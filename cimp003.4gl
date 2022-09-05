# Prog. Version..: '5.30.09-13.09.06(00004)'     #
#
# Pattern name...: abxp113.4gl
# Descriptions...: 批次更新採購基本資料
# Date & Author..: 06/11/03 By kim
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: 20180816 add by momo 
# Modify.........: NO.1907043259 20190704 by momo 增加顯示供應商簡稱
# Modify.........: No.2105076192 20210510 By momo QBE增加來源碼ima08
# Modify.........: No.2105276289 20210527 By momo QBE增加採購員ima43
# Modify.........: No.22080060   20220905 By momo Input 增加 ima54 供應商編號
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    l_ac          LIKE type_file.num5,               
    g_wc          STRING, 
    tm            RECORD 
                  ima43_i     LIKE ima_file.ima43,
                  ima07       LIKE ima_file.ima07,
                  ima28       LIKE ima_file.ima28,      
                  ima89       LIKE ima_file.ima89,
                  ima54_i     LIKE ima_file.ima54    #供應商20220905  
                  END RECORD,
    g_bne2        DYNAMIC ARRAY OF RECORD 
                  bne02         LIKE bne_file.bne02,
                  bne10         LIKE bne_file.bne10,
                  ima1916_1   LIKE ima_file.ima1916,
                  ima1916_2   LIKE ima_file.ima1916
                  END RECORD, 
    g_ima         DYNAMIC ARRAY OF RECORD
                  choice    LIKE type_file.chr1,       #選擇
                  ima01_b   LIKE ima_file.ima01,       #變更料號編號
                  ima02_01  LIKE ima_file.ima02,       #品名
                  ima021_01 LIKE ima_file.ima021,      #規格
                  ima54_b   LIKE ima_file.ima54,       #供應商
                  pmc03     LIKE pmc_file.pmc03,       #供應商簡稱 20190704
                  ima54_a   LIKE ima_file.ima54,       #供應商 20220905
                  ima43_b   LIKE ima_file.ima43,       #原採購員 
                  ima43_a   LIKE ima_file.ima43,       #新採購員
                  ima07_b   LIKE ima_file.ima07,       #原ABC碼
                  ima07_a   LIKE ima_file.ima07,       #新ABC碼
                  ima28_a   LIKE ima_file.ima28,       #安全期間
                  ima89_a   LIKE ima_file.ima89        #採購期間
                  END RECORD,
    g_rec_b       LIKE type_file.num5,  #單身筆數
    l_flag        LIKE type_file.chr1,
    g_sql         STRING
DEFINE   g_msg          LIKE type_file.chr1000 
DEFINE   g_cnt          LIKE type_file.num10   
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CIM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
        RETURNING g_time
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW abxp113_w AT p_row,p_col WITH FORM "cim/42f/cimp003" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('z')
   WHILE TRUE
      CALL p113_tm()                      #接受選擇
      CALL p113_p1()
      IF INT_FLAG THEN LET INT_FLAG = 0 CONTINUE WHILE END IF #使用者中斷
      IF cl_sure(0,0) THEN 
          CALL p113_update() 
          IF g_success = 'Y' THEN
             COMMIT WORK
             CALL p113_b()
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
 
