# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: csfp002.4gl
# Descriptions...: 雜發單整批工單產生作業
# Date & Author..: 2022/03/14 BY momo
# Modify.........: 22080020 20220815 By momo 開工日預設轉單日
# Modify.........: 22090008 20220913 By momo 雜發單單號+項次直接帶入asfi301裡的訂單單號序號 

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE
         g_argv1   LIKE   ina_file.ina01,  
         g_argv3   LIKE   type_file.chr1,   
         g_ima     RECORD LIKE ima_file.*,
         g_ina     RECORD LIKE ina_file.*,
         g_sfb     RECORD LIKE sfb_file.*,
         g_flag    LIKE type_file.chr1,    
         sfc_sw    LIKE type_file.chr1,    
         lot       LIKE type_file.num10,    
         lota      LIKE type_file.num15_3, 
         l_mod     LIKE type_file.num10,    
         g_cmd,g_sql,g_sql_smy  STRING,  
         g_t1      LIKE oay_file.oayslip,                     
         g_sw      LIKE type_file.chr1,    
         mm_sfb08  LIKE sfb_file.sfb08,
         l_ima60   LIKE ima_file.ima60,
         l_ima601  LIKE ima_file.ima601,    
         l_inb08   LIKE inb_file.inb08,
         l_ima55   LIKE ima_file.ima55,
         l_ima562  LIKE ima_file.ima562,
         g_ecu01   LIKE ecu_file.ecu01,   
 
         new DYNAMIC ARRAY OF RECORD
                x             LIKE type_file.chr1,    
                inb01         LIKE inb_file.inb01,    
                inb03         LIKE inb_file.inb03,
                new_part      LIKE ima_file.ima01,   
                ima02         LIKE ima_file.ima02,
                ima021        LIKE ima_file.ima021,   
                sfb93         LIKE sfb_file.sfb93,    
                sfb06         LIKE sfb_file.sfb06,    
                edc01         LIKE edc_file.edc01,    
                edc02         LIKE edc_file.edc02,    
                ima910        LIKE ima_file.ima910,   
                new_qty       LIKE sfb_file.sfb08,   
                sfb919        LIKE sfb_file.sfb919,   
                b_date        LIKE type_file.dat,     
                e_date        LIKE type_file.dat,     
                sfb02         LIKE sfb_file.sfb02,    
                new_no        LIKE ina_file.ina01,      
                ven_no        LIKE pmc_file.pmc01,    
                a             LIKE type_file.chr1,   
                costcenter    LIKE gem_file.gem01, 
                gem02c        LIKE gem_file.gem02  
                END RECORD,
         tm         RECORD
                gen02         LIKE gen_file.gen02,
                desc          LIKE pmc_file.pmc01,  
                gem01         LIKE gem_file.gem01,  
                skd01         LIKE skd_file.skd01, 
                sfb81         LIKE sfb_file.sfb81, 
                sfc01         LIKe sfc_file.sfc01, 
                bmb09         LIKE bmb_file.bmb09, 
                mac_opt       LIKE type_file.chr1  
                END RECORD
  DEFINE 
   mg
      DYNAMIC ARRAY OF RECORD
         orno  LIKE sfb_file.sfb01
      END RECORD
DEFINE l_slip LIKE sfb_file.sfb01   #00-12-26
 
DEFINE   pr_date         LIKE type_file.chr1     #20181019 add 
DEFINE   l_max_no        LIKE sfb_file.sfb01     #No.MOD-960317 add
DEFINE   l_min_no        LIKE sfb_file.sfb01     #No.MOD-960317 add
DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680121 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(72)
DEFINE   g_wc            STRING                  #FUN-920088
DEFINE   l_barcode_yn    LIKE ima_file.ima930    #DEV-D30026 add      #條碼使用否 
DEFINE   g_argv4         LIKE type_file.chr20    #FUN-D80022 add by zhuhao
#M001 171115 By TSD.Nic -----(S)
DEFINE   g_wos           STRING
DEFINE   g_pmk           RECORD LIKE pmk_file.*
DEFINE   g_t2            LIKE type_file.chr5
DEFINE   g_bookno1       LIKE aza_file.aza81
DEFINE   g_bookno2       LIKE aza_file.aza82
#M001 171115 By TSD.Nic -----(E)

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   LET g_argv1  = ARG_VAL(1)
   LET g_argv3  = ARG_VAL(2)
   IF cl_null(g_argv3) THEN
     LET g_argv3 = 'N'
   END IF
   LET g_bgjob  = ARG_VAL(3)
   LET g_argv4  = ARG_VAL(4)                      #FUN-D80022 add by zhuhao
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #No:MOD-A70028 add

   #M001 171117 By TSD.Nic -----(S)
   #p470使用
   DROP TABLE apm_p470

   CREATE TEMP TABLE apm_p470(
       ta_sfb01 LIKE sfb_file.ta_sfb01,
       sfb01    LIKE sfb_file.sfb01,
       part     LIKE sfa_file.sfa03,
       sfa26    LIKE sfa_file.sfa26,
       sfb13    LIKE sfb_file.sfb13,    #實際開工日
       req_qty  LIKE sfa_file.sfa04,
       al_qty   LIKE sfa_file.sfa04,
       pr_qty   LIKE sfa_file.sfa04,
       po_qty   LIKE sfa_file.sfa04,
       qc_qty   LIKE sfa_file.sfa04,
       wo_qty   LIKE sfa_file.sfa04)

   CREATE UNIQUE INDEX p470_t1 ON apm_p470 (ta_sfb01,sfb01,part,sfa26,sfb13)

   DELETE FROM apm_p470 WHERE 1=1
   #M001 171117 By TSD.Nic -----(E)

   IF g_bgjob = 'N' THEN
      CALL p002_tm()
   ELSE
      LET g_ina.ina01 = g_argv1 CLIPPED
      LET g_sfb.sfb81 = TODAY
      CALL p002_fill_b_data(g_grup)
      LET g_success='Y'
      LET pr_date = 'Y'    
      CALL csfp002()
      
      IF g_success='Y' THEN
         MESSAGE "Success!"
      END IF
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No:MOD-A70028 add
END MAIN
 
FUNCTION p002_tm()
   DEFINE   p_row,p_col,i    LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   mm_qty,mm_qty1   LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_cnt,s_date     LIKE type_file.num5    #No.FUN-680121 SMALLINT  
   DEFINE   l_time           LIKE ima_file.ima58    #No.FUN-680121 DEC(15,3)
   DEFINE   l_sfb08          LIKE sfb_file.sfb08
   DEFINE   l_flag           LIKE type_file.chr1                  #No.FUN-680121 VARCHAR(1)
   DEFINE   l_cn             LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima55_fac      LIKE ima_file.ima55_fac
   DEFINE   l_check          LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima59          LIKE ima_file.ima59
   DEFINE   l_ima61          LIKE ima_file.ima61
   DEFINE   l_ina00          LIKE ina_file.ina00   
   DEFINE   l_costcenter     LIKE gem_file.gem01   #FUN-670103
   DEFINE   l_gem02c         LIKE gem_file.gem02   #FUN-670103
   #M001 171116 By TSD.Nic -----(S)
   DEFINE   l_slip           LIKE smy_file.smyslip
   DEFINE   l_pmk02          LIKE pmk_file.pmk02
   DEFINE   li_result        LIKE type_file.num5
   #M001 171116 By TSD.Nic -----(E)
 
   IF s_shut(0) THEN
      RETURN
   END IF
   LET p_row = 2 
   LET p_col = 4 
 
   
     OPEN WINDOW p304_w AT p_row,p_col
        WITH FORM "csf/42f/csfp002"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 

    
   CALL cl_ui_init()    
 
   CALL cl_set_comp_visible("ima910",g_sma.sma118='Y')
   IF g_aaz.aaz90='Y' THEN
      CALL cl_set_comp_required("gem01",TRUE)
   END IF
   CALL cl_set_comp_visible("costcenter,gem02c",g_aaz.aaz90='Y')
   CALL cl_set_comp_visible("sfb919,gb3",g_sma.sma1421='Y')  #FUN-A80102
   CALL cl_set_comp_visible("edc01,edc02",g_sma.sma541='Y')  #FUN-A80054
 
   CALL cl_opmsg('z')
 
   WHILE TRUE  #MOD-490189
 
   MESSAGE ''
   CLEAR FORM 
   INITIALIZE g_ina.* TO NULL
   INITIALIZE tm.*    TO NULL
   #M001 171116 By TSD.Nic -----(S)
   INITIALIZE g_pmk.* TO NULL
   CALL p002_pmk_default()
   #M001 171116 By TSD.Nic -----(E)
   LET mm_qty=0   
   LET mm_qty1=0   
   LET sfc_sw='Y'
   LET lot=1   
   LET g_sw='N' 
   LET g_sfb.sfb81 = TODAY
   LET pr_date = 'Y'        #20220307
   LET l_ima59=0
   LET l_ima60=0
   LET l_ima61=0
   LET tm.gem01=g_grup    #FUN-670103
   LET l_gem02c = ''                                              #FUN-920088
   SELECT gem02 INTO l_gem02c FROM gem_file WHERE gem01=tm.gem01  #FUN-920088
      AND gemacti='Y'                                             #FUN-920088
