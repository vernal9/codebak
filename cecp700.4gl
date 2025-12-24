# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cecp700.4gl
# Descriptions...: 報工單批次建立作業
# Date & Author..: 2024/04/25 By momo
# Modify 		 : 


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE d_shb         RECORD LIKE shb_file.* 
DEFINE g_ecm         RECORD LIKE ecm_file.*
DEFINE 
    g_argv1         LIKE shb_file.shb01,       #上階主件
    g_shb06         LIKE shb_file.shb06,
    g_shb01_t       LIKE shb_file.shb01,
    g_shb        DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        shb04     LIKE shb_file.shb04,      #員工編號
        gen02     LIKE gen_file.gen02,      #姓名
        shb05     LIKE shb_file.shb05,      #工單編號
        shb10     LIKE shb_file.shb10,      #生產料件
        ima02     LIKE ima_file.ima02,      #品名
        ima021    LIKE ima_file.ima021,   #規格
        shb06    LIKE shb_file.shb06,       #製程序號
        shb08     LIKE shb_file.shb08,      #線/班別
        shb09     LIKE shb_file.shb09,      #機台編號
        shb02     LIKE shb_file.shb02,      #開工日期
        shb021    LIKE shb_file.shb021,   #開工時間
        shb03     LIKE shb_file.shb03,      #完工日期
        shb031    LIKE shb_file.shb031,   #完工時間
        shb032    LIKE shb_file.shb032,   #投入工時
        shb033    LIKE shb_file.shb033,   #投入機時
        shb111    LIKE shb_file.shb111,   #良品轉出數量
        shb01     LIKE shb_file.shb01       #報工單號   
                END RECORD,
    g_shb_t     RECORD                      #程式變數 (舊值)
        shb04     LIKE shb_file.shb04,      #員工編號
        gen02     LIKE gen_file.gen02,      #姓名
        shb05     LIKE shb_file.shb05,      #工單編號
        shb10     LIKE shb_file.shb10,      #生產料件
        ima02     LIKE ima_file.ima02,      #品名
        ima021    LIKE ima_file.ima021,   #規格
        shb06    LIKE shb_file.shb06,       #製程序號
        shb08     LIKE shb_file.shb08,      #線/班別
        shb09     LIKE shb_file.shb09,      #機台編號
        shb02     LIKE shb_file.shb02,      #開工日期
        shb021    LIKE shb_file.shb021,   #開工時間
        shb03     LIKE shb_file.shb03,      #完工日期
        shb031    LIKE shb_file.shb031,   #完工時間
        shb032    LIKE shb_file.shb032,   #投入工時
        shb033    LIKE shb_file.shb033,   #投入機時
        shb111    LIKE shb_file.shb111,   #良品轉出數量
        shb01     LIKE shb_file.shb01       #報工單號         
                END RECORD,
    g_wc2,g_sql    string,  
    g_tit           LIKE type_file.chr20,             #
    g_tit1          LIKE type_file.chr20,             #
    g_rec_b      LIKE type_file.num5,              #單身筆數
    l_ac            LIKE type_file.num5               #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING                            #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt        LIKE type_file.num10              #  
DEFINE g_i          LIKE type_file.num5               ##count/index for any purpose
DEFINE l_table      STRING                            #                                                                  
DEFINE g_str        STRING                            #                                                                 
DEFINE g_prog1      STRING                            #
DEFINE l_cnt        LIKE type_file.num10
DEFINE g_yy         LIKE type_file.num5    
DEFINE g_mm         LIKE type_file.num5    


MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1   = ARG_VAL(1) 
   LET g_shb06   = g_argv1
  
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("cec")) THEN
      EXIT PROGRAM
   END IF
                                                                                                                      

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW i300_w WITH FORM "cec/42f/cecp700"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("cecp700")
   CALL cl_ui_init()
 
 
   CALL p700_b_fill(g_wc2)
 
   CALL p700_menu()
 
   CLOSE WINDOW i300_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p700_menu()
 
   WHILE TRUE
      CALL p700_bp("G")
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p700_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL p700_batch_confirm()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_shb),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
 
