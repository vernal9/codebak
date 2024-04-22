# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cooi103.4gl
# Descriptions...: 取替代可用不可用設定作業
# Date & Author..: 2020/01/30 By momo
# Modify 		 : 2001204176


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
    g_argv1         LIKE boa_file.boa01,       #上階主件
    g_argv2         LIKE boa_file.boa02,       #元件群組
    g_boa01         LIKE boa_file.boa01,
    g_boa02         LIKE boa_file.boa02,
    g_boa01_t       LIKE azf_file.azf02,
    g_tc_aad        DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_aad01     LIKE tc_aad_file.tc_aad01,      #料號
        tc_aad02     LIKE tc_aad_file.tc_aad02,      #導程
        tc_aad03     LIKE tc_aad_file.tc_aad03,      #系列別
        azf03        LIKE azf_file.azf03,            #描述
        tc_aad04     LIKE tc_aad_file.tc_aad04,      #包含/排除
        tc_aaduser   LIKE tc_aad_file.tc_aaduser,    #資料所有者  
        gen02        LIKE gen_file.gen02,            #姓名 
        tc_aaddate   LIKE tc_aad_file.tc_aaddate,    #修改日
        tc_addcreate LIKE tc_aad_file.tc_aadcreate   #建立日
                    END RECORD,
    g_tc_aad_t         RECORD                  #程式變數 (舊值)
        tc_aad01     LIKE tc_aad_file.tc_aad01,      #料號
        tc_aad02     LIKE tc_aad_file.tc_aad02,      #導程
        tc_aad03     LIKE tc_aad_file.tc_aad03,      #系列別
        azf03        LIKE azf_file.azf03,            #描述
        tc_aad04     LIKE tc_aad_file.tc_aad04,      #包含/排除
        tc_aaduser   LIKE tc_aad_file.tc_aaduser,    #資料所有者  
        gen02        LIKE gen_file.gen02,            #姓名 
        tc_aaddate   LIKE tc_aad_file.tc_aaddate,    #修改日
        tc_addcreate LIKE tc_aad_file.tc_aadcreate   #建立日
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
   LET g_argv2   = ARG_VAL(2)   #No.FUN-D40121   Add
   LET g_boa01   = g_argv1
   LET g_boa02   = g_argv2
   LET g_boa01_t = g_boa01
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("COO")) THEN
      EXIT PROGRAM
   END IF
                                                                                                                      

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW i300_w WITH FORM "coo/42f/cooi103"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("cooi103")
   CALL cl_ui_init()
 
 
   #No.FUN-D40121 ---Add--- Start
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 =g_wc2 CLIPPED, "  tc_aad01 ='",g_argv1 CLIPPED,"' AND tc_aad02 ='",g_argv2 CLIPPED,"' " 
    END IF
   #No.FUN-D40121 ---Add--- End
 
   CALL i103_b_fill(g_wc2)
 
   CALL i103_menu()
 
   CLOSE WINDOW i300_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i103_menu()
 
   WHILE TRUE
      CALL i103_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i103_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i103_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_aad),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i103_q()
 
   CALL i103_b_askkey()
 
END FUNCTION
 
