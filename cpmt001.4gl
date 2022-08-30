# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cpmt001.4gl
# Descriptions...: 
# Date & Author..: NO.22080034  20220817 By momo 固定資產評估維護作業


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE g_tc_evaa         RECORD LIKE tc_evaa_file.*,      
       g_tc_evaa_t       RECORD LIKE tc_evaa_file.*,       
       g_tc_evaa_o       RECORD LIKE tc_evaa_file.*,       
       g_tc_evaa01_t     LIKE tc_evaa_file.tc_evaa01,          
       g_t1          LIKE smy_file.smyslip,              
       g_ydate       LIKE type_file.dat,          
       g_tc_evab         DYNAMIC ARRAY OF RECORD       
           tc_evab02     LIKE tc_evab_file.tc_evab02,          
           tc_evab03     LIKE tc_evab_file.tc_evab03,                   
           tc_evab04     LIKE tc_evab_file.tc_evab04,
           tc_evab05     LIKE tc_evab_file.tc_evab05,                                                                        
           tc_evab06     LIKE tc_evab_file.tc_evab06                    
                     END RECORD,
       g_tc_evab_t       RECORD                    
           tc_evab02     LIKE tc_evab_file.tc_evab02,          
           tc_evab03     LIKE tc_evab_file.tc_evab03,
           tc_evab04     LIKE tc_evab_file.tc_evab04,
           tc_evab05     LIKE tc_evab_file.tc_evab05,                                                                         
           tc_evab06     LIKE tc_evab_file.tc_evab06          
                     END RECORD,
       g_tc_evab_o       RECORD                      
           tc_evab02     LIKE tc_evab_file.tc_evab02,          
           tc_evab03     LIKE tc_evab_file.tc_evab03,
           tc_evab04     LIKE tc_evab_file.tc_evab04,
           tc_evab05     LIKE tc_evab_file.tc_evab05,                                                                        
           tc_evab06     LIKE tc_evab_file.tc_evab06          
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
DEFINE g_gem02             LIKE gem_file.gem02
DEFINE g_pmc03             LIKE pmc_file.pmc03 
DEFINE g_flag              LIKE type_file.chr1
DEFINE g_argv1             LIKE tc_evaa_file.tc_evaa01  #單號                    #FUN-BC0018
DEFINE g_argv2             STRING               #執行功能                #FUN-EC0001 add
DEFINE g_laststage         LIKE type_file.chr1  #是否為簽核最後一站flag  #FUN-BC0018
DEFINE g_chr1,g_chr2       LIKE type_file.chr1  #VARCHAR(1)              #FUN-BC0018
DEFINE g_pml          RECORD LIKE pml_file.*

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
   LET g_argv2 = ARG_VAL(2)              #執行功能 #FUN-EC0001 add
   IF fgl_getenv('EASYFLOW') = "1" THEN  #判斷是否為簽核模式
      LET g_argv1 = aws_efapp_wsk(1)     #取得單號,參數:key-1
   END IF
 
 
   LET g_forupd_sql = "SELECT * FROM tc_evaa_file WHERE tc_evaa01 = ? FOR UPDATE"   
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t001_cl CURSOR FROM g_forupd_sql
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN   
      OPEN WINDOW t001_w WITH FORM "cpm/42f/cpmt001"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
      CALL cl_set_locale_frm_name("cpmt001")    
      CALL cl_ui_init()
      CALL cl_set_combo_items_plus("tc_evaa05","cpmt001","tc_evaa05")
   END IF   
   
 
   CALL aws_efapp_toolbar()    #建立簽核模式時的toolbar icon
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, invalid, detail, query, locale, void, undo_void,confirm, undo_confirm, easyflow_approval")  #CHI-D20010 add undo_void
        RETURNING g_laststage  #傳入簽核模式時不應執行的action清單
  
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "efconfirm"
            CALL t001_q()
            CALL t001_y_chk()
            IF g_success = "Y" THEN
               CALL t001_y_upd()
            END IF
            EXIT PROGRAM
         OTHERWISE
            CALL t001_q()
      END CASE
   END IF
   
   CALL t001_menu()
   CLOSE WINDOW t001_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t001_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_tc_evab.clear()
    

   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " tc_evaa01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
   ELSE
 
      CONSTRUCT BY NAME g_wc ON tc_evaa01,tc_evaa02,tc_evaa03,tc_evaa04,tc_evaa09,tc_evaa06,tc_evaa08,tc_evaamksg,
                                tc_evaa05,tc_evaa07,tc_evaa11, 
                             tc_evaauser,tc_evaagrup,tc_evaamodu,tc_evaadate,tc_evaaacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(tc_evaa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="cq_tc_evaa01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evaa01                
                  NEXT FIELD tc_evaa01
                  
               WHEN INFIELD(tc_evaa03) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evaa03
                  NEXT FIELD tc_evaa03                  
      
               WHEN INFIELD(tc_evaa04) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evaa04
                  NEXT FIELD tc_evaa04
      
               WHEN INFIELD(tc_evaa09)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_pmc2"                  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evaa09
                  NEXT FIELD tc_evaa09
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
   
  
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_evaauser', 'tc_evaagrup')
 
   CONSTRUCT g_wc2 ON tc_evab02,tc_evab03,tc_evab04,   
                      tc_evab05,tc_evab06
             FROM s_tc_evab[1].tc_evab02,s_tc_evab[1].tc_evab03,s_tc_evab[1].tc_evab04,
                  s_tc_evab[1].tc_evab05,s_tc_evab[1].tc_evab06
 
      BEFORE CONSTRUCT
        CALL cl_qbe_display_condition(lc_qbe_sn)
   
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_evab03) 
              CALL q_sel_ima( TRUE, "q_ima08","","","","","","","",'')  RETURNING  g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_evab03
              NEXT FIELD tc_evab03              
                            
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
 
   IF g_wc2 = " 1=1" THEN                  
      LET g_sql = "SELECT tc_evaa01 FROM tc_evaa_file ",        #091020
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tc_evaa01"
   ELSE                             
      LET g_sql = "SELECT tc_evaa01 ",                        #091020
                  "  FROM tc_evaa_file, tc_evab_file ",
                  " WHERE tc_evaa01 = tc_evab01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY tc_evaa01"
   END IF
 
   PREPARE t001_prepare FROM g_sql
   DECLARE t001_cs                         
       SCROLL CURSOR WITH HOLD FOR t001_prepare
 
   IF g_wc2 = " 1=1" THEN                  
      LET g_sql="SELECT COUNT(*) FROM tc_evaa_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT tc_evaa01) FROM tc_evaa_file,tc_evab_file WHERE ",
                "tc_evab01=tc_evaa01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t001_precount FROM g_sql
   DECLARE t001_count CURSOR FOR t001_precount
 
END FUNCTION
 
FUNCTION t001_menu() 
DEFINE l_creator  LIKE type_file.chr1  #是否退回填表人      
DEFINE l_flowuser LIKE type_file.chr1  #是否有指定加簽人員  

   LET l_flowuser = "N"  #FUN-BC0018
 
   WHILE TRUE
      CALL t001_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t001_a()
               LET g_data_keyvalue = g_tc_evaa.tc_evaa01      
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t001_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t001_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t001_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t001_x()
            END IF
 
        # WHEN "reproduce"
        #    IF cl_chk_act_auth() THEN
        #       CALL t001_copy()
        #    END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t001_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "output"
            IF cl_chk_act_auth() THEN
               LET l_wc='tc_evaa01="',g_tc_evaa.tc_evaa01,'"'
               LET g_msg = "cpmr100",
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
               CALL t001_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t001_y_upd()       #CALL 原確認的 update 段
               END IF
             
               CALL t001_show() #圖示  
            END IF
 
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t001_unconfirm()
               CALL t001_show() 
            END IF
            
        WHEN "agree"                                       #執行EF簽核,"准"功能
           IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
              CALL t001_y_upd()                            #CALL 原確認的 update 段
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
                       CALL t001_q()
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

        WHEN "deny"                                                 #執行EF簽核,"不准"功能
           IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN  #退回關卡
              IF aws_efapp_formapproval() THEN                      #執行EF簽核
                 IF l_creator = "Y" THEN                            #當退回填表人時
                    LET g_tc_evaa.tc_evaa08 = 'R'                   #顯示狀態碼為'R' 送簽退回
                    DISPLAY BY NAME g_tc_evaa.tc_evaa08
                 END IF
                 IF cl_confirm('aws-081') THEN                      #詢問是否繼續下一筆資料的簽核
                    IF aws_efapp_getnextforminfo() THEN             #取得下一筆簽核單號
                       LET l_flowuser = 'N'
                       LET g_argv1 = aws_efapp_wsk(1)               #取得單號
                       IF NOT cl_null(g_argv1) THEN                 #自動query帶出資料
                          CALL t001_q()
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
                CALL t001_ef()
           END IF 

        WHEN "carry_pr"                  #拋轉請購單
           IF cl_chk_act_auth() THEN
                CALL t001_carry_pr()
           END IF
           
 
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_evab),'','')
            END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_evaa.tc_evaa01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_evaa01"
                 LET g_doc.value1 = g_tc_evaa.tc_evaa01
                 CALL cl_doc()
               END IF
         END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t001_v(1)  
               CALL t001_show_pic() 
            END IF
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t001_v(2)   
               CALL t001_show_pic()
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_evab TO s_tc_evab.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION jump
         CALL t001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION next
         CALL t001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL t001_fetch('L')
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

      ON ACTION carry_pr    
         LET g_action_choice = 'carry_pr'
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
 
