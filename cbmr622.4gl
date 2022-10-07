# Pattern name...: cbmr622.4gl
# Descriptions...: 多階產品自製率報表
# Input parameter:
# Return code....:
# Date & Author..: 20220517 By Ruby

DATABASE ds
                                        
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
    	    wc  	    LIKE type_file.chr1000, 
      		range     LIKE cdb_file.cdb13,    
       	  effective LIKE type_file.dat,         
          pur       LIKE type_file.chr1,    
          year      LIKE type_file.chr4,  
          month     LIKE type_file.chr2, 
          open      LIKE type_file.chr1,        #開啟報表否
       	  more	    LIKE type_file.chr1     
          END RECORD,
          g_bma01_a     LIKE bma_file.bma01     #產品結構單頭                
DEFINE   g_cnt          LIKE type_file.num10    
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        
DEFINE   l_table        STRING                                                                                                    
DEFINE   g_sql          STRING                  
DEFINE   g_str          STRING                  
DEFINE   g_no           LIKE type_file.num10 
DEFINE   l_num          LIKE type_file.num5    
 
DEFINE sum_self_cost   LIKE imb_file.imb116 #自製件材料加總
DEFINE sum_noself_cost LIKE imb_file.imb116 #非自製件材料加總 
DEFINE sum_other_cost  LIKE imb_file.imb116 #非材料加總不分是否自製
DEFINE sum_total       LIKE type_file.num15_3  #自製率計算

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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
                                                                                                           
   LET g_sql = " l_num.type_file.num5,",       #排序用
               " p_level.type_file.num5,",     #階數                                                                     
               " p_i.type_file.num5,",         #項次
               " g_bma01_a.bma_file.bma01,",   #QBE條件料號
               " bma01.bma_file.bma01,",       #主件料件編號
               " l_bma05.bma_file.bma05,",     #BOM發放日期
               " l_ima02.ima_file.ima02,",     #主件品名                                                                                     
               " l_ima021.ima_file.ima021,",   #主件規格                                                                                                                                                                        
               " l_ima08.ima_file.ima08,",     #主件來源碼                                                                                     
               " l_ima63.ima_file.ima63,",     #主件發料單位                                                                                   
               " l_ima55.ima_file.ima55,",     #主件生產單位                                                                                                                               
               " bmb03.bmb_file.bmb03,",       #元件料件編號
               " ima02.ima_file.ima02,",       #元件品名                                                                                     
               " ima021.ima_file.ima021,",     #元件規格
               " ima08.ima_file.ima08,",       #元件來源碼
               " imaud02.ima_file.imaud02,",   #自製件否
               " p_total.bmb_file.bmb06,",     #終階用量               
               " bmb10.bmb_file.bmb10,",       #元件單位
               " un_mcsts.imb_file.imb111,",   #材料單價                                                                                      
               " mcsts.imb_file.imb111,",      #材料成本
               " l_ad.type_file.num5,",        #製程項次
               " ecu02.ecu_file.ecu02,",       #製程編號
               " ecb03.ecb_file.ecb03,",       #製程序
               " ecb06.ecb_file.ecb06,",       #作業編號
               " ecb17.ecb_file.ecb17,",       #作業名稱
               " ecb08.ecb_file.ecb08,",       #工作站
               " eca03.eca_file.eca03,",       #部門
               " ecb19.ecb_file.ecb19,",       #標準工時(秒)
               " un_labcsts.imb_file.imb1131,",#人工單價                                                                                   
               " labcsts.imb_file.imb1131,",   #人工成本
               " un_exp1csts.imb_file.imb114,",#製費一單價                                                                                     
               " exp1csts.imb_file.imb114,",   #製造費用一
               " un_exp2csts.imb_file.imb115,",#製費二單價                                                                                     
               " exp2csts.imb_file.imb115,",   #製造費用二
               " un_outcsts.imb_file.imb116,", #委外單價                                                                                    
               " outcsts.imb_file.imb116 ,",   #委外加工       
               " sum_self_cost.imb_file.imb116,", #自製材料
               " sum_noself_cost.imb_file.imb116,", #非自製材料
               " sum_other_cost.imb_file.imb116,",  #非材料
               " sum_total.imb_file.imb116 "        #自製率計算     
                                                                                                                                                                                                         
   LET l_table = cl_prt_temptable('cbmr622',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                                                                                                      
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",                                                                            
               "        ?,?,?,?,?, ?,?,?,?,?, ",                                                                            
               "        ?,?,?,?,?, ?,?,?,?,?, ",                                                                            
               "        ?,?,?,?,?, ?,?,?,?,?  ) "                                                                          
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                                
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.effective = ARG_VAL(8)
   LET tm.range  = ARG_VAL(9)   
   LET tm.pur   = ARG_VAL(10)  
   LET tm.year  = ARG_VAL(11)
   LET tm.month = ARG_VAL(12)
   LET tm.open = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r622_tm(0,0)			        # Input print condition
      ELSE CALL cbmr622()			            # Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r622_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,   
          l_flag        LIKE type_file.num5,   
          l_one         LIKE type_file.chr1,   
          l_bdate       LIKE bmx_file.bmx07,
          l_edate       LIKE bmx_file.bmx08,
          l_bma01       LIKE bma_file.bma01,
          l_cmd		      LIKE type_file.chr1000 
   DEFINE l_bmx07_1     LIKE bmx_file.bmx07
   DEFINE l_bmx07_2     LIKE bmx_file.bmx07
   DEFINE l_year        LIKE ccz_file.ccz01
   DEFINE l_month       LIKE ccz_file.ccz02 
   DEFINE l_sql         STRING  
   DEFINE l_wc          STRING  
   
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 7 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 3 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 7
   END IF
   SELECT ccz01,ccz02 INTO l_year,l_month FROM ccz_file
 
   OPEN WINDOW r622_w AT p_row,p_col
        WITH FORM "cbm/42f/cbmr622"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			    # Default condition
   LET tm.effective = g_today	      # 有效日期   
   LET tm.pur  ='3'                 # 1.最近進價 2.最近核價 3.實際成本
   LET tm.year = l_year             # 現行年
   LET tm.month = l_month           # 現行月
   LET tm.open = 'Y'                # 預設開啟報表明細
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
  CONSTRUCT BY NAME tm.wc ON bma01,tc_aaf02
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
 
     ON ACTION controlp
         CASE
           WHEN INFIELD(bma01)      #主件料號 
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bma01
              NEXT FIELD bma01    
           WHEN INFIELD(tc_aaf02)  #型號標準件
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_tc_aaf"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_aaf02
              NEXT FIELD tc_aaf02
   
       OTHERWISE EXIT CASE
       END CASE

  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
  
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r622_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   LET l_one='N'
   IF tm.wc != ' 1=1' THEN
       LET l_cmd="SELECT COUNT(DISTINCT bma01),bma01 ",
                 " FROM bma_file ",
                 " LEFT JOIN tc_aaf_file ON bma01=tc_aaf02 ",
                 " WHERE bmaacti='Y' ",
                 "   AND ",tm.wc CLIPPED," GROUP BY bma01"
       PREPARE r622_precnt FROM l_cmd
       IF SQLCA.sqlcode THEN
          CALL cl_err('P0:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time 
          EXIT PROGRAM             
       END IF
       DECLARE r622_cnt
            CURSOR FOR r622_precnt
       OPEN r622_cnt
       FETCH r622_cnt INTO g_cnt,l_bma01
       IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2601',0)
            CONTINUE WHILE
       ELSE
           IF g_cnt=1 THEN
               LET l_one='Y'
           END IF
       END IF
       CLOSE r622_cnt
   END IF
 
   INPUT BY NAME tm.effective,tm.range,tm.pur,tm.year,tm.month,tm.open,tm.more WITHOUT DEFAULTS  

      AFTER FIELD pur
         IF tm.pur NOT MATCHES '[123]' THEN
             NEXT FIELD pur
         END IF
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
      ON ACTION CONTROLG 
         CALL cl_cmdask()	# Command execution
      
      ON ACTION CONTROLP 
         CASE
            WHEN INFIELD(range)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tc_cdb"              
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING tm.range
               DISPLAY BY NAME tm.range
               NEXT FIELD range
         END CASE
                              
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
                 
   END INPUT
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r622_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM         
   END IF
   
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='cbmr622'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cbmr622','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.effective CLIPPED,"'",
                         " '",tm.range CLIPPED,"'",                         
                         " '",tm.pur  CLIPPED,"'", 
                         " '",tm.year  CLIPPED,"'", 
                         " '",tm.month  CLIPPED,"'",                                                       
                         " '",tm.open  CLIPPED,"'",                                                       
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
         CALL cl_cmdat('cbmr622',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r622_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cbmr622()
   ERROR ""
END WHILE
   CLOSE WINDOW r622_w
END FUNCTION
 
FUNCTION r622_wc()
   DEFINE l_wc    LIKE type_file.chr1000    
 
   OPEN WINDOW r622_w2 AT 2,2
        WITH FORM "abm/42f/abmi600"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_locale("abmi600")
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT l_wc ON                               # 螢幕上取條件
        bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
        bmb02,bmb03,bmb04,bmb05,bmb06,bmb07,bmb08,bmb10
        FROM
        bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
        s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb04,s_bmb[1].bmb05,
        s_bmb[1].bmb06,s_bmb[1].bmb07,s_bmb[1].bmb08,s_bmb[1].bmb10
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
   END CONSTRUCT
 
   CLOSE WINDOW r622_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc CLIPPED
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉---------------------
# 從單頭讀取合乎條件的主件資料
# 處理元件及其相關的展開資料
FUNCTION cbmr622()
   DEFINE l_name	      LIKE type_file.chr20,    
          l_use_flag    LIKE type_file.chr2,     
          l_ute_flag    LIKE type_file.chr10,     
          l_sql 	      LIKE type_file.chr1000,
          l_cmd		      LIKE type_file.chr1000, 
          l_cnt         LIKE type_file.num5, 
          l_ad          LIKE type_file.num5,         
          l_za05	      LIKE type_file.chr1000,  
          l_labcst      LIKE imb_file.imb111,    #人工成本
          l_bma01       LIKE bma_file.bma01      #主件料件           
 
   DEFINE l_cmd1        LIKE type_file.chr1000     
   DEFINE p_level,p_i   LIKE type_file.num5,
          p_total       LIKE bmb_file.bmb06,
          l_k           LIKE type_file.num5, 
          l_total       LIKE bmb_file.bmb06
                                                                          
  DEFINE  l_ima02    LIKE ima_file.ima02,    #品名                                                                                 
          l_ima021   LIKE ima_file.ima021,   #規格                                                                                                                                                                 
          l_ima08    LIKE ima_file.ima08,    #來源                                                                                                                                                                         
          l_ima63    LIKE ima_file.ima63,    #發料單位                                                                                 
          l_ima55    LIKE ima_file.ima55,    #生產單位                                                                                                                                                                 
          l_bma05    LIKE bma_file.bma05     #發放日期                                                                                 

  DEFINE  sr2 DYNAMIC ARRAY OF RECORD
              ecu01       LIKE ecu_file.ecu01,  #主件料號
              ecu02       LIKE ecu_file.ecu02,  #製程編號
              ecb03       LIKE ecb_file.ecb03,  #製程序
              ecb06       LIKE ecb_file.ecb06,  #作業編號
              ecb17       LIKE ecb_file.ecb17,  #作業名稱
              ecb08       LIKE ecb_file.ecb08,  #工作站
              eca03       LIKE eca_file.eca03,  #部門
              ecb19       LIKE ecb_file.ecb19,  #標準工時(秒)
              ecb39       LIKE ecb_file.ecb39,  #委外Y/N
              ecb25       LIKE ecb_file.ecb25,  #委外廠商
              un_mcsts    LIKE imb_file.imb111, #材料單價   
              mcsts       LIKE imb_file.imb111, #直接材料
              un_labcsts  LIKE imb_file.imb1131,#人工單價
              labcsts     LIKE imb_file.imb1131,#直接人工
              un_exp1csts LIKE imb_file.imb114, #製費一單價
              exp1csts    LIKE imb_file.imb114, #製造費用一
              un_exp2csts LIKE imb_file.imb115, #製費二單價
              exp2csts    LIKE imb_file.imb115, #製造費用二
              un_outcsts  LIKE imb_file.imb116, #委外單價
              outcsts     LIKE imb_file.imb116  #委外加工               
          END RECORD,        
          l_unit        LIKE bmb_file.bmb10,
          l_unit_fac    LIKE bmb_file.bmb10_fac,
          l_ima44_fac   LIKE ima_file.ima44_fac
                                                                                                                  
     CALL cl_del_data(l_table) 
     LET l_num=0                                                                                                    
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
     LET sum_self_cost = 0
     LET sum_noself_cost = 0
     LET sum_other_cost = 0
     LET sum_total = 0
 
     LET l_sql = "SELECT UNIQUE bma01 ", 
                 " FROM bma_file ",
                 " LEFT JOIN tc_aaf_file ON tc_aaf02=bma01 ", #型號標準件設定
                 " WHERE ",
                 " bmaacti='Y' AND ",tm.wc
     PREPARE r622_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM          
     END IF
     DECLARE r622_curs1 CURSOR FOR r622_prepare1 
     FOREACH r622_curs1 INTO l_bma01
       IF SQLCA.sqlcode THEN
          CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET g_bma01_a=l_bma01    #主件   
       #當下階的所有成本資料均列印後, 最後要列印主件的標準成本及
       #計算後成本資料, 表示方式, 以32700為其階層(level)
                                                                                                                                    
      SELECT ima02,ima021,ima08,ima55,ima63                                                                                                      
        INTO l_ima02,l_ima021,l_ima08,l_ima55,l_ima63                                                                                                
        FROM ima_file                                                                                                               
        WHERE ima01=g_bma01_a                                                                                                        
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_ima02=''                                                                                                            
          LET l_ima021=''                                                                                                                                                                                                                                                                                                                                  
          LET l_ima08=''                                                                                                                                                                                                                       
      END IF 
      #發放日期      
      SELECT bma05 
        INTO l_bma05                                                                                             
        FROM bma_file                                                                                                             
        WHERE bma01=l_bma01                                                                                                    
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_bma05=''                                                                                                           
      END IF     

      EXECUTE insert_prep USING '0','32700','0',g_bma01_a,l_bma01,l_bma05,l_ima02,l_ima021,l_ima08,'',l_ima63,l_ima55,
                                 '','','','','0','','0','0','0','','','','','','','0','0','0','0','0','0','0','0','0',
                                 '0','0','0','0'
                                 
            LET l_cnt=0
            ##--- 取料件主製程
            SELECT count(*) INTO l_cnt FROM ecu_file WHERE ecu01=g_bma01_a and ecuacti='Y'
            IF l_cnt>=1 THEN
              IF l_cnt=1 THEN
                LET l_cmd=
                "SELECT ecu01,ecu02,ecb03,ecb06,ecb17,ecb08,eca03,ecb19,ecb39,ecb25,0,0,0,0,0,0,0,0,0,0 ",
                " FROM ecu_file inner join ecb_file on ecu01=ecb01 AND ecu02=ecb02 left join eca_file on ecb08=eca01",
                " WHERE ecuacti='Y' AND ecu01='", g_bma01_a,"'",
                " ORDER BY ecu01,ecu02,ecb03"
              ELSE
                LET l_cmd=               
                "SELECT ecu01,ecu02,ecb03,ecb06,ecb17,ecb08,eca03,ecb19,ecb39,ecb25,0,0,0,0,0,0,0,0,0,0 ",
                " FROM ecu_file inner join ecb_file on ecu01=ecb01 AND ecu02=ecb02 ",
                "      inner join ima_file on ecu01=ima01 AND ecu02=ima94 left join eca_file on ecb08=eca01",
                " WHERE ecuacti='Y' AND ecu01='", g_bma01_a,"'",
                " ORDER BY ecu01,ecu02,ecb03"              
              END IF
              PREPARE r622_ppu1 FROM l_cmd
              IF SQLCA.sqlcode THEN
                CALL cl_err('P1:',SQLCA.sqlcode,1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time 
                EXIT PROGRAM            
              END IF
              DECLARE r622_cur2 CURSOR FOR r622_ppu1
                LET l_ad=1
                FOREACH r622_cur2 INTO sr2[l_ad].* 
                  #產內生產
                  IF sr2[l_ad].ecb39='N' THEN
                    #人工單位成本
                    SELECT tc_cdb07 INTO sr2[l_ad].un_labcsts FROM tc_cdb_file WHERE tc_cdb03=sr2[l_ad].eca03 and tc_cdb04='1' and tc_cdb13=tm.range
                    LET sr2[l_ad].labcsts=1*(sr2[l_ad].un_labcsts*sr2[l_ad].ecb19/3600)
                    #製費一單位成本
                    SELECT tc_cdb07 INTO sr2[l_ad].un_exp1csts FROM tc_cdb_file WHERE tc_cdb03=sr2[l_ad].eca03 and tc_cdb04='2' and tc_cdb13=tm.range
                    LET sr2[l_ad].exp1csts=1*(sr2[l_ad].un_exp1csts*sr2[l_ad].ecb19/3600)
                    #製費二單位成本
                    SELECT tc_cdb07 INTO sr2[l_ad].un_exp2csts FROM tc_cdb_file WHERE tc_cdb03=sr2[l_ad].eca03 and tc_cdb04='3' and tc_cdb13=tm.range
                    LET sr2[l_ad].exp2csts=1*(sr2[l_ad].un_exp2csts*sr2[l_ad].ecb19/3600)
                  ELSE 
                    #委外單位成本
                    CASE tm.pur
                        WHEN '1' #最近進價
                             LET sr2[l_ad].un_outcsts    = 0
                             LET sr2[l_ad].outcsts       = 0
                             SELECT rvv38,ima44,ima44_fac
                               INTO sr2[l_ad].un_outcsts,l_unit,l_ima44_fac
                             FROM (SELECT rvv38*pmm42 as rvv38,rvu03,ima44,ima44_fac          #200424 add pmm42 by ruby
                             FROM rvu_file,rvv_file,ima_file,pmm_file                         #200424 add pmm_file by ruby
                               WHERE rvv31=sr2[l_ad].ecu01
                                 AND rvu04=sr2[l_ad].ecb25
                                 AND rvu01=rvv01
                                 AND ima01=rvv31 
                                 AND rvv36=pmm01                                              #200424 add by ruby
                                 AND rvu08='SUB'
                                 AND rvuconf='Y'
                              ORDER BY rvu03 DESC
                             ) WHERE rownum=1
                           IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                           LET l_unit_fac = 1 / l_ima44_fac
                           LET sr2[l_ad].un_outcsts = sr2[l_ad].un_outcsts * l_unit_fac
                         WHEN '2' #最近核價
                             LET sr2[l_ad].un_outcsts    = 0
                             LET sr2[l_ad].outcsts       = 0
                             SELECT case when pmi05='Y' then pmr05 else pmj07 END,ima44,ima44_fac
                               INTO sr2[l_ad].un_outcsts,l_unit,l_ima44_fac
                             FROM (SELECT pmi05,pmi02,pmj07*nvl(azk052,1) as pmj07,pmr05*nvl(azk052,1) as pmr05,ima44,ima44_fac  #200424 add azk052 by ruby
                             FROM pmi_file
                               INNER JOIN pmj_file ON pmi01=pmj01
                               INNER JOIN ima_file ON ima01=pmj03
                               LEFT JOIN pmr_file ON pmj01=pmr01 AND pmj02=pmr02 AND pmr03=1
                               LEFT JOIN azk_file ON pmj05=azk01 AND pmi02=azk02                                                 #200424 add by ruby
                               WHERE pmj03=sr2[l_ad].ecu01
                                 AND pmi03=sr2[l_ad].ecb25
                                 AND pmi10='2'
                                 AND pmiconf='Y'
                                 AND ta_pmj02 is null                                                                
                                 ORDER BY pmi02 DESC
                             ) WHERE rownum=1
                           IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                           LET l_unit_fac = 1 / l_ima44_fac
                           LET sr2[l_ad].un_outcsts = sr2[l_ad].un_outcsts * l_unit_fac
                        WHEN '3' #實際成本
                             LET sr2[l_ad].un_outcsts    = 0
                             LET sr2[l_ad].outcsts       = 0
                             SELECT ccc23d,ima86,ima86_fac
                               INTO sr2[l_ad].un_outcsts,l_unit,l_ima44_fac
                             FROM ccc_file,ima_file 
                               WHERE ccc01=sr2[l_ad].ecu01
                                 AND ima01=ccc01
                                 AND ccc02=tm.year
                                 AND ccc03=tm.month
                           IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                           LET l_unit_fac = 1 / l_ima44_fac
                           LET sr2[l_ad].un_outcsts = sr2[l_ad].un_outcsts * l_unit_fac
                    END CASE 
                  LET sr2[l_ad].outcsts=1*sr2[l_ad].un_outcsts                                                       
                  END IF
                                                                                            
                  #LET l_num = l_num + 1                                                                                                                                                                                                                                                                                                                                                     
                  EXECUTE insert_prep USING l_num,p_level,'0',g_bma01_a,l_bma01,l_bma05,l_ima02,l_ima021,l_ima08,l_ima63,l_ima55,
                                   l_bma01,l_ima02,l_ima021,l_ima08,'1',l_ima55,
                                   '0','0',l_ad,sr2[l_ad].ecu02,sr2[l_ad].ecb03,sr2[l_ad].ecb06,sr2[l_ad].ecb17,
                                   sr2[l_ad].ecb08,sr2[l_ad].eca03,sr2[l_ad].ecb19,sr2[l_ad].un_labcsts,sr2[l_ad].labcsts,
                                   sr2[l_ad].un_exp1csts,sr2[l_ad].exp1csts,sr2[l_ad].un_exp2csts,sr2[l_ad].exp2csts,sr2[l_ad].un_outcsts,sr2[l_ad].outcsts ,
                                   sum_self_cost,sum_noself_cost,sum_other_cost,sum_total                             
                  LET l_ad = l_ad + 1  
                END FOREACH
                END IF  
               CALL r622_bom(0,l_bma01,1)    
               ##----自製率計算
               LET sum_total = cl_digcut((sum_self_cost+sum_other_cost)/(sum_self_cost+sum_noself_cost+sum_other_cost) *100,1)
               DISPLAY BY NAME sum_self_cost,sum_noself_cost,sum_other_cost,sum_total
               IF g_bma01_a[1,1] = '0' THEN
                  UPDATE ima_file SET imaud02 = regexp_replace(sum_total/100,'^\.', '0.') WHERE ima01 = g_bma01_a
                  LET sum_self_cost=0
                  LET sum_other_cost=0
                  LET sum_noself_cost=0
               END IF
               ##----自製率計算 
	  END FOREACH
               ##----自製率計算
               #LET sum_total = cl_digcut((sum_self_cost+sum_other_cost)/(sum_self_cost+sum_noself_cost+sum_other_cost) *100,1)     
               #DISPLAY BY NAME sum_self_cost,sum_noself_cost,sum_other_cost,sum_total 
               #IF g_bma01_a[1,1] = '0' THEN
               #   UPDATE ima_file SET imaud02 = regexp_replace(sum_total/100,'^\.', '0.') WHERE ima01 = g_bma01_a
               #END IF                                                                                                                                                                                                                                

     #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'bma01')                                                                                    
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,l_cmd1 CLIPPED                                                             
     LET g_str = g_str,";",tm.effective,";",tm.pur,";",g_azi03,";",g_azi05
     IF tm.open = 'Y' THEN
        CALL cl_prt_cs3('cbmr622','cbmr622',g_sql,g_str)
     ELSE
        CALL cl_err('','afa-116',1)
     END IF
END FUNCTION
 
FUNCTION r622_bom(p_level,p_key,p_total) 
   DEFINE p_level      	LIKE type_file.num5,    #階數
          p_total       LIKE bmb_file.bmb06,    #終階用量
          l_total       LIKE bmb_file.bmb06,   
          p_key		      LIKE bma_file.bma01,    #主件料件編號
          l_ac   	      LIKE type_file.num5,
          l_ae          LIKE type_file.num5, 
          i             LIKE type_file.num5,   
          arrno		      LIKE type_file.num5,    
          b_seq		      LIKE type_file.num5,    
          sr DYNAMIC ARRAY OF RECORD            #每階存放資料
              bma01     LIKE bma_file.bma01,    #主件料號
              bmb02     LIKE bmb_file.bmb02,    #項次      
              bmb03     LIKE bmb_file.bmb03,    #元件料號
              ima02     LIKE ima_file.ima02,    #品名
              ima021    LIKE ima_file.ima021,   #規格
              ima08     LIKE ima_file.ima08,    #來源碼
              imaud02   LIKE ima_file.imaud02,  #自製件否
              bmb06     LIKE bmb_file.bmb06,    #QPA
              bmb10     LIKE bmb_file.bmb10,    #發料單位
              bmb10_fac LIKE bmb_file.bmb10_fac,#發料換算率
              bmb19     LIKE bmb_file.bmb19,    #工單開立展開選項
              un_mcsts    LIKE imb_file.imb111, #材料單價   
              mcsts       LIKE imb_file.imb111, #直接材料
              un_labcsts  LIKE imb_file.imb1131,#人工單價
              labcsts     LIKE imb_file.imb1131,#直接人工
              un_exp1csts LIKE imb_file.imb114, #製費一單價
              exp1csts    LIKE imb_file.imb114, #製造費用一
              un_exp2csts LIKE imb_file.imb115, #製費二單價
              exp2csts    LIKE imb_file.imb115, #製造費用二
              un_outcsts  LIKE imb_file.imb116, #委外單價
              outcsts     LIKE imb_file.imb116  #委外加工
          END RECORD,
          sr1 DYNAMIC ARRAY OF RECORD
              ecu01       LIKE ecu_file.ecu01,  #主件料號
              ecu02       LIKE ecu_file.ecu02,  #製程編號
              ecb03       LIKE ecb_file.ecb03,  #製程序
              ecb06       LIKE ecb_file.ecb06,  #作業編號
              ecb17       LIKE ecb_file.ecb17,  #作業名稱
              ecb08       LIKE ecb_file.ecb08,  #工作站
              eca03       LIKE eca_file.eca03,  #部門
              ecb19       LIKE ecb_file.ecb19,  #標準工時(秒)
              ecb39       LIKE ecb_file.ecb39,  #委外Y/N
              ecb25       LIKE ecb_file.ecb25,  #委外廠商
              un_mcsts    LIKE imb_file.imb111, #材料單價   
              mcsts       LIKE imb_file.imb111, #直接材料
              un_labcsts  LIKE imb_file.imb1131,#人工單價
              labcsts     LIKE imb_file.imb1131,#直接人工
              un_exp1csts LIKE imb_file.imb114, #製費一單價
              exp1csts    LIKE imb_file.imb114, #製造費用一
              un_exp2csts LIKE imb_file.imb115, #製費二單價
              exp2csts    LIKE imb_file.imb115, #製造費用二
              un_outcsts  LIKE imb_file.imb116, #委外單價
              outcsts     LIKE imb_file.imb116  #委外加工               
          END RECORD,        
          l_unit        LIKE bmb_file.bmb10,
          l_unit_fac    LIKE bmb_file.bmb10_fac,
          l_ima44_fac   LIKE ima_file.ima44_fac,          
          l_cmd		      LIKE type_file.chr1000,
          p_num         LIKE type_file.num5,
          l_cnt         LIKE type_file.num5,
          g_sw          LIKE type_file.num5    
                                                                                                           
   DEFINE p_i        LIKE type_file.num5,    #項次
          l_ima02    LIKE ima_file.ima02,    #品名                                                                              
          l_ima021   LIKE ima_file.ima021,   #規格                                                                                                                                                                        
          l_ima08    LIKE ima_file.ima08,    #來源碼                                                                                                                                                                   
          l_ima63    LIKE ima_file.ima63,    #發料單位                                                                              
          l_ima55    LIKE ima_file.ima55,    #生產單位                                                                              
          l_bma05    LIKE bma_file.bma05,    #主件生產單位                                                                                                                                                                            
          l_k        LIKE type_file.num5,
          l_ute_flag LIKE type_file.chr10,                                                                       
          l_str2     LIKE cre_file.cre08 

                                                                                                      
    LET p_level = p_level + 1
    IF p_level > 20 THEN
        CALL cl_err(p_level,'mfg2644',2)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
    END IF
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
        LET sr[1].bmb03 = p_key
    END IF
                                                                                                                                      
      SELECT ima02,ima021,ima08,ima55,ima63                                                                                                      
        INTO l_ima02,l_ima021,l_ima08,l_ima55,l_ima63                                                                                                
        FROM ima_file                                                                                                               
       WHERE ima01=g_bma01_a                                                                                                        
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_ima02=''                                                                                                            
          LET l_ima021=''                                                                                                                                                                                                                      
          LET l_ima08=''                                                                                                                                                                                                                       
      END IF                                                                                                                        
      SELECT bma05                                                                                                    
          INTO l_bma05                                                                                              
          FROM bma_file                                                                                                             
          WHERE bma01=g_bma01_a                                                                                                     
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_bma05=''                                                                                                                                                                                                                       
      END IF                                                                                                                                                                                     
                                                           
    LET arrno = 600
    WHILE TRUE
        #下階元件
        LET l_cmd=
            "SELECT bma01,bmb02,bmb03,ima02,ima021,ima08,",
            "       imaud02,",
            "       (bmb06/bmb07),bmb10,bmb10_fac,bmb19,0,0,0,0,0,0,0,0,0,0",
            " FROM bmb_file, ima_file, bma_file",
            " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,
            " AND bmb_file.bmb03 = ima_file.ima01",
            " AND bmb_file.bmb01 = bma_file.bma01",
            " AND ima_file.ima08 != 'A'",
            " AND bma_file.bmaacti='Y'"
        IF tm.effective IS NOT NULL THEN
        LET l_cmd=l_cmd CLIPPED, 
            " AND (bmb04 <='",tm.effective,"' OR bmb04 IS NULL)",
            " AND (bmb05 >='",tm.effective,"' OR bmb05 IS NULL)",
            " AND (bma05 <='",tm.effective,"')"
        END IF
        LET l_cmd=l_cmd CLIPPED," ORDER BY bmb02"
        PREPARE r622_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
           CALL cl_err('P1:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
           EXIT PROGRAM            
        END IF
        DECLARE r622_cur CURSOR FOR r622_ppp
 
        LET l_ac=1
        FOREACH r622_cur INTO sr[l_ac].*
            LET l_ac = l_ac + 1
             IF l_ac >= arrno THEN EXIT FOREACH END IF
        END FOREACH
        FOR i = 1 TO l_ac-1
          LET l_cnt=0
          LET l_total=p_total*sr[i].bmb06               #元件之終階QPA          
          
            CASE tm.pur
                 WHEN '1' #最近進價
                      LET sr[i].un_mcsts    = 0
                      LET sr[i].mcsts       = 0
                        SELECT rvv38,ima44,ima44_fac
                          INTO sr[i].un_mcsts,l_unit,l_ima44_fac
                        FROM (SELECT rvv38*pmm42 as rvv38,rvu03,ima44,ima44_fac         #200424 add pmm42 by ruby
                        FROM rvu_file,rvv_file,ima_file,pmm_file                        #200424 add pmm_file by ruby
                          WHERE rvv31=sr[i].bmb03
                            AND rvu01=rvv01
                            AND ima01=rvv31
                            AND rvv36=pmm01                                             #200424 add by ruby
                            AND rvu08<>'SUB'
                            AND rvuconf='Y'
                         ORDER BY rvu03 DESC
                        ) WHERE rownum=1
                      IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                      LET l_unit_fac = sr[i].bmb10_fac / l_ima44_fac
                      LET sr[i].un_mcsts = sr[i].un_mcsts * l_unit_fac
                 WHEN '2' #最近核價
                      LET sr[i].un_mcsts    = 0
                      LET sr[i].mcsts       = 0
                      SELECT case when pmi05='Y' then pmr05 else pmj07 END,ima44,ima44_fac
                        INTO sr[i].un_mcsts,l_unit,l_ima44_fac
                      FROM (SELECT pmi05,pmi02,pmj07*nvl(azk052,1) as pmj07,pmr05*nvl(azk052,1) as pmr05,ima44,ima44_fac  #200424 add azk052 by ruby
                      FROM pmi_file 
                        INNER JOIN pmj_file ON pmi01=pmj01  
                        INNER JOIN ima_file ON pmi03=ima54 AND ima01=pmj03
                        LEFT JOIN pmr_file ON pmj01=pmr01 and pmj02=pmr02 and pmr03=1
                        LEFT JOIN azk_file ON pmj05=azk01 AND pmi02=azk02                                                 #200424 add by ruby 
                        WHERE pmj03=sr[i].bmb03
                          AND pmi10='1'
                          AND pmiconf='Y'
                          AND ta_pmj02 is null                                               
                       ORDER BY pmi02 DESC
                      ) WHERE rownum=1
                      IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                      LET l_unit_fac = sr[i].bmb10_fac / l_ima44_fac
                      LET sr[i].un_mcsts = sr[i].un_mcsts * l_unit_fac
                 WHEN '3' #實際成本
                      LET sr[i].un_mcsts    = 0
                      LET sr[i].mcsts       = 0
                      SELECT ccc23a,ima86,ima86_fac
                        INTO sr[i].un_mcsts,l_unit,l_ima44_fac
                      FROM ccc_file,ima_file 
                        WHERE ccc01=sr[i].bmb03
                          AND ima01=ccc01
                          AND ccc02=tm.year
                          AND ccc03=tm.month
                      IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                      LET l_unit_fac = sr[i].bmb10_fac / l_ima44_fac
                      LET sr[i].un_mcsts = sr[i].un_mcsts * l_unit_fac
               END CASE

            IF sr[i].un_mcsts IS NULL THEN LET sr[i].un_mcsts=0 END IF
            IF sr[i].mcsts    IS NULL THEN LET sr[i].mcsts=0    END IF     
            LET sr[i].mcsts=sr[i].un_mcsts*l_total     #元件之本階直接材料成本  

            #自製/非自製總計 
            IF cl_null(sum_self_cost) THEN LET sum_self_cost = 0 END IF 
            IF cl_null(sum_noself_cost) THEN LET sum_noself_cost = 0 END IF 
            IF sr[i].imaud02='Y' THEN
               LET sum_self_cost = sum_self_cost + sr[i].mcsts
            ELSE
               LET sum_noself_cost = sum_noself_cost + sr[i].mcsts
            END IF
 
            #材料成本之算法和其他的幾個成本的計算方式不同                                                                                                                                      
            SELECT count(*) INTO l_cnt FROM ecu_file WHERE ecu01=sr[i].bmb03 and ecuacti='Y'
            #無製程且BOM為不為展開
            IF l_cnt=0 and sr[i].bmb19<>'3' THEN
                LET l_num = l_num + 1      
                IF cl_null(sr[i].imaud02) THEN LET sr[i].imaud02 = 'N' END IF        
                EXECUTE insert_prep USING l_num,p_level,sr[i].bmb02,g_bma01_a,p_key,l_bma05,l_ima02,l_ima021,l_ima08,l_ima63,l_ima55,
                                 sr[i].bmb03,sr[i].ima02,sr[i].ima021,sr[i].ima08,
                                 sr[i].imaud02,
                                 l_total,sr[i].bmb10,sr[i].un_mcsts,
                                 sr[i].mcsts,
                                 '0','','','','','','','0',sr[i].un_labcsts,sr[i].labcsts,
                                 sr[i].un_exp1csts,sr[i].exp1csts,sr[i].un_exp2csts,sr[i].exp2csts,sr[i].un_outcsts,sr[i].outcsts,
                                 sum_self_cost,sum_noself_cost,sum_other_cost,sum_total                 
            END IF
            IF l_cnt>=1 THEN
              IF l_cnt=1 THEN
                LET l_cmd=
                "SELECT ecu01,ecu02,ecb03,ecb06,ecb17,ecb08,eca03,ecb19,ecb39,ecb25,0,0,0,0,0,0,0,0,0,0 ",
                " FROM ecu_file inner join ecb_file on ecu01=ecb01 AND ecu02=ecb02 left join eca_file on ecb08=eca01",
                " WHERE ecuacti='Y' AND ecu01='", sr[i].bmb03,"'",
                " ORDER BY ecu01,ecu02,ecb03"
              ELSE
                LET l_cmd=               
                "SELECT ecu01,ecu02,ecb03,ecb06,ecb17,ecb08,eca03,ecb19,ecb39,ecb25,0,0,0,0,0,0,0,0,0,0 ",
                " FROM ecu_file inner join ecb_file on ecu01=ecb01 AND ecu02=ecb02 inner join ima_file on ecu01=ima01 AND ecu02=ima94 left join eca_file on ecb08=eca01",
                " WHERE ecuacti='Y' AND ecu01='", sr[i].bmb03,"'",
                " ORDER BY ecu01,ecu02,ecb03"              
              END IF
              PREPARE r622_ppu FROM l_cmd
              IF SQLCA.sqlcode THEN
                CALL cl_err('P1:',SQLCA.sqlcode,1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time 
                EXIT PROGRAM            
              END IF
              DECLARE r622_cur1 CURSOR FOR r622_ppu
                LET l_ae=1
                FOREACH r622_cur1 INTO sr1[l_ae].* 
                  IF sr1[l_ae].ecb39='N' THEN
                    #人工單位成本
                    SELECT tc_cdb07 INTO sr1[l_ae].un_labcsts FROM tc_cdb_file WHERE tc_cdb03=sr1[l_ae].eca03 and tc_cdb04='1' and tc_cdb13=tm.range
                    LET sr1[l_ae].labcsts=l_total*(sr1[l_ae].un_labcsts*sr1[l_ae].ecb19/3600)
                    #製費一單位成本
                    SELECT tc_cdb07 INTO sr1[l_ae].un_exp1csts FROM tc_cdb_file WHERE tc_cdb03=sr1[l_ae].eca03 and tc_cdb04='2' and tc_cdb13=tm.range
                    LET sr1[l_ae].exp1csts=l_total*(sr1[l_ae].un_exp1csts*sr1[l_ae].ecb19/3600)
                    #製費二單位成本
                    SELECT tc_cdb07 INTO sr1[l_ae].un_exp2csts FROM tc_cdb_file WHERE tc_cdb03=sr1[l_ae].eca03 and tc_cdb04='3' and tc_cdb13=tm.range
                    LET sr1[l_ae].exp2csts=l_total*(sr1[l_ae].un_exp2csts*sr1[l_ae].ecb19/3600)
                  ELSE 
                    #委外單位成本
                    CASE tm.pur
                        WHEN '1' #最近進價
                             LET sr1[l_ae].un_outcsts    = 0
                             LET sr1[l_ae].outcsts       = 0
                             SELECT rvv38,ima44,ima44_fac
                               INTO sr1[l_ae].un_outcsts,l_unit,l_ima44_fac
                             FROM (SELECT rvv38*pmm42 as rvv38,rvu03,ima44,ima44_fac    #200424 add pmm42 by ruby
                             FROM rvu_file,rvv_file,ima_file,pmm_file                   #200424 add pmm_file by ruby
                               WHERE rvv31=sr1[l_ae].ecu01
                                 AND rvu04=sr1[l_ae].ecb25
                                 AND rvu01=rvv01
                                 AND ima01=rvv31 
                                 AND rvv36=pmm01                                        #200424 add by ruby
                                 AND rvu08='SUB'
                                 AND rvuconf='Y'
                              ORDER BY rvu03 DESC
                             ) WHERE rownum=1
                           IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                           LET l_unit_fac = sr[i].bmb10_fac / l_ima44_fac
                           LET sr1[l_ae].un_outcsts = sr1[l_ae].un_outcsts * l_unit_fac
                         WHEN '2' #最近核價
                             LET sr1[l_ae].un_outcsts    = 0
                             LET sr1[l_ae].outcsts       = 0
                             SELECT case when pmi05='Y' then pmr05 else pmj07 END,ima44,ima44_fac
                               INTO sr1[l_ae].un_outcsts,l_unit,l_ima44_fac
                             FROM (SELECT pmi05,pmi02,pmj07*nvl(azk052,1) as pmj07,pmr05*nvl(azk052,1) as pmr05,ima44,ima44_fac  #200424 add azk052 by urby
                             FROM pmi_file
                               INNER JOIN pmj_file ON pmi01=pmj01
                               INNER JOIN ima_file ON ima01=pmj03
                               LEFT JOIN pmr_file ON pmj01=pmr01 AND pmj02=pmr02 AND pmr03=1
                               LEFT JOIN azk_file ON pmj05=azk01 AND pmi02=azk02                                                 #200424 add by ruby                               
                               WHERE pmj03=sr1[l_ae].ecu01
                                 AND pmi03=sr1[l_ae].ecb25
                                 AND pmi10='2'
                                 AND pmiconf='Y'
                                 AND ta_pmj02 is null                                                                
                                 ORDER BY pmi02 DESC
                             ) WHERE rownum=1
                           IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                           LET l_unit_fac = sr[i].bmb10_fac / l_ima44_fac
                           LET sr1[l_ae].un_outcsts = sr1[l_ae].un_outcsts * l_unit_fac
                        WHEN '3' #實際成本
                             LET sr1[l_ae].un_outcsts    = 0
                             LET sr1[l_ae].outcsts       = 0
                             SELECT ccc23d,ima86,ima86_fac
                               INTO sr1[l_ae].un_outcsts,l_unit,l_ima44_fac
                             FROM ccc_file,ima_file 
                               WHERE ccc01=sr1[l_ae].ecu01
                                 AND ima01=ccc01
                                 AND ccc02=tm.year
                                 AND ccc03=tm.month
                           IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                           LET l_unit_fac = sr[i].bmb10_fac / l_ima44_fac
                           LET sr1[l_ae].un_outcsts = sr1[l_ae].un_outcsts * l_unit_fac
                    END CASE 
                  LET sr1[l_ae].outcsts=l_total*sr1[l_ae].un_outcsts                                                       
                  END IF

                  #非材料成本加總
                  IF cl_null(sum_other_cost) THEN LET sum_other_cost = 0 END IF
                  LET sum_other_cost = sum_other_cost + sr1[l_ae].labcsts + sr1[l_ae].exp1csts + sr1[l_ae].exp2csts + sr1[l_ae].outcsts                                 

                  IF sr[i].bmb19<>'3' THEN
                     IF l_ae=1 THEN
                        LET l_num = l_num + 1                                                                                                                                                                                                                                                                                                                                                                          
                        IF cl_null(sr[i].imaud02) THEN LET sr[i].imaud02 = 'N' END IF     
                        IF sr1[l_ae].labcsts > 0 THEN  #20221007
                           LET sr[i].mcsts = 0
                           LET sr1[l_ae].mcsts = 0
                        END IF                        #20221007                                                                                                                                                                                                                                                                                                                                                   
                        EXECUTE insert_prep USING l_num,p_level,sr[i].bmb02,g_bma01_a,p_key,l_bma05,l_ima02,l_ima021,l_ima08,l_ima63,l_ima55,
                                      sr[i].bmb03,sr[i].ima02,sr[i].ima021,sr[i].ima08,
                                      sr[i].imaud02,
                                      sr[i].bmb06,sr[i].bmb10,
                                      sr[i].un_mcsts,sr[i].mcsts,l_ae,sr1[l_ae].ecu02,sr1[l_ae].ecb03,sr1[l_ae].ecb06,sr1[l_ae].ecb17,
                                      sr1[l_ae].ecb08,sr1[l_ae].eca03,sr1[l_ae].ecb19,sr1[l_ae].un_labcsts,sr1[l_ae].labcsts,
                                      sr1[l_ae].un_exp1csts,sr1[l_ae].exp1csts,sr1[l_ae].un_exp2csts,sr1[l_ae].exp2csts,sr1[l_ae].un_outcsts,sr1[l_ae].outcsts,
                                      sum_self_cost,sum_noself_cost,sum_other_cost,sum_total                             
                     ELSE
                     #LET l_num = l_num + 1
                     EXECUTE insert_prep USING l_num,p_level,sr[i].bmb02,g_bma01_a,p_key,l_bma05,l_ima02,l_ima021,l_ima08,l_ima63,l_ima55,
                                      sr[i].bmb03,sr[i].ima02,sr[i].ima021,sr[i].ima08,
                                      sr[i].imaud02,
                                      sr[i].bmb06,sr[i].bmb10,
                                      sr1[l_ae].un_mcsts,sr1[l_ae].mcsts,l_ae,sr1[l_ae].ecu02,sr1[l_ae].ecb03,sr1[l_ae].ecb06,sr1[l_ae].ecb17,
                                      sr1[l_ae].ecb08,sr1[l_ae].eca03,sr1[l_ae].ecb19,sr1[l_ae].un_labcsts,sr1[l_ae].labcsts,
                                      sr1[l_ae].un_exp1csts,sr1[l_ae].exp1csts,sr1[l_ae].un_exp2csts,sr1[l_ae].exp2csts,sr1[l_ae].un_outcsts,sr1[l_ae].outcsts,                 
                                      sum_self_cost,sum_noself_cost,sum_other_cost,sum_total                             
                                      
                     END IF
                  END IF
                  LET l_ae = l_ae + 1   
                END FOREACH                                               
                CALL r622_bom(p_level,sr[i].bmb03,l_total)       
                END IF            
        END FOR                                                                                                                                
        IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmb02
        END IF   
    END WHILE
END FUNCTION
