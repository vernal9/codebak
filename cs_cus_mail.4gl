# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Program name...: cs_cus_mail.4gl
# Description....: 提供客戶MAIL寄送
# Date & Author..: 2021/10/07
# 

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cus_mail(l_sfb01,g_prog)
  DEFINE g_prog         STRING
  DEFINE l_cmd          STRING #LIKE type_file.chr1000 
  DEFINE l_oce03        LIKE   oce_file.oce03          #連絡人
  DEFINE l_oce05        LIKE   oce_file.oce05          #Email
  DEFINE l_zo02         LIKE   zo_file.zo02
  DEFINE l_subject      STRING   #主旨
  DEFINE l_body         STRING   #內文路徑
  DEFINE l_recipient    STRING   #收件者
  DEFINE l_cnt          LIKE   type_file.num5 
  DEFINE l_cnt1         LIKE   type_file.num5  
  DEFINE l_wc           STRING
  DEFINE l_sql          STRING
  DEFINE ls_context        STRING
  DEFINE ls_temp_path      STRING
  DEFINE ls_context_file   STRING
  DEFINE ls_unix_cmd       STRING  
  DEFINE l_oea01        LIKE oea_file.oea01
  DEFINE l_ta_sfb01     LIKE sfb_file.ta_sfb01 
  DEFINE l_sfb01        LIKE sfb_file.sfb01    #20241025
  DEFINE l_oea          RECORD LIKE oea_file.*
  DEFINE i              LIKE type_file.num5      
  DEFINE l_d            LIKE type_file.chr1 
  DEFINE l_gen06        LIKE gen_file.gen06 
  DEFINE l_gen02        LIKE gen_file.gen02 
  DEFINE l_occ21        LIKE occ_file.occ21
  DEFINE g_msg          LIKE type_file.chr1000
  DEFINE g_zo041        LIKE zo_file.zo041     #Address

  ##---- 20240925 add (S) 進程式前即判斷是否有需處理的資料
  IF g_prog = 'asfi301' THEN
     SELECT SUBSTR(ta_sfb01,1,15),ta_sfb01
       INTO l_oea01,l_ta_sfb01
       FROM sfa_file,sfb_file
      WHERE sfa01=sfb01 
        AND sfb87 = 'Y'
        AND sfb04 < '8'
        AND sfa03 LIKE '5%' 
        AND sfa05 > 0
        AND NOT EXISTS(SELECT * FROM oeo_file 
                        WHERE oeo01||LPAD(oeo03,3,'0')=ta_sfb01 AND oeo04=sfa03)
        AND ROWNUM = 1
        AND sfb01 = l_sfb01
      IF cl_null(l_oea01) THEN 
         RETURN
      END IF
  END IF
  ##---- 20240925 add (E)

  SELECT * INTO l_oea.*
    FROM oea_file 
   WHERE oea01 = l_oea01
      
  #收件者
  LET l_recipient = ''
  LET l_gen06=''
  LET l_gen02='' 

  SELECT gen06,gen02 INTO l_gen06,l_gen02 FROM gen_file
   WHERE gen01 = l_oea.oea14 
     AND gen06 IS NOT NULL 
                      
  DECLARE r400_oce_c CURSOR FOR
     SELECT oce03,oce05 FROM oce_file
      WHERE oce01 = l_oea.oea03
        AND oce05 IS NOT NULL
        AND nvl(oce02,' ') <> '電子發票'                         
     
     LET i = 0                                                           
     FOREACH r400_oce_c INTO l_oce03,l_oce05
        LET i = i + 1
        IF i = 1 THEN
           LET l_recipient = l_recipient CLIPPED,l_oce05 CLIPPED,":",l_oce03 CLIPPED ,":","1" CLIPPED
        ELSE
           LET l_recipient = l_recipient CLIPPED ,";",l_oce05 CLIPPED,":",l_oce03 CLIPPED ,":","1" CLIPPED
        END IF
     END FOREACH
     
     LET l_recipient =l_recipient CLIPPED ,";",l_gen06 CLIPPED,":",l_gen02 CLIPPED ,":","1" CLIPPED 
     
         
     LET g_xml.recipient = l_recipient
     CALL FGL_SETENV("MAIL_TO",l_recipient)


  IF g_prog = 'asfi301' THEN
  #客供料QRCode--s--       
     LET l_subject = "東佑達(",l_oea.oea032 CLIPPED ,")客供品QR CODE通知-",l_ta_sfb01 CLIPPED ,"_",l_oea.oea10
     LET g_xml.subject = l_subject 
     LET g_xml.body = 'cxm-QR'       #20250821 搭配調整 cl_prt 依plant 列印 地址
     #LET l_wc = "oea01='",l_oea.oea01 CLIPPED,"'"                                #20241025 mark
     LET l_wc = "sfb01='",l_sfb01,"' and oea01='",l_oea.oea01 CLIPPED,"'"         #20241025 modify
     LET l_wc = cl_replace_str(l_wc,"'","\"")     
     CALL FGL_SETENV("FGLGUI","0")
     LET l_cmd = "cxmr401 '", 
                  g_today,"' '",g_user CLIPPED,"' '",
                  g_rlang,"' 'Y' 'A' '1' '",l_wc CLIPPED,
                  "' 'Y' 'default' 'default' 'cxmr401' '",g_xml.subject,"' '",g_xml.body,"' '",g_xml.recipient,"' 'cxmr401_0_std'"                                  
     CALL cl_cmdrun(l_cmd)  
     LET g_msg = TIME                                                                              #20240924 
     LET g_xml.subject = g_xml.subject[1,79]
     INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)                  #20240924
          VALUES ('asfi301',g_user,g_today,g_msg,l_sfb01,g_xml.subject,g_plant,g_legal)           #20241025
     CALL FGL_SETENV("FGLGUI","1")
     CALL cl_err('','afa-116',0)
  #客供料QRCode--e--    
  END IF  
END FUNCTION
