# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: saqct110_sub.4gl
# Descriptions...: 提供saqct110.4gl使用的sub routine
# Date & Author..: No:DEV-D40021 13/04/25 By TSD.sophy 
# Memo...........: 搬移saqct110.4gl確認相關程式段至saqct110_sub.4gl
# Modify.........: No.DEV-D50009 13/05/23 By Nina 修正判斷CALL批序號變數的預設值
# Modify.........: No.DEV-D50007 13/05/30 By Nina aqct110sub_get_fac增加回傳值
# Modify.........: No.MOD-E50061 14/05/13 By Mandy 確認時加控卡,至少需有一筆單身檢驗項目,若沒有,不允許確認
# Modify.........: No.MOD-E70152 14/07/29 By Mandy 調整l_sum及l_sum1定義的大小
# Modify.........: No.MOD-EC0028 14/12/04 By Mandy "確認"時檢查若此張單據需做QC料件判定,check此張單據是否已輸入QC料件判定(aqci107)資料
# Modify.........: No.MOD-EC0133 14/12/27 By Mandy 確認時,若有批/序號明細資料,未能正確的將允收數量UPDATE 回原收貨單的rvbs_file的rvbs10
# Modify.........: No.MOD-F30045 15/03/10 By Mandy 確認時,在FUNCTION aqct110sub_y_chk() 內一筆筆檢核單身該行序記錄的缺點數和[單身不良原因]總數是否一致
# Modify.........: No.FUN-E70053 15/04/17 By Alberti 修正 MOD-EC0028，判斷檢驗合格才進判斷
# Modify.........: No:MOD-FB0069 15/11/11 By fionchen 調整CHI-C70004只要有檢驗項目已經判定驗退,則後續檢驗項目開窗輸入測量值時,不管有沒有輸入都不需控管檢驗量與測量值筆數是否相同
# Modify.........: No:MOD-FB0124 15/11/23 By fionchen 在各功能執行完COMMIT WORK後增加CALL cl_flow_notify()
# Modify.........: No:MOD-FB0139 15/11/24 By fionchen 調整MOD-EC0028,增加判斷若該單據是OQC或是倉庫檢驗(資料來源<>'Z')就不需控管是否做QC料件判定
# Modify.........: No:MOD-G40139 16/04/29 By fionchen 若為批序號管理時,特採作業,多產生一組批序號QC資料,紀錄特採數量資料 
# Modify.........: No:MOD-G60058 16/06/13 By catmoon 只有IQC才會有收貨單資料,因此其他QC作業不需執行取得收貨單位
# Modify.........: No:MOD-G80036 16/08/08 By fionchen aim-011的控卡須排除製程委外工單  
# Moidify........:               20180620 By momo 確認時回寫時間至檢驗時間欄位
# Modify.........: No:2009175229 20200922 By momo 驗退時檢核不良原因是否完整並需輸入檢驗工時

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

FUNCTION aqct110sub_lock_cl()
   DEFINE l_forupd_sql       STRING 
   
   LET l_forupd_sql = "SELECT * FROM qcs_file ",
                      " WHERE qcs01 = ? AND qcs02 = ? AND qcs05 = ? FOR UPDATE"   
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE aqct110sub_cl CURSOR FROM l_forupd_sql

END FUNCTION 

