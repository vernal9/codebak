# Prog. Version..: '5.30.24-17.04.13(00003)'     #
#
# Program name...: cs_gen_mail.4gl
# Descriptions...: zaa 報表抓取
# Date & Author..: 20260105 By momo
# Usage..........: CALL cs_gen_rep(p_prog) RETURNING l_content,l_title,l_subject
# Input PARAMETER: p_prog 程式代號=報表代號, p_rlang 語言別
# RETURN Code....: l_body 信件內文, l_subject 主旨


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"   #FUN-7C0053

FUNCTION cs_gen_mail(p_prog,p_rlang)
DEFINE
   l_content   LIKE zaa_file.zaa08,    #信件內文
   l_body      LIKE zaa_file.zaa08,    #信件內文
   l_title     LIKE zaa_file.zaa08,    #表格抬頭
   l_subject   LIKE zaa_file.zaa08,    #信件主旨
   p_rlang     LIKE zaa_file.zaa03,    #語言別
   p_prog      LIKE zaa_file.zaa01     #報表代號=程式代號
DEFINE 
   l_sql       STRING


   LET l_body=''
   LET l_content = ''
   LET l_subject = ''
   LET l_title = ''
 
   #---MAIL內文 
   LET l_sql = "SELECT zaa08 FROM zaa_file ",
                " WHERE zaa01='",p_prog,"' AND zaa09='1' AND zaa14='G' AND zaa03='",p_rlang,"' AND zaa11='mail' ",
                " ORDER BY zaa02 "
   PREPARE q_bodycur FROM l_sql
   DECLARE q_body CURSOR FOR q_bodycur
   FOREACH q_body INTO l_content
      LET l_body = l_body , "<p>",  l_content , "</p>"
   END FOREACH

   LET l_body = l_body ||  "<table border=""1"" cellpadding=""4"" cellspacing=""0""><tr>"
   ##--TABLE title
   LET l_sql = "SELECT zaa08 FROM zaa_file ",
               " WHERE zaa01='",p_prog,"' AND zaa09='2' AND zaa14='G' AND zaa03='",p_rlang,"' AND zaa11='mail' ",
               " ORDER BY zaa02 "
   PREPARE q_titlecur FROM l_sql
   DECLARE q_title CURSOR FOR q_titlecur
   FOREACH q_title INTO l_title
      LET l_body = l_body , "<th>" , l_title || "</th>"
   END FOREACH


   ##---主旨
   SELECT zaa08 INTO l_subject FROM zaa_file
    WHERE zaa03 = p_rlang
      AND zaa09 = '1' AND zaa14='J'
      AND zaa01 = p_prog AND zaa11='mail'

   RETURN l_subject,l_body

  
END FUNCTION
  


