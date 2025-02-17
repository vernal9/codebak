# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: aimi100_sub.4gl
# Descriptions...: 將原aimi100.4gl確認段拆解至aimi100_sub.4gl中
# Date & Author..: #FUN-A70106 10/07/20 By Mandy
# Modify.........: #FUN-B20050 11/02/18 By Mandy MES整合無法連線時,應正確show出錯誤訊息
# Modify.........: #FUN-B60046 11/06/09 By Abby  修正"當有與MES整合且來源碼為[Z]時，資料無法進行確認"
#---------------------------------------------------------------------------------------------
# Modify.........: #FUN-A70106 11/06/28 By Mandy PLM GP5.1追版至GP5.25 以上為GP5.1單號
# Modify.........: #TQC-C20283 12/02/20 By zhuhao 確認時，加判斷，特性資料(imac_file)中，所有歸屬層級="1.料號"的時，皆需有值才可確認
# Modify.........: #MOD-C30124 12/03/09 By yuhuabao 母料加判斷，如未設定特性資料，則不可確認
# Modify.........: #MOD-C30164 12/03/10 By yuhuabao 母料為特性主料時不需要做aim1144的判斷
# Modify.........: #FUN-C50110 12/05/29 By bart ICD確認後需要自動拋轉
# Modify.........: #FUN-C60021 12/06/06 by xqzy 鞋服業暫不做特性料件
# Modify.........: #FUN-C90107 12/09/28 By Abby  無效段拆解至aimi100_sub.4gl並Service CALL FUNCTION調整
# Modify.........: #FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: #MOD-CC0187 13/01/11 By Elise 調整料在BOM有取替代關係時做無效的控卡
# Modify.........: #MOD-D30241 13/03/27 By bart 程式清單無資料
# Modify.........: No:CHI-B70001 13/05/02 By Alberti 當料件做廢時，判斷是否為有效且未結案請購單，若有則不允許做無效
# Modify.........: No:MOD-D90004 13/09/02 By Alberti 資料已確認用ima1010='1' #確認 來判斷，而非 imaacti
# Modify.........: No:FUN-DA0039 13/10/16 By Nina 新增料件時aimi100如拋轉MES失敗則TIPTOP也需確認失敗
# Modify.........: No:CHI-DB0011 13/11/19 By Alberti 在新增及確認段時，需增加 cl_flow_notify 
# Modify.........: No:MOD-E10033 14/01/07 By jt_chen aimi100確認時檢查產品分類碼需為有效
# Modify.........: No:FUN-E50065 14/05/23 By Smapmin CALL cl_flow_notify()應寫在_y_upd(),否則會寄送2次通知
# Modify.........: No.MOD-E70080 14/07/17 By Alberti 無效時 ,檢查abmi100未生效的BOM(bmo05=空的),是否有使用到,
#                                                    若有則提示:工程BOM已有使用,詢問是否確認無效後再做無效
# Modify.........: No:MOD-E80007 14/08/01 By Summer 續CHI-B70001,增加排除作廢請購單 
# Modify.........: No:MOD-EA0048 14/10/07 By Johnson 產品設定無效碼時,檢查是否任一產品策略使用到該產品.如果有,則不可上無效碼.
# Modify.........: No.FUN-E80014 15/05/28 By TsungYung 流通業在輸入相關單據時，應該不須控卡MISC要存在於商品/採購策略中
# Modify.........: No.MOD-F60012 15/06/02 By ywtsai 料件無效時判斷請購單單身狀態碼(pml16)為結案或作廢(6、7、8、9)之條件
# Modify.........: No.CHI-F80014 15/09/02 By fionchen 調整CURSOR在二次查詢顯示異常的問題 
# Modify.........: No.CHI-F90007 15/09/08 By catmoon 只要程式有UPDATE ima_file 的任何一個欄位時,同時UPDATE imamodu=g_user
# Modify.........:               20180514 By momo aim1011 檢核更改為只抓未結案且有餘量的請購量
# Modify.........:               20180516 By momo 修正料件失效時未檢核是否有群組替代
# Modify.........: No.           18/05/23 By Ruby 增加資料清單欄位(安全存量&最小採購量)
# Modify.........:               20180612 By momo 確認與作廢更新最後版本料件至 ima133
# Modify.........:               20180817 By momo 舊預測料號等同此次變更料號時，也一併更新為新預測料號
# Modify.........:               20180828 By momo 預測料號一併同步至蘇州
# Modify.........: NO.1910233808 20191024 By momo 料號確認時檢核成品分群是否皆已維護
# Modify.........: No.2009045161 20200907 By momo 料號改無效時，清空預設倉儲
# Modify.........: No.           20211001 By momo NO.1910233808 限定 營運中心DC
# Modify.........: No.22090046   20220929 By momo 分群檢核

DATABASE ds
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../4gl/aimi100.global"
GLOBALS "../../../tiptop/sub/4gl/s_data_center.global"   

FUNCTION i100sub_lock_cl() #FUN-A70106
   DEFINE l_forupd_sql STRING                                                   

  #LET l_forupd_sql = "SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE NOWAIT" #FUN-A70106 mark
   LET l_forupd_sql = "SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE "       #FUN-A70106 add
   LET g_forupd_sql = cl_forupd_sql(l_forupd_sql)           #轉換不同資料庫語法  #FUN-A70106 add
   DECLARE i100sub_cl CURSOR FROM l_forupd_sql                                  
END FUNCTION

