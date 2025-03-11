# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cpmt004.4gl
# Descriptions...: 採購未交排程維護作業
# Input parameter: 
# Date & Author..: 2025/02/17 By Momo

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_pmc01         LIKE pmc_file.pmc01,   #供應商編號
    g_ima06         LIKE ima_file.ima06,   #分群碼
    g_pmn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pmn01       LIKE pmn_file.pmn01,   #採購單號
        pmn04       LIKE pmn_file.pmn04,   #採購料號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        pmn20       LIKE pmn_file.pmn20,   #採購數量
        pmn50       LIKE pmn_file.pmn50,   #未交量
        pmn33       LIKE pmn_file.pmn33,   #交貨日
        bmb01       LIKE bmb_file.bmb10,   #完工料件
        img10       LIKE img_file.img10    #庫存狀況
                    END RECORD,
    g_pmn_t         RECORD                 #程式變數 (舊值)
        pmn01       LIKE pmn_file.pmn01,   #採購單號
        pmn04       LIKE pmn_file.pmn04,   #採購料號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        pmn20       LIKE pmn_file.pmn20,   #採購數量
        pmn50       LIKE pmn_file.pmn50,   #未交量
        pmn33       LIKE pmn_file.pmn33,   #交貨日
        bmb01       LIKE bmb_file.bmb10,   #完工料件
        img10       LIKE img_file.img10    #庫存狀況
                    END RECORD,
    g_argv1         LIKE pmn_file.pmn02,
    g_ss            LIKE type_file.chr1,   
    g_wc,g_sql     STRING, 
    g_rec_b         LIKE type_file.num5,   #單身筆數             
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT 
DEFINE p_row,p_col  LIKE type_file.num5    
 
#主程式開始
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL 
DEFINE g_before_input_done  LIKE type_file.num5          
 
DEFINE   g_cnt           LIKE type_file.num10            
DEFINE   g_i             LIKE type_file.num5             #count/index for any purpose   
DEFINE   g_msg           LIKE type_file.chr1000          
#為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         
DEFINE   g_curs_index   LIKE type_file.num10         
DEFINE   g_jump         LIKE type_file.num10        
DEFINE   mi_no_ask      LIKE type_file.num5         
DEFINE   l_sql          STRING                       
DEFINE   g_str          STRING                      
DEFINE   l_table        STRING                      
DEFINE   l_table1       STRING                     
DEFINE   g_flag         LIKE type_file.chr1  


MAIN
   
     OPTIONS
         INPUT NO WRAP
     DEFER INTERRUPT
   
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("CPM")) THEN
       EXIT PROGRAM
    END IF
  
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
  
    LET g_pmc01 = NULL                   #消除鍵值
    LET g_ima06 = NULL
    LET g_argv1 = ARG_VAL(1)
 
    LET p_row = 2 LET p_col = 12
 
    OPEN WINDOW t004_w AT p_row,p_col
         WITH FORM "cpm/42f/cpmt004" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
  
    CALL t004_menu()
 
    CLOSE WINDOW t004_w                   #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
         RETURNING g_time                 
 
END MAIN     
 
