# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Program name...: s_abmi600_carry.4gl
# Descriptions...: BOM資料整批拋轉
# Date & Author..: 08/03/10 By Sunyanchun FUN-820031 FUN-7C0010
# Usage..........: CALL s_abmi600_carry(p_bma,p_azp,p_gev04)
# Input PARAMETER: p_bma
#                  p_azp
#                  p_gev04
# Modify.........: FUN-830090 08/03/24 By Carrier add upload logical
# Modify.........: NO.FUN-840033 08/04/17 BY Yiting  拋轉成功才發郵件通知
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:FUN-A80036 10/08/11 By Carrier 资料抛转时,使用的中间表变成动态表名
# Modify.........: No.TQC-AC0162 10/11/17 By vealxu 資料拋轉"成功後，沒有任何提示 
# Modify.........: No.FUN-B10013 11/01/21 By lixh1  將abmi600的拋轉功能獨立成一個函數s_abmi600_comcarry()寫到s_abmi600_carry.4gl
# Modify.........: No:FUN-AC0026 11/07/05 By Mandy PLM GP5.1追版至GP5.25-----str-----
# Modify.........: No:FUN-AC0026 10/12/13 By Mandy PLM-資料中心功能
# Modify.........: No:FUN-B20003 11/02/17 By Mandy PLM-BUG
# Modify.........: No:FUN-AC0026 11/07/05 By Mandy PLM GP5.1追版至GP5.25-----end-----
# Modify.........: No:FUN-B70076 11/07/21 By Mandy PLM-資料中心拋轉異常
# Modify.........: No:FUN-C40011 12/05/15 By bart aimi150自動產生時不要跳出詢問式窗
# Modify.........: No:FUN-D40122 13/06/28 By zhuhao g_prog='abmi600' 时，错误信息在abmi600.4gl中集中显示。
# Modify.........: No:MOD-E10161 14/01/24 By Alberti 新增 拋轉時多拋轉連產品(bmm_file)
# Modify.........: No:MOD-E80134 14/08/25 By Mandy   新增 拋轉時多拋轉服飾業單身TABLE(bmba_file,bmbb_file,bmbc_file,bmbd_file)
# Modify.........: No:MOD-FB0043 15/11/10 By catmoon 拋轉時 未考慮取替代會共用，導致重複新增而拋轉失敗的情形
# Modify.........: No:MOD-G10134 16/01/25 By catmoon 新增 拋轉時多拋轉icm_file的資料
# Modify.........: No:2005054578 20200505 By momo 群組取替代段不需考慮 資料中心 更新否 之需定，一律更新

DATABASE ds
#No.FUN-820031----BEGIN
 
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../tiptop/aim/4gl/aimi100.global" #FUN-7C0010
GLOBALS "../../../tiptop/sub/4gl/s_data_center.global"   #FUN-B10013
DEFINE g_bma_1    DYNAMIC ARRAY OF RECORD
                  sel      LIKE type_file.chr1,
                  bma01    LIKE bma_file.bma01,
                  bma06    LIKE bma_file.bma06
                  END RECORD
DEFINE g_azp      DYNAMIC ARRAY OF RECORD
                  sel      LIKE type_file.chr1,
                  azp01    LIKE azp_file.azp01,
                  azp02    LIKE azp_file.azp02,
                  azp03    LIKE azp_file.azp03
                  END RECORD
#FUN-B10013 ------------------------Begin---------------------------------------
DEFINE  g_bmax        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                      sel         LIKE type_file.chr1,
                      bma01       LIKE bma_file.bma01,
                      bma06       LIKE bma_file.bma06
                      END RECORD                  
DEFINE  p_flag        LIKE type_file.num10
#FUN-B10013 ------------------------End-----------------------------------------                      
DEFINE g_gev04    LIKE gev_file.gev04
DEFINE g_msg1     LIKE type_file.chr1000
DEFINE g_msg2     LIKE type_file.chr1000
DEFINE g_msg3     LIKE type_file.chr1000
DEFINE g_msg4     LIKE type_file.chr1000
DEFINE g_msg_x    LIKE type_file.chr1000
DEFINE g_err      LIKE type_file.chr1000
DEFINE g_bmc      RECORD LIKE bmc_file.*
DEFINE g_bmb      RECORD LIKE bmb_file.*
DEFINE g_bma      RECORD LIKE bma_file.*
DEFINE g_bmd      RECORD LIKE bmd_file.*
DEFINE g_bmm      RECORD LIKE bmm_file.*  #MOD-E10161 add
DEFINE g_bmba     RECORD LIKE bmba_file.* #140525 add
DEFINE g_bmbb     RECORD LIKE bmbb_file.* #140525 add
DEFINE g_bmbc     RECORD LIKE bmbc_file.* #140525 add
DEFINE g_bmbd     RECORD LIKE bmbd_file.* #140525 add
DEFINE g_icm      RECORD LIKE icm_file.*  #MOD-G10134 add
DEFINE g_bmt      RECORD LIKE bmt_file.*
DEFINE g_bml      RECORD LIKE bml_file.*
DEFINE g_bob      RECORD LIKE bob_file.*
DEFINE g_boa      RECORD LIKE boa_file.*
DEFINE g_dbs_sep  LIKE type_file.chr50
DEFINE g_all_cnt  LIKE type_file.num10    #總共要拋轉的筆數
DEFINE g_cur_cnt  LIKE type_file.num10    #當前營運中心滿足拋轉條件的筆數
DEFINE g_flagx    LIKE type_file.chr1     #No.FUN-830090
DEFINE g_plant_sep LIKE azp_file.azp01    #FUN-A50102

#FUN-D40122 ------ add ---------- begin --------------
DEFINE g_sql      STRING
DEFINE g_db_type  LIKE type_file.chr3
DEFINE g_gew01    LIKE gew_file.gew01
DEFINE g_gew02    LIKE gew_file.gew02
DEFINE g_cnt      LIKE type_file.num10
DEFINE i          LIKE type_file.num10
#FUN-D40122 ------ add ---------- end ----------------

#FUN-B10013 -----------------------------Begin-----------------------------------
FUNCTION s_abmi600_com_carry(p_bma01,p_bma06,p_bma10,p_plant,p_flag)
   DEFINE p_bma01       LIKE bma_file.bma01
   DEFINE p_bma06       LIKE bma_file.bma06
   DEFINE p_bma10       LIKE bma_file.bma10   
   DEFINE p_plant       LIKE azp_file.azp01
   DEFINE l_i           LIKE type_file.num10
   DEFINE l_j           LIKE type_file.num10
  #DEFINE l_sql         LIKE type_file.chr1000 #20190925
   DEFINE l_sql         STRING                 #20190525
   DEFINE l_gew03       LIKE gew_file.gew03 
   DEFINE l_gev04       LIKE gev_file.gev04    
   DEFINE p_flag        LIKE type_file.num5

   IF cl_null(p_bma01) THEN   
      IF g_prog = 'abmi600' THEN                                     #FUN-D40122 add
         LET g_showmsg = g_plant,":",p_bma01                         #FUN-D40122 add
         CALL s_errmsg('azp01,bma01',g_showmsg,'bma10','-400',1)     #FUN-D40122 add
      ELSE                                                           #FUN-D40122 add
         CALL cl_err('',-400,0)
      END IF                                                         #FUN-D40122 add
      RETURN 
   END IF
   IF p_bma10 <> '2' THEN
      IF g_prog = 'abmi600' THEN                                     #FUN-D40122 add
         LET g_showmsg = g_plant,":",p_bma01                         #FUN-D40122 add
         CALL s_errmsg('azp01,bma01',g_showmsg,'bma10','aoo-091',1)  #FUN-D40122 add
      ELSE                                                           #FUN-D40122 add
         CALL cl_err(p_bma01,'aoo-091',1) 
      END IF                                                         #FUN-D40122 add
      RETURN
   END IF
  
   LET l_gev04 = NULL                                                           
                                                                                
   #是否為資料中心的拋轉DB                                                      
   SELECT gev04 INTO l_gev04 FROM gev_file                                      
    WHERE gev01 = '2' AND gev02 = p_plant                                       
      AND gev03 = 'Y'                                                           
   IF SQLCA.sqlcode THEN                                                        
      IF g_prog = 'abmi600' THEN                                     #FUN-D40122 add
         CALL s_errmsg('p_plant',l_gev04,'','aoo-036',1)             #FUN-D40122 add
      ELSE                                                           #FUN-D40122 add
         CALL cl_err(l_gev04,'aoo-036',1)                                          
      END IF                                                         #FUN-D40122 add
      RETURN                                                                    
   END IF
 
   IF cl_null(l_gev04) THEN RETURN END IF
   
   SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file                               
    WHERE gew01 = l_gev04 AND gew02 = '2'                                       
   IF NOT cl_null(l_gew03) THEN                                                 
      IF l_gew03 = '2' THEN 
         IF g_prog <> 'aimi150' AND g_prog <> 'abmi600' THEN    #FUN-C40011---begin #FUN-D40122 add g_prog <> 'abmi600'
            IF NOT cl_confirm('anm-929') THEN     #詢問是否執行拋轉
               RETURN 
            END IF 
         END IF      #FUN-C40011---end
      END IF
      IF p_flag THEN     #FUN-B10013
      #開窗選擇拋轉的db清單
         LET l_sql = "SELECT COUNT(*) FROM &bma_file WHERE bma01='",p_bma01,"'",
                                                    "  AND bma06='",p_bma06,"'"
        #CALL s_dc_sel_db1(l_gev04,'2',l_sql)                   #FUN-D40122 mark
         IF g_azp1.getLength() = 0 THEN                        #FUN-D40122 如果g_azp1数组存在值时，不用再次选择调用db
            CALL s_abmi600_sel_db1(l_gev04,'2',l_sql)           #FUN-D40122 add
            IF INT_FLAG THEN
               LET INT_FLAG=0
               CALL g_azp1.clear()                              #FUN-D40122 add
               RETURN
            END IF
         END IF                                                 #FUN-D40122 add
      END IF              #FUN-B10013
      CALL g_bmax.clear()
     
      LET g_bmax[1].sel = 'Y'
      LET g_bmax[1].bma01 = p_bma01
      LET g_bmax[1].bma06 = p_bma06
      FOR l_i = 1 TO g_azp1.getLength()
          LET g_azp[l_i].sel   = g_azp1[l_i].sel
          LET g_azp[l_i].azp01 = g_azp1[l_i].azp01
          LET g_azp[l_i].azp02 = g_azp1[l_i].azp02
          LET g_azp[l_i].azp03 = g_azp1[l_i].azp03
      END FOR
    
#FUN-D40122 ---------- add -------------- begin ------------
      IF g_prog = 'abmi600' THEN   
         CALL s_abmi600_carry(g_bmax,g_azp,l_gev04,'0')
      ELSE
#FUN-D40122 ---------- add -------------- end --------------
         CALL s_showmsg_init()
         CALL s_abmi600_carry(g_bmax,g_azp,l_gev04,'0')  
         CALL s_showmsg()
      END IF                #FUN-D40122 add
   END IF            
  
END FUNCTION
#FUN-B10013 -----------------------------End-------------------------------------
 
