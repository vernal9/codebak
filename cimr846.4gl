# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cimr846.4gl
# Descriptions...: 多工廠料件庫存估算表
# Return code....:
# Date & Author..: 94/7/1 By Nick
#-------MODIFICATION-------MODIFICATION-------MODIFIACTION-------
#
#
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                        # Print condition RECORD
           wc1    STRING,                # Where Condition  #TQC-630166
           wc2    STRING,                #TQC-A70003
           day   LIKE type_file.num15_3, # 廠內庫存水位 
           day2  LIKE type_file.num15_3, # 庫存水位 
           more  LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD,
       l_done LIKE type_file.num5        #No.FUN-690026 SMALLINT
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
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 

#No.FUN-A40023 -----------start-----------------
    LET g_sql = " ima01.ima_file.ima01,",
                " ima02.ima_file.ima02,",
                " ima021.ima_file.ima021,",
                " ima25.ima_file.ima25,",
                " avl_stk.type_file.num15_3,",
                " ima27.ima_file.ima27,",
                " ima41.ima_file.ima41,",        
                " ima46.ima_file.ima46,",        
                " ima54.ima_file.ima54,",
                " ima44_fac.ima_file.ima44_fac,",
                " imgplant.img_file.imgplant, ",     
                " pmc03.pmc_file.pmc03,",
                " pmh04.pmh_file.pmh04,",
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
                " day.type_file.num15_3,",
                " day2.type_file.num15_3"
   

    LET l_table = cl_prt_temptable('cimr846',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?, ",
                "        ?,?,?,?,?, ?,?,?,?,? ) "        
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
   LET tm.wc1 = ARG_VAL(7)      #MOD-DC0142 add
   LET tm.wc2 = ARG_VAL(8)      #MOD-DC0142  7 mod  8
   LET tm.day  = ARG_VAL(9)    #MOD-DC0142  9 mod 10
   LET tm.day2  = ARG_VAL(10)    #MOD-DC0142  9 mod 10
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11) #MOD-DC0142 12 mod 13
   LET g_rep_clas = ARG_VAL(12) #MOD-DC0142 13 mod 14
   LET g_template = ARG_VAL(13) #MOD-DC0142 14 mod 15
   LET g_rpt_name = ARG_VAL(14) #No.FUN-7C0078 #MOD-DC0142 15 mod 16
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r846_tm()	        	# Input print condition
      ELSE CALL cimr846()			# Read data and create out-file
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
        WITH FORM "cim/42f/cimr846"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more    = 'N'
   LET tm.day = 1
   LET tm.day2 = 1
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
   
   CONSTRUCT BY NAME tm.wc2 ON ima01,ima06          #TQC-A70003 
 
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

   INPUT BY NAME tm.day,tm.day2,
				 tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
 
      AFTER FIELD day
         IF tm.day < 0
            THEN NEXT FIELD day
         END IF
 
      AFTER FIELD day2
         IF tm.day2 < 0
            THEN NEXT FIELD day2
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
             WHERE zz01='cimr846'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('cimr846','9031',1)
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
                         " '",tm.day CLIPPED,"'",
                         " '",tm.day2 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('cimr846',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r560_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cimr846()
   ERROR ""
END WHILE
   CLOSE WINDOW r560_w
END FUNCTION
 
FUNCTION cimr846()
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
                        ima01  LIKE ima_file.ima01, #料件編號
                        ima02  LIKE ima_file.ima02, #品名規格
                        ima021 LIKE ima_file.ima021,#品名規格
                        ima25  LIKE ima_file.ima25, #庫存單位
                        avl_stk LIKE type_file.num15_3, #庫存可用量        
                        ima27  LIKE ima_file.ima27, #安全存量/再補貨點
                        ima41 LIKE ima_file.ima41, #平均用量
                        ima46 LIKE ima_file.ima46, #最少採購量
                        ima54 LIKE ima_file.ima54, #主要供應商
                        ima44_fac LIKE ima_file.ima44_fac #採購換算
                        END RECORD
   DEFINE g_str         STRING                      
   DEFINE tok           base.StringTokenizer 
   DEFINE l_zxy03       LIKE zxy_file.zxy03 
   DEFINE l_str         STRING                    
   DEFINE l_pmc03       LIKE pmc_file.pmc03
   DEFINE l_pmh04       LIKE pmh_file.pmh04  
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
 
     LET l_done = 0
     LET l_sql = "SELECT ima01,ima02,ima021,ima25,0,ima27/ima44_fac,ima41/ima44_fac,ima46,ima54,ima44_fac,pmc03,pmh04 ",
                 " FROM ",cl_get_target_table(l_plant,'ima_file'), 
                 " LEFT JOIN ",cl_get_target_table(l_plant,'pmc_file'), 
                             " ON pmc01 = ima54",
                 " LEFT JOIN ",cl_get_target_table(l_plant,'pmh_file'), 
                             " ON pmc01 = pmh02 AND ima01 = pmh01 ",
                 " WHERE ",tm.wc2 CLIPPED
                 
     LET l_sql = l_sql CLIPPED, " ORDER BY ima01"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
     PREPARE r846_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE r846_curs1 CURSOR FOR r846_prepare1
     FOREACH r846_curs1 INTO sr.*,l_pmc03,l_pmh04
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        
          #可用庫存
          CALL s_getstock(sr.ima01,l_plant) RETURNING  l_ima271,l_ima271,sr.avl_stk
          LET sr.avl_stk = sr.avl_stk / sr.ima44_fac

          CALL cs_muplant_qty(sr.ima01,l_plant)
               RETURNING l_ima.oeb_q, l_ima.sfa_q1, l_ima.sfa_q2, l_ima.sie_q,  l_ima.pml_q,
                l_ima.pmn_q, l_ima.rvb_q2, l_ima.rvb_q,  l_ima.sfb_q1, l_ima.sfb_q2,
                l_ima.qcf_q, l_ima.atp_qty,l_ima.misc_q1,l_ima.sfs_q2
          LET l_ima.oeb_q = l_ima.oeb_q / sr.ima44_fac 
          LET l_ima.sfa_q1 = l_ima.sfa_q1 / sr.ima44_fac 
          LET l_ima.sfa_q2 = l_ima.sfa_q2 / sr.ima44_fac 
          LET l_ima.sie_q = l_ima.sie_q / sr.ima44_fac 
          LET l_ima.pml_q = l_ima.pml_q / sr.ima44_fac
          LET l_ima.pmn_q = l_ima.pmn_q / sr.ima44_fac 
          LET l_ima.rvb_q2 = l_ima.rvb_q2 / sr.ima44_fac 
          LET l_ima.rvb_q = l_ima.rvb_q / sr.ima44_fac 
          LET l_ima.sfb_q1 = l_ima.sfb_q1 / sr.ima44_fac 
          LET l_ima.sfb_q2 = l_ima.sfb_q2 / sr.ima44_fac 
          LET l_ima.qcf_q = l_ima.qcf_q / sr.ima44_fac 
          LET l_ima.atp_qty = l_ima.atp_qty / sr.ima44_fac
          LET l_ima.misc_q1 = l_ima.misc_q1 / sr.ima44_fac 
          LET l_ima.sfs_q2 = l_ima.sfs_q2 / sr.ima44_fac 

        
          EXECUTE insert_prep USING sr.ima01,sr.ima02,sr.ima021,sr.ima25,sr.avl_stk,
                                    sr.ima27,sr.ima41,sr.ima46,sr.ima54,sr.ima44_fac,
                                    l_plant,
                                    l_pmc03,l_pmh04,
                                    l_ima.atp_qty,l_ima.oeb_q,l_ima.sfa_q1,l_ima.sfa_q2,
                                    l_ima.misc_q1,l_ima.sfs_q2,l_ima.sie_q,l_ima.pml_q,
                                    l_ima.pmn_q,l_ima.rvb_q2,l_ima.rvb_q,
                                    l_ima.sfb_q1,l_ima.sfb_q2,l_ima.qcf_q,
                                    tm.day,tm.day2
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
     CALL cl_prt_cs3('cimr846','cimr846',g_sql,g_str)   #FUN-A40023
END FUNCTION
