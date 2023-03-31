# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: csfr410.4gl
# Descriptions...: 生產排程明細表
# Date & Author..: 95/01/07 by Nick
# Modify.........: No.8262 03/09/26 Carol 選擇排列項目,報表不會排序
#                                         --> 修改report 的order by
# Modify.........: No.8991 04/01/28 Kammy 應區分不同幣別列印
# Modify.........: No.FUN-4A0016 04/10/04 Echo 訂單單號,帳款客戶,送貨客戶,人員編號要開窗
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-580004 05/08/03 By wujie 雙單位報表格式修改
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.MOD-5C0054 05/12/09 By Nicola 連續執行時，金額加總會不見
# Modify.........: No.FUN-580031 06/01/06 By saki QBE查詢條件紀錄
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-670022 06/07/10 By Pengu 條件選項的排序中，選擇3:帳款客戶，但列印出來卻未按帳款客戶排序。
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/28 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.FUN-7A0036 07/11/07 By baofei 報表輸出至Crystal Reports功能 
# Modify.........: No.MOD-7B0154 07/11/16 By zhoufeng 打印總數量(tm.c)在畫面上有但是程序邏輯中沒有處理
# Modify.........: No.FUN-850142 08/06/30 By xiaofeizhu 增加"是否要印結案資料"的功能
# Modify.........: No.TQC-940009 09/04/08 By sabrina 增加〝僅印出未完全出貨之訂單〞功能
# Modify.........: No.CHI-970045 09/07/22 By sabrina 印報表時應排除借貨訂單，因在axmr422有處理借貨訂單資料
# Modify.........: No.TQC-A50044 10/05/17 By Carrier 加一行資料庫呼叫語法
# Modify.........: No.TQC-B30058 11/03/08 By zhangll l_sql -> STRING
# Modify.........: No.FUN-960004 11/05/11 By lixiang 增加列印條件--訂單類別oea00
# Modify.........: No.TQC-C90095 12/09/24 By dongsz 1.增加合約編碼、留置碼的欄位開窗
#                                                   2.漢化打印條件
# Modify.........: No.MOD-CC0246 13/01/31 By jt_chen 修正外部參數的傳接值順序
# Modify.........: No:MOD-E50070 14/05/15 By Reanna 依條件儲存所帶出來的資料，在列印時，依然以預設值顯示
# Modify.........: No:FUN-EA0031 14/10/16 By Sulamite 增加新鞋服報表功能
# Modify.........: No:           17/12/28 By Ruby 新增客戶訂單/送貨客戶/匯率
# Modify.........: No:           18/03/05 By Ruby 新增批號
# Modify.........: 20180409 add by momo 增加顯示 排定交貨日 oeb16
# Modify.........: No:           18/05/24 By Ruby 新增是否提供馬達
# Modify.........: 20180723 add by momo 增加顯示 最小工作站說明與國別
# Modify.........: No:           18/08/15 By Ruby 增加已出貨數量
# Modify.........: No:           18/10/12 By Ruby 增加含稅金額
# Modify.........: No:           19/04/18 By Ruby 增加客戶產品編號
# Modify.........: No:           19/04/22 By Ruby 增加客戶產品名稱&規格
# Modify.........: No:           19/05/09 By Ruby 增加條件 品名/規格
# Modify.........: NO:1908013429 20190806 By momo 新增列印單身交運方式oeb20與訂單中請購單號oeb27
# Modify.........: NO:1908273548 20190828 By momo 新增列印到達地oea42
# Modify.........: NO:2105126212 20210517 By momo 新增列印延期原因 tc_oeq07
# Modify.........: No:2108316856 20210906 By momo 新增列印發料站別
# Modify.........: No:2203037682 20220317 By momo 新增列印雜發需求
# Modify.........: No:23030027   20230321 By momo 國別抓取調整為抓取帳款客戶
# Modify.........: No:23030054   20230331 By momo 增加訂單單身備註

DATABASE ds  #No.TQC-A50044
 
GLOBALS "../../../tiptop/config/top.global"
 
#No.FUN-580004--begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
#No.FUN-580004--end
 
DEFINE tm         RECORD
               #      wc      VARCHAR(500),            # QBE 條件
                     wc      STRING,           #TQC-630166   # QBE 條件
                     s       LIKE type_file.chr3,        # Prog. Version..: '5.30.24-17.04.13(03)             # 排列 (INPUT 條件)
                     t       LIKE type_file.chr3,        # Prog. Version..: '5.30.24-17.04.13(03)             # 跳頁 (INPUT 條件)
                     u       LIKE type_file.chr3,        # Prog. Version..: '5.30.24-17.04.13(03)             # 合計 (INPUT 條件)
                     a       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
                     b       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
                     c       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
                     d       LIKE type_file.chr1,        # No.FUN-EA0031 
                     more    LIKE type_file.chr1,        # Prog. Version..: '5.30.24-17.04.13(01)              # 輸入其它特殊列印條件
                     oea00   LIKE oea_file.oea00,        # No.FUN-960004
                     x       LIKE type_file.chr1,        # No.FUN-850142 VARCHAR(01)
                     v       LIKE type_file.chr1,        # No.TQC-940009 VARCHAR(01)
                     bdate   LIKE ina_file.inaud13,         # 20220317
                     edate   LIKE ina_file.inaud13          # 20220317
                  END RECORD
