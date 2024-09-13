# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: abmi720_sub.4gl
# Descriptions...: 將原abmi720.4gl確認段拆解至abmi720_sub.4gl中
# Date & Author..: #FUN-AC0060 10/12/21 By Mandy
# Modify.......... No:TQC-B20005 2011/02/10 By Mandy CALL s_umfchkm(l_item,b_bmy.bmy10,l_ima86,g_dbs)
#                                                                                              ^^^^^ 參數傳錯,應為g_dbs_sep
# Modify.......... No:FUN-B20003 2011/02/10 By Mandy PLM-BUG
# Modify.......... No:MOD-B40205 2011/04/25 By sabrina 取特性代碼時應串bmy29
# Modify.......... No:MOD-B60018 2011/06/02 By sabrina i720sub_s3()少回傳bmb.bmb10_fac2
#---------------------------------------------------------------------------------------------
# Modify.........: #FUN-AC0060 11/07/05 By Mandy (1)PLM GP5.1追版至GP5.25 以上為GP5.1單號
#                                                (2)g_argv3改成g_argv3_str
# Modify.........: #FUN-B70076 11/07/21 By Mandy (1) 傳給s_umfchkm()的參數不正確
#                                                (2) 給bmb081,bmb082 default
# Modify.........: No.FUN-B80071 11/08/18 By Abby 調整EF自動確認功能
# Modify.........: No.TQC-BA0080 11/10/17 By houlia ECN變更時bmy35寫入bmb14
# Modify.........: No:MOD-BB0164 11/11/25 By johung 處理順序依bmy03作order by
# Modify.........: No:MOD-BC0097 11/12/10 By johung 修正i720sub_s4的SQL
# Modify.........: No.MOD-B80310 12/01/16 By Vampire 將 i720sub_upd_p3 的 SQL 及 prepare i720sub_upd_p3 移到if判斷式前面
# Modify.........: No:MOD-C20059 12/02/07 By destiny 修改时bmb14没有更新
# Modify.........: No:MOD-C20154 12/03/02 By ck2yuan 在確認段檢查新增元件是否有維護元件明細資料
# Modify.........: No:CHI-C40010 12/04/23 By ck2yuan 取替代時,作業編號未輸入即表示不異動
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C60180 12/06/27 By lixh1 將bmy07的值帶入bmb_file/brb_file     
# Modify.........: No.TQC-C60194 12/06/29 By fengrui 在insert into bmd_file之前給bmd11賦值
# Modify.........: No.CHI-C20060 12/09/18 By bart 類別增加替代變更，變更替代量，替代只能打替代量，回寫abmi604
# Modify.........: No.MOD-C90250 12/09/28 By suncx i720sub_upd_p41的sql語法錯誤
# Modify.........: No.FUN-BB0075 12/11/05 By bart 確認回寫abmi604時，if bmy36有值，即異動失效日bmd06=bmy36 else才異動替代量
# Modify.........: No.FUN-C40007 13/01/10 By Nina 只要程式有UPDATE bmb_file 的任何一個欄位時,多加bmbdate=g_today
# Modify.........: No:FUN-D10093 13/01/23 By Abby PLM BOM項次一致問題
# Modify.........: No:CHI-CA0035 13/01/28 By Elise 調整參數避免串查錯誤,g_argv1:固定參數 g_argv2:單號 g_argv3:執行功能
# Modify.........: No:FUN-D10146 13/01/31 By Mandy PLM 拋BOM給TP(走CreatePLMBOMData) 時,當有做ECN 異動及拋資料中心拋轉(ex:DS7拋DS2)會異常
# Modify.........: No:CHI-D40002 13/04/02 By bart icd行業別需一併修改icm_file
# Modify.........: No:MOD-D40044 13/04/09 By bart 元件被取代為另一顆元件後，已失效元件的取替代資料應該要一起失效
# Modify.........: No.MOD-D80031 13/08/06 By Alberti 選擇6:替代變更 確認後不會回寫ECN單號(bmy01)及主件新版本(bmy17)
# Modify.........: No:MOD-D90002 13/09/03 By Alberti BOM內同時存在兩筆相同元件資料B,做4.取代時,BOM單身將會產生二筆取代資料
# Modify.........: No:TQC-DA0015 13/10/18 By fengrui bmb_file 新增bmb34 服飾業顏色、尺寸屬性設定預設值
# Modify.........: No.MOD-E10080 14/01/13 By fengmy abmi710已審核資料不重複審核
# Modify.........: No:CHI-E20026 14/03/06 By Alberti 將abm-150以後的調整 abm-150 = 'Y',會將存在的下階BOM整個刪除並重新建立下階BOM(此點移除)
# Modify.........: No.MOD-E30067 14/03/12 By fengmy mark MOD-E10080
# Modify.........: No.MOD-E70053 14/07/10 By fengmy 更新bramodu,bradate不需加入bra012,bra013
# Modiyf.........: No:FUN-E70037 14/09/04 By Sulamite 鞋服功能改善
#                                                     服饰版新增同款式不同颜色、尺寸使用单一料号进行管理的功能，
#                                                     即一个款式就是一个料号，颜色、尺寸作为料号的两个属性，不同颜色、尺寸不再生成子料号
# Modify.........: No:MOD-EA0134 14/10/27 By Alberti 修正 將異動別(bmy03)=6 替代變更 -> 取/替代變更，相對應的控卡也一併做更改(CHI-C20060) 
# Modify.........: No:FUN-F50035 15/06/02 By Lisa 新增與APS整合時,單身可維護vlr_file及vls_file資訊，並於確認後將資料update至vmo_file及vmq_file
# Modify.........: No:FUN-F80027 15/08/17 By Nina 因FUN-EC0082已結案，但程式已被過至正式區，故此單為修正正式區程式，純過單用
# Modify.........: No:MOD-G60007 16/06/04 By catmoon i720_bmb_p2的sql有未考慮跨營運中心的句子
# Modify.........: No:MOD-G90030 16/10/11 By Mandy ima147插件位置與QPA勾稽=N時，若更改插件位置數量並不會更新組成用量
# Modify.........: No:MOD-H30025 17/03/24 By Mandy 取代時不成功s4_ins bmd問題,bmd03 應重新取MAX(bmd03)+1 而不是直接給1
# Modify.........: No:0000664623_06_M014 18/02/05 By TSD.Andy 變異別='4'時，檢查取替代料號不得為空
# Modify.........: 20190122 By momo 判斷變異別新舊元件單位不同時，底數與組成用量需有值
# Modify.........: No:2010195341 20201023 By momo ECN 單據確 需依生效日依序執行
# Mdofiy.........: No:2011265491 20201204 若勾選停產，將該資訊回寫至料件主檔
# Modify.........: No:2012235638 20201223 by momo 調整 TY 確認時生效日不可小於當日
#                                                 調整 停產卡控，只提示不強制
# Modify.........: No:23030031/2 20230317 By momo 生效日期卡控調整為不分營運中心
# Modify.........: No:23080027   20230830 By momo 同步停產，依『資料中心拋轉設定作業(aooi602)
# Modify.........: No:24050007   20240508 By momo 優化cbm-003錯誤訊息提示，增加主件資訊，以利快速排除


DATABASE ds
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../4gl/abmi720.global"
GLOBALS "../../../tiptop/sub/4gl/s_data_center.global"   

FUNCTION i720sub_lock_cl() 
  DEFINE l_forupd_sql STRING

  CALL i720sub_get_dbs_sep(g_plant) RETURNING g_dbs_sep
  LET l_forupd_sql = "SELECT * FROM ",g_dbs_sep CLIPPED,"bmx_file WHERE bmx01 = ? FOR UPDATE " #FUN-AC0060(110705) mod
  LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)                                               #FUN-AC0060(110705) add
  DECLARE i720sub_cl CURSOR FROM l_forupd_sql
END FUNCTION

FUNCTION i720sub_y_chk(p_bmx01)
DEFINE p_bmx01     LIKE bmx_file.bmx01
DEFINE l_cnt       LIKE type_file.num5     
DEFINE l_str       LIKE type_file.chr4     
DEFINE l_pml04     LIKE pml_file.pml04
DEFINE l_imaacti   LIKE ima_file.imaacti
DEFINE l_ima140    LIKE ima_file.ima140

   WHENEVER ERROR CONTINUE
   LET g_bmx.bmx01 = p_bmx01
   IF g_prog = 'aws_ttsrv2' THEN 
       LET g_action_choice = 'confirm' 
       LET g_argv1_str = '1' #FUN-AC0060 add  #CHI-CA0035 mod g_argv3->g_argv1
   END IF
   LET g_success = 'Y'
   IF s_shut(0) THEN RETURN END IF

   ##--- 20201023 add by momo - ECN 單據確 需依生效日依序執行(S) 
   #IF g_plant = 'KS' THEN
   #   LET l_cnt = 0
   #   SELECT COUNT(*) INTO l_cnt
   #     FROM bmx_file
   #    WHERE bmx07 < g_bmx.bmx07 AND bmx04='N'
   #      AND bmx01 <> g_bmx.bmx01               #20201124
   #   IF l_cnt > 0 THEN
   #      CALL cl_err('','cbm-009',1)
   #      LET g_success = 'N'
   #      RETURN
   #   END IF
   #END IF
   ##--- 20201023 add by momo - ECN 單據確 需依生效日依序執行(E)

   ##----- 20180517 by momo (S) 檢核是否有存在元件群組取替代
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM boa_file
           WHERE boa01= b_bmy.bmy14 AND boa03=b_bmy.bmy05
         AND (boa07 IS NULL OR boa07 > g_today)
         IF l_cnt > 0 THEN
            CALL s_errmsg('bmx01',b_bmy.bmy05,b_bmy.bmy14,'cbm-003',1)   #20240508 modify
            LET g_success='N'
            RETURN                                                      #20240508
         END IF
   ##----- 20180517 by momo (E)

   ##--- 20230317 modify by momo 不分營運中心
   ##--- 20201223 add by momo (S) 生效日不可小於當日
   #IF g_plant[1,2] = 'TY' AND g_bmx.bmx07 < g_today THEN
   IF g_bmx.bmx07 < g_today THEN
      UPDATE bmx_file SET bmx07=g_today WHERE bmx01=g_bmx.bmx01
   END IF
   ##--- 20201223 add by momo (E) 生效日不可小於當日

#CHI-C30107 -------- add  -------- begin
   IF cl_null(g_bmx.bmx01) THEN CALL cl_err('',-400,0) RETURN END IF

   IF g_bmx.bmx04='X'      THEN
      LET g_showmsg = g_bmx.bmx01
      CALL s_errmsg('bmx01',g_plant,g_showmsg,'9024',1)
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_prog <> 'aws_ttsrv2' THEN #FUN-D10146 add if 判斷
       IF g_bmx.bmx04='Y'      THEN
          LET g_showmsg = g_bmx.bmx01
          CALL s_errmsg('bmx01',g_plant,g_showmsg,'9023',1)
          LET g_success = 'N'
          RETURN
       END IF
   END IF #FUN-D10146 add end if
   IF g_bmx.bmxacti= 'N' THEN
      LET g_showmsg = g_bmx.bmx01
      CALL s_errmsg('bmx01',g_plant,g_showmsg,'mfg0301',1)
      LET g_success = 'N'
   END IF
   IF g_action_choice CLIPPED = "confirm"       #按「確認」時
   OR g_action_choice CLIPPED = "insert"        #FUN-B80071 add
   THEN
      IF g_prog <> 'aws_ttsrv2' THEN
          IF NOT cl_null(g_argv3_str) AND g_argv3_str <> 'abmp701' THEN  #CHI-CA0035 mod g_argv2->g_argv3
              IF NOT cl_confirm('axm-108') THEN
                 LET g_success = "N"
                 RETURN
              END IF
          END IF
      END IF
   END IF
