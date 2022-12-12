# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cqcp002.4gl
# Descriptions...: 收貨整批產生QC單作業
# Date & Author..: FUN-A80064 10/08/11 By houlia
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.MOD-AC0319 10/12/28 By chenying 點擊QC鈕沒有反應
# Modify.........: No.MOD-AC0311 11/01/04 By lixh1 不能自動產生IQC自動檢驗單   
# Modify.........: No.TQC-B10188 11/01/20 By lilingyu g_argv1欄位長度定義過段,導致根傳進來的參數選不出資料
# Modify.........: No.MOD-B30406 11/03/15 By baogc 修改QC單據已經產生的報錯信息
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B70290 11/07/30 By suncx l_qcs22赋值不正确，l_rate類型定義錯誤
# Modify.........: No:MOD-B70274 11/08/18 By Vampire  未給予確認日期欄位(qcs15)產生時間
# Modify.........: No:TQC-B90236 11/11/09 By zhuhao 新增欄位"依製造批號拆分不同QC單",增加CURSOR.
# Modify.........: No.FUN-BB0085 11/12/13 By xianghui 增加數量欄位小數取位
# Modify.........: No:MOD-BA0036 12/02/03 By Summer 產生單頭檔時qcs17沒有值,導致後續抓檢驗量時抓不到 
# Modify.........: No:MOD-BB0073 12/02/17 By bart 產生單身資料變數給值前應先給初始值
# Modify.........: No:TQC-C30012 12/03/03 By yuhuabao 沒勾依製造批號拆分qc單時，qc單的資料沒有產生
#                                                     有勾依製造批號拆分qc單時，qc單的數量不對，且也沒依製造批號拆分
# Modify.........: No:MOD-C30307 12/03/12 By zhuhao 根據是否有參數傳入判斷 是否開啟畫面 
# Modify.........: No:MOD-C30382 12/03/13 By dongsz 檢查QC單是否重覆時，排除掉作廢的單
# Modify.........: No:FUN-C30064 12/06/08 By bart 成功產生QC單後顯示單號
# Modify.........: No:MOD-C70225 12/07/23 By ck2yuan 給l_ecm04 & l_type預設值
# Modify.........: No:MOD-C70226 12/07/23 By ck2yuan CHI-B90064修改saqct110,這邊對應地方也應該修改
# Modify.........: No:MOD-C90134 12/09/20 By Elise 修改sql
# Modify.........: No:MOD-CC0009 12/01/17 By Carrier 单一单位时,不重算qcs32的值
# Modify.........: No:MOD-D20123 13/03/08 By Elise (1) 修正變數帶錯
#                                                  (2) 將 l_ima101 修改為 g_ima101
# Modify.........: No:MOD-D40169 13/04/22 By Vampire 調整級數1916檢驗方式
# Modify.........: No:DEV-D40021 13/04/24 By TSD.sophy 若維條碼料件，不自動產生rvbs_file的資料
# Modify.........: No:FUN-D10004 13/06/20 By jt_chen 有用到pmh_file的SQL條件需增加判斷廠牌pmh07
# Modify.........: No:MOD-D70179 13/07/29 By jt_chen 透過整批產生QC單,應跟單身輸入方式相同，統一皆只能特採
# Modify.........: No:MOD-D80012 13/08/05 By jt_chen t110_defqty() 撈 qdg_file 時卻使用 aimi103 檢驗水準的設定,以致帶出的檢驗數量為0。
# Modify.........: No:MOD-D80053 13/08/12 By jt_chen 因MOD-B80091 mark 起來後,會造成抓到多筆;調整：1.mark MOD-B80091 的調整。2.cqcp002 邏輯也需一致
# Modify.........: No:MOD-D80081 13/08/15 By jt_chen 調整級數1916檢驗方式
# Modify.........: No:MOD-DA0168 13/10/25 By Vampire 1. 還原 MOD-D80053 修改；2. 將 UNIQUE 改為 DISTINCT。
# Modify.........: No:MOD-DB0022 13/10/25 By Vampire 調整 MOD-DA0168 SQL 語法。 
# Modify.........: No:MOD-E40146 14/04/25 By Reanna 修正l_qcs03_t未給值的問題
# Modify.........: No:CHI-E60021 14/06/25 By Mandy (1)p001_defqty()內,檢驗水準為"1916"時,回饋的抽樣數量(檢驗量qct11)異常
#                                                  (2)pmh_cur2 CURSOR 其SQL使用的l_type變數混淆
# Modify.........: No:MOD-E60119 14/06/27 By Mandy MOD-D80081版號將CALL p001_defqty()內的第三個參數改為g_qcs.qcs17,
#                                                  但是程式當檢驗水準為"1:一般"時漏改,但應無影響,為了程式的一致性還是統一都改掉
# Modify.........: No:MOD-E90097 14/09/24 By liliwen asms250參數[採購入庫允收數量與IQC勾稽]有勾選時才可執行
# Modify.........: No:MOD-G80087 16/08/18 By fionchen 調整l_qty參數宣告為type_file.num10 

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"    #FUN-A80064
 
DEFINE tm RECORD
            wc        LIKE type_file.chr1000,    
            qc        LIKE type_file.chr1     #TQC-B90236
          END RECORD 
DEFINE  
      l_sql      LIKE type_file.chr1000,  
      l_sql1     STRING,
      l_rva         RECORD LIKE rva_file.*,
      l_rvb         RECORD LIKE rvb_file.*,
      l_rvbs        RECORD LIKE rvbs_file.*,    #TQC-B90236
      l_qcs         RECORD LIKE qcs_file.*,
      l_qcd         RECORD LIKE qcd_file.*,
      l_pmm         RECORD LIKE pmm_file.*,
      l_pmn         RECORD LIKE pmn_file.*,
      l_type     LIKE type_file.chr20,     
      l_correct  LIKE type_file.chr1,     
      l_do       LIKE type_file.chr1 
#DEFINE l_qty     LIKE pmn_file.pmn50     #MOD-G80087 mark
DEFINE l_qty     LIKE type_file.num10     #MOD-G80087 add
DEFINE l_qdf02   LIKE qdf_file.qdf02
DEFINE l_qcs22   LIKE qcs_file.qcs22
DEFINE l_ecm04   LIKE ecm_file.ecm04
DEFINE l_qcd03   LIKE qcd_file.qcd03
DEFINE l_qcd05   LIKE qcd_file.qcd05
DEFINE l_qcs01        LIKE qcs_file.qcs01
DEFINE l_qcs02        LIKE qcs_file.qcs02
DEFINE l_qcs021       LIKE qcs_file.qcs021
DEFINE l_qcs03        LIKE qcs_file.qcs03
DEFINE l_qcs04        LIKE qcs_file.qcs04
DEFINE p_row,p_col    LIKE type_file.num5       
DEFINE g_flag         LIKE type_file.chr1       
DEFINE l_k            LIKE type_file.num5       
DEFINE g_argv1        LIKE type_file.chr30                 #TQC-B10188 chr18->chr30       
DEFINE l_flag         LIKE type_file.chr1,      
       g_change_lang  LIKE type_file.chr1,      
       ls_date        STRING,                   
       g_chkno        LIKE pmm_file.pmm01       
DEFINE g_ima101       LIKE ima_file.ima101 #MOD-D20123 add
DEFINE l_tc_evae03    LIKE tc_evae_file.tc_evae03          #模具零件料號 20221003
DEFINE l_tc_evae01    LIKE tc_evae_file.tc_evae01          #模具編號     20221003
DEFINE lc_cmd        LIKE type_file.chr1000    

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                
 
   LET g_argv1=ARG_VAL(1)
   INITIALIZE g_bgjob_msgfile TO NULL