FUNCTION p113_tm()
   DEFINE   l_n     LIKE type_file.num5                  #screen array no
   DEFINE   l_len   LIKE type_file.num5                  #screen array no
 
   IF s_shut(0) THEN RETURN END IF
   CLEAR FORM
   CALL g_ima.clear()
   CALL g_bne2.clear()
   INITIALIZE tm.* TO NULL
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   CONSTRUCT BY NAME g_wc ON ima01,ima06,ima54,ima08,ima43 #20210527 
    
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
           WHEN INFIELD(ima54)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_pmc"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima54
              NEXT FIELD ima54
           ##---- 20210527 add by momo (S)
           WHEN INFIELD(ima43)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima43
              NEXT FIELD ima43
           ##---- 20210527 add by momo (E)
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
 
   LET tm.ima43_i = ''                   #20210527
   LET tm.ima07 = ''
 #  LET tm.ima28 = 0
   LET tm.ima89 = 0
   LET tm.ima54_i = ''                   #20220905 add
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INPUT BY NAME tm.ima43_i,tm.ima07,tm.ima28,tm.ima89,tm.ima54_i  #20220905 
                   WITHOUT DEFAULTS 
 
 
      AFTER FIELD ima43_i        #採購員
         IF NOT cl_null(tm.ima43_i) THEN
            SELECT gen01 INTO tm.ima43_i FROM gen_file
             WHERE gen01 = tm.ima43_i AND imaacti = 'Y'
            IF cl_null(tm.ima43_i) THEN
               CALL cl_err(tm.ima43_i,'aic-022',0)
               NEXT FIELD ima43_i
            ELSE
               DISPLAY BY NAME tm.ima43_i
            END IF
         END IF  

      #----供應商 20220905
      AFTER FIELD ima54_i
         IF NOT cl_null(tm.ima54_i) THEN
            SELECT pmc01 INTO tm.ima54_i FROM pmc_file
             WHERE pmc01 = tm.ima54_i
               AND pmc05 = '1'
            IF cl_null(tm.ima54_i) THEN
               NEXT FIELD ima54_i 
            ELSE
               DISPLAY BY NAME tm.ima54_i
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(ima43_i)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_gen"
             LET g_qryparam.default1 = tm.ima43_i
             CALL cl_create_qry() RETURNING tm.ima43_i
             DISPLAY BY NAME tm.ima43_i
             NEXT FIELD ima43_i
           #供應商 
           WHEN INFIELD(ima54_i)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_pmc"
             LET g_qryparam.default1 = tm.ima54_i
             CALL cl_create_qry() RETURNING tm.ima54_i
             DISPLAY BY NAME tm.ima54_i
             NEXT FIELD ima54_i

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
 
END FUNCTION 
 