#FUN-C90107 add str-------------
FUNCTION i100sub_declare_curs()

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')

   LET g_sql = "SELECT ima01 FROM ima_file ", # 組合出 SQL 指令
             # " WHERE ",g_wc CLIPPED,                                                      #FUN-A90049 mark
               " WHERE ( ima120 IS NULL OR ima120 = ' ' OR ima120 = '1' ) AND ",g_wc CLIPPED,    #FUN-A90049 add
               " ORDER BY ima01"
&ifdef ICD
   IF g_wc.getindexof('imaicd',1)>0 THEN
      LET g_sql = "SELECT ima_file.ima01 FROM ima_file,imaicd_file ", # 組合出 SQL 指令
                # " WHERE ima01=imaicd00 AND ",g_wc CLIPPED,                                                     #FUN-A90
                  " WHERE ( ima120 IS NULL OR ima120 = ' ' OR ima120 = '1' ) AND ima01=imaicd00 AND ",g_wc CLIPPED,   #FU
                  " ORDER BY ima01"
   END IF
&endif
   PREPARE aimi100sub_prepare FROM g_sql
   DECLARE aimi100sub_curs SCROLL CURSOR WITH HOLD FOR aimi100sub_prepare

   #DECLARE aimi100sub_list_cur CURSOR FOR aimi100sub_prepare   #CHI-F80014 mark      

END FUNCTION
#FUN-C90107 add end---------------

FUNCTION i100sub_refresh(p_ima01)
   DEFINE p_ima01 LIKE ima_file.ima01
   DEFINE l_ima RECORD LIKE ima_file.*
   
   SELECT * INTO l_ima.* FROM ima_file WHERE ima01=p_ima01
   RETURN l_ima.*
END FUNCTION

FUNCTION i100sub_y_chk(p_ima01)
   DEFINE p_ima01   LIKE ima_file.ima01
   DEFINE l_ima     RECORD LIKE ima_file.*
   DEFINE l_imac    RECORD LIKE imac_file.*  #TQC-C20283 add
   DEFINE l_n       LIKE type_file.num5      #MOD-C30124 add
   DEFINE l_obaacti LIKE oba_file.obaacti    #MOD-E10033 add
   LET g_success = 'Y'
   IF cl_null(p_ima01)THEN
      CALL cl_err("",-400,1)
      LET g_errno = '-400'
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_ima.* FROM ima_file WHERE ima01 = p_ima01

   IF NOT s_dc_ud_flag('1',l_ima.ima916,g_plant,'u') THEN 
      CALL cl_err(l_ima.ima916,'aoo-045',1) #參數設定:不可修改其他營運中心拋轉過來的資料
      LET g_errno = 'aoo-045'
      LET g_success = 'N'
      RETURN
   END IF

  #IF l_ima.imaacti='Y' THEN             #MOD-D90004 mark
   IF l_ima.ima1010 = '1' THEN           #MOD-D90004 add
      CALL cl_err("",9023,1) #此筆資料已確認
      LET g_errno = '9023'
      LET g_success = 'N'
      RETURN
   END IF

   IF l_ima.imaacti='N' THEN
      #此筆資料已無效, 不可異動
      CALL cl_err('','aim-153',1)
      LET g_errno = 'aim-153'
      LET g_success = 'N'
      RETURN
   END IF

   #MOD-E10033 -- add start --
   IF NOT cl_null(l_ima.ima131) THEN
      LET l_obaacti = ''
      SELECT obaacti INTO l_obaacti
        FROM oba_file
       WHERE oba01 = l_ima.ima131 
      IF l_obaacti <> 'Y' THEN
         CALL cl_err('','axm1219',1)
         LET g_errno = 'axm1219'
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #MOD-E10033 -- add end --
   
   IF NOT s_industry('slk') THEN  #FUN-C60021--ADD
#MOD-C30124 ----- add ----- begin
# 母料為特性主料時，無特性主料不能確認
   IF l_ima.ima928 = 'Y' THEN
      SELECT COUNT(*) INTO l_n FROM imac_file WHERE imac01 = p_ima01
      IF l_n = 0 THEN
         CALL cl_err('','aim1151',1)
         LET g_errno = 'aim1151'
         LET g_success = 'N'
         RETURN
      END IF
   END IF
