# Prog. Version..: '5.10.16-10.10.14(00007)'     #
# Pattern name...: csfq022.4gl
# Descriptions...: 工單明細查詢
# Date & Author..: 

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

#模組變數(Module Variables)
DEFINE
    tm          RECORD
                  wc            STRING, 
                  wc1           STRING  
    	        END RECORD,
    g_b1        DYNAMIC ARRAY OF RECORD
                  sfb01_1    LIKE sfb_file.sfb01,         #工單號碼
                  ta_sfb01_1 LIKE sfb_file.ta_sfb01,    #訂單單號序號
                  sfb81_1    LIKE sfb_file.sfb81,         #工單日
                  sfb04_1    LIKE sfb_file.sfb04,         #工單狀態
                  sfb05_1    LIKE sfb_file.sfb05,         #生產料號
                  ima02_1    LIKE ima_file.ima02,         #品名規格
                  ima021_1   LIKE ima_file.ima021,        #規格
                  sfb15_1    LIKE sfb_file.sfb15,         #預計完工日
                  sfb081_1   LIKE sfb_file.sfb081,        #發料套數
                  sfb09_1    LIKE sfb_file.sfb09,         #完工數
                  sfb12_1    LIKE sfb_file.sfb12,         #報廢數
                  wip_1      LIKE sfb_file.sfb09          #總wip數
                END RECORD,
    g_b2        DYNAMIC ARRAY OF RECORD
                  ecm01_2    LIKE ecm_file.ecm01,    #工單編號
                  ecm03_2    LIKE ecm_file.ecm03,    #製程序
                  ecm45_2    LIKE ecm_file.ecm45,    #作業名稱
                  ecm52_2    LIKE ecm_file.ecm52,    #委外
                  wip_2      LIKE ecm_file.ecm301,   #wip量
                  ecm313     LIKE ecm_file.ecm313    #報廢量
                END RECORD,
    g_b2_attr    DYNAMIC ARRAY OF RECORD
                  ecm01_2    STRING,    #工單編號
                  ecm03_2    STRING,    #製程序
                  ecm45_2    STRING,    #作業名稱
                  ecm52_2    STRING    #委外
                END RECORD,
    g_b3        DYNAMIC ARRAY OF RECORD
                  pmn43_3    LIKE pmn_file.pmn43,    #製程序
                  ta_pmn01_3 LIKE ecm_file.ecm45,    #作業編號
                  pmm01_3    LIKE pmm_file.pmm01,    #採購單號
                  pmc03_3    LIKE pmc_file.pmc03,    #廠商簡稱
                  pmn02_3    LIKE pmn_file.pmn02,    #採購項次
                  pmn33_3    LIKE pmn_file.pmn33,    #到廠日
                  pmn20_3    LIKE pmn_file.pmn20,    #採購數量
                  pmn50_3    LIKE pmn_file.pmn50,    #入庫量
                  pmn55_3    LIKE pmn_file.pmn55,    #驗退量
                  netqty_3   LIKE pmn_file.pmn20,    #可收量
                  qty1_3     LIKE pmn_file.pmn20,    #QC合格量
                  qty2_3     LIKE pmn_file.pmn20,    #QC報廢
                  qty3_3     LIKE pmn_file.pmn20     #已入庫量
                END RECORD,
    g_b3_attr    DYNAMIC ARRAY OF RECORD
                 pmn43_3    STRING,    #製程序
                 ta_pmn01_3 STRING,    #作業編號
                 pmm01_3    STRING     #採購單號
                END RECORD,
    g_b4       DYNAMIC ARRAY OF RECORD
                 sfa03_1      LIKE sfa_file.sfa03,   #發料料號
                 ima02_4      LIKE ima_file.ima02,   #品名
                 ima021_4     LIKE ima_file.ima021,  #規格
                 sfa12_1      LIKE sfa_file.sfa12,   #發料單位
                 sfa05_1      LIKE sfa_file.sfa05,   #應發量
                 sfa06_1      LIKE sfa_file.sfa06,   #已發量
                 sfa062_1     LIKE sfa_file.sfa062,  #超領量
                 sfa161_1     LIKE sfa_file.sfa161,  #QPA
                 sfa08_1      LIKE sfa_file.sfa08,   #作業編號
                 sfa07_1      LIKE sfa_file.sfa07,   #欠料量
                 img10_1      LIKE img_file.img10,   #庫存量
                 img04_1      LIKE img_file.img04    #批號
                 END RECORD,
    g_b4_attr   DYNAMIC ARRAY OF RECORD
                 sfa03_1      STRING,
                 ima02_4      STRING,   #品名
                 ima021_4     STRING,   #規格
                 sfa12_1      STRING,   #發料單位
                 sfa05_1      STRING,   #應發量
                 sfa06_1      STRING,   #已發量
                 sfa062_1     STRING,   #超領量
                 sfa161_1     STRING,   #QPA
                 sfa08_1      STRING,   #作業編號
                 sfa07_1      STRING,   #欠料量
                 img10_1      STRING,
                 img04_1      STRING
                 END RECORD,
     g_b5       DYNAMIC ARRAY OF RECORD
                 pmn01_5      LIKE pmn_file.pmn01,   #採購單號
                 pmn02_5      LIKE pmn_file.pmn02,   #採購項次
                 pmm09_5      LIKE pmm_file.pmm09,   #供應商
                 pmc03_5      LIKE pmc_file.pmc03,   #簡稱
                 pmn33_5      LIKE pmn_file.pmn33,   #交貨日
                 pmn20_5      LIKE pmn_file.pmn20,   #採購量
                 pmn50_5      LIKE pmn_file.pmn50,   #交貨量
                 pmn51_5      LIKE pmn_file.pmn51,   #在驗量
                 pmn56_5      LIKE pmn_file.pmn56    #批號
                 END RECORD,
    g_b5_attr   DYNAMIC ARRAY OF RECORD
                 pmn01_5      STRING,   #採購單號
                 pmn02_5      STRING,   #採購項次
                 pmm09_5      STRING,   #供應商
                 pmc03_5      STRING,   #簡稱
                 pmn33_5      STRING,   #交貨日
                 pmn20_5      STRING,   #採購量
                 pmn50_5      STRING,   #交貨量
                 pmn51_5      STRING,   #在驗量
                 pmn56_5      STRING    #批號
                 END RECORD,
    g_wc,g_sql    STRING,       
    g_rec_b1      LIKE type_file.num10,          #單身1筆數
    g_rec_b2      LIKE type_file.num10,          #單身2筆數
    g_rec_b3      LIKE type_file.num10,          #單身3筆數
    g_rec_b4      LIKE type_file.num10,          #單身4筆數
    g_rec_b5      LIKE type_file.num10           #單身5筆數

