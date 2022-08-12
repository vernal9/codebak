# Prog. Version..: '5.30.09-13.09.06(00004)'     #
#
# Pattern name...: abxp113.4gl
# Descriptions...: 批次更新研發基本資料
# Date & Author..: 06/11/03 By kim
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: 20180830 add by momo 
# Modify.........: No:2006234807 20200702 By momo 批次更新作業追加欄位
# Modify.........: No:2106256554 20210706 By momo 批次更新作業追加欄位
# Modify.........: No:22080007   20220812 By momo 追加 ima130 銷售特性
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    l_ac          LIKE type_file.num5,               
    g_wc          STRING, 
    tm            RECORD
                  i_ima02       LIKE ima_file.ima02,
                  i_ima021      LIKE ima_file.ima021,
                  ima09         LIKE ima_file.ima09,
                  i_ta_ima06    LIKE ima_file.ta_ima06,
                  ta_ima01      LIKE ima_file.ta_ima01,
                  ta_ima08      LIKE ima_file.ta_ima08,      
                  ima1007       LIKE ima_file.ima1007,
                  ima10         LIKE ima_file.ima10,   #20200702
                  ima11         LIKE ima_file.ima11,   #20200702    
                  ta_ima07      LIKE ima_file.ta_ima07,#20200702  
                  i_ima1401     LIKE ima_file.ima1401, #20210706
                  i_ima109      LIKE ima_file.ima109,  #20210706
                  i_ima131      LIKE ima_file.ima131,  #20210706
                  i_imaacti     LIKE ima_file.imaacti, #20210706
                  i_ima130      LIKE ima_file.ima130   #20220812
                  END RECORD,
    g_bne2        DYNAMIC ARRAY OF RECORD 
                  bne02         LIKE bne_file.bne02,
                  bne10         LIKE bne_file.bne10,
                  ima1916_1     LIKE ima_file.ima1916,
                  ima1916_2     LIKE ima_file.ima1916
                  END RECORD, 
    g_ima         DYNAMIC ARRAY OF RECORD
                  choice       LIKE type_file.chr1,       #選擇
                  ima01_b      LIKE ima_file.ima01,       #變更料號編號
                  ima02_01     LIKE ima_file.ima02,       #品名
                  ima02_a      LIKE ima_file.ima02,       #新品名
                  ima021_01    LIKE ima_file.ima021,      #規格
                  ima021_a     LIKE ima_file.ima021,      #新規格
                  ima09_b      LIKE ima_file.ima09,       #原系列 
                  ima09_a      LIKE ima_file.ima09,       #新系列
                  ta_ima01_a   LIKE ima_file.ta_ima01,    #新免備品料
                  ta_ima08_a   LIKE ima_file.ta_ima08,    #新特注
                  ima1007_a    LIKE ima_file.ima1007,     #型號
                  ta_ima06_a   LIKE ima_file.ta_ima06,    #新代工
                  ima10_b      LIKE ima_file.ima10,       #原馬達功率
                  ima10_a      LIKE ima_file.ima10,       #新馬達功率
                  ima11_b      LIKE ima_file.ima11,       #原馬達規格
                  ima11_a      LIKE ima_file.ima11,       #新馬達規格
                  ta_ima07_b   LIKE ima_file.ta_ima07,    #原馬達方向
                  ta_ima07_a   LIKE ima_file.ta_ima07,    #新馬達方向
                  ta_ima02_a   LIKE ima_file.ta_ima02,    #新軸數
                  ta_ima03_a   LIKE ima_file.ta_ima03,    #新外徑加導程
                  ta_ima04_a   LIKE ima_file.ta_ima04,    #新行程
                  ta_ima05_a   LIKE ima_file.ta_ima05,    #新帶控制
                  imaud07_a    LIKE ima_file.imaud07,     #新控制線長
                  imaud08_a    LIKE ima_file.imaud08,     #新螺桿/研磨長度
                  ima1401_a    LIKE ima_file.ima1401,     #新停產生效日
                  ima109_a     LIKE ima_file.ima109,      #新材料類別
                  ima131_a     LIKE ima_file.ima131,      #新產品分類編號
                  ima110_a     LIKE ima_file.ima110,      #BOM展開選項
                  imaacti_a    LIKE ima_file.imaacti,     #有效否
                  ima130_a     LIKE ima_file.ima130       #銷售特性 
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
 
   OPEN WINDOW abxp113_w AT p_row,p_col WITH FORM "cim/42f/cimp005" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
   CALL cl_set_combo_items_plus("ta_ima07","aimi100","ta_ima07")  #20220113
 
 
   CALL cl_opmsg('z')
   WHILE TRUE
      CALL p115_tm()                      #接受選擇
      CALL p115_p1()
      IF INT_FLAG THEN LET INT_FLAG = 0 CONTINUE WHILE END IF #使用者中斷
      IF cl_sure(0,0) THEN 
          CALL p115_update() 
          IF g_success = 'Y' THEN
             COMMIT WORK
             CALL p115_b()
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
 
