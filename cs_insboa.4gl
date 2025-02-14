# Prog.Version...: '5.30.09-13.09.06(00000)'     #
#
# Program Name...: cs_insboa.4gl
# Descriptions...: 群組取替代自動新增程式
# Date & Author..: 20250212 By momo
# Input Parameter: p_bma01 主件               
# Return Code....: 
# Modify.........:        

 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"    #FUN-7C0053

FUNCTION cs_insboa(p_bma01)
         
DEFINE 
       p_bma01       LIKE bmb_file.bmb01,  #主件                  
       l_sql         STRING,
       l_cnt         LIKE type_file.num5
DEFINE g_boa         RECORD LIKE boa_file.*
DEFINE g_bob         RECORD LIKE bob_file.*
DEFINE i_bma01       LIKE bma_file.bma01  #符合條件的主件
DEFINE n_boa02       LIKE boa_file.boa02  #群組編號取最大值
   
     LET l_cnt = 0
   
        
     #取出符合條件的群組資料
     LET l_sql = "SELECT DISTINCT boa01,boa02 FROM boa_file ",
                 "  LEFT JOIN ima_file a ON a.ima01 = '",p_bma01,"' ",
                 " WHERE ta_boa01 = 'Y' ",
                 #--判斷需符合一致的條件
                 "   AND EXISTS (SELECT 1 FROM ima_file b ",
                 "                WHERE b.ima01=boa01 AND b.ima131=a.ima131 AND b.ima09=a.ima09 ",
                 "                  AND b.ima1007 = a.ima1007 ",
                 "                  AND b.ta_ima06 = a.ta_ima06 AND b.ta_ima08 =a.ta_ima08 )"
     

     PREPARE boa_cal FROM l_sql
     DECLARE boa_cs CURSOR FOR boa_cal

     FOREACH boa_cs INTO g_boa.boa01,g_boa.boa02
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:boa_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF

        MESSAGE 'boa01:',g_boa.boa01 ||' boa02:' ||g_boa.boa02 CLIPPED

        #找出符合群組的主件BOM
        LET l_sql = " SELECT bma01 FROM bma_file,ima_file a ",
                    "  WHERE NOT EXISTS (        ",
                    "    SELECT boa03,bmb06,bmb07 FROM boa_file,bmb_file WHERE bmb01=boa01 AND bmb03=boa03 AND boa01='",g_boa.boa01,"' AND boa02='",g_boa.boa02,"' ",
                    "    MINUS ",
                    "    SELECT bmb03,bmb06,bmb07 FROM bmb_file WHERE bmb01=bma01 AND bmb05 IS NULL ",
                    "  ) ",
                    " AND bmaacti = 'Y' ",
                    " AND bma01 = a.ima01 ",
                    " AND bma01 ='",p_bma01,"' ",
                    " AND EXISTS (SELECT 1 FROM ima_file b ",
                    "              WHERE b.ima01='",g_boa.boa01,"' AND b.ima131=a.ima131 AND b.ima09=a.ima09 ",
                    "                AND b.ima1007 = a.ima1007 ",
                    "                AND b.ta_ima06 = a.ta_ima06 AND b.ta_ima08 =a.ta_ima08) "
         
        PREPARE bma_cal FROM l_sql
        DECLARE bma_cs CURSOR FOR bma_cal

        FOREACH bma_cs INTO i_bma01
          IF SQLCA.sqlcode THEN
           CALL cl_err('foreach: bma_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
          END IF

          MESSAGE 'bma01:',i_bma01
          ##---判斷是否已新增過
          LET l_sql = "SELECT 1 FROM dual WHERE NOT EXISTS ( ",
                      "  SELECT boa03 FROM boa_file WHERE boa01='",g_boa.boa01,"' AND boa02='",g_boa.boa02,"' ",
                      "   MINUS ",
                      "  SELECT boa03 FROM boa_file WHERE boa01 = '",i_bma01,"' )"
          PREPARE boa_sel FROM l_sql
          DECLARE boa_yn CURSOR FOR boa_sel
          FOREACH boa_yn INTO l_cnt
            
          END FOREACH
          IF l_cnt = 1 THEN
             EXIT FOREACH
          END IF

          #---INSERT boa_file群組資料
          INSERT INTO boa_file(boa01,boa02,boa03,boa04,boa05,boa06,boa07,boa08,ta_boa01,ta_boadate,ta_boamodu)
          SELECT bma01,(SELECT NVL(MAX(boa02)+10,10) FROM boa_file WHERE boa01 = i_bma01),
                 boa03,boa04,boa05,TRUNC(SYSDATE),boa07,boa08,'N',TRUNC(SYSDATE),'tiptop'
            FROM bma_file,boa_file
           WHERE bma01 = i_bma01
             AND boa01 = g_boa.boa01 AND boa02=g_boa.boa02
          GROUP BY bma01,boa03,boa04,boa05,boa06,boa07,boa08
          IF SQLCA.sqlcode THEN
             CALL cl_err('insert boa',i_bma01,1)
             EXIT FOREACH
          END IF
          MESSAGE 'ins boa:',i_bma01

          #---INSERT bob_file群組資料
          INSERT INTO bob_file(bob01,bob02,bob03,bob04,bob05,bob06,bob07,bob08,bob09,bob10,bob14,ta_bobdate,ta_bobmodu)
          SELECT bma01,(SELECT MAX(boa02) FROM boa_file WHERE boa01 = i_bma01 AND ta_boadate=TRUNC(SYSDATE) ),
                 bob03,bob04,bob05,bob06,bob07,bob08,bob09,TRUNC(SYSDATE),bob14,TRUNC(SYSDATE),'tiptop'
            FROM bma_file,bob_file
           WHERE bma01 = i_bma01
             AND bob01 = g_boa.boa01 AND bob02=g_boa.boa02 
          GROUP BY bma01,bob03,bob04,bob05,bob06,bob07,bob08,bob09,bob10,bob14
          IF SQLCA.sqlcode THEN
             CALL cl_err('insert bob',i_bma01,1)
             EXIT FOREACH
          END IF
          MESSAGE 'ins bob:',i_bma01

          #--UPDATE bmb16 取替代特性 = 5
          UPDATE bmb_file SET bmb16='5' 
           WHERE EXISTS (SELECT 1 FROM boa_file 
                          WHERE boa01=g_boa.boa01 AND boa02 = g_boa.boa02
                            AND boa03=bmb03)
             AND bmb01 = i_bma01

          IF SQLCA.sqlcode THEN
             CALL cl_err('insert bob',i_bma01,1)
             EXIT FOREACH
          END IF
          MESSAGE 'upd bmb16:',i_bma01
         
        END FOREACH 
               
     END FOREACH
           
END FUNCTION

