# Prog. Version..: '5.30.09-13.09.06(00004)'     #
#
# Pattern name...: cecp007.4gl
# Descriptions...: 批次失效製程基本資料
# Date & Author..: 2024/11/05 By Momo
# Modify.........: 1912234058 20191224 add by momo 

 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    l_ac          LIKE type_file.num5,               
    g_wc          STRING, 
    tm            RECORD 
                  ecb0601       LIKE ecb_file.ecb06,
                  ecb0801       LIKE ecb_file.ecb08,
                  ecb0602       LIKE ecb_file.ecb06,
                  ecb0802       LIKE ecb_file.ecb08,
                  ecb0603       LIKE ecb_file.ecb06,
                  ecb0803       LIKE ecb_file.ecb08,
                  TY            LIKE type_file.chr1,
                  KS            LIKE type_file.chr1,
                  DC            LIKE type_file.chr1,
                  KR            LIKE type_file.chr1
                  END RECORD,
   
    g_ima         DYNAMIC ARRAY OF RECORD
                  choice       LIKE type_file.chr1,       #選擇
                  ecb01        LIKE ecb_file.ecb01,       #料號編號
                  ima02_01     LIKE ima_file.ima02,       #品名
                  ima021_01    LIKE ima_file.ima021,      #規格
                  ecb02        LIKE ecb_file.ecb02,       #製程編號
                  ecb17        LIKE ecb_file.ecb17,       #作業說明
                  eca02        LIKE ecb_file.ecb17        #工作站說明
                  END RECORD,
    
    g_rec_b       LIKE type_file.num5,  #單身筆數
    l_flag        LIKE type_file.chr1,
    g_sql         STRING,
    l_sql         STRING
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
 
   OPEN WINDOW cecp007_w AT p_row,p_col WITH FORM "cec/42f/cecp007" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('z')
   WHILE TRUE
      CALL p007_tm()                      #接受選擇
      CALL p007_p1()
      IF INT_FLAG THEN LET INT_FLAG = 0 CONTINUE WHILE END IF #使用者中斷
      IF cl_sure(0,0) THEN 
          CALL p007_invalid() 
          IF g_success = 'Y' THEN
             COMMIT WORK
             CALL p007_p1()
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
 
   CLOSE WINDOW p007_w
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
      RETURNING g_time
END MAIN
 
