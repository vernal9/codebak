# Prog. Version..: '5.30.24-17.04.13(00007)'     #
#
# Pattern name...: cxct001.4gl
# Descriptions...: 標準成本設定維護作業
# Date & Author..: 24110053 by momo

 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
    g_tc_stx02         LIKE tc_stx_file.tc_stx01,      #年度 (假單頭)  
    g_tc_stx02_t       LIKE tc_stx_file.tc_stx01,      #    
    g_tc_stx03         LIKE tc_stx_file.tc_stx01,      #月份 (假單頭)
    g_tc_stx03_t       LIKE tc_stx_file.tc_stx01,      #    
    g_tc_stx05         LIKE tc_stx_file.tc_stx05,      #成本設定基準
    g_tc_stx06         LIKE tc_stx_file.tc_stx06,      #權重
    g_ccc02            LIKE type_file.chr4,            #實際成本年
    g_ccc03            LIKE type_file.chr2,            #實際成本月
    ima06_a            LIKE ima_file.ima06,
    ima01_a            LIKE ima_file.ima01,
    g_cnt1             LIKE type_file.num5,      
    l_cmd              LIKE type_file.chr1000,  
    g_tc_stx           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                    tc_stx01   LIKE tc_stx_file.tc_stx01, 
                    ima02      LIKE ima_file.ima02,
                    ima021     LIKE ima_file.ima021, 
                    ima25      LIKE ima_file.ima25, 
                    ima44      LIKE ima_file.ima44, 
                    ima44_fac  LIKE ima_file.ima44_fac, 
                    tc_stx04   LIKE tc_stx_file.tc_stx04, 
                    price      LIKE tc_stx_file.tc_stx04, 
                    tc_stx05   LIKE tc_stx_file.tc_stx05,
                    tc_stx06   LIKE tc_stx_file.tc_stx06,
                    tc_stxuser LIKE tc_stx_file.tc_stxuser,
                    tc_stxdate LIKE tc_stx_file.tc_stxdate                  
                    END RECORD,
    g_tc_stx_t         RECORD                    #程式變數 (舊值)
                    tc_stx01   LIKE tc_stx_file.tc_stx01, 
                    ima02      LIKE ima_file.ima02,
                    ima021     LIKE ima_file.ima021, 
                    ima25      LIKE ima_file.ima25, 
                    ima44      LIKE ima_file.ima44, 
                    ima44_fac  LIKE ima_file.ima44_fac, 
                    tc_stx04   LIKE tc_stx_file.tc_stx04, 
                    price      LIKE tc_stx_file.tc_stx04, 
                    tc_stx05   LIKE tc_stx_file.tc_stx05,
                    tc_stx06   LIKE tc_stx_file.tc_stx06,
                    tc_stxuser LIKE tc_stx_file.tc_stxuser,
                    tc_stxdate LIKE tc_stx_file.tc_stxdate                 
                    END RECORD,
    g_tc_stx_l      DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                    tc_stx01    LIKE tc_stx_file.tc_stx01, 
                    ima02      LIKE ima_file.ima02,
                    ima021     LIKE ima_file.ima021, 
                    tc_stx02    LIKE tc_stx_file.tc_stx02, 
                    tc_stx04_1  LIKE tc_stx_file.tc_stx04, 
                    tc_stx04_2  LIKE tc_stx_file.tc_stx04, 
                    tc_stx04_3  LIKE tc_stx_file.tc_stx04, 
                    tc_stx04_4  LIKE tc_stx_file.tc_stx04,
                    tc_stx04_5  LIKE tc_stx_file.tc_stx04,
                    tc_stx04_6  LIKE tc_stx_file.tc_stx04,
                    tc_stx04_7  LIKE tc_stx_file.tc_stx04,
                    tc_stx04_8  LIKE tc_stx_file.tc_stx04,
                    tc_stx04_9  LIKE tc_stx_file.tc_stx04,
                    tc_stx04_10 LIKE tc_stx_file.tc_stx04,
                    tc_stx04_11 LIKE tc_stx_file.tc_stx04,
                    tc_stx04_12 LIKE tc_stx_file.tc_stx04              
                    END RECORD,
    g_wc,g_sql    string,  #No.FUN-580092 HCN
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數 
    g_rec_b         LIKE type_file.num5,   #單身筆數       
    g_rec_b2        LIKE type_file.num5,   #單身筆數       
    l_za05          LIKE type_file.chr1000,
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  
    l_ac1           LIKE type_file.num5,   #目前處理的ARRAY CNT  
    l_sl            LIKE type_file.num5    #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING 