DEFINE g_orderA   ARRAY[3] OF LIKE faj_file.faj02        # No.FUN-680137 VARCHAR(10)  # 篩選排序條件用變數
DEFINE g_i        LIKE type_file.num5          #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE g_head1    STRING
#FUN-580004--begin
DEFINE g_sma115   LIKE sma_file.sma115
DEFINE g_sma116   LIKE sma_file.sma116
#DEFINE l_sql      LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(1000)
DEFINE l_sql      STRING  #Mod No.TQC-B30058
DEFINE l_zaa02    LIKE zaa_file.zaa02
DEFINE i          LIKE type_file.num10         # No.FUN-680137 INTEGER
#FUN-580004--end
#No.FUN-7A0036---Begin                                                                                                              
DEFINE l_table        STRING,                                                                                                       
       g_str          STRING,                                                                                                       
       g_sql          STRING                                                                                                       
#No.FUN-7A0036---End   
DEFINE l_table1       STRING   #FUN-EA0031
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   #--外部程式傳遞參數或 Background Job 時接受參數 --#
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.t     = ARG_VAL(9)
   LET tm.u     = ARG_VAL(10)
   LET tm.a     = ARG_VAL(11)
   LET tm.b     = ARG_VAL(12)
#   LET tm.c     = ARG_VAL(13)          #No.FUN-7B0154
#------------No.TQC-610089 modify
  #LET tm.more  = ARG_VAL(14)
   #MOD-CC0246 -- add start --   #參數順序搬移
   LET tm.x     = ARG_VAL(13)   
   LET tm.v     = ARG_VAL(14) 
   LET tm.d     = ARG_VAL(15)    #FUN-EA0031 add
   LET tm.oea00 = ARG_VAL(16)    #FUN-EA0031 modify ARG_VAL(15) -> ARG_VAL(16)
   #MOD-CC0246 -- add end --     #參數順序搬移
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(17)                   #MOD-CC0246 modify ARG_VAL(15) -> ARG_VAL(16)   #FUN-EA0031 modify ARG_VAL(16) -> ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)                   #MOD-CC0246 modify ARG_VAL(16) -> ARG_VAL(17)   #FUN-EA0031 modify ARG_VAL(17) -> ARG_VAL(18)
   LET g_template = ARG_VAL(19)                   #MOD-CC0246 modify ARG_VAL(17) -> ARG_VAL(18)   #FUN-EA0031 modify ARG_VAL(18) -> ARG_VAL(19)
   LET g_rpt_name = ARG_VAL(20)  #No.FUN-7C0078   #MOD-CC0246 modify ARG_VAL(18) -> ARG_VAL(19)   #FUN-EA0031 modify ARG_VAL(19) -> ARG_VAL(20)
   #No.FUN-570264 ---end---