FUNCTION t001_bp_refresh()
  DISPLAY ARRAY g_tc_evab TO s_tc_evab.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t001_a()
   DEFINE li_result   LIKE type_file.num5   
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10  
 
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_evab.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_tc_evaa.* LIKE tc_evaa_file.*             #DEFAULT 設定
   LET g_tc_evaa01_t = NULL
   LET g_tc_evaa.tc_evaa02 = g_today
   LET g_tc_evaa.tc_evaa03 = g_user
   LET g_tc_evaa.tc_evaa06 = 'N'
   LET g_tc_evaa.tc_evaa07 = 'A'
   LET g_tc_evaa.tc_evaa08 = '0'   
   LET g_tc_evaa.tc_evaamksg = 'N' 
   LET g_gen02 = NULL
   LET g_gem02 = NULL
   LET g_pmc03 = NULL
   SELECT gen02,gen03 INTO g_gen02,g_tc_evaa.tc_evaa04 FROM gen_file
    WHERE gen01 = g_user
   SELECT gem02 INTO g_gem02 FROM gem_file
    WHERE gem01 = g_tc_evaa.tc_evaa04   
 
   #預設值及將數值類變數清成零
   LET g_tc_evaa_t.* = g_tc_evaa.*
   LET g_tc_evaa_o.* = g_tc_evaa.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_tc_evaa.tc_evaauser=g_user
      LET g_tc_evaa.tc_evaaoriu = g_user 
      LET g_tc_evaa.tc_evaaorig = g_grup 
      LET g_data_plant = g_plant
      LET g_tc_evaa.tc_evaagrup=g_grup
      LET g_tc_evaa.tc_evaadate=g_today
      LET g_tc_evaa.tc_evaaacti='Y'              #資料有效
      LET g_tc_evaa.tc_evaaplant = g_plant
      LET g_tc_evaa.tc_evaalegal = g_legal 
 
      CALL t001_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_tc_evaa.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_tc_evaa.tc_evaa01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
      CALL s_auto_assign_no("apm",g_tc_evaa.tc_evaa01,g_tc_evaa.tc_evaa02,"A","tc_evaa_file","tc_evaa01","","","") RETURNING li_result,g_tc_evaa.tc_evaa01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_tc_evaa.tc_evaa01
 
      INSERT INTO tc_evaa_file VALUES (g_tc_evaa.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","tc_evaa_file",g_tc_evaa.tc_evaa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-B80100---上移一行調整至回滾事務前--- 
         ROLLBACK WORK     
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_tc_evaa.tc_evaa01,'I')
      END IF
 
      LET g_tc_evaa01_t = g_tc_evaa.tc_evaa01 
      LET g_tc_evaa_t.* = g_tc_evaa.*
      LET g_tc_evaa_o.* = g_tc_evaa.*
      CALL g_tc_evab.clear()
 
      LET g_rec_b = 0
      CALL t001_b()                   #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t001_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_evaa.tc_evaa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_tc_evaa.tc_evaa08 = '9' THEN RETURN END IF  
   IF g_tc_evaa.tc_evaa08 matches '[Ss1]' THEN     
      CALL cl_err("","mfg3557",1)
      LET g_success='N'
      RETURN                                                                                                                        
   END IF

 
   SELECT * INTO g_tc_evaa.* FROM tc_evaa_file
    WHERE tc_evaa01=g_tc_evaa.tc_evaa01
 
   IF g_tc_evaa.tc_evaaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tc_evaa.tc_evaa01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tc_evaa01_t = g_tc_evaa.tc_evaa01
   BEGIN WORK
 
   OPEN t001_cl USING g_tc_evaa.tc_evaa01    
   IF STATUS THEN
      CALL cl_err("OPEN t001_cl:", STATUS, 1)
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t001_cl INTO g_tc_evaa.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_evaa.tc_evaa01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t001_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t001_show()
 
   WHILE TRUE
      LET g_tc_evaa01_t = g_tc_evaa.tc_evaa01
      LET g_tc_evaa_o.* = g_tc_evaa.*
      LET g_tc_evaa.tc_evaamodu=g_user
      LET g_tc_evaa.tc_evaadate=g_today
 
      CALL t001_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tc_evaa.*=g_tc_evaa_t.*
         CALL t001_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_tc_evaa.tc_evaa01 != g_tc_evaa01_t THEN            # 更改單號
         UPDATE tc_evab_file SET tc_evab01 = g_tc_evaa.tc_evaa01
          WHERE tc_evab01 = g_tc_evaa01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","tc_evab_file",g_tc_evaa01_t,"",SQLCA.sqlcode,"","tc_evab",1)
            CONTINUE WHILE
         END IF
      END IF
 
      LET g_tc_evaa.tc_evaa08 = '0'  
      DISPLAY BY NAME g_tc_evaa.tc_evaa08  

      UPDATE tc_evaa_file SET tc_evaa_file.* = g_tc_evaa.*
       WHERE tc_evaa01 = g_tc_evaa01_t     
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","tc_evaa_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t001_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tc_evaa.tc_evaa01,'U')
 
   CALL t001_b_fill("1=1")
   CALL t001_bp_refresh()
 
END FUNCTION
 
