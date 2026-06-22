# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cbmr715.4gl
# Descriptions...: 跨Plant工程變異單
# Input parameter:
# Return code....:
# Date & Author..: 2026/04/20 By momo
# Modify.........: 


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
	wc  	LIKE type_file.chr1000, 
	source  LIKE azp_file.azp01,
        target  LIKE azp_file.azp01,
        more	LIKE type_file.chr1     
              END RECORD
       
DEFINE   g_cnt    LIKE type_file.num10   
DEFINE   g_i      LIKE type_file.num5    

DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_table1   STRING   
DEFINE  l_table2   STRING   
DEFINE  g_str      STRING
DEFINE  g_count    LIKE type_file.num5
DEFINE  g_argv1    LIKE bmx_file.bmx01  

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

   LET g_argv1  = ARG_VAL(1) 
   LET g_pdate  = ARG_VAL(2)		# Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   LET tm.source = ARG_VAL(9)
   LET tm.target = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)
 
   LET g_sql ="bmx01.bmx_file.bmx01,",
              "bmx02.bmx_file.bmx02,",
              "bmx07.bmx_file.bmx07,",
              "bmb03.bmb_file.bmb03,",
              "bmy01.bmy_file.bmy01,",
              "bmy02.bmy_file.bmy02,",
              "bmy03.bmy_file.bmy03,",
              "bmy04.bmy_file.bmy04,",
              "bmy05.bmy_file.bmy05,",
              "bmy06.bmy_file.bmy06,",
              "bmy07.bmy_file.bmy07,",
              "bmy16.bmy_file.bmy16,",
              "bmy38.bmy_file.bmy38,",
              "bmy27.bmy_file.bmy27,",
              "ima02_2.ima_file.ima02,",
              "ima021_2.ima_file.ima021,",  
              "ima25.ima_file.ima25,",            
              "ima02_3.ima_file.ima02,", 
              "ima021_3.ima_file.ima021,",
              "bmy14.bmy_file.bmy14,",      
              "ima02_4.ima_file.ima02,", 
              "ima021_4.ima_file.ima021"
                   
      
   LET l_table = cl_prt_temptable('cbmr715',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   #工程變異單主件
   LET g_sql ="bmx01.bmx_file.bmx01,",
              "bmz02.bmz_file.bmz02,",
              "bmzplant.bmz_file.bmzplant,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021"
   LET l_table1 = cl_prt_temptable('cbmr7151',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   #備註
   LET g_sql ="bmx01.bmx_file.bmx01,",
              "bmg02.bmg_file.bmg02,",
              "bmg03.bmg_file.bmg03,",
              "ta_bmg01.bmg_file.ta_bmg01"        
   LET l_table2 = cl_prt_temptable('cbmr7152',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off
      LET tm.source = 'TY'
      LET tm.target = g_plant
      LET tm.more = 'N'
      LET g_pdate = g_today
      LET g_rlang = g_lang
      LET g_bgjob = 'N'
      LET g_copies = '1'
      CALL r715_tm()	             	        # Input print condition
   ELSE
     #LET tm.wc=" bmx01='",tm.wc,"'"           
      CALL r715()		          	# Read data and create out-file
   END IF

  CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r715_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     
DEFINE l_cmd		LIKE type_file.chr1000, 
       p_row,p_col      LIKE type_file.num5    
 
 
   OPEN WINDOW r715_w AT p_row,p_col
        WITH FORM "cbm/42f/cbmr715"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bmx01,bmx02
     BEFORE CONSTRUCT
       CALL cl_qbe_init()

     IF NOT cl_null(g_argv1) THEN
        DISPLAY g_argv1 TO bmx01
     END IF

 
#FUN-4A0037新增開窗功能
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
      LET INT_FLAG = 0 CLOSE WINDOW r715_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.source,tm.target,tm.more WITHOUT DEFAULTS
        
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
      LET INT_FLAG = 0 CLOSE WINDOW r715_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='cbmr715'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cbmr715','9031',1)
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
                         " '",tm.source CLIPPED,"'",    
                         " '",tm.target CLIPPED,"'",    
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"         
                               
         CALL cl_cmdat('cbmr715',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r715_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r715()
   ERROR ""
END WHILE
   CLOSE WINDOW r715_w
END FUNCTION
 
FUNCTION r715()
   DEFINE l_name	LIKE type_file.chr20,  
          l_sql 	LIKE type_file.chr1000, 
          l_ta_bmg01    LIKE bmg_file.ta_bmg01, #類別
          l_bmg02       LIKE bmg_file.bmg02,   
          l_bmg03       LIKE bmg_file.bmg03,    
          l_bmw04       LIKE bmw_file.bmw04,    
          l_bmw05       LIKE bmw_file.bmw05,    
          l_bmz02       LIKE bmz_file.bmz02,    
          l_bmzplant    LIKE bmz_file.bmzplant,  
          l_ima02       LIKE ima_file.ima02,  
          l_ima02_1     LIKE ima_file.ima02,  
          l_ima021_1    LIKE ima_file.ima021,   
          l_ima021      LIKE ima_file.ima021,
          l_bmx06       LIKE bmx_file.bmx06,
          l_bmb01       LIKE bmb_file.bmb01, 
          l_order	ARRAY[5] OF LIKE type_file.chr20,  

          bmw		RECORD LIKE bmw_file.*,    
          sr               RECORD
                                   bmx01  LIKE bmx_file.bmx01,
                                   bmx02  LIKE bmx_file.bmx02,
                                   bmx07  LIKE bmx_file.bmx07,
                                   bmb03  LIKE bmb_file.bmb03,
                                   bmy01  LIKE bmy_file.bmy01,
                                   bmy02  LIKE bmy_file.bmy02,
                                   bmy03  LIKE bmy_file.bmy03,
                                   bmy04  LIKE bmy_file.bmy04,
                                   bmy05  LIKE bmy_file.bmy05,
                                   bmy06  LIKE bmy_file.bmy06,
                                   bmy07  LIKE bmy_file.bmy07,
                                   bmy16  LIKE bmy_file.bmy16,
                                   bmy38  LIKE bmy_file.bmy38,
                                   bmy27  LIKE bmy_file.bmy27,
                                   ima02  LIKE ima_file.ima02,
                                   ima021 LIKE ima_file.ima021,  
                                   ima25  LIKE ima_file.ima25,
                                   ima02_3  LIKE ima_file.ima02,
                                   ima021_3 LIKE ima_file.ima021,
                                   bmy14    LIKE bmy_file.bmy14,
                                   ima02_4  LIKE ima_file.ima02,
                                   ima021_4 LIKE ima_file.ima021
                           END RECORD


   DEFINE l_img_blob     LIKE type_file.blob
 
   CALL cl_del_data(l_table)    
   CALL cl_del_data(l_table1)  
   CALL cl_del_data(l_table2)   
   
   LOCATE l_img_blob IN MEMORY   #blob初始化  
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",       
               "        ?,?,?,?,?, ?,?,?,?,?, ?,? )"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
 
   #工程變異單主件
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF

 
   #備註
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?)"                                   
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmxuser','bmxgrup')   
  
   LET l_sql = "SELECT bmx01,bmx02,bmx07,'',bmy01,bmy02,bmy03,bmy04,bmy05,bmy06,bmy07,bmy16,bmy38, ",   
               "       bmy27,a.ima02,a.ima021,a.ima25,b.ima02,b.ima021,bmy14,c.ima02,c.ima021  ",   
               "  FROM ",tm.source,".bmx_file ",
               "  LEFT JOIN ",tm.source,".bmy_file ON bmx01=bmy01 ",
               "  LEFT JOIN ",tm.source,".ima_file a ON bmy_file.bmy05=a.ima01 ",  
               "  LEFT JOIN ",tm.source,".ima_file b ON bmy_file.bmy27=b.ima01 ",  
               "  LEFT JOIN ",tm.source,".ima_file c ON bmy_file.bmy14=c.ima01 ",  
               " WHERE bmx04 = 'Y' AND ",tm.wc CLIPPED
   
   PREPARE r715_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   DECLARE r715_c0 CURSOR FOR r715_prepare1

   FOREACH r715_c0 INTO sr.*,l_ima02_1,l_ima021_1
      IF STATUS THEN CALL cl_err('for bmx:',STATUS,1) EXIT FOREACH END IF
 
      ##---元件存在否
      LET l_sql = "SELECT bmb03 ",
                  " FROM ",tm.target,".bmb_file ",
                  " WHERE bmb03 = '",sr.bmy05,"' AND bmb05 IS NULL AND ROWNUM = 1 "
      PREPARE r715_prebmb03 FROM l_sql
      IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE r715_cbmb03 CURSOR FOR r715_prebmb03
      FOREACH r715_cbmb03 INTO sr.bmb03
         IF NOT cl_null(sr.bmb03) THEN
            LET sr.bmb03 = "✓"
         END IF
      END FOREACH
      ##---主件存在否
      LET l_bmb01=''
      LET l_sql = "SELECT bmb01 ",
                  " FROM ",tm.target,".bmb_file ",
                  " WHERE bmb01 = '",sr.bmy14,"' AND bmb05 IS NULL AND ROWNUM = 1 "
      PREPARE r715_prebmb01 FROM l_sql
      IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE r715_cbmb01 CURSOR FOR r715_prebmb01
      FOREACH r715_cbmb01 INTO l_bmb01
         IF NOT cl_null(l_bmb01) THEN
            LET l_bmb01 = "O"
         END IF
      END FOREACH
      LET sr.bmb03 = sr.bmb03,l_bmb01
      

      EXECUTE insert_prep USING sr.* 

   END FOREACH
 

   LET l_sql = "SELECT bmx01,bmx06 FROM ",tm.source,".bmx_file ",
               " WHERE bmx04 = 'Y' AND ",tm.wc CLIPPED,
               " ORDER BY bmx01 "
               
   PREPARE r701_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
   CALL cl_err('prepare2:',SQLCA.sqlcode,1)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   EXIT PROGRAM
   END IF
   DECLARE r701_cs2 CURSOR FOR r701_prepare2
   
   FOREACH r701_cs2 INTO sr.bmx01,l_bmx06
      #備註
      LET l_sql = "SELECT bmg02,bmg03,tc_dic05 ",
                  " FROM ",tm.source,".bmg_file ",
                  " LEFT JOIN ",tm.source,".tc_dic_file ON tc_dic04=ta_bmg01 and tc_dic01='abmi701' ",
                  " WHERE bmg01 = '",sr.bmx01,"'",
                  " ORDER BY bmg02 "
      PREPARE r715_bmg2 FROM l_sql                 
      DECLARE r715_bmgc2 CURSOR FOR r715_bmg2
      FOREACH r715_bmgc2 INTO l_bmg02,l_bmg03,l_ta_bmg01  
         IF STATUS THEN CALL cl_err('for bmg:',STATUS,1) EXIT FOREACH END IF
         EXECUTE insert_prep2 USING sr.bmx01,l_bmg02,l_bmg03,l_ta_bmg01                   
      END FOREACH
 
      
      #工程變異單主件
      
      IF l_bmx06 = '1' THEN
      LET l_sql = "SELECT bmz02,bmb01,ima02,ima021 ",
                  " FROM ",tm.source,".bmz_file ",
                  " LEFT JOIN ",tm.source,".ima_file ON ima01=bmz02 ",
                  " LEFT JOIN ",tm.target,".bmb_file ON bmb01=bmz02 AND bmb05 IS NULL AND rownum = 1 ",
                  " WHERE bmz01 = '",sr.bmx01,"'" 
      LET l_bmz02 = NULL
      LET l_bmzplant = NULL
      LET l_ima02 = NULL
      LET l_ima021 = NULL
      PREPARE r715_bmz2 FROM l_sql                 
      DECLARE r715_bmzc2 CURSOR FOR r715_bmz2
      FOREACH r715_bmzc2 INTO l_bmz02,l_bmzplant,l_ima02,l_ima021
         IF STATUS THEN CALL cl_err('for bmz:',STATUS,1) EXIT FOREACH END IF
         IF NOT cl_null(l_bmzplant) THEN
            LET l_bmzplant = "O"
         END IF
         EXECUTE insert_prep1 USING 
            sr.bmx01,l_bmz02,l_bmzplant,l_ima02,l_ima021
      END FOREACH
      END IF
      
   END FOREACH
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'bmx01,bmx02')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table2 CLIPPED
 
    LET g_cr_table = l_table                 #主報表的temp table名稱
    LET g_cr_apr_key_f = "bmx01"             #報表主鍵欄位名稱，用"|"隔開  
    CALL cl_prt_cs3('cbmr715','cbmr715',l_sql,g_str)

END FUNCTION 
