# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: abmq501.4gl
# Descriptions...: BOM 單階查詢
# Date & Author..: 94/02/06  By  Roger
#	.........: 將組成用量除以底數
# Modify.........: #No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-510115 05/01/19 By ching per 與 4gl array 需一致
# Modify.........: No.MOD-550020 05/05/03 By Mandy 單身抬頭和單身資料的內容不對應,例:抬頭是組成用量,但是其資料卻是show品名
# Modify.........: No.FUN-550093 05/05/24 By kim 配方BOM
# Modify.........: No.FUN-550106 05/05/27 By Smapmin QPA欄位放大
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.MOD-550192 05/07/26 By Carol QPA的計算不用再乘以與生產單位的轉換率了
# Modify.........: No.MOD-5A0257 05/10/21 By Rosayu 欄位順序要與s_bmb一致
# Modify.........: No.TQC-660046 06/06/12 By xumin cl_err To cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720055 07/03/19 By Ray 單身下條件查詢時，筆數值有誤
# Modify.........: No.MOD-740052 07/04/24 By pengu 按了單身[料號]的欄位做資料排序後再查詢前後筆資料會有問題
# Modify.........: No.TQC-740338 07/04/27 By sherry 查詢時狀態欄位不能錄入。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-850118 08/05/15 By claire 料號加入開窗
# Modify.........: No.MOD-850129 08/05/15 By claire 將組成用量除以底數(bmb06/bmb07)
# Modify.........: No.MOD-750093 07/05/24 By pengu 單身資料未依產品樹狀結構呈現
# Modify.........: No.MOD-760024 07/06/07 By pengu 查詢時單身尾有多空白行
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.MOD-860144 08/06/13 By claire 單身展不出
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.MOD-920094 09/02/06 By chenl  調整變量大小
# Modify.........: No.MOD-920233 09/02/18 By claire 特性代碼關聯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No:MOD-A80212 10/08/27 By sabrina p_total型態改為LIKE bmb_file.bmb06 
# Modify.........: No:TQC-AB0041 10/12/18 By lixh1   將SQL中的OUTER改為LEFT OUTER JOIN
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.TQC-C50116 12/05/14 By fengrui 填充單身時，除去無效資料
# Modify.........: No.CHI-CA0002 12/10/12 By Elise 修改MOD-850118開窗,改為q_bma101(改善效能)
# Modify.........: No.MOD-D20085 13/02/19 By bart 往下展時，需考慮主件發料單位與生產單位的轉換。
# Modify.........: No.CHI-CB0050 13/02/26 By Elise 增加 作業編號(bmb09)欄位
# Modify.........: No.MOD-D50209 13/05/24 By bart tm.wc改為STRING
# Modify.........: No.MOD-E60121 14/06/26 By Mandy 單身下查詢條件時,無法show出第2階(含)以後的元件資籵
# Modify.........: No.MOD-E60124 14/06/26 By Mandy 得到的查詢筆數不正確,欄位FORMONLY.cnt
# Modify.........: No.MOD-E70144 14/08/01 By Alberti 修正 下階展料單位換算有問題 
# Modify.........: No.23080014   20230828 By momo abmq501 查詢功能調整 
# Modify.........: No.23090031   20230928 By momo 增加替代料件資訊

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	#wc  	LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(500) #MOD-D50209
        	#wc2  	LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(500) #MOD-D50209
            wc      STRING, #MOD-D50209
            wc2     STRING, #MOD-D50209
            wc3     STRING
        END RECORD,
    g_bma   RECORD
            bma01 LIKE bma_file.bma01,
            ima02 LIKE ima_file.ima02,
            ima021 LIKE ima_file.ima021,
            ima05 LIKE ima_file.ima05,
            ima08 LIKE ima_file.ima08,
            ima55 LIKE ima_file.ima55,
            bmauser LIKE bma_file.bmauser,
            bmagrup LIKE bma_file.bmagrup,
            bmamodu LIKE bma_file.bmamodu,
            bmadate LIKE bma_file.bmadate,
            bmaacti LIKE bma_file.bmaacti,
            bma06 LIKE bma_file.bma06,     #FUN-550093
            bmaoriu LIKE bma_file.bmaoriu, #No.FUN-9A0024                                                                           
            bmaorig LIKE bma_file.bmaorig  #No.FUN-9A0024 
            END RECORD,
	g_vdate LIKE type_file.dat,           #No.FUN-680096 DATE
	g_rec_b LIKE type_file.num5,          #No.FUN-680096 SMALLINT
    g_bmb DYNAMIC ARRAY OF RECORD
            x_level   LIKE type_file.num5,      #No.FUN-680096 SMALLINT
            bmb02     LIKE bmb_file.bmb02,
            bmb03     LIKE bmb_file.bmb03,
            ima02_b   LIKE ima_file.ima02,     #MOD-5A0257 add
            ima021_b  LIKE ima_file.ima021,    #MOD-5A0257 add
            ima06_N   LIKE ima_file.ima06,     #料號不顯示分群碼 20230823
            ima06     LIKE ima_file.ima06,     #顯示子階分群碼 20230823
            bmb09     LIKE bmb_file.bmb09,     #作業編號    #CHI-CB0050 add
            bmb06     LIKE bmb_file.bmb06,
            bmb10     LIKE bmb_file.bmb10,
            ima31     LIKE ima_file.ima31,
            ima31_fac LIKE ima_file.ima31_fac, #銷售單位 20230823
            bmb13     LIKE bmb_file.bmb13,     #銷售對庫存換算率 20230823
            bmd04     LIKE bmd_file.bmd04,     #替代料號 20230928
            ima02_c   LIKE ima_file.ima02,     #替代料號品名 20230928
            ima021_c  LIKE ima_file.ima021     #替代料號規格 20230928
            # ima02_b LIKE ima_file.ima02,    #BUG-510115  #MOD-550020 #MOD-5A0257 mark
            # ima021_b LIKE ima_file.ima021   #MOD-550020  #MOD-5A0257 mark
        END RECORD,
    g_argv1         LIKE bma_file.bma01,      # INPUT ARGUMENT - 1
    g_sql           string                    #No.FUN-580092 HCN
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE   g_cnt         LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_msg         LIKE ze_file.ze03      #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_curs_index  LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_jump        LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   mi_no_ask     LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE  lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE   g_seq         LIKE type_file.num5    #No.MOD-750093 add   
 
