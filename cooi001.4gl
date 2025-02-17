# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cooi001.4gl
# Descriptions...: 動態下拉選單設定作業
# Date & Author..: 2022/01/13 By momo
# Modify 		 : 


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
    g_argv1         LIKE eca_file.eca01,
    g_tc_dic        DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
        tc_dic01    LIKE tc_dic_file.tc_dic01,   #程式編號
        tc_dic02    LIKE tc_dic_file.tc_dic02,   #
        tc_dic03    LIKE tc_dic_file.tc_dic03,   #
        tc_dic04    LIKE tc_dic_file.tc_dic04,   #
        tc_dic05    LIKE tc_dic_file.tc_dic05,   #
        tc_dicacti  LIKE tc_dic_file.tc_dicacti #
                    END RECORD,
    g_tc_dic_t         RECORD                    #程式變數 (舊值)
        tc_dic01    LIKE tc_dic_file.tc_dic01,   #程式編號
        tc_dic02    LIKE tc_dic_file.tc_dic02,   #
        tc_dic03    LIKE tc_dic_file.tc_dic03,   #
        tc_dic04    LIKE tc_dic_file.tc_dic04,   #
        tc_dic05    LIKE tc_dic_file.tc_dic05,   #
        tc_dicacti  LIKE tc_dic_file.tc_dicacti #
                    END RECORD,
    g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_tit           LIKE type_file.chr20,             #No.FUN-680102 VARCHAR(10),
    g_tit1          LIKE type_file.chr20,             #No.FUN-680102 VARCHAR(16),
    g_rec_b         LIKE type_file.num5,              #No.FUN-680102 SMALLINT,              #單身筆數
    l_ac            LIKE type_file.num5               #No.FUN-680102 SMALLINT               #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING                            #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt        LIKE type_file.num10              #No.FUN-680102 INTEGER   
DEFINE g_i          LIKE type_file.num5               #No.FUN-680102 SMALLINT   #count/index for any purpose
DEFINE l_table      STRING                            #No.FUN-850016                                                                    
DEFINE g_str        STRING                            #No.FUN-850016                                                                    
DEFINE g_prog1      STRING                            #No.FUN-850016    

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1   = ARG_VAL(1) 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("COO")) THEN
      EXIT PROGRAM
   END IF
                                                                                                                      

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW i001_w WITH FORM "coo/42f/cooi001"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("cooi001")
   CALL cl_ui_init()
 

   LET g_wc2 = "  " 
 
   #No.FUN-D40121 ---Add--- Start
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 =g_wc2 CLIPPED, "  AND tc_dic01 ='",g_argv1 CLIPPED,"' " 
    END IF
   #No.FUN-D40121 ---Add--- End
 
   CALL i001_b_fill(g_wc2)
 
   CALL i001_menu()
 
   CLOSE WINDOW i001_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i001_menu()
 
   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
        
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_dic),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i001_q()
 
   CALL i001_b_askkey()
 
END FUNCTION
 
