# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cbmr700.4gl
# Descriptions...: 工程變異清單
# Input parameter:
# Return code....:
# Date & Author..: 2023/02/15 By Momo
# Modify.........: No.23010027


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
          wc  STRING, 
      more    LIKE type_file.chr1   
              END RECORD
  
 
DEFINE   g_cnt    LIKE type_file.num10   
DEFINE   g_i      LIKE type_file.num5    #count/index for any purpose   #

DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_table1   STRING   
DEFINE  l_table2   STRING   
DEFINE  l_table3   STRING   
DEFINE  g_str      STRING

DEFINE  g_count    LIKE type_file.num5

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CBM")) THEN
      EXIT PROGRAM
   END IF
  
 
 
   INITIALIZE tm.* TO NULL			# Default condition
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12) 
 
   LET g_sql ="bmx01.bmx_file.bmx01,",
              "bmx02.bmx_file.bmx02,",
              "bmx05.bmx_file.bmx05,",
              "bmx07.bmx_file.bmx07,",
              "azf03.azf_file.azf03,",     #ECN原因說明
              "gen02.gen_file.gen02,",     
              "gem02.gem_file.gem02,",     
              "bmy01.bmy_file.bmy01,",
              "bmy02.bmy_file.bmy02,",
              "bmy03.bmy_file.bmy03,",
              "bmy04.bmy_file.bmy04,",
              "bmy05.bmy_file.bmy05,",
              "bmy06.bmy_file.bmy06,",
              "bmy07.bmy_file.bmy07,",
              "bmy16.bmy_file.bmy16,",
              "bmy19.bmy_file.bmy19,",
              "bmy27.bmy_file.bmy27,",
              "bmy30.bmy_file.bmy30,",
              "bmy14.bmy_file.bmy14,",       #變異主件
              "ima02_14.ima_file.ima02,",    #主件品名
              "ima021_14.ima_file.ima021,",  #主件規格
              "bmystr.type_file.chr1000,",
              "ima02_2.ima_file.ima02,",     #元件品名
              "ima021_2.ima_file.ima021,",   #元件規格
              "ima25.ima_file.ima25,",
              "ima02_3.ima_file.ima02,",     #取替代品名 
              "ima021_3.ima_file.ima021"     #取替代規格
             ,",sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     
              "sign_show.type_file.chr1,"                               #是否顯示簽核資料(Y/N)  
              ,"sign_str.type_file.chr1000"        
   LET l_table = cl_prt_temptable('cbmr700',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
 
   #工程變異單主件
   LET g_sql ="bmx01.bmx_file.bmx01,",
              "bmz02.bmz_file.bmz02,",
              "bmz03.bmz_file.bmz03,",
              "bmz05.bmz_file.bmz05,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021"
   LET l_table1 = cl_prt_temptable('cbmr7001',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   #備註
   LET g_sql ="bmx01.bmx_file.bmx01,",
              "bmg02.bmg_file.bmg02,",
              "bmg03.bmg_file.bmg03"
   LET l_table2 = cl_prt_temptable('cbmr7002',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   #插件位置
   LET g_sql ="bmx01.bmx_file.bmx01,",
              "bmy05.bmy_file.bmy05,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021"
   LET l_table3 = cl_prt_temptable('cbmr7003',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
  
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off
   
      LET tm.more = 'N'
      LET g_pdate = g_today
      LET g_rlang = g_lang
      LET g_bgjob = 'N'
      LET g_copies = '1'
      CALL r700_tm()	             	        # Input print condition
   ELSE
      CALL r700()		          	# Read data and create out-file
   END IF
 
  CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r700_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01    
DEFINE l_cmd		LIKE type_file.chr1000, 
          p_row,p_col   LIKE type_file.num5     
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 8 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 18
   END IF
 
   OPEN WINDOW r700_w AT p_row,p_col
        WITH FORM "cbm/42f/cbmr700"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   CALL cl_set_comp_visible("group",g_sma.sma541 = 'Y')    
  
  
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bmx01,bmx02
         
         BEFORE CONSTRUCT
             CALL cl_qbe_init()        

   ON ACTION CONTROLP
      CALL cl_init_qry_var()
      LET g_qryparam.state = "c"
      LET g_qryparam.form = "q_bmx1"
      CALL cl_create_qry() RETURNING g_qryparam.multiret
      DISPLAY g_qryparam.multiret TO bmx01
 
 
   ON ACTION locale
          CALL cl_show_fld_cont()                   
         LET g_action_choice = "locale"
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
        
         ON ACTION qbe_select
            CALL cl_qbe_select()
         
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS   
        
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
        
 
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
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         
         ON ACTION qbe_save
            CALL cl_qbe_save()
       
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='cbmr700'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cbmr700','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")   #"
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
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
                         " '",g_rpt_name CLIPPED,"'"              
         CALL cl_cmdat('cbmr700',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r700_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r700()
   ERROR ""
END WHILE
   CLOSE WINDOW r700_w
END FUNCTION
 
FUNCTION r700()
   DEFINE l_name	    LIKE type_file.chr20,  
          l_sql 	    STRING,
          l_bmg02       LIKE bmg_file.bmg02,    
          l_bmg03       LIKE bmg_file.bmg03,    
          l_bmz02       LIKE bmz_file.bmz02,    
          l_bmz03       LIKE bmz_file.bmz03,    
          l_bmz05       LIKE bmz_file.bmz05,    
          l_ima02       LIKE ima_file.ima02,    
          l_ima02_1     LIKE ima_file.ima02,    
          l_ima021_1    LIKE ima_file.ima021,  
          l_ima021      LIKE ima_file.ima021,   
          l_order	ARRAY[5] OF LIKE type_file.chr20, 
          ##影響主件
          sr3           RECORD
                        bmy01    LIKE bmy_file.bmy01,
                        bmy05    LIKE bmy_file.bmy05,
                        ima02    LIKE ima_file.ima02,
                        ima021   LIKE ima_file.ima021
                        END RECORD,

          sr               RECORD
                                   bmx01  LIKE bmx_file.bmx01,
                                   bmx02  LIKE bmx_file.bmx02,
                                   bmx05  LIKE bmx_file.bmx05,
                                   bmx07  LIKE bmx_file.bmx07,
                                   azf03  LIKE azf_file.azf03,         #ECN變更原因
                                   gen02  LIKE gen_file.gen02,        
                                   gem02  LIKE gem_file.gem02,        
                                   bmy01  LIKE bmy_file.bmy01,
                                   bmy02  LIKE bmy_file.bmy02,
                                   bmy03  LIKE bmy_file.bmy03,
                                   bmy04  LIKE bmy_file.bmy04,
                                   bmy05  LIKE bmy_file.bmy05,
                                   bmy06  LIKE bmy_file.bmy06,
                                   bmy07  LIKE bmy_file.bmy07,
                                   bmy16  LIKE bmy_file.bmy16,
                                   bmy19  LIKE bmy_file.bmy19,
                                   bmy27  LIKE bmy_file.bmy27,
                                   bmy30  LIKE bmy_file.bmy30,
                                   bmy14  LIKE bmy_file.bmy14,       #變更主件
                                   ima02_14  LIKE ima_file.ima02,    #主件品名
                                   ima021_14 LIKE ima_file.ima021,   #主件規格
                                   bmystr LIKE type_file.chr1000,
                                   ima02  LIKE ima_file.ima02,
                                   ima021 LIKE ima_file.ima021,  
                                   ima25  LIKE ima_file.ima25
                           END RECORD

 

   DEFINE l_img_blob     LIKE type_file.blob
 
   CALL cl_del_data(l_table)     
   CALL cl_del_data(l_table1)    
   CALL cl_del_data(l_table2)    
   CALL cl_del_data(l_table3)    
   
   LOCATE l_img_blob IN MEMORY   #blob初始化  
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,",        
               "        ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?)" 
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #
      EXIT PROGRAM
   END IF
 
   #工程變異單主件
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF

 
   #備註
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF

 
   #受影響主件
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?)"
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep3:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF
 
   

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmxuser','bmxgrup')   
 
   LET l_sql = "SELECT bmx01,bmx02,bmx05,bmx07,'','','',bmy01,bmy02,bmy03,bmy04,bmy05,bmy06,bmy07,bmy16, ",  
               "       bmy19,bmy27,bmy30,bmy14,'','','',ima02,ima021,ima25  ",   
               "  FROM bmx_file LEFT OUTER JOIN bmy_file ON bmx01=bmy01 ",
               "                LEFT OUTER JOIN ima_file ON bmy_file.bmy05=ima01 ",  
               " WHERE bmx04 <> 'X' AND ",tm.wc CLIPPED
  
   PREPARE r700_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   DECLARE r700_c0 CURSOR FOR r700_prepare1
 

   FOREACH r700_c0 INTO sr.*
      IF STATUS THEN CALL cl_err('for bmx:',STATUS,1) EXIT FOREACH END IF

      SELECT ima02,ima021 INTO sr.ima02_14,sr.ima021_14
        FROM ima_file
       WHERE ima01 = sr.bmy14

      SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01 
          IN (SELECT bmx10 FROM bmx_file WHERE bmx01 = sr.bmx01)
      IF SQLCA.sqlcode THEN LET sr.gen02 = ' ' END IF 

 
      SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01      
          IN (SELECT bmx13 FROM bmx_file WHERE bmx01 = sr.bmx01)
      IF SQLCA.sqlcode THEN  LET sr.gem02 = ' ' END IF 


     ## ECN變更原因(S)
     SELECT azf03 INTO sr.azf03 
       FROM azf_file,bmx_file
      WHERE azf01 = ta_bmx03
        AND azf02='2' AND azf09='G'
        AND bmx01 = sr.bmx01
  
      SELECT ima02,ima021 INTO l_ima02_1,l_ima021_1 FROM ima_file  
       WHERE ima01 = sr.bmy27
 

      EXECUTE insert_prep USING 
         sr.*,l_ima02_1,l_ima021_1  
         ,"",l_img_blob,"N",""         
    
 

   END FOREACH

    
  
   LET l_sql = "SELECT bmx01 FROM bmx_file ",
               " WHERE bmx04 <> 'X' AND ",tm.wc CLIPPED,
               " ORDER BY bmx01"
   PREPARE r701_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
   CALL cl_err('prepare2:',SQLCA.sqlcode,1)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   EXIT PROGRAM
   END IF
   DECLARE r701_cs2 CURSOR FOR r701_prepare2
   
   FOREACH r701_cs2 INTO sr.bmx01
      #備註
      DECLARE r700_c1 CURSOR FOR
         SELECT bmg02,bmg03 FROM bmg_file WHERE bmg01=sr.bmx01 ORDER BY bmg02  
     
      FOREACH r700_c1 INTO l_bmg02,l_bmg03 
         IF STATUS THEN CALL cl_err('for bmg:',STATUS,1) EXIT FOREACH END IF
      
         EXECUTE insert_prep2 USING sr.bmx01,l_bmg02,l_bmg03
      
      END FOREACH

      #影響主件
      LET l_sql = "SELECT DISTINCT bmb01 FROM bmb_file,ima_file ",
                  "WHERE bmb01=ima01 ",
                  "  AND ima01 LIKE '0%' ",
                  "  AND imaacti='Y' AND ima140='N' ",
                  "START WITH bmb03 IN (SELECT distinct bmy05 FROM bmy_file WHERE bmy01='",sr.bmx01,"' AND bmy05=bmb03)",
                  "CONNECT BY bmb03=PRIOR bmb01"
      PREPARE r700_prepare3 FROM l_sql
         
      DECLARE r700_c3 CURSOR FOR r700_prepare3
    
      FOREACH r700_c3 INTO sr3.bmy05           
         IF STATUS THEN CALL cl_err('for bmy:',STATUS,1) EXIT FOREACH END IF
         SELECT ima02,ima021 INTO sr3.ima02,sr3.ima021
          FROM ima_file
         WHERE ima01 = sr3.bmy05
      
         EXECUTE insert_prep3 USING
            sr.bmx01,sr3.bmy05,sr3.ima02,sr3.ima021
     
      END FOREACH
 
      #工程變異單主件
      DECLARE r700_c2 CURSOR FOR
         SELECT bmz02,bmz03,bmz05,ima02,ima021 FROM bmz_file, ima_file
          WHERE bmz01=sr.bmx01 AND bmz02=ima_file.ima01   
          ORDER BY bmz02
      LET l_bmz02 = NULL
      LET l_bmz03 = NULL
      LET l_bmz05 = NULL
      LET l_ima02 = NULL
      LET l_ima021 = NULL
      FOREACH r700_c2 INTO  l_bmz02,l_bmz03,l_bmz05,l_ima02,l_ima021
         IF STATUS THEN CALL cl_err('for bmz:',STATUS,1) EXIT FOREACH END IF
       
         EXECUTE insert_prep1 USING 
            sr.bmx01,l_bmz02,l_bmz03,l_bmz05,l_ima02,l_ima021
       
      END FOREACH
   END FOREACH
   
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'bmx01,bmx02')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05   
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table3 CLIPPED  
    
    LET g_cr_table = l_table                 #主報表的temp table名稱
  
    LET g_cr_apr_key_f = "bmx01"             #報表主鍵欄位名稱，用"|"隔開 

 
     CALL cl_prt_cs3('cbmr700','cbmr700',l_sql,g_str)


END FUNCTION 
 
