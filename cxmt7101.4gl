# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cxmt7101.4gl
# Descriptions...: 客訴維護零件登錄
# Date & Author..: 20221115 By momo
# Modify.........: No:

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE
    g_ohc     RECORD   LIKE ohc_file.* ,
    g_ohc_t   RECORD LIKE ohc_file.*   ,
    g_tc_ohc01_t    LIKE tc_ohc_file.tc_ohc01,
    g_argv1         LIKE tc_ohc_file.tc_ohc01,
    g_tc_ohc        DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_ohc02    LIKE tc_ohc_file.tc_ohc02, #料號
        ima02       LIKE ima_file.ima02,       #品名
        ima021      LIKE ima_file.ima021,      #規格
        tc_ohc04    LIKE tc_ohc_file.tc_ohc04  #領用數量
                    END RECORD,
    g_tc_ohc_t      RECORD    #程式變數(Program Variables)
        tc_ohc02    LIKE tc_ohc_file.tc_ohc02, #料號
        ima02       LIKE ima_file.ima02,       #品名
        ima021      LIKE ima_file.ima021,      #規格
        tc_ohc04    LIKE tc_ohc_file.tc_ohc04  #領用數量
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166       
    g_rec_b         LIKE type_file.num5,          #目前單身筆數          
    l_ac            LIKE type_file.num5           #目前處理 ARRAY COUNT  
 
DEFINE p_row,p_col     LIKE type_file.num5          
 
DEFINE g_forupd_sql    STRING  #SELECT ... FOR UPDATE SQL  
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(72)
 
DEFINE   g_curs_index   LIKE type_file.num10        
DEFINE   g_row_count    LIKE type_file.num10         
DEFINE   g_jump         LIKE type_file.num10         
DEFINE   mi_no_ask      LIKE type_file.num5          
DEFINE   g_success      LIKE type_file.chr1           
 
MAIN
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   INITIALIZE g_ohc.* TO NULL
   INITIALIZE g_ohc_t.* TO NULL
   LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW i7101_w AT p_row,p_col
         WITH FORM "cxm/42f/cxmt7101"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #
 
    CALL cl_ui_init()
    
 
    LET g_argv1 = ARG_VAL(1)
    LET g_ohc.ohc01 = g_argv1
    IF NOT cl_null(g_argv1) THEN
        CALL i7101_q()
    END IF
    CALL i7101_menu()
    CLOSE WINDOW i7101_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i7101_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
    IF g_argv1 = " " OR g_argv1 IS NULL THEN
      CLEAR FORM
      CALL cl_set_head_visible("","YES")       
 
   INITIALIZE g_ohc.* TO NULL    
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
          ohc01
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
         CALL cl_qbe_list() RETURNING lc_qbe_sn
	 CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT

      IF INT_FLAG THEN RETURN END IF

      CONSTRUCT g_wc2 ON tc_ohc02,tc_ohc04  # 螢幕上取單身條件     
              FROM s_tc_ohc[1].tc_ohc02,s_tc_ohc[1].tc_ohc04
      BEFORE CONSTRUCT
	     CALL cl_qbe_display_condition(lc_qbe_sn)

        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(tc_ohc02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tc_ohc02
                NEXT FIELD tc_ohc02
 
               OTHERWISE
                    EXIT CASE
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
 
 
      ON ACTION qbe_save
	 CALL cl_qbe_save()
      END CONSTRUCT
      IF STATUS THEN CALL cl_err ('',STATUS,1) END IF
      IF INT_FLAG THEN  RETURN END IF
 
      IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
         LET g_sql = "SELECT ohc01 FROM ohc_file ",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY ohc01"
      ELSE					# 若單身有輸入條件
         LET g_sql = "SELECT UNIQUE tc_ohc01 ",
                     "  FROM tc_ohc_file,ohc_file  ",
                     " WHERE tc_ohc01 = ohc01 AND ",
                     g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY tc_ohc01"
      END IF
   ELSE
      LET g_wc = " ohc01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
      LET g_sql = "SELECT ohc01 FROM ohc_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY ohc01"
   END IF
   PREPARE i7101_prepare FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE i7101_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i7101_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM ohc_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(distinct tc_ohc01)",
                  " FROM tc_ohc_file,ohc_file WHERE ",
                  " tc_ohc01=ohc01 AND ",g_wc CLIPPED,
                  " AND ",g_wc2 CLIPPED
    END IF
    PREPARE i7101_precount FROM g_sql
    DECLARE i7101_count CURSOR FOR i7101_precount
END FUNCTION
 
FUNCTION i7101_menu()
 
   WHILE TRUE
      CALL i7101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i7101_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_ohc.ohc03 <> '2' THEN
                  CALL i7101_b()
               ELSE
                  RETURN
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_ohc),'','')
            END IF
      END CASE
   END WHILE
      CLOSE i7101_cs
