vf# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cbmi610.4gl
# Descriptions...: 上階主件對元件群組維護作業
# Date & Author..: 2020/12/01 momo
# Modify.........: 
# Modify.........: No:2103316054 20210416 By momo 增加「資料拋轉」、「資料拋轉歷史」
# Modify.........: NO:2106026315 20210630 By momo 增加 cooi103 檢核
# Modify.........: No:2205278169 20220527 By momo abm-017 卡控調整
# Modify.........: No:2205308180 20220530 By momo 當取替代資料失效時，更新BOM取替代特性
# Modify.........: No:23060010   20230606 By momo abm-017 卡控調整 
# Modify.........: No:23070027   20230718 By momo 增加QBE與atp_qty顯示
# Modify.........: No:23100001   20231012 By momo 增加bmb06、bmb07 欄位顯示
# Modify.........: No:24090011   20240910 By momo 增加批次失效ACTION
# Modify.........: No:25020030   20250224 By momo 增加顯示ta_boa01標準否欄位，無有效資料時自動失效標準否欄位

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../tiptop/sub/4gl/s_data_center.global"
 
DEFINE                                     #模組變數(Module Variables)
    g_cnt2,g_cnt3   LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    g_argv1         LIKE boa_file.boa01,   #上階主件 (假單頭)
    g_argv2         LIKE boa_file.boa02,   #元件群組
    g_boa01         LIKE boa_file.boa01,   #類別代號 (假單頭)
    g_boa02         LIKE boa_file.boa02,   #元件群組
    g_boa08         LIKE boa_file.boa08,   #說明
    g_ima02         LIKE ima_file.ima02,   #品名規格
    g_ima021        LIKE ima_file.ima021,  #品名規格
    g_ima05         LIKE ima_file.ima05,   #目前使用版本
    g_ima08         LIKE ima_file.ima08,   #來源碼
    g_ima25         LIKE ima_file.ima25,
    g_ima63         LIKE ima_file.ima63,
    g_boa          DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
                boa01       LIKE boa_file.boa01,
                ima02       LIKE ima_file.ima02,
                ima021      LIKE ima_file.ima021,
                ima08       LIKE ima_file.ima08,
                boa02       LIKE boa_file.boa02,
                ta_boa01    LIKE boa_file.ta_boa01,   #20250224
                boa03       LIKE boa_file.boa03,
                ima02b      LIKE ima_file.ima02,
                ima021b     LIKE ima_file.ima021,
                bmb06       LIKE bmb_file.bmb06,      #20231012
                bmb07       LIKE bmb_file.bmb07,      #20231012
                boa04       LIKE boa_file.boa04,
                boa05       LIKE boa_file.boa05,
                boa06       LIKE boa_file.boa06,
                boa07       LIKE boa_file.boa07,
                ta_boadate  LIKE boa_file.ta_boadate, 
                ta_boamodu  LIKE boa_file.ta_boamodu,
                note        LIKE boa_file.boa08
  END RECORD,
    g_bob          DYNAMIC ARRAY OF RECORD
                bob02       LIKE bob_file.bob02,
                bob03       LIKE bob_file.bob03,
                bob07       LIKE bob_file.bob07,
                bob04       LIKE bob_file.bob04,
                bob05       LIKE bob_file.bob05,
                bob06       LIKE bob_file.bob06,
                bob08       LIKE bob_file.bob08,
                bob09       LIKE bob_file.bob09,
                bob10       LIKE bob_file.bob10,
                bob11       LIKE bob_file.bob11,
                bob14       LIKE bob_file.bob14,
                tyatp       LIKE type_file.num15_3,  #20230718
                ksatp       LIKE type_file.num15_3   #20230718
   END RECORD,
    g_boa_t        RECORD                  #變數舊值
                boa01       LIKE boa_file.boa01,
                ima02       LIKE ima_file.ima02,
                ima021      LIKE ima_file.ima021,
                ima08       LIKE ima_file.ima08,
                boa02       LIKE boa_file.boa02,
                ta_boa01    LIKE boa_file.ta_boa01,   #20250224
                boa03       LIKE boa_file.boa03,
                ima02b      LIKE ima_file.ima02,
                ima021b     LIKE ima_file.ima021,
                bmb06       LIKE bmb_file.bmb06,     #20231012
                bmb07       LIKE bmb_file.bmb07,     #20231012
                boa04       LIKE boa_file.boa04,
                boa05       LIKE boa_file.boa05,
                boa06       LIKE boa_file.boa06,
                boa07       LIKE boa_file.boa07,
                ta_boadate  LIKE boa_file.ta_boadate, 
                ta_boamodu  LIKE boa_file.ta_boamodu,  
                note        LIKE boa_file.boa08
   END RECORD,
    ga_color DYNAMIC ARRAY OF RECORD
                           boa01  STRING,
                           ima02  STRING,
                           ima021 STRING,
                           ima08  STRING,
                           boa02  STRING,
                           ta_boa01 STRING,
                           boa03  STRING,    
                           ima02b STRING,
                           ima021b STRING,
                           bmb06   STRING,
                           bmb07   STRING,
                           boa04   STRING,
                           boa05   STRING,
                           boa06   STRING,
                           boa07   STRING,
                           ta_boadate STRING,
                           ta_boamodu STRING,
                           note       STRING
                           END RECORD,
    g_wc,g_wc2             string,                 #No.FUN-580092 HCN
    g_sql                  string,                 #No.FUN-580092 HCN
    g_sql1                 string,                 #No.FUN-580092 HCN
    g_ss                   LIKE type_file.chr1,    #決定後續步驟 #No.FUN-680096 VARCHAR(1)
    g_check_bma01          LIKE type_file.chr1,    #決定後續步驟 #No.FUN-680096 VARCHAR(1)
    g_rec_b                LIKE type_file.num5,    #單身筆數        #No.FUN-680096 SMALLINT
    g_rec_b2               LIKE type_file.num5,    #單身筆數        #No.FUN-680096 SMALLINT
    l_ac                   LIKE type_file.num5     #目前處理的ARRAY CNT   #No.FUN-680096 SMALLINT
 