#QBE 查詢資料
FUNCTION t004_curs()
    CLEAR FORM                            #清除畫面
    CALL g_pmn.clear()
    CALL cl_set_head_visible("","YES")      
 
    IF NOT cl_null(g_argv1) THEN 
       LET g_pmc01 =  g_argv1
 
   INITIALIZE g_pmc01 TO NULL   
   INITIALIZE g_ima06 TO NULL   
       CONSTRUCT g_wc ON pmc01,
                         ima06,
                         pmn01,pmn04,pmn33   #螢幕上取條件 
                    FROM pmc01,ima06,
                         s_pmn[1].pmn01,s_pmn[1].pmn04,s_pmn[1].pmn33                 
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
            ON ACTION controlp
               CASE                
                  WHEN INFIELD(pmn01) #採購單號
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_pmn04"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO pmn01 
                       NEXT FIELD pmn01
                  WHEN INFIELD(pmn04) #產品名稱
                       CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO pmn04
                       NEXT FIELD pmn04
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
             LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmnuser', 'pmngrup') 
 
             LET g_wc = g_wc CLIPPED," AND pmc01 ='",g_argv1,"'"
 
             IF INT_FLAG THEN RETURN END IF
 
    ELSE 
        CONSTRUCT g_wc ON pmc01,ima06,                                  
                          pmn01,pmn04,pmn33
            FROM pmc01,ima06,                                     
                 s_pmn[1].pmn01,s_pmn[1].pmn04,s_pmn[1].pmn33
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

            AFTER FIELD pmc01
               LET g_pmc01 = GET_FLDBUF(pmc01)
               IF NOT cl_null(g_pmc01) THEN
                  SELECT pmm09 INTO g_pmc01 FROM pmm_file
                   WHERE pmm09 = g_pmc01
                  LET g_wc = g_wc CLIPPED," AND pmm09 ='",g_pmc01,"'"
               END IF

            ON ACTION controlp
               CASE
                  WHEN INFIELD(pmn04) #產品名稱
                        CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO pmn04
                       NEXT FIELD pmn04
                  WHEN INFIELD(pmn01) #採購編號
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_pmn04"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO pmn01
                       NEXT FIELD pmn01
          
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
    END IF  
    LET g_sql= "SELECT UNIQUE pmm09 FROM pmm_file ",
               " LEFT JOIN pmc_file ON pmc01 = pmm09 ", 
               " WHERE pmm18='Y' AND ", g_wc CLIPPED,
               " ORDER BY pmm09 "
    PREPARE t004_prepare FROM g_sql      #預備一下
    DECLARE t004_b_curs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t004_prepare
    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE x
    LET g_sql = "SELECT COUNT(DISTINCT pmn02) FROM pmn_file",
                " LEFT JOIN pmm_file ON pmm01 = pmn01 ",
                " WHERE ",g_wc CLIPPED
    PREPARE t004_precount FROM g_sql
    DECLARE t004_count CURSOR FOR t004_precount
END FUNCTION
 
FUNCTION t004_menu()
 
   WHILE TRUE
      CALL t004_bp("G")
      CASE g_action_choice
       
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t004_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t004_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL t004_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmn),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION
 
 
#Query 查詢
FUNCTION t004_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pmc01 TO NULL              
    INITIALIZE g_ima06 TO NULL              
 
    CALL cl_opmsg('q')
 
    MESSAGE ""                               
    CLEAR FORM                               
    CALL g_pmn.clear()
 
    CALL t004_curs()                         #取得查詢條件
 
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
 
    OPEN t004_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                    #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_pmc01 TO NULL       
       INITIALIZE g_ima06 TO NULL       
    ELSE
       CALL t004_fetch('F')            #讀出TEMP第一筆並顯示
       OPEN t004_count
       FETCH t004_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t004_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式       
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t004_b_curs INTO g_pmc01
        WHEN 'P' FETCH PREVIOUS t004_b_curs INTO g_pmc01
        WHEN 'F' FETCH FIRST    t004_b_curs INTO g_pmc01
        WHEN 'L' FETCH LAST     t004_b_curs INTO g_pmc01
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
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF 
            FETCH ABSOLUTE g_jump t004_b_curs INTO g_pmc01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_pmc01,SQLCA.sqlcode,0)
       INITIALIZE g_pmc01 TO NULL  
    ELSE
 
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL t004_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t004_show()
 
 
    CALL t004_b_fill(g_wc)                 #單身
 
    CALL cl_show_fld_cont()                 
END FUNCTION

#單身
FUNCTION t004_b()
DEFINE
    l_imaacti       LIKE ima_file.imaacti, 
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,                #檢查重複用        
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
    p_cmd           LIKE type_file.chr1,                #處理狀態          
    l_allow_insert  LIKE type_file.num5,                #可新增否          
    l_allow_delete  LIKE type_file.num5                #可刪除否          
