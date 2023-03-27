# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cxmr400.4gl
# Descriptions...: 出貨標籤列印
# Date & Author..: 20190327 By momo
# Modify.........: No:23030052  20230327 調整聯絡人電話

DATABASE ds
 
#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"
#start FUN-570069 add
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5          #No.FUN-680137 SMALLINT
END GLOBALS
#end FUN-570069 add
 
DEFINE tm  RECORD                         # Print condition RECORD
           #wc      LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(500)             # Where condition #MOD-F10016 MARK
            wc      STRING,                       #MOD-F10016 ADD                                              
            a       LIKE type_file.chr1,          #No.FUN-E40034                          # 列印款式明細 
            n       LIKE type_file.chr1,          # Prog. Version..: '5.30.24-17.04.13(01)              # 列印單價
            b       LIKE type_file.chr1,          # Prog. Version..: '5.30.24-17.04.13(01)              # 列印訂單嘜頭
            d       LIKE type_file.chr1,          # 列印客戶料號
            c       LIKE type_file.chr1,          # 列印額外品名規格 No.FUN-A80072
           #e       LIKE type_file.chr1,          # 發送訂單確認書給客戶  #TQC-730022
            more    LIKE type_file.chr1           # Prog. Version..: '5.30.24-17.04.13(01)               # Input more condition(Y/N)
            END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20,         #No.FUN-680137 VARCHAR(20)   # For TIPTOP 串 EasyFlow
       g_po_no,g_ctn_no1,g_ctn_no2      LIKE type_file.chr20         #No.FUN-680137  VARCHAR(20)      #No:7674
DEFINE g_cnt       LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE g_i         LIKE type_file.num5      #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE g_msg       LIKE type_file.chr1000    #No.FUN-680137 VARCHAR(72)
DEFINE g_show_msg  DYNAMIC ARRAY OF RECORD  #FUN-650020
          oea01     LIKE oea_file.oea01,
          oea03     LIKE oea_file.oea03,
          occ02     LIKE occ_file.occ02,
          occ18     LIKE occ_file.occ18,
          ze01      LIKE ze_file.ze01,
          ze03      LIKE ze_file.ze03
                   END RECORD
