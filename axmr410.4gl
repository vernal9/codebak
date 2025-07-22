# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: axmr410.4gl
# Descriptions...: 客戶訂單明細表
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
# Modify.........: No.MOD-BC0161 11/12/23 By Vampire 單價oeb13、金額oeb14,程式中先作取位的動作
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
# Modify.........: No:           21/03/19 By Ruby 增加折數  
# Modify.........: No:2105256272 20210527 By momo QBE增加搭配業務
# Modify.........: No:2207188491 20220719 By momo 增加送貨客戶編號之潛在客戶簡稱ofd02
# Modify.........: No:22110021   22/11/11 By Ruby 增加單頭備註oeaud01
# Modify.........: No:24050052   24/06/20 By Ruby 增加選項及欄位[客戶屬性]
# Modify.........: No:24080005   24/08/05 By Ruby 增加欄位「產品分類」及「型號」
# Modify.........: No:25020028   25/03/06 By Ruby 增加欄位「指定供應商代號」及「指定供應商名稱」
# Modify.........: No:25050015   20250515 By momo 增加 潛在客戶「行業別」顯示 ofd03(ofq02)

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
                     v       LIKE type_file.chr1         # No.TQC-940009 VARCHAR(01)
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
DEFINE  m_tc_oci02    LIKE tc_oci_file.tc_oci02    #240620 add by ruby
DEFINE  g_wc          LIKE type_file.chr1000       #240620 add by ruby
 
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
   LET g_wc     = ARG_VAL(17)    #240620 add by ruby
   #MOD-CC0246 -- add end --     #參數順序搬移
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(18)                   #MOD-CC0246 modify ARG_VAL(15) -> ARG_VAL(16)   #FUN-EA0031 modify ARG_VAL(16) -> ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(19)                   #MOD-CC0246 modify ARG_VAL(16) -> ARG_VAL(17)   #FUN-EA0031 modify ARG_VAL(17) -> ARG_VAL(18)
   LET g_template = ARG_VAL(20)                   #MOD-CC0246 modify ARG_VAL(17) -> ARG_VAL(18)   #FUN-EA0031 modify ARG_VAL(18) -> ARG_VAL(19)
   LET g_rpt_name = ARG_VAL(21)  #No.FUN-7C0078   #MOD-CC0246 modify ARG_VAL(18) -> ARG_VAL(19)   #FUN-EA0031 modify ARG_VAL(19) -> ARG_VAL(20)
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
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
#No.FUN-7A0036---Begin
   LET g_sql = "oea01.oea_file.oea01,",
               "oea02.oea_file.oea02,",
               "oea03.oea_file.oea03,",
               "oea032.oea_file.oea032,",
               "oea04.oea_file.oea04,",
               "occ02.occ_file.occ02,",      #20220719 move
               "ofq02.ofq_file.ofq02,",      #20250515 行業別說明
               "oea10.oea_file.oea10,",      #add by ruby 2017/12/28
               "oea044.oea_file.oea044,",    #add by ruby 2017/12/28
               "ocd03.ocd_file.ocd03,",      #add by ruby 2017/12/28
               "oea24.oea_file.oea24,",      #add by ruby 2017/12/28
               "oea01_3.oea_file.oea01,",    #add by ruby 2018/03/05
               "oea12.oea_file.oea12,",
               "oea14.oea_file.oea14,",
               "oea15.oea_file.oea15,",
               "oea21.oea_file.oea21,",
               "oea23.oea_file.oea23,",
               "oea31.oea_file.oea31,",
               "oea32.oea_file.oea32,",
               "oeaconf.oea_file.oeaconf,",
               "oeahold.oea_file.oeahold,",
             # "occ02.occ_file.occ02,",     #20220719 move
               "occ21.geb_file.geb02,",     #國別 20180723 add 
               "oea915.occ_file.occ02,",    #20180410 add
               "oea916.occ_file.occ02,",    #20180410 add
               "oeaud01.oea_file.oeaud01,", #221111 add by ruby
               "gen02.gen_file.gen02,",
               "gem02.gem_file.gem02,",
               "oeb03.oeb_file.oeb03,",
               "oeb04.oeb_file.oeb04,",
               "oeb05.oeb_file.oeb05,",
               "oeb06.oeb_file.oeb06,",
               "oeb11.oeb_file.oeb11,",     #190418 add by ruby
               "ta_obk01.obk_file.ta_obk01,", #190422 add by ruby 
               "ta_obk02.obk_file.ta_obk02,", #190422 add by ruby
               "tc_ocj02.type_file.chr1000,", #240620 add by ruby
               "oeb12.oeb_file.oeb12,",
               "oeb24.oeb_file.oeb24,",     #180815 add by ruby
               "oeb13.oeb_file.oeb13,",
               "oeb14.oeb_file.oeb14,",
               "oeb14t.oeb_file.oeb14t,",   #181012 add by ruby
               "oeb15.oeb_file.oeb15,",
               "oeb16.oeb_file.oeb16,",        #20180409 add
               "l_str2.type_file.chr1000,",
               "oeb909.oeb_file.oeb909,",      #250306 add by ruby
               "pmc03.pmc_file.pmc03,",        #250306 add by ruby
               "oeb916.oeb_file.oeb916,",
               "oeb917.oeb_file.oeb917,",
               "oebud06.oeb_file.oebud06,",    #210319 add by ruby
               "oeb70.oeb_file.oeb70,",        #220110 add by ruby
               "l_oeocnt.type_file.num5,",     #180524 add by ruby
               "ima021.ima_file.ima021,",
               "ima906.ima_file.ima906,",
               "oba02.oba_file.oba02,",        #240805 add by ruby
               "ima1007.ima_file.ima1007,",    #240805 add by ruby
               "eca02.eca_file.eca02,",        #工作站名稱 20180723 add
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('axmr410',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
  #FUN-EA0031--add str--
   LET g_sql="oebc01.oebc_file.oebc01, oebc03.oebc_file.oebc03,",
             "oebc05.oebc_file.oebc05, oebc05_name.agd_file.agd03,",
             "oebc06.oebc_file.oebc06, oebc06_name.agd_file.agd03,",
             "oebc07.oebc_file.oebc07, oebc07_1.oebc_file.oebc07,",
             "oebc07_2.oebc_file.oebc07, oebc07_3.oebc_file.oebc07,",
             "oebc07_4.oebc_file.oebc07,",
             "agd04_color.agd_file.agd04, agd04_size.agd_file.agd04 "
   LET l_table1 = cl_prt_temptable('axmr4101',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
  #FUN-EA0031--add end--
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?,?,? ",
               "       ,?,?,?,?,? ,?,?,?,?,? ,?,?,?,?,? ,?,?,?,?,? ",   #add by ruby 4? 2017/12/28 #add by ruby 1? 2018/03/05  #20180409 add 1?  #20180410 add 2? #180524 add 1? by ruby #20180723 add 2?
               "       ,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "       #180815 add 1? by ruby #181012 add 1? by ruby #190418 add 1? by ruby #190422 add 2? by ruby #210319 add 1? by ruby #220110 add 1? by ruby #221111 add 1? by ruby #240620 add 1? by ruby #240805 add 2? by ruby #250306 add by ruby  #20250515 add 1?                                        
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
{
   #No.8991
   #DROP TABLE curr_tmp
# No.FUN-680137 --start--
   CREATE TEMP TABLE curr_tmp(
     curr    LIKE adu_file.adu10,
     amt     LIKE type_file.num20_6,
     order1  LIKE aaf_file.aaf03,
     order2  LIKE aaf_file.aaf03,
     order3  LIKE aaf_file.aaf03)
# No.FUN-680137 ---end---
   #No.8991(end)
}
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
   OPEN WINDOW r410_w AT p_row,p_col WITH FORM "cxm/42f/axmr410"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   #預設畫面欄位
   INITIALIZE tm.* TO NULL
   LET tm2.s1  = '1'
   LET tm2.u1  = 'Y'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.a    = '3'
   LET tm.b    = '3'
#   LET tm.c    = 'N'       #No.FUN-7B0154
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  #LET tm.x    = 'Y'        #No.FUN-850142 #20210705 mark
   LET tm.x    = 'N'        #No.FUN-850142 #20210705 modify
   LET tm.v    = 'N'        #No.TQC-940009
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

  #240620 add by ruby --s--
   CONSTRUCT BY NAME g_wc ON tc_oci02

      BEFORE CONSTRUCT
          CALL cl_qbe_init()

      ON ACTION controlp
            IF INFIELD(tc_oci02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ocj1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_oci02
               NEXT FIELD tc_oci02
            END IF

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
     #CONTINUE WHILE
  END IF

  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW axmr410_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM
  END IF
  #240620 add by ruby --e--
  
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04,
                                 #oea14,oea15,oea23,oea12,oeahold               #190509 mark by ruby
                                 oea14,oea15,oea23,oea12,oeb04,
                                 oeb49,                                         #20210527 add
                                 oeb06,ima021,oeahold                           #190509 add by ruby
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
              #TQC-C90095 add str---
               WHEN INFIELD(oea12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oea12_1"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea12
                 NEXT FIELD oea12
               #190509 add by ruby --s--  
               WHEN INFIELD(oeb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb04
                 NEXT FIELD oeb04
               #190509 add by ruby --e--                   
               WHEN INFIELD(oeahold)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oea12_2"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeahold
                 NEXT FIELD oeahold
              #TQC-C90095 add end---

              ##---- 20210527 add by momo (S)
               WHEN INFIELD(oeb49)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb49
                  NEXT FIELD oeb49
              ##---- 20210527 add by momo (E)
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
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.a,tm.b,tm.more,tm.oea00,tm.x,tm.v,tm.d  #No.MOD-7B0154  #FUN-850142 Add tm.x  #TQC-940009 add tm.v   #No.FUN-960004 add tm.oea00  #FUN-EA0031 add tm.d 
#                    tm2.u1,tm2.u2,tm2.u3,tm.a,tm.b,tm.c,tm.more #No.MOD-7B0154
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
 
         #No.MOD-7B0154 --mark--
#         AFTER FIELD c
#            IF tm.c NOT MATCHES '[YN]' THEN
#               NEXT FIELD c
#            END IF
         #No.MOD-7B0154 --end--
  
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
               IF tm.x = 'Y' THEN
                  IF tm.v = 'Y' THEN
                     CALL cl_err('','axm-427',0)
                     LET tm.x = 'N'
                     NEXT FIELD x
                  END IF
               END IF
            END IF
            #TQC-940009
         #No.FUN-850142 --end--
 
        #No.TQC-940009--Add--start--
         AFTER FIELD v
            IF NOT cl_null(tm.v) THEN
               IF tm.v NOT MATCHES '[YN]' THEN
                  NEXT FIELD v
               END IF
               IF tm.v = 'Y'  THEN
                  IF tm.x = 'Y' THEN
                     CALL cl_err('','axm-427',0)
                     LET tm.v = 'N'
                     NEXT FIELD v
                  END IF
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
          WHERE zz01='axmr410'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmr410','9031',1)
         ELSE  
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET g_wc = cl_replace_str(g_wc, "'", "\"")   #240620 add by ruby
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
                        " '",g_wc CLIPPED,"'",                 #240620 add by ruby
                       #MOD-CC0246 -- add end --    #參數搬移
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078      #MOD-CC0246 remove ,
                       #MOD-CC0246 -- mark start -- #參數搬移
                       #" '",tm.x CLIPPED,"'",                 #No.FUN-850142
                       #" '",tm.v CLIPPED,"'"                  #No.TQC-940009 add
                       #MOD-CC0246 -- mark end --   #參數搬移
            CALL cl_cmdat('axmr410',g_time,l_cmd)
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
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0094
#DEFINE l_sql     LIKE type_file.chr1000         # SQL STATEMENT                   #No.FUN-680137 VARCHAR(1000)
DEFINE l_sql     STRING  #Mod No.TQC-B30058
DEFINE l_za05    LIKE type_file.chr1000         #No.FUN-680137 VARCHAR(40)
DEFINE l_str2    LIKE type_file.chr1000         #No.FUN-7A0036                  
DEFINE l_ima021  LIKE ima_file.ima021           #No.FUN_7A0036
DEFINE l_order   ARRAY[5] OF LIKE aaf_file.aaf03          # No.FUN-680137 VARCHAR(40)               #FUN-560074
#No.FUN-7A0036---Begin
   DEFINE  l_oeb915    LIKE type_file.chr1000                                                                                                       
   DEFINE  l_oeb912    LIKE type_file.chr1000                                                                                                       
   DEFINE  l_oeb12     LIKE type_file.chr1000                                                                                                      
   DEFINE  l_ima906    LIKE ima_file.ima906 
   DEFINE  l_ocd03     LIKE ocd_file.ocd03           #add by ruby 2017/12/28
   DEFINE  l_oea01_3   LIKE oea_file.oea01           #add by ruby 2018/03/05
   DEFINE  l_eca02     LIKE eca_file.eca02           #最小工作站名稱 20180723 add
#No.FUN-7A0036---End
DEFINE sr        RECORD order1  LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)              #FUN-560074
                        order2  LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)              #FUN-560074
                        order3  LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)              #FUN-560074
                        oea01   LIKE oea_file.oea01,
                        oea02   LIKE oea_file.oea02,
                        oea03   LIKE oea_file.oea03,
                        oea032  LIKE oea_file.oea032,	#客戶簡稱
                        oea04   LIKE oea_file.oea04,	#客戶編號
                        occ02   LIKE occ_file.occ02,	#送貨客戶簡稱 20220719 move
                        oea10   LIKE oea_file.oea10,  #add by ruby 2017/12/28
                        oea044  LIKE oea_file.oea044, #add by ruby 2017/12/28
                        oea24   LIKE oea_file.oea24,  #add by ruby 2017/12/28
                      # occ02   LIKE occ_file.occ02,	#客戶簡稱 20220719 move
                        occ21   LIKE geb_file.geb02,	#國別 20180723 add
                        oea915  LIKE occ_file.occ02,	#多角帳款客戶簡稱 #20180410
                        oea916  LIKE occ_file.occ02,	#多角送貨客戶簡稱 #20180410
                        oeaud01 LIKE oea_file.oeaud01,  #221111 add by ruby
                        gen02   LIKE gen_file.gen02,
                        gem02   LIKE gem_file.gem02,
                        oea23   LIKE oea_file.oea23,
                        oea21   LIKE oea_file.oea21,
                        oea12   LIKE oea_file.oea12,
                        oea31   LIKE oea_file.oea31,
                        oea32   LIKE oea_file.oea32,
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
                        oeb13   LIKE oeb_file.oeb13,
                        oeb14   LIKE oeb_file.oeb14,
                        oeb14t  LIKE oeb_file.oeb14t,   #181012 add by ruby
                        oeb15   LIKE oeb_file.oeb15,
                        oeb16   LIKE oeb_file.oeb16,    #20180409 add
                        oeb909  LIKE oeb_file.oeb909,   #250306 add by ruby
                        oeb910  LIKE oeb_file.oeb910,   #FUN-580004
                        oeb912  LIKE oeb_file.oeb912,   #FUN-580004
                        oeb913  LIKE oeb_file.oeb913,   #FUN-580004
                        oeb915  LIKE oeb_file.oeb915,   #FUN-580004
                        oeb916  LIKE oeb_file.oeb916,   #FUN-580004
                        oeb917  LIKE oeb_file.oeb917,   #FUN-580004         
                        oebud06 LIKE oeb_file.oebud06,  #210319 add by ruby
                        oeb70   LIKE oeb_file.oeb70     #220110 add by ruby
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
         l_oeocnt       LIKE type_file.num5,            #180524 add by ruby
         l_ta_obk01     LIKE obk_file.ta_obk01,         #190422 add by ruby
         l_ta_obk02     LIKE obk_file.ta_obk02,         #190422 add by ruby
         l_tc_ocj01     LIKE tc_ocj_file.tc_ocj01,      #240620 add by ruby
         l_tc_ocj02     LIKE tc_ocj_file.tc_ocj02,      #240620 add by ruby
         l_tc_ocj02_t   LIKE type_file.chr1000          #240620 add by ruby
  DEFINE i              LIKE type_file.num5             #240620 add by ruby
  DEFINE l_oba02        LIKE oba_file.oba02             #240805 add by ruby
  DEFINE l_ima1007      LIKE ima_file.ima1007           #240805 add by ruby
  DEFINE l_pmc03        LIKE pmc_file.pmc03             #250306 add by ruby
  DEFINE l_ofq02        LIKE ofq_file.ofq02             #20250515 潛在客戶行業別 
#FUN-EA0031--add end--

   CALL cl_del_data(l_table)                 #No.FUN-7A0036
   CALL cl_del_data(l_table1)                #No.FUN-EA0031	
   #抓取公司名稱
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #No:7A0036
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR

   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
#      LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
#   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
#      LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
#   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
#      LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
#   END IF
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
#End:FUN-980030
 
#No.FUN-7A0036---Begin
{
   #No.8991   (針對幣別加總)
   DELETE FROM curr_tmp;
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
             "  WHERE order1=? ",
             "  GROUP BY curr"
   PREPARE tmp1_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_1:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
             "  WHERE order1=? ",
             "    AND order2=? ",
             "  GROUP BY curr  "
   PREPARE tmp2_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_2:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 3 小計
             "  WHERE order1=? ",
             "    AND order2=? ",
             "    AND order3=? ",
             "  GROUP BY curr  "
   PREPARE tmp3_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_3:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp3_cs CURSOR FOR tmp3_pre
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計
             "  GROUP BY curr  "
   PREPARE tmp4_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_4:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp4_cs CURSOR FOR tmp4_pre
   #No.8991(end)
}
#No.FUN-7A0036---End
 {  SELECT azi03,azi04,azi05
     INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
     FROM azi_file
    WHERE azi01=g_aza.aza17
 }      #No.CHI-6A0004
 
#No.FUN-850142 --Mark--Begin--#
#  LET l_sql = "SELECT '','','',                                ",
#              "      oea01, oea02, oea03, A.occ02, oea04, B.occ02, ",
#              "      gen02, gem02, oea23, oea21, oea12, oea31, ",
#              "      oea32, oeahold,oeaconf,oea14,oea15,", #FUN-4C0096
#              "      oeb03, oeb04, oeb06,",                #FUN-4C0096
#              "      oeb05, oeb12, oeb13,oeb14, oeb15 ",
#              "      ,oeb910,oeb912,oeb913,oeb915,oeb916,oeb917 ",   #FUN-580004
#              " FROM oea_file, OUTER occ_file A,OUTER occ_file B,",
#              "      OUTER gen_file, OUTER gem_file, oeb_file ",
#              " WHERE oea03 = A.occ01 AND B.occ01 = oea04  ",
#              "   AND gen_file.gen01 = oea14 ",
#              "   AND gem_file.gem01 = oea15 AND oea01=oeb_file.oeb01 AND oeaconf!='X' ",
#              "   AND ", tm.wc CLIPPED
#No.FUN-850142 --Mark--End--#
 
#No.FUN-850142 --Add--Begin--#                                                                                                      
   IF tm.x = 'Y' THEN                                                                                                               
      LET l_sql = "SELECT '','','',                                ",                                                               
                 #"      oea01, oea02, oea03, A.occ02, oea04, oea10, oea044, oea24, B.occ02, ",  #add by ruby oea10,oea044,oea24 2017/12/28  #20220719 modify
                  "      oea01, oea02, oea03, A.occ02, oea04, B.occ02,oea10, oea044, oea24,  ",  #20220719 move
                  "      B.occ21, ",                                                             #20180723 add by momo   
                  "      oea915,oea916, ",                                                       #20180410 add oea915 oea916
                  "      oeaud01, ",                                                             #221111 add by ruby
                  "      gen02, gem02, oea23, oea21, oea12, oea31, ",                                                               
                  "      oea32, oeahold,oeaconf,oea14,oea15,", #FUN-4C0096                                                          
                  "      oeb03, oeb04, oeb06,",                #FUN-4C0096                                                          
                  "      oeb05, oeb11, oeb12, oeb24, oeb13,oeb14,oeb14t, oeb15, ",               #180815 modify by ruby  #181012 add oeb14t by ruby #190418 add oeb11 by ruby
                  "      oeb16 ",                              #20180409 add                                                                       
                  "      ,oeb909,oeb910,oeb912,oeb913,oeb915,oeb916,oeb917,oebud06,oeb70 ",   #FUN-580004     #210319 add oebud06 by ruby #220110 add oeb70 by ruby #250306 add oeb909 by ruby                                         
                  #" FROM oeb_file,oea_file LEFT OUTER JOIN occ_file A ON oea_file.oea03=A.occ01 LEFT OUTER JOIN occ_file B ON oea_file.oea04=B.occ01 LEFT OUTER JOIN gen_file ON oea_file.oea14 = gen_file.gen01 LEFT OUTER JOIN gem_file ON oea_file.oea15 = gem_file.gem01 ",                                                              #190509 mark by ruby
                  " FROM oeb_file LEFT OUTER JOIN ima_file ON oeb_file.oeb04 = ima_file.ima01 ,oea_file LEFT OUTER JOIN occ_file A ON oea_file.oea03=A.occ01 LEFT OUTER JOIN occ_file B ON oea_file.oea04=B.occ01 LEFT OUTER JOIN gen_file ON oea_file.oea14 = gen_file.gen01 LEFT OUTER JOIN gem_file ON oea_file.oea15 = gem_file.gem01 ",  #190509 add by ruby
                  " WHERE oea01 = oeb01 AND oeaconf !='X' ", 
                  "   AND oea00 NOT IN('8','9') ",          #CHI-970045 add
                  "   AND ", tm.wc CLIPPED                                                                                          
   ELSE            
   #TQC-940009---add---start---
     IF tm.v = 'Y' THEN
        LET l_sql = "SELECT '','','',                                ",
                   #"      oea01, oea02, oea03, A.occ02, oea04, oea10, oea044, oea24, B.occ02, ",  #add by ruby oea10,oea044,oea24 2017/12/28 #20220719 modify
                    "      oea01, oea02, oea03, A.occ02, oea04, B.occ02,oea10, oea044, oea24,  ",  #20220719 move
                    "      B.occ21, ",                                                             #20180723 add by momo   
                    "      oea915,oea916, ",                                                       #20180410 add oea915 oea916  
                    "      oeaud01, ",                                                             #221111 add by ruby
                    "      gen02, gem02, oea23, oea21, oea12, oea31, ",
                    "      oea32, oeahold,oeaconf,oea14,oea15,",
                    "      oeb03, oeb04, oeb06,",
                    "      oeb05, oeb11, oeb12, oeb24, oeb13,oeb14,oeb14t, oeb15, ",               #180815 modify by ruby  #181012 add oeb14t by ruby #190418 add oeb11 by ruby 
                    "      oeb16 ",                                #20180409 add
                    "      ,oeb909,oeb910,oeb912,oeb913,oeb915,oeb916,oeb917,oebud06,oeb70 ",                   #210319 add oebud06 by ruby #220110 add oeb70 by ruby #250306 add oeb909 by ruby                                                                                                                                                                                                                                                 
#" FROM oeb_file,oea_file LEFT OUTER JOIN occ_file A ON oea_file.oea03=A.occ01 LEFT OUTER JOIN occ_file B ON oea_file.oea04=B.occ01 LEFT OUTER JOIN gen_file ON oea_file.oea14 = gen_file.gen01 LEFT OUTER JOIN gem_file ON oea_file.oea15 = gem_file.gem01 ",                                                                                #190509 mark by ruby
" FROM oeb_file LEFT OUTER JOIN ima_file ON oeb_file.oeb04 = ima_file.ima01 ,oea_file LEFT OUTER JOIN occ_file A ON oea_file.oea03=A.occ01 LEFT OUTER JOIN occ_file B ON oea_file.oea04=B.occ01 LEFT OUTER JOIN gen_file ON oea_file.oea14 = gen_file.gen01 LEFT OUTER JOIN gem_file ON oea_file.oea15 = gem_file.gem01 ",                    #190509 add by ruby
" WHERE oea01 = oeb01 AND oeaconf !='X' ", 
                    "   AND (oeb12 - oeb24 + oeb25 - oeb26) > 0 ",
                    "   AND oea00 NOT IN('8','9') ",          #CHI-970045 add
                    "   AND ", tm.wc CLIPPED
     ELSE
   #TQC-940009---add---end---
      LET l_sql = "SELECT '','','',                                ",                                                               
                 #"      oea01, oea02, oea03, A.occ02, oea04, oea10, oea044, oea24, B.occ02, ",   #add by ruby oea10,oea044,oea24 2017/12/28  #20220719 mark
                  "      oea01, oea02, oea03, A.occ02, oea04, B.occ02, oea10, oea044, oea24,  ",   #20220719 move  
                  "      B.occ21, ",                                                              #20180723 add by momo                     
                  "      oea915,oea916, ",                                                        #20180410 add oea915 oea916
                  "      oeaud01, ",                                                              #221111 add by ruby                                              
                  "      gen02, gem02, oea23, oea21, oea12, oea31, ",                                                               
                  "      oea32, oeahold,oeaconf,oea14,oea15,", #FUN-4C0096                                                          
                  "      oeb03, oeb04, oeb06,",                #FUN-4C0096                                                          
                  "      oeb05, oeb11, oeb12, oeb24, oeb13,oeb14,oeb14t, oeb15, ",                #180815 modify by ruby #181012 add oeb14t by ruby #190418 add oeb11 by ruby                                        
                  "      oeb16 ",                              #20180409 add
                  "      ,oeb909,oeb910,oeb912,oeb913,oeb915,oeb916,oeb917,oebud06,oeb70 ",   #FUN-580004      #210319 add oebud06 by ruby #220110 add oeb70 by ruby #250306 add oeb909 by ruby        
#" FROM oeb_file,oea_file LEFT OUTER JOIN occ_file A ON oea_file.oea03=A.occ01 LEFT OUTER JOIN occ_file B ON oea_file.oea04=B.occ01 LEFT OUTER JOIN gen_file ON oea_file.oea14 = gen_file.gen01 LEFT OUTER JOIN gem_file ON oea_file.oea15 = gem_file.gem01 ",                                                                                  #190509 mark by ruby
" FROM oeb_file LEFT OUTER JOIN ima_file ON oeb_file.oeb04 = ima_file.ima01 ,oea_file LEFT OUTER JOIN occ_file A ON oea_file.oea03=A.occ01 LEFT OUTER JOIN occ_file B ON oea_file.oea04=B.occ01 LEFT OUTER JOIN gen_file ON oea_file.oea14 = gen_file.gen01 LEFT OUTER JOIN gem_file ON oea_file.oea15 = gem_file.gem01 ",                      #190509 add by ruby
" WHERE oea01 = oeb01 AND oeaconf !='X' ", 
                  "   AND oeb_file.oeb70 = 'N' ",                                                                                            
                  "   AND oea00 NOT IN('8','9') ",          #CHI-970045 add
                  "   AND ", tm.wc CLIPPED                                                                                          
     END IF          #TQC-940009
   END IF                                                                                                                           
#No.FUN-850142 --Add--End--#
 
 #240620 add by ruby --s--
 IF g_wc <> ' 1=1' THEN
   LET l_sql=l_sql CLIPPED," AND oea03 IN (SELECT tc_oci01 FROM tc_oci_file WHERE ", g_wc CLIPPED,")" 
 END IF
 #240620 add by ruby --e--
 
 #No.FUN-960004 --add--
   IF tm.oea00 MATCHES '[1234]' THEN
      LET l_sql=l_sql CLIPPED,"   AND oea00= '",tm.oea00,"'"
   END IF
 #No.FUN-960004 --end--

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

#   CALL cl_outnam('axmr410') RETURNING l_name       #No.FUN-7A0036
 
#FUN-580004--begin
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
#No.FUN-7A0036---Begin                                                                                                              
{ 
   IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
      LET g_zaa[52].zaa06 = "Y"
      LET g_zaa[53].zaa06 = "Y"
      LET g_zaa[58].zaa06 = "N"
      LET g_zaa[59].zaa06 = "N"
   ELSE
      LET g_zaa[52].zaa06 = "N"
      LET g_zaa[53].zaa06 = "N"
      LET g_zaa[58].zaa06 = "Y"
      LET g_zaa[59].zaa06 = "Y"
   END IF
 
   IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
      LET g_zaa[57].zaa06 = "N"
   ELSE
      LET g_zaa[57].zaa06 = "Y"
   END IF
   CALL cl_prt_pos_len()
#No.FUN-580004--end
}
   IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076                                                                            
       LET l_name='axmr410'                                                                                                         
   ELSE                                                                                                                             
       IF g_sma115 = "Y" THEN
          LET l_name='axmr410_1'
       ELSE
          LET l_name='axmr410_2'   
       END IF                                                                                                    
   END IF                                                                                                                           
 
#   START REPORT r410_rep TO l_name            
#   LET g_pageno = 0                           
#No.FUN-7A0036---End


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
 
#No.FUN-7A0036---Begin 
{
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oea01
                                       LET g_orderA[g_i]= g_x[20]
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oea02
                                           USING 'yyyymmdd'
                                       LET g_orderA[g_i]= g_x[21]
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oea03
                                       LET g_orderA[g_i]= g_x[22]
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oea04
                                       LET g_orderA[g_i]= g_x[23]
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.gen02
                                       LET g_orderA[g_i]= g_x[24]
              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.gem02
                                       LET g_orderA[g_i]= g_x[25]
              WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oea23
                                       LET g_orderA[g_i]= g_x[26]
              WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.oea12
                                       LET g_orderA[g_i]= g_x[27]
              WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i]=sr.oeahold
                                       LET g_orderA[g_i]= g_x[28]
              OTHERWISE LET l_order[g_i]  = '-'
                        LET g_orderA[g_i] = ' '          #清為空白
         END CASE
      END FOR
 
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
}
      SELECT azi03,azi04,azi05                                                                                                      
        INTO t_azi03,t_azi04,t_azi05                                                                   
        FROM azi_file                                                                                                               
       WHERE azi01=sr.oea23    
      IF sr.oeb04[1,4] !='MISC' THEN                                                                                                
         SELECT ima021 INTO l_ima021 FROM ima_file                                                                                  
          WHERE ima01 = sr.oeb04                                                                                                    
      ELSE                                                                                                                          
         LET l_ima021 = ''                                                                                                          
      END IF    
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file                                                                     
                         WHERE ima01=sr.oeb04                                                                                       
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
      
      #add by ruby 2017/12/28
      SELECT ocd03 INTO l_ocd03 FROM ocd_file WHERE ocd01=sr.oea03 and ocd02=sr.oea044
          IF STATUS THEN
         LET l_ocd03 = '' 
      END IF 

      #180524 add by ruby --s--
      SELECT count(*) INTO l_oeocnt FROM oeo_file WHERE oeo01=sr.oea01 and oeo03=sr.oeb03
          IF STATUS THEN
         LET l_oeocnt = '' 
      END IF 
      #180524 add by ruby --e--
                                                                                                                                         
      IF g_sma.sma116 MATCHES '[23]' THEN                                                                       
                                              
            IF sr.oeb05  <> sr.oeb916 THEN                                                            
               CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12                                                                      
               LET l_str2 = l_str2 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"                                                         
            END IF                                                                                                                  
      END IF        
#     OUTPUT TO REPORT r410_rep(sr.*)
      
      CALL cl_digcut(sr.oeb13,t_azi03)  RETURNING sr.oeb13   #MOD-BC0161 add
      CALL cl_digcut(sr.oeb14,t_azi04)  RETURNING sr.oeb14   #MOD-BC0161 add
      CALL cl_digcut(sr.oeb14t,t_azi04)  RETURNING sr.oeb14t  #181012 add by ruby

      #add by ruby 2018/03/05
      select oeb01||substr('00'||oeb03,length(oeb03),3) INTO l_oea01_3 from oeb_file where oeb01=sr.oea01 and oeb03=sr.oeb03
          IF STATUS THEN
         LET l_oea01_3 = '' 
      END IF

     #190422 add by ruby --s--
     SELECT ta_obk01,ta_obk02 INTO l_ta_obk01,l_ta_obk02 FROM obk_file where obk01=sr.oeb04 and obk02=sr.oea03  
     #190422dd by ruby --e--

     #240620 add by ruby --s--
     LET l_tc_ocj02=''
     LET l_tc_ocj02_t=''
     LET i = 0
     LET l_sql="SELECT tc_ocj01,tc_ocj02",
               "  FROM tc_oci_file LEFT JOIN tc_ocj_file ON tc_oci02=tc_ocj01",
               " WHERE tc_oci01=? ",
               " ORDER BY tc_ocj01"
     PREPARE r410_ocj1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare r410_ocj1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r410_curs4 CURSOR FOR r410_ocj1
     FOREACH r410_curs4 USING sr.oea03 INTO l_tc_ocj01,l_tc_ocj02
       LET i = i + 1
       IF i = 1 THEN
         LET l_tc_ocj02_t=l_tc_ocj02
       ELSE   
         LET l_tc_ocj02_t=l_tc_ocj02_t,"/",l_tc_ocj02
       END IF  
     END FOREACH
     #240620 add by ruby --e--
     
      #----- 20180410 add by momo 源頭多角訂單帳款客戶與送貨客戶(S)
      SELECT occ02 INTO sr.oea915 FROM occ_file
       WHERE occ01=sr.oea915
      SELECT occ02 INTO sr.oea916 FROM occ_file
       WHERE occ01=sr.oea916
      #----- 20180410 add by momo 源頭多角訂單帳款客戶與送貨客戶(S)
   
      ##---- 20220719 add by momo (S) 帶出潛在客戶簡稱
      LET l_ofq02=''
      IF cl_null(sr.occ02) THEN 
         SELECT ofd02,ofq02 INTO sr.occ02,l_ofq02
           FROM ofd_file
           LEFT JOIN ofq_file ON ofd03 = ofq01       # 20250515 add by momo 潛在客戶行業別
          WHERE ofd01 = sr.oea04
      END IF
      ##---- 20220719 add by momo (E) 帶出潛在客戶簡稱


      #----- 20180723 add by momo 顯示最小工作站名稱、國別 (S)
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
      SELECT geb02 INTO sr.occ21 FROM geb_file WHERE geb01=sr.occ21
      #----- 20180723 add by momo 顯示最小工作站名稱、國別 (E)

      #240805 add by ruby --s-- 產品分類、型號
      LET l_oba02=''
      LET l_ima1007=''
      SELECT oba02,ima1007 INTO l_oba02,l_ima1007 FROM ima_file left join oba_file on ima131=oba01 WHERE ima01=sr.oeb04    
      #240805 add by ruby --e--

      #250306 add by ruby --s--
      LET l_pmc03=''
      IF NOT cl_null(sr.oeb909) THEN
        SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.oeb909
      END IF  
      #250306 add by ruby --e--
      
      EXECUTE insert_prep USING  sr.oea01,sr.oea02,sr.oea03,sr.oea032,sr.oea04, 
                                 sr.occ02,
                                 l_ofq02,                                         #20250515 潛在客戶行業別
                                 sr.oea10,sr.oea044,l_ocd03,sr.oea24,l_oea01_3,   #add by ruby 2017/12/28 #add by ruby l_oea01_3 2018/03/05
                                 sr.oea12,sr.oea14,sr.oea15,sr.oea21,sr.oea23,
                                 sr.oea31,sr.oea32,sr.oeaconf,sr.oeahold,
                                 sr.occ21,                                        #20180723 add
                                 sr.oea915,sr.oea916,                             #20180410 add
                                 sr.oeaud01,                                      #221111 add by ruby
                                 sr.gen02,sr.gem02,sr.oeb03,sr.oeb04,sr.oeb05,
                                 sr.oeb06,sr.oeb11,l_ta_obk01,l_ta_obk02,l_tc_ocj02_t,sr.oeb12,sr.oeb24,sr.oeb13,sr.oeb14,sr.oeb14t,sr.oeb15,         #180815 modify by ruby  #181012 add oeb14t by ruby #190418 add oeb11 by ruby #190422 add ta_obk01,ta_obk02 by ruby #240620 add tc_ocj02_t by ruby
                                 sr.oeb16,                                        #20180409 add
                                 l_str2,sr.oeb909,l_pmc03,sr.oeb916,              #250306 add oeb909,pmc03 by ruby
                                 sr.oeb917,sr.oebud06,sr.oeb70,l_oeocnt,l_ima021,l_ima906,l_oba02,l_ima1007,l_eca02,t_azi03,t_azi04,t_azi05     #180524 add l_oeocnt by ruby #20180723 add eca02 #210319 add oebud06 by ruby #220110 add oeb70 by ruby #240805 add oba02,ima1007 by ruby
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
         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05,oea12,oea14,oea15,oea23,oeb04,oeb06,ima021,oeahold')    #TQC-C90095 add oea12,oea14,oea15,oea23,oeahold #190509 add by ruby                                                                     
              RETURNING tm.wc  
      ELSE                                                                       #TQC-C90095 add
         LET tm.wc = null                                                        #TQC-C90095 add
      END IF
      LET g_str=tm.wc ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
                           tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",tm.u[2,2],";",
                           tm.u[3,3],";",g_sma115,";",g_sma.sma116                               
                                 
                                                                  
                                                                                                                                    
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
               ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED        #FUN-EA0031
                                                      
   CALL cl_prt_cs3('axmr410',l_name,l_sql,g_str)    
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7A0036---End
END FUNCTION
 
#No.FUN-7A0036---Begin
{REPORT r410_rep(sr)
DEFINE l_last_sw   LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
DEFINE sr           RECORD order1 LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)          #FUN-560074
                           order2 LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)          #FUN-560074
                           order3 LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)          #FUN-560074
                        oea01   LIKE oea_file.oea01,
                        oea02   LIKE oea_file.oea02,
                        oea03   LIKE oea_file.oea03,
                        oea032  LIKE oea_file.oea032,	#客戶簡稱
                        oea04   LIKE oea_file.oea04,	#客戶編號
                        occ02   LIKE occ_file.occ02,	#客戶簡稱
                        gen02   LIKE gen_file.gen02,
                        gem02   LIKE gem_file.gem02,
                        oea23   LIKE oea_file.oea23,
                        oea21   LIKE oea_file.oea21,
                        oea12   LIKE oea_file.oea12,
                        oea31   LIKE oea_file.oea31,
                        oea32   LIKE oea_file.oea32,
                        oeahold LIKE oea_file.oeahold,
                        oeaconf LIKE oea_file.oeaconf,
                        oea14   LIKE oea_file.oea14,    #FUN-4C0096
                        oea15   LIKE oea_file.oea15,    #FUN-4C0096
                        oeb03   LIKE oeb_file.oeb03,
                        oeb04   LIKE oeb_file.oeb04,
                        oeb06   LIKE oeb_file.oeb06,
                        oeb05   LIKE oeb_file.oeb05,
                        oeb12   LIKE oeb_file.oeb12,
                        oeb13   LIKE oeb_file.oeb13,
                        oeb14   LIKE oeb_file.oeb14,
                        oeb15   LIKE oeb_file.oeb15,
                        oeb910  LIKE oeb_file.oeb910,   #FUN-580004
                        oeb912  LIKE oeb_file.oeb912,   #FUN-580004
                        oeb913  LIKE oeb_file.oeb913,   #FUN-580004
                        oeb915  LIKE oeb_file.oeb915,   #FUN-580004
                        oeb916  LIKE oeb_file.oeb916,   #FUN-580004
                        oeb917  LIKE oeb_file.oeb917    #FUN-580004
                    END RECORD,
          sr1           RECORD                 #No.8991
                           curr      LIKE gsb_file.gsb05,      # No.FUN-680137 VARCHAR(04)
                           amt       LIKE oeb_file.oeb14
                    END RECORD,
                l_str   LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)              #FUN-4C0096 add
                l_str1  LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)              #FUN-4C0096 add
                l_str2  LIKE type_file.chr1000,   # No.FUN-680137 VARCHAR(100)             #No.FUN-580004
                l_str3  LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(40)              #FUN-4C0096 add
                l_ima021 LIKE ima_file.ima021, #FUN-4C0096 add
		l_rowno LIKE type_file.num5,      # No.FUN-680137 SMALLINT
		l_amt_1 LIKE oeb_file.oeb14,   #FUN-4C0096 modify
		l_amt_2 LIKE oeb_file.oeb12    #FUN-4C0096 modify