DEFINE   l_cnt      LIKE type_file.num10     
 
    LET g_action_choice = ""
 
    IF cl_null(g_pmc01) THEN 
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
        "SELECT pmn01,pmn04,'','',pmn20,pmn50,pmn33,'',0 ",                           
        "        FROM pmn_file ",          
        " WHERE pmn01 = ?  FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t004_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pmn WITHOUT DEFAULTS FROM s_pmn.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEn
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK    
            
            IF g_rec_b >= l_ac THEN
 
               LET p_cmd='u'
               LET g_pmn_t.* = g_pmn[l_ac].*  #BACKUP
 
               OPEN t004_bcl USING g_pmn_t.pmn01
               IF STATUS THEN
                  CALL cl_err("OPEN t004_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t004_bcl INTO g_pmn_t.* 
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_pmn_t.pmn04,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      LET g_pmn_t.*=g_pmn[l_ac].*
                  END IF
               END IF
               CALL cl_show_fld_cont()    
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_pmn[l_ac].* TO NULL      
          
            LET g_pmn_t.* = g_pmn[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD pmn01
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
           
            INSERT INTO pmn_file(pmn02,pmn01,pmn03,ta_pmn01,ta_pmn02, 
                                 ta_pmn03,                            
                                 pmn04,pmn05,pmn07,pmn08,      
                                 pmn09,pmn15,             
                                 pmn11,pmn12,pmn13,pmn14,  
                                 pmnoriu,pmnorig,pmnuser,pmngrup,pmnmodu,pmndate,pmnacti) 
                          VALUES(g_pmn02,
                                 g_pmn[l_ac].pmn01,g_pmn[l_ac].pmn03,
                                 g_pmn[l_ac].ta_pmn01,g_pmn[l_ac].ta_pmn02,                        
                                 g_pmn[l_ac].ta_pmn03,                                            
                                 g_pmn[l_ac].pmn04,g_pmn[l_ac].pmn05,
                                 g_pmn[l_ac].pmn07,g_pmn[l_ac].pmn08,
                                 g_pmn[l_ac].pmn09,g_pmn[l_ac].pmn15,  
                                 l_pmn11,l_pmn12,l_pmn13,l_pmn14,
                                 g_user, g_grup,                                              
                                 g_pmn[l_ac].pmnuser,g_pmn[l_ac].pmngrup,g_pmn[l_ac].pmnmodu,  
                                 g_pmn[l_ac].pmndate,g_pmn[l_ac].pmnacti)                      
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","pmn_file",g_pmn02,g_pmn[l_ac].pmn01,SQLCA.sqlcode,"","",1)  
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2   
            END IF
 
        AFTER FIELD pmn01 
            IF NOT cl_null(g_pmn[l_ac].pmn01) THEN 
               IF NOT s_chk_item_no(g_pmn[l_ac].pmn01,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_pmn[l_ac].pmn01= g_pmn_t.pmn01
                  NEXT FIELD  pmn01
               END IF
               IF cl_null(g_pmn[l_ac].pmn03) THEN 
                   LET g_pmn[l_ac].pmn03 = g_pmn[l_ac].pmn01
                   DISPLAY BY NAME g_pmn[l_ac].pmn03  
               END IF
              
               SELECT ima02,ima021,ima31,imaacti   
                 INTO g_pmn[l_ac].ima02,g_pmn[l_ac].ima021,g_pmn[l_ac].pmn07,
                      l_imaacti   
                 FROM ima_file
                WHERE ima01 = g_pmn[l_ac].pmn01
               IF STATUS THEN
                  CALL cl_err3("sel","ima_file",g_pmn[l_ac].pmn01,"",STATUS,"","select ima",1)  
                  NEXT FIELD pmn01
               END IF
               IF l_imaacti = 'N' THEN
                  CALL cl_err(g_pmn[l_ac].pmn01,'axm-890',1)
                  NEXT FIELD pmn01
               END IF 
               IF NOT t004_pmn09_check() THEN 
                  LET g_pmn07_t = g_pmn[l_ac].pmn07
                  NEXT FIELD pmn09
               END IF
               LET g_pmn07_t = g_pmn[l_ac].pmn07
            END IF
 

 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pmn[l_ac].* = g_pmn_t.*
               CLOSE t004_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_pmn[l_ac].pmn01,-263,1)
               LET g_pmn[l_ac].* = g_pmn_t.*
            ELSE
               UPDATE pmn_file SET
                                   pmnacti=g_pmn[l_ac].pmnacti  
                WHERE pmn01 = g_pmn_t.pmn01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","pmn_file",g_pmn_t.pmn01,SQLCA.sqlcode,"","",1) 
                 LET g_pmn[l_ac].* = g_pmn_t.*
                 ROLLBACK WORK
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
                  LET g_pmn[l_ac].* = g_pmn_t.*
               ELSE
                  CALL g_pmn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               CLOSE t004_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   
            CLOSE t004_bcl
            COMMIT WORK
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(pmn04) #產品名稱
                   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                   CALL t004_pmn04()
                   CALL t004_b_fill(" 1=1")
                   COMMIT WORK
                   LET g_flag = TRUE
                   EXIT INPUT

            END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pmn01) AND l_ac > 1 THEN
               LET g_pmn[l_ac].* = g_pmn[l_ac-1].*
               NEXT FIELD pmn01
            END IF
 
        ON ACTION controls                              
           CALL cl_set_head_visible("","AUTO")          
 
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
 
    
    END INPUT

    IF g_flag THEN
       LET g_flag = FALSE
       CALL t004_b()
    END IF

 
END FUNCTION
   
FUNCTION t004_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000  
 
    CONSTRUCT g_wc ON pmn01,pmn03,ta_pmn01,ta_pmn02,         #180913 add ta_pmn01,ta_pmn02 by ruby
                      ta_pmn03,                              #20190326
                      pmn04,pmn05,pmn07,pmn08,pmn09,pmn15    #螢幕上取條件  #FUN-G90009 add pmn15
        FROM s_pmn[1].pmn01,s_pmn[1].pmn03,s_pmn[1].ta_pmn01,s_pmn[1].ta_pmn02,   #180913 add ta_pmn01,ta_pmn02 by ruby
             s_pmn[1].ta_pmn03,                              #20190326
             s_pmn[1].pmn04,s_pmn[1].pmn05,                   
             s_pmn[1].pmn07,s_pmn[1].pmn08,s_pmn[1].pmn09,s_pmn[1].pmn15  #FUN-G90009 add pmn15 
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
 
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
    CALL t004_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION t004_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       
 
    LET g_sql =
               "SELECT pmn01,pmn04,ima02,ima021,pmn20,pmn20-pmn53+pmn58,pmn33,'',0 ", 
               " FROM ima_file,pmn_file ",
               " LEFT JOIN pmm_file ON pmm01 = pmn01 ",        
               " WHERE pmn04=ima01 AND pmn16 in ('1','2')",
               "   AND pmn20-pmn53+pmn58 > 0　AND　",p_wc CLIPPED ,
               " ORDER BY pmn33 "
    PREPARE t004_p2 FROM g_sql      #預備一下
    DECLARE pmn_curs CURSOR FOR t004_p2
 
    CALL g_pmn.clear()
    LET g_cnt = 1
 
    FOREACH pmn_curs INTO g_pmn[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     
    END FOREACH
    CALL g_pmn.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2      
    
END FUNCTION
 
FUNCTION t004_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                  
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
     
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      
      ON ACTION first 
         CALL t004_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY               
                               
      ON ACTION previous
         CALL t004_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                  
                              
 
      ON ACTION jump 
         CALL t004_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
                              
 
      ON ACTION next
         CALL t004_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                 
                              
 
      ON ACTION last 
         CALL t004_fetch('L')
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                            
         CALL cl_set_head_visible("","AUTO")          
 
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
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 