DEFINE g_before_input_done  LIKE type_file.num5         
DEFINE   g_cnt            LIKE type_file.num10         #
DEFINE   g_i              LIKE type_file.num5          #count/index for any purpose    
DEFINE   g_msg            LIKE ze_file.ze03            #
DEFINE   g_row_count      LIKE type_file.num10         
DEFINE   g_curs_index     LIKE type_file.num10         
DEFINE   g_jump           LIKE type_file.num10         
DEFINE   g_no_ask         LIKE type_file.num5         
DEFINE   g_flag           LIKE type_file.chr1         
DEFINE w                  ui.Window
DEFINE f                  ui.Form
DEFINE page   om.DomNode
DEFINE l_node om.DomNode
DEFINE g_action_flag STRING
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_tc_stx02   = NULL                   #清除鍵值
   LET g_tc_stx02_t = NULL

   OPEN WINDOW t001_w WITH FORM "cxc/42f/cxct001"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()

   CALL t001_menu()
   CLOSE WINDOW t001_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t001_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_tc_stx.clear()
   INITIALIZE g_tc_stx02 TO NULL    
   INITIALIZE g_tc_stx03 TO NULL  
   INITIALIZE ima06_a TO NULL  
   INITIALIZE ima01_a TO NULL  

  
   CONSTRUCT g_wc ON tc_stx02,tc_stx03,ima06,ima01 #螢幕上取條件 
        FROM tc_stx02,tc_stx03,ima06_a,ima01_a

        BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(ima06_a) #
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_imz"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima06_a
                   NEXT FIELD ima06_a
             WHEN INFIELD(ima01_a) #
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_ima"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima01_a
                   NEXT FIELD ima01_a
             OTHERWISE EXIT CASE
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 
   IF INT_FLAG THEN RETURN END IF
 
    LET g_sql="SELECT UNIQUE tc_stx02,tc_stx03 ",        
              " FROM tc_stx_file,ima_file      ",              # 組合出 SQL 指令
              " WHERE tc_stx01=ima01 AND ", g_wc CLIPPED,      
              " ORDER BY 1,2"
   PREPARE t001_prepare FROM g_sql      #預備一下
   DECLARE t001_bcs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t001_prepare
 
   LET g_sql="SELECT COUNT(*) ",        
             "  FROM tc_stx_file,ima_file ",                   
             " WHERE tc_stx01=ima01 AND ", g_wc CLIPPED     
 
   PREPARE t001_precount FROM g_sql
   DECLARE t001_count CURSOR FOR t001_precount
 
END FUNCTION
 