FUNCTION t001_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,    
   p_cmd     LIKE type_file.chr1    
   DEFINE    li_result   LIKE type_file.num5
   DEFINE    l_sql       STRING
   DEFINE    l_tc_evaa06     LIKE tc_evaa_file.tc_evaa06
   DEFINE    l_cnt       LIKE type_file.num5      
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_tc_evaa.tc_evaauser,g_tc_evaa.tc_evaamodu,
       g_tc_evaa.tc_evaagrup,g_tc_evaa.tc_evaadate,g_tc_evaa.tc_evaaacti
   IF p_cmd = 'a' THEN    
      DISPLAY g_gen02 TO gen02
      DISPLAY g_gem02 TO gem02       
   END IF
   CALL cl_set_head_visible("","YES")         
   INPUT BY NAME g_tc_evaa.tc_evaa01,g_tc_evaa.tc_evaa02,g_tc_evaa.tc_evaa03,g_tc_evaa.tc_evaa04,
                 g_tc_evaa.tc_evaa05,g_tc_evaa.tc_evaa07,g_tc_evaa.tc_evaa11,
                 g_tc_evaa.tc_evaaoriu,g_tc_evaa.tc_evaaorig,
                 g_tc_evaa.tc_evaa06,g_tc_evaa.tc_evaa08,g_tc_evaa.tc_evaa09,
                 g_tc_evaa.tc_evaa10,g_tc_evaa.tc_evaamksg,
                 g_tc_evaa.tc_evaa12,g_tc_evaa.tc_evaa13    
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t001_set_entry(p_cmd)
         CALL t001_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("tc_evaa01")

      BEFORE FIELD tc_evaa01
        SELECT rye03 INTO g_tc_evaa.tc_evaa01 FROM rye_file
               WHERE rye01 = 'apm' AND ryeacti = 'Y' and rye02='A' AND ta_rye01='cpmt001'
            DISPLAY BY NAME g_tc_evaa.tc_evaa01
 
      AFTER FIELD tc_evaa01
         IF NOT cl_null(g_tc_evaa.tc_evaa01) THEN
            CALL s_check_no("apm",g_tc_evaa.tc_evaa01,g_tc_evaa01_t,"A","tc_evaa_file","tc_evaa01","") RETURNING li_result,g_tc_evaa.tc_evaa01
            DISPLAY BY NAME g_tc_evaa.tc_evaa01
            IF (NOT li_result) THEN
               LET g_tc_evaa.tc_evaa01=g_tc_evaa_o.tc_evaa01
               NEXT FIELD tc_evaa01
            END IF
            LET g_tc_evaa.tc_evaamksg = g_smy.smyapr
            DISPLAY BY NAME g_tc_evaa.tc_evaamksg
            DISPLAY g_smy.smydesc TO smydesc
         END IF
 
      AFTER FIELD tc_evaa03                
         IF NOT cl_null(g_tc_evaa.tc_evaa03) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt 
              FROM gen_file
             WHERE gen01 = g_tc_evaa.tc_evaa03
               AND genacti ='Y'
            IF l_cnt <= 0 THEN
               CALL cl_err('','aap-038',0)
               NEXT FIELD tc_evaa03
            END IF     
            LET g_gen02 = NULL
            SELECT gen02,gen03 INTO g_gen02,g_tc_evaa.tc_evaa04 FROM gen_file
             WHERE gen01 = g_tc_evaa.tc_evaa03
            DISPLAY g_gen02 TO gen02
            DISPLAY g_tc_evaa.tc_evaa04 TO tc_evaa04
         END IF
 
      AFTER FIELD tc_evaa04                
         IF NOT cl_null(g_tc_evaa.tc_evaa04) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt 
              FROM gem_file
             WHERE gem01 = g_tc_evaa.tc_evaa04
               AND gemacti ='Y'
            IF l_cnt <= 0 THEN
               CALL cl_err('','aap-039',0)
               NEXT FIELD tc_evaa04
            END IF         
            LET g_gem02 = NULL
            SELECT gem02 INTO g_gem02 FROM gem_file
             WHERE gem01 = g_tc_evaa.tc_evaa04
            DISPLAY g_gem02 TO gem02  
         END IF
 
      AFTER FIELD tc_evaa09               
         IF NOT cl_null(g_tc_evaa.tc_evaa09) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt 
              FROM pmc_file
             WHERE pmc01 = g_tc_evaa.tc_evaa09
               AND pmcacti ='Y'
            IF l_cnt <= 0 THEN
               CALL cl_err('','aap-000',0)
               NEXT FIELD tc_evaa09
            END IF         
            LET g_pmc03 = NULL
            SELECT pmc03,pmc22 INTO g_pmc03,g_tc_evaa.tc_evaa10 
              FROM pmc_file
             WHERE pmc01 = g_tc_evaa.tc_evaa09
            DISPLAY g_pmc03 TO pmc03
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
            WHEN INFIELD(tc_evaa01) 
                 LET g_t1=s_get_doc_no(g_tc_evaa.tc_evaa01)     
                 CALL q_smy(FALSE,FALSE,g_t1,'apm','A') RETURNING g_t1 
                 LET g_tc_evaa.tc_evaa01 = g_t1                 
                 DISPLAY BY NAME g_tc_evaa.tc_evaa01
                 CALL t001_tc_evaa01('d')
                 NEXT FIELD tc_evaa01
                 
            WHEN INFIELD(tc_evaa03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_tc_evaa.tc_evaa03
               CALL cl_create_qry() RETURNING g_tc_evaa.tc_evaa03
               DISPLAY BY NAME g_tc_evaa.tc_evaa03
               CALL t001_tc_evaa03('d')
               NEXT FIELD tc_evaa03                 
 
            WHEN INFIELD(tc_evaa04) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = g_tc_evaa.tc_evaa04
               CALL cl_create_qry() RETURNING g_tc_evaa.tc_evaa04
               DISPLAY BY NAME g_tc_evaa.tc_evaa04
               CALL t001_tc_evaa04('d')
               NEXT FIELD tc_evaa04
 
            WHEN INFIELD(tc_evaa09) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc2"
               LET g_qryparam.default1 = g_tc_evaa.tc_evaa09
               CALL cl_create_qry() RETURNING g_tc_evaa.tc_evaa09
               DISPLAY BY NAME g_tc_evaa.tc_evaa09
               CALL t001_tc_evaa09('d')
               NEXT FIELD tc_evaa09
 
            WHEN INFIELD(tc_evaa10) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_tc_evaa.tc_evaa10
               CALL cl_create_qry() RETURNING g_tc_evaa.tc_evaa10
               DISPLAY BY NAME g_tc_evaa.tc_evaa10
               NEXT FIELD tc_evaa09
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
 
FUNCTION t001_tc_evaa01(p_cmd)
   DEFINE l_smydesc LIKE smy_file.smydesc,
          l_smyacti LIKE smy_file.smyacti,
          l_t1      LIKE oay_file.oayslip, 
          p_cmd     LIKE type_file.chr1   
 
   LET g_errno = ' '
   LET l_t1 = s_get_doc_no(g_tc_evaa.tc_evaa01)
   IF g_tc_evaa.tc_evaa01 IS NULL THEN
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
 
FUNCTION t001_tc_evaa03(p_cmd)
   DEFINE l_gen02   LIKE gen_file.gen02,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT gen02 INTO l_gen02 FROM gen_file
    WHERE gen01 = g_tc_evaa.tc_evaa03
 
   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_gen02 = NULL
   END IF   
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO gen02
   END IF
 
END FUNCTION
 
FUNCTION t001_tc_evaa04(p_cmd)  
   DEFINE l_gem02   LIKE gem_file.gem02,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT gem02 INTO l_gem02 FROM gem_file
    WHERE gem01 = g_tc_evaa.tc_evaa04
 
   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_gem02 = NULL
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO gem02
   END IF
 
END FUNCTION
 
FUNCTION t001_tc_evaa09(p_cmd)
   DEFINE l_pmc03   LIKE pmc_file.pmc03,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pmc03 INTO l_pmc03 FROM pmc_file
    WHERE pmc01 = g_tc_evaa.tc_evaa09
 
   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_pmc03 = NULL
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO pmc03
   END IF
 
END FUNCTION
 
FUNCTION t001_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_msg("")  
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tc_evab.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t001_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_tc_evaa.* TO NULL
      RETURN
   END IF
 
   OPEN t001_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_evaa.* TO NULL
   ELSE
      OPEN t001_count
      FETCH t001_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t001_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t001_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1            
 
   CASE p_flag

      WHEN 'N' FETCH NEXT     t001_cs INTO g_tc_evaa.tc_evaa01               
      WHEN 'P' FETCH PREVIOUS t001_cs INTO g_tc_evaa.tc_evaa01               
      WHEN 'F' FETCH FIRST    t001_cs INTO g_tc_evaa.tc_evaa01               
      WHEN 'L' FETCH LAST     t001_cs INTO g_tc_evaa.tc_evaa01               
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
            FETCH ABSOLUTE g_jump t001_cs INTO g_tc_evaa.tc_evaa01                   
            LET g_no_ask = FALSE   
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_evaa.tc_evaa01,SQLCA.sqlcode,0)
      INITIALIZE g_tc_evaa.* TO NULL             
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
 
   SELECT * INTO g_tc_evaa.* FROM tc_evaa_file WHERE tc_evaa01 = g_tc_evaa.tc_evaa01  
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","tc_evaa_file","","",SQLCA.sqlcode,"","",1) 
      INITIALIZE g_tc_evaa.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_tc_evaa.tc_evaauser      
   LET g_data_group = g_tc_evaa.tc_evaagrup    
   LET g_data_plant = g_tc_evaa.tc_evaaplant   
   LET g_data_keyvalue = g_tc_evaa.tc_evaa01   
   CALL t001_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t001_show()
 
   LET g_tc_evaa_t.* = g_tc_evaa.*                #保存單頭舊值
   LET g_tc_evaa_o.* = g_tc_evaa.*                #保存單頭舊值
   LET g_data_keyvalue = g_tc_evaa.tc_evaa01      #No:FUN-F50016
   DISPLAY BY NAME g_tc_evaa.tc_evaa01,g_tc_evaa.tc_evaa02,g_tc_evaa.tc_evaa03, g_tc_evaa.tc_evaaoriu,g_tc_evaa.tc_evaaorig,
                   g_tc_evaa.tc_evaa04,g_tc_evaa.tc_evaa05,g_tc_evaa.tc_evaa07,g_tc_evaa.tc_evaa10,g_tc_evaa.tc_evaa11,
                   g_tc_evaa.tc_evaa09,g_tc_evaa.tc_evaa06,g_tc_evaa.tc_evaa08,g_tc_evaa.tc_evaamksg,  
                   g_tc_evaa.tc_evaa12,g_tc_evaa.tc_evaa13,g_tc_evaa.tc_evaa06,
                   g_tc_evaa.tc_evaauser,g_tc_evaa.tc_evaagrup,g_tc_evaa.tc_evaamodu,
                   g_tc_evaa.tc_evaadate,g_tc_evaa.tc_evaaacti
                   
   CALL t001_tc_evaa01('d')
   CALL t001_tc_evaa03('d')
   CALL t001_tc_evaa04('d')
   CALL t001_tc_evaa09('d')                    
 
   CALL t001_b_fill(g_wc2)                 #單身
   CALL t001_show_pic() #圖示  
   CALL cl_show_fld_cont()              
END FUNCTION
 
FUNCTION t001_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_evaa.tc_evaa01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_tc_evaa.tc_evaa08 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      LET g_success='N' RETURN
   END IF   
   BEGIN WORK
 
   OPEN t001_cl USING g_tc_evaa.tc_evaa01   
   IF STATUS THEN
      CALL cl_err("OPEN t001_cl:", STATUS, 1)
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t001_cl INTO g_tc_evaa.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_evaa.tc_evaa01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t001_show()
 
   IF cl_exp(0,0,g_tc_evaa.tc_evaaacti) THEN                   #確認一下
      LET g_chr=g_tc_evaa.tc_evaaacti
      IF g_tc_evaa.tc_evaaacti='Y' THEN
         LET g_tc_evaa.tc_evaaacti='N'
      ELSE
         LET g_tc_evaa.tc_evaaacti='Y'
      END IF
 
      UPDATE tc_evaa_file SET tc_evaaacti=g_tc_evaa.tc_evaaacti,
                          tc_evaamodu=g_user,
                          tc_evaadate=g_today
       WHERE tc_evaa01=g_tc_evaa.tc_evaa01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tc_evaa_file",g_tc_evaa.tc_evaa01,"",SQLCA.sqlcode,"","",1)  
         LET g_tc_evaa.tc_evaaacti=g_chr
      END IF
   END IF
 
   CLOSE t001_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_tc_evaa.tc_evaa01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT tc_evaaacti,tc_evaamodu,tc_evaadate
     INTO g_tc_evaa.tc_evaaacti,g_tc_evaa.tc_evaamodu,g_tc_evaa.tc_evaadate FROM tc_evaa_file
    WHERE tc_evaa01=g_tc_evaa.tc_evaa01
   DISPLAY BY NAME g_tc_evaa.tc_evaaacti,g_tc_evaa.tc_evaamodu,g_tc_evaa.tc_evaadate
 
END FUNCTION
 
FUNCTION t001_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_evaa.tc_evaa01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
  
   IF g_tc_evaa.tc_evaa08 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      LET g_success='N' 
      RETURN
   END IF   
 
   SELECT * INTO g_tc_evaa.* FROM tc_evaa_file
    WHERE tc_evaa01=g_tc_evaa.tc_evaa01
 
   BEGIN WORK
 
   OPEN t001_cl USING g_tc_evaa.tc_evaa01  
   IF STATUS THEN
      CALL cl_err("OPEN t001_cl:", STATUS, 1)
      CLOSE t001_cl
      ROLLBACK WORK
  
      RETURN
   END IF
 
   FETCH t001_cl INTO g_tc_evaa.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_evaa.tc_evaa01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t001_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL         
       LET g_doc.column1 = "tc_evaa01"         
       LET g_doc.value1 = g_tc_evaa.tc_evaa01     
       CALL cl_del_doc()                
      DELETE FROM tc_evaa_file WHERE tc_evaa01 = g_tc_evaa.tc_evaa01
      DELETE FROM tc_evab_file WHERE tc_evab01 = g_tc_evaa.tc_evaa01
      CLEAR FORM
      CALL g_tc_evab.clear()
      OPEN t001_count
      IF STATUS THEN
         CLOSE t001_cs  
         CLOSE t001_count
         COMMIT WORK
         RETURN
      END IF
      FETCH t001_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t001_cs  
         CLOSE t001_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t001_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t001_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE   
         CALL t001_fetch('/')
      END IF
   END IF
 
   CLOSE t001_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tc_evaa.tc_evaa01,'D')
