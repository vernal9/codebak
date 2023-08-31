# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cimt501.4gl
# Descriptions...: 
# Date & Author..: NO.23080001  20230814 By momo 化學品管製維護作業

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE g_tc_sds         RECORD LIKE tc_sds_file.*,      
       g_tc_sds_t       RECORD LIKE tc_sds_file.*,       
       g_tc_sds_o       RECORD LIKE tc_sds_file.*,       
       g_tc_sds02_t     LIKE tc_sds_file.tc_sds02,          
       g_t1             LIKE smy_file.smyslip,              
       g_ydate          LIKE type_file.dat,          
       g_tc_sit         DYNAMIC ARRAY OF RECORD       
           tc_sit03     LIKE tc_sit_file.tc_sit03,      
           gem02        LIKE gem_file.gem02,             
           tc_sit04     LIKE tc_sit_file.tc_sit04,
           gen02        LIKE gen_file.gen02,
           tc_sit05     LIKE tc_sit_file.tc_sit05,                                                                        
           tc_sit06     LIKE tc_sit_file.tc_sit06,  
           tc_faf02     LIKE tc_faf_file.tc_faf02,                  
           tc_sit07     LIKE tc_sit_file.tc_sit07,                   
           tc_sit08     LIKE tc_sit_file.tc_sit08,                    
           tc_sit09     LIKE tc_sit_file.tc_sit09,                    
           tc_faf02_2   LIKE tc_faf_file.tc_faf02,                  
           tc_sit10     LIKE tc_sit_file.tc_sit10,                   
           tc_sit11     LIKE tc_sit_file.tc_sit11,                    
           tc_sit12     LIKE tc_sit_file.tc_sit12,                   
           tc_faf02_3   LIKE tc_faf_file.tc_faf02,                  
           tc_sit13     LIKE tc_sit_file.tc_sit13,                   
           tc_sit14     LIKE tc_sit_file.tc_sit14,                   
           tc_sitacti   LIKE tc_sit_file.tc_sitacti,
           tc_sitdate   LIKE tc_sit_file.tc_sitdate,
           tc_sitmodu   LIKE tc_sit_file.tc_sitmodu               
                     END RECORD,
       g_tc_sit_t       RECORD                    
           tc_sit03     LIKE tc_sit_file.tc_sit03,
           gem02        LIKE gem_file.gem02,             
           tc_sit04     LIKE tc_sit_file.tc_sit04,
           gen02        LIKE gen_file.gen02,
           tc_sit05     LIKE tc_sit_file.tc_sit05,                                                                         
           tc_sit06     LIKE tc_sit_file.tc_sit06,          
           tc_faf02     LIKE tc_faf_file.tc_faf02,                  
           tc_sit07     LIKE tc_sit_file.tc_sit07,                   
           tc_sit08     LIKE tc_sit_file.tc_sit08,                    
           tc_sit09     LIKE tc_sit_file.tc_sit09,                    
           tc_faf02_2   LIKE tc_faf_file.tc_faf02,                  
           tc_sit10     LIKE tc_sit_file.tc_sit10,                   
           tc_sit11     LIKE tc_sit_file.tc_sit11,                    
           tc_sit12     LIKE tc_sit_file.tc_sit12,                   
           tc_faf02_3   LIKE tc_faf_file.tc_faf02,                  
           tc_sit13     LIKE tc_sit_file.tc_sit13,                   
           tc_sit14     LIKE tc_sit_file.tc_sit14,                   
           tc_sitacti   LIKE tc_sit_file.tc_sitacti,                   
           tc_sitdate   LIKE tc_sit_file.tc_sitdate,
           tc_sitmodu   LIKE tc_sit_file.tc_sitmodu               
                     END RECORD,
       g_tc_sit_o       RECORD                      
           tc_sit03     LIKE tc_sit_file.tc_sit03,
           gem02        LIKE gem_file.gem02,             
           tc_sit04     LIKE tc_sit_file.tc_sit04,
           gen02        LIKE gen_file.gen02,
           tc_sit05     LIKE tc_sit_file.tc_sit05,                                                                        
           tc_sit06     LIKE tc_sit_file.tc_sit06,          
           tc_faf02     LIKE tc_faf_file.tc_faf02,                  
           tc_sit07     LIKE tc_sit_file.tc_sit07,                   
           tc_sit08     LIKE tc_sit_file.tc_sit08,                    
           tc_sit09     LIKE tc_sit_file.tc_sit09,                    
           tc_faf02_2   LIKE tc_faf_file.tc_faf02,                  
           tc_sit10     LIKE tc_sit_file.tc_sit10,                   
           tc_sit11     LIKE tc_sit_file.tc_sit11,                    
           tc_sit12     LIKE tc_sit_file.tc_sit12,                   
           tc_faf02_3   LIKE tc_faf_file.tc_faf02,                  
           tc_sit13     LIKE tc_sit_file.tc_sit13,                   
           tc_sit14     LIKE tc_sit_file.tc_sit14,                   
           tc_sitacti   LIKE tc_sit_file.tc_sitacti,                   
           tc_sitdate   LIKE tc_sit_file.tc_sitdate,
           tc_sitmodu   LIKE tc_sit_file.tc_sitmodu               
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
DEFINE g_flag              LIKE type_file.chr1
DEFINE g_argv1             LIKE tc_sds_file.tc_sds02  #單號                    
DEFINE g_argv2             STRING                     #執行功能                
DEFINE g_laststage         LIKE type_file.chr1  #是否為簽核最後一站flag  
DEFINE g_chr1,g_chr2       LIKE type_file.chr1  
#資料清單
DEFINE w              ui.Window
DEFINE f              ui.Form
DEFINE page           om.DomNode
DEFINE g_action_flag  STRING
DEFINE g_rec_b1       LIKE type_file.num10
DEFINE l_ac1          LIKE type_file.num10
DEFINE g_tc_sds_l    DYNAMIC ARRAY OF RECORD
       tc_sds01_l    LIKE tc_sds_file.tc_sds01,
       tc_sds02_l    LIKE tc_sds_file.tc_sds02,
       tc_sds03_l    LIKE tc_sds_file.tc_sds03,
       tc_sds04_l    LIKE tc_sds_file.tc_sds04,
       tc_sds05_l    LIKE tc_sds_file.tc_sds05,
       tc_sds06_l    LIKE tc_sds_file.tc_sds06,
       tc_sds07_l    LIKE tc_sds_file.tc_sds07,
       tc_sds09_l    LIKE tc_sds_file.tc_sds09,
       expiry        LIKE type_file.num10       #到期天數
       END RECORD

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
 
   IF (NOT cl_setup("CIM")) THEN
      EXIT PROGRAM
   END IF
  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
 
   LET g_argv1 = ARG_VAL(1)              #單號
   LET g_argv2 = ARG_VAL(2)              #執行功能 
   IF fgl_getenv('EASYFLOW') = "1" THEN  #判斷是否為簽核模式
      LET g_argv1 = aws_efapp_wsk(1)     #取得單號,參數:key-1
   END IF
 
 
   LET g_forupd_sql = "SELECT * FROM tc_sds_file WHERE tc_sds02=? FOR UPDATE"   
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t501_cl CURSOR FROM g_forupd_sql
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN   
      OPEN WINDOW t501_w WITH FORM "cim/42f/cimt501"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
      CALL cl_set_locale_frm_name("cimt501")    
      CALL cl_ui_init()
      
   END IF   
   
 
   CALL aws_efapp_toolbar()    #建立簽核模式時的toolbar icon
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, invalid, detail, query, locale, void, undo_void,confirm, modify_head, easyflow_approval")  #CHI-D20010 add undo_void
        RETURNING g_laststage  #傳入簽核模式時不應執行的action清單
  
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "efconfirm"
            CALL t501_q()
            CALL t501_y_chk()
            IF g_success = "Y" THEN
               CALL t501_y_upd()
            END IF
            EXIT PROGRAM
         OTHERWISE
            CALL t501_q()
      END CASE
   END IF
   
   CALL t501_menu()
   CLOSE WINDOW t501_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t501_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_tc_sit.clear()
    

   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " tc_sds02 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
   ELSE
 
      CONSTRUCT BY NAME g_wc ON tc_sds01,tc_sds02,tc_sds03,tc_sds04,tc_sds05,tc_sds06,
                                tc_sds07,tc_sds08,tc_sds09,tc_sds10,tc_sdsconf,                                
                                tc_sdsuser,tc_sdsgrop,tc_sdsmodu,tc_sdsdate,tc_sdsacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(tc_sds01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="cq_tc_ghs01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_sds01                
                  NEXT FIELD tc_sds01
                  
               WHEN INFIELD(tc_sds03) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="cq_ima002"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_sds03
                  NEXT FIELD tc_sds03   

               WHEN INFIELD(tc_sds07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="cq_tc_sds01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_sds07
                  NEXT FIELD tc_sds07

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
   
  
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_sdsuser', 'tc_sdsgrop')
 
   CONSTRUCT g_wc2 ON tc_sit03,tc_sit04,tc_sit05,tc_sit06,tc_sit09,tc_sit10,
                      tc_sit12,tc_sitacti,
                      tc_sitdate,tc_sitmodu
             FROM s_tc_sit[1].tc_sit03,s_tc_sit[1].tc_sit04,
                  s_tc_sit[1].tc_sit05,s_tc_sit[1].tc_sit06,
                  s_tc_sit[1].tc_sit09,s_tc_sit[1].tc_sit10,
                  s_tc_sit[1].tc_sit12,s_tc_sit[1].tc_sitacti,
                  s_tc_sit[1].tc_sitdate,s_tc_sit[1].tc_sitmodu
 
      BEFORE CONSTRUCT
        CALL cl_qbe_display_condition(lc_qbe_sn)
   
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_sit03) 
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_sit03
              NEXT FIELD tc_sit03     
            WHEN INFIELD(tc_sit04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_sit04
              NEXT FIELD tc_sit04
            WHEN INFIELD(tc_sit06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_tc_faf"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_sit06
              NEXT FIELD tc_sit06
            WHEN INFIELD(tc_sit09)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_tc_faf"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_sit09
              NEXT FIELD tc_sit09
            WHEN INFIELD(tc_sit12)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_tc_faf"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_sit12
              NEXT FIELD tc_sit12
                            
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
      LET g_sql = "SELECT tc_sds02 FROM tc_sds_file ",        
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tc_sds01"
   ELSE                             
      LET g_sql = "SELECT tc_sds02 ",                        
                  "  FROM tc_sds_file, tc_sit_file ",
                  " WHERE tc_sds02 = tc_sit02 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY tc_sds01"
   END IF
 
   PREPARE t501_prepare FROM g_sql
   DECLARE t501_cs                         
       SCROLL CURSOR WITH HOLD FOR t501_prepare
 
   IF g_wc2 = " 1=1" THEN                  
      LET g_sql="SELECT COUNT(*) FROM tc_sds_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(tc_sds02) FROM tc_sds_file,tc_sit_file WHERE ",
                " tc_sit02 = tc_sds02 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t501_precount FROM g_sql
   DECLARE t501_count CURSOR FOR t501_precount
 
END FUNCTION
 
FUNCTION t501_menu() 
DEFINE l_creator  LIKE type_file.chr1  #是否退回填表人      
DEFINE l_flowuser LIKE type_file.chr1  #是否有指定加簽人員 
DEFINE  l_node         om.DomNode,
        win            ui.Window,
        f              ui.Form 

   LET l_flowuser = "N"  
 
   WHILE TRUE
      ## 資料清單(S)
       CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "page_main")
            CALL t501_bp("G")
         WHEN (g_action_flag = "page_info")
            CALL t501_list_fill()
            CALL t501_bp1("G")
            IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
               SELECT tc_sds_file.* INTO g_tc_sds.* FROM tc_sds_file
                WHERE tc_sds02=g_tc_sds_l[l_ac1].tc_sds02_l
            END IF
            IF g_action_choice!= "" THEN
               LET g_action_flag = 'page_main'
               LET l_ac1 = ARR_CURR()
               LET g_jump = l_ac1
               LET g_no_ask = TRUE  
               IF g_rec_b1 >0 THEN
                   CALL t501_fetch('/')
               END IF
               CALL cl_set_comp_visible("page_info", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page_info", TRUE)
             END IF
      END CASE
      ## 資料清單(E)
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t501_a()
               LET g_data_keyvalue = g_tc_sds.tc_sds02  
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t501_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t501_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t501_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t501_x()
            END IF
 
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t501_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "output"
            IF cl_chk_act_auth() THEN
               LET l_wc='tc_sds02="',g_tc_sds.tc_sds02,'"'
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
               CALL t501_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t501_y_upd()       #CALL 原確認的 update 段
               END IF
             
               CALL t501_show() #圖示  
            END IF
 
        #調整SDS資訊
        WHEN "modify_head"
            IF cl_chk_act_auth() THEN
               CALL t501_changehead()
               CALL t501_show() 
            END IF

        #補料號
        WHEN "changeitem"  
            IF cl_chk_act_auth() THEN
               CALL t501_changeitem()
               CALL t501_show()
            END IF
            
        WHEN "agree"                                       #執行EF簽核,"准"功能
           IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
              CALL t501_y_upd()                            #CALL 原確認的 update 段
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
                       CALL t501_q()
                       #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                       CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, modify_head, easyflow_approval")  #CHI-D20010 add undo_void
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
                    LET g_tc_sds.tc_sds10 = 'R'                     #顯示狀態碼為'R' 送簽退回
                    DISPLAY BY NAME g_tc_sds.tc_sds10
                 END IF
                 IF cl_confirm('aws-081') THEN                      #詢問是否繼續下一筆資料的簽核
                    IF aws_efapp_getnextforminfo() THEN             #取得下一筆簽核單號
                       LET l_flowuser = 'N'
                       LET g_argv1 = aws_efapp_wsk(1)               #取得單號
                       IF NOT cl_null(g_argv1) THEN                 #自動query帶出資料
                          CALL t501_q()
                          #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, modify_head, easyflow_approval")  #CHI-D20010 add undo_void
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
                CALL t501_ef()
           END IF 
 
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              LET w = ui.Window.getCurrent()
              LET f = w.getForm()
              LET l_node = f.findNode("Table","s_tc_sit")
               CASE 
                 WHEN (g_action_flag IS NULL) OR (g_action_flag = 'page_main')
                   CALL  cl_export_to_excel(l_node,base.TypeInfo.create(g_tc_sit),'','')
                 WHEN (g_action_flag = 'page_info')
                     LET page = f.FindNode("Page","page_info")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_sds_l),'','')
                 END CASE
                 LET g_action_choice = NULL
            END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_sds.tc_sds01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_sds02"
                 LET g_doc.value1 = g_tc_sds.tc_sds02
                 CALL cl_doc()
               END IF
         END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t501_v(1)  
               CALL t501_show_pic() 
            END IF
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t501_v(2)   
               CALL t501_show_pic()
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_sit TO s_tc_sit.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     

      ON ACTION page_info
         LET g_action_flag="page_info"
         EXIT DISPLAY          
 
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
         CALL t501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION jump
         CALL t501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION next
         CALL t501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL t501_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
         
      ON ACTION invalid
         LET g_action_choice="invalid"
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
         
      ON ACTION easyflow_approval           
        LET g_action_choice = "easyflow_approval"
        EXIT DISPLAY
 
      ON ACTION confirm     
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION modify_head   
         LET g_action_choice="modify_head"
         EXIT DISPLAY 

      ON ACTION changeitem
         LET g_action_choice="changeitem"
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
 
FUNCTION t501_bp_refresh()
  DISPLAY ARRAY g_tc_sit TO s_tc_sit.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t501_a()
   DEFINE li_result   LIKE type_file.num5   
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10  
 
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_sit.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_tc_sds.* LIKE tc_sds_file.*             #DEFAULT 設定
   LET g_tc_sds02_t = NULL
   LET g_tc_sds.tc_sds10 = '0'
   LET g_tc_sds.tc_sdsconf = 'N'
   
 
   #預設值及將數值類變數清成零
   LET g_tc_sds_t.* = g_tc_sds.*
   LET g_tc_sds_o.* = g_tc_sds.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_tc_sds.tc_sdsuser=g_user
      LET g_data_plant = g_plant
      LET g_tc_sds.tc_sdsgrop=g_grup
      LET g_tc_sds.tc_sdsdate=g_today
      LET g_tc_sds.tc_sdsacti='Y'              #資料有效
      LET g_tc_sds.tc_sdsplant = g_plant
      LET g_tc_sds.tc_sdsmodu = g_user

      CALL t501_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_tc_sds.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_tc_sds.tc_sds01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
 
      INSERT INTO tc_sds_file VALUES (g_tc_sds.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","tc_sds_file",g_tc_sds.tc_sds01,"",SQLCA.sqlcode,"","",1)  #上移一行調整至回滾事務前--- 
         ROLLBACK WORK     
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_tc_sds.tc_sds01,'I')
      END IF
 
      LET g_tc_sds02_t = g_tc_sds.tc_sds02
      LET g_tc_sds_t.* = g_tc_sds.*
      LET g_tc_sds_o.* = g_tc_sds.*
      CALL g_tc_sit.clear()
 
      LET g_rec_b = 0
      CALL t501_b()                   #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t501_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_sds.tc_sds01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_tc_sds.tc_sds10 = '9' OR g_tc_sds.tc_sdsconf='Y' THEN 
      RETURN 
   END IF  
   IF g_tc_sds.tc_sds10 matches '[Ss1]' THEN     
      CALL cl_err("","mfg3557",1)
      LET g_success='N'
      RETURN                                                                                                                        
   END IF

   SELECT * INTO g_tc_sds.* FROM tc_sds_file
    WHERE tc_sds01=g_tc_sds.tc_sds01
       AND tc_sds02=g_tc_sds.tc_sds02
 
   IF g_tc_sds.tc_sdsacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tc_sds.tc_sds02,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tc_sds02_t = g_tc_sds.tc_sds02
   BEGIN WORK
 
   OPEN t501_cl USING g_tc_sds.tc_sds02
   IF STATUS THEN
      CALL cl_err("OPEN t501_cl:", STATUS, 1)
      CLOSE t501_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t501_cl INTO g_tc_sds.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_sds.tc_sds01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t501_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t501_show()
 
   WHILE TRUE
      LET g_tc_sds02_t = g_tc_sds.tc_sds02
      LET g_tc_sds_o.* = g_tc_sds.*
      LET g_tc_sds.tc_sdsmodu=g_user
      LET g_tc_sds.tc_sdsdate=g_today
 
      CALL t501_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tc_sds.*=g_tc_sds_t.*
         CALL t501_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      UPDATE tc_sds_file SET tc_sds_file.* = g_tc_sds.*
       WHERE tc_sds02 = g_tc_sds02_t     
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","tc_sds_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      ELSE
         IF g_tc_sds_o.tc_sds01 <> g_tc_sds.tc_sds01 THEN
            UPDATE tc_sit_file SET tc_sit01 = g_tc_sds.tc_sds01
             WHERE tc_sit02 = g_tc_sds.tc_sds02
         END IF
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t501_cl
   COMMIT WORK
 
   CALL t501_b_fill("1=1")
   CALL t501_bp_refresh()
 
END FUNCTION
 
FUNCTION t501_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,    
   p_cmd     LIKE type_file.chr1    
   DEFINE    li_result   LIKE type_file.num5
   DEFINE    l_sql       STRING
   DEFINE    l_tc_sds06     LIKE tc_sds_file.tc_sds06
   DEFINE    l_cnt       LIKE type_file.num5      
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_tc_sds.tc_sdsuser,g_tc_sds.tc_sdsmodu,
       g_tc_sds.tc_sdsgrop,g_tc_sds.tc_sdsdate,g_tc_sds.tc_sdsacti
   
   CALL cl_set_head_visible("","YES")         
   INPUT BY NAME g_tc_sds.tc_sds01,g_tc_sds.tc_sds02,g_tc_sds.tc_sds03,g_tc_sds.tc_sds04,
                 g_tc_sds.tc_sds05,g_tc_sds.tc_sds06,g_tc_sds.tc_sds07,g_tc_sds.tc_sds08,
                 g_tc_sds.tc_sds09,g_tc_sds.tc_sdsacti
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t501_set_entry(p_cmd)
         CALL t501_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("tc_sds02")


      AFTER FIELD tc_sds01
         IF cl_null(g_tc_sds.tc_sds01) THEN
            NEXT FIELD tc_sds01
         ELSE
            IF cl_null(g_tc_sds.tc_sds02) THEN
               SELECT to_number(to_char(sysdate, 'YY')||LPAD(NVL(max(SUBSTR(tc_sds02,3,5))+1,1),'3','0'))
                INTO g_tc_sds.tc_sds02
                FROM tc_sds_file
               DISPLAY BY NAME g_tc_sds.tc_sds02
             END IF
         END IF
 
      AFTER FIELD tc_sds03                
         IF NOT cl_null(g_tc_sds.tc_sds03) THEN
            LET l_cnt = 0
            SELECT 1 INTO l_cnt 
              FROM tc_sds_file
             WHERE tc_sds03 = g_tc_sds.tc_sds03
               AND tc_sds02 <> g_tc_sds.tc_sds02
            IF l_cnt = 1 THEN
               CALL cl_err('','agl-185',1)
               NEXT FIELD tc_sds03
            ELSE
               SELECT ima02,ima021 INTO g_tc_sds.tc_sds04,g_tc_sds.tc_sds05
                 FROM ima_file
                WHERE ima01 = g_tc_sds.tc_sds03
                  AND ima06 IN ('22129','22110')
               DISPLAY BY NAME g_tc_sds.tc_sds04
               DISPLAY BY NAME g_tc_sds.tc_sds05 
            END IF     
         END IF
 
      
      AFTER FIELD tc_sds06
         IF g_tc_sds.tc_sds06 > g_today THEN
            NEXT FIELD tc_sds06
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
            WHEN INFIELD(tc_sds01) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="cq_tc_ghs01"
               LET g_qryparam.default1 = g_tc_sds.tc_sds01
               CALL cl_create_qry() RETURNING g_tc_sds.tc_sds01 
               DISPLAY BY NAME g_tc_sds.tc_sds01
            WHEN INFIELD(tc_sds03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="cq_ima002"
               LET g_qryparam.default1 = g_tc_sds.tc_sds03
               CALL cl_create_qry() RETURNING g_tc_sds.tc_sds03,g_tc_sds.tc_sds04,g_tc_sds.tc_sds05
               DISPLAY BY NAME g_tc_sds.tc_sds06
               NEXT FIELD tc_sds03  
            WHEN INFIELD(tc_sds07)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="cq_tc_sds01"
               LET g_qryparam.default1 = g_tc_sds.tc_sds07
               CALL cl_create_qry() RETURNING g_tc_sds.tc_sds07,g_tc_sds.tc_sds08,g_tc_sds.tc_sds09
               DISPLAY BY NAME g_tc_sds.tc_sds07,g_tc_sds.tc_sds08,g_tc_sds.tc_sds09
               NEXT FIELD tc_sds07               
 
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
 
FUNCTION t501_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_msg("")  
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tc_sit.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t501_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_tc_sds.* TO NULL
      RETURN
   END IF
 
   OPEN t501_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_sds.* TO NULL
   ELSE
      OPEN t501_count
      FETCH t501_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t501_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t501_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1            
 
   CASE p_flag

      WHEN 'N' FETCH NEXT     t501_cs INTO g_tc_sds.tc_sds02             
      WHEN 'P' FETCH PREVIOUS t501_cs INTO g_tc_sds.tc_sds02              
      WHEN 'F' FETCH FIRST    t501_cs INTO g_tc_sds.tc_sds02                
      WHEN 'L' FETCH LAST     t501_cs INTO g_tc_sds.tc_sds02                
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
            FETCH ABSOLUTE g_jump t501_cs INTO g_tc_sds.tc_sds02                   
            LET g_no_ask = FALSE   
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_sds.tc_sds01,SQLCA.sqlcode,0)
      INITIALIZE g_tc_sds.* TO NULL             
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
 
   SELECT * INTO g_tc_sds.* FROM tc_sds_file 
     WHERE tc_sds02 = g_tc_sds.tc_sds02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","tc_sds_file","","",SQLCA.sqlcode,"","",1) 
      INITIALIZE g_tc_sds.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_tc_sds.tc_sdsuser      
   LET g_data_group = g_tc_sds.tc_sdsgrop    
   LET g_data_plant = g_tc_sds.tc_sdsplant   
   LET g_data_keyvalue = g_tc_sds.tc_sds01   
   CALL t501_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t501_show()
   DEFINE    l_cnt       LIKE type_file.num5      
 
   LET g_tc_sds_t.* = g_tc_sds.*                #保存單頭舊值
   LET g_tc_sds_o.* = g_tc_sds.*                #保存單頭舊值
   LET g_data_keyvalue = g_tc_sds.tc_sds02      #No:FUN-F50016

   IF g_tc_sds.tc_sdsconf='N' AND g_tc_sds.tc_sds10='1' THEN
      LET g_tc_sds.tc_sdsconf='Y'
      UPDATE tc_sds_file SET tc_sdsconf='Y' WHERE tc_sds02=g_tc_sds.tc_sds02
   END IF  
 
   DISPLAY BY NAME g_tc_sds.tc_sds01,g_tc_sds.tc_sds02,g_tc_sds.tc_sds03, 
                   g_tc_sds.tc_sds04,g_tc_sds.tc_sds05,g_tc_sds.tc_sds06,
                   g_tc_sds.tc_sds07,g_tc_sds.tc_sds08,g_tc_sds.tc_sds09,
                   g_tc_sds.tc_sds10,g_tc_sds.tc_sdsacti,g_tc_sds.tc_sdsconf,
                   g_tc_sds.tc_sdsuser,g_tc_sds.tc_sdsgrop,g_tc_sds.tc_sdsmodu,
                   g_tc_sds.tc_sdsdate,g_tc_sds.tc_sdsacti

   LET l_cnt = '' 
   SELECT 1 INTO l_cnt
     FROM tc_ghs_file
    WHERE tc_ghs01 = g_tc_sds.tc_sds01
   IF cl_null(l_cnt) THEN
      DISPLAY BY NAME g_tc_sds.tc_sds01 ATTRIBUTE(REVERSE,BOLD,RED)
   END IF

   CALL t501_b_fill(g_wc2)                 #單身
   CALL t501_show_pic() #圖示  
   CALL cl_show_fld_cont()              
END FUNCTION
 
FUNCTION t501_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_sds.tc_sds01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_tc_sds.tc_sds10 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      LET g_success='N' RETURN
   END IF   
   BEGIN WORK
 
   OPEN t501_cl USING g_tc_sds.tc_sds01, g_tc_sds.tc_sds02
   IF STATUS THEN
      CALL cl_err("OPEN t501_cl:", STATUS, 1)
      CLOSE t501_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t501_cl INTO g_tc_sds.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_sds.tc_sds01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t501_show()
 
   IF cl_exp(0,0,g_tc_sds.tc_sdsacti) THEN                   #確認一下
      LET g_chr=g_tc_sds.tc_sdsacti
      IF g_tc_sds.tc_sdsacti='Y' THEN
         LET g_tc_sds.tc_sdsacti='N'
      ELSE
         LET g_tc_sds.tc_sdsacti='Y'
      END IF
 
      UPDATE tc_sds_file SET tc_sdsacti=g_tc_sds.tc_sdsacti,
                             tc_sdsmodu=g_user,
                             tc_sdsdate=g_today
       WHERE tc_sds02=g_tc_sds.tc_sds02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tc_sds_file",g_tc_sds.tc_sds02,"",SQLCA.sqlcode,"","",1)  
         LET g_tc_sds.tc_sdsacti=g_chr
      END IF
   END IF
 
   CLOSE t501_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_tc_sds.tc_sds02,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT tc_sdsacti,tc_sdsmodu,tc_sdsdate
     INTO g_tc_sds.tc_sdsacti,g_tc_sds.tc_sdsmodu,g_tc_sds.tc_sdsdate FROM tc_sds_file
    WHERE tc_sds01=g_tc_sds.tc_sds02
   DISPLAY BY NAME g_tc_sds.tc_sdsacti,g_tc_sds.tc_sdsmodu,g_tc_sds.tc_sdsdate
 
END FUNCTION
 
FUNCTION t501_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_sds.tc_sds01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_tc_sds.tc_sdsconf='Y' THEN
      LET g_success='N' 
      RETURN
   END IF
   
   IF g_tc_sds.tc_sds10 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      LET g_success='N' 
      RETURN
   END IF   
 
   SELECT * INTO g_tc_sds.* FROM tc_sds_file
    WHERE tc_sds01=g_tc_sds.tc_sds01
      AND tc_sds02=g_tc_sds.tc_sds02
 
   BEGIN WORK
 
   OPEN t501_cl USING g_tc_sds.tc_sds02 
   IF STATUS THEN
      CALL cl_err("OPEN t501_cl:", STATUS, 1)
      CLOSE t501_cl
      ROLLBACK WORK
  
      RETURN
   END IF
 
   FETCH t501_cl INTO g_tc_sds.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_sds.tc_sds01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t501_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL         
       LET g_doc.column1 = "tc_sds02"         
       LET g_doc.value1 = g_tc_sds.tc_sds02    
       CALL cl_del_doc()                
      DELETE FROM tc_sds_file WHERE tc_sds02=g_tc_sds.tc_sds02
      DELETE FROM tc_sit_file WHERE tc_sit02=g_tc_sds.tc_sds02
      CLEAR FORM
      CALL g_tc_sit.clear()
      OPEN t501_count
      IF STATUS THEN
         CLOSE t501_cs  
         CLOSE t501_count
         COMMIT WORK
         RETURN
      END IF
      FETCH t501_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t501_cs  
         CLOSE t501_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t501_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t501_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE   
         CALL t501_fetch('/')
      END IF
   END IF
 
   CLOSE t501_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tc_sds.tc_sds01,'D')