#No.FUN-580004--begin
   DEFINE  l_oeb915    STRING
   DEFINE  l_oeb912    STRING
   DEFINE  l_oeb12     STRING
   DEFINE  l_ima906    LIKE ima_file.ima906
#No.FUN-580004--end
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
#-------------No.MOD-670022 modify
 #ORDER EXTERNAL BY sr.order1,sr.order2,sr.order3     #No:8262
  ORDER BY sr.order1,sr.order2,sr.order3     
#-------------No.MOD-670022 end
 
#FUN-4C0096 modify
  #格式設定
  FORMAT
   #列印表頭
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      LET g_head1 = g_x[13] CLIPPED,
                    g_orderA[1] CLIPPED,'-',
                    g_orderA[2] CLIPPED,'-',
                    g_orderA[3] CLIPPED
      PRINT g_head1
 
 
     #LET l_str1= g_orderA[1],'-'
     #LET l_str2= g_orderA[2],'-'
     #LET l_str3= ''
     #CASE tm.a
     #     WHEN '1' LET l_str3=g_x[14] CLIPPED;
     #     WHEN '2' LET l_str3=g_x[15] CLIPPED;
     #     WHEN '3' LET l_str3=g_x[16] CLIPPED;
     #END CASE
     #CASE tm.b
     #     WHEN '1' LET l_str3=g_x[17] CLIPPED;
     #     WHEN '2' LET l_str3=g_x[18] CLIPPED;
     #     WHEN '3' LET l_str3=g_x[19] CLIPPED;
     #END CASE
 
      PRINT g_dash[1,g_len]
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38],
            g_x[39],
            g_x[40],
            g_x[41],
            g_x[42],
            g_x[43],
            g_x[44],
            g_x[45],
            g_x[46],
            g_x[47],
            g_x[48],
            g_x[49],
            g_x[50],
            g_x[51],
            g_x[57],  #No.FUN-580004
            g_x[58],  #No.FUN-580004
            g_x[59],  #No.FUN-580004
            g_x[52],
            g_x[53],
            g_x[54],
            g_x[55],
            g_x[56]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y'           #跳頁控制
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2       #跳頁控制
      IF tm.t[2,2] = 'Y'
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3       #跳頁控制
      IF tm.t[3,3] = 'Y'
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.oea01
      SELECT azi03,azi04,azi05
        INTO t_azi03,t_azi04,t_azi05         #No.CHI-6A0004
        FROM azi_file
       WHERE azi01=sr.oea23
      PRINT COLUMN g_c[31],sr.oea01 CLIPPED,
            COLUMN g_c[32],sr.oea02 CLIPPED,
            COLUMN g_c[33],sr.oea03 CLIPPED,
            COLUMN g_c[34],sr.oea032 CLIPPED,
            COLUMN g_c[35],sr.oea04 CLIPPED,
            COLUMN g_c[36],sr.occ02 CLIPPED,
            COLUMN g_c[37],sr.oea14 CLIPPED,
            COLUMN g_c[38],sr.gen02 CLIPPED,
            COLUMN g_c[39],sr.oea15 CLIPPED,
            COLUMN g_c[40],sr.gem02 CLIPPED,
            COLUMN g_c[41],sr.oea23 CLIPPED,
            COLUMN g_c[42],sr.oea12 CLIPPED,
            COLUMN g_c[43],sr.oea31 CLIPPED,
            COLUMN g_c[44],sr.oea21 CLIPPED,
            COLUMN g_c[45],sr.oea32 CLIPPED,
            COLUMN g_c[46],sr.oeahold CLIPPED,
            COLUMN g_c[47],sr.oeaconf CLIPPED;
 
   ON EVERY ROW
      IF sr.oeb04[1,4] !='MISC' THEN
         SELECT ima021 INTO l_ima021 FROM ima_file
          WHERE ima01 = sr.oeb04
      ELSE
         LET l_ima021 = ''
      END IF
