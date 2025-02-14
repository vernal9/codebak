# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: abmi610.4gl
# Descriptions...: 上階主件對元件群組維護作業
# Date & Author..: 2003/04/15 alexwang
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470051 04/07/21 By Mandy 加入相關文件功能
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-510033 05/02/16 By Mandy 報表轉XML
# Modify.........: No.FUN-5A0061 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-660046 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770052 07/07/08 By xiaofeizhu 制作水晶報表
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.TQC-920061 09/02/20 By dxfwo .out抓出數據sql錯誤導致畫面主件的品名規格都是元件的
# Modify.........: No.FUN-980001 09/08/06 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40058 10/04/26 By lilingyu bmb16增加規格替代的邏輯內容
# Modify.........: No.TQC-A60132 10/06/29 By chenmoyan 把ds_report改為g_cr_db_str
# Modify.........: No,FUN-AA0059 10/10/25 By vealxu 規通料件整合(3)全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.TQC-AB0041 10/12/14 By lixh1  將SQL中的OUTER改為LEFT OUTER JOIN 
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-D10033 13/01/23 By bart 1.設定完set替代後，需update bmb16=5
#                                                 2.刪除後判斷如果不存在其他的set取替代則update bmb16=0。
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D60215 13/06/27 By Alberti 修改刪除資料單頭未清空
# Modify.........: No.FUN-DA0126 13/11/04 By bart 移除azo_file程式段
# Modify.........: No:MOD-G80103 16/08/22 By Mandy 加入資料權限的控卡
# Modify.........: No:0000664623_06_M014 18/01/30 By TSD.Andy 新增複製功能
# Modify.........: 20180323 mark by momo 參數傳入時不需隱藏 sub_group ACTION
# Modify.........: No:0000664623_06_M014 18/03/27 By TSD.Tim 複製時，一併更新bmb_file資料
# Modify.........: No:1907033256 20190709 By momo 增加資料清單
# Modify.........: No:1909273692 20191007 By momo 增加記錄修改日期與修改時間
# Modify.........: No:2001204176 20200130 By momo 增加記錄使用或不使用系列別
# Modify.........: No:2103316054 20210414 By momo 增加「資料拋轉」、「資料拋轉歷史」
# Modify.........: NO:2106026315 20210608 By momo 此功能移做它用，此處註銷
# Modify.........: NO:2106026315 20210630 By momo cooi103 檢核
# Modify.........: No:2205168074 20220527 By momo 取替代資料失效時，更新BOM取替代特性
# Modify.........: No:23070024   20230713 By momo 卡控資料中心，新增狀態檢核
# Modify.........: No:23070027   20230714 By momo 增加欄位查詢功能 
# Modify.........: NO:23100001   20231006 By momo 增加顯示 bmb06、bmb07 欄位
# Modify.........: NO:24110007   20241111 By momo boa01 依資料中心設定增加卡控
# Modify.........: No:25020016   20250212 By momo 增加標準否ta_boa01欄位記錄與功能

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../tiptop/sub/4gl/s_data_center.global"
 
DEFINE                                     #模組變數(Module Variables)
    g_cnt2,g_cnt3   LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    g_argv1         LIKE boa_file.boa01,   #上階主件 (假單頭)
    g_argv2         LIKE boa_file.boa02,   #元件群組
    g_boa01         LIKE boa_file.boa01,   #上階主件 (假單頭)
    g_boa02         LIKE boa_file.boa02,   #元件群組
    g_boa08         LIKE boa_file.boa08,   #群組說明
    g_ta_boa01      LIKE boa_file.ta_boa01,#標準否 20250212
    g_ima02         LIKE ima_file.ima02,   #品名
    g_ima021        LIKE ima_file.ima021,  #品名規格
   #g_ima05         LIKE ima_file.ima05,   #目前使用版本 #20250212
    g_ima08         LIKE ima_file.ima08,   #來源碼
    g_ima25         LIKE ima_file.ima25,
    g_ima63         LIKE ima_file.ima63,
    g_boa          DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
                boa03       LIKE boa_file.boa03,
                ima02b      LIKE ima_file.ima02,
                ima021b     LIKE ima_file.ima021,
                bmb06       LIKE bmb_file.bmb06,     #20231006
                bmb07       LIKE bmb_file.bmb07,     #20231006
                boa04       LIKE boa_file.boa04,
                boa05       LIKE boa_file.boa05,
                boa06       LIKE boa_file.boa06,
                boa07       LIKE boa_file.boa07,
                ta_boadate  LIKE boa_file.ta_boadate, #20191007
                ta_boamodu  LIKE boa_file.ta_boamodu, #20191007
                atp         LIKE type_file.num15_3    #20230714
   END RECORD,
    g_boa_t        RECORD                  #變數舊值
                boa03       LIKE boa_file.boa03,
                ima02b      LIKE ima_file.ima02,
                ima021b     LIKE ima_file.ima021,
                bmb06       LIKE bmb_file.bmb06,     #20231006
                bmb07       LIKE bmb_file.bmb07,     #20231006
                boa04       LIKE boa_file.boa04,
                boa05       LIKE boa_file.boa05,
                boa06       LIKE boa_file.boa06,
                boa07       LIKE boa_file.boa07,
                ta_boadate  LIKE boa_file.ta_boadate, #20191007
                ta_boamodu  LIKE boa_file.ta_boamodu, #20191007
                atp         LIKE type_file.num15_3    #20230714
   END RECORD,
     g_wc,g_wc2            string,                 #No.FUN-580092 HCN
     g_sql                 string,                 #No.FUN-580092 HCN
    g_ss                   LIKE type_file.chr1,    #決定後續步驟 #No.FUN-680096 VARCHAR(1)
    g_check_bma01          LIKE type_file.chr1,    #決定後續步驟 #No.FUN-680096 VARCHAR(1)
    g_rec_b                LIKE type_file.num5,    #單身筆數        #No.FUN-680096 SMALLINT
    l_ac                   LIKE type_file.num5     #目前處理的ARRAY CNT   #No.FUN-680096 SMALLINT
 
DEFINE g_forupd_sql      STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)       
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   g_row_count     LIKE type_file.num10        #No.FUN-680096 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10        #No.FUN-680096 INTEGER
DEFINE   g_jump          LIKE type_file.num10        #No.FUN-680096 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5         #No.FUN-680096 SMALLINT
DEFINE   l_table         STRING,                     ### FUN-770052 ###                                                                  
         g_str           STRING                      ### FUN-770052 ###
DEFINE   g_boa01_c       LIKE boa_file.boa01     #M014 180205 By TSD.Andy
##---- 20190709 資料清單 (S)
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE   g_action_flag  STRING
DEFINE   g_rec_b1       LIKE type_file.num10
DEFINE   l_ac1          LIKE type_file.num10
DEFINE   boa_l          RECORD  LIKE ecb_file.*
DEFINE   g_boa_1        DYNAMIC ARRAY OF RECORD
                           boa01_1     LIKE boa_file.boa01,
                           ima02_l     LIKE ima_file.ima02,
                           ima021_l    LIKE ima_file.ima021,
                           ima08_l     LIKE ima_file.ima08,
                           boa02_l     LIKE boa_file.boa02,
                           boa08_1     LIKE boa_file.boa08,
                           ta_boa01_1  LIKE boa_file.ta_boa01  #20250212
                                       END RECORD
##---- 20190709 資料清單 (E)

##---- 20210414 add by momo (S) 資料拋轉
DEFINE  g_boax        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
          sel         LIKE type_file.chr1,
          boa01       LIKE boa_file.boa01,
          boa02       LIKE boa_file.boa02,
          boa03       LIKE boa_file.boa03,
          boa04       LIKE boa_file.boa04,
          boa05       LIKE boa_file.boa05
                      END RECORD
DEFINE g_gev04        LIKE gev_file.gev04
DEFINE g_cmd          LIKE type_file.chr1000
##---- 20210414 add by momo (E)
 
MAIN
    DEFINE    l_za05     LIKE type_file.chr1000     #No.FUN-680096 VARCHAR(40)
 
    OPTIONS                                        #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                #擷取中斷鍵, 由程式處理
 
    LET g_argv1 = ARG_VAL(1)               #傳key值
    LET g_argv2 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CBM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0060
