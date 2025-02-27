# Prog. Version..: '5.30.09-13.09.06(00004)'     #
#
# Pattern name...: cecp006.4gl
# Descriptions...: 批次新增製程基本資料
# Date & Author..: 2019/12/17 By Momo
# Modify.........: 1912234058 20191224 add by momo 
# Modify.........: NO.2004284562 20200429 add by momo QBE增加 ima02 品名
# Modify.........: No.2006234807 20200623 modify by momo 批次建立製程，建立後自動確認
# Modify.........: NO.2107056595 20210708 add by momo 調整複製時轉出單位應抓生產單位
#                                                     額外增加調整 ecb19、ecb21 新增時時間預設為 0
# Modify.........: No:2205188097 20220520 add by momo 增加 同步營運中心選擇
# Modify.........: No:23030028   20230317 modify by momo 增加 建立日期 ecuud13
# Modify.........: No:25020038   20250227 modify by momo 製程營運中心調整
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    l_ac          LIKE type_file.num5,               
    g_wc          STRING, 
    tm            RECORD 
                  ecu01         LIKE ecu_file.ecu01,
                  ecu02         LIKE ecu_file.ecu02,
                  updateima94   LIKE type_file.chr1,   #20200507
                  TY            LIKE type_file.chr1,   #20220520
                  KS            LIKE type_file.chr1,   #20220520
                  KR            LIKE type_file.chr1    #20250227
                  END RECORD,
    g_bne2        DYNAMIC ARRAY OF RECORD 
                  bne02         LIKE bne_file.bne02,
                  bne10         LIKE bne_file.bne10,
                  ima1916_1     LIKE ima_file.ima1916,
                  ima1916_2     LIKE ima_file.ima1916
                  END RECORD, 
    g_ima         DYNAMIC ARRAY OF RECORD
                  choice       LIKE type_file.chr1,       #選擇
                  ecb01        LIKE ecb_file.ecb01,       #料號編號
                  ima02_01     LIKE ima_file.ima02,       #品名
                  ima021_01    LIKE ima_file.ima021,      #規格
                  ecu02_b      LIKE ecu_file.ecu02,       #原製程編號
                  ecu02_a      LIKE ecu_file.ecu02        #新製程編號
                  END RECORD,
    g_ecb         DYNAMIC ARRAY OF RECORD
                  ecb02        LIKE ecb_file.ecb02,       
                  ecb03        LIKE ecb_file.ecb03, 
                  ecb06        LIKE ecb_file.ecb06, 
                  ecb08        LIKE ecb_file.ecb08 
                  END RECORD,
    g_rec_b       LIKE type_file.num5,  #單身筆數
    l_flag        LIKE type_file.chr1,
    g_sql         STRING
DEFINE   g_msg          LIKE type_file.chr1000 
DEFINE   g_cnt          LIKE type_file.num10   
DEFINE   g_cnt1         LIKE type_file.num10   
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("cec")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
        RETURNING g_time
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW abxp113_w AT p_row,p_col WITH FORM "cec/42f/cecp006" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('z')
   WHILE TRUE
      CALL p116_tm()                      #接受選擇
      CALL p116_p1()
      IF INT_FLAG THEN LET INT_FLAG = 0 CONTINUE WHILE END IF #使用者中斷
      IF cl_sure(0,0) THEN 
          CALL p116_insert() 
          IF g_success = 'Y' THEN
             COMMIT WORK
             CALL p116_b()
             CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
          ELSE 
             ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
          END IF
          IF l_flag THEN
             CONTINUE WHILE
          ELSE
             EXIT WHILE
          END IF
      END IF
   END WHILE
 
   CLOSE WINDOW p113_w
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
      RETURNING g_time
END MAIN
 
