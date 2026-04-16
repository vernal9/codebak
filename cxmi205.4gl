# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cxmi205.4gl
# Descriptions...: 客戶地址/聯絡人
# Date & Author..: 18/03/21 By momo

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_occ           RECORD
                       occ01   LIKE occ_file.occ01,    #客戶編號
                       occ02   LIKE occ_file.occ02,    #簡稱
                       occ04   LIKE occ_file.occ04,    #負慣業務
                       occ55   LIKE occ_file.occ55,    #慣用語言
                       occacti LIKE occ_file.occacti   #資料有效值
                    END RECORD,
    g_occ_t         RECORD
                       occ01   LIKE occ_file.occ01,    #客戶編號
                       occ02   LIKE occ_file.occ02,    #簡稱
                       occ04   LIKE occ_file.occ04,    #負慣業務
                       occ55   LIKE occ_file.occ55,    #慣用語言
                       occacti LIKE occ_file.occacti   #資料有效值
                    END RECORD,
    g_occ01_t       LIKE occ_file.occ01,              #客戶編號  (舊值)
    g_ocd           DYNAMIC ARRAY OF RECORD           #程式變數(Program Variables)
        ocd02       LIKE ocd_file.ocd02,        #客戶地址
        ocd03       LIKE ocd_file.ocd03,        #說明
        ocd04       LIKE ocd_file.ocd04,        #郵遞區號
        ocd221      LIKE ocd_file.ocd221,       #地址-1
        ocd224      LIKE ocd_file.ocd224,       #電話-1
        ocd228      LIKE ocd_file.ocd228        #聯絡人-1
                    END RECORD,
    g_ocd_t      RECORD                            #程式變數 (舊值)
        ocd02       LIKE ocd_file.ocd02,        #客戶地址
        ocd03       LIKE ocd_file.ocd03,        #說明
        ocd04       LIKE ocd_file.ocd04,        #郵遞區號
        ocd221      LIKE ocd_file.ocd221,       #地址-1
        ocd224      LIKE ocd_file.ocd224,       #電話-1
        ocd228      LIKE ocd_file.ocd228        #聯絡人-1
                    END RECORD,
   g_oce           DYNAMIC ARRAY OF RECORD           #程式變數(Program Variables)
        oce02       LIKE oce_file.oce02,        #職務
        oce03       LIKE oce_file.oce03,        #聯絡人
        oce04       LIKE oce_file.oce04,        #TEL
        oce05       LIKE oce_file.oce05         #Email
                    END RECORD,
    g_oce_t      RECORD                            #程式變數 (舊值)
        oce02       LIKE oce_file.oce02,        #職務
        oce03       LIKE oce_file.oce03,        #聯絡人
        oce04       LIKE oce_file.oce04,        #TEL
        oce05       LIKE oce_file.oce05         #Email
                    END RECORD,                 
    g_wc,g_wc2,g_wc3,g_sql     STRING,                      
    g_argv1         LIKE occ_file.occ01,
    g_flag          LIKE type_file.chr1,              #No.FUN-680136 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,              #單身筆數                   #No.FUN-680136 SMALLINT
    g_rec_b2        LIKE type_file.num5,              #單身筆數                   #No.FUN-680136 SMALLINT
    l_ac,l_ac2      LIKE type_file.num5               #目前處理的ARRAY CNT        #No.FUN-680136 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5            #No.FUN-680136 SMALLINT 
 
