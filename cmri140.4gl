# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cmri140.4gl
# Descriptions...: MRP資料維護作業
# Date & Author..: 20180713 By Momo
# Modify.........: 20210624 By momo 
# Modify.........: NO.23070026   20230717 modify by momo 增加取替代資訊顯示

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_mss_v         LIKE mss_file.mss_v,   #類別代號 (假單頭)
    g_mss_v_t       LIKE mss_file.mss_v,   #類別代號 (舊值)
    g_mss           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        mss11       LIKE mss_file.mss11,
	    mss09       LIKE mss_file.mss09,
	    mss08       LIKE mss_file.mss08,  
        ima27       LIKE ima_file.ima27,    #20210624
        atp_qty     LIKE type_file.num10,   #20210624
        mss00       LIKE mss_file.mss00,   
	    mss01       LIKE mss_file.mss01,
	    ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,     
        ima08       LIKE ima_file.ima08,     
        mss03       LIKE mss_file.mss03,     
	    mss041      LIKE mss_file.mss041,
    	mss043      LIKE mss_file.mss043,
	    mss044      LIKE mss_file.mss044,
	    mss051      LIKE mss_file.mss051,
        mss052      LIKE mss_file.mss052,
        mss053      LIKE mss_file.mss053,
        mss061      LIKE mss_file.mss061,
        mss062      LIKE mss_file.mss061,
        mss063      LIKE mss_file.mss063,
        mss064      LIKE mss_file.mss064,
        mss065      LIKE mss_file.mss065
                    END RECORD,
    g_mss_t         RECORD                 #程式變數 (舊值)
        mss11       LIKE mss_file.mss11,
	    mss09       LIKE mss_file.mss09,
	    mss08       LIKE mss_file.mss08, 
        ima27       LIKE ima_file.ima27,    #20210624
        atp_qty     LIKE type_file.num10,   #20210624
        mss00       LIKE mss_file.mss00,      
	    mss01       LIKE mss_file.mss01,
	    ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,     
        ima08       LIKE ima_file.ima08,     
        mss03       LIKE mss_file.mss03,     
	    mss041      LIKE mss_file.mss041,
	    mss043      LIKE mss_file.mss043,
	    mss044      LIKE mss_file.mss044,
	    mss051      LIKE mss_file.mss051,
        mss052      LIKE mss_file.mss052,
        mss053      LIKE mss_file.mss053,
        mss061      LIKE mss_file.mss061,
        mss062      LIKE mss_file.mss061,
        mss063      LIKE mss_file.mss063,
        mss064      LIKE mss_file.mss064,
        mss065      LIKE mss_file.mss065
                    END RECORD,
    ##---- 20210624 add (S) -----
    g_mss_attr       DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        mss11       STRING,
        mss09       STRING,
        mss08       STRING,
        ima27       STRING,    
        atp_qty     STRING,   
        mss00       STRING,
        mss01       STRING,
        ima02       STRING,
        ima021      STRING,
        ima08       STRING,
        mss03       STRING,
        mss041      STRING,
        mss043      STRING,
        mss044      STRING,
        mss051      STRING,
        mss052      STRING,
        mss053      STRING,
        mss061      STRING,
        mss062      STRING,
        mss063      STRING,
        mss064      STRING,
        mss065      STRING
                    END RECORD,
    ##---- 20210624 add (E) -----
    g_argv1         LIKE mss_file.mss_v,
    g_wc,g_sql      STRING,                      #No.FUN-580092 HCN        #No.FUN-680104
    g_cmd           LIKE type_file.chr1000,      #MOD-4B0255        #No.FUN-680104
    g_ss            LIKE type_file.chr1,         # Prog. Version..: '5.30.24-17.04.13(01)             #決定後續步驟
    g_rec_b         LIKE type_file.num5,         #單身筆數        #No.FUN-680104 SMALLINT
    g_rec_b2        LIKE type_file.num5,
    l_ac            LIKE type_file.num5,         #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
    g_sql1          STRING,                      #20230717
    g_bmd          DYNAMIC ARRAY OF RECORD       #20230717
        bmd04       LIKE bmd_file.bmd04,         #20230717
        atp         LIKE type_file.num15_3       #20230717
   END RECORD
 
