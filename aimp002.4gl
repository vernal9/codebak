# Prog. Version..: '5.30.24-17.04.13(00008)'     #
#
# Pattern name...: aimp002.4gl
# Descriptions...: 
# Date & Author..: 10/03/20 By dxfwo
# Modify.........: No:FUN-8C0131 10/02/22 by dxfwo  
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.MOD-CB0143 12/11/23 By Elise 應一併update img37
# Modify.........: No:MOD-E80116 14/08/20 By Summer 更新img37時的邏輯,增加判斷沒有tlf_file資料的情況 
# Modify.........: No:FUN-E90045 15/08/26 By Mandy 加入更新最近入/出庫日期
# Modify.........: No:MOD-G50040 16/05/06 By Ann_Huang  調整背景執行傳入參數
# Modify.........: No:           19/03/20 By Ruby 新增條件tlf10<>0，否則調整單會被計入
# Modify.........: No:           20240422 By momo 料件更新，條件過瀘SQL調整

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE g_wc,g_sql       string                    
DEFINE g_cnt            LIKE type_file.num10   
DEFINE g_change_lang    LIKE type_file.chr1    
DEFINE g_choice         LIKE type_file.chr1 #FUN-E90045 add
       
#No.FUN-8C0131
MAIN
   DEFINE l_flag        LIKE type_file.chr1    

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   #MOD-G50040  --- mark Start ---
   #LET g_tlf.tlf01=ARG_VAL(1)
   #LET g_tlf.tlf902=ARG_VAL(2)
   #LET g_tlf.tlf903=ARG_VAL(3)
   #LET g_tlf.tlf904=ARG_VAL(4)
   #LET g_tlf.tlf61=ARG_VAL(5)         
   #LET g_bgjob = ARG_VAL(6)
   #LET g_choice = ARG_VAL(7) #FUN-E90045 add
   #MOD-G50040  --- mark End ---
   #MOD-G50040  --- add Start ---
   LET g_wc = ARG_VAL(1)
   LET g_bgjob = ARG_VAL(2)
   LET g_choice = ARG_VAL(3)
   #MOD-G50040  --- add End ---
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
   #FUN-E90045--add---str--
   IF cl_null(g_choice) THEN
       LET g_choice = 'Y'
   END IF
   #FUN-E90045--add---end--

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   WHILE TRUE
      LET g_success = 'Y'
      IF g_bgjob = 'N' THEN
         CALL p002_p1()
         IF cl_sure(0,0) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p002_p2()
            #CALL cl_end(0,0)    #20231102 mark
            IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag    
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag   
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p002_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         CALL p002_p2()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF

 END WHILE

 CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN

FUNCTION p002_p1()
DEFINE lc_cmd        LIKE type_file.chr1000 
DEFINE p_row,p_col   LIKE type_file.num5    

 OPEN WINDOW p002_w AT p_row,p_col
      WITH FORM "aim/42f/aimp002"
      ATTRIBUTE (STYLE = g_win_style)

 CALL cl_ui_init()

 LET g_bgjob = 'N'

 WHILE TRUE
   CALL cl_opmsg('z')
   CONSTRUCT BY NAME g_wc ON tlf01,tlf902,tlf903,tlf904,tlf61
   BEFORE CONSTRUCT 
      CALL cl_qbe_init()
      
      ON ACTION CONTROLP
       CASE 
        WHEN INFIELD(tlf01)
#FUN-AA0059 --Begin--
       #  CALL cl_init_qry_var()
       #  LET g_qryparam.form ="q_ima"
       #  CALL cl_create_qry() RETURNING g_tlf.tlf01
         CALL q_sel_ima(FALSE, "q_ima", "", g_tlf.tlf01, "", "", "", "" ,"",'' )  RETURNING g_tlf.tlf01
