# Prog. Version..: '5.30.24-17.04.13(00009)'     #
#
# Pattern name...: cpmr100.4gl
# Descriptions...: 固定資產評估單列印
# Date & Author..: 20220826 By momo


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD                               # Print condition RECORD
              wc      LIKE type_file.chr1000,      # Where condition
              more    LIKE type_file.chr1          # Prog. Version..: '5.30.24-17.04.13(01)              # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5       #count/index for any purpose        
DEFINE   g_msg           LIKE type_file.chr1000    
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_sql="tc_evaa01.tc_evaa_file.tc_evaa01,",
             "tc_evaa02.tc_evaa_file.tc_evaa02,",
             "tc_evaa03.tc_evaa_file.tc_evaa03,",
             "tc_evaa04.tc_evaa_file.tc_evaa04,",
             "tc_evaa05.tc_dic_file.tc_dic05,",
             "tc_evaa07.tc_evaa_file.tc_evaa07,",
             "tc_evaa09.tc_evaa_file.tc_evaa09,",
             "tc_evaa10.tc_evaa_file.tc_evaa10,",
             "tc_evaa11.tc_evaa_file.tc_evaa11,",
             "tc_evaa12.tc_evaa_file.tc_evaa12,",
             "tc_evaa13.tc_evaa_file.tc_evaa13,",
             "tc_evab01.tc_evab_file.tc_evab01,",
             "tc_evab02.tc_evab_file.tc_evab02,",
             "tc_evab03.tc_evab_file.tc_evab03,",
             "tc_evab04.tc_evab_file.tc_evab04,",
             "tc_evab05.tc_evab_file.tc_evab05,",
             "tc_evab06.tc_evab_file.tc_evab06,",            
             "pmc03.pmc_file.pmc03,",
             "gen02.gen_file.gen02,",
             "gem02.gem_file.gem02,",
             "azi03.azi_file.azi03,",
             "azi04.azi_file.azi04,",
             "azi05.azi_file.azi05,",
             "azi07.azi_file.azi07,",
             "sign_type.type_file.chr1,",  # 簽核方式
             "sign_img.type_file.blob,",   # 簽核圖檔
             "sign_show.type_file.chr1,",  # 是否顯示簽核資料(Y/N)
             "sign_str.type_file.chr1000"  # sign_str

   LET  l_table = cl_prt_temptable('cpmr100',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?)"                     
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
 
   INITIALIZE tm.* TO NULL            # Default condition

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
   IF cl_null(tm.wc)
      THEN CALL cpmr100_tm(0,0)             # Input print condition
      ELSE
           CALL cpmr100()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION cpmr100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,       
       l_cmd        LIKE type_file.chr1000       
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW cpmr100_w AT p_row,p_col WITH FORM "cpm/42f/cpmr100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    CALL cl_set_combo_items_plus("tc_evaa05","cpmt001","tc_evaa05")
 
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   CALL cl_opmsg('p')
   
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tc_evaa01,tc_evaa02,tc_evaa03,tc_evaa04,tc_evaa09,tc_evaa05
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
       ON ACTION locale
         CALL cl_show_fld_cont()                   
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

       ON ACTION CONTROLP
          CASE
            WHEN INFIELD(tc_evaa01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="cq_tc_evaa01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_evaa01
              NEXT FIELD tc_evaa01          
            WHEN INFIELD(tc_evaa04)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_evaa04
              NEXT FIELD tc_evaa04
            WHEN INFIELD(tc_evaa09)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_pmc2"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_evaa09
              NEXT FIELD tc_evaa09
            WHEN INFIELD(tc_evaa03)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_evaa03
              NEXT FIELD tc_evaa03
         END CASE
        
 
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
      LET INT_FLAG = 0 CLOSE WINDOW cpmr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #UI
   INPUT BY NAME tm.more  WITHOUT DEFAULTS
         
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
        
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
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
  
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT INPUT
         
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW cpmr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cpmr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cpmr100','9031',1)
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
         CALL cl_cmdat('cpmr100',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cpmr100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cpmr100()
   ERROR ""
END WHILE
   CLOSE WINDOW cpmr100_w
END FUNCTION
 
FUNCTION cpmr100()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       
          l_za05    LIKE type_file.chr1000,       
          sr        RECORD
                    tc_evaa      RECORD LIKE tc_evaa_file.*,
                    tc_evab      RECORD LIKE tc_evab_file.*
                    END RECORD
   DEFINE l_pmc03   LIKE pmc_file.pmc03,
          l_gen02   LIKE gen_file.gen02,
          l_gem02   LIKE gem_file.gem02
   DEFINE l_azi03   LIKE azi_file.azi03
   DEFINE l_azi04   LIKE azi_file.azi04
   DEFINE l_azi05   LIKE azi_file.azi05
   DEFINE l_azi07   LIKE azi_file.azi07
   DEFINE l_cnt     LIKE type_file.num5           
   DEFINE l_img_blob     LIKE type_file.blob
   DEFINE l_tc_dic05 LIKE tc_dic_file.tc_dic05
   LOCATE l_img_blob IN MEMORY          
      

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cpmr100' 
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tc_evaauser', 'tc_evaagrup')
 
 
     LET l_sql="SELECT * FROM tc_evaa_file,tc_evab_file ",
               " WHERE tc_evaa01=tc_evab01 ",
               "   AND ",tm.wc CLIPPED,
               "   AND tc_evaa06 != 'X' ",   # 不為已作廢的估價單
               " ORDER BY tc_evaa01,tc_evab02 "    
     PREPARE cpmr100_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE cpmr100_curs1 CURSOR FOR cpmr100_prepare1
 
  
     FOREACH cpmr100_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.tc_evaa.tc_evaa04       
         SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.tc_evaa.tc_evaa09
 
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.tc_evaa.tc_evaa03
      
       SELECT azi03,azi04,azi05,azi07 INTO l_azi03,l_azi04,l_azi05,l_azi07
         FROM azi_file
        WHERE azi01=sr.tc_evaa.tc_evaa10

       SELECT tc_dic05 INTO l_tc_dic05 FROM tc_dic_file
        WHERE tc_dic01='cpmt001' AND tc_dic02='tc_evaa05'
          AND tc_dic04 = sr.tc_evaa.tc_evaa05
 
       EXECUTE insert_prep USING sr.tc_evaa.tc_evaa01,sr.tc_evaa.tc_evaa02,sr.tc_evaa.tc_evaa03,
                                 sr.tc_evaa.tc_evaa04,l_tc_dic05,
                                 sr.tc_evaa.tc_evaa07,sr.tc_evaa.tc_evaa09,sr.tc_evaa.tc_evaa10,
                                 sr.tc_evaa.tc_evaa11,sr.tc_evaa.tc_evaa12,sr.tc_evaa.tc_evaa13,
                                 sr.tc_evab.tc_evab01,sr.tc_evab.tc_evab02,sr.tc_evab.tc_evab03,
                                 sr.tc_evab.tc_evab04,sr.tc_evab.tc_evab05,sr.tc_evab.tc_evab06,                                
                                 l_pmc03,l_gen02,l_gem02,
                                 l_azi03,l_azi04,l_azi05,l_azi07,"",l_img_blob,"N",""      
       DISPLAY "EXECUTE:",STATUS     #odyliao test
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'tc_evaa01,tc_evaa02,tc_evaa03,tc_evaa05,tc_evaa07')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc
     LET g_cr_table = l_table      #主報表的temp table名稱
     LET g_cr_apr_key_f = "tc_evaa01"  #報表主鍵欄位名稱，用"|"隔開
     CALL cl_prt_cs3('cpmr100','cpmr100',g_sql,g_str)
END FUNCTION
 