FUNCTION s_abmi600_carry(p_bma,p_azp,p_gev04,p_flagx)  #No.FUN-830090     
  DEFINE p_bma                DYNAMIC ARRAY OF RECORD
                              sel      LIKE type_file.chr1,
                              bma01    LIKE bma_file.bma01,
                              bma06    LIKE bma_file.bma06
                              END RECORD
  DEFINE p_azp                DYNAMIC ARRAY OF RECORD
                              sel      LIKE type_file.chr1,
                              azp01    LIKE azp_file.azp01,
                              azp02    LIKE azp_file.azp02,
                              azp03    LIKE azp_file.azp03
                              END RECORD
  DEFINE p_gev04              LIKE gev_file.gev04
  DEFINE p_flagx              LIKE type_file.chr1    #No.FUN-830090
  DEFINE l_i                  LIKE type_file.num10
  DEFINE l_j                  LIKE type_file.num10
  DEFINE l_str1               STRING
  DEFINE l_str2               STRING
  DEFINE l_str3               STRING
  DEFINE l_str4               STRING
  DEFINE l_str1_bmc           STRING
  DEFINE l_str2_bmc           STRING
  DEFINE l_str3_bmc           STRING
  DEFINE l_str4_bmc           STRING
  DEFINE l_str1_bmb           STRING
  DEFINE l_str2_bmb           STRING
  DEFINE l_str3_bmb           STRING
  DEFINE l_str4_bmb           STRING
  DEFINE l_str1_bmd           STRING
  DEFINE l_str2_bmd           STRING
  DEFINE l_str3_bmd           STRING
  DEFINE l_str4_bmd           STRING
  DEFINE l_str1_bmt           STRING
  DEFINE l_str2_bmt           STRING
  DEFINE l_str3_bmt           STRING
  DEFINE l_str4_bmt           STRING
  DEFINE l_str1_bml           STRING
  DEFINE l_str2_bml           STRING
  DEFINE l_str3_bml           STRING
  DEFINE l_str4_bml           STRING
  DEFINE l_str1_boa           STRING
  DEFINE l_str2_boa           STRING
  DEFINE l_str3_boa           STRING
  DEFINE l_str4_boa           STRING
  DEFINE l_str1_bob           STRING
  DEFINE l_str2_bob           STRING
  DEFINE l_str3_bob           STRING
  DEFINE l_str4_bob           STRING
 #MOD-E10161-Start-Add
  DEFINE l_str1_bmm           STRING
  DEFINE l_str2_bmm           STRING
  DEFINE l_str3_bmm           STRING
  DEFINE l_str4_bmm           STRING  
 #MOD-E10161-End-Add
 #MOD-E80134 add---str---
  DEFINE l_str1_bmba          STRING
  DEFINE l_str2_bmba          STRING
  DEFINE l_str3_bmba          STRING
  DEFINE l_str4_bmba          STRING  
  DEFINE l_str1_bmbb          STRING
  DEFINE l_str2_bmbb          STRING
  DEFINE l_str3_bmbb          STRING
  DEFINE l_str4_bmbb          STRING  
  DEFINE l_str1_bmbc          STRING
  DEFINE l_str2_bmbc          STRING
  DEFINE l_str3_bmbc          STRING
  DEFINE l_str4_bmbc          STRING  
  DEFINE l_str1_bmbd          STRING
  DEFINE l_str2_bmbd          STRING
  DEFINE l_str3_bmbd          STRING
  DEFINE l_str4_bmbd          STRING  
 #MOD-E80134 add---end---
 #MOD-G10134 add---str---
  DEFINE l_str1_icm           STRING
  DEFINE l_str2_icm           STRING
  DEFINE l_str3_icm           STRING
  DEFINE l_str4_icm           STRING
 #MOD-G10134 add---end--- 
  DEFINE l_bma01              LIKE bma_file.bma01
  DEFINE l_bma01_old          LIKE bma_file.bma01
  DEFINE l_bma06              LIKE bma_file.bma06
  DEFINE l_bma06_old          LIKE bma_file.bma01
  DEFINE l_dbs_sep            LIKE type_file.chr50
  DEFINE l_gew05              LIKE gew_file.gew05
  DEFINE l_gew07              LIKE gew_file.gew07
  DEFINE l_gez04              LIKE gez_file.gez04
  DEFINE l_gez05              LIKE gez_file.gez05
  DEFINE l_tabname            LIKE type_file.chr50
  DEFINE l_bma                RECORD LIKE bma_file.*
  DEFINE l_gew08              LIKE gew_file.gew08     #for mail
  DEFINE l_hist_tab           LIKE type_file.chr50    #for mail
  DEFINE l_hs_flag            LIKE type_file.chr1     #for mail
  DEFINE l_hs_path            LIKE ze_file.ze03       #for mail
  DEFINE l_bma_upd            LIKE type_file.chr1     #no.FUN-840033 add
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  LET g_flagx = p_flagx     #No.FUN-830090  0.carry  1.upload
 
  #檢查是否有要拋轉的資料
  #No.FUN-830090  --Begin
  IF g_flagx <> '1' THEN
     IF p_bma.getLength() = 0 THEN RETURN END IF
  END IF
  #No.FUN-830090  --End
  
  #檢查是否有拋轉到的資料庫
  IF p_azp.getLength() = 0 THEN RETURN END IF
  CALL g_bma_1.clear()
 
  #前置准備
  FOR l_i = 1 TO p_bma.getLength()
      LET g_bma_1[l_i].* = p_bma[l_i].*
  END FOR
  FOR l_i = 1 TO p_azp.getLength()
      LET g_azp[l_i].* = p_azp[l_i].*
  END FOR
  LET g_gev04 = p_gev04
  LET g_db_type=cl_db_get_database_type()
 
  #定義cursor
  CALL s_carry_p_cs()
  #default aooi602中設置的預設值
  LET g_sql = " SELECT gez04,gez05 FROM gez_file ",
              "  WHERE gez01 = '",g_gev04 CLIPPED,"'",
              "    AND gez02 = '2'",
              "    AND gez03 = ?  "
  PREPARE gez_p FROM g_sql
  DECLARE gez_cur CURSOR WITH HOLD FOR gez_p
 
  #組column
  CALL s_carry_col('bma_file') RETURNING l_str1,l_str2,l_str3
  CALL s_carry_col('bmc_file') RETURNING l_str1_bmc,l_str2_bmc,l_str3_bmc
  CALL s_carry_col('bmb_file') RETURNING l_str1_bmb,l_str2_bmb,l_str3_bmb
  CALL s_carry_col('bmd_file') RETURNING l_str1_bmd,l_str2_bmd,l_str3_bmd
  CALL s_carry_col('bmt_file') RETURNING l_str1_bmt,l_str2_bmt,l_str3_bmt
  CALL s_carry_col('bml_file') RETURNING l_str1_bml,l_str2_bml,l_str3_bml
  CALL s_carry_col('bob_file') RETURNING l_str1_bob,l_str2_bob,l_str3_bob
  CALL s_carry_col('boa_file') RETURNING l_str1_boa,l_str2_boa,l_str3_boa
  CALL s_carry_col('bmm_file') RETURNING l_str1_bmm,l_str2_bmm,l_str3_bmm #MOD-E10161 add
  CALL s_carry_col('bmba_file') RETURNING l_str1_bmba,l_str2_bmba,l_str3_bmba #MOD-E80134 add
  CALL s_carry_col('bmbb_file') RETURNING l_str1_bmbb,l_str2_bmbb,l_str3_bmbb #MOD-E80134 add
  CALL s_carry_col('bmbc_file') RETURNING l_str1_bmbc,l_str2_bmbc,l_str3_bmbc #MOD-E80134 add
  CALL s_carry_col('bmbd_file') RETURNING l_str1_bmbd,l_str2_bmbd,l_str3_bmbd #MOD-E80134 add
  CALL s_carry_col('icm_file') RETURNING l_str1_icm,l_str2_icm,l_str3_icm  #MOD-G10134 add
  #組index
  CALL s_carry_idx('bma_file') RETURNING l_str4
  CALL s_carry_idx('bmc_file') RETURNING l_str4_bmc
  CALL s_carry_idx('bmb_file') RETURNING l_str4_bmb
  CALL s_carry_idx('bmd_file') RETURNING l_str4_bmd
  CALL s_carry_idx('bmt_file') RETURNING l_str4_bmt
  CALL s_carry_idx('bml_file') RETURNING l_str4_bml
  CALL s_carry_idx('bob_file') RETURNING l_str4_bob
  CALL s_carry_idx('boa_file') RETURNING l_str4_boa
  CALL s_carry_idx('bmm_file') RETURNING l_str4_bmm                       #MOD-E10161 add
  CALL s_carry_idx('bmba_file') RETURNING l_str4_bmba                     #MOD-E80134 add
  CALL s_carry_idx('bmbb_file') RETURNING l_str4_bmbb                     #MOD-E80134 add
  CALL s_carry_idx('bmbc_file') RETURNING l_str4_bmbc                     #MOD-E80134 add
  CALL s_carry_idx('bmbd_file') RETURNING l_str4_bmbd                     #MOD-E80134 add
  CALL s_carry_idx('icm_file') RETURNING l_str4_icm                       #MOD-G10134 add
  #建立臨時表,用于存放拋轉的資料
  CALL s_abmi600_carry_p1() RETURNING l_tabname
  #No.FUN-830090  --Begin
  IF g_all_cnt = 0 THEN
     CALL cl_err('','aap-129',1)
     RETURN
  END IF
  #No.FUN-830090  --End  
 
  IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0026 add if判斷
      #建立歷史資料拋轉的臨時表
      CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab
  #FUN-AC0026---add----str---
  ELSE
      LET l_hist_tab = g_dc_hist_tab     
  END IF
  #FUN-AC0026---add----end---
 
  #No.FUN-830090  --Begin    
  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM bmc_file ",
                 "  WHERE bmc01=? AND bmc02=? AND bmc021=? AND bmc03=? AND bmc06 = ?"
  ELSE
     LET g_sql = " SELECT * FROM bmc_file_bak1 ",
                 "  WHERE bmc01=? AND bmc02=? AND bmc021=? AND bmc03=? AND bmc06 = ?"
  END IF
  #No.FUN-830090  --End
  PREPARE bmc_p FROM g_sql
  DECLARE bmc_cur CURSOR WITH HOLD FOR bmc_p
 
  #No.FUN-830090  --Begin    
  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM bmt_file ",
                 "  WHERE bmt01 = ? AND bmt02 = ? ",
                 "    AND bmt03 = ? AND bmt04 = ? AND bmt08 = ? "
  ELSE
     LET g_sql = " SELECT * FROM bmt_file_bak1 ",
                 "  WHERE bmt01 = ? AND bmt02 = ? ",
                 "    AND bmt03 = ? AND bmt04 = ? AND bmt08 = ? "
  END IF
  #No.FUN-830090  --End
  PREPARE bmt_p FROM g_sql
  DECLARE bmt_cur CURSOR WITH HOLD FOR bmt_p
 
  #No.FUN-830090  --Begin    
  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM bml_file ",
                 "  WHERE bml01=? AND bml02=?"
  ELSE
     LET g_sql = " SELECT * FROM bml_file_bak1 ",
                 "  WHERE bml01=? AND bml02=?"
  END IF
  #No.FUN-830090  --End
  PREPARE bml_p FROM g_sql
  DECLARE bml_cur CURSOR WITH HOLD FOR bml_p
 
  #No.FUN-830090  --Begin    
  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM bmd_file",
                 " WHERE bmd08=? AND bmd01=? ",
                 "   AND bmdacti = 'Y'"                                           #CHI-910021
  ELSE
     LET g_sql = " SELECT * FROM bmd_file_bak1",
                 " WHERE bmd08=? AND bmd01=? ",
                 "   AND bmdacti = 'Y'"                                           #CHI-910021
  END IF
  #No.FUN-830090  --End
  PREPARE bmd_p FROM g_sql
  DECLARE bmd_cur CURSOR WITH HOLD FOR bmd_p
  #No.FUN-830090  --Begin    

 #MOD-E10161-Start-Add
  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM bmm_file",
                 " WHERE bmm01=? "
  ELSE
     LET g_sql = " SELECT * FROM bmm_file_bak1",
                 " WHERE bmm01=? "
  END IF
  PREPARE bmm_p FROM g_sql
  DECLARE bmm_cur CURSOR WITH HOLD FOR bmm_p
 #MOD-E10161-End-Add
 #MOD-E80134---add---str---
  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM bmba_file",
                 " WHERE bmba01=? ", #主件
                 "   AND bmba02=? ", #組合項次
                 "   AND bmba03=? ", #元件
                 "   AND bmba04=? ", #生效日期
                 "   AND bmba29=? "  #特性代碼
  ELSE
     LET g_sql = " SELECT * FROM bmba_file_bak1",
                 " WHERE bmba01=? ", #主件
                 "   AND bmba02=? ", #組合項次
                 "   AND bmba03=? ", #元件
                 "   AND bmba04=? ", #生效日期
                 "   AND bmba29=? "  #特性代碼
  END IF
  PREPARE bmba_p FROM g_sql
  DECLARE bmba_cur CURSOR WITH HOLD FOR bmba_p

  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM bmbb_file",
                 " WHERE bmbb01=? ", #主件
                 "   AND bmbb02=? ", #組合項次
                 "   AND bmbb03=? ", #元件
                 "   AND bmbb04=? ", #生效日期
                 "   AND bmbb29=? "  #特性代碼
  ELSE
     LET g_sql = " SELECT * FROM bmbb_file_bak1",
                 " WHERE bmbb01=? ", #主件
                 "   AND bmbb02=? ", #組合項次
                 "   AND bmbb03=? ", #元件
                 "   AND bmbb04=? ", #生效日期
                 "   AND bmbb29=? "  #特性代碼
  END IF
  PREPARE bmbb_p FROM g_sql
  DECLARE bmbb_cur CURSOR WITH HOLD FOR bmbb_p

  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM bmbc_file",
                 " WHERE bmbc01=? ", #主件
                 "   AND bmbc02=? ", #組合項次
                 "   AND bmbc03=? ", #元件
                 "   AND bmbc04=? ", #生效日期
                 "   AND bmbc29=? "  #特性代碼
  ELSE
     LET g_sql = " SELECT * FROM bmbc_file_bak1",
                 " WHERE bmbc01=? ", #主件
                 "   AND bmbc02=? ", #組合項次
                 "   AND bmbc03=? ", #元件
                 "   AND bmbc04=? ", #生效日期
                 "   AND bmbc29=? "  #特性代碼
  END IF
  PREPARE bmbc_p FROM g_sql
  DECLARE bmbc_cur CURSOR WITH HOLD FOR bmbc_p

  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM bmbd_file",
                 " WHERE bmbd01=? ", #主件
                 "   AND bmbd02=? ", #組合項次
                 "   AND bmbd03=? ", #元件
                 "   AND bmbd04=? ", #生效日期
                 "   AND bmbd29=? "  #特性代碼
  ELSE
     LET g_sql = " SELECT * FROM bmbc_file_bak1",
                 " WHERE bmbd01=? ", #主件
                 "   AND bmbd02=? ", #組合項次
                 "   AND bmbd03=? ", #元件
                 "   AND bmbd04=? ", #生效日期
                 "   AND bmbd29=? "  #特性代碼
  END IF
  PREPARE bmbd_p FROM g_sql
  DECLARE bmbd_cur CURSOR WITH HOLD FOR bmbd_p
 #MOD-E80134---add---end---
 #MOD-G10134---add---str---
   IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM icm_file",
                 " WHERE icm02=? ", #主件
                 "   AND icm01=? "  #元件
  ELSE
     LET g_sql = " SELECT * FROM icm_file_bak1",
                 " WHERE icm02=? ", #主件
                 "   AND icm01=? "  #元件
  END IF
  PREPARE icm_p FROM g_sql
  DECLARE icm_cur CURSOR WITH HOLD FOR icm_p
 #MOD-G10134---add---end---
  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM bmb_file WHERE bmb01=? AND bmb29 = ?"
  ELSE
     LET g_sql = " SELECT * FROM bmb_file_bak1 WHERE bmb01=? AND bmb29 = ?"
  END IF
  #No.FUN-830090  --End
  PREPARE bmb_p FROM g_sql
  DECLARE bmb_cur CURSOR WITH HOLD FOR bmb_p
 
  #No.FUN-830090  --Begin    
  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM bob_file ",
                 " WHERE bob01 = ?  AND bob02 = ? "
  ELSE
     LET g_sql = " SELECT * FROM bob_file_bak1 ",
                 " WHERE bob01 = ?  AND bob02 = ? "
  END IF
  #No.FUN-830090  --End
  PREPARE bob_p FROM g_sql
  DECLARE bob_cur CURSOR WITH HOLD FOR bob_p
 
  #No.FUN-830090  --Begin    
  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM boa_file ",
                 " WHERE boa01=? AND boa03=? "
  ELSE
     LET g_sql = " SELECT * FROM boa_file_bak1 ",
                 " WHERE boa01=? AND boa03=? "
  END IF
  #No.FUN-830090  --End
  PREPARE boa_p FROM g_sql
  DECLARE boa_cur CURSOR WITH HOLD FOR boa_p


 
  FOR l_j = 1 TO g_azp.getLength()
      IF cl_null(g_azp[l_j].azp03) THEN CONTINUE FOR END IF
      IF g_azp[l_j].sel = 'N' THEN CONTINUE FOR END IF
 
      SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
       WHERE gew01 = g_gev04
         AND gew02 = '2'
         AND gew04 = g_azp[l_j].azp01
      IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
     #IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0026 add if判斷 #FUN-B70076 mark
          #mail_1                                                              
          CALL s_dc_carry_send_mail_1(g_azp[l_j].azp01,l_j,g_gev04,'2',l_hist_tab)
               RETURNING l_hs_flag,l_hs_path
     #END IF #FUN-AC0026 add #FUN-B70076 mark
 
      CALL s_dbstring(g_azp[l_j].azp03) RETURNING l_dbs_sep
      LET g_dbs_sep = l_dbs_sep
      LET g_plant_sep = g_azp[l_j].azp01   #FUN-A50102 
     #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"bma_file",  #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bma_file'),   #FUN-A50102 
                  " VALUES(",l_str2,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs1 FROM g_sql
     #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"bma_file",  #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bma_file'),  #FUN-A50102 
                  "   SET ",l_str3,
                  " WHERE ",l_str4
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs2 FROM g_sql
 
     #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"bmc_file",  #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmc_file'),   #FUN-A50102
                  " VALUES(",l_str2_bmc,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs1_bmc FROM g_sql
     #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"bmc_file",   #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmc_file'),   #FUN-A50102
                  "   SET ",l_str3_bmc,
                  " WHERE ",l_str4_bmc
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs2_bmc FROM g_sql
 
     #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"bmb_file",   #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmb_file'),  #FUN-A50102
                  " VALUES(",l_str2_bmb,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs1_bmb FROM g_sql
     #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"bmb_file",  #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmb_file'),   #FUN-A50102 
                  "   SET ",l_str3_bmb,
                  " WHERE ",l_str4_bmb
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs2_bmb FROM g_sql

     #MOD-FB0043--add--start-------------------------
      LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_azp[l_j].azp01,'bmd_file'),
                  " WHERE bmd01=? ",
                  "   AND bmd02=? ",
                  "   AND bmd03=? ",
                  "   AND bmd08=? ",
                  "   AND bmdacti = 'Y'"             
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
      PREPARE db_bmd_p FROM g_sql              
     #MOD-FB0043--add--end---------------------------

 
     #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"bmd_file",  #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmd_file'),  #FUN-A50102
                  " VALUES(",l_str2_bmd,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs1_bmd FROM g_sql
     #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"bmd_file",   #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmd_file'),   #FUN-A50102 
                  "   SET ",l_str3_bmd,
                  " WHERE ",l_str4_bmd
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs2_bmd FROM g_sql


     #MOD-E10161-Start-Add
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmm_file'),  
                  " VALUES(",l_str2_bmm,")"
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
      PREPARE db_cs1_bmm FROM g_sql
     
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmm_file'),  
                  "   SET ",l_str3_bmm,
                  " WHERE ",l_str4_bmm
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
      PREPARE db_cs2_bmm FROM g_sql
     #MOD-E10161-End-Add

     #MOD-E80134---add----str---
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmba_file'),  
                  " VALUES(",l_str2_bmba,")"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
      PREPARE db_cs1_bmba FROM g_sql
     
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmba_file'),  
                  "   SET ",l_str3_bmba,
                  " WHERE ",l_str4_bmba
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
      PREPARE db_cs2_bmba FROM g_sql

      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmbb_file'),  
                  " VALUES(",l_str2_bmbb,")"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
      PREPARE db_cs1_bmbb FROM g_sql
     
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmbb_file'),  
                  "   SET ",l_str3_bmbb,
                  " WHERE ",l_str4_bmbb
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
      PREPARE db_cs2_bmbb FROM g_sql

      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmbc_file'),  
                  " VALUES(",l_str2_bmbc,")"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
      PREPARE db_cs1_bmbc FROM g_sql
     
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmbc_file'),  
                  "   SET ",l_str3_bmbc,
                  " WHERE ",l_str4_bmbc
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
      PREPARE db_cs2_bmbc FROM g_sql

      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmbd_file'),  
                  " VALUES(",l_str2_bmbd,")"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
      PREPARE db_cs1_bmbd FROM g_sql
     
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmbd_file'),  
                  "   SET ",l_str3_bmbd,
                  " WHERE ",l_str4_bmbd
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
      PREPARE db_cs2_bmbd FROM g_sql
     #MOD-E80134---add----end---
     #MOD-G10134---add----str---
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'icm_file'),  
                  " VALUES(",l_str2_icm,")"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
      PREPARE db_cs1_icm FROM g_sql
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'icm_file'),  
                  "   SET ",l_str3_icm,
                  " WHERE ",l_str4_icm
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
      PREPARE db_cs2_icm FROM g_sql
     #MOD-G10134---add----end---
     #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"bmt_file",   #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bmt_file'),   #FUN-A50102 
                  " VALUES(",l_str2_bmt,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs1_bmt FROM g_sql
     #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"bmt_file",   #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bmt_file'),   #FUN-A50102 
                  "   SET ",l_str3_bmt,
                  " WHERE ",l_str4_bmt
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs2_bmt FROM g_sql
 
     #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"bml_file",   #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bml_file'),   #FUN-A50102 
                  " VALUES(",l_str2_bml,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs1_bml FROM g_sql
     #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"bml_file",   #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bml_file'),  #FUN-A50102 
                  "   SET ",l_str3_bml,
                  " WHERE ",l_str4_bml
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs2_bml FROM g_sql
 
     #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"boa_file",   #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'boa_file'),   #FUN-A50102
                  " VALUES(",l_str2_boa,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs1_boa FROM g_sql
     #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"boa_file",  #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'boa_file'),   #FUN-A50102
                  "   SET ",l_str3_boa,
                  " WHERE ",l_str4_boa
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs2_boa FROM g_sql
 
     #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"bob_file",  #FUN-A50102
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bob_file'),   #FUN-A50102  
                  " VALUES(",l_str2_bob,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs1_bob FROM g_sql
     #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"bob_file",   #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bob_file'),   #FUN-A50102 
                  "   SET ",l_str3_bob,
                  " WHERE ",l_str4_bob
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs2_bob FROM g_sql
 
      #default aooi602中設置的預設值
      LET l_bma01 = NULL
      #LET l_bma06 = NULL
      FOREACH gez_cur USING g_azp[l_j].azp01 INTO l_gez04,l_gez05
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('gez03',g_azp[l_j].azp01,'foreach',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
         IF l_gez04 = 'bma01'  THEN LET l_bma01  = l_gez05 END IF
      END FOREACH
 
      #定義拋轉的SQL
      LET g_sql = " SELECT * FROM ",l_tabname CLIPPED,
                  "  WHERE ",l_gew05 CLIPPED
      PREPARE carry_p1 FROM g_sql
      DECLARE carry_cur1 CURSOR WITH HOLD FOR carry_p1
 
       #當前營運中心,滿足aooi602拋轉條件的筆數
       LET g_cur_cnt = 0
       LET g_sql = " SELECT COUNT(*) FROM ",l_tabname CLIPPED,                         
                   "  WHERE ",l_gew05 CLIPPED                                   
       PREPARE cnt_p1 FROM g_sql                                              
       EXECUTE cnt_p1 INTO g_cur_cnt
       IF cl_null(g_cur_cnt) THEN LET g_cur_cnt = 0 END IF
       IF g_all_cnt <> g_cur_cnt THEN   #aooi602中有設置,部分資料不滿足拋轉
          LET g_showmsg = g_azp[l_j].azp01,"/",g_all_cnt USING "<<<<&","/",g_cur_cnt USING "<<<<&"
          CALL s_errmsg("azp01,all_cnt,cur_cnt",g_showmsg,"cnt_p1","aoo-049",1)
       END IF
      
      LET l_bma_upd = 'N'     #No.FUN-A80036
      FOREACH carry_cur1 INTO g_bma.*
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('bma01',g_bma.bma01,'foreach',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
         IF g_bma.bma10 <> '2' THEN
            IF l_j = 1 THEN
               LET g_showmsg = g_plant,":",g_bma.bma01
               CALL s_errmsg('azp01,bma01',g_showmsg,'bma10','aoo-091',1)
            END IF
            CONTINUE FOREACH
         END IF
 
         LET g_success = 'Y'
         #LET l_bma_upd = 'N'   #NO.FUN-840033  #No.FUN-A80036
         IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0026 add if 判斷
             BEGIN WORK
         END IF                         #FUN-AC0026 add
 
         LET g_msg1 = 'ins ',g_azp[l_j].azp03 CLIPPED,':',g_bma.bma01 CLIPPED,'+',g_bma.bma06 CLIPPED,':'
         LET g_msg2 = 'upd ',g_azp[l_j].azp03 CLIPPED,':',g_bma.bma01 CLIPPED,'+',g_bma.bma06 CLIPPED,':'
 
         LET l_bma01_old = g_bma.bma01
         LET l_bma06_old = g_bma.bma06
         IF NOT cl_null(l_bma01)  THEN LET g_bma.bma01  = l_bma01  END IF
 
         #check item exist or not ?
         IF NOT s_abmi600_carry_chk_ima(g_bma.bma01,'bma_file') THEN
            LET g_success = 'N'
            #LET l_bma_upd ='N'  #NO.FUN-840033 add  #No.FUN-A80036
         END IF
 
         LET g_bma.bma08 = g_plant
         LET g_bma.bma09 = 1
         #把數據插入到要拋轉的目標資料庫中
         EXECUTE db_cs1 USING g_bma.*
         IF SQLCA.sqlcode = 0 THEN 
            MESSAGE g_msg1 CLIPPED,':OK'
            CALL ui.Interface.refresh()
            #LET l_bma_upd = 'Y'   #NO.FUN-840033 add  #No.FUN-A80036
         ELSE
            #No.FUN-A80036  --Begin
            #IF SQLCA.sqlcode = -239 THEN
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在
            #No.FUN-A80036  --End  
               IF l_gew07 = 'N' THEN
                  MESSAGE g_msg1 CLIPPED,':exist'
                  CALL ui.Interface.refresh()
                 #LET g_success = 'N'         #No.FUN-A80036 #170120 mark
                  #LET l_bma_upd = 'N'         #No.FUN-840033 add  #No.FUN-A80036
               ELSE
                  #LET g_sql = "SELECT bma09 FROM ",l_dbs_sep CLIPPED,"bma_file ",   #FUN-A50102
                  LET g_sql = "SELECT bma09 FROM ",cl_get_target_table(g_azp[l_j].azp01,'bma_file'),    #FUN-A50102
                              " WHERE bma01='",l_bma01_old ,"'",
                              "   AND bma06='",l_bma06_old ,"'"
               	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                  CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
                  PREPARE bma_p1 FROM g_sql
                  EXECUTE bma_p1 INTO g_bma.bma09
                  IF cl_null(g_bma.bma09) THEN LET g_bma.bma09 = 0 END IF
                  LET g_bma.bma09 = g_bma.bma09 + 1    #拋轉次數
 
                  EXECUTE db_cs2 USING g_bma.*,l_bma01_old,l_bma06_old   #更新
                  IF SQLCA.sqlcode = 0 THEN
                     MESSAGE g_msg2 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                     #LET l_bma_upd = 'Y'    #NO.FUN-840033 add  #No.FUN-A80036
                  ELSE
                     LET g_msg_x = g_azp[l_j].azp01,':upd'
                     LET g_showmsg = g_bma.bma01 ,"/", g_bma.bma06
                     CALL s_errmsg('bma01,bma06',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                     MESSAGE g_msg2 CLIPPED,':fail'
                     CALL ui.Interface.refresh()
                     LET g_success = 'N'
                     #LET l_bma_upd = 'N'    #No.FUN-840033 add  #No.FUN-A80036
                  END IF
               END IF
            ELSE
               LET g_msg_x = g_azp[l_j].azp01,':ins'
               LET g_showmsg = g_bma.bma01 ,"/", g_bma.bma06
               CALL s_errmsg('bma01,bma06',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg1 CLIPPED,':fail'
               CALL ui.Interface.refresh()
               LET g_success = 'N'
               #LET l_bma_upd = 'N'   #NO.FUN-840033 add  #No.FUN-A80036
            END IF
         END IF
 
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlerrd[3] > 0 THEN
         IF g_success = 'Y' THEN
         #No.FUN-A80036  --End  
            CALL s_dc_carry_record(g_gev04,g_azp[l_j].azp01,g_prog,g_bma.bma01||'+'||g_bma.bma06,'2')
            CALL s_abmi600_bmb1(l_bma01_old,l_bma01,l_bma06_old,l_bma06,g_azp[l_j].azp01,l_gew07)
         END IF
         IF g_success = 'N' THEN
            #LET l_bma_upd = 'N'   #NO.FUN-840033 add  #No.FUN-A80036
            IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0026 add if 判斷
                ROLLBACK WORK
            END IF                         #FUN-AC0026 add
         ELSE
            LET l_bma_upd = 'Y'   #NO.FUN-840033 add 
            IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0026 add if 判斷
                COMMIT WORK
            END IF                         #FUN-AC0026 add
         END IF
      END FOREACH
      IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0026 add if判斷
          #mail 2          
          IF l_bma_upd = 'Y' THEN  #NO.FUN-840033 add                                                        
              CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
          END IF                   #NO.FUN-840033 add
      END IF #FUN-AC0026 add
  END FOR
 
  IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0026 add if判斷
      CALL s_dc_drop_temp_table(l_tabname)
      CALL s_dc_drop_temp_table(l_hist_tab)
  #FUN-AC0026--add---str--
  ELSE
      CALL s_dc_del_tmp(l_tabname)
      CALL s_dc_del_tmp(l_hist_tab)
  END IF 
  #FUN-AC0026--add---end--
 
 #TQC-AC0162 -----------mod start----------------
 #MESSAGE 'Data Carry Finish!'
  IF l_bma_upd = 'Y' THEN
     CALL cl_err('','aim-162',0)
  END IF 
 #TQC-AC0162 -----------mod end--------------- 
  CALL ui.Interface.refresh()
# CALL s_abmi600_carry_send_mail()
END FUNCTION
 
FUNCTION s_abmi600_bmb1(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_azp01,p_gew07)
   DEFINE p_bma01_old     LIKE bma_file.bma01
   DEFINE p_bma01_new     LIKE bma_file.bma01
   DEFINE p_bma06_old     LIKE bma_file.bma06
   DEFINE p_bma06_new     LIKE bma_file.bma06
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
 
   FOREACH bmb_cur USING p_bma01_old,p_bma06_old INTO g_bmb.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmb01',g_bmb.bmb01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bma01_new) THEN LET g_bmb.bmb01 = p_bma01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02 CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04 CLIPPED,'+',g_bmb.bmb29 CLIPPED,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bmb.bmb01 CLIPPED,'+',g_bmb.bmb02 CLIPPED,'+',g_bmb.bmb03 CLIPPED,'+',g_bmb.bmb04 CLIPPED,'+',g_bmb.bmb29 CLIPPED,':'
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmb.bmb03,'bmb_file') THEN
         LET g_success = 'N'
      END IF
      EXECUTE db_cs1_bmb USING g_bmb.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在 
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
              #LET g_success = 'N'   #No.FUN-A80036 #170120 mark
            ELSE
               EXECUTE db_cs2_bmb USING g_bmb.*,p_bma01_old,g_bmb.bmb02,
                                    g_bmb.bmb03,g_bmb.bmb04,g_bmb.bmb29
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_bmb.bmb01,'/',g_bmb.bmb02,'/',g_bmb.bmb03,'/',g_bmb.bmb04,'/',g_bmb.bmb29
                  CALL s_errmsg('bmb01,bmb02,bmb03,bmb04,bmb29',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmb.bmb01,'/',g_bmb.bmb02,'/',g_bmb.bmb03,'/',g_bmb.bmb04,'/',g_bmb.bmb29
            CALL s_errmsg('bmb01,bmb02,bmb03,bmb04,bmb29',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_bmb.bmb01||'+'||g_bmb.bmb02||'+'||g_bmb.bmb03||'+'||g_bmb.bmb04||'+'||g_bmb.bmb29,'2')
         CALL s_abmi600_bmc(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,p_azp01,p_gew07)
         CALL s_abmi600_bmt(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,p_azp01,p_gew07)
         CALL s_abmi600_bml(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,g_bmb.bmb03,p_azp01,p_gew07)
         IF (g_bmb.bmb04 <= g_today OR cl_null(g_bmb.bmb04)) AND
            (g_bmb.bmb05 >  g_today OR cl_null(g_bmb.bmb05)) THEN
            CALL s_abmi600_bmd(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,g_bmb.bmb03,p_azp01,p_gew07)
            CALL s_abmi600_bmm(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,g_bmb.bmb03,p_azp01,p_gew07)  #MOD-E10161 add
         END IF
         CALL s_abmi600_boa(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,g_bmb.bmb03,p_azp01,p_gew07)
         CALL s_abmi600_bmba(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,p_azp01,p_gew07) #MOD-E80134 add
         CALL s_abmi600_bmbb(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,p_azp01,p_gew07) #MOD-E80134 add
         CALL s_abmi600_bmbc(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,p_azp01,p_gew07) #MOD-E80134 add
         CALL s_abmi600_bmbd(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,p_azp01,p_gew07) #MOD-E80134 add
         CALL s_abmi600_icm(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,p_azp01,p_gew07)  #MOD-G10134 add
      END IF
   END FOREACH
END FUNCTION
#FUNCTION s_abmi600_bmb2(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_azp01,p_gew07)
#   DEFINE p_bma01_old     LIKE bma_file.bma01
#   DEFINE p_bma01_new     LIKE bma_file.bma01
#   DEFINE p_bma06_old     LIKE bma_file.bma06
#   DEFINE p_bma06_new     LIKE bma_file.bma06
#   DEFINE p_azp01         LIKE azp_file.azp01
#   DEFINE p_gew07         LIKE gew_file.gew07
#
#   FOREACH bmb_cur1 USING p_bma01_old,p_bma06_old INTO g_bmb.*
#      IF SQLCA.sqlcode THEN
#         CALL s_errmsg('bmb01',g_bmb.bmb01,'foreach',SQLCA.sqlcode,1)
#         CONTINUE FOREACH
#      END IF
#      IF NOT cl_null(p_bma01_new) THEN LET g_bmb.bmb01 = p_bma01_new END IF
#
#      CALL s_abmi600_bmc(g_bmb.bmb01,p_bma01_new,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,p_azp01,p_gew07)
#      CALL s_abmi600_bmt(g_bmb.bmb01,p_bma01_new,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,p_azp01,p_gew07)
#
#   END FOREACH
#END FUNCTION
#FUNCTION s_abmi600_bmb3(p_bma01_old,p_bma01_new,p_azp01,p_gew07)
#   DEFINE p_bma01_old     LIKE bma_file.bma01
#   DEFINE p_bma01_new     LIKE bma_file.bma01
#   DEFINE p_bma06_old     LIKE bma_file.bma06
#   DEFINE p_bma06_new     LIKE bma_file.bma06
#   DEFINE p_azp01         LIKE azp_file.azp01
#   DEFINE p_gew07         LIKE gew_file.gew07
#
#   FOREACH bmb_cur2 USING p_bma01_old INTO g_bmb.*
#      IF SQLCA.sqlcode THEN
#         CALL s_errmsg('bmb01',g_bmb.bmb01,'foreach',SQLCA.sqlcode,1)
#         CONTINUE FOREACH
#      END IF
#      IF NOT cl_null(p_bma01_new) THEN LET g_bmb.bmb01 = p_bma01_new END IF
#
#      CALL s_abmi600_bmd(g_bmb.bmb01,p_bma01_new,g_bmb.bmb03,p_azp01,p_gew07)
#
#   END FOREACH
#END FUNCTION
 
FUNCTION s_abmi600_bmc(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_bmb02,p_bmb03,p_bmb04,p_azp01,p_gew07)
   DEFINE p_bma01_old     LIKE bma_file.bma01
   DEFINE p_bma01_new     LIKE bma_file.bma01
   DEFINE p_bma06_old     LIKE bma_file.bma06
   DEFINE p_bma06_new     LIKE bma_file.bma06
   DEFINE p_bmb02         LIKE bmb_file.bmb02
   DEFINE p_bmb03         LIKE bmb_file.bmb03
   DEFINE p_bmb04         LIKE bmb_file.bmb04
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
 
   FOREACH bmc_cur USING p_bma01_old,p_bmb02,p_bmb03,p_bmb04,p_bma06_old INTO g_bmc.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmc01',g_bmc.bmc01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bma01_new) THEN LET g_bmc.bmc01 = p_bma01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bmc.bmc01 CLIPPED,'+',g_bmc.bmc02 CLIPPED,
                   '+',g_bmc.bmc03 CLIPPED,'+',g_bmc.bmc04 CLIPPED,'+',g_bmc.bmc06 CLIPPED,'+',g_bmc.bmc021 CLIPPED,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bmc.bmc01 CLIPPED,'+',g_bmc.bmc02 CLIPPED,
                   '+',g_bmc.bmc03 CLIPPED,'+',g_bmc.bmc04 CLIPPED,'+',g_bmc.bmc06 CLIPPED,'+',g_bmc.bmc021 CLIPPED,':'
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmc.bmc021,'bmc_file') THEN
         LET g_success = 'N'
      END IF
      EXECUTE db_cs1_bmc USING g_bmc.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'    #No.FUN-A80036
            ELSE
               EXECUTE db_cs2_bmc USING g_bmc.*,g_bmc.bmc01,g_bmc.bmc02,g_bmc.bmc021,g_bmc.bmc03,g_bmc.bmc04,g_bmc.bmc06  
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_bmc.bmc01,'/',g_bmc.bmc02,'/',g_bmc.bmc03,'/',g_bmc.bmc04,'/',g_bmc.bmc06,'/',g_bmc.bmc021
                  CALL s_errmsg('bmc01,bmc02,bmc03,bmc04,bmc06,bmc021',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmc.bmc01,'/',g_bmc.bmc02,'/',g_bmc.bmc03,'/',g_bmc.bmc04,'/',g_bmc.bmc06,'/',g_bmc.bmc021
            CALL s_errmsg('bmc01,bmc02,bmc03,bmc04,bmc06,bmc021',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,
              g_bmc.bmc01||'+'||g_bmc.bmc02||'+'||g_bmc.bmc03||'+'||g_bmc.bmc04||'+'||g_bmc.bmc06||'+'||g_bmc.bmc021,'2')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_abmi600_bmt(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_bmb02,p_bmb03,p_bmb04,p_azp01,p_gew07)
   DEFINE p_bma01_old     LIKE bma_file.bma01
   DEFINE p_bma01_new     LIKE bma_file.bma01
   DEFINE p_bma06_old     LIKE bma_file.bma06
   DEFINE p_bma06_new     LIKE bma_file.bma06
   DEFINE p_bmb02         LIKE bmb_file.bmb02
   DEFINE p_bmb03         LIKE bmb_file.bmb03
   DEFINE p_bmb04         LIKE bmb_file.bmb04
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
 
   FOREACH bmt_cur USING p_bma01_old,p_bmb02,p_bmb03,p_bmb04,p_bma06_old INTO g_bmt.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmt01',g_bmt.bmt01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bma01_new) THEN LET g_bmt.bmt01 = p_bma01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bmt.bmt01 CLIPPED,'+',g_bmt.bmt02 CLIPPED,
                   '+',g_bmt.bmt03 CLIPPED,'+',g_bmt.bmt04 CLIPPED,'+',g_bmt.bmt05 CLIPPED,'+',g_bmt.bmt08 CLIPPED,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bmt.bmt01 CLIPPED,'+',g_bmt.bmt02 CLIPPED,
                   '+',g_bmt.bmt03 CLIPPED,'+',g_bmt.bmt04 CLIPPED,'+',g_bmt.bmt05 CLIPPED,'+',g_bmt.bmt08 CLIPPED,':'
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmt.bmt03,'bmt_file') THEN
         LET g_success = 'N'
      END IF
      EXECUTE db_cs1_bmt USING g_bmt.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'    #No.FUN-A80036
            ELSE
               EXECUTE db_cs2_bmt USING g_bmt.*,g_bmt.bmt01,g_bmt.bmt02,g_bmt.bmt03,g_bmt.bmt04,g_bmt.bmt05,g_bmt.bmt08
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_bmt.bmt01,'/',g_bmt.bmt02,'/',g_bmt.bmt03,'/',g_bmt.bmt04,'/',g_bmt.bmt05,'/',g_bmt.bmt08
                  CALL s_errmsg('bmt01,bmt02,bmt03,bmt04,bmt05,bmt08',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmt.bmt01,'/',g_bmt.bmt02,'/',g_bmt.bmt03,'/',g_bmt.bmt04,'/',g_bmt.bmt05,'/',g_bmt.bmt08
            CALL s_errmsg('bmt01,bmt02,bmt03,bmt04,bmt05,bmt08',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,
              g_bmt.bmt01||'+'||g_bmt.bmt02||'+'||g_bmt.bmt03||'+'||g_bmt.bmt04||'+'||g_bmt.bmt05||'+'||g_bmt.bmt08,'2')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_abmi600_bml(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_bmb03,p_azp01,p_gew07)
   DEFINE p_bma01_old     LIKE bma_file.bma01
   DEFINE p_bma01_new     LIKE bma_file.bma01
   DEFINE p_bma06_old     LIKE bma_file.bma06
   DEFINE p_bma06_new     LIKE bma_file.bma06
   DEFINE p_bmb03         LIKE bmb_file.bmb03
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
 
   FOREACH bml_cur USING p_bmb03,p_bma01_old INTO g_bml.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bml01',g_bml.bml01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bma01_new) THEN LET g_bml.bml02 = p_bma01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bml.bml01 CLIPPED,'+',g_bml.bml02 CLIPPED,'+',g_bml.bml03 CLIPPED,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bml.bml01 CLIPPED,'+',g_bml.bml02 CLIPPED,'+',g_bml.bml03 CLIPPED,':'
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bml.bml01,'bml_file') THEN
         LET g_success = 'N'
      END IF
      EXECUTE db_cs1_bml USING g_bml.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'      #No.FUN-A80036
            ELSE
               EXECUTE db_cs2_bml USING g_bml.*,g_bml.bml01,g_bml.bml02,g_bml.bml03
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_bml.bml01,'/',g_bml.bml02,'/',g_bml.bml03
                  CALL s_errmsg('bml01,bml02,bml03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bml.bml01,'/',g_bml.bml02,'/',g_bml.bml03
            CALL s_errmsg('bml01,bml02,bml03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN 
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_bml.bml02||'+'||g_bml.bml01||'+'||g_bml.bml03,'2')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_abmi600_bmd(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_bmb03,p_azp01,p_gew07)
   DEFINE p_bma01_old     LIKE bma_file.bma01
   DEFINE p_bma01_new     LIKE bma_file.bma01
   DEFINE p_bma06_old     LIKE bma_file.bma06
   DEFINE p_bma06_new     LIKE bma_file.bma06
   DEFINE p_bmb03         LIKE bmb_file.bmb03
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_cnt           LIKE type_file.num10     #MOD-FB0043 add
   
 
   FOREACH bmd_cur USING p_bma01_old,p_bmb03 INTO g_bmd.*  
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmd01',g_bmd.bmd01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
     #MOD-FB0043--add--start---------------------------------
      EXECUTE db_bmd_p USING g_bmd.bmd01,g_bmd.bmd02,g_bmd.bmd03,g_bmd.bmd08 INTO l_cnt
      IF l_cnt > 0 THEN
         EXIT FOREACH
      END IF
     #MOD-FB0043--add--end-----------------------------------
      
      IF NOT cl_null(p_bma01_new) THEN LET g_bmd.bmd08 = p_bma01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bmd.bmd01 CLIPPED,'+',g_bmd.bmd02 CLIPPED,'+',g_bmd.bmd03 CLIPPED,'+',g_bmd.bmd08 CLIPPED,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bmd.bmd01 CLIPPED,'+',g_bmd.bmd02 CLIPPED,'+',g_bmd.bmd03 CLIPPED,'+',g_bmd.bmd08 CLIPPED,':'
 
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmd.bmd01,'bmd_file') THEN
         LET g_success = 'N'
      END IF
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmd.bmd04,'bmd_file') THEN
         LET g_success = 'N'
      END IF
      EXECUTE db_cs1_bmd USING g_bmd.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'   #No.FUN-A80036
            ELSE
               EXECUTE db_cs2_bmd USING g_bmd.*,g_bmd.bmd01,g_bmd.bmd08,g_bmd.bmd02,g_bmd.bmd03  #UPDATE bmd
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_bmd.bmd01,'/',g_bmd.bmd02,'/',g_bmd.bmd03,'/',g_bmd.bmd08
                  CALL s_errmsg('bmd01,bmd02,bmd03,bmd08',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmd.bmd01,'/',g_bmd.bmd02,'/',g_bmd.bmd03,'/',g_bmd.bmd08
            CALL s_errmsg('bmd01,bmd02,bmd03,bmd08',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_bmd.bmd08||'+'||g_bmd.bmd01||'+'||g_bmd.bmd02||'+'||g_bmd.bmd03,'2')
      END IF
   END FOREACH
END FUNCTION

#MOD-E10161-Start-Add
FUNCTION s_abmi600_bmm(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_bmb03,p_azp01,p_gew07)
   DEFINE p_bma01_old     LIKE bma_file.bma01
   DEFINE p_bma01_new     LIKE bma_file.bma01
   DEFINE p_bma06_old     LIKE bma_file.bma06
   DEFINE p_bma06_new     LIKE bma_file.bma06
   DEFINE p_bmb03         LIKE bmb_file.bmb03
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07

   FOREACH bmm_cur USING p_bma01_old INTO g_bmm.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmm01',g_bmm.bmm01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmm.bmm01,'bmm_file') THEN
         LET g_success = 'N'
      END IF
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmm.bmm03,'bmm_file') THEN
         LET g_success = 'N'
      END IF

      EXECUTE db_cs1_bmm USING g_bmm.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'   
            ELSE
               EXECUTE db_cs2_bmm USING g_bmm.*,g_bmm.bmm01,g_bmm.bmm02
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_bmm.bmm01,'/',g_bmm.bmm02
                  CALL s_errmsg('bmm01,bmm02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmm.bmm01,'/',g_bmm.bmm02
            CALL s_errmsg('bmm01,bmm02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      IF g_success = 'Y' THEN
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_bmm.bmm01||'+'||g_bmm.bmm02,'2')
      END IF
   END FOREACH
END FUNCTION
#MOD-E10161-End-Add

#MOD-E80134---add---str---
FUNCTION s_abmi600_bmba(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_bmb02,p_bmb03,p_bmb04,p_azp01,p_gew07)
   DEFINE p_bma01_old     LIKE bma_file.bma01
   DEFINE p_bma01_new     LIKE bma_file.bma01
   DEFINE p_bma06_old     LIKE bma_file.bma06
   DEFINE p_bma06_new     LIKE bma_file.bma06
   DEFINE p_bmb02         LIKE bmb_file.bmb02
   DEFINE p_bmb03         LIKE bmb_file.bmb03
   DEFINE p_bmb04         LIKE bmb_file.bmb04
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
 
   FOREACH bmba_cur USING p_bma01_old,p_bmb02,p_bmb03,p_bmb04,p_bma06_old INTO g_bmba.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmba01',g_bmba.bmba01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bma01_new) THEN LET g_bmba.bmba01 = p_bma01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bmba.bmba01 CLIPPED,'+',g_bmba.bmba02 CLIPPED,
                                          '+',g_bmba.bmba03 CLIPPED,'+',g_bmba.bmba04 CLIPPED,
                                          '+',g_bmba.bmba05 CLIPPED,'+',g_bmba.bmba06 CLIPPED,
                                          '+',g_bmba.bmba29 CLIPPED,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bmba.bmba01 CLIPPED,'+',g_bmba.bmba02 CLIPPED,
                                          '+',g_bmba.bmba03 CLIPPED,'+',g_bmba.bmba04 CLIPPED,
                                          '+',g_bmba.bmba05 CLIPPED,'+',g_bmba.bmba06 CLIPPED,
                                          '+',g_bmba.bmba29 CLIPPED,':'
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmba.bmba01,'bmba_file') THEN
         LET g_success = 'N'
      END IF
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmba.bmba03,'bmba_file') THEN
         LET g_success = 'N'
      END IF

      EXECUTE db_cs1_bmba USING g_bmba.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'    
            ELSE
               EXECUTE db_cs2_bmba USING g_bmba.*,g_bmba.bmba01,g_bmba.bmba02,g_bmba.bmba03,g_bmba.bmba04,g_bmba.bmba05,g_bmba.bmba06,g_bmba.bmba29
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_bmba.bmba01,'/',g_bmba.bmba02,'/',g_bmba.bmba03,'/',g_bmba.bmba04,'/',g_bmba.bmba05,'/',g_bmba.bmba06,'/',g_bmba.bmba29
                  CALL s_errmsg('bmba01,bmba02,bmba03,bmba04,bmba05,bmba06,bmba29',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmba.bmba01,'/',g_bmba.bmba02,'/',g_bmba.bmba03,'/',g_bmba.bmba04,'/',g_bmba.bmba05,'/',g_bmba.bmba06,'/',g_bmba.bmba29
            CALL s_errmsg('bmba01,bmba02,bmba03,bmba04,bmba05,bmba06,bmba29',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      IF g_success = 'Y' THEN
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,
              g_bmba.bmba01||'+'||g_bmba.bmba02||'+'||g_bmba.bmba03||'+'||g_bmba.bmba04||'+'||g_bmba.bmba05||'+'||g_bmba.bmba06||'+'||g_bmba.bmba29,'2')
      END IF
   END FOREACH
END FUNCTION

FUNCTION s_abmi600_bmbb(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_bmb02,p_bmb03,p_bmb04,p_azp01,p_gew07)
   DEFINE p_bma01_old     LIKE bma_file.bma01
   DEFINE p_bma01_new     LIKE bma_file.bma01
   DEFINE p_bma06_old     LIKE bma_file.bma06
   DEFINE p_bma06_new     LIKE bma_file.bma06
   DEFINE p_bmb02         LIKE bmb_file.bmb02
   DEFINE p_bmb03         LIKE bmb_file.bmb03
   DEFINE p_bmb04         LIKE bmb_file.bmb04
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
 
   FOREACH bmbb_cur USING p_bma01_old,p_bmb02,p_bmb03,p_bmb04,p_bma06_old INTO g_bmbb.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmbb01',g_bmbb.bmbb01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bma01_new) THEN LET g_bmbb.bmbb01 = p_bma01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bmbb.bmbb01 CLIPPED,'+',g_bmbb.bmbb02 CLIPPED,
                                          '+',g_bmbb.bmbb03 CLIPPED,'+',g_bmbb.bmbb04 CLIPPED,
                                          '+',g_bmbb.bmbb05 CLIPPED,'+',g_bmbb.bmbb06 CLIPPED,
                                          '+',g_bmbb.bmbb29 CLIPPED,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bmbb.bmbb01 CLIPPED,'+',g_bmbb.bmbb02 CLIPPED,
                                          '+',g_bmbb.bmbb03 CLIPPED,'+',g_bmbb.bmbb04 CLIPPED,
                                          '+',g_bmbb.bmbb05 CLIPPED,'+',g_bmbb.bmbb06 CLIPPED,
                                          '+',g_bmbb.bmbb29 CLIPPED,':'
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmbb.bmbb01,'bmbb_file') THEN
         LET g_success = 'N'
      END IF
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmbb.bmbb03,'bmbb_file') THEN
         LET g_success = 'N'
      END IF

      EXECUTE db_cs1_bmbb USING g_bmbb.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'    
            ELSE
               EXECUTE db_cs2_bmbb USING g_bmbb.*,g_bmbb.bmbb01,g_bmbb.bmbb02,g_bmbb.bmbb03,g_bmbb.bmbb04,g_bmbb.bmbb05,g_bmbb.bmbb06,g_bmbb.bmbb29
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_bmbb.bmbb01,'/',g_bmbb.bmbb02,'/',g_bmbb.bmbb03,'/',g_bmbb.bmbb04,'/',g_bmbb.bmbb05,'/',g_bmbb.bmbb06,'/',g_bmbb.bmbb29
                  CALL s_errmsg('bmbb01,bmbb02,bmbb03,bmbb04,bmbb05,bmbb06,bmbb29',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmbb.bmbb01,'/',g_bmbb.bmbb02,'/',g_bmbb.bmbb03,'/',g_bmbb.bmbb04,'/',g_bmbb.bmbb05,'/',g_bmbb.bmbb06,'/',g_bmbb.bmbb29
            CALL s_errmsg('bmbb01,bmbb02,bmbb03,bmbb04,bmbb05,bmbb06,bmbb29',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      IF g_success = 'Y' THEN
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,
              g_bmbb.bmbb01||'+'||g_bmbb.bmbb02||'+'||g_bmbb.bmbb03||'+'||g_bmbb.bmbb04||'+'||g_bmbb.bmbb05||'+'||g_bmbb.bmbb06||'+'||g_bmbb.bmbb29,'2')
      END IF
   END FOREACH
END FUNCTION

FUNCTION s_abmi600_bmbc(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_bmb02,p_bmb03,p_bmb04,p_azp01,p_gew07)
   DEFINE p_bma01_old     LIKE bma_file.bma01
   DEFINE p_bma01_new     LIKE bma_file.bma01
   DEFINE p_bma06_old     LIKE bma_file.bma06
   DEFINE p_bma06_new     LIKE bma_file.bma06
   DEFINE p_bmb02         LIKE bmb_file.bmb02
   DEFINE p_bmb03         LIKE bmb_file.bmb03
   DEFINE p_bmb04         LIKE bmb_file.bmb04
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
 
   FOREACH bmbc_cur USING p_bma01_old,p_bmb02,p_bmb03,p_bmb04,p_bma06_old INTO g_bmbc.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmbc01',g_bmbc.bmbc01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bma01_new) THEN LET g_bmbc.bmbc01 = p_bma01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bmbc.bmbc01 CLIPPED,'+',g_bmbc.bmbc02 CLIPPED,
                                          '+',g_bmbc.bmbc03 CLIPPED,'+',g_bmbc.bmbc04 CLIPPED,
                                          '+',g_bmbc.bmbc05 CLIPPED,'+',g_bmbc.bmbc29 CLIPPED,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bmbc.bmbc01 CLIPPED,'+',g_bmbc.bmbc02 CLIPPED,
                                          '+',g_bmbc.bmbc03 CLIPPED,'+',g_bmbc.bmbc04 CLIPPED,
                                          '+',g_bmbc.bmbc05 CLIPPED,'+',g_bmbc.bmbc29 CLIPPED,':'
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmbc.bmbc01,'bmbc_file') THEN
         LET g_success = 'N'
      END IF
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmbc.bmbc03,'bmbc_file') THEN
         LET g_success = 'N'
      END IF

      EXECUTE db_cs1_bmbc USING g_bmbc.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'    
            ELSE
               EXECUTE db_cs2_bmbc USING g_bmbc.*,g_bmbc.bmbc01,g_bmbc.bmbc02,g_bmbc.bmbc03,g_bmbc.bmbc04,g_bmbc.bmbc05,g_bmbc.bmbc29
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_bmbc.bmbc01,'/',g_bmbc.bmbc02,'/',g_bmbc.bmbc03,'/',g_bmbc.bmbc04,'/',g_bmbc.bmbc05,'/',g_bmbc.bmbc29
                  CALL s_errmsg('bmbc01,bmbc02,bmbc03,bmbc04,bmbc05,bmbc29',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmbc.bmbc01,'/',g_bmbc.bmbc02,'/',g_bmbc.bmbc03,'/',g_bmbc.bmbc04,'/',g_bmbc.bmbc05,'/',g_bmbc.bmbc29
            CALL s_errmsg('bmbc01,bmbc02,bmbc03,bmbc04,bmbc05,bmbc29',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      IF g_success = 'Y' THEN
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,
              g_bmbc.bmbc01||'+'||g_bmbc.bmbc02||'+'||g_bmbc.bmbc03||'+'||g_bmbc.bmbc04||'+'||g_bmbc.bmbc05||'+'||g_bmbc.bmbc29,'2')
      END IF
   END FOREACH
END FUNCTION

FUNCTION s_abmi600_bmbd(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_bmb02,p_bmb03,p_bmb04,p_azp01,p_gew07)
   DEFINE p_bma01_old     LIKE bma_file.bma01
   DEFINE p_bma01_new     LIKE bma_file.bma01
   DEFINE p_bma06_old     LIKE bma_file.bma06
   DEFINE p_bma06_new     LIKE bma_file.bma06
   DEFINE p_bmb02         LIKE bmb_file.bmb02
   DEFINE p_bmb03         LIKE bmb_file.bmb03
   DEFINE p_bmb04         LIKE bmb_file.bmb04
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
 
   FOREACH bmbd_cur USING p_bma01_old,p_bmb02,p_bmb03,p_bmb04,p_bma06_old INTO g_bmbd.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmbd01',g_bmbd.bmbd01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bma01_new) THEN LET g_bmbd.bmbd01 = p_bma01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bmbd.bmbd01 CLIPPED,'+',g_bmbd.bmbd02 CLIPPED,
                                          '+',g_bmbd.bmbd03 CLIPPED,'+',g_bmbd.bmbd04 CLIPPED,
                                          '+',g_bmbd.bmbd05 CLIPPED,'+',g_bmbd.bmbd29 CLIPPED,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bmbd.bmbd01 CLIPPED,'+',g_bmbd.bmbd02 CLIPPED,
                                          '+',g_bmbd.bmbd03 CLIPPED,'+',g_bmbd.bmbd04 CLIPPED,
                                          '+',g_bmbd.bmbd05 CLIPPED,'+',g_bmbd.bmbd29 CLIPPED,':'
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmbd.bmbd01,'bmbd_file') THEN
         LET g_success = 'N'
      END IF
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bmbd.bmbd03,'bmbd_file') THEN
         LET g_success = 'N'
      END IF

      EXECUTE db_cs1_bmbd USING g_bmbd.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'    
            ELSE
               EXECUTE db_cs2_bmbd USING g_bmbd.*,g_bmbd.bmbd01,g_bmbd.bmbd02,g_bmbd.bmbd03,g_bmbd.bmbd04,g_bmbd.bmbd05,g_bmbd.bmbd29
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_bmbd.bmbd01,'/',g_bmbd.bmbd02,'/',g_bmbd.bmbd03,'/',g_bmbd.bmbd04,'/',g_bmbd.bmbd05,'/',g_bmbd.bmbd29
                  CALL s_errmsg('bmbd01,bmbd02,bmbd03,bmbd04,bmbd05,bmbd29',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bmbd.bmbd01,'/',g_bmbd.bmbd02,'/',g_bmbd.bmbd03,'/',g_bmbd.bmbd04,'/',g_bmbd.bmbd05,'/',g_bmbd.bmbd29
            CALL s_errmsg('bmbd01,bmbd02,bmbd03,bmbd04,bmbd05,bmbd29',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      IF g_success = 'Y' THEN
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,
              g_bmbd.bmbd01||'+'||g_bmbd.bmbd02||'+'||g_bmbd.bmbd03||'+'||g_bmbd.bmbd04||'+'||g_bmbd.bmbd05||'+'||g_bmbd.bmbd29,'2')
      END IF
   END FOREACH
END FUNCTION
#MOD-E80134---add---end---
#MOD-G10134---add---str---
#ICD料件下階製程料件
FUNCTION s_abmi600_icm(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_bmb02,p_bmb03,p_bmb04,p_azp01,p_gew07)
   DEFINE p_bma01_old     LIKE bma_file.bma01
   DEFINE p_bma01_new     LIKE bma_file.bma01
   DEFINE p_bma06_old     LIKE bma_file.bma06
   DEFINE p_bma06_new     LIKE bma_file.bma06
   DEFINE p_bmb02         LIKE bmb_file.bmb02
   DEFINE p_bmb03         LIKE bmb_file.bmb03
   DEFINE p_bmb04         LIKE bmb_file.bmb04
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
 
   FOREACH icm_cur USING p_bma01_old,p_bmb03 INTO g_icm.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('icm02',g_icm.icm02,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bma01_new) THEN LET g_icm.icm02 = p_bma01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_icm.icm02 CLIPPED,'+',g_icm.icm01 CLIPPED,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_icm.icm02 CLIPPED,'+',g_icm.icm01 CLIPPED,':'
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_icm.icm02,'icm_file') THEN
         LET g_success = 'N'
      END IF
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_icm.icm01,'icm_file') THEN
         LET g_success = 'N'
      END IF

      EXECUTE db_cs1_icm USING g_icm.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'    
            ELSE
               EXECUTE db_cs2_icm USING g_icm.*,g_icm.icm01,g_icm.icm02
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_icm.icm01,'/',g_icm.icm02
                  CALL s_errmsg('icm01,icm02,icm03,icm04,icm12,icm13,icm14,icm15,icm16,icmacti,icmdate,icmgrup,icmmodu,icmuser,icmorig,icmoriu',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_icm.icm01,'/',g_icm.icm02
            CALL s_errmsg('icm01,icm02,icm03,icm04,icm12,icm13,icm14,icm15,icm16,icmacti,icmdate,icmgrup,icmmodu,icmuser,icmorig,icmoriu',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      IF g_success = 'Y' THEN
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_icm.icm01||'+'||g_icm.icm02,'2')
      END IF
   END FOREACH
END FUNCTION
#MOD-G10134---add---end---
FUNCTION s_abmi600_boa(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_bmb03,p_azp01,p_gew07)
   DEFINE p_bma01_old     LIKE bma_file.bma01
   DEFINE p_bma01_new     LIKE bma_file.bma01
   DEFINE p_bma06_old     LIKE bma_file.bma06
   DEFINE p_bma06_new     LIKE bma_file.bma06
   DEFINE p_bmb03         LIKE bmb_file.bmb03
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
 
   FOREACH boa_cur USING p_bma01_old,p_bmb03 INTO g_boa.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('boa01',g_boa.boa01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bma01_new) THEN LET g_boa.boa01 = p_bma01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_boa.boa01 CLIPPED,'+',g_boa.boa02 CLIPPED,'+',g_boa.boa03 CLIPPED,'+',g_boa.boa04 CLIPPED,'+',g_boa.boa05 CLIPPED,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_boa.boa01 CLIPPED,'+',g_boa.boa02 CLIPPED,'+',g_boa.boa03 CLIPPED,'+',g_boa.boa04 CLIPPED,'+',g_boa.boa05 CLIPPED,':'
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_boa.boa03,'boa_file') THEN
         LET g_success = 'N'
      END IF
      EXECUTE db_cs1_boa USING g_boa.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         #No.FUN-A80036  --End  
            #IF p_gew07 = 'N' THEN #20200505 mark
            IF p_gew07 = 'O' THEN  #20200505 modify 
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'      #No.FUN-A80036
            ELSE
               EXECUTE db_cs2_boa USING g_boa.*,g_boa.boa01,g_boa.boa02,g_boa.boa03,g_boa.boa04,g_boa.boa05
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_boa.boa01,'/',g_boa.boa02,'/',g_boa.boa03,'/',g_boa.boa04,'/',g_boa.boa05
                  CALL s_errmsg('boa01,boa02,boa03,boa04,boa05',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_boa.boa01,'/',g_boa.boa02,'/',g_boa.boa03,'/',g_boa.boa04,'/',g_boa.boa05
            CALL s_errmsg('boa01,boa02,boa03,boa04,boa05',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_boa.boa01||'+'||g_boa.boa02||'+'||g_boa.boa03||'+'||g_boa.boa04||'+'||g_boa.boa05,'2')
         CALL s_abmi600_bob(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,g_boa.boa02,p_azp01,p_gew07)
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_abmi600_bob(p_bma01_old,p_bma01_new,p_bma06_old,p_bma06_new,p_boa02,p_azp01,p_gew07)
   DEFINE p_bma01_old     LIKE bma_file.bma01
   DEFINE p_bma01_new     LIKE bma_file.bma01
   DEFINE p_bma06_old     LIKE bma_file.bma06
   DEFINE p_bma06_new     LIKE bma_file.bma06
   DEFINE p_boa02         LIKE boa_file.boa02
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
 
   FOREACH bob_cur USING p_bma01_old,p_boa02 INTO g_bob.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bob01',g_bob.bob01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bma01_new) THEN LET g_bob.bob01 = p_bma01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_bob.bob01 CLIPPED,'+',g_bob.bob02 CLIPPED,'+',g_bob.bob03 CLIPPED,
                   '+',g_bob.bob04 CLIPPED,'+',g_bob.bob05 CLIPPED,'+',g_bob.bob06 CLIPPED,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_bob.bob01 CLIPPED,'+',g_bob.bob02 CLIPPED,'+',g_bob.bob03 CLIPPED,
                   '+',g_bob.bob04 CLIPPED,'+',g_bob.bob05 CLIPPED,'+',g_bob.bob06 CLIPPED,':'
      #check item exist or not ?
      IF NOT s_abmi600_carry_chk_ima(g_bob.bob04,'bob_file') THEN
         LET g_success = 'N'
      END IF
      EXECUTE db_cs1_bob USING g_bob.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         #No.FUN-A80036  --End  
           #IF p_gew07 = 'N' THEN     #20200505 mark
            IF p_gew07 = 'O' THEN     #20200505 modify
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'      #No.FUN-A80036
            ELSE
               EXECUTE db_cs2_bob USING g_bob.*,g_bob.bob01,g_bob.bob02,g_bob.bob03,
                                        g_bob.bob04,g_bob.bob05,g_bob.bob06
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_bob.bob01,'/',g_bob.bob02,'/',g_bob.bob03,'/',g_bob.bob04,'/',g_bob.bob05,'/',g_bob.bob06
                  CALL s_errmsg('bob01,bob02,bob03,bob04,bob05,bob06',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_bob.bob01,'/',g_bob.bob02,'/',g_bob.bob03,'/',g_bob.bob04,'/',g_bob.bob05,'/',g_bob.bob06
            CALL s_errmsg('bob01,bob02,bob03,bob04,bob05,bob06',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,
              g_bob.bob01||'+'||g_bob.bob02||'+'||g_bob.bob03||'+'||g_bob.bob04||'+'||g_bob.bob05||'+'||g_bob.bob06,'2')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_abmi600_carry_p1()
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_tabname            STRING                    #No.FUN-A80036         
   DEFINE l_str                STRING                    #No.FUN-A80036
 
  #FUN-AC0026---mark---str---
  #CALL s_dc_cre_temp_table("bma_file") RETURNING l_tabname
  #FUN-AC0026---mark---end---
  #FUN-AC0026---add----str---
   IF g_prog <> 'aws_ttsrv2' THEN 
       CALL s_dc_cre_temp_table("bma_file") RETURNING l_tabname
   ELSE
      #LET l_tabname = g_dc_tabname     #FUN-B20003 mark
       LET l_tabname = g_dc_tabname_bma #FUN-B20003 add
   END IF
  #FUN-AC0026---add----end---
   #No.FUN-A80036  --Begin
   #LET g_sql = " CREATE UNIQUE INDEX bma_file_bak_01 ON ",l_tabname CLIPPED,"(bma01,bma06)"
   LET g_sql = " CREATE UNIQUE INDEX ",l_tabname CLIPPED,"_01 ON ",l_tabname CLIPPED,"(bma01,bma06)"
   #No.FUN-A80036  --End  
   PREPARE unique_p1 FROM g_sql
   EXECUTE unique_p1
 
   LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM bma_file",
                                                 "  WHERE bma01 = ? AND bma06 = ?"
   PREPARE ins_pp FROM g_sql
 
   LET g_all_cnt = 0
   #No.FUN-830090  --Begin
   IF cl_null(g_flagx) THEN LET g_flagx = '0' END IF
   IF g_flagx <> '1' THEN
      FOR l_i = 1 TO g_bma_1.getLength()
          IF cl_null(g_bma_1[l_i].bma01) THEN
             CONTINUE FOR
          END IF
          IF g_bma_1[l_i].sel = 'N' THEN
             CONTINUE FOR
          END IF
          EXECUTE ins_pp USING g_bma_1[l_i].bma01,g_bma_1[l_i].bma06
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN
          IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN
         #No.FUN-A80036  --End  
             LET l_str = "ins ",l_tabname                   #No.FUN-A80036      
            #IF g_bgerr THEN                                #No.FUN-AC0026 mark
             IF g_bgerr OR g_prog = 'aws_ttsrv2' THEN       #No.FUN-AC0026 add
                CALL s_errmsg('','',l_str,SQLCA.sqlcode,1)  #No.FUN-A80036      
             ELSE                                                               
                CALL cl_err(l_str,SQLCA.sqlcode,1)          #No.FUN-A80036      
             END IF
             CONTINUE FOR
          END IF
          LET g_all_cnt = g_all_cnt + 1
      END FOR
   ELSE
      LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM bma_file_bak1"
      PREPARE ins_ppx FROM g_sql
      EXECUTE ins_ppx
      LET g_sql = " SELECT COUNT(*) FROM ",l_tabname
      PREPARE cnt_ppx FROM g_sql
      EXECUTE cnt_ppx INTO g_all_cnt
      IF cl_null(g_all_cnt) THEN LET g_all_cnt = 0 END IF
   END IF
   #No.FUN-830090  --End
 
   RETURN l_tabname
END FUNCTION
 
FUNCTION s_abmi600_download(p_bma)
  DEFINE p_bma        DYNAMIC ARRAY OF RECORD
                      sel      LIKE type_file.chr1,
                      bma01    LIKE bma_file.bma01,
                      bma06    LIKE bma_file.bma06
                      END RECORD
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10
 
    #
    FOR l_i = 1 TO p_bma.getLength()
        LET g_bma_1[l_i].* = p_bma[l_i].*
    END FOR
 
    CALL s_dc_download_path() RETURNING l_path
    IF cl_null(l_path) THEN RETURN END IF
    CALL s_abmi600_download_files(l_path)
 
END FUNCTION
 
FUNCTION s_abmi600_download_files(p_path)
  DEFINE p_path            LIKE ze_file.ze03
  DEFINE l_download_file   LIKE ze_file.ze03
  DEFINE l_upload_file     LIKE ze_file.ze03
  DEFINE l_status          LIKE type_file.num5
  DEFINE l_n               LIKE type_file.num5
  DEFINE l_i               LIKE type_file.num5
  DEFINE l_tempdir         LIKE ze_file.ze03
  DEFINE l_temp_file       LIKE ze_file.ze03
  DEFINE l_temp_file1      LIKE ze_file.ze03
  DEFINE l_tabname         LIKE type_file.chr50
 
   LET l_tempdir=FGL_GETENV("TEMPDIR")
   LET l_n=LENGTH(l_tempdir)
   IF l_n>0 THEN
      IF l_tempdir[l_n,l_n]='/' THEN
         LET l_tempdir[l_n,l_n]=' '
      END IF
   END IF
   LET l_n=LENGTH(p_path)
   IF l_n>0 THEN
      IF p_path[l_n,l_n]='/' THEN
         LET p_path[l_n,l_n]=' '
      END IF
   END IF
 
   LET l_tempdir    = fgl_getenv('TEMPDIR')
 
   #
   CALL s_abmi600_carry_p1() RETURNING l_tabname
 
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog CLIPPED,'_bma_file_2.txt'  #No.FUN-830090
   LET l_download_file = p_path CLIPPED,"/",g_prog CLIPPED,"_bma_file_2.txt"   #No.FUN-830090
 
   LET g_sql = "SELECT * FROM ",l_tabname
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
 
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #bmc
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog CLIPPED,'_bmc_file_2.txt'  #No.FUN-830090
   LET l_download_file = p_path CLIPPED,"/",g_prog CLIPPED,"_bmc_file_2.txt"   #No.FUN-830090
 
   LET g_sql = "SELECT bmc_file.* FROM bmc_file,bmb_file WHERE ",
               " (bmb01,bmb29) IN (SELECT bma01,bma06 FROM ",l_tabname CLIPPED,")",
               " AND bmb01 = bmc01 AND bmb02 = bmc02 AND bmb03 = bmc021 AND bmb04 = bmc03 AND bmb29 = bmc06 "
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
 
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #bmb
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog CLIPPED,'_bmb_file_2.txt'  #No.FUN-830090
   LET l_download_file = p_path CLIPPED,"/",g_prog CLIPPED,"_bmb_file_2.txt"   #No.FUN-830090
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   LET g_sql = "SELECT * FROM bmb_file WHERE ",
               " (bmb01,bmb29) IN (SELECT bma01,bma06 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
 
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #bmd
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog CLIPPED,'_bmd_file_2.txt'  #No.FUN-830090
   LET l_download_file = p_path CLIPPED,"/",g_prog CLIPPED,"_bmd_file_2.txt"   #No.FUN-830090
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   LET g_sql = "SELECT bmd_file.* FROM bmb_file,bmd_file WHERE ",
               " bmb01 IN (SELECT bma01 FROM ",l_tabname CLIPPED,") AND bmb01 = bmd08 ",
               " AND bmb03 = bmd01 AND (bmb04 <= '",g_today,"'",
               " OR bmb04 IS NULL) AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)",
               " AND bmdacti = 'Y'"                                           #CHI-910021
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
 
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #bmt
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog CLIPPED,'_bmt_file_2.txt'  #No.FUN-830090
   LET l_download_file = p_path CLIPPED,"/",g_prog CLIPPED,"_bmt_file_2.txt"   #No.FUN-830090
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   LET g_sql = "SELECT bmt_file.* FROM bmb_file,bmt_file WHERE ",
               " (bmb01,bmb29) IN (SELECT bma01,bma06 FROM ",l_tabname CLIPPED,") AND bmb01 = bmt01 ",
               " AND bmb02 = bmt02 AND bmb03 = bmt03 AND bmb04 = bmt04 AND bmb29 = bmt08 "
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
 
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #bml
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog CLIPPED,'_bml_file_2.txt'  #No.FUN-830090
   LET l_download_file = p_path CLIPPED,"/",g_prog CLIPPED,"_bml_file_2.txt"   #No.FUN-830090
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   LET g_sql = "SELECT bml_file.* FROM bmb_file,bml_file WHERE ",
               " bmb01 IN (SELECT bma01 FROM ",l_tabname CLIPPED,") AND bmb01 = bml02 ",
               " AND bmb03 = bml01 "
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
 
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #boa
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog CLIPPED,'_boa_file_2.txt'  #No.FUN-830090
   LET l_download_file = p_path CLIPPED,"/",g_prog CLIPPED,"_boa_file_2.txt"   #No.FUN-830090
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   LET g_sql = "SELECT boa_file.* FROM bmb_file,boa_file WHERE ",
               " bmb01 IN (SELECT bma01 FROM ",l_tabname CLIPPED,") AND bmb01 = boa01 ",
               " AND bmb03 = boa03 "
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
 
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #bob
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog CLIPPED,'_bob_file_2.txt'  #No.FUN-830090
   LET l_download_file = p_path CLIPPED,"/",g_prog CLIPPED,"_bob_file_2.txt"   #No.FUN-830090
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   LET g_sql = "SELECT bob_file.* FROM bmb_file,boa_file,bob_file WHERE ",
               " bmb01 IN (SELECT bma01 FROM ",l_tabname CLIPPED,") AND bmb01 = bob01 ",
               " AND bob02 = boa02 AND bmb01 = boa01 AND bmb03 = boa03 "
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
 
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
END FUNCTION
 
FUNCTION s_abmi600_carry_chk_ima(p_ima01,p_tabname)
   DEFINE p_ima01        LIKE ima_file.ima01
   DEFINE p_tabname      LIKE type_file.chr50
   DEFINE l_cnt          LIKE type_file.num5
 
   IF cl_null(p_ima01) THEN
      RETURN TRUE
   END IF
 
   LET l_cnt = 0
  #LET g_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"ima_file ",   #FUN-A50102
   LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'ima_file'),   #FUN-A50102
             " WHERE ima01='",p_ima01,"'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  #FUN-A50102
   PREPARE chk_ima_p1 FROM g_sql
   EXECUTE chk_ima_p1 INTO l_cnt
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
 
   IF l_cnt = 0 THEN
      LET g_showmsg = g_dbs_sep,"/",p_tabname,"/",p_ima01
      CALL s_errmsg('azp01,gat01,ima01',g_showmsg,'sel ima01','abm-805',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
#No.FUN-820031---END

#FUN-D40122 ---------- add ----------------- begin -------------------
##################################################
# Descriptions...: 資料中心拋轉時DB選擇作業
# Input PARAMETER: p_gew01  資料中心
#                  p_gew02  資料類型
#                  p_sql    查詢資料的sql語句
##################################################
FUNCTION s_abmi600_sel_db1(p_gew01,p_gew02,p_sql)
   DEFINE p_gew01    LIKE gew_file.gew01
   DEFINE p_gew02    LIKE gew_file.gew02
   DEFINE p_sql      STRING 
   DEFINE l_gew03    LIKE gew_file.gew03
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_dbs_sep  LIKE type_file.chr50
   DEFINE l_gev04    LIKE gev_file.gev04
   DEFINE l_geu02    LIKE geu_file.geu02
   DEFINE l_n        LIKE type_file.num5  
   DEFINE l_azw01    LIKE azw_file.azw01  
   DEFINE l_azw06    LIKE azw_file.azw06  
   DEFINE l_str      STRING               

   WHENEVER ERROR CALL cl_err_msg_log

    LET g_gew01 = p_gew01
    LET g_gew02 = p_gew02

    CALL g_azp1.clear()
    LET g_rec_dc = 0

    SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
     WHERE gew01 = g_gew01 AND gew02 = g_gew02
    IF SQLCA.sqlcode THEN
       IF SQLCA.sqlcode = -284 THEN
          LET l_gew03 = 'N'
       END IF
    END IF

    IF l_gew03 = '1' OR l_gew03 = '2' OR l_gew03 = '3' THEN
       DECLARE s_dc_sel_azp1 CURSOR FOR
        #SELECT 'Y',gew04,azp02,azp03,' ','N' FROM gew_file,OUTER azp_file  #20240313 mark
         SELECT 'N',gew04,azp02,azp03,' ','N' FROM gew_file,OUTER azp_file  #20240313 modify
         WHERE gew01 = g_gew01
           AND gew02 = g_gew02
           AND gew_file.gew04 = azp_file.azp01
           AND gew04 <> g_plant

       LET g_cnt = 1
       FOREACH s_dc_sel_azp1 INTO g_azp1[g_cnt].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach s_dc_sel_azp:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          CALL s_dbstring(g_azp1[g_cnt].azp03) RETURNING l_dbs_sep
          LET g_sql = cl_replace_str(p_sql,"&",l_dbs_sep)
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql #MOD-970195
          PREPARE exist_p1 FROM g_sql
          EXECUTE exist_p1 INTO l_cnt
          IF l_cnt > 0 THEN
             LET g_azp1[g_cnt].exist = 'Y'
          ELSE
             LET g_azp1[g_cnt].exist = 'N'
          END IF
          LET l_azw06 = NULL
          LET l_azw01 = NULL
          LET l_str = ''
          SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = g_azp1[g_cnt].azp01
          DECLARE s_dc_db1  CURSOR  FOR
                  SELECT azw01 FROM azw_file WHERE azw06 = l_azw06
          FOREACH s_dc_db1  INTO l_azw01
            IF STATUS THEN
               CALL cl_err('foreach:',STATUS,1)
               EXIT FOREACH
            END IF
            IF l_azw01 = g_azp1[g_cnt].azp01 THEN
               LET l_azw01 = NULL
               CONTINUE FOREACH
            END IF
            IF cl_null(l_str)  THEN
               LET l_str = l_azw01
            ELSE
               LET l_str = l_str,",",l_azw01
            END IF
          END FOREACH
          LET g_azp1[g_cnt].plant = l_str
          LET g_cnt = g_cnt + 1
       END FOREACH
       CALL g_azp1.deleteElement(g_cnt)
       LET g_rec_dc = g_cnt - 1
    END IF
    IF l_gew03 = '3' THEN
        OPEN WINDOW s_dc_1_w1 WITH FORM "sub/42f/s_dc_sel_db1"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)

        CALL cl_ui_locale("s_dc_sel_db1")

        SELECT gev04 INTO l_gev04 FROM gev_file
         WHERE gev01 = p_gew02 AND gev02 = g_plant
        SELECT geu02 INTO l_geu02 FROM geu_file
         WHERE geu01 = l_gev04 AND geu00='1'
        DISPLAY l_gev04 TO FORMONLY.gev04
        DISPLAY l_geu02 TO FORMONLY.geu02
        CALL s_check_gev04(l_gev04,p_gew02)
        IF NOT cl_null(g_errno) THEN
           CALL cl_err(l_gev04,g_errno,1)
           CLOSE WINDOW s_dc_1_w1
           RETURN
        END IF
        LET l_n = 0
        SELECT COUNT(*) INTO l_n FROM azw_file
         WHERE azw05 <> azw06
        IF l_n  = 0  THEN
           CALL cl_set_comp_visible("plant",FALSE)
        END IF

        DISPLAY ARRAY g_azp1 TO s_azp.* ATTRIBUTE(COUNT=g_rec_dc,UNBUFFERED)
           BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY

        CALL cl_set_act_visible("accept", TRUE)
        INPUT ARRAY g_azp1 WITHOUT DEFAULTS FROM s_azp.*
              ATTRIBUTE(COUNT=g_rec_dc,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)

           BEFORE INPUT
              IF g_rec_dc!=0 THEN
                 CALL fgl_set_arr_curr(i)
              END IF

           BEFORE ROW
              LET i = ARR_CURR()             # 現在游標是在陣列的第幾筆

           BEFORE INSERT
              LET g_azp1[i].sel = 'N'
              LET g_azp1[i].exist = 'N'

           AFTER FIELD azp01
              IF NOT cl_null(g_azp1[i].azp01) THEN
                 CALL s_dc_sel_db_azp01_1()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_azp1[i].azp01,g_errno,0)
                    NEXT FIELD azp01
                 END IF
                 CALL s_dbstring(g_azp1[i].azp03) RETURNING l_dbs_sep
                 LET g_sql = cl_replace_str(p_sql,"&",l_dbs_sep)
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
                 PREPARE exist_p2 FROM g_sql
                 EXECUTE exist_p2 INTO l_cnt
                 IF l_cnt > 0 THEN
                    LET g_azp1[i].exist = 'Y'
                 ELSE
                    LET g_azp1[i].exist = 'N'
                 END IF
                 LET l_azw06 = NULL
                 LET l_azw01 = NULL
                 LET l_str = ''
                 SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = g_azp1[i].azp01
                 DECLARE s_dc_db2  CURSOR  FOR
                         SELECT azw01 FROM azw_file WHERE azw06 = l_azw06
                 FOREACH s_dc_db2  INTO l_azw01
                   IF STATUS THEN
                      CALL cl_err('foreach:',STATUS,1)
                      EXIT FOREACH
                   END IF
                   IF l_azw01 = g_azp1[i].azp01 THEN
                      LET l_azw01 = NULL
                      CONTINUE FOREACH
                   END IF
                   IF cl_null(l_str)  THEN
                      LET l_str = l_azw01
                   ELSE
                      LET l_str = l_str,",",l_azw01
                   END IF
                 END FOREACH
                 DISPLAY l_str TO formonly.plant
              ELSE
                 LET g_azp1[i].azp02 = NULL
                 LET g_azp1[i].azp03 = NULL
                 DISPLAY '' TO formonly.plant
              END IF

           AFTER ROW
              LET i = ARR_CURR()

           ON ACTION controlp
              CASE
                 WHEN INFIELD(azp01)        #azp_file
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     = "q_gew04"
                      LET g_qryparam.arg1     = g_gew01
                      LET g_qryparam.arg2     = g_gew02
                      LET g_qryparam.where    = " gew04 <> '",g_plant,"'"
                      LET g_qryparam.default1 = g_azp1[i].azp01
                      CALL cl_create_qry() RETURNING g_azp1[i].azp01
                      CALL s_dc_sel_db_azp01_1()
                      NEXT FIELD azp01
              END CASE

           ON ACTION select_all
              CALL s_dc_sel_all1("Y")

           ON ACTION select_non
              CALL s_dc_sel_all1("N")

           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT

           ON ACTION controlg
              CALL cl_cmdask()

        END INPUT

        CLOSE WINDOW s_dc_1_w1

        IF INT_FLAG THEN
           RETURN
        END IF

        LET g_rec_dc = g_azp1.getLength()
    END IF
END FUNCTION
#FUN-D40122 ---------- add ----------------- end ---------------------