#FUN-D80022 ---------- add ---------- begin ------------ by zhuhao
            
         IF tm.mac_opt IS NULL THEN LET tm.mac_opt='N' END IF 
         DISPLAY BY NAME g_sfb.sfb81,tm.gem01 
         DISPLAY BY NAME tm.mac_opt  
         DISPLAY l_gem02c TO gem02   
    
         INPUT BY NAME g_sfb.sfb81,tm.gem01,tm.mac_opt WITHOUT DEFAULTS  
    
           AFTER FIELD gem01
               IF NOT cl_null(tm.gem01) THEN
                  IF g_aaz.aaz90='Y' THEN
                     IF NOT s_costcenter_chk(tm.gem01) THEN
                        LET tm.gem01=NULL
                        DISPLAY BY NAME tm.gem01
                        DISPLAY NULL TO FORMONLY.gem02
                        NEXT FIELD gem01
                     ELSE
                        DISPLAY s_costcenter_desc(tm.gem01) TO FORMONLY.gem02
                     END IF               
                  ELSE
                     LET l_gem02c = ''
                     SELECT gem02 INTO l_gem02c FROM gem_file WHERE gem01=tm.gem01
                        AND gemacti='Y'
                     IF STATUS THEN
                        CALL cl_err3("sel","gem_file",tm.gem01,"",STATUS,"","select gem",1)
                        NEXT FIELD gem01 
                     END IF
                     DISPLAY l_gem02c TO gem02
                  END IF
               END IF
           #TQC-C80187----add----begin
           AFTER INPUT
                 IF INT_FLAG THEN
                    EXIT INPUT
                 END IF
                 IF NOT cl_null(tm.gem01) THEN
                    SELECT gem02 INTO l_gem02c FROM gem_file WHERE gem01=tm.gem01
                        AND gemacti='Y'
                     IF STATUS THEN
                        CALL cl_err3("sel","gem_file",tm.gem01,"",STATUS,"","select gem",1)
                        NEXT FIELD gem01
                     END IF   
                 END IF  
           #TQC-C80187----add----end    
               ON ACTION CONTROLP
                  CASE
                     WHEN INFIELD(gem01)
                         CALL cl_init_qry_var()
                         IF g_aaz.aaz90='Y' THEN
                            LET g_qryparam.form ="q_gem4"
                         ELSE
                            LET g_qryparam.form ="q_gem"
                         END IF
                         LET g_qryparam.default1 = tm.gem01
                         CALL cl_create_qry() RETURNING tm.gem01
                         DISPLAY BY NAME tm.gem01
                         NEXT FIELD gem01
                     OTHERWISE EXIT CASE
                 END CASE
    
            ON ACTION locale
               CALL cl_dynamic_locale()
               CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
   
   #TQC-A50129 --begin--         
            ON ACTION controlg
               CALL cl_cmdask()   
   #TQC-A50129 --end--  
         
         END INPUT
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         CONSTRUCT BY NAME g_wc ON ina01,ina03,ina11,ina04

    
            BEFORE CONSTRUCT 
                CALL cl_qbe_init()
         DISPLAY g_argv1 TO ina01 
       
            ON ACTION CONTROLP
               CASE
                 WHEN INFIELD(ina01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="cq_ina01" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret 
                    DISPLAY g_qryparam.multiret TO ina01
                    NEXT FIELD ina01
                 WHEN INFIELD(ina11)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gen" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret 
                    DISPLAY g_qryparam.multiret TO ina11
                    NEXT FIELD ina11
                 WHEN INFIELD(ina04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c" 
                    LET g_qryparam.form ="q_gem" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                          
                    DISPLAY g_qryparam.multiret TO ina04                                                                     
                    NEXT FIELD ina04
               END CASE
             ON ACTION exit                                                                                                            
                LET INT_FLAG = 1                                                                                                       
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
    
             ON ACTION qbe_select
                CALL cl_qbe_select()
    
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('inauser', 'inagrup') 
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
        
         DISPLAY 'Y' TO pr_date 
         INPUT BY NAME g_pmk.pmk01,g_pmk.pmk04,g_pmk.pmk02,pr_date WITHOUT DEFAULTS 

            ##---- 20180410 預設請購單別(S)
            BEFORE FIELD pmk01
              SELECT rye03 INTO g_pmk.pmk01 FROM rye_file
               WHERE rye01 = 'apm' AND ryeacti = 'Y' and rye02='1' AND ta_rye01='asfp304'
            DISPLAY BY NAME g_pmk.pmk01
            ##---- 20180410 預設請購單別(E)

            AFTER FIELD pmk01
               IF NOT cl_null(g_pmk.pmk01) THEN
                  LET g_t2=s_get_doc_no(g_pmk.pmk01)
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM  rye_file WHERE rye04 = g_t2 AND ryeacti = 'Y' AND rye01 = 'apm'
                  IF l_cnt > 0 THEN
                     CALL cl_err(g_t2,'apc1036',0)
                     NEXT FIELD pmk01
                  END IF

                  CALL s_check_no("apm",g_pmk.pmk01,"","1","pmk_file","pmk01","") RETURNING li_result,g_pmk.pmk01
                  DISPLAY BY NAME g_pmk.pmk01
                  IF (NOT li_result) THEN
                     NEXT FIELD pmk01
                  END IF

                  LET l_pmk02 = ''
                  SELECT smy72,smyapr,smysign
                    INTO l_pmk02,g_pmk.pmkmksg,g_pmk.pmksign
                    FROM smy_file
                   WHERE smyslip = g_t2
                  IF NOT cl_null(l_pmk02) THEN
                     LET g_pmk.pmk02 = l_pmk02
                     DISPLAY BY NAME g_pmk.pmk02
                  END IF
             
                  LET g_pmk.pmkprsw = 'Y'
               END IF

            AFTER FIELD pmk04       #請購日期(預設會計年度/期間)
               IF NOT cl_null(g_pmk.pmk04) THEN
                  IF NOT cl_null(g_sma.sma53) AND g_pmk.pmk04 <= g_sma.sma53 THEN
                    CALL cl_err('','mfg9999',0)
                    NEXT FIELD pmk04
                  END IF
                  SELECT azn02,azn04 INTO g_pmk.pmk31,g_pmk.pmk32 FROM azn_file
                   WHERE azn01 = g_pmk.pmk04
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("sel","azn_file",g_pmk.pmk04,"","mfg0027","","",1)
                     LET g_pmk.pmk04 = ''
                     DISPLAY BY NAME g_pmk.pmk04
                     NEXT FIELD pmk04
                  END IF
                  CALL s_get_bookno(YEAR(g_pmk.pmk04))
                       RETURNING g_flag,g_bookno1,g_bookno2
                  IF g_flag =  '1' THEN  #抓不到帳別
                     CALL cl_err(g_pmk.pmk04,'aoo-081',1)
                     NEXT FIELD pmk04
                  END IF
                  IF g_aza.aza17 != g_pmk.pmk22 THEN
                     CALL s_curr3(g_pmk.pmk22,g_pmk.pmk04,g_sma.sma904)
                        RETURNING g_pmk.pmk42
                  END IF
                  DISPLAY 'N' TO pr_date
               END IF

            AFTER INPUT
               IF INT_FLAG THEN
                  EXIT INPUT
               END IF
               LET g_pmk.pmkuser = s_get_data_owner("pmk_file")
               LET g_pmk.pmkgrup = s_get_data_group("pmk_file")

            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(pmk01) #單據編號
                     LET g_t2=s_get_doc_no(g_pmk.pmk01)
                     CALL q_smy(FALSE,FALSE,g_t2,'APM','1') RETURNING g_t2
                     LET g_pmk.pmk01 = g_t2
                     DISPLAY BY NAME g_pmk.pmk01
                     NEXT FIELD pmk01
                  OTHERWISE
                     EXIT CASE
              END CASE
    
            ON ACTION locale
               CALL cl_dynamic_locale()
               CALL cl_show_fld_cont()
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
            ON ACTION controlg
               CALL cl_cmdask()   
         END INPUT
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
   
      
      #將塞單身這段整個搬出成一個FUNCTION
      CALL p002_fill_b_data(tm.gem01)
            
      LET g_success='Y'
      LET g_flag='Y'
      CALL csfp002()
         CALL cl_confirm('lib-005') RETURNING l_flag
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      ERROR ""
   END WHILE
 
   CLOSE WINDOW p304_w
 
END FUNCTION
 
FUNCTION p002_fill_b_data(p_gem01)
   DEFINE   p_gem01          LIKE gem_file.gem01
   DEFINE   l_cnt,s_date     LIKE type_file.num5    
   DEFINE   l_time           LIKE ima_file.ima58    
   DEFINE   l_sfb08          LIKE sfb_file.sfb08
   DEFINE   l_sfb09          LIKE sfb_file.sfb09    
   DEFINE   l_flag           LIKE type_file.chr1                  
   DEFINE   l_cn             LIKE type_file.num5    
   DEFINE   l_ima55_fac      LIKE ima_file.ima55_fac
   DEFINE   l_check          LIKE type_file.num5    
   DEFINE   l_ima59          LIKE ima_file.ima59
   DEFINE   l_ima61          LIKE ima_file.ima61
   DEFINE   l_costcenter     LIKE gem_file.gem01    
   DEFINE   l_gem02c         LIKE gem_file.gem02    
   DEFINE   li_result        LIKE type_file.num5    
   DEFINE   l_ina00          LIKE ina_file.ina00    
   DEFINE   l_smy57          LIKE smy_file.smy57    
   DEFINE   l_sql            STRING                 
   DEFINE   l_tmp            STRING                 
   DEFINE   l_snum,l_enum    STRING                 
   DEFINE   l_ssn,l_esn      LIKE type_file.num20   
   DEFINE   l_ima54          LIKE ima_file.ima54    
   DEFINE   l_ima08          LIKE ima_file.ima08    
   DEFINE   tok1             base.StringTokenizer   
   DEFINE   l_token_cnt      LIKE type_file.num10   
   DEFINE   l_sfb919         LIKE sfb_file.sfb919   
   #CHI-B80044 -- begin --
   DEFINE   l_availqty       LIKE sfb_file.sfb08   #訂單可轉工單數量
   DEFINE   l_calc           LIKE type_file.num5   #計算生產批量倍數用
   DEFINE   l_allowqty       LIKE sfb_file.sfb08   #允許生產數量
   #CHI-B80044
  #DEFINE   l_str            STRING                #MOD-D80184 add #CHI-D90021 mark
   DEFINE   l_msg            LIKE type_file.chr100                 #CHI-D90021 add
   DEFINE   l_fld01          LIKE gaq_file.gaq03                   #CHI-D90021 add
   DEFINE   l_fld02          LIKE gaq_file.gaq03                   #CHI-D90021 add
   DEFINE   l_fld03          LIKE gaq_file.gaq03                   #CHI-D90021 add
   DEFINE   l_qty            LIKE sfb_file.sfb08                   #CHI-DA0027 add
   DEFINE   l_ima56          LIKE ima_file.ima56                   #CHI-DA0027 add
   DEFINE   l_smy72          LIKE smy_file.smy72                   #MOD-G60089 add
   DEFINE   l_bma05          LIKE bma_file.bma05                   #20190905 add
   #M001 180109 By TSD.Jin--start--
   DEFINE   l_ima            RECORD
               oeb_q         LIKE type_file.num15_3,
               sfa_q1        LIKE type_file.num15_3,
               sfa_q2        LIKE type_file.num15_3,
               misc_q1       LIKE type_file.num15_3,
               sfs_q2        LIKE type_file.num15_3,
               sie_q         LIKE type_file.num15_3,
               pml_q         LIKE type_file.num15_3,
               pmn_q         LIKE type_file.num15_3,
               rvb_q2        LIKE type_file.num15_3,
               rvb_q         LIKE type_file.num15_3,
               sfb_q1        LIKE type_file.num15_3,
               sfb_q2        LIKE type_file.num15_3,
               qcf_q         LIKE type_file.num15_3,
               atp_qty       LIKE type_file.num15_3
                             END RECORD
   #M001 180109 By TSD.Jin--end----
   
      CALL new.clear()
      LET l_costcenter=s_costcenter(p_gem01) #FUN-670103
      LET l_gem02c=s_costcenter_desc(l_costcenter) #FUN-670103
      IF cl_null(g_wc) THEN
         LET g_wc= 'inb01=',"'",g_argv1,"'"
      END IF
      
   
      LET g_sql = "SELECT 'Y',inb01,inb03,inb04,ima02,ima021,'N','','','',ima910,inb16,'',NULL,inaud13, ",  
                  " '1',ima111,' ','Y','','',inb08,ima55,((100+ima562)/100),ima60,ima601 ",   
                  " ,ima54,ima08 ",       
                  " FROM inb_file,ima_file,ina_file ",            
                  " WHERE ", g_wc CLIPPED, 
                  "  AND inb16>0 ",   
                  "  AND inb04 = ima01 ",
                  "  AND inb01 = ina01 ",       
                  "  AND EXISTS (SELECT * FROM bma_file WHERE bma01=inb04 AND bma10='2')",  
                  "  AND ima08<>'P' ",   
                  "  AND ima911<>'Y' "  
 
  
      PREPARE q_inb_prepare FROM g_sql
      DECLARE inb_curs CURSOR FOR q_inb_prepare
      LET g_i=1
      CALL s_showmsg_init() 
       FOREACH inb_curs INTO new[g_i].*,l_inb08,l_ima55,l_ima562,l_ima60,l_ima601,l_ima54,l_ima08 
         IF g_sma.sma541 = 'N' THEN
            IF NOT cl_null(new[g_i].edc01) THEN
               LET new[g_i].edc01=''
            END IF
            IF NOT cl_null(new[g_i].edc02) THEN
               LET new[g_i].edc02=''
            END IF
         END IF
         IF STATUS THEN
            EXIT FOREACH
         END IF
         SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = new[g_i].new_part
      
        CALL cl_get_feldname('inb01',g_lang) RETURNING l_fld01
        CALL cl_get_feldname('inb03',g_lang) RETURNING l_fld02
        CALL cl_get_feldname('inb04',g_lang) RETURNING l_fld03
        LET l_msg = l_fld01 CLIPPED,':',new[g_i].inb01 CLIPPED,' ',l_fld02 CLIPPED,':',new[g_i].inb03
                  ,' ',l_fld03 CLIPPED,':',new[g_i].new_part
       
        IF g_ima.ima140 = 'Y' AND g_ima.ima1401 <= g_today THEN  
           CALL s_errmsg('',l_msg,'','asf-960',1)    
           CONTINUE FOREACH
        END IF 
        
         IF g_sma.sma54 = 'Y' THEN
            IF NOT cl_null(new[g_i].new_no) THEN
               SELECT smy57 INTO l_smy57 FROM smy_file
                WHERE smyslip = new[g_i].new_no
               LET new[g_i].sfb93 = l_smy57[1,1]
            END IF
         END IF
         IF new[g_i].sfb93 = 'Y' THEN
           
            SELECT ima94 INTO new[g_i].sfb06 FROM ima_file 
             WHERE ima01 = new[g_i].new_part  
             IF cl_null(new[g_i].sfb06) THEN
                DECLARE ecu02_c CURSOR FOR 
                   SELECT ecu02 FROM ecu_file
                    WHERE ecu01 = new[g_i].new_part
                      AND ecu10='Y' AND ecuacti = 'Y'
                      AND ecuacti = 'Y'  
                FOREACH ecu02_c INTO new[g_i].sfb06
                   EXIT FOREACH
                END FOREACH
             END IF
         END IF
         
         IF NOT cl_null(new[g_i].edc01) THEN
            LET new[g_i].edc02=''
            SELECT MIN(edb02) INTO new[g_i].edc02 FROM eda_file,edb_file
             WHERE edb03=new[g_i].new_part
               AND edb01=new[g_i].edc01
               AND edb04=new[g_i].sfb06
               AND edb01=eda01 AND edaconf='Y'
         END IF

         LET l_sfb08 = 0
       IF s_industry('std') THEN
          LET g_ina.ina01 = new[g_i].inb01
        LET l_ina00 = NULL
        SELECT ina00 INTO l_ina00 FROM ina_file
         WHERE ina01 = g_ina.ina01
        IF l_ina00 <> '1' THEN
           CALL s_errmsg('ina00',g_ina.ina01,'sel ina00','aba-189',1)
           CONTINUE FOREACH
        END IF
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM ina_file
         WHERE ina01 = g_ina.ina01
           AND inaconf = 'Y'
        IF l_cnt <=0 THEN 
           CONTINUE FOREACH
        ELSE
           
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt  
             FROM inb_file,sic_file
            WHERE inb01 = g_ina.ina01
              AND inb16 <= sic06
              AND inb01=sic03 AND inb03=sic05
           IF l_cnt >0 THEN   
              CALL s_errmsg('',g_ina.ina01,'','asf-962',1)
              CONTINUE FOREACH
           END IF
        END IF
       END IF
        
            SELECT smy72 INTO l_smy72 FROM smy_file 
             WHERE smyslip = new[g_i].new_no    
            IF l_smy72 = '7' THEN
               LET new[g_i].sfb02 = '7'
            ELSE
               LET new[g_i].sfb02 = '1'
               IF s_industry('std') THEN
                  LET new[g_i].ven_no = tm.gem01
               END IF
            END IF     
         
         CALL s_umfchk(new[g_i].new_part,l_inb08,l_ima55)
                            RETURNING l_check,l_ima55_fac
         IF cl_null(l_ima55_fac) THEN 
            LET l_ima55_fac = 1
         END IF
         LET new[g_i].new_qty = new[g_i].new_qty * l_ima55_fac * l_ima562   
         
            SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
             WHERE sfb91  =  g_ina.ina01
               AND sfb92 =  new[g_i].inb03              
               AND sfb04 <> '8'                                                    
               AND sfb87!='X'

            SELECT SUM(sfb09) INTO l_sfb09 FROM sfb_file
             WHERE sfb91  =  g_ina.ina01
               AND sfb92 =  new[g_i].inb03 
               AND sfb04  = '8'   
               AND sfb87 != 'X'


         IF l_sfb08 IS NULL THEN
            LET l_sfb08 = 0
         END IF
        
         IF l_sfb09 IS NULL THEN
            LET l_sfb09 = 0
         END IF
         
         IF l_sfb08 + l_sfb09 >= new[g_i].new_qty THEN                 
            CONTINUE FOREACH
         ELSE
            LET new[g_i].new_qty = new[g_i].new_qty - l_sfb08-l_sfb09  

            CALL cs_q102_qty(new[g_i].new_part)
               RETURNING l_ima.oeb_q, l_ima.sfa_q1, l_ima.sfa_q2, l_ima.sie_q, l_ima.pml_q,
                         l_ima.pmn_q, l_ima.rvb_q2, l_ima.rvb_q, l_ima.sfb_q1, l_ima.sfb_q2,
                         l_ima.qcf_q, l_ima.atp_qty,l_ima.misc_q1,l_ima.sfs_q2
            LET l_ima.atp_qty = l_ima.atp_qty + new[g_i].new_qty     #受訂量包含自己這張訂單，故需要加回來

            IF l_ima.atp_qty > 0 THEN
               IF new[g_i].new_qty >= l_ima.atp_qty THEN
                  LET new[g_i].new_qty = new[g_i].new_qty - l_ima.atp_qty
               ELSE
                  LET new[g_i].new_qty = 0
               END IF
            END IF

            LET l_allowqty = new[g_i].new_qty   
            IF NOT cl_null(g_ima.ima56) AND g_ima.ima56 > 0 THEN
               LET l_calc = 0
               LET l_qty = new[g_i].new_qty * 1000         
               LET l_ima56 = g_ima.ima56 * 1000             
               IF l_qty MOD l_ima56 > 0 THEN                
                  LET l_calc = new[g_i].new_qty/g_ima.ima56 +1
                  LET l_allowqty = l_calc * g_ima.ima56
               END IF
            END IF
            LET new[g_i].new_qty = l_allowqty
            LET new[g_i].new_qty = s_digqty(new[g_i].new_qty,l_ima55)  
         END IF
##-計算開工日
         LET g_ima.ima62 = 0
          SELECT ima62,ima59,ima61 INTO g_ima.ima62,l_ima59,l_ima61 FROM ima_file 
          WHERE ima01 = new[g_i].new_part
         IF new[g_i].e_date IS NULL THEN
            LET new[g_i].e_date = 0
         END IF
      ##---- 20180417 add by momo (S)
          SELECT bma05||ima02 INTO new[g_i].ima02 
            FROM bma_file,ima_file
           WHERE ima01=bma01 AND bmaacti = 'Y'
             AND bma01=new[g_i].new_part
             AND bma05 IS NOT NULL
      ##---- 20180417 add by momo (E)
          LET l_time= (new[g_i].new_qty * l_ima60/l_ima601)+ l_ima59 + l_ima61 
 
         IF cl_null(l_time) THEN
            LET l_time=0
         END IF
         LET s_date=l_time+0.5
         IF cl_null(s_date) THEN
            LET s_date=0 
         END IF

         #CALL s_aday(new[g_i].e_date,-1,s_date) RETURNING new[g_i].b_date  #20220815 
         LET new[g_i].b_date = g_today                                      #20220815
 
         IF new[g_i].b_date < g_sfb.sfb81 THEN
            LET new[g_i].b_date = g_sfb.sfb81
         END IF
         IF new[g_i].b_date > new[g_i].e_date THEN 
            LET new[g_i].e_date = new[g_i].b_date
         END IF
         
         LET new[g_i].gem02c=l_gem02c 
         LET g_i=g_i+1
      END FOREACH
      CALL s_showmsg()    
      CALL new.deleteElement(g_i)  
      LET g_i=g_i-1
END FUNCTION

#TQC-AC0238   --start  
FUNCTION i304_new_no(i)             
   DEFINE i         LIKE type_file.num5
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_smy73   LIKE smy_file.smy73    
   DEFINe l_cnt     LIKE type_file.num5    
 
   LET g_errno = ' '
   IF cl_null(new[i].new_no) THEN RETURN END IF
   LET l_slip = s_get_doc_no(new[i].new_no)
 
  #DEV-D30026 add str---------------------
   IF l_barcode_yn = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt
      FROM smy_file,smyb_file
      WHERE smy_file.smyslip = smyb_file.smybslip AND
            smy_file.smysys = 'asf' AND
            smy_file.smykind = '1' AND
            smy_file.smyslip = l_slip
      IF l_cnt = 0 THEN
         CALL cl_err('','aba-134',1)
      END IF
   ELSE
      SELECT smy73 INTO l_smy73 FROM smy_file                 
       WHERE smyslip = l_slip
      IF l_smy73 = 'Y' THEN
         LET g_errno = 'asf-875'
      END IF 
   END IF        
END FUNCTION
 
FUNCTION csfp002()
   DEFINE l_za05        LIKE type_file.chr1000 
   DEFINE l_sfb         RECORD LIKE sfb_file.*
   DEFINE l_sfc         RECORD LIKE sfc_file.*
   DEFINE l_sfd         RECORD LIKE sfd_file.*
   DEFINE l_minopseq    LIKE ecb_file.ecb03 
   DEFINE new_part      LIKE ima_file.ima01    
   DEFINE i,j           LIKE type_file.num10   
   DEFINE ask           LIKE type_file.num5    
   DEFINE s_date        LIKE type_file.num5    
   DEFINE l_time        LIKE ima_file.ima58    
   DEFINE l_item        LIKE ima_file.ima01
   DEFINE l_smy57       LIKE smy_file.smy57
   DEFINE l_smy73       LIKE smy_file.smy73    
   DEFINE l_ima910      LIKE ima_file.ima910   
   DEFINE   li_result   LIKE type_file.num5          
   DEFINE   l_max_no    LIKE sfb_file.sfb01         
   DEFINE   l_min_no    LIKE sfb_file.sfb01        
   DEFINE l_sfb08       LIKE sfb_file.sfb08
   DEFINE l_sfb09       LIKE sfb_file.sfb09     
   DEFINE l_qty         LIKE oeb_file.oeb12
   DEFINE l_ima55_fac   LIKE ima_file.ima55_fac
   DEFINE l_check       LIKE type_file.num5     
   DEFINE l_cn          LIKE type_file.num5     
   DEFINE l_ima59       LIKE ima_file.ima59
   DEFINE l_ima61       LIKE ima_file.ima61
   DEFINE l_btflg       LIKE type_file.chr1     
   DEFINE l_proc        LIKE type_file.chr1     
   DEFINE l_sfbi        RECORD LIKE sfbi_file.* 
   DEFINE l_sfbc        RECORD LIKE sfbc_file.* 
   DEFINE l_formid      LIKE oay_file.oayslip   
   DEFINE l_ima571      LIKE ima_file.ima571    
   DEFINE l_cnt         LIKE type_file.num5     
   DEFINE l_sfc01       LIKE sfc_file.sfc01     
   DEFINE l_t1          LIKE oay_file.oayslip   
   DEFINE l_sfci        RECORD LIKE sfci_file.* 
   DEFINE l_flag        LIKE type_file.chr1     
   DEFINE l_new_no1     STRING                  
   DEFINE l_new_no      LIKE smy_file.smyslip   
   DEFINE l_sfd01       LIKE sfd_file.sfd01     
   DEFINE l_ima56       LIKE ima_file.ima56     
   DEFINE l_ima561      LIKE ima_file.ima561    
   DEFINE l_qty1        LIKE sfb_file.sfb08     
   DEFINE l_qty2        LIKE ima_file.ima56     
   DEFINE l_availqty        LIKE sfb_file.sfb08   #訂單可轉工單數量
   DEFINE l_allowqty        LIKE sfb_file.sfb08   #允許生產數量
   DEFINE l_calc            LIKE type_file.num5   #計算生產批量倍數用
   DEFINE l_i           LIKE type_file.num5   #FUN-C50052
   DEFINE l_count       LIKE type_file.num5   #FUN-D80022
   DEFINE l_sfb01       LIKE sfb_file.sfb01   #FUN-D80022
   DEFINE l_smy72       LIKE smy_file.smy72       #MOD-FB0042 add
   DEFINE l_pmk40       LIKE pmk_file.pmk40
   DEFINE l_ima43       LIKE ima_file.ima43
   DEFINE l_ori_pmk     LIKE pmk_file.pmk01
   DEFINE l_pass_pmk    STRING
   DEFINE l_sql         STRING
   DEFINE l_wos         STRING
   DEFINE l_tot_cnt     LIKE type_file.num5
   #M012 180129 By TSD.Nic -----(E)

  
   WHILE TRUE
       LET g_flag='Y' #MOD-530283
   LET l_ima59=0
   LET l_ima60=0
   LET l_ima61=0
   #TQC-730022 如果是背景作業不再INPUT ARRAY

  #FUN-B30035--begin--add-----
   IF g_sma.sma541 = 'Y' THEN
      DROP TABLE sfd_tmp
      CREATE TEMP TABLE sfd_tmp(
        sfd01   LIKE sfc_file.sfc01)
      CREATE UNIQUE INDEX sfd_tmp_01 on sfd_tmp(sfd01);
   END IF
  #FUN-B30035--end--add-------


    IF g_bgjob = 'N' THEN 
      INPUT ARRAY new WITHOUT DEFAULTS FROM s_new.*
         ATTRIBUTE(COUNT=g_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE, APPEND ROW=FALSE)
 
         BEFORE INPUT                                            
            CALL cl_set_comp_required("b_date,e_date",TRUE)      

         BEFORE ROW       
            LET i=ARR_CURR()
            LET g_ina.ina01 = new[i].inb01 
            IF cl_null(new[i].sfb93) THEN LET new[i].sfb93='N' END IF
            IF new[i].sfb93 = 'N' THEN LET new[i].sfb06='' END IF  
            
            CALL p002_set_entry_b()
            CALL p002_set_no_entry_b(i)
            CALL p002_set_no_required_b()
            CALL p002_set_required_b(i)
                           
            
         BEFORE INSERT
            LET new[i].sfb02='1'
            DISPLAY BY NAME new[i].sfb02
            IF cl_null(new[i].sfb93) THEN
               LET new[i].sfb93 = 'N'
               DISPLAY BY NAME new[i].sfb93
            END IF
               
         ON CHANGE x
            CALL p002_set_entry_b()
            CALL p002_set_no_entry_b(i)
            CALL p002_set_no_required_b()
            CALL p002_set_required_b(i)
            
         AFTER FIELD x
            IF NOT cl_null(new_part) THEN
             IF new[i].x IS NULL OR (new[i].x != 'Y' AND new[i].x != 'N') THEN
               NEXT FIELD x
             END IF
            END IF
            IF new[i].x = 'Y' AND NOT cl_null(new[i].new_no[g_no_sp,g_no_sp]) THEN      
                     CALL cl_err('','asf-371','1')                                                                                 
            END IF
            
          AFTER FIELD ima910                                                                                                        
             IF NOT cl_null(new[i].ima910) THEN                                                                                     
              SELECT COUNT(*) INTO g_cnt FROM bma_file                                                                              
               WHERE bma06 = new[i].ima910                                                                                          
                 AND bma01 = new[i].new_part                                                                                        
                 AND bma05 IS NOT NULL AND bma05 <= g_sfb.sfb81                                                                     
              IF g_cnt = 0 THEN                                                                                                     
                 CALL cl_err(new[i].ima910,"abm-618",0)                                                                             
                 NEXT FIELD ima910                                                                                                  
              END IF                                                                                                                
           END IF                                                                                                                   

         ON CHANGE sfb93
            CALL p002_set_entry_b()
            CALL p002_set_no_entry_b(i)
            CALL p002_set_no_required_b()
            CALL p002_set_required_b(i)              
            
         AFTER FIELD sfb93
             LET g_ecu01 = ''    
             IF NOT cl_null(new[i].sfb93) THEN

                IF new[i].sfb93 <> 'Y' THEN
                   LET new[i].sfb06 = ''
                   DISPLAY BY NAME new[i].sfb06
                END IF   
             END IF
             
         AFTER FIELD sfb06
             IF NOT cl_null(new[i].sfb06) THEN
                SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01=new[i].new_part
                IF cl_null(l_ima571) THEN LET l_ima571=' ' END IF
                LET l_cnt = 0
                SELECT count(*) INTO l_cnt FROM ecu_file
                 WHERE (ecu01=l_ima571 OR ecu01=new[i].new_part)
                   AND ecu02 = new[i].sfb06
                   AND ecuacti = 'Y'  
                IF l_cnt = 0 THEN
                   CALL cl_err('','mfg4030',1)
                   NEXT FIELD sfb06
                END IF
                CALL p002_chk_edb(new[i].edc01,new[i].new_part,new[i].sfb06)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('','aec-065',1)
                   NEXT FIELD sfb06
                END IF
                 CALL p002_edc02(new[i].edc01,new[i].edc02,new[i].new_part,new[i].sfb06)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(new[i].edc02,'aec-065',0)
                    NEXT FIELD sfb06
                 END IF
             END IF
                
        AFTER FIELD edc01
           IF NOT cl_null(new[i].edc01) THEN
           
              CALL p002_chk_edb(new[i].edc01,new[i].new_part,new[i].sfb06)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD edc01
              END IF
              IF cl_null(new[i].edc02) THEN
                SELECT MIN(edb02) INTO new[i].edc02 FROM eda_file,edb_file
                 WHERE edb03=new[i].new_part
                   AND edb01=new[i].edc01
                   AND edb04=new[i].sfb06
                   AND edb01=eda01 AND edaconf='Y'
              END IF
              IF NOT cl_null(new[i].edc02) THEN
                 CALL p002_edc02(new[i].edc01,new[i].edc02,new[i].new_part,new[i].sfb06)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(new[i].edc02,'aec-057',0)
                    NEXT FIELD edc02
                 END IF
              END IF
           END IF 
                   
         AFTER FIELD edc02
            IF NOT cl_null(new[i].edc02) THEN
               CALL p002_edc02(new[i].edc01,new[i].edc02,new[i].new_part,new[i].sfb06)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(new[i].edc02,'aec-058',0)
                  NEXT FIELD edc02
               END IF
            END IF

         BEFORE FIELD new_qty
            IF new[i].x = 'N' THEN
            END IF
   
         AFTER FIELD new_qty 
            IF new[i].new_qty IS NULL OR new[i].new_qty<0 THEN 
               NEXT FIELD new_qty 
            END IF
             #--MOD-530799 add    判斷工單數量是否大於訂單數量
            IF NOT cl_null(new[i].new_qty) THEN
               LET new[i].new_qty = s_digqty(new[i].new_qty,l_ima55)   
               SELECT inb16,inb08,ima55,((ima562+100)/100) INTO l_qty,   
               l_inb08,l_ima55,l_ima562
               FROM inb_file,ima_file
               WHERE inb01=g_ina.ina01 AND inb03=new[i].inb03
               AND inb04 = ima01 
              
               CALL s_umfchk(new[i].new_part,l_inb08,l_ima55)
                    RETURNING l_check,l_ima55_fac
               IF cl_null(l_ima55_fac) THEN 
                  LET l_ima55_fac = 1
               END IF
               LET l_qty = l_qty * l_ima55_fac * l_ima562
               LET l_sfb08 = 0
               SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
                WHERE sfb91  =  g_ina.ina01
                  AND sfb92 =  new[i].inb03
                  AND sfb04 <> '8'                                                       
                  AND sfb87!='X'

               SELECT SUM(sfb09) INTO l_sfb09 FROM sfb_file
                WHERE sfb91  =  g_ina.ina01
                  AND sfb92 =  new[i].inb03
                  AND sfb04  = '8'                                                        
                  AND sfb87 != 'X'
               
               IF l_sfb08 IS NULL THEN
                  LET l_sfb08 = 0
               END IF
               IF l_sfb09 IS NULL THEN
                  LET l_sfb09 = 0
               END IF
               
               LET l_qty = l_qty - l_sfb08-l_sfb09   
               

               IF new[i].x = 'Y' THEN         
                  IF new[i].sfb02 NOT MATCHES '[58]' THEN  
                     SELECT ima561,ima56 INTO l_ima561,l_ima56 FROM ima_file WHERE ima01=new[i].new_part
                     IF l_ima561 > 0 THEN
                        IF new[i].new_qty < l_ima561 THEN
                           CALL cl_err(l_ima561,'asf-307',0)
                           NEXT FIELD new_qty
                        END IF
                     END IF
                     LET l_allowqty = new[i].new_qty      
                     IF NOT cl_null(l_ima56) AND l_ima56>0  THEN
                        LET l_qty1 = new[i].new_qty * 1000
                        LET l_qty2 = l_ima56 * 1000
                        IF (l_qty1 MOD l_qty2) > 0 THEN
                           CALL cl_err(l_ima56,'asf-308',0)
                           NEXT FIELD new_qty
                        END IF
                        LET l_calc = 0
                        IF l_qty MOD l_ima56 > 0 THEN
                           LET l_calc = l_qty/l_ima56 + 1
                           LET l_allowqty = l_calc * l_ima56
                        END IF
                        IF new[i].new_qty > l_allowqty THEN
                           CALL cl_err('','asf-358',1)
                           LET new[i].new_qty = l_allowqty
                           NEXT FIELD new_qty
                        END IF
                     END IF
                  END IF  
               END IF                 
            END IF
            IF new[i].new_qty > l_qty THEN
               CALL cl_err('','asf-939',0)

            END IF
 
         BEFORE FIELD new_no  
             
         AFTER FIELD new_no  
            LET i=ARR_CURR()
          
            IF NOT cl_null(new[i].new_no) THEN  
               CALL i304_new_no(i)          
               IF NOT cl_null(g_errno) THEN
                 CALL cl_err(new[i].new_no,g_errno,0)
                 LET  new[i].new_no = NULL
                 DISPLAY BY NAME new[i].new_no
                 NEXT FIELD new_no
               END IF                                                                  
               CALL s_check_no("asf",new[i].new_no,"","1","","","")  
               RETURNING li_result,new[i].new_no                                                  
               DISPLAY BY NAME new[i].new_no                                                                                             
               IF (NOT li_result) THEN                                                                                                 
                  NEXT FIELD new_no
               END IF
               IF g_smy.smyauno='Y' AND NOT cl_null(new[i].new_no[g_no_sp,g_no_ep]) THEN      
                  NEXT FIELD new_no
               END IF
               DISPLAY new[i].new_no TO s_new[i].new_no
             
               SELECT smy60,smy72 INTO new[i].costcenter,l_smy72 FROM smy_file
                WHERE smyslip = new[i].new_no
               IF cl_null(l_smy72) THEN
                  LET l_smy72 = 1
               ELSE
                  IF l_smy72 NOT MATCHES '[17]' THEN
                     LET l_smy72 = 1
                  END IF
               END IF 
               LET new[i].sfb02 = l_smy72
               DISPLAY BY NAME new[i].sfb02
               DISPLAY new[i].costcenter TO s_new[i].costcenter
            END IF 
           
         AFTER FIELD ven_no
            LET i=ARR_CURR()
            IF NOT cl_null(new[i].ven_no) THEN    
                IF new[i].sfb02=1 THEN 
                  SELECT gem02 FROM gem_file
                   WHERE gem01=new[i].ven_no
                     AND gemacti = 'Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","gem_file",new[i].ven_no,"",STATUS,"","sel gem:",1)    
                     NEXT FIELD ven_no
                  END IF
               END IF
               IF new[i].sfb02=7 OR new[i].sfb02=8 THEN  
                  SELECT pmc03 FROM pmc_file
                   WHERE pmc01=new[i].ven_no
                     AND pmcacti = 'Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","pmc_file",new[i].ven_no,"",STATUS,"","sel pmc:",1)    
                     NEXT FIELD ven_no
                  END IF
               END IF
            END IF
   
         AFTER FIELD b_date
                                                                                      
#              ERROR '開工日為空白or小於工單日,請檢查!'                                                                             
            IF NOT cl_null(new[i].b_date) THEN          
               IF new[i].b_date < g_sfb.sfb81 THEN      
                  CALL cl_err('','asf-867','1')                                                                               
                  NEXT FIELD b_date
               END IF
               
               IF NOT cl_null(new[i].e_date) AND new[i].e_date < new[i].b_date THEN
                  CALL cl_err('','asf-310','1')
                  NEXT FIELD b_date 
               END IF 
               LET li_result = 0
               CALL s_daywk(new[i].b_date) RETURNING li_result
               IF li_result = 0 THEN      #0:非工作日
                  CALL cl_err(new[i].b_date,'mfg3152',1)
               END IF
               IF li_result = 2 THEN      #2:未設定
                  CALL cl_err(new[i].b_date,'mfg3153',1)
               END IF
               #MOD-C50055 add end-----------------------
            END IF
   
         AFTER FIELD e_date
                                                                                
#              ERROR '完工日為空白or小於工單日,請檢查!'                                                                             
            IF NOT cl_null(new[i].e_date) THEN
               IF new[i].e_date < g_sfb.sfb81 THEN
                  CALL cl_err('','asf-868','1')
                  NEXT FIELD e_date
               END IF
               IF new[i].e_date < new[i].b_date THEN
                        CALL cl_err('','asf-310','1')                                                                                 
#                 ERROR '完工日不能小於開工日,請檢查!'                                                                                 
                  NEXT FIELD e_date                                                                                                    
               END IF 
               LET li_result = 0
               CALL s_daywk(new[i].e_date) RETURNING li_result
               IF li_result = 0 THEN      #0:非工作日
                  CALL cl_err(new[i].e_date,'mfg3152',1)
               END IF
               IF li_result = 2 THEN      #2:未設定
                  CALL cl_err(new[i].e_date,'mfg3153',1)
               END IF
               #MOD-C50055 add end-----------------------
               IF cl_confirm('asf-379') THEN
                  #前置時間(l_time)=生產數量(sfb08)*變動前置時間(ima60)
                  #if l_time <=7: 以7天計, >7:以照原值計,
                  #預計開工日(sfb13): 預計完工日-l_time,但不可小於開單日期
                  SELECT ima60,ima601,ima59,ima61 INTO l_ima60,l_ima601,l_ima59,l_ima61 FROM ima_file 
                   WHERE ima01 = new[i].new_part
                  LET l_time=(new[i].new_qty * l_ima60/l_ima601)+l_ima59+l_ima61  
                  display "l_time:" ||l_time
                  display "l_ima60:" ||l_ima60
                  display "l_ima601:" ||l_ima601  
                  display "l_ima59:" ||l_ima59
                  display "l_ima61:" ||l_ima61
                  display "new[i].new_qty:" ||new[i].new_qty
                  IF cl_null(l_time) THEN
                     LET l_time = 0
                  END IF
                  LET s_date=l_time+0.5
                  IF cl_null(s_date) THEN
                     LET s_date = 0
                  END IF

                 CALL s_aday(new[g_i].e_date,-1,s_date) RETURNING new[g_i].b_date  
  
               END IF
 
               IF new[i].b_date IS NULL OR (new[i].b_date < g_sfb.sfb81) OR
                 (new[i].b_date > new[i].e_date) THEN
                  LET new[i].b_date=g_sfb.sfb81
               END IF
    
               DISPLAY new[i].b_date TO s_new[i].b_date 
            END IF
   
         AFTER FIELD a
            IF new[i].a IS NULL OR (new[i].a != 'Y' AND new[i].a != 'N') THEN
               NEXT FIELD a
            END IF
   
         AFTER FIELD costcenter 
            IF NOT s_costcenter_chk(new[i].costcenter) THEN
               NEXT FIELD costcenter
            ELSE
               LET new[i].gem02c=s_costcenter_desc(new[i].costcenter)
               DISPLAY BY NAME new[i].gem02c
            END IF
 
         AFTER ROW 
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              LET g_success = 'N'
              RETURN
           END IF
           LET i = ARR_CURR() 
           IF new[i].x = 'Y' THEN  
              IF new[i].sfb93 = 'Y' THEN
                 IF cl_null(new[i].sfb06) THEN
                    NEXT FIELD sfb06
                 END IF
              END IF
           END IF
           IF NOT cl_null(new[i].edc01) AND cl_null(new[i].edc02) THEN
              NEXT FIELD edc02
           END IF
           IF NOT cl_null(new[i].edc02) AND cl_null(new[i].edc01) THEN
              NEXT FIELD edc01
           END IF
   
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(new_part) 
                  LET i=ARR_CURR()

                   CALL q_sel_ima(FALSE, "q_ima","",new[i].new_part,"","","","","",'' ) 
                   RETURNING  new[i].new_part
                  DISPLAY new[i].new_part TO s_new[i].new_part 
                  NEXT FIELD new_part
              WHEN INFIELD(ima910)                                                                                                  
                 LET i=ARR_CURR()                                                                                                   
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form = "q_bma7"                                                                                     
                 LET g_qryparam.default1 = new[i].ima910                                                                            
                 LET g_qryparam.arg1 = new[i].new_part                                                                              
                 CALL cl_create_qry() RETURNING new[i].ima910                                                                       
                 DISPLAY new[i].ima910 TO s_new[i].ima910                                                                           
                 NEXT FIELD ima910                                                                                                  
               WHEN INFIELD(new_qty) 
                  LET i=ARR_CURR()
                  LET g_cmd = "aimq102"," '1' "," '",new[i].new_part,"' "
                  CALL cl_cmdrun(g_cmd CLIPPED)
               WHEN INFIELD(new_no)
                  
                  IF l_barcode_yn = 'Y' THEN
                     LET i=ARR_CURR()
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smyslip2"
                     LET g_qryparam.default1 = new[i].new_no
                     LET g_qryparam.arg1 = 'asf'
                     LET g_qryparam.arg2 = '1'
                     LET g_qryparam.arg3 = '2'
                     CALL cl_create_qry() RETURNING new[i].new_no
                     DISPLAY new[i].new_no TO s_new[i].new_no
                     NEXT FIELD new_no
                  ELSE
                     LET i=ARR_CURR()
                     LET g_sql_smy = " (smy73 <> 'Y' OR smy73 is null)" 
                     CALL smy_qry_set_par_where(g_sql_smy)               
                     LET g_t1 = s_get_doc_no(new[i].new_no)             
                     CALL q_smy(FALSE,FALSE,new[i].new_no,'ASF','1') RETURNING new[i].new_no  
                     DISPLAY new[i].new_no TO s_new[i].new_no     
                     NEXT FIELD new_no
                  END IF                                              
               WHEN INFIELD(ven_no)
                   CASE                                
                     WHEN new[i].sfb02 MATCHES '[78]'   
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_pmc"
                        LET g_qryparam.default1 = new[i].ven_no
                        CALL cl_create_qry() RETURNING new[i].ven_no
                     OTHERWISE
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gem"
                        LET g_qryparam.default1 = new[i].ven_no
                        CALL cl_create_qry() RETURNING new[i].ven_no
                   END CASE
                   DISPLAY new[i].ven_no TO s_new[i].ven_no     
                   NEXT FIELD ven_no
               WHEN INFIELD(costcenter)
                    CALL cl_init_qry_var()
                    IF g_aaz.aaz90='Y' THEN
                       LET g_qryparam.form ="q_gem4"
                    ELSE
                       LET g_qryparam.form ="q_gem"
                    END IF
                    LET g_qryparam.default1 = new[i].costcenter
                    CALL cl_create_qry() RETURNING new[i].costcenter
                    DISPLAY BY NAME new[i].costcenter
                    NEXT FIELD costcenter
                WHEN INFIELD(sfb06) 
                  LET i=ARR_CURR()
                  SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01=new[i].new_part
                  IF cl_null(l_ima571) THEN LET l_ima571=' ' END IF
                  CALL cl_init_qry_var()
                  IF g_sma.sma541 = 'Y' THEN    
                       LET g_qryparam.form     = "q_ecu05_a" 
                    ELSE   
                       LET g_qryparam.form     = "q_ecu05"   
                  END IF 
                  LET g_qryparam.arg1     = l_ima571
                  LET g_qryparam.arg2 = new[i].new_part        
                  LET g_qryparam.default1 = new[i].sfb06
                  CALL cl_create_qry() RETURNING g_ecu01,new[i].sfb06 
                  
            
                  DISPLAY new[i].sfb06 TO sfb06 
                  NEXT FIELD sfb06
                WHEN INFIELD(edc01) OR INFIELD(edc02) 
                  LET i=ARR_CURR()
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_edc"
                  LET g_qryparam.default1 = new[i].edc01
                  LET g_qryparam.default2 = new[i].edc02
                  LET g_qryparam.where = " edb03='",new[i].new_part,"' AND edb04='",new[i].sfb06,"' "
                  CALL cl_create_qry() RETURNING new[i].edc01,new[i].edc02
                  DISPLAY new[i].edc01 TO edc01
                  DISPLAY new[i].edc02 TO edc02
                  NEXT FIELD CURRENT
               OTHERWISE EXIT CASE 
             END CASE
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION ALL
            FOR l_i = 1 TO new.getLength()
               LET new[l_i].x = 'Y'
            END FOR
         ON ACTION no_all
            FOR l_i = 1 TO new.getLength()
               LET new[l_i].x = 'N'
            END FOR
      END INPUT
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         RETURN
      END IF
   END IF  
 
      LET l_proc = 'N'
      # 檢查單身
      FOR i = 1 TO new.getLength()
         IF new[i].x = 'Y' AND NOT cl_null(new[i].ven_no) THEN   
            IF new[i].sfb02 = '7' OR new[i].sfb02 = '8' THEN       #
               SELECT pmc03 FROM pmc_file
                WHERE pmc01=new[i].ven_no
                  AND pmcacti= 'Y' 
               IF STATUS THEN
                  CALL cl_err3("sel","pmc_file",new[i].ven_no,"",STATUS,"","sel pmc",1)  
                  EXIT FOR 
               END IF
            END IF    
            IF new[i].sfb02 = '1' THEN    
               SELECT gem02 FROM gem_file
                WHERE gem01=new[i].ven_no
                  AND gemacti = 'Y'
               IF STATUS THEN
                  LET g_flag = 'N'
                  CALL cl_err3("sel","gem_file",new[i].ven_no,"",STATUS,"","sel gem:",1)    
                  EXIT FOR
               END IF
            END IF 
         END IF    
         IF new[i].x = 'Y' AND cl_null(new[i].new_no) THEN
            LET g_flag = 'N'
            CALL cl_err('','asf-380','1')                                                                                           
#           ERROR "尚未完成工單編號"                                                                                                
            EXIT FOR
         END IF
         IF new[i].x = 'Y' THEN
            LET l_proc = 'Y'
            IF new[i].sfb02 NOT MATCHES '[58]' THEN  
               SELECT ima561,ima56 INTO l_ima561,l_ima56 FROM ima_file 
                WHERE ima01 = new[i].new_part
               IF l_ima561 > 0 THEN
                 IF new[i].new_qty < l_ima561 THEN
                    LET g_flag = 'N'
                    CALL cl_err(l_ima561,'asf-307',1)
                    EXIT FOR
                 END IF
               END IF
               LET l_allowqty = new[i].new_qty       
               IF NOT cl_null(l_ima56) AND l_ima56>0  THEN
                  LET l_qty1 = new[i].new_qty * 1000
                  LET l_qty2 = l_ima56 * 1000
                  IF (l_qty1 MOD l_qty2) > 0 THEN
                     LET g_flag = 'N'
                     CALL cl_err(l_ima56,'asf-308',1)
                     EXIT FOR
                  END IF
                  IF l_qty > 0 THEN
                     LET l_calc = 0
                     IF l_availqty MOD l_ima56 > 0 THEN
                        LET l_calc = l_availqty/l_ima56 + 1
                        LET l_allowqty = l_calc * l_ima56
                     END IF
                     IF g_sfb.sfb08 > l_allowqty THEN
                        CALL cl_err('','asf-358',1)
                        EXIT FOR
                     END IF
                  END IF
               END IF
            END IF  
         END IF            
      END FOR 
   
      IF g_flag= 'N' THEN
         CONTINUE WHILE
      END IF
 
      IF l_proc = 'N' THEN
         EXIT WHILE
      END IF
   
      IF g_bgjob = 'N' THEN  
        IF NOT cl_sure(19,0) THEN
           RETURN
        END IF
      END IF
   
      CALL cl_wait()

      LET g_wos = " sfb01 IN ('"
  
    # 陣列列印資料
      CALL s_showmsg_init() 
      FOR i=1 TO new.getLength()
         BEGIN WORK
         LET g_success = 'Y'   
         IF cl_null(new[i].new_part) THEN
            EXIT FOR
         END IF
         IF cl_null(new[i].new_no) THEN 
            CONTINUE FOR
         END IF
         IF cl_null(new[i].new_qty) THEN
            CONTINUE FOR
         END IF
         IF new[i].x = 'N' THEN
            CONTINUE FOR
         END IF
         IF new[i].new_qty = 0 THEN
            CONTINUE FOR
         END IF
   
         INITIALIZE l_sfb.* TO NULL
  
        IF cl_null(new[i].new_no[g_no_sp,g_no_ep]) THEN                                                                               
           CALL s_auto_assign_no("asf",new[i].new_no,g_sfb.sfb81,"","","","","","")                                              
                RETURNING li_result,new[i].new_no                                                                                            
           IF (NOT li_result) THEN                                    
              CALL s_errmsg('smyslip',new[i].new_no,'s_auto_assign_no','asf-963',1)
              LET g_success='N'
            END IF    #有問題
         END IF
   
         LET l_sfb.sfb01 = new[i].new_no
         LET l_sfb.sfb02 = new[i].sfb02 #FUN-650054
         LET l_sfb.sfb04 = '1'
         LET l_sfb.sfb05 = new[i].new_part
        #先不給"製程編號"(sfb06)，到後面再根據sfb93判斷要不要給值
         SELECT ima35,ima36,ima571
           INTO l_sfb.sfb30,l_sfb.sfb31,l_item
           FROM ima_file
          WHERE ima01=l_sfb.sfb05 AND imaacti= 'Y'

        #MOD-E30086-Start-Add
        #如不同料號，卻有相同名稱的製程，會有問題，故都改抓開窗回傳的料號
         IF NOT cl_null(g_ecu01) THEN
            LET l_item = g_ecu01
         END IF 
        #MOD-E30086-End-Add
     
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('ima01',l_sfb.sfb05,'select ima35','aom-198',1)
            LET g_success = 'N'
         END IF
         IF cl_null(l_item) THEN LET l_item=l_sfb.sfb05 END IF 
 
         LET l_ima910=new[i].ima910
         IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
         LET l_cnt = 0
         IF NOT cl_null(new[i].sfb06) AND g_sma.sma542 = 'Y' THEN
            SELECT count(*) INTO l_cnt FROM bra_file
             WHERE bra01=l_sfb.sfb05
               AND bra05 IS NOT NULL
               AND bra05 <=g_sfb.sfb81
               AND bra06 = l_ima910 
               AND bra011 = new[i].sfb06
               AND braacti = 'Y'      
         END IF  
         IF l_cnt = 0 THEN  
            SELECT count(*) INTO l_cnt FROM bma_file  
             WHERE bma01=l_sfb.sfb05
               AND bma05 IS NOT NULL
               AND bma05 <=g_sfb.sfb81
               AND bma06 = l_ima910   
               AND bmaacti = 'Y'      
               AND bma10 = '2'        #20190905 BOM應被發放
         END IF  
   
         IF l_cnt = 0 THEN  
            IF l_sfb.sfb02!='5' AND l_sfb.sfb02!='8' AND l_sfb.sfb02!='11' THEN   
               CALL s_errmsg('bom',l_sfb.sfb05,g_sfb.sfb81,'mfg5071',1)    
               LET g_success = 'N'
            END IF                     
         END IF
   
         #--(1)產生工單檔(sfb_file)---------------------------
         
         LET l_sfb.sfb071= g_today                    
         LET l_sfb.sfb08 = new[i].new_qty
         LET l_sfb.sfb081= 0
         LET l_sfb.sfb09 = 0
         LET l_sfb.sfb10 = 0
         LET l_sfb.sfb11 = 0
         LET l_sfb.sfb111= 0
         LET l_sfb.sfb121= 0
         LET l_sfb.sfb122= 0 
         LET l_sfb.sfb12 = 0
         LET l_sfb.sfb13 = new[i].b_date
         LET l_sfb.sfb14 = '00:00'       
         LET l_sfb.sfb15 = new[i].e_date
         LET l_sfb.sfb16 = '00:00'       
         LET l_sfb.sfb23 = 'Y' 
         LET l_sfb.sfb24 = 'N'
         LET l_sfb.sfb251= g_sfb.sfb81
         LET l_sfb.sfb91 = new[i].inb01                                                                                           
         LET l_sfb.sfb92= new[i].inb03 
         LET l_sfb.ta_sfb01 = l_sfb.sfb92 USING "&&&"       #20220913 modify
         LET l_sfb.ta_sfb01 = l_sfb.sfb91,l_sfb.ta_sfb01    #20220913 modify
        #LET l_sfb.ta_sfb01 = ''                            #20220913 mark
         LET l_sfb.sfb27 = ' '    
         LET l_sfb.sfb29 = 'Y'
         LET l_sfb.sfb39 = '1'
         LET l_sfb.sfb81 = g_sfb.sfb81
         LET l_sfb.sfb82 = new[i].ven_no
         LET l_sfb.sfb85 = ' '    
         LET l_sfb.sfb86 = ' '    
         LET l_sfb.sfb89 = ' '    
         LET l_sfb.sfb87 = 'N'
         LET l_sfb.sfb91 = l_sfb.sfb91 
         LET l_sfb.sfb92 = l_sfb.sfb92
         LET l_sfb.sfb87 = 'N'    
         LET l_sfb.sfb41 = 'N'
         LET l_sfb.sfb44 = g_user 
         LET l_sfb.sfb919=new[i].sfb919   
         LET l_formid = s_get_doc_no(new[i].new_no)
       
         LET l_sfb.sfb27 = ''
         LET l_sfb.sfb271= ''
         LET l_sfb.sfb50 = ''
         LET l_sfb.sfb51 = ''
         SELECT smyapr INTO l_sfb.sfbmksg FROM smy_file
          WHERE smyslip=l_formid
         LET l_sfb.sfb43 = '0'    
         IF l_sfb.sfb02='11' THEN #拆件式工單=>sfb99='Y'
            LET l_sfb.sfb99 = 'Y'
         ELSE
            LET l_sfb.sfb99 = 'N'
         END IF
         LET l_sfb.sfb85= tm.sfc01 
         LET l_sfb.sfb17 = NULL   
         LET l_sfb.sfb95=l_ima910
         LET l_sfb.sfb98 = new[i].costcenter 
         LET l_sfb.sfbacti = 'Y'
         LET l_sfb.sfbuser = g_user
         LET l_sfb.sfbgrup = g_grup
         LET l_sfb.sfbdate = g_today
         LET l_sfb.sfb1002='N' #保稅核銷否 #
 
         LET l_sfb.sfbplant = g_plant 
         LET l_sfb.sfblegal = g_legal 
   
         LET l_slip = s_get_doc_no(l_sfb.sfb01)      
         SELECT smy57 INTO l_smy57 FROM smy_file WHERE smyslip=l_slip
         LET l_sfb.sfb93 = new[i].sfb93  
         LET l_sfb.sfb94 = l_smy57[2,2]
         #MOD-G10147 add start -----------------------
         LET l_sfb.sfb100= l_smy57[6,6]
         IF l_sfb.sfb02 NOT MATCHES "[78]" THEN  
            LET l_sfb.sfb100 = '1'                
         END IF                                
         IF cl_null(l_sfb.sfb100) THEN
            LET l_sfb.sfb100 = '1'
         END IF                     
         IF NOT cl_null(new[i].sfb06) AND 
            (l_sfb.sfb02!='7' AND l_sfb.sfb02!='8' AND l_sfb.sfb02!='15') THEN
            LET l_sfb.sfb06 = new[i].sfb06               
         END IF
   
         IF cl_null(l_sfb.sfb98) THEN
            SELECT ima34 INTO l_sfb.sfb98 FROM ima_file
             WHERE ima01 = l_sfb.sfb05
         END IF

         LET l_sfb.sfboriu = g_user     
         LET l_sfb.sfborig = g_grup      
         LET l_sfb.sfb51=''
         LET l_sfb.sfb07=''
         LET l_sfb.sfb223=''
         LET l_sfb.sfb224=''
         LET l_sfb.sfb104 = 'N'   
       
         
         INSERT INTO sfb_file VALUES(l_sfb.*)
         IF SQLCA.SQLCODE THEN
            CALL s_errmsg('sfb05',l_sfb.sfb05,'insert sfb','asf-738',1)
            LET g_success='N'   
            LET new[i].new_no=null
         END IF
      
      
         IF l_sfb.sfb93='Y' THEN
            CALL s_schdat(0,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb071,l_sfb.sfb01,
                          l_sfb.sfb06,l_sfb.sfb02,l_item,l_sfb.sfb08,2)
               RETURNING g_cnt,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb32,l_sfb.sfb24
         END IF
 
         IF l_sfb.sfb24 IS NOT NULL THEN
            UPDATE sfb_file
               SET sfb24= l_sfb.sfb24 
             WHERE sfb01=l_sfb.sfb01 
            IF SQLCA.sqlcode THEN 
               CALL s_errmsg('sfb05',l_sfb.sfb05,'update sfb',SQLCA.sqlcode,1)
               LET g_success='N' 
            END IF
         END IF
   
         #-->(2)產生備料檔
         LET l_minopseq=0
         
         CALL s_minopseq(l_sfb.sfb05,l_sfb.sfb06,l_sfb.sfb071) RETURNING l_minopseq
         
         CASE
            WHEN l_sfb.sfb02='1' OR l_sfb.sfb02='7' #一般工單 or 委外工單 (保留原本asfp304的處理方式)
               LET l_minopseq = 0
                   CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y', 
                               l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,
                                  '',l_sfb.sfb95)        
                    RETURNING g_cnt
                             
            WHEN l_sfb.sfb02='13'     #預測工單展至尾階
               CALL s_cralc2(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                             l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,
                             ' 1=1',l_sfb.sfb95)
               RETURNING g_cnt
            WHEN l_sfb.sfb02='15'     #試產性工單
               CALL s_cralc3(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                             l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,
                             l_sfb.sfb07,g_sma.sma883,l_sfb.sfb95)
               RETURNING g_cnt
            OTHERWISE                 #一般工單展單階
               IF l_sfb.sfb02 = 11 THEN
                  LET l_btflg = 'N'
               ELSE
                  LET l_btflg = 'Y'
               END IF
               CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
                            l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,'',l_sfb.sfb95)  #FUN-BC0008 mod
                  RETURNING g_cnt
         END CASE
         IF g_cnt = 0 THEN
             CALL s_errmsg('sfb05',l_sfb.sfb05,'s_cralc error','asf-385',1)
             LET g_success = 'N' 
             LET new[i].new_no=null
         END IF
         #FUN-A80054--begin--add------------------------------
         IF g_sma.sma541 = 'Y' THEN  
            IF NOT cl_null(new[i].edc01) AND NOT cl_null(new[i].edc02) THEN
              DECLARE sfd_cs1 CURSOR FOR
               SELECT sfd01 FROM sfd_tmp
              LET l_sfd01=''  LET l_sfd.sfd01=''
              FOREACH sfd_cs1 INTO l_sfd01
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM sfd_file WHERE sfd01=l_sfd01 AND sfd08=new[i].edc01 AND sfdconf='N'
                 IF l_cnt > 0 THEN
                    LET l_sfd.sfd01=l_sfd01
                    EXIT FOREACH
                 END IF
              END FOREACH 
             
               IF cl_null(l_sfd.sfd01) THEN 
                  LET l_t1=s_get_doc_no(new[i].edc01) 
                  SELECT smy75 INTO l_sfd.sfd01 FROM smy_file
                   WHERE smyslip=l_t1
                  IF cl_null(l_sfd.sfd01) THEN 
                     CALL s_errmsg('smy75',l_t1,'sel smy','aec-060',1)
                     LET g_success='N' 
                     LET new[i].new_no=null
                  END IF
                  CALL s_auto_assign_no("asf",l_sfd.sfd01,g_today,"8","sfd_file","sfd01","","","") 
                  RETURNING li_result,l_sfd.sfd01                                                                                               
                  IF (NOT li_result) THEN                                                                                                     
                     LET g_success='N'
                     LET new[i].new_no=null
                  END IF
                  IF NOT cl_null(l_sfd.sfd01) THEN
                     LET l_sfc.sfc01=l_sfd.sfd01
                     LET l_sfc.sfcuser=g_user
                     LET l_sfc.sfcgrup=g_grup
                     LET l_sfc.sfcdate=g_today
                     LET l_sfc.sfcacti='Y'
                     LET l_sfc.sfcoriu=g_user
                     LET l_sfc.sfcorig=g_grup
                     INSERT INTO sfc_file VALUES(l_sfc.*)
                     IF SQLCA.sqlcode THEN 
                        CALL s_errmsg('sfc01',l_sfc.sfc01,'ins sfc',SQLCA.sqlcode,1)
                        LET g_success='N' 
                        LET new[i].new_no=null
                     END IF

                     IF g_sma.sma541 = 'Y' THEN 
                        INSERT INTO sfd_tmp VALUES(l_sfc.sfc01)
                     END IF  
                  END IF
               END IF  
               IF NOT cl_null(l_sfd.sfd01) THEN
                  SELECT MAX(sfd02)+1 INTO l_sfd.sfd02 FROM sfd_file WHERE sfd01=l_sfd.sfd01
                  IF cl_null(l_sfd.sfd02) THEN LET l_sfd.sfd02 = 1 END IF
                  LET l_sfd.sfd03=new[i].new_no
                  LET l_sfd.sfd08=new[i].edc01
                  LET l_sfd.sfd04=new[i].edc02
                  LET l_sfd.sfd09 = '2'  
                  LET l_sfd.sfdconf='N'
                  LET  l_sfd.sfduser = g_user        
                  LET  l_sfd.sfdgrup = g_grup        
                  LET  l_sfd.sfddate = g_today       
                  LET  l_sfd.sfdacti ='Y'            
                  LET  l_sfd.sfdoriu = g_user        
                  LET  l_sfd.sfdorig = g_grup        
                  SELECT edb05,edb07 INTO l_sfd.sfd05,l_sfd.sfd07
                    FROM edb_file
                   WHERE edb01=new[i].edc01
                     AND edb02=new[i].edc02
                  INSERT INTO sfd_file VALUES(l_sfd.*)
                  IF SQLCA.sqlcode THEN 
                     CALL s_errmsg('sfd01',l_sfd.sfd01,'ins sfd',SQLCA.sqlcode,1)
                     LET g_success='N' 
                     LET new[i].new_no=null
                  END IF
                  SELECT sum(sfd05) INTO l_sfd.sfd06 FROM sfd_file WHERE sfd01=l_sfd.sfd01
                  UPDATE sfd_file SET sfd06=l_sfd.sfd06 WHERE sfd01=l_sfd.sfd01
                  UPDATE sfb_file SET sfb85=l_sfd.sfd01 WHERE sfb01=l_sfb.sfb01
                  IF g_success='Y' THEN
                     CALL p002_ins_edg(l_sfd.sfd01,l_sfd.sfd02,l_sfd.sfd03,new[i].edc01,new[i].edc02)
                     IF g_success='N' THEN LET new[i].new_no=null END IF
                     IF g_success = 'Y' THEN
                        CALL p002_ins_edh(l_sfd.sfd01,l_sfd.sfd02,new[i].edc01,new[i].edc02)
                        IF g_success='N' THEN LET new[i].new_no=null END IF
                     END IF
                  END IF
               END IF
            END IF
         END IF  
        
         IF l_sfb.sfb02 != '5' AND l_sfb.sfb02 != '11' THEN
        
            IF new[i].a = 'Y' THEN
               CALL p301(l_sfb.sfb01, l_sfb.sfb81, 99, 'N', TRUE)
            END IF
         END IF

         CALL p002_chk_sfb39(l_sfb.sfb01)      
 
 
      END FOR
      CALL s_showmsg()    

      IF g_success = 'Y' THEN
         COMMIT WORK
         # 将成功生成的工单号显示出来
         LET g_sql = "SELECT * FROM p304_tmp ORDER BY orno"
         DECLARE p304_orno CURSOR FROM g_sql
         LET i = 1
         FOREACH p304_orno INTO l_max_no
            LET mg[i].orno = l_max_no  
            LET i = i + 1
         END FOREACH
         CALL cl_get_feldname('sfb01', g_lang) RETURNING g_msg
         CALL cl_show_array(base.TypeInfo.CREATE(mg), g_msg, g_msg)
      ELSE
         ROLLBACK WORK
         RETURN           
      END IF
      DROP TABLE p304_tmp
   
      ERROR ""
      IF g_sma.sma541 = 'Y' THEN  DROP TABLE sfd_bmp END IF 
   
      LET l_max_no = ''  
      LET l_min_no = '' 
      FOR i=1 TO new.getLength()
       
         IF new[i].x = 'N' THEN
            CONTINUE FOR
         END IF
         IF cl_null(l_max_no) AND cl_null(l_min_no) THEN
            LET l_max_no = new[i].new_no
            LET l_min_no = new[i].new_no
         END IF
         IF cl_null(l_max_no) THEN LET l_max_no = ' ' END IF   
         IF new[i].new_no > l_max_no THEN LET l_max_no = new[i].new_no END IF
         IF cl_null(l_min_no) THEN LET l_min_no = l_max_no END IF   
         IF new[i].new_no < l_min_no THEN LET l_min_no = new[i].new_no END IF
         # 用子工單更新l_min_no、l_max_no
         IF NOT cl_null(new[i].new_no) THEN  
            IF g_wos = " sfb01 IN ('" THEN
               LET g_wos = g_wos,new[i].new_no CLIPPED
            ELSE
               LET g_wos = g_wos,"','",new[i].new_no CLIPPED
            END IF
            CALL p002_sub_no(new[i].new_no,l_min_no,l_max_no) RETURNING l_min_no,l_max_no 
         END IF 
         IF cl_null(new[i].new_part) THEN EXIT FOR END IF
         DISPLAY new[i].new_no TO s_new[i].new_no
      END FOR

      LET g_wos = g_wos,"')"
     

       LET i = new.getLength()
       IF cl_null(l_max_no) AND cl_null(l_min_no) THEN
          CALL cl_err('','asf-196',1)
       ELSE
       
          IF cl_null(l_min_no) THEN
             LET g_msg = l_max_no CLIPPED
          ELSE
             IF cl_null(l_max_no) THEN
                LET g_msg = l_min_no CLIPPED
             ELSE
                LET g_msg = l_min_no CLIPPED,"~",l_max_no
             END IF
          END IF
          CALL cl_err(g_msg,'mfg0101',1) 
       END IF  #TQC-B60133
     
        IF g_argv3 = 'Y' THEN
          FOR i = 1 TO new.getLength()
             IF new[i].x = 'N' THEN
                CONTINUE FOR
             END IF
             IF cl_null(new[i].new_no) THEN
                CONTINUE FOR
             END IF

             CALL i301sub_firm1_chk(new[i].new_no,FALSE)  
             IF g_success = 'Y' THEN
                CALL i301sub_firm1_upd(new[i].new_no,"confirm",FALSE)  #CALL原確認的update段 
             END IF
          END FOR
        END IF

      IF g_wos = " sfb01 IN ('')" THEN     
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
        LET l_wos = g_wos
        LET l_pass_pmk = ''
        LET l_tot_cnt = 0
        LET l_ori_pmk = g_pmk.pmk01
        LET l_sql = "SELECT UNIQUE ima43 FROM sfb_file,sfa_file,ima_file ",
                    " WHERE sfb01 = sfa01 AND sfa03 = ima01 ",
                    "   AND sfa03 NOT LIKE '5%' AND ",g_wos CLIPPED
        DECLARE split_pmk_cs CURSOR FROM l_sql
        FOREACH split_pmk_cs INTO l_ima43
           IF SQLCA.sqlcode THEN
              CALL cl_err('split_pmk_cs',SQLCA.sqlcode,1)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
           LET g_pmk.pmk01 = l_ori_pmk
           IF NOT cl_null(l_ima43) THEN                                                    
           LET g_wos = l_wos," AND sfa03 NOT LIKE '5%' ",
                             " AND EXISTS( SELECT 1 FROM ima_file WHERE ima01 = sfa03 AND ima43 = '",l_ima43,"') "
           ELSE                                                                             
           LET g_wos = l_wos," AND sfa03 NOT LIKE '5%' ",                                   
                             " AND EXISTS( SELECT 1 FROM ima_file WHERE ima01 = sfa03 AND ima43 is null) "   
           END IF                                                                           
         CALL p002_ins_pmk()
         IF g_success = 'Y' THEN
            CALL p002_ins_pnl()
         END IF
         IF g_success = 'Y' THEN
            CALL p470('P',g_pmk.pmk01,pr_date) 
         END IF
         IF g_success = 'Y' THEN
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM pml_file
            WHERE pml01 = g_pmk.pmk01
           IF l_cnt = 0 THEN
            DELETE FROM pmk_file WHERE pmk01 = g_pmk.pmk01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               IF SQLCA.sqlcode = 0 THEN LET SQLCA.sqlcode = 9050 END IF
               CALL cl_err3("del","pmk_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
            END IF
            LET g_pmk.pmk01 = NULL
           ELSE     
            LET l_pmk40 = 0
            SELECT SUM(pmlud07) INTO l_pmk40 
              FROM pml_file
             WHERE pml01=g_pmk.pmk01
            IF SQLCA.sqlcode OR g_pmk.pmk40 IS NULL THEN
               LET g_pmk.pmk40=0
            END IF
            SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01=g_pmk.pmk22 AND aziacti='Y'
            CALL cl_digcut(l_pmk40,t_azi04) RETURNING l_pmk40
            UPDATE pmk_file SET pmk40=l_pmk40
             WHERE pmk01=g_pmk.pmk01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               IF SQLCA.sqlcode = 0 THEN LET SQLCA.sqlcode = 9050 END IF
               CALL cl_err3("upd","pmk_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","update pmk40 fail :",1)
               LET g_success = 'N'
            ELSE
               IF cl_null(l_pass_pmk) THEN
                  LET l_pass_pmk = g_pmk.pmk01
             
               END IF
               LET l_tot_cnt = l_tot_cnt + 1
            END IF
           END IF   
         END IF
        END FOREACH
        IF cl_null(l_pass_pmk) THEN
           LET l_pass_pmk = g_pmk.pmk01
        ELSE
           LET l_pass_pmk = l_pass_pmk,"~",g_pmk.pmk01
        END IF
     
         IF g_success = 'Y' AND l_tot_cnt > 0 THEN
            CALL cl_err(l_pass_pmk,'axm-559',1) #請購單已經成功產生
            COMMIT WORK
          
         ELSE
          IF NOT cl_null(g_pmk.pmk01) THEN   
            CALL cl_err('','axm-558',1) #請購單未能成功產生
          ELSE
            CALL cl_err('','TSD0033',1) #此次不需產生請購單
          END IF
            ROLLBACK WORK
         END IF
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 

#FUN-A80054--begin--add---------------------
FUNCTION p002_edc02(p_edc01,p_edc02,p_sfb05,p_sfb06)
DEFINE l_cnt    LIKE type_file.num5
DEFINE p_edc01  LIKE edc_file.edc01
DEFINE p_edc02  LIKE edc_file.edc02
DEFINE p_sfb05  LIKE sfb_file.sfb05
DEFINE p_sfb06  LIKE sfb_file.sfb06

  LET l_cnt=0
  LET g_errno=''
  IF cl_null(p_edc01) OR cl_null(p_edc02) OR cl_null(p_sfb05) OR cl_null(p_sfb06) THEN RETURN END IF  #FUN-B20085
  SELECT COUNT(*) INTO l_cnt FROM eda_file,edb_file 
   WHERE edb01=p_edc01 
     AND edb02=p_edc02
     AND edb03=p_sfb05 
     AND edb04=p_sfb06
     AND eda01=edb01 AND edaconf='Y'
  IF l_cnt=0 THEN LET g_errno='aec-058' END IF

END FUNCTION

FUNCTION p002_ins_edg(p_sfd01,p_sfd02,p_sfd03,p_edc01,p_edc02)
DEFINE p_sfd01    LIKE sfd_file.sfd01
DEFINE p_sfd02    LIKE sfd_file.sfd02
DEFINE p_sfd03    LIKE sfd_file.sfd03
DEFINE p_edc01    LIKE edc_file.edc01
DEFINE p_edc02    LIKE edc_file.edc02
DEFINE l_edg      RECORD LIKE edg_file.*
DEFINE l_edc      RECORD LIKE edc_file.*
#FUN-A80060--begin--add------------------
DEFINE p_strtdat       LIKE type_file.dat,
       p_duedat        LIKE type_file.dat,
       w_bdate,w_edate LIKE type_file.dat,
       w_day           LIKE type_file.num5, 
       w_flag          LIKE type_file.chr1,
       l_sfb13         LIKE sfb_file.sfb13,
       l_sfb15         LIKE sfb_file.sfb15
#FUN-A80060--end--add------------------

    DECLARE edc_cs CURSOR FOR
      SELECT * FROM edc_file WHERE edc01=p_edc01 AND edc02=p_edc02 ORDER BY edc03
    FOREACH edc_cs INTO l_edc.*
      LET l_edg.edg01 =p_sfd01
      LET l_edg.edg02 =p_sfd02
      LET l_edg.edg03 =l_edc.edc03   
      LET l_edg.edg04 =l_edc.edc04  
      LET l_edg.edg05 =l_edc.edc05  
      LET l_edg.edg06 =l_edc.edc06  
      LET l_edg.edg07 =l_edc.edc07  
      LET l_edg.edg08 =l_edc.edc08  
      LET l_edg.edg09 =l_edc.edc09  
      LET l_edg.edg10 =l_edc.edc10    
      LET l_edg.edg12 =l_edc.edc12  
      LET l_edg.edg121=l_edc.edc121 
      LET l_edg.edg13 =l_edc.edc13  
      LET l_edg.edg14 =l_edc.edc14  
      LET l_edg.edg15 =l_edc.edc15  
      LET l_edg.edg16 =l_edc.edc16  
      LET l_edg.edg17 =l_edc.edc17  
      LET l_edg.edg18 =l_edc.edc18  
      LET l_edg.edg19 =l_edc.edc19  
      LET l_edg.edg20 =l_edc.edc20  
      LET l_edg.edg21 =l_edc.edc21  
      LET l_edg.edg22 =l_edc.edc22  
      LET l_edg.edg23 =l_edc.edc23  
      LET l_edg.edg24 =l_edc.edc24  
      LET l_edg.edg25 =l_edc.edc25  
      LET l_edg.edg26 =l_edc.edc26  
      LET l_edg.edg27 =l_edc.edc27  
      LET l_edg.edg28 =l_edc.edc28  
      LET l_edg.edg291=l_edc.edc291 
      LET l_edg.edg292=l_edc.edc292 
      LET l_edg.edg301=l_edc.edc301 
      LET l_edg.edg302=l_edc.edc302 
      LET l_edg.edg303=l_edc.edc303 
      LET l_edg.edg311=l_edc.edc311 
      LET l_edg.edg312=l_edc.edc312 
      LET l_edg.edg313=l_edc.edc313 
      LET l_edg.edg314=l_edc.edc314 
      LET l_edg.edg315=l_edc.edc315 
      LET l_edg.edg316=l_edc.edc316 
      LET l_edg.edg321=l_edc.edc321 
      LET l_edg.edg322=l_edc.edc322 
      LET l_edg.edg34 =l_edc.edc34  
      LET l_edg.edg35 =l_edc.edc35  
      LET l_edg.edg36 =l_edc.edc36  
      LET l_edg.edg37 =l_edc.edc37  
      LET l_edg.edg38 =l_edc.edc38  
      LET l_edg.edg39 =l_edc.edc39  
      LET l_edg.edg40 =l_edc.edc40
      #MOD-E40116-Start-Add
      IF cl_null(l_edg.edg40) THEN
         LET l_edg.edg40 =0
      END IF     
      #MOD-E40116-End-Add
      LET l_edg.edg41 =l_edc.edc41  
      LET l_edg.edg42 =l_edc.edc42  
      LET l_edg.edg43 =l_edc.edc43  
      LET l_edg.edg45 =l_edc.edc45  
      LET l_edg.edg49 =l_edc.edc49  
     #LET l_edg.edg50 =l_edc.edc50  #FUN-A80060
     #LET l_edg.edg51 =l_edc.edc51  #FUN-A80060
      LET l_edg.edg52 =l_edc.edc52  
      LET l_edg.edg53 =l_edc.edc53  
      LET l_edg.edg54 =l_edc.edc54  
      LET l_edg.edg55 =l_edc.edc55  
      LET l_edg.edg56 =l_edc.edc56  
      LET l_edg.edg57 =l_edc.edc57  
      LET l_edg.edg58 =l_edc.edc58  
      LET l_edg.edg59 =l_edc.edc59  
      LET l_edg.edg60 =l_edc.edc60  
      LET l_edg.edg61 =l_edc.edc61  
      LET l_edg.edg62 =l_edc.edc62  
      LET l_edg.edg63 =l_edc.edc63  
      LET l_edg.edg64 =l_edc.edc64  
      LET l_edg.edg65 =l_edc.edc65  
      LET l_edg.edg66 =l_edc.edc66  
      LET l_edg.edg67 =l_edc.edc67  
      LET l_edg.edgslk01=l_edc.edcslk01
      LET l_edg.edgslk02=l_edc.edcslk02
      LET l_edg.edgslk03=l_edc.edcslk03
      LET l_edg.edgslk04=l_edc.edcslk04 
      LET l_edg.edgconf='N'
      LET l_edg.edguser=g_user
      LET l_edg.edgdate=g_today
      LET l_edg.edgacti='Y'
      LET l_edg.edgmodu=null
      LET l_edg.edggrup=g_grup
      LET l_edg.edgorig=g_grup
      LET l_edg.edgoriu=g_user
      
      SELECT sfb05,sfb06,sfb13,sfb15                  #FUN-A80060
        INTO l_edg.edg031,l_edg.edg11,l_sfb13,l_sfb15 #FUN-A80060  
        FROM sfb_file
       WHERE sfb01=p_sfd03
       #FUN-A80060--begin--add----------------
      IF NOT cl_null(l_sfb13) AND cl_null(l_sfb15) THEN
         LET w_day=(l_edg.edg14+l_edg.edg13)/86400 +0.99    # 一天86400秒
         CALL s_wknxt(l_sfb13,w_day) RETURNING w_flag,w_edate
         IF w_day != 0 THEN
            CALL s_wknxt(w_edate,-1) RETURNING w_flag,p_duedat
         ELSE
            CALL s_wknxt(w_edate,0) RETURNING w_flag,p_duedat
         END IF
         LET l_edg.edg50=l_sfb13  LET l_edg.edg51=p_duedat
      ELSE
         LET w_day=((l_edg.edg14+l_edg.edg13)/86400 +0.99)*-1    # 一天86400秒
         CALL s_wknxt(l_sfb15,w_day) RETURNING w_flag,w_bdate
         IF w_day != 0 THEN
            CALL s_wknxt(w_bdate,1) RETURNING w_flag,p_strtdat
         ELSE
            CALL s_wknxt(w_bdate,0) RETURNING w_flag,p_strtdat
         END IF
         LET l_edg.edg50=p_strtdat  LET l_edg.edg51=l_sfb15
      END IF
      #FUN-A80060--end--add--------------------
      INSERT INTO edg_file VALUES l_edg.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('ins edg',SQLCA.sqlcode,1)
         LET g_success='N' EXIT FOREACH
      END IF          
    END FOREACH
END FUNCTION    
                
FUNCTION p002_ins_edh(p_sfd01,p_sfd02,p_edc01,p_edc02)
DEFINE p_sfd01    LIKE sfd_file.sfd01
DEFINE p_sfd02    LIKE sfd_file.sfd02
DEFINE p_edc01    LIKE edc_file.edc01
DEFINE p_edc02    LIKE edc_file.edc02
DEFINE l_edh      RECORD LIKE edh_file.*
DEFINE l_edd      RECORD LIKE edd_file.*

  DECLARE edd_cs CURSOR FOR
     SELECT * FROM edd_file WHERE edd01=p_edc01 AND edd011=p_edc02 ORDER BY edd013,edd02
  FOREACH edd_cs INTO l_edd.*
    LET l_edh.edh01=p_sfd01
    LET l_edh.edh011=p_sfd02
    LET l_edh.edh013=l_edd.edd013
    LET l_edh.edh02 =l_edd.edd02 
    LET l_edh.edh03 =l_edd.edd03 
    LET l_edh.edh04 =l_edd.edd04 
    LET l_edh.edh05 =l_edd.edd05 
    LET l_edh.edh06 =l_edd.edd06 
    LET l_edh.edh07 =l_edd.edd07 
    LET l_edh.edh08 =l_edd.edd08 
    LET l_edh.edh081=l_edd.edd081
    LET l_edh.edh082=l_edd.edd082
    LET l_edh.edh09 =l_edd.edd09 
    LET l_edh.edh10 =l_edd.edd10 
    LET l_edh.edh11 =l_edd.edd11 
    LET l_edh.edh13 =l_edd.edd13 
    LET l_edh.edh14 =l_edd.edd14 
    LET l_edh.edh15 =l_edd.edd15 
    LET l_edh.edh16 =l_edd.edd16 
    LET l_edh.edh17 =l_edd.edd17 
    LET l_edh.edh18 =l_edd.edd18 
    LET l_edh.edh19 =l_edd.edd19 
    LET l_edh.edh20 =l_edd.edd20 
    LET l_edh.edh21 =l_edd.edd21 
    LET l_edh.edh22 =l_edd.edd22 
    LET l_edh.edh23 =l_edd.edd23 
    LET l_edh.edh24 =l_edd.edd24 
    LET l_edh.edh25 =l_edd.edd25 
    LET l_edh.edh26 =l_edd.edd26 
    LET l_edh.edh27 =l_edd.edd27 
    LET l_edh.edh28 =l_edd.edd28 
    LET l_edh.edh29 =l_edd.edd29 
    LET l_edh.edh30 =l_edd.edd30 
    LET l_edh.edh31 =l_edd.edd31 
    LET l_edh.edh33 =l_edd.edd33 
    LET l_edh.edh10_fac=l_edd.edd10_fac
    LET l_edh.edh10_fac2=l_edd.edd10_fac2
    LET l_edh.edhcomm=l_edd.eddcomm
    LET l_edh.edhmodu=NULL
    LET l_edh.edhdate=g_today
    INSERT INTO edh_file VALUES l_edh.*
    IF SQLCA.sqlcode THEN
       CALL cl_err('ins edh',SQLCA.sqlcode,1)
       LET g_success='N' EXIT FOREACH
    END IF 
  END FOREACH
END FUNCTION
#FUN-A80054--end--add------------------------
#No.FUN-9C0072 精簡程式碼
 
FUNCTION p002_chk_edb(p_edc01,p_new_part,p_sfb06)
DEFINE l_cnt      LIKE type_file.num5
DEFINE p_edc01    LIKE edc_file.edc01
DEFINE p_sfb06    LIKE sfb_file.sfb06
DEFINE p_new_part LIKE ima_file.ima01
 
  LET g_errno=''
  LET l_cnt=0
  IF NOT cl_null(p_edc01) AND NOT cl_null(p_new_part) AND
     NOT cl_null(p_sfb06) THEN
     SELECT COUNT(*) INTO l_cnt FROM eda_file,edb_file
      WHERE eda01=p_edc01
        AND edb03=p_new_part
        AND edb04=p_sfb06
        AND eda01=edb01 AND edaconf='Y'
     IF l_cnt = 0 THEN
        LET g_errno='aec-057'
     END IF
  END IF
END FUNCTION

#CHI-C50029 str add-----
FUNCTION p002_chk_sfb39(l_sfb01)
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_cnt2     LIKE type_file.num5
DEFINE l_sfb01    LIKE sfb_file.sfb01
DEFINE l_sfb01_2  LIKE sfb_file.sfb01

  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt FROM sfa_file
   WHERE sfa01  = l_sfb01
     AND sfa11 = 'E'                     
  IF l_cnt > 0 THEN                      
    UPDATE sfb_file SET sfb39='2' WHERE sfb01=l_sfb01
  END IF

  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt FROM sfb_file
   WHERE sfb86  = l_sfb01

  IF l_cnt>0 THEN
    DECLARE p304_cur1 CURSOR FOR
       SELECT sfb01 FROM sfb_file WHERE sfb86  = l_sfb01

    FOREACH p304_cur1 INTO l_sfb01_2
       LET l_cnt2=0
       SELECT COUNT(*) INTO l_cnt2 FROM sfa_file
        WHERE sfa01  = l_sfb01_2
          AND sfa11  = 'E'   
       IF l_cnt2 > 0 THEN     
         UPDATE sfb_file SET sfb39='2' WHERE sfb01=l_sfb01_2
       END IF
    END FOREACH
  END IF

END FUNCTION

FUNCTION p002_sub_no(p_no,p_min_no,p_max_no)
   DEFINE   p_no        LIKE sfb_file.sfb01
   DEFINE   p_min_no    LIKE sfb_file.sfb01      
   DEFINE   p_max_no    LIKE sfb_file.sfb01       
   DEFINE   l_sub_no    LIKE sfb_file.sfb01
   DEFINE   l_min_no    LIKE sfb_file.sfb01
   DEFINE   l_max_no    LIKE sfb_file.sfb01        
   DEFINE   l_n         LIKE type_file.num5
   DEFINE   l_sql       STRING

   LET l_min_no = p_min_no
   LET l_max_no = p_max_no
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM sfb_file
    WHERE sfb86 = p_no
   IF l_n = 0 THEN RETURN l_min_no,l_max_no END IF 

   LET l_sql = "SELECT sfb01 FROM sfb_file ",
           " WHERE sfb86 = '", p_no ,"' "
   PREPARE q_sfb_prepare FROM l_sql
   #M001 171117 By TSD.Nic -----(S)
   #DECLARE sfb_curs CURSOR FOR q_sfb_prepare 
   DECLARE sfb_curs CURSOR WITH HOLD FOR q_sfb_prepare 
   #M001 171117 By TSD.Nic -----(E)
   FOREACH sfb_curs INTO l_sub_no
      IF SQLCA.sqlcode THEN
         RETURN l_min_no,l_max_no
      END IF
      IF cl_null(l_max_no) THEN LET l_max_no = ' ' END IF    
      IF l_sub_no > l_max_no THEN LET l_max_no = l_sub_no END IF
      IF cl_null(l_min_no) THEN LET l_min_no = l_max_no END IF    
      IF l_sub_no < l_min_no THEN LET l_min_no = l_sub_no END IF
      #母工單只會有一圈不用遞迴
      #CALL p002_sub_no(l_sub_no,l_min_no,l_max_no) RETURNING l_min_no,l_max_no  #遞歸查詢各級子工單
      LET g_wos = g_wos,"','",l_sub_no CLIPPED

   END FOREACH
   RETURN l_min_no,l_max_no
END FUNCTION
#TQC-C70002--add--end--

#TQC-C70104--add--str--
FUNCTION p002_set_entry_b()
   CALL cl_set_comp_entry("sfb06",TRUE)
END FUNCTION

FUNCTION p002_set_no_entry_b(p_i)
   DEFINE p_i       LIKE type_file.num5
   DEFINE i         LIKE type_file.num5

   LET i = p_i
   IF new[i].sfb93 <> 'Y' THEN
      CALL cl_set_comp_entry("sfb06",FALSE)
   END IF
END FUNCTION

FUNCTION p002_set_no_required_b()
   CALL cl_set_comp_required("sfb06,new_no",FALSE)
   IF g_aaz.aaz90 = 'Y' THEN
      CALL cl_set_comp_required("costcenter",FALSE)
   END IF
END FUNCTION

FUNCTION p002_set_required_b(p_i)
   DEFINE p_i       LIKE type_file.num5
   DEFINE i         LIKE type_file.num5

   LET i = p_i
   IF new[i].x = 'Y' THEN
      IF new[i].sfb93 = 'Y' THEN
         CALL cl_set_comp_required("sfb06",TRUE)
      END IF
      IF g_aaz.aaz90 = 'Y' THEN
         CALL cl_set_comp_required("costcenter",TRUE)
      END IF
      CALL cl_set_comp_required("new_no",TRUE)
   END IF 
END FUNCTION
#TQC-C70104--add--end--



#M001 171116 By TSD.Nic -----(S)
#pmk default
FUNCTION p002_pmk_default()
   LET g_pmk.pmk01 = NULL
   LET g_pmk.pmk04 = g_today               #請購日期

   SELECT azn02,azn04 INTO g_pmk.pmk31,g_pmk.pmk32 FROM azn_file
    WHERE azn01 = g_pmk.pmk04
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","azn_file",g_pmk.pmk04,"","mfg0027","","",1)
      LET g_pmk.pmk04 = ''
      DISPLAY BY NAME g_pmk.pmk04
   END IF
   CALL s_get_bookno(YEAR(g_pmk.pmk04))
        RETURNING g_flag,g_bookno1,g_bookno2

   LET g_pmk.pmk02 = 'REG'       #單號性質
   LET g_pmk.pmk03 = '0'
   LET g_pmk.pmk12 = g_user
   LET g_pmk.pmk13 = g_grup
   LET g_pmk.pmk18 = 'N'
   LET g_pmk.pmk25 = '0'         #開立
   LET g_pmk.pmk27 = g_today
   LET g_pmk.pmk40 = 0           #總金額
   LET g_pmk.pmk401= 0           #總金額
   LET g_pmk.pmk43 = 0           #稅率
   LET g_pmk.pmk45 = 'Y'         #可用
   LET g_pmk.pmkdays = 0         #簽核天數
   LET g_pmk.pmkprno = 0         #列印次數
   LET g_pmk.pmksmax = 0         #己簽順序
   LET g_pmk.pmksseq = 0         #應簽順序
   LET g_pmk.pmk05   =''
   LET g_pmk.pmk12   = g_user               #請購員
   LET g_pmk.pmkplant = g_plant
   LET g_pmk.pmklegal = g_legal
   LET g_pmk.pmk46 = '1'
   LET g_pmk.pmk47 = g_plant
   LET g_pmk.pmk50 = null
   LET g_pmk.pmk48 = TIME
   LET g_pmk.pmkacti ='Y'                   #有效的資料
   LET g_pmk.pmkuser = g_user
   LET g_pmk.pmkoriu = g_user
   LET g_pmk.pmkorig = g_grup
   LET g_data_plant = g_plant
   LET g_pmk.pmkgrup = g_grup               #使用者所屬群
   LET g_pmk.pmkcrat = g_today           #資料創建日
   LET g_pmk.pmkplant = g_plant
   LET g_pmk.pmklegal = g_legal
   LET g_pmk.pmkud03 = 'N'               #20190814 BPM是否加簽
END FUNCTION

#INSERT INTO pmk_file
FUNCTION p002_ins_pmk()
   DEFINE  l_smyauno     LIKE smy_file.smyauno
   DEFINE  l_smyapr      LIKE smy_file.smyapr
   DEFINE  l_smy59       LIKE smy_file.smy59
   DEFINE  li_result     LIKE type_file.num5
   DEFINE  l_slip        LIKE smy_file.smyslip

   LET l_slip = s_get_doc_no(g_pmk.pmk01)
   LET l_smyauno = ''
   LET l_smyapr  = ''
   LET l_smy59   = ''
   SELECT smyauno,smyapr,smy59
     INTO l_smyauno,l_smyapr,l_smy59
     FROM smy_file
    WHERE smyslip = l_slip

   IF l_smyauno='Y' THEN
   CALL s_auto_assign_no("apm",g_pmk.pmk01,g_pmk.pmk04,"1","pmk_file","pmk01","","","") RETURNING li_result,g_pmk.pmk01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
   END IF
   IF cl_null(g_pmk.pmkmksg) THEN
      LET  g_pmk.pmkmksg = l_smyapr
   END IF
   IF cl_null(g_pmk.pmkmksg) THEN
      LET  g_pmk.pmkmksg = 'N'
   END IF

  IF cl_null(g_pmk.pmk46) THEN
     LET g_pmk.pmk46 = '1'
  END IF

   IF l_smy59 = 'Y' AND cl_null(g_pmk.pmk22) THEN
      LET g_pmk.pmk22 = g_aza.aza17
      LET g_pmk.pmk42 = 1
   END IF

   INSERT INTO pmk_file VALUES(g_pmk.*)     #DISK WRITE
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pmk_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   ELSE
      IF NOT s_axm_memo_ins_pmo(g_pmk.pmk01,g_pmk.pmk09,'0') THEN
         LET g_success = 'N'
         RETURN
      END IF

      CALL cl_flow_notify(g_pmk.pmk01,'I')
      SELECT pmk01 INTO g_pmk.pmk01 FROM pmk_file
       WHERE pmk01 = g_pmk.pmk01
   END IF
END FUNCTION

#INSERT INTO pnl_file
FUNCTION p002_ins_pnl()
   DEFINE l_maxd       LIKE sfb_file.sfb13
   DEFINE l_mind       LIKE sfb_file.sfb13
   DEFINE l_sql        STRING
   DEFINE l_wc         LIKE pnl_file.pnl02    

   LET l_maxd = ''
   LET l_mind = ''
   LET l_sql = "SELECT MAX(sfb13),MIN(sfb13) ",              
               "  FROM sfb_file,sfa_file ",
               " WHERE sfa01 = sfb01 ",
               "   AND ",g_wos CLIPPED
               
   PREPARE dates_exe FROM l_sql
   EXECUTE dates_exe INTO l_maxd,l_mind

   LET l_wc = g_wos

   DELETE FROM pnl_file WHERE pnl01 = g_pmk.pmk01
   IF SQLCA.sqlcode THEN END IF
   INSERT INTO pnl_file(pnl01,pnl02,pnl03,pnl04,pnl05,
                        pnl06,pnl07,pnl08,pnl09,pnl10,pnl11,pnluser,pnlplant,pnllegal,pnloriu,pnlorig)
                 VALUES(g_pmk.pmk01,l_wc,l_mind,l_maxd,
                       
                        'N','N','N','N',
                        'N','N','N',g_user,g_plant,g_legal, g_user, g_grup)
                       
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pnl_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
#M001 171116 By TSD.Nic -----(E)
