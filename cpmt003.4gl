# Prog. Version..: '5.30.24-17.04.13(00030)'     #
#
# Pattern name...: cpmt003.4gl
# Descriptions...: 模具
# Date & Author..: NO.22080028  20220921 By momo 模具資料表維護作業
# Modify.........: No.
# Modify.........: No.22100031  20221024 By momo 查詢QC單調整

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE g_tc_evad         RECORD LIKE tc_evad_file.*,      
       g_tc_evad_t       RECORD LIKE tc_evad_file.*,       
       g_tc_evad_o       RECORD LIKE tc_evad_file.*,       
       g_tc_evad01_t     LIKE tc_evad_file.tc_evad01,          
       g_t1          LIKE smy_file.smyslip,              
       g_ydate       LIKE type_file.dat,          
       g_tc_evae         DYNAMIC ARRAY OF RECORD       
           tc_evae02     LIKE tc_evae_file.tc_evae02,          
           tc_evae03     LIKE tc_evae_file.tc_evae03,
           ima02         LIKE ima_file.ima02,
           ima021        LIKE ima_file.ima021,                   
           tc_evae04     LIKE tc_evae_file.tc_evae04,
           tc_evae05     LIKE tc_evae_file.tc_evae05,                                                                        
           tc_evae06     LIKE tc_evae_file.tc_evae06,                    
           tc_evae07     LIKE tc_evae_file.tc_evae07,
           rvb01         LIKE rvb_file.rvb01                   
                     END RECORD,
       g_tc_evae_t       RECORD                    
           tc_evae02     LIKE tc_evae_file.tc_evae02,          
           tc_evae03     LIKE tc_evae_file.tc_evae03,
           ima02         LIKE ima_file.ima02,
           ima021        LIKE ima_file.ima021,                   
           tc_evae04     LIKE tc_evae_file.tc_evae04,
           tc_evae05     LIKE tc_evae_file.tc_evae05,                                                                         
           tc_evae06     LIKE tc_evae_file.tc_evae06,          
           tc_evae07     LIKE tc_evae_file.tc_evae07,         
           rvb01         LIKE rvb_file.rvb01                   
                     END RECORD,
       g_tc_evae_o       RECORD                      
           tc_evae02     LIKE tc_evae_file.tc_evae02,          
           tc_evae03     LIKE tc_evae_file.tc_evae03,
           ima02         LIKE ima_file.ima02,
           ima021        LIKE ima_file.ima021,                   
           tc_evae04     LIKE tc_evae_file.tc_evae04,
           tc_evae05     LIKE tc_evae_file.tc_evae05,                                                                        
           tc_evae06     LIKE tc_evae_file.tc_evae06,          
           tc_evae07     LIKE tc_evae_file.tc_evae07,         
           rvb01         LIKE rvb_file.rvb01                   
                     END RECORD,
       g_tc_evaf         DYNAMIC ARRAY OF RECORD       
           tc_evaf02     LIKE tc_evaf_file.tc_evaf02,          
           tc_evaf03     LIKE tc_evaf_file.tc_evaf03,                  
           tc_evaf04     LIKE tc_evaf_file.tc_evaf04,
           tc_evaf05     LIKE tc_evaf_file.tc_evaf05,                                                                        
           tc_evaf06     LIKE tc_evaf_file.tc_evaf06,
           tc_evaf07     LIKE tc_evaf_file.tc_evaf07,
           tc_evaf08     LIKE tc_evaf_file.tc_evaf08,
           tc_evaf09     LIKE tc_evaf_file.tc_evaf09          
                     END RECORD,
       g_tc_evaf_t       RECORD       
           tc_evaf02     LIKE tc_evaf_file.tc_evaf02,          
           tc_evaf03     LIKE tc_evaf_file.tc_evaf03,                  
           tc_evaf04     LIKE tc_evaf_file.tc_evaf04,
           tc_evaf05     LIKE tc_evaf_file.tc_evaf05,                                                                        
           tc_evaf06     LIKE tc_evaf_file.tc_evaf06,
           tc_evaf07     LIKE tc_evaf_file.tc_evaf07,
           tc_evaf08     LIKE tc_evaf_file.tc_evaf08,
           tc_evaf09     LIKE tc_evaf_file.tc_evaf09          
                     END RECORD,
       g_sql         STRING,                       
       g_wc          STRING,                       
       g_wc2         STRING,                       
       g_wc3         STRING,                       
       l_wc          STRING,                       
       g_rec_b       LIKE type_file.num5,          
       l_ac          LIKE type_file.num5,
       l_ac2         LIKE type_file.num5         
DEFINE g_forupd_sql        STRING                
DEFINE g_before_input_done LIKE type_file.num5    
DEFINE g_chr               LIKE type_file.chr1   
DEFINE g_cnt               LIKE type_file.num10  
DEFINE g_cnt2              LIKE type_file.num10  
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
DEFINE g_argv1             LIKE tc_evad_file.tc_evad01  #單號        
DEFINE g_argv2             STRING                       #執行功能               
DEFINE g_laststage         LIKE type_file.chr1  #是否為簽核最後一站flag  #FUN-BC0038
DEFINE g_chr1,g_chr2       LIKE type_file.chr1  #VARCHAR(1)              #FUN-BC0038
#資料清單
DEFINE w              ui.Window
DEFINE f              ui.Form
DEFINE page           om.DomNode
DEFINE g_action_flag  STRING
DEFINE g_cmd          STRING
DEFINE g_rec_b1       LIKE type_file.num10
DEFINE l_ac1          LIKE type_file.num10
DEFINE g_tc_evad_l    DYNAMIC ARRAY OF RECORD
       tc_evad01_l    LIKE tc_evad_file.tc_evad01,
       tc_evad02_l    LIKE tc_evad_file.tc_evad02,
       tc_evad03_l    LIKE tc_evad_file.tc_evad03,
       gen02_l        LIKE gen_file.gen02,
       tc_evad05_l    LIKE tc_evad_file.tc_evad05,
       tc_evad06_l    LIKE tc_evad_file.tc_evad06,
       pmc03_l        LIKE pmc_file.pmc03,
       tc_evad12_l    LIKE tc_evad_file.tc_evad12,
       tc_evad14_l    LIKE tc_evad_file.tc_evad14,
       tc_evad15_l    LIKE tc_evad_file.tc_evad15,
       tc_evad16_l    LIKE tc_evad_file.tc_evad16,
       pmc03_2_l      LIKE pmc_file.pmc03,
       tc_evae03_l    LIKE tc_evae_file.tc_evae03,
       tc_evae07_l    LIKE tc_evae_file.tc_evae07,
       ima02_l        LIKE ima_file.ima02,
       ima021_l       LIKE ima_file.ima021,
       tc_evaf05_l    LIKE tc_evaf_file.tc_evaf05,
       tc_evaf06_l    LIKE tc_evaf_file.tc_evaf06,
       tc_evaf07_l    LIKE tc_evaf_file.tc_evaf07,
       tc_evaf09_l    LIKE tc_evaf_file.tc_evaf09,
       delay          LIKE type_file.num5
       END RECORD

MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN      #判斷是否為背景執行程式 FUN-EC0003 add
      OPTIONS                               #改變一些系統預設值
         INPUT NO WRAP
   END IF                                   #FUN-EC0003 add

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
   LET g_argv2 = ARG_VAL(2)              #執行功能 #FUN-EC0003 add
   IF fgl_getenv('EASYFLOW') = "1" THEN  #判斷是否為簽核模式
      LET g_argv1 = aws_efapp_wsk(1)     #取得單號,參數:key-1
   END IF
 
 
   LET g_forupd_sql = "SELECT * FROM tc_evad_file WHERE tc_evad01 = ? FOR UPDATE"   
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t003_cl CURSOR FROM g_forupd_sql
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN   
      OPEN WINDOW t003_w WITH FORM "cpm/42f/cpmt003"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
      CALL cl_set_locale_frm_name("cpmt003")    
      CALL cl_ui_init()
      #CALL cl_set_combo_items_plus("tc_evad05","cpmt003","tc_evad05")
   END IF   
   
 
   CALL aws_efapp_toolbar()    #建立簽核模式時的toolbar icon
   CALL aws_efapp_flowaction("insert, modify, delete, invalid, detail, query, locale, fin, undo_fin, undo_mass, easyflow_approval")  #CHI-D20030 add undo_void
        RETURNING g_laststage  #傳入簽核模式時不應執行的action清單
  
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "efconfirm"
            CALL t003_q()
            CALL t003_y_chk()
            IF g_success = "Y" THEN
               CALL t003_y_upd()
            END IF
            EXIT PROGRAM
         OTHERWISE
            CALL t003_q()
      END CASE
   END IF
   
   CALL t003_menu()
   CLOSE WINDOW t003_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t003_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_tc_evae.clear()
   CALL g_tc_evaf.clear()
    

   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " tc_evad01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
      LET g_wc3 = " 1=1"
   ELSE
 
      CONSTRUCT BY NAME g_wc ON tc_evad01,tc_evad02,tc_evad03,tc_evad04,tc_evad05,tc_evad06,
                                tc_evad07,tc_evad08,tc_evad13,tc_evad12,tc_evad14, 
                                tc_evaduser,tc_evadgrup,tc_evadmodu,tc_evaddate,tc_evadacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(tc_evad01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="cq_tc_evad01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evad01                
                  NEXT FIELD tc_evad01
                  
               WHEN INFIELD(tc_evad03) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evad03
                  NEXT FIELD tc_evad03                  
      
               WHEN INFIELD(tc_evad04) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evad04
                  NEXT FIELD tc_evad04
      
               WHEN INFIELD(tc_evad06)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_pmc2"                  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evad06
                  NEXT FIELD tc_evad06

               WHEN INFIELD(tc_evad14) #財產編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_faj03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_evad14
                  NEXT FIELD tc_evad14

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
   
  
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_evaduser', 'tc_evadgrup')
 
   CONSTRUCT g_wc2 ON tc_evae02,tc_evae03,tc_evae04,   
                      tc_evae05,tc_evae06,tc_evae07
             FROM s_tc_evae[1].tc_evae02,s_tc_evae[1].tc_evae03,s_tc_evae[1].tc_evae04,
                  s_tc_evae[1].tc_evae05,s_tc_evae[1].tc_evae06,s_tc_evae[1].tc_evae07
 
      BEFORE CONSTRUCT
        CALL cl_qbe_display_condition(lc_qbe_sn)
   
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_evae03) 
              CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_evae03
              NEXT FIELD tc_evae03 
            WHEN INFIELD(tc_evae05)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "cq_pmn01"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_evae05
              NEXT FIELD tc_evae05
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

      CONSTRUCT g_wc3 ON tc_evaf02,tc_evaf04,   
                      tc_evaf05,tc_evaf06,tc_evaf07,tc_evaf08,tc_evaf09
             FROM s_tc_evaf[1].tc_evaf02,s_tc_evaf[1].tc_evaf04,s_tc_evaf[1].tc_evaf05,
                  s_tc_evaf[1].tc_evaf06,s_tc_evaf[1].tc_evaf07,s_tc_evaf[1].tc_evaf08,
                  s_tc_evaf[1].tc_evaf09
 
      BEFORE CONSTRUCT
        CALL cl_qbe_display_condition(lc_qbe_sn)
   
      ON ACTION CONTROLP
         CASE
            
            WHEN INFIELD(tc_evaf04)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_pje"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tc_evaf04
              NEXT FIELD tc_evae04
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
      LET g_sql = "SELECT tc_evad01 FROM tc_evad_file ",        
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tc_evad01"
   ELSE                             
      LET g_sql = "SELECT tc_evad01 ",                        
                  "  FROM tc_evad_file, tc_evae_file ",
                  "  LEFT JOIN tc_evaf_file ON tc_evae01=tc_evaf01 ",
                  " WHERE tc_evad01 = tc_evae01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED,
                  " ORDER BY tc_evae02"
   END IF
 
   PREPARE t003_prepare FROM g_sql
   DECLARE t003_cs                         
       SCROLL CURSOR WITH HOLD FOR t003_prepare
 
   IF g_wc2 = " 1=1" THEN                  
      LET g_sql="SELECT COUNT(*) FROM tc_evad_file WHERE ",g_wc CLIPPED
   ELSE
      
      LET g_sql="SELECT COUNT(DISTINCT tc_evad01) ",
                "FROM tc_evad_file,tc_evae_file ",
                "LEFT JOIN tc_evaf_file ON tc_evae01=tc_evaf01",
                "WHERE tc_evae01=tc_evad01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED
   END IF
 
   PREPARE t003_precount FROM g_sql
   DECLARE t003_count CURSOR FOR t003_precount
 