FUNCTION p007_tm()
   DEFINE   l_n     LIKE type_file.num5                  #screen array no
   DEFINE   l_len   LIKE type_file.num5                  #screen array no
   DEFINE   l_cnt   LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   CLEAR FORM
   CALL g_ima.clear()
   INITIALIZE tm.* TO NULL
   CALL cl_set_head_visible("","YES")     
 
   CONSTRUCT BY NAME g_wc ON ecu01,ima02,ima021,ecu02,ecu03,imaacti
   BEFORE CONSTRUCT
     CALL cl_qbe_init()
     DISPLAY 'Y' TO imaacti
    
     ON ACTION CONTROLP
        CASE           
           WHEN INFIELD(ecu01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_ecu01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ecu01
              NEXT FIELD ecu01           
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CLOSE WINDOW p007_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     
      EXIT PROGRAM 
   END IF
   
   LET tm.ecb0601 = '' 
   LET tm.ecb0801 = ''
   LET tm.ecb0602 = '' 
   LET tm.ecb0802 = ''
   LET tm.ecb0603 = '' 
   LET tm.ecb0803 = ''
   LET tm.TY = 'N'
   LET tm.KS = 'N'
   LET tm.DC = 'N'
   LET tm.KR = 'N'
   
   CALL cl_set_head_visible("","YES")     #
   CALL p007_entry()
   INPUT BY NAME tm.ecb0601,tm.ecb0602,tm.ecb0603,tm.ecb0801,tm.ecb0802,tm.ecb0803,tm.TY,tm.dc,tm.KS,tm.KR
                   WITHOUT DEFAULTS

      AFTER FIELD ecb0601
        IF NOT cl_null(tm.ecb0601) THEN 
          SELECT COUNT(*) INTO l_cnt
            FROM ecd_file
           WHERE ecd01 = tm.ecb0601 
             AND ecdacti = 'Y'
          IF l_cnt=0 THEN 
             CALL cl_err('','abm-750',1)
             LET tm.ecb0601=''
          END IF
        END IF

      AFTER FIELD ecb0602
        IF NOT cl_null(tm.ecb0602) THEN 
          IF cl_null(tm.ecb0601) THEN
             NEXT FIELD ecb0601
          END IF
          SELECT COUNT(*) INTO l_cnt
            FROM ecd_file
           WHERE ecd01 = tm.ecb0602 
             AND ecdacti = 'Y'
          IF l_cnt=0 THEN 
             CALL cl_err('','abm-750',1)
             LET tm.ecb0602=''
          END IF
        END IF

      AFTER FIELD ecb0603
        IF NOT cl_null(tm.ecb0603) THEN 
          IF cl_null(tm.ecb0601) THEN
             NEXT FIELD ecb0601
          END IF
          IF cl_null(tm.ecb0602) THEN
             NEXT FIELD ecb0602
          END IF
          SELECT COUNT(*) INTO l_cnt
            FROM ecd_file
           WHERE ecd01 = tm.ecb0603 
             AND ecdacti = 'Y'
          IF l_cnt=0 THEN 
             CALL cl_err('','abm-750',1)
             LET tm.ecb0603=''
          END IF
        END IF

      AFTER FIELD ecb0801 
        IF NOT cl_null(tm.ecb0801) THEN 
          SELECT COUNT(*) INTO l_cnt
            FROM eca_file
           WHERE eca01 = tm.ecb0801 
             AND ecaacti = 'Y'
          IF l_cnt=0 THEN 
             CALL cl_err('','aec-100',1)
             LET tm.ecb0801=''
          END IF
        END IF

      AFTER FIELD ecb0802 
        IF NOT cl_null(tm.ecb0802) THEN 
          IF cl_null(tm.ecb0801) THEN
             NEXT FIELD ecb0801
          END IF
          SELECT COUNT(*) INTO l_cnt
            FROM eca_file
           WHERE eca01 = tm.ecb0802 
             AND ecaacti = 'Y'
          IF l_cnt=0 THEN 
             CALL cl_err('','aec-100',1)
             LET tm.ecb0802=''
          END IF
        END IF

      AFTER FIELD ecb0803 
        IF NOT cl_null(tm.ecb0803) THEN 
          IF cl_null(tm.ecb0801) THEN
             NEXT FIELD ecb0801
          END IF
          IF cl_null(tm.ecb0802) THEN
             NEXT FIELD ecb0802
          END IF
          SELECT COUNT(*) INTO l_cnt
            FROM eca_file
           WHERE eca01 = tm.ecb0803 
             AND ecaacti = 'Y'
          IF l_cnt=0 THEN 
             CALL cl_err('','aec-100',1)
             LET tm.ecb0803=''
          END IF
       END IF
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(ecb0601)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_ecd3"
             LET g_qryparam.default1 = tm.ecb0601
             CALL cl_create_qry() RETURNING tm.ecb0601
             DISPLAY BY NAME tm.ecb0601
             NEXT FIELD ecb0601
           WHEN INFIELD(ecb0602)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_ecd3"
             LET g_qryparam.default1 = tm.ecb0602
             CALL cl_create_qry() RETURNING tm.ecb0602
             DISPLAY BY NAME tm.ecb0602
             NEXT FIELD ecb0602
           WHEN INFIELD(ecb0603)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_ecd3"
             LET g_qryparam.default1 = tm.ecb0603
             CALL cl_create_qry() RETURNING tm.ecb0603
             DISPLAY BY NAME tm.ecb0603
             NEXT FIELD ecb0603
           WHEN INFIELD(ecb0801)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_eca1"
             LET g_qryparam.default1 = tm.ecb0801
             CALL cl_create_qry() RETURNING tm.ecb0801
             DISPLAY BY NAME tm.ecb0801
             NEXT FIELD ecb0801
           WHEN INFIELD(ecb0802)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_eca1"
             LET g_qryparam.default1 = tm.ecb0802
             CALL cl_create_qry() RETURNING tm.ecb0802
             DISPLAY BY NAME tm.ecb0802
             NEXT FIELD ecb0802
           WHEN INFIELD(ecb0803)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_eca1"
             LET g_qryparam.default1 = tm.ecb0803
             CALL cl_create_qry() RETURNING tm.ecb0803
             DISPLAY BY NAME tm.ecb0803
             NEXT FIELD ecb0803

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
      CLOSE WINDOW p007_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      
      EXIT PROGRAM 
   END IF

 
END FUNCTION 
 
FUNCTION p007_p1()
   DEFINE l_exit LIKE type_file.chr1
 
   LET g_sql = "SELECT 'N',ecu01,ima02,ima021,",
               "       ecu02,'' ",
               "  FROM ecu_file,ima_file ",
               " WHERE ecu01=ima01 AND ecuacti='Y' AND ",g_wc CLIPPED
   IF NOT cl_null(tm.ecb0601) THEN
      LET g_sql = g_sql CLIPPED, " AND EXISTS (SELECT 1 FROM ecb_file WHERE ecb01=ecu01 AND ecb02=ecu02 AND ecb06='",tm.ecb0601,"')"
   END IF

   IF NOT cl_null(tm.ecb0602) THEN
      LET g_sql = g_sql CLIPPED, " AND EXISTS (SELECT 1 FROM ecb_file WHERE ecb01=ecu01 AND ecb02=ecu02 AND ecb06='",tm.ecb0602,"') "
   END IF

   IF NOT cl_null(tm.ecb0603) THEN
      LET g_sql = g_sql CLIPPED, " AND EXISTS (SELECT 1 FROM ecb_file WHERE ecb01=ecu01 AND ecb02=ecu02 AND ecb06='",tm.ecb0601,"') "
   END IF
   IF NOT cl_null(tm.ecb0801) THEN
      LET g_sql = g_sql CLIPPED, " AND EXISTS (SELECT 1 FROM ecb_file WHERE ecb01=ecu01 AND ecb02=ecu02 AND ecb08='",tm.ecb0801,"')"
   END IF

   IF NOT cl_null(tm.ecb0802) THEN
      LET g_sql = g_sql CLIPPED, " AND EXISTS (SELECT 1 FROM ecb_file WHERE ecb01=ecu01 AND ecb02=ecu02 AND ecb08='",tm.ecb0802,"')"
   END IF

   IF NOT cl_null(tm.ecb0803) THEN
      LET g_sql = g_sql CLIPPED, " AND EXISTS (SELECT 1 FROM ecb_file WHERE ecb01=ecu01 AND ecb02=ecu02 AND ecb08='",tm.ecb0803,"')"
   END IF
 
   PREPARE p007_prepare1 FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('PREPARE:',SQLCA.SQLCODE,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      
      EXIT PROGRAM
   END IF   
 
   DECLARE p007_curs1 CURSOR FOR p007_prepare1
 
   CALL g_ima.clear()
  
   LET g_cnt = 1
   FOREACH p007_curs1 INTO g_ima[g_cnt].*
      IF SQLCA.sqlcode THEN                                  #有問題
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF

      LET l_sql = "SELECT LISTAGG(ecb17,'>') WITHIN GROUP (ORDER BY ecb03), ",
                  "       LISTAGG(eca02,'>') WITHIN GROUP (ORDER BY ecb03) ",
                  "  FROM ecb_file ",
                  "  LEFT JOIN eca_file ON eca01=ecb08 ",
                  " WHERE ecb01 = '",g_ima[g_cnt].ecb01,"' AND ecb02= '",g_ima[g_cnt].ecb02,"' AND ecbacti='Y' "
      PREPARE q_ecb17 FROM l_sql
      DECLARE q_ecb17_cur CURSOR FOR q_ecb17
      FOREACH q_ecb17_cur INTO g_ima[g_cnt].ecb17,g_ima[g_cnt].eca02
      END FOREACH

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
     INPUT ARRAY g_ima WITHOUT DEFAULTS FROM s_ecb.*  #顯示並進行選擇
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
           CALL p007_sel_all("Y")

        ON ACTION select_non
           CALL p007_sel_all("N")

        ON ACTION exporttoexcel2
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','')
 
        ON ACTION controls                                                                                            
           CALL cl_set_head_visible("","AUTO")   
     
     END INPUT
     IF INT_FLAG THEN RETURN END IF   #使用者中斷
     IF l_exit = 'y' THEN EXIT WHILE END IF
   END WHILE
END FUNCTION
 
FUNCTION p007_invalid()
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
          
          UPDATE ecu_file SET ecuacti = 'N',ecu10='N',ecudate=g_today,ecumodu=g_user
           WHERE ecu01 = g_ima[l_i].ecb01
             AND ecu02 = g_ima[l_i].ecb02
   
          IF tm.KS = 'Y' THEN
             UPDATE ks.ecu_file SET ecuacti = 'N',ecu10='N',ecudate=g_today,ecumodu=g_user
              WHERE ecu01 = g_ima[l_i].ecb01
                AND ecu02 = g_ima[l_i].ecb02
          END IF 
      
          IF tm.TY = 'Y' THEN
             UPDATE ty.ecu_file SET ecuacti = 'N',ecu10='N',ecudate=g_today,ecumodu=g_user
              WHERE ecu01 = g_ima[l_i].ecb01
                AND ecu02 = g_ima[l_i].ecb02
          END IF 
      
          IF tm.KR = 'Y' THEN
             UPDATE kr.ecu_file SET ecuacti = 'N',ecu10='N',ecudate=g_today,ecumodu=g_user
              WHERE ecu01 = g_ima[l_i].ecb01
                AND ecu02 = g_ima[l_i].ecb02
          END IF
   
          IF tm.DC = 'Y' THEN
             UPDATE dc.ecu_file SET ecuacti = 'N',ecu10='N',ecudate=g_today,ecumodu=g_user
              WHERE ecu01 = g_ima[l_i].ecb01
                AND ecu02 = g_ima[l_i].ecb02
          END IF   
    
      END FOR 
END FUNCTION

FUNCTION p007_b()
   DEFINE l_exit LIKE type_file.chr1
 
   LET g_sql = "SELECT 'N',ima01,ima02,ima021,",
               "       ecu02,'' ",
               "  FROM ima_file,ecu_file ",
               " WHERE  ima01=ecu01 AND ",g_wc CLIPPED
        
 
   PREPARE p007_prepare FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('PREPARE:',SQLCA.SQLCODE,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      
      EXIT PROGRAM
   END IF   
 
   DECLARE p007_curs CURSOR FOR p007_prepare
 
   CALL g_ima.clear()

   LET g_cnt = 1
   FOREACH p007_curs INTO g_ima[g_cnt].*
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
     INPUT ARRAY g_ima WITHOUT DEFAULTS FROM s_ecb.*  #顯示並進行選擇
       ATTRIBUTE(COUNT=g_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
        
        BEFORE FIELD choice
        #   CALL cl_set_comp_entry("choice",FALSE)

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

FUNCTION p007_sel_all(p_value)
  DEFINE p_value      LIKE type_file.chr1
  DEFINE l_i          LIKE type_file.num10

  FOR l_i = 1 TO g_ima.getLength()
     LET g_ima[l_i].choice = p_value
  END FOR

END FUNCTION

FUNCTION p007_entry()
  CALL cl_set_comp_entry("TY,KS,DC,KR",TRUE)
  IF g_plant = 'TY' THEN 
     CALL cl_set_comp_entry("TY",FALSE)
  END IF
  IF g_plant = 'DC' THEN 
     CALL cl_set_comp_entry("DC",FALSE)
  END IF
  IF g_plant = 'KS' THEN 
     CALL cl_set_comp_entry("KS",FALSE)
  END IF
  IF g_plant = 'KR' THEN 
     CALL cl_set_comp_entry("KR",FALSE)
  END IF
END FUNCTION
