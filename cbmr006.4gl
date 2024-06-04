# Prog. Version..: '5.30.24-17.04.13(00005)'     #
#
# Pattern name...: cbmr006.4gl
# Descriptions...: 依型號查詢元件明細
# Input parameter:
# Return code....:
# Date & Author..: 2023/12/29 By Momo
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD		             	# Print condition RECORD
       	        wc 	    LIKE type_file.chr1000, 
                more	LIKE type_file.chr1     
              END RECORD
 
DEFINE   g_cnt          LIKE type_file.num10   
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  
DEFINE   g_sql          STRING     
DEFINE   g_str          STRING     
DEFINE   l_table        STRING     
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT		        # Supress DEL key function
 
  
   LET g_pdate = ARG_VAL(1)	        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
  
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CBM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_sql = "bmb01.bmb_file.bmb01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "bmb03.bmb_file.bmb03,",
               "ima1007.ima_file.ima1007,",
               "level2.type_file.num5,",
               "path2.type_file.chr1000,"
 
   LET l_table = cl_prt_temptable('cbmr006',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                 " VALUES(?,?,?,?,?,  ?,?)"                                                                                           
                                                                                                       
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                        
      EXIT PROGRAM                                                                                                                 
   END IF

 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r006_tm(0,0)	     	# Input print condition
      ELSE CALL cbmr006()	         	# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r006_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,    
       l_cmd	      LIKE type_file.chr1000 
 
   LET p_row = 4 LET p_col = 10
 
   OPEN WINDOW r006_w AT p_row,p_col
        WITH FORM "cbm/42f/cbmr006"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON bmb03,ima02,ima021
 
        
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
        
 
       ON ACTION CONTROLP 
            IF INFIELD(bmb03) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bmb03
               NEXT FIELD bmb03
            END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW r006_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more  # Condition
 
#UI
   INPUT BY NAME tm.more
      WITHOUT DEFAULTS
 
        
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
          
     
      AFTER FIELD more
         IF tm.more IS NULL OR tm.more NOT MATCHES '[YN]' THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      #UI
      AFTER INPUT

 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
         IF INT_FLAG THEN EXIT INPUT END IF
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r006_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='cbmr006'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cbmr006','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"           
         CALL cl_cmdat('cbmr006',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r006_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cbmr006()
   ERROR ""
END WHILE
   CLOSE WINDOW r006_w
END FUNCTION
 
FUNCTION cbmr006()
   DEFINE l_name	LIKE type_file.chr20,   
          l_time2       LIKE type_file.chr8,  	# Used time for running the job       
          l_time_used	LIKE ogd_file.ogd15,   
          l_sql 	LIKE type_file.chr1000,     # RDSQL STATEMENT      
          l_chr		LIKE type_file.chr1,    
          l_za05	LIKE type_file.chr1000,
          l_order	ARRAY[5] OF LIKE bmj_file.bmj01,    
          sr RECORD
             bmb01   LIKE bmb_file.bmb01, 
             ima02   LIKE ima_file.ima02,      
             ima021  LIKE ima_file.ima021,      
             bmb03   LIKE bmb_file.bmb03,        
             ima1007 LIKE ima_file.ima1007,  
             level2  LIKE type_file.num5,      
             path2   LIKE type_file.chr1000
          END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
  
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmjuser', 'bmjgrup')
   
   
     LET l_sql = "SELECT distinct '','','',bmb03,'',0,0,'' ",
                 " FROM bmb_file,ima_file ",
                 " WHERE bmb01=ima01 AND imaacti='Y' AND bmb05 IS NULL",
                 " START WITH bmb05 IS NULL AND ",tm.wc,
                 "CONNECT BY PRIOR bmb03 = bmb01 AND bmb05 IS NULL"
    
 
     PREPARE r006_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
     END IF
     DECLARE r006_cs1 CURSOR FOR r006_prepare1
     CALL cl_del_data(l_table)  

     FOREACH r006_cs1 INTO sr.*
       IF SQLCA.sqlcode THEN
         CALL cl_err('ForEACH:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       ##----依元件查找，有被使用的型號 （S）
       LET l_sql = "SELECT distinct bmb01,ima02,ima021,ima1007,level,SYS_CONNECT_BY_PATH(bmb01,'/') AS PartPath ",
                   " FROM bma_file,bmb_file,ima_file ",
                   " WHERE bma01=bmb01 AND bmaacti='Y' AND bmb01=ima01 AND bmb05 IS NULL ",
                   " START WITH bmb03='",sr.bmb03,"' AND bmb05 IS NULL AND bmaacti='Y' ",
                   " CONNECT BY bmb03 = PRIOR bmb01 AND bmb05 IS NULL AND bmaacti='Y' ",
                   " ORDER BY 6 "
       PREPARE r006_prepare11 FROM l_sql
       DECLARE r006_ima1007 CURSOR FOR r006_prepare11
       FOREACH r006_ima1007 INTO sr.bmb01,sr.ima02,sr.ima021,sr.ima1007,sr.level2,sr.path2
               EXECUTE insert_prep USING sr.*
       END FOREACH
       ##----依元件查找，有被使用的型號 （S）

         
       #EXECUTE insert_prep USING sr.*
    
     END FOREACH
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'bmj01,bmj02,bmj10,bmj11,bmj06')
            RETURNING tm.wc
     ELSE
        LET tm.wc = ""
     END IF
     LET g_str = tm.wc,";"
     CALL cl_prt_cs3('cbmr006','cbmr006',g_sql,g_str)
   
END FUNCTION
