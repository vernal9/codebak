# Prog. Version..: '5.30.24-17.04.13(00000)'     #
# Pattern name...: cs_q102_qty.4gl
# Descriptions...: aimq102單頭的各數量
# Date & Author..: No.0000664623_06_M001 18/01/09 By TSD.Jin
# Usage..........: CALL cs_q102_qty
# Input Parameter: p_ima01     
# Return code....: 
# Memo...........: 
# Modify.........: 20180410 by momo 走製程不能預設為0

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cs_muplant_qty(p_ima01, p_plant)
   DEFINE p_ima01         LIKE ima_file.ima01 
   DEFINE p_plant         LIKE type_file.chr10
   DEFINE l_ima           RECORD
             oeb_q        LIKE type_file.num15_3,
             sfa_q1       LIKE type_file.num15_3,
             sfa_q2       LIKE type_file.num15_3,
             misc_q1      LIKE type_file.num15_3,
             sfs_q2       LIKE type_file.num15_3,
             sie_q        LIKE type_file.num15_3,
             pml_q        LIKE type_file.num15_3,
             pmn_q        LIKE type_file.num15_3,
             rvb_q2       LIKE type_file.num15_3,
             rvb_q        LIKE type_file.num15_3,
             sfb_q1       LIKE type_file.num15_3,
             sfb_q2       LIKE type_file.num15_3,
             qcf_q        LIKE type_file.num15_3, 
             atp_qty      LIKE type_file.num15_3 
                          END RECORD  
   DEFINE l_short_qty     LIKE sfa_file.sfa07 
   DEFINE l_sql           STRING              
   DEFINE lr_sfa          RECORD LIKE sfa_file.*     
   DEFINE l_shb114        LIKE shb_file.shb114
   DEFINE l_sfa_q1        LIKE type_file.num15_3
   DEFINE l_avl_stk       LIKE type_file.num15_3 
   DEFINE l_n1            LIKE type_file.num15_3 
   DEFINE l_n2            LIKE type_file.num15_3 
   DEFINE l_n3            LIKE type_file.num15_3

   WHENEVER ERROR CONTINUE

   #-->受訂量
   LET l_sql = "SELECT SUM((oeb12-oeb24+oeb25-oeb26)*oeb05_fac)",
           "  FROM ",cl_get_target_table(p_plant,'oeb_file'),"," 
                    ,cl_get_target_table(p_plant,'oea_file'),
           " WHERE oeb01 = oea01",
           "   AND oea00 >= '1'", 
           "   AND oeb70 = 'N'", 
           "   AND oeaconf = 'Y' ", 
           " AND oeb12 > (oeb24+oeb25-oeb26)", 
           " AND oeb04 = ? "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE oeb_q FROM l_sql
   EXECUTE oeb_q INTO l_ima.oeb_q  USING p_ima01
   IF cl_null(l_ima.oeb_q) THEN
      LET l_ima.oeb_q = 0
   END IF
 
   #-->工單備料量 & 工單缺料量
   LET l_ima.sfa_q1 = 0  
   LET l_ima.sfa_q2=0    
   
    LET l_sql = "SELECT sfa_file.* ",
                "  FROM ",cl_get_target_table(p_plant,'sfa_file'),","
                         ,cl_get_target_table(p_plant,'sfb_file'),
                " WHERE sfb01=sfa01 ",
                "   AND sfa03 = '",p_ima01,"'",
                "   AND sfb02 != '15'",
                "   AND sfb87 !='X'",
                "   AND sfb04 <= '7'"
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE q102_sum_pre FROM l_sql
   DECLARE q102_sum CURSOR FOR q102_sum_pre 
   FOREACH q102_sum INTO lr_sfa.*
      CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                      lr_sfa.sfa12,lr_sfa.sfa27,
                      lr_sfa.sfa012,lr_sfa.sfa013)  #FUN-A50066 #TQC-A80005
           RETURNING l_short_qty 
      IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF 
      #   (備料量條件                                                     OR 欠料量條件)
      IF (lr_sfa.sfa05 > (lr_sfa.sfa06 + lr_sfa.sfa065 - lr_sfa.sfa063 ) OR l_short_qty > 0) THEN  
          #工單未備(A)  =    應發sfa05 -    已發sfa06 -    代買sfa065 + 下階料報廢sfa063 -    超領sfa062
          #若 A  < 0 ,則 LET A = 0
           LET l_sfa_q1 =(lr_sfa.sfa05 - lr_sfa.sfa06 - lr_sfa.sfa065 +    lr_sfa.sfa063 - lr_sfa.sfa062 ) * lr_sfa.sfa13
           IF l_sfa_q1 < 0 THEN
               LET l_sfa_q1 = 0
           END IF
           LET l_ima.sfa_q1= l_ima.sfa_q1 + l_sfa_q1
           LET l_ima.sfa_q2= l_ima.sfa_q2 + (l_short_qty * lr_sfa.sfa13)
      END IF            
   END FOREACH

   #M001 180109 By TSD.Jin--start--
   #-->雜發單未扣帳量
   LET l_ima.misc_q1 = 0
   LET l_sql = "SELECT SUM(inb09*inb08_fac)", 
           "  FROM ",cl_get_target_table(p_plant,'inb_file'),","
                    ,cl_get_target_table(p_plant,'ina_file'), 
           " WHERE ina01 = inb01",
           "   AND inb04 = ? ",
           "   AND ina00 = '1' ",      #庫存雜發單
           "   AND inaconf = 'Y' ",    #已確認
           "   AND inapost = 'N' "     #未過帳
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE misc_q1 FROM l_sql
   EXECUTE misc_q1 INTO l_ima.misc_q1  USING p_ima01

   #-->超耗單未扣帳量
   LET l_ima.sfs_q2 = 0
   LET l_sql = "SELECT SUM(sfs05) ", 
           "  FROM " ,cl_get_target_table(p_plant,'sfs_file'),","
                     ,cl_get_target_table(p_plant,'sfp_file'), 
          "  WHERE sfp01 = sfs01 ",
          "    AND sfs04 = ? ",
          "    AND sfpconf = 'Y' ",   #已確認
          "    AND sfp04   = 'N' ",   #未過帳
         "     AND sfp06 = '2' "     #超領
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sfs_q2 FROM l_sql
   EXECUTE sfs_q2 INTO l_ima.sfs_q2  USING p_ima01
   #M001 180109 By TSD.Jin--end----
   
   #-->請購量
   LET l_sql = "SELECT SUM((pml20-pml21)*pml09) ", 
               "  FROM " ,cl_get_target_table(p_plant,'pml_file'),","
                         ,cl_get_target_table(p_plant,'pmk_file'),
               " WHERE pml01 = pmk01 ",
               "   AND pml16 IN ('0','1','2','S','R','W') ",
               "   AND pml20 > pml21 ",
               "   AND pml04 = ? ",
               "   AND pmk18 != 'X' "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE pml_q FROM l_sql
   EXECUTE pml_q INTO l_ima.pml_q  USING p_ima01
   IF cl_null(l_ima.pml_q) THEN LET l_ima.pml_q = 0 END IF

   #--> 備置量
   LET l_sql= "SELECT SUM(sig05)  ", 
              "  FROM " ,cl_get_target_table(p_plant,'sig_file'),                         
              " WHERE sig01 = ?   "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sie_q FROM l_sql
   EXECUTE sie_q INTO l_ima.sie_q  USING p_ima01
   IF cl_null(l_ima.sie_q) THEN LET l_ima.sie_q = 0 END IF               

   #-->採購量
   MESSAGE " (4)Wait..."
   LET l_sql = "SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) ",  
               "  FROM ",cl_get_target_table(p_plant, 'pmn_file'),"," 
                        ,cl_get_target_table(p_plant, 'pmm_file'), 
               " WHERE pmn01 = pmm01 ",
               "   AND pmn16 IN ('0','1','2','S','R','W')   ",   
               "   AND pmn011 !='SUB' ",
               "   AND pmn20 > pmn50-pmn55-pmn58 ",   
               "   AND pmn04 = ? ",
               "   AND pmm18 != 'X' "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE pmn_q FROM l_sql
   EXECUTE pmn_q INTO l_ima.pmn_q  USING p_ima01
 
   IF cl_null(l_ima.pmn_q) THEN LET l_ima.pmn_q=0 END IF
   IF l_ima.pmn_q=0 THEN LET l_ima.pmn_q=NULL END IF
 
   #-->工單在製量
   MESSAGE " (5)Wait..."
   LET l_sql = "SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)", 
               "  FROM ",cl_get_target_table(p_plant,'ima_file') ,","
                        ,cl_get_target_table(p_plant,'sfb_file') ,
               " WHERE sfb05=ima01 ",  
               "   AND sfb02 IN ('1','5','13') ",                            
               "   AND sfb87 !='X' ",
               "   AND sfb08 > (sfb09+sfb10+sfb11+sfb12) ",
               "   AND sfb04 <= '7' ",
               "   AND sfb05 = ? "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sfb_q1 FROM l_sql
   EXECUTE sfb_q1 INTO l_ima.sfb_q1  USING p_ima01

   LET l_shb114 = 0
   LET l_sql = "SELECT SUM(shb114) ",
               "  FROM" ,cl_get_target_table(p_plant,'shb_file'), ","
                        ,cl_get_target_table(p_plant,'sfb_file'), 
               " WHERE shb05 = sfb01 ",
               "   AND shb10 = sfb05 ",
               "   AND sfb02 IN ('1','5','13') ",                                         
               "   AND sfb87 != 'X' ",
               "   AND sfb04 <= '7' ",
               "   AND shb10 = ? ",
               "   AND shb114 > 0 "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sfb_q11 FROM l_sql
   EXECUTE sfb_q11 INTO l_shb114  USING p_ima01                                                       

   IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
   LET l_ima.sfb_q1 = l_ima.sfb_q1 - l_shb114
 
   #-->委外在製量
   LET l_sql = "SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac) ",
               "  FROM " ,cl_get_target_table(p_plant,'sfb_file'), ","
                         ,cl_get_target_table(p_plant,'ima_file'),
               " WHERE sfb05=ima01 ",
               "   AND sfb87!='X' ",
               "   AND sfb08 > (sfb09+sfb10+sfb11+sfb12) ",
               "   AND sfb04 <= '7' ",
               "   AND sfb05 = ? ",
               "   AND sfb02 IN ('7','8') "  
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sfb_q2 FROM l_sql
   EXECUTE sfb_q2 INTO l_ima.sfb_q2  USING p_ima01
   IF cl_null(l_ima.sfb_q2) THEN LET l_ima.sfb_q2=0 END IF  
   
   LET l_shb114 = 0 
   LET l_sql = "SELECT SUM(shb114) ", 
               "  FROM ",cl_get_target_table(p_plant,'shb_file'),","
                        ,cl_get_target_table(p_plant,'sfb_file'),
               " WHERE shb05 = sfb01 ",
               "   AND shb10 = sfb05 ",
               "   AND sfb87 != 'X' ",
               "   AND sfb04 <= '7' ",
               "   AND shb10 = ? ",
               "   AND sfb02 IN ('7','8') " 
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sfb_q112 FROM l_sql
   EXECUTE sfb_q112 INTO l_shb114  USING p_ima01  
   IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
   LET l_ima.sfb_q2 = l_ima.sfb_q2 - l_shb114
 
   LET l_ima.rvb_q2 = 0
   #-->委外IQC在製量
   LET l_sql = "SELECT SUM((rvb07-rvb29-rvb30)*pmn09) ", 
               "  FROM ",cl_get_target_table(p_plant,'rvb_file'),"," 
                        ,cl_get_target_table(p_plant,'rva_file'),"," 
                        ,cl_get_target_table(p_plant,'pmn_file'),
               " WHERE rvb01=rva01 ",
               "   AND rvb04 = pmn01 AND rvb03 = pmn02 ",
               "   AND rvaconf='Y' ",
               "   AND rva10 = 'SUB' ",
               "   AND rvb05 = ? ", 
               "   AND rvb07 > (rvb29+rvb30) "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE rvb_q2 FROM l_sql
   EXECUTE rvb_q2 INTO l_ima.rvb_q2  USING p_ima01
 
 
   #-->IQC 在驗量
   MESSAGE " (6)Wait..."
   LET l_sql= " SELECT SUM((rvb07-rvb29-rvb30)*pmn09) ", 
              "   FROM " ,cl_get_target_table(p_plant,'rvb_file'),"," 
                         ,cl_get_target_table(p_plant,'rva_file'),","
                         ,cl_get_target_table(p_plant,'pmn_file'),
              "  WHERE rvb01=rva01 ",
              "    AND rvb04 = pmn01 AND rvb03 = pmn02 ",
              "    AND rvaconf='Y' ",
              "    AND rva10 != 'SUB' ",
              "    AND rvb05 = ? ",
              "    AND rvb07 > (rvb29+rvb30) "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE rvb_q FROM l_sql
   EXECUTE rvb_q INTO l_ima.rvb_q  USING p_ima01
 
   #-->FQC 在驗量
   MESSAGE " (7)Wait..."
   LET l_sql = " SELECT SUM(sfb11*ima55_fac) ",
               "   FROM " ,cl_get_target_table(p_plant,'sfb_file'),","
                          ,cl_get_target_table(p_plant,'ima_file'),
               "  WHERE sfb05=ima01 ",
               "    AND sfb87 != 'X' ",
               "    AND sfb02 <> '7' ",                  
               "    AND sfb02 <> '8' ",     
               "    AND sfb02 <> '11' ",               
               "    AND sfb04 <= '7' ", 
               "    AND sfb05 = ? ",
               "    AND sfb11 > 0 "      
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE qcf_q FROM l_sql
   EXECUTE qcf_q INTO l_ima.qcf_q  USING p_ima01

   IF l_ima.qcf_q = 0 THEN LET l_ima.qcf_q = '' END IF
   IF l_ima.oeb_q   IS NULL THEN LET l_ima.oeb_q = 0 END IF
   IF l_ima.sfa_q1  IS NULL THEN LET l_ima.sfa_q1 = 0 END IF
   IF l_ima.sfa_q2  IS NULL THEN LET l_ima.sfa_q2 = 0 END IF
   IF l_ima.pml_q   IS NULL THEN LET l_ima.pml_q = 0 END IF
   IF l_ima.pmn_q   IS NULL THEN LET l_ima.pmn_q = 0 END IF
   IF l_ima.rvb_q   IS NULL THEN LET l_ima.rvb_q = 0 END IF
   IF l_ima.sfb_q1  IS NULL THEN LET l_ima.sfb_q1 = 0 END IF
   IF l_ima.sfb_q2  IS NULL THEN LET l_ima.sfb_q2 = 0 END IF
   IF l_ima.qcf_q   IS NULL THEN LET l_ima.qcf_q = 0 END IF
   IF l_ima.sie_q   IS NULL THEN LET l_ima.sie_q = 0 END IF 
   IF l_ima.misc_q1 IS NULL THEN LET l_ima.misc_q1= 0 END IF
   IF l_ima.sfs_q2  IS NULL THEN LET l_ima.sfs_q2 = 0 END IF

   CALL s_getstock(p_ima01,p_plant) RETURNING  l_n1,l_n2,l_n3
   LET l_avl_stk = l_n3 

   LET l_ima.atp_qty = l_avl_stk - l_ima.oeb_q - l_ima.sfa_q1  
                       - l_ima.misc_q1 - l_ima.sfs_q2         #M001 180109 By TSD.Jin add
                                  + l_ima.pml_q + l_ima.pmn_q + l_ima.rvb_q
                                  + l_ima.sfb_q1+ l_ima.sfb_q2+ l_ima.qcf_q

   RETURN l_ima.oeb_q, l_ima.sfa_q1, l_ima.sfa_q2, l_ima.sie_q, l_ima.pml_q,
          l_ima.pmn_q, l_ima.rvb_q2, l_ima.rvb_q, l_ima.sfb_q1, l_ima.sfb_q2,
          l_ima.qcf_q, l_ima.atp_qty,l_ima.misc_q1,l_ima.sfs_q2
