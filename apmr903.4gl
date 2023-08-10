# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Desc/riptions...: 請購單列印
# Input parameter:
# Return code....:
# Date & Author..: 91/10/05 By MAY
# Modify.........: 93/12/03 By Apple
# Note...........: 考慮列印委外代買的資料
# Modify.........: 95/02/21 By Danny  (格式變更)
# modify.........: 97/04/16 By Davidjr(English Note Printing)
# Modify.........: No.MOD-4A0256 04/10/20 By Mandy 單身沒資料,列印時會出現錯誤錯誤視窗,造成程式當掉
# Modify.........: No.FUN-4B0043 04/11/15 By Nicola 加入開窗功能
# Modify.........: No.MOD-530089 05/03/14 By cate 報表標題標準化
# Modify.........: No.MOD-520129 05/02/25 By Mandy 將g_x[30][1,2]改成g_x[30].substring(1,2)
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: No.FUN-550114 05/05/27 By echo 新增報表備註
# Modify.........: NO.MOD-580126 05/08/12 By Rosayu 報表表格沒對齊
# Modify.........: No.MOD-580143 05/08/15 By kim 列印廠商時,應該要依排序順序列出,排序依序為:核准狀態,核准日期(由最近開始排序),單價
# Modify.........: No.TQC-5A0009 05/10/06 By kim 報表料號放大
# Modify.........: No.MOD-5A0121 05/10/14 By ice 料號/品名/規格欄位放大
# Modify.........: No.FUN-5A0139 05/10/24 By Pengu 調整報表的格式
# Modify.........: No.TQC-610127 06/02/14 By pengu 單位註解內容無show出
# Modify.........: No.TQC-610085 06/04/06 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-640056 06/04/08 By Echo 請購單無列印「規格 」欄位
# Modify.........: No.TQC-640132 06/04/18 By Nicola 日期調整
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.TQC-6A0079 06/11/6 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6A0086 06/11/13 By baogui  報表問題修改
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.FUN-710082 07/03/09 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-740151 07/04/20 By Rayven 打印不出資料
# Modify.........: No.FUN-740214 07/05/10 By Sarah 特別說明的內容沒有印出來
# Modify.........: No.CHI-7A0026 07/10/15 By jamie 特別說明改由新的子報表寫法
# Modify.........: No.MOD-860194 08/06/18 By Smapmin 列印廠商資料時會重複
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-910012 09/01/08 By tsai_yen 在CR報表列印簽核欄
# Moidfy.........: No.FUN-930113 09/03/30 By mike 將oah-->pnz
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.TQC-9A0187 09/10/30 By xiaofeizhu 標準SQL修改
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No.FUN-A40073 10/05/05 By liuxqa modify sql
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No:FUN-A50041 10/05/10 by tsai_yen 報表簽核圖功能出現Error Messages -450,在fglrun Version 2.21.02中的blob必須先用LOCATE初始化
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:CHI-B70039 11/08/18 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:TQC-BA0075 11/10/14 By destiny 笔数可输入负数 
# Modify.........: No:TQC-BB0168 12/01/05 By destiny apmt420调用时会报错退出
# Modify.........: No:TQC-C10039 12/01/13 By minpp  CR报表列印TIPTOP与EasyFlow签核图片
# Modify.........: No:CHI-C50001 12/06/05 By Elise 請購單號(pmk01)增加開窗
# Modify.........: No:FUN-D10004 13/06/11 By jt_chen 有用到pmh_file的SQL條件需增加判斷廠牌pmh07
# Modify.........: No:MOD-DC0123 13/12/20 By Vampire 依單位取位。
# Modify.........: No:FUN-E50025 14/05/14 By Sabrina  GR還原CR 
# Modify.........: No.FUN-E50074 14/06/03 By yinhy 報表欄位15欄增加至40欄
# Modify.........: No:FUN-F50037 15/07/17 By jwlin 增加開窗 請購部門(pmk13)
# Modify.........: No:MOD-FA0154 15/10/30 By fionchen 調整FUN-F50037請購部門開窗 
# Modify.........: No.0000664623_06_M001 17/11/18 By TSD.Nic 增加列印 訂單單號序號 
# Modify.........: No.                   17/12/14 By Ruby 增加列印 廠商代號/廠商簡稱/未稅單價/幣別
# Modify.........: No.                   18/01/12 By Ruby 增加工單單號/預計開工日 
# Modify.........: No.                   18/03/01 By Ruby 增加專案代號
# Modify.........: 20180329 modify by momo 預計開工日優先抓T4011的開工日，若無則抓ta_pml02工單的完工日
# Modify.........: 20180403 modify by momo 預計可用量換算為採購單位
# Modify.........: 20180412 modify by momo T4011抓無資料時抓該工單完工日, SQLCA.SQLCODE 需 =100
# Modify.........: 20180424 modify by momo 增加顯示前後版本料件庫存採購資料
# Modify.........: 20180508 modify by momo 料號ABCD開頭，ima021 改放 ima02
# Modify.........: 20180605 modfiy by momo 前一版本料號增加列印「預計可用量」
# Modify.........: 20180813 add    by momo 增加列印 pmkud01 單頭備註
# Modify.........: 20180827 add    by momo 增加列印年平均用量
# Modify.........: 20180910 add    by momo 增加記錄列印次數與最後列印日期
# Modify.........: 20180925 add    by momo 增加列印季平均用量,最小採購量 ima46
# Modify.........: 20180928 add    by momo 顯加列印顯示「是否存在BOM」
# Modify.........: 20181012 Modify by momo 調整平均用量計算方式 改為 cs_avguse01
# Modify.........: 20181031 Modify by momo 年平均用量改抓 ima41
# Modify.........: 20181222 add    by momo 新增pml88t 含稅金額欄位總計用
# Modify.........: NO:1909093607 20190912 By momo 請購單列印時加入”供應商等級”欄位pmcud06，若為C級廠商則顯示為紅字
# Modify.........: NO:2005254689 20200527 By momo 料號有存在於分量計價,列印報表時料號秀"紅字"
#                                                 報表新增欄位：平均入庫量(往前抓三個月)
# Modify.........: NO:2111027209 20211102 By momo 增加 sma119料件編碼長度判斷，20碼才抓前後版本資訊
# Modify.........: NO:2202107544 20220210 By momo 增加顯示請購員
# Modify.........: No:2207258542 20220725 By momo 版本料號資訊重覆修正
# Modify.........: No:23070058   20230810 By momo aimi108 PR01 類別，固定顯示

DATABASE ds

 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD
                   wc      LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(500)
                   d       LIKE type_file.chr1,     #FUN-E50074
                   a       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
                   b       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
                   c       LIKE type_file.num5,         #No.FUN-680136 SMALLINT
                   more    LIKE type_file.chr1   	#No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_zo   RECORD    LIKE zo_file.*
 
   DEFINE g_cnt            LIKE type_file.num10         #No.FUN-680136 INTEGER
   DEFINE i                LIKE type_file.num5          #No.FUN-710082
   DEFINE g_cnt1           LIKE type_file.num10         #No.FUN-710082 
   DEFINE g_i              LIKE type_file.num5          #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_table1   STRING                                                       
