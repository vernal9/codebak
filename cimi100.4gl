# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cimi100.4gl
# Descriptions...: 料件批次建立維護作業
# Date & Author..: 2024/04/25 By momo
# Modify 		 : 


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE d_ima         RECORD LIKE ima_file.* 
DEFINE 
    g_argv1         LIKE ima_file.ima01,       #上階主件
    g_ima06         LIKE ima_file.ima06,
    g_ima01_t       LIKE ima_file.ima01,
    g_ima        DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ima01     LIKE ima_file.ima01,      #料號
        ima02     LIKE ima_file.ima02,      #品名
        ima021    LIKE ima_file.ima021,     #規格
        ima06     LIKE ima_file.ima06,      #分群碼
        ima08     LIKE ima_file.ima08,      #來源碼
        ima25     LIKE ima_file.ima25,      #庫存單位
        ima131    LIKE ima_file.ima131,     #產品分類
        ima09     LIKE ima_file.ima09,      #其他分群碼-系列
        ima1007   LIKE ima_file.ima1007,    #其他分群碼-型號
        ima10     LIKE ima_file.ima10,      #其他分群碼二-馬達功率
        ima11     LIKE ima_file.ima11,      #其他分群碼二-馬達規格
        ta_ima02  LIKE ima_file.ta_ima02,   #軸數
        ta_ima07  LIKE ima_file.ta_ima07,   #馬達方向
        ta_ima03  LIKE ima_file.ta_ima03,   #外徑+導程
        ta_ima04  LIKE ima_file.ta_ima04,   #行程
        ta_ima05  LIKE ima_file.ta_ima05,   #帶控制
        ta_ima06  LIKE ima_file.ta_ima06,   #代工
        imaud07   LIKE ima_file.imaud07,    #含控制線長(米)
        ta_ima08  LIKE ima_file.ta_ima08,   #是否特注
        ta_ima01  LIKE ima_file.ta_ima01,   #免備料品
        imaud08   LIKE ima_file.imaud08,    #素材長度
        imauser   LIKE ima_file.imauser,    #資料所有者  
        gen02     LIKE gen_file.gen02,      #姓名 
        ima901    LIKE ima_file.ima901,     #建檔日
        imaoriu   LIKE ima_file.imaoriu     #       
                END RECORD,
    g_ima_t     RECORD                      #程式變數 (舊值)
        ima01     LIKE ima_file.ima01,      #料號
        ima02     LIKE ima_file.ima02,      #品名
        ima021    LIKE ima_file.ima021,     #規格
        ima06     LIKE ima_file.ima06,      #分群碼
        ima08     LIKE ima_file.ima08,      #來源碼
        ima25     LIKE ima_file.ima25,      #庫存單位
        ima131    LIKE ima_file.ima131,     #產品分類
        ima09     LIKE ima_file.ima09,      #其他分群碼-系列
        ima1007   LIKE ima_file.ima1007,    #其他分群碼-型號
        ima10     LIKE ima_file.ima10,      #其他分群碼二-馬達功率
        ima11     LIKE ima_file.ima11,      #其他分群碼二-馬達規格
        ta_ima02  LIKE ima_file.ta_ima02,   #
        ta_ima07  LIKE ima_file.ta_ima07,   #
        ta_ima03  LIKE ima_file.ta_ima03,   #
        ta_ima04  LIKE ima_file.ta_ima04,   #
        ta_ima05  LIKE ima_file.ta_ima05,   #
        ta_ima06  LIKE ima_file.ta_ima06,   #
        imaud07   LIKE ima_file.imaud07,    #
        ta_ima08  LIKE ima_file.ta_ima08,   #
        ta_ima01  LIKE ima_file.ta_ima01,   #
        imaud08   LIKE ima_file.imaud08,    #素材長度
        imauser   LIKE ima_file.imauser,    #資料所有者  
        gen02     LIKE gen_file.gen02,      #姓名 
        ima901    LIKE ima_file.ima901,     #建檔日
        imaoriu   LIKE ima_file.imaoriu     #
        
                END RECORD,
    g_wc2,g_sql    string,  
    g_tit           LIKE type_file.chr20,             #
    g_tit1          LIKE type_file.chr20,             #
    g_rec_b         LIKE type_file.num5,              #單身筆數
    l_ac            LIKE type_file.num5               #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING                            #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt        LIKE type_file.num10              #  
DEFINE g_i          LIKE type_file.num5               ##count/index for any purpose
DEFINE l_table      STRING                            #                                                                  
DEFINE g_str        STRING                            #                                                                 
DEFINE g_prog1      STRING                            #
DEFINE l_cnt        LIKE type_file.num10


MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1   = ARG_VAL(1) 
   LET g_ima06   = g_argv1
  
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CIM")) THEN
      EXIT PROGRAM
   END IF
                                                                                                                      

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW i300_w WITH FORM "cim/42f/cimi100"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("cimi100")
   CALL cl_ui_init()
 
 
   CALL i100_b_fill(g_wc2)
 
   CALL i100_menu()
 
   CLOSE WINDOW i300_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i100_menu()
 
   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i100_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i100_batch_confirm()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
 