END FUNCTION
 
FUNCTION t003_menu() 
DEFINE l_creator  LIKE type_file.chr1  #是否退回填表人      
DEFINE l_flowuser LIKE type_file.chr1  #是否有指定加簽人員 
DEFINE  l_node         om.DomNode,
        win            ui.Window,
        f              ui.Form 

   LET l_flowuser = "N"  #FUN-BC0038
 
   WHILE TRUE
      ## 資料清單(S)
      #CALL t003_bp("G")
       CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "main")
            CALL t003_bp("G")
         WHEN (g_action_flag = "page_list")
            CALL t003_list_fill()
            CALL t003_bp1("G")
            IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
               SELECT tc_evad_file.* INTO g_tc_evad.* FROM tc_evad_file
                WHERE tc_evad01=g_tc_evad_l[l_ac1].tc_evad01_l
            END IF
            IF g_action_choice!= "" THEN
               LET g_action_flag = 'main'
               LET l_ac1 = ARR_CURR()
               LET g_jump = l_ac1
               LET g_no_ask = TRUE  
               IF g_rec_b1 >0 THEN
                   CALL t003_fetch('/')
               END IF
               CALL cl_set_comp_visible("page_list", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page_list", TRUE)
             END IF
      END CASE
      ## 資料清單(E)
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t003_a()
               LET g_data_keyvalue = g_tc_evad.tc_evad01      
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t003_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t003_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t003_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t003_x()
            END IF

         #履歷
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t003_b2()
            ELSE
               LET g_action_choice = NULL
            END IF

         #零件料號
         WHEN "maintain_part"
            IF cl_chk_act_auth() THEN
               CALL t003_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "output"
            IF cl_chk_act_auth() THEN
               LET l_wc='tc_evad01="',g_tc_evad.tc_evad01,'"'
               LET g_msg = "cpmr300",
                   " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' '' '1'",
                   " '",l_wc CLIPPED,"' "
               CALL cl_cmdrun(g_msg)
            END IF

         WHEN "apji100"
           IF cl_chk_act_auth() THEN
              LET g_cmd = "apji100"
              CALL cl_cmdrun_wait(g_cmd)
           END IF
            
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "confirm"
            IF cl_chk_act_auth() THEN             
               CALL t003_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t003_y_upd()       #CALL 原確認的 update 段
               END IF
               CALL t003_show() #圖示  
            END IF
 
         WHEN "undo_mass"
            IF cl_chk_act_auth() THEN
               CALL t003_unconfirm()
               CALL t003_show() 
            END IF
            
        WHEN "agree"                                       #執行EF簽核,"准"功能
           IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
              CALL t003_y_upd()                            #CALL 原確認的 update 段
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
                       CALL t003_q()
                       #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                       CALL aws_efapp_flowaction("insert, modify, delete, detail, query, locale, fin, undo_fin, undo_mass, easyflow_approval")  #CHI-D20030 add undo_void
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
                    LET g_tc_evad.tc_evad13 = 'R'                   #顯示狀態碼為'R' 送簽退回
                    DISPLAY BY NAME g_tc_evad.tc_evad13
                 END IF
                 IF cl_confirm('aws-081') THEN                      #詢問是否繼續下一筆資料的簽核
                    IF aws_efapp_getnextforminfo() THEN             #取得下一筆簽核單號
                       LET l_flowuser = 'N'
                       LET g_argv1 = aws_efapp_wsk(1)               #取得單號
                       IF NOT cl_null(g_argv1) THEN                 #自動query帶出資料
                          CALL t003_q()
                          #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete,  detail, query, locale, fin, undo_fin,  undo_mass, easyflow_approval")  #CHI-D20030 add undo_void
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
                CALL t003_ef()
           END IF 

            
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
                LET w = ui.Window.getCurrent()
              LET f = w.getForm()
              LET l_node = f.findNode("Table","s_tc_evae")
               CASE 
                 WHEN (g_action_flag IS NULL) OR (g_action_flag = 'main')
                   CALL  cl_export_to_excel(l_node,base.TypeInfo.create(g_tc_evae),'','')
                 WHEN (g_action_flag = 'page_list')
                     LET page = f.FindNode("Page","page_list")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_evad_l),'','')
                 END CASE
                 LET g_action_choice = NULL
            END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_evad.tc_evad01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_evad01"
                 LET g_doc.value1 = g_tc_evad.tc_evad01
                 CALL cl_doc()
               END IF
         END IF
         WHEN "fin"
            IF cl_chk_act_auth() THEN
               CALL t003_v(1)  
               CALL t003_show_pic() 
            END IF
         WHEN "undo_fin"
            IF cl_chk_act_auth() THEN
               CALL t003_v(2)   
               CALL t003_show_pic()
            END IF
         WHEN "gen_qc"
            IF cl_chk_act_auth() THEN
               LET g_cmd = "cqcp002 '",g_tc_evae[l_ac].rvb01,"' "
               CALL cl_cmdrun_wait(g_cmd)
            END IF
         WHEN "qry_qc" #查詢QC單
            IF cl_chk_act_auth() THEN
               LET g_cmd = "aqct110 '",g_tc_evae[l_ac].rvb01,"' "         #20221024
               #LET g_wc = " qcs10 = '",g_tc_evad.tc_evad01,"' "          #20221024
               #LET g_cmd = 'p_query "tqrcqc0001" "',g_wc CLIPPED,'"'     #20221024
               CALL cl_cmdrun_wait(g_cmd)
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t003_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_evae TO s_tc_evae.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()    

      CALL t003_icon() 

      ON ACTION page_list
         LET g_action_flag="page_list"
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
         CALL t003_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t003_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION jump
         CALL t003_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION next
         CALL t003_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL t003_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
         
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY

      ON ACTION apji100
         LET g_action_choice="apji100"
         EXIT DISPLAY
 
      ON ACTION maintain_part
         LET g_action_choice="maintain_part"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac2 = 1
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
 
      #ON ACTION confirm     
      #   LET g_action_choice="confirm"
      #   EXIT DISPLAY
 
      ON ACTION undo_mass  
         LET g_action_choice="undo_mass"
         EXIT DISPLAY         
      ON ACTION fin
         LET g_action_choice="fin"
         EXIT DISPLAY
      ON ACTION undo_fin
         LET g_action_choice="undo_fin"
         EXIT DISPLAY

      ON ACTION gen_qc
         LET g_action_choice="gen_qc"
         EXIT DISPLAY
      ON ACTION qry_qc
         LET g_action_choice="qry_qc"
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
 
