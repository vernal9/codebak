# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cpmr846.4gl
# Descriptions...: 多工廠料件金額比較表
# Return code....:
# Date & Author..: 2023/03/09 By momo
#-------MODIFICATION-------MODIFICATION-------MODIFIACTION-------
# #-25040031 20250423 By momo 
#
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                        # Print condition RECORD
           wc1    STRING,                # Where Condition  #TQC-630166
           wc2    STRING,                #TQC-A70003
           price  LIKE type_file.chr1,   # 價格選擇
           bom    LIKE type_file.chr1,   # 展BOM否
           azk01  LIKE azk_file.azk01,   # 幣別
           azk04  LIKE azk_file.azk04,   # 匯率
           bdate  LIKE pmm_file.pmm04,   # 採購開始日
           edate  LIKE pmm_file.pmm04,   # 採購截止日
           more   LIKE type_file.chr1    # Input more condition(Y/N)
           END RECORD
DEFINE g_i    LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE l_table STRING    #FUN-A40023
DEFINE g_sql   STRING    #FUN-A40023
DEFINE   g_chk_azp01     LIKE type_file.chr1
DEFINE   g_chk_auth      STRING  
DEFINE   g_azp01         LIKE azp_file.azp01 
DEFINE   g_azp01_str     STRING
DEFINE   g_multi_ima01   STRING      #MOD-G80137 add 

 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 