#MOD-C30124 ----- add ----- end

   ##---- 20191024 By momo (S) 分群碼檢核
  IF g_plant = 'DC' OR g_plant = 'TY_TEST' THEN   #20211001
   IF p_ima01[1,1]='0' AND l_ima.ima08='M' THEN
      IF cl_null(l_ima.ima09) OR cl_null(l_ima.ima1007) OR cl_null(l_ima.ima10) OR
         cl_null(l_ima.ima11) OR cl_null(l_ima.ta_ima07) OR cl_null(l_ima.ta_ima06) OR
         cl_null(l_ima.imaud07) OR cl_null(l_ima.imaud08) OR cl_null(l_ima.ima131) THEN
         CALL cl_err('','aws-334',1)
         LET g_errno = 'aws-334'
         LET g_success = 'N'
         RETURN
      END IF
      IF cl_null(l_ima.ta_ima02) OR l_ima.ta_ima02='0' THEN
         CALL cl_err('','cim-007',1)
         LET g_errno = 'cim-007'
         LET g_success = 'N'
         RETURN
      END IF
   END IF

   ##---- 20220929 add (S)
   IF l_ima.ima06 = '00100' OR l_ima.ima06 = '00200' THEN
      SELECT 1 INTO l_n FROM ima_file
       WHERE ima109 = l_ima.ima109 AND ima131 = l_ima.ima131
         AND ima09 = l_ima.ima09 AND ima1007 = l_ima.ima1007
         AND ima10 = l_ima.ima10 AND ima11 = l_ima.ima11
         AND ta_ima02 = l_ima.ta_ima02 AND ta_ima07 = l_ima.ta_ima07
         AND ta_ima03 = l_ima.ta_ima03 AND ta_ima04 = l_ima.ta_ima04
         AND ta_ima05 = l_ima.ta_ima05 AND ta_ima06 = l_ima.ta_ima06
         AND ta_ima08 = l_ima.ta_ima08 AND imaud07 = l_ima.imaud07
         AND imaud08 = l_ima.imaud08
         AND ima01 LIKE '0%' AND ima1010='1'
         AND ROWNUM = 1

       IF l_n<>1 THEN
          CALL cl_getmsg('cim-010',g_lang) RETURNING g_msg  #20240906
          LET g_msg = p_ima01, g_msg                        #20240906 modify
          IF cl_confirm(g_msg) THEN               #20240906 modify
             LET g_success = 'N'
             RETURN
          END IF
       END IF
   END IF
   ##---- 20220929 add (E)
  END IF   #20211001
   ##---- 20191024 By momo (E)

   #TQC-C20283--add--begin
   IF l_ima.ima928 <> 'Y' THEN    #MOD-C30164 add
      DECLARE imac_cr CURSOR FOR
      SELECT * FROM imac_file WHERE imac01 = p_ima01 AND imac03 = '1'
      FOREACH imac_cr INTO l_imac.*
         IF cl_null(l_imac.imac02) OR cl_null(l_imac.imac04)
            OR cl_null(l_imac.imac05) THEN
            CALL cl_err('','aim1144',1)
            LET g_errno = 'aim1144'
            LET g_success = 'N'
            RETURN
         END IF
      END FOREACH
   END IF    #MOD-C30164 add
   #TQC-C20283--add--end
   END IF #FUN-C60021----ADD--

   #CALL cl_flow_notify(p_ima01,'Y')   #CHI-DB0011 add   #FUN-E50065

END FUNCTION 

FUNCTION i100sub_y_upd(p_ima01)
   DEFINE p_ima01   LIKE ima_file.ima01
   DEFINE l_ima     RECORD LIKE ima_file.*
   DEFINE l_imaag   LIKE ima_file.imaag   
   DEFINE l_sql     STRING    
   DEFINE l_ima133  LIKE ima_file.ima133 #20180612 抓最後版本料號            
   DEFINE o_ima133  LIKE ima_file.ima133 #20180818 記錄變更前預設料號      

   WHENEVER ERROR CONTINUE

   LET g_success = 'Y'   

   CALL i100sub_lock_cl()

   OPEN i100sub_cl USING p_ima01
   IF STATUS THEN
      CALL cl_err("OPEN i100sub_cl:", STATUS, 1)
      CLOSE i100sub_cl
      LET g_errno = 'aws-191' #OPEN LOCK CURSOR失敗!
      LET g_success = 'N'
      RETURN
   END IF
   FETCH i100sub_cl INTO l_ima.*                # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(p_ima01,SQLCA.sqlcode,1)     # 資料被他人LOCK
       CLOSE i100sub_cl 
       LET g_errno = '-243'                     #資料已經被鎖住, 無法讀取 !
       LET g_success = 'N'
       RETURN
   END IF
   CLOSE i100sub_cl

   ##---- 更新最後版本料號至 ima133 20180612/20180817/20180828
   SELECT MAX(ima01) INTO l_ima133 FROM ima_file 
    WHERE imaacti <> 'N' AND ima01 LIKE SUBSTR(p_ima01,1,12)||'%'
   IF l_ima133 = p_ima01 THEN
      UPDATE ima_file SET ima133=p_ima01 WHERE ima01 LIKE SUBSTR(p_ima01,1,12)||'%'
      UPDATE ima_file SET ima133=p_ima01 WHERE ima133 LIKE SUBSTR(p_ima01,1,12)||'%'  #舊預測料號等於此次變更料號時，也一併更新
      UPDATE ks.ima_file SET ima133=p_ima01 WHERE ima01 LIKE SUBSTR(p_ima01,1,12)||'%'
      UPDATE ks.ima_file SET ima133=p_ima01 WHERE ima133 LIKE SUBSTR(p_ima01,1,12)||'%'  #舊預測料號等於此次變更料號時，也一併更新
      UPDATE ty.ima_file SET ima133=p_ima01 WHERE ima01 LIKE SUBSTR(p_ima01,1,12)||'%'
      UPDATE ty.ima_file SET ima133=p_ima01 WHERE ima133 LIKE SUBSTR(p_ima01,1,12)||'%'  #舊預測料號等於此次變更料號時，也一併更新
   END IF
   ##---- 更新最後版本料號至 ima133 20180612/20180817/20180828

   UPDATE ima_file
      SET ima1010 = '1', #'1':確認
          imaacti = 'Y', #'Y':確認
          imadate = g_today  #FUN-C30315 add
         ,imamodu = g_user   #CHI-F90007 add
    WHERE ima01 = p_ima01
   IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","ima_file",l_ima.ima01,"",SQLCA.sqlcode,"",
                    "ima1010",1)  #
       LET g_errno = 'aws-190' #更新ERP料件主檔的狀況碼(ima1010)和有效碼(imaacti)不成功!
       LET g_success = 'N'    
       RETURN
   END IF
   
   SELECT imaag INTO l_imaag
     FROM ima_file
    WHERE ima01 = l_ima.ima01
   
   IF l_imaag IS NULL OR l_imaag = '@CHILD' THEN
   ELSE
      LET l_sql = " UPDATE ima_file SET ima1010 = '1',imaacti='Y', ",
                  " imadate = '",g_today, "'",     #FUN-C30315 add 
                  " ,imamodu = '", g_user, "'",    #CHI-F90007 add
                  "  WHERE ima01 LIKE '",l_ima.ima01,"_%'"
      PREPARE ima_cs3       FROM l_sql
      EXECUTE ima_cs3
      IF STATUS THEN
         CALL cl_err('ima1010',STATUS,1) 
         LET g_errno = 'aws-192' #更新料件屬性群組資料失敗!
         LET g_success = 'N'            
         RETURN
      END IF
   END IF 
   
   IF g_aza.aza90 MATCHES "[Yy]" THEN
       CALL i100sub_mes(l_ima.ima08,'insert',l_ima.ima01)
       #FUN-B20050---add---str--
       IF g_success = 'N' THEN
           LET g_errno = 'aws-557' #MES整合無法連線!
       END IF
       #FUN-B20050---add---end--
   END IF

   #-----FUN-E50065---------
   IF g_success='Y' THEN
      CALL cl_flow_notify(p_ima01,'Y')
   END IF
   #-----END FUN-E50065-----
