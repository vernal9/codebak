# Prog. Version..: '5.30.09-13.09.06(00004)'     #
#
# Pattern name...: cimp006.4gl
# Descriptions...: 料號批次失效
# Date & Author..: 20210510 By momo
# Modify.........: 20210517 By momo 增加實際庫存量檢核
# Modify.........: 24100022 20241024 By momo 增加在途單據檢核
# Modify.........: NO.25010011 20250109 by momo 增加 存在主件BOM
# Modify.........: NO.25010024 20250115 by momo 增加 取替代相關卡控與主件BOM無效
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../4gl/aimi100.global"
 
#模組變數(Module Variables)
DEFINE 
    l_ac          LIKE type_file.num5,               
    g_wc          STRING, 
    g_ima         DYNAMIC ARRAY OF RECORD
                  choice    LIKE type_file.chr1,       #選擇
                  ima01_b   LIKE ima_file.ima01,       #變更料號編號
                  ima02_01  LIKE ima_file.ima02,       #品名
                  ima021_01 LIKE ima_file.ima021,      #規格
                  atp_qty   LIKE type_file.num15_3,    #預計可用量
                  unavl_stk LIKE type_file.num15_3,    #不可用量
                  bom       LIKE type_file.chr1,       #存在元件BOM否
                  mbom      LIKE type_file.chr1,       #存在主件BOM否 #20250109
                  other     LIKE type_file.chr1000     #其他卡控 20250115
                  END RECORD,
    g_rec_b       LIKE type_file.num5,  #單身筆數
    l_flag        LIKE type_file.chr1,
    g_sql         STRING
DEFINE   g_msg    LIKE type_file.chr1000 
DEFINE   g_cnt    LIKE type_file.num10  
##---- 20241024 add by momo (S)
DEFINE   Nbom     LIKE type_file.chr1
DEFINE  
    g_qty  RECORD 
                 unavl_stk  LIKE type_file.num15_3,   
                 avl_stk    LIKE type_file.num15_3,   
                 oeb_q      LIKE type_file.num15_3,   
                 sfa_q1     LIKE type_file.num15_3,   
                 sfa_q2     LIKE type_file.num15_3,   
                 misc_q1    LIKE type_file.num15_3,   
                 sfs_q2     LIKE type_file.num15_3,   
                 sie_q      LIKE type_file.num15_3,   
                 pml_q      LIKE type_file.num15_3,   
                 pmn_q      LIKE type_file.num15_3,   
                 rvb_q2     LIKE type_file.num15_3,   
                 rvb_q      LIKE type_file.num15_3,   
                 sfb_q1     LIKE type_file.num15_3,   
                 sfb_q2     LIKE type_file.num15_3,   
                 qcf_q      LIKE type_file.num15_3,   
                 atp_qty    LIKE type_file.num15_3
          END RECORD
##---- 20241024 add by momo (E) 
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
 
   OPEN WINDOW cimp006_w AT p_row,p_col WITH FORM "cim/42f/cimp006" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('z')
   WHILE TRUE
      CALL p006_tm()
      CALL p006_p1()
      IF INT_FLAG THEN LET INT_FLAG = 0 CONTINUE WHILE END IF #使用者中斷
      IF cl_sure(0,0) THEN 
          CALL p006_update() 
          IF g_success = 'Y' THEN
             COMMIT WORK
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
 
   CLOSE WINDOW p006_w
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
      RETURNING g_time
END MAIN

FUNCTION p006_tm()
   DEFINE   l_n     LIKE type_file.num5                  #screen array no
   DEFINE   l_len   LIKE type_file.num5                  #screen array no

   IF s_shut(0) THEN RETURN END IF
   CLEAR FORM
   CALL g_ima.clear()
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033

   CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021,ima140
   
   BEFORE CONSTRUCT
     DISPLAY 'Y' TO ima140

   ON ACTION CONTROLP
      CASE
        WHEN INFIELD(ima01)
             CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ima01
             NEXT FIELD ima01
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
  
   LET Nbom = 'Y'                         #20241024 
   INPUT BY NAME Nbom WITHOUT DEFAULTS    #20241024
     AFTER FIELD Nbom                     #20241024
   END INPUT                              #20241024 

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p006_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
END FUNCTION 
 