DEFINE  l_table2   STRING    #FUN-740214 add     
DEFINE  l_table3   STRING    #FUN-E50074 
DEFINE  l_table4   STRING    #20180424                                       
DEFINE  l_str      STRING   
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                         # Supress DEL key function
   #TQC-BB0168--begin
   LET g_pdate = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d = ARG_VAL(11)           #FUN-E50074
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #TQC-BB0168--end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
   #--->無使用請購功能
   IF g_sma.sma31 matches'[Nn]' THEN
      CALL cl_err(g_sma.sma31,'mfg0032',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   #TQC-BB0168--begin 
#  LET g_pdate = ARG_VAL(1)                 # Get arguments from command line
#  LET g_towhom = ARG_VAL(2)
#  LET g_rlang = ARG_VAL(3)
#  LET g_bgjob = ARG_VAL(4)
#  LET g_prtway = ARG_VAL(5)
#  LET g_copies = ARG_VAL(6)
#  LET tm.wc = ARG_VAL(7)
#  LET tm.a  = ARG_VAL(8)
#  LET tm.b  = ARG_VAL(9)
#  LET tm.c  = ARG_VAL(10)   
#  LET g_rep_user = ARG_VAL(11)
#  LET g_rep_clas = ARG_VAL(12)
#  LET g_template = ARG_VAL(13)
#  LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #TQC-BB0168--end 
   IF cl_null(tm.a) THEN LET tm.a='N' END IF
   IF cl_null(tm.b) THEN LET tm.b='N' END IF
   IF cl_null(tm.c) THEN LET tm.c=0   END IF
 
   LET g_sql ="pmk01.pmk_file.pmk01,",
              "smydesc.smy_file.smydesc,",
              "pmk04.pmk_file.pmk04,",
              "pmk13.pmk_file.pmk13,",
              "gem02.gem_file.gem02,",
 
              "pmc081.pmc_file.pmc081,",
              "pmc091.pmc_file.pmc091,",
              "pma02.pma_file.pma02,",
              "pmk41.pmk_file.pmk41,",
              "oah02.oah_file.oah02,",
 
              "pme031.pme_file.pme031,",
              "pme032.pme_file.pme032,",
              "pmk11.pmk_file.pmk11,",
              "gec02.gec_file.gec02,",
              "pmk22.pmk_file.pmk22,",
              "pmkud01.pmk_file.pmkud01,",      #20180813 add pmkud01 單頭備註
 
              "pml02.pml_file.pml02,",
              #M001 171120 By TSD.Nic -----(S)
              "ta_pml01.pml_file.ta_pml01,",
              #M001 171120 By TSD.Nic -----(E)
              "ta_pml02.pml_file.ta_pml02,",    #add by ruby 18/01/12 
              "ta_pml03.pml_file.ta_pml03,",    #add by ruby 17/12/15 增加主供應商
              "ta_pml05.pml_file.ta_pml05,",    #add by ruby 17/12/15 增加幣別
              "pml31.pml_file.pml31,",          #add by ruby 17/12/15 增加未稅單價
              "pml88t.pml_file.pml88t,",        #含稅價 20181222
              "pmc031.pmc_file.pmc03,",         #add by ruby 17/12/15 增加主供應商簡稱
              "pml12.pml_file.pml12,",          #add by ruby 18/03/01 增加專案代號
              "pml04.pml_file.pml04,",
              "pml07.pml_file.pml07,",
              "pml20.pml_file.pml20,",
              "pml18.pml_file.pml18,",
 
              "pml33.pml_file.pml33,",
              "pml34.pml_file.pml34,",
              "pml35.pml_file.pml35,",
              "pml15.pml_file.pml15,",
              "pml14.pml_file.pml14,",
 
              "pml041.pml_file.pml041,",
              "pml41.pml_file.pml41,",
              "pml80.pml_file.pml80,",
              "pml82.pml_file.pml82,",
              "pml83.pml_file.pml83,",
 
              "pml85.pml_file.pml85,",
              "pml86.pml_file.pml86,",
              "str2.type_file.chr1000,",
              "pmm04.pmm_file.pmm04,",
              "pmm01.pmm_file.pmm01,",
              "pmn02.pmn_file.pmn02,",   #No.TQC-740151
 
              "pmc03.pmc_file.pmc03,",
              "pmn20.pmn_file.pmn20,",
              "pmn07.pmn_file.pmn07,",
              "pmm22.pmm_file.pmm22,",
              "pmn31.pmn_file.pmn31,",
 
              "amt.pmm_file.pmm40,",
              "zo041.zo_file.zo041,",
              "zo042.zo_file.zo042,",
              "zo05.zo_file.zo05,",
              "zo09.zo_file.zo09,",
 
              "pmk21.pmk_file.pmk21,",
              "pme031a.pme_file.pme031,",
              "pme032a.pme_file.pme032,",
              "ima021.ima_file.ima021,",
              "azi03.azi_file.azi03,",
 
              "azi04.azi_file.azi04,",
              "gfe03.gfe_file.gfe03,",  #MOD-DC0123 add
              "sfb13.sfb_file.sfb13,",          #add by ruby 18/01/12
              "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #FUN-910012
              "sign_show.type_file.chr1,",                               #是否顯示簽核資料(Y/N)  #FUN-910012
              "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039

              #M003 171121 By TSD.Nic -----(S)
            ,",gen02.gen_file.gen02,",
              "atp_qty.type_file.num15_3,",
              "ima27.ima_file.ima27,",
              "occ02.occ_file.occ02,",
              #M003 171121 By TSD.Nic -----(E)
              "ima52.ima_file.ima52,",                #年平均     20180827 add
              "ima52_3.ima_file.ima52,",              #季平均     20180925 add
              "ima52_4.ima_file.ima52,",              #入庫季平均 20200527 add
              "ima46.ima_file.ima46"                  #最小採購量 20180925 add
 
   LET l_table = cl_prt_temptable('apmr903',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="pml02.pml_file.pml02,",   #MOD-860194
              "ima01.ima_file.ima01,",
              "x1_1.type_file.chr10,",
              "x1_2.type_file.chr10,",
              "x1_3.type_file.chr10,",
              "x1_4.type_file.chr10,",
              "x2_1.type_file.num20_6,",
              "x2_2.type_file.num20_6,",
              "x2_3.type_file.num20_6,",
              "x2_4.type_file.num20_6,",
              "x3_1.type_file.chr3,",
              "x3_2.type_file.chr3,",
              "x3_3.type_file.chr3,",
              "x3_4.type_file.chr3,",
              "azi03_1.azi_file.azi03,",
              "azi03_2.azi_file.azi03,",
              "azi03_3.azi_file.azi03,",
              "azi03_4.azi_file.azi03,",
              "i.type_file.num5"
 
   LET l_table1= cl_prt_temptable('apmr9031',g_sql) CLIPPED
   IF l_table1= -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="pmo01.pmo_file.pmo01,",
              "pmo03.pmo_file.pmo03,",
              "pmo04.pmo_file.pmo04,",
              "pmo05.pmo_file.pmo05,",    #CHI-7A0026 add
              "pmo06.pmo_file.pmo06"      #CHI-7A0026 add
 
   LET l_table2= cl_prt_temptable('apmr9032',g_sql) CLIPPED
   IF l_table2= -1 THEN EXIT PROGRAM END IF
   
   #No.FUN-E50074  --Begin
   LET g_sql="pmlc01.pmlc_file.pmlc01,   pmlc02.pmlc_file.pmlc02,",
             "pmlc04.pmlc_file.pmlc04,   pmlc04_name.agd_file.agd03,",
             "pmlc05.pmlc_file.pmlc05,   pmlc05_name.agd_file.agd03,",            
             "pmlc06.pmlc_file.pmlc06,   pmlc06_1.pmlc_file.pmlc06,",
             "pmlc06_2.pmlc_file.pmlc06, pmlc06_3.pmlc_file.pmlc06,",
             "pmlc06_4.pmlc_file.pmlc06, agd04_color.agd_file.agd04,",
             "agd04_size.agd_file.agd04"             
   LET l_table3 = cl_prt_temptable('apmr9033',g_sql) CLIPPED
   IF  l_table3 = -1 THEN EXIT PROGRAM END IF          
   #No.FUN-E50074  --End

   #---- 20180424 add (S)
   LET g_sql ="img01.img_file.img01,",
              "img10.img_file.img10,",
              "ima01_1.ima_file.ima01,",
              "ima01_2.ima_file.ima01,",
              "qtp_qty.img_file.img10,",   #20180605
              "pml02.pml_file.pml02 "      #20220725 item num
 
   LET l_table4= cl_prt_temptable('apmr9034',g_sql) CLIPPED
   IF l_table4= -1 THEN EXIT PROGRAM END IF
   #---- 20180424 add (E)
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r903_tm(0,0)        # Input print condition
   ELSE
      CALL apmr903()           # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r903_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680136 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r903_w AT p_row,p_col WITH FORM "cpm/42f/apmr903"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = 'N'
   LET tm.b    = 'N'
   LET tm.c    = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #No.FUN-E50074  --Begin
   IF s_industry("slk") AND g_sma.sma150 = 'Y' THEN
      LET tm.d   = 'Y'
      CALL cl_set_comp_visible("d",TRUE)
   ELSE
      LET tm.d   = 'N'
      CALL cl_set_comp_visible("d",FALSE)
   END IF
   #No.FUN-E50074  --End
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmk01,pmk04,pmk12,pmk13
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
        ON ACTION CONTROLP    #FUN-4B0043
         #CHI-C50001---S---
           CASE
             WHEN INFIELD(pmk12)
          #IF INFIELD(pmk12) THEN
         #CHI-C50001---E---
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmk12
              NEXT FIELD pmk12
          #END IF   #CHI-C50001 mark

        #CHI-C50001---S---
           WHEN INFIELD(pmk01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pmk3"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pmk01
                NEXT FIELD pmk01
        #FUN-F50037 add str------------
           WHEN INFIELD(pmk13)   #請購部門
                CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_pmc1"     #MOD-FA0154 mark
                LET g_qryparam.form = "q_gem"      #MOD-FA0154 add
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pmk13
                NEXT FIELD pmk13
        #FUN-F50037 add end------------
           OTHERWISE EXIT CASE
         END CASE
        #CHI-C50001---E---
 
     ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r903_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.d,tm.a,tm.b,tm.c,tm.more WITHOUT DEFAULTS           #FUN-E50074 add d
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
  #FUN-E50074----add--star---
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
            NEXT FIELD d
         END IF
 #FUN-E50074----add--end----
      AFTER FIELD a
         IF tm.a NOT MATCHES "[YN]" OR cl_null(tm.a) THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b
      AFTER FIELD c
         #TQC-BA0075--being
         IF NOT cl_null(tm.c) THEN
            IF tm.c<0 THEN
               CALL cl_err('','aec-020',1)
               NEXT FIELD c
            END IF
         END IF
         #TQC-BA0075--being
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r903_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmr903'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr903','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",                        
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'" ,
                         " '",tm.d CLIPPED,"'",        #FUN-E50074
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr903',g_time,l_cmd)
      END IF
      CLOSE WINDOW r903_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr903()
   ERROR ""
END WHILE
   CLOSE WINDOW r903_w
END FUNCTION
 
FUNCTION apmr903()
   DEFINE l_name    LIKE type_file.chr20,      # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,       # Used time for running the job   #No.FUN-680136 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,    # RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)
          l_smyslip LIKE smy_file.smyslip,
          l_za05    LIKE type_file.chr1000,    #No.FUN-680136 VARCHAR(40)
          sr               RECORD
                           pmk01     LIKE pmk_file.pmk01,
                           smydesc   LIKE smy_file.smydesc,
                           pmk04     LIKE pmk_file.pmk04,
                           pmk13     LIKE pmk_file.pmk13,
                           gem02     LIKE gem_file.gem02,
                           pmc081    LIKE pmc_file.pmc081,
                           pmc091    LIKE pmc_file.pmc091,
                           pma02     LIKE pma_file.pma02,
                           pmk41     LIKE pmk_file.pmk41,
                           pnz02     LIKE pnz_file.pnz02, #FUN-930113
                           pme031    LIKE pme_file.pme031,
                           pme032    LIKE pme_file.pme032,
                           pmk11     LIKE pmk_file.pmk11,
                           gec02     LIKE gec_file.gec02,
                           pmk22     LIKE pmk_file.pmk22,
                           pmkud01   LIKE pmk_file.pmkud01, #20180813 add
                           pml02     LIKE pml_file.pml02,
                           #M001 171120 By TSD.Nic -----(S)
                           ta_pml01  LIKE pml_file.ta_pml01,
                           #M001 171120 By TSD.Nic -----(E)
                           ta_pml02  LIKE pml_file.ta_pml02,      #add by ruby 18/01/12
                           ta_pml03  LIKE pml_file.ta_pml03,      #add by ruby 17/12/15 增加主供應商
                           ta_pml05  LIKE pml_file.ta_pml05,      #add by ruby 17/12/15 增加幣別
                           pml31     LIKE pml_file.pml31,         #add by ruby 17/12/15 增加未稅單價
                           pml88t    LIKE pml_file.pml88t,        #增加含稅價 20181222
                           pmc031    LIKE pmc_file.pmc03,         #add by ruby 17/12/15 增加主供應商簡稱
                           pml12     LIKE pml_file.pml12,         #add by ruby 18/03/01 增加專案代號
                           pml04     LIKE pml_file.pml04,
                           pml07     LIKE pml_file.pml07,
                           pml20     LIKE pml_file.pml20,
                           pml18     LIKE pml_file.pml18,
                           pml33     LIKE pml_file.pml33,
                           pml34     LIKE pml_file.pml34,
                           pml35     LIKE pml_file.pml35,  #No.TQC-6640132
                           pml15     LIKE pml_file.pml15,
                           pml14     LIKE pml_file.pml14,
                           pml041    LIKE pml_file.pml041,
                           pml41     LIKE pml_file.pml41,
                           pml80     LIKE pml_file.pml80,
                           pml82     LIKE pml_file.pml82,
                           pml83     LIKE pml_file.pml83,
                           pml85     LIKE pml_file.pml85,
                           pml86     LIKE pml_file.pml86
                        END RECORD
DEFINE  sr1          RECORD
                     pmm04     LIKE pmm_file.pmm04,
                     pmm01     LIKE pmm_file.pmm01,
                     pmn02     LIKE pmn_file.pmn02,             #No.TQC-740151
                     pmc03     LIKE pmc_file.pmc03,
                     pmn20     LIKE pmn_file.pmn20,
                     pmn07     LIKE pmn_file.pmn07,
                     pmm22     LIKE pmm_file.pmm22,
                     pmn31     LIKE pmn_file.pmn31,
                     amt       LIKE pmm_file.pmm40
                     END RECORD
   DEFINE a                LIKE aba_file.aba00          	#No.FUN-680136 VARCHAR(5)
   DEFINE x1         ARRAY[10] OF LIKE type_file.chr10   	#No.FUN-680136 VARCHAR(10)#No.TQC-6A0079
   DEFINE x2         ARRAY[10] OF LIKE type_file.num20_6        #No.FUN-680136 DECIMAL(20,6)
   DEFINE x3         ARRAY[10] OF LIKE type_file.chr3     	#No.FUN-680136 VARCHAR(3)
   DEFINE x4         ARRAY[10] OF LIKE type_file.num20_6        #No.FUN-680136 DECIMAL(20,6)
   DEFINE l_azi03    ARRAY[10] OF LIKE type_file.num5   	#No.FUN-680136 SMALLINT
   DEFINE l_str1           LIKE type_file.chr1000              #No.TQC-610127
   DEFINE l_str2           LIKE type_file.chr1000              #No.TQC-610127
   DEFINE l_ima906         LIKE ima_file.ima906                 #No.TQC-610127
   DEFINE l_ima021         LIKE ima_file.ima021                 #MOD-640056
DEFINE  l_pml20      LIKE pml_file.pml20,
        l_pml85      LIKE pml_file.pml85,
        l_pml82      LIKE pml_file.pml82,
        l_pmo06      LIKE pmo_file.pmo06,
        l_pme031     LIKE pme_file.pme031,
        l_pme032     LIKE pme_file.pme032,
        l_flag       LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)
        l_totamt     LIKE tlf_file.tlf18 	#No.FUN-680136 DECIMAL(13,3)
DEFINE  l_pmk21      LIKE pmk_file.pmk21       
DEFINE  l_pmh01      LIKE pmh_file.pmh01       
DEFINE  l_pmo05      LIKE pmo_file.pmo05        #CHI-7A0026 add
DEFINE  l_pmk09      LIKE pmk_file.pmk09        #MOD-860194
DEFINE l_img_blob     LIKE type_file.blob
DEFINE  l_pml123     LIKE pml_file.pml123       #FUN-D10004 add
DEFINE  l_gfe03      LIKE gfe_file.gfe03        #MOD-DC0123 add
#M003 171121 By TSD.Nic -----(S)
DEFINE  l_ta_pml06   LIKE pml_file.ta_pml06
DEFINE  l_gen02      LIKE gen_file.gen02
DEFINE  l_atp_qty    LIKE type_file.num15_3
DEFINE  l_ima27      LIKE ima_file.ima27
DEFINE  l_occ02      LIKE occ_file.occ02
#M003 171121 By TSD.Nic -----(E)
DEFINE l_gen02_pmk12 LIKE gen_file.gen02        #20220210 請購人

#TQC-C10039--mark--str--
#DEFINE l_ii           INTEGER
#DEFINE l_key          RECORD                  #主鍵
#          v1          LIKE pmk_file.pmk01
#          END RECORD
#TQC-C10039--mark--end--
   #No.FUN-E50074  --Begin
   DEFINE     l_pmlc04       LIKE pmlc_file.pmlc04,
              l_pmlc04_name  LIKE agd_file.agd03,    #顏色
              l_pmlc05       LIKE pmlc_file.pmlc05,
              l_pmlc05_name  LIKE agd_file.agd03,    #尺寸
              l_pmlc06       LIKE pmlc_file.pmlc06,
              l_pmlc06_1     LIKE pmlc_file.pmlc06,  #數量(1~10)
              l_pmlc06_2     LIKE pmlc_file.pmlc06,  #數量(11~20)
              l_pmlc06_3     LIKE pmlc_file.pmlc06,  #數量(21~30)
              l_pmlc06_4     LIKE pmlc_file.pmlc06   #數量(31~40)
   DEFINE l_flag1        LIKE type_file.chr1     #是否顯示款別明細
   DEFINE l_next         LIKE type_file.num5     #目前分組到哪一筆
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_agd04_color  LIKE agd_file.agd04     #順序-顏色
   DEFINE l_agd04_size   LIKE agd_file.agd04     #順序-尺寸
   #No.FUN-E50074  --End
   #M003 171121 By TSD.Nic -----(S)
   DEFINE lr_sfa         RECORD LIKE sfa_file.*
   DEFINE l_oea01        LIKE oea_file.oea01
   DEFINE l_n1           LIKE type_file.num15_3
   DEFINE l_n2           LIKE type_file.num15_3
   DEFINE l_n3           LIKE type_file.num15_3
   DEFINE l_avl_stk      LIKE type_file.num15_3
   DEFINE l_oeb_q        LIKE type_file.num15_3
   DEFINE l_sfa_q1       LIKE type_file.num15_3
   DEFINE l_sfa_q1_2     LIKE type_file.num15_3
   DEFINE l_misc_q1      LIKE type_file.num15_3 #雜發
   DEFINE l_pml_q        LIKE type_file.num15_3
   DEFINE l_pmn_q        LIKE type_file.num15_3
   DEFINE l_rvb_q        LIKE type_file.num15_3
   DEFINE l_sfb_q1       LIKE type_file.num15_3
   DEFINE l_sfb_q2       LIKE type_file.num15_3
   DEFINE l_rvb_q2       LIKE type_file.num15_3
   DEFINE l_qcf_q        LIKE type_file.num15_3
   DEFINE l_shb114       LIKE shb_file.shb114
   DEFINE l_short_qty    LIKE sfa_file.sfa07
   DEFINE l_sfb13        LIKE sfb_file.sfb13
   #M003 171121 By TSD.Nic -----(E)
   DEFINE l_ima44_fac    LIKE ima_file.ima44_fac #採購庫存單位換算率 20180403 add 
   ##---- 20180424 add (S)----
   DEFINE  sr4          RECORD
                     img01     LIKE img_file.img01, #版本料號
                     img10     LIKE img_file.img10, #版本庫存
                     ima01     LIKE ima_file.ima01, #最終版本料號   
                     atp_qty   LIKE img_file.img10  #預計可用量
                     END RECORD
   ##---- 20180424 add (E)----
   DEFINE l_ima52        LIKE ima_file.ima52        #年平均用量 20180827
   DEFINE l_ima52_3      LIKE ima_file.ima52        #季平均用量 20180925
   DEFINE l_ima52_4      LIKE ima_file.ima52        #入庫季平均用量 20200527
   DEFINE l_ima46        LIKE ima_file.ima46        #最小採購量 20180925
   DEFINE l_pmk01        LIKE pmk_file.pmk01        #列印請購單號 20180910 add
   DEFINE l_bom          LIKE type_file.chr1        #是否存在BOM  20180928
   DEFINE l_pmcud06      LIKE pmc_file.pmcud06      #排除主要供應商 20190912
   DEFINE fast_ima01     LIKE ima_file.ima01        #第一版料號 20191209
   
   LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039 
   CALL cl_del_data(l_table) 
   CALL cl_del_data(l_table1) 
   CALL cl_del_data(l_table2)   #FUN-740214 add 
   CALL cl_del_data(l_table3)       #FUN-E50074
   CALL cl_del_data(l_table4)   #20180424
   LOCATE l_img_blob IN MEMORY  #FUN-A50041
   
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               #M001 171120 By TSD.Nic -----(S)
               #"        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?) "  #No.TQC-740151 add ?  #FUN-910012 加3個 #TQC-C10039 ADD 1? #MOD-DC0123 add ,?
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?) " #M003 171121 By TSD.Nic add 4?       #add by ruby 17/12/15 4? #add by ruby 2? 2018/01/12 #add by ruby 1? 2018/03/01 #20180813 add 1? #20180827 add 1? #20180925 add 2? #20181222 add 1? #20200527 add 1?
               #M001 171120 By TSD.Nic -----(E)
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
   #LET g_sql = "INSERT INTO ds_report.",l_table1 CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  #TQC-A50009 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?)"   #MOD-860194
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
   #LET g_sql = "INSERT INTO ds_report.",l_table2 CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,  #TQC-A50009 mod
               " VALUES(?,?,?,?,?)"        #CHI-7A0026 mod
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep2:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
   #No.FUN-E50074  --Begin
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep3:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF 
   #No.FUN-E50074  --End 

   ##----- 20180424 add (S)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
               " VALUES(?,?,?,?,?, ?)"                                 #20220725 add 1?
   PREPARE insert_prep4 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep4:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   ##----- 20180424 add (E)
   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #No.TQC-610127 add
   SELECT * INTO g_zo.* FROM zo_file WHERE zo01= g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr903'
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')
 
   LET l_sql = "SELECT pmk01,'',pmk04,pmk13,gem02,pmc081,",
               "       pmc091,pma02,pmk41,pnz02,pme031,pme032,pmk11,gec02,", #FUN-930113
               #M001 171120 By TSD.Nic -----(S)
               #"       pmk22,pml02,pml04,pml07,pml20,pml18,pml33,pml34,pml35,",  #No.TQC-640132
               "        pmk22,pmkud01,pml02,",                                                       #20180813 add pmkud01
               "       ta_pml01,ta_pml02,ta_pml03,ta_pml05,pml31,pml20*pml31t,pmc03,pml12,pml04,pml07,pml20,pml18,pml33,pml34,pml35,",      #add by ruby 增加主供應商/幣別/未稅單價/主供應商簡稱  #add by ruby ta_pml02 2018/01/12 #add by ruby pml12 2018/03/01 #20181222 add pml88t
               #M001 171120 By TSD.Nic -----(E)
               "       pml15,pml14,pml041,pml41",   
              #"       ,pml80,pml82,pml83,pml85,pml86,pmk21",    #No.TQC-610127 add  #No.FUN-710082   #FUN-D10004 mark
               "       ,pml80,pml82,pml83,pml85,pml86,pmk21,pml123",                                  #FUN-D10004 add
               #M003 171121 By TSD.Nic -----(S)
               "       ,ta_pml06,0,0,0,0 ",                             #20180827 add 0 #20180925 add 0,0  #20200527 add 0
               #M003 171121 By TSD.Nic -----(E)
        " FROM pmk_file LEFT OUTER JOIN pml_file ON pmk01 = pml01 ",
	" LEFT OUTER JOIN pmc_file ON pmc01 = ta_pml03 ",         #mark by ruby pmk09改ta_pml03
	" LEFT OUTER JOIN pme_file ON pme01 = pmk10 ",
	" LEFT OUTER JOIN pma_file ON pma01 = pmk20 ",
	" LEFT OUTER JOIN gec_file ON gec01 = pmk21 AND gec011='1' ",
	" LEFT OUTER JOIN gem_file ON gem01 = pmk13 ",
	" LEFT OUTER JOIN oah_file ON oah01 = pmk41 ",
        " LEFT OUTER JOIN pnz_file ON pnz01 = pmk41 ",                          #TQC-9A0187 Add
	" WHERE pmkacti='Y' AND ",tm.wc
   LET l_sql = l_sql CLIPPED," ORDER BY pmk01,pml02"   #No.FUN-710082  
   display "l_sql:",l_sql CLIPPED
 
   PREPARE r903_prepare FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
   END IF
   DECLARE r903_cs CURSOR FOR r903_prepare

  #FUN-E50074 add--------------------------------------------------------------
  #抓取尺寸總共有幾個
   LET g_sql="SELECT DISTINCT(pmlc05)",  
             "  FROM pmlc_file",
             " WHERE pmlc01=? AND pmlc02=? ",
             " ORDER BY pmlc05" 
   PREPARE r903_pmlc_pr FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare r903_pmlc_pr:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r903_pmlc_cs CURSOR FOR r903_pmlc_pr


   #抓取該尺寸的顏色總共有幾個
   LET g_sql="SELECT pmlc04,pmlc06",
             "  FROM pmlc_file",
             " WHERE pmlc01=? AND pmlc02=? AND pmlc05=? ",
             "   AND pmlc06 <> '0'",
             " ORDER BY pmlc04,pmlc05"
   PREPARE r903_pmlc_pr1 FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare r903_pmlc_pr1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r903_pmlc_cs1 CURSOR FOR r903_pmlc_pr1
   #FUN-E50074 add end----------------------------------------------------------      
##TQC-C10039--mark--str--      
#  #單據key值
#  LET l_sql = "SELECT pmk01",
#       " FROM pmk_file LEFT OUTER JOIN pml_file ON pmk01 = pml01 ",
#       " LEFT OUTER JOIN pmc_file ON pmc01 = pmk09 ",
#       " LEFT OUTER JOIN pme_file ON pme01 = pmk10 ",
#       " LEFT OUTER JOIN pma_file ON pma01 = pmk20 ",
#       " LEFT OUTER JOIN gec_file ON gec01 = pmk21 AND gec011='1' ",
#       " LEFT OUTER JOIN gem_file ON gem01 = pmk13 ",
#       " LEFT OUTER JOIN oah_file ON oah01 = pmk41 ",
#       " LEFT OUTER JOIN pnz_file ON pnz01 = pmk41 ",                          #TQC-9A0187 Add
#       " WHERE pmkacti='Y' AND ",tm.wc
#  LET l_sql = l_sql CLIPPED," GROUP BY pmk01"
#
#  PREPARE r903_pr3 FROM l_sql
#  IF SQLCA.sqlcode THEN
#     CALL cl_err('prepare r903_pr3:',SQLCA.sqlcode,0)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time
#     EXIT PROGRAM
#  END IF
#  DECLARE r903_cs3 CURSOR FOR r903_pr3
 ##TQC-C10039--mark--end
  #FOREACH r903_cs INTO sr.*,l_pmk21            #FUN-D10004 mark 
   #M003 171121 By TSD.Nic -----(S)
   #FOREACH r903_cs INTO sr.*,l_pmk21,l_pml123   #FUN-D10004 add
   FOREACH r903_cs INTO sr.*,l_pmk21,l_pml123,l_ta_pml06
   #M003 171121 By TSD.Nic -----(E)
      IF SQLCA.sqlcode != 0 THEN 
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF

      ##--20190912 C級供應商 (S)
      LET l_pmcud06=''
      SELECT pmcud06 INTO l_pmcud06 FROM pmc_file
       WHERE pmc01=sr.ta_pml03
      IF NOT cl_null(l_pmcud06) THEN
         LET sr.ta_pml03 = l_pmcud06 || '-' || sr.ta_pml03
      END IF
      ##--20190912 C級供應商 (E)
 
      LET l_smyslip = s_get_doc_no(sr.pmk01)     #No.FUN-550060
      SELECT smydesc INTO sr.smydesc FROM smy_file
       WHERE smyslip=l_smyslip
 
      SELECT pme031,pme032 INTO l_pme031,l_pme032 FROM pme_file
                                                 WHERE pme01=sr.pmk11
      IF SQLCA.SQLCODE THEN LET l_pme031='' LET l_pme032='' END IF

     ##---- 20180424 add (S)

     #最終料號
     IF g_sma.sma119 = '0' THEN         #20211102 add
        LET fast_ima01 = sr.pml04[1,12] #20191209
     ELSE
        LET fast_ima01 = ' '
     END IF                             #20211102 add

     DECLARE img_cur41 CURSOR FOR
      SELECT img01,SUM(img10) FROM img_file
       #WHERE img01 LIKE SUBSTR(sr.pml04,1,12)||'%' #20191209 mark
        WHERE img01 LIKE fast_ima01||'%'             #20191209 modify
         AND img23='Y'
         AND img10 > 0
      GROUP BY img01

      FOREACH img_cur41 INTO sr4.img01,sr4.img10
         SELECT MAX(ima01) INTO sr4.ima01 FROM ima_file
          #WHERE ima01 LIKE SUBSTR(sr.pml04,1,12)||'%' #20191209 mark
           WHERE ima01 LIKE fast_ima01||'%'            #20191209 modify
            AND imaacti='Y'

         #---20180605 增加預設可用量 (S)
         #GET atp_qty
      LET l_oeb_q = 0
      LET l_sfa_q1 = 0
      LET l_pml_q = 0
      LET l_pmn_q = 0
      LET l_rvb_q = 0
      LET l_sfb_q1 = 0
      LET l_sfb_q2 = 0
      LET l_qcf_q = 0
      LET l_misc_q1 = 0

      CALL s_getstock(sr4.img01,g_plant) RETURNING  l_n1,l_n2,l_n3
      LET l_avl_stk = l_n3

      SELECT SUM((oeb12-oeb24+oeb25-oeb26)*oeb05_fac) INTO l_oeb_q
        FROM oeb_file, oea_file
       WHERE oeb01 = oea01 AND oea00<>'0'
         AND oeb70 = 'N'
         AND oeaconf = 'Y'
         AND oeb12-oeb24+oeb25-oeb26>0
         AND oeb04 = sr4.img01

      SELECT SUM(inb09) INTO l_misc_q1
        FROM ina_file,inb_file
       WHERE ina01=inb01 AND inaconf = 'Y'
         AND inapost = 'N' AND ina00='1'
         AND inb04 = sr4.img01

      LET l_sql = "SELECT sfa_file.*",
                  "  FROM sfa_file,sfb_file",
                  " WHERE sfa03 = '",sr4.img01,"'",
                  "   AND sfb01 = sfa01",
                  "   AND sfb04 <='7'",
                  "   AND sfb87!='X'",
                  "   AND sfb02 != '15'"
      PREPARE r903_sum_pre FROM l_sql
      DECLARE r903_sum CURSOR FOR r903_sum_pre
      FOREACH r903_sum INTO lr_sfa.*
         IF SQLCA.sqlcode THEN END IF
         CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                         lr_sfa.sfa12,lr_sfa.sfa27,
                         lr_sfa.sfa012,lr_sfa.sfa013)
              RETURNING l_short_qty
         IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF
         IF (lr_sfa.sfa05 > (lr_sfa.sfa06 + lr_sfa.sfa065 - lr_sfa.sfa063 ) OR l_short_qty > 0) THEN
              LET l_sfa_q1_2 =(lr_sfa.sfa05 - lr_sfa.sfa06 - lr_sfa.sfa065 +    lr_sfa.sfa063 - lr_sfa.sfa062 ) * lr_sfa.sfa13
              IF l_sfa_q1_2 < 0 THEN
                  LET l_sfa_q1_2 = 0
              END IF
              LET l_sfa_q1= l_sfa_q1 + l_sfa_q1_2
         END IF
      END FOREACH

      SELECT SUM((pml20-pml21)*pml09) INTO l_pml_q
        FROM pml_file, pmk_file
       WHERE pml01 = pmk01
         AND pml20 > pml21
         AND ( pml16 <='2' OR pml16='S' OR pml16='R' OR pml16='W')
         AND pml011 !='SUB'
         AND pmk18 != 'X'
         AND pml20 > pml21
         AND pml04 = sr4.img01

      SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) INTO l_pmn_q
        FROM pmn_file, pmm_file
       WHERE pmn01 = pmm01
         AND pmn20 > pmn50-pmn55-pmn58
         AND ( pmn16 <='2' OR pmn16='S' OR pmn16='R' OR pmn16='W')
         AND pmn011 !='SUB'
         AND pmm18 != 'X'
         AND pmn04 = sr4.img01

      SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO l_rvb_q
        FROM rvb_file, rva_file, pmn_file
       WHERE rvb01=rva01
         AND rvb04 = pmn01 AND rvb03 = pmn02
         AND rvb07 > (rvb29+rvb30)
         AND rvaconf='Y'
         AND rva10 != 'SUB'
         AND rvb05 = sr4.img01

      SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)
        INTO l_sfb_q1
        FROM ima_file,sfb_file
       WHERE sfb05=ima01 AND sfb04 <='7'
         AND ( sfb02 !='7' AND sfb02 !='8' AND sfb02 !='11' AND sfb02 != '15' )
         AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X'
         AND sfb05 = sr4.img01

      LET l_shb114 = 0
      SELECT SUM(shb114) INTO l_shb114
        FROM shb_file,sfb_file
       WHERE shb05 = sfb01
         AND shb10 = sfb05
         AND sfb87 != 'X'
         AND ( sfb02 !='7' AND sfb02 !='8' AND sfb02 !='11' AND sfb02 != '15' )
         AND sfb04 <= '7'
         AND shb10 = sr4.img01

      IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
      LET l_sfb_q1 = l_sfb_q1 - l_shb114

      SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)
        INTO l_sfb_q2
        FROM ima_file,sfb_file
       WHERE sfb05=ima01
         AND (sfb02='7' OR sfb02='8')
         AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X'
         AND sfb04 <= '7'
         AND sfb05 = sr4.img01

      IF cl_null(l_sfb_q2) THEN LET l_sfb_q2=0 END IF
      LET l_shb114 = 0
      SELECT SUM(shb114) INTO l_shb114
        FROM shb_file,sfb_file
       WHERE shb05 = sfb01
         AND shb10 = sfb05
         AND sfb87 != 'X'
         AND ( sfb02 ='7' AND sfb02 ='8')
         AND sfb04 <= '7'
         AND shb10 = sr4.img01
      IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
      LET l_sfb_q2 = l_sfb_q2 - l_shb114

      SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO l_rvb_q2
        FROM rvb_file, rva_file, pmn_file
       WHERE rvb01=rva01
         AND rvb04 = pmn01 AND rvb03 = pmn02
         AND rvb07 > (rvb29+rvb30)
         AND rvaconf='Y'
         AND rva10 ='SUB'
         AND pmn43 = 0
         AND rvb05 = sr4.img01

      IF cl_null(l_rvb_q2) THEN LET l_rvb_q2=0 END IF

      LET l_sfb_q2 = l_sfb_q2 + l_rvb_q2

      SELECT SUM(sfb11*ima55_fac) INTO l_qcf_q
        FROM ima_file,sfb_file
       WHERE sfb05=ima01 
         AND sfb02 <> '7' AND sfb87!='X'
         AND sfb02 <> '8'
         AND sfb02 <> '11'
         AND sfb04 <= '7'
         AND sfb05 = sr4.img01
      IF SQLCA.sqlcode OR STATUS THEN LET l_qcf_q = 0 END IF

      IF cl_null(l_oeb_q)  THEN LET l_oeb_q = 0  END IF
      IF cl_null(l_misc_q1)  THEN LET l_misc_q1 = 0  END IF
      IF cl_null(l_sfa_q1) THEN LET l_sfa_q1 = 0 END IF
      IF cl_null(l_pml_q)  THEN LET l_pml_q = 0  END IF
      IF cl_null(l_pmn_q)  THEN LET l_pmn_q = 0  END IF
      IF cl_null(l_rvb_q)  THEN LET l_rvb_q = 0  END IF
      IF cl_null(l_sfb_q1) THEN LET l_sfb_q1 = 0 END IF
      IF cl_null(l_sfb_q2) THEN LET l_sfb_q2 = 0 END IF
      IF cl_null(l_qcf_q)  THEN LET l_qcf_q = 0  END IF
      LET l_atp_qty = l_avl_stk - l_oeb_q - l_sfa_q1 - l_misc_q1
                                + l_pml_q + l_pmn_q + l_rvb_q
                                + l_sfb_q1+ l_sfb_q2+ l_qcf_q
      LET sr4.atp_qty=l_atp_qty
         #---20180605 增加預設可用量 (E)

      ##=== 20180928 add by momo (S) 是否存在BOM
      IF sr4.img01 <> sr4.ima01 THEN
        SELECT COUNT(*) INTO l_cnt
           FROM bmb_file,bma_file
          WHERE bma01=bmb01
            AND bmb05 IS NULL AND bmaacti='Y'
            AND bma05 IS NOT NULL
            AND bmb03 = sr4.img01
         IF l_cnt > 0 THEN
            LET sr4.img01 = '*'||sr4.img01
         END IF
      END IF
      ##=== 20180928 add by momo (E)

         EXECUTE insert_prep4 USING sr4.img01,sr4.img10,sr4.ima01,sr.pml04,sr4.atp_qty,
                                    sr.pml02                                              #20220725 
      END FOREACH

   ##---- 20180424 add (E)
 
     #特別說明維護(項次前)
      LET l_pmo05=''
      LET l_pmo06=''
      DECLARE pmo_cur2 CURSOR FOR
         SELECT pmo05,pmo06 FROM pmo_file
          WHERE pmo01=sr.pmk01 AND pmo03=sr.pml02 AND pmo04='0'
          ORDER BY pmo05
      FOREACH pmo_cur2 INTO l_pmo05,l_pmo06
         EXECUTE insert_prep2 USING sr.pmk01,sr.pml02,'0',l_pmo05,l_pmo06
      END FOREACH
      #No.FUN-E50074  --Begin
      IF tm.d = 'Y' THEN
         LET l_flag1='N'
         LET l_cnt = 0
         #判斷是否存在顏色相關資料記錄
         SELECT COUNT(*) INTO l_cnt FROM agd_file
         WHERE agd02 IN (SELECT pmlc04 FROM pmlc_file WHERE pmlc01 = sr.pmk01 AND pmlc02 =sr.pml02)
           AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr.pml04)      
         IF l_cnt>0 THEN
            LET l_flag1='Y'
         ELSE
            #判斷是否存在尺寸相關資料記錄
            SELECT COUNT(*) INTO l_cnt FROM agd_file
            WHERE agd02 IN (SELECT pmlc05 FROM pmlc_file WHERE pmlc01 = sr.pmk01 AND pmlc02 =sr.pml02)
              AND agd01=(SELECT ima941 FROM ima_file WHERE ima01=sr.pml04)
            IF l_cnt>0 THEN
               LET l_flag1='Y'
            END IF
         END IF
         IF l_flag1='Y' THEN
            #抓取顏色尺寸資料
            LET l_next = 1 
            FOREACH r903_pmlc_cs USING sr.pmk01,sr.pml02 INTO l_pmlc05
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach r903_pmlc_cs:',SQLCA.sqlcode,1) EXIT FOREACH
               END IF
               LET l_pmlc05_name = ''
               LET l_agd04_size = ''
               #尺寸的名稱  
               SELECT agd03,agd04 INTO l_pmlc05_name,l_agd04_size FROM agd_file
                WHERE agd02=l_pmlc05
                  AND agd01=(SELECT ima941 FROM ima_file WHERE ima01=sr.pml04)
               LET l_pmlc06=''
               CASE
                  WHEN (l_next <= 10)  #1~10
                     #跑每一個顏色
                     FOREACH r903_pmlc_cs1 USING sr.pmk01,sr.pml02,l_pmlc05
                                      INTO l_pmlc04,l_pmlc06
                        LET l_pmlc06_1=''
                        LET l_pmlc06_2=''              
                        LET l_pmlc06_3=''
                        LET l_pmlc06_4=''
                        LET l_pmlc06_1=l_pmlc06
                        LET l_pmlc04_name=''
                        LET l_agd04_color=''
                        SELECT agd03,agd04 INTO l_pmlc04_name,l_agd04_color FROM agd_file
                         WHERE agd02=l_pmlc04
                           AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr.pml04)
                        EXECUTE insert_prep3 USING sr.pmk01,sr.pml02,
                                                   l_pmlc04,l_pmlc04_name,l_pmlc05,
                                                   l_pmlc05_name,l_pmlc06,l_pmlc06_1,
                                                   l_pmlc06_2,l_pmlc06_3,l_pmlc06_4,
                                                   l_agd04_color,l_agd04_size
                     END FOREACH
                  WHEN (l_next > 10 AND l_next <= 20) #11~20
                     #跑每一個顏色
                     FOREACH r903_pmlc_cs1 USING sr.pmk01,sr.pml02,l_pmlc05
                                      INTO l_pmlc04,l_pmlc06
                        LET l_pmlc06_1=''
                        LET l_pmlc06_2=l_pmlc06
                        SELECT agd03,agd04 INTO l_pmlc04_name,l_agd04_color FROM agd_file
                         WHERE agd02=l_pmlc04
                           AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr.pml04)
                        EXECUTE insert_prep3 USING sr.pmk01,sr.pml02,
                                                   l_pmlc04,l_pmlc04_name,l_pmlc05,
                                                   l_pmlc05_name,l_pmlc06,l_pmlc06_1,
                                                   l_pmlc06_2,l_pmlc06_3,l_pmlc06_4,
                                                   l_agd04_color,l_agd04_size
                     END FOREACH
                  WHEN (l_next > 20 AND l_next <= 30) #21~30
                     #跑每一個顏色
                     FOREACH r903_pmlc_cs1 USING sr.pmk01,sr.pml02,l_pmlc05
                                      INTO l_pmlc04,l_pmlc06
                        LET l_pmlc06_2=''
                        LET l_pmlc06_3=l_pmlc06
                        SELECT agd03,agd04 INTO l_pmlc04_name,l_agd04_color FROM agd_file
                         WHERE agd02=l_pmlc04
                           AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr.pml04)
                        EXECUTE insert_prep3 USING sr.pmk01,sr.pml02,
                                                   l_pmlc04,l_pmlc04_name,l_pmlc05,
                                                   l_pmlc05_name,l_pmlc06,l_pmlc06_1,
                                                   l_pmlc06_2,l_pmlc06_3,l_pmlc06_4,
                                                   l_agd04_color,l_agd04_size
                     END FOREACH
                  WHEN (l_next > 30) #30以上
                     #跑每一個顏色
                     FOREACH r903_pmlc_cs1 USING sr.pmk01,sr.pml02,l_pmlc05
                                      INTO l_pmlc04,l_pmlc06
                        LET l_pmlc06_3=''
                        LET l_pmlc06_4=l_pmlc06
                        SELECT agd03,agd04 INTO l_pmlc04_name,l_agd04_color FROM agd_file
                         WHERE agd02=l_pmlc04
                           AND agd01=(SELECT ima940 FROM ima_file WHERE ima01=sr.pml04)
                        EXECUTE insert_prep3 USING sr.pmk01,sr.pml02,
                                                   l_pmlc04,l_pmlc04_name,l_pmlc05,
                                                   l_pmlc05_name,l_pmlc06,l_pmlc06_1,
                                                   l_pmlc06_2,l_pmlc06_3,l_pmlc06_4,
                                                   l_agd04_color,l_agd04_size
                     END FOREACH
               END CASE
               IF NOT cl_null(l_pmlc06) THEN
                  LET l_next = l_next+1
               END IF
            END FOREACH  
         END IF 
      END IF
      #No.FUN-E50074  --End 
     #特別說明維護(項次後)
      LET l_pmo05=''
      LET l_pmo06=''
      DECLARE pmo_cur3 CURSOR FOR
       #SELECT pmo05,pmo06 FROM pmo_file                         #20230810 mark
       # WHERE pmo01=sr.pmk01 AND pmo03=sr.pml02 AND pmo04='1'   #20230810 mark
       #UNION                                  #20230810 add
       SELECT imc03,imc04 FROM imc_file        #20230810 add
        WHERE imc02='PR01'                     #20230810 add
          AND imc01 = sr.pml04                 #20230810 add
        ORDER BY 1
      FOREACH pmo_cur3 INTO l_pmo05,l_pmo06
         EXECUTE insert_prep2 USING sr.pmk01,sr.pml02,'1',l_pmo05,l_pmo06
      END FOREACH
 
      SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=sr.pml04
      LET l_str2 = ""
      LET l_str1 = ""
 
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
               CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
               LET l_str1 = l_pml85
               LET l_str2 = l_str1 CLIPPED,sr.pml83 CLIPPED
               IF cl_null(sr.pml85) OR sr.pml85 = 0 THEN
                  CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
                  LET l_str1 = l_pml82
                  LET l_str2 = l_str1 CLIPPED, sr.pml80 CLIPPED
               ELSE
                  IF NOT cl_null(sr.pml82) AND sr.pml82 > 0 THEN
                     CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
                     LET l_str1 = l_pml82
                     LET l_str2 = l_str2 CLIPPED,',',l_str1 CLIPPED,
                                  sr.pml80 CLIPPED
                  END IF
               END IF
            WHEN "3"
               IF NOT cl_null(sr.pml85) AND sr.pml85 > 0 THEN
                  CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
                  LET l_str1 = l_pml85
                  LET l_str2 = l_str1 CLIPPED,sr.pml83 CLIPPED
               END IF
         END CASE
      END IF
      IF g_sma.sma116 MATCHES '[13]' THEN  #TQC-6B0137 mod
         IF sr.pml07 <> sr.pml86 THEN      #TQC-6B0137 mod
            CALL cl_remove_zero(sr.pml20) RETURNING l_pml20
            LET l_str1 = l_pml20
            LET l_str2 = l_str2 CLIPPED,"(",l_str1 CLIPPED,
                         sr.pml07 CLIPPED,")"
         END IF
      END IF

      SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=sr.pml07   #MOD-DC0123 add
 
      LET l_ima021 = ""                                              #MOD-640056
      SELECT ima021 INTO l_ima021 FROM ima_file where ima01=sr.pml04 #MOD-640056 
      IF sr.pml04[1,1] MATCHES '[ABCD]' THEN                             #20180508
         SELECT ima02 INTO l_ima021 FROM ima_file                        #20180508
          WHERE ima01=sr.pml04 AND ima02 <> sr.pml041                    #20180508                              
      END IF                                                             #20180508
      LET l_pmk09 = ''    #MOD-860194
      SELECT pmk09 INTO l_pmk09 FROM pmk_file WHERE pmk01 = sr.pmk01   #MOD-860194
 
      IF cl_null(l_pml123) THEN LET l_pml123 = ' ' END IF            #FUN-D10004 add
      DECLARE pmh_cur CURSOR FOR
         #SELECT pmh01,pmc03,pmh12,pmh13,pmh12*pmh14 as aaa FROM pmh_file, pmc_file #MOD-580143 add pmh12*pmh14 as aaa     #FUN-A40073 mark
         SELECT pmh01,pmc03,pmh12,pmh13,pmh12*pmh14 as aaa FROM pmh_file LEFT OUTER JOIN pmc_file ON pmh02=pmc_file.pmc01  #FUN-A40073 mod 
          WHERE pmh01 = sr.pml04     # AND pmh02=pmc_file.pmc01  #FUN-A40073 mark
            AND pmh02 = l_pmk09      #MOD-860194
            AND pmh07 = l_pml123     #FUN-D10004 add
            AND pmh21 = ' '                                             #CHI-860042                                                 
            AND pmh22 = '1'                                             #CHI-860042
            AND pmh23 = ' '                                             #No.CHI-960033
            AND pmhacti = 'Y'                                           #CHI-910021
          ORDER BY pmh05 ASC,pmh06 DESC,aaa ASC #MOD-580143
      FOR g_cnt=1 TO 10
         LET x1[g_cnt]='' 
         LET x2[g_cnt]='' 
         LET x3[g_cnt]=''
         LET x4[g_cnt]=NULL #MOD-580143
      END FOR
      LET g_cnt=1
      LET i=1
      FOREACH pmh_cur INTO l_pmh01,x1[g_cnt],x2[g_cnt],x3[g_cnt],x4[g_cnt] #MOD-580143 add x4[g_cnt]
         IF STATUS THEN EXIT FOREACH END IF
         SELECT azi03 INTO l_azi03[1]
           FROM azi_file WHERE azi01=x3[1]
         SELECT azi03 INTO l_azi03[2]
           FROM azi_file WHERE azi01=x3[2]
         SELECT azi03 INTO l_azi03[3]
           FROM azi_file WHERE azi01=x3[3]
         SELECT azi03 INTO l_azi03[4]
           FROM azi_file WHERE azi01=x3[4]
         EXECUTE insert_prep1 USING 
            sr.pml02,l_pmh01,   #MOD-860194
            x1[1],x1[2],x1[3],x1[4],
            x2[1],x2[2],x2[3],x2[4],
            x3[1],x3[2],x3[3],x3[4],
            l_azi03[1],l_azi03[2],l_azi03[3],l_azi03[4],
            i
         LET g_cnt=g_cnt+1 IF g_cnt > 4 THEN EXIT FOREACH END IF
         LET i=i+1
         LET l_pmh01=''
      END FOREACH
 
      DECLARE pmn_cur CURSOR FOR
