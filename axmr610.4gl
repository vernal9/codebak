# Prog. Version..: '5.30.24-17.04.13(00006)'     #
#
# Pattern name...: axmr610.4gl
# Descriptions...: 出貨清單
# Date & Author..: 95/01/19 by Nick
# Modify.........: 01-04-06 BY ANN CHEN B311 1.不包含出貨通知單
#                                            2.不應包含作廢資料
# Modify.........: No.FUN-4B0043 04/11/16 By Nicola 加入開窗功能
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.MOD-560155 05/06/22 By Mandy 取消條件選項,若不要印各倉/儲/批的數量請至p_zaa將此欄位設定隱藏
# Modify.........: No.FUN-580004 05/08/03 By wujie 雙單位報表結構修改
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-5C0075 05/12/19 By Tracy 若成品替代(oaz23='Y'),則多打印替代料號
# Modify.........: No.FUN-610020 06/01/18 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-7C0007 07/12/05 By baofei  報表輸出至Crystal Reports功能/MARK tm.a    
# Modify.........: No.MOD-870137 08/07/11 By Smapmin 發票號碼欄位抓錯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B40119 11/04/15 By lixia “人員編號”開窗查詢全選運行后報錯
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No.           18/04/17 By Ruby 增加轉採購單號
# Modify.........: No.           18/05/02 By Ruby 增加aimi100軸數及帶控制欄位
# Modify.........: No.           18/09/13 By Ruby 增加出貨金額
# Moify..........: 20181221 By momo 增加產品分類編號、其他分群碼-(系列)、型號、馬達方向、外徑+導程、行程、代工、成品特注、螺桿研磨長度
# Modify.........: 20190104 By momo 增加顯示 訂單日期oea02 與 約定交貨日 oeb15
# Modify.........: No.22100054   22/10/27 By Ruby 增加產品編號
# Modify.........: NO:23080008   20230815 By momo 增加WO
 
DATABASE ds
 
#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"

#No.FUN-580004--begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
#No.FUN-580004--end
   DEFINE tm  RECORD                         # Print condition RECORD
              wc       STRING,             # Where condition
              a       LIKE type_file.chr1,        # Prog. Version..: '5.30.24-17.04.13(01)              # 列印單價
              more    LIKE type_file.chr1         # Prog. Version..: '5.30.24-17.04.13(01)               # Input more condition(Y/N)
              END RECORD,
	 l_outbill   LIKE oga_file.oga01     # 出貨單號,傳參數用
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
#FUN-580004--begin
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
#FUN-580004--end
DEFINE g_oaz23          LIKE oaz_file.oaz23  #成品替代    #No.FUN-5C0075
#No.FUN-7C0007---Begin                                                          
DEFINE l_table        STRING,
       l_table1       STRING,
       g_str          STRING,                                                   
       g_sql          STRING                                                   