MAIN
      DEFINE  # l_time LIKE type_file.chr8           #No.FUN-6A0060
          l_sl	       LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CBM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
    LET g_argv1      = ARG_VAL(1)          # 參數值(1)
    LET g_vdate      = g_today
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q501_w AT p_row,p_col WITH FORM "cbm/42f/abmq501"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
    #FUN-560021................end
 
    IF NOT cl_null(g_argv1) THEN CALL q501_q() END IF
    CALL q501_menu()
    CLOSE WINDOW q501_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
 
FUNCTION q501_cs()                         # QBE 查詢資料
   DEFINE   l_cnt   LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "bma01 = '",g_argv1,"'"
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM                       # 清除畫面
   CALL g_bmb.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INITIALIZE g_bma.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON bma01,bma06, #FUN-550093
                                 bmauser,bmamodu,bmaacti,bmagrup,bmadate     #No.TQC-740338
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      #--No.MOD-850118--------
      ON ACTION CONTROLP
        CASE 
         WHEN INFIELD(bma01) #主件
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
      	     #LET g_qryparam.form = "q_bmb01"    #CHI-CA0002 mark
              LET g_qryparam.form = "q_bma101"   #CHI-CA0002
              CALL cl_create_qry() RETURNING g_qryparam.multiret
      	      DISPLAY g_qryparam.multiret TO bma01
      	      NEXT FIELD bma01
         OTHERWISE 
              EXIT CASE
         END CASE
      #--#MOD-850118-END-------    
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
      INPUT BY NAME g_vdate WITHOUT DEFAULTS
         ON ACTION controlg       #TQC-860021
            CALL cl_cmdask()      #TQC-860021
 
         ON IDLE g_idle_seconds   #TQC-860021
            CALL cl_on_idle()     #TQC-860021
            CONTINUE INPUT        #TQC-860021
 
         ON ACTION about          #TQC-860021
            CALL cl_about()       #TQC-860021
 
         ON ACTION help           #TQC-860021
            CALL cl_show_help()   #TQC-860021
      END INPUT                   #TQC-860021
 
      IF INT_FLAG THEN
         RETURN
      END IF
      CALL q501_b_askkey()             # 取得單身 construct 條件( tm.wc2 )
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
   MESSAGE ' SEARCHING '
   IF tm.wc2 = " 1=1" THEN
      LET g_sql = " SELECT UNIQUE bma01,bma06 FROM bma_file", #FUN-550093
                  "  WHERE ",tm.wc CLIPPED
   ELSE
      LET g_sql = " SELECT UNIQUE bma01,bma06", #FUN-550093
                  " FROM bma_file, bmb_file ",
                  " WHERE ",tm.wc CLIPPED, 
                 #"   AND ",tm.wc2 CLIPPED, #MOD-E60121 mark 因為會展BOM,可能查詢的元件是在第2階(含)之後,故不能在一開始就限製
                  "   AND bma06 = bmb29",   #MOD-920233 add
                  "   AND bma01 = bmb01"
      #MOD-E60121 add---str---
      #-->當單頭未下條件時,才將單身的條件加入
      IF tm.wc = " 1=1" THEN
          LET g_sql = g_sql CLIPPED," AND ",tm.wc2 CLIPPED 
      END IF

      #-->生效日及失效日的判斷 
      IF NOT cl_null(g_vdate) THEN
          LET g_sql = g_sql CLIPPED,
                     " AND (bmb04 <='",g_vdate,"' OR bmb04 IS NULL)",
                     " AND (bmb05 > '",g_vdate,"' OR bmb05 IS NULL)"
      END IF
      #MOD-E60121 add---end---
   END IF
   
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND bmauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND bmagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY bma01"
   PREPARE q501_prepare FROM g_sql
   DECLARE q501_cs SCROLL CURSOR FOR q501_prepare