END FUNCTION
 
#單身
FUNCTION t001_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              
    l_n             LIKE type_file.num5,            
    l_n1            LIKE type_file.num5,               
    l_n2            LIKE type_file.num5,               
    l_n3            LIKE type_file.num5,               
    l_cnt           LIKE type_file.num5,               
    l_lock_sw       LIKE type_file.chr1,             
    p_cmd           LIKE type_file.chr1,                            
    l_allow_insert  LIKE type_file.num5,               
    l_allow_delete  LIKE type_file.num5   
 
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000
DEFINE l_ima926  LIKE ima_file.ima926  
DEFINE l_count   LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE l_tc_evaa06   LIKE tc_evaa_file.tc_evaa06
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_tc_evaa.tc_evaa01 IS NULL THEN
       RETURN
    END IF
 
 
    IF g_tc_evaa.tc_evaa08 ='9' THEN RETURN END IF  
    IF g_tc_evaa.tc_evaa08 matches '[Ss1]' THEN     
       CALL cl_err("","mfg3557",1) 
       LET g_success='N' 
       RETURN
    END IF    

 
    SELECT * INTO g_tc_evaa.* FROM tc_evaa_file
     WHERE tc_evaa01=g_tc_evaa.tc_evaa01
 
    IF g_tc_evaa.tc_evaaacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_tc_evaa.tc_evaa01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_evab02,tc_evab03,tc_evab04,tc_evab05,tc_evab06",
                       "  FROM tc_evab_file",
                       " WHERE tc_evab01=? AND tc_evab02=? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tc_evab WITHOUT DEFAULTS FROM s_tc_evab.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW           
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           CALL t001_set_entry_b()
           CALL t001_set_no_entry_b()
 
           BEGIN WORK
 
           OPEN t001_cl USING g_tc_evaa.tc_evaa01  
           IF STATUS THEN
              CALL cl_err("OPEN t001_cl:", STATUS, 1)
              CLOSE t001_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t001_cl INTO g_tc_evaa.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tc_evaa.tc_evaa01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t001_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_tc_evab_t.* = g_tc_evab[l_ac].*  #BACKUP
              LET g_tc_evab_o.* = g_tc_evab[l_ac].*  #BACKUP
              OPEN t001_bcl USING g_tc_evaa.tc_evaa01,g_tc_evab_t.tc_evab02
              IF STATUS THEN
                 CALL cl_err("OPEN t001_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t001_bcl INTO g_tc_evab[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_evab_t.tc_evab02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t001_tc_evab03('d')                 
              CALL cl_show_fld_cont()     
              END IF
           END IF 
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_evab[l_ac].* TO NULL        
           LET g_tc_evab_t.* = g_tc_evab[l_ac].*        
           LET g_tc_evab_o.* = g_tc_evab[l_ac].*        
           LET g_tc_evab[l_ac].tc_evab04 = ' '    #MOD-G30024 add
           CALL cl_show_fld_cont()         
           NEXT FIELD tc_evab02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_tc_evab[l_ac].tc_evab04) THEN
              LET g_tc_evab[l_ac].tc_evab04 = ' '
           END IF
           INSERT INTO tc_evab_file(tc_evab01,tc_evab02,tc_evab03,tc_evab04,tc_evab05,tc_evab06,
                                tc_evabplant,tc_evablegal)  
           VALUES(g_tc_evaa.tc_evaa01,g_tc_evab[l_ac].tc_evab02,
                  g_tc_evab[l_ac].tc_evab03,g_tc_evab[l_ac].tc_evab04,
                  g_tc_evab[l_ac].tc_evab05,g_tc_evab[l_ac].tc_evab06,
                  g_plant,g_legal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_evab_file",g_tc_evaa.tc_evaa01,g_tc_evab[l_ac].tc_evab02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD tc_evab02                       
           IF g_tc_evab[l_ac].tc_evab02 IS NULL OR g_tc_evab[l_ac].tc_evab02 = 0 THEN
              SELECT max(tc_evab02)+1
                INTO g_tc_evab[l_ac].tc_evab02
                FROM tc_evab_file
               WHERE tc_evab01 = g_tc_evaa.tc_evaa01
              IF g_tc_evab[l_ac].tc_evab02 IS NULL THEN
                 LET g_tc_evab[l_ac].tc_evab02 = 1
              END IF
           END IF
 
        AFTER FIELD tc_evab02                        #check 序號是否重複
           IF NOT cl_null(g_tc_evab[l_ac].tc_evab02) THEN
              IF g_tc_evab[l_ac].tc_evab02 != g_tc_evab_t.tc_evab02
                 OR g_tc_evab_t.tc_evab02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM tc_evab_file
                  WHERE tc_evab01 = g_tc_evaa.tc_evaa01
                    AND tc_evab02 = g_tc_evab[l_ac].tc_evab02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tc_evab[l_ac].tc_evab02 = g_tc_evab_t.tc_evab02
                    NEXT FIELD tc_evab02
                 END IF
              END IF
           END IF
           
        AFTER FIELD tc_evab03
           IF cl_null(g_tc_evab[l_ac].tc_evab03) THEN
              NEXT FIELD tc_evab03
           END IF                                  
           IF NOT cl_null(g_tc_evab[l_ac].tc_evab03) THEN
              LET l_n1 = 0
              SELECT COUNT(*) INTO l_n1 FROM ima_file
               WHERE ima01 = g_tc_evab[l_ac].tc_evab03
              IF l_n1 = 0 THEN
                 CALL cl_err('','mfg0002',0)
                 NEXT FIELD tc_evab03
              END IF
              CALL t001_tc_evab03('d') 
           END IF
           
        AFTER FIELD tc_evab04
           IF cl_null(g_tc_evab[l_ac].tc_evab04) THEN
              NEXT FIELD tc_evab04
           END IF 
           
        AFTER FIELD tc_evab05
           IF cl_null(g_tc_evab[l_ac].tc_evab05) THEN
              NEXT FIELD tc_evab05
           END IF 

        AFTER FIELD tc_evab06
           IF cl_null(g_tc_evab[l_ac].tc_evab06) THEN
              NEXT FIELD tc_evab06
           END IF 
           
        BEFORE FIELD tc_evab06
              CALL t001_set_entry_b()
              CALL t001_set_no_entry_b()
              CALL t001_tc_evaa06()        
              IF g_tc_evaa.tc_evaa06 = '3' THEN
                 CALL cl_err('','abm-013',0)
              END IF
 
                      
                      
        BEFORE DELETE                     
           DISPLAY "BEFORE DELETE"
           IF g_tc_evab_t.tc_evab02 > 0 AND g_tc_evab_t.tc_evab02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM tc_evab_file
               WHERE tc_evab01 = g_tc_evaa.tc_evaa01
                 AND tc_evab02 = g_tc_evab_t.tc_evab02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_evab_file",g_tc_evaa.tc_evaa01,g_tc_evab_t.tc_evab02,SQLCA.sqlcode,"","",1)
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
              LET g_tc_evab[l_ac].* = g_tc_evab_t.*
              CLOSE t001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_evab[l_ac].tc_evab02,-263,1)
              LET g_tc_evab[l_ac].* = g_tc_evab_t.*
           ELSE
              UPDATE tc_evab_file SET tc_evab02=g_tc_evab[l_ac].tc_evab02,
                                  tc_evab03=g_tc_evab[l_ac].tc_evab03,
                                  tc_evab04=g_tc_evab[l_ac].tc_evab04,
                                  tc_evab05=g_tc_evab[l_ac].tc_evab05,
                                  tc_evab06=g_tc_evab[l_ac].tc_evab06                                 
               WHERE tc_evab01=g_tc_evaa.tc_evaa01
                 AND tc_evab02=g_tc_evab_t.tc_evab02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tc_evab_file",g_tc_evaa.tc_evaa01,g_tc_evab_t.tc_evab02,SQLCA.sqlcode,"","",1)
                 LET g_tc_evab[l_ac].* = g_tc_evab_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_tc_evab[l_ac].* = g_tc_evab_t.*
              ELSE
                 CALL g_tc_evab.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              END IF
              CLOSE t001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  
           CLOSE t001_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tc_evab02) AND l_ac > 1 THEN
              LET g_tc_evab[l_ac].* = g_tc_evab[l_ac-1].*
              LET g_tc_evab[l_ac].tc_evab02 = g_rec_b + 1
              NEXT FIELD tc_evab02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION itemno
           IF g_sma.sma38 matches'[Yy]' THEN
              CALL cl_cmdrun("aimi109 ")
           ELSE
              CALL cl_err(g_sma.sma38,'mfg0035',1)
           END IF
           
        ON ACTION CONTROLP
           CASE           
            WHEN INFIELD(tc_evab03) 
              CALL q_sel_ima(FALSE, "q_ima08", "", "" , "", "", "", "" ,"",'' )  RETURNING g_tc_evab[l_ac].tc_evab03 
              CALL t001_tc_evab03('d')
              NEXT FIELD tc_evab03
                          
           END CASE
 
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
 
    LET g_tc_evaa.tc_evaamodu = g_user
    LET g_tc_evaa.tc_evaadate = g_today
    LET g_tc_evaa.tc_evaa08 = '0'  
    UPDATE tc_evaa_file SET tc_evaamodu = g_tc_evaa.tc_evaamodu,tc_evaadate = g_tc_evaa.tc_evaadate,tc_evaa08 = g_tc_evaa.tc_evaa08 
     WHERE tc_evaa01 = g_tc_evaa.tc_evaa01
    DISPLAY BY NAME g_tc_evaa.tc_evaamodu,g_tc_evaa.tc_evaadate,g_tc_evaa.tc_evaa08  
 
    CLOSE t001_bcl
    COMMIT WORK
    CALL t001_delHeader()
