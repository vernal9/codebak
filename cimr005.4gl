# Prog. Version..: '5.30.24-17.04.13(00008)'     #
#
# Pattern name...: cimr005.4gl
# Descriptions...: 雜發請採明細表
# Input parameter:
# Return code....:
# Date & Author..: 2021/07/12 By MOMO
# REQ:2107096616
# Modify.........: NO.23020003  20230217 By momo 報表需求調整
# Modify.........: NO.23020043  20230303 By momo 增加採單採購員 pmm12

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS

 
DEFINE tm  RECORD                          # Print condition RECORD
           wc      STRING,                 # TQC-630166
           more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
 
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_sma115    LIKE sma_file.sma115    
DEFINE g_sql       STRING                  
DEFINE g_str       STRING                  
DEFINE l_table     STRING                  
DEFINE l_table1    STRING                  
DEFINE g_inaconf   LIKE ina_file.inaconf   
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                #
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   ##---- 主報表
   LET g_sql="ina04.ina_file.ina04,gem02.gem_file.gem02,",
             "ina03.ina_file.ina03,",
             "ina01.ina_file.ina01,",
             "inacond.ina_file.inacond,",
             "inb03.inb_file.inb03,",
             "inb04.inb_file.inb04,ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "inb08.inb_file.inb08,inb09.inb_file.inb09,",
             "chr1000_1.type_file.chr1000,",
             "ima131.ima_file.ima131,inaconf.ina_file.inaconf,",
             "atpqty.type_file.num15_3, ",        #預計可用量      
             "avlstk.type_file.num15_3, ",        #可用量
             "pmlq.type_file.num15_3, ",          #請購量
             "pmnq.type_file.num15_3, ",          #採購量
             "pmm01.pmm_file.pmm01, ",            #採購單號
             "pmm04.pmm_file.pmm04, ",            #採購日期
             "pmm09.pmc_file.pmc03, ",            #供應商
             "pmn33.pmn_file.pmn33, ",            #採單交貨日
             "pmn53.pmn_file.pmn53, ",            #入庫量   20230217
             "pmk01.pmk_file.pmk01, ",            #請購單號 20230217
             "pmk04.pmk_file.pmk04, ",            #請購日期 20230217
             "sfb01.sfb_file.sfb01, ",            #工單單號 20230217
             "ina02.ina_file.ina02, ",            #扣帳日期 20230217 
             "rvu01.rvu_file.rvu01, ",            #入庫單號 20230217
             "rvu03.rvu_file.rvu03  "             #入庫日   20230217   
   LET l_table = cl_prt_temptable('cimr005',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   #LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,
   #             " VALUES(?,?,?,?,?,  ?,?,?,?,?, ",
   #             "        ?,?,?,?,?,  ?,?,?,?,?    )"                       
   #PREPARE insert_prep FROM g_sql
   #IF STATUS THEN
   #   CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   #END IF

   ##--- 採購明細
   LET g_sql = "pmm01.pmm_file.pmm01,",
               "pmm09.pmm_file.pmm09,",
               "pmc03.pmc_file.pmc03,",
               "pmn02.pmn_file.pmn02,",
               "pmn04.pmn_file.pmn04,",
               "pmn20.pmn_file.pmn20,",
               "pmn33.pmn_file.pmn33"
     
   LET l_table1 = cl_prt_temptable('cimr0051',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   #LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table1 CLIPPED,
   #             " VALUES(?,?,?,?,?,  ?,?) "
   #PREPARE insert_prep1 FROM g_sql
   #IF STATUS THEN
   #   CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM
   #END IF

 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14) 
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        
      THEN CALL cimr005_tm(0,0)       
      ELSE CALL cimr005()           
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION cimr005_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,    
       l_cmd          LIKE type_file.chr1000  
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 15 END IF
   #UI
 
   OPEN WINDOW cimr005_w AT p_row,p_col
        WITH FORM "cim/42f/cimr005"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_inaconf ='3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ina01,ina03,inb04,inb15,inaud13
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

        DISPLAY '4210' TO inb15 #20230217
 
        ON ACTION locale
            #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
       #### No.FUN-4A0056
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ina01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ina2"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ina01
                NEXT FIELD ina01
 
              WHEN INFIELD(inb04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO inb04
                NEXT FIELD inb04

              WHEN INFIELD(inb15)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azf01a"
                LET g_qryparam.default1 = '4210','2'
                LET g_qryparam.state = 'c'
                LET g_qryparam.arg1 = "4"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO inb15
                NEXT FIELD inb15
           END CASE
      ### END  No.FUN-4A0056
 
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
      LET INT_FLAG = 0 CLOSE WINDOW cimr005_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF

   INPUT g_inaconf,tm.more
     FROM FORMONLY.inaconf,
          FORMONLY.more ATTRIBUTES(WITHOUT DEFAULTS=TRUE)

         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
#      ON ACTION CONTROLP CALL cimr005_wc()   # Input detail Where Condition
      #UI
      AFTER INPUT

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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW cimr005_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cimr005'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cimr005','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
         CALL cl_cmdat('cimr005',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cimr005_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cimr005()
   ERROR ""
END WHILE
   CLOSE WINDOW cimr005_w
END FUNCTION
 
FUNCTION cimr005()
   DEFINE l_name     LIKE type_file.chr20,   #External(Disk) file name  
          l_sql      STRING,                 
          l_chr      LIKE type_file.chr1,    
          l_za05     LIKE za_file.za05,      
          l_order    ARRAY[5] OF LIKE ina_file.ina01,   
          sr         RECORD  
                            ina01    LIKE ina_file.ina01, #
                            ina03    LIKE ina_file.ina03,
                            ina04    LIKE ina_file.ina04,
                            ima02    LIKE ima_file.ima02,
                            ima021   LIKE ima_file.ima021,
                            ina05    LIKE ina_file.ina05,
                            inacond  LIKE ina_file.inacond,
                            inb03    LIKE inb_file.inb03, #單身項次
                            inb04    LIKE inb_file.inb04,
                            inb08    LIKE inb_file.inb08,
                            inb09    LIKE inb_file.inb09,
                            inb902   LIKE inb_file.inb902,
                            inb903   LIKE inb_file.inb903,
                            inb904   LIKE inb_file.inb904,
                            inb905   LIKE inb_file.inb905,
                            inb906   LIKE inb_file.inb906,
                            inb907   LIKE inb_file.inb907,
                            ima131   LIKE ima_file.ima131,  
                            inaconf  LIKE ina_file.inaconf,
                            pmm01    LIKE pmm_file.pmm01, #20230217
                            pmm04    LIKE pmm_file.pmm04, #20230217
                            pmm09    LIKE pmc_file.pmc03,
                            pmn01    LIKE pmn_file.pmn01, #20230217
                            pmn33    LIKE pmn_file.pmn33,
                            pmn53    LIKE pmn_file.pmn53, #20230217
                            pmk01    LIKE pmk_file.pmk01, #20230217
                            pmk04    LIKE pmk_file.pmk04, #20230217
                            pml02    LIKE pml_file.pml02, #20230217
                            sfb01    LIKE sfb_file.sfb01, #20230217
                            ina02    LIKE ina_file.ina02  #20230217
                     END RECORD
   DEFINE l_rvu01    LIKE rvu_file.rvu01   #入庫單號 20230217
   DEFINE l_rvu03    LIKE rvu_file.rvu03   #入庫日期 20230217
   DEFINE l_cnt      LIKE type_file.num5                  
   DEFINE l_i        LIKE type_file.num5                  
   DEFINE l_zaa02    LIKE zaa_file.zaa02                 
   DEFINE l_ima02    LIKE ima_file.ima02 
   DEFINE l_ima021   LIKE ima_file.ima021
   DEFINE l_gem02    LIKE gem_file.gem02
   DEFINE l_str2     LIKE type_file.chr1000,       
          l_inb904   STRING,                       
          l_inb907   STRING                        
   DEFINE l_ima906   LIKE ima_file.ima906 
   DEFINE l_ima           RECORD
             oeb_q        LIKE type_file.num15_3,
             sfa_q1       LIKE type_file.num15_3,
             sfa_q2       LIKE type_file.num15_3,
             misc_q1      LIKE type_file.num15_3,
             sfs_q2       LIKE type_file.num15_3,
             pml_q        LIKE type_file.num15_3,
             pmn_q        LIKE type_file.num15_3,
             rvb_q2       LIKE type_file.num15_3,
             rvb_q        LIKE type_file.num15_3,
             sfb_q1       LIKE type_file.num15_3,
             sfb_q2       LIKE type_file.num15_3,
             qcf_q        LIKE type_file.num15_3,
             atp_qty      LIKE type_file.num15_3,
             avl_stk      LIKE type_file.num15_3
                          END RECORD

   DEFINE l_pmn           RECORD
             pmm01        LIKE pmm_file.pmm01,
             pmm09        LIKE pmm_file.pmm09,
             pmc03        LIKE pmc_file.pmc03,
             pmn02        LIKE pmn_file.pmn02,
             pmn04        LIKE pmn_file.pmn04,
             pmn20        LIKE pmn_file.pmn20,
             pmn33        LIKE pmn_file.pmn33
                          END RECORD

   DEFINE l_pmn01         LIKE pmn_file.pmn01
 
     CALL cl_del_data(l_table)                             
     CALL cl_del_data(l_table1)         

     LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?,  ?,?,?,?,?, ",
                 "        ?,?,?,?,?,  ?,?,?,?,?, ",
                 "        ?,?,?,?,?,  ?,?,?,?              )"   #20230217
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
     END IF                    

     LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " VALUES(?,?,?,?,?,  ?,?) "      
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM
     END IF
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang


 
#No.FUN-930034 ---add begin
     IF NOT cl_null(g_inaconf) THEN
        CASE g_inaconf
           WHEN '1'
              LET tm.wc = tm.wc CLIPPED," AND inaconf = 'N'"
           WHEN '2'
              LET tm.wc = tm.wc CLIPPED," AND inaconf = 'Y' AND inapost = 'N'"
           WHEN '3'
              LET tm.wc = tm.wc CLIPPED," AND inapost = 'Y'"
           WHEN '4'
              LET tm.wc = tm.wc CLIPPED," AND inaconf = 'X'"
           WHEN '5'
              LET tm.wc = tm.wc CLIPPED
        END CASE
    END IF
#No.FUN-930034 ---add end

     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('inauser', 'inagrup')

 
     LET l_sql = "SELECT ",
                 "       ina01,ina03,ina04,ima02,ima021,ina05,inacond, ",
		 "       inb03,inb04,inb08,inb09,",
		 "       inb902,inb903,inb904,inb905,inb906,inb907, ima131,",
                 "       inaconf,pmm01,pmm04,pmc03, pmn02,pmn33,pmn53, ",
                 "       pmk01,pmk04,pml02,sfb01, ",
                 "       CASE inapost WHEN 'Y' THEN to_char(ina02,'yyyy/mm/dd') ELSE '' END ina02  ",                    #20230217
                 "   FROM ima_file,ina_file,inb_file ",
                 "   LEFT JOIN sfb_file ON sfb91 = inb01 AND sfb92 = inb03 ",                #20230217
                 "   LEFT JOIN pml_file ON pml24=inb01 ",                                    #20230217
                 "                         AND pml25=inb03 AND (pml16 <= '2' OR pml16 IN ('S','R','W')) ",  #20230217
                 "   LEFT JOIN pmk_file ON pmk01=pml01 ",
                 "   LEFT JOIN pmn_file ON pmn24 = pml01 AND pmn25 = pml02 ",                               #20230217
                 "   LEFT JOIN pmm_file ON pmm01 = pmn01 ",                                                 #20230217
                 "   LEFT JOIN pmc_file oN pmm09 = pmc01 ",                                                 #20230217
                 " WHERE ina01 = inb01 ",
                 "   AND inb04 = ima01 ",
                 "   AND ina00='1' AND ",tm.wc ,
                 " ORDER BY 3,2 "
    
     PREPARE cimr005_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
     END IF
     DECLARE cimr005_curs1 CURSOR FOR cimr005_prepare1

       SELECT sma115 INTO g_sma115 FROM sma_file
  
     FOREACH cimr005_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF


       LET l_gem02 = ''
       SELECT gem02 INTO l_gem02
              FROM gem_file
       WHERE gem01 = sr.ina04
   
       #最後入庫日 20230217
       SELECT MAX(rvu03) INTO l_rvu03
         FROM rvu_file,rvv_file
        WHERE rvu01=rvv01 AND rvu00='1'
          AND rvv36 = sr.pmm01 AND rvv37= sr.pmn01
          AND rvuconf = 'Y'

       #最後入庫日 20230217
       SELECT MAX(rvu01) INTO l_rvu01
         FROM rvu_file,rvv_file
        WHERE rvu01=rvv01 AND rvu00='1'
          AND rvv36 = sr.pmm01 AND rvv37= sr.pmn01
          AND rvu03 = l_rvu03
          AND rvuconf = 'Y'

       CALL cs_q103_qty(sr.inb04)
         RETURNING l_ima.oeb_q, l_ima.sfa_q1, l_ima.sfa_q2, l_ima.pml_q,
          l_ima.pmn_q, l_ima.rvb_q2, l_ima.rvb_q, l_ima.sfb_q1, l_ima.sfb_q2,
          l_ima.qcf_q, l_ima.atp_qty,l_ima.misc_q1,l_ima.sfs_q2,l_ima.avl_stk

       ##----多單位 -------------(S)
       LET l_str2 = ""
       IF g_sma115 = "Y" THEN

          SELECT ima906 INTO l_ima906 FROM ima_file
              WHERE ima01 = sr.inb04

          CASE l_ima906
            WHEN "2"
               CALL cl_remove_zero(sr.inb907) RETURNING l_inb907
               LET l_str2 = l_inb907, sr.inb905 CLIPPED
               IF cl_null(sr.inb907) OR sr.inb907 = 0 THEN
                  CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
                  LET l_str2 = l_inb904, sr.inb902 CLIPPED
               ELSE
                  IF NOT cl_null(sr.inb904) AND sr.inb904 <> 0 THEN
                     CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
                     LET l_str2 = l_str2 CLIPPED,',',l_inb904, sr.inb902 CLIPPED
                  END IF
               END IF
            WHEN "3"
               IF NOT cl_null(sr.inb907) OR sr.inb907 > 0 THEN
                  CALL cl_remove_zero(sr.inb907) RETURNING l_inb907
                  LET l_str2 = l_inb907, sr.inb905 CLIPPED
                END IF
          END CASE
       END IF
       ##----多單位 -------------(E)

       IF cl_null(sr.pmm01) THEN    #無對應採單才抓取其他採單
       ##---採購子報表
         DECLARE r005_c2 CURSOR FOR
           SELECT pmm01,pmm09,pmc03,pmn02,pmn04,pmn20,pmn33
             FROM pmm_file,pmn_file,pmc_file
            WHERE pmm01=pmn01 AND pmm09=pmc01
               AND pmn20 > pmn50-pmn55-pmn58                    
               AND (pmn16 <= '2' OR pmn16 IN ('S','R','W'))     
               AND pmm18 <> 'X'
               AND pmn04 = sr.inb04                             
            ORDER BY pmn33
         FOREACH r005_c2 INTO l_pmn.*
            IF STATUS THEN EXIT FOREACH END IF
               SELECT pmn01 INTO l_pmn01
                 FROM pmn_file,pml_file
                WHERE pmn24 = pml01 AND pmn02= pml02
                  AND pml24 = sr.ina01 AND pml25 = sr.inb03
               IF l_pmn01 <> l_pmn.pmm01 THEN
                  LET l_pmn.pmm01 = 'x',l_pmn.pmm01
               END IF
            EXECUTE insert_prep1 USING l_pmn.*
         END FOREACH
       ##---採購子報表
       END IF
 
       EXECUTE insert_prep USING sr.ina04,l_gem02,sr.ina03,
                                 sr.ina01,sr.inacond,sr.inb03,sr.inb04,
                                 sr.ima02,sr.ima021,sr.inb08,
                                 sr.inb09,l_str2,sr.ima131,sr.inaconf,
                                 l_ima.atp_qty,l_ima.avl_stk,l_ima.pml_q,l_ima.pmn_q,
                                 sr.pmm01,sr.pmm04,                                      #20230217
                                 sr.pmm09,sr.pmn33,
                                 sr.pmn53,                                               #20230217
                                 sr.pmk01,sr.pmk04,sr.sfb01,sr.ina02,l_rvu01,l_rvu03     #20230217       
     END FOREACH

     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ina01,ina03,ina04,inaconf')              
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",g_sma115,";"
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED ,"|",
                 "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED

     CALL cl_prt_cs3('cimr005','cimr005',l_sql,g_str)
END FUNCTION

