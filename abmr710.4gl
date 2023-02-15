# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: abmr710.4gl
# Descriptions...: 工程變異單
# Input parameter:
# Return code....:
# Date & Author..: 92/02/11 By Carol
# Modify.........: 93/12/23 By Apple
# Modify.........: No.MOD-4A0086(1) 93/10/06 By Mandy 若為4.取代報表僅存出舊料,建議也要秀出新料.
# Modify.........: No.MOD-4A0086(2) 93/10/06 By Mandy 若為4.取代時,只列印出4.,正確為4.取代
# Modify.........: No.FUN-4A0037 04/10/08 By Smapmin 新增開窗功能
# Modify.........: No.MOD-530078 05/02/15 By cate 報表標題標準化
# Modify.........: No.MOD-530217 05/03/23 By kim 頁次永遠為1
# Modify.........: No.FUN-550095 05/05/27 By Mandy 特性BOM
# Modify.........: No.FUN-550101 05/05/25 By echo 新增報表備註
# Modify.........: No.MOD-590168 05/09/20 By kim 報表料號放大
# Modify.........: No.FUN-590110 05/09/28 By Tracy 修改報表,轉XML格式
# Modify.........: No.FUN-5A0010 05/10/12 By Sarah 列印時bmy16(取替代)欄位都是show英文,新增p_ze(abm-815~abm-818)來顯示,CASE多增加5 SET替代
# Modify.........: No.FUN-5A0142 05/10/20 By Claire 修改報表格式
# Modify.........: No.MOD-5C0160 05/12/28 By kim 變異別納入p_zaa
# Modify.........: No.TQC-610068 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-610131 06/01/24 By Claire 調整報表
# Modify.........: No.TQC-630177 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-640178 06/04/09 By Rayven 不使用特性BOM時不打印計算方式
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-710089 07/02/02 By Ray Crystal Report修改
# Modify.........: No.TQC-730088 07/03/22 By Nicole 增加CR參數
# Modify.........: No.FUN-750057 07/05/24 By Sarah 增加列印規格(ima021)
# Modify.........: No.CHI-7A0012 07/10/05 By Sarah 若ECN變更單有輸入備註，列印時資料會異常
# Modify.........: No.FUN-940041 09/05/04 By TSD.Ken 在CR報表列印簽核欄
# Modify.........: No.TQC-960269 09/06/23 By destiny 修改選取資料的sql，使abmi710無單身的資料也可以打印
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9C0054 10/02/26 By vealxu 新增申請部門，申請人欄位
# Modify.........: No.CHI-A40033 10/04/26 By liuxqa modify slq
# Modify.........: No.FUN-A60012 10/06/03 By vealxu 新增列印BOM類別欄位 
# Modify.........: No.TQC-AC0173 10/12/14 By vealxu BOM類別,申請部門沒有資料
# Modify.........: No:MOD-AC0408 10/12/30 By sabrina 改寫r710_c0的sql 
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 12/01/06 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C10034 12/01/16 By zhuhao 簽核處理 
# Modify.........: No.FUN-E50024 14/05/08 By sabrina GR還原CR
# Modify.........: No.FUN-E50052 14/05/20 By SunLM 報表欄位15欄增加至40欄
# Modify.........: NO.23020015   20230209 By momo 增加顯示 ta_bmx03 ECN 變更原因 azf03

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		wc  	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
		b     LIKE type_file.chr1,     #FUN-E50052 add
      type  LIKE type_file.chr1,    #No.FUN-A60012 VARCHAR(1)
      more	LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD
        # g_argv1 LIKE bmx_file.bmx01           #FUN-550095  #TQC-610068
 
DEFINE   g_cnt    LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_i      LIKE type_file.num5    #count/index for any purpose   #No.FUN-680096 SMALLINT
#No.FUN-710089 --begin
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_table1   STRING   #CHI-7A0012 add
DEFINE  l_table2   STRING   #CHI-7A0012 add
DEFINE  l_table3   STRING   #CHI-7A0012 add
DEFINE  g_str      STRING
#No.FUN-710089 --end
#FUN-E50052--add--str--
DEFINE  l_table4   STRING
DEFINE  l_table5   STRING
DEFINE  l_table6   STRING
DEFINE  l_table7   STRING
DEFINE  g_count    LIKE type_file.num5
#FUN-E50052--add--end

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107 #FUN-BB0047 mark
 
 
   INITIALIZE tm.* TO NULL			# Default condition
  #TQC-610068-begin
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
  #TQC-AC0173 ---------mod start-------------
   LET tm.type = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)
   LET tm.b    = ARG_VAL(13) #FUN-E50052
  #LET g_rep_user = ARG_VAL(8)
  #LET g_rep_clas = ARG_VAL(9)
  #LET g_template = ARG_VAL(10)
  #TQC-AC0173 ---------mod end---------------
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(2)
   #LET g_rep_clas = ARG_VAL(3)
   #LET g_template = ARG_VAL(4)
   LET g_rpt_name = ARG_VAL(5)  #No.FUN-7C0078
  #LET tm.type = ARG_VAL(11)     #No.FUN-A60012 add    #TQC-AC0173 mark
   ##No.FUN-570264 ---end---
  #TQC-610068-end