#主程式開始
DEFINE g_forupd_sql     STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_forupd_sql2    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose #No.FUN-680136 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_argv1      = ARG_VAL(1)           #客戶編號
   LET g_occ.occ01  = g_argv1
 
   LET g_forupd_sql = "SELECT * FROM occ_file WHERE occ01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i205_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW i205_w WITH FORM "cxm/42f/cxmi205"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL g_ocd.clear()
 
   IF NOT cl_null(g_argv1) THEN
      CALL i205_q()
   END IF
   CALL cl_set_combo_lang("occ55")
   CALL i205_menu()
   CLOSE WINDOW i205_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i205_cs()
   DEFINE lc_qbe_sn  LIKE gbm_file.gbm01  
   DEFINE l_msg      LIKE ze_file.ze03      
 
   CLEAR FORM                             #清除畫面
   CALL g_ocd.clear()
 
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")       
  
   INITIALIZE g_occ.* TO NULL   
      CONSTRUCT BY NAME g_wc ON occ01,occ02,occ04,occ55
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION controlp
          CASE
           WHEN INFIELD(occ01) #客戶編號
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_occ"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO occ01
             NEXT FIELD occ01
           WHEN INFIELD(occ04) #SALES
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_gen"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO occ04
             NEXT FIELD occ04
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
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
      CONSTRUCT g_wc2 ON ocd02,ocd03,ocd04,ocd221,ocd224,ocd228 
           FROM s_ocd[1].ocd02,s_ocd[1].ocd03,s_ocd[1].ocd04,
                s_ocd[1].ocd221,s_ocd[1].ocd224,s_ocd[1].ocd228
	BEFORE CONSTRUCT
	   CALL cl_qbe_display_condition(lc_qbe_sn)

      ON ACTION controlp
        # CASE
        # WHEN INFIELD(ocd04) #工作站
        #      CALL cl_init_qry_var()
        #      LET g_qryparam.state = "c"
        #      LET g_qryparam.form ="q_eca1"
        #      CALL cl_create_qry() RETURNING g_qryparam.multiret
        #      DISPLAY g_qryparam.multiret TO ocd04
        #      NEXT FIELD ocd04
        # END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()   
 
      ON ACTION qbe_save
		 CALL cl_qbe_save()
      END CONSTRUCT
 
      IF INT_FLAG THEN
         RETURN
      END IF

      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
 
   ELSE
      SELECT occ01,occ02,occ04,occ55,occacti
        INTO g_occ.* 
        FROM occ_file 
      WHERE occ01 = g_occ.occ01
      UNION ALL
      SELECT ofd01,ofd02,ofd23,'',ofdacti
        INTO g_occ.*
        FROM ofd_file
       WHERE ofd01 = g_occ.occ01
 
      DISPLAY BY NAME g_occ.occ01     # 顯示單頭值
      DISPLAY BY NAME g_occ.occ02     # 顯示單頭值
      DISPLAY BY NAME g_occ.occ04     # 顯示單頭值
      DISPLAY BY NAME g_occ.occ55     # 顯示單頭值
 
      LET g_wc = " occ01 ='",g_occ.occ01,"'"
      LET g_wc2= " occ01 ='",g_occ.occ01,"'"
      LET g_wc3= " ofd01 ='",g_occ.occ01,"'"
   END IF
 
   LET g_wc3 = cl_replace_str(g_wc,"occ01","ofd01")

   IF g_wc2 = " 1=1" THEN         # 若單身未輸入條件
      LET g_sql = "SELECT occ01 FROM occ_file ",
                  " WHERE ", g_wc CLIPPED,
                  " UNION ALL ",
                  "SELECT ofd01 FROM ofd_file ",
                  " WHERE ", g_wc3 CLIPPED
                  
   ELSE               # 若單身有輸入條件
      LET g_sql = "SELECT occ01 ",
                  "  FROM occ_file, ocd_file ",
                  " WHERE occ01 = ocd01 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " UNION ALL ",
                  "SELECT ofd01",
                  "  FROM ofd_file, ocd_file ",
                  " WHERE ofd01 = ocd01 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED
   END IF
 
   PREPARE i205_prepare FROM g_sql
   DECLARE i205_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i205_prepare
 
   IF g_wc2 = " 1=1" THEN         # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM occ_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(distinct occ01) FROM occ_file,ocd_file WHERE ",
                "occ01=ocd01 ",
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i205_precount FROM g_sql
   DECLARE i205_count CURSOR FOR i205_precount
 
END FUNCTION
 
FUNCTION i205_menu()
 
   WHILE TRUE
      CALL i205_bp("G")
      #CALL i205_bp1("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i205_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i205_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i205_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "contact"
            IF cl_chk_act_auth() THEN
               CALL i205_b2()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i205_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ocd),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i205_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ocd.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i205_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_occ.* TO NULL
      RETURN
   END IF
 
   OPEN i205_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_occ.* TO NULL
   ELSE
      OPEN i205_count
      FETCH i205_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i205_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i205_fetch(p_flag)