END FUNCTION

FUNCTION cs_muplant_atp_qty(p_ima01)
   DEFINE p_ima01         LIKE ima_file.ima01 
   DEFINE l_ima           RECORD
             oeb_q        LIKE type_file.num15_3,
             sfa_q1       LIKE type_file.num15_3,
             sfa_q2       LIKE type_file.num15_3,
             misc_q1      LIKE type_file.num15_3,
             sfs_q2       LIKE type_file.num15_3,
             sie_q        LIKE type_file.num15_3,
             pml_q        LIKE type_file.num15_3,
             pmn_q        LIKE type_file.num15_3,
             rvb_q2       LIKE type_file.num15_3,
             rvb_q        LIKE type_file.num15_3,
             sfb_q1       LIKE type_file.num15_3,
             sfb_q2       LIKE type_file.num15_3,
             qcf_q        LIKE type_file.num15_3, 
             atp_qty      LIKE type_file.num15_3 
                          END RECORD  
   DEFINE l_short_qty     LIKE sfa_file.sfa07 
   DEFINE l_sql           STRING              
   DEFINE lr_sfa          RECORD LIKE sfa_file.*     
   DEFINE l_shb114        LIKE shb_file.shb114
   DEFINE l_sfa_q1        LIKE type_file.num15_3
   DEFINE l_avl_stk       LIKE type_file.num15_3 
   DEFINE l_n1            LIKE type_file.num15_3 
   DEFINE l_n2            LIKE type_file.num15_3 
   DEFINE l_n3            LIKE type_file.num15_3

   WHENEVER ERROR CONTINUE

   #-->受訂量
   MESSAGE " (1)Wait..."
   LET l_ima.oeb_q = 0
   SELECT SUM((oeb12-oeb24+oeb25-oeb26)*oeb05_fac) INTO l_ima.oeb_q 
          FROM oeb_file, oea_file
          WHERE oeb01 = oea01 
            AND oea00 >= '1'
            AND oeb70 = 'N' 
            AND oeaconf = 'Y' 
            AND oeb12-oeb24+oeb25-oeb26>0 #20191111
            AND oeb04 = p_ima01 
 
   #-->工單備料量 & 工單缺料量
   MESSAGE " (2)Wait..."
   LET l_ima.sfa_q1 = 0  
   LET l_ima.sfa_q2=0    
   
    LET l_sql = "SELECT sfa_file.*",
                "  FROM sfa_file,sfb_file",
                " WHERE sfb01=sfa01 ",
               #"   AND sfb04 !='8'",  #20191111
                "   AND sfb02 != '15'",
                "   AND sfb87 !='X'",
                "   AND sfb04 <='7'",   #20191111
                "   AND sfa03 = '",p_ima01,"' "
   PREPARE q102_sum_pre1 FROM l_sql
   DECLARE q102_sum1 CURSOR FOR q102_sum_pre1 
   FOREACH q102_sum1 INTO lr_sfa.*
      CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                      lr_sfa.sfa12,lr_sfa.sfa27,
                      lr_sfa.sfa012,lr_sfa.sfa013)  #FUN-A50066 #TQC-A80005
           RETURNING l_short_qty 
      IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF 
      #   (備料量條件                                                     OR 欠料量條件)
      IF (lr_sfa.sfa05 > (lr_sfa.sfa06 + lr_sfa.sfa065 - lr_sfa.sfa063 ) OR l_short_qty > 0) THEN  
          #工單未備(A)  =    應發sfa05 -    已發sfa06 -    代買sfa065 + 下階料報廢sfa063 -    超領sfa062
          #若 A  < 0 ,則 LET A = 0
           LET l_sfa_q1 =(lr_sfa.sfa05 - lr_sfa.sfa06 - lr_sfa.sfa065 +    lr_sfa.sfa063 - lr_sfa.sfa062 ) * lr_sfa.sfa13
           IF l_sfa_q1 < 0 THEN
               LET l_sfa_q1 = 0
           END IF
           LET l_ima.sfa_q1= l_ima.sfa_q1 + l_sfa_q1
           LET l_ima.sfa_q2= l_ima.sfa_q2 + (l_short_qty * lr_sfa.sfa13)
      END IF            
   END FOREACH

   #M001 180109 By TSD.Jin--start--
   #-->雜發單未扣帳量
   LET l_ima.misc_q1 = 0
   SELECT SUM(inb09) INTO l_ima.misc_q1
     FROM inb_file,ina_file
    WHERE ina01 = inb01
      AND ina00 = '1'      #庫存雜發單
      AND inaconf = 'Y'    #已確認
      AND inapost = 'N'    #未過帳
      AND inb04 = p_ima01

   #-->超耗單未扣帳量
   LET l_ima.sfs_q2 = 0
   SELECT SUM(sfs05) INTO l_ima.sfs_q2
     FROM sfs_file,sfp_file
    WHERE sfp01 = sfs01
      AND sfpconf = 'Y'    #已確認
      AND sfp04   = 'N'    #未過帳
      AND sfp06 = '2'     #超領
      AND sfs04 = p_ima01
   #M001 180109 By TSD.Jin--end----
   
   #-->請購量
   MESSAGE " (3)Wait..."
   SELECT SUM((pml20-pml21)*pml09) INTO l_ima.pml_q
         FROM pml_file, pmk_file
        WHERE pml01 = pmk01
          AND pml16 IN ('0','1','2','S','R','W')                    #20191111
         #AND ( pml16 <='2' OR pml16='S' OR pml16='R' OR pml16='W') #20191111
         #AND pml011 !='SUB'  #20191111
          AND pml20 > pml21
          AND pmk18 != 'X'
          AND pml04 = p_ima01

   SELECT SUM(sig05) INTO l_ima.sie_q 
         FROM sig_file #,ima_file  
        WHERE sig01 = p_ima01
          AND sig05 > 0  #20191111 

   #-->採購量
   MESSAGE " (4)Wait..."
   SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) INTO l_ima.pmn_q   
         FROM pmn_file, pmm_file
        WHERE pmn01 = pmm01
         #AND ( pmn16 <='2' OR pmn16='S' OR pmn16='R' OR pmn16='W') #20191111
          AND pmn16 IN ('0','1','2','S','R','W') #20191111
          AND pmn011 !='SUB'
          AND pmm18 != 'X'
          AND pmn20 > pmn50-pmn55-pmn58   #No.FUN-9A0068 
          AND pmn04 = p_ima01
 
   IF cl_null(l_ima.pmn_q) THEN LET l_ima.pmn_q=0 END IF
   IF l_ima.pmn_q=0 THEN LET l_ima.pmn_q=NULL END IF
 
   #-->工單在製量
   MESSAGE " (5)Wait..."
   SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)
     INTO l_ima.sfb_q1
     FROM ima_file,sfb_file
    WHERE sfb05=ima01
     #AND ( sfb02 !='7' AND sfb02 !='8' AND sfb02 !='11' AND sfb02 != '15' )    #20191111
      AND sfb02 IN ('1','5','13')                                               #20191111 
      AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X'
      AND sfb04 <= '7'
      AND sfb05 = p_ima01

   LET l_shb114 = 0
   SELECT SUM(shb114) INTO l_shb114 
     FROM shb_file,sfb_file
    WHERE shb05 = sfb01
      AND shb10 = sfb05
      AND sfb87 != 'X'
     #AND ( sfb02 !='7' AND sfb02 !='8' AND sfb02 !='11' AND sfb02 != '15' )    #20191111
      AND sfb02 IN ('1','5','13')                                               #20191111
      AND sfb04 <= '7'
      AND shb114 > 0                                                            #20191111 
      AND shb10 = p_ima01
   IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
   LET l_ima.sfb_q1 = l_ima.sfb_q1 - l_shb114
 
   #-->委外在製量
   SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)
     INTO l_ima.sfb_q2
     FROM ima_file,sfb_file
    WHERE sfb05=ima01 
      AND sfb87 !='X'
      AND sfb08 > (sfb09+sfb10+sfb11+sfb12)
      AND sfb04 <= '7'
      AND sfb05 = p_ima01 
      AND sfb02 IN ('7','8')   #FUN-5B0114
   IF cl_null(l_ima.sfb_q2) THEN LET l_ima.sfb_q2=0 END IF  
   
   LET l_shb114 = 0 
   SELECT SUM(shb114) INTO l_shb114 
     FROM shb_file,sfb_file
    WHERE shb05 = sfb01
      AND shb10 = sfb05
      AND sfb04 <= '7' AND sfb87 != 'X'
     #AND ( sfb02 ='7' AND sfb02 ='8')     #20180426 mark
      AND sfb02 IN ('7','8')      #20180426 modify 
      AND shb10 = p_ima01
      AND shb114 > 0              #20191111
   IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
   LET l_ima.sfb_q2 = l_ima.sfb_q2 - l_shb114
 
   LET l_ima.rvb_q2 = 0
   #-->委外IQC在製量
   SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO l_ima.rvb_q2 
     FROM rvb_file, rva_file, pmn_file
    WHERE rvb01=rva01
      AND rvb04 = pmn01 AND rvb03 = pmn02
      AND rvaconf='Y'  
      AND rva10 ='SUB'
      AND rvb05 = p_ima01 
      AND rvb07 > (rvb29+rvb30)  
     #AND pmn43 = 0                      #20180410 mark by momo 走製程不能預設為0  
   IF cl_null(l_ima.rvb_q2) THEN LET l_ima.rvb_q2=0 END IF   
 
  #委外在置量應加上委外IQC在驗量
  #LET l_ima.sfb_q2 = l_ima.sfb_q2 + l_ima.rvb_q2   #20180503 mark 委外IQC不等於委外工單
  #IF l_ima.sfb_q2=0 THEN LET l_ima.sfb_q2=NULL END IF     
  #IF l_ima.rvb_q2=0 THEN LET l_ima.rvb_q2=NULL END IF     
 
   #-->IQC 在驗量
   MESSAGE " (6)Wait..."
   SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO l_ima.rvb_q
         FROM rvb_file, rva_file, pmn_file
        WHERE rvb01=rva01
          AND rvb04 = pmn01 AND rvb03 = pmn02
          AND rvaconf='Y'
          AND rva10 != 'SUB' 
          AND rvb07-rvb29-rvb30 > 0 
          AND rvb05 = p_ima01
 
   #-->FQC 在驗量
   MESSAGE " (7)Wait..."
   SELECT SUM(sfb11*ima55_fac) INTO l_ima.qcf_q
     FROM ima_file,sfb_file
    WHERE sfb05=ima01
      AND sfb02 <> '7' AND sfb87!='X'
      AND sfb02 <> '8'   #FUN-5B0069
      AND sfb02 <> '11'  
      AND sfb04 <= '7'
      AND sfb05 = p_ima01 
      AND sfb11 > 0      #20191111 

   IF SQLCA.sqlcode OR STATUS THEN LET l_ima.qcf_q = '' END IF
   IF l_ima.qcf_q = 0 THEN LET l_ima.qcf_q = '' END IF
   IF l_ima.oeb_q   IS NULL THEN LET l_ima.oeb_q = 0 END IF
   IF l_ima.sfa_q1  IS NULL THEN LET l_ima.sfa_q1 = 0 END IF
   IF l_ima.sfa_q2  IS NULL THEN LET l_ima.sfa_q2 = 0 END IF
   IF l_ima.pml_q   IS NULL THEN LET l_ima.pml_q = 0 END IF
   IF l_ima.pmn_q   IS NULL THEN LET l_ima.pmn_q = 0 END IF
   IF l_ima.rvb_q   IS NULL THEN LET l_ima.rvb_q = 0 END IF
   IF l_ima.sfb_q1  IS NULL THEN LET l_ima.sfb_q1 = 0 END IF
   IF l_ima.sfb_q2  IS NULL THEN LET l_ima.sfb_q2 = 0 END IF
   IF l_ima.qcf_q   IS NULL THEN LET l_ima.qcf_q = 0 END IF
   IF l_ima.sie_q   IS NULL THEN LET l_ima.sie_q = 0 END IF 
   IF l_ima.misc_q1 IS NULL THEN LET l_ima.misc_q1= 0 END IF
   IF l_ima.sfs_q2  IS NULL THEN LET l_ima.sfs_q2 = 0 END IF

   CALL s_getstock(p_ima01,g_plant) RETURNING  l_n1,l_n2,l_n3
   LET l_avl_stk = l_n3 

   LET l_ima.atp_qty = l_avl_stk - l_ima.oeb_q - l_ima.sfa_q1  
                       - l_ima.misc_q1 - l_ima.sfs_q2         #M001 180109 By TSD.Jin add
                                  + l_ima.pml_q + l_ima.pmn_q + l_ima.rvb_q
                                  + l_ima.sfb_q1+ l_ima.sfb_q2+ l_ima.qcf_q

   RETURN l_ima.atp_qty