DEFINE g_oea01     LIKE oea_file.oea01   #FUN-650020
DEFINE g_sma115    LIKE sma_file.sma115  #MOD-6B0114
DEFINE g_sma116    LIKE sma_file.sma116  #MOD-6B0114
DEFINE l_table     STRING                #TQC-740271 add
DEFINE l_table1    STRING                #CHI-7A0010 add
DEFINE l_table2    STRING                #FUN-A80072 add
DEFINE l_table3    STRING                #CHI-D70029 add
DEFINE l_table4    STRING                #FUN-E40034 add
DEFINE l_table5    STRING                #add by ruby 2017/12/27
DEFINE g_sql       STRING                #TQC-740271 add
DEFINE g_str       STRING                #TQC-740271 add
 
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
 
   #str TQC-740271 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "oea00.oea_file.oea00  ,oea01.oea_file.oea01,",
               "oea02.oea_file.oea02  ,oea10.oea_file.oea10,",
               "oea915.occ_file.occ02  ,oea916.occ_file.occ02,", #20180410 add by momo
               "oea11.oea_file.oea11  ,oea12.oea_file.oea12,",
               "oea03.oea_file.oea03  ,oea032.oea_file.oea032,",
               "oea04.oea_file.oea04  ,oea044.oea_file.oea032,",
               "oea44.oea_file.oea44  ,occ02.occ_file.occ02,",
               "occ261.occ_file.occ261,occ29.occ_file.occ29,",  #add by ruby 2017/12/26
               "oea06.oea_file.oea06  ,oea14.oea_file.oea14,",
               "oea15.oea_file.oea15  ,oea23.oea_file.oea23,",
               "oea24.oea_file.oea24  ,oea43.oea_file.oea43,",  #add by ruby 2017/12/21
               "oea41.oea_file.oea41  ,oea42.oea_file.oea42,",  #add by ruby 2017/12/26
               "oac02.oac_file.oac02  ,oac021.oac_file.oac02,", #add by ruby 2017/12/26
               "ged02.ged_file.ged02  ,oeb70.oeb_file.oeb70,",  #add by ruby 2017/12/21
               "oeaud01.oea_file.oeaud01,",                     #add by ruby 2017/12/26
               "oea21.oea_file.oea21  ,oea211.oea_file.oea211,", #add by ruby 2018/02/02
               "oea25.oea_file.oea25,",
               "oea31.oea_file.oea31  ,oea32.oea_file.oea32,",
               "oea33.oea_file.oea33  ,oeb03.oeb_file.oeb03,",
               "oeb04.oeb_file.oeb04  ,ima021.ima_file.ima021,",
               "ima02.ima_file.ima02,",
               "oeb05.oeb_file.oeb05  ,oeb12.oeb_file.oeb12,",
               "oeb13.oeb_file.oeb13  ,oeb14.oeb_file.oeb14,",
               "oeb14t.oeb_file.oeb14t,oeb15.oeb_file.oeb15,",
               "oeb16.oeb_file.oeb16  ,",                         #20180409 add oeb16
               "oeb06.oeb_file.oeb06  ,oeb11.oeb_file.oeb11,",
               "ta_obk01.obk_file.ta_obk01  ,ta_obk02.obk_file.ta_obk02,",      #                     #180917 add by ruby
               "ta_obk03.obk_file.ta_obk03,",                     #20190327
               "oeb17.oeb_file.oeb17  ,oeb18.oeb_file.oeb18,",
               "oeb19.oeb_file.oeb19  ,oeb20.oeb_file.oeb20,",
               "oeb21.oeb_file.oeb21  ,oeb32.oeb_file.oeb32,",    #FUN-7B0142 mod   #No.FUN-A80024 add oeb32
              #"oeb21.oeb_file.oeb21  ,occ55.occ_file.occ55,",    #FUN-7B0142 mark
               "oeb916.oeb_file.oeb916,oeb917.oeb_file.oeb917,",
               "oebud01.oeb_file.oebud01,",
               "oebud02.oeb_file.oebud02,",
               "oebud05.oeb_file.oebud05,",
               "gfe03.gfe_file.gfe03  ,azi03.azi_file.azi03,",
               "azi04.azi_file.azi04  ,azi05.azi_file.azi05,",
               "occ02_1.occ_file.occ02,gen02.gen_file.gen02,",
               "ocd03.ocd_file.ocd03  ,ocd221.ocd_file.ocd221,", #add by ruby 2017/12/19
               "ocd224.ocd_file.ocd224,ocd228.ocd_file.ocd228,", #add by ruby 2017/12/26
               "oab02.oab_file.oab02  ,gem02.gem_file.gem02,",
               "oah02.oah_file.oah02  ,oag02.oag_file.oag02,",
               "gec02.gec_file.gec02  ,addr1.occ_file.occ241,",
               "addr2.occ_file.occ241 ,addr3.occ_file.occ241,",
               "addr4.occ_file.occ241 ,addr5.occ_file.occ241,",
               "unit.type_file.chr50  ,",                         #CHI-D70029 add   
               "zo02.zo_file.zo02     ,",                     #CHI-D70029 add
               "g_msg.type_file.chr1000,",   #MOD-7B0236      #CHI-D70029 modify chr50 -> chr1000
               "zo041.zo_file.zo041,zo05.zo_file.zo05,zo09.zo_file.zo09,",   #FUN-810029 add
               "oeb07.oeb_file.oeb07,l_count.type_file.num5,l_count_ocf.type_file.num5,l_count_oeo.type_file.num5,",   #FUN-940044 add 2, #CHI-EC0042 add l_count_cof #180321 add l_count_oeo
               "sign_type.type_file.chr1,sign_img.type_file.blob,",          #簽核方式, 簽核圖檔    #FUN-940044 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000"         #是否顯示簽核資料(Y/N) #TQC-C10039 sign_str 
             
   LET l_table = cl_prt_temptable('cxmr400',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   #str CHI-7A0010 add
    #備註
    LET g_sql = "oao01.oao_file.oao01,",
                "oao03.oao_file.oao03,",
                "oao04.oao_file.oao04,",
                "oao05.oao_file.oao05,",
                "oao06.oao_file.oao06"
    LET l_table1 = cl_prt_temptable('cxmr4001',g_sql) CLIPPED
    IF  l_table1 = -1 THEN EXIT PROGRAM END IF
   #end CHI-7A0010 add
   #No.FUN-A80072 --start--
   LET g_sql = "imc01.imc_file.imc01,",
               "imc02.imc_file.imc02,",
               "imc03.imc_file.imc03,",
               "imc04.imc_file.imc04,",
               "oea01.oea_file.oea01,",
               "oeb03.oeb_file.oeb03"
    LET l_table2 = cl_prt_temptable('cxmr4002',g_sql) CLIPPED
    IF  l_table2 = -1 THEN EXIT PROGRAM END IF
   #No.FUN-A80072 --end--
   #CHI-D70029 -- add start --
   LET g_sql = "l_ocf_display01.type_file.chr1, l_ocf_display02.type_file.chr1,",
               "l_ocf_display03.type_file.chr1, l_ocf_display04.type_file.chr1,",
               "l_ocf_display05.type_file.chr1, l_ocf_display06.type_file.chr1,",
               "l_ocf_display07.type_file.chr1, l_ocf_display08.type_file.chr1,",
               "l_ocf_display09.type_file.chr1, l_ocf_display10.type_file.chr1,",
               "l_ocf_display11.type_file.chr1, l_ocf_display12.type_file.chr1,",
               "ocf01.ocf_file.ocf01  , ocf02.ocf_file.ocf02  ,",
               "ocf101.ocf_file.ocf101, ocf102.ocf_file.ocf102,",
               "ocf103.ocf_file.ocf103, ocf104.ocf_file.ocf104,",
               "ocf105.ocf_file.ocf105, ocf106.ocf_file.ocf106,",
               "ocf107.ocf_file.ocf107, ocf108.ocf_file.ocf108,",
               "ocf109.ocf_file.ocf109, ocf110.ocf_file.ocf110,",
               "ocf111.ocf_file.ocf111, ocf112.ocf_file.ocf112,",
               "ocf201.ocf_file.ocf201, ocf202.ocf_file.ocf202,",
               "ocf203.ocf_file.ocf203, ocf204.ocf_file.ocf204,",
               "ocf205.ocf_file.ocf205, ocf206.ocf_file.ocf206,",
               "ocf207.ocf_file.ocf207, ocf208.ocf_file.ocf208,",
               "ocf209.ocf_file.ocf209, ocf210.ocf_file.ocf210,",
               "ocf211.ocf_file.ocf211, ocf212.ocf_file.ocf212,",   #MOD-FA0126 add ,",
               "oea01.oea_file.oea01"                               #MOD-FA0126 add
   LET l_table3 = cl_prt_temptable('cxmr4003',g_sql) CLIPPED
   IF  l_table3 = -1 THEN EXIT PROGRAM END IF
   #CHI-D70029 -- add end --
   #------------------------------ CR (1) ------------------------------#
   #FUN-E40034--start to add--
   LET g_sql="oebc01.oebc_file.oebc01, oebc03.oebc_file.oebc03,",
             "oebc05.oebc_file.oebc05, oebc05_name.agd_file.agd03,",
             "oebc06.oebc_file.oebc06, oebc06_name.agd_file.agd03,", 
             "oebc07.oebc_file.oebc07, oebc07_1.oebc_file.oebc07,",
             "oebc07_2.oebc_file.oebc07, oebc07_3.oebc_file.oebc07,",
             "oebc07_4.oebc_file.oebc07,",
             "agd04_color.agd_file.agd04, agd04_size.agd_file.agd04 "
   LET l_table4 = cl_prt_temptable('cxmg4004',g_sql) CLIPPED
   IF  l_table4 = -1 THEN EXIT PROGRAM END IF
   #FUN-E40034--add the end--
   
    #選配件 add by ruby 2017/12/27
    LET g_sql = "oeo01.oeo_file.oeo01,",
                "oeo03.oeo_file.oeo03,",
                "oeo04.oeo_file.oeo04,",
                "oeo05.oeo_file.oeo05,",
                "oeo09.oeo_file.oeo09,",
                "ima02_1.ima_file.ima02,",
                "ima021_1.ima_file.ima021"
    LET l_table5 = cl_prt_temptable('cxmr4005',g_sql) CLIPPED
    IF  l_table5 = -1 THEN EXIT PROGRAM END IF
 
  #start FUN-570069 add
   LET g_pdate  = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
  #end FUN-570069 add
   LET tm.wc    = ARG_VAL(7)                          #FUN-570069 modify
   LET tm.n     = ARG_VAL(8)                          #FUN-570069 modify
   LET tm.b     = ARG_VAL(9)       
   LET tm.c     = ARG_VAL(10)                         #FUN-A80072 modify
  #LET g_rpt_name = ARG_VAL(2)   # 外部指定報表名稱   #FUN-570069 mark
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)                       #FUN-570069 modify
   LET g_rep_clas = ARG_VAL(12)                       #FUN-570069 modify
   LET g_template = ARG_VAL(13)                       #FUN-570069 modify
   #No.FUN-570264 ---end---

   LET tm.d = ARG_VAL(14)
   LET tm.a = ARG_VAL(15)
   LET g_xml.subject = ARG_VAL(16)
   LET g_xml.body = ARG_VAL(17)
   LET g_xml.recipient = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)
