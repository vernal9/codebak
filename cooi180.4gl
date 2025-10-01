# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cooi180.4gl
# Descriptions...: 待辦清單維護作業
# Date & Author..: 2025/08/04 By momo
# Modify 		 : 


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 

    g_tc_tdi        DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_tdi01     LIKE tc_tdi_file.tc_tdi01,      #編號
        tc_tdi02     LIKE tc_tdi_file.tc_tdi02,      #類別
        tc_tdi03     LIKE tc_tdi_file.tc_tdi03,      #事項說明
        tc_tdi04     LIKE tc_tdi_file.tc_tdi04,      #開始日期
        tc_tdi05     LIKE tc_tdi_file.tc_tdi05,      #結束日期
        tc_tdi06     LIKE tc_tdi_file.tc_tdi06,      #週期
        tc_tdi07     LIKE tc_tdi_file.tc_tdi07,      #廠商代號  
        tc_tdi08     LIKE tc_tdi_file.tc_tdi08,      #廠商名稱
        tc_tdi09     LIKE tc_tdi_file.tc_tdi09,      #聯絡資訊  
        tc_tdi10     LIKE tc_tdi_file.tc_tdi10,      #主要窗口
        tc_tdi11     LIKE tc_tdi_file.tc_tdi11,      #次要窗口  
        tc_tdi12     LIKE tc_tdi_file.tc_tdi12,      #備註說明
        tc_tdi13     LIKE tc_tdi_file.tc_tdi13,      #處理狀態  
        tc_tdiacti   LIKE tc_tdi_file.tc_tdiacti,    #有效否
        tc_tdidate   LIKE tc_tdi_file.tc_tdidate     #修改日
                    END RECORD,
    g_tc_tdi_t         RECORD                  #程式變數 (舊值)
        tc_tdi01     LIKE tc_tdi_file.tc_tdi01,      #編號
        tc_tdi02     LIKE tc_tdi_file.tc_tdi02,      #類別
        tc_tdi03     LIKE tc_tdi_file.tc_tdi03,      #事項說明
        tc_tdi04     LIKE tc_tdi_file.tc_tdi04,      #開始日期
        tc_tdi05     LIKE tc_tdi_file.tc_tdi05,      #結束日期
        tc_tdi06     LIKE tc_tdi_file.tc_tdi06,      #週期
        tc_tdi07     LIKE tc_tdi_file.tc_tdi07,      #廠商代號  
        tc_tdi08     LIKE tc_tdi_file.tc_tdi08,      #廠商名稱
        tc_tdi09     LIKE tc_tdi_file.tc_tdi09,      #聯絡資訊  
        tc_tdi10     LIKE tc_tdi_file.tc_tdi10,      #主要窗口
        tc_tdi11     LIKE tc_tdi_file.tc_tdi11,      #次要窗口  
        tc_tdi12     LIKE tc_tdi_file.tc_tdi12,      #備註說明
        tc_tdi13     LIKE tc_tdi_file.tc_tdi13,      #處理狀態  
        tc_tdiacti   LIKE tc_tdi_file.tc_tdiacti,    #有效否
        tc_tdidate   LIKE tc_tdi_file.tc_tdidate     #修改日
                    END RECORD,
    g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_tit           LIKE type_file.chr20,             #No.FUN-680102 VARCHAR(10),
    g_tit1          LIKE type_file.chr20,             #No.FUN-680102 VARCHAR(16),
    g_rec_b         LIKE type_file.num5,              #No.FUN-680102 SMALLINT,              #單身筆數
    l_ac            LIKE type_file.num5               #No.FUN-680102 SMALLINT               #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING                            #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt        LIKE type_file.num10              #No.FUN-680102 INTEGER   
