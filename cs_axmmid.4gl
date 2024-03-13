# Prog. Version..: '5.30.24-17.04.13(00003)'     #
#
# Program name...: cs_axmmid.4gl
# Descriptions...: 銷售中介檔寫入
# Date & Author..: 20240312 By momo
# Usage..........: CALL cs_axmmid(p_no,p_prog) RETURNING l_avguse
# Input PARAMETER: p_no    單據編號
#                  p_prog  程式代號
# RETURN Code....: l_success 成功否


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"   #FUN-7C0053

FUNCTION cs_axmmid(l_no,l_prog)
DEFINE
   l_no      LIKE oea_file.oea01,    #單據編號
   l_line    LIKE type_file.num5,    #單據項次
   l_prog    LIKE type_file.chr10    #程式代號
  

   WHENEVER ERROR CALL cl_err_msg_log

   #--axms050 銷售參數控制
   IF g_oaz.oazud02 != 'Y' OR cl_null(g_oaz.oazud02) THEN RETURN END IF    
   
   #-- 整張單據，拋轉狀態皆改為 0
   #-- TABLE location TY 其餘正式營運中心如需使用，再將 TABLE設定 SYN
   UPDATE tc_mid_file SET tc_mid04=0 WHERE tc_mid01=l_no

   #--單據編號、項次、程式代號 寫入中介檔
   CASE l_prog
        WHEN "axmt360"
          INSERT INTO ty_test.tc_mid_file SELECT oqu01,oqu02,'axmt360',0 FROM oqu_file 
                                           WHERE oqu01=l_no
                                             AND NOT EXISTS(SELECT 1 FROM tc_mid_file WHERE oqu01=tc_mid01 AND oqu02=tc_mid02)
        WHEN "axmt410"
          INSERT INTO ty_test.tc_mid_file SELECT oeb01,oeb03,'axmt410',0 FROM oeb_file 
                                           WHERE oeb01=l_no
                                             AND NOT EXISTS(SELECT 1 FROM tc_mid_file WHERE oeb01=tc_mid01 AND oeb03=tc_mid02)
        WHEN "axmt620"
          INSERT INTO ty_test.tc_mid_file SELECT ogb01,ogb03,'axmt410',0 FROM ogb_file 
                                           WHERE ogb01=l_no
                                             AND NOT EXISTS(SELECT 1 FROM tc_mid_file WHERE ogb01=tc_mid01 AND ogb03=tc_mid02)
        WHEN "axmi221"
          INSERT INTO ty_test.tc_mid_file SELECT occ01,0,'axmi221',0 FROM occ_file WHERE occ01=l_no
  
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","tc_mid_file",l_no,l_line,SQLCA.sqlcode,"","",1)  
      END IF
   END CASE


END FUNCTION