END FUNCTION

FUNCTION t001_delHeader()
   DEFINE l_action_choice    STRING               
   DEFINE l_cho              LIKE type_file.num5  
   DEFINE l_num              LIKE type_file.num5  
   DEFINE l_slip             LIKE type_file.chr5  
   DEFINE l_sql              STRING               
   DEFINE l_cnt              LIKE type_file.num5  
   DEFINE l_n                LIKE type_file.num5

   SELECT COUNT(*) INTO l_n FROM tc_evab_file WHERE tc_evab01 = g_tc_evaa.tc_evaa01

   IF l_n = 0 THEN
      CALL s_get_doc_no(g_tc_evaa.tc_evaa01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM tc_evaa_file ",
                  "  WHERE tc_evaa01 LIKE '",l_slip,"%' ",
                  "    AND tc_evaa01 > '",g_tc_evaa.tc_evaa01,"'"
      PREPARE t001_pb6 FROM l_sql 
      EXECUTE t001_pb6 INTO l_cnt       
      
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
         CALL t001_v(1)  
         CALL t001_show_pic()
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM tc_evaa_file WHERE tc_evaa01 = g_tc_evaa.tc_evaa01
         INITIALIZE g_tc_evaa.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION

 
FUNCTION t001_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
 
   LET g_sql = "SELECT tc_evab02,tc_evab03,tc_evab04,tc_evab05,",
               " tc_evab06 FROM tc_evab_file",
               " WHERE tc_evab01 ='",g_tc_evaa.tc_evaa01,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY tc_evab02"
   DISPLAY g_sql
 
   PREPARE t001_pb FROM g_sql
   DECLARE tc_evab_cs CURSOR FOR t001_pb
 
   CALL g_tc_evab.clear()
   LET g_cnt = 1
 
   FOREACH tc_evab_cs INTO g_tc_evab[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT ima02 INTO g_tc_evab[g_cnt].tc_evab04
         FROM ima_file
        WHERE ima01 = g_tc_evab[g_cnt].tc_evab03 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_tc_evab.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t001_copy()
   DEFINE l_newno     LIKE tc_evaa_file.tc_evaa01,
          l_newdate   LIKE tc_evaa_file.tc_evaa02,
          l_oldno     LIKE tc_evaa_file.tc_evaa01
   DEFINE li_result   LIKE type_file.num5 
   DEFINE l_slip      LIKE smy_file.smyslip  
   DEFINE l_tc_evaamksg   LIKE tc_evaa_file.tc_evaamksg 
   
   IF s_shut(0) THEN RETURN END IF
 
   IF g_tc_evaa.tc_evaa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   
   CALL cl_set_head_visible("","YES")           
   INPUT l_newno,l_newdate FROM tc_evaa01,tc_evaa02
       BEFORE INPUT
          CALL cl_set_docno_format("tc_evaa01")
          CALL cl_set_comp_required("tc_evaa02",TRUE)    
          CALL cl_set_comp_entry("tc_evaa01,tc_evaa02",TRUE) 
          LET l_newdate=g_today                     
          DISPLAY l_newdate TO tc_evaa02               
 
       AFTER FIELD tc_evaa01
           IF l_newno[1,g_doc_len] IS NULL THEN
              NEXT FIELD tc_evaa01
           END IF
           IF NOT cl_null(l_newno) THEN
              LET g_t1=s_get_doc_no(l_newno)
              CALL s_check_no("apm",l_newno,"","A","tc_evaa_file","tc_evaa01","") RETURNING li_result,l_newno
              DISPLAY l_newno TO tc_evaa01
              IF (NOT li_result) THEN
                 NEXT FIELD tc_evaa01
              END IF
 
              DISPLAY g_smy.smydesc TO smydesc           #單據名稱
           END IF
 
       AFTER FIELD tc_evaa02
           IF cl_null(l_newdate) THEN NEXT FIELD tc_evaa02 END IF
 
           BEGIN WORK 
           CALL s_auto_assign_no("apm",l_newno,l_newdate,"","tc_evaa_file","tc_evaa01","","","") RETURNING li_result,l_newno
           IF (NOT li_result) THEN
              NEXT FIELD tc_evaa01
           END IF
           DISPLAY l_newno TO tc_evaa01
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(tc_evaa01) #單據編號
                LET g_t1=s_get_doc_no(l_newno)       
                CALL q_smy(FALSE,FALSE,g_t1,'apm','A') RETURNING g_t1 
                LET l_newno=g_t1                     
                DISPLAY BY NAME l_newno
                NEXT FIELD tc_evaa01
              OTHERWISE EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about        
        CALL cl_about()      
 
     ON ACTION help         
        CALL cl_show_help() 
 
     ON ACTION controlg    
        CALL cl_cmdask()   
 

     AFTER INPUT                                
        CALL cl_set_comp_required("tc_evaa02",FALSE) 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_tc_evaa.tc_evaa01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM tc_evaa_file         #單頭複製
       WHERE tc_evaa01=g_tc_evaa.tc_evaa01
       INTO TEMP y
   CALL s_get_doc_no(l_newno) RETURNING l_slip
   SELECT smyapr INTO l_tc_evaamksg
     FROM smy_file 
    WHERE smyslip = l_slip
   IF cl_null(l_tc_evaamksg) THEN LET l_tc_evaamksg = 'N' END IF 
   UPDATE y
       SET tc_evaa01=l_newno,    #新的鍵值
           tc_evaa02=l_newdate,  
           tc_evaauser=g_user,   #資料所有者
           tc_evaagrup=g_grup,   #資料所有者所屬群
           tc_evaamodu=NULL,     #資料修改日期
           tc_evaadate=g_today,  #資料建立日期
           tc_evaaacti='Y',      #有效資料
           tc_evaa08='0',        #狀況碼  
           tc_evaamksg = l_tc_evaamksg  
 
   INSERT INTO tc_evaa_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","tc_evaa_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM tc_evab_file         #單身複製
       WHERE tc_evab01=g_tc_evaa.tc_evaa01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET tc_evab01=l_newno
 
   INSERT INTO tc_evab_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","tc_evab_file","","",SQLCA.sqlcode,"","",1)    #上移一行調整至回滾事務前---
      ROLLBACK WORK 
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_tc_evaa.tc_evaa01
   SELECT tc_evaa_file.* INTO g_tc_evaa.* FROM tc_evaa_file WHERE tc_evaa01 = l_newno                      
   CALL t001_u()
   CALL t001_b()
 
END FUNCTION


FUNCTION t001_y_chk()
  DEFINE l_n      LIKE type_file.num5  
  
    LET g_success = 'Y'
 
    IF g_tc_evaa.tc_evaa01 IS NULL THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       RETURN
    END IF
    IF g_tc_evaa.tc_evaa08 = '9' THEN 
       LET g_success = 'N'
       RETURN 
    END IF  
    IF g_tc_evaa.tc_evaa08 = '1' THEN  #已核准
       CALL cl_err('','mfg3212',1)
       LET g_success = 'N'
       RETURN
    END IF

    IF g_tc_evaa.tc_evaa06 = '3' THEN  #已承認
       SELECT COUNT(*) INTO l_n FROM tc_evab_file
        WHERE tc_evab01 = g_tc_evaa.tc_evaa01
          AND (tc_evab06 IS NULL OR tc_evab10 IS NULL)
       IF l_n > 0 THEN
          CALL cl_err('','abm-013',0)
          LET g_success = 'N'
          RETURN
       END IF
    END IF

    IF g_tc_evaa.tc_evaaacti = 'N' THEN  #本筆資料無效
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
    IF g_tc_evaa.tc_evaa01 IS NULL THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       RETURN
    END IF

    IF g_tc_evaa.tc_evaa08 = '1' THEN  #已核准
       CALL cl_err('','mfg3212',1)
       LET g_success = 'N'
       RETURN
    END IF   
  
    IF g_tc_evaa.tc_evaa06 = '3' THEN  #已承認
       SELECT COUNT(*) INTO l_n FROM tc_evab_file
        WHERE tc_evab01 = g_tc_evaa.tc_evaa01
          AND (tc_evab06 IS NULL OR tc_evab10 IS NULL)
       IF l_n > 0 THEN
          CALL cl_err('','abm-013',0)
          LET g_success = 'N'
          RETURN
       END IF
    END IF   
    
    IF g_tc_evaa.tc_evaaacti = 'N' THEN  #本筆資料無效
       CALL cl_err('','abm-889',1)
       LET g_success = 'N'
       RETURN
    END IF
END FUNCTION

FUNCTION t001_y_upd()
  DEFINE i         LIKE type_file.num5
  DEFINE l_cnt     LIKE type_file.num5
  DEFINE c_tc_evaa09   LIKE tc_evaa_file.tc_evaa09
  DEFINE c_tc_evaa06   LIKE tc_evaa_file.tc_evaa06  
  DEFINE c_tc_evab02   LIKE tc_evab_file.tc_evab02
  DEFINE c_tc_evab03   LIKE tc_evab_file.tc_evab03  
  DEFINE c_tc_evab04   LIKE tc_evab_file.tc_evab04  

    LET g_success = 'Y'
    LET g_flag = 'Y' 

    IF g_action_choice CLIPPED = "confirm" OR  #執行 "確認" 功能(非簽核模式呼叫)
       g_action_choice CLIPPED = "insert"    
    THEN
       IF g_tc_evaa.tc_evaamksg = 'Y' THEN        #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
          IF g_tc_evaa.tc_evaa08 != '1' THEN
             CALL cl_err('','aws-078',1)  #此狀況碼不為「1.已核准」，不可確認!!
             LET g_success = 'N'
             RETURN
          END IF
       END IF
    END IF

    BEGIN WORK

    IF g_success = 'Y' THEN
       IF g_tc_evaa.tc_evaamksg = 'Y' THEN       #簽核模式
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
          LET g_tc_evaa.tc_evaa08 = '1'  #執行成功，狀態值顯示為'1'已核准
          LET g_tc_evaa.tc_evaa06 = 'Y'
          UPDATE tc_evaa_file SET tc_evaa08 = '1',tc_evaa06='Y'
           WHERE tc_evaa01 = g_tc_evaa.tc_evaa01
          DISPLAY BY NAME g_tc_evaa.tc_evaa08   
          DISPLAY BY NAME g_tc_evaa.tc_evaa06  
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
 
FUNCTION t001_unconfirm()
  DEFINE l_cnt     LIKE type_file.num5

   
    LET g_success = 'Y' 
    LET g_flag ='Y'                
   
    IF g_tc_evaa.tc_evaa08 = '9' THEN RETURN END IF 
    IF g_tc_evaa.tc_evaa08 = 'S' THEN
       #送簽中, 不可修改資料!
       CALL cl_err(g_tc_evaa.tc_evaa08,'apm-030',1)
       RETURN
    END IF
    #非審核狀態 不能取消審核
    IF g_tc_evaa.tc_evaa08 !='1' THEN
       CALL  cl_err('','atm-053',1)
       RETURN
    END IF
    
    IF NOT cl_confirm('axm-109') THEN RETURN END IF

    #已轉請採 不能取消審核
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM pml_file
     WHERE pml16 NOT IN ('8','9')
       AND pml24 = g_tc_evaa.tc_evaa01
       AND pml21 = 0
    IF l_cnt > 0 THEN
       CALL  cl_err('','apm-515',1)
       RETURN
    END IF

    UPDATE tc_evaa_file SET tc_evaa08='0',tc_evaa06='N' 
     WHERE tc_evaa01 = g_tc_evaa.tc_evaa01

    SELECT * INTO g_tc_evaa.* FROM tc_evaa_file WHERE tc_evaa01 = g_tc_evaa.tc_evaa01
    
END FUNCTION
 
FUNCTION t001_ef()                                                                                                                  
     CALL t001_y_chk()  #CALL 原確認段的check段後在執行送簽
     IF g_success = 'N' THEN                                                                                                        
        RETURN                                                                                                                     
     END IF                                                                                                                         

     IF g_tc_evaa.tc_evaaacti = 'N' THEN
        CALL cl_err('','abm-885',1)
        LET g_success = 'N'
        RETURN
     END IF
     IF g_tc_evaa.tc_evaa08 = '1' THEN     
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
                                                                                                                
 IF aws_efcli2(base.TypeInfo.create(g_tc_evaa),base.TypeInfo.create(g_tc_evab),'','','','')                        
 THEN
   LET g_success='Y'                                                                                                   
  #重新更新狀態碼顯示
   SELECT tc_evaa08 INTO g_tc_evaa.tc_evaa08 FROM tc_evaa_file WHERE tc_evaa01 = g_tc_evaa.tc_evaa01
   DISPLAY BY NAME g_tc_evaa.tc_evaa08      
 ELSE                                                                                                                               
   LET g_success='N'                                                                                                                
 END IF                                                                                                                             
                                                                                                                                    
END FUNCTION 
 
FUNCTION t001_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tc_evaa01",TRUE)
   END IF   
END FUNCTION
 
FUNCTION t001_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tc_evaa01",FALSE)
   END IF
END FUNCTION
 
FUNCTION t001_set_entry_b() 
   IF g_tc_evaa.tc_evaa06='3' THEN
     #CALL cl_set_comp_entry("tc_evab06",TRUE)
   END IF
END FUNCTION
 
FUNCTION t001_set_no_entry_b()
   IF g_tc_evaa.tc_evaa06<>'3' THEN
    # CALL cl_set_comp_entry("tc_evab06",FALSE)
   END IF
END FUNCTION
 
FUNCTION t001_tc_evaa06()
   IF g_tc_evaa.tc_evaa06<>'3' THEN
     # LET g_tc_evab[l_ac].tc_evab06=NULL
   END IF
END FUNCTION
 
FUNCTION t001_tc_evab03(p_cmd)       
 
DEFINE  p_cmd   LIKE type_file.chr1   
 
   LET g_errno = " "
  SELECT ima02 INTO g_tc_evab[l_ac].tc_evab04
    FROM ima_file
   WHERE ima01 = g_tc_evab[l_ac].tc_evab03
   
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
                           LET g_tc_evab[l_ac].tc_evab04 = NULL
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE   
   
   IF g_tc_evab[l_ac].tc_evab03[1,4]='MISC' THEN
      CALL cl_set_comp_entry("tc_evab04",TRUE)
   END IF

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME g_tc_evab[l_ac].tc_evab04
   END IF 
 
END FUNCTION
 

#FUN-BC0018 add str---
FUNCTION t001_show_pic()
DEFINE l_chr3  LIKE type_file.chr1  #CHI-C80041
     IF g_tc_evaa.tc_evaa08 MATCHES '[1]' THEN
         LET g_chr1='Y'
         LET g_chr2='Y'
     ELSE
         LET g_chr1='N'
         LET g_chr2='N'
     END IF
     #CHI-C80041---begin
     IF g_tc_evaa.tc_evaa08 MATCHES '[9]' THEN
         LET l_chr3 = 'Y'
     ELSE
         LET l_chr3 = 'N'
     END IF 
     CALL cl_set_field_pic(g_chr1,g_chr2,"","",l_chr3,g_tc_evaa.tc_evaaacti)
END FUNCTION

FUNCTION t001_v(p_type)   
DEFINE   l_chr              LIKE type_file.chr1
DEFINE   l_chr1             LIKE type_file.chr1
DEFINE   l_flag             LIKE type_file.chr1  
DEFINE   p_type             LIKE type_file.chr1 

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_tc_evaa.tc_evaa01) THEN CALL cl_err('',-400,0) RETURN END IF  
   
   IF p_type = 1 THEN
      IF g_tc_evaa.tc_evaa08 ='9' THEN RETURN END IF
   ELSE
      IF g_tc_evaa.tc_evaa08 <>'9' THEN RETURN END IF
   END IF
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t001_cl USING g_tc_evaa.tc_evaa01
   IF STATUS THEN
      CALL cl_err("OPEN t001_cl:", STATUS, 1)
      CLOSE t001_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t001_cl INTO g_tc_evaa.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_evaa.tc_evaa01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t001_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_tc_evaa.tc_evaa08 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      RETURN
   END IF  
   IF g_tc_evaa.tc_evaa08 = '0' THEN
      LET l_chr1 = 'N'
   ELSE
      LET l_chr1 = 'X'
   END IF 
   IF g_tc_evaa.tc_evaa08='9' AND NOT cl_null(g_sma.sma53) AND g_tc_evaa.tc_evaa02 <= g_sma.sma53 THEN
      CALL cl_err('','alm1393',0)
      RETURN
   END IF
   IF cl_void(0,0,l_chr1)   THEN 
        LET l_chr=g_tc_evaa.tc_evaa08
        IF p_type = 1 THEN        
            LET g_tc_evaa.tc_evaa08='9' 
        ELSE 
           IF g_tc_evaa.tc_evaa08='9' THEN
              LET g_tc_evaa.tc_evaa08='0'
           END IF 
        END IF
        UPDATE tc_evaa_file
            SET tc_evaa08=g_tc_evaa.tc_evaa08,  
                tc_evaamodu=g_user,
                tc_evaadate=g_today
            WHERE tc_evaa01=g_tc_evaa.tc_evaa01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","tc_evaa_file",g_tc_evaa.tc_evaa01,"",SQLCA.sqlcode,"","",1)  
            LET g_tc_evaa.tc_evaa08=l_chr 
        END IF
        DISPLAY BY NAME g_tc_evaa.tc_evaa08 
   END IF
 
   CLOSE t001_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tc_evaa.tc_evaa01,'V')
 
