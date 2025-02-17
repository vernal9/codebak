# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Program name...: cs_cus_mail.4gl
# Description....: 提供客戶MAIL寄送
# Date & Author..: 2021/10/07
# 

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cus_mail(l_oea01,g_prog)
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
  DEFINE l_oea          RECORD LIKE oea_file.*
  DEFINE i              LIKE type_file.num5      
  DEFINE l_d            LIKE type_file.chr1 
  DEFINE l_gen06        LIKE gen_file.gen06 
  DEFINE l_gen02        LIKE gen_file.gen02 
  DEFINE l_occ21        LIKE occ_file.occ21
  DEFINE g_msg          LIKE type_file.chr1000

  ##---- 20240925 add (S) 進程式前即判斷是否有需處理的資料
  IF g_prog = 'asfi301' THEN
     LET l_cnt=0
     SELECT 1 INTO l_cnt FROM sfa_file,sfb_file
      WHERE sfa01=sfb01 AND SUBSTR(ta_sfb01,1,15)=l_oea01
        AND sfb87 = 'Y'
        AND sfb04 < '8'
        AND sfa03 LIKE '5%' AND sfa05 > sfa06
        AND NOT EXISTS(SELECT * FROM oeo_file WHERE oeo01=l_oea01 AND oeo04=sfa03)
        AND ROWNUM = 1
      IF l_cnt = 0 OR cl_null(l_cnt) THEN 
         RETURN
      END IF
  END IF
  ##---- 20240925 add (E)

  SELECT * INTO l_oea.*
    FROM oea_file 
   WHERE oea01 = l_oea01
  
  SELECT occ21 INTO l_occ21 
    FROM occ_file,oea_file
    WHERE occ01 = oea03
      AND oea01 = l_oea01
      
       #收件者
         LET l_recipient = ''
         LET l_gen06=''
         LET l_gen02='' 
           SELECT gen06,gen02 INTO l_gen06,l_gen02 FROM gen_file
             WHERE gen01 = l_oea.oea14                             
         DECLARE r400_oce_c CURSOR FOR
                 SELECT oce03,oce05 FROM oce_file
                   WHERE oce01 = l_oea.oea03
                     AND oce05 IS NOT NULL
                     AND nvl(oce02,' ') <> '電子發票'                         
                   ORDER BY oce03
         LET i = 0                                                           
         FOREACH r400_oce_c INTO l_oce03,l_oce05
           LET i = i + 1
           IF i = 1 THEN
              LET l_recipient = l_recipient CLIPPED,l_oce05 CLIPPED,":",l_oce03 CLIPPED ,":","1" CLIPPED
           ELSE
              LET l_recipient = l_recipient CLIPPED ,";",l_oce05 CLIPPED,":",l_oce03 CLIPPED ,":","1" CLIPPED
           END IF
         END FOREACH
         
           LET l_cnt=0
           SELECT COUNT(*) INTO l_cnt FROM oce_file 
             WHERE oce01 = l_oea.oea03 AND oce05 IS NOT NULL AND nvl(oce02,' ') <> '電子發票'   
           IF l_cnt>0 THEN                                     
              LET l_recipient =l_recipient CLIPPED ,";",l_gen06 CLIPPED,":",l_gen02 CLIPPED ,":","1" CLIPPED 
           ELSE
              LET l_recipient =l_recipient CLIPPED ,l_gen06 CLIPPED,":",l_gen02 CLIPPED ,":","1" CLIPPED  
           END IF          
         LET g_xml.recipient = l_recipient
         CALL FGL_SETENV("MAIL_TO",l_recipient)
  IF g_prog = 'axmt410' THEN  
  #訂單交期通知 --s--
       #主旨                                            #要發 訂單交期(axmr400)
        #SELECT zo02 INTO l_zo02  FROM zo_file  WHERE zo01 = g_lang
        #LET l_subject = cl_getmsg("apm-795",g_lang) CLIPPED,l_zo02 CLIPPED,
        #                cl_getmsg("axm-796",g_lang) CLIPPED,l_oea.oea01  
        IF l_occ21='TW' OR l_occ21='CN' THEN
          LET l_subject = "東佑達(",l_oea.oea032 CLIPPED ,")交期通知-",l_oea.oea01 CLIPPED ,"_",l_oea.oea10
          LET g_xml.subject = l_subject 
          LET g_xml.body = 'cxm-029'          
        END IF
        IF l_occ21='JP' THEN
          LET l_subject = "TOYO(",l_oea.oea032 CLIPPED ,")納期のお知らせ-",l_oea.oea01 CLIPPED ,"_",l_oea.oea10
          LET g_xml.subject = l_subject  
          LET g_xml.body = 'cxm-030'                  
        END IF                  
        IF l_occ21<>'TW' AND l_occ21<>'CN' AND l_occ21<>'JP' THEN
          LET l_subject = "TOYO(",l_oea.oea032 CLIPPED ,")delivery notice-",l_oea.oea01 CLIPPED ,"_",l_oea.oea10
          LET g_xml.subject = l_subject   
          LET g_xml.body = 'cxm-031'                 
        END IF
 
       #內文
       #LET ls_context = cl_getmsg("apm-799",g_lang) CLIPPED   
       #LET ls_temp_path = FGL_GETENV("TEMPDIR")
       #LET ls_context_file = ls_temp_path,"/axmr400_context_" || FGL_GETPID() || ".txt"
       #LET ls_unix_cmd = "echo '" || ls_context || "' > " || ls_context_file
       #RUN ls_unix_cmd WITHOUT WAITING
       #LET g_xml.file = "axmr400_cn_" || FGL_GETPID() || ".xml"
       #LET g_xml.body = ls_context_file       
           
         LET l_wc = "oea01='",l_oea.oea01 CLIPPED,"'",
                    " AND oea02='",l_oea.oea02 CLIPPED,"'",
                    " AND oea14='",l_oea.oea14 CLIPPED,"'"
         LET l_wc = cl_replace_str(l_wc,"'","\"")
         CALL FGL_SETENV("MAIL_TO",l_recipient)  
         
         IF l_occ21='TW' OR l_occ21='CN' THEN             
           LET l_cmd = "axmr400 '", 
                        g_today,"' '",g_user CLIPPED,"' '",
                        g_rlang,"' 'Y' 'A' '1' '",l_wc CLIPPED,
                        "' 'Y' 'Y' 'N' 'default' 'default' 'axmr400' 'Y' 'N' '",g_xml.subject,"' '",g_xml.body,"' '",g_xml.recipient,"' 'axmr400_0_std'"                                  
           CALL cl_cmdrun(l_cmd)
         ELSE
           LET l_cmd = "axmr400 '", 
                        g_today,"' '",g_user CLIPPED,"' '",
                        g_rlang,"' 'Y' 'A' '1' '",l_wc CLIPPED,
                        "' 'Y' 'Y' 'N' 'default' 'default' 'axmr400' 'Y' 'N' '",g_xml.subject,"' '",g_xml.body,"' '",g_xml.recipient,"' 'axmr400_0_std_3'"                                  
           CALL cl_cmdrun(l_cmd)         
         END IF
  #訂單交期通知--e--
  END IF
  IF g_prog = 'asfi301' THEN
  #客供料QRCode--s--       
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM sfa_file,sfb_file
          WHERE sfa01=sfb01 AND SUBSTR(ta_sfb01,1,15)=l_oea01
            AND sfa03 LIKE '5%' AND sfa05 > sfa06
            AND NOT EXISTS(SELECT * FROM oeo_file WHERE oeo01=l_oea01 AND oeo04=sfa03)

         IF l_cnt>0 THEN                                
           #主旨
           #SELECT zo02 INTO l_zo02  FROM zo_file  WHERE zo01 = g_lang
           #LET l_subject = cl_getmsg("apm-795",g_lang) CLIPPED,l_zo02 CLIPPED,
           #                cl_getmsg("axm-796",g_lang) CLIPPED,l_oea.oea01  
           LET l_subject = "東佑達(",l_oea.oea032 CLIPPED ,")客供品QR CODE通知-",l_oea.oea01 CLIPPED ,"_",l_oea.oea10
           LET g_xml.subject = l_subject 
           LET g_xml.body = 'cxm-032'   
           LET l_wc = "oea01='",l_oea.oea01 CLIPPED,"'"
           LET l_wc = cl_replace_str(l_wc,"'","\"")     
           CALL FGL_SETENV("FGLGUI","0")
           LET l_cmd = "cxmr401 '", 
                        g_today,"' '",g_user CLIPPED,"' '",
                        g_rlang,"' 'Y' 'A' '1' '",l_wc CLIPPED,
                        "' 'Y' 'default' 'default' 'cxmr401' '",g_xml.subject,"' '",g_xml.body,"' '",g_xml.recipient,"' 'cxmr401_0_std'"                                  
           CALL cl_cmdrun(l_cmd)  
           LET g_msg = TIME                                                                              #20240924 
           INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)                   #20240924
                       VALUES ('asfi301',g_user,g_today,g_msg,l_oea.oea01,g_xml.subject,g_plant,g_legal)  #20240924
           CALL FGL_SETENV("FGLGUI","1")
         END IF  
  #客供料QRCode--e--    
END IF  
END FUNCTION
