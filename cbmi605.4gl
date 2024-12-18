# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cbmi605.4gl
# Descriptions...: 客戶BOM元件取代資料維護
# Date & Author..: 20201029 By momo
# Modify.........: 2106026314 20210607 By momo 增加客戶不可取代 tc_bmd02:9
# Modify.........: 24120019   20241218 By momo 修正複正時卡控錯誤

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE
    g_tc_bmd01         LIKE tc_bmd_file.tc_bmd01,   #
    g_tc_bmd08         LIKE tc_bmd_file.tc_bmd08,   #
    g_tc_bmdnote       LIKE tc_bmd_file.tc_bmdnote,   #
    g_tc_bmd02         LIKE tc_bmd_file.tc_bmd02,   #
    g_tc_bmd01_t       LIKE tc_bmd_file.tc_bmd01,   #
    g_tc_bmd08_t       LIKE tc_bmd_file.tc_bmd08,   #
    g_tc_bmd02_t       LIKE tc_bmd_file.tc_bmd02,   #
    g_tc_bmdnote_t     LIKE tc_bmd_file.tc_bmdnote,   #
    g_tc_bmd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_bmd03       LIKE tc_bmd_file.tc_bmd03,   #行序
        tc_bmd04       LIKE tc_bmd_file.tc_bmd04,   #舊料料號
        ima02_b        LIKE ima_file.ima02,        
        ima021_b       LIKE ima_file.ima02,
        tc_bmd05       LIKE tc_bmd_file.tc_bmd05,   #Date
        tc_bmd06       LIKE tc_bmd_file.tc_bmd06,   #Date
        tc_bmd07       LIKE tc_bmd_file.tc_bmd07,
        tc_bmddate     LIKE tc_bmd_file.tc_bmddate,
        gen02          LIKE gen_file.gen02
                    END RECORD,
    g_tc_bmd_t         RECORD                 #程式變數 (舊值)
        tc_bmd03       LIKE tc_bmd_file.tc_bmd03,   #行序
        tc_bmd04       LIKE tc_bmd_file.tc_bmd04,   #舊料料號
        ima02_b     LIKE ima_file.ima02, 
        ima021_b    LIKE ima_file.ima02,
        tc_bmd05       LIKE tc_bmd_file.tc_bmd05,   #Date
        tc_bmd06       LIKE tc_bmd_file.tc_bmd06,   #Date
        tc_bmd07       LIKE tc_bmd_file.tc_bmd07, 
        tc_bmddate     LIKE tc_bmd_file.tc_bmddate,
        gen            LIKE gen_file.gen02
                    END RECORD,
    g_tc_bmd04_o       LIKE tc_bmd_file.tc_bmd04,
    g_wc,g_wc2,g_sql    string,            #No.FUN-580092 HCN
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數   #No.FUN-680096 VARCHAR(1) 
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680096 SMALLINT
    g_ss            LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)  
    g_argv1         LIKE tc_bmd_file.tc_bmd01,
    g_argv2         LIKE tc_bmd_file.tc_bmd08,
    g_argv3         LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1) 
    g_ls            LIKE type_file.chr1,   #No.FUN-580110   #No.FUN-680096 VARCHAR(1) 
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT        #No.FUN-680096 SMALLINT
DEFINE g_cmd        LIKE type_file.chr1000
DEFINE g_flag       LIKE type_file.chr1
DEFINE g_forupd_sql   STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt        LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose    #No.FUN-680096 SMALLINT
DEFINE   g_msg        LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump       LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_no_ask     LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   l_table      STRING                  #No.FUN-C30190
##---- 20190708 -- (S)
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE   g_action_flag  STRING
DEFINE   g_rec_b1       LIKE type_file.num10
DEFINE   l_ac1          LIKE type_file.num10
DEFINE   g_tc_bmd_a        RECORD LIKE tc_bmd_file.*
DEFINE   g_tc_bmd_1        DYNAMIC ARRAY OF RECORD
                           tc_bmd01    LIKE tc_bmd_file.tc_bmd01,
                           tc_bmd04    LIKE tc_bmd_file.tc_bmd04,
                           ima02       LIKE ima_file.ima02,
                           ima021      LIKE ima_file.ima021,
                           ima25       LIKE ima_file.ima25,
                           ima08       LIKE ima_file.ima08,
                           tc_bmd02    LIKE tc_bmd_file.tc_bmd02,
                           tc_bmd08    LIKE tc_bmd_file.tc_bmd08,
                           occ02       LIKE occ_file.occ02,
                           tc_bmdnote  LIKE tc_bmd_file.tc_bmdnote
                                       END RECORD