DEFINE
       p_flag          LIKE type_file.chr1,        #處理方式    
       l_occuser       LIKE occ_file.occuser,      
       l_occgrup       LIKE occ_file.occgrup       
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i205_cs INTO g_occ.occ01
      WHEN 'P' FETCH PREVIOUS i205_cs INTO g_occ.occ01
      WHEN 'F' FETCH FIRST    i205_cs INTO g_occ.occ01
      WHEN 'L' FETCH LAST     i205_cs INTO g_occ.occ01
      WHEN '/'
            IF (NOT mi_no_ask) THEN
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
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i205_cs INTO g_occ.occ01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode AND cl_null(g_argv1) THEN
      LET g_msg=g_occ.occ01 CLIPPED,'+',g_occ.occ02 CLIPPED
      CALL cl_err(g_msg,SQLCA.sqlcode,0)
      INITIALIZE g_occ.* TO NULL               
      RETURN
   END IF
 
   IF cl_null(g_argv1) THEN
      SELECT occ01,occ02,occacti,occuser,occgrup  
        INTO g_occ.*,l_occuser,l_occgrup                
        FROM occ_file WHERE occ01 = g_occ.occ01
      UNION ALL
      SELECT ofd01,ofd02,ofdacti,ofduser,ofdgrup
        INTO g_occ.*,l_occuser,l_occgrup
        FROM ofd_file WHERE ofd01 = g_occ.occ01

      IF SQLCA.sqlcode THEN
         LET g_msg=g_occ.occ01 CLIPPED,'+',g_occ.occ02 CLIPPED
         CALL cl_err3("sel","occ_file","","",SQLCA.sqlcode,"","",1)  
         INITIALIZE g_occ.* TO NULL
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
      LET g_data_owner = l_occuser      
      LET g_data_group = l_occgrup      
      LET g_data_keyvalue = g_occ.occ01
  
   END IF
 
   CALL i205_show()
 
END FUNCTION

FUNCTION i205_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_occ.occ01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_occ_t.* = g_occ.*
    WHILE TRUE
        CALL i205_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_occ.occ01=g_occ_t.occ01
            LET g_occ.occ02=g_occ_t.occ02
            LET g_occ.occ04=g_occ_t.occ04
            LET g_occ.occ55=g_occ_t.occ55
            DISPLAY g_occ.occ01 TO occ01      #單頭
            DISPLAY g_occ.occ02 TO occ02      #單頭
            DISPLAY g_occ.occ04 TO occ04      #單頭
            DISPLAY g_occ.occ55 TO occ55     
 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_occ.occ04 != g_occ_t.occ04 OR g_occ.occ55 != g_occ_t.occ55 THEN #更改單頭值 
            UPDATE occ_file
               SET occ04 = g_occ.occ04,
                   occ55 = g_occ.occ55
             WHERE occ01 = g_occ_t.occ01          
            IF SQLCA.sqlcode THEN
	        LET g_msg = g_occ.occ01 CLIPPED
                CALL cl_err3("upd","occ_file",g_occ_t.occ01,'',SQLCA.sqlcode,"",g_msg,1) 
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION

#處理INPUT
FUNCTION i205_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改      
    l_cnt           LIKE type_file.num5,     
    l_gen02         LIKE gen_file.gen02,
    l_n             LIKE type_file.num5      
DEFINE  l_i         LIKE type_file.num5,     
        l_sum_bmd07 LIKE bmd_file.bmd07      
