# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cecr002.4gl
# Descriptions...: 在製工單作業編號狀況表列印
# Date & Author..: 20250312 By momo
 
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
          ecd01          LIKE ecd_file.ecd01,
          ecd02          LIKE ecd_file.ecd02
                         END RECORD
DEFINE g_xls             RECORD
          ecm01             STRING,   #工單單號
          sfb04             STRING,   #工單狀態
          sfb08             STRING,   #生產數量
          sfb05             STRING,   #生產數量
          ima02             STRING,   #工單齊料套數
          ima021            STRING
                         END RECORD
DEFINE g_xls_wipqty      DYNAMIC ARRAY OF STRING      #WIP量 (明細)
DEFINE g_xls_subqty      DYNAMIC ARRAY OF STRING      #在外量 (明細)
DEFINE g_sum             LIKE type_file.num20_6       #總計 (右方)
DEFINE l_data            LIKE type_file.chr1

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

   IF (NOT cl_setup("CEC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET tm.wc =ARG_VAL(1)

   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r002_tm(0,0)
      ELSE CALL r002()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r002_tm(p_row,p_col)
   DEFINE lc_qbe_sn    LIKE gbm_file.gbm01
   DEFINE p_row,p_col  LIKE type_file.num5,
          l_cmd        LIKE type_file.chr1000

   OPEN WINDOW r002_w AT p_row,p_col WITH FORM "cec/42f/cecr002"
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
      CONSTRUCT BY NAME tm.wc ON ecm01,ecm03_par,ecm04,ima06
                                 

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION controlp
            CASE
              WHEN INFIELD(ecm01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ecm01
                NEXT FIELD ecm01

              WHEN INFIELD(ecm03_par)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ecm03_par
                NEXT FIELD ecm03_par

              WHEN INFIELD(ecm04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ecd3"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ecm04
                NEXT FIELD ecm04

              WHEN INFIELD(ima06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima06"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima06
                NEXT FIELD ima06
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
         CLOSE WINDOW r002_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='cecr002'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('cecr002','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                            " '",tm.wc CLIPPED,"'"
            CALL cl_cmdat('cecr002',g_time,l_cmd)
         END IF
         CLOSE WINDOW r002_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r002()
      ERROR ""
   END WHILE
   CLOSE WINDOW r002_w
END FUNCTION

FUNCTION r002()
   DEFINE l_sql        STRING,
          l_name       LIKE type_file.chr1000,
          l_fname      LIKE type_file.chr1000,  #檔案名稱
          m_file       LIKE type_file.chr1000,
          l_file       LIKE type_file.chr1000,
          l_cnt        LIKE type_file.num5
   DEFINE res          LIKE type_file.num10
 
   DEFINE sr           RECORD
                ecm01    LIKE ecm_file.ecm01,
                sfb04    LIKE type_file.chr20,
                sfb08    LIKE sfb_file.sfb08, 
                sfb05    LIKE sfb_file.sfb05, 
                ima02    LIKE ima_file.ima02,    
                ima021   LIKE ima_file.ima021
                       END RECORD
   

   CALL cl_outnam('cecr002') RETURNING l_name
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL s_showmsg_init()

   CALL r002_xls_def()  #準備整份報表所需的變數

  #------------------------------------------------------#
   LET g_ss_num = "s40"
   LET g_quote = """"
   LET l_fname = 'cecr002.xls'
   LET m_file = FGL_GETENV("TEMPDIR") CLIPPED,"/",l_fname
   LET lc_channel = base.channel.create()
   CALL lc_channel.openFile(m_file,"w")
   CALL lc_channel.setDelimiter("")
   CALL r002_H_xls()  #excel 頭
  #------------------------------------------------------#

   INITIALIZE g_xls.* TO NULL
   
   LET l_sql = " SELECT DISTINCT sfb01,sfb04,sfb08,sfb05,ima02,ima021", 
               "   FROM sfb_file,ima_file,ecm_file ",
               "  WHERE sfb01=ecm01 AND ima01 = sfb05 ",               
               "    AND sfb04 < '8' ",   #狀態碼
               "    AND sfb87 <> 'X' ",   #作廢   
               "    AND ",tm.wc,
               "  ORDER BY ima021,sfb05 "
   PREPARE r002_pre FROM l_sql
   DECLARE r002_cur CURSOR FOR r002_pre


   LET l_data = 'N'
   FOREACH r002_cur INTO sr.*
    
    CASE sr.sfb04 WHEN '1' LET sr.sfb04='1:開立'
                     WHEN '2' LET sr.sfb04='2:確認'
                     WHEN '3' LET sr.sfb04='3:料表已列印'
                     WHEN '4' LET sr.sfb04='4:發料'
                     WHEN '5' LET sr.sfb04='5:WIP'
                     WHEN '7' LET sr.sfb04='7:入庫'
       END CASE


      #總WIP量=齊料套數-入庫-報廢
           
        # SELECT SUM(ecm301+ecm302+ecm303-ecm311-ecm312-ecm313-ecm314-ecm316-ecm292) 
        #   INTO l_tot_wip 
        #   FROM ecm_file 
        #  WHERE ecm01=sr.sfb01
      
      #準備EXCEL資料
      LET g_sum = 0
      INITIALIZE g_xls.* TO NULL
      
      LET g_xls.ecm01  = sr.ecm01           
      LET g_xls.sfb04  = sr.sfb04         
      LET g_xls.sfb08  = sr.sfb08         
      LET g_xls.sfb05  = sr.sfb05       
      LET g_xls.ima02  = sr.ima02    #品名         
      LET g_xls.ima021 = sr.ima021   #規格
     

      CALL r002_wipqty(sr.ecm01)

      #LET g_xls.sum = g_sum          #總計 (右方)

      #總計 (下方)
      #LET g_sum_tot.sfb08   = g_sum_tot.sfb08   + sr.sfb08    #生產數量      
        
      CALL r002_body_xls()  #excel 明細
      LET l_data = 'Y'
   END FOREACH

   CALL r002_tail_xls()  #excel 尾


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
         LET m_file = FGL_GETENV("TEMPDIR") CLIPPED,"/", 'cxcr002_'||g_today USING 'YYYYMMDD' ,".xls"
         LET l_file = 'cecr002_',g_today USING 'YYYYMMDD','.xls'
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
FUNCTION r002_xls_def()
   DEFINE l_sql        STRING
   DEFINE l_ecd01      LIKE ecd_file.ecd01
   DEFINE l_ecd02      LIKE ecd_file.ecd02

   #作業編號
   LET l_sql = "SELECT ecd01,ecd02||'('||ecd15 ",
               "  FROM ecd_file ",
               " WHERE ",
               "  EXISTS (SELECT * FROM ecm_file,sfb_file,ima_file WHERE ecm04=ecd01 AND ecm01=sfb01 ",
               "             AND sfb04 <'8' AND sfb87 <> 'X' AND ima01=sfb05 AND ",tm.wc, 
               "          )",
               " ORDER BY ecd15,ecd01 "

   PREPARE r002_h_xls_pr FROM l_sql
   DECLARE r002_h_xsl_cs CURSOR FOR r002_h_xls_pr

   LET g_i = 1
   CALL g_ecd_h.clear()
   FOREACH r002_h_xsl_cs INTO l_ecd01,l_ecd02
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
END FUNCTION

#各製程之WIP量
FUNCTION r002_wipqty(p_sfb01)
   DEFINE p_sfb01      LIKE sfb_file.sfb01
   DEFINE l_sql        STRING
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_wipqty     LIKE type_file.num15_3
   DEFINE l_subqty     LIKE type_file.num15_3
   DEFINE l_sum_wipqty LIKE type_file.num15_3
   DEFINE l_ecm        RECORD
              ecm54       LIKE ecm_file.ecm54,
              ecm291      LIKE ecm_file.ecm291,
              ecm292      LIKE ecm_file.ecm292, 
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
   LET l_sql = "SELECT ecm54,ecm291,ecm292, ",  
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
   CALL g_xls_subqty.clear()

   LET l_sum_wipqty = 0

   FOR l_i = 1 TO g_ecd_h.getlength()

      LET l_wipqty = 0
      LET l_subqty = 0
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
                         - l_ecm.ecm321    #委外加工量
                         + l_ecm.ecm322    #委外完工量
         
           LET l_subqty = l_ecm.ecm321 - l_ecm.ecm322
      END FOREACH

 #     LET l_sum_wipqty = l_sum_wipqty + l_wipqty
      ##---IF 委外在外量 > 0, 則顯示在外量 
      IF l_subqty > 0 THEN
         LET l_wipqty = l_subqty
      END IF

      LET g_xls_wipqty[g_xls_wipqty.getlength() + 1] = l_wipqty   #WIP量 (明細)
      LET g_xls_subqty[g_xls_subqty.getlength() + 1] = l_subqty   #SUB量 (明細)


   END FOR


END FUNCTION

FUNCTION r002_H_xls()  #excel 頭
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

   LET l_str = "<Worksheet ss:Name=",g_quote,"cecr002",g_quote,"> "
   CALL lc_channel.write(l_str CLIPPED)
   LET l_str = '<Table> ',
               '<Column ss:Width="66.75" ss:Span="1" /> ',
               '<Column ss:Index="3" ss:Width="93" /> ',    #料號
               '<Column ss:Width="93"/> ',                 #品名
               '<Column ss:Width="90"/> ',
               '<Column ss:Width="40.5"/> ',
               '<Column ss:AutoFitWidth="0" ss:Width="56.25"/> ',
               '<Column ss:Width="79.5"/> ',
               '<Column ss:AutoFitWidth="0" ss:Width="56.25" ss:Span="46"/> '

   CALL lc_channel.write(l_str CLIPPED)

   #跨欄至中
    LET l_MergeAcross = 0

   #---抬頭1
   LET l_str = "  <Row>",
       #        "  <Cell ss:MergeAcross=",g_quote,l_MergeAcross,g_quote," ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[14],"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>"
               

   #作業編號
   FOR  g_i = 1 TO g_ecd_h.getlength()
      LET l_str = l_str ,
              "   <Cell ss:StyleID=" , g_quote, "s68", g_quote, 
              "         ss:MergeAcross=" , g_quote, "0", g_quote, ">" ||  # 橫向合併 1 格（總共佔 2 格）
              "      <Data ss:Type=" , g_quote, "String", g_quote, ">" , g_ecd_h[g_i].ecd01 , "</Data>" ||
              "   </Cell>"
   END FOR

   ##總計
   #LET l_str = l_str ,
   #           "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[15],"</Data></Cell>"

   LET l_str = l_str , "  </Row> "
   CALL lc_channel.write(l_str CLIPPED)


   #---抬頭2
   LET l_str ="  <Row>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[1],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[2],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[3],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[4],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[5],"</Data></Cell>",
              "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[6],"</Data></Cell>"

   #作業編號說明
   FOR g_i = 1 TO g_ecd_h.getlength()
      LET l_str = l_str ,
               "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_ecd_h[g_i].ecd02,"</Data></Cell>"
             # "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">","SUB_QTY","</Data></Cell>"
   END FOR

   #總計
   #LET l_str = l_str ,
   #           "   <Cell ss:StyleID=",g_quote,"s63",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",'',"</Data></Cell>" 
   LET l_str = l_str , "  </Row> "
   CALL lc_channel.write(l_str CLIPPED)
END FUNCTION


FUNCTION r002_tail_xls()  #excel 尾
   DEFINE l_str        STRING
   DEFINE l_ss_azi03   LIKE type_file.chr10   #本國幣別取位
   DEFINE l_str_ecb48  STRING
   DEFINE l_str_tot    STRING
   DEFINE l_sum_ecb48  LIKE ecb_file.ecb48
   DEFINE l_MergeAcross   LIKE type_file.num5
   DEFINE l_xls             RECORD            #總計 (下方)
             sfb08             STRING         #生產數量
                            END RECORD

   LET l_ss_azi03 = 's40'

   INITIALIZE l_xls.* TO NULL
   LET l_xls.sfb08   = g_sum_tot.sfb08       #生產數量

   #跨欄至中
   LET l_MergeAcross = 1
    
    
   #頁尾
   LET l_str = "  <Row>",
               "  <Cell ss:MergeAcross=",g_quote,l_MergeAcross,g_quote," ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_x[15],"</Data></Cell>",
               "   <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",l_xls.sfb08  ,"</Data></Cell>"


   FOR g_i = 1 TO g_ecd_h.getlength()

      LET l_str_tot = g_sum_tot2[g_i]

      LET l_str = l_str,
                  "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",l_str_tot,"</Data></Cell>"

   END FOR

   LET l_str = l_str , "  </Row> "

   CALL lc_channel.write(l_str CLIPPED)

   LET l_str = "</Table>"
   CALL lc_channel.write(l_str)
   LET l_str = "</Worksheet>"
   CALL lc_channel.write(l_str)
   LET l_str = "</Workbook>"
   CALL lc_channel.write(l_str)
END FUNCTION


FUNCTION r002_body_xls()  #excel 明細
   DEFINE l_str        STRING
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_ss_azi03   LIKE type_file.chr10   #本國幣別取位
   DEFINE l_style      LIKE type_file.chr10


   LET l_str =
          "  <Row> ",
          "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.ecm01,"</Data></Cell>" ,
          "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote," >",g_xls.sfb04 ,"</Data></Cell>",
          "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",g_xls.sfb08,"</Data></Cell>"  ,
          "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.sfb05  ,"</Data></Cell>",     
          "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.ima02 ,"</Data></Cell>",      
          "  <Cell ss:StyleID=",g_quote,"s62",g_quote,"><Data ss:Type=",g_quote,"String",g_quote,">",g_xls.ima021 ,"</Data></Cell>"
          
   #各製程之WIP量
   FOR l_i = 1 TO g_ecd_h.getlength()
      IF g_xls_subqty[l_i] > 0 THEN 
         LET l_style="yel"
      END IF
      LET l_str = l_str,
          "  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",g_xls_wipqty[l_i],"</Data></Cell>"
         #"  <Cell ss:StyleID=",g_quote,g_ss_num,g_quote,"><Data ss:Type=",g_quote,"Number",g_quote,">",g_xls_subqty[l_i],"</Data></Cell>"
   END FOR

   LET l_str = l_str,
          "  </Row> "

   CALL lc_channel.write(l_str CLIPPED)
END FUNCTION
 