##---- 20190708 -- (E)
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("CBM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

    #FUN-C30190---add---Begin
    LET g_sql = "l_order1.tc_bmd_file.tc_bmd01,",
                "l_order2.tc_bmd_file.tc_bmd01,",
                "tc_bmd01.tc_bmd_file.tc_bmd01,",
                "tc_bmd08.tc_bmd_file.tc_bmd08,",
                "tc_bmd02.tc_bmd_file.tc_bmd02,",
                "tc_bmd03.tc_bmd_file.tc_bmd03,",
                "tc_bmd04.tc_bmd_file.tc_bmd04,",
                "tc_bmd05.tc_bmd_file.tc_bmd05,",
                "tc_bmd06.tc_bmd_file.tc_bmd06,",
                "tc_bmd07.tc_bmd_file.tc_bmd07"

    LET l_table = cl_prt_temptable('cbmi605',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    #FUN-C30190---add---End
    LET g_tc_bmd01 = NULL                     #清除鍵值
    LET g_tc_bmd08 = NULL                     #清除鍵值
    LET g_tc_bmd02 = NULL                     #20210607                    
    LET g_tc_bmd01_t = NULL
    LET g_tc_bmd08_t = NULL
    LET g_tc_bmd02_t = NULL                   #20210607
 
    #取得參數
    LET g_argv1=ARG_VAL(1)	#元件
    IF g_argv1=' ' THEN LET g_argv1='' ELSE LET g_tc_bmd01=g_argv1 END IF
    LET g_argv2=ARG_VAL(2)	#主件
    IF g_argv2=' ' THEN LET g_argv2='' ELSE LET g_tc_bmd08=g_argv2 END IF
    LET g_argv3='3'	        #CUS UTE
 
    OPEN WINDOW i605_w WITH FORM "cbm/42f/cbmi605"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()

    #CALL s_decl_bmb() 
    
    IF NOT cl_null(g_argv1) THEN CALL i605_q() END IF
    IF NOT cl_null(g_argv1) AND g_row_count = 0  THEN CALL i605_a() END IF 

 
    LET g_delete='N'
    CALL i605_menu()
    CLOSE WINDOW i605_w                                 #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION i605_cs()
    IF cl_null(g_argv1) THEN
    	CLEAR FORM                             #清除畫面
        CALL g_tc_bmd.clear() 
        CALL cl_set_head_visible("","YES")           

   INITIALIZE g_tc_bmd01 TO NULL    
   INITIALIZE g_tc_bmd08 TO NULL    
    	CONSTRUCT g_wc ON tc_bmd01,tc_bmd08,tc_bmd02,tc_bmd03,tc_bmd04,
                          tc_bmd05,tc_bmd06
        	FROM tc_bmd01,tc_bmd08,tc_bmd02,s_tc_bmd[1].tc_bmd03,s_tc_bmd[1].tc_bmd04,
                 s_tc_bmd[1].tc_bmd05,s_tc_bmd[1].tc_bmd06
                    
 
           BEFORE CONSTRUCT
              CALL cl_qbe_init()
 
           ON ACTION CONTROLP
               CASE
                   WHEN INFIELD(tc_bmd01)
                        CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO tc_bmd01
                        NEXT FIELD tc_bmd01
                   WHEN INFIELD(tc_bmd08)
                        #CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = 'q_occ'
                        LET g_qryparam.state  = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO tc_bmd08
                        NEXT FIELD tc_bmd08
                   WHEN INFIELD(tc_bmd04)
                        CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO tc_bmd04
                        NEXT FIELD tc_bmd04
               END CASE
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
 
           ON ACTION about         
              CALL cl_about()      
      
           ON ACTION help          
              CALL cl_show_help()  
      
           ON ACTION controlg      
              CALL cl_cmdask()     
 
           ON ACTION qbe_select
              CALL cl_qbe_select()
           ON ACTION qbe_save
	      CALL cl_qbe_save()
 
        END CONSTRUCT
    	IF INT_FLAG THEN RETURN END IF
      ELSE
	LET g_wc=" tc_bmd02 IN ('3','9') AND tc_bmd01='",g_argv1,"'"              #20210607
    END IF
    LET g_sql="SELECT DISTINCT tc_bmd01,tc_bmd08,tc_bmd02 FROM tc_bmd_file ", 
               " WHERE tc_bmd02 IN ('3','9') AND ", g_wc CLIPPED,                 #20210607
               " ORDER BY tc_bmd01,tc_bmd08,tc_bmd02"
    PREPARE i605_prepare FROM g_sql      #預備一下
    IF STATUS THEN CALL cl_err('prep:',STATUS,1) END IF
    DECLARE i605_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i605_prepare
    LET g_sql="SELECT DISTINCT tc_bmd01,tc_bmd08,tc_bmd02 FROM tc_bmd_file WHERE tc_bmd02 IN ('3','9') AND ",  #20210607
               g_wc CLIPPED
    PREPARE i605_precount FROM g_sql
    DECLARE i605_count CURSOR FOR i605_precount
END FUNCTION
 
FUNCTION i605_menu()
 
    CALL cl_navigator_setting( g_curs_index, g_row_count )
       
   WHILE TRUE
  
      CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "main")
            CALL i605_bp("G")
         WHEN (g_action_flag = "page_list")
            CALL i605_list_fill()
            CALL i605_bp1("G")
            IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
               SELECT tc_bmd_file.* INTO g_tc_bmd_a.* FROM tc_bmd_file
                WHERE tc_bmd01=g_tc_bmd_1[l_ac1].tc_bmd01
            END IF
            IF g_action_choice!= "" THEN
               LET g_action_flag = 'main'
               LET l_ac1 = ARR_CURR()
               LET g_jump = l_ac1
               LET g_no_ask = TRUE
               IF g_rec_b1 >0 THEN
                   CALL i605_fetch('/')
               END IF
               CALL cl_set_comp_visible("page_list", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page_list", TRUE)
             END IF
      END CASE
  
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i605_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i605_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i605_u()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i605_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i605_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i605_b()
            ELSE
               LET g_action_choice = NULL
            END IF
      
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"                  
            IF cl_chk_act_auth() THEN
               IF g_tc_bmd01 IS NOT NULL THEN
                  LET g_doc.column1 = "tc_bmd01"
                  LET g_doc.value1  = g_tc_bmd01
                  LET g_doc.column2 = "tc_bmd02"
                  LET g_doc.value2  = g_tc_bmd02
                  LET g_doc.column3 = "tc_bmd08"
                  LET g_doc.value3  = g_tc_bmd08
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN              
              LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               CASE                                                                              
                  WHEN (g_action_flag IS NULL) OR (g_action_flag = 'main')                            
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_bmd),'','')
                  WHEN (g_action_flag = 'page_list')
                     LET page = f.FindNode("Page","page_list")                                                 
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_bmd_1),'','')
               END CASE
               LET g_action_choice = NULL
            END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
#Add  輸入
FUNCTION i605_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_tc_bmd.clear()
    INITIALIZE g_tc_bmd01 LIKE tc_bmd_file.tc_bmd01
    INITIALIZE g_tc_bmd08 LIKE tc_bmd_file.tc_bmd08
    #INITIALIZE g_tc_bmd02 LIKE tc_bmd_file.tc_bmd02
    INITIALIZE g_tc_bmdnote LIKE tc_bmd_file.tc_bmdnote
    IF NOT cl_null(g_argv1) THEN
       LET g_tc_bmd01=g_argv1
       DISPLAY g_tc_bmd01 TO tc_bmd01
       CALL i605_tc_bmd01('a') 
    END IF
    IF NOT cl_null(g_argv3) THEN
       LET g_tc_bmd02=g_argv3
       DISPLAY g_tc_bmd02 TO tc_bmd02
    END IF
    LET g_tc_bmd01_t = NULL
    LET g_tc_bmd08_t = NULL
    LET g_tc_bmd02_t = NULL            #20210607
    LET g_tc_bmdnote_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        IF cl_null(g_tc_bmd02) THEN    #No.MOD-850293 add
           LET g_tc_bmd02 ='3'
        END IF                      #No.MOD-850293 add
        CALL i605_i("a")                   #輸入單頭
	IF INT_FLAG THEN
           LET g_tc_bmd01=NULL
           LET INT_FLAG=0
           CALL cl_err('',9001,0)
           EXIT WHILE 
        END IF
        CALL g_tc_bmd.clear()
	LET g_rec_b = 0
        DISPLAY g_rec_b TO FORMONLY.cn2
        CALL i605_b()                   #輸入單身
        LET g_tc_bmd01_t = g_tc_bmd01            #保留舊值
        LET g_tc_bmd08_t = g_tc_bmd08            #保留舊值
        LET g_tc_bmd02_t = g_tc_bmd02            #保留舊值
        LET g_tc_bmdnote_t = g_tc_bmdnote            #保留舊值
        EXIT WHILE
    END WHILE