#  LET tm.wc     = ARG_VAL(1)
   LET g_bgjob = ARG_VAL(2)
 
   IF cl_null(g_bgjob) THEN
      LET g_bgjob= "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  #MOD-C30307 -- add -- begin
   IF cl_null(g_argv1) THEN
      WHENEVER ERROR CALL cl_err_msg_log
   END IF
  #MOD-C30307 -- add -- end
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
  #MOD-E90097 add str
   IF g_sma.sma886[8,8]!='Y' THEN
      CALL cl_err('','aqc1020',1)
      EXIT PROGRAM
   END IF
  #MOD-E90097 add end
 
     CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   WHILE TRUE
      LET g_success = 'Y'
      IF NOT cl_null(g_argv1) THEN 
         CALL p001_cs()
         CALL p001_chk()
         IF g_success = 'Y' THEN
            EXIT WHILE
         ELSE
            EXIT WHILE
         END IF  
      ELSE   
         IF g_bgjob= "N" THEN
            CALL p001_cs()
            IF cl_sure(18,20) THEN
               BEGIN WORK
               LET g_success = 'Y'
               CALL p001_chk()
               CALL s_showmsg()       
               IF g_success = 'Y' AND l_k = 1 THEN
                  CALL cl_end2(1) RETURNING l_flag
               ELSE
                  ROLLBACK WORK
                  CALL cl_end2(2) RETURNING l_flag
               END IF
               IF l_flag THEN
                  CONTINUE WHILE
               ELSE
                  CLOSE WINDOW p001_w
                  EXIT WHILE
               END IF
            ELSE
               CONTINUE WHILE
            END IF
            CLOSE WINDOW p001_w
         ELSE
            BEGIN WORK
            LET g_success = 'Y'
            CALL p001_chk()
            CALL s_showmsg()       
            IF g_success = "Y" THEN
               COMMIT WORK
            ELSE
               ROLLBACK WORK
            END IF
            EXIT WHILE
         END IF
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p001_cs()
   DEFINE lc_cmd        LIKE type_file.chr1000    
 
   IF cl_null(g_argv1) THEN      #MOD-C30307 add
      LET p_row = 3 LET p_col = 15
      OPEN WINDOW p001_w AT p_row,p_col WITH FORM "aqc/42f/aqcp001"
           ATTRIBUTE (STYLE = g_win_style)
      IF g_sma.sma90='Y' THEN
         CALL cl_set_comp_visible("Group1,qc",TRUE)
      ELSE
         CALL cl_set_comp_visible("Group1,qc",FALSE)
      END IF
 
      CALL cl_ui_init()
   END IF                        #MOD-C30307 add
   WHILE TRUE
      INITIALIZE tm.* TO NULL
      IF NOT cl_null(g_argv1) THEN
         LET tm.wc = "rva01='",g_argv1,"'"
      ELSE
         CONSTRUCT BY NAME tm.wc ON rva01,rva06,qcs02,qcs03, qcs021 
    
            BEFORE CONSTRUCT
                CALL cl_qbe_init()
 
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(rva01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rva01_1"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rva01
                     NEXT FIELD rva01
                  WHEN INFIELD(qcs03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_qcs03"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO qcs03
                     NEXT FIELD qcs03
                  WHEN INFIELD(qcs021)        
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_qcs021"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(TRUE, "q_qcs021","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                     DISPLAY g_qryparam.multiret TO qcs021
                     NEXT FIELD qcs021
                   OTHERWISE EXIT CASE
               END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG 
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         ON ACTION about
            CALL cl_about()
         ON ACTION help
            CALL cl_show_help()
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT CONSTRUCT
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
         ON ACTION qbe_save
            CALL cl_qbe_save()
   END CONSTRUCT
#TQC-B90236-----------add----begin-------
   LET tm.qc = 'N'
   DISPLAY tm.qc TO qc
   INPUT BY NAME tm.qc WITHOUT DEFAULTS
      AFTER FIELD qc
         IF tm.qc NOT MATCHES "[YN]" THEN
            NEXT FIELD qc
         END IF
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
      ON ACTION about
         CALL cl_about()
      ON ACTION help
         CALL cl_show_help()
      ON ACTION locale
         LET g_change_lang = TRUE
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT
#TQC-B90236----------add----end-----------
END IF 
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()  
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p001_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
      EXIT PROGRAM
   END IF
 
    LET g_bgjob = "N"          
    LET g_flag = 'N'           
    LET g_chkno = NULL       
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()  
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p001_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
      EXIT PROGRAM
   END IF
 
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "cqcp002"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('cqcp002','9031',1)   
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.wc CLIPPED ,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('cqcp002',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p001_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
   EXIT WHILE
 END WHILE
 
END FUNCTION
 
FUNCTION p001_chk()  
DEFINE l_ima906  LIKE ima_file.ima906  
DEFINE l_yn      LIKE type_file.num5    
DEFINE l_cnt     LIKE type_file.num5       
DEFINE l_ac_num  LIKE type_file.num5
DEFINE l_re_num  LIKE type_file.num5 
DEFINE l_qct11   LIKE qct_file.qct11
DEFINE l_qct14   LIKE qct_file.qct14
DEFINE l_qct15   LIKE qct_file.qct15
DEFINE l_q       LIKE qcs_file.qcs22
#DEFINE l_ima101  LIKE ima_file.ima101  #MOD-D20123 mark
DEFINE l_qcs03_t  LIKE qcs_file.qcs03 
DEFINE seq        LIKE qct_file.qct07 
DEFINE l_s        LIKE type_file.chr1 
DEFINE l_n        LIKE type_file.chr1 
DEFINE l_m        LIKE type_file.chr1 
DEFINE l_t        LIKE type_file.chr1 
DEFINE l_ima918   LIKE ima_file.ima918       #TQC-B90236 
DEFINE l_ima921   LIKE ima_file.ima921       #TQC-B90236
DEFINE l_rvbs04   LIKE rvbs_file.rvbs04      #TQC-B90236
DEFINE l_rvbs06   LIKE rvbs_file.rvbs06      #TQC-B90236
DEFINE l_rvbs06s  LIKE rvbs_file.rvbs06      #TQC-B90236
DEFINE l_qcs22s   LIKE qcs_file.qcs22        #TQC-B90236
DEFINE l_ima44    LIKE ima_file.ima44        #FUN-BB0085
DEFINE l_str      STRING   #FUN-C30064
DEFINE l_ima930   LIKE ima_file.ima930   #DEV-D40021 --add
   
   LET l_sql ="SELECT * FROM rva_file  ",
              " WHERE rvaconf='Y' ",
              "   AND ",tm.wc CLIPPED 
   PREPARE p001_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p1 error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_c1 CURSOR FOR p001_p1
   
   LET l_sql1 ="SELECT rvb_file.*,tc_evae03,tc_evae01 FROM rvb_file  ",
               " INNER JOIN tc_evae_file ON tc_evae05=rvb04 AND tc_evae06=rvb03 ",  #20221003
               " INNER JOIN tc_evad_file ON tc_evad01 = tc_evae01 ",
               " WHERE rvb01=? and rvb19='1' ",
               "   AND tc_evadacti='Y' "
   PREPARE p001_p11 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p11 error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_c11 CURSOR FOR p001_p11

#No.TQC-B90236----add--begin----------   
   LET l_sql1 ="SELECT * FROM rvbs_file  ",
               " WHERE  rvbs01 = ? AND rvbs02=? AND rvbs09=1 ",   #TQC-C30012 modify and -> where
               "   AND rvbs13 = 0 AND rvbs00[1,7] <>'aqct110' "
   PREPARE p001_p11a FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p11a error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_rvbs CURSOR FOR p001_p11a

   LET l_sql1 ="SELECT rvbs04,SUM(rvbs06) FROM rvbs_file  ",
               " WHERE rvbs01 = ? AND rvbs02=? AND rvbs09=1 AND rvbs13 = 0 ",  #TQC-C30012 modify and -> where
               "   AND rvbs00[1,7] <>'aqct110'  GROUP BY rvbs04"
   PREPARE p001_p11b FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p11b error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_rvbs1 CURSOR FOR p001_p11b

   LET l_sql1 ="SELECT * FROM rvbs_file  ",
               " WHERE  rvbs01 = ? AND rvbs02=? AND rvbs04=? AND rvbs09=1 ",   #TQC-C30012 modify and -> where
               "   AND rvbs13 = 0 AND rvbs00[1,7] <>'aqct110' "
   PREPARE p001_p11c FROM l_sql1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p001_p11c error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p001_rvbs2 CURSOR FOR p001_p11c

#No.TQC-B90236----add--end------------
   LET g_success = 'Y'
   CALL s_showmsg_init()

   LET l_s = 'N'
   LET l_str = NULL  #FUN-C30064
   FOREACH p001_c1 into l_rva.*
      FOREACH p001_c11 using l_rva.rva01 into l_rvb.*,l_tc_evae03,l_tc_evae01            #20221003

             LET l_rvb.rvb05 = l_tc_evae03   #20221003 
             LET l_qcs.qcs00 = '2'           #20221003

   #產生QC單頭資料
             LET l_m = 'Y'
             LET l_s = 'Y'
             LET l_qcs.qcs01 = l_rva.rva01
             LET l_qcs.qcs02 = l_rvb.rvb02
             LET l_qcs.qcs021 =l_rvb.rvb05
             LET l_qcs.qcs03 = l_rva.rva05
             LET l_qcs03_t = l_qcs.qcs03     #MOD-E40146
             LET l_qcs.qcs04 = g_today
             LET l_qcs.qcs041 = TIME
             LET l_qcs.qcs10 = l_tc_evae01
             #回寫收貨單需檢驗 20221026
             UPDATE rvb_file SET rvb39='Y',rvb40='',rvb41='',rvb33=0 
              WHERE rvb01 = l_rva.rva01 AND rvb02= l_rvb.rvb02
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","rvb_file",l_rvb.rvb02,"",STATUS,"","upd rvb39:",1)
                LET g_success = 'N'
             END IF

             SELECT pmm_file.*,pmn_file.* INTO l_pmm.*,l_pmn.* 
              FROM pmm_file,pmn_file
             WHERE pmm01=l_rvb.rvb04 AND pmn02=l_rvb.rvb03	
               AND pmm01=pmn01  #MOD-C90134 add
             										
             LET l_ecm04=' '     #MOD-C70225 add
             LET l_type='1'      #MOD-C70225 add

             
             SELECT pmn63 INTO l_qcs.qcs16                   
               FROM pmn_file 
               WHERE pmn01=l_rvb.rvb04 AND pmn02=l_rvb.rvb03								

             IF cl_null(l_pmn.pmn123) THEN LET l_pmn.pmn123 = ' ' END IF   #FUN-D10004 add
            
             SELECT pmh16 INTO l_qcs.qcs17
               FROM pmh_file 
              WHERE pmh01=l_qcs.qcs021 
             	AND pmh02=l_qcs.qcs03 
                AND pmh07=l_pmn.pmn123                           #FUN-D10004 add
             	AND pmh21=l_ecm04 
             	AND pmh22=l_type 
             	AND pmh23=' '

             SELECT pmh09 INTO l_qcs.qcs21
               FROM pmh_file 
              WHERE pmh01=l_qcs.qcs021 
             	AND pmh02=l_qcs.qcs03 
                AND pmh07=l_pmn.pmn123                           #FUN-D10004 add 
             	AND pmh21=l_ecm04 
             	AND pmh22=l_type 
             	AND pmh23=' '
             #MOD-BA0036 add --start--
             IF STATUS=100 OR cl_null(l_qcs.qcs21) OR cl_null(l_qcs.qcs17) THEN 
             SELECT pmc906,pmc907 INTO l_qcs.qcs21,l_qcs.qcs17
               FROM pmc_file
                WHERE pmc01 = l_qcs.qcs03

                IF STATUS=100 OR cl_null(l_qcs.qcs21) OR cl_null(l_qcs.qcs17) THEN 
                   SELECT ima100,ima102 INTO l_qcs.qcs21,l_qcs.qcs17
                      FROM ima_file WHERE ima01=l_qcs.qcs021
                   IF STATUS THEN
                      LET l_qcs.qcs21=' '
                      LET l_qcs.qcs17=' '
                   END IF
                END IF
             END IF
             #MOD-BA0036 add --end--

             LET l_qcs.qcs13 = g_user
             LET l_qcs.qcs14 = 'N'
             LET l_qcs.qcsspc ='0'
             LET l_qcs.qcsprno = 0
             LET l_qcs.qcsacti = 'Y'
             LET l_qcs.qcsuser = g_user
             LET l_qcs.qcsgrup = g_grup
             LET l_qcs.qcsdate = g_today
             LET l_qcs.qcsplant = g_plant
             LET l_qcs.qcslegal = g_legal
             LET l_qcs.qcsoriu = g_user
             LET l_qcs.qcsorig = g_grup
             LET l_qcs.qcs15 = ''                       #MOD-B70274 add
#No.TQC-B90236----add---begin-------
             SELECT ima918 INTO l_ima918 FROM ima_file
              WHERE ima01 = l_qcs.qcs021
             IF tm.qc='Y' AND l_ima918='Y' THEN
                FOREACH p001_rvbs1 USING l_qcs.qcs01,l_qcs.qcs02 INTO l_rvbs04,l_rvbs06    #依製造批號抓取資料
                    SELECT MAX(qcs05)+1 INTO l_qcs.qcs05 FROM qcs_file 
                     WHERE qcs01= l_rva.rva01 AND qcs02 = l_rvb.rvb02
                    IF cl_null(l_qcs.qcs05) THEN LET l_qcs.qcs05=1 END IF
                    #抓取已產生的資料
                    SELECT SUM(rvbs06) INTO l_rvbs06s FROM rvbs_file,qcs_file
                     WHERE qcs01 =l_qcs.qcs01
                       AND qcs02 =l_qcs.qcs02
                       AND rvbs13=qcs05
                       AND qcs01 = rvbs01
                       AND qcs02 = rvbs02
                       AND rvbs04 = l_rvbs04
                       AND rvbs00[1,7] = 'aqct110'
                       AND qcs14 !='X'
                       AND qcs00 = '1'
                       AND rvbs09 = 1
                    IF cl_null(l_rvbs06s) THEN
                       LET l_rvbs06s=0
                    END IF
                    LET l_qcs.qcs22 = (l_rvbs06- l_rvbs06s)/l_rvb.rvb90_fac  
                    IF l_qcs.qcs22 = 0 THEN
                       LET l_s = 'N'
                       CONTINUE FOREACH
                    END IF
                    
                    LET l_qcs22 = l_qcs.qcs22
                    LET l_qcs.qcs30 = l_rvb.rvb80
                    LET l_qcs.qcs31 = l_rvb.rvb81
                    LET l_qcs.qcs32 = l_rvb.rvb82
                    LET l_qcs.qcs33 = l_rvb.rvb83
                    LET l_qcs.qcs34 = l_rvb.rvb84
                    LET l_qcs.qcs35 = l_rvb.rvb85
                
                    SELECT ima906,ima44 INTO l_ima906,l_ima44 FROM ima_file    #FUN-BB0085  add ima44
                     WHERE ima01 = l_qcs.qcs021
                    IF l_ima906 = '3' THEN
                       LET l_qcs.qcs32 = l_qcs.qcs22
                       IF l_qcs.qcs34 <> 0 THEN
                          LET l_qcs.qcs35 = l_qcs.qcs22/l_qcs.qcs34
                       ELSE
                          LET l_qcs.qcs35 = 0
                       END IF
                    ELSE
                       IF l_ima906 = '2' AND NOT cl_null(l_qcs.qcs34) AND l_qcs.qcs34 <>0 THEN   #No.MOD-CC0009
                          LET l_qcs.qcs32 = l_qcs.qcs22 MOD l_qcs.qcs34
                          LET l_qcs.qcs35 = (l_qcs.qcs22 - l_qcs.qcs32) / l_qcs.qcs34
                       END IF#No.MOD-CC0009
                    END IF
                    LET l_qcs.qcs09 = '1'
                    LET l_qcs.qcs091 = l_qcs.qcs22
                    LET l_qcs.qcs36 = l_qcs.qcs30
                    LET l_qcs.qcs37 = l_qcs.qcs31
                    LET l_qcs.qcs38 = l_qcs.qcs32
                    LET l_qcs.qcs39 = l_qcs.qcs33
                    LET l_qcs.qcs40 = l_qcs.qcs34
                    LET l_qcs.qcs41 = l_qcs.qcs35
                    #FUN-BB0085-add-str--
                    LET l_qcs.qcs091= s_digqty(l_qcs.qcs091,l_ima44)
                    LET l_qcs.qcs22 = s_digqty(l_qcs.qcs22,l_ima44)
                    LET l_qcs.qcs32 = s_digqty(l_qcs.qcs32,l_qcs.qcs30)
                    LET l_qcs.qcs35 = s_digqty(l_qcs.qcs35,l_qcs.qcs33)
                    LET l_qcs.qcs38 = s_digqty(l_qcs.qcs38,l_qcs.qcs36)
                    LET l_qcs.qcs41 = s_digqty(l_qcs.qcs41,l_qcs.qcs39)
                    #FUN-BB0085-add-end--
                    CALL p001_chk_qcs09()   #MOD-D70179 add 
                    INSERT INTO qcs_file VALUES l_qcs.*
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("","","","",SQLCA.SQLCODE,"","",1)
                       LET g_success = 'N'
                       EXIT FOREACH
                    END IF
                    
                    #寫入批序號資料
                    FOREACH p001_rvbs2 USING l_qcs.qcs01,l_qcs.qcs02,l_rvbs04 INTO l_rvbs.*  #抓取批序號資料
                       #DEV-D40021 --add--str
                       LET l_ima930 = ''
                       SELECT ima930 INTO l_ima930 FROM ima_file 
                        WHERE ima01 = l_rvbs.rvbs021  
                       IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF 
                       IF l_ima930 = 'Y' THEN CONTINUE FOREACH END IF 
                       #DEV-D40021 --add--end
                       
                       #抓取已產生的資料
                       SELECT SUM(rvbs06) INTO l_rvbs06s FROM rvbs_file,qcs_file
                        WHERE qcs01 =l_qcs.qcs01
                          AND qcs02 =l_qcs.qcs02
                          AND rvbs13=qcs05
                          AND qcs01 = rvbs01
                          AND qcs02 = rvbs02
                          AND rvbs03 = l_rvbs.rvbs03
                          AND rvbs04 = l_rvbs.rvbs04
                          AND rvbs08 = l_rvbs.rvbs08
                          AND rvbs00[1,7] = 'aqct110'
                          AND qcs14 !='X'
                          AND qcs00 = '1'
                          AND rvbs09 = 1
                       IF cl_null(l_rvbs06s) THEN
                          LET l_rvbs06s=0
                       END IF
                       
                       LET l_rvbs.rvbs00 = 'aqct110'
                       LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs06s
                       LET l_rvbs.rvbs10 = 0
                       LET l_rvbs.rvbs11 = 0
                       LET l_rvbs.rvbs12 = 0
                       LET l_rvbs.rvbs13 = l_qcs.qcs05
                       LET l_rvbs.rvbsplant = g_plant
                       LET l_rvbs.rvbslegal = g_legal

                       INSERT INTO rvbs_file VALUES (l_rvbs.*)
                    END FOREACH
                END FOREACH
             ELSE    #不拆分
                SELECT MAX(qcs05)+1 INTO l_qcs.qcs05 FROM qcs_file
                 WHERE qcs01= l_rva.rva01 AND qcs02 = l_rvb.rvb02
                IF cl_null(l_qcs.qcs05) THEN LET l_qcs.qcs05=1 END IF

                SELECT SUM(qcs22) INTO l_qcs22s FROM qcs_file
                 WHERE qcs00='2' AND qcs01= l_rva.rva01
                   AND qcs02 = l_rvb.rvb02 AND qcs14 <>'X'
                   AND qcs021 = l_rvb.rvb05                      #20221003
                IF cl_null(l_qcs22s) THEN LET l_qcs22s = 0 END IF
                LET l_qcs.qcs22 = l_rvb.rvb07 - l_qcs22s
                IF l_qcs.qcs22 = 0 THEN
                   LET l_s = 'N'
                   CONTINUE FOREACH
                END IF

                LET l_qcs22 = l_qcs.qcs22
                LET l_qcs.qcs30 = l_rvb.rvb80
                LET l_qcs.qcs31 = l_rvb.rvb81
                LET l_qcs.qcs32 = l_rvb.rvb82
                LET l_qcs.qcs33 = l_rvb.rvb83
                LET l_qcs.qcs34 = l_rvb.rvb84
                LET l_qcs.qcs35 = l_rvb.rvb85

                SELECT ima906,ima44 INTO l_ima906,l_ima44 FROM ima_file     #FUN-BB0085 add ima44
                 WHERE ima01 = l_qcs.qcs021

                IF g_sma.sma115 = 'Y' AND l_qcs22s <> 0 THEN
                   IF l_ima906 = '3' THEN
                      LET l_qcs.qcs32 = l_qcs.qcs22
                      IF l_qcs.qcs34 <> 0 THEN
                         LET l_qcs.qcs35 = l_qcs.qcs22/l_qcs.qcs34
                      ELSE
                         LET l_qcs.qcs35 = 0
                      END IF
                   ELSE
                      IF l_ima906 = '2' AND NOT cl_null(l_qcs.qcs34) AND l_qcs.qcs34 <>0 THEN   #No.MOD-CC0009
                         LET l_qcs.qcs32 = l_qcs.qcs22 MOD l_qcs.qcs34
                         LET l_qcs.qcs35 = (l_qcs.qcs22 - l_qcs.qcs32) / l_qcs.qcs34
                      END IF                                                                    #No.MOD-CC0009
                   END IF
                END IF
                LET l_qcs.qcs09 = '1'
                LET l_qcs.qcs091 = l_qcs.qcs22
                LET l_qcs.qcs36 = l_qcs.qcs30
                LET l_qcs.qcs37 = l_qcs.qcs31
                LET l_qcs.qcs38 = l_qcs.qcs32
                LET l_qcs.qcs39 = l_qcs.qcs33
                LET l_qcs.qcs40 = l_qcs.qcs34
                LET l_qcs.qcs41 = l_qcs.qcs35
                #FUN-BB0085-add-str--
                LET l_qcs.qcs091= s_digqty(l_qcs.qcs091,l_ima44)
                LET l_qcs.qcs22 = s_digqty(l_qcs.qcs22,l_ima44)
                LET l_qcs.qcs32 = s_digqty(l_qcs.qcs32,l_qcs.qcs30)
                LET l_qcs.qcs35 = s_digqty(l_qcs.qcs35,l_qcs.qcs33)
                LET l_qcs.qcs38 = s_digqty(l_qcs.qcs38,l_qcs.qcs36)
                LET l_qcs.qcs41 = s_digqty(l_qcs.qcs41,l_qcs.qcs39)
                #FUN-BB0085-add-end--
#             END IF      #TQC-C30012
                SELECT COUNT(*) INTO l_n                       
                  FROM qcs_file WHERE qcs01 = g_argv1
                                  AND qcs14 != 'X'              #MOD-C30382 add
                SELECT SUM(qcs22) INTO l_q FROM qcs_file
                 WHERE qcs01= l_rva.rva01 AND qcs02 = l_rvb.rvb02
                   AND qcs021 = l_rvb.rvb05 
                   AND qcs14 != 'X'                             #MOD-C30382 add
             
                IF l_q >=l_rvb.rvb07 AND l_n >=1 THEN
                   CALL cl_err('','aqc-335',1)
                   LET l_t = 'N'
                   EXIT FOREACH                     
                ELSE
                   LET l_t = 'Y'
                END IF
                CALL p001_chk_qcs09()   #MOD-D70179 add
                INSERT INTO qcs_file VALUES l_qcs.*									
                IF SQLCA.sqlcode THEN	
                   CALL cl_err3("","","","",SQLCA.SQLCODE,"","",1)																					
                   LET g_success = 'N'											
                   EXIT FOREACH											
                END IF
                
                SELECT ima921 INTO l_ima921 FROM ima_file
                 WHERE ima01 = l_qcs.qcs021
                IF l_ima918="Y" OR l_ima921="Y" THEN 
                   FOREACH p001_rvbs USING l_qcs.qcs01,l_qcs.qcs02 INTO l_rvbs.*  #抓取批序號資料
                      #DEV-D40021 --add--str
                      LET l_ima930 = ''
                      SELECT ima930 INTO l_ima930 FROM ima_file 
                       WHERE ima01 = l_rvbs.rvbs021  
                      IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF 
                      IF l_ima930 = 'Y' THEN CONTINUE FOREACH END IF 
                      #DEV-D40021 --add--end
                      
                      #抓取已產生的資料
                      SELECT SUM(rvbs06) INTO l_rvbs06s FROM rvbs_file,qcs_file
                       WHERE qcs01 =l_qcs.qcs01
                         AND qcs02 =l_qcs.qcs02
                         AND rvbs13=qcs05
                         AND qcs01 = rvbs01
                         AND qcs02 = rvbs02
                         AND rvbs03 = l_rvbs.rvbs03
                         AND rvbs04 = l_rvbs.rvbs04
                         AND rvbs08 = l_rvbs.rvbs08
                         AND rvbs00[1,7] = 'aqct110'
                         AND qcs14 !='X'
                         AND qcs00 = '1'
                         AND rvbs09 = 1
                      IF cl_null(l_rvbs06s) THEN
                         LET l_rvbs06s=0
                      END IF

                      LET l_rvbs.rvbs00 = 'aqct110'
                      LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs06s
                      LET l_rvbs.rvbs10 = 0
                      LET l_rvbs.rvbs11 = 0
                      LET l_rvbs.rvbs12 = 0
                      LET l_rvbs.rvbs13 = l_qcs.qcs05
                      LET l_rvbs.rvbsplant = g_plant 
                      LET l_rvbs.rvbslegal = g_legal 

                      INSERT INTO rvbs_file VALUES (l_rvbs.*)
                   END FOREACH
                END IF
             END IF      #TQC-C30012 add
#No.TQC-B90236----add---end---------

   #產生QC單身資料

             LET l_s = 'Y'
             LET l_flag = ' '

			 LET l_yn = 0   #MOD-BB0073 add
                                    
             SELECT ecm04,COUNT(*) INTO l_ecm04,l_yn
               FROM qcc_file,ecm_file,rvb_file,pmn_file
              WHERE rvb01 = l_qcs.qcs01
                AND rvb02 = l_qcs.qcs02
                AND rvb04 = pmn01
                AND rvb03 = pmn02
                AND pmn41 = ecm01
                AND pmn46 = ecm03
                AND qcc01 = l_qcs.qcs021
                AND qcc011 = ecm04
                AND qcc08 IN ('1','9')
                AND ecm012 = pmn012
              GROUP BY ecm04
            #SELECT ima101 INTO l_ima101 #MOD-D20123 mark
             SELECT ima101 INTO g_ima101 #MOD-D20123 add
               FROM ima_file 
             #WHERE ima01 = l_qcs021     #MOD-D20123 mark
              WHERE ima01 = l_qcs.qcs021 #MOD-D20123 add

             IF cl_null(l_yn) OR l_yn<=0 THEN
                SELECT ecm04,COUNT(*) INTO l_ecm04,l_yn
                  FROM qcc_file,ecm_file,rvb_file,pmn_file
                 WHERE rvb01 = l_qcs.qcs01
                   AND rvb02 = l_qcs.qcs02
                   AND rvb04 = pmn01
                   AND rvb03 = pmn02
                   AND pmn41 = ecm01
                   AND pmn46 = ecm03
                   AND qcc01 = '*'
                   AND qcc011 = ecm04
                   AND qcc08 IN ('1','9')
                   AND ecm012 = pmn012
                 GROUP BY ecm04

                 IF cl_null(l_yn) OR l_yn<=0 THEN
                    SELECT sgm04,COUNT(*) INTO l_ecm04,l_yn
                      FROM qcc_file,sgm_file,rvb_file,pmn_file
                     WHERE rvb01=l_qcs.qcs01
                       AND rvb02=l_qcs.qcs02
                       AND rvb04=pmn01
                       AND rvb03=pmn02
                       AND pmn41=sgm02
                       AND pmn32=sgm03
                       AND sgm012 = pmn012
                       AND qcc01=l_qcs.qcs021
                       AND qcc011=sgm04
                       AND qcc08 IN ('1','9')
                     GROUP BY sgm04
                END IF
             END IF

             IF l_yn > 0 THEN
                LET l_flag = '1'          #--製程委外抓站別檢驗項目
             ELSE
                LET l_sql = " SELECT COUNT(*) FROM qcd_file ",
                            " WHERE qcd01 = ? ",
                            " AND qcd08 in ('1','9') "
                PREPARE qcd_sel FROM l_sql
                EXECUTE qcd_sel USING l_qcs.qcs021 INTO l_yn

                IF l_yn > 0 THEN          #--- 料件檢驗項目
                   LET l_flag = '2'
                ELSE
                   LET l_flag = '3'       #--- 材料類別檢驗項目
                END IF
             END IF

             CASE l_flag
                WHEN '1'
                   LET l_sql = "SELECT qcc01,qcc02,qcc03,qcc04,qcc05,qcc061,qcc062, ",
                               "       qccacti,qccuser,qccgrup,qccmodu,qccdate ",
                               "  FROM qcc_file ",
                               " WHERE qcc01 = ? ",
                               "   AND qcc011 = ? ",
                               "   AND qcc08 IN ('1','9') ",
                               " ORDER BY qcc02"
                   PREPARE qcc_cur1 FROM l_sql
                   DECLARE qcc_cur CURSOR FOR qcc_cur1
                   DECLARE qcc_cur2 SCROLL CURSOR FOR qcc_cur1	
											
                   OPEN qcc_cur2 USING l_qcs.qcs021,l_ecm04
                   FETCH FIRST qcc_cur2 INTO l_qcd.*
                   IF SQLCA.sqlcode = 100 THEN
                      LET l_qcs021 = '*'
                   ELSE
                      LET l_qcs021 = l_qcs.qcs021
                   END IF

                   LET seq = 1                 #MOD-AC0311
                   FOREACH qcc_cur USING l_qcs021,l_ecm04 INTO l_qcd.*											
                      CASE l_qcd.qcd05 											
                       WHEN "1"   #一般											
                         CALL s_newaql(l_qcs.qcs021,l_qcs03_t,l_qcd.qcd04,l_qcs.qcs22,l_ecm04,l_type)											
                             RETURNING l_ac_num,l_re_num											
                        #CALL p001_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11 #MOD-E60119 mark									
                        #CALL p001_defqty(2,l_qcd.qcd04,l_qcs.qcs17,l_qcd.qcd05) RETURNING l_qct11 #MOD-E60119 add
                         LET l_qct11 = l_qcs.qcs22 #20221003
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                       WHEN '2'     #特殊											
                         LET l_ac_num = 0											
                         LET l_re_num = 1											
                         SELECT qcj05 INTO l_qct11											
                           FROM qcj_file											
                          WHERE (l_qcs.qcs22 BETWEEN qcj01 AND qcj02)											
                            AND qcj03 = l_qcd.qcd04											
                            AND qcj04 = l_qcs.qcs17											
                         IF STATUS THEN											
                            LET l_qct11 = 0											
                         END IF											
                         IF l_qcs22 = 1 THEN											
                            LET l_qct11 = 1											
                         END IF											
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                      WHEN "3"    #1916 計數											
                         LET l_ac_num = 0											
                         LET l_re_num = 1											
                        #CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11         #MOD-D40169 mark
                        #CALL p001_defqty(2,l_qcd.qcd04,l_qcs.qcs17,l_qcd.qcd05) RETURNING l_qct11 #MOD-D40169 add   #MOD-D80081 modify l_qcd05 -> l_qcd.qcd05
                         LET l_qct11 = l_qcs.qcs22 #20221003
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                      WHEN "4"    #1916 計量											
                         LET l_ac_num = ''											
                         LET l_re_num = ''											
                        #CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11         #MOD-D40169 mark
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcs.qcs17,l_qcd.qcd05) RETURNING l_qct11 #MOD-D40169 add   #MOD-D80081 modify l_qcd05 -> l_qcd.qcd05
                         SELECT qdf02 INTO l_qdf02											
                           FROM qdf_file											
                          WHERE (l_qcs.qcs22 BETWEEN qdf03 AND qdf04)											
                           #AND qdf01 = l_qcd.qcd03                                                #MOD-D40169 mark
                            AND qdf01 = l_qcs.qcs17                                                #MOD-D40169 add
                         SELECT qdg05,qdg06 INTO l_qct14,l_qct15											
                           FROM qdg_file											
                         #WHERE qdg01 =單頭.ima101  #MOD-BA0036 mark
                         #WHERE qdg01 =l_ima101     #MOD-BA0036 #MOD-D20123 mark
                          WHERE qdg01 =g_ima101     #MOD-D20123 add
                           #AND qdg02 = l_qcd.qcd03 #MOD-D40169 mark
                            AND qdg02 = l_qcs.qcs17 #MOD-D40169 add
                            AND qdg03 = l_qdf02											
                         IF STATUS THEN											
                            LET l_qct14 =0											
                            LET l_qct15 =0											
                         END IF											
                      END CASE											
											
                      IF l_qct11 > l_qcs.qcs22 THEN											
                         LET l_qct11 = l_qcs.qcs22											
                      END IF											
											
                      IF cl_null(l_qct11) OR l_qct11 = 0 THEN											
                         LET l_qct11 = l_qcs.qcs22											
                      END IF											
											
                      INSERT INTO qct_file (qct01,qct02,qct021,qct03,qct04,qct05,											
                                            qct06,qct07,qct08,qct09,qct10,qct11,											
                                            qct12,qct131,qct132,qct14,qct15,											
                                            qctplant,qctlegal)											
                         VALUES(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,seq,											
                                l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,											
                                0,'1',l_ac_num,l_re_num,l_qct11,											
                                l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,											
                                l_qct14,l_qct15,											
                                g_plant,g_legal)											
                      LET seq = seq + 1											
                   END FOREACH											
                WHEN '2'											
                   LET l_sql = "  SELECT * FROM qcd_file",											
                               "  WHERE qcd01 = ? ",											
                               "    AND qcd08 IN ('1','9') ",											
                               "   ORDER BY qcd02"											
                   PREPARE qcd_cur1 FROM l_sql											
                   DECLARE qcd_cur CURSOR FOR qcd_cur1											
											
                   LET seq = 1            #MOD-AC0311
                   FOREACH qcd_cur USING l_qcs.qcs021 INTO l_qcd.*											
                      CASE l_qcd.qcd05 											
                       WHEN "1"   #一般											
                         CALL s_newaql(l_qcs.qcs021,l_qcs03_t,l_qcd.qcd04,l_qcs.qcs22,l_ecm04,l_type)											
                             RETURNING l_ac_num,l_re_num											
                        #CALL p001_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11 #MOD-E60119 mark
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcs.qcs17,l_qcd.qcd05) RETURNING l_qct11 #MOD-E60119 add
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                       WHEN '2'     #特殊											
                         LET l_ac_num = 0											
                         LET l_re_num = 1											
                         SELECT qcj05 INTO l_qct11											
                           FROM qcj_file											
                          WHERE (l_qcs.qcs22 BETWEEN qcj01 AND qcj02)											
                            AND qcj03 = l_qcd.qcd04											
                            AND qcj04 = l_qcs.qcs17											
                         IF STATUS THEN											
                            LET l_qct11 = 0											
                         END IF											
                         IF l_qcs22 = 1 THEN											
                            LET l_qct11 = 1											
                         END IF											
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                      WHEN "3"    #1916 計數											
                         LET l_ac_num = 0											
                         LET l_re_num = 1											
                        #CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11           #MOD-D80081 mark
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcs.qcs17,l_qcd.qcd05) RETURNING l_qct11   #MOD-D80081 add
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                      WHEN "4"    #1916 計量											
                         LET l_ac_num = ''											
                         LET l_re_num = ''											
                        #CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11           #MOD-D80081 mark
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcs.qcs17,l_qcd.qcd05) RETURNING l_qct11   #MOD-D80081 add
                         SELECT qdf02 INTO l_qdf02											
                           FROM qdf_file											
                          WHERE qdf03 <= l_qcs.qcs22 
                            AND qdf04 >= l_qcs.qcs22											
                           #AND qdf01 = l_qcd.qcd03                                                  #MOD-D80081 mark                                                                     
                            AND qdf01 = g_qcs.qcs17                                                  #MOD-D80081 add
                         SELECT qdg05,qdg06 INTO l_qct14,l_qct15											
                           FROM qdg_file											
                         #WHERE qdg01 = l_ima101 #MOD-D20123 mark											
                          WHERE qdg01 = g_ima101 #MOD-D20123 add
                           #AND qdg02 = l_qcd.qcd03                                                  #MOD-D80081 mark
                            AND qdg02 = g_qcs.qcs17                                                  #MOD-D80081 add
                            AND qdg03 = l_qdf02											
                         IF STATUS THEN											
                            LET l_qct14 =0											
                            LET l_qct15 =0											
                         END IF											
                      END CASE											
											
                      IF l_qct11 > l_qcs.qcs22 THEN											
                         LET l_qct11 = l_qcs.qcs22											
                      END IF											
             											
                      IF cl_null(l_qct11) OR l_qct11 = 0 THEN											
                         LET l_qct11 = l_qcs.qcs22 #20221003										
                      END IF											
											
                      INSERT INTO qct_file (qct01,qct02,qct021,qct03,qct04,qct05,											
                                            qct06,qct07,qct08,qct09,qct10,qct11,											
                                            qct12,qct131,qct132,qct14,qct15,											
                                            qctplant,qctlegal)											
                                    #VALUES(g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,seq,	#MOD-AC0311										
                                     VALUES(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,seq,    #MOD-AC0311
                                            l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,											
                                            0,'1',l_ac_num,l_re_num,l_qct11,											
                                            l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,											
                                            l_qct14,l_qct15,											
                                            g_plant,g_legal)											
                      LET seq = seq + 1											
                   END FOREACH											
                WHEN '3'      #--- 材料類別檢驗項目											
                   LET l_sql = " SELECT qck_file.* FROM qck_file,ima_file ",											
                               "  WHERE qck01 = ima109 AND ima01 = ?",											
                               "    AND qck08 IN ('1','9') ",											
                               "  ORDER BY qck02"											
                   PREPARE qck_cur1 FROM l_sql											
                   DECLARE qck_cur CURSOR FOR qck_cur1											
 
                   LET seq = 1         #MOD-AC0311											
                   FOREACH qck_cur USING l_qcs.qcs021 INTO l_qcd.*											
                      CASE l_qcd.qcd05 											
                       WHEN "1"   #一般											
                         CALL s_newaql(l_qcs.qcs021,l_qcs03_t,l_qcd.qcd04,l_qcs.qcs22,l_ecm04,l_type)											
                              RETURNING l_ac_num,l_re_num											
                        #CALL p001_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qct11 #MOD-E60119 mark				
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcs.qcs17,l_qcd.qcd05) RETURNING l_qct11 #MOD-E60119 add
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                       WHEN '2'     #特殊											
                         LET l_ac_num=0 LET l_re_num=1											
                         SELECT qcj05 INTO l_qct11											
                           FROM qcj_file											
                          WHERE (l_qcs.qcs22 BETWEEN qcj01 AND qcj02)											
                            AND qcj03=l_qcd.qcd04											
                            AND qcj04 = l_qcs.qcs17											
                         IF STATUS THEN LET l_qct11=0 END IF											
                         IF l_qcs22 = 1 THEN											
                            LET l_qct11 = 1											
                         END IF											
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                      WHEN "3"    #1916 計數											
                         LET l_ac_num = 0											
                         LET l_re_num = 1											
                        #CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11           #MOD-D80081 mark
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcs.qcs17,l_qcd.qcd05) RETURNING l_qct11   #MOD-D80081 add
                         LET l_qct14 = ''											
                         LET l_qct15 = ''											
                      WHEN "4"    #1916 計量											
                         LET l_ac_num = ''											
                         LET l_re_num = ''											
                        #CALL p001_defqty(2,l_qcd.qcd04,l_qcd03,l_qcd05) RETURNING l_qct11           #MOD-D80081 mark
                         CALL p001_defqty(2,l_qcd.qcd04,l_qcs.qcs17,l_qcd.qcd05) RETURNING l_qct11   #MOD-D80081 add
                         SELECT qdf02 INTO l_qdf02											
                           FROM qdf_file											
                          WHERE (l_qcs.qcs22 BETWEEN qdf03 AND qdf04)											
                           #AND qdf01 = l_qcd.qcd03                                                  #MOD-D80081 mark
                            AND qdf01 = g_qcs.qcs17                                                  #MOD-D80081 add
                         SELECT qdg05,qdg06 INTO l_qct14,l_qct15											
                           FROM qdg_file											
                         #WHERE qdg01 = l_ima101 #MOD-D20123 mark											
                          WHERE qdg01 = g_ima101 #MOD-D20123 add
                           #AND qdg02 = l_qcd.qcd03                                                  #MOD-D80081 mark
                            AND qdf01 = g_qcs.qcs17                                                  #MOD-D80081 add 
                            AND qdg03 = l_qdf02		                                                			
                         IF STATUS THEN											
                            LET l_qct14 =0											
                            LET l_qct15 =0											
                         END IF											
                      END CASE											
                      IF l_qct11 > l_qcs.qcs22 THEN 
                         LET l_qct11=l_qcs.qcs22 
                      END IF											
                      IF cl_null(l_qct11) OR l_qct11 = 0 THEN 
                         LET l_qct11= l_qcs.qcs22  #20221003 
                      END IF											
                      INSERT INTO qct_file (qct01,qct02,qct021,qct03,qct04,qct05,											
                                            qct06,qct07,qct08,qct09,qct10,qct11,											
                                            qct12,qct131,qct132,qct14,qct15,											
                                            qctplant,qctlegal)											
                                     VALUES(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,seq,											
                                            l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,											
                                            0,'1',l_ac_num,l_re_num,l_qct11,											
                                            l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,											
                                            l_qct14,l_qct15,											
                                            g_plant,g_legal)											
                      LET seq=seq+1											
                   END FOREACH											
             END CASE											
         END FOREACH
         #FUN-C30064---begiin
         IF g_success = 'Y'AND l_s = 'Y' THEN
            IF cl_null(l_str) THEN 
               LET l_str = l_rva.rva01
            ELSE
               LET l_str = l_str,',',l_rva.rva01
            END IF 
         END IF 
         #FUN-C30064---end 
      END FOREACH								
      IF l_m = 'Y' THEN
         IF g_success = 'Y'AND l_s = 'Y' THEN											
            COMMIT WORK											
            #CALL cl_err('','aqc-336',1)  #FUN-C30064
            CALL cl_err(l_str,'aqc-336',1)   #FUN-C30064
            LET l_k = 1
         ELSE											
         #  CALL cl_err('','aqc-337',1)   #MOD-AC0319 mark
         ###-MOD-B30406 - ADD - BEGIN ------------------------
            IF l_s = 'N' THEN
               CALL cl_err('','aqc-337',1)
            ELSE
         ###-MOD-B30406 - ADD -  END  ------------------------
               CALL cl_err('','mfg1608',1)   #MOD-AC0319 add
            END IF                           #MOD-B30406 - ADD -
            LET l_k = 2
            ROLLBACK WORK
         END IF	
      #MOD-AC0319-----add----str-----
      ELSE
         CALL cl_err('','aqc-337',1)
         LET l_k = 2
         ROLLBACK WORK       	
      #MOD-AC0319----add-----end------									
      END IF

      IF g_success = 'Y' THEN
         LET tm.wc = 'qcs10="',l_qcs.qcs10,'" AND qcs04="',l_qcs.qcs04,'"'
                    
         LET lc_cmd = 'aqcr300' CLIPPED ,
             " '",g_today CLIPPED,"' ''",
             " '",g_lang CLIPPED,"' 'Y' '""' '1'",
             " '",tm.wc CLIPPED,"' "
         CALL cl_cmdrun(lc_cmd)
      END IF
      #END IF
      #END IF