FUNCTION i100_b()
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
 
                     
   LET g_forupd_sql = " SELECT ima01,ima02,ima021 ",   
                      "        FROM ima_file ",  
                      "  WHERE ima01= ?  FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_ima WITHOUT DEFAULTS FROM s_ima.*
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
            LET g_ima_t.* = g_ima[l_ac].*  #BACKUP
            OPEN i100_bcl USING g_ima_t.ima01
            IF STATUS THEN
               CALL cl_err("OPEN i100_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i100_bcl INTO g_ima[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ima_t.ima01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  UPDATE ima_file
                     SET ima01 = g_ima[l_ac].ima01,
                         ima02 = g_ima[l_ac].ima02,
                         ima021 = g_ima[l_ac].ima021,
                         ima06 = g_ima[l_ac].ima06,
                         ima08 = g_ima[l_ac].ima08,
                         ima25 = g_ima[l_ac].ima25,
                         ima131 = g_ima[l_ac].ima131,
                         ima09 = g_ima[l_ac].ima09,
                         ima1007 = g_ima[l_ac].ima1007,
                         ima10 = g_ima[l_ac].ima10,
                         ima11 = g_ima[l_ac].ima11,
                         ta_ima02 = g_ima[l_ac].ta_ima02,
                         ta_ima07 = g_ima[l_ac].ta_ima07,
                         ta_ima03 = g_ima[l_ac].ta_ima03,
                         ta_ima04 = g_ima[l_ac].ta_ima04,
                         ta_ima05 = g_ima[l_ac].ta_ima05,
                         ta_ima06 = g_ima[l_ac].ta_ima06,
                         imaud07 = g_ima[l_ac].imaud07,
                         ta_ima08 = g_ima[l_ac].ta_ima08,
                         ta_ima01 = g_ima[l_ac].ta_ima01,
                         imaud08 = g_ima[l_ac].imaud08,
                         imauser = g_ima[l_ac].imauser
                   WHERE ima01 = g_ima_t.ima01
                     
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","ima_file",g_ima_t.ima01,"",SQLCA.sqlcode,"","",1)
                  END IF

                  DISPLAY BY NAME g_ima[l_ac].imauser
                  
               END IF
            END IF
            CALL cl_show_fld_cont()  
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_ima[l_ac].* TO NULL      
         INITIALIZE d_ima.* TO NULL
         LET g_ima_t.* = g_ima[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()  
         NEXT FIELD ima01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF NOT i100_a_ins() THEN 
            ROLLBACK WORK
            CANCEL INSERT
         END IF
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ima_file",g_ima[l_ac].ima01,"",SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      AFTER FIELD ima01
         IF NOT cl_null(g_ima[l_ac].ima01) THEN
            IF p_cmd='a' THEN
               LET l_cnt = 0
               SELECT 1 INTO l_cnt FROM ima_file
                WHERE ima01= g_ima[l_ac].ima01
               IF l_cnt = 1 THEN
                  CALL cl_err(g_ima[l_ac].ima01,'aim-023',1)
                  NEXT FIELD ima01
               END IF
            END IF
         END IF
         DISPLAY BY NAME g_ima[l_ac].ima01

      AFTER FIELD ima02
         IF cl_null(g_ima[l_ac].ima02) THEN
            NEXT FIELD ima02
         END IF
         DISPLAY BY NAME g_ima[l_ac].ima02

      AFTER FIELD ima021
         IF cl_null(g_ima[l_ac].ima021) THEN
            NEXT FIELD ima021
         END IF
         IF NOT cl_null(g_ima[l_ac].ima021)  THEN
            LET l_cnt = 0
            SELECT 1 INTO l_cnt FROM ima_file
             WHERE ima02 = g_ima[l_ac].ima02
               AND ima021= g_ima[l_ac].ima021
               AND ima01 <> g_ima[l_ac].ima01
               AND rownum = 1
            IF l_cnt = 1 THEN
               CALL cl_err('','aom-753',1)
               NEXT FIELD ima02
            END IF
         END IF
         DISPLAY BY NAME g_ima[l_ac].ima021

      AFTER FIELD ima06
        IF cl_null(g_ima[l_ac].ima06) THEN
           NEXT FIELD ima06
        ELSE
           SELECT 1 INTO l_cnt FROM imz_file
             WHERE imz01 = g_ima[l_ac].ima06
               AND imzacti='Y'
           IF l_cnt = 1 THEN
              CALL i100_set_rel_ima06()
              CALL i100_default()
           ELSE
              NEXT FIELD ima06
           END IF
        END IF
        DISPLAY BY NAME g_ima[l_ac].ima06

      AFTER FIELD ima08
         IF cl_null(g_ima[l_ac].ima08) THEN
            NEXT FIELD ima08
         ELSE
            IF g_ima[l_ac].ima08 NOT MATCHES "[CTDAMPXKUVRZS]" THEN
               NEXT FIELD ima08
            END IF
         END IF
         DISPLAY BY NAME g_ima[l_ac].ima08

      AFTER FIELD ima25
         IF cl_null(g_ima[l_ac].ima25) THEN
            NEXT FIELD ima25
         ELSE
            LET l_cnt = 0
            SELECT 1 INTO l_cnt FROM gfe_file
             WHERE gfe01 = g_ima[l_ac].ima25
               AND gfeacti='Y'
            IF l_cnt <> 1 THEN
               NEXT FIELD ima25
            END IF
         END IF
         DISPLAY BY NAME g_ima[l_ac].ima25

      AFTER FIELD ima131
         IF cl_null(g_ima[l_ac].ima131) THEN
            NEXT FIELD ima131
         ELSE
            LET l_cnt = 0
            SELECT 1 INTO l_cnt FROM oba_file
             WHERE oba01 = g_ima[l_ac].ima131
               AND obaacti='Y'
            IF l_cnt <> 1 THEN
               NEXT FIELD ima131
            END IF
         END IF
         DISPLAY BY NAME g_ima[l_ac].ima131

      AFTER FIELD ima09
         IF NOT cl_null(g_ima[l_ac].ima09) THEN
            LET l_cnt = 0
            SELECT 1 INTO l_cnt FROM azf_file
             WHERE azf01 = g_ima[l_ac].ima09
               AND azfacti='Y' AND azf02='D'
            IF l_cnt <> 1 THEN
               NEXT FIELD ima09
            END IF
         END IF
         DISPLAY BY NAME g_ima[l_ac].ima09

      AFTER FIELD ima10
         IF NOT cl_null(g_ima[l_ac].ima10) THEN
            LET l_cnt = 0
            SELECT 1 INTO l_cnt FROM azf_file
             WHERE azf01 = g_ima[l_ac].ima10
               AND azfacti='Y' AND azf02='E'
            IF l_cnt <> 1 THEN
               NEXT FIELD ima10
            END IF
         END IF
         DISPLAY BY NAME g_ima[l_ac].ima10

      AFTER FIELD ima11
         IF NOT cl_null(g_ima[l_ac].ima11) THEN
            LET l_cnt = 0
            SELECT 1 INTO l_cnt FROM azf_file
             WHERE azf01 = g_ima[l_ac].ima11
               AND azfacti='Y' AND azf02='F'
            IF l_cnt <> 1  THEN
               NEXT FIELD ima11
            END IF
         END IF
         DISPLAY BY NAME g_ima[l_ac].ima11

      AFTER FIELD ta_ima02
         IF cl_null(g_ima[l_ac].ta_ima02) THEN
            NEXT FIELD ta_ima02
         ELSE
            IF g_ima[l_ac].ta_ima02 < 0 OR g_ima[l_ac].ta_ima02>8 THEN
               NEXT FIELD ta_ima02
            END IF
         END IF
         DISPLAY BY NAME g_ima[l_ac].ta_ima02

      AFTER FIELD ta_ima05
         IF NOT cl_null(g_ima[l_ac].ta_ima05) THEN
            LET l_cnt = 0
            SELECT 1 INTO l_cnt FROM tc_dic_file
             WHERE tc_dic01='aimi100' AND tc_dic02='ta_ima05'
               AND tc_dicacti='Y'
               AND tc_dic04=g_ima[l_ac].ta_ima05
            IF l_cnt <> 1 THEN
               NEXT FIELD ta_ima05
            END IF
         END IF  
         DISPLAY BY NAME g_ima[l_ac].ta_ima05

      AFTER FIELD ta_ima07
         IF NOT cl_null(g_ima[l_ac].ta_ima07) THEN
            LET l_cnt = 0
            SELECT 1 INTO l_cnt FROM tc_dic_file
             WHERE tc_dic01='aimi100' AND tc_dic02='ta_ima07'
               AND tc_dicacti='Y'
               AND tc_dic04=g_ima[l_ac].ta_ima07
            IF l_cnt <> 1 THEN
               NEXT FIELD ta_ima07
            END IF
         END IF 
         DISPLAY BY NAME g_ima[l_ac].ta_ima07
 
      BEFORE DELETE                            #是否取消單身
         IF g_ima_t.ima01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM ima_file WHERE ima01 = g_ima_t.ima01
                                      AND ima02 = g_ima_t.ima02
                                      
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ima_file",g_ima_t.ima01,"",SQLCA.sqlcode,"","",1) 
               ROLLBACK WORK
               CANCEL DELETE
            ##---- 20240801 相關文件刪除
            LET g_doc.column1 = "ima01"
            LET g_doc.value1 = g_ima_t.ima01
            CALL cl_del_doc() 
            DELETE FROM imc_file WHERE imc01= g_ima_t.ima01 #品名規格額外說明
            
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ima[l_ac].* = g_ima_t.*
            CLOSE i100_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ima[l_ac].ima01,-263,1)
            LET g_ima[l_ac].* = g_ima_t.*
         ELSE
            UPDATE ima_file SET ima01=g_ima[l_ac].ima01,
                                ima02=g_ima[l_ac].ima02,
                                imaoriu = g_user,
                                imadate = g_today,                           
                                ima021 = g_ima[l_ac].ima021,
                                ima06 = g_ima[l_ac].ima06,
                                ima08 = g_ima[l_ac].ima08,
                                ima25 = g_ima[l_ac].ima25,
                                ima131 = g_ima[l_ac].ima131,
                                ima09 = g_ima[l_ac].ima09,
                                ima1007 = g_ima[l_ac].ima1007,
                                ima10 = g_ima[l_ac].ima10,
                                ima11 = g_ima[l_ac].ima11,
                                ta_ima02 = g_ima[l_ac].ta_ima02,
                                ta_ima07 = g_ima[l_ac].ta_ima07,
                                ta_ima03 = g_ima[l_ac].ta_ima03,
                                ta_ima04 = g_ima[l_ac].ta_ima04,
                                ta_ima05 = g_ima[l_ac].ta_ima05,
                                ta_ima06 = g_ima[l_ac].ta_ima06,
                                imaud07 = g_ima[l_ac].imaud07,
                                ta_ima08 = g_ima[l_ac].ta_ima08,
                                ta_ima01 = g_ima[l_ac].ta_ima01,
                                imaud08 = g_ima[l_ac].imaud08,
                                imauser = g_ima[l_ac].imauser
             WHERE ima01 = g_ima_t.ima01
               
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ima_file",g_ima_t.ima01,g_ima_t.ima02,SQLCA.sqlcode,"","",1)  
               LET g_ima[l_ac].* = g_ima_t.*
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
               LET g_ima[l_ac].* = g_ima_t.*              

            #FUN-D40030--add--str--
            ELSE
               CALL g_ima.deleteElement(l_ac)
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
         CLOSE i100_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(ima06)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_imz"
                LET g_qryparam.default1 = g_ima[l_ac].ima06
                CALL cl_create_qry() RETURNING g_ima[l_ac].ima06
                DISPLAY BY NAME g_ima[l_ac].ima06
                NEXT FIELD ima06
             WHEN INFIELD(ima09)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azf"
                LET g_qryparam.default1 = g_ima[l_ac].ima09
                LET g_qryparam.arg1 = "D"
                CALL cl_create_qry() RETURNING g_ima[l_ac].ima09
                DISPLAY BY NAME g_ima[l_ac].ima09
                NEXT FIELD ima09
             WHEN INFIELD(ima25)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gfe"
                LET g_qryparam.default1 = g_ima[l_ac].ima25
                CALL cl_create_qry() RETURNING g_ima[l_ac].ima25
                DISPLAY BY NAME g_ima[l_ac].ima25
                NEXT FIELD ima25
             WHEN INFIELD(ima131)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_oba"
                LET g_qryparam.default1 = g_ima[l_ac].ima131
                CALL cl_create_qry() RETURNING g_ima[l_ac].ima131
                DISPLAY BY NAME g_ima[l_ac].ima131
                NEXT FIELD ima131
             OTHERWISE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(ima01) AND l_ac > 1 THEN
            LET g_ima[l_ac].* = g_ima[l_ac-1].*
            NEXT FIELD ima01
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
 
   CLOSE i100_bcl
 
   COMMIT WORK
 
END FUNCTION
 

FUNCTION i100_b_askkey()
 
    CLEAR FORM
    CALL g_ima.clear()
 
    CONSTRUCT g_wc2 ON ima01,ima02,ima021,ima06
         FROM s_ima[1].ima01,s_ima[1].ima02,s_ima[1].ima021,s_ima[1].ima06
       
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
     
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ima06)
                 LET g_qryparam.form = "q_imz"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ima[1].ima06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima06
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
 
    LET g_wc2 =g_wc2 CLIPPED
   
    CALL i100_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i100_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT ima01,ima02,ima021,ima06,ima08,ima25,ima131,ima09,ima1007,ima10,ima11, ",   
               "       ta_ima02,ta_ima07,ta_ima03,ta_ima04,ta_ima05,ta_ima06,imaud07,ta_ima08,ta_ima01,",
               "       imaud08,imauser,gen02,ima901,imaoriu",
               "  FROM ima_file,gen_file ",                                        
               " WHERE imauser=gen01 AND ", p_wc2 CLIPPED,                     #單身
               " ORDER BY ima01 "
   PREPARE i100_pb FROM g_sql
   DECLARE azf_curs CURSOR FOR i100_pb
 
   CALL g_ima.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH azf_curs INTO g_ima[g_cnt].*   #單身 ARRAY 填充
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
 
   CALL g_ima.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
 
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
   DISPLAY ARRAY g_ima TO s_ima.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                  
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ON ACTION confirm
         LET g_action_choice="confirm"
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
 
      ON ACTION about        
         CALL cl_about()      
 
 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i100_a_ins()
