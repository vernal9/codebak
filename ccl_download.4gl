# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Library name...: ccl_download.4gl
# Descriptions...: 料件圖檔下載
# Date & Author..: 20230906
# Modify.........: No.23120013 20231213 By momo asf 調整為可直接開啟圖檔

IMPORT os # No.FUN-B10061

DATABASE ds
GLOBALS "../../../tiptop/config/top.global"
 
#參1：料件編號
#參2：檔案類型： pdf/dwg
##########################################################################
FUNCTION ccl_download(ls_fname,ls_name)
  DEFINE ls_fname      STRING,
         ls_name       STRING,
         ls_url        STRING
  DEFINE li_status     LIKE type_file.chr10
  DEFINE ls_tempfname  STRING       
  DEFINE ls_msg_syslog STRING       
  DEFINE re_gcb10 LIKE gcb_file.gcb10
  DEFINE l_smaud02     LIKE sma_file.smaud02  #pdf路徑
  DEFINE l_smaud03     LIKE sma_file.smaud03  #dwg路徑
  
  #-- //192.168.1.210/pdf$ mount /u1/out/pdf/
  #-- //192.168.1.210/dwg$ mount /u1/out/dwg/
  LET l_smaud02='/u1/out/pdf/'
  LET l_smaud03='/u1/out/dwg/'

  IF g_plant = 'NM' THEN
     ERROR "NM 營運中心，尚無此功能可使用，若需使用請洽MIS"
     RETURN
  END IF

  CASE ls_name
       WHEN 'pdf'
            LET re_gcb10=l_smaud02,ls_fname,".",ls_name
       WHEN 'dwg'
            LET re_gcb10=l_smaud03,ls_fname,".",ls_name
  END CASE

  CALL cl_download_file(re_gcb10 CLIPPED,"d:/tiptop/"|| ls_fname||"."||ls_name CLIPPED) RETURNING li_status
  IF li_status = '1' THEN
     DISPLAY "Success"
  ELSE
     ERROR "檢查是否存在 d:/tiptop/ 路徑，若存在則表示尚無該檔可下載"
     RETURN
  END IF
      IF g_prog= 'asfi511' THEN                                                                #20231213 add
         CALL cl_open_doc("d:/tiptop/"|| ls_fname||"."||ls_name CLIPPED) RETURNING li_status   #20231213 add
      ELSE                                                                                     #20231213 add
         CALL cl_open_doc("d:/tiptop/") RETURNING li_status
      END IF                                                                                   #20231213 add
     #CALL cl_open_doc("d:/tiptop/"|| ls_fname||"."||ls_name CLIPPED) RETURNING li_status
  #進行系統紀錄 p_syslog 查看
     LET ls_msg_syslog = "Download document: ",
                          g_prog CLIPPED,"--",ls_fname CLIPPED,"--",
                          ls_name CLIPPED
     IF cl_syslog("A","G",ls_msg_syslog) THEN END IF
  
END FUNCTION 