END FUNCTION

#FUNCTION p001_defqty(l_def,l_rate,l_level,l_type)  #對送驗量做四捨五入 #MOD-D80081 modify l_qcd03 -> l_level ,l_qcd05 -> l_type 
 FUNCTION p001_defqty(l_def,l_rate,l_level,l_type1) #對送驗量做四捨五入 #MOD-D80081 modify l_qcd03 -> l_level ,l_qcd05 -> l_type  #CHI-E60021 l_type改名為l_type1避免和global變數的l_type義思混淆
#DEFINE      l_ima915  LIKE ima_file.ima915   #MOD-C70226 mark
DEFINE      l_pmh09   LIKE pmh_file.pmh09
DEFINE      l_pmh15   LIKE pmh_file.pmh15
DEFINE      l_pmh16   LIKE pmh_file.pmh16
DEFINE      l_qcb04   LIKE qcb_file.qcb04
DEFINE      l_qca03   LIKE qca_file.qca03
DEFINE      l_qca04   LIKE qca_file.qca04
DEFINE      l_qca05   LIKE qca_file.qca05
DEFINE      l_qca06   LIKE qca_file.qca06
DEFINE      l_qdg04   LIKE qdg_file.qdg04
DEFINE      l_def     LIKE type_file.num5
#DEFINE      l_rate    LIKE type_file.num5
DEFINE      l_rate    LIKE qcd_file.qcd04   #MOD-B70290 
DEFINE      l_qcd03   LIKE qcd_file.qcd03
DEFINE      l_qcd05   LIKE qcd_file.qcd05
DEFINE      l_level   LIKE qcd_file.qcd03   #MOD-D80081 add
DEFINE      l_type1   LIKE qcd_file.qcd05   #MOD-D80081 add #CHI-E60021 l_type改名為l_type1



   LET l_qty = l_qcs22											
   LET l_qcs22 = l_qty											
  #MOD-C70226 str mark-----
  #LET l_ima915 = ''											
  #SELECT ima915 INTO l_ima915 FROM ima_file											
  # WHERE ima01=l_qcs.qcs021											
  #IF cl_null(l_ima915) THEN											
  #   LET l_ima915 = '0'											
  #END IF		
  #MOD-C70226 end mark-----									
											
   LET l_sql="SELECT pmh09,pmh15,pmh16 FROM pmh_file",											
             " WHERE pmh01 ='", l_qcs.qcs021,"'",											
             "   AND pmh02 ='", l_qcs.qcs03,"'",											
             "   AND pmh07 ='", l_pmn.pmn123,"'",   #FUN-D10004 add
             "   AND pmh21 ='", l_ecm04,"'",											
             "   AND pmh22 ='", l_type,"'",											
             "   AND pmh23 = ' ' "											
   PREPARE pmh_cur2_pre FROM l_sql											
   DECLARE pmh_cur2 CURSOR FOR pmh_cur2_pre											
											
   OPEN pmh_cur2											
   FETCH pmh_cur2 INTO l_pmh09,l_pmh15,l_pmh16											
  #IF STATUS OR l_ima915 = '0' THEN           #MOD-C70226 mark
   IF STATUS THEN                             #MOD-C70226 add											
      SELECT pmc906,pmc905,pmc907											
        INTO l_pmh09,l_pmh15,l_pmh16											
        FROM pmc_file											
       WHERE pmc01 = l_qcs.qcs03											
      IF STATUS OR cl_null(l_pmh09) OR cl_null(l_pmh15)											
         OR cl_null(l_pmh16) THEN											
         SELECT ima100,ima101,ima102											
           INTO l_pmh09,l_pmh15,l_pmh16											
           FROM ima_file											
          WHERE ima01 = l_qcs.qcs021											
         IF STATUS THEN											
            LET l_pmh09=''											
            LET l_pmh15=''											
            LET l_pmh16=''											
            RETURN 0											
         END IF											
      END IF											
   END IF											
											
   LET l_qcs.qcs17 = l_pmh16											
   IF l_pmh09 IS NULL OR l_pmh09=' ' THEN RETURN 0 END IF											
   IF l_pmh15 IS NULL OR l_pmh15=' ' THEN RETURN 0 END IF											
   IF l_pmh16 IS NULL OR l_pmh16=' ' THEN RETURN 0 END IF											
											
   IF l_pmh15='1' THEN											
      SELECT qcb04											
        INTO l_qcb04											
        FROM qca_file,qcb_file											
       WHERE (l_qcs22 BETWEEN qca01 AND qca02)											
         AND qcb02 = l_rate											
         AND qca03 = qcb03											
         AND qca07 = l_qcs.qcs17											
         AND qcb01 = l_qcs.qcs21											
											
      IF NOT cl_null(l_qcb04) THEN											
        #SELECT UNIQUE qca03,qca04,qca05,qca06   #MOD-DA0168 mark	
        #SELECT DISTINCT qca03,qca04,qca05,qca0	 #MOD-DA0168 add  #MOD-DB0022 mark
         SELECT DISTINCT qca03,qca04,qca05,qca06 #MOD-DB0022 add
           INTO l_qca03,l_qca04,l_qca05,l_qca06											
           FROM qca_file											
          WHERE qca03=l_qcb04											
           #MOD-DA0168 mark start -----
           #AND l_qcs22 BETWEEN qca01 AND qca02  #MOD-D80053 add 
           #AND qca07=l_qcs.qcs17                #MOD-D80053 add 
           #MOD-DA0168 mark end   -----
         IF STATUS THEN											
            LET l_qca03 = 0											
            LET l_qca04 = 0											
            LET l_qca05 = 0											
            LET l_qca06 = 0											
         END IF											
      END IF											
   END IF											
											
   IF l_pmh15 = '2' THEN											
      SELECT qcb04 INTO l_qcb04											
        FROM qch_file,qcb_file											
       WHERE (l_qcs22 BETWEEN qch01 AND qch02)											
         AND qcb02 = l_rate											
         AND qch03 = qcb03											
         AND qch07 = l_qcs.qcs17											
         AND qcb01 = l_qcs.qcs21											
											
      IF NOT cl_null(l_qcb04) THEN											
         SELECT UNIQUE qch03,qch04,qch05,qch06											
           INTO l_qca03,l_qca04,l_qca05,l_qca06											
           FROM qch_file											
          WHERE qch03=l_qcb04											
         IF STATUS THEN											
            LET l_qca03 = 0											
            LET l_qca04 = 0											
            LET l_qca05 = 0											
            LET l_qca06 = 0											
         END IF											
      END IF											
   END IF											
											
   IF l_qcs22 = 1 THEN											
      LET l_qca04 = 1											
      LET l_qca05 = 1											
      LET l_qca06 = 1											
   END IF											
											
    #CASE l_type     #MOD-D80081 modify l_qcd.qcd05 -> l_type  #CHI-E60021 mark
     CASE                                                      #CHI-E60021 add