END FUNCTION
 
FUNCTION i605_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_tc_bmd01 IS NULL OR g_tc_bmd08 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tc_bmd01_t = g_tc_bmd01
    LET g_tc_bmd08_t = g_tc_bmd08
    LET g_tc_bmd02_t = g_tc_bmd02
    LET g_tc_bmdnote_t = g_tc_bmdnote
    WHILE TRUE
        CALL i605_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_tc_bmd01=g_tc_bmd01_t
            LET g_tc_bmd08=g_tc_bmd08_t
            LET g_tc_bmd02=g_tc_bmd02_t
            LET g_tc_bmdnote=g_tc_bmdnote_t
            DISPLAY g_tc_bmd01 TO tc_bmd01      #單頭
            DISPLAY g_tc_bmd08 TO tc_bmd08      #單頭
            DISPLAY g_tc_bmd02 TO tc_bmd02      #單頭
            DISPLAY g_tc_bmdnote TO tc_bmdnote      #單頭
 
            LET INT_FLAG = 0
            #CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
            UPDATE tc_bmd_file SET tc_bmdnote = g_tc_bmdnote,  #更新DB
                                   tc_bmddate = g_today,
                                   tc_bmdmodu = g_user
                WHERE tc_bmd01 = g_tc_bmd01_t          #COLAUTH?
	              AND tc_bmd08 = g_tc_bmd08_t
	              AND tc_bmd02 = g_tc_bmd02_t
            IF SQLCA.sqlcode THEN
	        LET g_msg = g_tc_bmd01 CLIPPED,' + ', g_tc_bmd08 CLIPPED
                CALL cl_err3("upd","tc_bmd_file",g_tc_bmd01_t,g_tc_bmd08_t,SQLCA.sqlcode,"",g_msg,1) #TQC-660046
                CONTINUE WHILE
            END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i605_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改       
    l_cnt           LIKE type_file.num5,     
    l_tc_bmd04         LIKE tc_bmd_file.tc_bmd04,
    l_n             LIKE type_file.num5      
DEFINE  l_i         LIKE type_file.num5,     
        l_sum_tc_bmd07 LIKE tc_bmd_file.tc_bmd07      