FUNCTION p006_p1()
   DEFINE l_exit LIKE type_file.chr1
   DEFINE l_note LIKE type_file.chr1000 #20250115

   IF cl_null(Nbom) THEN LET Nbom = 'N' END IF 
   IF Nbom = 'N' THEN 
     LET g_sql = "SELECT ' ',ima01,ima02,ima021,0,0,'N','N','' ",       #20250109 modify #20250115
                 "  FROM ima_file ",
                 " WHERE imaacti='Y' ",
                 "   AND NOT EXISTS (SELECT 1 FROM img_file WHERE img01=ima01 AND img10 > 0) ", #排除有庫存
                 " AND ",g_wc CLIPPED
   ELSE
     LET g_sql = "SELECT ' ',ima01,ima02,ima021,0,0,'N','N','' ",       #20250109 modify #20250115
                 "  FROM ima_file ",
                 " WHERE imaacti='Y' ",
                 "   AND NOT EXISTS (SELECT 1 FROM img_file WHERE img01=ima01 AND img10 > 0) ", #排除有庫存
                 "   AND NOT EXISTS (SELECT 1 FROM bmb_file,bma_file WHERE bma01=bmb01 ",
                 "                      AND bmb05 IS NULL and bmaacti='Y' AND bmb03=ima01) ",
                 "   AND ",g_wc CLIPPED
   END IF  
 
   PREPARE p006_prepare FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('PREPARE:',SQLCA.SQLCODE,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF   
 
   DECLARE p006_curs CURSOR FOR p006_prepare
 
   CALL g_ima.clear()
   INITIALIZE g_qty.* TO NULL    #20241024
   LET g_cnt = 1
   FOREACH p006_curs INTO g_ima[g_cnt].*
      IF SQLCA.sqlcode THEN                                  #有問題
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF

      CALL cs_q102_qty(g_ima[g_cnt].ima01_b)
           RETURNING g_qty.oeb_q, g_qty.sfa_q1, g_qty.sfa_q2, g_qty.sie_q,  g_qty.pml_q,
                     g_qty.pmn_q, g_qty.rvb_q2, g_qty.rvb_q,  g_qty.sfb_q1, g_qty.sfb_q2,
                     g_qty.qcf_q, g_qty.atp_qty,g_qty.misc_q1,g_qty.sfs_q2 

      SELECT SUM(img10*img21) INTO g_ima[g_cnt].unavl_stk
        FROM img_file
       WHERE img01 = g_ima[g_cnt].ima01_b AND img23 = 'N'  
      IF cl_null(g_ima[g_cnt].unavl_stk) THEN
         LET g_ima[g_cnt].unavl_stk = 0
      END IF 
      IF Nbom = 'Y' THEN LET g_ima[g_cnt].bom = 'N' 
      ELSE
         #元件BOM存在否
         SELECT 'Y' Y INTO g_ima[g_cnt].bom
           FROM bmb_file,bma_file
          WHERE bmb01=bma01
            AND bmb03 = g_ima[g_cnt].ima01_b
            AND bmb05 is null 
            AND bmaacti = 'Y'
            AND rownum = 1
       END IF
 
         ##---- 20250115 取替代資訊(S)
         LET l_note = ''
         SELECT 'abmi604' INTO l_note
           FROM bmd_file
          WHERE bmd04 = g_ima[g_cnt].ima01_b
            AND bmd06 IS NULL AND bmdacti='Y'
         LET g_ima[g_cnt].other = l_note
         LET l_note = ''

         SELECT 'abmi611' INTO l_note
           FROM bob_file
          WHERE bob04 = g_ima[g_cnt].ima01_b
            AND bob11 IS NULL 
         LET g_ima[g_cnt].other = g_ima[g_cnt].other,l_note
         LET l_note = ''

         SELECT case tc_bmd02 when '3' then 'cbmi605' 
                              when '9' then 'cbmi605'
                              else 'cbmi604' end 
           INTO l_note
           FROM tc_bmd_file
          WHERE tc_bmd04 = g_ima[g_cnt].ima01_b
            AND tc_bmd06 IS NULL
         LET g_ima[g_cnt].other = g_ima[g_cnt].other,l_note
         ##---- 20250115 取替代資訊(E)

         ##--- 20250109 主件BOM存在否 (S)
         SELECT 'Y' Y INTO g_ima[g_cnt].mbom
           FROM bma_file
          WHERE bma01 = g_ima[g_cnt].ima01_b
            AND bmaacti = 'Y'
            AND rownum = 1
         ##--- 20250109 主件BOM (E)
      IF cl_null(g_ima[g_cnt].bom) THEN LET g_ima[g_cnt].bom ='N' END IF
      IF cl_null(g_ima[g_cnt].mbom) THEN LET g_ima[g_cnt].mbom ='N' END IF #20250109

      LET g_ima[g_cnt].atp_qty = g_qty.oeb_q + g_qty.sfa_q1 + g_qty.sfa_q2 + g_qty.sie_q + g_qty.pml_q+     #20241024
                                 g_qty.pmn_q + g_qty.rvb_q2+ g_qty.rvb_q + g_qty.sfb_q1 + g_qty.sfb_q2+     #20241024
                                 g_qty.qcf_q + g_qty.misc_q1 + g_qty.sfs_q2                                 #20241024
       
     #IF g_ima[g_cnt].unavl_stk > 0 OR g_ima[g_cnt].atp_qty> 0 OR g_ima[g_cnt].bom='Y' OR g_ima[g_cnt].mbom='Y' THEN  #20250109
      IF g_ima[g_cnt].unavl_stk > 0 OR g_ima[g_cnt].atp_qty> 0 OR g_ima[g_cnt].bom='Y' OR NOT cl_null(g_ima[g_cnt].other) THEN  #20250109
         LET g_ima[g_cnt].choice = 'N'
      ELSE
         LET g_ima[g_cnt].choice = 'Y'  
      END IF

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
           CALL p006_sel_all("Y")

        ON ACTION select_non
           CALL p006_sel_all("N")

        ON ACTION exporttoexcel2
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','')
 
        ON ACTION controls                       #No.FUN-6B0033                                                                       
           CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
     
     END INPUT
     IF INT_FLAG THEN RETURN END IF   #使用者中斷
     IF l_exit = 'y' THEN EXIT WHILE END IF
   END WHILE
END FUNCTION
 
FUNCTION p006_update()
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_msg1    LIKE type_file.chr1000
 
   LET g_success = 'Y'
   BEGIN WORK
      FOR l_i = 1 TO g_cnt
          IF g_ima[l_i].choice = 'N' THEN
             CONTINUE FOR
          END IF
         #IF g_ima[l_i].atp_qty =0 AND g_ima[l_i].unavl_stk= 0 AND g_ima[l_i].bom='N' AND g_ima[l_i].mbom='N' THEN  #20250109 #20250115 mark
          IF g_ima[l_i].atp_qty =0 AND g_ima[l_i].unavl_stk= 0 AND g_ima[l_i].bom='N' AND cl_null(g_ima[l_i].other) THEN  #20250115
             UPDATE ima_file SET imaacti = 'N',
                                 imamodu = g_user,
                                 imadate = g_today
                           WHERE ima01 = g_ima[l_i].ima01_b
          END IF
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err('upd ima_file',SQLCA.SQLCODE,1)
             LET g_success = 'N'
             EXIT FOR
          ELSE
             #--20250115 主件BOM無效 
             IF g_ima[l_i].mbom='Y' THEN
                UPDATE bma_file
                   SET bmaacti='N',
                       bmamodu=g_user,
                       bmadate=g_today
                   WHERE bma01=g_ima[l_i].ima01_b
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                   CALL cl_err('upd bma_file',SQLCA.SQLCODE,1)
                   LET g_success = 'N'
                   EXIT FOR
                END IF
             END IF
             #--20250115 主件BOM無效 
          END IF
      END FOR 
END FUNCTION


FUNCTION p006_sel_all(p_value)
  DEFINE p_value      LIKE type_file.chr1
  DEFINE l_i          LIKE type_file.num10

  FOR l_i = 1 TO g_ima.getLength()
      LET g_ima[l_i].choice = p_value
  END FOR

END FUNCTION
