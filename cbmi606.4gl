# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cbmi606.4gl
# Descriptions...: 取替代使用於工單之特殊判斷
# Date & Author..: 20260511 By momo
# Modify.........: 2106026314 20210607 By momo 增加客戶不可取代 tc_bmd02:9

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm RECORD 
       azp01  LIKE azp_file.azp01  END RECORD
DEFINE plant_visible LIKE type_file.chr1
DEFINE
    g_tc_bmd02_i       LIKE tc_bmd_file.tc_bmd02,   #
    g_tc_bmd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        from           LIKE type_file.chr20,
        tc_bmd01       LIKE tc_bmd_file.tc_bmd01,   #原元件
        ima02_h        LIKE ima_file.ima02,
        ima021_h       LIKE ima_file.ima021,
        tc_bmd02       LIKE tc_bmd_file.tc_bmd02,   #更換條件
        type           LIKE type_file.chr20,
        tc_bmd08       LIKE tc_bmd_file.tc_bmd08,   #指定
        tc_bmd03       LIKE tc_bmd_file.tc_bmd03,   #行序
        tc_bmd04       LIKE tc_bmd_file.tc_bmd04,   #舊料料號
        ima02_b        LIKE ima_file.ima02,        
        ima021_b       LIKE ima_file.ima02,
        tc_bmd05       LIKE tc_bmd_file.tc_bmd05,   #Date
        tc_bmd06       LIKE tc_bmd_file.tc_bmd06,   #Date
        tc_bmd07       LIKE tc_bmd_file.tc_bmd07,
        tc_bmdnote     LIKE tc_bmd_file.tc_bmdnote,
        tc_bmddate     LIKE tc_bmd_file.tc_bmddate,
        gen02          LIKE gen_file.gen02
                    END RECORD,
    g_tc_bmd_t         RECORD                 #程式變數 (舊值)
        from           LIKE type_file.chr20,
        tc_bmd01       LIKE tc_bmd_file.tc_bmd01,   #原元件
        ima02_h        LIKE ima_file.ima02,
        ima021_h       LIKE ima_file.ima021,
        tc_bmd02       LIKE tc_bmd_file.tc_bmd02,   #更換條件
        type           LIKE type_file.chr20,
        tc_bmd08       LIKE tc_bmd_file.tc_bmd08,   #指定
        tc_bmd03       LIKE tc_bmd_file.tc_bmd03,   #行序
        tc_bmd04       LIKE tc_bmd_file.tc_bmd04,   #更換料號
        ima02_b        LIKE ima_file.ima02, 
        ima021_b       LIKE ima_file.ima02,
        tc_bmd05       LIKE tc_bmd_file.tc_bmd05,   #Date
        tc_bmd06       LIKE tc_bmd_file.tc_bmd06,   #Date
        tc_bmd07       LIKE tc_bmd_file.tc_bmd07, 
        tc_bmdnote     LIKE tc_bmd_file.tc_bmdnote,
        tc_bmddate     LIKE tc_bmd_file.tc_bmddate,
        gen02          LIKE gen_file.gen02
                    END RECORD,
    g_wc,g_wc2,g_sql   STRING,           
    g_rec_b         LIKE type_file.num5,   #單身筆數       
    g_argv1         LIKE tc_bmd_file.tc_bmd01,
    g_argv2         LIKE tc_bmd_file.tc_bmd08,
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT       
DEFINE g_cmd        LIKE type_file.chr1000
DEFINE g_flag       LIKE type_file.chr1
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10    
DEFINE g_msg        LIKE ze_file.ze03       
DEFINE g_row_count  LIKE type_file.num10    
DEFINE g_curs_index LIKE type_file.num10    
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("CBM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

    LET g_tc_bmd02_i = NULL
    LET plant_visible = 'N' 
    LET tm.azp01=g_plant                       
 
    OPEN WINDOW i606_w WITH FORM "cbm/42f/cbmi606"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL i606_menu()
    CLOSE WINDOW i606_w                                 #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i606_menu()

  DEFINE l_flag LIKE type_file.chr1
 
  CALL cl_navigator_setting( g_curs_index, g_row_count )
       
   WHILE TRUE
  
      CALL i606_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i606_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i606_q()
            END IF
         WHEN "plant"
            IF cl_chk_act_auth() THEN
               LET plant_visible = 'Y' 
               CALL i606_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i606_b_fill(g_wc)
               CALL i606_b()
            ELSE
               LET g_action_choice = NULL
            END IF
      
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"                  
            IF cl_chk_act_auth() THEN
               LET g_doc.column1 = "tc_bmd01"
               LET g_doc.value1  = g_tc_bmd[l_ac].tc_bmd01
               LET g_doc.column2 = "tc_bmd02"
               LET g_doc.value2  = g_tc_bmd[l_ac].tc_bmd02
               LET g_doc.column3 = "tc_bmd08"
               LET g_doc.value3  = g_tc_bmd[l_ac].tc_bmd08
               CALL cl_doc()
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN              
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_bmd),'','')
            END IF
          WHEN "allinvalid"    #batch invalid
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_tc_bmd[l_ac].tc_bmd01) THEN
                 CALL ui.Interface.refresh()
               IF cl_sure(21,21) THEN
                  CALL cl_wait()
                  LET g_success = 'Y'
                  CALL i606_allinvalid()
                  IF g_success = 'Y' THEN
                     CALL cl_end2(1) RETURNING l_flag        #批次作业正确结束
                  ELSE
                     CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
                  END IF
              END IF
           END IF
         END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
