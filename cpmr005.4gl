# Prog. Version..: '5.30.24-17.04.13(00000)'     #
#
# Pattern name...: cpmr005.4gl
# Descriptions...: 採購單未交清單-依供應商匯整
# Date & Author..: 2026/01/06 By momo


IMPORT util
IMPORT os      
IMPORT com    

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

##----p_cron USE 
DEFINE g_wc  STRING
DEFINE g_wc2 STRING
DEFINE g_cus STRING

##---QBE USE
DEFINE tm  RECORD                # Print condition RECORD
       wc  STRING,               # Where condition
       s      LIKE type_file.chr3,          # Order by sequence
       t      LIKE type_file.chr3,          # Eject sw
       more   LIKE type_file.chr1           # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       
DEFINE   g_head1         STRING


MAIN
 OPTIONS
   INPUT NO WRAP
 DEFER INTERRUPT 
 
 IF (NOT cl_user()) THEN
      EXIT PROGRAM
 END IF

 IF (NOT cl_setup("CXM")) THEN
    EXIT PROGRAM
 END IF

 CALL cl_used(g_prog,g_time,1) RETURNING g_time
 ## ARV_VAL 皆在 p_cron 設定 
 LET g_wc = ARG_VAL(1)           #明細條件
 LET g_cus = ARG_VAL(2)          #寄送客戶否
 LET g_wc2 = ARG_VAL(3)          #客戶取得條件

 IF NOT cl_null(g_wc) THEN
    CALL send_late_order_mail()
 ELSE
    CALL cpmr005_tm(0,0)
 END IF
END MAIN

FUNCTION cpmr005_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,      
       l_cmd          LIKE type_file.chr1000      
 
   LET p_row = 4 LET p_col = 13
 
   OPEN WINDOW cpmr005_w AT p_row,p_col WITH FORM "apm/42f/apmr506"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm2.s1  = '3'
   LET tm2.s2  = '2'
   LET tm2.s3  = '3'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04,pmm12,pmm13,pmn04,pmn16
 
   BEFORE CONSTRUCT
     CALL cl_qbe_init()
 
     ON ACTION locale
        LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   
        EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION about        
        CALL cl_about()     
 
     ON ACTION help         
        CALL cl_show_help() 
 
     ON ACTION controlg     
        CALL cl_cmdask()    
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
 

     ON ACTION CONTROLP
        CASE
        WHEN INFIELD(pmm01)
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_pmm602"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO pmm01
           NEXT FIELD pmm01
        WHEN INFIELD(pmm12)
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_gen"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO pmm12
           NEXT FIELD pmm12
        WHEN INFIELD(pmm13)
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_gem"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO pmm13
           NEXT FIELD pmm13
        WHEN INFIELD(pmn04)
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO pmn04
           NEXT FIELD pmn04
        END CASE
     ON ACTION qbe_select
        CALL cl_qbe_select()
 
  END CONSTRUCT

  IF g_action_choice = "locale" THEN
     LET g_action_choice = ""
     CALL cl_dynamic_locale()
     CONTINUE WHILE
  END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW cpmr005_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
 
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
     INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more  WITHOUT DEFAULTS #HELP 1
     BEFORE INPUT
       CALL cl_qbe_display_condition(lc_qbe_sn)
 
     AFTER FIELD more
       IF tm.more = 'Y'
          THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
          END IF
 
     AFTER INPUT
       LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
       LET tm.t = tm2.t1,tm2.t2,tm2.t3
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help         
        CALL cl_show_help() 
 
     ON ACTION controlg      
        CALL cl_cmdask()     
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT INPUT
 
     ON ACTION qbe_save
        CALL cl_qbe_save()
 
    END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW cpmr005_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL cpmr005()
   ERROR ""
END WHILE
   CLOSE WINDOW cpmr005_w
END FUNCTION