#        SELECT pmm04,pmm01,pmn02,pmc03,pmn20,pmn07,pmm22,pmn31,pmn20*pmn31  #No.TQC-740151 add pmn02   #CHI-B70039 mark
         SELECT pmm04,pmm01,pmn02,pmc03,pmn20,pmn07,pmm22,pmn31,pmn87*pmn31  #CHI-B70039
           #FROM pmm_file, pmn_file, pmc_file
           FROM pmn_file, pmm_file LEFT OUTER JOIN pmc_file ON pmm09=pmc_file.pmc01   #FUN-A40073 mod 
          WHERE pmn04 = sr.pml04 AND pmn01=pmm01 #AND pmm09=pmc_file.pmc01   #FUN-A40073 mod 
                AND pmm18 <> 'X'
          ORDER BY pmm04 DESC
      LET g_cnt1=0
      LET l_flag=0
      LET sr1.pmm04 = ''   #No.TQC-740151
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05    #No.CHI-6A0004
        FROM azi_file WHERE azi01=sr1.pmm22
 
      #M003 171121 By TSD.Nic -----(S)
      #GET gen02
      LET l_gen02 = ''
      SELECT gen02 INTO l_gen02
        FROM gen_file   
      WHERE gen01 = l_ta_pml06 

      #GET occ02
      LET l_occ02 = ''
      IF LENGTH(sr.ta_pml01) <=3 OR cl_null(sr.ta_pml01) THEN
      ELSE
         LET l_oea01 = sr.ta_pml01[1,LENGTH(sr.ta_pml01)-3]
         SELECT occ02 INTO l_occ02
           FROM occ_file,oea_file
          WHERE occ01 = oea03 AND oea01 = l_oea01
      END IF

      #GET ima27
      LET l_ima27 = ''
      LET l_ima46 = 0                          #20180925
      SELECT ima27,ima46 INTO l_ima27,l_ima46  #20180925
        FROM ima_file
       WHERE ima01 = sr.pml04

      #20180329 add by momo 預計開工日優先抓T4011工單 
      #20191211 modify by momo 調整為參數化
      SELECT sfb13 INTO l_sfb13 FROM sfb_file 
       WHERE ta_sfb01=sr.ta_pml01 
        #AND sfb01 LIKE 'T4011%'                                                             #20191211 mark 
         AND EXISTS (SELECT * FROM smy_file WHERE smyslip=SUBSTR(sfb01,1,5) AND smyud02='Y') #20191211 mark
         AND sfb87='Y'
      IF SQLCA.SQLCODE=100 THEN    #20180412 add =100
      #add by ruby 預計完工日
      SELECT sfb15 INTO l_sfb13 FROM sfb_file WHERE sfb01=sr.ta_pml02
      IF SQLCA.SQLCODE THEN LET l_sfb13='' END IF
      END IF #20180329

      #GET atp_qty
      LET l_oeb_q = 0
      LET l_sfa_q1 = 0
      LET l_pml_q = 0
      LET l_pmn_q = 0
      LET l_rvb_q = 0
      LET l_sfb_q1 = 0
      LET l_sfb_q2 = 0
      LET l_qcf_q = 0
      LET l_misc_q1 = 0

      CALL s_getstock(sr.pml04,g_plant) RETURNING  l_n1,l_n2,l_n3
      LET l_avl_stk = l_n3

      SELECT SUM((oeb12-oeb24+oeb25-oeb26)*oeb05_fac) INTO l_oeb_q
        FROM oeb_file, oea_file
       WHERE oeb01 = oea01 AND oea00<>'0'
         AND oeb70 = 'N'
         AND oeb12-oeb24+oeb25-oeb26>0
         AND oeaconf = 'Y'
         AND oeb04 = sr.pml04

      SELECT SUM(inb09) INTO l_misc_q1
        FROM ina_file,inb_file
       WHERE ina01=inb01 AND inaconf = 'Y'
         AND inapost = 'N' AND ina00='1'
         AND inb04 = sr.pml04

      LET l_sql = "SELECT sfa_file.*",
                  "  FROM sfa_file,sfb_file",
                  " WHERE sfb01 = sfa01 ",
                  "   AND sfb04 <= '7' ",
                  "   AND sfb87!='X'",
                  "   AND sfb02 != '15'",
                  "   AND sfa03 = '",sr.pml04,"' "
      PREPARE r903_sum_pre1 FROM l_sql
      DECLARE r903_sum1 CURSOR FOR r903_sum_pre1
      FOREACH r903_sum1 INTO lr_sfa.*
         IF SQLCA.sqlcode THEN END IF
         CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                         lr_sfa.sfa12,lr_sfa.sfa27,
                         lr_sfa.sfa012,lr_sfa.sfa013)
              RETURNING l_short_qty
         IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF
         IF (lr_sfa.sfa05 > (lr_sfa.sfa06 + lr_sfa.sfa065 - lr_sfa.sfa063 ) OR l_short_qty > 0) THEN
              LET l_sfa_q1_2 =(lr_sfa.sfa05 - lr_sfa.sfa06 - lr_sfa.sfa065 +    lr_sfa.sfa063 - lr_sfa.sfa062 ) * lr_sfa.sfa13
              IF l_sfa_q1_2 < 0 THEN
                  LET l_sfa_q1_2 = 0
              END IF
              LET l_sfa_q1= l_sfa_q1 + l_sfa_q1_2
         END IF
      END FOREACH

      SELECT SUM((pml20-pml21)*pml09) INTO l_pml_q
        FROM pml_file, pmk_file
       WHERE pml01 = pmk01
         AND pml20 > pml21
         AND ( pml16 <='2' OR pml16='S' OR pml16='R' OR pml16='W')
         AND pml011 !='SUB'
         AND pmk18 != 'X'
         AND pml04 = sr.pml04

      SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) INTO l_pmn_q
        FROM pmn_file, pmm_file
       WHERE pmn01 = pmm01
         AND pmn20 > pmn50-pmn55-pmn58
         AND ( pmn16 <='2' OR pmn16='S' OR pmn16='R' OR pmn16='W')
         AND pmn011 !='SUB'
         AND pmm18 != 'X'
         AND pmn04 = sr.pml04

      SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO l_rvb_q
        FROM rvb_file, rva_file, pmn_file
       WHERE rvb01=rva01
         AND rvb04 = pmn01 AND rvb03 = pmn02
         AND rvb07 > (rvb29+rvb30)
         AND rvaconf='Y'
         AND rva10 != 'SUB'
         AND rvb05 = sr.pml04

      SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)
        INTO l_sfb_q1
        FROM ima_file,sfb_file
       WHERE sfb05=ima01
         AND ( sfb02 !='7' AND sfb02 !='8' AND sfb02 !='11' AND sfb02 != '15' )
         AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X'
         AND sfb04 <= '7'
         AND sfb05 = sr.pml04

      LET l_shb114 = 0
      SELECT SUM(shb114) INTO l_shb114
        FROM shb_file,sfb_file
       WHERE shb05 = sfb01
         AND shb10 = sfb05
         AND sfb04 <= '7' AND sfb87 != 'X'
         AND ( sfb02 !='7' AND sfb02 !='8' AND sfb02 !='11' AND sfb02 != '15' )
         AND shb10 = sr.pml04

      IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
      LET l_sfb_q1 = l_sfb_q1 - l_shb114

      SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)
        INTO l_sfb_q2
        FROM ima_file,sfb_file
       WHERE sfb05=ima01
         AND (sfb02='7' OR sfb02='8')
         AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X'
         AND sfb04 <= '7'
         AND sfb05 = sr.pml04
      IF cl_null(l_sfb_q2) THEN LET l_sfb_q2=0 END IF
      LET l_shb114 = 0
      SELECT SUM(shb114) INTO l_shb114
        FROM shb_file,sfb_file
       WHERE shb05 = sfb01
         AND shb10 = sfb05
         AND sfb87 != 'X'
         AND ( sfb02 ='7' OR sfb02 ='8')
         AND sfb04 <= '7'
         AND shb10 = sr.pml04
      IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
      LET l_sfb_q2 = l_sfb_q2 - l_shb114

      SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO l_rvb_q2
        FROM rvb_file, rva_file, pmn_file
       WHERE rvb01=rva01
         AND rvb04 = pmn01 AND rvb03 = pmn02
         AND rvb07 > (rvb29+rvb30)
         AND rvaconf='Y'
         AND rva10 ='SUB'
         AND pmn43 = 0
         AND rvb05 = sr.pml04
      IF cl_null(l_rvb_q2) THEN LET l_rvb_q2=0 END IF

      LET l_sfb_q2 = l_sfb_q2 + l_rvb_q2

      SELECT SUM(sfb11*ima55_fac) INTO l_qcf_q
        FROM ima_file,sfb_file
       WHERE sfb05=ima01 
         AND sfb02 <> '7' AND sfb87!='X'
         AND sfb02 <> '8'
         AND sfb02 <> '11'
         AND sfb04 <= '7'
         AND sfb05 = sr.pml04
      IF SQLCA.sqlcode OR STATUS THEN LET l_qcf_q = 0 END IF

      IF cl_null(l_oeb_q)  THEN LET l_oeb_q = 0  END IF
      IF cl_null(l_misc_q1)  THEN LET l_misc_q1 = 0  END IF
      IF cl_null(l_sfa_q1) THEN LET l_sfa_q1 = 0 END IF
      IF cl_null(l_pml_q)  THEN LET l_pml_q = 0  END IF
      IF cl_null(l_pmn_q)  THEN LET l_pmn_q = 0  END IF
      IF cl_null(l_rvb_q)  THEN LET l_rvb_q = 0  END IF
      IF cl_null(l_sfb_q1) THEN LET l_sfb_q1 = 0 END IF
      IF cl_null(l_sfb_q2) THEN LET l_sfb_q2 = 0 END IF
      IF cl_null(l_qcf_q)  THEN LET l_qcf_q = 0  END IF
      LET l_atp_qty = l_avl_stk - l_oeb_q - l_sfa_q1 - l_misc_q1
                                + l_pml_q + l_pmn_q + l_rvb_q
                                + l_sfb_q1+ l_sfb_q2+ l_qcf_q
      #M003 171121 By TSD.Nic -----(E)

      ##---- 20180403 add by momo(S) 請購單可用量/安全存量顯示採購單位
      ##---- 20181031 增加顯示 年平均用量 ima41
      LET l_ima52 = 0
      SELECT ima41,ima44_fac INTO l_ima52,l_ima44_fac 
        FROM ima_file 
       WHERE ima01 = sr.pml04
      LET l_atp_qty = l_atp_qty / l_ima44_fac
      LET l_ima27   = l_ima27 / l_ima44_fac  
      ##---- 20180403 add by momo(E)

      ##---- 20180827 add by momo (S) 抓取年平均用量 #20181012 modify
      #LET l_ima52 = 0
      #SELECT SUM(ccc31+ccc41+ccc81)*-1/COUNT(DISTINCT ccc03)
      #  INTO l_ima52
      #  FROM ccc_file,ima_file
      # WHERE ccc01=ima01
      #   AND ccc02||LPAD(ccc03,2,'0') >=to_char(add_months(trunc(sysdate),-12),'yyyymm')
      #   AND ccc02||LPAD(ccc03,2,'0') <= to_char(add_months(trunc(sysdate),-1),'yyyymm')
      #   AND ima133 = sr.pml04
      #GROUP BY ima133
      #CALL cs_avguse(sr.pml04,12) RETURNING l_ima52 #20181031 mark
      LET l_ima52 = l_ima52 / l_ima44_fac
      ##---- 20180827 add by momo (E)

      ##---- 20180925 add by momo (S) 抓取季平均用量 #20181012 modify
      LET l_ima52_3 = 0
      #SELECT SUM(ccc31+ccc41+ccc81)*-1/COUNT(DISTINCT ccc03)
      #  INTO l_ima52_3
      #  FROM ccc_file,ima_file
      # WHERE ccc01=ima01
      #   AND ccc02||LPAD(ccc03,2,'0') >=to_char(add_months(trunc(sysdate),-3),'yyyymm')
      #   AND ccc02||LPAD(ccc03,2,'0') <= to_char(add_months(trunc(sysdate),-1),'yyyymm')
      #   AND ima133 = sr.pml04
      #GROUP BY ima133
       CALL cs_avguse(sr.pml04,3) RETURNING l_ima52_3
       LET l_ima52_3 = l_ima52_3 / l_ima44_fac
      ##---- 20180925 add by momo (E)

      ##--- 20200527 add by momo 抓取三個月內入庫量(S)
      LET l_ima52_4 = 0
      SELECT SUM(rvv17)/3 INTO l_ima52_4
        FROM ima_file,rvv_file,rvu_file
       WHERE rvv31 = ima01
         AND rvu01 = rvv01
         AND rvuconf = 'Y'
         AND ima133 = sr.pml04
         AND rvu00 = '1'
         AND rvu03 >= sysdate - 90
         
      ##--- 20200527 add by momo 抓取三個月內入庫量(E)

      ##---- 20200527 add by momo (S) 判斷是否存在分量計價
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM pmc_file,pmj_file ,pmi_file
       WHERE pmi03=pmc01 AND pmc05='1'
         AND pmi01 = pmj01 AND pmiconf = 'Y'
         AND pmj03 = sr.pml04
         AND ta_pmj02 is null
         AND pmj12 = '1'
         AND pmi05 = 'Y'
         AND pmj09||pmi03 IN ( SELECT MAX(pmj09)||pmi03 FROM pmi_file ,pmj_file
                         WHERE pmi01=pmj01
                            AND pmiconf='Y' 
                            AND pmj03 = sr.pml04 AND pmj12='1'
                            AND (ta_pmi01 IS NULL ) 
                        GROUP BY pmj03,pmi03)
      IF l_cnt > 0 THEN
         #LET sr.pml04 = '(分量)'||sr.pml04   #20210831 mark
         LET sr.pml041 = '(分量)'||sr.pml041  #20210831 modify
      END IF
      ##---- 20200527 add by momo (E)

      ##---- 20220210 add by momo (S)
      LET l_gen02_pmk12 = ''
      SELECT gen02 INTO l_gen02_pmk12 
        FROM gen_file,pmk_file
       WHERE gen01 = pmk12
         AND pmk01 = sr.pmk01
      LET sr.gem02 = sr.gem02 ,'- ', l_gen02_pmk12 
      ##---- 20220210 add by momo (E)

      FOREACH pmn_cur INTO sr1.*
         IF STATUS THEN CALL cl_err('pmn_cur',STATUS,1) EXIT FOREACH END IF
         LET g_cnt1=g_cnt1+1 IF g_cnt1 > tm.c THEN EXIT FOREACH END IF #No.TQC-740151
 
         EXECUTE insert_prep USING 
            sr.*,l_str2,sr1.*,
            g_zo.zo041,g_zo.zo042,g_zo.zo05,g_zo.zo09,
            l_pmk21,l_pme031,l_pme032,l_ima021,t_azi03,t_azi04,l_gfe03,l_sfb13, #MOD-DC0123 add l_gfe03,  #add by ruby l_sfb13 2018/01/12
            "",l_img_blob,"N",""      #FUN-910012 #TQC-c10039 add ""
           ,l_gen02,l_atp_qty,l_ima27,l_occ02  #M003 171121 By TSD.Nic add
           ,l_ima52,l_ima52_3,l_ima52_4,l_ima46                            #20180827 add #20180925 add #20200527 add ima52_4
            
         LET l_flag = 1            #No.TQC-740151
         LET sr1.pmm04=''
         LET sr1.pmm01=''
         LET sr1.pmn02=''          #No.TQC-740151
         LET sr1.pmc03=''
         LET sr1.pmn20=''
         LET sr1.pmn07=''
         LET sr1.pmn31=''
         LET sr1.amt=''         
      END FOREACH
      IF l_flag=0 THEN
         INITIALIZE sr1.* TO NULL
      END IF
      IF l_flag=0 AND cl_null(sr1.pmm04) THEN
         EXECUTE insert_prep USING sr.*,l_str2,sr1.*,
                                   g_zo.zo041,g_zo.zo042,g_zo.zo05,g_zo.zo09,
                                   l_pmk21,l_pme031,l_pme032,l_ima021,t_azi03,t_azi04,l_gfe03,l_sfb13, #MOD-DC0123 add l_gfe03, #add by ruby l_sfb13 2018/01/12
                                   "",l_img_blob,"N",""      #FUN-910012   #TQC-c10039 add ""
                                  ,l_gen02,l_atp_qty,l_ima27,l_occ02  #M003 171121 By TSD.Nic add
                                  ,l_ima52,l_ima52_3,l_ima52_4,l_ima46                            #20180827 add #20180925 add  #20200527 
         LET l_flag=1
      END IF
   END FOREACH
 
   #處理單據前、後特別說明
   LET l_sql = "SELECT pmk01 FROM pmk_file ",
               " WHERE ",tm.wc CLIPPED,
               "   ORDER BY pmk01"
   PREPARE r903_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE r903_cs2 CURSOR FOR r903_prepare2
 
   FOREACH r903_cs2 INTO sr.pmk01
 
     #額外備註-單據前備註 
      DECLARE pmo_cur CURSOR FOR
         SELECT pmo05,pmo06 FROM pmo_file
          WHERE pmo01=sr.pmk01 AND pmo03=0 AND pmo04='0'
          ORDER BY pmo05
      FOREACH pmo_cur INTO l_pmo05,l_pmo06
         EXECUTE insert_prep2 USING sr.pmk01,'0','0',l_pmo05,l_pmo06
      END FOREACH
 
     #額外備註-單據後備註 
      DECLARE pmo_cur4 CURSOR FOR
       SELECT pmo05,pmo06 FROM pmo_file
        WHERE pmo01=sr.pmk01 AND pmo03=0 AND pmo04='1'
          ORDER BY pmo05
      FOREACH pmo_cur4 INTO l_pmo05,l_pmo06
         EXECUTE insert_prep2 USING sr.pmk01,'0','1',l_pmo05,l_pmo06
      END FOREACH
   END FOREACH

 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED ,"|", 
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " WHERE pmo03=0 AND pmo04='0' ","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " WHERE pmo03!=0 AND pmo04='0' ","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " WHERE pmo03!=0 AND pmo04='1' ","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " WHERE pmo03=0 AND pmo04='1' ","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",               #FUN-E50074
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED                    #20180424
 
   IF g_zz05 = 'Y' THEN                                                         
      CALL cl_wcchp(tm.wc,'pmk01,pmk04,pmk12,pmk13')  
      RETURNING tm.wc                                                           
   ELSE
      LET tm.wc = ''
   END IF                      
   LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",tm.a CLIPPED,";",
               tm.b CLIPPED,";",tm.c CLIPPED