FUNCTION t003_bp_refresh()
  DISPLAY ARRAY g_tc_evae TO s_tc_evae.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

  DISPLAY ARRAY g_tc_evaf TO s_tc_evaf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t003_a()
   DEFINE li_result   LIKE type_file.num5   
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10  
 
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_evae.clear()
   CALL g_tc_evaf.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_tc_evad.* LIKE tc_evad_file.*             #DEFAULT 設定
   LET g_tc_evad01_t = NULL
   LET g_tc_evad.tc_evad02 = g_today
   LET g_tc_evad.tc_evad12 = 'N'
   LET g_tc_evad.tc_evad13 = 0  
   LET g_gen02 = NULL
   LET g_gem02 = NULL
   LET g_pmc03 = NULL
 
   #預設值及將數值類變數清成零
   LET g_tc_evad_t.* = g_tc_evad.*
   LET g_tc_evad_o.* = g_tc_evad.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_tc_evad.tc_evaduser=g_user
      LET g_tc_evad.tc_evadoriu = g_user 
      LET g_tc_evad.tc_evadorig = g_grup 
      LET g_data_plant = g_plant
      LET g_tc_evad.tc_evadgrup=g_grup
      LET g_tc_evad.tc_evaddate=g_today
      LET g_tc_evad.tc_evadacti='Y'              #資料有效
      LET g_tc_evad.tc_evadplant = g_plant
      LET g_tc_evad.tc_evadlegal = g_legal 
 
      CALL t003_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_tc_evad.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9003,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_tc_evad.tc_evad01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
 
      INSERT INTO tc_evad_file VALUES (g_tc_evad.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","tc_evad_file",g_tc_evad.tc_evad01,"",SQLCA.sqlcode,"","",1)  #No.FUN-B80100---上移一行調整至回滾事務前--- 
         ROLLBACK WORK     
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_tc_evad.tc_evad01,'I')
      END IF
 
      LET g_tc_evad01_t = g_tc_evad.tc_evad01 
      LET g_tc_evad_t.* = g_tc_evad.*
      LET g_tc_evad_o.* = g_tc_evad.*
      CALL g_tc_evae.clear()
 
      LET g_rec_b = 0
      CALL t003_b()                   #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t003_u()
    
   CALL cl_set_comp_required("tc_evad15",FALSE)
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_evad.tc_evad01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_tc_evad.tc_evad13 = '9' THEN RETURN END IF  
   IF g_tc_evad.tc_evad13 matches '[Ss1]' THEN     
      CALL cl_err("","mfg3557",1)
      LET g_success='N'
      RETURN                                                                                                                        
   END IF

 
   SELECT * INTO g_tc_evad.* FROM tc_evad_file
    WHERE tc_evad01=g_tc_evad.tc_evad01
 
   IF g_tc_evad.tc_evadacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tc_evad.tc_evad01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tc_evad01_t = g_tc_evad.tc_evad01
   BEGIN WORK
 
   OPEN t003_cl USING g_tc_evad.tc_evad01    
   IF STATUS THEN
      CALL cl_err("OPEN t003_cl:", STATUS, 1)
      CLOSE t003_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t003_cl INTO g_tc_evad.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_evad.tc_evad01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t003_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t003_show()
 
   WHILE TRUE
      LET g_tc_evad01_t = g_tc_evad.tc_evad01
      LET g_tc_evad_o.* = g_tc_evad.*
      LET g_tc_evad.tc_evadmodu=g_user
      LET g_tc_evad.tc_evaddate=g_today
 
      CALL t003_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tc_evad.*=g_tc_evad_t.*
         CALL t003_show()
         CALL cl_err('','9003',0)
         EXIT WHILE
      END IF
 
      #LET g_tc_evad.tc_evad13 = '0'  
      #DISPLAY BY NAME g_tc_evad.tc_evad13

      UPDATE tc_evad_file SET tc_evad_file.* = g_tc_evad.*
       WHERE tc_evad01 = g_tc_evad01_t     
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","tc_evad_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t003_cl
   COMMIT WORK
 
   CALL t003_b_fill("1=1")
   CALL t003_b2_fill("1=1")
   CALL t003_bp_refresh()
 
END FUNCTION
 