FUNCTION p700_b()
   DEFINE l_ac_t          LIKE type_file.num5,     
          l_n             LIKE type_file.num5,     
          l_lock_sw       LIKE type_file.chr1,     #單身鎖住否
          p_cmd           LIKE type_file.chr1,     #處理狀態
          l_allow_insert  LIKE type_file.num5,     #可新增否
          l_allow_delete  LIKE type_file.num5      #可刪除否
   DEFINE l_shb02         LIKE shb_file.shb02
   DEFINE l_shb021        LIKE shb_file.shb021   
   DEFINE l_shb031        LIKE shb_file.shb031 
   DEFINE l_shb032_1      LIKE shb_file.shb032
   DEFINE l_shb033_1      LIKE shb_file.shb033
   DEFINE l_day,l_min,l_hh,l_mm LIKE type_file.num5
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
                     
   LET g_forupd_sql = " SELECT shb01,shb02,shb021 ",   
                      "        FROM shb_file ",  
                      "  WHERE shb01= ?  FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p700_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_shb WITHOUT DEFAULTS FROM s_shb.*
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
            LET g_shb_t.* = g_shb[l_ac].*  #BACKUP
            OPEN p700_bcl USING g_shb_t.shb01
            IF STATUS THEN
               CALL cl_err("OPEN p700_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH p700_bcl INTO g_shb[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_shb_t.shb01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  UPDATE shb_file
                     SET shb04  = g_shb[l_ac].shb04,
                         shb05  = g_shb[l_ac].shb05,
                         shb10  = g_shb[l_ac].shb10,
                         shb06  = g_shb[l_ac].shb06,
                         shb08  = g_shb[l_ac].shb08,
                         shb09  = g_shb[l_ac].shb09,
                         shb02  = g_shb[l_ac].shb02,
                         shb021 = g_shb[l_ac].shb021,
                         shb03  = g_shb[l_ac].shb03,
                         shb031 = g_shb[l_ac].shb031,
                         shb032 = g_shb[l_ac].shb032,
                         shb033 = g_shb[l_ac].shb033,
                         shb111 = g_shb[l_ac].shb111
                   WHERE shb01 = g_shb_t.shb01
                     
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","shb_file",g_shb_t.shb01,"",SQLCA.sqlcode,"","",1)
                  END IF
                  
               END IF
            END IF
            CALL cl_show_fld_cont()  
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_shb[l_ac].* TO NULL      
         INITIALIZE d_shb.* TO NULL
         LET g_shb_t.* = g_shb[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()  
         NEXT FIELD shb01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF NOT p700_a_ins() THEN 
            ROLLBACK WORK
            CANCEL INSERT
         END IF
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","shb_file",g_shb[l_ac].shb01,"",SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      AFTER FIELD shb04
        IF NOT cl_null(g_shb[l_ac].shb04) THEN
           SELECT gen02 INTO g_shb[l_ac].gen02
             FROM gen_file
            WHERE gen01 = g_shb[l_ac].shb04
              AND genacti='Y'
            IF cl_null(g_shb[l_ac].gen02) THEN
               NEXT FIELD shb04
            END IF
            LET d_shb.shb04 = g_shb[l_ac].shb04
        END IF

      AFTER FIELD shb05
        IF NOT cl_null(g_shb[l_ac].shb05) THEN
           SELECT sfb05,ima02,ima021 
             INTO g_shb[l_ac].shb10,g_shb[l_ac].ima02,g_shb[l_ac].ima021
             FROM sfb_file
             LEFT JOIN ima_file ON sfb05=ima01 
            WHERE sfb01=g_shb[l_ac].shb05
              AND sfb04 >= '2' AND sfb04 <=7
              AND sfb87='Y'
            IF STATUS THEN   #資料不存在 
               CALL cl_err(g_shb[l_ac].shb05,'asf-018',0)
               LET g_shb[l_ac].shb05 = g_shb_t.shb05
               DISPLAY BY NAME g_shb[l_ac].shb05
               NEXT FIELD shb05
            END IF

            #委外工單   
            SELECT 1 INTO l_cnt FROM sfb_file
              WHERE sfb01=g_shb[l_ac].shb05 AND sfb02='7' AND sfb87!='X'
            IF l_cnt = 1 THEN
               CALL cl_err(g_shb[l_ac].shb05,'asf-817',1)
               NEXT FIELD shb05
            END IF
            LET d_shb.shb05 = g_shb[l_ac].shb05
         END IF

      AFTER FIELD shb06
        IF NOT cl_null(g_shb[l_ac].shb06) THEN
           LET d_shb.shb012=' ' 
           LET l_cnt = 0
           #-作業編號,作業名稱,工作站編號
           SELECT ecm04,ecm45,ecm06,ecm58,ecm52 
             INTO d_shb.shb081,d_shb.shb082,d_shb.shb07,d_shb.shb34,g_ecm.ecm52
             FROM ecm_file
            WHERE ecm01=g_shb[l_ac].shb05
              AND ecm03=g_shb[l_ac].shb06
           IF cl_null(d_shb.shb081) THEN  
              CALL cl_err('','abm-215',1)
              NEXT FIELD shb06
           END IF
           IF g_ecm.ecm52='Y' THEN
              CALL cl_err(d_shb.shb081,'asf-160',1)
              NEXT FIELD shb06
           END IF
                                        
           LET d_shb.shb112 = 0
           LET d_shb.shb114 = 0
           LET d_shb.shb06 = g_shb[l_ac].shb06
        END IF

     AFTER FIELD shb08
       IF NOT cl_null(g_shb[l_ac].shb08) THEN  
          LET l_cnt = 0  
          SELECT 1 INTO l_cnt FROM ecg_file
            WHERE ecg01 = g_shb[l_ac].shb08
          IF l_cnt = 0  THEN
             CALL cl_err(g_shb[l_ac].shb08,'aec-001',1)
             LET g_shb[l_ac].shb08 = g_shb_t.shb08
             NEXT FIELD shb08
          END IF
          LET d_shb.shb08 = g_shb[l_ac].shb08
       END IF

     AFTER FIELD shb09
        IF NOT cl_null(g_shb[l_ac].shb09) THEN
           SELECT 1 INTO l_cnt
             FROM eci_file
            WHERE eci01 = g_shb[l_ac].shb09
              AND eciacti='Y'
            IF l_cnt <> 1 THEN
               NEXT FIELD shb09
            END IF
        END IF
        
     AFTER FIELD shb02
       IF NOT cl_null(g_shb[l_ac].shb02) THEN
          SELECT 1 INTO l_cnt FROM sfb_file
           WHERE sfb01 = g_shb[l_ac].shb05
             AND sfb81 > g_shb[l_ac].shb02 #工單開工日大於報工開工日
          IF l_cnt = 1 THEN
             CALL cl_err('','asf-904',1)
             NEXT FIELD shb02
          END IF
       END IF

      AFTER FIELD shb021
        IF NOT cl_null(g_shb[l_ac].shb021) THEN              
           CALL t700_calctime(g_shb[l_ac].shb02,g_shb[l_ac].shb021,g_shb[l_ac].shb03,g_shb[l_ac].shb031) 
           RETURNING g_errno,l_shb032_1,l_shb033_1
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_shb[l_ac].shb021,g_errno,0)
              NEXT FIELD shb021
           END IF
           LET g_shb[l_ac].shb032=l_shb032_1
           LET g_shb[l_ac].shb033=l_shb033_1    
        END IF

      AFTER FIELD shb03
        IF NOT cl_null(g_shb[l_ac].shb03) THEN
           SELECT 1 INTO l_cnt
             FROM sfb_file 
            WHERE sfb01=g_shb[l_ac].shb05 AND sfb87!='X'
              AND (sfb37 < g_shb[l_ac].shb03
               OR sfb81 > g_shb[l_ac].shb03)
           IF NOT cl_null(g_shb[l_ac].shb02) AND NOT cl_null(g_shb[l_ac].shb021) THEN  
              IF l_cnt = 1 THEN
                 CALL cl_err('','asf-904',0)
                 NEXT FIELD shb03
              END IF
           END IF 
           IF g_shb[l_ac].shb02 > g_shb[l_ac].shb03 THEN
              CALL cl_err(g_shb[l_ac].shb03,'asf-916',1)
              NEXT FIELD shb03
           END IF
              
           CALL s_yp(g_shb[l_ac].shb03) RETURNING g_yy,g_mm
           IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
              CALL cl_err('','mfg6091',0)
              NEXT FIELD shb03
           END IF
           #check 成會關帳日期...................................
           IF g_shb[l_ac].shb03 <= g_sma.sma53 THEN
              CALL cl_err('','axm-164',0)
              NEXT FIELD shb03
           END IF
           #MOD-FA0148 add start ------------------------------------
           CALL t700_calctime(g_shb[l_ac].shb02,g_shb[l_ac].shb021,g_shb[l_ac].shb03,g_shb[l_ac].shb031) 
            RETURNING g_errno,l_shb032_1,l_shb033_1
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_shb[l_ac].shb03,g_errno,0)
              NEXT FIELD shb03
           END IF  
        END IF

     AFTER FIELD shb031
       IF NOT cl_null(g_shb[l_ac].shb031) THEN
          CALL t700_calctime(g_shb[l_ac].shb02,g_shb[l_ac].shb021,g_shb[l_ac].shb03,g_shb[l_ac].shb031) 
           RETURNING g_errno,l_shb032_1,l_shb033_1
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_shb[l_ac].shb031,g_errno,0)
             NEXT FIELD shb031
          END IF
          LET g_shb[l_ac].shb032=l_shb032_1
          LET g_shb[l_ac].shb033=l_shb033_1    
       END IF

     AFTER FIELD shb032
       IF NOT cl_null(g_shb[l_ac].shb032) THEN
          IF g_shb[l_ac].shb032 < 0 THEN
             CALL cl_err(g_shb[l_ac].shb032,'asf-807',1)
              NEXT FIELD shb032
          END IF
          
          #----工時小於2小時提醒
          IF g_shb[l_ac].shb032 <= 120 THEN
             IF cl_confirm('csf-018') THEN
                LET g_shb[l_ac].shb032 = g_shb[l_ac].shb032 * 60
                NEXT FIELD shb032
              END IF
          END IF
                
          LET l_day = g_shb[l_ac].shb032 / 1440       # 算出天數
          LET l_min = g_shb[l_ac].shb032 MOD 1440     # 算出分鐘數
          LET l_shb031 = (g_shb[l_ac].shb031[1,2]*60 + g_shb[l_ac].shb031[4,5]) MOD 1440
          LET l_shb02 = g_shb[l_ac].shb03 - l_day
          IF l_shb031 < l_min THEN              #有跨天的情況
             LET l_shb02 = l_shb02 - 1
             LET l_shb021 = (l_shb031 - l_min) + 1440
          ELSE
             LET l_shb021 = l_shb031 - l_min
          END IF
          LET l_hh = l_shb021 / 60              #算時
          LET l_mm = l_shb021 MOD 60            #算分
 
          IF NOT cl_null(l_shb02) THEN    
             LET g_shb[l_ac].shb02 = l_shb02  
          END IF                         
          IF NOT cl_null(l_hh) AND NOT cl_null(l_mm) THEN    
             LET g_shb[l_ac].shb021 = l_hh USING '&&', ':', l_mm USING '&&'
          END IF                                            
              
        END IF
  
        AFTER FIELD shb033
          IF NOT cl_null(g_shb[l_ac].shb033) THEN
             IF g_shb[l_ac].shb033 < 0 THEN
                CALL cl_err(g_shb[l_ac].shb033,'asf-807',1)
                NEXT FIELD shb033
             END IF
          END IF

        BEFORE FIELD shb111
            ##---- 20190227 add by momo (S) 當有未確認移轉單時不可再新增
            SELECT 1 INTO l_cnt
             FROM shb_file
             WHERE shb05 = g_shb[l_ac].shb05
               AND shb081 = d_shb.shb081
               AND shb01 != g_shb[l_ac].shb01
               AND shbconf = 'N'
            IF l_cnt > 0 THEN
               CALL cl_err('','ask-021',1)
               LET INT_FLAG = TRUE
               EXIT INPUT
            END IF
            ##---- 20190227 add by momo (E)

        AFTER FIELD shb111           
           LET g_shb[l_ac].shb111 = cl_digcut(g_shb[l_ac].shb111,0)     #取整數    

           IF NOT cl_null(g_shb[l_ac].shb111) THEN
               IF g_shb[l_ac].shb111 < 0  THEN
                  NEXT FIELD shb111
               END IF
               ## 檢查可報工數量

               IF g_shb[l_ac].shb111 >0 THEN
                  SELECT 1 INTO l_cnt FROM sfa_file
                   WHERE sfa01=g_shb[l_ac].shb05
                     AND sfa08=d_shb.shb081
             
                  IF l_cnt = 1  THEN
                    CALL p700_shb111_a()
                    IF g_success='N' THEN NEXT FIELD shb111 END IF                  
                  END IF
               END IF
               
           END IF
           
            
 
      BEFORE DELETE                            #是否取消單身
         IF g_shb_t.shb01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM shb_file WHERE shb01 = g_shb_t.shb01                                    
                                      
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","shb_file",g_shb_t.shb01,"",SQLCA.sqlcode,"","",1) 
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
            LET g_shb[l_ac].* = g_shb_t.*
            CLOSE p700_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_shb[l_ac].shb01,-263,1)
            LET g_shb[l_ac].* = g_shb_t.*
         ELSE
            UPDATE shb_file
               SET shb04  = g_shb[l_ac].shb04,
                   shb05  = g_shb[l_ac].shb05,
                   shb10  = g_shb[l_ac].shb10,
                   shb06 = g_shb[l_ac].shb06,
                   shb08  = g_shb[l_ac].shb08,
                   shb09  = g_shb[l_ac].shb09,
                   shb02  = g_shb[l_ac].shb02,
                   shb021 = g_shb[l_ac].shb021,
                   shb03  = g_shb[l_ac].shb03,
                   shb031 = g_shb[l_ac].shb031,
                   shb032 = g_shb[l_ac].shb032,
                   shb033 = g_shb[l_ac].shb033,
                   shb111 = g_shb[l_ac].shb111                  
             WHERE shb01 = g_shb_t.shb01
               
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","shb_file",g_shb_t.shb01,'',SQLCA.sqlcode,"","",1)  
               LET g_shb[l_ac].* = g_shb_t.*
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
               LET g_shb[l_ac].* = g_shb_t.*              

            #FUN-D40030--add--str--
            ELSE
               CALL g_shb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            CLOSE p700_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      
         CLOSE p700_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(shb06)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_imz"
                LET g_qryparam.default1 = g_shb[l_ac].shb06
                CALL cl_create_qry() RETURNING g_shb[l_ac].shb06
                DISPLAY BY NAME g_shb[l_ac].shb06
                NEXT FIELD shb06
             
             OTHERWISE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(shb01) AND l_ac > 1 THEN
            LET g_shb[l_ac].* = g_shb[l_ac-1].*
            NEXT FIELD shb04
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
 
   CLOSE p700_bcl
 
   COMMIT WORK
 