FUNCTION t001_menu()
   WHILE TRUE
      #CALL t001_bp("G")
      CASE
          WHEN (g_action_flag IS NULL) OR (g_action_flag="main") 
            CALL t001_bp("G")
          WHEN (g_action_flag="page_list")
            CALL t001_b1_fill(g_wc) 
            CALL t001_bp1("G")
      END CASE
      CASE g_action_choice
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL t001_q()
            END IF
           WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t001_a()
            END IF
           WHEN "detail" 
            IF cl_chk_act_auth() THEN 
                CALL t001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
           WHEN "maintain_item_unit_conversion" 
            IF cl_chk_act_auth() THEN 
               LET g_action_choice="maintain_item_unit_conversion"
               LET l_cmd = "aooi103 '",g_tc_stx[l_ac].tc_stx01,"'" CLIPPED
               CALL cl_cmdrun(l_cmd CLIPPED)
            ELSE
               LET g_action_choice = NULL
            END IF
 
           WHEN "next" 
            CALL t001_fetch('N')
           WHEN "previous" 
            CALL t001_fetch('P')
           WHEN "delete" 
            IF cl_chk_act_auth() THEN
                CALL t001_r()
            END IF
           WHEN "help" 
            CALL cl_show_help()
           WHEN "exit"
            EXIT WHILE
           WHEN "jump"
            CALL t001_fetch('/')
           WHEN "controlg"     
            CALL cl_cmdask()
           WHEN "exporttoexcel"   #FUN-4B0025
            IF cl_chk_act_auth() THEN
               LET w=ui.Window.getCurrent()
               LET f=w.getForm()
               LET l_node=f.findNode("Table","s_tc_stx")
               CASE
                 WHEN (g_action_flag IS NULL) OR (g_action_flag='main')
                   CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_stx),'','') 
                 WHEN (g_action_flag='page_list')
                   LET page = f.FindNode("Page","page_list")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_stx_l),'','') 
                 END CASE
               LET g_action_choice = NULL
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t001_a()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_stx.clear()
   LET g_wc=NULL
   LET g_tc_stx02_t = NULL
   LET g_tc_stx03_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t001_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
      CALL t001_b()                      #輸入單身
      LET g_tc_stx02_t = g_tc_stx02            #保留舊值
      LET g_tc_stx03_t = g_tc_stx03            #保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION
   