END FUNCTION

FUNCTION t001_carry_pr()   #轉請購
  DEFINE l_buf        LIKE oay_file.oayslip   
  DEFINE l_pmk        RECORD LIKE pmk_file.*     
  DEFINE l_pmk01      LIKE pmk_file.pmk01
  DEFINE l_tc_evab05  LIKE tc_evab_file.tc_evab05  
  DEFINE l_tc_evab02  LIKE tc_evab_file.tc_evab02  
  DEFINE l_sql        STRING 
  DEFINE l_cnt        LIKE type_file.num5    
  DEFINE l_cnt1       LIKE type_file.num5   
  DEFINE tm RECORD
         wc       STRING,                 
         tc_evab01    LIKE tc_evab_file.tc_evab01,
         tc_evab02    LIKE tc_evab_file.tc_evab02,
         slip         LIKE oay_file.oayslip  
         END RECORD 
  DEFINE l_slip       LIKE oay_file.oayslip 
  DEFINE l_prog_t     STRING
  DEFINE l_tc_evaa    RECORD LIKE tc_evaa_file.*
  DEFINE l_gfa        RECORD LIKE gfa_file.*
  DEFINE p_row,p_col  LIKE type_file.num5
  DEFINE li_cnt       LIKE type_file.num5     
  DEFINE li_success   STRING              
  DEFINE l_chr        STRING              
  DEFINE l_tc_evab03  LIKE tc_evab_file.tc_evab03  
  DEFINE l_ima25      LIKE ima_file.ima25  #庫存單位
  DEFINE l_ima44      LIKE ima_file.ima44  #採購單位
  DEFINE l_flag       LIKE type_file.num5  
  DEFINE l_fac        LIKE img_file.img21  
  DEFINE l_t          LIKE type_file.num5  
  DEFINE l_n          LIKE type_file.num5,  
         p_flag       LIKE type_file.chr1 
  DEFINE li_result    LIKE type_file.num5  
  DEFINE l_smydmy4    LIKE smy_file.smydmy4 
  DEFINE l_cmd        LIKE type_file.chr1000 
  WHENEVER ERROR CONTINUE                #忽略一切錯誤  #
 
   #重新讀取資料
   SELECT * INTO l_tc_evaa.* FROM tc_evaa_file
    WHERE tc_evaa01=g_tc_evaa.tc_evaa01
   
   IF cl_null(l_tc_evaa.tc_evaa01) THEN RETURN END IF
   IF l_tc_evaa.tc_evaa06 != 'Y' THEN CALL cl_err('',9029,1) RETURN END IF   

    
      LET p_row = 5 LET p_col = 11
 
      OPEN WINDOW t370sub_exp AT p_row,p_col WITH FORM "axm/42f/axmt400e"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      CALL cl_set_comp_visible("a",FALSE)   
      CALL cl_set_comp_visible("oeb01,oeb03",FALSE) 
      CALL cl_ui_locale("axmt400e")
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t370sub_exp
         RETURN
      END IF
     
    
      INPUT BY NAME tm.slip 
                 
         BEFORE INPUT
            SELECT smyslip INTO tm.slip FROM smy_file
             WHERE smysys = 'apm' AND smykind = '1'
               AND smy72= 'CAP'
             LET l_slip = tm.slip
              
         AFTER FIELD slip
            IF NOT cl_null(tm.slip) THEN   
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM smy_file
                WHERE smyslip = tm.slip AND smysys = 'apm' AND smykind = '1' 
               IF SQLCA.sqlcode OR cl_null(tm.slip) THEN  
                  LET l_cnt = 0
               END IF
               IF l_cnt = 0 THEN
                  CALL cl_err(tm.slip,'aap-010',0)       
                  NEXT FIELD slip
               END IF
            END IF
            LET l_slip = tm.slip
   
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW t370sub_exp
            RETURN
         END IF
   
         ON ACTION controlp
            CASE
               WHEN INFIELD(slip)
                    CALL q_smy(FALSE,TRUE,tm.slip,'apm','1') RETURNING tm.slip
                     DISPLAY BY NAME tm.slip        
                    NEXT FIELD slip
               OTHERWISE EXIT CASE
            END CASE
   
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
   
         ON ACTION about         
            CALL cl_about()      
   
         ON ACTION help         
            CALL cl_show_help() 
   
         ON ACTION controlg      
            CALL cl_cmdask()    
   
   
      END INPUT
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t370sub_exp
         RETURN
      END IF
 
   LET g_success = 'Y'  

  
   BEGIN WORK           
  
   SELECT smydmy4 INTO l_smydmy4 FROM smy_file
    WHERE smyslip = tm.slip
   
   # -------------------------未存在請購單號 才可拋轉
   LET l_tc_evab05 = 0
 
   LET l_sql = "SELECT tc_evab02,tc_evab05,tc_evab03 ",  
               "  FROM tc_evab_file ",
               " WHERE tc_evab01 = '",g_tc_evaa.tc_evaa01,"' ",
               "   AND NOT EXISTS (SELECT * from pml_file,pmk_file  ",
               "                    WHERE pmk01=pml01 AND pmk18 != 'X' AND pml24=tc_evab01 AND pml25= tc_evab02) ",
               "   AND EXISTS (SELECT * FROM ima_file WHERE ima01=tc_evab03  ) ",
               " ORDER BY tc_evab02 "
               
  
   PREPARE t370sub_exp_pre FROM l_sql
   IF SQLCA.sqlcode THEN CALL cl_err('t370sub_exp_pre',STATUS,1) END IF
   DECLARE t370sub_exp_c CURSOR FOR t370sub_exp_pre
   IF SQLCA.sqlcode THEN CALL cl_err('t370sub_exp_c',STATUS,1) END IF
   LET l_cnt = 1
   
   CALL s_auto_assign_no("apm",tm.slip,g_today,"","pmk_file","pmk01","","","")
        RETURNING li_result,l_pmk01
   IF (NOT li_result) THEN
      LET g_success ='N'
      ROLLBACK WORK
      CLOSE WINDOW t370sub_exp
      RETURN
   END IF
    
   DROP TABLE pml_file_temp
   SELECT * FROM pml_file WHERE pml01 = l_pmk01
     INTO TEMP pml_file_temp 

 
   CALL s_showmsg_init()                
   LET l_tc_evab02 = 0    
   FOREACH t370sub_exp_c INTO l_tc_evab02,l_tc_evab05,l_tc_evab03  #項次/數量/產品編號   
   IF g_success = "N" THEN                                                                                                        
      LET g_totsuccess = "N"                                                                                                      
      LET g_success = "Y"                                                                                                         
   END IF                                                                                                                         
     
     SELECT ima25,ima44 INTO l_ima25,l_ima44
       FROM ima_file WHERE ima01=l_tc_evab03

     IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
     IF cl_null(l_fac) THEN LET l_fac=1 END IF   
    
         IF l_cnt = 1 THEN            
             CALL t001sub_ins_pmk(l_pmk01)                 
             CALL t001sub_ins_pml_exp(l_pmk01,g_tc_evaa.tc_evaa01,l_tc_evab02)
         ELSE                     
             CALL t001sub_ins_pml_exp(l_pmk01,g_tc_evaa.tc_evaa01,l_tc_evab02)
         END IF
         LET l_cnt = l_cnt + 1
   
   END FOREACH
   IF cl_null(l_pmk01) THEN LET g_success="N" END IF    
   
   IF g_totsuccess="N" THEN                                                                                                       
      LET g_success="N"                                                                                                           
   END IF                                                                                                                         
    CALL s_showmsg()        
   IF li_success = 'N' OR g_success = 'N' OR l_cnt <= 1 THEN                              
       ROLLBACK WORK                                                        
       CALL cl_err('','axm-558',1)                                           
       CLOSE WINDOW t370sub_exp                                              
 
   ELSE                                                                                                                                            
  
   IF g_success = 'Y' THEN
   
       COMMIT WORK
       LET l_prog_t = g_prog
       LET g_prog = 'apmt420'
       CALL cl_flow_notify(l_pmk01,'I')
       LET g_prog = l_prog_t
       #MESSAGE "已轉請購單號:",l_pmk01        

       IF NOT cl_null(l_pmk01) THEN
          IF cl_confirm('TSD0012') THEN
             LET l_cmd = "apmt420 ","'",l_pmk01,"'"   #20181212 add by momo  直接開啟請購單
             CALL cl_cmdrun(l_cmd)                   
          END IF
       END IF

   ELSE
       ROLLBACK WORK
       
   END IF
   CLOSE WINDOW t370sub_exp
  END IF                                                                                            