#主程式開始
DEFINE g_forupd_sql   STRING                       #SELECT ... FOR UPDATE SQL        #No.FUN-680104
DEFINE g_chr          LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5          #No.FUN-680104 SMALLINT
DEFINE g_cnt_1        LIKE type_file.num10         #CHI-8C0017
 
MAIN
DEFINE
    p_row,p_col   LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("CMR")) THEN
       EXIT PROGRAM
    END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
    LET g_argv1  = ARG_VAL(1)              #料件編號
    LET g_mss_v = NULL                     #清除鍵值
    LET g_mss_v_t = NULL
    LET g_mss_v = g_argv1
 
    LET p_row = 4 LET p_col = 6
    OPEN WINDOW i140_w AT p_row,p_col
         WITH FORM "cmr/42f/cmri140"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
	CALL  i140_q()
    END IF
    CALL i140_menu()
    CLOSE WINDOW i140_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION i140_curs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
   DEFINE
    l_mss  RECORD
            mss_01	 LIKE mss_file.mss01       
           END RECORD   
 
    CLEAR FORM                             #清除畫面
    CALL g_mss.clear()
    IF g_argv1 IS NULL OR g_argv1 = ' ' THEN
 
    CALL cl_set_head_visible("","YES")           
    INITIALIZE g_mss_v TO NULL   

    
    CONSTRUCT g_wc ON mss_v,mss09,ima08,mss01,mss03 FROM mss_v,s_mss[1].mss09,s_mss[1].ima08,s_mss[1].mss01,s_mss[1].mss03             
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION controlp
           CASE
              WHEN INFIELD(mss_v)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_mss_v"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO mss_v
                   NEXT FIELD mss_v
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
   
       IF INT_FLAG THEN RETURN END IF
    ELSE LET g_wc = " mss_v = '",g_argv1,"'"
    END IF
    LET g_sql= "SELECT UNIQUE mss_v FROM mss_file,ima_file ",                      
               " WHERE mss01=ima01 AND ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i140_prepare FROM g_sql      #預備一下
    DECLARE i140_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i140_prepare
 
    LET g_cnt_1 = 0
    FOREACH i140_b_curs INTO l_mss.*
            LET g_cnt_1 = g_cnt_1 + 1
	  END FOREACH 

END FUNCTION
 
 
FUNCTION i140_menu()
 
   WHILE TRUE
      CALL i140_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i140_q()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i140_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mss),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i140_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_mss.clear()
    INITIALIZE g_mss_v LIKE mss_file.mss_v
    LET g_mss_v_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i140_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ss='N' THEN
            CALL g_mss.clear()
        ELSE
            CALL i140_b_fill('1=1')         #單身
        END IF
        LET g_rec_b = 0
        CALL i140_b()                      #輸入單身
        LET g_mss_v_t = g_mss_v            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i140_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680104 VARCHAR(1)
 
    LET g_ss='Y'

 
    CALL cl_set_head_visible("","YES")           
    INPUT g_mss_v                       
        WITHOUT DEFAULTS
        FROM mss_v                  
 
 
        AFTER FIELD mss_v                  #類別代號
            IF NOT cl_null(g_mss_v) THEN

                IF g_mss_v != g_mss_v_t OR     #輸入後更改不同時值
                   g_mss_v_t IS NULL THEN
                    SELECT UNIQUE mss_v INTO g_chr
                        FROM mss_file
                        WHERE mss01=g_mss_v
                          AND mss10='N'                                           
                    IF SQLCA.sqlcode THEN             #不存在, 新來的
                        IF p_cmd='a' THEN
                            LET g_ss='N'
                        END IF
                    ELSE
                        IF p_cmd='u' THEN
                            CALL cl_err(g_mss_v,-239,0)
                            LET g_mss_v=g_mss_v_t
                            NEXT FIELD mss_v
                        END IF
                    END IF
                END IF
               
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_mss_v,g_errno,0)
                   NEXT FIELD mss_v
                END IF
            END IF
            
 
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(mss_v)
#FUN-AA0059---------mod------------str-----------------
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_mss_v"
                    LET g_qryparam.default1 = ''
                    CALL cl_create_qry() RETURNING g_mss_v
                   
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY BY NAME g_mss_v
                     NEXT FIELD mss_v
                OTHERWISE EXIT CASE
            END CASE
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
    END INPUT
