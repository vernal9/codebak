# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: csfq001.4gl
# Descriptions...: 工單實際機工時檢核表
# Date & Author..: No.0000664623_06_M009 2017/11/24 By TSD.Andy
# Modify.........: No.0000664623_06_M009 18/02/07 By TSD.Jin 增加條件機時工時為空時，也要查出
# Modify.........: 20180316 modify by momo 排除作廢單據，增加移轉單號
# Modify.........:                       2018/03/19 By Ruby 增加製程編號/製程序
# Modify.........: 20180319 modify by momo 只抓生產數大於0的單據
# Modify.........: No.26030080920260319 by momo 預設 條件調整
# Modify.........: NO.26030080  20260324 By momo SQL條件只抓取大於關帳日日期、增加匯入、更新ACTION

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE azp01        LIKE azp_file.azp01       #20260324 
DEFINE 
     g_shb          DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
       shb01        LIKE shb_file.shb01,      #移轉號碼 20180316
       shb05        LIKE shb_file.shb05,      #工單號碼
       shb10        LIKE shb_file.shb10,      #產品編號
       ima02        LIKE ima_file.ima02,      #品名
       ima021       LIKE ima_file.ima021,     #規格
       shb32        LIKE shb_file.shb32,      #報工確認日
       shb081       LIKE shb_file.shb081,     #作業編號
       shb082       LIKE shb_file.shb082,     #作業名稱
       sfb06        LIKE sfb_file.sfb06,      #製程編號  180319
       shb06        LIKE shb_file.shb06,      #製程序    180319
       shb111       LIKE shb_file.shb111,     #生產數量
       shb032       LIKE shb_file.shb032,     #實際工時
       shb033       LIKE shb_file.shb033      #實際機時
                    END RECORD,
       g_wc2        STRING,
       g_sql        STRING,
       g_rec_b      LIKE type_file.num5,      #單身筆數  
       l_ac         LIKE type_file.num5       #目前處理的ARRAY CNT  
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_i          LIKE type_file.num5     
DEFINE g_row_count  LIKE type_file.num5   
DEFINE g_curs_index LIKE type_file.num5  
DEFINE plant_visible   LIKE type_file.chr1     #20260324

MAIN
 
   OPTIONS                     #改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT             #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time

   LET plant_visible = 'N'              #20260324
   DISPLAY g_plant TO FORMONLY.azp01    #20260324 
 
   OPEN WINDOW q001_w WITH FORM "csf/42f/csfq001"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   LET g_wc2 = '1=1'                                                           
   CALL q001_b_fill(g_wc2)
   CALL q001_menu()
   CLOSE WINDOW q001_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
         RETURNING g_time    
END MAIN
 
FUNCTION q001_menu()
 
   WHILE TRUE
      CALL q001_bp("G")
      CASE g_action_choice
         ##--- 20260324 (S)
         WHEN "plant" 
           IF cl_chk_act_auth() THEN
              LET plant_visible = 'Y'
              CALL q001_q()
           END IF
         ##--- 20260324 (E)
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q001_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_shb),'','')
            END IF
         OTHERWISE EXIT CASE 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q001_q()
   ##--- 20260324(S)
   IF cl_null(azp01) THEN
      LET azp01 = g_plant
      DISPLAY azp01 TO azp01
   END IF
   ##--- 20260324(E)
   CALL q001_b_askkey()
END FUNCTION
 
