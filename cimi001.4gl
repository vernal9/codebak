# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cimi001.4gl
# Descriptions...: 系列型號自製率列表
# Date & Author..: 19/09/30 By momo

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_azf           RECORD
                       azf01 LIKE azf_file.azf01    #系列
                    END RECORD,
    g_azf_t         RECORD
                       azf01 LIKE azf_file.azf01    #系列
                    END RECORD,
    g_ima1007_t       LIKE ima_file.ima1007,        #系列  (舊值)
    g_ima        DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
        ima09         LIKE ima_file.ima09,          #系列
        ima1007       LIKE ima_file.ima1007,        #型號
        ima01         LIKE ima_file.ima01,          #料號
        ima021        LIKE ima_file.ima021,         #規格
        imaud02       LIKE ima_file.imaud02         #自製率
                    END RECORD,
    g_ima_t         RECORD                       #程式變數(Program Variables)
        ima09         LIKE ima_file.ima09,          #系列
        ima1007       LIKE ima_file.ima1007,        #型號
        ima01         LIKE ima_file.ima01,          #料號
        ima021        LIKE ima_file.ima021,         #規格
        imaud02       LIKE ima_file.imaud02         #自製率
                    END RECORD,
    g_wc,g_wc2,g_sql     STRING,                      
    g_flag          LIKE type_file.chr1,              
    g_rec_b         LIKE type_file.num5,              #單身筆數                  
    l_ac            LIKE type_file.num5               #目前處理的ARRAY CNT        
DEFINE p_row,p_col     LIKE type_file.num5            
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10         
DEFINE   l_cnt          LIKE type_file.num10         
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose 
DEFINE   g_msg          LIKE ze_file.ze03            
DEFINE   g_row_count    LIKE type_file.num10         
DEFINE   g_curs_index   LIKE type_file.num10         
DEFINE   g_jump         LIKE type_file.num10         
DEFINE   mi_no_ask      LIKE type_file.num5         
DEFINE l_cmd       STRING
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CIM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   #刪除與建立暫存檔
   DROP TABLE r001_cimi001
   SELECT ima01,ima021,ima09,ima1007,imaud02 FROM view_self_maker INTO TEMP r001_cimi001 
 
   LET g_forupd_sql = "SELECT * FROM azf_file WHERE azf01 = ? AND azf02='D' FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW i001_w WITH FORM "cim/42f/cimi001"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
   CALL g_ima.clear()
 
 
   CALL i001_menu()
   CLOSE WINDOW i001_w                 #結束畫面
   DROP TABLE r001_cimi001
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i001_cs()
   DEFINE lc_qbe_sn  LIKE gbm_file.gbm01  
   DEFINE l_msg      LIKE ze_file.ze03       
 
   CLEAR FORM                             #清除畫面
   CALL g_ima.clear()
   CALL cl_set_head_visible("","YES")    
   
   INITIALIZE g_azf.* TO NULL   
      CONSTRUCT BY NAME g_wc ON azf01
              
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               
       ON ACTION controlp
          CASE
           WHEN INFIELD(azf01) #系列
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_azf"
             LET g_qryparam.arg1     = "D"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO azf01
             NEXT FIELD azf01
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
 
      CONSTRUCT g_wc2 ON ima09
           FROM s_ima[1].ima09
      BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)

      ON ACTION controlp
         CASE
         WHEN INFIELD(ima1007) #型號
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="cq_ima1007"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima1007
              NEXT FIELD ima1007
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
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
   IF cl_null(g_wc) THEN LET g_wc = "1=1" END IF
   IF cl_null(g_wc2) THEN LET g_wc2 = "1=1" END IF
 
   
      LET g_sql = "SELECT DISTINCT azf01 FROM azf_file ",
                  " WHERE azf02='D' AND azfacti='Y' AND azf01 LIKE '0%' AND ", g_wc CLIPPED
                  
 
   PREPARE i001_prepare FROM g_sql
   DECLARE i001_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i001_prepare
 
   IF g_wc2 = " 1=1" THEN         # 取合乎條件筆數
      LET g_sql="SELECT COUNT(azf01) FROM azf_file WHERE azf02='D' AND azfacti='Y' AND azf01 LIKE '0%' AND ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(azf01) FROM azf_file ",
                "   LEFT JOIN ima_file on ima09=azf01 AND ima01 LIKE '0%' and imaud02 >'0'",
                " WHERE ",
                "   azf02='D' and azfacti='Y' ",
                " AND azf01 LIKE '0%' AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i001_precount FROM g_sql
   DECLARE i001_count CURSOR FOR i001_precount
 