#------------No.TQC-610089 end
  #MOD-CC0246 -- mark start --   #參數順序搬移
  #LET tm.x     = ARG_VAL(19)    #No.FUN-850142
  #LET tm.v     = ARG_VAL(20)    #No.TQC-940009
  #LET tm.oea00 = ARG_VAL(21)    #FUN-960004 
  #MOD-CC0246 -- mark end --     #參數順序搬移

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
#No.FUN-7A0036---Begin
   LET g_sql = "oea01.oea_file.oea01,",
               "oea02.oea_file.oea02,",
               "oea03.oea_file.oea03,",
               "oea032.oea_file.oea032,",
               "oea04.oea_file.oea04,",
               "oea10.oea_file.oea10,",      #add by ruby 2017/12/28
               "oea044.oea_file.oea044,",    #add by ruby 2017/12/28
               "oea01_3.oea_file.oea01,",    #add by ruby 2018/03/05
               "oea14.oea_file.oea14,",
               "oea15.oea_file.oea15,",
               "oea42.oea_file.oea42,",     #到達地 20190828
               "oeaconf.oea_file.oeaconf,",
               "oeahold.oea_file.oeahold,",
               "occ02.occ_file.occ02,",
               "occ21.geb_file.geb02,",     #國別 20180723 add 
               "oea915.occ_file.occ02,",    #20180410 add
               "oea916.occ_file.occ02,",    #20180410 add
               "gen02.gen_file.gen02,",
               "gem02.gem_file.gem02,",
               "oeb03.oeb_file.oeb03,",
               "oeb04.oeb_file.oeb04,",
               "oeb05.oeb_file.oeb05,",
               "oeb06.oeb_file.oeb06,",
               "oeb11.oeb_file.oeb11,",     #190418 add by ruby
               "oeb12.oeb_file.oeb12,",
               "oeb24.oeb_file.oeb24,",     #180815 add by ruby
               "oeb15.oeb_file.oeb15,",
               "oeb16.oeb_file.oeb16,",         #20180409 add
               "oeb20.ged_file.ged02,",         #20190806
               "oeb27.oeb_file.oeb27,",         #20190806
               "oao06.oao_file.oao06,",         #訂單單身備註 20230331
               "sfb13.sfb_file.sfb13,",         #工單開工日
               "sfw03.sfw_file.sfw03,",         #工單備註
               "azf03.azf_file.azf03,",         #排交變更原因類別
               "tc_oeq07.tc_oeq_file.tc_oeq07,",#延期原因 20210517
               "oga02.oga_file.oga02,",         #出貨日
               "l_str2.type_file.chr1000,",
               "oeb916.oeb_file.oeb916,",
               "oeb917.oeb_file.oeb917,",
               "l_oeocnt.type_file.num5,",     #180524 add by ruby
               "ima021.ima_file.ima021,",
               "ta_ima02.type_file.num5,",  #20190716
               "ima906.ima_file.ima906,",   
               "eca02.eca_file.eca02,",        #工作站名稱 20180723 add
               "eca02_2.eca_file.eca02,",      #工作站名稱發料用 20210906 add
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('csfr410',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
  #FUN-EA0031--add str--
   LET g_sql="oebc01.oebc_file.oebc01, oebc03.oebc_file.oebc03,",
             "oebc05.oebc_file.oebc05, oebc05_name.agd_file.agd03,",
             "oebc06.oebc_file.oebc06, oebc06_name.agd_file.agd03,",
             "oebc07.oebc_file.oebc07, oebc07_1.oebc_file.oebc07,",
             "oebc07_2.oebc_file.oebc07, oebc07_3.oebc_file.oebc07,",
             "oebc07_4.oebc_file.oebc07,",
             "agd04_color.agd_file.agd04, agd04_size.agd_file.agd04 "
   LET l_table1 = cl_prt_temptable('csfr4101',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
  #FUN-EA0031--add end--
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?,?,? ",
               "       ,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?,?,?  ",
               "       ,?,?,?,?,?, ?,?,?) "          #20190806 #20190828 #20210517 #20210906 #20230331                                       
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF             
  #FUN-EA0031--add str--
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
  #FUN-EA0031--add end--

#No.FUn-7A0036---End
   IF NOT cl_null(tm.wc) THEN
      CALL r410()
#      DROP TABLE curr_tmp      #No.FUN-7A0036
   ELSE
      CALL r410_tm(0,0)
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION r410_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
 
   LET p_row = 3 LET p_col = 11
   OPEN WINDOW r410_w AT p_row,p_col WITH FORM "csf/42f/csfr410"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   #預設畫面欄位
   INITIALIZE tm.* TO NULL
   LET tm2.s1  = '1'
   LET tm2.u1  = 'N'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.a    = '3'
   LET tm.b    = '3'
#   LET tm.c    = 'N'       #No.FUN-7B0154
   LET tm.more = 'N'
   LET tm.bdate = g_today   #20220317
   LET tm.edate = g_today   #20220317
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.x    = 'Y'        #No.FUN-850142
   LET tm.v    = 'Y'        #No.TQC-940009
   LET tm.oea00= 'A'        #No.FUN-960004
  #FUN-EA0031--add str--
   IF s_industry("slk") AND g_sma.sma150='Y' THEN
      CALL cl_set_comp_visible("d",TRUE)
      LET tm.d='Y'
   ELSE
      CALL cl_set_comp_visible("d",FALSE)
      LET tm.d='N'
   END IF
  #FUN-EA0031--add end--

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04,
                                 oea14,oea15,oeb04,oeb06,ima021,
                                 oeb15,oeb16,sfb13,
                                 oeb20                           #20190805
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT

 
         ## No.FUN-4A0016
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oea01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oea5"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea01
                 NEXT FIELD oea01
 
               WHEN INFIELD(oea03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea03
                 NEXT FIELD oea03
 
               WHEN INFIELD(oea04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea04
                 NEXT FIELD oea04
 
               WHEN INFIELD(oea14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea14
                 NEXT FIELD oea14
 
               WHEN INFIELD(oea15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea15
                 NEXT FIELD oea15
 
               WHEN INFIELD(oeb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb04
                 NEXT FIELD oeb04

              #TQC-C90095 add end---
              ##---- 20190805 add 交運方式
              WHEN INFIELD(oeb20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ged"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb20
                 NEXT FIELD oeb20
            END CASE
         ## END  No.FUN-4A0016
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW r410_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.bdate,tm.edate,                                              #20220317
                    tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.a,tm.b,tm.more,tm.oea00,tm.x,tm.v,tm.d  #No.MOD-7B0154  #FUN-850142 Add tm.x  #TQC-940009 add tm.v   #No.FUN-960004 add tm.oea00  #FUN-EA0031 add tm.d
            WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
            #MOD-E50070 add-----------------------------------------------------
            LET tm2.s1 = GET_FLDBUF(s1)
            LET tm2.s2 = GET_FLDBUF(s2)
            LET tm2.s3 = GET_FLDBUF(s3)
            LET tm2.t1 = GET_FLDBUF(t1)
            LET tm2.t2 = GET_FLDBUF(t2)
            LET tm2.t3 = GET_FLDBUF(t3)
            LET tm2.u1 = GET_FLDBUF(u1)
            LET tm2.u2 = GET_FLDBUF(u2)
            LET tm2.u3 = GET_FLDBUF(u3)
            LET tm.a = GET_FLDBUF(a)
            LET tm.b = GET_FLDBUF(b)
            LET tm.oea00 = GET_FLDBUF(oea00)
            LET tm.x = GET_FLDBUF(x)
            LET tm.v = GET_FLDBUF(v)
            LET tm.d = GET_FLDBUF(d)            #FUN-EA0031 add
            LET tm.more = GET_FLDBUF(more)
            #MOD-E50070 add end-------------------------------------------------
 
         AFTER FIELD a
            IF tm.a NOT MATCHES '[123]' THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
            IF tm.b NOT MATCHES '[123]' THEN
               NEXT FIELD b
            END IF
 

  
        #FUN-EA0031--add str--
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
               NEXT FIELD d
            END IF
        #FUN-EA0031--add end--
 
         AFTER FIELD more    #是否輸入其它特殊條件
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF

         #No.FUN-960004 --add--
          AFTER FIELD oea00
             IF tm.oea00 NOT MATCHES '[A1234]' THEN
                NEXT FIELD oea00
             END IF
         #No.FUN-960004 --end--
 
         #No.FUN-850142 --Add--                                                                                                     
          AFTER FIELD x
            IF NOT cl_null(tm.x) THEN   #TQC-940009 add
               IF tm.x NOT MATCHES '[YN]' THEN
                  NEXT FIELD x
               END IF
            #TQC-940009
            END IF
            #TQC-940009
         #No.FUN-850142 --end--
 
        #No.TQC-940009--Add--start--
         AFTER FIELD v
            IF NOT cl_null(tm.v) THEN
               IF tm.v NOT MATCHES '[YN]' THEN
                  NEXT FIELD v
               END IF
            END IF
        #No.TQC-940009--add--end--
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW r410_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='csfr410'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('csfr410','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                       #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                       #----------------No.TQC-610089 add
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
#                       " '",tm.c CLIPPED,"'",                 #No.MOD-7B0154   
                       #----------------No.TQC-610089 end
                       #MOD-CC0246 -- add start --  #參數搬移
                        " '",tm.x CLIPPED,"'",
                        " '",tm.v CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",                 #No.FUN-EA0031 
                        " '",tm.oea00 CLIPPED,"'",  #MOD-CC0246 add
                       #MOD-CC0246 -- add end --    #參數搬移
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078      #MOD-CC0246 remove ,
                       #MOD-CC0246 -- mark start -- #參數搬移
                       #" '",tm.x CLIPPED,"'",                 #No.FUN-850142
                       #" '",tm.v CLIPPED,"'"                  #No.TQC-940009 add
                       #MOD-CC0246 -- mark end --   #參數搬移
            CALL cl_cmdat('csfr410',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r410_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL r410()
 
      ERROR ""
   END WHILE
 
#   DROP TABLE curr_tmp   #No.MOD-5C0054    #No.FUN-7A0036
 
   CLOSE WINDOW r410_w
 
END FUNCTION
 
FUNCTION r410()
DEFINE l_name    LIKE type_file.chr20           # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
DEFINE l_sql     STRING  #Mod No.TQC-B30058
DEFINE l_za05    LIKE type_file.chr1000         #No.FUN-680137 VARCHAR(40)
DEFINE l_str2    LIKE type_file.chr1000         #No.FUN-7A0036                  
DEFINE l_ima021  LIKE ima_file.ima021           #No.FUN_7A0036
DEFINE l_ta_ima02 LIKE type_file.num5
DEFINE l_order   ARRAY[5] OF LIKE aaf_file.aaf03          # No.FUN-680137 VARCHAR(40)               #FUN-560074
#No.FUN-7A0036---Begin
   DEFINE  l_oeb915    LIKE type_file.chr1000                                                                                                       
   DEFINE  l_oeb912    LIKE type_file.chr1000                                                                                                       
   DEFINE  l_oeb12     LIKE type_file.chr1000                                                                                                      
   DEFINE  l_ima906    LIKE ima_file.ima906 
   DEFINE  l_oea01_3   LIKE oea_file.oea01           #add by ruby 2018/03/05
   DEFINE  l_eca02     LIKE eca_file.eca02           #最小工作站名稱 20180723 add
   DEFINE  l_eca02_2   LIKE eca_file.eca02           #最小發料工作站名稱 20210906 add
   DEFINE  l_sfw03     LIKE sfw_file.sfw03           #工單備註
   DEFINE  l_azf03     LIKE azf_file.azf03           #排交原因備註
   DEFINE  l_tc_oeq07  LIKE tc_oeq_file.tc_oeq07     #延期原因說明 20210517
#No.FUN-7A0036---End
DEFINE sr        RECORD order1  LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)              #FUN-560074
                        order2  LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)              #FUN-560074
                        order3  LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)              #FUN-560074
                        oea01   LIKE oea_file.oea01,
                        oea02   LIKE oea_file.oea02,
                        oea03   LIKE oea_file.oea03,
                        oea032  LIKE oea_file.oea032,	#客戶簡稱
                        oea04   LIKE oea_file.oea04,	#客戶編號
                        oea10   LIKE oea_file.oea10,  #add by ruby 2017/12/28
                        oea044  LIKE oea_file.oea044, #add by ruby 2017/12/28
                        occ02   LIKE occ_file.occ02,	#客戶簡稱
                        occ21   LIKE geb_file.geb02,	#國別 20180723 add
                        oea915  LIKE occ_file.occ02,	#多角帳款客戶簡稱 #20180410
                        oea916  LIKE occ_file.occ02,	#多角送貨客戶簡稱 #20180410
                        gen02   LIKE gen_file.gen02,
                        gem02   LIKE gem_file.gem02,
                        oea42   LIKE oea_file.oea42,    #到達地 20190828 
                        oeahold LIKE oea_file.oeahold,
                        oeaconf LIKE oea_file.oeaconf,
                        oea14   LIKE oea_file.oea14,    #FUN-4C0096
                        oea15   LIKE oea_file.oea15,    #FUN-4C0096
                        oeb03   LIKE oeb_file.oeb03,
                        oeb04   LIKE oeb_file.oeb04,
                        oeb06   LIKE oeb_file.oeb06,
                        oeb05   LIKE oeb_file.oeb05,
                        oeb11   LIKE oeb_file.oeb11,    #190418 add by ruby
                        oeb12   LIKE oeb_file.oeb12,
                        oeb24   LIKE oeb_file.oeb24,    #180815 add by ruby
                        oeb15   LIKE oeb_file.oeb15,
                        oeb16   LIKE oeb_file.oeb16,    #20180409 add
                        oeb20   LIKE ged_file.ged02,    #20190806
                        oeb27   LIKE oeb_file.oeb27,    #20190806
                        oao06   LIKE oao_file.oao06,    #訂單單身備註 20230331
                        sfb13   LIKE sfb_file.sfb13,
                        oga02   LIKE oga_file.oga02,
                        oeb910  LIKE oeb_file.oeb910,   #FUN-580004
                        oeb912  LIKE oeb_file.oeb912,   #FUN-580004
                        oeb913  LIKE oeb_file.oeb913,   #FUN-580004
                        oeb915  LIKE oeb_file.oeb915,   #FUN-580004
                        oeb916  LIKE oeb_file.oeb916,   #FUN-580004
                        oeb917  LIKE oeb_file.oeb917,   #FUN-580004
                        sfb01   LIKE sfb_file.sfb01,    #20210906 工單單號
                        ima021  LIKE ima_file.ima021    #20220318 規格
                        END RECORD
#FUN-EA0031--add str--
DEFINE   l_oebc05       LIKE oebc_file.oebc05,          
         l_oebc06       LIKE oebc_file.oebc06,
         l_oebc05_name  LIKE agd_file.agd03,            #size
         l_oebc06_name  LIKE agd_file.agd03,            #color
         l_oebc07       LIKE oebc_file.oebc07,
         l_oebc07_1     LIKE oebc_file.oebc07,          #amount  1-10
         l_oebc07_2     LIKE oebc_file.oebc07,          #amount 11-20
         l_oebc07_3     LIKE oebc_file.oebc07,          #amount 21-30
         l_oebc07_4     LIKE oebc_file.oebc07,          #amount 31-40
         l_next         LIKE type_file.num5,            #目前執行筆數
         l_agd04_color  LIKE agd_file.agd04,            #顏色的順序
         l_agd04_size   LIKE agd_file.agd04,            #尺寸的順序
         l_flag         LIKE type_file.chr1,
         l_cnt          LIKE type_file.num5,
         l_oeocnt       LIKE type_file.num5             #180524 add by ruby
#FUN-EA0031--add end--

DEFINE l_ta_obk02       LIKE obk_file.ta_obk02          #客戶規格

   CALL cl_del_data(l_table)                 #No.FUN-7A0036
   CALL cl_del_data(l_table1)                #No.FUN-EA0031	
   #抓取公司名稱
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #No:7A0036
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR


      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
      LET l_sql = "SELECT '1','','',                                ",                                                               
                  "      oea01, oea02, oea03, A.occ02, oea04, oea10, oea044, B.occ02, ",     
                 #"      B.occ21, ",                               #20230321 mark                                                          
                  "      A.occ21, ",                               #20230321 modify                
                  "      oea915,oea916, ",                                                                                             
                  "      '', '', ",                                                               
                  "      oea42, oeahold,oeaconf,oea14,oea15,",     #20190828                                                     
                  "      oeb03, oeb04, oeb06,",                                                                          
                  "      oeb05, oeb11, oeb12, oeb24, oeb15, ",               
                  "      oeb16, ged02, oeb27, oao06, sfb13, '', ", #20190806  #20230331 add oao06                                                                                            
                  "      oeb910,oeb912,oeb913,oeb915,oeb916,oeb917,sfb01,ima021 ",  #20210906 add sfb01  #20220318                                                
                  " FROM oeb_file ",
                  "      LEFT JOIN ged_file ON oeb20 = ged01 ",  #20190806
                  "      LEFT JOIN oao_file ON oao01 = oeb01 AND (oao03=oeb03 OR oao03=0) AND oao05='2' ",  #20230331 訂單單身備註
                  "      LEFT JOIN sfb_file ON sfb22=oeb01 AND sfb221=oeb03 AND sfb87='Y' ",
                  "      LEFT JOIN ima_file ON oeb_file.oeb04 = ima_file.ima01 ,oea_file ",
                  "      LEFT JOIN occ_file A ON oea_file.oea03=A.occ01 ",
                  "      LEFT JOIN occ_file B ON oea_file.oea04=B.occ01 ",
                  " WHERE oea01 = oeb01 AND oeaconf !='X' ", 
                  "   AND oea00 NOT IN('8','9') ",    
                  "   AND ima08 != 'Z' ",     
                  "   AND ", tm.wc CLIPPED                                                                                          
                                                                                                                            

 
 #No.FUN-960004 --add--
   IF tm.oea00 MATCHES '[1234]' THEN
      LET l_sql=l_sql CLIPPED,"   AND oea00= '",tm.oea00,"'"
   END IF
 #No.FUN-960004 --end--

   #只抓未出貨資料
   IF tm.v = 'Y' THEN
      LET l_sql=l_sql CLIPPED,"   AND (oeb12 - oeb24 + oeb25 ) > 0 "
   END IF

   #不列印結案資料
   IF tm.x= 'Y' THEN
      LET l_sql=l_sql CLIPPED,"   AND oeb70='N' "
   END IF

   ##----- 20220318 add by momo (S) 增加雜發
   LET l_sql = l_sql CLIPPED,
       " UNION ",
       " SELECT '2','','',  inb01, ina03, '', gem02, '', '', '', '',      '',       '','',  ",
       "       '', '',       '', '','','','',      inb03, inb04, ima02,      '', '', inb16, 0, inaud14,     ",
       "       inaud13, '', '','', inaud14, '',       '',0,'',0,'',0,'',ima021  ",
       "  FROM ima_file,inb_file,ina_file,gem_file ",
       " WHERE ina01 = inb01 ",
       "   AND inb04 = ima01 ",
       "   AND ina04 = gem01",
       "   AND inaconf = 'Y' AND inapost='N' ",
       "   AND inaud13 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
       " ORDER BY 1,4"
   ##----- 20220318 add by momo (E)

   PREPARE r410_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   DECLARE r410_curs1 CURSOR FOR r410_prepare1
 
  #FUN-EA0031--add str--
   #抓取尺寸總共有幾個
     LET l_sql="SELECT DISTINCT(oebc06)",
               "  FROM oebc_file, oeb_file ",
               " WHERE oebc01=oeb01 AND oebc03=oeb03 AND oebc01=? AND oebc03=? AND oeb04=?",
               " ORDER BY oebc06"
     PREPARE r410_prepare2 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare r410_prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r410_curs2 CURSOR FOR r410_prepare2

     #抓取該尺寸的顏色總共有幾個
     LET l_sql="SELECT oebc05,oebc07",
               "  FROM oebc_file,oeb_file ",
               " WHERE oebc01=oeb01 AND oebc03=oeb03 AND oebc01=? AND oebc03=? AND oeb04=? AND oebc06=?",
               "   AND oebc07 <> '0'",
               " ORDER BY oebc05"
     PREPARE r410_prepare3 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare r410_prepare3:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r410_curs3 CURSOR FOR r410_prepare3
  #FUN-EA0031--add end--

   LET l_name = 'csfr410' 
                                                                      
                                                                                            

   FOREACH r410_curs1 INTO sr.*
 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF tm.a = '1' AND sr.oeaconf = 'N' THEN
         CONTINUE FOREACH
      END IF
 
      IF tm.a = '2' AND sr.oeaconf = 'Y' THEN
         CONTINUE FOREACH
      END IF
 
      IF tm.b = '1' AND cl_null(sr.oeahold) THEN
         CONTINUE FOREACH
      END IF
 
      IF tm.b = '2' AND NOT cl_null(sr.oeahold) THEN
         CONTINUE FOREACH
      END IF

      LET l_ta_ima02 = 0

      #SELECT ima021
      #  INTO l_ima021
      #  FROM ima_file
      # WHERE ima01=sr.oeb04

      SELECT ta_ima02 
        INTO l_ta_ima02 
        FROM ima_file                                                                     
       WHERE ima01=sr.oeb04
         AND ima01 LIKE '0%'
  
      IF cl_null(l_ta_ima02) THEN LET l_ta_ima02= 0 END IF
                                                                                       
      LET l_str2 = ""                                                                                                               
      IF g_sma115 = "Y" THEN                                                                                                        
         CASE l_ima906                                                                                                              
            WHEN "2"                                                                                                                
                CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915                                                                   
                LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED                                                                           
                IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN                                                                         
                    CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912                                                               
                    LET l_str2 = l_oeb912, sr.oeb910 CLIPPED                                                                        
                ELSE                                                                                                                
                   IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN                                                                 
                      CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912                                                             
                      LET l_str2 = l_str2 CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED                                                   
                   END IF                                                                                                           
                END IF     
            WHEN "3"                                                                                                                
                IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN                                                                    
                    CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915                                                               
                    LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED                                                                       
                END IF                                                                                                              
         END CASE                                                                                                                   
      ELSE                                                                                                                          
      END IF 
      
                                                                                                                                         
      IF g_sma.sma116 MATCHES '[23]' THEN                                                                       
                                              
            IF sr.oeb05  <> sr.oeb916 THEN                                                            
               CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12                                                                      
               LET l_str2 = l_str2 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"                                                         
            END IF                                                                                                                  
      END IF        
#     OUTPUT TO REPORT r410_rep(sr.*)
      


      #是否提供馬達抓取工單備料單 5開頭料號且不為資訊參考
      LET l_oeocnt = 0
      SELECT count(*) INTO l_oeocnt
        FROM sfa_file,sfb_file
       WHERE sfa01=sfb01 AND sfb87='Y'
         #AND ta_sfb01 = l_oea01_3         #20210906 mark
         AND sfb01 = sr.sfb01              #20210906 mark
         AND sfa11 <> 'X' AND sfa03 LIKE '5%'



      #----- 20180410 add by momo 源頭多角訂單帳款客戶與送貨客戶(S)
      SELECT occ02 INTO sr.oea915 FROM occ_file
       WHERE occ01=sr.oea915
      SELECT occ02 INTO sr.oea916 
        FROM occ_file
       WHERE occ01=sr.oea916
      UNION
      SELECT ofd02 INTO sr.oea916
       FROM ks.ofd_file
      WHERE ofd01 = sr.oea916
      IF cl_null(sr.oea915) THEN LET sr.oea915 = sr.oea032 END IF
      IF cl_null(sr.oea916) THEN LET sr.oea916 = sr.occ02 END IF
      #----- 20180410 add by momo 源頭多角訂單帳款客戶與送貨客戶(E)

      #有送貨地址依送貨地址帶出
      SELECT ocd03 INTO sr.oea916 FROM ocd_file,oea_file
       WHERE ocd02=oea044 AND ocd01=oea04
         AND oea01 = sr.oea01

      ##---20220324 add by momo 抓潛在客戶 (S)
      IF cl_null(sr.oea916) THEN
         SELECT ofd02 INTO sr.oea916 FROM ofd_file
          WHERE ofd01 = sr.oea04
      END IF 
      ##---20220324 add by momo 抓潛在客戶 (E)

      ##---- 20220324 add by momo 客戶規格串料件規格 
      LET l_ta_obk02 = ''
      SELECT ta_obk02 INTO l_ta_obk02 FROM obk_file
       WHERE (sr.oeb04 = obk03 OR sr.oeb04=obk01)
         AND obk02 = sr.oea03
      IF NOT cl_null(l_ta_obk02) THEN
         LET sr.ima021 = sr.ima021 ,"(", l_ta_obk02,")"
      END IF


      #---- 顯示最小工作站名稱、國別
      LET l_eca02 = ''
      IF sr.oeb04[1,1] = '0' THEN                                        #只抓成品
         SELECT eca02 INTO l_eca02 
           FROM eca_file,ecb_file,ima_file                               #20180906 add ima_file                     
          WHERE ecb08=eca01 AND ecb01 = sr.oeb04
            AND ima01=ecb01 AND ima94=ecb02                              #20180906 add
            AND ecbacti='Y'
            AND ecb03 = (SELECT MIN(ecb03) FROM ecb_file,ima_file        #20180906 add ima_file
                       WHERE ima01=ecb01 AND ima94=ecb02                 #20180906 add
                         AND ecb01 = sr.oeb04 
                         AND ecb08 NOT IN ('BA001')) #剔除 BA001
      END IF

      ##---- 20210906 add by momo 顯示發料站別
      LET l_eca02_2 = ''
      SELECT eca02 INTO l_eca02_2
        FROM eca_file,ecm_file
       WHERE eca01 = ecm06
         AND ecm01 = sr.sfb01
         AND ecm03 = (SELECT MIN(ecm03) FROM ecm_file 
                       WHERE ecm01=sr.sfb01
                         AND ecm04 NOT IN ('BA01'))

      ##---- 顯示工單備註 
      LET l_sfw03=''
      SELECT sfw03 INTO l_sfw03 FROM sfw_file
       WHERE sfw01=sr.sfb01 AND sfw02=1
        

      ##---- 顯示排交變更原因類別
      LET l_azf03 = ''
      LET l_tc_oeq07 = ''   #20210517
      SELECT '('||tc_oeq02||')' || azf03,tc_oeq07                #20210517
        INTO l_azf03 ,l_tc_oeq07                                 #20210517
        FROM azf_file,      
             (SELECT tc_oeq02,tc_oeq05,tc_oeq07 FROM tc_oeq_file #20210517
               WHERE tc_oeq01 = sr.oea01 AND tc_oeq03 = sr.oeb03
              ORDER BY tc_oeq02 desc)
       WHERE rownum=1 AND azf01=tc_oeq05

      ##---帶出最後出貨日
      SELECT MAX(oga02) INTO sr.oga02 FROM oga_file,ogb_file 
       WHERE oga01=ogb01 AND oga09 IN ('2','4','6') AND ogapost='Y'
         AND ogb31=sr.oea01 AND ogb32=sr.oeb03


      SELECT geb02 INTO sr.occ21 FROM geb_file WHERE geb01=sr.occ21
      
      EXECUTE insert_prep USING  sr.oea01,sr.oea02,sr.oea03,sr.oea032,sr.oea04,
                                 sr.oea10,sr.oea044,l_oea01_3,   #add by ruby 2017/12/28 #add by ruby l_oea01_3 2018/03/05
                                 sr.oea14,sr.oea15,
                                 sr.oea42,                                        #20190828
                                 sr.oeaconf,sr.oeahold,sr.occ02,
                                 sr.occ21,                                        #20180723 add
                                 sr.oea915,sr.oea916,                             #20180410 add
                                 sr.gen02,sr.gem02,sr.oeb03,sr.oeb04,sr.oeb05,
                                 sr.oeb06,sr.oeb11,sr.oeb12,sr.oeb24,sr.oeb15,         #180815 modify by ruby  #190418 add oeb11 by ruby 
                                 sr.oeb16,
                                 sr.oeb20, sr.oeb27,                              #20190806
                                 sr.oao06,                                        #20230331 
                                 sr.sfb13,l_sfw03,l_azf03,
                                 l_tc_oeq07,                                      #20210517
                                 sr.oga02,                  
                                 l_str2,sr.oeb916,
                                 sr.oeb917,l_oeocnt,sr.ima021,l_ta_ima02,l_ima906,         ##180524 add l_oeocnt by ruby
                                 l_eca02,                                                 #20180723 add eca02
                                 l_eca02_2,                                               #20210906 add eca02_2
                                 t_azi03,t_azi04,t_azi05    
     #FUN-EA0031--add str-- 
      IF tm.d = 'Y' THEN
         LET l_flag='N'
         LET l_cnt=0
         #判斷是否存在顏色相關資料記錄
         SELECT COUNT(*) INTO l_cnt FROM agd_file
         WHERE agd02 IN (SELECT oebc05 FROM oebc_file
                          WHERE oebc01 = sr.oea01
                            AND oebc03 = sr.oeb03)
           AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr.oeb04)
         IF l_cnt>0 THEN
            LET l_flag='Y'
         ELSE
           #判斷是否存在尺寸相關資料記錄
            SELECT COUNT(*) INTO l_cnt FROM agd_file
            WHERE agd02 IN (SELECT oebc06 FROM oebc_file
                             WHERE oebc01 = sr.oea01
                               AND oebc03 = sr.oeb03)
              AND agd01=(SELECT ima941 FROM ima_file WHERE ima01=sr.oeb04)
            IF l_cnt>0 THEN
               LET l_flag='Y'
            END IF
         END IF
      END IF

      #抓取顏色尺寸資料
        IF l_flag='Y' THEN
           LET l_next = 1
           FOREACH r410_curs2 USING sr.oea01,sr.oeb03,sr.oeb04
                              INTO l_oebc06            
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach r410_curs2:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF

             #尺寸的名稱
              LET l_oebc06_name = ''
              LET l_agd04_size = ''
              LET l_oebc07 = ''
              #尺寸說明
              SELECT agd03,agd04 INTO l_oebc06_name,l_agd04_size FROM agd_file 
              WHERE agd02=l_oebc06
                AND agd01=(SELECT ima941 FROM ima_file WHERE ima01=sr.oeb04)
              CASE
                 WHEN (l_next <= 10)  #1-10
                    #跑每一個顏色
                    FOREACH r410_curs3 USING sr.oea01,sr.oeb03,sr.oeb04,l_oebc06
                                       INTO l_oebc05,l_oebc07
                       LET l_oebc07_1=''
                       LET l_oebc07_2=''
                       LET l_oebc07_3=''
                       LET l_oebc07_4=''
                       LET l_oebc07_1= l_oebc07
                       LET l_oebc05_name=''
                       LET l_agd04_color=''
                       SELECT agd03,agd04 INTO l_oebc05_name,l_agd04_color FROM agd_file
                        WHERE agd02=l_oebc05
                          AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr.oeb04)
                       EXECUTE insert_prep1 USING sr.oea01,sr.oeb03,l_oebc05,l_oebc05_name,
                                                  l_oebc06,l_oebc06_name,l_oebc07,l_oebc07_1,l_oebc07_2,
                                                  l_oebc07_3,l_oebc07_4,l_agd04_color,l_agd04_size
                    END FOREACH
                 WHEN (l_next > 10 AND l_next <= 20) #11-20
                    #跑每一個顏色
                    FOREACH r410_curs3 USING sr.oea01,sr.oeb03,sr.oeb04,l_oebc06
                                       INTO l_oebc05,l_oebc07
                       LET l_oebc07_1=''
                       LET l_oebc07_2=l_oebc07
                       LET l_oebc05_name=''
                       LET l_agd04_color=''
                       SELECT agd03,agd04 INTO l_oebc05_name,l_agd04_color FROM agd_file
                        WHERE agd02=l_oebc05
                          AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr.oeb04)
                       EXECUTE insert_prep1 USING sr.oea01,sr.oeb03,l_oebc05,l_oebc05_name,
                                                  l_oebc06,l_oebc06_name,l_oebc07,l_oebc07_1,l_oebc07_2,
                                                  l_oebc07_3,l_oebc07_4,l_agd04_color,l_agd04_size
                    END FOREACH
                 WHEN (l_next > 20 AND l_next <= 30) #21-30
                    #跑每一個顏色
                    FOREACH r410_curs3 USING sr.oea01,sr.oeb03,sr.oeb04 ,l_oebc06
                                       INTO l_oebc05,l_oebc07
                       LET l_oebc07_2=''
                       LET l_oebc07_3=l_oebc07
                       LET l_oebc05_name=''
                       LET l_agd04_color=''
                       SELECT agd03,agd04 INTO l_oebc05_name,l_agd04_color FROM agd_file
                        WHERE agd02=l_oebc05
                          AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr.oeb04)
                       EXECUTE insert_prep1 USING sr.oea01,sr.oeb03,l_oebc05,l_oebc05_name,
                                                  l_oebc06,l_oebc06_name,l_oebc07,l_oebc07_1,l_oebc07_2,
                                                  l_oebc07_3,l_oebc07_4,l_agd04_color,l_agd04_size
                    END FOREACH
                 WHEN (l_next > 30) #30以上
                    #跑每一個顏色
                    FOREACH r410_curs3 USING sr.oea01,sr.oeb03,sr.oeb04 ,l_oebc06
                                     INTO l_oebc05,l_oebc07
                       LET l_oebc07_3=''
                       LET l_oebc07_4=l_oebc07
                       LET l_oebc05_name=''
                       LET l_agd04_color=''
                       SELECT agd03,agd04 INTO l_oebc05_name,l_agd04_color FROM agd_file
                        WHERE agd02=l_oebc05
                          AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr.oeb04)
                       EXECUTE insert_prep1 USING sr.oea01,sr.oeb03,l_oebc05,l_oebc05_name,
                                                  l_oebc06,l_oebc06_name,l_oebc07,l_oebc07_1,l_oebc07_2,
                                                  l_oebc07_3,l_oebc07_4,l_agd04_color,l_agd04_size
                    END FOREACH
                 END CASE
                 IF NOT cl_null(l_oebc07) THEN
                    LET l_next = l_next + 1
                 END IF
              END FOREACH
        END IF
     #FUN-EA0031--add end--
#No.FUN-7A0036---End
   END FOREACH
#No.FUN-7A0036---Begin
#   FINISH REPORT r410_rep
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05,oea14,oea15,oeb04,oeb06,ima021,oeb15,oeb16,sfb13')                                                                    
              RETURNING tm.wc  
      ELSE                                                                       #TQC-C90095 add
         LET tm.wc = null                                                        #TQC-C90095 add
      END IF
      LET g_str=tm.wc ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
                           tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",tm.u[2,2],";",
                           tm.u[3,3],";",g_sma115,";",g_sma.sma116                               
                                 
                                                                  
                                                                                                                                    
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
               ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED        #FUN-EA0031
                                                      
   CALL cl_prt_cs3('csfr410',l_name,l_sql,g_str)    
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7A0036---End
END FUNCTION
 
