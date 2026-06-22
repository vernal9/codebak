# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cemi100.4gl
# Descriptions...: 產品製程明細
# Date & Author..: 20260612 By momo
# Modify.........: NO.26060023 20260612
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm RECORD 
       azp01  LIKE azp_file.azp01  END RECORD
DEFINE plant_visible LIKE type_file.chr1
DEFINE
    g_ecb01_i       LIKE ecb_file.ecb01,   #
    g_ecb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ecb01       LIKE ecb_file.ecb01,   
        ima02_h     LIKE ima_file.ima02,
        ima021_h    LIKE ima_file.ima021,
        ecb02       LIKE ecb_file.ecb02,   
        ecb03       LIKE ecb_file.ecb03, 
        ecb06       LIKE ecb_file.ecb06, 
        ecb017      LIKE ecb_file.ecb17, 
        ecb08       LIKE ecb_file.ecb08,   
        eca02       LIKE eca_file.eca02,
        ecb19       LIKE ecb_file.ecb19,   
        ecb21       LIKE ecb_file.ecb21,  
        ecb39       LIKE ecb_file.ecb39,
        ecb07       LIKE ecb_file.ecb07, 
        ecb45       LIKE ecb_file.ecb45,
        imaud08     LIKE ima_file.imaud08,  #素材長度
        sum_time    LIKE ecb_file.ecb19,    #總工時
        shb32       LIKE shb_file.shb32,    #移轉單確認
        ecbacti     LIKE ecb_file.ecbacti
                    END RECORD,
    g_ecb_t         RECORD                 #程式變數 (舊值)
        ecb01         LIKE ecb_file.ecb01,   
        ima02_h     LIKE ima_file.ima02,
        ima021_h    LIKE ima_file.ima021,
        ecb02       LIKE ecb_file.ecb02,   
        ecb03       LIKE ecb_file.ecb03, 
        ecb06       LIKE ecb_file.ecb06, 
        ecb017      LIKE ecb_file.ecb17, 
        ecb08       LIKE ecb_file.ecb08,   
        eca02       LIKE eca_file.eca02,
        ecb19       LIKE ecb_file.ecb19,   
        ecb21       LIKE ecb_file.ecb21,  
        ecb39       LIKE ecb_file.ecb39,
        ecb07       LIKE ecb_file.ecb07, 
        ecb45       LIKE ecb_file.ecb45,
        imaud08     LIKE ima_file.imaud08,  #素材長度
        sum_time    LIKE ecb_file.ecb19,    #總工時
        shb32       LIKE shb_file.shb32,
        ecbacti     LIKE ecb_file.ecbacti
                    END RECORD,
    g_wc,g_wc2,g_sql   STRING,           
    g_rec_b         LIKE type_file.num5,   #單身筆數       
    l_ac            LIKE type_file.num5       #目前處理的ARRAY CNT       
DEFINE g_cmd        LIKE type_file.chr1000
DEFINE g_flag       LIKE type_file.chr1
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10    
DEFINE g_msg        LIKE ze_file.ze03       
DEFINE g_row_count  LIKE type_file.num10    
DEFINE g_curs_index LIKE type_file.num10    
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("CEC")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

    LET g_ecb01_i = NULL
    LET plant_visible = 'N' 
    LET tm.azp01=g_plant                       
 
    OPEN WINDOW i100_w WITH FORM "cec/42f/ceci100"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL i100_menu()
    CLOSE WINDOW i100_w                                 #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i100_menu()

  DEFINE l_flag LIKE type_file.chr1
 
  CALL cl_navigator_setting( g_curs_index, g_row_count )
       
   WHILE TRUE
  
      CALL i100_bp("G")
      CASE g_action_choice
         
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "plant"
            IF cl_chk_act_auth() THEN
               LET plant_visible = 'Y' 
               CALL i100_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i100_b_fill(g_wc)
               CALL i100_b()
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
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecb),'','')
            END IF
          
 
      END CASE
   END WHILE
 
END FUNCTION
 
 
#Query 查詢
FUNCTION i100_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i100_b_askkey()                    #取得查詢條件
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i100_show()
  CALL i100_b_fill(g_wc)                 #單身
  LET g_ecb01_i = g_ecb[l_ac].ecb01