FUNCTION i001_b()
   DEFINE l_ac_t          LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #檢查重複用
          l_lock_sw       LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),            #單身鎖住否
          p_cmd           LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),            #處理狀態
          l_allow_insert  LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #可新增否
          l_allow_delete  LIKE type_file.num5      #No.FUN-680102 SMALLINT               #可刪除否
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
                    
   LET g_forupd_sql = " SELECT tc_dic01,tc_dic02,tc_dic03,tc_dic04,tc_dic05,tc_dicacti ",   
                      "   FROM tc_dic_file ",  
                      "  WHERE tc_dic01= ? AND tc_dic02= ? AND tc_dic03 = ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_tc_dic WITHOUT DEFAULTS FROM s_tc_dic.*
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
            LET g_tc_dic_t.* = g_tc_dic[l_ac].*  #BACKUP
            OPEN i001_bcl USING g_tc_dic_t.tc_dic01,g_tc_dic_t.tc_dic02,g_tc_dic_t.tc_dic03
            IF STATUS THEN
               CALL cl_err("OPEN i001_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i001_bcl INTO g_tc_dic[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tc_dic_t.tc_dic01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  
                  UPDATE tc_dic_file
                     SET tc_dic02 = g_tc_dic[l_ac].tc_dic02,
                         tc_dic01 = g_tc_dic[l_ac].tc_dic01,
                         tc_dic03 = g_tc_dic[l_ac].tc_dic03,
                         tc_dic04 = g_tc_dic[l_ac].tc_dic04,
                         tc_dic05 = g_tc_dic[l_ac].tc_dic05,
                         tc_dicacti = g_tc_dic[l_ac].tc_dicacti
                   WHERE tc_dic02 = g_tc_dic[l_ac].tc_dic02
                     AND tc_dic01 = g_tc_dic[l_ac].tc_dic01
                     AND tc_dic03 = g_tc_dic[l_ac].tc_dic03
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","tc_dic_file",g_tc_dic_t.tc_dic01,"",SQLCA.sqlcode,"","",1)
                  END IF
               
                  DISPLAY BY NAME g_tc_dic[l_ac].tc_dic01
                  DISPLAY BY NAME g_tc_dic[l_ac].tc_dic02
                  DISPLAY BY NAME g_tc_dic[l_ac].tc_dic03
                  DISPLAY BY NAME g_tc_dic[l_ac].tc_dic04
                  DISPLAY BY NAME g_tc_dic[l_ac].tc_dic05
                  DISPLAY BY NAME g_tc_dic[l_ac].tc_dicacti
                  
               END IF
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET l_ac = g_rec_b + 1
         LET p_cmd = 'a'
         INITIALIZE g_tc_dic[l_ac].* TO NULL      
        
         LET g_tc_dic_t.* = g_tc_dic[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()    
         NEXT FIELD tc_dic01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO tc_dic_file(tc_dic01,tc_dic02,tc_dic03,tc_dic04,tc_dic05,tc_dicacti) 
                       VALUES(g_tc_dic[l_ac].tc_dic01,g_tc_dic[l_ac].tc_dic02,
                              g_tc_dic[l_ac].tc_dic03,g_tc_dic[l_ac].tc_dic04,
                              g_tc_dic[l_ac].tc_dic05,g_tc_dic[l_ac].tc_dicacti
                             )  
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_dic_file",g_tc_dic[l_ac].tc_dic01,"",SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
     AFTER FIELD tc_dic01
         IF NOT cl_null(g_tc_dic[l_ac].tc_dic01) THEN
         END IF

      AFTER FIELD tc_dic02                       

      AFTER FIELD tc_dic03
         IF cl_null(g_tc_dic[l_ac].tc_dic03) THEN
            SELECT MAX(tc_dic03)+1 INTO g_tc_dic[l_ac].tc_dic03
              FROM tc_dic_file
             WHERE tc_dic01 = g_tc_dic[l_ac].tc_dic01
               AND tc_dic02 = g_tc_dic[l_ac].tc_dic02     
            IF cl_null(g_tc_dic[l_ac].tc_dic03) THEN
               LET g_tc_dic[l_ac].tc_dic03 = 1 
            END IF       
         END IF

      BEFORE FIELD tc_dicacti
         IF cl_null(g_tc_dic[l_ac].tc_dicacti) THEN
            LET g_tc_dic[l_ac].tc_dicacti = 'Y'
         END IF

 
      BEFORE DELETE                            #是否取消單身
         IF g_tc_dic_t.tc_dic01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM tc_dic_file WHERE tc_dic01 = g_tc_dic[l_ac].tc_dic01
                                      AND tc_dic02 = g_tc_dic[l_ac].tc_dic02
                                      AND tc_dic03 = g_tc_dic[l_ac].tc_dic03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tc_dic_file",g_tc_dic_t.tc_dic01,"",SQLCA.sqlcode,"","",1) 
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
            LET g_tc_dic[l_ac].* = g_tc_dic_t.*
            CLOSE i001_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tc_dic[l_ac].tc_dic01,-263,1)
            LET g_tc_dic[l_ac].* = g_tc_dic_t.*
         ELSE
           
            UPDATE tc_dic_file SET tc_dic01=g_tc_dic[l_ac].tc_dic01,
                                   tc_dic02=g_tc_dic[l_ac].tc_dic02,
                                   tc_dic03=g_tc_dic[l_ac].tc_dic03,
                                   tc_dic04=g_tc_dic[l_ac].tc_dic04,
                                   tc_dic05=g_tc_dic[l_ac].tc_dic05,
                                   tc_dicacti = g_tc_dic[l_ac].tc_dicacti
             WHERE tc_dic02 = g_tc_dic_t.tc_dic02
               AND tc_dic01 = g_tc_dic_t.tc_dic01 
               AND tc_dic03 = g_tc_dic_t.tc_dic03 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tc_dic_file",g_tc_dic_t.tc_dic02,g_tc_dic_t.tc_dic01,SQLCA.sqlcode,"","",1) 
               LET g_tc_dic[l_ac].* = g_tc_dic_t.*
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
               LET g_tc_dic[l_ac].* = g_tc_dic_t.*              

            ELSE
               CALL g_tc_dic.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            CLOSE i001_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      
         CLOSE i001_bcl
         COMMIT WORK
 
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tc_dic01) AND l_ac > 1 THEN
            LET g_tc_dic[l_ac].* = g_tc_dic[l_ac-1].*
            NEXT FIELD tc_dic01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
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
 
   CLOSE i001_bcl
 
   COMMIT WORK
 
END FUNCTION
 

FUNCTION i001_b_askkey()
 
    CLEAR FORM
    CALL g_tc_dic.clear()
 
    CONSTRUCT g_wc2 ON tc_dic01,tc_dic02,tc_dic04,tc_dic05,tc_dicacti
         FROM s_tc_dic[1].tc_dic01,s_tc_dic[1].tc_dic02,
              s_tc_dic[1].tc_dic04,s_tc_dic[1].tc_dic05,s_tc_dic[1].tc_dicacti
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
       
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
       
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
    
         #No.FUN-580031 --start--     HCN
         ON ACTION qbe_select
            CALL cl_qbe_select() 
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 --end--       HCN
    END CONSTRUCT

 
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       LET g_rec_b = 0  #MOD-D60241
       RETURN 
    END IF
 
    LET g_wc2 =g_wc2 CLIPPED, "  " 
   
    CALL i001_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i001_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT tc_dic01,tc_dic02,tc_dic03,tc_dic04,tc_dic05,tc_dicacti ",   
               "  FROM tc_dic_file ",                                        
               " WHERE  ", p_wc2 CLIPPED ,                    #單身
               " ORDER BY 1,2,3 "
   PREPARE i001_pb FROM g_sql
   DECLARE dic_curs CURSOR FOR i001_pb

 
   CALL g_tc_dic.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH dic_curs INTO g_tc_dic[g_cnt].*   #單身 ARRAY 填充
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
 
   CALL g_tc_dic.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_dic TO s_tc_dic.* ATTRIBUTE(COUNT=g_rec_b)
 
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
