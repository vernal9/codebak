# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: sapmt110_sub.4gl
# Descriptions...: 採購檢驗否
# Date & Author..: 08/05/05 By Kevin
# Modify.........: No.FUN-850022 08/05/05 By kevin 新建立
# Modify.........: No.MOD-860092 08/06/10 By Smapmin 料件供應商管制建議依品號設定;程式中原判斷sma63=1者改為判斷ima915=2 OR 3
# Modify.........: No.MOD-860146 08/07/14 By Smapmin pmh_file多加pmh21/pmh22的key值
# Modify.........: No.MOD-910172 09/01/15 By Smpamin 抓取作業編號時,委外還要區分製程與非製程
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-A10130 10/02/20 By jan 拆分出sapmt110.src.4gl的'確認'功能
# Modify.........: No.FUN-A30072 10/04/28 By jan 委外FT時是否依收貨等級重新取價
# Modify.........: No:FUN-A50054 10/06/03 By shiwuying SLK行業別邏輯修改
# Modify.........: No:FUN-A60026 10/06/07 By Lilan EF(EasyFlow)整合--修正[rvamksg:是否簽核]為NULL值,導致進行確認無控卡問題
# Modify.........: No:FUN-A60027 10/06/18 by sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/25 By huangtao GP5.25 製造功能優化-平行製程(批量修改)
# Modify.........: No:TQC-A70105 10/07/22 By sabrina 自動入庫的申請人改抓rva33
# Modify.........: No:FUN-A60035 10/07/27 By chenls 服飾二維功能mark
# Modify.........: No:MOD-A80052 10/08/09 By Dido 若為運輸發票(gec05='T')時,稅額與未稅金額邏輯調整 
# Modify.........: No:CHI-A70021 10/08/16 By Smapmin 整體參數設定收貨單不做批序號管理,入庫單的料卻要做批序號管理,
#                                                    此時只要產生入庫單據即可,不要做入庫確認的動作.
# Modify.........: No:FUN-A80026 10/08/17 By Carrier 产生入库单后,自动产生AP资料
# Modify.........: No:MOD-A80206 10/08/31 By Smapmin 確認時,委外收貨數量與發料數量的檢核有誤
# Modify.........: No:FUN-A90059 10/09/27 By sabrina 自動產生入庫單時，計劃批號也要帶到入庫單
# Modify.........: No:MOD-A90197 10/10/22 By Smapmin 產生入庫單要檢查入庫單號是否重複時,要考慮作廢的入庫單
# Modify.........: No:MOD-A80168 10/11/17 By Smapmin 收貨單確認自動產生入庫並做入庫確認時,因為g_prog程式代號未轉換為入庫單的程式代號,
#                                                    故在做批序號數量與單據數量檢核時會出錯
# Modify.........: No:FUN-AB0066 10/11/18 By lilingyu 增加倉庫權限的控管
# Modify.........: No:TQC-AB0392 10/12/04 By jan 自動確認產生入庫單入庫日期應default收貨日期
# Modify.........: No:MOD-AC0167 10/12/18 By shiwuying 倉庫控管拿掉
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No:MOD-AC0114 10/12/24 By Smapmin 修正MOD-AB0227
# Modify.........: No:TQC-B10220 11/01/21 By lilingyu 調整TQC-AC0355反映的問題
# Modify.........: No:TQC-B10228 11/02/11 By lilingyu 審核時沒有對"採購員"欄位進行控管;
# Modify.........: No:FUN-A60003 11/02/17 By Lilan EF整合不走自動產生AP資料
# Modify.........: No:MOD-B30016 11/03/02 By Smapmin 單別設限倉庫的控管於確認段再做一次
# Modify.........: No:FUN-A60009 10/10/25 By Lilan EF整合-apmt720,相關呼叫到t720的程式也要修改
# Modify.........: No:CHI-B40011 11/04/18 By Smapmin 多角採購入庫段加入考量自動拋轉的功能.
# Modify.........: No:MOD-B50044 11/05/06 By lilingyu 採購單收貨入庫後,採購單無法結案
# Modify.........: No:MOD-B50165 11/05/18 By lilingyu 測試前一個月份開立的MISC收貨單,到次月審核時,生成的入庫單的入庫日期默認收貨日期,導致小於成本關帳日期而報錯 
# Modify.........: No:MOD-B50153 11/05/25 By Summer CALL t110sub_get_min_set()之前,重新抓取l_pmn07
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No:MOD-B60200 11/06/23 By Summer FUNCTION t110sub_insrvu中RETURN未給值 
# Modify.........: No.FUN-B30187 11/06/29 By jason ICD功能修改，增加母批、DATECODE欄位 
# Modify.........: No:MOD-B70150 11/07/19 By JoHung t110sub_insrvu應抓入庫單的單別設定
# Modify.........: No:MOD-B70240 11/07/25 By yinhy 審核時自動產生rvu_file資料時未把rvu111，rvu115等資料INSERT到rvu_file
# Modify.........: No:TQC-B80005 11/08/03 By jason 新增ICD行業別rvbi條件,s_icdpost函數傳入參數
# Modify.........: No:MOD-B80087 11/08/08 By johung 自動入庫的申請部門抓gen03
# Modify.........: No:CHI-B80038 11/09/02 By johung 修正採購收貨免料驗直接入庫時，apmt111確認時只產生入庫單未確認
# Modify.........: No:MOD-B80272 11/09/03 By johung 修改串t720_gen_ap的判斷式
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: NO:FUN-B90012 11/09/23 By fengrui 添加'TAP'的條件判斷
# Modify.........: NO:FUN-B90101 11/11/01 By lixiang SLK行業別下，新增rvv_file的同時也要同步新增到母料件表rvvslk_file中
# Modify.........: No:FUN-BB0084 11/12/05 By lixh1 增加數量欄位小數取位
# Modify.........: No.FUN-BA0051 11/12/09 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BB0001 11/12/12 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: NO:CHI-B60084 11/12/12 By Summer 控卡apm-307時,加串聯產品bmm_file
# Modify.........: NO:MOD-B90100 11/12/12 By Summer 判斷最小發料套數時需排除委外tky非最終站的收貨數量 
# Modify.........: No.FUN-BB0164 11/11/30 By Abby (1)背景執行時，不執行彈窗"apm-002 此工單尚未發料，或已發料未過帳，繼續否(Y/N)?"
#                                                 (2)免驗料自動產生的入庫單一律不走簽核，且不考慮單別的簽核設定
# Modify.........: No.FUN-BC0104 12/01/30 By lixh1 將apmt110的產生入庫/驗退單部份獨立到sub  
# Modify.........: No:FUN-C20006 12/02/03 By lixiang 服飾BUG修改
# Modify.........: No:TQC-C20117 12/02/10 By xjll    增加服飾業g_azw.azw04='2' 判斷
# Modify.........: No:TQC-C20159 12/02/14 By lixh1 修正RETURN返回值問題 
# Modify.........: No:TQC-C20177 12/02/14 By lixh1 修正提示信息
# Modify.........: No:FUN-C20076 12/02/14 By lixh1 新增倉庫庫存明細
# Modify.........: No:TQC-C20184 12/02/16 By lixh1 修正rvv87（計價數量)的問題
# Modify.........: No.MOD-BA0157 12/02/20 By Vampire 自動確認後產生的入庫單,入庫日期應default收貨日期
# Modify.........: No:TQC-C20521 12/02/28 By lixh1 rvumksg為null時給'N' 
# Modify.........: No:TQC-C30048 12/03/02 By lixh1 當為驗退時,不提供新增倉儲批的功能
# Modify.........: No:TQC-C30119 12/03/07 By lxih1 修正計量不計價的數量
# Modify.........: No:TQC-C30193 12/03/12 By jason FOR ICD:TKY流程最終站才計數量
# Modify.........: No:CHI-C30064 12/03/15 By Sakura 程式有用到"aim-011"訊息的地方，改用料倉儲批抓庫存單位(img09)換算
# Modify.........: No:FUN-C40015 12/04/06 By lixh1 程式執行成功后給出相應的提示信息
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改
# Modify.........: No.TQC-C30225 12/04/09 By SunLM 若為運輸發票(gec05='T')時,未稅單價邏輯調整
# Modify.........: No.TQC-C40186 12/04/20 By lixh1 更改信息顯示方式,以免apmt110串接aqcp107時錯誤提示信息顯示不出來
# Modify.........: No.TQC-C50056 12/05/08 By Sarah FOR ICD:比較idd數量與入庫單身數量時,應以良品數(idd13)+不良品數(idd26)來比較才對
# Modify.........: No.TQC-C50060 12/05/09 By lixh1 增加報錯信息
# Modify.........: No.TQC-C50062 12/05/09 By Sarah FOR ICD:只有當CP才做TQC-C50056的計算
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C70086 12/07/16 By suncx 判斷如果樣品(rvv25='Y')將rvv38/rvv38t/rvv39/rvv39t置為0
# Modify.........: No.FUN-C70014 12/07/16 By suncx Run Card發料作業調整
# Modify.........: No.FUN-C70098 12/07/24 By xjll  服飾流通二維，不可審核數量為零的母單身資料
# Modify.........: No.FUN-C70087 12/08/03 By bart 整批寫入img_file
# Modify.........: No:FUN-C70037 12/08/16 By lixh1 CALL s_minp增加傳入日期參數
# Modify.........: No:MOD-C80049 12/09/27 By Vampire 收貨單自動入庫的則不直接CALL t720sub_ecm串報工單，整個Transaction結束之後再串
# Modify.........: No:TQC-C80120 12/09/27 By Vampire 只判斷入庫單是否存在,導致一般採購收貨入庫會去串報工單
# Modify.........: No:TQC-CA0028 12/10/11 By bart 離開程式前要drop temp table
# Modify.........: No:TQC-CA0049 12/11/01 By yuhuabao 如果是分批檢驗的,只能將審核過的批序號資料入庫
# Modify.........: No:CHI-CB0041 12/11/22 By bart 修改TQC-CA0028
# Modify.........: No:FUN-CB0087 12/12/07 By qiull 庫存單據理由碼改善
# Modify.........: No.FUN-CC0013 13/01/11 By Lori aqci106移除性質3.驗退/重工(qcl05=3)選項
# Modify.........: No:FUN-CC0095 13/01/16 By bart 修改整批寫入img_file
# Modify.........: No.FUN-C30075 13/01/29 By Sakura 確認時加判斷，收貨料號為特性主料時，顯示訊息不可確認
# Modify.........: No.FUN-D10128 13/02/26 By SunLM 若為農業發票(gec05='A')時,未稅單價邏輯調整
# Modify.........: No:DEV-D30045 13/04/01 By TSD.JIE 
#                  1.條碼產生時機點相關程式-增加"條碼查詢"
#                  2.條碼產生時機點相關程式-增加"條碼列印"
#                  3.條碼產生時機點相關程式-增加"條碼產生"
#                  4.調整確認自動產生barcode
#                  5.調整取消確認自動作廢barcode
# Modify.........: No.DEV-D30040 13/04/01 By Nina [條碼管理]:批序號相關程式,當料件使用條碼時(ima930 = 'Y'),確認時,
#                                                 若未輸入批序號資料則不需控卡單據數量與批/序號總數量是否相符 
#                                                 ex:單據數量與批/序號總數量不符，請檢查資料！(aim-011)
# Modify.........: No.DEV-D40015 13/04/16 By Nina [條碼管理]:(1)aimi100有勾選使用條碼&條碼產生時機='K'，確認前，
#                                                            (2)將產生條碼段移至確認chk段前，並CALL s_ibb_ins_rvbs寫入rvbs_file
#                                                            (3)若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
# Modify.........: No.DEV-D30043 13/04/17 By TSD.JIE [條碼管理]:調整條碼自動編號(s_gen_barcode2)與條碼手動編號(s_diy_barcode)產生先後順序
# Modify.........: No.DEV-D40019 13/04/23 By Nina [條碼管理]:修正DEV-D40015控卡SQL的錯誤
# Modify.........: No:DEV-D40021 13/04/26 By TSD.sophy [條碼管理]:將sapmt110.4gl的t110_g()、t110_qc_ck()、t110_qc_item()程式段搬移至sapmt110_sub.4gl
# Modify.........: No.DEV-D50004 13/05/02 By Nina [條碼管理]:增加DEV-D30040程式註解
# Modify.........: No.FUN-CC0012 13/05/09 By Lori 料件檢驗先抓"aqci121站別料件檢驗項目"，抓不到就抓"料件檢驗項目",若再抓不到的話就抓"料件類別檢驗項目" 
# Modify.........: No.TQC-D50065 13/05/13 By Lori 還原t110sub_qc_item參數
# Modify.........: No.MOD-D50136 13/05/15 By Summer FUNCTION t110sub_ind_icd_set_rvb87_tky中不須重新取價RETURN的rvb87須為原值 
# Modify.........: No.FUN-D10004 13/05/24 By jt_chen 1.有用到pmh_file的SQL條件需增加判斷廠牌pmh07
#                                                    2.有用到s_defprice_new的需加傳廠牌進去
# Modify.........: No.MOD-D50194 13/05/28 By Vampire 判斷若倉為空，則不新增 img。
# Modify.........: No.TQC-D50082 13/06/04 By lujh 產生apmt720的資料時，由smydmy4判斷是否立即審核
# Modify.........: No.MOD-D60015 13/06/06 By suncx 修改因CHI-B60084改錯造成的單身有代買料無法過賬的問題
# Modify.........: No.MOD-D60095 13/06/13 By Vampire apm-272錯誤訊息smy51=NULL或smy52=NULL也需依參數顯示
# Modify.........: No.DEV-D60003 13/06/14 By Nina [條碼管理]:
#                                                 (1)修正DEV-D40019控卡SQL的錯誤
#                                                 (2)修正t110sub_g程式段
# Modify.........: No.MOD-D70023 13/07/05 By Vampire 判斷若倉為空，則不詢問 mfg1401。
# Modify.........: No:CHI-D60028 13/07/04 By Vampire 調整 QC 料件判定架構。
# Modify.........: No:MOD-D70118 13/07/19 By Vampire 調整 qc_ck() By 單身項次檢查。
# Modify.........: No:MOD-D80123 13/09/22 By SunLM 收货单审核后，自动生成入库单，rvv89赋值为空的问题
# Modify.........: No:MOD-D90171 13/09/30 by Vampire 抓稅別檔gec_file的錯誤訊息原為mfg3192請改為mfg3044。 
# Modify.........: No:MOD-DA0134 13/10/18 by Vampire 若【開窗詢問新增庫存明細檔資料(sma892[3.3])】有勾選,則開窗詢問mfg1401,沒有勾的話則直接新增img_file
# Modify.........: No:FUN-D90015 13/11/14 By zhuhao 製造服飾業確認邏輯控管
# Modify.........: No.MOD-DB0134 13/11/21 By Vampire 將提示訊息改為 cl_err_msg()
# Modify.........: No.CHI-DC0002 13/12/13 By Vampire QC單驗退必須要可以已產生驗退單。
# Modify.........: No.MOD-E20093 14/02/21 By Reanna 樣品單價、金額為零(5.25的MOD-CB0164追單調整)
# Modify.........: No.FUN-E20026 14/03/05 By apo 1.排除sma150=Y時,會重複寫入rbvs_file情形
#                                                2.屬於全收/全退情形才將顏色尺寸數量從apmt110全部帶入
#                                                3.新鞋服寫入rvvc_file應根據apmt720/apmt721寫入不同值
# Modify.........: No.TQC-E30007 14/03/14 By apo 調整新鞋服也寫入rvvi_file
# Modify.........: No.FUN-E30029 14/03/19 By apo 若為多角寫入rvbs00應為apmt740_slk/apmt741_slk
# Modify.........: No:FUN-E30041 14/03/26 By apo apm-187錯誤訊息增加顯示明細總數量
# Modify.........: No:FUN-E30046 14/03/31 By jingll 委外收货bug 修改
# Modify.........: No.CHI-E40020 14/04/18 By Sulamite 由FUN-9B0025 GP5.20開發，GP5.25後未再使用，故將此欄位移除
# Modify.........: No:FUN-E50036 14/06/18 By Rayhu SFT整合委外製程:調整一般無製程工單委外採購時,收貨確認工單狀態不轉F.Q.C
# Modify.........: No.MOD-E70047 14/07/10 By Reanna 確認段再做一次aim-034的檢查
# Modify.........: No.MOD-E70167 14/07/31 By Mandy 走QC料件判定流程,但是QC後結果為驗退,此時產生驗退單異常
# Modify.........: No.CHI-E80020 14/08/14 By Sabrina 寫入rvbs06時需先轉換成庫存單位的數量後再寫入
# Modify.........: No.FUN-E80075 14/09/30 By liliwen 新增、確認時，需檢查廠商是否未確認、留置、停止交易
# Modify.........: No.MOD-EB0112 14/11/24 By dujuan 增加判斷ima906=2,寫入單位一;ima906=2或3,寫入單位二
# Modify.........: No.MOD-EC0005 14/12/01 By liliwen 收貨單確認後自動產生入庫單時,增加判斷樣品不付款時,單價金額預設為0
# Modify.........: No.FUN-EC0083 14/12/26 By Mandy 當從aqci107 QC判定產生入庫單時,若QC也有批/序號資料時,入庫單的rvbs_file資料直接由aqci107資料產生
# Modify.........: No.MOD-F10082 15/01/20 By liliwen 避免進位問題將set_rvv87的公式調整為在同一列計算
# Modify.........: No:FUN-F30020 15/03/23 By Rayhu WIP整合委外製程:收貨轉入庫自動帶入委採WIP單號(pmn101->rvv90)
# Modify.........: No:MOD-F50062 15/05/14 By Summer aim-011的控卡須排除製程委外工單 
# Modify.........: No:MOD-F50079 15/05/18 By Summer 修正MOD-F50062一般收貨sfb93會是null
# Modify.........: No:FUN-E70053 15/05/19 By Alberti 修正 手動產生驗退/入庫單有異常(有使用QC料件判定)
# Modify.........: No:CHI-F50010 15/05/29 By Alberti 修正 無法紀錄驗退單的訊息
# Modify.........: No:FUN-F60033 15/07/10 By jwlin 1、mark掉apmt741相關條件
#                                                  2、多角收貨[產生入庫/驗退]，只能產生入庫單，若有驗退需產生驗退時，提示訊息：多角貿易有驗退情況時，需特採全部入庫後走倉退流程
# Modify.........: No:CHI-F80017 15/08/26 By catmoon 調整增加控卡L/C收貨[rva04]='Y'不能走驗退
# Modify.........: No:MOD-F90077 15/09/15 By fionchen l_rvb90_fac欄位型態定義rvb90改為rvb90_fac 
# Modify.........: No:MOD-FB0174 15/11/30 By fionchen 調整CHI-A70021,若為新鞋服,不勾選收貨單做批/序號控管(sma90),當收貨單確認後產生的入庫單,若該單別為自動確認,可直接確認 
# Modify.........: No:MOD-FC0048 15/12/10 By fionchen 委外收貨作業執行確認時,增加判斷若當工單為事後領料時,不需出現apm-002提示詢問視窗 
# Modify.........: No:MOD-G10124 16/01/21 By fionchen 調整FUN-E50036,判斷委外工單是否要更新FQC相關的方法有誤 
# Modify.........: No:MOD-G30071 16/03/11 By fionchen 當有批序號資料時,沒考慮QC判定為特採的狀態,造成產生的入庫驗退單沒有批序號資料 
# Modify.........: No:MOD-G50065 16/05/13 By fionchen 當有批序號資料時,產生的驗退單批序號資料,rvbs09屬性欄位應設定為-1 
# Modify.........: No:MOD-G40139 16/05/20 By fionchen 調整當有批序號管理時,且QC結果有特採時產生入庫驗退單處理 
# Modify.........: No:MOD-G60123 16/06/27 By fionchen 在t110sub_y_chk段增加判斷收貨日期不可小於採購單日期,避免送簽後造成自動確認失敗 
# Modify.........: No:MOD-G60115 16/06/28 By fionchen 調整批序號管理時,若走簡易QC時,產生入庫驗退單處理 
# Modify.........: No:MOD-G90037 16/09/23 By fionchen 在t110sub_y_chk段增加判斷若為免驗料且直接入庫時需先檢查倉儲批,避免送簽後造成自動確認失敗 
# Modify.........: No:FUN-G90010 17/02/23 By earl
#                  1.單據取消確認成功或單據確認成功，呼叫條碼產生程式(s_barcode)
#                  2.單據取消確認成功或單據確認成功，呼叫條碼扣帳程式(s_barcode_01)
# Modify.........: No.0000664623_06_M006 17/11/22 By TSD.Nic 確認完成後，自動執行[產生QC單]
# Modify.........: 20180403 mark by momo apm-126 整張收貨單皆需檢驗完才可入庫提示不使用
# Modify.........: 20180508 by momo rvv031 帶入 rvb051
# Modify.........: 20181203 By momo 收貨單確認時檢核單身採購單是否為對應的收貨單
# Modify.........: No:2007104880 20200722 By momo 特採入庫時，系統自動產生「限定批號」, 格式TC-廠商-YYMMDD
# Modify.........: No:2012115582 20201215 By momo 廠商國別代碼”非TW”, 卡控 rva21、rva08、rva09 為必填
# Modify.........: No:2207198503 20220728 By momo 增加判斷 交期是否提早30天
# Modify.........: No:22080035   20220816 By momo 特採入庫時，系統自動產生「限定批號」 --> NM營運中心不使用
# Modify.........: No:22080059   20220825 By momo 供應商留置時可收貨、入庫pmc05='2'

DATABASE ds
#FUN-850022
GLOBALS "../../../tiptop/config/top.global"
#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
                     img01 LIKE img_file.img01,
                     img02 LIKE img_file.img02,
                     img03 LIKE img_file.img03,
                     img04 LIKE img_file.img04,
                     img05 LIKE img_file.img05,
                     img06 LIKE img_file.img06,
                     img09 LIKE img_file.img09,
                     img13 LIKE img_file.img13,
                     img14 LIKE img_file.img14,
                     img17 LIKE img_file.img17,
                     img18 LIKE img_file.img18,
                     img19 LIKE img_file.img19,
                     img21 LIKE img_file.img21,
                     img26 LIKE img_file.img26,
                     img27 LIKE img_file.img27,
                     img28 LIKE img_file.img28,
                     img35 LIKE img_file.img35,
                     img36 LIKE img_file.img36,
                     img37 LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
                    imgg00 LIKE imgg_file.imgg00,
                    imgg01 LIKE imgg_file.imgg01,
                    imgg02 LIKE imgg_file.imgg02,
                    imgg03 LIKE imgg_file.imgg03,
                    imgg04 LIKE imgg_file.imgg04,
                    imgg05 LIKE imgg_file.imgg05,
                    imgg06 LIKE imgg_file.imgg06,
                    imgg09 LIKE imgg_file.imgg09,
                    imgg10 LIKE imgg_file.imgg10,
                    imgg20 LIKE imgg_file.imgg20,
                    imgg21 LIKE imgg_file.imgg21,
                    imgg211 LIKE imgg_file.imgg211,
                    imggplant LIKE imgg_file.imggplant,
                    imgglegal LIKE imgg_file.imgglegal
                            END RECORD
END GLOBALS
#FUN-CC0095---end
#FUN-A10130--begin--add------------------
#{                                                                              
#作用:lock cursor                                                               
#回傳值:無                                                                      
#}                                                                              
FUNCTION t110sub_lock_cl()                                                      
   DEFINE l_forupd_sql STRING                                                   
   LET l_forupd_sql = "SELECT * FROM rva_file WHERE rva01 = ? FOR UPDATE"       
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE t110sub_cl CURSOR FROM l_forupd_sql                                  
END FUNCTION
#FUN-A10130--end--add-----------------------
   
FUNCTION t110_get_rvb39(p_rvb03,p_rvb04,p_rvb05,p_rvb19,p_rva05,p_sma886)   #MOD-860146
   DEFINE l_pmh08   LIKE pmh_file.pmh08,    #
          l_pmm22   LIKE pmm_file.pmm22,
          p_rvb03   LIKE rvb_file.rvb03,    #MOD-860146
          p_rvb04   LIKE rvb_file.rvb04,
          p_rvb05   LIKE rvb_file.rvb05,
          p_rvb19   LIKE rvb_file.rvb19,
          l_rvb39   LIKE rvb_file.rvb39,
          p_rva05   LIKE rva_file.rva05,
          p_sma886  LIKE sma_file.sma886
   DEFINE l_ima915  LIKE ima_file.ima915   #MOD-860092
   DEFINE l_pmm02   LIKE pmm_file.pmm02     #MOD-860146
   DEFINE l_type    LIKE type_file.chr1     #MOD-860146
   DEFINE l_pmn41   LIKE pmn_file.pmn41     #MOD-860146
   DEFINE l_pmn43   LIKE pmn_file.pmn43     #MOD-860146
   DEFINE l_ecm04   LIKE ecm_file.ecm04     #MOD-860146
   DEFINE l_pmn18   LIKE pmn_file.pmn18     #MOD-910172
   DEFINE l_pmn012  LIKE pmn_file.pmn012   #FUN-A60076 add by huangtao
   DEFINE l_pmn123  LIKE pmn_file.pmn123    #FUN-D10004 add

   #-----MOD-860092---------  
   #IF g_sma.sma63='1' THEN #料件供應商控制方式,1: 需作料件供應商管制
   #                        #                   2: 不作料件供應商管制
   #料件供應商控制方式: 0.不管制、1.請購單需管制、2.採購單需管制、3.二者皆需管制
   SELECT ima915 INTO l_ima915 FROM ima_file
    WHERE ima01=p_rvb05
  
   IF l_ima915='2' OR l_ima915='3' OR (l_ima915='0' AND g_plant[1,2]='TY') THEN  #20180921 modify TY
   #-----END MOD-860092-----
      #SELECT pmm22 INTO l_pmm22 FROM pmm_file   #MOD-860146
      SELECT pmm02,pmm22 INTO l_pmm02,l_pmm22 FROM pmm_file   #MOD-860146
       WHERE pmm01=p_rvb04
      #-----MOD-910172---------
      ##-----MOD-860146---------
      #IF l_pmm02 = 'SUB' THEN
      #   LET l_type = '2'
      #ELSE
      #   LET l_type = '1'
      #END IF
      #SELECT pmn41,pmn43 INTO l_pmn41,l_pmn43 FROM pmn_file
      #  WHERE pmn01 = p_rvb04
      #    AND pmn02 = p_rvb03
      #IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN
      #   LET l_ecm04 = " "
      #ELSE
      #   SELECT ecm04 INTO l_ecm04 FROM ecm_file
      #    WHERE ecm01 = l_pmn41
      #      AND ecm03 = l_pmn43
      #END IF
      ##-----END MOD-860146-----
     #SELECT pmn41,pmn43,pmn18,pmn012 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn012 FROM pmn_file       #FUN-A60076 add pmn012,l_pmn012   #FUN-D10004 mark
      SELECT pmn41,pmn43,pmn18,pmn012,pmn123 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn012,l_pmn123 FROM pmn_file                         #FUN-D10004 add
       WHERE pmn01 = p_rvb04 AND pmn02 = p_rvb03          
      IF l_pmm02='SUB' THEN
         LET l_type='2'
         IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
            LET l_ecm04=' '
         ELSE
            IF NOT cl_null(l_pmn18) THEN
               SELECT sgm04 INTO l_ecm04 FROM sgm_file
                WHERE sgm01=l_pmn18
                  AND sgm02=l_pmn41
                  AND sgm03=l_pmn43
                  AND sgm012 = l_pmn012                       #FUN-A60076 add by vealxu 
            ELSE
               SELECT ecm04 INTO l_ecm04 FROM ecm_file 
                WHERE ecm01=l_pmn41
                  AND ecm03=l_pmn43
                  AND ecm012=l_pmn012                          #FUN-A60076 add by huangtao
            END IF
         END IF   
      ELSE
         LET l_type='1'
         LET l_ecm04=' '
      END IF
      #-----END MOD-910172-----
      IF cl_null(l_pmn123) THEN LET l_pmn123 = ' ' END IF      #FUN-D10004 add
      SELECT pmh08 INTO l_pmh08 FROM pmh_file
       WHERE pmh01=p_rvb05
         AND pmh02=p_rva05
         AND pmh07=l_pmn123                                    #FUN-D10004 add
         AND pmh13=l_pmm22
         AND pmh21= l_ecm04   #MOD-860146
         AND pmh22= l_type    #MOD-860146
         AND pmhacti = 'Y'                                           #CHI-910021
      IF cl_null(l_pmh08) THEN
         SELECT ima24 INTO l_pmh08 FROM ima_file  #20180921
          WHERE ima01=p_rvb05
         IF cl_null(l_pmh08) THEN
            LET l_pmh08 = 'N'
         END IF
      END IF

      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   ELSE
      SELECT ima24 INTO l_pmh08 FROM ima_file
       WHERE ima01=p_rvb05

      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF

      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   END IF

   IF l_pmh08='N' OR     #免驗料
      (p_sma886[6,6]='N' AND p_sma886[8,8]='N') OR #視同免驗
      p_rvb19='2' THEN #委外代買料
      LET l_rvb39 = 'N'
   ELSE
      LET l_rvb39 = 'Y'
   END IF

   RETURN l_rvb39

END FUNCTION

#TQC-B10228 --begin--
FUNCTION t200_rva33_check(p_cmd)
 DEFINE   p_cmd      LIKE rva_file.rva33
 DEFINE   l_genacti  LIKE gen_file.genacti

  LET g_errno = ' '
  SELECT genacti INTO l_genacti FROM gen_file
   WHERE gen01 = p_cmd
   
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno ='mfg1312'
                                 LET l_genacti = NULL
        WHEN l_genacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

END FUNCTION    
#TQC-B10228 --end--

#CHI-C30118---add---START
#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#p_ask_post : IF p_ask_post=TRUE 會詢問"是否執行過帳"
#p_argv5 : IF p_argv5='1' 執行自動確認
#p_argv2 : 采購類別
#p_rvu03_flag : IF p_rvu03_flag = '1'則為自動確認後產生的入庫單
#CHI-C30118---add---END

#FUN-A10130--begin--add--------------------
FUNCTION t110sub_y_chk(p_rva01,p_inTransaction,p_ask_post,p_argv5,p_argv2,p_rvu03_flag,p_argv6) #資料檢查 #CHI-C30118 add
DEFINE l_code     LIKE type_file.num5,
       l_msg      LIKE type_file.chr50
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_rvb22    LIKE rvb_file.rvb22
DEFINE l_als05    LIKE als_file.als05
DEFINE l_als21    LIKE als_file.als21
DEFINE l_rvb03    LIKE rvb_file.rvb03
DEFINE l_rvb04    LIKE rvb_file.rvb04
DEFINE l_rvb07    LIKE rvb_file.rvb07
DEFINE l_pmn16    LIKE pmn_file.pmn16
DEFINE l_status   LIKE type_file.chr1
DEFINE p_rva01    LIKE rva_file.rva01
DEFINE p_argv5    LIKE type_file.chr1
DEFINE p_argv2    LIKE rva_file.rva10
DEFINE l_rva      RECORD LIKE rva_file.*
DEFINE l_t1       LIKE oay_file.oayslip
DEFINE p_argv6    LIKE rva_file.rva00
DEFINE l_rvb36    LIKE rvb_file.rvb36        #FUN-AB0066
DEFINE l_rvb05    LIKE rvb_file.rvb05,       #MOD-B30016
       l_rvb37    LIKE rvb_file.rvb37,       #MOD-B30016
       l_rvb02    LIKE rvb_file.rvb02,       #MOD-B30016
       l_rvb34    LIKE rvb_file.rvb34,       #MOD-B30016
       l_rvb38    LIKE rvb_file.rvb38,       #MOD-E70047
       l_ec_sw    LIKE type_file.chr1,       #MOD-B30016
       x_sfb24    LIKE sfb_file.sfb24        #MOD-B30016
DEFINE p_inTransaction LIKE type_file.num5   #CHI-C30118 add
DEFINE p_ask_post LIKE type_file.chr1        #CHI-C30118 add
DEFINE p_rvu03_flag    LIKE type_file.chr1   #CHI-C30118 add
DEFINE l_rvbslk02 LIKE rvbslk_file.rvbslk02  #FUN-C70098 add
DEFINE l_rvbslk05 LIKE rvbslk_file.rvbslk05  #FUN-C70098 add
DEFINE l_rvbslk07 LIKE rvbslk_file.rvbslk07  #FUN-C70098 add
DEFINE l_ima928   LIKE ima_file.ima928       #FUN-C30075 add
DEFINE l_sum      LIKE type_file.num15_3     #FUN-D90015 add
DEFINE l_ima943   LIKE ima_file.ima943       #FUN-D90015 add
DEFINE l_rvb      RECORD LIKE rvb_file.*     #FUN-D90015 add
DEFINE l_msg2     STRING                     #FUN-E30041 add
DEFINE l_ima159   LIKE ima_file.ima159       #MOD-E70047
DEFINE l_pmm04    LIKE pmm_file.pmm04        #MOD-G60123 add
#MOD-G90037 add start -----------
DEFINE l_ins_rvu  LIKE type_file.chr1        #有免驗料,可直接入庫的資料設'Y'
DEFINE l_rvb19    LIKE rvb_file.rvb19       
DEFINE l_rvb39    LIKE rvb_file.rvb39
DEFINE l_sfb24    LIKE sfb_file.sfb24
DEFINE l_rvbi     RECORD LIKE rvbi_file.* 
#MOD-G90037 add end   -----------
DEFINE l_pmc07    LIKE pmc_file.pmc07        #20201215 判斷國別
DEFINE l_pmn33    LIKE pmn_file.pmn33        #交貨日 20220728

   WHENEVER ERROR CONTINUE
   LET g_success = 'Y'

   IF cl_null(p_rva01) THEN LET g_success = 'N' RETURN END IF

   SELECT * INTO l_rva.* FROM rva_file WHERE rva01=p_rva01
   IF l_rva.rvaconf = 'Y' THEN     #當確認碼為 'Y' 時, RETURN
      CALL cl_err('',9023,0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_rva.rvaconf = 'X' THEN     #當確認碼為 'X' 作廢時, RETURN
      CALL cl_err('',9024,0)
      LET g_success = 'N'
      RETURN 
   END IF
   IF l_rva.rvaacti='N' THEN       #當資料有效碼為 'N' 時, RETURN
      CALL cl_err('','mfg0301',1)
      LET g_success = 'N'
      RETURN
   END IF

   ##---- 20181203 add by momo (S) 收貨單與採購單勾稽
   #IF g_plant = 'TY_TEST' THEN
   LET l_t1 = s_get_doc_no(l_rva.rva01)
   SELECT COUNT(*) INTO l_cnt FROM rvb_file,smy_file
    WHERE smyslip = l_t1 
      AND rvb01= p_rva01
      AND SUBSTR(rvb04,1,5) != smyud03
      AND smyud03 IS NOT NULL
   IF l_cnt > 0 THEN
      CALL cl_err('','cpm-009',1)
      LET g_success = 'N'
      RETURN
   END IF
   #END IF
   ##---- 20181203 add by momo (E)

   ##---- 20201215 add by momo (S) 外購進口報單資訊卡控
   #台灣使用
   IF g_aza.aza17='TWD' THEN
      SELECT pmc07 INTO l_pmc07 FROM pmc_file WHERE pmc01=l_rva.rva05
      IF l_pmc07 <> 'TW' THEN
         IF cl_null(l_rva.rva21) OR cl_null(l_rva.rva08) OR cl_null(l_rva.rva09) THEN
            CALL cl_err('','cpm-019',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
   ##---- 20201215 add by momo (E)

#FUN-D90015 -------------- add ---------------- begin --------------------
   IF s_industry('slk') AND g_sma.sma150 ='Y' THEN
      LET l_msg = ''
      LET l_msg2= ''   #FUN-E30041
      CALL s_showmsg_init()
      DECLARE t110sub_rvb01 CURSOR FOR SELECT * FROM rvb_file WHERE rvb01 = p_rva01
      FOREACH t110sub_rvb01 INTO l_rvb.*
         LET l_sum = 0
         SELECT SUM(rvbc06) INTO l_sum FROM rvbc_file
          WHERE rvbc01=l_rvb.rvb01 AND rvbc02=l_rvb.rvb02
         SELECT ima943 INTO l_ima943 FROM ima_file WHERE ima01 = l_rvb.rvb05
         IF cl_null(l_ima943) THEN LET l_ima943 = '4' END IF
         IF NOT cl_null(l_rvb.rvb07) AND l_ima943<>'4' THEN
            IF cl_null(l_sum) OR (l_sum<>l_rvb.rvb07) THEN
               LET l_msg = l_rvb.rvb01,"/",l_rvb.rvb02
               LET l_msg2= l_sum,"/"                                   #FUN-E30041
              #CALL s_errmsg('rvb01/rvb02',l_msg,'','apm-187',1)       #FUN-E30041 mark
               CALL s_errmsg('rvb01/rvb02',l_msg,l_msg2,'apm-187',1)   #FUN-E30041
            END IF
         END IF
      END FOREACH
      CALL s_showmsg()
      IF NOT cl_null(l_msg) THEN
         LET g_success = 'N'
         RETURN
      END IF
   END IF
#FUN-D90015 -------------- add ---------------- end ----------------------

##---- 20220728 add by momo (S)交貨日判斷是否早於30日
   LET l_msg = ''
   LET l_msg2= ''
   CALL s_showmsg_init()
   DECLARE t110sub_pmn33 CURSOR FOR SELECT rvb02,rvb04,rvb03,pmn33 
                                      FROM rvb_file,pmn_file
                                     WHERE rvb01 = p_rva01
                                       AND rvb04 = pmn01 AND rvb03 = pmn02
                                       AND pmn33 - sysdate >= 31
   FOREACH t110sub_pmn33 INTO l_rvb.rvb02,l_rvb.rvb04,l_rvb.rvb03,l_pmn33
      LET l_msg = l_rvb.rvb02,"/",l_rvb.rvb04,"/",l_rvb.rvb03
      LET l_msg2 = l_pmn33,"/"
      CALL s_errmsg('rvb01/rvb02',l_msg,l_msg2,'cpm-024',1)
   END FOREACH
   CALL s_showmsg()
##---- 20220728 add by momo (E)

   #CHI-C30118---add---START
   IF g_action_choice CLIPPED = "confirm" OR      #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"  THEN
      IF l_rva.rvamksg='Y' THEN                    #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
         IF l_rva.rva32 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF

     #DEV-D40015 add str--------
     #此段控卡收貨是否需要掃描，若條碼產生時機點不等於E(採購入庫)、K(採購收貨)則皆需掃描才可確認 
     #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
      IF g_aza.aza131 = 'Y' AND (g_prog = 'apmt110' OR g_prog = 'apmt200') THEN 
         #確認是否有符合條件的料件
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
           FROM ima_file
          WHERE ima01 IN (SELECT rvb05 FROM rvb_file WHERE rvb01 = l_rva.rva01) #料件
            AND ima930 = 'Y'                   #條碼使用否
            AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
           #AND (iam932 <> 'K')                #條碼產生時機點不等於K(採購收貨)  #DEV-D40019 mark
           #AND (ima932 <> 'K')                #條碼產生時機點不等於K(採購收貨)  #DEV-D40019 add   #DEV-D60003 mark
            AND ima932 NOT IN ('E','K')        #條碼產生時機點不等於E(採購入庫)、K(採購收貨)       #DEV-D60003 add
         #確認是否已有掃描紀錄
         IF l_cnt > 0 THEN
            IF NOT s_chk_barcode_confirm('confirm','ibj',l_rva.rva01,'','') THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      END IF
     #DEV-D40015 add end--------

      IF p_ask_post='Y' THEN  # 外部呼叫的程式不可出現詢問視窗
         IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF #詢問是否執行確認功能
      END IF
   END IF
   #CHI-C30118---add---END
#CHI-C30107 --------------- add ----------------- begin
   SELECT * INTO l_rva.* FROM rva_file WHERE rva01=p_rva01
   IF l_rva.rvaconf = 'Y' THEN     #當確認碼為 'Y' 時, RETURN
      CALL cl_err('',9023,0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_rva.rvaconf = 'X' THEN     #當確認碼為 'X' 作廢時, RETURN
      CALL cl_err('',9024,0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_rva.rvaacti='N' THEN       #當資料有效碼為 'N' 時, RETURN
      CALL cl_err('','mfg0301',1)
      LET g_success = 'N'
      RETURN
   END IF
#CHI-C30107 --------------- add -------------- end

#TQC-B10228 --begin--
   CALL t200_rva33_check(l_rva.rva33)
   IF NOT cl_null(g_errno) THEN
      CALL cl_err(l_rva.rva33,g_errno,0)
      LET g_success = 'N'
      RETURN 
   END IF  
#TQC-B10228 --end--

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rvb_file WHERE rvb01=l_rva.rva01
   IF l_cnt > g_sma.sma110 THEN
      CALL cl_err('','axm-156',0)
      LET g_success = 'N'
      RETURN
   END IF

  #FUN-E80075 add str
   CALL s_chk_pmc05(l_rva.rva05)
   IF NOT cl_null(g_errno) THEN
      ##---- 20220825 modify by momo 留置時可收貨(S)
      SELECT COUNT(*) INTO l_cnt FROM pmc_file
       WHERE pmc01 = l_rva.rva05
         AND pmc05 = '2'
      IF l_cnt = 1 THEN
         CALL cl_err('','cpm-025',0)
         LET g_errno = ''
      ELSE
         CALL cl_err('',g_errno,0)
         LET g_success = 'N'
         RETURN
      END IF
      ##---- 20220825 modify by momo 留置時可收貨(E)
   END IF
  #FUN-E80075 add end

#FUN-AB0066 --begin--
   #TQC-B80005 --START--
   IF s_industry('icd') THEN
     #LET l_sql = "SELECT rvb36,rvb05,rvb37,rvb02,rvb34 FROM rvb_file,rvbi_file", #MOD-E70047 mark
      LET l_sql = "SELECT rvb36,rvb05,rvb37,rvb02,rvb34", #MOD-E70047
                  "      ,rvb38",                         #MOD-E70047
                  "  FROM rvb_file,rvbi_file",            #MOD-E70047
                  " WHERE rvb01 = '", l_rva.rva01,"' ",
                  "   AND rvb01 = rvbi01 AND rvb02 = rvbi02 ",
                  "   AND (rvbiicd13 = ' ' OR rvbiicd13 = 'N')"
   ELSE
     #LET l_sql = "SELECT rvb36,rvb05,rvb37,rvb02,rvb34 FROM rvb_file", #MOD-E70047 mark
      LET l_sql = "SELECT rvb36,rvb05,rvb37,rvb02,rvb34", #MOD-E70047
                  "      ,rvb38",                         #MOD-E70047
                  "  FROM rvb_file",                      #MOD-E70047
                  " WHERE rvb01 = '", l_rva.rva01,"' "
   END IF
   DECLARE t110_sub_rvb36 CURSOR FROM l_sql
   #TQC-B80005 --END--

   #TQC-B80005 mark 
   #DECLARE t110_sub_rvb36 CURSOR FOR   
   # SELECT rvb36,rvb05,rvb37,rvb02,rvb34 FROM rvb_file   #MOD-B30016 add rvb05,rvb37,rvb02,rvb34 
   #  WHERE rvb01 = l_rva.rva01

   FOREACH t110_sub_rvb36 INTO l_rvb36,l_rvb05,l_rvb37,l_rvb02,l_rvb34   #MOD-B30016 add rvb05,rvb37,rvb02,rvb34
                              ,l_rvb38   #MOD-E70047
      IF NOT s_chk_ware(l_rvb36) THEN 
         LET g_success = 'N'
         RETURN 
      END IF 
      #-----MOD-B30016---------
      IF l_rvb37 = '　' THEN
         LET l_rvb37 = ' '
      END IF
      IF l_rvb37 IS NULL THEN
         LET l_rvb37=' '
      END IF
      LET l_ec_sw = 'N'
      IF p_argv2 ='SUB' THEN
         LET x_sfb24=''
         SELECT sfb24 INTO x_sfb24
           FROM sfb_file
          WHERE sfb01 = l_rvb34
         IF x_sfb24 IS NOT NULL AND x_sfb24='Y' THEN
            LET l_ec_sw='Y'
         END IF
      END IF
      IF NOT cl_null(l_rvb36) AND l_ec_sw='N' THEN  
         #檢查料號預設倉儲及單別預設倉儲
         IF NOT s_chksmz(l_rvb05, l_rva.rva01,
                         l_rvb36, l_rvb37) THEN
            LET g_success='N'
            RETURN
         END IF
      END IF
      #-----END MOD-B30016-----
    
      #MOD-E70047 add-----------------------------------------------------------
      IF NOT cl_null(l_rvb05) THEN
         LET l_ima159 = ''
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = l_rvb05
         CALL t110sub_ec_sw(l_rvb34,p_argv2) RETURNING l_ec_sw
         IF NOT (p_argv2 = 'SUB' AND l_ec_sw = 'Y') THEN
            IF l_ima159 = '1' AND cl_null(l_rvb38)
               AND l_rvb05[1,4]<>'MISC' AND l_ec_sw='N' THEN
               CALL cl_err('','aim-034',0)
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      END IF
      #MOD-E70047 add end-------------------------------------------------------
  END FOREACH   
#FUN-AB0066 --end--

#FUN-C30075---add---START 
   LET l_rvb05 = ''
   DECLARE t110_ima928 CURSOR FOR 
    SELECT rvb05,ima928 FROM rvb_file,ima_file WHERE rvb05 = ima01 AND rvb01 = l_rva.rva01 
   FOREACH t110_ima928 INTO l_rvb05,l_ima928 
     IF STATUS THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,0)
        LET g_success = 'N'
        RETURN
     END IF
     IF l_ima928 = 'Y' THEN
        CALL cl_err(l_rvb05,'apm1093',1)
        LET g_success = 'N'
        RETURN        
     END IF 
   END FOREACH
#FUN-C30075---add-----END

   IF p_argv6 ='1' THEN
      LET l_ins_rvu='N'              #MOD-G90037 add   #default可直接入庫碼設為'Y'
      DECLARE t110_rvb04 CURSOR FOR
      #SELECT rvb03,rvb04,rvb07 FROM rvb_file WHERE rvb01 = l_rva.rva01               #MOD-G90037 mark 
       SELECT rvb03,rvb04,rvb07,rvb05,rvb19 FROM rvb_file WHERE rvb01 = l_rva.rva01   #MOD-G90037 add
      
     #FOREACH t110_rvb04 INTO l_rvb03,l_rvb04,l_rvb07                                 #MOD-G90037 mark
      FOREACH t110_rvb04 INTO l_rvb03,l_rvb04,l_rvb07,l_rvb05,l_rvb19                 #MOD-G90037 add     
         IF STATUS THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,0)
            LET g_success = 'N'
            RETURN
         END IF
      
         SELECT pmn16 INTO l_pmn16 FROM pmn_file 
          WHERE pmn01 = l_rvb04
            AND pmn02 = l_rvb03
         IF l_pmn16 != '2' THEN
            CALL cl_err('','mfg3166',1)
            LET g_success = 'N'
            RETURN
         END IF
      
         IF l_rvb07 <= 0 THEN
            CALL cl_err('','mfg3348',0) 
            LET g_success = 'N'  
            RETURN
         END IF
         #MOD-G60123 add start -------------------------
         LET l_pmm04 =''
         IF NOT cl_null(l_rvb04) THEN
            SELECT pmm04 INTO l_pmm04 FROM pmm_file   #採購單據日期
             WHERE pmm01 = l_rvb04
            IF STATUS OR l_pmm04 > l_rva.rva06 THEN
               #收貨日期不可小於採購單據日期
               CALL cl_err(l_rvb04,'apm-413',1) 
               LET g_success = 'N'  
               RETURN
            END IF
         END IF
         #MOD-G60123 add end   -------------------------
         #MOD-G90037 add start -------------------------
         CALL t110_get_rvb39(l_rvb03,l_rvb04,l_rvb05,l_rvb19,l_rva.rva05,g_sma.sma886) RETURNING l_rvb39
         IF l_rvb39 = 'N' THEN
            LET l_ins_rvu = 'Y'
         END IF 
         #MOD-G90037 add end   -------------------------
      END FOREACH

      #MOD-G90037 add start -------------------------
      #-->不為 'MISC' 且 為免檢者須check img_file(因免檢可直接入庫)
      IF l_ins_rvu='Y' THEN
         DECLARE t110_y_n1 CURSOR FOR  
          SELECT * FROM rvb_file
           WHERE rvb01=l_rva.rva01
             AND rvb39='N' #檢驗否='N'

         FOREACH t110_y_n1 INTO l_rvb.*
            IF s_industry('icd') THEN
               SELECT * INTO l_rvbi.* FROM rvbi_file
                WHERE rvbi01 = l_rvb.rvb01 AND rvbi02 = l_rvb.rvb02
            END IF
            IF l_rvbi.rvbiicd13 = 'Y' THEN
               CONTINUE FOREACH
            END IF
            IF g_sma.sma886[7,7] = 'Y'  THEN   
               IF l_rvb.rvb05[1,4] <>'MISC' THEN
                  IF l_rva.rva10 = 'SUB' THEN
                     SELECT sfb24 INTO l_sfb24 FROM sfb_file      
                      WHERE sfb01 = l_rvb.rvb34
                  END IF
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt
                    FROM img_file
                   WHERE img01 = l_rvb.rvb05
                     AND img02 = l_rvb.rvb36
                     AND img03 = l_rvb.rvb37
                     AND img04 = l_rvb.rvb38
                  IF l_cnt=0 AND ((l_rva.rva10<>'SUB') OR (l_rva.rva10='SUB' AND l_sfb24='N')) THEN
                     #CALL cl_err(l_rvb05,'apm-259',1)                          #211118 mark by ruby
                     CALL cl_err(l_rvb.rvb05,'apm-259',1)                       #211118 add by ruby
                     LET g_success='N'
                     RETURN 
                  END IF
               END IF
            END IF
         END FOREACH
      END IF 
      #MOD-G90037 add end   -------------------------
   END IF   

   #無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rvb_file
    WHERE rvb01=l_rva.rva01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      LET g_success = 'N'
      RETURN
   END IF

   #FUN-C70098----add----begin--------------
   IF s_industry("slk") AND g_azw.azw04 = '2' THEN
       DECLARE rvbslk05_curs CURSOR FOR
          SELECT rvbslk02,rvbslk05,rvbslk07 FROM rvbslk_file WHERE rvbslk01 = l_rva.rva01 
       CALL s_showmsg_init()
       FOREACH rvbslk05_curs INTO l_rvbslk02,l_rvbslk05,l_rvbslk07 
           IF cl_null(l_rvbslk07) OR l_rvbslk07 = 0 THEN
              CALL s_errmsg('', l_rva.rva01 ,l_rvbslk05 ,'mfg1213',1)
              LET g_success = 'N'
           END IF
       END FOREACH
       CALL s_showmsg()
       IF g_success = 'N' THEN
          RETURN
       END IF
   END IF
   #FUN-C70098----add----end----------------

   IF p_argv5<>'1' THEN 
      IF g_sma.sma41 = 'Y' AND l_rva.rva04='Y' THEN
         LET l_sql = "SELECT rvb22 FROM rvb_file",
                     " WHERE rvb01 = '",l_rva.rva01,"'"
         PREPARE t110_rvb_pre FROM l_sql
         DECLARE t110_rvb_cs CURSOR FOR t110_rvb_pre
         FOREACH t110_rvb_cs INTO l_rvb22
            SELECT als05,als21 INTO l_als05,l_als21 FROM als_file
             WHERE als01=l_rvb22
            IF SQLCA.sqlcode=100 THEN
               CALL cl_err3("sel","als_file",l_rvb22,"","aap-762","","",1)
               LET g_success = 'N'
               RETURN
            END IF
            IF l_als05 <> l_rva.rva05 THEN
               CALL cl_err('','apm-303',0)
               LET g_success = 'N'
               RETURN
            END IF
         END FOREACH
      END IF
    
   END IF
   
  #MOD-AC0167 Begin---
  #IF g_azw.azw04='2' THEN
  #   LET l_cnt = 0
  #   SELECT COUNT(*) INTO l_cnt 
  #     FROM rvb_file 
  #    WHERE rvb01 = l_rva.rva01 
  #      AND (rvb36 IS NULL OR rvb36 = ' ')
  #   IF l_cnt IS NULL THEN 
  #      LET l_cnt = 0          
  #   END IF
  #   IF l_cnt != 0 THEN
  #      LET g_success = 'N'          
  #      CALL cl_err('','apm-067',0) 
  #      RETURN 
  #   END IF
  #END IF
  #MOD-AC0167 End-----
   LET g_totsuccess = 'Y'    
   
  #判斷是否有勾選〝與GPM整合〞，有則做GPM控管
   IF g_aza.aza71 MATCHES '[Yy]' THEN   
      LET l_t1 = s_get_doc_no(l_rva.rva01) 
      
      SELECT * INTO g_smy.* FROM smy_file
       WHERE smyslip=l_t1
      IF NOT cl_null(g_smy.smy64) THEN                                                                                   
         IF g_smy.smy64 != '0' THEN    #要控管GPM
            CALL s_showmsg_init()
               
            CALL aws_gpmcli_part(l_rva.rva01,l_rva.rva05,'','7')
                 RETURNING l_status
            IF l_status = '1' THEN   #回傳結果為失敗
              IF g_smy.smy64 = '1' THEN
                 CALL s_showmsg()
              END IF
              IF g_smy.smy64 = '2' THEN   
                 CALL s_showmsg()
                 LET g_success = 'N'
                 RETURN
              END IF
            END IF
         END IF
      END IF
   END IF                   

   #-->確認時 check 超短交 & 可否提前交貨
   CALL s_showmsg_init()
   IF p_argv6 ='1' THEN     
      CALL t110sub_chk_over(l_rva.*,p_argv2)
   END IF
   CALL s_showmsg()
   
   IF g_totsuccess = 'N' THEN 
      CALL cl_rbmsg(4) 
      LET g_success = 'N'
      RETURN 
   END IF
   IF s_industry('icd') 
      AND (l_rva.rva10 = 'SUB' OR l_rva.rva10 = 'TAP' OR l_rva.rva10[1,2] = 'WB')    #TQC-B10220 add  #FUN-B90012--add 'TAP'--
   THEN
      #-->確認時 check  若該工單是作業群組(ecdicd01) = '6.TKY',
      #委外TKY收貨作業站別與委外工單作業製程站別不符,
      #則出現錯誤訊息, 不允許確認
      CALL t110sub_ind_icd_chk_tky(p_argv2,l_rva.rva01)
      IF g_success = 'N' THEN 
         CALL cl_rbmsg(4) 
         RETURN 
      END IF
   END IF
   
END FUNCTION
#FUN-9C0076 add end ---

FUNCTION t110sub_chk_over(l_rva,p_argv2)
   DEFINE  l_pmn34    LIKE pmn_file.pmn34,
           l_pmn37    LIKE pmn_file.pmn37,
           l_date     LIKE type_file.dat,     #No.FUN-680136 DATE
           l_pmn15    LIKE pmn_file.pmn15,
           l_pmn13    LIKE pmn_file.pmn13,
           l_pmn14    LIKE pmn_file.pmn14,
           l_pmn20    LIKE pmn_file.pmn20,
           l_pmn50_55 LIKE pmn_file.pmn50,
           l_rvb02    LIKE rvb_file.rvb02,
           l_cnt      LIKE type_file.num5
   DEFINE  l_rva      RECORD LIKE rva_file.*
   DEFINE  l_rvb      RECORD LIKE rvb_file.*
   DEFINE  p_argv2    LIKE rva_file.rva10
   DEFINE  l_rvbiicd13 LIKE rvbi_file.rvbiicd13   #TQC-C30193


   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rvb_file WHERE rvb01=l_rva.rva01
   IF l_cnt = 0 THEN LET g_success = 'N' RETURN END IF
    
   DECLARE t110_rvb_c CURSOR FOR
    SELECT * FROM rvb_file
     WHERE rvb01 = l_rva.rva01
   FOREACH t110_rvb_c INTO l_rvb.*
      #TQC-C30193 --START--
      IF s_industry('icd') THEN
         SELECT rvbiicd13 INTO l_rvbiicd13 FROM rvbi_file
          WHERE rvbi01 = l_rvb.rvb01 AND rvbi02 = l_rvb.rvb02
          IF l_rvbiicd13 = 'Y' OR cl_null(l_rvbiicd13) THEN
             CONTINUE FOREACH 
          END IF 
      END IF 
      #TQC-C30193 --END--
      SELECT pmn13,pmn14,pmn15, pmn34,pmn37,pmn20,(pmn50-pmn55-pmn58)
        INTO l_pmn13,l_pmn14,l_pmn15,l_pmn34,l_pmn37,l_pmn20,l_pmn50_55
        FROM pmn_file,pmm_file
       WHERE pmn01 = l_rvb.rvb04
         AND pmn02 = l_rvb.rvb03
         AND pmn01 = pmm01

      IF l_rvb.rvb35 = 'N' THEN
         CALL t110sub_chk_over_sub(l_rva.*,l_rvb.*,l_pmn13,l_pmn50_55,l_pmn20,l_pmn14,p_argv2)
      END IF

      IF g_success='N' THEN 
         IF g_bgerr THEN
            LET g_totsuccess = 'N' 
            LET g_success = 'Y'
         ELSE 
            LET g_totsuccess = 'N' 
            EXIT FOREACH
         END IF
      END IF

      IF l_pmn15 = 'N'  THEN  #可否提前交貨(Y/N)
         IF cl_null(l_pmn37)  THEN
            LET l_date = l_pmn34
         ELSE
            LET l_date = l_pmn37
         END IF

         IF l_rva.rva06 < l_date   THEN    
            IF g_bgerr THEN             
               CALL s_errmsg("","",l_rvb.rvb04,'apm-285',1)           
               LET g_totsuccess = 'N' 
               LET g_success = 'Y'
            ELSE                                                
               CALL cl_err3("","","","",l_rvb.rvb04,"","apm-285",1) 
               LET g_totsuccess = 'N' 
               LET g_success='N'
               EXIT FOREACH
            END IF
         END IF
      END IF
   END FOREACH

END FUNCTION

FUNCTION t110sub_chk_over_sub(l_rva,l_rvb,p_pmn13,p_pmn50_55,p_pmn20,p_pmn14,p_argv2)
DEFINE l_sfb39    LIKE sfb_file.sfb39, 
       l_sfb05    LIKE sfb_file.sfb05, 
       l_sfb93    LIKE sfb_file.sfb93, 
       l_min_set  LIKE sfb_file.sfb08, 
       l_rvb07_1  LIKE rvb_file.rvb07,
       l_rvb07_2  LIKE rvb_file.rvb07,
       l_rvb07_3  LIKE rvb_file.rvb07,
       l_fac      LIKE ima_file.ima31_fac,
       l_i        LIKE type_file.num5, 
       l_ima55    LIKE ima_file.ima55,   
       l_rvb07    LIKE rvb_file.rvb07
DEFINE l_rvb07_3_tky LIKE rvb_file.rvb03  
DEFINE l_imaicd04 LIKE imaicd_file.imaicd04
DEFINE l_rvbiicd13 LIKE rvbi_file.rvbiicd13 
DEFINE l_pmniicd13 LIKE pmni_file.pmniicd13 
DEFINE l_ima153    LIKE ima_file.ima153
DEFINE p_pmn13     LIKE pmn_file.pmn13
DEFINE p_pmn50_55  LIKE pmn_file.pmn50
DEFINE p_pmn20     LIKE pmn_file.pmn20
DEFINE p_pmn14     LIKE pmn_file.pmn14
DEFINE l_pmn20     LIKE pmn_file.pmn20
DEFINE l_rvbiicd03 LIKE rvbi_file.rvbiicd03
DEFINE l_rvbiicd06 LIKE rvbi_file.rvbiicd06   #MOD-AC0114
DEFINE l_rvbiicd07 LIKE rvbi_file.rvbiicd07   #MOD-AC0114
DEFINE l_cnt       LIKE type_file.num10
DEFINE l_pmn07     LIKE pmn_file.pmn07
DEFINE l_rva      RECORD LIKE rva_file.* 
DEFINE l_rvb      RECORD LIKE rvb_file.* 
DEFINE p_argv2    LIKE rva_file.rva10 
DEFINE l_conf_qty LIKE sfb_file.sfb08
DEFINE l_conf_qty2 LIKE sfb_file.sfb08   #MOD-AC0114
DEFINE l_conf_qty1 LIKE sfb_file.sfb08   #CHI-B60084 add
DEFINE l_conf_qty3 LIKE sfb_file.sfb08   #CHI-B60084 add

   IF s_industry('icd') THEN
      SELECT rvbiicd03,rvbiicd13,rvbiicd06,rvbiicd07    #MOD-AC0114 add rvbiicd06,rvbiicd07
         INTO l_rvbiicd03,l_rvbiicd13,l_rvbiicd06,l_rvbiicd07 FROM rvbi_file    #MOD-AC0114 add rvbiicd06,rvbiicd07
       WHERE rvbi01=l_rvb.rvb01
         AND rvbi02=l_rvb.rvb02
   END IF   

   IF cl_null(p_pmn13) THEN  #超交率
      LET p_pmn13 = 0
   END IF
   IF s_industry('icd') THEN
      #當所收的貨為WAFER時不可超交
      SELECT imaicd04 INTO l_imaicd04
        FROM imaicd_file
       WHERE imaicd00 = l_rvb.rvb05

      IF l_imaicd04 MATCHES "[012]" THEN
         LET p_pmn13 = 0
      END IF
   END IF
    
   IF cl_null(p_pmn50_55) THEN
      LET p_pmn50_55 = 0
   END IF

   #-----MOD-8C0007---------
   SELECT pmn20 INTO l_pmn20 FROM pmn_file
    WHERE pmn01=l_rvb.rvb04
      AND pmn02=l_rvb.rvb03
   #-----END MOD-8C0007-----
   LET p_pmn20 = l_pmn20

   IF s_industry('icd') THEN
      SELECT SUM(rvb07) INTO l_rvb07_3 FROM rvb_file,rva_file,rvbi_file
       WHERE rvb04 = l_rvb.rvb04
         AND rvb03 = l_rvb.rvb03
         AND rvbi01=rvb01
         AND rvbi02=rvb02
         AND rvaconf = 'N'
         AND rva01 = rvb01
         AND rvb35 = 'N'
         AND NOT (rvb01 = l_rva.rva01
         AND rvb02 = l_rvb.rvb02)
         #若為委外TKY,要排除非最後一站的數量
         AND (rvbiicd13 = 'N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
   ELSE
      SELECT SUM(rvb07) INTO l_rvb07_3 FROM rvb_file,rva_file
       WHERE rvb04 = l_rvb.rvb04
         AND rvb03 = l_rvb.rvb03
         AND rvaconf = 'N'
         AND rva01 = rvb01
         AND rvb35 = 'N'
         AND NOT (rvb01 =l_rva.rva01
         AND rvb02 = l_rvb.rvb02)
    END IF


   IF cl_null(l_rvb07_3) THEN
      LET l_rvb07_3 = 0
   END IF

   IF s_industry('icd') THEN
      #本采購單累積被衝銷量
      SELECT pmniicd13 INTO l_pmniicd13 FROM pmni_file
       WHERE pmni01 = l_rvb.rvb04
         AND pmni02 = l_rvb.rvb03

     IF cl_null(l_pmniicd13) THEN
        LET l_pmniicd13 = 0 
     END IF
   END IF
 
   #計算已交量
   LET l_rvb07=p_pmn50_55+l_rvb07_3+l_rvb.rvb07
   IF s_industry('icd') THEN
      LET l_rvb07=l_rvb07+l_pmniicd13 
   END IF
   LET l_rvb07_1=(p_pmn20*(100+p_pmn13))/100     #可交貨量
   LET l_rvb07_2=(p_pmn20*(100-p_pmn13))/100     #最少可交貨量
   IF s_industry('icd') THEN
      IF l_rvbiicd13 = 'Y' THEN
         SELECT SUM(rvb07) INTO l_rvb07_3_tky
           FROM rvb_file,rva_file,rvbi_file
          WHERE rvb04 = l_rvb.rvb04
            AND rvb03 = l_rvb.rvb03
            AND rvbi01=rvb01
            AND rvbi02=rvb02
            AND rvaconf != 'X'
            AND rva01 = rvb01
            AND rvb35 = 'N'
            AND NOT (rvb01 = l_rva.rva01
            AND rvb02 = l_rvb.rvb02)
            AND rvbiicd13 = 'Y'
            AND rvbiicd03= l_rvbiicd03
         IF cl_null(l_rvb07_3_tky) THEN
            LET l_rvb07_3_tky = 0
         END IF
         #計算已交量
         LET l_rvb07=l_rvb07_3_tky+l_rvb.rvb07
      END IF
   END IF

   IF p_pmn13 >= 0 THEN    #MODIFY 超短交控制 by Keith
      IF p_pmn14 = 'N' THEN   #不能部份交貨, 超短交都控制
         IF l_rvb07_2 > l_rvb07 THEN #短交 #MOD-530021
            IF g_sma.sma85 MATCHES '[Rr]' THEN
              IF g_bgerr THEN             
                  CALL s_errmsg("","",l_rvb07_2,'mfg3038',1)           
                  LET g_success='N'
               ELSE
                  CALL cl_err(l_rvb07_2,'mfg3038',0)
                  LET g_success='N'
                  RETURN
               END IF
            ELSE
               CALL cl_err(l_rvb07_2,'mfg9120',1)
            END IF
         END IF

         IF l_rvb07_1 < l_rvb07 THEN #超交
            IF g_sma.sma85 MATCHES '[Rr]' THEN
               IF g_bgerr THEN
                  CALL s_errmsg("","",l_rvb07_1,'mfg3037',1)           
                  LET g_success='N'
               ELSE
                  CALL cl_err(l_rvb07_1,'mfg3037',1) 
                  LET g_success='N'
                  RETURN
               END IF
            ELSE
               CALL cl_err(l_rvb07_1,'mfg9121',1) 
            END IF
         END IF
      END IF

      IF p_pmn14 = "Y" THEN    #可部份交貨, 則僅控制超交
         IF l_rvb07_1 < l_rvb07 THEN #超交
            IF g_sma.sma85 MATCHES '[Rr]' THEN
               IF g_bgerr THEN
                  CALL s_errmsg("","",l_rvb07_1,'mfg3037',1)           
                  LET g_success='N'
               ELSE
                  CALL cl_err(l_rvb07_1,'mfg3037',1) 
                  LET g_success='N'
                  RETURN
               END IF  
            ELSE
               CALL cl_err(l_rvb07_1,'mfg9121',1) 
            END IF
         END IF
      END IF
   END IF

   IF p_pmn13 < 0 THEN    #控制超短交
      IF p_pmn14 = 'N' THEN   #不能部份交貨
         IF l_rvb07 - p_pmn20 < 0 THEN      #須>= 訂購量
            IF g_bgerr THEN
               CALL s_errmsg("","",l_rvb07,'mfg3335',1)
               LET g_success = 'N'
            ELSE
               CALL cl_err(l_rvb07,'mfg3335',0)
               LET g_success='N'
               RETURN
            END IF
         END IF
      END IF
   END IF

   SELECT sfb05,sfb39,sfb93 INTO l_sfb05,l_sfb39,l_sfb93  
     FROM sfb_file
    WHERE sfb01 = l_rvb.rvb34

   #MOD-D60015 add --start--
   LET l_cnt = 0
   SELECT count(*) INTO l_cnt FROM sfa_file
    WHERE sfa01 = l_rvb.rvb34
      AND sfa03 = l_rvb.rvb05
   #MOD-D60015 add --end--
   IF l_sfb39 != '2' THEN   #工單完工方式為'2' pull 不check min_set
     #IF p_argv2 ='SUB' AND l_rvb.rvb05=l_sfb05 THEN #CHI-B60084 mark
     #IF p_argv2 ='SUB' THEN                         #CHI-B60084  #MOD-D60015 mark
      IF p_argv2 ='SUB' AND (l_rvb.rvb05=l_sfb05 OR l_cnt=0) THEN #MOD-D60015
        IF l_sfb93 != 'Y' THEN   # 製程委外不控管最小發料套數
           LET l_min_set = 0
          #CALL s_get_ima153(l_rvb.rvb05) RETURNING l_ima153 #CHI-B60084 mark 
           CALL s_get_ima153(l_sfb05) RETURNING l_ima153     #CHI-B60084 
        #  CALL s_minp(l_rvb.rvb34,g_sma.sma73,l_ima153,'','','')  #FUN-A60027  #FUN-C70037 mark
           CALL s_minp(l_rvb.rvb34,g_sma.sma73,l_ima153,'','','',l_rva.rva06)   #FUN-C70037
                 RETURNING l_cnt,l_min_set
           IF cl_null(l_min_set) THEN LET l_min_set = 0 END IF

           SELECT ima55 INTO l_ima55
             FROM ima_file
           #WHERE ima01 = l_rvb.rvb05 #CHI-B60084 mark
            WHERE ima01 = l_sfb05     #CHI-B60084
          #CALL s_umfchk(l_rvb.rvb05,l_rvb.rvb90,l_ima55) #CHI-B60084 mark 
           CALL s_umfchk(l_sfb05,l_rvb.rvb90,l_ima55)     #CHI-B60084
                RETURNING l_i,l_fac
           IF l_i = 1 THEN
              #採購單位無法與料件的生產單位做換算,預設轉換率為1
             #CALL cl_err(l_rvb.rvb05,'apm-120',1) #CHI-B60084 mark 
              CALL cl_err(l_sfb05,'apm-120',1)     #CHI-B60084
              LET l_fac = 1
           END IF
           LET l_min_set = l_min_set / l_fac

           # 確認之(收貨-退貨)
           #MOD-B90100 add --start--
           IF s_industry('icd') THEN
              #主料    
              SELECT SUM(rvb07-rvb29) INTO l_conf_qty FROM rvb_file,rva_file,rvbi_file
               WHERE rvb34 = l_rvb.rvb34
                 AND rvb01 = rva01 AND rvaconf='Y'   
                 AND rvb05 = l_sfb05 AND rvb35='N' 
                 AND NOT (rvb02=l_rvb.rvb02 AND rvb01=l_rva.rva01) 
                 AND rvb04 = l_rvb.rvb04   
                 AND rvb03 = l_rvb.rvb03  
                 AND rvbi01=rvb01 
                 AND rvbi02=rvb02
                 #排除委外tky非最終站的收貨數量
                 AND (rvbiicd13='N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')

              #聯產品                
              SELECT SUM(rvb07-rvb29) INTO l_conf_qty1 FROM rvb_file,rva_file,bmm_file,rvbi_file
               WHERE rvb34 = l_rvb.rvb34
                 AND rvb01 = rva01 AND rvaconf='Y'
                 AND bmm01 = l_sfb05
                 AND rvb05 = bmm03 AND rvb35='N'
                 AND bmm05='Y'
                 AND bmm01 <> bmm03 
                 AND NOT (rvb02=l_rvb.rvb02 AND rvb01=l_rva.rva01) 
                 AND rvb04 = l_rvb.rvb04   
                 AND rvb03 = l_rvb.rvb03  
                 AND rvbi01=rvb01 
                 AND rvbi02=rvb02
                 #排除委外tky非最終站的收貨數量
                 AND (rvbiicd13='N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
           ELSE
           #MOD-B90100 add --end--
              SELECT SUM(rvb07-rvb29) INTO l_conf_qty FROM rvb_file,rva_file
               WHERE rvb34 = l_rvb.rvb34
                 #AND rvb01 = rva01 AND rvaconf<>'X'    #MOD-A80206
                 AND rvb01 = rva01 AND rvaconf='Y'    #MOD-A80206
                #AND rvb05 = l_rvb.rvb05 AND rvb35='N' #CHI-B60084 mark
                 AND rvb05 = l_sfb05 AND rvb35='N'     #CHI-B60084
                 AND NOT (rvb02=l_rvb.rvb02 AND rvb01=l_rva.rva01) 
                 AND rvb04 = l_rvb.rvb04   
                 AND rvb03 = l_rvb.rvb03  

              #CHI-B60084 add --start--
              #聯產品                
              SELECT SUM(rvb07-rvb29) INTO l_conf_qty1 FROM rvb_file,rva_file,bmm_file
               WHERE rvb34 = l_rvb.rvb34
                 AND rvb01 = rva01 AND rvaconf='Y'
                 AND bmm01 = l_sfb05
                 AND rvb05 = bmm03 AND rvb35='N'
                 AND bmm05='Y'
                 AND bmm01 <> bmm03 
                 AND NOT (rvb02=l_rvb.rvb02 AND rvb01=l_rva.rva01) 
                 AND rvb04 = l_rvb.rvb04   
                 AND rvb03 = l_rvb.rvb03  
              #CHI-B60084 add --end--
           END IF #MOD-B90100 add

           IF l_conf_qty IS NULL THEN LET l_conf_qty=0 END IF
           IF l_conf_qty1 IS NULL THEN LET l_conf_qty1=0 END IF #CHI-B60084 add
          #LET l_min_set=l_min_set-l_conf_qty                 #CHI-B60084 mark
           LET l_min_set=l_min_set-l_conf_qty-l_conf_qty1     #CHI-B60084
#-----MOD-AC0114---------
           IF s_industry('icd') THEN
              SELECT SUM(rvbiicd06+rvbiicd07) INTO l_conf_qty2 FROM rvb_file,rva_file,rvbi_file
               WHERE rvb34 = l_rvb.rvb34
                 AND rvb01 = rva01 AND rvaconf='Y'  
                #AND rvb05 = l_rvb.rvb05 AND rvb35='N'       #CHI-B60084 mark
                 AND rvb05 = l_sfb05 AND rvb35='N'           #CHI-B60084
                 AND NOT (rvb02=l_rvb.rvb02 AND rvb01=l_rva.rva01)
                 AND rvb04 = l_rvb.rvb04   
                 AND rvb03 = l_rvb.rvb03   
                 AND rvbi01=rvb01
                 AND rvbi02=rvb02
                #MOD-B90100 add --start--
                 #排除委外tky非最終站的收貨數量
                 AND (rvbiicd13='N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
                #MOD-B90100 add --end--

              #CHI-B60084 add --start--
              #聯產品                
              SELECT SUM(rvbiicd06+rvbiicd07) INTO l_conf_qty3 FROM rvb_file,rva_file,rvbi_file,bmm_file
               WHERE rvb34 = l_rvb.rvb34
                 AND rvb01 = rva01 AND rvaconf='Y'  
                 AND bmm01 = l_sfb05
                 AND rvb05 = bmm03 AND rvb35='N'
                 AND bmm05='Y'
                 AND bmm01 <> bmm03   
                 AND NOT (rvb02=l_rvb.rvb02 AND rvb01=l_rva.rva01)
                 AND rvb04 = l_rvb.rvb04   
                 AND rvb03 = l_rvb.rvb03   
                 AND rvbi01=rvb01
                 AND rvbi02=rvb02
                #MOD-B90100 add --start--
                 #排除委外tky非最終站的收貨數量
                 AND (rvbiicd13='N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
                #MOD-B90100 add --end--
              #CHI-B60084 add --end--

              IF l_conf_qty2 IS NULL THEN LET l_conf_qty2=0 END IF
              IF l_conf_qty3 IS NULL THEN LET l_conf_qty3=0 END IF #CHI-B60084 add
              LET l_min_set=l_min_set-l_conf_qty2                #CHI-B60084 mark
              LET l_min_set=l_min_set-l_conf_qty2-l_conf_qty3    #CHI-B60084
           END IF
#-----END MOD-AC0114-----

           IF NOT s_industry('icd') THEN   #MOD-AC0114
              IF l_rvb.rvb07 > l_min_set THEN 
                 IF g_bgerr THEN
                    CALL s_errmsg("","",l_rvb.rvb07,'apm-307',1)
                    LET g_success = 'N'
                 ELSE
                    CALL cl_err(l_rvb.rvb07,'apm-307',1) 
                    LET g_success='N'
                    RETURN
                 END IF
              END IF
           ELSE
           #-----MOD-AC0114---------
              IF l_rvb.rvb07+l_rvbiicd06+l_rvbiicd07 > l_min_set THEN    
                 IF g_bgerr THEN
                    CALL s_errmsg("","",l_rvb.rvb07+l_rvbiicd06+l_rvbiicd07,'apm-369',1)
                    LET g_success = 'N'
                 ELSE
                    CALL cl_err(l_rvb.rvb07+l_rvbiicd06+l_rvbiicd07,'apm-369',1) 
                    LET g_success='N'
                    RETURN
                 END IF
              END IF
           END IF
           #-----END MOD-AC0114-----
         ELSE
           SELECT pmn07 INTO l_pmn07 FROM pmn_file WHERE pmn01=l_rvb.rvb04 AND pmn02=l_rvb.rvb03 #MOD-B50153 add
           CALL t110sub_get_min_set(l_rvb.rvb05,l_rvb.rvb34,l_pmn07,l_rva.rva01,
                                l_rvb.rvb02,l_rvb.rvb03,l_rvb.rvb04,l_rvb.rvb90) #取得l_min_set的值
           RETURNING l_min_set
           IF NOT s_industry('icd') THEN
             #for ICD Turnkey收貨不需check發料最小套數
              IF l_rvb.rvb07 > l_pmn20 - l_conf_qty THEN
                 IF g_bgerr THEN
                    CALL s_errmsg("","",l_rvb.rvb07,'apm-070',1)
                    LET g_success = 'N'
                 ELSE
                    CALL cl_err(l_rvb.rvb07,'apm-070',1) 
                    LET g_success='N'
                    RETURN
                 END IF
               END IF
           END IF
        END IF
      END IF
   END IF

END FUNCTION

FUNCTION t110sub_get_min_set(p_rvb05,p_rvb34,p_pmn07,p_rva01,p_rvb02,p_rvb03,p_rvb04,p_rvb90)
  DEFINE  l_ima55      LIKE ima_file.ima55,
          l_fac        LIKE ima_file.ima31_fac, 
          l_i          LIKE type_file.num5     
   DEFINE l_ima153     LIKE ima_file.ima153 
   DEFINE l_min_set    LIKE sfb_file.sfb08
   DEFINE l_conf_qty LIKE sfb_file.sfb08
   DEFINE p_rvb05      LIKE rvb_file.rvb05
   DEFINE p_rvb34      LIKE rvb_file.rvb34
   DEFINE p_pmn07      LIKE pmn_file.pmn07
   DEFINE p_rva01      LIKE rva_file.rva01
   DEFINE p_rvb02      LIKE rvb_file.rvb02
   DEFINE p_rvb03      LIKE rvb_file.rvb03
   DEFINE p_rvb04      LIKE rvb_file.rvb04
   DEFINE p_rvb90      LIKE rvb_file.rvb90
   DEFINE l_cnt        LIKE type_file.num10
   DEFINE l_pmn04     LIKE pmn_file.pmn04   #CHI-B60084 add
   DEFINE l_conf_qty1 LIKE sfb_file.sfb08   #CHI-B60084 add
   DEFINE l_conf_qty3 LIKE sfb_file.sfb08   #CHI-B60084 add
   DEFINE l_rva06     LIKE rva_file.rva06   #FUN-C70037 add

   LET l_min_set = 0

   CALL s_get_ima153(p_rvb05)  RETURNING l_ima153 
   #FUN-C70037 ---------------Begin------------------
   SELECT rva06 INTO l_rva06 FROM rva_file,rvb_file
    WHERE rva01 = rvb01
      AND rva01 = p_rva01
   #FUN-C70037 ---------------End--------------------
#  CALL s_minp(p_rvb34,g_sma.sma73,l_ima153,'','','')  #FUN-A60027 #FUN-C70037 mark
   CALL s_minp(p_rvb34,g_sma.sma73,l_ima153,'','','',l_rva06)      #FUN-C70037 
         RETURNING l_cnt,l_min_set

   SELECT ima55 INTO l_ima55
     FROM ima_file
    WHERE ima01 = p_rvb05

   CALL s_umfchk(p_rvb05,p_rvb90,l_ima55)
        RETURNING l_i,l_fac

   IF l_i = 1 THEN
      #採購單位無法與料件的生產單位做換算,預設轉換率為1
      CALL cl_err(p_rvb05,'apm-120',1)
      LET l_fac = 1
   END IF

   LET l_min_set = l_min_set / l_fac

   # 確認之(收貨-退貨)
   #CHI-B60084 add --start--
   SELECT pmn04 INTO l_pmn04
     FROM pmn_file
    WHERE pmn01 = p_rvb04
      AND pmn02 = p_rvb03
   #CHI-B60084 add --end--
   #MOD-B90100 add --start--
   IF s_industry('icd') THEN
      SELECT SUM(rvb07-rvb29) INTO l_conf_qty FROM rvb_file,rva_file,rvbi_file
       WHERE rvb34 = p_rvb34
         AND rvb01 = rva01
         AND rvaconf<>'X'  
         AND rvb05 = l_pmn04 AND rvb35='N' 
         AND NOT (rvb02=p_rvb02 AND rvb01=p_rva01)
         AND rvb04 = p_rvb04  
         AND rvb03 = p_rvb03   
         AND rvbi01=rvb01 
         AND rvbi02=rvb02
         #排除委外tky非最終站的收貨數量
         AND (rvbiicd13='N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')

      #聯產品                
      SELECT SUM(rvb07-rvb29) INTO l_conf_qty1 FROM rvb_file,rva_file,bmm_file,rvbi_file
       WHERE rvb34 = p_rvb34
         AND rvb01 = rva01
         AND rvaconf<>'X'  
         AND bmm01 = l_pmn04
         AND rvb05 = bmm03 AND rvb35='N'
         AND bmm05='Y'
         AND bmm01 <> bmm03 
         AND NOT (rvb02=p_rvb02 AND rvb01=p_rva01)
         AND rvb04 = p_rvb04  
         AND rvb03 = p_rvb03   
         AND rvbi01=rvb01 
         AND rvbi02=rvb02
         #排除委外tky非最終站的收貨數量
         AND (rvbiicd13='N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
   ELSE
      #MOD-B90100 add --end--
      SELECT SUM(rvb07-rvb29) INTO l_conf_qty FROM rvb_file,rva_file
       WHERE rvb34 = p_rvb34
         AND rvb01 = rva01
         AND rvaconf<>'X'  
        #AND rvb05 =p_rvb05 #CHI-B60084 mark 
        #AND rvb35='N'      #CHI-B60084 mark
         AND rvb05 = l_pmn04 AND rvb35='N'     #CHI-B60084
         AND NOT (rvb02=p_rvb02 AND rvb01=p_rva01)
         AND rvb04 = p_rvb04  
         AND rvb03 = p_rvb03   

      #CHI-B60084 add --start--
      #聯產品                
      SELECT SUM(rvb07-rvb29) INTO l_conf_qty1 FROM rvb_file,rva_file,bmm_file
       WHERE rvb34 = p_rvb34
         AND rvb01 = rva01
         AND rvaconf<>'X'  
         AND bmm01 = l_pmn04
         AND rvb05 = bmm03 AND rvb35='N'
         AND bmm05='Y'
         AND bmm01 <> bmm03 
         AND NOT (rvb02=p_rvb02 AND rvb01=p_rva01)
         AND rvb04 = p_rvb04  
         AND rvb03 = p_rvb03   
      #CHI-B60084 add --end--
   END IF #MOD-B90100 add

   IF l_conf_qty IS NULL THEN
      LET l_conf_qty = 0
   END IF

   IF l_conf_qty1 IS NULL THEN LET l_conf_qty1=0 END IF #CHI-B60084 add

  #LET l_min_set=l_min_set-l_conf_qty                 #CHI-B60084 mark
   LET l_min_set=l_min_set-l_conf_qty-l_conf_qty1     #CHI-B60084
   RETURN l_min_set

END FUNCTION

#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#p_ask_post : IF p_ask_post=TRUE 會詢問"是否執行過帳"
#p_argv5 : IF p_argv5='1' 執行自動確認
#p_argv2 : 采購類別
#p_rvu03_flag : IF p_rvu03_flag = '1'則為自動確認後產生的入庫單
FUNCTION t110sub_y_upd(p_rva01,p_inTransaction,p_ask_post,p_argv5,p_argv2,p_rvu03_flag,p_argv6)                          #執行段
   DEFINE l_cnt      LIKE type_file.num5 
   DEFINE p_rva01    LIKE rva_file.rva01
   DEFINE p_argv6    LIKE rva_file.rva00
   DEFINE p_inTransaction  LIKE type_file.num5
   DEFINE l_rva      RECORD LIKE rva_file.*
   DEFINE p_ask_post LIKE type_file.chr1
   DEFINE l_cmd      LIKE type_file.chr1000
   DEFINE p_argv5    LIKE type_file.chr1
   DEFINE p_argv2    LIKE rva_file.rva10
   DEFINE p_rvu03_flag    LIKE type_file.chr1
   DEFINE l_rvu01    LIKE rvu_file.rvu01
   DEFINE l_flag     LIKE type_file.chr1   #CHI-A70021 做為入庫單單身是否有做批序號管理的判斷
   DEFINE l_rvv31    LIKE rvv_file.rvv31   #CHI-A70021
   DEFINE l_ima918   LIKE ima_file.ima918  #CHI-A70021
   DEFINE l_ima921   LIKE ima_file.ima921  #CHI-A70021
   DEFINE l_prog_old LIKE type_file.chr20  #程式代號備份   #MOD-A80168
   DEFINE l_rvuconf  LIKE rvu_file.rvuconf,    #CHI-B40011
          l_rvu20    LIKE rvu_file.rvu20,      #CHI-B40011
          l_rvu00    LIKE rvu_file.rvu00,      #CHI-B40011
          l_msg      LIKE ze_file.ze03         #CHI-B40011
   DEFINE l_rvb       RECORD LIKE rvb_file.*  #FUN-C70087
   #DEFINE l_img_table      STRING             #FUN-C70087  #FUN-CC0095
   #DEFINE l_imgg_table     STRING             #FUN-C70087  #FUN-CC0095
   DEFINE l_cnt_img   LIKE type_file.num5     #FUN-C70087
   DEFINE l_cnt_imgg  LIKE type_file.num5     #FUN-C70087
   DEFINE l_sql            STRING             #FUN-C70087
   DEFINE l_pmm02     LIKE pmm_file.pmm02     #TQC-C80120 add
   DEFINE l_sfb93     LIKE sfb_file.sfb93     #TQC-C80120 add
   DEFINE l_t         LIKE type_file.chr10   #TQC-D50082 add
   DEFINE l_smy52     LIKE type_file.chr10   #TQC-D50082 add
   DEFINE l_smydmy4   LIKE type_file.chr1    #TQC-D50082 add
   DEFINE l_ima906    LIKE ima_file.ima906    #MOD-EB0112---ADD
   #M006 171122 By TSD.Nic -----(S)
   DEFINE l_cmdr      STRING
   #M006 171122 By TSD.Nic -----(E)

   #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087  #FUN-CC0095
   #CALL s_padd_imgg_create() RETURNING l_imgg_table #FUN-C70087  #FUN-CC0095
   
   LET g_success = 'Y'

   SELECT * INTO l_rva.* FROM rva_file WHERE rva01=p_rva01  #FUN-A60026 add

#CHI-C30118---mark---START 移至y_chk最上方
# IF g_action_choice CLIPPED = "confirm" OR      #執行 "確認" 功能(非簽核模式呼叫)
#    g_action_choice CLIPPED = "insert"  THEN
#   IF l_rva.rvamksg='Y' THEN                    #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
#      IF l_rva.rva32 != '1' THEN
#         CALL cl_err('','aws-078',1)
#         LET g_success = 'N'
#         RETURN
#      END IF
#   END IF
#   IF p_ask_post='Y' THEN  # 外部呼叫的程式不可出現詢問視窗
#      IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF #詢問是否執行確認功能 
#   END IF
# END IF
#CHI-C30118---mark---END

   #DEV-D40015--add--begin
   #自動產生barcode
   IF g_success='Y' AND g_prog = 'apmt110' AND g_aza.aza131 = 'Y' THEN
      CALL t110sub_barcode_gen(l_rva.rva01,'N')
   END IF
   #DEV-D40015--add--end

   IF NOT p_inTransaction THEN
      BEGIN WORK
   END IF

   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   DECLARE t110_s_c1 CURSOR FOR SELECT * FROM rvb_file
     WHERE rvb01 = l_rva.rva01

   FOREACH t110_s_c1 INTO l_rvb.*
      IF STATUS THEN EXIT FOREACH END IF
      IF NOT cl_null(l_rvb.rvb36) THEN #MOD-D50194 add
         LET l_cnt_img = 0
         SELECT COUNT(*) INTO l_cnt_img
           FROM img_file
          WHERE img01 = l_rvb.rvb05
            AND img02 = l_rvb.rvb36
            AND img03 = l_rvb.rvb37
            AND img04 = l_rvb.rvb38
         IF l_cnt_img = 0 THEN
            #CALL s_padd_img_data(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,l_rva.rva01,l_rvb.rvb02,l_rva.rva06,l_img_table) #FUN-CC0095
            CALL s_padd_img_data1(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,l_rva.rva01,l_rvb.rvb02,l_rva.rva06) #FUN-CC0095
         END IF

         SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01 = l_rvb.rvb05  #MOD-EB0112---ADD
         IF l_ima906 ='2' THEN   #MOD-EB0112---ADD
             CALL s_chk_imgg(l_rvb.rvb05,l_rvb.rvb36,
                             l_rvb.rvb37,l_rvb.rvb38,
                             l_rvb.rvb80) RETURNING l_flag
             IF l_flag = 1 THEN
                #CALL s_padd_imgg_data(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,l_rvb.rvb80,l_rva.rva01,l_rvb.rvb02,l_imgg_table) #FUN-CC0095
                CALL s_padd_imgg_data1(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,l_rvb.rvb80,l_rva.rva01,l_rvb.rvb02) #FUN-CC0095
             END IF 
         END IF   #MOD-EB0112---ADD
         IF l_ima906 MATCHES '[23]' THEN   #MOD-EB0112---ADD
             CALL s_chk_imgg(l_rvb.rvb05,l_rvb.rvb36,
                             l_rvb.rvb37,l_rvb.rvb38,
                             l_rvb.rvb83) RETURNING l_flag
             IF l_flag = 1 THEN
                #CALL s_padd_imgg_data(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,l_rvb.rvb83,l_rva.rva01,l_rvb.rvb02,l_imgg_table) #FUN-CC0095
                CALL s_padd_imgg_data1(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,l_rvb.rvb83,l_rva.rva01,l_rvb.rvb02) #FUN-CC0095
             END IF 
         END IF   #MOD-EB0112---ADD
      END IF #MOD-D50194 add
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_img FROM l_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_imgg FROM l_sql
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end    
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
          
   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
      IF NOT cl_null(l_rvb.rvb36) THEN #MOD-D70023 add
        #IF cl_confirm('mfg1401') THEN #MOD-DA0134 mark 
  #MOD-DA0134 add start -----
         IF NOT cl_confirm('mfg1401') THEN 
            LET g_success = 'N'
            RETURN 
         END IF 
      END IF 
   END IF 
   IF NOT cl_null(l_rvb.rvb36) THEN
  #MOD-DA0134 add end   -----
      IF l_cnt_img > 0 THEN 
         #IF NOT s_padd_img_show(l_img_table) THEN   #FUN-CC0095
         IF NOT s_padd_img_show1() THEN  #FUN-CC0095
            #CALL s_padd_img_drop(l_img_table) #FUN-CC0095
            LET g_success = 'N'
            #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #CHI-CB0041
            #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #CHI-CB0041
            RETURN 
         END IF 
      END IF 
      IF l_cnt_imgg > 0 THEN #FUN-CC0095 
         #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095
         IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
            #CALL s_padd_imgg_drop(l_imgg_table)  ##FUN-CC0095
            LET g_success = 'N'
            #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #CHI-CB0041
            #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #CHI-CB0041
            RETURN 
         END IF 
      END IF #FUN-CC0095    
  #MOD-DA0134 mark start -----
  #      ELSE
  #         #CALL s_padd_img_drop(l_img_table)  #FUN-CC0095
  #         #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095
  #         LET g_success = 'N'
  #         #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #CHI-CB0041
  #         #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #CHI-CB0041
  #         RETURN
  #      END IF
  #   END IF #MOD-D70023 add
  #MOD-DA0134 mark start -----
   END IF
   #CALL s_padd_img_del(l_img_table)  #FUN-CC0095
   #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095
   #FUN-C70087---end
   
   CALL t110sub_lock_cl()

   OPEN t110sub_cl USING p_rva01
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err("OPEN t110sub_cl:", STATUS, 1)
      CLOSE t110sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
   FETCH t110sub_cl INTO l_rva.*                       #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(l_rva.rva01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t110sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF

   #-->更新單頭確認碼
   LET g_time = TIME
   UPDATE rva_file SET rvaconf = 'Y',          #更新單頭確認碼
                       rvaconu=g_user,
                       rvacond=g_today,
                       rvacont=g_time
                      ,rva32 ='1'             #更新狀況碼為:已核准
    WHERE rva01 = l_rva.rva01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success = 'N'
   END IF

#FUN-C20006--add--begin--
   IF s_industry('slk') THEN 
      IF g_azw.azw04 = '2' THEN
         CALL t110sub_add_img(l_rva.*)
      END IF 
   END IF 
#FUN-C20006--add--end--

   CALL t110sub_y1(l_rva.*,p_argv5,p_argv2,p_rvu03_flag,p_argv6)
   RETURNING l_rvu01

   IF g_success ='Y' THEN  
      IF p_argv6 ='1' THEN
         CALL t110sub_upd_pmn(l_rva.rva01)
      END IF
   END IF  
   
   CALL cl_msg("")
   
   IF g_success = 'Y' THEN
      LET l_rva.rvaconu = g_user  
      LET l_rva.rvacond = g_today 
      LET l_rva.rvacont = g_time
      IF l_rva.rvamksg = 'Y' THEN                 #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                   LET l_rva.rvaconf="N"
                   LET g_success = "N"
                   IF NOT p_inTransaction THEN ROLLBACK WORK END IF
                   #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
                   #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                   LET l_rva.rvaconf="N"
                   LET g_success = "N"
                   IF NOT p_inTransaction THEN ROLLBACK WORK END IF
                   #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
                   #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
                   RETURN
         END CASE      
      END IF  

      LET l_rva.rva32='1'                #執行成功, 狀態值顯示為 '1' 已核准
      LET l_rva.rvaconf='Y'              #執行成功, 確認碼顯示為 'Y' 已確認
      LET l_cnt = 0
      IF NOT cl_null(l_rvu01) THEN
         SELECT COUNT(*) INTO l_cnt FROM rvu_file
          WHERE rvu02 = l_rva.rva01
            AND rvuconf != 'X'         
#        IF l_cnt > 0 AND p_argv6 <> '2' THEN   #CHI-B80038 mark
         IF l_cnt > 0 THEN                      #CHI-B80038
            #-----CHI-A70021---------
            DECLARE rvv31_curs CURSOR FOR
               SELECT rvv31 FROM rvv_file WHERE rvv01=l_rvu01
            LET l_flag = 'N'
            FOREACH rvv31_curs INTO l_rvv31
              SELECT ima918,ima921 INTO l_ima918,l_ima921 FROM ima_file
                WHERE ima01 = l_rvv31
              IF l_ima918='Y' OR l_ima921 = 'Y' THEN
                 LET l_flag = 'Y'
                 EXIT FOREACH
              END IF
            END FOREACH
           #IF NOT (g_sma.sma90='N' AND l_flag='Y') THEN      #MOD-FB0174 mark
            #-----END CHI-A70021-----
            #MOD-FB0174 add start ---------------------------
            IF (s_industry('slk') AND g_sma.sma150 = 'Y') OR 
               NOT (g_sma.sma90='N' AND l_flag='Y') THEN 
            #MOD-FB0174 add end   ---------------------------
               #-----MOD-A80168---------
               LET l_prog_old = g_prog
               IF l_rva.rva10='SUB' THEN
                  IF NOT s_industry('icd') THEN
                     LET g_prog = "apmt730"
                  ELSE
                     LET g_prog = "apmt730_icd"                          
                  END IF
               ELSE
                  IF l_rva.rva10='TAP' THEN  
                     IF NOT s_industry('icd') THEN
                        LET g_prog = "apmt740"
                     ELSE
                        LET g_prog = "apmt740_icd" 
                     END IF
                  ELSE
                     IF NOT s_industry('icd') THEN
                        LET g_prog = "apmt720"
                     ELSE
                       LET g_prog = "apmt720_icd"  
                     END IF
                  END IF
               END IF
              #-----END MOD-A80168-----
              #CALL t720sub_y(l_rvu01,'5',l_rva.rva01,p_argv2,'7',TRUE,'N') #FUN-A60009 mark
              #FUN-A60009 add str ---------------------
               CALL t720sub_y_chk(l_rvu01,'5',l_rva.rva01,p_argv2,'7','N')
               IF g_success = "Y" THEN
                  #CALL t720sub_y_upd(l_rvu01,'5',l_rva.rva01,p_argv2,'7',TRUE,'N')    #MOD-C80049 mark
                  #TQC-D50082--add--str--
                   CALL s_get_doc_no(l_rva.rva01) RETURNING l_t
                   SELECT smy52 INTO l_smy52  FROM smy_file WHERE smyslip = l_t
                   SELECT smydmy4 INTO l_smydmy4  FROM smy_file WHERE smyslip = l_smy52
                   IF l_smydmy4 = 'Y' THEN   
                   #TQC-D50082--add--end--                  
                      CALL t720sub_y_upd(l_rvu01,'5',l_rva.rva01,p_argv2,'7',TRUE,'N','N') #MOD-C80049 add
                   END IF     #TQC-D50082  add
               END IF
              #FUN-A60009 add end --------------------- 
               LET g_prog = l_prog_old   #MOD-A80168
            END IF   #CHI-A70021
         END IF
      END IF

      #FUN-G90010 add s
      #產生barcode
      IF g_success='Y' AND (g_prog = 'apmt110') THEN
         IF NOT s_barcode('1',g_prog,l_rva.rva01,l_rva.rva05) THEN
            LET g_success = 'N'
         END IF
      END IF

      #產生扣帳barcode
      IF g_success='Y' AND (g_prog = 'apmt110') THEN
         IF NOT s_barcode_01('1',g_prog,l_rva.rva01) THEN
            LET g_success = 'N'
         END IF
      END IF
      #FUN-G90010 add e

      IF g_success = 'N' THEN
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
         #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
         RETURN
      END IF
      IF NOT p_inTransaction THEN 
         COMMIT WORK 

         #因目前自動產生AP會開窗,故EF簽核暫不走自動產生AP，
         #待AP畫面開窗時會自動帶入預設值的規格定案後再處理
         IF cl_null(l_rva.rvamksg) OR l_rva.rvamksg = 'N' THEN  #FUN-A60003 add
            #No.FUN-A80026  --Begin
#            IF NOT cl_null(l_rvu01) THEN                                           #MOD-B80272 mark
             IF NOT cl_null(l_rvu01) AND (g_sma.sma91='Y' OR g_sma.sma92='Y') THEN  #MOD-B80272
                CALL t720_gen_ap(l_rvu01)
             END IF
            #No.FUN-A80026  --End  
         END IF                                                 #FUN-A60003 add

         #M006 171122 By TSD.Nic -----(S)
         #自動產生QC單
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
           FROM rvb_file
          WHERE rvb01 = l_rva.rva01
            AND rvb39 = 'Y'
         IF l_cnt > 0 THEN
            LET l_cmdr = "aqcp001  '",l_rva.rva01,"' "
            CALL cl_cmdrun_wait(l_cmdr)
         END IF
         #M006 171122 By TSD.Nic -----(E)
      END IF

      #MOD-C80049 add start -----
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM rvu_file WHERE rvu01 = l_rvu01 AND rvuconf = 'Y'
      #IF l_cnt > 0 THEN                  #TQC-C80120 mark
      #TQC-C80120 add start -----
      IF l_cnt > 0 AND p_argv6 = '1' THEN
         SELECT UNIQUE pmm02 INTO l_pmm02 FROM pmm_file
          WHERE pmm01 IN (SELECT rvv36 FROM rvv_file
                           WHERE rvv01 = l_rvu01)
         IF l_pmm02 = 'SUB' AND g_sma.sma131 = 'Y' AND (g_sma.sma1431='N' OR cl_null(g_sma.sma1431)) THEN
            SELECT sfb93 INTO l_sfb93 FROM rvv_file,sfb_file WHERE sfb01=rvv18 AND rvv01 = l_rvu01 ORDER BY rvv02
            IF l_sfb93 = 'Y' THEN
      #TQC-C80120 add end   -----
               CALL t720sub_ecm(l_rvu01)
            END IF #TQC-C80120 add
         END IF    #TQC-C80120 add
      END IF
      #MOD-C80049 add end   -----

      CALL cl_flow_notify(l_rva.rva01,'Y')
      CALL cl_cmmsg(4)
      #-----CHI-B40011---------
      IF NOT p_inTransaction THEN 
         SELECT pod05 INTO g_pod.pod05 
           FROM pod_file 
          WHERE pod00 = '0'
         SELECT rvuconf,rvu20,rvu00 INTO l_rvuconf,l_rvu20,l_rvu00  
           FROM rvu_file
          WHERE rvu01 = l_rvu01
         IF l_rva.rva10 = 'TAP' AND g_pod.pod05 = 'Y' AND 
            l_rvuconf = 'Y' AND l_rvu20 = 'N' THEN
            CASE
               WHEN l_rvu00='1' #入庫
                  IF t720sub_chkpoz011(l_rvu01) THEN
                     LET l_msg="apmp822 '",l_rvu01,"'"
                     CALL cl_cmdrun_wait(l_msg CLIPPED)
                  END IF
            END CASE
         END IF
      END IF
      #-----END CHI-B40011----- 
   ELSE
      LET g_success = 'N'
      LET l_rva.rvaconf='N'
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      CALL s_showmsg()       
      CALL cl_rbmsg(4)
   END IF

   #CALL s_padd_img_drop(l_img_table)   #FUN-C70087  #FUN-CC0095
   #CALL s_padd_imgg_drop(l_imgg_table) #FUN-C70087  #FUN-CC0095
   {#CKP
   IF g_rva.rvaconf='X' THEN 
     LET g_chr='Y' 
   ELSE 
     LET g_chr='N' 
   END IF
   CALL cl_set_field_pic(g_rva.rvaconf,"","","",g_chr,"")}

   #DEV-D40015--add--begin
   #失敗自動作廢
   IF g_success='N' AND g_prog = 'apmt110' AND g_aza.aza131 = 'Y' THEN
      CALL t110sub_barcode_z(l_rva.rva01,FALSE)
   END IF
   #DEV-D40015--add--end

  #DEV-D40015 mark add------  #改至確認chk段之前
  ##DEV-D30045--add--begin
  ##自動產生barcode
  #IF g_success='Y' AND g_prog = 'apmt110' AND g_aza.aza131 = 'Y' THEN
  #   CALL t110sub_barcode_gen(l_rva.rva01,'N')
  #END IF
  ##DEV-D30045--add--end
  #DEV-D40015 mark end------

END FUNCTION

FUNCTION t110sub_upd_pmn(p_rva01)
DEFINE l_rvb03    LIKE rvb_file.rvb03,
       l_rvb04    LIKE rvb_file.rvb04,
       l_rvb35    LIKE rvb_file.rvb35,
       l_rvb07    LIKE rvb_file.rvb07,
       l_rvb30    LIKE rvb_file.rvb30,
       l_rvv17    LIKE rvv_file.rvv17,    #
       l_pmn51    LIKE pmn_file.pmn51,
       l_rvb02    LIKE rvb_file.rvb02   
DEFINE l_rvbiicd13    LIKE rvbi_file.rvbiicd13  
DEFINE p_rva01    LIKE rva_file.rva01
DEFINE l_ima24    LIKE ima_file.ima24     #MOD-B50044 


   #-->計算採購單之已交量/在驗量(已交量-退貨量-入庫量)
   DECLARE t110_upd_pmn CURSOR WITH HOLD FOR
     SELECT rvb03,rvb04,rvb35,rvb02  
       FROM rvb_file WHERE rvb01 = p_rva01

   FOREACH t110_upd_pmn INTO l_rvb03,l_rvb04,l_rvb35,l_rvb02  
      #-->樣品不更新PO上的數量
      IF l_rvb35 <> 'N' THEN
         CONTINUE FOREACH
      END IF
      IF s_industry('icd') THEN
         SELECT rvbiicd13 INTO l_rvbiicd13
           FROM rvbi_file
          WHERE rvbi01=p_rva01
            AND rvbi02=l_rvb02
         #判斷若為委外收貨單TKY,非最後一站的項次,不更新收貨資料
         IF l_rvbiicd13 = 'Y' THEN CONTINUE FOREACH END IF
      END IF

      IF s_industry('icd') THEN
         SELECT SUM(rvb30),SUM(rvb07),SUM(rvb07-rvb29-rvb30)
           INTO l_rvb30,l_rvb07,l_pmn51
           FROM rva_file,rvb_file,rvbi_file
          WHERE rvb04 = l_rvb04
            AND rvb03 = l_rvb03
            AND rvb35 = 'N'
            AND rvaconf = 'Y'
            AND rva01 = rvb01
            AND rvbi01= rvb01
            AND rvbi02= rvb02
            AND (rvbiicd13 = 'N' OR rvbiicd13 IS NULL OR rvbiicd13 = ' ')
      ELSE
         SELECT SUM(rvb30),SUM(rvb07),SUM(rvb07-rvb29-rvb30)
           INTO l_rvb30,l_rvb07,l_pmn51
           FROM rva_file,rvb_file
          WHERE rvb04 = l_rvb04
            AND rvb03 = l_rvb03
            AND rvb35 = 'N'
            AND rvaconf = 'Y'
            AND rva01 = rvb01
      END IF

      IF cl_null(l_rvb07) THEN LET l_rvb07=0 END IF
      IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
      IF cl_null(l_pmn51) THEN LET l_pmn51=0 END IF

      IF s_industry('icd') THEN
         SELECT SUM(rvv17) INTO l_rvv17     #計算此採購單對應之倉退量
           FROM rvv_file,rvu_file,rvvi_file
          WHERE rvv37 = l_rvb03
            AND rvv36 = l_rvb04
            AND rvv25 = 'N'
            AND rvuconf = 'Y'
            AND rvu01 = rvv01
            AND rvu00 = '3'  #倉退
            AND rvvi01=rvv01
            AND rvvi02=rvv02
            AND (rvviicd07 = 'N' OR rvviicd07 IS NULL OR rvviicd07 = ' ')
      ELSE
         SELECT SUM(rvv17) INTO l_rvv17     #計算此採購單對應之倉退量
           FROM rvv_file,rvu_file
          WHERE rvv37 = l_rvb03
            AND rvv36 = l_rvb04
            AND rvv25 = 'N'
            AND rvuconf = 'Y'
            AND rvu01 = rvv01
            AND rvu00 = '3'  #倉退
      END IF
      IF cl_null(l_rvv17) THEN LET l_rvv17=0 END IF

      #-->(1-1)更新採購單已交量/在驗量
      CALL cl_msg("Update pmn_file ...")

#MOD-B50044 --begin--
      SELECT ima24 INTO l_ima24 FROM ima_file
       WHERE ima01 IN(SELECT pmn04 FROM pmn_file WHERE pmn01 = l_rvb04 AND pmn02=l_rvb03)
      IF l_ima24 = 'Y' THEN
        IF g_sma.sma886[6,6] = 'Y' THEN
          UPDATE pmn_file SET pmn51 = l_pmn51
           WHERE pmn01 = l_rvb04
             AND pmn02 = l_rvb03
        END IF
      END IF
#MOD-B50044 --end--

      UPDATE pmn_file SET pmn50 = l_rvb07,            #已交量
#                         pmn51 = l_pmn51,            #在驗量     #MOD-B50044 
                          pmn53 = l_rvb30             #入庫量
       WHERE pmn01 = l_rvb04
         AND pmn02 = l_rvb03
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success = 'N'
         IF g_bgerr THEN
            LET g_showmsg = l_rvb04,"/",l_rvb03
            CALL s_errmsg("pmn01,pmn02",g_showmsg,"upd pmn50:",SQLCA.sqlcode,1)
         ELSE
           CALL cl_err3("upd","pmn_file",l_rvb04,l_rvb03,SQLCA.sqlcode,"","upd pmn50:",1)
         END IF
         RETURN
      END IF
      CALL s_udpmn57(l_rvb04,l_rvb03) 
   END FOREACH

   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg("","","foreach",STATUS,1)
      ELSE
         CALL cl_err3("","","","",STATUS,"","foreach",1)
      END IF
      LET g_success = 'N'
   END IF

END FUNCTION

FUNCTION t110sub_y1(l_rva,p_argv5,p_argv2,p_rvu03_flag,p_argv6)
 DEFINE  l_rvb   RECORD LIKE rvb_file.*,
         l_factor1       LIKE ima_file.ima31_fac, #No.FUN-680136 DECIMAL(16,8)
         l_cnt           LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_sfa05         LIKE sfa_file.sfa05,
         l_sfa065        LIKE sfa_file.sfa065,
         l_rvb07         LIKE rvb_file.rvb07,
         l_sfb04         LIKE sfb_file.sfb04,    #
         l_sfb24         LIKE sfb_file.sfb24,    #No.B415 add
         l_pmh08         LIKE pmh_file.pmh08,    #
         l_pmn07         LIKE pmn_file.pmn07,    #採購單號
         l_pmn51         LIKE pmn_file.pmn51,
         l_pmn01         LIKE pmn_file.pmn01,    #採購單號
         l_pmn02         LIKE pmn_file.pmn02,    #項次
         l_pmn122        LIKE pmn_file.pmn122,   #專案號碼
         l_pmn09         LIKE pmn_file.pmn09,    #轉換因子
         l_pmn40         LIKE pmn_file.pmn40,    #會計科目
         l_pmn011        LIKE pmn_file.pmn011,   #性質
         l_pmm22         LIKE pmm_file.pmm22 ,   #
         l_ima25         LIKE ima_file.ima25,    #庫存單位
         l_ima86         LIKE ima_file.ima86,    #成本單位
         l_ima906        LIKE ima_file.ima906,   #No.FUN-540027
         l_code          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
         l_qc            LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
         l_ins_rvu       LIKE type_file.chr1,    # Prog. Version..: '5.30.24-17.04.13(01) #有免驗料,可直接入庫的資料設'Y' NO:7143
         l_fac           LIKE ima_file.ima31_fac, #No.FUN-680136 DEC(16,8)
         l_ima44         LIKE ima_file.ima44,
         l_ima55         LIKE ima_file.ima55
 DEFINE  l_msg           LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(100)
 DEFINE  l_pmm04         LIKE pmm_file.pmm04     #FUN-610040
 DEFINE  l_ima915        LIKE ima_file.ima915    #FUN-710060 add
 DEFINE  l_flag          LIKE type_file.num10    #FUN-810038
 DEFINE  l_rvbs06        LIKE rvbs_file.rvbs06   #No:FUN-840187
 DEFINE  l_rvbi          RECORD LIKE rvbi_file.* #FUN-810038
 DEFINE l_img09          LIKE img_file.img09  #No:FUN-850100
 DEFINE l_i              LIKE type_file.num5  #No:FUN-850100
 DEFINE l_pmm02   LIKE pmm_file.pmm02     #MOD-860146
 DEFINE l_type    LIKE type_file.chr1     #MOD-860146
 DEFINE l_pmn41   LIKE pmn_file.pmn41     #MOD-860146
 DEFINE l_pmn43   LIKE pmn_file.pmn43     #MOD-860146
 DEFINE l_ecm04   LIKE ecm_file.ecm04     #MOD-860146
 DEFINE l_pmn18   LIKE pmn_file.pmn18     #CHI-8C0017
 DEFINE l_pmn65   LIKE pmn_file.pmn65     #CHI-990025
 DEFINE l_pmn012  LIKE pmn_file.pmn012    #FUN-A60076 add 
 DEFINE l_ima918  LIKE ima_file.ima918
 DEFINE l_ima921  LIKE ima_file.ima921
 DEFINE l_ima930  LIKE ima_file.ima930    #DEV-D30040 add
 DEFINE l_rva     RECORD LIKE rva_file.*
 DEFINE p_argv5   LIKE type_file.chr1
 DEFINE p_argv2   LIKE rva_file.rva10
 DEFINE p_argv6   LIKE rva_file.rva00
 DEFINE p_rvu03_flag   LIKE type_file.chr1
 DEFINE l_forupd_sql STRING
 DEFINE l_rvu01   LIKE rvu_file.rvu01
 #FUN-A30072--begin--add-------
 DEFINE 
    sr RECORD
          pmn04   LIKE pmn_file.pmn04,
          pmm09   LIKE pmm_file.pmm09,
          pmm22   LIKE pmm_file.pmm22,
          pmm04   LIKE pmm_file.pmm04,
          pmn87   LIKE pmn_file.pmn87,
          pmm21   LIKE pmm_file.pmm21,
          pmm43   LIKE pmm_file.pmm43,
          pmn86   LIKE pmn_file.pmn86,
          pmm41   LIKE pmm_file.pmm41,
          pmm20   LIKE pmm_file.pmm20
     END RECORD
 DEFINE l_pmn123  LIKE pmn_file.pmn123   #FUN-D10004
 DEFINE l_n,i     LIKE type_file.num5
 DEFINE l_idd18_sum,l_i1    LIKE idd_file.idd18
 DEFINE l_rvbiicd03         LIKE rvbi_file.rvbiicd03
 DEFINE l_rvb10_a,l_rvb10   LIKE rvb_file.rvb10
 DEFINE l_rvb10t_a,l_rvb10t LIKE rvb_file.rvb10t
 DEFINE l_ecdicd01          LIKE ecd_file.ecdicd01
 DEFINE l_ica32             LIKE ica_file.ica32
 DEFINE l_idd DYNAMIC ARRAY OF RECORD
              icf05   LIKE icf_file.icf05,
              idd18   LIKE idd_file.idd18
        END RECORD
 #FUN-A30072--end--add---------
 DEFINE l_pmn73   LIKE pmn_file.pmn73,    #TQC-AC0257 add
        l_pmn74   LIKE pmn_file.pmn74     #TQC-AC0257 add
#DEFINE l_rvb90_fac LIKE rvb_file.rvb90   #CHI-C30064      #MOD-F90077 mark
 DEFINE l_rvb90_fac LIKE rvb_file.rvb90_fac                #MOD-F90077 add
 DEFINE l_sfb93     LIKE sfb_file.sfb93   #MOD-F50062 add
 DEFINE l_sfb39     LIKE sfb_file.sfb39   #MOD-FC0048 add

   LET l_qc = 'N'
   LET l_ins_rvu='N' #default可直接入庫碼設為'Y'
   DECLARE t110_y CURSOR FOR
     SELECT * FROM rvb_file WHERE rvb01=l_rva.rva01
   DECLARE t110_y_n CURSOR FOR  #NO:7143
     SELECT * FROM rvb_file
      WHERE rvb01=l_rva.rva01
        AND rvb39='N' #檢驗否='N'

   CALL s_showmsg_init()  
   FOREACH t110_y INTO l_rvb.*
      IF STATUS THEN
         LET g_success = 'N' 
         IF g_bgerr THEN
            CALL s_errmsg("","","foreach",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","foreach",1)
         END IF
         EXIT FOREACH
      END IF
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF

   #MOD-F50062 add --start--
  #LET l_sfb93 = ''  #MOD-F50079 mark
   LET l_sfb93 = 'N' #MOD-F50079
   IF l_rva.rva10 = 'SUB' THEN
      SELECT sfb93 INTO l_sfb93
        FROM sfb_file
       WHERE sfb01 = l_rvb.rvb34
   END IF

  #IF l_sfb93 <> 'Y' THEN #MOD-F50079 mark
   IF l_sfb93 = 'N' THEN  #MOD-F50079
   #MOD-F50062 add --end--

      #-----No:FUN-840187-----
      SELECT ima918,ima921,ima930 INTO l_ima918,l_ima921,l_ima930 #DEV-D30040 add ima930,l_ima930 
        FROM ima_file
       WHERE ima01 = l_rvb.rvb05
         AND imaacti = "Y"
      
      IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF  #DEV-D30040 add

      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         IF g_sma.sma90 = "Y" THEN 
             
            SELECT SUM(rvbs06) INTO l_rvbs06
              FROM rvbs_file
             WHERE rvbs00 = g_prog
               AND rvbs01 = l_rvb.rvb01
               AND rvbs02 = l_rvb.rvb02
               AND rvbs13 = 0  
               AND rvbs09 = 1
            
            IF cl_null(l_rvbs06) THEN
               LET l_rvbs06 = 0
            END IF
            
           #CHI-C30064---Start---add
            SELECT img09 INTO l_img09 FROM img_file
             WHERE img01=l_rvb.rvb05  AND img02=l_rvb.rvb36 
               AND img03=l_rvb.rvb37  AND img04=l_rvb.rvb38 
            CALL s_umfchk(l_rvb.rvb05,l_rvb.rvb90,l_img09) RETURNING l_cnt,l_rvb90_fac
            IF l_cnt = '1' THEN
               LET l_rvb90_fac = 1
            END IF             
           #CHI-C30064---End---add 
           #IF (l_rvb.rvb07 * l_rvb.rvb90_fac) <> l_rvbs06 THEN
           #確認時檢查，當條碼管理否(ima930) = 'Y'且批序號數量不為0(代表已有批序號資料)，則控卡批序號數量須等於單據數量  #DEV-D50004 add
            IF (l_ima930 = 'Y' and l_rvbs06 <> 0) OR l_ima930 = 'N' THEN  #DEV-D30040
               IF (l_rvb.rvb07 * l_rvb90_fac) <> l_rvbs06 THEN #CHI-C30064
                  LET g_success = "N"
                  CALL s_errmsg("","",l_rvb.rvb04,"aim-011",1)
                  CONTINUE FOREACH
               END IF
            END IF                                                        #DEV-D30040
         END IF
      END IF
   END IF #MOD-F50062 add

    IF s_industry('icd') THEN
        SELECT * INTO l_rvbi.*
          FROM rvbi_file
         WHERE rvbi01=l_rvb.rvb01
           AND rvbi02=l_rvb.rvb02
        #LET b_rvbi.* = l_rvbi.* #TQC-940066
        #判斷若為委外收貨單TKY,非最後一站的項次,不做收貨確認
        IF l_rvbi.rvbiicd13 = 'Y' THEN CONTINUE FOREACH END IF
    END IF

      LET l_pmm04 =''
      IF NOT cl_null(l_rvb.rvb04) THEN
         SELECT pmm04 INTO l_pmm04 FROM pmm_file   #採購單據日期
          WHERE pmm01 = l_rvb.rvb04
         IF STATUS OR l_pmm04 > l_rva.rva06 THEN
            #收貨日期不可小於採購單據日期
            LET g_success = 'N'
            IF g_bgerr THEN
               CALL s_errmsg("","",l_rvb.rvb04,"apm-413",1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","","apm-413","",l_rvb.rvb04,1)
               EXIT FOREACH
            END IF
         END IF
      END IF

      IF l_rva.rva10='SUB' THEN
        #SELECT sfb24 INTO l_sfb24 FROM sfb_file                     #MOD-FC0048 mark
         SELECT sfb24,sfb39 INTO l_sfb24,l_sfb39 FROM sfb_file       #MOD-FC0048 add
          WHERE sfb01 = l_rvb.rvb34

         SELECT COUNT(*) INTO l_cnt
           FROM sfa_file
          WHERE sfa01=l_rvb.rvb34 AND sfa05!=sfa065
          
         IF NOT s_industry('icd') THEN  #ICD之委外工單不發料也可收貨確認
           #IF l_cnt>0 THEN                                          #MOD-FC0048 mark
            IF l_cnt>0 AND l_sfb39 != '2' THEN                       #MOD-FC0048 add
               SELECT COUNT(*) INTO l_cnt FROM sfp_file,sfq_file
                WHERE sfp01 = sfq01
                  AND sfq02 = l_rvb.rvb34
                 #AND sfp06 = '1'          #FUN-C70014 mark
                  AND sfp06 IN ('1','D')   #FUN-C70014 add
                  AND sfp04 = 'Y'
               IF l_cnt = 0 AND p_argv5<>'1' THEN 
                  IF g_bgjob = 'N' OR cl_null(g_bgjob) THEN  #FUN-BB0164
                     CALL cl_getmsg('apm-002',g_lang) RETURNING l_msg
                     LET l_msg = l_rvb.rvb34 CLIPPED,l_msg
                     IF NOT cl_prompt(17,5,l_msg) THEN
                        LET g_success='N'
                        RETURN ''
                     END IF
                  END IF  #FUN-BB0164
               END IF
            END IF
         END IF

         SELECT sfb04 INTO l_sfb04 FROM sfb_file   #工單
          WHERE sfb01 = l_rvb.rvb34
         IF l_sfb04 = "8" THEN
            IF g_bgerr THEN
               CALL s_errmsg("","",l_rvb.rvb34,"asf-070",1)
            ELSE
               CALL cl_err3("","","","","asf-070","",l_rvb.rvb34,1)
            END IF
            LET g_success = 'N'
            RETURN ''
         END IF
 
         LET l_cnt = 0                  #MOD-G10124 add 
        #FUN-E50036 add---str------
        #收購性質為"SUB"廠外加工且為工單類別為"1"一般或"13"預測型不進入F.Q.C
        #SELECT COUNT(*)                #MOD-G10124 mark
         SELECT COUNT(*) INTO l_cnt     #MOD-G10124 add 
           FROM sfb_file
          WHERE sfb01 = l_rvb.rvb34
            AND (sfb02 = '1' OR sfb02 = '13')
        #IF SQLCA.SQLCODE = 100 THEN    #MOD-G10124 mark
         IF l_cnt = 0 THEN              #MOD-G10124 add
        #FUN-E50036 add---end------
            IF l_sfb24 ='N' OR l_sfb24 IS NULL THEN                            
               SELECT sfb04 INTO l_sfb04 FROM sfb_file 
                WHERE sfb01 = l_rvb.rvb34
               IF l_sfb04 < '6' THEN
                  CALL cl_msg("Update sfb_file ...")
                  UPDATE sfb_file SET sfb04 = '6'  #工單已完工,進入F.Q.C
                   WHERE sfb01 = l_rvb.rvb34
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                     IF g_bgerr THEN
                        CALL s_errmsg("sfb01",l_rvb.rvb34,"1.UPDATE fail sfb_file :",SQLCA.sqlcode,1)
                     ELSE
                        CALL cl_err3("upd","sfb_file",l_rvb.rvb34,"",SQLCA.sqlcode,"","1.UPDATE fail sfb_file :",1)
                     END IF
                     LET g_success = 'N'
                     RETURN ''
                  END IF
               END IF
               CALL s_updsfb117(l_rvb.rvb34)
               IF g_success='N' THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("","","2.UPDATE fail sfb_file :",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("","","","",SQLCA.sqlcode,"","2.UPDATE fail sfb_file :",1)
                  END IF
                  RETURN ''
               END IF
            END IF
         END IF  #FUN-E50036 add
      END IF
      IF p_argv6='1' THEN                               #FUN-940083--add
      #-->取採購單位(pmn07)與庫存單位(ima25)的轉換,且LOCK 此筆資料
         LET l_forupd_sql = "SELECT pmn09,pmn011,pmn40,pmn07",
                            "  FROM pmn_file",
                            " WHERE pmn01=? AND pmn02=? FOR UPDATE"
         LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
         DECLARE t110_pmn1 CURSOR FROM l_forupd_sql                 # LOCK CURSOR

        OPEN t110_pmn1 USING l_rvb.rvb04,l_rvb.rvb03
        IF STATUS THEN
           IF g_bgerr THEN
              CALL s_errmsg("","","OPEN t110_pmn1:",STATUS,1)
           ELSE
              CALL cl_err3("","","","",STATUS,"","OPEN t110_pmn1:",1)
           END IF
           CLOSE t110_pmn1
           LET g_success = 'N'   
           RETURN ''
        END IF
        FETCH t110_pmn1 INTO l_pmn09,l_pmn011,l_pmn40,l_pmn07  
        IF SQLCA.sqlcode THEN
           IF g_bgerr THEN
              CALL s_errmsg("","","fetch t110_pmn1:",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch t110_pmn1:",1)
           END IF
           LET g_success = 'N'
           RETURN ''
        END IF
      END IF

      IF s_industry('icd') THEN
         IF p_argv2='ICD' OR p_argv2='SUB' OR p_argv2='TAP' THEN   #FUN-B90012--add 'TAP'--
            #TQC-B80005 --START--
            SELECT * INTO l_rvbi.* FROM rvbi_file
             WHERE rvbi01 = l_rvb.rvb01 AND rvbi02 = l_rvb.rvb02
            #TQC-B80005 --END--
            CALL s_icdpost(0,l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,l_rvb.rvb38,
                           l_pmn07,l_rvb.rvb07,l_rvb.rvb01,l_rvb.rvb02,
                           l_rva.rva06,'Y','','',l_rvbi.rvbiicd16,l_rvbi.rvbiicd08,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
                 RETURNING l_flag
            IF l_flag = 0 THEN
               LET g_success = 'N'
               EXIT FOREACH
            END IF
           #FUN-A30072--begin--add---------------
            SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
             WHERE ecd01 = l_rvbi.rvbiicd03
            SELECT ica32 INTO l_ica32 FROM ica_file WHERE ica00='0'
            IF (l_ecdicd01='5' OR (l_ecdicd01='6' AND l_rvbi.rvbiicd13='N'))
                AND (l_ica32 = 'Y') THEN
              #SELECT pmn04,pmm09,pmm22,pmm04,pmn87,pmm21,pmm43,pmn86,pmm41,pmm20          #FUN-D10004 mark
               SELECT pmn04,pmm09,pmm22,pmm04,pmn87,pmm21,pmm43,pmn86,pmm41,pmm20,pmn123   #FUN-D10004 add
                #INTO sr.*                                                                 #FUN-D10004 mark
                 INTO sr.*,l_pmn123                                                        #FUN-D10004 add 
                 FROM pmn_file,pmm_file
                WHERE pmn01 = pmm01
                  AND pmn01 = l_rvb.rvb04
                  AND pmn02 = l_rvb.rvb03
               LET l_rvbiicd03 = l_rvbi.rvbiicd03
               IF cl_null(l_rvbiicd03) THEN LET l_rvbiicd03= ' ' END IF
               DECLARE t110_idd CURSOR FOR
                SELECT icf05,sum(idd18) 
                  FROM idd_file,icf_file,ima_file,imaicd_file
                 WHERE idd01=ima01 AND ima01=imaicd00
                   AND icf02=idd06
                   AND icf01=idd01
                   AND idd10 = l_rvb.rvb01
                   AND idd11 = l_rvb.rvb02
                 GROUP BY icf05
               LET l_n = 1
               LET l_idd18_sum = 0
               FOREACH t110_idd INTO l_idd[l_n].icf05,l_idd[l_n].idd18
                 IF SQLCA.sqlcode != 0 THEN                                                                                                 
                    CALL cl_err('t110_idd',SQLCA.sqlcode,1)                                                                             
                    EXIT FOREACH                                                                                                            
                 END IF
                 LET l_idd18_sum = l_idd18_sum + l_idd[l_n].idd18
                 LET l_n = l_n + 1
               END FOREACH
               LET l_rvb10 = 0  LET l_rvb10t = 0
               FOR i = 1 TO l_n - 1
                 CALL s_defprice_new_price(l_idd[i].icf05)
                 CALL s_defprice_new(sr.pmn04,sr.pmm09,sr.pmm22,sr.pmm04,
                                 sr.pmn87,l_rvbiicd03,sr.pmm21,sr.pmm43,"2",
                                #sr.pmn86,'',sr.pmm41,sr.pmm20,g_plant)            #FUN-D10004 mark
                                 sr.pmn86,'',sr.pmm41,sr.pmm20,g_plant,l_pmn123)   #FUN-D10004 add  
                 RETURNING l_rvb10_a,l_rvb10t_a,l_pmn73,l_pmn74   #TQC-AC0257 add l_pmn73,l_pmn74
                 CALL s_defprice_new_init()
                 LET l_i1 = l_idd[i].idd18/l_idd18_sum
                 LET l_rvb10 = l_rvb10+l_rvb10_a*l_i1
                 LET l_rvb10t = l_rvb10t+l_rvb10t_a*l_i1
               END FOR
               IF cl_null(l_rvb10) THEN LET l_rvb10 = 0 END IF
               IF cl_null(l_rvb10t) THEN LET l_rvb10t = 0 END IF
               UPDATE rvb_file SET rvb10=l_rvb10,
                                   rvb10t=l_rvb10t
                             WHERE rvb01 = l_rvb.rvb01
                               AND rvb02 = l_rvb.rvb02
           END IF
           #FUN-A30072--end--add-----------------
           #TQC-C30193 --START--
           
           #TQC-C30193 --END--
         END IF
      END IF

      IF l_rvb.rvb05[1,4] != 'MISC' THEN
         LET l_forupd_sql = "SELECT ima25,ima86 FROM ima_file",
                            " WHERE ima01=? FOR UPDATE"
         LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
         DECLARE t110_ima1  CURSOR FROM l_forupd_sql              # LOCK CURSOR

         OPEN t110_ima1 USING l_rvb.rvb05
         IF STATUS THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","OPEN t110_ima1:",STATUS,1)
            ELSE
               CALL cl_err3("","","","",STATUS,"","OPEN t110_ima1:",1)
            END IF
            CLOSE t110_ima1
            LET g_success = 'N'      
            RETURN ''
         END IF

         FETCH t110_ima1 INTO l_ima25,l_ima86 
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","fetch:",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","fetch:",1)
            END IF
            LET g_success = 'N'
            RETURN ''
         END IF

         CALL s_umfchk(l_rvb.rvb05,l_rvb.rvb90,l_ima25) RETURNING l_cnt,l_factor1
         IF l_cnt = 1 THEN
            IF g_bgerr THEN
              #CALL s_errmsg("","","pmn07/ima25: ","abm-731",1)                          #MOD-DB0134 mark
               CALL s_errmsg("rvb02,rvb05",l_rvb.rvb02||"/"||l_rvb.rvb05,"","abm-731",1) #MOD-DB0134 add
            ELSE
              #CALL cl_err3("","","","","abm-731","","pmn07/ima25: ",1)       #MOD-DB0134 mark
               CALL cl_err_msg("","apm1199",l_rvb.rvb02||"|"||l_rvb.rvb05,10) #MOD-DB0134 add 
            END IF
            LET g_success ='N'
            RETURN ''
         END IF
      END IF

      IF p_argv6='1' THEN               #FUN-940083--add
         #-->取專案編號
         SELECT pmn122 INTO l_pmn122 FROM pmn_file
          WHERE pmn01 = l_rvb.rvb04
            AND pmn02 = l_rvb.rvb03
      END IF                            #FUN-940083--add 
      
      #-->樣品不更新PO上的數量
      IF l_rvb.rvb35='N' THEN

         #-->(1-3)產生tlf_file
         IF l_rvb.rvb05[1,4] != 'MISC' THEN
            CALL cl_msg("Insert tlf_file ...")
            IF p_argv6='1' THEN
               CALL t110sub_log(1,0,l_rvb.*,l_pmn011,l_rva.rva10,l_pmn40,l_ima86,l_pmn122,
                                l_rva.rva05,l_rva.rva06,p_argv2,p_argv6)
            ELSE
               CALL t110sub_log(1,0,l_rvb.*,l_rva.rva10,l_rva.rva10,'',l_ima86,' ',
                                l_rva.rva05,l_rva.rva06,p_argv2,p_argv6)
            END IF
            
            SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=l_rvb.rvb05
            IF g_sma.sma115 = 'Y' AND l_ima906 MATCHES '[23]' THEN
               IF NOT cl_null(l_rvb.rvb83) THEN
                  IF NOT cl_null(l_rvb.rvb85) THEN
                     IF p_argv6='1' THEN
                        CALL t110sub_tlff(l_pmn011,l_ima86,l_pmn122,l_rvb.*,l_rvb.rvb83,l_rvb.rvb84,l_rvb.rvb85,'2',
                                          l_rva.rva05,l_rva.rva06)
                     ELSE
                        CALL t110sub_tlff(l_pmn011,l_ima86,' ',l_rvb.*,l_rvb.rvb83,l_rvb.rvb84,l_rvb.rvb85,'2',
                                          l_rva.rva05,l_rva.rva06)
                     END IF
                  END IF
               END IF
               IF l_ima906 <> '3' THEN
                  IF NOT cl_null(l_rvb.rvb80) THEN
                     IF NOT cl_null(l_rvb.rvb82) THEN 
                        IF p_argv6='1' THEN
                           CALL t110sub_tlff(l_pmn011,l_ima86,l_pmn122,l_rvb.*,l_rvb.rvb80,l_rvb.rvb81,l_rvb.rvb82,'1',
                                             l_rva.rva05,l_rva.rva06)
                        ELSE
                           CALL t110sub_tlff(l_pmn011,l_ima86,' ',l_rvb.*,l_rvb.rvb80,l_rvb.rvb81,l_rvb.rvb82,'1',
                                             l_rva.rva05,l_rva.rva06)
                        END IF
                     END IF
                  END IF
               END IF
            END IF
         END IF
      END IF

     IF p_argv6 ='1' THEN                           #FUN-940083--add
        #IF g_sma.sma63='1' THEN #料件供應商控制方式,1: 需作料件供應商管制
        #                        #                   2: 不作料件供應商管制
        #料件供應商控制方式: 0.不管制、1.請購單需管制、2.採購單需管制、3.二者皆需管制
         SELECT ima915 INTO l_ima915 FROM ima_file
          WHERE ima01=l_rvb.rvb05
         #IF l_ima915='2' OR l_ima915='3' THEN                    #20180919
         IF l_ima915='2' OR l_ima915='3' OR (l_ima915='0' AND g_plant[1,2]='TY' ) THEN     #20180919
            SELECT pmm02,pmm22 INTO l_pmm02,l_pmm22 FROM pmm_file 
             WHERE pmm01=l_rvb.rvb04
            
          #SELECT pmn41,pmn43,pmn18,pmn012 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn012 FROM pmn_file    #FUN-A60076 add pmn012,l_pmn012   #FUN-D10004 mark
           SELECT pmn41,pmn43,pmn18,pmn012,pmn123 INTO l_pmn41,l_pmn43,l_pmn18,l_pmn012,l_pmn123 FROM pmn_file                      #FUN-D10004 add
            WHERE pmn01 = l_rvb.rvb04 AND pmn02 = l_rvb.rvb03          
           IF l_pmm02='SUB'  THEN  
              LET l_type='2'
              IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
              LET l_ecm04=' '
           ELSE
              IF NOT cl_null(l_pmn18) THEN
                 SELECT sgm04 INTO l_ecm04 FROM sgm_file
                  WHERE sgm01=l_pmn18
                    AND sgm02=l_pmn41
                    AND sgm03=l_pmn43
                    AND sgm012 = l_pmn012                           #FUN-A60076 add by vealxu   
              ELSE
                 SELECT ecm04 INTO l_ecm04 FROM ecm_file 
                  WHERE ecm01=l_pmn41
                    AND ecm03=l_pmn43
                    AND ecm012=l_pmn012                             #FUN-A60076 add by huangtao
              END IF
           END IF
         ELSE
            LET l_type='1'
            LET l_ecm04=' '
         END IF  
         IF cl_null(l_pmn123) THEN LET l_pmn123 = ' ' END IF        #FUN-D10004 add
         SELECT pmh08 INTO l_pmh08 FROM pmh_file
          WHERE pmh01=l_rvb.rvb05
            AND pmh02=l_rva.rva05
            AND pmh07=l_pmn123                                      #FUN-D10004 add
            AND pmh13=l_pmm22
            AND pmh21= l_ecm04 
            AND pmh22= l_type  
            AND pmh23 = ' '  
            AND pmhacti = 'Y'  

         IF cl_null(l_pmh08)  THEN
            ##----- 20180918 add by momo (S)當無廠商料件資料時再取一次料件主檔
            #LET l_pmh08 = 'N'
            SELECT ima24 INTO l_pmh08 FROM ima_file
             WHERE ima01=l_rvb.rvb05
            IF cl_null(l_pmh08) THEN
               LET l_pmh08 = 'N'
            END IF
            ##----- 20180918 add by momo (E)
         END IF

         IF l_rvb.rvb05[1,4] = 'MISC' THEN
            LET l_pmh08='N'
         END IF
       ELSE
          SELECT ima24 INTO l_pmh08 FROM ima_file
           WHERE ima01=l_rvb.rvb05
          IF cl_null(l_pmh08) THEN
             LET l_pmh08 = 'N'
          END IF

          IF l_rvb.rvb05[1,4] = 'MISC' THEN
             LET l_pmh08='N'
          END IF
       END IF
      ELSE
         LET l_pmm22=' '
         LET l_type ='1'
         LET l_ecm04=' '
         LET l_pmh08=l_rvb.rvb39
      END IF

      IF l_pmh08='N' OR     #免驗料
         (g_sma.sma886[6,6]='N' AND g_sma.sma886[8,8]='N') OR #視同免驗
         l_rvb.rvb19='2' THEN #委外代買料
         UPDATE rvb_file SET rvb33 = l_rvb.rvb07, #實收數量
                             rvb31 = l_rvb.rvb07,  
                             rvb331 = l_rvb.rvb82, #實收數量
                             rvb332 = l_rvb.rvb85, #實收數量
                             rvb39 = 'N',         #檢驗否    #MARK 改在單身產生時即應將是否檢驗的資料帶入，不需等到確認後再帶出。   #MOD-940078
                             rvb40 = g_today,     #檢驗日期
                             rvb41 = 'OK'         #檢驗結果
          WHERE rvb01 = l_rvb.rvb01
            AND rvb02 = l_rvb.rvb02
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               LET g_showmsg = l_rvb.rvb01,"/",l_rvb.rvb02
               CALL s_errmsg("rvb01,rvb02",g_showmsg,"UPDATE rvb_file",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","rvb_file",l_rvb.rvb01,l_rvb.rvb02,SQLCA.sqlcode,"","UPDATE rvb_file",1)
            END IF
            LET g_success = 'N'
            RETURN ''
         END IF
         LET l_ins_rvu='Y' #因為免驗料,所以可直接入庫碼設為'Y'
      END IF
       
      IF p_argv6 = '1' THEN
         #check收貨和品管是否要檢查承認文號
         #No:7631 要驗料件才需check
         IF l_pmh08 = 'Y' THEN
            CALL s_chk_apprl(l_rvb.rvb05,l_rva.rva05,l_rvb.rvb04)
            RETURNING l_code,l_msg #No:7625 所傳的參數寫顛倒
            #需依照參數『收貨單無承認文號時0.不處理　1.警告　2.拒絕』的設定處理
            CASE l_code
               WHEN 1      #警告
                  CALL cl_err('',l_msg,1)
               WHEN 2      #拒
                  CALL cl_err('',l_msg,1)
                  LET g_success = 'N'
                  RETURN ''
               OTHERWISE
                  EXIT CASE
            END CASE
         END IF
      END IF

      CLOSE t110_pmn1
      CLOSE t110_ima1
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

   #-->不為 'MISC' 且 為免檢者須check img_file(因免檢可直接入庫)
   IF l_ins_rvu='Y' THEN
      FOREACH t110_y_n INTO l_rvb.*
         IF g_success="N" THEN
            LET g_totsuccess="N"
            LET g_success="Y"
         END IF
         #TQC-B80005 --START--
         IF s_industry('icd') THEN
            SELECT * INTO l_rvbi.* FROM rvbi_file
             WHERE rvbi01 = l_rvb.rvb01 AND rvbi02 = l_rvb.rvb02 
         END IF 
         IF l_rvbi.rvbiicd13 = 'Y' THEN 
            CONTINUE FOREACH
         END IF    
         #TQC-B80005 --END--
        IF g_sma.sma886[7,7] = 'Y'  THEN   #MOD-9A0176
         IF l_rvb.rvb05[1,4] <>'MISC' THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt
              FROM img_file
             WHERE img01 = l_rvb.rvb05
               AND img02 = l_rvb.rvb36
               AND img03 = l_rvb.rvb37
               AND img04 = l_rvb.rvb38
            IF l_cnt=0 AND ((l_rva.rva10<>'SUB') OR (l_rva.rva10='SUB' AND l_sfb24='N')) THEN
               LET g_success='N'
               IF g_bgerr THEN
                  CALL s_errmsg("","",l_rvb.rvb05,"apm-259",1)
               ELSE
                  CALL cl_err3("","","","","apm-259","",l_rvb.rvb05,1)
               END IF
               RETURN ''
            END IF
        END IF
       END IF 
      END FOREACH
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF

      IF STATUS THEN
         LET g_success='N'
         IF g_bgerr THEN
            CALL s_errmsg("","","foreach:",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","foreach:",1)
         END IF
         RETURN ''
      END IF
   END IF

   #-->免檢驗表示全部可直接入庫
   IF l_ins_rvu = 'Y' AND g_sma.sma886[7]='Y' THEN
     #IF l_rva.rva06 > g_today THEN           #MOD-B50165 #MOD-BA0157 mark 
        LET p_rvu03_flag = '1'   #TQC-AB0392 
        CALL t110sub_insrvu(l_rva.*,p_rvu03_flag,p_argv2,p_argv6) RETURNING l_rvu01
        LET p_rvu03_flag = '0'   #TQC-AB0392
#MOD-BA0157 ----- mark start -----
##MOD-B50165 --begin--
#     ELSE
#        CALL t110sub_insrvu(l_rva.*,p_rvu03_flag,p_argv2,p_argv6) RETURNING l_rvu01
#     END IF 
##MOD-B50165 --end--
#MOD-BA0157 ----- mark end -----
      IF g_success='N' THEN
         RETURN ''
      END IF

      IF s_industry('icd') THEN
         CALL t110sub_ind_icd_upd_rvb87(l_rva.rva01,p_argv2) #更新計價數量
      END IF
      RETURN l_rvu01
   END IF
   RETURN ''
END FUNCTION

FUNCTION t110sub_log(p_stdc,p_reason,p_rvb,p_pmn011,p_rva10,p_pmn40,
                     p_ima86,p_pmn122,p_rva05,p_rva06,p_argv2,p_argv6)
   DEFINE
      p_stdc          LIKE type_file.num5,        #是否需取得標準成本
      p_reason        LIKE type_file.num5,        #是否需取得異動原因
      p_code          LIKE type_file.chr4,        
      p_qty           LIKE img_file.img10,        #異動數量
      p_rvb           RECORD LIKE rvb_file.*,
      p_pmn011        LIKE pmn_file.pmn011,
      p_pmn40         LIKE pmn_file.pmn40,        #會計科目
      p_rva10         LIKE rva_file.rva10,
      p_ima86         LIKE ima_file.ima86,        #成本單位
      p_pmn122        LIKE pmn_file.pmn122,       #專案號碼
      l_sta           LIKE type_file.num5,        
      x_sfb24         LIKE sfb_file.sfb24,  
      l_pmn65         LIKE pmn_file.pmn65         
   DEFINE
        l_img09       LIKE img_file.img01,
        l_pmn09       LIKE pmn_file.pmn09,
        l_ec_sw       LIKE type_file.chr1,
        l_cnt         LIKE type_file.num5,
        p_rva05       LIKE rva_file.rva05,
        p_rva06       LIKE rva_file.rva06,
        p_argv2       LIKE rva_file.rva10,
        p_argv6       LIKE rva_file.rva00  

   LET l_ec_sw = 'N'
   IF p_argv2 ='SUB' THEN
      LET x_sfb24=''
      SELECT sfb24 INTO x_sfb24
        FROM sfb_file
       WHERE sfb01 = p_rvb.rvb34
      IF x_sfb24 IS NOT NULL AND x_sfb24='Y' THEN
         LET l_ec_sw='Y'
      END IF
   END IF

   LET g_tlf.tlf01=p_rvb.rvb05          #異動料件編號
   CASE p_rva10
      WHEN 'REG ' LET g_tlf.tlf02=11    #資料來源
      WHEN 'EXP ' LET g_tlf.tlf02=14
      WHEN 'CAP ' LET g_tlf.tlf02=16
      WHEN 'SUB '
           SELECT pmn65 INTO l_pmn65
             FROM pmn_file
            WHERE pmn01 = p_rvb.rvb04
              AND pmn02 = p_rvb.rvb03
           IF l_pmn65 = '2' THEN
               LET g_tlf.tlf02=18      #委外代買
           ELSE
               LET g_tlf.tlf02=60
           END IF
      OTHERWISE LET g_tlf.tlf02 = 10
   END CASE
   LET g_tlf.tlf020=g_plant             #工廠編號
   LET g_tlf.tlf021=''                  #倉庫別
   LET g_tlf.tlf022=''                  #儲位別
   LET g_tlf.tlf023=''
   LET g_tlf.tlf024=''
   LET g_tlf.tlf025=''
   IF p_argv6 ='1' THEN
      IF p_pmn011='SUB' THEN
         LET g_tlf.tlf026=p_rvb.rvb34
         LET g_tlf.tlf027=p_rvb.rvb03
         LET g_tlf.tlf03=25                 #F.Q.C.
         LET g_tlf.tlf13='asft6001'         #異動命令代號
      ELSE
         LET g_tlf.tlf026=p_rvb.rvb04        #單據編號(採購單)
         LET g_tlf.tlf027=p_rvb.rvb03        #項次(採購項次)
         LET g_tlf.tlf03 =20                 #資料目的為檢驗區
         LET g_tlf.tlf13='apmt1101'          #異動命令代號
      END IF
   ELSE
      LET g_tlf.tlf03 =20                    #資料目的為檢驗區          
      LET g_tlf.tlf13='apmt1101'             #異動命令代號
   END IF   
   LET g_tlf.tlf030=g_plant             #工廠編號
   LET g_tlf.tlf031=p_rvb.rvb36         #倉庫別
   LET g_tlf.tlf032=p_rvb.rvb37         #儲位別
   LET g_tlf.tlf033=p_rvb.rvb38         #入庫批號
   LET g_tlf.tlf034=''                  #庫存數量
   LET g_tlf.tlf035=''                  #異動後庫存單位
   LET g_tlf.tlf036=p_rvb.rvb01         #驗收單單據編號
   LET g_tlf.tlf037=p_rvb.rvb02         #單據項次
   LET g_tlf.tlf04=''                   #工作中心
   LET g_tlf.tlf05=' '                  #作業編號
   LET g_tlf.tlf06=p_rva06          #異動日期=驗收單之收貨日期
   LET g_tlf.tlf07=g_today              #異動數量=驗收單之實收數量
   LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user               #產生人
   LET g_tlf.tlf10=p_rvb.rvb07          #異動數量=驗收單之實收數量
   LET g_tlf.tlf11=p_rvb.rvb90          #異動單位=收貨單位
   LET g_tlf.tlf12=p_rvb.rvb90_fac      #收料單位/料件庫存轉換率
   LET g_tlf.tlf14=' '                  #異動原因代碼
   LET g_tlf.tlf17=''                   #非庫存性料件編號
   CALL s_imaQOH(p_rvb.rvb05) RETURNING g_tlf.tlf18 #異動後總庫存量
   LET g_tlf.tlf19=p_rva05              #廠商編號
   IF p_argv6 = '1' THEN
      LET g_tlf.tlf20=p_pmn122          #專案號碼
   ELSE
      LET g_tlf.tlf20= ' '              #專案號碼
   END IF
   LET g_tlf.tlf61=p_ima86              #成本單位
   LET g_tlf.tlf62=p_rvb.rvb04          #單據編號(採購單)
   LET g_tlf.tlf63=p_rvb.rvb03          #項次(採購項次)
   LET g_tlf.tlf64=p_rvb.rvb25          #手冊 no.A050
   LET g_tlf.tlf930=p_rvb.rvb930        #成本中心 #FUN-670051
   IF p_argv6 !='1' THEN
      SELECT pmn122,pmn96,pmn97,pmn98
        INTO g_tlf.tlf20,g_tlf.tlf41,g_tlf.tlf42,g_tlf.tlf43
        FROM pmn_file
       WHERE pmn01 = p_rvb.rvb04
         AND pmn02 = p_rvb.rvb03
      IF SQLCA.sqlcode THEN
        LET g_tlf.tlf20 = ' '
        LET g_tlf.tlf41 = ' '
        LET g_tlf.tlf42 = ' '
        LET g_tlf.tlf43 = ' '
      END IF
   END IF
   CALL s_tlf(p_stdc,p_reason)

END FUNCTION

FUNCTION t110sub_tlff(p_pmn011,p_ima86,p_pmn122,p_rvb,p_unit,p_fac,p_qty,p_flag,p_rva05,p_rva06)
   DEFINE
      p_rvb           RECORD LIKE rvb_file.*,
      p_unit          LIKE img_file.img09,
      p_fac           LIKE img_file.img21,
      p_qty           LIKE img_file.img10,
      p_pmn011        LIKE pmn_file.pmn011,
      p_ima86         LIKE ima_file.ima86,    #成本單位
      p_pmn122        LIKE pmn_file.pmn122,   #專案號碼
      p_flag          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
      p_ac,l_sta      LIKE type_file.num5,    #No.FUN-680136 SMALLINT
      l_pmn65         LIKE pmn_file.pmn65,    #No:7692
      p_rva05         LIKE rva_file.rva05,
      p_rva06         LIKE rva_file.rva06

   LET g_tlff.tlff01=p_rvb.rvb05          #異動料件編號
   CASE p_pmn011
      WHEN 'REG ' LET g_tlff.tlff02=11    #資料來源
      WHEN 'EXP ' LET g_tlff.tlff02=14
      WHEN 'CAP ' LET g_tlff.tlff02=16
      WHEN 'SUB '
           SELECT pmn65 INTO l_pmn65
             FROM pmn_file
            WHERE pmn01 = p_rvb.rvb04
              AND pmn02 = p_rvb.rvb03
           IF l_pmn65 = '2' THEN
               LET g_tlff.tlff02=18      #委外代買
           ELSE
               LET g_tlff.tlff02=60
           END IF
      OTHERWISE LET g_tlff.tlff02 = 10
   END CASE
   LET g_tlff.tlff020=g_plant             #工廠編號
   LET g_tlff.tlff021=''                  #倉庫別
   LET g_tlff.tlff022=''                  #儲位別
   LET g_tlff.tlff023=''
   LET g_tlff.tlff024=''
   LET g_tlff.tlff025=''

   IF p_pmn011='SUB' THEN
      LET g_tlff.tlff026=p_rvb.rvb34
      LET g_tlff.tlff027=p_rvb.rvb03
      LET g_tlff.tlff03=25                 #F.Q.C.
      LET g_tlff.tlff13='asft6001'            #異動命令代號
   ELSE
      LET g_tlff.tlff026=p_rvb.rvb04        #單據編號(採購單)
      LET g_tlff.tlff027=p_rvb.rvb03        #項次(採購項次)
      LET g_tlff.tlff03 =20                  #資料目的為檢驗區
      LET g_tlff.tlff13='apmt1101'           #異動命令代號
   END IF

   LET g_tlff.tlff030=g_plant             #工廠編號
   LET g_tlff.tlff031=p_rvb.rvb36         #倉庫別
   LET g_tlff.tlff032=p_rvb.rvb37         #儲位別
   LET g_tlff.tlff033=p_rvb.rvb38         #入庫批號
   LET g_tlff.tlff034=''                  #庫存數量
   LET g_tlff.tlff035=''                  #異動後庫存單位
   LET g_tlff.tlff036=p_rvb.rvb01         #驗收單單據編號
   LET g_tlff.tlff037=p_rvb.rvb02         #單據項次
   LET g_tlff.tlff04=''                   #工作中心
   LET g_tlff.tlff05=' '                  #作業編號
   LET g_tlff.tlff06=p_rva06          #異動日期=驗收單之收貨日期
   LET g_tlff.tlff07=g_today              #異動數量=驗收單之實收數量
   LET g_tlff.tlff08=TIME                 #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user               #產生人
   LET g_tlff.tlff10=p_qty                #異動數量=驗收單之實收數量
   LET g_tlff.tlff11=p_unit               #異動單位=採購單位
   LET g_tlff.tlff12=p_fac                #收料單位/料件庫存轉換率
   LET g_tlff.tlff14=' '                  #異動原因代碼
   LET g_tlff.tlff17=''                   #非庫存性料件編號

   CALL s_imaQOH(p_rvb.rvb05) RETURNING g_tlff.tlff18 #異動後總庫存量

   LET g_tlff.tlff19=p_rva05          #廠商編號
   LET g_tlff.tlff20=p_pmn122             #專案號碼
   LET g_tlff.tlff61=p_ima86              #成本單位
   LET g_tlff.tlff62=p_rvb.rvb04          #單據編號(採購單)
   LET g_tlff.tlff63=p_rvb.rvb03          #項次(採購項次)
   LET g_tlff.tlff64=p_rvb.rvb25          #手冊 no.A050
   LET g_tlff.tlff930=p_rvb.rvb930        #成本中心 #FUN-670051

   IF cl_null(p_rvb.rvb85) OR p_rvb.rvb85 = 0 THEN
     CALL s_tlff(p_flag,NULL)
   ELSE
     CALL s_tlff(p_flag,p_rvb.rvb83)
   END IF

END FUNCTION

FUNCTION t110sub_insrvu(l_rva,p_rvu03_flag,p_argv2,p_argv6)
  DEFINE l_rvb     RECORD LIKE rvb_file.*,
         l_rvu     RECORD LIKE rvu_file.*,
         l_rvv     RECORD LIKE rvv_file.*,
         la_rvbi   RECORD LIKE rvbi_file.*,
         l_rva     RECORD LIKE rva_file.*,
         l_smy57   LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(01)
         l_t       LIKE smy_file.smyslip      #No.FUN-680136 VARCHAR(5)  #No.FUN-540027
  DEFINE li_result LIKE type_file.num5      #No.FUN-540027 #No.FUN-680136 SMALLINT
  DEFINE l_ima44   LIKE ima_file.ima44      #No.FUN-540027
  DEFINE l_rvvi    RECORD LIKE rvvi_file.*    #No.FUN-7B0018
  DEFINE l_idd     RECORD LIKE idd_file.*    #MOD-840263
  DEFINE l_ida     RECORD LIKE ida_file.*    #MOD-840263
  DEFINE l_sql     STRING  #No:FUN-810036
  DEFINE l_rvbs    RECORD LIKE rvbs_file.*  #No:FUN-810036
  DEFINE l_pmm43   LIKE pmm_file.pmm43     #CHI-830033
  DEFINE l_cnt     LIKE type_file.num5         #MOD-840263
  DEFINE l_i       LIKE type_file.num5
  DEFINE p_rvu03_flag   LIKE type_file.chr1
  DEFINE l_img09_t LIKE img_file.img09
  DEFINE l_ima906  LIKE ima_file.ima906
  DEFINE l_ima907  LIKE ima_file.ima907
  DEFINE l_flag    LIKE type_file.chr1
  DEFINE l_gec07   LIKE gec_file.gec07
  DEFINE p_argv2   LIKE rva_file.rva10
  DEFINE p_argv6   LIKE rva_file.rva00
  DEFINE l_yy      LIKE type_file.num5
  DEFINE l_mm      LIKE type_file.num5
  DEFINE l_n       LIKE type_file.num5
  DEFINE l_gec05   LIKE gec_file.gec05      #MOD-A80052
  DEFINE l_rvw06f  LIKE rvw_file.rvw06f     #MOD-A80052
  DEFINE l_gen03   LIKE gen_file.gen03      #MOD-B80087 add
#FUN-A60035 ---MARK BEGIN
  DEFINE l_prog    LIKE type_file.chr20 #No.FUN-A50054  #FUN-E30046--remark
#  DEFINE l_ata  RECORD LIKE ata_file.*  #No.FUN-A50054
#FUN-A60035 ---MARK END
#FUN-B90101--add--begin--
  DEFINE l_rvvslk  RECORD LIKE rvvslk_file.*,
         l_rvbslk  RECORD LIKE rvbslk_file.*,
         l_rvv31   LIKE rvv_file.rvv31,
         l_rvv02   LIKE rvv_file.rvv02
#FUN-B90101--add--end-- 
 DEFINE l_ima24   LIKE ima_file.ima24           #TQC-CA0049 add
 DEFINE l_sum_rvbs06 LIKE rvbs_file.rvbs06      #TQC-CA0049 add
 
   #-->判斷此驗收單是否已產生入庫
   LET l_i = 0
   SELECT COUNT(*) INTO l_i FROM rvu_file WHERE rvu02=l_rva.rva01
      AND rvuconf !='X'
   IF l_i>0 THEN LET g_success = 'N' RETURN '' END IF
   INITIALIZE l_rvu.* TO NULL
   IF g_azw.azw04='2' THEN
      IF l_rva.rva29 = '1' THEN
         LET l_rvu.rvu00='1'
      ELSE
         LET l_rvu.rvu00='4'
      END IF
   ELSE
      LET l_rvu.rvu00='1'
   END IF 
   LET l_rvu.rvu00='1'                          #異動類別
   LET l_rvu.rvu02=l_rva.rva01                  #驗收單號  
   IF p_rvu03_flag = '1' THEN
      LET l_rvu.rvu03=l_rva.rva06                      #異動日期   
   ELSE
      LET l_rvu.rvu03=g_today                      #異動日期   
   END IF
                                                                                                         
   #若入庫日小於收貨日                                                                                                              
   IF l_rvu.rvu03<l_rva.rva06 THEN                                                                                                  
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg("","",l_rvu.rvu03,"apm-316",1)                                                                               
      ELSE                                                                                                                          
         CALL cl_err3("","","","","apm-316","",l_rvu.rvu03,1)                                                                       
      END IF                                                                                                                        
      LET g_success='N'                                                                                                             
      RETURN ''                                                                                                                       
   END IF                                                                                                                           
 
   #日期<=關帳日期
   IF NOT cl_null(g_sma.sma53) AND l_rvu.rvu03 <= g_sma.sma53 THEN
      IF g_bgerr THEN
         CALL s_errmsg("","",l_rvu.rvu03,"mfg9999",1)
      ELSE
         CALL cl_err3("","","","","mfg9999","",l_rvu.rvu03,1)
      END IF
      LET g_success='N'
      RETURN ''
   END IF
   CALL s_yp(l_rvu.rvu03) RETURNING l_yy,l_mm
   IF (l_yy*12+l_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
      CALL cl_err(l_rvu.rvu03,'mfg6091',1)
      LET g_success='N'
      RETURN ''
   END IF

   LET l_t = s_get_doc_no(l_rva.rva01) 
  #FUN-BB0164 mod str---
  #SELECT smy52,smy57[3,3],smyapr              #FUN-A60009 add:,smyapr
  #  INTO l_rvu.rvu01,l_smy57,l_rvu.rvumksg    #FUN-A60009 add:,l_rvu.rvumksg
  #  FROM smy_file WHERE smyslip=l_t
   SELECT smy52,smy57[3,3]
     INTO l_rvu.rvu01,l_smy57
     FROM smy_file WHERE smyslip=l_t
  #FUN-BB0164 mod end---
   IF l_rvu.rvu01 IS NULL THEN
      IF g_bgerr THEN
         CALL s_errmsg("","","smy52=NULL","apm-272",1)
      ELSE
         CALL cl_err3("","","","","apm-272","","smy52=NULL",1)
      END IF
      LET g_success = 'N'
      RETURN ''
   END IF
   SELECT COUNT(*) INTO l_n FROM smy_file WHERE smyslip = l_rvu.rvu01
   IF l_n IS NULL THEN LET l_n = 0 END IF
   IF l_n = 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg("smyslip",l_rvu.rvu01,"sel smy_file","apm-068",1)
      ELSE 
         CALL cl_err(l_rvu.rvu01,'apm-068',1)
      END IF
      RETURN '' #MOD-B60200 add ''
   END IF
   IF l_smy57='Y' THEN
      LET l_rvu.rvu01[g_no_sp-1,g_no_ep]=l_rva.rva01[g_no_sp-1,g_no_ep]      #入庫單號
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM rvu_file WHERE rvu01=l_rvu.rvu01
         #AND rvuconf != 'X'   #MOD-A90197 
      IF l_cnt > 0 THEN
        LET l_t = l_rvu.rvu01[1,g_doc_len]
        CALL s_auto_assign_no("apm",l_t,l_rva.rva06,"","","","","","")
             RETURNING li_result,l_rvu.rvu01
        IF (NOT li_result) THEN
            LET g_success='N'
            RETURN ''
        END IF
      END IF
   ELSE
         LET l_t = l_rvu.rvu01[1,g_doc_len] 
         CALL s_auto_assign_no("apm",l_t,l_rvu.rvu03,"","","","","","")
              RETURNING li_result,l_rvu.rvu01
         IF (NOT li_result) THEN
             LET g_success='N'
             RETURN ''
         END IF
   END IF
 #FUN-BB0164 mark str---
 ##MOD-B70150 -- begin --
 # SELECT smyapr INTO l_rvu.rvumksg
 #   FROM smy_file WHERE smyslip=l_t
 ##MOD-B70150 -- end --
 #FUN-BB0164 mark end---

   LET l_rvu.rvu04=l_rva.rva05                  #廠商編號
   SELECT pmc03 INTO l_rvu.rvu05 FROM pmc_file  #簡稱
   WHERE pmc01=l_rva.rva05

#  LET l_rvu.rvu06=g_grup        #部門    #MOD-B80087 mark
#MOD-B80087 -- begin --
   SELECT gen03 INTO l_gen03 FROM gen_file
      WHERE gen01 = l_rva.rva33
   LET l_rvu.rvu06=l_gen03
#MOD-B80087 -- end --

  #LET l_rvu.rvu07=g_user        #人員    #TQC-A70105 mark
   LET l_rvu.rvu07=l_rva.rva33   #人員    #TQC-A70105 add
   LET l_rvu.rvu08=l_rva.rva10   #性質
  #FUN-E30046----add--begin----------------
   IF g_sma.sma150='Y' AND s_industry('slk') THEN
      IF l_rvu.rvu08 = 'SUB' THEN
         LET l_prog = 'apmt730_slk'
      ELSE
         LET l_prog = 'apmt720_slk'   
      END IF
   END IF
  #FUN-E30046----add--end------------------ 
   LET l_rvu.rvu09=NULL
   LET l_rvu.rvuconf='N'         #確認碼
   LET l_rvu.rvuacti='Y'
   LET l_rvu.rvu20='N'           #三角貿易拋轉否 no.4475
   LET l_rvu.rvuuser=l_rva.rvauser
   LET l_rvu.rvugrup=l_rva.rvagrup
   LET l_rvu.rvumodu=' '
   LET l_rvu.rvudate=g_today
   LET l_rvu.rvu21 = l_rva.rva29  
   LET l_rvu.rvuplant = l_rva.rvaplant
   LET l_rvu.rvulegal = l_rva.rvalegal
   LET l_rvu.rvu22 = l_rva.rva30
   LET l_rvu.rvu23 = l_rva.rva31
   #LET l_rvu.rvu900 = '0'       #CHI-E40020 mark
   LET l_rvu.rvumksg = 'N'       #是否簽核  #FUN-A60009 mark  #FUN-BB0164
   LET l_rvu.rvu17='0'           #簽核狀況  #FUN-A60009 add
   LET l_rvu.rvucrat = g_today
   LET l_rvu.rvupos = 'N'
   IF l_rvu.rvu21 IS NULL THEN LET l_rvu.rvu21 = '1' END IF
   LET l_rvu.rvuplant = g_plant 
   LET l_rvu.rvulegal = g_legal 
   LET l_rvu.rvuoriu = g_user
   LET l_rvu.rvuorig = g_grup
   LET l_rvu.rvu27 = '1'         #TQC-B60065
   #No.MOD-B70240  --Begin
   LET l_rvu.rvu111 = l_rva.rva111
   LET l_rvu.rvu112 = l_rva.rva112
   LET l_rvu.rvu115 = l_rva.rva115
   LET l_rvu.rvu12  = l_rva.rva116
   LET l_rvu.rvu113 = l_rva.rva113
   LET l_rvu.rvu114 = l_rva.rva114
   #No.MOD-B70240  --End
   
   INSERT INTO rvu_file VALUES (l_rvu.*)
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg("rvu01",l_rvu.rvu01,"ins rvu:2",STATUS,1)
      ELSE
         CALL cl_err3("ins","rvu_file",l_rvu.rvu01,"",STATUS,"","ins rvu:2",1)
      END IF
      LET g_success='N'
      RETURN ''
   END IF
   #-->單身
   DECLARE t110_y1 CURSOR WITH HOLD FOR
      SELECT * FROM rvb_file
       WHERE rvb01=l_rva.rva01
         AND rvb39='N' #檢驗否為'N'
         ORDER BY rvb02      #FUN-B90101 

   FOREACH t110_y1 INTO l_rvb.*
     IF s_industry('icd') THEN
         SELECT * INTO la_rvbi.* FROM rvbi_file
          WHERE rvbi01=l_rvb.rvb01  
            AND rvbi02=l_rvb.rvb02  
     END IF
 
      LET l_rvv.rvv01=l_rvu.rvu01     #單號
      SELECT MAX(rvv02)+1 INTO l_rvv.rvv02 FROM rvv_file   #序號
       WHERE rvv01=l_rvu.rvu01
      IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02=1 END IF
      LET l_rvv.rvv03='1'             #異動類別
      LET l_rvv.rvv04=l_rva.rva01     #驗收單號
      LET l_rvv.rvv05=l_rvb.rvb02     #驗收項次
      LET l_rvv.rvv06=l_rva.rva05     #廠商
      IF p_rvu03_flag = '1' THEN
         LET l_rvv.rvv09=l_rva.rva06                      #異動日期   
      ELSE
         LET l_rvv.rvv09=g_today                      #異動日期   
      END IF
      LET l_rvv.rvv17=l_rvb.rvb07     #數量
      IF NOT cl_null(l_rvb.rvb33) THEN LET l_rvv.rvv17=l_rvb.rvb33 END IF
      IF NOT cl_null(l_rvb.rvb331) THEN LET l_rvv.rvv82=l_rvb.rvb331 END IF
      IF NOT cl_null(l_rvb.rvb332) THEN LET l_rvv.rvv85=l_rvb.rvb332 END IF
      IF g_sma.sma115 = 'Y' THEN
         LET l_rvv.rvv80=l_rvb.rvb80
         LET l_rvv.rvv81=l_rvb.rvb81
         LET l_rvv.rvv82=l_rvb.rvb82
         LET l_rvv.rvv83=l_rvb.rvb83
         LET l_rvv.rvv84=l_rvb.rvb84
         LET l_rvv.rvv85=l_rvb.rvb85
      END IF
      LET l_rvv.rvv86=l_rvb.rvb86
      LET l_rvv.rvv87=l_rvb.rvb87
      LET l_rvv.rvv18=l_rvb.rvb34     #工單編號
      LET l_rvv.rvv23=0               #已請款匹配數量
      LET l_rvv.rvv88=0               #No.TQC-7B0083
      LET l_rvv.rvv24=NULL
      LET l_rvv.rvv89=l_rvb.rvb89     #VMI收貨否
      IF cl_null(l_rvv.rvv89) THEN LET l_rvv.rvv89= 'N'  END IF  #MOD-D80123 add
      LET l_rvv.rvv25=l_rvb.rvb35     #樣品
      LET l_rvv.rvv26=NULL           
      LET l_rvv.rvv31=l_rvb.rvb05     #料號
      ##----- 20180508 mark by momo (S)
      #IF l_rvb.rvb05[1,4]='MISC' THEN      #品名
      #   LET l_rvv.rvv031 = l_rvb.rvb051
      #ELSE
      #   SELECT ima02 INTO l_rvv.rvv031 FROM ima_file
      #    WHERE ima01=l_rvb.rvb05
      #END IF
      ##----- 20180508 mark by momo (E)
      LET l_rvv.rvv031 = l_rvb.rvb051   #20180508 modify
      SELECT ima44 INTO l_ima44 FROM ima_file WHERE ima01=l_rvv.rvv31
      LET l_rvv.rvv32=l_rvb.rvb36  
      LET l_rvv.rvv33=l_rvb.rvb37  
      LET l_rvv.rvv34=l_rvb.rvb38  
      IF cl_null(l_rvv.rvv32) THEN LET l_rvv.rvv32=' ' END IF
      IF cl_null(l_rvv.rvv33) THEN LET l_rvv.rvv33=' ' END IF
      IF cl_null(l_rvv.rvv34) THEN LET l_rvv.rvv34=' ' END IF

      LET l_rvv.rvv35 = l_rvb.rvb90
      LET l_rvv.rvv35_fac = l_rvb.rvb90_fac
      IF NOT cl_null(l_rvv.rvv32) AND l_rvv.rvv32 <> 'MISC' THEN   #TQC-C30193
         SELECT img09 INTO l_img09_t FROM img_file
          WHERE img01=l_rvv.rvv31 AND img02=l_rvv.rvv32
            AND img03=l_rvv.rvv33 AND img04=l_rvv.rvv34

         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_img09_t)
              RETURNING l_i,l_rvv.rvv35_fac

         IF l_i = 1 THEN
            IF g_bgerr THEN
              #CALL s_errmsg("","","rvv35/img09: ","abm-731",1)                          #MOD-DB0134 mark
               CALL s_errmsg("rvb02,rvb05",l_rvv.rvv04||"/"||l_rvv.rvv05,"","abm-731",1) #MOD-DB0134 add
            ELSE
              #CALL cl_err3("","","","","abm-731","","rvv35/img09: ",1)       #MOD-DB0134 mark
               CALL cl_err_msg("","apm1199",l_rvv.rvv04||"|"||l_rvv.rvv05,10) #MOD-DB0134 add 
            END IF
            LET g_success ='N'
            RETURN ''
         END IF
         LET l_ima906 = NULL
         LET l_ima907 = NULL

         SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
          WHERE ima01=l_rvv.rvv31

         IF g_sma.sma115 = 'Y' AND l_ima906 MATCHES '[23]' THEN
            IF NOT cl_null(l_rvv.rvv83) THEN
               CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv83) RETURNING l_flag

               IF l_flag = 1 THEN
                  CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                                  l_rvv.rvv33,l_rvv.rvv34,
                                  l_rvv.rvv83,l_rvv.rvv84,
                                  l_rvv.rvv01,l_rvv.rvv02,0) RETURNING l_flag
                  IF l_flag = 1 THEN
                     LET g_success = 'N'
                     RETURN ''
                  END IF
               END IF
               CALL s_du_umfchk(l_rvv.rvv31,'','','',
                                l_ima44,l_rvv.rvv83,l_ima906)
                    RETURNING g_errno,l_rvv.rvv84
               IF NOT cl_null(g_errno) THEN
                  IF g_bgerr THEN
                    #CALL s_errmsg("","","rvv83/ima44: ","abm-731",1)                          #MOD-DB0134 mark
                     CALL s_errmsg("rvb02,rvb05",l_rvv.rvv04||"/"||l_rvv.rvv05,"","abm-731",1) #MOD-DB0134 add
                  ELSE
                    #CALL cl_err3("","","","","abm-731","","rvv83/ima44: ",1)       #MOD-DB0134 mark
                     CALL cl_err_msg("","apm1199",l_rvv.rvv04||"|"||l_rvv.rvv05,10) #MOD-DB0134 add 
                  END IF
                  LET g_success = 'N'
                  RETURN ''
               END IF
            END IF

            IF NOT cl_null(l_rvv.rvv80) AND l_ima906 = '2' THEN
               CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv80) RETURNING l_flag
               IF l_flag = 1 THEN
                  CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                                  l_rvv.rvv33,l_rvv.rvv34,
                                  l_rvv.rvv80,l_rvv.rvv81,
                                  l_rvv.rvv01,l_rvv.rvv02,0) RETURNING l_flag
                  IF l_flag = 1 THEN
                     LET g_success = 'N'
                     RETURN ''
                  END IF
               END IF
               CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima44)
                    RETURNING l_i,l_rvv.rvv81
               IF l_i = 1 THEN
                  IF g_bgerr THEN
                    #CALL s_errmsg("","","rvv80/ima44: ","abm-731",1)                          #MOD-DB0134 mark
                     CALL s_errmsg("rvb02,rvb05",l_rvv.rvv04||"/"||l_rvv.rvv05,"","abm-731",1) #MOD-DB0134 add
                  ELSE
                    #CALL cl_err3("","","","",SQLCA.sqlcode,"","rvv80/ima44: ",1)   #MOD-DB0134 mark
                     CALL cl_err_msg("","apm1199",l_rvv.rvv04||"|"||l_rvv.rvv05,10) #MOD-DB0134 add 
                  END IF
                  LET g_success = 'N'
                  RETURN ''
               END IF
            END IF

            IF l_ima906 = '3' THEN
               IF l_rvv.rvv85 <> 0 THEN
                  LET l_rvv.rvv84=l_rvv.rvv82/l_rvv.rvv85
               ELSE
                  LET l_rvv.rvv84=0
               END IF
            END IF
         END IF

            IF g_sma.sma115='Y' THEN
               CALL t110sub_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,l_rvv.rvv85,
                                   l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv86,0,'')
                    RETURNING l_rvv.rvv87
            ELSE
               CALL t110sub_set_rvv87(l_rvv.rvv31,1,0,1,l_rvv.rvv17,
                                   l_rvv.rvv86,1,l_rvv.rvv35)
                    RETURNING l_rvv.rvv87
            END IF
      END IF

      LET l_rvv.rvv36=l_rvb.rvb04     #採購單號
      LET l_rvv.rvv37=l_rvb.rvb03     #採購單序號
      LET l_rvv.rvv38=l_rvb.rvb10
      LET l_rvv.rvv38t=l_rvb.rvb10t  
    
     #FUN-F30020 add---str---
      SELECT pmn101 INTO l_rvv.rvv90
        FROM pmn_file
       WHERE pmn01 = l_rvv.rvv36
         AND pmn02 = l_rvv.rvv37
      IF SQLCA.sqlcode THEN
         LET l_rvv.rvv90 = NULL
      END IF
     #FUN-F30020 add---end---

      IF cl_null(l_rvv.rvv86) THEN
         LET l_rvv.rvv86 = l_rvv.rvv35
         LET l_rvv.rvv87 = l_rvv.rvv17
      ELSE
       #入庫量=實收量,收貨計價數量給予入庫數量,避免計價數量在來源是調整後的值
       #而在入庫時又重推值
        IF l_rvv.rvv17=l_rvb.rvb07  THEN
           LET l_rvv.rvv87=l_rvb.rvb87
        END IF 
       END IF

      LET l_rvv.rvv39=l_rvv.rvv87*l_rvv.rvv38
      LET l_rvv.rvv39t=l_rvv.rvv87*l_rvv.rvv38t  
      LET l_rvv.rvv41=l_rvb.rvb25     #手冊編號 A050
      LET t_azi04='' 
      IF p_argv6='1' THEN
         SELECT azi04 INTO t_azi04 
           FROM pmm_file,azi_file
          WHERE pmm22=azi01
            AND pmm01 = l_rvv.rvv36 #採購單號
            AND pmm18 <> 'X'
      ELSE
         SELECT azi04 INTO t_azi04 
           FROM azi_file
          WHERE azi01=l_rva.rva113
      END IF

      IF cl_null(t_azi04) THEN 
         LET t_azi04=0  
      END IF

      CALL cl_digcut(l_rvv.rvv39,t_azi04) RETURNING l_rvv.rvv39   
      CALL cl_digcut(l_rvv.rvv39t,t_azi04) RETURNING l_rvv.rvv39t 

      IF p_argv6='1' THEN
         #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
        #SELECT gec07,pmm43 INTO l_gec07,l_pmm43 FROM gec_file,pmm_file                     #MOD-A80052 mark
         SELECT gec05,gec07,pmm43 INTO l_gec05,l_gec07,l_pmm43 FROM gec_file,pmm_file       #MOD-A80052
          WHERE gec01 = pmm21
            AND pmm01 = l_rvv.rvv36
         IF SQLCA.SQLCODE = 100 THEN
           #CALL cl_err('','mfg3192',0) #MOD-D90171 mark
            CALL cl_err('','mfg3044',0) #MOD-D90171 add
            LET g_success = 'N'
            RETURN ''
         END IF 
         IF l_gec07='Y' THEN
           #LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_pmm43/100)     #MOD-A80052 mark
           #LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)      #MOD-A80052 mark 
           #-MOD-A80052-add-
            #IF l_gec05 = 'T' THEN
            IF l_gec05  MATCHES '[AT]' THEN  #FUN-D10128   
               LET l_rvv.rvv38 = l_rvv.rvv38t * (1 - l_pmm43/100) #TQC-C30225 add
               LET l_rvv.rvv38 = cl_digcut(l_rvv.rvv38 , t_azi03) #TQC-C30225 add
               LET l_rvw06f = l_rvv.rvv39t * (l_pmm43/100)
               LET l_rvw06f = cl_digcut(l_rvw06f , t_azi04)
               LET l_rvv.rvv39 = l_rvv.rvv39t - l_rvw06f 
               LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
            ELSE
               LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_pmm43/100)
               LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
            END IF 
           #-MOD-A80052-end-
         ELSE
            LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + l_pmm43/100)
            LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , t_azi04)  
         END IF
      ELSE
         #不使用單價*數量=金額,改以金額回推稅率,以避免小數位差的問題
         SELECT gec07 INTO l_gec07 FROM gec_file
          WHERE gec01 = l_rva.rva115
         IF SQLCA.SQLCODE = 100 THEN
           #CALL cl_err('','mfg3192',0) #MOD-D90171 mark
            CALL cl_err('','mfg3044',0) #MOD-D90171 add
            LET g_success = 'N'
            RETURN '' #MOD-B60200 add ''
         END IF
         IF l_gec07 = 'Y' THEN
            LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_rva.rva116/100)
            LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)
         ELSE
            LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + l_rva.rva116/100)
            LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , t_azi04)
         END IF
      END IF
      #MOD-EC0005 add str
      IF l_rvv.rvv25 = 'Y' THEN
         LET l_rvv.rvv38 = 0
         LET l_rvv.rvv38t = 0
         LET l_rvv.rvv39 = 0
         LET l_rvv.rvv39t = 0
      END IF
      #MOD-EC0005 add end

      LET l_rvv.rvv40 = 'N'      # (default 為非沖暫估)
      LET l_rvv.rvv930=l_rvb.rvb930  
      IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF
      LET l_rvv.rvv88 = 0 
      LET l_rvv.rvv10 = l_rvb.rvb42
      LET l_rvv.rvv11 = l_rvb.rvb43
      LET l_rvv.rvv12 = l_rvb.rvb44
      LET l_rvv.rvv13 = l_rvb.rvb45
      LET l_rvv.rvvplant = l_rva.rvaplant
      LET l_rvv.rvvlegal = l_rva.rvalegal
      IF l_rvv.rvv10 IS NULL THEN LET l_rvv.rvv10 = '1' END IF
      LET l_rvv.rvvplant = g_plant 
      LET l_rvv.rvvlegal = g_legal
      LET l_rvv.rvv919 = l_rvb.rvb919      #FUN-A90059 add
      LET l_rvv.rvv22 = l_rvb.rvb22    #FUN-BB0001 add 
      #FUN-CB0087---add---str---
      IF g_aza.aza115 = 'Y' THEN
         CALL s_reason_code(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu.rvu07,l_rvu.rvu06) RETURNING l_rvv.rvv26
         IF cl_null(l_rvv.rvv26) THEN
            CALL cl_err('','aim-425',1)
            LET g_success = 'N'
            RETURN ''
         END IF
      END IF
      #FUN-CB0087---add---end---
      INSERT INTO rvv_file VALUES (l_rvv.*)
      IF STATUS THEN
         IF g_bgerr THEN
            LET g_showmsg = l_rvv.rvv01,"/",l_rvv.rvv02
            CALL s_errmsg("rvv01,rvv02",g_showmsg,"i rvv:",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","rvv_file",l_rvv.rvv01,l_rvv.rvv02,STATUS,"","i rvv:",1)
         END IF
         LET g_success = 'N'
         RETURN ''
      END IF
#FUN-D90015 ---------- add ------------ begin ---------------
      IF g_sma.sma150='Y' AND s_industry('slk') THEN
         LET l_sql = " INSERT INTO rvvc_file   ",
                     " SELECT '",l_rvv.rvv01,"',",l_rvv.rvv02,", rvbc03,  ",
                     "        rvbc04,rvbc05,rvbc06  ",
                     "   FROM rvbc_file ",
                     "  WHERE rvbc01='",l_rvu.rvu02,"' AND rvbc02 = ",l_rvv.rvv05," "
         PREPARE t110_slk_rvvc FROM l_sql
         EXECUTE t110_slk_rvvc
         #同步新增至rvbs_file
         LET l_sql = "  INSERT INTO rvbs_file ",
                     "  SELECT '",l_prog,"','",l_rvv.rvv01,"',",l_rvv.rvv02,",rvvc05,rvvc04, ",     #FUN-E30046--modify apmt720_slk 替換成l_prog
                    #"         '",g_today,"',rvvc06,'','",' ',"','",l_rvv.rvv31,"',rvvc03,1, ",            #CHI-E80020 mark
                     "         '",g_today,"',rvvc06*rvv35_fac,'','",' ',"','",l_rvv.rvv31,"',rvvc03,1, ",  #CHI-E80020 add      
                     "         0,0,0,0,'",g_plant,"','",g_legal,"' ",
                    #"    FROM rvvc_file ",             #CHI-E80020 mark
                     "    FROM rvvc_file,rvv_file ",    #CHI-E80020 add
                     "   WHERE rvvc01 = '",l_rvv.rvv01,"' AND rvvc02 = '",l_rvv.rvv02,"' ",
                     "     AND rvv01 = rvvc01 AND rvv02 = rvvc02 "            #CHI-E80020 add
         PREPARE t110_slk_rvbs2 FROM l_sql
         EXECUTE t110_slk_rvbs2
      END IF
#FUN-D90015 ---------- add ------------ end -----------------

#FUN-A60035 ---MARK BEGIN
#    #No.FUN-A50054 -BEGIN-----
#     IF s_industry('slk') THEN
#       CASE
#        WHEN l_rva.rva10 = 'SUB' AND l_rvu.rvu00 = '1'
#           LET l_prog = 'apmt730'
#        WHEN l_rva.rva10 = 'SUB' AND l_rvu.rvu00 = '2'
#           LET l_prog = 'apmt731'
#        WHEN l_rva.rva10 = 'TAP' AND l_rvu.rvu00 = '1'
#           LET l_prog = 'apmt740'
#        WHEN l_rva.rva10 = 'TAP' AND l_rvu.rvu00 = '2'
#           LET l_prog = 'apmt741'
#        WHEN l_rvu.rvu00 = '1'
#           LET l_prog = 'apmt720'
#        WHEN l_rvu.rvu00 = '2'
#           LET l_prog = 'apmt721'
#       END CASE
#       SELECT * INTO l_ata.* FROM ata_file
#        WHERE ata00 = g_prog
#          AND ata01 = l_rva.rva01
#          AND ata03 = l_rvb.rvb02
#       LET l_ata.ata00 = l_prog
#       LET l_ata.ata01 = l_rvv.rvv01
#       INSERT INTO ata_file VALUES(l_ata.*)
#       IF STATUS THEN
#        IF g_bgerr THEN
#           LET g_showmsg = l_ata.ata01,"/",l_ata.ata02
#           CALL s_errmsg("ata01,ata02",g_showmsg,"i ata:",SQLCA.sqlcode,1)
#        ELSE
#           CALL cl_err3("ins","ata_file",l_ata.ata01,l_ata.ata02,STATUS,"","i ata:",1)
#        END IF
#        LET g_success='N'
#       END IF
#    END IF
#   #No.FUN-A50054 -END-------
#FUN-A60035 ---MARK END
      IF NOT s_industry('std') THEN
         INITIALIZE l_rvvi.* TO NULL
      END IF
      IF s_industry('icd') THEN
        LET l_rvvi.rvviicd07 = la_rvbi.rvbiicd13  #委外TKY非最終站否
        LET l_rvvi.rvviicd03 = la_rvbi.rvbiicd14  #母體料號
        LET l_rvvi.rvviicd05 = la_rvbi.rvbiicd16  #母批
        IF p_argv2 = 'SUB' THEN
           LET l_rvvi.rvviicd01 = la_rvbi.rvbiicd03  #作業編號
           LET l_rvvi.rvviicd02 = la_rvbi.rvbiicd08  #Date Code
           LET l_rvvi.rvviicd04 = la_rvbi.rvbiicd15  #產品型號
           LET l_rvvi.rvviicd06 = la_rvbi.rvbiicd11  #Tape Reel
        
           #判斷
           #若是產生入庫資料,則入庫異動數量必須等於,
           #    該收貨單刻號明細入庫否='Y'的總異動數量
           #若是產生驗退資料,則驗退異動數量必須等於,
           #    該收貨單刻號明細入庫否='N'的總異動數量
           IF l_rvvi.rvviicd07 ='N' OR cl_null(l_rvvi.rvviicd07) THEN #委外TKY,非最終站不檢查
              CALL t110sub_ind_icd_chk_icdin_yn(l_rvv.*,'1')  #免檢料入庫,第二參數皆為'1'
              IF g_success = 'N' THEN
                 RETURN ''
              END IF
           END IF
        END IF
       END IF

      #IF NOT s_industry('std') AND g_sma.sma150 = 'N' THEN     #TQC-E30007 mark  #FUN-D90015 add sma150
       IF NOT s_industry('std') THEN                            #TQC-E30007
          LET l_rvvi.rvvi01 = l_rvv.rvv01
          LET l_rvvi.rvvi02 = l_rvv.rvv02
        # IF NOT s_ins_rvvi(l_rvvi.*,'') THEN
          IF NOT s_ins_rvvi(l_rvvi.*,g_plant) THEN #No.FUN-A50054
             LET g_success = 'N'
             RETURN ''
          END IF
       END IF
      IF s_industry('icd') THEN 
      #將收貨單的"刻號/BIN資料已過帳資料"帶入入庫單
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM idd_file 
                                   WHERE idd10=l_rvv.rvv04
                                     AND idd11=l_rvv.rvv05
         IF l_cnt>0 THEN
            DECLARE sel_idd_2 CURSOR FOR           
              SELECT * FROM idd_file               
                      WHERE idd10=l_rvv.rvv04
                        AND idd11=l_rvv.rvv05
            FOREACH sel_idd_2 INTO l_idd.*         #No:MOD-890023 add
               INITIALIZE l_ida.* TO NULL
               LET l_ida.ida01 = l_rvv.rvv31    #料號            
               LET l_ida.ida02 = l_rvv.rvv32    #倉庫            
               LET l_ida.ida03 = l_rvv.rvv33    #儲位            
               LET l_ida.ida04 = l_rvv.rvv34    #批號            
               LET l_ida.ida05 = l_idd.idd05    #刻號            
               LET l_ida.ida06 = l_idd.idd06    #BIN             
               LET l_ida.ida07 = l_rvv.rvv01    #單據編號        
               LET l_ida.ida08 = l_rvv.rvv02    #單據項次        
               LET l_ida.ida09 = l_idd.idd08    #異動日期        
               LET l_ida.ida10 = l_idd.idd13    #實收數量        
               LET l_ida.ida11 = l_idd.idd26    #不良數量        
               LET l_ida.ida12 = l_idd.idd27    #報廢數量        
               LET l_ida.ida13 = l_idd.idd07    #單位            
               LET l_ida.ida14 = l_idd.idd15    #母體料號        
               LET l_ida.ida15 = l_idd.idd16    #母批            
               LET l_ida.ida16 = l_idd.idd17    #DATECODE        
               LET l_ida.ida17 = l_idd.idd18    #DIE 數          
               LET l_ida.ida18 = l_idd.idd19    #YIELD           
               LET l_ida.ida19 = l_idd.idd20    #TEST #          
               LET l_ida.ida20 = l_idd.idd21    #DEDUCT          
               LET l_ida.ida21 = l_idd.idd22    #PASS BIN        
               LET l_ida.ida22 = l_idd.idd23    #接單料號        
               LET l_ida.ida27 = l_idd.idd28    #轉入否          
               LET l_ida.ida28 = '1'            #異動別(出入庫別)
               LET l_ida.ida29 = l_idd.idd25    #備註            
               LET l_ida.ida26 = l_idd.idd24    #轉入否            
               LET l_ida.ida30 = l_rvb.rvb01    #來源單號
               LET l_ida.ida31 = l_rvb.rvb02    #來源項次
               LET l_ida.idaplant = g_plant 
               LET l_ida.idalegal = g_legal 

              INSERT INTO ida_file VALUES(l_ida.*) 
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err('ins ida',SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 RETURN ''
              END IF
            END FOREACH      #No:MOD-890023 add
         END IF
      END IF

      #帶入批/序號資料
     #IF g_sma.sma90 = "Y" THEN                          #FUN-E20026 mark
      IF g_sma.sma90 = "Y" AND g_sma.sma150 = 'N' THEN   #FUN-E20026
         LET l_sql = "SELECT * FROM rvbs_file",
                     " WHERE rvbs00 = '",g_prog,"'",
                     "   AND rvbs01 = '",l_rvv.rvv04,"'",
                     "   AND rvbs02 = ",l_rvv.rvv05,
                     "   AND rvbs09 = 1",
                     "   AND rvbs13 = 0"  

         PREPARE t110_rvbs2 FROM l_sql
         
         DECLARE rvbs_curs2 CURSOR FOR t110_rvbs2
         
         FOREACH rvbs_curs2 INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('foreach rvbs:',STATUS,1)
               EXIT FOREACH
            END IF
#TQC-CA0049 -------------------- add ------------------ begin #判斷對應的批序號質量檢驗是否通過審核
         SELECT ima24 INTO l_ima24 FROM ima_file WHERE ima01 = l_rvbs.rvbs021
         IF l_ima24 = 'Y' AND g_sma.sma886[6,6] = 'Y' THEN
            SELECT SUM(rvbs06) INTO l_sum_rvbs06 FROM rvbs_file,qcs_file
             WHERE qcs01 = rvbs01
               AND qcs02 = rvbs02
               AND qcs05 = rvbs13
               AND rvbs00 = 'aqct110'
               AND rvbs01 = l_rvbs.rvbs01
               AND rvbs02 = l_rvbs.rvbs02
               AND rvbs022 = l_rvbs.rvbs022
               AND rvbs09 = l_rvbs.rvbs09
               AND qcs14 = 'Y'
               AND qcs09 = '1'
            LET l_rvbs.rvbs06 = l_sum_rvbs06
            IF cl_null(l_rvbs.rvbs06) THEN LET l_rvbs.rvbs06 = 0 END IF
            IF l_rvbs.rvbs06 = 0 THEN CONTINUE FOREACH END IF
            LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs.rvbs11
         END IF
#TQC-CA0049 -------------------- add ------------------ end
         
            IF l_rva.rva10='SUB' THEN
               IF NOT s_industry('icd') THEN
                  LET l_rvbs.rvbs00 = "apmt730"
               ELSE
                  LET l_rvbs.rvbs00 = "apmt730_icd"  #CHI-920064                        
               END IF
            ELSE
               IF l_rva.rva10='TAP' THEN  
                  IF NOT s_industry('icd') THEN
                     LET l_rvbs.rvbs00 = "apmt740"
                  ELSE
                     LET l_rvbs.rvbs00 = "apmt740_icd" 
                  END IF
               ELSE
                  IF NOT s_industry('icd') THEN
                     LET l_rvbs.rvbs00 = "apmt720"
                  ELSE
                    LET l_rvbs.rvbs00 = "apmt720_icd"  
                  END IF
               END IF
           END IF
            LET l_rvbs.rvbs01 = l_rvv.rvv01
            LET l_rvbs.rvbs02 = l_rvv.rvv02 
         
            LET l_rvbs.rvbs10 = 0
         
            LET l_rvbs.rvbs11 = 0
         
            LET l_rvbs.rvbs12 = 0
         
            LET l_rvbs.rvbs13 = 0  
            
            LET l_rvbs.rvbsplant = g_plant 
            LET l_rvbs.rvbslegal = g_legal
         
            INSERT INTO rvbs_file VALUES(l_rvbs.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1) 
               LET g_success = "N"
               CONTINUE FOREACH
            END IF
         
         END FOREACH
      END IF 
  END FOREACH
#FUN-B90101--add--begin--
# IF s_industry("slk") THEN    #TQC-C20117--mark
  IF s_industry("slk") AND g_azw.azw04='2'   THEN      #TQC-C20117--add
     LET l_rvvslk.rvvslk01 = l_rvu.rvu01

     DECLARE t110_g_rvvslk CURSOR FOR SELECT rvbslk01,rvbslk02,rvbslk05,rvbslk36,rvbslk37,rvbslk38,
                                             rvbslk90,1,rvbslk04,rvbslk03,rvbslk930,rvbslk42,
                                             rvbslk43,rvbslk10,rvbslk10t
                                        FROM rvbslk_file
                                        WHERE rvbslk01=l_rvu.rvu02
                                        ORDER BY rvbslk02     
  
     FOREACH t110_g_rvvslk INTO l_rvvslk.rvvslk04,l_rvvslk.rvvslk05,l_rvvslk.rvvslk31,
                                l_rvvslk.rvvslk32,l_rvvslk.rvvslk33,l_rvvslk.rvvslk34,
                                l_rvvslk.rvvslk35,l_rvvslk.rvvslk35_fac,l_rvvslk.rvvslk36,
                                l_rvvslk.rvvslk37,l_rvvslk.rvvslk930,l_rvvslk.rvvslk10,
                                l_rvvslk.rvvslk11,l_rvvslk.rvvslk38,l_rvvslk.rvvslk38t
  
        SELECT MAX(rvvslk02)+1 INTO l_rvvslk.rvvslk02 FROM rvvslk_file WHERE rvvslk01=l_rvvslk.rvvslk01
        IF cl_null(l_rvvslk.rvvslk02) THEN
           LET l_rvvslk.rvvslk02=1
        END IF
        SELECT ima02 INTO l_rvvslk.rvvslk031 FROM ima_file WHERE ima01=l_rvvslk.rvvslk31
        LET l_rvvslk.rvvslk03= '1'
        SELECT SUM(rvv17),SUM(rvv39),SUM(rvv39t)
          INTO l_rvvslk.rvvslk17,l_rvvslk.rvvslk39,l_rvvslk.rvvslk39t
          FROM rvv_file,rvvi_file,rvb_file,rvbi_file
         WHERE rvv01=rvvi01
           AND rvv02=rvvi02
           AND rvb01=rvbi01
           AND rvb02=rvbi02
           AND rvv04=rvb01
           AND rvv05=rvb02
           AND rvv01=l_rvu.rvu01
           AND rvv04=l_rvvslk.rvvslk04
           AND rvbislk02=l_rvvslk.rvvslk05
  
        IF cl_null(l_rvvslk.rvvslk17) THEN
           CONTINUE FOREACH
        END IF
        LET l_rvvslk.rvvslk39 = cl_digcut(l_rvvslk.rvvslk39,t_azi04)
        LET l_rvvslk.rvvslk39t= cl_digcut(l_rvvslk.rvvslk39t,t_azi04)
        LET l_rvvslk.rvvslkplant=l_rvu.rvuplant
        LET l_rvvslk.rvvslklegal=l_rvu.rvulegal
        INSERT INTO rvvslk_file VALUES(l_rvvslk.*)
        IF STATUS THEN
           CALL cl_err3("ins","rvvslk_file","","",SQLCA.sqlcode,"","ins rvvslk",1)
           LET g_success = "N"
           EXIT FOREACH
        ELSE
           UPDATE rvvi_file SET rvvislk01=l_rvvslk.rvvslk31,rvvislk02=l_rvvslk.rvvslk02
             WHERE rvvi01=l_rvu.rvu01
               AND rvvi02 IN (SELECT rvv02 FROM rvv_file,rvb_file,rvbi_file
                               WHERE rvv01=l_rvu.rvu01
                                 AND rvv04=rvb01
                                 AND rvv05=rvb02
                                 AND rvb01=rvbi01
                                 AND rvb02=rvbi02
                                 AND rvb01=l_rvvslk.rvvslk04
                                 AND rvbislk02=l_rvvslk.rvvslk05)
  
           IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("upd","rvvi_file","","",SQLCA.sqlcode,"","",1)
              LET g_success = "N"
              EXIT FOREACH
           END IF
        END IF
  
     END FOREACH   
  END IF
#FUN-B90101--add--end---
  RETURN l_rvu.rvu01
END FUNCTION

#判斷
#若是產生入庫資料,則入庫異動數量必須等於,
#    該收貨單刻號明細入庫否='Y'的總異動數量
#若是產生驗退資料,則驗退異動數量必須等於,
#    該收貨單刻號明細入庫否='N'的總異動數量
FUNCTION t110sub_ind_icd_chk_icdin_yn(l_rvv,p_rvu00)
   DEFINE p_rvu00       LIKE rvu_file.rvu00,
          l_idd13       LIKE idd_file.idd13,
          l_idd07       LIKE idd_file.idd07,
          #l_imaicd04    LIKE imaicd_file.imaicd04,   #FUN-BA0051 mark
          #l_imaicd08    LIKE imaicd_file.imaicd08,   #FUN-BA0051 mark
          l_rvv17       LIKE rvv_file.rvv17,
          l_fac         LIKE rvv_file.rvv35
   DEFINE l_rvv         RECORD LIKE rvv_file.*
   DEFINE l_i           LIKE type_file.num5
   DEFINE l_msg         LIKE ze_file.ze03
   DEFINE l_imaicd04    LIKE imaicd_file.imaicd04  #料件狀態   #TQC-C50062 add

   #FUN-BA0051 --START mark-- 
   #LET l_imaicd04 =  NULL
   #LET l_imaicd08 = NULL
   ##取得料件狀態,是否展明細資訊
   #SELECT imaicd04,imaicd08 INTO l_imaicd04,l_imaicd08
   #   FROM imaicd_file
   #  WHERE imaicd00 = l_rvv.rvv31
   #IF l_imaicd04 MATCHES '[0124]' AND l_imaicd08 = 'Y' THEN
   #FUN-BA0051 --END mark--
   IF s_icdbin(l_rvv.rvv31) THEN   #FUN-BA0051
      IF p_rvu00 = '1' THEN LET p_rvu00 = 'Y' END IF  #入庫
      IF p_rvu00 = '2' THEN LET p_rvu00 = 'N' END IF  #驗退
      SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file  #TQC-C50062 add
       WHERE imaicd00 = l_rvv.rvv31                     #TQC-C50062 add
      #若為產生入庫資料,則取得該收貨單刻號明細入庫否='Y'的總異動數量
      #若為產生驗退資料,則取得該收貨單刻號明細入庫否='N'的總異動數量
     #str TQC-C50062 add
      IF l_imaicd04 = '2' THEN   #CP
        #SELECT SUM(idd13),idd07 INTO l_idd13,l_idd07              #TQC-C50056 mark
         SELECT SUM(idd13)+SUM(idd26),idd07 INTO l_idd13,l_idd07   #TQC-C50056
           FROM idd_file 
          WHERE idd10 = l_rvv.rvv04  #收貨單號
            AND idd11 = l_rvv.rvv05  #收貨項次
            AND idd24 = 'Y' #收貨時無法決定是否入庫  p_rvu00      #入庫否
          GROUP BY idd07 
      ELSE
     #end TQC-C50062 add
         SELECT SUM(idd13),idd07 INTO l_idd13,l_idd07
            FROM idd_file
           WHERE idd10 = l_rvv.rvv04  #收貨單號
             AND idd11 = l_rvv.rvv05  #收貨項次
             AND idd24 = 'Y' #收貨時無法決定是否入庫  p_rvu00      #入庫否
           GROUP BY idd07
      END IF   #TQC-C50062 add

      IF cl_null(l_idd13) THEN LET l_idd13 = 0 END IF

      LET l_fac = 0

      IF l_rvv.rvv35 != l_idd07 THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_idd07)
              RETURNING L_i,l_fac
         IF l_i = 1 THEN
            ### ------單位無法轉換--------####
           #CALL cl_err('rvv35/idd07: ','abm-731',1)                       #MOD-DB0134 mark
            CALL cl_err_msg("","apm1199",l_rvv.rvv04||"|"||l_rvv.rvv05,10) #MOD-DB0134 add 
            LET g_success ='N'
            RETURN
         END IF
      END IF
      IF cl_null(l_fac) OR l_fac = 0 THEN LET l_fac = 1 END IF

      LET l_rvv17 = l_rvv.rvv17 * l_fac

      #判斷
      #若是產生入庫資料,則入庫異動數量必須等於,
      #    該收貨單刻號明細入庫否='Y'的總異動數量
      #若是產生驗退資料,則驗退異動數量必須等於,
      #    該收貨單刻號明細入庫否='N'的總異動數量
      IF l_rvv17 != l_idd13 THEN
         LET l_msg = "[Rec No.",l_rvv.rvv04,"  Line:",
                     l_rvv.rvv05 USING '<<<<<',"]"
         IF p_rvu00 = 'Y' THEN
            CALL cl_err(l_msg,'aic-118',1)
         END IF
         IF p_rvu00 = 'N' THEN
            CALL cl_err(l_msg,'aic-119',1)
         END IF
         LET g_success = 'N'
         RETURN
      END IF
   END IF
END FUNCTION

#8.計價數量: 作業編號(rvbiicd03)串作業編號檔,
#  若作業群組(ecdicd01)屬不同類型, 則計價數量如下
#8.1 CP: 計價數量= 可允收數(rvb33)
#8.2 DS: 計價數量= 可允收數(rvb33)
#8.3 ASS: 計價數量= 可允收數(rvb33)
#8.4 FT: 計價數量= 可允收數(rvb33) + 不良品數(rvbiicd06)
#8.5 TKY:
#8.5.1若作業群組'4.ASS': 可允收數(rvb33) + 不良品數(rvbiicd06)
#8.5.2若作業群組'5.FT': 可允收數(rvb33) + 不良品數(rvbiicd06)
FUNCTION t110sub_ind_icd_upd_rvb87(p_rva01,p_argv2)
DEFINE l_rvb2    RECORD LIKE rvb_file.*
DEFINE l_rvbi2   RECORD LIKE rvbi_file.*
DEFINE p_rva01   LIKE rva_file.rva01
DEFINE l_rvb87   LIKE rvb_file.rvb87
DEFINE p_argv2   LIKE rva_file.rva10

   IF g_success = 'N' THEN RETURN END IF
   IF p_argv2 != 'SUB' THEN RETURN END IF

   INITIALIZE l_rvb2.* TO NULL

   DECLARE upd_rvb87 CURSOR FOR
      SELECT rvb_file.*,rvbi_file.* FROM rvb_file,rvbi_file
        WHERE rvb01 = p_rva01
          AND rvb01 = rvbi01
          AND rvb02 = rvbi02
          AND rvbiicd03 IS NOT NULL
          AND rvbiicd03 != ' '
	        AND rvb87 <> 0 #如果user輸入為零則不重計計價數量

   FOREACH upd_rvb87 INTO l_rvb2.*,l_rvbi2.*
      CALL t110sub_ind_icd_set_rvb87_tky('a',l_rvb2.*,l_rvbi2.*,p_argv2)
      RETURNING l_rvb2.*,l_rvbi2.*,l_rvb87
 
      UPDATE rvb_file SET rvb87 = l_rvb2.rvb87
         WHERE rvb01 = l_rvb2.rvb01
           AND rvb02 = l_rvb2.rvb02
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd rvb87',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
END FUNCTION 

FUNCTION t110sub_ind_icd_set_rvb87_tky(p_cmd,l_rvb2,l_rvbi2,p_argv2)
   DEFINE l_ecdicd01     LIKE ecd_file.ecdicd01
   DEFINE l_ecdicd01_tky LIKE ecd_file.ecdicd01
   DEFINE p_cmd          LIKE type_file.chr1  #p:單身  a:其他
   DEFINE l_rvb2    RECORD LIKE rvb_file.*
   DEFINE l_rvbi2   RECORD LIKE rvbi_file.*
   DEFINE l_rvb87   LIKE rvb_file.rvb87
   DEFINE p_argv2   LIKE rva_file.rva10

  #IF p_argv2 != 'SUB' THEN RETURN l_rvb2.*,l_rvbi2.*,l_rvb87 END IF      #MOD-D50136 mark
   IF p_argv2 != 'SUB' THEN RETURN l_rvb2.*,l_rvbi2.*,l_rvb2.rvb87 END IF #MOD-D50136

   IF p_cmd = 'b' THEN
      #委外tky非最終站否(rvbiicd13)='Y',允收數量(rvb33)=實收數量
      IF l_rvbi2.rvbiicd13  = 'Y' THEN 
         LET l_rvb2.rvb33  = l_rvb2.rvb07
         LET l_rvb2.rvb331 = l_rvb2.rvb82 #實收數量
         LET l_rvb2.rvb332 = l_rvb2.rvb85 #實收數量
         LET l_rvb2.rvb40  = g_today      #檢驗日期
         LET l_rvb2.rvb41  = 'OK'         #檢驗結果
      ELSE
         IF l_rvb2.rvb33 = 0 OR cl_null(l_rvb2.rvb33) THEN
           #RETURN l_rvb2.*,l_rvbi2.*,l_rvb87      #MOD-D50136 mark
            RETURN l_rvb2.*,l_rvbi2.*,l_rvb2.rvb87 #MOD-D50136
         END IF
      END IF      
   END IF

   #取得工單作業編號
   LET l_ecdicd01_tky = ''
   SELECT ecdicd01 INTO l_ecdicd01_tky
      FROM pmni_file,ecd_file
     WHERE pmni01 = l_rvb2.rvb04
       AND pmni02 = l_rvb2.rvb03
       AND pmniicd03 IS NOT NULL
       AND pmniicd03 != ' '
       AND pmniicd03 = ecd01

   LET l_ecdicd01 = ''
   SELECT ecdicd01 INTO l_ecdicd01
      FROM ecd_file
     WHERE ecd01 = l_rvbi2.rvbiicd13

   CASE l_ecdicd01
        WHEN '2'  #CP: 計價數量= 可允收數(rvb33)
             LET l_rvb2.rvb87 = l_rvb2.rvb33
        WHEN '3'  #DS: 計價數量= 可允收數(rvb33)
             LET l_rvb2.rvb87 = l_rvb2.rvb33
        WHEN '4'  #ASS: 計價數量= 可允收數(rvb33)
             LET l_rvb2.rvb87 = l_rvb2.rvb33
        WHEN '5'  # FT: 計價數量= 可允收數(rvb33) + 不良品數(rvbiicd06)
             IF cl_null(l_rvbi2.rvbiicd06) THEN
                LET l_rvbi2.rvbiicd06=0
             END IF
             LET l_rvb2.rvb87 = l_rvb2.rvb33 + l_rvbi2.rvbiicd06
   END CASE
   IF l_ecdicd01 = '4' AND l_ecdicd01_tky = '6' THEN
      #TKY:若作業群組'4.ASS'= 可允收數(rvb33) + 不良品數(rvbiicd06)
      IF cl_null(l_rvbi2.rvbiicd06) THEN
         LET l_rvbi2.rvbiicd06=0
      END IF
      LET l_rvb2.rvb87 = l_rvb2.rvb33 + l_rvbi2.rvbiicd06
   END IF

   IF p_cmd = 'b' THEN
      LET l_rvb87 = l_rvb2.rvb87
   END IF
   RETURN l_rvb2.*,l_rvbi2.*,l_rvb87
END FUNCTION

FUNCTION t110sub_set_rvv87(p_item,p_fac2,p_qty2,p_fac1,p_qty1,p_rvv86,p_flag,p_unit)
   DEFINE p_item    LIKE img_file.img01,     #料號
          l_ima25   LIKE ima_file.ima25,     #ima單位
          l_ima44   LIKE ima_file.ima44,     #ima單位
          l_ima906  LIKE ima_file.ima906,
          p_fac2    LIKE img_file.img21,     #第二轉換率
          p_qty2    LIKE img_file.img10,     #第二數量
          p_fac1    LIKE img_file.img21,     #第一轉換率
          p_qty1    LIKE img_file.img10,     #第一數量
          p_rvv86   LIKE ima_file.ima25,     #第一數量
          p_unit    LIKE ima_file.ima25,
          l_tot     LIKE img_file.img10,     #計價數量
          p_flag    LIKE type_file.num5,     
          l_factor  LIKE ima_file.ima31_fac,  
          l_cnt     LIKE type_file.num5


   SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
     FROM ima_file WHERE ima01=p_item
   IF SQLCA.sqlcode = 100 THEN
      IF p_item MATCHES 'MISC*' THEN
         SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
           FROM ima_file WHERE ima01='MISC'
      END IF
   END IF

   IF cl_null(l_ima44) THEN
      LET l_ima44 = l_ima25
   END IF

   IF p_flag=1 THEN
      LET l_factor =1
      CALL s_umfchk(p_item,p_unit,l_ima44) RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET p_fac1=l_factor
   END IF

   IF cl_null(p_fac1) THEN LET p_fac1=1 END IF
   IF cl_null(p_qty1) THEN LET p_qty1=0 END IF
   IF cl_null(p_fac2) THEN LET p_fac2=1 END IF
   IF cl_null(p_qty2) THEN LET p_qty2=0 END IF

  #MOD-F10082 mark str
  #IF g_sma.sma115 = 'Y' THEN
  #   CASE l_ima906
  #      WHEN '1' LET l_tot=p_qty1*p_fac1
  #      WHEN '2' LET l_tot=p_qty1*p_fac1+p_qty2*p_fac2
  #      WHEN '3' LET l_tot=p_qty1*p_fac1
  #   END CASE
  #ELSE  #不使用雙單位
  #   LET l_tot=p_qty1*p_fac1
  #END IF
  #
  #IF cl_null(l_tot) THEN LET l_tot = 0 END IF
  #MOD-F10082 mark end
   LET l_factor = 1

   CALL s_umfchk(p_item,l_ima44,p_rvv86) RETURNING l_cnt,l_factor

   IF l_cnt = 1 THEN
      LET l_factor = 1
   END IF
  #MOD-F10082 mark str
  #LET l_tot = l_tot * l_factor
  #LET l_tot = s_digqty(l_tot,p_rvv86)     #FUN-BB0084
  #MOD-F10082 mark end
  #MOD-F10082 add str
   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot= s_digqty(((p_qty1*p_fac1) * l_factor),p_rvv86)
         WHEN '2' LET l_tot= s_digqty(((p_qty1*p_fac1+p_qty2*p_fac2) * l_factor),p_rvv86)
         WHEN '3' LET l_tot= s_digqty(((p_qty1*p_fac1) * l_factor),p_rvv86)
      END CASE
   ELSE  #不使用雙單位
      LET l_tot= s_digqty(((p_qty1*p_fac1) * l_factor),p_rvv86)
   END IF
   IF cl_null(l_tot) THEN LET l_tot = 0 END IF
  #MOD-F10082 add end

   RETURN l_tot

END FUNCTION

#-->確認時 check  若該工單是作業群組(ecdicd01) = '6.TKY',
#委外TKY收貨作業站別是否與委外工單作業製程站別是否相等
FUNCTION t110sub_ind_icd_chk_tky(p_argv2,p_rva01)
   DEFINE l_rvb34  LIKE rvb_file.rvb34,
          l_ecm04  LIKE ecm_file.ecm04
   DEFINE l_n      LIKE type_file.num5
   DEFINE p_argv2  LIKE rva_file.rva10
   DEFINE p_rva01  LIKE rva_file.rva01
 
#   IF p_argv2 != 'SUB' AND p_argv2 != 'ICD' THEN  LET g_success = 'N' RETURN END IF   #FUN-B90012--mark--
 
   DECLARE chk_tky_cur CURSOR FOR
      SELECT DISTINCT rvb34 FROM rvb_file,rvbi_file
         WHERE rvb01 = p_rva01   
           AND rvb01=rvbiicd01 
           AND rvb02=rvbiicd02
           AND rvbiicd17 IS NOT NULL AND rvbiicd17 != ' '
           AND rvb34 IS NOT NULL 
           AND rvbiicd03 IS NOT NULL
           AND rvbiicd03 !=' '
 
   FOREACH chk_tky_cur INTO l_rvb34
      #取得該工單之製程資料
      DECLARE ecm_cur CURSOR FOR
         SELECT ecm04 FROM ecm_file
            WHERE ecm01 = l_rvb34
      FOREACH ecm_cur INTO l_ecm04
         LET l_n = 0 
         SELECT COUNT(*) INTO l_n FROM rvb_file,rvbi_file
            WHERE rvb01 = p_rva01
              AND rvb01=rvbiicd01
              AND rvb02=rvbiicd02 
              AND rvbiicd03 = l_ecm04
              AND rvbiicd17 IS NOT NULL AND rvbiicd17 != ' '
              AND rvb34 IS NOT NULL AND rvbiicd03 IS NOT NULL
              AND rvbiicd03 !=' '
 
         #委外TKY收貨作業站別與委外工單作業製程站別不符或不齊全,請查核!!
         IF l_n = 0 THEN
            CALL cl_err('','aic-121',1)
            LET g_success = 'N'
            RETURN
         END IF
      END FOREACH  
   END FOREACH
 
END FUNCTION 
#FUN-A10130--end--add--------------------

#FUN-BC0104 ---------------------Begin----------------
#p_chr = 'i' 入庫,p_chr = 'o' 驗退;p_qc是否走QC;p_qcl05 性質;
#p_in 入庫異動數量;p_in1 入庫單位一數量;p_in2入庫單位二數量
#p_out 驗退異動數量;p_out1 驗退單位一數量;p_out2 驗退單位二數量
FUNCTION t110sub_ins_rvu(p_chr,p_qc,p_qcl05,p_flag,p_rva,p_rvb,p_rvbi,p_qco,p_smydate,p_in,p_in1,p_in2,p_out,p_out1,p_out2,p_argv2,p_argv6,p_rvu01_1,p_rvu01_2,p_msg,p_msg1)   #FUN-C40015 add p_msg,p_msg1
   DEFINE p_argv2     LIKE rva_file.rva10    #採購類別
   DEFINE p_argv6     LIKE rva_file.rva00    #收貨類別 
   DEFINE p_rva       RECORD LIKE rva_file.*
   DEFINE p_rvb       RECORD LIKE rvb_file.*
   DEFINE p_rvbi      RECORD LIKE rvbi_file.*
   DEFINE p_qco       RECORD LIKE qco_file.*
   DEFINE p_smydate   LIKE smy_file.smydate
   DEFINE p_flag      LIKE rvb_file.rvb01
   DEFINE p_chr       LIKE type_file.chr1
   DEFINE p_qc        LIKE type_file.chr1
   DEFINE p_qcl05     LIKE qcl_file.qcl05
   DEFINE g_qcz       RECORD LIKE qcz_file.*
   DEFINE l_rvu       RECORD LIKE rvu_file.*
   DEFINE l_yy,l_mm   LIKE type_file.num5
   DEFINE l_t         LIKE smy_file.smyslip 
   DEFINE l_smy57     LIKE smy_file.smy57
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_smyapr    LIKE smy_file.smyapr
   DEFINE p_in        LIKE rvv_file.rvv17
   DEFINE p_in1       LIKE rvv_file.rvv82
   DEFINE p_in2       LIKE rvv_file.rvv85
   DEFINE p_out       LIKE rvv_file.rvv17
   DEFINE p_out1      LIKE rvv_file.rvv82
   DEFINE p_out2      LIKE rvv_file.rvv85
   DEFINE p_rvu01_1   LIKE rvu_file.rvu01
   DEFINE p_rvu01_2   LIKE rvu_file.rvu01 
   DEFINE g_rvu01     LIKE rvu_file.rvu01
   DEFINE g_rvu00     LIKE rvu_file.rvu00 
   DEFINE p_msg       STRING     #FUN-C40015
   DEFINE p_msg1      STRING     #FUN-C40015

   INITIALIZE l_rvu.* TO NULL

  #用傳入的參數來判斷是驗退還是入庫
   IF p_chr = 'o' THEN      #異動類別   
      LET l_rvu.rvu00='2'   #驗退
      IF s_industry('icd') THEN
      #委外tky非最終站之收貨項次資料不可產生至驗退單
         IF p_rvbi.rvbiicd13 = 'Y' THEN
         #  RETURN NULL,NULL                #FUN-C40015
            RETURN NULL,NULL,p_msg,p_msg1   #FUN-C40015
         END IF
      END IF 
   ELSE
      LET l_rvu.rvu00='1'   #入庫
   END IF  
   LET l_rvu.rvu02=p_rva.rva01   #驗收單號(收貨單號)
   IF p_qc = 'Y' THEN            #依據判定結果產生入庫/驗退單
      LET l_rvu.rvu03 = p_smydate   #異動日期  
   ELSE
      LET l_rvu.rvu03 = g_today     #異動日期     
   END IF    

   #若入庫日小於收貨日
   IF l_rvu.rvu03<p_rva.rva06 THEN
      IF g_bgerr THEN
         CALL s_errmsg("","",l_rvu.rvu03,"apm-316",1)
      ELSE
         CALL cl_err3("","","","","apm-316","",l_rvu.rvu03,1)
      END IF
      LET g_success='N'
   #  RETURN             #TQC-C20159 
   #  RETURN NULL,NULL   #TQC-C20159  #FUN-C40015
      RETURN NULL,NULL,p_msg,p_msg1   #FUN-C40015 
   END IF   
   
   #日期<=關帳日期
   IF NOT cl_null(g_sma.sma53) AND l_rvu.rvu03 <= g_sma.sma53 THEN
      IF g_bgerr THEN
         CALL s_errmsg("","",l_rvu.rvu03,"mfg9999",1)
      ELSE
         CALL cl_err3("","","","","mfg9999","",l_rvu.rvu03,1)
      END IF
      LET g_success = 'N'
   #  RETURN NULL,NULL                #FUN-C40015
      RETURN NULL,NULL,p_msg,p_msg1   #FUN-C40015
   END IF

   CALL s_yp(l_rvu.rvu03) RETURNING l_yy,l_mm
   IF (l_yy*12+l_mm)>(g_sma.sma51*12+g_sma.sma52)THEN    #不可大於現行年月
      IF g_bgerr THEN
         CALL s_errmsg("","",l_rvu.rvu03,"mfg6091",1)
      ELSE
         CALL cl_err3("","","","","mfg6091","",l_rvu.rvu03,1)
      END IF
      LET g_success = 'N'
   #  RETURN NULL,NULL                #FUN-C40015
      RETURN NULL,NULL,p_msg,p_msg1   #FUN-C40015
   END IF   
   LET l_t = s_get_doc_no(p_rva.rva01)    #取出收貨單的單別       
   #用傳入的參數來判斷
   IF p_chr = 'o' THEN     #取對應的入庫/驗退單別      
      SELECT smy51,smy57[3,3] INTO l_rvu.rvu01,l_smy57 FROM smy_file
       WHERE smyslip=l_t
   ELSE
      SELECT smy52,smy57[3,3] INTO l_rvu.rvu01,l_smy57 FROM smy_file
       WHERE smyslip=l_t
   END IF    

   IF l_rvu.rvu01 IS NULL THEN
      IF g_bgerr THEN
        #MOD-D60095 add start -----
         IF p_chr = 'o' THEN     #取對應的入庫/驗退單別      
            CALL s_errmsg("","","smy51=NULL","apm-272",1)
         ELSE
        #MOD-D60095 add end   -----
            CALL s_errmsg("","","smy52=NULL","apm-272",1)
         END IF #MOD-D60095 add
      ELSE
        #MOD-D60095 add start -----
         IF p_chr = 'o' THEN     #取對應的入庫/驗退單別      
            CALL cl_err3("","","","","apm-272","","smy51=NULL",1)
         ELSE
        #MOD-D60095 add end   -----
            CALL cl_err3("","","","","apm-272","","smy52=NULL",1)
         END IF
        #MOD-D60095 add end   -----
      END IF
      LET g_success = 'N'
   #  RETURN NULL,NULL                #FUN-C40015 
      RETURN NULL,NULL,p_msg,p_msg1   #FUN-C40015
   END IF
   
   IF p_flag THEN   #如果當前單號不等於上一筆收貨單單號,原來的入庫單單號清空
      LET p_rvu01_1 = NULL
      LET p_rvu01_2 = NULL
   END IF    
      
   IF (l_rvu.rvu00='1' AND cl_null(p_rvu01_1)) OR
      (l_rvu.rvu00='2' AND cl_null(p_rvu01_2)) THEN
      IF l_smy57='Y' THEN    #入庫單流水是否預設同收貨單流水
         LET l_rvu.rvu01[g_no_sp-1,g_no_ep]=p_rva.rva01[g_no_sp-1,g_no_ep] 
         SELECT COUNT(*) INTO l_cnt
           FROM rvu_file
          WHERE rvu01=l_rvu.rvu01
         IF l_cnt > 0 THEN   # OR MONTH(p_rva.rva08) <> MONTH(g_today)
                             #原有考慮收貨月份不等於入庫月份時應以 g_today產生單號
                             #此狀況改以原收貨月份產生單號)
            LET l_t = l_rvu.rvu01[1,g_doc_len]        
            CALL s_auto_assign_no("apm",l_t,p_rva.rva06,"","","","","","")
                 RETURNING li_result,l_rvu.rvu01
            IF (NOT li_result) THEN
            #TQC-C50060 ------------Begin-----------
               IF g_bgerr THEN 
                  CALL s_errmsg("","","","apm-155",1)
               ELSE
                  CALL cl_err3("","","","","apm-155","","",1)
               END IF
            #TQC-C50060 ------------End-------------
               LET g_success='N'
            END IF
         END IF   
      ELSE
         LET l_t = l_rvu.rvu01[1,g_doc_len]        
         CALL s_auto_assign_no("apm",l_t,l_rvu.rvu03,"","","","","","")
              RETURNING li_result,l_rvu.rvu01
         IF (NOT li_result) THEN
            #TQC-C50060 ------------Begin-----------
            IF g_bgerr THEN 
               CALL s_errmsg("","","","apm-155",1)
            ELSE
               CALL cl_err3("","","","","apm-155","","",1)
            END IF
            #TQC-C50060 ------------End-------------
            LET g_success='N'
         END IF
      END IF
   END IF         

   IF (l_rvu.rvu00='1' AND cl_null(p_rvu01_1)) THEN #新產生入庫單
      LET p_rvu01_1 = l_rvu.rvu01
      LET p_msg = p_msg," ",p_rvu01_1    #FUN-C40015
   END IF

   IF (l_rvu.rvu00='2' AND cl_null(p_rvu01_2)) THEN #新產生驗退單
      LET p_rvu01_2 = l_rvu.rvu01
      LET p_msg1 = p_msg1," ",p_rvu01_2  #FUN-C40015 
   END IF

   IF l_rvu.rvu00 = '1' THEN
      LET l_rvu.rvu01 = p_rvu01_1 #入庫
   ELSE
      LET l_rvu.rvu01 = p_rvu01_2 #驗退
   END IF   

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rvu_file   #根據入庫單號和收貨單號判斷是否需要新增入庫單單頭資料
    WHERE rvu01 = l_rvu.rvu01
      AND rvuconf !='X'
      AND rvu02 = p_rva.rva01   

   IF l_cnt >=1 THEN     #該筆收貨單對應的入庫/驗退單存在，只需新增單身資料
      CALL t110sub_ins_rvv(p_chr,p_qc,l_rvu.rvu00,l_rvu.rvu01,l_rvu.rvu03,p_qcl05,p_rva.*,p_rvb.*,p_rvbi.*,p_qco.*,p_in,p_in1,p_in2,p_out,p_out1,p_out2,p_argv2,p_argv6)  #TQC-C30119 add p_chr
      IF s_industry('slk') THEN 
         LET g_rvu01 = l_rvu.rvu01
         LET g_rvu00 = l_rvu.rvu00
      END IF       
   ELSE                  #新增單頭和單身
      LET l_rvu.rvu04=p_rva.rva05   #廠商編號
      SELECT pmc03 INTO l_rvu.rvu05 FROM pmc_file  #簡稱
       WHERE pmc01=l_rvu.rvu04
      LET l_rvu.rvu06=g_grup        #部門
      LET l_rvu.rvu07=g_user        #人員
      LET l_rvu.rvu08=p_rva.rva10   #性質
      LET l_rvu.rvu09=NULL
      LET l_rvu.rvu20='N'           #三角貿易拋轉否no.4475
      LET l_rvu.rvuconf='N'         #確認碼
      LET l_rvu.rvuacti='Y'
      LET l_rvu.rvuuser=p_rva.rvauser
      LET l_rvu.rvugrup=p_rva.rvagrup
      LET l_rvu.rvumodu=' '
      LET l_rvu.rvucrat=g_today  
      LET l_rvu.rvu21 = p_rva.rva29
      LET l_rvu.rvuplant = p_rva.rvaplant
      LET l_rvu.rvulegal = p_rva.rvalegal
      LET l_rvu.rvu22 = p_rva.rva30
      LET l_rvu.rvu23 = p_rva.rva31
      LET l_rvu.rvucrat = g_today
      #LET l_rvu.rvu900 = '0'       #CHI-E40020 mark
      LET l_rvu.rvumksg = 'N'
      LET l_rvu.rvupos = 'N'   
      IF l_rvu.rvu21 IS NULL THEN LET l_rvu.rvu21 = '1' END IF
      LET l_rvu.rvuplant = g_plant 
      LET l_rvu.rvulegal = g_legal 
      LET l_rvu.rvuoriu = g_user 
      LET l_rvu.rvuorig = g_grup 
      LET l_rvu.rvu101=p_rva.rva08   
      LET l_rvu.rvu102=p_rva.rva21   
      LET l_rvu.rvu100=p_rva.rva100  
      LET l_rvu.rvu17='0'
      LET l_t = l_rvu.rvu01[1,g_doc_len]
      SELECT smyapr INTO l_smyapr
        FROM smy_file
       WHERE smyslip = l_t 
      LET l_rvu.rvumksg = l_smyapr   
    #TQC-C20521 ---------Begin-------
      IF cl_null(l_rvu.rvumksg) THEN 
         LET l_rvu.rvumksg = 'N' 
      END IF 
    #TQC-C20521 ---------End---------
      LET l_rvu.rvu111 = p_rva.rva111
      LET l_rvu.rvu112 = p_rva.rva112
      LET l_rvu.rvu115 = p_rva.rva115
      LET l_rvu.rvu12  = p_rva.rva116
      LET l_rvu.rvu113 = p_rva.rva113
      LET l_rvu.rvu114 = p_rva.rva114   
      LET l_rvu.rvu27 = '1'  
      INSERT INTO rvu_file VALUES (l_rvu.*)
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg("rvu01",l_rvu.rvu01,"ins rvu:1",STATUS,1)
         ELSE
            CALL cl_err3("ins","rvu_file",l_rvu.rvu01,"",STATUS,"","ins rvu:1",1)
         END IF
         LET g_success='N'
      #  RETURN NULL,NULL                 #FUN-C40015 
         RETURN NULL,NULL,p_msg,p_msg1    #FUN-C40015
      ELSE
      #FUN-C40015 ----------Begin-----------mark
      #  IF p_qc = 'N' THEN    #TQC-C20177
      #     IF l_rvu.rvu00 = '1' THEN
      #        #產生的入庫異動單
      #        IF g_bgerr THEN
      #           CALL s_errmsg("rvu01","",l_rvu.rvu01,"apm-112",1)
      #        ELSE
      #           CALL cl_err3("","","","","apm-112","",l_rvu.rvu01,1)
      #        END IF
      #     ELSE
      #        #產生的驗退異動單
      #        IF g_bgerr THEN
      #           CALL s_errmsg("rvu01","",l_rvu.rvu01,"apm-124",1)
      #        ELSE
      #           CALL cl_err3("","","","","apm-124","",l_rvu.rvu01,1)
      #        END IF
      #     END IF            #TQC-C20177
      #  END IF 
      #FUN-C40015 ----------End-------------mark
      END IF
      CALL t110sub_ins_rvv(p_chr,p_qc,l_rvu.rvu00,l_rvu.rvu01,l_rvu.rvu03,p_qcl05,p_rva.*,p_rvb.*,p_rvbi.*,p_qco.*,p_in,p_in1,p_in2,p_out,p_out1,p_out2,p_argv2,p_argv6) #NO:7143單身    #TQC-C30119 add p_chr
      IF s_industry('slk') THEN
         LET g_rvu01 = l_rvu.rvu01
         LET g_rvu00 = l_rvu.rvu00
      END IF 
   END IF      
#  RETURN p_rvu01_1,p_rvu01_2                 #FUN-C40015  
   RETURN p_rvu01_1,p_rvu01_2,p_msg,p_msg1    #FUN-C40015 
END FUNCTION

#p_chr = 'i' 入庫,p_chr = 'o' 驗退;p_qc是否走QC;p_qcl05 性質;
#p_in 入庫異動數量;p_in1 入庫單位一數量;p_in2入庫單位二數量
#p_out 驗退異動數量;p_out1 驗退單位一數量;p_out2 驗退單位二數量
FUNCTION t110sub_ins_rvv(p_chr,p_qc,p_rvu00,p_rvv01,p_rvu03,p_qcl05,p_rva,p_rvb,p_rvbi,p_qco,p_in,p_in1,p_in2,p_out,p_out1,p_out2,p_argv2,p_argv6)  #TQC-C30119 add p_chr
   DEFINE p_chr     LIKE type_file.chr1     #TQC-C30119 
   DEFINE p_rva     RECORD LIKE rva_file.*
   DEFINE p_rvb     RECORD LIKE rvb_file.*
   DEFINE p_rvbi    RECORD LIKE rvbi_file.*
   DEFINE p_qco     RECORD LIKE qco_file.*
   DEFINE g_qcz     RECORD LIKE qcz_file.*
   DEFINE l_ima44   LIKE ima_file.ima44      
   DEFINE l_rvv     RECORD LIKE rvv_file.*,
          l_rvuconf LIKE rvu_file.rvuconf,
          l_smy57   LIKE type_file.chr1,     
          l_t       LIKE smy_file.smyslip,  
          p_rvv01   LIKE rvv_file.rvv01
   DEFINE p_rvu00   LIKE rvu_file.rvu00      
   DEFINE l_flag    LIKE type_file.num5      
   DEFINE l_flag1   LIKE type_file.num5
   DEFINE l_sql     STRING  
   DEFINE l_rvbs    RECORD LIKE rvbs_file.*  
   DEFINE l_cnt     LIKE type_file.num5      
   DEFINE l_rvw06f  LIKE rvw_file.rvw06f
   DEFINE l_rvbiicd13   LIKE rvbi_file.rvbiicd13
   DEFINE p_qcl05       LIKE qcl_file.qcl05
   DEFINE l_img09_t     LIKE img_file.img09
   DEFINE g_ima906      LIKE ima_file.ima906
   DEFINE g_ima907      LIKE ima_file.ima907 
   DEFINE g_i           LIKE type_file.num5
   DEFINE t_azi04       LIKE azi_file.azi04
   DEFINE l_gec05       LIKE gec_file.gec05
   DEFINE l_gec07       LIKE gec_file.gec07
   DEFINE l_pmm43       LIKE pmm_file.pmm43 
   DEFINE p_qc          LIKE type_file.chr1
   DEFINE p_in          LIKE rvv_file.rvv17
   DEFINE p_in1         LIKE rvv_file.rvv82
   DEFINE p_in2         LIKE rvv_file.rvv85
   DEFINE p_out         LIKE rvv_file.rvv17
   DEFINE p_out1        LIKE rvv_file.rvv82
   DEFINE p_out2        LIKE rvv_file.rvv85
   DEFINE p_rvu03       LIKE rvu_file.rvu03
   DEFINE p_argv6       LIKE rva_file.rva00    #收貨類別
   DEFINE p_argv2       LIKE rva_file.rva10    #採購類別
   DEFINE l_rvvi        RECORD LIKE rvvi_file.*  
   DEFINE l_ida         RECORD LIKE ida_file.*   
   DEFINE l_idd         RECORD LIKE idd_file.*   
   DEFINE l_ima24   LIKE ima_file.ima24           #TQC-CA0049 add
   DEFINE l_sum_rvbs06 LIKE rvbs_file.rvbs06      #TQC-CA0049 add
   DEFINE l_qcs09      LIKE qcs_file.qcs09        #TQC-CA0049 add
   DEFINE l_rvu06      LIKE rvu_file.rvu06        #FUN-CB0087 add
   DEFINE l_rvu07      LIKE rvu_file.rvu07        #FUN-CB0087 add
   DEFINE l_rvbs00     LIKE rvbs_file.rvbs00      #FUN-E20026
   #MOD-G30071 add start ------------------------
   DEFINE l_cnt1         LIKE type_file.num5
   DEFINE l_qcs22        LIKE qcs_file.qcs22
   DEFINE l_rvb07        LIKE rvb_file.rvb07
   DEFINE l_sum_rvbs06_1 LIKE rvbs_file.rvbs06
   #MOD-G30071 add end   ------------------------
   DEFINE l_newqc_flag   LIKE type_file.chr1      #MOD-G40139 add   
   DEFINE l_sum1_rvbs06  LIKE rvbs_file.rvbs06    #MOD-G40139 add
   DEFINE l_sum3_rvbs06  LIKE rvbs_file.rvbs06    #MOD-G40139 add

   IF s_industry('icd') THEN
      #委外TKY非最終站,不需產生至驗退
      SELECT rvbiicd13 INTO l_rvbiicd13  FROM rvbi_file
       WHERE rvbi01 = p_rvb.rvb01
         AND rvbi02 = p_rvb.rvb02
      IF p_rvu00 = '2' AND l_rvbiicd13 = 'Y' THEN
         RETURN
      END IF
   END IF 

   LET l_rvv.rvv01 = p_rvv01
   SELECT * INTO g_qcz.* FROM qcz_file WHERE qcz00='0'
   LET l_t = s_get_doc_no(p_rvb.rvb01)
   SELECT smy57[3,3] INTO l_smy57 FROM smy_file
    WHERE smyslip=l_t   
   IF p_rvu00 = '2' THEN   #驗退   
      SELECT MAX(rvv02)+1 INTO l_rvv.rvv02 FROM rvv_file   #序號
       WHERE rvv01=l_rvv.rvv01
      LET l_rvv.rvv03='2'                                  #異動類別
      #這邊可以直接用本次可驗退量來賦值給異動數量
      LET l_rvv.rvv86=p_rvb.rvb86   #計價單位
      IF p_qc = 'Y' THEN            #依QC判定結果產生入庫/驗退單
         IF p_qcl05 = '1' THEN      #計價不計量 
            LET l_rvv.rvv17 = 0
         ELSE
            LET l_rvv.rvv17 = p_out      
         END IF 
         IF p_qcl05 = '2' THEN
            LET l_rvv.rvv87 = 0
         ELSE
            LET l_rvv.rvv87 = p_out
         END IF
      ELSE
         LET l_rvv.rvv17 = p_out
         LET l_rvv.rvv87 = p_rvb.rvb87 
      END IF
      IF g_sma.sma115 = 'Y' THEN   #ima906='2'/'3'且qco20 > 0 時是不會走到這段邏輯，因為此種情況不不會調用t110sub_ins_rvu()
         IF p_qc = 'N' THEN 
            LET l_rvv.rvv80=p_rvb.rvb80
            LET l_rvv.rvv81=p_rvb.rvb81
            LET l_rvv.rvv82=p_out1         
            LET l_rvv.rvv83=p_rvb.rvb83
            LET l_rvv.rvv84=p_rvb.rvb84
            LET l_rvv.rvv85=p_out2  
         ELSE 
            LET l_rvv.rvv80=p_qco.qco13
            LET l_rvv.rvv81=p_qco.qco14
            LET l_rvv.rvv83=p_qco.qco16
            LET l_rvv.rvv84=p_qco.qco17
            IF p_qcl05 = '1' THEN      #計價不計量 
               LET l_rvv.rvv82=0
               LET l_rvv.rvv85=0
            ELSE
               LET l_rvv.rvv82=p_out1
               LET l_rvv.rvv85=p_out2
            END IF		
         END IF             
      END IF
   ELSE    #入庫
      SELECT MAX(rvv02)+1 INTO l_rvv.rvv02 FROM rvv_file   #序號
       WHERE rvv01=l_rvv.rvv01
      LET l_rvv.rvv03='1'                                  #異動類別
     #這里可以直接用本次可入庫量來賦值     
      LET l_rvv.rvv86=p_rvb.rvb86  #計價單位    
      IF p_qc = 'Y' THEN
         IF p_qcl05 = '1' THEN     #計價不計量
            LET l_rvv.rvv17 = 0
         ELSE
            LET l_rvv.rvv17 = p_in
         END IF  
         IF p_qcl05 = '2' THEN
            LET l_rvv.rvv87 = 0
         ELSE
            LET l_rvv.rvv87 = p_in
         END IF 
      ELSE
         LET l_rvv.rvv17 = p_in
         LET l_rvv.rvv87 = p_rvb.rvb87 
      END IF
      IF g_sma.sma115 = 'Y' THEN
         IF p_qc = 'N' THEN 
            LET l_rvv.rvv80=p_rvb.rvb80
            LET l_rvv.rvv81=p_rvb.rvb81
            LET l_rvv.rvv82=p_in1                      
            LET l_rvv.rvv83=p_rvb.rvb83
            LET l_rvv.rvv84=p_rvb.rvb84
            LET l_rvv.rvv85=p_in2          
         ELSE
            LET l_rvv.rvv80=p_qco.qco13
            LET l_rvv.rvv81=p_qco.qco14
            LET l_rvv.rvv83=p_qco.qco16
            LET l_rvv.rvv84=p_qco.qco17
            IF p_qcl05 = '1' THEN   #計價不計量
               LET l_rvv.rvv82=0
               LET l_rvv.rvv85=0
            ELSE
               LET l_rvv.rvv82=p_in1
               LET l_rvv.rvv85=p_in2
            END IF
         END IF         
      END IF
   END IF     #入庫/驗退的數量賦值結束
   LET l_rvv.rvv82 = s_digqty(l_rvv.rvv82,l_rvv.rvv80)   
   LET l_rvv.rvv85 = s_digqty(l_rvv.rvv85,l_rvv.rvv83)  
   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02=1 END IF   
   LET l_rvv.rvv04=p_rvb.rvb01     #驗收單號
   LET l_rvv.rvv05=p_rvb.rvb02     #驗收項次   
   LET l_rvv.rvv06=p_rva.rva05     #廠商      
   LET l_rvv.rvv09=p_rvu03         #異動日
   LET l_rvv.rvv18=p_rvb.rvb34     #工單編號
   LET l_rvv.rvv23=0               #已請款匹配數量
   LET l_rvv.rvv88=0               
   LET l_rvv.rvv24=NULL
   LET l_rvv.rvv25=p_rvb.rvb35     #樣品
   LET l_rvv.rvv26=NULL          
   
   IF p_qc = 'N' THEN       
      LET l_rvv.rvv31=p_rvb.rvb05   #料號
   ELSE 
      LET l_rvv.rvv31=p_qco.qco06   #料號可能會有聯產品 
   END IF   

   LET l_rvv.rvv89=p_rvb.rvb89     

   IF cl_null(l_rvv.rvv89) THEN
      LET l_rvv.rvv89 = 'N'
   END IF
   
   SELECT ima44 INTO l_ima44 FROM ima_file WHERE ima01=l_rvv.rvv31
 
   ##---- 20180508 mark by momo (S)
   #IF p_rvb.rvb05[1,4]='MISC' THEN      #品名
   #   LET l_rvv.rvv031 = p_rvb.rvb051
   #ELSE
   #   SELECT ima02 INTO l_rvv.rvv031 FROM ima_file
   #    WHERE ima01=p_rvb.rvb05
   #END IF
   #IF p_qc = 'Y' THEN
   #   SELECT ima02 INTO l_rvv.rvv031 FROM ima_file
   #    WHERE ima01=p_qco.qco06
   #END IF 
   ##----- 20180508 mark by momo (E)
   LET l_rvv.rvv031 = p_rvb.rvb051   #20180508 modify

   ##----- 20200722 add by momo 特採批號 (S)
   IF p_rvu00 = '1' AND g_plant <> 'NM' THEN  #20220816 NM 不使用該功能
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM qcs_file
    WHERE qcs01 = p_rvb.rvb01
      AND qcs02 = p_rvb.rvb02
      AND qcs09 = '3'
   IF l_cnt > 0 THEN
      SELECT to_char(sysdate,'yy')||to_char(sysdate,'mm')||to_char(sysdate,'dd')
        INTO p_rvb.rvb38
        FROM dual
      LET p_rvb.rvb38 = 'TC-'||p_rva.rva05||'-'||p_rvb.rvb38
      IF p_rva.rva10 = 'REG' THEN
         LET p_qcl05 = 1
      END IF
   END IF 
   END IF
   ##----- 20200722 add by momo 特採批號 (E)

   IF p_qc = 'N' THEN 
      LET l_rvv.rvv32=p_rvb.rvb36     #倉庫
      LET l_rvv.rvv33=p_rvb.rvb37     #儲位
      LET l_rvv.rvv34=p_rvb.rvb38     #批號
      LET l_rvv.rvv35=p_rvb.rvb90     #單位 
      LET l_rvv.rvv35_fac=p_rvb.rvb90_fac  #單位對庫存單位的轉換率       
   ELSE
      LET l_rvv.rvv32=p_qco.qco07
      LET l_rvv.rvv33=p_qco.qco08
      LET l_rvv.rvv34=p_qco.qco09 
      LET l_rvv.rvv35=p_qco.qco10
      LET l_rvv.rvv35_fac=p_qco.qco12
   END IF    
   IF cl_null(l_rvv.rvv32) THEN LET l_rvv.rvv32=' ' END IF
   IF cl_null(l_rvv.rvv33) THEN LET l_rvv.rvv33=' ' END IF
   IF cl_null(l_rvv.rvv34) THEN LET l_rvv.rvv34=' ' END IF
   LET l_rvv.rvv17 = s_digqty(l_rvv.rvv17,l_rvv.rvv35)  

#FUN-C20076 ---------------------Begin----------------------
#新增倉庫庫存明細,產生驗退單時不需要新增倉儲批
#依QC料件判定產生入庫單的邏輯新增自動產生倉儲批的功能
  #IF p_qcl05 <> '3' AND NOT cl_null(p_qcl05) THEN      #TQC-C30048     #FUN-CC0013 mark
   IF NOT cl_null(p_qcl05) THEN                                         #FUN-CC0013 add
      LET l_flag1 = 0
      SELECT COUNT(*) INTO l_flag1 FROM img_file
       WHERE img01 = l_rvv.rvv31 AND  img02 = l_rvv.rvv32
         AND img03 = l_rvv.rvv33 AND  img04 = l_rvv.rvv34
      IF cl_null(l_flag1) OR l_flag1 = 0 THEN      #新增倉庫庫存明細檔
         IF g_sma.sma892[3,3] = 'Y' THEN
        #MOD-DA0134 add start -----
            IF NOT cl_confirm('mfg1401') THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
        #MOD-DA0134 add end   -----
         CALL s_add_img(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                        l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv09)
        #END IF #MOD-DA0134 mark
      END IF
      IF g_sma.sma115 = 'Y' THEN
         LET g_ima906 = NULL
         LET g_ima907 = NULL
         SELECT ima906,ima907,ima44 INTO g_ima906,g_ima907,l_ima44 FROM ima_file
          WHERE ima01=l_rvv.rvv31
          IF g_ima906 MATCHES '[2,3]' THEN
            LET l_flag1 = 0
            IF NOT cl_null(l_rvv.rvv83) THEN 
               CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv83) RETURNING l_flag1
               IF l_flag1  = 1 THEN 
                  IF g_sma.sma892[3,3] = 'Y' THEN 
                 #MOD-DA0134 add start -----
                     IF NOT cl_confirm('mfg1401') THEN
                        LET g_success = 'N'
                        RETURN
                     END IF
                  END IF
                 #MOD-DA0134 add end   -----
                  CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                                  l_rvv.rvv33,l_rvv.rvv34,
                                  l_rvv.rvv83,l_rvv.rvv84,
                                  l_rvv.rvv01,l_rvv.rvv02,0) RETURNING l_flag1 
                  IF l_flag1 = 1 THEN 
                 #TQC-C50060 ---------Begin-----------
                     IF g_bgerr THEN 
                        CALL s_errmsg("","","","apm-156",1)
                     ELSE
                        CALL cl_err3("","","","","apm-156","","",1)
                     END IF
                 #TQC-C50060 ---------End-------------
                     LET g_success = 'N'
                     RETURN
                  END IF
                 #END IF   #MOD-DA0134 mark 
               END IF
            END IF
            IF NOT cl_null(l_rvv.rvv80) AND g_ima906 = '2' THEN 
               LET l_flag1 = 0
               CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv80) RETURNING l_flag1
               IF l_flag = 1 THEN 
                  IF g_sma.sma892[3,3] = 'Y' THEN
                 #MOD-DA0134 add start -----
                     IF NOT cl_confirm('mfg1401') THEN
                        LET g_success = 'N'
                        RETURN
                     END IF
                  END IF
                 #MOD-DA0134 add end   -----
                     CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                                     l_rvv.rvv33,l_rvv.rvv34,
                                     l_rvv.rvv80,l_rvv.rvv81,
                                     l_rvv.rvv01,l_rvv.rvv02,0) RETURNING l_flag1
                     IF l_flag1 = 1 THEN 
                 #TQC-C50060 ---------Begin-----------
                        IF g_bgerr THEN 
                           CALL s_errmsg("","","","apm-156",1)
                        ELSE
                           CALL cl_err3("","","","","apm-156","","",1)
                        END IF
                 #TQC-C50060 ---------End-------------
                        LET g_success = 'N'
                        RETURN
                     END IF
                 #END IF #MOD-DA0134 mark 
               END IF
            END IF
         END IF
      END IF
   END IF    #TQC-C30048
#FUN-C20076 ---------------------End------------------------

   #計價數量的計算   
   IF g_sma.sma115='Y' THEN   
   #  IF p_qcl05 = '3' THEN    #驗退      #TQC-C30119 mark
   #  IF p_qcl05 = '3' OR (cl_null(p_qcl05) AND p_chr = 'o') THEN    #TQC-C30119   #FUN-CC0013 mark
      IF cl_null(p_qcl05) AND p_chr = 'o' THEN                                     #FUN-CC0013 add
   #依QC判定產生驗退單和不走QC判定時產生驗退單rvv87的计算方式
         CALL t110sub_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,p_out2,
                                l_rvv.rvv81,p_out1,l_rvv.rvv86,0,'')
              RETURNING l_rvv.rvv87
      ELSE    #入庫
   #依QC判定產生入庫單和不走QC判定時rvv87的计算方式  
         CALL t110sub_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,p_in2,
                                l_rvv.rvv81,p_in1,l_rvv.rvv86,0,'')
              RETURNING l_rvv.rvv87
      END IF 
   ELSE    #不走多單位
   #  IF p_qcl05 = '3' THEN    #驗退      #TQC-C30119 mark
   #  IF p_qcl05 = '3' OR (cl_null(p_qcl05) AND p_chr = 'o') THEN    #TQC-C30119   #FUN-CC0013 mark
      IF cl_null(p_qcl05) AND p_chr = 'o' THEN                                     #FUN-CC0013 add
         CALL t110sub_set_rvv87(l_rvv.rvv31,1,0,1,p_out,
                                l_rvv.rvv86,1,l_rvv.rvv35)
              RETURNING l_rvv.rvv87
      ELSE    #入庫 
         CALL t110sub_set_rvv87(l_rvv.rvv31,1,0,1,p_in,
                                l_rvv.rvv86,1,l_rvv.rvv35)
              RETURNING l_rvv.rvv87     #rvv87已經取位
      END IF 
   END IF
 
   IF p_qcl05 = '2' THEN    #計量不計價
      LET l_rvv.rvv87 = 0
   END IF

   LET l_flag=TRUE   

   IF s_industry('icd') THEN
        LET l_rvvi.rvviicd07 = p_rvbi.rvbiicd13 #委外TKY非最終站否
        IF (l_rvvi.rvviicd07 = 'N' OR l_rvvi.rvviicd07 IS NULL
            OR l_rvvi.rvviicd07 = ' ') THEN
           LET l_flag=TRUE  #委外TKY最終站
        ELSE
           LET l_flag=FALSE #委外TKY非最終站
        END IF
   END IF   

#不須檢查img_file的合理性
#當倉庫有值,收料單可以直接入庫(即不需要檢驗),委外TKY最終站時
#l_rvv.rvv35_fac是料件對應具體倉庫的換算率
   IF NOT cl_null(l_rvv.rvv32) AND (g_sma.sma886[7,7] = 'Y') AND (l_flag) THEN  
      SELECT img09 INTO l_img09_t FROM img_file
       WHERE img01 = l_rvv.rvv31
         AND img02 = l_rvv.rvv32
         AND img03 = l_rvv.rvv33
         AND img04 = l_rvv.rvv34
      CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_img09_t)
           RETURNING g_i,l_rvv.rvv35_fac
      IF g_i = 1 THEN
         ### ------單位無法轉換--------####
         IF g_bgerr THEN
           #CALL s_errmsg("","","rvv35/img09: ","abm-731",1)                          #MOD-DB0134 mark
            CALL s_errmsg("rvb02,rvb05",l_rvv.rvv04||"/"||l_rvv.rvv05,"","abm-731",1) #MOD-DB0134 add
         ELSE
           #CALL cl_err3("","","","","abm-731","","rvv35/img09: ",1)       #MOD-DB0134 mark
            CALL cl_err_msg("","apm1199",l_rvv.rvv04||"|"||l_rvv.rvv05,10) #MOD-DB0134 add 
         END IF
         LET g_success ='N'
         RETURN
      END IF 

      LET g_ima906 = NULL
      LET g_ima907 = NULL
      SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
       WHERE ima01=l_rvv.rvv31
      IF g_sma.sma115 = 'Y' AND g_ima906 MATCHES '[23]' THEN
         IF NOT cl_null(l_rvv.rvv83) THEN
            CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                            l_rvv.rvv83) RETURNING l_flag1
            IF l_flag1 = 1 THEN
               CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                               l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv83,l_rvv.rvv84,
                               l_rvv.rvv01,l_rvv.rvv02,0) RETURNING l_flag1
               IF l_flag1 = 1 THEN
                 #TQC-C50060 ---------Begin-----------
                  IF g_bgerr THEN 
                     CALL s_errmsg("","","","apm-156",1)
                  ELSE
                     CALL cl_err3("","","","","apm-156","","",1)
                  END IF
                 #TQC-C50060 ---------End-------------
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF

            CALL s_du_umfchk(l_rvv.rvv31,'','','',l_ima44,l_rvv.rvv83,g_ima906)
                 RETURNING g_errno,l_rvv.rvv84
            IF NOT cl_null(g_errno) THEN
               IF g_bgerr THEN
                 #CALL s_errmsg("","","rvv83/ima44: ","abm-731",1)                          #MOD-DB0134 mark
                  CALL s_errmsg("rvb02,rvb05",l_rvv.rvv04||"/"||l_rvv.rvv05,"","abm-731",1) #MOD-DB0134 add
               ELSE
                 #CALL cl_err3("","","","","abm-731","","rvv83/ima44: ",1)       #MOD-DB0134 mark
                  CALL cl_err_msg("","apm1199",l_rvv.rvv04||"|"||l_rvv.rvv05,10) #MOD-DB0134 add 
               END IF
               LET g_success = 'N' 
               RETURN
            END IF
         END IF

         IF NOT cl_null(l_rvv.rvv80) AND g_ima906 = '2' THEN
            CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                            l_rvv.rvv80) RETURNING l_flag1
            IF l_flag1 = 1 THEN
               CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
                               l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv80,l_rvv.rvv81,
                               l_rvv.rvv01,l_rvv.rvv02,0) RETURNING l_flag1
               IF l_flag1 = 1 THEN
                 #TQC-C50060 ---------Begin-----------
                  IF g_bgerr THEN
                     CALL s_errmsg("","","","apm-156",1)
                  ELSE
                     CALL cl_err3("","","","","apm-156","","",1)
                  END IF
                 #TQC-C50060 ---------End-------------
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF

            CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima44)
                 RETURNING g_i,l_rvv.rvv81
            IF g_i = 1 THEN
               IF g_bgerr THEN
                 #CALL s_errmsg("","","rvv80/ima44: ","abm-731",1)                          #MOD-DB0134 mark
                  CALL s_errmsg("rvb02,rvb05",l_rvv.rvv04||"/"||l_rvv.rvv05,"","abm-731",1) #MOD-DB0134 add
               ELSE
                 #CALL cl_err3("","","","","abm-731","","rvv80/ima44: ",1)       #MOD-DB0134 mark
                  CALL cl_err_msg("","apm1199",l_rvv.rvv04||"|"||l_rvv.rvv05,10) #MOD-DB0134 add 
               END IF
               LET g_success = 'N' 
               RETURN
            END IF
         END IF

         IF g_ima906 = '3' THEN
            IF l_rvv.rvv85 <> 0 THEN
               LET l_rvv.rvv84=l_rvv.rvv82/l_rvv.rvv85
            ELSE
               LET l_rvv.rvv84=0
            END IF
         END IF
      END IF

     #TQC-C20184 -------------------Begin-------------------- 
     #IF g_sma.sma115='Y' THEN
     #   CALL t110sub_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,l_rvv.rvv85,   
     #                          l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv86,0,'')
     #        RETURNING l_rvv.rvv87
     #ELSE
     #   CALL t110sub_set_rvv87(l_rvv.rvv31,1,0,1,l_rvv.rvv17,  
     #                          l_rvv.rvv86,1,l_rvv.rvv35)
     #        RETURNING l_rvv.rvv87
     #END IF
      IF g_sma.sma115='Y' THEN
      #  IF p_qcl05 = '3' THEN    #驗退        #TQC-C30119 mark
      #  IF p_qcl05 = '3' OR (cl_null(p_qcl05) AND p_chr = 'o') THEN    #TQC-C30119     #FUN-CC0013 mark
         IF cl_null(p_qcl05) AND p_chr = 'o' THEN                                       #FUN-CC0013 add
            CALL t110sub_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,p_out2,
                                   l_rvv.rvv81,p_out1,l_rvv.rvv86,0,'')
                 RETURNING l_rvv.rvv87
         ELSE    #入庫
            CALL t110sub_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,p_in2,
                                   l_rvv.rvv81,p_in1,l_rvv.rvv86,0,'')
                 RETURNING l_rvv.rvv87
         END IF
      ELSE    #不走多單位
      #  IF p_qcl05 = '3' THEN    #驗退        #TQC-C30119 mark
      #  IF p_qcl05 = '3' OR (cl_null(p_qcl05) AND p_chr = 'o') THEN    #TQC-C30119     #FUN-CC0013 mark
         IF cl_null(p_qcl05) AND p_chr = 'o' THEN                                       #FUN-CC0013 add
      #依QC判定產生驗退單和不走QC判定時產生驗退單rvv87的计算方式   
            CALL t110sub_set_rvv87(l_rvv.rvv31,1,0,1,p_out,
                                   l_rvv.rvv86,1,l_rvv.rvv35)
                 RETURNING l_rvv.rvv87
         ELSE    #入庫
      #依QC判定產生入庫單和不走QC判定時rvv87的计算方式
            CALL t110sub_set_rvv87(l_rvv.rvv31,1,0,1,p_in,
                                   l_rvv.rvv86,1,l_rvv.rvv35)
                 RETURNING l_rvv.rvv87 
         END IF
      END IF
     #TQC-C20184 -------------------End-----------------------
   END IF     #不需要檢驗,直接入庫的邏輯結束

   IF cl_null(l_rvv.rvv86) THEN
      LET l_rvv.rvv86 = l_rvv.rvv35   
      IF p_qc = 'N' THEN 
         LET l_rvv.rvv87 = l_rvv.rvv17
      ELSE 
         IF p_qcl05 = '0' THEN 
            LET l_rvv.rvv87 = l_rvv.rvv17  
         END IF 
         #FUN-CC0013 mark begin---
         #IF p_qcl05 = '3' THEN 
         #   LET l_rvv.rvv87 = l_rvv.rvv17 
         #END IF 
         #FUN-CC0013 mark end-----
         IF p_qcl05 = '1' THEN  
            LET l_rvv.rvv87 = l_rvv.rvv17         
         END IF 
         IF p_qcl05 = '2' THEN 
            LET l_rvv.rvv87 = 0
         END IF                
      END IF    
   ELSE
   #入庫量=實收量,收貨計價數量給予入庫數量,避免計價數量在來源是調整後的值
   #而在入庫時又重推值
      IF p_qc = 'N' THEN 
         IF l_rvv.rvv17=p_rvb.rvb07  THEN
            LET l_rvv.rvv87=p_rvb.rvb87
         END IF
      END IF    
   END IF

#TQC-C30119 --------Begin----------
   IF p_qcl05 = '2' THEN
      LET l_rvv.rvv87 = 0
   END IF
#TQC-C30119 --------End------------

   LET l_rvv.rvv36=p_rvb.rvb04     #採購單號
   LET l_rvv.rvv37=p_rvb.rvb03     #採購單序號
   LET l_rvv.rvv38=p_rvb.rvb10
   LET l_rvv.rvv38t=p_rvb.rvb10t   
   LET l_rvv.rvv39=l_rvv.rvv87*l_rvv.rvv38
   LET l_rvv.rvv39t=l_rvv.rvv87*l_rvv.rvv38t   
   LET l_rvv.rvv41=p_rvb.rvb25     #手冊編號 no.A050
   LET l_rvv.rvv930=p_rvb.rvb930  #成本中心 
   LET l_rvv.rvv10 = p_rvb.rvb42
   LET l_rvv.rvv11 = p_rvb.rvb43
   LET l_rvv.rvv12 = p_rvb.rvb44
   LET l_rvv.rvv13 = p_rvb.rvb45
   IF l_rvv.rvv10 IS NULL THEN LET l_rvv.rvv10 = '1' END IF
   LET t_azi04=''            

   IF p_argv6='1' THEN      #收貨類別        
      SELECT azi04 INTO t_azi04  
        FROM pmm_file,azi_file
       WHERE pmm22=azi01
         AND pmm01 = l_rvv.rvv36 #採購單號
         AND pmm18 <> 'X'
   ELSE
      SELECT azi04 INTO t_azi04
        FROM azi_file
       WHERE azi01=g_rva.rva113
   END IF

   IF cl_null(t_azi04) THEN  
      LET t_azi04=0   
   END IF

   CALL cl_digcut(l_rvv.rvv39,t_azi04)  RETURNING l_rvv.rvv39   
   CALL cl_digcut(l_rvv.rvv39t,t_azi04) RETURNING l_rvv.rvv39t 

   IF p_argv6='1' THEN               
      #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題

      SELECT gec05,gec07,pmm43 INTO l_gec05,l_gec07,l_pmm43 FROM gec_file,pmm_file       #MOD-A80052
       WHERE gec01 = pmm21
         AND pmm01 = l_rvv.rvv36
      IF SQLCA.SQLCODE = 100 THEN
      #  CALL cl_err('','mfg3192',0)    #TQC-C40186 mark
      #TQC-C40186 -----------------Begin----------------
         IF g_bgerr THEN 
           #CALL s_errmsg("","","","mfg3192",1) #MOD-D90171 mark
            CALL s_errmsg("","","","mfg3044",1) #MOD-D90171 add
         ELSE 
           #CALL cl_err3("","","","","mfg3192","","",1) #MOD-D90171 mark 
            CALL cl_err3("","","","","mfg3044","","",1) #MOD-D90171 add 
         END IF  
      #TQC-C40186 -----------------End------------------
         LET g_success = 'N' 
         RETURN
      END IF   
      IF l_gec07='Y' THEN
        #IF l_gec05 = 'T' THEN
        IF l_gec05  MATCHES '[AT]' THEN  #FUN-D10128
           LET l_rvw06f = l_rvv.rvv39t * (l_pmm43/100)
           LET l_rvw06f = cl_digcut(l_rvw06f , t_azi04)
           LET l_rvv.rvv39 = l_rvv.rvv39t - l_rvw06f   
           LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)
        ELSE
           LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_pmm43/100)
           LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)
        END IF
      ELSE
         LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + l_pmm43/100)
         LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , t_azi04)
      END IF
   ELSE
      SELECT gec07,gec05 INTO l_gec07,l_gec05 FROM gec_file   
       WHERE gec01 = p_rva.rva115
      IF SQLCA.SQLCODE = 100 THEN
      #  CALL cl_err('','mfg3192',0)  #TQC-C40186 mark
      #TQC-C40186 -----------------Begin----------------
         IF g_bgerr THEN
           #CALL s_errmsg("","","","mfg3192",1) #MOD-D90171 mark
            CALL s_errmsg("","","","mfg3044",1) #MOD-D90171 add
         ELSE
           #CALL cl_err3("","","","","mfg3192","","",1) #MOD-D90171 mark
            CALL cl_err3("","","","","mfg3044","","",1) #MOD-D90171 add
         END IF
      #TQC-C40186 -----------------End------------------
         LET g_success = 'N'
         RETURN
      END IF
      IF l_gec07='Y' THEN
         #IF l_gec05 = 'T' THEN
         IF l_gec05  MATCHES '[AT]' THEN  #FUN-D10128
            LET l_rvw06f = l_rvv.rvv39t * (p_rva.rva116/100)
            LET l_rvw06f = cl_digcut(l_rvw06f , t_azi04)
            LET l_rvv.rvv39 = l_rvv.rvv39t - l_rvw06f
            LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)
         ELSE
            LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + p_rva.rva116/100)
            LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)
         END IF
      ELSE
         LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + p_rva.rva116/100)
         LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , t_azi04)
      END IF
   END IF
   #MOD-E20093 add--------------------------------------------------------------
   IF l_rvv.rvv25 = 'Y' THEN
      LET l_rvv.rvv38 = 0
      LET l_rvv.rvv38t = 0
      LET l_rvv.rvv39 = 0
      LET l_rvv.rvv39t = 0
   END IF
   #MOD-E20093 add end----------------------------------------------------------
   LET l_rvv.rvv40 = 'N'
   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF


   IF s_industry('icd') THEN
      LET l_rvvi.rvviicd07 = p_rvbi.rvbiicd13  #委外TKY非最終站否
      LET l_rvvi.rvviicd03 = p_rvbi.rvbiicd14  #母體料號
      LET l_rvvi.rvviicd05 = p_rvbi.rvbiicd16  #母批
      IF p_argv2 = 'SUB' THEN
         LET l_rvvi.rvviicd01 = p_rvbi.rvbiicd03  #作業編號
         LET l_rvvi.rvviicd02 = p_rvbi.rvbiicd08  #Date Code
         LET l_rvvi.rvviicd04 = p_rvbi.rvbiicd15  #產品型號
         LET l_rvvi.rvviicd06 = p_rvbi.rvbiicd11  #Tape Reel

         #判斷
         #若是產生入庫資料,則入庫異動數量必須等於,
         #    該收貨單刻號明細入庫否='Y'的總異動數量
         #若是產生驗退資料,則驗退異動數量必須等於,
         #    該收貨單刻號明細入庫否='N'的總異動數量
         IF l_rvvi.rvviicd07 ='N' OR cl_null(l_rvvi.rvviicd07) THEN #委外TKY,非最終站不檢查
            CALL t110sub_ind_icd_chk_icdin_yn(l_rvv.*,p_rvu00) 
            IF g_success = 'N' THEN
               RETURN
            END IF
         END IF
      END IF
   END IF 

   LET l_rvv.rvv88 = 0  
   LET l_rvv.rvvlegal = p_rva.rvalegal
   LET l_rvv.rvvplant = g_plant 
   LET l_rvv.rvvlegal = g_legal 
   LET l_rvv.rvv919 = p_rvb.rvb919  
   IF p_qc = 'Y' THEN
      LET l_rvv.rvv45 = p_qco.qco05
      LET l_rvv.rvv46 = p_qco.qco03
      LET l_rvv.rvv47 = p_qco.qco04
   END IF    
#TQC-C70086 add begin----------------      
   IF l_rvv.rvv25 = 'Y' THEN 
      LET l_rvv.rvv38 = 0
      LET l_rvv.rvv38t = 0
      LET l_rvv.rvv39 = 0
      LET l_rvv.rvv39t = 0
   END IF 
#TQC-C70086 add end -----------------
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      SELECT rvu06,rvu07 INTO l_rvu06,l_rvu07 FROM rvu_file WHERE rvu01=l_rvv.rvv01
      CALL s_reason_code(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu07,l_rvu06) RETURNING l_rvv.rvv26
      IF cl_null(l_rvv.rvv26) THEN
         CALL cl_err('','aim-425',1)
         LET g_success = 'N'
      END IF
   END IF
   #FUN-CB0087---add---end---
   INSERT INTO rvv_file VALUES (l_rvv.*)
   IF STATUS THEN
      IF g_bgerr THEN
         LET g_showmsg = l_rvv.rvv01,"/",l_rvv.rvv02
         CALL s_errmsg("rvv01,rvv02",g_showmsg,"i rvv:",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("ins","rvv_file",l_rvv.rvv01,l_rvv.rvv02,STATUS,"","i rvv:",1)
      END IF
      LET g_success='N'
   ELSE
     #IF NOT s_industry('std') AND g_sma.sma150 ='N' THEN    #TQC-E30007 mark  #FUN-D90015 add sma150
      IF NOT s_industry('std') THEN                          #TQC-E30007
         LET l_rvvi.rvvi01=l_rvv.rvv01
         LET l_rvvi.rvvi02=l_rvv.rvv02

         IF NOT s_ins_rvvi(l_rvvi.*,g_plant) THEN 
            LET g_success = 'N'
         END IF

         IF s_industry('icd') THEN 
         ##將收貨單的"刻號/BIN資料已過帳資料"帶入入庫單
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM idd_file
                                      WHERE idd10=l_rvv.rvv04
                                        AND idd11=l_rvv.rvv05
            IF l_cnt>0 THEN
               CALL t110sub_ind_icd_ins_icin(l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv04,
                                          l_rvv.rvv05,p_rvu00)
            END IF
         END IF 
      END IF    
#FUN-D90015 ---------- add ------------ begin ---------------
      IF g_sma.sma150='Y' AND s_industry('slk') THEN                     
         #全收(入庫量=實收量)/全退(驗退量=實收量)情形,才寫入顏色尺寸數量      #FUN-E20026
         IF l_rvv.rvv17=p_rvb.rvb07  THEN                                     #FUN-E20026
            LET l_sql = " INSERT INTO rvvc_file   ",
                        " SELECT '",l_rvv.rvv01,"',",l_rvv.rvv02,", rvbc03,  ",
                        "        rvbc04,rvbc05,rvbc06  ",
                        "   FROM rvbc_file ",
                        "  WHERE rvbc01='",l_rvv.rvv04,"' AND rvbc02 = ",l_rvv.rvv05," "
            PREPARE t110_slk_rvvc1 FROM l_sql
            EXECUTE t110_slk_rvvc1
            #-FUN-E30029-str--
            IF p_rva.rva10='TAP' THEN
               IF p_rvu00 = '2' THEN
                  #LET l_rvbs00 = "apmt741_slk" #FUN-F60033 mark
               ELSE
                  LET l_rvbs00 = "apmt740_slk"
               END IF
            ELSE
            #-FUN-E30029-end--
            #FUN-E30046-----add--begin--------------
               IF p_rva.rva10='SUB' THEN
                  IF p_rvu00 = '2' THEN
                     LET l_rvbs00 = "apmt731_slk"
                  ELSE
                     LET l_rvbs00 = "apmt730_slk"
                  END IF
               ELSE
            #FUN-E30046-----add--end-----------------  
               #FUN-E20026-str--
                  IF p_rvu00 = '2' THEN
                     LET l_rvbs00 = "apmt721_slk"
                  ELSE
                     LET l_rvbs00 = "apmt720_slk"
                  END IF
               #FUN-E20026-end--
               END IF     #FUN-E30046-add 
            END IF   #FUN-E30029
            #同步新增至rvbs_file
            LET l_sql = "  INSERT INTO rvbs_file ",
                       #"  SELECT 'apmt720_slk','",l_rvv.rvv01,"',",l_rvv.rvv02,",rvvc05,rvvc04, ",   #FUN-E20026 mark 
                        "  SELECT '",l_rvbs00,"','",l_rvv.rvv01,"',",l_rvv.rvv02,",rvvc05,rvvc04, ",  #FUN-E20026
                       #"         '",g_today,"',rvvc06,'','",' ',"','",l_rvv.rvv31,"',rvvc03,1, ",            #CHI-E80020 mark
                        "         '",g_today,"',rvvc06*rvv35_fac,'','",' ',"','",l_rvv.rvv31,"',rvvc03,1, ",  #CHI-E80020 add      
                        "         0,0,0,0,'",g_plant,"','",g_legal,"' ",
                       #"    FROM rvvc_file ",             #CHI-E80020 mark
                        "    FROM rvvc_file,rvv_file ",    #CHI-E80020 add
                        "   WHERE rvvc01 = '",l_rvv.rvv01,"' AND rvvc02 = '",l_rvv.rvv02,"' ",
                        "     AND rvv01 = rvvc01 AND rvv02 = rvvc02 "            #CHI-E80020 add
            PREPARE t110_slk_rvbs3 FROM l_sql
            EXECUTE t110_slk_rvbs3
         END IF   #FUN-E20026
      END IF
#FUN-D90015 ---------- add ------------ end -----------------
   END IF
  #FUN-EC0083--add---str--
  #當從aqci107 QC判定產生入庫單時,若QC也有批/序號資料時,
  #入庫單的rvbs_file資料直接由aqci107資料產生
   IF g_sma.sma90 = "Y" AND g_sma.sma150 = 'N' AND p_qc = 'Y' THEN   
       INITIALIZE l_rvbs.* TO NULL    
       SELECT * INTO l_rvbs.*
         FROM rvbs_file
        WHERE rvbs00 MATCHES 'aqc*'
          AND rvbs01 =  p_qco.qco01  #來源單號(qco01)
          AND rvbs02 =  p_qco.qco02  #來源項次(qco02)
          AND rvbs09 =  1            #屬性限制1
          AND rvbs13 =  p_qco.qco05  #分批順序(qco05)
          AND rvbs022 = p_qco.qco022 #QC批序號明細項次 (qco022)
       IF NOT cl_null(l_rvbs.rvbs022) THEN
           IF p_rva.rva10='SUB' THEN
              IF NOT s_industry('icd') THEN 
                 LET l_rvbs.rvbs00 = "apmt730"
              ELSE   
                 LET l_rvbs.rvbs00 = "apmt730_icd"  
              END IF 
           ELSE
              IF p_rva.rva10='TAP' THEN
                 IF NOT s_industry('icd') THEN 
                    LET l_rvbs.rvbs00 = "apmt740"
                 ELSE    
                    LET l_rvbs.rvbs00 = "apmt740_icd"                   
                 END IF 
              ELSE
                 IF p_rvu00 = '2' THEN
                    LET l_rvbs.rvbs00 = "apmt721"
                 ELSE
                    LET l_rvbs.rvbs00 = "apmt720"
                 END IF
                 IF s_industry('slk') THEN 
                    IF p_rvu00 = '2' THEN
                       LET l_rvbs.rvbs00 = "apmt721_slk"   
                    ELSE
                       LET l_rvbs.rvbs00 = "apmt720_slk"
                    END IF
                 END IF    
                 IF s_industry('icd') THEN  
                    IF p_rvu00 = '2' THEN
                       LET l_rvbs.rvbs00 = "apmt721_icd"
                    ELSE
                       LET l_rvbs.rvbs00 = "apmt720_icd"
                    END IF
                 END IF  
              END IF
           END IF
           LET l_rvbs.rvbs01  = l_rvv.rvv01
           LET l_rvbs.rvbs02  = l_rvv.rvv02
           LET l_rvbs.rvbs022 = 1
           LET l_rvbs.rvbs06  = p_qco.qco11
           LET l_rvbs.rvbs10 = 0
           LET l_rvbs.rvbs11 = 0
           LET l_rvbs.rvbs12 = 0
           LET l_rvbs.rvbs13 = 0   
           LET l_rvbs.rvbsplant = g_plant 
           LET l_rvbs.rvbslegal = g_legal 
           INSERT INTO rvbs_file VALUES(l_rvbs.*)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1)
              LET g_success = "N"
           END IF
       END IF
   END IF
  #FUN-EC0083--add---end--

  #IF g_sma.sma90 = "Y" THEN                          #FUN-E20026 mark
  #IF g_sma.sma90 = "Y" AND g_sma.sma150 = 'N' THEN   #FUN-E20026    #FUN-EC0083 mark
   IF g_sma.sma90 = "Y" AND g_sma.sma150 = 'N' AND p_qc = 'N' THEN   #FUN-EC0083 add
      LET l_sql = "SELECT * FROM rvbs_file",
                  " WHERE rvbs00 = '",g_prog,"'",
                  "   AND rvbs01 = '",l_rvv.rvv04,"'",
                  "   AND rvbs02 = ",l_rvv.rvv05,
                  "   AND rvbs09 = 1",
                  "   AND rvbs13 = 0"   
         
      PREPARE t110_rvbs FROM l_sql
      
      DECLARE rvbs_curs CURSOR FOR t110_rvbs
      
      FOREACH rvbs_curs INTO l_rvbs.*
         IF STATUS THEN
            CALL cl_err('foreach rvbs:',STATUS,1)
            EXIT FOREACH
         END IF
         IF p_rva.rva10='SUB' THEN

            IF NOT s_industry('icd') THEN
               #MOD-G30071 add start ---------------
               IF p_rvu00 = '2' THEN
                  LET l_rvbs.rvbs00 = "apmt731"
               ELSE
               #MOD-G30071 add end   ---------------
                  LET l_rvbs.rvbs00 = "apmt730"
               #MOD-G30071 add start ---------------
               END IF     
               IF s_industry('slk') THEN 
                  IF p_rvu00 = '2' THEN
                     LET l_rvbs.rvbs00 = "apmt731_slk"
                  ELSE
                     LET l_rvbs.rvbs00 = "apmt730_slk"
                  END IF
               END IF
               #MOD-G30071 add end   ---------------
            ELSE   
               #MOD-G30071 add start ---------------
               IF p_rvu00 = '2' THEN
                  LET l_rvbs.rvbs00 = "apmt731_icd"
               ELSE
               #MOD-G30071 add end   ---------------
                  LET l_rvbs.rvbs00 = "apmt730_icd"
               END IF    #G30071 add  
            END IF 
         ELSE
            IF p_rva.rva10='TAP' THEN
               IF NOT s_industry('icd') THEN 
                  LET l_rvbs.rvbs00 = "apmt740"
               ELSE    
                  LET l_rvbs.rvbs00 = "apmt740_icd"                   
               END IF 
            ELSE

               IF p_rvu00 = '2' THEN
                  LET l_rvbs.rvbs00 = "apmt721"
               ELSE
                  LET l_rvbs.rvbs00 = "apmt720"
               END IF


               IF s_industry('slk') THEN 

                  IF p_rvu00 = '2' THEN
                   # LET l_rvbs.rvbs00 = "apmt721"       #FUN-E30046--mark
                     LET l_rvbs.rvbs00 = "apmt721_slk"   #FUN-E30046--add
                  ELSE
                     LET l_rvbs.rvbs00 = "apmt720_slk"
                  END IF
               END IF    
               IF s_industry('icd') THEN  
                  IF p_rvu00 = '2' THEN
                     LET l_rvbs.rvbs00 = "apmt721_icd"
                  ELSE
                     LET l_rvbs.rvbs00 = "apmt720_icd"
                  END IF
               END IF  
            END IF
         END IF

         LET l_rvbs.rvbs01 = l_rvv.rvv01
         LET l_rvbs.rvbs02 = l_rvv.rvv02

         IF p_rvu00 = '2' THEN
            LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs.rvbs10
         ELSE
            IF l_rvbs.rvbs10 > 0 THEN
               #異動數量=允收量-入庫量
               LET l_rvbs.rvbs06 = l_rvbs.rvbs10 - l_rvbs.rvbs11
            END IF
         END IF  
#TQC-CA0049 -------------------- add ------------------ begin #判斷對應的批序號質量檢驗是否通過審核
         IF p_rvu00 = '2' THEN
            LET l_qcs09 = '2'
         ELSE
            LET l_qcs09 = '1'
         END IF
         SELECT ima24 INTO l_ima24 FROM ima_file WHERE ima01 = l_rvbs.rvbs021
         IF l_ima24 = 'Y' AND g_sma.sma886[6,6] = 'Y' THEN
            #MOD-G40139 add start --------------
            #先判斷QC資料是否有新的特採批序號資料
            LET l_newqc_flag = 'N'
            LET l_cnt1 = 0 
            SELECT COUNT(*) INTO l_cnt1 FROM rvbs_file,qcs_file
             WHERE qcs01 = rvbs01
               AND qcs02 = rvbs02
               AND qcs05 = rvbs13
               AND rvbs00 = 'aqct110-3'
               AND rvbs01 = l_rvv.rvv04
               AND rvbs02 = l_rvv.rvv05
               AND rvbs022 = l_rvbs.rvbs022
               AND rvbs09 = l_rvbs.rvbs09
               AND qcs14 = 'Y'
               AND qcs09 = '3'
            IF l_cnt1 > 0 THEN LET l_newqc_flag = 'Y' END IF
            IF l_newqc_flag = 'N' THEN        #批序號特採舊有做法
            #MOD-G40139 add end   --------------
               IF p_rvu00 = '1' THEN                  #MOD-G30071 add
                  SELECT SUM(rvbs06) INTO l_sum_rvbs06 FROM rvbs_file,qcs_file
                   WHERE qcs01 = rvbs01
                     AND qcs02 = rvbs02
                     AND qcs05 = rvbs13
                     AND rvbs00 = 'aqct110'
                     AND rvbs01 = l_rvv.rvv04
                     AND rvbs02 = l_rvv.rvv05
                     AND rvbs022 = l_rvbs.rvbs022
                     AND rvbs09 = l_rvbs.rvbs09
                     AND qcs14 = 'Y'
                    #AND qcs09 = l_qcs09              #MOD-G30071 mark 
               #MOD-G30071 add start ------------------------
                     AND(qcs09 = l_qcs09 OR qcs09 = '3')  
                  IF cl_null(l_sum_rvbs06) THEN LET l_sum_rvbs06 = 0 END IF    #MOD-G40139 add 
               ELSE 
                  #若QC判定驗退則rvbs06=批序號驗退量,若為特採,則rvbs06=批序號合格量,
                  #因此須由收貨單的rvbs06收貨數量-特採合格量,推算驗退量(此算法需該收貨單項次收貨數量已全數檢驗)
                  LET l_cnt1 = 0 
                  SELECT COUNT(*) INTO l_cnt1 FROM qcs_file WHERE qcs01 = l_rvv.rvv04 AND qcs02 = l_rvv.rvv05 AND qcs09 = '3'
                  #若有特採才需執行以下作業
                  IF l_cnt1 > 0 THEN
                     SELECT SUM(qcs22) INTO l_qcs22 FROM qcs_file WHERE qcs01 = l_rvv.rvv04 AND qcs02 = l_rvv.rvv05 AND qcs14 = 'Y'  #已送驗量
                     SELECT rvb07 INTO l_rvb07 FROM rvb_file WHERE rvb01 = l_rvv.rvv04 AND rvb02 = l_rvv.rvv05                       #收貨量
                     IF l_qcs22 = l_rvb07 THEN   #必須該收貨項次已全數檢驗,才能推算驗退量
                        SELECT SUM(rvbs06) INTO l_sum_rvbs06_1 FROM rvbs_file,qcs_file 
                         WHERE qcs01 = rvbs01
                           AND qcs02 = rvbs02
                           AND qcs05 = rvbs13
                           AND rvbs00 = 'aqct110'
                           AND rvbs01 = l_rvv.rvv04
                           AND rvbs02 = l_rvv.rvv05
                           AND rvbs022 = l_rvbs.rvbs022
                           AND rvbs09 = l_rvbs.rvbs09
                           AND qcs14 = 'Y'
                           AND(qcs09 = '1' OR qcs09 = '3')

                        SELECT rvbs06 INTO l_rvbs.rvbs06 FROM rvbs_file 
                         WHERE rvbs01 = l_rvv.rvv04 AND rvbs02 = l_rvv.rvv05 
                           AND rvbs03 = l_rvbs.rvbs03 
                           AND rvbs04 = l_rvbs.rvbs04
                           AND rvbs08 = l_rvbs.rvbs08
                           AND rvbs022= l_rvbs.rvbs022
                           AND rvbs13 = 0                #批序號收貨量
                     
                        IF cl_null(l_sum_rvbs06_1) THEN LET l_sum_rvbs06_1 = 0 END IF       #MOD-G40139 add
                        LET l_sum_rvbs06 = l_rvbs.rvbs06 - l_sum_rvbs06_1  #驗退量 = 收貨量 - 合格量 
                     END IF
                  ELSE
                     SELECT SUM(rvbs06) INTO l_sum_rvbs06 FROM rvbs_file,qcs_file
                      WHERE qcs01 = rvbs01
                        AND qcs02 = rvbs02
                        AND qcs05 = rvbs13
                        AND rvbs00 = 'aqct110'
                        AND rvbs01 = l_rvv.rvv04
                        AND rvbs02 = l_rvv.rvv05
                        AND rvbs022 = l_rvbs.rvbs022
                        AND rvbs09 = l_rvbs.rvbs09
                        AND qcs14 = 'Y'
                        AND qcs09 = l_qcs09                  
                     IF cl_null(l_sum_rvbs06) THEN LET l_sum_rvbs06 = 0 END IF    #MOD-G40139 add 
                  END IF 
               END IF            
               #MOD-G30071 add end   ------------------------
            #MOD-G40139 add start -----------------------------
            #特採時會多產生一筆批序號資料作法
            ELSE
               LET l_sum1_rvbs06 = 0
               LET l_sum3_rvbs06 = 0 
               IF p_rvu00 = '1' THEN    
                  #QC合格數             
                  SELECT SUM(rvbs06) INTO l_sum1_rvbs06 FROM rvbs_file,qcs_file
                   WHERE qcs01 = rvbs01
                     AND qcs02 = rvbs02
                     AND qcs05 = rvbs13
                     AND rvbs00 = 'aqct110' 
                     AND rvbs01 = l_rvv.rvv04
                     AND rvbs02 = l_rvv.rvv05
                     AND rvbs022 = l_rvbs.rvbs022
                     AND rvbs09 = l_rvbs.rvbs09
                     AND qcs14 = 'Y'
                     AND qcs09 = l_qcs09   
                  #QC特採合格數
                  SELECT SUM(rvbs06) INTO l_sum3_rvbs06 FROM rvbs_file,qcs_file
                   WHERE qcs01 = rvbs01
                     AND qcs02 = rvbs02
                     AND qcs05 = rvbs13
                     AND rvbs00 = 'aqct110-3' 
                     AND rvbs01 = l_rvv.rvv04
                     AND rvbs02 = l_rvv.rvv05
                     AND rvbs022 = l_rvbs.rvbs022
                     AND rvbs09 = l_rvbs.rvbs09
                     AND qcs14 = 'Y'
                     AND qcs09 = '3'  
                  IF cl_null(l_sum1_rvbs06) THEN LET l_sum1_rvbs06 = 0 END IF
                  IF cl_null(l_sum3_rvbs06) THEN LET l_sum3_rvbs06 = 0 END IF 
                  LET l_sum_rvbs06 = l_sum1_rvbs06 + l_sum3_rvbs06 
               ELSE
                  #QC驗退量+特採送驗量 
                  SELECT SUM(rvbs06) INTO l_sum1_rvbs06 FROM rvbs_file,qcs_file
                   WHERE qcs01 = rvbs01
                     AND qcs02 = rvbs02
                     AND qcs05 = rvbs13
                     AND rvbs00 = 'aqct110'
                     AND rvbs01 = l_rvv.rvv04
                     AND rvbs02 = l_rvv.rvv05
                     AND rvbs022 = l_rvbs.rvbs022
                     AND rvbs09 = l_rvbs.rvbs09
                     AND qcs14 = 'Y'
                     AND (qcs09 = l_qcs09 OR qcs09 = '3')       
                  #QC特採合格量
                  SELECT SUM(rvbs06) INTO l_sum3_rvbs06 FROM rvbs_file,qcs_file
                   WHERE qcs01 = rvbs01
                     AND qcs02 = rvbs02
                     AND qcs05 = rvbs13
                     AND rvbs00 = 'aqct110-3'
                     AND rvbs01 = l_rvv.rvv04
                     AND rvbs02 = l_rvv.rvv05
                     AND rvbs022 = l_rvbs.rvbs022
                     AND rvbs09 = l_rvbs.rvbs09
                     AND qcs14 = 'Y'
                     AND qcs09 = '3'
                  IF cl_null(l_sum1_rvbs06) THEN LET l_sum1_rvbs06 = 0 END IF
                  IF cl_null(l_sum3_rvbs06) THEN LET l_sum3_rvbs06 = 0 END IF 
                  LET l_sum_rvbs06 = l_sum1_rvbs06 - l_sum3_rvbs06
               END IF 
            END IF
            #MOD-G40139 add end   -----------------------------
            IF g_sma.sma886[8]='Y' THEN           #MOD-G60115 add
               LET l_rvbs.rvbs06 = l_sum_rvbs06
            END IF                                #MOD-G60115 add
            IF cl_null(l_rvbs.rvbs06) THEN LET l_rvbs.rvbs06 = 0 END IF
            IF l_rvbs.rvbs06 = 0 THEN  CONTINUE FOREACH END IF  ##TQC-CA0049 add
            IF p_rvu00 ='2' THEN
               LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs.rvbs12
            ELSE
               LET l_rvbs.rvbs06 = l_rvbs.rvbs06 - l_rvbs.rvbs11
            END IF
         END IF
#TQC-CA0049 -------------------- add ------------------ end

         #MOD-G50065 add start ------------
         IF p_rvu00 = '2' THEN
            LET l_rvbs.rvbs09 = -1
         ELSE 
            LET l_rvbs.rvbs09 = 1 
         END IF
         #MOD-G50065 add end   ------------
         LET l_rvbs.rvbs10 = 0

         LET l_rvbs.rvbs11 = 0

         LET l_rvbs.rvbs12 = 0

         LET l_rvbs.rvbs13 = 0   

         LET l_rvbs.rvbsplant = g_plant 
         LET l_rvbs.rvbslegal = g_legal 
         INSERT INTO rvbs_file VALUES(l_rvbs.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rvbs_file",l_rvbs.rvbs01,l_rvbs.rvbs02,SQLCA.sqlcode,"","",1)
            LET g_success = "N"
            CONTINUE FOREACH
         END IF
      END FOREACH
   END IF  

   IF s_industry('icd') THEN 
   #-->若為委外收貨單,產生入庫資料後,重新給予入庫計價數量,單價,金額
      CALL t110sub_ind_icd_upd_rvvxx(l_rvv.*)
   END IF          
END FUNCTION

FUNCTION t110sub_ind_icd_upd_rvvxx(l_rvv) 
   DEFINE l_rvv       RECORD LIKE rvv_file.*
   DEFINE l_rvb       RECORD LIKE rvb_file.*
   DEFINE l_rvbi      RECORD LIKE rvbi_file.*
   DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01
   DEFINE l_icg27     LIKE icg_file.icg27
   DEFINE p_argv2     LIKE rva_file.rva10      #採購類別

   #1.計價數量(rvv87)= rvb87
   #2.金額(rvv39)
   #2-1.FT金額:
   #   [可允收數(rvb33) + 不良品數(rvbiicd06)] * 採購單價 +
   #   [可允收數(rvb33) *  Lead Scan Price(icg27)]
   #   Lead Scan Price: 以最終料號(rvbiicd15)+廠商(rvu04)+
   #                    作業編號(rvbiicd03)帶出
   #2-2.其他金額: 比照Package

   #3.單價(rvv38)
   #3-1.FT單價 = 金額(rvv39)/ 計價數量(rvv87)
   #3-2.其他單價: 比照Package

   IF p_argv2!= 'SUB' THEN RETURN END IF
   IF l_rvv.rvv03 != '1' THEN RETURN END IF
   IF g_success = 'N' THEN RETURN END IF

   INITIALIZE l_rvb.* TO NULL
   SELECT * INTO l_rvb.* FROM rvb_file
      WHERE rvb01 = l_rvv.rvv04
        AND rvb02 = l_rvv.rvv05

   INITIALIZE l_rvbi.* TO NULL
   SELECT * INTO l_rvbi.* FROM rvbi_file
      WHERE rvbi01 = l_rvb.rvb01
        AND rvbi02 = l_rvb.rvb02
        
#計價數量的賦值問題(行業別代碼段)
   LET l_rvv.rvv87 = l_rvb.rvb87       #計價數量
   #-->取得作業群組
   LET l_ecdicd01 = ''
   SELECT ecdicd01 INTO l_ecdicd01
     FROM ecd_file
    WHERE ecd01 = l_rvbi.rvbiicd03

   IF l_ecdicd01 = '5' THEN
      #-->取得Lead Scan Price
      SELECT icg27 INTO l_icg27
         FROM icg_file
        WHERE icg01 = l_rvbi.rvbiicd15 #最終料號
          AND icg02 = g_rva.rva05      #廠商
          AND icg03 = l_rvbi.rvbiicd03 #作業編號
      IF cl_null(l_icg27) THEN LET l_icg27 = 0 END IF
      LET l_rvv.rvv39 = (l_rvb.rvb33 + l_rvbi.rvbiicd06)*l_rvb.rvb10 +
                        (l_rvb.rvb33 * l_icg27)
      LET l_rvv.rvv38 = l_rvv.rvv39 / l_rvv.rvv87
   END IF
   
   UPDATE rvv_file SET rvv87 = l_rvv.rvv87,
                       rvv38 = l_rvv.rvv38,
                       rvv39 = l_rvv.rvv39
      WHERE rvv01 = l_rvv.rvv01
        AND rvv02 = l_rvv.rvv02
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('upd rvv87',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION 


FUNCTION t110sub_ind_icd_ins_icin(p_rvv01,p_rvv02,p_rvv04,p_rvv05,p_rvu00)
   DEFINE p_rvv01       LIKE rvv_file.rvv01
   DEFINE p_rvv02       LIKE rvv_file.rvv02
   DEFINE p_rvv04       LIKE rvv_file.rvv04
   DEFINE p_rvv05       LIKE rvv_file.rvv05
   DEFINE l_ida     RECORD LIKE ida_file.*
   DEFINE l_idd      RECORD LIKE idd_file.*
   DEFINE p_rvu00       LIKE type_file.chr1     #Y:入庫 N:驗退

  IF p_rvu00 = '1' THEN LET p_rvu00 = 'Y' END IF
  IF p_rvu00 = '2' THEN LET p_rvu00 = 'N' END IF

  DECLARE t110_ins_icin_cs CURSOR FOR
     SELECT * INTO l_idd.* FROM idd_file
       WHERE idd10 = p_rvv04
         AND idd11 = p_rvv05
         AND idd12 = 0
         AND idd24 = 'Y' #p_rvu00  #入庫否
         AND idd12 = 0        #收貨
  FOREACH t110_ins_icin_cs INTO l_idd.*
     INITIALIZE l_ida.* TO NULL
     LET l_ida.ida01 = l_idd.idd01    #料號
     LET l_ida.ida02 = l_idd.idd02    #倉庫
     LET l_ida.ida03 = l_idd.idd03    #儲位
     LET l_ida.ida04 = l_idd.idd04    #批號
     LET l_ida.ida05 = l_idd.idd05    #刻號
     LET l_ida.ida06 = l_idd.idd06    #BIN
     LET l_ida.ida07 = p_rvv01              #單據編號
     LET l_ida.ida08 = p_rvv02              #單據項次
     LET l_ida.ida09 = l_idd.idd08    #異動日期
     LET l_ida.ida10 = l_idd.idd13    #實收數量
     LET l_ida.ida11 = l_idd.idd26    #不良數量
     LET l_ida.ida12 = l_idd.idd27    #報廢數量
     LET l_ida.ida13 = l_idd.idd07    #單位
     LET l_ida.ida14 = l_idd.idd15    #母體料號
     LET l_ida.ida15 = l_idd.idd16    #母批
     LET l_ida.ida16 = l_idd.idd17    #DATECODE
     LET l_ida.ida17 = l_idd.idd18    #DIES 數
     LET l_ida.ida18 = l_idd.idd19    #YIELD
     LET l_ida.ida19 = l_idd.idd20    #TEST #
     LET l_ida.ida20 = l_idd.idd21    #DEDUCT
     LET l_ida.ida21 = l_idd.idd22    #PASSBIN
     LET l_ida.ida22 = l_idd.idd23    #接單料號
     LET l_ida.ida27 = 'N'                   #轉入否
     IF p_rvu00 = 'Y' THEN LET l_ida.ida28 = 1 END IF
     IF p_rvu00 = 'N' THEN LET l_ida.ida28 = 0 END IF
     LET l_ida.ida29 = l_idd.idd25   #備註
     LET l_ida.ida30 = p_rvv04
     LET l_ida.ida31 = p_rvv05

     LET l_ida.idaplant = g_plant #NO.FUN-980006 jarlin add
     LET l_ida.idalegal = g_legal #NO.FUN-980006 jarlin add
     INSERT INTO ida_file VALUES(l_ida.*)
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('ins ida_file for rvv',SQLCA.sqlcode,1)
        LET g_success='N'
        RETURN
     END IF
   END FOREACH
END FUNCTION

#服飾行業別下的倉儲批的處理
#FUN-C20006--add--begin--
FUNCTION t110sub_add_img(l_rva)
  DEFINE l_rva     RECORD LIKE rva_file.*
  DEFINE l_rvb     RECORD LIKE rvb_file.*,
         l_n              LIKE type_file.num5

      DECLARE t110_img CURSOR FOR
         SELECT * FROM rvb_file WHERE rvb01=l_rva.rva01
     
      LET l_n = 0
      FOREACH t110_img INTO l_rvb.*
        SELECT COUNT(*) INTO l_n FROM img_file
          WHERE img01 = l_rvb.rvb05
            AND img02 = l_rvb.rvb36
            AND img03 = l_rvb.rvb37
            AND img04 = l_rvb.rvb38
         IF l_n = 0 AND (NOT cl_null(l_rvb.rvb36)) THEN   
            IF g_sma.sma892[3,3] ='Y' THEN
               IF cl_confirm('mfg1401') THEN
                  CALL s_add_img(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,
                                 l_rvb.rvb38,l_rva.rva01,l_rvb.rvb02,
                                 l_rva.rva06)
               END IF
            ELSE
               CALL s_add_img(l_rvb.rvb05,l_rvb.rvb36,l_rvb.rvb37,
                              l_rvb.rvb38,l_rva.rva01,l_rvb.rvb02,
                              l_rva.rva06)
            END IF
         END IF
      END FOREACH

END FUNCTION
#FUN-C20006--add--end--
#FUN-BC0104 ---------------------End------------------


#DEV-D30045--add--begin
FUNCTION t110sub_barcode_gen(p_rva01,p_ask)
   DEFINE p_rva01   LIKE rva_file.rva01
   DEFINE p_ask     LIKE type_file.chr1
   DEFINE l_rva     RECORD LIKE rva_file.*

   IF cl_null(p_rva01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_rva.* FROM rva_file WHERE rva01 = p_rva01

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('K',l_rva.rva01,'','') THEN
      RETURN
   END IF

   IF p_ask = 'Y' THEN   #DEV-D40015 add
   IF l_rva.rvaconf = 'N' THEN
      CALL cl_err('','sfb-999',0)
      LET g_success = 'N'
      RETURN
   END IF
   END IF       #DEV-D40015 add

   IF l_rva.rvaconf = 'X' THEN
      CALL cl_err('','sfb-998',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk(l_rva.rva01) THEN
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
   CALL t110sub_lock_cl()

   OPEN t110sub_cl USING l_rva.rva01
   IF STATUS THEN
      CALL cl_err("OPEN t110sub_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t110sub_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t110sub_cl INTO l_rva.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_rva.rva01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t110sub_cl
      ROLLBACK WORK
      RETURN
   END IF

   #DEV-D30043--mark--begin
   #IF NOT s_diy_barcode(l_rva.rva01,'','','K') THEN
   #   LET g_success = 'N'
   #END IF
   #
   #IF g_success = 'Y' THEN
   #   CALL s_gen_barcode2('K',l_rva.rva01,'','')
   #END IF
   #DEV-D30043--mark--end

   #DEV-D30043--add--begin
   IF g_success = 'Y' THEN
      CALL s_gen_barcode2('K',l_rva.rva01,'','')
   END IF

   IF g_success = 'Y' THEN
      IF NOT s_diy_barcode(l_rva.rva01,'','','K') THEN
         LET g_success = 'N'
      END IF
   END IF
   #DEV-D30043--add--end

  #DEV-D40015 add str-------               
   IF g_success = 'Y' THEN
      CALL t110sub_chk_ima(l_rva.rva01,'I')
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

FUNCTION t110sub_barcode_z(p_rva01,p_inTransaction) #DEV-D40015--add p_inTransaction
   DEFINE p_rva01   LIKE rva_file.rva01
   DEFINE p_inTransaction  LIKE type_file.num5      #DEV-D40015--add
   DEFINE l_rva     RECORD LIKE rva_file.*
   DEFINE l_srg02   LIKE srg_file.srg02
   DEFINE l_srg03   LIKE srg_file.srg03
   DEFINE l_srg05   LIKE srg_file.srg05
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima919  LIKE ima_file.ima919
   DEFINE l_ima920  LIKE ima_file.ima920
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_ima922  LIKE ima_file.ima922
   DEFINE l_ima923  LIKE ima_file.ima923
   DEFINE l_ima931  LIKE ima_file.ima931
   DEFINE l_ima933  LIKE ima_file.ima933
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_sql     STRING

   IF cl_null(p_rva01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT * INTO l_rva.* FROM rva_file WHERE rva01 =p_rva01 

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('K',l_rva.rva01,'','') THEN
      RETURN
   END IF

   IF l_rva.rvaconf = 'X' THEN
      CALL cl_err(' ','9024',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk2(l_rva.rva01) THEN 
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
   CALL t110sub_lock_cl()

   OPEN t110sub_cl USING l_rva.rva01
   IF STATUS THEN
      CALL cl_err("OPEN t110sub_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t110sub_cl
      #DEV-D40015--add--begin
      #ROLLBACK WORK
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF 
      #DEV-D40015--add--end
      RETURN
   END IF
   FETCH t110sub_cl INTO l_rva.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_rva.rva01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t110sub_cl
      #DEV-D40015--add--begin
      #ROLLBACK WORK
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF 
      #DEV-D40015--add--end
      RETURN
   END IF

   #DEV-D40015--add--begin
   #先刪除,再作廢條碼
   IF g_success='Y' THEN
      CALL t110sub_chk_ima(l_rva.rva01,'D')
   END IF
   #DEV-D40015--add--end

   IF g_success='Y' THEN
      CALL s_barcode_x2('K',l_rva.rva01,'','')
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
#DEV-D30045--add--end

#DEV-D40015 add str--------
FUNCTION t110sub_chk_ima(p_rvb01,p_type)
   DEFINE p_rvb01    LIKE   rva_file.rva01
   DEFINE p_type     LIKE   rva_file.rva01  #I:新增 D:刪除
   DEFINE l_sql      STRING
   DEFINE l_ima01    LIKE   ima_file.ima01
   
   LET l_sql = " SELECT DISTINCT b.ima01 ",
               "   FROM rvb_file a         ",
               "  INNER JOIN ima_file b ON a.rvb05 = b.ima01 ",
               "                       AND b.ima930= 'Y' ",
               "                       AND b.ima932= 'K'",
               "  WHERE a.rvb01 = '",p_rvb01,"'" 

   PREPARE t110_chkima_pre FROM l_sql
   DECLARE t110_chkima_cur CURSOR FOR t110_chkima_pre

   FOREACH t110_chkima_cur INTO l_ima01  
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach t110_chkima_cur:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF  
 
      CASE
         WHEN p_type = 'I'
            CALL s_ibb_ins_rvbs(g_prog,p_rvb01,l_ima01)
         WHEN p_type = 'D'
            CALL s_ibb_del_rvbs(g_prog,p_rvb01,l_ima01)
      END CASE
   END FOREACH
END FUNCTION
#DEV-D40015 add end--------

#DEV-D40021 --add--str
FUNCTION t110sub_g(p_rva01,p_ask_flag,p_argv2,p_argv6)
   DEFINE l_rvb33  LIKE rvb_file.rvb33
   DEFINE l_flag   LIKE type_file.num5     #No.FUN-680136 SMALLINT
   DEFINE l_factor LIKE qcs_file.qcs31
   DEFINE l_ima906 LIKE ima_file.ima906
   DEFINE l_g_already LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   DEFINE l_smy57     LIKE type_file.chr1,   #MOD-740033 add  #MOD-7B0145 modify
          l_t         LIKE smy_file.smyslip  #MOD-740033 add
   DEFINE l_rvb02  LIKE rvb_file.rvb02  #FUN-810038
   DEFINE l_pmn16     LIKE pmn_file.pmn16    #采購單單身狀況碼   #TQC-880009 add
   DEFINE l_qcs091    LIKE qcs_file.qcs091   #合格量
   DEFINE l_qcs38     LIKE qcs_file.qcs38    #合格量   #MOD-A70160
   DEFINE l_qcs41     LIKE qcs_file.qcs41    #合格量   #MOD-A70160
   DEFINE l_qcs22     LIKE qcs_file.qcs22    #送驗量(判定結果位驗退時為驗退量) 
   DEFINE l_qcs32     LIKE qcs_file.qcs32    #送驗量(判定結果位驗退時為驗退量)    #MOD-A70160
   DEFINE l_qcs35     LIKE qcs_file.qcs35    #送驗量(判定結果位驗退時為驗退量)    #MOD-A70160
   DEFINE l_in        LIKE rvb_file.rvb07    #全部入庫量，包括未審核
   DEFINE l_in1       LIKE rvb_file.rvb82    #全部入庫量，包括未審核   #MOD-A70160
   DEFINE l_in2       LIKE rvb_file.rvb85    #全部入庫量，包括未審核   #MOD-A70160
   DEFINE l_out       LIKE rvb_file.rvb07    #全部驗退量，包括未審核
   DEFINE l_out1      LIKE rvb_file.rvb82    #全部驗退量，包括未審核   #MOD-A70160
   DEFINE l_out2      LIKE rvb_file.rvb85    #全部驗退量，包括未審核   #MOD-A70160
   DEFINE l_smy74     LIKE smy_file.smy74    #FUN-A80026   ##FUN-B30161 mark   #TQC-B40081 unmark
#  DEFINE l_sma91     LIKE sma_file.sma91    #FUN-B30161   #TQC-B40081 unmark  #TQC-B60252 mark
   DEFINE l_smyslip   LIKE smy_file.smyslip  #FUN-A80026
   DEFINE l_smydmy4   LIKE smy_file.smydmy4    #MOD-AB0244
   DEFINE l_smyapr    LIKE smy_file.smyapr     #FUN-A60009 add 
   DEFINE l_action_choice  STRING            #MOD-B80272 add
   DEFINE l_qco       RECORD LIKE qco_file.* #TQC-C20196
   DEFINE l_msg       STRING   #FUN-C40015
   DEFINE l_msg1      STRING   #FUN-C40015
   DEFINE l_pmm02     LIKE pmm_file.pmm02    #TQC-C80120 add
   #DEV-D40021 --add--str
   DEFINE p_rva01      LIKE rva_file.rva01
   DEFINE p_ask_flag   LIKE type_file.chr1
   DEFINE p_argv2      LIKE rva_file.rva10
   DEFINE p_argv6      LIKE rva_file.rva00
   DEFINE g_in         LIKE rvv_file.rvv17   #No.MOD-8A0112 #本次可入庫量
   DEFINE g_in1        LIKE rvv_file.rvv82   #MOD-A70160
   DEFINE g_in2        LIKE rvv_file.rvv85   #MOD-A70160
   DEFINE g_out        LIKE rvv_file.rvv17   #No.MOD-8A0112 #本次可驗退量
   DEFINE g_out1       LIKE rvv_file.rvv82   #MOD-A70160
   DEFINE g_out2       LIKE rvv_file.rvv85   #MOD-A70160
   DEFINE l_rvu01_1    LIKE rvu_file.rvu01
   DEFINE l_rvu01_2    LIKE rvu_file.rvu01 
   DEFINE l_rvb        RECORD LIKE rvb_file.*
   DEFINE l_rvbi       RECORD LIKE rvbi_file.*
   DEFINE l_rva        RECORD LIKE rva_file.*
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_sfb93      LIKE sfb_file.sfb93
   #DEV-D40021 --add--end
   DEFINE l_qc_flag    LIKE type_file.chr1 #CHI-D60028 add
   DEFINE l_qc_cnt     LIKE type_file.num5 #CHI-D60028 add

   #DEV-D40021 --add--str
   SELECT * INTO l_rva.* FROM rva_file WHERE rva01 = p_rva01
   #DEV-D40021 --add--end
   
   
   IF l_rva.rvaconf !='Y' THEN  
      CALL cl_err('','aap-717',1)
      RETURN
   END IF
 
   IF cl_null(l_rva.rva01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   #FUN-E80075 add str
   CALL s_chk_pmc05(l_rva.rva05)
   IF NOT cl_null(g_errno) THEN
      ##---- 20220825 modify (S)
      SELECT COUNT(*) INTO l_cnt FROM pmc_file
       WHERE pmc01 = l_rva.rva05
         AND pmc05 = '2'
      IF l_cnt = 1 THEN
         CALL cl_err(l_rva.rva05,'cpm-025',0)
         LET g_errno = ''
      ELSE
         CALL cl_err(l_rva.rva05,g_errno,1)
         RETURN
      END IF
      ##---- 20220825 modify (E)
   END IF
   #FUN-E80075 add end
 
   IF p_ask_flag = 'Y' THEN    #DEV-D40021 --add
   IF NOT cl_confirm('apm-113') THEN
      RETURN
   END IF
   END IF   #DEV-D40021 --add

   ###---- 20180403 mark by momo 可分批檢驗入庫，不應卡整張收貨單 
   #   IF g_sma.sma886[6,6]='Y' THEN
   #      LET l_cnt = 0
   #      SELECT COUNT(*) INTO l_cnt
   #        FROM rvb_file
   #       WHERE rvb01 = l_rva.rva01
   #         AND rvb39 = 'Y'
   #         AND (rvb40 IS NULL OR rvb40 = '') #No:7607
   #      IF l_cnt >=1 THEN
   #         #(asms250)須檢驗收料需由品管確認才可入庫,但是本收貨單尚有料件未經品管確認
   #         CALL cl_err('','apm-126',1)
   #         RETURN
   #      END IF
   #   END IF
   ###----- 20180403 mark by momo

   BEGIN WORK
   LET g_success = 'Y'    #No.MOD-890074
   LET g_totsuccess = 'Y' #No.MOD-890074
 
   DECLARE t110_irvu CURSOR FOR SELECT * FROM rvb_file
                                 WHERE rvb01=l_rva.rva01
                                 ORDER BY rvb02
 
   LET l_g_already = 'Y'
   LET l_rvu01_1 = NULL
   LET l_rvu01_2 = NULL
   LET l_qc_cnt = 0    #CHI-D60028 add
 
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH t110_irvu INTO l_rvb.*
      LET l_qc_flag = 'N' #CHI-D60028 add
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF

     #CHI-D60028 add start -----
     #IF t110sub_qc_ck(l_rvb.rvb01) THEN             #MOD-D70118 mark
      IF t110sub_qc_ck(l_rvb.rvb01,l_rvb.rvb02) THEN #MOD-D70118 add
         IF t110sub_qc_item(l_rvb.rvb01,l_rvb.rvb05,'Y') THEN
            LET l_qc_flag = 'Y'
            LET l_qc_cnt = l_qc_cnt + 1 
         END IF
      END IF 
     #CHI-D60028 add end   -----

      IF s_industry('icd') THEN    #DEV-D40021 --add
      #&ifdef ICD
         SELECT * INTO l_rvbi.* FROM rvbi_file
          WHERE rvbi01=l_rvb.rvb01  #CHI-920064
            AND rvbi02=l_rvb.rvb02  #CHI-920064
      #&endif
      END IF    #DEV-D40021 --add
 
      SELECT pmn16 INTO l_pmn16 FROM pmn_file  #采購單
       WHERE pmn01 = l_rvb.rvb04
         AND pmn02 = l_rvb.rvb03

      IF l_pmn16 != '2' THEN
         LET g_showmsg =  l_rvb.rvb04,"-",l_rvb.rvb03 
         CALL cl_err(g_showmsg,'mfg3166',1)   
         CONTINUE FOREACH  
      END IF    
 
      LET l_n = 0
      LET l_t = s_get_doc_no(l_rvb.rvb01)
 
      SELECT smy57[3,3] INTO l_smy57 FROM smy_file
       WHERE smyslip=l_t
 
      IF l_smy57='N' THEN
      ELSE
#MOD-B40185 --begin--
#        #----單身
#        SELECT COUNT(*) INTO l_n FROM rvv_file
#         WHERE rvv04=l_rvb.rvb01  #收貨單號
#           AND rvv05=l_rvb.rvb02  #收貨項次
         SELECT COUNT(*) INTO l_n FROM rvv_file,rvu_file
          WHERE rvv04 = l_rvb.rvb01
            AND rvv05 = l_rvb.rvb02
            AND rvv01 = rvu01
            AND rvuconf != 'X' 
#MOD-B40185 --end--
      END IF   #MOD-740033 add
     
      IF l_n >= 1 THEN
         CONTINUE FOREACH
      END IF
     
     #DEV-D60003 add str---------
      #&ifdef ICD
      IF (((l_rvbi.rvbiicd13 = 'N') OR 
           (l_rvbi.rvbiicd13=' ')   OR   #CHI-920083
           (l_rvbi.rvbiicd13 IS NULL)) AND s_industry('icd')) OR
         NOT s_industry('icd')  THEN   #委外非最終站不檢查QC合格量  #CHI-920083
      #&endif
         #SELECT SUM(rvv17) INTO l_in FROM rvv_file,rvu_file   #MOD-A70160
         SELECT SUM(rvv17),SUM(rvv82),SUM(rvv85)              #MOD-A70160
           INTO l_in,l_in1,l_in2 FROM rvv_file,rvu_file       #MOD-A70160
          WHERE rvv04=l_rvb.rvb01  #收貨單號
            AND rvv05=l_rvb.rvb02  #收貨項次
            AND rvu01=rvv01
            AND rvu00='1'
            AND rvuconf != 'X'
         #SELECT SUM(rvv17) INTO l_out FROM rvv_file,rvu_file   #MOD-A70160
         SELECT SUM(rvv17),SUM(rvv82),SUM(rvv85)                #MOD-A70160
           INTO l_out,l_out1,l_out2 FROM rvv_file,rvu_file      #MOD-A70160
          WHERE rvv04=l_rvb.rvb01  #收貨單號
            AND rvv05=l_rvb.rvb02  #收貨項次
            AND rvu01=rvv01
            AND rvu00='2'
            AND rvuconf != 'X'
         IF cl_null(l_in) THEN LET l_in = 0 END IF
         IF cl_null(l_in1) THEN LET l_in1 = 0 END IF   #MOD-A70160
         IF cl_null(l_in2) THEN LET l_in2 = 0 END IF   #MOD-A70160
         IF cl_null(l_out) THEN LET l_out = 0 END IF
         IF cl_null(l_out1) THEN LET l_out1 = 0 END IF   #MOD-A70160
         IF cl_null(l_out2) THEN LET l_out2 = 0 END IF   #MOD-A70160
         IF l_in + l_out = l_rvb.rvb07 THEN    #已經全部入庫或驗退
            CONTINUE FOREACH
         END IF
         #SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file    #MOD-A70160
         SELECT SUM(qcs091),SUM(qcs38),SUM(qcs41)           #MOD-A70160
           INTO l_qcs091,l_qcs38,l_qcs41 FROM qcs_file      #MOD-A70160
          WHERE qcs01 = l_rvb.rvb01
            AND qcs02 = l_rvb.rvb02
            AND qcs14 = 'Y'           #No.MOD-930262 add
         IF cl_null(l_qcs091) THEN LET l_qcs091 = 0 END IF   #No.MOD-930220 add
         IF cl_null(l_qcs38) THEN LET l_qcs38 = 0 END IF   #MOD-A70160
         IF cl_null(l_qcs41) THEN LET l_qcs41 = 0 END IF   #MOD-A70160 
         LET g_in = l_qcs091 - l_in   #檢驗合格的量減去已經入庫的量，得到本次可入庫量
         LET g_in1 = l_qcs38 - l_in1   #檢驗合格的量減去已經入庫的量，得到本次可入庫量   #MOD-A70160
         LET g_in2 = l_qcs41 - l_in2   #檢驗合格的量減去已經入庫的量，得到本次可入庫量   #MOD-A70160
         IF cl_null(g_in) THEN
            LET g_in = 0
         END IF
         IF cl_null(g_in1) THEN LET g_in1 = 0 END IF   #MOD-A70160
         IF cl_null(g_in2) THEN LET g_in2 = 0 END IF   #MOD-A70160
         #SELECT SUM(qcs22-qcs091) INTO l_qcs22 FROM qcs_file    #MOD-980191   #MOD-A70160
         SELECT SUM(qcs22-qcs091),SUM(qcs32-qcs38),SUM(qcs35-qcs41)            #MOD-A70160
            INTO l_qcs22,l_qcs32,l_qcs35 FROM qcs_file                         #MOD-A70160
          WHERE qcs01 = l_rvb.rvb01
            AND qcs02 = l_rvb.rvb02
            AND qcs14 = 'Y'           #No.MOD-930262 add
         IF cl_null(l_qcs22) THEN LET l_qcs22 = 0 END IF   #No.MOD-930220 add
         IF cl_null(l_qcs32) THEN LET l_qcs32 = 0 END IF   #MOD-A70160
         IF cl_null(l_qcs35) THEN LET l_qcs35 = 0 END IF   #MOD-A70160
         LET g_out = l_qcs22 - l_out   #檢驗結果為驗退的量減去已經驗退的量，得到本次可驗退的量
         LET g_out1 = l_qcs32 - l_out1   #檢驗結果為驗退的量減去已經驗退的量，得到本次可驗退的量   #MOD-A70160
         LET g_out2 = l_qcs35 - l_out2   #檢驗結果為驗退的量減去已經驗退的量，得到本次可驗退的量   #MOD-A70160
         IF cl_null(g_out) THEN
            LET g_out = 0
         END IF
         IF cl_null(g_out1) THEN LET g_out1 = 0 END IF   #MOD-A70160
         IF cl_null(g_out2) THEN LET g_out2 = 0 END IF   #MOD-A70160
         IF g_sma.sma886[6,6] = 'N' THEN         #免檢驗直接入庫
            LET g_in = l_rvb.rvb07-l_in-l_out    #No.MOD-8C0080 add
            LET g_in1 = l_rvb.rvb82-l_in1-l_out1    #MOD-A70160
            LET g_in2 = l_rvb.rvb85-l_in2-l_out2    #MOD-A70160
            LET g_out= 0
            LET g_out1= 0   #MOD-A70160
            LET g_out2= 0   #MOD-A70160
         END IF
         IF g_sma.sma886[6,6] = 'Y' AND g_sma.sma886[8,8] = 'N' THEN
            LET g_in  = l_rvb.rvb33
            LET g_in1 = l_rvb.rvb331   #MOD-A70160
            LET g_in2 = l_rvb.rvb332   #MOD-A70160
            LET g_out = l_rvb.rvb07-l_rvb.rvb33-l_in-l_out
            LET g_out1= l_rvb.rvb82-l_rvb.rvb331-l_in1-l_out1   #MOD-A70160
            LET g_out2= l_rvb.rvb85-l_rvb.rvb332-l_in2-l_out2   #MOD-A70160
         END IF
         IF l_rvb.rvb39 = 'N' THEN   #料件免檢驗入庫，不管上面怎麼算，都直接入庫
            LET g_in = l_rvb.rvb07-l_in-l_out
            LET g_in1 = l_rvb.rvb82-l_in1-l_out1     #MOD-A70160
            LET g_in2 = l_rvb.rvb85-l_in2-l_out2     #MOD-A70160
            LET g_out= 0
            LET g_out1= 0    #MOD-A70160
            LET g_out2= 0    #MOD-A70160
         END IF
         IF g_in <= 0 AND g_out <= 0 THEN   #本次可入庫量和本次可驗退量都不大于0
            CONTINUE FOREACH
         END IF
      END IF
     #DEV-D60003 add end-----
     
     IF s_industry('icd') THEN   #DEV-D40021 --add--str 
     #&ifdef ICD
       #DEV-D60003 add str-----
        IF NOT((l_rvbi.rvbiicd13 = 'N') OR 
               (l_rvbi.rvbiicd13=' ')   OR  
               (l_rvbi.rvbiicd13 IS NULL)) THEN
           LET g_in = l_rvb.rvb07
           LET g_in1 = l_rvb.rvb82
           LET g_in2 = l_rvb.rvb85
        END IF
       #DEV-D60003 add end-----

       #委外tky非最終站收貨項次不需做檢驗(不管檢驗項次為何),
       #在產生單據的同時,允收數量直接等於實收數量
       #所以在執行此功能[產生入庫/驗退單據]時,須跟隨最終站的收貨項次的條件來決定
       #是否可在此時產生入庫單,以免照成最終站尚無可允收數量,非最終站就被產生
       #至入庫單據了
        IF l_rvbi.rvbiicd13 = 'Y' THEN
           #取得該委外TKY採購單的最終站收貨資料
           SELECT rvb02 INTO l_rvb02 
             FROM rvb_file,ecm_file,rvbi_file
              WHERE rvb01 = l_rvb.rvb01           #收貨單
                AND rvb04 = l_rvb.rvb04           #採購單
                AND rvb03 = l_rvb.rvb03           #採購項次
                AND rvbiicd17 = l_rvbi.rvbiicd17  #工單作業編號
                AND ecm01 = rvb34                 #工單單號
                AND rvbi01=rvb01
                AND rvbi02=rvb02
                AND ecm04 = rvbiicd03             #作業編號
                AND ecm03 IN (SELECT MAX(ecm03) FROM ecm_file
                                WHERE ecm01 = l_rvb.rvb34)
           #判斷最終站是否有允收數量可產生入庫,
           #若沒有,則所對應之非最終站收貨資料也不可在此時產生入庫
           LET l_n = 0 
           SELECT COUNT(*) INTO l_n FROM rvb_file
              WHERE rvb01 = l_rvb.rvb01
                AND rvb02 = l_rvb02
                AND rvb33 > 0
           IF l_n = 0  THEN
              CONTINUE FOREACH
           END IF
        END IF
     #&endif
     END IF   #DEV-D40021 --mark--end
 
      LET l_g_already = 'N' #是否所有的收貨資料,早已產生入庫/驗退單完畢
      #母子單位時,自動產生入庫時,需check 以下
      #(允收數二+允收數一)經過換算<= IQC合格量才可自動產生
      #(rvb332*l_factor+rvb331)   <= rvb33
       IF g_sma.sma115 = 'Y' THEN #使用雙單位
           SELECT ima906 INTO l_ima906
             FROM ima_file
            WHERE ima01=l_rvb.rvb05
           IF l_ima906 = '2' THEN #母子單位
               LET l_rvb33  = l_rvb.rvb332 * l_rvb.rvb84 + l_rvb.rvb331 * l_rvb.rvb81
               IF l_rvb33 > l_rvb.rvb33 THEN
                   LET g_showmsg=l_rvb.rvb05 CLIPPED,'==>',l_rvb.rvb332,'*',l_factor,'+',l_rvb.rvb331,'>',l_rvb.rvb33
                  IF g_bgerr THEN
                     CALL s_errmsg("","",g_showmsg,"aqc-501",1)
                     CONTINUE FOREACH
                  ELSE
                     CALL cl_err3("","","","","aqc-501","",g_showmsg,1)
                     EXIT FOREACH
                  END IF
               END IF
           END IF
       END IF
      LET l_flag=TRUE   #FUN-810038
     
      IF s_industry('icd') THEN   #DEV-D40021 --add--str 
      #&ifdef ICD
         IF NOT (l_rvbi.rvbiicd13='N' OR  #非委外TKY/委外TKY最終站
                 l_rvbi.rvbiicd13 IS NULL OR 
                 l_rvbi.rvbiicd13 = ' ') THEN
            LET l_flag=FALSE
         END IF
      #&endif
      END IF    #DEV-D40021 --add--end
 
      #若IQC單未審核則不可生成驗收入庫信息
      IF l_rvb.rvb39 = 'Y'   AND  #檢驗否='Y'
         g_sma.sma886[8]='Y' AND  #採購收貨允收數量是否與IQC量勾稽='Y'
         l_rvb.rvb35='N'     AND  #不是樣品
         l_flag              AND  #FUN-810038
         l_rvb.rvb19 !='2'   THEN #不為委外代買
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM qcs_file
          WHERE qcs01=l_rvb.rvb01
            AND qcs02=l_rvb.rvb02
            AND qcs14='Y'
            AND qcs00<'5'   #No.FUN-5C0078
         IF l_n = 0 THEN
            LET g_success='N'
            LET g_showmsg=l_rvb.rvb01,'+',l_rvb.rvb02 USING '&&' CLIPPED
            #此收貨單之IQC品質記錄資料未確認,不可產生入庫單 !!
            IF g_bgerr THEN
               CALL s_errmsg("","",g_showmsg,"aqc-026",1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","","aqc-026","",g_showmsg,1)
               EXIT FOREACH
            END IF
         END IF
      END IF
 
      IF l_qc_flag = 'N' THEN #CHI-D60028 add
        #要根據計算出來的本次可入庫量已經本次可驗退量來判斷
         IF g_in > 0 THEN
         #  CALL t110_ins_rvu('i')   #本次產生的是入庫單   #FUN-C20076
            CALL t110sub_ins_rvu('i','N','',FALSE,l_rva.*,l_rvb.*,l_rvbi.*,l_qco.*,g_today,g_in,g_in1,g_in2,g_out,g_out1,g_out2,p_argv2,p_argv6,l_rvu01_1,l_rvu01_2,l_msg,l_msg1)   #FUN-C20076    #FUN-C40015 add l_msg,l_msg1
            #    RETURNING l_rvu01_1,l_rvu01_2                #FUN-C20076   #FUN-C40015 mark
                 RETURNING l_rvu01_1,l_rvu01_2,l_msg,l_msg1   #FUN-C40015 
         END IF
     #END IF #MOD-E70167 add #CHI-F50010 mark
         #MOD-E70167 QC驗退時,因為不可以輸入aqci107,所以驗退單的產生一律走舊流程
         IF g_out > 0 THEN
            IF l_rva.rva04='Y' THEN         #CHI-F80017 add L/C收貨不能走驗退
               CALL cl_err('','apm1228',1)  #CHI-F80017 add
            ELSE                            #CHI-F80017 add   
               #FUN-F60033 add str---------------------------
               IF p_argv2 = 'TAP' THEN                     #多角貿易不能走驗退
                  CALL cl_err('','apm1220',1)
               ELSE
               #FUN-F60033 add end---------------------------
               #  CALL t110_ins_rvu('o')   #本次產生的是驗退單   #FUN-C20076
               #  CALL t110sub_ins_rvu('o','N','','N',l_rva.*,l_rvb.*,l_rvbi.*,' ',g_today,g_in,g_in1,g_in2,g_out,g_out1,g_out2,p_argv2,p_argv6,l_rvu01_1,l_rvu01_2)   #FUN-C20076  #TQC-C20196  
                  CALL t110sub_ins_rvu('o','N','',FALSE,l_rva.*,l_rvb.*,l_rvbi.*,l_qco.*,g_today,g_in,g_in1,g_in2,g_out,g_out1,g_out2,p_argv2,p_argv6,l_rvu01_1,l_rvu01_2,l_msg,l_msg1)   #TQC-C20196    #FUN-C40015 add l_msg,l_msg1
                  #    RETURNING l_rvu01_1,l_rvu01_2                #FUN-C20076   #FUN-C40015 mark
                       RETURNING l_rvu01_1,l_rvu01_2,l_msg,l_msg1   #FUN-C40015
               END IF   #FUN-F60033 add
            END IF   #CHI-F80017 add
         END IF
      END IF #CHI-D60028 add #MOD-E70167 mark #CHI-F50010 remark
       
 
      IF g_success = 'N' THEN
         IF g_bgerr THEN
            CONTINUE FOREACH
         ELSE
            EXIT FOREACH
         END IF
      END IF
   END FOREACH

  #CHI-D60028 add start -----
   IF l_qc_cnt > 0 AND g_success = "Y" THEN
      IF p_ask_flag = 'Y' THEN
         IF cl_confirm("aqc-401") THEN
            CALL s_gene_IQC(l_rvu01_1,'',l_rva.rva01,'',g_today,TRUE)
         END IF 
      END IF
   END IF
  #CHI-D60028 add end   -----

   #-----MOD-AB0244---------
   IF NOT cl_null(l_rvu01_1) THEN
      LET l_smydmy4 = ''
      LET l_t = l_rvu01_1[1,g_doc_len]
     #FUN-A60009 mod str --------------------   
     #SELECT smydmy4 INTO l_smydmy4 FROM smy_file
     # WHERE smyslip = l_t
     #IF l_smydmy4 = 'Y' THEN
     #   CALL t720sub_y(l_rvu01_1,'6',l_rvu01_1,p_argv2,'7',TRUE,'N')
     #END IF
      SELECT smydmy4,smyapr
        INTO l_smydmy4,l_smyapr
        FROM smy_file
       WHERE smyslip = l_t
      IF l_smydmy4 = 'Y' AND l_smyapr <> 'Y' THEN
            CALL t720sub_y_chk(l_rvu01_1,'6',l_rvu01_1,p_argv2,'7','N') 
            IF g_success = "Y" THEN
              #CALL t720sub_y_upd(l_rvu01_1,'6',l_rvu01_1,p_argv2,'7',TRUE,'N')     #MOD-C80049 mark
               CALL t720sub_y_upd(l_rvu01_1,'6',l_rvu01_1,p_argv2,'7',TRUE,'N','N') #MOD-C80049 add
            END IF
      END IF
     #FUN-A60009 mod end ---------------------
   END IF
   IF NOT cl_null(l_rvu01_2) THEN 
      LET l_smydmy4 = ''
      LET l_t = l_rvu01_2[1,g_doc_len]   
     #FUN-A60009 mod str --------------------   
     #SELECT smydmy4 INTO l_smydmy4 FROM smy_file
     # WHERE smyslip = l_t
     #IF l_smydmy4 = 'Y' THEN
     #   CALL t720sub_y(l_rvu01_2,'6',l_rvu01_2,p_argv2,'4',TRUE,'N')
     #END IF
      SELECT smydmy4,smyapr
        INTO l_smydmy4,l_smyapr
        FROM smy_file
       WHERE smyslip = l_t
      IF l_smydmy4 = 'Y' AND l_smyapr <> 'Y' THEN
            CALL t720sub_y_chk(l_rvu01_2,'6',l_rvu01_2,p_argv2,'4','N')
            IF g_success = "Y" THEN
               #CALL t720sub_y_upd(l_rvu01_2,'6',l_rvu01_2,p_argv2,'4',TRUE,'N')    #MOD-C80049 mark
               CALL t720sub_y_upd(l_rvu01_2,'6',l_rvu01_2,p_argv2,'4',TRUE,'N','N') #MOD-C80049 add
            END IF
      END IF
     #FUN-A60009 mod end ---------------------
   END IF
   #-----END MOD-AB0244-----
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
 
   IF l_g_already = 'Y' THEN
      #所有的收貨資料,早已產生入庫/驗退單完畢,不可重覆產生!
      IF g_bgerr THEN
         CALL s_errmsg("","",l_rva.rva01,"apm-111",1)    
     #   CALL s_errmsg("","",l_rva.rva01,"mfg1607",1)    #MOD-AC0306 add   #MOD-AC0306 mark
      ELSE
         CALL cl_err3("","","","","apm-111","",l_rva.rva01,1)  
      #  CALL cl_err3("","","","","mfg1607","",l_rva.rva01,1)  #MOD-AC0306 add #MOD-AC0306 mark
      END IF
      LET g_success = 'N'
   END IF
   CALL cl_msg("")
 
#FUN-C40015 ------------Begin-----------
   IF g_success = 'Y' THEN
      IF NOT cl_null(l_msg) THEN
         IF g_bgerr THEN
            CALL s_errmsg('rvu01',l_msg,"","mfg-085",2)
         ELSE
            CALL cl_err(l_msg CLIPPED,"mfg-085",0)
         END IF
      END IF
      IF NOT cl_null(l_msg1) THEN
         IF g_bgerr THEN
            CALL s_errmsg('rvu01',l_msg1,"","mfg-086",2)
         ELSE
            CALL cl_err(l_msg1 CLIPPED,"mfg-086",0)
         END IF
      END IF
   END IF   
#FUN-C40015 ------------End-------------

   CALL s_showmsg()       #No.FUN-710030
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF

   #MOD-C80049 add start -----
   IF NOT cl_null(l_rvu01_1) THEN
      #TQC-C80120 add start -----
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM rvu_file WHERE rvu01 = l_rvu01_1 AND rvuconf = 'Y'
      IF l_cnt > 0 AND l_rva.rva00 = '1' THEN
         SELECT UNIQUE pmm02 INTO l_pmm02 FROM pmm_file
          WHERE pmm01 IN (SELECT rvv36 FROM rvv_file
                           WHERE rvv01 = l_rvu01_1)
         IF l_pmm02 = 'SUB' AND g_sma.sma131 = 'Y' AND (g_sma.sma1431='N' OR cl_null(g_sma.sma1431)) THEN
            LET l_sfb93 = ''
            SELECT sfb93 INTO l_sfb93 FROM rvv_file,sfb_file WHERE sfb01=rvv18 AND rvv01 = l_rvu01_1 ORDER BY rvv02
      #TQC-C80120 add end   -----
            #IF l_cnt > 0 THEN    #TQC-C80120 mark
            IF l_sfb93 = 'Y' THEN #TQC-C80120 add
               CALL t720sub_ecm(l_rvu01_1)
            END IF
         END IF #TQC-C80120 add
      END IF    #TQC-C80120 add
   END IF
   #MOD-C80049 add end   -----

   #No.FUN-A80026  --Begin

#TQC-B40081 --unmark --begin--
   #FUN-B30161-mark-start--
   #l_rvu01_1 为产生的入库单

   LET l_smyslip = s_get_doc_no(l_rvu01_1)
# TQC-B60252 --mark --begin--
#   SELECT smy74 INTO l_smy74 FROM smy_file WHERE smyslip = l_smyslip
#
#   IF cl_null(l_smy74) THEN LET l_smy74 = 'N' END IF
# 
#   IF NOT cl_null(l_rvu01_1) AND l_smy74 = 'Y' AND g_success = 'Y' THEN
#TQC-B40081 --unmark --end--
   #FUN-B60252-mark-end--
#TQC-B40081 --unmark --begin--

#TQC-B40081 --unmark --begin--
#TQC-B60252 --un mark -- begin--
#   SELECT sma91 INTO l_sma91 FROM sma_file                                                    #FUN-B30161 add    #TQC-B60252 add
   IF cl_null(g_sma.sma91) THEN LET g_sma.sma91 = 'N' END IF                                       #FUN-B30161 add #TQC-B60252 add
#  IF NOT cl_null(l_rvu01_1) AND g_sma.sma91 = 'Y' AND g_success = 'Y'AND l_rva.rva10='REG' THEN     #FUN-B30161 add  #TQC-B60252 add   #MOD-B80272 mark
   IF NOT cl_null(l_rvu01_1) AND (g_sma.sma91 = 'Y' OR g_sma.sma92 = 'Y') AND                      #MOD-B80272
      g_success = 'Y' THEN                                                                         #MOD-B80272
#TQC-B40081 --unmark --end--
#MOD-B80272 -- begin --
      #當作是做入庫單確認後直接串產生應付帳款功能,先改變g_action_choice的值,因為後面會用來判斷
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'confirm'
#MOD-B80272 -- end --
      CALL t720_gen_ap(l_rvu01_1)
      LET g_action_choice = l_action_choice   #MOD-B80272 add
   END IF 
   #No.FUN-A80026  --End  
 #TQC-B60252 --un mark --end--
END FUNCTION

#FUNCTION t110sub_qc_ck(p_rva01)        #MOD-D70118 mark
FUNCTION t110sub_qc_ck(p_rva01,p_rvb02) #MOD-D70118 add
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE p_rva01  LIKE rva_file.rva01   #DEV-D40021 --add
   DEFINE p_rvb02  LIKE rvb_file.rvb02   #MOD-D70118 add

   IF g_qcz.qcz14 = 'Y' THEN
     #MOD-D20137 add start -----
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt
        FROM rvb_file
       WHERE rvb01 = p_rva01
         AND rvb39 = 'Y'
         AND rvb02 = p_rvb02 #MOD-D70118 add
        #AND (rvb40 IS NULL OR rvb40 = '') #TQC-D40091 mark
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
      IF l_cnt = 0 THEN
         RETURN FALSE 
      ELSE
     #MOD-D20137 add end   -----
         RETURN TRUE
      END IF #MOD-D20137 add
   ELSE
      IF cl_null(p_rva01) THEN
         CALL cl_err('','aqc-334',1)
         RETURN
      END IF
     
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM qco_file WHERE qco01 = p_rva01
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 

      IF l_cnt = 0 THEN
         RETURN FALSE
      ELSE
         RETURN TRUE
      END IF

   END IF 
END FUNCTION 

#FUNCTION t110sub_qc_item(p_rva01,p_ask_flag)             #FUN-CC0012 mark     #TQC-D50065 remark #CHI-D60028 mark
FUNCTION t110sub_qc_item(p_rva01,p_rvb05,p_ask_flag)    #FUN-CC0012 end      #TQC-D50065 mark     #CHI-D60028 remove #
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE l_sure       LIKE type_file.chr1
   DEFINE l_qcs14      LIKE qcs_file.qcs14
   DEFINE l_msg        STRING
   DEFINE l_qck09      LIKE qck_file.qck09
   #DEV-D40021 --add--str
   DEFINE p_rva01      LIKE rva_file.rva01
   DEFINE p_rvb05      LIKE rvb_file.rvb05    #FUN-CC0012   #TQC-D50065 mark #CHI-D60028 remove #
   DEFINE p_ask_flag   LIKE type_file.chr1
   DEFINE l_rva        RECORD LIKE rva_file.*
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_n2         LIKE type_file.num5 #FUN-E70053 add
   #DEV-D40021 --add--end
   DEFINE l_qcc09      LIKE qcc_file.qcc09    #FUN-CC0012
   DEFINE l_qcd09      LIKE qcd_file.qcd09    #FUN-CC0012
   DEFINE l_qc_flag    LIKE type_file.chr1    #FUN-CC0012
   DEFINE l_rvb05      LIKE rvb_file.rvb05    #TQC-D50065
   DEFINE l_sql        STRING                 #TQC-D50065 
  #DEFINE l_qc_cnt     LIKE type_file.num5    #TQC-D50065 #CHI-D60028 mark
  #DEFINE l_err_cnt    LIKE type_file.num5    #TQC-D50065 #CHI-D60028 mark
   DEFINE l_rvb02      LIKE rvb_file.rvb02    #CHI-DC0002 add
   DEFINE l_qc         LIKE type_file.chr1    #CHI-DC0002 add

   LET l_qc  = 'Y'       #CHI-DC0002 add
   LET l_rvb05 = p_rvb05 #CHI-D60028 add
   #DEV-D40021 --add--str
   SELECT * INTO l_rva.* FROM rva_file WHERE rva01 = p_rva01
   #DEV-D40021 --add--end
  
  #CHI-D60028 mark start -----
  #IF cl_null(l_rva.rva01) THEN
  #   CALL cl_err('','aqc-334',1)
  #   RETURN
  #END IF
  #CHI-D60028 mark end   -----
  
   #DEV-D40021 須調整暫時MARK--mark--str 
   #SELECT DISTINCT qck09 INTO l_qck09 FROM ima_file,qck_file
   # WHERE qck01=ima109
   #   AND ima01=g_rvb[l_ac].rvb05
   #IF l_qck09 = 'N' THEN
   #   RETURN
   #END IF
   #DEV-D40021 須調整暫時MARK--mark--end 

   #TQC-D50065 add begin---
  #CHI-D60028 mark start -----
  #LET l_qc_cnt = 0
  #LET l_err_cnt = 0 
  #CALL s_showmsg_init() 
  #LET l_sql = "SELECT rvb05 FROM rvb_file WHERE rvb01 = '",p_rva01,"' " 
  #PREPARE t110_rvb05_pre FROM l_sql
  #DECLARE t110_rvb05_cus CURSOR FOR t110_rvb05_pre

  #FOREACH t110_rvb05_cus INTO l_rvb05
  #CHI-D60028 mark end   -----
   #TQC-D50065 add end----- 
      #FUN-CC0012 add begin---
      LET l_qc_flag = NULL
      LET l_qcc09 = NULL
      LET l_qcd09 = NULL
      LET l_qck09 = NULL
      LET g_showmsg = p_rva01,"/",l_rvb05                         #TQC-D50065 add

      SELECT DISTINCT qcc09 INTO l_qcc09 FROM qcc_file
       WHERE qcc01=l_rvb05   #TQC-D50065 mod
       
      IF l_qcc09 = 'Y' THEN
         LET l_qc_flag = 'Y'
      ELSE
         SELECT DISTINCT qcd09 INTO l_qcd09 FROM qcd_file
          WHERE qcd01=l_rvb05   #TQC-D50065 mod
         IF l_qcd09 = 'Y' THEN
            LET l_qc_flag = 'Y'
         ELSE
            LET l_qck09=''
            SELECT DISTINCT qck09 INTO l_qck09 FROM ima_file,qck_file
             WHERE qck01=ima109
               AND ima01=l_rvb05   #TQC-D50065 mod
            IF l_qck09 = 'Y' THEN
               LET l_qc_flag = 'Y'
            END IF
         END IF
      END IF
      #TQC-D50065 mark begin---
      #IF l_qc_flag <> 'Y' THEN
      #   RETURN                                                   
      #END IF
      #TQC-D50065 mark end-----

     #CHI-D60028 mark start -----
     ##TQC-D50065 add begin---
     #IF l_qc_flag = 'Y' THEN
     #   LET l_qc_cnt = l_qc_cnt +1 
     #END IF
     ##TQC-D50065 add end-----
     #CHI-D60028 mark end   -----
      #FUN-CC0012 add end-----

      IF l_qc_flag = 'Y' THEN                  #TQC-D50065 add  
        #CHI-D60028 mark start -----
        #IF l_rva.rvaconf !='Y' THEN 
        #   CALL cl_err('','aap-717',0)
        #   RETURN 
        #END IF
        #CHI-D60028 mark end   -----
         LET l_sure = 'Y'
         LET l_n = 0 
         LET l_cnt = ARR_CURR()
         SELECT COUNT(*) INTO l_n FROM qcs_file
          WHERE qcs01 = l_rva.rva01
         #  AND qcs02 = g_rvb[l_ac].rvb02   #MOD-C30349 mark
         IF l_n < 1 THEN 
           #CALL cl_err('','aqc-532',1)     #TQC-D50065 mark
           #RETURN                          #TQC-D50065 mark
          #LET l_err_cnt = l_err_cnt + 1                                  #TQC-D50065 add #CHI-D60028 mark
           IF g_bgerr THEN #CHI-D60028 add
              CALL s_errmsg('rva01,rvb05',g_showmsg,'','aqc-532',1)       #TQC-D50065 add
          #CHI-D60028 add start -----
           ELSE
              CALL cl_err3("","","","","aqc-532","",g_showmsg,1)
           END IF
           LET g_success='N'
          #CHI-D60028 add end   -----
         END IF
   
        #CHI-DC0002 add start -----
         LET l_sql = "SELECT rvb02 FROM rvb_file WHERE rvb01 = '",p_rva01,"' " 
         PREPARE t110_rvb02_pre FROM l_sql
         DECLARE t110_rvb02_cus CURSOR FOR t110_rvb02_pre

         FOREACH t110_rvb02_cus INTO l_rvb02
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM qcs_file
             WHERE qcs01 = l_rva.rva01
               AND qcs02 = l_rvb02 AND (qcs09 = '1' OR qcs09 = '3')
            IF l_cnt > 0 THEN
        #CHI-DC0002 add end   -----
               #MOD-C30349 -------------Begin--------------
               LET l_n = 0 
               SELECT COUNT(*) INTO l_n FROM qco_file
                WHERE qco01 = l_rva.rva01
                  AND qco02 = l_rvb02 #CHI-DC0002 add 
               IF cl_null(l_n) THEN
                  LET l_n = 0
               END IF 
               IF l_n < 1 THEN
                 #CALL cl_err('','aqc-532',1)      #TQC-D50065 mark    
                 #RETURN                           #TQC-D50065 mark
                #LET l_err_cnt = l_err_cnt + 1                                  #TQC-D50065 add #CHI-D60028 mark
                 IF g_bgerr THEN #CHI-D60028 add
                    CALL s_errmsg('rva01,rvb05',g_showmsg,'','aqc-532',1)          #TQC-D50065 add
                #CHI-D60028 add start -----
                 ELSE
                    CALL cl_err3("","","","","aqc-532","",g_showmsg,1)
                 END IF
                 LET g_success='N'
                #CHI-D60028 add end   -----
                 LET l_qc = 'N' #CHI-DC0002 add
               END IF     
    
              #合格的情況 
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM qcs_file,qco_file
                WHERE qcs01 = qco01
                  AND qcs02 = qco02
                  AND qcs05 = qco05
                  AND qco11 > qco20
                  AND qcs01 = l_rva.rva01
                  AND qcs14 = 'Y'  
                  AND qcs09 = '1'     #FUN-E70053 Add  
                  AND qcs02 = l_rvb02 #CHI-DC0002 add 
               IF cl_null(l_n) THEN LET l_n = 0 END IF
               
               #FUN-E70053-Start-Add
               #特採之情況 
               LET l_n2 = 0
               SELECT COUNT(*) INTO l_n2 FROM qcs_file
                WHERE qcs091 > 0
                  AND qcs01 = l_rva.rva01
                  AND qcs02 = l_rvb02
                  AND qcs14 = 'Y'  
                  AND qcs09 = '3' 
              IF cl_null(l_n2) THEN LET l_n2 = 0 END IF    
               #FUN-E70053-End-Add
                
               
              
              #IF l_n < = 0 THEN            #FUN-E70053 mark
               IF (l_n + l_n2) < = 0 THEN   #FUN-E70053 add
                 #CALL cl_err('','aqc-100',1)      #TQC-D50065 mark  
                 #RETURN                           #TQC-D50065 mark
                #LET l_err_cnt = l_err_cnt + 1                                  #TQC-D50065 add #CHI-D60028 mark
                 IF g_bgerr THEN #CHI-D60028 add
                    CALL s_errmsg('rva01,rvb05',g_showmsg,'','aqc-100',1)          #TQC-D50065 add
                #CHI-D60028 add start -----
                 ELSE
                    CALL cl_err3("","","","","aqc-100","",g_showmsg,1)
                 END IF
                 LET g_success='N'
                #CHI-D60028 add end   -----
                 LET l_qc = 'N' #CHI-DC0002 add
               END IF 
               #MOD-C30349 -------------End----------------
        #CHI-DC0002 add start -----
            END IF
         END FOREACH
        #CHI-DC0002 add end   -----

   #TQC-D50065 add begin---
     #CHI-D60028 add start -----
      ELSE
         RETURN FALSE 
     #CHI-D60028 add end   -----
      END IF 
   #END FOREACH   #TQC-D50065 add #CHI-D60028 mark
  
  IF l_qc = 'Y' THEN #CHI-DC0002 add
     RETURN TRUE #CHI-D60028 add
 #CHI-DC0002 add start -----
  ELSE
     RETURN FALSE 
  END IF
 #CHI-DC0002 add end   -----

  #CHI-D60028 mark start -----
  #IF l_qc_cnt = 0 THEN
  #   RETURN
  #END IF

  #IF l_err_cnt > 0 THEN
  #   CALL s_showmsg()
  #   RETURN
  #END IF
  #CHI-D60028 mark end   -----
   #TQC-D50065 add end---


#MOD-C30349 -------------Begin--------------
#  DECLARE qc_item CURSOR FOR
#   SELECT qcs14 FROM qcs_file 
#    WHERE qcs01 = l_rva.rva01
#      AND qcs02 = g_rvb[l_ac].rvb02
#  FOREACH qc_item INTO l_qcs14
#     IF l_qcs14 != 'Y' THEN 
#        LET l_sure = 'N'
#        EXIT FOREACH
#     END IF  
#  END FOREACH
#  IF l_sure = 'N' THEN
#     CALL cl_err('','aqc-534',1)
#     RETURN
#  END IF
#MOD-C30349 -------------End---------------

  #CHI-D60028 mark start -----
  #IF p_ask_flag = 'Y' THEN    #DEV-D40021 --add
  #IF cl_confirm("aqc-401") THEN   #TQC-C20521 add
  ##  LET l_msg = "aqcp107 '1' '' '' '",g_today,"' '' '' '",l_rva.rva01,"' '",g_rvb[l_cnt].rvb05,"' '' 'Y'"  #TQC-C30195 mark
  #   LET l_msg = "aqcp107 '1' '' '' '",g_today,"' '' '' '",l_rva.rva01,"' '' '' 'Y'"     #TQC-C30195  
  #   CALL cl_cmdrun(l_msg)
  #  #MESSAGE ' O.K '      #TQC-C40027 add  #TQC-C40060 mark
  #END IF   #TQC-C20521 add 
  #END IF    #DEV-D40021 --add
  #CHI-D60028 mark end   -----
END FUNCTION 
#DEV-D40021 --add--end

#MOD-E70047 add-----------------------------------------------------------------
#【注意】以後維護此FUNCTION t110sub_ec_sw()需同步維護sapmt110.src.4gl裡面的FUNCTION t110_ec_sw()
#確認是否為製程委外工單
FUNCTION t110sub_ec_sw(p_rvb34,p_argv2)
   DEFINE l_flag    LIKE type_file.chr1,
          x_sfb24   LIKE sfb_file.sfb24
   DEFINE p_rvb34   LIKE rvb_file.rvb34
   DEFINE p_argv2   LIKE rva_file.rva10

   LET l_flag = 'N'
#&ifndef SLK
   IF g_prog <>'apmt110_slk' AND NOT cl_null(p_rvb34) THEN
      IF p_argv2 ='SUB' THEN
         LET x_sfb24=''
         SELECT sfb24 INTO x_sfb24
           FROM sfb_file
          WHERE sfb01 = p_rvb34
         IF x_sfb24 IS NOT NULL AND x_sfb24='Y' THEN
            LET l_flag='Y'
         END IF
      END IF
#&endif
   END IF
   RETURN l_flag
END FUNCTION
#MOD-E70047 add end-------------------------------------------------------------
