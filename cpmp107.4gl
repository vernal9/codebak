# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cpmp107.4gl
# Descriptions...: 供應商重新核價整批產生作業
# Modify.........: 20181211 By momo 輸入日期與新核准日拆開
# Modify.........: 20190122 By momo 排除已失效核價資料
# Modify.........: NO.1904242991 20190424 By momo 核價單身筆數限制最大500筆
# Modify.........: NO.2006174784 20200617 By momo apmi255核價單單身備註一併做移轉
# Modify.........: No.2012305667 20210108 By momo QBE增加 核價日期
# Modify.........: NO.2112307402 20211230 By momo 轉出之料件增加ima41>0判斷
# Modify.........: NO.24120036   20241227 By momo QBE 增加 ima08 來源碼過瀘

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD
           wc          STRING,          
           smyslip1    LIKE pmi_file.pmi01,
           smydate     LIKE smy_file.smydate,                  
           pmj09       LIKE pmj_file.pmj09,                  
           vender_no   LIKE pmi_file.pmi03,
           discount    LIKE type_file.num15_3,
           doc_no      LIKE pmi_file.pmi03,
           item_no     LIKE pmj_file.pmj03,
           source_code LIKE ima_file.ima08,     #來源碼 20241227
           type_no     LIKE pmi_file.pmi10,
           date        STRING   #20210108
           END RECORD
DEFINE g_argv1      LIKE smy_file.smyslip  
DEFINE g_argv2      LIKE smy_file.smydate
DEFINE g_argv3      STRING
DEFINE g_argv4      LIKE type_file.chr20
DEFINE g_pmi        RECORD LIKE pmi_file.* #核價單號
DEFINE g_pmj        RECORD LIKE pmj_file.* #核價單身
DEFINE g_pmr        RECORD LIKE pmr_file.* #分量計價
DEFINE g_pmi_pmi01  LIKE pmi_file.pmi01      #記錄核價單號 
DEFINE g_pmj_pmj02  LIKE pmj_file.pmj02      #記錄核價單號 
DEFINE l_flag       LIKE type_file.chr1 
DEFINE g_msg        LIKE type_file.chr1000 
DEFINE g_wc         STRING              #CHI-F50010 add
DEFINE g_flag1      LIKE type_file.chr1 #CHI-F50010 ADD
DEFINE m_msg        STRING  #FUN-C40015
DEFINE m_msg1       STRING  #FUN-C40015
DEFINE g_cnt        LIKE type_file.num5 #計算單身筆數 20190424

#提供背景執行功能
MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP,
       FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF          
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)
   LET g_argv4 = ARG_VAL(4) 
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   WHILE TRUE
    
      LET tm.smyslip1 = g_argv1
      LET tm.smydate = g_argv2
      LET tm.pmj09 = g_argv2
      LET tm.wc = g_argv3
      LET g_bgjob = g_argv4
      LET g_flag1 = '0'  #CHI-F50010 ADD
      IF cl_null(g_bgjob) THEN
         LET g_bgjob = "N"
      END IF
#     IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   #不啟動背景執行功能
      IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN   #FUN-C40015  #不啟動背景執行功能
         CALL p107_tm()           #打開畫面檔,輸入條件
         IF cl_sure(21,21) THEN   #是否確認執行
            CALL p107_p1()        #產生入庫單
              
            #CHI-F50010-Start-ADd
            #g_flag1 = 1，表示無符合資料，不顯示成功或失敗
            IF g_flag1 = '1' THEN 
               LET l_flag = '1' 
            ELSE 
            #CHI-F50010-End-ADd   
            #最後給出成功與否的提示信息,背景執行時不給提示信息
               IF g_totsuccess = 'Y' THEN
                  CALL cl_end2(1) RETURNING l_flag
               ELSE
                  CALL cl_end2(2) RETURNING l_flag
               END IF         
            END IF #CHI-F50010 ADd      
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p107_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE   #啟動背景執行功能     
         CALL p107_p1()   #產生入庫單   

         EXIT WHILE
      END IF
   END WHILE            
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN      