END FUNCTION
 
 
#Query 查詢
FUNCTION i140_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_mss_v TO NULL              
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i140_curs()                        #取得查詢條件
    IF INT_FLAG THEN                        #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_mss_v TO NULL
        RETURN
    END IF
    OPEN i140_b_curs                        #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                   #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_mss_v TO NULL
    ELSE
        CALL i140_fetch('F')                #讀出TEMP第一筆並顯示
        LET g_row_count = g_cnt_1
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i140_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i140_b_curs INTO g_mss_v         
        WHEN 'P' FETCH PREVIOUS i140_b_curs INTO g_mss_v
        WHEN 'F' FETCH FIRST    i140_b_curs INTO g_mss_v
        WHEN 'L' FETCH LAST     i140_b_curs INTO g_mss_v
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i140_b_curs INTO g_mss_v           
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_mss_v,SQLCA.sqlcode,0)
        INITIALIZE g_mss_v TO NULL
    ELSE
        CALL i140_show()
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
 
#將資料顯示在畫面上
FUNCTION i140_show()
 
    DISPLAY g_mss_v TO mss_v                #單頭
    CALL i140_b_fill(g_wc)                  #單身
    CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
END FUNCTION
 

 
#單身
FUNCTION i140_b()
DEFINE
    l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT  #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,       #檢查重複用      #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,       #單身鎖住否      #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,       #處理狀態        #No.FUN-680104 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,    #可新增否        #No.FUN-680104 VARCHAR(80)
    l_allow_insert  LIKE type_file.num5,       #可新增否        #No.FUN-680104 SMALLINT
    l_allow_delete  LIKE type_file.num5        #可刪除否        #No.FUN-680104 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_mss_v IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT mss11,mss09,mss08,ima27,0,", #20210624
      "        mss00,mss01,ima02,ima021,ima08,mss03,mss041,mss043,mss044,mss051,mss052,mss053,mss061,mss062,mss063,mss064,mss065 ",                      
      "   FROM mss_file,ima_file ",
      "   WHERE ima01=mss01 AND mss_v= ? ",
      "    AND mss00 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i140_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        #LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_mss WITHOUT DEFAULTS FROM s_mss.*
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
                LET g_mss_t.* = g_mss[l_ac].*        #BACKUP
                BEGIN WORK
                                                      
              
                OPEN i140_bcl USING g_mss_v,g_mss_t.mss00                                     
                IF STATUS THEN
                    CALL cl_err("OPEN i140_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i140_bcl INTO g_mss[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_mss_t.mss00,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    
                    END IF
                    CALL cs_q102_atp_qty(g_mss[l_ac].mss01) RETURNING g_mss[l_ac].atp_qty
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        
 
        BEFORE DELETE                            #是否取消單身
            IF g_mss_t.mss00 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM mss_file
                    WHERE mss_v = g_mss_v AND
                          mss00 = g_mss_t.mss00
                      AND mss01 = g_mss_t.mss01                        
                                                
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","mss_file",g_mss_v,g_mss_t.mss00,SQLCA.sqlcode,"","",1)  
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
               LET g_mss[l_ac].* = g_mss_t.*
               CLOSE i140_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_mss[l_ac].mss00,-263,1)
                LET g_mss[l_ac].* = g_mss_t.*
            ELSE
               
                UPDATE mss_file SET
                       mss09=g_mss[l_ac].mss09,
                       mss03=g_mss[l_ac].mss03,   #20180810 add
                       mss11=g_mss[l_ac].mss11
                 WHERE mss_v = g_mss_v
                   AND mss00 = g_mss_t.mss00
                   AND mss01 = g_mss_t.mss01                                           
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","mss_file",g_mss_v,g_mss_t.mss00,SQLCA.sqlcode,"","",1)  
                    LET g_mss[l_ac].* = g_mss_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac  #FUN-D30034
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_mss[l_ac].* = g_mss_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_mss.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE i140_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30034
            CLOSE i140_bcl
            COMMIT WORK
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(mss01)     
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ima"
                     LET g_qryparam.default1 = g_mss[l_ac].mss01
                     CALL cl_create_qry() RETURNING g_mss[l_ac].mss01
                     DISPLAY g_mss[l_ac].mss01 TO mss01
                     NEXT FIELD mss01
               
                OTHERWISE EXIT CASE
            END CASE
 
      
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(mss01) AND l_ac > 1 THEN
                LET g_mss[l_ac].* = g_mss[l_ac-1].*
                NEXT FIELD mss01
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
 
 
    CLOSE i140_bcl
    COMMIT WORK
