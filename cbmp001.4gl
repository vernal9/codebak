# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cbmp001.4gl
# Descriptions...: BOM依條件整批拋轉
# Return code....:
# Date & Author..: 2025/01/22 By momo
#-------MODIFICATION-------MODIFICATION-------MODIFIACTION-------
#
#
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                        # Print condition RECORD
           wc1    STRING,                # Where Condition 
           wc2    STRING,               
           more  LIKE type_file.chr1     # Input more condition(Y/N) 
           END RECORD   
DEFINE g_i    LIKE type_file.num5     #count/index for any purpose 
DEFINE l_table STRING   
DEFINE g_sql   STRING    
DEFINE g_chk_azp01     LIKE type_file.chr1
DEFINE g_chk_auth      STRING  
DEFINE g_azp01         LIKE azp_file.azp01 
DEFINE g_azp01_str     STRING
DEFINE g_multi_ima01   STRING    
DEFINE l_flag          LIKE type_file.chr1 

 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CBM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 


   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc1 = ARG_VAL(7)     
   LET tm.wc2 = ARG_VAL(8)      

   LET g_bgjob = 'N'
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p001_tm()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL cbmp001()
            IF g_success = 'Y' THEN
               COMMIT WORK
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
         CALL cbmp001()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
        
         EXIT WHILE
      END IF
   END WHILE
  
  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p001_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01    