DEFINE  l_num       LIKE type_file.num5      

    LET g_ss='Y'
    CALL cl_set_head_visible("","YES")          
    INPUT g_tc_bmd01, g_tc_bmd08, g_tc_bmd02, g_tc_bmdnote     
        WITHOUT DEFAULTS
        FROM tc_bmd01,tc_bmd08,tc_bmd02, tc_bmdnote
 
 
	BEFORE FIELD tc_bmd01  # 是否可以修改 key
	 #   IF g_chkey = 'N' AND p_cmd = 'u' THEN RETURN END IF
         IF p_cmd = 'u' THEN
            CALL cl_set_comp_entry("tc_bmd01,tc_bmd02,tc_bmd08","FALSE")
         END IF
 
        AFTER FIELD tc_bmd01            #
            IF NOT cl_null(g_tc_bmd01) THEN
              
                IF NOT s_chk_item_no(g_tc_bmd01,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_tc_bmd01 = g_tc_bmd01_t
                   DISPLAY g_tc_bmd01 TO tc_bmd01
                   NEXT FIELD tc_bmd01
                END IF 
              
                IF g_tc_bmd01 != g_tc_bmd01_t OR g_tc_bmd01_t IS NULL THEN
                    CALL i605_tc_bmd01('a')
                    IF NOT cl_null(g_errno) THEN
	                IF g_errno='mfg9116' THEN
	                    IF NOT cl_confirm(g_errno) THEN
	                        NEXT FIELD tc_bmd01
	                    END IF
	                ELSE
                            CALL cl_err(g_tc_bmd01,g_errno,0)
                            LET g_tc_bmd01 = g_tc_bmd01_t
                            DISPLAY g_tc_bmd01 TO tc_bmd01
                            NEXT FIELD tc_bmd01
	                END IF
                    END IF
                    
                    IF NOT cl_null(g_tc_bmd08) THEN
                       LET l_n=0
                       SELECT COUNT(*) INTO l_n FROM ima_file
                        WHERE ima1007 = g_tc_bmd08
                         
                       IF l_n = 0 THEN
                          CALL cl_err('','aic-004',0)
                          NEXT FIELD tc_bmd01
                       END IF
                    END IF
                  
                END IF
            END IF
 
        AFTER FIELD tc_bmd08            #
	    IF NOT cl_null(g_tc_bmd08) THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM occ_file
                WHERE occ01 = g_tc_bmd08
               IF l_n = 0 THEN
                  CALL cl_err('','alm1625',0)
                  NEXT FIELD tc_bmd08
               END IF
            END IF
            
        AFTER FIELD tc_bmd02            #
	    IF NOT cl_null(g_tc_bmd02) THEN
	        IF g_tc_bmd02 NOT MATCHES '[39]' THEN NEXT FIELD tc_bmd02 END IF   #20210607
                SELECT count(*) INTO g_cnt FROM tc_bmd_file
                    WHERE tc_bmd01 = g_tc_bmd01
                      AND tc_bmd08 = g_tc_bmd08
                      AND tc_bmd02 = g_tc_bmd02
                IF g_cnt > 0 THEN   #資料重複
	            LET g_msg = g_tc_bmd01 CLIPPED,' + ', g_tc_bmd08 CLIPPED
                    CALL cl_err(g_msg,-239,0)
                    LET g_tc_bmd01 = g_tc_bmd01_t
                    LET g_tc_bmd08 = g_tc_bmd08_t
                    DISPLAY  g_tc_bmd01 TO tc_bmd01
                    DISPLAY  g_tc_bmd08 TO tc_bmd08
                    NEXT FIELD tc_bmd01
                END IF
            END IF


 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(tc_bmd01)
                     CALL q_sel_ima(FALSE, "q_ima", "", g_tc_bmd01, "", "", "", "" ,"",'' )  RETURNING g_tc_bmd01
                     DISPLAY BY NAME g_tc_bmd01
                     CALL i605_tc_bmd01('d')
                     NEXT FIELD tc_bmd01
                WHEN INFIELD(tc_bmd08)
                     #CALL q_sel_ima(FALSE, "q_ima", "", g_tc_bmd08, "", "", "", "" ,"",'' )  RETURNING g_tc_bmd08
                     #DISPLAY BY NAME g_tc_bmd08
                     #CALL i605_tc_bmd08('d')
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_occ'
                     LET g_qryparam.default1 = g_tc_bmd08
                     CALL cl_create_qry() RETURNING g_tc_bmd08
                     DISPLAY BY NAME g_tc_bmd08
                     NEXT FIELD tc_bmd08
                OTHERWISE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION controlg       
           CALL cl_cmdask()      
 
        ON IDLE g_idle_seconds   
           CALL cl_on_idle()     
           CONTINUE INPUT       
 
        ON ACTION about          
           CALL cl_about()       
 
        ON ACTION help           
           CALL cl_show_help()   
    END INPUT
#TQC-B90236------add------begin
    IF g_tc_bmd.getLength() > 0 THEN
       LET l_sum_tc_bmd07 = 0
       FOR l_i = 1 TO g_tc_bmd.getLength()
          LET l_sum_tc_bmd07 = l_sum_tc_bmd07 + g_tc_bmd[l_i].tc_bmd07
       END FOR  
    END IF
#TQC-B90236------add------end
END FUNCTION
 
FUNCTION i605_tc_bmd01(p_cmd)  #
    DEFINE p_cmd     LIKE type_file.chr1,          
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima25   LIKE ima_file.ima25,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima25,ima08,imaacti
           INTO l_ima02,l_ima021,l_ima25,l_ima08,l_imaacti
           FROM ima_file WHERE ima01 = g_tc_bmd01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_ima02 = NULL  LET l_ima25 = NULL
                            LET l_ima021 = NULL
                            LET l_ima08 = NULL  LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
 
         WHEN l_ima08 NOT MATCHES '[PVZS]' LET g_errno = 'mfg9116'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
     IF cl_null(g_errno) OR p_cmd = 'd' OR g_errno = 'mfg9116'  
      THEN DISPLAY l_ima02 TO FORMONLY.ima02_h
           DISPLAY l_ima021 TO FORMONLY.ima021_h
           DISPLAY l_ima25 TO FORMONLY.ima25_h
           DISPLAY l_ima08 TO FORMONLY.ima08_h
    END IF
END FUNCTION
 
 
#Query 查詢
FUNCTION i605_q()
  DEFINE l_tc_bmd01  LIKE tc_bmd_file.tc_bmd01,
         l_tc_bmd08  LIKE tc_bmd_file.tc_bmd08,
         l_tc_bmd02  LIKE tc_bmd_file.tc_bmd02,
         l_cnt    LIKE type_file.num10  
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_tc_bmd01 TO NULL        
    INITIALIZE g_tc_bmd08 TO NULL        
    #INITIALIZE g_tc_bmd02 TO NULL        
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i605_cs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_tc_bmd01 TO NULL
        INITIALIZE g_tc_bmd08 TO NULL
        INITIALIZE g_tc_bmd02 TO NULL
        RETURN
    END IF
    OPEN i605_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('open cursor:',SQLCA.sqlcode,0)
        INITIALIZE g_tc_bmd01 TO NULL
        INITIALIZE g_tc_bmd08 TO NULL
        INITIALIZE g_tc_bmd02 TO NULL
    ELSE
        FOREACH i605_count INTO l_tc_bmd01,l_tc_bmd08,l_tc_bmd02
            LET g_row_count = g_row_count + 1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt
        IF NOT cl_null(g_argv1) AND g_row_count = 0 THEN
            RETURN
        END IF
        CALL i605_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i605_fetch(p_flag)
DEFINE
    p_flag   LIKE type_file.chr1        #處理方式   
  DEFINE l_tc_bmd01  LIKE tc_bmd_file.tc_bmd01,
         l_tc_bmd08  LIKE tc_bmd_file.tc_bmd08,
         l_tc_bmd02  LIKE tc_bmd_file.tc_bmd02
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i605_bcs INTO g_tc_bmd01,g_tc_bmd08,g_tc_bmd02 
        WHEN 'P' FETCH PREVIOUS i605_bcs INTO g_tc_bmd01,g_tc_bmd08,g_tc_bmd02
        WHEN 'F' FETCH FIRST    i605_bcs INTO g_tc_bmd01,g_tc_bmd08,g_tc_bmd02
        WHEN 'L' FETCH LAST     i605_bcs INTO g_tc_bmd01,g_tc_bmd08,g_tc_bmd02
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i605_bcs INTO g_tc_bmd01,g_tc_bmd08,g_tc_bmd02
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_tc_bmd01,SQLCA.sqlcode,1)
        INITIALIZE g_tc_bmd01 TO NULL  
        INITIALIZE g_tc_bmd02 TO NULL  
        INITIALIZE g_tc_bmd08 TO NULL  
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
    CALL i605_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i605_show()
  DEFINE l_tc_bmddate LIKE tc_bmd_file.tc_bmddate
  DEFINE l_gen02      LIKE gen_file.gen02
  DEFINE l_occ02      LIKE occ_file.occ02
     
    SELECT tc_bmdnote
      INTO g_tc_bmdnote,l_tc_bmddate,l_gen02
      FROM tc_bmd_file
    WHERE tc_bmd01 = g_tc_bmd01
      AND tc_bmd08 = g_tc_bmd08
      AND tc_bmd02 = g_tc_bmd02
    DISPLAY g_tc_bmd01 TO tc_bmd01      #單頭
    DISPLAY g_tc_bmd08 TO tc_bmd08      #單頭
    DISPLAY g_tc_bmd02 TO tc_bmd02      #單頭
    DISPLAY g_tc_bmdnote TO tc_bmdnote     

    SELECT occ02 INTO l_occ02
      FROM occ_file
     WHERE occ01 = g_tc_bmd08

   DISPLAY l_occ02 TO FORMONLY.occ02_h
    
    CALL i605_tc_bmd01('d')
    CALL i605_bf(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i605_r()
  DEFINE l_tc_bmd01  LIKE tc_bmd_file.tc_bmd01,
         l_tc_bmd08  LIKE tc_bmd_file.tc_bmd08,
         l_tc_bmd02  LIKE tc_bmd_file.tc_bmd02
  DEFINE l_n      LIKE type_file.num5     #No.CHI-860017
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_tc_bmd01 IS NULL THEN
       CALL cl_err("",-400,0)              #No.FUN-6A0002
       RETURN
    END IF

    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       
        LET g_doc.column1 = "tc_bmd01"      
        LET g_doc.value1  = g_tc_bmd01      
        LET g_doc.column2 = "tc_bmd02"     
        LET g_doc.value2  = g_tc_bmd02      
        LET g_doc.column3 = "tc_bmd08"      
        LET g_doc.value3  = g_tc_bmd08      
        CALL cl_del_doc()                
        DELETE FROM tc_bmd_file
         WHERE tc_bmd01=g_tc_bmd01 AND tc_bmd08=g_tc_bmd08 AND tc_bmd02= g_tc_bmd02 #20210607
        IF SQLCA.sqlcode THEN
             CALL cl_err3("del","tc_bmd_file",g_tc_bmd01,g_tc_bmd08,SQLCA.sqlcode,"","BODY DELETE",1)   #TQC - 660046 
        ELSE
 
            CLEAR FORM
            CALL g_tc_bmd.clear()
            LET g_row_count = 0
            FOREACH i605_count INTO l_tc_bmd01,l_tc_bmd08,l_tc_bmd02
                LET g_row_count = g_row_count + 1
            END FOREACH
            
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i605_bcs

                                                   
            IF g_row_count >= 1 THEN         
               IF g_curs_index = g_row_count + 1 THEN
                  LET g_jump = g_row_count
                  CALL i605_fetch('L')
               ELSE
                  LET g_jump = g_curs_index
                  LET g_no_ask = TRUE
                  CALL i605_fetch('/')
               END IF
            ELSE               
               LET g_tc_bmd01 = NULL
               LET g_tc_bmd08 = NULL
               LET g_tc_bmd02 = NULL               
            END IF
            
            LET g_delete='Y'
           
            MESSAGE 'DELETE O.K' 
        END IF
    END IF
END FUNCTION
 
 
#單身
FUNCTION i605_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     
    l_n             LIKE type_file.num5,     
    l_lock_sw       LIKE type_file.chr1,     
    p_cmd           LIKE type_file.chr1,     
    l_allow_insert  LIKE type_file.num5,     
    l_allow_delete  LIKE type_file.num5,    
    l_cnt           LIKE type_file.num5      
DEFINE  l_n1        LIKE type_file.num5      
DEFINE  l_i         LIKE type_file.num5,    
        l_sum_tc_bmd07 LIKE tc_bmd_file.tc_bmd07      
DEFINE  l_num       LIKE type_file.num5     
DEFINE  l_tc_bmd02     LIKE tc_bmd_file.tc_bmd02      

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_tc_bmd01 IS NULL THEN
        RETURN
    END IF

 
    CALL cl_opmsg('b')
    LET g_forupd_sql =
      " SELECT tc_bmd03,tc_bmd04,'','',tc_bmd05,tc_bmd06,tc_bmd07,tc_bmddate,'' ",   
      " FROM tc_bmd_file ",
      "  WHERE tc_bmd01 = ? ",
      "   AND tc_bmd08 = ? ",
      "   AND tc_bmd02 = ? ",
      "   AND tc_bmd03 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i605_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_tc_bmd
              WITHOUT DEFAULTS
              FROM s_tc_bmd.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_tc_bmd_t.* = g_tc_bmd[l_ac].*  #BACKUP
               LET g_tc_bmd04_o = g_tc_bmd[l_ac].tc_bmd04  #BACKUP
                BEGIN WORK
                OPEN i605_bcl USING g_tc_bmd01,g_tc_bmd08,g_tc_bmd02,g_tc_bmd_t.tc_bmd03
                IF STATUS THEN
                    CALL cl_err("OPEN i605_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i605_bcl INTO g_tc_bmd[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_tc_bmd_t.tc_bmd03,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    LET g_tc_bmd[l_ac].ima02_b=g_tc_bmd_t.ima02_b
                    LET g_tc_bmd[l_ac].ima021_b=g_tc_bmd_t.ima021_b
                END IF
                CALL cl_show_fld_cont()     
            END IF

 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO tc_bmd_file
              (tc_bmd01, tc_bmd02, tc_bmd03, tc_bmd04,
               tc_bmd05, tc_bmd06, tc_bmd07, tc_bmd08,
               tc_bmdnote, tc_bmddate,tc_bmdmodu)
            VALUES(g_tc_bmd01,g_tc_bmd02,                               #20210607
                   g_tc_bmd[l_ac].tc_bmd03,g_tc_bmd[l_ac].tc_bmd04,
                   g_tc_bmd[l_ac].tc_bmd05,g_tc_bmd[l_ac].tc_bmd06,
                   g_tc_bmd[l_ac].tc_bmd07,g_tc_bmd08,
                   g_tc_bmdnote,g_today,g_user)
           IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","tc_bmd_file",g_tc_bmd01,g_tc_bmd[l_ac].tc_bmd03,SQLCA.sqlcode,"","",1)     
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
      
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
	        COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_tc_bmd[l_ac].* TO NULL     
            LET g_tc_bmd[l_ac].tc_bmd05=TODAY
            LET g_tc_bmd[l_ac].tc_bmd07=1               
         
            LET g_tc_bmd_t.* = g_tc_bmd[l_ac].*        
            CALL cl_show_fld_cont()    
            NEXT FIELD tc_bmd03
 
        BEFORE FIELD tc_bmd03                        #default 序號
            IF p_cmd='a' THEN
                SELECT max(tc_bmd03)+1
                   INTO g_tc_bmd[l_ac].tc_bmd03
                   FROM tc_bmd_file
                   WHERE tc_bmd01=g_tc_bmd01 AND tc_bmd08=g_tc_bmd08 AND tc_bmd02=g_tc_bmd02                  
                IF g_tc_bmd[l_ac].tc_bmd03 IS NULL THEN
                    LET g_tc_bmd[l_ac].tc_bmd03 = 1
                END IF
            END IF
 
        AFTER FIELD tc_bmd03                        #check 序號是否重複
            IF NOT cl_null(g_tc_bmd[l_ac].tc_bmd03) THEN
                IF g_tc_bmd[l_ac].tc_bmd03 != g_tc_bmd_t.tc_bmd03 OR
                   g_tc_bmd_t.tc_bmd03 IS NULL THEN
                    SELECT count(*) INTO l_n FROM tc_bmd_file
                        WHERE tc_bmd01 = g_tc_bmd01
                          AND tc_bmd08 = g_tc_bmd08
                          AND tc_bmd02 = g_tc_bmd02
                          AND tc_bmd03 = g_tc_bmd[l_ac].tc_bmd03
                   
                    IF l_n > 0 THEN
                       CALL cl_err(g_tc_bmd[l_ac].tc_bmd03,-239,0)
                       LET g_tc_bmd[l_ac].tc_bmd03 = g_tc_bmd_t.tc_bmd03
                       NEXT FIELD tc_bmd03
                    END IF
                END IF
            END IF
 
         AFTER FIELD tc_bmd04
             IF NOT cl_null(g_tc_bmd[l_ac].tc_bmd04) THEN
             
                IF NOT s_chk_item_no(g_tc_bmd[l_ac].tc_bmd04,'') THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD tc_bmd04
                END IF 
               
               #合理性的檢查,元件A不應同時有相同的替代料及取代料皆為B的狀況
                IF g_tc_bmd02='1' THEN
                   SELECT COUNT(*) INTO l_cnt FROM tc_bmd_file
                    WHERE tc_bmd01=g_tc_bmd01 
                      AND tc_bmd08=g_tc_bmd08
                      AND tc_bmd04=g_tc_bmd[l_ac].tc_bmd04
                      AND tc_bmd02='2'
                                                       
                ELSE
                   SELECT COUNT(*) INTO l_cnt FROM tc_bmd_file
                    WHERE tc_bmd01=g_tc_bmd01
                      AND tc_bmd08=g_tc_bmd08 
                      AND tc_bmd04=g_tc_bmd[l_ac].tc_bmd04
                      AND tc_bmd02='1'
                                                        
                END IF
                IF l_cnt > 0 THEN
                   CALL cl_err_msg("","abm-205",g_tc_bmd01 CLIPPED|| "|" || g_tc_bmd[l_ac].tc_bmd04 CLIPPED,10)
                   NEXT FIELD tc_bmd04
                END IF 
 
                 IF g_tc_bmd[l_ac].tc_bmd04=g_tc_bmd01 THEN
                    CALL cl_err('','abm-804',0) NEXT FIELD tc_bmd04
                 END IF
                 SELECT ima02,ima021 INTO g_tc_bmd[l_ac].ima02_b,g_tc_bmd[l_ac].ima021_b
                   FROM ima_file
                  WHERE ima01=g_tc_bmd[l_ac].tc_bmd04                                                     
                 IF STATUS THEN
                     CALL cl_err3("sel","ima_file",g_tc_bmd[l_ac].tc_bmd04,"",STATUS,"","sel ima:",1)    
                     NEXT FIELD tc_bmd04
                 END IF

             END IF
          
             IF NOT cl_null(g_tc_bmd[l_ac].tc_bmd05) THEN
                CALL i605_chk_date_range('b')
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD tc_bmd05
                END IF
             END IF
           
 
        AFTER FIELD tc_bmd05
          CALL i605_chk_date_range('b')
          IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,0)
            NEXT FIELD tc_bmd05
          END IF
 
        AFTER FIELD tc_bmd06
             IF NOT cl_null(g_tc_bmd[l_ac].tc_bmd06) THEN
                IF g_tc_bmd[l_ac].tc_bmd06 < g_tc_bmd[l_ac].tc_bmd05 THEN
                   CALL cl_err(g_tc_bmd[l_ac].tc_bmd06,'mfg2604',0)
                   NEXT FIELD tc_bmd06
                END IF
             END IF
 
            CALL i605_chk_date_range('e')
            IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD tc_bmd06
            END IF
 
        AFTER FIELD tc_bmd07
           IF g_tc_bmd[l_ac].tc_bmd07 < 0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD tc_bmd07
           END IF

 
        BEFORE DELETE                            #是否取消單身
            IF g_tc_bmd_t.tc_bmd03 > 0 AND
               g_tc_bmd_t.tc_bmd03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM tc_bmd_file
                    WHERE tc_bmd01 = g_tc_bmd01
                      AND tc_bmd08 = g_tc_bmd08
                      AND tc_bmd02 = g_tc_bmd02
                      AND tc_bmd03 = g_tc_bmd_t.tc_bmd03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","tc_bmd_file",g_tc_bmd01,g_tc_bmd08,SQLCA.sqlcode,"","",1)       
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
               

	        COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_bmd[l_ac].* = g_tc_bmd_t.*
               CLOSE i605_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_bmd[l_ac].tc_bmd03,-263,1)
               LET g_tc_bmd[l_ac].* = g_tc_bmd_t.*
            ELSE
       
                UPDATE tc_bmd_file SET
                       tc_bmd03=g_tc_bmd[l_ac].tc_bmd03,
                       tc_bmd04=g_tc_bmd[l_ac].tc_bmd04,
                       tc_bmd05=g_tc_bmd[l_ac].tc_bmd05,
                       tc_bmd06=g_tc_bmd[l_ac].tc_bmd06,
                       tc_bmd07=g_tc_bmd[l_ac].tc_bmd07,
                       tc_bmddate=g_today,
                       tc_bmdmodu=g_user
                 WHERE tc_bmd01=g_tc_bmd01
                   AND tc_bmd08=g_tc_bmd08
                   AND tc_bmd02=g_tc_bmd02                 #20210607
                   AND tc_bmd03=g_tc_bmd_t.tc_bmd03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","tc_bmd_file",g_tc_bmd01,g_tc_bmd_t.tc_bmd03,SQLCA.sqlcode,"","",1)         
                    LET g_tc_bmd[l_ac].* = g_tc_bmd_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
	            COMMIT WORK
                END IF
            END IF

 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_tc_bmd[l_ac].* = g_tc_bmd_t.*
               ELSE
                  CALL g_tc_bmd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               CLOSE i605_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  

           
            IF cl_null(g_tc_bmd[l_ac].tc_bmd03) THEN 
               CALL g_tc_bmd.deleteElement(l_ac)
            END IF
           
            CLOSE i605_bcl
            COMMIT WORK

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tc_bmd03) AND l_ac > 1 THEN
                LET g_tc_bmd[l_ac].* = g_tc_bmd[l_ac-1].*
                NEXT FIELD tc_bmd03
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(tc_bmd04)
                    CALL q_sel_ima(FALSE, "q_ima", "", g_tc_bmd[l_ac].tc_bmd04 , "", "", "", "" ,"",'' )  RETURNING g_tc_bmd[l_ac].tc_bmd04
                    
                    DISPLAY g_tc_bmd[l_ac].tc_bmd04 TO tc_bmd04
                    NEXT FIELD tc_bmd04
            END CASE
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controls                                    
         CALL cl_set_head_visible("","AUTO")      

      AFTER INPUT 
         LET l_sum_tc_bmd07 = 0
         FOR l_i = 1 TO g_tc_bmd.getLength() 
             LET l_sum_tc_bmd07 = l_sum_tc_bmd07 + g_tc_bmd[l_i].tc_bmd07
         END FOR
      END INPUT
    CLOSE i605_bcl
	COMMIT WORK
