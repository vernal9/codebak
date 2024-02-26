# Prog. Version..: '5.30.24-17.04.13(00005)'     #
#
# Pattern name...: cxmr412.4gl
# Descriptions...: 料件規格查詢與申請記錄列印
# Date & Author..: 20231225 By momo
# Modify.........: No.23120041   20231225 By momo 料件規格查詢與申請記錄列印

 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc      STRING,                    # Where condition
              more    LIKE type_file.chr1        # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose      
DEFINE   g_head1         STRING
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
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
   LET g_xml.subject = ARG_VAL(11)
   LET g_xml.body = ARG_VAL(12)
   LET g_xml.recipient = ARG_VAL(13)   
   LET g_rpt_name = ARG_VAL(14)  

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL cxmr412_tm(0,0)                # Input print condition
      ELSE CALL cxmr412()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION cxmr412_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01  
   DEFINE p_row,p_col    LIKE type_file.num5,      
          l_cmd          LIKE type_file.chr1000      
 
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW cxmr412_w AT p_row,p_col WITH FORM "cxm/42f/cxmr412" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tc_mpn03,tc_mpndate
                               
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()  
        LET g_action_choice = NULL     
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
 
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(tc_mpn03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_mpn03
              NEXT FIELD tc_mpn03
          
        END CASE
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT

         ON ACTION qbe_select
            CALL cl_qbe_select()

 
  END CONSTRUCT
 
  IF g_action_choice = "locale" THEN
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()  
     CONTINUE WHILE
  END IF
 
  IF INT_FLAG THEN
     LET INT_FLAG = 0 CLOSE WINDOW cxmr412_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time 
     EXIT PROGRAM
        
  END IF
  IF tm.wc = ' 1=1' THEN 
     CALL cl_err('','9046',0) CONTINUE WHILE
  END IF
  INPUT BY NAME tm.more WITHOUT DEFAULTS 
       
    BEFORE INPUT
       CALL cl_qbe_display_condition(lc_qbe_sn)
        
 
    ON ACTION locale
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()   
       LET g_action_choice = "locale"
 
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
  
    ON ACTION exit
       LET INT_FLAG = 1
       EXIT INPUT
       
    ON ACTION qbe_save
       CALL cl_qbe_save()
        
 
  END INPUT
  IF INT_FLAG THEN
     LET INT_FLAG = 0 CLOSE WINDOW cxmr412_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time 
     EXIT PROGRAM
        
  END IF
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
            WHERE zz01='cxmr412'
     IF SQLCA.sqlcode OR l_cmd IS NULL THEN
        CALL cl_err('cxmr412','9031',1)
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
                        " '",g_xml.subject CLIPPED,"'",
                        " '",g_xml.body CLIPPED,"'",
                        " '",g_xml.recipient CLIPPED,"'",                        
                        " '",g_rpt_name CLIPPED,"'"            
        CALL cl_cmdat('cxmr412',g_time,l_cmd)    # Execute cmd at later time
     END IF
     CLOSE WINDOW cxmr412_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time 
     EXIT PROGRAM
  END IF
  CALL cl_wait()
  CALL cxmr412()
  ERROR ""
END WHILE
   CLOSE WINDOW cxmr412_w
END FUNCTION
 
FUNCTION cxmr412()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,       
          l_order    ARRAY[5] OF LIKE type_file.chr20,       
          sr               RECORD 
                                  oeo01  LIKE oeo_file.oeo01,  
                                  oeo03  LIKE oeo_file.oeo03,  
                                  oeo04  LIKE oeo_file.oeo04,  
                                  ima021 LIKE ima_file.ima021,  
                                  ima35  LIKE ima_file.ima35,  
                                  ima36  LIKE ima_file.ima36,
                                  ima021_1 LIKE ima_file.ima021 
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR

     LET l_sql =  "SELECT tc_mpn00,tc_mpn01,tc_mpn02,tc_mpn03,occ02,",                 
                    "       tc_mpn04,tc_mpn05,tc_mpn06,tc_mpn07,tc_mpn08,tc_mpn09,",                                                       
                    "       tc_mpn10,tc_mpn19,tc_mpn11,tc_mpn12,tc_mpn13,tc_mpn14,tc_mpn15,",
                    "       tc_mpn16,",
                    "       to_char(tc_mpn17,'yyyy/mm/dd HH24:MI:SS'),",
                    "       to_char(tc_mpn18,'yyyy/mm/dd HH24:MI:SS'),",
                    "       to_char(tc_mpndate,'yyyy/mm/dd HH24:MI:SS'),",
                    "       tc_mpnoriu,tc_mpnplant,oeb01,'' ",
                    " FROM tc_mpn_file,occ_file ",
                    " LEFT JOIN (SELECT oeb01,oeb03,oea03,oea10 FROM oeb_file,oea_file WHERE oea01=oeb01) ",
                    "             ON oea10=tc_mpn01 and oea03=tc_mpn03 and oeb03=tc_mpn02",
                    " LEFT JOIN bma_file ON bma01 = tc_mpn06 ",
                    " WHERE tc_mpn03 = occ01 ",     
                    "   AND tc_mpn00='1' ",
                    "   AND tc_mpnplant='",g_plant,"' ",                                          
                    "   AND ",tm.wc
    
 
     CALL cl_prt_cs1('cxmr412','cxmr412',l_sql,'')
END FUNCTION