#CHI-C30107 -------- add -------- end
   CALL i720sub_get_dbs_sep(g_plant) RETURNING g_dbs_sep
  #LET g_sql = "SELECT bmx_file.ROWID,bmx_file.* FROM ",g_dbs_sep CLIPPED,"bmx_file WHERE bmx01 = '",g_bmx.bmx01,"'" #FUN-AC0060(110705) mark
   LET g_sql = "SELECT                bmx_file.* FROM ",g_dbs_sep CLIPPED,"bmx_file WHERE bmx01 = '",g_bmx.bmx01,"'" #FUN-AC0060(110705) add
   PREPARE i720sub_sel_p1 FROM g_sql
  #EXECUTE i720sub_sel_p1 INTO g_bmx_rowid,g_bmx.* #FUN-AC0060(110705) mark
   EXECUTE i720sub_sel_p1 INTO             g_bmx.* #FUN-AC0060(110705) add
   IF cl_null(g_bmx.bmx01) THEN CALL cl_err('',-400,0) RETURN END IF

   IF g_bmx.bmx04='X'      THEN
      LET g_showmsg = g_bmx.bmx01                    
      CALL s_errmsg('bmx01',g_plant,g_showmsg,'9024',1)
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_bmx.bmx04='Y'      THEN
      LET g_showmsg = g_bmx.bmx01                    
      CALL s_errmsg('bmx01',g_plant,g_showmsg,'9023',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_bmx.bmxacti= 'N' THEN
      LET g_showmsg = g_bmx.bmx01                    
      CALL s_errmsg('bmx01',g_plant,g_showmsg,'mfg0301',1)
      LET g_success = 'N'
   END IF

   CALL i720sub_y_chk_bmy()
   IF g_success = 'N' THEN
       RETURN
   END IF
  #MOD-E10080--begin
  #MOD-E30067--mark--begin
   #CALL i720sub_y_chk_bmy3()
   #IF g_success = 'N' THEN
   #    RETURN
   #END IF
  #MOD-E30067--mark--end
  #MOD-E10080--end
  #MOD-C20154 str add-----
   CALL i720sub_y_chk_bmy2()
   IF g_success = 'N' THEN
       RETURN
   END IF
  #MOD-C20154 end add-----

   LET l_cnt =0
   LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmy_file",
               " WHERE bmy01 = '",g_bmx.bmx01,"'"
   PREPARE i720sub_sel_p2 FROM g_sql
   EXECUTE i720sub_sel_p2 INTO l_cnt
   IF l_cnt=0 OR cl_null(l_cnt) THEN
      LET g_showmsg = g_bmx.bmx01                    
      CALL s_errmsg('bmx01',g_plant,g_showmsg,'mfg-008',1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION

FUNCTION i720sub_y_upd(p_bmx01,p_carry)
DEFINE p_bmx01    LIKE bmx_file.bmx01
DEFINE l_gew03    LIKE gew_file.gew03   
DEFINE l_i        LIKE type_file.num10  
DEFINE l_sql      STRING                
DEFINE p_carry    LIKE type_file.chr1

   WHENEVER ERROR CONTINUE

   LET g_bmx.bmx01 = p_bmx01
   LET g_success = 'Y'
   CALL i720sub_get_dbs_sep(g_plant) RETURNING g_dbs_sep
   LET g_sql = "SELECT * FROM ",g_dbs_sep CLIPPED,"sma_file",
               " WHERE sma00 = '0'"
   PREPARE i720sub_sel_p3 FROM g_sql
   EXECUTE i720sub_sel_p3 INTO g_sma.*

  #LET g_sql = "SELECT bmx_file.ROWID,bmx_file.* FROM ",g_dbs_sep CLIPPED,"bmx_file WHERE bmx01 = '",g_bmx.bmx01,"'" #FUN-AC0060(110705) mark
   LET g_sql = "SELECT                bmx_file.* FROM ",g_dbs_sep CLIPPED,"bmx_file WHERE bmx01 = '",g_bmx.bmx01,"'" #FUN-AC0060(110705) add
   PREPARE i720sub_sel_p31 FROM g_sql
  #EXECUTE i720sub_sel_p31 INTO g_bmx_rowid,g_bmx.* #FUN-AC0060(110705) mark
   EXECUTE i720sub_sel_p31 INTO             g_bmx.* #FUN-AC0060(110705) add

   CALL i720sub_lock_cl()
   IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'u') THEN                                                                           
       LET g_showmsg = g_plant,":",g_bmx.bmx01                    
       CALL s_errmsg('bmx11',g_bmx.bmx11,g_showmsg,'aoo-045',1)
       RETURN                                                                                                                       
   END IF                                                                                                                          
   IF g_action_choice CLIPPED = "confirm"       #按「確認」時
   OR g_action_choice CLIPPED = "insert"        #FUN-B80071 add
   THEN
       IF g_bmx.bmxmksg='Y' THEN
           IF g_bmx.bmx09 != '1' THEN
               LET g_showmsg = g_plant,":",g_bmx.bmx09                    
               CALL s_errmsg('bmx09',g_bmx.bmx09,g_showmsg,'aws-078',1)
               #CALL cl_err('','aws-078',1)
               LET g_success = 'N'
               RETURN
           END IF
       END IF
       IF g_bmx.bmx04 = 'Y' THEN RETURN END IF
     #IF g_argv2_str <> 'abmp701' THEN 
#CHI-C30107 -------- mark -------- begin
#     IF g_prog <> 'aws_ttsrv2' THEN
#         IF NOT cl_null(g_argv2_str) AND g_argv2_str <> 'abmp701' THEN
#             IF NOT cl_confirm('axm-108') THEN 
#                LET g_success = "N" 
#                RETURN
#             END IF
#         END IF
#     END IF                            
#CHI-C30107 -------- mark -------- end      
   END IF
   IF g_prog <> 'aws_ttsrv2' THEN
       BEGIN WORK  
   END IF

  #OPEN i720sub_cl USING g_bmx_rowid #FUN-AC0060(110705) mark
   OPEN i720sub_cl USING g_bmx.bmx01 #FUN-AC0060(110705) add
   IF STATUS THEN
      LET g_success = 'N'
      LET g_showmsg = g_bmx.bmx01,' OPEN i720sub_cl:'                    
      CALL s_errmsg('bmx01',g_plant,g_showmsg,STATUS,1)
      CLOSE i720sub_cl
      IF g_prog <> 'aws_ttsrv2' THEN
          ROLLBACK WORK    
      END IF
      RETURN
   END IF
   FETCH i720sub_cl INTO g_bmx.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      LET g_showmsg = g_bmx.bmx01,' i720sub_cl fetch:'                    
      CALL s_errmsg('bmx01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
      CLOSE i720sub_cl
      IF g_prog <> 'aws_ttsrv2' THEN
          ROLLBACK WORK    
      END IF
      RETURN
   END IF

   LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmx_file",
               "   SET bmx04 = 'Y',",
               "       bmx09 = '1' ",
               " WHERE bmx01 = '",g_bmx.bmx01,"'"
   PREPARE i720sub_upd_p1 FROM g_sql
   EXECUTE i720sub_upd_p1
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       LET g_showmsg = g_bmx.bmx01,' update bmx04,bmx09:'                    
       CALL s_errmsg('bmx01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
       LET g_success='N'
       IF g_prog <> 'aws_ttsrv2' THEN
           ROLLBACK WORK  
       END IF
       RETURN        
   END IF

   CALL i720sub_y()    
   CALL i720sub_y2()   
   IF g_success = 'Y' THEN
      IF g_bmx.bmxmksg = 'Y' THEN
         CASE aws_efapp_formapproval()
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                   LET g_bmx.bmx04="N"
                   LET g_success = "N"
                   ROLLBACK WORK    
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                   LET g_bmx.bmx04="N"
                   ROLLBACK WORK   
                   RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET g_bmx.bmx09='1'
         LET g_bmx.bmx04='Y'
         IF g_prog <> 'aws_ttsrv2' THEN 
             COMMIT WORK    
             CALL cl_flow_notify(g_bmx.bmx01,'Y')
             LET g_showmsg = g_bmx.bmx01                    
             CALL s_errmsg('bmx01',g_plant,g_showmsg,'abm-983',0)
         END IF 
      ELSE
         LET g_bmx.bmx04='N'
         LET g_success = 'N'
         LET g_showmsg = g_bmx.bmx01                    
         CALL s_errmsg('bmx01',g_plant,g_showmsg,'abm-984',0)
         IF g_prog <> 'aws_ttsrv2' THEN
             ROLLBACK WORK    
         END IF
         RETURN
      END IF
   ELSE
      LET g_bmx.bmx04='N'
      LET g_success = 'N'
      IF g_prog <> 'aws_ttsrv2' THEN
          ROLLBACK WORK    
      END IF
      RETURN
   END IF
   #CKP
   LET g_sql = "SELECT * FROM ",g_dbs_sep CLIPPED,"bmx_file WHERE bmx01 = '",g_bmx.bmx01,"'"
   PREPARE i720sub_sel_p4 FROM g_sql
   EXECUTE i720sub_sel_p4 INTO g_bmx.*

   IF p_carry = 'Y' THEN
       LET g_sql = "SELECT gev04 FROM ",g_dbs_sep CLIPPED,"gev_file ",
                   " WHERE gev01 = '3' ",
                   "   AND gev02 = '",g_plant,"'",
                   "   AND gev03 = 'Y' "
       PREPARE i720sub_sel_p5 FROM g_sql
       EXECUTE i720sub_sel_p5 INTO g_gev04
       IF NOT cl_null(g_gev04) THEN 
           SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
            WHERE gew01 = g_gev04 AND gew02 = '3'
           IF l_gew03 = '1' THEN #自動拋轉
               #開窗選擇拋轉的db清單                                                                                                            
               LET l_sql = "SELECT COUNT(*) FROM &bmx_file WHERE bmx01='",g_bmx.bmx01,"'"                                                       
               CALL s_dc_sel_db1(g_gev04,'3',l_sql)                                                                                             
               IF INT_FLAG THEN                                                                                                                 
                  LET INT_FLAG=0                                                                                                                
                  RETURN                                                                                                                        
               END IF
                                                                                                                                                
               CALL g_bmxx.clear()                                                                                                              
               LET g_bmxx[1].sel = 'Y'                                                                                                          
               LET g_bmxx[1].bmx01 = g_bmx.bmx01 
               FOR l_i = 1 TO g_azp1.getLength()                                                                                                
                   LET g_azp[l_i].sel   = g_azp1[l_i].sel                                                                                       
                   LET g_azp[l_i].azp01 = g_azp1[l_i].azp01                                                                                     
                   LET g_azp[l_i].azp02 = g_azp1[l_i].azp02                                                                                     
                   LET g_azp[l_i].azp03 = g_azp1[l_i].azp03                                                                                     
               END FOR
                                                                                                                                               
               CALL s_showmsg_init()                                                                                                            
               CALL s_abmi710_carry_bmx(g_bmxx,g_azp,g_gev04,'0')                                       
               CALL s_showmsg()                                                                                                                 
           END IF
       END IF
   END IF 
END FUNCTION

#確認時檢查單據中所有的主件+元件是否有未確認的單據存在資料庫且生效日在本張單據之前
FUNCTION i720sub_y_chk_bmy()  
DEFINE i,j      LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_sql    STRING
DEFINE l_n      LIKE type_file.num5    
DEFINE l_bmy05  LIKE bmy_file.bmy05    
DEFINE l_bmy13  LIKE bmy_file.bmy13    
DEFINE l_bma    RECORD LIKE bma_file.* 
DEFINE l_bmy    RECORD LIKE bmy_file.* 
DEFINE l_run_del LIKE type_file.chr1   
DEFINE l_str1_bma STRING
DEFINE l_str2_bma STRING
DEFINE l_str3_bma STRING
DEFINE l_bmy29  LIKE bmy_file.bmy29           #MOD-B40205 add
DEFINE l_bmy02  LIKE bmy_file.bmy02   #M014 180208 By TSD.Tim

   LET l_flag= 'N'
   LET g_chk1 = 'N'
  #CHI-E20026-Start-Mark 
  #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmy_file a,",g_dbs_sep CLIPPED,"ima_file ",
  #            " WHERE a.bmy01 = '",g_bmx.bmx01,"'",
  #            "   AND a.bmy03 = '2' ",
  #            "   AND exists (SELECT * FROM ",g_dbs_sep CLIPPED,"bma_file WHERE a.bmy05 = bma01) ",
  #            "   AND ima01 = a.bmy05 ",
  #            "   AND ima151 != 'Y' ",
  #            "   AND exists (SELECT * FROM ",g_dbs_sep CLIPPED,"bmy_file WHERE bmy14 = a.bmy05 AND bmy01 = '",g_bmx.bmx01,"')"
  #PREPARE i720sub_sel_p6 FROM g_sql
  #EXECUTE i720sub_sel_p6 INTO l_n
  #
  #IF l_n >0 THEN
  #   LET l_run_del = 'N'   
  #   IF g_prog = 'aws_ttsrv2' THEN
  #       LET l_run_del = 'Y'   
  #   ELSE
  #       IF cl_confirm('abm-150')  THEN      
  #           LET l_run_del = 'Y'   
  #       END IF
  #   END IF
  #   IF l_run_del = 'Y' THEN
  #      LET g_chk1 = 'Y'
  #     #LET g_sql = "SELECT bmy05,bmy13 FROM ",g_dbs_sep CLIPPED,"bmy_file a,",g_dbs_sep CLIPPED,"ima_file ",    #MOD-B40205 mark
  #      LET g_sql = "SELECT bmy05,bmy29 FROM ",g_dbs_sep CLIPPED,"bmy_file a,",g_dbs_sep CLIPPED,"ima_file ",    #MOD-B40205 add
  #                  " WHERE a.bmy01 = '",g_bmx.bmx01,"'",
  #                  "   AND a.bmy03 = '2' ",
  #                  "   AND exists (SELECT * FROM ",g_dbs_sep CLIPPED,"bma_file WHERE  a.bmy05 = bma01)",
  #                  "   AND ima01 = a.bmy05 ",
  #                  "   AND ima151!= 'Y' ",
  #                  "   AND exists (SELECT * FROM ",g_dbs_sep CLIPPED,"bmy_file ",
  #                  "                WHERE bmy14 = a.bmy05 ",
  #                  "                  AND bmy01 = '",g_bmx.bmx01,"')"  
  #      PREPARE i720sub_del_bmy01_p1 FROM g_sql
  #      DECLARE i720sub_del_bmy01 CURSOR FOR i720sub_del_bmy01_p1

  #      LET g_sql = "DELETE FROM ",g_dbs_sep CLIPPED,"bmb_file WHERE bmb01 = ? AND bmb29 = ? "
  #      PREPARE i720sub_del_bmb1 FROM g_sql

  #      LET g_sql = "DELETE FROM ",g_dbs_sep CLIPPED,"bmt_file WHERE bmt01 = ? AND bmt08 = ? "
  #      PREPARE i720sub_del_bmt1 FROM g_sql

  #      LET g_sql = "DELETE FROM ",g_dbs_sep CLIPPED,"bmd_file WHERE bmd01 = ? "
  #      PREPARE i720sub_del_bmd FROM g_sql
  #     #MOD-B40205---modify---start---
  #      #FOREACH i720sub_del_bmy01 INTO l_bmy05,l_bmy13        
  #     #  EXECUTE i720sub_del_bmb1 USING l_bmy05,l_bmy13    
  #      FOREACH i720sub_del_bmy01 INTO l_bmy05,l_bmy29               
  #        EXECUTE i720sub_del_bmb1 USING l_bmy05,l_bmy29    
  #     #MOD-B40205---modify---end--- 
  #        IF SQLCA.sqlcode THEN 
  #           LET g_success = 'N'
  #           RETURN
  #        END IF 
  #        EXECUTE i720sub_del_bmt1 USING l_bmy05,l_bmy13  
  #        IF SQLCA.sqlcode THEN 
  #           LET g_success = 'N'
  #           RETURN
  #        END IF 
  #        EXECUTE i720sub_del_bmd USING l_bmy05
  #        IF SQLCA.sqlcode THEN 
  #           LET g_success = 'N'
  #           RETURN
  #        END IF 
  #      END FOREACH
  #   END IF 
  #END IF 
  #CHI-E20026-End-Mark 

   LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmy_file ",
               " WHERE NOT exists (SELECT * FROM ",g_dbs_sep CLIPPED,"bma_file WHERE bmy05 = bma01) ",
               "   AND bmy05 IN (SELECT bmy14 FROM ",g_dbs_sep CLIPPED,"bmy_file ",
               "                  WHERE bmy01 = '",g_bmx.bmx01,"'",
               "                    AND bmy03 = '2') ",
               "   AND bmy01 = '",g_bmx.bmx01,"'",
               "   AND bmy03 = '2' "
   PREPARE i720sub_sel_p7 FROM g_sql
   EXECUTE i720sub_sel_p7 INTO l_n

   IF l_n >0 THEN
         LET g_sql = "SELECT  * FROM ",g_dbs_sep CLIPPED,"bmy_file ",
                     " WHERE bmy01 = '",g_bmx.bmx01,"'",
                     "   AND bmy03 = '2' ",
                     "   AND  NOT exists (SELECT * FROM ",g_dbs_sep CLIPPED,"bma_file WHERE bmy05 = bma01) ",
                     "   AND bmy05 IN (SELECT bmy14 FROM ",g_dbs_sep CLIPPED,"bmy_file ",
                     "                  WHERE bmy01 = '",g_bmx.bmx01,"'",
                     "                    AND bmy03 = '2') "
         PREPARE i720sub_del_bmy02_p FROM g_sql
         DECLARE i720sub_del_bmy02 CURSOR FOR i720sub_del_bmy02_p

         CALL s_carry_p_cs()
         CALL s_carry_col('bma_file') RETURNING l_str1_bma,l_str2_bma,l_str3_bma
         LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bma_file",
                     " VALUES(",l_str2_bma,")"
         PREPARE i720sub_ins_bma FROM g_sql

         FOREACH i720sub_del_bmy02 INTO l_bmy.*       
           LET l_bma.bma01 = l_bmy.bmy05
           LET l_bma.bma06 = l_bmy.bmy13
           LET l_bma.bma10 = '2' 
           LET l_bma.bma05 = g_today
           LET l_bma.bma04 =' '
           LET l_bma.bma08 = ' '
           LET l_bma.bmaacti = 'Y'
           LET l_bma.bmauser =g_user
           LET l_bma.bmagrup =g_grup
           EXECUTE i720sub_ins_bma USING l_bma.*
           IF SQLCA.sqlcode THEN 
              LET g_success = 'N'
              RETURN
           END IF 
         END FOREACH
   END IF 
   FOR i = 1 TO g_bmy.getLength()                                                                                               
       IF cl_null(g_bmy[i].bmy04) THEN 
           LET l_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmx_file,",g_dbs_sep CLIPPED,"bmy_file ",
                     " WHERE bmx01 = bmy01 ",
                     "   AND bmx01 <> '",g_bmx.bmx01,"'",     #單號
                     "   AND bmy14 =  '",g_bmy[i].bmy14,"' ", #主件編號
                     "   AND bmy05 =  '",g_bmy[i].bmy05,"'",  #元件編號
                     "   AND bmx07 <  '",g_bmx.bmx07,"'",     #生效日
                     "   AND bmx04 =  'N'"                    #確認碼 
       ELSE
           LET l_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmx_file,",g_dbs_sep CLIPPED,"bmy_file ",
                     " WHERE bmx01 = bmy01",
                     "   AND bmx01 <> '",g_bmx.bmx01,"'",     #單號
                     "   AND bmy14 =  '",g_bmy[i].bmy14,"' ", #主件編號
                     "   AND bmy05 =  '",g_bmy[i].bmy05,"'",  #元件編號
                     "   AND bmx07 <  '",g_bmx.bmx07,"'",     #生效日
                    #"   AND bmy04 =  ",g_bmy[i].bmy04,"'",   #BOM項次  #FUN-E70037  mark
                     "   AND bmy04 =  '",g_bmy[i].bmy04,"'",  #BOM項次  #FUN-E70037  modify
                     "   AND bmx04 =  'N'"                    #確認碼 
       END IF
       PREPARE i720sub_chk_bmy_p FROM l_sql
       DECLARE i720sub_chk_bmy_c CURSOR FOR i720sub_chk_bmy_p
       LET l_flag= 'N'
       OPEN i720sub_chk_bmy_c 
       FETCH i720sub_chk_bmy_c INTO l_count
       CLOSE i720sub_chk_bmy_c
       CASE
           WHEN l_count > 0 
               LET g_showmsg = g_bmy[i].bmy14,'/',g_bmy[i].bmy05                    
               CALL s_errmsg('bmy14,bmy05',g_plant,g_showmsg,'abm-821',1)
               LET l_flag = 'Y'
               LET g_success = 'N'
               EXIT FOR
               OTHERWISE
               CONTINUE FOR
       END CASE
       IF l_flag = 'Y' THEN
           EXIT FOR
       END IF
   END FOR
   #M014 180205 By TSD.Andy -----(S)
   LET l_sql = "SELECT bmy02 FROM ",g_dbs_sep CLIPPED,"bmx_file,",g_dbs_sep CLIPPED,"bmy_file ",
              " WHERE bmx01 = bmy01 ",
              "   AND bmx01 = '",g_bmx.bmx01,"'",     #單號
              "   AND bmy03 = '4' ",
              "   AND bmy27 IS NULL ",
              " ORDER BY bmy02 "
   PREPARE i720_sel_bmy_p FROM l_sql
   DECLARE i720_sel_bmy_c CURSOR FOR i720_sel_bmy_p
   
   FOREACH i720_sel_bmy_c INTO l_bmy02
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('bmy02',l_bmy02,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      CALL s_errmsg('bmy02',l_bmy02,'','TSD0046',1)  #取替代料號不得為空，無法確認!
      LET g_success = 'N'
   END FOREACH
   #M014 180205 By TSD.Andy -----(E)

   ##---- 20190122 add by momo(S)
   LET l_sql = "SELECT bmy02,COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmx_file,",g_dbs_sep CLIPPED,"bmy_file, ",
                                       g_dbs_sep CLIPPED,"ima_file a,",g_dbs_sep CLIPPED,"ima_file b ",
              " WHERE bmx01 = bmy01 ",
              "   AND bmx01 = '",g_bmx.bmx01,"'",     #單號
              "   AND bmy05 = a.ima01 and bmy27=b.ima01 ",
              "   AND a.ima25<>b.ima25 ",
              "   AND (NVL(bmy06,0)=0 OR NVL(bmy07,0)=0) ",
              " GROUP BY bmy02 "
              
   PREPARE i720_sel_bmy_p1 FROM l_sql
   DECLARE i720_sel_bmy_c1 CURSOR FOR i720_sel_bmy_p1

   FOREACH i720_sel_bmy_c1 INTO l_bmy02,l_count
      IF l_count > 0 THEN
         CALL s_errmsg('bmy02',l_bmy02,'','cbm-006',1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

   END FOREACH
   ##---- 20190122 add by momo(E)
END FUNCTION

#MOD-E10080--begin
#確認時檢查單據中所有的主件+元件是否有確認的單據存在資料庫且生效日在本張單據之前或同時
FUNCTION i720sub_y_chk_bmy3()
DEFINE i,j      LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_sql    STRING

   FOR i = 1 TO g_bmy.getLength()
       IF cl_null(g_bmy[i].bmy04) THEN
           LET l_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmx_file,",g_dbs_sep CLIPPED,"bmy_file,",g_dbs_sep CLIPPED,"bmz_file ",
                     " WHERE bmx01 = bmy01 ",
                     "   AND bmx01 = bmz01 ",
                     "   AND bmx01 <> '",g_bmx.bmx01,"'",     #單號
                    #"   AND bmy14 =  '",g_bmy[i].bmy14,"' ", #主件編號
                     "   AND bmz02 =  '",g_bmy[i].bmy14,"' ", #主件編號
                     "   AND bmy05 =  '",g_bmy[i].bmy05,"'",  #元件編號
                     "   AND bmx07 <= '",g_bmx.bmx07,"'",     #生效日
                     "   AND bmx04 =  'Y'"                    #確認碼
       ELSE
           LET l_sql="SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmx_file,",g_dbs_sep CLIPPED,"bmy_file,",g_dbs_sep CLIPPED,"bmz_file ",
                     " WHERE bmx01 = bmy01",
                     "   AND bmx01 = bmz01 ",
                     "   AND bmx01 <> '",g_bmx.bmx01,"'",     #單號
                    #"   AND bmy14 =  '",g_bmy[i].bmy14,"' ", #主件編號
                     "   AND bmz02 =  '",g_bmy[i].bmy14,"' ", #主件編號
                     "   AND bmy05 =  '",g_bmy[i].bmy05,"'",  #元件編號
                     "   AND bmx07 <= '",g_bmx.bmx07,"'",     #生效日
                     "   AND bmy04 =  ",g_bmy[i].bmy04,"'",   #BOM項次
                     "   AND bmx04 =  'Y'"                    #確認碼
       END IF
       PREPARE i720sub_chk_bmy_p1 FROM l_sql
       DECLARE i720sub_chk_bmy_c1 CURSOR FOR i720sub_chk_bmy_p1
       LET l_flag= 'N'
       OPEN i720sub_chk_bmy_c1
       FETCH i720sub_chk_bmy_c1 INTO l_count
       CLOSE i720sub_chk_bmy_c1
       CASE
           WHEN l_count > 0
               LET g_showmsg = g_bmy[i].bmy14,'/',g_bmy[i].bmy05
               CALL s_errmsg('bmy14,bmy05',g_plant,g_showmsg,'abm-822',1)
               LET l_flag = 'Y'
               LET g_success = 'N'
               EXIT FOR
               OTHERWISE
               CONTINUE FOR
       END CASE
       IF l_flag = 'Y' THEN
           EXIT FOR
       END IF
   END FOR
END FUNCTION
#MOD-E10080--end
FUNCTION i720sub_y()
DEFINE l_str            STRING                  
DEFINE l_cnt      LIKE  type_file.num5          
DEFINE l_sql      STRING                        
DEFINE l_chr      LIKE type_file.chr5           
DEFINE l_ima86    LIKE ima_file.ima86           
DEFINE l_item     LIKE ima_file.ima01           
DEFINE l_bmd07    LIKE bmd_file.bmd07  #CHI-C20060

     IF s_industry('slk') THEN 
         CALL i720sub_chk_mutli() RETURNING l_chr
         IF l_chr=0 THEN 
           CALL cl_err('','abm-035',1)
           LET g_success = 'N'
           RETURN 
         END IF 
     END IF 
     LET g_last_seq=NULL
     LET g_sql = "SELECT * FROM ",g_dbs_sep CLIPPED,"bmy_file",
                 " WHERE bmy01 = '",g_bmx.bmx01,"'",   #MOD-BB0164 add ,
                 "     ORDER BY bmy03"                 #MOD-BB0164 add
     PREPARE i720sub_y_p FROM g_sql
     DECLARE i720sub_y_c2 CURSOR FOR i720sub_y_p
     CALL s_showmsg_init()                             #20240508
     FOREACH i720sub_y_c2 INTO b_bmy.*
        IF cl_null(b_bmy.bmy05) THEN CONTINUE FOREACH END IF

         #No.FUN-AB0058  --Begin
         IF NOT cl_null(b_bmy.bmy25) THEN
            IF NOT s_chk_ware(b_bmy.bmy25) THEN  #检查仓库是否属于当前门店
               LET g_success='N'
               RETURN
            END IF
         END IF
         #No.FUN-AB0058  --End 

         ##----- 20180517 by momo (S) 檢核是否有存在元件群組取替代
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM boa_file
           WHERE boa01= b_bmy.bmy14 AND boa03=b_bmy.bmy05
         AND (boa07 IS NULL OR boa07 > g_today)
         IF l_cnt > 0 THEN 
            #CALL cl_err(b_bmy.bmy05,'cbm-003',1)                        #20240508 mark 
            CALL s_errmsg('bmx01',b_bmy.bmy05,b_bmy.bmy14,'cbm-003',1)   #20240508 modify
            LET g_success='N'
            CONTINUE FOREACH                                             #20240508
            #RETURN                                                      #20240508
         END IF
         ##----- 20180517 by momo (E)

        IF b_bmy.bmy03 = '4' THEN
           LET l_item = b_bmy.bmy27
        ELSE
           LET l_item = b_bmy.bmy05
        END IF
     

        LET g_sql = "SELECT ima86 FROM ",g_dbs_sep CLIPPED,"ima_file",
                    " WHERE ima01 = '",l_item,"'"
        PREPARE i720sub_sel_p8 FROM g_sql
        EXECUTE i720sub_sel_p8 INTO l_ima86

        IF cl_null(b_bmy.bmy10_fac2) THEN
           IF b_bmy.bmy10 != l_ima86  #發料/成本單位
              THEN
             #CALL s_umfchk(l_item,b_bmy.bmy10,l_ima86)
             #CALL s_umfchkm(l_item,b_bmy.bmy10,l_ima86,g_dbs_sep) #TQC-B20005 mod #FUN-B70076 mark
              CALL s_umfchkm(l_item,b_bmy.bmy10,l_ima86,g_plant)                   #FUN-B70076 add
                RETURNING g_sw_chr1,b_bmy.bmy10_fac2
                IF g_sw_chr1 THEN
                  CALL cl_err(b_bmy.bmy05,'mfg2722',0)
                END IF
           ELSE
              LET b_bmy.bmy10_fac2 = 1
           END IF
        END IF
        IF g_argv1_str='1' THEN  #No.FUN-A60008 #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
            LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bma_file ",
                        "   SET bmamodu = ?,",
                        "       bmadate = ? ",
                        " WHERE bma01 = '",b_bmy.bmy14,"'",
                        "   AND bma06 = '",b_bmy.bmy29,"'"
            PREPARE i720sub_upd_p2 FROM g_sql
            EXECUTE i720sub_upd_p2 USING g_user,g_today
    
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","bma_file",g_user,g_today,SQLCA.sqlcode,"","upd bma:",1) # TQC-660046
               LET g_success='N'
               RETURN
            END IF
       #No.FUN-A60008--begin   
        ELSE 
            LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bra_file ",
                        "   SET bramodu = ?,",
                        "       bradate = ? ",
                        " WHERE bra01 = '",b_bmy.bmy14 ,"'",
                        "   AND bra011= '",b_bmy.bmy011,"'",
                       #"   AND bra012= '",b_bmy.bmy012,"'",  #MOD-E70053 mark
                       #"   AND bra013= '",b_bmy.bmy013,"'",  #MOD-E70053 mark
                        "   AND bra06 = '",b_bmy.bmy29,"'"
           PREPARE i720sub_upd_p_bra FROM g_sql
           EXECUTE i720sub_upd_p_bra USING g_user,g_today
   
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","bra_file",g_user,g_today,SQLCA.sqlcode,"","upd bra:",1) 
              LET g_success='N'
              RETURN
           END IF
        END IF 
       #No.FUN-A60008--end 

        LET l_str = b_bmy.bmy02,' ',b_bmy.bmy05
        CALL cl_msg(l_str)

       #==>有指定項次時不問
       IF g_action_choice CLIPPED = "confirm" THEN      #按「確認」時 
          IF cl_null(b_bmy.bmy04) OR b_bmy.bmy04 = ' ' THEN
              IF g_argv1_str='1' THEN  #No.FUN-A60008 #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
                  #--多元件時要詢問是否更新
                  LET l_cnt = 0
                  LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmb_file",
                              " WHERE bmb01 = '",b_bmy.bmy14,"'",
                              "   AND bmb03 = '",b_bmy.bmy05,"'",
                              "   AND (bmb05 IS NULL ",
                              "        OR bmb05 > '",g_bmx.bmx07,"')"
                  PREPARE i720sub_sel_p9 FROM g_sql
                  EXECUTE i720sub_sel_p9 INTO l_cnt
              #No.FUN-A60008--begin
              ELSE
                  LET l_cnt = 0
                  LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"brb_file",
                              " WHERE brb01 = '",b_bmy.bmy14,"'",  
                              "   AND brb03 = '",b_bmy.bmy05,"'",
                              "   AND brb011= '",b_bmy.bmy011,"'",
                              "   AND brb012= '",b_bmy.bmy012,"'",
                              "   AND brb013= '",b_bmy.bmy013,"'",
                              "   AND (brb05 IS NULL OR brb05 > '",g_bmx.bmx07,"')"
                  PREPARE i720sub_sel_p_brb FROM g_sql
                  EXECUTE i720sub_sel_p_brb INTO l_cnt
              END IF 	    
              #No.FUN-A60008--end    
             IF l_cnt > 1 THEN
                 CALL cl_getmsg('abm-023',g_lang) RETURNING g_msg
                 IF g_argv3_str = 'abmp701' THEN  #CHI-CA0035 mod g_argv2->g_argv3
                     LET g_msg=g_bmx.bmx01 CLIPPED,' : ',g_msg CLIPPED
                 ELSE
                     LET g_msg=g_msg CLIPPED
                 END IF
                 LET INT_FLAG = 0 
             END IF 
          END IF   
        END IF    
        
        #MOD-B80310 --- modify --- start ---
        LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"ima_file",
                    "   SET ima05 = ? ",
                    " WHERE ima01 = ? "
        PREPARE i720sub_upd_p3 FROM g_sql
        #MOD-B80310 --- modify ---  end  ---
        
       #IF b_bmy.bmy03 MATCHES '[1345]' THEN    #MOD-D80031  mark
        IF b_bmy.bmy03 MATCHES '[13456]' THEN   #MOD-D80031  add
           CALL i720sub_s()  #No.FUN-A60008
          #FUN-E70037--add str--
           IF g_success='N' THEN 
              RETURN 
           END IF
          #FUN-E70037--add end--
          #IF NOT cl_null(b_bmy.bmy04) THEN
          #   #LET l_sql ="SELECT ROWID,bmb_file.*  FROM ",g_dbs_sep CLIPPED,"bmb_file ", #FUN-AC0060(110705) mark
          #    LET l_sql ="SELECT       bmb_file.*  FROM ",g_dbs_sep CLIPPED,"bmb_file ", #FUN-AC0060(110705) add
          #               " WHERE bmb01 ='", b_bmy.bmy14 CLIPPED, "'"
          #    IF g_sma.sma118='Y' THEN
          #        LET l_sql=l_sql,"   AND bmb29 ='", b_bmy.bmy29 , "'" #MOD-830242
          #    END IF

          #    LET l_sql=l_sql,"   AND bmb02 =",  b_bmy.bmy04,
          #                    "   AND bmb03 ='", b_bmy.bmy05 CLIPPED, "'",
          #                    "   AND (bmb05 >'", g_bmx.bmx07 CLIPPED ,"' OR bmb05 IS NULL)", 
          #                    "   AND bmb04 = (SELECT MAX(bmb04) FROM ",g_dbs_sep CLIPPED,"bmb_file ",
          #                    "                 WHERE bmb01 = '",b_bmy.bmy14 CLIPPED,"' ",
          #                    "                   AND bmb02 = ",b_bmy.bmy04 CLIPPED,
          #                    "                   AND bmb03 = '",b_bmy.bmy05 CLIPPED,"' ",
          #                    "                   AND (bmb04 <= '",g_bmx.bmx07 CLIPPED,"' OR bmb04 IS NULL) ", 
          #                    "                   AND (bmb05 >  '",g_bmx.bmx07 CLIPPED,"' OR bmb05 IS NULL)) "
          #ELSE
          #   #LET l_sql ="SELECT ROWID,bmb_file.*  FROM ",g_dbs_sep CLIPPED,"bmb_file ", #FUN-AC0060(110705) mark
          #    LET l_sql ="SELECT       bmb_file.*  FROM ",g_dbs_sep CLIPPED,"bmb_file ", #FUN-AC0060(110705) add
          #               " WHERE bmb01 ='", b_bmy.bmy14 CLIPPED, "'"
          #    IF g_sma.sma118='Y' THEN
          #       LET l_sql=l_sql,"   AND bmb29 ='", b_bmy.bmy29 , "'"  
          #    END IF

          #    LET l_sql=l_sql,"   AND bmb03 ='", b_bmy.bmy05 CLIPPED, "'",
          #                    "   AND (bmb05 >'", g_bmx.bmx07 CLIPPED ,"' OR bmb05 IS NULL)"
          #END IF

          #PREPARE i720sub_bmb_pre FROM l_sql
          #DECLARE i720sub_bmb_c2 CURSOR FOR i720sub_bmb_pre
          #MOD-B80310 --- mark --- start ---
          #LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"ima_file",
          #            "   SET ima05 = ? ",
          #            " WHERE ima01 = ? "
          #PREPARE i720sub_upd_p3 FROM g_sql
          #MOD-B80310 --- mark ---  end  ---
          #FOREACH i720sub_bmb_c2 INTO g_bmb_rowid,g_bmb.* #FUN-AC0060(110705) mark
          #FOREACH i720sub_bmb_c2 INTO             g_bmb.* #FUN-AC0060(110705) add
          #  IF STATUS THEN	# 當bmy04 is null時,可能讀出一筆以上
          #     CALL cl_err('sel bmb:',STATUS,1) LET g_success='N' RETURN
          #  END IF
          #  LET g_last_seq=g_bmb.bmb02
          #  CASE
          #       WHEN b_bmy.bmy03='1' CALL i720sub_s1()	# 失效
          #       WHEN b_bmy.bmy03='3' CALL i720sub_s3()	# 修改
          #       WHEN b_bmy.bmy03='4' CALL i720sub_s4()	# 取代
          #       WHEN b_bmy.bmy03='5' CALL i720sub_s4()	# 替代   
          #  END CASE
          #  IF g_success='N' THEN RETURN END IF
          #  EXECUTE i720sub_upd_p3 USING b_bmy.bmy17,b_bmy.bmy14
          #END FOREACH 
        #ELSE                      #CHI-C20060
        END IF                     #CHI-C20060
        IF b_bmy.bmy03 = '2' THEN  #CHI-C20060
           CALL i720sub_s2()   # 新增
           IF g_success='N' THEN 
              ROLLBACK WORK
              RETURN 
           END IF
           EXECUTE i720sub_upd_p3 USING b_bmy.bmy17,b_bmy.bmy14
        END IF
        #CHI-C20060---begin
        IF b_bmy.bmy03 = '6' THEN
            IF cl_null(b_bmy.bmy36) THEN  #FUN-BB0075
               LET l_bmd07 = b_bmy.bmy06/b_bmy.bmy07
               LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmd_file ",
                           "   SET bmd07 = ?",
                           " WHERE bmd08 = '",b_bmy.bmy14,"'",
                           "   AND bmd01 = '",b_bmy.bmy05,"'",
                           "   AND bmd04 = '",b_bmy.bmy27,"'",
                          #"   AND bmd02 = '2' "                  #MOD-EA0134 mark
                           "   AND (bmd02 = '1' OR bmd02 = '2') " #MOD-EA0134 add
               PREPARE i720sub_upd_p14 FROM g_sql
               EXECUTE i720sub_upd_p14 USING l_bmd07
            #FUN-BB0075---begin
            ELSE
               LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmd_file ",
                           "   SET bmd06 = ?",
                           " WHERE bmd08 = '",b_bmy.bmy14,"'",
                           "   AND bmd01 = '",b_bmy.bmy05,"'",
                           "   AND bmd04 = '",b_bmy.bmy27,"'",
                          #"   AND bmd02 = '2' "                  #MOD-EA0134 mark
                           "   AND (bmd02 = '1' OR bmd02 = '2') " #MOD-EA0134 add
               PREPARE i720sub_upd_p15 FROM g_sql
               EXECUTE i720sub_upd_p15 USING b_bmy.bmy36
            END IF 
            #FUN-BB0075---end
            #MOD-D80031-Start-Add
            LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmb_file",
                        "   SET bmb24 = '",g_bmx.bmx01,"',", 
                        "       bmbmodu = '",g_user,"',",
                        "       bmbdate = '",g_today,"'",
                        " WHERE bmb01 = '",g_bmb01,"'",
                        "   AND bmb02 = '",g_bmb02,"'",
                        "   AND bmb03 = '",g_bmb03,"'",
                        "   AND bmb04 = '",g_bmb04,"'",
                        "   AND bmb29 = '",g_bmb29,"'"
           PREPARE i720sub_upd_p20 FROM g_sql
           EXECUTE i720sub_upd_p20
           #MOD-D80031-End-Add
          #FUN-F50035 add str-----
           IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN #與APS整合
              CALL i720_upd_vmo()
              CALL i720_upd_vmq()
           END IF
          #FUN-F50035 add end-----
        END IF 
        #CHI-C20060---end
     END FOREACH
END FUNCTION

FUNCTION i720sub_y2()
  DEFINE l_bmz RECORD LIKE bmz_file.*
  DEFINE l_str1_bmz STRING
  DEFINE l_str2_bmz STRING
  DEFINE l_str3_bmz STRING

     LET g_sql = "SELECT bmy01,bmy14,bmy17,bmy171,bmy29, ",
                 "       bmy011,bmy012 ",
                 "  FROM ",g_dbs_sep CLIPPED,"bmy_file ",
                 " WHERE bmy01 = '",g_bmx.bmx01,"'",
                 " GROUP BY bmy01,bmy14,bmy17,bmy171,bmy29,bmy011,bmy012 "
     PREPARE i720sub_y2_p FROM g_sql
     DECLARE i720sub_y_c3 CURSOR FOR i720sub_y2_p

     CALL s_carry_p_cs()
     CALL s_carry_col('bmz_file') RETURNING l_str1_bmz,l_str2_bmz,l_str3_bmz
     LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmz_file",
                 " VALUES(",l_str2_bmz,")"
     PREPARE i720sub_ins_bmz FROM g_sql

     FOREACH i720sub_y_c3 INTO l_bmz.bmz01,l_bmz.bmz02,l_bmz.bmz03,l_bmz.bmz04,l_bmz.bmz05,l_bmz.bmz011,l_bmz.bmz012    
         IF STATUS THEN
            CALL cl_err('y_c2 err',STATUS,1) LET g_success='N' RETURN
         END IF
         IF cl_null(l_bmz.bmz05) THEN
            LET l_bmz.bmz05 = ' '
         END IF
         LET l_bmz.bmzplant = g_plant 
         LET l_bmz.bmzlegal = g_legal 
         #FUN-AC0060--add---str--
         IF cl_null(l_bmz.bmz011) THEN
            LET l_bmz.bmz011 = ' ' 
         END IF
         #FUN-AC0060--add---end--
         #FUN-A70125 --begin--
         IF cl_null(l_bmz.bmz012) THEN
            LET l_bmz.bmz012 = ' ' 
         END IF 
         IF cl_null(l_bmz.bmz013) THEN
            LET l_bmz.bmz013 = 0 
         END IF 
         #FUN-A70125 --end--
         EXECUTE i720sub_ins_bmz USING l_bmz.*
         IF STATUS AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN 
             LET g_showmsg = l_bmz.bmz01,' ins bmz err:'                    
             CALL s_errmsg('bmz01',g_plant,g_showmsg,STATUS,1)
             LET g_success='N' RETURN
         END IF
     END FOREACH
END FUNCTION

FUNCTION i720sub_chk_mutli()
DEFINE l_chr LIKE type_file.chr1
DEFINE l_n   LIKE type_file.num5
DEFINE l_bmy14 LIKE bmy_file.bmy14 

   LET l_chr = 1
   LET g_sql = "SELECT bmy14 FROM ",g_dbs_sep CLIPPED,"bmx_file,",g_dbs_sep CLIPPED,"bmy_file,",g_dbs_sep CLIPPED,"imx_file ",
               " WHERE bmy01 = bmx01 ",
               "   AND bmx01 = '",g_bmx.bmx01,"'",
               " GROUP BY bmy14 "
   PREPARE i720sub_mutil_p FROM g_sql
   DECLARE i720sub_mutil CURSOR FOR i720sub_mutil_p

   LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmy_file,",g_dbs_sep CLIPPED,"bmx_file ",
               " WHERE bmy14 IN ",
               "  (SELECT imx000 FROM ",g_dbs_sep CLIPPED,"imx_file",
               "    WHERE imx00 = ? )",
               "   AND bmx04 ='N' ",
               "   AND bmy01 = bmx01 "
   PREPARE i720sub_sel_p10 FROM g_sql
   FOREACH i720sub_mutil INTO l_bmy14
      EXECUTE i720sub_sel_p10 INTO l_n USING l_bmy14
      IF l_n >0 THEN 
         LET l_chr=0 
         RETURN l_chr
      END IF 
   END FOREACH 
   RETURN l_chr
END FUNCTION             

##No.FUN-A60008--begin
FUNCTION i720sub_s()
DEFINE l_sql    STRING
DEFINE l_azw06  LIKE azw_file.azw06 

    IF g_argv1_str='1' THEN  #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
       IF NOT cl_null(b_bmy.bmy04) THEN             
           LET l_sql ="SELECT bmb_file.*  FROM ",g_dbs_sep CLIPPED,"bmb_file ",
                      " WHERE bmb01 ='", b_bmy.bmy14 CLIPPED, "'"
           IF g_sma.sma118='Y' THEN
             LET l_sql=l_sql,"   AND bmb29 ='", b_bmy.bmy29 , "'" #MOD-830242
           END IF       
           LET l_sql=l_sql,"   AND bmb02 =",  b_bmy.bmy04,
                      "   AND bmb03 ='", b_bmy.bmy05 CLIPPED, "'",
                      "   AND (bmb05 >'", g_bmx.bmx07 CLIPPED ,"' OR bmb05 IS NULL)", #MOD-6A0109 add ,
                     #"   AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file ",                        #MOD-G60007 mark
                      "   AND bmb04 = (SELECT MAX(bmb04) FROM ",g_dbs_sep CLIPPED," bmb_file ",  #MOD-G60007 add
                     #---> Mod No.MOD-AB0029
                     #" WHERE bmb01 = '",b_bmy.bmy14 CLIPPED,"' ",
                     #"   AND bmb02 = ",b_bmy.bmy04 CLIPPED,
                      " WHERE bmb01 = '",b_bmy.bmy14 CLIPPED,"' "
                      IF g_sma.sma118='Y' THEN
                         LET l_sql=l_sql,"   AND bmb29 ='", b_bmy.bmy29 , "'" #MOD-830242
                      END IF
                      LET l_sql=l_sql,"   AND bmb02 = ",b_bmy.bmy04 CLIPPED,
                     #---> End Mod No.MOD-AB0029
                      "   AND bmb03 = '",b_bmy.bmy05 CLIPPED,"' ",
                      "   AND (bmb04 <= '",g_bmx.bmx07 CLIPPED,"' OR bmb04 IS NULL) ", 
                      "   AND (bmb05 >  '",g_bmx.bmx07 CLIPPED,"' OR bmb05 IS NULL)) "
       
       ELSE       
           LET l_sql ="SELECT bmb_file.*  FROM ",g_dbs_sep CLIPPED,"bmb_file ",
                      " WHERE bmb01 ='", b_bmy.bmy14 CLIPPED, "'"
           IF g_sma.sma118='Y' THEN
              LET l_sql=l_sql,"   AND bmb29 ='", b_bmy.bmy29 , "'"  #MOD-830242
           END IF
       
           LET l_sql=l_sql,"   AND bmb03 ='", b_bmy.bmy05 CLIPPED, "'",
                           "   AND bmb04 <= '",g_bmx.bmx07 CLIPPED,"' ",     #MOD-D90002 add
                           "   AND (bmb05 >'", g_bmx.bmx07 CLIPPED ,"' OR bmb05 IS NULL)"
       END IF
       
       PREPARE i720_bmb_pre FROM l_sql
       DECLARE i720_bmb_c2 CURSOR FOR i720_bmb_pre
       FOREACH i720_bmb_c2 INTO g_bmb.* 
         IF STATUS THEN	# 當bmy04 is null時,可能讀出一筆以上
            CALL cl_err('sel bmb:',STATUS,1) LET g_success='N' RETURN
         END IF
         LET g_last_seq=g_bmb.bmb02
         #FUN-AC0060---add----str---
         LET g_bmb01 = g_bmb.bmb01
         LET g_bmb02 = g_bmb.bmb02
         LET g_bmb03 = g_bmb.bmb03
         LET g_bmb04 = g_bmb.bmb04
         LET g_bmb29 = g_bmb.bmb29
         #FUN-AC0060---add----str---
         CASE
              WHEN b_bmy.bmy03='1' CALL i720sub_s1()	# 失效
              WHEN b_bmy.bmy03='3' CALL i720sub_s3()	# 修改
              WHEN b_bmy.bmy03='4' CALL i720sub_s4()	# 取代
              WHEN b_bmy.bmy03='5' CALL i720sub_s4()	# 替代     #CHI-960004
         END CASE
         IF g_success='N' THEN RETURN END IF
         LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"ima_file",
                     "   SET ima05 = '",b_bmy.bmy17,"'",
                     " WHERE ima01 = '",b_bmy.bmy14,"'"
         PREPARE i720sub_upd_p21 FROM g_sql
         EXECUTE i720sub_upd_p21
        #UPDATE ima_file SET ima05 = b_bmy.bmy17 WHERE ima01=b_bmy.bmy14
        ##------ 20201204 add by momo (S)
        IF b_bmy.bmy03 MATCHES '[14]' AND b_bmy.bmy38='Y' THEN
           ##---- 20230830 add by momo (S)多營運中心更新停產狀況
           DECLARE i720sub_multupd_ima140 CURSOR FOR
             SELECT azw06 FROM gew_file,azw_file WHERE gew04=azw01 AND gew01 = g_plant AND gew02='2'
             FOREACH i720sub_multupd_ima140 INTO l_azw06
              IF NOT cl_null(l_azw06) THEN
                 CALL s_dbstring(l_azw06) RETURNING l_azw06
                 LET g_sql = "UPDATE ",l_azw06 CLIPPED,"ima_file",
                             "  SET ima140 = '",b_bmy.bmy38,"', ima1401 = '",g_bmx.bmx07,"' ",
                             " WHERE ima01 = '",b_bmy.bmy05,"'"
                 PREPARE i720sub_mulupd_ima140 FROM g_sql
                 EXECUTE i720sub_mulupd_ima140
              END IF
             END FOREACH
           ##---- 20230830 add by momo (E)
           LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"ima_file",
                       "  SET ima140 = '",b_bmy.bmy38,"', ima1401 = '",g_bmx.bmx07,"' ",
                       " WHERE ima01 = '",b_bmy.bmy05,"'"
           PREPARE i720sub_upd_ima140 FROM g_sql
           EXECUTE i720sub_upd_ima140
        END IF
        ##------ 20201204 add by momo (E)
       END FOREACH 
    ELSE 
       IF NOT cl_null(b_bmy.bmy04) THEN             
           LET l_sql ="SELECT brb_file.*  FROM ",g_dbs_sep CLIPPED,"brb_file ",
                      " WHERE brb01 ='", b_bmy.bmy14 CLIPPED, "' ",
                      " AND brb011='", b_bmy.bmy011 CLIPPED, "' ",
                      " AND brb012='", b_bmy.bmy012 CLIPPED, "' ",
                      " AND brb013='", b_bmy.bmy013 CLIPPED, "' "
           IF g_sma.sma118='Y' THEN
             LET l_sql=l_sql,"   AND brb29 ='", b_bmy.bmy29 , "'" #MOD-830242
           END IF       
           LET l_sql=l_sql,"   AND brb02 =",  b_bmy.bmy04,
                      "   AND brb03 ='", b_bmy.bmy05 CLIPPED, "'",
                      "   AND (brb05 >'", g_bmx.bmx07 CLIPPED ,"' OR brb05 IS NULL)", #MOD-6A0109 add ,
                      "   AND brb04 = (SELECT MAX(brb04) FROM ",g_dbs_sep CLIPPED,"brb_file ",
                                     " WHERE brb01 = '",b_bmy.bmy14 CLIPPED,"' ",
                                     " AND brb011='", b_bmy.bmy011 CLIPPED, "' ",
                                     " AND brb012='", b_bmy.bmy012 CLIPPED, "' ",
                                     " AND brb013='", b_bmy.bmy013 CLIPPED, "' ",
                                     "   AND brb02 = ",b_bmy.bmy04 CLIPPED,
                                     "   AND brb03 = '",b_bmy.bmy05 CLIPPED,"' ",
                                     "   AND (brb04 <= '",g_bmx.bmx07 CLIPPED,"' OR brb04 IS NULL) ", 
                                     "   AND (brb05 >  '",g_bmx.bmx07 CLIPPED,"' OR brb05 IS NULL)) "
       
       ELSE       
           LET l_sql ="SELECT brb_file.*  FROM ",g_dbs_sep CLIPPED,"brb_file ",
                      " WHERE brb01 ='", b_bmy.bmy14 CLIPPED, "'",
                      " AND brb011='", b_bmy.bmy011 CLIPPED, "' ",
                      " AND brb012='", b_bmy.bmy012 CLIPPED, "' ",
                      " AND brb013='", b_bmy.bmy013 CLIPPED, "' "
           IF g_sma.sma118='Y' THEN
              LET l_sql=l_sql,"   AND brb29 ='", b_bmy.bmy29 , "'"  #MOD-830242
           END IF
       
           LET l_sql=l_sql,"   AND brb03 ='", b_bmy.bmy05 CLIPPED, "'",
                      "   AND (brb05 >'", g_bmx.bmx07 CLIPPED ,"' OR brb05 IS NULL)"
       END IF
       
       PREPARE i720_brb_pre FROM l_sql
       DECLARE i720_brb_c2 CURSOR FOR i720_brb_pre
       FOREACH i720_brb_c2 INTO g_brb.* 
         IF STATUS THEN	# 當bmy04 is null時,可能讀出一筆以上
            CALL cl_err('sel brb:',STATUS,1) LET g_success='N' RETURN
         END IF
         LET g_last_seq=g_brb.brb02
         CASE
              WHEN b_bmy.bmy03='1' CALL i720sub_s1()	# 失效
              WHEN b_bmy.bmy03='3' CALL i720sub_s3()	# 修改
         END CASE
         IF g_success='N' THEN RETURN END IF
         LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"ima_file",
                     "   SET ima05 = '",b_bmy.bmy17,"'",
                     " WHERE ima01 = '",b_bmy.bmy14,"'"
         PREPARE i720sub_upd_p22 FROM g_sql
         EXECUTE i720sub_upd_p22
        #UPDATE ima_file SET ima05 = b_bmy.bmy17 WHERE ima01=b_bmy.bmy14
       END FOREACH     	
    END IF 
END FUNCTION 
#No.FUN-A60008--end  

FUNCTION i720sub_s1()
   DEFINE   l_bmb06   LIKE bmb_file.bmb06
   DEFINE   l_tmp_bmb06   LIKE bmb_file.bmb06
   DEFINE   l_cnt    LIKE type_file.num5   
#   #No.FUN-A60008--begin
    LET g_sql = "SELECT bra014 FROM ",g_dbs_sep CLIPPED,"bra_file",
                " WHERE bra01 = '",b_bmy.bmy14,"'",
                "   AND bra011= '",b_bmy.bmy011,"'",
                "   AND bra012= '",b_bmy.bmy012,"'",
                "   AND bra013= '",b_bmy.bmy013,"'"
    PREPARE i720sub_sel_p40 FROM g_sql
    EXECUTE i720sub_sel_p40 INTO g_bra014
#    #No.FUN-A60008--end    

    IF g_argv1_str='1' THEN  #No.FUN-A60008 #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
        LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmb_file",
                    "   SET bmb05 = '",g_bmx.bmx07,"',",
                    "       bmb24 = '",g_bmx.bmx01,"',",
                    "       bmb30 = '",b_bmy.bmy30,"',",
                    #"       bmb361 = '",b_bmy.bmy361,"',", #FUN-D10093 add  #CHI-D40002
                    "       bmb36 = '",b_bmy.bmy361,"',",  #CHI-D40002
                    "       bmb37 = '",b_bmy.bmy37,"',",   #FUN-D10093 add
                    "       bmbmodu = '",g_user,"',",
                    "       bmbdate = '",g_today,"'",
                   #FUN-AC0060(110705)---mod---str-----
                   #" WHERE ROWID = '",g_bmb_rowid,"'" 
                    " WHERE bmb01 = '",g_bmb01,"'",
                    "   AND bmb02 = '",g_bmb02,"'",
                    "   AND bmb03 = '",g_bmb03,"'",
                    "   AND bmb04 = '",g_bmb04,"'",
                    "   AND bmb29 = '",g_bmb29,"'" 
                   #FUN-AC0060(110705)---mod---end-----
        PREPARE i720sub_upd_p4 FROM g_sql
        EXECUTE i720sub_upd_p4
        DISPLAY "FUN-D10093(1)",g_sql
     #No.FUN-A60008--begin
     END IF 
     #CHI-D40002---begin
     IF s_industry('icd')  THEN
        LET g_sql = " UPDATE ",g_dbs_sep CLIPPED,"icm_file",
                    "    SET icmacti = 'N'",
                    "  WHERE icm01 = '",g_bmb03,"'",
                    "    AND icm02 = '",g_bmb01,"'"
        PREPARE i720sub_upd_p44 FROM g_sql
        EXECUTE i720sub_upd_p44
     END IF 
     #CHI-D40002---end
     IF g_argv1_str='2' THEN  #FUN-AC0060(110705)  #CHI-CA0035 mod g_argv3->g_argv1
     	LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"brb_file",
                   #MOD-C90250 mod begin--------------------------------
                   #"   SET brb05 = '",g_bmx.bmx07,"'",
                   #"       brb24 = '",g_bmx.bmx01,"'",
                   #"       brb30 = '",b_bmy.bmy30,"'",
                   #"     brbmodu = '",g_user,"'",
                    "   SET brb05 = '",g_bmx.bmx07,"',",
                    "       brb24 = '",g_bmx.bmx01,"',",
                    "       brb30 = '",b_bmy.bmy30,"',",
                    "     brbmodu = '",g_user,"',",
                   #MOD-C90250 mod end----------------------------------
                    "     brbdate = '",g_today,"'",
                    " WHERE brb01 = '",g_brb.brb01,"'",
                    "   AND brb011= '",g_brb.brb011,"'",
                    "   AND brb012= '",g_brb.brb012,"'",
                    "   AND brb013= '",g_brb.brb013,"'",
                    "   AND brb02 = '",g_brb.brb02,"'",
                    "   AND brb03 = '",g_brb.brb03,"'",
                    "   AND brb04 = '",g_brb.brb04,"'",
                    "   AND brb29 = '",g_brb.brb29,"'"
        PREPARE i720sub_upd_p41 FROM g_sql
        EXECUTE i720sub_upd_p41

        IF g_bra014='Y' THEN 
            LET g_sql = "SELECT ecb06 FROM ",g_dbs_sep CLIPPED,"ecb_file",
                        " WHERE ecb01 = '",g_brb.brb01,"'",
                        "   AND ecb02 = '",g_brb.brb011,"'",
                        "   AND ecb012= '",g_brb.brb012,"'",
                        "   AND ecb03 = '",g_brb.brb013,"'"
            PREPARE i720sub_sel_p41 FROM g_sql
            EXECUTE i720sub_sel_p41 INTO g_ecb06
            
            LET g_sql = "SELECT bmb06 FROM ",g_dbs_sep CLIPPED,"bmb_file",
                        " WHERE bmb01 = '",g_brb.brb01,"'",
                        "   AND bmb03 = '",g_brb.brb03,"'",
                        "   AND bmb29 = '",g_brb.brb29,"'",
                        "   AND bmb09 = '",g_ecb06,"'"
            PREPARE i720sub_sel_p42 FROM g_sql
            EXECUTE i720sub_sel_p42 INTO l_bmb06

            IF l_bmb06 >g_brb.brb06 THEN 
                LET l_tmp_bmb06 = l_bmb06 - g_brb.brb06
                LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmb_file", 
                            "   SET bmb06  = ?,", #l_bmb06-g_brb.brb06,
                            "       bmb24  = ?,", #g_bmx.bmx01,
                            "       bmbmodu= ?,", #g_user,
                            "       bmbdate= ? ", #g_today
                            " WHERE bmb01 = '",g_brb.brb01,"'",
                            "   AND bmb09 = '",g_brb.brb09,"'",
                            "   AND bmb03 = '",g_brb.brb03,"'",
                            "   AND bmb29 = '",g_brb.brb29,"'"
                PREPARE i720sub_upd_p42 FROM g_sql
                EXECUTE i720sub_upd_p42 USING l_tmp_bmb06,g_bmx.bmx01,g_user,g_today
            ELSE  
                LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmb_file",
                            " SET bmb05  = ?,", #g_bmx.bmx07,
                            "     bmb24  = ?,", #g_bmx.bmx01,
                            "     bmbmodu= ?,", #g_user,
                            "     bmbdate= ? ", #g_today
                            " WHERE bmb01 = '",g_brb.brb01,"'",
                            "   AND bmb09 = '",g_brb.brb09,"'",
                            "   AND bmb03 = '",g_brb.brb03,"'",
                            "   AND bmb29 = '",g_brb.brb29,"'"
                PREPARE i720sub_upd_p43 FROM g_sql
                EXECUTE i720sub_upd_p43 USING g_bmx.bmx07,g_bmx.bmx01,g_user,g_today
            END IF 
        END IF          
     END IF    
     #No.FUN-A60008--end    
     IF SQLCA.sqlcode THEN
        LET g_showmsg = g_bmx.bmx01,' update bmb_file:'                    
        CALL s_errmsg('bmx01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
        LET g_success='N'
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        LET g_showmsg = g_bmx.bmx01,' update bmb_file:'                    
        CALL s_errmsg('bmx01',g_plant,g_showmsg,'aap-161',1)
        LET g_success='N'
     END IF

     #FUN-F50035 add str--- 
      IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN 
         CALL i720_del_vmo() 
         IF SQLCA.sqlcode THEN
            LET g_showmsg = g_bmx.bmx01,' delete vmo_file:'                    
            CALL s_errmsg('bmx01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
            LET g_success='N'
         END IF
      END IF 
     #FUN-F50035 add end--- 

     IF g_argv1_str='1' THEN  #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
         LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmv_file",
                     "   SET bmv06 = '",g_bmx.bmx07,"'",
                     " WHERE bmv01 = '",b_bmy.bmy14,"'",
                     "   AND bmv02 = '",b_bmy.bmy05,"'",
                     "   AND bmv03 = '",b_bmy.bmy29,"'"
         PREPARE i720sub_upd_p6 FROM g_sql
         EXECUTE i720sub_upd_p6
         IF SQLCA.sqlcode THEN
            LET g_showmsg = g_bmx.bmx01,' update bmv_file:'                    
            CALL s_errmsg('bmx01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
            LET g_success='N'
         END IF
     END IF 
     LET g_bmy05_t=b_bmy.bmy05

     LET l_cnt = 0 
     LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmd_file ",
                 " WHERE bmd08 = '",b_bmy.bmy14,"'",
                 "   AND bmd01 = '",b_bmy.bmy05,"'",
                 "   AND (bmd06 > '",g_bmx.bmx07,"'",
                 "        OR bmd06 IS NULL) "
     PREPARE i720sub_sel_p11 FROM g_sql
     EXECUTE i720sub_sel_p11 INTO l_cnt
    
     IF l_cnt > 0 THEN 
        LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmd_file",
                    "   SET bmd06 = '",g_bmx.bmx07 ,"',",
                    "       bmdmodu = '",g_user    ,"',",
                    "       bmddate = '",g_today   ,"'",
                    " WHERE bmd08 = '",b_bmy.bmy14 ,"'",
                    "   AND bmd01 = '",b_bmy.bmy05 ,"'",
                    "   AND (bmd06 > '",g_bmx.bmx07,"'",
                    "        OR bmd06 IS NULL) "
        PREPARE i720sub_upd_p5 FROM g_sql
        EXECUTE i720sub_upd_p5
        IF SQLCA.sqlcode THEN
           LET g_showmsg = g_bmx.bmx01,' update bmd_file:'                    
           CALL s_errmsg('bmx01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
           LET g_success='N'
        END IF
        IF SQLCA.SQLERRD[3]=0 THEN
           LET g_showmsg = g_bmx.bmx01,' update bmd_file:'                    
           CALL s_errmsg('bmx01',g_plant,g_showmsg,'aap-161',1)
           LET g_success='N'
        END IF
     END IF

END FUNCTION

FUNCTION i720sub_s2()
   DEFINE l_bmt		RECORD LIKE bmt_file.*
   DEFINE l_ima151      LIKE ima_file.ima151   
   DEFINE l_bmc		RECORD LIKE bmc_file.*
   DEFINE l_ecb06       LIKE ecb_file.ecb06
   DEFINE l_brb06       LIKE brb_file.brb06 
   DEFINE l_str1_bmb STRING
   DEFINE l_str2_bmb STRING
   DEFINE l_str3_bmb STRING
   DEFINE l_str1_brb STRING
   DEFINE l_str2_brb STRING
   DEFINE l_str3_brb STRING
   DEFINE l_str1_bmt STRING
   DEFINE l_str2_bmt STRING
   DEFINE l_str3_bmt STRING
   DEFINE l_str1_bmc STRING
   DEFINE l_str2_bmc STRING
   DEFINE l_str3_bmc STRING
  #FUN-E70037--add str--
   DEFINE l_str1_bmba STRING
   DEFINE l_str2_bmba STRING
   DEFINE l_str3_bmba STRING
   DEFINE l_str1_bmbb STRING
   DEFINE l_str2_bmbb STRING
   DEFINE l_str3_bmbb STRING
   DEFINE l_str1_bmbc STRING
   DEFINE l_str2_bmbc STRING
   DEFINE l_str3_bmbc STRING
   DEFINE l_str1_bmbd STRING
   DEFINE l_str2_bmbd STRING
   DEFINE l_str3_bmbd STRING
  #FUN-E70037--add end--
   DEFINE l_cnt         LIKE type_file.num5  #CHI-D40002
   DEFINE l_icm      RECORD LIKE icm_file.*  #CHI-D40002
  #FUN-E70037--add--str--
   DEFINE l_bmy29       LIKE bmy_file.bmy29
   DEFINE l_bmya04      LIKE bmya_file.bmya04
   DEFINE l_bmya05      LIKE bmya_file.bmya05
   DEFINE l_bmyb04      LIKE bmyb_file.bmyb04
   DEFINE l_bmyb05      LIKE bmyb_file.bmyb05
   DEFINE l_bmyc04      LIKE bmyc_file.bmyc04
   DEFINE l_bmyd04      LIKE bmyd_file.bmyd04
   DEFINE l_bmba        RECORD LIKE bmba_file.*
   DEFINE l_bmbb        RECORD LIKE bmbb_file.*
   DEFINE l_bmbc        RECORD LIKE bmbc_file.*
   DEFINE l_bmbd        RECORD LIKE bmbd_file.*
  #FUN-E70037--add--end--

   WHENEVER ERROR CONTINUE

  #No.FUN-A60008--begin
    LET g_sql = "SELECT bra014 FROM ",g_dbs_sep CLIPPED,"bra_file",
                " WHERE bra01 = '",b_bmy.bmy14,"'",
                "   AND bra011= '",b_bmy.bmy011,"'",
                "   AND bra012= '",b_bmy.bmy012,"'",
                "   AND bra013= '",b_bmy.bmy013,"'"
    PREPARE i720sub_sel_p43 FROM g_sql
    EXECUTE i720sub_sel_p43 INTO g_bra014
  #No.FUN-A60008--end   
   INITIALIZE g_bmb.* TO NULL
   LET g_bmb.bmb01 =b_bmy.bmy14
   LET g_bmb.bmb02 =b_bmy.bmy04 
   LET g_bmb.bmb29 =b_bmy.bmy29 
   LET g_bmb.bmb30 =b_bmy.bmy30 
   LET g_bmb.bmb33 =b_bmy.bmy33 
   LET g_bmb.bmb34 =b_bmy.bmy38  #FUN-E70037 add
   LET g_bmb.bmb36 =b_bmy.bmy361 #FUN-D10093 add
   LET g_bmb.bmb37 =b_bmy.bmy37  #FUN-D10093 add
   IF g_bmb.bmb02 IS NULL THEN      
      LET g_sql = "SELECT MAX(bmb02) FROM ",g_dbs_sep CLIPPED,"bmb_file",
                  " WHERE bmb01 = '",g_bmb.bmb01,"'",
                  "   AND bmb29 = '",g_bmb.bmb29,"'"
      PREPARE i720sub_sel_p12 FROM g_sql
      EXECUTE i720sub_sel_p12 INTO g_bmb.bmb02

      IF g_bmb.bmb02 IS NULL THEN 
          LET g_bmb.bmb02 = 0 
      END IF
      LET g_bmb.bmb02 = g_bmb.bmb02 + g_sma.sma19
   END IF                          
   LET g_bmb.bmb03 = b_bmy.bmy05
   LET g_bmb.bmb04 = g_bmx.bmx07
   LET g_bmb.bmb06 = b_bmy.bmy06
   LET g_bmb.bmb07 = b_bmy.bmy07
   LET g_bmb.bmb09 = b_bmy.bmy09   #20221124
   LET g_bmb.bmb16 = b_bmy.bmy16
   LET g_bmb.bmb24 = g_bmx.bmx01
   LET g_bmb.bmb25 = b_bmy.bmy25
   LET g_bmb.bmb26 = b_bmy.bmy26
   LET g_bmb.bmb13 = b_bmy.bmy13
   LET g_bmb.bmb18 = b_bmy.bmy18
   LET g_bmb.bmb08 = b_bmy.bmy08
   LET g_bmb.bmb081= b_bmy.bmy081  #Add No:TQC-AC0300
   LET g_bmb.bmb082= b_bmy.bmy082  #Add No:TQC-AC0300
   LET g_bmb.bmb11 = b_bmy.bmy11
   LET g_bmb.bmb09 = b_bmy.bmy09
   LET g_bmb.bmb10 = b_bmy.bmy10
   LET g_bmb.bmb10_fac = b_bmy.bmy10_fac
   LET g_sql = "SELECT ima105 FROM ",g_dbs_sep CLIPPED,"ima_file",
               " WHERE ima01 = '",g_bmb.bmb03,"'"
   PREPARE i720sub_sel_p13 FROM g_sql
   EXECUTE i720sub_sel_p13 INTO g_bmb.bmb27

   LET g_bmb.bmb31 = b_bmy.bmy34  
   LET g_bmb.bmb10_fac2 = b_bmy.bmy10_fac2
#  LET g_bmb.bmb14 = 0               #TQC-BA0080 mark
   LET g_bmb.bmb14 = b_bmy.bmy35     #TQC-BA0080 add
   LET g_bmb.bmb15 = b_bmy.bmy21   
   LET g_bmb.bmb17 = 'N'
   LET g_bmb.bmb19 = '1'
   IF NOT cl_null(b_bmy.bmy20) THEN LET g_bmb.bmb19 =b_bmy.bmy20 END IF  
   LET g_bmb.bmb23 = 100     
   LET g_bmb.bmb28 = b_bmy.bmy23   
   IF cl_null(g_bmb.bmb28) THEN
      LET g_bmb.bmb28 = 0
   END IF

   IF cl_null(g_bmb.bmb02)  THEN
      LET g_bmb.bmb02 = ' '
   END IF
   IF cl_null(g_bmb.bmb08) THEN
      LET g_bmb.bmb08 = 0
   END IF
   #Add No:TQC-AC0300
   IF cl_null(g_bmb.bmb081) THEN
      LET g_bmb.bmb081 = 0
   END IF
   IF cl_null(g_bmb.bmb082) THEN
      LET g_bmb.bmb082 = 1
   END IF
   #End Add No:TQC-AC0300
   LET g_bmb.bmb33 = 0   
   LET g_bmb.bmb31 = b_bmy.bmy34  
   #FUN-B70076---add---str---
   LET g_bmb.bmb081 = b_bmy.bmy081
   LET g_bmb.bmb082 = b_bmy.bmy082
   IF cl_null(g_bmb.bmb081) THEN
       LET g_bmb.bmb081 = 0
   END IF
   IF cl_null(g_bmb.bmb082) THEN
       LET g_bmb.bmb082 = 1
   END IF
   #FUN-B70076---add---end---

   LET g_sql = "SELECT ima151 FROM ",g_dbs_sep CLIPPED,"ima_file,",g_dbs_sep CLIPPED,"bmy_file",
               " WHERE bmy14 = ima01 ",
               "   AND bmy14 = '",b_bmy.bmy14,"'",
               "   AND bmy01 = '",g_bmx.bmx01,"'",
               "   AND bmy02 = '",b_bmy.bmy02,"'"
   PREPARE i720sub_sel_p14 FROM g_sql
   EXECUTE i720sub_sel_p14 INTO l_ima151

   IF g_argv1_str='1' THEN  #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
       IF l_ima151 = 'Y' THEN
           LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmy_file",
                       "   SET bmy33 = '",g_bmb.bmb02,"'",
                       " WHERE bmy01 = '",g_bmx.bmx01,"'",
                       "   AND bmy02 = '",b_bmy.bmy02,"'",
                       "   AND bmy14 = '",b_bmy.bmy14,"'"
           PREPARE i720sub_upd_p7 FROM g_sql
           EXECUTE i720sub_upd_p7   
           IF SQLCA.sqlcode THEN
               LET g_showmsg = g_bmx.bmx01,' update bmy_file:'                    
               CALL s_errmsg('bmy33',g_plant,g_showmsg,SQLCA.SQLCODE,1)
               LET g_success='N'
           END IF
       ELSE
           LET g_bmb.bmb33 = b_bmy.bmy33
       END IF
       LET g_bmb.bmb34 = b_bmy.bmy38                             #FUN-E70037 add
       IF cl_null(g_bmb.bmb34) THEN LET g_bmb.bmb34 = 0  END IF  #TQC-DA0015 add
       CALL s_carry_p_cs()
       CALL s_carry_col('bmb_file') RETURNING l_str1_bmb,l_str2_bmb,l_str3_bmb
       LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmb_file",
                   " VALUES(",l_str2_bmb,")"
       PREPARE i720sub_ins_bmb1 FROM g_sql
       EXECUTE i720sub_ins_bmb1 USING g_bmb.*
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          LET g_showmsg = g_bmx.bmx01,' insert bmb_file:'                  
          CALL s_errmsg('bmx01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
          LET g_success='N'
       END IF
     #FUN-F50035 add str-----
      IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN #與APS整合
         CALL i720_ins_vmo()
      END IF
     #FUN-F50035 add end-----
      #FUN-E70037--add str--
       #ADD ABOUT COLOR SIZE
       IF g_success = 'Y' AND s_industry('slk') AND g_sma.sma150 = 'Y' THEN
          SELECT bmy29 INTO l_bmy29 FROM bmy_file
           WHERE bmy01 = g_bmx.bmx01 AND bmy02 = b_bmy.bmy02 AND bmy38 = g_bmb.bmb34
          IF cl_null(l_bmy29) THEN LET l_bmy29 = ' ' END IF
          IF g_bmb.bmb34 MATCHES '[23]' THEN
             LET g_sql = "SELECT bmya04,bmya05 FROM ",g_dbs_sep CLIPPED,"bmya_file ",
                         " WHERE bmya01 = '",g_bmx.bmx01,"'",
                         "   AND bmya02 = '",b_bmy.bmy02,"'"               
             PREPARE i720s2_sel_bmya FROM g_sql
             DECLARE i720s2_sel_bmya_cl CURSOR FOR i720s2_sel_bmya
             CALL s_carry_p_cs()
             CALL s_carry_col('bmba_file') RETURNING l_str1_bmba,l_str2_bmba,l_str3_bmba
           	FOREACH i720s2_sel_bmya_cl INTO l_bmya04,l_bmya05
           	   IF NOT cl_null(l_bmya04) AND NOT cl_null(l_bmya05) THEN
                   LET l_bmba.bmba01 = g_bmb.bmb01
                   LET l_bmba.bmba02 = g_bmb.bmb02
                   LET l_bmba.bmba03 = g_bmb.bmb03
                   LET l_bmba.bmba04 = g_bmb.bmb04
                   LET l_bmba.bmba05 = l_bmya04
                   LET l_bmba.bmba06 = l_bmya05
                   LET l_bmba.bmba29 = l_bmy29		   		   
            	LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmba_file",
                         " VALUES(",l_str2_bmba,")"
             PREPARE i720sub_ins_bmba FROM g_sql
             EXECUTE i720sub_ins_bmba USING l_bmba.*
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                   LET g_showmsg = g_bmb.bmb01,' insert bmba_file:'
                   CALL s_errmsg('bmba01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
                   LET g_success='N'
                END IF
             END IF
             END FOREACH
          END IF
          IF g_bmb.bmb34 MATCHES '[24]' THEN
             LET g_sql = "SELECT bmyb04,bmyb05 FROM ",g_dbs_sep CLIPPED,"bmyb_file ",
                         " WHERE bmyb01 = '",g_bmx.bmx01,"'",
                         "   AND bmyb02 = '",b_bmy.bmy02,"'"               
             PREPARE i720s2_sel_bmyb FROM g_sql
             DECLARE i720s2_sel_bmyb_cl CURSOR FOR i720s2_sel_bmyb
             CALL s_carry_p_cs()
             CALL s_carry_col('bmbb_file') RETURNING l_str1_bmbb,l_str2_bmbb,l_str3_bmbb
           	FOREACH i720s2_sel_bmyb_cl INTO l_bmyb04,l_bmyb05
           	   IF NOT cl_null(l_bmyb04) AND NOT cl_null(l_bmyb05) THEN
                   LET l_bmbb.bmbb01 = g_bmb.bmb01
                   LET l_bmbb.bmbb02 = g_bmb.bmb02
                   LET l_bmbb.bmbb03 = g_bmb.bmb03
                   LET l_bmbb.bmbb04 = g_bmb.bmb04
                   LET l_bmbb.bmbb05 = l_bmyb04
                   LET l_bmbb.bmbb06 = l_bmyb05
                   LET l_bmbb.bmbb29 = l_bmy29		   		   
            	LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmbb_file",
                         " VALUES(",l_str2_bmbb,")"
             PREPARE i720sub_ins_bmbb FROM g_sql
             EXECUTE i720sub_ins_bmbb USING l_bmbb.*
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                   LET g_showmsg = g_bmb.bmb01,' insert bmbb_file:'
                   CALL s_errmsg('bmbb01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
                   LET g_success='N'
                END IF
             END IF
             END FOREACH
          END IF
          IF g_bmb.bmb34 MATCHES '[56]' THEN
             LET g_sql = "SELECT bmyc04 FROM ",g_dbs_sep CLIPPED,"bmyc_file ",
                         " WHERE bmyc01 = '",g_bmx.bmx01,"'",
                         "   AND bmyc02 = '",b_bmy.bmy02,"'"               
             PREPARE i720s2_sel_bmyc FROM g_sql
             DECLARE i720s2_sel_bmyc_cl CURSOR FOR i720s2_sel_bmyc
             CALL s_carry_p_cs()
             CALL s_carry_col('bmbc_file') RETURNING l_str1_bmbc,l_str2_bmbc,l_str3_bmbc
           	FOREACH i720s2_sel_bmyc_cl INTO l_bmyc04
           	   IF NOT cl_null(l_bmyc04) THEN
                   LET l_bmbc.bmbc01 = g_bmb.bmb01
                   LET l_bmbc.bmbc02 = g_bmb.bmb02
                   LET l_bmbc.bmbc03 = g_bmb.bmb03
                   LET l_bmbc.bmbc04 = g_bmb.bmb04
                   LET l_bmbc.bmbc05 = l_bmyc04
                   LET l_bmbc.bmbc29 = l_bmy29		   		   
            	LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmbc_file",
                         " VALUES(",l_str2_bmbc,")"
             PREPARE i720sub_ins_bmbc FROM g_sql
             EXECUTE i720sub_ins_bmbc USING l_bmbc.*
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                   LET g_showmsg = g_bmb.bmb01,' insert bmbc_file:'
                   CALL s_errmsg('bmbc01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
                   LET g_success='N'
                END IF
             END IF
             END FOREACH
          END IF
          IF g_bmb.bmb34 MATCHES '[57]' THEN
             LET g_sql = "SELECT bmyd04 FROM ",g_dbs_sep CLIPPED,"bmyd_file ",
                         " WHERE bmyd01 = '",g_bmx.bmx01,"'",
                         "   AND bmyd02 = '",b_bmy.bmy02,"'"               
             PREPARE i720s2_sel_bmyd FROM g_sql
             DECLARE i720s2_sel_bmyd_cl CURSOR FOR i720s2_sel_bmyd
             CALL s_carry_p_cs()
             CALL s_carry_col('bmbd_file') RETURNING l_str1_bmbd,l_str2_bmbd,l_str3_bmbd
           	FOREACH i720s2_sel_bmyd_cl INTO l_bmyd04
           	   IF NOT cl_null(l_bmyd04) THEN
                      LET l_bmbd.bmbd01 = g_bmb.bmb01
                      LET l_bmbd.bmbd02 = g_bmb.bmb02
                      LET l_bmbd.bmbd03 = g_bmb.bmb03
                      LET l_bmbd.bmbd04 = g_bmb.bmb04
                      LET l_bmbd.bmbd05 = l_bmyd04
                      LET l_bmbd.bmbd29 = l_bmy29		   		   
                      LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmbd_file",
                                  " VALUES(",l_str2_bmbd,")"
                      PREPARE i720sub_ins_bmbd FROM g_sql
                      EXECUTE i720sub_ins_bmbd USING l_bmbd.*
                      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                         LET g_showmsg = g_bmb.bmb01,' insert bmbd_file:'
                         CALL s_errmsg('bmbd01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
                         LET g_success='N'
                      END IF
                   END IF
                END FOREACH
          END IF
       END IF
      #FUN-E70037--add end--
      #CHI-D40002---begin
       IF s_industry('icd')  THEN
         LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"icm_file",
                     " WHERE icm01 = '",g_bmb.bmb03,"'",
                     "   AND icm02 = '",g_bmb.bmb01,"'"
         PREPARE i720sub_sel_p33 FROM g_sql
         EXECUTE i720sub_sel_p33 INTO l_cnt
         
          IF l_cnt = 0 THEN
             INITIALIZE l_icm.* TO NULL
             LET l_icm.icm01 = g_bmb.bmb03
             LET l_icm.icm02 = g_bmb.bmb01
             LET l_icm.icmacti = 'Y'
             LET l_icm.icmdate = g_today
             LET l_icm.icmgrup = g_grup
             LET l_icm.icmmodu = ''
             LET l_icm.icmuser = g_user
             LET l_icm.icmoriu = g_user      
             LET l_icm.icmorig = g_grup     

             LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"icm_file",
                         " (icm01,icm02,icmacti,icmdate,icmgrup,icmmodu,icmuser,icmoriu,icmorig) ",
                         " VALUES(?,?,?,?,?, ?,?,?,?) "
             PREPARE i720sub_ins_icm1 FROM g_sql
             EXECUTE i720sub_ins_icm1 USING l_icm.icm01,l_icm.icm02,l_icm.icmacti,l_icm.icmdate,l_icm.icmgrup,l_icm.icmmodu,l_icm.icmuser,l_icm.icmoriu,l_icm.icmorig
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","icm_file",g_bmb.bmb01,g_bmb.bmb03,SQLCA.sqlcode,"","",1)
                LET g_success = 'N'
             END IF
          ELSE
             IF l_cnt = 1 THEN
                LET g_sql = " UPDATE ",g_dbs_sep CLIPPED,"icm_file",
                            "    SET icmacti = 'Y' ",
                            "  WHERE icm01 = '",g_bmb.bmb03,"'",
                            "    AND icm02 = '",g_bmb.bmb01,"'"
                PREPARE i720sub_upd_icm1 FROM g_sql   
                EXECUTE i720sub_upd_icm1           
             END IF 
          END IF
       END IF
#CHI-D40002---end
       
       IF g_sma.sma845='Y'   #低階碼可否部份重計
          THEN
          CALL s_decl_bmb_m(g_dbs_sep)
          CALL s_uima146_m(g_bmb.bmb03,g_dbs_sep)
          CALL cl_msg("")                              
       END IF
       
       LET g_sql ="SELECT * FROM ",g_dbs_sep CLIPPED,"bmw_file",
                  " WHERE bmw01 = '",g_bmx.bmx01,"'",
                  "   AND bmw02 = '",b_bmy.bmy02,"'"
       PREPARE i720sub_s2_p1 FROM g_sql
       DECLARE i720sub_s2_c2 CURSOR FOR i720sub_s2_p1
       FOREACH i720sub_s2_c2 INTO b_bmw.*
          LET l_bmt.bmt01=g_bmb.bmb01
          LET l_bmt.bmt02=g_bmb.bmb02
          LET l_bmt.bmt03=g_bmb.bmb03
          LET l_bmt.bmt04=g_bmb.bmb04
          LET l_bmt.bmt05=b_bmw.bmw03
          LET l_bmt.bmt06=b_bmw.bmw04
          LET l_bmt.bmt07=b_bmw.bmw05
          LET l_bmt.bmt08=g_bmb.bmb29 
          IF cl_null(l_bmt.bmt02) THEN
             LET l_bmt.bmt02=0
          END IF
          CALL s_carry_p_cs()
          CALL s_carry_col('bmt_file') RETURNING l_str1_bmt,l_str2_bmt,l_str3_bmt
          LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmt_file",
                      " VALUES(",l_str2_bmt,")"
          PREPARE i720sub_ins_bmt1 FROM g_sql
          EXECUTE i720sub_ins_bmt1 USING l_bmt.*
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
             LET g_showmsg = l_bmt.bmt01,' insert bmt_file:#1'                  
             CALL s_errmsg('bmt01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
             LET g_success='N'
          END IF
       END FOREACH
       CALL i720sub_up_bmb13()
       
       #==>說明檔(bmc_file)複製
       LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmf_file",
                   " WHERE bmf01 = '",g_bmx.bmx01,"'",
                   "   AND bmf02 = '",b_bmy.bmy02,"'"
       PREPARE i720sub_sel_p15 FROM g_sql
       EXECUTE i720sub_sel_p15 INTO g_cnt
       IF g_cnt>0 THEN 	# 有輸入才更新
          LET g_sql = "SELECT * FROM ",g_dbs_sep CLIPPED,"bmf_file",
                      " WHERE bmf01 = '",g_bmx.bmx01,"'",
                      "   AND bmf02 = '",b_bmy.bmy02,"'"
          PREPARE i720sub_s2_p2 FROM g_sql
          DECLARE i720sub_s2_c3 CURSOR FOR i720sub_s2_p2
       
          CALL s_carry_p_cs()
          CALL s_carry_col('bmc_file') RETURNING l_str1_bmc,l_str2_bmc,l_str3_bmc
          LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmc_file",
                      " VALUES(",l_str2_bmc,")"
          PREPARE i720sub_ins_bmc1 FROM g_sql
          FOREACH i720sub_s2_c3 INTO b_bmf.*
              LET l_bmc.bmc01=g_bmb.bmb01
              LET l_bmc.bmc02=g_bmb.bmb02
              LET l_bmc.bmc021=g_bmb.bmb03
              LET l_bmc.bmc03=g_bmb.bmb04
              LET l_bmc.bmc04=b_bmf.bmf03
              LET l_bmc.bmc05=b_bmf.bmf04
              LET l_bmc.bmc06=g_bmb.bmb29 
              EXECUTE i720sub_ins_bmc1 USING l_bmc.*
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                 LET g_showmsg = g_plant,":",l_bmc.bmc01,'ins bmc:'
                 CALL s_errmsg('bmc01',l_bmc.bmc01,g_showmsg,SQLCA.sqlcode,1)
                 LET g_success='N'
              END IF
          END FOREACH
       END IF
    #No.FUN-A60008--begin
   ELSE 
       INITIALIZE g_brb.* TO NULL
       LET g_brb.brb01 =b_bmy.bmy14
       LET g_brb.brb011 =b_bmy.bmy011
       LET g_brb.brb012 =b_bmy.bmy012
       LET g_brb.brb013 =b_bmy.bmy013
       LET g_brb.brb02 =b_bmy.bmy04
       LET g_brb.brb29 =b_bmy.bmy29
       LET g_brb.brb30 =b_bmy.bmy30
       LET g_brb.brb33 =b_bmy.bmy33 
       IF g_brb.brb02 IS NULL THEN      
           LET g_sql = "SELECT MAX(brb02) FROM ",g_dbs_sep CLIPPED,"brb_file",
                       " WHERE brb01 = '",g_brb.brb01,"'",
                       "   AND brb29 = '",g_brb.brb29,"'",
                       "   AND brb011= '",g_brb.brb011,"'",
                       "   AND brb012= '",g_brb.brb012,"'",
                       "   AND brb013= '",g_brb.brb013,"'"
           PREPARE i720sub_sel_p44 FROM g_sql
           EXECUTE i720sub_sel_p44 INTO g_brb.brb02
           IF g_brb.brb02 IS NULL THEN LET g_brb.brb02 = 0 END IF
           LET g_brb.brb02 = g_brb.brb02 + g_sma.sma19
       END IF                          
       LET g_brb.brb03 =b_bmy.bmy05
       LET g_brb.brb04 =g_bmx.bmx07
       LET g_brb.brb06 =b_bmy.bmy06
       LET g_brb.brb07 =b_bmy.bmy07
       LET g_brb.brb16 =b_bmy.bmy16
       LET g_brb.brb24 =g_bmx.bmx01
       LET g_brb.brb25 =b_bmy.bmy25
       LET g_brb.brb26 =b_bmy.bmy26
       LET g_brb.brb13 =b_bmy.bmy13
       LET g_brb.brb18 =b_bmy.bmy18
       LET g_brb.brb08 =b_bmy.bmy08
       LET g_brb.brb081 = b_bmy.bmy081    #FUN-AC0075
       LET g_brb.brb082 = b_bmy.bmy082    #FUN-AC0075
       LET g_brb.brb11 =b_bmy.bmy11
       LET g_sql = "SELECT ecb06 FROM ",g_dbs_sep CLIPPED,"ecb_file",
                   " WHERE ecb01 = '",g_brb.brb01,"'",
                   "   AND ecb02 = '",g_brb.brb011,"'",
                   "   AND ecb012= '",g_brb.brb012,"'",
                   "   AND ecb03 = '",g_brb.brb013,"'"
       PREPARE i720sub_sel_p45 FROM g_sql
       EXECUTE i720sub_sel_p45 INTO l_ecb06
       LET g_brb.brb09 =l_ecb06
       LET g_brb.brb10 =b_bmy.bmy10
       LET g_brb.brb10_fac =b_bmy.bmy10_fac
       LET g_sql = "SELECT ima105 FROM ",g_dbs_sep CLIPPED,"ima_file",
                   " WHERE ima01 = '",g_brb.brb03,"'"
       PREPARE i720sub_sel_p46 FROM g_sql
       EXECUTE i720sub_sel_p46 INTO g_brb.brb27
       LET g_brb.brb31 =b_bmy.bmy34 
       LET g_brb.brb10_fac2=b_bmy.bmy10_fac2
      #LET g_brb.brb14 =0 #CHI-A60028 mark
       LET g_brb.brb14 =b_bmy.bmy35 #CHI-A60028 add
       LET g_brb.brb15 =b_bmy.bmy21   
       LET g_brb.brb17 ='N'
       LET g_brb.brb19 ='1'
       IF NOT cl_null(b_bmy.bmy20) THEN LET g_brb.brb19 =b_bmy.bmy20 END IF 
      #LET g_brb.brb23 =0       #MOD-A90160 mark 
       LET g_brb.brb23 =100     #MOD-A90160 add 
       LET g_brb.brb28 =b_bmy.bmy23  
       IF cl_null(g_brb.brb28) THEN
          LET g_brb.brb28 =0
       END IF
       
       IF cl_null(g_brb.brb02)  THEN
          LET g_brb.brb02=' '
       END IF
       IF cl_null(g_brb.brb08) THEN
          LET g_brb.brb08 = 0
       END IF
       LET g_brb.brb33 = 0  
       LET g_brb.brb31 = b_bmy.bmy34  
       IF g_bra014='Y' THEN 
          INITIALIZE g_bmb.* TO NULL
          LET g_bmb.bmb01 =b_bmy.bmy14 LET g_bmb.bmb29 =b_bmy.bmy29 
          LET g_bmb.bmb30 =b_bmy.bmy30 LET g_bmb.bmb03 =b_bmy.bmy05
          LET g_bmb.bmb04 =g_bmx.bmx07 LET g_bmb.bmb06 =b_bmy.bmy06
          LET g_bmb.bmb07 =b_bmy.bmy07 LET g_bmb.bmb16 =b_bmy.bmy16
          LET g_bmb.bmb24 =g_bmx.bmx01 LET g_bmb.bmb25 =b_bmy.bmy25
          LET g_bmb.bmb26 =b_bmy.bmy26 LET g_bmb.bmb13 =b_bmy.bmy13
          LET g_bmb.bmb18 =b_bmy.bmy18 LET g_bmb.bmb08 =b_bmy.bmy08
          LET g_bmb.bmb081=b_bmy.bmy081 LET g_bmb.bmb082=b_bmy.bmy082  #Add No:TQC-AC0300
          LET g_bmb.bmb11 =b_bmy.bmy11 LET g_bmb.bmb09 =g_brb.brb09
          LET g_bmb.bmb10 =b_bmy.bmy10 LET g_bmb.bmb10_fac =b_bmy.bmy10_fac
          LET g_bmb.bmb31 =b_bmy.bmy34 LET g_bmb.bmb27=g_brb.brb27 
          LET g_bmb.bmb10_fac2=b_bmy.bmy10_fac2
          LET g_bmb.bmb14 =b_bmy.bmy35 LET g_bmb.bmb15 =b_bmy.bmy21  
          LET g_bmb.bmb17 ='N' 
          LET g_bmb.bmb19 ='1'
          LET g_bmb.bmb34 =b_bmy.bmy38  #FUN-E70037 add

          LET g_sql = "SELECT MAX(bmb02) FROM ",g_dbs_sep CLIPPED,"bmb_file",
                      " WHERE bmb01 = '",g_bmb.bmb01,"'",
                      "   AND bmb29 = '",g_bmb.bmb29,"'"
          PREPARE i720sub_sel_p47 FROM g_sql
          EXECUTE i720sub_sel_p47 INTO g_bmb.bmb02

          IF cl_null(g_bmb.bmb02) THEN
             LET g_bmb.bmb02 = 0
          END IF
          LET g_bmb.bmb02=g_bmb.bmb02+g_sma.sma19                 
          IF NOT cl_null(b_bmy.bmy20) THEN LET g_bmb.bmb19 =b_bmy.bmy20 END IF  
         #LET g_bmb.bmb23 =0        #MOD-A90160 mark   
          LET g_bmb.bmb23 = 100     #MOD-A90160 add 
          LET g_bmb.bmb28 =b_bmy.bmy23  
          IF cl_null(g_bmb.bmb28) THEN
             LET g_bmb.bmb28 =0
          END IF
          IF cl_null(g_bmb.bmb08) THEN
             LET g_bmb.bmb08 = 0
          END IF
          #Add No:TQC-AC0300
          IF cl_null(g_bmb.bmb081) THEN
             LET g_bmb.bmb081 = 0
          END IF
          IF cl_null(g_bmb.bmb082) THEN
             LET g_bmb.bmb082 = 1
          END IF
          #End Add No:TQC-AC0300
          LET g_bmb.bmb33 = 0                  
          LET g_bmb.bmb31 = b_bmy.bmy34 
          LET g_bmb.bmbdate = g_today 

          LET g_sql = "SELECT SUM(brb06) FROM ",g_dbs_sep CLIPPED,"brb_file,",g_dbs_sep CLIPPED,"bra_file",
                      " WHERE bra01 = brb01 ",
                      "   AND bra011= brb011 ",
                      "   AND bra012= brb012 ",
                      "   AND bra013= brb013 ",
                      "   AND bra06 = brb29 ",
                      "   AND bra10 = '2' ",
                      "   AND brb01 = '",g_brb.brb01,"'",
                      "   AND brb011= '",g_brb.brb011,"'",
                      "   AND brb09 = '",l_ecb06,"'",
                      "   AND brb29 = '",g_brb.brb29,"'",
                      "   AND brb03 = '",g_brb.brb03,"'"
          PREPARE i720sub_sel_p48 FROM g_sql
          EXECUTE i720sub_sel_p48 INTO l_brb06

          IF cl_null(l_brb06) THEN 
             LET l_brb06=0
          END IF    
          LET g_bmb.bmb06=l_brb06+b_bmy.bmy06
          CALL s_carry_p_cs()
          CALL s_carry_col('bmb_file') RETURNING l_str1_bmb,l_str2_bmb,l_str3_bmb
          LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmb_file",
                      " VALUES(",l_str2_bmb,")"
          PREPARE i720sub_ins_bmb2 FROM g_sql
          EXECUTE i720sub_ins_bmb2 USING g_bmb.*
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
             LET g_showmsg = g_bmx.bmx01,'ins brb:'
             CALL s_errmsg('brb01',g_bmb.bmb01,g_showmsg,SQLCA.sqlcode,1)
             LET g_success='N'
          END IF            
       END IF             
 #FUN-A70125 --begin--
       IF cl_null(g_brb.brb012) THEN
          LET g_brb.brb012 = ' ' 
       END IF 
       IF cl_null(g_brb.brb013) THEN
          LET g_brb.brb013 = 0 
       END IF 
 #FUN-A70125 --end--
       CALL s_carry_p_cs()
       CALL s_carry_col('brb_file') RETURNING l_str1_brb,l_str2_brb,l_str3_brb
       LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"brb_file",
                   " VALUES(",l_str2_brb,")"
       PREPARE i720sub_ins_brb1 FROM g_sql
       EXECUTE i720sub_ins_brb1 USING g_brb.*
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          LET g_showmsg = g_bmx.bmx01,' insert brb_file:'                  
          CALL s_errmsg('bmx01','',g_showmsg,SQLCA.SQLCODE,1)
          LET g_success='N'
       END IF      
    END IF 
    #No.FUN-A60008--end 
END FUNCTION

FUNCTION i720sub_s3()
   DEFINE l_bmt		RECORD LIKE bmt_file.*
   DEFINE l_ima151      LIKE ima_file.ima151  
   DEFINE l_cnt         LIKE type_file.num5  
   DEFINE l_bmc		RECORD LIKE bmc_file.* 
   DEFINE l_brb06       LIKE brb_file.brb06 
   DEFINE l_str1_bmb    STRING
   DEFINE l_str2_bmb    STRING
   DEFINE l_str3_bmb    STRING
   DEFINE l_str1_brb STRING
   DEFINE l_str2_brb STRING
   DEFINE l_str3_brb STRING
   DEFINE l_str1_bmc    STRING
   DEFINE l_str2_bmc    STRING
   DEFINE l_str3_bmc    STRING
   DEFINE l_str1_bmt    STRING
   DEFINE l_str2_bmt    STRING
   DEFINE l_str3_bmt    STRING
   DEFINE l_aza121      LIKE aza_file.aza121
   DEFINE l_do_del_bmt  LIKE type_file.chr1 #FUN-B20003 add 
  #FUN-E70037--add str--
   DEFINE l_bmy29       LIKE bmy_file.bmy29
   DEFINE l_bmya04      LIKE bmya_file.bmya04
   DEFINE l_bmya05      LIKE bmya_file.bmya05
   DEFINE l_bmyb04      LIKE bmyb_file.bmyb04
   DEFINE l_bmyb05      LIKE bmyb_file.bmyb05
   DEFINE l_bmyc04      LIKE bmyc_file.bmyc04
   DEFINE l_bmyd04      LIKE bmyd_file.bmyd04
   DEFINE l_bmba        RECORD LIKE bmba_file.*
   DEFINE l_bmbb        RECORD LIKE bmbb_file.*
   DEFINE l_bmbc        RECORD LIKE bmbc_file.*
   DEFINE l_bmbd        RECORD LIKE bmbd_file.*
   DEFINE l_bmb02_t     LIKE bmb_file.bmb02
  #FUN-E70037--add end--

  #No.FUN-A60008--begin
    LET g_sql = "SELECT bra014 FROM ",g_dbs_sep CLIPPED,"bra_file",
                " WHERE bra01 = '",b_bmy.bmy14,"'",
                "   AND bra011= '",b_bmy.bmy011,"'",
                "   AND bra012= '",b_bmy.bmy012,"'",
                "   AND bra013= '",b_bmy.bmy013,"'"
    PREPARE i720sub_sel_p53 FROM g_sql
    EXECUTE i720sub_sel_p53 INTO g_bra014
  #No.FUN-A60008--end   

   LET g_bmb.bmb04 =g_bmx.bmx07
   LET g_bmb.bmb05 =NULL
   LET g_bmb.bmb06 =b_bmy.bmy06
   LET g_bmb.bmb07 =b_bmy.bmy07
   LET g_bmb.bmb16 =b_bmy.bmy16
   LET g_bmb.bmb24 =g_bmx.bmx01
   IF NOT cl_null(b_bmy.bmy25) THEN LET g_bmb.bmb25 =b_bmy.bmy25 END IF
   IF NOT cl_null(b_bmy.bmy26) THEN LET g_bmb.bmb26 =b_bmy.bmy26 END IF
   IF NOT cl_null(b_bmy.bmy13) THEN LET g_bmb.bmb13 =b_bmy.bmy13 END IF
   IF NOT cl_null(b_bmy.bmy18) THEN LET g_bmb.bmb18 =b_bmy.bmy18 END IF
   IF NOT cl_null(b_bmy.bmy08) THEN LET g_bmb.bmb08 =b_bmy.bmy08 END IF
   IF NOT cl_null(b_bmy.bmy081) THEN LET g_bmb.bmb081 =b_bmy.bmy081 END IF  #Add No:TQC-AC0300
   IF NOT cl_null(b_bmy.bmy082) THEN LET g_bmb.bmb082 =b_bmy.bmy082 END IF  #Add No:TQC-AC0300
   IF NOT cl_null(b_bmy.bmy11) THEN LET g_bmb.bmb11 =b_bmy.bmy11 END IF
   IF NOT cl_null(b_bmy.bmy20) THEN LET g_bmb.bmb19 =b_bmy.bmy20 END IF
   IF NOT cl_null(b_bmy.bmy09) THEN LET g_bmb.bmb09 =b_bmy.bmy09 END IF
   IF NOT cl_null(b_bmy.bmy10) THEN LET g_bmb.bmb10 =b_bmy.bmy10 END IF
   IF NOT cl_null(b_bmy.bmy35) THEN LET g_bmb.bmb14 =b_bmy.bmy35 END IF   #MOD-C20059
   IF NOT cl_null(b_bmy.bmy361) THEN LET g_bmb.bmb36 =b_bmy.bmy361 END IF #FUN-D10093 add
   IF NOT cl_null(b_bmy.bmy37) THEN LET g_bmb.bmb37 =b_bmy.bmy37 END IF   #FUN-D10093 add
   IF NOT cl_null(b_bmy.bmy38) THEN LET g_bmb.bmb34 =b_bmy.bmy38 END IF   #FUN-E70037 add
   IF NOT cl_null(b_bmy.bmy10_fac) THEN
      LET g_bmb.bmb10_fac =b_bmy.bmy10_fac
   END IF
  #MOD-B60018---add---start---
   IF NOT cl_null(b_bmy.bmy10_fac2) THEN
      LET g_bmb.bmb10_fac2 =b_bmy.bmy10_fac2
   END IF
  #MOD-B60018---add---end---
   IF NOT cl_null(b_bmy.bmy21) THEN LET g_bmb.bmb15 =b_bmy.bmy21 END IF
   IF NOT cl_null(b_bmy.bmy23) THEN LET g_bmb.bmb28 =b_bmy.bmy23 END IF
   LET g_bmb.bmbmodu = g_user
   LET g_bmb.bmbdate = g_today
   LET l_bmb02_t = g_bmb.bmb02 #FUN-E70037 add
   IF g_argv1_str='1' THEN  #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
       LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmb_file",
                   "   SET bmb05 = '",g_bmx.bmx07,"',",
                   "       bmbdate = '",g_today,"',",    #FUN-C40007 add 
                   "       bmb30 = '",b_bmy.bmy30,"',",  #FUN-D10093 mod
                   "       bmb36 = '",g_bmb.bmb36,"',",  #FUN-D10093 add
                   "       bmb37 = '",g_bmb.bmb37,"' ",  #FUN-D10093 add
                   " WHERE bmb01 = '",g_bmb01,"'",
                   "   AND bmb02 = '",g_bmb02,"'",
                   "   AND bmb03 = '",g_bmb03,"'",
                   "   AND bmb04 = '",g_bmb04,"'",
                   "   AND bmb29 = '",g_bmb29,"'" 
       PREPARE i720sub_upd_p8 FROM g_sql
       EXECUTE i720sub_upd_p8
       DISPLAY "FUN-D10093(2)",g_sql
     #FUN-F50035 add str---
      IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN
         CALL i720_del_vmo()
      END IF
     #FUN-F50035 add end---
   END IF 
   #No.FUN-A60008--begin 
   IF g_argv1_str='2' THEN   #CHI-CA0035 mod g_argv3->g_argv1
       LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"brb_file",
                  #"   SET brb05 = '",g_bmx.bmx07,"'",  #MOD-E70053 mark
                   "   SET brb05 = '",g_bmx.bmx07,"',", #MOD-E70053 add
                   "       brb30 = '",b_bmy.bmy30,"'",
                   " WHERE brb01 = '",g_brb.brb01,"'", 
                   "   AND brb02 = '",g_brb.brb02,"'", 
                   "   AND brb011= '",g_brb.brb011,"'", 
                   "   AND brb012= '",g_brb.brb012,"'",
                   "   AND brb013= '",g_brb.brb013,"'", 
                   "   AND brb03 = '",g_brb.brb03,"'", 
                   "   AND brb04 = '",g_brb.brb04,"'", 
                   "   AND brb29 = '",g_brb.brb29,"'"
       PREPARE i720sub_upd_p13 FROM g_sql
       EXECUTE i720sub_upd_p13
   END IF 	
   #No.FUN-A60008--end  
   IF SQLCA.SQLCODE THEN
      LET g_showmsg = g_bmx.bmx01,' update bmb05,bmb30:'                  
      CALL s_errmsg('bmb01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
      LET g_success='N'
   END IF
   LET g_bmb.bmb29 =b_bmy.bmy29 
   LET g_bmb.bmb30 =b_bmy.bmy30 
   LET g_sql = "SELECT MAX(bmb02) FROM ",g_dbs_sep CLIPPED,"bmb_file",
               " WHERE bmb01 = '",g_bmb.bmb01,"'",
               "   AND bmb29 = '",g_bmb.bmb29,"'" 
   PREPARE i720sub_sel_p16 FROM g_sql
   EXECUTE i720sub_sel_p16 INTO g_bmb.bmb02
   IF cl_null(g_bmb.bmb02) THEN LET g_bmb.bmb02 = 0 END IF
   LET g_bmb.bmb02 = g_bmb.bmb02 + g_sma.sma19
   IF cl_null(g_bmb.bmb28) THEN LET g_bmb.bmb28 =0 END IF
   IF cl_null(g_bmb.bmb02)  THEN
      LET g_bmb.bmb02=' '
   END IF
   IF cl_null(g_bmb.bmb08) THEN
      LET g_bmb.bmb08 = 0
   END IF
   #Add No:TQC-AC0300
   IF cl_null(g_bmb.bmb081) THEN
      LET g_bmb.bmb081 = 0
   END IF
   IF cl_null(g_bmb.bmb082) THEN
      LET g_bmb.bmb082 = 1
   END IF
   #End Add No:TQC-AC0300
   LET g_bmb.bmb33 = 0            
   LET g_bmb.bmb31 = b_bmy.bmy34  

   LET g_sql = "SELECT ima151 FROM ",g_dbs_sep CLIPPED,"ima_file,",g_dbs_sep CLIPPED,"bmy_file",
               " WHERE bmy14 = ima01 ",
               "   AND bmy14 = '",b_bmy.bmy14,"'",
               "   AND bmy01 = '",g_bmx.bmx01,"'",
               "   AND bmy02 = '",b_bmy.bmy02,"'"
   PREPARE i720sub_sel_p17 FROM g_sql
   EXECUTE i720sub_sel_p17 INTO l_ima151
   IF g_argv1_str='1' THEN  #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
       IF l_ima151 = 'Y' THEN
          LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmy_file",
                      "   SET bmy33 = '",g_bmb.bmb02,"'",
                      " WHERE bmy01 = '",g_bmx.bmx01,"'",
                      "   AND bmy02 = '",b_bmy.bmy02,"'",
                      "   AND bmy14 = '",b_bmy.bmy14,"'"
          PREPARE i720sub_upd_p9 FROM g_sql
          EXECUTE i720sub_upd_p9
          IF SQLCA.sqlcode THEN
              LET g_showmsg = g_bmx.bmx01,' update bmy_file:'                    
              CALL s_errmsg('bmy33',g_plant,g_showmsg,SQLCA.SQLCODE,1)
              LET g_success='N'
         END IF
       ELSE
         LET g_bmb.bmb33 = b_bmy.bmy33
       END IF
       #EX:原BOM 10 A ,ECN後,會將BOM 10 A失效後,再新增10 A生效,因生效日期為key值之一。 
       #PLM時==>若在同一天BOM生效又做ECN時,則覆蓋原項次資料,維持一筆即可 (EX:BOM 10 A 生效日10/3/3,在10/3/3做ECN變更)
       LET g_sql = "SELECT aza121 FROM ",g_dbs_sep CLIPPEd,"aza_file"
       PREPARE i720sub_sel_p32 FROM g_sql
       EXECUTE i720sub_sel_p32 INTO l_aza121 #aza121:是否與PLM整合
      
       IF g_prog = 'aws_ttsrv2' OR l_aza121 = 'Y' THEN #若與PLM整合時,由ERP執行的邏輯要與用PLM傳過來的邏輯一致
           LET g_sql = "SELECT bmb02 FROM ",g_dbs_sep CLIPPEd,"bmb_file",
                      #FUN-AC0060(110705)---mod----str-----
                      #" WHERE ROWID = '",g_bmb_rowid,"'"
                       " WHERE bmb01 = '",g_bmb01,"'",
                       "   AND bmb02 = '",g_bmb02,"'",
                       "   AND bmb03 = '",g_bmb03,"'",
                       "   AND bmb04 = '",g_bmb04,"'",
                       "   AND bmb29 = '",g_bmb29,"'" 
                      #FUN-AC0060(110705)---mod----end-----
           PREPARE i720sub_sel_p18 FROM g_sql
           EXECUTE i720sub_sel_p18 INTO g_bmb.bmb02
      
           LET g_bmb.bmb04 = g_bmx.bmx07
      
           LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmb_file",
                       " WHERE bmb01 = '",g_bmb.bmb01,"'",
                       "   AND bmb02 = '",g_bmb.bmb02,"'",
                       "   AND bmb03 = '",g_bmb.bmb03,"'",
                       "   AND bmb04 = '",g_bmb.bmb04,"'",
                       "   AND bmb29 = '",g_bmb.bmb29,"'" 
           PREPARE i720sub_sel_p19 FROM g_sql
           EXECUTE i720sub_sel_p19 INTO l_cnt
           IF l_cnt >=1 THEN
              LET g_sql = "DELETE FROM ",g_dbs_sep CLIPPED,"bmb_file",
                         #FUN-AC0060(110705)---mod----str-----
                         #" WHERE ROWID = '",g_bmb_rowid,"'"
                          " WHERE bmb01 = '",g_bmb01,"'",
                          "   AND bmb02 = '",g_bmb02,"'",
                          "   AND bmb03 = '",g_bmb03,"'",
                          "   AND bmb04 = '",g_bmb04,"'",
                          "   AND bmb29 = '",g_bmb29,"'" 
                         #FUN-AC0060(110705)---mod----end-----
              PREPARE i720sub_del_bmb2 FROM g_sql
              EXECUTE i720sub_del_bmb2 
           END IF
       END IF
       IF cl_null(g_bmb.bmb34) THEN LET g_bmb.bmb34 = 0  END IF  #TQC-DA0015 add
       CALL s_carry_p_cs()
       CALL s_carry_col('bmb_file') RETURNING l_str1_bmb,l_str2_bmb,l_str3_bmb
       LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmb_file",
                   " VALUES(",l_str2_bmb,")"
       PREPARE i720sub_ins_bmb3 FROM g_sql
       EXECUTE i720sub_ins_bmb3 USING g_bmb.*
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          LET g_showmsg = g_bmb.bmb01,' insert bmb_file:'                  
          CALL s_errmsg('bmb01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
          LET g_success='N'
       END IF
     #FUN-F50035 add str-----
      IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN #與APS整合
         CALL i720_ins_vmo()
      END IF
     #FUN-F50035 add end-----      

      #FUN-E70037--add--str--
      #ADD ABOUT COLOR SIZE
       IF g_success = 'Y' AND s_industry('slk') AND g_sma.sma150 = 'Y' AND NOT cl_null(b_bmy.bmy38) THEN
          SELECT bmy29 INTO l_bmy29 FROM bmy_file
           WHERE bmy01 = g_bmx.bmx01 AND bmy02 = b_bmy.bmy02 AND bmy38 = g_bmb.bmb34
          DELETE FROM bmba_file WHERE bmba01 = g_bmb.bmb01
                                  AND bmba02 = l_bmb02_t
                                  AND bmba03 = g_bmb.bmb03
                                  AND bmba29 = l_bmy29
          DELETE FROM bmbb_file WHERE bmbb01 = g_bmb.bmb03
                                  AND bmbb02 = l_bmb02_t
                                  AND bmbb03 = g_bmb.bmb03
                                  AND bmbb29 = l_bmy29
          DELETE FROM bmbc_file WHERE bmbc01 = g_bmb.bmb03
                                  AND bmbc02 = l_bmb02_t
                                  AND bmbc03 = g_bmb.bmb03
                                  AND bmbc29 = l_bmy29
          DELETE FROM bmbd_file WHERE bmbd01 = g_bmb.bmb03
                                  AND bmbd02 = l_bmb02_t
                                  AND bmbd03 = g_bmb.bmb03
                                  AND bmbd29 = l_bmy29
          IF g_bmb.bmb34 MATCHES '[23]' THEN
            DECLARE i720_s3_bmya CURSOR FOR
             SELECT bmya04,bmya05 FROM bmya_file
              WHERE bmya01 = g_bmx.bmx01
                AND bmya02 = b_bmy.bmy02
            FOREACH i720_s3_bmya INTO l_bmya04,l_bmya05
               IF NOT cl_null(l_bmya04) AND NOT cl_null(l_bmya05) THEN
                    LET l_bmba.bmba01 = g_bmb.bmb01
                    LET l_bmba.bmba02 = g_bmb.bmb02
                    LET l_bmba.bmba03 = g_bmb.bmb03
                    LET l_bmba.bmba04 = g_bmb.bmb04
                    LET l_bmba.bmba05 = l_bmya04
                    LET l_bmba.bmba06 = l_bmya05
                    LET l_bmba.bmba29 = l_bmy29
                    INSERT INTO bmba_file VALUES (l_bmba.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                       LET g_showmsg = g_bmb.bmb01,'ins bmba:'
                       CALL s_errmsg('bmba01',g_bmb.bmb01,g_showmsg,SQLCA.sqlcode,1)
                       LET g_success = 'N'
                    END IF
               END IF
            END FOREACH
         END IF
         IF g_bmb.bmb34 MATCHES '[24]' THEN
            DECLARE i720_s3_bmyb CURSOR FOR
             SELECT bmyb04,bmyb05 FROM bmyb_file
              WHERE bmyb01 = g_bmx.bmx01
                AND bmyb02 = b_bmy.bmy02
            FOREACH i720_s3_bmyb INTO l_bmyb04,l_bmyb05
               IF NOT cl_null(l_bmyb04) AND NOT cl_null(l_bmyb05) THEN
                    LET l_bmbb.bmbb01 = g_bmb.bmb01
                    LET l_bmbb.bmbb02 = g_bmb.bmb02
                    LET l_bmbb.bmbb03 = g_bmb.bmb03
                    LET l_bmbb.bmbb04 = g_bmb.bmb04
                    LET l_bmbb.bmbb05 = l_bmyb04
                    LET l_bmbb.bmbb06 = l_bmyb05
                    LET l_bmbb.bmbb29 = l_bmy29
                    INSERT INTO bmbb_file VALUES (l_bmbb.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                       LET g_showmsg = g_bmb.bmb01,'ins bmbb:'
                       CALL s_errmsg('bmbb01',g_bmb.bmb01,g_showmsg,SQLCA.sqlcode,1)
                       LET g_success = 'N'
                    END IF
               END IF
            END FOREACH
         END IF
         IF g_bmb.bmb34 MATCHES '[56]' THEN
            DECLARE i720_s3_bmyc CURSOR FOR
             SELECT bmyc04 FROM bmyc_file
              WHERE bmyc01 = g_bmx.bmx01
                AND bmyc02 = b_bmy.bmy02
            FOREACH i720_s3_bmyc INTO l_bmyc04
               IF NOT cl_null(l_bmyc04) THEN
                    LET l_bmbc.bmbc01 = g_bmb.bmb01
                    LET l_bmbc.bmbc02 = g_bmb.bmb02
                    LET l_bmbc.bmbc03 = g_bmb.bmb03
                    LET l_bmbc.bmbc04 = g_bmb.bmb04
                    LET l_bmbc.bmbc05 = l_bmyc04
                    LET l_bmbc.bmbc29 = l_bmy29
                    INSERT INTO bmbc_file VALUES (l_bmbc.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                       LET g_showmsg = g_bmb.bmb01,'ins bmbc:'
                       CALL s_errmsg('bmbc01',g_bmb.bmb01,g_showmsg,SQLCA.sqlcode,1)
                       LET g_success = 'N'
                    END IF
               END IF
            END FOREACH
         END IF
         IF g_bmb.bmb34 MATCHES '[57]' THEN
            DECLARE i720_s3_bmyd CURSOR FOR
             SELECT bmyd04 FROM bmyd_file
              WHERE bmyd01 = g_bmx.bmx01
                AND bmyd02 = b_bmy.bmy02
            FOREACH i720_s3_bmyd INTO l_bmyc04
               IF NOT cl_null(l_bmyc04) THEN
                    LET l_bmbd.bmbd01 = g_bmb.bmb01
                    LET l_bmbd.bmbd02 = g_bmb.bmb02
                    LET l_bmbd.bmbd03 = g_bmb.bmb03
                    LET l_bmbd.bmbd04 = g_bmb.bmb04
                    LET l_bmbd.bmbd05 = l_bmyc04
                    LET l_bmbd.bmbd29 = l_bmy29
                    INSERT INTO bmbd_file VALUES (l_bmbd.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                       LET g_showmsg = g_bmb.bmb01,'ins bmbd:'
                       CALL s_errmsg('bmbd01',g_bmb.bmb01,g_showmsg,SQLCA.sqlcode,1)
                       LET g_success = 'N'
                    END IF
               END IF
            END FOREACH
         END IF
      END IF
      IF g_success = 'Y' AND s_industry('slk') AND g_sma.sma150 = 'Y' AND cl_null(b_bmy.bmy38) THEN
         UPDATE bmba_file SET bmba01 = g_bmb.bmb01,
                              bmba02 = g_bmb.bmb02,
                              bmba03 = g_bmb.bmb03,
                              bmba04 = g_bmb.bmb04,
                              bmba29 = g_bmb.bmb29
                        WHERE bmba01 = g_bmb.bmb01
                          AND bmba02 = l_bmb02_t
                          AND bmba03 = g_bmb.bmb03
                          AND bmba29 = g_bmb.bmb29

         UPDATE bmbb_file SET bmbb01 = g_bmb.bmb01,
                              bmbb02 = g_bmb.bmb02,
                              bmbb03 = g_bmb.bmb03,
                              bmbb04 = g_bmb.bmb04,
                              bmbb29 = g_bmb.bmb29
                        WHERE bmbb01 = g_bmb.bmb01
                          AND bmbb02 = l_bmb02_t
                          AND bmbb03 = g_bmb.bmb03
                          AND bmbb29 = g_bmb.bmb29

         UPDATE bmbc_file SET bmbc01 = g_bmb.bmb01,
                              bmbc02 = g_bmb.bmb02,
                              bmbc03 = g_bmb.bmb03,
                              bmbc04 = g_bmb.bmb04,
                              bmbc29 = g_bmb.bmb29
                        WHERE bmbc01 = g_bmb.bmb01
                          AND bmbc02 = l_bmb02_t
                          AND bmbc03 = g_bmb.bmb03
                          AND bmbc29 = g_bmb.bmb29
         UPDATE bmbd_file SET bmbd01 = g_bmb.bmb01,
                              bmbd04 = g_bmb.bmb04,
                              bmbd29 = g_bmb.bmb29
                        WHERE bmbd01 = g_bmb.bmb01
                          AND bmbd02 = l_bmb02_t
                          AND bmbd03 = g_bmb.bmb03
                          AND bmbd29 = g_bmb.bmb29
      END IF
     #FUN-E70037--add end--
       IF g_sma.sma845='Y'   #低階碼可否部份重計
          THEN
          CALL s_decl_bmb_m(g_dbs_sep)
          CALL s_uima146_m(g_bmb.bmb03,g_dbs_sep)
          CALL cl_msg("")                              
       END IF
      
       LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmw_file",
                   " WHERE bmw01 = '",g_bmx.bmx01,"'",
                   "   AND bmw02 = '",b_bmy.bmy02,"'"
       PREPARE i720sub_sel_p20 FROM g_sql
       EXECUTE i720sub_sel_p20 INTO g_cnt
       IF g_cnt=0 THEN
           INITIALIZE l_bmt.* TO NULL
           LET g_sql = "SELECT * FROM ",g_dbs_sep CLIPPEd,"bmt_file",
                       " WHERE bmt01 = '",b_bmy.bmy14,"'",
                       "   AND bmt03 = '",b_bmy.bmy05,"'",
                       "   AND bmt04 IN (SELECT MAX(bmt04) FROM ",g_dbs_sep CLIPPED,"bmt_file",
                       "                  WHERE bmt01 = '",b_bmy.bmy14,"'",
                       "                    AND bmt03 = '",b_bmy.bmy05,"')"
           PREPARE i720sub_s3_p1 FROM g_sql
           DECLARE i720sub_s3_c3 CURSOR FOR i720sub_s3_p1
           
           LET l_cnt=0
           FOREACH i720sub_s3_c3 INTO b_bmt.*
              #FUN-B20003---add----str---
              IF g_prog = 'aws_ttsrv2' OR l_aza121 = 'Y' THEN #若與PLM整合時,由ERP執行的邏輯要與用PLM傳過來的邏輯一致
                  LET g_sql = "DELETE FROM ",g_dbs_sep CLIPPED,"bmt_file",
                              " WHERE bmt01 = '",b_bmt.bmt01,"'",
                              "   AND bmt02 = '",b_bmt.bmt02,"'",
                              "   AND bmt03 = '",b_bmt.bmt03,"'",
                              "   AND bmt04 = '",b_bmt.bmt04,"'",
                              "   AND bmt08 = '",b_bmt.bmt08,"'"
                  PREPARE i720sub_del_bmt3 FROM g_sql
                  EXECUTE i720sub_del_bmt3
                  EXIT FOREACH
              END IF
              #FUN-B20003---add----end---
              LET l_cnt=l_cnt+1
             #IF l_cnt=1 THEN                                          #FUN-B80071 mark
              IF l_cnt=1 AND (g_bgjob = 'N' OR cl_null(g_bgjob)) THEN  #FUN-B80071 add
                 LET g_sql=cl_getmsg('abm-040',g_lang)
                 IF NOT cl_prompt(0,0,g_sql) THEN EXIT FOREACH END IF
              END IF
              LET l_bmt.bmt01=g_bmb.bmb01
              LET l_bmt.bmt02=g_bmb.bmb02
              LET l_bmt.bmt03=g_bmb.bmb03
              LET l_bmt.bmt04=g_today
              LET l_bmt.bmt05=b_bmt.bmt05
              LET l_bmt.bmt06=b_bmt.bmt06
              LET l_bmt.bmt07=b_bmt.bmt07
              LET l_bmt.bmt08=g_bmb.bmb29 
              CALL s_carry_p_cs()
              CALL s_carry_col('bmt_file') RETURNING l_str1_bmt,l_str2_bmt,l_str3_bmt
              LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmt_file",
                          " VALUES(",l_str2_bmt,")"
              PREPARE i720sub_ins_bmt2 FROM g_sql
              EXECUTE i720sub_ins_bmt2 USING l_bmt.*
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                 LET g_showmsg = l_bmt.bmt01,' insert bmt_file:#2'                  
                 CALL s_errmsg('bmt01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
                 LET g_success='N'
              END IF
           END FOREACH
           CALL i720sub_up_bmb13() #FUN-B20003 add
           INITIALIZE l_bmt.* TO NULL
       ELSE
      
           LET g_sql = "SELECT * FROM ",g_dbs_sep CLIPPED,"bmw_file",
                       " WHERE bmw01 = '",g_bmx.bmx01,"'",
                       "   AND bmw02 = '",b_bmy.bmy02,"'"
           PREPARE i720sub_s3 FROM g_sql
           DECLARE i720sub_s3_c2 CURSOR FOR i720sub_s3
           LET l_do_del_bmt = 'N' #FUN-B20003 add
           FOREACH i720sub_s3_c2 INTO b_bmw.*
              LET l_bmt.bmt01=g_bmb.bmb01
              LET l_bmt.bmt02=g_bmb.bmb02
              LET l_bmt.bmt03=g_bmb.bmb03
              LET l_bmt.bmt04=g_bmb.bmb04
              LET l_bmt.bmt05=b_bmw.bmw03
              LET l_bmt.bmt06=b_bmw.bmw04
              LET l_bmt.bmt07=b_bmw.bmw05
              LET l_bmt.bmt08=g_bmb.bmb29 
              IF cl_null(l_bmt.bmt02) THEN
                 LET l_bmt.bmt02=0
              END IF
              IF l_do_del_bmt = 'N' THEN #FUN-B20003 add if 判斷
                  IF g_prog = 'aws_ttsrv2' OR l_aza121 = 'Y' THEN #若與PLM整合時,由ERP執行的邏輯要與用PLM傳過來的邏輯一致
                      LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmt_file",
                                  " WHERE bmt01 = '",l_bmt.bmt01,"'",
                                  "   AND bmt02 = '",l_bmt.bmt02,"'",
                                  "   AND bmt03 = '",l_bmt.bmt03,"'",
                                  "   AND bmt04 = '",l_bmt.bmt04,"'",
                                  "   AND bmt05 = '",l_bmt.bmt05,"'",
                                  "   AND bmt08 = '",l_bmt.bmt08,"'"
                      PREPARE i720sub_sel_p21 FROM g_sql
                      EXECUTE i720sub_sel_p21 INTO l_cnt
                      IF l_cnt >=1 THEN
                          LET g_sql = "DELETE FROM ",g_dbs_sep CLIPPED,"bmt_file",
                                      " WHERE bmt01 = '",l_bmt.bmt01,"'",
                                      "   AND bmt02 = '",l_bmt.bmt02,"'",
                                      "   AND bmt03 = '",l_bmt.bmt03,"'",
                                      "   AND bmt04 = '",l_bmt.bmt04,"'",
                                     #"   AND bmt05 = '",l_bmt.bmt05,"'", #FUN-B20003 mark,因為有可能刪了某個插件位置,借此指令一次刪除
                                      "   AND bmt08 = '",l_bmt.bmt08,"'"
                          PREPARE i720sub_del_bmt2 FROM g_sql
                          EXECUTE i720sub_del_bmt2 
                          LET l_do_del_bmt = 'Y' #FUN-B20003 add
                      END IF
                  END IF
              END IF #FUN-B20003 add 
              CALL s_carry_p_cs()
              CALL s_carry_col('bmt_file') RETURNING l_str1_bmt,l_str2_bmt,l_str3_bmt
              LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmt_file",
                          " VALUES(",l_str2_bmt,")"
              PREPARE i720sub_ins_bmt3 FROM g_sql
              EXECUTE i720sub_ins_bmt3 USING l_bmt.*
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                CALL cl_err('ins bmt: ',SQLCA.SQLCODE,1)
                 LET g_showmsg = l_bmt.bmt01,' insert bmt_file:#3'                  
                 CALL s_errmsg('bmt01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
                 LET g_success='N'
              END IF
           END FOREACH
           CALL i720sub_up_bmb13()
      END IF
      
       #----- 說明檔(bmc_file)複製 ------------
       LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmf_file",
                   " WHERE bmf01 = '",g_bmx.bmx01,"'",
                   "   AND bmf02 = '",b_bmy.bmy02,"'"
       PREPARE i720sub_sel_p22 FROM g_sql
       EXECUTE i720sub_sel_p22 INTO g_cnt
       IF g_cnt=0 THEN RETURN END IF	# 有輸入才更新
      
       LET g_sql = "SELECT * FROM ",g_dbs_sep CLIPPED,"bmf_file",
                   " WHERE bmf01 = '",g_bmx.bmx01,"'",
                   "   AND bmf02 = '",b_bmy.bmy02,"'"
       PREPARE i720sub_s3_p2 FROM g_sql
       DECLARE i720sub_s3_c4 CURSOR FOR i720sub_s3_p2
      
       FOREACH i720sub_s3_c4 INTO b_bmf.*
          LET l_bmc.bmc01=g_bmb.bmb01
          LET l_bmc.bmc02=g_bmb.bmb02
          LET l_bmc.bmc021=g_bmb.bmb03
          LET l_bmc.bmc03=g_bmb.bmb04
          LET l_bmc.bmc04=b_bmf.bmf03
          LET l_bmc.bmc05=b_bmf.bmf04
          LET l_bmc.bmc06=g_bmb.bmb29
      
          CALL s_carry_p_cs()
          CALL s_carry_col('bmc_file') RETURNING l_str1_bmc,l_str2_bmc,l_str3_bmc
          LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmc_file",
                      " VALUES(",l_str2_bmc,")"
          PREPARE i720sub_ins_bmc2 FROM g_sql
          EXECUTE i720sub_ins_bmc2 USING l_bmc.*
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
             LET g_showmsg = g_plant,":",l_bmc.bmc01,' ins bmc:'
             CALL s_errmsg('bmc01',l_bmc.bmc01,g_showmsg,SQLCA.SQLCODE,1)
             LET g_success='N'
          END IF
       END FOREACH
   #No.FUN-A60008--begin
   ELSE 
       LET g_brb.brb011 =b_bmy.bmy011
       LET g_brb.brb012 =b_bmy.bmy012
       LET g_brb.brb013 =b_bmy.bmy013
       LET g_brb.brb04 =g_bmx.bmx07
       LET g_brb.brb05 =NULL
       LET g_brb.brb06 =b_bmy.bmy06
       LET g_brb.brb07 =b_bmy.bmy07
       LET g_brb.brb16 =b_bmy.bmy16
       LET g_brb.brb14 =b_bmy.bmy35 #CHI-A60028 add
       LET g_brb.brb24 =g_bmx.bmx01
       IF cl_null(g_brb.brb09) THEN 
          LET g_sql = "SELECT ecb06 FROM ",g_dbs_sep CLIPPEd,"ecb_file",
                      " WHERE ecb01 = '",g_brb.brb01,"'",
                      "   AND ecb02 = '",g_brb.brb011,"'",
                      "   AND ecb012= '",g_brb.brb012,"'", 
                      "   AND ecb03 = '",g_brb.brb013,"'"
          PREPARE i720sub_sel_p49 FROM g_sql
          EXECUTE i720sub_sel_p49 INTO g_brb.brb09
       END IF 
       IF NOT cl_null(b_bmy.bmy25) THEN LET g_brb.brb25 =b_bmy.bmy25 END IF
       IF NOT cl_null(b_bmy.bmy26) THEN LET g_brb.brb26 =b_bmy.bmy26 END IF
       IF NOT cl_null(b_bmy.bmy13) THEN LET g_brb.brb13 =b_bmy.bmy13 END IF
       IF NOT cl_null(b_bmy.bmy18) THEN LET g_brb.brb18 =b_bmy.bmy18 END IF
       IF NOT cl_null(b_bmy.bmy08) THEN LET g_brb.brb08 =b_bmy.bmy08 END IF
       IF NOT cl_null(b_bmy.bmy081) THEN LET g_brb.brb081 = b_bmy.bmy081 END IF    #FUN-AC0075
       IF NOT cl_null(b_bmy.bmy082) THEN LET g_brb.brb082 = b_bmy.bmy082 END IF    #FUN-AC0075
       IF NOT cl_null(b_bmy.bmy11) THEN LET g_brb.brb11 =b_bmy.bmy11 END IF
       IF NOT cl_null(b_bmy.bmy20) THEN LET g_brb.brb19 =b_bmy.bmy20 END IF
       IF NOT cl_null(b_bmy.bmy10) THEN LET g_brb.brb10 =b_bmy.bmy10 END IF
       IF NOT cl_null(b_bmy.bmy10_fac) THEN
          LET g_brb.brb10_fac =b_bmy.bmy10_fac
       END IF
       IF NOT cl_null(b_bmy.bmy21) THEN LET g_brb.brb15 =b_bmy.bmy21 END IF
       IF NOT cl_null(b_bmy.bmy23) THEN LET g_brb.brb28 =b_bmy.bmy23 END IF
       LET g_brb.brbmodu = g_user
       LET g_brb.brbdate = g_today  
       LET g_brb.brb29 =b_bmy.bmy29 
       LET g_brb.brb30 =b_bmy.bmy30 
       LET g_sql = "SELECT MAX(brb02) FROM ",g_dbs_sep CLIPPED,"brb_file",
                   " WHERE brb01 = '",g_brb.brb01,"'",
                   "   AND brb011= '",g_brb.brb011,"'", 
                   "   AND brb012= '",g_brb.brb012,"'", 
                   "   AND brb013= '",g_brb.brb013,"'",
                   "   AND brb29 = '",g_brb.brb29,"'"
       PREPARE i720sub_sel_p50 FROM g_sql
       EXECUTE i720sub_sel_p50 INTO g_brb.brb02
       IF cl_null(g_brb.brb02) THEN LET g_brb.brb02 = 0 END IF
       LET g_brb.brb02 = g_brb.brb02 + g_sma.sma19
       IF cl_null(g_brb.brb28) THEN LET g_brb.brb28 =0 END IF
       IF cl_null(g_brb.brb02)  THEN
          LET g_brb.brb02=' '
       END IF
       IF cl_null(g_brb.brb08) THEN
          LET g_brb.brb08 = 0
       END IF
       LET g_brb.brb33 = 0        
       LET g_brb.brb31 = b_bmy.bmy34  
 #FUN-A70125 --begin--
       IF cl_null(g_brb.brb012) THEN
          LET g_brb.brb012 = ' '
       END IF
       IF cl_null(g_brb.brb013) THEN
          LET g_brb.brb013 = 0
       END IF
 #FUN-A70125 --end--
       CALL s_carry_p_cs()
       CALL s_carry_col('brb_file') RETURNING l_str1_brb,l_str2_brb,l_str3_brb
       LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"brb_file",
                   " VALUES(",l_str2_brb,")"
       PREPARE i720sub_ins_brb2 FROM g_sql
       EXECUTE i720sub_ins_brb2 USING g_brb.*
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          LET g_showmsg = g_brb.brb01,' insert brb_file:'                  
          CALL s_errmsg('brb01','',g_showmsg,SQLCA.SQLCODE,1)
          LET g_success='N'
       END IF   	
       IF g_bra014='Y' THEN 
          LET g_sql = "DELETE FROM ",g_dbs_sep CLIPPED,"bmb_file",
                      " WHERE bmb01 = '",g_brb.brb01,"'",
                      "   AND bmb03 = '",g_brb.brb03,"'", 
                      "   AND bmb09 = '",g_brb.brb09,"'",
                      "   AND bmb29 = '",g_brb.brb29,"'"
          PREPARE i720sub_del_bmb3 FROM g_sql
          EXECUTE i720sub_del_bmb3 

          LET g_sql = "SELECT SUM(brb06) FROM ",g_dbs_sep CLIPPED,"brb_file",
                      " WHERE brb01 = '",g_brb.brb01,"'",
                      "   AND brb011= '",g_brb.brb011,"'", 
                      "   AND (brb012 != '",g_brb.brb012,"' OR brb013 != '",g_brb.brb013,"')",
                      "   AND brb09 = '",g_brb.brb09,"'",
                      "   AND brb29 = '",g_brb.brb29,"'", 
                      "   AND brb03 = '",g_brb.brb03,"'" 
          PREPARE i720sub_sel_p51 FROM g_sql
          EXECUTE i720sub_sel_p51 INTO l_brb06
          IF cl_null(l_brb06) THEN LET l_brb06=0 END IF 
          LET g_bmb.bmb01=g_brb.brb01   LET g_bmb.bmb03=g_brb.brb03
          LET g_bmb.bmb04 =g_bmx.bmx07  LET g_bmb.bmb29 =b_bmy.bmy29 
          LET g_bmb.bmb30 =b_bmy.bmy30  LET g_bmb.bmb05 =NULL
          LET g_sql = "SELECT MAX(bmb02) FROM ",g_dbs_sep CLIPPEd,"bmb_file",
                      " WHERE bmb01 = '",g_bmb.bmb01,"'",
                      "   AND bmb29 = '",g_bmb.bmb29,"'" 
          PREPARE i720sub_sel_p52 FROM g_sql
          EXECUTE i720sub_sel_p52 INTO g_bmb.bmb02
          IF cl_null(g_bmb.bmb02) THEN LET g_bmb.bmb02 = 0 END IF
          LET g_bmb.bmb02 = g_bmb.bmb02 + g_sma.sma19
          IF cl_null(g_bmb.bmb08) THEN
             LET g_bmb.bmb08 = 0
          END IF
          LET g_bmb.bmb33 = 0               
          IF cl_null(b_bmy.bmy06) THEN 
             LET b_bmy.bmy06=g_brb.brb06
          END IF 
          LET g_bmb.bmb06 =b_bmy.bmy06+l_brb06
          LET g_bmb.bmb09=g_brb.brb09
          LET g_bmb.bmb07=g_brb.brb07 LET g_bmb.bmb08=g_brb.brb08 
          LET g_bmb.bmb081=g_brb.brb081 LET g_bmb.bmb082=g_brb.brb082 
          LET g_bmb.bmb09=g_brb.brb09 LET g_bmb.bmb10=g_brb.brb10
          LET g_bmb.bmb10_fac=g_brb.brb10_fac LET g_bmb.bmb10_fac2=g_brb.brb10_fac2
          LET g_bmb.bmb11=g_brb.brb11 LET g_bmb.bmb13=g_brb.brb13
          LET g_bmb.bmb14=g_brb.brb14 LET g_bmb.bmb15=g_brb.brb15
          LET g_bmb.bmb16=g_brb.brb16 LET g_bmb.bmb17=g_brb.brb17
          LET g_bmb.bmb18=g_brb.brb18 LET g_bmb.bmb19=g_brb.brb19
          LET g_bmb.bmb20=g_brb.brb20 LET g_bmb.bmb21=g_brb.brb21
          LET g_bmb.bmb22=g_brb.brb22 LET g_bmb.bmb23=g_brb.brb23
          LET g_bmb.bmb25=g_brb.brb25 LET g_bmb.bmb26=g_brb.brb26
          LET g_bmb.bmb27=g_brb.brb27 LET g_bmb.bmb28=g_brb.brb28
          LET g_bmb.bmb31=g_brb.brb31 
          LET g_bmb.bmb24 =g_bmx.bmx01 
          LET g_bmb.bmbmodu = g_user
          LET g_bmb.bmbdate = g_today     
          IF NOT cl_null(b_bmy.bmy07) THEN LET g_bmb.bmb07 =b_bmy.bmy07 END IF
          IF NOT cl_null(b_bmy.bmy16) THEN LET g_bmb.bmb16 =b_bmy.bmy16 END IF
          IF NOT cl_null(b_bmy.bmy35) THEN LET g_bmb.bmb14 =b_bmy.bmy35 END IF  
          IF NOT cl_null(b_bmy.bmy25) THEN LET g_bmb.bmb25 =b_bmy.bmy25 END IF
          IF NOT cl_null(b_bmy.bmy26) THEN LET g_bmb.bmb26 =b_bmy.bmy26 END IF
          IF NOT cl_null(b_bmy.bmy13) THEN LET g_bmb.bmb13 =b_bmy.bmy13 END IF
          IF NOT cl_null(b_bmy.bmy18) THEN LET g_bmb.bmb18 =b_bmy.bmy18 END IF
          IF NOT cl_null(b_bmy.bmy08) THEN LET g_bmb.bmb08 =b_bmy.bmy08 END IF
          IF NOT cl_null(b_bmy.bmy081) THEN LET g_bmb.bmb081 =b_bmy.bmy081 END IF  #Add No:TQC-AC0300
          IF NOT cl_null(b_bmy.bmy082) THEN LET g_bmb.bmb082 =b_bmy.bmy082 END IF  #Add No:TQC-AC0300
          IF NOT cl_null(b_bmy.bmy11) THEN LET g_bmb.bmb11 =b_bmy.bmy11 END IF
          IF NOT cl_null(b_bmy.bmy20) THEN LET g_bmb.bmb19 =b_bmy.bmy20 END IF
          IF NOT cl_null(b_bmy.bmy10) THEN LET g_bmb.bmb10 =b_bmy.bmy10 END IF
          IF NOT cl_null(b_bmy.bmy10_fac) THEN
             LET g_bmb.bmb10_fac =b_bmy.bmy10_fac
          END IF
          IF NOT cl_null(b_bmy.bmy10_fac2) THEN
             LET g_bmb.bmb10_fac2 =b_bmy.bmy10_fac2
          END IF
          IF NOT cl_null(b_bmy.bmy21) THEN LET g_bmb.bmb15 =b_bmy.bmy21 END IF 
          IF NOT cl_null(b_bmy.bmy23) THEN LET g_bmb.bmb28 =b_bmy.bmy23 END IF
          IF cl_null(g_bmb.bmb28) THEN LET g_bmb.bmb28 =0 END IF
          IF NOT cl_null(b_bmy.bmy34) THEN LET g_bmb.bmb31 =b_bmy.bmy34 END IF 
          #Add No:TQC-AC0300
          IF cl_null(g_bmb.bmb081) THEN
             LET g_bmb.bmb081 = 0
          END IF
          IF cl_null(g_bmb.bmb082) THEN
             LET g_bmb.bmb082 = 1
          END IF
          #End Add No:TQC-AC0300
        
          IF cl_null(g_bmb.bmb34) THEN LET g_bmb.bmb34 = 0  END IF  #TQC-DA0015 add
          CALL s_carry_p_cs()
          CALL s_carry_col('bmb_file') RETURNING l_str1_bmb,l_str2_bmb,l_str3_bmb
          LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmb_file",
                      " VALUES(",l_str2_bmb,")"
          PREPARE i720sub_ins_bmb5 FROM g_sql
          EXECUTE i720sub_ins_bmb5 USING g_bmb.*
          IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
             LET g_showmsg = g_bmb.bmb01,' ins bmb:'
             CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,STATUS,1)
             LET g_success='N'
          END IF                                   
       END IF 
       #No.FUN-A60083--end       
    END IF 	
    #No.FUN-A60008--end  

END FUNCTION

FUNCTION i720sub_up_bmb13()
 DEFINE l_cnt     LIKE type_file.num5   #MOD-G90030 add
 DEFINE l_ima147  LIKE ima_file.ima147  #MOD-G90030 add
 DEFINE l_bmt07   LIKE bmt_file.bmt07   #MOD-G90030 add
 DEFINE l_bmt06   LIKE bmt_file.bmt06,
        s_bmb13   LIKE bmb_file.bmb13,
        l_i       LIKE type_file.num5     
 
    LET s_bmb13=' '
    LET l_i = 0
    LET g_sql = "SELECT bmt06 FROM ",g_dbs_sep CLIPPED,"bmt_file",
                " WHERE bmt01 = '",g_bmb.bmb01,"'",
                "   AND bmt02 = '",g_bmb.bmb02,"'",
                "   AND bmt03 = '",g_bmb.bmb03,"'",
                "   AND bmt04 = '",g_bmb.bmb04,"'",
                "   AND bmt08 = '",g_bmb.bmb29,"'"
    PREPARE up_bmb13_cs_p FROM g_sql
    DECLARE up_bmb13_cs CURSOR FOR up_bmb13_cs_p
    FOREACH up_bmb13_cs INTO l_bmt06
     IF SQLCA.sqlcode THEN
        LET g_showmsg = g_bmb.bmb01,' FOREACH up_bmb13_cs'                  
        CALL s_errmsg('bmb01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
        EXIT FOREACH
     END IF
     IF l_i = 0 THEN
        LET s_bmb13=l_bmt06
     ELSE
        LET s_bmb13= s_bmb13 CLIPPED , ',', l_bmt06
     END IF
     LET l_i = l_i + 1
    END FOREACH
   #MOD-G90030--add---str---
    LET l_ima147 = NULL
    LET g_sql = "SELECT ima147 FROM ",g_dbs_sep CLIPPED,"ima_file",
                " WHERE ima01 = ? "
    PREPARE i720sub_sel_ima147 FROM g_sql
    EXECUTE i720sub_sel_ima147 INTO l_ima147 USING g_bmb.bmb03
    IF l_ima147 = 'Y' THEN
       LET g_sql = "SELECT bmb06 FROM ",g_dbs_sep CLIPPED,"bmb_file",
                   " WHERE bmb01 = ? ",
                   "   AND bmb02 = ? ",
                   "   AND bmb03 = ? ",
                   "   AND bmb04 = ? ",
                   "   AND bmb29 = ? "
       PREPARE i720sub_sel_bmb06_01 FROM g_sql
       EXECUTE i720sub_sel_bmb06_01 INTO l_bmt07 USING g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,g_bmb.bmb29
    ELSE
        #當插件位置檔(bmt_file)有資料時,以SUM(bmt07)的值回寫組成用量
        #當插件位置檔(bmt_file)無資料時,以原bmb06   的值回寫組成用量
        LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmt_file",
                    " WHERE bmt01 = ? ",
                    "   AND bmt02 = ? ",
                    "   AND bmt03 = ? ",
                    "   AND bmt04 = ? ",
                    "   AND bmt08 = ? "
        PREPARE i720sub_sel_bmt_cnt FROM g_sql
        EXECUTE i720sub_sel_bmt_cnt INTO l_cnt USING g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,g_bmb.bmb29
        IF l_cnt >=1 THEN
            LET g_sql = "SELECT SUM(bmt07) FROM ",g_dbs_sep CLIPPED,"bmt_file",
                        " WHERE bmt01 = ? ",
                        "   AND bmt02 = ? ",
                        "   AND bmt03 = ? ",
                        "   AND bmt04 = ? ",
                        "   AND bmt08 = ? "
            PREPARE i720sub_sel_bmt_sum FROM g_sql
            EXECUTE i720sub_sel_bmt_sum INTO l_bmt07 USING g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,g_bmb.bmb29
        ELSE
            LET g_sql = "SELECT bmb06 FROM ",g_dbs_sep CLIPPED,"bmb_file",
                        " WHERE bmb01 = ? ",
                        "   AND bmb02 = ? ",
                        "   AND bmb03 = ? ",
                        "   AND bmb04 = ? ",
                        "   AND bmb29 = ? "
            PREPARE i720sub_sel_bmb06_02 FROM g_sql
            EXECUTE i720sub_sel_bmb06_02 INTO l_bmt07 USING g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,g_bmb.bmb29
        END IF
    END IF 
    IF cl_null(l_bmt07) THEN
        LET l_bmt07 = 1
    END IF
   #MOD-G90030--add---end---
    LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmb_file",
                "   SET bmb13 = '",s_bmb13,"',",
                "       bmb06 =  ",l_bmt07, " ,",  #MOD-G90030 add
                "       bmbmodu = '",g_user,"',",  #MOD-G90030 add
                "       bmbdate = '",g_today,"'",  #FUN-C40007 add
                " WHERE bmb01 = '",g_bmb.bmb01,"'",
                "   AND bmb02 = '",g_bmb.bmb02,"'",
                "   AND bmb03 = '",g_bmb.bmb03,"'",
                "   AND bmb04 = '",g_bmb.bmb04,"'",
                "   AND bmb29 = '",g_bmb.bmb29,"'"
    PREPARE i720sub_upd_p10 FROM g_sql
    EXECUTE i720sub_upd_p10
    IF SQLCA.sqlcode THEN
       LET g_showmsg = g_bmb.bmb01,' update bmb13'                  
       CALL s_errmsg('bmb01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
    END IF
END FUNCTION
#No.B632 end----

FUNCTION i720sub_s4()      
   DEFINE l_bmt		RECORD LIKE bmt_file.*
   DEFINE l_ima151      LIKE ima_file.ima151 
   DEFINE l_bmb06       LIKE bmb_file.bmb06  
   DEFINE l_bmb07       LIKE bmb_file.bmb07  
   DEFINE l_cnt         LIKE type_file.num5  
   DEFINE l_bmc		RECORD LIKE bmc_file.* 
   DEFINE l_str1_bmb    STRING
   DEFINE l_str2_bmb    STRING
   DEFINE l_str3_bmb    STRING
   DEFINE l_str1_bmc    STRING
   DEFINE l_str2_bmc    STRING
   DEFINE l_str3_bmc    STRING
   DEFINE l_str1_bmd    STRING
   DEFINE l_str2_bmd    STRING
   DEFINE l_str3_bmd    STRING
   DEFINE l_str1_bmt    STRING
   DEFINE l_str2_bmt    STRING
   DEFINE l_str3_bmt    STRING
   DEFINE l_bmb09       LIKE bmb_file.bmb09  #CHI-C40010 add

#舊料做失效
   LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmb_file",
               "   SET bmb05 = '",g_bmx.bmx07,"',",
               "       bmb30 = '",b_bmy.bmy30,"',",
               "       bmbmodu = '",g_user,"',",
               "       bmbdate = '",g_today,"'",
              #FUN-AC0060(110705)---mod----str-----
              #" WHERE ROWID = '",g_bmb_rowid,"'"
               " WHERE bmb01 = '",g_bmb.bmb01,"'",
               "   AND bmb02 = '",g_bmb.bmb02,"'",
               "   AND bmb03 = '",g_bmb.bmb03,"'",
               "   AND bmb04 = '",g_bmb.bmb04,"'",
               "   AND bmb29 = '",g_bmb.bmb29,"'" 
              #FUN-AC0060(110705)---mod----end-----
   PREPARE i720sub_upd_p11 FROM g_sql
   EXECUTE i720sub_upd_p11

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_showmsg = g_bmx.bmx01,' update bmb_file:'                  
      CALL s_errmsg('bmb01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
      LET g_success='N'
   END IF

   #MOD-D40044---begin
   IF b_bmy.bmy03 = '4' THEN
      LET l_cnt = 0 
      LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmd_file ",
                  " WHERE bmd08 = '",b_bmy.bmy14,"'",
                  "   AND bmd01 = '",b_bmy.bmy05,"'",
                  "   AND (bmd06 > '",g_bmx.bmx07,"'",
                  "        OR bmd06 IS NULL) "
      PREPARE i720sub_sel_p35 FROM g_sql
      EXECUTE i720sub_sel_p35 INTO l_cnt
    
      IF l_cnt > 0 THEN 
         LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmd_file",
                     "   SET bmd06 = '",g_bmx.bmx07 ,"',",
                     "       bmdmodu = '",g_user    ,"',",
                     "       bmddate = '",g_today   ,"'",
                     " WHERE bmd08 = '",b_bmy.bmy14 ,"'",
                     "   AND bmd01 = '",b_bmy.bmy05 ,"'",
                     "   AND (bmd06 > '",g_bmx.bmx07,"'",
                     "        OR bmd06 IS NULL) "
         PREPARE i720sub_upd_p16 FROM g_sql
         EXECUTE i720sub_upd_p16
         IF SQLCA.sqlcode THEN
            LET g_showmsg = g_bmx.bmx01,' update bmd_file:'                    
            CALL s_errmsg('bmx01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
            LET g_success='N'
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg = g_bmx.bmx01,' update bmd_file:'                    
            CALL s_errmsg('bmx01',g_plant,g_showmsg,'aap-161',1)
            LET g_success='N'
         END IF
        #FUN-F50035 add str---
         IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN #與APS整合
            CALL i720_del_vmo()
         END IF
        #FUN-F50035 add end---
      END IF
   END IF    
   #MOD-D40044---end
  #CHI-C40010 str add-----
   SELECT bmb09 INTO l_bmb09 FROM bmb_file
    WHERE bmb01 = g_bmb.bmb01 AND bmb02=g_bmb.bmb02
        AND bmb03=g_bmb.bmb03 AND bmb04=g_bmb.bmb04
        AND bmb29=g_bmb.bmb29
  #CHI-C40010 end add-----

   LET g_bmy05_t=b_bmy.bmy05

   LET l_bmb06 = 1
   LET l_bmb07 = 1
   LET g_sql = "SELECT bmb06,bmb07 FROM ",g_dbs_sep CLIPPED,"bmb_file",
              #FUN-AC0060(110705)---mod----str-----
              #" WHERE ROWID = '",g_bmb_rowid,"'"
               " WHERE bmb01 = '",g_bmb.bmb01,"'",
               "   AND bmb02 = '",g_bmb.bmb02,"'",
               "   AND bmb03 = '",g_bmb.bmb03,"'",
               "   AND bmb04 = '",g_bmb.bmb04,"'",
               "   AND bmb29 = '",g_bmb.bmb29,"'" 
              #FUN-AC0060(110705)---mod----end-----
   PREPARE i720sub_sel_p23 FROM g_sql
   EXECUTE i720sub_sel_p23 INTO l_bmb06,l_bmb07
   IF cl_null(l_bmb06) THEN LET l_bmb06 = 1 END IF 
   IF cl_null(l_bmb07) THEN LET l_bmb07 = 1 END IF 
   #新增新料,取替代default '1'
   INITIALIZE g_bmb.* TO NULL
   LET g_bmb.bmb01 = b_bmy.bmy14
   LET g_bmb.bmb29 = b_bmy.bmy29  
   LET g_bmb.bmb30 = b_bmy.bmy30  
   LET g_sql = "SELECT MAX(bmb02) FROM ",g_dbs_sep CLIPPED,"bmb_file ",
               " WHERE bmb01 = '",g_bmb.bmb01,"'",
               "   AND bmb29 = '",g_bmb.bmb29,"'"
   PREPARE i720sub_sel_p24 FROM g_sql
   EXECUTE i720sub_sel_p24 INTO g_bmb.bmb02
   IF g_bmb.bmb02 IS NULL THEN LET g_bmb.bmb02 = 0 END IF
   LET g_bmb.bmb02=g_bmb.bmb02+g_sma.sma19
   IF cl_null(g_bmb.bmb02) THEN
      LET g_bmb.bmb02 = g_last_seq
   END IF

   IF b_bmy.bmy03 ='5' THEN
      LET g_bmb.bmb03 =b_bmy.bmy05
   ELSE
      LET g_bmb.bmb03 =b_bmy.bmy27
   END IF
   LET g_bmb.bmb04 =g_bmx.bmx07
   IF b_bmy.bmy03 = '5' THEN
      LET g_bmb.bmb06 =l_bmb06
      LET g_bmb.bmb07 =l_bmb07
   ELSE
      IF NOT cl_null(b_bmy.bmy06) THEN
         LET g_bmb.bmb06 =b_bmy.bmy06 
      ELSE 
         LET g_bmb.bmb06 =l_bmb06
      END IF
      IF NOT cl_null(b_bmy.bmy07) THEN
         LET g_bmb.bmb07 =b_bmy.bmy07 
      ELSE 
         LET g_bmb.bmb07 =l_bmb07
      END IF
   END IF
   LET g_bmb.bmb16 =b_bmy.bmy16
   LET g_bmb.bmb24 =g_bmx.bmx01
   LET g_bmb.bmb25 =b_bmy.bmy25
   LET g_bmb.bmb26 =b_bmy.bmy26
   LET g_bmb.bmb13 =b_bmy.bmy13
   LET g_bmb.bmb18 =b_bmy.bmy18
   LET g_bmb.bmb08 =b_bmy.bmy08
   LET g_bmb.bmb081=b_bmy.bmy081  #Add No:TQC-AC0300
   LET g_bmb.bmb082=b_bmy.bmy082  #Add No:TQC-AC0300
   LET g_bmb.bmb11 =b_bmy.bmy11
   IF NOT cl_null(b_bmy.bmy09) THEN     #CHI-C40010 add
     LET g_bmb.bmb09 =b_bmy.bmy09
   ELSE                                 #CHI-C40010 add
     LET g_bmb.bmb09 =l_bmb09           #CHI-C40010 add
   END IF                               #CHI-C40010 add
   LET g_bmb.bmb10 =b_bmy.bmy10
   LET g_bmb.bmb10_fac =b_bmy.bmy10_fac
   LET g_sql = "SELECT ima105 FROM ",g_dbs_sep CLIPPEd,"ima_file",
               " WHERE ima01 = '",g_bmb.bmb03,"'"
   PREPARE i720sub_sel_p25 FROM g_sql
   EXECUTE i720sub_sel_p25 INTO g_bmb.bmb27

   LET g_bmb.bmb10_fac2=b_bmy.bmy10_fac2
#  LET g_bmb.bmb14 =0             #TQC-C60180 mark
   LET g_bmb.bmb14 = b_bmy.bmy35  #TQC-C60180 add
   LET g_bmb.bmb15 = b_bmy.bmy21        
   LET g_bmb.bmb17 ='N'
   LET g_bmb.bmb19 ='1'
   IF NOT cl_null(b_bmy.bmy20) THEN LET g_bmb.bmb19 =b_bmy.bmy20 END IF  
   LET g_bmb.bmb28 = b_bmy.bmy23        
   IF cl_null(g_bmb.bmb28) THEN
      LET g_bmb.bmb28 =0
   END IF

   IF cl_null(g_bmb.bmb02)  THEN
      LET g_bmb.bmb02=' '
   END IF
   IF cl_null(g_bmb.bmb08) THEN
      LET g_bmb.bmb08 = 0
   END IF
   #Add No:TQC-AC0300
   IF cl_null(g_bmb.bmb081) THEN
      LET g_bmb.bmb081 = 0
   END IF
   IF cl_null(g_bmb.bmb082) THEN
      LET g_bmb.bmb082 = 1
   END IF
   #End Add No:TQC-AC0300
   IF cl_null(g_bmb.bmb15) THEN
      LET g_sql = "SELECT ima70 FROM ",g_dbs_sep CLIPPEd,"ima_file",
                  " WHERE ima01 = '",g_bmb.bmb03,"'"
      PREPARE i720sub_sel_p26 FROM g_sql
      EXECUTE i720sub_sel_p26 INTO g_bmb.bmb15
   END IF
   LET g_bmb.bmb33 = 0              
   LET g_bmb.bmb31 = b_bmy.bmy34   
   LET g_sql = "SELECT ima151 FROM ",g_dbs_sep CLIPPEd,"ima_file,",g_dbs_sep CLIPPED,"bmy_file",
               " WHERE bmy14 = ima01 ",
               "   AND bmy14 = '",b_bmy.bmy14,"'",
               "   AND bmy01 = '",g_bmx.bmx01,"'",
               "   AND bmy02 = '",b_bmy.bmy02,"'"
   PREPARE i720sub_sel_p27 FROM g_sql
   EXECUTE i720sub_sel_p27 INTO l_ima151
   IF l_ima151 = 'Y' THEN
       LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"bmy_file",
                   "   SET bmy33 = '",g_bmb.bmb02,"'",
                   " WHERE bmy01 = '",g_bmx.bmx01,"'",
                   "   AND bmy02 = '",b_bmy.bmy02,"'",
                  #"   AND bmy14 = '",b_bmy.bmy14       #MOD-BC0097 mark
                   "   AND bmy14 = '",b_bmy.bmy14,"'"   #MOD-BC0097
       PREPARE i720sub_upd_p12 FROM g_sql
       EXECUTE i720sub_upd_p12
       IF SQLCA.sqlcode THEN
           LET g_showmsg = g_bmx.bmx01,' update bmy_file:'                    
           CALL s_errmsg('bmy33',g_plant,g_showmsg,SQLCA.SQLCODE,1)
           LET g_success='N'
       END IF
   ELSE
       LET g_bmb.bmb33 = b_bmy.bmy33
   END IF

   IF cl_null(g_bmb.bmb34) THEN LET g_bmb.bmb34 = 0  END IF  #TQC-DA0015 add
   CALL s_carry_p_cs()
   CALL s_carry_col('bmb_file') RETURNING l_str1_bmb,l_str2_bmb,l_str3_bmb
   LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmb_file",
               " VALUES(",l_str2_bmb,")"
   PREPARE i720sub_ins_bmb4 FROM g_sql
   EXECUTE i720sub_ins_bmb4 USING g_bmb.*
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      LET g_showmsg = g_bmb.bmb01,' insert into bmb_file:'                  
      CALL s_errmsg('bmb01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
      LET g_success='N'
   END IF

  #FUN-F50035 add str-----
   IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN #與APS整合
      CALL i720_ins_vmo()
   END IF
  #FUN-F50035 add end-----

   IF g_sma.sma845='Y' THEN  #低階碼可否部份重計
      CALL s_decl_bmb_m(g_dbs_sep)
      CALL s_uima146_m(g_bmb.bmb03,g_dbs_sep)
      CALL cl_msg("")                              
   END IF
 
   LET g_sql = "SELECT * FROM ",g_dbs_sep CLIPPED,"bmw_file",
               " WHERE bmw01 = '",g_bmx.bmx01,"'",
               "   AND bmw02 = '",b_bmy.bmy02,"'"
   PREPARE i720sub_s4_p1 FROM g_sql
   DECLARE i720sub_s4_c2 CURSOR FOR i720sub_s4_p1
   FOREACH i720sub_s4_c2 INTO b_bmw.*
      LET l_bmt.bmt01=g_bmb.bmb01
      LET l_bmt.bmt02=g_bmb.bmb02
      LET l_bmt.bmt03=g_bmb.bmb03
      LET l_bmt.bmt04=g_bmb.bmb04
      LET l_bmt.bmt05=b_bmw.bmw03
      LET l_bmt.bmt06=b_bmw.bmw04
      LET l_bmt.bmt07=b_bmw.bmw05
      LET l_bmt.bmt08=g_bmb.bmb29
      IF cl_null(l_bmt.bmt02) THEN
         LET l_bmt.bmt02=0
      END IF
      CALL s_carry_p_cs()
      CALL s_carry_col('bmt_file') RETURNING l_str1_bmt,l_str2_bmt,l_str3_bmt
      LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmt_file",
                  " VALUES(",l_str2_bmt,")"
      PREPARE i720sub_ins_bmt4 FROM g_sql
      EXECUTE i720sub_ins_bmt4 USING l_bmt.*
      IF STATUS THEN
         LET g_showmsg = l_bmt.bmt01,' s4_ins bmt:'                  
         CALL s_errmsg('bmt01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
         LET g_success='N'
      END IF
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = l_bmt.bmt01,' s4_ins bmt:'                  
         CALL s_errmsg('bmt01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
         LET g_success='N'
      END IF
   END FOREACH

   LET g_cnt=0
   LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmw_file",
               " WHERE bmw01 = '",g_bmx.bmx01,"'",
               "   AND bmw02 = '",b_bmy.bmy02,"'"
   PREPARE i720sub_sel_p28 FROM g_sql
   EXECUTE i720sub_sel_p28 INTO g_cnt
   IF g_cnt=0 THEN
      LET g_sql = "SELECT * FROM ",g_dbs_sep CLIPPED,"bmt_file",
                  " WHERE bmt01 = '",b_bmy.bmy14,"'",
                  "   AND bmt03 = '",b_bmy.bmy05,"'",
                  "   AND bmt04 IN (SELECT MAX(bmt04) FROM ",g_dbs_sep CLIPPED,"bmt_file",
                  "                  WHERE bmt01 = '",b_bmy.bmy14,"'",
                  "                    AND bmt03 = '",b_bmy.bmy05,"')"
     PREPARE i720sub_s4_p2 FROM g_sql
     DECLARE i720sub_s4_c21 CURSOR FOR i720sub_s4_p2
     LET l_cnt=0
     FOREACH i720sub_s4_c21 INTO l_bmt.*
        LET l_cnt=l_cnt+1
       #IF l_cnt=1 THEN                                          #FUN-B80071 mark
        IF l_cnt=1 AND (g_bgjob = 'N' OR cl_null(g_bgjob)) THEN  #FUN-B80071 add
           LET g_sql=cl_getmsg('abm-040',g_lang)
           IF NOT cl_prompt(0,0,g_sql) THEN EXIT FOREACH END IF
        END IF
        DISPLAY g_bmb.bmb02
        DISPLAY l_bmt.bmt02
        LET l_bmt.bmt02=g_bmb.bmb02
        DISPLAY g_bmb.bmb02
        DISPLAY l_bmt.bmt02
        LET l_bmt.bmt03=g_bmb.bmb03
        LET l_bmt.bmt04=g_bmb.bmb04
        CALL s_carry_p_cs()
        CALL s_carry_col('bmt_file') RETURNING l_str1_bmt,l_str2_bmt,l_str3_bmt
        LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmt_file",
                    " VALUES(",l_str2_bmt,")"
        PREPARE i720sub_ins_bmt5 FROM g_sql
        EXECUTE i720sub_ins_bmt5 USING l_bmt.*
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           LET g_showmsg = g_plant,":",l_bmt.bmt01,' s4_c21 ins bmt:'
           CALL s_errmsg('bmt01',l_bmt.bmt01,g_showmsg,SQLCA.SQLCODE,1)
           LET g_success='N'
        END IF
     END FOREACH
   END IF

   #----- 取代�替代產品結構明細資料檔(bmd_file)複製 ------------
   IF NOT cl_null(g_bmy05_t) AND b_bmy.bmy16 <> '0' THEN
      INITIALIZE g_bmd.* TO NULL
      IF b_bmy.bmy03 = '4' THEN   
         LET g_bmd.bmd01=b_bmy.bmy27 
         LET g_bmd.bmd02='1'
         LET g_bmd.bmd07 = 1      
      END IF                      
      IF b_bmy.bmy03 = '5' THEN  
         LET g_bmd.bmd01=b_bmy.bmy05 
         LET g_bmd.bmd02='2'      
         LET g_bmd.bmd07 = b_bmy.bmy06 / b_bmy.bmy07   
      END IF                   
      IF b_bmy.bmy03 = '5' THEN
         LET g_sql = "SELECT max(bmd03)+1 FROM ",g_dbs_sep CLIPPED,"bmd_file",
                     " WHERE bmd01 = '",b_bmy.bmy05,"'",
                     "   AND bmd02 = '2' ",
                     "   AND bmd08 = '",b_bmy.bmy14,"'"
         PREPARE i720sub_sel_p29 FROM g_sql
         EXECUTE i720sub_sel_p29 INTO g_bmd.bmd03
         IF cl_null(g_bmd.bmd03) THEN
            LET g_bmd.bmd03=1
         END IF
      ELSE
        #LET g_bmd.bmd03 = 1 #MOD-H30025 mark
        #MOD-H30025---add----str---
         LET g_sql = "SELECT max(bmd03)+1 FROM ",g_dbs_sep CLIPPED,"bmd_file",
                     " WHERE bmd01 = '",b_bmy.bmy27,"'",
                     "   AND bmd02 = '1' ",  #取代
                     "   AND bmd08 = '",b_bmy.bmy14,"'"
         PREPARE i720sub_sel_p291 FROM g_sql
         EXECUTE i720sub_sel_p291 INTO g_bmd.bmd03
         IF cl_null(g_bmd.bmd03) THEN
            LET g_bmd.bmd03=1
         END IF
        #MOD-H30025---add----end---
      END IF
      IF b_bmy.bmy03 = '4' THEN      
         LET g_bmd.bmd04=g_bmy05_t
      ELSE                           
         LET g_bmd.bmd04=b_bmy.bmy27 
      END IF                         
      LET g_bmd.bmd05=g_bmx.bmx07
      LET g_bmd.bmd08=b_bmy.bmy14
      LET g_bmd.bmduser = g_user
      LET g_bmd.bmdgrup = g_grup
      LET g_bmd.bmddate = g_today
      LET g_bmd.bmdacti = 'Y'
      IF cl_null(g_bmd.bmd11) THEN LET g_bmd.bmd11 = 'N' END IF #TQC-C60194 add
      CALL s_carry_p_cs()
      CALL s_carry_col('bmd_file') RETURNING l_str1_bmd,l_str2_bmd,l_str3_bmd
      LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmd_file",
                  " VALUES(",l_str2_bmd,")"
      PREPARE i720sub_ins_bmd FROM g_sql
      EXECUTE i720sub_ins_bmd USING g_bmd.*
     #IF SQLCA.SQLCODE THEN                                                 #MOD-D90002 mark
      IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN     #MOD-D90002 add
         LET g_showmsg = g_bmd.bmd01,' s4_ins bmd_file:'                  
         CALL s_errmsg('bmd01',g_plant,g_showmsg,SQLCA.SQLCODE,1)
         LET g_success='N'
      END IF
      LET g_bmy05_t=NULL
     #FUN-F50035 add str---
      IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN #與APS整合
         CALL i720_upd_vmq()
      END IF
     #FUN-F50035 add end---
   END IF
   CALL i720sub_up_bmb13() 

   #----- 說明檔(bmc_file)複製 ------------
   LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_sep CLIPPED,"bmf_file",
               " WHERE bmf01 = '",g_bmx.bmx01,"'",
               "   AND bmf02 = '",b_bmy.bmy02,"'"
   PREPARE i720sub_sel_p30 FROM g_sql
   EXECUTE i720sub_sel_p30 INTO g_cnt
   IF g_cnt>0 THEN 	# 有輸入才更新
      LET g_sql = "SELECT * FROM ",g_dbs_sep CLIPPED,"bmf_file",
                  " WHERE bmf01 = '",g_bmx.bmx01,"'",
                  "   AND bmf02 = '",b_bmy.bmy02,"'"
      PREPARE i720sub_s4_p3 FROM g_sql
      DECLARE i720sub_s4_c3 CURSOR FOR i720sub_s4_p3

      CALL s_carry_p_cs()
      CALL s_carry_col('bmc_file') RETURNING l_str1_bmc,l_str2_bmc,l_str3_bmc

      FOREACH i720sub_s4_c3 INTO b_bmf.*
          LET l_bmc.bmc01=g_bmb.bmb01
          LET l_bmc.bmc02=g_bmb.bmb02
          LET l_bmc.bmc021=g_bmb.bmb03
          LET l_bmc.bmc03=g_bmb.bmb04
          LET l_bmc.bmc04=b_bmf.bmf03
          LET l_bmc.bmc05=b_bmf.bmf04
          LET l_bmc.bmc06=g_bmb.bmb29
          LET g_sql = "INSERT INTO ",g_dbs_sep CLIPPED,"bmc_file",
                      " VALUES(",l_str2_bmc,")"
          PREPARE i720sub_ins_bmc3 FROM g_sql
          EXECUTE i720sub_ins_bmc3 USING l_bmc.*
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
             LET g_showmsg = g_plant,":",l_bmt.bmt01,' s4_ins bmc:'
             CALL s_errmsg('bmc01',l_bmc.bmc01,g_showmsg,SQLCA.SQLCODE,1)
             LET g_success='N'
          END IF
      END FOREACH
   END IF

END FUNCTION

FUNCTION i720sub_get_dbs_sep(p_plant)
  DEFINE p_plant               LIKE azq_file.azq01
  DEFINE l_dbs                 LIKE type_file.chr20
  DEFINE l_dbs_sep             LIKE type_file.chr50

  SELECT azp03 INTO l_dbs FROM azp_file
   WHERE azp01 = p_plant
  CALL s_dbstring(l_dbs) RETURNING l_dbs_sep
  RETURN l_dbs_sep        
END FUNCTION

FUNCTION i720sub_refresh(p_bmx01)
  DEFINE p_bmx01 LIKE bmx_file.bmx01
  DEFINE l_bmx RECORD LIKE bmx_file.*

  SELECT * INTO l_bmx.* FROM bmx_file WHERE bmx01=p_bmx01
  RETURN l_bmx.*
END FUNCTION
#FUN-AC0060
#MOD-C20154 str add-----
FUNCTION i720sub_y_chk_bmy2()

  DECLARE i720sub_y_cur CURSOR FOR
    SELECT * FROM bmy_file WHERE bmy01=g_bmx.bmx01

  FOREACH i720sub_y_cur INTO b_bmy.*
    IF (cl_null(b_bmy.bmy08) OR cl_null(b_bmy.bmy10) OR cl_null(b_bmy.bmy10_fac) OR
        cl_null(b_bmy.bmy18) OR cl_null(b_bmy.bmy20) OR cl_null(b_bmy.bmy21) OR
        cl_null(b_bmy.bmy23) OR cl_null(b_bmy.bmy34)) AND b_bmy.bmy03 = '2' THEN

       CALL s_errmsg('bmy05',b_bmy.bmy05,' ','abm-093',1)
       LET g_success='N'
    END IF
  END FOREACH

END FUNCTION
#MOD-C20154 end add-----

#FUN-F50035 add str-----
FUNCTION i720_chk_vlr(p_type,p_bmx01,p_bmy02)
  DEFINE p_type  LIKE type_file.chr1
  DEFINE p_bmx01 LIKE bmx_file.bmx01
  DEFINE p_bmy02 LIKE bmy_file.bmy02
  DEFINE l_cnt   LIKE type_file.num5

    LET l_cnt = 0
    IF p_type = '1' THEN   #check此筆ECN單資料是否有對應的vlr_file存在
       SELECT COUNT(*) INTO l_cnt 
         FROM vlr_file 
        WHERE vlr00 = p_bmx01
          AND vlr19 = p_bmy02
    ELSE                   #check vlr_file是否在bmb_file有相對應資料存在
       SELECT COUNT(*) INTO l_cnt 
         FROM vlr_file 
        WHERE vlr00 = p_bmx01
          AND vlr01 = g_bmb.bmb01
          AND vlr02 = g_bmb.bmb03
          AND vlr03 = g_bmb.bmb02
          AND vlr19 = p_bmy02
    END IF

    RETURN l_cnt
END FUNCTION

FUNCTION i720_chk_vls(p_type,p_bmx01,p_bmy02)
  DEFINE p_type  LIKE type_file.chr1
  DEFINE p_bmx01 LIKE bmx_file.bmx01
  DEFINE p_bmy02 LIKE bmy_file.bmy02
  DEFINE l_cnt   LIKE type_file.num5

    LET l_cnt = 0
    IF p_type = '1' THEN   #check此筆ECN單資料是否有對應的vlr_file存在
       SELECT COUNT(*) INTO l_cnt 
         FROM vls_file 
        WHERE vls00 = p_bmx01
          AND vls12 = p_bmy02
    ELSE                   #check vlr_file是否在bmb_file有相對應資料存在
       SELECT COUNT(*) INTO l_cnt 
         FROM vls_file 
        WHERE vls00 = p_bmx01 
          AND vls01 = g_bmb.bmb01
          AND vls02 = g_bmb.bmb03
          AND vls12 = p_bmy02
    END IF

    RETURN l_cnt
END FUNCTION

FUNCTION i720_get_aps_temp_data(p_type)
  DEFINE p_type  LIKE type_file.chr10

   IF p_type = 'vlr' THEN
      SELECT * INTO b_vlr.*
        FROM vlr_file 
       WHERE vlr00 = g_bmx.bmx01
         AND vlr19 = b_bmy.bmy02
   ELSE
      SELECT * INTO b_vls.*
        FROM vls_file 
       WHERE vls00 = g_bmx.bmx01
         AND vls12 = b_bmy.bmy02
   END IF
END FUNCTION

FUNCTION i720_del_vmo()
  DEFINE l_cnt   LIKE type_file.num5

   LET l_cnt = 0
   CALL i720_chk_vlr('2',g_bmx.bmx01,b_bmy.bmy02) RETURNING l_cnt
   IF l_cnt > 0 THEN
      CALL i720_get_aps_temp_data('vlr')   #取得存在vlr_file的資料至b_vlr.*
      SELECT COUNT(*) INTO l_cnt
        FROM vmo_file
      WHERE vmo01 = b_vlr.vlr01
        AND vmo02 = b_vlr.vlr02
        AND (vmo03 = b_vlr.vlr03 OR b_vlr.vlr03 = 0)

      IF l_cnt > 0 THEN
         IF b_vlr.vlr03 = 0 THEN
            DELETE FROM vmo_file
             WHERE vmo01 = b_vlr.vlr01
               AND vmo02 = b_vlr.vlr02
         ELSE
            DELETE FROM vmo_file
             WHERE vmo01 = b_vlr.vlr01
               AND vmo02 = b_vlr.vlr02
               AND vmo03 = b_vlr.vlr03 
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg = g_bmx.bmx01,'upd bmb:'
            CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,'aap-161',1)
            LET g_success='N'
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION i720_ins_vmo()
  DEFINE l_cnt   LIKE type_file.num5

    CALL i720_get_aps_temp_data('vlr')
    IF cl_null(b_vlr.vlr00) THEN   #若vlr_file沒有資料則不INSERT vmo_file
       RETURN
    END IF
    LET b_vlr.vlr03 = g_bmb.bmb02
    INSERT INTO vmo_file (vmo01,vmo02,vmo03,vmo13,vmo16,vmo17,vmo18)
    VALUES(b_vlr.vlr01,b_vlr.vlr02,b_vlr.vlr03,b_vlr.vlr13,b_vlr.vlr16,b_vlr.vlr17,b_vlr.vlr18)
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       LET g_showmsg = g_bmx.bmx01,'ins vlr:'
       CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,SQLCA.sqlcode,1)
       LET g_success='N'
    END IF
END FUNCTION

FUNCTION i720_upd_vmo()
  DEFINE l_cnt   LIKE type_file.num5

    CALL i720_get_aps_temp_data('vlr')

    UPDATE vmo_file 
       SET vmo13 = b_vlr.vlr13,
           vmo16 = b_vlr.vlr16,
           vmo17 = b_vlr.vlr17,      
           vmo18 = b_vlr.vlr18      
     WHERE vmo01 = b_vlr.vlr01
       AND vmo02 = b_vlr.vlr02
       AND vmo03 = b_vlr.vlr03
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       LET g_showmsg = g_bmx.bmx01,'upd vmo:'
       CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,SQLCA.sqlcode,1)
       LET g_success='N'
    END IF
END FUNCTION

FUNCTION i720_upd_vmq()
  DEFINE l_cnt   LIKE type_file.num5

   #若變異別為'6'，則g_bmb會沒有值，故需另外給值
    IF b_bmy.bmy03 = '6' THEN
       LET g_bmb.bmb01 = b_bmy.bmy14
       LET g_bmb.bmb03 = b_bmy.bmy05
    END IF

    LET l_cnt = 0
    IF b_bmy.bmy03 = '4' THEN
       SELECT COUNT(*) INTO l_cnt
         FROM vls_file
        WHERE vls01 = g_bmb.bmb01
          AND vls02 = g_bmb.bmb03
          AND vls03 = b_bmy.bmy05
          AND vls00 = g_bmx.bmx01
          AND vls12 = b_bmy.bmy02
    ELSE
       SELECT COUNT(*) INTO l_cnt
         FROM vls_file
        WHERE vls01 = g_bmb.bmb01
          AND vls02 = g_bmb.bmb03
          AND vls03 = b_bmy.bmy27
          AND vls00 = g_bmx.bmx01
          AND vls12 = b_bmy.bmy02
    END IF
    IF l_cnt > 0 THEN
       CALL i720_get_aps_temp_data('vls')
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt
         FROM vmq_file
        WHERE vmq01 = b_vls.vls01
          AND vmq02 = b_vls.vls02
          AND vmq03 = b_vls.vls03 
       IF l_cnt > 0 THEN 
          UPDATE vmq_file
             SET vmq11 = b_vls.vls11
          WHERE vmq01 = b_vls.vls01
            AND vmq02 = b_vls.vls02
            AND vmq03 = b_vls.vls03 
          IF SQLCA.SQLERRD[3]=0 THEN
             LET g_showmsg = g_bmx.bmx01,' update vmq_file:'                    
             CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,'aap-161',1)
             LET g_success='N'
          END IF
       ELSE
          INSERT INTO vmq_file(vmq01,vmq02,vmq03,vmq11)
                        VALUES(b_vls.vls01,b_vls.vls02,b_vls.vls03,b_vls.vls11)   
          IF SQLCA.SQLERRD[3]=0 THEN
             LET g_showmsg = g_bmx.bmx01,' insert vmq_file:'                    
             CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,'aap-161',1)
             LET g_success='N'
          END IF
       END IF
    END IF
END FUNCTION
#FUN-F50035 add end-----

#FUN-F80027 add