FUNCTION t001_u()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_tc_stx02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tc_stx02_t = g_tc_stx02
   WHILE TRUE
      CALL t001_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET g_tc_stx02=g_tc_stx02_t
         LET g_tc_stx03=g_tc_stx03_t
         DISPLAY g_tc_stx02 TO tc_stx02 #單頭
         DISPLAY g_tc_stx03 TO tc_stx03 #單頭
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_tc_stx02 != g_tc_stx02_t OR g_tc_stx03 != g_tc_stx03_t THEN
         UPDATE tc_stx_file SET tc_stx02 = g_tc_stx02                   #更新DB
          WHERE tc_stx02 = g_tc_stx02_t                                 #COLAUTH?
         IF SQLCA.sqlcode THEN
            LET g_msg = g_tc_stx02 CLIPPED CLIPPED
            CALL cl_err3("upd","tc_stx_file",g_tc_stx02_t,'',
                          SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
         END IF
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION t001_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        
    l_cnt    LIKE type_file.num10           #No.FUN-680136 INTEGER
 
    LET g_tc_stx06 = 1
    LET g_tc_stx02 = YEAR(g_today)
    LET g_tc_stx03 = MONTH(g_today)-1
    CALL cl_set_comp_visible("ccc02,ccc03",FALSE)

    INPUT g_tc_stx02,g_tc_stx03,g_tc_stx05,g_tc_stx06,g_ccc02,g_ccc03 WITHOUT DEFAULTS  
           FROM tc_stx02,tc_stx03,tc_stx05_a,tc_stx06_a,ccc02,ccc03

       BEFORE FIELD tc_stx03
          LET g_tc_stx03 = MONTH(g_today)-1


       AFTER FIELD tc_stx06_a
          IF cl_null(g_tc_stx06) THEN
             LET g_tc_stx06 = 1
          END IF

       AFTER FIELD tc_stx05_a
           IF cl_null(g_tc_stx05) THEN
              LET g_tc_stx05 = '4'
           END IF
           IF g_tc_stx05 = '4' THEN
              CALL cl_set_comp_entry("tc_stx06_a",FALSE)
           ELSE
              CALL cl_set_comp_entry("tc_stx06_a",TRUE)
           END IF
           IF g_tc_stx05 = '2' THEN
              CALL cl_set_comp_visible("ccc02,ccc03",TRUE)
           END IF

        AFTER FIELD ccc02
          IF cl_null(g_ccc02) THEN
             NEXT FIELD ccc02
          END IF
             
        AFTER FIELD ccc03
          IF cl_null(g_ccc03) THEN
             NEXT FIELD ccc03
          END IF

        ON ACTION CONTROLP                  
           CASE
              WHEN INFIELD(tc_stx02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc" 
                 LET g_qryparam.default1 = g_tc_stx02
                 CALL cl_create_qry() RETURNING g_tc_stx02
                 DISPLAY BY NAME g_tc_stx02
                 NEXT FIELD tc_stx02
              OTHERWISE         
           END CASE

        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
    END INPUT
    IF g_tc_stx05 < '4' THEN
       CALL t001_result()
    ELSE
       CALL t001_b()
    END IF
END FUNCTION
 
FUNCTION t001_q()
 
  DEFINE l_tc_stx02  LIKE tc_stx_file.tc_stx02,
         l_cnt       LIKE type_file.num10         
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_tc_stx02 TO NULL                 
   INITIALIZE g_tc_stx03 TO NULL                 
   CALL cl_opmsg('q')
   MESSAGE ""
   CALL t001_cs()                            #取得查詢條件
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_tc_stx02 TO NULL
      RETURN
   END IF
   OPEN t001_count
   FETCH t001_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t001_bcs
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_stx02 TO NULL
   ELSE
      CALL t001_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION t001_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t001_bcs INTO g_tc_stx02,g_tc_stx03
        WHEN 'P' FETCH PREVIOUS t001_bcs INTO g_tc_stx02,g_tc_stx03
        WHEN 'F' FETCH FIRST    t001_bcs INTO g_tc_stx02,g_tc_stx03
        WHEN 'L' FETCH LAST     t001_bcs INTO g_tc_stx02,g_tc_stx03
        WHEN '/' 
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
                
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump t001_bcs INTO g_tc_stx02,g_tc_stx03
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_tc_stx02,SQLCA.sqlcode,0)
       INITIALIZE g_tc_stx02 TO NULL  
       INITIALIZE g_tc_stx03 TO NULL  
    ELSE
       OPEN t001_count
       FETCH t001_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL t001_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
FUNCTION t001_show()
    DISPLAY g_tc_stx02 TO FORMONLY.tc_stx02  
    DISPLAY g_tc_stx03 TO FORMONLY.tc_stx03  
    CALL t001_b_fill(g_wc)                 #單身
    CALL t001_b1_fill(g_wc) 
    CALL cl_show_fld_cont()                
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t001_r()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_tc_stx02 IS NULL THEN
      CALL cl_err("",-400,0)                
      RETURN
   END IF
   IF NOT cl_null(g_wc) THEN
   IF cl_delh(0,0) THEN                   #確認一下
      LET g_sql = "DELETE FROM tc_stx_file ",
                  " WHERE tc_stx02 = '",g_tc_stx02,"' ",
                  "   AND tc_stx03 = '",g_tc_stx03,"' ",
                  "   AND EXISTS (SELECT 1 FROM ima_file WHERE tc_stx01=ima01 AND " ,g_wc CLIPPED ,
                  " )"

      PREPARE t001_del FROM g_sql
      EXECUTE t001_del 
      FREE t001_del
    ELSE
      DELETE FROM tc_stx_file WHERE tc_stx02 = g_tc_stx02 AND tc_stx03=g_tc_stx03
    END IF

      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","tc_stx_file",g_tc_stx02,g_tc_stx03,SQLCA.sqlcode,
                      "","BODY DELETE",1)  
      ELSE
         CLEAR FORM
         CALL g_tc_stx.clear()
         LET g_delete='Y'
         LET g_tc_stx02 = NULL
         LET g_tc_stx03 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         DROP TABLE x
         PREPARE t001_precount_x2 FROM g_sql_tmp  
         EXECUTE t001_precount_x2                 
         OPEN t001_count
         IF STATUS THEN
            CLOSE t001_bcs
            CLOSE t001_count
            COMMIT WORK
            RETURN
         END IF
         FETCH t001_count INTO g_row_count
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t001_bcs
            CLOSE t001_count
            COMMIT WORK
            RETURN
         END IF
         OPEN t001_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t001_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t001_fetch('/')
         END IF
      END IF
   END IF
END FUNCTION
 