FUNCTION p116_tm()
   DEFINE   l_n     LIKE type_file.num5                  #screen array no
   DEFINE   l_len   LIKE type_file.num5                  #screen array no
   DEFINE   l_cnt   LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   CLEAR FORM
   CALL g_ima.clear()
   CALL g_bne2.clear()
   INITIALIZE tm.* TO NULL
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021,ima06,ima09,ima1007,ima94
    
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(ima01)
#FUN-AA0059 --Begin--
            #  CALL cl_init_qry_var()
            #  LET g_qryparam.state = "c"
            #  LET g_qryparam.form = "q_ima"
            #  CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End-- 
              DISPLAY g_qryparam.multiret TO ima01
              NEXT FIELD ima01
           WHEN INFIELD(ima06)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_imz"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima06
              NEXT FIELD ima06
           WHEN INFIELD(ima09)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.arg1     = "D"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima09
              NEXT FIELD ima09
           WHEN INFIELD(ima1007)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "cq_ima1007"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima1007
              NEXT FIELD ima1007 
           WHEN INFIELD(ima94)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_ecu04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima94
              NEXT FIELD ima94
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
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont() 
 
      ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT CONSTRUCT
   
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CLOSE WINDOW p113_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
   END IF
   
   LET tm.ecu01 = '' 
   LET tm.ecu02 = ''
   LET tm.updateima94='Y' #20200507
   LET tm.TY = 'N'        #20220520
   LET tm.KS = 'N'        #20220520
   LET tm.KR = 'N'        #20250227
   
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
   
   IF g_plant = 'DC' THEN
      CALL cl_set_comp_visible("TY,KS,KR",TRUE)
   ELSE
      CALL cl_set_comp_visible("TY,KS,KR",FALSE)
   END IF
 
   INPUT BY NAME tm.ecu01,tm.ecu02,tm.updateima94,tm.TY,tm.KS,tm.KR #20220520 #20250227
                   WITHOUT DEFAULTS 
 
      AFTER FIELD ecu02
        IF NOT cl_null(tm.ecu02) THEN 
          SELECT COUNT(*) INTO l_cnt
            FROM ecu_file
           WHERE ecu01 = tm.ecu01 AND ecu02=tm.ecu02
             AND ecuacti = 'Y'
          IF l_cnt=0 THEN 
             CALL cl_err('','aec-090',1)
             LET tm.ecu02=''
          END IF
        END IF

      AFTER FIELD updateima94
          IF tm.updateima94='N' THEN  
             CALL cl_set_comp_entry("TY,KS,KR",FALSE)
          ELSE
             CALL cl_set_comp_entry("TY,KS,KR",TRUE)
          END IF
            
      #AFTER FIELD ima09        #其他分群碼一
      #   IF NOT cl_null(tm.ima09) THEN
      #      SELECT azf01 INTO tm.ima09 FROM azf_file
      #       WHERE azf01 = tm.ima09 AND azf02='D'
      #      IF cl_null(tm.ima09) THEN
      #         CALL cl_err(tm.ima09,'aic-022',0)
      #         NEXT FIELD ima09
      #      ELSE
      #         DISPLAY BY NAME tm.ima09
      #      END IF
      #   END IF   
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(ecu01)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_ima"
             LET g_qryparam.default1 = tm.ecu01
             CALL cl_create_qry() RETURNING tm.ecu01
             DISPLAY BY NAME tm.ecu01
             NEXT FIELD ecu01
           WHEN INFIELD(ecu02)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_ecu02_2"
             LET g_qryparam.default1 = tm.ecu02
             CALL cl_create_qry() RETURNING tm.ecu02
             DISPLAY BY NAME tm.ecu02
             NEXT FIELD ecu02

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
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()  
 
      ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT INPUT
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW p113_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
   END IF

   CALL p116_p2()
 
END FUNCTION 
 