END FUNCTION
 
FUNCTION i001_menu()
 
   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i001_out()
            END IF
            
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','')
            END IF

      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i001_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ima.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i001_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_azf.* TO NULL
      RETURN
   END IF
 
   OPEN i001_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_azf.* TO NULL
      CALL i001_b()
   ELSE
      OPEN i001_count
      FETCH i001_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i001_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i001_fetch(p_flag)
DEFINE
       p_flag          LIKE type_file.chr1,        #處理方式    
       l_occuser       LIKE occ_file.occuser
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i001_cs INTO g_azf.azf01
      WHEN 'P' FETCH PREVIOUS i001_cs INTO g_azf.azf01
      WHEN 'F' FETCH FIRST    i001_cs INTO g_azf.azf01
      WHEN 'L' FETCH LAST     i001_cs INTO g_azf.azf01
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
            FETCH ABSOLUTE g_jump i001_cs INTO g_azf.azf01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode  THEN
      LET g_msg=g_azf.azf01 CLIPPED
      CALL cl_err(g_msg,SQLCA.sqlcode,0)
      INITIALIZE g_azf.* TO NULL               
      RETURN
   END IF
 

      SELECT DISTINCT azf01  
        INTO g_azf.azf01            
        FROM azf_file WHERE azf01 = g_azf.azf01
      IF SQLCA.sqlcode THEN
         LET g_msg=g_azf.azf01 CLIPPED
         CALL cl_err3("sel","azf_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         INITIALIZE g_azf.* TO NULL
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
      
 
 
   CALL i001_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i001_show()
  DEFINE l_msg   LIKE ze_file.ze03  
  DEFINE l_azf03 LIKE azf_file.azf03 
 
   LET g_azf_t.* = g_azf.*              #保存單頭舊值

   SELECT azf03 INTO l_azf03 FROM azf_file
    WHERE azf01 = g_azf_t.azf01
      AND azf02 = 'D'
   
   DISPLAY l_azf03 TO azf03  
   DISPLAY BY NAME   g_azf.azf01      # 顯示單頭值
 
   CALL i001_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                
END FUNCTION
 
FUNCTION i001_b()
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
 
    IF cl_null(g_azf.azf01) THEN
       RETURN
    END IF
  
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ima09,tc_aaf01,tc_aaf02,ima021,imaud02 ",
                       "  FROM ima_file ",
                       "  LEFT JOIN tc_aaf_file ON tc_aaf01 = ima1007 AND tc_aaf02 = ima01 ",
                       " WHERE ima1007=?  AND ima01=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    #LET l_allow_insert = cl_detail_input_auth("insert")
    #LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ima WITHOUT DEFAULTS FROM s_ima.*
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
              LET g_ima_t.* = g_ima[l_ac].*  #BACKUP
 
              OPEN i001_bcl USING g_ima_t.ima1007,g_ima_t.ima01
              IF STATUS THEN
                 CALL cl_err("OPEN i001_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i001_bcl INTO g_ima[l_ac].*
                 IF SQLCA.sqlcode THEN
                  #  LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
 
        BEFORE FIELD ima01                       #料號
           LET g_ima[l_ac].ima1007 = g_ima_t.ima1007
           DISPLAY BY NAME g_ima[l_ac].ima1007

        AFTER FIELD ima01
           IF NOT cl_null(g_ima[l_ac].ima01) THEN
              SELECT ima021,imaud02 INTO g_ima[l_ac].ima021,g_ima[l_ac].imaud02
                FROM ima_file
               WHERE ima01 = g_ima[l_ac].ima01
              IF cl_null(g_ima[l_ac].ima021) THEN
                 NEXT FIELD ima01
              END IF
           END IF 
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ima[l_ac].* = g_ima_t.*
              CLOSE i001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ima[l_ac].ima01,-263,1)
              LET g_ima[l_ac].* = g_ima_t.*
           ELSE UPDATE tc_aaf_file 
                   SET tc_aaf02=g_ima[l_ac].ima01
               WHERE tc_aaf01=g_ima_t.ima1007
              IF SQLCA.SQLERRD[3]=0 THEN
                 INSERT INTO tc_aaf_file VALUES(g_ima_t.ima1007,g_ima[l_ac].ima01)
                 LET g_ima[l_ac].* = g_ima_t.*
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
                 LET g_ima[l_ac].* = g_ima_t.*
              ELSE
                 CALL g_ima.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              END IF
              CLOSE i001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac         
           CLOSE i001_bcl
           COMMIT WORK
       
        ON ACTION controlp
           CASE

           WHEN INFIELD(ima01)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_ima01"
             CALL cl_create_qry() RETURNING g_ima[l_ac].ima01
             DISPLAY BY NAME g_ima[l_ac].ima01
             NEXT FIELD ima01
           
           WHEN INFIELD(ima1007) #型號
             CALL cl_init_qry_var()
             LET g_qryparam.form ="cq_ima1007"
             CALL cl_create_qry() RETURNING g_ima[l_ac].ima1007
             DISPLAY BY NAME g_ima[l_ac].ima1007
             NEXT FIELD ima1007
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(ima01) AND l_ac > 1 THEN
              LET g_ima[l_ac].* = g_ima[l_ac-1].*
              SELECT max(ima01)+1
                INTO g_ima[l_ac].ima01
                FROM ima_file
               WHERE ima1007 = g_ima_t.ima1007
              NEXT FIELD ima01
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
 
    CLOSE i001_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i001_b_askkey()
DEFINE
    l_wc2           STRING
 
    CONSTRUCT l_wc2 ON ima1007
                  FROM s_ima.ima1007
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
 
    CALL i001_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i001_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           STRING,
   l_flag          LIKE type_file.chr1          
 
   LET g_sql = "SELECT DISTINCT a.ima09,a.ima1007,b.tc_aaf02,'',''  ",
              #"SELECT DISTINCT a.ima09,a.ima1007,b.ima01,b.ima021,b.imaud02 ",
               " FROM ima_file a  ",
               " LEFT JOIN tc_aaf_file b ON a.ima01=b.tc_aaf02 AND a.ima1007=b.tc_aaf01 ",
               " WHERE a.ima09 = '",g_azf.azf01,"' AND a.ima1007 IS NOT NULL AND a.imaacti='Y'  ",
               " ORDER BY a.ima1007"
   PREPARE i001_pb FROM g_sql
   DECLARE tc_aaa_cs CURSOR FOR i001_pb
 
   CALL g_ima.clear()
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH tc_aaa_cs INTO g_ima[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

     # SELECT ima01,ima021,imaud02
     #   INTO g_ima[g_cnt].ima01,g_ima[g_cnt].ima021,g_ima[g_cnt].imaud02
     #  FROM r001_cimi001
     #  WHERE ima1007 = g_ima[g_cnt].ima1007 AND ima09 = g_ima[g_cnt].ima09
      SELECT ima021,imaud02
        INTO g_ima[g_cnt].ima021,g_ima[g_cnt].imaud02
        FROM ima_file
       WHERE ima01 = g_ima[g_cnt].ima01

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ima.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ima TO s_ima.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
      LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL i001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 
 
      ON ACTION jump
         CALL i001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                   
 
 
      ON ACTION next
         CALL i001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
 
 
      ON ACTION last
         CALL i001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                   
 
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
 
 
 
FUNCTION i001_out()
DEFINE
   l_i             LIKE type_file.num5,          
   sr              RECORD
       ima1007    LIKE ima_file.ima1007,          #
       ima01    LIKE ima_file.ima01,
       ima021    LIKE ima_file.ima021, 
       imaud02    LIKE ima_file.imaud02
                   END RECORD,
   l_name          LIKE type_file.chr20,         #External(Disk) file name 
   l_za05          LIKE za_file.za05             
DEFINE l_cmd       STRING
 
 
#No.FUN-820002--start--
   IF cl_null(g_wc) AND NOT cl_null(g_ima_t.ima1007) THEN                                                                               
      LET g_wc = " ima09 = '",g_ima_t.ima09,"' "                                                                                      
   END IF                                                                                                                           
   IF cl_null(g_wc2) THEN                                                                                                           
       LET g_wc2 = " 1=1"                                                                                                           
   END IF
 
   #報表轉為使用 p_query                                                                                                            
   LET l_cmd = 'p_query "cimi001" "',g_wc2 CLIPPED,'"'                                        
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN 
 

END FUNCTION
 