END FUNCTION
  
 
FUNCTION i605_b_askkey()
DEFINE
    l_wc    LIKE type_file.chr1000  
 
    CONSTRUCT l_wc ON tc_bmd03, tc_bmd04                     #螢幕上取條件
       FROM s_tc_bmd[1].tc_bmd03,s_tc_bmd[1].tc_bmd04
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
 
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
         ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
    LET l_wc = l_wc CLIPPED,cl_get_extra_cond('tc_bmduser', 'tc_bmdgrup') 
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i605_bf(l_wc)
END FUNCTION
 
FUNCTION i605_bf(p_wc)              #BODY FILL UP
DEFINE
    p_wc     LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(300)
 
    LET g_sql =
       "SELECT tc_bmd03, tc_bmd04, ima02,ima021,tc_bmd05, tc_bmd06, tc_bmd07,tc_bmddate,tc_bmdmodu ",
       " FROM ima_file,tc_bmd_file ",
       " LEFT JOIN gen_file ON gen01= tc_bmdmodu ",
       " WHERE tc_bmd01 = '",g_tc_bmd01,"' AND tc_bmd08 = '",g_tc_bmd08,"'",
       "   AND tc_bmd02 = '",g_tc_bmd02,"' ",                                  #20210607
       "   AND tc_bmd_file.tc_bmd04 = ima_file.ima01",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i605_prepare2 FROM g_sql      #預備一下
    DECLARE tc_bmd_cs CURSOR FOR i605_prepare2
    CALL g_tc_bmd.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH tc_bmd_cs INTO g_tc_bmd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tc_bmd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i605_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_bmd TO s_tc_bmd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                  

    
      ON ACTION page_list
         LET g_action_flag="page_list"
         EXIT DISPLAY

 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i605_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                  
 
 
      ON ACTION previous
         CALL i605_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                  
 
 
      ON ACTION jump
         CALL i605_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
 
 
      ON ACTION next
         CALL i605_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                 
 
 
      ON ACTION last
         CALL i605_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                  
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
     
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                   
         CALL cl_set_head_visible("","AUTO")      
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i605_copy()
DEFINE
    l_oldno1         LIKE tc_bmd_file.tc_bmd01,
    l_oldno2         LIKE tc_bmd_file.tc_bmd08,
    l_oldno3         LIKE tc_bmd_file.tc_bmd02,
    l_newno1         LIKE tc_bmd_file.tc_bmd01,
    l_newno2         LIKE tc_bmd_file.tc_bmd08,
    l_newno3         LIKE tc_bmd_file.tc_bmd02
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_tc_bmd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")          
    INPUT l_newno2  FROM tc_bmd08
 

        AFTER FIELD tc_bmd08
            IF cl_null(l_newno2) THEN
                NEXT FIELD tc_bmd08
            END IF

            #SELECT * FROM ima_file    #20241218 mark
            # WHERE ima01 = l_newno2   #20241218 mark
            SELECT * FROM occ_file     #20241218 modify
             WHERE occ01 = l_newno2    #20241218 modify

            IF SQLCA.sqlcode THEN
               #CALL cl_err3("sel","ima_file",l_newno2,"","mfg2729","","",1)  #20241218
                CALL cl_err3("sel","occ_file",l_newno2,"","alm1625","","",1)  #20241218
               NEXT FIELD tc_bmd08
            END IF
            SELECT count(*) INTO g_cnt FROM tc_bmd_file
             WHERE tc_bmd01 = g_tc_bmd01
               AND tc_bmd08 = l_newno2
               AND tc_bmd02 = g_tc_bmd02
                                                    
            IF g_cnt > 0 THEN
	        LET g_msg = g_tc_bmd01 CLIPPED,'+',l_newno2 CLIPPED
                CALL cl_err(g_msg,-239,0)
                NEXT FIELD tc_bmd08
            END IF
        ON ACTION CONTROLP
           CASE
                WHEN INFIELD(tc_bmd08)
                     #CALL q_sel_ima(FALSE, "q_ima", "", l_newno2, "", "", "", "" ,"",'' )  RETURNING l_newno2
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_occ'
                     LET g_qryparam.default1 = l_newno2
                     CALL cl_create_qry() RETURNING l_newno2
                     DISPLAY BY NAME l_newno2
                     NEXT FIELD tc_bmd08
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
    IF INT_FLAG OR l_newno2 IS NULL THEN
        LET INT_FLAG = 0
    	CALL i605_show()
        RETURN
    END IF
   DROP TABLE x 
    SELECT * FROM tc_bmd_file
        WHERE tc_bmd01=g_tc_bmd01
          AND tc_bmd08=g_tc_bmd08
          AND tc_bmd02=g_tc_bmd02                                          
        INTO TEMP x
    UPDATE x
        SET tc_bmd08=l_newno2
    INSERT INTO tc_bmd_file
        SELECT * FROM x
  
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err3("ins","tc_bmd_file",g_tc_bmd01,g_tc_bmd08,SQLCA.sqlcode,"","",1)  
    ELSE
        LET g_rec_b = sqlca.sqlerrd[3]            
        LET g_msg = g_tc_bmd01 CLIPPED, ' + ', l_newno2 CLIPPED
        MESSAGE 'ROW(',g_msg,') O.K'
        LET l_oldno2 = g_tc_bmd08
        LET g_tc_bmd08 = l_newno2
       
        IF g_chkey = 'Y' THEN CALL i605_u() END IF
        CALL i605_b()
        
    END IF