#No.TQC-720055 --begin
#  LET g_sql= " SELECT COUNT(*) FROM bma_file WHERE ",tm.wc CLIPPED
   IF tm.wc2 = " 1=1" THEN
     #LET g_sql= " SELECT COUNT(*) ",                     #MOD-E60124 mark
      LET g_sql= " SELECT COUNT(UNIQUE bma01||bma06) ",   #MOD-E60124 add 得到的筆數不正確調整
                 "   FROM bma_file WHERE ",tm.wc CLIPPED  
   ELSE
     #LET g_sql = " SELECT COUNT(*) ",                    #MOD-E60124 mark
      LET g_sql = " SELECT COUNT(UNIQUE bma01||bma06) ",  #MOD-E60124 add 得到的筆數不正確調整
                  " FROM bma_file, bmb_file ",
                  " WHERE ",tm.wc CLIPPED,
                 #"   AND ",tm.wc2 CLIPPED, #MOD-E60121 mark
                  "   AND bma06 = bmb29",   #MOD-920233 add
                  "   AND bma01 = bmb01"
      #MOD-E60121 add---str---
      #-->當單頭未下條件時,才將單身的條件加入
      IF tm.wc = " 1=1" THEN
          LET g_sql = g_sql CLIPPED," AND ",tm.wc2 CLIPPED 
      END IF

      #-->生效日及失效日的判斷 #140626
      IF NOT cl_null(g_vdate) THEN
          LET g_sql = g_sql CLIPPED,
                     " AND (bmb04 <='",g_vdate,"' OR bmb04 IS NULL)",
                     " AND (bmb05 > '",g_vdate,"' OR bmb05 IS NULL)"
      END IF
      #MOD-E60121 add---end---
   END IF
#No.TQC-720055 --end
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND bmauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND bmagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q501_pp FROM g_sql
   DECLARE q501_cnt CURSOR FOR q501_pp