#Add  輸入
FUNCTION i606_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_tc_bmd.clear()
    LET g_tc_bmd02_i = NULL       
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
      CALL i606_i("a")                   #輸入單頭
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CALL cl_err('',9001,0)
         EXIT WHILE 
      END IF
      CALL g_tc_bmd.clear()
      LET g_rec_b = 0
      DISPLAY g_rec_b TO FORMONLY.cn2
      CALL i606_b()                   #輸入單身
      EXIT WHILE
    END WHILE

END FUNCTION
 
#處理INPUT
FUNCTION i606_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改       
    l_cnt           LIKE type_file.num5,     
    l_n             LIKE type_file.num5      

    CALL cl_set_head_visible("","YES")          
    INPUT g_tc_bmd02_i 
        WITHOUT DEFAULTS
        FROM tc_bmd02_i
            
        AFTER FIELD tc_bmd02_i
	  IF g_tc_bmd02_i NOT MATCHES '[39S]' OR cl_null(g_tc_bmd02_i) THEN 
             NEXT FIELD tc_bmd02_i
          END IF
          IF l_ac > 0 THEN
             DISPLAY g_tc_bmd[l_ac].tc_bmd02 TO FORMONLY.tc_bmd02_i
          END IF
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON ACTION controlg       
           CALL cl_cmdask()      
 
        ON IDLE g_idle_seconds   
           CALL cl_on_idle()     
           CONTINUE INPUT       
 
        ON ACTION about          
           CALL cl_about()       
 
        ON ACTION help           
           CALL cl_show_help()   
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i606_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i606_b_askkey()                    #取得查詢條件
END FUNCTION
 
 
#將資料顯示在畫面上
FUNCTION i606_show()
     
  CALL i606_b_fill(g_wc)                 #單身
  LET g_tc_bmd02_i = g_tc_bmd[l_ac].tc_bmd02
END FUNCTION
 
 
#單身
FUNCTION i606_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     
    l_n             LIKE type_file.num5,     
    l_lock_sw       LIKE type_file.chr1,     
    p_cmd           LIKE type_file.chr1,     
    l_allow_insert  LIKE type_file.num5,     
    l_allow_delete  LIKE type_file.num5,    
    l_cnt           LIKE type_file.num5      