END FUNCTION
 

 
FUNCTION i605_chk_date_range(p_type)
  DEFINE l_tc_bmd05  LIKE tc_bmd_file.tc_bmd05,
         l_tc_bmd06  LIKE tc_bmd_file.tc_bmd06,
         l_sql    STRING,
         p_type   LIKE type_file.chr1
 
  LET g_errno = ''
  
 
  LET l_sql = "SELECT tc_bmd05,tc_bmd06 FROM tc_bmd_file ",
              " WHERE tc_bmd01 ='", g_tc_bmd01 CLIPPED ,"'",
              "   AND tc_bmd08 ='", g_tc_bmd08 CLIPPED ,"'",
              "   AND tc_bmd02 ='", g_tc_bmd02 CLIPPED ,"' ",  #20210607
              "   AND tc_bmd03 <>", g_tc_bmd[l_ac].tc_bmd03,
              "   AND tc_bmd04 ='", g_tc_bmd[l_ac].tc_bmd04 CLIPPED,"'",
              " ORDER BY tc_bmd03"
           
  PREPARE i605_pre_chk FROM l_sql      
  DECLARE tc_bmd_chk CURSOR FOR i605_pre_chk
  FOREACH tc_bmd_chk INTO l_tc_bmd05,l_tc_bmd06
    IF cl_null(l_tc_bmd05) THEN
       IF cl_null(l_tc_bmd06) THEN
         LET g_errno = 'abm-021'
         RETURN
       ELSE
         IF cl_null(g_tc_bmd[l_ac].tc_bmd04) OR g_tc_bmd[l_ac].tc_bmd04 < l_tc_bmd06 THEN
            LET g_errno = 'abm-021'
            RETURN
         END IF
       END IF
    END IF
    IF p_type = 'b' AND g_tc_bmd[l_ac].tc_bmd05 < l_tc_bmd05 AND cl_null(g_tc_bmd[l_ac].tc_bmd06) THEN RETURN END IF
    IF cl_null(l_tc_bmd06) THEN
       IF cl_null(g_tc_bmd[l_ac].tc_bmd06) THEN
          LET g_errno = 'abm-021'
          RETURN
       ELSE
          IF g_tc_bmd[l_ac].tc_bmd06 > l_tc_bmd05 THEN
             LET g_errno = 'abm-021'
             RETURN
          END IF
       END IF
    ELSE
       IF g_tc_bmd[l_ac].tc_bmd05 <= l_tc_bmd05 THEN 
         IF cl_null(g_tc_bmd[l_ac].tc_bmd06) THEN
           LET g_errno = 'abm-021'
           RETURN
         END IF
         IF g_tc_bmd[l_ac].tc_bmd06 > l_tc_bmd05 THEN
           LET g_errno = 'abm-021'
           RETURN
         END IF
       END IF
       IF g_tc_bmd[l_ac].tc_bmd05 > l_tc_bmd05 AND g_tc_bmd[l_ac].tc_bmd05 < l_tc_bmd06 THEN
           LET g_errno = 'abm-021'
           RETURN
       END IF 
    END IF
  END FOREACH