#No.FUN-710089 --begin
   LET g_sql ="bmx01.bmx_file.bmx01,",
              "bmx02.bmx_file.bmx02,",
              "bmx05.bmx_file.bmx05,",
              "bmx07.bmx_file.bmx07,",
              "azf03.azf_file.azf03,",     #20230209 ECN原因說明
              "gen02.gen_file.gen02,",     #CHI-9C0054
              "gem02.gem_file.gem02,",     #CHI-9C0054
              "bmy01.bmy_file.bmy01,",
              "bmy02.bmy_file.bmy02,",
              "bmy03.bmy_file.bmy03,",
              "bmy04.bmy_file.bmy04,",
              "bmy05.bmy_file.bmy05,",
              "bmy06.bmy_file.bmy06,",
              "bmy07.bmy_file.bmy07,",
              "bmy16.bmy_file.bmy16,",
              "bmy19.bmy_file.bmy19,",
              "bmy27.bmy_file.bmy27,",
              "bmy30.bmy_file.bmy30,",
              "bmystr.type_file.chr1000,",
              "ima02_2.ima_file.ima02,",
              "ima021_2.ima_file.ima021,",   #FUN-750057 add
              "ima25.ima_file.ima25,",
             #"bmg03.bmg_file.bmg03,",       #CHI-7A0012 mark
             #"bmz02.bmz_file.bmz02,",       #CHI-7A0012 mark
             #"bmz03.bmz_file.bmz03,",       #CHI-7A0012 mark
             #"bmz05.bmz_file.bmz05,",       #CHI-7A0012 mark
             #"ima02.ima_file.ima02,",       #CHI-7A0012 mark
             #"ima021.ima_file.ima021,",     #CHI-7A0012 mark
              "ima02_3.ima_file.ima02,", 
              "ima021_3.ima_file.ima021"     #FUN-750057 add
             ,",sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #FUN-940041
              "sign_show.type_file.chr1,"                               #是否顯示簽核資料(Y/N)  #FUN-940041
              ,"sign_str.type_file.chr1000"         #TQC-C10034 add
   LET l_table = cl_prt_temptable('abmr710',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
  #str CHI-7A0012 add
   #工程變異單主件
   LET g_sql ="bmx01.bmx_file.bmx01,",
              "bmz02.bmz_file.bmz02,",
              "bmz03.bmz_file.bmz03,",
              "bmz05.bmz_file.bmz05,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021"
   LET l_table1 = cl_prt_temptable('abmr7101',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   #備註
   LET g_sql ="bmx01.bmx_file.bmx01,",
              "bmg02.bmg_file.bmg02,",
              "bmg03.bmg_file.bmg03"
   LET l_table2 = cl_prt_temptable('abmr7102',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   #插件位置
   LET g_sql ="bmx01.bmx_file.bmx01,",
              "bmy02.bmy_file.bmy02,",
              "bmw03.bmw_file.bmw03,",
              "bmw04.bmw_file.bmw04,",
              "bmw05.bmw_file.bmw05"
   LET l_table3 = cl_prt_temptable('abmr7103',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
  #end CHI-7A0012 add
   ##FUN-E50052--add--str--
   LET g_sql="bmya01.bmya_file.bmya01, bmya02.bmya_file.bmya02,",
             "bmya04.agd_file.agd03,",
             "bmya05.agd_file.agd03 "
   LET l_table4 = cl_prt_temptable('abmr7104',g_sql) CLIPPED
   IF l_table4 = -1 THEN EXIT PROGRAM END IF

   LET g_sql="bmyb01.bmyb_file.bmyb01, bmyb02.bmyb_file.bmyb02,",
             "bmyb04.agd_file.agd03,",
             "bmyb05.agd_file.agd03 "  
   LET l_table5 = cl_prt_temptable('abmr7105',g_sql) CLIPPED             
   IF l_table5 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql="bmyc01.bmyc_file.bmyc01, bmyc02.bmyc_file.bmyc02,",
             "bmyc04.agd_file.agd03"
   LET l_table6 = cl_prt_temptable('abmr7106',g_sql) CLIPPED                                 
   IF l_table6 = -1 THEN EXIT PROGRAM END IF

   LET g_sql="bmyd01.bmyd_file.bmyd01, bmyd02.bmyd_file.bmyd02,",
             "bmyd04.agd_file.agd03"
   LET l_table7 = cl_prt_temptable('abmr7107',g_sql) CLIPPED
   IF l_table7 = -1 THEN EXIT PROGRAM END IF
   ##FUN-E50052--add--end--
#No.FUN-710089 --end
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
  #TQC-610068-begin
   #IF cl_null(g_argv1)
   #   THEN CALL r710_tm()	             	# Input print condition
   #   ELSE LET tm.wc=" bmx01='",g_argv1,"'"
   #        CALL r710()		          	# Read data and create out-file
   #END IF
   #TQC-630177-begin
   #IF cl_null(tm.wc) THEN
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off
   #TQC-630177-end
      LET tm.more = 'N'
      LET g_pdate = g_today
      LET g_rlang = g_lang
      LET g_bgjob = 'N'
      LET g_copies = '1'
      CALL r710_tm()	             	        # Input print condition
   ELSE
     #LET tm.wc=" bmx01='",tm.wc,"'"            #TQC-630177 
      CALL r710()		          	# Read data and create out-file
   END IF
  #TQC-610068-end
  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r710_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE l_cmd		LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(1000)
          p_row,p_col   LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 8 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 18
   END IF
 
   OPEN WINDOW r710_w AT p_row,p_col
        WITH FORM "abm/42f/abmr710"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   CALL cl_set_comp_visible("group",g_sma.sma541 = 'Y')    #No.FUN-A60012 add 
   LET tm.type = '1'                                       #No.FUN-A60012 default value 
   #FUN-E50052--add--str--
   IF s_industry("slk") AND g_sma.sma150='Y' THEN
      CALL cl_set_comp_visible("b",TRUE)
      LET tm.b='Y'
   ELSE
      CALL cl_set_comp_visible("b",FALSE)
      LET tm.b='N'
   END IF
   #FUN-E50052--add--end   
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bmx01,bmx02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#FUN-4A0037新增開窗功能
   ON ACTION CONTROLP
      CALL cl_init_qry_var()
      LET g_qryparam.state = "c"
      LET g_qryparam.form = "q_bmx1"
      CALL cl_create_qry() RETURNING g_qryparam.multiret
      DISPLAY g_qryparam.multiret TO bmx01
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r710_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.b,tm.type,tm.more WITHOUT DEFAULTS    #No.FUN-A60012 add tm.type #FUN-E50052--add tm.b
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      #FUN-E50052--add--str--
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
      #FUN-E50052--add--end         
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW r710_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr710'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr710','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")   #"
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",               #No.FUN-A60012                         
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.b CLIPPED,"'"                 #FUN-E50052
         CALL cl_cmdat('abmr710',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r710_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r710()
   ERROR ""
END WHILE
   CLOSE WINDOW r710_w
END FUNCTION
 
FUNCTION r710()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT        #No.FUN-680096 VARCHAR(1000)
          l_bmg02       LIKE bmg_file.bmg02,    #No.CHI-7A0012 add
          l_bmg03       LIKE bmg_file.bmg03,    #No.FUN-710089
          l_bmw04       LIKE bmw_file.bmw04,    #No.FUN-710089
          l_bmw05       LIKE bmw_file.bmw05,    #No.FUN-710089
          l_bmz02       LIKE bmz_file.bmz02,    #No.FUN-710089
          l_bmz03       LIKE bmz_file.bmz03,    #No.FUN-710089
          l_bmz05       LIKE bmz_file.bmz05,    #No.FUN-710089
          l_ima02       LIKE ima_file.ima02,    #No.FUN-710089
          l_ima02_1     LIKE ima_file.ima02,    #No.FUN-710089
          l_ima021_1    LIKE ima_file.ima021,   #No.FUN-750057 add
          l_ima021      LIKE ima_file.ima021,   #No.FUN-710089
          l_order	ARRAY[5] OF LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(20)
#No.FUN-710089 --begin
#         bmx		RECORD LIKE bmx_file.*, 
#         bmy		RECORD LIKE bmy_file.*,
#         ima		RECORD LIKE ima_file.*
          bmw		RECORD LIKE bmw_file.*,    #CHI-7A0012 add
          sr               RECORD
                                   bmx01  LIKE bmx_file.bmx01,
                                   bmx02  LIKE bmx_file.bmx02,
                                   bmx05  LIKE bmx_file.bmx05,
                                   bmx07  LIKE bmx_file.bmx07,
                                   azf03  LIKE azf_file.azf03,         #20230209 add ECN變更原因
                                   gen02  LIKE gen_file.gen02,         #CHI-9C0054 add
                                   gem02  LIKE gem_file.gem02,         #CHI-9C0054 add
                                   bmy01  LIKE bmy_file.bmy01,
                                   bmy02  LIKE bmy_file.bmy02,
                                   bmy03  LIKE bmy_file.bmy03,
                                   bmy04  LIKE bmy_file.bmy04,
                                   bmy05  LIKE bmy_file.bmy05,
                                   bmy06  LIKE bmy_file.bmy06,
                                   bmy07  LIKE bmy_file.bmy07,
                                   bmy16  LIKE bmy_file.bmy16,
                                   bmy19  LIKE bmy_file.bmy19,
                                   bmy27  LIKE bmy_file.bmy27,
                                   bmy30  LIKE bmy_file.bmy30,
                                   bmystr LIKE type_file.chr1000,
                                   ima02  LIKE ima_file.ima02,
                                   ima021 LIKE ima_file.ima021,   #FUN-750057 add
                                   ima25  LIKE ima_file.ima25
                           END RECORD
#No.FUN-710089 --end
 
   ###FUN-940041 START ###
   DEFINE l_img_blob     LIKE type_file.blob
#TQC-C10034--mark--begin
  #DEFINE l_ii           INTEGER
  #DEFINE l_key          RECORD                  #主鍵
  #          v1          LIKE bmx_file.bmx01
  #          END RECORD
#TQC-C10034--mark--end
   ###FUN-940041 END ###
#FUN-E50052----add----star----
   DEFINE  bmya          RECORD LIKE bmya_file.*
   DEFINE  bmyb          RECORD LIKE bmyb_file.*
   DEFINE  bmyc          RECORD LIKE bmyc_file.*
   DEFINE  bmyd          RECORD LIKE bmyd_file.*
   DEFINE l_bmya04  LIKE agd_file.agd03
   DEFINE l_bmya05  LIKE agd_file.agd03
   DEFINE l_bmyb04  LIKE agd_file.agd03
   DEFINE l_bmyb05  LIKE agd_file.agd03
   DEFINE l_bmyc04  LIKE agd_file.agd03
   DEFINE l_bmyd04  LIKE agd_file.agd03
#FUN-E50052----add-----end---
 
   CALL cl_del_data(l_table)     #No.FUN-710089
   CALL cl_del_data(l_table1)    #CHI-7A0012 add
   CALL cl_del_data(l_table2)    #CHI-7A0012 add
   CALL cl_del_data(l_table3)    #CHI-7A0012 add
   CALL cl_del_data(l_table4)    #FUN-E50052 add
   CALL cl_del_data(l_table5)    #FUN-E50052 add
   CALL cl_del_data(l_table6)    #FUN-E50052 add
   CALL cl_del_data(l_table7)    #FUN-E50052 add
   
   LOCATE l_img_blob IN MEMORY   #blob初始化   #FUN-940041
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
  #str CHI-7A0012 add
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,",        #CHI-9C0054  add ? ?
               "        ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?)" #,?,?,?,?, ?,?,?)"  #FUN-750057 add ?,? #CHI-7A0012 mod #FUN-940041 加3個?  #TQC-C10034 add ? #20230209 add 1?
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF
 
   #工程變異單主件
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF

 
   #備註
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF

 
   #插件位置
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep3:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF
 #FUN-E50052-------star-----add----
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
               " VALUES(?,?,?,?)"
   PREPARE insert_prep4 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep4:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
               " VALUES(?,?,?,?)"
   PREPARE insert_prep5 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep5:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table6 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep6 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep6:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table7 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep7 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep7:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   LET l_sql =  "SELECT * FROM bmya_file ",
                " WHERE bmya01=? AND bmya02=? ",
                " ORDER BY bmya03 "
   PREPARE r710_prepare4 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare4:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r710_c4 CURSOR FOR r710_prepare4

   LET l_sql =  "SELECT * FROM bmyb_file ",
                " WHERE bmyb01=? AND bmyb02=? ",
                " ORDER BY bmyb03 "
   PREPARE r710_prepare5 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare5:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r710_c5 CURSOR FOR r710_prepare5

   LET l_sql =  "SELECT * FROM bmyc_file ",
                " WHERE bmyc01=? AND bmyc02=? ",
                " ORDER BY bmyc03 "
   PREPARE r710_prepare6 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare6:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r710_c6 CURSOR FOR r710_prepare6

   LET l_sql =  "SELECT * FROM bmyd_file ",
                " WHERE bmyd01=? AND bmyd02=? ",
                " ORDER BY bmyd03 "
   PREPARE r710_prepare7 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare7:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r710_c7 CURSOR FOR r710_prepare7
#FUN-E50052----add---end---- 
  #end CHI-7A0012 add
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND bmxuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND bmxgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND bmxgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmxuser','bmxgrup')   
   #End:FUN-980030
  #MOD-AC0408---modify---start--- 
  #LET l_sql = "SELECT bmx01,bmx02,bmx05,bmx07,'','',bmy01,bmy02,bmy03,bmy04,bmy05,bmy06,bmy07,bmy16, ",     #CHI-9C0054 add 2'' 
  #            "       bmy19,bmy27,bmy30,'',ima02,ima021,ima25  ",   #FUN-750057 add ima021
  #           #"  FROM bmx_file bmy_file OUTER ima_file",          #NO.TQC-960269 
  #            "  FROM bmx_file, bmy_file, ima_file",    #NO.TQC-960269  
  #           #" WHERE bmx01=bmy01(+) AND bmy05=ima01(+) ",    #No.CHI-9C0054  mark     
  #            " WHERE bmx01 = bmy01 AND bmy05 = ima01 ",      #No.CHI-9C0054  add      
  #            "   AND bmx04 <> 'X' AND ",tm.wc CLIPPED,
  #            "   AND bmx06 = '1' " #FUN-550095 add  
   LET l_sql = "SELECT bmx01,bmx02,bmx05,bmx07,'','','',bmy01,bmy02,bmy03,bmy04,bmy05,bmy06,bmy07,bmy16, ",   #20230209 modify ''
               "       bmy19,bmy27,bmy30,'',ima02,ima021,ima25  ",   
               "  FROM bmx_file LEFT OUTER JOIN bmy_file ON bmx01=bmy01 ",
               "                LEFT OUTER JOIN ima_file ON bmy_file.bmy05=ima01 ",  
               " WHERE bmx04 <> 'X' AND ",tm.wc CLIPPED,
               "   AND bmx06 = '1' " 
  #MOD-AC0408---modify---end---
   #No.FUN-A60012 -------start-------------
   CASE
      WHEN tm.type = '1'
         LET l_sql = l_sql," AND bmx50 = '1'"     
      WHEN tm.type = '2'
          LET l_sql = l_sql," AND bmx50 = '2'"
       WHEN tm.type = '3'
          LET l_sql = l_sql CLIPPED
   END CASE
   #No.FUN-A60012 --------end--------------
   PREPARE r710_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM 
   END IF
   DECLARE r710_c0 CURSOR FOR r710_prepare1
 
#  CALL cl_outnam('abmr710') RETURNING l_name     #No.FUN-710089
#  START REPORT r710_rep TO l_name     #No.FUN-710089
 
#  LET g_pageno = 0  #MOD-530217
   FOREACH r710_c0 INTO sr.*
      IF STATUS THEN CALL cl_err('for bmx:',STATUS,1) EXIT FOREACH END IF

#No.CHI-9C0054 ---start---
      SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01 
          IN (SELECT bmx10 FROM bmx_file WHERE bmx01 = sr.bmx01)
      IF SQLCA.sqlcode THEN LET sr.gen02 = ' ' END IF 

     #SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem02       #TQC-AC0173 mark
      SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01       #TQC-AC0173
          IN (SELECT bmx13 FROM bmx_file WHERE bmx01 = sr.bmx01)
      IF SQLCA.sqlcode THEN  LET sr.gem02 = ' ' END IF 
#No.CHI-9C0054 ---end---

     ##--- 20230209 add ECN變更原因(S)
     SELECT azf03 INTO sr.azf03 
       FROM azf_file,bmx_file
      WHERE azf01 = ta_bmx03
        AND azf02='2' AND azf09='G'
        AND bmx01 = sr.bmx01
     ##--- 20230209 add ECN變更原因(E)

#No.FUN-710089 --begin
      SELECT ima02,ima021 INTO l_ima02_1,l_ima021_1 FROM ima_file   #FUN-750057 add ima021
       WHERE ima01 = sr.bmy27
 
      #插件位置
      DECLARE r710_c3 CURSOR FOR
        #SELECT bmw04,bmw05 FROM bmw_file   #CHI-7A0012 mark
         SELECT * FROM bmw_file             #CHI-7A0012
          WHERE bmw01=sr.bmy01 AND bmw02=sr.bmy02
          ORDER BY bmw03
      LET sr.bmystr=NULL
     #FOREACH r710_c3 INTO l_bmw04,l_bmw05  #CHI-7A0012 mark
      FOREACH r710_c3 INTO bmw.*            #CHI-7A0012
         IF STATUS THEN CALL cl_err('for bmy:',STATUS,1) EXIT FOREACH END IF
        #str CHI-7A0012 mod
        #LET sr.bmystr=sr.bmystr CLIPPED,' ',
        #              l_bmw04 CLIPPED,'*',l_bmw05 USING '<<<<'
         EXECUTE insert_prep3 USING
            sr.bmy01,sr.bmy02,bmw.bmw03,bmw.bmw04,bmw.bmw05
       #end CHI-7A0012 mod
      END FOREACH
#FUN-E50052----add----star----
      IF tm.b='Y' THEN
         FOREACH r710_c4 USING sr.bmy01,sr.bmy02  INTO bmya.*  
            IF STATUS THEN CALL cl_err('for bmy:',STATUS,1) EXIT FOREACH END IF
            CALL r710_agd03_d(sr.bmy05,bmya.bmya04,'1') RETURNING l_bmya04
            CALL r710_agd03_d(sr.bmy05,bmya.bmya05,'1') RETURNING l_bmya05
            EXECUTE insert_prep4 USING
               sr.bmy01,sr.bmy02,l_bmya04,l_bmya05
         END FOREACH
         FOREACH r710_c5 USING sr.bmy01,sr.bmy02  INTO bmyb.*
            IF STATUS THEN CALL cl_err('for bmy:',STATUS,1) EXIT FOREACH END IF
            CALL r710_agd03_d(sr.bmy05,bmyb.bmyb04,'2') RETURNING l_bmyb04
            CALL r710_agd03_d(sr.bmy05,bmyb.bmyb05,'2') RETURNING l_bmyb05
            EXECUTE insert_prep5 USING
               sr.bmy01,sr.bmy02,l_bmyb04,l_bmyb05
         END FOREACH
         FOREACH r710_c6 USING sr.bmy01,sr.bmy02  INTO bmyc.*
            IF STATUS THEN CALL cl_err('for bmy:',STATUS,1) EXIT FOREACH END IF
            CALL r710_agd03_d(sr.bmy05,bmyc.bmyc04,'1') RETURNING l_bmyc04
            EXECUTE insert_prep6 USING
               sr.bmy01,sr.bmy02,l_bmyc04
         END FOREACH
         FOREACH r710_c7 USING sr.bmy01,sr.bmy02  INTO bmyd.*
            IF STATUS THEN CALL cl_err('for bmy:',STATUS,1) EXIT FOREACH END IF
            CALL r710_agd03_d(sr.bmy05,bmyd.bmyd04,'1') RETURNING l_bmyd04
            EXECUTE insert_prep7 USING
               sr.bmy01,sr.bmy02,l_bmyd04
         END FOREACH
      END IF
#FUN-E50052----add----end---- 
     #str CHI-7A0012 mod
     #IF cl_null(l_bmg03) AND cl_null(l_bmz02) AND  cl_null(l_bmz03) and cl_null(l_bmz05) THEN
     #   EXECUTE insert_prep USING 
     #      sr.*,'',l_bmz02,l_bmz03,l_bmz05,l_ima02,l_ima021,
     #      l_ima02_1,l_ima021_1   #FUN-750057 add l_ima021_1
     #END IF
      EXECUTE insert_prep USING 
         sr.*,l_ima02_1,l_ima021_1   #FUN-750057 add l_ima021_1
         ,"",l_img_blob,"N",""          #FUN-940041  #TQC-C10034 add
     #end CHI-7A0012 mod
 
#      OUTPUT TO REPORT r710_rep(bmx.*, bmy.*, ima.*)
#No.FUN-710089 --end
   END FOREACH
 
  #str CHI-7A0012 add
   LET l_sql = "SELECT bmx01 FROM bmx_file ",
               " WHERE bmx04 <> 'X' AND ",tm.wc CLIPPED,
               "   AND bmx06 = '1' ",       #FUN-550095 add
               " ORDER BY bmx01"
   PREPARE r701_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
   CALL cl_err('prepare2:',SQLCA.sqlcode,1)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
   EXIT PROGRAM
   END IF
   DECLARE r701_cs2 CURSOR FOR r701_prepare2
   
   FOREACH r701_cs2 INTO sr.bmx01
      #備註
      DECLARE r710_c1 CURSOR FOR
        #SELECT bmg03 FROM bmg_file WHERE bmg01=sr.bmx01 ORDER BY bmg02         #CHI-7A0012 mark
         SELECT bmg02,bmg03 FROM bmg_file WHERE bmg01=sr.bmx01 ORDER BY bmg02   #CHI-7A0012
     #FOREACH r710_c1 INTO l_bmg03           #071003 mark
      FOREACH r710_c1 INTO l_bmg02,l_bmg03   #071003
         IF STATUS THEN CALL cl_err('for bmg:',STATUS,1) EXIT FOREACH END IF
        #str CHI-7A0012 mod
        #EXECUTE insert_prep USING 
        #   sr.*,l_bmg03,'','','','','',l_ima02_1,l_ima021_1   #FUN-750057 add l_ima021_1   
         EXECUTE insert_prep2 USING sr.bmx01,l_bmg02,l_bmg03
        #end CHI-7A0012 mod
      END FOREACH
 
      #工程變異單主件
      DECLARE r710_c2 CURSOR FOR
         SELECT bmz02,bmz03,bmz05,ima02,ima021 FROM bmz_file, ima_file
          #WHERE bmz01=sr.bmx01 AND bmz02=ima_file.ima    #CHI-A40033 mark
          WHERE bmz01=sr.bmx01 AND bmz02=ima_file.ima01   #CHI-A40033 mod
          ORDER BY bmz02
      LET l_bmz02 = NULL
      LET l_bmz03 = NULL
      LET l_bmz05 = NULL
      LET l_ima02 = NULL
      LET l_ima021 = NULL
      FOREACH r710_c2 INTO  l_bmz02,l_bmz03,l_bmz05,l_ima02,l_ima021
         IF STATUS THEN CALL cl_err('for bmz:',STATUS,1) EXIT FOREACH END IF
        #str CHI-7A0012 mod
        #EXECUTE insert_prep USING 
        #   sr.*,'',l_bmz02,l_bmz03,l_bmz05,l_ima02,l_ima021,
        #   l_ima02_1,l_ima021_1   #FUN-750057 add l_ima021_1
         EXECUTE insert_prep1 USING 
            sr.bmx01,l_bmz02,l_bmz03,l_bmz05,l_ima02,l_ima021
        #end CHI-7A0012 mod
      END FOREACH
   END FOREACH
  #end CHI-7A0012 add
 
#No.FUN-710089 --begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'bmx01,bmx02')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05,";",tm.type,";",tm.b     #No.FUN-A60012 add tm.type #FUN-E50052 add tm.b
 
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED    #TQC-730088
    #str CHI-7A0012 mod
    #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table3 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table4 CLIPPED,"|", #FUN-E50052 ADD
                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table5 CLIPPED,"|", #FUN-E50052 ADD
                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table6 CLIPPED,"|", #FUN-E50052 ADD
                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table7 CLIPPED     #FUN-E50052 ADD
    #end CHI-7A0012 mod
 
   # CALL cl_prt_cs3('abmr710',l_sql,g_str)          #TQC-730088
 
    ###FUN-940041 START ###
    LET g_cr_table = l_table                 #主報表的temp table名稱
   #LET g_cr_gcx01 = "asmi300"               #單別維護程式   #TQC-C10034 mark
    LET g_cr_apr_key_f = "bmx01"             #報表主鍵欄位名稱，用"|"隔開 
#TQC-C10034--mark--begin
   #LET g_sql = "SELECT DISTINCT bmx01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #PREPARE key_pr FROM g_sql
   #DECLARE key_cs CURSOR FOR key_pr
   #LET l_ii = 1
   ##報表主鍵值
   #CALL g_cr_apr_key.clear()                #清空
   #FOREACH key_cs INTO l_key.*            
   #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
   #   LET l_ii = l_ii + 1
   #END FOREACH
   ####FUN-940041 END ###
#TQC-C10034--mark--end
 
     CALL cl_prt_cs3('abmr710','abmr710',l_sql,g_str)
#    FINISH REPORT r710_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-710089 --end

END FUNCTION 

#No.FUN-710089 --begin
#REPORT r710_rep(bmx, bmy, ima)
#   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
#          l_type        LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#          l_buf		LIKE type_file.chr20,   #MOD-5C0160 4->10        #No.FUN-680096 VARCHAR(10)
#          l_str		LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(400)
#          l_ima02       LIKE ima_file.ima02,    #MOD-4A0086(1)
#          bmx		RECORD LIKE bmx_file.*,
#          bmy		RECORD LIKE bmy_file.*,
#          bmz		RECORD LIKE bmz_file.*,
#          bmg		RECORD LIKE bmg_file.*,
#          bmw		RECORD LIKE bmw_file.*,
#          ima		RECORD LIKE ima_file.*,
#          ima2		RECORD LIKE ima_file.*
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#
#  ORDER BY bmx.bmx01
#  FORMAT
#    PAGE HEADER
##No.FUN-590110 --start--
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
##No.FUN-590110 --end--
#      PRINT g_x[11] CLIPPED,bmx.bmx01, COLUMN 30,g_x[12] CLIPPED,bmx.bmx02
#      PRINT g_x[13] CLIPPED,bmx.bmx05, COLUMN 30,g_x[14] CLIPPED,bmx.bmx07
#      PRINT g_dash2   #No.FUN-590110
#    BEFORE GROUP OF bmx.bmx01
#      SKIP TO TOP OF PAGE
#      #----------------------------------------------------------------------
#      DECLARE r710_c1 CURSOR FOR
#         SELECT * FROM bmg_file WHERE bmg01=bmx.bmx01 ORDER BY bmg02
#      LET g_cnt=0
#      FOREACH r710_c1 INTO bmg.*
#         IF STATUS THEN CALL cl_err('for bmg:',STATUS,1) EXIT FOREACH END IF
#         LET g_cnt=g_cnt+1
#         IF g_cnt=1 THEN PRINT g_x[16] CLIPPED END IF
#         PRINT COLUMN 10,bmg.bmg03 CLIPPED
#      END FOREACH
#      IF g_cnt>0 THEN PRINT g_dash2 END IF  #No.FUN-590110
#      #----------------------------------------------------------------------
#      DECLARE r710_c2 CURSOR FOR
#         SELECT bmz_file.*,ima_file.* FROM bmz_file, OUTER ima_file
#              WHERE bmz01=bmx.bmx01 AND bmz02=ima_file.ima01
#              ORDER BY bmz02
#      LET g_cnt=0
#      FOREACH r710_c2 INTO bmz.*, ima2.*
#         IF STATUS THEN CALL cl_err('for bmz:',STATUS,1) EXIT FOREACH END IF
#         LET g_cnt=g_cnt+1
#       #TQC-610131-begin
#       # IF g_cnt=1
#       #  #FUN-5A0142-begin
#       #  # THEN PRINT COLUMN  1, g_x[17] CLIPPED,COLUMN 10, bmz.bmz02,' ',bmz.bmz05, #FUN-550095
#       #  #            COLUMN 49, g_x[18] CLIPPED,COLUMN 54, ima2.ima02,
#       #  #            COLUMN 110,g_x[19] CLIPPED,COLUMN 119,bmz.bmz03
#       #  # ELSE PRINT COLUMN 10, bmz.bmz02 CLIPPED,' ',bmz.bmz05 CLIPPED,
#       #  #            COLUMN 54, ima2.ima02 CLIPPED,
#       #  #            COLUMN 119,bmz.bmz03
#       #  #
#       #  # #FUN-550095(end)
#       #   THEN PRINT COLUMN  1, g_x[17] CLIPPED,COLUMN 10, bmz.bmz02,' ',bmz.bmz05 #FUN-550095
#       #        PRINT COLUMN  5, g_x[18] CLIPPED,COLUMN 10, ima2.ima02,
#       #              COLUMN 71, g_x[19] CLIPPED,COLUMN 80,bmz.bmz03
#       #        PRINT COLUMN  5, g_x[42] CLIPPED,COLUMN 10, ima2.ima021
#       #   ELSE PRINT COLUMN 10, bmz.bmz02 CLIPPED,' ',bmz.bmz05 CLIPPED
#       #        PRINT COLUMN 10, ima2.ima02 CLIPPED,
#       #              COLUMN 80,bmz.bmz03
#       #  #FUN-5A0142-end
#       # END IF
#       ##FUN-5A0142-begin
#       ##IF NOT cl_null(ima2.ima021) THEN PRINT COLUMN 54,ima2.ima021 CLIPPED END IF #FUN-550095
#       # IF NOT cl_null(ima2.ima021) THEN PRINT COLUMN 10,ima2.ima021 CLIPPED END IF #FUN-550095
#       ##FUN-5A0142-end
#       PRINT COLUMN  1, g_x[17] CLIPPED,COLUMN 10, bmz.bmz02,' ',bmz.bmz05 #FUN-550095
#       PRINT COLUMN  5, g_x[18] CLIPPED,COLUMN 10, ima2.ima02,
#             COLUMN 71, g_x[19] CLIPPED,COLUMN 80,bmz.bmz03
#       IF NOT cl_null(ima2.ima021) THEN
#          PRINT COLUMN  5, g_x[42] CLIPPED,COLUMN 10, ima2.ima021
#       END IF
#       #TQC-610131-end
#      END FOREACH
#      IF g_cnt>0 THEN PRINT g_dash[1,g_len] END IF   #No.FUN-590110
#      #----------------------------------------------------------------------
##No.FUN-590110 --start--
#     #FUN-5A0142-begin
#      #PRINTX name=H1
#      #      g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#      #      g_x[39],g_x[40],g_x[41]
#      IF g_sma.sma118 = 'Y' THEN   #No.MOD-640178
#         PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[37],g_x[38],
#                        g_x[39],g_x[40],g_x[41]
#      #No.MOD-640178  --start--
#      ELSE
#         PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[38],
#                        g_x[39],g_x[40],g_x[41]
#      END IF
#      #No.MOD-640178  --end--
#      PRINTX name=H2 g_x[43],g_x[35]
#      PRINTX name=H3 g_x[44],g_x[36]
#     #FUN-5A0142-end
#      PRINT g_dash1
##No.FUN-590110 --end--
#      LET l_last_sw = 'n'
#
#   ON EVERY ROW
#      #FUN-550095 add
#      CASE WHEN bmy.bmy30='1' LET l_type=bmy.bmy30,'.',g_x[26] CLIPPED #固定
#           WHEN bmy.bmy30='2' LET l_type=bmy.bmy30,'.',g_x[27] CLIPPED #變動
#           WHEN bmy.bmy30='3' LET l_type=bmy.bmy30,'.',g_x[28] CLIPPED #公式
#           OTHERWISE          LET l_type=' '
#      END CASE
#      #FUN-550095(end)
#      LET l_buf=r710_bmy03(bmy.bmy03)
##No.FUN-590110 --start--
#     #FUN-5A0142-begin
#     #PRINT COLUMN g_c[31],bmy.bmy02 USING '####',
#     #      COLUMN g_c[32],bmy.bmy03 CLIPPED,'.',l_buf CLIPPED,
#     #      COLUMN g_c[33],bmy.bmy19 CLIPPED,
#     #      COLUMN g_c[34],bmy.bmy04 USING '####',
#     #      COLUMN g_c[35],bmy.bmy05 CLIPPED,
#     #      COLUMN g_c[36],ima.ima02 CLIPPED,
#     #      COLUMN g_c[37],l_type CLIPPED,
#     #      COLUMN g_c[38],ima.ima25 CLIPPED,
#     #      COLUMN g_c[39],bmy.bmy16 CLIPPED,'.';
#      IF g_sma.sma118 = 'Y' THEN  #No.MOD-640178
#         PRINTX name=D1 COLUMN g_c[31],bmy.bmy02 USING '####',
#                        COLUMN g_c[32],bmy.bmy03 CLIPPED,'.',l_buf CLIPPED,
#                        COLUMN g_c[33],bmy.bmy19 CLIPPED,
#                        COLUMN g_c[34],bmy.bmy04 USING '####',
#                        COLUMN g_c[37],l_type CLIPPED,
#                        COLUMN g_c[38],ima.ima25 CLIPPED,
#                        COLUMN g_c[39],bmy.bmy16 CLIPPED,'.';
#      #No.MOD-640178  --start--
#      ELSE 
#         PRINTX name=D1 COLUMN g_c[31],bmy.bmy02 USING '####',
#                        COLUMN g_c[32],bmy.bmy03 CLIPPED,'.',l_buf CLIPPED,
#                        COLUMN g_c[33],bmy.bmy19 CLIPPED,
#                        COLUMN g_c[34],bmy.bmy04 USING '####',
#                        COLUMN g_c[38],ima.ima25 CLIPPED,
#                        COLUMN g_c[39],bmy.bmy16 CLIPPED,'.';
#      END IF
#      #No.MOD-640178  --end--
#     # FUN-5A0142-end
#            #start FUN-5A0010
#            #CASE WHEN bmy.bmy16='0' PRINT 'NO ';
#            #     WHEN bmy.bmy16='1' PRINT 'UTE';
#           #     WHEN bmy.bmy16='2' PRINT 'SUB';
#           #     OTHERWISE          PRINT '   ';
#           #END CASE
#            CASE
#               WHEN bmy.bmy16='0'  #NO  - 不可取替代
#                    CALL cl_getmsg('abm-815',g_lang) RETURNING l_str
#               WHEN bmy.bmy16='1'  #UTE - 取代
#                    CALL cl_getmsg('abm-816',g_lang) RETURNING l_str
#               WHEN bmy.bmy16='2'  #SUB - 替代
#                    CALL cl_getmsg('abm-817',g_lang) RETURNING l_str
#               WHEN bmy.bmy16='5'  #SET SUB - SET替代
#                    CALL cl_getmsg('abm-818',g_lang) RETURNING l_str
#               OTHERWISE
#                    LET l_str='   '
#            END CASE
#            PRINT l_str;
#           #end FUN-5A0010
#            PRINT COLUMN g_c[40],bmy.bmy06 USING '----------&.&&&',
#                  COLUMN g_c[41],bmy.bmy07 USING '-----------'
#     # FUN-5A0142
#      PRINTX name=D2 COLUMN g_c[35],bmy.bmy05 CLIPPED
#      PRINTX name=D3 COLUMN g_c[36],ima.ima02 CLIPPED
#     # FUN-5A0142-end
##No.FUN-590110 --end--
#     #MOD-4A0086(1)
#      IF bmy.bmy03 = '4' THEN #取代
##No.FUN-590110 --start--
#     # FUN-5A0142-begin
#     #    PRINT COLUMN g_c[34],g_x[23] CLIPPED,
#     #          COLUMN g_c[35],bmy.bmy27 CLIPPED
#          PRINTX name=D1 COLUMN g_c[31],g_x[23] CLIPPED
#          PRINTX name=D2 COLUMN g_c[35],bmy.bmy27 CLIPPED
#     # FUN-5A0142-end
##No.FUN-590110 --end--
#          SELECT ima02 INTO l_ima02 FROM ima_file
#           WHERE ima01 = bmy.bmy27
##         PRINT COLUMN 29,l_ima02  CLIPPED
#     # FUN-5A0142-begin
#     #    PRINT COLUMN g_c[35],l_ima02 CLIPPED  #No.FUN-590110
#          PRINTX name=D3 COLUMN g_c[36],l_ima02 CLIPPED  #No.FUN-590110
#     # FUN-5A0142-end
#      END IF
#      #MOD-4A0086(1)(end)
#
#      #----------------------------------------------------------------------
#      DECLARE r710_c3 CURSOR FOR
#         SELECT * FROM bmw_file
#               WHERE bmw01=bmy.bmy01 AND bmw02=bmy.bmy02
#               ORDER BY bmw03
#      LET l_str=NULL
#      FOREACH r710_c3 INTO bmw.*
#         IF STATUS THEN CALL cl_err('for bmy:',STATUS,1) EXIT FOREACH END IF
#         LET l_str=l_str CLIPPED,' ',
#                   bmw.bmw04 CLIPPED,'*',bmw.bmw05 USING '<<<<'
#      END FOREACH
#      IF l_str IS NOT NULL THEN
#         PRINT COLUMN 18,g_x[20] CLIPPED,l_str[2,40]
#         IF l_str[41,80]  <>' ' THEN PRINT COLUMN 29,l_str[41,80]   CLIPPED END IF
#         IF l_str[81,120] <>' ' THEN PRINT COLUMN 29,l_str[81,121]  CLIPPED END IF
#         IF l_str[121,160]<>' ' THEN PRINT COLUMN 29,l_str[121,160] CLIPPED END IF
#         IF l_str[161,200]<>' ' THEN PRINT COLUMN 29,l_str[161,200] CLIPPED END IF
#      END IF
#      #----------------------------------------------------------------------
#       PRINT ' ' #FUN-5A0142
### FUN-550101
#  ON LAST ROW
#      LET l_last_sw = 'y'
#
#  PAGE TRAILER
#      PRINT ' '
#      PRINT g_dash[1,g_len]
#      IF l_last_sw = 'n'
#      THEN
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
#      PRINT ' '
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[9]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[9]
#             PRINT g_memo
#      END IF
### END FUN-550101
#
#END REPORT
#No.FUN-710089 --end
 
FUNCTION r710_bmy03(p_chr)
   DEFINE p_chr	LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
   DEFINE l_buf	LIKE type_file.chr20    #MOD-5C0160 4->10        #No.FUN-680096 VARCHAR(10)
 
  #MOD-5C0160...............begin
  #CASE g_lang
  #  WHEN '0'
  #     CASE #WHEN p_chr='0' LET l_buf='刪除' #MOD-4A0086(2)
  #          WHEN p_chr='1' LET l_buf='失效'
  #          WHEN p_chr='2' LET l_buf='新增'
  #          WHEN p_chr='3' LET l_buf='修改'
  #           WHEN p_chr='4' LET l_buf='取代' #MOD-4A0086(2)
  #    END CASE
  #  WHEN '2'
  #     CASE #WHEN p_chr='0' LET l_buf='刪除' #MOD-4A0086(2)
  #          WHEN p_chr='1' LET l_buf='失效'
  #          WHEN p_chr='2' LET l_buf='新增'
  #          WHEN p_chr='3' LET l_buf='修改'
  #           WHEN p_chr='4' LET l_buf='取代' #MOD-4A0086(2)
  #    END CASE
  #  OTHERWISE
  #     CASE #WHEN p_chr='0' LET l_buf='Del'  #MOD-4A0086(2)
  #          WHEN p_chr='1' LET l_buf='Disa'
  #          WHEN p_chr='2' LET l_buf='Add '
  #          WHEN p_chr='3' LET l_buf='Mod '
  #           WHEN p_chr='4' LET l_buf='R/S ' #MOD-4A0086(2)
  #    END CASE
  #END CASE
  CASE
    WHEN p_chr='1' LET l_buf=g_x[45] #MOD-5C0160
    WHEN p_chr='2' LET l_buf=g_x[46] #MOD-5C0160
    WHEN p_chr='3' LET l_buf=g_x[47] #MOD-5C0160
    WHEN p_chr='4' LET l_buf=g_x[48] #MOD-5C0160
    OTHERWISE LET l_buf=''
  END CASE
  #MOD-5C0160...............end
   RETURN l_buf
END FUNCTION
#Patch....NO.TQC-610035 <> #
#FUN-E50024

#FUN-E50052 ADD BEGIN---------------
FUNCTION r710_agd03_d(p_ima01,p_agd02,p_type)
   DEFINE p_ima01   LIKE ima_file.ima01
   DEFINE p_agd02   LIKE agd_file.agd02
   DEFINE p_type    LIKE type_file.chr1
   DEFINE l_agd03   LIKE agd_file.agd03

   IF p_type = '1' THEN
      SELECT agd03 INTO l_agd03 FROM agd_file,ima_file
       WHERE agd01 = ima940
         AND ima01 = p_ima01
         AND agd02 = p_agd02
   END IF
   IF p_type = '2' THEN
      SELECT agd03 INTO l_agd03 FROM agd_file,ima_file
       WHERE agd01 = ima941
         AND ima01 = p_ima01
         AND agd02 = p_agd02
   END IF
   RETURN l_agd03
END FUNCTION
#FUN-E50052 ADD END---------------