DEFINE l_cnt        LIKE type_file.num5               #
DEFINE l_table      STRING                            #No.FUN-850016                                                                    
DEFINE g_str        STRING                            #No.FUN-850016                                                                    
DEFINE g_prog1      STRING                            #No.FUN-850016    

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
  
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("COO")) THEN
      EXIT PROGRAM
   END IF
                                                                                                                      

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW i300_w WITH FORM "coo/42f/cooi180"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("cooi180")
   CALL cl_ui_init()
 
   CALL i180_b_fill(g_wc2)
 
   CALL i180_menu()
 
   CLOSE WINDOW i300_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i180_menu()
 
   WHILE TRUE
      CALL i180_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i180_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i180_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_tdi),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i180_q()
 
   CALL i180_b_askkey()
 
END FUNCTION
 
FUNCTION i180_b()
   DEFINE l_ac_t          LIKE type_file.num5,     
          l_n             LIKE type_file.num5,     
          l_lock_sw       LIKE type_file.chr1,     #單身鎖住否
          p_cmd           LIKE type_file.chr1,     #處理狀態
          l_allow_insert  LIKE type_file.num5,     #可新增否
          l_allow_delete  LIKE type_file.num5      #可刪除否
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
                     
   LET g_forupd_sql = " SELECT tc_tdi01,tc_tdi02,tc_tdi03,tc_tdi04,tc_tdi05,tc_tdi06,tc_tdi07,",
                      "        tc_tdi08,tc_tdi09,tc_tdi10,tc_tdi11,tc_tdi12,tc_tdi13,tc_tdiacti,tc_tdidate ",   
                      "        FROM tc_tdi_file ",  
                      "  WHERE tc_tdi01= ?  FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i180_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_tc_tdi WITHOUT DEFAULTS FROM s_tc_tdi.*
         ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac      = ARR_CURR()
         LET l_n       = ARR_COUNT()
         LET l_lock_sw = 'N'            #DEFAULT
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd = 'u'
            LET g_tc_tdi_t.* = g_tc_tdi[l_ac].*  #BACKUP
            OPEN i180_bcl USING g_tc_tdi_t.tc_tdi01
            IF STATUS THEN
               CALL cl_err("OPEN i180_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i180_bcl INTO g_tc_tdi[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tc_tdi_t.tc_tdi01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  UPDATE tc_tdi_file
                     SET tc_tdi01 = g_tc_tdi[l_ac].tc_tdi01,
                         tc_tdi02 = g_tc_tdi[l_ac].tc_tdi02,
                         tc_tdi03 = g_tc_tdi[l_ac].tc_tdi03,
                         tc_tdi04 = g_tc_tdi[l_ac].tc_tdi04,
                         tc_tdi05 = g_tc_tdi[l_ac].tc_tdi05,
                         tc_tdi06 = g_tc_tdi[l_ac].tc_tdi06,
                         tc_tdi07 = g_tc_tdi[l_ac].tc_tdi07,
                         tc_tdi08 = g_tc_tdi[l_ac].tc_tdi08,
                         tc_tdi09 = g_tc_tdi[l_ac].tc_tdi09,
                         tc_tdi10 = g_tc_tdi[l_ac].tc_tdi10,
                         tc_tdi11 = g_tc_tdi[l_ac].tc_tdi11,
                         tc_tdi12 = g_tc_tdi[l_ac].tc_tdi12,
                         tc_tdi13 = g_tc_tdi[l_ac].tc_tdi13,
                         tc_tdiacti = g_tc_tdi[l_ac].tc_tdiacti,
                         tc_tdidate = g_today
                   WHERE tc_tdi01 = g_tc_tdi[l_ac].tc_tdi01
                     
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","tc_tdi_file",g_tc_tdi_t.tc_tdi01,"",SQLCA.sqlcode,"","",1)
                  END IF
               
                  
               END IF
            END IF
            CALL cl_show_fld_cont()  
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_tc_tdi[l_ac].* TO NULL      
        
         LET g_tc_tdi_t.* = g_tc_tdi[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()  
         NEXT FIELD tc_tdi01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO tc_tdi_file(tc_tdi01,tc_tdi02,tc_tdi03,tc_tdi04,tc_tdi05,tc_tdi06,tc_tdi07,
                                 tc_tdi08,tc_tdi09,tc_tdi10,tc_tdi11,tc_tdi12,tc_tdi13,tc_tdiacti,tc_tdidate) 
              VALUES(g_tc_tdi[l_ac].tc_tdi01,g_tc_tdi[l_ac].tc_tdi02,g_tc_tdi[l_ac].tc_tdi03,g_tc_tdi[l_ac].tc_tdi04,
                     g_tc_tdi[l_ac].tc_tdi05,g_tc_tdi[l_ac].tc_tdi06,g_tc_tdi[l_ac].tc_tdi07,g_tc_tdi[l_ac].tc_tdi08,
                     g_tc_tdi[l_ac].tc_tdi09,g_tc_tdi[l_ac].tc_tdi10,g_tc_tdi[l_ac].tc_tdi11,g_tc_tdi[l_ac].tc_tdi12,
                     g_tc_tdi[l_ac].tc_tdi13,g_tc_tdi[l_ac].tc_tdiacti,g_today)  
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_tdi_file",g_tc_tdi[l_ac].tc_tdi01,"",SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD tc_tdi01                        #check 編號是否重複
         IF NOT cl_null(g_tc_tdi[l_ac].tc_tdi01) AND p_cmd = 'a' THEN
            IF g_tc_tdi[l_ac].tc_tdi01 != g_tc_tdi_t.tc_tdi01 
               OR g_tc_tdi_t.tc_tdi01 IS NULL THEN
               SELECT 1 INTO l_cnt FROM tc_tdi_file
                WHERE azf01 = g_tc_tdi[l_ac].tc_tdi01
                  AND rownum = 1
               IF l_cnt = 1 THEN
                  CALL cl_err(g_tc_tdi[l_ac].tc_tdi03,'atm-310',0)
                  NEXT FIELD tc_tdi01
               END IF
            END IF
         END IF

      AFTER FIELD tc_tdi04
        

 
      BEFORE DELETE                            #是否取消單身
         IF g_tc_tdi_t.tc_tdi01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM tc_tdi_file WHERE tc_tdi01 = g_tc_tdi_t.tc_tdi01
                                     
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tc_tdi_file",g_tc_tdi_t.tc_tdi01,"",SQLCA.sqlcode,"","",1) 
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tc_tdi[l_ac].* = g_tc_tdi_t.*
            CLOSE i180_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tc_tdi[l_ac].tc_tdi01,-263,1)
            LET g_tc_tdi[l_ac].* = g_tc_tdi_t.*
         ELSE
            UPDATE tc_tdi_file 
               SET tc_tdi01=g_tc_tdi[l_ac].tc_tdi01,
                   tc_tdi02=g_tc_tdi[l_ac].tc_tdi02,
                   tc_tdi03=g_tc_tdi[l_ac].tc_tdi03, 
                   tc_tdi04=g_tc_tdi[l_ac].tc_tdi04,     
                   tc_tdi05=g_tc_tdi[l_ac].tc_tdi05,
                   tc_tdi06=g_tc_tdi[l_ac].tc_tdi06, 
                   tc_tdi07=g_tc_tdi[l_ac].tc_tdi07,
                   tc_tdi08=g_tc_tdi[l_ac].tc_tdi08,
                   tc_tdi09=g_tc_tdi[l_ac].tc_tdi09, 
                   tc_tdi10=g_tc_tdi[l_ac].tc_tdi10,
                   tc_tdi11=g_tc_tdi[l_ac].tc_tdi11,
                   tc_tdi12=g_tc_tdi[l_ac].tc_tdi12, 
                   tc_tdi13=g_tc_tdi[l_ac].tc_tdi13,
                   tc_tdiacti = g_tc_tdi[l_ac].tc_tdiacti, 
                   tc_tdidate = g_today                           
             WHERE tc_tdi01 = g_tc_tdi_t.tc_tdi01
              
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tc_tdi_file",g_tc_tdi_t.tc_tdi01,g_tc_tdi_t.tc_tdi02,SQLCA.sqlcode,"","",1)  
               LET g_tc_tdi[l_ac].* = g_tc_tdi_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D40030 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_tc_tdi[l_ac].* = g_tc_tdi_t.*              

            ELSE
               CALL g_tc_tdi.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            CLOSE i180_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      
         CLOSE i180_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(tc_tdi07)      
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_pmc" 
                LET g_qryparam.default1 = g_tc_tdi[l_ac].tc_tdi07
                CALL cl_create_qry() RETURNING g_tc_tdi[l_ac].tc_tdi07
                DISPLAY BY NAME g_tc_tdi[l_ac].tc_tdi07
                NEXT FIELD tc_tdi07
              WHEN INFIELD(tc_tdi10)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gen"
                LET g_qryparam.default1 = g_tc_tdi[l_ac].tc_tdi10
                CALL cl_create_qry() RETURNING g_tc_tdi[l_ac].tc_tdi10
                DISPLAY BY NAME g_tc_tdi[l_ac].tc_tdi10
                NEXT FIELD tc_tdi10
              WHEN INFIELD(tc_tdi11)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gen"
                LET g_qryparam.default1 = g_tc_tdi[l_ac].tc_tdi11
                CALL cl_create_qry() RETURNING g_tc_tdi[l_ac].tc_tdi11
                DISPLAY BY NAME g_tc_tdi[l_ac].tc_tdi11
                NEXT FIELD tc_tdi11
             OTHERWISE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tc_tdi01) AND l_ac > 1 THEN
            LET g_tc_tdi[l_ac].* = g_tc_tdi[l_ac-1].*
            NEXT FIELD tc_tdi01
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
 
   CLOSE i180_bcl
 
   COMMIT WORK
 