DEFINE l_cnt        LIKE type_file.num5    

   IF cl_null(d_ima.ima601) THEN 
      LET d_ima.ima601 = '1'    
   END IF   

   LET d_ima.ima01 = g_ima[l_ac].ima01
   LET d_ima.ima02 = g_ima[l_ac].ima02
   LET d_ima.ima021= g_ima[l_ac].ima021
   LET d_ima.ima06 = g_ima[l_ac].ima06
   LET d_ima.ima08 = g_ima[l_ac].ima08
   LET d_ima.ima25 = g_ima[l_ac].ima25
   LET d_ima.ima131 = g_ima[l_ac].ima131
   LET d_ima.ima09 = g_ima[l_ac].ima09
   LET d_ima.ima1007 = g_ima[l_ac].ima1007
   LET d_ima.ima10 = g_ima[l_ac].ima10
   LET d_ima.ima11 = g_ima[l_ac].ima11
   LET d_ima.ta_ima01 = g_ima[l_ac].ta_ima01
   LET d_ima.ta_ima02 = g_ima[l_ac].ta_ima02
   LET d_ima.ta_ima03 = g_ima[l_ac].ta_ima03
   LET d_ima.ta_ima04 = g_ima[l_ac].ta_ima04
   LET d_ima.ta_ima05 = g_ima[l_ac].ta_ima05
   LET d_ima.ta_ima06 = g_ima[l_ac].ta_ima06
   LET d_ima.ta_ima07 = g_ima[l_ac].ta_ima07
   LET d_ima.ta_ima08 = g_ima[l_ac].ta_ima08
   LET d_ima.imaud07 = g_ima[l_ac].imaud07
   LET d_ima.imaud08 = g_ima[l_ac].imaud08
   LET d_ima.imauser = g_ima[l_ac].imauser
   
   INSERT INTO ima_file VALUES(d_ima.*)       # DISK WRITE
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ima_file",d_ima.ima01,"",SQLCA.sqlcode,"","",1)  #
      RETURN FALSE
   ELSE
      LET g_ima01_t = d_ima.ima01           #TQC-C70189 add
      ##- 固定備註---- (S)
      IF d_ima.ima06 = 'E0000' THEN
          INSERT INTO imc_file(imc01,imc02,imc03,imc04)
               VALUES(d_ima.ima01,'MN01',1,'TOYO提供燒錄軟體')
       END IF
       IF d_ima.ima06 = 'F0000' THEN
          INSERT INTO imc_file(imc01,imc02,imc03,imc04)
               VALUES(d_ima.ima01,'MN01',1,'TOYO提供治具')
       END IF 
      ##- 固定備註---- (E)
   END IF
   CALL i100_a_file()
   RETURN TRUE
