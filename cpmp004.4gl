# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cpmp004.4gl
# Descriptions...: 採購 u/p calcaul
# Input parameter: 
# Return code....: 
# Date & Author..: 92/02/25 By Carol
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.FUN-4C0011 04/12/01 By Mandy 單價金額位數改為dec(20,6)
# Modify.........: No.MOD-570111 05/08/04 By Nicola 1.程式沒有考慮系統的匯率參數是取每月或每日,直接使用每日統計檔資料.
#                                                   2.程式沒有考慮本幣別匯率為1的狀況. 所以所有的資料全部運算不出來
# Modify.........: No.FUN-570138 06/03/09 By yiting 批次背景執行
# Modify.........: No.MOD-630108 06/04/18 By pengu 最近採購單價(ima53)及平均採購單價(ima91)沒有轉換為庫存單位,
                          #                        因為單價與數量都乘以轉換率所以互相抵銷
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-610085 06/07/20 By Pengu 1.畫面條件選項增加外幣單價換算本幣之匯率採用
                                  #                2.畫面下方的注意移除第二項
# Modify.........: No.FUN-680136 06/09/18 By Jackho 欄位類型修改
# Modify.........: No.FUN-710030 07/01/16 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-6B0009 07/02/09 By rainy 新增勾選是否更新採購單價
# Modify.........: No.MOD-850282 08/05/28 By Smcpmin 更新ima53最近採購單價時,未考慮採購量=0的情況,仍以金額/數量,使得最近採購單價update錯誤!
# Modify.........: No.MOD-880160 08/08/21 By Smcpmin 延續MOD-630108
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0108 09/12/14 By Smcpmin 最近/平均單價的計算應同cpmp554的計算方式
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today 
# Modify.........: No.FUN-D70120 13/08/02 By yangtt 會計年期會不按照自然年月設置,年期的判斷需要按照aooq011的設置
# Modify.........: No.MOD-F20019 15/02/05 By liliwen 背景執行時，增加傳入tm.a,tm.b的參數至p_cron中 
# Modify.........: No.2103316053 20210401 By momo 雜發計算剔除 %2013 單別
# Modify.........: No.2207148468 20220714 By momo 增加撈取條件 tlf907 = -1 (發料)
# Modify.........: NO.24120011   20241211 By momo 當數量為負時，調整為 0

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm RECORD
          wc	LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(200)
          bdate	LIKE type_file.dat,       #No.FUN-680136 DATE
          edate	LIKE type_file.dat,       #No.FUN-680136 DATE
          b     LIKE type_file.chr1       #FUN-6B0009
          END RECORD,
       g_flag   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE l_flag          LIKE type_file.chr1,    #No.FUN-570138  #No.FUN-680136 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,    # Prog. Version..: '5.30.24-17.04.13(01)   #是否有做語言切換 No.FUN-570138
       ls_date         STRING                  #->No.FUN-570138
DEFINE g_bookno1       LIKE aza_file.aza81     #No.FUN-D70120
DEFINE g_bookno2       LIKE aza_file.aza82     #No.FUN-D70120
   
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
#->No.FUN-570138 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc    = ARG_VAL(1)
   LET ls_date  = ARG_VAL(2)
   LET tm.bdate = cl_batch_bg_date_convert(ls_date)
   LET ls_date  = ARG_VAL(3)
   LET tm.edate = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob = ARG_VAL(4)
   LET tm.b = ARG_VAL(5)   #MOD-F20019 add
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570138 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("cpm")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p004_tm()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL cpmp004()
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
               CLOSE WINDOW p004_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p004_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL cpmp004_1()
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
 
FUNCTION p004_tm()
   DEFINE lc_cmd        LIKE type_file.chr1000
 
   IF s_shut(0) THEN RETURN END IF
 
   OPEN WINDOW p004_w WITH FORM "cpm/42f/cpmp004" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.b = 'Y'                            #No.FUN-610085 add
      CONSTRUCT BY NAME tm.wc ON ima01,ima08 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       
        ON ACTION locale                    #genero
#NO.FUN-570138 mark--
#           LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570138 mark--
           LET g_change_lang = TRUE
           EXIT CONSTRUCT
       
        ON ACTION exit              #加離開功能genero
           LET INT_FLAG = 1
           EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
     END CONSTRUCT
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
#NO.FUN-570138 start--  
#     IF g_action_choice = "locale" THEN  #genero
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        CONTINUE WHILE 
#     END IF
 