END FUNCTION
 
#單身
FUNCTION i100_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     
    l_n             LIKE type_file.num5,     
    l_lock_sw       LIKE type_file.chr1,     
    p_cmd           LIKE type_file.chr1,     
    l_allow_insert  LIKE type_file.num5,     
    l_allow_delete  LIKE type_file.num5,    
    l_cnt           LIKE type_file.num5      
DEFINE  l_n1        LIKE type_file.num5      
DEFINE  l_i         LIKE type_file.num5 
DEFINE  l_num       LIKE type_file.num5     
DEFINE  l_ecb02     LIKE ecb_file.ecb02      

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
 
    CALL cl_opmsg('b')
    LET g_forupd_sql =
      " SELECT 'ecb01,'','',ecb02,ecb03,ecb06,ecb17,ecb08,'',ecb19,ecb21,ecb39,ecb07,ecb45,'',0,'',ecbacti ",   
      " FROM ecb_file ",
      "  WHERE ecb01 = ? ",
      "   AND ecb02 = ? ",
      "   AND ecb03 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
   
 
        INPUT ARRAY g_ecb
              WITHOUT DEFAULTS
              FROM s_ecb.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=6000,UNBUFFERED,
                        INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
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
               LET g_ecb_t.* = g_ecb[l_ac].*  #BACKUP
                BEGIN WORK
                OPEN i100_bcl USING g_ecb_t.ecb01,g_ecb_t.ecb02,g_ecb_t.ecb03
                IF STATUS THEN
                    CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i100_bcl INTO g_ecb[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_ecb_t.ecb03,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     
            END IF

 
        AFTER INSERT
 
        BEFORE INSERT
          INITIALIZE g_ecb[l_ac].* TO NULL     
         
          LET g_ecb_t.* = g_ecb[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD ecb01
 
        AFTER FIELD ecb01
          DISPLAY g_ecb[l_ac].ecb01 TO FORMONLY.ecb01_i

 
        BEFORE DELETE                            #是否取消單身

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ecb[l_ac].* = g_ecb_t.*
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ecb[l_ac].ecb03,-263,1)
               LET g_ecb[l_ac].* = g_ecb_t.*
            ELSE
       
                UPDATE ecb_file SET
                       ecb19=g_ecb[l_ac].ecb19,
                       ecb21=g_ecb[l_ac].ecb21,
                       ecbdate=g_today,
                       ecbmodu=g_user
                 WHERE ecb01=g_ecb_t.ecb01
                   AND ecb02=g_ecb_t.ecb02       
                   AND ecb03=g_ecb_t.ecb03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","ecb_file",g_ecb_t.ecb01,g_ecb_t.ecb03,SQLCA.sqlcode,"","",1)         
                    LET g_ecb[l_ac].* = g_ecb_t.*
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
                  LET g_ecb[l_ac].* = g_ecb_t.*
               ELSE
                  CALL g_ecb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  
           
            IF cl_null(g_ecb[l_ac].ecb03) THEN 
               CALL g_ecb.deleteElement(l_ac)
            END IF
           
            CLOSE i100_bcl
            COMMIT WORK

 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ecb01)
                 CALL q_sel_ima(FALSE, "q_ima", "", g_ecb[l_ac].ecb01 , "", "", "", "" ,"",'' )  RETURNING g_ecb[l_ac].ecb01
                 DISPLAY g_ecb[l_ac].ecb01 TO ecb01
                 NEXT FIELD ecb01
               
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
      END INPUT

    CLOSE i100_bcl
    COMMIT WORK