FUNCTION p115_tm()
   DEFINE   l_n     LIKE type_file.num5                  #screen array no
   DEFINE   l_len   LIKE type_file.num5                  #screen array no
 
   IF s_shut(0) THEN RETURN END IF
   CLEAR FORM
   CALL g_ima.clear()
   CALL g_bne2.clear()
   INITIALIZE tm.* TO NULL
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021,ima06,ima131,imaacti,ima130 #20210701 #20220812

   BEFORE CONSTRUCT         #20210705
     DISPLAY 'Y' TO imaacti #20210705
    
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
           WHEN INFIELD(ima131)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_oba"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima131
              NEXT FIELD ima131
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
   
   LET tm.ima09 = '' 
   LET tm.ta_ima01 = ''
   LET tm.ta_ima08 = ''
   LET tm.ima1007 = ''

   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INPUT BY NAME tm.i_ima02,tm.i_ima021,tm.ima09,tm.i_ta_ima06,
                 tm.ta_ima01,tm.ta_ima08,tm.ima1007,
                 tm.ima10,tm.ima11,tm.ta_ima07,                     #20200702
                 tm.i_ima1401,tm.i_ima109,tm.i_ima131,tm.i_imaacti, #20210706
                 tm.i_ima130                                        #20220812
                   WITHOUT DEFAULTS 
 
 
      AFTER FIELD ima09        #其他分群碼一
         IF NOT cl_null(tm.ima09) THEN
            SELECT azf01 INTO tm.ima09 FROM azf_file
             WHERE azf01 = tm.ima09 AND azf02='D'
            IF cl_null(tm.ima09) THEN
               CALL cl_err(tm.ima09,'aic-022',0)
               NEXT FIELD ima09
            ELSE
               DISPLAY BY NAME tm.ima09
            END IF
         END IF  

      AFTER FIELD ima10        #其他分群碼二
         IF NOT cl_null(tm.ima10) THEN
            SELECT azf01 INTO tm.ima10 FROM azf_file
             WHERE azf01 = tm.ima10 AND azf02='E'
            IF cl_null(tm.ima10) THEN
               CALL cl_err(tm.ima10,'aic-022',0)
               NEXT FIELD ima10
            ELSE
               DISPLAY BY NAME tm.ima10
            END IF
         END IF 

      AFTER FIELD ima11        #其他分群碼三
         IF NOT cl_null(tm.ima11) THEN
            SELECT azf01 INTO tm.ima11 FROM azf_file
             WHERE azf01 = tm.ima11 AND azf02='F'
            IF cl_null(tm.ima11) THEN
               CALL cl_err(tm.ima11,'aic-022',0)
               NEXT FIELD ima11
            ELSE
               DISPLAY BY NAME tm.ima11
            END IF
         END IF

      ##---- 20210706 add (S)
      AFTER FIELD i_ima109        #材料類別
         IF NOT cl_null(tm.i_ima109) THEN
            SELECT azf01 INTO tm.i_ima109 FROM azf_file
             WHERE azf01 = tm.i_ima109 AND azf02='8'
            IF cl_null(tm.i_ima109) THEN
               CALL cl_err(tm.i_ima109,'abg-002',0)
               NEXT FIELD i_ima109
            ELSE
               DISPLAY BY NAME tm.i_ima109
            END IF
         END IF

      AFTER FIELD i_ima131
        IF NOT cl_null(tm.i_ima131) THEN
           SELECT oba01 INTO tm.i_ima131 FROM oba_file
            WHERE oba01 = tm.i_ima131
           IF cl_null(tm.i_ima131) THEN
              CALL cl_err(tm.i_ima131,'aim-142',0)
           ELSE
              DISPLAY BY NAME tm.i_ima131
           END IF
        END IF

      AFTER FIELD i_imaacti
        IF NOT cl_null(tm.i_imaacti) THEN
           IF tm.i_imaacti <> 'Y' THEN
              NEXT FIELD tm.i_imaacti
           END IF
        END IF

      ##---- 20210706 add (E)
     
     ##--- 20220812 add (S)
     AFTER FIELD i_ima130
       IF NOT tm.i_ima130 NOT MATCHES '[01]' THEN
          NEXT FIELD tm.i_ima130
       END IF
     ##--- 20220812 add (E)
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(ima09)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_azf"
             LET g_qryparam.default1 = tm.ima09
             LET g_qryparam.arg1     = "D"
             CALL cl_create_qry() RETURNING tm.ima09
             DISPLAY BY NAME tm.ima09
             NEXT FIELD ima09
           WHEN INFIELD(ima10)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_azf"
             LET g_qryparam.default1 = tm.ima10
             LET g_qryparam.arg1     = "E"
             CALL cl_create_qry() RETURNING tm.ima10
             DISPLAY BY NAME tm.ima10
             NEXT FIELD ima10
           WHEN INFIELD(ima11)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_azf"
             LET g_qryparam.default1 = tm.ima11
             LET g_qryparam.arg1     = "F"
             CALL cl_create_qry() RETURNING tm.ima11
             DISPLAY BY NAME tm.ima11
             NEXT FIELD ima11
          
           WHEN INFIELD(i_ta_ima06)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_occ"
             LET g_qryparam.default1 = tm.i_ta_ima06
             CALL cl_create_qry() RETURNING tm.i_ta_ima06
             DISPLAY BY NAME tm.i_ta_ima06
             NEXT FIELD i_ta_ima06

            ##---- 20210706 add (S)
            WHEN INFIELD(i_ima109)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azf"
                 LET g_qryparam.default1 = tm.i_ima109
                 LET g_qryparam.arg1     = "8"
                 CALL cl_create_qry() RETURNING tm.i_ima109
                 DISPLAY BY NAME tm.i_ima109
                 NEXT FIELD i_ima109
 
            WHEN INFIELD(i_ima131)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oba"
                 LET g_qryparam.default1 = tm.i_ima131
                 CALL cl_create_qry() RETURNING tm.i_ima131
                 DISPLAY BY NAME tm.i_ima131
                 NEXT FIELD i_ima131

        
            ##---- 20210706 add (E)

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
 