END FUNCTION


FUNCTION i100_default()
   
   LET d_ima.ima05 = NULL
   LET d_ima.ima07 = 'A'
   LET d_ima.ima08 = 'P'
   LET d_ima.ima108 = 'N'
   LET d_ima.ima14 = 'N'   
   LET d_ima.ima15 = 'N'
   LET d_ima.ima16 = 99
   LET d_ima.ima18 = 0
   LET d_ima.ima022 = 0  
   LET d_ima.ima131 = ' '  
   LET d_ima.ima23 = ' '
   LET d_ima.ima27 = 0
   LET d_ima.ima28 = 0
   LET d_ima.ima29  =NULL      #最近異動日期
   LET d_ima.ima30 = g_today      
   LET d_ima.ima911= 'N'   
   LET d_ima.ima271 = 0
   LET d_ima.ima31_fac = 1
   LET d_ima.ima32 = 0
   LET d_ima.ima33 = 0
   LET d_ima.ima38 = 0
   LET d_ima.ima40 = 0
   LET d_ima.ima41 = 0
   LET d_ima.ima44_fac = 1
   LET d_ima.ima46 = 0
   LET d_ima.ima47 = 0
   LET d_ima.ima48 = 0
   LET d_ima.ima49 = 0
   LET d_ima.ima491 = 0
   LET d_ima.ima50 = 0
   LET d_ima.ima51 = 1
   LET d_ima.ima52 = 1
   LET d_ima.ima140 = 'N'
   LET d_ima.ima53 = 0
   LET d_ima.ima531 = 0
   LET d_ima.ima532 =NULL      #市價最近異動日期  
   LET d_ima.ima55_fac = 1
   LET d_ima.ima562 = 0  #生產時損耗率
   LET d_ima.ima571 = g_ima[l_ac].ima01
   LET d_ima.ima57 = 0
   LET d_ima.ima58 = 0
   LET d_ima.ima59 = 0
   LET d_ima.ima60 = 0
   LET d_ima.ima61 = 0
   LET d_ima.ima62 = 0
   LET d_ima.ima63_fac = 1
   LET d_ima.ima65 = 0
   LET d_ima.ima66 = 0
   LET d_ima.ima68 = 0
   LET d_ima.ima69 = 0
   LET d_ima.ima70 = 'N'
   LET d_ima.ima73 = NULL #最近入庫日期    
   LET d_ima.ima74 = NULL #最近出庫日期       
   LET d_ima.ima72 = 0
   LET d_ima.ima721 = 0 
   LET d_ima.ima75 = ''
   LET d_ima.ima76 = ''
   LET d_ima.ima77 = 0
   LET d_ima.ima78 = 0
   LET d_ima.ima80 = 0
   LET d_ima.ima81 = 0
   LET d_ima.ima82 = 0
   LET d_ima.ima83 = 0
   LET d_ima.ima84 = 0
   LET d_ima.ima85 = 0
   LET d_ima.ima852= 'N'
   LET d_ima.ima853= 'N'
   LET d_ima.ima881 =NULL      #期間採購最近採購日期
   LET d_ima.ima86_fac = 1
   LET d_ima.ima88 = 0
   LET d_ima.ima91 = 0
   LET d_ima.ima92 = 'N'
   LET d_ima.ima93 = "NNNNNNNN"
   LET d_ima.ima94 = ''
   LET d_ima.ima95 = 0
   LET d_ima.ima96 = 0
   LET d_ima.ima97 = 0
   LET d_ima.ima98 = 0
   LET d_ima.ima99 = 0
   LET d_ima.ima100 = 'N'
   LET d_ima.ima101 = '1'
   LET d_ima.ima102 = '1'
   LET d_ima.ima103 = '0'
   LET d_ima.ima104 = 0
   LET d_ima.ima105 = 'N'
   LET d_ima.ima107= 'N'
   LET d_ima.ima120='1'   
   LET d_ima.ima139 = 'N'
   LET d_ima.ima147= 'N' 
   LET d_ima.ima154 = 'N'      #                                                                                 
   LET d_ima.ima155 = 'N'
   LET d_ima.ima156 ='N'
   LET d_ima.ima157 =' '
   LET d_ima.ima158 ='N'
   LET d_ima.ima160 = 'N'
   LET d_ima.ima165 = 'N'  
   LET d_ima.ima902 = NULL
   LET d_ima.ima9021 = NULL
   LET d_ima.ima903= 'N'
   LET d_ima.ima905= 'N'
   LET d_ima.ima913 = 'N' 
   LET d_ima.ima918= 'N'
   LET d_ima.ima919= 'N'
   LET d_ima.ima921= 'N'
   LET d_ima.ima922= 'N'
   LET d_ima.ima924= 'N'
   LET d_ima.ima925= '1'    
   LET d_ima.ima910 = ' '  
   LET d_ima.ima912 = 0  
   LET d_ima.ima918 = 'N' 
   LET d_ima.ima919 = 'N'
   LET d_ima.ima921 = 'N'
   LET d_ima.ima922 = 'N'
   LET d_ima.ima924 = 'N'
   LET d_ima.ima926 = 'N'
   LET d_ima.ima927 = 'N' 
   LET d_ima.ima928='N'   
   LET d_ima.ima943 = '4'
   LET d_ima.imaacti= 'P' 
   LET d_ima.imaoriu = g_user 
   LET d_ima.imaorig = g_grup 
   LET d_ima.imagrup= g_grup                #使用者所屬群
   LET d_ima.imadate= g_today
   LET d_ima.ima901 = g_today               #料件建檔日期
    
   #產品資料
   LET d_ima.ima121 = 0
   LET d_ima.ima122 = 0
   LET d_ima.ima123 = 0
   LET d_ima.ima124 = 0
   LET d_ima.ima125 = 0
   LET d_ima.ima126 = 0
   LET d_ima.ima127 = 0
   LET d_ima.ima128 = 0
   LET d_ima.ima129 = 0
   LET d_ima.ima133 = g_ima[l_ac].ima01
   LET d_ima.ima135 = NULL     #產品條碼編號
   LET d_ima.ima141 = '0'
   LET d_ima.ima1010 = '0' #0:開立     

   #單位控制部分
 
   IF g_sma.sma115 = 'Y' THEN
      IF g_sma.sma122 MATCHES '[13]' THEN
         LET d_ima.ima906 = '2'
      ELSE
         LET d_ima.ima906 = '3'
      END IF
   ELSE
      LET d_ima.ima906 = '1'
   END IF
   LET d_ima.ima909 = 0
   LET d_ima.ima1001 = ''
   LET d_ima.ima1002 = ''
   LET d_ima.ima1012 = NULL
   LET d_ima.ima1014 = '1'
   #LET d_ima.ima1019 = 0
   #LET d_ima.ima1020 = 0
   #LET d_ima.ima1021 = 0
   #LET d_ima.ima1022 = 0
   #LET d_ima.ima1023 = 0
   #LET d_ima.ima1024 = 0
   #LET d_ima.ima1025 = 0
   #LET d_ima.ima1026 = 0
   #LET d_ima.ima1027 = 0
   #LET d_ima.ima1028 = 0
   LET d_ima.ima151 = 'N'
   LET d_ima.ima918='N'
   LET d_ima.ima919='N'
   LET d_ima.ima921='N'
   LET d_ima.ima922='N'
   LET d_ima.ima924='N'
   LET d_ima.ima925='1'
   LET d_ima.ima916=g_plant  
   LET d_ima.ima917=0        
   LET d_ima.ima156='N'     
   LET d_ima.ima157=' '      
   LET d_ima.ima158='N'     
   LET d_ima.ima159= '3'    
   LET d_ima.ima930 = 'N'    #使用條碼否
   LET d_ima.ima931 = 'N'    
   LET d_ima.ima934 = 'Y'    
   LET d_ima.ima935 = 'N'    
   LET d_ima.ima937 = 0   

   IF g_sma.sma95 = "N" THEN
      LET d_ima.ima918 = "N"
      LET d_ima.ima919 = "N"
      LET d_ima.ima920 = NULL 
      LET d_ima.ima921 = "N"
      LET d_ima.ima922 = "N"
      LET d_ima.ima923 = NULL 
      LET d_ima.ima924 = "N"
      LET d_ima.ima925 = "1" 
   END IF  

   ##---- 20201012 add by momo (S) 分群A0000與B0000 預設為免備料品
   IF d_ima.ima06 = 'E0000' OR d_ima.ima06 = 'F0000' THEN
      LET d_ima.ta_ima01='Y'
   END IF
   ##---- 20201012 add by momo (E) 