FUNCTION p107_tm()     #對畫面檔進行操作
   DEFINE g_yy,g_mm       LIKE type_file.num5
   DEFINE g_t1            LIKE smy_file.smyslip 
   DEFINE g_sql           STRING 
   DEFINE p_row,p_col     LIKE type_file.num5              
   DEFINE li_result       LIKE type_file.num5
   DEFINE l_smy73         LIKE smy_file.smy73
   DEFINE l_cmd           LIKE type_file.chr1000
   DEFINE l_cnt           LIKE type_file.num5  

   LET p_row = 4 LET p_col = 10
   OPEN WINDOW p107_w AT p_row,p_col
        WITH FORM "cpm/42f/cpmp107"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   CLEAR FORM
   
   WHILE TRUE
      LET tm.wc   = '1=1' 
      IF s_shut(0) THEN RETURN END IF
      LET tm.type_no = '1'
      LET tm.discount = 1
      DISPLAY BY NAME g_bgjob
      DISPLAY tm.type_no TO type_no
      INPUT BY NAME tm.smyslip1,tm.smydate,tm.pmj09,tm.vender_no,tm.discount #20181211 add
            WITHOUT DEFAULTS 

      BEFORE INPUT
         IF cl_null(tm.smydate) THEN
            LET tm.smydate = g_today
         END IF    
         IF cl_null(tm.pmj09) THEN  #20181211
            LET tm.pmj09 = g_today
         END IF    
                                
      AFTER FIELD smyslip1
        #MOD-DB0188 mark start -----
        #IF cl_null(tm.smyslip1) THEN 
        #   NEXT FIELD smyslip1
        #END IF    
        #MOD-DB0188 mark end   -----
         IF NOT cl_null(tm.smyslip1) THEN 
            LET g_t1 = s_get_doc_no(tm.smyslip1) 
            CALL s_check_no("apm",tm.smyslip1," ","5","pmi_file","pmi01","")
              RETURNING li_result,tm.smyslip1
            DISPLAY BY NAME tm.smyslip1
               IF (NOT li_result) THEN
                  NEXT FIELD smyslip1
               END IF
            #簽核     
            SELECT smyapr INTO g_smy.smyapr FROM smy_file
             WHERE smyslip = g_t1
         END IF    

     
      AFTER FIELD smydate
         IF cl_null(tm.smydate) THEN
            LET tm.smydate = g_today
         END IF    
         #日期<=關帳日期
         IF NOT cl_null(g_sma.sma53) AND tm.smydate <= g_sma.sma53 THEN
            IF g_bgerr THEN
               CALL s_errmsg("","",tm.smydate,"mfg9999",1)
            ELSE
               CALL cl_err3("","","","","mfg9999","",tm.smydate,1)
            END IF
            NEXT FIELD smydate
         END IF
         #不可大於現行年月
         #CALL s_yp(tm.smydate) RETURNING g_yy,g_mm
         #IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN
         #   IF g_bgerr THEN
            #   CALL s_errmsg("","",tm.smydate,"mfg6091",1)
         #   ELSE
            #   CALL cl_err3("","","","","mfg6091","",tm.smydate,1)
         #   END IF
         #   NEXT FIELD smydate
         #END IF

      ##--- 20181211 add by momo 
      AFTER FIELD pmj09
        IF tm.pmj09 < tm.smydate THEN
           CALL cl_err3("","","","","mfg9999","",tm.smydate,1)
           NEXT FIELD smydate
        END IF
      
      AFTER FIELD discount
        IF tm.discount = 0 THEN
           NEXT FIELD discount
        END IF                
 