END FUNCTION
 
FUNCTION i7101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_ohc.* TO NULL             
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i7101_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_ohc.* TO NULL
        RETURN
    END IF
    OPEN i7101_count
    FETCH i7101_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i7101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ohc.ohc01,SQLCA.sqlcode,0)
        INITIALIZE g_ohc.* TO NULL
    ELSE
        CALL i7101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i7101_fetch(p_flag)
    DEFINE
        p_flag          LIKE type_file.chr1 
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i7101_cs INTO g_ohc.ohc01
        WHEN 'P' FETCH PREVIOUS i7101_cs INTO g_ohc.ohc01
        WHEN 'F' FETCH FIRST    i7101_cs INTO g_ohc.ohc01
        WHEN 'L' FETCH LAST     i7101_cs INTO g_ohc.ohc01
        WHEN '/'
           IF (NOT mi_no_ask) THEN
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
              IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
              END IF
           END IF
           FETCH ABSOLUTE g_jump i7101_cs INTO g_ohc.ohc01
           LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ohc.ohc01,SQLCA.sqlcode,0)
        INITIALIZE g_ohc.* TO NULL  
        LET g_ohc.ohc01 = NULL      
        RETURN
    END IF
 
      CASE p_flag
            WHEN 'F' LET g_curs_index = 1
            WHEN 'P' LET g_curs_index = g_curs_index - 1
            WHEN 'N' LET g_curs_index = g_curs_index + 1
            WHEN 'L' LET g_curs_index = g_row_count
            WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
 
    SELECT ohc01,ohc03   # 重讀DB,因TEMP有不被更新特性
           INTO g_ohc.ohc01,g_ohc.ohc03 FROM ohc_file
       WHERE ohc_file.ohc01 = g_ohc.ohc01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","tc_ohc_file",g_ohc.ohc01,"",SQLCA.sqlcode,"","",1)  
       INITIALIZE g_ohc.* TO NULL        
    ELSE
       LET g_data_keyvalue = g_ohc.ohc01  
       CALL i7101_show()                      # 重新顯示
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i7101_show()
    DEFINE   l_msg   LIKE type_file.chr20     
    LET g_ohc_t.* = g_ohc.*            #保存單頭舊值
    LET g_data_keyvalue = g_ohc.ohc01            
    DISPLAY BY NAME g_ohc.ohc01        #顯示單頭值
    DISPLAY l_msg TO FORMONLY.desc
    CALL i7101_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                  
END FUNCTION
 