END FUNCTION 

FUNCTION i100_set_rel_ima06()
  DEFINE
     l_imz02        LIKE imz_file.imz02,
     l_imaacti      LIKE ima_file.imaacti,
     l_imauser      LIKE ima_file.imauser,
     l_imagrup      LIKE ima_file.imagrup,
     l_imamodu      LIKE ima_file.imamodu,
     l_imadate      LIKE ima_file.imadate
 
    SELECT imz01,imz02,imz03 ,imz04,
           imz07,imz08,imz09,imz10,
           imz11,imz12,imz14,imz15,
           imz17,imz19,imz21,
           imz23,imz24,imz25,imz27,
           imz28,imz31,imz31_fac,imz34,
           imz35,imz36,imz37,imz38,
           imz39,imz42,imz43,imz44,
           imz44_fac,imz45,imz46 ,imz47,
           imz48,imz49,imz491,imz50,
           imz51,imz52,imz54,imz55,
           imz55_fac,imz56,imz561,imz562,
           imz59 ,imz60,imz61,imz62,
           imz63,imz63_fac ,imz64,imz641,
           imz65,imz66,imz67,imz68,
           imz69,imz70,imz71,imz86,
           imz86_fac ,imz87,imz871,imz872,
           imz873,imz874,imz88,imz89,
           imz90,imz94,imz99,imz100 ,
           imz101,imz102 ,imz103,imz105,
           imz106,imz107,imz108,imz109,
           imz110,imz130,imz131,imz132,
           imz134,
           imz147,imz148,imz903,
           imzacti,imzuser,imzgrup,imzmodu,imzdate,
           imz906,imz907,imz908,imz909,
           imz911,
           imz918,imz919,imz920,imz921,imz922,imz923,imz924,imz925,   
           imz136,imz137,imz391,imz1321,
           imz72,imz153,imz601,  
           imz926,      
           imz156,imz157,imz158,             
           imz022,imz251,imz159,               
           imz163,imz1631,                    
           imz152,imz150 
      INTO d_ima.ima06,l_imz02,d_ima.ima03,d_ima.ima04,
           d_ima.ima07,d_ima.ima08,d_ima.ima09,d_ima.ima10,
           d_ima.ima11,d_ima.ima12,d_ima.ima14,d_ima.ima15,
           d_ima.ima17,d_ima.ima19,d_ima.ima21,
           d_ima.ima23,d_ima.ima24,d_ima.ima25,d_ima.ima27,
           d_ima.ima28,d_ima.ima31,d_ima.ima31_fac,d_ima.ima34,
           d_ima.ima35,d_ima.ima36,d_ima.ima37,d_ima.ima38,
           d_ima.ima39,d_ima.ima42,d_ima.ima43,d_ima.ima44,
           d_ima.ima44_fac,d_ima.ima45,d_ima.ima46,d_ima.ima47,
           d_ima.ima48,d_ima.ima49,d_ima.ima491,d_ima.ima50,
           d_ima.ima51,d_ima.ima52,d_ima.ima54,d_ima.ima55,
           d_ima.ima55_fac,d_ima.ima56,d_ima.ima561,d_ima.ima562,
           d_ima.ima59, d_ima.ima60,d_ima.ima61,d_ima.ima62,
           d_ima.ima63, d_ima.ima63_fac,d_ima.ima64,d_ima.ima641,
           d_ima.ima65, d_ima.ima66,d_ima.ima67,d_ima.ima68,
           d_ima.ima69, d_ima.ima70,d_ima.ima71,d_ima.ima86,
           d_ima.ima86_fac, d_ima.ima87,d_ima.ima871,d_ima.ima872,
           d_ima.ima873, d_ima.ima874,d_ima.ima88,d_ima.ima89,
           d_ima.ima90,d_ima.ima94,d_ima.ima99,d_ima.ima100,     
           d_ima.ima101,d_ima.ima102,d_ima.ima103,d_ima.ima105,  
           d_ima.ima106,d_ima.ima107,d_ima.ima108,d_ima.ima109,  
           d_ima.ima110,d_ima.ima130,d_ima.ima131,d_ima.ima132,  
           d_ima.ima134,                           
           d_ima.ima147,d_ima.ima148,d_ima.ima903,
           l_imaacti,l_imauser,l_imagrup,l_imamodu,l_imadate,
           d_ima.ima906,d_ima.ima907,d_ima.ima908,d_ima.ima909, 
           d_ima.ima911,                                        
           d_ima.ima918,d_ima.ima919,d_ima.ima920,               
           d_ima.ima921,d_ima.ima922,d_ima.ima923,               
           d_ima.ima924,d_ima.ima925,                            
           d_ima.ima136,d_ima.ima137,d_ima.ima391,d_ima.ima1321, 
           d_ima.ima915,d_ima.ima153,d_ima.ima601,              
           d_ima.ima926,                                        
           d_ima.ima156,d_ima.ima157,d_ima.ima158,              
           d_ima.ima022,d_ima.ima251,d_ima.ima159,              
           d_ima.ima163,d_ima.ima1631,d_ima.ima152,                          
           d_ima.ima150
           FROM  imz_file
           WHERE imz01 = g_ima[l_ac].ima06
  
   
   IF g_ima[l_ac].ima01[1,4]='MISC' THEN 
      LET d_ima.ima08='Z'
   END IF
  
   IF d_ima.ima918 = 'Y' OR d_ima.ima921 = 'Y' THEN
      IF cl_null(d_ima.ima925) THEN
         LET d_ima.ima925 = '1'
      END IF 
   END IF 
   