DEFINE   p_row,p_col     LIKE type_file.num5 
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_msg           LIKE ze_file.ze03,
         l_ac1           LIKE type_file.num5,    #目前處理的ARRAY CNT
         l_ac2           LIKE type_file.num5,    #目前處理的ARRAY CNT
         l_ac3           LIKE type_file.num5,    #目前處理的ARRAY CNT
         l_ac4           LIKE type_file.num5,    #目前處理的ARRAY CNT
         l_ac5           LIKE type_file.num5     #目前處理的ARRAY CNT

DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10


MAIN

   OPTIONS                                       #改變一些系統預設值
        FORM LINE       FIRST + 2,               #畫面開始的位置
        MESSAGE LINE    LAST,                    #訊息顯示的位置
        PROMPT LINE     LAST,                    #提示訊息的位置
        INPUT NO WRAP                            #輸入的方式: 不打轉
   DEFER INTERRUPT                               #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)                 #計算使用時間 (進入時間)
         RETURNING g_time

   LET p_row = 4 LET p_col = 2

   OPEN WINDOW q022_w AT p_row,p_col
        WITH FORM "csf/42f/csfq022"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   CALL q022_menu()
   CLOSE WINDOW q022_w
   CALL  cl_used(g_prog,g_time,2)                 #計算使用時間 (退出使間)
         RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION q022_cs()
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_pmn01        LIKE pmn_file.pmn01

   CALL cl_set_head_visible("","YES")

   CLEAR FORM                                 #清除畫面
   CALL g_b1.clear()
   CALL g_b2.clear()
   CALL g_b3.clear()
   CALL g_b4.clear()
   CALL g_b5.clear()

   CALL cl_opmsg('q')

   WHILE TRUE

      INITIALIZE tm.* TO NULL
      LET l_ac1 = 1
      LET l_ac2 = 1
      LET l_ac3 = 1
      LET l_ac4 = 1
      LET l_ac5 = 1
      LET g_rec_b1 = 0
      LET g_rec_b2 = 0
      LET g_rec_b3 = 0
      LET g_rec_b4 = 0
      LET g_rec_b5 = 0


      DIALOG ATTRIBUTES(UNBUFFERED)


         CONSTRUCT BY NAME tm.wc ON sfb01,ta_sfb01,sfb05,ima11,sfb04,sfb15
            BEFORE CONSTRUCT
                CALL cl_set_act_visible('close',FALSE)
                CALL cl_qbe_init()
         END CONSTRUCT
 

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(sfb01)   #工單號碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfb"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb01
                  NEXT FIELD CURRENT
               WHEN INFIELD(ta_sfb01)   #訂單單號序號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oea"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ta_sfb01
                  NEXT FIELD CURRENT
               WHEN INFIELD(sfb05)  #生產料件
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form ="cq_ima01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb05
                  NEXT FIELD sfb05
               WHEN INFIELD(ima11)  #廠編
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form ="q_ima11_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima11
                  NEXT FIELD ima11
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
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
 
         ON ACTION accept
            EXIT DIALOG
  
         ON ACTION cancel
            LET INT_FLAG=1
            EXIT DIALOG

         ON ACTION exit
            LET INT_FLAG=1
            EXIT DIALOG
      END DIALOG
 
      IF INT_FLAG THEN RETURN END IF

      IF cl_null(tm.wc) THEN LET tm.wc = ' 1=1' END IF
   
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION q022_menu()
   DEFINE l_cmd          LIKE type_file.chr1000

   WHILE TRUE
      CALL q022_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q022_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_b1),'','')
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_b2),'','')
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_b3),'','')
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_b4),'','')
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_b5),'','')
            END IF
         WHEN "refresh_datae"
            IF cl_chk_act_auth() THEN
               IF cl_null(tm.wc) THEN
                  CALL cl_err('','apj-003',1)
               ELSE
                  CALL q022_show()
               END IF
            END IF
         #WHEN "po_details"
         #IF cl_chk_act_auth() THEN
         #     LET l_cmd = "apmq520 '",g_b3[l_ac3].pmm01_3,"' "
         #     CALL cl_cmdrun(l_cmd)
         #END IF
         ##---- 20171207 add (S)
         #收貨異常清單
         #WHEN "abnormal"
         #   IF cl_chk_act_auth() THEN   #MOD-D70084 add 
         #      CALL q022_2()
         #   END IF  
         ##---- 20171207 add (E)
      END CASE
   END WHILE