#單身
FUNCTION t001_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,                #檢查重複用        
    l_str           LIKE type_file.chr20,               #
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       
    p_cmd           LIKE type_file.chr1,                #處理狀態         
    l_allow_insert  LIKE type_file.num5,                #可新增否         
    l_allow_delete  LIKE type_file.num5,                #可刪除否          
    l_cnt           LIKE type_file.num10          
 
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_tc_stx02 IS NULL THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_stx01,ima02,ima021,ima25,ima44,ima44_fac,tc_stx04,tc_stx04*ima44_fac,",
                       "       tc_stx05,tc_stx06,tc_stxuser,tc_stxdate",  
                       "  FROM tc_stx_file,ima_file ",                  
                       "  WHERE tc_stx02=? AND tc_stx03=? ",
                       "    AND tc_stx01=? ",
                       "    AND tc_stx01=ima01 ",                   
                       "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t001_bcl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tc_stx WITHOUT DEFAULTS FROM s_tc_stx.* 
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
              BEGIN WORK
              LET p_cmd='u'
              LET g_tc_stx_t.* = g_tc_stx[l_ac].*      #BACKUP
              OPEN t001_bcl USING g_tc_stx02,g_tc_stx03,g_tc_stx_t.tc_stx01
              FETCH t001_bcl INTO g_tc_stx[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_tc_stx_t.tc_stx01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              ELSE
              END IF
              LET g_tc_stx_t.* = g_tc_stx[l_ac].*      #BACKUP
              CALL cl_show_fld_cont()     
           END IF
 
        AFTER FIELD tc_stx01
            IF NOT cl_null(g_tc_stx[l_ac].tc_stx01) THEN
               SELECT ima02,ima021 INTO g_tc_stx[l_ac].ima02,g_tc_stx[l_ac].ima021
                 FROM ima_file
                WHERE ima01 = g_tc_stx[l_ac].tc_stx01
                  AND imaacti='Y' AND ima140='N'
                  AND NOT EXISTS (SELECT 1 FROM tc_stx_file WHERE tc_stx01=ima01 AND tc_stx02=g_tc_stx02 AND tc_stx03=g_tc_stx03)
                 
               DISPLAY BY NAME g_tc_stx[l_ac].ima02,g_tc_stx[l_ac].ima021
               IF cl_null(g_tc_stx[l_ac].ima02) THEN
                  CALL cl_err('','aic-036',1)
                  NEXT FIELD tc_stx01
               END IF
            END IF

        AFTER FIELD tc_stx04
           LET g_tc_stx[l_ac].price = g_tc_stx[l_ac].tc_stx04*g_tc_stx[l_ac].ima44_fac
           DISPLAY BY NAME g_tc_stx[l_ac].price

        AFTER FIELD tc_stx06
           IF cl_null(g_tc_stx[l_ac].tc_stx06) THEN
              LET g_tc_stx[l_ac].tc_stx06 = 1
           END IF
  
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_stx[l_ac].* TO NULL      
           LET g_tc_stx_t.* = g_tc_stx[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     
           NEXT FIELD tc_stx01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           IF cl_null(g_tc_stx[l_ac].tc_stx05) THEN 
              LET g_tc_stx[l_ac].tc_stx05 = '4'
           END IF

           INSERT INTO tc_stx_file(tc_stx01,tc_stx02,tc_stx03,tc_stx04,tc_stx05,tc_stx06,tc_stxuser,tc_stxdate)
           VALUES(g_tc_stx[l_ac].tc_stx01,g_tc_stx02,g_tc_stx03,g_tc_stx[l_ac].tc_stx04,
                  g_tc_stx[l_ac].tc_stx05,g_tc_stx[l_ac].tc_stx06,g_user,g_today)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_stx_file",g_tc_stx[l_ac].tc_stx01,"",
                            SQLCA.sqlcode,"","",1)  #No.FUN-660129
              LET g_tc_stx[l_ac].* = g_tc_stx_t.*
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              COMMIT WORK
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_tc_stx[l_ac].tc_stx01 IS NOT NULL AND g_tc_stx_t.tc_stx01 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM tc_stx_file
               WHERE tc_stx02 = g_tc_stx02
                 AND tc_stx03 = g_tc_stx03
                 AND tc_stx01 = g_tc_stx[l_ac].tc_stx01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_stx_file",g_tc_stx[l_ac].tc_stx01,"",
                               SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE 
              END IF
              COMMIT WORK
              LET g_rec_b=g_rec_b-1
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tc_stx[l_ac].* = g_tc_stx_t.*
              CLOSE t001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_stx[l_ac].tc_stx01,-263,1)
              LET g_tc_stx[l_ac].* = g_tc_stx_t.*
           ELSE
              UPDATE tc_stx_file SET tc_stx04=g_tc_stx[l_ac].tc_stx04,
                                     tc_stx06=g_tc_stx[l_ac].tc_stx06,
                                     tc_stx05 = '4',
                                     tc_stxuser=g_user,
                                     tc_stxdate=g_today
               WHERE tc_stx02=g_tc_stx02
                 AND tc_stx03=g_tc_stx03
                 AND tc_stx01=g_tc_stx[l_ac].tc_stx01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","tc_stx_file",g_tc_stx[l_ac].tc_stx01,"",
                               SQLCA.sqlcode,"","",1)  
                 LET g_tc_stx[l_ac].* = g_tc_stx_t.*
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
              IF p_cmd = 'u' THEN 
                 LET g_tc_stx[l_ac].* = g_tc_stx_t.*
              ELSE
                 CALL g_tc_stx.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              END IF 
              CLOSE t001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  
           CLOSE t001_bcl
           COMMIT WORK
 
        ON ACTION CONTROLP                  
           CASE
              WHEN INFIELD(tc_stx01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ima" 
                 LET g_qryparam.default1 = g_tc_stx[l_ac].tc_stx01
                 CALL cl_create_qry() RETURNING g_tc_stx[l_ac].tc_stx01
                 DISPLAY BY NAME g_tc_stx[l_ac].tc_stx01
                 NEXT FIELD tc_stx01
              OTHERWISE         
           END CASE
         
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tc_stx03) AND l_ac > 1 THEN
              LET g_tc_stx[l_ac].* = g_tc_stx[l_ac-1].*
              NEXT FIELD tc_stx03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about      
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help()  
 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")      
    
    END INPUT
 
    CLOSE t001_bcl
        COMMIT WORK
 