END FUNCTION 

FUNCTION i100sub_carry(p_ima01)
   DEFINE p_ima01   LIKE ima_file.ima01
   DEFINE l_gew03   LIKE gew_file.gew03   
   DEFINE l_i       LIKE type_file.num10  
   DEFINE l_sql     STRING     
   DEFINE l_bma01   LIKE bma_file.bma01  #FUN-C50110
   DEFINE l_bma06   LIKE bma_file.bma06  #FUN-C50110
   DEFINE l_bma10   LIKE bma_file.bma10  #FUN-C50110 
   
   SELECT gev04 
     INTO g_gev04 
     FROM gev_file 
    WHERE gev01 = '1' 
      AND gev02 = g_plant
      AND gev03 = 'Y'
   IF NOT cl_null(g_gev04) THEN 
      SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
       WHERE gew01 = g_gev04 AND gew02 = '1'
      IF l_gew03 = '1' THEN #自動拋轉
        #開窗選擇拋轉的db清單
         LET l_sql = "SELECT COUNT(*) FROM &ima_file WHERE ima01='",p_ima01,"'"  
         CALL s_dc_sel_db1(g_gev04,'1',l_sql)
         IF INT_FLAG THEN
            LET INT_FLAG=0
            RETURN
         END IF
      
         CALL g_imax.clear()
         LET g_imax[1].sel = 'Y'
         LET g_imax[1].ima01 = p_ima01
      
         FOR l_i = 1 TO g_azp1.getLength()
            LET g_azp[l_i].sel   = g_azp1[l_i].sel
            LET g_azp[l_i].azp01 = g_azp1[l_i].azp01
            LET g_azp[l_i].azp02 = g_azp1[l_i].azp02
            LET g_azp[l_i].azp03 = g_azp1[l_i].azp03
         END FOR
         #FUN-C50110---begin
         IF s_industry('icd') THEN
            LET g_sql = "SELECT 'Y',imaicd00 FROM imaicd_file",
                        " WHERE imaicd11='",p_ima01 CLIPPED,"'",
                        " ORDER BY imaicd00"
            PREPARE i100_imaicd00_p FROM g_sql
            DECLARE i100_imaicd00_cs CURSOR FOR i100_imaicd00_p
       
            LET l_i = 2
            FOREACH i100_imaicd00_cs INTO g_imax[l_i].*
               LET l_i = l_i + 1
            END FOREACH
         END IF 
         #FUN-C50110---end   
         CALL s_showmsg_init()
         CALL s_aimi100_carry(g_imax,g_azp,g_gev04,'0')
         CALL s_showmsg()
         #FUN-C50110---begin
         #ICD行業別時,自動產生出來的BOM也要做資料拋轉
         IF s_industry('icd') THEN   
            LET g_sql = "SELECT DISTINCT bma01,bma06,bma10 FROM bma_file",
                        " WHERE bmaicd01='",p_ima01 CLIPPED,"'",
                        " ORDER BY bma01,bma06"
            PREPARE i100_bma_p FROM g_sql
            DECLARE i100_bma_cs CURSOR WITH HOLD FOR i100_bma_p
                  
            FOREACH i100_bma_cs INTO l_bma01,l_bma06,l_bma10  
               CALL s_abmi600_com_carry(l_bma01,l_bma06,l_bma10,g_plant,1)
            END FOREACH
         END IF
         #FUN-C50110---end 
      END IF
   END IF
END FUNCTION

FUNCTION i100sub_mes(p_key1,p_key2,p_key3)
 DEFINE p_key1   LIKE type_file.chr1
 DEFINE p_key2   LIKE type_file.chr6
 DEFINE p_key3   LIKE type_file.chr500
 DEFINE l_prog   LIKE type_file.chr7
 DEFINE l_mesg01 LIKE type_file.chr30

 LET l_prog = ''
 CASE p_key1
   WHEN 'P' LET l_prog = 'aimi100'
   WHEN 'V' LET l_prog = 'aimi100'
  #WHEN 'Z' LET l_prog = ' '        #FUN-DA0039 mark
   WHEN 'Z' RETURN                  #FUN-DA0039
   OTHERWISE LET l_prog= 'axmi121'
 END CASE

 CASE p_key2
    WHEN 'insert'  #新增
         LET l_mesg01 = 'INSERT O.K, INSERT MES O.K'
    WHEN 'update'  #修改
         LET l_mesg01 = 'UPDATE O.K, UPDATE MES O.K'
    WHEN 'delete'  #刪除
         LET l_mesg01 = 'DELETE O.K, DELETE MES O.K'
    OTHERWISE
 END CASE

