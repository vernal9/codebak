# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cooi500.4gl
# Descriptions...: 多營運化學品基本資料表
# Date & Author..: 2023/08/04 By momo


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE
    tm              RECORD
     azp01          LIKE azp_file.azp01
                    END RECORD, 
     g_tc_ghs           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_ghs01       LIKE tc_ghs_file.tc_ghs01,   
        tc_ghs02       LIKE tc_ghs_file.tc_ghs02,   
        tc_ghs03       LIKE tc_ghs_file.tc_ghs03,   
        tc_ghs04       LIKE tc_ghs_file.tc_ghs04,   
        tc_ghs05       LIKE tc_ghs_file.tc_ghs05
                    END RECORD,
    g_tc_ghs_t         RECORD                      #程式變數 (舊值)
        tc_ghs01       LIKE tc_ghs_file.tc_ghs01,   
        tc_ghs02       LIKE tc_ghs_file.tc_ghs02,   
        tc_ghs03       LIKE tc_ghs_file.tc_ghs03,   
        tc_ghs04       LIKE tc_ghs_file.tc_ghs04,  
        tc_ghs05       LIKE tc_ghs_file.tc_ghs05
                    END RECORD,
    g_wc2           STRING,
    g_wc            STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                #單身筆數  
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  
 
DEFINE g_forupd_sql STRING                              #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     #count/index 
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5      
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING                      
DEFINE l_n          LIKE type_file.num5

MAIN

    DEFINE p_row,p_col   LIKE type_file.num5    
 
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
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time    
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i500_w AT p_row,p_col WITH FORM "cim/42f/cimi500"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
 
    CALL cl_ui_init()
    LET g_wc2 = " 1=1 "
    LET tm.azp01 = g_plant
     
    DISPLAY tm.azp01 TO azp01
    CALL i500_b_fill(g_wc2)
    CALL i500_menu()
    CLOSE WINDOW i500_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
         RETURNING g_time 
END MAIN
 
FUNCTION i500_menu()
 
   WHILE TRUE
      CALL i500_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i500_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i500_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i500_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_ghs),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i500_q()
   CALL i500_b_askkey()
END FUNCTION
 