#MOD-AC0311 ---------------Begin--------------
#       WHEN '1' OR '2'											
#          CASE l_pmh09											
#             WHEN 'N'											
#                RETURN l_qca04											
#             WHEN 'T'											
#                RETURN l_qca05											
#             WHEN 'R'											
#                RETURN l_qca06											
#             OTHERWISE											
#                RETURN 0											
#          END CASE											
# 
#       WHEN '3' OR '4'	
#          CASE l_pmh09											
#             WHEN 'N'											
#                LET l_qcd03 = l_qcd.qcd03											
#             WHEN 'T'											
#                LET l_qcd03 = l_qcd.qcd03+1											
#                IF l_qcd03 = 8 THEN											
#                   LET l_qcd03 = 'T'											
#                END IF											
#             WHEN 'R'											
#                LET l_qcd03 = l_qcd.qcd03-1											
#                IF l_qcd03 = 0 THEN											
#                   LET l_qcd03 = 'R'											
#                END IF											
#             OTHERWISE											
#                RETURN 0											
#          END CASE			
       #WHEN '1'           #CHI-E60021 mark
        WHEN l_type1 = '1' #CHI-E60021 add
           CASE l_pmh09
              WHEN 'N'
                 RETURN l_qca04
              WHEN 'T'
                 RETURN l_qca05
              WHEN 'R'
                 RETURN l_qca06
              OTHERWISE
                 RETURN 0
           END CASE
       #WHEN '2'           #CHI-E60021 mark
        WHEN l_type1 = '2' #CHI-E60021 add
           CASE l_pmh09
              WHEN 'N'
                 RETURN l_qca04
              WHEN 'T'
                 RETURN l_qca05
              WHEN 'R'
                 RETURN l_qca06
              OTHERWISE
                 RETURN 0
           END CASE
       #WHEN '3'                      #CHI-E60021 mark
        WHEN l_type1 MATCHES "[34]"   #CHI-E60021 add
          #CHI-E60021 add----str----移至此
          #setp1 先找出符合該料檢驗級數及批量範圍的樣本字樣
          #aqci104
           LET l_qcd03 = l_level       #級數不變
           SELECT qdf02 INTO l_qdf02
             FROM qdf_file
            WHERE (l_qcs.qcs22 BETWEEN qdf03 AND qdf04) 
              AND qdf01 = l_qcd03
          
          #setp2 再依據檢驗程度,決定是否將級數做加減
          #CHI-E60021 add----end----
           CASE l_pmh09
              WHEN 'N'
                 LET l_qcd03 = l_level       #MOD-D80081 modify l_qcd.qcd03 -> l_level
              WHEN 'T'
                 LET l_qcd03 = l_level + 1   #MOD-D80081 modify l_qcd.qcd03 -> l_level
                 IF l_qcd03 = 8 THEN
                    LET l_qcd03 = 'T'
                 END IF
              WHEN 'R'
                 LET l_qcd03 = l_level - 1   #MOD-D80081 modify l_qcd.qcd03 -> l_level
                 IF l_qcd03 = 0 THEN
                    LET l_qcd03 = 'R'
                 END IF
              OTHERWISE
                 RETURN 0
           END CASE
          #CHI-E60021 mark---str----移至上面
          #SELECT qdf02 INTO l_qdf02
          #  FROM qdf_file
          ##WHERE (g_qcs.qcs22 BETWEEN qdf03 AND qdf04) #MOD-D20123 mark
          # WHERE (l_qcs.qcs22 BETWEEN qdf03 AND qdf04) #MOD-D20123 add
          #   AND qdf01 = l_qcd03
          #CHI-E60021 mark---end----
          #setp3 抓抽樣數
          #aqci105
           SELECT qdg04 INTO l_qdg04
             FROM qdg_file
           #WHERE qdg01 = l_ima101 #MOD-D20123 mark
           #WHERE qdg01 = l_type   #MOD-D20123 add #MOD-D80012 modify g_ima101 -> l_qcd.qcd05    #MOD-D80081 modify l_qcd.qcd05 -> l_type   #CHI-E60021 mark
            WHERE qdg01 = l_type1  #MOD-D20123 add #MOD-D80012 modify g_ima101 -> l_qcd.qcd05    #MOD-D80081 modify l_qcd.qcd05 -> l_type   #CHI-E60021 add
              AND qdg02 = l_qcd03
              AND qdg03 = l_qdf02
           IF STATUS THEN
              LET l_qdg04 = 0
           END IF
           RETURN l_qdg04
       #CHI-E60021---mark---str---
       #為'3' 或 '4' 的做法一致,程式也一致,不需寫二段造成維護困擾故mark掉
       #WHEN '4'
       #   CASE l_pmh09
       #      WHEN 'N'
       #         LET l_qcd03 = l_level         #MOD-D80081 modify l_qcd.qcd03 -> l_level
       #      WHEN 'T'
       #         LET l_qcd03 = l_level + 1     #MOD-D80081 modify l_qcd.qcd03 -> l_level
       #         IF l_qcd03 = 8 THEN
       #            LET l_qcd03 = 'T'
       #         END IF
       #      WHEN 'R'
       #         LET l_qcd03 = l_level - 1     #MOD-D80081 modify l_qcd.qcd03 -> l_level
       #         IF l_qcd03 = 0 THEN
       #            LET l_qcd03 = 'R'
       #         END IF
       #      OTHERWISE
       #         RETURN 0
       #   END CASE