# CALL aws_mescli
# 傳入參數: (1)程式代號
#           (2)功能選項：insert(新增),update(修改),delete(刪除)
#           (3)Key
 CASE aws_mescli(l_prog,p_key2,p_key3)
   #WHEN 0  #無與 MES 整合               #FUN-B60046 add #FUN-DA0039 mark
   #     MESSAGE l_mesg01                #FUN-B60046 add #FUN-DA0039 mark
   #     LET g_success = 'Y'             #FUN-B60046 add #FUN-DA0039 mark
    WHEN 1  #呼叫 MES 成功
         MESSAGE l_mesg01
         LET g_success = 'Y'
    WHEN 2  #呼叫 MES 失敗
         LET g_success = 'N'
    OTHERWISE  #其他異常                 #FUN-B60046 mark #FUN-DA0039 remark
         LET g_success = 'N'             #FUN-B60046 mark #FUN-DA0039 remark
 END CASE

END FUNCTION

#FUN-C90107 add str---
FUNCTION i100sub_x(p_ima01)
    DEFINE
        l_chr LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_n   LIKE type_file.num5     #No.FUN-690026 SMALLINT
    DEFINE l_prog   LIKE type_file.chr8    #FUN-870101 add
    DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3,   #FUN-A20044
           l_unavl_stk      LIKE type_file.num15_3,   #FUN-A20044
           l_avl_stk        LIKE type_file.num15_3    #FUN-A20044
    DEFINE p_ima01  LIKE ima_file.ima01     #FUN-C90107 add
    DEFINE l_exe_exp LIKE type_file.chr1    #FUN-C90107 add
    DEFINE l_cnt     LIKE type_file.num5    #MOD-E70080 add
    DEFINE l_cnt1    LIKE type_file.num5    #MOD-E70080 add
    DEFINE l_ima133  LIKE ima_file.ima133   #20180612 add

    LET g_errno = ''   #FUN-5A0081
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ima.ima01) THEN LET g_ima.ima01=p_ima01 END IF  #20241023
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        LET g_errno = '-400'       #FUN-C90107 add
        RETURN
    END IF

    #CHI-B70001 --- modify --- start ---
    LET l_n = 0

    SELECT COUNT(*) INTO l_n
       FROM ima_file,pmk_file,pml_file
      WHERE pmk01 = pml01 AND ima01 = pml04
       #AND pmkacti = 'Y' AND pmk25 <> '6' #MOD-E80007 mark
       #MOD-E80007 add --start--
        AND pmkacti = 'Y'          #有效
        AND pmk18 <> 'X'           #排除作廢
       #AND pmk25 NOT IN ('6','9') #排除結案、作廢  #MOD-F60012 mark
        AND pml16 NOT IN ('6','7','8','9')          #MOD-F60012 add
       #MOD-E80007 add --end--
        AND ima01 = g_ima.ima01
        AND pml20-pml21 > 0        #20180514 by momo 只抓出有餘量的請購單

    IF l_n > 0 THEN
       CALL cl_err('','aim1011',0)
       RETURN
    END IF
    #CHI-B70001 --- modify ---  end  ---
    
    IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
       CALL cl_err(g_ima.ima916,'aoo-045',1)
       LET g_errno = 'aoo-045'     #FUN-C90107 add
       RETURN
    END IF

    #MOD-A90011 add --start--
    #--->產品結構(bma_file,bmb_file)須有效BOM
    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM bma_file
     WHERE bma01 = g_ima.ima01
       AND bmaacti = 'Y'
       AND bma08 = g_plant                   #20210622

   #IF l_n > 0 THEN                          #MOD-CA0016 mark
    IF l_n > 0 AND g_ima.imaacti = 'Y' THEN  #MOD-CA0016
        CALL cl_err(g_ima.ima01,'aim-022',1)
        LET g_errno = 'aim-022'              #FUN-C90107 add
        RETURN
    END IF
    LET l_n = 0
   #MOD-B60132---modify---start---
   #SELECT COUNT(*) INTO l_n FROM bmb_file
   # WHERE bmb03 = g_ima.ima01
   #   AND (bmb04<=g_today OR bmb04 IS NULL)
   #   AND (bmb05> g_today OR bmb05 IS NULL)
    SELECT COUNT(*) INTO l_n FROM bmb_file,bma_file
     WHERE bmb03 = g_ima.ima01
       AND bma01 = bmb01 AND bma06 = bmb29
       AND (bmb04<=g_today OR bmb04 IS NULL)
       AND (bmb05> g_today OR bmb05 IS NULL)
       AND bmaacti = 'Y'
   #MOD-B60132---modify---end---
   #IF l_n > 0 THEN                          #MOD-CA0016 mark
    IF l_n > 0 AND g_ima.imaacti = 'Y' THEN  #MOD-CA0016
        CALL cl_err(g_ima.ima01,'aim-022',1)
        LET g_errno = 'aim-022'     #FUN-C90107 add
        RETURN
    END IF
    #MOD-A90011 add --end--

     #MOD-CC0187---add---S
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM bmd_file
       WHERE bmd04 = g_ima.ima01 AND bmdacti = 'Y'
         AND (bmd06 IS NULL OR bmd06 > g_today)
      IF l_n > 0 THEN
         CALL cl_err(g_ima.ima01,'aim1164',1)
         RETURN
      END IF
     #MOD-CC0187---add---S

    #----- 20180516 add by momo 檢核群組替代 (S)
    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM bob_file
     WHERE bob04 = g_ima.ima01
       AND (bob11 IS NULL OR bob11 > g_today)
    IF l_n > 0 THEN
       CALL cl_err(g_ima.ima01,'cbm-002',1)
       RETURN
    END IF

    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM boa_file
     WHERE boa03 = g_ima.ima01
       AND (boa07 IS NULL OR boa07 > g_today)
    IF l_n > 0 THEN
       CALL cl_err(g_ima.ima01,'cbm-002',1)
       RETURN
    END IF
    #----- 20180516 add by momo 檢核群組替代 (E)

    #CHI-AC0014 add --start--
    LET l_n = 0
    SELECT COUNT(DISTINCT ina01) INTO l_n
      FROM ina_file,inb_file
     WHERE inb01 = ina01
       AND inb04 = g_ima.ima01
      #AND inaconf != 'X'       #MOD-B10101 mark
       AND inaconf = 'N'        #MOD-B10101 add
    IF l_n > 0 THEN
        CALL cl_err(g_ima.ima01,'aim-026',1)
        LET g_errno = 'aim-026'     #FUN-C90107 add
        RETURN
    END IF
    #CHI-AC0014 add --end--

    IF g_prog <> 'aws_ttsrv2' THEN    #FUN-C90107 add
       BEGIN WORK
    END IF                            #FUN-C90107 add
 
    CALL i100sub_lock_cl()            #FUN-C90107 add

