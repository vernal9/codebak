# Prog. Version..: '5.30.24-17.04.13(00006)'     #
#
# Pattern name...: cqci102.4gl
# Descriptions...: 細部不良原因資料維護
# Date & Author..: 20230412 By Momo
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
    g_tc_qce           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
        tc_qce01       LIKE tc_qce_file.tc_qce01,     #不良編號
        tc_qce03       LIKE tc_qce_file.tc_qce03,     #描述
        tc_qce04       LIKE tc_qce_file.tc_qce04,     #上層不良原因
        qce03          LIKE qce_file.qce03,        #上層描述
        tc_qceacti     LIKE type_file.chr1         #
                    END RECORD,
    g_tc_qce_t         RECORD                      #程式變數 (舊值)
        tc_qce01       LIKE tc_qce_file.tc_qce01,     #不良編號
        tc_qce03       LIKE tc_qce_file.tc_qce03,     #描述
        tc_qce04       LIKE tc_qce_file.tc_qce04,     #上層不良原因
        qce03          LIKE qce_file.qce03,        #上層描述
        tc_qceacti     LIKE type_file.chr1         #
                    END RECORD,
    g_wc2,g_sql     STRING,                    
    g_rec_b         LIKE type_file.num5,        #單身筆數        
    l_ac            LIKE type_file.num5,        #目前處理的ARRAY CNT       
    l_sl            LIKE type_file.num5         #目前處理的SCREEN LINE

DEFINE g_forupd_sql          LIKE type_file.chr1000  #SELECT ... FOR UPDATE SQL      
DEFINE g_cnt                 LIKE type_file.num10    #
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i                   LIKE type_file.num5     #count/index for any purpose    
  
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("CQC")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 

    OPEN WINDOW i102_w WITH FORM "cqc/42f/cqci102"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i102_b_fill(g_wc2)
    CALL i102_menu()

    CLOSE WINDOW i102_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
 
FUNCTION i102_menu()
DEFINE l_cmd  LIKE type_file.chr1000             
   WHILE TRUE
      CALL i102_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i102_q() 
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN
               CALL i102_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN
               CALL i102_out()                        
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_qce),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i102_q()
   CALL i102_b_askkey()
END FUNCTION
 