FUNCTION q001_b_askkey()

   CALL cl_set_comp_entry("azp01",TRUE)  #20260324
   CLEAR FORM
   CALL g_shb.clear()
   CALL cl_opmsg('q')
  
   ##--- 20260324 plant choice (S)
   INPUT BY NAME azp01 WITHOUT DEFAULTS
  
   BEFORE FIELD azp01
     IF plant_visible = 'N' THEN
        CALL cl_set_comp_entry("azp01",FALSE)
     END IF


   END INPUT
 
   CONSTRUCT g_wc2 ON shb01,shb05,shb10,shb32,shb081,shb082,shb06,shb111,shb032,shb033   #20180316 add shb01 #180319 add shb06              
        FROM s_shb[1].shb01,s_shb[1].shb05,s_shb[1].shb10,s_shb[1].shb32,          #20180316 add shb01        
             s_shb[1].shb081,s_shb[1].shb082,s_shb[1].shb06,                       #180319 add shb06      
             s_shb[1].shb111,s_shb[1].shb032,s_shb[1].shb033
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            #20180316 add (S)
            WHEN INFIELD(shb01)      #移轉單號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     ="q_shb"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb01
                     NEXT FIELD shb01
            #20180316 add (E)
            WHEN INFIELD(shb05)        #工單號碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form ="q_sfb2402"
                 LET g_qryparam.construct = "Y"
                 LET g_qryparam.arg1     = 234567
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shb05
                 NEXT FIELD shb05
            WHEN INFIELD(shb10)        #單檔編號
                 CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shb10
                 NEXT FIELD shb10 
            WHEN INFIELD(shb081)       #作業編號
                 CALL q_ecm02(TRUE,TRUE,'','') RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shb081
                 NEXT FIELD shb081
            OTHERWISE
               EXIT CASE
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('shbuser', 'shbgrup') 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_rec_b = 0 
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL q001_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION q001_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2      STRING
   DEFINE l_ecb19    LIKE ecb_file.ecb19 #20290324
   DEFINE l_ecb21    LIKE ecb_file.ecb21 #20290324

   LET g_plant_new= azp01                #20260324

   LET g_sql = "SELECT shb01,shb05,shb10,ima02,ima021,shb32,shb081,shb082,sfb06,shb06,shb111,shb032,shb033 ", #20180316 add shb01 #180319 add '',shb06
               "  FROM ",cl_get_target_table(g_plant_new,'shb_file'),                                         #20260324 
               "  LEFT JOIN ",cl_get_target_table(g_plant_new,'ima_file')," ON ima01 = shb10 ",               #20260324
               "  LEFT JOIN ",cl_get_target_table(g_plant_new,'sfb_file')," ON sfb01 = shb05 ",               #20260324
               #M009 180207 By TSD.Jin--start--
               #" WHERE shb032 = 0 AND shb033 = 0  ",
               " WHERE ((shb032 = 0 AND shb033 = 0) OR (shb032 IS NULL AND shb033 IS NULL))  ",
               #M009 180207 By TSD.Jin--end----
               "   AND shb28 IS NULL ",
               "   AND shbconf = 'Y' ",             #排除作廢單據 20180316
               "   AND shb111 > 0 ",                #只抓生產數大於0 20180319
              #"   AND shb32 > '",g_sma.sma53,"' ", #排除已關帳 20260319
               "   AND shb32 > (SELECT sma53 FROM ",cl_get_target_table(g_plant_new,'sma_file'),
                              ")",
               "   AND ", p_wc2 CLIPPED,            #單身
               " ORDER BY shb05,shb10 "     
 
   PREPARE q001_pb FROM g_sql
   DECLARE shb_curs CURSOR FOR q001_pb
 
   CALL g_shb.clear()
   LET g_cnt = 1
   FOREACH shb_curs INTO g_shb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
            
      IF g_action_choice = 'update_working_time' THEN
         CALL update_working_time()
      END IF
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

   END FOREACH

   CALL g_shb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0              
   LET g_curs_index = 0            
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_shb TO s_shb.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 

      ##--- 20260324 (S)
      ON ACTION plant                  
         LET plant_visible = 'Y'       
         LET g_action_choice="plant"  
         EXIT DISPLAY  
      ##--- 20260324 (E) 
 
      ON ACTION query
         LET plant_visible = 'N'       #20260324
         LET g_action_choice="query"
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

      ##---- 20260324 更新報工時間
      ON ACTION update_working_time
         LET g_action_choice = 'update_working_time'
         CALL q001_b_fill(g_wc2)
         CALL q001_q()

      ##---- 20260324 匯入機工時
      ON ACTION import_working_time
         LET g_action_choice="import_working_time" 
         CALL import_working_time() 
         LET g_action_choice = 'update_working_time'
         CALL q001_b_fill(g_wc2)
         CALL q001_q()

      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

##--- 20260324
FUNCTION update_working_time()

DEFINE l_ecb19 LIKE ecb_file.ecb19
DEFINE l_ecb21 LIKE ecb_file.ecb21
DEFINE l_sql   STRING
      
   LET l_ecb19 = 0
   LET l_ecb21 = 0
   LET l_sql = "SELECT ecb19,ecb21 ",
               " FROM ",cl_get_target_table(g_plant_new,'ecb_file'),
               " WHERE ecb01 = '",g_shb[g_cnt].shb10,"' ",
               "   AND ecb02 = '",g_shb[g_cnt].sfb06,"' ",
               "   AND ecb03 = '",g_shb[g_cnt].shb06,"' ",
               "   AND ecb012 = ' ' ",
               "   AND ecb19+ecb21 > 0 "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
   PREPARE sel_ecb_time FROM l_sql
   EXECUTE sel_ecb_time INTO l_ecb19,l_ecb21

   IF l_ecb19 + l_ecb21 > 0 THEN
      LET l_sql = "UPDATE ",cl_get_target_table(g_plant_new,'shb_file'), 
                  "   SET shb032 = (shb111 * ? )/60,",
                  "       shb033 = (shb111 * ? )/60 ",
                  " WHERE shb01 = ? "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
      PREPARE upd_shb_time FROM l_sql
      EXECUTE upd_shb_time USING l_ecb19,l_ecb21,g_shb[g_cnt].shb01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","shb_file",g_shb[g_cnt].shb01,g_shb[g_cnt].shb10,SQLCA.sqlcode,"","",1)
      ELSE
         COMMIT WORK
      END IF
   END IF
      
END FUNCTION