#FUN-AA0059 --End--
         DISPLAY BY NAME g_tlf.tlf01
         NEXT FIELD tlf01
        WHEN INFIELD(tlf902)
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_imd01"
         LET g_qryparam.state = "c"
         CALL cl_create_qry() RETURNING g_tlf.tlf902
         DISPLAY BY NAME g_tlf.tlf902
         NEXT FIELD tlf902
        WHEN INFIELD(tlf903)
         CALL cl_init_qry_var()
         IF NOT cl_null(g_tlf.tlf902) THEN 
            LET g_qryparam.form ="q_ime001"
            LET g_qryparam.arg1 = g_tlf.tlf902
         ELSE
             LET g_qryparam.form ="q_ime4_1" 
         END IF 	  
         CALL cl_create_qry() RETURNING g_tlf.tlf903
         DISPLAY BY NAME g_tlf.tlf903
         NEXT FIELD tlf903         
       END CASE   

      ON ACTION qbe_select
         CALL cl_qbe_select()
            
      ON ACTION locale                     
         LET g_change_lang = TRUE
         EXIT CONSTRUCT

      ON ACTION close             
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT CONSTRUCT  
      
      ON ACTION exit              
         LET INT_FLAG = 1
         EXIT CONSTRUCT
   END CONSTRUCT 
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p001_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF

             
  #INPUT BY NAME g_bgjob WITHOUT DEFAULTS                                                                      #FUN-E90045 mark
   INPUT BY NAME g_choice,g_bgjob WITHOUT DEFAULTS  #更新最近入出庫日期否(ima73/ima74/ima29/img15/img16/img17) #FUN-E90045 add


   AFTER FIELD g_bgjob
        IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
           NEXT FIELD g_bgjob
        END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  

   
     ON ACTION locale
          LET g_change_lang = TRUE
        EXIT INPUT
      
         BEFORE INPUT
             CALL cl_qbe_init()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

   END INPUT
      
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
      CONTINUE WHILE
   END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p002_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF

     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "aimp002"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('aimp002','9031',1)
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                       #MOD-G50040 --- mark Start ---
                       #" '",g_tlf.tlf01 CLIPPED,"'",
                       #" '",g_tlf.tlf902 CLIPPED,"'",
                       #" '",g_tlf.tlf903 CLIPPED,"'",
                       #" '",g_tlf.tlf904 CLIPPED,"'",
                       #" '",g_tlf.tlf61 CLIPPED,"'",
                       #MOD-G50040 --- mark End --- 
                        " '",g_wc CLIPPED,"'",    #MOD-G50040 --- add
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_choice CLIPPED,"'" #FUN-E90045 add
           CALL cl_cmdat('aimp002',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p002_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  
        EXIT PROGRAM
     END IF
     EXIT WHILE

 END WHILE

END FUNCTION

FUNCTION p002_p2()
DEFINE l_ima01     LIKE ima_file.ima01     #MOD-CB0143 add
DEFINE l_ima9021   LIKE ima_file.ima9021   #MOD-CB0143 add

   LET g_success='Y'
   #CALL p002_s1()    #20231102 mark
   #FUN-E90045--add---str--
   IF cl_null(g_choice) THEN
       LET g_choice = 'Y'
   END IF
   IF g_success = 'Y' AND g_choice = 'Y' THEN
       CALL p002_upd_ima() 
       CALL p002_upd_img() 
   END IF
   #FUN-E90045--add---end--
   IF  g_success='Y' THEN 
      UPDATE ima_file 
         SET ima902=ima9021 
       WHERE ima902 IS NULL 
         AND ima9021 IS NOT NULL

     #MOD-CB0143---add---S
      LET g_sql = " SELECT ima01,ima9021 FROM ima_file WHERE ima9021 IS NOT NULL "

      PREPARE p2_ima FROM g_sql
      DECLARE p2_ima_2 CURSOR FOR p2_ima
      FOREACH p2_ima_2 INTO l_ima01,l_ima9021
         UPDATE img_file
            SET img37 = l_ima9021
          WHERE img01 = l_ima01
            AND img37 IS null

         #MOD-E80116 add --start--
         UPDATE img_file
            SET img37 = l_ima9021
          WHERE img01 = l_ima01
            AND img37 IS NOT NULL
            AND NOT EXISTS (SELECT tlf01 FROM tlf_file
                             WHERE tlf01 = l_ima01
                               AND tlf01 = img01
                               AND tlf902= img02
                               AND tlf903= img03
                               AND tlf904= img04 )
         #MOD-E80116 add --end--
      END FOREACH
     #MOD-CB0143---add---E

    END IF        
END FUNCTION

FUNCTION p002_s1()   
DEFINE p_plant  LIKE type_file.chr21
DEFINE l_slip   LIKE aba_file.aba00
DEFINE l_sql    STRING
DEFINE l_img37  LIKE img_file.img37
DEFINE l_ima902 LIKE ima_file.ima902
DEFINE l_max_tlf06 LIKE tlf_file.tlf06
DEFINE l_oay12  LIKE oay_file.oay12
DEFINE l_smy56  LIKE smy_file.smy56
DEFINE l_azp03  LIKE  azp_file.azp03
DEFINE l_dbs    LIKE  azp_file.azp03

   LET p_plant = ''
   SELECT azp03  INTO l_azp03 FROM azp_file 
    WHERE azp01 = g_plant 
   LET l_dbs = s_dbstring(l_azp03)
   LET p_plant=l_dbs

  #LET g_sql = " SELECT * FROM ",p_plant,"tlf_file ",   #FUN-A50102
   LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant,'tlf_file'),  #FUN-A50102
               "  WHERE ",g_wc CLIPPED                                         
   IF STATUS THEN 
       CALL cl_err3("sel","tlf_file",g_tlf.tlf01,"",STATUS,"","sel tlf:",0)   #NO.FUN-640266
       RETURN 
   END IF
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql  #FUN-A50102
   PREPARE tlf_pre  FROM g_sql
   DECLARE tlf_curs CURSOR FOR tlf_pre
   
   FOREACH tlf_curs INTO g_tlf.*
      #IF NOT s_untlf1(p_plant) THEN 
      IF NOT s_untlf1(g_plant) THEN    #FUN-A50102
         LET g_success='N' RETURN
      END IF 
   END FOREACH 
    
   
