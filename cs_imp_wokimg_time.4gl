# Prog. Version..: '5.30.24-17.04.13(00000)'     #
#
# Pattern name...: cs_imp_working_time.4gl
# Descriptions...: #匯入機工時
# Date & Author..: 2026/03/20 By momo
# Modify.........: NO.26030110  2026/03/26 修正 SQL語法錯誤問題

DATABASE ds

GLOBALS "../../../tiptop/config/top.global" 

FUNCTION import_working_time()             #匯入機工時
   DEFINE l_data          DYNAMIC ARRAY OF RECORD
                          data01,data02,data03,data04,data05,
                          data06,data07,data08,data09,data10,
                          data11,data12,data13,data14,data15,
                          data16,data17,data18,data19,data20   
                          STRING
                          END RECORD
   DEFINE l_target        STRING           # 記錄$TEMPDIR的路徑
   DEFINE l_source        STRING           # 記錄來源的路徑
   DEFINE l_filename      STRING     
   DEFINE l_filename2     STRING
   DEFINE l_tok           base.StringTokenizer 
   DEFINE l_channel       base.Channel
   DEFINE l_content       STRING
   DEFINE l_value         STRING
   DEFINE g_pid           STRING
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_eof           LIKE type_file.num10
   DEFINE l_cmd           STRING
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE g_cnt           LIKE type_file.num5
   DEFINE g_tot_cnt       LIKE type_file.num5
   DEFINE l_file_address  STRING
   DEFINE l_ecu01         LIKE ecu_file.ecu01
   DEFINE l_ecu02         LIKE ecu_file.ecu02
   DEFINE l_ecb03         LIKE ecb_file.ecb03
   DEFINE l_ecb06         LIKE ecb_file.ecb06
   DEFINE l_ecb06_t       LIKE ecb_file.ecb06
   DEFINE l_ecb19         LIKE ecb_file.ecb19
   DEFINE l_ecb21         LIKE ecb_file.ecb21
   DEFINE l_str           STRING
   DEFINE l_line          STRING
   DEFINE l_sql           STRING

   IF s_shut(0) THEN
      RETURN
   END IF

   OPEN WINDOW i100_d WITH FORM "cec/42f/aeci100_d"   #打開畫面aeci100_d
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("aeci100_d")

   CALL cl_set_act_visible("accept,cancel", TRUE)
   INPUT l_file_address FROM file_address

      ON ACTION browser2
         LET l_file_address = cl_browse_file()
         DISPLAY l_file_address TO FORMONLY.file_address

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
  
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()

   END INPUT
   
   CLOSE WINDOW i100_d

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   BEGIN WORK
   LET g_success = "Y"
   CALL s_showmsg_init()
   LET g_totsuccess = 'Y'
   LET g_tot_cnt = 0    #紀錄成功筆數
   #資料撈完開始做處理

   WHILE TRUE

      LET g_pid = FGL_GETPID()
      LET g_pid = g_pid.trim()
      #上傳檔案
      LET l_filename= g_prog CLIPPED,"_",g_pid CLIPPED
      LET l_target = FGL_GETENV("TEMPDIR")                           #目的路徑
      LET l_target = l_target CLIPPED,"/",l_filename CLIPPED,".csv"  #目的路徑+檔名
      LET l_source = l_file_address CLIPPED                          #來源路徑
      IF NOT cl_upload_file(l_source,l_target) THEN                  #上傳
         #文件檔案傳輸失敗
         CALL cl_err(l_file_address,'lib-212',0)
         LET g_success = 'N'
         EXIT WHILE
      END IF

      LET l_filename2 =FGL_GETENV("TEMPDIR"),"/",g_prog CLIPPED,"_",g_pid CLIPPED,"_1.csv"  
      LET l_cmd ="iconv -f big5 -t utf8 ",l_target CLIPPED,">",l_filename2
      RUN l_cmd

      LET l_channel = base.Channel.create()
      CALL l_channel.openFile(l_filename2,"r")
      IF STATUS THEN
         CALL s_errmsg('','',l_file_address,'-880',1)
         LET g_success = 'N'
         CALL l_channel.close()
         EXIT WHILE
      END IF

      IF g_success = 'Y' THEN
         LET g_cnt = 1
         LET l_cnt = 1
         LET l_eof = l_channel.isEof()
         WHILE NOT l_eof
            LET l_content = l_channel.readLine()

            LET l_tok = base.StringTokenizer.createExt(l_content,",","",TRUE)
            WHILE l_tok.hasMoreTokens() 
                    LET l_value = l_tok.nextToken()
                    LET l_data[l_cnt].data01 = l_value.subString(l_value.getIndexOf("'",1) + 1,l_value.getLength())
                    LET l_value = l_tok.nextToken()
                    LET l_data[l_cnt].data02 = l_value.subString(l_value.getIndexOf("'",1) + 1,l_value.getLength())
                    LET l_data[l_cnt].data03 =l_tok.nextToken()
                    LET l_value = l_tok.nextToken()
                    LET l_data[l_cnt].data04 = l_value.subString(l_value.getIndexOf("'",1) + 1,l_value.getLength())
                    LET l_data[l_cnt].data05 =l_tok.nextToken()
                    LET l_data[l_cnt].data06 =l_tok.nextToken()
            END WHILE
            LET l_cnt=l_cnt+1
            LET l_eof = l_channel.isEof()
         END WHILE
         CALL l_channel.close()
      END IF

      IF g_success = 'N' THEN
         EXIT WHILE
      END IF

      #第一行為欄位代號,第二行為欄位名稱,從第三行開始
      FOR l_i = 3 TO l_data.getLength()
         IF g_success = 'N' THEN
            LET g_totsuccess = 'N'
            LET g_success = 'Y'
         END IF
         LET l_line = "Line",l_i,":"
         LET l_ecu01  = l_data[l_i].data01
         LET l_ecu02  = l_data[l_i].data02
         LET l_ecb03  = l_data[l_i].data03
         LET l_ecb06  = l_data[l_i].data04
         LET l_ecb19  = l_data[l_i].data05
         LET l_ecb21  = l_data[l_i].data06
         
         #確認必要欄位是否為空值
         IF cl_null(l_ecu01) AND cl_null(l_ecu02) AND cl_null(l_ecb03) AND cl_null(l_ecb06) AND cl_null(l_ecb19) AND cl_null(l_ecb21) THEN
            CONTINUE FOR
         ELSE
            LET l_str = ''
            IF cl_null(l_ecu01) THEN
                  LET l_str = l_str,"ecu01"
            END IF
            IF cl_null(l_ecu02) THEN
               IF cl_null(l_str) THEN
                  LET l_str = l_str,"ecu02"
               ELSE
                  LET l_str = l_str,",ecu02"
               END IF
            END IF
            IF cl_null(l_ecb03) THEN
               IF cl_null(l_str) THEN
                  LET l_str = l_str,"ecb03"
               ELSE
                  LET l_str = l_str,",ecb03"
               END IF
            END IF
            IF cl_null(l_ecb06) THEN
               IF cl_null(l_str) THEN
                  LET l_str = l_str,"ecb06"
               ELSE
                  LET l_str = l_str,",ecb06"
               END IF
            END IF
            IF cl_null(l_ecb19) THEN
               IF cl_null(l_str) THEN
                  LET l_str = l_str,"ecb19"
               ELSE
                  LET l_str = l_str,",ecb19"
               END IF
            END IF
            IF cl_null(l_ecb21) THEN
               IF cl_null(l_str) THEN
                  LET l_str = l_str,"ecb21"
               ELSE
                  LET l_str = l_str,",ecb21"
               END IF
            END IF
            IF NOT cl_null(l_str) THEN
               LET g_success = 'N'
               CALL s_errmsg(l_str,"",l_line,"alm-917",1)
               CONTINUE FOR
            END IF
         END IF

         #檢查人工工時/機時不可小於零
         IF l_ecb19 < 0 OR l_ecb21 < 0 THEN
            LET g_success = "N"
            IF l_ecb19 < 0 THEN
               CALL s_errmsg("ecb19",l_ecb19,l_line,"TSD0018",1)     #人工工時/機時不可小於零
            END IF
            IF l_ecb21 < 0 THEN
               CALL s_errmsg("ecb21",l_ecb21,l_line,"TSD0018",1)     #人工工時/機時不可小於零
            END IF
            CONTINUE FOR
         END IF

         #LET l_cnt = 0
         #SELECT 1 INTO l_cnt
         #  FROM ecu_file
         # WHERE ecu01 = l_ecu01 AND ecu02 = l_ecu02
         #   AND rownum = 1
         #IF l_cnt = 0 THEN
         #   LET g_success = 'N'
         #   LET l_str = ''
         #   LET l_str = l_ecu01,"/",l_ecu02
         #   CALL s_errmsg("ecu01,ecu02",l_str,l_line,"TSD0015",1)     #該料號+製程編號不存在資料
         #   CONTINUE FOR
         #END IF

         LET l_cnt = 0
         LET l_ecb06_t = ''
         IF cl_null(g_plant_new) THEN
            LET g_plant_new = g_plant         
         END IF
         LET l_sql = "SELECT 1,ecb06 ",
                     " FROM ",cl_get_target_table(g_plant_new,'ecb_file'),
                     " WHERE ecb01 = '",l_ecu01,"' AND ecb02 = '",l_ecu02,"' ",
                     "   AND ecb03 = '",l_ecb03,"' AND ecb012 = ' ' ",
                     "   AND rownum = 1 "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
         PREPARE check_exists FROM l_sql
         EXECUTE check_exists INTO l_cnt,l_ecb06_t
         IF l_cnt = 0 THEN
            LET g_success = 'N'
            LET l_str = ''
            LET l_str = l_ecu01,"/",l_ecu02,"/",l_ecb03
            CALL s_errmsg("ecb01,ecb02,ecb03",l_str,l_line,"TSD0016",1)     #該料號+製程編號+製程序不存在資料
            CONTINUE FOR
         END IF
         IF l_ecb06 <> l_ecb06_t THEN
            LET g_success = 'N'
            CALL s_errmsg("ecb06",l_ecb06,l_line,"TSD0017",1)               #對應的作業編號與匯入的作業編號不符
            CONTINUE FOR
         END IF   
 
         LET l_sql = "UPDATE ", cl_get_target_table(g_plant_new,'ecb_file'), #20260326
                     " SET ecb19  = ? ",    
                     "    ,ecb21  = ? ", 
                     " WHERE ecb01 = ? ",
                     " AND ecb02 = ? ",
                     " AND ecb03 = ? ",
                     " AND ecb012 = ' ' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
         PREPARE upd_ecb_time FROM l_sql
         EXECUTE upd_ecb_time USING l_ecb19,l_ecb21,l_ecu01,l_ecu02,l_ecb03
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            IF SQLCA.sqlcode = 0 THEN 
               LET SQLCA.sqlcode = 9050 
            END IF
            LET g_success = 'N'
            CALL s_errmsg('','','upd ecb_file',SQLCA.sqlcode,1)
            CONTINUE FOR
         END IF
         LET g_tot_cnt = g_tot_cnt + 1
      END FOR

      LET l_cmd = 'chmod 777 ',l_filename2 
      LET l_cmd = 'rm ',l_filename2
      RUN l_cmd
      LET l_cmd = 'chmod 777  ',l_target
      LET l_cmd = 'rm ',l_target
      RUN l_cmd

      EXIT WHILE
   END WHILE

   IF g_totsuccess = 'N' THEN
      LET g_success = 'N'
   END IF

   IF g_success = 'Y' AND g_tot_cnt = 0 THEN
      #無資料產生
      CALL cl_err('','axc-034',1)
      LET g_success = 'N'
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_err('','9062',1)     #資料更新成功
   ELSE
      ROLLBACK WORK
   END IF
   CALL s_showmsg()

END FUNCTION
