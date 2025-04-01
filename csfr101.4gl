# Prog. Version..: '5.30.09-13.09.06(00009)'     #
#
# Pattern name...: csfr101.4gl
# Descriptions...: 製程工單在製報表
# Date & Author..: No.0000162019_06_M105 15/03/10 By TSD.JIE
# Modify.........: No.QBRBQ1620000005 15/04/02 By TSD.JIE
# Modify.........: No.                15/04/14 By TSD.JIE
#                  1.待入庫量:最後一個製程良品轉出數總和-入庫數(跟原本的邏輯相反，請看下方圖示)
#                  2.報表會依照每個營運中心設定的工作站資料全部展出，然後再填入數字。但如工作站是無效的就可以不用列出
# Modify.........: No.TPS150423 15/04/23 By TPS.peggy 調整待入庫量=最後一站的良出+BONUS-已完工入庫(同如asfr810)
# Modify.........: NO.web000356595 15/05/05 By TPS.peggy 調整各製程站的WIP量計算，考慮盤點量。
# Modify.........: 20150610 By HC.momo 增加是否分段投料 sfa08。
#                  當分段投料的欄位為Y時，總WIP量的算法為aecq700各站的WIP量加總
# Modify.........: 20150714 By HC.momo 調整製程顯示的位置
#modify .........20150824 zdl  add ima11 机种
#modify .........20151010 zdl  add azf03 机种名称
DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD
              wc      STRING,
              more    LIKE type_file.chr1
           END RECORD
DEFINE g_i               LIKE type_file.num10
DEFINE g_quote           STRING
DEFINE lc_channel        base.Channel
DEFINE g_ss_num          LIKE type_file.chr10
DEFINE g_ecd_h           DYNAMIC ARRAY OF RECORD
                  ecd01      LIKE ecd_file.ecd01,
                  ecd02      LIKE ecd_file.ecd02
                         END RECORD
DEFINE g_xls             RECORD
          sfb13             STRING,   #預計開工日
          sfb15             STRING,   #預計完工日
          ima11           STRING,   #机种  20150824 zdl add
          azf03           STRING,   #机种名称  20151010 zdl add
          sfb05             STRING,   #料號        #QBRBQ1620000005 TSD.JIE
          ima02             STRING,   #品名        #QBRBQ1620000005 TSD.JIE
          ima021            STRING,   #規格
          sfb01             STRING,   #工單編號
          sfb94             STRING,   #FQC否
          sfa08             STRING,   #是否為分段投料 #20150610
          sfb08             STRING,   #生產數量
          min_set           STRING,   #工單齊料套數
          ecm292            STRING,   #盤點量
          tot_wip           STRING,   #總WIP量
          qcf22             STRING,   #FQC
          scrap             STRING,   #報廢
          qty               STRING,   #待入庫
          sfb09             STRING,   #入庫
          sum               STRING ,   #總計 (右方)
          dd           LIKE type_file.num10 ,   #天数 15090910 add by zdl g_today
           yj     LIKE type_file.chr1,  #预警 15090910 add by zdl
          yq      LIKE type_file.chr1  #逾期15090910 add by zdl
                         END RECORD
DEFINE g_xls_wipqty      DYNAMIC ARRAY OF STRING      #WIP量 (明細)
DEFINE g_sum             LIKE type_file.num20_6       #總計 (右方)


DEFINE g_sum_tot         RECORD                       #總計 (下方)
          sfb08             LIKE type_file.num20_6,   #生產數量
          min_set           LIKE type_file.num20_6,   #工單齊料套數
          ecm292            LIKE type_file.num20_6,   #盤點量
          tot_wip           LIKE type_file.num20_6,   #總WIP量
          qcf22             LIKE type_file.num20_6,   #FQC
          scrap             LIKE type_file.num20_6,   #報廢
          qty               LIKE type_file.num20_6,   #待入庫
          sfb09             LIKE type_file.num20_6,   #入庫
          sum               LIKE type_file.num20_6    #總計 (右方)
                         END RECORD
DEFINE g_sum_tot2        DYNAMIC ARRAY OF LIKE type_file.num15_3  #WIP量 (總和)


MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET tm.wc =ARG_VAL(1)

   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r101_tm(0,0)
      ELSE CALL r101()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r101_tm(p_row,p_col)
   DEFINE lc_qbe_sn    LIKE gbm_file.gbm01
   DEFINE p_row,p_col  LIKE type_file.num5,
          l_cmd        LIKE type_file.chr1000

   OPEN WINDOW r101_w AT p_row,p_col WITH FORM "csf/42f/csfr101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL cl_set_comp_visible("gr5230",FALSE) #隱藏INPUT

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'

   WHILE TRUE
    DISPLAY BY NAME tm.more
      CONSTRUCT BY NAME tm.wc ON sfb01,gen02,sfb81,sfb05,sfb87,
                                 sfb04,ima02,ima021,sfb08,sfb081,
                                 sfb06,ecm03,ecm04,ecd02,ecm52,
                                 sfb13,sfb15,ecm313

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION controlp
            CASE
              WHEN INFIELD(sfb01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb01
                NEXT FIELD sfb01

              WHEN INFIELD(sfb05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb05
                NEXT FIELD sfb05

              WHEN INFIELD(ecm04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ecd3"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ecm04
                NEXT FIELD ecm04
            END CASE

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT CONSTRUCT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT

         ON ACTION qbe_select
            CALL cl_qbe_select()
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r520_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('',9046,0)
         CONTINUE WHILE
      END IF

 DISPLAY BY NAME tm.more 
      INPUT BY NAME tm.more WITHOUT DEFAULTS
       
        # BEFORE INPUT
         #   CALL cl_qbe_display_condition(lc_qbe_sn)
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
       
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r101_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='csfr101'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('csfr101','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                            " '",tm.wc CLIPPED,"'"
            CALL cl_cmdat('csfr101',g_time,l_cmd)
         END IF
         CLOSE WINDOW r101_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r101()
      ERROR ""
   END WHILE
   CLOSE WINDOW r101_w
END FUNCTION

FUNCTION r101()
   DEFINE l_sql        STRING,
          l_name       LIKE type_file.chr1000,
          l_fname      LIKE type_file.chr1000,  #檔案名稱
          m_file       LIKE type_file.chr1000,
          l_file       LIKE type_file.chr1000,
          l_cnt        LIKE type_file.num5
   DEFINE res          LIKE type_file.num10
 
   DEFINE sr           RECORD
                sfb13    LIKE sfb_file.sfb13,
                sfb15    LIKE sfb_file.sfb15,
                 ima11 LIKE  ima_file.ima11, #20150824zdl add
                 azf03 LIKE  azf_file.azf03, #20151010zdl add
                sfb05    LIKE sfb_file.sfb05,    #QBRBQ1620000005 TSD.JIE
                ima02    LIKE ima_file.ima02,    #QBRBQ1620000005 TSD.JIE
                ima021   LIKE ima_file.ima021,
                ima153   LIKE ima_file.ima153,
                sfb01    LIKE sfb_file.sfb01,
                sfb94    LIKE sfb_file.sfb94,
                sfb08    LIKE sfb_file.sfb08,
                ecm292   LIKE ecm_file.ecm292,
                sfb09    LIKE sfb_file.sfb09
                       END RECORD
   DEFINE l_data       LIKE type_file.chr1
   DEFINE l_min_set    LIKE sfb_file.sfb09     #齊料套數
   DEFINE l_tot_wip    LIKE sfb_file.sfb09     #總WIP量
   DEFINE l_qcf22      LIKE qcf_file.qcf22     #FQC
   DEFINE l_srg07      LIKE srg_file.srg07     #作廢數量
   DEFINE l_shb112     LIKE shb_file.shb112    #當站報廢
   DEFINE l_shb111     LIKE shb_file.shb111    #良品轉出數量
   DEFINE l_shb115     LIKE shb_file.shb115    #BONUS  #NO.TPS150423 add by TPS.peggy
   DEFINE l_ecm311     LIKE ecm_file.ecm311    #良品轉出數量
   DEFINE l_scrap      LIKE shb_file.shb112    #報廢
   DEFINE l_qty        LIKE sfv_file.sfv09     #待入庫
   DEFINE l_sfa08      LIKE type_file.chr1     #是否為分段投料 #20150610

   CALL ('csfr101') RETURNING l_name
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL s_showmsg_init()

   CALL r101_xls_def()  #準備整份報表所需的變數

  #------------------------------------------------------#
   LET g_ss_num = "s40"
   LET g_quote = """"
   LET l_fname = 'csfr101_',g_today USING 'YYYYMMDD', ".xls"
   LET m_file = FGL_GETENV("TEMPDIR") CLIPPED,"/",l_fname
   LET lc_channel = base.channel.create()
   CALL lc_channel.openFile(m_file,"w")
   CALL lc_channel.setDelimiter("")
   CALL r101_H_xls()  #excel 頭
  #------------------------------------------------------#

   LET l_sql = " SELECT sfb13,sfb15,ima131,oba02,", #20150824zdl add ima11 #20151010zdl add azf03
               "        sfb05,ima02, ", #QBRBQ1620000005 TSD.JIE
               "        ima021,ima153, ",
               "        sfb01,sfb94,sfb08, ",
               "        SUM(ecm292),sfb09  ",
               "   FROM sfb_file,ecm_file,",
               "        gen_file,ecd_file,ima_file ",
                "                LEFT OUTER JOIN oba_file ON ima131=oba01  ",#20151010 zdl add azf03
               "  WHERE sfb01 = ecm01 ",
               "    AND ima01 = sfb05 ",
               "    AND sfb44 = gen01 ",
               "    AND ecm04 = ecd01 ",
               "    AND sfb93 = 'Y' ",    #製程
               "    AND sfb04 <> '8' ",   #狀態碼
               "    AND sfb28 IS NULL ",     #NO.TPS150423 add by TPS.peggy
               "    AND sfb87 = 'Y' ",    #確認   #TSD.JIE 150326
               "    AND ",tm.wc,
               "  GROUP BY sfb13,sfb15, ima131,",#20150824zdl add ima11
               "           sfb05,ima02, ", #QBRBQ1620000005 TSD.JIE
               "           ima021,ima153, ",
               "           sfb01,sfb94,sfb08, ",
               "           sfb09 ,oba02 " #20151010zdl add azf03
   PREPARE r101_pre FROM l_sql
   DECLARE r101_cur CURSOR FOR r101_pre


   LET l_data = 'N'
   FOREACH r101_cur INTO sr.*
      IF cl_null(sr.ima153) THEN LET sr.ima153 = 0 END IF
      IF cl_null(sr.sfb94) THEN LET sr.sfb94 = 'N' END IF
      IF cl_null(sr.sfb08) THEN LET sr.sfb08 = 0 END IF
      IF cl_null(sr.ecm292) THEN LET sr.ecm292 = 0 END IF
      IF cl_null(sr.sfb09) THEN LET sr.sfb09 = 0 END IF
      
      ##----- 20150610 Begin 分段投料
      #151030 先判斷單身備料是否大於一顆料
      LET l_cnt = 0
      SELECT count(*) INTO l_cnt FROM sfa_file 
       WHERE sfa01 = sr.sfb01 
       LET l_sfa08='N'
      IF l_cnt > 1 THEN  #151030 備料多顆料時再判斷是否為分段  
        LET l_cnt=0
      SELECT count(*) INTO l_cnt FROM sfa_file 
       WHERE sfa01 = sr.sfb01 
        #AND (sfa08 is null OR sfa08 = ' ')       #20150729 151030 by HCJ 有作業編號表有分段
         AND (sfa08 is not null AND sfa08 <> ' ' )  #151116 add AND sfa08 <> ' ' by ytchen AND sfb08 <> ' '     #151030 by HCJ 有作業編號表有分段
     #IF l_cnt > 0 THEN LET l_sfa08 ='N' ELSE LET l_sfa08 = 'Y' END IF
      IF l_cnt > 0 THEN LET l_sfa08 ='Y' ELSE LET l_sfa08 = 'N' END IF
      END IF #151030 by HCJ
      
      ##----- 2050610 End

      #工單齊料套數
      CALL s_minp(sr.sfb01,g_sma.sma73,sr.ima153,'','','','')
           RETURNING l_cnt,l_min_set
      IF l_cnt != 0 THEN LET l_min_set = 0 END IF
      IF cl_null(l_min_set) THEN LET l_min_set = 0 END IF


      #FQC
      LET l_qcf22 = 0
      IF sr.sfb94 = 'Y' THEN
         SELECT SUM(NVL(qcf22,0))
           INTO l_qcf22
           FROM qcf_file
          WHERE qcf00 = '1'        #1.工單
            AND qcf02 = sr.sfb01   #工單編號
            AND qcf14 = 'N'        #N.未確認
         IF cl_null(l_qcf22) THEN LET l_qcf22 = 0 END IF
      END IF

      #asft700 當站報廢
      LET l_shb112 = 0
      SELECT SUM(shb112)
        INTO l_shb112
        FROM shb_file
       WHERE shb05 = sr.sfb01
         AND shbconf = 'Y'   #確認否
      IF cl_null(l_shb112) THEN LET l_shb112 = 0 END IF

      #asft300 作廢數量
      LET l_srg07 = 0
      SELECT SUM(srg07)
        INTO l_srg07
        FROM srg_file,srf_file
       WHERE srg16 = sr.sfb01
         AND srf01 = srg01
         AND srfconf = 'Y'   #確認否
      IF cl_null(l_srg07) THEN LET l_srg07 = 0 END IF


      #報廢
      LET l_scrap = l_shb112 + l_srg07 


      #總WIP量=齊料套數-入庫-報廢
      
      ####------- 20150610 Begin      
      #LET l_tot_wip = l_min_set - sr.sfb09 - l_scrap
      IF l_sfa08 = 'N' THEN 
         LET l_tot_wip = l_min_set - sr.sfb09 - l_scrap
      ELSE
         SELECT SUM(ecm301+ecm302+ecm303-ecm311-ecm312-ecm313-ecm314-ecm316-ecm292) 
           INTO l_tot_wip 
           FROM ecm_file 
          WHERE ecm01=sr.sfb01
      END IF
      ####-------- 20150610 End
      
      ##入庫量
      #LET l_sfv09 = ''
      #SELECT SUM(NVL(sfv09,0)) INTO l_sfv09
      #  FROM sfv_file,sfu_file
      # WHERE sfv01 = sfu01
      #   AND sfuconf = 'Y'
      #   AND sfupost = 'N'
      #   AND sfv11 = sr.sfb01
      #IF cl_null(l_sfv09) THEN LET l_sfv09 = 0 END IF

      #最後一站 良品轉出數量
      LET l_shb111 = 0
      SELECT SUM(shb111),SUM(shb115) INTO l_shb111,l_shb115  #NO.TPS150423 add shb115 by TPS.peggy
        FROM shb_file
       WHERE shb05 = sr.sfb01
         AND shbconf = 'Y'                                    #TSD.danny2000 20150417
         AND shb06 = (SELECT MAX(ecm03) FROM ecm_file
                       WHERE ecm01 = sr.sfb01)
      IF cl_null(l_shb111) THEN LET l_shb111 = 0 END IF
      IF cl_null(l_shb115) THEN LET l_shb115 = 0 END IF   #NO.TPS150423 add shb115 by TPS.peggy

      #待入庫
      #LET l_qty = l_shb111 - sr.sfb09   #150414 TSD.JIE mark
     #LET l_qty = sr.sfb09 - l_shb111    #150414 TSD.JIE mod  #NO.TPS150423 mark by TPS.peggy
      LET l_qty = l_shb111 + l_shb115 - sr.sfb09    #150414 TSD.JIE mod  #NO.TPS150423 add by TPS.peggy
      #160302 add by HCJ 台灣和昌要用實際開工日
       IF g_aza.aza26 ='0' THEN 
          SELECT MIN(tlf06) INTO sr.sfb13 FROM tlf_file
           WHERE tlf62= sr.sfb01                 #工單
             AND tlf13 LIKE  'asfi5%'     #異動命令
             AND tlf02='50'                   #來源為倉庫
       END IF 
      #準備EXCEL資料
      LET g_sum = 0
      INITIALIZE g_xls.* TO NULL
      LET g_xls.sfb13  = sr.sfb13    #預計開工日
      LET g_xls.sfb15  = sr.sfb15    #預計完工日
      LET g_xls.ima11  = sr.ima11   #机种         #20150824zdl add
      LET g_xls.azf03  = sr.azf03   #机种名称        #20151010zdl add
      LET g_xls.sfb05  = sr.sfb05    #料號         #QBRBQ1620000005 TSD.JIE
      LET g_xls.ima02  = sr.ima02    #品名         #QBRBQ1620000005 TSD.JIE
      LET g_xls.ima021 = sr.ima021   #規格
      LET g_xls.sfb01  = sr.sfb01    #工單編號
      LET g_xls.sfb94  = sr.sfb94    #FQC否
      LET g_xls.sfa08  = l_sfa08    #分段投料否  #20150610
      LET g_xls.sfb08  = sr.sfb08    #生產數量
      LET g_xls.min_set = l_min_set  #工單齊料套數
      LET g_xls.ecm292  = sr.ecm292  #盤點量
      LET g_xls.tot_wip = l_tot_wip  #總WIP量
      LET g_xls.qcf22  = l_qcf22     #FQC
      LET g_xls.scrap  = l_scrap     #報廢
      LET g_xls.qty    = l_qty       #待入庫
      LET g_xls.sfb09  = sr.sfb09    #入庫

      CALL r101_wipqty(sr.sfb01)

      LET g_xls.sum = g_sum          #總計 (右方)

      #總計 (下方)
      LET g_sum_tot.sfb08   = g_sum_tot.sfb08   + sr.sfb08    #生產數量
      LET g_sum_tot.min_set = g_sum_tot.min_set + l_min_set   #工單齊料套數
      LET g_sum_tot.ecm292  = g_sum_tot.ecm292  + sr.ecm292   #盤點量
      LET g_sum_tot.tot_wip = g_sum_tot.tot_wip + l_tot_wip   #總WIP量
      LET g_sum_tot.qcf22   = g_sum_tot.qcf22   + l_qcf22     #FQC
      LET g_sum_tot.scrap   = g_sum_tot.scrap   + l_scrap     #報廢
      LET g_sum_tot.qty     = g_sum_tot.qty     + l_qty       #待入庫
      LET g_sum_tot.sfb09   = g_sum_tot.sfb09   + sr.sfb09    #入庫
      LET g_sum_tot.sum     = g_sum_tot.sum     + g_sum       #總計 (右方)
      IF g_xls.tot_wip>0 THEN 
        LET g_xls.dd = g_xls.sfb15 -g_today    # 150910 add 差异天数 
       END IF 
      IF g_xls.dd <=2  AND g_xls.dd >=0  THEN 
         LET g_xls.yj='Y'
          
       END IF 
       IF g_xls.dd <0 THEN 
         LET g_xls.yq='Y'
         LET g_xls.yj='Y'
       END IF 
       
      
      CALL r101_body_xls()  #excel 明細
      LET l_data = 'Y'
   END FOREACH

   CALL r101_tail_xls()  #excel 尾


   IF l_data ='Y' THEN

      CALL lc_channel.close()

      IF g_bgjob = 'N' THEN
         LET l_file = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/", l_fname
         CALL ui.Interface.frontCall("standard",
                                  "shellexec",
                                  ["EXPLORER \"" || l_file || "\""],
                                  [res])
         IF STATUS THEN
            CALL cl_err("Front End Call failed.", STATUS, 1)
            LET g_success = 'N'
         END IF
      ELSE
         #LET m_file = FGL_GETENV("TEMPDIR") CLIPPED,"/", 'cxcr101_'||g_today USING 'YYYYMMDD' ,".xls"
         LET l_file = "C:/tiptop/",l_fname
         LET l_file = 'csfr101_',g_today USING 'YYYYMMDD','.xls'
         IF NOT cl_download_file(m_file CLIPPED,l_file ) THEN
            CALL s_errmsg('','',l_file,'anm1008',1)
            LET g_success = 'N'
         END IF
      END IF

      #CALL cl_open_prog("excel",l_file) RETURNING g_i

   ELSE
      CALL lc_channel.close()
      CALL s_errmsg('','','','mfg3382',1)
      LET g_success = 'N'
   END IF

   CALL s_showmsg()

END FUNCTION

#準備整份報表所需的變數
FUNCTION r101_xls_def()
   DEFINE l_sql        STRING
   DEFINE l_ecd01      LIKE ecd_file.ecd01
   DEFINE l_ecd02      LIKE ecd_file.ecd02

   #作業編號
   LET l_sql = "SELECT ecd01,ecd02 ",
               "  FROM ecd_file ",
               " WHERE ecdacti = 'Y' ", #150414 TSD.JIE
               "  AND EXISTS (SELECT * FROM ecm_file,sfb_file WHERE ecm04=ecd01 AND ecm01=sfb01 AND sfb04 <'8' AND sfb87 <> 'X')",
               " ORDER BY ecd01 "

   PREPARE r101_h_xls_pr FROM l_sql
   DECLARE r101_h_xsl_cs CURSOR FOR r101_h_xls_pr

   LET g_i = 1
   CALL g_ecd_h.clear()
   FOREACH r101_h_xsl_cs INTO l_ecd01,l_ecd02
      LET g_ecd_h[g_i].ecd01 = l_ecd01
      LET g_ecd_h[g_i].ecd02 = l_ecd02

      #清空變數
      LET g_sum_tot2[g_i] = 0   #WIP量 (總和)

      LET g_i = g_i + 1
   END FOREACH
   CALL g_ecd_h.deleteElement(g_i)
   LET g_i = 0

   #清空變數
   LET g_sum_tot.sfb08   = 0    #生產數量
   LET g_sum_tot.min_set = 0    #工單齊料套數
   LET g_sum_tot.ecm292  = 0    #盤點量
   LET g_sum_tot.tot_wip = 0    #總WIP量
   LET g_sum_tot.qcf22   = 0    #FQC
   LET g_sum_tot.scrap   = 0    #報廢
   LET g_sum_tot.qty     = 0    #待入庫
   LET g_sum_tot.sfb09   = 0    #入庫
   LET g_sum_tot.sum     = 0    #總計 (右方)
END FUNCTION

#各製程之WIP量
FUNCTION r101_wipqty(p_sfb01)
   DEFINE p_sfb01      LIKE sfb_file.sfb01
   DEFINE l_sql        STRING
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_wipqty     LIKE type_file.num15_3
   DEFINE l_sum_wipqty LIKE type_file.num15_3
   DEFINE l_ecm        RECORD
              ecm54       LIKE ecm_file.ecm54,
              ecm291      LIKE ecm_file.ecm291,
              ecm292      LIKE ecm_file.ecm292,  #NO.web000356595 add by TPS.peggy
              ecm301      LIKE ecm_file.ecm301,
              ecm302      LIKE ecm_file.ecm302,
              ecm303      LIKE ecm_file.ecm303,
              ecm311      LIKE ecm_file.ecm311,
              ecm312      LIKE ecm_file.ecm312,
              ecm313      LIKE ecm_file.ecm313,
              ecm314      LIKE ecm_file.ecm314,
              ecm316      LIKE ecm_file.ecm316,
              ecm321      LIKE ecm_file.ecm321,
              ecm322      LIKE ecm_file.ecm322
                       END RECORD

   #該元件品號製程資料之加工單價(ecb48)
   LET l_sql = "SELECT ecm54,ecm291,ecm292, ",  #NO.web000356595 add by TPS.peggy
               "       ecm301,ecm302,ecm303, ",
               "       ecm311,ecm312,ecm313, ",
               "       ecm314,ecm316, ",
               "       ecm321,ecm322  ",
               "  FROM ecm_file ",
               " WHERE ecm01 = '",p_sfb01,"'",
               "   AND ecm04 = ? "

   PREPARE r004_wipqty_pr FROM l_sql
   DECLARE r004_wipqty_cs CURSOR FOR r004_wipqty_pr

   CALL g_xls_wipqty.clear()

   LET l_sum_wipqty = 0

   FOR l_i = 1 TO g_ecd_h.getlength()

      LET l_wipqty = 0
      FOREACH r004_wipqty_cs USING g_ecd_h[l_i].ecd01
                              INTO l_ecm.*
         IF cl_null(l_ecm.ecm291) THEN LET l_ecm.ecm291 = 0 END IF
         IF cl_null(l_ecm.ecm292) THEN LET l_ecm.ecm292 = 0 END IF
         IF cl_null(l_ecm.ecm301) THEN LET l_ecm.ecm301 = 0 END IF
         IF cl_null(l_ecm.ecm302) THEN LET l_ecm.ecm302 = 0 END IF
         IF cl_null(l_ecm.ecm303) THEN LET l_ecm.ecm303 = 0 END IF
         IF cl_null(l_ecm.ecm311) THEN LET l_ecm.ecm311 = 0 END IF
         IF cl_null(l_ecm.ecm312) THEN LET l_ecm.ecm312 = 0 END IF
         IF cl_null(l_ecm.ecm313) THEN LET l_ecm.ecm313 = 0 END IF
         IF cl_null(l_ecm.ecm314) THEN LET l_ecm.ecm314 = 0 END IF
         IF cl_null(l_ecm.ecm316) THEN LET l_ecm.ecm316 = 0 END IF
         IF cl_null(l_ecm.ecm321) THEN LET l_ecm.ecm321 = 0 END IF
         IF cl_null(l_ecm.ecm322) THEN LET l_ecm.ecm322 = 0 END IF

         IF l_ecm.ecm54='Y' THEN   #check in 否
            LET l_wipqty = l_wipqty
                         + l_ecm.ecm291    #check in
                         - l_ecm.ecm311    #良品轉出
                         - l_ecm.ecm312    #重工轉出
                         - l_ecm.ecm313    #當站報廢
                         - l_ecm.ecm314    #當站下線
                         - l_ecm.ecm316
         #                - l_ecm.ecm321    #委外加工量
         #                + l_ecm.ecm322    #委外完工量
         ELSE
            LET l_wipqty = l_wipqty
                         + l_ecm.ecm301    #良品轉入量
                         + l_ecm.ecm302    #重工轉入量
                         + l_ecm.ecm303
                         - l_ecm.ecm311    #良品轉出
                         - l_ecm.ecm312    #重工轉出
                         - l_ecm.ecm313    #當站報廢
                         - l_ecm.ecm314    #當站下線
                         - l_ecm.ecm316
                         - l_ecm.ecm292    #盤點量  #NO.web000356595 add by TPS.peggy
         #                - l_ecm.ecm321    #委外加工量
         #                + l_ecm.ecm322    #委外完工量
         END IF

      END FOREACH

      LET l_sum_wipqty = l_sum_wipqty + l_wipqty

      LET g_xls_wipqty[g_xls_wipqty.getlength() + 1] = l_wipqty   #WIP量 (明細)

      LET g_sum_tot2[l_i] = g_sum_tot2[l_i] + l_wipqty            #WIP量 (總和)

   END FOR

   LET g_sum = g_sum + l_sum_wipqty #總計 (右方)

END FUNCTION

FUNCTION r101_H_xls()  #excel 頭
   DEFINE l_str     STRING ,
          l_sql     STRING,
          l_line    STRING
   DEFINE l_MergeAcross   LIKE type_file.num5

   LET l_str = "<?xml version=",g_quote,"1.0",g_quote,"?>"
   CALL lc_channel.write(l_str CLIPPED)
   LET l_str = "<?mso-application progid=",g_quote,"Excel.Sheet",g_quote,"?>"
   CALL lc_channel.write(l_str CLIPPED)
   LET l_str = "<Workbook xmlns:C=",g_quote,"urn:schemas-microsoft-com:office:component:spreadsheet",g_quote
   CALL lc_channel.write(l_str CLIPPED)
   LET l_str = " xmlns:html=",g_quote,"http://www.w3.org/TR/REC-html40",g_quote
   CALL lc_channel.write(l_str CLIPPED)
   LET l_str = " xmlns:o=",g_quote,"urn:schemas-microsoft-com:office:office",g_quote
   CALL lc_channel.write(l_str CLIPPED)
   LET l_str = " xmlns:xsi=",g_quote,"http://www.w3.org/2001/XMLSchema-instance",g_quote
   CALL lc_channel.write(l_str CLIPPED)
   LET l_str = " xmlns=",g_quote,"urn:schemas-microsoft-com:office:spreadsheet",g_quote
   CALL lc_channel.write(l_str CLIPPED)
   LET l_str = " xmlns:x2=",g_quote,"http://schemas.microsoft.com/office/excel/2003/xml",g_quote
   CALL lc_channel.write(l_str CLIPPED)
   LET l_str = " xmlns:ss=",g_quote,"urn:schemas-microsoft-com:office:spreadsheet",g_quote
   CALL lc_channel.write(l_str CLIPPED)
   LET l_str = " xmlns:x=",g_quote,"urn:schemas-microsoft-com:office:excel",g_quote,">"
   CALL lc_channel.write(l_str CLIPPED)
   #--------------------#

   LET l_line = #格線
              "  <Borders> ",
              "   <Border ss:Position=",g_quote,"Bottom",g_quote," ss:LineStyle=",g_quote,"Continuous",g_quote," ss:Weight=",g_quote,"1",g_quote,"/> ",
              "   <Border ss:Position=",g_quote,"Left",g_quote," ss:LineStyle=",g_quote,"Continuous",g_quote," ss:Weight=",g_quote,"1",g_quote,"/> ",
              "   <Border ss:Position=",g_quote,"Right",g_quote," ss:LineStyle=",g_quote,"Continuous",g_quote," ss:Weight=",g_quote,"1",g_quote,"/> ",
              "   <Border ss:Position=",g_quote,"Top",g_quote," ss:LineStyle=",g_quote,"Continuous",g_quote," ss:Weight=",g_quote,"1",g_quote,"/> ",
              "  </Borders> "

   LET l_str = "<Styles> ",
              " <Style ss:ID=",g_quote,"s40",g_quote,">",  #顯示小數0位,零顯示'-'
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"_-* #,##0_-;\-* #,##0_-;_-* &quot;-&quot;??_-;_-@_-",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s41",g_quote,">",  #顯示小數1位,零顯示'-'
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"_-* #,##0.0_-;\-* #,##0.0_-;_-* &quot;-&quot;??_-;_-@_-",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s42",g_quote,">",  #顯示小數2位,零顯示'-'
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s43",g_quote,">",  #顯示小數3位,零顯示'-'
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;??_-;_-@_-",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s44",g_quote,">",  #顯示小數4位,零顯示'-'
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"_-* #,##0.0000_-;\-* #,##0.0000_-;_-* &quot;-&quot;??_-;_-@_-",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s45",g_quote,">",  #顯示小數5位,零顯示'-'
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"_-* #,##0.00000_-;\-* #,##0.00000_-;_-* &quot;-&quot;??_-;_-@_-",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s46",g_quote,">",  #顯示小數6位,零顯示'-'
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"_-* #,##0.000000_-;\-* #,##0.000000_-;_-* &quot;-&quot;??_-;_-@_-",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s47",g_quote,">",  #顯示小數7位,零顯示'-'
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"_-* #,##0.0000000_-;\-* #,##0.0000000_-;_-* &quot;-&quot;??_-;_-@_-",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s48",g_quote,">",  #顯示小數8位,零顯示'-'
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"_-* #,##0.00000000_-;\-* #,##0.00000000_-;_-* &quot;-&quot;??_-;_-@_-",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s49",g_quote,">",  #顯示小數9位,零顯示'-'
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"_-* #,##0.000000000_-;\-* #,##0.000000000_-;_-* &quot;-&quot;??_-;_-@_-",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",

              " <Style ss:ID=",g_quote,"s50",g_quote,">",  #顯示小數0位
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"0_ ",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s51",g_quote,">",  #顯示小數1位
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"0.0_ ",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s52",g_quote,">",  #顯示小數2位
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"0.00_ ",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s53",g_quote,">",  #顯示小3數位
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"0.000_ ",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s54",g_quote,">",  #顯示小數4位
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"0.0000_ ",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s55",g_quote,">",  #顯示小數5位
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"0.00000_ ",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s56",g_quote,">",  #顯示小數6位
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"0.000000_ ",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s57",g_quote,">",  #顯示小數7位
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"0.0000000_ ",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s58",g_quote,">",  #顯示小數8位
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"0.00000000_ ",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",
              " <Style ss:ID=",g_quote,"s59",g_quote,">",  #顯示小數9位
              "  <Alignment ss:Horizontal=",g_quote,"Right",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <NumberFormat ss:Format=",g_quote,"0.000000000_ ",g_quote,"/>",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,"/> ",
              " </Style>",

              " <Style ss:ID=",g_quote,"Default",g_quote," ss:Name=",g_quote,"Normal",g_quote,"> ",
              "  <Alignment ss:Vertical=",g_quote,"Center",g_quote,"/> ",
              "  <Borders/> ",
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,
              "   ss:Color=",g_quote,"#000000",g_quote,"/> ",
              "  <Interior/> ",
              "  <NumberFormat/> ",
              "  <Protection/> ",
              " </Style> ",
              " <Style ss:ID=",g_quote,"s62",g_quote,"> ", #靠左
              "  <Alignment ss:Horizontal=",g_quote,"Left",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,
              "   ss:Color=",g_quote,"#000000",g_quote,"/> ",
              "  <Interior/> ",
              "  <NumberFormat/> ",
              "  <Protection/> ",
              " </Style> ",
              " <Style ss:ID=",g_quote,"s63",g_quote,"> ",  #置中
              "  <Alignment ss:Horizontal=",g_quote,"Center",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",

              l_line,
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,
              "   ss:Color=",g_quote,"#000000",g_quote,"/> ",
              "  <Interior/> ",
              "  <NumberFormat/> ",
              "  <Protection/> ",
              " </Style> ",



              --------------------------------zdl-------------------------------
 " <Style ss:ID=",g_quote,"s68",g_quote,"> ", #靠左
              "  <Alignment ss:Horizontal=",g_quote,"Left",g_quote," ss:Vertical=",g_quote,"Top",g_quote,"/> ",
              l_line,
              "  <Font ss:FontName=",g_quote,"新細明體",g_quote," x:CharSet=",g_quote,"136",g_quote," x:Family=",g_quote,"Roman",g_quote," ss:Size=",g_quote,"11",g_quote,
              "   ss:Color=",g_quote,"#FF3030",g_quote,"/> ",
              "  <Interior/> ",
              "  <NumberFormat/> ",
              "  <Protection/> ",
              " </Style> ",




----------------------------------------------------------------------------------

              "</Styles> "

            
   CALL lc_channel.write(l_str CLIPPED)

   #--------------------#

   LET l_str = "<Worksheet ss:Name=",g_quote,"csfr101",g_quote,"> "
   CALL lc_channel.write(l_str CLIPPED)
   LET l_str = '<Table> ',
               #QBRBQ1620000005 TSD.JIE --(S) mark
               #'<Column ss:Width="66.75" ss:Span="2"/> ',
               #'<Column ss:Index="4" ss:Width="90"/> ',
               #QBRBQ1620000005 TSD.JIE --(E) mark
               #QBRBQ1620000005 TSD.JIE --(S)
               '<Column ss:Width="66.75" ss:Span="1" /> ',
               '<Column ss:Index="3" ss:Width="93" /> ',    #料號
               '<Column ss:Width="93"/> ',                 #品名
               #'<Column ss:Index="3" ss:Width="93"  ss:Color=",g_quote,"#DC143C",g_quote"/> ',                 #規格
               '<Column ss:Width="90"/> ',
               #QBRBQ1620000005 TSD.JIE --(E)
               '<Column ss:Width="40.5"/> ',
               '<Column ss:AutoFitWidth="0" ss:Width="56.25"/> ',
               '<Column ss:Width="79.5"/> ',
               '<Column ss:AutoFitWidth="0" ss:Width="56.25" ss:Span="46"/> '

   CALL lc_channel.write(l_str CLIPPED)

   #跨欄至中
   #LET l_MergeAcross = 6   #QBRBQ1620000005 TSD.JIE mark
  # LET l_MergeAcross = 8    #QBRBQ1620000005 TSD.JIE mod
  # LET l_MergeAcross = 9    #20150714 mod
    LET l_MergeAcross = 14    #20150824 zdl 13>14

   #---抬頭1
   LET l_str = "  <Row>",
               "  <Cell ss:MergeAcross=",g_quote,l_MergeAcross,g_quote," ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[14],"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>"
               
              # "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>"    #20150824 zdl add

   #作業編號
   FOR  g_i = 1 TO g_ecd_h.getlength()
      LET l_str = l_str ,
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_ecd_h[g_i].ecd01,"</Data></Cell>"
   END FOR

   ##總計
   #LET l_str = l_str ,
   #           "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[15],"</Data></Cell>"

   LET l_str = l_str , "  </Row> "
   CALL lc_channel.write(l_str CLIPPED)


   #---抬頭2
   LET l_str ="  <Row>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[20],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[21],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[22],"</Data></Cell>",   #20150824zdl add
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[1],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[2],"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[19],"</Data></Cell>",   #20150824zdl add
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[23],"</Data></Cell>",   #20150824zdl add
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[16],"</Data></Cell>",   #QBRBQ1620000005 TSD.JIE
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[17],"</Data></Cell>",   #QBRBQ1620000005 TSD.JIE
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[3],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[4],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[5],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[18],"</Data></Cell>",   #20150609
              
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[6],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[7],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[8],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[9],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[10],"</Data></Cell>",

              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[11],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[12],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[13],"</Data></Cell>"

   #作業編號說明
   FOR g_i = 1 TO g_ecd_h.getlength()
      LET l_str = l_str ,
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_ecd_h[g_i].ecd02,"</Data></Cell>"
   END FOR

   #總計
   #LET l_str = l_str ,
   #           "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>" 
   LET l_str = l_str , "  </Row> "
   CALL lc_channel.write(l_str CLIPPED)
END FUNCTION


FUNCTION r101_tail_xls()  #excel 尾
   DEFINE l_str        STRING
   DEFINE l_ss_azi03   LIKE type_file.chr10   #本國幣別取位
   DEFINE l_str_ecb48  STRING
   DEFINE l_str_tot    STRING
   DEFINE l_sum_ecb48  LIKE ecb_file.ecb48
   DEFINE l_MergeAcross   LIKE type_file.num5
   DEFINE l_xls             RECORD            #總計 (下方)
             sfb08             STRING,        #生產數量
             min_set           STRING,        #工單齊料套數
             ecm292            STRING,        #盤點量
             tot_wip           STRING,        #總WIP量
             qcf22             STRING,        #FQC
             scrap             STRING,        #報廢
             qty               STRING,        #待入庫
             sfb09             STRING,        #入庫
             sum               STRING         #總計 (右方)
                            END RECORD

   LET l_ss_azi03 = 's40'
   CASE g_azi03
      WHEN 0  LET l_ss_azi03 = 's40'
      WHEN 1  LET l_ss_azi03 = 's41'
      WHEN 2  LET l_ss_azi03 = 's42'
      WHEN 3  LET l_ss_azi03 = 's43'
      WHEN 4  LET l_ss_azi03 = 's44'
      WHEN 5  LET l_ss_azi03 = 's45'
      WHEN 5  LET l_ss_azi03 = 's45'
      WHEN 6  LET l_ss_azi03 = 's46'
      WHEN 7  LET l_ss_azi03 = 's47'
      WHEN 8  LET l_ss_azi03 = 's48'
      WHEN 9  LET l_ss_azi03 = 's49'
   END CASE

   INITIALIZE l_xls.* TO NULL
   LET l_xls.sfb08   = g_sum_tot.sfb08       #生產數量
   LET l_xls.min_set = g_sum_tot.min_set     #工單齊料套數
   LET l_xls.ecm292  = g_sum_tot.ecm292      #盤點量
   LET l_xls.tot_wip = g_sum_tot.tot_wip     #總WIP量
   LET l_xls.qcf22   = g_sum_tot.qcf22       #FQC
   LET l_xls.scrap   = g_sum_tot.scrap       #報廢
   LET l_xls.qty     = g_sum_tot.qty         #待入庫
   LET l_xls.sfb09   = g_sum_tot.sfb09       #入庫
   LET l_xls.sum     = g_sum_tot.sum         #總計 (右方)

   #跨欄至中
   #LET l_MergeAcross = 4   #QBRBQ1620000005 TSD.JIE mark
   #LET l_MergeAcross = 6    #QBRBQ1620000005 TSD.JIE mod
    #LET l_MergeAcross = 7   #20150610
     LET l_MergeAcross = 12   #20150824 zdl 11 #20151010 zdl 12
    
    
   #頁尾
   LET l_str = "  <Row>",
               "  <Cell ss:MergeAcross=",g_quote,l_MergeAcross,g_quote," ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[15],"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",l_xls.sfb08  ,"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",l_xls.min_set,"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",l_xls.ecm292 ,"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",l_xls.tot_wip,"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",l_xls.qcf22  ,"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",l_xls.scrap  ,"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",l_xls.qty    ,"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",l_xls.sfb09  ,"</Data></Cell>"

   FOR g_i = 1 TO g_ecd_h.getlength()

      LET l_str_tot = g_sum_tot2[g_i]

      LET l_str = l_str,
                  "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",l_str_tot,"</Data></Cell>"

   END FOR

   #總計
   #LET l_str = l_str,
   #            "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",l_xls.sum    ,"</Data></Cell>"

   LET l_str = l_str , "  </Row> "

   CALL lc_channel.write(l_str CLIPPED)

#  #頁尾
#  LET l_str = "  <Row>",
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",

#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",

#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> ",
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> "


#  FOR g_i = 1 TO g_ecb17.getlength()
#     LET l_str = l_str,
#                 "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> "
#  END FOR

#  #小計
#  LET l_str = l_str,
#              "   <Cell ss:StyleID=",g_quote,"s62",g_quote,"/> "

#  LET l_str = l_str , "  </Row> "

#  CALL lc_channel.write(l_str CLIPPED)
   LET l_str = "</Table>"
   CALL lc_channel.write(l_str)
   LET l_str = "</Worksheet>"
   CALL lc_channel.write(l_str)
   LET l_str = "</Workbook>"
   CALL lc_channel.write(l_str)
END FUNCTION


FUNCTION r101_body_xls()  #excel 明細
   DEFINE l_str        STRING
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_ss_azi03   LIKE type_file.chr10   #本國幣別取位

   LET l_ss_azi03 = 's40'
   CASE g_azi03
      WHEN 0  LET l_ss_azi03 = 's40'
      WHEN 1  LET l_ss_azi03 = 's41'
      WHEN 2  LET l_ss_azi03 = 's42'
      WHEN 3  LET l_ss_azi03 = 's43'
      WHEN 4  LET l_ss_azi03 = 's44'
      WHEN 5  LET l_ss_azi03 = 's45'
      WHEN 5  LET l_ss_azi03 = 's45'
      WHEN 6  LET l_ss_azi03 = 's46'
      WHEN 7  LET l_ss_azi03 = 's47'
      WHEN 8  LET l_ss_azi03 = 's48'
      WHEN 9  LET l_ss_azi03 = 's49'
   END CASE

   LET l_str =
          "  <Row> ",
           "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.yj,"</Data></Cell>" ,
           "  <Cell   ss:StyleID=",g_quote,"s68",g_quote,"><Data ss:Type=",g_quote,"String",g_quote," >",g_xls.yq ,"</Data></Cell>",
            "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.dd ,"</Data></Cell>"  ,
            "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.sfb13  ,"</Data></Cell>",     #A
          "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.sfb15 ,"</Data></Cell>",      #B
          "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.ima11 ,"</Data></Cell>",      #20150824 zdl add
           "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.azf03 ,"</Data></Cell>",      #20151010 zdl add
          "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.sfb05 ,"</Data></Cell>",       #QBRBQ1620000005 TSD.JIE
          "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.ima02 ,"</Data></Cell>",       #QBRBQ1620000005 TSD.JIE
          "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.ima021 ,"</Data></Cell>",     #C
          "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.sfb01,"</Data></Cell>",       #D
          "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.sfb94 ,"</Data></Cell>",      #E
           "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.sfa08 ,"</Data></Cell>",     #E #20150610
          "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",g_xls.sfb08 ,"</Data></Cell>",   #F
          "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",g_xls.min_set,"</Data></Cell>",  #G
          "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",g_xls.ecm292 ,"</Data></Cell>",  #H
          "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",g_xls.tot_wip ,"</Data></Cell>", #I
          "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",g_xls.qcf22 ,"</Data></Cell>",   #J
          "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",g_xls.scrap ,"</Data></Cell>",   #K
          "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",g_xls.qty   ,"</Data></Cell>",   #L
          "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",g_xls.sfb09 ,"</Data></Cell>"   #M
          
   #各製程之WIP量
   FOR l_i = 1 TO g_ecd_h.getlength()
      LET l_str = l_str,
             "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",g_xls_wipqty[l_i],"</Data></Cell>"
   END FOR
   #LET l_str = l_str,
  #  "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.yj,"</Data></Cell>" ,
    #       "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.yq ,"</Data></Cell>",
      #      "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.dd ,"</Data></Cell>"  
   #總計
   #LET l_str = l_str,
   #       "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",g_xls.sum,"</Data></Cell>"

   LET l_str = l_str,
          "  </Row> "

   CALL lc_channel.write(l_str CLIPPED)
END FUNCTION

