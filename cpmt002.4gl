# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cpmt002.4gl
# Descriptions...: 
# Date & Author..: NO.22080034  20220905 By momo 固定資產驗收維護作業


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE g_tc_evac         RECORD LIKE tc_evac_file.*,      
       g_tc_evac_t       RECORD LIKE tc_evac_file.*,       
       g_tc_evac_o       RECORD LIKE tc_evac_file.*,       
       g_tc_evac01_t     LIKE tc_evac_file.tc_evac01,          
       g_t1          LIKE smy_file.smyslip,              
       g_ydate       LIKE type_file.dat,          
       g_rvb         DYNAMIC ARRAY OF RECORD       
           rvb02     LIKE rvb_file.rvb02,          
           rvb04     LIKE rvb_file.rvb04,                   
           rvb03     LIKE rvb_file.rvb03,
           rvb05     LIKE rvb_file.rvb05,                                                                        
           rvb051    LIKE rvb_file.rvb051,
           rvb07     LIKE rvb_file.rvb07
                     END RECORD,
       g_sql         STRING,                       
       g_wc          STRING,                       
       g_wc2         STRING,                       
       l_wc          STRING,                       
       g_rec_b       LIKE type_file.num5,          
       l_ac          LIKE type_file.num5           
DEFINE g_forupd_sql        STRING                
DEFINE g_before_input_done LIKE type_file.num5    
DEFINE g_chr               LIKE type_file.chr1   
DEFINE g_cnt               LIKE type_file.num10  
DEFINE g_i                 LIKE type_file.num5   
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10  
DEFINE g_row_count         LIKE type_file.num10  
DEFINE g_jump              LIKE type_file.num10  
DEFINE g_no_ask            LIKE type_file.num5    
DEFINE g_gen02             LIKE gen_file.gen02  
DEFINE g_gen02_05          LIKE gen_file.gen02  
DEFINE g_gem02             LIKE gem_file.gem02
DEFINE g_gem02_08          LIKE gem_file.gem02
DEFINE g_faf02             LIKE faf_file.faf02
DEFINE g_flag              LIKE type_file.chr1
DEFINE g_argv1             LIKE tc_evac_file.tc_evac01  #單號                    
DEFINE g_argv2             STRING               #執行功能                
DEFINE g_laststage         LIKE type_file.chr1  #是否為簽核最後一站flag  
DEFINE g_chr1,g_chr2       LIKE type_file.chr1  #VARCHAR(1)             
DEFINE g_tc_evaa05         LIKE tc_evaa_file.tc_evaa05 

MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN      #判斷是否為背景執行程式 FUN-EC0001 add
      OPTIONS                               #改變一些系統預設值
         INPUT NO WRAP
   END IF                                   #FUN-EC0001 add

   DEFER INTERRUPT                          #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
    
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("cpm")) THEN
      EXIT PROGRAM
   END IF
  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
 
   LET g_argv1 = ARG_VAL(1)              #單號
   LET g_argv2 = ARG_VAL(2)              #執行功能 
   IF fgl_getenv('EASYFLOW') = "1" THEN  #判斷是否為簽核模式
      LET g_argv1 = aws_efapp_wsk(1)     #取得單號,參數:key-1
   END IF
 
 
   LET g_forupd_sql = "SELECT * FROM tc_evac_file WHERE tc_evac01 = ? FOR UPDATE"   
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t002_cl CURSOR FROM g_forupd_sql
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN   
      OPEN WINDOW t002_w WITH FORM "cpm/42f/cpmt002"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
      CALL cl_set_locale_frm_name("cpmt002")    
      CALL cl_ui_init()
 
   END IF   
   
 
   CALL aws_efapp_toolbar()    #建立簽核模式時的toolbar icon
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, invalid, detail, query, locale, void, undo_void,confirm, undo_confirm, easyflow_approval")  #CHI-D20010 add undo_void
        RETURNING g_laststage  #傳入簽核模式時不應執行的action清單
  
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "efconfirm"
            CALL t002_q()
            CALL t002_y_chk()
            IF g_success = "Y" THEN
               CALL t002_y_upd()
            END IF
            EXIT PROGRAM
         OTHERWISE
            CALL t002_q()
      END CASE
   END IF
   
   CALL t002_menu()
   CLOSE WINDOW t002_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t002_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
  

   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " tc_evac01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
   ELSE
 
      CONSTRUCT BY NAME g_wc ON tc_evac01,tc_evac02,tc_evac03,tc_evac04,
                                tc_evac05,tc_evac06,tc_evac07,tc_evac08,tc_evac09,
                                tc_evac10,tc_evacconf,
                                tc_evacmksg,
                                tc_evacuser,tc_evacgrup,tc_evacmodu,tc_evacdate,tc_evacacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(tc_evac01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="cq_tc_evac01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evac01                
                  NEXT FIELD tc_evac01

               WHEN INFIELD(tc_evac03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="cq_rva01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evac03
                  NEXT FIELD tc_evac03
                  
               WHEN INFIELD(tc_evac04) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evac04
                  NEXT FIELD tc_evac04    

               WHEN INFIELD(tc_evac05) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evac05
                  NEXT FIELD tc_evac05      
      
               WHEN INFIELD(tc_evac06) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evac06
                  NEXT FIELD tc_evac06

               WHEN INFIELD(tc_evac07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_faf"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evac07
                  NEXT FIELD tc_evac07

               WHEN INFIELD(tc_evac08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evac08
                  NEXT FIELD tc_evac08
      
               OTHERWISE EXIT CASE
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
   
  
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_evacuser', 'tc_evacgrup')
 
   CONSTRUCT g_wc2 ON rvb02,rvb04,rvb03,   
                      rvb05,rvb051,rvb07
             FROM s_rvb[1].rvbb02,rvb[1].rvb04,s_rvb[1].rvb03,
                  s_rvb[1].rvb05,s_rvb[1].tc_evab051,s_rvb[1].tc_evab07
 
      BEFORE CONSTRUCT
        CALL cl_qbe_display_condition(lc_qbe_sn)
   
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rvb05) 
             # CALL q_sel_ima( TRUE, "q_ima08","","","","","","","",'')  RETURNING  g_qryparam.multiret
             # DISPLAY g_qryparam.multiret TO rvb05
             # NEXT FIELD rvb05              
                            
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
   END IF 
 
   IF cl_null(g_wc2) THEN LET g_wc2 = "1=1" END IF 
   IF g_wc2 = " 1=1" THEN                  
      LET g_sql = "SELECT tc_evac01 FROM tc_evac_file ",       
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tc_evac01"
   ELSE                             
      LET g_sql = "SELECT tc_evac01 ",                        
                  "  FROM tc_evac_file, rvb_file ",
                  " WHERE tc_evac03 = rvb01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY tc_evac01"
   END IF
 
   PREPARE t002_prepare FROM g_sql
   DECLARE t002_cs                         
       SCROLL CURSOR WITH HOLD FOR t002_prepare
 
   IF g_wc2 = " 1=1" THEN                  
      LET g_sql="SELECT COUNT(*) FROM tc_evac_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT tc_evac01) FROM tc_evac_file,rvb_file WHERE ",
                "rvb01=tc_evac03 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t002_precount FROM g_sql
   DECLARE t002_count CURSOR FOR t002_precount
 
END FUNCTION
 
FUNCTION t002_menu() 
DEFINE l_creator  LIKE type_file.chr1  #是否退回填表人      
DEFINE l_flowuser LIKE type_file.chr1  #是否有指定加簽人員  

   LET l_flowuser = "N"  #FUN-BC0018
 
   WHILE TRUE
      CALL t002_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t002_a()
               LET g_data_keyvalue = g_tc_evac.tc_evac01     
               CALL t002_b_fill("1=1") 
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t002_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t002_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t002_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t002_x()
            END IF
        
         WHEN "output"
            IF cl_chk_act_auth() THEN
               LET l_wc='tc_evac01="',g_tc_evac.tc_evac01,'"'
               LET g_msg = "cpmr200",
                   " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' '' '1'",
                   " '",l_wc CLIPPED,"' "
               CALL cl_cmdrun(g_msg)
            END IF
            
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "confirm"
            IF cl_chk_act_auth() THEN             
               CALL t002_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t002_y_upd()       #CALL 原確認的 update 段
               END IF
             
               CALL t002_show() #圖示  
            END IF
 
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t002_unconfirm()
               CALL t002_show() 
            END IF
            
        WHEN "agree"                                       #執行EF簽核,"准"功能
           IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
              CALL t002_y_upd()                            #CALL 原確認的 update 段
           ELSE
              LET g_success = "Y"
              IF NOT aws_efapp_formapproval() THEN       #執行EF簽核       
                 LET g_success = "N"
              END IF
           END IF
           IF g_success = 'Y' THEN
              IF cl_confirm('aws-081') THEN              #詢問是否繼續下一筆資料的簽核
                 IF aws_efapp_getnextforminfo() THEN     #取得下一筆簽核單號
                    LET l_flowuser = 'N'
                    LET g_argv1 = aws_efapp_wsk(1)       #取得單號
                    IF NOT cl_null(g_argv1) THEN         #自動query帶出資料
                       CALL t002_q()
                       #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                      # CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, undo_confirm, easyflow_approval")  #CHI-D20010 add undo_void
                      #      RETURNING g_laststage
                    ELSE
                       EXIT WHILE
                    END IF
                 ELSE
                    EXIT WHILE
                 END IF
              ELSE
                 EXIT WHILE
              END IF
           END IF

        WHEN "deny"                                                 #執行EF簽核,"不准"功能
           IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN  #退回關卡
              IF aws_efapp_formapproval() THEN                      #執行EF簽核
                 IF l_creator = "Y" THEN                            #當退回填表人時
                    LET g_tc_evac.tc_evac10 = 'R'                   #顯示狀態碼為'R' 送簽退回
                    DISPLAY BY NAME g_tc_evac.tc_evac10
                 END IF
                 IF cl_confirm('aws-081') THEN                      #詢問是否繼續下一筆資料的簽核
                    IF aws_efapp_getnextforminfo() THEN             #取得下一筆簽核單號
                       LET l_flowuser = 'N'
                       LET g_argv1 = aws_efapp_wsk(1)               #取得單號
                       IF NOT cl_null(g_argv1) THEN                 #自動query帶出資料
                          CALL t002_q()
                          #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, undo_confirm, easyflow_approval")  #CHI-D20010 add undo_void
                               RETURNING g_laststage
                       ELSE
                          EXIT WHILE
                       END IF
                    ELSE
                       EXIT WHILE
                    END IF
                 ELSE
                    EXIT WHILE
                 END IF
              END IF
            END IF

        WHEN "modify_flow"                #執行EF簽核,"加簽"功能
           IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
              LET l_flowuser = 'Y'
           ELSE
              LET l_flowuser = 'N'
           END IF

        WHEN "withdraw"                   #執行EF簽核,"撤簽"功能
           IF cl_confirm("aws-080") THEN
              IF aws_efapp_formapproval() THEN
                 EXIT WHILE
              END IF
           END IF

        WHEN "org_withdraw"               #執行EF簽核,"抽單"功能
           IF cl_confirm("aws-079") THEN
              IF aws_efapp_formapproval() THEN
                 EXIT WHILE
              END IF
           END IF

        WHEN "phrase"                     #執行EF簽核,"簽核意見"功能
           CALL aws_efapp_phrase()

        WHEN "approval_status"            #執行EF簽核,"簽核狀況"功能
           IF cl_chk_act_auth() THEN     
              IF aws_condition2() THEN
                 CALL aws_efstat2()             
              END IF
           END IF

        WHEN "easyflow_approval"          #執行EF簽核,"EasyFlow送簽"功能
           IF cl_chk_act_auth() THEN
                CALL t002_ef()
           END IF 

 
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvb),'','')
            END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_evac.tc_evac01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_evac01"
                 LET g_doc.value1 = g_tc_evac.tc_evac01
                 CALL cl_doc()
               END IF
         END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t002_v(1)  
               CALL t002_show_pic() 
            END IF
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t002_v(2)   
               CALL t002_show_pic()
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                 
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t002_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t002_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION jump
         CALL t002_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION next
         CALL t002_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL t002_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
         
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      #ON ACTION reproduce
      #   LET g_action_choice="reproduce"
      #   EXIT DISPLAY
 
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
         
      ON ACTION easyflow_approval           
        LET g_action_choice = "easyflow_approval"
        EXIT DISPLAY
 
      ON ACTION confirm     
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm     
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY         
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      ON ACTION undo_void
         LET g_action_choice="undo_void"
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

 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")       
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY
         
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY

      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY

      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY

      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY

      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY

      ON ACTION approval_status           
        LET g_action_choice = "approval_status"
        EXIT DISPLAY
    
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t002_bp_refresh()
  DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t002_a()
   DEFINE li_result   LIKE type_file.num5   
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10  
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rvb.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_tc_evac.* LIKE tc_evac_file.*             #DEFAULT 設定
   LET g_tc_evac01_t = NULL
   LET g_tc_evac.tc_evac02 = g_today
   LET g_tc_evac.tc_evacconf = 'N'  
   LET g_tc_evac.tc_evac10 = 0  
   LET g_tc_evac.tc_evac16 = 'N'  
   LET g_tc_evac.tc_evacmksg = 'N' 
   LET g_gen02 = NULL
   LET g_gen02_05 = NULL
   LET g_gem02 = NULL
   LET g_faf02 = NULL
   LET g_gem02_08 = NULL
 
   #預設值及將數值類變數清成零
   LET g_tc_evac_t.* = g_tc_evac.*
   LET g_tc_evac_o.* = g_tc_evac.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_tc_evac.tc_evacuser=g_user
      LET g_tc_evac.tc_evacoriu = g_user 
      LET g_tc_evac.tc_evacorig = g_grup 
      LET g_data_plant = g_plant
      LET g_tc_evac.tc_evacgrup=g_grup
      LET g_tc_evac.tc_evacdate=g_today
      LET g_tc_evac.tc_evacacti='Y'              #資料有效
      LET g_tc_evac.tc_evacplant = g_plant
      LET g_tc_evac.tc_evaclegal = g_legal 
 
      CALL t002_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_tc_evac.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_tc_evac.tc_evac01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
      CALL s_auto_assign_no("apm",g_tc_evac.tc_evac01,g_tc_evac.tc_evac02,"B","tc_evac_file","tc_evac01","","","") RETURNING li_result,g_tc_evac.tc_evac01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_tc_evac.tc_evac01
 
      INSERT INTO tc_evac_file VALUES (g_tc_evac.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","tc_evac_file",g_tc_evac.tc_evac01,"",SQLCA.sqlcode,"","",1)  #No.FUN-B80100---上移一行調整至回滾事務前--- 
         ROLLBACK WORK     
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
 
      LET g_tc_evac01_t = g_tc_evac.tc_evac01 
      LET g_tc_evac_t.* = g_tc_evac.*
      LET g_tc_evac_o.* = g_tc_evac.*
      CALL g_rvb.clear()
 
      LET g_rec_b = 0
      
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t002_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_evac.tc_evac01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_tc_evac.tc_evac10 = '9' THEN RETURN END IF  
   IF g_tc_evac.tc_evac10 matches '[Ss1]' THEN     
      CALL cl_err("","mfg3557",1)
      LET g_success='N'
      RETURN                                                                                                                        
   END IF

 
   SELECT * INTO g_tc_evac.* FROM tc_evac_file
    WHERE tc_evac01=g_tc_evac.tc_evac01
 
   IF g_tc_evac.tc_evacacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tc_evac.tc_evac01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tc_evac01_t = g_tc_evac.tc_evac01
   BEGIN WORK
 
   OPEN t002_cl USING g_tc_evac.tc_evac01    
   IF STATUS THEN
      CALL cl_err("OPEN t002_cl:", STATUS, 1)
      CLOSE t002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t002_cl INTO g_tc_evac.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_evac.tc_evac01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t002_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t002_show()
 
   WHILE TRUE
      LET g_tc_evac01_t = g_tc_evac.tc_evac01
      LET g_tc_evac_o.* = g_tc_evac.*
      LET g_tc_evac.tc_evacmodu=g_user
      LET g_tc_evac.tc_evacdate=g_today
 
      CALL t002_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tc_evac.*=g_tc_evac_t.*
         CALL t002_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
 
      LET g_tc_evac.tc_evac10 = '0'  
      DISPLAY BY NAME g_tc_evac.tc_evac10  

      UPDATE tc_evac_file SET tc_evac_file.* = g_tc_evac.*
       WHERE tc_evac01 = g_tc_evac01_t     
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","tc_evac_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t002_cl
   COMMIT WORK
 
   CALL t002_b_fill("1=1")
   CALL t002_bp_refresh()
 
END FUNCTION
 
FUNCTION t002_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,    
   p_cmd     LIKE type_file.chr1    
   DEFINE    li_result   LIKE type_file.num5
   DEFINE    l_sql       STRING
   DEFINE    l_tc_evac06 LIKE tc_evac_file.tc_evac06
   DEFINE    l_cnt       LIKE type_file.num5      
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_tc_evac.tc_evacuser,g_tc_evac.tc_evacmodu,
       g_tc_evac.tc_evacgrup,g_tc_evac.tc_evacdate,g_tc_evac.tc_evacacti
   IF p_cmd = 'a' THEN    
      DISPLAY g_gen02 TO gen02
      DISPLAY g_gem02 TO gem02       
   END IF
   CALL cl_set_head_visible("","YES")         
   INPUT BY NAME g_tc_evac.tc_evac01,g_tc_evac.tc_evac02,g_tc_evac.tc_evac03,g_tc_evac.tc_evac04,
                 g_tc_evac.tc_evac05,g_tc_evac.tc_evac06,g_tc_evac.tc_evac07,
                 g_tc_evac.tc_evacoriu,g_tc_evac.tc_evacorig,
                 g_tc_evac.tc_evac08, g_tc_evac.tc_evac16,
                 g_tc_evac.tc_evac09,
                 g_tc_evac.tc_evac10,g_tc_evac.tc_evacmksg,
                 g_tc_evac.tc_evac11,
                 g_tc_evac.tc_evac12,g_tc_evac.tc_evac13,
                 g_tc_evac.tc_evac14,g_tc_evac.tc_evac15    
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t002_set_entry(p_cmd)
         CALL t002_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("tc_evac01")

      BEFORE FIELD tc_evac01
        IF cl_null(g_tc_evac.tc_evac01) THEN
           SELECT rye03 INTO g_tc_evac.tc_evac01 FROM rye_file
            WHERE rye01 = 'apm' AND ryeacti = 'Y' and rye02='B' AND ta_rye01='cpmt002'
           DISPLAY BY NAME g_tc_evac.tc_evac01
        END IF

      AFTER FIELD tc_evac01
         IF NOT cl_null(g_tc_evac.tc_evac01) THEN
            CALL s_check_no("apm",g_tc_evac.tc_evac01,g_tc_evac01_t,"B","tc_evac_file","tc_evac01","") RETURNING li_result,g_tc_evac.tc_evac01
            DISPLAY BY NAME g_tc_evac.tc_evac01
            IF (NOT li_result) THEN
               LET g_tc_evac.tc_evac01=g_tc_evac_o.tc_evac01
               NEXT FIELD tc_evac01
            END IF
            LET g_tc_evac.tc_evacmksg = g_smy.smyapr
            DISPLAY BY NAME g_tc_evac.tc_evacmksg
            DISPLAY g_smy.smydesc TO smydesc
         END IF

      AFTER FIELD tc_evac03
         IF NOT cl_null(g_tc_evac.tc_evac03) THEN
            CALL t002_tc_evac03('d')
            CALL t002_show()
            NEXT FIELD tc_evac04
         ELSE
            NEXT FIELD tc_evac03
         END IF
 
      AFTER FIELD tc_evac04                
         IF NOT cl_null(g_tc_evac.tc_evac04) THEN
            LET g_gen02 = NULL
            SELECT gen02 INTO g_gen02 FROM gen_file
             WHERE gen01 = g_tc_evac.tc_evac04
            IF cl_null(g_gen02) THEN
               CALL cl_err('','aap-038',0)
               NEXT FIELD tc_evac04
            END IF
            DISPLAY g_gen02 TO gen02_04
         END IF

       AFTER FIELD tc_evac05
         IF NOT cl_null(g_tc_evac.tc_evac05) THEN
            LET g_gen02_05 = NULL
            SELECT gen02,gen03,gem02
              INTO g_gen02_05,g_tc_evac.tc_evac06,g_gem02
              FROM gen_file,gem_file
             WHERE gen01 = g_tc_evac.tc_evac05
            IF cl_null(g_gen02_05) THEN
               CALL cl_err('','aap-038',0)
               NEXT FIELD tc_evac05
            END IF
            DISPLAY g_gen02_05 TO gen02_05
            DISPLAY BY NAME g_tc_evac.tc_evac06
            DISPLAY g_gem02 TO gem02  
         END IF
 
      AFTER FIELD tc_evac06                
         IF NOT cl_null(g_tc_evac.tc_evac06) THEN
            LET g_gem02 = ''
            SELECT gem02 INTO g_gem02 FROM gem_file
             WHERE gem01 = g_tc_evac.tc_evac06
               AND gemacti ='Y'
            IF cl_null(g_gem02) THEN
               NEXT FIELD tc_evac06
            END IF
            DISPLAY g_gem02 TO gem02  
         END IF

      AFTER FIELD tc_evac07
         IF NOT cl_null(g_tc_evac.tc_evac07) THEN
            LET g_faf02 = ''
            SELECT faf02 INTO g_faf02 FROM faf_file
             WHERE faf01 = g_tc_evac.tc_evac07
               AND fafacti ='Y'
            IF cl_null(g_faf02) THEN
               NEXT FIELD tc_evac07
            END IF
            DISPLAY g_faf02 TO faf02
         END IF
      

      AFTER FIELD tc_evac08
         IF NOT cl_null(g_tc_evac.tc_evac08) THEN
            LET g_gem02_08 = ''
            SELECT gem02 INTO g_gem02_08 FROM gem_file
             WHERE gem01 = g_tc_evac.tc_evac08
               AND gemacti ='Y'
            IF cl_null(g_gem02_08) THEN
               NEXT FIELD tc_evac08
            END IF
            DISPLAY g_gem02_08 TO gem02_08
         END IF

      AFTER FIELD tc_evac11
         IF g_tc_evac.tc_evac11 > g_today THEN
            CALL cl_err('','alm-072',1)
            NEXT FIELD tc_evac11
         END IF

      AFTER FIELD tc_evac12
         IF g_tc_evac.tc_evac12 > g_today THEN
            CALL cl_err('','alm-072',1)
            NEXT FIELD tc_evac12
         END IF

      AFTER FIELD tc_evac13
         IF g_tc_evac.tc_evac13 > g_today THEN
            CALL cl_err('','alm-072',1)
            NEXT FIELD tc_evac13
         END IF

      AFTER FIELD tc_evac14
         IF g_tc_evac.tc_evac11 > g_today THEN
            CALL cl_err('','alm-072',1)
            NEXT FIELD tc_evac14
         END IF

      AFTER FIELD tc_evac16
         IF g_tc_evac.tc_evac16='Y' THEN
            CALL cl_set_comp_required("tc_evac15",TRUE)
            IF cl_null(g_tc_evac.tc_evac15) THEN
               CALL cl_err('','cpm-026','1')
            END IF
         END IF
            
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_evac01) 
                 LET g_t1=s_get_doc_no(g_tc_evac.tc_evac01)     
                 CALL q_smy(FALSE,FALSE,g_t1,'apm','B') RETURNING g_t1 
                 LET g_tc_evac.tc_evac01 = g_t1                 
                 DISPLAY BY NAME g_tc_evac.tc_evac01
                 CALL t002_tc_evac01('d')
                 NEXT FIELD tc_evac01

            WHEN INFIELD(tc_evac03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="cq_rva01"
               LET g_qryparam.default1 = g_tc_evac.tc_evac03
               CALL cl_create_qry() RETURNING g_tc_evac.tc_evac03
               DISPLAY BY NAME g_tc_evac.tc_evac03
               NEXT FIELD tc_evac03
                 
            WHEN INFIELD(tc_evac04) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_tc_evac.tc_evac04
               CALL cl_create_qry() RETURNING g_tc_evac.tc_evac04
               DISPLAY BY NAME g_tc_evac.tc_evac04
               CALL t002_tc_evac04('d')
               NEXT FIELD tc_evac04  

             WHEN INFIELD(tc_evac05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_tc_evac.tc_evac05
               CALL cl_create_qry() RETURNING g_tc_evac.tc_evac05
               DISPLAY BY NAME g_tc_evac.tc_evac05
               CALL t002_tc_evac04('d')
               NEXT FIELD tc_evac05               
 
            WHEN INFIELD(tc_evac06) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = g_tc_evac.tc_evac06
               CALL cl_create_qry() RETURNING g_tc_evac.tc_evac06
               DISPLAY BY NAME g_tc_evac.tc_evac06
               CALL t002_tc_evac06('d')
               NEXT FIELD tc_evac06
 
            WHEN INFIELD(tc_evac07) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_faf"
               LET g_qryparam.default1 = g_tc_evac.tc_evac07
               CALL cl_create_qry() RETURNING g_tc_evac.tc_evac07
               DISPLAY BY NAME g_tc_evac.tc_evac07
               CALL t002_tc_evac07('d')
               NEXT FIELD tc_evac07

             WHEN INFIELD(tc_evac08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = g_tc_evac.tc_evac08
               CALL cl_create_qry() RETURNING g_tc_evac.tc_evac08
               DISPLAY BY NAME g_tc_evac.tc_evac08
               CALL t002_tc_evac06('d')
               NEXT FIELD tc_evac08
 
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION
 
FUNCTION t002_tc_evac01(p_cmd)
   DEFINE l_smydesc LIKE smy_file.smydesc,
          l_smyacti LIKE smy_file.smyacti,
          l_t1      LIKE oay_file.oayslip, 
          p_cmd     LIKE type_file.chr1   
 
   LET g_errno = ' '
   LET l_t1 = s_get_doc_no(g_tc_evac.tc_evac01)
   IF g_tc_evac.tc_evac01 IS NULL THEN
      LET g_errno = 'E'
      LET l_smydesc=NULL
   ELSE
      SELECT smydesc,smyacti
        INTO l_smydesc,l_smyacti
        FROM smy_file WHERE smyslip = l_t1
      IF SQLCA.sqlcode THEN
         LET g_errno = 'E'
         LET l_smydesc = NULL
      ELSE
         IF l_smyacti matches'[nN]' THEN
            LET g_errno = 'E'
         END IF
      END IF
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_smydesc TO FORMONLY.smydesc
   END IF
 
END FUNCTION

#收貨帶評估
FUNCTION t002_tc_evac03(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1,
          l_tc_evaa01 LIKE tc_evaa_file.tc_evaa01,
          l_tc_evaa05 LIKE tc_evaa_file.tc_evaa05,
          l_tc_evaa07 LIKE tc_evaa_file.tc_evaa07,
          l_tc_evaa14 LIKE tc_evaa_file.tc_evaa14,
          l_sum_total LIKE tc_evaa_file.tc_evaa11 
   DEFINE l_cnt       LIKE type_file.num5

   LET g_errno = ' '
   SELECT SUM(rvb88),tc_evaa01,tc_evaa05,tc_evaa07,tc_evaa14,tc_evaa04 
     INTO l_sum_total,l_tc_evaa01,l_tc_evaa05,l_tc_evaa07,l_tc_evaa14,g_tc_evac.tc_evac06
     FROM rvb_file
     LEFT JOIN pmn_file ON pmn01 = rvb04
     LEFT JOIN pml_file ON pml01 = pmn24
     LEFT JOIN tc_evaa_file ON tc_evaa01 = pml24
    WHERE rvb01 = g_tc_evac.tc_evac03
   GROUP BY tc_evaa01,tc_evaa05,tc_evaa07,tc_evaa14,tc_evaa04

   LET g_tc_evaa05 = l_tc_evaa05
   
   DISPLAY l_tc_evaa01 TO tc_evaa01
   DISPLAY l_tc_evaa05 TO tc_evaa05
   DISPLAY l_tc_evaa07 TO tc_evaa07
   DISPLAY l_tc_evaa14 TO tc_evaa14
   DISPLAY l_sum_total TO sum_total
   DISPLAY BY NAME g_tc_evac.tc_evac06

   LET l_cnt = 0
   SELECT 1 INTO l_cnt
     FROM ima_file,rvb_file
    WHERE ima131 = 'FA01'   #列帳
      AND ima01 = rvb05
      AND rvb01 = g_tc_evac.tc_evac03

   IF l_cnt = 1 THEN
      CALL cl_set_comp_required("tc_evac08",TRUE)
      IF l_tc_evaa05 = '1' AND l_tc_evaa07='A' THEN
         CALL cl_set_comp_required("tc_evac09",TRUE)
      ELSE
         CALL cl_set_comp_required("tc_evac09",FALSE)
      END IF
   ELSE
      CALL cl_set_comp_required("tc_evac08",FALSE)
   END IF

   IF NOT cl_null(l_tc_evaa14) THEN
      SELECT faj19,faj20,faj21,faj24
        INTO g_tc_evac.tc_evac05,g_tc_evac.tc_evac06,g_tc_evac.tc_evac07,g_tc_evac.tc_evac08
       FROM faj_file
       WHERE faj02 = l_tc_evaa14
      DISPLAY BY NAME g_tc_evac.tc_evac05,g_tc_evac.tc_evac06,g_tc_evac.tc_evac07,g_tc_evac.tc_evac08
   END IF

END FUNCTION
 
FUNCTION t002_tc_evac04(p_cmd)
   DEFINE l_gen02     LIKE gen_file.gen02,
          l_gen02_05  LIKE gen_file.gen02,
          p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT gen02 INTO l_gen02 FROM gen_file
    WHERE gen01 = g_tc_evac.tc_evac04
 
   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_gen02 = NULL
   END IF   
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO gen02_04
   END IF

   SELECT gen02 INTO l_gen02_05 FROM gen_file
    WHERE gen01 = g_tc_evac.tc_evac05
   DISPLAY l_gen02_05 TO gen02_05
 
END FUNCTION
 
FUNCTION t002_tc_evac06(p_cmd)  
   DEFINE l_gem02    LIKE gem_file.gem02,
          l_gem02_08 LIKE gem_file.gem02,
          p_cmd      LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT gem02 INTO l_gem02 FROM gem_file
    WHERE gem01 = g_tc_evac.tc_evac06
 
   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_gem02 = NULL
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO gem02
   END IF
 
   SELECT gem02 INTO l_gem02_08 FROM gem_file
    WHERE gem01 = g_tc_evac.tc_evac08
   DISPLAY l_gem02_08 TO gem02_08

END FUNCTION
 
FUNCTION t002_tc_evac07(p_cmd)
   DEFINE l_faf02   LIKE faf_file.faf02,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT faf02 INTO l_faf02 FROM faf_file
    WHERE faf01 = g_tc_evac.tc_evac07
 
   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_faf02 = NULL
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_faf02 TO faf02
   END IF
 
END FUNCTION
 
FUNCTION t002_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_msg("")  
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rvb.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t002_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_tc_evac.* TO NULL
      RETURN
   END IF
 
   OPEN t002_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_evac.* TO NULL
   ELSE
      OPEN t002_count
      FETCH t002_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t002_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t002_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1            
 
   CASE p_flag

      WHEN 'N' FETCH NEXT     t002_cs INTO g_tc_evac.tc_evac01               
      WHEN 'P' FETCH PREVIOUS t002_cs INTO g_tc_evac.tc_evac01               
      WHEN 'F' FETCH FIRST    t002_cs INTO g_tc_evac.tc_evac01               
      WHEN 'L' FETCH LAST     t002_cs INTO g_tc_evac.tc_evac01               
      WHEN '/'
            IF (NOT g_no_ask) THEN     
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
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
            FETCH ABSOLUTE g_jump t002_cs INTO g_tc_evac.tc_evac01                   
            LET g_no_ask = FALSE   
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_evac.tc_evac01,SQLCA.sqlcode,0)
      INITIALIZE g_tc_evac.* TO NULL             
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
      DISPLAY g_curs_index TO FORMONLY.idx                    
   END IF
 
   SELECT * INTO g_tc_evac.* FROM tc_evac_file WHERE tc_evac01 = g_tc_evac.tc_evac01  
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","tc_evac_file","","",SQLCA.sqlcode,"","",1) 
      INITIALIZE g_tc_evac.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_tc_evac.tc_evacuser      
   LET g_data_group = g_tc_evac.tc_evacgrup    
   LET g_data_plant = g_tc_evac.tc_evacplant   
   LET g_data_keyvalue = g_tc_evac.tc_evac01   
   CALL t002_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t002_show()
 
   LET g_tc_evac_t.* = g_tc_evac.*                #保存單頭舊值
   LET g_tc_evac_o.* = g_tc_evac.*                #保存單頭舊值
   LET g_data_keyvalue = g_tc_evac.tc_evac01      #No:FUN-F50016
   DISPLAY BY NAME g_tc_evac.tc_evac01,g_tc_evac.tc_evac02,g_tc_evac.tc_evac03, g_tc_evac.tc_evacoriu,g_tc_evac.tc_evacorig,
                   g_tc_evac.tc_evac04,g_tc_evac.tc_evac05,g_tc_evac.tc_evac07,g_tc_evac.tc_evac10,g_tc_evac.tc_evac11,
                   g_tc_evac.tc_evac09,g_tc_evac.tc_evac06,g_tc_evac.tc_evac08,g_tc_evac.tc_evacmksg,  
                   g_tc_evac.tc_evac12,g_tc_evac.tc_evac13,g_tc_evac.tc_evac14,g_tc_evac.tc_evac06,
                   g_tc_evac.tc_evac15,g_tc_evac.tc_evac16,
                   g_tc_evac.tc_evacuser,g_tc_evac.tc_evacgrup,g_tc_evac.tc_evacmodu,
                   g_tc_evac.tc_evacdate,g_tc_evac.tc_evacacti,g_tc_evac.tc_evacconf
                   
   CALL t002_tc_evac01('d')
   CALL t002_tc_evac04('d')
   CALL t002_tc_evac06('d')
   CALL t002_tc_evac07('d')                    
   CALL t002_tc_evac03('d')
   CALL t002_b_fill(g_wc2)                 #單身
   CALL t002_show_pic() #圖示  
   CALL cl_show_fld_cont()              
END FUNCTION
 
FUNCTION t002_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_evac.tc_evac01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_tc_evac.tc_evac10 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      LET g_success='N' RETURN
   END IF   
   BEGIN WORK
 
   OPEN t002_cl USING g_tc_evac.tc_evac01   
   IF STATUS THEN
      CALL cl_err("OPEN t002_cl:", STATUS, 1)
      CLOSE t002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t002_cl INTO g_tc_evac.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_evac.tc_evac01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t002_show()
 
   IF cl_exp(0,0,g_tc_evac.tc_evacacti) THEN                   #確認一下
      LET g_chr=g_tc_evac.tc_evacacti
      IF g_tc_evac.tc_evacacti='Y' THEN
         LET g_tc_evac.tc_evacacti='N'
      ELSE
         LET g_tc_evac.tc_evacacti='Y'
      END IF
 
      UPDATE tc_evac_file SET tc_evacacti=g_tc_evac.tc_evacacti,
                          tc_evacmodu=g_user,
                          tc_evacdate=g_today
       WHERE tc_evac01=g_tc_evac.tc_evac01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tc_evac_file",g_tc_evac.tc_evac01,"",SQLCA.sqlcode,"","",1)  
         LET g_tc_evac.tc_evacacti=g_chr
      END IF
   END IF
 
   CLOSE t002_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT tc_evacacti,tc_evacmodu,tc_evacdate
     INTO g_tc_evac.tc_evacacti,g_tc_evac.tc_evacmodu,g_tc_evac.tc_evacdate FROM tc_evac_file
    WHERE tc_evac01=g_tc_evac.tc_evac01
   DISPLAY BY NAME g_tc_evac.tc_evacacti,g_tc_evac.tc_evacmodu,g_tc_evac.tc_evacdate
 
END FUNCTION
 
FUNCTION t002_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_evac.tc_evac01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
  
   IF g_tc_evac.tc_evac10 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      LET g_success='N' 
      RETURN
   END IF   
 
   SELECT * INTO g_tc_evac.* FROM tc_evac_file
    WHERE tc_evac01=g_tc_evac.tc_evac01
 
   BEGIN WORK
 
   OPEN t002_cl USING g_tc_evac.tc_evac01  
   IF STATUS THEN
      CALL cl_err("OPEN t002_cl:", STATUS, 1)
      CLOSE t002_cl
      ROLLBACK WORK
  
      RETURN
   END IF
 
   FETCH t002_cl INTO g_tc_evac.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_evac.tc_evac01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t002_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL         
       LET g_doc.column1 = "tc_evac01"         
       LET g_doc.value1 = g_tc_evac.tc_evac01     
       CALL cl_del_doc()                
      DELETE FROM tc_evac_file WHERE tc_evac01 = g_tc_evac.tc_evac01
      DELETE FROM tc_evab_file WHERE tc_evab01 = g_tc_evac.tc_evac01
      CLEAR FORM
      CALL g_rvb.clear()
      OPEN t002_count
      IF STATUS THEN
         CLOSE t002_cs  
         CLOSE t002_count
         COMMIT WORK
         RETURN
      END IF
      FETCH t002_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t002_cs  
         CLOSE t002_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t002_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t002_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE   
         CALL t002_fetch('/')
      END IF
   END IF
 
   CLOSE t002_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tc_evac.tc_evac01,'D')
END FUNCTION
 

FUNCTION t002_sum()
   SELECT SUM(tc_evab05*tc_evab06*NVL(azk052,1)) INTO g_tc_evac.tc_evac11
     FROM tc_evab_file,tc_evac_file,azk_file
    WHERE tc_evab01 = g_tc_evac.tc_evac01
      AND tc_evac01 = tc_evab01
      AND tc_evac10 = azk01
      AND tc_evac02 = azk02
   DISPLAY BY NAME g_tc_evac.tc_evac11
END FUNCTION

FUNCTION t002_delHeader()
   DEFINE l_action_choice    STRING               
   DEFINE l_cho              LIKE type_file.num5  
   DEFINE l_num              LIKE type_file.num5  
   DEFINE l_slip             LIKE type_file.chr5  
   DEFINE l_sql              STRING               
   DEFINE l_cnt              LIKE type_file.num5  
   DEFINE l_n                LIKE type_file.num5

   SELECT COUNT(*) INTO l_n FROM tc_evab_file WHERE tc_evab01 = g_tc_evac.tc_evac01

   IF l_n = 0 THEN
      CALL s_get_doc_no(g_tc_evac.tc_evac01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM tc_evac_file ",
                  "  WHERE tc_evac01 LIKE '",l_slip,"%' ",
                  "    AND tc_evac01 > '",g_tc_evac.tc_evac01,"'"
      PREPARE t002_pb6 FROM l_sql 
      EXECUTE t002_pb6 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t002_v(1)  
         CALL t002_show_pic()
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM tc_evac_file WHERE tc_evac01 = g_tc_evac.tc_evac01
         INITIALIZE g_tc_evac.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION

 
FUNCTION t002_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
 
   LET g_sql = "SELECT rvb02,rvb04,rvb03,rvb05,rvb051,rvb07",
               "  FROM rvb_file ",
               " WHERE rvb01 ='",g_tc_evac.tc_evac03,"' "   #單頭
 
  # IF NOT cl_null(p_wc2) THEN
  #    LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
  # END IF
  # LET g_sql=g_sql CLIPPED," ORDER BY rvb02"
   DISPLAY g_sql
 
   PREPARE t002_pb FROM g_sql
   DECLARE tc_evab_cs CURSOR FOR t002_pb
 
   CALL g_rvb.clear()
   LET g_cnt = 1
 
   FOREACH tc_evab_cs INTO g_rvb[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_rvb.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 


FUNCTION t002_y_chk()
  DEFINE l_n      LIKE type_file.num5  
  
    LET g_success = 'Y'
 
    IF g_tc_evac.tc_evac01 IS NULL THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       RETURN
    END IF
    IF g_tc_evac.tc_evac10 = '9' THEN 
       LET g_success = 'N'
       RETURN 
    END IF  
    IF g_tc_evac.tc_evac10 = '1' THEN  #已核准
       CALL cl_err('','mfg3212',1)
       LET g_success = 'N'
       RETURN
    END IF

    IF g_tc_evac.tc_evacacti = 'N' THEN  #本筆資料無效
       CALL cl_err('','abm-889',1)
       LET g_success = 'N'
       RETURN
    END IF
    IF g_action_choice CLIPPED = "confirm" OR  #執行 "確認" 功能(非簽核模式呼叫)
       g_action_choice CLIPPED = "insert"
    THEN
       IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF  #詢問是否執行確認功能 
    END IF
#CHI-C30107 -------------- add ----------------- end
    IF g_tc_evac.tc_evac01 IS NULL THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       RETURN
    END IF

    IF g_tc_evac.tc_evac10 = '1' THEN  #已核准
       CALL cl_err('','mfg3212',1)
       LET g_success = 'N'
       RETURN
    END IF   
  
      
    IF g_tc_evac.tc_evacacti = 'N' THEN  #本筆資料無效
       CALL cl_err('','abm-889',1)
       LET g_success = 'N'
       RETURN
    END IF

    IF (cl_null(g_tc_evac.tc_evac12) OR cl_null(g_tc_evac.tc_evac13) 
       OR (cl_null(g_tc_evac.tc_evac14) AND g_tc_evaa05='1'))    #教育訓練日期空，且為設備
       AND cl_null(g_tc_evac.tc_evac15) THEN
       CALL cl_err('','cpm-027',1)
       LET g_success = 'N'
       RETURN
    END IF
END FUNCTION

FUNCTION t002_y_upd()
  DEFINE i         LIKE type_file.num5
  DEFINE l_cnt     LIKE type_file.num5
  DEFINE c_tc_evac09   LIKE tc_evac_file.tc_evac09
  DEFINE c_tc_evac06   LIKE tc_evac_file.tc_evac06  

    LET g_success = 'Y'
    LET g_flag = 'Y' 

    IF g_action_choice CLIPPED = "confirm" OR  #執行 "確認" 功能(非簽核模式呼叫)
       g_action_choice CLIPPED = "insert"    
    THEN
       IF g_tc_evac.tc_evacmksg = 'Y' THEN        #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
          IF g_tc_evac.tc_evac10 != '1' THEN
             CALL cl_err('','aws-078',1)  #此狀況碼不為「1.已核准」，不可確認!!
             LET g_success = 'N'
             RETURN
          END IF
       END IF
    END IF

    BEGIN WORK

    IF g_success = 'Y' THEN
       IF g_tc_evac.tc_evacmksg = 'Y' THEN       #簽核模式
          CASE aws_efapp_formapproval()  #呼叫EF簽核功能
             WHEN 0  #呼叫EasyFlow簽核失敗
                LET g_success = "N"
                ROLLBACK WORK
                RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                ROLLBACK WORK
                RETURN
          END CASE
       END IF
   
       IF g_success = 'Y' THEN
          LET g_tc_evac.tc_evac10 = '1'  #執行成功，狀態值顯示為'1'已核准
          LET g_tc_evac.tc_evacconf = 'Y'
          UPDATE tc_evac_file SET tc_evac10 = '1',tc_evacconf='Y'
           WHERE tc_evac01 = g_tc_evac.tc_evac01
          DISPLAY BY NAME g_tc_evac.tc_evac10   
          DISPLAY BY NAME g_tc_evac.tc_evacconf  
          COMMIT WORK 
       ELSE
          LET g_success = "N"
          ROLLBACK WORK
       END IF
    ELSE
       LET g_success = "N"
       ROLLBACK WORK
    END IF   	                                         	    
END FUNCTION
 
FUNCTION t002_unconfirm()
  DEFINE l_cnt     LIKE type_file.num5

   
    LET g_success = 'Y' 
    LET g_flag ='Y'                
   
    IF g_tc_evac.tc_evac10 = '9' THEN RETURN END IF 
    IF g_tc_evac.tc_evac10 = 'S' THEN
       #送簽中, 不可修改資料!
       CALL cl_err(g_tc_evac.tc_evac10,'apm-030',1)
       RETURN
    END IF
    #非審核狀態 不能取消審核
    IF g_tc_evac.tc_evac10 !='1' THEN
       CALL  cl_err('','atm-053',1)
       RETURN
    END IF
    
    IF NOT cl_confirm('axm-109') THEN RETURN END IF

    #已轉請採 不能取消審核
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM pml_file
     WHERE pml16 NOT IN ('8','9')
       AND pml24 = g_tc_evac.tc_evac01
       AND pml21 = 0
    IF l_cnt > 0 THEN
       CALL  cl_err('','apm-515',1)
       RETURN
    END IF

    UPDATE tc_evac_file SET tc_evac10='0',tc_evacconf='N' 
     WHERE tc_evac01 = g_tc_evac.tc_evac01

    SELECT * INTO g_tc_evac.* FROM tc_evac_file WHERE tc_evac01 = g_tc_evac.tc_evac01
    
END FUNCTION
 
FUNCTION t002_ef()                                                                                                                  
     CALL t002_y_chk()  #CALL 原確認段的check段後在執行送簽
     IF g_success = 'N' THEN                                                                                                        
        RETURN                                                                                                                     
     END IF                                                                                                                         

     IF g_tc_evac.tc_evacacti = 'N' THEN
        CALL cl_err('','abm-885',1)
        LET g_success = 'N'
        RETURN
     END IF
     IF g_tc_evac.tc_evac10 = '1' THEN     
        CALL cl_err('','abm-884',1)
        LET g_success = 'N'
        RETURN
     END IF                                                                                                                       
                                                                                                                                    
     CALL aws_condition()  #判斷送簽資料                                                                                         
     IF g_success = 'N' THEN                                                                                                        
         RETURN                                                                                                                     
     END IF                                                                                                                         

 ##########
 # CALL aws_efcli2()
 # 傳入參數：(1)單頭資料,(2-6)單身資料
 # 回傳值：0 開單失敗; 1 開單成功
 ##########
                                                                                                                
 IF aws_efcli2(base.TypeInfo.create(g_tc_evac),base.TypeInfo.create(g_rvb),'','','','')                        
 THEN
   LET g_success='Y'                                                                                                   
  #重新更新狀態碼顯示
   SELECT tc_evac08 INTO g_tc_evac.tc_evac10 FROM tc_evac_file WHERE tc_evac01 = g_tc_evac.tc_evac01
   DISPLAY BY NAME g_tc_evac.tc_evac10      
 ELSE                                                                                                                               
   LET g_success='N'                                                                                                                
 END IF                                                                                                                             
                                                                                                                                    
END FUNCTION 
 
FUNCTION t002_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tc_evac01",TRUE)
   END IF   
END FUNCTION
 
FUNCTION t002_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("tc_evac01",FALSE)
   END IF
END FUNCTION
 
 
FUNCTION t002_tc_evab03(p_cmd)       
 
DEFINE  p_cmd   LIKE type_file.chr1   
 
   LET g_errno = " "
  SELECT ima02 INTO g_rvb[l_ac].rvb05
    FROM ima_file
   WHERE ima01 = g_rvb[l_ac].rvb05
   
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
                           LET g_rvb[l_ac].rvb051 = NULL
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE   
   
   IF g_rvb[l_ac].rvb05[1,4]='MISC' THEN
      CALL cl_set_comp_entry("rvb051",TRUE)
   END IF

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME g_rvb[l_ac].rvb05
   END IF 
 
END FUNCTION
 

#FUN-BC0018 add str---
FUNCTION t002_show_pic()
DEFINE l_chr3  LIKE type_file.chr1  #CHI-C80041
     IF g_tc_evac.tc_evac10 MATCHES '[1]' THEN
         LET g_chr1='Y'
         LET g_chr2='Y'
     ELSE
         LET g_chr1='N'
         LET g_chr2='N'
     END IF
     #CHI-C80041---begin
     IF g_tc_evac.tc_evac10 MATCHES '[9]' THEN
         LET l_chr3 = 'Y'
     ELSE
         LET l_chr3 = 'N'
     END IF 
     CALL cl_set_field_pic(g_chr1,g_chr2,"","",l_chr3,g_tc_evac.tc_evacacti)
END FUNCTION

FUNCTION t002_v(p_type)   
DEFINE   l_chr              LIKE type_file.chr1
DEFINE   l_chr1             LIKE type_file.chr1
DEFINE   l_flag             LIKE type_file.chr1  
DEFINE   p_type             LIKE type_file.chr1 

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_tc_evac.tc_evac01) THEN CALL cl_err('',-400,0) RETURN END IF  
   
   IF p_type = 1 THEN
      IF g_tc_evac.tc_evac10 ='9' THEN RETURN END IF
   ELSE
      IF g_tc_evac.tc_evac10 <>'9' THEN RETURN END IF
   END IF
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t002_cl USING g_tc_evac.tc_evac01
   IF STATUS THEN
      CALL cl_err("OPEN t002_cl:", STATUS, 1)
      CLOSE t002_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t002_cl INTO g_tc_evac.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_evac.tc_evac01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t002_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_tc_evac.tc_evac10 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      RETURN
   END IF  
   IF g_tc_evac.tc_evac10 = '0' THEN
      LET l_chr1 = 'N'
   ELSE
      LET l_chr1 = 'X'
   END IF 
   IF g_tc_evac.tc_evac10='9' AND NOT cl_null(g_sma.sma53) AND g_tc_evac.tc_evac02 <= g_sma.sma53 THEN
      CALL cl_err('','alm1393',0)
      RETURN
   END IF
   IF cl_void(0,0,l_chr1)   THEN 
        LET l_chr=g_tc_evac.tc_evac10
        IF p_type = 1 THEN        
            LET g_tc_evac.tc_evac10='9' 
        ELSE 
           IF g_tc_evac.tc_evac10='9' THEN
              LET g_tc_evac.tc_evac10='0'
           END IF 
        END IF
        UPDATE tc_evac_file
            SET tc_evac10=g_tc_evac.tc_evac10,  
                tc_evacmodu=g_user,
                tc_evacdate=g_today
            WHERE tc_evac01=g_tc_evac.tc_evac01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","tc_evac_file",g_tc_evac.tc_evac01,"",SQLCA.sqlcode,"","",1)  
            LET g_tc_evac.tc_evac10=l_chr 
        END IF
        DISPLAY BY NAME g_tc_evac.tc_evac10
   END IF
 
   CLOSE t002_cl
   COMMIT WORK
  
 
END FUNCTION