END FUNCTION
 

FUNCTION p700_b_askkey()
 
    CLEAR FORM
    CALL g_shb.clear()
 
    CONSTRUCT g_wc2 ON shb01,shb02,shb021,shb06
         FROM s_shb[1].shb01,s_shb[1].shb02,s_shb[1].shb021,s_shb[1].shb06
       
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
     
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(shb06)
                 LET g_qryparam.form = "q_imz"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_shb[1].shb06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shb06
              OTHERWISE
           END CASE
 
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
   
    CALL p700_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p700_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000  
 
   LET g_sql = "SELECT shb04,gen02,shb05,shb10,ima02,ima021,shb06,shb08,sbh09,shb02, ",   
               "       shb021,shb03,sbh031,shb032,sbh033,shb111,shb01 ",
               "  FROM gen_file,shb_file ",    
               "  LEFT JOIN ima_file ON shb10=ima01 ",               
               " WHERE shb04=gen01 AND ", p_wc2 CLIPPED                    #單身

   PREPARE p700_pb FROM g_sql
   DECLARE azf_curs CURSOR FOR p700_pb
 
   CALL g_shb.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH azf_curs INTO g_shb[g_cnt].*   #單身 ARRAY 填充
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
 
   CALL g_shb.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION p700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_shb TO s_shb.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  
                                                                                           
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
   
 
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