END FUNCTION
 
 
FUNCTION q501_b_askkey()
   CONSTRUCT tm.wc2 ON ima06,bmb02,bmb03,bmb09                                 #CHI-CB0050 add bmb09 #20230825
        FROM s_bmb[1].ima06_N,s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb09     #CHI-CB0050 add bmb09 #20230825

              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
              #No.FUN-580031 --end--       HCN

     #CHI-CB0050---add---S
      ON ACTION CONTROLP
         CASE
            ##--- 20230825 add (S)
            WHEN INFIELD(ima06_N)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_imz"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima06_N
                 NEXT FIELD ima06_N
            ##--- 20230825 add (E)
            WHEN INFIELD(bmb09)
                 CALL q_ecd(TRUE,TRUE,g_bmb[1].bmb09)
                        RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO bmb09
                   NEXT FIELD bmb09

            OTHERWISE EXIT CASE
         END  CASE
     #CHI-CB0050---add---E

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT

   ##--- 20230825 add (S) ----
   CONSTRUCT tm.wc3 ON ima06                           
        FROM s_bmb[1].ima06     
        BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(ima06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_imz"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima06
                 NEXT FIELD ima06
        END CASE

      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   ##--- 20230825 add (E) ----

END FUNCTION
 
FUNCTION q501_menu()
 
   WHILE TRUE
      CALL q501_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q501_q()
         WHEN "jump"
            CALL q501_fetch('/')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "next"
            CALL q501_fetch('N')
         WHEN "previous"
            CALL q501_fetch('P')
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q501_q()
 
    CALL cl_set_comp_visible("ima06_N,ima06",TRUE) #20230825
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q501_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q501_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q501_cnt
       FETCH q501_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q501_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q501_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1      #處理方式   #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q501_cs INTO g_bma.bma01,g_bma.bma06
        WHEN 'P' FETCH PREVIOUS q501_cs INTO g_bma.bma01,g_bma.bma06
        WHEN 'F' FETCH FIRST    q501_cs INTO g_bma.bma01,g_bma.bma06
        WHEN 'L' FETCH LAST     q501_cs INTO g_bma.bma01,g_bma.bma06
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q501_cs INTO g_bma.bma01,g_bma.bma06
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)
        INITIALIZE g_bma.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    #FUN-550093................begin
#	SELECT bma01,ima02,ima021,' ',ima08,ima55,
#           bmauser,bmagrup,bmamodu,bmadate,bmaacti,bma06
#	  INTO g_bma.*
#      FROM bma_file, OUTER ima_file
#	 WHERE bma01 = g_bma.bma01 AND bma01 = ima_file.ima01
    SELECT bma01,'','','','','',
           bmauser,bmagrup,bmamodu,bmadate,bmaacti,bma06
           INTO g_bma.*
      FROM bma_file WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06
 
    IF SQLCA.sqlcode THEN
   #    CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("sel","bma_file",g_bma.bma01,"",SQLCA.sqlcode,"","",0)    #No.TQC-660046
        RETURN
    END IF
    SELECT ima02,ima021,' ',ima08,ima55
       INTO g_bma.ima02,g_bma.ima021,g_bma.ima05,g_bma.ima08,g_bma.ima55
       FROM ima_file WHERE ima01=g_bma.bma01
    #FUN-550093................end
    CALL s_effver(g_bma.bma01,g_vdate) RETURNING g_bma.ima05
 
    CALL q501_show()
END FUNCTION
 
FUNCTION q501_show()
   #No.FUN-9A0024--begin                                                                                                            
   #DISPLAY BY NAME g_bma.*                                                                                                         
   DISPLAY BY NAME g_bma.bma01,g_bma.ima02,g_bma.ima021,g_bma.ima05,g_bma.ima08,g_bma.ima55,                                        
                   g_bma.bmauser,g_bma.bmamodu,g_bma.bmaacti,g_bma.bmagrup,                                                         
                   g_bma.bmadate,g_bma.bmaoriu,g_bma.bmaorig                                                                        
   #No.FUN-9A0024--end 
 #MOD-550192
#  IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
#      DISPLAY '!' TO FORMONLY.g_s
#  END IF
   CALL q501_explosion()
   CALL q501_b_fill() #單身
   CALL cl_set_comp_visible("ima06_N,ima06",FALSE)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q501_explosion()
   MESSAGE " BOM Explosing ! "
   DROP TABLE q501_temp