DEFINE  l_n1        LIKE type_file.num5      
DEFINE  l_i         LIKE type_file.num5 
DEFINE  l_num       LIKE type_file.num5     
DEFINE  l_tc_bmd02     LIKE tc_bmd_file.tc_bmd02      

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
 
    CALL cl_opmsg('b')
    LET g_forupd_sql =
      " SELECT 'CBM',tc_bmd01,'','',tc_bmd02,tc_bmd02,tc_bmd08,tc_bmd03,tc_bmd04,'','',tc_bmd05,tc_bmd06,tc_bmd07,tc_bmdnote,tc_bmddate,'' ",   
      " FROM tc_bmd_file ",
      "  WHERE tc_bmd01 = ? ",
      "   AND tc_bmd08 = ? ",
      "   AND tc_bmd02 = ? ",
      "   AND tc_bmd03 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i606_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_tc_bmd
              WITHOUT DEFAULTS
              FROM s_tc_bmd.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_tc_bmd_t.* = g_tc_bmd[l_ac].*  #BACKUP
                BEGIN WORK
                OPEN i606_bcl USING g_tc_bmd_t.tc_bmd01,g_tc_bmd_t.tc_bmd08,g_tc_bmd_t.tc_bmd02,g_tc_bmd_t.tc_bmd03
                IF STATUS THEN
                    CALL cl_err("OPEN i606_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i606_bcl INTO g_tc_bmd[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_tc_bmd_t.tc_bmd03,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    LET g_tc_bmd[l_ac].ima02_b=g_tc_bmd_t.ima02_b
                    LET g_tc_bmd[l_ac].ima021_b=g_tc_bmd_t.ima021_b
                END IF
                CALL cl_show_fld_cont()     
            END IF

 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO tc_bmd_file
              (tc_bmd01, tc_bmd02, tc_bmd03, tc_bmd04,
               tc_bmd05, tc_bmd06, tc_bmd07, tc_bmd08,
               tc_bmdnote, tc_bmddate,tc_bmdmodu)
            VALUES(g_tc_bmd[l_ac].tc_bmd01,g_tc_bmd[l_ac].tc_bmd02,                     
                   g_tc_bmd[l_ac].tc_bmd03,g_tc_bmd[l_ac].tc_bmd04,
                   g_tc_bmd[l_ac].tc_bmd05,g_tc_bmd[l_ac].tc_bmd06,
                   g_tc_bmd[l_ac].tc_bmd07,g_tc_bmd[l_ac].tc_bmd08,
                   g_tc_bmd[l_ac].tc_bmdnote,g_today,g_user)
           IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","tc_bmd_file",g_tc_bmd[l_ac].tc_bmd01,g_tc_bmd[l_ac].tc_bmd03,SQLCA.sqlcode,"","",1)     
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
      
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
	        COMMIT WORK
            END IF
 
        BEFORE INSERT
          LET p_cmd = 'a'
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_tc_bmd[l_ac].* TO NULL     
          LET g_tc_bmd[l_ac].tc_bmd05=TODAY
          LET g_tc_bmd[l_ac].tc_bmd07=1               
         
          LET g_tc_bmd_t.* = g_tc_bmd[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD tc_bmd01

        AFTER FIELD tc_bmd01
          IF NOT cl_null(g_tc_bmd[l_ac].tc_bmd01) THEN
             SELECT ima02,ima021 INTO g_tc_bmd[l_ac].ima02_h,g_tc_bmd[l_ac].ima021_h
              FROM ima_file
             WHERE ima01 = g_tc_bmd[l_ac].tc_bmd01
             IF cl_null(g_tc_bmd[l_ac].ima02_h) THEN
                NEXT FIELD tc_bmd01
             END IF
          ELSE
             NEXT FIELD tc_bmd01
          END IF

        BEFORE FIELD tc_bmd02
          IF cl_null(g_tc_bmd[l_ac].tc_bmd02) THEN
             LET g_tc_bmd[l_ac].tc_bmd02 = g_tc_bmd02_i
          END IF
 
        AFTER FIELD tc_bmd02
          IF g_tc_bmd[l_ac].tc_bmd02 NOT MATCHES '[39S]' THEN
             CALL cl_err(g_tc_bmd[l_ac].tc_bmd02,'aws-386',1)
             NEXT FIELD tc_bmd02
          END IF
          IF cl_null(g_tc_bmd[l_ac].tc_bmd02) THEN
             LET g_tc_bmd[l_ac].tc_bmd02 = g_tc_bmd02_i
          END IF
          IF cl_null(g_tc_bmd[l_ac].tc_bmd02) THEN
             NEXT FIELD tc_bmd02
          END IF
          IF g_tc_bmd[l_ac].tc_bmd02 = 'S' THEN
             LET g_tc_bmd[l_ac].tc_bmd08="oea08='2' AND ima06 NOT IN ('22049','22039')"
          END IF 
          LET g_tc_bmd[l_ac].type=g_tc_bmd[l_ac].tc_bmd02 
          DISPLAY g_tc_bmd[l_ac].tc_bmd02 TO FORMONLY.tc_bmd02_i

        AFTER FIELD tc_bmd08
          IF g_tc_bmd[l_ac].tc_bmd02 MATCHES '[39]' THEN
             SELECT 1 INTO l_cnt FROM occ_file
              WHERE occ01 = g_tc_bmd[l_ac].tc_bmd08
             IF l_cnt < 1 THEN
                CALL cl_err('','alm1625',0)
                NEXT FIELD tc_bmd08
             END IF
          END IF
          IF g_tc_bmd[l_ac].tc_bmd02 = 'S' THEN
             LET g_tc_bmd[l_ac].tc_bmd08="oea08='2' AND ima06 NOT IN ('22049','22039')"
          END IF 
          IF cl_null(g_tc_bmd[l_ac].tc_bmd08) THEN
             NEXT FIELD tc_bmd08
          END IF

        BEFORE FIELD tc_bmd03                        #default 序號
          IF p_cmd='a' THEN
             SELECT max(tc_bmd03)+1
               INTO g_tc_bmd[l_ac].tc_bmd03
               FROM tc_bmd_file
              WHERE tc_bmd01=g_tc_bmd[l_ac].tc_bmd01 
                AND tc_bmd08=g_tc_bmd[l_ac].tc_bmd08 
                AND tc_bmd02=g_tc_bmd[l_ac].tc_bmd02                  
             IF g_tc_bmd[l_ac].tc_bmd03 IS NULL THEN
                LET g_tc_bmd[l_ac].tc_bmd03 = 1
             END IF
          END IF
 
         AFTER FIELD tc_bmd04
             IF NOT cl_null(g_tc_bmd[l_ac].tc_bmd04) THEN
                IF g_tc_bmd[l_ac].tc_bmd04=g_tc_bmd[l_ac].tc_bmd01 THEN
                   CALL cl_err('','abm-804',0) NEXT FIELD tc_bmd04
                END IF
                SELECT ima02,ima021 INTO g_tc_bmd[l_ac].ima02_b,g_tc_bmd[l_ac].ima021_b
                  FROM ima_file
                 WHERE ima01=g_tc_bmd[l_ac].tc_bmd04 AND imaacti='Y'                                              
                 IF STATUS THEN
                     CALL cl_err3("sel","ima_file",g_tc_bmd[l_ac].tc_bmd04,"",STATUS,"","sel ima:",1)    
                     NEXT FIELD tc_bmd04
                 END IF

             END IF
 
        AFTER FIELD tc_bmd05
 
        AFTER FIELD tc_bmd06
          IF NOT cl_null(g_tc_bmd[l_ac].tc_bmd06) THEN
             IF g_tc_bmd[l_ac].tc_bmd06 < g_tc_bmd[l_ac].tc_bmd05 THEN
                CALL cl_err(g_tc_bmd[l_ac].tc_bmd06,'mfg2604',0)
                NEXT FIELD tc_bmd06
             END IF
          END IF
 
        AFTER FIELD tc_bmd07
          IF g_tc_bmd[l_ac].tc_bmd07 < 0 THEN
             CALL cl_err('','mfg4012',0)
             NEXT FIELD tc_bmd07
          END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_tc_bmd_t.tc_bmd03 > 0 AND
               g_tc_bmd_t.tc_bmd03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM tc_bmd_file
                    WHERE tc_bmd01 = g_tc_bmd_t.tc_bmd01
                      AND tc_bmd08 = g_tc_bmd_t.tc_bmd08
                      AND tc_bmd02 = g_tc_bmd_t.tc_bmd02
                      AND tc_bmd03 = g_tc_bmd_t.tc_bmd03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","tc_bmd_file",g_tc_bmd_t.tc_bmd01,g_tc_bmd_t.tc_bmd08,SQLCA.sqlcode,"","",1)       
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
               

	        COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_bmd[l_ac].* = g_tc_bmd_t.*
               CLOSE i606_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_bmd[l_ac].tc_bmd03,-263,1)
               LET g_tc_bmd[l_ac].* = g_tc_bmd_t.*
            ELSE
       
                UPDATE tc_bmd_file SET
                       tc_bmd02=g_tc_bmd[l_ac].tc_bmd02,
                       tc_bmd03=g_tc_bmd[l_ac].tc_bmd03,
                       tc_bmd04=g_tc_bmd[l_ac].tc_bmd04,
                       tc_bmd05=g_tc_bmd[l_ac].tc_bmd05,
                       tc_bmd06=g_tc_bmd[l_ac].tc_bmd06,
                       tc_bmd07=g_tc_bmd[l_ac].tc_bmd07,
                       tc_bmd08=g_tc_bmd[l_ac].tc_bmd08,
                       tc_bmdnote=g_tc_bmd[l_ac].tc_bmdnote,
                       tc_bmddate=g_today,
                       tc_bmdmodu=g_user
                 WHERE tc_bmd01=g_tc_bmd_t.tc_bmd01
                   AND tc_bmd08=g_tc_bmd_t.tc_bmd08
                   AND tc_bmd02=g_tc_bmd_t.tc_bmd02       
                   AND tc_bmd03=g_tc_bmd_t.tc_bmd03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","tc_bmd_file",g_tc_bmd_t.tc_bmd01,g_tc_bmd_t.tc_bmd03,SQLCA.sqlcode,"","",1)         
                    LET g_tc_bmd[l_ac].* = g_tc_bmd_t.*
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
                  LET g_tc_bmd[l_ac].* = g_tc_bmd_t.*
               ELSE
                  CALL g_tc_bmd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               CLOSE i606_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  
           
            IF cl_null(g_tc_bmd[l_ac].tc_bmd03) THEN 
               CALL g_tc_bmd.deleteElement(l_ac)
            END IF
           
            CLOSE i606_bcl
            COMMIT WORK

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tc_bmd03) AND l_ac > 1 THEN
                LET g_tc_bmd[l_ac].* = g_tc_bmd[l_ac-1].*
                NEXT FIELD tc_bmd03
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(tc_bmd01)
                 CALL q_sel_ima(FALSE, "q_ima", "", g_tc_bmd[l_ac].tc_bmd01 , "", "", "", "" ,"",'' )  RETURNING g_tc_bmd[l_ac].tc_bmd01
                 DISPLAY g_tc_bmd[l_ac].tc_bmd01 TO tc_bmd01
                 NEXT FIELD tc_bmd01
               WHEN INFIELD(tc_bmd04)
                 CALL q_sel_ima(FALSE, "q_ima", "", g_tc_bmd[l_ac].tc_bmd04 , "", "", "", "" ,"",'' )  RETURNING g_tc_bmd[l_ac].tc_bmd04
                 DISPLAY g_tc_bmd[l_ac].tc_bmd04 TO tc_bmd04
                 NEXT FIELD tc_bmd04
            END CASE
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controls                                    
         CALL cl_set_head_visible("","AUTO")      

      AFTER INPUT 
      END INPUT

    CLOSE i606_bcl
    COMMIT WORK