END FUNCTION

FUNCTION i100_batch_confirm()
  DEFINE l_i,l_n        LIKE type_file.num5

  LET l_n = 0
  LET g_success = 'N'
  FOR l_i = 1 TO g_rec_b
      CALL i100sub_y_chk(g_ima[l_i].ima01)
      IF g_success = 'Y' THEN 
         BEGIN WORK
         CALL i100sub_y_upd(g_ima[l_i].ima01)
         IF g_success = 'Y' THEN
            COMMIT WORK
         END IF
      END IF
  END FOR
  CALL cl_err('','afa-116',1)
  CALL i100_b_fill("1=2")
END FUNCTION

##----- 新增料件pdf 與 dwg 圖檔資訊
FUNCTION i100_a_file()
   DEFINE l_gca     RECORD LIKE gca_file.*
   DEFINE l_gcb     RECORD LIKE gcb_file.*
   DEFINE l_smaud02 LIKE sma_file.smaud02   #PDF路徑
   DEFINE l_smaud03 LIKE sma_file.smaud03   #DWG路徑
   
   ##---新增 pdf
   SELECT smaud02 INTO l_smaud02 FROM sma_file
   IF NOT cl_null(l_smaud02) THEN
      LET l_gca.gca01 = "ima01" || "=" || d_ima.ima01 CLIPPED
      LET l_gca.gca02 = ' '
      LET l_gca.gca03 = ' '
      LET l_gca.gca04 = ' '
      LET l_gca.gca05 = ' '
      LET l_gca.gca06 = 1
      LET l_gca.gca07 = "URL-pdf" || d_ima.ima01  CLIPPED
      LET l_gca.gca08 = "URL"
      LET l_gca.gca09 = "01"
      LET l_gca.gca10 = "001"
      LET l_gca.gca11 = "Y"
      LET l_gca.gca12 = d_ima.imauser
      LET l_gca.gca13 = d_ima.imagrup
      LET l_gca.gca14 = g_today
               
      INSERT INTO gca_file VALUES(l_gca.*)
      IF STATUS THEN
         CALL cl_err3("ins","gca_file",d_ima.ima01,"",SQLCA.sqlcode,"","",1)  
      END IF              　　 
      LET l_gcb.gcb01 = l_gca.gca07
      LET l_gcb.gcb02 = l_gca.gca08
      LET l_gcb.gcb05 = d_ima.ima01 CLIPPED || "-PDF"
      LET l_gcb.gcb10 = l_smaud02 || d_ima.ima01 || ".pdf"  
      LET l_gcb.gcb03 = "01"
      LET l_gcb.gcb04 = "001"
      LET l_gcb.gcb11 = "O"
      LET l_gcb.gcb12 = "U"
      LET l_gcb.gcb13 = g_user CLIPPED
      LET l_gcb.gcb14 = g_grup CLIPPED
      LET l_gcb.gcb15 = g_today CLIPPED
      INSERT INTO gcb_file(gcb01,gcb02,gcb03,gcb04,gcb05,gcb10,
                           gcb11,gcb12,gcb13,gcb14,gcb15,gcb16)
           VALUES (l_gcb.gcb01,l_gcb.gcb02,l_gcb.gcb03,l_gcb.gcb04,l_gcb.gcb05,
                   l_gcb.gcb10,
                   l_gcb.gcb11,l_gcb.gcb12,l_gcb.gcb13,l_gcb.gcb14,l_gcb.gcb15,
                   l_gcb.gcb16)
      IF STATUS THEN
         CALL cl_err3("ins","gcb_file",d_ima.ima01,"",SQLCA.sqlcode,"","",1)  
      END IF  
