# Prog.Version...: '5.30.09-13.09.06(00000)'     #
#
# Program Name...: cs_updbmb16.4gl
# Descriptions...: BOM取替代特性更新
# Date & Author..: 20220530 By momo
# Input Parameter: p_bmb01  主件, p_bmb03 元件 ,p_bmb16 取替代特性                          
# Return Code....: 
# Modify.........: 22100019  20221018 By momo 修正取替代失效主件ALL，影響群組替代特性問題                  

 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"    #FUN-7C0053
 
FUNCTION cs_updbmb16(l_bmd08,l_bmd01,p_bmb16)
         
DEFINE 
       p_bmb01       LIKE bmb_file.bmb01,  #主件             
       p_bmb03       LIKE bmb_file.bmb03,  #元件      
       p_bmb16       LIKE bmb_file.bmb16,  #取替代特性      
       l_sql         STRING,
       l_cnt         LIKE type_file.num5,
       n_bmb16       LIKE bmb_file.bmb16   #新取替代特性      

DEFINE l_bmd01       LIKE bmd_file.bmd01,  #取代主件
       l_bmd08       LIKE bmd_file.bmd08   #取代元件
   
     LET l_cnt = 0

     IF cl_null(l_bmd08) THEN
        LET l_sql = "SELECT bmd01,bmd08 FROM bmd_file WHERE bmd04 = '",l_bmd01,"' AND bmd06=SYSDATE-1 "
     ELSE
        IF p_bmb16='S' THEN
           LET l_sql = "SELECT boa03,boa01 FROM boa_file WHERE boa01 = '",l_bmd08,"' AND boa03 = '",l_bmd01,"' "
        ELSE
           LET l_sql = "SELECT bmd01,bmd08 FROM bmd_file WHERE bmd01 = '",l_bmd01,"' AND bmd08 = '",l_bmd08,"' "
        END IF
     END IF

     PREPARE bmd_cal FROM l_sql
     DECLARE bmd_cs CURSOR FOR bmd_cal

     FOREACH bmd_cs INTO p_bmb03,p_bmb01
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
     
     #群組確認
        SELECT COUNT(*) INTO l_cnt
          FROM boa_file
         WHERE boa01 = p_bmb01 AND boa03 = p_bmb03 
           AND boa07 IS NULL
        IF l_cnt > 0 THEN LET n_bmb16 = '5' END IF
    
     #取代時，確認是否存在其他 取代
     IF l_cnt = 0 THEN          
        SELECT COUNT(*) INTO l_cnt 
          FROM bmd_file
         WHERE (bmd08 = p_bmb01 OR bmd08='ALL')
           AND bmd01 = p_bmb03 AND bmd02 = '1' AND bmd06 IS NULL AND bmdacti = 'Y'
        IF l_cnt > 0 THEN LET n_bmb16 = '1' END IF
     END IF

     #取代失效或無取代存在時，確認是否存在 替代
     IF l_cnt = 0 THEN
        SELECT COUNT(*) INTO l_cnt 
          FROM bmd_file
         WHERE (bmd08 = p_bmb01 OR bmd08='ALL')
           AND bmd01 = p_bmb03 AND bmd02 = '2' AND bmd06 IS NULL AND bmdacti = 'Y'
        IF l_cnt > 0 THEN LET n_bmb16 = '2' END IF
     END IF

     IF l_cnt = 0 THEN LET n_bmb16 = '0' END IF

     IF p_bmb01 = 'ALL' THEN
        IF n_bmb16 = '0' THEN     #20221018
           UPDATE bmb_file SET bmb16 = n_bmb16,
                               bmbdate = g_today,
                               bmbmodu = g_user
            WHERE bmb03 = p_bmb03 
              AND bmb05 IS NULL
              AND bmb16 <> '5'    #20221018
        ELSE
            UPDATE bmb_file SET bmb16 = n_bmb16,
                               bmbdate = g_today,
                               bmbmodu = g_user
            WHERE bmb03 = p_bmb03
              AND bmb05 IS NULL
        END IF
     ELSE
        UPDATE bmb_file SET bmb16 = n_bmb16,
                            bmbdate = g_today,
                            bmbmodu = g_user
         WHERE bmb03 = p_bmb03 AND bmb01 = p_bmb01 
           AND bmb05 IS NULL
     END IF
  
     END FOREACH
           
END FUNCTION

