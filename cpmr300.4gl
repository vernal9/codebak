# Prog. Version..: '5.30.24-17.04.13(00009)'     #
#
# Pattern name...: cpmr300.4gl
# Descriptions...: 模具資料列印
# Date & Author..: 20221011 By momo


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
 
   LET g_sql="tc_evad01.tc_evad_file.tc_evad01,",
             "tc_evad02.tc_evad_file.tc_evad02,",
             "tc_evad03.tc_evad_file.tc_evad03,",
             "tc_evad04.tc_evad_file.tc_evad04,",
             "tc_evad05.tc_evad_file.tc_evad05,",
             "tc_evad06.tc_evad_file.tc_evad06,",
             "tc_evad07.tc_evad_file.tc_evad07,",
             "tc_evad08.tc_evad_file.tc_evad08,",
             "tc_evad09.tc_evad_file.tc_evad09,",
             "tc_evad10.tc_evad_file.tc_evad10,",
             "tc_evad11.tc_evad_file.tc_evad11,",
             "tc_evad12.tc_evad_file.tc_evad12,",
             "tc_evad13.tc_evad_file.tc_evad13,",
             "tc_evad14.tc_evad_file.tc_evad14,",
             "tc_evad15.tc_evad_file.tc_evad15,",
             "tc_evad16.tc_evad_file.tc_evad16,",
             "tc_evae01.tc_evae_file.tc_evae01,",
             "tc_evae02.tc_evae_file.tc_evae02,",
             "tc_evae03.tc_evae_file.tc_evae03,",
             "tc_evae04.tc_evae_file.tc_evae04,",
             "tc_evae05.tc_evae_file.tc_evae05,",
             "tc_evae06.tc_evae_file.tc_evae06,",            
             "tc_evaf05.tc_evaf_file.tc_evaf05,",            
             "tc_evaf06.tc_evaf_file.tc_evaf06,",            
             "tc_evaf07.tc_evaf_file.tc_evaf07,",            
             "tc_evaf09.tc_evaf_file.tc_evaf09,",            
             "pmc03.pmc_file.pmc03,",
             "pmc03_2.pmc_file.pmc03,",
             "gen02.gen_file.gen02,",
             "gem02.gem_file.gem02,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "pmc081.pmc_file.pmc081,",
             "pmc091.pmc_file.pmc091,",
             "pmc10.pmc_file.pmc10,",
             "pmc11.pmc_file.pmc11,",
             "pmc24.pmc_file.pmc24,",
             "pmc1916.pmc_file.pmc1916,",
             "azi03.type_file.num10,",
             "azi04.azi_file.azi04,",
             "azi05.azi_file.azi05,",
             "azi07.azi_file.azi07,",
             "sign_type.type_file.chr1,",  # 簽核方式
             "sign_img.type_file.blob,",   # 簽核圖檔
             "sign_show.type_file.chr1,",  # 是否顯示簽核資料(Y/N)
             "sign_str.type_file.chr1000"  # sign_str

   LET  l_table = cl_prt_temptable('cpmr300',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ? )"                     
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
      THEN CALL cpmr300_tm(0,0)             # Input print condition
      ELSE
           CALL cpmr300()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION cpmr300_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,       
       l_cmd        LIKE type_file.chr1000       
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW cpmr300_w AT p_row,p_col WITH FORM "cpm/42f/cpmr300"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   CALL cl_opmsg('p')
   
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tc_evad01,tc_evad02,tc_evad04,tc_evad06,tc_evad13
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
            WHEN INFIELD(tc_evad01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="cq_tc_evad01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_evad01
              NEXT FIELD tc_evad01          
            WHEN INFIELD(tc_evad04)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_evad04
              NEXT FIELD tc_evad04
            WHEN INFIELD(tc_evad06)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_pmc2"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_evad06
              NEXT FIELD tc_evad06
            WHEN INFIELD(tc_evad03)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_evad03
              NEXT FIELD tc_evad03
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
      LET INT_FLAG = 0 CLOSE WINDOW cpmr300_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW cpmr300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cpmr300'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cpmr300','9031',1)
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
         CALL cl_cmdat('cpmr300',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cpmr300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cpmr300()
   ERROR ""
END WHILE
   CLOSE WINDOW cpmr300_w
END FUNCTION
 
FUNCTION cpmr300()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       
          l_za05    LIKE type_file.chr1000,       
          sr        RECORD
                    tc_evad      RECORD LIKE tc_evad_file.*,
                    tc_evae      RECORD LIKE tc_evae_file.*,
                    tc_evaf      RECORD LIKE tc_evaf_file.*
                    END RECORD
   DEFINE l_pmc03   LIKE pmc_file.pmc03,
          l_gen02   LIKE gen_file.gen02,
          l_gem02   LIKE gem_file.gem02
   DEFINE l_pmc03_2 LIKE pmc_file.pmc03
   DEFINE l_azi03   LIKE type_file.num10
   DEFINE l_azi04   LIKE azi_file.azi04
   DEFINE l_azi05   LIKE azi_file.azi05
   DEFINE l_azi07   LIKE azi_file.azi07
   DEFINE l_cnt     LIKE type_file.num5 
   DEFINE l_ima02   LIKE ima_file.ima02          
   DEFINE l_ima021  LIKE ima_file.ima021         
   DEFINE l_pmc081  LIKE pmc_file.pmc081 
   DEFINE l_pmc091  LIKE pmc_file.pmc091 
   DEFINE l_pmc10   LIKE pmc_file.pmc10 
   DEFINE l_pmc11   LIKE pmc_file.pmc11 
   DEFINE l_pmc24   LIKE pmc_file.pmc24
   DEFINE l_pmc1916 LIKE pmc_file.pmc1916
   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY          
      

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cpmr300' 
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tc_evaduser', 'tc_evadgrup')
 
 
     LET l_sql="SELECT * FROM tc_evad_file,tc_evae_file b ",
               " WHERE tc_evad01=tc_evae01 ",
               "   AND ",tm.wc CLIPPED,
               "   AND tc_evadacti = 'Y' ",   # 有效資料
               "   AND b.tc_evae02 = (SELECT MAX(tc_evae02) FROM tc_evae_file bb WHERE b.tc_evae01=bb.tc_evae01 ) ",
               " ORDER BY tc_evad01,b.tc_evae03 "    
     PREPARE cpmr300_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE cpmr300_curs1 CURSOR FOR cpmr300_prepare1
 
  
     FOREACH cpmr300_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.tc_evad.tc_evad04       
         SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.tc_evad.tc_evad06
         SELECT pmc03 INTO l_pmc03_2 FROM pmc_file WHERE pmc01=sr.tc_evad.tc_evad16
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.tc_evad.tc_evad03
         SELECT ima02,ima021 INTO l_ima02,l_ima021
           FROM ima_file
          WHERE ima01 = sr.tc_evae.tc_evae03
    
       SELECT pmc081,pmc091,pmc10,pmc11,pmc24,pmc1916
        INTO l_pmc081,l_pmc091,l_pmc10,l_pmc11,l_pmc24,l_pmc1916     
        FROM pmc_file
       WHERE pmc01 =sr.tc_evad.tc_evad16            #供應商編號

       SELECT sum(distinct pmn88) INTO l_azi03
         FROM tc_evae_file,pmn_file
        WHERE tc_evae05=pmn01 AND tc_evae06=pmn02
          AND tc_evae01 = sr.tc_evad.tc_evad01
        GROUP BY tc_evae05,tc_evae06

       #進度說明
       SELECT * INTO sr.tc_evaf.* FROM tc_evaf_file
        WHERE tc_evaf01 = sr.tc_evad.tc_evad01
          AND tc_evaf08 IS NULL

       IF g_bgjob = 'Y' THEN
          IF sr.tc_evaf.tc_evaf04='M07' THEN
             CONTINUE FOREACH
          END IF
       END IF

       EXECUTE insert_prep USING sr.tc_evad.tc_evad01,sr.tc_evad.tc_evad02,sr.tc_evad.tc_evad03,
                                 sr.tc_evad.tc_evad04,sr.tc_evad.tc_evad05,sr.tc_evad.tc_evad06,
                                 sr.tc_evad.tc_evad07,sr.tc_evad.tc_evad08,sr.tc_evad.tc_evad09,
                                 sr.tc_evad.tc_evad10,sr.tc_evad.tc_evad11,sr.tc_evad.tc_evad12,
                                 sr.tc_evad.tc_evad13,sr.tc_evad.tc_evad14,sr.tc_evad.tc_evad15,
                                 sr.tc_evad.tc_evad16,
                                 sr.tc_evae.tc_evae01,sr.tc_evae.tc_evae02,sr.tc_evae.tc_evae03,
                                 sr.tc_evae.tc_evae04,sr.tc_evae.tc_evae05,sr.tc_evae.tc_evae06,                                
                                 sr.tc_evaf.tc_evaf05,sr.tc_evaf.tc_evaf06,sr.tc_evaf.tc_evaf07,
                                 sr.tc_evaf.tc_evaf09,
                                 l_pmc03,l_pmc03_2,
                                 l_gen02,l_gem02,
                                 l_ima02,l_ima021,
                                 l_pmc081,l_pmc091,l_pmc10,l_pmc11,l_pmc24,l_pmc1916,
                                 l_azi03,l_azi04,l_azi05,l_azi07,"",l_img_blob,"N",""      
       DISPLAY "EXECUTE:",STATUS     #odyliao test
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'tc_evad01,tc_evad02,tc_evad04,tc_evad06')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc
     LET g_cr_table = l_table      #主報表的temp table名稱
     LET g_cr_apr_key_f = "tc_evad01"  #報表主鍵欄位名稱，用"|"隔開
     CALL cl_prt_cs3('cpmr300','cpmr300',g_sql,g_str)
END FUNCTION
 