FUNCTION cpmr005()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,       
          l_xml     LIKE aab_file.aab01,          
          l_order   ARRAY[5] OF LIKE ima_file.ima01,                
          sr        RECORD order1    LIKE pmm_file.pmm01,        
                           order2    LIKE pmm_file.pmm01,        
                           order3    LIKE pmm_file.pmm01, 
                           pmn01     LIKE pmn_file.pmn01,
                           pmn02     LIKE pmn_file.pmn02,
                           pmn04     LIKE pmn_file.pmn04,
                           ima02     LIKE ima_file.ima02,
                           pmn041    LIKE pmn_file.pmn041,
                           pmn07     LIKE pmn_file.pmn07,
                           pmn20     LIKE pmn_file.pmn20,
                           pmn33     LIKE pmn_file.pmn33,
                           delay     LIKE type_file.num5,
                           gen02     LIKE gen_file.gen02,
                           pmm12     LIKE pmm_file.pmm12,
                           pmm13     LIKE pmm_file.pmm13
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
 
     LET l_sql = "SELECT '','','',",
                 "   pmn01,pmn02,pmn04,ima02,pmn041,pmn07,pmn20-pmn50+pmn55+pmn58,",
                 "   pmn33,pmn33-sysdate,gen02,pmm12,pmm13 ",
                 " FROM pmm_file ",
                 " LEFT JOIN pmn_file ON pmn01=pmm01 ",
                 " LEFT JOIN pmk_file ON pmn24=pmk01 ",
                 " LEFT JOIN ima_file ON ima01=pmn04 ",
                 " LEFT JOIN gen_file ON gen01=pmk12 ",
                 " WHERE pmn20-pmn50+pmn55+pmn58 >=1 ",
                 "   AND pmn16 >= '1' AND pmn16 <= '2' ",
                 "   AND pmm18='Y' ",
                 "   AND ",tm.wc , "  "
 
     PREPARE cpmr005_prepare11 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
     END IF
     DECLARE cpmr005_curs11 CURSOR FOR cpmr005_prepare11
 
     CALL cl_outnam('cpmr005') RETURNING l_name
 
     START REPORT cpmr005_rep TO l_name
 
     LET g_pageno = 0
     FOREACH cpmr005_curs11 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pmn01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pmn33
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pmm12
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pmm13
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       OUTPUT TO REPORT cpmr005_rep(sr.*)
     END FOREACH
 
     FINISH REPORT cpmr005_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT cpmr005_rep(sr)
DEFINE l_last_sw   LIKE type_file.chr1,      
       sr          RECORD order1    LIKE pmm_file.pmm01,
                          order2    LIKE pmm_file.pmm01,
                          order3    LIKE pmm_file.pmm01,
                          pmn01     LIKE pmn_file.pmn01,
                          pmn02     LIKE pmn_file.pmn02,
                          pmn04     LIKE pmn_file.pmn04,
                          ima02     LIKE ima_file.ima02,
                          pmn041    LIKE pmn_file.pmn041,
                          pmn07     LIKE pmn_file.pmn07,
                          pmn20     LIKE pmn_file.pmn20,
                          pmn33     LIKE pmn_file.pmn33,
                          delay     LIKE type_file.num5,
                          gen02     LIKE gen_file.gen02,
                          pmm12     LIKE pmm_file.pmm12,
                          pmm13     LIKE pmm_file.pmm13
                    END RECORD, 
        l_chr        LIKE type_file.chr1       
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED  
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
 
      PRINT g_dash[1,g_len]                              
      PRINT g_x[7],g_x[8],g_x[17],g_x[9],g_x[10],g_x[11],g_x[13],g_x[12],g_x[14],g_x[15],g_x[17]
      PRINT g_dash1                              
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
      PRINT COLUMN g_c[7],sr.pmn01,  
            COLUMN g_c[8],sr.pmn02, 
            COLUMN g_c[9],sr.pmn04,   
            COLUMN g_c[10],sr.ima02,
            COLUMN g_c[11],sr.pmn041,
            COLUMN g_c[12],sr.pmn07,
            COLUMN g_c[13],sr.pmn20 USING '###',
            COLUMN g_c[14],sr.pmn33,
            COLUMN g_c[15],sr.delay,
            COLUMN g_c[17],sr.gen02
##
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         PRINT g_dash1                         
      END IF
      PRINT g_dash[1,g_len]                            
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]                       
         PRINT g_x[1] CLIPPED,
               COLUMN g_len-9, g_x[2] CLIPPED  
      ELSE
         SKIP 2 LINE
      END IF
END REPORT