FUNCTION i103_b()
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
 
                     
   LET g_forupd_sql = " SELECT tc_aad01,tc_aad02,tc_aad03,'',tc_aad04,tc_aaduser,'',tc_aaddate,tc_aadcreate ",   
                      "        FROM tc_aad_file ",  
                      "  WHERE tc_aad01= ? AND tc_aad02= ? AND tc_aad03=?  FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i103_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_tc_aad WITHOUT DEFAULTS FROM s_tc_aad.*
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
            LET g_tc_aad_t.* = g_tc_aad[l_ac].*  #BACKUP
            OPEN i103_bcl USING g_tc_aad_t.tc_aad01,g_tc_aad_t.tc_aad02,g_tc_aad_t.tc_aad03
            IF STATUS THEN
               CALL cl_err("OPEN i103_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i103_bcl INTO g_tc_aad[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tc_aad_t.tc_aad01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  UPDATE tc_aad_file
                     SET tc_aad02 = g_tc_aad[l_ac].tc_aad02,
                         tc_aad03 = g_tc_aad[l_ac].tc_aad03,
                         tc_aad04 = g_tc_aad[l_ac].tc_aad04,
                         tc_aaduser = g_user,
                         tc_aaddate = g_today
                   WHERE tc_aad01 = g_tc_aad[l_ac].tc_aad01
                     AND tc_aad02 = g_tc_aad[l_ac].tc_aad02
                     AND tc_aad03 = g_tc_aad[l_ac].tc_aad03
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","tc_aad_file",g_tc_aad_t.tc_aad01,"",SQLCA.sqlcode,"","",1)
                  END IF
               
                  DISPLAY BY NAME g_tc_aad[l_ac].tc_aad02
                  DISPLAY BY NAME g_tc_aad[l_ac].tc_aad03
                  DISPLAY BY NAME g_tc_aad[l_ac].tc_aad04
                  DISPLAY BY NAME g_tc_aad[l_ac].tc_aaduser
                  DISPLAY BY NAME g_tc_aad[l_ac].tc_aaddate
                  
               END IF
            END IF
            CALL cl_show_fld_cont()  
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_tc_aad[l_ac].* TO NULL      
         IF NOT cl_null(g_argv1) THEN
            LET g_tc_aad[l_ac].tc_aad01 = g_argv1
            LET g_tc_aad[l_ac].tc_aad02 = g_argv2
         END IF
        
         LET g_tc_aad_t.* = g_tc_aad[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()  
         NEXT FIELD tc_aad01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO tc_aad_file(tc_aad01,tc_aad02,tc_aad03,tc_aad04,tc_aaduser,tc_aaddate,tc_aadcreate) 
                       VALUES(g_tc_aad[l_ac].tc_aad01,g_tc_aad[l_ac].tc_aad02,
                              g_tc_aad[l_ac].tc_aad03,g_tc_aad[l_ac].tc_aad04,
                              g_user,g_today,g_today)  
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_aad_file",g_tc_aad[l_ac].tc_aad01,"",SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      AFTER FIELD tc_aad02
         IF cl_null(g_tc_aad[l_ac].tc_aad02) THEN
            NEXT FIELD tc_aad02
         END IF
 
      AFTER FIELD tc_aad03                        #check 編號是否重複
         IF NOT cl_null(g_tc_aad[l_ac].tc_aad03) THEN
            IF g_tc_aad[l_ac].tc_aad03 != g_tc_aad_t.tc_aad03 
               OR g_tc_aad_t.tc_aad03 IS NULL THEN
               SELECT azf03 INTO g_tc_aad[l_ac].azf03 FROM azf_file
                WHERE azf01 = g_tc_aad[l_ac].tc_aad03
                  AND azf02 = 'D'
               IF cl_null(g_tc_aad[l_ac].azf03 ) THEN
                  CALL cl_err(g_tc_aad[l_ac].tc_aad03,'aic-004',0)
                  LET g_tc_aad[l_ac].azf03 = g_tc_aad_t.azf03
                  NEXT FIELD tc_aad03
               END IF
            END IF
         END IF

      AFTER FIELD tc_aad04
         IF g_tc_aad[l_ac].tc_aad04 NOT MATCHES "[YN]" THEN
            NEXT FIELD tc_aad04
         END IF

 
      BEFORE DELETE                            #是否取消單身
         IF g_tc_aad_t.tc_aad01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM tc_aad_file WHERE tc_aad01 = g_tc_aad_t.tc_aad01
                                      AND tc_aad02 = g_tc_aad_t.tc_aad02
                                      AND tc_aad03 = g_tc_aad_t.tc_aad03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tc_aad_file",g_tc_aad_t.tc_aad01,"",SQLCA.sqlcode,"","",1) 
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
            LET g_tc_aad[l_ac].* = g_tc_aad_t.*
            CLOSE i103_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tc_aad[l_ac].tc_aad01,-263,1)
            LET g_tc_aad[l_ac].* = g_tc_aad_t.*
         ELSE
            UPDATE tc_aad_file SET tc_aad01=g_tc_aad[l_ac].tc_aad01,
                                   tc_aad02=g_tc_aad[l_ac].tc_aad02,
                                   tc_aad03=g_tc_aad[l_ac].tc_aad03, 
                                   tc_aad04=g_tc_aad[l_ac].tc_aad04,     
                                   tc_aaduser = g_user,
                                   tc_aaddate = g_today                           
             WHERE tc_aad01 = g_tc_aad_t.tc_aad01
               AND tc_aad02 = g_tc_aad_t.tc_aad02
               AND tc_aad03 = g_tc_aad_t.tc_aad03 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tc_aad_file",g_tc_aad_t.tc_aad01,g_tc_aad_t.tc_aad02,SQLCA.sqlcode,"","",1)  
               LET g_tc_aad[l_ac].* = g_tc_aad_t.*
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
               LET g_tc_aad[l_ac].* = g_tc_aad_t.*              

            #FUN-D40030--add--str--
            ELSE
               CALL g_tc_aad.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE i103_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D40030 Add
         CLOSE i103_bcl
         COMMIT WORK
 
      #FUN-510041 add
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(tc_aad03)      
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azf" 
                LET g_qryparam.default1 = g_tc_aad[l_ac].tc_aad03
                LET g_qryparam.arg1 = 'D'
                CALL cl_create_qry() RETURNING g_tc_aad[l_ac].tc_aad03
                DISPLAY BY NAME g_tc_aad[l_ac].tc_aad03
                NEXT FIELD tc_aad03
              WHEN INFIELD(tc_aad01)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_boa01"
                LET g_qryparam.default1 = g_tc_aad[l_ac].tc_aad01
                CALL cl_create_qry() RETURNING g_tc_aad[l_ac].tc_aad01,g_tc_aad[l_ac].tc_aad02
                DISPLAY BY NAME g_tc_aad[l_ac].tc_aad01
                DISPLAY BY NAME g_tc_aad[l_ac].tc_aad02
                NEXT FIELD tc_aad02
             OTHERWISE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tc_aad01) AND l_ac > 1 THEN
            LET g_tc_aad[l_ac].* = g_tc_aad[l_ac-1].*
            NEXT FIELD tc_aad01
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
     
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      #No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
      #No.FUN-6B0030-----End------------------     
 
   END INPUT
 
   CLOSE i103_bcl
 
   COMMIT WORK
 