#錄入開窗部份
      ON ACTION controlp   
         CASE
            WHEN INFIELD (smyslip1)   #查詢單据
               LET g_t1 = s_get_doc_no(tm.smyslip1)   
             
                  LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"  
                  CALL smy_qry_set_par_where(g_sql)
                  CALL q_smy( FALSE, TRUE,g_t1,'APM','5') RETURNING g_t1  
            
               LET tm.smyslip1=g_t1          
               DISPLAY BY NAME tm.smyslip1
               NEXT FIELD smyslip1
                    
         END CASE 

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT INPUT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
             CALL cl_about()

         ON ACTION HELP
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()           

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_save
             CALL cl_qbe_save()  
             
      END INPUT  
     
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p107_w              
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM                     
      END IF
      LET tm.item_no = '1'
       
      DISPLAY BY NAME tm.smyslip1,tm.smydate,tm.pmj09,tm.item_no,g_bgjob  #20181211
 
      
         CONSTRUCT tm.wc ON pmi03,pmj03,ima08,pmi10,pmi02    #20241227
              FROM doc_no,item_no,source_code,type_no,date   #20210108 #20241227
         
            BEFORE CONSTRUCT
               LET tm.date = g_today-365,':',g_today         #20210108
               DISPLAY tm.type_no TO type_no
               DISPLAY tm.date TO date             #20210108
               CALL cl_qbe_init()
 
            ON ACTION controlp
               CASE
                  WHEN INFIELD (doc_no)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form  = "q_pmc03"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO doc_no
 
                  WHEN INFIELD (item_no)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form  = "q_ima"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO item_no
               END CASE
 
            ON ACTION locale
               CALL cl_show_fld_cont()
               LET g_action_choice = "locale"
               EXIT CONSTRUCT
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION exit                            #加離開功能
               LET INT_FLAG = 1
               EXIT CONSTRUCT
 
            ON ACTION qbe_select
               CALL cl_qbe_select()
 
          END CONSTRUCT
     
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW p107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF 
      
      INPUT BY NAME g_bgjob  WITHOUT DEFAULTS


         AFTER FIELD g_bgjob
            IF cl_null(g_bgjob) THEN
               LET g_bgjob = 'N'
            END IF

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT INPUT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
             CALL cl_about()

         ON ACTION HELP
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_save
             CALL cl_qbe_save()

      END INPUT

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01 = 'cpmp107'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('cpmp107','9031',1)
         ELSE 
            LET tm.wc = cl_replace_str(tm.wc,"'","\"")
            LET l_cmd = l_cmd CLIPPED,
                         " '",tm.wc       CLIPPED, "'",                         
                         " '",tm.smyslip1 CLIPPED, "'",                       
                         " '",g_bgjob  CLIPPED, "'"
            CALL cl_cmdat('cpmp107',g_time,l_cmd CLIPPED)
         END IF
         CLOSE WINDOW p107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF      
      EXIT WHILE
   END WHILE         
END FUNCTION

FUNCTION p107_p1()
  #CHI-F50010-Start-Add
   DEFINE l_sql     STRING                   
   DEFINE l_n,l_n2  LIKE type_file.num5 
  #CHI-F50010-End-Add 
   
   LET g_flag1 = '0'                        #CHI-F50010 add  
   
   IF cl_null(tm.wc) THEN 
      LET tm.wc = '1 =1'
   END IF  
     
   CALL p107_gene_price()

END FUNCTION 


