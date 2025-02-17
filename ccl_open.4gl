# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Library name...: ccl_open.4gl
# Descriptions...: 開啟料號PDF圖面處理函式
# Date & Author..: 2019/10/18 by Momo

IMPORT os # No.FUN-B10061

DATABASE ds
GLOBALS "../../../tiptop/config/top.global"

FUNCTION ccl_open(ls_buf)
  DEFINE ls_fname    STRING,
         ls_name     STRING,
         ls_url      STRING
  DEFINE li_status   LIKE type_file.num10    #No.FUN-690005   INTEGER
  DEFINE lch_pipe    base.Channel
  DEFINE ls_buf      STRING
  DEFINE ls_tempfname  STRING       #FUN-E30028
  DEFINE ls_cmd        STRING
  DEFINE l_gcb10     LIKE gcb_file.gcb10
  DEFINE l_gca01     LIKE gca_file.gca01

  LET l_gca01 =  "ima01=" || ls_buf CLIPPED

  SELECT gcb10 INTO l_gcb10
   FROM gcb_file,gca_file
  WHERE gca07=gcb01
    AND gca01 = l_gca01
    AND  rownum=1

  LET li_status= cl_open_doc(l_gcb10)

  IF li_status = 0 THEN
     CALL cl_err('','lib-205',1)
  END IF  
END FUNCTION
