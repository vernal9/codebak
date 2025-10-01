# Prog. Version..: '5.30.24-17.04.13(00009)'     #
#
# Pattern name...: csfr011.4gl
# Descriptions...: 未結案工單備料明細表
# Date & Author..: 2021/05/07  By  momo

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,      
           more    LIKE type_file.chr1    
           END RECORD
DEFINE   g_i          LIKE type_file.num5           #count/index for any purpose      
DEFINE   l_table      STRING                         
DEFINE   g_str        STRING                           
DEFINE   g_sql        STRING                       
    
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_sql = "sfb01.sfb_file.sfb01,",       #工單編號
               "ta_sfb01.sfb_file.ta_sfb01,", #訂單單號序號
               "oea032.oea_file.oea032,",     #帳款客戶名稱
               "occ02.oea_file.oea032,",      #送貨客戶名稱
               "sfb05.sfb_file.sfb05,",       #生產料件
               "aima02.ima_file.ima02,",      #品名
               "aima021.ima_file.ima021,",    #規格
               "sfb08.sfb_file.sfb08,",       #生產數量
               "sfb09.sfb_file.sfb09,",       #完工數量
               "sfb12.sfb_file.sfb12,",       #報廢數量
               "sfb13.sfb_file.sfb13,",       #預計開工日
               "ima06.ima_file.ima06,",       #備料分群碼
               "sfa03.sfa_file.sfa03,",       #發料料號
               "bima02.ima_file.ima02,",      #備料品名
               "bima021.ima_file.ima021,",    #備料規格
               "sfa05.sfa_file.sfa05,",       #應發數量
               "sfa06.sfa_file.sfa06,",       #已發數量
               "sfa16.sfa_file.sfa16,",       #標準單位用量
               "sfa29.sfa_file.sfa29"         #上階料號
              
   LET l_table = cl_prt_temptable('csfr011',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,? )"              
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN                                                                                                                  
      CALL cl_err('insert_prep:',status,1) 
      EXIT PROGRAM                                                                            
   END IF   
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_xml.subject = ARG_VAL(11)     
   LET g_rpt_name = ARG_VAL(12)  
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r011_tm(0,0)
      ELSE CALL r011()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION r011_tm(p_row,p_col)

DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,          
       l_cmd          LIKE type_file.chr1000        
 
   LET p_row = 4 LET p_col =20
 
   OPEN WINDOW r011_w AT p_row,p_col
        WITH FORM "csf/42f/csfr011"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON ima06,sfa03,sfb01,ta_sfb01,sfb05,sfb13
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   
          EXIT CONSTRUCT

       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(sfa03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfa03
                NEXT FIELD sfa03
 
              WHEN INFIELD(sfb01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb9"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb01
                NEXT FIELD sfb01
 
              WHEN INFIELD(sfb05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb05
                NEXT FIELD sfb05

              WHEN INFIELD(ima06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imz"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima06
                NEXT FIELD ima06
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION CONTROLG 
          CALL cl_cmdask()  
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
 
       ON ACTION qbe_select
          CALL cl_qbe_select()
 
     END CONSTRUCT
 
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF tm.wc =' 1=1' THEN CONTINUE WHILE END IF
 
     INPUT BY NAME tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
 
        AFTER FIELD more
           IF tm.more = 'Y' THEN
              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
              RETURNING g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies
           END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        AFTER INPUT
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT

        ON ACTION qbe_save
           CALL cl_qbe_save()
 
     END INPUT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file
               WHERE zz01='csfr011'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('csfr011','9031',1)
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           " '",g_rlang CLIPPED,"'",
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc CLIPPED,"'",
                           " '",g_rep_user CLIPPED,"'",           
                           " '",g_rep_clas CLIPPED,"'",           
                           " '",g_template CLIPPED,"'",           
                           " '",g_xml.subject CLIPPED,"'",                           
                           " '",g_rpt_name CLIPPED,"'"            
 
           CALL cl_cmdat('csfr011',g_time,l_cmd)
        END IF
        CLOSE WINDOW r011_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
 
     CALL cl_wait()
     CALL r011()
     ERROR ""
 
   END WHILE
 
   CLOSE WINDOW r011_w
END FUNCTION
 
FUNCTION r011()
   DEFINE l_name    LIKE type_file.chr20,                
          l_sql     STRING,                              
          l_chr     LIKE type_file.chr1,                 
          l_cnt     LIKE type_file.num5,                 
          l_oea04   LIKE oea_file.oea04,
          sr        RECORD
                    sfb01    LIKE sfb_file.sfb01,
                    ta_sfb01 LIKE sfb_file.ta_sfb01,
                    oea032   LIKE oea_file.oea032,
                    occ02    LIKE occ_file.occ02,
                    sfb05    LIKE sfb_file.sfb05,
                    aima02   LIKE ima_file.ima02,
                    aima021  LIKE ima_file.ima021,
                    sfb08    LIKE sfb_file.sfb08,
                    sfb09    LIKE sfb_file.sfb09,
                    sfb012   LIKE sfb_file.sfb12,
                    sfb013   LIKE sfb_file.sfb13,
                    ima06    LIKE ima_file.ima06,
                    sfa03    LIKE sfa_file.sfa03,
                    bima02   LIKE ima_file.ima02,
                    bima021  LIKE ima_file.ima021,
                    sfa05    LIKE sfa_file.sfa05,
                    sfa06    LIKE sfa_file.sfa06,
                    sfa16    LIKE sfa_file.sfa16,
                    sfa29    LIKE sfa_file.sfa29
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     CALL cl_del_data(l_table)                                                                                                        
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                         
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
 
     LET l_sql = "SELECT sfb01,ta_sfb01,'','',sfb05,'','', ",
                 "       sfb08,sfb09,sfb12,sfb13, ",     
                 "       ima06,sfa03,ima02,ima021,sfa05,sfa06,sfa16,sfa29",
                 " FROM sfb_file,sfa_file ",
                 " LEFT JOIN ima_file ON sfa03 = ima01 ",
                 " WHERE ", tm.wc CLIPPED,
                 "   AND sfb01 = sfa01 AND sfb87 ='Y' ",       
                 "   AND sfb04 != '8' ",
                 "   AND sfa05 > 0 ",
                 " ORDER BY sfa01,sfa29"
 
     PREPARE r011_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE r011_curs1 CURSOR FOR r011_prepare1
 
     FOREACH r011_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF

          LET l_oea04 = ''
          SELECT oea032,occ02,oea04
            INTO sr.oea032,sr.occ02,l_oea04
            FROM oea_file
            LEFT JOIN occ_file ON oea04 = occ01
           WHERE oea01= SUBSTR(sr.ta_sfb01,1,15)

          IF cl_null(sr.occ02) THEN
             SELECT ofd02 INTO sr.occ02 FROM ofd_file
              WHERE ofd01 = l_oea04
          END IF
 
          SELECT ima02,ima021 INTO sr.aima02,sr.aima021 
            FROM ima_file  
           WHERE ima01 = sr.sfb05                                 
                     
          EXECUTE insert_prep USING sr.*

     END FOREACH
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     IF g_zz05 = 'Y' THEN                                                                                                            
        CALL cl_wcchp(tm.wc,'sfa03,sfb03,sfb82,sfb05')
             RETURNING tm.wc                                                                                                         
        LET g_str = tm.wc                                                                                                            
     END IF
     LET g_str = g_str
     CALL cl_prt_cs3('csfr011','csfr011',l_sql,g_str)    
 
END FUNCTION
 
 