END FUNCTION
  
 
FUNCTION i100_b_askkey()

 DEFINE l_cnt LIKE type_file.num5
    CALL cl_set_comp_entry("azp01",TRUE)
    CLEAR FORM
    CALL g_ecb.clear()

    INPUT BY NAME tm.azp01 WITHOUT DEFAULTS
   
    BEFORE FIELD azp01                               
      IF plant_visible = 'N' THEN
         CALL cl_set_comp_entry("azp01",FALSE)
      ELSE
         CALL cl_set_comp_entry("azp01",TRUE)
      END IF
   
    AFTER FIELD azp01
      LET l_cnt = 0
      SELECT 1 INTO l_cnt FROM zxy_file
       WHERE zxy01 = g_user
         AND zxy03 = tm.azp01
      IF l_cnt = 0 THEN
         CALL cl_err(tm.azp01,'sub-188',1)
         NEXT FIELD azp01
      END IF

    ON ACTION controlp
       CASE
         WHEN INFIELD(azp01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_zxy"
              LET g_qryparam.arg1 = g_user
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              LET tm.azp01 = g_qryparam.multiret
              DISPLAY BY NAME tm.azp01
              NEXT FIELD azp01
         OTHERWISE
         EXIT CASE
       END CASE
   END INPUT
 
    CONSTRUCT g_wc ON ecb01,ecb02,ecb03,ecb06,ecb17,ecb08,ecb19,ecb21,ecb39,ecb07,ecb45,shb32,ecbacti     #螢幕上取條件
         FROM s_ecb[1].ecb01,s_ecb[1].ecb02,s_ecb[1].ecb03,
              s_ecb[1].ecb06,s_ecb[1].ecb17,s_ecb[1].ecb08,
              s_ecb[1].ecb19,s_ecb[1].ecb21,s_ecb[1].ecb39,
              s_ecb[1].ecb07,s_ecb[1].ecb45,s_ecb[1].shb32,s_ecb[1].ecbacti
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

       ON ACTION CONTROLP
               CASE
                   WHEN INFIELD(ecb01)
                        CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO ecb01
                        NEXT FIELD ecb01
                   
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ecbuser', 'ecbgrup') 
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i100_b_fill(g_wc)
END FUNCTION
 
FUNCTION i100_b_fill(g_wc)              #BODY FILL UP
DEFINE g_wc,g_wc2 STRING 
    
    LET g_plant_new= tm.azp01
    
    LET g_sql =
       "SELECT ecb01,a.ima02,a.ima021,ecb02,ecb03,ecb06,",
       "       ecb17, ecb08,eca02,ecb19,ecb21,", 
       "       ecb39, ecb07,ecb45,a.imaud08,0,MAX(shb32),ecbacti ",
       " FROM ",cl_get_target_table(g_plant_new,'ecb_file'),
       " LEFT JOIN ",cl_get_target_table(g_plant_new,'ima_file')," a ON a.ima01=ecb01 ",
       " LEFT JOIN ",cl_get_target_table(g_plant_new,'eca_file')," ON eca01= ecb08 ",
       " LEFT JOIN ",cl_get_target_table(g_plant_new,'shb_file')," ON shb10= ecb01 AND ",
       "    EXISTS (SELECT 1 FROM ",cl_get_target_table(g_plant_new,'sfb_file')," WHERE sfb01 = shb05 AND sfb06=ecb02 ) ",
       " WHERE  ", g_wc CLIPPED,
       " GROUP BY ecb01,a.ima02,a.ima021,ecb02,ecb03,ecb06,ecb17, ecb08,eca02,ecb19,ecb21,ecb39, ecb07,ecb45,a.imaud08,0,ecbacti ",
       " ORDER BY 1,2"
    PREPARE i100_prepare2 FROM g_sql      #預備一下
    DECLARE ecb_cs CURSOR FOR i100_prepare2
    CALL g_ecb.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    LET g_max_rec = 6000
    FOREACH ecb_cs INTO g_ecb[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_ecb[g_cnt].imaud08 = 0 THEN
           SELECT smd04 INTO g_ecb[g_cnt].imaud08
             FROM smd_file
            WHERE smd01 = g_ecb[g_cnt].ecb01
              AND smd02 = g_ecb[g_cnt].ecb45
        END IF
        LET g_ecb[g_cnt].sum_time = (g_ecb[g_cnt].ecb19*g_ecb[g_cnt].imaud08+
                                    g_ecb[g_cnt].ecb21*g_ecb[g_cnt].imaud08)/60
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ecb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ecb TO s_ecb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac > 0 THEN
            DISPLAY g_ecb[l_ac].ecb01 TO FORMONLY.ecb01_i
         END IF
      CALL cl_show_fld_cont()                  
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION plant
         LET g_action_choice="plant"
         LET plant_visible = 'Y' 
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
 
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                   
         CALL cl_set_head_visible("","AUTO")      
 
   &include "qry_string.4gl" 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
