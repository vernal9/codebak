# Prog. Version..: 5.30
#
# Pattern name...: 
# Descriptions...: GP產能指標小程式
# Date & Author..: 20/08/27 By TSC.Sammmi

DATABASE ds

#GLOBALS "../../config/top.global"

DEFINE g_sql    STRING 
       
DEFINE sr1   
       DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
        data       VARCHAR(200)
       END RECORD
	   
DEFINE l_i          LIKE type_file.num5
DEFINE g_cnt        LIKE type_file.num10

DEFINE l_YM         VARCHAR(10)

DEFINE l_where1    STRING 
DEFINE l_where2    STRING
DEFINE l_where3    STRING

DEFINE l_bdate     VARCHAR(50)
DEFINE l_edate     VARCHAR(50)

MAIN
CLOSE DATABASE 
DATABASE ty #改

   CREATE TEMP TABLE data_tmp(
        data       VARCHAR(200),
        data01     VARCHAR(200),
        data02     VARCHAR(200),
        data03     VARCHAR(200),
        data04     VARCHAR(200),
        data05     VARCHAR(200),
        data06     VARCHAR(200),
        data07     VARCHAR(200),
        data08     VARCHAR(200),
        data09     VARCHAR(200),
        data10     VARCHAR(200),
        data11     VARCHAR(200),
        data12     VARCHAR(200),
        data13     VARCHAR(200),
        data14     VARCHAR(200),
        data15     VARCHAR(200),
        data16     VARCHAR(200),
        data17     VARCHAR(200),
        data18     VARCHAR(200),
        data19     VARCHAR(200),
        data20     VARCHAR(200),
        data21     VARCHAR(200),
        data22     VARCHAR(200),
        data23     VARCHAR(200),
        data24     VARCHAR(200)
   )
   

   CREATE TEMP TABLE data_tmp2(
        data       VARCHAR(200),
        data01     VARCHAR(200),
        data02     VARCHAR(200),
        data03     VARCHAR(200),
        data04     VARCHAR(200)
   )
   
   DELETE FROM data_tmp 
   DELETE FROM data_tmp2

   LET l_bdate = '202203'
   LET l_edate = '202402'
   #計算月份
   LET g_sql = 
              "  select TO_CHAR(MIN(sme01),'YYYYMM')                                      ",
              "    from sme_file                                                          ",
              "   where TO_CHAR(sme01,'YYYYMM') between '",l_bdate,"' and '",l_edate,"'   ",
              "   GROUP BY TO_CHAR(sme01,'YYYYMM')                                        ",   
              "   order BY TO_CHAR(sme01,'YYYYMM')                                        "
   PREPARE r001_prep FROM g_sql                                                   
   DECLARE r001_curs CURSOR FOR r001_prep
   
   #明細近一年即可
   LET l_bdate = '202303'
   LET l_edate = '202402'
   #計算月份
   LET g_sql = 
              "  select TO_CHAR(MIN(sme01),'YYYYMM')                                      ",
              "    from sme_file                                                          ",
              "   where TO_CHAR(sme01,'YYYYMM') between '",l_bdate,"' and '",l_edate,"'   ",
              "   GROUP BY TO_CHAR(sme01,'YYYYMM')                                        ",   
              "   order BY TO_CHAR(sme01,'YYYYMM')                                        "
   PREPARE new_r001_prep FROM g_sql                                                   
   DECLARE new_r001_curs CURSOR FOR new_r001_prep

   LET g_cnt = 0
   SELECT count(distinct(azf03)) into g_cnt from azf_file,ima_file  where ima12 = azf01  and azf03 in ('製成品','商品','半成品','原料','物料')  and azf02='G' 
   IF g_cnt > 0 THEN 
      LET l_where1 = "azf03 in ('製成品','商品')        "   #成品
      LET l_where2 = "azf03 = '半成品'                  "   #半品
      LET l_where3 = "azf03 in ('原料','物料')          "   #原物料
   END IF 
   
   LET g_cnt = 0
   SELECT count(distinct(azf06)) into g_cnt from azf_file,ima_file  where ima12 = azf01  and azf06 in ('0','1','2','3')  and azf02='G' 
   IF g_cnt > 0 THEN 
      LET l_where1 = "azf06 IN ('0','1') "   #成品
      LET l_where2 = "azf06 = '2'        "   #半品
      LET l_where3 = "azf06 = '3'        "   #原物料
   END IF    
   
 #  CALL r001_e01() display "1"   #210506 新增
 #     UNLOAD TO "r001_e01.txt" select * from data_tmp where data like 'E%'  order by data,data01
 #  CALL r001_e02() display "2"  #sql
 #     UNLOAD TO "r001_e02.txt" select * from data_tmp where data like 'E%'  order by data,data01
 #  CALL r001_e03() display "3"  #周準時完工率
 #     UNLOAD TO "r001_e03.txt" select * from data_tmp where data like 'E%'  order by data,data01
 #  CALL r001_e04() display "4"  #製程站當天使用料號數
 #     UNLOAD TO "r001_e04.txt" select * from data_tmp2 where data like 'E%'  order by data,data01
   CALL r001_e05() display "5"   #機台完工時間到下一站開工時間落差 BY 機台編號
      UNLOAD TO "r001_e05.txt" select * from data_tmp2 where data like 'E%'  order by data,data01
display "r001_e03.txt r001_e05.txt ok!!"
	  
END MAIN