END FUNCTION


#FUN-E90045-----add-----str---
FUNCTION p002_upd_ima()   
DEFINE l_sql        STRING
DEFINE l_sql_1      STRING
DEFINE l_sql_2      STRING
DEFINE l_sql_3      STRING
DEFINE l_ima01      LIKE ima_file.ima01
DEFINE l_max_ima73  LIKE ima_file.ima73
DEFINE l_max_ima74  LIKE ima_file.ima74
DEFINE l_max_ima29  LIKE ima_file.ima29
DEFINE l_cnt        LIKE type_file.num5

   ##-- 20231101 應加入 g_wc 條件，避免只是要重該某料時跑全部的料，QBE設假的？   
   #因為更新最近入/出庫日以所有的料及所有的tlf_file資料來考量,所以不受限加入g_wc條件

   LET l_sql = " SELECT ima01 FROM ima_file ",
               "  WHERE imaacti='Y' ",
               "    AND EXISTS (SELECT 1 FROM tlf_file WHERE tlf01=ima01 AND ", g_wc CLIPPED ,  #20240422 modify
               "               )"                                                               #20240422 modify
              #"  WHERE imaacti='Y' AND ",g_wc CLIPPED    #20231101 add #20240422 mark                                       
              #"  ORDER BY ima01 "                        #20231101 mark
   PREPARE ima_pre  FROM l_sql
   DECLARE ima_curs CURSOR FOR ima_pre


   LET l_sql = " SELECT MAX(tlf06),COUNT(*) FROM tlf_file ",  
               #"  WHERE tlf01 = ? "                                            #190320 mark by ruby
                "  WHERE tlf10<>0 and tlf01 = ? ",                              #190320 add by ruby
                "   AND EXISTS (SELECT 1 FROM smy_file WHERE smy56='Y' ",       #20231101 add 單別是否計算依據 asmi300 設定
                "   AND smyslip = SUBSTR(tlf905,1,5))"                          #20231101
   #料件(入)
   LET l_sql_1 = l_sql CLIPPED,
               "    AND tlf907 = 1 "  #入
   PREPARE max_tlf06_pre1  FROM l_sql_1

   #料件(出)
   LET l_sql_2 = l_sql CLIPPED,
               "    AND tlf907 = -1 "  #出
   PREPARE max_tlf06_pre2  FROM l_sql_2

   #料件(入/出)
   LET l_sql_3 = l_sql CLIPPED,
               "    AND (tlf907 = 1 OR tlf907 = -1) "  #入及出
   PREPARE max_tlf06_pre3  FROM l_sql_3

   #更新ima73/ima74/ima29
   LET l_sql = "UPDATE ima_file ",
               "   SET ima73 = ?, ", #最近入庫日
               "       ima74 = ?, ", #最近出庫日
               "       ima29 = ?  ", #最近異動日期
               " WHERE ima01 = ? "
   PREPARE upd_ima_pre FROM l_sql


   FOREACH ima_curs INTO l_ima01
           IF SQLCA.sqlcode THEN
              IF g_bgerr THEN
                  CALL s_errmsg('ima01',l_ima01,'foreach ima_curs',SQLCA.sqlcode,1)
              ELSE
                  CALL cl_err('foreach ima_curs',SQLCA.sqlcode,1)
              END IF
              LET g_success='N'
              CONTINUE FOREACH
           END IF
           MESSAGE l_ima01               #20231102
           CALL ui.Interface.refresh()   #20231102

           #抓最近入庫日
           EXECUTE max_tlf06_pre1 USING l_ima01 INTO l_max_ima73,l_cnt
           IF l_cnt = 0 THEN
              #LET l_max_ima73 = NULL                                    #20231102
              SELECT MIN(tlf06),COUNT(*) INTO l_max_ima73 FROM tlf_file  #無最近入庫日時抓最小入庫日
               WHERE tlf01 = l_ima01
           END IF

           #抓最近出庫日
           EXECUTE max_tlf06_pre2 USING l_ima01 INTO l_max_ima74,l_cnt
           IF l_cnt = 0 THEN
               LET l_max_ima74 = NULL
           END IF

           #抓最近異動日期
           EXECUTE max_tlf06_pre3 USING l_ima01 INTO l_max_ima29,l_cnt
           IF l_cnt = 0 THEN
              #LET l_max_ima29 = NULL                                   #20231102 mark
               LET l_max_ima29 = l_max_ima73                            #20231102 無最小異動日時取最小入庫日
           END IF

           EXECUTE upd_ima_pre USING l_max_ima73,l_max_ima74,l_max_ima29,l_ima01
           IF SQLCA.sqlcode <> 0 OR SQLCA.sqlerrd[3] = 0 THEN
               IF g_bgerr THEN
                   CALL s_errmsg('ima01',l_ima01,'upd ima73/ima74,ima29',SQLCA.sqlcode,1)
               ELSE
                   CALL cl_err('upd ima73/ima74/ima29',SQLCA.sqlcode,1)
               END IF
               LET g_success='N'
           END IF
   END FOREACH