#FUN-580004--begin
 
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=sr.oeb04
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
      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
           #IF sr.oeb910 <> sr.oeb916 THEN   #NO.TQC-6B0137 mark
            IF sr.oeb05  <> sr.oeb916 THEN   #NO.TQC-6B0137 mod
               CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
               LET l_str2 = l_str2 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
            END IF
      END IF
#FUN-580004--end
      PRINT COLUMN g_c[48],sr.oeb03 USING '####',
            COLUMN g_c[50],sr.oeb06 CLIPPED,
            #COLUMN g_c[49],sr.oeb04[1,20] CLIPPED,   #No.FUN-580004
            COLUMN g_c[49],sr.oeb04 CLIPPED,   #No.FUN-580004 #NO.FUN-5B0015
            COLUMN g_c[51],l_ima021 CLIPPED,
            COLUMN g_c[57],l_str2 CLIPPED,          #No.FUN-580004
            COLUMN g_c[58],sr.oeb916 CLIPPED,       #No.FUN-580004
            COLUMN g_c[59],sr.oeb917 USING '###########&.##' CLIPPED,       #No.FUN-580004
            COLUMN g_c[52],sr.oeb05 CLIPPED,
            COLUMN g_c[53],sr.oeb12 USING '############.##',
            COLUMN g_c[54],cl_numfor(sr.oeb13,54,t_azi03),       #No.CHI-6A0004
            COLUMN g_c[55],cl_numfor(sr.oeb14,55,t_azi04),       #No.CHI-6A0004 
            COLUMN g_c[56],sr.oeb15
      #No.8991
      INSERT INTO curr_tmp VALUES(sr.oea23,sr.oeb14,
                                  sr.order1,sr.order2,sr.order3)
      #No.8991(end)
		
   AFTER GROUP OF sr.order1            #金額小計
      IF tm.u[1,1] = 'Y' THEN
         LET l_amt_1 = GROUP SUM(sr.oeb14)
         LET l_amt_2 = GROUP SUM(sr.oeb12)
         PRINT COLUMN g_c[51],g_orderA[1] CLIPPED,
               COLUMN g_c[52],g_x[11] CLIPPED,
               COLUMN g_c[53],l_amt_2 USING '############.##';
         #No.8991
         FOREACH tmp1_cs USING sr.order1 INTO sr1.*
             SELECT azi05 INTO t_azi05 FROM azi_file      #No.CHI-6A0004
              WHERE azi01 = sr1.curr
             LET l_str = sr1.curr CLIPPED,':'
             PRINT COLUMN g_c[54],l_str CLIPPED,
                   COLUMN g_c[55],cl_numfor(sr1.amt,55,t_azi05) CLIPPED     #No.CHI-6A0004
         END FOREACH
         #No.8991(end)
   	 PRINT ''
      END IF
 
   AFTER GROUP OF sr.order2            #金額小計
      IF tm.u[2,2] = 'Y' THEN
         LET l_amt_1 = GROUP SUM(sr.oeb14)
         LET l_amt_2 = GROUP SUM(sr.oeb12)
         PRINT COLUMN g_c[51],g_orderA[2] CLIPPED,
               COLUMN g_c[52],g_x[11] CLIPPED,
               COLUMN g_c[53],l_amt_2 USING '############.##';
         #No.8991
         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
             SELECT azi05 INTO t_azi05 FROM azi_file       #No.CHI-6A0004
              WHERE azi01 = sr1.curr
             LET l_str = sr1.curr CLIPPED,':'
             PRINT COLUMN g_c[54],l_str CLIPPED,
                   COLUMN g_c[55],cl_numfor(sr1.amt,55,t_azi05) CLIPPED       #No.CHI-6A0004
         END FOREACH
         #No.8991(end)
         PRINT ''
      END IF
 
   AFTER GROUP OF sr.order3            #金額小計
      IF tm.u[3,3] = 'Y' THEN
         LET l_amt_1 = GROUP SUM(sr.oeb14)
         LET l_amt_2 = GROUP SUM(sr.oeb12)
         PRINT COLUMN g_c[51],g_orderA[3] CLIPPED,
               COLUMN g_c[52],g_x[11] CLIPPED,
               COLUMN g_c[53],l_amt_2 USING '############.##';
         #No.8991
         FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
             SELECT azi05 INTO t_azi05 FROM azi_file     #No.CHI-6A0004
              WHERE azi01 = sr1.curr
             LET l_str = sr1.curr CLIPPED,':'
             PRINT COLUMN g_c[54],sr1.curr CLIPPED,':',
                   COLUMN g_c[55],cl_numfor(sr1.amt,55,t_azi05) CLIPPED       #No.CHI-6A0004
         END FOREACH
         #No.8991(end)
         PRINT ''
      END IF
 
   ON LAST ROW                         #金額總計
      PRINT ''
      LET l_amt_1 = SUM(sr.oeb14)
      LET l_amt_2 = SUM(sr.oeb12)
      PRINT COLUMN g_c[52],g_x[12] CLIPPED,
            COLUMN g_c[53],l_amt_2 USING '############.##';
      #No.8991
      FOREACH tmp4_cs INTO sr1.*
          SELECT azi05 INTO t_azi05 FROM azi_file      #No.CHI-6A0004
           WHERE azi01 = sr1.curr
          LET l_str = sr1.curr CLIPPED,':'
          PRINT COLUMN g_c[54],l_str CLIPPED,
                COLUMN g_c[55],cl_numfor(sr1.amt,55,t_azi05)    #No.CHI-6A0004 
      END FOREACH
      #No.8991(end)
      PRINT ''
 
      #是否列印選擇條件
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05,oea12,oea14,oea15,oea23,oeb04,oeb06,ima021,oeahold')     #TQC-C90095 add oea12,oea14,oea15,oea23,oeahhold #190509 add by ruby
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
     #        IF tm.wc[001,070] > ' ' THEN            # for 80
     #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
     #        IF tm.wc[071,140] > ' ' THEN
     #    PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
     #        IF tm.wc[141,210] > ' ' THEN
     #    PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
     #        IF tm.wc[211,280] > ' ' THEN
     #    PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
	#TQC-630166
	CALL cl_prt_pos_wc(tm.wc)
      ELSE                                   #TQC-C90095 add
         LET tm.wc = null                    #TQC-C90095 add
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
## FUN-550127
     #PRINT COLUMN g_c[31],g_x[4] CLIPPED,
     #      COLUMN g_c[34],g_x[5] CLIPPED,
     #      COLUMN g_c[37],g_x[9] CLIPPED,
     #      COLUMN g_c[40],g_x[10] CLIPPED,
     PRINT  COLUMN (g_len-9),g_x[7] CLIPPED  #No.FUN-580004
 
   #表尾列印
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
     #   PRINT COLUMN g_c[31],g_x[4] CLIPPED,
     #         COLUMN g_c[34],g_x[5] CLIPPED,
     #         COLUMN g_c[37],g_x[9] CLIPPED,
     #         COLUMN g_c[40],g_x[10] CLIPPED,
     PRINT     COLUMN (g_len-9),g_x[6] CLIPPED  #No.FUN-580004
      ELSE
         SKIP 2 LINE
      END IF
      PRINT
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[4]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[4]
             PRINT g_memo
      END IF
## END FUN-550127
 
END REPORT
}
#No.FUN-7A0036---End