DEFINE g_forupd_sql      STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_cnt1          LIKE type_file.num10    #No.FUN-680096 INTEGER
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
                           boa08_1     LIKE boa_file.boa08
                                       END RECORD
##---- 20190709 資料清單 (E)

##---- 20210416 add by momo (S) 資料拋轉
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
##---- 20210416 add by momo (E)
 
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
 
    OPEN WINDOW i610_w WITH FORM "cbm/42f/cbmi610"
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
       CALL g_bob.clear()
       IF cl_null(ARG_VAL(1)) AND cl_null(ARG_VAL(2)) THEN
           CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_boa01 TO NULL    #No.FUN-750051
   INITIALIZE g_boa02 TO NULL    #No.FUN-750051
   INITIALIZE g_boa08 TO NULL    #No.FUN-750051
           CONSTRUCT g_wc ON boa08,boa01,
                             a.ima02,a.ima021,                    #20230718
                             boa02,
                             ta_boa01,                            #20250224
                             boa03,
                             b.ima02,b.ima021,                    #20230718
                             boa04,boa05,boa06,boa07,
                             ta_boadate,ta_boamodu                #20230718
                        FROM boa08,
                             s_boa[1].boa01,
                             s_boa[1].ima02,s_boa[1].ima021,      #20230718
                             s_boa[1].boa02,
                             s_boa[1].ta_boa01,                   #20250224
                             s_boa[1].boa03,
                             s_boa[1].ima02b,s_boa[1].ima021b,    #20230718
                             s_boa[1].boa04,s_boa[1].boa05,
                             s_boa[1].boa06,s_boa[1].boa07,
                             s_boa[1].ta_boadate,s_boa[1].ta_boamodu #20230718
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(boa01)

                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret

                     DISPLAY g_qryparam.multiret TO boa01
                     NEXT FIELD boa01
                 WHEN INFIELD(boa03)     #元件料號
                    IF g_check_bma01 = 'Y' THEN

                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_bmb302"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO boa03
                    ELSE

                       CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret  

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
 
    #LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')         
    IF g_wc= ' 1=1      ' THEN LET g_wc = '1=2' END IF
 
    LET g_sql= "SELECT UNIQUE NVL(boa08,'N') FROM boa_file",
               "  LEFT JOIN ima_file a ON boa01 = a.ima01 ",    #20230718 add 
               "  LEFT JOIN ima_file b ON boa03 = b.ima01 ",    #20230718 add
               " WHERE ", g_wc CLIPPED,
               " GROUP BY boa08"
 
    PREPARE i610_prepare FROM g_sql          #預備一下
    DECLARE i610_b_curs                      #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i610_prepare
 
  
    LET g_sql = "SELECT UNIQUE NVL(boa08,'N') FROM boa_file ",        
                "  LEFT JOIN ima_file a ON boa01 = a.ima01 ",    #20230718 add 
                "  LEFT JOIN ima_file b ON boa03 = b.ima01 ",    #20230718 add
                " WHERE  ",g_wc CLIPPED,
                " GROUP BY boa08 "
 
    PREPARE i610_precount FROM g_sql
    DECLARE i610_count CURSOR FOR i610_precount
 
