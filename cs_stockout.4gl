# Prog. Version..: '5.30.24-17.04.13(00000)'     #
# Pattern name...: cs_stockout.4gl
# Descriptions...: 工單缺料狀況
# Date & Author..: momo
# Usage..........: CALL cs_stockout(p_sfb01,p_ta_sfb01) RETURNING: l_str
# Input Parameter: p_oeb01     
# Return code....: l_str   版本 
# Memo...........:

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cs_stockout(p_ta_sfb01, p_plant)

DEFINE p_sfb01     LIKE sfb_file.sfb01 
DEFINE p_ta_sfb01  LIKE sfb_file.ta_sfb01 
DEFINE p_plant     LIKE type_file.chr10
DEFINE g_sql       STRING
DEFINE l_str       LIKE type_file.chr1000
DEFINE l_str2      LIKE type_file.chr1000
DEFINE l_str3      LIKE type_file.chr1000
DEFINE l_str4      LIKE type_file.chr1000
DEFINE l_str5      LIKE type_file.chr1000
DEFINE l_str6      LIKE type_file.chr1000
DEFINE l_sfa03     LIKE sfa_file.sfa03
DEFINE l_pmc03     LIKE pmc_file.pmc03
DEFINE l_pmn33     LIKE pmn_file.pmn33
DEFINE l_ima02     LIKE ima_file.ima02
DEFINE l_ima021    LIKE ima_file.ima021
DEFINE l_status    STRING
DEFINE l_num       LIKE type_file.num5
DEFINE l_pmn20     LIKE pmn_file.pmn20
DEFINE l_pmn50     LIKE pmn_file.pmn50
DEFINE l_pmn51     LIKE pmn_file.pmn51
DEFINE l_pmn53     LIKE pmn_file.pmn53
DEFINE l_img10     LIKE img_file.img10
DEFINE l_sfs04     LIKE sfs_file.sfs04 #超領
DEFINE l_sfa05     LIKE sfa_file.sfa05 #未發
DEFINE l_pmn01     LIKE pmn_file.pmn01
DEFINE l_pmn02     LIKE pmn_file.pmn02
DEFINE l_qcs14     LIKE qcs_file.qcs14
DEFINE l_sie11     LIKE sie_file.sie11 #未備置量 20231214

   WHENEVER ERROR CONTINUE

   LET l_num = 0
   LET l_str = ''
   LET l_str2= '' 
   LET l_sfs04=''
   LET l_sfa03=''

   LET g_sql = "SELECT distinct sfa03,sfs04,sfa05-sfa06 ",
               " FROM sfb_file,sfa_file ", 
               " LEFT JOIN (SELECT sfs03,sfs04 FROM sfp_file,sfs_file ",
               "             WHERE sfp01=sfs01 AND sfp04='N' and sfpconf<>'X' AND sfp06='2') ON sfa01=sfs03 AND sfs04 =sfa03",
               " WHERE sfa01 = sfb01 AND sfa05 > sfa06 ",
               "   AND sfb04 <='7' AND sfb87<>'X' ",
               "   AND ta_sfb01 = '",p_ta_sfb01,"' ",
             # "   AND NOT EXISTS (SELECT 1 FROM sic_file WHERE sic03=sfa01 AND sic03=sfa03 ) ",  #20231214 mark
               " ORDER BY 1"
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
   PREPARE check_sfa03 FROM g_sql
   DECLARE check_cur CURSOR FOR check_sfa03
   FOREACH check_cur INTO l_sfa03,l_sfs04,l_sfa05
        LET l_pmc03=''
        LET l_img10 = 0
        LET l_pmn50 = 0 
        LET l_pmn51 = 0 
        LET l_pmn53 = 0 
        LET l_pmn20 = 0
        LET l_pmn01 = ''
        LET l_pmn02 = 0 
        LET l_status = ''
       
        ##-- 排除批號已入庫未發料
        SELECT SUM(img10) INTO l_img10
         FROM img_file
        WHERE img10 > 0
          AND img01 = l_sfa03
          AND img23 = 'Y'
          AND img04 = p_ta_sfb01
        
        IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
        IF l_img10 >= l_sfa05 THEN
           CONTINUE FOREACH
        END IF
        IF l_img10 > 0 THEN LET l_sfa05= l_sfa05 - l_img10 END IF #取欠料餘量 20240112

        #-- 抓取同單號備置量
        SELECT SUM(sie11) INTO l_sie11
          FROM sie_file,sfb_file
         WHERE sie01 = l_sfa03
           AND ta_sfb01 = p_ta_sfb01
           AND sie05 = sfb01
           AND sie11 > 0
        IF cl_null(l_sie11) THEN LET l_sie11 = 0 END IF
        IF l_sie11 >= l_sfa05 THEN
           CONTINUE FOREACH
        END IF
        IF l_sie11 > 0 THEN LET l_sfa05= l_sfa05 - l_sie11 END IF #取欠料餘量 20240112
     
        ##-- 取其他批號或無批號庫存量
        #SELECT SUM(img10),img04 INTO l_img10   #20240112 mark
        SELECT SUM(img10) INTO l_img10          #20240112 modify
             FROM img_file
           WHERE img10 > 0
             AND img01 = l_sfa03
             AND img23 = 'Y'
             #-- view_nostockout 抓取未扣帳訂單與雜發單 --
             AND NOT EXISTS (SELECT 1 FROM view_nostockout WHERE img04 = lot )
        #GROUP BY img04                        #20230112 mark
        IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
        IF l_img10 >= l_sfa05 THEN
           CONTINUE FOREACH
        END IF
        IF l_img10 > 0 THEN LET l_sfa05= l_sfa05 - l_img10 END IF #取欠料餘量 20240112

        ##--- 20231214 取備置 
        LET l_sie11 = 0
        SELECT SUM(sie11) INTO l_sie11
          FROM sie_file
         WHERE sie01 = l_sfa03
           AND sie05||LPAD(sie15,3,'0') <> p_ta_sfb01
           AND sie11 > 0
        IF cl_null(l_sie11) THEN LET l_sie11 = 0 END IF
             
        LET l_img10 = l_img10 - l_sie11                  #庫存-備置

        IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
        IF l_img10 >= l_sfa05 THEN
           CONTINUE FOREACH
        END IF
 
       LET l_num = l_num+1    #計數
       #品名、規格
       SELECT ima02,ima021 INTO l_ima02,l_ima021
         FROM ima_file
        WHERE (ima01 = l_sfa03
          OR ima01 = l_sfs04)

       #對應批號未入庫採單
        SELECT pmc03,pmn33,pmn20,pmn50-pmn55,pmn51,pmn53,pmn01,pmn02
          INTO l_pmc03,l_pmn33,l_pmn20,l_pmn50,l_pmn51,l_pmn53,l_pmn01,l_pmn02
          FROM pmc_file,pmm_file,pmn_file
         WHERE pmc01=pmm09
           AND pmn56 = p_ta_sfb01
           AND pmm01 = pmn01
           AND pmm18 = 'Y'
           AND pmn16 IN ('0','1','2','S','R','W')
           AND pmn20 > pmn53+pmn58
           AND pmn04 = l_sfa03

        IF cl_null(l_pmc03) THEN
           #無對應批號採單
           SELECT pmc03,pmn33,pmn20,pmn50-pmn55,pmn51,pmn53,pmn01,pmn02
             INTO l_pmc03,l_pmn33,l_pmn20,l_pmn50,l_pmn51,l_pmn53,l_pmn01,l_pmn02
             FROM pmc_file,pmn_file,pmm_file
            WHERE pmc01=pmm09
              AND pmm01 = pmn01
              AND pmm18 = 'Y'
              AND pmn04 = l_sfa03
              AND pmn33 = (SELECT MIN(pmn33) FROM pmn_file WHERE pmn04=l_sfa03 AND pmn20 > pmn53+pmn58
                              AND pmn16 IN ('0','1','2','S','R','W'))
        END IF

        LET l_status = '' 
        IF l_pmn20 > l_pmn50-l_pmn51-l_pmn53 THEN
           LET l_status = l_pmc03,l_pmn33
        END IF

        IF l_pmn51 > 0 THEN
           SELECT qcs14 INTO l_qcs14
             FROM qcs_file,rvb_file
            WHERE qcs01 = rvb01 AND qcs02 = rvb02
              AND rvb04 = l_pmn01 AND rvb03= l_pmn02
           IF l_qcs14='Y' THEN LET l_status = '--待入庫'
           ELSE 
              LET l_status = '--品檢'
           END IF
        END IF


        IF NOT cl_null(l_sfs04) THEN
          LET l_status = '--超領'
        END IF

        IF l_num > 0 AND l_num <= 10 THEN
           LET l_str = '(',l_num USING "&&" ,')',l_sfa03,'-',l_ima02,'-',l_ima021,'-',l_status
           LET l_str2 = l_str2 CLIPPED,l_str CLIPPED
        END IF

        IF l_num > 10 AND l_num <=20 THEN
           LET l_str = '(',l_num USING "&&" ,')',l_sfa03,'-',l_ima02,'-',l_ima021,'-',l_status
           LET l_str3 = l_str3 CLIPPED,l_str CLIPPED
        END IF
        
        IF l_num > 20 AND l_num <=30 THEN
           LET l_str = '(',l_num USING "&&" ,')',l_sfa03,'-',l_ima02,'-',l_ima021,'-',l_status
           LET l_str4 = l_str4 CLIPPED,l_str CLIPPED
        END IF

        IF l_num > 30 AND l_num <=40 THEN
           LET l_str = '(',l_num USING "&&" ,')',l_sfa03,'-',l_ima02,'-',l_ima021,'-',l_status
           LET l_str5 = l_str5 CLIPPED,l_str CLIPPED
        END IF

        IF l_num > 40 AND l_num <=50 THEN
           LET l_str = '(',l_num USING "&&" ,')',l_sfa03,'-',l_ima02,'-',l_ima021,'-',l_status
           LET l_str6 = l_str6 CLIPPED,l_str CLIPPED
        END IF
   END FOREACH


   RETURN  l_str2,l_str3,l_str4,l_str5,l_str6,l_num
END FUNCTION
