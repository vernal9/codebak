# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cooi300.4gl
# Descriptions...: 分群碼一PM設定作業
# Date & Author..: 2018/08/30 By momo
# Modify 		 : 94/12/05 by Nick (Convert to Multiline Task)


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
    g_argv1         LIKE azf_file.azf02,
    g_argv2         LIKE azf_file.azf01,   #No.FUN-D40121   Add
    g_azf02         LIKE azf_file.azf02,
    g_azf02_t       LIKE azf_file.azf02,
    g_tc_azf        DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_azf01    LIKE tc_azf_file.tc_azf01, #編號
        azf03       LIKE azf_file.azf03,       #描述
        tc_azf02    LIKE tc_azf_file.tc_azf02, #PM工號   
        gen02       LIKE gen_file.gen02        #姓名  
                    END RECORD,
    g_tc_azf_t         RECORD                  #程式變數 (舊值)
        tc_azf01    LIKE tc_azf_file.tc_azf01, #編號
        azf03       LIKE azf_file.azf03,       #描述
        tc_azf02    LIKE tc_azf_file.tc_azf02, #PM工號   
        gen02       LIKE gen_file.gen02        #姓名   
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
   LET g_azf02   = g_argv1
   LET g_azf02_t = g_azf02
   LET g_argv2   = ARG_VAL(2)   #No.FUN-D40121   Add
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("COO")) THEN
      EXIT PROGRAM
   END IF
                                                                                                                      

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW i300_w WITH FORM "coo/42f/cooi300"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("cooi300")
   CALL cl_ui_init()
 

   DISPLAY g_azf02 TO azf02
   LET g_wc2 = " azf02 ='D' " 
 
   #No.FUN-D40121 ---Add--- Start
    IF NOT cl_null(g_argv2) THEN
       LET g_wc2 =g_wc2 CLIPPED, "  AND tc_azf01 ='",g_argv2 CLIPPED,"' " 
    END IF
   #No.FUN-D40121 ---Add--- End
 
   CALL i300_b_fill(g_wc2)
 
   CALL i300_menu()
 
   CLOSE WINDOW i300_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i300_menu()
 
   WHILE TRUE
      CALL i300_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i300_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i300_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_azf),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i300_q()
 
   CALL i300_b_askkey()
 
END FUNCTION
 