FUNCTION p107_gene_price()
   DEFINE l_cnt        LIKE type_file.num5 
   DEFINE g_pmj03_t    LIKE pmj_file.pmj03
   DEFINE g_pmi03_t    LIKE pmi_file.pmi03   
   DEFINE g_pmi05_t    LIKE pmi_file.pmi05    
   DEFINE g_pmi10_t    LIKE pmi_file.pmi05    
   DEFINE g_qcs01_t    LIKE qcs_file.qcs01
   DEFINE l_flag       LIKE type_file.num5 
   DEFINE g_rvu01      LIKE rvu_file.rvu01
   DEFINE l_chr        LIKE type_file.chr1
   DEFINE l_type       LIKE type_file.chr1
   DEFINE l_g_already  LIKE type_file.chr1
   DEFINE l_sql        STRING 
   
   LET l_sql = "SELECT a.*,b.* ",
               "  FROM pmi_file a,pmj_file b, ima_file ",
               " WHERE pmi01 = pmj01 ",
               "   AND imaacti='Y' AND ima140='N' AND ima41>0 AND b.pmj03=ima01 ",   #20241227 modify
               "   AND pmiconf = 'Y' ",
               "   AND (pmj07 > 0 OR (pmi05='Y' AND pmj07=0 )) ",
               "   AND NVL(ta_pmj02,'9999/12/31') = '9999/12/31' ", #20190122 add by momo
               "   AND (pmj09) IN (SELECT DISTINCT(MAX(pmj09)) FROM pmi_file a1 ,pmj_file b1 ",
               "                 WHERE pmi01=pmj01 and pmi01=pmi01 and pmiconf='Y' ",
               "                   AND a.pmi03=a1.pmi03 AND b.pmj03=b1.pmj03 ",
               "                 GROUP BY pmj03,pmi03,pmi10) ",
              #"   AND EXISTS (SELECT ima01 FROM ima_file WHERE imaacti='Y' AND ima140='N' AND ima41>0 AND b.pmj03=ima01 )",  #20211230 add ima41 #20241227 mark
               "   AND NOT EXISTS (SELECT pmc01 FROM pmc_file WHERE pmc05 = '3' AND pmi03=pmc01 ) "

   LET l_sql = l_sql,"   AND ", tm.wc CLIPPED,
                     " ORDER BY pmi03,pmi05,pmj03,pmj09 desc"    

   PREPARE p107_cs2_pre FROM l_sql
   DECLARE p107_cs2 CURSOR WITH HOLD FOR p107_cs2_pre

   LET g_success = 'Y' 
   LET g_totsuccess = 'Y'  
   LET l_g_already = 'N'
   LET g_pmi_pmi01 = NULL 
   LET m_msg = NULL       #FUN-C40015
   LET m_msg1 = NULL      #FUN-C40015 
   CALL s_showmsg_init()    

   FOREACH p107_cs2 INTO g_pmi.*,g_pmj.*
      LET l_g_already = 'Y'
      LET l_flag = FALSE 
      IF g_success="N" THEN     #標示位 
         LET g_totsuccess="N"   #用來標示是否所有的單據都產生核價單成功
      END IF        
      
      IF NOT cl_null(tm.vender_no) THEN
         LET g_pmi.pmi03=tm.vender_no
      END IF
      IF (cl_null(g_pmi03_t) OR (g_pmi05_t<>g_pmi.pmi05)) THEN   
         BEGIN WORK 
         LET g_pmj03_t = g_pmj.pmj03
         LET g_pmi03_t = g_pmi.pmi03   
         LET g_pmi05_t = g_pmi.pmi05  
         LET g_pmi10_t = g_pmi.pmi10  
         LET l_flag = TRUE    #產生入庫單單頭資料
      END IF
      #IF g_pmj03_t = g_pmj.pmj03 THEN
      #   EXIT FOREACH
      #END IF 
      IF NOT cl_null(g_pmi03_t) AND NOT cl_null(g_pmi.pmi03)  THEN
         IF g_pmi03_t = g_pmi.pmi03 AND g_success = 'N' THEN
            CONTINUE FOREACH 
         END IF 
         IF g_pmi03_t! = g_pmi.pmi03 AND g_success = 'N' THEN  
            ROLLBACK WORK
            BEGIN WORK
            LET g_pmi03_t = g_pmi.pmi03
            LET g_pmj03_t = g_pmj.pmj03    
            LET g_pmi05_t = g_pmi.pmi05 
            LET g_pmi10_t = g_pmi.pmi10
            LET g_pmi_pmi01 = NULL
            LET l_flag = TRUE
            LET g_success = 'Y'
         END IF 
         IF g_pmi03_t! = g_pmi.pmi03 AND g_success = 'Y' THEN  #成功产生核價單
            COMMIT WORK 
                        
            BEGIN WORK
            LET g_pmi03_t = g_pmi.pmi03
            LET g_pmj03_t = g_pmj.pmj03    #FUN-C40015
            LET g_pmi05_t = g_pmi.pmi05    #FUN-C40015
            LET g_pmi10_t = g_pmi.pmi10    #FUN-C40015
            LET g_pmi_pmi01 = NULL
            LET l_flag = TRUE
         END IF 
      END IF         

            CALL p107_gene_pmi(l_flag)
 
   END FOREACH  
   IF l_g_already = 'N' THEN
      LET g_success = 'N'
      LET g_totsuccess = 'N' 
      CALL cl_err('','mfg3382',1)    #MOD-C30540
   ELSE 
      IF g_success = 'Y' THEN 
         COMMIT WORK                 
      ELSE 
         ROLLBACK WORK 
         LET g_totsuccess = 'N'        
      END IF   
   END IF
 
   CALL s_showmsg()    #顯示錯誤信息   