FUNCTION p115_p1()
   DEFINE l_exit LIKE type_file.chr1
 
   LET g_sql = "SELECT 'N',ima01,ima02,ima02,ima021,ima021,ima09,",
               "       ' ',ta_ima01,ta_ima08,ima1007,ta_ima06, ",
               "       ima10,' ',ima11,' ',ta_ima07,' ',ta_ima02, ",                         #20200702
               "       ta_ima03,ta_ima04,ta_ima05,NVL(imaud07,0),NVL(imaud08,0), ",          #20200702 #20201130
               "       ima1401,ima109,ima131,ima110,imaacti, ",                              #20210706
               "       ima130 ",                                                             #20220812
               "  FROM ima_file ",
              #" WHERE imaacti <> 'N' AND ",g_wc CLIPPED                                     #20210705 mark
               " WHERE ",g_wc CLIPPED                                                        #20210705 modify
 
   PREPARE p115_prepare FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('PREPARE:',SQLCA.SQLCODE,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF   
 
   DECLARE p115_curs CURSOR FOR p115_prepare
 
   CALL g_ima.clear()
   CALL g_bne2.clear()
   LET g_cnt = 1
   FOREACH p115_curs INTO g_ima[g_cnt].*
      IF SQLCA.sqlcode THEN                                  #有問題
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      
       
      LET g_ima[g_cnt].choice = 'Y'  
      IF NOT cl_null(tm.ima09) THEN     
         LET g_ima[g_cnt].ima09_a = tm.ima09
      ELSE
         LET g_ima[g_cnt].ima09_a = g_ima[g_cnt].ima09_b
      END IF
      IF NOT cl_null(tm.ta_ima01) THEN
         LET g_ima[g_cnt].ta_ima01_a = tm.ta_ima01
      END IF
      IF NOT cl_null(tm.ta_ima08) THEN
         LET g_ima[g_cnt].ta_ima08_a = tm.ta_ima08
      END IF
      IF NOT cl_null(tm.ima1007) THEN
         LET g_ima[g_cnt].ima1007_a = tm.ima1007
      END IF
      IF NOT cl_null(tm.i_ima02) THEN
         LET g_ima[g_cnt].ima02_a = tm.i_ima02
      END IF
      IF NOT cl_null(tm.i_ima021) THEN
         LET g_ima[g_cnt].ima021_a = tm.i_ima021
      END IF
      IF NOT cl_null(tm.i_ta_ima06) THEN
         LET g_ima[g_cnt].ta_ima06_a = tm.i_ta_ima06
      END IF
      ##---- 20200702 add (S)
      IF NOT cl_null(tm.ima10) THEN     
         LET g_ima[g_cnt].ima10_a = tm.ima10
      ELSE
         LET g_ima[g_cnt].ima10_a = g_ima[g_cnt].ima10_b
      END IF

      IF NOT cl_null(tm.ima11) THEN     
         LET g_ima[g_cnt].ima11_a = tm.ima11
      ELSE
         LET g_ima[g_cnt].ima11_a = g_ima[g_cnt].ima11_b
      END IF

      IF NOT cl_null(tm.ta_ima07) THEN     
         LET g_ima[g_cnt].ta_ima07_a = tm.ta_ima07
      ELSE
         LET g_ima[g_cnt].ta_ima07_a = g_ima[g_cnt].ta_ima07_b
      END IF
      ##---- 20200702 add (E)
      ##---- 20210706 add (S)
      IF NOT cl_null(tm.i_ima1401) THEN
         LET g_ima[g_cnt].ima1401_a = tm.i_ima1401
      ELSE
         LET g_ima[g_cnt].ima1401_a = g_ima[g_cnt].ima1401_a
      END IF

      IF NOT cl_null(tm.i_ima109) THEN
         LET g_ima[g_cnt].ima109_a = tm.i_ima109
      ELSE
         LET g_ima[g_cnt].ima109_a = g_ima[g_cnt].ima109_a 
      END IF

      IF NOT cl_null(tm.i_ima131) THEN
         LET g_ima[g_cnt].ima131_a = tm.i_ima131
      ELSE
         LET g_ima[g_cnt].ima131_a = g_ima[g_cnt].ima131_a 
      END IF

      IF tm.i_imaacti = 'Y' THEN
         LET g_ima[g_cnt].imaacti_a = 'Y'
      ELSE
         LET g_ima[g_cnt].imaacti_a = g_ima[g_cnt].imaacti_a
      END IF
      ##---- 20210706 add (E)
     
      ##--- 20220812 add (S)
      IF NOT cl_null(tm.i_ima130) THEN
         LET g_ima[g_cnt].ima130_a = tm.i_ima130
      ELSE
         LET g_ima[g_cnt].ima130_a = g_ima[g_cnt].ima130_a 
      END IF
      ##--- 20220812 add (E)

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

        AFTER FIELD imaacti_a
           IF g_ima[l_ac].imaacti_a <> 'Y' THEN
              LET g_ima[l_ac].imaacti_a = 'Y'
              NEXT FIELD imaacti_a
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

        ON ACTION insert_pn_spec_extra_desc      #20190605
           CALL p115_insert()                    #20190605
 
        ON ACTION controls                       #No.FUN-6B0033                                                                       
           CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
     
     END INPUT
     IF INT_FLAG THEN RETURN END IF   #使用者中斷
     IF l_exit = 'y' THEN EXIT WHILE END IF
   END WHILE
END FUNCTION
 
FUNCTION p115_update()
   DEFINE  l_i       LIKE type_file.num5
   DEFINE l_msg1    LIKE type_file.chr1000
 
   LET g_success = 'Y'
   BEGIN WORK
      FOR l_i = 1 TO g_cnt
          IF g_ima[l_i].choice = 'N' THEN
             CONTINUE FOR
          END IF
          UPDATE ima_file SET ima09    = g_ima[l_i].ima09_a,
                              ima10    = g_ima[l_i].ima10_a,   #20200702
                              ima11    = g_ima[l_i].ima11_a,   #20200702
                              ima1007  = g_ima[l_i].ima1007_a,
                              ta_ima01 = g_ima[l_i].ta_ima01_a,
                              ta_ima08 = g_ima[l_i].ta_ima08_a,
                              imamodu  = g_user,
                              imadate  = g_today,
                              ima02    = g_ima[l_i].ima02_a,
                              ima021   = g_ima[l_i].ima021_a,
                              ta_ima06 = g_ima[l_i].ta_ima06_a,
                              ta_ima07 = g_ima[l_i].ta_ima07_a, #20200702
                              ta_ima02 = g_ima[l_i].ta_ima02_a, #20200702
                              ta_ima03 = g_ima[l_i].ta_ima03_a, #20200702
                              ta_ima04 = g_ima[l_i].ta_ima04_a, #20200702 
                              ta_ima05 = g_ima[l_i].ta_ima05_a, #20200702
                              imaud07  = g_ima[l_i].imaud07_a,  #20200702
                              imaud08  = g_ima[l_i].imaud08_a,  #20200702
                              ima1401  = g_ima[l_i].ima1401_a,  #20210706
                              ima109   = g_ima[l_i].ima109_a,   #20210706
                              ima131   = g_ima[l_i].ima131_a,   #20210706
                              ima110   = g_ima[l_i].ima110_a,   #20210706
                              imaacti  = g_ima[l_i].imaacti_a,  #20210706
                              ima130   = g_ima[l_i].ima130_a    #20220812
                        WHERE ima01 = g_ima[l_i].ima01_b
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err('upd ima_file',SQLCA.SQLCODE,1)
             LET g_success = 'N'
             EXIT FOR
          ELSE
            # LET l_msg1 = "UPDATE,",g_ima[l_i].ima43_b,"->",g_ima[l_i].ima43_a CLIPPED
            # LET g_msg=TIME
            # INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
            # VALUES ('cimp003',g_user,g_today,g_msg,g_ima[l_i].ima01_b,l_msg1,g_plant,g_legal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","azo_file","cimp005","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              ROLLBACK WORK
              RETURN FALSE
           END IF
          END IF
      END FOR 
END FUNCTION

FUNCTION p115_insert()
   DEFINE  l_i       LIKE type_file.num5
   DEFINE l_msg1    LIKE type_file.chr1000
 
   LET g_success = 'Y'
   BEGIN WORK
      FOR l_i = 1 TO g_cnt
          IF g_ima[l_i].choice = 'N' THEN
             CONTINUE FOR
          END IF
          INSERT INTO imc_file (imc01,imc02,imc03,imc04)
                VALUES (g_ima[l_i].ima01_b,'CH',1,g_ima[l_i].ima02_01)
          INSERT INTO imc_file (imc01,imc02,imc03,imc04)
                VALUES (g_ima[l_i].ima01_b,'CH',2,g_ima[l_i].ima021_01)
                       
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err('insert imc_file',SQLCA.SQLCODE,1)
             LET g_success = 'N'
             EXIT FOR
          ELSE
            # LET l_msg1 = "UPDATE,",g_ima[l_i].ima43_b,"->",g_ima[l_i].ima43_a CLIPPED
            # LET g_msg=TIME
            # INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
            # VALUES ('cimp003',g_user,g_today,g_msg,g_ima[l_i].ima01_b,l_msg1,g_plant,g_legal)
           #IF SQLCA.sqlcode THEN
           #   CALL cl_err3("ins","azo_file","cimp005","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           #   ROLLBACK WORK
           #   RETURN FALSE
           #END IF
          END IF
      END FOR
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL p115_b()
         CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
      END IF 
END FUNCTION

FUNCTION p115_b()
   DEFINE l_exit LIKE type_file.chr1
 
   LET g_sql = "SELECT 'N',ima01,ima02,ima02,ima021,ima021,ima09,",
               "       ima09,ta_ima01,ta_ima08,ima1007 ",
               "  FROM ima_file ",
               " WHERE  ",g_wc CLIPPED
        
 
   PREPARE p005_prepare FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('PREPARE:',SQLCA.SQLCODE,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF   
 
   DECLARE p005_curs CURSOR FOR p005_prepare
 
   CALL g_ima.clear()
   CALL g_bne2.clear()

   LET g_cnt = 1
   FOREACH p005_curs INTO g_ima[g_cnt].*,g_bne2[g_cnt].*
      IF SQLCA.sqlcode THEN                                  #有問題
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      
      #IF NOT cl_null(tm.ecu01) THEN
      #   IF g_bne2[g_cnt].ima1916_1 != tm.ecu01 THEN
      #      CONTINUE FOREACH
      #   END IF 
      #END IF

      IF NOT cl_null(tm.ima09) THEN
         LET g_ima[g_cnt].ima09_a = tm.ima09
      ELSE
         LET g_ima[g_cnt].ima09_a = g_ima[g_cnt].ima09_b
      END IF
      IF NOT cl_null(tm.ta_ima01) THEN
         LET g_ima[g_cnt].ta_ima01_a = tm.ta_ima01
      END IF
      IF NOT cl_null(tm.ta_ima08) THEN
         LET g_ima[g_cnt].ta_ima08_a = tm.ta_ima01
      END IF
      IF NOT cl_null(tm.ima1007) THEN
         LET g_ima[g_cnt].ima1007_a = tm.ima1007
      END IF
      IF NOT cl_null(tm.i_ima02) THEN
         LET g_ima[g_cnt].ima02_a = tm.i_ima02
      END IF
      IF NOT cl_null(tm.i_ima021) THEN
         LET g_ima[g_cnt].ima021_a = tm.i_ima021
      END IF
      IF NOT cl_null(tm.i_ta_ima06) THEN
         LET g_ima[g_cnt].ta_ima06_a = tm.i_ta_ima06
      END IF
      ##---- 20200702 
      IF NOT cl_null(tm.ima10) THEN
         LET g_ima[g_cnt].ima10_a = tm.ima10
      ELSE
         LET g_ima[g_cnt].ima10_a = g_ima[g_cnt].ima10_b
      END IF

      IF NOT cl_null(tm.ima11) THEN
         LET g_ima[g_cnt].ima11_a = tm.ima11
      ELSE
         LET g_ima[g_cnt].ima11_a = g_ima[g_cnt].ima11_b
      END IF

      IF NOT cl_null(tm.ta_ima07) THEN
         LET g_ima[g_cnt].ta_ima07_a = tm.ta_ima07
      ELSE
         LET g_ima[g_cnt].ta_ima07_a = g_ima[g_cnt].ta_ima07_b
      END IF
      ##---- 20200702
      LET g_ima[g_cnt].choice = 'N'       
 
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

        ON ACTION insert_pn_spec_extra_desc      #20190605
           CALL p115_insert()                    #20190605
           
 
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