END FUNCTION
 
 
FUNCTION i610_menu()                         #中文的MENU
   DEFINE   l_cmd  LIKE type_file.chr50      #No.FUN-680096 VARCHAR(50)
   DEFINE   l_flag LIKE type_file.chr1       #20240910

   WHILE TRUE
   
      #CALL i610_bp("G")
      CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "main")
            CALL i610_bp("G")
           
      END CASE

      ##---- 20190709 資料清單 (E)
      CASE g_action_choice
 
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
               CALL i610_b_fill(g_wc)
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
       #  WHEN "sub_group"
       #     IF cl_chk_act_auth() AND NOT cl_null(g_boa01) THEN
       #        CALL i610_v()
       #     END IF
         #----20200130 add
       #  WHEN "series"
       #     IF cl_chk_act_auth() AND NOT cl_null(g_boa01) THEN
       #       LET g_msg = "cooi103 '",g_boa01 CLIPPED,"' '",g_boa02 CLIPPED,"'"
       #        CALL cl_cmdrun(g_msg)
       #     END IF
         #----20200130 add
       #   WHEN "related_document"                  #MOD-470051
       #     IF cl_chk_act_auth() THEN
       #        IF g_boa01 IS NOT NULL THEN
       #           LET g_doc.column1 = "boa01"
       #           LET g_doc.value1  = g_boa01
       #           LET g_doc.column2 = "boa02"
       #           LET g_doc.value2  = g_boa02
       #           LET g_doc.column3 = "boa08"
       #           LET g_doc.value3  = g_boa08
       #           CALL cl_doc()
       #        END IF
       #     END IF

         ##---- 20210416 add by momo (S)
         WHEN "carry"            #資料拋轉
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL i610_carry()
            END IF

         WHEN "qry_carry_history" #拋轉資料查詢
            IF cl_chk_act_auth() THEN
               LET g_cmd='aooq604 "',g_plant,'" "2" "',g_prog,'" "',g_boa01,'"'
               CALL cl_cmdrun(g_cmd)
            END IF
         ##---- 20210416 add by momo (E)

         ##---- 20240910 add by momo (S)
         WHEN "allinvalid" #整批無效
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               IF cl_sure(21,21) THEN
                  CALL cl_wait()
                  LET g_success = 'Y'
                  CALL i610_allinvalid()
                  IF g_success = 'Y' THEN
                     CALL cl_end2(1) RETURNING l_flag        #批次作业正确结束
                  ELSE
                     CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
                  END IF
             END IF 
            END IF
         ##---- 20240910 add by momo (E)

         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              
              LET w = ui.Window.getCurrent()
              LET f = w.getForm()
              CASE 
                 WHEN (g_action_flag IS NULL) OR (g_action_flag = 'main')
                     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_boa),'','')
               
                 END CASE
                 LET g_action_choice = NULL
              
            END IF
         OTHERWISE EXIT CASE
        
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i610_a()                            #Add  輸入
 
    MESSAGE ""
 
    CLEAR FORM
    CALL g_boa.clear()
    CALL g_bob.clear()
   #LET g_wc = NULL #MOD-D60215 mark
    INITIALIZE g_boa01 LIKE boa_file.boa01   #預設值及將數值類變數清成零
    INITIALIZE g_boa02 LIKE boa_file.boa02
    INITIALIZE g_boa08 LIKE boa_file.boa08
 
    CALL cl_opmsg('a')
 
    WHILE TRUE
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
            CALL i610_bp2('')
        END IF
 
        CALL i610_b()                        #輸入單身
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i610_u()
 
