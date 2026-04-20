# Prog. Version..: '5.30.24-17.04.13(00005)'     #
#
# Pattern name...: cbmr691.4gl
# Descriptions...: 2 BOM 比較表
# Input parameter:
# Return code....:
# Date & Author..: 25090019 2025/9/15 By Momo
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD		             	# Print condition RECORD
       	        aazp01 	    LIKE azp_file.azp01,
       	        abmb01 	    LIKE bmb_file.bmb01,
       	        bazp01 	    LIKE azp_file.azp01,
       	        bbmb01 	    LIKE bmb_file.bmb01,
                choice      LIKE type_file.chr1,
                open        LIKE type_file.chr1,
                more	    LIKE type_file.chr1,
                wc          LIKE type_file.chr1000     
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
 
   LET g_sql = "bmb03.bmb_file.bmb03,",        #元件料號
               "ima02.ima_file.ima02,",        #元件品名
               "ima021.ima_file.ima021,",      #元件規格
               "abmb01.bmb_file.bmb01,",       #A_主件料號
               "aima021.ima_file.ima021,",     #A_主件規格
               "abmb06.bmb_file.bmb06,",       #A_QPA
               "abmb09.bmb_file.bmb09,",       #A_作業編號
               "bbmb01.bmb_file.bmb01,",       #B_主件料號
               "bima021.ima_file.ima021,",     #B_主件規格
               "bbmb06.bmb_file.bmb06,",       #B_QPA
               "bbmb09.bmb_file.bmb09,",       #B_作業編號
               "diff.type_file.chr20"          #差異狀況
 
   LET l_table = cl_prt_temptable('cbmr691',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                 " VALUES(?,?,?,?,?,  ?,?,?,?,?, ?,?)"                                                                                       
                                                                                                       
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                        
      EXIT PROGRAM                                                                                                                 
   END IF

 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r691_tm(0,0)	     	# Input print condition
      ELSE CALL cbmr691()	         	# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r691_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,    
       l_cmd	      LIKE type_file.chr1000 
 
   LET p_row = 4 LET p_col = 10
 
   OPEN WINDOW r691_w AT p_row,p_col
        WITH FORM "cbm/42f/cbmr691"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.choice = '1'
   LET tm.open = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   

   WHILE TRUE
{
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
}
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r691_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more  # Condition
 
#UI
   INPUT BY NAME tm.aazp01,tm.abmb01,tm.bazp01,tm.bbmb01,tm.choice,tm.open,tm.more
      WITHOUT DEFAULTS
 
        
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
          
      AFTER FIELD open
         IF tm.open IS NULL OR tm.open NOT MATCHES '[YN]' THEN
            NEXT FIELD open
         END IF
     
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
      LET INT_FLAG = 0 CLOSE WINDOW r691_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='cbmr691'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cbmr691','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"           
         CALL cl_cmdat('cbmr691',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r691_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cbmr691()
   ERROR ""
END WHILE
   CLOSE WINDOW r691_w
END FUNCTION
 
FUNCTION cbmr691()
   DEFINE l_name	LIKE type_file.chr20,   
          l_time2       LIKE type_file.chr8,  	# Used time for running the job       
          l_time_used	LIKE ogd_file.ogd15,   
          l_sql 	STRING,   
          l_chr		LIKE type_file.chr1,    
          l_za05	LIKE type_file.chr1000,
          l_order	ARRAY[5] OF LIKE bmj_file.bmj01,    
          sr RECORD
             bmb03     LIKE bmb_file.bmb03, 
             ima02     LIKE ima_file.ima02,      
             ima021    LIKE ima_file.ima021,      
             abmb01    LIKE bmb_file.bmb01,        
             aima021   LIKE ima_file.ima021,      
             abmb06    LIKE bmb_file.bmb06,    
             abmb09    LIKE bmb_file.bmb09,   
             bbmb01    LIKE bmb_file.bmb01,        
             bima021   LIKE ima_file.ima021,      
             bbmb06    LIKE bmb_file.bmb06,    
             bbmb09    LIKE bmb_file.bmb09,   
             diff      LIKE type_file.chr20
          END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     IF tm.open='Y' THEN
        LET l_sql = "WITH ",
                    "BOM_A AS (SELECT LEVEL,bmb01,a.ima021 aaima021,bmb03,b.ima02 abima02,b.ima021 abima021,bmb06/bmb07 QPA,bmb09 ",
                    " FROM ",tm.aazp01,".bmb_file ",
                    " LEFT JOIN ",tm.aazp01,".bma_file ON bmb01=bma01",
                    " LEFT JOIN ",tm.aazp01,".ima_file a ON bmb01=a.ima01",
                    " LEFT JOIN ",tm.aazp01,".ima_file b ON bmb03=b.ima01",
                    " WHERE bmaacti = 'Y' AND  bmb05 IS NULL ",
                    " START WITH bmb01 = '",tm.abmb01,"' ",
                    " CONNECT BY PRIOR bmb03 = bmb01 AND bmb05 IS NULL ),",
                    "BOM_B AS (SELECT LEVEL,bmb01,a.ima021 baima021,bmb03,b.ima02 bbima02,b.ima021 bbima021,bmb06/bmb07 QPA,bmb09 ",
                    " FROM ",tm.aazp01,".bmb_file ",
                    " LEFT JOIN ",tm.aazp01,".bma_file ON bmb01=bma01",
                    " LEFT JOIN ",tm.aazp01,".ima_file a ON bmb01=a.ima01",
                    " LEFT JOIN ",tm.aazp01,".ima_file b ON bmb03=b.ima01",
                    " WHERE bmaacti = 'Y' AND  bmb05 IS NULL ",
                    " START WITH bmb01 = '",tm.bbmb01,"' ",
                    " CONNECT BY PRIOR bmb03 = bmb01 AND bmb05 IS NULL ) ",
                    "SELECT NVL(a.bmb03, b.bmb03),NVL(abima02, bbima02),NVL(abima021, bbima021),",
                    "       a.bmb01 ,aaima021,a.QPA ,a.bmb09 ,b.bmb01 ,baima021,b.QPA ,b.bmb09,",
                    "       CASE WHEN a.QPA = b.QPA AND a.bmb09 = b.bmb09 THEN '一致' ELSE '不一致' END ",
                    "  FROM BOM_A a ",
                    "  FULL OUTER JOIN BOM_B b ON a.bmb03 = b.bmb03 "


     ELSE   
        LET l_sql = "SELECT NVL(a.bmb03, b.bmb03),NVL(abima02, bbima02),NVL(abima021, bbima021), ",
                    "       a.bmb01,aaima021,a.bmb06/a.bmb07,a.bmb09,",
                    "       b.bmb01,baima021,b.bmb06/b.bmb07,b.bmb09,",
                    "       CASE WHEN a.bmb06/a.bmb07 = b.bmb06/b.bmb07 AND a.bmb09 = b.bmb09 THEN '一致' ELSE '不一致' END ",
                    " FROM (SELECT bmb01,a.ima021 aaima021,bmb06,bmb07,bmb09,bmb03,b.ima02 abima02,b.ima021 abima021 ",
                    "         FROM ",tm.aazp01,".ima_file b,",tm.aazp01,".bmb_file ",
                    "         LEFT JOIN ",tm.aazp01,".ima_file a ON a.ima01 = bmb01",
                    "        WHERE bmb03=b.ima01 AND bmb05 IS NULL AND bmb01 = '",tm.abmb01,"' ) a ",
                    " FULL OUTER JOIN ",
                    "      (SELECT bmb01,a.ima021 baima021,bmb06,bmb07,bmb09,bmb03,b.ima02 bbima02,b.ima021 bbima021  ",
                    "         FROM ",tm.bazp01,".ima_file b,",tm.bazp01,".bmb_file ",
                    "         LEFT JOIN ",tm.bazp01,".ima_file a ON a.ima01 = bmb01",
                    "        WHERE bmb03=b.ima01 AND bmb05 IS NULL AND bmb01 = '",tm.bbmb01,"' ) b ",
                    " ON a.bmb03 = b.bmb03 "
     END IF
 
     PREPARE r691_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
     END IF
     DECLARE r691_cs1 CURSOR FOR r691_prepare1
     CALL cl_del_data(l_table)  

     FOREACH r691_cs1 INTO sr.*
       IF SQLCA.sqlcode THEN
         CALL cl_err('ForEACH:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       IF tm.choice = '2' THEN
          IF sr.diff = '不一致' THEN
             CONTINUE FOREACH
          END IF
       END IF
         
       IF tm.choice = '3' THEN
          IF sr.diff = '一致' THEN
             CONTINUE FOREACH
          END IF
       END IF

       EXECUTE insert_prep USING sr.*
    
     END FOREACH
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     CALL cl_prt_cs3('cbmr691','cbmr691',g_sql,g_str)
   
END FUNCTION