#TQC-C10039--mod--str-- 
   LET g_cr_table = l_table                 #主報表的temp table名稱
#  LET g_cr_gcx01 = "asmi300"               #單別維護程式
   LET g_cr_apr_key_f = "pmk01"       #報表主鍵欄位名稱，用"|"隔開 
#  LET l_ii = 1
   #報表主鍵值
#  CALL g_cr_apr_key.clear()                #清空
# FOREACH r903_cs3 INTO l_key.*            
#     LET g_cr_apr_key[l_ii].v1 = l_key.v1
#     LET l_ii = l_ii + 1
#   END FOREACH
#TQC-C10039--mod--end--
   CALL cl_prt_cs3('apmr903','apmr903',l_sql,l_str)

   ##---- 20180910 add by momo (S) 記錄列印次數
   LET l_sql = "SELECT DISTINCT pmk01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE r903_p3 FROM l_sql
   DECLARE r903_c3 CURSOR FOR r903_p3
   FOREACH r903_c3 INTO l_pmk01
      UPDATE pmk_file SET pmkprno = pmkprno + 1,
                          pmkprdt = g_today
                    WHERE pmk01 = l_pmk01
      IF sqlca.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","pmk_file",l_pmk01,'',STATUS,"","upd pmkprno",1)
      END IF
   END FOREACH
   ##----- 20180910 add by momo (E) 
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
#FUN-E50025