## *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                      
    LET g_sql = "boa01.boa_file.boa01,",  
                "boa02.boa_file.boa02,",
                "boa03.boa_file.boa03,",
                "boa04.boa_file.boa04,",
                "boa05.boa_file.boa05,",
                "boa06.boa_file.boa06,",
                "boa07.boa_file.boa07,",
                "boa08.boa_file.boa08,",                                                                                          
                "ima02.ima_file.ima02,",                                                                                            
                "ima021.ima_file.ima021,",                                                                                          
                "ima02a.ima_file.ima02,",                                                                                            
                "ima021a.ima_file.ima021"                                                                                                                    
    LET l_table = cl_prt_temptable('abmi610',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
#   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,             #TQC-A60132                                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #TQC-A60132                                                                      
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                        
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#  
 
    LET g_chkey = "N"                      #封鎖更改假單頭 key 功能
    #就算 p_zz 設 "Y" 也不給做 替代表沒必要做 key 值修改
 
    OPEN WINDOW i610_w WITH FORM "cbm/42f/abmi610"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
        CALL i610_q()
    ELSE
        LET g_argv1 = ''                     #清除鍵值
        LET g_argv2 = 0                      #清除鍵值
    END IF
    CALL i610_menu()
 
    CLOSE WINDOW i610_w                      #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0060
END MAIN
 
FUNCTION i610_curs()                         #QBE 查詢資料
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "boa01 = '",g_argv1 CLIPPED,"' "
       IF NOT cl_null(g_argv2) THEN
          LET g_wc = g_wc CLIPPED," AND boa02 = ",g_argv2 CLIPPED
       END IF
    ELSE
       CLEAR FORM                               #清除畫面
       CALL g_boa.clear()
       IF cl_null(ARG_VAL(1)) AND cl_null(ARG_VAL(2)) THEN
           CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_boa01 TO NULL    #No.FUN-750051
   INITIALIZE g_boa02 TO NULL    #No.FUN-750051
   INITIALIZE g_boa08 TO NULL    #No.FUN-750051
   INITIALIZE g_ta_boa01 TO NULL #20250212
           CONSTRUCT g_wc ON boa01,boa02,boa08,
                             ta_boa01,                                            #20250212
                             a.ima02,a.ima021,                                    #20230714
                             boa03,
                             b.ima02,b.ima021,                                    #20230714
                             boa04,boa05,boa06,boa07,
                             ta_boadate,ta_boamodu                                #20230714
                        FROM boa01,boa02,boa08,
                             ta_boa01,                                            #20250212
                             ima02,ima021,                                        #20230714
                             s_boa[1].boa03,
                             s_boa[1].ima02b,s_boa[1].ima021b,                    #20230714
                             s_boa[1].boa04,s_boa[1].boa05,
                             s_boa[1].boa06,s_boa[1].boa07,
                             s_boa[1].ta_boadate,s_boa[1].ta_boamodu               #20230714
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(boa01)
#                    CALL q_ima(0,0,g_boa01) RETURNING g_boa01
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.state = "c"
                  #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO boa01
                     NEXT FIELD boa01
                 WHEN INFIELD(boa03)     #元件料號
                    IF g_check_bma01 = 'Y' THEN
##Genero:兩種做法,hot code 會解決qry原本組合sql及回傳超過四個值的狀況
#                      CALL q_bmb3(FALSE,TRUE,g_boa01,g_boa[1].boa03,
#                                  g_boa[1].boa04,g_boa[1].boa05)
#                           RETURNING g_msg, g_boa[1].boa03,g_boa[1].boa04,g_boa[1].boa05
##CALL q_bmb3分支出去的q_bmb302且要在主程式將最後沒回傳到的值再SELECT出來
##不過, boa04,boa05後面都還會再開出其他的qry查詢, 是否boa03這邊要回傳boa04,05?
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_bmb302"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO boa03
                    ELSE
#FUN-AA0059 --Begin--
                   #    CALL cl_init_qry_var()
                   #    LET g_qryparam.form = "q_ima"
                   #    LET g_qryparam.state = "c"
                   #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                       CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret  
#FUN-AA0059 --End--
                       DISPLAY g_qryparam.multiret TO boa03
                    END IF
                    NEXT FIELD boa03
 
                WHEN INFIELD(boa04) #作業主檔
                   CALL q_ecd(TRUE,TRUE,g_boa[1].boa04)
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO boa04
                     NEXT FIELD boa04
 
                 WHEN INFIELD(boa05)     #單位
#                   CALL q_gfe(3,3,g_boa[1].boa05) RETURNING g_boa[1].boa05
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO boa05
                    NEXT FIELD boa05
              END CASE
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
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
           IF INT_FLAG THEN RETURN END IF
       END IF
    END IF
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')         #MOD-G80103 add
   #LET g_sql= "SELECT UNIQUE boa01, boa02, boa08 FROM boa_file ",          #MOD-G80103 mark
    LET g_sql= "SELECT UNIQUE boa01, boa02, boa08, ta_boa01 ",              #MOD-G80103 add   #20250212
               "  FROM bma_file,boa_file ",
               "  LEFT JOIN ima_file b ON boa03 = b.ima01 ",                #20230714
               "  LEFT JOIN ima_file a ON boa01 = a.ima01 ",                #20230714
               " WHERE ", g_wc CLIPPED,
               "   AND boa01 = bma01 AND bma06 = ' ' ",                     #MOD-G80103 add
               " ORDER BY boa01, boa02"
 
    PREPARE i610_prepare FROM g_sql          #預備一下
    DECLARE i610_b_curs                      #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i610_prepare
 
   #LET g_sql = "SELECT UNIQUE boa01,boa02 FROM boa_file ",                 #MOD-G80103 mark
    LET g_sql = "SELECT UNIQUE boa01,boa02 FROM bma_file,boa_file ",        #MOD-G80103 add
                "  LEFT JOIN ima_file b ON boa03 = b.ima01 ",               #20230714
                "  LEFT JOIN ima_file a ON boa01 = a.ima01 ",               #20230714
                " WHERE ",g_wc CLIPPED,
                "   AND boa01 = bma01 AND bma06 = ' ' ",                    #MOD-G80103 add
                " GROUP BY boa01,boa02 "
 
    PREPARE i610_precount FROM g_sql
    DECLARE i610_count CURSOR FOR i610_precount
 
END FUNCTION
 
 
FUNCTION i610_menu()                         #中文的MENU
   DEFINE   l_cmd  LIKE type_file.chr50      #No.FUN-680096 VARCHAR(50)
   DEFINE   l_cnt  LIKE type_file.num5       #20250212
 
   WHILE TRUE
      ##---- 20190709 資料清單 (S)
      #CALL i610_bp("G")
      CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "main")
            CALL i610_bp("G")
         WHEN (g_action_flag = "page_list")
            CALL i610_list_fill()
            CALL i610_bp1("G")
            IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
               SELECT boa_file.* INTO boa_l.* FROM boa_file
                WHERE boa01=g_boa_1[l_ac1].boa01_1
            END IF
            IF g_action_choice!= "" THEN
               LET g_action_flag = 'main'
               LET l_ac1 = ARR_CURR()
               LET g_jump = l_ac1
               LET g_no_ask = TRUE 
               IF g_rec_b1 >0 THEN
                   CALL i610_fetch('/')
               END IF
               CALL cl_set_comp_visible("page_list", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page_list", TRUE)
             END IF
      END CASE

      ##---- 20190709 資料清單 (E)
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i610_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i610_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i610_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i610_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i610_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i610_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "替代群組"
         WHEN "sub_group"
            IF cl_chk_act_auth() AND NOT cl_null(g_boa01) THEN
               CALL i610_v()
            END IF
         #----20200130 add
         #WHEN "series"
         #   IF cl_chk_act_auth() AND NOT cl_null(g_boa01) THEN
         #      LET g_msg = "cooi103 '",g_boa01 CLIPPED,"' '",g_boa02 CLIPPED,"'"
         #      CALL cl_cmdrun(g_msg)
         #   END IF
         #----20200130 add
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_boa01 IS NOT NULL THEN
                  LET g_doc.column1 = "boa01"
                  LET g_doc.value1  = g_boa01
                  LET g_doc.column2 = "boa02"
                  LET g_doc.value2  = g_boa02
                  LET g_doc.column3 = "boa08"
                  LET g_doc.value3  = g_boa08
                  CALL cl_doc()
               END IF
            END IF

         ##---- 20210414 add by momo (S)
         WHEN "carry"            #資料拋轉
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL i610_carry()
            END IF

         WHEN "qry_carry_history" #拋轉資料查詢
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_boa01) THEN  #No.FUN-830090
                  LET g_cmd='aooq604 "',g_plant,'" "2" "',g_prog,'" "',g_boa01,'"'
                  CALL cl_cmdrun(g_cmd)
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF
         ##---- 20210414 add by momo (E)

         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              ##---- 20190709 資料清單 (S)
              #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_boa),'','')
              LET w = ui.Window.getCurrent()
              LET f = w.getForm()
              CASE 
                 WHEN (g_action_flag IS NULL) OR (g_action_flag = 'main')
                     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_boa),'','')
                 WHEN (g_action_flag = 'page_list')
                     LET page = f.FindNode("Page","page_list")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_boa_1),'','')
                 END CASE
                 LET g_action_choice = NULL
              ##---- 20190709 資料清單 (E)
            END IF
         #M014 180130 By TSD.Andy -----(S) 
         #@WHEN 複製 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i610_copy()
            END IF
         OTHERWISE EXIT CASE
         #M014 180130 By TSD.Andy -----(E)
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i610_a()                            #Add  輸入
 
    MESSAGE ""
 
    CLEAR FORM
    CALL g_boa.clear()
   #LET g_wc = NULL #MOD-D60215 mark
    INITIALIZE g_boa01 LIKE boa_file.boa01   #預設值及將數值類變數清成零
    INITIALIZE g_boa02 LIKE boa_file.boa02
    INITIALIZE g_boa08 LIKE boa_file.boa08
    INITIALIZE g_ta_boa01 LIKE boa_file.ta_boa01  #20250212
 
    CALL cl_opmsg('a')
 
    WHILE TRUE
        ##---- 20230713 多營運中心資料使用檢核(S)
        IF NOT s_dc_ud_flag('2',g_plant,g_plant,'a') THEN
           CALL cl_err(g_plant,'aoo-078',1)
           EXIT WHILE
        END IF
        ##---- 20230713 多營運中心資料使用檢核(E)
        LET g_check_bma01 = 'Y'
        CALL i610_i("a")                     #輸入單頭
 
        IF INT_FLAG THEN                     #使用者不玩了
            LET g_boa01=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 
        LET g_rec_b = 0                    #No.FUN-680064
        IF g_ss='N' THEN
            CALL g_boa.clear()
        ELSE
            CALL i610_b_fill('1=1')          #單身
        END IF
 
        CALL i610_b()                        #輸入單身
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i610_u()
 