DEFINE l_cmd         LIKE type_file.chr1000
DEFINE p_row,p_col   LIKE type_file.num5    
DEFINE tok            base.StringTokenizer 
DEFINE l_zxy03        LIKE zxy_file.zxy03
DEFINE l_plant        STRING   
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 6 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW p001_w AT p_row,p_col
        WITH FORM "cbm/42f/cbmp001"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more    = 'N'
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
               DECLARE p001_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH p001_zxy_cs1 INTO l_zxy03 
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
      LET INT_FLAG = 0 CLOSE WINDOW p001_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF

   
   CONSTRUCT BY NAME tm.wc2 ON ima01,ima06,ima09,ima1007,ta_ima06,ta_ima08       
 
  
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
  
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

            IF INFIELD(ima09) THEN  #其他分群碼一
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_azf"
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = "D"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima09
               NEXT FIELD ima09
            END IF

            IF INFIELD(ima1007) THEN #型號
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "cq_ima1007"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima1007
               NEXT FIELD ima1007
            END IF

            IF INFIELD(ta_ima06) THEN #代工 
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_occ"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ta_ima06
               NEXT FIELD ta_ima06
            END IF
 
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
      LET INT_FLAG = 0 CLOSE WINDOW p001_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF cl_null(tm.wc2) THEN
      LET tm.wc2 = " 1=1"
   END IF

   INPUT BY NAME tm.more WITHOUT DEFAULTS
 
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW p001_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	
             WHERE zz01='cbmp001'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('cbmp001','9031',1)
      ELSE
         LET tm.wc1 = cl_replace_str(tm.wc1, "'", "\"")    
         LET tm.wc2 = cl_replace_str(tm.wc2, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		           #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",       
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc1 CLIPPED,"'",        
                         " '",tm.wc2 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
         CALL cl_cmdat('cbmp001',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW p001_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cbmp001()
   ERROR ""
END WHILE
   CLOSE WINDOW p001_w
END FUNCTION
 
FUNCTION cbmp001()
   DEFINE l_plant   LIKE  azp_file.azp01    
   DEFINE l_azp02   LIKE  azp_file.azp02    
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name  
          l_sql         STRING,                
          l_chr		LIKE type_file.chr1 
   DEFINE g_str         STRING                      
   DEFINE tok           base.StringTokenizer 
   DEFINE l_zxy03       LIKE zxy_file.zxy03 
   DEFINE l_str         STRING                    
 

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
                l_str,                                      
                " ORDER BY azp01 "
    PREPARE sel_azp01_pre FROM l_sql
    DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
 
    FOREACH sel_azp01_cs INTO l_plant,l_azp02  
      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF 
      
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
 
     LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('imauser', 'imagrup')

     ##--- 依符合條件新增多階BOM bmb_file 
     LET l_sql = "INSERT  ",
                 "/*+ ignore_row_on_dupkey_index(bmb_file,bmb_pk) */ ",
                 " INTO ",cl_get_target_table(l_plant,'bmb_file'), 
                 " (SELECT * FROM (SELECT distinct bmb_file.* ",
                 "                  FROM bmb_file ",
                 "                  WHERE bmb05 is NULL ",
                 " START WITH bmb01 in (SELECT ima01 FROM ima_file ",
                 "                       WHERE imaacti='Y' AND ",tm.wc2 CLIPPED ,
                 "   ) AND bmb05 is null ",
                 "   AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant,'bma_file'), 
                 "                     ksb where ksb.bma01=bmb_file.bmb01)",
                 "   AND EXISTS (SELECT 1 FROM bma_file where bma01=bmb01 and bmaacti='Y')" ,
                 " CONNECT BY PRIOR bmb03 = bmb01 and bmb05 is null ",
                 "   AND not exists (select 1 FROM ",cl_get_target_table(l_plant,'bma_file'),
                 "                    ksb where ksb.bma01=bmb_file.bmb01)))"
                 
     LET l_sql = l_sql CLIPPED
     
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
     PREPARE p001_prepare1 FROM l_sql
     EXECUTE p001_prepare1
     IF SQLCA.sqlcode THEN
        CALL cl_err('INSERT bmb_file error)',SQLCA.sqlcode,1)
        LET g_success='N'
     ELSE
        ##---新增缺少的主件
        LET l_sql = "INSERT ",
　　　　　　　　　　"/*+ ignore_row_on_dupkey_index(bma_file,bma_pk) */",
                    " INTO ",cl_get_target_table(l_plant,'bma_file'),
                    " (SELECT distinct * FROM bma_file sou ",
                    "   WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant,'bmb_file'),
                    "                   WHERE sou.bma01=bmb01 )",
                    "   AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant,'bma_file'),
                    "                    dis WHERE sou.bma01=dis.bma01)) "
        LET l_sql = l_sql CLIPPED
     
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
        PREPARE p001_prepare12 FROM l_sql
        EXECUTE p001_prepare12
　　　　   IF SQLCA.sqlcode THEN
       　　    CALL cl_err('INSERT bma_file error)',SQLCA.sqlcode,1)
        　　   LET g_success='N'
           ELSE
               ##-----新增缺少的料件
　　　　　　　 LET l_sql = "INSERT ",
　　　　　　　　　　"/*+ ignore_row_on_dupkey_index(ima_file,ima_pk) */",
                    " INTO ",cl_get_target_table(l_plant,'ima_file'),
                    " (SELECT distinct * FROM ima_file sou ",
                    "   WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant,'bmb_file'),
                    "                   WHERE sou.ima01=bmb03 )",
                    "   AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant,'ima_file'),
                    "                    dis WHERE sou.ima01=dis.ima01 ))"
               LET l_sql = l_sql CLIPPED

               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
               PREPARE p001_prepare13 FROM l_sql
               EXECUTE p001_prepare13
　　　　       IF SQLCA.sqlcode THEN
       　　       CALL cl_err('INSERT ima_file error)',SQLCA.sqlcode,1)
        　　      LET g_success='N'
               ELSE
                  ##-----新增缺少的製程
　　　　　　　    LET l_sql = "INSERT ",
　　　　　　　　   　　"/*+ ignore_row_on_dupkey_index(ecu_file,ecu_pk) */",
                       " INTO ",cl_get_target_table(l_plant,'ecu_file'),
                       " (SELECT distinct * FROM ecu_file sou ",
                       "   WHERE sou.ecuacti='Y' ",
                       "   AND EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant,'ima_file'),
                       "                 WHERE sou.ecu01=ima571 AND sou.ecu02=ima94 )",
                       "   AND EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant,'bma_file'), 
                       "                 WHERE bma01=sou.ecu01) ",
                       "   AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant,'ecu_file'),
                       "                    dis WHERE sou.ecu01=dis.ecu01 AND sou.ecu02=dis.ecu02 ))"
                  LET l_sql = l_sql CLIPPED

                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
                  PREPARE p001_prepare14 FROM l_sql
                  EXECUTE p001_prepare14
　　　　          IF SQLCA.sqlcode THEN
       　　          CALL cl_err('INSERT ecu_file error)',SQLCA.sqlcode,1)
        　　         LET g_success='N'
     　           END IF

                  LET l_sql = "INSERT ",
　　　　　　　　   　　"/*+ ignore_row_on_dupkey_index(ecb_file,ecb_pk) */",
                       " INTO ",cl_get_target_table(l_plant,'ecb_file'),
                       " (SELECT distinct * FROM ecb_file sou ",
                       "   WHERE sou.ecbacti='Y' ",
                       "     AND EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant,'ecu_file'),
                       "                 WHERE ecu01=sou.ecb01 AND sou.ecb02=ecu02 )",
                       "     AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant,'ecb_file'),
                       "                    dis WHERE sou.ecb01=dis.ecb01 AND sou.ecb02=dis.ecb02 ))"
                  LET l_sql = l_sql CLIPPED

                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
                  PREPARE p001_prepare15 FROM l_sql
                  EXECUTE p001_prepare15
　　　　          IF SQLCA.sqlcode THEN
       　　          CALL cl_err('INSERT ecb_file error)',SQLCA.sqlcode,1)
        　　         LET g_success='N'
     　           END IF
              END IF
           END IF
        END IF 
END FOREACH
   
END FUNCTION