FUNCTION p116_p1()
   DEFINE l_exit LIKE type_file.chr1
 
   LET g_sql = "SELECT 'N',ima01,ima02,ima021,",
               "       ima94,'' ",
               "  FROM ima_file ",
               " WHERE imaacti='Y' AND ",g_wc CLIPPED
 
   PREPARE p116_prepare FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('PREPARE:',SQLCA.SQLCODE,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF   
 
   DECLARE p116_curs CURSOR FOR p116_prepare
 
   CALL g_ima.clear()
   CALL g_bne2.clear()
   LET g_cnt = 1
   FOREACH p116_curs INTO g_ima[g_cnt].*
      IF SQLCA.sqlcode THEN                                  #有問題
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      
      IF NOT cl_null(tm.ecu02) THEN
         LET g_ima[g_cnt].ecu02_a = tm.ecu02
      ELSE
         LET g_ima[g_cnt].ecu02_a = g_ima[g_cnt].ecu02_b
      END IF
      
      LET g_cnt = g_cnt + 1                           #累加筆數
      LET g_max_rec = 30000
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ima.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1                               #正確的總筆數
   #筆數為零則跳出訊息並RETURN
   IF g_cnt = 0 THEN 
      CALL cl_err('','agl-118',1) 
      LET INT_FLAG = 1 
      RETURN
   END IF
   CALL SET_COUNT(g_cnt)                               #告之DISPALY ARRAY
   DISPLAY g_cnt TO FORMONLY.cn3                       #顯示總筆數
   WHILE TRUE 
     LET l_exit = 'y'
     INPUT ARRAY g_ima WITHOUT DEFAULTS FROM s_ima.*  #顯示並進行選擇
       ATTRIBUTE(COUNT=g_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
 
        AFTER FIELD choice
           IF g_ima[l_ac].choice NOT MATCHES '[YN]' THEN
              NEXT FIELD choice
           END IF

 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG 
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about     
           CALL cl_about()  
 
        ON ACTION help         
           CALL cl_show_help()

        ON ACTION select_all
           CALL p005_sel_all("Y")

        ON ACTION select_non
           CALL p005_sel_all("N")

        ON ACTION exporttoexcel2
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','')
 
        ON ACTION controls                       #No.FUN-6B0033                                                                       
           CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
     
     END INPUT
     IF INT_FLAG THEN RETURN END IF   #使用者中斷
     IF l_exit = 'y' THEN EXIT WHILE END IF
   END WHILE
END FUNCTION
 
FUNCTION p116_insert()
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_msg1    STRING
   DEFINE g_ecu1    RECORD LIKE ecu_file.*
   DEFINE g_ecb1    RECORD LIKE ecb_file.*
   LET g_success = 'Y'
   BEGIN WORK
      FOR l_i = 1 TO g_cnt
          IF g_ima[l_i].choice = 'N' THEN
             CONTINUE FOR
          END IF
          #---新增製程單頭
          SELECT * INTO g_ecu1.* FROM ecu_file
            WHERE ecu01 = tm.ecu01 AND ecu02 = tm.ecu02
          LET g_ecu1.ecu01 = g_ima[l_i].ecb01
          #LET g_ecu1.ecu10 = 'N'  #20200623 mark
          LET g_ecu1.ecu10 = 'Y'   #20200623 modify
          LET g_ecu1.ecudate = g_today
          LET g_ecu1.ecuoriu = g_user
          LET g_ecu1.ecuuser = g_user
          LET g_ecu1.ecumodu = ''
          LET g_ecu1.ecugrup = g_grup
          LET g_ecu1.ecuorig = g_grup
          LET g_ecu1.ecuud13 = g_today   #20230317
 
          INSERT INTO ecu_file VALUES (g_ecu1.*)          

          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err('ins ecu_file',SQLCA.SQLCODE,1)
             LET g_success = 'N'
             EXIT FOR
          ELSE
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","azo_file","cecp006","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              ROLLBACK WORK
              RETURN FALSE
           ELSE
            #---新增製程單身
              LET l_msg1 = " SELECT * FROM ecb_file ",
                           "  WHERE ecb01 = '",tm.ecu01,"' AND ecb02 = '",tm.ecu02,"' "
              PREPARE p116_ecb_prepare FROM l_msg1
              DECLARE p116_ecb_curs CURSOR FOR p116_ecb_prepare
              FOREACH p116_ecb_curs INTO g_ecb1.*
                 ##---- 20210708 生產單位 (S)---
                 SELECT ima55 INTO g_ecb1.ecb45 FROM ima_file
                  WHERE ima01 = g_ima[l_i].ecb01
                 LET g_ecb1.ecb45 = g_ecb1.ecb45
                 ##---- 20210708 (E) ------------
                 LET g_ecb1.ecb01 = g_ima[l_i].ecb01
                 LET g_ecb1.ecb19 = 0                #20210708
                 LET g_ecb1.ecb21 = 0                #20210708
                 LET g_ecb1.ecbgrup = g_grup
                 LET g_ecb1.ecborig = g_grup
                 LET g_ecb1.ecbmodu = ''
                 LET g_ecb1.ecbuser = g_user
                 LET g_ecb1.ecboriu = g_user
                 LET g_ecb1.ecbdate = g_today
                 INSERT INTO ecb_file VALUES (g_ecb1.*) 
              END FOREACH
              ##---- 20200507 add by momo 更新料號預設製程(S)
              IF tm.updateima94 = 'Y' THEN
                 UPDATE ima_file SET ima94 = tm.ecu02
                  WHERE ima01 = tm.ecu01
                    OR ima01 = g_ima[l_i].ecb01
                 IF tm.TY='Y' THEN  #20220520
                    UPDATE ty.ima_file SET ima94 = tm.ecu02
                      WHERE ima01 = tm.ecu01
                         OR ima01 = g_ima[l_i].ecb01
                 END IF
                 IF tm.KS='Y' THEN  #20220520
                    UPDATE ks.ima_file SET ima94 = tm.ecu02
                     WHERE ima01 = tm.ecu01
                        OR ima01 = g_ima[l_i].ecb01
                 END IF
                 IF tm.KR='Y' THEN  #20250227
                    UPDATE kr.ima_file SET ima94 = tm.ecu02
                     WHERE ima01 = tm.ecu01
                        OR ima01 = g_ima[l_i].ecb01
                 END IF
              END IF
              ##---- 20200507 add by momo 更新料號預設製程(E)
  
           END IF
          END IF
      END FOR 
END FUNCTION

FUNCTION p116_b()
   DEFINE l_exit LIKE type_file.chr1
 
   LET g_sql = "SELECT 'N',ima01,ima02,ima021,",
               "       ecu02,'' ",
               "  FROM ima_file,ecu_file ",
               " WHERE  ima01=ecu01 AND ",g_wc CLIPPED
        
 
   PREPARE p006_prepare FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('PREPARE:',SQLCA.SQLCODE,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF   
 
   DECLARE p006_curs CURSOR FOR p006_prepare
 
   CALL g_ima.clear()

   LET g_cnt = 1
   FOREACH p006_curs INTO g_ima[g_cnt].*
      IF SQLCA.sqlcode THEN                                  #有問題
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      
      LET g_ima[g_cnt].choice = 'N'       
 
      LET g_cnt = g_cnt + 1                           #累加筆數
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ima.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1                               #正確的總筆數
   CALL SET_COUNT(g_cnt)                               #告之DISPALY ARRAY
   DISPLAY g_cnt TO FORMONLY.cn3                       #顯示總筆數
   WHILE TRUE 
     LET l_exit = 'y'
     INPUT ARRAY g_ima WITHOUT DEFAULTS FROM s_ima.*  #顯示並進行選擇
       ATTRIBUTE(COUNT=g_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
        
        BEFORE FIELD choice
        #   CALL cl_set_comp_entry("choice",FALSE)
 
        BEFORE FIELD ima43_a
        #   CALL cl_set_comp_entry("new",FALSE) 

        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG 
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about     
           CALL cl_about()  
 
        ON ACTION help         
           CALL cl_show_help()
       
        ON ACTION exporttoexcel2
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','') 
 
        ON ACTION controls                       #No.FUN-6B0033                                                                       
           CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
     
     END INPUT
     IF INT_FLAG THEN RETURN END IF   #使用者中斷
     IF l_exit = 'y' THEN EXIT WHILE END IF
   END WHILE
END FUNCTION

FUNCTION p005_sel_all(p_value)
  DEFINE p_value      LIKE type_file.chr1
  DEFINE l_i          LIKE type_file.num10

  FOR l_i = 1 TO g_ima.getLength()
     LET g_ima[l_i].choice = p_value
  END FOR

END FUNCTION

FUNCTION p116_p2()
   DEFINE l_exit LIKE type_file.chr1
 
   LET g_sql = "SELECT ecb02,ecb03,ecb06,ecb08 ",
               "  FROM ecb_file ",
               " WHERE ecbacti='Y' AND ecb01 = '",tm.ecu01,"' AND ecb02 = '",tm.ecu02,"' "
 
   PREPARE p116_prepare1 FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('PREPARE:',SQLCA.SQLCODE,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      
      EXIT PROGRAM
   END IF   
 
   DECLARE p116_curs1 CURSOR FOR p116_prepare1
 
   CALL g_ecb.clear()

   LET g_cnt1 = 1
   FOREACH p116_curs1 INTO g_ecb[g_cnt1].*
      IF SQLCA.sqlcode THEN                                  #有問題
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
       
      LET g_cnt1 = g_cnt1 + 1                           #累加筆數
 
      IF g_cnt1 > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL SET_COUNT(g_cnt1)                               #告之DISPALY ARRAY

   DISPLAY ARRAY g_ecb TO s_ecb.* ATTRIBUTE(COUNT=g_cnt1)   
   END DISPLAY
END FUNCTION
