# Prog. Version..: '5.30.24-17.04.13(00005)'     #
#
# Pattern name...: cxmr401.4gl
# Descriptions...: 客供標籤列印
# Date & Author..: 20201126 By momo
# Modify.........: No.2011255486    20201126 By momo 訂單選配件列印或工單客供件列印
# Modify.........: No.2108106746    21/08/11 By Ruby 增加產品規格
# Modify.........: No.2110067060    20211007 By momo 使用工單列印時排除已存在訂單選配
# Modify.........: No.22100023      20221024 By momo 增加列印條件選配數量大於0
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,       #TQC-630166  # Where condition
              a       LIKE type_file.chr1,   #客供來源為工單
              more    LIKE type_file.chr1                  #No.FUN-680137 VARCHAR(1)    # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
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
   LET tm.a = ARG_VAL(8)   
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_xml.subject = ARG_VAL(12)
   LET g_xml.body = ARG_VAL(13)
   LET g_xml.recipient = ARG_VAL(14)   
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL cxmr401_tm(0,0)        # Input print condition
      ELSE CALL cxmr401()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION cxmr401_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01  
   DEFINE p_row,p_col    LIKE type_file.num5,      
          l_cmd          LIKE type_file.chr1000      
 
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW cxmr401_w AT p_row,p_col WITH FORM "cxm/42f/cxmr401" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea01,oea02
                               
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
           WHEN INFIELD(oeo04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oeo04
              NEXT FIELD oeo04
          WHEN INFIELD(oea01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_oea01"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO oea01
             NEXT FIELD oea01
        END CASE
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
 
  IF g_action_choice = "locale" THEN
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()   #FUN-550037(smin)
     CONTINUE WHILE
  END IF
 
  IF INT_FLAG THEN
     LET INT_FLAG = 0 CLOSE WINDOW cxmr401_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time 
     EXIT PROGRAM
        
  END IF
  IF tm.wc = ' 1=1' THEN 
     CALL cl_err('','9046',0) CONTINUE WHILE
  END IF
  INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
    ON ACTION locale
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()   #FUN-550037(smin)
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
 
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
 
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
  
    ON ACTION exit
       LET INT_FLAG = 1
       EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
  END INPUT
  IF INT_FLAG THEN
     LET INT_FLAG = 0 CLOSE WINDOW cxmr401_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time 
     EXIT PROGRAM
        
  END IF
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
            WHERE zz01='cxmr401'
     IF SQLCA.sqlcode OR l_cmd IS NULL THEN
        CALL cl_err('cxmr401','9031',1)
     ELSE
        LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
        LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                        " '",tm.a CLIPPED,"'" ,
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_xml.subject CLIPPED,"'",
                        " '",g_xml.body CLIPPED,"'",
                        " '",g_xml.recipient CLIPPED,"'",                        
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
        CALL cl_cmdat('cxmr401',g_time,l_cmd)    # Execute cmd at later time
     END IF
     CLOSE WINDOW cxmr401_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time 
     EXIT PROGRAM
  END IF
  CALL cl_wait()
  CALL cxmr401()
  ERROR ""
END WHILE
   CLOSE WINDOW cxmr401_w
END FUNCTION
 
FUNCTION cxmr401()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680137 VARCHAR(1000)
          l_chr        LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE type_file.chr20,       #No.FUN-680137 VARCHAR(20)
          sr               RECORD 
                                  oeo01  LIKE oeo_file.oeo01,  
                                  oeo03  LIKE oeo_file.oeo03,  
                                  oeo04  LIKE oeo_file.oeo04,  
                                  ima021 LIKE ima_file.ima021,  
                                  ima35  LIKE ima_file.ima35,  
                                  ima36  LIKE ima_file.ima36,
                                  ima021_1 LIKE ima_file.ima021  #210811 by ruby
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     IF tm.a = 'N' THEN 
        #LET l_sql = "SELECT oea01 sn,LPAD(oeo03,3,'0') oeb03,ima01,ima021,ima35,ima36 ",                                             #210811 mark by ruby
        #            "  FROM ima_file,oea_file,oeo_file ",                                                                            #210811 mark by ruby
        #            "  WHERE oeo04=ima01 AND oeo01=oea01 AND oeaconf <> 'X' ",                                                       #210811 mark by ruby
        LET l_sql = "SELECT oea01 sn,LPAD(oeo03,3,'0') oeb03,a.ima01,a.ima021,a.ima35,a.ima36,b.ima021 as ima021_1",                  #210811 add by ruby
                    "  FROM oea_file,oeb_file,oeo_file,ima_file a,ima_file b ",                                                       #210811 add by ruby
                    "  WHERE oea01=oeb01 AND oeo01=oea01 AND oeo03=oeb03 AND oeo04=a.ima01 AND oeb04=b.ima01 AND oeaconf <> 'X' ",    #210811 add by ruby                                                           #210811 add by ruby
                    "    AND oeo09 > 0 ",                                                                                             #20221024
                    "    AND ",tm.wc
     ELSE
        #LET l_sql = "SELECT ta_sfb01 sn,0 oeb03,ima01,ima021,ima35,ima36 ",                                                          #210811 mark by ruby
        #            "  FROM ima_file,oea_file,sfa_file,sfb_file ",                                                                   #210811 mark by ruby
        #            "  WHERE sfb01=sfa01 AND sfb87 <> 'X' AND sfa03 LIKE '5%' ",                                                     #210811 mark by ruby
        #            "    AND ima01=sfa03 AND SUBSTR(ta_sfb01,1,15) = oea01 AND ",tm.wc                                               #210811 mark by ruby
        LET l_sql = "SELECT ta_sfb01 sn,0 oeb03,a.ima01,a.ima021,a.ima35,a.ima36,b.ima021 as ima021_1 ",                              #210811 add by ruby
                    "  FROM oea_file,sfa_file,sfb_file,ima_file a,ima_file b ",                                                       #210811 add by ruby
                    "  WHERE sfb01=sfa01 AND sfb87 <> 'X' AND sfa03 LIKE '5%' ",                                                      #210811 add by ruby
                    "    AND a.ima01=sfa03 AND b.ima01=sfb05 AND SUBSTR(ta_sfb01,1,15) = oea01  ",                                    #210811 add by ruby
                    "    AND sfa05 > 0 ",                                                                                             #20211007 add by momo 
                    #"    AND NOT EXISTS(SELECT 1 FROM oeo_file WHERE oeo01=oea01 AND sfa03=oeo04) AND ",tm.wc                        #20211007 add by momo    #220309 mark by ruby
                    "    AND NOT EXISTS(SELECT 1 FROM oeo_file WHERE oeo01=oea01 AND SUBSTR(ta_sfb01,16,3)=LPAD(oeo03,3,'0') AND sfa03=oeo04) AND ",tm.wc      #220309 add by ruby
                    
     END IF            
 
     CALL cl_prt_cs1('cxmr401','cxmr401',l_sql,'')
END FUNCTION