END FUNCTION
 
FUNCTION t001_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       
 
    LET g_sql = "SELECT tc_stx01,ima02,ima021,ima25,ima44,ima44_fac,tc_stx04,tc_stx04*ima44_fac,",
                "       tc_stx05,tc_stx06,tc_stxuser,tc_stxdate ",  
                "  FROM tc_stx_file,ima_file ",   
                " WHERE tc_stx02 = '",g_tc_stx02,"'",
                "   AND tc_stx03 = '",g_tc_stx03,"'", 
                "   AND ima01=tc_stx01 ",          
                "   AND ",p_wc CLIPPED ,
                " ORDER BY 1"
    PREPARE t001_prepare2 FROM g_sql      #預備一下
    DECLARE tc_stx_cs CURSOR FOR t001_prepare2
 
    CALL g_tc_stx.clear()  
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH tc_stx_cs INTO g_tc_stx[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_tc_stx.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1               
    LET g_cnt = 0
   
END FUNCTION
 
FUNCTION t001_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1       
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_tc_stx TO s_tc_stx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  
         LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first 
         CALL t001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                  
                              
      ON ACTION previous
         CALL t001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
                              
      ON ACTION jump 
         CALL t001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                 
                              
      ON ACTION next
         CALL t001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY             
                              
      ON ACTION last 
         CALL t001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY   

      ON ACTION page_list
         LET g_action_flag="page_list" 
         EXIT DISPLAY

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY         
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION maintain_item_unit_conversion
         LET g_action_choice="maintain_item_unit_conversion"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
         LET INT_FLAG=FALSE 			
         LET g_action_choice="exit"
         EXIT DISPLAY
    
      ON ACTION exporttoexcel    
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY   
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
       ON IDLE g_idle_seconds
       CALL cl_on_idle  ()
       CONTINUE DISPLAY
 
      ON ACTION controls                                
         CALL cl_set_head_visible("","AUTO")       
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t001_result()
  DEFINE tm RECORD
         wc       LIKE type_file.chr1000, 
         ima01    LIKE ima_file.ima01 
         END RECORD 
  DEFINE g_tc_stx    RECORD LIKE tc_stx_file.*
  DEFINE l_cnt    LIKE type_file.num10
  DEFINE l_cnt1   LIKE type_file.num10
  DEFINE l_cnt2   LIKE type_file.num10
  DEFINE l_sql    STRING
  DEFINE l_price  LIKE tc_stx_file.tc_stx04
  DEFINE l_yy     LIKE type_file.chr4
  DEFINE l_mm     LIKE type_file.chr2
 
   LET g_success = 'Y'
 
   BEGIN WORK
 
   CONSTRUCT tm.wc ON ima06,ima01 #螢幕上取條件
           FROM ima06_a,ima01_a
 
           BEFORE CONSTRUCT
              CALL cl_qbe_init()

      AFTER FIELD ima06_a
         IF cl_null(GET_FLDBUF(ima06_a)) THEN
            NEXT FIELD ima01_a
         END IF
 
      AFTER FIELD ima01_a
         IF cl_null(GET_FLDBUF(ima01_a)) AND cl_null(GET_FLDBUF(ima06_a)) THEN
            NEXT FIELD ima06_a
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(ima01_a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ima" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima01_a  
                 NEXT FIELD ima01_a
            WHEN INFIELD(ima06_a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_imz" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima06_a
                 NEXT FIELD ima06_a
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
 
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      ROLLBACK WORK       
      CLOSE WINDOW t0011_w
      CALL t001_show()
      RETURN
   END IF
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      ROLLBACK WORK      
      CLOSE WINDOW t0011_w
      CALL t001_show()
      RETURN
   END IF
 
   BEGIN WORK

   ##--最近採購價
　 IF g_tc_stx05 = '1' THEN
      LET l_sql = "SELECT distinct a.pmn04,a.pmn31/a.pmn09*pmm42 ",
                  "  FROM pmn_file a,pmm_file b,ima_file ",
                  " WHERE a.pmn04 = ima01 AND imaacti = 'Y' AND ima140='N' ",
                  "   AND a.pmn01 = b.pmm01 AND b.pmm18='Y' AND b.pmm02='REG' ",
                  "   AND b.pmm04 = (SELECT MAX(pmm04) FROM pmn_file a1,pmm_file b1 ",
                  "                   WHERE a1.pmn01=b1.pmm01 AND a1.pmn04=a.pmn04 ",
                  "                     AND b1.pmm18='Y' AND b1.pmm02='REG' AND a1.pmn31 > 0 )",
                  "   AND NOT EXISTS (SELECT 1 FROM tc_stx_file WHERE tc_stx01=a.pmn04 AND tc_stx02='",g_tc_stx02,"' AND tc_stx03='",g_tc_stx03,"')",
                  "   AND pmm04 >= sysdate-364 ",
                  "   AND ",tm.wc
   END IF

   #--最後一期　實際成本
   IF g_tc_stx05 = '2' THEN
      LET l_sql = "SELECT ccc01,ccc23 ",
                  "  FROM ima_file,ccc_file ",                           
                  " WHERE imaacti='Y' AND ima01=ccc01 ",
                  "   AND ccc02= '",g_ccc02,"' AND ccc03 = '",g_ccc03,"' ",
                  "   AND ccc23 > 0 ",
                  "   AND NOT EXISTS (SELECT 1 FROM tc_stx_file WHERE tc_stx01=ccc01 AND tc_stx02='",g_tc_stx02,"' AND tc_stx03='",g_tc_stx03,"'  )",
                  "   AND ima140='N' AND ",tm.wc 
   END IF

   #--最後一期　標準成本
   IF g_tc_stx05 = '3' THEN
      SELECT MAX(tc_stx02) INTO l_yy FROM tc_stx_file;
      SELECT MAX(tc_stx03) INTO l_mm FROM tc_stx_file WHERE tc_stx02=l_yy;
      LET l_sql = "SELECT a.tc_stx01,a.tc_stx04 ",
                  "  FROM ima_file,tc_stx_file a ",
                  " WHERE imaacti='Y' AND ima01=a.tc_stx01 ",
                  "   AND a.tc_stx02= '",l_yy,"' AND a.tc_stx03 = '",l_mm,"' ",
                  "   AND NOT EXISTS (SELECT 1 FROM tc_stx_file b WHERE a.tc_stx01=b.tc_stx01 AND b.tc_stx02='",g_tc_stx02,"' AND a.tc_stx03='",g_tc_stx03,"' )",
                  "   AND ima140='N' AND ",tm.wc
   END IF

   PREPARE t0011_pre FROM l_sql
   IF SQLCA.sqlcode THEN CALL cl_err('t0011_pre',STATUS,1) END IF
   DECLARE t0011_c CURSOR FOR t0011_pre
   IF SQLCA.sqlcode THEN CALL cl_err('t0011_exp_c',STATUS,1) END IF
      CALL s_showmsg_init()               
      LET l_cnt = 0 
      FOREACH t0011_c INTO g_tc_stx.tc_stx01,l_price
         IF SQLCA.SQLCODE THEN LET g_success = 'N' EXIT FOREACH END IF
       
            LET g_tc_stx.tc_stx04 = l_price * g_tc_stx06
         
            INSERT INTO tc_stx_file(tc_stx01,tc_stx02,tc_stx03,tc_stx04,tc_stx05,tc_stx06,tc_stxdate,tc_stxuser)
                 VALUES (g_tc_stx.tc_stx01,g_tc_stx02,g_tc_stx03,g_tc_stx.tc_stx04,
                         g_tc_stx05,g_tc_stx06,g_today,g_user)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","tc_stx_file",g_tc_stx.tc_stx01,g_tc_stx.tc_stx02,
                              SQLCA.sqlcode,"","",1)  
                LET g_success = 'N'
             ELSE
                LET l_cnt = l_cnt + 1 
                LET g_success = 'Y'
             END IF
     END FOREACH
     IF g_success = 'Y' THEN 
        IF l_cnt > 0 THEN
           CALL cl_err('','apm-144',0)
        ELSE
           CALL cl_err('','apm-145',0)
        END IF
        COMMIT WORK 
     ELSE 
        CALL cl_err('','apm-146',0)
        ROLLBACK WORK 
     END IF
     CALL t001_b_fill(tm.wc)
     CLOSE WINDOW t0011_w
 
END FUNCTION

FUNCTION t001_bp1(p_ud)
    DEFINE p_ud            LIKE type_file.chr1       
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_tc_stx_l TO s_tc_stx_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()                  
         LET l_sl = SCR_LINE()
      
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
         LET INT_FLAG=FALSE 			
         LET g_action_choice="exit"
         EXIT DISPLAY
    
      ON ACTION exporttoexcel    
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY   

      ON ACTION main
         LET g_action_flag = 'main'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
       ON IDLE g_idle_seconds
       CALL cl_on_idle  ()
       CONTINUE DISPLAY
 
      ON ACTION controls                                
         CALL cl_set_head_visible("","AUTO")       
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t001_b1_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       
 
    LET g_sql = "SELECT * FROM ",
                "  (SELECT tc_stx01,ima02,ima021,tc_stx02,tc_stx03,sum(tc_stx04) tc_stx04 ",
                "     FROM ima_file,tc_stx_file ",
                "    WHERE ima01 = tc_stx01",  
                "    GROUP BY tc_stx01,ima02,ima021,tc_stx02,tc_stx03) ",   
                "  pivot (sum(tc_stx04) for tc_stx03 in ('1' ,'2' ,'3' ,'4','5','6','7','8','9','10','11','12'))",
                "  LEFT JOIN ima_file ON ima01=tc_stx01 ",
                " WHERE tc_stx02 = '",g_tc_stx02,"'",
                "   AND ",p_wc CLIPPED ,
                " ORDER BY tc_stx02"
    PREPARE t001_prepare21 FROM g_sql      #預備一下
    DECLARE tc_stx_cs2 CURSOR FOR t001_prepare21
 
    CALL g_tc_stx_l.clear()  
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH tc_stx_cs2 INTO g_tc_stx_l[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_tc_stx_l.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1               
    LET g_cnt = 0
   
END FUNCTION 
