# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cxmi202.4gl
# Descriptions...: 客戶重要備註維護作業
# Date & Author..: 18/03/21 By momo

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_occ           RECORD
                       occ01   LIKE occ_file.occ01,    #客戶編號
                       occ02   LIKE occ_file.occ02,    #簡稱
                       occacti LIKE occ_file.occacti   #資料有效值
                    END RECORD,
    g_occ_t         RECORD
                       occ01   LIKE occ_file.occ01,    #客戶編號
                       occ02   LIKE occ_file.occ02,    #簡稱
                       occacti LIKE occ_file.occacti   #資料有效值
                    END RECORD,
    g_occ01_t       LIKE occ_file.occ01,              #客戶編號  (舊值)
    g_tc_oao           DYNAMIC ARRAY OF RECORD           #程式變數(Program Variables)
        tc_oao02       LIKE tc_oao_file.tc_oao02,        #屬性
        tc_oao03       LIKE tc_oao_file.tc_oao03,        #行序
        tc_oao04       LIKE tc_oao_file.tc_oao04,        #工作中心代號
        eca02          LIKE eca_file.eca02,              #工作中心說明
        tc_oao05       LIKE tc_oao_file.tc_oao05,        #重要備註
        tc_oao06       LIKE tc_oao_file.tc_oao06         #有效期限
                    END RECORD,
    g_tc_oao_t      RECORD                            #程式變數 (舊值)
        tc_oao02       LIKE tc_oao_file.tc_oao02,        #屬性
        tc_oao03       LIKE tc_oao_file.tc_oao03,        #行序
        tc_oao04       LIKE tc_oao_file.tc_oao04,        #工作中心代號
        eca02          LIKE eca_file.eca02,              #工作中心說明
        tc_oao05       LIKE tc_oao_file.tc_oao05,        #重要備註
        tc_oao06       LIKE tc_oao_file.tc_oao06         #有效期限
                    END RECORD,
    g_wc,g_wc2,g_sql     STRING,                      #NO.TQC-630166 
    g_argv1         LIKE occ_file.occ01,
    g_flag          LIKE type_file.chr1,              #No.FUN-680136 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,              #單身筆數                   #No.FUN-680136 SMALLINT
    l_ac            LIKE type_file.num5               #目前處理的ARRAY CNT        #No.FUN-680136 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5            #No.FUN-680136 SMALLINT 
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
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
   DECLARE i202_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW i202_w WITH FORM "cxm/42f/cxmi202"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL g_tc_oao.clear()
 
   IF NOT cl_null(g_argv1) THEN
      CALL i202_q()
   END IF
 
   CALL i202_menu()
   CLOSE WINDOW i202_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i202_cs()
   DEFINE lc_qbe_sn  LIKE    gbm_file.gbm01  #No.FUN-580031  HCN
   DEFINE l_msg      LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(20)
 
   CLEAR FORM                             #清除畫面
   CALL g_tc_oao.clear()
 
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_occ.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON occ01,occ02
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       ON ACTION controlp
          CASE
           WHEN INFIELD(occ01) #客戶編號
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_occ"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO occ01
             NEXT FIELD occ01
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
      CONSTRUCT g_wc2 ON tc_oao02,tc_oao04,tc_oao05,tc_oao06 
           FROM s_tc_oao[1].tc_oao02,s_tc_oao[1].tc_oao04,s_tc_oao[1].tc_oao05,s_tc_oao[1].tc_oao06
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)

      ON ACTION controlp
         CASE
         WHEN INFIELD(tc_oao04) #工作站
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_eca1"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_oao04
              NEXT FIELD tc_oao04
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
      ON ACTION qbe_save
		 CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
      END CONSTRUCT
 
      IF INT_FLAG THEN
         RETURN
      END IF

      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
      #End:FUN-980030
 
 
   ELSE
      SELECT occ01,occ02,occacti
        INTO g_occ.* FROM occ_file WHERE occ01 = g_occ.occ01
 
      DISPLAY BY NAME g_occ.occ01     # 顯示單頭值
      DISPLAY BY NAME g_occ.occ02     # 顯示單頭值
 
      LET g_wc = " occ01 ='",g_occ.occ01,"'"
      LET g_wc2= " occ01 ='",g_occ.occ01,"'"
   END IF
 
   IF g_wc2 = " 1=1" THEN         # 若單身未輸入條件
      LET g_sql = "SELECT  occ01 FROM occ_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY occ01"
   ELSE               # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE occ_file. occ01 ",
                  "  FROM occ_file, tc_oao_file ",
                  " WHERE occ01 = tc_oao01 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY occ01"
   END IF
 
   PREPARE i202_prepare FROM g_sql
   DECLARE i202_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i202_prepare
 
   IF g_wc2 = " 1=1" THEN         # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM occ_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(distinct occ01) FROM occ_file,tc_oao_file WHERE ",
                "occ01=tc_oao01 ",
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i202_precount FROM g_sql
   DECLARE i202_count CURSOR FOR i202_precount
 