END FUNCTION

FUNCTION t001sub_ins_pmk(p_pmk01)                            
 DEFINE l_pmk    RECORD LIKE pmk_file.*
 DEFINE l_slip   LIKE type_file.chr5                               
 DEFINE p_pmk01 LIKE pmk_file.pmk01  
 
   INITIALIZE l_pmk.* TO NULL
 
   LET l_pmk.pmk01 = p_pmk01      
   CALL s_get_doc_no(p_pmk01) RETURNING l_slip 
   LET l_pmk.pmk02 = 'CAP'       #單號性質
   LET l_pmk.pmk03 = '0'
   LET l_pmk.pmk04 = g_today     #請購日期
   LET l_pmk.pmk12 = g_user
   LET l_pmk.pmk13 = g_grup
   LET l_pmk.pmk18 = 'N'
   LET l_pmk.pmk25 = '0'         #開立
   LET l_pmk.pmk27 = g_today
   LET l_pmk.pmk40 = 0           #總金額
   LET l_pmk.pmk401= 0           #總金額
   LET l_pmk.pmk42 = 1           #匯率
   LET l_pmk.pmk43 = 0           #稅率
   IF g_smy.smyud02='N' THEN 
      LET l_pmk.pmk45='N' 
   ELSE
      LET l_pmk.pmk45 = 'Y'         #可用
   END IF
   
   LET l_pmk.pmk50 = g_plant     #生产门店
   SELECT smyapr,smysign INTO l_pmk.pmkmksg,l_pmk.pmksign   
     FROM smy_file
    WHERE smyslip = l_slip
   IF SQLCA.sqlcode OR cl_null(l_pmk.pmkmksg) THEN
      LET l_pmk.pmkmksg = 'N'
      LET l_pmk.pmksign= NULL
   END IF
   LET l_pmk.pmkdays = 0         #簽核天數
   LET l_pmk.pmksseq = 0         #應簽順序
   LET l_pmk.pmkprno = 0         #列印次數 
   LET l_pmk.pmkacti ='Y'        #有效的資料
   LET l_pmk.pmkuser = g_user    #使用者
   LET l_pmk.pmkgrup = g_grup    #使用者所屬群
   LET l_pmk.pmkdate = g_today   
   LET l_pmk.pmk46='6'           #固資轉入     
   LET l_pmk.pmk47=''
   LET l_pmk.pmkcond= ''             #審核日期
   LET l_pmk.pmkconu= ''             #審核時間
   LET l_pmk.pmkcrat= g_today        #資料創建日
   LET l_pmk.pmkplant = g_plant        #機構別
   LET l_pmk.pmklegal = g_legal        
   LET l_pmk.pmkoriu = g_user     
   LET l_pmk.pmkorig = g_grup   
   LET l_pmk.pmkud03 = 'N'
   LET l_pmk.pmksmax = 0
   LET l_pmk.pmksseq = 0
   
   INSERT INTO pmk_file VALUES(l_pmk.*)     #DISK WRITE
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg("pmk01",l_pmk.pmk01,"ins pmk",SQLCA.sqlcode,1)      
      LET g_success = 'N'
   END IF           
  
END FUNCTION        