FUNCTION r001_e01()
DEFINE l_data       VARCHAR(20)
DEFINE l_sql        STRING 

 INSERT INTO data_tmp (data,data01) VALUES('E06','頁簽E06')
 INSERT INTO data_tmp (data,data01) VALUES('E07','頁簽E07')
 INSERT INTO data_tmp (data,data01) VALUES('E08','頁簽E08')
 INSERT INTO data_tmp (data,data01) VALUES('E20','D13')
 INSERT INTO data_tmp (data,data01) VALUES('E21','A43')
 INSERT INTO data_tmp (data,data01) VALUES('E22','A40')
 INSERT INTO data_tmp (data,data01) VALUES('E23','A29')
 INSERT INTO data_tmp (data,data01) VALUES('E24','I18')
 INSERT INTO data_tmp (data,data01) VALUES('E25','I02')
 INSERT INTO data_tmp (data,data01) VALUES('E26','I20')
 INSERT INTO data_tmp (data,data01) VALUES('E28','I04')
 INSERT INTO data_tmp (data,data01) VALUES('E31','I17')
 INSERT INTO data_tmp (data,data01) VALUES('E32','I03')
 
      #(半)生產報廢數量比
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
         " select round(avg(sfb12/sfb08),4)*100 AA1                                                         ",
         "    from sfb_file                                                                                 ",
         "   inner join ima_file ON sfb05 = ima01                                                           ",
         "                      and ima12 in (select azf01 from azf_file where  ",l_where2," and azf02='G') ",
         "   where TO_CHAR(sfb81,'YYYYMM')  = '",l_YM CLIPPED,"'                                            ",
         "     and sfb87 = 'Y'                                                                              ",
         "     and sfb02='1'  and  sfb08<>0                                                                              "
   
         PREPARE r001_prep_e27 FROM l_sql                                                
         DECLARE r001_curs_e27 CURSOR FOR r001_prep_e27
         FOREACH r001_curs_e27 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E27',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
	  
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
	 #(半)一般工單超領比率
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
         " Select Round(A_CNT/B_CNT,4)*100                                                      ",
         " FROM                                                                                 ",
         " (select TO_CHAR(sfb81,'YYYYMM') A_YM,count(*) A_CNT                                  ",
         "    from sfb_file,ima_file                                                            ",
         "   where TO_CHAR(sfb81,'YYYYMM')  = '",l_YM CLIPPED,"'                                ",
         "     and sfb87 = 'Y'                                                                  ",
         "     and sfb02='1'                                                                    ",
         "     and sfb05 = ima01                                                                ",
         "     and ima12 in (select azf01 from azf_file where  ",l_where2,"   and azf02='G')    ",
         "     and exists (select distinct(sfb01) from sfp_file,sfe_file,ima_file               ",
         "                where sfp06='2'                                                       ",
         "                and sfp04 = 'Y'                                                       ",
         "                and sfp01 = sfe02                                                     ",
         "                and sfe01 = sfb01                                                     ",
         "                and ima01 = sfe07)                                                    ",
         "  group by TO_CHAR(sfb81,'YYYYMM')),                                                  ",
         " (select TO_CHAR(sfb81,'YYYYMM') B_YM,count(*) B_CNT                                  ",
         "    from sfb_file,ima_file                                                            ",
         "   where TO_CHAR(sfb81,'YYYYMM')  = '",l_YM CLIPPED,"'                                ",
         "     and sfb87 = 'Y'                                                                  ",
         "     and sfb02='1'                                                                    ",
         "     and sfb05 = ima01                                                                ",
         "     and ima12 in (select azf01 from azf_file where  ",l_where2,"   and azf02='G')    ",
         "   group by TO_CHAR(sfb81,'YYYYMM'))                                                  ",
         " WHERE A_YM=B_YM  and B_CNT>0                                                         "
   
         PREPARE r001_prep_e29 FROM l_sql                                                
         DECLARE r001_curs_e29 CURSOR FOR r001_prep_e29
         FOREACH r001_curs_e29 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E29',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
	  
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
	  #(半)實際與標準生產週期差異工單數占比
	  let g_cnt = 0
	  select count(*) into g_cnt from gav_file where gav02 = 'ima601'
	  LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         IF g_cnt > 0 THEN
              LET l_sql =
                  " SELECT ROUND(SUM(CNT)/COUNT(1),4)*100 FROM                                                                ",
                  "   (select (CASE WHEN S_SUM <> 0 THEN 1 ELSE 0 END) CNT                                                    ",
                  "    from                                                                                                   ",
                  "       (select YM,A_sfu02-(A_sfb25+(ima59+nvl(nvl(ima60/nvl(NULLIF(ima601,0),1),0)*sfb08,0)+ima61)) S_SUM  ",
                  "       FROM sfb_file,ima_file,                                                                             ",
                  "       (SELECT TO_CHAR(sfb81,'YYYYMM') YM,sfb01 A_sfb01,MIN(sfu02) A_sfu02,MIN(sfb25) A_sfb25              ",
                  "         FROM sfb_file,sfu_file,sfv_file                                                                   ",
                  "        WHERE sfu01 = sfv01                                                                                ",
                  "          AND sfupost ='Y'                                                                                 ",
                  "          and sfv11 = sfb01                                                                                ",
                  "          and sfb02 ='1'                                                                                   ",
                  "          and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'                                                 ",
                  "         group by TO_CHAR(sfb81,'YYYYMM'),sfb01)                                                           ",
                  "       WHERE sfb05 = ima01                                                                                 ",
                  "         and ima12 in (select azf01 from azf_file where  ",l_where2,"   and azf02='G')                     ",
                  "         and imaacti = 'Y'                                                                                 ",
                  "         and A_sfb01 = sfb01))                                                                             "
         ELSE
              LET l_sql =
                  " SELECT ROUND(SUM(CNT)/COUNT(1),4)*100 FROM                                                                ",
                  "   (select (CASE WHEN S_SUM <> 0 THEN 1 ELSE 0 END) CNT                                                    ",
                  "    from                                                                                                   ",
                  "       (select YM,A_sfu02-(A_sfb25+(ima59+ima60*sfb08+ima61)) S_SUM  ",
                  "       FROM sfb_file,ima_file,                                                                             ",
                  "       (SELECT TO_CHAR(sfb81,'YYYYMM') YM,sfb01 A_sfb01,MIN(sfu02) A_sfu02,MIN(sfb25) A_sfb25              ",
                  "         FROM sfb_file,sfu_file,sfv_file                                                                   ",
                  "        WHERE sfu01 = sfv01                                                                                ",
                  "          AND sfupost ='Y'                                                                                 ",
                  "          and sfv11 = sfb01                                                                                ",
                  "          and sfb02 ='1'                                                                                   ",
                  "          and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'                                                 ",
                  "         group by TO_CHAR(sfb81,'YYYYMM'),sfb01)                                                           ",
                  "       WHERE sfb05 = ima01                                                                                 ",
                  "         and ima12 in (select azf01 from azf_file where  ",l_where2,"   and azf02='G')                     ",
                  "         and imaacti = 'Y'                                                                                 ",
                  "         and A_sfb01 = sfb01))                                                                             "
	     END IF
         PREPARE r001_prep_e30 FROM l_sql                                                
         DECLARE r001_curs_e30 CURSOR FOR r001_prep_e30
         FOREACH r001_curs_e30 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E30',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
	  
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
	 #(成)生產報廢數量比
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
         " select round(avg(sfb12/sfb08),4)*100 AA1                                                         ",
         "    from sfb_file                                                                                 ",
         "   inner join ima_file ON sfb05 = ima01                                                           ",
         "                      and ima12 in (select azf01 from azf_file where ",l_where1," and azf02='G')  ",
         "   where TO_CHAR(sfb81,'YYYYMM')   = '",l_YM CLIPPED,"'                                           ",
         "     and sfb87 = 'Y'                                                                              ",
         "     and sfb02='1'    and  sfb08<>0                                                                                "
	
         PREPARE r001_prep_e33 FROM l_sql                                                
         DECLARE r001_curs_e33 CURSOR FOR r001_prep_e33
         FOREACH r001_curs_e33 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E33',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)

      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
	 #(成)實際與標準生產週期差異工單數占比
	  let g_cnt = 0
	  select count(*) into g_cnt from gav_file where gav02 = 'ima601'
	  LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         IF g_cnt > 0 THEN
            LET l_sql =
                " SELECT ROUND(SUM(CNT)/COUNT(1),4)*100 FROM                                                               ",
                "   (select (CASE WHEN S_SUM <> 0 THEN 1 ELSE 0 END) CNT                                                   ",
                "    from                                                                                                  ",
                "       (select YM,A_sfu02-(A_sfb25+(ima59+nvl(nvl(ima60/nvl(NULLIF(ima601,0),1),0)*sfb08,0)+ima61)) S_SUM ",
                "       FROM sfb_file,ima_file,                                                                            ",
                "       (SELECT TO_CHAR(sfb81,'YYYYMM') YM,sfb01 A_sfb01,MIN(sfu02) A_sfu02,MIN(sfb25) A_sfb25             ",
                "         FROM sfb_file,sfu_file,sfv_file                                                                  ",
                "        WHERE sfu01 = sfv01                                                                               ",
                "          AND sfupost ='Y'                                                                                ",
                "          and sfv11 = sfb01                                                                               ",
                "          and sfb02 ='1'                                                                                  ",
                "          and TO_CHAR(sfb81,'YYYYMM')   = '",l_YM CLIPPED,"'                                              ",
                "         group by TO_CHAR(sfb81,'YYYYMM'),sfb01)                                                          ",
                "       WHERE sfb05 = ima01                                                                                ",
                "         and ima12 in (select azf01 from azf_file where  ",l_where1," and azf02='G')                      ",
                "         and imaacti = 'Y'                                                                                ",
                "         and A_sfb01 = sfb01))                                                                            "
	     ELSE
            LET l_sql =
                " SELECT ROUND(SUM(CNT)/COUNT(1),4)*100 FROM                                                               ",
                "   (select (CASE WHEN S_SUM <> 0 THEN 1 ELSE 0 END) CNT                                                   ",
                "    from                                                                                                  ",
                "       (select YM,A_sfu02-(A_sfb25+(ima59+ima60*sfb08+ima61)) S_SUM ",
                "       FROM sfb_file,ima_file,                                                                            ",
                "       (SELECT TO_CHAR(sfb81,'YYYYMM') YM,sfb01 A_sfb01,MIN(sfu02) A_sfu02,MIN(sfb25) A_sfb25             ",
                "         FROM sfb_file,sfu_file,sfv_file                                                                  ",
                "        WHERE sfu01 = sfv01                                                                               ",
                "          AND sfupost ='Y'                                                                                ",
                "          and sfv11 = sfb01                                                                               ",
                "          and sfb02 ='1'                                                                                  ",
                "          and TO_CHAR(sfb81,'YYYYMM')   = '",l_YM CLIPPED,"'                                              ",
                "         group by TO_CHAR(sfb81,'YYYYMM'),sfb01)                                                          ",
                "       WHERE sfb05 = ima01                                                                                ",
                "         and ima12 in (select azf01 from azf_file where  ",l_where1," and azf02='G')                      ",
                "         and imaacti = 'Y'                                                                                ",
                "         and A_sfb01 = sfb01))                                                                            "
	     END IF
         PREPARE r001_prep_e34 FROM l_sql                                                
         DECLARE r001_curs_e34 CURSOR FOR r001_prep_e34
         FOREACH r001_curs_e34 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E34',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
	  
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01