END FUNCTION
  
 
FUNCTION i606_b_askkey()

 DEFINE l_cnt LIKE type_file.num5
    CALL cl_set_comp_entry("azp01",TRUE)
    CLEAR FORM
    CALL g_tc_bmd.clear()

    INPUT BY NAME tm.azp01 WITHOUT DEFAULTS
   
    BEFORE FIELD azp01                               
      IF plant_visible = 'N' THEN
         CALL cl_set_comp_entry("azp01",FALSE)
      ELSE
         CALL cl_set_comp_entry("azp01",TRUE)
      END IF
   
    AFTER FIELD azp01
      LET l_cnt = 0
      SELECT 1 INTO l_cnt FROM zxy_file
       WHERE zxy01 = g_user
         AND zxy03 = tm.azp01
      IF l_cnt = 0 THEN
         CALL cl_err(tm.azp01,'sub-188',1)
         NEXT FIELD azp01
      END IF

    ON ACTION controlp
       CASE
         WHEN INFIELD(azp01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_zxy"
              LET g_qryparam.arg1 = g_user
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              LET tm.azp01 = g_qryparam.multiret
              DISPLAY BY NAME tm.azp01
              NEXT FIELD azp01
         OTHERWISE
         EXIT CASE
       END CASE
   END INPUT
 
    CONSTRUCT g_wc ON tc_bmd01,tc_bmd02,tc_bmd08,tc_bmd03,tc_bmd04,tc_bmdnote,tc_bmd05,tc_bmd06     #螢幕上取條件
         FROM s_tc_bmd[1].tc_bmd01,s_tc_bmd[1].tc_bmd02,s_tc_bmd[1].tc_bmd08,
              s_tc_bmd[1].tc_bmd03,s_tc_bmd[1].tc_bmd04,s_tc_bmd[1].tc_bmdnote,
              s_tc_bmd[1].tc_bmd05,s_tc_bmd[1].tc_bmd06
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

       ON ACTION CONTROLP
               CASE
                   WHEN INFIELD(tc_bmd01)
                        CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO tc_bmd01
                        NEXT FIELD tc_bmd01
                   WHEN INFIELD(tc_bmd04)
                        CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO tc_bmd04
                        NEXT FIELD tc_bmd04
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_bmduser', 'tc_bmdgrup') 
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i606_b_fill(g_wc)
END FUNCTION
 
FUNCTION i606_b_fill(g_wc)              #BODY FILL UP
DEFINE g_wc,g_wc2 STRING 
    IF cl_null(g_wc2) THEN  
       LET g_wc2 = g_wc
       LET g_wc2=cl_replace_str(g_wc2,"tc_bmd","bmd")
    END IF
    LET g_plant_new= tm.azp01
    IF g_action_choice='detail' THEN 
       LET g_wc2="1=2"
       LET g_plant_new = g_plant 
    END IF
    LET g_sql =
       "SELECT 'CBM',tc_bmd01,a.ima02,a.ima021,tc_bmd02,tc_bmd02,tc_bmd08,",
       "       tc_bmd03, tc_bmd04,b.ima02,b.ima021,tc_bmd05,", 
       "       tc_bmd06, tc_bmd07,tc_bmdnote,tc_bmddate,tc_bmdmodu ",
       " FROM ",cl_get_target_table(g_plant_new,'tc_bmd_file'),
       " LEFT JOIN ",cl_get_target_table(g_plant_new,'ima_file')," a ON a.ima01=tc_bmd01 ",
       " LEFT JOIN ",cl_get_target_table(g_plant_new,'ima_file')," b ON b.ima01=tc_bmd04 ",
       " LEFT JOIN ",cl_get_target_table(g_plant_new,'gen_file')," ON gen01= tc_bmdmodu ",
       " WHERE tc_bmd02 >= '3' AND ", g_wc CLIPPED,
       " UNION ",
       "SELECT 'ABM',bmd01,a.ima02,a.ima021,bmd02,bmd02,bmd08,",
       "       bmd03, bmd04,b.ima02,b.ima021,bmd05,", 
       "       bmd06, bmd07,ta_bmd01,bmddate,bmdmodu ",
       " FROM ",cl_get_target_table(g_plant_new,'bmd_file'), 
       " LEFT JOIN ",cl_get_target_table(g_plant_new,'ima_file')," a ON a.ima01=bmd01 ",
       " LEFT JOIN ",cl_get_target_table(g_plant_new,'ima_file')," b ON b.ima01=bmd04 ",
       " LEFT JOIN ",cl_get_target_table(g_plant_new,'gen_file')," ON gen01= bmdmodu ",
       " WHERE ", g_wc2 CLIPPED,
       " ORDER BY 1"
    PREPARE i606_prepare2 FROM g_sql      #預備一下
    DECLARE tc_bmd_cs CURSOR FOR i606_prepare2
    CALL g_tc_bmd.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH tc_bmd_cs INTO g_tc_bmd[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_tc_bmd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i606_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_bmd TO s_tc_bmd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac > 0 THEN
            DISPLAY g_tc_bmd[l_ac].tc_bmd02 TO FORMONLY.tc_bmd02_i
         END IF
      CALL cl_show_fld_cont()                  
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION plant
         LET g_action_choice="plant"
         LET plant_visible = 'Y' 
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
     
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
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
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      #batch invalid
      ON ACTION allinvalid
         LET g_action_choice = 'allinvalid'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                   
         CALL cl_set_head_visible("","AUTO")      
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i606_allinvalid()
  DEFINE p_value      LIKE type_file.chr1
  DEFINE l_i          LIKE type_file.num10
  DEFINE l_note       LIKE bmd_file.ta_bmd01

  PROMPT "備註：" FOR l_note

  BEGIN WORK
     FOR l_i = 1 TO g_tc_bmd.getLength()
        LET g_tc_bmd_t.* = g_tc_bmd[l_i].*            #BACKUP
        IF NOT cl_null(g_tc_bmd[l_i].tc_bmd06) THEN
           CONTINUE FOR
        END IF
        LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'tc_bmd_file'),
                    "   SET tc_bmd06 = '",g_today,"' ,",
                    "       tc_bmddate = '",g_today,"' ,",
                    "       tc_bmdmodu = '",g_user,"' ,",
                    "       tc_bmdnote = '",l_note,"'  ",
                    " WHERE tc_bmd01 = ? ",
                    "   AND tc_bmd02 = ? ",
                    "   AND tc_bmd03 = ? ",
                    "   AND tc_bmd08 = ? "
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
        PREPARE upd_tc_bmd06 FROM g_sql
        EXECUTE upd_tc_bmd06 USING g_tc_bmd_t.tc_bmd01,g_tc_bmd_t.tc_bmd02,g_tc_bmd_t.tc_bmd03,g_tc_bmd_t.tc_bmd08
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           LET g_success = 'N'
           CALL cl_err('upd tc_bmd_file',SQLCA.SQLCODE,1)
           EXIT FOR
           ROLLBACK WORK
        ELSE
           COMMIT WORK
        END IF
  END FOR
  CALL i606_b_fill(g_wc)
END FUNCTION 