#No.FUN-7C0007---End  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
#No.FUN-7C0007---Begin                                                          
   LET g_sql = "oga01.oga_file.oga01,",
               "oea02.oea_file.oea02,",   #20190104 接單日
               "oeb15.oeb_file.oeb15,",   #20190104 約交日
               "oma10.oma_file.oma10,",   #MOD-870137  oga011-->oma10
               "oga02.oga_file.oga02,",
               "oga03.oga_file.oga03,",
               "oga032.oga_file.oga032,",
               "oga04.oga_file.oga04,",
               "oga14.oga_file.oga14,",
               "oga15.oga_file.oga15,",
               "ogb03.ogb_file.ogb03,",
               "ogb04.ogb_file.ogb04,",
               "ogb05.ogb_file.ogb05,",
               "ogb06.ogb_file.ogb06,",      
               "ogb12.ogb_file.ogb12,",
               "ogb14.ogb_file.ogb14,",   #180913 add by ruby
               "ogb17.ogb_file.ogb17,",      
               "ogb31.ogb_file.ogb31,",
               "ogb32.ogb_file.ogb32,",
               "pmn01.pmn_file.pmn01,",   #180417 add by ruby
               "occ02.occ_file.occ02,",
               "gen02.gen_file.gen02,",
               "gem02.gem_file.gem02,",
               "ima021.ima_file.ima021,",
               "ta_ima02.ima_file.imaud01,",    #180502 add by ruby
               "ta_ima05.ima_file.ta_ima05,",    #180502 add by ruby
               "oba02.oba_file.oba02,",          #20181221
               "azf03.azf_file.azf03,",          #20181221
               "ima1007.ima_file.ima1007,",      #20181221
               "ta_ima03.ima_file.ta_ima03,",    #20181221
               "ta_ima04.ima_file.ta_ima04,",    #20181221
               "occ02_1.occ_file.occ02,",        #20181221
               "ta_ima07.ima_file.ta_ima07,",    #20181221
               "ta_ima08.ima_file.ta_ima08,",    #20181221
               "imaud08.ima_file.imaud08,",      #20181221
               "sfb01.sfb_file.sfb01,",          #20230815
               "l_str2.type_file.chr1000"               
                                                                
   LET l_table = cl_prt_temptable('axmr610',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "oga01.oga_file.oga01,",
               "ogb03.ogb_file.ogb03,",
               "ogc09.ogc_file.ogc09,",
               "ogc091.ogc_file.ogc091,",   
               "ogc092.ogc_file.ogc092,",
               "ogc15.ogc_file.ogc15,",
               "ogc16.ogc_file.ogc16,",
               "ogc17.ogc_file.ogc17"
   LET l_table1 = cl_prt_temptable('axmr6101',g_sql) CLIPPED                                                                          
   IF l_table1 = -1 THEN EXIT PROGRAM END IF              
#No.FUN-7C0007---End   
   INITIALIZE tm.* TO NULL            # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.wc = ARG_VAL(1)
  #LET tm.a ='Y'
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
 
 #--------------No.TQC-610089 modify
  #IF cl_null(l_outbill)
   IF cl_null(tm.wc)
      THEN CALL axmr610_tm(0,0)             # Input print condition
   ELSE
     #LET tm.wc="oga01='",tm.wc CLIPPED,"'"
      CALL axmr610()                   # Read data and create out-file
   END IF
 #--------------No.TQC-610089 end
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr610_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd       LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 17
 
   OPEN WINDOW axmr610_w AT p_row,p_col WITH FORM "cxm/42f/axmr610"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oga01,oga011,oga02,ogb04,oga03,oga04,oga14,oga15  #221027 add ogb04 by ruby 
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP    #FUN-4B0043
           #221027 add by ruby --s--
           IF INFIELD(ogb04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ogb04
              NEXT FIELD ogb04
           END IF
           #221027 add by ruby --e--
           IF INFIELD(oga03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga03
              NEXT FIELD oga03
           END IF
           IF INFIELD(oga04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga04
              NEXT FIELD oga04
           END IF
           IF INFIELD(oga14) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga14
              NEXT FIELD oga14
           END IF
           IF INFIELD(oga15) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga15
              NEXT FIELD oga15
           END IF
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr610_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   #INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS #MOD-560155 MARK
    INPUT BY NAME tm.more WITHOUT DEFAULTS      #MOD-560155 取消tm.a
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      #MOD-560155 MARK
     #AFTER FIELD a
     #   IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
     #      NEXT FIELD a
     #   END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr610_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr610'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr610','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                        #" '",tm.a CLIPPED,"'" ,                #No.TQC-610089 mark
                        #" '",tm.more CLIPPED,"'"  ,            #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr610',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr610_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr610()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr610_w
END FUNCTION
 
FUNCTION axmr610()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
         #l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_sql     STRING,                       #TQC-B40119 modify
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_ta_ima02 LIKE ima_file.imaud01,      #180502 add by ruby
          l_ta_ima05 LIKE ima_file.ta_ima05,      #180502 add by ruby
          sr        RECORD
                    oga01     LIKE oga_file.oga01,
                    oga02     LIKE oga_file.oga02,
                    oma10     LIKE oma_file.oma10,   #MOD-870137  oga011-->oma10
                    oga03     LIKE oga_file.oga03,
                    oga032    LIKE oga_file.oga032,
                    oga04     LIKE oga_file.oga04,
                    oga044    LIKE oga_file.oga044,
                    oga14     LIKE oga_file.oga14,
                    oga15     LIKE oga_file.oga15,
                    ogb03     LIKE ogb_file.ogb03,
                    ogb04     LIKE ogb_file.ogb04,
                    ogb05     LIKE ogb_file.ogb05,
                    ogb06     LIKE ogb_file.ogb06,
                    ogb09     LIKE ogb_file.ogb09,
                    ogb091    LIKE ogb_file.ogb091,
                    ogb092    LIKE ogb_file.ogb092,
                    ogb12     LIKE ogb_file.ogb12,
                    ogb14     LIKE ogb_file.ogb14,      #180913 add by ruby
                    ogb16     LIKE ogb_file.ogb16,
                    ogb17     LIKE ogb_file.ogb17,
                    ogb31     LIKE ogb_file.ogb31,
                    ogb32     LIKE ogb_file.ogb32,
                    pmn01     LIKE pmn_file.pmn01,      #180417 add by ruby
                    ogb910    LIKE ogb_file.ogb910,     #No.FUN-580004
                    ogb912    LIKE ogb_file.ogb912,     #No.FUN-580004
                    ogb913    LIKE ogb_file.ogb913,     #No.FUN-580004
                    ogb915    LIKE ogb_file.ogb915,     #No.FUN-580004
                    oga10     LIKE oga_file.oga10   #MOD-870137
                    END RECORD
            DEFINE  l_ogb915   STRING                   #No.FUN-7C0007                                                                                     
            DEFINE  l_ogb912   STRING                   #No.FUN-7C0007                                                                                     
            DEFINE  l_str2     LIKE type_file.chr1000   #No.FUN-7C0007                                                                                     
            DEFINE  l_ima906   LIKE ima_file.ima906,    #No.FUN-7C0007
                    l_occ02    LIKE occ_file.occ02,     #No.FUN-7C0007                                                                                         
                    l_gen02    LIKE gen_file.gen02,     #No.FUN-7C0007                                                                                       
                    l_gem02    LIKE gem_file.gem02,     #No.FUN-7C0007                                                                                       
                    l_ima021   LIKE ima_file.ima021,    #No.FUN-7C0007 
                    l_ogc   RECORD                      #No.FUN-7C0007                                                                                       
                    ogc17     LIKE ogc_file.ogc17,      #No.FUN-7C0007                                                      
                    ogc15     LIKE ogc_file.ogc15,      #No.FUN-7C0007                                                    
                    ogc09     LIKE ogc_file.ogc09,      #No.FUN-7C0007                                                                            
                    ogc091    LIKE ogc_file.ogc091,     #No.FUN-7C0007                                                                            
                    ogc16     LIKE ogc_file.ogc16,      #No.FUN-7C0007                                                                            
                    ogc092    LIKE ogc_file.ogc092      #No.FUN-7C0007                                                                            
                 END RECORD                             #No.FUN-7C0007
           ##---- 20181221 add (S)
           DEFINE   l_oba02    LIKE oba_file.oba02,
                    l_azf03    LIKE azf_file.azf03,
                    l_ima1007  LIKE ima_file.ima1007,
                    l_ta_ima07 LIKE ima_file.ta_ima07,
                    l_ta_ima03 LIKE ima_file.ta_ima03,
                    l_ta_ima04 LIKE ima_file.ta_ima04,
                    l_occ02_1  LIKE occ_file.occ02,
                    l_ta_ima08 LIKE ima_file.ta_ima08,
                    l_imaud08  LIKE ima_file.imaud08
           ##---- 20181221 add (E)
           DEFINE   l_oea02    LIKE oea_file.oea02  #20190104
           DEFINE   l_oeb15    LIKE oeb_file.oeb15  #20190104
           DEFINE   l_sfb01    LIKE sfb_file.sfb01  #20230815
#No.FUN-7C0007---Begin 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,? ,?,?,?,?,? ,?,?,?,?,? ",
               "       ,?,?,?,?,? ,?,?,?,?,? ,?,?,?,?,? ",
               "       ,?,?,?,?,? ,?,?) "          #180417 add 1? by ruby #180502 add 2? by ruby  #180913 add 1? by ruby #20181221 add 9?   #20190104 add 2? #20230815                                            
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM                                                                             
   END IF          
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                  
               " VALUES(?,?,?,?,?,?,?,?) "                                                                  
   PREPARE insert_prep1 FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM                                                                             
   END IF                                                                                                                           
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)  
#No.FUN-7C0007---End
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog  #No.FUN-7C0007
#    IF tm.a = 'Y' THEN
#        LET g_len = 136
#    ELSE
#        LET g_len = 102
#    END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
     #End:FUN-980030
 
     #LET l_sql="SELECT oga01,oga02,oga011,oga03,oga032,oga04,oga044,oga14,",   #MOD-870137
     LET l_sql="SELECT oga01,oga02,'',oga03,oga032,oga04,oga044,oga14,",   #MOD-870137
               "       oga15,",
               "       ogb03,ogb04,ogb05,ogb06,ogb09,ogb091,ogb092,",
               #"       ogb12,ogb16,ogb17,ogb31,ogb32,",                                           #180417 mark by ruby
               #"       ogb12,ogb16,ogb17,ogb31,ogb32,pmn01,",                                      #180417 add by ruby #180913 mark by ruby
               "       ogb12,ogb14,ogb16,ogb17,ogb31,ogb32,pmn01,",                                                     #180913 add by ruby
               #"       ogb910,ogb912,ogb913,ogb915 ",         #No.FUN-580004   #MOD-870137
               "       ogb910,ogb912,ogb913,ogb915,oga10 ",         #No.FUN-580004   #MOD-870137
               #"  FROM oga_file,ogb_file "                                                        #180417 mark by ruby
               "  FROM oga_file,ogb_file left join pmn_file on ogb31=pmn24 and ogb32=pmn25  ",      #180417 add by ruby
               "                                       AND EXISTS (SELECT * FROM pmm_file WHERE pmm01=pmn01 AND pmm18='Y') ", #20200115
               " WHERE oga01=ogb01 ",
               "   AND oga09 !='1' ",     #No.B242 010328 by plum 去除出貨通知單
               "   AND oga09 !='5' ",     #No.B311 010406 BY ANN CHEN 去三角貿易
               "   AND oga09 !='7' ",     #No.FUN-610020
               "   AND oga09 !='9' ",     #No.FUN-610020
               "   AND ogaconf != 'X' ",  #No.B311
      	       "   AND ",tm.wc
	 LET l_sql= l_sql CLIPPED," ORDER BY oga01,ogb03 "
     PREPARE axmr610_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE axmr610_curs1 CURSOR FOR axmr610_prepare1
#No.FUN-7C0007---Begin
 
#     CALL cl_outnam('axmr610') RETURNING l_name
#FUN-580004--begin
#     SELECT sma115 INTO g_sma115 FROM sma_file
#     IF g_sma115 = "Y"  THEN
#            LET g_zaa[54].zaa06 = "N"
#     ELSE
#            LET g_zaa[54].zaa06 = "Y"
#     END IF
#      CALL cl_prt_pos_len()
#No.FUN-580004--end
      SELECT sma115 INTO g_sma115 FROM sma_file
      IF g_sma115 = 'Y'  THEN
         LET l_name = 'axmr610'
      ELSE
         LET l_name = 'axmr610_1'       
      END IF
#     START REPORT axmr610_rep TO l_name
 
#     LET g_pageno = 0
#No.FUN-7C0007---End
     FOREACH axmr610_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
#No.FUN-7C0007---Begin
         LET l_occ02=''                                                         #220317 add by ruby
         SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oga04                                                               
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14                                                               
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15                                                               
         IF SQLCA.SQLCODE THEN                                                                                                      
            LET l_gen02='' LET l_gem02=''                                                                                           
         END IF    

         ##---- 20181221 modify                                         
            SELECT oba02,azf03,occ02,ima1007,imaud08,ta_ima03,ta_ima04,ta_ima07,ta_ima08
              INTO l_oba02,l_azf03,l_occ02_1,l_ima1007,l_imaud08,l_ta_ima03,l_ta_ima04,l_ta_ima07,l_ta_ima08
              FROM ima_file
              LEFT JOIN oba_file ON oba01 = ima131
              LEFT JOIN occ_file ON occ01 = ta_ima06
              LEFT JOIN azf_file ON azf01 = ima09 AND azf02='D'
             WHERE ima01=sr.ogb04
            ##---- 20181221 modify   
         
         #220317 add by ruby --s--
         IF length(sr.oga04)='6' THEN
            SELECT ofd02 INTO l_occ02 FROM ofd_file WHERE ofd01=sr.oga04
         END IF
         #220317 add by ruby --e--   

#180502 add by ruby --s--
         SELECT case when ta_ima02='0' then '無軸數' when ta_ima02='1' then '單軸'
            when ta_ima02='2' then '2軸' when ta_ima02='3' then '3軸'
            when ta_ima02='4' then '4軸' when ta_ima02='5' then '5軸'
            when ta_ima02='6' then '6軸' when ta_ima02='7' then '7軸'
            when ta_ima02='8' then '8軸' else ' ' end,ta_ima05 INTO l_ta_ima02,l_ta_ima05 
         FROM ima_file WHERE ima01=sr.ogb04                                                               
         IF SQLCA.SQLCODE THEN                                                                                                      
            LET l_ta_ima02='' LET l_ta_ima05=''                                                                                           
         END IF     
#180502 add by ruby --e--

         SELECT ima906 INTO l_ima906 FROM ima_file                                                                                     
                         WHERE ima01=sr.ogb04                                                                                       
         LET l_str2 = ""                                                                                                               
         IF g_sma115 = "Y" THEN                                                                                                        
            CASE l_ima906                                                                                                              
               WHEN "2"                                                                                                                
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915                                                                   
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED                                                                           
                    IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN                                                                         
                       CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912                                                               
                       LET l_str2 = l_ogb912, sr.ogb910 CLIPPED                                                                        
                    ELSE                                                                                                                
                       IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN                                                                 
                        CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912                                                             
                        LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED                                                   
                       END IF                                                                                                           
                    END IF                                                                                                              
                WHEN "3"                                                                                                                
                    IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN                                                                    
                       CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915 
                       LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED                                                                       
                    END IF                                                                                                              
            END CASE                                                                                                                   
         ELSE                                                                                                                          
         END IF                                                                                                                        
         
         SELECT ima021  INTO l_ima021 FROM ima_file WHERE ima01=sr.ogb04 
 
            IF sr.ogb17 = 'Y' THEN                                                                                                 
              LET l_sql=" SELECT ogc17,ogc15,ogc09,ogc091,ogc16,ogc092",#No.FUN-5C0075                                             
                         "   FROM ogc_file ",                                                                                      
                         "  WHERE ogc01 = '",sr.oga01,"' AND ogc03 ='",sr.ogb03,"'"                                                
            ELSE                                                                                                                   
               LET l_sql=" SELECT '','',ogb09,ogb091,ogb16,ogb092",#No.FUN-5C0075                                                  
                         "   FROM ogb_file ",                                                                                      
                         "  WHERE ogb01 = '",sr.oga01,"' AND ogb03 ='",sr.ogb03,"'"                                                
            END IF                                                                                                                 
            PREPARE r600_p2 FROM l_sql                                                                                             
            DECLARE r600_c2 CURSOR FOR r600_p2                                                                                     
            LET i = 0                                                                                                              
            FOREACH r600_c2 INTO l_ogc.*                                                                                           
               IF STATUS THEN EXIT FOREACH END IF                                                                                  
                                                                                                 
               SELECT oaz23  INTO g_oaz23 FROM oaz_file
            IF sr.ogb17 = 'N' THEN
               LET l_ogc.ogc15=''
               LET l_ogc.ogc17='' 
            END IF           
              EXECUTE insert_prep1 USING 
                 sr.oga01,sr.ogb03,l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,l_ogc.ogc15,
                 l_ogc.ogc16,l_ogc.ogc17                                                                           
            END FOREACH
            #-----MOD-870137---------
            SELECT oma10 INTO sr.oma10 FROM oma_file 
              WHERE oma01 = sr.oga10
            #-----END MOD-870137-----

            ##---- 20190104 add by momo (S)
            SELECT oea02,oeb15 INTO l_oea02,l_oeb15
              FROM oea_file,oeb_file
            WHERE oea01=oeb01
              AND oea01 = sr.ogb31 AND oeb03 = sr.ogb32
            ##---- 20190104 add by momo (E)

            ##---- 20230815 add by momo (S)
            LET l_sfb01=''
            SELECT sfb01 INTO l_sfb01 FROM sfb_file
             WHERE sfb22 = sr.ogb31
               AND sfb221 = sr.ogb32
            ##---- 20230815 add by momo (E)

 
            EXECUTE insert_prep USING   
                 sr.oga01,
                 l_oea02,l_oeb15,                                                                               #20190104
                 sr.oma10,sr.oga02,sr.oga03,sr.oga032,sr.oga04,sr.oga14,sr.oga15,   #MOD-870137  oga011-->oma10
                 #sr.ogb03,sr.ogb04,sr.ogb05,sr.ogb06,sr.ogb12,sr.ogb17,sr.ogb31,sr.ogb32,l_occ02,              #180417 mark by ruby
                 #sr.ogb03,sr.ogb04,sr.ogb05,sr.ogb06,sr.ogb12,sr.ogb17,sr.ogb31,sr.ogb32,sr.pmn01,l_occ02,      #180417 add by ruby #180913 mark by ruby
                 sr.ogb03,sr.ogb04,sr.ogb05,sr.ogb06,sr.ogb12,sr.ogb14,sr.ogb17,sr.ogb31,sr.ogb32,sr.pmn01,l_occ02,                  #180913 add by ruby
                 l_gen02,l_gem02,l_ima021,l_ta_ima02,l_ta_ima05,                                                 #180402 add ta_ima02,ta_ima05 by ruby
                 l_oba02,l_azf03,l_ima1007,l_ta_ima03,l_ta_ima04,l_occ02_1,l_ta_ima07,l_ta_ima08,l_imaud08,      #20181221 add
                 l_sfb01,                                                                                        #20230815
                 l_str2
#        OUTPUT TO REPORT axmr610_rep(sr.*)
#No.FUN-7C0007---End
     END FOREACH
#No.FUN-7C0007---Begin
#     FINISH REPORT axmr610_rep
      IF g_zz05 = 'Y' THEN                                                      
              CALL cl_wcchp(tm.wc,'oga01,oga011,oga02,ogb04,oga03,oga04,oga14,oga15')   #221027 add ogb04 by ruby                      
              RETURNING tm.wc                                                   
      END IF                                                                    
      LET g_str=tm.wc,";",g_oaz23
      LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED,"|",
                  "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED
      CALL cl_prt_cs3('axmr610',l_name,l_sql,g_str)
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7C0007---End
END FUNCTION
#No.FUN-7C0007---Begin
#REPORT axmr610_rep(sr)
#   DEFINE l_last_sw   LIKE type_file.chr1,        # No.FUN-680137  VARCHAR(1)
#          sr        RECORD
#                    oga01     LIKE oga_file.oga01,
#                    oga02     LIKE oga_file.oga02,
#                    oga011    LIKE oga_file.oga011,
#                    oga03     LIKE oga_file.oga03,
#                    oga032    LIKE oga_file.oga032,
#                    oga04     LIKE oga_file.oga04,
#                    oga044    LIKE oga_file.oga044,
#                    oga14     LIKE oga_file.oga14,
#                    oga15     LIKE oga_file.oga15,
#                    ogb03     LIKE ogb_file.ogb03,
#                    ogb04     LIKE ogb_file.ogb04,
#                    ogb05     LIKE ogb_file.ogb05,
#                    ogb06     LIKE ogb_file.ogb06,
#                    ogb09     LIKE ogb_file.ogb09,
#                    ogb091    LIKE ogb_file.ogb091,
#                    ogb092    LIKE ogb_file.ogb092,
#                    ogb12     LIKE ogb_file.ogb12,
#                    ogb16     LIKE ogb_file.ogb16,
#                    ogb17     LIKE ogb_file.ogb17,
#                    ogb31     LIKE ogb_file.ogb31,
#                    ogb32     LIKE ogb_file.ogb32,
#                    ogb910    LIKE ogb_file.ogb910,     #No.FUN-580004
#                    ogb912    LIKE ogb_file.ogb912,     #No.FUN-580004
#                    ogb913    LIKE ogb_file.ogb913,     #No.FUN-580004
#                    ogb915    LIKE ogb_file.ogb915      #No.FUN-580004
#					END RECORD,
#         l_buf   ARRAY[10] OF LIKE type_file.chr1000,   # No.FUN-680137 VARCHAR(46)
#         l_buf2  ARRAY[10] OF LIKE ogc_file.ogc16,
#         l_ogc   RECORD
#                    ogc17     LIKE ogc_file.ogc17,      #No.FUN-5C0075
#                    ogc15     LIKE ogc_file.ogc15,      #No.FUN-5C0075
#                    ogc09     LIKE ogc_file.ogc09,
#                    ogc091    LIKE ogc_file.ogc091,
#                    ogc16     LIKE ogc_file.ogc16,
#                    ogc092    LIKE ogc_file.ogc092
#                 END RECORD,
#         l_flag     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#         l_occ02    LIKE occ_file.occ02,
#         l_gen02    LIKE gen_file.gen02,
#         l_gem02    LIKE gem_file.gem02,
#         l_ogb12    LIKE ogb_file.ogb12,
#         l_ima021   LIKE ima_file.ima021,
#         l_sql      LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
#         i,j	    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#         l_rowno    LIKE type_file.num5,         # No.FUN-680137 SMALLINT
#         l_ogb04092 LIKE type_file.chr1000       # No.FUN-680137 VARCHAR(50)
##No.FUN-580004--begin
#    DEFINE  l_ogb915   STRING
#   DEFINE  l_ogb912   STRING
#   DEFINE  l_str2     STRING
#   DEFINE  l_ima906    LIKE ima_file.ima906
##No.FUN-580004--end
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.oga01,sr.ogb03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      PRINT ''
 
#      PRINT g_dash[1,g_len]
 
#No.FUN-5C0075  --start--
#      PRINTX name=H1
#             g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#             g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
#             g_x[47],g_x[54],g_x[48],
#             g_x[49],g_x[50],g_x[51],g_x[52],g_x[53]
#      PRINTX name=H2
#             g_x[56],g_x[57],g_x[58],g_x[59],g_x[60],g_x[61],g_x[62],g_x[63],
#             g_x[64],g_x[65],g_x[66],g_x[67],g_x[68],g_x[69],g_x[70]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#No.FUN-5C0075  --end--
 
#   BEFORE GROUP OF sr.oga01
#         LET l_rowno =1
#         SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oga04
#        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
#        SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
#        IF SQLCA.SQLCODE THEN
#           LET l_gen02='' LET l_gem02=''
#        END IF
#        PRINTX name=D1
#              COLUMN g_c[31],sr.oga01,
#              COLUMN g_c[32],sr.oga02,
#              COLUMN g_c[33],sr.oga011 CLIPPED,
#              COLUMN g_c[34],sr.oga03,
#              COLUMN g_c[35],sr.oga032,
#              COLUMN g_c[36],sr.oga04,
#              COLUMN g_c[37],l_occ02,
#              COLUMN g_c[38],sr.oga14,
#              COLUMN g_c[39],l_gen02,
#              COLUMN g_c[40],sr.oga15,
#              COLUMN g_c[41],l_gem02 CLIPPED;
 
#  ON EVERY ROW
 
#FUN-580004--begin
 
#     SELECT ima906 INTO l_ima906 FROM ima_file
#                        WHERE ima01=sr.ogb04
#     LET l_str2 = ""
#     IF g_sma115 = "Y" THEN
#        CASE l_ima906
#           WHEN "2"
#               CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
#               LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
#               IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
#                   CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
#                   LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
#               ELSE
#                  IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
#                     CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
#                     LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
#                  END IF
#               END IF
#           WHEN "3"
#               IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
#                   CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
#                   LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
#               END IF
#        END CASE
#     ELSE
#     END IF
#FUN-580004--end
#        SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.ogb04 #No.FUN-5C0075
#        PRINTX name=D1
#              COLUMN g_c[42],sr.ogb03 USING '####',
#              COLUMN g_c[43],sr.ogb31 CLIPPED,
#              COLUMN g_c[44],sr.ogb32 USING '####',
#              COLUMN g_c[45],sr.ogb04 CLIPPED,  #No.FUN-580004  #NO.FUN-5B0015
#              COLUMN g_c[46],sr.ogb06 CLIPPED,
#              COLUMN g_c[47],l_ima021 CLIPPED,
#              COLUMN g_c[54],l_str2 CLIPPED,
#              COLUMN g_c[48],sr.ogb05 CLIPPED,
#              COLUMN g_c[49],sr.ogb12 USING '############.##'
 
##         IF tm.a = 'N' THEN                         #No.FUN-7C0007漏mark tm.a
##	    PRINT ''                                  #No.FUN-7C0007漏mark tm.a
##         ELSE                                       #No.FUN-7C0007漏mark tm.a
##            IF tm.a ='Y' AND sr.ogb17 = 'Y' THEN    #No.FUN-7C0007漏mark tm.a
#            IF sr.ogb17 = 'Y' THEN
#              LET l_sql=" SELECT ogc17,ogc15,ogc09,ogc091,ogc16,ogc092",#No.FUN-5C0075
#                         "   FROM ogc_file ",
#                         "  WHERE ogc01 = '",sr.oga01,"' AND ogc03 ='",sr.ogb03,"'"
#            ELSE
#               LET l_sql=" SELECT '','',ogb09,ogb091,ogb16,ogb092",#No.FUN-5C0075
#                         "   FROM ogb_file ",
#                         "  WHERE ogb01 = '",sr.oga01,"' AND ogb03 ='",sr.ogb03,"'"
#            END IF
#            PREPARE r600_p2 FROM l_sql
#            DECLARE r600_c2 CURSOR FOR r600_p2
#            LET i = 0
#            FOREACH r600_c2 INTO l_ogc.*
#               IF STATUS THEN EXIT FOREACH END IF
#No.FUN-5C0075  --start--
#               SELECT oaz23  INTO g_oaz23 FROM oaz_file
#               IF g_oaz23='Y'THEN
#                  PRINTX name=D1
#                        COLUMN g_c[45],l_ogc.ogc17 CLIPPED,
#                        COLUMN g_c[48],l_ogc.ogc15 CLIPPED;
#               END IF
#No.FUN-5C0075  --end--
#                  PRINTX name=D1
#                        COLUMN g_c[50],l_ogc.ogc09 CLIPPED,
#	                COLUMN g_c[51],l_ogc.ogc091 CLIPPED,
#	                COLUMN g_c[52],l_ogc.ogc092 CLIPPED,
#                        COLUMN g_c[53],l_ogc.ogc16 USING '##########&.###'
#                LET i = i + 1
#             END FOREACH
#             IF i = 0 THEN
#                PRINT ''
#             END IF
##         END IF                       #No.FUN-7C0007漏mark tm.a
 
#  AFTER GROUP OF sr.oga01
#     LET l_ogb12= GROUP SUM(sr.ogb12)
#     PRINTX name=D3
#           COLUMN g_c[48],g_x[11] CLIPPED,
#           COLUMN g_c[49],l_ogb12 USING '############.##'
#     PRINT ''
 
#  ON LAST ROW                         #金額總計
#     #是否列印選擇條件
#     IF g_zz05 = 'Y' THEN
#        CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05')
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
#        #TQC-630166
#        #     IF tm.wc[001,070] > ' ' THEN            # for 80
#        #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        #     IF tm.wc[071,140] > ' ' THEN
#        # PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#        #     IF tm.wc[141,210] > ' ' THEN
#        # PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        #     IF tm.wc[211,280] > ' ' THEN
#        # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#        CALL cl_prt_pos_wc(tm.wc)
#        #END TQC-630166
#     END IF
#     PRINT g_dash[1,g_len]
## FUN-550127
#    #PRINT COLUMN g_c[31],g_x[04] CLIPPED,
#    #      COLUMN g_c[34],g_x[05] CLIPPED,
#    #      COLUMN g_c[37],g_x[09] CLIPPED,
#    #      COLUMN g_c[40],g_x[10] CLIPPED,
#     PRINT COLUMN (g_len-9),g_x[7] CLIPPED  #No.FUN-580004
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash[1,g_len]
#       #PRINT COLUMN g_c[31],g_x[04] CLIPPED,
#       #      COLUMN g_c[34],g_x[05] CLIPPED,
#       #      COLUMN g_c[37],g_x[09] CLIPPED,
#       #      COLUMN g_c[40],g_x[10] CLIPPED,
#        PRINT COLUMN (g_len-9),g_x[6] CLIPPED  #No.FUN-580004
#     ELSE
#        SKIP 2 LINE
#     END IF
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[4]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[4]
#            PRINT g_memo
#     END IF
## END FUN-550127
 
#END REPOR
#No.FUN-7C0007---End