#FUN-E40034--modify the end--
 
  #LET g_rpt_name = ''
  
  #IF cl_null(tm.wc) THEN                                         #FUN-570069 mark
   IF (cl_null(g_bgjob) OR g_bgjob = 'N') THEN  # If background   #FUN-570069
      CALL cxmr400_tm(0,0)             # Input print condition
   ELSE 
  #   LET tm.wc="oea01= '",tm.wc CLIPPED,"'"   #FUN-570069 mark
      CALL cxmr400()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION cxmr400_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW cxmr400_w AT p_row,p_col WITH FORM "cxm/42f/cxmr400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'       
   LET g_copies = '1'
   LET tm.n ='Y'
   LET tm.b ='Y'
   LET tm.d ='Y'   #FUN-690032 add
   LET tm.c ='N'   #FUN-A80072 add 
  #LET tm.e ='N'   #TQC-730022 add   #TQC-740271 mark
  #FUN-E40034--start to add--
   IF s_industry("slk") AND g_sma.sma150='Y' THEN
      CALL cl_set_comp_visible("a",TRUE)
      LET tm.a='Y'
   ELSE
      CALL cl_set_comp_visible("a",FALSE)
      LET tm.a='N'
   END IF
  #FUN-E40034-add the end--
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea01,oea02,oeb03
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
    #No.FUN-B30169-add-start--
      ON ACTION controlp
         CASE
            WHEN INFIELD(oea01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_oea11"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea01
               NEXT FIELD oea01
           
         OTHERWISE
            EXIT CASE
         END CASE
    #No.FUN-B30169-add-end--

      ON ACTION locale
         #CALL cl_dynamic_locale()
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
      LET INT_FLAG = 0 CLOSE WINDOW cxmr400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.n,tm.b,tm.c,tm.d,tm.more WITHOUT DEFAULTS  #BugNo:6289  #FUN-690032 add tm.d  #FUN-A80072 add tm.c   #TQC-740271  #FUN-E40034 add tm.a

      AFTER FIELD a
        IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
           NEXT FIELD a
        END IF
      #FUN-E40034--add the end--

      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[YN]' THEN
            NEXT FIELD n
         END IF
      AFTER FIELD b                #NO:6882
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
 
     #FUN-690032 add--begin
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
            NEXT FIELD d
         END IF
     #FUN-690032 add--end
     #FUN-A80072 --start--
     AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
            NEXT FIELD d
         END IF
     #FUN-A80072 --start--
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW cxmr400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF

   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cxmr400'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cxmr400','9031',1)
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
                         " '",tm.n CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'" ,   #No.FUN-A80072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         #FUN-E40034--start to add--
                         " '",tm.d CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",g_xml.subject CLIPPED,"'",
                         " '",g_xml.body CLIPPED,"'",
                         " '",g_xml.recipient CLIPPED,"'",
                         #FUN-E40034--add the end--
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078 
                         
         CALL cl_cmdat('cxmr400',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cxmr400_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cxmr400()
   ERROR ""
END WHILE
   CLOSE WINDOW cxmr400_w
END FUNCTION
 
FUNCTION cxmr400()
#TQC-730022 add
  DEFINE l_cmd           LIKE type_file.chr1000 
  DEFINE l_oce03         LIKE oce_file.oce03
  DEFINE l_oce05         LIKE oce_file.oce05
  DEFINE l_zo02          LIKE zo_file.zo02
  DEFINE l_zo041         LIKE zo_file.zo041       #FUN-810029 add
  DEFINE l_zo05          LIKE zo_file.zo05        #FUN-810029 add
  DEFINE l_zo09          LIKE zo_file.zo09        #FUN-810029 add
  DEFINE l_subject       STRING   #主旨
  DEFINE l_body          STRING   #內文路徑
  DEFINE l_recipient     STRING   #收件者
  DEFINE l_cnt           LIKE   type_file.num5    #SMALLINT
  DEFINE l_wc            STRING
  DEFINE ls_context      STRING  
  DEFINE ls_temp_path    STRING 
  DEFINE ls_context_file STRING
  DEFINE l_oea01_t       LIKE oea_file.oea01
  DEFINE l_count         LIKE   type_file.num5    #SMALLINT  #No.FUN-A80072
  DEFINE l_count_ocf     LIKE type_file.num5      #CHI-EC0042 add
  DEFINE l_count_oeo     LIKE type_file.num5      #180321
#TQC-730022 end
 
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          l_sql     STRING,                       #TQC-C50101 add
          sr        RECORD
                    oea00     LIKE oea_file.oea00,
                    oea01     LIKE oea_file.oea01,
                    oea02     LIKE oea_file.oea02,
                    oea10     LIKE oea_file.oea10,   #No.MOD-570395
                    oea915    LIKE occ_file.occ02,   #20180410
                    oea916    LIKE occ_file.occ02,   #20180410
                    oea11     LIKE oea_file.oea11,
                    oea12     LIKE oea_file.oea12,
                #   oea71     LIKE oea_file.oea71,    oea71 --> oea03
                    oea03     LIKE oea_file.oea03,
                    oea032    LIKE oea_file.oea032,
                    oea04     LIKE oea_file.oea04,
                    oea044    LIKE oea_file.oea044,
                    oea44     LIKE oea_file.oea44,   #No.MOD-570395
                    occ02     LIKE occ_file.occ02,
                    occ261    LIKE occ_file.occ261,  #add by ruby 2017/12/26
                    occ29     LIKE occ_file.occ29,   #add by ruby 2017/12/26
                    oea06     LIKE oea_file.oea06,
                    oea14     LIKE oea_file.oea14,
                    oea15     LIKE oea_file.oea15,
                    oea23     LIKE oea_file.oea23,
                    oea24     LIKE oea_file.oea24,   #add by ruby 2017/12/21
                    oea43     LIKE oea_file.oea43,   #add by ruby 2017/12/21
                    oea41     LIKE oea_file.oea41,   #add by ruby 2017/12/26
                    oea42     LIKE oea_file.oea42,   #add by ruby 2017/12/26
                    oeb70     LIKE oeb_file.oeb70,   #add by ruby 2017/12/21
                    oeaud01   LIKE oea_file.oeaud01, #add by ruby 2017/12/26
                    oea21     LIKE oea_file.oea21,
                    oea211    LIKE oea_file.oea211,  #add by ruby 2018/02/02
                    oea25     LIKE oea_file.oea25,
                    oea31     LIKE oea_file.oea31,
                    oea32     LIKE oea_file.oea32,
                    oea33     LIKE oea_file.oea33,
                    oeb03     LIKE oeb_file.oeb03,
                    oeb04     LIKE oeb_file.oeb04,
                    ima021    LIKE ima_file.ima021,
                    ima02     LIKE ima_file.ima02,
                    oeb05     LIKE oeb_file.oeb05,
                    oeb12     LIKE oeb_file.oeb12,
                    oeb13     LIKE oeb_file.oeb13,
                    oeb14     LIKE oeb_file.oeb14,
                    oeb14t    LIKE oeb_file.oeb14t,
                    oeb15     LIKE oeb_file.oeb15,
                    oeb16     LIKE oeb_file.oeb16,  #20180409 add 
                    oeb06     LIKE oeb_file.oeb06,
                    oeb07     LIKE oeb_file.oeb07,  #No.FUN-A80072
                    oeb11     LIKE oeb_file.oeb11,
                    oeb17     LIKE oeb_file.oeb17,
                    oeb18     LIKE oeb_file.oeb18,
                    oeb19     LIKE oeb_file.oeb19,
                    oeb20     LIKE oeb_file.oeb20,
                    oeb21     LIKE oeb_file.oeb21,
                    oeb32     LIKE oeb_file.oeb32,  #No.FUN-A80024
                    ofa04     LIKE ofa_file.ofa04,  #No:7646
                    ofa10     LIKE ofa_file.ofa10,  #No:7646
                    ofa44     LIKE ofa_file.ofa44,  #No:7646
                    ofa45     LIKE ofa_file.ofa45,  #No:7646
                    ofa46     LIKE ofa_file.ofa46,  #No:7646
                    oeb910    LIKE oeb_file.oeb910, #MOD-6B0114
                    oeb912    LIKE oeb_file.oeb912, #MOD-6B0114
                    oeb913    LIKE oeb_file.oeb913, #MOD-6B0114
                    oeb915    LIKE oeb_file.oeb915, #MOD-6B0114
                    oeb916    LIKE oeb_file.oeb916, #MOD-6B0114
                    oeb917    LIKE oeb_file.oeb917, #MOD-6B0114
                    oebud01   LIKE oeb_file.oebud01,
                    oebud02   LIKE oeb_file.oebud02,
                    oebud05   LIKE oeb_file.oebud05
                    END RECORD,
          #No.FUN-A80072  --start--
          sr1       RECORD
                    imc01     LIKE imc_file.imc01,
                    imc02     LIKE imc_file.imc02,
                    imc03     LIKE imc_file.imc03,
                    imc04     LIKE imc_file.imc04
                    END RECORD
          #No.FUN-A80072  --end--
   DEFINE oao      RECORD LIKE oao_file.*            #CHI-7A0010 add
   DEFINE oeo      RECORD LIKE oeo_file.*            #add by ruby 2017/12/27
   DEFINE l_msg    STRING    #FUN-650020
   DEFINE l_msg2   STRING    #FUN-650020
   DEFINE lc_gaq03 LIKE gaq_file.gaq03   #FUN-650020
   DEFINE l_oea03 DYNAMIC ARRAY OF LIKE oea_file.oea03  #TQC-730022
   DEFINE l_oea01 DYNAMIC ARRAY OF LIKE oea_file.oea01  #TQC-730022
   DEFINE l_i,l_j     LIKE type_file.num5     #TQC-730022
   #str TQC-740271 add
   DEFINE l_gfe03   LIKE gfe_file.gfe03,
          l_occ02   LIKE occ_file.occ02,       
          l_gen02   LIKE gen_file.gen02,
          l_ocd03   LIKE ocd_file.ocd03,     #add by ruby 2017/12/19
          l_ocd221  LIKE ocd_file.ocd221,    #add by ruby 2017/12/19
          l_ocd224  LIKE ocd_file.ocd224,    #add by ruby 2017/12/26
          l_ocd228  LIKE ocd_file.ocd228,    #add by ruby 2017/12/26
          l_ged02   LIKE ged_file.ged02,     #add by ruby 2017/12/19 
          l_oac02   LIKE oac_file.oac02,     #add by ruby 2017/12/26
          l_oac021  LIKE oac_file.oac02,     #add by ruby 2017/12/26
          l_ima02_1 LIKE ima_file.ima02, #add by ruby 2017/12/27
          l_ima021_1 LIKE ima_file.ima021, #add by ruby 2017/12/27
          l_ta_obk01 LIKE obk_file.ta_obk01,  #180919 add by ruby
          l_ta_obk02 LIKE obk_file.ta_obk02,  #180919 add by ruby
          l_ta_obk03 LIKE obk_file.ta_obk03,
          l_oab02   LIKE oab_file.oab02,
          l_gem02   LIKE gem_file.gem02,
          l_oah02   LIKE oah_file.oah02,
          l_oag02   LIKE oag_file.oag02,
          l_gec02   LIKE gec_file.gec02,
          l_addr1   LIKE occ_file.occ241,
          l_addr2   LIKE occ_file.occ241,
          l_addr3   LIKE occ_file.occ241,
          l_addr4   LIKE occ_file.occ241,
          l_addr5   LIKE occ_file.occ241,
          l_ima906  LIKE ima_file.ima906,
          l_oeb910  LIKE oeb_file.oeb910,
          l_oeb912  LIKE oeb_file.oeb912,
          l_oeb913  LIKE oeb_file.oeb913,
          l_oeb915  LIKE oeb_file.oeb915,
          l_oeb12   LIKE oeb_file.oeb12,
          l_unit    LIKE type_file.chr50,
         #l_oao04   LIKE oao_file.oao04,   #CHI-7A0010 mark
         #l_oao06   LIKE oao_file.oao06,   #CHI-7A0010 mark
          l_ocf     RECORD LIKE ocf_file.* 
   #end TQC-740271 add
DEFINE l_lang_t     LIKE type_file.chr1,   #TQC-750114
       l_wc0        STRING,
       l_wc1        STRING,
       l_wc2        STRING
   ###No.FUN-940044 START###
DEFINE   l_img_blob     LIKE type_file.blob
#CHI-D70029 -- add start --
DEFINE l_ocf_display01    LIKE type_file.chr1
DEFINE l_ocf_display02    LIKE type_file.chr1
DEFINE l_ocf_display03    LIKE type_file.chr1
DEFINE l_ocf_display04    LIKE type_file.chr1
DEFINE l_ocf_display05    LIKE type_file.chr1
DEFINE l_ocf_display06    LIKE type_file.chr1
DEFINE l_ocf_display07    LIKE type_file.chr1
DEFINE l_ocf_display08    LIKE type_file.chr1
DEFINE l_ocf_display09    LIKE type_file.chr1
DEFINE l_ocf_display10    LIKE type_file.chr1
DEFINE l_ocf_display11    LIKE type_file.chr1
DEFINE l_ocf_display12    LIKE type_file.chr1

 DEFINE   l_oebc05        LIKE oebc_file.oebc05,   
          l_oebc06        LIKE oebc_file.oebc06,  
          l_oebc05_name   LIKE agd_file.agd03,      #size 
          l_oebc06_name   LIKE agd_file.agd03,      #color
          l_oebc07        LIKE oebc_file.oebc07, 
          l_oebc07_1      LIKE oebc_file.oebc07,    #amount  1-10
          l_oebc07_2      LIKE oebc_file.oebc07,    #amount 11-20
          l_oebc07_3      LIKE oebc_file.oebc07,    #amount 21-30
          l_oebc07_4      LIKE oebc_file.oebc07,    #amount 31-40
          l_next          LIKE type_file.num5,      #目前執行筆數
          l_agd04_color   LIKE agd_file.agd04,      #顏色的順序 
          l_agd04_size    LIKE agd_file.agd04,      #尺寸的順序
          l_flag          LIKE type_file.chr1
#FUN-E40034--add the end--
 
   #str TQC-740271 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   LOCATE l_img_blob IN MEMORY #blob初始化  #No.FUN-940044 add
   CALL cl_del_data(l_table1)   #CHI-7A0010 add
   CALL cl_del_data(l_table2)   #No.FUN-A80072 
   CALL cl_del_data(l_table3)   #CHI-D70029 add
   CALL cl_del_data(l_table4)   #FUN-E40034 add
   CALL cl_del_data(l_table5)   #add by ruby 2017/12/27
   #------------------------------ CR (2) ------------------------------#
 
  #str CHI-7A0010 add
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"                           #20190327
            
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep2:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"    #MOD-FA0126 add
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep3:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep4 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep4:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   #add by ruby 2017/12/27
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
               " VALUES(?,?,?,?,?,?,?)"
   PREPARE insert_prep5 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep5:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   #FUN-E40034--add the end--
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #MOD-6B0114
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  #str FUN-810029 mod
  #公司全名zo02、公司地址zo041、公司電話zo05、公司傳真zo09
   LET l_zo041 = NULL  LET l_zo05 = NULL  LET l_zo09 = NULL
   SELECT zo02,zo041,zo05,zo09 INTO g_company,l_zo041,l_zo05,l_zo09
     FROM zo_file WHERE zo01=g_rlang
  #end FUN-810029 mod
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #TQC-740271 add

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
 
   LET l_sql="SELECT oea00,oea01,oea02,oea10,oea915,oea916,oea11,oea12,",   
             "       oea03,oea032,oea04,oea044,oea44,case when occ02 is null then ofd02 else occ02 end,",
             "       case when occ261 is null then ofd33 else occ261 end,",
             "       case when occ29 is null then ofd31 else occ29 end,oea06,",   
             "       oea14,oea15,oea23,oea24,oea43,oea41,oea42,oeb70,oeaud01,oea21,oea211,oea25,oea31,oea32,",   
             "       oea33,oeb03,oeb04,ima021,ima02,oeb05,oeb12,oeb13,oeb14,",
             "       oeb14t,oeb15,oeb16,oeb06,oeb07,oeb11,oeb17,oeb18,oeb19,oeb20,oeb21,oeb32",      
             ",'','','','','',",    
             "      oeb910,oeb912,oeb913,oeb915,oeb916,oeb917, ", 
             "      oebud01,oebud02,oebud05 ",
             "  FROM oea_file LEFT OUTER JOIN oeb_file ON oea01=oeb01 ",
             "                LEFT OUTER JOIN ima_file ON oeb_file.oeb04 = ima_file.ima01 ",
             "                LEFT OUTER JOIN occ_file ON oea04=occ01 LEFT OUTER JOIN ofd_file ON oea04=ofd01 ", 
             " WHERE ", 
             "   oeaconf != 'X' ", 
             "   AND ",tm.wc CLIPPED,
             " ORDER BY oea01,oea02,oeb03 "
   PREPARE cxmr400_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   DECLARE cxmr400_curs1 CURSOR FOR cxmr400_prepare1
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF


   
###No.FUN-940044 START ###
   #單據key值
   LET l_sql="SELECT oea01",
             "  FROM oea_file,oeb_file LEFT OUTER JOIN ima_file ON oeb_file.oeb04 = ima_file.ima01,occ_file ",
             " WHERE oea_file.oea01 = oeb_file.oeb01 ",
             "   AND oea_file.oea04 = occ_file.occ01 ",
             "   AND oeaconf != 'X' ",
             "   AND ",tm.wc CLIPPED,
             " ORDER BY oea01"
   
   PREPARE r400_pr1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r400_cs1 CURSOR FOR r400_pr1
  

   LET l_i = 0  #TQC-730022
   CALL g_show_msg.clear() #FUN-650020
   FOREACH cxmr400_curs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
      #單位小數位數
      SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=sr.oeb05
      IF cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
 
	  #帳款客戶名稱
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oea03
      IF SQLCA.SQLCODE THEN LET l_occ02='' END IF
      #送貨廠商  add by ruby 2017/12/19
      LET l_ocd03 = ''
      SELECT ocd03 INTO l_ocd03 FROM ocd_file WHERE ocd01=sr.oea03 and ocd02=sr.oea044
      #送貨地址/聯絡電話  add by ruby 2017/12/19
      LET l_ocd221 = '' 
      #SELECT ocd221 INTO l_ocd221 FROM ocd_file WHERE ocd01=sr.oea03 and ocd02=sr.oea044

      #聯絡人
      LET l_ocd224=''
      SELECT oea45 INTO l_ocd224 FROM oea_file WHERE oea01 = sr.oea01

      #聯絡電話 20230327
      LET l_ocd228= ''
      SELECT oce04 INTO l_ocd228 FROM oce_file WHERE oce03 = l_ocd224 AND oce01=sr.oea03

      #最後出貨日
      LET sr.oeb16=''
      SELECT MAX(oga02) INTO sr.oeb16 FROM ogb_file,oga_file
       WHERE ogb31 = sr.oea01 AND ogb32 = sr.oeb03
         AND oga01 = ogb01
         AND ogapost = 'Y' AND oga09 IN ('2','4','6')
      
      #交運方式  add by ruby 2017/12/21
      LET l_ged02 = ''
      SELECT ged02 INTO l_ged02 FROM ged_file WHERE ged01=sr.oea43
      #起運地  add by ruby 2017/12/26
      LET l_oac02 = ''
      SELECT oac02 INTO l_oac02 FROM oac_file WHERE oac01=sr.oea41     
      #到達地  add by ruby 2017/12/26
      LET l_oac021 = ''
      SELECT oac02 INTO l_oac021 FROM oac_file WHERE oac01=sr.oea42       
      #員工姓名
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oea14
      IF SQLCA.SQLCODE THEN LET l_gen02='' END IF
      #分類名稱
      SELECT oab02 INTO l_oab02 FROM oab_file WHERE oab01=sr.oea25
      IF SQLCA.SQLCODE THEN LET l_oab02='' END IF
      #部門名稱
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oea15
      IF SQLCA.SQLCODE THEN LET l_gem02='' END IF
      #說明
      SELECT oah02 INTO l_oah02 FROM oah_file WHERE oah01=sr.oea31
      IF SQLCA.SQLCODE THEN LET l_oah02='' END IF
      #說明
      SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01=sr.oea32
      IF SQLCA.SQLCODE THEN LET l_oah02='' END IF
      #稅別名稱
      SELECT gec02 INTO l_gec02 FROM gec_file WHERE gec01=sr.oea21 AND gec011='2'   #銷項
      IF SQLCA.SQLCODE THEN LET l_gec02='' END IF
      #地址檔
      CALL s_addr(sr.oea01,sr.oea04,sr.oea044) 
           RETURNING l_addr1,l_addr2,l_addr3,l_addr4,l_addr5
      IF SQLCA.SQLCODE THEN
         LET l_addr1='' LET l_addr2='' LET l_addr3='' 
         LET l_addr4='' LET l_addr5=''
      END IF

      #180919 add by ruby --s--
      SELECT ta_obk01,ta_obk02,ta_obk03
        INTO l_ta_obk01,l_ta_obk02,l_ta_obk03
        FROM obk_file 
       WHERE obk01=sr.oeb04 and obk02=sr.oea03 and obk03=sr.oeb11
        IF STATUS THEN
          LET l_ta_obk01 = ''
          LET l_ta_obk02 = '' 
        END IF           
      #180919 add by ruby --e--
          
      #客戶信用查核
      LET g_msg=NULL
     
      #單位備註(當使用多單位時才需要印)
      LET l_unit = ""
      IF g_sma115 = "Y" THEN
         SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=sr.oeb04
         CASE l_ima906
            WHEN "2"
               CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
               LET l_unit = l_oeb915 , sr.oeb913 CLIPPED
               IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
                  CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                  LET l_unit = l_oeb912, sr.oeb910 CLIPPED
               ELSE
                 IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
                    CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                    LET l_unit = l_unit CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
                 END IF
               END IF
            WHEN "3"
               IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
                  CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
                  LET l_unit = l_oeb915 , sr.oeb913 CLIPPED
               END IF
         END CASE
      END IF
      IF g_sma116 MATCHES '[13]' THEN    #No.FUN-610076
         IF sr.oeb05  <> sr.oeb916 THEN
            CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
            LET l_unit = l_unit CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
         END IF
      END IF
     #str CHI-7A0010 mod
      #列印單身備註
      DECLARE oao_c2 CURSOR FOR
       SELECT * FROM oao_file
        WHERE oao01=sr.oea01 AND oao03=sr.oeb03 AND (oao05='1' OR oao05='2')
      FOREACH oao_c2 INTO oao.*
         IF NOT cl_null(oao.oao06) THEN
            EXECUTE insert_prep1 USING 
               sr.oea01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
         END IF
      END FOREACH

      #列印單身選配件 add by ruby 2017/12/27
      DECLARE oeo_c5 CURSOR FOR
      SELECT *  FROM oeo_file
        WHERE oeo01=sr.oea01 AND oeo03=sr.oeb03 
      FOREACH oeo_c5 INTO oeo.*		 
			#選配件品名規格
			LET l_ima02_1 = '' LET l_ima021_1 = ''
			SELECT ima02,ima021 INTO l_ima02_1,l_ima021_1 FROM ima_file WHERE ima01=oeo.oeo04    
	  
            EXECUTE insert_prep5 USING 
               sr.oea01,oeo.oeo03,oeo.oeo04,oeo.oeo05,oeo.oeo09,l_ima02_1,l_ima021_1
      END FOREACH

      #180321 選配件項目數
      SELECT COUNT(*) INTO l_count_oeo FROM oeo_file
        WHERE oeo01=sr.oea01 AND oeo03=sr.oeb03 
      
    
      #No.FUN-A80072  --start  列印額外品名規格說明
      IF tm.c = 'Y' THEN
          SELECT COUNT(*) INTO l_count FROM imc_file
             WHERE imc01=sr.oeb04 AND imc02=sr.oeb07
          IF l_count !=0  THEN
            DECLARE imc_cur CURSOR FOR
            SELECT * FROM imc_file    
              WHERE imc01=sr.oeb04 AND imc02=sr.oeb07 
            ORDER BY imc03                                        
            FOREACH imc_cur INTO sr1.*                            
              EXECUTE insert_prep2 USING sr1.imc01,sr1.imc02,sr1.imc03,sr1.imc04,sr.oea01,sr.oeb03
            END FOREACH
          END IF
       END IF    
       #No.FUN-A80072  --end
      #CHI-EC0042 add start ------
       IF tm.b = 'Y' THEN
           SELECT COUNT(*) INTO l_count_ocf FROM ocf_file
            WHERE ocf01=sr.oea04 AND ocf02=sr.oea44
       END IF
      #CHI-EC0042 add start ------
     #MOD-D30205 add start -----
      #單價、金額、小計小數位數
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
        FROM azi_file WHERE azi01=sr.oea23
      IF cl_null(t_azi03) THEN LET t_azi03 = 0 END IF
      IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF
      IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF
     #MOD-D30205 add end  -----

     ##---- 20180410 add by momo (S)
     SELECT occ02 INTO sr.oea915 FROM occ_file  #帳款客戶
      WHERE occ01=sr.oea915 
     SELECT occ02 INTO sr.oea916 FROM occ_file  #送貨客戶
      WHERE occ01=sr.oea916
     ##---- 20180410 add by momo (E)
      

      EXECUTE insert_prep USING 
         sr.oea00    ,sr.oea01    ,sr.oea02    ,sr.oea10    ,
         sr.oea915   ,sr.oea916   ,                                         #20180410 add
         sr.oea11    ,
         sr.oea12    ,sr.oea03    ,sr.oea032   ,sr.oea04    ,sr.oea044   ,
         sr.oea44    ,sr.occ02    ,sr.occ261   ,sr.occ29    ,sr.oea06    ,  #add by ruby occ261,occ29 2017/12/26
         sr.oea14    ,sr.oea15    ,                                         
         sr.oea23    ,sr.oea24    ,sr.oea43    ,sr.oea42    ,sr.oea41    ,  #add by ruby oea24,oea43,oea41,oea42 2017/12/21
         l_oac02     ,l_oac021    ,l_ged02     ,sr.oeb70    ,               #add by ruby l_oac02,l_oac021,l_ged02,oeb70 2017/12/21
         sr.oeaud01  ,sr.oea21    ,sr.oea211   ,sr.oea25    ,sr.oea31    ,sr.oea32    ,  #add by ruby oeaud01 2017/12/26  #add by ruby oea211 2018/02/02
         sr.oea33    ,sr.oeb03    ,sr.oeb04    ,sr.ima021   ,sr.ima02    ,sr.oeb05    ,
         sr.oeb12    ,sr.oeb13    ,sr.oeb14    ,sr.oeb14t   ,sr.oeb15    ,
         sr.oeb16    ,                                                      #20180409 add oeb16
         sr.oeb06    ,sr.oeb11    ,l_ta_obk01  ,l_ta_obk02  ,               #180919 add l_ta_obk01,l_ta_obk02 by ruby
         l_ta_obk03,
         sr.oeb17    ,sr.oeb18    ,sr.oeb19    ,
         sr.oeb20    ,sr.oeb21    ,sr.oeb32    ,sr.oeb916   ,sr.oeb917   ,                #FUN-7B0142 mod   No.FUN-A80024 add oeb32
         sr.oebud01  ,sr.oebud02  ,sr.oebud05  ,
        #sr.oeb20    ,sr.oeb21    ,sr.occ55    ,sr.oeb916   ,sr.oeb917   ,   #FUN-7B0142 mark 
         l_gfe03     ,t_azi03     ,t_azi04     ,t_azi05     ,l_occ02     ,                                                   
         l_gen02     ,l_ocd03     ,l_ocd221    ,l_ocd224    ,l_ocd228    ,   #add by ruby 2017/12/19
         l_oab02     ,l_gem02     ,l_oah02     ,l_oag02     ,     
         l_gec02     ,l_addr1     ,l_addr2     ,l_addr3     ,l_addr4     ,
         l_addr5     ,l_unit      ,                                          #CHI-D70029 add
         l_zo02,g_msg #CHI-D70029 add
        ,l_zo041     ,l_zo05      ,l_zo09  ,sr.oeb07 ,l_count      #FUN-810029 add  #FUN-A80072 add l_count
        ,l_count_ocf,l_count_oeo                                   #CHI-EC0042 add  #180321 add l_count_oeo
        ,"",l_img_blob,"N",""                                      #FUN-940044 add  #TQC-C10039 add "" 
      #end TQC-740271 add
 
    

 
   END FOREACH
 
  #str CHI-7A0010 add
   #列印整張備註
   LET l_sql = "SELECT oea01 FROM oea_file ",
               " WHERE ",tm.wc CLIPPED,
               "   ORDER BY oea01"
   PREPARE r400_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   DECLARE r400_cs2 CURSOR FOR r400_prepare2
 
   FOREACH r400_cs2 INTO sr.oea01
      DECLARE oao_c1 CURSOR FOR
       SELECT * FROM oao_file
        WHERE oao01=sr.oea01 AND oao03=0 AND (oao05='1' OR oao05='2')
      FOREACH oao_c1 INTO oao.*
         IF NOT cl_null(oao.oao06) THEN
            EXECUTE insert_prep1 USING 
               sr.oea01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
         END IF
      END FOREACH
   END FOREACH
   
  #end CHI-7A0010 add
  #CHI-D70029 -- add start --
  #客戶嘜頭檔
  #LET l_sql = "SELECT oea04,oea10,oea44 FROM oea_file ",  #MOD-FA0126 mark
   LET l_sql = "SELECT oea04,oea10,oea44,oea01 FROM oea_file ", #MOD-FA0126 add
               " WHERE ",tm.wc CLIPPED,
               "   ORDER BY oea01"
   PREPARE r400_prepare3 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare3:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE r400_cs3 CURSOR FOR r400_prepare3
  #FOREACH r400_cs3 INTO sr.oea04,sr.oea10,sr.oea44            #MOD-FA0126 mark
   FOREACH r400_cs3 INTO sr.oea04,sr.oea10,sr.oea44,sr.oea01   #MOD-FA0126 add
      DECLARE ocf_c1 CURSOR FOR
       SELECT * FROM ocf_file
        WHERE ocf01=sr.oea04 AND ocf02=sr.oea44
      FOREACH ocf_c1 INTO l_ocf.*
         LET l_ocf_display01 = 'Y'
         LET l_ocf_display02 = 'Y'
         LET l_ocf_display03 = 'Y'
         LET l_ocf_display04 = 'Y'
         LET l_ocf_display05 = 'Y'
         LET l_ocf_display06 = 'Y'
         LET l_ocf_display07 = 'Y'
         LET l_ocf_display08 = 'Y'
         LET l_ocf_display09 = 'Y'
         LET l_ocf_display10 = 'Y'
         LET l_ocf_display11 = 'Y'
         LET l_ocf_display12 = 'Y'
         #判斷是否有維護值來決定是否顯示
         IF cl_null(l_ocf.ocf112) AND cl_null(l_ocf.ocf212) THEN
            LET l_ocf_display12 = 'N'
            IF cl_null(l_ocf.ocf111) AND cl_null(l_ocf.ocf211) THEN
               LET l_ocf_display11 = 'N'
               IF cl_null(l_ocf.ocf110) AND cl_null(l_ocf.ocf210) THEN
                  LET l_ocf_display10 = 'N'
                  IF cl_null(l_ocf.ocf109) AND cl_null(l_ocf.ocf209) THEN
                     LET l_ocf_display09 = 'N'
                     IF cl_null(l_ocf.ocf108) AND cl_null(l_ocf.ocf208) THEN
                        LET l_ocf_display08 = 'N'
                        IF cl_null(l_ocf.ocf107) AND cl_null(l_ocf.ocf207) THEN
                           LET l_ocf_display07 = 'N'
                           IF cl_null(l_ocf.ocf106) AND cl_null(l_ocf.ocf206) THEN
                              LET l_ocf_display06 = 'N'
                              IF cl_null(l_ocf.ocf105) AND cl_null(l_ocf.ocf205) THEN
                                 LET l_ocf_display05 = 'N'
                                 IF cl_null(l_ocf.ocf104) AND cl_null(l_ocf.ocf204) THEN
                                    LET l_ocf_display04 = 'N'
                                    IF cl_null(l_ocf.ocf103) AND cl_null(l_ocf.ocf203) THEN
                                       LET l_ocf_display03 = 'N'
                                       IF cl_null(l_ocf.ocf102) AND cl_null(l_ocf.ocf202) THEN
                                          LET l_ocf_display02= 'N'
                                          IF cl_null(l_ocf.ocf101) AND cl_null(l_ocf.ocf201) THEN
                                             LET l_ocf_display01 = 'N'
                                          END IF
                                       END IF
                                    END IF
                                 END IF
                              END IF
                           END IF
                        END IF
                     END IF
                  END IF
               END IF
            END IF
         END IF
         IF NOT cl_null(l_ocf.ocf01) THEN
            #-----No.MOD-570395-----
            LET g_po_no=sr.oea10
            LET g_ctn_no1=""
            LET g_ctn_no2=""
            #-----No.MOD-570395 END-----
            LET l_ocf.ocf101=r400_ocf_c(l_ocf.ocf101)
            LET l_ocf.ocf102=r400_ocf_c(l_ocf.ocf102)
            LET l_ocf.ocf103=r400_ocf_c(l_ocf.ocf103)
            LET l_ocf.ocf104=r400_ocf_c(l_ocf.ocf104)
            LET l_ocf.ocf105=r400_ocf_c(l_ocf.ocf105)
            LET l_ocf.ocf106=r400_ocf_c(l_ocf.ocf106)
            LET l_ocf.ocf107=r400_ocf_c(l_ocf.ocf107)
            LET l_ocf.ocf108=r400_ocf_c(l_ocf.ocf108)
            LET l_ocf.ocf109=r400_ocf_c(l_ocf.ocf109)
            LET l_ocf.ocf110=r400_ocf_c(l_ocf.ocf110)
            LET l_ocf.ocf111=r400_ocf_c(l_ocf.ocf111)
            LET l_ocf.ocf112=r400_ocf_c(l_ocf.ocf112)
            LET l_ocf.ocf201=r400_ocf_c(l_ocf.ocf201)
            LET l_ocf.ocf202=r400_ocf_c(l_ocf.ocf202)
            LET l_ocf.ocf203=r400_ocf_c(l_ocf.ocf203)
            LET l_ocf.ocf204=r400_ocf_c(l_ocf.ocf204)
            LET l_ocf.ocf205=r400_ocf_c(l_ocf.ocf205)
            LET l_ocf.ocf206=r400_ocf_c(l_ocf.ocf206)
            LET l_ocf.ocf207=r400_ocf_c(l_ocf.ocf207)
            LET l_ocf.ocf208=r400_ocf_c(l_ocf.ocf208)
            LET l_ocf.ocf209=r400_ocf_c(l_ocf.ocf209)
            LET l_ocf.ocf210=r400_ocf_c(l_ocf.ocf210)
            LET l_ocf.ocf211=r400_ocf_c(l_ocf.ocf211)
            LET l_ocf.ocf212=r400_ocf_c(l_ocf.ocf212)
         ELSE
            LET l_ocf.ocf01=' '
            LET l_ocf.ocf02=' '
            LET l_ocf.ocf101=' '
            LET l_ocf.ocf102=' '
            LET l_ocf.ocf103=' '
            LET l_ocf.ocf104=' '
            LET l_ocf.ocf105=' '
            LET l_ocf.ocf106=' '
            LET l_ocf.ocf107=' '
            LET l_ocf.ocf108=' '
            LET l_ocf.ocf109=' '
            LET l_ocf.ocf110=' '
            LET l_ocf.ocf111=' '
            LET l_ocf.ocf112=' '
            LET l_ocf.ocf201=' '
            LET l_ocf.ocf202=' '
            LET l_ocf.ocf203=' '
            LET l_ocf.ocf204=' '
            LET l_ocf.ocf205=' '
            LET l_ocf.ocf206=' '
            LET l_ocf.ocf207=' '
            LET l_ocf.ocf208=' '
            LET l_ocf.ocf209=' '
            LET l_ocf.ocf210=' '
            LET l_ocf.ocf211=' '
            LET l_ocf.ocf212=' '
         END IF
         EXECUTE insert_prep3 USING
            l_ocf_display01,l_ocf_display02,l_ocf_display03,l_ocf_display04,l_ocf_display05
           ,l_ocf_display06,l_ocf_display07,l_ocf_display08,l_ocf_display09,l_ocf_display10
           ,l_ocf_display11,l_ocf_display12
           ,l_ocf.ocf01 ,l_ocf.ocf02 ,l_ocf.ocf101
           ,l_ocf.ocf102,l_ocf.ocf103,l_ocf.ocf104,l_ocf.ocf105,l_ocf.ocf106
           ,l_ocf.ocf107,l_ocf.ocf108,l_ocf.ocf109,l_ocf.ocf110,l_ocf.ocf111
           ,l_ocf.ocf112,l_ocf.ocf201,l_ocf.ocf202,l_ocf.ocf203,l_ocf.ocf204
           ,l_ocf.ocf205,l_ocf.ocf206,l_ocf.ocf207,l_ocf.ocf208,l_ocf.ocf209
           ,l_ocf.ocf210,l_ocf.ocf211,l_ocf.ocf212
           ,sr.oea01    #MOD-FA0126 add
      END FOREACH
   END FOREACH
  #CHI-D70029 -- add end -- 
  #FINISH REPORT cxmr400_rep   #TQC-740271 mark
     
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  #TQC-730022
      #FUN-650020...............begin
      IF g_show_msg.getlength()>0 THEN
         CALL cl_get_feldname("oea01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("oea03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("occ02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("occ18",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         #TQC-840040-end-modify
         CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
         CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
      END IF
      #FUN-650020...............end
   END IF   #TQC-730022
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
  #str CHI-7A0010 mod
  #修改成新的子報表的寫法(可組一句主要SQL,五句子報表SQL)
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  # LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
  #             "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
  #             " WHERE oao03 =0 AND oao05='1'","|",
  #             "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
  #             " WHERE oao03!=0 AND oao05='1'","|",
  #             "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
  #             " WHERE oao03!=0 AND oao05='2'","|",
  #             "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
  #             " WHERE oao03 =0 AND oao05='2'","|",   
  #             "SELECT * FROM ", g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",   #CHI-D70029 add ,"|",
  #             "SELECT * FROM ", g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",   #CHI-D70029 add  #FUN-E40034 add,"|",
  #             "SELECT * FROM ", g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",   #FUN-E40034 add 
  #             "SELECT * FROM ", g_cr_db_str CLIPPED,l_table5 CLIPPED        #add by ruby 2017/12/27      
  #end CHI-7A0010 mod
 
   LET g_str = tm.n,";",tm.b,";",tm.d,";",g_sma116
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
     #TQC-750114 begin
       CALL cl_wcchp(tm.wc,'oea01,oea02,oeb03')  #FUN-7B0142 mark還原
            RETURNING tm.wc                      #FUN-7B0142 mark還原
   ELSE
      LET tm.wc = ''
   END IF
    LET g_str = g_str ,";",tm.wc,";",tm.c                #FUN-7B0142 mark 還原  #TQC-750114
   #LET g_str = g_str ,";",l_wc0 CLIPPED,";",l_wc1 CLIPPED,";",l_wc2 CLIPPED  #FUN-7B0142 mark#TQC-750114
###No.FUN-940044 START###
   LET g_cr_table = l_table                 #主報表的temp table名稱
   #LET g_cr_gcx01 = "cxmi010"              #單別維護程式#TQC-C10039 mark---
   LET g_cr_apr_key_f = "oea01"             #報表主鍵欄位名稱，用"|"隔開

   CALL cl_prt_cs3('cxmr400','cxmr400',g_sql,g_str)
  
END FUNCTION
 
 
#No:7674 add
FUNCTION r400_ocf_c(str)
  DEFINE str   LIKE cob_file.cob08        #No.FUN-680137 VARCHAR(30)
  DEFINE i,j    LIKE type_file.num5       #No.FUN-680137 SMALLINT

  FOR i=1 TO 20
    LET j=i+5
    IF str[i,j]='PPPPPP' THEN LET str[i,30]=g_po_no   RETURN str END IF
    IF str[i,j]='CCCCCC' THEN LET str[i,30]=g_ctn_no1 RETURN str END IF
    IF str[i,j]='DDDDDD' THEN LET str[i,30]=g_ctn_no2 RETURN str END IF
  END FOR
  RETURN str
END FUNCTION
##
 
FUNCTION r400_err_ana(ls_showmsg)    #FUN-650020
   DEFINE ls_showmsg  STRING
   DEFINE lc_oea03    LIKE oea_file.oea03
   DEFINE lc_ze01     LIKE ze_file.ze01
   DEFINE lc_occ02    LIKE occ_file.occ02
   DEFINE lc_occ18    LIKE occ_file.occ18
   DEFINE li_newerrno LIKE type_file.num5     #No.FUN-680137 SMALLINT
   DEFINE ls_tmpstr   STRING
 
   IF cl_null(ls_showmsg) THEN
      RETURN FALSE
   END IF
 
   LET lc_oea03 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
   LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                         ls_showmsg.getLength())
   IF ls_showmsg.getIndexOf("||",1) THEN
      LET lc_ze01 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
      LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                            ls_showmsg.getLength())
   ELSE
      LET lc_ze01 = ls_showmsg.trim()
      LET ls_showmsg = ""
   END IF
 
   SELECT occ02,occ18 INTO lc_occ02,lc_occ18 FROM occ_file
    WHERE occ01=lc_oea03
 
   LET li_newerrno = g_show_msg.getLength() + 1
   LET g_show_msg[li_newerrno].oea01   = g_oea01
   LET g_show_msg[li_newerrno].oea03   = lc_oea03
   LET g_show_msg[li_newerrno].occ02   = lc_occ02
   LET g_show_msg[li_newerrno].occ18   = lc_occ18
   LET g_show_msg[li_newerrno].ze01    = lc_ze01
   CALL cl_getmsg(lc_ze01,g_lang) RETURNING ls_tmpstr
   LET g_show_msg[li_newerrno].ze03    = ls_showmsg.trim(),ls_tmpstr.trim()
   #kim test
   LET li_newerrno = g_show_msg.getLength()
   DISPLAY li_newerrno
   RETURN TRUE
 
END FUNCTION
 

