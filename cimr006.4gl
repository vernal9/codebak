# Prog. Version..: '5.30.24-17.04.13(00004)'     #
#
# Pattern name...: cimr006.4gl
# Descriptions...: 会员邮递标签
# Date & Author..: #FUN-A60075 10/06/28 By sunchenxu
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.TQC-C10039 12/01/12 By wangrr 整合單據列印EF簽核
# Modify.........: No.TQC-C20203 12/02/15 By dongsz 套表不需添加簽核內容

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,    
              ima35       LIKE ima_file.ima35,   #倉
              ima36       LIKE ima_file.ima36,   #儲
              lot         LIKE ima_file.imaud01, #批
              ima73       LIKE ima_file.ima73,   #入庫日      
              paper       LIKE type_file.num5,   #列印張數
              more    LIKE type_file.chr1       # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
DEFINE   l_cnt           LIKE type_file.num5
DEFINE   l_tlf905        LIKE tlf_file.tlf905

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CIM")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql = "ima01.ima_file.ima01,",    #料號
               "ima02.ima_file.ima02,",   #品名 
               "ima021.ima_file.ima021,",  #規格 
               "ima35.ima_file.ima35,",    #倉
               "ima36.ima_file.ima36,",    #儲
               "lot.ima_file.imaud01,",    #批
               "ima73.ima_file.ima73"      #入庫日

    
   LET l_table = cl_prt_temptable('cimr006',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?,?,?,?,?, ?,?) "  
    
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)            
    END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL cimr006_tm(0,0)        # Input print condition
      ELSE CALL cimr006()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION cimr006_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_direct       LIKE type_file.chr1,  
          l_cmd          LIKE type_file.chr1000
 
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW cimr006_w AT p_row,p_col WITH FORM "cim/42f/cimr006" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.paper    = 1
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ima01,tlf905

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      

         AFTER FIELD tlf905
            LET l_tlf905 = GET_FLDBUF(tlf905)
            IF cl_null(l_tlf905) THEN
               LET tm.ima73 = g_today
            END IF
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01
               
            END CASE
            
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
         LET INT_FLAG = 0 CLOSE WINDOW cimr006_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF

      
      DISPLAY BY NAME tm.ima35,tm.ima36,tm.lot,tm.ima73,tm.paper,tm.more
      
      INPUT BY NAME tm.ima35,tm.ima36,tm.lot,tm.ima73,tm.paper,tm.more  WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         

         BEFORE FIELD paper
            IF cl_null(tm.paper) THEN
               LET tm.paper=1
            END IF

         AFTER FIELD ima35
            IF NOT cl_null(tm.ima35) THEN
               LET l_cnt = 0
               SELECT 1 INTO l_cnt FROM imd_file
                 WHERE imd01 = tm.ima35
               IF l_cnt <> 1 THEN
                  CALL cl_err(tm.ima35,'aic-034',1)
                  NEXT FIELD ima35
               END IF
            END IF

         AFTER FIELD ima36
            IF NOT cl_null(tm.ima36) THEN
               LET l_cnt = 0
               SELECT 1 INTO l_cnt FROM ime_file
                 WHERE ime01 = tm.ima35
                   AND ime02 = tm.ima36
               IF l_cnt <> 1 THEN
                  CALL cl_err(tm.ima36,'aps-715',1)
                  NEXT FIELD ima36
               END IF
            END IF
            
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
            END IF

         ON ACTION controlp
            CASE
               WHEN INFIELD(ima35)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imd"
                  LET g_qryparam.arg1     = 'SW'
                  CALL cl_create_qry() RETURNING tm.ima35
                  DISPLAY BY NAME tm.ima35
                  NEXT FIELD ima35

                WHEN INFIELD(ima36)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ime01"
                  LET g_qryparam.arg1     = tm.ima35
                  CALL cl_create_qry() RETURNING tm.ima36
                  DISPLAY BY NAME tm.ima36
                  NEXT FIELD ima36

            END CASE
           
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
            
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
            
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
         LET INT_FLAG = 0 CLOSE WINDOW cimr006_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='cimr006'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('cimr006','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('cimr006',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW cimr006_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL cimr006()
      ERROR ""
   END WHILE
   CLOSE WINDOW cimr006_w
END FUNCTION

FUNCTION cimr006()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     STRING,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,
          l_sum     LIKE type_file.num5,    
          sr        RECORD 
                    ima01  LIKE ima_file.ima01,  
                    ima02  LIKE ima_file.ima02,
                    ima021 LIKE ima_file.ima021,
                    ima35  LIKE ima_file.ima35, 
                    ima36  LIKE ima_file.ima36,
                    lot    LIKE ima_file.imaud01,
                    ima73  LIKE ima_file.ima73
                    END RECORD
    
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

    CALL cl_del_data(l_table)
    INITIALIZE sr.* TO NULL

    IF NOT cl_null(l_tlf905) THEN
    LET l_sql = " SELECT ima01,ima02,ima021,tlf902,tlf903,tlf904,tlf06 ", 
                "   FROM ima_file ",
                "   LEFT JOIN tlf_file ON ima01=tlf01 ",
                " WHERE ",tm.wc CLIPPED
    ELSE
    LET l_sql = " SELECT ima01,ima02,ima021,'','','','' ", 
                "   FROM ima_file ",
                " WHERE ",tm.wc CLIPPED
    END IF 
    PREPARE cimr006_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
    DECLARE cimr006_curs1 CURSOR FOR cimr006_prepare1

    FOREACH cimr006_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
         IF NOT cl_null(tm.ima35) THEN
            LET sr.ima35=tm.ima35
         END IF
         IF NOT cl_null(tm.ima36) THEN
            LET sr.ima36=tm.ima36
         END IF
         IF NOT cl_null(tm.lot) THEN
            LET sr.lot=tm.lot
         END IF
         IF NOT cl_Null(tm.ima73) THEN
            LET sr.ima73=tm.ima73
         END IF
   
         FOR l_sum=1 TO tm.paper
     
         EXECUTE  insert_prep  USING  
         sr.ima01,sr.ima02,sr.ima021,sr.ima35,sr.ima36,sr.lot,sr.ima73    
         END FOR
    
   END FOREACH
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = tm.wc
       
      CALL cl_prt_cs3('cimr006','cimr006',l_sql,g_str)  

END FUNCTION
