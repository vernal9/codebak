# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: csfr102.4gl
# Descriptions...: 檢測書資料列印
# Date & Author..: 92/08/14 By Nora
# Modify.........:(NO:6882, (g_argv1,g_argv2先mark無用到),g5掃過只有asfi301 串此支程式)
# Modify.........: No.7967 03/09/01 Carol 若工單有輸入備註資料時，工單列印時應一併列印出來
#                                         --> per add 選項列印
# Modify.........: No.MOD-4A0203 04/10/14 By Smapmin 將l_table5全部印出來
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-530401 05/04/04 By Carol 1.列印嘜頭有 PPPPPP的字樣轉成客戶訂單號
#                                                  2.QBE料號欄位增加 Ctrl+P
# Modify.........: No.FUN-550124 05/05/30 By echo 新增報表備註
# Modify.........: No.MOD-580068 05/08/12 By Claire RETURN ss => RETURN g_count,原判斷 ss=2  => g_count=0
# Modify.........: No.MOD-580275 05/09/13 By Nicola l_dept 改為like pmc_file.pmc03
# Modify.........: No.FUN-5A0140 05/10/21 By Claire 修改報表格式
# Modify.........: No.MOD-5B0296 05/11/30 By Claire 當產品BOM階數大于2，並且發料時3階以上（3階、4階）料件發生取替代時,不被印出
# Modify.........: No.MOD-620075 06/02/24 By Claire 備料清單超過一頁時, 前頁末筆部份資料會產生在次頁表頭,而非清單明細
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-670066 06/07/24 By xiake voucher型報表轉template1型
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0090 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6A0090 06/11/06 By douzh l_time轉g_time
# Modify.........: No.MOD-6B0100 06/11/20 By Claire sfb93加入判斷再印g_x[57]
# Modify.........: No.FUN-710082 07/01/30 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-710070 07/03/28 By atsea 單身抬頭錯誤修改
# Modify.........: No.TQC-740275 07/04/25 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.FUN-750047 07/05/15 By Sarah 畫面新增選項"列印工單Barcode"
# Modify.........: No.FUN-670104 08/10/06 By jan 改r102_p2,s_momo1_c,r102_memo1_c  CURSOR
# Modify.........: No.FUN-940008 09/05/09 By hongmei 發料改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A60097 10/05/27 By Carrier MOD-960330追单
# Modify.........: No.FUN-A60027 10/06/09 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:MOD-A60129 10/06/21 By Sarah Temptable增加sfa27
# Modify.........: No.TQC-A60097 10/06/22 By liuxqa TQC-A60097拆单过来，不做修改，过单用
# Modify.........: No.FUN-A80150 10/09/14 By sabrina 新增計畫批號(sfb919)
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-940042 11/11/04 By minpp 整合單據列印EF簽核
# Modify.........: No:TQC-BA0010 11/11/11 By lilingyu 過單
# Modify.........: No.FUN-B50095 11/12/06 By jason 來源特性為'X'時(資訊參考),應發數量以sfa16*數量計算
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C10039 12/01/12 By wangrr 整合單據列印EF簽核
# Modify.........: No.MOD-CA0097 13/03/07 By Alberti asfi301應發數量有依gfe03取位,報表請比照處理
# Modify.........: No.TQC-D60054 13/06/14 By bart g_rpt_name變數接錯
# Modify.........: No.FUN-E50024 14/05/08 By sabrina GR還原CR
# Modify.........: No.FUN-E40035 14/05/20 By Reanna 1.新增列印款式明細的40欄顏色尺寸報表
#                                14/07/18           2.修改此報表架構
# Modify.........: No.MOD-EB0083 14/11/18 By liliwen 把單頭顏色尺寸FOREACH r102_sfbc_cs搬到，備料的FOREACH r102_c2的外面
# Modify.........: No.MOD-F50134 15/05/28 By Mio 無法列印訂單備註
# Modify.........: No.0000664623_06_M001 17/11/20 By TSD.Nic 增加列印「訂單單號序號欄位」
# Modify.........: No.           17/12/29 By Ruby 增加規格/單位用量/委外廠商
# Modify.........: No.           18/01/24 By Ruby 增加客戶名稱
# Modify.........: No.           18/01/24 By Ruby 增加製程預計開工日/製程預計完工日
# Modify.........: NO.1903072811 20190318 By momo 畫面增加顯示客戶簡稱
# Modify.........: NO.1904172966 20190418 By momo 畫面增加顯示客戶品名ta_obk01 客戶規格ta_obk02
# Modify.........: NO.           20190430 By momo 增加列印 批序號資訊rvbs04+rvbs03
# Modify.........: NO.1905033030 20190510 By momo 畫面增加顯示訂單單號項次與重要備註鈕
# Modify.........: No.1912234056 20191225 By momo 列印時將日期記錄於 sfbud13, 並於畫面上顯示列印日
# Modify.........: No.2105116201 20210514 By momo QBE增加 訂單單號序號、並增加「規格」顯示
# Modify.........: NO.2109166959 20210923 By momo QBE 工單編號限定字數最長 15碼
# Modify.........: No.2206208305 20220623 By momo 增加顯示客戶料號 obk03
# Modify.........: No.22080027   20220811 By momo 增加國別 occ21

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                          # Print condition RECORD #TQC-BA0010
            wc     STRING,                 #No.TQC-630166 VARCHAR(600) #Where condition
            a      LIKE type_file.chr5,    #No.FUN-680121 VARCHAR(1)# XYZ軸
            b      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)# 是否列印製程資料
            c      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)# 是否列印訂單memo
            d      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)# 是否列印訂單嘜頭
            e      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)# 是否特註項目
            f      LIKE type_file.chr1,    #No.FUN-750047 add       # 是否列印工單Barcode
            g      LIKE type_file.chr1,    #FUN-E40035              # 是否列印款式明細
            more   LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
           END RECORD
     # g_argv1     LIKE sfb_file.sfb01,    # 工單編號
     # g_argv2     LIKE sfb_file.sfb05,    # 料件編號
DEFINE g_count     LIKE type_file.num5     #No.FUN-680121 SMALLINT
DEFINE g_i         LIKE type_file.num5     #No.FUN-680121 SMALLINT #count/index for any purpose
DEFINE g_msg       LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(72)
DEFINE g_po_no     LIKE oea_file.oea10     #No.MOD-530401
DEFINE g_ctn_no1,g_ctn_no2   LIKE type_file.chr20  #No.FUN-680121 VARCHAR(20) #MOD-530401
#No.FUN-710082--begin
DEFINE g_sql       STRING
DEFINE l_table     STRING
DEFINE l_str       STRING
#No.FUN-710082--end
#FUN-E40035 add-----------------------------------------------------------------
DEFINE l_table1    STRING
DEFINE l_table2    STRING
DEFINE l_table3    STRING
DEFINE l_table4    STRING
DEFINE l_table5    STRING
DEFINE l_table6    STRING
DEFINE l_table7    STRING
DEFINE l_oea032    LIKE oea_file.oea032   #20190315
DEFINE l_ta_sfb01  LIKE sfb_file.ta_sfb01 #20190510
DEFINE l_sfbud13   LIKE sfb_file.sfbud13  #20191225 檢測書列印日
DEFINE l_ima021    LIKE ima_file.ima021   #20210514 規格
#FUN-E40035 add end-------------------------------------------------------------
DEFINE aa  RECORD
      sfb01    LIKE sfb_file.sfb01,
      sfb02    LIKE sfb_file.sfb02,
      sfb04    LIKE sfb_file.sfb04,
      sfb39    LIKE sfb_file.sfb39,
      sfb22    LIKE sfb_file.sfb22,
      sfb221   LIKE sfb_file.sfb221,
      sfb82    LIKE sfb_file.sfb82,
      gem02    LIKE gem_file.gem02,
      sfb919   LIKE sfb_file.sfb919,   #FUN-A80150 add
      sfb05    LIKE sfb_file.sfb05,
      ima02    LIKE ima_file.ima02,
      ima021   LIKE ima_file.ima021,
      obk03    LIKE obk_file.obk03,    #20220623
      occ21    LIKE occ_file.occ21,    #20220811
      ta_obk01 LIKE obk_file.ta_obk01, #20190418
      ta_obk02 LIKE obk_file.ta_obk02, #20190418
      rvbs04   LIKE rvbs_file.rvbs04,  #製造批號 20190430
      sfb071   LIKE sfb_file.sfb071,
      sfb08    LIKE sfb_file.sfb08,
      sfb09    LIKE sfb_file.sfb09,
      sfb11    LIKE sfb_file.sfb11,
      sfb40    LIKE sfb_file.sfb40,
      sfb34    LIKE sfb_file.sfb34,
      sfb28    LIKE sfb_file.sfb28,
      sfb41    LIKE sfb_file.sfb41,
      sfb06    LIKE sfb_file.sfb06,
      sfb27    LIKE sfb_file.sfb27,
      sfb07    LIKE sfb_file.sfb07,
      sfb38    LIKE sfb_file.sfb38,
      sfb42    LIKE sfb_file.sfb42,
      sfb87    LIKE sfb_file.sfb87,
      sfb13    LIKE sfb_file.sfb13,
      sfb15    LIKE sfb_file.sfb15,
      sfb25    LIKE sfb_file.sfb25,
      sfb251   LIKE sfb_file.sfb251,
      sfb88    LIKE sfb_file.sfb88,
      ima08    LIKE ima_file.ima08, 
      ima55    LIKE ima_file.ima55