#No.FUN-A40023 -----------start-----------------
    LET g_sql = " sn.type_file.num5,",
                " ima01.ima_file.ima01,",
                " ima02.ima_file.ima02,",
                " ima021.ima_file.ima021,",
                " ima25.ima_file.ima25,",
                " ima41.ima_file.ima41,",        
                " ima44_fac.ima_file.ima44_fac,",
                " ima133.ima_file.ima133,",     #產品預設料號
                " bmb06.bmb_file.bmb06,",       #組成用量
                " bmb10.bmb_file.bmb10,",       #BOM單位
                " imgplant.img_file.imgplant, ",     
                " pmc03.pmc_file.pmc03,",
                " pmh04.pmh_file.pmh04,",
                " pmh06.pmh_file.pmh06,",       #採購日期/核價日期 20250423
                " pmh12.pmh_file.pmh12,",       #價格 
                " pmh22.pmh_file.pmh22,",       #價格型態
                " pmn20.pmn_file.pmn20,",       #最近採購量
                " pmi05.pmi_file.pmi05,",       #分量計價  20250424
                " azk01.azk_file.azk01,",       #幣別
                " atp_qty.type_file.num15_3,",
                " oeb_q.type_file.num15_3,",
                " sfa_q1.type_file.num15_3,",
                " sfa_q2.type_file.num15_3,",
                " misc_q1.type_file.num15_3,",
                " sfs_q2.type_file.num15_3,",
                " sie_q.type_file.num15_3,",
                " pml_q.type_file.num15_3,",
                " pmn_q.type_file.num15_3,",
                " rvb_q2.type_file.num15_3,",
                " rvb_q.type_file.num15_3,",
                " sfb_q1.type_file.num15_3,",
                " sfb_q2.type_file.num15_3,",
                " qcf_q.type_file.num15_3,",
                " price.type_file.chr1,",
                " bom.type_file.chr1"
   

    LET l_table = cl_prt_temptable('cpmr846',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?, ",
                "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ? ) "        
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#No.FUN-A40023---------------end------------


   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc1 = ARG_VAL(7)      
   LET tm.wc2 = ARG_VAL(8)      
   LET tm.price  = ARG_VAL(9)   
   LET tm.bom    = ARG_VAL(10)    #MOD-DC0142  9 mod 10
   LET g_rep_user = ARG_VAL(11) #MOD-DC0142 12 mod 13
   LET g_rep_clas = ARG_VAL(12) #MOD-DC0142 13 mod 14
   LET g_template = ARG_VAL(13) #MOD-DC0142 14 mod 15
   LET g_rpt_name = ARG_VAL(14) #No.FUN-7C0078 #MOD-DC0142 15 mod 16
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r846_tm()	        	# Input print condition
      ELSE CALL cpmr846()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r846_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE l_cmd         LIKE type_file.chr1000
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE tok            base.StringTokenizer 
DEFINE l_zxy03        LIKE zxy_file.zxy03
DEFINE l_plant        STRING   #MOD-G80137 add 
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 6 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW r560_w AT p_row,p_col
        WITH FORM "cpm/42f/cpmr846"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more    = 'N'
   LET tm.price = '1'
   LET tm.bom = 'N'
   LET tm.azk04 = 0
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
#TQC-A70003 ---start
   CONSTRUCT BY NAME tm.wc1 ON azp01
                                 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         AFTER FIELD azp01 
            LET g_chk_azp01 = TRUE 
            LET g_azp01_str = get_fldbuf(azp01)  
            LET g_chk_auth = '' 
            IF NOT cl_null(g_azp01_str) AND g_azp01_str <> "*" THEN
               LET g_chk_azp01 = FALSE 
               LET tok = base.StringTokenizer.create(g_azp01_str,"|") 
               LET g_azp01 = ""
               WHILE tok.hasMoreTokens() 
                  LET g_azp01 = tok.nextToken()
                  SELECT zxy03 INTO l_zxy03 FROM zxy_file WHERE zxy01 = g_user AND zxy03 = g_azp01
                  IF STATUS THEN 
                     CONTINUE WHILE  
                  ELSE
                     IF g_chk_auth IS NULL THEN
                        LET g_chk_auth = "'",l_zxy03,"'"
                     ELSE
                        LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                     END IF 
                  END IF
               END WHILE
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF  
            END IF 
            IF g_chk_azp01 THEN
               DECLARE r846_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH r846_zxy_cs1 INTO l_zxy03 
                 IF g_chk_auth IS NULL THEN
                    LET g_chk_auth = "'",l_zxy03,"'"
                 ELSE
                    LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                 END IF
               END FOREACH
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF 
            END IF

            
            
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      
            
         ON ACTION controlp
            CASE
              WHEN INFIELD(azp01)   #來源營運中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw01"     
                   LET g_qryparam.state = "c"
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azp01
                   NEXT FIELD azp01
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
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
            
         ON ACTION qbe_select
            CALL cl_qbe_select()
            
   END CONSTRUCT
       
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r560_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF

#  IF cl_null(tm.wc1) THEN
#     LET tm.wc1 = " azp01 = '",g_plant,"'" 
#  END IF
#TQC-A70003 ---end
   
   CONSTRUCT BY NAME tm.wc2 ON ima01,ima02,ima021,ima06          #20250423
 
   #No.FUN-570240 --start
     #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
     #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
            IF INFIELD(ima01) THEN
               IF cl_null(g_chk_auth) THEN
                  LET l_plant = g_plant
               ELSE
                  LET l_plant = g_chk_auth
               END IF
               CALL q_ima_3(1,1,l_plant) RETURNING g_multi_ima01 
               DISPLAY g_multi_ima01 TO ima01
               NEXT FIELD ima01
            END IF

            IF INFIELD(ima06) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_imz"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO FORMONLY.ima06
               NEXT FIELD ima06
            END IF
            
   #No.FUN-570240 --end
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_action_choice = "locale"
          EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT

     #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
     #No.FUN-580031 ---end---
 
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r560_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF cl_null(tm.wc2) THEN
      LET tm.wc2 = " 1=1"
   END IF

   INPUT BY NAME tm.bom,tm.price,tm.bdate,tm.edate,tm.azk01,tm.azk04,
		 tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

 
      AFTER FIELD azk01
         IF NOT cl_null(tm.azk01) THEN
            SELECT 1 FROM azi_file
             WHERE azi01 = tm.azk01
            IF STATUS != 0 THEN
               CALL cl_err3("sel","azi_file",tm.azk01,"","aap-002","","azk01",1)
                   NEXT FIELD azk01
            END IF
            # azk04 賣出匯率
            SELECT azk04 INTO tm.azk04 FROM azk_file
             WHERE azk01 = tm.azk01
               AND azk02 = (SELECT MAX(azk02) FROM azk_file WHERE azk01=tm.azk01)
            IF cl_null(tm.azk04) THEN
               LET tm.azk04 = 0
            END IF
            DISPLAY BY NAME tm.azk04
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
	AFTER INPUT
		IF INT_FLAG THEN EXIT INPUT END IF

      ON ACTION CONTROLP
        CASE
          WHEN INFIELD(azk01)
            CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.default1 = tm.azk01
                     CALL cl_create_qry() RETURNING tm.azk01
                     DISPLAY BY NAME tm.azk01
                     NEXT FIELD azk01
          WHEN INFIELD(azk04)
                     CALL s_rate(tm.azk01,tm.azk04) RETURNING tm.azk04
                     DISPLAY BY NAME tm.azk04
                     NEXT FIELD azk04
        OTHERWISE EXIT CASE
        END CASE 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r560_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='cpmr846'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('cpmr846','9031',1)
      ELSE
         LET tm.wc1 = cl_replace_str(tm.wc1, "'", "\"")      #MOD-DC0142 add
         LET tm.wc2 = cl_replace_str(tm.wc2, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		           #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'",        #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'",       #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc1 CLIPPED,"'",        #MOD-DC0142 add 
                         " '",tm.wc2 CLIPPED,"'",
                         " '",tm.price CLIPPED,"'",
                         " '",tm.bom CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('cpmr846',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r560_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cpmr846()
   ERROR ""
END WHILE
   CLOSE WINDOW r560_w
END FUNCTION
 
FUNCTION cpmr846()
   DEFINE l_plant   LIKE  azp_file.azp01    #TQC-A70003
   DEFINE l_azp02   LIKE  azp_file.azp02    #TQC-A70003
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          l_sql         STRING,                 # RDSQL STATEMENT     #TQC-630166
          l_chr		LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05	LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          l_ima271  LIKE ima_file.ima271,
          maxstk    LIKE ima_file.ima271,
          sr            RECORD
                        sn     LIKE type_file.num5,  #序號
                        ima01  LIKE ima_file.ima01,  #料件編號
                        ima02  LIKE ima_file.ima02,  #品名規格
                        ima021 LIKE ima_file.ima021, #品名規格
                        ima25  LIKE ima_file.ima25,  #採購單位
                        ima41  LIKE ima_file.ima41,  #平均用量
                        ima44_fac LIKE ima_file.ima44_fac, #採購換算
                        ima133 LIKE ima_file.ima133, #產品預設料號 20250423
                        bmb06  LIKE bmb_file.bmb06,  #組成用量
                        bmb10  LIKE bmb_file.bmb10   #BOM單位
                        END RECORD
   DEFINE g_str         STRING                      
   DEFINE tok           base.StringTokenizer 
   DEFINE l_zxy03       LIKE zxy_file.zxy03 
   DEFINE l_str         STRING                    
   DEFINE l_pmc03       LIKE pmc_file.pmc03
   DEFINE l_pmh04       LIKE pmh_file.pmh04  
   DEFINE l_pmh06       LIKE pmh_file.pmh06 #採購日期/核價日期 20250423
   DEFINE l_pmh12       LIKE pmh_file.pmh12
   DEFINE l_pmh22       LIKE pmh_file.pmh22 #價格型態
   DEFINE l_pmn20       LIKE pmn_file.pmn20 #最近採購量
   DEFINE l_azk01       LIKE azk_file.azk01 #幣別
   DEFINE l_pmi05       LIKE pmi_file.pmi05 #分量計價 20250424
   DEFINE l_pmi01       LIKE pmi_file.pmi01 #核價單號 20250424
   DEFINE l_pmj02       LIKE pmj_file.pmj02 #核價項次 20250424
   DEFINE l_pmj05       LIKE pmj_file.pmj05 #核價幣別 20250424
   DEFINE l_ima           RECORD
             oeb_q        LIKE type_file.num15_3,
             sfa_q1       LIKE type_file.num15_3,
             sfa_q2       LIKE type_file.num15_3,
             misc_q1      LIKE type_file.num15_3,
             sfs_q2       LIKE type_file.num15_3,
             sie_q        LIKE type_file.num15_3,
             pml_q        LIKE type_file.num15_3,
             pmn_q        LIKE type_file.num15_3,
             rvb_q2       LIKE type_file.num15_3,
             rvb_q        LIKE type_file.num15_3,
             sfb_q1       LIKE type_file.num15_3,
             sfb_q2       LIKE type_file.num15_3,
             qcf_q        LIKE type_file.num15_3,
             atp_qty      LIKE type_file.num15_3
                          END RECORD

    CALL cl_del_data(l_table)
   #----------------------------MOD-DC0142--------------------------(S)
    IF g_bgjob = 'Y' THEN
       LET tm.wc1  = cl_replace_str(tm.wc1, "\\\"", "'")  
       LET tm.wc2  = cl_replace_str(tm.wc2, "\\\"", "'")  
       LET l_str = " AND ",tm.wc1 CLIPPED
    ELSE
       LET l_str = " AND azp01 IN ",g_chk_auth CLIPPED 
    END IF
   #----------------------------MOD-DC0142--------------------------(E)
    LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                " WHERE azw01 = azp01  ",
               #" AND azp01 IN ",g_chk_auth,                 #MOD-DC0142 mark
                l_str,                                       #MOD-DC0142 add
                " ORDER BY azp01 "
    PREPARE sel_azp01_pre FROM l_sql
    DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
 
    FOREACH sel_azp01_cs INTO l_plant,l_azp02  
      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF 
      
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-750093
 
     LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('imauser', 'imagrup')

     IF tm.bom='Y' THEN 
        LET tm.wc2 = cl_replace_str(tm.wc2,"ima01","bmb01") 
        LET l_sql = "SELECT rownum,ima01,ima02,ima021,ima44,ima41/ima44_fac,ima44_fac,ima133,bmb06,bmb10 ", #20250423
                    "  FROM ",cl_get_target_table(l_plant,'ima_file'),
                    "      ,",cl_get_target_table(l_plant,'bmb_file'),
                    "  WHERE bmb03 = ima01 AND bmb05 IS NULL ",
                    "    AND imaacti = 'Y' ",
                    "  START WITH ",tm.wc2 CLIPPED ,
                    "  CONNECT BY PRIOR bmb03 = bmb01 "
     ELSE
        LET l_sql = 
                    "SELECT '',ima01,ima02,ima021,ima44,ima41/ima44_fac ima41,ima44_fac,ima133,0,'' ",   #20250423
                    " FROM ",cl_get_target_table(l_plant,'ima_file'), 
                    " WHERE imaacti='Y' AND ima140='N' AND ",tm.wc2 CLIPPED,
                    " ORDER BY ima02,ima021,ima01 "

     END IF
                 
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
     PREPARE r846_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  
        EXIT PROGRAM
     END IF
     DECLARE r846_curs1 CURSOR FOR r846_prepare1
     FOREACH r846_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        
        LET l_pmn20 = 0
        LET l_pmc03=''
        LET l_pmh12 = 0
        LET l_pmh06 = ''    #20250423
        LET l_azk01 = ''
        LET l_pmi05 = ''    #20250424
        LET l_pmi01 = '' 
        LET l_pmj02 = '' 
        LET l_pmj05 = '' 
        LET g_today = g_today - 1

        #最近採購量 
        LET l_sql = "SELECT SUM(pmn20),MAX(pmm04),pmc03,pmn44,pmm02,aza17 ",   #20250423
                    "  FROM ",cl_get_target_table(l_plant,'pmn_file'),
                    "  ,"    ,cl_get_target_table(l_plant,'pmm_file'),
                    "  ,"    ,cl_get_target_table(l_plant,'pmc_file'), 
                    "  ,"    ,cl_get_target_table(l_plant,'aza_file'),
                    " WHERE pmn01=pmm01 ",
                    "   AND pmc01=pmm09 ",
                    "   AND pmn04 = '",sr.ima01,"' ",
                    "   AND pmm04 between '",tm.bdate,"' AND '",tm.edate,"' ",                            
                    "   AND pmm04 = (SELECT MAX(pmm04) FROM ",cl_get_target_table(l_plant,'pmm_file'),   
                    "  ,"                                    ,cl_get_target_table(l_plant,'pmn_file'),    
                    "                 WHERE pmm01=pmn01 ",                                                
                    "                   AND pmm04 between '",tm.bdate,"' AND '",tm.edate,"' ",            
                    "                   AND pmn04 = '",sr.ima01,"') ",
                    "GROUP BY pmc03,pmn44,pmm02,aza17 "
         
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_pmn_pre FROM l_sql
         EXECUTE sel_pmn_pre INTO l_pmn20,l_pmh06,l_pmc03,l_pmh12,l_pmh22,l_azk01 #20250423

         IF l_pmh22='S' THEN LET l_pmh22='2' ELSE LET l_pmh22='1' END IF

         IF cl_null(l_pmh22) THEN CONTINUE FOREACH END IF

         #最新核價
         IF tm.price = '2' THEN
            LET l_sql = "SELECT * FROM ( ",
                        "SELECT pmc03,pmi01,pmj02,pmj05,pmi02,pmi05,pmj07*azk052,pmi10,aza17 ",     #20250424
                        "  FROM ",cl_get_target_table(l_plant,'pmi_file'),
                        "  ,"    ,cl_get_target_table(l_plant,'pmj_file'),
                        "  ,"    ,cl_get_target_table(l_plant,'pmc_file'),
                        "  ,"    ,cl_get_target_table(l_plant,'azk_file'),
                        "  ,"    ,cl_get_target_table(l_plant,'aza_file'),
                        " WHERE pmi01 = pmj01 ",
                        "   AND pmc01 = pmi03 ",
                        "   AND pmj05 = azk01 ",
                        "   AND azk02 = '",g_today,"'  ",
                      # "   AND azk02 = (SELECT MAX(azk02) FROM ",cl_get_target_table(l_plant,'azk_file'),
                      # "  ,"                                    ,cl_get_target_table(l_plant,'pmj_file'),
                      # "                  WHERE azk01=pmj05) ",
                        "   AND pmc05 = '1' ",
                        "   AND pmi10 <= '2' ",
                        "   AND ta_pmj02 is null ",
                        "   AND pmiconf = 'Y' ",
                        "   AND pmj03 = '",sr.ima01,"' ",
                        "   AND pmj09 IN (SELECT MAX(pmj09) FROM ",cl_get_target_table(l_plant,'pmi_file'),
                        "  ,"                                     ,cl_get_target_table(l_plant,'pmj_file'),
                      # "                        WHERE pmi01=pmj01 AND pmj03 = '",sr.ima01,"' AND pmj07>0 ",
                        "                        WHERE pmi01=pmj01 AND pmj03 = '",sr.ima01,"' ",
                        "                          AND pmi02 between '",tm.bdate,"' AND '",tm.edate,"' ",     #20250422
                        "                          AND pmiconf='Y' AND ta_pmj02 is null AND pmj12<='2') ",
                        "   ORDER BY pmj07 ) ",
                        "   WHERE ROWNUM=1 "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
            PREPARE sel_pmj_pre FROM l_sql
            EXECUTE sel_pmj_pre INTO l_pmc03,l_pmi01,l_pmj02,l_pmj05,l_pmh06,l_pmi05,l_pmh12,l_pmh22,l_azk01  #20250424
     
            ##---- 分量計價 取最高 (S)
            IF l_pmi05='Y' THEN
               LET l_sql = "SELECT MAX(pmr05*azk052) ",
                           "  FROM ",cl_get_target_table(l_plant,'pmr_file'),
                           "  ,"    ,cl_get_target_table(l_plant,'azk_file'),
                           " WHERE pmr01 = '",l_pmi01,"' AND pmr02 = '",l_pmj02,"' ", 
                           "   AND azk01 = '",l_pmj05,"' ",
                           "   AND azk02 = '",g_today,"'  "
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
                PREPARE sel_pmr_pre FROM l_sql
                EXECUTE sel_pmr_pre INTO l_pmh12
            END IF
            ##---- 分量計價 取最低 (E)

         END IF
 
         #實際成本
         IF tm.price ='3' THEN
            LET l_sql = "SELECT ccc23,aza17 ",
                        "  FROM ",cl_get_target_table(l_plant,'ccc_file'),
                        "  ,"    ,cl_get_target_table(l_plant,'aza_file'),
                        " WHERE ccc01 =  '",sr.ima01,"' ",
                        "   AND ccc02||ccc03 = (SELECT MAX(ccc02||ccc03) FROM ",cl_get_target_table(l_plant,'ccc_file')
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
            PREPARE sel_ccc_pre FROM l_sql
            EXECUTE sel_ccc_pre INTO l_pmh12,l_azk01
         END IF 

         IF l_azk01 = tm.azk01 AND tm.azk04>0 THEN
            LET l_pmh12 = l_pmh12*tm.azk04
         END IF

          CALL cs_muplant_qty(sr.ima01,l_plant)
               RETURNING l_ima.oeb_q, l_ima.sfa_q1, l_ima.sfa_q2, l_ima.sie_q,  l_ima.pml_q,
                l_ima.pmn_q, l_ima.rvb_q2, l_ima.rvb_q,  l_ima.sfb_q1, l_ima.sfb_q2,
                l_ima.qcf_q, l_ima.atp_qty,l_ima.misc_q1,l_ima.sfs_q2
          LET l_ima.atp_qty = l_ima.atp_qty / sr.ima44_fac

        
          EXECUTE insert_prep USING sr.sn,sr.ima01,sr.ima02,sr.ima021,sr.ima25,
                                    sr.ima41,sr.ima44_fac,
                                    sr.ima133,                                          #20250423
                                    sr.bmb06,sr.bmb10,
                                    l_plant,
                                    l_pmc03,l_pmh04,
                                    l_pmh06,                                            #20250423
                                    l_pmh12,l_pmh22,l_pmn20,l_pmi05,l_azk01,
                                    l_ima.atp_qty,l_ima.oeb_q,l_ima.sfa_q1,l_ima.sfa_q2,
                                    l_ima.misc_q1,l_ima.sfs_q2,l_ima.sie_q,l_ima.pml_q,
                                    l_ima.pmn_q,l_ima.rvb_q2,l_ima.rvb_q,
                                    l_ima.sfb_q1,l_ima.sfb_q2,l_ima.qcf_q,
                                    tm.price,tm.bom
     END FOREACH 
END FOREACH
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

 
     LET g_str = ''
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc2,'ima01')
             RETURNING tm.wc2
        LET g_str = tm.wc2
     END IF
     LET g_str=g_str
     CALL cl_prt_cs3('cpmr846','cpmr846',g_sql,g_str)   #FUN-A40023
END FUNCTION