#     IF INT_FLAG THEN 
#        LET INT_FLAG = 0
#        EXIT WHILE
#     END IF
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p004_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
#NO.FUN-570138 end--------
     LET g_bgjob = 'N' #NO.FUN-570138 
     #INPUT BY NAME tm.bdate,tm.edate WITHOUT DEFAULTS 
     INPUT BY NAME tm.bdate,tm.edate,tm.b,g_bgjob WITHOUT DEFAULTS   
       #FUN-6B0009--begin
         BEFORE INPUT
           LET tm.b = 'Y'
           DISPLAY BY NAME tm.b
       #FUN-6B0009--end
         AFTER FIELD bdate
         #   IF tm.bdate IS NULL THEN NEXT FIELD bdate END IF
         AFTER FIELD edate
         #   IF tm.edate IS NULL THEN NEXT FIELD edate END IF
        
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
      
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
        #->No.FUN-570138 --start--
           #LET g_action_choice='locale'
            LET g_change_lang = TRUE
        #->No.FUN-570138 ---end---
            EXIT INPUT
 
      END INPUT
 
#NO.FUN-570138 mark+---
#      IF INT_FLAG THEN 
#         LET INT_FLAG = 0  
#         EXIT WHILE 
#      END IF
#
#      IF cl_sure(10,10) THEN
#
#         BEGIN WORK
#
#         LET g_success = 'Y' 
#         CALL cpmp004()
#
#         IF g_success = 'Y' THEN 
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#         END IF 
#         IF g_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#     END IF 
#NO.FUN-570138 mark--
 