END RECORD
#---- 20190510 add (S)
DEFINE g_oao   DYNAMIC ARRAY OF RECORD
               oao05      LIKE oao_file.oao05,
               occ01      LIKE occ_file.occ01,
               occ02      LIKE occ_file.occ02,
               oao04      LIKE oao_file.oao04,
               oao06      LIKE oao_file.oao06,
               oao02      LIKE oao_file.oao02
               END RECORD
DEFINE g_cnt LIKE type_file.num5
DEFINE l_cnt LIKE type_file.num5
DEFINE l_ac LIKE type_file.num5
#---- 20190510 add (E)

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT               # Supress DEL key function

   LET g_pdate = ARG_VAL(1)      # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)
   LET tm.e  = ARG_VAL(12)
   LET tm.f  = ARG_VAL(13)       #FUN-750047 add
   LET tm.g  = ARG_VAL(14)       #FUN-E40035
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)  #FUN-E40035 mod 14->15
   LET g_rep_clas = ARG_VAL(16)  #FUN-E40035 mod 15->16
   LET g_template = ARG_VAL(17)  #FUN-E40035 mod 16->17
   #No.FUN-570264 ---end---
   LET g_rpt_name = ARG_VAL(18)  #TQC-D60054 #FUN-E40035 mod 17->18
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047
 
   display "g_pdate  =",g_pdate
   display "g_towhom =",g_towhom
   display "g_rlang  =",g_rlang
   display "g_bgjob  =",g_bgjob
   display "g_prtway =",g_prtway
   display "g_copies =",g_copies
   display "tm.wc    =",tm.wc
   display "tm.a     =",tm.a
   display "tm.b     =",tm.b
   display "tm.c     =",tm.c
   display "tm.d     =",tm.d
   display "tm.e     =",tm.e
   display "tm.f     =",tm.f
   display "tm.g     =",tm.g     #FUN-E40035

  #LET g_argv1 = ARG_VAL(10)     #NO:6882
  #LET g_argv2 = ARG_VAL(11)     #NO:6882
  #LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078  #TQC-D60054
 


   #FUN-E40035 add--------------------------------------------------------------
   #主報表
   LET g_sql ="sfb01.sfb_file.sfb01,sfb04.sfb_file.sfb04,",
              #M001 171120 By TSD.Nic -----(S)
              "ta_sfb01.sfb_file.ta_sfb01,",
              #M001 171120 By TSD.Nic -----(E)
              "sfb39.sfb_file.sfb39,sfb22.sfb_file.sfb22,",
              "sfb221.sfb_file.sfb221,sfb82.sfb_file.sfb82,",
              "gem02.gem_file.gem02,sfb919.sfb_file.sfb919,",
              "sfb05.sfb_file.sfb05,ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "obk03.obk_file.obk03,",       #20190418
              "occ21.occ_file.occ21,",       #國別 20220811
              "ta_obk01.obk_file.ta_obk01,", #20190418
              "ta_obk02.obk_file.ta_obk02,", #20190418
              "rvbs04.rvbs_file.rvbs04,",    #20190430 
              "imc04_1.imc_file.imc04,",
              "imc04_2.imc_file.imc04,",
              "sfb071.sfb_file.sfb071,",
              "sfb08.sfb_file.sfb08,sfb09.sfb_file.sfb09,",
              "oea032.oea_file.oea032,",                             #add by ruby 2018/01/24
              "sfb11.sfb_file.sfb11,sfb40.sfb_file.sfb40,",
              "sfb34.sfb_file.sfb34,sfb28.sfb_file.sfb28,",
              "sfb41.sfb_file.sfb41,sfb06.sfb_file.sfb06,",
              "sfb27.sfb_file.sfb27,sfb07.sfb_file.sfb07,",
              "sfb38.sfb_file.sfb38,sfb42.sfb_file.sfb42,",
              "sfb87.sfb_file.sfb87,sfb13.sfb_file.sfb13,",
              "sfb15.sfb_file.sfb15,sfb251.sfb_file.sfb251,",
              "sfb88.sfb_file.sfb88,ima08.ima_file.ima08,",
              "ima55.ima_file.ima55,sfb02doc.type_file.chr30,",
              "sign_type.type_file.chr1,sign_img.type_file.blob,",   #簽核方式/簽核圖檔 
              "sign_show.type_file.chr1,sign_str.type_file.chr1000"  #是否顯示簽核資料(Y/N)
   LET l_table = cl_prt_temptable('csfr102',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF

   #子報表-1
   LET g_sql="sfbc01.sfbc_file.sfbc01,",
             "sfbc03_name.agd_file.agd03,sfbc04_name.agd_file.agd03,",
             "sfbc05_1.sfbc_file.sfbc05,sfbc05_2.sfbc_file.sfbc05,",
             "sfbc05_3.sfbc_file.sfbc05,sfbc05_4.sfbc_file.sfbc05,",
             "agd04_color.agd_file.agd04,agd04_size.agd_file.agd04"
   LET l_table1 = cl_prt_temptable('csfr1021',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF

   #子報表-2
   LET g_sql="sfb01.sfb_file.sfb01,sfw02.sfw_file.sfw02,",
             "sfw03.sfw_file.sfw03"
   LET l_table2 = cl_prt_temptable('csfr1022',g_sql) CLIPPED
   IF  l_table2 = -1 THEN EXIT PROGRAM END IF

   #子報表-3
   LET g_sql="sfb01.sfb_file.sfb01,sfb02.sfb_file.sfb02,",
             "sfa03.sfa_file.sfa03,sfa05.sfa_file.sfa05,",
             "sfa06.sfa_file.sfa06,sfa08.sfa_file.sfa08,",
             "sfa11.sfa_file.sfa11,sfa12.sfa_file.sfa12,",
             "sfa26.sfa_file.sfa26,sfa27.sfa_file.sfa27,",
             "sfa012.sfa_file.sfa012,sfa013.sfa_file.sfa013,",
             "ima02_1.ima_file.ima02,gfe03.gfe_file.gfe03,",
             "sizes.ima_file.ima021,sfa16.sfa_file.sfa16"           #add by ruby 2017/12/29
   LET l_table3 = cl_prt_temptable('csfr1023',g_sql) CLIPPED
   IF  l_table3 = -1 THEN EXIT PROGRAM END IF

   #子報表-4
   LET g_sql="sfac01.sfac_file.sfac01,sfac02.sfac_file.sfac02,",
             "sfac03.sfac_file.sfac03,",
             "sfac04_name.agd_file.agd03,sfac05_name.agd_file.agd03,",
             "sfac06_1.sfac_file.sfac06,sfac06_2.sfac_file.sfac06,",
             "sfac06_3.sfac_file.sfac06,sfac06_4.sfac_file.sfac06,",
             "agd04_color.agd_file.agd04,agd04_size.agd_file.agd04"
   LET l_table4 = cl_prt_temptable('csfr1024',g_sql) CLIPPED
   IF  l_table4 = -1 THEN EXIT PROGRAM END IF

   #子報表-5
   LET g_sql="sfb01.sfb_file.sfb01,ecb03.ecb_file.ecb03,",
             "ecb06.ecb_file.ecb06,ecb08.ecb_file.ecb08,",
             "srtdt.sfb_file.sfb071,esrtdt.sfb_file.sfb071,",
             "ecm67.ecm_file.ecm67"                              #add by ruby 2017/12/29
   LET l_table5 = cl_prt_temptable('csfr1025',g_sql) CLIPPED
   IF  l_table5 = -1 THEN EXIT PROGRAM END IF

   #子報表-6
   LET g_sql="sfb01.sfb_file.sfb01,oao03.oao_file.oao03,",
             "oao05.oao_file.oao05,oao06.oao_file.oao06"
   LET l_table6 = cl_prt_temptable('csfr1026',g_sql) CLIPPED
   IF  l_table6 = -1 THEN EXIT PROGRAM END IF

   #子報表-7
   LET g_sql="sfb01.sfb_file.sfb01,ocf01.ocf_file.ocf01,",
             "ocf02.ocf_file.ocf02,ocf101.ocf_file.ocf101,",
             "ocf102.ocf_file.ocf102,ocf103.ocf_file.ocf103,",
             "ocf104.ocf_file.ocf104,ocf105.ocf_file.ocf105,",
             "ocf106.ocf_file.ocf106,ocf107.ocf_file.ocf107,",
             "ocf108.ocf_file.ocf108,ocf109.ocf_file.ocf109,",
             "ocf110.ocf_file.ocf110,ocf111.ocf_file.ocf111,",
             "ocf112.ocf_file.ocf112,ocf201.ocf_file.ocf201,",
             "ocf202.ocf_file.ocf202,ocf203.ocf_file.ocf203,",
             "ocf204.ocf_file.ocf204,ocf205.ocf_file.ocf205,",
             "ocf206.ocf_file.ocf206,ocf207.ocf_file.ocf207,",
             "ocf208.ocf_file.ocf208,ocf209.ocf_file.ocf209,",
             "ocf210.ocf_file.ocf210,ocf211.ocf_file.ocf211,",
             "ocf212.ocf_file.ocf212,occ02.occ_file.occ02"
   LET l_table7 = cl_prt_temptable('csfr1027',g_sql) CLIPPED
   IF  l_table7 = -1 THEN EXIT PROGRAM END IF
   #FUN-E40035 add end----------------------------------------------------------



   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN      #If background job sw is off
      CALL asfr102_tm(0,0)                        #Input print condition
   ELSE
      CALL asfr102()                              #Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr102_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)

  LET p_row = 6 LET p_col = 20
  OPEN WINDOW asfr102_w AT p_row,p_col WITH FORM "csf/42f/csfr102"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)    #No.FUN-580092 HCN
  CALL cl_ui_init()
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL     # Default condition
  LET tm.a    = ''
  LET tm.b='N'
  #IF g_sma.sma54 = 'N' THEN
  #   LET tm.b = 'N'
  #ELSE
  #   LET tm.b = 'Y'
  #END IF
  LET tm.c    = 'N'
  LET tm.d    = 'N'
  LET tm.e    = 'Y'
  LET tm.f    = 'N'           #FUN-750047 add
  LET tm.g    = 'N'           #FUN-E40035
  LET tm.more = 'N'
  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies = '1'


  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfb82 #20210514 add 
       #No.FUN-580031 --start--
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 ---end---
       AFTER FIELD sfb01
         LET aa.sfb01 = GET_FLDBUF(sfb01) #20190318 add            
         LET aa.sfb01 = aa.sfb01[1,15]    #20210923
         DISPLAY aa.sfb01 TO sfb01        #20210923

       ##--- 20210514 add by momo (S)
       #AFTER FIELD ta_sfb01
       #  LET l_ta_sfb01 = GET_FLDBUF(ta_sfb01)
       #  LET l_ta_sfb01 = l_ta_sfb01[1,18]
       #  DISPLAY l_ta_sfb01 TO ta_sfb01
       ##--- 20210514 add by momo (E)

       ON ACTION CONTROLP        #FUN-4B0001
          IF INFIELD(sfb01) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.state    = "c"
             LET g_qryparam.form     = "q_sfb01"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO sfb01
             NEXT FIELD sfb01
          END IF

       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()       #No.FUN-550037 hmf
          EXIT CONSTRUCT

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT

       #No.FUN-580031 --start--
       ON ACTION qbe_select
          CALL cl_qbe_select()
       #No.FUN-580031 ---end---
 
       #MOD-F90107 add start ------------ 
       ON ACTION controlg      
         CALL cl_cmdask()     
       #MOD-F90107 add end   ------------ 

       ON ACTION b_note              #20190510
          CALL r102_q1(l_ta_sfb01)
    END CONSTRUCT

    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF

    IF tm.wc=" 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
    END IF


    DISPLAY BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.more                  #FUN-750047 add tm.f #FUN-E40035 add tm.g
    INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.more WITHOUT DEFAULTS   #FUN-750047 add tm.f #FUN-E40035 add tm.g
       #No.FUN-580031 --start--
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
       #No.FUN-580031 ---end---

    ##---- 20190318 add by momo 顯示客戶簡稱(S)
    ##---- 20191225 add by momo 顯示檢測書列印日期
       BEFORE FIELD a
          LET l_oea032 = ''
          LET l_sfbud13 = ''
          LET l_ima021 = ''  #20210514 add

          ##---- 20210514 modify by momo (S)
          #IF NOT cl_null(l_ta_sfb01) THEN
          #   SELECT oea032,ima021
          #     INTO l_oea032, l_ima021
          #     FROM oea_file,oeb_file,ima_file
          #    WHERE oea01=oeb01
          #      AND oeb04 = ima01
          #      AND oeb01||LPAD(oeb03,3,'0') = l_ta_sfb01

          #   SELECT MAX(sfbud13) INTO l_sfbud13
          #     FROM sfb_file
          #    WHERE ta_sfb01 = l_ta_sfb01
          #      AND sfb87 = 'Y'
          #ELSE

          SELECT oea032,ta_sfb01,sfbud13,ima021    #20210514    
            INTO l_oea032,l_ta_sfb01,l_sfbud13,l_ima021     #20190510 #20210514
            FROM oea_file,sfb_file,ima_file
           WHERE oea01= SUBSTR(ta_sfb01,1,15)
             AND sfb01 = aa.sfb01
             AND ima01 = sfb05
          #END IF

          DISPLAY l_oea032 TO oea032
          DISPLAY l_ta_sfb01 TO ta_sfb01
          DISPLAY l_ima021 TO ima021

       IF NOT cl_null(l_sfbud13) OR l_sfbud13 > '1899/12/31' THEN
          DISPLAY l_sfbud13 TO sfbud13 ATTRIBUTE(REVERSE,RED)
       ELSE
          DISPLAY ' ' TO sfbud13
       END IF
    ##---- 20190318 add by momo 顯示客戶簡稱(E)

    ##---- 20190510 add by momo 顯示客戶重要備註(E)
       ##判斷是否存在重要備註 20190510
       SELECT COUNT(*) INTO l_cnt
         FROM oea_file,tc_oao_file
        WHERE oea01 = SUBSTR(l_ta_sfb01,1,15)
          AND (oea03 = tc_oao01 OR oea04=tc_oao01 OR oea916=tc_oao01)
      IF l_cnt=0 THEN
         SELECT COUNT(*) INTO l_cnt
           FROM oeb_file,oao_file
          WHERE oeb01||LPAD(oeb03,3,'0')=l_ta_sfb01
            AND oeb01=oao01 AND oeb03=oao03
            AND oao05 IN ('1','2')
          IF l_cnt > 0 THEN
             DISPLAY l_ta_sfb01 TO ta_sfb01 ATTRIBUTE(REVERSE,BOLD,RED)
          END IF
      ELSE
         DISPLAY l_ta_sfb01 TO ta_sfb01 ATTRIBUTE(REVERSE,BOLD,RED)
      END IF

    ##---- 20190510 add by momo 顯示客戶簡稱(E)

       AFTER FIELD a
          #IF tm.a NOT MATCHES "[XYZ]" THEN
          #   NEXT FIELD a
          #END IF
          #LET l_dir = 'D'

       BEFORE FIELD b
          IF g_sma.sma54 = 'N' THEN
             IF l_dir = 'D' THEN
                LET l_dir = 'U'
                NEXT FIELD c
             ELSE
                NEXT FIELD a
             END IF
          END IF

       AFTER FIELD b
          IF tm.b NOT MATCHES "[YN]" THEN
             NEXT FIELD b
          END IF

       AFTER FIELD c
          IF tm.c NOT MATCHES "[YN]" THEN
             NEXT FIELD c
          END IF

       AFTER FIELD d
          IF tm.d NOT MATCHES "[YN]" THEN
             NEXT FIELD d
          END IF

       AFTER FIELD e
          IF tm.e NOT MATCHES "[YN]" THEN
             NEXT FIELD e
          END IF

       #str FUN-750047 add
       AFTER FIELD f   #是否列印工單Barcode
          IF tm.f NOT MATCHES "[YN]" THEN
             NEXT FIELD f
          END IF
       #end FUN-750047 add

       #FUN-E40035 add----------------------------------------------------------
       AFTER FIELD g   #是否列印款式明細
          IF tm.g NOT MATCHES "[YN]" THEN
             NEXT FIELD g
          END IF
       #FUN-E40035 add end------------------------------------------------------

       AFTER FIELD more
          IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
       #No.FUN-580031 --start--
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 ---end---
       ON ACTION b_note              #20190510
          CALL r102_q1(l_ta_sfb01)
    END INPUT

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='csfr102'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('csfr102','9031',1)  
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                          " '",g_pdate CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'",       #No.FUN-7C0078
                          " '",g_rlang CLIPPED,"'",      #No.FUN-7C0078
                          " '",g_bgjob CLIPPED,"'",
                          " '",g_prtway CLIPPED,"'",
                          " '",g_copies CLIPPED,"'",
                          " '",tm.wc CLIPPED,"'",
                          " '",tm.a CLIPPED,"'",
                          " '",tm.b CLIPPED,"'",
                          " '",tm.c CLIPPED,"'",
                          " '",tm.d CLIPPED,"'",
                          " '",tm.e CLIPPED,"'",
                          " '",tm.f CLIPPED,"'",         #FUN-750047 add
                          " '",tm.g CLIPPED,"'",         #FUN-E40035
                         #" '",g_argv1 CLIPPED,"'",
                         #" '",g_argv2 CLIPPED,"'"
                          " '",g_rep_user CLIPPED,"'",   #No.FUN-570264
                          " '",g_rep_clas CLIPPED,"'",   #No.FUN-570264
                          " '",g_template CLIPPED,"'",   #No.FUN-570264
                          " '",g_rpt_name CLIPPED,"'"    #No.FUN-7C0078
          CALL cl_cmdat('asfr102',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW asfr102_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL asfr102()
    ERROR ""
  END WHILE
  CLOSE WINDOW asfr102_w
END FUNCTION

FUNCTION asfr102()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#         l_time    LIKE type_file.chr8               #No.FUN-6A0090
          l_sql     STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc LIKE type_file.chr30,            #No:TQC-A60097 add
#         l_order   ARRAY[5] OF LIKE apm_file.apm08,  #No.FUN-680121 VARCHAR(10) # TQC-6A0079
          sr        RECORD
                     sfb      RECORD LIKE sfb_file.*,
                     ima02    LIKE ima_file.ima02,    #品名規格
                     ima021   LIKE ima_file.ima021,   #品名規格
                     obk03    LIKE obk_file.obk03,    #客戶料號 20220623
                     occ21    LIKE occ_file.occ21,    #國別 20220811
                     ta_obk01 LIKE obk_file.ta_obk01, #客戶品名 20190418
                     ta_obk02 LIKE obk_file.ta_obk02, #客戶規格 20190418
                     rvbs04   LIKE rvbs_file.rvbs04,  #製造批號 20190430
                     imc04_1  LIKE imc_file.imc04, 
                     imc04_2  LIKE imc_file.imc04, 
                     ima08    LIKE ima_file.ima08,    #來源碼
                     ima55    LIKE ima_file.ima55     #生產單位
                    END RECORD
#No.FUN-710082--begin
DEFINE    sr1       RECORD
                     sfa03    LIKE sfa_file.sfa03,    #料件編號
                     sfa05    LIKE sfa_file.sfa05,    #應發數量
                     sfa06    LIKE sfa_file.sfa06,    #已發數量
                     sfa062   LIKE sfa_file.sfa06,    #
                     sfa063   LIKE sfa_file.sfa06,    #
                     sfa07    LIKE sfa_file.sfa07,    #缺料數量
                     sfa08    LIKE sfa_file.sfa08,    #作業編號
                     sfa09    LIKE sfa_file.sfa09,    #前置時間調整
                     sfa11    LIKE sfa_file.sfa11,    #旗標
                     sfa12    LIKE sfa_file.sfa12,    #發料單位
                     sfa16    LIKE sfa_file.sfa16,    #標準QPA #FUN-B50095
                     sfa25    LIKE sfa_file.sfa25,    #未備料量
                     sfa26    LIKE sfa_file.sfa26,    #來源
                     sfa27    LIKE sfa_file.sfa27,    #被替代料號   #MOD-A60129 add
                     sfa29    LIKE sfa_file.sfa29,    #上階料號
                     sfa012   LIKE sfa_file.sfa012,   #製程段號
                     sfa013   LIKE sfa_file.sfa013    #製程段號 
                    END RECORD,
          sr2       RECORD
                     ecm03    LIKE ecm_file.ecm03,    #作業序號
                     ecm06    LIKE ecm_file.ecm06,    #工作站
                     ecm11    LIKE ecm_file.ecm11,    #製程編號
                     eca04    LIKE eca_file.eca04     #工作站型態
                    END RECORD,
          sr3       RECORD
                     ocf      RECORD LIKE ocf_file.*     #NO:6882
                    END RECORD,
          sr4       RECORD
                     oao03      LIKE oao_file.oao03,   #NO:6882
                     oao05      LIKE oao_file.oao05,
                     oao06      LIKE oao_file.oao06    #訂單備註
                    END RECORD
   DEFINE cr        RECORD                        #TQC-740275 add
                     sfb01    LIKE sfb_file.sfb01,
                     sfb02    LIKE sfb_file.sfb02,
                     sfb04    LIKE sfb_file.sfb04,
                     sfb39    LIKE sfb_file.sfb39,
                     sfb22    LIKE sfb_file.sfb22,
                     sfb221   LIKE sfb_file.sfb221,
                     sfb82    LIKE sfb_file.sfb82,
                     gem02    LIKE gem_file.gem02,
                     sfb919   LIKE sfb_file.sfb919,   #FUN-A80150 add
                     sfb05    LIKE sfb_file.sfb05,
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima021,
                     sfb071   LIKE sfb_file.sfb071,
                     sfb08    LIKE sfb_file.sfb08,
                     sfb09    LIKE sfb_file.sfb09,
                     sfb11    LIKE sfb_file.sfb11,
                     sfb40    LIKE sfb_file.sfb40,
                     sfb34    LIKE sfb_file.sfb34,
                     sfb28    LIKE sfb_file.sfb28,
                     sfb41    LIKE sfb_file.sfb41,
                     sfb06    LIKE sfb_file.sfb06,
                     sfb27    LIKE sfb_file.sfb27,
                     sfb07    LIKE sfb_file.sfb07,
                     sfb38    LIKE sfb_file.sfb38,
                     sfb42    LIKE sfb_file.sfb42,
                     sfb87    LIKE sfb_file.sfb87,
                     sfb13    LIKE sfb_file.sfb13,
                     sfb15    LIKE sfb_file.sfb15,
                     sfb25    LIKE sfb_file.sfb25,
                     sfb251   LIKE sfb_file.sfb251,
                     sfb88    LIKE sfb_file.sfb88,
                     ima08    LIKE ima_file.ima08, 
                     ima55    LIKE ima_file.ima55, 
                     sfa03    LIKE sfa_file.sfa03,
                     sfa05    LIKE sfa_file.sfa05,
                     sfa06    LIKE sfa_file.sfa06,
                     sfa062   LIKE sfa_file.sfa06,
                     sfa063   LIKE sfa_file.sfa06,
                     sfa07    LIKE sfa_file.sfa07,
                     sfa08    LIKE sfa_file.sfa08,
                     sfa09    LIKE sfa_file.sfa09,
                     sfa11    LIKE sfa_file.sfa11,
                     sfa12    LIKE sfa_file.sfa12,
                     sfa16    LIKE sfa_file.sfa16,   #FUN-B50095
                     sfa25    LIKE sfa_file.sfa25,
                     sfa26    LIKE sfa_file.sfa26,
                     sfa27    LIKE sfa_file.sfa27,          #MOD-A60129 add
                     sfa29    LIKE sfa_file.sfa29,
                     sfa012   LIKE sfa_file.sfa012,         #FUN-A60027
                     sfa013   LIKE sfa_file.sfa013,         #FUN-A60027
                     ima02_1  LIKE ima_file.ima02,
                     ima021_1 LIKE ima_file.ima021,
                     eca04d   LIKE eca_file.eca04,
                     ecb012   LIKE ecb_file.ecb012,         #FUN-A60027
                     ecb03    LIKE ecb_file.ecb03,
                     ecb06    LIKE ecb_file.ecb06,
                     ecb08    LIKE ecb_file.ecb08,
                     srtdt    LIKE type_file.dat,
                     duedt    LIKE type_file.dat,
                     esrtdt   LIKE type_file.dat,
                     lsrtdt   LIKE type_file.dat,
                     eduedt   LIKE type_file.dat,
                     lduedt   LIKE type_file.dat,
                     ocf01    LIKE ocf_file.ocf01,
                     ocf02    LIKE ocf_file.ocf02,
                     ocf101   LIKE ocf_file.ocf101,
                     ocf102   LIKE ocf_file.ocf102,
                     ocf103   LIKE ocf_file.ocf103,
                     ocf104   LIKE ocf_file.ocf104,
                     ocf105   LIKE ocf_file.ocf105,
                     ocf106   LIKE ocf_file.ocf106,
                     ocf107   LIKE ocf_file.ocf107,
                     ocf108   LIKE ocf_file.ocf108,
                     ocf109   LIKE ocf_file.ocf109,
                     ocf110   LIKE ocf_file.ocf110,
                     ocf111   LIKE ocf_file.ocf111,
                     ocf112   LIKE ocf_file.ocf112,
                     ocf201   LIKE ocf_file.ocf201,
                     ocf202   LIKE ocf_file.ocf202,
                     ocf203   LIKE ocf_file.ocf203,
                     ocf204   LIKE ocf_file.ocf204,
                     ocf205   LIKE ocf_file.ocf205,
                     ocf206   LIKE ocf_file.ocf206,
                     ocf207   LIKE ocf_file.ocf207,
                     ocf208   LIKE ocf_file.ocf208,
                     ocf209   LIKE ocf_file.ocf209,
                     ocf210   LIKE ocf_file.ocf210,
                     ocf211   LIKE ocf_file.ocf211,
                     ocf212   LIKE ocf_file.ocf212,
                     occ02    LIKE occ_file.occ02,
                     sfw02    LIKE sfw_file.sfw02,
                     sfw03    LIKE sfw_file.sfw03,
                     oao03    LIKE oao_file.oao03,
                     oao05    LIKE oao_file.oao05,
                     oao06    LIKE oao_file.oao06 
                    END RECORD
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
		  l_sizes LIKE ima_file.ima021,
          l_dept    LIKE pmc_file.pmc03,          #No.MOD-580275
          l_occ02   LIKE occ_file.occ02,
          l_eca04   LIKE eca_file.eca04,
          l_eca04d  LIKE eca_file.eca04,          #TQC-740275 add
          l_sum1,l_sum2,l_sum3    LIKE smh_file.smh103,        #No.FUN-680121 DEC(13,5)
          l_cnt     LIKE type_file.num5           #No.FUN-680121 SMALLINT
   DEFINE l_oea01   LIKE oea_file.oea01
   DEFINE l_ofb01   LIKE ofb_file.ofb01
   DEFINE l_oea04   LIKE oea_file.oea04
   DEFINE l_oea44   LIKE oea_file.oea44
   DEFINE l_sfw02   LIKE sfw_file.sfw02
   DEFINE l_sfw03   LIKE sfw_file.sfw03
   DEFINE l_ecm67   LIKE ecm_file.ecm67  #add by ruby 2017/12/29
   DEFINE l_oea032  LIKE oea_file.oea032 #add by ruby 2018/01/24
   DEFINE l_oea03   LIKE oea_file.oea03  #20190418
#No.FUN-710082--end  
   DEFINE l_short_qty   LIKE sfa_file.sfa07   #FUN-940008 add
   DEFINE l_sfa  RECORD LIKE sfa_file.*       #FUN-940008 add
   DEFINE l_gfe03   LIKE gfe_file.gfe03       #MOD-CA0097 add
   DEFINE l_ecm50   LIKE ecm_file.ecm50       #add by ruby 2018/01/24
   DEFINE l_ecm51   LIKE ecm_file.ecm51       #add by ruby 2018/01/24
   #str TQC-740275 add
#FUN-940042--ADD--STR--
   DEFINE            l_img_blob     LIKE type_file.blob
#TQC-C10039--start--mark--   
   #DEFINE            l_ii           INTEGER
   #DEFINE            l_key          RECORD                  #主鍵
                       # v1          LIKE sfb_file.sfb01
                       #            END RECORD
#TQC-C10039--end--mark--
#FUN-940042--ADD--END--
   #FUN-E40035 add--------------------------------------------------------------
   #單頭
   DEFINE l_sfbc03       LIKE sfbc_file.sfbc03,
          l_sfbc03_name  LIKE agd_file.agd03,    #顏色
          l_sfbc04       LIKE sfbc_file.sfbc04,
          l_sfbc04_name  LIKE agd_file.agd03,    #尺寸
          l_sfbc05       LIKE sfbc_file.sfbc05,
          l_sfbc05_1     LIKE sfbc_file.sfbc05,  #數量(1~10)
          l_sfbc05_2     LIKE sfbc_file.sfbc05,  #數量(11~20)
          l_sfbc05_3     LIKE sfbc_file.sfbc05,  #數量(21~30)
          l_sfbc05_4     LIKE sfbc_file.sfbc05   #數量(31~40)
   #單身
   DEFINE l_sfac04       LIKE sfac_file.sfac04,
          l_sfac04_name  LIKE agd_file.agd03,    #顏色
          l_sfac05       LIKE sfac_file.sfac05,
          l_sfac05_name  LIKE agd_file.agd03,    #尺寸
          l_sfac06       LIKE sfac_file.sfac06,
          l_sfac06_1     LIKE sfac_file.sfac06,  #數量(1~10)
          l_sfac06_2     LIKE sfac_file.sfac06,  #數量(11~20)
          l_sfac06_3     LIKE sfac_file.sfac06,  #數量(21~30)
          l_sfac06_4     LIKE sfac_file.sfac06   #數量(31~40)
   DEFINE l_flag         LIKE type_file.chr1     #是否顯示款別明細
   DEFINE l_next         LIKE type_file.num5     #目前分組到哪一筆
   DEFINE l_agd04_color  LIKE agd_file.agd04     #順序-顏色
   DEFINE l_agd04_size   LIKE agd_file.agd04     #順序-尺寸
   DEFINE l_wc           STRING
   #FUN-E40035 add end----------------------------------------------------------

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #FUN-E40035 add--------------------------------------------------------------
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)
   CALL cl_del_data(l_table4)
   CALL cl_del_data(l_table5)
   CALL cl_del_data(l_table6)
   CALL cl_del_data(l_table7)
   #FUN-E40035 add end----------------------------------------------------------
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#
   DELETE FROM r102_tmp
   DELETE FROM r102_tmp1
   DELETE FROM r102_tmp2
   DELETE FROM r102_tmp3
   DELETE FROM r102_tmp4
   DELETE FROM r102_tmp5


   #FUN-E40035 add--------------------------------------------------------------
   #主報表
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,? ) " #20190418 #20190430 1? #20220623 1? #20220811 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   #子報表-1
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,? ,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   #子報表-2
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   #子報表-3
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?,? ,?,?,?,?,? ,?,?,?,?,? ,?)"          #add by ruby 2? 2017/12/29
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep3:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   #子報表-4
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
               " VALUES(?,?,?,?,? ,?,?,?,?,? ,?)"
   PREPARE insert_prep4 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep4:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   #子報表-5
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
               " VALUES(?,?,?,?,? ,?,?)"       #add by ruby 1? 2017/12/29
   PREPARE insert_prep5 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep5:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   #子報表-6
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table6 CLIPPED,
               " VALUES(?,?,?,?)"
   PREPARE insert_prep6 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep6:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   #子報表-7
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table7 CLIPPED,
               " VALUES(?,?,?,?,? ,?,?,?,?,? ,?,?,?,?,? ,?,?,?,?,?",
               "       ,?,?,?,?,? ,?,?,?) "
   PREPARE insert_prep7 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep7:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   #FUN-E40035 add end----------------------------------------------------------



   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
   #End:FUN-980030

 
   LET l_sql = " SELECT sfb_file.*,ima02,ima021,'','','','','','','',ima08,ima55",                 #20190418 #20190430 #20220623 #20220811
   #           " FROM sfb_file,OUTER ima_file",                 #FUN-A60027
               " FROM sfb_file LEFT OUTER JOIN ima_file ON sfb_file.sfb05 = ima_file.ima01 ",   #FUN-A60027
              #" WHERE  sfb_file.sfb05 = ima_file.ima01  AND sfb87!='X' AND ",tm.wc CLIPPED     #FUN-A60027
               " WHERE  sfb87!='X' AND ",tm.wc CLIPPED                                          #FUN-A60027
   LET l_sql=l_sql CLIPPED," ORDER BY sfb01"   #No.FUN-710082
   PREPARE asfr102_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('p1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   DECLARE asfr102_curs1 CURSOR FOR asfr102_p1


   LET l_sql = " SELECT * FROM ocf_file ",      #NO:6882
               " WHERE  ocf01=? AND ocf02=? "
   PREPARE asfr102_p2 FROM l_sql                  # RUNTIME 編譯
   DECLARE asfr102_curs2 CURSOR FOR asfr102_p2    # CURSOR

#No.FUN-670104--BEGIN--
   IF tm.a = 'Y' THEN        #備料資料
      LET l_sql = " SELECT sfa03,sfa05,sfa06,sfa062,sfa063,'',sfa08,", #FUN-940008 sfa07-->''
                  " sfa09,sfa11,sfa12,sfa16,sfa25,sfa26,sfa27,sfa29,sfa012,sfa013",    #FUN-A60027 add sfa012,sfa013  #MOD-A60129 add sfa27 #FUN-B50095 add sfa16
                  " FROM sfa_file",
                  " WHERE sfa01 = ? ",
                  " ORDER BY sfa27 "
      PREPARE r102_p2 FROM l_sql
      IF STATUS THEN CALL cl_err('p2:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM 
      END IF
      DECLARE r102_c2 CURSOR FOR r102_p2

   END IF     
   IF tm.c ='Y' THEN #訂單備註       
      LET l_sql = " SELECT oao03,oao05,oao06,oao04 FROM oao_file",
                  " WHERE oao01 = ? ",
                 #"   AND oao05 ='0'",               #MOD-F50134 mark
                  "   AND (oao03=0 OR oao03=?)",
                  " ORDER BY oao03 "
     PREPARE r102_memo1_1 FROM l_sql
     DECLARE s_memo1_c CURSOR FOR r102_memo1_1
   END IF
   IF tm.e ='Y' THEN #特註
      LET l_sql = " SELECT imc03,imc04 FROM imc_file ",
                  "  WHERE imc02='CI01' AND imc01 = ? ",
                  "  ORDER BY imc03 "
     PREPARE r102_memo1_2 FROM l_sql
     DECLARE r102_memo1_c CURSOR FOR r102_memo1_2
   END IF

   IF tm.g='Y' THEN
      #(單頭)抓取尺寸總共有幾個
      LET g_sql="SELECT DISTINCT(sfbc04)",
                "  FROM sfbc_file",
                " WHERE sfbc01=? ",
                " ORDER BY sfbc04"
      PREPARE r102_sfbc_pr FROM g_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare r102_sfbc_pr:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE r102_sfbc_cs CURSOR FOR r102_sfbc_pr

      #(單頭)抓取該尺寸的顏色總共有幾個
      LET g_sql="SELECT sfbc03,sfbc05",
                "  FROM sfbc_file",
                " WHERE sfbc01=? AND sfbc04=? ",
                "   AND sfbc05 <> '0'",
                " ORDER BY sfbc03,sfbc05"
      PREPARE r102_sfbc_pr1 FROM g_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare r102_sfbc_pr1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE r102_sfbc_cs1 CURSOR FOR r102_sfbc_pr1

      #(單身)抓取尺寸總共有幾個
      LET g_sql="SELECT DISTINCT(sfac05)",
                "  FROM sfac_file",
                " WHERE sfac01=? AND sfac013=? AND sfac03=?",
                " ORDER BY sfac05"
      PREPARE r102_sfac_pr FROM g_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare r102_sfac_pr:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE r102_sfac_cs CURSOR FOR r102_sfac_pr

      #(單身)抓取該尺寸的顏色總共有幾個
      LET g_sql="SELECT sfac04,sfac06",
                "  FROM sfac_file",
                " WHERE sfac01=? AND sfac013=? AND sfac03=? AND sfac05=? ",
                "   AND sfac06 <> '0'",
                " ORDER BY sfac04,sfac06"
      PREPARE r102_sfac_pr1 FROM g_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare r102_sfac_pr1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE r102_sfac_cs1 CURSOR FOR r102_sfac_pr1
   END IF
   #FUN-E40035 add end----------------------------------------------------------

   CALL cl_del_data(l_table)
   #FUN-E40035 add--------------------------------------------------------------
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)
   CALL cl_del_data(l_table4)
   CALL cl_del_data(l_table5)
   CALL cl_del_data(l_table6)
   CALL cl_del_data(l_table7)
   #FUN-E40035 add end----------------------------------------------------------
   FOREACH asfr102_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      FOR l_next = 1 TO sr.sfb.sfb08

  	  #客戶名稱add by ruby 2018/01/24
      SELECT oea03,oea032,oea04 INTO l_oea03,l_oea032,l_oea04 #20220811 add oea04 
        FROM oea_file 
       WHERE oea01=substr(sr.sfb.ta_sfb01,1,15)
      IF SQLCA.SQLCODE THEN 
         LET l_oea032='' 
         LET l_oea03='' 
         LET l_oea04='' 
      END IF  

      ##--- 20190418 客戶規格、客戶品名
      SELECT obk03,ta_obk01,ta_obk02           
        INTO sr.obk03,sr.ta_obk01,sr.ta_obk02  #20220811
        FROM obk_file                         
       WHERE obk01 = sr.sfb.sfb05
         AND obk02 = l_oea03
      IF cl_null(sr.obk03) THEN LET sr.obk03='無客戶料號' END IF

      ##----- 20220811 國別  (S)
      LET sr.occ21= ''
      SELECT occ21 INTO sr.occ21       #先抓送貨客戶
        FROM occ_file
       WHERE occ01 = l_oea04
      IF cl_null(sr.occ21) THEN
         SELECT occ21 INTO sr.occ21    #抓不到送貨客戶改抓帳款客戶
           FROM occ_file
          WHERE occ01 = l_oea03
      END IF
      ##----- 20220811 國別  (E)

      #--- 20190430 製造批號
      SELECT rvbs04||rvbs03 INTO sr.rvbs04
        FROM rvbs_file,shb_file
        WHERE rvbs022=l_next
          AND rvbs01 = shb01 AND shb05=sr.sfb.sfb01
          AND rvbs02 = shb06

      ##--- 20181120 add by momo 增加馬達規格與轉速
      SELECT imc04 INTO sr.imc04_1 FROM imc_file
       WHERE imc01 = sr.sfb.sfb05 AND imc02='QC01' AND imc03=1

      SELECT imc04 INTO sr.imc04_2 FROM imc_file
       WHERE imc01 = sr.sfb.sfb05 AND imc02='QC01' AND imc03=2
      IF NOT cl_null(tm.a) THEN
         LET sr.sfb.ta_sfb01 = sr.sfb.ta_sfb01[1,18],l_next USING "&&&"||tm.a 
      ELSE
         LET sr.sfb.ta_sfb01 = sr.sfb.ta_sfb01[1,18],l_next USING "&&&"
      END IF

      ##--- 20191224 by momo 記錄首次列印日
      UPDATE sfb_file SET sfbud13 = SYSDATE WHERE sfb01 = sr.sfb.sfb01
                                              AND (sfbud13 <> '1899/12/31' OR sfbud13 IS NULL)
      ##--- 20191224 by momo 記錄首次列印日


      #FUN-E40035 add-----------------------------------------------------------
      EXECUTE insert_prep USING
         sr.sfb.sfb01,sr.sfb.sfb04
        ,sr.sfb.ta_sfb01
        ,sr.sfb.sfb39,sr.sfb.sfb22,sr.sfb.sfb221 #M001 171120 By TSD.Nic add ta_sfb01
        ,sr.sfb.sfb82,l_dept,sr.sfb.sfb919,sr.sfb.sfb05,sr.ima02
        ,sr.ima021
        ,sr.obk03                                #20220623
        ,sr.occ21                                #20220811
        ,sr.ta_obk01                             #20190418
        ,sr.ta_obk02                             #20190418
        ,sr.rvbs04                               #20190430
        ,sr.imc04_1,sr.imc04_2
        ,sr.sfb.sfb071,sr.sfb.sfb08,sr.sfb.sfb09,l_oea032,sr.sfb.sfb11  #add by ruby l_oea032 2018/01/24
        ,sr.sfb.sfb40,sr.sfb.sfb34,sr.sfb.sfb28,sr.sfb.sfb41,sr.sfb.sfb06
        ,sr.sfb.sfb27,sr.sfb.sfb07,sr.sfb.sfb38,sr.sfb.sfb42,sr.sfb.sfb87
        ,sr.sfb.sfb13,sr.sfb.sfb15,sr.sfb.sfb251,sr.sfb.sfb88,sr.ima08
        ,sr.ima55,l_sfb02doc,"",l_img_blob,"N"
        ,""
      #FUN-E40035 add end-------------------------------------------------------
     END FOR
      
#No.FUN-670104--BEGIN--
     #IF tm.a = 'Y' THEN #備料資料 #FUN-E40035 mark
      IF tm.a = 'Y' OR tm.g ='Y' THEN #FUN-E40035

         LET l_cnt = 0
         FOREACH r102_c2 USING sr.sfb.sfb01 INTO sr1.*  #No.FUN-670104
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
            #FUN-A60027  -------------start---------------
           #CALL s_shortqty(l_sfa.sfa01,l_sfa.sfa03,l_sfa.sfa08,l_sfa.sfa12,l_sfa.sfa27,l_sfa.sfa012,l_sfa.sfa013)
            CALL s_shortqty(sr.sfb.sfb01,sr1.sfa03,sr1.sfa08,sr1.sfa12,sr1.sfa27,sr1.sfa012,sr1.sfa013)
               RETURNING sr1.sfa07
            #FUN-A60027 -------------end----------------  
            #str TQC-740275 add 
            SELECT ima02,ima021 INTO l_ima02,l_sizes FROM ima_file WHERE ima01=sr1.sfa03
            IF cl_null(l_ima02) THEN LET l_ima02 = ' ' END IF
            IF cl_null(l_sizes) THEN LET l_sizes = ' ' END IF
            #MOD-CA0097 add start -----
            SELECT gfe03 INTO l_gfe03 FROM gfe_file
             WHERE gfe01 = sr1.sfa12
            IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
               LET l_gfe03 = 0
            END IF
            #MOD-CA0097 add end   -----
         

            #FUN-E40035 add-----------------------------------------------------
			IF tm.a = 'Y' THEN
               EXECUTE insert_prep3 USING
                  sr.sfb.sfb01,sr.sfb.sfb02,sr1.sfa03,sr1.sfa05,sr1.sfa06
                 ,sr1.sfa08,sr1.sfa11,sr1.sfa12,sr1.sfa26,sr1.sfa27
                 ,sr1.sfa012,sr1.sfa013,l_ima02,l_gfe03,l_sizes,sr1.sfa16                  #add by ruby l_sizes,sfa16 2017/12/29
            END IF
         
            #印備料資料之鞋服顏色尺寸
            IF tm.a = 'Y' AND tm.g = 'Y' THEN
               LET l_next = 1
               FOREACH r102_sfac_cs USING sr.sfb.sfb01,sr1.sfa013,sr1.sfa03
                                     INTO l_sfac05
                  IF SQLCA.sqlcode != 0 THEN
                     CALL cl_err('foreach r102_sfac_cs:',SQLCA.sqlcode,1) EXIT FOREACH
                  END IF
                  #尺寸的名稱
                  LET l_sfac05_name=''
                  LET l_agd04_size=''
                  SELECT agd03,agd04 INTO l_sfac05_name,l_agd04_size FROM agd_file
                   WHERE agd02=l_sfac05
                     AND agd01=(SELECT ima941 FROM ima_file WHERE ima01=sr1.sfa03)
                  LET l_sfac06=''
                  CASE
                     WHEN (l_next <= 10)  #1~10
                        #跑每一個顏色
                        FOREACH r102_sfac_cs1 USING sr.sfb.sfb01,sr1.sfa013,sr1.sfa03,l_sfac05
                                              INTO l_sfac04,l_sfac06
                           LET l_sfac06_1=''
                           LET l_sfac06_2=''
                           LET l_sfac06_3=''
                           LET l_sfac06_4=''
                           LET l_sfac06_1=l_sfac06
                           #顏色的名稱
                           LET l_sfac04_name=''
                           LET l_agd04_color=''
                           SELECT agd03,agd04 INTO l_sfac04_name,l_agd04_color FROM agd_file
                            WHERE agd02=l_sfac04
                              AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr1.sfa03)
                           EXECUTE insert_prep4 USING sr.sfb.sfb01,sr1.sfa013,sr1.sfa03,
                                                      l_sfac04_name,l_sfac05_name,l_sfac06_1,
                                                      l_sfac06_2,l_sfac06_3,l_sfac06_4,
                                                      l_agd04_color,l_agd04_size
                        END FOREACH
                     WHEN (l_next > 10 AND l_next <= 20) #11~20
                        #跑每一個顏色
                        FOREACH r102_sfac_cs1 USING sr.sfb.sfb01,sr1.sfa013,sr1.sfa03,l_sfac05
                                              INTO l_sfac04,l_sfac06
                           LET l_sfac06_1=''
                           LET l_sfac06_2=l_sfac06
                           #顏色的名稱
                           SELECT agd03,agd04 INTO l_sfac04_name,l_agd04_color FROM agd_file
                            WHERE agd02=l_sfac04
                              AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr1.sfa03)
                           EXECUTE insert_prep4 USING sr.sfb.sfb01,sr1.sfa013,sr1.sfa03,
                                                      l_sfac04_name,l_sfac05_name,l_sfac06_1,
                                                      l_sfac06_2,l_sfac06_3,l_sfac06_4,
                                                      l_agd04_color,l_agd04_size
                        END FOREACH
                     WHEN (l_next > 20 AND l_next <= 30) #21~30
                        #跑每一個顏色
                        FOREACH r102_sfac_cs1 USING sr.sfb.sfb01,sr1.sfa013,sr1.sfa03,l_sfac05
                                              INTO l_sfac04,l_sfac06
                           LET l_sfac06_2=''
                           LET l_sfac06_3=l_sfac06
                           #顏色的名稱
                           SELECT agd03,agd04 INTO l_sfac04_name,l_agd04_color FROM agd_file
                           WHERE agd02=l_sfac04
                              AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr1.sfa03)
                           EXECUTE insert_prep4 USING sr.sfb.sfb01,sr1.sfa013,sr1.sfa03,
                                                      l_sfac04_name,l_sfac05_name,l_sfac06_1,
                                                      l_sfac06_2,l_sfac06_3,l_sfac06_4,
                                                      l_agd04_color,l_agd04_size
                        END FOREACH
                     WHEN (l_next > 30) #30以上
                        #跑每一個顏色
                        FOREACH r102_sfac_cs1 USING sr.sfb.sfb01,sr1.sfa013,sr1.sfa03,l_sfac05
                                              INTO l_sfac04,l_sfac06
                           LET l_sfac06_3=''
                           LET l_sfac06_4=l_sfac06
                           #顏色的名稱
                           SELECT agd03,agd04 INTO l_sfac04_name,l_agd04_color FROM agd_file
                            WHERE agd02=l_sfac04
                              AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr1.sfa03)
                           EXECUTE insert_prep4 USING sr.sfb.sfb01,sr1.sfa013,sr1.sfa03,
                                                      l_sfac04_name,l_sfac05_name,l_sfac06_1,
                                                      l_sfac06_2,l_sfac06_3,l_sfac06_4,
                                                      l_agd04_color,l_agd04_size
                        END FOREACH
                  END CASE
                  IF NOT cl_null(l_sfac06) THEN
                     LET l_next = l_next+1
                  END IF
               END FOREACH
            END IF
            #FUN-E40035 add end-------------------------------------------------------
         END FOREACH
      END IF 
 
      IF tm.b = 'Y' THEN #製程追蹤資料
         IF g_sma.sma26 != '1' AND sr.sfb.sfb24= 'N' 
            AND sr.sfb.sfb93 ='Y' THEN                 #MOD-6B0100 add
         ELSE
            CALL s_taskdat(0,sr.sfb.sfb13,sr.sfb.sfb15,sr.sfb.sfb071,
                           sr.sfb.sfb01,sr.sfb.sfb06,sr.sfb.sfb02,
                           sr.sfb.sfb05,sr.sfb.sfb08) RETURNING g_count   #MOD-580068 add
            FOR g_i = g_count TO 1 STEP -1                     
                SELECT eca04 INTO l_eca04 FROM eca_file
                 WHERE eca01 = g_takdate[g_i].ecb08
                IF l_eca04 = '2' THEN
                   LET l_eca04d='*'
                ELSE
                   LET l_eca04d=' '
                END IF

                SELECT ecm67,ecm50,ecm51 INTO l_ecm67,l_ecm50,l_ecm51 FROM ecm_file                         #add by ruby l_ecm50,l_ecm51 2018/01/24
                 WHERE ecm01 = sr.sfb.sfb01 
                 and ecm03=g_takdate[g_i].ecb03 and ecm04=g_takdate[g_i].ecb06 #20180925 mark
                  IF STATUS THEN
                      LET l_ecm67 = '' 
                  END IF
             
                EXECUTE insert_prep5 USING
                   sr.sfb.sfb01,g_takdate[g_i].ecb03,
                   g_takdate[g_i].ecb06,g_takdate[g_i].ecb08,
                   #g_takdate[g_i].srtdt,g_takdate[g_i].esrtdt,     #mark by ruby 2018/01/24
                   l_ecm50,l_ecm51,                                 #add by ruby 2018/01/24
                   l_ecm67
                #FUN-E40035 add end---------------------------------------------
            END FOR
         END IF
      END IF
 