DEFINE l_boa01_t     LIKE boa_file.boa01,
       l_boa02_t     LIKE boa_file.boa02,
       l_boa08_t     LIKE boa_file.boa08,  
       l_ta_boa01_t  LIKE boa_file.ta_boa01  #20250212 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_boa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    CALL i610_show()
    WHILE TRUE
        LET l_boa01_t = g_boa01 
        LET l_ta_boa01_t = g_ta_boa01         #20250212
        LET l_boa02_t = g_boa02
        LET l_boa08_t = g_boa08
        CALL i610_i("u")                      #欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_boa01 = l_boa01_t
           LET g_ta_boa01 = l_ta_boa01_t      #20250212
           LET g_boa02 = l_boa02_t
           LET g_boa08 = l_boa08_t
           CALL i610_show()
           CALL cl_err('','9001',0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
 
        IF g_boa01 != l_boa01_t OR g_boa02 != l_boa02_t
        OR ( g_ta_boa01 != l_ta_boa01_t)                    #20250212
        OR ( g_boa08 != l_boa08_t OR
           ( NOT cl_null(g_boa08) AND cl_null(l_boa08_t))) THEN
            IF g_chkey = "Y" THEN
                UPDATE boa_file
                   SET boa01=g_boa01,
                       boa02=g_boa02,
                       boa08=g_boa08,
                       ta_boa01 = g_ta_boa01               #20250212
                 WHERE boa01=l_boa01_t AND boa02=l_boa02_t
            ELSE
                UPDATE boa_file SET boa08 = g_boa08,
                                    ta_boa01 = g_ta_boa01  #20250212
                 WHERE boa01=l_boa01_t AND boa02=l_boa02_t
            END IF
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                CALL cl_err(g_boa01,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("upd","boa_file",l_boa01_t,l_boa02_t,SQLCA.sqlcode,"","",1) #TQC-660046
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
FUNCTION i610_i(p_cmd)                       #處理INPUT
 
DEFINE
    p_cmd  LIKE type_file.chr1       #a:輸入 u:更改   #No.FUN-680096 VARCHAR(1)
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT g_boa01,g_ta_boa01,g_boa02,g_boa08 WITHOUT DEFAULTS   #20250212 modify
        FROM boa01,ta_boa01,boa02,boa08                         #20250212 modify
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i610_set_entry(p_cmd)
            CALL i610_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        BEFORE FIELD boa01
            IF p_cmd="u" AND g_chkey="N" THEN NEXT FIELD boa08 END IF
 
        AFTER FIELD boa01                    #料件編號
            IF NOT cl_null(g_boa01) THEN
               #FUN-AA0059 -----------------------add start----------------------------
                IF NOT s_chk_item_no(g_boa01,'') THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD boa01
                END IF 
               #FUN-AA0059 ----------------------add end------------------------------ 
                CALL i610_boa01(p_cmd)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err("ItemNo.:",g_errno,0)
                    NEXT FIELD boa01
                END IF
            END IF
 
        BEFORE FIELD boa02
            SELECT MAX(boa02) INTO g_boa02 FROM boa_file
             WHERE boa01 = g_boa01
            IF cl_null(g_boa02) THEN
                LET g_boa02 = 1
            ELSE
                LET g_boa02 = g_boa02 + 1
            END IF
            DISPLAY g_boa02 TO boa02
 
        AFTER FIELD boa02
            IF NOT cl_null(g_boa02) THEN
                CALL i610_boa02(p_cmd)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err("Serial:",g_errno,0)
                    NEXT FIELD boa02
                END IF
               NEXT FIELD boa08
            END IF

         ##---- 20241214 add (S)
         AFTER FIELD boa08
           IF cl_null(g_boa08) THEN
              NEXT FIELD boa08
           END IF
         ##---- 20241214 add (E)
  
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(boa01)
#                   CALL q_ima(0,0,g_boa01) RETURNING g_boa01
#FUN-AA0059 --Begin--
                  #  CALL cl_init_qry_var()
                  #  LET g_qryparam.form = "q_ima"
                  #  LET g_qryparam.default1 = g_boa01
                  #  CALL cl_create_qry() RETURNING g_boa01
                    CALL q_sel_ima(FALSE, "q_ima", "", g_boa01, "", "", "", "" ,"",'' )  RETURNING g_boa01
#FUN-AA0059 --End--
                    DISPLAY BY NAME g_boa01
                    NEXT FIELD boa01
               OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION controlg       #TQC-860021
           CALL cl_cmdask()      #TQC-860021
 
        ON IDLE g_idle_seconds   #TQC-860021
           CALL cl_on_idle()     #TQC-860021
           CONTINUE INPUT        #TQC-860021
 
        ON ACTION about          #TQC-860021
           CALL cl_about()       #TQC-860021
 
        ON ACTION help           #TQC-860021
           CALL cl_show_help()   #TQC-860021
    END INPUT
END FUNCTION
 
FUNCTION  i610_boa01(p_cmd)
 
DEFINE
    p_cmd           LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
    l_desc          LIKE fan_file.fan02,      #No.FUN-680096 VARCHAR(4) 
    l_cnt           LIKE type_file.num5,      #No.FUN-680096 SMALLINT
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
   #l_ima05         LIKE ima_file.ima05,      #20250212 mark
    l_ima08         LIKE ima_file.ima08,
    l_imaacti       LIKE ima_file.imaacti,
    l_boa02         LIKE boa_file.boa02
DEFINE
    g_flag2         LIKE type_file.chr1      #20241111

    ##---- 20241111 (S)
    CALL s_field_chk(g_boa01,'1',g_plant,'ima01') RETURNING g_flag2
    IF g_flag2 = '0' THEN
       CALL cl_err(g_boa01,'aoo-043',1)
       LET g_boa01 = ''
       DISPLAY BY NAME g_boa01
       RETURN 
    END IF
    ##---- 20241111 (E)

 
    LET g_errno = ""
 
   #SELECT ima02,ima021,ima05,ima08,imaacti                            #20250212 mark
   #  INTO l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti FROM ima_file    #20250212 mark
    SELECT ima02,ima021,ima08,imaacti                                  #20250212 modify
      INTO l_ima02,l_ima021,l_ima08,l_imaacti FROM ima_file            #20250212 modify
     WHERE ima01=g_boa01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
                                 # LET l_ima05 = NULL                  #20250212 mark
                                   LET l_ima08 = NULL
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N'        LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
 
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) THEN
       #CHECK此上階料號是否存在BOM單頭中
       # YES :單身所輸入的料件皆須存在此料件之BOM明細中(bmb_file)
       # NO  :單身所輸入的料件不須存在此料件之BOM明細中(bmb_file)
        SELECT COUNT(*) INTO l_cnt FROM bma_file
         WHERE bma01 = g_boa01
        IF l_cnt > 0 THEN
           LET g_check_bma01 = 'Y'
        ELSE
           LET g_check_bma01 = 'N'
        END IF
    END IF
 
    IF p_cmd='d' OR cl_null(g_errno) THEN
        DISPLAY l_ima02 TO FORMONLY.ima02
        DISPLAY l_ima021 TO FORMONLY.ima021
      # DISPLAY l_ima05 TO FORMONLY.ima05            #20250212 mark
        DISPLAY l_ima08 TO FORMONLY.ima08
    END IF
 
END FUNCTION
 
FUNCTION  i610_boa02(p_cmd)
 
DEFINE
    p_cmd    LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
    LET g_errno = " "
 
    SELECT DISTINCT boa02 FROM boa_file
     WHERE boa01 = g_boa01 AND boa02 = g_boa02
    IF SQLCA.SQLCODE THEN
        IF SQLCA.SQLCODE != 100 THEN
            LET g_errno = SQLCA.sqlcode USING "-------"
        END IF
    ELSE
        LET g_ss="N"                         #進入單身的 sw
    END IF
END FUNCTION
 
FUNCTION i610_q()                            #Query 查詢
DEFINE l_boa        RECORD
       boa01        LIKE boa_file.boa01,
       boa02        LIKE boa_file.boa02
                    END RECORD,
       l_cnt        LIKE type_file.num5     #定義單頭總數   #No.FUN-680096 SMALLINT
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_boa01 TO NULL               #No.FUN-6A0002
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i610_curs()                         #取得查詢條件
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_boa01 TO NULL
        RETURN
    END IF
    OPEN i610_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.SQLCODE THEN                    #有問題
        CALL cl_err("",SQLCA.SQLCODE,0)
        INITIALIZE g_boa01 TO NULL
    ELSE
        FOREACH i610_count INTO l_boa.*
            LET g_row_count = g_row_count + 1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i610_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i610_fetch(p_flag)                  #處理資料的讀取
 
DEFINE
    p_flag     LIKE type_file.chr1       #處理方式    #No.FUN-680096 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i610_b_curs INTO g_boa01, g_boa02, g_boa08, g_ta_boa01 #20250212
        WHEN 'P' FETCH PREVIOUS i610_b_curs INTO g_boa01, g_boa02, g_boa08, g_ta_boa01 #20250212
        WHEN 'F' FETCH FIRST    i610_b_curs INTO g_boa01, g_boa02, g_boa08, g_ta_boa01 #20250212
        WHEN 'L' FETCH LAST     i610_b_curs INTO g_boa01, g_boa02, g_boa08, g_ta_boa01 #20250212
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i610_b_curs INTO g_boa01,g_boa02,g_boa08,g_ta_boa01  #20250212
    END CASE
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_boa01,SQLCA.sqlcode,0)
       INITIALIZE g_boa01 TO NULL
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
 
    CALL i610_show()
 
END FUNCTION
 
FUNCTION i610_show()                         #將資料顯示在畫面上
 
 DEFINE  l_tot    LIKE type_file.num5        #No.FUN-680096 SMALLINT 
 DEFINE  l_cnt    LIKE type_file.num5        #20200130

    DISPLAY g_boa01, g_boa02, g_boa08, g_ta_boa01   #假單頭 #20250212 
         TO boa01, boa02, boa08, ta_boa01                   #20250212
    CALL i610_boa01('d')                     #單身
 
    CALL i610_b_fill(g_wc)                   #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    CALL i610_show_icon()         #20200131
END FUNCTION

##---- 20200131 add (S)
#系列別有設定時顯示圖示與顏色
FUNCTION i610_show_icon()                         
 DEFINE  l_cnt    LIKE type_file.num5        

    LET l_cnt= 0
    SELECT COUNT(*) INTO l_cnt
      FROM tc_aad_file
     WHERE tc_aad01 = g_boa01 AND tc_aad02 = g_boa02
    IF l_cnt > 0 THEN
       LET w = ui.Window.getCurrent()
       LET page = w.findNode("Action","series")
       CALL page.setAttribute("image","information")
       DISPLAY g_boa02 TO boa02 ATTRIBUTE(REVERSE,BOLD,RED)
    ELSE
       LET w = ui.Window.getCurrent()
       LET page = w.findNode("Action","series")
       CALL page.setAttribute("image","")
    END IF
END FUNCTION 
##---- 20200131 add (E) 