FUNCTION send_late_order_mail()

    DEFINE l_pmm09      LIKE pmm_file.pmm09  #供應商編號
    DEFINE l_pmc03      LIKE pmc_file.pmc03  #供應商簡稱
    DEFINE l_pmc911     LIKE pmc_file.pmc911 #慣用語言
    DEFINE l_gdf06      LIKE gdf_file.gdf06
    DEFINE v_cnt        INTEGER

    DEFINE l_sql        STRING
    DEFINE l_body_0     LIKE zaa_file.zaa08  #繁中
    DEFINE l_subject_0  LIKE zaa_file.zaa08  #繁中
    DEFINE l_subject    LIKE zaa_file.zaa08  
    DEFINE l_body       LIKE zaa_file.zaa08
    DEFINE l_title      LIKE zaa_file.zaa08
    DEFINE l_content    LIKE zaa_file.zaa08
    DEFINE ls_temp_path STRING
    DEFINE ls_context_file  STRING
    DEFINE ls_unix_cmd      STRING
    DEFINE l_pmd02      LIKE pmd_file.pmd02
    DEFINE l_pmd07      LIKE pmd_file.pmd07
    DEFINE l_gen02      LIKE gen_file.gen02
    DEFINE l_gen06      LIKE gen_file.gen06
    DEFINE l_name       LIKE type_file.chr20
    DEFINE sr RECORD
              pmn01     LIKE pmn_file.pmn01,
              pmn02     LIKE pmn_file.pmn02,
              pmn04     LIKE pmn_file.pmn04,
              ima02     LIKE ima_file.ima02,
              pmn041    LIKE pmn_file.pmn041,
              pmn20     LIKE pmn_file.pmn20,
              pmn07     LIKE pmn_file.pmn07,
              pmn33     LIKE pmn_file.pmn33,
              delay     LIKE type_file.num5
              END RECORD


    #-- 依供應商處理
    LET l_sql = "SELECT pmc01,pmc03,pmc911 ",
                "  FROM pmc_file,pmm_file ",
                "  LEFT JOIN pmn_file ON pmn01=pmm01 ",
                " WHERE pmm09=pmc01 AND pmm18='Y' ",
                "   AND pmn16 >= '1' AND pmn16 <= '2' ",
                "   AND pmn20-pmn50+pmn55+pmn58 >= 1 ",
                "   AND ",g_wc ,
                "GROUP BY pmc01,pmc03,pmc911 ",
                "ORDER BY pmc911"

    PREPARE q_precur FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('P1:',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    DECLARE q_cur CURSOR FOR q_precur
    FOREACH q_cur INTO l_pmm09,l_pmc03,l_pmc911
       INITIALIZE sr.* TO NULL
       RUN "echo '<html><body>' >> " || ls_context_file   #HTML 字串初始化
     
       IF l_pmc911 <> '0' THEN
          LET l_subject = ''
          LET l_body= ''
       END IF
       IF l_pmc911 ='0' AND NOT cl_null(l_subject_0) THEN 
       ELSE
          CALL cs_gen_mail(g_prog,l_pmc911) RETURNING l_subject,l_body #zaa_file 取主旨與信件內文
          IF l_pmc911 = '0' THEN
             LET l_subject_0 = l_subject
             LET l_body_0 = l_body
          END IF
       END IF

        LET ls_unix_cmd = "echo '' > " || ls_context_file
        LET ls_temp_path = FGL_GETENV("TEMPDIR")
        LET ls_context_file =ls_temp_path CLIPPED || "/late_po" || ".htm"
        LET l_body = l_body || "</tr>" 
        LET ls_unix_cmd = "echo '" || l_body || "' > " || ls_context_file
        RUN ls_unix_cmd

        -- 未交明細
        LET l_sql = "SELECT pmn01,pmn02,pmn04,ima02,pmn041,pmn20-pmn50+pmn55+pmn58,",
                    "       pmn07,pmn33,sysdate-pmn33,gen02 ",
                    " FROM pmm_file ",
                    " LEFT JOIN pmn_file ON pmn01=pmm01 ",
                    " LEFT JOIN pmk_file ON pmn24=pmk01 ",
                    " LEFT JOIN ima_file ON ima01=pmn04 ",
                    " LEFT JOIN gen_file ON gen01=pmk12 ",
                    " WHERE pmn20-pmn50+pmn55+pmn58 >=1 ",
                    "   AND pmn16 >= '1' AND pmn16 <= '2' ",
                    "   AND pmm18='Y' ",
                    "   AND ",g_wc , "  ", 
                    "   AND pmm09 = '",l_pmm09,"'"

        PREPARE q_pmncur FROM l_sql
        DECLARE q_pmn CURSOR FOR q_pmncur
        FOREACH q_pmn INTO sr.*,l_gen02
           IF cl_null(sr.pmn01) THEN EXIT FOREACH END IF
           IF sr.pmn33 < g_today THEN
              LET sr.delay = sr.pmn33 - g_today
           ELSE
              LET sr.delay = '-'
           END IF
           LET ls_unix_cmd =
               "echo '<tr><td>",sr.pmn01,"</td>" ||
               "<td>",sr.pmn02,"</td>" ||
               "<td>",sr.pmn04 , "</td>" ||
               "<td>",sr.ima02 , "</td> " ||
               "<td>",sr.pmn041 ,"</td> " ||
               "<td>",sr.pmn20, "</td> " ||
               "<td>",sr.pmn07,"</td> " ||
               "<td>",sr.pmn33,"</td> " ||
               "<td>",sr.delay,"</td>" ||
               "<td>","" ,"</td>" ||
               "<td>",l_gen02,"</td>" ||
               "</tr>' >> " || ls_context_file
            RUN ls_unix_cmd
        END FOREACH

        IF cl_null(sr.pmn01) THEN CONTINUE FOREACH END IF
        -- HTML 結尾
        RUN "echo '</table></body></html>' >> " || ls_context_file

        #-------------------------------------------------
        # 2. 將 HTML 內容寫成實體檔案（RUN echo）
        #-------------------------------------------------
        LET ls_context_file =ls_temp_path CLIPPED || "/late_po.htm"

        LET g_xml.body       = ls_context_file
 
        #-- Email
   
        LET g_xml.recipient = ''

        ##---請購單位
        LET l_sql = "SELECT DISTINCT gen02,gen06 FROM gen_file ",
                    " WHERE genacti='Y' ",
                    "  AND EXISTS (SELECT 1 FROM pmm_file,pmn_file,pmk_file ",
                    "               WHERE pmm01=pmn01 AND pmn24=pmk01 ",
                    "                 AND (pmk12=gen01 OR pmkoriu=gen01 OR pmm12=gen01) ",
                    "                 AND pmn20-pmn50+pmn55+pmn58 >=1 ",
                    "                 AND pmn16 >= '1' AND pmn16 <= '2' ",
                    "                 AND pmm18='Y' ",
                    "                 AND ",g_wc , "  ",
                    "                 AND pmm09 = '",l_pmm09,"' )"
        PREPARE q_gen06 FROM l_sql
        DECLARE l_gen06 CURSOR FOR q_gen06
        FOREACH l_gen06 INTO l_gen02,l_gen06
          LET g_xml.recipient = g_xml.recipient CLIPPED ,";",l_gen06 CLIPPED,":",l_gen02 CLIPPED
        END FOREACH
       
        ##---供應商聯絡人
        IF g_cus='Y' THEN
           DECLARE l_pmd07 CURSOR FOR 
             SELECT pmd02,pmd07 FROM pmd_file WHERE pmd01=l_pmm09 AND pmd08='Y'
           FOREACH l_pmd07 INTO l_pmd02,l_pmd07
            #LET g_xml.recipient = g_xml.recipient CLIPPED ,";",l_pmd02 CLIPPED,":",l_pmd07 CLIPPED  #20260209
             LET g_xml.recipient = g_xml.recipient CLIPPED ,";",l_pmd07 CLIPPED                      #20260209
           END FOREACH
        END IF

        ##---p_cron 設定MAIL
        LET g_xml.cc = FGL_GETENV("MAIL_CC")
        LET g_xml.bcc = FGL_GETENV("MAIL_BCC")
        ##---主旨
        LET g_xml.subject = l_subject,"-",l_pmm09,"(",l_pmc03,")" CLIPPED 
        -- 寄信
        RUN "cat " || ls_context_file || " > /dev/null"
        CALL cl_jmail()
        RUN "sleep 5"
        #RUN "rm -f " || ls_context_file

    END FOREACH
        
END FUNCTION