FUNCTION i102_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用 
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否 
    p_cmd           LIKE type_file.chr1,      #處理狀態 
    l_allow_insert  LIKE type_file.chr1,      #可新增否
    l_allow_delete  LIKE type_file.chr1       #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT tc_qce01,tc_qce03,tc_qce04,qce03,tc_qceacti ",
                        "  FROM tc_qce_file,qce_file WHERE tc_qce04=qce01 AND tc_qce01=?  ",    
                          " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i102_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_tc_qce WITHOUT DEFAULTS FROM s_tc_qce.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
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
                LET g_tc_qce_t.* = g_tc_qce[l_ac].*  #BACKUP
                LET g_before_input_done = FALSE                                 
                CALL i102_set_entry(p_cmd)                                      
                CALL i102_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
                OPEN i102_bcl USING g_tc_qce_t.tc_qce01
                IF STATUS THEN
                   CALL cl_err("OPEN i102_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                END IF
                FETCH i102_bcl INTO g_tc_qce[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_tc_qce_t.tc_qce01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                CALL cl_show_fld_cont()    
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE                                     
            CALL i102_set_entry(p_cmd)                                          
            CALL i102_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
            INITIALIZE g_tc_qce[l_ac].* TO NULL      
            LET g_tc_qce[l_ac].tc_qceacti = 'Y'         #Body default
            LET g_tc_qce_t.* = g_tc_qce[l_ac].*         #新輸入資料
            DISPLAY g_tc_qce[l_ac].* TO s_qce[l_sl].* 
            CALL cl_show_fld_cont()    
            NEXT FIELD tc_qce01
 
        AFTER INSERT
         IF INT_FLAG THEN                 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i102_bcl
         END IF
         INSERT INTO tc_qce_file(tc_qce01,tc_qce02,tc_qce03,tc_qce04,tc_qceacti,tc_qceuser,tc_qcedate,tc_qceoriu,tc_qceorig)
                       VALUES(g_tc_qce[l_ac].tc_qce01,'',g_tc_qce[l_ac].tc_qce03,g_tc_qce[l_ac].tc_qce04,
                              g_tc_qce[l_ac].tc_qceacti, g_user,g_today, g_user, g_grup)      
         IF SQLCA.sqlcode THEN 
            CALL cl_err3("ins","tc_qce_file",g_tc_qce[l_ac].tc_qce01,"",SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
        AFTER FIELD tc_qce01                        #check 編號是否重複
            IF g_tc_qce[l_ac].tc_qce01 != g_tc_qce_t.tc_qce01 OR
               (g_tc_qce[l_ac].tc_qce01 IS NOT NULL AND g_tc_qce_t.tc_qce01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM tc_qce_file
                 WHERE tc_qce01 = g_tc_qce[l_ac].tc_qce01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_tc_qce[l_ac].tc_qce01 = g_tc_qce_t.tc_qce01
                   NEXT FIELD tc_qce01
                END IF
            END IF
 
        AFTER FIELD tc_qce04
             IF NOT cl_null(g_tc_qce[l_ac].tc_qce04) THEN
                LET g_tc_qce[l_ac].qce03 = ''
                SELECT qce03 INTO g_tc_qce[l_ac].qce03 FROM qce_file
                  WHERE qce01 = g_tc_qce[l_ac].tc_qce04
                DISPLAY BY NAME g_tc_qce[l_ac].qce03
                IF cl_null(g_tc_qce[l_ac].qce03) THEN
                   CALL cl_err('','aqc-023',1)
                   NEXT FIELD tc_qce04
                END IF
             END IF
 

        BEFORE DELETE                            #是否取消單身
             IF g_tc_qce_t.tc_qce01 IS NOT NULL THEN
               IF g_cnt = 0 THEN 
                IF NOT cl_delete() THEN
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM tc_qce_file WHERE tc_qce01 = g_tc_qce_t.tc_qce01
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","tc_qce_file",g_tc_qce_t.tc_qce01,"",SQLCA.sqlcode,"","",1) 
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i102_bcl
                COMMIT WORK
               ELSE 
                CLOSE i102_bcl
               END IF
            END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN              
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tc_qce[l_ac].* = g_tc_qce_t.*
            CLOSE i102_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_tc_qce[l_ac].tc_qce01,-263,1)
             LET g_tc_qce[l_ac].* = g_tc_qce_t.*
         ELSE
             UPDATE tc_qce_file
                SET tc_qce03 = g_tc_qce[l_ac].tc_qce03,
                    tc_qce04 = g_tc_qce[l_ac].tc_qce04,
                    tc_qceacti = g_tc_qce[l_ac].tc_qceacti,
                    tc_qcemodu = g_user,
                    tc_qcedate = g_today
              WHERE tc_qce01=g_tc_qce_t.tc_qce01
 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","tc_qce_file",g_tc_qce_t.tc_qce01,"",SQLCA.sqlcode,"","",1) 
                LET g_tc_qce[l_ac].* = g_tc_qce_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i102_bcl
                COMMIT WORK
             END IF
         END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_tc_qce[l_ac].* = g_tc_qce_t.*
               ELSE
                  CALL g_tc_qce.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               CLOSE i102_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i102_bcl
            COMMIT WORK

        ON ACTION CONTROLP
           CASE
           WHEN INFIELD(tc_qce04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_qce"
                LET g_qryparam.default1 = g_tc_qce[l_ac].tc_qce04
                CALL cl_create_qry() RETURNING g_tc_qce[l_ac].tc_qce04
                DISPLAY BY NAME g_tc_qce[l_ac].tc_qce04
                NEXT FIELD tc_qce04
           END CASE 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tc_qce01) AND l_ac > 1 THEN
                LET g_tc_qce[l_ac].* = g_tc_qce[l_ac-1].*
                DISPLAY g_tc_qce[l_ac].* TO s_tc_qce[l_sl].* 
                NEXT FIELD tc_qce01
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
 
    CLOSE i102_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i102_b_askkey()
    CLEAR FORM
    CALL g_tc_qce.clear()
    CONSTRUCT g_wc2 ON tc_qce01,tc_qce03,tc_qce04,tc_qceacti
            FROM s_tc_qce[1].tc_qce01,s_tc_qce[1].tc_qce03,
                 s_tc_qce[1].tc_qce04,s_tc_qce[1].tc_qceacti
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('tc_qceuser', 'tc_qcegrup') 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF
    CALL i102_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i102_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       
 
    LET g_sql =
        "SELECT tc_qce01,tc_qce03,tc_qce04,qce03,tc_qceacti",
        " FROM tc_qce_file ",
        " LEFT JOIN qce_file ON tc_qce04=qce01 ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i102_pb FROM g_sql
    DECLARE qce_curs CURSOR FOR i102_pb
 
    CALL g_tc_qce.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH qce_curs INTO g_tc_qce[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    MESSAGE ""
    CALL g_tc_qce.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_qce TO s_tc_qce.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                  
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         EXIT DISPLAY
 
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
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i102_out()
DEFINE l_cmd  LIKE type_file.chr1000           
     IF g_wc2 IS NULL THEN                                                       
        CALL cl_err('','9057',0)                                                 
        RETURN                                                                   
     END IF                                                                      
     LET l_cmd = 'p_query "cqci102" "',g_wc2 CLIPPED,'"'             
     CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION i102_set_entry(p_cmd)                                                  
 DEFINE p_cmd   LIKE type_file.chr1      
                                                                               
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
    CALL cl_set_comp_entry("tc_qce01",TRUE)                                       
  END IF                                                                       
END FUNCTION                                                                    
                                                                               
FUNCTION i102_set_no_entry(p_cmd)                                               
 DEFINE p_cmd   LIKE type_file.chr1        
                                                                               
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
    CALL cl_set_comp_entry("tc_qce01",FALSE)                                      
  END IF                                                                       
END FUNCTION                                                                    
                                        