#No.FUN-670104--BEGIN--
      IF tm.c = 'Y' THEN #訂單備註  

         FOREACH s_memo1_c USING sr.sfb.sfb22,sr.sfb.sfb221 INTO sr4.* #No.FUN-670104
            IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
            #str TQC-740275 add 
           #EXECUTE insert_prep5 USING #FUN-E40035 mark
            EXECUTE insert_prep6 USING #FUN-E40035
               sr.sfb.sfb01,sr4.oao03,sr4.oao05,sr4.oao06
            #end TQC-740275 add 
         END FOREACH
      END IF
 
      IF tm.d = 'Y' THEN #訂單麥頭
         LET g_po_no=''
         SELECT oea01,oea04,oea44,oea10 INTO l_oea01,l_oea04,l_oea44,g_po_no #MOD-530401
          FROM oea_file              #抓單頭資料
         WHERE oea01=sr.sfb.sfb22
         IF SQLCA.SQLCODE THEN
            LET l_oea01=NULL
            LET l_oea04=NULL
            LET l_oea44=NULL
         END IF
         OPEN asfr102_curs2 USING l_oea04,l_oea44
         FETCH asfr102_curs2 INTO sr3.*
         IF SQLCA.SQLCODE=0 AND NOT cl_null(l_oea04) THEN
            SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr3.ocf.ocf01
 #MOD-530401
            LET g_ctn_no1=''
            LET g_ctn_no2=''
            LET sr3.ocf.ocf101=r102_ocf_c(sr3.ocf.ocf101)
            LET sr3.ocf.ocf102=r102_ocf_c(sr3.ocf.ocf102)
            LET sr3.ocf.ocf103=r102_ocf_c(sr3.ocf.ocf103)
            LET sr3.ocf.ocf104=r102_ocf_c(sr3.ocf.ocf104)
            LET sr3.ocf.ocf105=r102_ocf_c(sr3.ocf.ocf105)
            LET sr3.ocf.ocf106=r102_ocf_c(sr3.ocf.ocf106)
            LET sr3.ocf.ocf107=r102_ocf_c(sr3.ocf.ocf107)
            LET sr3.ocf.ocf108=r102_ocf_c(sr3.ocf.ocf108)
            LET sr3.ocf.ocf109=r102_ocf_c(sr3.ocf.ocf109)
            LET sr3.ocf.ocf110=r102_ocf_c(sr3.ocf.ocf110)
            LET sr3.ocf.ocf111=r102_ocf_c(sr3.ocf.ocf111)
            LET sr3.ocf.ocf112=r102_ocf_c(sr3.ocf.ocf112)
            LET sr3.ocf.ocf201=r102_ocf_c(sr3.ocf.ocf201)
            LET sr3.ocf.ocf202=r102_ocf_c(sr3.ocf.ocf202)
            LET sr3.ocf.ocf203=r102_ocf_c(sr3.ocf.ocf203)
            LET sr3.ocf.ocf204=r102_ocf_c(sr3.ocf.ocf204)
            LET sr3.ocf.ocf205=r102_ocf_c(sr3.ocf.ocf205)
            LET sr3.ocf.ocf206=r102_ocf_c(sr3.ocf.ocf206)
            LET sr3.ocf.ocf207=r102_ocf_c(sr3.ocf.ocf207)
            LET sr3.ocf.ocf208=r102_ocf_c(sr3.ocf.ocf208)
            LET sr3.ocf.ocf209=r102_ocf_c(sr3.ocf.ocf209)
            LET sr3.ocf.ocf210=r102_ocf_c(sr3.ocf.ocf210)
            LET sr3.ocf.ocf211=r102_ocf_c(sr3.ocf.ocf211)
            LET sr3.ocf.ocf212=r102_ocf_c(sr3.ocf.ocf212)
            #str TQC-740275 add 
           #EXECUTE insert_prep3 USING #FUN-E40035 mark
            EXECUTE insert_prep7 USING #FUN-E40035
               sr.sfb.sfb01,sr3.ocf.ocf01
              ,sr3.ocf.ocf02,sr3.ocf.ocf101
              ,sr3.ocf.ocf102,sr3.ocf.ocf103
              ,sr3.ocf.ocf104,sr3.ocf.ocf105
              ,sr3.ocf.ocf106,sr3.ocf.ocf107
              ,sr3.ocf.ocf108,sr3.ocf.ocf109
              ,sr3.ocf.ocf110,sr3.ocf.ocf111
              ,sr3.ocf.ocf112,sr3.ocf.ocf201
              ,sr3.ocf.ocf202,sr3.ocf.ocf203
              ,sr3.ocf.ocf204,sr3.ocf.ocf205
              ,sr3.ocf.ocf206,sr3.ocf.ocf207
              ,sr3.ocf.ocf208,sr3.ocf.ocf209
              ,sr3.ocf.ocf210,sr3.ocf.ocf211
              ,sr3.ocf.ocf212,l_occ02
            #end TQC-740275 add 
         END IF
      END IF
 