FUNCTION i610_r()                            #取消整筆 (所有合乎單頭的資料)
DEFINE l_boa        RECORD
       boa01        LIKE boa_file.boa01,
       boa02        LIKE boa_file.boa02
       END RECORD,
       l_cnt        LIKE type_file.num5,          #No.FUN-680096 SMALLINT
       l_i          LIKE type_file.num5      #CHI-D10033
     
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_boa01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_success = 'Y'
 
    BEGIN WORK
    IF l_cnt > 0 THEN
       IF NOT cl_confirm('abm-800') THEN
          ROLLBACK WORK
          RETURN
       END IF
    ELSE
       IF NOT cl_delh(0,0) THEN                   #確認一下
          ROLLBACK WORK
          RETURN
       END IF
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "boa01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1  = g_boa01      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "boa02"      #No.FUN-9B0098 10/02/24
       LET g_doc.value2  = g_boa02      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "boa08"      #No.FUN-9B0098 10/02/24
       LET g_doc.value3  = g_boa08      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                            #No.FUN-9B0098 10/02/24
    END IF
    IF l_cnt > 0 THEN
       IF g_success = 'N' THEN
          ROLLBACK WORK
          RETURN
       END IF
    END IF
 
    DELETE FROM boa_file WHERE boa01 = g_boa01 AND boa02 = g_boa02
    DELETE FROM bob_file WHERE bob01 = g_boa01 AND bob02 = g_boa02  #20250214 應一併刪除替代群組
    IF SQLCA.sqlcode THEN
 #       CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("del","boa_file",g_boa01,g_boa02,SQLCA.sqlcode,"","BODY DELETE",1) #TQC-660046
        ROLLBACK WORK
        CALL cl_rbmsg(1)
        RETURN  
    ELSE
        #CHI-D10033---begin
        FOR l_i = 1 TO g_boa.getLength()
           ##---- 20180521 by momo 判斷是否存在取代
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM bmd_file
            WHERE bmd01=g_boa[l_i].boa03 AND (bmd08='ALL' OR bmd08=g_boa01)
              AND bmd06 IS NULL AND bmd02='1'
           IF l_cnt > 0 THEN
              UPDATE bmb_file
                 SET bmb16='1'
               WHERE bmb01 = g_boa01
                 AND bmb03 = g_boa[l_i].boa03
           ELSE
             #判斷是否存在替代
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM bmd_file
              WHERE bmd01=g_boa[l_i].boa03 AND (bmd08='ALL' OR bmd08=g_boa01)
                AND bmd06 IS NULL AND bmd02='2'
             IF l_cnt > 0 THEN
                UPDATE bmb_file
                   SET bmb16='2'
                 WHERE bmb01 = g_boa01
                   AND bmb03 = g_boa[l_i].boa03
             ELSE
              LET l_cnt = 0
              SELECT COUNT(*)
                INTO l_cnt
                FROM boa_file
               WHERE boa01 = g_boa01
                 AND boa03 = g_boa[l_i].boa03
              IF l_cnt = 0 THEN
                 UPDATE bmb_file 
                    SET bmb16='0'
                  WHERE bmb01 = g_boa01
                    AND bmb03 = g_boa[l_i].boa03
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","bmb_file","",g_boa[l_i].boa03,SQLCA.sqlcode,"","",0)
                 END IF
              END IF
            END IF #20180521
           END IF  #20180521 
        END FOR 
        #CHI-D10033---end
        CLEAR FORM
        CALL g_boa.clear()
        LET g_row_count = 0
        FOREACH i610_count INTO l_boa.*
            LET g_row_count = g_row_count + 1
        END FOREACH
        

       #MOD-D60215-Start-Mark
       ##FUN-B50062-add-start--
       #IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
       #   CLOSE i610_b_curs
       #   CLOSE i610_count
       #   COMMIT WORK
       #   RETURN
       #END IF
       ##FUN-B50062-add-end--
       #MOD-D60215-End-Mark 
        
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i610_b_curs
        
        
        
        IF g_row_count >= 1 THEN                            #MOD-D60215 add if 判斷
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i610_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET g_no_ask = TRUE
              CALL i610_fetch('/')
           END IF
        END IF                                              #MOD-D60215 add


       LET g_cnt=SQLCA.SQLERRD[3]                         
       MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'   
       COMMIT WORK
    END IF

    
 
    #LET g_msg=TIME  #FUN-DA0126
    #重要資料異動記錄 aoo/azo_file
    #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)#FUN-980001 add plant & legal #FUN-DA0126
    #   VALUES ('abmi610',g_user,g_today,g_msg,g_boa01,'delete',g_plant,g_legal)#FUN-980001 add plant & legal #FUN-DA0126

    #MOD-D60215---add---str--
    IF cl_null(g_row_count) OR g_row_count = 0 THEN
        INITIALIZE g_boa01 LIKE boa_file.boa01   #預設值及將數值類變數清成零
        INITIALIZE g_boa02 LIKE boa_file.boa02
        INITIALIZE g_boa08 LIKE boa_file.boa08
    END IF
    #MOD-D60215---add---end--
 
END FUNCTION
 
FUNCTION i610_b()                          #單身
 
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態    #No.FUN-680096 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(80)
    l_tot           LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    l_cnt           LIKE type_file.num5,     #檢查重複用  #No.FUN-680096 SMALLINT
    l_allow_insert  LIKE type_file.num5,     #可新增否    #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否    #No.FUN-680096 SMALLINT