END FUNCTION

FUNCTION p002_upd_img()   
DEFINE l_msg        STRING
DEFINE l_sql        STRING
DEFINE l_sql_1      STRING
DEFINE l_sql_2      STRING
DEFINE l_sql_3      STRING
DEFINE l_img01      LIKE img_file.img01
DEFINE l_img02      LIKE img_file.img02
DEFINE l_img03      LIKE img_file.img03
DEFINE l_img04      LIKE img_file.img04
DEFINE l_max_img15  LIKE img_file.img15
DEFINE l_max_img16  LIKE img_file.img16
DEFINE l_max_img17  LIKE img_file.img17
DEFINE l_cnt        LIKE type_file.num5
   
   ##-- 20231101 應加入 g_wc 條件，避免只是要重該某料時跑全部的料，QBE設假的？   
   #因為更新最近入/出庫日以所有的料/倉/儲/批及所有的tlf_file資料來考量,所以不受限加入g_wc條件

   LET g_wc =  cl_replace_str(g_wc,"tlf01","img01")               #20231101
   LET l_sql = " SELECT img01,img02,img03,img04 FROM img_file ",  
               "  WHERE  ",g_wc CLIPPED                           #20231101 add                                       
              #"  ORDER BY img01,img02,img03,img04 "              #20231101 mark
   PREPARE img_pre  FROM l_sql
   DECLARE img_curs CURSOR FOR img_pre


   LET l_sql = " SELECT MAX(tlf06),COUNT(*) FROM tlf_file ",  
               #"  WHERE tlf01 = ?  ",                                          #190320 mark by ruby
               "  WHERE tlf10<>0 and tlf01 = ?  ",                                 #190320 add by ruby
               "    AND tlf902 = ? ",
               "    AND tlf903 = ? ",
               "    AND tlf904 = ? ",
               "    AND EXISTS (SELECT 1 FROM smy_file WHERE smy56='Y' ",       #20231101 add 單別是否計算依據 asmi300 設定
               "    AND smyslip = SUBSTR(tlf905,1,5))"                          #20231101
   #料件(入)
   LET l_sql_1 = l_sql CLIPPED,
               "    AND tlf907 = 1 "  #入
   PREPARE max_tlf06_pre4  FROM l_sql_1

   #料件(出)
   LET l_sql_2 = l_sql CLIPPED,
               "    AND tlf907 = -1 "  #出
   PREPARE max_tlf06_pre5  FROM l_sql_2

   #料件(入/出)
   LET l_sql_3 = l_sql CLIPPED,
               "    AND (tlf907 = 1 OR tlf907 = -1) "  #入及出
   PREPARE max_tlf06_pre6  FROM l_sql_3

   #更新img15/img16/img17
   LET l_sql = "UPDATE img_file ",
               "   SET img15 = ?, ", #最近一次收料日期
               "       img16 = ?, ", #最近一次發料日期
               "       img17 = ?  ", #最近一次異動日期
               " WHERE img01 = ?  ",
               "   AND img02 = ?  ",
               "   AND img03 = ?  ",
               "   AND img04 = ?  "
   PREPARE upd_img_pre FROM l_sql


   FOREACH img_curs INTO l_img01,l_img02,l_img03,l_img04
           IF SQLCA.sqlcode THEN
              LET l_msg = l_img01,' ',l_img02,' ',l_img03,' ',l_img04
              IF g_bgerr THEN
                  CALL s_errmsg('img01,img02,img03,img04',l_msg,'upd img15/img16,img17',SQLCA.sqlcode,1)
              ELSE
                  CALL cl_err('foreach img_curs',SQLCA.sqlcode,1)
              END IF
              LET g_success='N'
              CONTINUE FOREACH
           END IF

           #最近一次收料日期
           EXECUTE max_tlf06_pre4 USING l_img01,l_img02,l_img03,l_img04 INTO l_max_img15,l_cnt
           IF l_cnt = 0 THEN
               LET l_max_img15 = NULL
           END IF

           #最近一次發料日期
           EXECUTE max_tlf06_pre5 USING l_img01,l_img02,l_img03,l_img04 INTO l_max_img16,l_cnt
           IF l_cnt = 0 THEN
               LET l_max_img16 = NULL
           END IF

           #最近一次異動日期
           EXECUTE max_tlf06_pre6 USING l_img01,l_img02,l_img03,l_img04 INTO l_max_img17,l_cnt
           IF l_cnt = 0 THEN
               LET l_max_img17 = NULL
           END IF
           EXECUTE upd_img_pre USING l_max_img15,l_max_img16,l_max_img17,l_img01,l_img02,l_img03,l_img04
           IF SQLCA.sqlcode <> 0 OR SQLCA.sqlerrd[3] = 0 THEN
               LET l_msg = l_img01,' ',l_img02,' ',l_img03,' ',l_img04
               IF g_bgerr THEN
                   CALL s_errmsg('img01,img02,img03,img04',l_msg,'upd img15/img16,img17',SQLCA.sqlcode,1)
               ELSE
                   CALL cl_err('upd img15/img16/img17',SQLCA.sqlcode,1)
               END IF
               LET g_success='N'
           END IF
   END FOREACH
END FUNCTION
#FUN-E90045-----add-----end---