#   OPEN i100_cl USING g_ima.ima01    #FUN-C90107 mark
#   FETCH i100_cl INTO g_ima.*        #FUN-C90107 mark
    OPEN i100sub_cl USING g_ima.ima01 #FUN-C90107 add
    FETCH i100sub_cl INTO g_ima.*     #FUN-C90107 add
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       LET g_errno = SQLCA.sqlcode       #FUN-C90107 add
       IF g_prog <> 'aws_ttsrv2' THEN    #FUN-C90107 add
          ROLLBACK WORK   #MOD-A10083     
       END IF                            #FUN-C90107 add
      #CLOSE i100_cl      #MOD-A10083    #FUN-C90107 mark
       CLOSE i100sub_cl   #MOD-A10083    #FUN-C90107 add
       RETURN
    END IF
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   #FUN-A20044 add

#   IF g_ima.ima26  >0 THEN        #FUN-A20044
    IF l_avl_stk_mpsmrp > 0 AND g_ima.imaacti='Y' THEN   #FUN-A20044 #20210520 imaact.
       CALL cl_err('','mfg9165',0)
       LET g_errno = 'mfg9165'          #FUN-C90107 add
       IF g_prog <> 'aws_ttsrv2' THEN   #FUN-C90107 add
          ROLLBACK WORK   #MOD-A10083
       END IF                           #FUN-C90107 add
      #CLOSE i100_cl      #MOD-A10083   #FUN-C90107 mark
       CLOSE i100sub_cl   #MOD-A10083   #FUN-C90107 add
       RETURN
    END IF
#   IF g_ima.ima261 >0 THEN       #FUN-A20044
    IF l_unavl_stk > 0 THEN       #FUN-A20044
       CALL cl_err('','mfg9166',0)
       LET g_errno = 'mfg9166'           #FUN-C90107 add
       IF g_prog <> 'aws_ttsrv2' THEN    #FUN-C90107 add
          ROLLBACK WORK   #MOD-A10083
       END IF                            #FUN-C90107 add
      #CLOSE i100_cl      #MOD-A10083    #FUN-C90107 mark
       CLOSE i100sub_cl   #MOD-A10083    #FUN-C90107 add
       RETURN
    END IF