DEFINE   l_bmb10    LIKE bmb_file.bmb10
DEFINE   l_bmb06    LIKE bmb_file.bmb06      #20231006
DEFINE   l_bmb07    LIKE bmb_file.bmb07      #20231006
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_boa01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT boa03,'','',0,0,boa04,boa05,boa06,boa07,ta_boadate,ta_boamodu,0 ", #20191007 #20230714 #20231011
       "  FROM boa_file ",
       "  WHERE boa01= ? ",
       "   AND boa02= ? ",
       "   AND boa03= ? ",
       "   AND boa04= ? ",
       "   AND boa05= ? ",
       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i610_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_boa WITHOUT DEFAULTS FROM s_boa.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_before_input_done = FALSE
            CALL i610_set_entry_b(p_cmd)
            CALL i610_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac   = ARR_CURR()
            LET l_lock_sw = 'N'              #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_boa_t.* = g_boa[l_ac].*  #BACKUP
                BEGIN WORK
 
                OPEN i610_bcl USING g_boa01,g_boa02,g_boa_t.boa03,g_boa_t.boa04,g_boa_t.boa05
                IF STATUS THEN
                    CALL cl_err("OPEN i610_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i610_bcl INTO g_boa[l_ac].*
                    IF SQLCA.SQLCODE THEN
                        CALL cl_err("P/NSpec:",SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    LET g_boa_t.*=g_boa[l_ac].*
                    SELECT ima02,ima021 INTO g_boa[l_ac].ima02b,g_boa[l_ac].ima021b FROM ima_file
                     WHERE ima01 = g_boa[l_ac].boa03

                    ##---20231011 (S)
                    SELECT bmb06,bmb07 INTO g_boa[l_ac].bmb06,g_boa[l_ac].bmb07
                      FROM bmb_file
                     WHERE bmb01 = g_boa01
                       AND bmb03 = g_boa[l_ac].boa03
                       AND bmb05 IS NULL          #20240911 排除失效BOM
                    ##---20231011 (E)
                    IF SQLCA.sqlcode THEN
                        LET g_boa[l_ac].ima02b=" "
                        LET g_boa[l_ac].ima021b=" "
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD boa03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
             INSERT INTO boa_file (boa01,boa02,boa03,boa04,boa05,boa06,boa07,boa08,ta_boadate,ta_boamodu) #No.MOD-470041 #20191007
                 VALUES (g_boa01,g_boa02,g_boa[l_ac].boa03,g_boa[l_ac].boa04,
                         g_boa[l_ac].boa05,g_boa[l_ac].boa06,g_boa[l_ac].boa07,
                         g_boa08,
                         g_today,g_user)  #20191007
            IF SQLCA.sqlcode THEN
 #               CALL cl_err(g_boa02,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("ins","boa_file",g_boa01,g_boa02,SQLCA.sqlcode,"","",1)  #TQC-660046
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            #CHI-D10033---begin
            UPDATE bmb_file SET bmb16='5' WHERE
               bmb01=g_boa01 AND bmb03=g_boa[l_ac].boa03
            #CHI-D10033---end
        BEFORE INSERT
            #CKP
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_boa[l_ac].* TO NULL       #900423
            LET g_boa_t.* = g_boa[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD boa03
 
        AFTER FIELD boa03
            IF NOT cl_null(g_boa[l_ac].boa03) THEN
              ##----- 20210630 add by momo (S) cooi103 檢核
              CALL cl_chktcaad(g_boa[l_ac].boa03,g_boa01) RETURNING g_errno
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD boa03
              END IF
              ##----- 20210630 add by momo (E)
              #FUN-AA0059 ------------------------------add start-----------------------
               IF NOT s_chk_item_no(g_boa[l_ac].boa03,'') THEN
                  CALL cl_err('',g_errno,1) 
                  NEXT FIELD boa03
               END IF 
              #FUN-AA0059 ------------------------------add end--------------------------
              #元件料號不可等於[上階主件]
               IF g_boa[l_ac].boa03 = g_boa01 THEN
                  CALL cl_err(g_boa[l_ac].boa03,'abm-016',0)
                  NEXT FIELD boa03
               END IF
               CALL i610_boa03("a")
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_boa[l_ac].boa03,g_errno,0) 
                  NEXT FIELD boa03
               END IF
            ELSE
                LET g_boa[l_ac].ima02b = " "
                LET g_boa[l_ac].ima021b = " "
            END IF
 
        AFTER FIELD boa04
            ##---- 20231006 ---(S)
            SELECT bmb10,bmb06,bmb07
              INTO g_boa[l_ac].boa05,g_boa[l_ac].bmb06,g_boa[l_ac].bmb07
              FROM bmb_file
             WHERE bmb01 = g_boa01
               AND bmb03 = g_boa[l_ac].boa03
               AND bmb09 = g_boa[l_ac].boa04
               AND bmb05 IS NULL    #20240911 排除失效BOM
            ##---- 20231006 ---(E)

            IF g_boa[l_ac].boa04 IS NULL THEN
               LET g_boa[l_ac].boa04=" "
            END IF
            IF NOT cl_null(g_boa[l_ac].boa04) THEN
               CALL i610_boa04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_boa[l_ac].boa04,g_errno,0)
                  NEXT FIELD boa04
               END IF
            END IF
 
        AFTER FIELD boa05
            IF NOT cl_null(g_boa[l_ac].boa05) THEN
                CALL i610_boa05('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_boa[l_ac].boa05,g_errno,0) 
                    NEXT FIELD boa05
                END IF
                #CHECK KEY值是否有重覆
                IF p_cmd='a' OR ( p_cmd = 'u' AND
                   ( g_boa_t.boa03 !=g_boa[l_ac].boa03
                   OR g_boa_t.boa04 !=g_boa[l_ac].boa04
                   OR g_boa_t.boa05 !=g_boa[l_ac].boa05 )) THEN
                   LET l_cnt = 0
                   SELECT COUNT(*) INTO l_cnt FROM boa_file
                    WHERE boa01 = g_boa01
                      AND boa02 = g_boa02
                      AND boa03 = g_boa[l_ac].boa03
                      AND boa04 = g_boa[l_ac].boa04
                      AND boa05 = g_boa[l_ac].boa05
                   IF l_cnt > 0 THEN
                      CALL cl_err(g_boa[l_ac].boa03,'-239',0)
                      NEXT FIELD boa05
                   END IF
 
                   #CHECK所輸入的料件資料是否已存在上階料其他替代料資料中
                   LET l_cnt = 0
                   SELECT COUNT(*) INTO l_cnt FROM boa_file
                    WHERE boa01 = g_boa01
                      AND boa02 != g_boa02
                      AND boa03 = g_boa[l_ac].boa03
                      AND boa04 = g_boa[l_ac].boa04
                      AND boa05 = g_boa[l_ac].boa05
                   IF l_cnt > 0 THEN
                      #CALL cl_err(g_boa[l_ac].boa03,'abm-017',0)  #20210707 mark 
                      #NEXT FIELD boa05                            #20210707 mark
                      CALL cl_err(g_boa[l_ac].boa03,'abm-017',1)   #20210707 modify
                   END IF
                END IF
            END IF
 
        BEFORE FIELD boa06
            IF cl_null(g_boa[l_ac].boa06) THEN
                LET g_boa[l_ac].boa06 = g_today
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_boa[l_ac].boa06
                #------MOD-5A0095 END------------
            END IF
 
        AFTER FIELD boa06
            IF NOT cl_null(g_boa[l_ac].boa06) THEN
                IF NOT cl_null(g_boa[l_ac].boa07) THEN
                   #失效日期不可小於生效日期
                   IF g_boa[l_ac].boa06 > g_boa[l_ac].boa07 THEN
                      CALL cl_err(g_boa[l_ac].boa07,'mfg2604',1)
                      NEXT FIELD boa06
                   END IF
                END IF
            END IF
 
        AFTER FIELD boa07
            IF NOT cl_null(g_boa[l_ac].boa07) THEN
              #失效日期不可小於生效日期
               IF g_boa[l_ac].boa06 > g_boa[l_ac].boa07 THEN
                  CALL cl_err(g_boa[l_ac].boa07,'mfg2604',1)
                  NEXT FIELD boa06
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_boa_t.boa03) THEN
               IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
               END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
               DELETE FROM boa_file
                WHERE boa01 = g_boa01       AND boa02 = g_boa02
                  AND boa03 = g_boa_t.boa03 AND boa04 = g_boa_t.boa04
                  AND boa05 = g_boa_t.boa05
               IF SQLCA.SQLCODE THEN
 #                  CALL cl_err("Del-ItemNo.:",SQLCA.SQLCODE,0) #No.TQC-660046
                   CALL cl_err3("del","boa_file",g_boa01,g_boa02,SQLCA.sqlcode,"","Del-ItemNo",1)  #TQC-660046
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               #CHI-D10033---begin
               ##---- 20180521 by momo 判斷是否存在取代
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM bmd_file
                WHERE bmd01=g_boa_t.boa03 AND (bmd08='ALL' OR bmd08=g_boa01)
                  AND bmd06 IS NULL AND bmd02='1'
               IF l_cnt > 0 THEN
                  UPDATE bmb_file
                     SET bmb16='1'
                   WHERE bmb01 = g_boa01
                     AND bmb03 = g_boa_t.boa03
               ELSE
               #判斷是否存在替代
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM bmd_file
                WHERE bmd01=g_boa_t.boa03 AND (bmd08='ALL' OR bmd08=g_boa01)
                  AND bmd06 IS NULL AND bmd02='2'
               IF l_cnt > 0 THEN
                  UPDATE bmb_file
                     SET bmb16='2'
                   WHERE bmb01 = g_boa01
                     AND bmb03 = g_boa_t.boa03
               ELSE
                 LET l_cnt = 0
                 SELECT COUNT(*)
                   INTO l_cnt
                   FROM boa_file
                  WHERE boa01 = g_boa01
                    AND boa03 = g_boa_t.boa03
                 IF l_cnt = 0 THEN
                    UPDATE bmb_file 
                       SET bmb16='0'
                     WHERE bmb01 = g_boa01
                       AND bmb03 = g_boa_t.boa03
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","bmb_file","",g_boa_t.boa03,SQLCA.sqlcode,"","",0)
                     END IF
                  END IF 
                END IF   #20180521 
              END IF     #20180521
               #CHI-D10033---end
               COMMIT WORK
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_boa[l_ac].* = g_boa_t.*
               CLOSE i610_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_boa[l_ac].boa03,-263,1)
                LET g_boa[l_ac].* = g_boa_t.*
            ELSE
                UPDATE boa_file
                  SET boa03=g_boa[l_ac].boa03,
                      boa04=g_boa[l_ac].boa04,
                      boa05=g_boa[l_ac].boa05,
                      boa06=g_boa[l_ac].boa06,
                      boa07=g_boa[l_ac].boa07,
                      ta_boadate = g_today,  #20191007
                      ta_boamodu = g_user    #20191007
                WHERE boa01=g_boa01
                  AND boa02=g_boa02
                  AND boa03=g_boa_t.boa03
                  AND boa04=g_boa_t.boa04
                  AND boa05=g_boa_t.boa05
                IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
 #                   CALL cl_err(g_boa[l_ac].boa03,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("upd","boa_file",g_boa01,g_boa02,SQLCA.sqlcode,"","",1) #TQC-660046
                    LET g_boa[l_ac].* = g_boa_t.*
                    ROLLBACK WORK
                ELSE
                    ##---20210414 mark by momo (S) BOM同步不可因失效更新BOM
                    ##---20180817 by momo 修正失效時未更新BOM資料 (S)
                    { 
                    IF NOT cl_null(g_boa[l_ac].boa07) THEN
                       LET l_cnt = 0
                       SELECT COUNT(*) INTO l_cnt FROM bmd_file
                        WHERE bmd01 = g_boa_t.boa03 AND (bmd08='ALL' OR bmd08=g_boa01)
                          AND bmd06 IS NULL AND bmd02='1'
                       IF l_cnt > 0 THEN
                          UPDATE bmb_file
                             SET bmb16='1'
                           WHERE bmb01 = g_boa01
                            AND bmb03 = g_boa_t.boa03 
                       ELSE
                          UPDATE bmb_file
                             SET bmb16='0'
                           WHERE bmb01 = g_boa01
                            AND bmb03 = g_boa_t.boa03
                       END IF
                    END IF
                    
                    ##---20180817 by momo 修正失效時未更新BOM資料 (E)
                    ##---20210414 mark by momo (E) BOM同步不可因失效更新BOM

                    #CHI-D10033---begin
                    
                     IF g_boa[l_ac].boa03 <> g_boa_t.boa03 THEN                    
                       LET l_cnt = 0
                       SELECT COUNT(*)
                         INTO l_cnt
                         FROM boa_file
                        WHERE boa01 = g_boa01
                          AND boa03 = g_boa_t.boa03
                       IF l_cnt = 0 THEN
                          UPDATE bmb_file 
                             SET bmb16='0'
                           WHERE bmb01 = g_boa01
                            AND bmb03 = g_boa_t.boa03
                          IF SQLCA.sqlcode THEN
                             CALL cl_err3("upd","bmb_file","",g_boa_t.boa03,SQLCA.sqlcode,"","",0)
                          END IF 
                       END IF  
                       UPDATE bmb_file 
                          SET bmb16='5'
                        WHERE bmb01 = g_boa01
                         AND bmb03 = g_boa[l_ac].boa03
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd","bmb_file","",g_boa[l_ac].boa03,SQLCA.sqlcode,"","",0)
                       END IF
                    END IF 
                    #CHI-D10033---end
                    }
                    COMMIT WORK
                    CALL cs_updbmb16(g_boa01,g_boa_t.boa03,'S')   #20220530 更新BOM取替代狀態
                    MESSAGE "UPDATE O.K"
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_boa[l_ac].* = g_boa_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_boa.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i610_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #CKP
          #LET g_boa_t.* = g_boa[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i610_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(boa03)     #元件料號
                  IF g_check_bma01 = 'Y' THEN
##Genero:兩種做法,hot code 會解決qry原本組合sql及回傳超過四個值的狀況
#                    CALL q_bmb3(FALSE,TRUE,g_boa01,g_boa[l_ac].boa03,
#                                g_boa[l_ac].boa04,g_boa[l_ac].boa05)
#                         RETURNING g_msg, g_boa[l_ac].boa03,g_boa[l_ac].boa04,g_boa[l_ac].boa05
##CALL FGL_DIALOG_SETBUFFER( g_msg )
##CALL FGL_DIALOG_SETBUFFER(  g_boa[l_ac].boa03 )
##CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa04 )
##CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa05 )
##CALL q_bmb3分支出去的q_bmb302且要在主程式將最後沒回傳到的值再SELECT出來
##不過, boa04,boa05後面都還會再開出其他的qry查詢, 是否boa03這邊要回傳boa04,05?
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmb302"
                     LET g_qryparam.default1 = g_boa01
                     LET g_qryparam.default2 = g_boa[l_ac].boa03
                     LET g_qryparam.default3 = g_boa[l_ac].boa04
                     LET g_qryparam.arg1     = g_boa01
                     CALL cl_create_qry() RETURNING g_msg, g_boa[l_ac].boa03,g_boa[l_ac].boa04
#                     CALL FGL_DIALOG_SETBUFFER( g_msg )
#                     CALL FGL_DIALOG_SETBUFFER(  g_boa[l_ac].boa03 )
#                     CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa04 )
                      DISPLAY BY NAME g_boa[l_ac].boa03           #No.MOD-490371
                      DISPLAY BY NAME g_boa[l_ac].boa04           #No.MOD-490371
                     ##--- 20231006 modify
                     SELECT bmb10,bmb06,bmb07 INTO l_bmb10,l_bmb06,l_bmb07
                       FROM bmb_file
                      WHERE bmb01 = g_boa01
                        AND bmb03 = g_boa[l_ac].boa03
                        AND bmb05 IS NULL                #20240911 排除失效BOM
                     DISPLAY l_bmb10 TO boa05
                     DISPLAY l_bmb06 TO bmb06
                     DISPLAY l_bmb07 TO bmb07
                     ##--- 20231006 modify
                  ELSE
#                    CALL q_ima(4,0,g_boa[l_ac].boa03) RETURNING g_boa[l_ac].boa03
#                    CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa03 )
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima"
                   #  LET g_qryparam.default1 = g_boa[l_ac].boa03
                   #  CALL cl_create_qry() RETURNING g_boa[l_ac].boa03
                      CALL q_sel_ima(FALSE, "q_ima", "", g_boa[l_ac].boa03, "", "", "", "" ,"",'' )  RETURNING g_boa[l_ac].boa03
#FUN-AA0059 --End--
#                     CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa03 )
                      DISPLAY BY NAME g_boa[l_ac].boa03           #No.MOD-490371
                     CALL i610_boa03('a')
                  END IF
                  NEXT FIELD boa03
 
                WHEN INFIELD(boa04)     #作業編號
                   CALL q_ecd(FALSE,TRUE,g_boa[l_ac].boa04) RETURNING g_boa[l_ac].boa04