#MOD-AC0311 --------------End------------------
       #   SELECT qdf02 INTO l_qdf02
       #     FROM qdf_file
       #   #WHERE (g_qcs.qcs22 BETWEEN qdf03 AND qdf04)	#MOD-D20123 mark
       #    WHERE (l_qcs.qcs22 BETWEEN qdf03 AND qdf04) #MOD-D20123 add
       #      AND qdf01 = l_qcd03
       #   SELECT qdg04 INTO l_qdg04
       #     FROM qdg_file
       #   #WHERE qdg01 = l_ima101 #MOD-D20123 mark
       #    WHERE qdg01 = l_type  #MOD-D20123 add #MOD-D80012 modify g_ima101 -> l_qcd.qcd05   #MOD-D80081 modify l_qcd.qcd05 -> l_type
       #      AND qdg02 = l_qcd03
       #      AND qdg03 = l_qdf02
       #   IF STATUS THEN
       #      LET l_qdg04 = 0
       #   END IF
       #   RETURN l_qdg04
       #CHI-E60021---mark---end---
     END CASE
 END FUNCTION
#MOD-D70179 -- add start --
FUNCTION p001_chk_qcs09()
DEFINE l_ima926    LIKE ima_file.ima926

   SELECT ima926 INTO l_ima926 FROM ima_file
      WHERE ima01 = l_qcs.qcs021
   IF l_qcs.qcs09 = '1' AND g_qcz.qcz13='Y' AND l_ima926 = 'Y'   
      AND l_qcs.qcs00 = '2' AND cl_null(l_qcs.qcs10) THEN
      LET l_qcs.qcs09='3'
      CALL cl_err('','aqc-051',1)
   END IF

END FUNCTION
#MOD-D70179 -- add end --