DEFINE l_boa01_t     LIKE boa_file.boa01,
       l_boa02_t     LIKE boa_file.boa02,
       l_boa08_t     LIKE boa_file.boa08
 
    IF s_shut(0) THEN RETURN END IF
    IF g_boa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    CALL i610_show()
    WHILE TRUE
        LET l_boa01_t = g_boa01 LET l_boa02_t = g_boa02
        LET l_boa08_t = g_boa08
        CALL i610_i("u")                      #欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_boa01 = l_boa01_t
           LET g_boa02 = l_boa02_t
           LET g_boa08 = l_boa08_t
           CALL i610_show()
           CALL cl_err('','9001',0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
 
        IF g_boa01 != l_boa01_t OR g_boa02 != l_boa02_t
        OR ( g_boa08 != l_boa08_t OR
           ( NOT cl_null(g_boa08) AND cl_null(l_boa08_t))) THEN
            IF g_chkey = "Y" THEN
                UPDATE boa_file
                   SET boa01=g_boa01,
                       boa02=g_boa02,
                       boa08=g_boa08
                 WHERE boa01=l_boa01_t AND boa02=l_boa02_t
            ELSE
                UPDATE boa_file SET boa08 = g_boa08
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
    INPUT g_boa01,g_boa02,g_boa08 WITHOUT DEFAULTS
        FROM boa01,boa02,boa08
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i610_set_entry(p_cmd)
            CALL i610_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        #BEFORE FIELD boa01
        #    IF p_cmd="u" AND g_chkey="N" THEN NEXT FIELD boa08 END IF
 
        #AFTER FIELD boa01                    #料件編號
        #    IF NOT cl_null(g_boa01) THEN
               #FUN-AA0059 -----------------------add start----------------------------
        #        IF NOT s_chk_item_no(g_boa01,'') THEN
        #           CALL cl_err('',g_errno,1)
        #           NEXT FIELD boa01
        #        END IF 
               #FUN-AA0059 ----------------------add end------------------------------ 
        #        CALL i610_boa01(p_cmd)
        #        IF NOT cl_null(g_errno) THEN
        #            CALL cl_err("ItemNo.:",g_errno,0)
        #            NEXT FIELD boa01
        #        END IF
        #    END IF
 
        #BEFORE FIELD boa02
        #    SELECT MAX(boa02) INTO g_boa02 FROM boa_file
        #     WHERE boa01 = g_boa01
        #    IF cl_null(g_boa02) THEN
        #        LET g_boa02 = 1
        #    ELSE
        #        LET g_boa02 = g_boa02 + 1
        #    END IF
        #    DISPLAY g_boa02 TO boa02
 
        #AFTER FIELD boa02
        #    IF NOT cl_null(g_boa02) THEN
        #        CALL i610_boa02(p_cmd)
        #        IF NOT cl_null(g_errno) THEN
        #            CALL cl_err("Serial:",g_errno,0)
        #            NEXT FIELD boa02
        #        END IF
        #    END IF
 
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
    l_ima05         LIKE ima_file.ima05,
    l_ima08         LIKE ima_file.ima08,
    l_imaacti       LIKE ima_file.imaacti,
    l_boa02         LIKE boa_file.boa02
 
    LET g_errno = ""
 
    SELECT ima02,ima021,ima05,ima08,imaacti
      INTO l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti FROM ima_file
     WHERE ima01=g_boa01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
                                   LET l_ima05 = NULL
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
        DISPLAY l_ima05 TO FORMONLY.ima05
        DISPLAY l_ima08 TO FORMONLY.ima08
    END IF
 
END FUNCTION
 
FUNCTION  i610_boa02(p_cmd)
 
DEFINE
    p_cmd    LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
    LET g_errno = " "
 
    SELECT DISTINCT boa02 FROM boa_file
     WHERE boa01 = g_boa01 AND boa02 = g_boa02
       AND boa06 < g_boa_t.boa06  #20210224 生效日有小於的要卡關
    IF SQLCA.SQLCODE != 100 THEN
        #   LET g_errno = SQLCA.sqlcode USING "-------"
        LET g_errno = 'cbm-014'
    END IF
    #IF SQLCA.SQLCODE THEN
    #    IF SQLCA.SQLCODE != 100 THEN
    #        LET g_errno = SQLCA.sqlcode USING "-------"
    #    END IF
    #ELSE
    #    LET g_ss="N"                         #進入單身的 sw
    #END IF
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
    LET l_ac = 1
END FUNCTION
 
FUNCTION i610_fetch(p_flag)                  #處理資料的讀取
 
DEFINE
    p_flag     LIKE type_file.chr1       #處理方式    #No.FUN-680096 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i610_b_curs INTO g_boa08
        WHEN 'P' FETCH PREVIOUS i610_b_curs INTO g_boa08
        WHEN 'F' FETCH FIRST    i610_b_curs INTO g_boa08
        WHEN 'L' FETCH LAST     i610_b_curs INTO g_boa08
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
            FETCH ABSOLUTE g_jump i610_b_curs INTO g_boa08
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

    DISPLAY g_boa01, g_boa02, g_boa08        #假單頭
         TO boa01, boa02, boa08
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
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT boa01,'','','',boa02,ta_boa01,boa03,'','',",            #20250224
       "       0,0,",                                                  #20240408
       "       boa04,boa05,boa06,boa07,ta_boadate,ta_boamodu,boa08 ", 
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
         #   CALL i610_set_entry_b(p_cmd)
         #   CALL i610_set_no_entry_b(p_cmd)
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
 
                OPEN i610_bcl USING g_boa_t.boa01,g_boa_t.boa02,g_boa_t.boa03,g_boa_t.boa04,g_boa_t.boa05
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
                    IF SQLCA.sqlcode THEN
                        LET g_boa[l_ac].ima02b=" "
                        LET g_boa[l_ac].ima021b=" "
                    END IF
                    SELECT ima02,ima021,ima08 
                      INTO g_boa[l_ac].ima02,g_boa[l_ac].ima021,g_boa[l_ac].ima08 FROM ima_file
                     WHERE ima01 = g_boa[l_ac].boa01
                    IF SQLCA.sqlcode THEN
                        LET g_boa[l_ac].ima02=" "
                        LET g_boa[l_ac].ima021=" "
                        LET g_boa[l_ac].ima08=" "
                    END IF
                    ##----- 20231012 add (S)
                    SELECT bmb06,bmb07 INTO g_boa[l_ac].bmb06,g_boa[l_ac].bmb07
                      FROM bmb_file
                     WHERE bmb01 = g_boa01
                       AND bmb03 = g_boa[l_ac].boa03
                    ##----- 20231012 add (E)
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
                 VALUES (g_boa[l_ac].boa01,g_boa[l_ac].boa02,g_boa[l_ac].boa03,g_boa[l_ac].boa04,
                         g_boa[l_ac].boa05,g_boa[l_ac].boa06,g_boa[l_ac].boa07,
                         g_boa[l_ac].note,
                         g_today,g_user)  
            IF SQLCA.sqlcode THEN
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
            UPDATE bmb_file SET bmb16='5' WHERE bmb01=g_boa[l_ac].boa01 AND bmb03=g_boa[l_ac].boa03
            #CHI-D10033---end
        BEFORE INSERT
            ##---- 20230713 多營運中心資料使用檢核(S)
            IF NOT s_dc_ud_flag('2',g_plant,g_plant,'a') THEN
               CALL cl_err(g_plant,'aoo-078',1)
               RETURN
            END IF
            ##---- 20230713 多營運中心資料使用檢核(E)
            #CKP
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_boa[l_ac].* TO NULL       #900423
            LET g_boa_t.* = g_boa[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD boa01

        BEFORE FIELD boa01
            IF NOT cl_null(g_boa[l_ac].boa01) THEN
               LET g_boa01 = g_boa[l_ac].boa01
               LET g_boa02 = g_boa[l_ac].boa02
            END IF

        AFTER FIELD boa01
            IF cl_null(g_boa[l_ac].boa01) THEN
            ELSE
                LET g_boa01 = g_boa[l_ac].boa01
                IF NOT s_chk_item_no(g_boa[l_ac].boa01,'') THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD boa01
                END IF
                CALL i610_boa01(p_cmd)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err("ItemNo.:",g_errno,0)
                    NEXT FIELD boa01
                END IF
            END IF

        AFTER FIELD boa02
            IF cl_null(g_boa[l_ac].boa02) THEN
               NEXT FIELD boa02
            ELSE
               LET g_boa02 = g_boa[l_ac].boa02
              #CALL i610_boa02(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err("Serial:",g_errno,0)
                  NEXT FIELD boa02
               END IF
            END IF
 
        AFTER FIELD boa03
            IF NOT cl_null(g_boa[l_ac].boa03) THEN

              ##----- 20210630 add by momo (S) cooi103 檢核
              CALL cl_chktcaad(g_boa[l_ac].boa03,g_boa[l_ac].boa01) RETURNING g_errno
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
                    # AND boa02 = g_boa02             #20230606 mark
                      AND boa02 = g_boa[l_ac].boa02   #20230606 modify
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
                     #AND boa02 != g_boa02           #20230606 mark
                      AND boa02 = g_boa[l_ac].boa02  #20230606 modify
                      AND boa03 = g_boa[l_ac].boa03
                      AND boa04 = g_boa[l_ac].boa04
                      AND boa05 = g_boa[l_ac].boa05
                      AND boa07 IS NULL            #20220527
                   IF l_cnt > 0 THEN
                      CALL cl_err(g_boa[l_ac].boa03,'abm-017',1)  #20210709 modify
                      #NEXT FIELD boa05                           #20210709 mark
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
               LET g_boa_t.boa06 = g_boa[l_ac].boa06 #20210224
               CALL i610_boa02(p_cmd)  #20210224   
               IF NOT cl_null(g_errno) THEN          #20210709
                  CALL cl_err("Serial:",g_errno,1)   #20210709
                  NEXT FIELD boa02                   #20210706
               END IF                                #20210709
    
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
                WHERE boa01 = g_boa_t.boa01 AND boa02 = g_boa_t.boa02
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
                WHERE bmd01=g_boa_t.boa03 AND (bmd08='ALL' OR bmd08=g_boa_t.boa01)
                  AND bmd06 IS NULL AND bmd02='1'
               IF l_cnt > 0 THEN
                  UPDATE bmb_file
                     SET bmb16='1'
                   WHERE bmb01 = g_boa_t.boa01
                     AND bmb03 = g_boa_t.boa03
               ELSE
               #判斷是否存在替代
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM bmd_file
                WHERE bmd01=g_boa_t.boa03 AND (bmd08='ALL' OR bmd08=g_boa_t.boa01)
                  AND bmd06 IS NULL AND bmd02='2'
               IF l_cnt > 0 THEN
                  UPDATE bmb_file
                     SET bmb16='2'
                   WHERE bmb01 = g_boa_t.boa01
                     AND bmb03 = g_boa_t.boa03
               ELSE
                 LET l_cnt = 0
                 SELECT COUNT(*)
                   INTO l_cnt
                   FROM boa_file
                  WHERE boa01 = g_boa_t.boa01
                    AND boa03 = g_boa_t.boa03
                 IF l_cnt = 0 THEN
                    UPDATE bmb_file 
                       SET bmb16='0'
                     WHERE bmb01 = g_boa_t.boa01
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
                      boa08=g_boa[l_ac].note,
                      ta_boadate = g_today,  
                      ta_boamodu = g_user    
                WHERE boa01=g_boa_t.boa01
                  AND boa02=g_boa_t.boa02
                  AND boa03=g_boa_t.boa03
                  AND boa04=g_boa_t.boa04
                  AND boa05=g_boa_t.boa05
                IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
 #                   CALL cl_err(g_boa[l_ac].boa03,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("upd","boa_file",g_boa01,g_boa02,SQLCA.sqlcode,"","",1) #TQC-660046
                    LET g_boa[l_ac].* = g_boa_t.*
                    ROLLBACK WORK
                ELSE
                    {
                    ##---20180817 by momo 修正失效時未更新BOM資料 (S)
                    IF NOT cl_null(g_boa[l_ac].boa07) THEN
                       LET l_cnt = 0
                       SELECT COUNT(*) INTO l_cnt FROM bmd_file
                        WHERE bmd01 = g_boa_t.boa03 AND (bmd08='ALL' OR bmd08=g_boa01)
                          AND bmd06 IS NULL AND bmd02='1'
                       IF l_cnt > 0 THEN
                          UPDATE bmb_file
                             SET bmb16='1'
                           WHERE bmb01 = g_boa_t.boa01
                            AND bmb03 = g_boa_t.boa03 
                       ELSE
                          UPDATE bmb_file
                             SET bmb16='0'
                           WHERE bmb01 = g_boa_t.boa01
                            AND bmb03 = g_boa_t.boa03
                       END IF
                    END IF
                    ##---20180817 by momo 修正失效時未更新BOM資料 (E)

                    #CHI-D10033---begin
                    #IF g_boa[l_ac].boa03 <> g_boa_t.boa03 THEN                    
                       LET l_cnt = 0
                       SELECT COUNT(*)
                         INTO l_cnt
                         FROM boa_file
                        WHERE boa01 = g_boa_t.boa01
                          AND boa03 = g_boa_t.boa03
                       IF l_cnt = 0 THEN
                          UPDATE bmb_file 
                             SET bmb16='0'
                           WHERE bmb01 = g_boa_t.boa01
                            AND bmb03 = g_boa_t.boa03
                          IF SQLCA.sqlcode THEN
                             CALL cl_err3("upd","bmb_file","",g_boa_t.boa03,SQLCA.sqlcode,"","",0)
                          END IF 
                       END IF  
                       UPDATE bmb_file 
                          SET bmb16='5'
                        WHERE bmb01 = g_boa[l_ac].boa01
                         AND bmb03 = g_boa[l_ac].boa03
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd","bmb_file","",g_boa[l_ac].boa03,SQLCA.sqlcode,"","",0)
                       END IF
                    #END IF 
                    #CHI-D10033---end
                    }
                     ##---- 20250224 無有效資料時，取消標準否 (S)
                     IF g_boa[l_ac].ta_boa01 = 'Y' THEN
                        UPDATE boa_file SET ta_boa01='N',ta_boadate=g_today,ta_boamodu=g_user
                         WHERE boa01=g_boa_t.boa01 AND boa02=g_boa_t.boa02
                           AND NOT EXISTS (SELECT 1 FROM boa_file b
                                            WHERE b.boa01=g_boa_t.boa01 AND b.boa02=g_boa_t.boa02 AND boa07 is null)

                     END IF
                    ##---- 20250224 無有效資料時，取消標準否 (E)
                    COMMIT WORK
                    CALL cs_updbmb16(g_boa_t.boa01,g_boa_t.boa03,'S')   #20220530 更新BOM取替代狀態 
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

                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmb302"
                     LET g_qryparam.default1 = g_boa01
                     LET g_qryparam.default2 = g_boa[l_ac].boa03
                     LET g_qryparam.default3 = g_boa[l_ac].boa04
                     LET g_qryparam.arg1     = g_boa01
                     CALL cl_create_qry() RETURNING g_msg, g_boa[l_ac].boa03,g_boa[l_ac].boa04
                      DISPLAY BY NAME g_boa[l_ac].boa03           #No.MOD-490371
                      DISPLAY BY NAME g_boa[l_ac].boa04           #No.MOD-490371
                     SELECT bmb10 INTO l_bmb10 FROM bmb_file
                      WHERE bmb01 = g_boa01
                     DISPLAY l_bmb10 TO boa05
                  ELSE

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
      #SELECT UNIQUE bmb03 FROM bmb_file     #20231012 mark     應抓取BOM單位
       SELECT UNIQUE bmb10                   #20231012  modify
         INTO g_ima63  FROM bmb_file         #20231012 add
        WHERE bmb01 = g_boa01
          AND bmb03 = g_boa[l_ac].boa03
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
 
    CONSTRUCT l_wc ON boa01,
                      boa02,boa03,
                      boa04,boa05,boa06,boa07
                 FROM s_boa[1].boa01,
                      s_boa[1].boa02,s_boa[1].boa03,
                      s_boa[1].boa04,
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
DEFINE   p_wc     STRING 
DEFINE   l_cnt    LIKE type_file.chr1   #20251105               
     
    LET g_sql =
       "SELECT boa01,a.ima02,a.ima021,a.ima08,boa02,ta_boa01,boa03,b.ima02,b.ima021,",    #20250224
       "       bmb06,bmb07,",                                                             #20231012
       "       boa04,boa05,boa06,boa07 ",
       "       ,ta_boadate,ta_boamodu,boa08  " ,      
       "  FROM boa_file LEFT JOIN ima_file b ",           
       "    ON boa_file.boa03 =b.ima01 ",          
       "  LEFT JOIN ima_file a ON a.ima01=boa01 ",       
       "  LEFT JOIN bmb_file ON bmb01 = boa01 AND bmb03 = boa03 AND bmb05 IS NULL ",      #20231012  #20240911 排除失效                 
       " WHERE (NVL(boa08,'N')='",g_boa08,"' ) ",
       "   AND ",p_wc CLIPPED,
       " ORDER BY boa01,boa02" 
 
    PREPARE i610_prepare2 FROM g_sql           #預備一下
    DECLARE boa_curs CURSOR FOR i610_prepare2
    CALL g_boa.clear()
    CALL ga_color.clear()
    LET g_cnt = 1
    FOREACH boa_curs INTO g_boa[g_cnt].*       #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        ##--- 20251105 (S) ----
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt
         FROM bob_file
        WHERE bob01 = g_boa[g_cnt].boa01
          AND bob11 IS NULL
        GROUP BY bob01
        IF l_cnt > 1 THEN
           LET ga_color[g_cnt].boa01 = "RED"
        END IF
        ##--- 20251105 (E) ----
        IF g_cnt > 1 THEN
           DISPLAY BY NAME g_boa[g_cnt-1].boa01
           IF (g_boa[g_cnt].boa01 <> g_boa[g_cnt-1].boa01) OR (g_boa[g_cnt].boa02 <> g_boa[g_cnt-1].boa02) THEN
              LET ga_color[g_cnt].boa01 = "green reverse"
              LET ga_color[g_cnt].boa02 = "green reverse"
           END IF
        END IF 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
        #   CALL cl_err( '', 9035, 0 )
        #   EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_boa.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i610_b1_fill()              #BODY FILL UP
DEFINE
    p_wc     STRING                  
 
    LET g_sql1 =
       "SELECT bob02,bob03,bob07,bob04,bob05,bob06,bob08, ",
       "       bob09,bob10,bob11,bob14, " ,
       "       0,0 ",                                          #20230718                
       "  FROM bob_file ",           
       " WHERE bob01='",g_boa[l_ac].boa01,"' ",
       "   AND bob02='",g_boa[l_ac].boa02,"' "      
       
 
    PREPARE i610_prepare21 FROM g_sql1           #預備一下
    DECLARE bob_curs CURSOR FOR i610_prepare21
    CALL g_bob.clear()
    LET g_cnt1 = 1
    FOREACH bob_curs INTO g_bob[g_cnt1].*       #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL cs_muplant_atpqty(g_bob[g_cnt1].bob04, 'TY') RETURNING g_bob[g_cnt1].tyatp #20230718
        CALL cs_muplant_atpqty(g_bob[g_cnt1].bob04, 'KS') RETURNING g_bob[g_cnt1].ksatp #20230718
        LET g_cnt1 = g_cnt1 + 1
        IF g_cnt1 > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_bob.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt1 - 1
 #   DISPLAY g_rec_b TO FORMONLY.cn2
 #   LET g_cnt1 = 0
END FUNCTION
 
 
FUNCTION i610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_boa TO s_boa.* ATTRIBUTE(COUNT=g_rec_b)

 
      BEFORE DISPLAY
        # CALL cl_navigator_setting( g_curs_index, g_row_count )
        CALL DIALOG.setCellAttributes(ga_color)
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
        LET l_ac = ARR_CURR()
        #CALL cl_show_fld_cont()        
        IF l_ac = 0 THEN
           LET l_ac = 1
        END IF       
        IF l_ac > 0 THEN
           CALL i610_b1_fill()
           CALL i610_bp2('')
        END IF

      END DISPLAY

      DISPLAY ARRAY g_bob TO s_bob.* ATTRIBUTE(COUNT=g_rec_b2)
        BEFORE ROW
      END DISPLAY

 
     # ON ACTION insert
     #    LET g_action_choice="insert"
     #    EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
 
      ON ACTION first
         CALL i610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                  #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ##---- 20210416 add by momo (S) 
      ON ACTION carry
         LET g_action_choice="carry"
         EXIT DIALOG

      ON ACTION qry_carry_history
         LET g_action_choice = "qry_carry_history"
         EXIT DIALOG

     ##---- 20210416 add by momo (E) 整批無效
     ON ACTION allinvalid
        LET g_action_choice="allinvalid"
        EXIT DIALOG
     ##---- 20240910 add by momo (E)
     
 
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033

 
   END DIALOG


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
 
                                               #FUN-770052
 
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


FUNCTION  i610_boa01_c(p_cmd)
 
DEFINE
    p_cmd           LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
    l_desc          LIKE fan_file.fan02,      #No.FUN-680096 VARCHAR(4) 
    l_cnt           LIKE type_file.num5,      #No.FUN-680096 SMALLINT
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_ima05         LIKE ima_file.ima05,
    l_ima08         LIKE ima_file.ima08,
    l_imaacti       LIKE ima_file.imaacti,
    l_boa02         LIKE boa_file.boa02
 
    LET g_errno = ""
 
    SELECT ima02,ima021,ima05,ima08,imaacti
      INTO l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti FROM ima_file
     WHERE ima01=g_boa01_c
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
                                   LET l_ima05 = NULL
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
        DISPLAY l_ima05 TO FORMONLY.ima05
        DISPLAY l_ima08 TO FORMONLY.ima08
    END IF

END FUNCTION
#M014 180130 By TSD.Andy -----(E)



##----- 20200131 add by momo (S) 複製時系列別檢核
FUNCTION i610_copy_chk()
 DEFINE l_cnt       LIKE type_file.num5
 DEFINE l_tc_aad03  LIKE tc_aad_file.tc_aad03 

 LET l_cnt = 0

 #判斷是否符合可用系列別
 SELECT COUNT(*) INTO l_cnt
  FROM tc_aad_file
 WHERE tc_aad01 = g_boa01
   AND tc_aad02 = g_boa02
   AND tc_aad04 = 'Y'
   AND NOT EXISTS (SELECT * FROM ima_file 
                WHERE ima09 = tc_aad03 AND ima01 = g_boa01_c )
 IF l_cnt > 0 THEN
    CALL cl_err(l_tc_aad03,'cbm-008',1)
    LET g_boa01_c = ''
 END IF

 #抓取不可用系列別
 IF l_cnt = 0 THEN
    SELECT tc_aad03 INTO l_tc_aad03
      FROM tc_aad_file
     WHERE tc_aad01 = g_boa01
       AND tc_aad02 = g_boa02
       AND tc_aad04 = 'N'
       AND EXISTS (SELECT * FROM ima_file 
                    WHERE ima09 = tc_aad03 AND ima01 = g_boa01_c )
    IF NOT cl_null(l_tc_aad03) THEN
       CALL cl_err(l_tc_aad03,'cbm-008',1)
       LET g_boa01_c = ''
    END IF
 END IF
END FUNCTION
##----- 20200131 add by momo (E) 複製時系列別檢核

FUNCTION i610_bp2(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1

   DISPLAY ARRAY g_bob TO s_bob.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
      ON ACTION return
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()
   END DISPLAY

END FUNCTION

##--- 20210416 add by momo (S) 資料拋轉  
FUNCTION i610_carry()
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
   DEFINE l_sql     LIKE type_file.chr1000

   IF cl_null(g_boa08) THEN   
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
       LET g_boax[l_j].boa01 = g_boa[l_i].boa01
       LET g_boax[l_j].boa02 = g_boa[l_i].boa02
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

#---20240910 ---整批無效 (S)
FUNCTION i610_allinvalid()
  DEFINE p_value      LIKE type_file.chr1
  DEFINE l_i          LIKE type_file.num10

  BEGIN WORK
     FOR l_i = 1 TO g_boa.getLength()
        LET g_boa_t.* = g_boa[l_i].*            #BACKUP
        IF NOT cl_null(g_boa[l_i].boa07) THEN
           CONTINUE FOR
        END IF
        LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'boa_file'),
                    "   SET boa07 = '",g_today,"' ,",
                    "       ta_boadate = '",g_today,"' ,",
                    "       ta_boamodu = '",g_user,"' ",
                    " WHERE boa01 = ? ",
                    "   AND boa02 = ? ",
                    "   AND boa03 = ? ",
                    "   AND boa04 = ? ",
                    "   AND boa05 = ? "
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
        PREPARE upd_boa07 FROM g_sql
        EXECUTE upd_boa07 USING g_boa_t.boa01,g_boa_t.boa02,g_boa_t.boa03,g_boa_t.boa04,g_boa_t.boa05
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           LET g_success = 'N'
           CALL cl_err('upd boa_file',SQLCA.SQLCODE,1)
           EXIT FOR
           ROLLBACK WORK
        ELSE
           ##---- 20250224 無有效資料時，取消標準否 (S)
           IF g_boa[l_i].ta_boa01 = 'Y' THEN
              UPDATE boa_file  
                 SET ta_boa01='N',ta_boadate=g_today,ta_boamodu=g_user
              WHERE boa01=g_boa_t.boa01 AND boa02=g_boa_t.boa02
                AND NOT EXISTS (SELECT 1 FROM boa_file b 
                                 WHERE b.boa01=g_boa_t.boa01 AND b.boa02=g_boa_t.boa02 AND b.boa07 is null)
                
           END IF
           ##---- 20250224 無有效資料時，取消標準否 (E)
           CALL cs_updbmb16(g_boa_t.boa01,g_boa_t.boa03,'S')
           COMMIT WORK   
        END IF
  END FOR

  CALL i610_b_fill(g_wc)
END FUNCTION
#---20240910 ---整批無效 (E)