END FUNCTION

FUNCTION q022_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')

   CALL q022_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      RETURN
   END IF
   CALL q022_show()
   MESSAGE ''

END FUNCTION

FUNCTION q022_show()
  DEFINE l_sql STRING  #131219 by HCJ
  DEFINE l_buf          LIKE type_file.chr1000, #120730 by HCJ
         l_k,l_l,l_n    LIKE type_file.num5     #120730 by HCJ
   #  字串轉換 #
    IF tm.wc != " 1=1 "  THEN 
        LET tm.wc1 = tm.wc
        LET l_buf=tm.wc CLIPPED
        LET l_l=length(l_buf)
   #   FOR l_k=1 TO l_l-6
   #    IF l_buf[l_k,l_k+6]='sfb05' THEN
   #      LET l_buf[l_k,l_k+6]='tlf902 ' 
   #    END IF 
   #    IF l_buf[l_k,l_k+6]='tlff903' THEN  
   #      LET l_buf[l_k,l_k+6]='tlf903 ' 
   #    END IF 
   #   END FOR
       LET tm.wc = l_buf
       LET g_wc= tm.wc  
     END IF
  
   CALL q022_b_fill1()
   CALL q022_b_fill2()
   CALL q022_b_fill3()
   CALL q022_b_fill4()
   CALL cl_show_fld_cont()                  
