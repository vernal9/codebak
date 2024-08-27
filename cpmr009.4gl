# Prog. Version..: '5.30.24-17.04.13(00004)'     #
#
# Pattern name...: cpmr009.4gl
# Descriptions...: 依採購單料件標籤列印
# Date & Author..: #24080028 20240823 By momo


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,    
              paper       LIKE type_file.num5,    #列印張數
              i_vendor    LIKE type_file.chr10    # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
DEFINE   l_cnt           LIKE type_file.num5
DEFINE   g_pmn           DYNAMIC ARRAY OF RECORD
                         choice   LIKE type_file.chr1,
                         pmn01    LIKE pmn_file.pmn01,
                         pmn02    LIKE pmn_file.pmn02,
                         pmn04    LIKE pmn_file.pmn04,
                         pmn041   LIKE pmn_file.pmn041,
                         ima021   LIKE ima_file.ima021,
                         pmn56    LIKE pmn_file.pmn56,
                         pmn33    LIKE pmn_file.pmn33,
                         pmn20    LIKE pmn_file.pmn20,
                         vendor   LIKE pmm_file.pmm09
                         END RECORD
DEFINE   g_cnt           LIKE type_file.num10 
DEFINE   l_ac            LIKE type_file.num5

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql = "pmn04.pmn_file.pmn04,",      #料號
               "ima021.ima_file.ima021,",    #規格 
               "pmn56.pmn_file.pmn56,",      #批號
               "pmn33.pmn_file.pmn33,",      #交貨日
               "vendor.pmm_file.pmm09"       #供應商代號

    
   LET l_table = cl_prt_temptable('cpmr009',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?,?,?,?,?) "  
    
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
   CALL cpmr009_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION cpmr009_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_direct       LIKE type_file.chr1,  
          l_cmd          LIKE type_file.chr1000
 
   LET p_row = 6 LET p_col = 16
   CLEAR FORM
 
   OPEN WINDOW cpmr009_w AT p_row,p_col WITH FORM "cpm/42f/cpmr009" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON pmm01,pmm09,pmn04,pmm04,pmn33

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      

         ON ACTION controlp
            CASE
               WHEN INFIELD(pmm01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmm12"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmm01
                  NEXT FIELD pmm01
               WHEN INFIELD(pmm09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmm09
                  NEXT FIELD pmm09
               WHEN INFIELD(pmn04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmn041"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmn041
                  NEXT FIELD pmn041
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
         LET INT_FLAG = 0 CLOSE WINDOW cpmr009_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF

      
      DISPLAY BY NAME tm.paper,tm.i_vendor
      
      INPUT BY NAME tm.paper,tm.i_vendor  WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
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
         LET INT_FLAG = 0 CLOSE WINDOW cpmr009_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='cpmr009'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('cpmr009','9031',1)
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
            CALL cl_cmdat('cpmr009',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW cpmr009_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r009_p1()
      CALL cpmr009()
      ERROR ""
   END WHILE
   CLOSE WINDOW cpmr009_w
END FUNCTION

FUNCTION cpmr009()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     STRING,                       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_sum     LIKE type_file.num5,    
          l_i       LIKE type_file.num5   
    
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

    CALL cl_del_data(l_table)

    FOR l_i = 1 TO g_cnt
        IF g_pmn[l_i].choice='N' THEN
           CONTINUE FOR
        END IF
        FOR l_sum=1 TO g_pmn[l_i].pmn20
            EXECUTE insert_prep  USING  
                    g_pmn[l_i].pmn04,g_pmn[l_i].ima021,
                    g_pmn[l_i].pmn56,g_pmn[l_i].pmn33,g_pmn[l_i].vendor
          END FOR
    END FOR

    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = tm.wc
       
    CALL cl_prt_cs3('cpmr009','cpmr009',l_sql,g_str)  

END FUNCTION

FUNCTION r009_p1()
   DEFINE l_exit LIKE type_file.chr1
   DEFINE l_sql STRING

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
   LET l_sql = "SELECT 'N',pmn01,pmn02,pmn04,pmn041,ima021,pmn56,pmn33,pmn20,' ' ",
               "  FROM pmm_file,pmn_file ",
               "  LEFT JOIN ima_file ON ima01=pmn04 ",
               " WHERE pmm01=pmn01 AND pmm18='Y' ",
               "   AND pmn04 NOT LIKE 'MISC%' AND ",tm.wc CLIPPED,
               " ORDER BY pmn33"

   PREPARE r009p1_prepare FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('PREPARE:',SQLCA.SQLCODE,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     
      EXIT PROGRAM
   END IF 

   DECLARE r009p1_curs CURSOR FOR r009p1_prepare
  
   CALL g_pmn.clear()
   LET g_cnt = 1
   FOREACH r009p1_curs INTO g_pmn[g_cnt].*
      IF SQLCA.sqlcode THEN                                  #有問題
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_pmn[g_cnt].vendor = tm.i_vendor
      IF NOT cl_null(tm.paper) THEN
         LET g_pmn[g_cnt].pmn20 = tm.paper
      END IF
      LET g_cnt = g_cnt + 1                                  #累加筆數 
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_pmn.deleteElement(g_cnt)    
   LET g_cnt = g_cnt - 1                                     #正確總筆數
   #筆數為零則跳出訊息並RETURN
   IF g_cnt = 0 THEN 
      CALL cl_err('','agl-118',1) 
      LET INT_FLAG = 1 
      RETURN
   END IF
   CALL SET_COUNT(g_cnt)                                     #告之DISPALY ARRAY
   WHILE TRUE
     LET l_exit = 'y'
     INPUT ARRAY g_pmn WITHOUT DEFAULTS FROM s_pmn.*         #顯示並進行選擇
       ATTRIBUTE(COUNT=g_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)

       BEFORE ROW
           LET l_ac = ARR_CURR()

       AFTER FIELD choice
           IF g_pmn[l_ac].choice NOT MATCHES '[YN]' THEN
              NEXT FIELD choice
           END IF 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION select_all
         CALL r009_sel_all("Y")

      ON ACTION select_non
         CALL r009_sel_all("N")

      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmn),'','')

      END INPUT
      IF INT_FLAG THEN 
         CALL g_pmn.clear()
         LET INT_FLAG=0
         CALL cpmr009_tm(0,0) 
      END IF   #使用者中斷
      IF l_exit = 'y' THEN EXIT WHILE END IF
  END WHILE

END FUNCTION

FUNCTION r009_sel_all(p_value)
  DEFINE p_value      LIKE type_file.chr1
  DEFINE l_i          LIKE type_file.num10

  FOR l_i = 1 TO g_pmn.getLength()
     LET g_pmn[l_i].choice = p_value
  END FOR

END FUNCTION