END FUNCTION
 
FUNCTION i202_menu()
 
   WHILE TRUE
      CALL i202_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i202_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i202_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i202_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i202_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF g_occ.occ01 IS NOT NULL THEN
                  LET g_doc.column1 = "occ01"
                  LET g_doc.value1 = g_occ.occ01
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_oao),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i202_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tc_oao.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i202_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_occ.* TO NULL
      RETURN
   END IF
 
   OPEN i202_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_occ.* TO NULL
   ELSE
      OPEN i202_count
      FETCH i202_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i202_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i202_fetch(p_flag)
DEFINE
       p_flag          LIKE type_file.chr1,        #處理方式    #No.FUN-680136 VARCHAR(1)
       l_occuser       LIKE occ_file.occuser,      #FUN-4C0056 add
       l_occgrup       LIKE occ_file.occgrup       #FUN-4C0056 add
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i202_cs INTO g_occ.occ01
      WHEN 'P' FETCH PREVIOUS i202_cs INTO g_occ.occ01
      WHEN 'F' FETCH FIRST    i202_cs INTO g_occ.occ01
      WHEN 'L' FETCH LAST     i202_cs INTO g_occ.occ01
      WHEN '/'
            IF (NOT mi_no_ask) THEN
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
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i202_cs INTO g_occ.occ01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode AND cl_null(g_argv1) THEN
      LET g_msg=g_occ.occ01 CLIPPED,'+',g_occ.occ02 CLIPPED
      CALL cl_err(g_msg,SQLCA.sqlcode,0)
      INITIALIZE g_occ.* TO NULL               #No.FUN-6A0162
      RETURN
   END IF
 
   IF cl_null(g_argv1) THEN
      SELECT occ01,occ02,occacti,occuser,occgrup  #FUN-4C0056 add
        INTO g_occ.*,l_occuser,l_occgrup                #FUN-4C0056 add
        FROM occ_file WHERE occ01 = g_occ.occ01
      IF SQLCA.sqlcode THEN
         LET g_msg=g_occ.occ01 CLIPPED,'+',g_occ.occ02 CLIPPED
         CALL cl_err3("sel","occ_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
      LET g_data_owner = l_occuser      #FUN-4C0056 add
      LET g_data_group = l_occgrup      #FUN-4C0056 add
      LET g_data_keyvalue = g_occ.occ01 #FUN-DA0125 add
  
   END IF
 
   CALL i202_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i202_show()
  DEFINE l_msg   LIKE ze_file.ze03   #No.FUN-680136 VARCHAR(20)
 
   LET g_occ_t.* = g_occ.*           #保存單頭舊值
   LET g_data_keyvalue = g_occ.occ01 #No:FUN-F50016
   DISPLAY BY NAME   g_occ.occ01     # 顯示單頭值
   DISPLAY BY NAME   g_occ.occ02     # 顯示單頭值

 
   CALL i202_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i202_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用               #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否               #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態                 #No.FUN-680136 VARCHAR(1)
    l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入   #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否                 #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否                 #No.FUN-680136 SMALLINT
 
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
 
    LET g_forupd_sql = "SELECT tc_oao02,tc_oao03,tc_oao04,'',tc_oao05,tc_oao06 FROM tc_oao_file",
                       " WHERE tc_oao01=? AND tc_oao02=? AND tc_oao03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i202_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tc_oao WITHOUT DEFAULTS FROM s_tc_oao.*
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
              LET g_tc_oao_t.* = g_tc_oao[l_ac].*  #BACKUP
 
              OPEN i202_bcl USING g_occ.occ01,g_tc_oao_t.tc_oao02,g_tc_oao_t.tc_oao03
              IF STATUS THEN
                 CALL cl_err("OPEN i202_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i202_bcl INTO g_tc_oao[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_oao_t.tc_oao03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT eca02 INTO g_tc_oao[l_ac].eca02
                   FROM eca_file
                  WHERE eca01 = g_tc_oao[l_ac].tc_oao04
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_oao[l_ac].* TO NULL      #900423
           LET g_tc_oao_t.* = g_tc_oao[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD tc_oao02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO tc_oao_file(tc_oao01,tc_oao02,tc_oao03,tc_oao04,tc_oao05,tc_oao06)
                VALUES(g_occ.occ01,g_tc_oao[l_ac].tc_oao02,g_tc_oao[l_ac].tc_oao03,g_tc_oao[l_ac].tc_oao04,g_tc_oao[l_ac].tc_oao05,g_tc_oao[l_ac].tc_oao06)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_oao_file",g_occ.occ01,g_tc_oao[l_ac].tc_oao02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD tc_oao03                        #default 序號
           IF g_tc_oao[l_ac].tc_oao03 IS NULL OR g_tc_oao[l_ac].tc_oao03 = 0 THEN
              SELECT max(tc_oao03)+1
                INTO g_tc_oao[l_ac].tc_oao03
                FROM tc_oao_file
               WHERE tc_oao01 = g_occ.occ01
                 AND tc_oao02 = g_tc_oao[l_ac].tc_oao02 
              IF g_tc_oao[l_ac].tc_oao03 IS NULL THEN
                 LET g_tc_oao[l_ac].tc_oao03 = 1
              END IF
           END IF
 
        AFTER FIELD tc_oao03                        #check 序號是否重複
           IF NOT cl_null(g_tc_oao[l_ac].tc_oao03) THEN
              IF g_tc_oao[l_ac].tc_oao03 != g_tc_oao_t.tc_oao03 OR g_tc_oao_t.tc_oao03 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM tc_oao_file
                  WHERE tc_oao01 = g_occ.occ01
                    AND tc_oao02 = g_tc_oao[l_ac].tc_oao02
                    AND tc_oao03 = g_tc_oao[l_ac].tc_oao03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tc_oao[l_ac].tc_oao03 = g_tc_oao_t.tc_oao03
                    NEXT FIELD tc_oao03
                 END IF
              END IF
              LET g_cnt = g_cnt + 1
           END IF

        AFTER FIELD tc_oao04 #工作中心
          IF NOT cl_null(g_tc_oao[l_ac].tc_oao04) THEN
             LET g_tc_oao[l_ac].eca02=''
             SELECT eca02 INTO g_tc_oao[l_ac].eca02
               FROM eca_file
              WHERE eca01 = g_tc_oao[l_ac].tc_oao04
                AND ecaacti='Y'
             IF cl_null(g_tc_oao[l_ac].eca02) THEN
                CALL cl_err(g_tc_oao[l_ac].tc_oao04,'aec-054',1)
                NEXT FIELD tc_oao04
             ELSE
                DISPLAY BY NAME g_tc_oao[l_ac].eca02
             END IF
          END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_tc_oao_t.tc_oao03 > 0 AND g_tc_oao_t.tc_oao03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM tc_oao_file
               WHERE tc_oao01 = g_occ.occ01
                 AND tc_oao02 = g_tc_oao_t.tc_oao02
                 AND tc_oao03 = g_tc_oao_t.tc_oao03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_oao_file",g_occ.occ01,g_tc_oao_t.tc_oao02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_tc_oao[l_ac].* = g_tc_oao_t.*
              CLOSE i202_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_oao[l_ac].tc_oao03,-263,1)
              LET g_tc_oao[l_ac].* = g_tc_oao_t.*
           ELSE
              UPDATE tc_oao_file SET tc_oao02=g_tc_oao[l_ac].tc_oao02,
                                     tc_oao03=g_tc_oao[l_ac].tc_oao03,
                                     tc_oao04=g_tc_oao[l_ac].tc_oao04,
                                     tc_oao05=g_tc_oao[l_ac].tc_oao05,
                                     tc_oao06=g_tc_oao[l_ac].tc_oao06
               WHERE tc_oao01=g_occ.occ01
                 AND tc_oao02=g_tc_oao_t.tc_oao02
                 AND tc_oao03=g_tc_oao_t.tc_oao03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","tc_oao_file",g_occ.occ01,g_tc_oao_t.tc_oao02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_tc_oao[l_ac].* = g_tc_oao_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac         #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_tc_oao[l_ac].* = g_tc_oao_t.*
              #FUN-D30034---add---str---
              ELSE
                 CALL g_tc_oao.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end---
              END IF
              CLOSE i202_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac         #FUN-D30034 add 
           CLOSE i202_bcl
           COMMIT WORK
       
        ON ACTION controlp
           CASE

           WHEN INFIELD(tc_oao04) #工作站別
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_eca1"
             LET g_qryparam.default1 = g_tc_oao[l_ac].tc_oao04
             CALL cl_create_qry() RETURNING g_tc_oao[l_ac].tc_oao04
             DISPLAY BY NAME g_tc_oao[l_ac].tc_oao04
             NEXT FIELD tc_oao04
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tc_oao03) AND l_ac > 1 THEN
              LET g_tc_oao[l_ac].* = g_tc_oao[l_ac-1].*
              SELECT max(tc_oao03)+1
                INTO g_tc_oao[l_ac].tc_oao03
                FROM tc_oao_file
               WHERE tc_oao01 = g_occ.occ01
                 AND tc_oao02 = g_tc_oao[l_ac].tc_oao02
              NEXT FIELD tc_oao03
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
    END INPUT
 
    CLOSE i202_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i202_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON tc_oao02,tc_oao04,tc_oao05,tc_oao05 
                  FROM s_tc_oao[1].tc_oao02,s_tc_oao[1].tc_oao04,s_tc_oao[1].tc_oao05,s_tc_oao[1].tc_oao06
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
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL i202_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i202_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           STRING,
   l_flag          LIKE type_file.chr1          
 
   LET g_sql = "SELECT tc_oao02,tc_oao03,tc_oao04,'',tc_oao05,tc_oao06 ",
               " FROM tc_oao_file,occ_file ",
               " WHERE tc_oao01=occ01 AND tc_oao01 ='",g_occ.occ01,"' AND ",  #單頭-1
               p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
   PREPARE i202_pb FROM g_sql
   DECLARE tc_oao_cs CURSOR FOR i202_pb
 
   CALL g_tc_oao.clear()
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH tc_oao_cs INTO g_tc_oao[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     
      SELECT eca02 INTO g_tc_oao[g_cnt].eca02
        FROM eca_file
       WHERE eca01 = g_tc_oao[g_cnt].tc_oao04
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_tc_oao.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i202_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_oao TO s_tc_oao.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
      LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i202_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i202_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i202_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i202_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i202_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
 
 
       ON ACTION related_document  #No.MOD-470518
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i202_copy()
DEFINE
   l_occ02 LIKE occ_file.occ02,
   l_newno,l_oldno LIKE occ_file.occ01 #己存在,欲copy單身的廠商編號
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_occ.occ01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT l_newno FROM occ01
 
      AFTER FIELD occ01
         IF cl_null(l_newno) THEN
            NEXT FIELD occ01
         END IF
         #檢查客戶編號是否存在
         SELECT count(*) INTO g_cnt
           FROM occ_file
          WHERE occ01 = l_newno AND occacti = 'Y'
         IF g_cnt = 0 THEN
            CALL cl_err(l_newno,'mfg3001',0)
            NEXT FIELD occ01
         END IF
         #檢查是否己有單身資料
         SELECT count(*) INTO g_cnt FROM tc_oao_file
          WHERE tc_oao01 = l_newno
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD occ01
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_occ.occ01
      DISPLAY BY NAME g_occ.occ02
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM tc_oao_file         #單身複製
    WHERE tc_oao01=g_occ.occ01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   END IF
 
   UPDATE x SET tc_oao01=l_newno
 
   INSERT INTO tc_oao_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","tc_oao_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_occ.occ01
   SELECT occ01,occ02 INTO g_occ.occ01,g_occ.occ02
     FROM occ_file
    WHERE occ01 = l_newno
   DISPLAY BY NAME g_occ.occ02
 
   CALL i202_b()
  
END FUNCTION
 
FUNCTION i202_out()
DEFINE
   l_i             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
   sr              RECORD
       occ01       LIKE occ_file.occ01,          #
       occ02       LIKE occ_file.occ02,
       tc_oao02    LIKE tc_oao_file.tc_oao02, 
       tc_oao04    LIKE tc_oao_file.tc_oao04,
       tc_oao05    LIKE tc_oao_file.tc_oao05,
       tc_oao06    LIKE tc_oao_file.tc_oao06   
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
   LET l_cmd = 'p_query "cxmi202" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'                                                         
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN 
 

END FUNCTION
 