FUNCTION p113_p1()
   DEFINE l_exit LIKE type_file.chr1
 
   LET g_sql = "SELECT ' ',ima01,ima02,ima021,ima54,pmc03,'',ima43,", #20190704 #20220905
               "       ' ',ima07,' ',ima28,ima89 ",
               "  FROM ima_file ",
               "  LEFT JOIN pmc_file ON ima54=pmc01 ",    #20190704
               " WHERE imaacti='Y' AND ",g_wc CLIPPED
 
   PREPARE p113_prepare FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('PREPARE:',SQLCA.SQLCODE,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF   
 
   DECLARE p113_curs CURSOR FOR p113_prepare
 
   CALL g_ima.clear()
   CALL g_bne2.clear()
   LET g_cnt = 1
   FOREACH p113_curs INTO g_ima[g_cnt].*
      IF SQLCA.sqlcode THEN                                  #有問題
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      
      #IF NOT cl_null(tm.ecu01) THEN
      #   IF g_bne2[g_cnt].ima1916_1 != tm.ecu01 THEN
      #      CONTINUE FOREACH
      #   END IF 
      #END IF
       
      LET g_ima[g_cnt].choice = 'Y'  
      IF NOT cl_null(tm.ima43_i) THEN     
         LET g_ima[g_cnt].ima43_a = tm.ima43_i
      ELSE
         LET g_ima[g_cnt].ima43_a = g_ima[g_cnt].ima43_b
      END IF
      IF NOT cl_null(tm.ima07) THEN
         LET g_ima[g_cnt].ima07_a = tm.ima07
      ELSE
         LET g_ima[g_cnt].ima07_a = g_ima[g_cnt].ima07_b 
      END IF
      IF tm.ima28 > 0 THEN
         LET g_ima[g_cnt].ima28_a = tm.ima28
      END IF
      IF tm.ima89 > 0 THEN
         LET g_ima[g_cnt].ima89_a = tm.ima89
      END IF
      ##---- 20220905 add 供應商
      IF NOT cl_null(tm.ima54_i) THEN
         LET g_ima[g_cnt].ima54_a = tm.ima54_i
      ELSE
         LET g_ima[g_cnt].ima54_a = g_ima[g_cnt].ima54_b
      END IF
 
      LET g_cnt = g_cnt + 1                           #累加筆數
 
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
 
        AFTER FIELD ima43_a
           IF g_ima[l_ac].ima43_a < 0 THEN
              CALL cl_err(g_ima[l_ac].ima43_a,'aim-391',0)
              NEXT FIELD ima43_a
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
           CALL p003_sel_all("Y")

        ON ACTION select_non
           CALL p003_sel_all("N")

        ON ACTION exporttoexcel2
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','')
 
        ON ACTION controls                       #No.FUN-6B0033                                                                       
           CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
     
     END INPUT
     IF INT_FLAG THEN RETURN END IF   #使用者中斷
     IF l_exit = 'y' THEN EXIT WHILE END IF
   END WHILE
END FUNCTION
 
FUNCTION p113_update()
   DEFINE  l_i       LIKE type_file.num5
   DEFINE l_msg1    LIKE type_file.chr1000
 
   LET g_success = 'Y'
   BEGIN WORK
      FOR l_i = 1 TO g_cnt
          IF g_ima[l_i].choice = 'N' THEN
             CONTINUE FOR
          END IF
          UPDATE ima_file SET ima43 = g_ima[l_i].ima43_a,
                              ima07 = g_ima[l_i].ima07_a,
                         #    ima28 = g_ima[l_i].ima28_a,
                         #    ima89 = g_ima[l_i].ima89_a,
                              ima54 = g_ima[l_i].ima54_a,  #供應商 20220905
                              imamodu = g_user,
                              imadate = g_today
                        WHERE ima01 = g_ima[l_i].ima01_b
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err('upd ima_file',SQLCA.SQLCODE,1)
             LET g_success = 'N'
             EXIT FOR
          ELSE
             LET l_msg1 = "UPDATE,",g_ima[l_i].ima43_b,"->",g_ima[l_i].ima43_a CLIPPED
             LET g_msg=TIME
            # INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
            # VALUES ('cimp003',g_user,g_today,g_msg,g_ima[l_i].ima01_b,l_msg1,g_plant,g_legal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","azo_file","cimp003","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              ROLLBACK WORK
              RETURN FALSE
           END IF
          END IF
      END FOR 
END FUNCTION

FUNCTION p113_b()
   DEFINE l_exit LIKE type_file.chr1
 
   LET g_sql = "SELECT 'Y',ima01,ima02,ima021,ima54,pmc03,'',ima43,", #20190704 #20220905
               "       ' ',ima07,' ',ima28,ima89 ",
               "  FROM ima_file ",
               "  LEFT JOIN pmc_file ON ima54=pmc01 ",             #20190704
               " WHERE  ",g_wc CLIPPED
        
 
   PREPARE p003_prepare FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('PREPARE:',SQLCA.SQLCODE,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF   
 
   DECLARE p003_curs CURSOR FOR p003_prepare
 
   CALL g_ima.clear()
   CALL g_bne2.clear()

   LET g_cnt = 1
   FOREACH p003_curs INTO g_ima[g_cnt].*,g_bne2[g_cnt].*
      IF SQLCA.sqlcode THEN                                  #有問題
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      
      #IF NOT cl_null(tm.ecu01) THEN
      #   IF g_bne2[g_cnt].ima1916_1 != tm.ecu01 THEN
      #      CONTINUE FOREACH
      #   END IF 
      #END IF

       
      LET g_ima[g_cnt].choice = 'N'       
      LET g_ima[g_cnt].ima43_a = ''
      LET g_ima[g_cnt].ima07_a = ''
 
      LET g_cnt = g_cnt + 1                           #累加筆數
 
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

FUNCTION p003_sel_all(p_value)
  DEFINE p_value      LIKE type_file.chr1
  DEFINE l_i          LIKE type_file.num10

  FOR l_i = 1 TO g_ima.getLength()
     LET g_ima[l_i].choice = p_value
  END FOR

END FUNCTION