END FUNCTION
 

FUNCTION i180_b_askkey()
 
    CLEAR FORM
    CALL g_tc_tdi.clear()
 
    CONSTRUCT g_wc2 ON tc_tdi01,tc_tdi02,tc_tdi03,tc_tdi04,tc_tdi05,tc_tdi06,tc_tdi07,
                       tc_tdi08,tc_tdi09,tc_tdi10,tc_tdi11,tc_tdi12,tc_tdi06,tc_tdi13,
                       tc_tdiacti
         FROM s_tc_tdi[1].tc_tdi01,s_tc_tdi[1].tc_tdi02,s_tc_tdi[1].tc_tdi03,s_tc_tdi[1].tc_tdi04,
              s_tc_tdi[1].tc_tdi05,s_tc_tdi[1].tc_tdi06,s_tc_tdi[1].tc_tdi07,s_tc_tdi[1].tc_tdi08,
              s_tc_tdi[1].tc_tdi09,s_tc_tdi[1].tc_tdi10,s_tc_tdi[1].tc_tdi11,s_tc_tdi[1].tc_tdi12,
              s_tc_tdi[1].tc_tdi13,s_tc_tdi[1].tc_tdiacti
     
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
    
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(tc_tdi07)
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_tdi[1].tc_tdi07
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_tdi07
               WHEN INFIELD(tc_tdi10)
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_tdi[1].tc_tdi10
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_tdi10
              OTHERWISE
           END CASE
         ##
 
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
       RETURN 
    END IF
 
    #LET g_wc2 =g_wc2 CLIPPED, "  AND azf02 ='D' " 
    LET g_wc2 =g_wc2 CLIPPED
   
    CALL i180_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i180_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT tc_tdi01,tc_tdi02,tc_tdi03,tc_tdi04,tc_tdi05,tc_tdi06,tc_tdi07, ",        
               "       tc_tdi08,tc_tdi09,tc_tdi10,tc_tdi11,tc_tdi12,tc_tdi13,",
               "       tc_tdiacti,tc_tdidate",
               "  FROM tc_tdi_file ",                                        
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY tc_tdi05 "
   PREPARE i180_pb FROM g_sql
   DECLARE azf_curs CURSOR FOR i180_pb
 
   CALL g_tc_tdi.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH azf_curs INTO g_tc_tdi[g_cnt].*   #單身 ARRAY 填充
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
 
   CALL g_tc_tdi.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i180_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_tdi TO s_tc_tdi.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
                                                                                        
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
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
 
      ON ACTION about         #
         CALL cl_about()      #
 
 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
    
      AFTER DISPLAY
         CONTINUE DISPLAY
    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 