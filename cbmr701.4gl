# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cbmr701.4gl
# Descriptions...: 工程變異原因清單
# Input parameter:
# Return code....:
# Date & Author..: 2024/05/13 By Momo
# Modify.........: No.24050004


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
              "bmx07.bmx_file.bmx07,",
              "bmx10.bmx_file.bmx10,",
              "gen0210.gen_file.gen02,",
              "bmx13.bmx_file.bmx13,",
              "gem02.gem_file.gem02,",
              "bmxuser.bmx_file.bmxuser,",
              "gen02.gen_file.gen02,",
              "ta_bmx03.bmx_file.ta_bmx03,",
              "azf03.azf_file.azf03,",
              "ta_bmg01.bmg_file.ta_bmg01,",
              "tc_dic05.tc_dic_file.tc_dic05,",
              "bmg02.bmg_file.bmg02,",
              "bmg03.bmg_file.bmg03,",
              "bmg0310.bmg_file.bmg03,",
              "bmg0320.bmg_file.bmg03,",
              "bmg0330.bmg_file.bmg03,",
              "bmg0340.bmg_file.bmg03,",
              "bmg0350.bmg_file.bmg03,",
              "bmg0360.bmg_file.bmg03,",
              "bmg0370.bmg_file.bmg03,",
              "bmg0380.bmg_file.bmg03,",
              "bmg0390.bmg_file.bmg03,",
              "bmg03100.bmg_file.bmg03"
 
                    
   LET l_table = cl_prt_temptable('cbmr701',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
  
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off
   
      LET tm.more = 'N'
      LET g_pdate = g_today
      LET g_rlang = g_lang
      LET g_bgjob = 'N'
      LET g_copies = '1'
      CALL r701_tm()	             	        # Input print condition
   ELSE
      CALL r701()		          	# Read data and create out-file
   END IF
 
  CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r701_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01    
DEFINE l_cmd		    LIKE type_file.chr1000, 
       p_row,p_col      LIKE type_file.num5     
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 8 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 18
   END IF
 
   OPEN WINDOW r701_w AT p_row,p_col
        WITH FORM "cbm/42f/cbmr701"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_set_comp_visible("group",g_sma.sma542 = 'Y')
   CALL cl_opmsg('p')
 
  
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bmx01,bmx02,bmx07,bmx10,bmx13,ta_bmx03,bmxoriu
         
         BEFORE CONSTRUCT
             CALL cl_qbe_init()        

   ON ACTION CONTROLP
      CASE
       WHEN INFIELD(bmx01)
         CALL cl_init_qry_var()
         LET g_qryparam.state = "c"
         LET g_qryparam.form = "q_bmx1"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO bmx01
       WHEN INFIELD(bmx10)
         CALL cl_init_qry_var()
         LET g_qryparam.state = "c"
         LET g_qryparam.form = "q_gen"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO bmx10
       WHEN INFIELD(bmx13)
         CALL cl_init_qry_var()
         LET g_qryparam.state = "c"
         LET g_qryparam.form = "q_gem"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO bmx13
       WHEN INFIELD(bmxoriu)
         CALL cl_init_qry_var()
         LET g_qryparam.state = "c"
         LET g_qryparam.form = "q_gen"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO bmxoriu
       WHEN INFIELD(ta_bmx03)
         CALL cl_init_qry_var()
         LET g_qryparam.form  = "q_azf01a"
         LET g_qryparam.state = "c"
         LET g_qryparam.arg1  = "G"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO ta_bmx03
      END CASE
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r701_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW r701_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='cbmr701'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cbmr701','9031',1)
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
         CALL cl_cmdat('cbmr701',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r701_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r701()
   ERROR ""
END WHILE
   CLOSE WINDOW r701_w
END FUNCTION
 
FUNCTION r701()
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
          sr               RECORD
                                   bmx01    LIKE bmx_file.bmx01,
                                   bmx02    LIKE bmx_file.bmx02,
                                   bmx07    LIKE bmx_file.bmx07,
                                   bmx10    LIKE bmx_file.bmx10,
                                   gen0210  LIKE gen_file.gen02,
                                   bmx13    LIKE bmx_file.bmx13,
                                   gem02    LIKE gem_file.gem02,
                                   bmxuer   LIKE bmx_file.bmxuser,
                                   gen02    LIKE gen_file.gen02,
                                   ta_bmx03 LIKE bmx_file.ta_bmx03,
                                   azf03    LIKE azf_file.azf03,         #ECN變更原因
                                   ta_bmg01 LIKE bmg_file.ta_bmg01,
                                   tc_dic05 LIKE tc_dic_file.tc_dic05,
                                   bmg02    LIKE bmg_file.bmg02,        
                                   bmg03    VARCHAR(2000),
                                   bmg0310  VARCHAR(2000),
                                   bmg0320  VARCHAR(2000),
                                   bmg0330  VARCHAR(2000),
                                   bmg0340  VARCHAR(2000),
                                   bmg0350  VARCHAR(2000),
                                   bmg0360  VARCHAR(2000),
                                   bmg0370  VARCHAR(2000),
                                   bmg0380  VARCHAR(2000),
                                   bmg0390  VARCHAR(2000),
                                   bmg03100  VARCHAR(2000)
                           END RECORD

 

   DEFINE l_img_blob     LIKE type_file.blob
 
   CALL cl_del_data(l_table)     
  
   LOCATE l_img_blob IN MEMORY   #blob初始化  
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,   ",
               "        ?,?,?,?,?, ?,?,?,?,?,   ",
               "        ?,?,?,?,?                  )" 
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #
      EXIT PROGRAM
   END IF
 
   

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmxuser','bmxgrup')   
 
   LET l_sql = "SELECT bmx01,bmx02,bmx07,bmx10,'',bmx13,gem02,bmxoriu,gen02,ta_bmx03,'', ",  
               "       '','',0,'',  ", 
               "       '','','','','','','','','','' ",  
               "  FROM gem_file,gen_file,bmx_file  ",
               " WHERE bmxoriu=gen01 AND bmx13=gem01 AND ",
               "       bmx04 <> 'X' AND ",tm.wc CLIPPED,
               " Order by 1"
  
   PREPARE r701_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   DECLARE r701_c0 CURSOR FOR r701_prepare1
 

   FOREACH r701_c0 INTO sr.*
      IF STATUS THEN CALL cl_err('for bmx:',STATUS,1) EXIT FOREACH END IF

     ## ECN變更原因
     SELECT azf03 INTO sr.azf03 
       FROM azf_file,bmx_file
      WHERE azf01 = ta_bmx03
        AND azf02='2' AND azf09='G'
        AND bmx01 = sr.bmx01

     ##申請人姓名
     SELECT gen02 INTO sr.gen0210 FROM gen_file
      WHERE gen01 = sr.bmx10

     LET l_sql = "SELECT ta_bmg01,listagg(bmg03,',') within group (order by bmg02) ",
                 "  FROM bmg_file ",
                 " WHERE bmg01 = '",sr.bmx01,"' ",
                 " GROUP BY ta_bmg01 "
     
     PREPARE r701_bmglist FROM l_sql
     DECLARE r701_bmgc CURSOR FOR r701_bmglist
     FOREACH r701_bmgc INTO sr.ta_bmg01,sr.bmg03

        SELECT tc_dic05 INTO sr.tc_dic05
          FROM tc_dic_file
         WHERE tc_dic01='abmi701' AND tc_dic02='ta_bmg01'
           AND tc_dic04 = sr.ta_bmg01

        CASE sr.ta_bmg01
             WHEN "10"  LET sr.bmg0310=sr.bmg03
             WHEN "20"  LET sr.bmg0320=sr.bmg03
             WHEN "30"  LET sr.bmg0330=sr.bmg03
             WHEN "40"  LET sr.bmg0340=sr.bmg03
             WHEN "50"  LET sr.bmg0350=sr.bmg03
             WHEN "60"  LET sr.bmg0360=sr.bmg03
             WHEN "70"  LET sr.bmg0370=sr.bmg03
             WHEN "80"  LET sr.bmg0380=sr.bmg03
             WHEN "90"  LET sr.bmg0390=sr.bmg03
             WHEN "100"  LET sr.bmg03100=sr.bmg03
        END CASE

     END FOREACH

      EXECUTE insert_prep USING sr.*        
    
 
   END FOREACH

 
   
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'bmx01,bmx02')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05   
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED,"|"
    
    LET g_cr_table = l_table                 #主報表的temp table名稱
  
    LET g_cr_apr_key_f = "bmx01"             #報表主鍵欄位名稱，用"|"隔開 

 
     CALL cl_prt_cs3('cbmr701','cbmr701',l_sql,g_str)


END FUNCTION 
 