#                   CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa04 )
                   DISPLAY g_boa[l_ac].boa04 TO boa04
                   NEXT FIELD boa04
 
                WHEN INFIELD(boa05)     #單位
#                    CALL q_gfe(3,3,g_boa[l_ac].boa05) RETURNING g_boa[l_ac].boa05
#                    CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa05 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.default1 = g_boa[l_ac].boa05
                     CALL cl_create_qry() RETURNING g_boa[l_ac].boa05
#                     CALL FGL_DIALOG_SETBUFFER( g_boa[l_ac].boa05 )
                     NEXT FIELD boa05
            END CASE
 
      # ON ACTION CONTROLN
      #     CALL i610_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
#           IF INFIELD(boa02) AND l_ac > 1 THEN
            IF l_ac > 1 THEN
                LET g_boa[l_ac].* = g_boa[l_ac-1].*
                NEXT FIELD boa03
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
        END INPUT
 
 
    CLOSE i610_bcl
    ##---- 20250213 add by momo (S)
    IF g_ta_boa01='Y' THEN
       SELECT 1 INTO l_cnt FROM boa_file
        WHERE boa01 = g_boa01 AND boa02=g_boa02
          AND boa07 IS NULL
       IF l_cnt = 0 THEN
          UPDATE boa_file SET ta_boa01='N' WHERE boa01=g_boa01 AND boa02=g_boa02
          DISPLAY 'N' TO ta_boa01
       END IF
    END IF
    ##---- 20250213 add by momo (E)
    COMMIT WORK
END FUNCTION
 
FUNCTION i610_boa03(p_cmd)         #元件料號, 預帶入 boa05
 
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_imaacti LIKE ima_file.imaacti,
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_n       LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
    LET g_errno = ''
    LET g_ima25 = ''
    LET g_ima63 = ''
 
    SELECT ima02,ima021,ima25,ima63,imaacti
      INTO l_ima02,l_ima021,g_ima25,g_ima63,l_imaacti FROM ima_file
     WHERE ima01 = g_boa[l_ac].boa03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = "ams-003"
                                   LET l_ima02 = ""
                                   LET l_ima021= ""
                                   LET l_imaacti = ""
         WHEN l_imaacti='N'        LET g_errno = "9028"
     #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
     #FUN-690022------mod-------
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING "-------"
    END CASE
 
    IF cl_null(g_errno) AND g_check_bma01 = 'Y' THEN
      #因上階料件存在BOM中(g_check_bma01='Y')...SO.....
      #CHECK元件料號必須為上階主件的下階料
      #SELECT UNIQUE bmb03                                  #20231006
       SELECT UNIQUE bmb10,bmb06,bmb07                      #20231006
         INTO g_ima63,g_boa[l_ac].bmb06,g_boa[l_ac].bmb07   #20231006
         FROM bmb_file
        WHERE bmb01 = g_boa01
          AND bmb03 = g_boa[l_ac].boa03
          AND bmb05 IS NULL                                 #20240911 排除失效BOM
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = "abm-015"
            OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING "-------"
       END CASE
    END IF
 
    IF p_cmd = 'a' THEN
      #順便將預設單位值丟出來
       LET g_boa[l_ac].ima02b = l_ima02
       LET g_boa[l_ac].ima021b = l_ima021
       IF g_check_bma01 = 'N' OR cl_null(g_boa[l_ac].boa05) THEN
          LET g_boa[l_ac].boa05  = g_ima63
       END IF
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_boa[l_ac].ima02b = l_ima02
       LET g_boa[l_ac].ima021b = l_ima021
    END IF
END FUNCTION
 
FUNCTION i610_boa04(p_cmd)         #作業編號
 
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ecdacti LIKE ecd_file.ecdacti
 
    LET g_errno = ""
    SELECT ecdacti INTO l_ecdacti FROM ecd_file
     WHERE ecd01 = g_boa[l_ac].boa04
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = "aec-015"
         WHEN l_ecdacti='N'        LET g_errno = "9028"
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING "-------"
    END CASE
 
END FUNCTION
 
 
FUNCTION i610_boa05(p_cmd)         #單位
 
    DEFINE p_cmd     LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
           l_gfeacti LIKE gfe_file.gfeacti,
           l_gfe01   LIKE gfe_file.gfe01,
           l_sfa13   LIKE sfa_file.sfa13,
           l_n       LIKE type_file.num5        #No.FUN-680096 SMALLINT
 
    LET g_errno = ""
    SELECT gfe01,gfeacti INTO l_gfe01,l_gfeacti FROM gfe_file
     WHERE gfe01 = g_boa[l_ac].boa05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = "mfg1326"
         WHEN l_gfeacti='N'        LET g_errno = "9028"
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING "-------"
    END CASE
 
    IF NOT cl_null(g_errno) THEN
      #單身的『單位』要檢查對庫存單位是否有建立轉換率
       CALL s_umfchk(g_boa[l_ac].boa03,g_boa[l_ac].boa05,g_ima25)
           RETURNING l_n,l_sfa13
       IF l_n = 1 THEN
          LET g_errno = 'mfg3075'
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i610_b_askkey()
 
DEFINE
    l_wc     LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(200)
 
    CONSTRUCT l_wc ON boa03,boa04,boa05,boa06,boa07
                 FROM s_boa[1].boa03,s_boa[1].boa04,
                      s_boa[1].boa05,s_boa[1].boa06,s_boa[1].boa07
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CALL i610_b_fill(l_wc)
END FUNCTION
 
FUNCTION i610_b_fill(p_wc)              #BODY FILL UP
DEFINE
   #p_wc     LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(300) #20180606 mark
    p_wc     STRING                   #20180606 modify
 
    LET g_sql =
       "SELECT boa03,b.ima02,b.ima021,",
       "       '','',",                                   #20231006
       "       boa04,boa05,boa06,boa07 ",
       "       ,ta_boadate,ta_boamodu,0 " ,               #20191007
      #"  FROM boa_file,OUTER ima_file ",                 #TQC-AB0041
       "  FROM boa_file LEFT OUTER JOIN ima_file b ",     #TQC-AB0041       
       "    ON boa_file.boa03 =b.ima01 ",          #TQC-AB0041
       "  LEFT JOIN ima_file a ON boa01=a.ima01 ",        #20230714 
       "      ,bma_file ",                                #MOD-G80103 add
       " WHERE boa01 = '",g_boa01,"' ",
       "   AND boa02 = '",g_boa02,"' ",
      #"   AND boa_file.boa03 =ima_file.ima01 ",          #TQC-AB0041 
       "   AND boa01 = bma01 AND bma06 = ' ' ",           #MOD-G80103 add
       "   AND ",p_wc CLIPPED 
 
    PREPARE i610_prepare2 FROM g_sql           #預備一下
    DECLARE boa_curs CURSOR FOR i610_prepare2
    CALL g_boa.clear()
    LET g_cnt = 1
    FOREACH boa_curs INTO g_boa[g_cnt].*       #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        ##--- 20231006 (S) 組成用量/底數
        SELECT bmb06,bmb07 INTO g_boa[g_cnt].bmb06,g_boa[g_cnt].bmb07
          FROM bmb_file
         WHERE bmb01 = g_boa01
           AND bmb03 = g_boa[g_cnt].boa03
           AND bmb05 IS NULL                  #20240911 排除失效BOM
        ##--- 20231006 (E)
        CALL cs_q102_atp_qty(g_boa[g_cnt].boa03) RETURNING g_boa[g_cnt].atp  #20230714
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_boa.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_boa TO s_boa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF NOT cl_null(g_argv1) THEN
         #    CALL cl_set_act_visible("sub_group",FALSE)  #20180323 mark
         END IF
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ##---- 20190709 資料清單
      ON ACTION page_list
         LET g_action_flag = "page_list"
         EXIT DISPLAY
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
    #@ON ACTION 替代群組
      ON ACTION sub_group
         LET g_action_choice="sub_group"
         EXIT DISPLAY

      #20200130 add
      #ON ACTION series
      #   LET g_action_choice="series"
      #   EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ##---- 20210414 add by momo (S) 
      ON ACTION carry
         LET g_action_choice="carry"
         EXIT DISPLAY

      ON ACTION qry_carry_history
         LET g_action_choice = "qry_carry_history"
         EXIT DISPLAY
      ##---- 20210414 add by momo (E) 
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033

      #M014 180130 By TSD.Andy -----(S)
      #@ 複製 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      #M014 180130 By TSD.Andy -----(E)
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION i610_v()
 
DEFINE l_msg    LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(100)
       l_bmb16  LIKE bmb_file.bmb16
 
    LET g_msg = "abmi611 '",g_boa01 CLIPPED,"' '",g_boa02 CLIPPED,"'"
    CALL cl_cmdrun(g_msg)
 
RETURN
 
    #詢問是否回寫 bmb16替代碼="5"
    SELECT bmb16 INTO l_bmb16 FROM bmb_file
     WHERE bmb01 = g_boa01
    IF SQLCA.SQLCODE THEN
        sleep 5
    END IF
    LET l_msg = "是否將",g_boa01 CLIPPED,"元件取替代特性由"
    CASE
        WHEN l_bmb16="0" LET l_msg=l_msg CLIPPED,"不可取替代"
        WHEN l_bmb16="1" LET l_msg=l_msg CLIPPED,"新料,有舊料可取代(UTE)"
        WHEN l_bmb16="2" LET l_msg=l_msg CLIPPED,"主料,有副料可替代(SUB)"
        WHEN l_bmb16="7" LET l_msg=l_msg CLIPPED,"規格替代"                     #FUN-A40058
        WHEN l_bmb16="5" RETURN
        OTHERWISE        LET l_msg=l_msg CLIPPED,"未記錄取替代特性"
    END CASE
    LET l_msg=l_msg CLIPPED,"變更為:主料,可做SET替代?"
    IF cl_prompt(0,0,l_msg) THEN
        sleep 5
    END IF
 
END FUNCTION
 