END FUNCTION 

FUNCTION p107_gene_pmi(p_flag)
   DEFINE  p_flag      LIKE type_file.num5
   DEFINE  l_pmi       RECORD LIKE pmi_file.*
   DEFINE  l_cnt       LIKE type_file.num5
   DEFINE  l_t1        LIKE smy_file.smyslip 
   DEFINE  li_result   LIKE type_file.num5
   
   INITIALIZE l_pmi.* TO NULL

   LET l_t1 = s_get_doc_no(tm.smyslip1)  
   IF p_flag OR g_cnt > 499 THEN    #單據編號變化  #單身資料超過500拆單 20190424
      LET g_cnt = 0                                #20190424
      CALL s_auto_assign_no("apm",l_t1,tm.smydate,"5","pmi_file","pmi01","","","") 
            RETURNING li_result,tm.smyslip1
      IF (NOT li_result) THEN 
         LET g_success='N'
         RETURN 
      END IF   
      LET g_pmi_pmi01=tm.smyslip1    #記錄產生的入庫單單號
      LET m_msg = m_msg," ",g_pmi_pmi01       #FUN-C40015
      LET l_pmi.pmi01=tm.smyslip1
      LET l_pmi.pmi02=tm.smydate
      IF NOT cl_null(tm.vender_no) THEN
         LET l_pmi.pmi03=tm.vender_no
      ELSE
         LET l_pmi.pmi03=g_pmi.pmi03
      END IF
      LET l_pmi.pmi05=g_pmi.pmi05
      LET l_pmi.pmi04='cpmp107 整批產生'
      LET l_pmi.pmi06='0'
      LET l_pmi.pmi08=g_pmi.pmi08
      LET l_pmi.pmi081=g_pmi.pmi081
      LET l_pmi.pmi09   = g_user
      LET l_pmi.pmi10=g_pmi.pmi10
      LET l_pmi.pmiconf='N' 
      LET l_pmi.pmiuser=g_user
      LET l_pmi.pmigrup=g_grup
      LET l_pmi.pmimodu=''
      LET l_pmi.pmidate=g_today
      LET l_pmi.pmiplant = g_plant 
      LET l_pmi.pmilegal = g_legal 
      LET l_pmi.pmioriu = g_user      
      LET l_pmi.pmiorig = g_grup     
      LET l_pmi.pmi07 = g_smy.smyapr
      LET l_pmi.pmiacti = 'Y'

      INSERT INTO pmi_file VALUES (l_pmi.*)
      IF SQLCA.sqlcode THEN
            CALL cl_err('ins pmi',SQLCA.sqlcode,1)
            LET g_success='N'
      END IF    
      CALL p107_ins_pmj()     
   ELSE 
      CALL p107_ins_pmj()    
   END IF    
END FUNCTION 