FUNCTION t003_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,    
   p_cmd     LIKE type_file.chr1    
   DEFINE    li_result   LIKE type_file.num5
   DEFINE    l_sql       STRING
   DEFINE    l_tc_evad06     LIKE tc_evad_file.tc_evad06
   DEFINE    l_cnt       LIKE type_file.num5  
   DEFINE    l_yymm      LIKE tc_evad_file.tc_evad01  
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_tc_evad.tc_evaduser,g_tc_evad.tc_evadmodu,
       g_tc_evad.tc_evadgrup,g_tc_evad.tc_evaddate,g_tc_evad.tc_evadacti
   IF p_cmd = 'a' THEN    
      DISPLAY g_gen02 TO gen02
      DISPLAY g_gem02 TO gem02       
   END IF
   CALL cl_set_head_visible("","YES")         
   INPUT BY NAME g_tc_evad.tc_evad02,g_tc_evad.tc_evad03,g_tc_evad.tc_evad04,
                 g_tc_evad.tc_evad05,g_tc_evad.tc_evad06,g_tc_evad.tc_evad07,g_tc_evad.tc_evad08,
                 g_tc_evad.tc_evad09,g_tc_evad.tc_evad10,g_tc_evad.tc_evad11,
                 g_tc_evad.tc_evad12,g_tc_evad.tc_evad13,
                 g_tc_evad.tc_evad14,g_tc_evad.tc_evad15,g_tc_evad.tc_evad16                               
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t003_set_entry(p_cmd)
         CALL t003_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("tc_evad01")


      AFTER FIELD tc_evad02
         IF cl_null(g_tc_evad.tc_evad02) THEN
            NEXT FIELD tc_evad02
         ELSE
            LET l_yymm = YEAR(g_tc_evad.tc_evad02) USING "&&&&" CLIPPED,MONTH(g_tc_evad.tc_evad02) USING "&&"
            LET l_yymm = l_yymm[3,6]
            IF cl_null(g_tc_evad.tc_evad01) AND p_cmd = 'a' THEN
              #SELECT to_number(to_char(sysdate, 'YYMM'))||MAX(LPAD(NVL(SUBSTR(tc_evad01,5,7),'0')+1,3,'0'))
               SELECT MAX(LPAD(NVL(SUBSTR(tc_evad01,5,7),'0')+1,3,'0'))
                 INTO g_tc_evad.tc_evad01
                 FROM dual
                #LEFT JOIN tc_evad_file ON SUBSTR(tc_evad01,1,4) = to_number(to_char(sysdate, 'YYMM'))
                 LEFT JOIN tc_evad_file ON SUBSTR(tc_evad01,1,4) = l_yymm
               LET g_tc_evad.tc_evad01 = l_yymm CLIPPED,g_tc_evad.tc_evad01
               DISPLAY BY NAME g_tc_evad.tc_evad01
            END IF
         END IF
 
      AFTER FIELD tc_evad03                
         IF NOT cl_null(g_tc_evad.tc_evad03) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt 
              FROM gen_file
             WHERE gen01 = g_tc_evad.tc_evad03
               AND genacti ='Y'
            IF l_cnt <= 0 THEN
               CALL cl_err('','aap-038',0)
               NEXT FIELD tc_evad03
            END IF     
            LET g_gen02 = NULL
            SELECT gen02,gen03 INTO g_gen02,g_tc_evad.tc_evad04 FROM gen_file
             WHERE gen01 = g_tc_evad.tc_evad03
            DISPLAY g_gen02 TO gen02
            DISPLAY g_tc_evad.tc_evad04 TO tc_evad04
         END IF
 
      AFTER FIELD tc_evad04                
         IF NOT cl_null(g_tc_evad.tc_evad04) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt 
              FROM gem_file
             WHERE gem01 = g_tc_evad.tc_evad04
               AND gemacti ='Y'
            IF l_cnt <= 0 THEN
               CALL cl_err('','aap-039',0)
               NEXT FIELD tc_evad04
            END IF         
            LET g_gem02 = NULL
            SELECT gem02 INTO g_gem02 FROM gem_file
             WHERE gem01 = g_tc_evad.tc_evad04
            DISPLAY g_gem02 TO gem02  
         END IF

      AFTER FIELD tc_evad07

      AFTER FIELD tc_evad14
 
      AFTER FIELD tc_evad06               
         IF NOT cl_null(g_tc_evad.tc_evad06) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt 
              FROM pmc_file
             WHERE pmc01 = g_tc_evad.tc_evad06
               AND pmcacti ='Y'
            IF l_cnt <= 0 THEN
               CALL cl_err('','aap-000',0)
               NEXT FIELD tc_evad06
            END IF         
            LET g_pmc03 = NULL
            SELECT pmc03 INTO g_pmc03 
              FROM pmc_file
             WHERE pmc01 = g_tc_evad.tc_evad06
            DISPLAY g_pmc03 TO pmc03
         END IF    

      AFTER FIELD tc_evad16
         IF NOT cl_null(g_tc_evad.tc_evad16) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt
              FROM pmc_file
             WHERE pmc01 = g_tc_evad.tc_evad16
               AND pmcacti ='Y'
            IF l_cnt <= 0 THEN
               CALL cl_err('','aap-000',0)
               NEXT FIELD tc_evad16
            END IF
            LET g_pmc03 = NULL
            SELECT pmc03 INTO g_pmc03
              FROM pmc_file
             WHERE pmc01 = g_tc_evad.tc_evad16
            DISPLAY g_pmc03 TO pmc03_2
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
                 
            WHEN INFIELD(tc_evad03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_tc_evad.tc_evad03
               CALL cl_create_qry() RETURNING g_tc_evad.tc_evad03
               DISPLAY BY NAME g_tc_evad.tc_evad03
               CALL t003_tc_evad03('d')
               NEXT FIELD tc_evad03                 
 
            WHEN INFIELD(tc_evad04) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = g_tc_evad.tc_evad04
               CALL cl_create_qry() RETURNING g_tc_evad.tc_evad04
               DISPLAY BY NAME g_tc_evad.tc_evad04
               CALL t003_tc_evad04('d')
               NEXT FIELD tc_evad04
 
            WHEN INFIELD(tc_evad06) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc2"
               LET g_qryparam.default1 = g_tc_evad.tc_evad06
               CALL cl_create_qry() RETURNING g_tc_evad.tc_evad06
               DISPLAY BY NAME g_tc_evad.tc_evad06
               CALL t003_tc_evad06('d')
               NEXT FIELD tc_evad06

            WHEN INFIELD(tc_evad16) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc2"
               LET g_qryparam.default1 = g_tc_evad.tc_evad16
               CALL cl_create_qry() RETURNING g_tc_evad.tc_evad16
               DISPLAY BY NAME g_tc_evad.tc_evad16
               CALL t003_tc_evad06('d')
               NEXT FIELD tc_evad16

            WHEN INFIELD(tc_evad14)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_faj03"
               LET g_qryparam.default1 = g_tc_evad.tc_evad14
               CALL cl_create_qry() RETURNING g_tc_evad.tc_evad14
               DISPLAY BY NAME g_tc_evad.tc_evad14
               NEXT FIELD tc_evad14            

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
 
FUNCTION t003_tc_evad03(p_cmd)
   DEFINE l_gen02   LIKE gen_file.gen02,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT gen02 INTO l_gen02 FROM gen_file
    WHERE gen01 = g_tc_evad.tc_evad03
 
   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_gen02 = NULL
   END IF   
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO gen02
   END IF
 
END FUNCTION
 
FUNCTION t003_tc_evad04(p_cmd)  
   DEFINE l_gem02   LIKE gem_file.gem02,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT gem02 INTO l_gem02 FROM gem_file
    WHERE gem01 = g_tc_evad.tc_evad04
 
   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_gem02 = NULL
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO gem02
   END IF
 
END FUNCTION
 
FUNCTION t003_tc_evad06(p_cmd)
   DEFINE l_pmc03   LIKE pmc_file.pmc03,
          l_pmc03_2 LIKE pmc_file.pmc03,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pmc03 INTO l_pmc03 FROM pmc_file
    WHERE pmc01 = g_tc_evad.tc_evad06
 
   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_pmc03 = NULL
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO pmc03
   END IF

   LET g_errno = ' '
   SELECT pmc03 INTO l_pmc03_2 FROM pmc_file
    WHERE pmc01 = g_tc_evad.tc_evad16

   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_pmc03_2 = NULL
   END IF

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03_2 TO pmc03_2
   END IF
 
END FUNCTION

FUNCTION t003_tc_evad14(p_cmd)
   DEFINE l_faf02   LIKE faf_file.faf02,
          p_cmd     LIKE type_file.chr1

   LET g_errno = ' '
   SELECT faf02 INTO l_faf02 FROM faj_file,faf_file
    WHERE faj02 = g_tc_evad.tc_evad14
      AND faj21 = faf01

   IF SQLCA.SQLCODE = 100  THEN
      LET g_errno = 'mfg3008'
      LET l_faf02 = NULL
   END IF

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_faf02 TO faf02
   END IF

END FUNCTION
 
FUNCTION t003_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_msg("")  
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tc_evae.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t003_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_tc_evad.* TO NULL
      RETURN
   END IF
 
   OPEN t003_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_evad.* TO NULL
   ELSE
      OPEN t003_count
      FETCH t003_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t003_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t003_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1            
 
   CASE p_flag

      WHEN 'N' FETCH NEXT     t003_cs INTO g_tc_evad.tc_evad01               
      WHEN 'P' FETCH PREVIOUS t003_cs INTO g_tc_evad.tc_evad01               
      WHEN 'F' FETCH FIRST    t003_cs INTO g_tc_evad.tc_evad01               
      WHEN 'L' FETCH LAST     t003_cs INTO g_tc_evad.tc_evad01               
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
            FETCH ABSOLUTE g_jump t003_cs INTO g_tc_evad.tc_evad01                   
            LET g_no_ask = FALSE   
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_evad.tc_evad01,SQLCA.sqlcode,0)
      INITIALIZE g_tc_evad.* TO NULL             
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
 
   SELECT * INTO g_tc_evad.* FROM tc_evad_file WHERE tc_evad01 = g_tc_evad.tc_evad01  
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","tc_evad_file","","",SQLCA.sqlcode,"","",1) 
      INITIALIZE g_tc_evad.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_tc_evad.tc_evaduser      
   LET g_data_group = g_tc_evad.tc_evadgrup    
   LET g_data_plant = g_tc_evad.tc_evadplant   
   LET g_data_keyvalue = g_tc_evad.tc_evad01   
   CALL t003_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t003_show()
   DEFINE l_sum_total    LIKE pmn_file.pmn88
   DEFINE w              ui.Window
   DEFINE n              om.DomNode 
   DEFINE l_cnt          LIKE type_file.num5

   IF g_tc_evad.tc_evad13='1' AND g_tc_evad.tc_evad12='N' THEN
      LET g_tc_evad.tc_evad12= 'Y' 
      UPDATE tc_evad_file set tc_evad12='Y' WHERE tc_evad01 = g_tc_evad.tc_evad01
   END IF
 
   LET g_tc_evad_t.* = g_tc_evad.*                #保存單頭舊值
   LET g_tc_evad_o.* = g_tc_evad.*                #保存單頭舊值
   LET g_data_keyvalue = g_tc_evad.tc_evad01      #No:FUN-F50036
   DISPLAY BY NAME g_tc_evad.tc_evad01,g_tc_evad.tc_evad02,g_tc_evad.tc_evad03, g_tc_evad.tc_evadoriu,g_tc_evad.tc_evadorig,
                   g_tc_evad.tc_evad04,g_tc_evad.tc_evad05,g_tc_evad.tc_evad07,g_tc_evad.tc_evad10,g_tc_evad.tc_evad11,
                   g_tc_evad.tc_evad09,g_tc_evad.tc_evad06,g_tc_evad.tc_evad08,  
                   g_tc_evad.tc_evad12,g_tc_evad.tc_evad13,g_tc_evad.tc_evad06,g_tc_evad.tc_evad14,g_tc_evad.tc_evad15,
                   g_tc_evad.tc_evad16,
                   g_tc_evad.tc_evaduser,g_tc_evad.tc_evadgrup,g_tc_evad.tc_evadmodu,
                   g_tc_evad.tc_evaddate,g_tc_evad.tc_evadacti
   
   #--- 成本
   SELECT sum(distinct pmn88) INTO l_sum_total
     FROM tc_evae_file,pmn_file
    WHERE tc_evae05=pmn01 AND tc_evae06=pmn02
      AND tc_evae01 = g_tc_evad.tc_evad01 
   GROUP BY tc_evae05,tc_evae06 

   IF cl_null(l_sum_total) THEN LET l_sum_total=0 END IF
   DISPLAY l_sum_total TO sum_total
                  
   CALL t003_tc_evad03('d')
   CALL t003_tc_evad04('d')
   CALL t003_tc_evad06('d')                    
   CALL t003_tc_evad14('d')                    
 
   CALL t003_b_fill(g_wc2)                 #單身
   CALL t003_b2_fill(g_wc3)                 #單身
   CALL t003_icon()
   CALL t003_bp_refresh()
   CALL t003_show_pic() #圖示  
   CALL cl_show_fld_cont()              
END FUNCTION
 
FUNCTION t003_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_evad.tc_evad01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_tc_evad.tc_evad13 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      LET g_success='N' RETURN
   END IF   
   BEGIN WORK
 
   OPEN t003_cl USING g_tc_evad.tc_evad01   
   IF STATUS THEN
      CALL cl_err("OPEN t003_cl:", STATUS, 1)
      CLOSE t003_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t003_cl INTO g_tc_evad.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_evad.tc_evad01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t003_show()
 
   IF cl_exp(0,0,g_tc_evad.tc_evadacti) THEN                   #確認一下
      LET g_chr=g_tc_evad.tc_evadacti
      IF g_tc_evad.tc_evadacti='Y' THEN
         LET g_tc_evad.tc_evadacti='N'
      ELSE
         LET g_tc_evad.tc_evadacti='Y'
      END IF
 
      UPDATE tc_evad_file SET tc_evadacti=g_tc_evad.tc_evadacti,
                          tc_evadmodu=g_user,
                          tc_evaddate=g_today
       WHERE tc_evad01=g_tc_evad.tc_evad01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tc_evad_file",g_tc_evad.tc_evad01,"",SQLCA.sqlcode,"","",1)  
         LET g_tc_evad.tc_evadacti=g_chr
      END IF
   END IF
 
   CLOSE t003_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_tc_evad.tc_evad01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT tc_evadacti,tc_evadmodu,tc_evaddate
     INTO g_tc_evad.tc_evadacti,g_tc_evad.tc_evadmodu,g_tc_evad.tc_evaddate FROM tc_evad_file
    WHERE tc_evad01=g_tc_evad.tc_evad01
   DISPLAY BY NAME g_tc_evad.tc_evadacti,g_tc_evad.tc_evadmodu,g_tc_evad.tc_evaddate
 
END FUNCTION
 
FUNCTION t003_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_evad.tc_evad01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
  
   IF g_tc_evad.tc_evad13 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      LET g_success='N' 
      RETURN
   END IF   
 
   SELECT * INTO g_tc_evad.* FROM tc_evad_file
    WHERE tc_evad01=g_tc_evad.tc_evad01
 
   BEGIN WORK
 
   OPEN t003_cl USING g_tc_evad.tc_evad01  
   IF STATUS THEN
      CALL cl_err("OPEN t003_cl:", STATUS, 1)
      CLOSE t003_cl
      ROLLBACK WORK
  
      RETURN
   END IF
 
   FETCH t003_cl INTO g_tc_evad.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_evad.tc_evad01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t003_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL         
       LET g_doc.column1 = "tc_evad01"         
       LET g_doc.value1 = g_tc_evad.tc_evad01     
       CALL cl_del_doc()                
      DELETE FROM tc_evad_file WHERE tc_evad01 = g_tc_evad.tc_evad01
      DELETE FROM tc_evae_file WHERE tc_evae01 = g_tc_evad.tc_evad01
      DELETE FROM tc_evaf_file WHERE tc_evaf01 = g_tc_evad.tc_evad01
      CLEAR FORM
      CALL g_tc_evae.clear()
      OPEN t003_count
      IF STATUS THEN
         CLOSE t003_cs  
         CLOSE t003_count
         COMMIT WORK
         RETURN
      END IF
      FETCH t003_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t003_cs  
         CLOSE t003_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t003_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t003_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE   
         CALL t003_fetch('/')
      END IF
   END IF
 
   CLOSE t003_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tc_evad.tc_evad01,'D')