FUNCTION i300_b()
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
 
                      #FUN-510041 add azf05
   LET g_forupd_sql = " SELECT tc_azf01,'',tc_azf02,''",   
                      "        FROM tc_azf_file ",  
                      "  WHERE tc_azf02= ? AND tc_azf01= ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_tc_azf WITHOUT DEFAULTS FROM s_azf.*
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
            LET g_tc_azf_t.* = g_tc_azf[l_ac].*  #BACKUP
            OPEN i300_bcl USING g_tc_azf_t.tc_azf02,g_tc_azf_t.tc_azf01
            IF STATUS THEN
               CALL cl_err("OPEN i300_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i300_bcl INTO g_tc_azf[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tc_azf_t.tc_azf01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  #No.FUN-DA0099 add Begin
                  UPDATE tc_azf_file
                     SET tc_azf02 = g_tc_azf[l_ac].tc_azf02
                   WHERE tc_azf02 = g_tc_azf[l_ac].tc_azf02
                     AND tc_azf01 = g_tc_azf[l_ac].tc_azf01
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","tc_azf_file",g_tc_azf_t.tc_azf01,"",SQLCA.sqlcode,"","",1)
                  END IF
               
                  DISPLAY BY NAME g_tc_azf[l_ac].tc_azf02

                                    
                 #---------------------MOD-DC0047-----------(E)

                  #No.FUN-DA0099 add End

                  
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_tc_azf[l_ac].* TO NULL      #900423
        
         LET g_tc_azf_t.* = g_tc_azf[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD tc_azf01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO tc_azf_file(tc_azf01,tc_azf02) 
                       VALUES(g_tc_azf[l_ac].tc_azf01,g_tc_azf[l_ac].tc_azf02)  
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_azf_file",g_tc_azf[l_ac].tc_azf01,"",SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD tc_azf01                        #check 編號是否重複
         IF NOT cl_null(g_tc_azf[l_ac].tc_azf01) THEN
            IF g_tc_azf[l_ac].tc_azf01 != g_tc_azf_t.tc_azf01 
               OR g_tc_azf_t.tc_azf01 IS NULL THEN
               SELECT azf03 INTO g_tc_azf[l_ac].azf03 FROM azf_file
                WHERE azf01 = g_tc_azf[l_ac].tc_azf01
                  AND azf02 = 'D'
               IF cl_null(g_tc_azf[l_ac].azf03 ) THEN
                  CALL cl_err(g_tc_azf[l_ac].tc_azf01,'aic-004',0)
                  LET g_tc_azf[l_ac].tc_azf01 = g_tc_azf_t.tc_azf01
                  NEXT FIELD tc_azf01
               END IF
            END IF
         END IF

     AFTER FIELD tc_azf02                        #
         IF NOT cl_null(g_tc_azf[l_ac].tc_azf02) THEN
            IF g_tc_azf[l_ac].tc_azf02 != g_tc_azf_t.tc_azf02
               OR g_tc_azf_t.tc_azf02 IS NULL THEN
               SELECT gen02 INTO g_tc_azf[l_ac].gen02 FROM gen_file
                WHERE gen01 = g_tc_azf[l_ac].tc_azf02
               IF cl_null(g_tc_azf[l_ac].gen02 ) THEN
                  CALL cl_err(g_tc_azf[l_ac].gen02,'aic-004',0)
                  LET g_tc_azf[l_ac].tc_azf02 = g_tc_azf_t.tc_azf02
                  NEXT FIELD tc_azf02
               END IF
            END IF
         END IF

  
 
      BEFORE DELETE                            #是否取消單身
         IF g_tc_azf_t.tc_azf01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM tc_azf_file WHERE tc_azf01 = g_tc_azf_t.tc_azf01
                                      AND tc_azf02 = g_tc_azf_t.tc_azf02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tc_azf_file",g_tc_azf_t.tc_azf01,"",SQLCA.sqlcode,"","",1) 
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
            LET g_tc_azf[l_ac].* = g_tc_azf_t.*
            CLOSE i300_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tc_azf[l_ac].tc_azf01,-263,1)
            LET g_tc_azf[l_ac].* = g_tc_azf_t.*
         ELSE
           

            UPDATE tc_azf_file SET tc_azf01=g_tc_azf[l_ac].tc_azf01,
                                tc_azf02=g_tc_azf[l_ac].tc_azf02
             WHERE tc_azf02 = g_tc_azf_t.tc_azf02
               AND tc_azf01 = g_tc_azf_t.tc_azf01 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tc_azf_file",g_tc_azf_t.tc_azf02,g_tc_azf_t.tc_azf01,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_tc_azf[l_ac].* = g_tc_azf_t.*
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
               LET g_tc_azf[l_ac].* = g_tc_azf_t.*              

            #FUN-D40030--add--str--
            ELSE
               CALL g_tc_azf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE i300_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D40030 Add
         CLOSE i300_bcl
         COMMIT WORK
 
      #FUN-510041 add
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(tc_azf01)      
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azf" 
                LET g_qryparam.default1 = g_tc_azf[l_ac].tc_azf01
                LET g_qryparam.arg1 = 'D'
                CALL cl_create_qry() RETURNING g_tc_azf[l_ac].tc_azf01
                DISPLAY BY NAME g_tc_azf[l_ac].tc_azf01
                NEXT FIELD tc_azf01
              WHEN INFIELD(tc_azf02)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gen"
                LET g_qryparam.default1 = g_tc_azf[l_ac].tc_azf02
                CALL cl_create_qry() RETURNING g_tc_azf[l_ac].tc_azf02
                DISPLAY BY NAME g_tc_azf[l_ac].tc_azf02
                NEXT FIELD tc_azf02
             OTHERWISE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tc_azf01) AND l_ac > 1 THEN
            LET g_tc_azf[l_ac].* = g_tc_azf[l_ac-1].*
            NEXT FIELD tc_azf01
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
 
   CLOSE i300_bcl
 
   COMMIT WORK
 
END FUNCTION
 

FUNCTION i300_b_askkey()
 
    CLEAR FORM
    CALL g_tc_azf.clear()
 
    CONSTRUCT g_wc2 ON tc_azf01,tc_azf02
         FROM s_azf[1].tc_azf01,s_azf[1].tc_azf02
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
              WHEN INFIELD(tc_azf01)
                 LET g_qryparam.form = "q_azf"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_azf[1].tc_azf01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_azf01
               WHEN INFIELD(tc_azf02)
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_azf[1].tc_azf02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_azf02
              
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
 
    LET g_wc2 =g_wc2 CLIPPED, "  AND azf02 ='D' " 
   
    CALL i300_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i300_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT tc_azf01,azf03,tc_azf02,gen02",   
               "  FROM tc_azf_file,azf_file,gen_file ",                                        
               " WHERE tc_azf01=azf01 AND tc_azf02=gen01 AND azf02='D' AND ", p_wc2 CLIPPED,                     #單身
               " ORDER BY tc_azf01"
   PREPARE i300_pb FROM g_sql
   DECLARE azf_curs CURSOR FOR i300_pb
 
   CALL g_tc_azf.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH azf_curs INTO g_tc_azf[g_cnt].*   #單身 ARRAY 填充
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
 
   CALL g_tc_azf.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_azf TO s_azf.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
