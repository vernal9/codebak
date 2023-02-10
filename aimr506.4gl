# Prog. Version..: '5.30.24-17.04.13(00008)'     #
#
# Pattern name...: aimr506.4gl
# Descriptions...: 庫存有效狀況表
# Return code....:
# Date & Author..: 92/06/22 BY MAY
# Modify.........: No.FUN-510017 05/01/26 By Mandy 報表轉XML
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
#
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-750093 07/06/15 By zhoufeng 報表打印改為Crystal Reports
# Modify.........: No.TQC-780054 07/08/17 By sherry   to_date改為ifx語法 
# Modify.........: No.MOD-8A0233 08/10/27 By claire 計算有效日期l_day應為字串型態
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-CC0036 12/12/07 By xuxz 倉庫，庫位，批號增加開窗功能
# Modify.........: No.TQC-CC0038 12/12/07 By xuxz 報表中加入顯示倉庫名稱和庫位名稱
# Modify.........: No.TQC-CC0039 12/12/07 By xuxz 抓取img_file的資料時候當選擇僅為失效資料時候sql問題
# Modify.........: No.2108126776 20210812 By momo 只抓取庫存大於0
# Modify.........: No.23010029   20230210 By momo 增加 有效日img18 查詢  
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                          # Print condition RECORD
           wc      STRING,                 # Where condition   #TQC-630166
           a       LIKE type_file.chr1,    # Order by sequence #No.FUN-690026 VARCHAR(1)
           more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
 
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_str    STRING             #No.FUN-750093
DEFINE l_table  STRING             #No.FUN-750093
DEFINE g_sql    STRING             #No.FUN-750093
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
#No.FUN-750093 --start--
   LET g_sql="chr1.type_file.chr1,img01.img_file.img01,img02.img_file.img02,",
             "imd02.imd_file.imd02,",#TQC-CC0038 add
            #"img03.img_file.img03,img18.img_file.img18,num10.type_file.num10,", #MOD-8A0233 mark
             "img03.img_file.img03,ime03.ime_file.ime03,img18.img_file.img18,num10.type_file.chr8,",  #MOD-8A0233#TQC-CC0038 add ime03
             "ima02.ima_file.ima02,img04.img_file.img04,ima021.ima_file.ima021,",
             "ima021_1.ima_file.ima021"
   LET l_table = cl_prt_temptable('aimr506',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"#TQC-CC0038 add ,?,?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-750093 --end--
 
   IF g_sma.sma12 ='N' THEN
      CALL cl_err('','mfg1319',0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'         # If background job sw is off
      THEN CALL r506_tm()                    # Input print condition
   ELSE CALL aimr506()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r506_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE l_cmd          LIKE type_file.chr1000,#No.FUN-690026 VARCHAR(1000)
       p_row,p_col    LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 7  LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW r506_w AT p_row,p_col
        WITH FORM "cim/42f/aimr506"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL             # Default condition
   LET tm.a    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON img01,img02,img03,img04, img18
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
            IF INFIELD(img01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img01
               NEXT FIELD img01
            END IF
#No.FUN-570240 --end
        #TQC-CC0036--add--str
         IF INFIELD(img02) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_img021"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO img02
            NEXT FIELD img02
         END IF
         IF INFIELD(img03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_img03"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO img03
            NEXT FIELD img03
         END IF
         IF INFIELD(img04) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_img041"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO img04
            NEXT FIELD img04
         END IF
        #TQC-CC0036--add--end
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r506_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.more          # Condition
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a = ' ' OR tm.a NOT MATCHES '[YyNn]' THEN
            NEXT FIELD a
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r506_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file     #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr506'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr506','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,         #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr506',g_time,l_cmd)     # Execute cmd at later time
      END IF
      CLOSE WINDOW r506_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr506()
   ERROR ""
END WHILE
   CLOSE WINDOW r506_w
END FUNCTION
 
FUNCTION aimr506()
   DEFINE l_name     LIKE type_file.chr20,     # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0074
          l_sql      STRING,                   # RDSQL STATEMENT   #TQC-630166
          l_chr      LIKE type_file.chr1,      #No.FUN-690026 VARCHAR(1)
          l_za05     LIKE za_file.za05,        #No.FUN-690026 VARCHAR(40)
          sr         RECORD img01  LIKE img_file.img01,     #
                            img02  LIKE img_file.img02,
                            img03  LIKE img_file.img03,
                            img04  LIKE img_file.img04,
                            img05  LIKE img_file.img05,
                            img18  LIKE img_file.img18,
                            ima02  LIKE ima_file.ima02,
                            ima021 LIKE ima_file.ima021,
                            days   LIKE type_file.num10   #No.FUN-690026 INTEGER
                     END RECORD
   DEFINE l_chr1     LIKE type_file.chr1                  #No.FUN-750093
   DEFINE l_day      LIKE type_file.chr8                  #MOD-8A0233   modify num10 #No.FUN-750093
   DEFINE l_ima021   LIKE ima_file.ima021                 #No.FUN-750093
   DEFINE l_imd02    LIKE imd_file.imd02                  #TQC-CC0038 add
   DEFINE l_ime03    LIKE ime_file.ime03                  #TQC-CC0038 add

 
     CALL cl_del_data(l_table)                            #No.FUN-750093
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT img01, img02, img03, img04, img05, img18,",
                 "       ima02,ima021, ' ' ",
                 "  FROM img_file, ima_file",
                 " WHERE img01 = ima01",
                 "   AND img10 > 0 ",                      #20210812 add 只抓庫存大於0
                 "   AND ",tm.wc CLIPPED
 
    #TQC-CC0039 --mark--str
    #IF tm.a MATCHES '[Yy]' THEN   #只印庫存巳失效資料
    #   #LET l_sql = l_sql CLIPPED, " AND cast('",g_today,"' as datetime) > img18 "   #No.TQC-780054
    #    LET l_sql = l_sql CLIPPED, " AND cast('",g_today,"' as datetime) > img18 "            #No.TQC-780054
    #END IF
    #TQC-CC0039 --mark--end
     PREPARE r506_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r506_curs1 CURSOR FOR r506_prepare1
 
#     CALL cl_outnam('aimr506') RETURNING l_name        #No.FUN-750093
 
#     START REPORT r506_rep TO l_name
#
#     LET g_pageno = 0                                  #No.FUN-750093
     LET l_ima021 = ''                                  #No.FUN-750093
     FOREACH r506_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.img18 IS NULL OR sr.img18 = ' '  THEN
          LET sr.img18 = g_lastdat   #'9999/12/31'
       END IF
       #TQC-CC0039--add--20121206
       IF tm.a MATCHES '[Yy]' THEN#只印庫存巳失效資料
          IF sr.img18 > g_today THEN
             CONTINUE FOREACh
          END IF
       END IF
       #TQC-CC0039--add--20121206
       IF sr.img18 - g_today > 0 THEN #未失效
          CALL s_vdays(sr.img01,sr.img02,sr.img03,sr.img04) RETURNING sr.days
          LET sr.days = sr.days * (-1)
       END IF
#       OUTPUT TO REPORT r506_rep(sr.*)           #No.FUN-750093
#No.FUN-750093 --start--
      IF sr.img18 IS NULL OR sr.img18 = ' ' OR sr.img18 = g_lastdat THEN        
        LET l_day = '> 365'                                  
      ELSE                                                                      
         IF g_today - sr.img18 > 0 THEN  #已失效                                
             LET l_day = ' '                                  
         ELSE                                                                   
             LET l_day = sr.days USING '#######&'             
         END IF                                                                 
      END IF                 
                                              
      IF g_today - sr.img18 > 0 THEN                                            
          LET l_chr1 = '*'                                    
      ELSE                                                                      
          LET l_chr1 = ' '                                    
      END IF                                                            
     #TQC-CC0038--add--str
      LET l_imd02 = ' '
      SELECT imd02 INTO l_imd02 FROM imd_file
       WHERE imd01 = sr.img02
      IF SQLCA.sqlcode THEN LET l_imd02 = ' ' END IF
      LET l_ime03 = ' '
      SELECT ime03 INTO l_ime03 FROM ime_file
       WHERE ime01 = sr.img02
         AND ime02 = sr.img03
      IF SQLCA.sqlcode THEN LET l_ime03 = ' ' END IF
     #TQC-CC0038--add--end
      EXECUTE insert_prep USING l_chr1,sr.img01,sr.img02,l_imd02,sr.img03,l_ime03,sr.img18,#TQC-CC0038 add l_imd02,l_ime03
                                l_day,sr.ima02,sr.img04,sr.ima021,l_ima021
      LET l_ima021 = sr.ima021
#No.FUN-750093 --end--   
     END FOREACH
 
#     FINISH REPORT r506_rep                       #No.FUN-750093
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-750093
#No.FUN-750093
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'img01,img02,img03,img04')
          RETURNING tm.wc
     LET g_str = tm.wc
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('aimr506','aimr506',l_sql,g_str)
END FUNCTION
#No.FUN-750093 --start--mark
{REPORT r506_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr            RECORD img01  LIKE img_file.img01,     #
                               img02  LIKE img_file.img02,
                               img03  LIKE img_file.img03,
                               img04  LIKE img_file.img04,
                               img05  LIKE img_file.img05,
                               img18  LIKE img_file.img18,
                               ima02  LIKE ima_file.ima02,
                               ima021 LIKE ima_file.ima021,
                               days   LIKE type_file.num10   #No.FUN-690026 INTEGER
                        END RECORD,
         l_chr         LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.img01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
      PRINTX name=H2 g_x[37],g_x[38],g_x[39]
      PRINTX name=H3 g_x[40],g_x[41]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.img01
      LET l_sw = ' '
      IF g_today - sr.img18 > 0 THEN
          PRINTX name=D1 COLUMN g_c[31],'*';
      ELSE
          PRINTX name=D1 COLUMN g_c[31],' ';
      END IF
      LET l_sw = 'N'
      PRINTX name=D1 COLUMN g_c[32],sr.img01;
 
   ON EVERY ROW
     #IF l_sw != 'N' AND g_today - sr.img18 > 0 THEN
     #    PRINT '*';
     #ELSE
     #    PRINT ' ';
     #END IF
      PRINTX name=D1 COLUMN g_c[33],sr.img02,
                     COLUMN g_c[34],sr.img03,
                     COLUMN g_c[35],sr.img18;
      IF sr.img18 IS NULL OR sr.img18 = ' ' OR sr.img18 = g_lastdat THEN
         PRINTX name=D1 COLUMN g_c[36],'> 365'
      ELSE
         IF g_today - sr.img18 > 0 THEN  #已失效
             PRINTX name=D1 COLUMN g_c[36],' '
         ELSE
             PRINTX name=D1 COLUMN g_c[36],sr.days USING '#######&'
         END IF
      END IF
      IF l_sw = 'N' THEN
         PRINTX name=D2 COLUMN g_c[37],' ',
                        COLUMN g_c[38],sr.ima02,
                        COLUMN g_c[39],sr.img04
         PRINTX name=D3 COLUMN g_c[40],' ',
                        COLUMN g_c[41],sr.ima021
      ELSE
         PRINTX name=D2 COLUMN g_c[37],' ',
                        COLUMN g_c[38],' ',
                        COLUMN g_c[39],sr.img04
      END IF
      LET l_sw = 'Y'
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash[1,g_len]
       #END TQC-630166
       #       IF tm.wc[001,070] > ' ' THEN			# for 80
 #	         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
 #             IF tm.wc[071,140] > ' ' THEN
 # 	         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
 #             IF tm.wc[141,210] > ' ' THEN
 # 	         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
 #             IF tm.wc[211,280] > ' ' THEN
 # 	         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             IF tm.wc[001,120] > ' ' THEN			# for 132
#		 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
       CALL cl_prt_pos_wc(tm.wc)
       #END TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-750093 --end--