FUNCTION p700_a_ins()
DEFINE l_cnt        LIKE type_file.num5    

   IF g_success = 'Y' THEN
      #預設單別
      SELECT rye03 INTO g_shb[l_ac].shb01 FROM rye_file
       WHERE rye01='asft700' 
      CALL s_auto_assign_no("asf",g_shb[l_ac].shb01,g_shb[l_ac].shb03,"9","shb_file","shb01","","","")
        RETURNING li_result,g_shb[l_ac].shb01
   INSERT INTO shb_file VALUES(d_shb.*)       # DISK WRITE
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","shb_file",d_shb.shb01,"",SQLCA.sqlcode,"","",1)  #
      RETURN FALSE
   ELSE
      LET g_shb01_t = d_shb.shb01          
   END IF

   RETURN TRUE
END FUNCTION

#計算投入工時與投入機時-
FUNCTION t700_calctime(p_shb02,p_shb021,p_shb03,p_shb031)
DEFINE p_shb02     LIKE shb_file.shb02
DEFINE p_shb021    LIKE shb_file.shb021
DEFINE p_shb03     LIKE shb_file.shb03
DEFINE p_shb031    LIKE shb_file.shb031
DEFINE p_shb032    LIKE shb_file.shb032
DEFINE p_shb033    LIKE shb_file.shb033
DEFINE l_chk_time  LIKE type_file.num10    

   LET g_errno = ' '
   LET p_shb032 = NULL
   LET p_shb033 = NULL

   IF cl_null(p_shb02) OR cl_null(p_shb03) OR
      cl_null(p_shb021) OR cl_null(p_shb031) THEN
      RETURN g_errno,p_shb032,p_shb033 
   END IF     

   LET g_h1=p_shb021[1,2]
   LET g_m1=p_shb021[4,5]
   LET g_h2=p_shb031[1,2]
   LET g_m2=p_shb031[4,5]
   IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1>24 OR g_m1>=60 OR 
      cl_null(g_h2) OR cl_null(g_m2) OR g_h2>24 OR g_m2>=60 THEN
      LET g_errno = 'asf-807'
      RETURN g_errno,p_shb032,p_shb033 
   END IF

   LET g_sum_m1=g_h1*60+g_m1
   LET g_sum_m2=g_h2*60+g_m2
   LET l_chk_time = (p_shb03-p_shb02)* 24 * 60 + g_sum_m2-g_sum_m1
   IF l_chk_time<0 THEN
      LET g_errno = 'asf-917'
      RETURN g_errno,p_shb032,p_shb033 
   END IF

   LET p_shb032=(p_shb03-p_shb02)*24*60+(g_sum_m2-g_sum_m1)
   LET p_shb033=p_shb032    

   RETURN g_errno,p_shb032,p_shb033