#No.FUN-670104--BEGIN--
      IF tm.e = 'Y' THEN #工單備註

         FOREACH r102_memo1_c USING sr.sfb.sfb05 INTO l_sfw02,l_sfw03 #No.FUN-670104
            IF SQLCA.sqlcode THEN
               CALL cl_err('',SQLCA.sqlcode,0)  
               EXIT FOREACH
            END IF
            #str TQC-740275 add 

            EXECUTE insert_prep2 USING #FUN-E40035
               sr.sfb.sfb01,l_sfw02,l_sfw03
            #end TQC-740275 add 
         END FOREACH
      END IF
      

#      OUTPUT TO REPORT asfr102_rep(sr.*)
   END FOREACH


   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
           #FUN-E40035 add------------------------------------------------------
           ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
           ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
           ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED
           ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED
           ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED
           ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table6 CLIPPED
           ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table7 CLIPPED
           #FUN-E40035 add end--------------------------------------------------

   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb82')
      RETURNING tm.wc
   ELSE
      LET tm.wc = ''
   END IF

   LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",
               tm.a,";",tm.b,";",tm.c,";",tm.d,";",tm.e,";",tm.f   #FUN-750047 add tm.f
               ,";",g_sma.sma1421,";",tm.g                         #FUN-E40035 add tm.g

   LET l_str = l_str, ";;;;;;;;;;;", FGL_GETENV("CRIP")
   #FUN-940042--ADD--STR-
   LET g_cr_table = l_table                 #主報表的temp table名稱
  #LET g_cr_gcx01 = "asmi300"               #單別維護程式 #TQC-C10039 mark--
   LET g_cr_apr_key_f = "sfb01"             #報表主鍵欄位名稱，用"|"隔開  

     CALL cl_prt_cs3('csfr102','csfr102',l_sql,l_str)
 