#   IF g_ima.ima262 >0 THEN       #FUN-A20044
    IF l_avl_stk > 0 AND g_ima.imaacti='Y' THEN         #FUN-A20044 #20210520 imaacti
       CALL cl_err('','mfg9167',0)
       LET g_errno = 'mfg9167'           #FUN-C90107 add
       IF g_prog <> 'aws_ttsrv2' THEN    #FUN-C90107 add
          ROLLBACK WORK   #MOD-A10083   
       END IF                            #FUN-C90107 add
      #CLOSE i100_cl      #MOD-A10083    #FUN-C90107 mark 
       CLOSE i100sub_cl   #MOD-A10083    #FUN-C90107 add 
       RETURN
    END IF

    IF g_prog <> 'aws_ttsrv2' THEN       #FUN-C90107 add
       LET l_n = 0
       SELECT COUNT(*) INTO l_n FROM sfb_file     #判斷是否有工單
              WHERE sfb05 = g_ima.ima01 AND sfb04 < '8'   #No.MOD-940165 add
                AND sfb87 != 'X'                           #No:MOD-9B0066 add
       IF cl_null(l_n) OR l_n = 0 THEN
          SELECT COUNT(*) INTO l_n FROM pmn_file,pmm_file  #判斷是否有採購單    #No:MOD-9B0066 add pmm_file
                 WHERE pmn04 = g_ima.ima01 AND pmn16 < '6'
                   AND pmn01 = pmm01 AND pmm18 != 'X'    #No:MOD-9B0066 add
          IF cl_null(l_n) OR l_n = 0 THEN
             SELECT COUNT(*) INTO l_n FROM oeb_file,oea_file   #判斷是否有訂單    #No:MOD-9B0066 add oea_file
                    WHERE oeb04 = g_ima.ima01 AND oeb70 != 'Y'
                      AND oeb01 = oea01 AND oeaconf !='X'   #No:MOD-9B0066 add
                      AND oeb12 + oeb25 - oeb24 > 0         #訂單量+銷退量-出貨量 > 0 #20180514
          END IF
       END IF

       IF NOT cl_null(l_n) AND l_n != 0 THEN
          IF NOT cl_confirm('aim-141') THEN
             ROLLBACK WORK   #MOD-A10083
             CLOSE i100sub_cl   #MOD-A10083
             RETURN
          END IF
       END IF
    END IF

    IF g_ima.imaacti='Y' THEN         #20210520
    SELECT COUNT(*) INTO l_n FROM img_file
     WHERE img01=g_ima.ima01
       AND img10 <>0
    IF l_n > 0 THEN
       LET g_errno='mfg9163'
       CALL cl_err('',g_errno,0)       #No:MOD-A10080 add
       IF g_prog <> 'aws_ttsrv2' THEN    #FUN-C90107 add
          ROLLBACK WORK   #MOD-A10083 
       END IF                            #FUN-C90107 add
      #CLOSE i100_cl      #MOD-A10083    #FUN-C90107 mark
       CLOSE i100sub_cl   #MOD-A10083    #FUN-C90107 add
       RETURN
    END IF #MOD-5B0336 add RETURN
    END IF

    #MOD-EA0048 add (begin)
    IF g_ima.imaacti = 'Y' THEN
       #FUN-E80014 --- add start ---
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt
         FROM rte_file
        WHERE rte03 = g_ima.ima01
       IF cl_null(l_cnt) OR l_cnt = 0 THEN
          IF g_ima.ima01[1,4] != 'MISC' THEN
             LET l_cnt = 1
          END IF
       END IF
       IF g_azw.azw04 = '2' AND l_cnt > 0 THEN
       #FUN-E80014 --- add end   ---
          SELECT COUNT(*) INTO l_n 
            FROM rte_file 
           WHERE rte03 = g_ima.ima01 
             AND rte07 = 'Y'

          IF l_n > 0 THEN
             LET g_errno='aim-673'
             CALL cl_err('',g_errno,0)
             ROLLBACK WORK
             CLOSE i100sub_cl
             RETURN
          END IF
       END IF   #FUN-E80014 add
    END IF
    #MOD-EA0048 add (end)

   #FUN-C90107 add str---
    LET l_exe_exp = 'N'
    IF g_prog <> 'aws_ttsrv2' THEN
       #MOD-E70080-Start-Add
       #找abmi100(工程BOM)主件及元件是否內有用到此料，如果有且生效了(bmo05!= NULL)
       #提示:工程BOM已有使用,詢問是否確認無效後再做無效
       LET l_cnt = 0
       LET l_cnt1 = 0
       SELECT COUNT(*) INTO l_cnt    #主件
         FROM bmo_file
        WHERE bmo01 = g_ima.ima01
          AND (bmo05 IS NULL OR bmo05 = ' ') 

       SELECT COUNT(*) INTO l_cnt1   #元件 
         FROM bmo_file,bmp_file
        WHERE bmo01 = bmp01
          AND bmo011 = bmp011
          AND bmo06  =bmp28
          AND bmp03 = g_ima.ima01
          AND (bmo05 IS NULL OR bmo05 = ' ') 
       IF l_cnt + l_cnt1 > 0 THEN
          IF g_ima.imaacti = 'N' THEN  #無效還原
             IF cl_confirm('lib-011') THEN  
                LET l_exe_exp = 'Y' 
             END IF   
          ELSE                         #無效
             #工程BOM已有使用,確認要無效?
             IF cl_confirm('aim1170') THEN  
                LET l_exe_exp = 'Y'   
             END IF
          END IF     
       ELSE 
       #MOD-E70080-End-Add
          IF cl_exp(0,0,g_ima.imaacti) THEN
             LET l_exe_exp = 'Y'
          END IF
       END IF    
    ELSE
       LET l_exe_exp = 'Y'
    END IF

    IF l_exe_exp = 'Y' THEN
   #FUN-C90107 add end---
   # Prog. Version..: '5.30.24-17.04.13(0,0,g_ima.imaacti) THEN    #FUN-C90107 mark
        LET g_chr=g_ima.imaacti
        LET g_chr2=g_ima.ima1010   #No.FUN-610013
        CASE g_ima.ima1010
          WHEN '0' #開立
               IF g_ima.imaacti='N' THEN
                  LET g_ima.imaacti='P'
               ELSE
                  LET g_ima.imaacti='N'
               END IF
          WHEN '1' #確認
               IF g_ima.imaacti='N' THEN
                  LET g_ima.imaacti='Y'
               ELSE
                  LET g_ima.imaacti='N'
               END IF
         END CASE
        UPDATE ima_file
            SET imaacti=g_ima.imaacti,
                imamodu=g_user, imadate=g_today
            WHERE ima01 = g_ima.ima01

        ##---- 20200907 add by momo (S) 無效時清空倉、儲
        IF g_ima.imaacti='N' THEN
           UPDATE ima_file SET ima35='',ima36='' 
            WHERE ima01 = g_ima.ima01
        END IF
        ##---- 20200907 add by momo (E)


        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","ima_file",g_ima_t.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            LET g_errno = SQLCA.sqlcode    #FUN-C90107 add
            LET g_ima.imaacti=g_chr
            LET g_ima.ima1010=g_chr2      #No.FUN-610013
            LET g_success = 'N'           #FUN-9A0056 add
            LET g_errno = SQLCA.sqlcode   #FUN-C90107 add
        END IF

       #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD  #FUN-9A0056 mark
        IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" AND g_ima.ima1010 = '1' THEN  #FUN-9A0056 add

           IF g_ima.imaacti='N' THEN
             #FUN-9A0056 mark str ------
              ## CALL aws_mescli
              ## 傳入參數: (1)程式代號
              ##           (2)功能選項：insert(新增),update(修改),delete(刪除)
              ##           (3)Key
              #LET l_prog=''
              #CASE g_ima.ima08
              #   WHEN 'P' LET l_prog = 'aimi100'
              #   WHEN 'M' LET l_prog = 'axmi121'
              #   OTHERWISE LET l_prog= ' '
              #END CASE
              #CASE aws_mescli(l_prog,'delete',g_ima.ima01)
              #   WHEN 0  #無與 MES 整合
              #        CALL cl_msg('Delete O.K')
              #   WHEN 1  #呼叫 MES 成功
              #        CALL cl_msg('Delete O.K, Delete MES O.K')
              #   WHEN 2  #呼叫 MES 失敗
              #        RETURN FALSE
              #END CASE
              #FUN-9A0056 mark end ------
              #確認資料由有效變無效,則傳送刪除MES
              #CALL i100_mes(g_ima.ima08,'delete',g_ima.ima01)   #FUN-9A0056 add #FUN-A70106 mark
               CALL i100sub_mes(g_ima.ima08,'delete',g_ima.ima01)                #FUN-A70106 add
            ELSE                                                 #FUN-9A0056 add
              #確認資料由無效變有效,則傳送新增MES
              #CALL i100_mes(g_ima.ima08,'insert',g_ima.ima01)   #FUN-9A0056 add #FUN-A70106 mark
               CALL i100sub_mes(g_ima.ima08,'insert',g_ima.ima01)                #FUN-A70106 add
           END IF
        END IF  #TQC-8B0011  ADD

        #FUN-9A0056-----start
        IF g_success = 'N' THEN
           IF g_prog <> 'aws_ttsrv2' THEN   #FUN-C90107 add
              ROLLBACK WORK
           END IF                           #FUN-C90107 add
          #CLOSE i100_cl                    #FUN-C90107 mar
           CLOSE i100sub_cl                 #FUN-C90107 add
           RETURN
        END IF
        #FUN-9A0056-------end

        DISPLAY BY NAME g_ima.ima1010     #No.FUN-610013
        DISPLAY BY NAME g_ima.imaacti
        IF g_prog <> 'aws_ttsrv2' THEN                         #FUN-C90107 add