#單身
FUNCTION i7101_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,                #檢查重複用        
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
    p_cmd           LIKE type_file.chr1,                #處理狀態          
    l_allow_insert  LIKE type_file.num5,                #可新增否          
    l_allow_delete  LIKE type_file.num5                 #可刪除否          
 
    LET g_action_choice = ""
    LET g_success = 'Y'          
    
    IF g_ohc.ohc01 IS NULL
       THEN RETURN
    END IF
    IF g_ohc.ohcconf = 'X'
    THEN CALL  cl_err('','sfb-998',0)
         RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
     "  SELECT tc_ohc02,'','',tc_ohc04",  
     "  FROM tc_ohc_file",
     "   WHERE tc_ohc01 = ? ",
     "  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i7101_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tc_ohc
              WITHOUT DEFAULTS
              FROM s_tc_ohc.*
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
                LET g_tc_ohc_t.* = g_tc_ohc[l_ac].*  #BACKUP
                BEGIN WORK
 
                OPEN i7101_bcl USING g_ohc.ohc01 
                IF STATUS THEN
                    CALL cl_err("OPEN i7101_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i7101_bcl INTO g_tc_ohc[l_ac].*  
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_tc_ohc_t.tc_ohc02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF     
                    SELECT ima02,ima021
                      INTO g_tc_ohc[l_ac].ima02,g_tc_ohc[l_ac].ima021
                      FROM ima_file
                     WHERE ima01=g_tc_ohc[l_ac].tc_ohc02
                CALL cl_show_fld_cont()    
            END IF
 
 
        AFTER INSERT
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO tc_ohc_file
                  (tc_ohc01,tc_ohc02,tc_ohc04)                   
            VALUES(g_ohc.ohc01,g_tc_ohc[l_ac].tc_ohc02,g_tc_ohc[l_ac].tc_ohc04)
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","tc_ohc_file",g_ohc.ohc01,g_tc_ohc[l_ac].tc_ohc02,SQLCA.sqlcode,"","",1) 
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_tc_ohc[l_ac].* TO NULL     
            LET g_tc_ohc_t.* = g_tc_ohc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()    
            NEXT FIELD tc_ohc02
 

        AFTER FIELD tc_ohc02
            IF NOT cl_null(g_tc_ohc[l_ac].tc_ohc02) THEN
               SELECT ima02,ima021 INTO g_tc_ohc[l_ac].ima02,g_tc_ohc[l_ac].ima021
                 FROM ima_file
                 WHERE ima01 = g_tc_ohc[l_ac].tc_ohc02
                   AND imaacti='Y'
               IF cl_null(g_tc_ohc[l_ac].ima02) THEN
                  NEXT FIELD tc_ohc02
               END IF
            END IF
       
        BEFORE DELETE                            #是否取消單身
            IF g_tc_ohc_t.tc_ohc02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM tc_ohc_file
                 WHERE tc_ohc01 = g_ohc.ohc01
                   AND tc_ohc02 = g_tc_ohc[l_ac].tc_ohc02
                IF SQLCA.SQLERRD[3] = 0 THEN
                    CALL cl_err3("del","tc_ohc_file",g_ohc.ohc01,g_tc_ohc_t.tc_ohc02,SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b -1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_ohc[l_ac].* = g_tc_ohc_t.*
               CLOSE i7101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_tc_ohc[l_ac].tc_ohc02,-263,1)
                LET g_tc_ohc[l_ac].* = g_tc_ohc_t.*
            ELSE
                UPDATE tc_ohc_file SET tc_ohc02 = g_tc_ohc[l_ac].tc_ohc02,
                                       tc_ohc04 = g_tc_ohc[l_ac].tc_ohc04
                    WHERE tc_ohc01 = g_ohc.ohc01
                      AND tc_ohc02 = g_tc_ohc_t.tc_ohc02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","tc_ohc_file",g_ohc.ohc01,g_tc_ohc_t.tc_ohc02,SQLCA.sqlcode,"","",1) 
                    LET g_tc_ohc[l_ac].* = g_tc_ohc_t.*
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
                  LET g_tc_ohc[l_ac].* = g_tc_ohc_t.*
               ELSE
                  CALL g_tc_ohc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               CLOSE i7101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   
            CLOSE i7101_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(tc_ohc02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.default1 = g_tc_ohc[l_ac].tc_ohc02
                CALL cl_create_qry() RETURNING g_tc_ohc[l_ac].tc_ohc02
                 DISPLAY BY NAME g_tc_ohc[l_ac].tc_ohc02      
                NEXT FIELD tc_ohc02
 
               OTHERWISE
                    EXIT CASE
            END CASE
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tc_ohc02) AND l_ac > 1 THEN
                LET g_tc_ohc[l_ac].* = g_tc_ohc[l_ac-1].*
                NEXT FIELD tc_ohc02
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
 
    CLOSE i7101_bcl
    COMMIT WORK
    
    IF g_rec_b <> 0 THEN
       IF g_success = 'N' THEN 
          LET g_success = 'Y' 
          CALL i7101_b()
       END IF                   
    END IF 
END FUNCTION
 
FUNCTION i7101_b_askkey()
DEFINE
 
    l_wc2           LIKE type_file.chr1000       
 
    CONSTRUCT l_wc2 ON tc_ohc02,tc_ohc04
                    FROM s_tc_ohc[1].tc_ohc02,s_tc_ohc[1].tc_ohc04
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
    IF INT_FLAG
       THEN LET INT_FLAG = 0
            RETURN
    END IF
    CALL i7101_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i7101_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       
 
    LET g_rec_b = 0
    LET g_sql =
        "SELECT tc_ohc02,ima02,ima021,tc_ohc04",   
        " FROM ima_file,tc_ohc_file ",
        " WHERE tc_ohc01 ='",g_ohc.ohc01,"'",
        "   AND tc_ohc02=ima01 ",
        " AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1,2"
    PREPARE i7101_pb FROM g_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,0) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
    DECLARE ocj_cs                      
        CURSOR FOR i7101_pb
 
    CALL g_tc_ohc.clear()
    LET g_cnt = 1
    FOREACH ocj_cs INTO g_tc_ohc[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode
           THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tc_ohc.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i7101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_ohc TO s_tc_ohc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                  
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i7101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 
 
      ON ACTION previous
         CALL i7101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                 
 
 
      ON ACTION jump
         CALL i7101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                
 
      ON ACTION next
         CALL i7101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY               
 
 
      ON ACTION last
         CALL i7101_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY           
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION controls                             
         CALL cl_set_head_visible("","AUTO")         
 
      ON ACTION exporttoexcel     
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i7101_tc_ohc02_entry()
DEFINE l_cnt     LIKE type_file.num5
     IF g_ohc.ohc03 <> '2' THEN 
        CALL cl_set_comp_entry("tc_ohc02,tc_ohc04",TRUE)
     END IF 
END FUNCTION 
 
FUNCTION i7101_tc_ohc02_noentry()
DEFINE l_cnt     LIKE type_file.num5
     IF g_ohc.ohc03= '2' THEN 
        CALL cl_set_comp_entry("tc_ohc02,tc_ohc04",FALSE)
     END IF  
END FUNCTION 
 