FUNCTION t001sub_ins_pml_exp(l_pmk01,p_tc_evaa01,p_tc_evab02)
 DEFINE l_pmk01      LIKE pmk_file.pmk01   
 DEFINE l_tc_evab02  LIKE tc_evab_file.tc_evab02  
 DEFINE l_qty        LIKE tc_evab_file.tc_evab05
 DEFINE l_tc_evab01  LIKE tc_evab_file.tc_evab01  
 DEFINE l_tc_evab    RECORD LIKE tc_evab_file.*
 DEFINE p_tc_evaa01  LIKE tc_evaa_file.tc_evaa01
 DEFINE p_tc_evab02  LIKE tc_evab_file.tc_evab02 
 
      DECLARE t370sub_inb_curs1 CURSOR FOR
       SELECT * FROM tc_evab_file
        WHERE tc_evab01 = p_tc_evaa01
          AND tc_evab02 = p_tc_evab02     
          
      FOREACH t370sub_inb_curs1 INTO l_tc_evab.*
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','',"foreach:",SQLCA.sqlcode,1)  
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET l_tc_evab02 = l_tc_evab02+1   
          CALL t001sub_ins_pml(l_pmk01,l_tc_evab.tc_evab01,l_tc_evab.tc_evab02) 
      END FOREACH
 
END FUNCTION

FUNCTION t001sub_ins_pml(p_pmk01,p_tc_evab01,p_tc_evab02)           
  DEFINE p_pmk01     LIKE pmk_file.pmk01,
         p_tc_evab01 LIKE tc_evab_file.tc_evab01,    
         p_tc_evab02 LIKE tc_evab_file.tc_evab02,
         l_ima01     LIKE ima_file.ima01,
         l_ima02     LIKE ima_file.ima02,
         l_ima05     LIKE ima_file.ima05,
         l_ima25     LIKE ima_file.ima25,
         l_ima27     LIKE ima_file.ima27,
         l_ima44     LIKE ima_file.ima44,
         l_ima44_fac LIKE ima_file.ima44_fac,
         l_ima45     LIKE ima_file.ima45,
         l_ima46     LIKE ima_file.ima46,
         l_ima49     LIKE ima_file.ima49,
         l_ima491    LIKE ima_file.ima491,
         l_ima913    LIKE ima_file.ima913,   
         l_ima914    LIKE ima_file.ima914,   
         l_pan       LIKE type_file.num10,   
         l_flag      LIKE type_file.chr1,    
         l_double    LIKE type_file.num10    
   DEFINE l_pml      RECORD LIKE pml_file.*  
   DEFINE l_tc_evab  RECORD LIKE tc_evab_file.*  
   DEFINE l_factor   LIKE img_file.img21     #
   DEFINE l_cnt      LIKE type_file.num5     
   DEFINE l_ima39    LIKE ima_file.ima39    
   DEFINE l_ima391   LIKE ima_file.ima391   
   DEFINE l_pmj01    LIKE pmj_file.pmj01     
   DEFINE l_azk052   LIKE azk_file.azk052    #匯率
   DEFINE l_gec04    LIKE gec_file.gec04     #稅率
   DEFINE l_gec07    LIKE gec_file.gec07     #含稅否

   CALL t001sub_pml_ini(p_pmk01) RETURNING l_pml.* 
   
   SELECT * INTO l_tc_evab.* FROM tc_evab_file WHERE tc_evab01=p_tc_evab01 AND tc_evab02=p_tc_evab02
 
   LET l_ima913 = 'N'  
 
       SELECT ima01,ima02,ima05,ima25,ima27,ima44,ima44_fac, 
              ima45,ima46,ima49,ima491,
              ima913,ima914,       
              ima39,ima391         
         INTO l_ima01,l_ima02,l_ima05,l_ima25,l_ima27,
              l_ima44,l_ima44_fac,l_ima45,l_ima46,l_ima49,l_ima491,
              l_ima913,l_ima914,      
              l_ima39,l_ima391       
         FROM ima_file
        WHERE ima01 = l_tc_evab.tc_evab03
      
       IF SQLCA.sqlcode THEN
           CALL s_errmsg("ima01",l_tc_evab.tc_evab03,"sel ima:",SQLCA.sqlcode,1)     
           LET g_success = 'N'
           RETURN
       END IF
       LET l_pml.pml40  = l_ima39     
       LET l_pml.pml401 = l_ima391    
       LET l_pml.pml02 = p_tc_evab02 
       LET l_pml.pml04 = l_ima01
       LET l_pml.pml041= l_tc_evab.tc_evab04
       LET l_pml.pml05 = NULL      
       LET l_pml.pml07 = l_ima44      
       LET l_pml.pml08 = l_ima25

       CALL s_umfchk(l_pml.pml04,l_pml.pml07,                                                                                     
            l_pml.pml08) RETURNING l_flag,l_pml.pml09                                                                             
       IF cl_null(l_pml.pml09) THEN LET l_pml.pml09=1 END IF
          
       LET l_pml.pml42 = '0'
       LET l_pml.pml20 = l_tc_evab.tc_evab05      
       LET l_pml.pml87 = l_tc_evab.tc_evab05      
       LET l_pml.pml35 = g_today +7                #到庫日期
       LET l_pml.pml34 = l_pml.pml35
       LET l_pml.pml33 = l_pml.pml35       
       LET l_pml.pml86 = l_ima44
       LET l_pml.pml190 = l_ima913    #統購否
       LET l_pml.pml191 = l_ima914    #採購成本中心
       LET l_pml.pml192 = 'N'         #拋轉否 
       LET l_pml.pml24 = p_tc_evab01
       LET l_pml.pml25 = p_tc_evab02
       LET l_pml.pml47=''
       LET l_pml.pml48=''
       LET l_pml.pml49='1'
       LET l_pml.pml50='1'
       LET l_pml.pml51=''
       LET l_pml.pml52=''
       LET l_pml.pml53=''
       LET l_pml.pml54=' '
       LET l_pml.ta_pml03 = g_tc_evaa.tc_evaa09   #供應商
       LET l_pml.ta_pml05 = g_tc_evaa.tc_evaa10   #幣別
       LET l_pml.pml31 = l_tc_evab.tc_evab06      #未稅單價
       LET l_pml.pml49 = ' '
       LET l_pml.pml50 = '1'
    
       SELECT pmc47,gec04,gec07 INTO l_pml.ta_pml04 ,l_gec04,l_gec07
         FROM pmc_file ,gec_file
        WHERE pmc01 = g_tc_evaa.tc_evaa09 
          AND pmc47 = gec01

       LET l_pml.pml31t =l_pml.pml31 * ( 1 + l_gec04/100) #含稅 
       LET l_pml.pml31t = cl_digcut(l_pml.pml31t,t_azi03)      

      #帶入採購員   
       SELECT ima43 INTO l_pml.ta_pml06
         FROM ima_file
        WHERE ima01= l_pml.pml04                                                                     


##----  帶入單價等資訊

   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
       WHERE azi01 = l_pml.ta_pml05  AND aziacti= 'Y'       #原幣

   LET l_pml.pml88 =cl_digcut(l_pml.pml87*l_pml.pml31,t_azi04)
   LET l_pml.pml88t=cl_digcut(l_pml.pml87*l_pml.pml31t,t_azi04)
   
   SELECT azk052 INTO l_azk052 FROM azk_file
    WHERE azk01=l_pml.ta_pml05 AND azk02=g_today
   IF cl_null(l_azk052) THEN LET l_azk052=1 END IF
   LET l_pml.pmlud07 =cl_digcut(l_pml.pml88*l_azk052,t_azi04)
   IF cl_null(l_pml.pmlud07) THEN LET l_pml.pmlud07=0 END IF
##----  (E)
                                                                         
   LET l_pml.pml56 = '1'  #bnl
   LET l_pml.pml91 = 'N'  #FUN-980010 add 給初始值  #Mod TQC-B30096
   LET l_pml.pml92 = 'N' #FUN-9B0023
   LET l_pml.pml91 = 'N'
  
   INSERT INTO pml_file VALUES(l_pml.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg("pml01",l_pml.pml01,"INS pml_file",SQLCA.sqlcode,1)          
      LET g_success = 'N'
   ELSE                                                                      
   END IF
    
END FUNCTION

FUNCTION t001sub_pml_ini(p_pmk01)
  DEFINE p_pmk01 LIKE pmk_file.pmk01,
         l_pmk02 LIKE pmk_file.pmk02,
         l_pmk25 LIKE pmk_file.pmk25,
         l_pmk13 LIKE pmk_file.pmk13
  DEFINE l_pml   RECORD LIKE pml_file.*
 
   INITIALIZE l_pml.* TO NULL     
   SELECT pmk02,pmk25,pmk13 INTO l_pmk02,l_pmk25,l_pmk13
     FROM pmk_file WHERE pmk01 = p_pmk01
   LET l_pml.pml01 = p_pmk01               LET l_pml.pml011 = l_pmk02
   LET l_pml.pml16 = l_pmk25
   LET l_pml.pml14 = g_sma.sma886[1,1]     LET l_pml.pml15  =g_sma.sma886[2,2]
   LET l_pml.pml23 = 'Y'  
   IF g_smy.smyud02='N' THEN LET l_pml.pml38='N' ELSE                 
      LET l_pml.pml38  ='Y'
   END IF
   LET l_pml.pml43 = 0                     LET l_pml.pml431 = 0
   LET l_pml.pml11 = 'N'                   LET l_pml.pml13  = 0
   LET l_pml.pml21  = 0
   LET l_pml.pml30 = 0                     LET l_pml.pml32 = 0
   LET l_pml.pml930=s_costcenter(l_pmk13) 
   LET l_pml.pmlplant=g_plant  
   LET l_pml.pmllegal=g_legal  
   RETURN l_pml.*
END FUNCTION