END FUNCTION
 

FUNCTION i103_b_askkey()
 
    CLEAR FORM
    CALL g_tc_aad.clear()
 
    CONSTRUCT g_wc2 ON tc_aad01,tc_aad02,tc_aad03,tc_aad04
         FROM s_tc_aad[1].tc_aad01,s_tc_aad[1].tc_aad02,s_tc_aad[1].tc_aad03,s_tc_aad[1].tc_aad04
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
        #FUN-510041 add 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(tc_aad03)
                 LET g_qryparam.form = "q_azf"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_aad[1].tc_aad03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_aad03
               WHEN INFIELD(tc_aad01)
                 LET g_qryparam.form = "q_boa01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_aad[1].tc_aad01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_aad01
              OTHERWISE
           END CASE
         ##
 
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
 
    #LET g_wc2 =g_wc2 CLIPPED, "  AND azf02 ='D' " 
    LET g_wc2 =g_wc2 CLIPPED
   
    CALL i103_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i103_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT tc_aad01,tc_aad02,tc_aad03,azf03,tc_aad04,tc_aaduser,gen02,tc_aaddate,tc_aadcreate ",        
               "  FROM tc_aad_file,azf_file,gen_file ",                                        
               " WHERE tc_aad03=azf01 AND tc_aaduser=gen01 AND azf02='D' AND ", p_wc2 CLIPPED,                     #單身
               " ORDER BY tc_aad01 "
   PREPARE i103_pb FROM g_sql
   DECLARE azf_curs CURSOR FOR i103_pb
 
   CALL g_tc_aad.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH azf_curs INTO g_tc_aad[g_cnt].*   #單身 ARRAY 填充
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
 
   CALL g_tc_aad.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i103_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_aad TO s_tc_aad.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