END FUNCTION

FUNCTION p700_shb111_a()
DEFINE l_ima153     LIKE ima_file.ima153
DEFINE l_ecm62      LIKE ecm_file.ecm62  #
DEFINE l_ecm63      LIKE ecm_file.ecm63  #
DEFINE l_n          LIKE type_file.num5  #
DEFINE l_sfb93      LIKE sfb_file.sfb93  #
DEFINE l_ecm311     LIKE ecm_file.ecm311 #可轉出量
DEFINE l_sfb08      LIKE sfb_file.sfb08  #生產數量

    LET g_success = 'Y'
    CALL s_get_ima153(g_shb[l_ac].shb10) RETURNING l_ima153 
  
    CALL s_minp(g_shb[l_ac].shb05,'Y',l_ima153,d_shb.shb081,'',g_shb[l_ac].shb06,'') 
    RETURNING l_cnt,g_min_set
    IF l_cnt !=0  THEN
       CALL cl_err(g_shb[l_ac].shb05,'asf-549',1)
       LET g_success='N' RETURN
    END IF
    
    LET l_ecm311 = 0                                
    #組成用量,底數,良品轉出量-重工轉入量 
    SELECT ecm62,ecm63,ecm311-ecm302                 
      INTO l_ecm62,l_ecm63,l_ecm311                  
      FROM ecm_file  
     WHERE ecm01=g_shb[l_ac].shb05 AND ecm03=g_shb[l_ac].shb06
    
    IF cl_null(l_ecm62) OR l_ecm62=0 THEN
       LET l_ecm62=1
    END IF
    IF cl_null(l_ecm63) OR l_ecm63=0 THEN
       LET l_ecm63=1
    END IF
   ##----- 20251202 By momo (S) 生產量=最小發料量，不需再重設最小發料量                                         
   ##----- 20241108 (S) 可移轉數判斷
   LET l_sfb08 = 0
   SELECT sfb08 INTO l_sfb08 FROM sfb_file
    WHERE sfb01 = g_shb[l_ac].shb05
   IF g_min_set = l_sfb08 THEN   
   ELSE  
      #WIP > 0 AND 良品轉出量 > 0 AND WIP-良品轉出 < 0 
      IF g_wip > 0 AND l_ecm311 > 0 AND g_wip-l_ecm311 < 0 THEN      
         LET g_min_set = g_wip - l_ecm311 + g_min_set                
      END IF              
      #WIP > 0 AND 良品轉出量 > 0 AND WIP > 良品轉出量 
      IF g_wip > 0 AND l_ecm311 > 0 AND g_wip > l_ecm311 THEN
         LET g_min_set =  g_min_set - l_ecm311
      END IF    
   END IF
 
    LET l_n = 0
    SELECT sfb93 INTO l_sfb93 FROM sfb_file  
     WHERE sfb01 = g_shb[l_ac].shb05
    
    SELECT 1 INTO l_n FROM sfa_file
     WHERE sfa01=g_shb[l_ac].shb05
       AND sfa08=d_shb.shb081
       AND sfa05>0
       AND sfa11 <> 'X'   
   
    IF g_shb[l_ac].shb111 > g_min_set*l_ecm62/l_ecm63 AND l_n=1 THEN   
       CALL cl_err(g_shb[l_ac].shb05,'asf-670',1) 
       LET g_success='N' RETURN    
    END IF
END FUNCTION


FUNCTION p700_batch_confirm()
  DEFINE l_i,l_n        LIKE type_file.num5

  LET l_n = 0
  LET g_success = 'N'
  FOR l_i = 1 TO g_rec_b
      CALL p700sub_y_chk(g_shb[l_i].shb01)
      IF g_success = 'Y' THEN 
         BEGIN WORK
         CALL p700sub_y_upd(g_shb[l_i].shb01)
         IF g_success = 'Y' THEN
            COMMIT WORK
         END IF
      END IF
  END FOR
  CALL cl_err('','afa-116',1)
  CALL p700_b_fill("1=2")
END FUNCTION