#No.FUN-680096----------------begin-----------------------
   CREATE TEMP TABLE q501_temp(
              x_level	LIKE type_file.num5,  
              bmb02     LIKE bmb_file.bmb02,
              bmb03     LIKE bmb_file.bmb03,
              bmb09     LIKE bmb_file.bmb09,    #CHI-CB0050 add
              bmb06     LIKE bmb_file.bmb06,
              bmb10     LIKE bmb_file.bmb10,
              bmb13     LIKE bmb_file.bmb13,
              bma01     LIKE bma_file.bma01,
              seq       LIKE type_file.num5)    #No.MOD-750093 add
   LET g_seq = 0                                #No.MOD-750093 add
#No.FUN-680096----------------end----------------------
   CALL q501_bom(0,g_bma.bma01,1,g_bma.bma06,'') #MOD-D20085
   MESSAGE ""
END FUNCTION
 
FUNCTION q501_bom(p_level,p_key,p_total,p_bma06,p_unit) #FUN-550093  #MOD-D20085
   DEFINE p_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_key		LIKE bma_file.bma01,    #主件料件編號
         #p_total       LIKE sfa_file.sfa05,    #MOD-550192 modify type  #No.MOD-920094 mark
         #p_total       LIKE sfa_file.sfa15,    #No.MOD-920094   #MOD-A80212 mark
          p_total       LIKE bmb_file.bmb06,    #MOD-A80212 add 
          p_bma06       LIKE bma_file.bma06,    #FUN-550093
          p_unit        LIKE bmb_file.bmb10,    #MOD-D20085
          l_ac,i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,    #BUFFER SIZE (可存筆數) #No.FUN-680096 SMALLINT
          l_chr,l_cnt   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_fac         LIKE csa_file.csa0301,  #No.FUN-680096 DEC(13,5)
         #l_ima55       LIKE ima_file.ima55,                    #MOD-E70144 mark
          l_ima55       DYNAMIC ARRAY OF LIKE ima_file.ima55,   #MOD-E70144 Add
          l_fac1        LIKE csa_file.csa0301,                  #MOD-E70144 Add
          l_cnt1        LIKE type_file.chr1,                    #MOD-E70144 Add
          l_bmaacti     LIKE bma_file.bmaacti,  #TQC-C50116 add
          sr DYNAMIC ARRAY OF RECORD            #每階存放資料
              x_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb09 LIKE bmb_file.bmb09,    #作業編號  #CHI-CB0050 add
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
               bma01 LIKE bma_file.bma01    #No.MOD-490217
          END RECORD,
          l_sql     LIKE type_file.chr1000  #No.FUN-680096  VARCHAR(1000)
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
   DEFINE l_cnt2    LIKE type_file.num10  #20230823 

   
    #TQC-C50116--add--str--
    LET l_bmaacti = NULL
    SELECT bmaacti INTO l_bmaacti
      FROM bma_file 
     WHERE bma01 = p_key 
       AND bma06 = p_bma06 
    IF l_bmaacti <> 'Y' THEN RETURN END IF
    #TQC-C50116--add--end--
	IF p_level > 20 THEN
       	   CALL cl_err('','mfg2733',1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
           EXIT PROGRAM
	END IF
    LET p_level = p_level + 1
    LET arrno = 600			#95/12/21 Modify By Lynn
    #FUN-550093................begin
#   LET l_sql= "SELECT 0, bmb02, bmb03, (bmb06/bmb07), bmb10, bmb13, bma01",
#              "  FROM bmb_file, OUTER bma_file",
#              " WHERE bmb01='", p_key,"' AND bmb03 = bma_file.bma01",
#              "   AND ",tm.wc2 CLIPPED
 
    LET l_sql= "SELECT 0, bmb02, bmb03, bmb09, (bmb06/bmb07), bmb10, bmb13, bmb01",  #CHI-CB0050 add bmb09
               "  FROM bmb_file",
               " WHERE bmb01='", p_key,"' AND bmb29='",p_bma06,"'"
              #"   AND ",tm.wc2 CLIPPED #MOD-E60121 mark #元件全部展至temp檔後再篩選
    #FUN-550093................end
    #---->生效日及失效日的判斷
    IF g_vdate IS NOT NULL THEN
        LET l_sql=l_sql CLIPPED,
                  " AND (bmb04 <='",g_vdate,"' OR bmb04 IS NULL)",
                  " AND (bmb05 > '",g_vdate,"' OR bmb05 IS NULL)"
    END IF
    CASE
      WHEN g_sma.sma65 = '1' LET l_sql=l_sql CLIPPED," ORDER BY bmb02"
      WHEN g_sma.sma65 = '2' LET l_sql=l_sql CLIPPED," ORDER BY bmb03"
      WHEN g_sma.sma65 = '3' LET l_sql=l_sql CLIPPED," ORDER BY bmb13"
      OTHERWISE              LET l_sql=l_sql CLIPPED," ORDER BY bmb02"
    END CASE
    PREPARE q501_precur FROM l_sql
    IF SQLCA.sqlcode THEN 
       CALL cl_err('P1:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
       EXIT PROGRAM 
    END IF
    DECLARE q501_cur CURSOR FOR q501_precur
    LET l_ac = 1
    FOREACH q501_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
        #FUN-8B0015--BEGIN--
        LET l_ima910[l_ac]=''
        SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
        IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
        #FUN-8B0015--END--
        SELECT ima55 INTO l_ima55[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bma01 #MOD-E70144 Add
        LET l_ac = l_ac + 1
        IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    FOR i = 1 TO l_ac-1    	        	# 讀BUFFER傳給REPORT
 #MOD-550192 mark
#       LET l_fac = 1
#       SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=sr[i].bmb03
#       IF l_ima55 !=sr[i].bmb10 THEN
#          CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,l_ima55)
#               RETURNING l_cnt,l_fac    #單位換算
#          IF l_cnt = '1'  THEN #有問題
#             CALL cl_err(sr[i].bmb03,'abm-731',1)
#             LET g_success = 'N'
#             EXIT FOR
#             RETURN
#          END IF
#       END IF
        LET sr[i].x_level = p_level
 #       LET sr[i].bmb06=p_total*sr[i].bmb06*l_fac  #MOD-550192 mark
        #LET sr[i].bmb06=p_total*sr[i].bmb06  #MOD-D20085
        
#MOD-D20085---begin
       IF NOT cl_null(p_unit) THEN
           #MOD-E70144-Start-Add
           #因主件的生產單位(ima55)未必會跟上一階的單位(bmb10)相同，所以p_total還需跟ima55做單位換算
           LET l_cnt1= 0
           LET l_fac1= 0
           CALL s_umfchk(sr[i].bma01,l_ima55[i],sr[i].bmb10)
              RETURNING l_cnt1,l_fac1
           IF l_cnt1 = '1'  THEN 
              LET l_fac1 = 1
           END IF
          #MOD-E70144-ENd-Add
           IF p_unit !=sr[i].bmb10 THEN
              CALL s_umfchk(sr[i].bmb03,p_unit,sr[i].bmb10)
                   RETURNING l_cnt,l_fac    #單位換算
              IF l_cnt = '1'  THEN 
                 LET l_fac = 1
              END IF
           END IF
           IF cl_null(l_fac) THEN LET l_fac = 1 END IF      
          #LET sr[i].bmb06=p_total*sr[i].bmb06*l_fac         #MOD-E70144 mark
           LET sr[i].bmb06=p_total/l_fac1*sr[i].bmb06*l_fac  #MOD-E70144 add
           
        ELSE 
           LET sr[i].bmb06=p_total*sr[i].bmb06
        END IF   
#MOD-D20085---end 
        LET g_seq = g_seq + 1                          #No.MOD-750093 add
        INSERT INTO q501_temp VALUES (sr[i].*,g_seq)   #No.MOD-750093 modify
        IF sr[i].bma01 IS NOT NULL THEN #若為主件
          #CALL q501_bom(p_level,sr[i].bmb03,sr[i].bmb06,' ') #FUN-8B0015
          ##---- 20230825子階過濾(S)
          #CALL q501_bom(p_level,sr[i].bmb03,sr[i].bmb06,l_ima910[i],sr[i].bmb10)#FUN-8B0015 #MOD-D20085
          LET l_sql = "SELECT 1 FROM ima_file WHERE ima01 ='",sr[i].bmb03,"' AND " ,tm.wc3 
          PREPARE q501_preopeny FROM l_sql
          DECLARE q501_curopeny CURSOR FOR q501_preopeny
          FOREACH q501_curopeny INTO l_cnt2
            IF l_cnt2 = 1 THEN
               CALL q501_bom(p_level,sr[i].bmb03,sr[i].bmb06,l_ima910[i],sr[i].bmb10)
            END IF
            EXIT FOREACH
          END FOREACH
          ##---- 20230825子階過濾(E)
        END IF
    END FOR
END FUNCTION
 
FUNCTION q501_b_fill()              #BODY FILL UP
   DEFINE i	LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
   #MOD-E60121--mark---str---
   #DECLARE q501_bcs CURSOR FOR
   #            SELECT x_level,bmb02,bmb03,ima02,ima021,bmb09, #MOD-510115 #MOD-5A0257 unmark #CHI-CB0050 add bmb09
   #                   bmb06,bmb10,bmb13 #MOD-850129   #MOD-860144 
   #                  #(bmb06/bmb07),bmb10,bmb13 #MOD-850129  #MOD-860144
   #                  #bmb06,bmb10,bmb13 #MOD-5A0257 unmark  #MOD-850129 mark
   #           #SELECT x_level,bmb02,bmb03,#MOD-5A0257 mark
   #           #       bmb06,bmb10,bmb13,#MOD-5A0257 mark
   #           #        ima02,ima021   #MOD-550020#MOD-5A0257 mark
   #           #  FROM q501_temp, OUTER ima_file        #TQC-AB0041
   #           # WHERE q501_temp.bmb03 = ima_file.ima01 #TQC-AB0041 
   #              FROM q501_temp LEFT OUTER JOIN ima_file  #TQC-AB0041
   #                ON q501_temp.bmb03 = ima_file.ima01    #TQC-AB0041
   #             WHERE tm.wc2 #MOD-E60121 add #篩選單身下的查詢條件
   #             ORDER BY seq                           #No.MOD-750093 add
   #MOD-E60121--mark---end---
   #MOD-E60121--add----str---
   #改用PREPARE 的方式並且加上tm.wc2的條件,其餘沒變

   LET tm.wc2 = cl_replace_str(tm.wc2,"ima06 in","ima06 not in")         #20230825
   LET tm.wc2 = cl_replace_str(tm.wc2,"ima06=","ima06 != ")              #20230825

   LET g_sql = "SELECT x_level,bmb02,bmb03,ima02,ima021,' ',ima06,bmb09, ",  #20230823
               "       bmb06,bmb10,ima31,ima31_fac,bmb13,'','','' ",         #20230823
               "  FROM q501_temp LEFT OUTER JOIN ima_file ",
               "    ON bmb03 = ima01 ",   
               " WHERE ",tm.wc2, # add 篩選單身下的查詢條件
               " ORDER BY seq "              
   PREPARE q501_pb FROM g_sql
   DECLARE q501_bcs CURSOR FOR q501_pb
   #MOD-E60121--add----end---

   #-----------------No.MOD-740052 modify
   #FOR g_cnt = 1 TO g_bmb.getLength()           #單身 ARRAY 乾洗
   #   INITIALIZE g_bmb[g_cnt].* TO NULL
   #END FOR
    CALL g_bmb.clear()
   #-----------------No.MOD-740052 end
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH q501_bcs INTO g_bmb[g_cnt].*
       IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
#      IF g_cnt > g_bmb_arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
      # genero shell add g_max_rec check START
      ##---- 20230928 (S) 替代資訊------
      SELECT bmd04,ima02,ima021
        INTO g_bmb[g_cnt].bmd04,g_bmb[g_cnt].ima02_c,g_bmb[g_cnt].ima021_c
        FROM bmd_file,ima_file
      WHERE bmd04 = ima01
        AND bmd01 = g_bmb[g_cnt].bmb03
        AND bmd06 IS NULL
        AND bmdacti = 'Y'
        AND rownum = 1
      ##---- 20230928 (E) ------
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    CALL g_bmb.deleteElement(g_cnt)       #No.MOD-760024 add
    LET g_rec_b = g_cnt -1
    LET g_cnt = g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cn2
#   LET i = g_cnt / g_bmb_sarrno
#   IF (g_cnt > i*g_bmb_sarrno) THEN LET i = i + 1 END IF
END FUNCTION
 
FUNCTION q501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q501_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION next
         CALL q501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION accept
        #LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