FUNCTION i500_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT     
    l_n             LIKE type_file.num5,                 #檢查重複用             
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否            
    p_cmd           LIKE type_file.chr1,                 #處理狀態               
    l_allow_insert  LIKE type_file.chr1,                 #可新增否
    l_allow_delete  LIKE type_file.chr1,                 #可刪除否
    v               string
 
    
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT tc_ghs01,tc_ghs02,tc_ghs03,tc_ghs04,tc_ghs05 ",  
                       "  FROM ",cl_get_target_table(tm.azp01,'tc_ghs_file'),
                       " WHERE tc_ghs01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_tc_ghs WITHOUT DEFAULTS FROM s_tc_ghs.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF

       IF g_plant <> tm.azp01 THEN
          CALL cl_err('','apm-012',1)
          EXIT INPUT
       END IF
     
 
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
        LET g_on_change = TRUE         
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
                                                       
           LET g_before_input_done = FALSE                                      
           CALL i500_set_entry(p_cmd)                                           
           CALL i500_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
             
           LET g_tc_ghs_t.* = g_tc_ghs[l_ac].*  #BACKUP
           OPEN i500_bcl USING g_tc_ghs_t.tc_ghs01
           IF STATUS THEN
              CALL cl_err("OPEN i500_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i500_bcl INTO g_tc_ghs[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_tc_ghs_t.tc_ghs01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
          
           CALL cl_show_fld_cont()    
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'                                                         
         LET g_before_input_done = FALSE                                        
         CALL i500_set_entry(p_cmd)                                             
         CALL i500_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
         INITIALIZE g_tc_ghs[l_ac].* TO NULL     
         LET g_tc_ghs_t.* = g_tc_ghs[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     
         NEXT FIELD tc_ghs01
 
     AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i500_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                   
 
        INSERT INTO tc_ghs_file(tc_ghs01,tc_ghs02,tc_ghs03,tc_ghs04,tc_ghs05)            
               VALUES(g_tc_ghs[l_ac].tc_ghs01,g_tc_ghs[l_ac].tc_ghs02,
               g_tc_ghs[l_ac].tc_ghs03,g_tc_ghs[l_ac].tc_ghs04,                      
               g_tc_ghs[l_ac].tc_ghs05)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","tc_ghs_file",g_tc_ghs[l_ac].tc_ghs01,"",SQLCA.sqlcode,"","",1)  
           ROLLBACK WORK             
           CANCEL INSERT
        ELSE 
           COMMIT WORK            
        END IF
 
     AFTER FIELD tc_ghs01                        #check 名稱是否重複
        IF NOT cl_null(g_tc_ghs[l_ac].tc_ghs01) THEN
           IF g_tc_ghs[l_ac].tc_ghs01 != g_tc_ghs_t.tc_ghs01 OR
              g_tc_ghs_t.tc_ghs01 IS NULL THEN
              SELECT count(*) INTO l_n FROM tc_ghs_file
               WHERE tc_ghs01 = g_tc_ghs[l_ac].tc_ghs01
              IF l_n > 0 THEN
                  LET g_tc_ghs[l_ac].tc_ghs01 = g_tc_ghs_t.tc_ghs01
                  NEXT FIELD tc_ghs01
              END IF
           END IF
        END IF

 
     BEFORE DELETE                            #是否取消單身
         IF g_tc_ghs_t.tc_ghs01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK     
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                
            LET g_doc.column1 = "tc_ghs01"               
            LET g_doc.value1 = g_tc_ghs[l_ac].tc_ghs01      
            CALL cl_del_doc()                                         
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK     
               CANCEL DELETE 
            END IF 
            
            IF (NOT cl_del_itemname("tc_ghs_file","tc_ghs01", g_tc_ghs_t.tc_ghs01)) THEN 
               ROLLBACK WORK
               RETURN
            END IF
           
            DELETE FROM tc_ghs_file WHERE tc_ghs01 = g_tc_ghs_t.tc_ghs01
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","tc_ghs_file",g_tc_ghs_t.tc_ghs01,"",SQLCA.sqlcode,"","",1)  
                ROLLBACK WORK     
                CANCEL DELETE
                EXIT INPUT
            END IF
              
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_tc_ghs[l_ac].* = g_tc_ghs_t.*
          CLOSE i500_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF

        IF l_lock_sw="Y" THEN
           CALL cl_err(g_tc_ghs[l_ac].tc_ghs01,-263,0)
           LET g_tc_ghs[l_ac].* = g_tc_ghs_t.*
        ELSE
           UPDATE tc_ghs_file 
              SET tc_ghs02=g_tc_ghs[l_ac].tc_ghs02,
                  tc_ghs03=g_tc_ghs[l_ac].tc_ghs03,
                  tc_ghs04=g_tc_ghs[l_ac].tc_ghs04,  
                  tc_ghs05=g_tc_ghs[l_ac].tc_ghs05                                
           WHERE tc_ghs01 = g_tc_ghs_t.tc_ghs01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","tc_ghs_file",g_tc_ghs_t.tc_ghs01,"",SQLCA.sqlcode,"","",1)  
              ROLLBACK WORK   
              LET g_tc_ghs[l_ac].* = g_tc_ghs_t.*
           ELSE
 
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()            # 新增
 
        IF INT_FLAG THEN                 
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_tc_ghs[l_ac].* = g_tc_ghs_t.*
        
           ELSE
              CALL g_tc_ghs.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
          
           END IF
           CLOSE i500_bcl                # 新增
           ROLLBACK WORK                 # 新增
           EXIT INPUT
         END IF
         LET l_ac_t = l_ac                       
         CLOSE i500_bcl                # 新增
         COMMIT WORK
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tc_ghs01) AND l_ac > 1 THEN
             LET g_tc_ghs[l_ac].* = g_tc_ghs[l_ac-1].*
             NEXT FIELD tc_ghs01
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
 
    END INPUT
 
    CLOSE i500_bcl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i500_b_askkey()
    CLEAR FORM
    CALL g_tc_ghs.clear()

    INPUT BY NAME tm.azp01 WITHOUT DEFAULTS


    AFTER FIELD azp01
      IF NOT cl_null(tm.azp01) THEN
         SELECT count(azp01) INTO l_n FROM azp_file
          WHERE azp01 = tm.azp01
         IF l_n = 0 THEN
            CALL cl_err(tm.azp01,'aap-025',0)
            NEXT FIELD azp01
         END IF
      END IF

    ON ACTION controlp
       CASE
         WHEN INFIELD(azp01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_azp01"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              LET tm.azp01 = g_qryparam.multiret
              DISPLAY BY NAME tm.azp01
              NEXT FIELD azp01
              OTHERWISE
              EXIT CASE
        END CASE

    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT

    END INPUT
      IF INT_FLAG THEN
         RETURN
      END IF
 
    CONSTRUCT g_wc2 ON tc_ghs01,tc_ghs02,tc_ghs03,tc_ghs04,tc_ghs05                
         FROM s_tc_ghs[1].tc_ghs01,s_tc_ghs[1].tc_ghs02,s_tc_ghs[1].tc_ghs03,                                   
              s_tc_ghs[1].tc_ghs04,s_tc_ghs[1].tc_ghs05

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
      LET g_rec_b = 0   
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL i500_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i500_b_fill(p_wc2)             
 
    DEFINE p_wc2           STRING

    CALL g_tc_ghs.clear()
 
       LET g_sql = "SELECT tc_ghs01,tc_ghs02,tc_ghs03,tc_ghs04,tc_ghs05 ",   
                   " FROM ",
                   cl_get_target_table(tm.azp01,'tc_ghs_file'),
                   " WHERE  ", p_wc2 CLIPPED,           #單身
                   " ORDER BY 1" 

       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,tm.azp01) RETURNING g_sql
 
       PREPARE i500_pb FROM g_sql
       DECLARE tc_ghs_curs CURSOR FOR i500_pb
 
       LET g_cnt = 1
       MESSAGE "Searching!" 
       FOREACH tc_ghs_curs INTO g_tc_ghs[g_cnt].*   #單身 ARRAY 填充
           IF STATUS THEN
              CALL cl_err('foreach:',STATUS,1)
              EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
       END FOREACH
    CALL g_tc_ghs.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2

    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
  
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               
   LET g_curs_index = 0              
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_ghs TO s_tc_ghs.* ATTRIBUTE(COUNT=g_rec_b)
 
    
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
   
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
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
 
   
#@    ON ACTION 相關文件  
       ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      
      AFTER DISPLAY
         CONTINUE DISPLAY    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i500_out()
    DEFINE
        l_tc_ghs           RECORD LIKE tc_ghs_file.*,
        l_i             LIKE type_file.num5,   
        l_name          LIKE type_file.chr20,               
        l_za05          LIKE type_file.chr1000            
    IF g_wc2 IS NULL THEN 
  
       CALL cl_err('','9057',0)
      RETURN
    END IF
    CALL cl_wait()

    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM tc_ghs_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED

    LET g_str=''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog 
        IF g_zz05='Y' THEN 

           CALL cl_wcchp(g_wc2,'tc_ghs01,tc_ghs02,tc_ghs03,tc_ghs04,tc_ghs05')  
             RETURNING g_wc2  
        END IF
        LET g_str=g_wc2    
         CALL cl_prt_cs1("aooi500","aooi500",g_sql,g_str)   
 
END FUNCTION

                                                    
FUNCTION i500_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1         
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("tc_ghs01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i500_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1          
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("tc_ghs01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION       