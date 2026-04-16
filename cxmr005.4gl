# Prog. Version..: '5.30.24-17.04.13(00000)'     #
#
# Pattern name...: cxmr005.4gl
# Descriptions...: 訂單交期調整清單
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
    CALL cxmr005_tm(0,0)
 END IF
END MAIN

FUNCTION cxmr005_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,      
       l_cmd          LIKE type_file.chr1000      
 
   LET p_row = 4 LET p_col = 13
 
   OPEN WINDOW cxmr005_w AT p_row,p_col WITH FORM "cxm/42f/cxmr005"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm2.s1  = '1'
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
   CONSTRUCT BY NAME tm.wc ON oeb04,oeb01,oea03,tc_oeqdate,tc_oeq04b,tc_oeq04a
 
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
        WHEN INFIELD(oea03)
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_occ"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO oea03
           NEXT FIELD oea03
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
      LET INT_FLAG = 0 CLOSE WINDOW cxmr005_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW cxmr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL cxmr005()
   ERROR ""
END WHILE
   CLOSE WINDOW cxmr005_w
END FUNCTION

FUNCTION cxmr005()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,       
          l_xml     LIKE aab_file.aab01,          
          l_order   ARRAY[5] OF LIKE ima_file.ima01,                
          sr        RECORD order1    LIKE ima_file.ima01,        
                           order2    LIKE ima_file.ima01,        
                           order3    LIKE ima_file.ima01, 
                           oea03     LIKE oea_file.oea03,
                           oea032    LIKE oea_file.oea032,
                           oea10     LIKE oea_file.oea10,
                           oea01     LIKE oea_file.oea01,
                           oeb03     LIKE oeb_file.oeb03,
                           oeb04     LIKE oeb_file.oeb04,
                           oeb12     LIKE oeb_file.oeb12,
                           ima02     LIKE ima_file.ima02,
                           ima021    LIKE ima_file.ima021,
                           tc_oeq08  LIKE tc_oeq_file.tc_oeq08,
                           tc_oeq04b LIKE tc_oeq_file.tc_oeq04b,
                           tc_oeq04a LIKE tc_oeq_file.tc_oeq04a,
                           tc_oeq06  LIKE tc_oeq_file.tc_oeq06,
                           tc_oeqdate LIKE type_file.chr50
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
 
     LET l_sql = "SELECT '','','',",
                 "       oea03,oea032,oea10,oea01,oeb03,oeb04,oeb12-oeb24,ima02,ima021,",   
                 "       tc_oeq08,tc_oeq04b,tc_oeq04a,azf03||tc_oeq06,",
                 "       to_char(tc_oeqdate,'yyyy/mm/dd HH24:MI:SS')",
                 "  FROM tc_oeq_file ",
                 "  LEFT JOIN azf_file ON azf01=tc_oeq05 AND azf02='2' AND azf09='C' ",
                 "  LEFT JOIN oeb_file ON tc_oeq01=oeb01 AND tc_oeq03=oeb03 ",
                 "  LEFT JOIN ima_file ON oeb04 = ima01 ",
                 "  LEFT JOIN oea_file ON oea01 = tc_oeq01 ",
                 " WHERE oeb12 > oeb24 AND ",tm.wc,
                 "   AND tc_oeq02= (select max(tc_oeq02) FROM tc_oeq_file WHERE tc_oeq01=oeb01 AND tc_oeq03=oeb03) ",
                 "   AND oeb70 = 'N' ",
                 " ORDER BY oea03 "
 
     PREPARE cxmr005_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
     END IF
     DECLARE cxmr005_curs1 CURSOR FOR cxmr005_prepare1
 
     CALL cl_outnam('cxmr005') RETURNING l_name
 
     START REPORT cxmr005_rep TO l_name
 
     LET g_pageno = 0
     FOREACH cxmr005_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oeb04
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oea03
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.tc_oeq04b
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.tc_oeq04a
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       OUTPUT TO REPORT cxmr005_rep(sr.*)
     END FOREACH
 
     FINISH REPORT cxmr005_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT cxmr005_rep(sr)
DEFINE l_last_sw   LIKE type_file.chr1,       
       sr        RECORD order1    LIKE ima_file.ima01,
                        order2    LIKE ima_file.ima01,
                        order3    LIKE ima_file.ima01,
                        oea03     LIKE oea_file.oea03,
                        oea032    LIKE oea_file.oea032,
                        oea10     LIKE oea_file.oea10,
                        oea01     LIKE oea_file.oea01,
                        oeb03     LIKE oeb_file.oeb03,
                        oeb04     LIKE oeb_file.oeb04,
                        oeb12     LIKE oeb_file.oeb12,
                        ima02     LIKE ima_file.ima02,
                        ima021    LIKE ima_file.ima021,
                        tc_oeq08  LIKE tc_oeq_file.tc_oeq08,
                        tc_oeq04b LIKE tc_oeq_file.tc_oeq04b,
                        tc_oeq04a LIKE tc_oeq_file.tc_oeq04a,
                        tc_oeq06  LIKE tc_oeq_file.tc_oeq06,
                        tc_oeqdate LIKE type_file.chr50
                  END RECORD ,
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
      PRINT g_x[6],g_x[7],g_x[8],g_x[17],g_x[9],g_x[10],g_x[11],g_x[12],g_x[13],g_x[14],g_x[15],g_x[16] 
      PRINT g_dash1                              
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
      PRINT COLUMN g_c[6],sr.oea032,
            COLUMN g_c[7],sr.oea10,  
            COLUMN g_c[8],sr.oea01, 
            COLUMN g_c[17],sr.oeb03, 
            COLUMN g_c[9],sr.oeb04,   
            COLUMN g_c[10],sr.ima02,
            COLUMN g_c[11],sr.ima021,
            COLUMN g_c[12],sr.oeb12 USING '###',
            COLUMN g_c[13],sr.tc_oeq04b,
            COLUMN g_c[14],sr.tc_oeq04a,
            COLUMN g_c[15],sr.tc_oeq06,
            COLUMN g_c[16],sr.tc_oeqdate
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

    DEFINE l_oea03      LIKE oea_file.oea03
    DEFINE l_oea032     LIKE oea_file.oea032
    DEFINE l_occ55      LIKE occ_file.occ55
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
    DEFINE l_oce03      LIKE oce_file.oce03
    DEFINE l_oce05      LIKE oce_file.oce05
    DEFINE l_gen02      LIKE gen_file.gen02
    DEFINE l_gen06      LIKE gen_file.gen06
    DEFINE l_name       LIKE type_file.chr20
    DEFINE sr RECORD
              oea10     LIKE oea_file.oea10,
              oea01     LIKE oea_file.oea01,
              oeb04     LIKE oeb_file.oeb04,
              oeb12     LIKE oeb_file.oeb12,
              ima02     LIKE ima_file.ima02,
              ima021    LIKE ima_file.ima021,
              tc_oeq08  LIKE tc_oeq_file.tc_oeq08,
              tc_oeq04b LIKE tc_oeq_file.tc_oeq04b,
              tc_oeq04a LIKE tc_oeq_file.tc_oeq04a,
              tc_aag02  LIKE tc_aag_file.tc_aag02,
              tc_aag04  LIKE tc_aag_file.tc_aag04
              END RECORD


    #-- 依客戶處理
    LET l_sql = "SELECT oea03,oea032,occ55 FROM tc_oeq_file,oea_file,occ_file,tc_aag_file ",
                " WHERE tc_oeq01=oea01 AND occ01 = oea03 AND tc_oeq04a>tc_oeq04b ",
                "   AND tc_aag01=tc_oeq05 AND ",g_wc2 ,
                " UNION ",
                "SELECT oea03,oea032,occ55 FROM tc_oeq_file,oea_file,oeb_file,occ_file,tc_aag_file",
                " WHERE oea01 = oeb01 AND tc_oeq01=oeb01 AND tc_oeq03=oeb03",
                "   AND oea03=occ01 AND oeb70='N' AND oeb12>oeb24 ",
                "   AND tc_aag02='Y' AND tc_oeq05=tc_aag01 ",
                "   AND tc_oeq02= (SELECT MAX(tc_oeq02) FROM tc_oeq_file WHERE tc_oeq01=oeb01 AND tc_oeq03=oeb03) ",
                "GROUP BY oea03,oea032,occ55 ",
                "ORDER BY occ55"
    PREPARE q_precur FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('P1:',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    DECLARE q_cur CURSOR FOR q_precur
    FOREACH q_cur INTO l_oea03,l_oea032,l_occ55
       INITIALIZE sr.* TO NULL
       RUN "echo '<html><body>' >> " || ls_context_file   #HTML 字串初始化
     
       IF l_occ55 <> '0' THEN
          LET l_subject = ''
          LET l_body= ''
       END IF
       IF l_occ55 ='0' AND NOT cl_null(l_subject_0) THEN 
       ELSE
          CALL cs_gen_mail(g_prog,l_occ55) RETURNING l_subject,l_body #zaa_file 取主旨與信件內文
          IF l_occ55 = '0' THEN
             LET l_subject_0 = l_subject
             LET l_body_0 = l_body
          END IF
       END IF

        LET ls_unix_cmd = "echo '' > " || ls_context_file
        LET ls_temp_path = FGL_GETENV("TEMPDIR")
        LET ls_context_file =ls_temp_path CLIPPED || "/late_order" || ".htm"
        LET l_body = l_body || "</tr>" 
        LET ls_unix_cmd = "echo '" || l_body || "' > " || ls_context_file
        RUN ls_unix_cmd

        -- 遲交明細
        LET l_sql = "SELECT oea10,oea01||LPAD(oeb03,3,'0'),oeb04,oeb12-oeb24,ima02,ima021,",
                    "       tc_oeq08,tc_oeq04b,tc_oeq04a,tc_aag02,tc_aag04 ",
                    " FROM tc_oeq_file ",
                    " INNER JOIN tc_aag_file ON tc_oeq05 = tc_aag01 AND tc_aag03='",l_occ55,"' ",
                    " LEFT JOIN oea_file ON oea01 = tc_oeq01 ",
                    " LEFT JOIN oeb_file ON oeb03 = tc_oeq03 AND oeb01=tc_oeq01 ",
                    " LEFT JOIN ima_file ON ima01 = oeb04 ",
                    " LEFT JOIN gen_file ON gen01 = oea14 ",
                    " WHERE oeb12>oeb24 AND oeb70='N' ",
                    "   AND tc_oeq02= (SELECT MAX(tc_oeq02) FROM tc_oeq_file WHERE tc_oeq01=oeb01 AND tc_oeq03=oeb03) ",
                   "   AND ",g_wc , "  ", 
                   # "   AND (",g_wc , " OR tc_aag02='Y' )", 
                    "   AND oea03 = '",l_oea03,"'"
        PREPARE q_oebcur FROM l_sql
        DECLARE q_oeb CURSOR FOR q_oebcur
        FOREACH q_oeb INTO sr.*
           IF cl_null(sr.oea01) THEN EXIT FOREACH END IF

           IF cl_null(sr.tc_oeq08) THEN 
              LET sr.tc_oeq08 = sr.oeb12
           END IF


           IF sr.tc_aag02 = 'Y' THEN
              LET sr.tc_oeq04a = ''
           END IF

           LET ls_unix_cmd =
               "echo '<tr><td>",sr.oea10,"</td>" ||
               "<td>",sr.oea01,"</td>" ||
               "<td>",sr.oeb04 , "</td>" ||
               "<td>",sr.ima02 , "</td> " ||
               "<td>",sr.ima021 ,"</td> " ||
               "<td>",sr.tc_oeq08, "</td> " ||
               "<td>",sr.tc_oeq04b,"</td> " ||
               "<td>",sr.tc_oeq04a,"</td> " ||
               "<td>",sr.tc_aag04,"</td>" ||
               "</tr>' >> " || ls_context_file
            RUN ls_unix_cmd
        END FOREACH

        IF cl_null(sr.oea01) THEN CONTINUE FOREACH END IF
        -- HTML 結尾
        RUN "echo '</table></body></html>' >> " || ls_context_file

        #-------------------------------------------------
        # 2. 將 HTML 內容寫成實體檔案（RUN echo）
        #-------------------------------------------------
        LET ls_context_file =ls_temp_path CLIPPED || "/late_order.htm"

        LET g_xml.body       = ls_context_file
 
        #-- Email
   
        LET g_xml.recipient = ''

        ##---業務
        DECLARE l_gen06 CURSOR FOR
         SELECT DISTINCT gen02,gen06 FROM gen_file 
          WHERE genacti='Y' AND EXISTS (SELECT 1 FROM oea_file WHERE oea03=l_oea03 AND oea14=gen01)
         UNION
         SELECT oce03,oce05 FROM oce_file WHERE oce01=l_oea03 AND oce05 IS NOT NULL AND oce02='TOYO' 
        FOREACH l_gen06 INTO l_gen02,l_gen06
          LET g_xml.recipient = g_xml.recipient CLIPPED ,";",l_gen06 CLIPPED,":",l_gen02 CLIPPED
        END FOREACH

        ##---客戶聯絡人
        IF g_cus='Y' THEN
           DECLARE l_oce05 CURSOR FOR 
             SELECT oce03,oce05 FROM oce_file WHERE oce01=l_oea03 AND oce05 IS NOT NULL AND oce02<>'電子發票'
           FOREACH l_oce05 INTO l_oce03,l_oce05
             LET g_xml.recipient = g_xml.recipient CLIPPED ,";",l_oce05 CLIPPED,":",l_oce03 CLIPPED 
           END FOREACH
        END IF

        ##---p_cron 設定MAIL
        #LET g_xml.cc = '' 
        #SELECT gdf06 INTO l_gdf06 FROM gdf_file
        # WHERE gdf01='cxmr005' 
        #LET g_xml.cc = l_gdf06

        ##---p_cron 設定MAIL
        LET g_xml.cc = FGL_GETENV("MAIL_CC")
        LET g_xml.bcc = FGL_GETENV("MAIL_BCC")
        LET g_rlang = l_occ55
        ##---主旨
        LET g_xml.subject = l_subject,"-",l_oea032 CLIPPED 
        -- 寄信
        RUN "cat " || ls_context_file || " > /dev/null"
        CALL cl_jmail()
        RUN "sleep 5"
        #RUN "rm -f " || ls_context_file
        -- 寫防重寄紀錄
        #INSERT INTO mail_log VALUES (TODAY, v_cust, "LATEORD")

    END FOREACH
        
END FUNCTION