END FUNCTION
 
#單身
FUNCTION t003_b()
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
DEFINE l_tc_evad06   LIKE tc_evad_file.tc_evad06
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_tc_evad.tc_evad01 IS NULL THEN
       RETURN
    END IF
 
 
    IF g_tc_evad.tc_evad13 ='9' THEN RETURN END IF  
    IF g_tc_evad.tc_evad13 matches '[Ss1]' THEN     
    #   CALL cl_err("","mfg3557",1) 
    #   LET g_success='N' 
    #   RETURN
    END IF    

 
    SELECT * INTO g_tc_evad.* FROM tc_evad_file
     WHERE tc_evad01=g_tc_evad.tc_evad01
 
    IF g_tc_evad.tc_evadacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_tc_evad.tc_evad01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_evae02,tc_evae03,'','',tc_evae04,tc_evae05,tc_evae06,tc_evae07",
                       "  FROM tc_evae_file",
                       " WHERE tc_evae01=? AND tc_evae02=? AND tc_evae03=? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t003_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tc_evae WITHOUT DEFAULTS FROM s_tc_evae.*
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
 
           OPEN t003_cl USING g_tc_evad.tc_evad01  
           IF STATUS THEN
              CALL cl_err("OPEN t003_cl:", STATUS, 1)
              CLOSE t003_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t003_cl INTO g_tc_evad.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tc_evad.tc_evad01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t003_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_tc_evae_t.* = g_tc_evae[l_ac].*  #BACKUP
              LET g_tc_evae_o.* = g_tc_evae[l_ac].*  #BACKUP
              OPEN t003_bcl USING g_tc_evad.tc_evad01,g_tc_evae_t.tc_evae02,g_tc_evae_t.tc_evae03
              IF STATUS THEN
                 CALL cl_err("OPEN t003_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t003_bcl INTO g_tc_evae[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_evae_t.tc_evae02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t003_tc_evae03('d')                 
              CALL cl_show_fld_cont()     
              END IF
           END IF 
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_evae[l_ac].* TO NULL        
           LET g_tc_evae_t.* = g_tc_evae[l_ac].*        
           LET g_tc_evae_o.* = g_tc_evae[l_ac].*        
           CALL cl_show_fld_cont()         
           NEXT FIELD tc_evae02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9003,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO tc_evae_file(tc_evae01,tc_evae02,tc_evae03,tc_evae04,tc_evae05,tc_evae06,
                                tc_evaeplant,tc_evaelegal,tc_evae07)  
           VALUES(g_tc_evad.tc_evad01,g_tc_evae[l_ac].tc_evae02,
                  g_tc_evae[l_ac].tc_evae03,g_tc_evae[l_ac].tc_evae04,
                  g_tc_evae[l_ac].tc_evae05,g_tc_evae[l_ac].tc_evae06,
                  g_plant,g_legal,g_tc_evae[l_ac].tc_evae07)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_evae_file",g_tc_evad.tc_evad01,g_tc_evae[l_ac].tc_evae02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

        BEFORE FIELD tc_evae02
           IF cl_null(g_tc_evae[l_ac].tc_evae02) AND l_ac>1 THEN
              LET g_tc_evae[l_ac].tc_evae02 = g_tc_evae[l_ac-1].tc_evae02
              DISPLAY BY NAME g_tc_evae[l_ac].tc_evae02
           END IF
           
        AFTER FIELD tc_evae03
           IF cl_null(g_tc_evae[l_ac].tc_evae02) THEN
              NEXT FIELD tc_evae02
           END IF                                  
           IF NOT cl_null(g_tc_evae[l_ac].tc_evae03) THEN
              LET l_n1 = 0
              SELECT COUNT(*) INTO l_n1 FROM ima_file
               WHERE ima01 = g_tc_evae[l_ac].tc_evae03
                 AND ima08<>'Z'
              IF l_n1 = 0 THEN
                 CALL cl_err('','mfg0002',0)
                 NEXT FIELD tc_evae03
              END IF
              CALL t003_tc_evae03('d') 
           END IF

        BEFORE FIELD tc_evae04
           IF cl_null(g_tc_evae[l_ac].tc_evae04) THEN
              IF l_ac>1 THEN
                 LET g_tc_evae[l_ac].tc_evae04=g_tc_evae[l_ac-1].tc_evae04
                 DISPLAY BY NAME g_tc_evae[l_ac].tc_evae04
              END IF
           END IF  
 
        BEFORE FIELD tc_evae05
           IF l_ac > 1 THEN
              IF cl_null(g_tc_evae[l_ac].tc_evae05)
                 AND (g_tc_evae[l_ac].tc_evae02=g_tc_evae[l_ac-1].tc_evae02)  THEN
                 LET g_tc_evae[l_ac].tc_evae05 = g_tc_evae[l_ac-1].tc_evae05
              END IF 
           END IF
                      
        BEFORE DELETE                     
           DISPLAY "BEFORE DELETE"
           IF g_tc_evae_t.tc_evae02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM tc_evae_file
               WHERE tc_evae01 = g_tc_evad.tc_evad01
                 AND tc_evae02 = g_tc_evae[l_ac].tc_evae02
                 AND tc_evae03 = g_tc_evae[l_ac].tc_evae03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_evae_file",g_tc_evad.tc_evad01,g_tc_evae_t.tc_evae02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9003,0)
              LET INT_FLAG = 0
              LET g_tc_evae[l_ac].* = g_tc_evae_t.*
              CLOSE t003_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_evae[l_ac].tc_evae02,-263,1)
              LET g_tc_evae[l_ac].* = g_tc_evae_t.*
           ELSE
              UPDATE tc_evae_file SET tc_evae02=g_tc_evae[l_ac].tc_evae02,
                                  tc_evae03=g_tc_evae[l_ac].tc_evae03,
                                  tc_evae04=g_tc_evae[l_ac].tc_evae04,
                                  tc_evae05=g_tc_evae[l_ac].tc_evae05,
                                  tc_evae06=g_tc_evae[l_ac].tc_evae06,                                 
                                  tc_evae07=g_tc_evae[l_ac].tc_evae07                                
               WHERE tc_evae01=g_tc_evad.tc_evad01
                 AND tc_evae02=g_tc_evae[l_ac].tc_evae02
                 AND tc_evae03=g_tc_evae[l_ac].tc_evae03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tc_evae_file",g_tc_evad.tc_evad01,g_tc_evae_t.tc_evae02,SQLCA.sqlcode,"","",1)
                 LET g_tc_evae[l_ac].* = g_tc_evae_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9003,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_tc_evae[l_ac].* = g_tc_evae_t.*
              ELSE
                 CALL g_tc_evae.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              END IF
              CLOSE t003_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  
           CLOSE t003_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tc_evae02) AND l_ac > 1 THEN
              LET g_tc_evae[l_ac].* = g_tc_evae[l_ac-1].*
              LET g_tc_evae[l_ac].tc_evae02 = g_rec_b + 1
              NEXT FIELD tc_evae02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
           
        ON ACTION CONTROLP
           CASE           
            WHEN INFIELD(tc_evae03) 
              CALL q_sel_ima(FALSE, "q_ima", "", "" , "", "", "", "" ,"",'' )  RETURNING g_tc_evae[l_ac].tc_evae03 
              CALL t003_tc_evae03('d')
              NEXT FIELD tc_evae03
            WHEN INFIELD(tc_evae05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_pmn01"
              CALL cl_create_qry() RETURNING g_tc_evae[l_ac].tc_evae05,g_tc_evae[l_ac].tc_evae06
              DISPLAY BY NAME g_tc_evae[l_ac].tc_evae05
              DISPLAY BY NAME g_tc_evae[l_ac].tc_evae06
              
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
 
    LET g_tc_evad.tc_evadmodu = g_user
    LET g_tc_evad.tc_evaddate = g_today
    UPDATE tc_evad_file 
       SET tc_evadmodu = g_tc_evad.tc_evadmodu,
           tc_evaddate = g_tc_evad.tc_evaddate,
           tc_evad13 = g_tc_evad.tc_evad13,
           tc_evad12 = g_tc_evad.tc_evad12 
     WHERE tc_evad01 = g_tc_evad.tc_evad01
    DISPLAY BY NAME g_tc_evad.tc_evadmodu,g_tc_evad.tc_evaddate,
                    g_tc_evad.tc_evad13,g_tc_evad.tc_evad12
 
    CLOSE t003_bcl
    COMMIT WORK
    CALL t003_delHeader()
END FUNCTION

FUNCTION t003_b2()
DEFINE
    l_ac2_t          LIKE type_file.num5,              
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
DEFINE l_count   LIKE type_file.num5
DEFINE l_sql     STRING
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_tc_evad.tc_evad01 IS NULL THEN
       RETURN
    END IF
 
 
    IF g_tc_evad.tc_evad13 ='9' THEN RETURN END IF  
    IF g_tc_evad.tc_evad13 matches '[Ss1]' THEN     
    #   CALL cl_err("","mfg3557",1) 
    #   LET g_success='N' 
    #   RETURN
    END IF    

 
    SELECT * INTO g_tc_evad.* FROM tc_evad_file
     WHERE tc_evad01=g_tc_evad.tc_evad01
 
    IF g_tc_evad.tc_evadacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_tc_evad.tc_evad01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_evaf02,tc_evaf03,tc_evaf04,tc_evaf05,tc_evaf06,tc_evaf07,tc_evaf08,tc_evaf09",
                       "  FROM tc_evaf_file",
                       " WHERE tc_evaf01=? AND tc_evaf02=? AND tc_evaf03=? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t003_bcl2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tc_evaf WITHOUT DEFAULTS FROM s_tc_evaf.*
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
           LET l_ac2 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t003_cl USING g_tc_evad.tc_evad01  
           IF STATUS THEN
              CALL cl_err("OPEN t003_cl2:", STATUS, 1)
              CLOSE t003_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t003_cl INTO g_tc_evad.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tc_evad.tc_evad01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t003_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac2 THEN
              LET p_cmd='u'
              LET g_tc_evaf_t.* = g_tc_evaf[l_ac2].*  #BACKUP
        
              OPEN t003_bcl2 USING g_tc_evad.tc_evad01,g_tc_evaf_t.tc_evaf02,g_tc_evaf_t.tc_evaf03
              IF STATUS THEN
                 CALL cl_err("OPEN t003_bcl2:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t003_bcl2 INTO g_tc_evaf[l_ac2].*
                 IF SQLCA.sqlcode THEN
                    #CALL cl_err(g_tc_evaf_t.tc_evaf02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                             
              CALL cl_show_fld_cont()     
              END IF
           END IF 
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_evaf[l_ac2].* TO NULL        
           LET g_tc_evaf_t.* = g_tc_evaf[l_ac2].*        
           CALL cl_show_fld_cont()         
           NEXT FIELD tc_evaf02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9003,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO tc_evaf_file(tc_evaf01,tc_evaf02,tc_evaf03,tc_evaf04,tc_evaf05,tc_evaf06,
                                    tc_evaf07,tc_evaf08,tc_evaf09,
                                    tc_evafplant,tc_evaflegal)  
           VALUES(g_tc_evad.tc_evad01,g_tc_evaf[l_ac2].tc_evaf02,
                  g_tc_evaf[l_ac2].tc_evaf03,g_tc_evaf[l_ac2].tc_evaf04,
                  g_tc_evaf[l_ac2].tc_evaf05,g_tc_evaf[l_ac2].tc_evaf06,
                  g_tc_evaf[l_ac2].tc_evaf07,g_tc_evaf[l_ac2].tc_evaf08,g_tc_evaf[l_ac2].tc_evaf09,
                  g_plant,g_legal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_evaf_file",g_tc_evad.tc_evad01,g_tc_evaf[l_ac2].tc_evaf02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

        BEFORE FIELD tc_evaf02
          IF cl_null(g_tc_evaf[l_ac2].tc_evaf02) THEN
             SELECT MAX(tc_evae02) INTO g_tc_evaf[l_ac2].tc_evaf02
               FROM tc_evae_file
               WHERE tc_evae01 = g_tc_evad.tc_evad01
          END IF
             
        BEFORE FIELD tc_evaf03
           IF cl_null(g_tc_evaf[l_ac2].tc_evaf03) THEN
              SELECT MAX(tc_evaf03)+1 INTO g_tc_evaf[l_ac2].tc_evaf03
                FROM tc_evaf_file
                WHERE tc_evaf01 = g_tc_evad.tc_evad01
              IF cl_null(g_tc_evaf[l_ac2].tc_evaf03) THEN
                 LET g_tc_evaf[l_ac2].tc_evaf03 = 1
              END IF
           END IF

        AFTER FIELD tc_evaf04
           IF NOT cl_null(g_tc_evaf[l_ac2].tc_evaf04) THEN
              SELECT pje02 INTO g_tc_evaf_t.tc_evaf05
                FROM pje_file
               WHERE pje01 = g_tc_evaf[l_ac2].tc_evaf04
              IF cl_null(g_tc_evaf_t.tc_evaf05) THEN
                 NEXT FIELD tc_evaf04
              END IF
           END IF

        BEFORE FIELD tc_evaf05
           IF cl_null(g_tc_evaf[l_ac2].tc_evaf05) THEN
              LET g_tc_evaf[l_ac2].tc_evaf05 =g_tc_evaf_t.tc_evaf05
           END IF
                      

        BEFORE FIELD tc_evaf06

        AFTER FIELD tc_evaf07
           IF cl_null(g_tc_evaf[l_ac2].tc_evaf07) THEN
              NEXT FIELD tc_evaf07
           ELSE
              IF g_tc_evaf[l_ac2].tc_evaf07 < g_tc_evaf[l_ac2].tc_evaf06 THEN
                 NEXT FIELD tc_evaf07
              END IF
           END IF
                      
        BEFORE DELETE                     
           DISPLAY "BEFORE DELETE"
           IF g_tc_evaf_t.tc_evaf02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM tc_evaf_file
               WHERE tc_evaf01 = g_tc_evad.tc_evad01
                 AND tc_evaf02 = g_tc_evaf_t.tc_evaf02
                 AND tc_evaf03 = g_tc_evaf_t.tc_evaf03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_evaf_file",g_tc_evad.tc_evad01,g_tc_evaf_t.tc_evaf02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9003,0)
              LET INT_FLAG = 0
              LET g_tc_evaf[l_ac].* = g_tc_evaf_t.*
              CLOSE t003_bcl2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_evaf[l_ac].tc_evaf02,-263,1)
              LET g_tc_evaf[l_ac2].* = g_tc_evaf_t.*
           ELSE
              UPDATE tc_evaf_file SET tc_evaf02=g_tc_evaf[l_ac2].tc_evaf02,
                                  tc_evaf03=g_tc_evaf[l_ac2].tc_evaf03,
                                  tc_evaf04=g_tc_evaf[l_ac2].tc_evaf04,
                                  tc_evaf05=g_tc_evaf[l_ac2].tc_evaf05,
                                  tc_evaf06=g_tc_evaf[l_ac2].tc_evaf06,   
                                  tc_evaf07=g_tc_evaf[l_ac2].tc_evaf07,  
                                  tc_evaf08=g_tc_evaf[l_ac2].tc_evaf08,                              
                                  tc_evaf09=g_tc_evaf[l_ac2].tc_evaf09                              
               WHERE tc_evaf01=g_tc_evad.tc_evad01
                 AND tc_evaf02=g_tc_evaf_t.tc_evaf02
                 AND tc_evaf03=g_tc_evaf_t.tc_evaf03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tc_evaf_file",g_tc_evad.tc_evad01,g_tc_evaf_t.tc_evaf02,SQLCA.sqlcode,"","",1)
                 LET g_tc_evaf[l_ac2].* = g_tc_evaf_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac2 = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9003,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_tc_evaf[l_ac2].* = g_tc_evaf_t.*
              ELSE
                 CALL g_tc_evaf.deleteElement(l_ac2)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac2 = l_ac2_t
                 END IF
              END IF
              CLOSE t003_bcl2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac2_t = l_ac2  
           CLOSE t003_bcl2
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tc_evaf02) AND l_ac2 > 1 THEN
              LET g_tc_evaf[l_ac2].* = g_tc_evaf[l_ac2-1].*
              LET g_tc_evaf[l_ac2].tc_evaf02 = g_rec_b + 1
              NEXT FIELD tc_evaf02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
           
        ON ACTION CONTROLP
           CASE           
            WHEN INFIELD(tc_evaf04)
              CALL cl_init_qry_var()
               LET g_qryparam.form ="cq_pje01"
               CALL cl_create_qry() RETURNING g_tc_evaf[l_ac2].tc_evaf04,g_tc_evaf[l_ac2].tc_evaf05
               DISPLAY BY NAME g_tc_evaf[l_ac2].tc_evaf04,g_tc_evaf[l_ac2].tc_evaf05
               NEXT FIELD tc_evaf04
                        
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
 
    LET g_tc_evad.tc_evadmodu = g_user
    LET g_tc_evad.tc_evaddate = g_today
    UPDATE tc_evad_file 
       SET tc_evadmodu = g_tc_evad.tc_evadmodu,
           tc_evaddate = g_tc_evad.tc_evaddate,
           tc_evad13 = g_tc_evad.tc_evad13,
           tc_evad12 = g_tc_evad.tc_evad12 
     WHERE tc_evad01 = g_tc_evad.tc_evad01
    DISPLAY BY NAME g_tc_evad.tc_evadmodu,g_tc_evad.tc_evaddate,
                    g_tc_evad.tc_evad13,g_tc_evad.tc_evad12
 
    CLOSE t003_bcl2
    COMMIT WORK
    CALL t003_delHeader()
END FUNCTION



FUNCTION t003_delHeader()
   DEFINE l_action_choice    STRING               
   DEFINE l_cho              LIKE type_file.num5  
   DEFINE l_num              LIKE type_file.num5  
   DEFINE l_slip             LIKE type_file.chr5  
   DEFINE l_sql              STRING               
   DEFINE l_cnt              LIKE type_file.num5  
   DEFINE l_n                LIKE type_file.num5

   SELECT COUNT(*) INTO l_n FROM tc_evae_file WHERE tc_evae01 = g_tc_evad.tc_evad01

   IF l_n = 0 THEN
      LET l_sql = " SELECT COUNT(*) FROM tc_evad_file ",
                  "  WHERE ",
                  "   tc_evad01 > '",g_tc_evad.tc_evad01,"'"
      PREPARE t003_pb6 FROM l_sql 
      EXECUTE t003_pb6 INTO l_cnt       
      
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
         CALL t003_v(1)  
         CALL t003_show_pic()
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM tc_evad_file WHERE tc_evad01 = g_tc_evad.tc_evad01
         INITIALIZE g_tc_evad.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION

 
FUNCTION t003_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
 
   LET g_sql = "SELECT tc_evae02,tc_evae03,ima02,ima021,tc_evae04,tc_evae05,",
               "       tc_evae06,tc_evae07,'' ",
               "  FROM tc_evae_file,ima_file",
               " WHERE tc_evae03=ima01 ",
               "   AND tc_evae01 ='",g_tc_evad.tc_evad01,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY tc_evae02"
   DISPLAY g_sql
 
   PREPARE t003_pb FROM g_sql
   DECLARE tc_evae_cs CURSOR FOR t003_pb
 
   CALL g_tc_evae.clear()
   LET g_cnt = 1
 
   FOREACH tc_evae_cs INTO g_tc_evae[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       SELECT MAX(rvb01) INTO g_tc_evae[g_cnt].rvb01
         FROM rvb_file,rva_file
        WHERE rva01 = rvb01 
          AND rvaconf = 'Y'
          AND rvb04 = g_tc_evae[g_cnt].tc_evae05
          AND rvb03 = g_tc_evae[g_cnt].tc_evae06
       LET g_tc_evae_t.rvb01 = g_tc_evae[g_cnt].rvb01
          
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_tc_evae.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION

FUNCTION t003_b2_fill(p_wc3)
DEFINE p_wc3   STRING
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
 
   LET g_sql = "SELECT tc_evaf02,tc_evaf03,tc_evaf04,tc_evaf05,",
               " tc_evaf06,tc_evaf07,tc_evaf08,tc_evaf09 ",
               " FROM tc_evaf_file ",
               " WHERE  ",
               "   tc_evaf01 ='",g_tc_evad.tc_evad01,"' "   #單頭
 
   IF NOT cl_null(p_wc3) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc3 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY tc_evaf03 DESC"
   DISPLAY g_sql
 
   PREPARE t003_pb2 FROM g_sql
   DECLARE tc_evaf_cs CURSOR FOR t003_pb2
 
   CALL g_tc_evaf.clear()
   LET g_cnt2 = 1
 
   FOREACH tc_evaf_cs INTO g_tc_evaf[g_cnt2].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       LET g_cnt2 = g_cnt2 + 1
       IF g_cnt2 > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_tc_evaf.deleteElement(g_cnt2)
 
   LET g_rec_b=g_cnt2-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt2 = 0
 
END FUNCTION
 
FUNCTION t003_copy()
   DEFINE l_newno     LIKE tc_evad_file.tc_evad01,
          l_newdate   LIKE tc_evad_file.tc_evad02,
          l_oldno     LIKE tc_evad_file.tc_evad01
   DEFINE li_result   LIKE type_file.num5 
   DEFINE l_slip      LIKE smy_file.smyslip  
   
   IF s_shut(0) THEN RETURN END IF
 
   IF g_tc_evad.tc_evad01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   
   CALL cl_set_head_visible("","YES")           
   INPUT l_newno,l_newdate FROM tc_evad01,tc_evad02
       BEFORE INPUT
          CALL cl_set_docno_format("tc_evad01")
          CALL cl_set_comp_required("tc_evad02",TRUE)    
          CALL cl_set_comp_entry("tc_evad01,tc_evad02",TRUE) 
          LET l_newdate=g_today                     
          DISPLAY l_newdate TO tc_evad02               
 
 
       AFTER FIELD tc_evad02
           IF cl_null(l_newdate) THEN NEXT FIELD tc_evad02 END IF
 
           BEGIN WORK 
           CALL s_auto_assign_no("apm",l_newno,l_newdate,"","tc_evad_file","tc_evad01","","","") RETURNING li_result,l_newno
           IF (NOT li_result) THEN
              NEXT FIELD tc_evad01
           END IF
           DISPLAY l_newno TO tc_evad01
 
       ON ACTION controlp
 
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
        CALL cl_set_comp_required("tc_evad02",FALSE) 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_tc_evad.tc_evad01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM tc_evad_file         #單頭複製
       WHERE tc_evad01=g_tc_evad.tc_evad01
       INTO TEMP y
   CALL s_get_doc_no(l_newno) RETURNING l_slip
   UPDATE y
       SET tc_evad01=l_newno,    #新的鍵值
           tc_evad02=l_newdate,  
           tc_evaduser=g_user,   #資料所有者
           tc_evadgrup=g_grup,   #資料所有者所屬群
           tc_evadmodu=NULL,     #資料修改日期
           tc_evaddate=g_today,  #資料建立日期
           tc_evadacti='Y',      #有效資料
           tc_evad13='0'        #狀況碼  
 
   INSERT INTO tc_evad_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","tc_evad_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM tc_evae_file         #單身複製
       WHERE tc_evae01=g_tc_evad.tc_evad01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET tc_evae01=l_newno
 
   INSERT INTO tc_evae_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","tc_evae_file","","",SQLCA.sqlcode,"","",1)    #上移一行調整至回滾事務前---
      ROLLBACK WORK 
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_tc_evad.tc_evad01
   SELECT tc_evad_file.* INTO g_tc_evad.* FROM tc_evad_file WHERE tc_evad01 = l_newno                      
   CALL t003_u()
   CALL t003_b2()
 
END FUNCTION


FUNCTION t003_y_chk()
  DEFINE l_n      LIKE type_file.num5  
  
    LET g_success = 'Y'
 
    IF g_tc_evad.tc_evad01 IS NULL THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       RETURN
    END IF
    IF g_tc_evad.tc_evad13 = '9' THEN 
       LET g_success = 'N'
       RETURN 
    END IF

    IF g_tc_evad.tc_evad12 = '1' THEN  #已核准
       CALL cl_err('','mfg3212',1)
       LET g_success = 'N'
       RETURN
    END IF

    IF g_tc_evad.tc_evadacti = 'N' THEN  #本筆資料無效
       CALL cl_err('','abm-889',1)
       LET g_success = 'N'
       RETURN
    END IF
    IF g_action_choice CLIPPED = "confirm" OR  #執行 "確認" 功能(非簽核模式呼叫)
       g_action_choice CLIPPED = "insert"
    THEN
       IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF  #詢問是否執行確認功能 
    END IF

END FUNCTION

FUNCTION t003_y_upd()
  DEFINE i         LIKE type_file.num5
  DEFINE l_cnt     LIKE type_file.num5
  DEFINE c_tc_evad09   LIKE tc_evad_file.tc_evad09
  DEFINE c_tc_evad06   LIKE tc_evad_file.tc_evad06  
  DEFINE c_tc_evae02   LIKE tc_evae_file.tc_evae02
  DEFINE c_tc_evae03   LIKE tc_evae_file.tc_evae03  
  DEFINE c_tc_evae04   LIKE tc_evae_file.tc_evae04  

    LET g_success = 'Y'
    LET g_flag = 'Y' 

    IF g_action_choice CLIPPED = "confirm" OR  #執行 "確認" 功能(非簽核模式呼叫)
       g_action_choice CLIPPED = "insert"    
    THEN
       IF g_tc_evad.tc_evad13 != '1' THEN
          CALL cl_err('','aws-078',1)  #此狀況碼不為「1.已核准」，不可確認!!
          LET g_success = 'N'
          RETURN
       END IF
    END IF

    BEGIN WORK

    IF g_success = 'Y' THEN
          CASE aws_efapp_formapproval()  #呼叫EF簽核功能
             WHEN 0  #呼叫EasyFlow簽核失敗
                LET g_success = "N"
                ROLLBACK WORK
                RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                ROLLBACK WORK
                RETURN
          END CASE
   
       IF g_success = 'Y' THEN
          LET g_tc_evad.tc_evad13 = '1'  #執行成功，狀態值顯示為'1'已核准
          LET g_tc_evad.tc_evad12 = 'Y'
          UPDATE tc_evad_file SET tc_evad13 = '1',tc_evad12='Y'
           WHERE tc_evad01 = g_tc_evad.tc_evad01
          DISPLAY BY NAME g_tc_evad.tc_evad13   
          DISPLAY BY NAME g_tc_evad.tc_evad12  
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
 
FUNCTION t003_unconfirm()
  DEFINE l_cnt     LIKE type_file.num5

   
    LET g_success = 'Y' 
    LET g_flag ='Y'                
   
    IF g_tc_evad.tc_evad13 = '9' THEN RETURN END IF 
    IF g_tc_evad.tc_evad13 = 'S' THEN
       #送簽中, 不可修改資料!
       CALL cl_err(g_tc_evad.tc_evad13,'apm-030',1)
       RETURN
    END IF
    #非審核狀態 不能取消審核
    IF g_tc_evad.tc_evad13 <> '1' THEN
       CALL  cl_err('','atm-053',1)
       RETURN
    END IF
    
    IF NOT cl_confirm('axm-109') THEN RETURN END IF

    #- 已有財編不可取消確認
    #IF NOT cl_null(g_tc_evad.tc_evad14) THEN
    #    CALL  cl_err('','apm-515',1)
    #   RETURN
    #END IF

    UPDATE tc_evad_file SET tc_evad13='0',tc_evad12='N' 
     WHERE tc_evad01 = g_tc_evad.tc_evad01

    SELECT * INTO g_tc_evad.* FROM tc_evad_file WHERE tc_evad01 = g_tc_evad.tc_evad01
    
END FUNCTION
 
FUNCTION t003_ef()                                                                                                                  
     CALL t003_y_chk()  #CALL 原確認段的check段後在執行送簽
     IF g_success = 'N' THEN                                                                                                        
        RETURN                                                                                                                     
     END IF                                                                                                                         

     IF g_tc_evad.tc_evadacti = 'N' THEN
        CALL cl_err('','abm-885',1)
        LET g_success = 'N'
        RETURN
     END IF
     IF g_tc_evad.tc_evad13 = '1' OR g_tc_evad.tc_evad13 = 'S' THEN     
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
                                                                                                                
 IF aws_efcli2(base.TypeInfo.create(g_tc_evad),base.TypeInfo.create(g_tc_evae),'','','','')                        
 THEN
   LET g_success='Y'                                                                                                   
  #重新更新狀態碼顯示
   SELECT tc_evad13 INTO g_tc_evad.tc_evad13 FROM tc_evad_file WHERE tc_evad01 = g_tc_evad.tc_evad01
   DISPLAY BY NAME g_tc_evad.tc_evad13
 ELSE                                                                                                                               
   LET g_success='N'                                                                                                                
 END IF                                                                                                                             
                                                                                                                                    
END FUNCTION 
 
FUNCTION t003_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tc_evad01",TRUE)
   END IF   
END FUNCTION
 
FUNCTION t003_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("tc_evad01",FALSE)
   END IF
END FUNCTION
 
 
FUNCTION t003_tc_evae03(p_cmd)       
 
DEFINE  p_cmd   LIKE type_file.chr1   
 
   LET g_errno = " "
   SELECT ima02,ima021 INTO g_tc_evae[l_ac].ima02,g_tc_evae[l_ac].ima021
     FROM ima_file
    WHERE ima01 = g_tc_evae[l_ac].tc_evae03
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE   
   
   IF g_tc_evae[l_ac].tc_evae03[1,4]='MISC' THEN
      LET g_errno = 'aap-158' 
   END IF

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME g_tc_evae[l_ac].ima02
      DISPLAY BY NAME g_tc_evae[l_ac].ima021
   END IF 
 
END FUNCTION
 

#FUN-BC0038 add str---
FUNCTION t003_show_pic()
DEFINE l_chr3  LIKE type_file.chr1  #CHI-C80041
     IF g_tc_evad.tc_evad13 MATCHES '[1]' THEN
         LET g_chr1='Y'
         LET g_chr2='Y'
     ELSE
         LET g_chr1='N'
         LET g_chr2='N'
     END IF
     #CHI-C80041---begin
     IF g_tc_evad.tc_evad13 MATCHES '[9]' THEN
         LET l_chr3 = 'Y'
     ELSE
         LET l_chr3 = 'N'
     END IF 
     CALL cl_set_field_pic(g_chr1,g_chr2,"","",l_chr3,g_tc_evad.tc_evadacti)
END FUNCTION

FUNCTION t003_v(p_type)   
DEFINE   l_chr              LIKE type_file.chr1
DEFINE   l_chr1             LIKE type_file.chr1
DEFINE   l_flag             LIKE type_file.chr1  
DEFINE   p_type             LIKE type_file.chr1 

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_tc_evad.tc_evad01) THEN CALL cl_err('',-400,0) RETURN END IF  
   
   IF p_type = 1 THEN
      IF g_tc_evad.tc_evad12 ='X' THEN RETURN END IF
   ELSE
      IF g_tc_evad.tc_evad12 <>'X' THEN RETURN END IF
   END IF
 
   BEGIN WORK

     INPUT g_tc_evad.tc_evad15 WITHOUT DEFAULTS FROM tc_evad15
 
     BEFORE FIELD tc_evad15
       LET g_tc_evad.tc_evad12 = 'X'
       DISPLAY BY NAME g_tc_evad.tc_evad12
       CALL cl_set_comp_required("tc_evad15",TRUE)

     AFTER FIELD tc_evad15
       LET g_tc_evad_t.tc_evad15 = g_tc_evad.tc_evad15

     AFTER INPUT
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_success = 'N'
          RETURN
       END IF
     END INPUT
 
   LET g_success='Y'
 
   OPEN t003_cl USING g_tc_evad.tc_evad01
   IF STATUS THEN
      CALL cl_err("OPEN t003_cl:", STATUS, 1)
      CLOSE t003_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t003_cl INTO g_tc_evad.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_evad.tc_evad01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t003_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_tc_evad.tc_evad13 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",1)  
      RETURN
   END IF  
   IF g_tc_evad.tc_evad13 = '0' THEN
      LET l_chr1 = 'N'
   ELSE
      LET l_chr1 = 'X'
   END IF 
   IF g_tc_evad.tc_evad13='9' AND NOT cl_null(g_sma.sma53) AND g_tc_evad.tc_evad02 <= g_sma.sma53 THEN
      CALL cl_err('','alm1393',0)
      RETURN
   END IF
        LET l_chr=g_tc_evad.tc_evad13
        IF p_type = 1 THEN        
            LET g_tc_evad.tc_evad13='0' 
            LET g_tc_evad.tc_evad12='X' 
            LET g_tc_evad.tc_evad15 = g_tc_evad_t.tc_evad15
        ELSE 
            LET g_tc_evad.tc_evad13='0'
            LET g_tc_evad.tc_evad12='N'
        END IF
        UPDATE tc_evad_file
            SET tc_evad13=g_tc_evad.tc_evad13,  
                tc_evad12=g_tc_evad.tc_evad12,
                tc_evad15=g_tc_evad.tc_evad15,
                tc_evadmodu=g_user,
                tc_evaddate=g_today
            WHERE tc_evad01=g_tc_evad.tc_evad01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","tc_evad_file",g_tc_evad.tc_evad01,"",SQLCA.sqlcode,"","",1)  
            LET g_tc_evad.tc_evad13=l_chr 
        END IF
        DISPLAY BY NAME g_tc_evad.tc_evad13 
        DISPLAY BY NAME g_tc_evad.tc_evad12
        DISPLAY BY NAME g_tc_evad.tc_evad15
 
   COMMIT WORK
   CLOSE t003_cl
 
END FUNCTION


FUNCTION t003_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_evad_l TO s_tc_evad_l.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()     

      ON ACTION main
         LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL t003_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         EXIT DISPLAY          
       
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      
 
      ON ACTION first
         CALL t003_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t003_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
 
      ON ACTION jump
         CALL t003_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY   
 
      ON ACTION next
         CALL t003_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL t003_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
         
 
     # ON ACTION detail
     #    LET g_action_choice="detail"
     #    LET l_ac2 = 1
     #    EXIT DISPLAY

      #ON ACTION maintain_part
      #   LET g_action_choice="maintain_part"
      #   LET l_ac = 1
      #   EXIT DISPLAY

    #  ON ACTION apji100
    #     LET g_action_choice="apji100"
    #     EXIT DISPLAY
 
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
         
     # ON ACTION fin
     #    LET g_action_choice="fin"
     #    EXIT DISPLAY

      ON ACTION accept
          LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         CALL t003_fetch('/')
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_list", TRUE)
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

FUNCTION t003_list_fill()
DEFINE l_cnt          LIKE type_file.num10
DEFINE l_tc_evad01    LIKE tc_evad_file.tc_evad01
DEFINE l_tc_evaf08    LIKE tc_evaf_file.tc_evaf08  

   CALL g_tc_evad_l.clear()
   LET l_cnt = 1

   FOREACH t003_cs INTO l_tc_evad01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF

      SELECT tc_evad01,tc_evad02,tc_evad03,gen02,tc_evad05,tc_evad06,pmc03,tc_evad12,tc_evad14,
             tc_evad15,tc_evad16,'',
             '','','','','','','','',0
        INTO g_tc_evad_l[l_cnt].*
        FROM gen_file,tc_evad_file,pmc_file 
       WHERE tc_evad03=gen01
         AND pmc01 = tc_evad06
         AND tc_evad01 = l_tc_evad01

       SELECT pmc03 INTO g_tc_evad_l[l_cnt].pmc03_2_l
         FROM pmc_file
        WHERE pmc01 = g_tc_evad_l[l_cnt].tc_evad16_l

       SELECT tc_evae03,tc_evae07,ima02,ima021
         INTO g_tc_evad_l[l_cnt].tc_evae03_l,g_tc_evad_l[l_cnt].tc_evae07_l,
              g_tc_evad_l[l_cnt].ima02_l,g_tc_evad_l[l_cnt].ima021_l
         FROM ima_file,tc_evae_file
        WHERE tc_evae01 = l_tc_evad01
          AND tc_evae03=ima01
          AND rownum = 1
        ORDER BY tc_evae02 DESC

       SELECT tc_evaf05,tc_evaf06,tc_evaf07,tc_evaf09,tc_evaf08
         INTO g_tc_evad_l[l_cnt].tc_evaf05_l,g_tc_evad_l[l_cnt].tc_evaf06_l,
              g_tc_evad_l[l_cnt].tc_evaf07_l,g_tc_evad_l[l_cnt].tc_evaf09_l,
              l_tc_evaf08
         FROM tc_evaf_file a
        WHERE tc_evaf01 = l_tc_evad01
          AND tc_evaf03= (SELECT MAX(tc_evaf03) FROM tc_evaf_file b WHERE a.tc_evaf01=b.tc_evaf01) 

       IF cl_null(l_tc_evaf08) THEN
          LET l_tc_evaf08 = g_today
       END IF
       LET g_tc_evad_l[l_cnt].delay = g_tc_evad_l[l_cnt].tc_evaf07_l-l_tc_evaf08

       LET l_cnt = l_cnt + 1
       IF l_cnt > g_max_rec THEN
       IF g_action_choice ="query"  THEN
            CALL cl_err( '', 9035, 0 )
          END IF
          EXIT FOREACH
       END IF
    END FOREACH
    
    OPEN t003_cs                     
    LET g_rec_b1 = l_cnt - 1
    DISPLAY g_rec_b1 TO FORMONLY.cnt  
    DISPLAY ARRAY g_tc_evad_l TO s_tc_evad_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
END FUNCTION

##--- 資料清單 (E)

FUNCTION t003_icon()
   DEFINE w               ui.Window
   DEFINE n               om.DomNode
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE lr_key          RECORD
         gca01              LIKE gca_file.gca01,
         gca02              LIKE gca_file.gca02,
         gca03              LIKE gca_file.gca03
                         END RECORD


   LET l_cnt = 0
   LET g_doc.column1= "tc_evad01"
   LET g_doc.value1 = g_tc_evad.tc_evad01
   LET lr_key.gca01 = g_doc.column1 CLIPPED || "=" || g_doc.value1 CLIPPED

   SELECT COUNT(*) INTO l_cnt FROM gca_file WHERE gca01=lr_key.gca01

   IF l_cnt > 0 THEN
      LET w = ui.Window.getCurrent()
      LET n = w.findNode("Action","related_document")
      CALL n.setAttribute("image","open2")
   ELSE
      LET w = ui.Window.getCurrent()
      LET n = w.findNode("Action","related_document")
      CALL n.setAttribute("image","")
   END IF

   
   LET l_cnt = 0
   SELECT 1 INTO l_cnt FROM qcs_file 
    WHERE qcs10 = g_tc_evad.tc_evad01
      AND qcs14 <> 'X'

   IF l_cnt > 0 THEN
      LET w = ui.Window.getCurrent()
      LET n = w.findNode("Action","qry_qc")
      CALL n.setAttribute("image","open2")
   ELSE
      LET w = ui.Window.getCurrent()
      LET n = w.findNode("Action","qry_qc")
      CALL n.setAttribute("image","")
   END IF


END FUNCTION 