FUNCTION i610_out()
DEFINE
    l_i         LIKE type_file.num5,          #No.FUN-680096 SMALLINT
    sr          RECORD
                boa01       LIKE boa_file.boa01,
                boa02       LIKE boa_file.boa02,
                boa03       LIKE boa_file.boa03,
                boa04       LIKE boa_file.boa04,
                boa05       LIKE boa_file.boa05,
                boa06       LIKE boa_file.boa06,
                boa07       LIKE boa_file.boa07,
                boa08       LIKE boa_file.boa08,
                ima02       LIKE ima_file.ima02,
                ima021      LIKE ima_file.ima021
    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name  #No.FUN-680096 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(40)
    DEFINE l_sql     STRING                  #FUN-770052 
    DEFINE l_ima02  LIKE ima_file.ima02    #FUN-770052                                                                             
    DEFINE l_ima021 LIKE ima_file.ima021   #FUN-770052                                                                             
    IF cl_null(g_wc) THEN
        LET g_wc="     boa01='",g_boa01,"'",
                 " AND boa02= ",g_boa02
    END IF
    IF cl_null(g_boa01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('abmi610') RETURNING l_name                      #FUN-770052
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                              
     #------------------------------ CR (2) ------------------------------# 
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
 
    LET g_sql="SELECT boa01,boa02,boa03,boa04,boa05,boa06,boa07,boa08,''",
              " FROM boa_file ",              # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
 
    PREPARE i610_p1 FROM g_sql                # uUNTIME 編譯
    DECLARE i610_curo                         # CURSOR
        CURSOR FOR i610_p1
 
#   START REPORT i610_rep TO l_name           #FUN-770052
 
    FOREACH i610_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
         WHERE ima01 = sr.boa03
        IF cl_null(sr.ima02) THEN LET sr.ima02 = " " END IF
        IF cl_null(sr.ima021) THEN LET sr.ima021 = " " END IF
 ###--FUN-770052--begin--
          SELECT ima02,ima021 INTO l_ima02,l_ima021                                                                                 
            FROM ima_file                                                                                                           
#          WHERE ima01= sr.boa03   #TQC-920061
           WHERE ima01= sr.boa01   #TQC-920061
 ###--FUN-770052--end--
#       OUTPUT TO REPORT i610_rep(sr.*)       #FUN-770052
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.boa01,sr.boa02,sr.boa03,sr.boa04,sr.boa05,sr.boa06,
                   sr.boa07,sr.boa08,sr.ima02,sr.ima021,l_ima02,l_ima021                                                             
        #------------------------------ CR (3) ------------------------------#     
    END FOREACH
 
#   FINISH REPORT i610_rep                    #FUN-770052
 
    CLOSE i610_curo
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)         #FUN-770052
 
#--No.FUN-770052--str--add--#                                                                                                       
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'boa01,boa02,boa08,boa03,boa04,boa05,boa06,boa07')                                                                                                  
            RETURNING g_wc                                                                                                          
    END IF                                                                                                                          