END FUNCTION


FUNCTION r001_e02()
DEFINE l_data       VARCHAR(20)
DEFINE l_sql        STRING 
   #實際工時平均差
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
                 " SELECT SUM(ABS(B_ccj05-A_SUM))/COUNT(B_ccj01)/60        ",
                 " FROM                                                 ",
                 " (select SUM(A_ccj05)/COUNT(*) A_SUM                  ",
                 " FROM                                                 ",
                 " (select ccj01 A_ccj01,sum(ccj05) A_ccj05             ",
                 " from cci_file,ccj_file                               ",
                 " where cci01 = ccj01                                  ",
                 "   and cci02 = ccj02                                  ",
                 "   and ccifirm = 'Y'                                  ",
                 "   and TO_CHAR(ccj01,'YYYYMM') = '",l_YM CLIPPED,"'   ",
                 " GROUP BY ccj01)),                                    ",
                 " (select ccj01 B_ccj01,sum(ccj05) B_ccj05             ",
                 " from cci_file,ccj_file                               ",
                 " where cci01 = ccj01                                  ",
                 "   and cci02 = ccj02                                  ",
                 "   and ccifirm = 'Y'                                  ",
                 "   and TO_CHAR(ccj01,'YYYYMM') = '",l_YM CLIPPED,"'   ",
                 " GROUP BY ccj01)                                      "
   
         PREPARE r002_prep1 FROM l_sql                                                
         DECLARE r002_curs1 CURSOR FOR r002_prep1
         FOREACH r002_curs1 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E01',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
	 
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
     #總報工人時
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
                 " select sum(ccj05) A_ccj05                             ",
                 " from cci_file,ccj_file                                ",
                 " where cci01 = ccj01                                   ",
                 "   and cci02 = ccj02                                   ",
                 "   and ccifirm = 'Y'                                   ",
                 "   and TO_CHAR(ccj01,'YYYYMM')  = '",l_YM CLIPPED,"'   "
   
         PREPARE r002_prep2_1 FROM l_sql                                                
         DECLARE r002_curs2_1 CURSOR FOR r002_prep2_1
         FOREACH r002_curs2_1 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E02',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
	  
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
     #總報工機時
	 let g_cnt = 0
     select count(*) into g_cnt from gav_file where gav02 = 'ccj051'
	 IF g_cnt > 0 THEN
	  LET l_i = 2  
         FOREACH r001_curs INTO l_YM
            LET l_data = "-" 
            LET l_sql =
                       " select sum(ccj051) A_ccj051                             ",
                       " from cci_file,ccj_file                                ",
                       " where cci01 = ccj01                                   ",
                       "   and cci02 = ccj02                                   ",
                       "   and ccifirm = 'Y'                                   ",
                       "   and TO_CHAR(ccj01,'YYYYMM')  = '",l_YM CLIPPED,"'   "
            PREPARE r002_prep2_2 FROM l_sql                                                
            DECLARE r002_curs2_2 CURSOR FOR r002_prep2_2
            FOREACH r002_curs2_2 INTO l_data
            END FOREACH
            IF l_data IS NULL THEN LET l_data = "-" END IF
            LET sr1[l_i].data  = l_data
            LET l_i = l_i + 1
         END FOREACH
            INSERT INTO data_tmp VALUES('E03',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                        sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                        sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
      ELSE
		 INSERT INTO data_tmp (data,data01) VALUES('E03','無此欄位') 
      END IF	 

      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
	  
     #預估生產人數
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
                 " select round(sum(ccj05)/8,2)                          ",
                 " from cci_file,ccj_file                                ",
                 " where cci01 = ccj01                                   ",
                 "   and cci02 = ccj02                                   ",
                 "   and ccifirm = 'Y'                                   ",
                 "   and TO_CHAR(ccj01,'YYYYMM')  = '",l_YM CLIPPED,"'   "
   
         PREPARE r002_prep2_3 FROM l_sql                                                
         DECLARE r002_curs2_3 CURSOR FOR r002_prep2_3
         FOREACH r002_curs2_3 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E04',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
	  
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
	 #加班費(人工)金額
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
                  " SELECT sum(cmi08)                               ",
                  "   FROM cmi_file                                 ",
                  "  WHERE cmi04 = '1'                              ",
                  "    AND cmi07 LIKE '%加班%'                    ",
                  "    AND (cmi01*100+cmi02)  = '",l_YM CLIPPED,"'  "

         PREPARE r002_prep3 FROM l_sql                                                
         DECLARE r002_curs3 CURSOR FOR r002_prep3
         FOREACH r002_curs3 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E05',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)

      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
     #實際與預計生產週期落差天數(平均)
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
                 " select round(sum(S_SUM)/count(*),2) from             ",
                 " (SELECT MIN(sfu02)-MIN(sfb15) S_SUM                  ",
                 "   FROM sfb_file,sfu_file,sfv_file                    ",
                 "   WHERE sfu01 = sfv01                                ",
                 "   AND sfupost ='Y'                                   ",
                 "   and sfv11 = sfb01                                  ",
                 "   and sfb02 ='1'                                     ",
                 "   and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'   ",
                 "   group by sfb01)                                    "
   
         PREPARE r002_prep7 FROM l_sql                                                
         DECLARE r002_curs7 CURSOR FOR r002_prep7
         FOREACH r002_curs7 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E09',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
	  
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
     #實際與標準生產週期落差天數(平均)
	 let g_cnt = 0
	 select count(*) into g_cnt from gav_file where gav02 = 'ima601'
	 LET l_i = 2 
     FOREACH r001_curs INTO l_YM
        LET l_data = "-"
        IF g_cnt > 0 THEN
           LET l_sql =
           " select round(sum(S_SUM)/count(*),2) from                          ",
           " (select A_sfu02-(A_sfb25+(ima59+nvl(nvl(ima60/nvl(NULLIF(ima601,0),1),0)*sfb08,0)+ima61)) S_SUM  ",
           " FROM sfb_file,ima_file,                                           ",
           " (SELECT sfb01 A_sfb01,MIN(sfu02) A_sfu02,MIN(sfb25) A_sfb25       ",
           "   FROM sfb_file,sfu_file,sfv_file                                 ",
           "   WHERE sfu01 = sfv01                                             ",
           "   AND sfupost ='Y'                                                ",
           "   and sfv11 = sfb01                                               ",
           "   and sfb02 ='1'                                                  ",
           "   and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'                ",
           "   group by sfb01)                                                 ",
           " WHERE sfb05 = ima01                                               ",
           "   and imaacti = 'Y'                                               ",
           "   and A_sfb01 = sfb01)                                            "
        ELSE
           LET l_sql =
           " select round(sum(S_SUM)/count(*),2) from                          ",
           " (select A_sfu02-(A_sfb25+(ima59+ima60*sfb08+ima61)) S_SUM  ",
           " FROM sfb_file,ima_file,                                           ",
           " (SELECT sfb01 A_sfb01,MIN(sfu02) A_sfu02,MIN(sfb25) A_sfb25       ",
           "   FROM sfb_file,sfu_file,sfv_file                                 ",
           "   WHERE sfu01 = sfv01                                             ",
           "   AND sfupost ='Y'                                                ",
           "   and sfv11 = sfb01                                               ",
           "   and sfb02 ='1'                                                  ",
           "   and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'                ",
           "   group by sfb01)                                                 ",
           " WHERE sfb05 = ima01                                               ",
           "   and imaacti = 'Y'                                               ",
           "   and A_sfb01 = sfb01)                                            "
        END IF
       
         PREPARE r002_prep8_2 FROM l_sql                                                
         DECLARE r002_curs8_2 CURSOR FOR r002_prep8_2
         FOREACH r002_curs8_2 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E11',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
	  
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
     #實際與標準生產週期差異工單數占比
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
                  " Select Round(A_CNT/B_CNT,4)*100                            ",
                  " FROM                                                       ",
                  " (select count(*) A_CNT from                                ",
                  "    (SELECT MIN(sfu02)-MIN(sfb15) S_SUM                     ",
                  "    FROM sfb_file,sfu_file,sfv_file                         ",
                  "    WHERE sfu01 = sfv01                                     ",
                  "    AND sfupost ='Y'                                        ",
                  "    and sfv11 = sfb01                                       ",
                  "    and sfb02 ='1'                                          ",
                  "    and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'        ",
                  "    group by sfb01)                                         ",
                  " WHERE S_SUM <> 0),                                         ",
                  " (select count(*) B_CNT from                                ",
                  "    (SELECT MIN(sfu02)-MIN(sfb15) S_SUM                     ",
                  "    FROM sfb_file,sfu_file,sfv_file                         ",
                  "    WHERE sfu01 = sfv01                                     ",
                  "    AND sfupost ='Y'                                        ",
                  "    and sfv11 = sfb01                                       ",
                  "    and sfb02 ='1'                                          ",
                  "    and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'        ",
                  "    group by sfb01))   where B_CNT > 0                      "
   
         PREPARE r002_prep9 FROM l_sql                                                
         DECLARE r002_curs9 CURSOR FOR r002_prep9
         FOREACH r002_curs9 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E12',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data) 
	 
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
	 let g_cnt = 0
	 select count(*) into g_cnt from gav_file where gav02 = 'ima601'
	 LET l_i = 2 
     FOREACH r001_curs INTO l_YM
        LET l_data = "-" 
        IF g_cnt > 0 THEN
           LET l_sql =
               " Select Round(A_CNT/B_CNT,4)*100                                         ",
               " FROM                                                                    ",
               " (select count(*) A_CNT from                                             ",
               "     (select A_sfu02-(A_sfb25+(ima59+nvl(nvl(ima60/nvl(NULLIF(ima601,0),1),0)*sfb08,0)+ima61)) S_SUM    ",
               "     FROM sfb_file,ima_file,                                             ",
               "     (SELECT sfb01 A_sfb01,MIN(sfu02) A_sfu02,MIN(sfb25) A_sfb25         ",
               "       FROM sfb_file,sfu_file,sfv_file                                   ",
               "       WHERE sfu01 = sfv01                                               ",
               "       AND sfupost ='Y'                                                  ",
               "       and sfv11 = sfb01                                                 ",
               "       and sfb02 ='1'                                                    ",
               "       and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'         ",
               "       group by sfb01)                                                   ",
               "     WHERE sfb05 = ima01                                                 ",
               "       and imaacti = 'Y'                                                 ",
               "       and A_sfb01 = sfb01)                                              ",
               " WHERE S_SUM <> 0),                                                      ",
               " (select count(*) B_CNT from                                             ",
               "    (select A_sfu02-(A_sfb25+(ima59+nvl(nvl(ima60/nvl(NULLIF(ima601,0),1),0)*sfb08,0)+ima61)) S_SUM     ",
               "    FROM sfb_file,ima_file,                                              ",
               "    (SELECT sfb01 A_sfb01,MIN(sfu02) A_sfu02,MIN(sfb25) A_sfb25          ",
               "      FROM sfb_file,sfu_file,sfv_file                                    ",
               "      WHERE sfu01 = sfv01                                                ",
               "      AND sfupost ='Y'                                                   ",
               "      and sfv11 = sfb01                                                  ",
               "      and sfb02 ='1'                                                     ",
               "      and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'          ",
               "      group by sfb01)                                                    ",
               "    WHERE sfb05 = ima01                                                  ",
               "      and imaacti = 'Y'                                                  ",
               "      and A_sfb01 = sfb01))   where B_CNT > 0                            "
         ELSE
           LET l_sql =
              " Select Round(A_CNT/B_CNT,4)*100                                         ",
              " FROM                                                                    ",
              " (select count(*) A_CNT from                                             ",
              "     (select A_sfu02-(A_sfb25+(ima59+ima60*sfb08+ima61)) S_SUM    ",
              "     FROM sfb_file,ima_file,                                             ",
              "     (SELECT sfb01 A_sfb01,MIN(sfu02) A_sfu02,MIN(sfb25) A_sfb25         ",
              "       FROM sfb_file,sfu_file,sfv_file                                   ",
              "       WHERE sfu01 = sfv01                                               ",
              "       AND sfupost ='Y'                                                  ",
              "       and sfv11 = sfb01                                                 ",
              "       and sfb02 ='1'                                                    ",
              "       and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'         ",
              "       group by sfb01)                                                   ",
              "     WHERE sfb05 = ima01                                                 ",
              "       and imaacti = 'Y'                                                 ",
              "       and A_sfb01 = sfb01)                                              ",
              " WHERE S_SUM <> 0),                                                      ",
              " (select count(*) B_CNT from                                             ",
              "    (select A_sfu02-(A_sfb25+(ima59+ima60*sfb08+ima61)) S_SUM     ",
              "    FROM sfb_file,ima_file,                                              ",
              "    (SELECT sfb01 A_sfb01,MIN(sfu02) A_sfu02,MIN(sfb25) A_sfb25          ",
              "      FROM sfb_file,sfu_file,sfv_file                                    ",
              "      WHERE sfu01 = sfv01                                                ",
              "      AND sfupost ='Y'                                                   ",
              "      and sfv11 = sfb01                                                  ",
              "      and sfb02 ='1'                                                     ",
              "      and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'          ",
              "      group by sfb01)                                                    ",
              "    WHERE sfb05 = ima01                                                  ",
              "      and imaacti = 'Y'                                                  ",
              "      and A_sfb01 = sfb01))   where B_CNT > 0                            "
         END IF
         PREPARE r002_prep10_2 FROM l_sql                                                
         DECLARE r002_curs10_2 CURSOR FOR r002_prep10_2
         FOREACH r002_curs10_2 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E14',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
									 
	  
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
     #工單如期開工率
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
                 " Select Round(A_CNT/B_CNT,4)*100                                   ",
                 " FROM                                                              ",
                 " (select count(*) A_CNT from                                       ",
                 "    (SELECT MIN(sfb25)-MIN(sfb13) S_SUM                            ",
                 "    FROM sfb_file,sfu_file,sfv_file                                ",
                 "    WHERE sfu01 = sfv01                                            ",
                 "    AND sfupost ='Y'                                               ",
                 "    and sfv11 = sfb01                                              ",
                 "    and sfb02 ='1'                                                 ",
                 "    and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'      ",
                 "    group by sfb01)                                                ",
                 " WHERE S_SUM <=0),                                                 ",
                 " (select count(*) B_CNT from                                       ",
                 "    (SELECT MIN(sfb25)-MIN(sfb13) S_SUM                            ",
                 "    FROM sfb_file,sfu_file,sfv_file                                ",
                 "    WHERE sfu01 = sfv01                                            ",
                 "    AND sfupost ='Y'                                               ",
                 "    and sfv11 = sfb01                                              ",
                 "    and sfb02 ='1'                                                 ",
                 "    and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'      ",
                 "    group by sfb01))   where B_CNT > 0                             "
   
         PREPARE r002_prep11 FROM l_sql                                                
         DECLARE r002_curs11 CURSOR FOR r002_prep11
         FOREACH r002_curs11 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E15',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
									 
	  
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
     #工單如期完工率
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
                 " Select Round(A_CNT/B_CNT,4)*100                                   ",
                 " FROM                                                              ",
                 " (select count(*) A_CNT from                                       ",
                 "    (SELECT MIN(sfu02)-MIN(sfb15) S_SUM                            ",
                 "    FROM sfb_file,sfu_file,sfv_file                                ",
                 "    WHERE sfu01 = sfv01                                            ",
                 "    AND sfupost ='Y'                                               ",
                 "    and sfv11 = sfb01                                              ",
                 "    and sfb02 ='1'                                                 ",
                 "    and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'       ",
                 "    group by sfb01)                                                ",
                 " WHERE S_SUM <=0),                                                 ",
                 " (select count(*) B_CNT from                                       ",
                 "    (SELECT MIN(sfu02)-MIN(sfb15) S_SUM                            ",
                 "    FROM sfb_file,sfu_file,sfv_file                                ",
                 "    WHERE sfu01 = sfv01                                            ",
                 "    AND sfupost ='Y'                                               ",
                 "    and sfv11 = sfb01                                              ",
                 "    and sfb02 ='1'                                                 ",
                 "    and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'      ",
                 "    group by sfb01))    where B_CNT > 0                                                 "
   
         PREPARE r002_prep12 FROM l_sql                                                
         DECLARE r002_curs12 CURSOR FOR r002_prep12
         FOREACH r002_curs12 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E16',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
									 
	  
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
     #排定交貨日與約定交貨日落差天數
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
                 " select round(SUM(oeb16-oeb15)/count(oea01) ,2)      ",
                 "   from oea_file,oeb_file                            ",
                 "  where  oea00 <>'0'                                 ",
                 "   and oea01 = oeb01                                 ",
                 "    and oeaconf = 'Y'                                ",
                 "    and TO_CHAR(oea02,'YYYYMM') = '",l_YM CLIPPED,"'   "
   
         PREPARE r002_prep14 FROM l_sql                                                
         DECLARE r002_curs14 CURSOR FOR r002_prep14
         FOREACH r002_curs14 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E18',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
									 
	  
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
     #排定交貨日與訂單日期落差天數
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
                  " select round(SUM(oeb16-oea02)/count(oea01) ,2)          ",
                  "   from oea_file ,oeb_file                               ",
                  "  where  oea00 <>'0'                                     ",
                  "   and oea01 = oeb01                                     ",
                  "    and oeaconf = 'Y'                                    ",
                  "    and TO_CHAR(oea02,'YYYYMM')  = '",l_YM CLIPPED,"'    "
   
         PREPARE r002_prep15 FROM l_sql                                                
         DECLARE r002_curs15 CURSOR FOR r002_prep15
         FOREACH r002_curs15 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E19',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
									 

      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01

     #(借)總帳會科金額(運模糊查詢)
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
         " SELECT ROUND(SUM(abb07),2)                                                                 ",
         "   FROM abb_file                                                                            ",
         "  INNER JOIN aba_file ON aba00 = abb00 AND  aba01 = abb01 AND abapost = 'Y' AND abb06 = '1' ",
         "  INNER JOIN aag_file ON aba00 = aag00 AND abb03 = aag01 AND aagacti = 'Y'                  ",
         "                     AND aag02 LIKE '%運%'                                                  ",
         "  WHERE TO_CHAR(aba03*100+aba04)  = '",l_YM CLIPPED,"'                                      "
   
         PREPARE r002_prep16 FROM l_sql                                                
         DECLARE r002_curs16 CURSOR FOR r002_prep16
         FOREACH r002_curs16 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E35',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
									 
      
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01

     #(貸)總帳會科金額(運模糊查詢)
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
         " SELECT ROUND(SUM(abb07),2)                                                                 ",
         "   FROM abb_file                                                                            ",
         "  INNER JOIN aba_file ON aba00 = abb00 AND  aba01 = abb01 AND abapost = 'Y' AND abb06 = '2' ",
         "  INNER JOIN aag_file ON aba00 = aag00 AND abb03 = aag01 AND aagacti = 'Y'                  ",
         "                     AND aag02 LIKE '%運%'                                                  ",
         "  WHERE TO_CHAR(aba03*100+aba04)  = '",l_YM CLIPPED,"'                                      "
   
         PREPARE r002_prep17 FROM l_sql                                                
         DECLARE r002_curs17 CURSOR FOR r002_prep17
         FOREACH r002_curs17 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E36',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)
								
      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01	 
	  
END FUNCTION

FUNCTION r001_e03()
DEFINE l_data       VARCHAR(20)
DEFINE l_sql        STRING 
   #實際工時平均差
      LET l_i = 2  
      FOREACH r001_curs INTO l_YM
         LET l_data = "-" 
         LET l_sql = 
               " SELECT ROUND(SUM(CNT)/COUNT(1),4)*100 FROM                                                                 ",
               "   (SELECT TO_CHAR(sfb81,'YYYYMM') YM,(trunc(MIN(sfu02), 'IW') + 6),(trunc(MIN(sfb15), 'IW') + 6)           ",
               "     ,sfb01,(CASE WHEN (trunc(MIN(sfu02), 'IW') + 6) = (trunc(MIN(sfb15), 'IW') + 6) THEN 1 ELSE 0 END) CNT ",
               "      FROM sfb_file,sfu_file,sfv_file                                                                       ",
               "     WHERE sfu01 = sfv01                                                                                    ",
               "       AND sfupost ='Y'                                                                                     ",
               "       and sfv11 = sfb01                                                                                    ",
               "       and sfb02 ='1'                                                                                       ",
               "       and TO_CHAR(sfb81,'YYYYMM') = '",l_YM CLIPPED,"'                                                     ",
               "     group by TO_CHAR(sfb81,'YYYYMM'),sfb01)                                                                "
   
     PREPARE r003_prep1 FROM l_sql                                                
     DECLARE r003_curs1 CURSOR FOR r003_prep1
     FOREACH r003_curs1 INTO l_data
         END FOREACH
         IF l_data IS NULL THEN LET l_data = "-" END IF
         LET sr1[l_i].data  = l_data
         LET l_i = l_i + 1
      END FOREACH
         INSERT INTO data_tmp VALUES('E17',sr1[2].data,sr1[3].data,sr1[4].data,sr1[5].data,
                                     sr1[6].data,sr1[7].data,sr1[8].data,sr1[9].data,sr1[10].data,
                                     sr1[11].data,sr1[12].data,sr1[13].data,sr1[14].data,sr1[15].data,sr1[16].data,sr1[17].data,sr1[18].data,sr1[19].data,sr1[20].data,sr1[21].data,sr1[22].data,sr1[23].data,sr1[24].data,sr1[25].data)

      UNLOAD TO "r001_e001.txt" select * from data_tmp where data like 'E%'  order by data,data01
END FUNCTION

FUNCTION r001_e04()
DEFINE l_data01       VARCHAR(20)
DEFINE l_data02       VARCHAR(20)
DEFINE l_data03       VARCHAR(20)
DEFINE l_sql        STRING 
   #製程站當天使用料號數量平均 BY 工作站
   FOREACH new_r001_curs INTO l_YM
     LET l_data01 = "-"
	 LET l_data02 = "-"
	 LET l_data03 = "-"
	 
     let g_cnt = 0
     select count(*) into g_cnt from gav_file where gav02 = 'shbconf'
     IF g_cnt > 0 THEN 
        LET l_sql =
             " SELECT eca01,eca02,SUM(A_CNT)/COUNT(*)                    ",
             "   FROM eca_file                                           ",
             "  INNER JOIN                                               ",
             "  (select A_shb02,A_shb07,count(*) A_CNT                   ",
             "    from                                                   ",
             "    (select shb02 A_shb02,shb07 A_shb07,shb10              ",
             "       from shb_file                                       ",
             "      where TO_CHAR(shb02,'YYYYMM')   = '",l_YM CLIPPED,"' ",  
             "        and shbconf = 'Y'                                  ",
             "      group by shb02,shb07,shb10)                          ",
             "    group by A_shb02,A_shb07)                              ",
             "   ON A_shb07 = eca01                                      ",
             "  where ecaacti = 'Y'                                      ",
             " GROUP BY eca01,eca02                                      "
     ELSE
        LET l_sql =
             " SELECT eca01,eca02,SUM(A_CNT)/COUNT(*)                    ",
             "   FROM eca_file                                           ",
             "  INNER JOIN                                               ",
             "  (select A_shb02,A_shb07,count(*) A_CNT                   ",
             "    from                                                   ",
             "    (select shb02 A_shb02,shb07 A_shb07,shb10              ",
             "       from shb_file                                       ",
             "      where TO_CHAR(shb02,'YYYYMM')   = '",l_YM CLIPPED,"' ",  
             "        and shbacti = 'Y'                                  ",
             "      group by shb02,shb07,shb10)                          ",
             "    group by A_shb02,A_shb07)                              ",
             "   ON A_shb07 = eca01                                      ",
             "  where ecaacti = 'Y'                                      ",
             " GROUP BY eca01,eca02                                      "
     END IF
   
     PREPARE r004_prep1 FROM l_sql                                                
     DECLARE r004_curs1 CURSOR FOR r004_prep1
     FOREACH r004_curs1 INTO l_data01,l_data02,l_data03
        IF l_data01 IS NULL THEN LET l_data01 = "-" END IF
        IF l_data02 IS NULL THEN LET l_data02 = "-" END IF
        IF l_data03 IS NULL THEN LET l_data03 = "-" END IF
	    CALL r001_ins_tmp2('E06',l_YM,l_data01,l_data02,l_data03)
     END FOREACH


   #製程站當天使用料號數兩次以上佔比 BY 工作站
     LET l_data01 = "-"
	 LET l_data02 = "-" 
	 
     let g_cnt = 0
     select count(*) into g_cnt from gav_file where gav02 = 'shbconf'
     IF g_cnt > 0 THEN 
        LET l_sql =
             " SELECT eca01,eca02,Round(NVL(A_SUM,0)/B_SUM,4)*100                ",
             "  FROM eca_file                                                    ",
             " INNER JOIN                                                        ",
             " (SELECT A_shb07 B_shb07,count(*) B_SUM                            ",
             "    FROM                                                           ",
             "    (select A_shb02,A_shb07,count(*) A_CNT                         ",
             "    from                                                           ",
             "    (select shb02 A_shb02,shb07 A_shb07,shb10                      ",
             "       from shb_file                                               ",
             "      where TO_CHAR(shb02,'YYYYMM') = '",l_YM CLIPPED,"' ",
             "        and shbconf = 'Y'                                          ",
             "      group by shb02,shb07,shb10)                                  ",
             "    group by A_shb02,A_shb07)                                      ",
             "    GROUP BY A_shb07)                                              ",
             "    ON B_shb07 = eca01 and ecaacti = 'Y'                           ",
             " LEFT JOIN                                                         ",
             " (SELECT A_shb07,count(*) A_SUM                                    ",
             "    FROM                                                           ",
             "    (select A_shb02,A_shb07,count(*) A_CNT                         ",
             "    from                                                           ",
             "    (select shb02 A_shb02,shb07 A_shb07,shb10                      ",
             "       from shb_file                                               ",
             "      where TO_CHAR(shb02,'YYYYMM')  = '",l_YM CLIPPED,"' ",
             "        and shbconf = 'Y'                                          ",
             "      group by shb02,shb07,shb10)                                  ",
             "    group by A_shb02,A_shb07)                                      ",
             "    WHERE A_CNT>=2                                                 ",
             " GROUP BY A_shb07)                                                 ",
             "   ON A_shb07 = B_shb07                                           ",
             " ORDER BY eca01,eca02                                              "
     ELSE
        LET l_sql =
              " SELECT eca01,eca02,Round(NVL(A_SUM,0)/B_SUM,4)*100                ",
              "  FROM eca_file                                                    ",
              " INNER JOIN                                                        ",
              " (SELECT A_shb07 B_shb07,count(*) B_SUM                            ",
              "    FROM                                                           ",
              "    (select A_shb02,A_shb07,count(*) A_CNT                         ",
              "    from                                                           ",
              "    (select shb02 A_shb02,shb07 A_shb07,shb10                      ",
              "       from shb_file                                               ",
              "      where TO_CHAR(shb02,'YYYYMM') = '",l_YM CLIPPED,"' ",
              "        and shbacti = 'Y'                                          ",
              "      group by shb02,shb07,shb10)                                  ",
              "    group by A_shb02,A_shb07)                                      ",
              "    GROUP BY A_shb07)                                              ",
              "    ON B_shb07 = eca01 and ecaacti = 'Y'                           ",
              " LEFT JOIN                                                         ",
              " (SELECT A_shb07,count(*) A_SUM                                    ",
              "    FROM                                                           ",
              "    (select A_shb02,A_shb07,count(*) A_CNT                         ",
              "    from                                                           ",
              "    (select shb02 A_shb02,shb07 A_shb07,shb10                      ",
              "       from shb_file                                               ",
              "      where TO_CHAR(shb02,'YYYYMM')  = '",l_YM CLIPPED,"' ",
              "        and shbacti = 'Y'                                          ",
              "      group by shb02,shb07,shb10)                                  ",
              "    group by A_shb02,A_shb07)                                      ",
              "    WHERE A_CNT>=2                                                 ",
              " GROUP BY A_shb07)                                                 ",
              "   ON A_shb07 = B_shb07                                           ",
              " ORDER BY eca01,eca02                                              "
	END IF
					
     PREPARE r005_prep1 FROM l_sql                                                
     DECLARE r005_curs1 CURSOR FOR r005_prep1
     FOREACH r005_curs1 INTO l_data01,l_data02,l_data03
        IF l_data01 IS NULL THEN LET l_data01 = "-" END IF
        IF l_data02 IS NULL THEN LET l_data02 = "-" END IF
        IF l_data03 IS NULL THEN LET l_data03 = "-" END IF
	    CALL r001_ins_tmp2('E07',l_YM,l_data01,l_data02,l_data03) 
     END FOREACH
	  
   END FOREACH
	  
END FUNCTION
	  
FUNCTION r001_e05()
   DEFINE l_sql             STRING 
   DEFINE l_day             VARCHAR(20)
   DEFINE l_CrossDay_str    LIKE type_file.num20 
   DEFINE l_CrossDay_end    LIKE type_file.num20 
   DEFINE l_Today_str       VARCHAR(20)
   DEFINE l_Today_end       VARCHAR(20)
   DEFINE l_shb09           LIKE shb_file.shb09
   DEFINE l_alltime         LIKE type_file.num20   #整體報工時間
   DEFINE l_realtime        LIKE type_file.num20   #實際報工時間
   DEFINE l_time            LIKE type_file.num20
   DEFINE l_cnt             LIKE type_file.num20
   DEFINE l_data03          VARCHAR(20)
   
   FOREACH new_r001_curs INTO l_YM
     #抓取每月工作日	 
     LET l_sql =
                 "  select TO_CHAR(sme01,'YYYYMMDD')              ",                    
                 "    from sme_file                               ",                       
                 "   where TO_CHAR(sme01,'YYYYMM')=  '",l_YM,"'   ",                                                         
                 "   order BY TO_CHAR(sme01,'YYYYMMDD')           "                         
     PREPARE r001_prep1 FROM l_sql                                                
     DECLARE r001_curs1 CURSOR FOR r001_prep1

     #機台編號(shb09) 
     LET l_sql =
                 " select shb09                                                                              ",
                 " from shb_file                                                                             ",
                 " where (shb09 is not null or shb09 <> '')                                                  ",
                 " and (TO_CHAR(shb03,'YYYYMM') = '",l_YM,"' or  TO_CHAR(shb02,'YYYYMM') = '",l_YM,"' )  ",
                 " group by shb09                                                                            "

     PREPARE r001_prep2 FROM l_sql                                                
     DECLARE r001_curs2 CURSOR FOR r001_prep2

    
     LET l_shb09 = "" 
     FOREACH r001_curs2 INTO l_shb09   #機台編號
	 LET l_day   = "" 
	 LET l_time = 0
        FOREACH r001_curs1 INTO l_day  #抓每日
           let g_cnt = 0
           select count(*) into g_cnt from gav_file where gav02 = 'shbconf'
           IF g_cnt > 0 THEN 
              LET l_CrossDay_str = 0
                 select sum((shb031[1,2])*60+shb031[4,5]) INTO l_CrossDay_str  #完工日為當天，完工日期>起始日期，抓是否有跨日製作狀況-頭
                   from shb_file                              
                  where shbconf ='Y'                                           		
                    and TO_CHAR(shb03,'YYYYMMDD') = l_day   			 
                    and TO_CHAR(shb03,'YYYYMMDD') > TO_CHAR(shb02,'YYYYMMDD') 	
                    and shb09 = l_shb09	
              
              
              LET l_CrossDay_end = 0
                 select sum((24-shb021[1,2])*60+0-shb021[4,5]) INTO l_CrossDay_end  #起始日為當天，完工日期>起始日期，抓是否有跨日製作狀況-尾
                   from shb_file                             
                  where shbconf ='Y'                                           		  
                    and TO_CHAR(shb02,'YYYYMMDD') = l_day                         		  
                    and TO_CHAR(shb03,'YYYYMMDD') > TO_CHAR(shb02,'YYYYMMDD') 	
                    and shb09 = l_shb09					 
              
              LET l_Today_str = ""
              LET l_Today_end = ""
                  select min(shb021),max(shb031)  INTO  l_Today_str,l_Today_end  #完工日期=起始日期
                  from shb_file                                                  		   
                  where shbconf ='Y'                                                      
                    and  TO_CHAR(shb02,'YYYYMMDD') = l_day                           		   
                    and  TO_CHAR(shb03,'YYYYMMDD') = TO_CHAR(shb02,'YYYYMMDD')   	
                    and shb09 = l_shb09				 
           ELSE 
              LET l_CrossDay_str = 0
                 select sum((shb031[1,2])*60+shb031[4,5]) INTO l_CrossDay_str  #完工日為當天，完工日期>起始日期，抓是否有跨日製作狀況-頭
                   from shb_file                              
                  where shbacti ='Y'                                           		
                    and TO_CHAR(shb03,'YYYYMMDD') = l_day   			 
                    and TO_CHAR(shb03,'YYYYMMDD') > TO_CHAR(shb02,'YYYYMMDD') 	
                    and shb09 = l_shb09	
              
              
              LET l_CrossDay_end = 0
                 select sum((24-shb021[1,2])*60+0-shb021[4,5]) INTO l_CrossDay_end  #起始日為當天，完工日期>起始日期，抓是否有跨日製作狀況-尾
                   from shb_file                             
                  where shbacti ='Y'                                           		  
                    and TO_CHAR(shb02,'YYYYMMDD') = l_day                         		  
                    and TO_CHAR(shb03,'YYYYMMDD') > TO_CHAR(shb02,'YYYYMMDD') 	
                    and shb09 = l_shb09					 
              
              LET l_Today_str = ""
              LET l_Today_end = ""
                  select min(shb021),max(shb031)  INTO  l_Today_str,l_Today_end  #完工日期=起始日期
                  from shb_file                                                  		   
                  where shbacti ='Y'                                                      
                    and  TO_CHAR(shb02,'YYYYMMDD') = l_day                           		   
                    and  TO_CHAR(shb03,'YYYYMMDD') = TO_CHAR(shb02,'YYYYMMDD')   	
                    and shb09 = l_shb09	  
		   END IF
		   
           IF l_CrossDay_str IS NULL THEN LET l_CrossDay_str = 0 END IF
           IF l_CrossDay_end IS NULL THEN LET l_CrossDay_end = 0 END IF
           #整體報工時間(起始至截止)
           let g_cnt = 0
           select count(*) into g_cnt from gav_file where gav02 = 'shbconf'
           IF g_cnt > 0 THEN 
		      LET l_cnt = 0
              select count(*) into l_cnt from shb_file                              
               where shbconf ='Y'                                           		
                 and TO_CHAR(shb03,'YYYYMMDD') > l_day   			 
                 and TO_CHAR(shb02,'YYYYMMDD') < l_day
                 and shb09 = l_shb09
           ELSE 
		      LET l_cnt = 0
              select count(*) into l_cnt from shb_file                              
               where shbacti ='Y'                                           		
                 and TO_CHAR(shb03,'YYYYMMDD') > l_day   			 
                 and TO_CHAR(shb02,'YYYYMMDD') < l_day
                 and shb09 = l_shb09
           END IF				 
				 
           IF l_cnt = 0 THEN  #判斷是否有跨多天期狀況
              CASE 
                 WHEN  l_CrossDay_str = 0 and l_CrossDay_end = 0  #無跨日
                    LET l_alltime = (l_Today_end[1,2]-l_Today_str[1,2])*60+l_Today_end[4,5]-l_Today_str[4,5]
                 WHEN  l_CrossDay_str = 0 and l_CrossDay_end > 0  #今天跨明天
                    LET l_alltime = (24-l_Today_str[1,2])*60+0-l_Today_str[4,5]
                 WHEN  l_CrossDay_str > 0 and l_CrossDay_end = 0  #前天跨今天
                    LET l_alltime = (l_Today_end[1,2])*60+l_Today_end[4,5]
                 WHEN  l_CrossDay_str > 0 and l_CrossDay_end > 0  #今天跨明天&前天跨今天
                    LET l_alltime = 1440                          #直接給予24小時 24*60=1440
              	 OTHERWISE
              END CASE
              IF l_alltime IS NULL THEN LET l_alltime = 0 END IF
           ELSE
              LET l_alltime = 1440
           END IF
			  
			  
           #實際報工時間(投入機時加總) 
           let g_cnt = 0
           select count(*) into g_cnt from gav_file where gav02 = 'shbconf'
           IF g_cnt > 0 THEN 
		      let g_cnt = 0
			  select count(*) into g_cnt from gav_file where gav02 = 'shb033'
              IF g_cnt > 0 THEN
                 select sum(shb033) INTO l_realtime    #投入機時加總
                 from shb_file                                                  		   
                 where shbconf ='Y'                                                      
                   and  TO_CHAR(shb02,'YYYYMMDD') = l_day                           		   
                   and  TO_CHAR(shb03,'YYYYMMDD') = TO_CHAR(shb02,'YYYYMMDD')   	
                   and shb09 = l_shb09	
              ELSE
                 select sum(shb032) INTO l_realtime    #投入機時加總
                 from shb_file                                                  		   
                 where shbconf ='Y'                                                      
                   and  TO_CHAR(shb02,'YYYYMMDD') = l_day                           		   
                   and  TO_CHAR(shb03,'YYYYMMDD') = TO_CHAR(shb02,'YYYYMMDD')   	
                   and shb09 = l_shb09	
              END IF
		   ELSE
		      let g_cnt = 0
			  select count(*) into g_cnt from gav_file where gav02 = 'shb033'
              IF g_cnt > 0 THEN
                 select sum(shb033) INTO l_realtime    #投入機時加總
                 from shb_file                                                  		   
                 where shbacti ='Y'                                                      
                   and  TO_CHAR(shb02,'YYYYMMDD') = l_day                           		   
                   and  TO_CHAR(shb03,'YYYYMMDD') = TO_CHAR(shb02,'YYYYMMDD')   	
                   and shb09 = l_shb09	
              ELSE
                 select sum(shb032) INTO l_realtime    #投入機時加總
                 from shb_file                                                  		   
                 where shbacti ='Y'                                                      
                   and  TO_CHAR(shb02,'YYYYMMDD') = l_day                           		   
                   and  TO_CHAR(shb03,'YYYYMMDD') = TO_CHAR(shb02,'YYYYMMDD')   	
                   and shb09 = l_shb09	
              END IF
           END IF
				
           IF l_realtime IS NULL THEN LET l_realtime = 0 END IF
		   
           IF l_cnt = 0 THEN
              LET l_realtime = l_realtime + l_CrossDay_str + l_CrossDay_end 
           ELSE
             LET l_realtime = l_realtime + l_CrossDay_str + l_CrossDay_end + (1440*l_cnt)
           END IF
		   
           IF l_alltime = 0 THEN LET l_alltime = l_realtime END IF   #如果整體報工時間為零 ，則至少要有實際報工時間才對
           IF l_alltime > 1440 THEN  LET l_alltime = 1440 END IF     #避免有超過整天狀況
           LET l_time = l_time + l_alltime - l_realtime
           #display l_day," ",l_alltime," ",l_realtime  #測試用
        END FOREACH
        #display l_YM," ",l_shb09," ",l_time  #測試用
	    LET l_data03 = "-"
        select eca02 into l_data03
          from eca_file
         where ecaacti = 'Y'
           and eca01 = l_shb09
		
	    CALL r001_ins_tmp2('E08',l_YM,l_shb09,l_data03,l_time)
     END FOREACH
	 
	 display "----------------------------" 
   END FOREACH

END FUNCTION
	  

FUNCTION r001_ins_tmp2(l_item01,l_ym01,l_data01,l_data02,l_data03)
DEFINE l_item01     VARCHAR(20)
DEFINE l_ym01       VARCHAR(20)
DEFINE l_data01     VARCHAR(20)
DEFINE l_data02     VARCHAR(20)
DEFINE l_data03     VARCHAR(20)

      INSERT INTO data_tmp2 VALUES(l_item01,l_ym01,l_data01,l_data02,l_data03)	
END FUNCTION