END FUNCTION
 
#單身
FUNCTION t501_b()
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
 
DEFINE l_s      LIKE type_file.chr1000 
DEFINE l_m      LIKE type_file.chr1000 
DEFINE i        LIKE type_file.num5
DEFINE l_s1     LIKE type_file.chr1000 
DEFINE l_m1     LIKE type_file.chr1000
DEFINE l_count   LIKE type_file.num5
DEFINE l_sql     STRING
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_tc_sds.tc_sds01 IS NULL THEN
       RETURN
    END IF
 
    IF g_tc_sds.tc_sds10 ='9' THEN RETURN END IF  
    IF g_tc_sds.tc_sds10 matches '[Ss]' THEN     
       CALL cl_err("","mfg3557",1) 
       LET g_success='N' 
       RETURN
    END IF    
 
    SELECT * INTO g_tc_sds.* FROM tc_sds_file
     WHERE tc_sds02=g_tc_sds.tc_sds02
 
    IF g_tc_sds.tc_sdsacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_tc_sds.tc_sds02,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_sit03,gem02,tc_sit04,gen02,tc_sit05,tc_sit06,tc_faf02,tc_sit07,tc_sit08,tc_sit09,'',",
                       "       tc_sit10,tc_sit11,tc_sit12,'',tc_sit13,tc_sit14,tc_sitacti,tc_sitdate,tc_sitmodu",
                       "  FROM tc_sit_file ",
                       "  LEFT JOIN gem_file ON tc_sit03 = gem01 ",
                       "  LEFT JOIN gen_file ON tc_sit04 = gen01 ",
                       "  LEFT JOIN tc_faf_file ON tc_sit06 = tc_faf01 ",
                       " WHERE tc_sit02=? AND tc_sit03=? AND tc_sit06=? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t501_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    IF g_tc_sds.tc_sdsconf = 'Y' THEN
       LET l_allow_delete = FALSE
       LET g_tc_sds.tc_sds10='W'
    END IF
 
    INPUT ARRAY g_tc_sit WITHOUT DEFAULTS FROM s_tc_sit.*
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
 
           BEGIN WORK
 
           OPEN t501_cl USING g_tc_sds.tc_sds02
           IF STATUS THEN
              CALL cl_err("OPEN t501_cl 1444:", STATUS, 1)
              CLOSE t501_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t501_cl INTO g_tc_sds.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tc_sds.tc_sds01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t501_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_tc_sit_t.* = g_tc_sit[l_ac].*  #BACKUP
              LET g_tc_sit_o.* = g_tc_sit[l_ac].*  #BACKUP
              OPEN t501_bcl USING g_tc_sds.tc_sds02,g_tc_sit_t.tc_sit03,g_tc_sit_t.tc_sit06
              IF STATUS THEN
                 CALL cl_err("OPEN t501_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t501_bcl INTO g_tc_sit[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_sds.tc_sds02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              CALL cl_show_fld_cont()     
              END IF
           END IF 
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_sit[l_ac].* TO NULL        
           LET g_tc_sit_t.* = g_tc_sit[l_ac].*        
           LET g_tc_sit_o.* = g_tc_sit[l_ac].*        
           CALL cl_show_fld_cont()         
           NEXT FIELD tc_sit03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           
           INSERT INTO tc_sit_file(tc_sit01,tc_sit02,tc_sit03,tc_sit04,tc_sit05,tc_sit06,
                                   tc_sit07,tc_sit08,tc_sit09,tc_sit10,tc_sit11,tc_sit12,
                                   tc_sit13,tc_sit14,tc_sitacti,tc_sitdate,tc_sitmodu)  
           VALUES(g_tc_sds.tc_sds01,g_tc_sds.tc_sds02,
                  g_tc_sit[l_ac].tc_sit03,g_tc_sit[l_ac].tc_sit04,
                  g_tc_sit[l_ac].tc_sit05,g_tc_sit[l_ac].tc_sit06,
                  g_tc_sit[l_ac].tc_sit07,g_tc_sit[l_ac].tc_sit08,
                  g_tc_sit[l_ac].tc_sit09,g_tc_sit[l_ac].tc_sit10,
                  g_tc_sit[l_ac].tc_sit11,g_tc_sit[l_ac].tc_sit12,
                  g_tc_sit[l_ac].tc_sit13,g_tc_sit[l_ac].tc_sit14,
                  g_tc_sit[l_ac].tc_sitacti, g_today,g_user)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_sit_file",g_tc_sds.tc_sds01,g_tc_sds.tc_sds02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              IF g_tc_sds.tc_sdsconf='Y' THEN
                 LET g_tc_sds.tc_sds10='W'
              END IF 
              UPDATE tc_sds_file SET tc_sds10=g_tc_sds.tc_sds10,tc_sdsmodu=g_tc_sit[l_ac].tc_sit04,tc_sdsdate=g_today
               WHERE tc_sds02 = g_tc_sds.tc_sds02
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

        AFTER FIELD tc_sit03
           IF cl_null(g_tc_sit[l_ac].tc_sit03) THEN
              NEXT FIELD tc_sit03
           ELSE
              SELECT gem02 INTO g_tc_sit[l_ac].gem02
               FROM gem_file
               WHERE gem01 = g_tc_sit[l_ac].tc_sit03
                 AND gemacti='Y'
               IF cl_null(g_tc_sit[l_ac].gem02) THEN
                  NEXT FIELD tc_sit03
               END IF
               DISPLAY BY NAME g_tc_sit[l_ac].gem02
           END IF 
         
           
        AFTER FIELD tc_sit04
           IF cl_null(g_tc_sit[l_ac].tc_sit04) THEN
              NEXT FIELD tc_sit03
           ELSE
              SELECT gen02 INTO g_tc_sit[l_ac].gen02
               FROM gen_file
               WHERE gen01 = g_tc_sit[l_ac].tc_sit04
                 AND genacti='Y'
               IF cl_null(g_tc_sit[l_ac].gen02) THEN
                  NEXT FIELD tc_sit04
               END IF
               DISPLAY BY NAME g_tc_sit[l_ac].gen02
           END IF                                  
           
           
        AFTER FIELD tc_sit05
           IF cl_null(g_tc_sit[l_ac].tc_sit05) THEN
              NEXT FIELD tc_sit05
           END IF 

        AFTER FIELD tc_sit06
           IF cl_null(g_tc_sit[l_ac].tc_sit06) THEN
              NEXT FIELD tc_sit06
           ELSE
              SELECT tc_faf02 INTO g_tc_sit[l_ac].tc_faf02
                FROM tc_faf_file
                WHERE tc_faf01 = g_tc_sit[l_ac].tc_sit06
              IF cl_null(g_tc_sit[l_ac].tc_faf02) THEN
                 NEXT FIELD tc_sit06
              END IF
              DISPLAY BY NAME g_tc_sit[l_ac].tc_faf02
           END IF 

        AFTER FIELD tc_sit09
           IF NOT cl_null(g_tc_sit[l_ac].tc_sit09) THEN
              SELECT tc_faf02 INTO g_tc_sit[l_ac].tc_faf02_2
                FROM tc_faf_file
                WHERE tc_faf01 = g_tc_sit[l_ac].tc_sit09
              IF cl_null(g_tc_sit[l_ac].tc_faf02_2) THEN
                 NEXT FIELD tc_sit09
              END IF
           END IF

        AFTER FIELD tc_sit12
           IF NOT cl_null(g_tc_sit[l_ac].tc_sit12) THEN
              SELECT tc_faf02 INTO g_tc_sit[l_ac].tc_faf02_3
                FROM tc_faf_file
                WHERE tc_faf01 = g_tc_sit[l_ac].tc_sit12
              IF cl_null(g_tc_sit[l_ac].tc_faf02_3) THEN
                 NEXT FIELD tc_sit12
              END IF
              LET g_tc_sit[l_ac].tc_sitacti='Y'
           END IF

        AFTER FIELD tc_sit08
           IF cl_null(g_tc_sit[l_ac].tc_sit08) THEN
              NEXT FIELD tc_sit08
           END IF 

                      
        BEFORE DELETE                     
           DISPLAY "BEFORE DELETE"
           IF g_tc_sds.tc_sds02 > 0 AND g_tc_sds.tc_sds02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM tc_sit_file
               WHERE tc_sit02 = g_tc_sds.tc_sds02
                 AND tc_sit03 = g_tc_sit_t.tc_sit03
                 AND tc_sit06 = g_tc_sit_t.tc_sit06
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_sit_file",g_tc_sds.tc_sds02,g_tc_sit_t.tc_sit03,SQLCA.sqlcode,"","",1)
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
              LET g_tc_sit[l_ac].* = g_tc_sit_t.*
              CLOSE t501_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_sit[l_ac].tc_sit03,-263,1)
              LET g_tc_sit[l_ac].* = g_tc_sit_t.*
           ELSE
              UPDATE tc_sit_file SET 
                                  tc_sit03=g_tc_sit[l_ac].tc_sit03,
                                  tc_sit04=g_tc_sit[l_ac].tc_sit04,
                                  tc_sit05=g_tc_sit[l_ac].tc_sit05,
                                  tc_sit06=g_tc_sit[l_ac].tc_sit06,
                                  tc_sit07=g_tc_sit[l_ac].tc_sit07,
                                  tc_sit08=g_tc_sit[l_ac].tc_sit08,
                                  tc_sit09=g_tc_sit[l_ac].tc_sit09,
                                  tc_sit10=g_tc_sit[l_ac].tc_sit10,
                                  tc_sit11=g_tc_sit[l_ac].tc_sit11,
                                  tc_sit12=g_tc_sit[l_ac].tc_sit12,
                                  tc_sit13=g_tc_sit[l_ac].tc_sit13,
                                  tc_sit14=g_tc_sit[l_ac].tc_sit14,
                                  tc_sitacti=g_tc_sit[l_ac].tc_sitacti,
                                  tc_sitdate=g_today,
                                  tc_sitmodu=g_user
               WHERE tc_sit02=g_tc_sds.tc_sds02
                 AND tc_sit03=g_tc_sit_t.tc_sit03
                 AND tc_sit06=g_tc_sit_t.tc_sit06
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tc_sit_file",g_tc_sds.tc_sds02,g_tc_sit_t.tc_sit03,SQLCA.sqlcode,"","",1)
                 LET g_tc_sit[l_ac].* = g_tc_sit_t.*
              ELSE
                 IF g_tc_sds.tc_sdsconf='Y' THEN
                    LET g_tc_sds.tc_sds10='W'
                 END IF
                 UPDATE tc_sds_file SET tc_sds10=g_tc_sds.tc_sds10,tc_sdsmodu=g_tc_sit[l_ac].tc_sit04,tc_sdsdate=g_today
                   WHERE tc_sds02 = g_tc_sds.tc_sds02
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","tc_sit_file",g_tc_sds.tc_sds02,g_tc_sit_t.tc_sit03,SQLCA.sqlcode,"","",1)
                 END IF
                 DISPLAY BY NAME g_tc_sds.tc_sds10
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
                 LET g_tc_sit[l_ac].* = g_tc_sit_t.*
              ELSE
                 CALL g_tc_sit.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              END IF
              CLOSE t501_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  
           CLOSE t501_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tc_sit03) AND l_ac > 1 THEN
              LET g_tc_sit[l_ac].* = g_tc_sit[l_ac-1].*
              LET g_tc_sit[l_ac].tc_sitdate = g_today
              LET g_tc_sit[l_ac].tc_sitmodu = g_user
              NEXT FIELD tc_sit03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
           
        ON ACTION CONTROLP
           CASE           
            WHEN INFIELD(tc_sit03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 CALL cl_create_qry() RETURNING g_tc_sit[l_ac].tc_sit03
                 DISPLAY BY NAME g_tc_sit[l_ac].tc_sit03
                 NEXT FIELD tc_sit03
             WHEN INFIELD(tc_sit04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 CALL cl_create_qry() RETURNING g_tc_sit[l_ac].tc_sit04
                 DISPLAY BY NAME g_tc_sit[l_ac].tc_sit04
                 NEXT FIELD tc_sit04
              WHEN INFIELD(tc_sit06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_faf"
                 CALL cl_create_qry() RETURNING g_tc_sit[l_ac].tc_sit06
                 DISPLAY BY NAME g_tc_sit[l_ac].tc_sit06
                 NEXT FIELD tc_sit06
              WHEN INFIELD(tc_sit09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_faf"
                 CALL cl_create_qry() RETURNING g_tc_sit[l_ac].tc_sit09
                 DISPLAY BY NAME g_tc_sit[l_ac].tc_sit09
                 NEXT FIELD tc_sit09
              WHEN INFIELD(tc_sit12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_faf"
                 CALL cl_create_qry() RETURNING g_tc_sit[l_ac].tc_sit12
                 DISPLAY BY NAME g_tc_sit[l_ac].tc_sit12
                 NEXT FIELD tc_sit12
              
                          
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
 
    CLOSE t501_bcl
    COMMIT WORK
    CALL t501_delHeader()
END FUNCTION


FUNCTION t501_delHeader()
   DEFINE l_action_choice    STRING               
   DEFINE l_cho              LIKE type_file.num5  
   DEFINE l_num              LIKE type_file.num5  
   DEFINE l_slip             LIKE type_file.chr5  
   DEFINE l_sql              STRING               
   DEFINE l_cnt              LIKE type_file.num5  
   DEFINE l_n                LIKE type_file.num5

   SELECT COUNT(*) INTO l_n FROM tc_sit_file 
     WHERE tc_sit02 = g_tc_sds.tc_sds02

   IF l_n = 0 THEN
      LET l_sql = " SELECT COUNT(*) FROM tc_sds_file ",
                  "  WHERE  ",
                  "    tc_sds02 > '",g_tc_sds.tc_sds02,"'"
      PREPARE t501_pb6 FROM l_sql 
      EXECUTE t501_pb6 INTO l_cnt       
      
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
         CALL t501_v(1)  
         CALL t501_show_pic()
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM tc_sds_file WHERE tc_sds02 = g_tc_sds.tc_sds02
         INITIALIZE g_tc_sds.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION

 
FUNCTION t501_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE l_s     LIKE type_file.chr1000 
DEFINE l_m     LIKE type_file.chr1000 
DEFINE i       LIKE type_file.num5
 
   LET g_sql = "SELECT tc_sit03,gem02,tc_sit04,gen02,tc_sit05,",
               " tc_sit06,tc_faf02,tc_sit07,tc_sit08,tc_sit09,'',tc_sit10,tc_sit11,tc_sit12,'',",
               " tc_sit13,tc_sit14,tc_sitacti,tc_sitdate,tc_sitmodu ",
               "  FROM tc_sit_file,gem_file,gen_file,tc_faf_file ",
               " WHERE tc_sit03=gem01 AND tc_sit04=gen01 AND tc_sit06=tc_faf01 ",
               "   AND tc_sit02 ='",g_tc_sds.tc_sds02,"'"
               
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY tc_sit02"
   DISPLAY g_sql
 
   PREPARE t501_pb FROM g_sql
   DECLARE tc_sit_cs CURSOR FOR t501_pb
 
   CALL g_tc_sit.clear()
   LET g_cnt = 1
 
   FOREACH tc_sit_cs INTO g_tc_sit[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
    
       SELECT tc_faf02 INTO g_tc_sit[g_cnt].tc_faf02_2
         FROM tc_faf_file
        WHERE tc_faf01 = g_tc_sit[g_cnt].tc_sit09  

       SELECT tc_faf02 INTO g_tc_sit[g_cnt].tc_faf02_3
         FROM tc_faf_file
        WHERE tc_faf01 = g_tc_sit[g_cnt].tc_sit09  

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_tc_sit.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 

FUNCTION t501_y_chk()
  DEFINE l_n      LIKE type_file.num5  
  
    LET g_success = 'Y'
 
    IF g_tc_sds.tc_sds02 IS NULL THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       RETURN
    END IF
    IF g_tc_sds.tc_sds10 = '9' THEN 
       LET g_success = 'N'
       RETURN 
    END IF  
    IF g_tc_sds.tc_sds10 = '1' THEN  #已核准
       CALL cl_err('','mfg3212',1)
       LET g_success = 'N'
       RETURN
    END IF


    IF g_tc_sds.tc_sdsacti = 'N' THEN  #本筆資料無效
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
    
    IF g_tc_sds.tc_sdsacti = 'N' THEN  #本筆資料無效
       CALL cl_err('','abm-889',1)
       LET g_success = 'N'
       RETURN
    END IF
END FUNCTION

FUNCTION t501_y_upd()
  DEFINE i         LIKE type_file.num5
  DEFINE l_cnt     LIKE type_file.num5
  DEFINE c_tc_sds09   LIKE tc_sds_file.tc_sds09
  DEFINE c_tc_sds06   LIKE tc_sds_file.tc_sds06  
  DEFINE c_tc_sit02   LIKE tc_sit_file.tc_sit02
  DEFINE c_tc_sit03   LIKE tc_sit_file.tc_sit03  
  DEFINE c_tc_sit04   LIKE tc_sit_file.tc_sit04  

    LET g_success = 'Y'
    LET g_flag = 'Y' 

    IF g_action_choice CLIPPED = "confirm" OR  #執行 "確認" 功能(非簽核模式呼叫)
       g_action_choice CLIPPED = "insert"    
    THEN
       IF g_tc_sds.tc_sdsacti = 'Y' THEN        #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
          IF g_tc_sds.tc_sds10 != '1' THEN
             CALL cl_err('','aws-078',1)  #此狀況碼不為「1.已核准」，不可確認!!
             LET g_success = 'N'
             RETURN
          END IF
       END IF
    END IF

    BEGIN WORK

    IF g_success = 'Y' THEN
       IF g_tc_sds.tc_sdsacti = 'Y' THEN       #簽核模式
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
          LET g_tc_sds.tc_sds10 = '1'  #執行成功，狀態值顯示為'1'已核准
          LET g_tc_sds.tc_sdsconf = 'Y'
          UPDATE tc_sds_file SET tc_sds10 = '1',tc_sdsconf='Y'
           WHERE tc_sds02 = g_tc_sds.tc_sds02
          DISPLAY BY NAME g_tc_sds.tc_sds10   
          DISPLAY BY NAME g_tc_sds.tc_sdsconf  
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
 
FUNCTION t501_changehead()
  DEFINE l_cnt     LIKE type_file.num5
   
    LET g_success = 'Y' 
    LET g_flag ='Y'                
   
    IF g_tc_sds.tc_sds10 = '9' THEN RETURN END IF 
    IF g_tc_sds.tc_sds10 = 'S' THEN
       #送簽中, 不可修改資料!
       CALL cl_err(g_tc_sds.tc_sds10,'apm-030',1)
       RETURN
    END IF
    
    INPUT g_tc_sds.tc_sds06,g_tc_sds.tc_sds07,g_tc_sds.tc_sds08,g_tc_sds.tc_sds09
     WITHOUT DEFAULTS FROM tc_sds06,tc_sds07,tc_sds08,tc_sds09

    AFTER FIELD tc_sds06
      IF g_tc_sds.tc_sds06 > g_today THEN
         NEXT FIELD tc_sds06
      END IF

    IF INT_FLAG THEN
       CALL cl_err('',9001,0)
       LET INT_FLAG = 0
       ROLLBACK WORK
       EXIT INPUT
       RETURN
    ELSE
       UPDATE tc_sds_file SET tc_sds10='W',
                              tc_sds06 = g_tc_sds.tc_sds06,
                              tc_sds07 = g_tc_sds.tc_sds07, 
                              tc_sds08 = g_tc_sds.tc_sds08, 
                              tc_sds09 = g_tc_sds.tc_sds09,
                              tc_sdsdate = g_today,
                              tc_sdsmodu = g_user
        WHERE tc_sds02 = g_tc_sds.tc_sds02
    END IF

    END INPUT
    SELECT * INTO g_tc_sds.* FROM tc_sds_file 
     WHERE tc_sds02 = g_tc_sds.tc_sds02
    
END FUNCTION

FUNCTION t501_changeitem()
  DEFINE l_cnt     LIKE type_file.num5

    LET g_success = 'Y'
    LET g_flag ='Y'

    IF g_tc_sds.tc_sdsconf = 'Y' THEN RETURN END IF

    INPUT g_tc_sds.tc_sds03 WITHOUT DEFAULTS FROM tc_sds03

    AFTER FIELD tc_sds03
       SELECT ima02,ima021 INTO g_tc_sds.tc_sds04,g_tc_sds.tc_sds05
         FROM ima_file
        WHERE ima01 = g_tc_sds.tc_sds03
          AND NOT EXISTS (SELECT 1 FROM tc_sds_file WHERE tc_sds03 = g_tc_sds.tc_sds03)
       IF cl_null(g_tc_sds.tc_sds04) THEN
          NEXT FIELD tc_sds03
       END IF

    IF INT_FLAG THEN
       CALL cl_err('',9001,0)
       LET INT_FLAG = 0
       ROLLBACK WORK
       EXIT INPUT
       RETURN
    ELSE
       UPDATE tc_sds_file SET tc_sds03 = g_tc_sds.tc_sds03,
                              tc_sds04 = g_tc_sds.tc_sds04,
                              tc_sds05 = g_tc_sds.tc_sds05,
                              tc_sdsdate = g_today,
                              tc_sdsmodu = g_user
        WHERE tc_sds02 = g_tc_sds.tc_sds02
    END IF

    END INPUT
    SELECT * INTO g_tc_sds.* FROM tc_sds_file
     WHERE tc_sds02 = g_tc_sds.tc_sds02

END FUNCTION
 
FUNCTION t501_ef()     
     CALL t501_show()   #20230105                                                                                                              
     CALL t501_y_chk()  #CALL 原確認段的check段後在執行送簽
     IF g_success = 'N' THEN                                                                                                        
        RETURN                                                                                                                     
     END IF                                                                                                                         

     IF g_tc_sds.tc_sdsacti = 'N' THEN
        CALL cl_err('','abm-885',1)
        LET g_success = 'N'
        RETURN
     END IF
     IF g_tc_sds.tc_sds10 = '1' THEN     
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
                                                                                                                
 IF aws_efcli2(base.TypeInfo.create(g_tc_sds),base.TypeInfo.create(g_tc_sit),'','','','')                        
 THEN
   LET g_success='Y'                                                                                                   
  #重新更新狀態碼顯示
   SELECT tc_sds10 INTO g_tc_sds.tc_sds10 FROM tc_sds_file 
    WHERE tc_sds02 = g_tc_sds.tc_sds02
   DISPLAY BY NAME g_tc_sds.tc_sds10      
 ELSE                                                                                                                               
   LET g_success='N'                                                                                                                
 END IF                                                                                                                             
                                                                                                                                    
END FUNCTION 
 
FUNCTION t501_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tc_sds01",TRUE)
   END IF   
END FUNCTION
 
FUNCTION t501_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("tc_sds01",FALSE)
   END IF
END FUNCTION
 
FUNCTION t501_show_pic()
DEFINE l_chr3  LIKE type_file.chr1  
     IF g_tc_sds.tc_sds10 MATCHES '[1]' THEN
         LET g_chr1='Y'
         LET g_chr2='Y'
     ELSE
         LET g_chr1='N'
         LET g_chr2='N'
     END IF
     IF g_tc_sds.tc_sds10 MATCHES '[9]' THEN
         LET l_chr3 = 'Y'
     ELSE
         LET l_chr3 = 'N'
     END IF 
     CALL cl_set_field_pic(g_chr1,g_chr2,"","",l_chr3,g_tc_sds.tc_sdsacti)
END FUNCTION

FUNCTION t501_v(p_type)   
DEFINE   l_chr              LIKE type_file.chr1
DEFINE   l_chr1             LIKE type_file.chr1
DEFINE   l_flag             LIKE type_file.chr1  
DEFINE   p_type             LIKE type_file.chr1 

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_tc_sds.tc_sds02) THEN CALL cl_err('',-400,0) RETURN END IF  
   
   IF p_type = 1 THEN
      IF g_tc_sds.tc_sds10 ='9' THEN RETURN END IF
   ELSE
      IF g_tc_sds.tc_sds10 <>'9' THEN RETURN END IF
   END IF
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t501_cl USING g_tc_sds.tc_sds02
   IF STATUS THEN
      CALL cl_err("OPEN t501_cl:", STATUS, 1)
      CLOSE t501_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t501_cl INTO g_tc_sds.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_sds.tc_sds01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t501_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_tc_sds.tc_sds10 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      RETURN
   END IF  
   IF g_tc_sds.tc_sds10 = '0' THEN
      LET l_chr1 = 'N'
   ELSE
      LET l_chr1 = 'X'
   END IF 
   IF g_tc_sds.tc_sds10='9' AND NOT cl_null(g_sma.sma53) AND g_tc_sds.tc_sds02 <= g_sma.sma53 THEN
      CALL cl_err('','alm1393',0)
      RETURN
   END IF
   IF cl_void(0,0,l_chr1)   THEN 
        LET l_chr=g_tc_sds.tc_sds10
        IF p_type = 1 THEN        
            LET g_tc_sds.tc_sds10='9' 
            LET g_tc_sds.tc_sdsconf='X' 
        ELSE 
           IF g_tc_sds.tc_sds10='9' THEN
              LET g_tc_sds.tc_sds10='0'
              LET g_tc_sds.tc_sdsconf='N'
           END IF 
        END IF
        UPDATE tc_sds_file
            SET tc_sds10=g_tc_sds.tc_sds10,  
                tc_sdsconf=g_tc_sds.tc_sdsconf,
                tc_sdsmodu=g_user,
                tc_sdsdate=g_today
            WHERE tc_sds02=g_tc_sds.tc_sds02
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","tc_sds_file",g_tc_sds.tc_sds02,"",SQLCA.sqlcode,"","",1)  
            LET g_tc_sds.tc_sds10=l_chr 
        END IF
        DISPLAY BY NAME g_tc_sds.tc_sds10 
        DISPLAY BY NAME g_tc_sds.tc_sdsconf
   END IF
 
   COMMIT WORK
   CLOSE t501_cl
 
END FUNCTION


FUNCTION t501_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_sds_l TO s_tc_sds.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()     

      ON ACTION page_main
         LET g_action_flag = 'page_main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL t501_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_info", TRUE)
         EXIT DISPLAY          
       
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      
 
      ON ACTION first
         CALL t501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
 
      ON ACTION jump
         CALL t501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY   
 
      ON ACTION next
         CALL t501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL t501_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
         
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac1 = 1
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
         
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      ON ACTION accept
          LET g_action_flag = 'page_main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         CALL t501_fetch('/')
         CALL cl_set_comp_visible("page_info", FALSE)
         CALL cl_set_comp_visible("page_info", TRUE)
         CALL ui.interface.refresh()
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
     
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t501_list_fill()
DEFINE l_cnt          LIKE type_file.num10
DEFINE l_tc_sds02     LIKE tc_sds_file.tc_sds02

   CALL g_tc_sds_l.clear()
   LET l_cnt = 1

   FOREACH t501_cs INTO l_tc_sds02
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF

      SELECT tc_sds01,tc_sds02,tc_sds03,tc_sds04,tc_sds05,tc_sds06,tc_sds07,tc_sds09,
             (tc_sds06+1095)-sysdate
        INTO g_tc_sds_l[l_cnt].*
        FROM tc_sds_file 
       WHERE tc_sds02 = l_tc_sds02
       
       LET l_cnt = l_cnt + 1
       IF l_cnt > g_max_rec THEN
       IF g_action_choice ="query"  THEN
            CALL cl_err( '', 9035, 0 )
          END IF
          EXIT FOREACH
       END IF
    END FOREACH
    
    OPEN t501_cs                     
    LET g_rec_b1 = l_cnt - 1
    DISPLAY g_rec_b1 TO FORMONLY.cnt  
    DISPLAY ARRAY g_tc_sds_l TO s_tc_sds.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
END FUNCTION

##--- 資料清單 (E)

 