　 END IF
   ##---新增 dwg
      SELECT smaud03 INTO l_smaud03 FROM sma_file
      IF NOT cl_null(l_smaud03) THEN                              
         LET l_gca.gca01 = "ima01" || "=" || d_ima.ima01 CLIPPED
         LET l_gca.gca02 = ' '
         LET l_gca.gca03 = ' '
         LET l_gca.gca04 = ' '
         LET l_gca.gca05 = ' '
         LET l_gca.gca06 = 2
         LET l_gca.gca07 = "URL-dwg" || d_ima.ima01 CLIPPED
         LET l_gca.gca08 = "URL"
         LET l_gca.gca09 = "01"
         LET l_gca.gca10 = "001"
         LET l_gca.gca11 = "Y"
         LET l_gca.gca12 = d_ima.imauser
         LET l_gca.gca13 = d_ima.imagrup
         LET l_gca.gca14 = g_today
               
         INSERT INTO gca_file VALUES(l_gca.*)
         IF STATUS THEN
            CALL cl_err3("ins","gca_file",d_ima.ima01,"",SQLCA.sqlcode,"","",1)  
         END IF              　　 
               
         LET l_gcb.gcb01 = l_gca.gca07
         LET l_gcb.gcb02 = l_gca.gca08
         LET l_gcb.gcb05 = d_ima.ima01 CLIPPED || "-DWG"
         LET l_gcb.gcb10 = l_smaud03 || d_ima.ima01 || ".dwg"  
         LET l_gcb.gcb03 = "01"
         LET l_gcb.gcb04 = "001"
         LET l_gcb.gcb11 = "O"
         LET l_gcb.gcb12 = "U"
         LET l_gcb.gcb13 = g_user CLIPPED
         LET l_gcb.gcb14 = g_grup CLIPPED
         LET l_gcb.gcb15 = g_today CLIPPED
         INSERT INTO gcb_file(gcb01,gcb02,gcb03,gcb04,gcb05,gcb10,
                              gcb11,gcb12,gcb13,gcb14,gcb15,gcb16)
              VALUES (l_gcb.gcb01,l_gcb.gcb02,l_gcb.gcb03,l_gcb.gcb04,l_gcb.gcb05,
                      l_gcb.gcb10,
                      l_gcb.gcb11,l_gcb.gcb12,l_gcb.gcb13,l_gcb.gcb14,l_gcb.gcb15,
                      l_gcb.gcb16)
          IF STATUS THEN
             CALL cl_err3("ins","gcb_file",d_ima.ima01,"",SQLCA.sqlcode,"","",1)  
          END IF  
　　  END IF
              
END FUNCTION