END FUNCTION

FUNCTION q022_b_fill1()
   DEFINE l_sql        STRING
   DEFINE l_ima153   LIKE ima_file.ima153
   DEFINE l_cnt      LIKE type_file.num5
        

   LET l_sql = "SELECT sfb01,ta_sfb01,sfb13,sfb04,sfb05,ima02,ima021,sfb15,sfb081,sfb09,sfb12,'0' ",
               "  FROM ima_file,sfb_file",
         #     "  LEFT JOIN oeb_file ON oeb01||LPAD(oeb03,3,'0')=ta_sfb01 ",
               " WHERE sfb05 = ima01 ",
               "   AND sfb87<> 'X' ",
               "   AND ",tm.wc,
               " ORDER BY 2 "
 
   PREPARE q022_b1_pr FROM l_sql
   DECLARE q022_b1_cs CURSOR FOR q022_b1_pr

   CALL g_b1.clear()
   LET g_cnt = 1
   FOREACH q022_b1_cs INTO g_b1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach b_fill1:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
       SELECT ima153 INTO l_ima153 FROM ima_file
         WHERE ima01=g_b1[g_cnt].sfb05_1
       IF STATUS OR cl_null(l_ima153) THEN LET l_ima153=0 END IF 
       CALL s_minp(g_b1[g_cnt].sfb01_1,g_sma.sma73,l_ima153,'','','','')  
               RETURNING l_cnt,g_b1[g_cnt].sfb081_1

      #SELECT SUM(ecm301+ecm302+ecm303-ecm311-ecm312-ecm313-ecm314-ecm316-ecm292) INTO g_b1[g_cnt].wip_1 
      # FROM ecm_file
      #  WHERE ecm01=g_b1[g_cnt].sfb01_1
      SELECT COUNT(*) INTO g_b1[g_cnt].wip_1 
        FROM sfa_file
       WHERE sfa01 = g_b1[g_cnt].sfb01_1
         AND sfa05 > sfa06

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
      END IF
   END FOREACH

   CALL g_b1.deleteElement(g_cnt)
   LET g_rec_b1=g_cnt-1
   LET g_cnt = 0 
END FUNCTION