#NO.FUN-570138 start--
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "cpmp004"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('cpmp004','9031',1)
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.wc CLIPPED ,"'",
                        " '",tm.bdate CLIPPED ,"'",
                        " '",tm.edate CLIPPED ,"'",
                        " '",g_bgjob CLIPPED,"'",   #MOD-F20019 add,
                        " '",tm.b CLIPPED ,"'"      #MOD-F20019 add
           CALL cl_cmdat('cpmp004',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p004_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
    EXIT WHILE
    #->No.FUN-570138 ---end---
   END WHILE
END FUNCTION
 
FUNCTION cpmp004()
   DEFINE l_sql		STRING,
          l_msg  	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
          l_cnt         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_ima01       LIKE ima_file.ima01,    #No.MOD-490217	
          l_ima44       LIKE ima_file.ima44,    #MOD-9C0108
          l_ima908      LIKE ima_file.ima908,   #MOD-9C0108
          l_maxdate     LIKE type_file.dat,     #No.FUN-680136 DATE
         #l_price1,l_price2	DECIMAL(12,3)
          l_ima41       LIKE ima_file.ima41, #FUN-4C0011
          l_price2      LIKE ima_file.ima53,  #FUN-4C0011
          l_start       LIKE tlf_file.tlf06,  #開始日期
          l_end         LIKE tlf_file.tlf06,  #結束日期
          l_tlf11       LIKE tlf_file.tlf11,  #庫存單位 20220714
          l_ima25       LIKE ima_file.ima25   #庫存單位 20220714
   DEFINE l_smd06       LIKE smd_file.smd06   #目的單位數量 20220714



     SELECT trunc(add_months(sysdate, -12), 'month'),trunc(last_day(add_months(sysdate, -1)))
            INTO l_start,l_end
       FROM aza_file
  
 
     LET l_sql = "SELECT ima01,ima25 FROM ima_file ",   #MOD-9C0108  #20200511 mark #20220714 
    #LET l_sql = "SELECT ima133 FROM ima_file ",   #MOD-9C0108 #20200511 modify
                #"  WHERE EXISTS (SELECT * FROM tlf_file WHERE tlf01=ima01 AND ",tm.wc CLIPPED,
                 "  WHERE imaacti='Y' AND   ",
                #"    AND (EXISTS (SELECT * FROM tlf_file WHERE tlf01=ima01) ",
                #"     OR ima901 >= sysdate - interval '45' day OR ima41 > 0 ) AND ", tm.wc CLIPPED,
                #"     AND ", tm.wc CLIPPED,
                 "    (ima01 LIKE '1%' OR ima01 LIKE '2%') AND ",tm.wc CLIPPED
                 
     PREPARE p004_prepare FROM l_sql
     DECLARE p004_cur CURSOR FOR p004_prepare
 

     LET l_sql = "SELECT SUM(tlf10*tlf907)*-1/MAX(Months_Between(to_date(TO_CHAR(sysdate, 'YYYY-MM'), 'YYYY-MM'),to_date(TO_CHAR(tlf06, 'YYYY-MM'), 'YYYY-MM')) ),tlf11 ", #20220714
                 " FROM tlf_file,ima_file ",
                 -- 工單領用剔除重工與版本重工
                 " WHERE ima01=tlf01 AND ((tlf13 LIKE 'asfi5%' ",
                 "   AND NOT EXISTS (SELECT * FROM sfa_file,sfb_file ",
                 "        WHERE sfa01=tlf62 AND sfb01=sfa01 ",
                 "          AND (SUBSTR(sfb05,1,12)=SUBSTR(sfa03,1,12) OR sfb01 LIKE '_401A%'))) ",
                 -- 出貨剔除多角貿
                 --OR  (tlf13 like 'axmt%' AND tlf99 is null)                         
                 -- 雜項領用只抓一般，不含報廢                         
                #" OR (tlf02 = '50' AND tlf13 = 'aimt301')) ",                                 #20210401 mark
                 " OR (tlf02 = '50' AND tlf13 = 'aimt301' AND tlf905 NOT LIKE '%2013%' )) ",   #20210401 modify
                 " AND ima133= ? ",
                 " AND tlf06 >= '",l_start,"' AND tlf06 <='",l_end,"' ",
                 " GROUP BY tlf11 "                                                            #20220714

      PREPARE p004_spre1 FROM l_sql
      DECLARE p004_scur1 CURSOR FOR p004_spre1

      FOREACH p004_cur INTO l_ima01,l_ima25                  #20220714 add by momo
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','p004_cur',SQLCA.sqlcode,1)  #NO.FUN-710046
            LET g_success = 'N'
            EXIT FOREACH
         END IF
       LET l_price2 = 0
       FOREACH p004_scur1 USING l_ima01 INTO l_ima41,l_tlf11
          IF l_ima41 < 0 THEN LET l_ima41=0 END IF           #20241211
          #單位換算 
          ##---- 20220714 add by momo (S)
          IF l_tlf11 <> l_ima25 THEN
             SELECT smd06/smd04 INTO l_smd06 FROM smd_file
              WHERE smd02= l_tlf11 AND smd03 = l_ima25
                AND smd01= l_ima01
             LET l_ima41 = cl_digcut(l_ima41 * l_smd06,3)
          END IF
             LET l_price2 = l_ima41+l_price2
          ##---- 20220714 add by momo (E)
       END FOREACH

       #IF l_ima41 > 0 THEN
       
          UPDATE ima_file 
            # SET ima41=l_im41
              SET ima41=l_price2
          WHERE ima01=l_ima01    #20200511
          # WHERE ima133=l_ima01   #20200511
       #END IF

       IF g_bgjob = 'N' THEN   #NO.FUN-570138
            MESSAGE l_ima01,' / ',l_price2 #20220714
            CALL ui.Interface.refresh()
       END IF


       #  LET l_msg = 'update ',l_ima01,l_ima41 CLIPPED
       #  IF SQLCA.sqlcode THEN 
       #     LET g_success = 'N'
       #  END IF  
         LET l_cnt = l_cnt + 1
     END FOREACH

        IF g_totsuccess='N' THEN
           LET g_success='N'
        END IF
END FUNCTION

FUNCTION cpmp004_1()
   DEFINE l_sql		STRING,
          l_msg  	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
          l_cnt         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_ima01       LIKE ima_file.ima01,    #No.MOD-490217	
          l_ima44       LIKE ima_file.ima44,    #MOD-9C0108
          l_ima908      LIKE ima_file.ima908,   #MOD-9C0108
          l_maxdate     LIKE type_file.dat,     #No.FUN-680136 DATE
         #l_price1,l_price2	DECIMAL(12,3)
          l_ima41       LIKE ima_file.ima41, #FUN-4C0011
          l_price2      LIKE ima_file.ima53,  #FUN-4C0011
          l_start       LIKE tlf_file.tlf06,  #開始日期
          l_end         LIKE tlf_file.tlf06   #結束日期



     SELECT trunc(add_months(sysdate, -12), 'month'),trunc(last_day(add_months(sysdate, -1)))
            INTO l_start,l_end
       FROM aza_file
  
 
     LET l_sql = "CREATE TABLE temp_ima41 ",
                " AS ",
                " (SELECT ima133,SUM(tlf10*tlf907)*-1/MAX(Months_Between(to_date(TO_CHAR(sysdate, 'YYYY-MM'), 'YYYY-MM'),to_date(TO_CHAR(tlf06, 'YYYY-MM'), 'YYYY-MM')) ) ima41 ",
                 " FROM tlf_file,ima_file b ",
                 -- 工單領用剔除重工與版本重工
                 " WHERE ima01=tlf01 ",
                 "   AND EXISTS (SELECT 1 FROM ima_file c where b.ima133=c.ima01 and tlf11=ima25) ", #只抓相同單位
                 "   AND ((tlf13 LIKE 'asfi5%' ",
                 "   AND NOT EXISTS (SELECT * FROM sfa_file,sfb_file ",
                 "        WHERE sfa01=tlf62 AND sfb01=sfa01 ",
                 "          AND (SUBSTR(sfb05,1,12)=SUBSTR(sfa03,1,12) OR sfb01 LIKE '_401A%'))) ",
                 -- 出貨剔除多角貿
                 --OR  (tlf13 like 'axmt%' AND tlf99 is null)                         
                 -- 雜項領用只抓一般，不含報廢                         
               # " OR (tlf02 = '50' AND tlf13 = 'aimt301' )) ",                                #20210401 mark
                 " OR (tlf02 = '50' AND tlf13 = 'aimt301' AND tlf905 NOT LIKE '%2013%' )) ",   #20210401 modify
                 " AND tlf06 >= '",l_start,"' AND tlf06 <='",l_end,"'  ",
               # " AND b.ima133 LIKE '16104-003022%' ",
                 " AND NVL(ima133,'XXX') != 'XXX' ",
                 " GROUP BY ima133 ) "
                 
     PREPARE p0041_prepare FROM l_sql
     EXECUTE p0041_prepare
     IF SQLCA.sqlcode THEN
        CALL cl_err('update ima_file error)',SQLCA.sqlcode,1)
        LET g_success='N'
     ELSE
        UPDATE ima_file  
           SET ima41 = (SELECT ima41 FROM temp_ima41 b WHERE ima_file.ima01=b.ima133)
         WHERE NVL(ima133,'XXX') != 'XXX'
        #   where ima01 like '22024-000106%'
        UPDATE ima_file SET ima41 = 0 WHERE ima41 < 0   #20241211
     END IF
     DROP TABLE temp_ima41 
     
END FUNCTION

FUNCTION cpmp004_2()
   DEFINE l_sql		STRING,
          l_msg  	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
          l_cnt         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_ima01       LIKE ima_file.ima01,    #No.MOD-490217	
          l_ima44       LIKE ima_file.ima44,    #MOD-9C0108
          l_ima908      LIKE ima_file.ima908,   #MOD-9C0108
          l_maxdate     LIKE type_file.dat,     #No.FUN-680136 DATE
         #l_price1,l_price2	DECIMAL(12,3)
          l_ima41       LIKE ima_file.ima41, #FUN-4C0011
          l_price2      LIKE ima_file.ima53,  #FUN-4C0011
          l_start       LIKE tlf_file.tlf06,  #開始日期
          l_end         LIKE tlf_file.tlf06   #結束日期



     SELECT trunc(add_months(sysdate, -12), 'month'),trunc(last_day(add_months(sysdate, -1)))
            INTO l_start,l_end
       FROM aza_file
  
 
     LET l_sql = "UPDATE ima_file a ",
                " SET ima41 = ( ",
                "SELECT SUM(tlf10*tlf907)*-1/MAX(Months_Between(to_date(TO_CHAR(sysdate, 'YYYY-MM'), 'YYYY-MM'),to_date(TO_CHAR(tlf06, 'YYYY-MM'), 'YYYY-MM')) ) ",
                 " FROM tlf_file,ima_file b ",
                 -- 工單領用剔除重工與版本重工
                 " WHERE ima01=tlf01 AND ((tlf13 LIKE 'asfi5%' ",
                 "   AND NOT EXISTS (SELECT * FROM sfa_file,sfb_file ",
                 "        WHERE sfa01=tlf62 AND sfb01=sfa01 ",
                 "          AND (SUBSTR(sfb05,1,12)=SUBSTR(sfa03,1,12) OR sfb01 LIKE '_401A%'))) ",
                 -- 出貨剔除多角貿
                 --OR  (tlf13 like 'axmt%' AND tlf99 is null)                         
                 -- 雜項領用只抓一般，不含報廢                         
               # " OR (tlf02 = '50' AND tlf13 = 'aimt301')) ",                                 #20210401 mark
                 " OR (tlf02 = '50' AND tlf13 = 'aimt301' AND tlf905 NOT LIKE '%2013%' )) ",   #20210401 modify
                 " AND a.ima01=b.ima133 ",
                 " AND tlf06 >= '",l_start,"' AND tlf06 <='",l_end,"'  ",
                 " GROUP BY ima133 ) ",
                 " WHERE substr(ima01,1,1) in ('1','2') "
                 
     PREPARE p0041_prepare2 FROM l_sql
     EXECUTE p0041_prepare2
     IF SQLCA.sqlcode THEN
        CALL cl_err('update ima_file error)',SQLCA.sqlcode,1)
        LET g_success='N'
     END IF

     
END FUNCTION