END FUNCTION
 

 
FUNCTION i140_b_askkey()
DEFINE
    l_wc          STRING
 
  
    CONSTRUCT l_wc ON mss01
                 FROM s_mss[1].mss01
                 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
    CALL i140_b_fill(l_wc)
END FUNCTION
 
FUNCTION i140_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc           STRING    
DEFINE l_cnt          LIKE type_file.num5   

      LET g_sql =
       "SELECT mss11,mss09,mss08,ima27,0,",         #20210624
       "       mss00,mss01,ima02,ima021,ima08,mss03,mss041,mss043,mss044,mss051,mss052,mss053,mss061,mss062,mss063,mss064,mss065  ",                                           #FUN-D10004 add
       " FROM mss_file,ima_file ",
       " WHERE mss_v = '",g_mss_v,"' ",
       "   AND mss01=ima01 AND mss10='N' ",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 5,1"

    PREPARE i140_prepare2 FROM g_sql      #預備一下
    DECLARE mss_curs CURSOR FOR i140_prepare2
    CALL g_mss.clear()
    CALL g_mss_attr.clear()  #20210624
    LET g_cnt = 1
    FOREACH mss_curs INTO g_mss[g_cnt].*                                                                    
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF

      CALL cs_q102_atp_qty(g_mss[g_cnt].mss01) RETURNING g_mss[g_cnt].atp_qty  #20210624

      ##---- 20210624 add (S)
      IF g_mss[g_cnt].atp_qty > g_mss[g_cnt].ima27 THEN
         LET g_mss_attr[g_cnt].mss09 = "red reverse"
         LET g_mss_attr[g_cnt].ima27 = "red reverse"
         LET g_mss_attr[g_cnt].atp_qty = "red reverse"
      END IF
      ##---- 20210624 add (E)

      ##---- 20230717 add by momo (S)
      LET l_cnt = 0
      SELECT 1 INTO l_cnt FROM bmd_file
       WHERE bmd01 = g_mss[g_cnt].mss01
         AND bmdacti = 'Y' 
         AND bmd06 IS NULL
      IF l_cnt =1 THEN
         LET g_mss_attr[g_cnt].mss01 = "green reverse"
      END IF
      ##---- 20230717 add by momo (E)
      
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_mss.deleteElement(g_cnt)
    LET g_rec_b= g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i140_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ""
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mss TO s_mss.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL DIALOG.setCellAttributes(g_mss_attr)      #20210624
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         #---- 20230717 add (S)
         #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF l_ac = 0 THEN
           LET l_ac = 1
         END IF       
         IF l_ac > 0 THEN
            CALL i140_b1_fill()
            CALL i140_bp2('')
         END IF
         #---- 20230717 add (E)
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i140_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i140_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i140_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i140_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i140_fetch('L')
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
         EXIT DISPLAY
 
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
 
     
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i140_bp2(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1

   DISPLAY ARRAY g_bmd TO s_bmd.* ATTRIBUTE(COUNT=g_rec_b2)
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

FUNCTION i140_b1_fill()              #BODY FILL UP
DEFINE p_wc     STRING  
DEFINE g_cnt1   LIKE type_file.num10                
 
    LET g_sql1 =
       "SELECT bmd04,0 ",
       "  FROM bmd_file ",           
       " WHERE bmd01 = '",g_mss[g_cnt].mss01,"' ",
       "   AND bmd06 IS NULL AND bmdacti='Y' "      
       
 
    PREPARE i140_prepare21 FROM g_sql1           #預備一下
    DECLARE bmd_curs CURSOR FOR i140_prepare21
    CALL g_bmd.clear()
    LET g_cnt1 = 1
    FOREACH bmd_curs INTO g_bmd[g_cnt1].*       #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt1 = g_cnt1 + 1
        IF g_cnt1 > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_bmd.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt1 - 1
 
END FUNCTION
 
 