#          CALL i100_list_fill()             #No.FUN-7C0010    #FUN-C90107 mark
           CALL i100sub_list_fill()          #No.FUN-7C0010    #FUN-C90107 add
        END IF                                                 #FUN-C90107 add
    END IF
    CLOSE i100sub_cl
    IF g_prog <> 'aws_ttsrv2' THEN                             #FUN-C90107 add
       COMMIT WORK
       ##---- 更新最後版本料號至 ima133 20180612 (S)
        SELECT MAX(ima01) INTO l_ima133 FROM ima_file
         WHERE imaacti = 'Y' AND ima01 LIKE SUBSTR(p_ima01,1,12)||'%'
        UPDATE ima_file SET ima133=l_ima133 WHERE ima01 LIKE SUBSTR(p_ima01,1,12)||'%'
        UPDATE ima_file SET ima133=l_ima133 WHERE ima133 = g_ima.ima133  #20180817
        UPDATE ty.ima_file SET ima133=l_ima133 WHERE ima01 LIKE SUBSTR(p_ima01,1,12)||'%'
        UPDATE ty.ima_file SET ima133=l_ima133 WHERE ima133 = g_ima.ima133  #20180817
       # UPDATE ks.ima_file SET ima133=l_ima133 WHERE ima01 LIKE SUBSTR(p_ima01,1,12)||'%'   #20180828
       # UPDATE ks.ima_file SET ima133=l_ima133 WHERE ima133 = g_ima.ima133                  #20180828
       ##---- 20180612 add by momo (E)
    END IF                                                     #FUN-C90107 add
END FUNCTION

FUNCTION i100sub_list_fill()
  DEFINE l_ima01         LIKE ima_file.ima01
  DEFINE l_i             LIKE type_file.num10
  
   CALL i100sub_declare_curs()  #MOD-D30241
   CALL g_ima_l.clear()
    LET l_i = 1
    #FOREACH aimi100sub_list_cur INTO l_ima01         #CHI-F80014 mark
    FOREACH aimi100sub_curs INTO l_ima01              #CHI-F80014 add 
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       #SELECT ima01,ima02,ima021,ima06,ima08,ima130,ima109,                    #180523 mark by ruby
       SELECT ima01,ima02,ima021,ima06,ima08,ima130,ima27,ima46,ima109,         #180523 add by ruby
              ima25,ima37,ima1010,imaacti,ima916
         INTO g_ima_l[l_i].*
         FROM ima_file
        WHERE ima01=l_ima01
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN   #CHI-BB0034 add
            CALL cl_err( '', 9035, 0 )
          END IF                              #CHI-BB0034 add
          EXIT FOREACH
       END IF
    END FOREACH
    OPEN aimi100sub_curs                              #CHI-F80014
    LET g_rec_b1 = l_i - 1
    DISPLAY g_rec_b1 TO FORMONLY.cnt                  #CHI-F80014
    DISPLAY ARRAY g_ima_l TO s_ima_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
END FUNCTION
#FUN-C90107 add end---