END FUNCTION

FUNCTION cs_muplant_atpqty(p_ima01, p_plant)
   DEFINE p_ima01         LIKE ima_file.ima01 
   DEFINE p_plant         LIKE type_file.chr10
   DEFINE l_ima           RECORD
             oeb_q        LIKE type_file.num15_3,
             sfa_q1       LIKE type_file.num15_3,
             sfa_q2       LIKE type_file.num15_3,
             misc_q1      LIKE type_file.num15_3,
             sfs_q2       LIKE type_file.num15_3,
             sie_q        LIKE type_file.num15_3,
             pml_q        LIKE type_file.num15_3,
             pmn_q        LIKE type_file.num15_3,
             rvb_q2       LIKE type_file.num15_3,
             rvb_q        LIKE type_file.num15_3,
             sfb_q1       LIKE type_file.num15_3,
             sfb_q2       LIKE type_file.num15_3,
             qcf_q        LIKE type_file.num15_3, 
             atp_qty      LIKE type_file.num15_3 
                          END RECORD  
   DEFINE l_short_qty     LIKE sfa_file.sfa07 
   DEFINE l_sql           STRING              
   DEFINE lr_sfa          RECORD LIKE sfa_file.*     
   DEFINE l_shb114        LIKE shb_file.shb114
   DEFINE l_sfa_q1        LIKE type_file.num15_3
   DEFINE l_avl_stk       LIKE type_file.num15_3 
   DEFINE l_n1            LIKE type_file.num15_3 
   DEFINE l_n2            LIKE type_file.num15_3 
   DEFINE l_n3            LIKE type_file.num15_3

   WHENEVER ERROR CONTINUE

   #-->受訂量
   LET l_sql = "SELECT SUM((oeb12-oeb24+oeb25-oeb26)*oeb05_fac)",
           "  FROM ",cl_get_target_table(p_plant,'oeb_file'),"," 
                    ,cl_get_target_table(p_plant,'oea_file'),
           " WHERE oeb01 = oea01",
           "   AND oea00 >= '1'", 
           "   AND oeb70 = 'N'", 
           "   AND oeaconf = 'Y' ", 
           " AND oeb12 > (oeb24+oeb25-oeb26)", 
           " AND oeb04 = ? "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE oeb_q3 FROM l_sql
   EXECUTE oeb_q3 INTO l_ima.oeb_q  USING p_ima01
   IF cl_null(l_ima.oeb_q) THEN
      LET l_ima.oeb_q = 0
   END IF
 
   #-->工單備料量 & 工單缺料量
   LET l_ima.sfa_q1 = 0  
   LET l_ima.sfa_q2=0    
   
    LET l_sql = "SELECT sfa_file.* ",
                "  FROM ",cl_get_target_table(p_plant,'sfa_file'),","
                         ,cl_get_target_table(p_plant,'sfb_file'),
                " WHERE sfb01=sfa01 ",
                "   AND sfa03 = '",p_ima01,"'",
                "   AND sfb02 != '15'",
                "   AND sfb87 !='X'",
                "   AND sfb04 <= '7'"
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE q102_sum_pre3 FROM l_sql
   DECLARE q102_sum3 CURSOR FOR q102_sum_pre3 
   FOREACH q102_sum3 INTO lr_sfa.*
      CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                      lr_sfa.sfa12,lr_sfa.sfa27,
                      lr_sfa.sfa012,lr_sfa.sfa013)  #FUN-A50066 #TQC-A80005
           RETURNING l_short_qty 
      IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF 
      #   (備料量條件                                                     OR 欠料量條件)
      IF (lr_sfa.sfa05 > (lr_sfa.sfa06 + lr_sfa.sfa065 - lr_sfa.sfa063 ) OR l_short_qty > 0) THEN  
          #工單未備(A)  =    應發sfa05 -    已發sfa06 -    代買sfa065 + 下階料報廢sfa063 -    超領sfa062
          #若 A  < 0 ,則 LET A = 0
           LET l_sfa_q1 =(lr_sfa.sfa05 - lr_sfa.sfa06 - lr_sfa.sfa065 +    lr_sfa.sfa063 - lr_sfa.sfa062 ) * lr_sfa.sfa13
           IF l_sfa_q1 < 0 THEN
               LET l_sfa_q1 = 0
           END IF
           LET l_ima.sfa_q1= l_ima.sfa_q1 + l_sfa_q1
           LET l_ima.sfa_q2= l_ima.sfa_q2 + (l_short_qty * lr_sfa.sfa13)
      END IF            
   END FOREACH

   #M001 180109 By TSD.Jin--start--
   #-->雜發單未扣帳量
   LET l_ima.misc_q1 = 0
   LET l_sql = "SELECT SUM(inb09*inb08_fac)", 
           "  FROM ",cl_get_target_table(p_plant,'inb_file'),","
                    ,cl_get_target_table(p_plant,'ina_file'), 
           " WHERE ina01 = inb01",
           "   AND inb04 = ? ",
           "   AND ina00 = '1' ",      #庫存雜發單
           "   AND inaconf = 'Y' ",    #已確認
           "   AND inapost = 'N' "     #未過帳
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE misc_q13 FROM l_sql
   EXECUTE misc_q13 INTO l_ima.misc_q1  USING p_ima01

   #-->超耗單未扣帳量
   LET l_ima.sfs_q2 = 0
   LET l_sql = "SELECT SUM(sfs05) ", 
           "  FROM " ,cl_get_target_table(p_plant,'sfs_file'),","
                     ,cl_get_target_table(p_plant,'sfp_file'), 
          "  WHERE sfp01 = sfs01 ",
          "    AND sfs04 = ? ",
          "    AND sfpconf = 'Y' ",   #已確認
          "    AND sfp04   = 'N' ",   #未過帳
         "     AND sfp06 = '2' "     #超領
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sfs_q23 FROM l_sql
   EXECUTE sfs_q23 INTO l_ima.sfs_q2  USING p_ima01
   #M001 180109 By TSD.Jin--end----
   
   #-->請購量
   LET l_sql = "SELECT SUM((pml20-pml21)*pml09) ", 
               "  FROM " ,cl_get_target_table(p_plant,'pml_file'),","
                         ,cl_get_target_table(p_plant,'pmk_file'),
               " WHERE pml01 = pmk01 ",
               "   AND pml16 IN ('0','1','2','S','R','W') ",
               "   AND pml20 > pml21 ",
               "   AND pml04 = ? ",
               "   AND pmk18 != 'X' "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE pml_q3 FROM l_sql
   EXECUTE pml_q3 INTO l_ima.pml_q  USING p_ima01
   IF cl_null(l_ima.pml_q) THEN LET l_ima.pml_q = 0 END IF

   #--> 備置量
   LET l_sql= "SELECT SUM(sig05)  ", 
              "  FROM " ,cl_get_target_table(p_plant,'sig_file'),                         
              " WHERE sig01 = ?   "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sie_q3 FROM l_sql
   EXECUTE sie_q3 INTO l_ima.sie_q  USING p_ima01
   IF cl_null(l_ima.sie_q) THEN LET l_ima.sie_q = 0 END IF               

   #-->採購量
   MESSAGE " (4)Wait..."
   LET l_sql = "SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) ",  
               "  FROM ",cl_get_target_table(p_plant, 'pmn_file'),"," 
                        ,cl_get_target_table(p_plant, 'pmm_file'), 
               " WHERE pmn01 = pmm01 ",
               "   AND pmn16 IN ('0','1','2','S','R','W')   ",   
               "   AND pmn011 !='SUB' ",
               "   AND pmn20 > pmn50-pmn55-pmn58 ",   
               "   AND pmn04 = ? ",
               "   AND pmm18 != 'X' "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE pmn_q3 FROM l_sql
   EXECUTE pmn_q3 INTO l_ima.pmn_q  USING p_ima01
 
   IF cl_null(l_ima.pmn_q) THEN LET l_ima.pmn_q=0 END IF
   IF l_ima.pmn_q=0 THEN LET l_ima.pmn_q=NULL END IF
 
   #-->工單在製量
   MESSAGE " (5)Wait..."
   LET l_sql = "SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)", 
               "  FROM ",cl_get_target_table(p_plant,'ima_file') ,","
                        ,cl_get_target_table(p_plant,'sfb_file') ,
               " WHERE sfb05=ima01 ",  
               "   AND sfb02 IN ('1','5','13') ",                            
               "   AND sfb87 !='X' ",
               "   AND sfb08 > (sfb09+sfb10+sfb11+sfb12) ",
               "   AND sfb04 <= '7' ",
               "   AND sfb05 = ? "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sfb_q13 FROM l_sql
   EXECUTE sfb_q13 INTO l_ima.sfb_q1  USING p_ima01

   LET l_shb114 = 0
   LET l_sql = "SELECT SUM(shb114) ",
               "  FROM" ,cl_get_target_table(p_plant,'shb_file'), ","
                        ,cl_get_target_table(p_plant,'sfb_file'), 
               " WHERE shb05 = sfb01 ",
               "   AND shb10 = sfb05 ",
               "   AND sfb02 IN ('1','5','13') ",                                         
               "   AND sfb87 != 'X' ",
               "   AND sfb04 <= '7' ",
               "   AND shb10 = ? ",
               "   AND shb114 > 0 "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sfb_q113 FROM l_sql
   EXECUTE sfb_q113 INTO l_shb114  USING p_ima01                                                       

   IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
   LET l_ima.sfb_q1 = l_ima.sfb_q1 - l_shb114
 
   #-->委外在製量
   LET l_sql = "SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac) ",
               "  FROM " ,cl_get_target_table(p_plant,'sfb_file'), ","
                         ,cl_get_target_table(p_plant,'ima_file'),
               " WHERE sfb05=ima01 ",
               "   AND sfb87!='X' ",
               "   AND sfb08 > (sfb09+sfb10+sfb11+sfb12) ",
               "   AND sfb04 <= '7' ",
               "   AND sfb05 = ? ",
               "   AND sfb02 IN ('7','8') "  
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sfb_q23 FROM l_sql
   EXECUTE sfb_q23 INTO l_ima.sfb_q2  USING p_ima01
   IF cl_null(l_ima.sfb_q2) THEN LET l_ima.sfb_q2=0 END IF  
   
   LET l_shb114 = 0 
   LET l_sql = "SELECT SUM(shb114) ", 
               "  FROM ",cl_get_target_table(p_plant,'shb_file'),","
                        ,cl_get_target_table(p_plant,'sfb_file'),
               " WHERE shb05 = sfb01 ",
               "   AND shb10 = sfb05 ",
               "   AND sfb87 != 'X' ",
               "   AND sfb04 <= '7' ",
               "   AND shb10 = ? ",
               "   AND sfb02 IN ('7','8') " 
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sfb_q1123 FROM l_sql
   EXECUTE sfb_q1123 INTO l_shb114  USING p_ima01  
   IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
   LET l_ima.sfb_q2 = l_ima.sfb_q2 - l_shb114
 
   LET l_ima.rvb_q2 = 0
   #-->委外IQC在製量
   LET l_sql = "SELECT SUM((rvb07-rvb29-rvb30)*pmn09) ", 
               "  FROM ",cl_get_target_table(p_plant,'rvb_file'),"," 
                        ,cl_get_target_table(p_plant,'rva_file'),"," 
                        ,cl_get_target_table(p_plant,'pmn_file'),
               " WHERE rvb01=rva01 ",
               "   AND rvb04 = pmn01 AND rvb03 = pmn02 ",
               "   AND rvaconf='Y' ",
               "   AND rva10 = 'SUB' ",
               "   AND rvb05 = ? ", 
               "   AND rvb07 > (rvb29+rvb30) "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE rvb_q23 FROM l_sql
   EXECUTE rvb_q23 INTO l_ima.rvb_q2  USING p_ima01
 
 
   #-->IQC 在驗量
   MESSAGE " (6)Wait..."
   LET l_sql= " SELECT SUM((rvb07-rvb29-rvb30)*pmn09) ", 
              "   FROM " ,cl_get_target_table(p_plant,'rvb_file'),"," 
                         ,cl_get_target_table(p_plant,'rva_file'),","
                         ,cl_get_target_table(p_plant,'pmn_file'),
              "  WHERE rvb01=rva01 ",
              "    AND rvb04 = pmn01 AND rvb03 = pmn02 ",
              "    AND rvaconf='Y' ",
              "    AND rva10 != 'SUB' ",
              "    AND rvb05 = ? ",
              "    AND rvb07 > (rvb29+rvb30) "
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE rvb_q3 FROM l_sql
   EXECUTE rvb_q3 INTO l_ima.rvb_q  USING p_ima01
 
   #-->FQC 在驗量
   MESSAGE " (7)Wait..."
   LET l_sql = " SELECT SUM(sfb11*ima55_fac) ",
               "   FROM " ,cl_get_target_table(p_plant,'sfb_file'),","
                          ,cl_get_target_table(p_plant,'ima_file'),
               "  WHERE sfb05=ima01 ",
               "    AND sfb87 != 'X' ",
               "    AND sfb02 <> '7' ",                  
               "    AND sfb02 <> '8' ",     
               "    AND sfb02 <> '11' ",               
               "    AND sfb04 <= '7' ", 
               "    AND sfb05 = ? ",
               "    AND sfb11 > 0 "      
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE qcf_q3 FROM l_sql
   EXECUTE qcf_q3 INTO l_ima.qcf_q  USING p_ima01

   IF l_ima.qcf_q = 0 THEN LET l_ima.qcf_q = '' END IF
   IF l_ima.oeb_q   IS NULL THEN LET l_ima.oeb_q = 0 END IF
   IF l_ima.sfa_q1  IS NULL THEN LET l_ima.sfa_q1 = 0 END IF
   IF l_ima.sfa_q2  IS NULL THEN LET l_ima.sfa_q2 = 0 END IF
   IF l_ima.pml_q   IS NULL THEN LET l_ima.pml_q = 0 END IF
   IF l_ima.pmn_q   IS NULL THEN LET l_ima.pmn_q = 0 END IF
   IF l_ima.rvb_q   IS NULL THEN LET l_ima.rvb_q = 0 END IF
   IF l_ima.sfb_q1  IS NULL THEN LET l_ima.sfb_q1 = 0 END IF
   IF l_ima.sfb_q2  IS NULL THEN LET l_ima.sfb_q2 = 0 END IF
   IF l_ima.qcf_q   IS NULL THEN LET l_ima.qcf_q = 0 END IF
   IF l_ima.sie_q   IS NULL THEN LET l_ima.sie_q = 0 END IF 
   IF l_ima.misc_q1 IS NULL THEN LET l_ima.misc_q1= 0 END IF
   IF l_ima.sfs_q2  IS NULL THEN LET l_ima.sfs_q2 = 0 END IF

   CALL s_getstock(p_ima01,p_plant) RETURNING  l_n1,l_n2,l_n3
   LET l_avl_stk = l_n3 

   LET l_ima.atp_qty = l_avl_stk - l_ima.oeb_q - l_ima.sfa_q1  
                       - l_ima.misc_q1 - l_ima.sfs_q2         #M001 180109 By TSD.Jin add
                                  + l_ima.pml_q + l_ima.pmn_q + l_ima.rvb_q
                                  + l_ima.sfb_q1+ l_ima.sfb_q2+ l_ima.qcf_q

   RETURN l_ima.atp_qty
END FUNCTION