#--No.FUN-770052--end--add--#
 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''
    LET g_str = g_wc                                                                                                                  
    CALL cl_prt_cs3('abmi610','abmi610',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
END FUNCTION
 
{REPORT i610_rep(sr)                          #FUN-770052
DEFINE
    l_ima02         LIKE ima_file.ima02,      #FUN-510033
    l_ima021        LIKE ima_file.ima021,     #FUN-510033
    l_trailer_sw    LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
    l_chr           LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
    l_tot           LIKE type_file.num20_6,   #No.FUN-680096 DECIMAL(20,6)
    l_page          LIKE type_file.num5,      #No.FUN-680096 SMALLINT
    l_dash          LIKE type_file.chr20,     #No.FUN-680096 VARCHAR(20)
    sr              RECORD
                boa01       LIKE boa_file.boa01,
                boa02       LIKE boa_file.boa02,
                boa03       LIKE boa_file.boa03,
                boa04       LIKE boa_file.boa04,
                boa05       LIKE boa_file.boa05,
                boa06       LIKE boa_file.boa06,
                boa07       LIKE boa_file.boa07,
                boa08       LIKE boa_file.boa08,
                ima02       LIKE ima_file.ima02,
                ima021      LIKE ima_file.ima021
    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.boa01,sr.boa02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT
            PRINT g_dash
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
            PRINTX name=H2 g_x[38],g_x[43],g_x[39],g_x[40]   #No.FUN-5A0061 modify
            PRINTX name=H3 g_x[41],g_x[44],g_x[42]           #No.FUN-5A0061 modify
            PRINT g_dash1
            LET l_trailer_sw = 'n'
 
        BEFORE GROUP OF sr.boa01  #料件編號
            SKIP TO TOP OF PAGE
 
        ON EVERY ROW
          SELECT ima02,ima021 INTO l_ima02,l_ima021
            FROM ima_file
           WHERE ima01= sr.boa03
          PRINTX name=D1 COLUMN g_c[31],sr.boa01,
                         COLUMN g_c[32],sr.boa02 USING "########",
                         COLUMN g_c[33],sr.boa03,
                         COLUMN g_c[34],sr.boa04,
                         COLUMN g_c[35],sr.boa05,
                         COLUMN g_c[36],sr.boa06,
                         COLUMN g_c[37],sr.boa07
          PRINTX name=D2 COLUMN g_c[38],sr.ima02,
                         COLUMN g_c[39],l_ima02,
                         COLUMN g_c[40],sr.boa08
          PRINTX name=D3 COLUMN g_c[41],sr.ima021,
                         COLUMN g_c[42],l_ima021
 
        AFTER GROUP OF sr.boa01  #料件編號
            LET l_trailer_sw = 'n'
 
        ON LAST ROW
            LET l_trailer_sw = 'y'
 
        PAGE TRAILER
            PRINT COLUMN  1,g_dash
            IF l_trailer_sw = 'y' THEN
                PRINT COLUMN  1,g_x[4] CLIPPED,
                      COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                PRINT COLUMN  1,g_x[4] CLIPPED,
                      COLUMN (g_len-9), g_x[5] CLIPPED
            END IF
END REPORT}                                                  #FUN-770052
 
#單頭
FUNCTION i610_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("boa01,boa02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i610_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("boa01,boa02",FALSE)
       END IF
   END IF
 
END FUNCTION
#單身
FUNCTION i610_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("boa03,boa05",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i610_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' THEN
           CALL cl_set_comp_entry("boa03,boa05",FALSE)
       END IF
   END IF
 
END FUNCTION
#Patch....NO.MOD-5A0095 <001> #
#M014 180130 By TSD.Andy -----(S)
#@ 複製 
FUNCTION i610_copy()
DEFINE l_newno1  LIKE boa_file.boa01,
       l_newno2  LIKE boa_file.boa02,
       l_oldno1  LIKE boa_file.boa01,
       l_oldno2  LIKE boa_file.boa02
   #M014 180327 By TSD.Tim---(S)
   DEFINE l_cnt  LIKE type_file.num5
   DEFINE l_boa03 LIKE boa_file.boa03
   #M014 180327 By TSD.Tim---(E)
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_boa01) OR cl_null(g_boa02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET g_before_input_done = FALSE  
   CALL i610_set_entry('a')         
   LET g_before_input_done = TRUE   
 
   DISPLAY ' ' TO boa01
   DISPLAY ' ' TO boa02
   DISPLAY NULL TO FORMONLY.ima02
   DISPLAY NULL TO FORMONLY.ima021
  #DISPLAY NULL TO FORMONLY.ima05    #20250212 mark
   DISPLAY NULL TO FORMONLY.ima08
   LET l_newno1 = ''
   LET l_newno2 = '' 
   LET l_oldno1 = g_boa01
   LET l_oldno2 = g_boa02

   CALL cl_set_head_visible("","YES")         
   INPUT l_newno1,l_newno2 WITHOUT DEFAULTS FROM boa01,boa02
      
      AFTER FIELD boa01                    #料件編號
         IF NOT cl_null(l_newno1) THEN
            CALL i610_boa01('a')         #20241216
            IF NOT s_chk_item_no(l_newno1,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD boa01
            END IF
            LET g_boa01_c = l_newno1 
            CALL i610_copy_chk()                   #20200131
            IF NOT cl_null(g_errno) THEN           #20210630
                CALL cl_err("ItemNo.:",g_errno,0)  #20210630
                NEXT FIELD boa01                   #20210630
            END IF                                 #20210630
            IF cl_null(g_boa01_c) THEN NEXT FIELD boa01 END IF #20200131
            CALL i610_boa01_c('a')
            IF NOT cl_null(g_errno) THEN
                CALL cl_err("ItemNo.:",g_errno,0)
                NEXT FIELD boa01
            END IF
         ELSE
            DISPLAY NULL TO FORMONLY.ima02
            DISPLAY NULL TO FORMONLY.ima021
         #  DISPLAY NULL TO FORMONLY.ima05    #20250212 mark
            DISPLAY NULL TO FORMONLY.ima08
         END IF
 
      BEFORE FIELD boa02
         LET l_newno2 = ''
         SELECT MAX(boa02) INTO l_newno2 FROM boa_file
          WHERE boa01 = l_newno1
         IF cl_null(l_newno2) THEN
             LET l_newno2 = 1
         ELSE
             LET l_newno2 = l_newno2 + 1
         END IF
         DISPLAY l_newno2 TO boa02
 
      AFTER FIELD boa02
         IF NOT cl_null(l_newno2) THEN
            LET g_errno = ''
            SELECT DISTINCT boa02 FROM boa_file
             WHERE boa01 = l_newno1 AND boa02 = l_newno2
            IF SQLCA.SQLCODE THEN
               IF SQLCA.SQLCODE != 100 THEN
                  LET g_errno = SQLCA.sqlcode USING "-------"
               END IF
            ELSE
               LET g_ss="N"                         #進入單身的 sw
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err("Serial:",g_errno,0)
               NEXT FIELD boa02
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(boa01)
               CALL q_sel_ima(FALSE, "q_ima", "", l_newno1, "", "", "", "" ,"",'' )  RETURNING l_newno1
               DISPLAY BY NAME l_newno1
               NEXT FIELD boa01
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_boa01 TO boa01
      DISPLAY g_boa02 TO boa02
      CALL i610_boa01('a')
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'

   DROP TABLE x
 
   SELECT * FROM boa_file 
    WHERE boa01 = g_boa01 
      AND boa02 = g_boa02
     INTO TEMP x        
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   LET g_ta_boa01 = 'N'                              #20250213
   UPDATE x SET boa01 = l_newno1,boa02 = l_newno2
               ,ta_boa01 = 'N'                       #20250212
               ,boa06 = g_today,ta_boadate = g_today #20210629
               ,ta_boamodu = g_user                  #20210629
    WHERE 1 = 1
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   DROP TABLE y
 
   SELECT * FROM bob_file 
    WHERE bob01 = g_boa01 
      AND bob02 = g_boa02
     INTO TEMP y        
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","bob_file","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE y SET bob01 = l_newno1,bob02 = l_newno2
               ,bob10 = g_today                         #20201201
    WHERE 1 = 1
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","y","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   INSERT INTO boa_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","boa_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK 
      LET g_success = 'N'
      RETURN
   END IF

   INSERT INTO bob_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","bob_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK 
      LET g_success = 'N' 
      RETURN
   END IF

   #M014 180327 By TSD.Tim---(S)
   LET g_sql = " SELECT DISTINCT boa03 ",
               "   FROM boa_file ",
               "  WHERE boa01 = '",l_newno1,"' ",
               "    AND boa02 =  ",l_newno2
   PREPARE i610_sel_boa03_p FROM g_sql
   DECLARE i610_sel_boa03_c CURSOR FOR i610_sel_boa03_p

   FOREACH i610_sel_boa03_c INTO l_boa03
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH i610_sel_boa03_c:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      LET l_cnt = 0
      SELECT COUNT(1)
        INTO l_cnt
        FROM boa_file
       WHERE boa01 = l_newno1
         AND boa03 = l_boa03
      IF l_cnt = 0 THEN
         ##---- 20180521 by momo 判斷是否存在取代
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM bmd_file
            WHERE bmd01=l_boa03 AND (bmd08='ALL' OR bmd08=g_boa01)
              AND bmd06 IS NULL AND bmd02='1'
           IF l_cnt > 0 THEN
              UPDATE bmb_file
                 SET bmb16='1'
               WHERE bmb01 = l_newno1
                 AND bmb03 = l_boa03
           ELSE
             #判斷是否存在替代
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM bmd_file
              WHERE bmd01=l_boa03 AND (bmd08='ALL' OR bmd08=g_boa01)
                AND bmd06 IS NULL AND bmd02='2'
             IF l_cnt > 0 THEN
                UPDATE bmb_file
                   SET bmb16='2'
                 WHERE bmb01 = l_newno1
                   AND bmb03 = l_boa03
             ELSE
               UPDATE bmb_file
                  SET bmb16 = '0'
                WHERE bmb01 = l_newno1
                  AND bmb03 = l_boa03
             END IF
           END IF
      ELSE
         UPDATE bmb_file
            SET bmb16 = '5'
          WHERE bmb01 = l_newno1
            AND bmb03 = l_boa03
      END IF
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","bmb_file","",l_boa03,SQLCA.sqlcode,"","",0)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
   #M014 180327 By TSD.Tim---(E)

   IF g_success = 'N' THEN
     ROLLBACK WORK
     RETURN
   ELSE
     COMMIT WORK
   END IF
 
   LET g_boa01 = l_newno1
   LET g_boa02 = l_newno2

   LET g_wc = ' 1=1' #M014 180207 By TSD.Tim
   CALL i610_u()
   CALL i610_b()
 
END FUNCTION

FUNCTION  i610_boa01_c(p_cmd)
 
DEFINE
    p_cmd           LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
    l_desc          LIKE fan_file.fan02,      #No.FUN-680096 VARCHAR(4) 
    l_cnt           LIKE type_file.num5,      #No.FUN-680096 SMALLINT
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
  # l_ima05         LIKE ima_file.ima05,      #20250212 mark
    l_ima08         LIKE ima_file.ima08,
    l_imaacti       LIKE ima_file.imaacti,
    l_boa02         LIKE boa_file.boa02
 
    LET g_errno = ""
 
    #SELECT ima02,ima021,ima05,ima08,imaacti                           #20250212 mark
    #  INTO l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti FROM ima_file   #20250212 mark
    SELECT ima02,ima021,ima08,imaacti                                  #20250212 modify
      INTO l_ima02,l_ima021,l_ima08,l_imaacti FROM ima_file            #20250212 modfiy
     WHERE ima01=g_boa01_c
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
                                  #LET l_ima05 = NULL                  #20250212 mark
                                   LET l_ima08 = NULL
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N'        LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
 
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) THEN
       #CHECK此上階料號是否存在BOM單頭中
       # YES :單身所輸入的料件皆須存在此料件之BOM明細中(bmb_file)
       # NO  :單身所輸入的料件不須存在此料件之BOM明細中(bmb_file)
        SELECT COUNT(*) INTO l_cnt FROM bma_file
         WHERE bma01 = g_boa01_c
        IF l_cnt > 0 THEN
           LET g_check_bma01 = 'Y'
        ELSE
           LET g_check_bma01 = 'N'
        END IF
    END IF
 
    IF p_cmd='d' OR cl_null(g_errno) THEN
        DISPLAY l_ima02 TO FORMONLY.ima02
        DISPLAY l_ima021 TO FORMONLY.ima021
       #DISPLAY l_ima05 TO FORMONLY.ima05     #20250212 mark
        DISPLAY l_ima08 TO FORMONLY.ima08
    END IF

END FUNCTION
#M014 180130 By TSD.Andy -----(E)

##---- 20190709 資料清單 (S)
FUNCTION i610_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_boa_1 TO s_boa_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF NOT cl_null(g_argv1) THEN
         END IF
 
     BEFORE ROW
        LET l_ac1 = ARR_CURR()
        CALL cl_show_fld_cont()                  

      ON ACTION main
         LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i610_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         EXIT DISPLAY
 
   
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

 
      ON ACTION first
         CALL i610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
 
      ON ACTION ACCEPT
         LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         CALL i610_fetch('/')
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL ui.interface.refresh()
         EXIT DISPLAY 
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i610_list_fill()
DEFINE l_cnt          LIKE type_file.num10
DEFINE l_boa01        LIKE boa_file.boa01
DEFINE l_boa02        LIKE boa_file.boa02
DEFINE l_boa08        LIKE boa_file.boa08
DEFINE l_ta_boa01     LIKE boa_file.ta_boa01 #20250212

   CALL g_boa_1.clear()
   LET l_cnt = 1

   FOREACH i610_b_curs INTO l_boa01,l_boa02,l_boa08,l_ta_boa01  #20250212
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      SELECT boa01,ima02,ima021,ima08,boa02,boa08,ta_boa01      #20250212
        INTO g_boa_1[l_cnt].*
        FROM boa_file LEFT JOIN ima_file ON boa01 = ima01
       WHERE boa01 = l_boa01
         AND boa02 = l_boa02
       LET l_cnt = l_cnt + 1
       IF l_cnt > g_max_rec THEN
       IF g_action_choice ="query"  THEN
            CALL cl_err( '', 9035, 0 )
          END IF
          EXIT FOREACH
       END IF
    END FOREACH
    OPEN i610_b_curs                     
    LET g_rec_b1 = l_cnt - 1
    DISPLAY g_rec_b1 TO FORMONLY.cnt  
    DISPLAY ARRAY g_boa_1 TO s_boa_1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
END FUNCTION

 
##---- 20190709 資料清單 (E)

##----- 20210630 add by momo (S) cooi103 檢核更新
##----- 20200131 add by momo (S) 複製時系列別檢核
FUNCTION i610_copy_chk()
 DEFINE l_cnt       LIKE type_file.num5
 DEFINE l_tc_aad03  LIKE tc_aad_file.tc_aad03 
 DEFINE l_boa03     LIKE boa_file.boa03

 LET g_sql = "SELECT DISTINCT boa03 FROM boa_file ",
             " WHERE boa01 = '",g_boa01,"' ",
             "   AND boa02 = '",g_boa02,"' "
 PREPARE i610_sel_boa03_chk FROM g_sql
 DECLARE i610_sel_boa03_c2 CURSOR FOR i610_sel_boa03_chk

 FOREACH i610_sel_boa03_c2 INTO l_boa03
    CALL cl_chktcaad(l_boa03,g_boa01_c) RETURNING g_errno
    IF NOT cl_null(g_errno) THEN
       CALL cl_err('',g_errno,1)
       EXIT FOREACH
    END IF
 END FOREACH

 #LET l_cnt = 0

 #判斷是否符合可用系列別
 #SELECT COUNT(*) INTO l_cnt
 # FROM tc_aad_file
 #WHERE tc_aad01 = g_boa01
 #  AND tc_aad02 = g_boa02
 #  AND tc_aad04 = 'Y'
 #  AND NOT EXISTS (SELECT * FROM ima_file 
 #               WHERE ima09 = tc_aad03 AND ima01 = g_boa01_c )
 #IF l_cnt > 0 THEN
 #   CALL cl_err(l_tc_aad03,'cbm-008',1)
 #   LET g_boa01_c = ''
 #END IF

 #抓取不可用系列別
 #IF l_cnt = 0 THEN
 #   SELECT tc_aad03 INTO l_tc_aad03
 #     FROM tc_aad_file
 #    WHERE tc_aad01 = g_boa01
 #      AND tc_aad02 = g_boa02
 #      AND tc_aad04 = 'N'
 #      AND EXISTS (SELECT * FROM ima_file 
 #                   WHERE ima09 = tc_aad03 AND ima01 = g_boa01_c )
 #   IF NOT cl_null(l_tc_aad03) THEN
 #      CALL cl_err(l_tc_aad03,'cbm-008',1)
 #      LET g_boa01_c = ''
 #   END IF
 #END IF
END FUNCTION

##----- 20200131 add by momo (E) 複製時系列別檢核

##--- 20210414 add by momo (S) 資料拋轉  
FUNCTION i610_carry()
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
   DEFINE l_sql     LIKE type_file.chr1000

   IF cl_null(g_boa01) THEN   #No.FUN-830090
      CALL cl_err('',-400,0)
      RETURN
   END IF
 #input data center
   LET g_gev04 = NULL
   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 FROM gev_file
    WHERE gev01 = '2' AND gev02 = g_plant
      AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',1)
      RETURN
   END IF
   IF cl_null(g_gev04) THEN RETURN END IF 
  
   #開窗選擇拋轉的db清單
   CALL s_dc_sel_db(g_gev04,'2')
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF

   CALL g_boax.clear()
   LET l_j = 1
   FOR l_i = 1 TO g_boa.getLength()
       LET g_boax[l_j].sel = 'Y'
       LET g_boax[l_j].boa01 = g_boa01
       LET g_boax[l_j].boa02 = g_boa02
       LET g_boax[l_j].boa03 = g_boa[l_i].boa03
       LET g_boax[l_j].boa04 = g_boa[l_i].boa04
       LET g_boax[l_j].boa05 = g_boa[l_i].boa05
       LET l_j = l_j +1
   END FOR

   IF cl_null(g_wc2) THEN LET g_wc2 = ' 1=1' END IF

   CALL s_showmsg_init()
   CALL s_abmi610_carry_boa(g_boax,g_azp,g_gev04,g_wc2) 
   CALL s_showmsg()

END FUNCTION

