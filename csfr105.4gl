# Prog. Version..: '5.30.24-17.04.13(00000)'     #
#
# Pattern name...: csfr105.4gl
# Descriptions...: 採購單未交清單-依供應商匯整
# Date & Author..: 2026/01/06 By momo


IMPORT util
IMPORT os      
IMPORT com    

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

##----p_cron USE 
DEFINE g_wc  STRING
DEFINE g_wc2 STRING
DEFINE g_cus STRING

##---QBE USE
DEFINE tm  RECORD                # Print condition RECORD
       wc  STRING,                          # Where condition
       s      LIKE type_file.chr3,         # Order by sequence
       t      LIKE type_file.chr3,          # Eject sw
       more   LIKE type_file.chr1      # Input more condition(Y/N)
END RECORD

DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       
DEFINE   g_head1         STRING


MAIN
 OPTIONS
   INPUT NO WRAP
 DEFER INTERRUPT 
 
 IF (NOT cl_user()) THEN
      EXIT PROGRAM
 END IF

 IF (NOT cl_setup("CSF")) THEN
    EXIT PROGRAM
 END IF

 CALL cl_used(g_prog,g_time,1) RETURNING g_time
 ## ARV_VAL 皆在 p_cron 設定 
 LET g_wc = ARG_VAL(1)           #明細條件
 LET g_cus = ARG_VAL(2)          #寄送客戶否
 LET g_wc2 = ARG_VAL(3)          #客戶取得條件

 IF NOT cl_null(g_wc) THEN
    CALL send_cus_qr_mail()
 ELSE
    
 END IF
END MAIN

FUNCTION send_cus_qr_mail()
    
    DEFINE l_gdf06         LIKE gdf_file.gdf06
    DEFINE v_cnt            INTEGER

    DEFINE l_sql        STRING
    DEFINE l_body_0     LIKE zaa_file.zaa08  #繁中
    DEFINE l_subject_0  LIKE zaa_file.zaa08  #繁中
    DEFINE l_subject    LIKE zaa_file.zaa08  
    DEFINE l_body       LIKE zaa_file.zaa08
    DEFINE l_title      LIKE zaa_file.zaa08
    DEFINE l_content    LIKE zaa_file.zaa08
    DEFINE ls_temp_path STRING
    DEFINE ls_context_file  STRING
    DEFINE ls_unix_cmd      STRING
    DEFINE l_pmd02      LIKE pmd_file.pmd02
    DEFINE l_pmd07      LIKE pmd_file.pmd07
    DEFINE l_gen02      LIKE gen_file.gen02
    DEFINE l_gen06      LIKE gen_file.gen06
    DEFINE l_name       LIKE type_file.chr20
    DEFINE l_sfb          RECORD LIKE sfb_file.*
    
    #-- 依LOG工單確認執行
    LET l_sql = "SELECT azo05 ",
                "  FROM azo_file ",
                " WHERE azo01='asfi301' ",
                "      AND azo05='T4011-260301457' "
             #   "   AND azo03= '",g_today,"' "

    PREPARE q_precur FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('P1:',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    DECLARE q_cur CURSOR FOR q_precur
    FOREACH q_cur INTO l_sfb.sfb01

    CALL cus_mail(l_sfb01,'asfi301')

    END FOREACH
        
END FUNCTION