FUNCTION aqct110sub_y_chk(p_qcs01,p_qcs02,p_qcs05,p_argv1,p_argv5,p_action_choice)
   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06
   DEFINE l_rvbs09   LIKE rvbs_file.rvbs09  
   DEFINE l_n        LIKE type_file.num5    
  #DEFINE l_sum      LIKE type_file.num10   #MOD-E70152 mark
  #DEFINE l_sum1     LIKE type_file.num10   #MOD-E70152 mark
   DEFINE l_sum      LIKE qcs_file.qcs091   #MOD-E70152 add
   DEFINE l_sum1     LIKE qcs_file.qcs22    #MOD-E70152 add
   DEFINE l_cnt      LIKE type_file.num5    
   DEFINE l_ibd10    LIKE ibd_file.ibd10    
   #DEV-D40021 --add--str
   DEFINE p_qcs01    LIKE qcs_file.qcs01
   DEFINE p_qcs02    LIKE qcs_file.qcs02
   DEFINE p_qcs05    LIKE qcs_file.qcs05
   DEFINE p_argv1    LIKE type_file.chr1
   DEFINE p_argv5    STRING 
   DEFINE p_action_choice STRING
   DEFINE l_qcs      RECORD LIKE qcs_file.*
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921
   DEFINE l_ima930   LIKE ima_file.ima930
   DEFINE l_rvb05    LIKE rvb_file.rvb05
   DEFINE l_rvb36    LIKE rvb_file.rvb36
   DEFINE l_rvb37    LIKE rvb_file.rvb37
   DEFINE l_rvb38    LIKE rvb_file.rvb38
   DEFINE l_rvb90    LIKE rvb_file.rvb90
   DEFINE l_img09    LIKE img_file.img09
   DEFINE l_fac      LIKE ima_file.ima31_fac
   DEFINE l_pmn07    LIKE pmn_file.pmn07       #DEV-D50007 add  #回傳值用
   #DEV-D40021 --add--end
   DEFINE l_qct03    LIKE qct_file.qct03    #MOD-F30045 add
   DEFINE l_qct07    LIKE qct_file.qct07    #MOD-F30045 add
   DEFINE l_sum_qcu05  LIKE qcu_file.qcu05  #MOD-F30045 add
   DEFINE l_sfb93      LIKE sfb_file.sfb93  #MOD-G80036 add
   DEFINE l_rva10      LIKE rva_file.rva10  #MOD-G80036 add
   DEFINE l_rvb34      LIKE rvb_file.rvb34  #MOD-G80036 add
 
   LET g_success = 'Y'
 
   SELECT * INTO l_qcs.* FROM qcs_file
    WHERE qcs01 = p_qcs01
      AND qcs02 = p_qcs02
      AND qcs05 = p_qcs05
 
   #CHI-C30107 -------------- add -------------- begin
   IF l_qcs.qcs14 = 'Y' THEN
      CALL cl_err('',9023,1)
      LET g_success = 'N'
      RETURN
   END IF

   IF l_qcs.qcs14 = 'X' THEN
      CALL cl_err('','9024',1)
      LET g_success = 'N'
      RETURN
   END IF

   IF l_qcs.qcs22 = 0 THEN
      CALL cl_err('','aqc-027',1)
      LET g_success = 'N'
      RETURN
   END IF

   ##---- 20200922 add by momo (S) 驗退時需輸入檢驗時間
   IF l_qcs.qcs09 = '2' AND l_qcs.qcs00='1' THEN
      IF cl_null(l_qcs.qcsud12) THEN
         CALL cl_err('','cqc-005',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   ##---- 20200922 add by momo (E) 驗退時需輸入檢驗時間

   #MOD-E50061---add----str---
   #確認時加控卡,至少需有一筆單身檢驗項目,若沒有,不允許確認
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM qct_file
    WHERE qct01 =  p_qcs01  #單號
      AND qct02 =  p_qcs02  #項次
      AND qct021=  p_qcs05  #分批檢驗順序

   IF l_cnt = 0 THEN
      CALL cl_err('','aqc-131',1) #單身至少需有一筆檢驗項目才允許確認
      LET g_success = 'N'
      RETURN
   END IF
   #MOD-E50061---add----end---

   #MOD-F30045--add----str---
   #檢查單身該行序記錄的缺點數和[單身不良原因]總數是否一致
    CALL s_showmsg_init()        
    DECLARE chk_qct07_curs CURSOR FOR
    SELECT qct03,qct07 FROM qct_file 
     WHERE qct01  = p_qcs01
       AND qct02  = p_qcs02      
       AND qct021 = p_qcs05    
    FOREACH chk_qct07_curs INTO l_qct03,l_qct07
       SELECT SUM(qcu05) INTO l_sum_qcu05
         FROM qcu_file
        WHERE qcu01  = p_qcs01
          AND qcu02  = p_qcs02
          AND qcu021 = p_qcs05
          AND qcu03  = l_qct03
       IF cl_null(l_sum_qcu05) THEN LET l_sum_qcu05 = 0 END IF #20200922 
       IF l_qct07 <> l_sum_qcu05 THEN
           #此行序記錄的缺點數和[單身不良原因]總數不合!
           CALL s_errmsg("qct03",l_qct03,'','aqc-122',1)
           LET g_totsuccess = 'N'
       END IF
    END FOREACH
    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
    CALL s_showmsg()   
    IF g_success = "N" THEN
        RETURN
    END IF
   #MOD-F30045--add----end---

  #MOD-EC0028---add----str---
  #取得這張單據是否做QC料件判定
  #若需做QC料件判定,並check此張單據是否已輸入QC料件判定(aqci107)資料
  #判斷是合格時才做判定               #FUN-E70053 add
  #IF l_qcs.qcs09 = '1' THEN      #FUN-E70053 add                                           #MOD-FB0139 mark
   IF l_qcs.qcs09 = '1' AND (p_argv1 = '1' OR ( p_argv1 = '2' AND l_qcs.qcs00 = 'Z')) THEN  #MOD-FB0139 add   
      CALL aqct110sub_get_qc_check(p_qcs01,p_qcs02,p_qcs05,p_argv1) 
      IF g_success = 'N' THEN
         RETURN
      END IF
  #MOD-EC0028---add----end---
   END IF                         #FUN-E70053 add
  
   #DEV-D40019 add str--------
   #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
   IF g_aza.aza131 = 'Y' AND g_prog = 'aqct110' THEN
      #確認是否有符合條件的料件
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ima_file
       WHERE ima01 IN (SELECT qcs021 
                         FROM qcs_file 
                        WHERE qcs01 = l_qcs.qcs01
                          AND qcs02 = l_qcs.qcs02
                          AND qcs05 = l_qcs.qcs05) #料件
         AND ima930 = 'Y'                   #條碼使用否
         AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
         AND (ima932 <> 'L')                #條碼產生時機點不等於L(IQC) 

      #確認是否已有掃描紀錄
      #IF l_cnt > 0 THEN      #DEV-D40021 mark
      #確認時檢查abas010的ibd10='N'(IQC自動產生入庫單)，不控卡須有掃描紀錄
      #DEV-D40021 add str----------
      LET l_ibd10 = 'N'
      SELECT ibd10 INTO l_ibd10
        FROM ibd_file

      IF cl_null(l_ibd10) THEN LET l_ibd10 = 'N' END IF
      IF l_cnt > 0 AND l_ibd10 <> 'N' THEN
      #DEV-D40021 add str----------
         IF NOT s_chk_barcode_confirm('confirm','ibj',l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05) THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
   #DEV-D40019 add end--------

   IF p_action_choice CLIPPED = "confirm" THEN
     IF NOT cl_confirm('axm-108') THEN
        LET g_success='N'
        RETURN
     END IF
   END IF  
   #CHI-C30107 -------------- add -------------- end
   
   IF l_qcs.qcs14 = 'Y' THEN
      CALL cl_err('',9023,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF l_qcs.qcs14 = 'X' THEN
      CALL cl_err('','9024',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF l_qcs.qcs22 = 0 THEN
     CALL cl_err('','aqc-027',1)
     LET g_success = 'N'
     RETURN
   END IF

   #TQC-B60106   ---start   Add
   SELECT COUNT(*) INTO l_n FROM gen_file 
    WHERE gen01 = l_qcs.qcs13
   IF l_n < 1 THEN
      CALL cl_err('','aqc-120',1)
      LET g_success = 'N'
      RETURN
   END IF
   #TQC-B60106   ---end     Add
 
   CALL aqct110sub_unqc_qty(l_qcs.*) 
   IF NOT cl_null(g_errno) THEN
      CALL cl_err(l_qcs.qcs01,g_errno,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF l_qcs.qcs00 MATCHES '[156ABCDH]' THEN

      #MOD-G80036 add start ----------
      LET l_sfb93 = 'N'
      SELECT rva10,rvb34 INTO l_rva10,l_rvb34 FROM rva_file,rvb_file WHERE rva01 = rvb01 AND rva01 = l_qcs.qcs01 AND rvb02 = l_qcs.qcs02
      IF l_rva10 = 'SUB' THEN
         SELECT sfb93 INTO l_sfb93
           FROM sfb_file
          WHERE sfb01 = l_rvb34
      END IF

      #排除製程中委外工單
      IF l_sfb93 = 'N' THEN  
      #MOD-G80036 add end   ----------

         #DEV-D40021 add str-----
         LET l_ima918 = ''
         LET l_ima921 = ''
         LET l_ima930 = ''
         #DEV-D40021 add str-----

         SELECT ima918,ima921,ima930 INTO l_ima918,l_ima921,l_ima930   #DEV-D40021 add ima930 
           FROM ima_file
          WHERE ima01 = l_qcs.qcs021
            AND imaacti = "Y"
      
         #DEV-D50009 add str--------
         IF cl_null(l_ima918) THEN LET l_ima918 = 'N' END IF   
         IF cl_null(l_ima921) THEN LET l_ima921 = 'N' END IF
         IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF
         #DEV-D50009 add end--------

         #IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         IF (l_ima918 = "Y" OR l_ima921 = "Y") AND l_ima930 = 'N' THEN   #DEV-D40021 add
            #IF g_sma.sma90 = "Y" THEN   #CHI-A70047
            IF (g_sma.sma90 = "Y" AND p_argv1='1') OR p_argv1<>'1' THEN   #CHI-A70047 
               SELECT SUM(rvbs06) INTO l_rvbs06
                 FROM rvbs_file
                WHERE rvbs00 = g_prog
                  AND rvbs01 = l_qcs.qcs01
                  AND rvbs02 = l_qcs.qcs02
                  AND rvbs13 = l_qcs.qcs05
                  AND rvbs09 = 1
            
               IF cl_null(l_rvbs06) THEN
                  LET l_rvbs06 = 0
               END IF
            
               CALL aqct110sub_get_fac(p_argv1,l_qcs.*) 
                    RETURNING l_rvb36,l_rvb37,l_rvb38,l_pmn07,l_img09,l_fac    #DEV-D50007 add
  
               IF l_qcs.qcs09 != '2' THEN        #MOD-BA0194 add 
                  IF (p_argv1 = '1') AND (l_qcs.qcs00 = '1') THEN #MOD-G60058 add
                     #CHI-C30064---Start---add
                     SELECT rvb05,rvb36,rvb37,rvb38,rvb90 
                       INTO l_rvb05,l_rvb36,l_rvb37,l_rvb38,l_rvb90
                       FROM rvb_file
                      WHERE rvb01 = l_qcs.qcs01
                        AND rvb02 = l_qcs.qcs02
                     SELECT img09 INTO l_img09
                       FROM img_file   #庫存單位
                      WHERE img01=l_rvb05 AND img02=l_rvb36
                        AND img03=l_rvb37 AND img04=l_rvb38
                     CALL s_umfchk(l_rvb05,l_rvb90,l_img09) RETURNING l_cnt,l_fac
                     IF l_cnt = '1' THEN LET l_fac = 1 END IF             
                     #CHI-C30064---End---add 
                  END IF         #MOD-G60058 add
                  IF (l_qcs.qcs091 * l_fac) <> l_rvbs06 THEN   #CHI-A70047   取消mark
                  #IF (l_qcs.qcs22 * l_fac) <> l_rvbs06 THEN   #CHI-A70047   mark
                     LET g_success = "N"
                     CALL cl_err(l_qcs.qcs021,"aim-011",1)
                     RETURN
                  END IF
               END IF             #MOD-BA0194 add
            END IF
         END IF
      END IF      #MOD-G80036 add
   END IF
 
   IF l_qcs.qcs00 MATCHES '[A]' THEN 
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ina_file,inb_file
        WHERE inb01 = l_qcs.qcs01
          AND inb03 = l_qcs.qcs02
          AND inb01 = ina01
          AND inapost = 'Y'
          AND ina00 MATCHES '[12]'
       IF l_cnt > 0 THEN 
          CALL cl_err(l_qcs.qcs01,'aqc-333',1)
          LET g_success = 'N'
          RETURN
       END IF
   END IF
 
   IF l_qcs.qcs00 MATCHES '[B]' THEN 
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ina_file,inb_file
        WHERE inb01 = l_qcs.qcs01
          AND inb03 = l_qcs.qcs02
          AND inb01 = ina01
          AND inapost = 'Y'
          AND ina00 IN ('3','4')
       IF l_cnt > 0 THEN 
          CALL cl_err(l_qcs.qcs01,'aqc-333',1)
          LET g_success = 'N'
          RETURN
       END IF
   END IF
   
   #FUN-BC0104----add----str----
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM qco_file
    WHERE qco01 = l_qcs.qcs01
      AND qco02 = l_qcs.qcs02
      AND qco05 = l_qcs.qcs05
   IF l_n > 0 THEN 
      IF l_qcs.qcs09 ='1' THEN       #MOD-C30557
         SELECT SUM(qco11*qco19) INTO l_sum 
           FROM qco_file,qcl_file
          WHERE qcl01 = qco03
            AND qco01 = l_qcs.qcs01
            AND qco02 = l_qcs.qcs02
            AND qco05 = l_qcs.qcs05
           #AND qcl05 <> '3'         #FUN-CC0013 mark
         IF l_sum != l_qcs.qcs091 THEN
            CALL cl_err(l_qcs.qcs01,'aqc-520',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF                         #MOD-C30557
      #TQC-C20504----Begin----
      SELECT SUM(qco11*qco19) INTO l_sum1
        FROM qco_file
       WHERE qco01 = l_qcs.qcs01
         AND qco02 = l_qcs.qcs02
         AND qco05 = l_qcs.qcs05
      IF l_sum1 != l_qcs.qcs22 THEN 
         CALL cl_err(l_qcs.qcs01,'aqc-536',1)
         LET g_success ='N'
         RETURN
      END IF
      #TQC-C20504-----End-----
   END IF 
   #FUN-BC0104----add----end----

   #DEV-D40019 mark str--------
   ##DEV-D40015 add str--------
   ##若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
   # IF g_aza.aza131 = 'Y' AND g_prog = 'aqct110' THEN
   #   #確認是否有符合條件的料件
   #    LET l_cnt = 0
   #    SELECT COUNT(*) INTO l_cnt
   #      FROM ima_file
   #     WHERE ima01 IN (SELECT qct021 
   #                       FROM qct_file 
   #                      WHERE qct01 = l_qcs.qcs01
   #                        AND qct02 = l_qcs.qcs02
   #                        AND qct021 = l_qcs.qcs05) #料件
   #       AND ima930 = 'Y'                   #條碼使用否
   #       AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
   #       AND (ima932 <> 'L')                #條碼產生時機點不等於L(IQC) 
   # 
   #   #確認是否已有掃描紀錄
   #    IF l_cnt > 0 THEN
   #       IF NOT s_chk_barcode_confirm('confirm','ibj',l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05) THEN
   #          LET g_success = 'N'
   #          RETURN
   #       END IF
   #    END IF
   # END IF
   ##DEV-D40015 add end--------
   #DEV-D40019 mark end--------
END FUNCTION
 
FUNCTION aqct110sub_y_upd(p_qcs01,p_qcs02,p_qcs05,p_argv1,p_argv5,p_action_choice)
   DEFINE l_rvb331  LIKE rvb_file.rvb331
   DEFINE l_rvb332  LIKE rvb_file.rvb332
   DEFINE l_flag    LIKE type_file.num5         #No.FUN-680104 SMALLINT
   DEFINE l_factor  LIKE qcs_file.qcs31
   DEFINE l_ima906  LIKE ima_file.ima906
   DEFINE l_rvb33   LIKE rvb_file.rvb33
   DEFINE l_rvb07   LIKE rvb_file.rvb07
   DEFINE l_rvb30   LIKE rvb_file.rvb30  #MOD-640512
   DEFINE l_rvbs    RECORD LIKE rvbs_file.*  #No.FUN-850100
   DEFINE l_rvbs10  LIKE rvbs_file.rvbs10  #No.FUN-850100
   DEFINE l_sql     STRING   #No.FUN-850100
   DEFINE l_rvbs09   LIKE rvbs_file.rvbs09   #No.FUN-860045
   DEFINE l_qcs091   LIKE qcs_file.qcs091    #FUN-870040
   DEFINE l_qcs38    LIKE qcs_file.qcs38     #FUN-870040
   DEFINE l_qcs41    LIKE qcs_file.qcs41     #FUN-870040
   DEFINE l_qct03    LIKE qct_file.qct03     #MOD-AB0143 add
   DEFINE l_qct04    LIKE qct_file.qct04     #MOD-AB0143 add
   DEFINE l_qct11    LIKE qct_file.qct11     #MOD-AB0143 add
   DEFINE l_qcd07    LIKE qcd_file.qcd07     #MOD-AB0143 add
   DEFINE l_cnt      LIKE type_file.num5     #MOD-AB0143 add
   DEFINE l_rvb90    LIKE rvb_file.rvb90     #FUN-BB0085 add
   #No.TQC-B90119  --Begin
   DEFINE l_qcd05    LIKE qcd_file.qcd05
   DEFINE l_qcd061   LIKE qcd_file.qcd061
   DEFINE l_qcd062   LIKE qcd_file.qcd062
   #No.TQC-B90119  --End
   DEFINE l_rowcount LIKE type_file.num5    #CHI-C70004 add
   DEFINE l_qcs09    LIKE qcs_file.qcs09    #CHI-C70004 add
   #DEV-D40021 --add--str
   DEFINE p_qcs01    LIKE qcs_file.qcs01
   DEFINE p_qcs02    LIKE qcs_file.qcs02
   DEFINE p_qcs05    LIKE qcs_file.qcs05
   DEFINE p_argv1    LIKE type_file.chr1
   DEFINE p_argv5    STRING
   DEFINE p_action_choice STRING
   DEFINE l_qcs      RECORD LIKE qcs_file.*
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921
   DEFINE l_ima930   LIKE ima_file.ima930
   DEFINE l_msg      LIKE type_file.chr1000
   DEFINE l_des1     LIKE ze_file.ze03
   #DEV-D40021 --add--end
 
   SELECT * INTO l_qcs.* FROM qcs_file
    WHERE qcs01 = p_qcs01
      AND qcs02 = p_qcs02
      AND qcs05 = p_qcs05
   
   #若設定與 SPC 整合, 判斷是否已拋轉
   IF g_aza.aza64 NOT matches '[ Nn]' AND 
     ((l_qcs.qcsspc IS NULL ) OR l_qcs.qcsspc NOT matches '[1]'  )
   THEN
     CALL cl_err('','aqc-117',1)
     LET g_success='N'
     RETURN
   END IF
 
   #No.TQC-BB0119  --Begin
   IF g_qcz.qcz01 = 'Y' THEN       #MOD-B20052 add
      ##MOD-AB0143---add---start---
      # LET l_cnt = 0
      # SELECT COUNT(*) INTO l_cnt FROM qcd_file WHERE qcd01 = l_qcs.qcs021
      # IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      ##IF l_cnt > 0 AND g_qcz.qcz01 THEN             #MOD-B20052 mark
      # IF l_cnt > 0 AND g_qcz.qcz01 = 'Y' THEN       #MOD-B20052 add
       DECLARE qct03_curs CURSOR FOR 
         SELECT qct03,qct04,qct11 FROM qct_file WHERE qct01 = l_qcs.qcs01
                                                  AND qct02 = l_qcs.qcs02      #MOD-B20010 add 
                                                  AND qct021 = l_qcs.qcs05     #MOD-B20010 add   
       FOREACH qct03_curs INTO l_qct03,l_qct04,l_qct11
           CALL aqct110sub_get_qcd07(l_qct04,p_argv1,l_qcs.*) RETURNING l_qcd07,l_qcd05,l_qcd061,l_qcd062
           #SELECT qcd07 INTO l_qcd07 FROM qcd_file WHERE qcd01 = l_qcs.qcs021 AND qcd02 = l_qct04
           IF l_qcd07 = 'Y' THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM qctt_file
               WHERE qctt01 = l_qcs.qcs01
                 AND qctt02 = l_qcs.qcs02
                 AND qctt021 = l_qcs.qcs05
                 AND qctt03 = l_qct03 
              IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
              #CHI-C70004 str add-----
              SELECT qcs09 INTO l_qcs09 FROM qcs_file
               WHERE qcs01 = l_qcs.qcs01
                 AND qcs02 = l_qcs.qcs02
                 AND qcs05 = l_qcs.qcs05
              #CHI-C70004 end add-----
             #IF l_cnt != l_qct11 AND NOT (l_qcs09 =2 AND l_cnt=0) THEN          #CHI-C70004 add NOT (l_qcs09 =2 AND l_cnt=0)   #MOD-FB0069 mark
              IF l_cnt != l_qct11 AND l_qcs09 != 2 THEN                          #MOD-FB0069 add 
                 LET l_msg = l_qct04,':',l_cnt,': ',l_qct11
                 CALL cl_err(l_msg,'aqc-038',1)
                 LET g_success = 'N'
                 RETURN
              END IF
           END IF
       END FOREACH
   END IF
   #MOD-AB0143---add---end---
   #No.TQC-BB0119  --End

   #DEV-D40015 add str-------------
   #自動產生barcode
   IF g_success = 'Y' AND g_aza.aza131 = 'Y' THEN
      CALL aqct110sub_barcode_gen(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,'N')
   END IF
   #DEV-D40015 add end-------------

 
   IF (p_argv5 <> "SPC_ins" AND p_argv5 <> "SPC_upd") OR p_argv5 IS NULL THEN
      BEGIN WORK
   END IF
 
   CALL aqct110sub_lock_cl()
    
   OPEN aqct110sub_cl USING l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05    #liuxqa 091022
   IF STATUS THEN
      CALL cl_err("OPEN aqct110sub_cl:", STATUS, 1)
      LET g_success='N'
      CLOSE aqct110sub_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH aqct110sub_cl INTO l_qcs.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_qcs.qcs01,SQLCA.sqlcode,1)      # 資料被他人LOCK
      LET g_success='N'
      CLOSE aqct110sub_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   #CHI-C30107 ---------------- mark --------------- begin
   #IF p_action_choice CLIPPED = "confirm" THEN
   #  IF NOT cl_confirm('axm-108') THEN
   #     LET g_success='N'
   #     ROLLBACK WORK   #No.MOD-850116
   #     RETURN
   #  END IF
   #END IF
   #CHI-C30107 ---------------- mark --------------- end
   LET l_qcs.qcs041 = TIME                   #20180620
   UPDATE qcs_file SET qcs14 = 'Y',
                       qcs15 = g_today,
                       qcs041 = l_qcs.qcs041  #20180620
    WHERE qcs01 = l_qcs.qcs01
      AND qcs02 = l_qcs.qcs02
      AND qcs05 = l_qcs.qcs05
 
   IF SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
   END IF

   IF l_qcs.qcs09 = '2' OR l_qcs.qcs09 = '3' THEN      #MOD-C30557    #FUN-CC0015 add qcs09=3
      CALL aqct110sub_qc(l_qcs.*)                                   #MOD-C30557
   END IF                                              #MOD-C30557
 
   IF (l_qcs.qcs00='7') AND (g_success='Y') THEN
      CALL aqct110sub_upd_srg10("+",l_qcs.*)
   END IF
   IF g_qcz.qcz12 = 'Y' THEN
      CALL aqct110sub_check_pmh09(p_action_choice,l_qcs.*)
   END IF
 
   #------ 是否與採購勾稽(modi in 01/06/04) ------
   #IF g_sma.sma886[8,8] = 'Y' AND l_qcs.qcs00 = '1' THEN    #20221026 mark
   IF g_sma.sma886[8,8] = 'Y'  THEN                          #20221026 modify
      UPDATE rvb_file SET rvb40 = l_qcs.qcs04   #No.MOD-590083 
       WHERE rvb01 = l_qcs.qcs01
         AND rvb02 = l_qcs.qcs02
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvb_file",l_qcs.qcs01,l_qcs.qcs02,STATUS,"","upd rvb40",1)  #No.FUN-660115
         LET g_success = 'N'
      END IF

      ##--- 20221026 add by momo (S) 只要有驗退 就是驗退
      IF l_qcs.qcs00 = '2' THEN
         SELECT '2',qcs091 INTO l_qcs.qcs09,l_qcs.qcs091
          FROM qcs_file
         WHERE qcs01 = l_qcs.qcs01 AND qcs02 = l_qcs.qcs02
           AND qcs09 = '2'
           AND ROWNUM = 1
      END IF
      ##--- 20221026 add by momo (E)
 
      CASE l_qcs.qcs09
         WHEN '1'
            CALL cl_getmsg('aqc-004',g_lang) RETURNING l_des1
         WHEN '2'
            CALL cl_getmsg('apm-244',g_lang) RETURNING l_des1        #No:7706
         WHEN '3'
            CALL cl_getmsg('aqc-006',g_lang) RETURNING l_des1
      END CASE
 
      UPDATE rvb_file SET rvb41 = l_des1 #檢驗結果
       WHERE rvb01 = l_qcs.qcs01
         AND rvb02 = l_qcs.qcs02
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvb_file",l_qcs.qcs01,l_qcs.qcs02,STATUS,"","upd rvb41",1)  #No.FUN-660115
         LET g_success='N'
      END IF
 
      SELECT rvb33,rvb07,rvb331,rvb332 ,rvb30              #FUN-5C0022 add rvb331  ,rvb332    #MOD-640512 add rvb30
          INTO l_rvb33,l_rvb07,l_rvb331,l_rvb332,l_rvb30   #FUN-5C0022 add rvb331  ,rvb332   #MOD-640512 add rvb30
        FROM rvb_file
       WHERE rvb01 = l_qcs.qcs01
         AND rvb02 = l_qcs.qcs02
 
      IF cl_null(l_rvb33) OR l_rvb33 < 0 THEN   #20221026 負值
         LET l_rvb33 = 0
      END IF
 
      IF cl_null(l_rvb331) THEN  #FUN-5C0022 add
         LET l_rvb331 = 0
      END IF
 
      IF cl_null(l_rvb332) THEN  #FUN-5C0022 add
         LET l_rvb332 = 0
      END IF
 
      IF cl_null(l_rvb07) THEN
         LET l_rvb07 = 0
      END IF
 
      LET l_rvb33 = l_rvb33 + l_qcs.qcs091
      IF g_sma.sma115 = 'Y' THEN #使用雙單位
         LET l_rvb331 = l_rvb331 + l_qcs.qcs38
         LET l_rvb332 = l_rvb332 + l_qcs.qcs41
      ELSE
         LET l_rvb331 = l_rvb331 + 0
         LET l_rvb332 = l_rvb332 + 0
      END IF
 
      #FUN-BB0085-add-str---
      SELECT rvb90 INTO l_rvb90 FROM rvb_file
       WHERE rvb01 = l_qcs.qcs01
         AND rvb02 = l_qcs.qcs02
      LET l_rvb33 = s_digqty(l_rvb33,l_rvb90)   
      #FUN-BB0085-add-end---
      UPDATE rvb_file SET rvb33 = l_rvb33,
             rvb331 = l_rvb331, #FUN-5C0022 add
             rvb332 = l_rvb332, #FUN-5C0022 add
             rvb31 = l_rvb33 - l_rvb30   #MOD-640512
       WHERE rvb01 = l_qcs.qcs01
         AND rvb02 = l_qcs.qcs02
 
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvb_file",l_qcs.qcs01,l_qcs.qcs02,STATUS,"","upd rvb33",1)  #No.FUN-660115
         LET g_success='N'
      END IF
   END IF
 
   IF l_qcs.qcs00 MATCHES '[156ABCDH]' THEN
      IF l_qcs.qcs00 MATCHES '[1BC]' THEN
         LET l_rvbs09 = 1  
      ELSE
         LET l_rvbs09 = -1  
      END IF

      #DEV-D40021 add str-----
      LET l_ima918 = ''
      LET l_ima921 = ''
      LET l_ima930 = ''
      #DEV-D40021 add end-----

      SELECT ima918,ima921,ima930 INTO l_ima918,l_ima921,l_ima930  #DEV-D40021 add ima930 
        FROM ima_file
       WHERE ima01 = l_qcs.qcs021
         AND imaacti = "Y"

     #DEV-D50009 add str--------
      IF cl_null(l_ima918) THEN LET l_ima918 = 'N' END IF   
      IF cl_null(l_ima921) THEN LET l_ima921 = 'N' END IF
      IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF
     #DEV-D50009 add end--------
      
     #IF l_ima918 = "Y" OR l_ima921 = "Y" THEN                         #DEV-D40021 mark
      IF (l_ima918 = "Y" OR l_ima921 = "Y") AND l_ima930 = 'N' THEN    #DEV-D40021 add
         #IF g_sma.sma90 = "Y" THEN   #CHI-A70047
         IF (g_sma.sma90 = "Y" AND p_argv1='1') OR p_argv1<>'1' THEN   #CHI-A70047 
                      
            LET l_sql = "SELECT * FROM rvbs_file",
                        " WHERE rvbs01 = '",l_qcs.qcs01,"'",
                        "   AND rvbs02 = ",l_qcs.qcs02,
                        "   AND rvbs13 = 0 ",   #No.FUN-860045
                        "   AND rvbs00 != '",g_prog,"'",
                        "   AND rvbs09 = ",l_rvbs09
            
            PREPARE aqct110sub_rvbssel FROM l_sql
            
            DECLARE rvbs_curssel CURSOR FOR aqct110sub_rvbssel
            
            FOREACH rvbs_curssel INTO l_rvbs.*
               IF STATUS THEN
                  CALL cl_err('foreach rvbs sel:',STATUS,1)
                  EXIT FOREACH
               END IF
            
              #SELECT SUM(rvbs10)   #MOD-EC0133 mark
               SELECT SUM(rvbs06)   #MOD-EC0133 add
                 INTO l_rvbs10
                 FROM qcs_file,rvbs_file 
                WHERE qcs01 = l_qcs.qcs01
                  AND qcs02 = l_qcs.qcs02
                  AND qcs01 = rvbs01
                  AND qcs02 = rvbs02
                  AND rvbs03 = l_rvbs.rvbs03
                  AND rvbs04 = l_rvbs.rvbs04
                  AND rvbs08 = l_rvbs.rvbs08
                  AND rvbs00 = g_prog
                  AND rvbs13 = qcs05                        #No.MOD-950114 add
                  AND qcs14 = 'Y'
               
               UPDATE rvbs_file SET rvbs10 = l_rvbs10
                WHERE rvbs01 = l_qcs.qcs01
                  AND rvbs02 = l_qcs.qcs02
                  AND rvbs03 = l_rvbs.rvbs03
                  AND rvbs04 = l_rvbs.rvbs04
                  AND rvbs08 = l_rvbs.rvbs08
                  AND rvbs13 = 0   #No.FUN-860045
               
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","rvbs_file",l_qcs.qcs01,l_qcs.qcs01,STATUS,"","upd rvbs10",1) 
                  LET g_success = 'N'
               END IF
               #-----CHI-A70047---------
               IF l_qcs.qcs00 = 'A' OR  
                  l_qcs.qcs00 = 'B' THEN
                  UPDATE rvbs_file SET rvbs06 = l_rvbs10
                   WHERE rvbs01 = l_qcs.qcs01
                     AND rvbs02 = l_qcs.qcs02
                     AND rvbs03 = l_rvbs.rvbs03
                     AND rvbs04 = l_rvbs.rvbs04
                     AND rvbs08 = l_rvbs.rvbs08
                     AND rvbs13 = 0   #No:FUN-860045
                  
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rvbs_file",l_qcs.qcs01,l_qcs.qcs01,STATUS,"","upd rvbs10",1) 
                     LET g_success = 'N'
                  END IF
               END IF
               #-----END CHI-A70047-----
            END FOREACH
         END IF
      END IF
   END IF
 
   IF l_qcs.qcs00 = 'A' OR  
      l_qcs.qcs00 = 'B' THEN
      SELECT SUM(qcs091),SUM(qcs38),SUM(qcs41)
        INTO l_qcs091,l_qcs38,l_qcs41
        FROM qcs_file
       WHERE qcs01 = l_qcs.qcs01
         AND qcs02 = l_qcs.qcs02
         AND (qcs09='1' OR qcs09='3')
         AND qcs14 = 'Y'   #No.MOD-970026
      IF cl_null(l_qcs091) THEN LET l_qcs091=0 END IF
      IF cl_null(l_qcs38 ) THEN LET l_qcs38 =0 END IF
      IF cl_null(l_qcs41 ) THEN LET l_qcs41 =0 END IF
      UPDATE inb_file 
         SET inb09 = l_qcs091,
             inb904= l_qcs38 ,
             inb907= l_qcs41 
       WHERE inb01 = l_qcs.qcs01
         AND inb03 = l_qcs.qcs02
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","inb_file",l_qcs.qcs01,l_qcs.qcs02,STATUS,"","upd inb09",1)
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      LET l_qcs.qcs14 = 'Y'
      LET l_qcs.qcs15 = g_today
      IF (p_argv5 <> "SPC_ins" AND p_argv5 <> "SPC_upd")      #FUN-680011
      OR p_argv5 IS NULL 
      THEN
         COMMIT WORK
         CALL cl_flow_notify(l_qcs.qcs01,'Y') #MOD-FB0124 add
      END IF
      #DISPLAY BY NAME l_qcs.qcs14,l_qcs.qcs15     #DEV-D40021 --mark
      #CALL t110_qc_item_show()      #MOD-C30557   #DEV-D40021 --mark
   ELSE
      LET g_success='N'
      ROLLBACK WORK
   END IF

   #DEV-D40015 add str-------------
   #失敗自動作廢barcode
   IF g_success = 'N' AND g_aza.aza131 = 'Y' THEN
      CALL aqct110sub_barcode_z(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,FALSE)
   END IF
   #DEV-D40015 add end-------------

  #DEV-D40015 mark str------
  ##DEV-D30045--add--begin
  ##自動產生barcode
  #IF g_success='Y' AND g_aza.aza131 = 'Y' THEN
  #   CALL aqct110sub_barcode_gen(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,'N')
  #END IF
  ##DEV-D30045--add--end
  #DEV-D40015 mark end------

END FUNCTION

#取得尚未送驗的數量
FUNCTION aqct110sub_unqc_qty(l_qcs)
   DEFINE l_unqc_qty    LIKE rvb_file.rvb07
   DEFINE l_rvb07       LIKE rvb_file.rvb07
   DEFINE l_qcs22       LIKE qcs_file.qcs22
   DEFINE l_inb09       LIKE inb_file.inb09,
          l_imn10       LIKE imn_file.imn10,
          l_imp04       LIKE imp_file.imp04,
          l_imq07       LIKE imq_file.imq07,
          l_qsa06       LIKE qsa_file.qsa06,
          l_ohb12       LIKE ohb_file.ohb12
   #DEV-D40021 --add--str
   DEFINE l_qcs         RECORD LIKE qcs_file.*
   #DEV-D40021 --add--end
 
   LET g_errno = ''
   IF l_qcs.qcs00='1' THEN
      SELECT rvb07 
        INTO l_rvb07 
        FROM rvb_file
       WHERE rvb01=l_qcs.qcs01 
         AND rvb02=l_qcs.qcs02
      IF cl_null(l_rvb07) THEN LET l_rvb07 = 0 END IF
      IF cl_null(l_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = '1'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs05 !=l_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = '1'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
      LET l_unqc_qty = l_rvb07-l_qcs22
      IF l_unqc_qty <= 0 THEN
         #此料已全部送驗!  
         #此收貨單+項次送驗資料皆已登打,請重新輸入!
         LET g_errno = 'aqc-114'
      END IF
   END IF
 
   IF l_qcs.qcs00='A' THEN
      SELECT inb16 #FUN-870040 
        INTO l_inb09 
        FROM inb_file
       WHERE inb01=l_qcs.qcs01 
         AND inb03=l_qcs.qcs02
      IF cl_null(l_inb09) THEN LET l_inb09 = 0 END IF
      IF cl_null(l_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'A'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs05 !=l_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'A'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_inb09-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF l_qcs.qcs00='B' THEN
      SELECT inb16  #FUN-870040
        INTO l_inb09 
        FROM inb_file
       WHERE inb01=l_qcs.qcs01 
         AND inb03=l_qcs.qcs02
      IF cl_null(l_inb09) THEN LET l_inb09 = 0 END IF
      IF cl_null(l_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'B'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs05 !=l_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'B'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_inb09-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF l_qcs.qcs00='C' THEN
      SELECT imn10 
        INTO l_imn10 
        FROM imn_file
       WHERE imn01=l_qcs.qcs01 
         AND imn02=l_qcs.qcs02
      IF cl_null(l_imn10) THEN LET l_imn10 = 0 END IF
      IF cl_null(l_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'C'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs05 !=l_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'C'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_imn10-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF l_qcs.qcs00='D' THEN
      SELECT imn10 
        INTO l_imn10 
        FROM imn_file
       WHERE imn01=l_qcs.qcs01 
         AND imn02=l_qcs.qcs02
      IF cl_null(l_imn10) THEN LET l_imn10 = 0 END IF
      IF cl_null(l_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'D'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs05 !=l_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'D'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_imn10-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF l_qcs.qcs00='E' THEN
      SELECT imp04 
        INTO l_imp04 
        FROM imp_file
       WHERE imp01=l_qcs.qcs01 
         AND imp02=l_qcs.qcs02
      IF cl_null(l_imp04) THEN LET l_imp04 = 0 END IF
      IF cl_null(l_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'E'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs05 !=l_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'E'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_imp04-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF l_qcs.qcs00='F' THEN
      SELECT imq07 
        INTO l_imq07 
        FROM imq_file
       WHERE imq01=l_qcs.qcs01 
         AND imq02=l_qcs.qcs02
      IF cl_null(l_imq07) THEN LET l_imq07 = 0 END IF
      IF cl_null(l_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'F'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs05 !=l_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'F'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_imq07-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF l_qcs.qcs00='G' THEN
      SELECT qsa06 
        INTO l_qsa06 
        FROM qsa_file
       WHERE qsa01=l_qcs.qcs01 
      IF cl_null(l_qsa06) THEN LET l_qsa06 = 0 END IF
      IF cl_null(l_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'G'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs05 !=l_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'G'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_qsa06-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
 
   IF l_qcs.qcs00='H' THEN
      SELECT ohb12 
        INTO l_ohb12 
        FROM ohb_file
       WHERE ohb01=l_qcs.qcs01 
         AND ohb03=l_qcs.qcs02
      IF cl_null(l_ohb12) THEN LET l_ohb12 = 0 END IF
      IF cl_null(l_qcs.qcs05) THEN
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs14 !='X' 
             AND qcs00 = 'H'
      ELSE
          SELECT SUM(qcs22) 
            INTO l_qcs22 FROM qcs_file
           WHERE qcs01 =l_qcs.qcs01 
             AND qcs02 =l_qcs.qcs02
             AND qcs05 !=l_qcs.qcs05 
             AND qcs14 !='X' 
             AND qcs00 = 'H'
      END IF
      IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF
 
       LET l_unqc_qty = l_ohb12-l_qcs22
       IF l_unqc_qty <= 0 THEN
           #此料已全部送驗!  
           #此收貨單+項次送驗資料皆已登打,請重新輸入!
           LET g_errno = 'aqc-114'
       END IF
   END IF
   IF NOT cl_null(l_qcs.qcs22) THEN
      IF l_qcs.qcs22 > l_unqc_qty THEN
         #本次檢驗量>剩余檢驗量
         LET g_errno = 'aqc-037'
      END IF
   END IF
 
END FUNCTION

FUNCTION aqct110sub_get_fac(p_argv1,l_qcs)
   #DEV-D40021 --add--str
   DEFINE p_argv1     LIKE type_file.chr1
   DEFINE l_qcs       RECORD LIKE qcs_file.*
   DEFINE l_rvb05     LIKE rvb_file.rvb05
   DEFINE l_rvb36     LIKE rvb_file.rvb36
   DEFINE l_rvb37     LIKE rvb_file.rvb37
   DEFINE l_rvb38     LIKE rvb_file.rvb38
   DEFINE l_pmn07     LIKE pmn_file.pmn07
   DEFINE l_img09     LIKE img_file.img09
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_fac       LIKE ima_file.ima31_fac
   #DEV-D40021 --add--end
 
   IF (p_argv1 = '1') AND (l_qcs.qcs00 = '1') THEN
      SELECT rvb05,rvb36,rvb37,rvb38,pmn07 
        INTO l_rvb05,l_rvb36,l_rvb37,l_rvb38,l_pmn07
        FROM rvb_file,pmn_file
       WHERE rvb01 = l_qcs.qcs01
         AND rvb02 = l_qcs.qcs02
         AND rvb04 = pmn01
         AND rvb03 = pmn02
 
      SELECT img09 INTO l_img09
        FROM img_file   #庫存單位
       WHERE img01=l_rvb05 AND img02=l_rvb36
         AND img03=l_rvb37 AND img04=l_rvb38
      CALL s_umfchk(l_rvb05,l_pmn07,l_img09) 
           RETURNING l_i,l_fac
      IF l_i = 1 THEN LET l_fac = 1 END IF
   END IF
 
   IF p_argv1 = '2' THEN
      #CASE l_qcs.qcs00   #CHI-A70047
      CASE    #CHI-A70047
         #WHEN "A" OR "B"   #CHI-A70047
         WHEN l_qcs.qcs00='A' OR l_qcs.qcs00='B'   #CHI-A70047
            SELECT inb04,inb05,inb06,inb07,inb08,inb08_fac   #CHI-A70047
              INTO l_rvb05,l_rvb36,l_rvb37,l_rvb38,l_pmn07,l_fac   #CHI-A70047
              FROM inb_file
             WHERE inb01 = l_qcs.qcs01
               #AND inb02 = l_qcs.qcs02   #CHI-A70047
               AND inb03 = l_qcs.qcs02   #CHI-A70047
 
            SELECT img09 INTO l_img09
              FROM img_file   #庫存單位
             WHERE img01=l_rvb05 AND img02=l_rvb36
               AND img03=l_rvb37 AND img04=l_rvb38
         #WHEN "C" OR "D"   #CHI-A70047
         WHEN l_qcs.qcs00='C' OR l_qcs.qcs00='D'   #CHI-A70047
            SELECT imn09 INTO l_img09
              FROM imn_file
             WHERE imn01 = l_qcs.qcs01
               AND imn02 = l_qcs.qcs02
 
            LET l_fac = 1
        #WHEN "H"   #CHI-A70047
        WHEN l_qcs.qcs00='H'   #CHI-A70047
            SELECT ohb15,ohb15_fac INTO l_img09,l_fac
              FROM ohb_file
             WHERE ohb01 = l_qcs.qcs01
               AND ohb03 = l_qcs.qcs02
      END CASE
   END IF
 
   IF p_argv1 = '3' THEN
      SELECT ogb15,ogb15_fac INTO l_img09,l_fac
        FROM ogb_file
       WHERE ogb01 = l_qcs.qcs01
         AND ogb03 = l_qcs.qcs02
   END IF
 
   RETURN l_rvb36,l_rvb37,l_rvb38,l_pmn07,l_img09,l_fac   #DEV-D50007 add

END FUNCTION

FUNCTION aqct110sub_get_qcd07(p_qct04,p_argv1,l_qcs)
   DEFINE p_qct04       LIKE qct_file.qct04
   DEFINE l_qcd05       LIKE qcd_file.qcd05
   DEFINE l_qcd07       LIKE qcd_file.qcd07
   DEFINE l_qcd061      LIKE qcd_file.qcd061
   DEFINE l_qcd062      LIKE qcd_file.qcd062
   #DEV-D40021 --add--str 
   DEFINE p_argv1       LIKE type_file.chr1
   DEFINE l_qcs         RECORD LIKE qcs_file.*
   DEFINE l_sql         STRING 
   #DEV-D40021 --add--end 

   LET l_qcd07  = 'N'
   LET l_qcd05  = ''
   LET l_qcd061 = ''
   LET l_qcd062 = ''
   LET l_sql = " SELECT qcc05,qcc061,qcc062,qcc07 ",
               "   FROM qcc_file,ecm_file,rvb_file,pmn_file ",
               "  WHERE rvb01= ?    AND rvb02= ?",
               "    AND rvb04=pmn01 AND rvb03=pmn02  ",
               "    AND pmn41=ecm01 AND pmn46=ecm03 ",
               "    AND qcc01= ?    AND qcc011=ecm04 ",
               "    AND qcc02= ?",
               "    AND ecm012=pmn012 "   
   IF p_argv1 = "1" THEN 
      LET l_sql = l_sql CLIPPED," AND qcc08 in ('1','9')"
   END IF     
   IF p_argv1 = "2" THEN 
      LET l_sql = l_sql CLIPPED," AND qcc08 in ('5','9')" 
   END IF     
   IF p_argv1 = "3" THEN 
      LET l_sql = l_sql CLIPPED," AND qcc08 in ('4','9')"
   END IF     
   IF p_argv1 = "4" THEN 
      LET l_sql = l_sql CLIPPED," AND qcc08 in ('2','9')"
   END IF 
   PREPARE qcc_sel2 FROM l_sql  
   EXECUTE qcc_sel2 USING l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs021,p_qct04
      INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07                                          
   IF STATUS=100 THEN
      EXECUTE qcc_sel2 USING l_qcs.qcs01,l_qcs.qcs02,'*',p_qct04
         INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07
      IF STATUS=100 THEN
         LET l_sql = " SELECT qcd05,qcd061,qcd062,qcd07 ",
                     " FROM qcd_file ",
                     " WHERE qcd01=? AND qcd02=? "
         IF p_argv1 = "1" THEN 
            LET l_sql = l_sql CLIPPED," AND qcd08 in ('1','9')"
         END IF           
         IF p_argv1 = "2" THEN 
            LET l_sql = l_sql CLIPPED," AND qcd08 in ('5','9')" 
         END IF     
         IF p_argv1 = "3" THEN 
            LET l_sql = l_sql CLIPPED," AND qcd08 in ('4','9')"
         END IF     
         IF p_argv1 = "4" THEN 
            LET l_sql = l_sql CLIPPED," AND qcd08 in ('2','9')"
         END IF
         PREPARE qcd_sel2 FROM l_sql  
         EXECUTE qcd_sel2 USING l_qcs.qcs021,p_qct04
            INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07                       
         IF STATUS=100 THEN
            LET l_sql = " SELECT qck05,qck061,qck062,qck07  ",
                        "   FROM qck_file,ima_file ",
                        "  WHERE ima01=? AND qck01=ima109 ",
                        "    AND qck02 = ?"
                   
            IF p_argv1 = "1" THEN 
               LET l_sql = l_sql CLIPPED," AND qck08 in ('1','9')" 
            END IF       
            IF p_argv1 = "2" THEN 
               LET l_sql = l_sql CLIPPED," AND qck08 in ('5','9')"
            END IF      
            IF p_argv1 = "3" THEN 
               LET l_sql = l_sql CLIPPED," AND qck08 in ('4','9')"
            END IF     
            IF p_argv1 = "4" THEN 
               LET l_sql = l_sql CLIPPED," AND qck08 in ('2','9')"
            END IF    
            PREPARE qck_sel2 FROM l_sql  
            EXECUTE qck_sel2 USING l_qcs.qcs021,p_qct04
               INTO l_qcd05,l_qcd061,l_qcd062,l_qcd07                    
            IF STATUS=100 THEN
               LET l_qcd07  = 'N'
               LET l_qcd05  = ''
               LET l_qcd061 = ''
               LET l_qcd062 = ''
            END IF
         END IF
      END IF    
   END IF

   RETURN l_qcd07,l_qcd05,l_qcd061,l_qcd062
END FUNCTION 

FUNCTION aqct110sub_qc(l_qcs)
   DEFINE l_sum_qco11     LIKE type_file.num10,
          l_sum_qco15     LIKE type_file.num10,
          l_sum_qco18     LIKE type_file.num10,
          l_qco13         LIKE qco_file.qco13,
          l_qco15         LIKE qco_file.qco15,
          l_qco16         LIKE qco_file.qco16,
          l_qco18         LIKE qco_file.qco18,
          l_factor        LIKE type_file.num10,
          l_flag          LIKE type_file.chr1,
          l_sql           STRING,
          l_n             LIKE type_file.num5
   #DEV-D40021 --add--str
   DEFINE l_qcs           RECORD LIKE qcs_file.*
   #DEV-D40021 --add--end

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM qco_file
    WHERE qco01 = l_qcs.qcs01
      AND qco02 = l_qcs.qcs02
      AND qco05 = l_qcs.qcs05
   IF l_n = 0 THEN RETURN END IF

   SELECT SUM(qco11*qco19) INTO l_sum_qco11
     FROM qco_file,qcl_file
    WHERE qco01 = l_qcs.qcs01
      AND qco02 = l_qcs.qcs02
      AND qco05 = l_qcs.qcs05
      AND qco03 = qcl01
     #AND qcl05 <> '3'      #FUN-CC0013 mark
   IF cl_null(l_sum_qco11) THEN LET l_sum_qco11 = 0 END IF
   IF l_sum_qco11 = 0 THEN RETURN END IF
   LET l_sql = "SELECT qco13,qco15,qco16,qco18 ",
               "  FROM qco_file,qcl_file       ",
               " WHERE qco03 = qcl01           ",
               "   AND qco01 = '",l_qcs.qcs01,"' ",
               "   AND qco02 = '",l_qcs.qcs02,"' ",
               "   AND qco05 = '",l_qcs.qcs05,"' "     #FUN-CC0013 mark ,
              #"   AND qcl05 <> '3' "                  #FUN-CC0013 mark
   PREPARE qco_pre FROM l_sql
   DECLARE qco_cur CURSOR FOR qco_pre
   FOREACH qco_cur INTO l_qco13,l_qco15,l_qco16,l_qco18
      CALL s_umfchk(l_qcs.qcs021,l_qco13,l_qcs.qcs30) RETURNING l_flag,l_factor
      IF l_flag = 1 THEN
         LET l_factor = 1
      END IF
      LET l_qco15 = l_qco15 * l_factor
      LET l_qco15 = s_digqty(l_qco15,l_qcs.qcs30)

      CALL s_umfchk(l_qcs.qcs021,l_qco16,l_qcs.qcs33) RETURNING l_flag,l_factor
      IF l_flag = 1 THEN
         LET l_factor = 1
      END IF
      LET l_qco18 = l_qco18 * l_factor
      LET l_qco18 = s_digqty(l_qco18,l_qcs.qcs33)

      LET l_sum_qco15 = l_sum_qco15 + l_qco15
      LET l_sum_qco18 = l_sum_qco18 + l_qco18
   END FOREACH

   UPDATE qcs_file
      SET qcs09  = '1',
          qcs091 = l_sum_qco11,
          qcs38  = l_sum_qco15,
          qcs41  = l_sum_qco18
    WHERE qcs01  = l_qcs.qcs01
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
   END IF

END FUNCTION

FUNCTION aqct110sub_upd_srg10(p_opt,l_qcs)
   DEFINE p_opt    LIKE type_file.chr1         # Prog. Version..: '5.30.24-17.04.13(01)  # "+" OR "-'
   DEFINE l_qcs091 LIKE qcs_file.qcs091
   DEFINE l_sre10  LIKE sre_file.sre10,
          l_srf03  LIKE srf_file.srf03,
          l_srf04  LIKE srf_file.srf04,
          l_srf05  LIKE srf_file.srf05,
          l_srg03  LIKE srg_file.srg03,
          l_srg18  LIKE srg_file.srg18 #FUN-630105
   DEFINE l_msg    STRING              #FUN-680011
   #DEV-D40021 --add--str
   DEFINE l_qcs    RECORD LIKE qcs_file.*
   #DEV-D40021 --add--end
 
   SELECT qcs091 INTO l_qcs091 FROM qcs_file WHERE qcs01=l_qcs.qcs01
                                               AND qcs02=l_qcs.qcs02
   IF cl_null(l_qcs091) THEN
      LET l_qcs091=0
   END IF
   SELECT srf03,srf04,srf05,srg03 INTO l_srf03,l_srf04,l_srf05,l_srg03
                               FROM srf_file,srg_file
                                             WHERE srf01=srg01
                                               AND srg01=l_qcs.qcs01
                                               AND srg02=l_qcs.qcs02
   SELECT sre10 INTO l_sre10 FROM sre_file WHERE sre03=l_srf03  #機台
                                             AND sre04=l_srg03  #料號
                                             AND sre05=l_srf04  #班別
                                             AND sre06=l_srf05  #計畫日
   IF cl_null(l_sre10) THEN
      LET l_sre10=0
   END IF
 
   CASE p_opt
      WHEN "+"
         LET l_sre10=l_sre10+l_qcs091
      WHEN "-"
         LET l_sre10=l_sre10-l_qcs091
      OTHERWISE
         RETURN
   END CASE
 
   UPDATE sre_file set sre10=l_sre10 WHERE sre03=l_srf03  #機台
                                       AND sre04=l_srg03  #料號
                                       AND sre05=l_srf04  #班別
                                       AND sre06=l_srf05  #計畫日
   IF SQLCA.sqlcode OR (SQLCA.sqlerrd[3]=0) THEN  #僅提示,繼續下面動作
       LET l_msg = cl_getmsg('9050',g_lang)
       LET l_msg="upd sre10 (sre_file) ",l_msg CLIPPED
       CALL cl_msgany(10,20,l_msg)
   END IF
 
   IF l_qcs.qcs00='7' THEN
      SELECT srg18 INTO l_srg18 FROM srg_file WHERE srg01=l_qcs.qcs01
                                                AND srg02=l_qcs.qcs02
      IF cl_null(l_srg18) THEN
         LET l_srg18=0
      END IF
      CASE p_opt
         WHEN "+"
            LET l_srg18=l_srg18+l_qcs091
         WHEN "-"
            LET l_srg18=l_srg18-l_qcs091
         OTHERWISE
            RETURN
      END CASE
      UPDATE srg_file set srg18=l_srg18 WHERE srg01=l_qcs.qcs01
                                          AND srg02=l_qcs.qcs02
      IF SQLCA.sqlcode OR (SQLCA.sqlerrd[3]=0) THEN
         CALL cl_err3("upd","srg_file",l_qcs.qcs01,l_qcs.qcs02,"9050","","upd srg18",1)  #No.FUN-660115
         LET g_success='N'
      END IF
   END IF
END FUNCTION

FUNCTION aqct110sub_check_pmh09(p_action_choice,l_qcs)
   DEFINE l_count,m_cnt   LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_countn        LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_countt        LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_countr        LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_pass          LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_down          LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_down1         LIKE type_file.num5,         #No.FUN-680104 SMALLINT
          l_qcs01         LIKE qcs_file.qcs01,         #No.FUN-680104 VARCHAR(16) #No.FUN-550029
          l_qcs09         LIKE qcs_file.qcs09,         #No.FUN-680104 VARCHAR(01)
          l_qcs04         LIKE qcs_file.qcs04,         #No.FUN-680104 DATE
          l_qcs041        LIKE qcs_file.qcs041,        #No.FUN-680104 VARCHAR(08)
          l_qcs21         LIKE qcs_file.qcs21,
          l_pmh09         LIKE pmh_file.pmh09
   #DEV-D40021 --add--str
   DEFINE p_action_choice STRING 
   DEFINE l_qcs    RECORD LIKE qcs_file.*
   DEFINE l_sql    STRING
   DEFINE l_type   LIKE pmh_file.pmh22  
   DEFINE l_ecm04  LIKE ecm_file.ecm04
   #DEV-D40021 --add--end
 
   #DEV-D40021 --add--str
   CALL aqct110sub_get_ecm04(l_qcs.*) RETURNING l_type,l_ecm04
   #DEV-D40021 --add--end
    
   LET l_count = 0
   LET l_countn= 0
   LET l_countt= 0
   LET l_countr= 0
 
   LET l_sql = "SELECT qcs09,qcs04,qcs01,qcs041,qcs21" ,
               "  FROM qcs_file  ",
               " WHERE qcs03  = '",l_qcs.qcs03,"'",
               "   AND qcs021 = '",l_qcs.qcs021,"'",
               "   AND qcsacti = 'Y' AND qcs14='Y' ",
               " ORDER BY qcs04 DESC,qcs041 DESC "
 
   PREPARE aqct110sub_c2 FROM l_sql
 
   DECLARE aqct110sub_c2p SCROLL CURSOR WITH HOLD FOR aqct110sub_c2
 
   FOREACH aqct110sub_c2p INTO l_qcs09,l_qcs04,l_qcs01,l_qcs041,l_qcs21
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
 
      IF l_qcs09 NOT MATCHES '[123]' THEN
         CONTINUE FOREACH
      END IF
 
      IF l_qcs21 NOT MATCHES '[NTR]' THEN
         CONTINUE FOREACH
      END IF
 
      LET l_count = l_count + 1
      CASE l_qcs21
         WHEN 'N' LET l_countn = l_countn + 1
         WHEN 'T' LET l_countt = l_countt + 1
         WHEN 'R' LET l_countr = l_countr + 1
      END CASE
 
      CASE l_qcs09
         WHEN '1'
            LET l_pass = l_pass + 1    #--- 合格
         WHEN '2'
            LET l_down = l_down + 1    #--- 退貨
         WHEN '3'
            LET l_down1 = l_down1 + 1  #--- 特採
      END CASE
 
      LET l_pmh09 = l_qcs.qcs21
 
      CASE l_qcs.qcs21
         WHEN 'N'      #正常檢驗
            CASE
               WHEN l_count = g_qcz.qcz08 AND l_countn = g_qcz.qcz08
                                          AND l_pass = g_qcz.qcz08
                  LET l_pmh09 = 'R'
                  EXIT FOREACH
               WHEN l_count <= g_qcz.qcz06 AND l_countn <= g_qcz.qcz06
                                           AND l_down = g_qcz.qcz061
                  LET l_pmh09 = 'T'
                  EXIT FOREACH
               WHEN l_count > g_qcz.qcz08 AND l_count > g_qcz.qcz06
                  EXIT FOREACH
            END CASE
         WHEN 'T'      #加嚴檢驗
            CASE
               WHEN l_count =g_qcz.qcz07  AND l_countt = g_qcz.qcz07
                                         AND l_pass = g_qcz.qcz07
                  LET l_pmh09 = 'N'
                  EXIT FOREACH
              WHEN l_count =g_qcz.qcz11  AND l_countt = g_qcz.qcz11
                                         AND l_down = g_qcz.qcz11
                  LET l_pmh09 = 'T'
                  IF l_qcs.qcs00 NOT MATCHES '[56]' THEN
                     UPDATE pmh_file SET pmh05='1',pmh06='',pmhdate = g_today     #FUN-D10063 add pmhdate = g_today
                      WHERE pmh01=l_qcs.qcs021 AND pmh02=l_qcs.qcs03
                        AND pmh21 = l_ecm04                             #CHI-860042   #MOD-890102 modify ' '->l_ecm04
                        AND pmh22 = l_type                              #CHI-860042   #MOD-890102 modify '1'->l_type
                        AND pmh23 = ' '                                 #No.CHI-960033
                  END IF
                  EXIT FOREACH
               WHEN l_count > g_qcz.qcz07 AND l_count > g_qcz.qcz11
                  EXIT FOREACH
            END CASE
         WHEN 'R'      #減量檢驗
            CASE
               WHEN l_count = g_qcz.qcz09 AND l_countr = g_qcz.qcz09
                                          AND l_down = g_qcz.qcz09
                  LET l_pmh09 = 'N'
                  EXIT FOREACH
               WHEN l_count = g_qcz.qcz10 AND l_countr = g_qcz.qcz10
                                          AND l_pass = g_qcz.qcz10
                  LET l_pmh09 = 'R'
                  IF l_qcs.qcs00 MATCHES '[56]' THEN
                     UPDATE obk_file SET obk11 = 'N'
                                   WHERE obk01 = l_qcs.qcs021
                                     AND obk02 = l_qcs.qcs03
                  ELSE
                     UPDATE pmh_file SET pmh08='N',pmhdate = g_today     #FUN-D10063 add pmhdate = g_today
                        WHERE pmh01=l_qcs.qcs021 AND pmh02=l_qcs.qcs03
                          AND pmh21 = l_ecm04                           #CHI-860042   #MOD-890102 modify ' '->l_ecm04
                          AND pmh22 = l_type                            #CHI-860042   #MOD-890102 modify '1'->l_type
                          AND pmh23 = ' '                               #No.CHI-960033
                  END IF
                  EXIT FOREACH
               WHEN l_count > g_qcz.qcz09 AND l_count > g_qcz.qcz10
                  EXIT FOREACH
            END CASE
      END CASE
   END FOREACH
 
   IF cl_null(l_pmh09) THEN
      LET l_pmh09 = 'N'
   END IF
 
   IF l_qcs.qcs00 MATCHES '[56]' THEN
      UPDATE obk_file SET obk12 = l_pmh09
       WHERE obk01 = l_qcs.qcs021
         AND obk02 = l_qcs.qcs03
   ELSE
      UPDATE pmh_file SET pmh09 = l_pmh09,pmhdate = g_today     #FUN-D10063 add pmhdate = g_today
       WHERE pmh01 = l_qcs.qcs021
         AND pmh02 = l_qcs.qcs03
         AND pmh21 = l_ecm04                             #CHI-860042   #MOD-890102 modify ' '->l_ecm04
         AND pmh22 = l_type                              #CHI-860042   #MOD-890102 modify '1'->l_type
         AND pmh23 = ' '                                 #No.CHI-960033
   END IF

   #str MOD-A30058 add
   IF l_qcs.qcs21 = 'R' THEN   #減量檢驗
      IF p_action_choice="undo_confirm" AND l_countr=g_qcz.qcz10-1 THEN
         IF l_qcs.qcs00 MATCHES '[56]' THEN
            UPDATE obk_file SET obk11 = 'Y'
             WHERE obk01 = l_qcs.qcs021
               AND obk02 = l_qcs.qcs03
         ELSE
            UPDATE pmh_file SET pmh08 = 'Y',pmhdate = g_today     #FUN-D10063 add pmhdate = g_today
             WHERE pmh01=l_qcs.qcs021 AND pmh02=l_qcs.qcs03
               AND pmh21 = l_ecm04
               AND pmh22 = l_type
               AND pmh23 = ' '
         END IF
      END IF
   END IF
   #end MOD-A30058 add
END FUNCTION

FUNCTION aqct110sub_get_ecm04(l_qcs)
   DEFINE l_rvb04  LIKE rvb_file.rvb04    #MOD-890102
   DEFINE l_rvb03  LIKE rvb_file.rvb03    #MOD-890102
   DEFINE l_pmm02  LIKE pmm_file.pmm02    #MOD-890102
   DEFINE l_pmn41  LIKE pmn_file.pmn41    #MOD-890102
   DEFINE l_pmn43  LIKE pmn_file.pmn43    #MOD-890102
   DEFINE l_pmn012  LIKE pmn_file.pmn012   #FUN-A60076 add
   #DEV-D40021 --add--str
   DEFINE l_qcs    RECORD LIKE qcs_file.*
   DEFINE l_type   LIKE pmh_file.pmh22
   DEFINE l_ecm04  LIKE ecm_file.ecm04
   #DEV-D40021 --add--end
 
   LET l_type  = '1'       #MOD-890102
   LET l_ecm04 = ' '       #MOD-890102
 
   IF l_qcs.qcs00 <> '1' AND  l_qcs.qcs00 <> '2' THEN
      RETURN l_type,l_ecm04
   END IF 
 
   SELECT rvb04,rvb03   
     INTO l_rvb04,l_rvb03           #MOD-890102 
     FROM rvb_file
    WHERE rvb01=l_qcs.qcs01
      AND rvb02=l_qcs.qcs02
   SELECT pmm02,pmn41,pmn43,pmn012 INTO l_pmm02,l_pmn41,l_pmn43,l_pmn012   #No.MOD-930234 add
     FROM pmm_file,pmn_file 
    WHERE pmm01 = l_rvb04  AND pmn02=l_rvb03
      AND pmm01 = pmn01
   IF l_pmm02='SUB' THEN 
      LET l_type='2' 
      IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN
         LET l_ecm04 = " "
      ELSE
         SELECT ecm04 INTO l_ecm04 FROM ecm_file
          WHERE ecm01 = l_pmn41
            AND ecm03 = l_pmn43
            AND ecm012 =l_pmn012                    #FUN-A60076 add
      END IF
   END IF 
   
   RETURN l_type,l_ecm04
END FUNCTION

FUNCTION aqct110sub_barcode_gen(p_qcs01,p_qcs02,p_qcs05,p_ask)
   DEFINE p_qcs01   LIKE qcs_file.qcs01
   DEFINE p_qcs02   LIKE qcs_file.qcs02
   DEFINE p_qcs05   LIKE qcs_file.qcs05
   DEFINE p_ask     LIKE type_file.chr1
   DEFINE l_qcs     RECORD LIKE qcs_file.*
   DEFINE l_inb03   LIKE inb_file.inb03
   DEFINE l_inb04   LIKE inb_file.inb04
   DEFINE l_inb09   LIKE inb_file.inb09
   DEFINE l_ima930  LIKE ima_file.ima930
   DEFINE l_ima932  LIKE ima_file.ima932
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima919  LIKE ima_file.ima919
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_ima922  LIKE ima_file.ima922
   DEFINE l_ima931  LIKE ima_file.ima931
   DEFINE l_count   LIKE type_file.num5
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_sql     STRING

   IF cl_null(p_qcs01) THEN
      CALL cl_err('',-400,1)
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_qcs.* FROM qcs_file
    WHERE qcs01 = p_qcs01
      AND qcs02 = p_qcs02
      AND qcs05 = p_qcs05

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('L',l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05) THEN
      RETURN
   END IF

   IF l_qcs.qcsacti = 'N' THEN
      CALL cl_err('',9027,0)
      LET g_success = 'N'
      RETURN
   END IF

   IF p_ask = 'Y' THEN #DEV-D40015 add
      IF l_qcs.qcs14 = 'N' THEN
         CALL cl_err('','sfb-999',0)
         LET g_success = 'N'
         RETURN
      END IF
   END IF                  #DEV-D40015 add

   IF l_qcs.qcs14 = 'X' THEN
      CALL cl_err('','sfb-998',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk(l_qcs.qcs01) THEN
      LET g_success = 'N'
      RETURN
   END IF

   IF p_ask = 'Y' THEN
      IF NOT cl_confirm('azz1276') THEN
         LET g_success='N'
         RETURN
      END IF
   END IF

   LET g_success = 'Y'
   CALL s_showmsg_init()
   
   BEGIN WORK

   CALL aqct110sub_lock_cl()
   
   OPEN aqct110sub_cl USING l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05
   IF STATUS THEN
      CALL cl_err("OPEN aqct110sub_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE aqct110sub_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH aqct110sub_cl INTO l_qcs.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_qcs.qcs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE aqct110sub_cl
      ROLLBACK WORK
      RETURN
   END IF

   #DEV-D30043--mark--begin
   #IF NOT s_diy_barcode(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,'L') THEN
   #   LET g_success = 'N'
   #END IF
   #
   #IF g_success = 'Y' THEN
   #   CALL s_gen_barcode2('L',l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05)
   #END IF
   #DEV-D30043--mark--end

   #DEV-D30043--add--begin
   IF g_success = 'Y' THEN
      CALL s_gen_barcode2('L',l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05)
   END IF

   IF g_success = 'Y' THEN
      IF NOT s_diy_barcode(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,'L') THEN
         LET g_success = 'N'
      END IF
   END IF
   #DEV-D30043--add--end
  
  #DEV-D40015 add str-------
   IF g_success = 'Y' THEN
      CALL aqct110sub_chk_ima(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,'I')
   END IF
  #DEV-D40015 add end-------

   CALL s_showmsg()
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_msgany(0,0,'aba-001')
   ELSE
      ROLLBACK WORK
      # Prog. Version..: '5.30.24-17.04.13(0,0,'aba-002')    #DEV-D40015--mark
      CALL cl_err('','aba-002',0)       #DEV-D40015--mod
   END IF
END FUNCTION

FUNCTION aqct110sub_barcode_z(p_qcs01,p_qcs02,p_qcs05,p_inTransaction)  #DEV-D40015--add p_inTransaction
   DEFINE p_qcs01   LIKE qcs_file.qcs01
   DEFINE p_qcs02   LIKE qcs_file.qcs02
   DEFINE p_qcs05   LIKE qcs_file.qcs05
   DEFINE p_inTransaction LIKE type_file.num5                     #DEV-D40015--add
   DEFINE l_qcs     RECORD LIKE qcs_file.*
   DEFINE l_inb03   LIKE inb_file.inb03
   DEFINE l_inb04   LIKE inb_file.inb04
   DEFINE l_inb09   LIKE inb_file.inb09
   DEFINE l_ima930  LIKE ima_file.ima930
   DEFINE l_ima932  LIKE ima_file.ima932
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima919  LIKE ima_file.ima919
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_ima922  LIKE ima_file.ima922
   DEFINE l_ima931  LIKE ima_file.ima931
   DEFINE l_count   LIKE type_file.num5
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_sql     STRING

   IF cl_null(p_qcs01) THEN
      CALL cl_err('',-400,1)
      LET g_success = 'N'
      RETURN
   END IF
   
   SELECT * INTO l_qcs.* FROM qcs_file
    WHERE qcs01 = p_qcs01
      AND qcs02 = p_qcs02
      AND qcs05 = p_qcs05

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('L',l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05) THEN
      RETURN
   END IF

   IF l_qcs.qcsacti = 'N' THEN
      CALL cl_err('',9027,0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk2(l_qcs.qcs01) THEN
      LET g_success = 'N'
      RETURN
   END IF

   LET g_success = 'Y'
   #DEV-D40015--add--begin
   #BEGIN WORK
   IF NOT p_inTransaction THEN
      BEGIN WORK
   END IF
   #DEV-D40015--add--end

   OPEN aqct110sub_cl USING l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05
   IF STATUS THEN
      CALL cl_err("OPEN aqct110sub_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE aqct110sub_cl
      #DEV-D40015--add--begin
      #ROLLBACK WORK
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      #DEV-D40015--add--end
      RETURN
   END IF
   FETCH aqct110sub_cl INTO l_qcs.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_qcs.qcs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE aqct110sub_cl
      #DEV-D40015--add--begin
      #ROLLBACK WORK
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      #DEV-D40015--add--end
      RETURN
   END IF

   #DEV-D40015 add str-------
   IF g_success = 'Y' THEN
      #先刪除,再作廢條碼
      CALL aqct110sub_chk_ima(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,'D')
   END IF
   #DEV-D40015 add end-------

   IF g_success='Y' THEN
      CALL s_barcode_x2('L',l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05)
   END IF

   IF g_success='Y' THEN
      #DEV-D40015--add--begin
      #COMMIT WORK
      IF NOT p_inTransaction THEN
         COMMIT WORK
      END IF
      #DEV-D40015--add--end
      CALL cl_msgany(0,0,'aba-178')
   ELSE
      #DEV-D40015--add--begin
      #ROLLBACK WORK
      IF NOT p_inTransaction THEN
         ROLLBACK WORK
      END IF
      #DEV-D40015--add--end
      CALL cl_msgany(0,0,'aba-179')
   END IF
END FUNCTION

FUNCTION aqct110sub_refresh(p_qcs01,p_qcs02,p_qcs05)
   DEFINE p_qcs01     LIKE qcs_file.qcs01
   DEFINE p_qcs02     LIKE qcs_file.qcs02
   DEFINE p_qcs05     LIKE qcs_file.qcs05
   DEFINE l_qcs       RECORD LIKE qcs_file.*
   
   INITIALIZE l_qcs.* TO NULL
   
   SELECT * INTO l_qcs.* FROM qcs_file 
    WHERE qcs01 = p_qcs01
      AND qcs02 = p_qcs02
      AND qcs05 = p_qcs05
   
   RETURN l_qcs.*
END FUNCTION 

FUNCTION aqct110sub_chk_ima(p_qcs01,p_qcs02,p_qcs05,p_type)
   DEFINE p_qcs01    LIKE   qcs_file.qcs01
   DEFINE p_qcs02    LIKE   qcs_file.qcs02
   DEFINE p_qcs05    LIKE   qcs_file.qcs05
   DEFINE p_type     LIKE   rva_file.rva01  #I:新增 D:刪除
   DEFINE l_sql      STRING
   DEFINE l_ima01    LIKE   ima_file.ima01

   LET l_sql = " SELECT DISTINCT b.ima01,b.ima930,b.ima932 ",
               "   FROM qcs_file a         ",
               "  INNER JOIN ima_file b ON a.qcs021 = b.ima01 ",
               "                       AND b.ima930= 'Y' ",
               "                       AND b.ima932= 'L'",
               "  WHERE a.qcs01 = '",p_qcs01,"'",
               "    AND a.qcs02 = '",p_qcs02,"'",
               "    AND a.qcs05 = '",p_qcs05,"'"

   PREPARE aqct110_chkima_pre FROM l_sql
   DECLARE aqct110_chkima_cur CURSOR FOR aqct110_chkima_pre

   FOREACH aqct110_chkima_cur INTO l_ima01
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach aqct110_chkima_cur:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF

      CASE
         WHEN p_type = 'I'
            CALL s_ibb_ins_rvbs(g_prog,p_qcs01,l_ima01)
         WHEN p_type = 'D'
            CALL s_ibb_del_rvbs(g_prog,p_qcs01,l_ima01)
      END CASE
   END FOREACH
END FUNCTION

#MOD-EC0028---add----str---
#取得這張單據是否做QC料件判定
#若需做QC料件判定,並check此張單據是否已輸入QC料件判定(aqci107)資料
FUNCTION aqct110sub_get_qc_check(p_qcs01,p_qcs02,p_qcs05,p_argv1) 
    DEFINE p_qcs01    LIKE qcs_file.qcs01
    DEFINE p_qcs02    LIKE qcs_file.qcs02
    DEFINE p_qcs05    LIKE qcs_file.qcs05
    DEFINE p_argv1    LIKE type_file.chr1
    DEFINE l_qcs      RECORD LIKE qcs_file.*
    DEFINE l_yn       LIKE type_file.num5    
    DEFINE l_cnt      LIKE type_file.num5    
    DEFINE l_flag     LIKE type_file.chr1    
    DEFINE l_sql      STRING      
    DEFINE l_qcc09    LIKE qcc_file.qcc09

    IF g_qcz.qcz14 = 'N' THEN
        RETURN 
    END IF
    SELECT * INTO l_qcs.*
      FROM qcs_file
     WHERE qcs01 = p_qcs01
       AND qcs02 = p_qcs02
       AND qcs05 = p_qcs05

    #以下此段邏輯copy 參考from saqct110.4gl FUNCTION t110_g_b()
    IF p_argv1 = "1" THEN
       SELECT COUNT(*) INTO l_yn
         FROM qcc_file,ecm_file,rvb_file,pmn_file
        WHERE rvb01 = l_qcs.qcs01
          AND rvb02 = l_qcs.qcs02
          AND rvb04 = pmn01
          AND rvb03 = pmn02
          AND pmn41 = ecm01
          AND pmn46 = ecm03
          AND qcc01 = l_qcs.qcs021
          AND qcc011 = ecm04
          AND qcc08 IN ('1','9')    
          AND ecm012 = pmn012       
        GROUP BY ecm04
        IF cl_null(l_yn) OR l_yn<=0 THEN
           SELECT COUNT(*) INTO l_yn
             FROM qcc_file,ecm_file,rvb_file,pmn_file
            WHERE rvb01 = l_qcs.qcs01
              AND rvb02 = l_qcs.qcs02
              AND rvb04 = pmn01
              AND rvb03 = pmn02
              AND pmn41 = ecm01
              AND pmn46 = ecm03
              AND qcc01 = '*'
              AND qcc011 = ecm04
              AND qcc08 IN ('1','9')
              AND ecm012 = pmn012         
            GROUP BY ecm04
            IF cl_null(l_yn) OR l_yn<=0 THEN
           SELECT COUNT(*) INTO l_yn 
             FROM qcc_file,sgm_file,rvb_file,pmn_file
            WHERE rvb01=l_qcs.qcs01 
              AND rvb02=l_qcs.qcs02
              AND rvb04=pmn01 
              AND rvb03=pmn02
              AND pmn41=sgm02 
              AND pmn32=sgm03
              AND sgm012 = pmn012     
              AND qcc01=l_qcs.qcs021 
              AND qcc011=sgm04 
              AND qcc08 IN ('1','9')     
              GROUP BY sgm04
           END IF
        END IF                               
    ELSE
       LET l_yn = 0
    END IF
 
    IF l_yn > 0 THEN
       LET l_flag = '1'          #--製程委外抓站別檢驗項目
    ELSE
       LET l_sql = " SELECT COUNT(*) FROM qcd_file ",
                   " WHERE qcd01 = ? "
       CASE p_argv1 
          WHEN '1' 
               LET l_sql = l_sql CLIPPED, " AND qcd08 in ('1','9') " 
          WHEN '2' 
               LET l_sql = l_sql CLIPPED, " AND qcd08 in ('5','9') "
          WHEN '3' 
               LET l_sql = l_sql CLIPPED, " AND qcd08 in ('4','9') "
          WHEN '4' 
               LET l_sql = l_sql CLIPPED, " AND qcd08 in ('2','9') " 
       END CASE                                    
       PREPARE t110sub_qcd_sel FROM l_sql 
       EXECUTE t110sub_qcd_sel USING l_qcs.qcs021 INTO l_yn           
       IF l_yn > 0 THEN          #--- 料件檢驗項目
          LET l_flag = '2'
       ELSE
          LET l_flag = '3'       #--- 材料類別檢驗項目
       END IF
    END IF

    LET l_qcc09 = 'N'
    CASE l_flag
         WHEN "1" #抓aqci121 #--製程委外抓站別檢驗項目
                 SELECT DISTINCT qcc09 INTO l_qcc09 FROM qcc_file
                  WHERE qcc01=l_qcs.qcs021
         WHEN "2" #抓aqci120 #--- 料件檢驗項目
                  SELECT DISTINCT qcd09 INTO l_qcc09 FROM qcd_file
                   WHERE qcd01=l_qcs.qcs021
         WHEN "3" #抓aqci122 #--- 材料類別檢驗項目
                  SELECT DISTINCT qck09 INTO l_qcc09 FROM ima_file,qck_file
                   WHERE qck01=ima109
                     AND ima01=l_qcs.qcs021
    END CASE
    IF l_qcc09 = 'Y' THEN
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt 
          FROM qco_file
         WHERE qco01 = l_qcs.qcs01
           AND qco02 = l_qcs.qcs02
           AND qco05 = l_qcs.qcs05
        IF l_cnt <= 0 THEN
           #此張單據需做QC料件判定,但沒有QC料件維護(aqci107)資料!
           CALL cl_err('','aqc-544',1)      
           LET g_success = 'N'
        END IF
    END IF
END FUNCTION
#MOD-EC0028---add----end---
#DEV-D40021 --add
#MOD-G40139 add start -------------------------------------------------------
FUNCTION aqct110sub_copy_rvbs(p_qcs01,p_qcs02,p_qcs05)
   DEFINE p_qcs01    LIKE qcs_file.qcs01
   DEFINE p_qcs02    LIKE qcs_file.qcs02
   DEFINE p_qcs05    LIKE qcs_file.qcs05
   DEFINE l_rvbs00   LIKE rvbs_file.rvbs00
   DEFINE l_cnt      LIKE type_file.num5    

   LET l_rvbs00 = g_prog + '-3'

   SELECT COUNT(*) INTO l_cnt
     FROM rvbs_file
    WHERE rvbs00 = l_rvbs00
      AND rvbs01 = p_qcs01
      AND rvbs02 = p_qcs02
      AND rvbs13 = p_qcs05
      AND rvbs09 = 1

   IF l_cnt > 0 THEN

      DELETE FROM rvbs_file 
       WHERE rvbs00 = l_rvbs00
         AND rvbs01 = p_qcs01
         AND rvbs02 = p_qcs02
         AND rvbs13 = p_qcs05
         AND rvbs09 = 1       
            
      IF SQLCA.sqlcode AND SQLCA.sqlerrd[3] <> l_cnt THEN
         CALL cl_err3("del","rvbs_file",p_qcs01,"",SQLCA.sqlcode,"","",1)
         RETURN 0 
      END IF
   END IF
 
   DROP TABLE x
   SELECT * FROM rvbs_file        
    WHERE rvbs00 = g_prog
      AND rvbs01 = p_qcs01
      AND rvbs02 = p_qcs02
      AND rvbs13 = p_qcs05
      AND rvbs09 = 1
     INTO TEMP x

   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rvbs_file",p_qcs01,"",SQLCA.sqlcode,"","",1)
      RETURN 0 
   END IF

   UPDATE x
      SET rvbs00 = l_rvbs00 

   INSERT INTO rvbs_file
   SELECT * FROM x

   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rvbs_file",p_qcs01,"",SQLCA.sqlcode,"","",1)
      RETURN 0
   END IF

   DROP TABLE x
   RETURN 1
END FUNCTION
#MOD-G40139 add end   -------------------------------------------------------