FUNCTION q022_b_fill2()
   DEFINE l_sql         STRING

   LET l_sql = "SELECT ecm01,ecm03,ecm04||'-'||ecm45,ecm52, ",
               "       SUM(ecm301+ecm302+ecm303-ecm311-ecm312-ecm313-ecm314-ecm316-ecm292),SUM(ecm313)  ",
               "  FROM ecm_file ",
               " WHERE ecm01 = '",g_b1[l_ac1].sfb01_1,"'",
               " GROUP BY ecm01, ecm03,ecm04||'-'||ecm45,ecm52 ",
               "  ORDER BY ecm03"

   PREPARE q022_b2_pr FROM l_sql
   DECLARE q022_b2_cs CURSOR FOR q022_b2_pr

   CALL g_b2.clear()
   LET g_cnt = 1
   FOREACH q022_b2_cs INTO g_b2[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach b_fill2:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
    IF g_b2[g_cnt].ecm52_2='Y' THEN  #151123 color
           let g_b2_attr[g_cnt].ecm52_2="MAGENTA REVERSE"
        ELSE
           let g_b2_attr[g_cnt].ecm52_2=""
        END IF  #151123

      #若庫存為0不顯示
    # IF g_b2[g_cnt].tlf10_2 = 0 THEN 
    #    CONTINUE FOREACH
    # END IF   

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH

   CALL g_b2.deleteElement(g_cnt)
   LET g_rec_b2=g_cnt-1
   LET g_cnt = 0 
END FUNCTION

FUNCTION q022_b_fill4()
   DEFINE l_sql         STRING

   LET l_sql = "SELECT sfa03,ima02,ima021,sfa12,sfa05,sfa06,sfa062,sfa161,sfa08,sfa05-sfa06,0,'' ",
               "  FROM sfa_file,ima_file ",
               " WHERE sfa03=ima01 AND sfa01 = '",g_b1[l_ac1].sfb01_1,"'",
               "  ORDER BY 7 DESC"

   PREPARE q022_b4_pr FROM l_sql
   DECLARE q022_b4_cs CURSOR FOR q022_b4_pr

   CALL g_b4.clear()
   LET g_cnt = 1
   FOREACH q022_b4_cs INTO g_b4[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach b_fill4:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      SELECT SUM(img10) INTO g_b4[g_cnt].img10_1
        FROM img_file
       WHERE img01 = g_b4[g_cnt].sfa03_1
         AND img23='Y'   

      IF g_b4[g_cnt].sfa07_1 > 0 THEN
          LET g_b4_attr[g_cnt].sfa07_1 ="RED"
      ELSE
         LET g_b4_attr[g_cnt].sfa07_1 =""
      END IF

      SELECT img04 INTO g_b4[g_cnt].img04_1 FROM img_file
       WHERE img01 = g_b4[g_cnt].sfa03_1
         AND img04 = g_b1[g_cnt].ta_sfb01_1
         AND img10 > 0

      IF NOT cl_null(g_b4[g_cnt].img04_1) THEN
         LET g_b4_attr[g_cnt].img04_1 ="MAGENTA REVERSE"
      ELSE
         LET g_b4_attr[g_cnt].img04_1 =""
      END IF 
     

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH

   CALL g_b4.deleteElement(g_cnt)
   LET g_rec_b4=g_cnt-1
   LET g_cnt = 0 
END FUNCTION

FUNCTION q022_b_fill5()
   DEFINE l_sql         STRING

   LET l_sql = "SELECT pmn01,pmn02,pmm09,pmc03,pmn33,pmn20,pmn50,pmn51,pmn56 ",
               "  FROM pmm_file,pmn_file,pmc_file ",
               " WHERE pmm01=pmn01 ",
               "   AND pmm09=pmc01 AND pmn16 NOT IN ('6','7','8','9')",
               "   AND pmn04 = '",g_b4[l_ac4].sfa03_1,"'",
               "   AND pmn20-pmn50+pmn55+pmn58 > 0",
               "UNION ",
               "SELECT pml01,pml02,ta_pml03,pmc03,pml33,pml20,pml21,0,ta_pml01 ",
               "  FROM pmk_file,pml_file ",
               " LEFT JOIN pmc_file ON pmc01 = ta_pml03 ",
               " WHERE pmk01=pml01 AND pml16 NOT IN ('6','7','8','9') ",
               "   AND pml20 - pml21 > 0 ",
               "   AND pml04 = '",g_b4[l_ac4].sfa03_1,"'"

   PREPARE q022_b5_pr FROM l_sql
   DECLARE q022_b5_cs CURSOR FOR q022_b5_pr

   CALL g_b5.clear()
   LET g_cnt = 1
   FOREACH q022_b5_cs INTO g_b5[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach b_fill5:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      IF g_b5[g_cnt].pmn56_5 = g_b1[l_ac1].ta_sfb01_1 THEN
         LET g_b5_attr[g_cnt].pmn56_5 ="MAGENTA REVERSE"
      ELSE
         LET g_b5_attr[g_cnt].pmn56_5 =""
      END IF 

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH

   CALL g_b5.deleteElement(g_cnt)
   LET g_rec_b5=g_cnt-1
   LET g_cnt = 0 
END FUNCTION


FUNCTION q022_b_fill3()
   DEFINE l_sql         STRING
   DEFINE l_img10       LIKE img_file.img10
   DEFINE l_pmn20       LIKE pmn_file.pmn20
   DEFINE l_pmn201      LIKE pmn_file.pmn20  #160808 add by HCJ
   DEFINE l_pmn202      LIKE pmn_file.pmn20  #160808 add by HCJ
   DEFINE l_pmn205      LIKE pmn_file.pmn20  #160808 add by HCJ
   DEFINE l_qty1        LIKE pmn_file.pmn20  #160809 add by HCJ
   DEFINE l_qty2        LIKE pmn_file.pmn20  #160809 add by HCJ
   DEFINE l_qty3        LIKE pmn_file.pmn20  #160809 add by HCJ

   LET l_sql = "SELECT pmn43,'',pmm01,pmc03,pmn02,pmn33,pmn20,pmn50,pmn55,(pmn20-pmn50+pmn55+pmn58),0,0,0 ", # by HCJ
               "  FROM pmm_file,pmn_file,pmc_file ",
               " WHERE pmm01 = pmn01 ",
               "   AND pmn41 = '",g_b1[l_ac1].sfb01_1,"'",
               "   AND pmn43 = '",g_b2[l_ac2].ecm03_2,"' ",
               "   AND pmc01=pmm09 ",
             # "   AND (pmn20-pmn50+pmn55+pmn58 > 0) ",  
               "   AND pmm18 <> 'X' ",  
               "   AND pmm02 = 'SUB' ",  
               " ORDER BY pmm01 "  

   PREPARE q022_b3_pr FROM l_sql
   DECLARE q022_b3_cs CURSOR FOR q022_b3_pr

   CALL g_b3.clear()
   LET g_cnt = 1
   LET l_pmn20=0
   LET l_pmn201=0  #160808
   LET l_pmn202=0  #160808
   LET l_pmn205=0  #160809 驗退量
   LET l_qty1=0  #160809 合格量
   LET l_qty2=0  #160809 報廢量
   LET l_qty3=0  #160809 入庫量
   FOREACH q022_b3_cs INTO g_b3[g_cnt].*

      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach b_fill3:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
         SELECT ecm45 INTO g_b3[g_cnt].ta_pmn01_3 FROM ecm_file
           WHERE ecm01=g_b1[l_ac1].sfb01_1
             AND ecm03=g_b3[g_cnt].pmn43_3
      LET l_pmn20 = l_pmn20+ g_b3[g_cnt].netqty_3
      LET l_pmn201= l_pmn201+ g_b3[g_cnt].pmn50_3
      LET l_pmn202= l_pmn202+ g_b3[g_cnt].pmn20_3
      LET l_pmn205= l_pmn205+ g_b3[g_cnt].pmn55_3
      SELECT SUM(qcs091) INTO g_b3[g_cnt].qty1_3 FROM qcs_file
       WHERE qcs01||qcs02 IN ( SELECT rvb01||rvb02 FROM rvb_file,rva_file
                          WHERE rvb04=g_b3[g_cnt].pmm01_3 AND rvb03=g_b3[g_cnt].pmn02_3 
                            AND rva01=rvb01 AND rvaconf='Y'
                            AND ta_rvb01= g_b3[g_cnt].pmn43_3)  #160321 by HCJ
         AND qcs14='Y'
      IF STATUS OR cl_null(g_b3[g_cnt].qty1_3) THEN LET g_b3[g_cnt].qty1_3=0 END IF 
      
      SELECT SUM(rvv17) INTO g_b3[g_cnt].qty3_3 FROM rvv_file,rvu_file
       WHERE rvv36=g_b3[g_cnt].pmm01_3 AND rvv37=g_b3[g_cnt].pmn02_3 
         AND rvu01=rvv01
         AND rvuconf='Y'
         AND rvu00='1'
      IF STATUS OR cl_null(g_b3[g_cnt].qty3_3) THEN LET g_b3[g_cnt].qty3_3=0 END IF 

      LET l_qty1= l_qty1+ g_b3[g_cnt].qty1_3
      LET l_qty2= 0
      LET l_qty3= l_qty3+ g_b3[g_cnt].qty3_3

      IF g_b3[g_cnt].pmn20_3-g_b3[g_cnt].netqty_3-g_b3[g_cnt].qty2_3-g_b3[g_cnt].qty3_3 > 0 THEN
           LET g_b3_attr[g_cnt].pmm01_3 ="MAGENTA REVERSE"
        ELSE
           LET g_b3_attr[g_cnt].pmm01_3 =""
        END IF
       
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
      END IF
   END FOREACH
   IF g_cnt >2 THEN 
     LET   g_b3[g_cnt].pmm01_3='TOTAL:'
     LET g_b3[g_cnt].netqty_3= l_pmn20
     LET g_b3[g_cnt].pmn50_3= l_pmn201
     LET g_b3[g_cnt].pmn20_3= l_pmn202
     LET g_b3[g_cnt].pmn55_3= l_pmn205  #160809總驗退量
     LET g_b3[g_cnt].qty1_3= l_qty1     #160809QC合格量
     LET g_b3[g_cnt].qty2_3= 0          #160809QC報廢量
     LET g_b3[g_cnt].qty3_3= l_qty3     #160809總入庫量
     LET g_cnt= g_cnt +1 
   END IF 
   CALL g_b3.deleteElement(g_cnt)
   LET g_rec_b3=g_cnt-1
   LET g_cnt = 0 
END FUNCTION



FUNCTION q022_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b1)
   CALL SET_COUNT(g_rec_b2)
   CALL SET_COUNT(g_rec_b3)
   CALL SET_COUNT(g_rec_b4)
   CALL SET_COUNT(g_rec_b5)

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY g_b1 TO s_b1.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            LET l_ac2 =1
            LET l_ac4 =1 
            CALL cl_show_fld_cont() 
            IF g_rec_b1 > 0 THEN
               DISPLAY g_b1[l_ac1].sfb01_1 TO sfb01
               DISPLAY g_b1[l_ac1].ta_sfb01_1 TO ta_sfb01
               CALL q022_b_fill2()
               CALL q022_b_fill3()
               CALL q022_b_fill4()
               CALL q022_b_fill5()
            END IF


         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG

         ON ACTION close
            LET INT_FLAG=FALSE 		
            LET g_action_choice="exit"
            EXIT DIALOG

      END DISPLAY

      DISPLAY ARRAY g_b2 TO s_b2.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE DISPLAY
              CALL DIALOG.setCellAttributes(g_b2_attr) 
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont() 

            IF g_rec_b2 > 0 THEN
               CALL q022_b_fill3()
            END IF
            
         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG

         ON ACTION close 
            LET INT_FLAG=FALSE 		
            LET g_action_choice="exit"
            EXIT DIALOG
         
      END DISPLAY

      DISPLAY ARRAY g_b4 TO s_b4.* ATTRIBUTE(COUNT=g_rec_b4)
         BEFORE DISPLAY
            CALL DIALOG.setCellAttributes(g_b4_attr)
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac4 = ARR_CURR()
            DISPLAY g_b4[l_ac4].sfa03_1 TO sfb05
            CALL cl_show_fld_cont()

            IF g_rec_b1 > 0 THEN
               CALL q022_b_fill4()
            END IF

            IF g_rec_b4 > 0 THEN
               CALL q022_b_fill5()
            END IF

         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG

         ON ACTION close
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG

      END DISPLAY

      DISPLAY ARRAY g_b3 TO s_b3.* ATTRIBUTE(COUNT=g_rec_b3)
         BEFORE DISPLAY
            CALL DIALOG.setCellAttributes(g_b3_attr)
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac3 = ARR_CURR()
            CALL cl_show_fld_cont() 
            
         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG

         ON ACTION close
            LET INT_FLAG=FALSE 		
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION po_details
            LET g_action_choice = 'po_details'
            EXIT DIALOG
    
      END DISPLAY

      DISPLAY ARRAY g_b5 TO s_b5.* ATTRIBUTE(COUNT=g_rec_b5)
         BEFORE DISPLAY
            CALL DIALOG.setCellAttributes(g_b5_attr)
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac5 = ARR_CURR()
            CALL cl_show_fld_cont()

         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG

         ON ACTION close
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG

      END DISPLAY


      BEFORE DIALOG 
         CALL cl_set_act_visible('close',FALSE)
         CALL cl_show_fld_cont()
         IF g_user ='tiptop'            
            then 
         ELSE 
         CALL cl_set_act_visible('inv_transit',FALSE)
         END IF 

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()      

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

     ON ACTION cancel
        LET INT_FLAG=FALSE 		
        LET g_action_choice="exit"
        EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 

      ON ACTION about        
         CALL cl_about()     

      ON ACTION exporttoexcel      
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON ACTION refresh_datae
         LET g_action_choice = 'refresh_datae'
         EXIT DIALOG

      #20171207 add 收貨異常
      #ON ACTION abnormal
      #   LET g_action_choice = 'abnormal'
      #   EXIT DIALOG

   END DIALOG

   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

##---- 20171207 add (S) 異常單據檢核
FUNCTION q022_2()
   DEFINE i		LIKE type_file.num5          
   DEFINE l_rvb DYNAMIC ARRAY OF RECORD
                rvbud01  LIKE rvb_file.rvbud01,   #狀況
                rvb01    LIKE rvb_file.rvb01,     #收貨單號
                rvb02    LIKE rvb_file.rvb02,     #收貨項次
                rvb39    LIKE rvb_file.rvb39,     #檢驗否
                rvb07    LIKE rvb_file.rvb07,     #收貨數量
                rvb29    LIKE rvb_file.rvb29,     #驗退量
                rvb30    LIKE rvb_file.rvb30      #入庫量
                END RECORD
   DEFINE l_t      LIKE type_file.num10   #No.FUN-680136 INTEGER
   DEFINE l_cmd    LIKE type_file.chr1000 

   IF g_b1[l_ac1].sfb01_1 IS NULL THEN RETURN END IF

 
   DECLARE q320_2_c CURSOR FOR
                SELECT '已收未驗',  rvb01, rvb02, rvb39, rvb07,rvb29, rvb30
                  FROM rvb_file,rva_file 
                  WHERE rvb34 = g_b1[l_ac1].sfb01_1 AND rvaconf='Y' AND rvb39='Y' AND rvb40 IS NULL
                    AND rva01=rvb01
                UNION
                SELECT '收貨未確認',  rvb01, rvb02, rvb39, rvb07,rvb29, rvb30
                  FROM rvb_file,rva_file
                  WHERE rvb34 = g_b1[l_ac1].sfb01_1 AND rvaconf='N' AND rvb39='Y' AND rvb40 IS NULL
                    AND rva01=rvb01
                SELECT '驗退未確認',  rvu02, rvv05, 'Y' ,0,rvv17,0,0
                  FROM rvv_file,rvu_file
                  WHERE rvv18 = g_b1[l_ac1].sfb01_1 
                    AND rvv01=rvu01
                    AND rvuconf='N' AND rvu00='2'
                UNION
                SELECT '入庫未確認',  rvu02, rvv05, 'Y' ,0,0,rvv17,0
                  FROM rvv_file,rvu_file
                  WHERE rvv18 = g_b1[l_ac1].sfb01_1
                    AND rvv01=rvu01
                    AND rvuconf='N' AND rvu00='1'
                                   
   LET i = 1
   LET p_row = 14 LET p_col = 2
   OPEN WINDOW q022_bw AT p_row,p_col
        WITH FORM "csf/42f/csfq022b"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("csfq022b")
   CALL cl_load_act_list(NULL)   #FUN-610098 add
 
   FOREACH q320_2_c INTO l_rvb[i].*
      IF STATUS THEN EXIT FOREACH END IF
      
      LET i = i + 1 
        IF i > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
   END FOREACH
 
 #MOD-480532
   DISPLAY ARRAY l_rvb TO s_rvb.*
     BEFORE DISPLAY
 
   ON ACTION apmt200
      LET l_t = ARR_CURR()
      LET l_cmd = "apmt200 '",l_rvb[l_t].rvb01,"' "
      CALL cl_cmdrun(l_cmd) 
 
   ON ACTION exit
      LET g_action_choice="exit"
      EXIT DISPLAY
 
   #TQC-860019-begin-add
    ON IDLE g_idle_seconds
       CALL cl_on_idle  ()
       CONTINUE DISPLAY
   #TQC-860019-end-add
 
   END DISPLAY
 
 
  LET INT_FLAG = 0
  CLOSE WINDOW q022_bw
END FUNCTION
##---- 20171207 add (E)