END FUNCTION
#No:FUN-9C0077




##--- 20190708 增加資料清單 (S)
FUNCTION i605_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_bmd_1 TO s_tc_bmd_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
      LET l_ac1 = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

     ON ACTION main
         LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i605_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         EXIT DISPLAY
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i605_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
  
      ON ACTION previous
         CALL i605_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i605_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i605_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i605_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

     
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         CALL i605_fetch('/')
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL ui.interface.refresh()
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
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i605_list_fill()
DEFINE l_cnt          LIKE type_file.num10
DEFINE l_tc_bmd01        LIKE tc_bmd_file.tc_bmd01
DEFINE l_tc_bmd08        LIKE tc_bmd_file.tc_bmd08
DEFINE l_tc_bmd02        LIKE tc_bmd_file.tc_bmd02

   CALL g_tc_bmd_1.clear()
   LET l_cnt = 1

   FOREACH i605_bcs INTO l_tc_bmd01,l_tc_bmd08,l_tc_bmd02     
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      SELECT tc_bmd01,tc_bmd04,a.ima02,a.ima021,a.ima25,a.ima08,tc_bmd02,tc_bmd08,occ02,tc_bmdnote
        INTO g_tc_bmd_1[l_cnt].*
        FROM tc_bmd_file LEFT JOIN ima_file a ON tc_bmd04 = a.ima01
                         LEFT JOIN occ_file ON tc_bmd08 = occ01
       WHERE tc_bmd01 = l_tc_bmd01
         AND tc_bmd08 = l_tc_bmd08
         AND tc_bmd02 = l_tc_bmd02
       LET l_cnt = l_cnt + 1
       IF l_cnt > g_max_rec THEN
       IF g_action_choice ="query"  THEN
            CALL cl_err( '', 9035, 0 )
          END IF
          EXIT FOREACH
       END IF
    END FOREACH
    OPEN i605_bcs                      #MOD-F80019 add
    LET g_rec_b1 = l_cnt - 1
    DISPLAY g_rec_b1 TO FORMONLY.cnt  #MOD-F80019 add
    DISPLAY ARRAY g_tc_bmd_1 TO s_tc_bmd_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
END FUNCTION
 
##--- 20190708 (E)