DEFINE  l_num       LIKE type_file.num5       
    CALL cl_set_head_visible("","YES")           
    INPUT g_occ.occ04, g_occ.occ55 WITHOUT DEFAULTS
     FROM occ04,occ55
 
        AFTER FIELD occ04
          IF NOT cl_null(g_occ.occ04) THEN
             SELECT gen02 INTO l_gen02 FROM gen_file
              WHERE gen01 = g_occ.occ04
                AND genacti='Y'
             IF cl_null(l_gen02) THEN
                NEXT FIELD occ04
             END IF
             DISPLAY l_gen02 TO gen02
          END IF

 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(occ04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.default1 = g_occ.occ04
                     CALL cl_create_qry() RETURNING g_occ.occ04
                     DISPLAY BY NAME g_occ.occ04
                     NEXT FIELD occ04
                OTHERWISE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
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
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i205_show()
  DEFINE l_msg   LIKE ze_file.ze03  
  DEFINE l_gen02 LIKE gen_file.gen02
 
   LET g_occ_t.* = g_occ.*           #保存單頭舊值
   LET g_data_keyvalue = g_occ.occ01 #No:FUN-F50016

  SELECT occ04,occ55,gen02
    INTO g_occ.occ04,g_occ.occ55,l_gen02
    FROM occ_file
    LEFT JOIN gen_file ON occ04=gen01
  WHERE occ01 = g_occ.occ01

   DISPLAY BY NAME   g_occ.occ01     # 顯示單頭值
   DISPLAY BY NAME   g_occ.occ02     # 顯示單頭值
   DISPLAY BY NAME   g_occ.occ04     # 顯示單頭值
   DISPLAY BY NAME   g_occ.occ55     # 顯示單頭值
   DISPLAY l_gen02 TO gen02
 
   CALL i205_b_fill(g_wc2)                 #單身
   CALL i205_b2_fill(g_wc2)                 #單身
  
   CALL cl_show_fld_cont()                #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i205_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
    l_n             LIKE type_file.num5,                #檢查重複用               
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否               
    p_cmd           LIKE type_file.chr1,                #處理狀態                 
    l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入   
    l_allow_insert  LIKE type_file.num5,                #可新增否                 
    l_allow_delete  LIKE type_file.num5                 #可刪除否                 
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF cl_null(g_occ.occ01) THEN
       RETURN
    END IF
 
    IF g_occ.occacti = 'N' THEN
       CALL  cl_err('','axm-189',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ocd02,ocd03,ocd04,ocd221,ocd224,ocd228 FROM ocd_file",
                       " WHERE ocd01=? AND ocd02=? AND ocd03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i205_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ocd WITHOUT DEFAULTS FROM s_ocd.*
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
 
           IF l_ac >= 1 AND l_n >= l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_ocd_t.* = g_ocd[l_ac].*  #BACKUP
 
              OPEN i205_bcl USING g_occ.occ01,g_ocd_t.ocd02,g_ocd_t.ocd03
              IF STATUS THEN
                 CALL cl_err("OPEN i205_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i205_bcl INTO g_ocd[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ocd_t.ocd03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont() 
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ocd[l_ac].* TO NULL      
           LET g_ocd_t.* = g_ocd[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()    
           NEXT FIELD ocd02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO ocd_file(ocd01,ocd02,ocd03,ocd04,ocd221,ocd224,ocd228)
                VALUES(g_occ.occ01,g_ocd[l_ac].ocd02,g_ocd[l_ac].ocd03,g_ocd[l_ac].ocd04,
                       g_ocd[l_ac].ocd221,g_ocd[l_ac].ocd224,g_ocd[l_ac].ocd228)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ocd_file",g_occ.occ01,g_ocd[l_ac].ocd02,SQLCA.sqlcode,"","",1) 
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_ocd[l_ac].ocd02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ocd_file
               WHERE ocd01 = g_occ.occ01
                 AND ocd02 = g_ocd[l_ac].ocd02
                 AND ocd03 = g_ocd[l_ac].ocd03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ocd_file",g_occ.occ01,g_ocd_t.ocd02,SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ocd[l_ac].* = g_ocd_t.*
              CLOSE i205_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ocd[l_ac].ocd03,-263,1)
              LET g_ocd[l_ac].* = g_ocd_t.*
           ELSE
              UPDATE ocd_file SET ocd02=g_ocd[l_ac].ocd02,
                                  ocd03=g_ocd[l_ac].ocd03,
                                  ocd04=g_ocd[l_ac].ocd04,
                                  ocd221=g_ocd[l_ac].ocd221,
                                  ocd224=g_ocd[l_ac].ocd224,
                                  ocd228=g_ocd[l_ac].ocd228
               WHERE ocd01=g_occ.occ01
                 AND ocd02=g_ocd_t.ocd02
                 AND ocd03=g_ocd_t.ocd03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ocd_file",g_occ.occ01,g_ocd_t.ocd02,SQLCA.sqlcode,"","",1) 
                 LET g_ocd[l_ac].* = g_ocd_t.*
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
                 LET g_ocd[l_ac].* = g_ocd_t.*
              ELSE
                 CALL g_ocd.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              END IF
              CLOSE i205_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac         
           CLOSE i205_bcl
           COMMIT WORK
       
        ON ACTION controlp
          # CASE

          # WHEN INFIELD(ocd04) #工作站別
          #   CALL cl_init_qry_var()
          #   LET g_qryparam.form ="q_eca1"
          #   LET g_qryparam.default1 = g_ocd[l_ac].ocd04
          #   CALL cl_create_qry() RETURNING g_ocd[l_ac].ocd04
          #   DISPLAY BY NAME g_ocd[l_ac].ocd04
          #   NEXT FIELD ocd04
          # END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(ocd03) AND l_ac > 1 THEN
              LET g_ocd[l_ac].* = g_ocd[l_ac-1].*
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
 
    CLOSE i205_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i205_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       
 
    CONSTRUCT l_wc2 ON ocd02,ocd04,ocd05,ocd05 
                  FROM s_ocd[1].ocd02,s_ocd[1].ocd04,s_ocd[1].ocd05,s_ocd[1].ocd06
              
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
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL i205_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i205_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           STRING,
   l_flag          LIKE type_file.chr1          
 
   LET g_sql = "SELECT ocd02,ocd03,ocd04,ocd221,ocd224,ocd228 ",
               " FROM ocd_file",
               " WHERE ocd01 ='",g_occ.occ01,"' AND ",  #單頭-1
               p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
   PREPARE i205_pb FROM g_sql
   DECLARE ocd_cs CURSOR FOR i205_pb
 
   CALL g_ocd.clear()
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH ocd_cs INTO g_ocd[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_ocd.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i205_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
  
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ocd TO s_ocd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
      LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i205_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL i205_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY              
 
 
      ON ACTION jump
         CALL i205_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY              
 
 
      ON ACTION next
         CALL i205_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY               
 
 
      ON ACTION last
         CALL i205_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                
 
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION contact
         LET g_action_choice="contact"
         LET l_ac2 = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                     
         CALL cl_set_head_visible("","AUTO")      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

FUNCTION i205_b2()
DEFINE
    l_ac_t2         LIKE type_file.num5,                #未取消的ARRAY CNT        
    l_n2            LIKE type_file.num5,                #檢查重複用               
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否               
    p_cmd           LIKE type_file.chr1,                #處理狀態                 
    l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入   
    l_allow_insert  LIKE type_file.num5,                #可新增否                 
    l_allow_delete  LIKE type_file.num5                 #可刪除否                 
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF cl_null(g_occ.occ01) THEN
       RETURN
    END IF
 
    IF g_occ.occacti = 'N' THEN
       CALL  cl_err('','axm-189',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql2 = "SELECT oce02,oce03,oce04,oce05 FROM oce_file",
                       " WHERE oce01=? AND oce03=? FOR UPDATE"
    LET g_forupd_sql2 = cl_forupd_sql(g_forupd_sql2)
    DECLARE i205_bcl2 CURSOR FROM g_forupd_sql2      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_oce WITHOUT DEFAULTS FROM s_oce.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac2)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac2 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n2  = ARR_COUNT()
 
           IF l_ac2 >= 1 AND l_n2>=l_ac2 THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_oce_t.* = g_oce[l_ac2].*  #BACKUP
 
              OPEN i205_bcl2 USING g_occ.occ01,g_oce_t.oce03
              IF STATUS THEN
                 CALL cl_err("OPEN i205_bcl2:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i205_bcl2 INTO g_oce[l_ac2].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_oce_t.oce03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont() 
           END IF
 
        BEFORE INSERT
           LET l_n2 = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_oce[l_ac2].* TO NULL      
           LET g_oce_t.* = g_oce[l_ac2].*         #新輸入資料
           CALL cl_show_fld_cont()    
           NEXT FIELD oce02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO oce_file(oce01,oce02,oce03,oce04,oce05)
                VALUES(g_occ.occ01,g_oce[l_ac2].oce02,g_oce[l_ac2].oce03,g_oce[l_ac2].oce04,
                       g_oce[l_ac2].oce05)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","oce_file",g_occ.occ01,g_oce[l_ac2].oce02,SQLCA.sqlcode,"","",1) 
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_oce[l_ac2].oce02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM oce_file
               WHERE oce01 = g_occ.occ01
                 AND oce03 = g_oce[l_ac2].oce03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","oce_file",g_occ.occ01,g_oce_t.oce03,SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_oce[l_ac2].* = g_oce_t.*
              CLOSE i205_bcl2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_oce[l_ac2].oce03,-263,1)
              LET g_oce[l_ac2].* = g_oce_t.*
           ELSE
              UPDATE oce_file SET oce02=g_oce[l_ac2].oce02,
                                  oce03=g_oce[l_ac2].oce03,
                                  oce04=g_oce[l_ac2].oce04,
                                  oce05=g_oce[l_ac2].oce05
               WHERE oce01=g_occ.occ01
                 AND oce03=g_oce_t.oce03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","oce_file",g_occ.occ01,g_oce_t.oce03,SQLCA.sqlcode,"","",1) 
                 LET g_oce[l_ac2].* = g_oce_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac2 = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_oce[l_ac2].* = g_oce_t.*
              ELSE
                 CALL g_oce.deleteElement(l_ac2)
                 IF g_rec_b2 != 0 THEN
                    LET g_action_choice = "contact"
                    LET l_ac2 = l_ac_t2
                 END IF
              END IF
              CLOSE i205_bcl2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t2 = l_ac2         
           CLOSE i205_bcl2
           COMMIT WORK
       
        ON ACTION controlp
          # CASE

          # WHEN INFIELD(ocd04) #工作站別
          #   CALL cl_init_qry_var()
          #   LET g_qryparam.form ="q_eca1"
          #   LET g_qryparam.default1 = g_ocd[l_ac].ocd04
          #   CALL cl_create_qry() RETURNING g_ocd[l_ac].ocd04
          #   DISPLAY BY NAME g_ocd[l_ac].ocd04
          #   NEXT FIELD ocd04
          # END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(oce03) AND l_ac2 > 1 THEN
              LET g_oce[l_ac2].* = g_oce[l_ac2-1].*
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
 
    CLOSE i205_bcl2
    COMMIT WORK
 
END FUNCTION

FUNCTION i205_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
  
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN
   #   RETURN
   #END IF
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oce TO s_oce.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
        IF cl_null(p_ud) THEN
           EXIT DISPLAY
        END IF
        # CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    #  BEFORE ROW
    #  LET l_ac = ARR_CURR()
    #  CALL cl_show_fld_cont()                   
 
    #  ON ACTION query
    #     LET g_action_choice="query"
    #     EXIT DISPLAY
    #  ON ACTION first
    #     CALL i205_fetch('F')
    #     CALL cl_navigator_setting(g_curs_index, g_row_count)   
    #       IF g_rec_b != 0 THEN
    #     CALL fgl_set_arr_curr(1)  
    #       END IF
    #       ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL i205_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY              
 
 
      ON ACTION jump
         CALL i205_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY              
 
 
      ON ACTION next
         CALL i205_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY               
 
 
      ON ACTION last
         CALL i205_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                
 
      ON ACTION contact
         LET g_action_choice="contact"
         LET l_ac2 = 1
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="contact"
         LET l_ac2 = ARR_CURR()
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
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                     
         CALL cl_set_head_visible("","AUTO")      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

FUNCTION i205_b2_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           STRING,
   l_flag          LIKE type_file.chr1          
 
   LET g_sql = "SELECT oce02,oce03,oce04,oce05 ",
               " FROM oce_file",
               " WHERE oce01 ='",g_occ.occ01,"' AND ",  #單頭-1
               p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
   PREPARE i205_pb2 FROM g_sql
   DECLARE oce_cs2 CURSOR FOR i205_pb2
 
   CALL g_oce.clear()
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH oce_cs2 INTO g_oce[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_oce.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
   CALL i205_bp1('') 
END FUNCTION
 
 
FUNCTION i205_out()
DEFINE
   l_i             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
   sr              RECORD
       occ01       LIKE occ_file.occ01,          #
       occ02       LIKE occ_file.occ02,
       ocd02    LIKE ocd_file.ocd02, 
       ocd04    LIKE ocd_file.ocd04,
       ocd221    LIKE ocd_file.ocd221,
       ocd224   LIKE ocd_file.ocd224  
                   END RECORD,
   l_name          LIKE type_file.chr20,         #External(Disk) file name #No.FUN-680136 VARCHAR(20)
   l_za05          LIKE za_file.za05             #No.FUN-680136 VARCHAR(40)
DEFINE l_cmd           LIKE type_file.chr1000         #No.FUN-820002
 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
 
#No.FUN-820002--start--
   IF cl_null(g_wc) AND NOT cl_null(g_occ.occ01) THEN                                                                               
      LET g_wc = " occ01 = '",g_occ.occ01,"' "                                                                                      
   END IF                                                                                                                           
   IF cl_null(g_wc2) THEN                                                                                                           
       LET g_wc2 = " 1=1"                                                                                                           
   END IF
 
   #報表轉為使用 p_query                                                                                                            
   LET l_cmd = 'p_query "cxmi205" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'                                                         
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN 
 

END FUNCTION
 