#給核價單單身賦值
FUNCTION p107_ins_pmj()
   DEFINE l_pmj        RECORD LIKE pmj_file.*
   DEFINE l_flag       LIKE type_file.num5
   DEFINE t_azi03      LIKE azi_file.azi03
   DEFINE l_cnt        LIKE type_file.num5 #計算INSERT筆數

   LET l_pmj.pmj01=tm.smyslip1
   SELECT MAX(pmj02)+1 INTO l_pmj.pmj02 FROM pmj_file
    WHERE pmj01 = l_pmj.pmj01 
   IF cl_null(l_pmj.pmj02) THEN 
      LET l_pmj.pmj02 = 1
   END IF    
   LET g_pmj_pmj02 = l_pmj.pmj02
   LET l_pmj.pmj03=g_pmj.pmj03
   LET l_pmj.pmj031=g_pmj.pmj031
   LET l_pmj.pmj032=g_pmj.pmj032
   LET l_pmj.pmj05=g_pmj.pmj05
   LET l_pmj.pmj06=g_pmj.pmj07
   LET l_pmj.pmj06t=g_pmj.pmj07t
   IF tm.discount = 1 THEN
      LET l_pmj.pmj07=g_pmj.pmj07
      LET l_pmj.pmj07t=g_pmj.pmj07t
   ELSE
      SELECT azi03 INTO t_azi03 FROM azi_file 
       WHERE azi01 = g_pmj.pmj05
      LET l_pmj.pmj07=g_pmj.pmj07 * tm.discount
      LET l_pmj.pmj07 = cl_digcut(l_pmj.pmj07,t_azi03)
      LET l_pmj.pmj07t = cl_digcut(l_pmj.pmj07 * (1 + g_pmi.pmi081/100),t_azi03)
   END IF
   LET l_pmj.pmj08=g_pmj.pmj09
   LET l_pmj.pmj09=tm.pmj09
   LET l_pmj.pmj10=g_pmj.pmj10
   LET l_pmj.pmj12=g_pmj.pmj12
   LET l_pmj.pmj13=g_pmj.pmj13
   LET l_pmj.pmj14=g_pmj.pmj14
   LET l_pmj.pmj15=g_pmj.pmj15
   LET l_pmj.pmj16=g_pmj.pmj16
   LET l_pmj.pmjplant = g_plant 
   LET l_pmj.pmjlegal = g_legal
   LET l_pmj.ta_pmj02 = '' #20190306 add 
   LET l_pmj.ta_pmj01=g_pmj.ta_pmj01 #20200617
   
   LET l_flag = 0
   INSERT INTO pmj_file VALUES (l_pmj.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins pmj',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN 
   ELSE
     LET g_cnt = g_cnt +1      #計算筆數 #20190424
     IF g_pmi.pmi05= 'Y' THEN
        CALL p107_ins_pmr()  
     END IF
   END IF
END FUNCTION 

#給核價單分量計價賦值
FUNCTION p107_ins_pmr()  
   DEFINE l_pmr        RECORD LIKE pmr_file.*
   DEFINE l_flag       LIKE type_file.num5
   DEFINE l_sql        STRING

   LET l_sql = "SELECT pmr_file.* ",
               "  FROM pmi_file,pmr_file,pmj_file a ",
               " WHERE pmj01=pmr01 AND pmj02=pmr02 AND ",
               "   pmi01=pmj01 AND pmi05='Y' AND pmiconf='Y' AND ",
               "   pmi03='",g_pmi.pmi03,"' AND ",
               "   pmj03='",g_pmj.pmj03,"' AND ",
               "   pmi10='",g_pmi.pmi10,"' AND ",
               "   (pmj09||pmj02) = (SELECT MAX(pmj09||pmj02) FROM pmi_file ,pmj_file a1 ",
               "                 WHERE pmi01=pmj01 and pmiconf='Y' ",
               "                   AND pmi03='",g_pmi.pmi03,"' AND pmj03='",g_pmj.pmj03,"' ",
               "                   AND pmi05='Y' ",
               "                   AND pmi10='",g_pmi.pmi10,"'  ",
               "                 GROUP BY pmj03) ",
               " ORDER BY pmr02,pmr03"    

   PREPARE p107_cs21_pre FROM l_sql
   DECLARE p107_cs21 CURSOR WITH HOLD FOR p107_cs21_pre

   LET m_msg = NULL       #FUN-C40015
   LET m_msg1 = NULL      #FUN-C40015 
   CALL s_showmsg_init()    

   FOREACH p107_cs21 INTO g_pmr.*
      LET l_pmr.pmr01=tm.smyslip1
      LET l_pmr.pmr02 = g_pmj_pmj02
      LET l_pmr.pmr03 = g_pmr.pmr03
      LET l_pmr.pmr04 = g_pmr.pmr04
      LET l_pmr.pmr05 = g_pmr.pmr05
      LET l_pmr.pmr05t = g_pmr.pmr05t
      LET l_pmr.pmrlegal = g_legal
      LET l_pmr.pmrplant = g_plant

      LET l_flag = 0
      INSERT INTO pmr_file VALUES (l_pmr.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_pmj.pmj03,SQLCA.sqlcode,1)
         LET g_success='N'
         RETURN 
      ELSE
        IF g_success = 'Y' THEN 
         COMMIT WORK                 
      ELSE 
         ROLLBACK WORK 
         LET g_totsuccess = 'N'        
      END IF
   
   END IF
 
   END FOREACH  
    
   CALL s_showmsg()    #顯示錯誤信息 


  
END FUNCTION 