END FUNCTION
 
 
 #MOD-530401 add
FUNCTION r102_ocf_c(str)
  DEFINE str    LIKE oea_file.oea10,       #No.FUN-680121 VARCHAR(30)
         i,j    LIKE type_file.num5          #No.FUN-680121 SMALLINT
  # 把麥頭內'PPPPPP'字串改為 P/O NO (oea10)
  # 把麥頭內'CCCCCC'字串改為 CTN NO ('')
  # 把麥頭內'DDDDDD'字串改為 CTN NO ('')
  FOR i=1 TO 20
    LET j=i+5
    IF str[i,j]='PPPPPP' THEN LET str[i,30]=g_po_no   RETURN str END IF
    IF str[i,j]='CCCCCC' THEN LET str[i,30]=g_ctn_no1 RETURN str END IF
    IF str[i,j]='DDDDDD' THEN LET str[i,30]=g_ctn_no2 RETURN str END IF
  END FOR
 RETURN str
 END FUNCTION
##
#Patch....NO.TQC-610037 <001,002> #
#TQC-A60097
#FUN-E50024



##---- 2019510 add by momo 重要備註（S）
FUNCTION r102_q1(p_ta_sfb01) #20190510
   DEFINE sr    RECORD
               oao05      LIKE oao_file.oao05,
               occ01      LIKE occ_file.occ01,
               occ02      LIKE occ_file.occ02,
               oao04      LIKE oao_file.oao04, 
               oao06      LIKE oao_file.oao06, 
               oao02      LIKE oao_file.oao02
               END RECORD
   DEFINE l_sql STRING
   DEFINE p_row,p_col        LIKE type_file.num5
   DEFINE p_ta_sfb01      LIKE sfb_file.ta_sfb01 #20190510
 

   LET p_row = 6 LET p_col = 2
   OPEN WINDOW t700_q1_w AT p_row,p_col
     WITH FORM "csf/42f/asft700_q1"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_locale("asft700_q1")

   LET l_sql="SELECT '4','','',oao04,oao06,'' ",                    #訂單單身備註
             "  FROM oea_file,oeb_file,oao_file ",
             " WHERE oea01||LPAD(oeb03,3,'0')='",l_ta_sfb01,"'",
             "   AND oeb01=oea01 ",
             "   AND oea01=oao01 AND oeb03=oao03 ",
             "   AND oao05 IN ('1','2') ",
             " UNION ",
             "SELECT '1',occ01,occ02,tc_oao03,tc_oao05,tc_oao04 ",  #帳款客戶備註
             "  FROM occ_file,oea_file,tc_oao_file ",
             " WHERE oea01=SUBSTR('",l_ta_sfb01,"',1,15)",
             "   AND occ01=tc_oao01 AND oea03=occ01 ",
             "   AND (NVL(tc_oao06,'9999/12/31')='9999/12/31' OR tc_oao06 > sysdate) ",
             " UNION ",
             "SELECT '2',occ01,occ02,tc_oao03,tc_oao05,tc_oao04 ",  #送貨客戶備註
             "  FROM occ_file,oea_file,tc_oao_file ",
             " WHERE oea01=SUBSTR('",l_ta_sfb01,"',1,15)",
             "   AND occ01=tc_oao01 AND oea04=occ01 AND oea03 <> oea04 ",
             "   AND (NVL(tc_oao06,'9999/12/31')='9999/12/31' OR tc_oao06 > sysdate) ",
             " UNION ",
             "SELECT '3',occ01,occ02,tc_oao03,tc_oao05,tc_oao04 ",  #多角終端客戶備註
             "  FROM occ_file,oea_file,tc_oao_file ",
             " WHERE oea01=SUBSTR('",l_ta_sfb01,"',1,15)",
             "   AND occ01=tc_oao01 AND oea916=occ01 ",
             "   AND (NVL(tc_oao06,'9999/12/31')='9999/12/31' OR tc_oao06 > sysdate) ",
             " ORDER BY 4 DESC "

   PREPARE t700_q1_prepare FROM l_sql
   DECLARE t700_q1_c CURSOR FOR t700_q1_prepare
   
   CALL g_oao.clear()
   LET g_cnt=1

   FOREACH t700_q1_c INTO sr.*
      IF STATUS THEN
         CALL cl_err('for:',STATUS,1)
         EXIT FOREACH
      END IF
      
      LET g_oao[g_cnt].oao05 = sr.oao05
      LET g_oao[g_cnt].occ01 = sr.occ01
      LET g_oao[g_cnt].occ02 = sr.occ02
      LET g_oao[g_cnt].oao04 = sr.oao04
      LET g_oao[g_cnt].oao06 = sr.oao06
      LET g_oao[g_cnt].oao02 = sr.oao02

      LET g_cnt=g_cnt+1
   END FOREACH
   DISPLAY ARRAY g_oao TO s_oao.*
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         CONTINUE DISPLAY     

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         CONTINUE DISPLAY      

      ON ACTION cancel
         LET INT_FLAG=FALSE                                                                               
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION b_note              #20190510
          CALL r102_q1(l_ta_sfb01)

      
   AFTER DISPLAY
     CONTINUE DISPLAY
   END DISPLAY

   CLOSE WINDOW t700_q1_w

END FUNCTION 
