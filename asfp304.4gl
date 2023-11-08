# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: asfp304.4gl
# Descriptions...: 訂單整批工單產生作業
# Date & Author..: 00/12/20 BY jacky
# Modify.........: 00-12-26 BY ANN CHEN  新增sfb93欄位的Default
# Modify.........: No.MOD-480184 04/08/06 By Wiky LET xxx='  '改=>' '
# Modify.........: No.MOD-480211 04/08/09 By Carol 將 oea01,sfb81,wo_type 設為 not null required 的欄位
# Modify.........: No.MOD-490217 04/09/10 By yiting 料號欄位放大
# Modify.........: No.MOD-530283 05/03/25 By Mandy 第一次未輸入工單單別時,即執行Carray,系統出現單別未輸入,但補入單別不時,執行Carray則無反應
# Modify.........: No.FUN-550112 05/05/27 By ching 特性BOM功能修改
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.MOD-530402 05/06/15 By pengu  1.轉至工單時，工單單頭製造通知單之項次應為 Null，不可為 0
#                                                   2.轉至工單時，工單單頭之成本中心應為Null，不可為 1
#                                                   3.錯誤之訂單編號時，錯誤訊息u(asf-737)無此製造通知單資料」，應改為無此訂單資料
#                                                   4. PROMPT '是否要重算: 預計開工日(Y/N)將改成CALL cl_conf()
# Modify.........: No.MOD-530799 05/06/30 By pengu 1.訂單轉工單應參考 ima562 之生產損耗率
                                                 # 2.生產量控管不能大於訂單量z`
                                                 # 3.在計算開工日時，需考慮非工作日
# Modify.........: No.MOD-580322 05/08/31 By wujie  中文資訊修改進 ze_file
# Modify.........: No.FUN-580178 05/09/08 By Rosayu 計算工單開工日時也應該要判斷行事曆休假日,否則造成與mrp 計算邏輯不一致
# Modify.........: No.MOD-5A0073 05/10/05 By Claire sfb28結案狀態不需給值
# Modify.........: No.FUN-5B0131 05/12/07 By Pengu CALL cl_cmdrun(g_msg) 改用 CALL cl_cmdrun_wait(g_msg)
                                       #           否則會造成CALL s_smyauno()時,發生status=-263問題
# Modify.........: No.TQC-610003 06/01/17 By Nicola INSERT INTO sfb_file 時, 特性代碼欄位(sfb95)應抓取該工單單頭生產料件在料件主檔(ima_file)設定的'主特性代碼'欄位(ima910)
# Modify.........: No.FUN-640083 06/04/09 By kim 訂單轉工單未卡是否為重覆性生產料件
# Modify.........: No.FUN-640148 06/04/17 By Sarah 增加當工單完工日與訂單預定交貨日不同時顯示訊息
# Modify.........: No.FUN-650193 06/06/01 By kim 2.0功能改善-主特性代碼
# Modify.........: No.FUN-570104 06/06/08 By Sarah 訂單若部份備置(ex:訂單量100，備置20)，則仍需可以轉工單(80)
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-670106 06/07/26 By cl 執行s_schdat函數后，更新sfb24的值.
# Modify.........: No.FUN-670103 06/07/31 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.TQC-680104 06/08/24 By pengu MOD-670106的修改會照成當訂單設有備置量時無法轉工單
# Modify.........: No.FUN-650054 06/09/11 By kim 工單型態 應置於單身可就不同item 各自選擇
# Modify.........: No.FUN-680121 06/09/18 By huchenghao 類型轉換
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.MOD-6A0138 06/11/15 By Claire 單身選不重計預計開工日會還原為原值
# Modify.........: No.TQC-730022 07/03/12 By rainy 新增背景作業
# Modify.........: No.MOD-790028 07/09/17 By Pengu 生產損耗率ima562應除100
# Modify.........: No.CHI-740001 07/09/27 By rainy bma_file要判斷有效碼
# Modify.........: No.TQC-7A0065 07/10/19 By lumxa "訂單轉工單asfp304作業BUG：
#                                                  已發放工單還原作業(asfp322)中發現某張母工單無法還原，報錯""無符合條件的資料""。
#                                                  發現抓取工單資料時有這樣一個條件："" AND sfb17 IS NULL"" ，
#                                                  據查，是訂單轉工單作業asfp304給sfb17賦值為0：LET l_sfb.sfb17 = 0 ，應改為LET l_sfb.sfb17 = NULL"
# Modify.........: No.TQC-7B0031 07/11/06 By Carrier 單身沒有選中時,不進行后續的邏輯處理
# Modify.........: No.FUN-710073 07/12/03 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.FUN-7C0021 07/12/06 By Sarah 當新增工單時,若工單型態(sfb02)為11.拆件式工單時,重工(sfb99)預設值給Y
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-810014 FUN-850079 08/01/17 By arman 修改為服飾版
# Modify.........: No.FUN-7B0018 08/02/26 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-840212 08/04/21 By Pengu FUN-810014單身加入訂單欄位，卻未撈訂單單號顯示
# Modify.........: No.FUN-840194 08/06/25 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-870117 08/08/01 BY ve007 增加按作業編號生成工單的功能
# Modify.........: No.MOD-880016
# Modify.........: No.MOD-8C0265 08/12/29 By chenyu 輸完工日期后，點否則不調整開工日期
# Modify.........: No.MOD-920243 09/02/19 By claire 排除 oea61 > (oea62+oea63) 資料 
# Modify.........: No.TQC-920104 09/02/27 By chenyu 部門/廠商欄位后面判斷有問題
# Modify.........: No.FUN-8C0081 09/03/09 By sabrina 原i301sub_firm1拆為i301sub_firm1_chk和i301sub_firm1_upd，所以此程式也一併調整
# Modify.........: No.MOD-940205 09/04/14 By Pengu 若有設生產損耗率, 當轉成工單時,工單生產量的計算會錯誤
# Modify.........: No.MOD-940349 09/04/27 By Pengu 控管境外倉出貨訂單不可轉工單
# Modify.........: No.FUN-950021 09/05/26 By Carrier 呼叫i301sub時，加傳一個是否在transaction的參數
# Modify.........: No.FUN-960083 09/06/30 By mike對單身特性代碼欄位加上開窗功能    
# Modify.........: No.FUN-920088 09/07/10 By jan 一般行業單頭部分欄位調整為QBE      
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-960317 09/09/03 By Carrier transaction 完整性修正
# Modify.........: No.MOD-990224 09/09/29 By Smapmin 沒有單位轉換率時,要default 1
# Modify.........: No:MOD-970045 09/11/03 By Pengu 訂單轉工單時，排除oea61>(oea62+oea63)的限制，且加上oeb70='N'的條件
# Modify.........: No:TQC-9B0181 09/11/23 By lilingyu 產生工單時,工單單頭sfbmksg都給'N'是錯誤的,應該去撈單別性質檔的設定來決定
# Modify.........: No:MOD-950295 09/11/27 By sabrina 若工單單別為不自動編碼時會無法正常轉工單
# Modify.........: No:MOD-950298 09/11/27 By sabrina 調整顯示工單號碼程式段
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造
#                                                   成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:MOD-A30177 10/03/30 By Summer 工單型態=8時,ven_no開窗應開供應商基本資料檔
# Modify.........: No:MOD-A40002 10/04/07 By Summer 增加oeb1001訂單原因碼default給sfb51工單理由碼
# Modify.........: No.TQC-A50087 10/05/20 By liuxqa sfb104 赋初值.
# Modify.........: No.TQC-A50129 10/05/21 By lilingyu 增加controlg功能
# Modify.........: No.FUN-A50066 10/06/10 By jan 平行製程
# Modify.........: No:MOD-A70028 10/08/03 By Pengu 程式位使用cl_used()
# Modify.........: No.FUN-A80102 10/08/20 By kim GP5.25號機管理
# Modify.........: No.FUN-A80054 10/08/26 By jan GP5.25工單間合拼
# Modify.........: No:MOD-A90067 10/09/23 By Summer 將手冊編號oeb908也帶入sfb97
# Modify.........: No:FUN-A80060 10/09/28 By jan GP5.25工單間合拼(edg50/edg51算法改寫)
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No:MOD-AB0063 10/11/08 By sabrina 若是重工工單或拆件式工單(工單型態為5、8、11)不應控管須建BOM
# Modify.........: No:MOD-AB0243 10/11/29 By sabrina (1)料件來源碼若為"S"，則工單型態改為"委外工單"
#                                                    (2)工單型態若為"委外工單"則"部門/廠商"欄位default為該料件的主要供應商
# Modify.........: No:TQC-AB0136 10/12/01 By jan ima571為null時,不能產生製程檔
# Modify.........: No:TQC-AC0238 10/12/17 By zhangweib 工單單別排除smy73='Y'的單別
# Modify.........: No.TQC-AC0243 10/12/17 By vealxu 抓預設製程編號應該撈ima94才對
# Modify.........: No:MOD-AC0288 10/12/24 By sabrina 成本中心應依工單單別來抓取 
# Modify.........: No:TQC-B20161 11/02/23 By jan INSERT INTO asfp312_tmp時VALUES個數不符
# Modify.........: No:FUN-B20085 11/03/03 By jan asfp304 控卡複雜操作不方便
# Modify.........: No.MOD-B30028 11/03/04 By zhangll 修正插入sfci_file,系统异常当出问题
# Modify.........: No.FUN-B20075 11/03/07 By kim 計畫批號要可以處理逗號
# Modify.........: No.FUN-B30035 11/03/10 By jan asfp304每次處理資料時，同合拼版號的都產生在同一張PBI單上 
# Modify.........: No.MOD-B30463 11/03/14 By shenyang 
# Modify.........: No.FUN-B20060 11/04/07 By zhangll sfb071改抓oeb72
# Modify.........: No.FUN-940103 11/05/10 By lixiang 增加規格顯示欄位
# Modify.........: No.TQC-B60133 11/06/16 By jan 無工單資料產生時，請給相應的報錯信息
# Modify.........: No.TQC-B60189 11/06/20 By lixh1 當訂單單身有輸入BOM版本時，訂單再轉工單並將訂單指定的BOM版本，default到工單BOM版本欄位中
# Modify.........: No.TQC-B60323 11/06/24 By guoch 轉為工單時進行生產批量和最小生產量的檢查
# Modify.........: No:MOD-B40215 11/07/17 By Summer 若l_max_no及l_min_no為null時，應給一個空白字元 
# Modify.........: No:CHI-B80053 11/10/06 By johung 成本中心是null時，帶入輸入料號的ima34
# Modify.........: NO:CHI-B80044 11/10/17 By johung 訂單轉工單且料有設生產批量時，生產數量應為批量的倍數，若大於訂單數則不可超過批量數
#                                                   生產數量大於訂單數時不控卡，僅提示訊息
# Modify.........: No.FUN-BC0008 11/12/02 By zhangll s_cralc4整合成s_cralc,s_cralc增加傳參
# Modify.........: No:MOD-C30872 12/03/27 By destiny 自动生成单身资料时排出掉misc料件 
# Modify.........: No:MOD-C50030 12/05/07 By suncx 已出貨的訂單轉工單，數量計算錯誤
# Modify.........: No:MOD-C40193 12/05/08 By ck2yuan 由外部傳入g_wc會是null,則給予oea01 = g_argv1(單號)
# Modify.........: No:MOD-C50055 12/05/09 By suncx 預計開工日和預計完工日bug處理
# Modify.........: No:FUN-C50052 12/05/17 By bart 單身增加全選取消全選按鈕
# Modify.........: No:TQC-C50223 12/05/28 By fengrui 預計開工日和預計完工日bug處理
# Modify.........: No:MOD-BA0006 12/06/18 By ck2yuan 做生產批量和最小生產量檢查時應判斷此張訂單是否要轉成工單
# Modify.........: No:TQC-C70002 12/07/02 By fengrui 生成的工單單號提示信息添加子工單單號
# Modify.........: No:TQC-C70031 12/07/04 By fengrui 生成的工單單號提示信息排除未轉工單
# Modify.........: No:TQC-C70104 12/07/19 By fengrui 工單按條件設為必輸欄位,根據轉值設置必輸欄位
# Modify.........: No:MOD-C70255 12/07/25 By ck2yuan 還原 MOD-C50030的修改
# Modify.........: No.FUN-C30114 12/08/07 By bart sfb89值
# Modify.........: No:MOD-C80127 12/08/20 By Lori oeb72有特別輸入值時,訂單轉工單不論什麼方式都要預帶oeb72
# Modify.........: No:CHI-C60023 12/08/20 By bart 新增欄位-資料類別
# Modify.........: No:TQC-C80187 12/08/31 By qiull 不經過單頭的部門欄位時,也需要增加控管
#                                                  不經過單身的部門欄位時，也要增加控管
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.MOD-CB0115 12/11/23 By Elise 修正SQL撈已開工數量
# Modify.........: No.MOD-C90048 12/11/30 By Elise 將訂單oeb41,oeb42,oeb43,oeb1001帶入工單的sfb27,sfb271,sfb50,sfb51
# Modify.........: No:MOD-CC0162 12/12/26 By Elise 調整因ima56=0使數量不會自動帶出的問題
# Modify.........: No:CHI-C50029 13/03/08 By Alberti 當下階料皆為消耗性料件時，預設扣帳方式為2:事後扣帳
#                                                    一併修改MOD-C80095
# Modify.........: No:FUN-D10127 13/03/15 By Alberti 增加sfduser,sfdgrup,sfdmodu,sfddate,sfdacti
# Modify.........: No.DEV-D30026 13/03/18 By Nina GP5.3 追版:DEV-D10003為GP5.25 的單號
# Modify.........: No.DEV-D30037 13/03/21 By TSD.JIE 有用smyb01="2:條碼單據"的控卡的改為用單身任一筆(MIN(項次)判斷即可)料件是否為包號管理(ima931)='Y'
# Modify.........: No.MOD-D40028 13/04/08 By bart 如果該料已預計停產且生效日期<today，則不產生至單身，且於彙總訊息顯示
# Modify.........: No.MOD-D50030 13/05/06 By bart 要針對勾選的單身資料進行檢核
# Modify.........: No.FUN-D50098 13/06/03 By lixh1 母工單的產生和子工單的產生包含在一個事物里
# Modify.........: No:MOD-D60188 13/06/24 By Alberti 修正MOD-CB0115之問題
# Modify.........: No:MOD-D70080 13/07/11 By Alberti 調整因ima56=0使數量不會自動帶出的問題
#                                                    修正CHI-B80044之問題
# Modify.........: No:FUN-D80022 13/08/20 By fengrui 鞋服功能改善
# Modify.........: No:MOD-D80184 13/09/02 By Alberti 如主件是phase out，則需控卡不可拋轉
# Modify.........: No:MOD-D90072 13/09/16 By Alberti 新增: 當abmi600 有4:開窗詢問是否展開，轉訂單時也會詢問
# Modify.........: No:CHI-D90021 13/09/16 By Alberti 還原MOD-D80184部分，並調整MOD-D40028之訊息內容
# Modify.........: No:CHI-DA0027 13/10/21 By Alberti 重新根據生產單位批量(ima56)及生產時耗損率(ima562)來計算生產量(new_qty)，
# Modify.........: No:TQC-DA0029 13/10/22 By yangxf  BUG修改，事务回滚不继续往下执行
# Modify.........: No:TQC-E10045 14/01/16 By lixh1   數組變量引用錯誤 mg[i] => mg[i].orno
# Modify.........: No:FUN-E20042 14/02/28 By jingll  鞋服行業插入行業別資料檔
# Modify.........: No:MOD-E30038 14/03/07 By Alberti 修正 單身 部門/廠商(ven_no)指控卡部門(gem_file)，沒有控卡到廠商(pmc_file)
# Modify.........: No:MOD-E30086 14/03/17 By Alberti 修正 在拋轉成工單時 sfb06開窗應開也可以選到ima571(預設製程編號)，並且會帶至工單製程追蹤(aeci700)裡面
# Modify.........: No:MOD-E40116 14/04/18 By Alberti 補預設值edg40 = 0 
# Modify.........: No:MOD-E50093 14/05/19 By apo 行業別為新鞋服的情形,asf-939必須強制控卡
# Modify.........: No:MOD-EC0058 14/12/11 By liliwen 生產數量需考慮生產單位小數位取位
# Modify.........: No:MOD-F10084 15/01/20 By liliwen 1.工單型態為5.再加工工單 或 8.重工委外工單時，不控管生產數量
#                                                    2.相同條件無須重複寫，故mark
# Modify.........: No:MOD-FA0074 15/10/19 By fionchen 訂單轉工單時,應排除出貨料號為'P'採購料件的資料 
# Modify.........: No:MOD-FA0134 15/10/27 By fionchen 訂單轉工單時,sfb14,sfb16需給預設值00:00 
# Modify.........: No:MOD-FB0042 15/11/06 By fionchen 挑選單別後,重新設定單據類型 
# Modify.........: No:MOD-FB0085 15/11/16 By fionchen 調整MOD-E30038,當執行確認檢查單身資料時,判斷工單型態與部門/廠商資料時,判斷的筆數參數調整為一致 
# Modify.........: No:MOD-G10147 16/01/27 By fionchen 將smy57_6帶入委外型態預設值 
# Modify.........: No:MOD-G60047 16/06/08 By fionchen 處理自動確認時,應帶入該陣列位置的工單單號 
# Modify.........: No:MOD-G60089 16/06/17 By fionchen 若為背景產生工單時,應將工單型態設定為單據類型 
# Modify.........: No.0000664623_06_M001 17/11/15 By TSD.Nic 同時以所有成功產生之子母工單產生一張請購單
# Modify.........: No.0000664623_06_M001 18/01/09 By TSD.Jin (駐廠調整)庫存可用量改為預計可用量並加回自己這張訂單的數量
# Modify.........: No.0000664623_06_M012 18/01/29 By TSD.Nic 1. 工單不自動確認 2.轉請購單不須控卡工單已確認 3.請購單依ima43拆單 4.料號5開頭(客供料)不轉請購單
# Modify.........:                       20180409 By momo 調整ima43若無輸入，仍需產生請購單
# Modify.........:                       20180410 By momo 請購單預設單別抓取aooi410
# Modify.........:                       20180410 By momo 工單完工日預設為訂單排交日
# Modify.........:                       20180417 By momo 品名前增加顯示BOM發放日期
# Moify..........:                       20180502 By momo 修正工單轉請購有時無法產生之問題
# Modify.........:                       20180528 By momo 請購單身未稅金額欄位改抓pmlud07
# Modify.........:                       20180607 By momo 修正當無BOM時，工單單頭扣帳方式式帶「事後扣帳」、工單類型一律參考單據設定
# Modify.........:                       20181019 By momo 新增核取 pr_date, 產生時選擇是否參考採購前置日
# Modify.........: NO:1908083453 20190814 By momo 增加 pmkud03 預設值N
# Modify.........: NO:23090030   20231004 By momo 增加訂單數量，並該數量與生產量勾稽，不同時跳出提示
# Modify.........: NO:23100041   20231030 By momo 應生產量有誤，未考量退貨情況

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE
         g_argv1   LIKE   oea_file.oea01,  #TQC-730022
         g_argv2   LIKE   smy_file.smyslip,  #TQC-730022
         g_argv3   LIKE   type_file.chr1,    #TQC-730022
         g_ima     RECORD LIKE ima_file.*,
         g_oea     RECORD LIKE oea_file.*,
         g_sfb     RECORD LIKE sfb_file.*,
         g_flag    LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
         sfc_sw    LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
         lot       LIKE type_file.num10,   #No.FUN-680121 INTEGER, 
#        lota      LIKE ima_file.ima26,    #No.FUN-680121 DEC(15,3), 
         lota      LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044 
         l_mod     LIKE type_file.num10,   #No.FUN-680121 INTEGER, 
         g_cmd,g_sql,g_sql_smy  STRING,  #No.FUN-580092 HCN
         g_t1      LIKE oay_file.oayslip,                     #No.FUN-550067        #No.FUN-680121 VARCHAR(05)
         g_sw      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
         mm_sfb08  LIKE sfb_file.sfb08,
         l_ima60   LIKE ima_file.ima60,
         l_ima601  LIKE ima_file.ima601,   #No.FUN-840194 
         l_oeb05   LIKE oeb_file.oeb05,
         l_ima55   LIKE ima_file.ima55,
         l_ima562  LIKE ima_file.ima562,
         g_ecu01   LIKE ecu_file.ecu01,   #MOD-E30086 add
 
         new DYNAMIC ARRAY OF RECORD
                x             LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
                oeb01         LIKE oeb_file.oeb01,    #No.FUN-810014
                oeb03         LIKE oeb_file.oeb03,
                new_part      LIKE ima_file.ima01,    #No.MOD-490217
                ima02         LIKE ima_file.ima02,
                ima021        LIKE ima_file.ima021,   #No.FUN-940103
                sfb93         LIKE sfb_file.sfb93,    #FUN-A50066
                sfb06         LIKE sfb_file.sfb06,    #FUN-A50066
                oeb12         LIKE oeb_file.oeb12,    #20231004 訂單數量
                edc01         LIKE edc_file.edc01,    #FUN-A80054
                edc02         LIKE edc_file.edc02,    #FUN-A80054
                ima910        LIKE ima_file.ima910,   #FUN-650193
                new_qty       LIKE sfb_file.sfb08,    #No.FUN-680121 DEC(15,3),
                sfb919        LIKE sfb_file.sfb919,   #FUN-A80102
                b_date        LIKE type_file.dat,     #No.FUN-680121 DATE
                e_date        LIKE type_file.dat,     #No.FUN-680121 DATE
                sfb02         LIKE sfb_file.sfb02,    #FUN-650054
                new_no        LIKE oea_file.oea01,    #No.FUN-680121 VARCHAR(16), #No.FUN-550067  
                ven_no        LIKE pmc_file.pmc01,    #No.FUN-680121 VARCHAR(10),
                a             LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
                costcenter    LIKE gem_file.gem01, #FUN-670103
                gem02c        LIKE gem_file.gem02  #FUN-670103
                END RECORD,
         ##---- 20231004 add by momo (S) COLOR
         new_color DYNAMIC ARRAY OF RECORD
                x             STRING,
                oeb01         STRING,
                oeb03         STRING,
                new_part      STRING,
                ima02         STRING,
                ima021        STRING,
                sfb93         STRING,
                sfb06         STRING,
                oeb12         STRING,
                edc01         STRING,
                edc02         STRING,
                ima910        STRING,
                new_qty       STRING,
                sfb919        STRING,
                b_date        STRING,
                e_date        STRING,
                sfb02         STRING,
                new_no        STRING,  
                ven_no        STRING,
                a             STRING,
                costcenter    STRING,
                gem02c        STRING
                END RECORD,
         ##---- 20231004 add by momo (E)
         tm         RECORD
                gen02         LIKE gen_file.gen02,
                desc          LIKE pmc_file.pmc01,  #No.FUN-680121 VARCHAR(10),
                gem01         LIKE gem_file.gem01,  #FUN-670103
                skd01         LIKE skd_file.skd01, #No.FUN-810014
                sfb81         LIKE sfb_file.sfb81, #No.FUN-810014
                sfc01         LIKe sfc_file.sfc01, #No.FUN-810014
                bmb09         LIKE bmb_file.bmb09, #No.FUN-870117
                mac_opt       LIKE type_file.chr1  #FUN-A80102
                END RECORD
#FUN-D50098 ------Begin------
  DEFINE 
   mg
      DYNAMIC ARRAY OF RECORD
         orno  LIKE sfb_file.sfb01
      END RECORD
#FUN-D50098 ------End--------
  DEFINE l_slip LIKE sfb_file.sfb01   #00-12-26
 
DEFINE   pr_date         LIKE type_file.chr1     #20181019 add 
DEFINE   l_max_no        LIKE sfb_file.sfb01     #No.MOD-960317 add
DEFINE   l_min_no        LIKE sfb_file.sfb01     #No.MOD-960317 add
DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680121 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(72)
DEFINE   g_wc            STRING                  #FUN-920088
DEFINE   l_barcode_yn    LIKE ima_file.ima930    #DEV-D30026 add      #條碼使用否 
DEFINE   g_argv4         LIKE type_file.chr20    #FUN-D80022 add by zhuhao
#M001 171115 By TSD.Nic -----(S)
DEFINE   g_wos           STRING
DEFINE   g_pmk           RECORD LIKE pmk_file.*
DEFINE   g_t2            LIKE type_file.chr5
DEFINE   g_bookno1       LIKE aza_file.aza81
DEFINE   g_bookno2       LIKE aza_file.aza82
#M001 171115 By TSD.Nic -----(E)

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   LET g_argv1  = ARG_VAL(1)
   LET g_argv2  = ARG_VAL(2)
   LET g_argv3  = ARG_VAL(3)
   IF cl_null(g_argv3) THEN
     LET g_argv3 = 'N'
   END IF
   LET g_bgjob  = ARG_VAL(4)
   LET g_argv4  = ARG_VAL(5)                      #FUN-D80022 add by zhuhao
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #No:MOD-A70028 add

   #M001 171117 By TSD.Nic -----(S)
   #p470使用
   DROP TABLE apm_p470

   CREATE TEMP TABLE apm_p470(
       ta_sfb01 LIKE sfb_file.ta_sfb01,
       sfb01    LIKE sfb_file.sfb01,
       part     LIKE sfa_file.sfa03,
       sfa26    LIKE sfa_file.sfa26,
       sfb13    LIKE sfb_file.sfb13,    #實際開工日
       req_qty  LIKE sfa_file.sfa04,
       al_qty   LIKE sfa_file.sfa04,
       pr_qty   LIKE sfa_file.sfa04,
       po_qty   LIKE sfa_file.sfa04,
       qc_qty   LIKE sfa_file.sfa04,
       wo_qty   LIKE sfa_file.sfa04)

   CREATE UNIQUE INDEX p470_t1 ON apm_p470 (ta_sfb01,sfb01,part,sfa26,sfb13)

   DELETE FROM apm_p470 WHERE 1=1
   #M001 171117 By TSD.Nic -----(E)

   IF g_bgjob = 'N' THEN
      CALL p304_tm()
   ELSE
      LET g_oea.oea01 = g_argv1 CLIPPED
      LET g_sfb.sfb81 = TODAY
      CALL p304_fill_b_data(g_grup)
      LET g_success='Y'
      LET pr_date = 'Y'    #20220307
      CALL asfp304()
      
      IF g_success='Y' THEN
         MESSAGE "Success!"
      END IF
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No:MOD-A70028 add
END MAIN
 
FUNCTION p304_tm()
   DEFINE   p_row,p_col,i    LIKE type_file.num5    #No.FUN-680121 SMALLINT
#  DEFINE   mm_qty,mm_qty1   LIKE ima_file.ima26    #No.FUN-680121 DEC(15,3)
   DEFINE   mm_qty,mm_qty1   LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_cnt,s_date     LIKE type_file.num5    #No.FUN-680121 SMALLINT  
   DEFINE   l_time           LIKE ima_file.ima58    #No.FUN-680121 DEC(15,3)
   DEFINE   l_sfb08          LIKE sfb_file.sfb08
   DEFINE   l_flag           LIKE type_file.chr1                  #No.FUN-680121 VARCHAR(1)
   DEFINE   l_cn             LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima55_fac      LIKE ima_file.ima55_fac
   DEFINE   l_check          LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima59          LIKE ima_file.ima59
   DEFINE   l_ima61          LIKE ima_file.ima61
   DEFINE   l_oea00          LIKE oea_file.oea00    #No.MOD-940349 add
   DEFINE   l_costcenter     LIKE gem_file.gem01   #FUN-670103
   DEFINE   l_gem02c         LIKE gem_file.gem02   #FUN-670103
   #M001 171116 By TSD.Nic -----(S)
   DEFINE   l_slip           LIKE smy_file.smyslip
   DEFINE   l_pmk02          LIKE pmk_file.pmk02
   DEFINE   li_result        LIKE type_file.num5
   #M001 171116 By TSD.Nic -----(E)
 
   IF s_shut(0) THEN
      RETURN
   END IF
   LET p_row = 2 
   LET p_col = 4 
 
   IF s_industry('slk') THEN
     #FUN-D80022--add--str--
     IF g_sma.sma150 = 'Y' THEN 
        OPEN WINDOW p304_w AT p_row,p_col
           WITH FORM "csf/42f/asfp304"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
     ELSE
     #FUN-D80022--add--end--
        OPEN WINDOW p304_w AT p_row,p_col
           WITH FORM "asf/42f/asfp304_a"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
     END IF  #FUN-D80022 add 
   ELSE
     OPEN WINDOW p304_w AT p_row,p_col
        WITH FORM "csf/42f/asfp304"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   END IF 
    
   CALL cl_ui_init()    
 
   CALL cl_set_comp_visible("ima910",g_sma.sma118='Y')
   IF g_aaz.aaz90='Y' THEN
      CALL cl_set_comp_required("gem01",TRUE)
   END IF
   CALL cl_set_comp_visible("costcenter,gem02c",g_aaz.aaz90='Y')
   CALL cl_set_comp_visible("sfb919,gb3",g_sma.sma1421='Y')  #FUN-A80102
   CALL cl_set_comp_visible("edc01,edc02",g_sma.sma541='Y')  #FUN-A80054
 
   CALL cl_opmsg('z')
 
   WHILE TRUE  #MOD-490189
 
   MESSAGE ''
   CLEAR FORM 
   INITIALIZE g_oea.* TO NULL
   INITIALIZE tm.*    TO NULL
   #M001 171116 By TSD.Nic -----(S)
   INITIALIZE g_pmk.* TO NULL
   CALL p304_pmk_default()
   #M001 171116 By TSD.Nic -----(E)
   LET mm_qty=0   
   LET mm_qty1=0   
   LET sfc_sw='Y'
   LET lot=1   
   LET g_sw='N' 
   LET g_sfb.sfb81 = TODAY
   LET pr_date = 'Y'        #20220307
   LET l_ima59=0
   LET l_ima60=0
   LET l_ima61=0
   LET tm.gem01=g_grup    #FUN-670103
   LET l_gem02c = ''                                              #FUN-920088
   SELECT gem02 INTO l_gem02c FROM gem_file WHERE gem01=tm.gem01  #FUN-920088
      AND gemacti='Y'                                             #FUN-920088
#FUN-D80022 ---------- add ---------- begin ------------ by zhuhao
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv4) AND g_argv4='axmt410_slk' AND g_sma.sma150 = 'Y' THEN
      LET g_wc = " oea01 = '",g_argv1 CLIPPED,"' "
   ELSE
#FUN-D80022 ---------- add ---------- end -------------- by zhuhao
      IF s_industry('slk') AND g_sma.sma150='N' THEN  #FUN-D80022
         LET tm.sfb81 = g_today
         DISPLAY BY NAME tm.sfb81
         INPUT BY NAME tm.skd01,tm.sfb81,tm.sfc01,tm.bmb09  WITHOUT DEFAULTS   #No.FUN-870117 --add bmb09
         
         AFTER FIELD skd01
            IF NOT cl_null(tm.skd01) THEN
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt  FROM skd_file WHERE skd01=tm.skd01 AND skdacti='Y' AND skd04='Y'
               IF l_cnt <=0 THEN 
                      CALL cl_err(tm.skd01,'mfg420',0) 
                     NEXT FIELD skd01
               END IF
            ELSE
                     NEXT FIELD skd01
            END IF
            
         AFTER FIELD bmb09 
            IF NOT cl_null(tm.bmb09) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM oeb_file,oebi_file,bmb_file
               WHERE oeb01= oebi01 and oeb04 = bmb01
                 AND oebislk01 = tm.skd01 and bmb09 = tm.bmb09
                 AND oeb03 = oebi03  
                  IF l_cnt <=0 THEN 
                    CALL cl_err(tm.bmb09,'asf-402',0) 
                    NEXT FIELD bmb09
                  END IF
            END IF 
            
         AFTER FIELD sfc01
            IF NOT cl_null(tm.sfc01) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM sfc_file,sfci_file WHERE sfc01 = sfci01 AND sfc01=tm.sfc01 AND sfcislk01=tm.skd01 AND sfcislk05='Y' AND sfcacti='Y'
               IF l_cnt <=0 THEN 
                      CALL cl_err(tm.sfc01,'asf-401',0) 
                     NEXT FIELD sfc01
               END IF
            END IF  
         ON ACTION CONTROLP                  
               CASE
                   WHEN INFIELD(skd01)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_skd01"
                        LET g_qryparam.default1 = ''
                        CALL cl_create_qry() RETURNING tm.skd01 
                        DISPLAY BY NAME tm.skd01 
                        NEXT FIELD skd01
                   WHEN INFIELD(sfc01)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_sfc01"
                        LET g_qryparam.default1 = ''
                        LET g_qryparam.arg1 = tm.skd01
                        CALL cl_create_qry() RETURNING tm.sfc01 
                        DISPLAY BY NAME tm.sfc01 
                        NEXT FIELD sfc01
                   WHEN INFIELD(bmb09)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_bmb09"
                        LET g_qryparam.default1 = ''
                        LET g_qryparam.arg1 = tm.skd01
                        CALL cl_create_qry() RETURNING tm.bmb09 
                        DISPLAY BY NAME tm.bmb09 
                        NEXT FIELD bmb09
                   OTHERWISE EXIT CASE
               END CASE
            ON ACTION locale
               CALL cl_dynamic_locale()
               CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
         
         END INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0 
            EXIT WHILE
         END IF
      ELSE
         IF tm.mac_opt IS NULL THEN LET tm.mac_opt='N' END IF #FUN-A80102
         DISPLAY BY NAME g_sfb.sfb81,tm.gem01 #FUN-670103 #FUN-650054 ,tm.wo_type
         DISPLAY BY NAME tm.mac_opt  #FUN-A80102
         DISPLAY l_gem02c TO gem02   #FUN-920088
    
         INPUT BY NAME g_sfb.sfb81,tm.gem01,tm.mac_opt WITHOUT DEFAULTS  #FUN-670103 #FUN-650054 ,tm.wo_type #FUN-920088  #FUN-A80102
    
           AFTER FIELD gem01
               IF NOT cl_null(tm.gem01) THEN
                  IF g_aaz.aaz90='Y' THEN
                     IF NOT s_costcenter_chk(tm.gem01) THEN
                        LET tm.gem01=NULL
                        DISPLAY BY NAME tm.gem01
                        DISPLAY NULL TO FORMONLY.gem02
                        NEXT FIELD gem01
                     ELSE
                        DISPLAY s_costcenter_desc(tm.gem01) TO FORMONLY.gem02
                     END IF               
                  ELSE
                     LET l_gem02c = ''
                     SELECT gem02 INTO l_gem02c FROM gem_file WHERE gem01=tm.gem01
                        AND gemacti='Y'
                     IF STATUS THEN
                        CALL cl_err3("sel","gem_file",tm.gem01,"",STATUS,"","select gem",1)
                        NEXT FIELD gem01 
                     END IF
                     DISPLAY l_gem02c TO gem02
                  END IF
               END IF
           #TQC-C80187----add----begin
           AFTER INPUT
                 IF INT_FLAG THEN
                    EXIT INPUT
                 END IF
                 IF NOT cl_null(tm.gem01) THEN
                    SELECT gem02 INTO l_gem02c FROM gem_file WHERE gem01=tm.gem01
                        AND gemacti='Y'
                     IF STATUS THEN
                        CALL cl_err3("sel","gem_file",tm.gem01,"",STATUS,"","select gem",1)
                        NEXT FIELD gem01
                     END IF   
                 END IF  
           #TQC-C80187----add----end    
               ON ACTION CONTROLP
                  CASE
                     WHEN INFIELD(gem01)
                         CALL cl_init_qry_var()
                         IF g_aaz.aaz90='Y' THEN
                            LET g_qryparam.form ="q_gem4"
                         ELSE
                            LET g_qryparam.form ="q_gem"
                         END IF
                         LET g_qryparam.default1 = tm.gem01
                         CALL cl_create_qry() RETURNING tm.gem01
                         DISPLAY BY NAME tm.gem01
                         NEXT FIELD gem01
                     OTHERWISE EXIT CASE
                 END CASE
    
            ON ACTION locale
               CALL cl_dynamic_locale()
               CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
   
   #TQC-A50129 --begin--         
            ON ACTION controlg
               CALL cl_cmdask()   
   #TQC-A50129 --end--  
         
         END INPUT
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         CONSTRUCT BY NAME g_wc ON oea01,oea02,oea14,oea03
    
            BEFORE CONSTRUCT 
                CALL cl_qbe_init()
       
            ON ACTION CONTROLP
               CASE
                 WHEN INFIELD(oea01)
   # HOT CODE....有問題請找saki
                    CALL q_oea4(TRUE,TRUE,g_oea.oea01,' ')
                    RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea01
                    NEXT FIELD oea01
                 WHEN INFIELD(oea14)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gen" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret 
                    DISPLAY g_qryparam.multiret TO oea14
                    NEXT FIELD oea14
                 WHEN INFIELD(oea03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c" 
                    LET g_qryparam.form ="q_occ3" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                          
                    DISPLAY g_qryparam.multiret TO oea03                                                                        
                    NEXT FIELD oea03  
               END CASE
             ON ACTION exit                                                                                                            
                LET INT_FLAG = 1                                                                                                       
                EXIT CONSTRUCT                                                                                                         
             ON IDLE g_idle_seconds                                                                                                    
                CALL cl_on_idle()                                                                                                      
                CONTINUE CONSTRUCT
    
             ON ACTION about
                CALL cl_about()
    
             ON ACTION help
                CALL cl_show_help()
    
             ON ACTION controlg
                CALL cl_cmdask()
    
             ON ACTION qbe_select
                CALL cl_qbe_select()
    
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         #M001 171116 By TSD.Nic -----(S)
         DISPLAY 'Y' TO pr_date 
         INPUT BY NAME g_pmk.pmk01,g_pmk.pmk04,g_pmk.pmk02,pr_date WITHOUT DEFAULTS #20181019 add pr_date

            ##---- 20180410 預設請購單別(S)
            BEFORE FIELD pmk01
              SELECT rye03 INTO g_pmk.pmk01 FROM rye_file
               WHERE rye01 = 'apm' AND ryeacti = 'Y' and rye02='1' AND ta_rye01='asfp304'
            DISPLAY BY NAME g_pmk.pmk01
            ##---- 20180410 預設請購單別(E)

            AFTER FIELD pmk01
               IF NOT cl_null(g_pmk.pmk01) THEN
                  LET g_t2=s_get_doc_no(g_pmk.pmk01)
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM  rye_file WHERE rye04 = g_t2 AND ryeacti = 'Y' AND rye01 = 'apm'
                  IF l_cnt > 0 THEN
                     CALL cl_err(g_t2,'apc1036',0)
                     NEXT FIELD pmk01
                  END IF

                  CALL s_check_no("apm",g_pmk.pmk01,"","1","pmk_file","pmk01","") RETURNING li_result,g_pmk.pmk01
                  DISPLAY BY NAME g_pmk.pmk01
                  IF (NOT li_result) THEN
                     NEXT FIELD pmk01
                  END IF

                  LET l_pmk02 = ''
                  SELECT smy72,smyapr,smysign
                    INTO l_pmk02,g_pmk.pmkmksg,g_pmk.pmksign
                    FROM smy_file
                   WHERE smyslip = g_t2
                  IF NOT cl_null(l_pmk02) THEN
                     LET g_pmk.pmk02 = l_pmk02
                     DISPLAY BY NAME g_pmk.pmk02
                  END IF
             
                  LET g_pmk.pmkprsw = 'Y'
               END IF

            AFTER FIELD pmk04       #請購日期(預設會計年度/期間)
               IF NOT cl_null(g_pmk.pmk04) THEN
                  IF NOT cl_null(g_sma.sma53) AND g_pmk.pmk04 <= g_sma.sma53 THEN
                    CALL cl_err('','mfg9999',0)
                    NEXT FIELD pmk04
                  END IF
                  SELECT azn02,azn04 INTO g_pmk.pmk31,g_pmk.pmk32 FROM azn_file
                   WHERE azn01 = g_pmk.pmk04
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("sel","azn_file",g_pmk.pmk04,"","mfg0027","","",1)
                     LET g_pmk.pmk04 = ''
                     DISPLAY BY NAME g_pmk.pmk04
                     NEXT FIELD pmk04
                  END IF
                  CALL s_get_bookno(YEAR(g_pmk.pmk04))
                       RETURNING g_flag,g_bookno1,g_bookno2
                  IF g_flag =  '1' THEN  #抓不到帳別
                     CALL cl_err(g_pmk.pmk04,'aoo-081',1)
                     NEXT FIELD pmk04
                  END IF
                  IF g_aza.aza17 != g_pmk.pmk22 THEN
                     CALL s_curr3(g_pmk.pmk22,g_pmk.pmk04,g_sma.sma904)
                        RETURNING g_pmk.pmk42
                  END IF
                  DISPLAY 'N' TO pr_date
               END IF

            AFTER INPUT
               IF INT_FLAG THEN
                  EXIT INPUT
               END IF
               LET g_pmk.pmkuser = s_get_data_owner("pmk_file")
               LET g_pmk.pmkgrup = s_get_data_group("pmk_file")

            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(pmk01) #單據編號
                     LET g_t2=s_get_doc_no(g_pmk.pmk01)
                     CALL q_smy(FALSE,FALSE,g_t2,'APM','1') RETURNING g_t2
                     LET g_pmk.pmk01 = g_t2
                     DISPLAY BY NAME g_pmk.pmk01
                     NEXT FIELD pmk01
                  OTHERWISE
                     EXIT CASE
              END CASE
    
            ON ACTION locale
               CALL cl_dynamic_locale()
               CALL cl_show_fld_cont()
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
            ON ACTION controlg
               CALL cl_cmdask()   
         END INPUT
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         #M001 171116 By TSD.Nic -----(E)
      END IF 
   END IF              #FUN-D80022 add by zhuhao
      
      #將塞單身這段整個搬出成一個FUNCTION
      CALL p304_fill_b_data(tm.gem01)
            
      LET g_success='Y'
      LET g_flag='Y'
      CALL asfp304()
         CALL cl_confirm('lib-005') RETURNING l_flag
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      ERROR ""
   END WHILE
 
   CLOSE WINDOW p304_w
 
END FUNCTION
 
FUNCTION p304_fill_b_data(p_gem01)
   DEFINE   p_gem01          LIKE gem_file.gem01
   DEFINE   l_cnt,s_date     LIKE type_file.num5    #No.FUN-680121 SMALLINT  
   DEFINE   l_time           LIKE ima_file.ima58    #No.FUN-680121 DEC(15,3)
   DEFINE   l_sfb08          LIKE sfb_file.sfb08
   DEFINE   l_sfb09          LIKE sfb_file.sfb09    #MOD-D60188 add
   DEFINE   l_flag           LIKE type_file.chr1                  #No.FUN-680121 VARCHAR(1)
   DEFINE   l_cn             LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima55_fac      LIKE ima_file.ima55_fac
   DEFINE   l_check          LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima59          LIKE ima_file.ima59
   DEFINE   l_ima61          LIKE ima_file.ima61
   DEFINE   l_costcenter     LIKE gem_file.gem01    #FUN-670103
   DEFINE   l_gem02c         LIKE gem_file.gem02    #FUN-670103
   DEFINE   li_result        LIKE type_file.num5    #No.TQC-730022
   DEFINE   l_oea00          LIKE oea_file.oea00    #FUN-920088
   DEFINE   l_smy57          LIKE smy_file.smy57    #FUN-A50066
   DEFINE   l_sql            STRING                 #FUN-A80102
   DEFINE   l_tmp            STRING                 #FUN-A80102
   DEFINE   l_snum,l_enum    STRING                 #FUN-A80102
   DEFINE   l_ssn,l_esn      LIKE type_file.num20   #FUN-A80102
   DEFINE   l_avg_oeb12,l_tol_oeb12,l_sum_oeb12  LIKE oeb_file.oeb12    #FUN-A80102
   DEFINE   l_ima54          LIKE ima_file.ima54    #MOD-AB0243 add
   DEFINE   l_ima08          LIKE ima_file.ima08    #MOD-AB0243 add
   DEFINE   tok1             base.StringTokenizer   #FUN-B20075
   DEFINE   l_token_cnt      LIKE type_file.num10   #FUN-B20075
   DEFINE   l_sfb919         LIKE sfb_file.sfb919   #FUN-B20075
   #CHI-B80044 -- begin --
   DEFINE   l_availqty       LIKE sfb_file.sfb08   #訂單可轉工單數量
   DEFINE   l_calc           LIKE type_file.num5   #計算生產批量倍數用
   DEFINE   l_allowqty       LIKE sfb_file.sfb08   #允許生產數量
   #CHI-B80044
  #DEFINE   l_str            STRING                #MOD-D80184 add #CHI-D90021 mark
   DEFINE   l_msg            LIKE type_file.chr100                 #CHI-D90021 add
   DEFINE   l_fld01          LIKE gaq_file.gaq03                   #CHI-D90021 add
   DEFINE   l_fld02          LIKE gaq_file.gaq03                   #CHI-D90021 add
   DEFINE   l_fld03          LIKE gaq_file.gaq03                   #CHI-D90021 add
   DEFINE   l_qty            LIKE sfb_file.sfb08                   #CHI-DA0027 add
   DEFINE   l_ima56          LIKE ima_file.ima56                   #CHI-DA0027 add
   DEFINE   l_smy72          LIKE smy_file.smy72                   #MOD-G60089 add
   DEFINE   l_bma05          LIKE bma_file.bma05                   #20190905 add
   #M001 180109 By TSD.Jin--start--
   DEFINE   l_ima            RECORD
               oeb_q         LIKE type_file.num15_3,
               sfa_q1        LIKE type_file.num15_3,
               sfa_q2        LIKE type_file.num15_3,
               misc_q1       LIKE type_file.num15_3,
               sfs_q2        LIKE type_file.num15_3,
               sie_q         LIKE type_file.num15_3,
               pml_q         LIKE type_file.num15_3,
               pmn_q         LIKE type_file.num15_3,
               rvb_q2        LIKE type_file.num15_3,
               rvb_q         LIKE type_file.num15_3,
               sfb_q1        LIKE type_file.num15_3,
               sfb_q2        LIKE type_file.num15_3,
               qcf_q         LIKE type_file.num15_3,
               atp_qty       LIKE type_file.num15_3
                             END RECORD
   #M001 180109 By TSD.Jin--end----
   
      CALL new.clear()
      CALL new_color.clear()  #20231004
      LET l_costcenter=s_costcenter(p_gem01) #FUN-670103
      LET l_gem02c=s_costcenter_desc(l_costcenter) #FUN-670103
     #MOD-C40193 str add------
      IF cl_null(g_wc) THEN
         LET g_wc= 'oeb01=',"'",g_argv1,"'"
      END IF
     #MOD-C40193 end add------
     #LET l_str = ' OR ima1401 >',"'" ,g_sfb.sfb81,"'" ,' )' #MOD-D80184 add  #CHI-D90021 mark
      
    #IF s_industry('slk') THEN  #FUN-D80022 mark 
    IF s_industry('slk') AND g_sma.sma150 = 'N' THEN  #FUN-D80022 add
      LET g_sql = "SELECT 'Y',oeb01,oeb03,oeb04,ima02,ima021,'N','', ",
                 #"oeb12, ",                                              #20231004 #20231030
                  "oeb12-oeb905-oeb24+oeb25-oeb26, ",                     #20231030 modify 未出貨量
                  "oeb918,'',ima910,",
                  "oeb12-oeb905,",
                  "oeb919,NULL,oeb15, ",    #FUN-A50066 #FUN-A80102 #FUN-A80054   #No.FUN-940103 add ima021   #MOD-C50030 mark  #MOD-C70255 remark
     #LET g_sql = "SELECT 'Y',oeb01,oeb03,oeb04,ima02,ima021,'N','',oeb918,'',ima910,oeb12-oeb905-oeb24+oeb25,oeb919,NULL,oeb15, ",    #FUN-A50066 #FUN-A80102 #FUN-A80054   #No.FUN-940103 add ima021 #MOD-C50030  #MOD-C70255 mark
                  " '1',ima111,' ','Y',oeb930,'',oeb05,ima55,((100+ima562)/100),ima60,ima601 ",   #No.MOD-940205 add
                  " ,ima54,ima08 ",       #MOD-AB0243 add
                  " FROM oeb_file,ima_file,oebi_file,oea_file ",   #MOD-920243 add oea_file          
                  " WHERE oebislk01='",tm.skd01,"' ",
                  "  AND oeb01 = oebi01 ",
                  "  AND oeb03 = oebi03 ",
                  "  AND oeb12>(oeb24-oeb25+oeb905) ",  
                  "  AND oeb01 = oea01 ",       #MOD-920243 add
                  "  AND  oeb70 = 'N' ",   
                  "  AND oeb04 = ima01 ",
                  "  AND oeb04 NOT LIKE 'MISC%' AND oeb04 NOT LIKE 'misc%' ",  #MOD-C30872
                  "  AND ima08<>'P' ",   #MOD-FA0074 add
                  "  AND ima911<>'Y' ",
                 #"  AND (ima140 = 'N' ", l_str CLIPPED,   #MOD-D80184 add   #CHI-D90021 mark
                  "  AND NOT EXISTS(SELECT * from sfb_file where sfb22= oeb01 and sfb221 =oeb03)"  #No.FUN-870117
      ELSE
      LET g_sql = "SELECT 'Y',oeb01,oeb03,oeb04,ima02,ima021,'N','', ",
                 #"oeb12, ",                                              #20231004 add #20231030 mark
                  "oeb12-oeb905-oeb24+oeb25-oeb26, ",                     #20231030 modify 未出貨量
                  "oeb918,'',ima910,",
                 #"oeb12-oeb905,",
                  "oeb12-oeb905-oeb24+oeb25-oeb26, ",                     #20231030 modify 未出貨量
                  "oeb919,NULL,oeb16, ",   #MOD-530799 add  #FUN-650193 add ima910  #FUN-A50066 #FUN-A80102 #FUN-A80054    #No.FUN-940103 add ima021   #MOD-C50030 mark #MOD-C70255 remark #20180410 oeb15 change oeb16
     #LET g_sql = "SELECT 'Y',oeb01,oeb03,oeb04,ima02,ima021,'N','',oeb918,'',ima910,oeb12-oeb905,oeb919,NULL,oeb15, ",   #MOD-530799 add  #FUN-650193 add ima910  #FUN-A50066 #FUN-A80102 #FUN-A80054    #No.FUN-940103 add ima021   #MOD-C50030 mark #MOD-C70255 remark
     #LET g_sql = "SELECT 'Y',oeb01,oeb03,oeb04,ima02,ima021,'N','',oeb918,'',ima910,oeb12-oeb905-oeb24+oeb25,oeb919,NULL,oeb15, ",   #MOD-530799 add  #FUN-650193 add ima910  #FUN-A50066 #FUN-A80102 #FUN-A80054    #No.FUN-940103 add ima021 #MOD-C50030  #MOD-C70255 mark
                  " '1',ima111,' ','Y',oeb930,'',oeb05,ima55,((100+ima562)/100),ima60,ima601 ",   #No.MOD-940205 add
                  " ,ima54,ima08 ",       #MOD-AB0243 add
                  " FROM oeb_file,ima_file,oea_file ",            #MOD-530799 add oeb05,ima55,ima562  #MOD-920243 add oea_file
                  " WHERE ", g_wc CLIPPED, #FUN-920088
                  "  AND oeb12>(oeb24-oeb25+oeb905) ",   #FUN-570104 add oeb905
                  "  AND oeb04 = ima01 ",
                  "  AND oeb01 = oea01 ",       #MOD-920243 add
                  "  AND  oeb70 = 'N' ",  
                  "  AND EXISTS (SELECT * FROM bma_file WHERE bma01=oeb04 AND bma10='2')", #20190905 
                  "  AND oeb04 NOT LIKE 'MISC%' AND oeb04 NOT LIKE 'misc%' ",  #MOD-C30872
                 #"  AND (ima140 = 'N' ", l_str CLIPPED,   #MOD-D80184 add    #CHI-D90021 mark
                  "  AND ima08<>'P' ",   #MOD-FA0074 add
                  "  AND ima911<>'Y' "  #FUN-640083
      END IF
 
      #FUN-A80102(S)
      IF tm.mac_opt='Y' THEN  #將計畫批號拆解成號機
         DROP TABLE asfp304_tmp
         CREATE TEMP TABLE asfp304_tmp (
                x             LIKE type_file.chr1 ,
                oeb01         LIKE oeb_file.oeb01 ,
                oeb03         LIKE oeb_file.oeb03 ,
                new_part      LIKE ima_file.ima01 ,
                ima02         LIKE ima_file.ima02 ,
                ima021        LIKE ima_file.ima021,   #No.FUN-940103
                sfb93         LIKE sfb_file.sfb93 ,
                sfb06         LIKE sfb_file.sfb06 ,
                edc01         LIKE edc_file.edc01 , #FUN-A80054
                edc02         LIKE edc_file.edc02 , #FUN-A80054
                ima910        LIKE ima_file.ima910,
                new_qty       LIKE sfb_file.sfb08 ,
                sfb919        LIKE sfb_file.sfb919,
                b_date        LIKE type_file.dat  , 
                e_date        LIKE type_file.dat  , 
                sfb02         LIKE sfb_file.sfb02 ,
                new_no        LIKE oea_file.oea01 ,
                ven_no        LIKE pmc_file.pmc01 ,
                a             LIKE type_file.chr1 ,
                costcenter    LIKE gem_file.gem01 ,
                gem02c        LIKE gem_file.gem02 ,
                oeb05         LIKE oeb_file.oeb05 ,
                ima55         LIKE ima_file.ima55 ,
                ima562        LIKE ima_file.ima562,
                ima60         LIKE ima_file.ima60 ,
                ima601        LIKE ima_file.ima601,
                ima54         LIKE ima_file.ima54,      #MOD-AB0243 add  
                ima08         LIKE ima_file.ima08);     #MOD-AB0243 add 
         LET l_sql = " INSERT INTO asfp304_tmp " , g_sql
         PREPARE asfp304_tmp_p1 FROM l_sql
         EXECUTE asfp304_tmp_p1
         LET l_sql = "SELECT * FROM asfp304_tmp WHERE sfb919 LIKE '%-%'"
         PREPARE q_oeb_prepare1 FROM l_sql
         DECLARE oeb_curs1 CURSOR FOR q_oeb_prepare1
         LET g_i=1
         FOREACH oeb_curs1 INTO new[g_i].*,l_oeb05,l_ima55,l_ima562,l_ima60,l_ima601,l_ima54,l_ima08     #MOD-AB0243 add ima54,ima08
            IF new[g_i].sfb919 IS NULL THEN CONTINUE FOREACH END IF
            DELETE FROM asfp304_tmp WHERE oeb01 = new[g_i].oeb01 AND oeb03 = new[g_i].oeb03
            LET l_sfb919 = new[g_i].sfb919
            #FUN-B20075(S)
            LET tok1 = base.StringTokenizer.create(l_sfb919,",")
            WHILE tok1.hasMoreTokens()
               LET l_tmp = tok1.nextToken()
               LET l_tmp = l_tmp.trim()
               LET l_cnt = l_tmp.getindexof('-',1)
               IF l_cnt > 0 THEN
                  CALL s_machine_de_code(new[g_i].new_part,l_tmp) RETURNING l_snum,l_enum
                  LET l_ssn = l_snum
                  LET l_esn = l_enum
                  IF l_esn <= l_ssn THEN
                     CONTINUE FOREACH
                  END IF
                  LET l_sum_oeb12 = new[g_i].new_qty
                 #LET l_avg_oeb12 = s_trunc(l_sum_oeb12 / (l_esn - l_ssn + 1),0)  #FUN-B20075
                  LET l_avg_oeb12 = 1  #FUN-B20075
                  LET l_tol_oeb12 = 0
                 #LET new[g_i].new_qty = l_avg_oeb12 #FUN-B20075
                  FOR l_cnt = l_ssn TO l_esn
                     LET new[g_i].sfb919 = s_machine_en_code(new[g_i].new_part,l_cnt)
                     INSERT INTO asfp304_tmp VALUES (new[g_i].*,l_oeb05,l_ima55,l_ima562,l_ima60,l_ima601,l_ima54,l_ima08)  #TQC-B20161
                  END FOR
               #FUN-B20075(S)
               ELSE
                  IF l_tmp IS NOT NULL THEN
                     LET l_cnt = l_tmp
                     LET new[g_i].sfb919 = s_machine_en_code(new[g_i].new_part,l_cnt)
                     INSERT INTO asfp304_tmp VALUES (new[g_i].*,l_oeb05,l_ima55,l_ima562,l_ima60,l_ima601,l_ima54,l_ima08)  #TQC-B20161
                  END IF
               #FUN-B20075(E)
               END IF
            END WHILE
            #重計生產量
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM asfp304_tmp WHERE oeb01 = new[g_i].oeb01 AND oeb03 = new[g_i].oeb03
            IF l_cnt > 0 THEN
               LET l_avg_oeb12 = s_trunc(new[g_i].new_qty / l_cnt,0)
               IF l_avg_oeb12 = 0 THEN LET l_avg_oeb12 = 1 END IF
               UPDATE asfp304_tmp SET new_qty = l_avg_oeb12 WHERE oeb01 = new[g_i].oeb01 AND oeb03 = new[g_i].oeb03
               IF new[g_i].new_qty > (l_avg_oeb12 * l_cnt) THEN  #若有尾差,則攤入最後一筆
                  LET l_cn= 0 
                  SELECT COUNT(*) INTO l_cn  FROM asfp304_tmp 
                                            WHERE oeb01 = new[g_i].oeb01 
                                              AND oeb03 = new[g_i].oeb03
                                              AND sfb919 = new[g_i].sfb919
                  IF l_cn  = 1 THEN
                     LET new[g_i].new_qty = l_avg_oeb12 + new[g_i].new_qty - l_avg_oeb12 * l_cnt
                  ELSE
                     LET new[g_i].new_qty = l_avg_oeb12 + (new[g_i].new_qty - l_avg_oeb12 * l_cnt) / l_cn
                  END IF
                  UPDATE asfp304_tmp SET new_qty = new[g_i].new_qty 
                                   WHERE oeb01  = new[g_i].oeb01 
                                     AND oeb03  = new[g_i].oeb03
                                     AND sfb919 = new[g_i].sfb919
               END IF
            END IF
            #FUN-B20075(E)
            LET g_i=g_i+1
         END FOREACH
         LET g_sql = "SELECT * FROM asfp304_tmp ORDER BY oeb01,oeb03,sfb919" 
      END IF
      #FUN-A80102(E)
      PREPARE q_oeb_prepare FROM g_sql
      DECLARE oeb_curs CURSOR FOR q_oeb_prepare
      LET g_i=1
      CALL s_showmsg_init() #FUN-920088
       FOREACH oeb_curs INTO new[g_i].*,l_oeb05,l_ima55,l_ima562,l_ima60,l_ima601,l_ima54,l_ima08 #No:FUN-840194 add l_ima601  #CHI-810015拿掉,l_ima56  #FUN-710073 add  #MOD-530799 add   #MOD-AB0243 add l_ima54,l_ima08
  #FUN-B30463--add---begin
         IF g_sma.sma541 = 'N' THEN
            IF NOT cl_null(new[g_i].edc01) THEN
               LET new[g_i].edc01=''
            END IF
            IF NOT cl_null(new[g_i].edc02) THEN
               LET new[g_i].edc02=''
            END IF
         END IF
  #FUN-B30463--add--end       
         IF STATUS THEN
            EXIT FOREACH
         END IF
         #CHI-B80044 -- begin --
         SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = new[g_i].new_part
         #CHI-B80044 -- end --
        #MOD-AB0243---modify---start---
        #IF s_industry('std') THEN         #FUN-920088
        #   LET new[g_i].ven_no = tm.gem01 #FUN-920088
        #END IF                            #FUN-920088
        #CHI-D90021-Start-Add
        #LET g_msg = l_min_no CLIPPED,"~",l_max_no
        CALL cl_get_feldname('oeb01',g_lang) RETURNING l_fld01
        CALL cl_get_feldname('oeb03',g_lang) RETURNING l_fld02
        CALL cl_get_feldname('oeb04',g_lang) RETURNING l_fld03
        LET l_msg = l_fld01 CLIPPED,':',new[g_i].oeb01 CLIPPED,' ',l_fld02 CLIPPED,':',new[g_i].oeb03
                  ,' ',l_fld03 CLIPPED,':',new[g_i].new_part
        #CHI-D90021-End-Add
        #MOD-D40028---begin
       #IF g_ima.ima140 = 'Y' AND g_ima.ima1401 < g_today THEN   #CHI-D90021 mark
        IF g_ima.ima140 = 'Y' AND g_ima.ima1401 <= g_today THEN  #CHI-D90021 add
          #CALL s_errmsg('',new[g_i].new_part,'','aim-045',1)    #CHI-D90021 mark
           CALL s_errmsg('',l_msg,'','asf-960',1)    #CHI-D90021 add
           CONTINUE FOREACH
        END IF 
        #MOD-D40028---end
        #MOD-G60089 mark start -----------
        #搬到後面設定,因為當bgjob='Y'時,此時的new_no為null,因此無法取得正確的單據性質
        #IF l_ima08 = 'S' THEN     
        #   LET new[g_i].sfb02 = '7'
        #   LET new[g_i].ven_no = l_ima54
        #ELSE
        #   LET new[g_i].sfb02 = '1'
        #   IF s_industry('std') THEN
        #      LET new[g_i].ven_no = tm.gem01
        #   END IF
        #END IF
        #MOD-G60089 mark end   -----------
        #MOD-AB0243---modify---end---
         #FUN-A50066--begin--add----------
         IF g_sma.sma54 = 'Y' THEN
            IF NOT cl_null(new[g_i].new_no) THEN
               SELECT smy57 INTO l_smy57 FROM smy_file
                WHERE smyslip = new[g_i].new_no
               LET new[g_i].sfb93 = l_smy57[1,1]
            END IF
         END IF
         IF new[g_i].sfb93 = 'Y' THEN
           #TQC-AC0243 -------------mod start----------------------------
           #SELECT DISTINCT bra011 INTO new[g_i].sfb06 FROM bra_file
           # WHERE bra01 = new[g_i].new_part
           #   AND bra014 = 'Y'
            SELECT ima94 INTO new[g_i].sfb06 FROM ima_file 
             WHERE ima01 = new[g_i].new_part  
           #TQC-AC0243 ------------mod end----------------------------------- 
             IF cl_null(new[g_i].sfb06) THEN
                DECLARE ecu02_c CURSOR FOR 
                   SELECT ecu02 FROM ecu_file
                    WHERE ecu01 = new[g_i].new_part
                      AND ecu10='Y' AND ecuacti = 'Y'
                      AND ecuacti = 'Y'  #CHI-C90006
                FOREACH ecu02_c INTO new[g_i].sfb06
                   EXIT FOREACH
                END FOREACH
             END IF
         END IF
         #FUN-A50066--end--add------------
         #FUN-A80054--begin--add-----------
         IF NOT cl_null(new[g_i].edc01) THEN
            LET new[g_i].edc02=''
            SELECT MIN(edb02) INTO new[g_i].edc02 FROM eda_file,edb_file
             WHERE edb03=new[g_i].new_part
               AND edb01=new[g_i].edc01
               AND edb04=new[g_i].sfb06
               AND edb01=eda01 AND edaconf='Y'
         END IF
         #FUN-A80054--end--add------------
         LET l_sfb08 = 0
       IF s_industry('std') THEN
          LET g_oea.oea01 = new[g_i].oeb01
        LET l_oea00 = NULL
        SELECT oea00 INTO l_oea00 FROM oea_file
         WHERE oea01 = g_oea.oea01
        IF l_oea00 = '4' THEN
           CALL s_errmsg('oea00',g_oea.oea01,'sel oea00','axm-155',1)
           CONTINUE FOREACH
        END IF
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM oea_file
         WHERE oea01 = g_oea.oea01
           AND oeaconf = 'Y'
        IF l_cnt <=0 THEN 
       #   CALL s_errmsg('oea01',g_oea.oea01,'','asf-959',1)   #MOD-B30463
           CONTINUE FOREACH
        ELSE
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM oea_file
            WHERE  oea00 <> '0' AND oea00 <> '4'  
              AND oeaconf = 'Y'
              AND oea01 = g_oea.oea01
           IF l_cnt=0 THEN
              CALL s_errmsg('',g_oea.oea01,'','asf-005',1)
              CONTINUE FOREACH
           END IF
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt  FROM oeb_file
            WHERE oeb01 = g_oea.oea01
              AND oeb12>(oeb24-oeb25+oeb905)   #oeb905:已備置量
              AND oeb70 = 'N'    #No:MOD-970045 add
           IF l_cnt <=0 THEN   
              CALL s_errmsg('',g_oea.oea01,'','asf-962',1)
              CONTINUE FOREACH
           END IF
        END IF
       END IF
         IF NOT cl_null(g_argv2) THEN
            LET new[g_i].new_no = g_argv2 CLIPPED
            CALL s_check_no("asf",new[g_i].new_no,"","1","","","")  
            RETURNING li_result,new[g_i].new_no                                                  
         END IF
         #MOD-G60089 add start --------------------------
         #IF l_ima08 = 'S' THEN                  #20180607 mark
         #   LET new[g_i].sfb02 = '7'            #20180607 mark
         #   LET new[g_i].ven_no = l_ima54       #20180607 mark
         #ELSE                                   #20180607 mark
            SELECT smy72 INTO l_smy72 FROM smy_file 
             WHERE smyslip = new[g_i].new_no    
            IF l_smy72 = '7' THEN
               LET new[g_i].sfb02 = '7'
            ELSE
               LET new[g_i].sfb02 = '1'
               IF s_industry('std') THEN
                  LET new[g_i].ven_no = tm.gem01
               END IF
            END IF     
         #END IF                                #20180607 mark
         #MOD-G60089 add end   --------------------------
         CALL s_umfchk(new[g_i].new_part,l_oeb05,l_ima55)
                            RETURNING l_check,l_ima55_fac
         IF cl_null(l_ima55_fac) THEN 
            LET l_ima55_fac = 1
         END IF
         LET new[g_i].new_qty = new[g_i].new_qty * l_ima55_fac * l_ima562   #MOD-990224
         
         IF cl_null(new[g_i].sfb919) THEN   #FUN-A80102
            SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
             WHERE sfb22  =  g_oea.oea01
               AND sfb221 =  new[g_i].oeb03 
              #AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 = sfb09))   #MOD-530799  #MOD-CB0115 mark
              #AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 <= sfb09))  #MOD-CB0115  #MOD-D60188 mark
               AND sfb04 <> '8'                                                     #MOD-D60188 add    
               AND sfb87!='X'

            #MOD-D60188-Start-Add
            SELECT SUM(sfb09) INTO l_sfb09 FROM sfb_file
             WHERE sfb22  =  g_oea.oea01
               AND sfb221 =  new[g_i].oeb03 
               AND sfb04  = '8'   
               AND sfb87 != 'X'
            #MOD-D60188-End-Add    
         #FUN-A80102(S)
         ELSE
            SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
             WHERE sfb22  =  g_oea.oea01
               AND sfb221 =  new[g_i].oeb03 
               AND sfb919 =  new[g_i].sfb919 
              #AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 = sfb09))   #MOD-530799  #MOD-CB0115 mark
              #AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 <= sfb09))  #MOD-CB0115  #MOD-D60188 mark
               AND sfb04 <> '8'                                                     #MOD-D60188 add
               AND sfb87!='X'

            #MOD-D60188-Start-Add
            SELECT SUM(sfb09) INTO l_sfb09 FROM sfb_file
             WHERE sfb22  =  g_oea.oea01
               AND sfb221 =  new[g_i].oeb03 
               AND sfb919 =  new[g_i].sfb919
               AND sfb04  = '8'   
               AND sfb87 != 'X'
            #MOD-D60188-End-Add   
         END IF
         #FUN-A80102(E)
         IF l_sfb08 IS NULL THEN
            LET l_sfb08 = 0
         END IF
        
         #MOD-D60188-Start-Add
         IF l_sfb09 IS NULL THEN
            LET l_sfb09 = 0
         END IF
         #MOD-D60188-End-Add 
         
        #IF l_sfb08 >= new[g_i].new_qty THEN                           #MOD-D60188 mark
         IF l_sfb08 + l_sfb09 >= new[g_i].new_qty THEN                 #MOD-D60188 add
            CONTINUE FOREACH
         ELSE
           #LET new[g_i].new_qty = new[g_i].new_qty - l_sfb08          #MOD-D60188 mark
            LET new[g_i].new_qty = new[g_i].new_qty - l_sfb08-l_sfb09  #MOD-D60188 add 

            #M001 180109 By TSD.Jin--start--
            CALL cs_q102_qty(new[g_i].new_part)
               RETURNING l_ima.oeb_q, l_ima.sfa_q1, l_ima.sfa_q2, l_ima.sie_q, l_ima.pml_q,
                         l_ima.pmn_q, l_ima.rvb_q2, l_ima.rvb_q, l_ima.sfb_q1, l_ima.sfb_q2,
                         l_ima.qcf_q, l_ima.atp_qty,l_ima.misc_q1,l_ima.sfs_q2
            LET l_ima.atp_qty = l_ima.atp_qty + new[g_i].new_qty     #受訂量包含自己這張訂單，故需要加回來

            IF l_ima.atp_qty > 0 THEN
               IF new[g_i].new_qty >= l_ima.atp_qty THEN
                  LET new[g_i].new_qty = new[g_i].new_qty - l_ima.atp_qty
               ELSE
                  LET new[g_i].new_qty = 0
               END IF
            END IF
            #M001 180109 By TSD.Jin--end----

            LET l_allowqty = new[g_i].new_qty   #MOD-CC0162 move
            #CHI-B80044 -- begin --
            IF NOT cl_null(g_ima.ima56) AND g_ima.ima56 > 0 THEN
               LET l_calc = 0
              #LET l_allowqty = new[g_i].new_qty   #MOD-CC0162 mark
               LET l_qty = new[g_i].new_qty * 1000          #CHI-DA0027 add
               LET l_ima56 = g_ima.ima56 * 1000             #CHI-DA0027 add
              #IF new[g_i].new_qty MOD g_ima.ima56 > 0 THEN #CHI-DA0027 mark
               IF l_qty MOD l_ima56 > 0 THEN                #CHI-DA0027 add
                  LET l_calc = new[g_i].new_qty/g_ima.ima56 +1
                  LET l_allowqty = l_calc * g_ima.ima56
               END IF
            END IF
            LET new[g_i].new_qty = l_allowqty
            LET new[g_i].new_qty = s_digqty(new[g_i].new_qty,l_ima55)  #MOD-EC0058 add
            #CHI-B80044 -- end --
         END IF
##-計算開工日
         LET g_ima.ima62 = 0
          SELECT ima62,ima59,ima61 INTO g_ima.ima62,l_ima59,l_ima61 FROM ima_file #MOD-530799
          WHERE ima01 = new[g_i].new_part
         IF new[g_i].e_date IS NULL THEN
            LET new[g_i].e_date = 0
         END IF
      ##---- 20180417 add by momo (S)
          SELECT bma05||ima02 INTO new[g_i].ima02 
            FROM bma_file,ima_file
           WHERE ima01=bma01 AND bmaacti = 'Y'
             AND bma01=new[g_i].new_part
             AND bma05 IS NOT NULL
      ##---- 20180417 add by momo (E)
      #mark by plum 010130
      #LET new[g_i].b_date = new[g_i].e_date - g_ima.ima62 units day
         #FUN-710073---mod---str---
         #LET l_time= (new[g_i].new_qty * l_ima60)+ l_ima59 + l_ima61  #No.FUN-840194 #CHI-810015 mark還原#MOD-530799
          LET l_time= (new[g_i].new_qty * l_ima60/l_ima601)+ l_ima59 + l_ima61 #No.FUN-840194  #CHI-810015 mark還原#MOD-530799
         #LET l_time= (new[g_i].new_qty * (l_ima60/l_ima56))+          #CHI-810015 mark 
         #            (l_ima59/l_ima56) + (l_ima61/l_ima56)            #CHI-810015 mark 
         #FUN-710073---mod---end---
 
         IF cl_null(l_time) THEN
            LET l_time=0
         END IF
         LET s_date=l_time+0.5
         IF cl_null(s_date) THEN
            LET s_date=0 
         END IF

         CALL s_aday(new[g_i].e_date,-1,s_date) RETURNING new[g_i].b_date  #MOD-C50055 add
 
      #MOD-C50055 mark begin-----------------------------
      #   LET new[g_i].b_date=new[g_i].e_date - s_date
 
      ##--MOD-530799 計算開工日時須扣掉非工作日
      #   SELECT COUNT(*) INTO l_cn FROM sme_file
      #      WHERE sme01 BETWEEN new[g_i].b_date AND new[g_i].e_date AND sme02 ='N'
      #   IF cl_null(l_cn) THEN
      #      LET l_cn=0
      #   END IF
      #   LET new[g_i].b_date = new[g_i].b_date - l_cn
      #MOD-C50055 mark end-------------------------------
 
         IF new[g_i].b_date < g_sfb.sfb81 THEN
            LET new[g_i].b_date = g_sfb.sfb81
         END IF
         IF new[g_i].b_date > new[g_i].e_date THEN 
            LET new[g_i].e_date = new[g_i].b_date
         END IF
         
         LET new[g_i].gem02c=l_gem02c  #FUN-670103

         ##---- 20231004 add by mom (S)
         IF new[g_i].new_qty <> new[g_i].oeb12 THEN
            LET new_color[g_i].new_part = "GREEN REVERSE"
         ELSE
            LET new_color[g_i].new_part = ""
         END IF
         ##---- 20231004 add by mom (E)
         LET g_i=g_i+1
      END FOREACH
      CALL s_showmsg()    #FUN-920088
      CALL new.deleteElement(g_i)  #MOD-490189
      LET g_i=g_i-1
END FUNCTION

#TQC-AC0238   --start  
FUNCTION i304_new_no(i)             
   DEFINE i         LIKE type_file.num5
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_smy73   LIKE smy_file.smy73    
   DEFINe l_cnt     LIKE type_file.num5    #DEV-D30026 add
 
   LET g_errno = ' '
   IF cl_null(new[i].new_no) THEN RETURN END IF
   LET l_slip = s_get_doc_no(new[i].new_no)
 
  #DEV-D30026 add str---------------------
   CALL p304_barcode_chk(new[i].new_part)
   IF l_barcode_yn = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt
      FROM smy_file,smyb_file
      WHERE smy_file.smyslip = smyb_file.smybslip AND
            smy_file.smysys = 'asf' AND
            smy_file.smykind = '1' AND
           #smyb_file.smyb01 = '2' AND #DEV-D30037--mark
            smy_file.smyslip = l_slip
      IF l_cnt = 0 THEN
         CALL cl_err('','aba-134',1)
      END IF
   ELSE
  #DEV-D30026 add end---------------------
      SELECT smy73 INTO l_smy73 FROM smy_file                 
       WHERE smyslip = l_slip
      IF l_smy73 = 'Y' THEN
         LET g_errno = 'asf-875'
      END IF 
   END IF        #DEV-D30026 add
END FUNCTION
#TQC-AC0238   --end 
 
FUNCTION asfp304()
   DEFINE l_za05        LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(40)
   DEFINE l_sfb         RECORD LIKE sfb_file.*
   DEFINE l_sfc         RECORD LIKE sfc_file.*
   DEFINE l_sfd         RECORD LIKE sfd_file.*
   DEFINE l_minopseq    LIKE ecb_file.ecb03 
   DEFINE new_part      LIKE ima_file.ima01    #No.MOD-490217
   DEFINE i,j           LIKE type_file.num10   #No.FUN-680121 INTEGER
   DEFINE ask           LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE s_date        LIKE type_file.num5    #No.FUN-680121 SMALLINT  
   DEFINE l_time        LIKE ima_file.ima58    #No.FUN-680121 DEC(15,3)
   DEFINE l_item        LIKE ima_file.ima01
   DEFINE l_smy57       LIKE smy_file.smy57
   DEFINE l_smy73       LIKE smy_file.smy73    #TQC-AC0238
   DEFINE l_ima910      LIKE ima_file.ima910   #FUN-550112
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067  #No.FUN-680121 SMALLINT
   DEFINE   l_max_no    LIKE sfb_file.sfb01         #No:MOD-950298 add
   DEFINE   l_min_no    LIKE sfb_file.sfb01         #No:MOD-950298 add
   DEFINE l_sfb08       LIKE sfb_file.sfb08
   DEFINE l_sfb09       LIKE sfb_file.sfb09     #MOD-D60188
   DEFINE l_qty         LIKE oeb_file.oeb12
   DEFINE l_ima55_fac   LIKE ima_file.ima55_fac
   DEFINE l_check       LIKE type_file.num5     #No.FUN-680121 SMALLINT
   DEFINE l_cn          LIKE type_file.num5     #No.FUN-680121 SMALLINT
   DEFINE l_ima59       LIKE ima_file.ima59
   DEFINE l_ima61       LIKE ima_file.ima61
   DEFINE l_oeb15       LIKE oeb_file.oeb15     #FUN-640148 add
   DEFINE l_btflg       LIKE type_file.chr1     #FUN-650054
   DEFINE l_proc        LIKE type_file.chr1     #No.TQC-7B0031
   DEFINE l_sfbi        RECORD LIKE sfbi_file.* #No.FUN-7B0018
   DEFINE l_sfbc        RECORD LIKE sfbc_file.* #No.FUN-D80022
   DEFINE l_formid      LIKE oay_file.oayslip   #TQC-9B0181
   DEFINE l_ima571      LIKE ima_file.ima571    #FUN-A50066
   DEFINE l_cnt         LIKE type_file.num5     #FUN-A50066
   DEFINE l_sfc01       LIKE sfc_file.sfc01     #FUN-A80054
   DEFINE l_t1          LIKE oay_file.oayslip   #FUN-A80054
   DEFINE l_sfci        RECORD LIKE sfci_file.* #FUN-A80054
   DEFINE l_flag        LIKE type_file.chr1     #FUN-A80054
   DEFINE l_new_no1     STRING                  #MOD-AC0288
   DEFINE l_new_no      LIKE smy_file.smyslip   #MOD-AC0288
   DEFINE l_sfd01       LIKE sfd_file.sfd01     #FUN-B30035
   DEFINE l_ima56       LIKE ima_file.ima56     #TQC-B60323
   DEFINE l_ima561      LIKE ima_file.ima561    #TQC-B60323
   DEFINE l_qty1        LIKE sfb_file.sfb08     #TQC-B60323
   DEFINE l_qty2        LIKE ima_file.ima56     #TQC-B60323
   #CHI-B80044 -- begin --
   DEFINE l_availqty        LIKE sfb_file.sfb08   #訂單可轉工單數量
   DEFINE l_allowqty        LIKE sfb_file.sfb08   #允許生產數量
   DEFINE l_calc            LIKE type_file.num5   #計算生產批量倍數用
   #CHI-B80044 -- end --
   DEFINE l_i           LIKE type_file.num5   #FUN-C50052
   DEFINE l_count       LIKE type_file.num5   #FUN-D80022
   DEFINE l_sfb01       LIKE sfb_file.sfb01   #FUN-D80022
  #MOD-C90048 add---S   
   DEFINE l_oeb41       LIKE oeb_file.oeb41,
          l_oeb42       LIKE oeb_file.oeb42,
          l_oeb43       LIKE oeb_file.oeb43,
          l_oeb1001     LIKE oeb_file.oeb1001
  #MOD-C90048 add---E
   DEFINE l_oebislk01   LIKE oebi_file.oebislk01  #FUN-E20042--add
   DEFINE l_smy72       LIKE smy_file.smy72       #MOD-FB0042 add
   #M001 171122 By TSD.Nic -----(S)
   DEFINE l_pmk40       LIKE pmk_file.pmk40
   #M001 171122 By TSD.Nic -----(E)
   #M012 180129 By TSD.Nic -----(S)
   DEFINE l_ima43       LIKE ima_file.ima43
   DEFINE l_ori_pmk     LIKE pmk_file.pmk01
   DEFINE l_pass_pmk    STRING
   DEFINE l_sql         STRING
   DEFINE l_wos         STRING
   DEFINE l_tot_cnt     LIKE type_file.num5
   #M012 180129 By TSD.Nic -----(E)

  
   WHILE TRUE
       LET g_flag='Y' #MOD-530283
   LET l_ima59=0
   LET l_ima60=0
   LET l_ima61=0
   INITIALIZE l_sfb.* TO NULL   #20221213 add
   #TQC-730022 如果是背景作業不再INPUT ARRAY

  #FUN-B30035--begin--add-----
   IF g_sma.sma541 = 'Y' THEN
      DROP TABLE sfd_tmp
      CREATE TEMP TABLE sfd_tmp(
        sfd01   LIKE sfc_file.sfc01)
      CREATE UNIQUE INDEX sfd_tmp_01 on sfd_tmp(sfd01);
   END IF
  #FUN-B30035--end--add-------


    IF g_bgjob = 'N' THEN #TQC-730022
      INPUT ARRAY new WITHOUT DEFAULTS FROM s_new.*
         ATTRIBUTE(COUNT=g_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE, APPEND ROW=FALSE)
 
         BEFORE INPUT                                            #TQC-C50223 add
            CALL cl_set_comp_required("b_date,e_date",TRUE)      #TQC-C50223 add

         CALL DIALOG.setCellAttributes(new_color)                #20231004
 
         BEFORE ROW       
            LET i=ARR_CURR()
            LET g_oea.oea01 = new[i].oeb01 #FUN-920088
            #FUN-A50066--begin--add------------
            IF cl_null(new[i].sfb93) THEN LET new[i].sfb93='N' END IF
            IF new[i].sfb93 = 'N' THEN LET new[i].sfb06='' END IF  #TQC-C70104 add
            #TQC-C70104--mark--str--
            #IF new[i].sfb93 = 'Y' THEN
            #   CALL cl_set_comp_entry("sfb06",TRUE)
            #   CALL cl_set_comp_required("sfb06",TRUE)  
            #ELSE
            #   CALL cl_set_comp_required("sfb06",FALSE)
            #   CALL cl_set_comp_entry("sfb06",FALSE)
            #   LET new[i].sfb06='' 
            #END IF
            #TQC-C70104--mark--end--
            #FUN-A50066--end--add--------------          
            #TQC-C70104--add--str--
            CALL p304_set_entry_b()
            CALL p304_set_no_entry_b(i)
            CALL p304_set_no_required_b()
            CALL p304_set_required_b(i)
            #TQC-C70104--add--end--
            
               
            
         BEFORE INSERT
            LET new[i].sfb02='1'
            DISPLAY BY NAME new[i].sfb02
            #FUN-A50066--begin--add---------
            IF cl_null(new[i].sfb93) THEN
               LET new[i].sfb93 = 'N'
               DISPLAY BY NAME new[i].sfb93
            END IF
            #FUN-A50066--end--add----------
            
   
         #TQC-C70104--add--str--
         ON CHANGE x
            CALL p304_set_entry_b()
            CALL p304_set_no_entry_b(i)
            CALL p304_set_no_required_b()
            CALL p304_set_required_b(i)
         #TQC-C70104--add--end-- 
            

         AFTER FIELD x
            IF NOT cl_null(new_part) THEN
             IF new[i].x IS NULL OR (new[i].x != 'Y' AND new[i].x != 'N') THEN
               NEXT FIELD x
             END IF
            END IF
            IF new[i].x = 'Y' AND NOT cl_null(new[i].new_no[g_no_sp,g_no_sp]) THEN      #No.FUN-550067 
                     CALL cl_err('','asf-371','1')                                                                                 
            END IF
            
          AFTER FIELD ima910                                                                                                        
             IF NOT cl_null(new[i].ima910) THEN                                                                                     
              SELECT COUNT(*) INTO g_cnt FROM bma_file                                                                              
               WHERE bma06 = new[i].ima910                                                                                          
                 AND bma01 = new[i].new_part                                                                                        
                 AND bma05 IS NOT NULL AND bma05 <= g_sfb.sfb81                                                                     
              IF g_cnt = 0 THEN                                                                                                     
                 CALL cl_err(new[i].ima910,"abm-618",0)                                                                             
                 NEXT FIELD ima910                                                                                                  
              END IF                                                                                                                
           END IF                                                                                                                   
 
         #FUN-A50066--begin--add------------
         #TQC-C70104--modify--str--
         #BEFORE FIELD sfb93
         #   CALL cl_set_comp_required("sfb06",FALSE)
         #   CALL cl_set_comp_entry("sfb06",TRUE)
         ON CHANGE sfb93
            CALL p304_set_entry_b()
            CALL p304_set_no_entry_b(i)
            CALL p304_set_no_required_b()
            CALL p304_set_required_b(i)              
         #TQC-C70104--modify--end--
            
         AFTER FIELD sfb93
             LET g_ecu01 = ''    #MOD-E30086 add
             IF NOT cl_null(new[i].sfb93) THEN
                #TQC-C70104--modify--str--
                #IF new[i].sfb93 = 'Y' THEN
                #   CALL cl_set_comp_required("sfb06",TRUE)
                #ELSE
                #   CALL cl_set_comp_entry("sfb06",FALSE)
                #   LET new[i].sfb06=''
                #   DISPLAY BY NAME new[i].sfb06
                #END IF
                IF new[i].sfb93 <> 'Y' THEN
                   LET new[i].sfb06 = ''
                   DISPLAY BY NAME new[i].sfb06
                END IF   
                #TQC-C70104--modify--end-- 
             END IF
             
         AFTER FIELD sfb06
             IF NOT cl_null(new[i].sfb06) THEN
                SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01=new[i].new_part
                IF cl_null(l_ima571) THEN LET l_ima571=' ' END IF
                LET l_cnt = 0
                SELECT count(*) INTO l_cnt FROM ecu_file
                 WHERE (ecu01=l_ima571 OR ecu01=new[i].new_part)
                   AND ecu02 = new[i].sfb06
                   AND ecuacti = 'Y'  #CHI-C90006
                IF l_cnt = 0 THEN
                   CALL cl_err('','mfg4030',1)
                   NEXT FIELD sfb06
                END IF
                #FUN-B20085--begin--add-----
                CALL p304_chk_edb(new[i].edc01,new[i].new_part,new[i].sfb06)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('','aec-065',1)
                   NEXT FIELD sfb06
                END IF
                 CALL p304_edc02(new[i].edc01,new[i].edc02,new[i].new_part,new[i].sfb06)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(new[i].edc02,'aec-065',0)
                    NEXT FIELD sfb06
                 END IF
                #FUN-B20085--end--add-----
             END IF
        #FUN-A50066--end--add-----------------
                
        #FUN-A80054--begin--add---------------
        AFTER FIELD edc01
           IF NOT cl_null(new[i].edc01) THEN
             #FUN-B20085--begin--modify---    
             #LET l_cnt=0
             #SELECT COUNT(*) INTO l_cnt FROM eda_file,edb_file
             # WHERE eda01=new[i].edc01
             #   AND edb03=new[i].new_part
             #   AND edb04=new[i].sfb06
             #   AND eda01=edb01 AND edaconf='Y'
             #IF l_cnt = 0 THEN
             #   CALL cl_err('','aec-057',1)
             #   NEXT FIELD edc01
             #END IF
              CALL p304_chk_edb(new[i].edc01,new[i].new_part,new[i].sfb06)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD edc01
              END IF
             #FUN-B20085--end--modify------
              #TQC-B20161--begin--add----
              IF cl_null(new[i].edc02) THEN
                SELECT MIN(edb02) INTO new[i].edc02 FROM eda_file,edb_file
                 WHERE edb03=new[i].new_part
                   AND edb01=new[i].edc01
                   AND edb04=new[i].sfb06
                   AND edb01=eda01 AND edaconf='Y'
              END IF
              #TQC-B20161--end--add-----
              IF NOT cl_null(new[i].edc02) THEN
                 CALL p304_edc02(new[i].edc01,new[i].edc02,new[i].new_part,new[i].sfb06)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(new[i].edc02,'aec-057',0)
                    NEXT FIELD edc02
                 END IF
              END IF
           END IF 
                   
         AFTER FIELD edc02
            IF NOT cl_null(new[i].edc02) THEN
               CALL p304_edc02(new[i].edc01,new[i].edc02,new[i].new_part,new[i].sfb06)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(new[i].edc02,'aec-058',0)
                  NEXT FIELD edc02
               END IF
            END IF
         #FUN-A80054--end--add-----------

         BEFORE FIELD new_qty
            IF new[i].x = 'N' THEN
            END IF
            ##--- 20220321 add by momo (S)
            IF new[i].new_qty = 0 THEN
               LET new[i].x = 'N'
            END IF
            ##--- 20220321 add by momo (E)
   
         AFTER FIELD new_qty 
            IF new[i].new_qty IS NULL OR new[i].new_qty<0 THEN 
               NEXT FIELD new_qty 
            END IF
             #--MOD-530799 add    判斷工單數量是否大於訂單數量
            IF NOT cl_null(new[i].new_qty) THEN
               LET new[i].new_qty = s_digqty(new[i].new_qty,l_ima55)   #MOD-EC0058 add
               SELECT oeb12,oeb05,ima55,((ima562+100)/100) INTO l_qty,    #No.MOD-790028 modify
               l_oeb05,l_ima55,l_ima562
               FROM oeb_file,ima_file
               WHERE oeb01=g_oea.oea01 AND oeb03=new[i].oeb03
               AND oeb04 = ima01  #AND oeb19 != 'Y'   #FUN-570104 mark
              
               CALL s_umfchk(new[i].new_part,l_oeb05,l_ima55)
                    RETURNING l_check,l_ima55_fac
               IF cl_null(l_ima55_fac) THEN 
                  LET l_ima55_fac = 1
               END IF
               LET l_qty = l_qty * l_ima55_fac * l_ima562
               LET l_sfb08 = 0
               SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
                WHERE sfb22  =  g_oea.oea01
                  AND sfb221 =  new[i].oeb03
                 #AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 = sfb09))   #MOD-CB0115 mark
                 #AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 <= sfb09))  #MOD-CB0115     #MOD-D60188 mark
                  AND sfb04 <> '8'                                                        #MOD-D60188 add
                  AND sfb87!='X'

               #MOD-D60188-Start-Add
               SELECT SUM(sfb09) INTO l_sfb09 FROM sfb_file
                WHERE sfb22  =  g_oea.oea01
                  AND sfb221 =  new[i].oeb03
                  AND sfb04  = '8'                                                        #MOD-D60188 add
                  AND sfb87 != 'X'
               #MOD-D60188-End-Add   
               
               IF l_sfb08 IS NULL THEN
                  LET l_sfb08 = 0
               END IF
               #MOD-D60188-Start-Add
               IF l_sfb09 IS NULL THEN
                  LET l_sfb09 = 0
               END IF
               #MOD-D60188-End-Add 
               
              #LET l_qty = l_qty - l_sfb08           #MOD-D60188 mark
               LET l_qty = l_qty - l_sfb08-l_sfb09   #MOD-D60188 add
               
              #CHI-B80044 -- mark begin --
              #IF new[i].new_qty > l_qty THEN
              #   CALL cl_err('','asf-939',1)
              #   LET new[i].new_qty = l_qty
              #   NEXT FIELD new_qty
              #END IF
              #CHI-B80044 -- mark end --
               IF new[i].x = 'Y' THEN          #MOD-BA0006 add
                  IF new[i].sfb02 NOT MATCHES '[58]' THEN   #MOD-F10084 add
                    #TQC-B60323  --begin
                     SELECT ima561,ima56 INTO l_ima561,l_ima56 FROM ima_file WHERE ima01=new[i].new_part
                     IF l_ima561 > 0 THEN
                        IF new[i].new_qty < l_ima561 THEN
                           CALL cl_err(l_ima561,'asf-307',0)
                           NEXT FIELD new_qty
                        END IF
                     END IF
                     LET l_allowqty = new[i].new_qty       #MOD-D70080 add
                     IF NOT cl_null(l_ima56) AND l_ima56>0  THEN
                        LET l_qty1 = new[i].new_qty * 1000
                        LET l_qty2 = l_ima56 * 1000
                        IF (l_qty1 MOD l_qty2) > 0 THEN
                           CALL cl_err(l_ima56,'asf-308',0)
                           NEXT FIELD new_qty
                        END IF
                       #CHI-B80044 -- begin --
                        LET l_calc = 0
                       #LET l_allowqty = new[i].new_qty   #MOD-D70080 mark
                        IF l_qty MOD l_ima56 > 0 THEN
                           LET l_calc = l_qty/l_ima56 + 1
                           LET l_allowqty = l_calc * l_ima56
                        END IF
                        IF new[i].new_qty > l_allowqty THEN
                           CALL cl_err('','asf-358',1)
                           LET new[i].new_qty = l_allowqty
                           NEXT FIELD new_qty
                        END IF
                       #CHI-B80044 -- end --
                     END IF
                    #TQC-B60323  --end
                  END IF   #MOD-F10084 add
               END IF            #MOD-BA0006 add        
            END IF
            #CHI-B80044 -- begin --
            IF new[i].new_qty > l_qty THEN
               CALL cl_err('','asf-939',0)
               IF s_industry('slk') AND g_sma.sma150='Y' THEN  #MOD-E50093
               NEXT FIELD new_qty                              #MOD-E50093
               END IF                                          #MOD-E50093
            END IF
            #CHI-B80044 -- end --
 
         BEFORE FIELD new_no  
            #TQC-C70104--mark--str--
            #IF new[i].x='N' THEN
            #   NEXT FIELD NEXT
            #END IF
            #TQC-C70104--mark--end--
            #增加顯示asf-382:"工單完工日與訂單預定交貨日不同!!"
            #SELECT oeb15 INTO l_oeb15 FROM oeb_file               #20180410 mark
            SELECT oeb16 INTO l_oeb15 FROM oeb_file                #20180410 oeb15 change oeb16
             WHERE oeb01 = g_oea.oea01 AND oeb03 = new[i].oeb03
            IF new[i].e_date != l_oeb15 THEN
               CALL cl_err('','asf-382',0)
            END IF
   
         AFTER FIELD new_no  
            LET i=ARR_CURR()
            #TQC-C70104--mark--str--
            #IF new[i].x='Y' THEN
            #   IF cl_null(new[i].new_no) THEN
            #      NEXT FIELD new_no
            #   END IF 
            #ELSE
            #   IF NOT cl_null(new[i].new_no) THEN
            #      NEXT FIELD new_no
            #   END IF 
            #END IF
            #TQC-C70104--mark--end--
            IF NOT cl_null(new[i].new_no) THEN  #TQC-C70104 add
              #TQC-AC0238   --start        
               CALL i304_new_no(i)          
               IF NOT cl_null(g_errno) THEN
                 CALL cl_err(new[i].new_no,g_errno,0)
                 LET  new[i].new_no = NULL
                 DISPLAY BY NAME new[i].new_no
                 NEXT FIELD new_no
               END IF                                                                  
              #TQC-AC0238   --end         
               CALL s_check_no("asf",new[i].new_no,"","1","","","")  
               RETURNING li_result,new[i].new_no                                                  
               DISPLAY BY NAME new[i].new_no                                                                                             
               IF (NOT li_result) THEN                                                                                                 
                  NEXT FIELD new_no
               END IF
               IF g_smy.smyauno='Y' AND NOT cl_null(new[i].new_no[g_no_sp,g_no_ep]) THEN    #No.FUN-550067    
                  NEXT FIELD new_no
               END IF
               DISPLAY new[i].new_no TO s_new[i].new_no
              #MOD-AC0288---add---start---
              #MOD-FB0042 mark start ----------------------------
              #LET l_new_no1=new[i].new_no
              #LET l_new_no=l_new_no1.subString(1,g_doc_len)
              #SELECT smy60 INTO new[i].costcenter FROM smy_file
              # WHERE smyslip = l_new_no 
              #MOD-FB0042 mark end   ----------------------------
               #MOD-FB0042 add start ----------------------------
               SELECT smy60,smy72 INTO new[i].costcenter,l_smy72 FROM smy_file
                WHERE smyslip = new[i].new_no
               IF cl_null(l_smy72) THEN
                  LET l_smy72 = 1
               ELSE
                  IF l_smy72 NOT MATCHES '[17]' THEN
                     LET l_smy72 = 1
                  END IF
               END IF 
               LET new[i].sfb02 = l_smy72
               DISPLAY BY NAME new[i].sfb02
               #MOD-FB0042 add end   ----------------------------
               DISPLAY new[i].costcenter TO s_new[i].costcenter
              #MOD-AC0288---add---end---
            END IF #TQC-C70104 add
           
         AFTER FIELD ven_no
            LET i=ARR_CURR()
            IF NOT cl_null(new[i].ven_no) THEN    #No.TQC-920104 add
                IF new[i].sfb02=1 THEN #FUN-650054
                  SELECT gem02 FROM gem_file
                   WHERE gem01=new[i].ven_no
                     AND gemacti = 'Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","gem_file",new[i].ven_no,"",STATUS,"","sel gem:",1)    #No.FUN-660128
                     NEXT FIELD ven_no
                  END IF
               END IF
              #IF new[i].sfb02=7 THEN #FUN-650054        #MOD-E30038 mark
               IF new[i].sfb02=7 OR new[i].sfb02=8 THEN  #MOD-E30038 add
                  SELECT pmc03 FROM pmc_file
                   WHERE pmc01=new[i].ven_no
                     AND pmcacti = 'Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","pmc_file",new[i].ven_no,"",STATUS,"","sel pmc:",1)    #No.FUN-660128
                     NEXT FIELD ven_no
                  END IF
               END IF
            END IF
   
         AFTER FIELD b_date
            #TQC-C50223--modify--str--
            #IF new[i].b_date IS NULL OR (new[i].b_date < g_sfb.sfb81) THEN  
            #         CALL cl_err('','asf-372','1')                                                                                
#              ERROR '開工日為空白or小於工單日,請檢查!'                                                                             
            IF NOT cl_null(new[i].b_date) THEN          
               IF new[i].b_date < g_sfb.sfb81 THEN      
                  CALL cl_err('','asf-867','1')                                                                               
            #TQC-C50223--modify--end--
                  NEXT FIELD b_date
               END IF
               
               #TQC-C50223--add--str--
               IF NOT cl_null(new[i].e_date) AND new[i].e_date < new[i].b_date THEN
                  CALL cl_err('','asf-310','1')
                  NEXT FIELD b_date 
               END IF 
               #TQC-C50223--add--end-- 
               #MOD-C50055 add begin---------------------
               LET li_result = 0
               CALL s_daywk(new[i].b_date) RETURNING li_result
               IF li_result = 0 THEN      #0:非工作日
                  CALL cl_err(new[i].b_date,'mfg3152',1)
               END IF
               IF li_result = 2 THEN      #2:未設定
                  CALL cl_err(new[i].b_date,'mfg3153',1)
               END IF
               #MOD-C50055 add end-----------------------
            END IF
   
         AFTER FIELD e_date
            #TQC-C50223--modify--str--
            #IF new[i].e_date IS NULL OR (new[i].e_date < g_sfb.sfb81) THEN
            #         CALL cl_err('','asf-373','1')                                                                                 
#              ERROR '完工日為空白or小於工單日,請檢查!'                                                                             
            IF NOT cl_null(new[i].e_date) THEN
               IF new[i].e_date < g_sfb.sfb81 THEN
                  CALL cl_err('','asf-868','1')
            #TQC-C50223--modify--end--
                  NEXT FIELD e_date
               END IF
               IF new[i].e_date < new[i].b_date THEN
                        CALL cl_err('','asf-310','1')                                                                                 
#                 ERROR '完工日不能小於開工日,請檢查!'                                                                                 
                  NEXT FIELD e_date                                                                                                    
                  #NEXT FIELD e_date    #TQC-C50223 mark
               END IF 
               #MOD-C50055 add begin---------------------
               LET li_result = 0
               CALL s_daywk(new[i].e_date) RETURNING li_result
               IF li_result = 0 THEN      #0:非工作日
                  CALL cl_err(new[i].e_date,'mfg3152',1)
               END IF
               IF li_result = 2 THEN      #2:未設定
                  CALL cl_err(new[i].e_date,'mfg3153',1)
               END IF
               #MOD-C50055 add end-----------------------
               IF cl_confirm('asf-379') THEN
                  #前置時間(l_time)=生產數量(sfb08)*變動前置時間(ima60)
                  #if l_time <=7: 以7天計, >7:以照原值計,
                  #預計開工日(sfb13): 預計完工日-l_time,但不可小於開單日期
                  SELECT ima60,ima601,ima59,ima61 INTO l_ima60,l_ima601,l_ima59,l_ima61 FROM ima_file #No.FUN-840194 add ima601 #MOD-530799
                   WHERE ima01 = new[i].new_part
                  LET l_time=(new[i].new_qty * l_ima60/l_ima601)+l_ima59+l_ima61  #No.FUN-840194 #No.MOD-530799
                  display "l_time:" ||l_time
                  display "l_ima60:" ||l_ima60
                  display "l_ima601:" ||l_ima601  #No.FUN-840194 
                  display "l_ima59:" ||l_ima59
                  display "l_ima61:" ||l_ima61
                  display "new[i].new_qty:" ||new[i].new_qty
                  IF cl_null(l_time) THEN
                     LET l_time = 0
                  END IF
                  LET s_date=l_time+0.5
                  IF cl_null(s_date) THEN
                     LET s_date = 0
                  END IF

                 CALL s_aday(new[g_i].e_date,-1,s_date) RETURNING new[g_i].b_date  #MOD-C50055 add
  
                 #MOD-C50055 mark begin-----------------------------
                 # LET new[i].b_date=new[i].e_date - s_date
                 # display "new[i].b_date:" ||new[i].b_date
                 ##-- 計算開工日時須扣掉非工作日
                 #  SELECT COUNT(*) INTO l_cn FROM sme_file 
                 #     WHERE sme01 BETWEEN new[i].b_date AND new[i].e_date 
                 #       AND sme02 = 'N'
                 #  IF cl_null(l_cn) THEN
                 #     LET l_cn=0 
                 #  END IF
                 #  LET new[i].b_date = new[i].b_date - l_cn
                 #MOD-C50055 mark end-------------------------------
               END IF
 
               IF new[i].b_date IS NULL OR (new[i].b_date < g_sfb.sfb81) OR
                 (new[i].b_date > new[i].e_date) THEN
                  LET new[i].b_date=g_sfb.sfb81
               END IF
    
               DISPLAY new[i].b_date TO s_new[i].b_date 
            END IF
   
         AFTER FIELD a
            IF new[i].a IS NULL OR (new[i].a != 'Y' AND new[i].a != 'N') THEN
               NEXT FIELD a
            END IF
   
         AFTER FIELD costcenter 
            IF NOT s_costcenter_chk(new[i].costcenter) THEN
               NEXT FIELD costcenter
            ELSE
               LET new[i].gem02c=s_costcenter_desc(new[i].costcenter)
               DISPLAY BY NAME new[i].gem02c
            END IF
 
         AFTER ROW 
           #TQC-C70104--add--str--
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              LET g_success = 'N'
              RETURN
           END IF
           #TQC-C70104--add--end--
           #FUN-A50066--begin--add------
           LET i = ARR_CURR() 
           IF new[i].x = 'Y' THEN  #TQC-C70104 add 
              IF new[i].sfb93 = 'Y' THEN
                 IF cl_null(new[i].sfb06) THEN
                    NEXT FIELD sfb06
                 END IF
              END IF
           END IF
           #FUN-A50066--end--add--------
           #FUN-A80054--begin--add-----
           IF NOT cl_null(new[i].edc01) AND cl_null(new[i].edc02) THEN
              NEXT FIELD edc02
           END IF
           IF NOT cl_null(new[i].edc02) AND cl_null(new[i].edc01) THEN
              NEXT FIELD edc01
           END IF
           #FUN-A80054--end--add-------
   
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(new_part) 
                  LET i=ARR_CURR()
#FUN-AA0059---------mod------------str-----------------                  
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = new[i].new_part
#                  CALL cl_create_qry() RETURNING new[i].new_part
                   CALL q_sel_ima(FALSE, "q_ima","",new[i].new_part,"","","","","",'' ) 
                   RETURNING  new[i].new_part
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY new[i].new_part TO s_new[i].new_part 
                  NEXT FIELD new_part
              WHEN INFIELD(ima910)                                                                                                  
                 LET i=ARR_CURR()                                                                                                   
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form = "q_bma7"                                                                                     
                 LET g_qryparam.default1 = new[i].ima910                                                                            
                 LET g_qryparam.arg1 = new[i].new_part                                                                              
                 CALL cl_create_qry() RETURNING new[i].ima910                                                                       
                 DISPLAY new[i].ima910 TO s_new[i].ima910                                                                           
                 NEXT FIELD ima910                                                                                                  
               WHEN INFIELD(new_qty) 
                  LET i=ARR_CURR()
                  LET g_cmd = "aimq102"," '1' "," '",new[i].new_part,"' "
                  CALL cl_cmdrun(g_cmd CLIPPED)
               WHEN INFIELD(new_no)
                 #DEV-D30026 add str-----------------------
                  CALL p304_barcode_chk(new[i].new_part)
                  IF l_barcode_yn = 'Y' THEN
                     LET i=ARR_CURR()
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smyslip2"
                     LET g_qryparam.default1 = new[i].new_no
                     LET g_qryparam.arg1 = 'asf'
                     LET g_qryparam.arg2 = '1'
                     LET g_qryparam.arg3 = '2'
                     CALL cl_create_qry() RETURNING new[i].new_no
                     DISPLAY new[i].new_no TO s_new[i].new_no
                     NEXT FIELD new_no
                  ELSE
                    #DEV-D30026 add end---------------
                     LET i=ARR_CURR()
                     LET g_sql_smy = " (smy73 <> 'Y' OR smy73 is null)"  #TQC-AC0238
                     CALL smy_qry_set_par_where(g_sql_smy)               #TQC-AC0238
                     LET g_t1 = s_get_doc_no(new[i].new_no)              #No.TQC-AC0238
                     CALL q_smy(FALSE,FALSE,new[i].new_no,'ASF','1') RETURNING new[i].new_no  #TQC-670008
                 #   LET new[i].new_no=g_t1                              #No.TQC-AC0238
                     DISPLAY new[i].new_no TO s_new[i].new_no     
                     NEXT FIELD new_no
                  END IF                                              #DEV-D30026 add
               WHEN INFIELD(ven_no)
                  #CASE new[i].sfb02 #FUN-650054        #MOD-A30177 mark
                  #  WHEN '7'                           #MOD-A30177 mark
                   CASE                                 #MOD-A30177
                     WHEN new[i].sfb02 MATCHES '[78]'   #MOD-A30177
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_pmc"
                        LET g_qryparam.default1 = new[i].ven_no
                        CALL cl_create_qry() RETURNING new[i].ven_no
                     OTHERWISE
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gem"
                        LET g_qryparam.default1 = new[i].ven_no
                        CALL cl_create_qry() RETURNING new[i].ven_no
                   END CASE
                   DISPLAY new[i].ven_no TO s_new[i].ven_no     
                   NEXT FIELD ven_no
               WHEN INFIELD(costcenter)
                    CALL cl_init_qry_var()
                    IF g_aaz.aaz90='Y' THEN
                       LET g_qryparam.form ="q_gem4"
                    ELSE
                       LET g_qryparam.form ="q_gem"
                    END IF
                    LET g_qryparam.default1 = new[i].costcenter
                    CALL cl_create_qry() RETURNING new[i].costcenter
                    DISPLAY BY NAME new[i].costcenter
                    NEXT FIELD costcenter
                #FUN-A50066--begin--add--------------
                WHEN INFIELD(sfb06) 
                  LET i=ARR_CURR()
                  SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01=new[i].new_part
                  IF cl_null(l_ima571) THEN LET l_ima571=' ' END IF
                  CALL cl_init_qry_var()
                 #MOD-E30086-Start-Modify 
                  IF g_sma.sma541 = 'Y' THEN    
                       LET g_qryparam.form     = "q_ecu05_a" 
                    ELSE   
                       LET g_qryparam.form     = "q_ecu05"   
                  END IF 
                  LET g_qryparam.arg1     = l_ima571
                  LET g_qryparam.arg2 = new[i].new_part        
                  LET g_qryparam.default1 = new[i].sfb06
                  CALL cl_create_qry() RETURNING g_ecu01,new[i].sfb06 
                  
                 # LET g_qryparam.form = "q_ecu_a"
                 #LET g_qryparam.default1 = new[i].sfb06
                 #LET g_qryparam.arg1 = l_ima571
                 #LET g_qryparam.arg1 = new[i].new_part
                 #CALL cl_create_qry() RETURNING new[i].sfb06
                 #MOD-E30086-End-Modify  
                  DISPLAY new[i].sfb06 TO sfb06 
                  NEXT FIELD sfb06
                #FUN-A50066--end--add----------------
                #FUN-A80054--begin--add-------------
                WHEN INFIELD(edc01) OR INFIELD(edc02) 
                  LET i=ARR_CURR()
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_edc"
                  LET g_qryparam.default1 = new[i].edc01
                  LET g_qryparam.default2 = new[i].edc02
                  LET g_qryparam.where = " edb03='",new[i].new_part,"' AND edb04='",new[i].sfb06,"' "
                  CALL cl_create_qry() RETURNING new[i].edc01,new[i].edc02
                  DISPLAY new[i].edc01 TO edc01
                  DISPLAY new[i].edc02 TO edc02
                  NEXT FIELD CURRENT
                #FUN-A80054--end--add--------------------
               OTHERWISE EXIT CASE 
             END CASE
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
         #FUN-C50052---begin
         ON ACTION ALL
            FOR l_i = 1 TO new.getLength()
               LET new[l_i].x = 'Y'
            END FOR
         ON ACTION no_all
            FOR l_i = 1 TO new.getLength()
               LET new[l_i].x = 'N'
            END FOR
         #FUN-C50052---end
      END INPUT
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         RETURN
      END IF
   END IF  #TQC-730022 add   
 
      LET l_proc = 'N'
      # 檢查單身
      FOR i = 1 TO new.getLength()
         ##---- 20231004 add by momo (S) 生產量與訂單量檢核
         IF new[i].x = 'Y' AND new[i].oeb12 <> new[i].new_qty THEN
            IF cl_confirm('csf-020') THEN
               LET g_flag = 'N'
               EXIT FOR
            END IF
         END IF
         ##---- 20231004 add by momo (E) 生產量與訂單量檢核
         
         #TQC-C80187--------begin--------
         IF new[i].x = 'Y' AND NOT cl_null(new[i].ven_no) THEN   #MOD-D50030 
         #MOD-E30038-Start-Add
           #IF new[g_i].sfb02 = '7' OR new[g_i].sfb02 = '8' THEN   #MOD-FB0085 mark
            IF new[i].sfb02 = '7' OR new[i].sfb02 = '8' THEN       #MOD-FB0085 add
               SELECT pmc03 FROM pmc_file
                WHERE pmc01=new[i].ven_no
                  AND pmcacti= 'Y' 
               IF STATUS THEN
                  CALL cl_err3("sel","pmc_file",new[i].ven_no,"",STATUS,"","sel pmc",1)  
                  EXIT FOR 
               END IF
            END IF    
           #IF new[g_i].sfb02 = '1' THEN   #MOD-FB0085 mark 
            IF new[i].sfb02 = '1' THEN     #MOD-FB0085 add
         #MOD-E30038-End-Add    
               SELECT gem02 FROM gem_file
                WHERE gem01=new[i].ven_no
                  AND gemacti = 'Y'
               IF STATUS THEN
                  LET g_flag = 'N'
                  CALL cl_err3("sel","gem_file",new[i].ven_no,"",STATUS,"","sel gem:",1)    
                  EXIT FOR
               END IF
            END IF #MOD-E30038 add
         END IF    
         #TQC-C80187-------end---------       
         IF new[i].x = 'Y' AND cl_null(new[i].new_no) THEN
            LET g_flag = 'N'
            CALL cl_err('','asf-380','1')                                                                                           
#           ERROR "尚未完成工單編號"                                                                                                
            EXIT FOR
         END IF
         IF new[i].x = 'Y' THEN
            LET l_proc = 'Y'
        #END IF                                      #MOD-F10084 mark
        #IF new[i].x = 'Y' THEN   #MOD-BA0006 add    #MOD-F10084 mark
            IF new[i].sfb02 NOT MATCHES '[58]' THEN  #MOD-F10084 add
              #TQC-B60323  --begin
               SELECT ima561,ima56 INTO l_ima561,l_ima56 FROM ima_file 
                WHERE ima01 = new[i].new_part
               IF l_ima561 > 0 THEN
                 IF new[i].new_qty < l_ima561 THEN
                    LET g_flag = 'N'
                    CALL cl_err(l_ima561,'asf-307',1)
                    EXIT FOR
                 END IF
               END IF
               LET l_allowqty = new[i].new_qty       #MOD-D70080 add
               IF NOT cl_null(l_ima56) AND l_ima56>0  THEN
                  LET l_qty1 = new[i].new_qty * 1000
                  LET l_qty2 = l_ima56 * 1000
                  IF (l_qty1 MOD l_qty2) > 0 THEN
                     LET g_flag = 'N'
                     CALL cl_err(l_ima56,'asf-308',1)
                     EXIT FOR
                  END IF
                 #CHI-B80044 -- begin --
                  IF l_qty > 0 THEN
                     LET l_calc = 0
                    #LET l_allowqty = new[i].new_qty #MOD-D70080 mark
                     IF l_availqty MOD l_ima56 > 0 THEN
                        LET l_calc = l_availqty/l_ima56 + 1
                        LET l_allowqty = l_calc * l_ima56
                     END IF
                     IF g_sfb.sfb08 > l_allowqty THEN
                        CALL cl_err('','asf-358',1)
                        EXIT FOR
                     END IF
                  END IF
                 #CHI-B80044 -- end --
               END IF
              #TQC-B60323  --end
            END IF   #MOD-F10084 add
         END IF            #MOD-BA0006 add
      END FOR 
   
      IF g_flag= 'N' THEN
         CONTINUE WHILE
      END IF
 
      IF l_proc = 'N' THEN
         EXIT WHILE
      END IF
   
      IF g_bgjob = 'N' THEN  #TQC-730022
        IF NOT cl_sure(19,0) THEN
           RETURN
        END IF
      END IF
   
      CALL cl_wait()

      #M001 171115 By TSD.Nic -----(S)
      LET g_wos = " sfb01 IN ('"
      #M001 171115 By TSD.Nic -----(E)
  
    # 陣列列印資料
      CALL s_showmsg_init() #FUN-920088
      FOR i=1 TO new.getLength()
         BEGIN WORK
         LET g_success = 'Y'   #No.MOD-960317
         IF cl_null(new[i].new_part) THEN
            EXIT FOR
         END IF
         IF cl_null(new[i].new_no) THEN 
            CONTINUE FOR
         END IF
         IF cl_null(new[i].new_qty) THEN
            CONTINUE FOR
         END IF
         IF new[i].x = 'N' THEN
            CONTINUE FOR
         END IF
         IF new[i].new_qty = 0 THEN
            CONTINUE FOR
         END IF
   
         INITIALIZE l_sfb.* TO NULL
  
        IF cl_null(new[i].new_no[g_no_sp,g_no_ep]) THEN                                                                               
           CALL s_auto_assign_no("asf",new[i].new_no,g_sfb.sfb81,"","","","","","")                                              
                RETURNING li_result,new[i].new_no                                                                                            
           IF (NOT li_result) THEN                                    
              CALL s_errmsg('smyslip',new[i].new_no,'s_auto_assign_no','asf-963',1)
              LET g_success='N'
            END IF    #有問題
         END IF
   
         LET l_sfb.sfb01 = new[i].new_no
         LET l_sfb.sfb02 = new[i].sfb02 #FUN-650054
         LET l_sfb.sfb04 = '1'
         LET l_sfb.sfb05 = new[i].new_part
        #先不給"製程編號"(sfb06)，到後面再根據sfb93判斷要不要給值
         SELECT ima35,ima36,ima571
           INTO l_sfb.sfb30,l_sfb.sfb31,l_item
           FROM ima_file
          WHERE ima01=l_sfb.sfb05 AND imaacti= 'Y'

        #MOD-E30086-Start-Add
        #如不同料號，卻有相同名稱的製程，會有問題，故都改抓開窗回傳的料號
         IF NOT cl_null(g_ecu01) THEN
            LET l_item = g_ecu01
         END IF 
        #MOD-E30086-End-Add
     
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('ima01',l_sfb.sfb05,'select ima35','aom-198',1)
            LET g_success = 'N'
         END IF
         IF cl_null(l_item) THEN LET l_item=l_sfb.sfb05 END IF #TQC-AB0136
 
         LET l_ima910=new[i].ima910
         IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
         #FUN-A50066--begin--add-------------------
         LET l_cnt = 0
         IF NOT cl_null(new[i].sfb06) AND g_sma.sma542 = 'Y' THEN
            SELECT count(*) INTO l_cnt FROM bra_file
             WHERE bra01=l_sfb.sfb05
               AND bra05 IS NOT NULL
               AND bra05 <=g_sfb.sfb81
               AND bra06 = l_ima910 
               AND bra011 = new[i].sfb06
               AND braacti = 'Y'      
        #ELSE  #FUN-B20075
         #FUN-A50066--end--add------------------
         END IF  #FUN-B20075
         IF l_cnt = 0 THEN  #FUN-B20075
            SELECT count(*) INTO l_cnt FROM bma_file  #FUN-A50066
             WHERE bma01=l_sfb.sfb05
               AND bma05 IS NOT NULL
               AND bma05 <=g_sfb.sfb81
               AND bma06 = l_ima910   #FUN-550112
               AND bmaacti = 'Y'      #CHI-740001
               AND bma10 = '2'        #20190905 BOM應被發放
         END IF  #FUN-A50066
   
         IF l_cnt = 0 THEN   #FUN-A50066
            IF l_sfb.sfb02!='5' AND l_sfb.sfb02!='8' AND l_sfb.sfb02!='11' THEN    #MOD-AB0063 add
               #CALL s_errmsg('bom',l_sfb.sfb05,'select bom','mfg5071',1)  #20180416 mark
               CALL s_errmsg('bom',l_sfb.sfb05,g_sfb.sfb81,'mfg5071',1)    #20180416 modify
               LET g_success = 'N'
            END IF                     #MOD-AB0063 add
         END IF
   
         #--(1)產生工單檔(sfb_file)---------------------------
        #Mod FUN-B20060
        #LET l_sfb.sfb071= g_sfb.sfb81
         SELECT oeb72 INTO l_sfb.sfb071 FROM oeb_file
          WHERE oeb01 = new[i].oeb01
            AND oeb03 = new[i].oeb03
         IF cl_null(l_sfb.sfb071) THEN
           #LET l_sfb.sfb071= g_sfb.sfb81    #MOD-C80127 mark
            LET l_sfb.sfb071= g_today        #MOD-C80127 add
         END IF
        #End Mod FUN-B20060
        
         LET l_sfb.sfb08 = new[i].new_qty
         LET l_sfb.sfb081= 0
         LET l_sfb.sfb09 = 0
         LET l_sfb.sfb10 = 0
         LET l_sfb.sfb11 = 0
         LET l_sfb.sfb111= 0
         LET l_sfb.sfb121= 0
         LET l_sfb.sfb122= 0 
         LET l_sfb.sfb12 = 0
         LET l_sfb.sfb13 = new[i].b_date
         LET l_sfb.sfb14 = '00:00'       #MOD-FA0134 add
         LET l_sfb.sfb15 = new[i].e_date
         LET l_sfb.sfb16 = '00:00'       #MOD-FA0134 add
         LET l_sfb.sfb23 = 'Y' #FUN-650054
         LET l_sfb.sfb24 = 'N'
         LET l_sfb.sfb251= g_sfb.sfb81
         LET l_sfb.sfb22 = new[i].oeb01                                                                                           
         LET l_sfb.sfb221= new[i].oeb03 
         #M001 171117 By TSD.Nic -----(S)
         LET l_sfb.ta_sfb01 = l_sfb.sfb221 USING "&&&"
         LET l_sfb.ta_sfb01 = l_sfb.sfb22,l_sfb.ta_sfb01
         #M001 171117 By TSD.Nic -----(E)
         LET l_oebislk01 = null   #FUN-E20042--add
         SELECT oebislk01 INTO l_oebislk01 FROM oebi_file WHERE oebi01 = new[i].oeb01 AND oebi03 = new[i].oeb03  #FUN-E20042--add
         LET l_sfb.sfb27 = ' '    #No.MOD-480184
         LET l_sfb.sfb29 = 'Y'
         LET l_sfb.sfb39 = '1'
         LET l_sfb.sfb81 = g_sfb.sfb81
         LET l_sfb.sfb82 = new[i].ven_no
         LET l_sfb.sfb85 = ' '    #No.MOD-480184
         LET l_sfb.sfb86 = ' '    #No.MOD-480184
         LET l_sfb.sfb89 = ' '    #FUN-C30114
         LET l_sfb.sfb87 = 'N'
         LET l_sfb.sfb91 = ' '    #No.MOD-480184
         LET l_sfb.sfb92 = NULL   #MOD-530402
         LET l_sfb.sfb87 = 'N'    #97/08/21 modify
         LET l_sfb.sfb41 = 'N'
         LET l_sfb.sfb44 = g_user #FUN-920088
         LET l_sfb.sfb919=new[i].sfb919   #FUN-A80102<p align="center"></p>
         LET l_formid = s_get_doc_no(new[i].new_no)
        #MOD-C90048---S---
         SELECT oeb41,oeb42,oeb43,oeb1001 INTO l_oeb41,l_oeb42,l_oeb43,l_oeb1001
           FROM oeb_file
          WHERE oeb01 = g_oea.oea01
         LET l_sfb.sfb27 = l_oeb41
         LET l_sfb.sfb271= l_oeb42
         LET l_sfb.sfb50 = l_oeb43
         LET l_sfb.sfb51 = l_oeb1001 
        #MOD-C90048---E--- 
         SELECT smyapr INTO l_sfb.sfbmksg FROM smy_file
          WHERE smyslip=l_formid
         LET l_sfb.sfb43 = '0'    #FUN-920088
         IF l_sfb.sfb02='11' THEN #拆件式工單=>sfb99='Y'
            LET l_sfb.sfb99 = 'Y'
         ELSE
            LET l_sfb.sfb99 = 'N'
         END IF
         LET l_sfb.sfb85= tm.sfc01 #No.FUN-810014
         LET l_sfb.sfb17 = NULL   #TQC-7A0065
         LET l_sfb.sfb95=l_ima910
         LET l_sfb.sfb98 = new[i].costcenter #FUN-670103
         LET l_sfb.sfbacti = 'Y'
         LET l_sfb.sfbuser = g_user
         LET l_sfb.sfbgrup = g_grup
         LET l_sfb.sfbdate = g_today
         LET l_sfb.sfb1002='N' #保稅核銷否 #FUN-6B0044
 
         LET l_sfb.sfbplant = g_plant #FUN-980008 add
         LET l_sfb.sfblegal = g_legal #FUN-980008 add
   
         LET l_slip = s_get_doc_no(l_sfb.sfb01)     #No.FUN-550067     
         SELECT smy57 INTO l_smy57 FROM smy_file WHERE smyslip=l_slip
        #LET l_sfb.sfb93 = l_smy57[1,1]  #FUN-A50066
         LET l_sfb.sfb93 = new[i].sfb93  #FUN-A50066
         LET l_sfb.sfb94 = l_smy57[2,2]
         #MOD-G10147 add start -----------------------
         LET l_sfb.sfb100= l_smy57[6,6]
         IF l_sfb.sfb02 NOT MATCHES "[78]" THEN  
            LET l_sfb.sfb100 = '1'                
         END IF                                
         IF cl_null(l_sfb.sfb100) THEN
            LET l_sfb.sfb100 = '1'
         END IF                     
         #MOD-G10147 add end   -----------------------
        #IF l_sfb.sfb93='Y' AND (  #FUN-A50066
         IF NOT cl_null(new[i].sfb06) AND ( #FUN-A50066
            l_sfb.sfb02!='7' AND l_sfb.sfb02!='8' AND l_sfb.sfb02!='15') THEN
            #SELECT ima94 INTO l_sfb.sfb06 FROM ima_file  #FUN-A50066
            # WHERE ima01=l_sfb.sfb05 AND imaacti= 'Y'    #FUN-A50066
            LET l_sfb.sfb06 = new[i].sfb06                #FUN-A50066
         END IF
   
#CHI-B80053 -- begin --
         IF cl_null(l_sfb.sfb98) THEN
            SELECT ima34 INTO l_sfb.sfb98 FROM ima_file
             WHERE ima01 = l_sfb.sfb05
         END IF
#CHI-B80053 -- end --

         LET l_sfb.sfboriu = g_user      #No.FUN-980030 10/01/04
         LET l_sfb.sfborig = g_grup      #No.FUN-980030 10/01/04

         #MOD-A40002 start---
         SELECT oeb1001,oeb22 INTO l_sfb.sfb51,l_sfb.sfb07 FROM oeb_file   #TQC-B60189  add oeb22
           WHERE oeb01 = l_sfb.sfb22
             AND oeb03 = l_sfb.sfb221
         #MOD-A40002 end---

         #MOD-A90067 add --start--
         IF l_smy57[5,5] = 'Y' THEN
            SELECT oeb908 INTO l_sfb.sfb97 FROM oeb_file
             WHERE oeb01 = l_sfb.sfb22
               AND oeb03 = l_sfb.sfb221
         END IF
         #MOD-A90067 add --end--

         #FUN-D80022--add--str--
         SELECT oea03,oea10 INTO l_sfb.sfb223,l_sfb.sfb224
           FROM oea_file WHERE oea01 = new[i].oeb01 
         #FUN-D80022--add--end--
         LET l_sfb.sfb104 = 'N'    #TQC-A50087 add
#FUN-D80022 ------- add ----------begin -------------- BY zhuhao 若订单对应工单资料已存在，且未审核，提示是否覆盖
         IF g_sma.sma150 = 'Y' AND NOT cl_null(l_sfb.sfb22) AND NOT cl_null(l_sfb.sfb221) THEN
            SELECT COUNT(*) INTO l_count FROM sfb_file
             WHERE sfb22 = l_sfb.sfb22 AND sfb221 = l_sfb.sfb221 AND sfb87 = 'N'
            IF l_count > 0 AND NOT cl_null(l_count) THEN
               IF cl_confirm('asf1058') THEN
                  DECLARE sfb_cs1 CURSOR FOR SELECT sfb01 FROM sfb_file 
                                              WHERE sfb22 = = l_sfb.sfb22 AND sfb221 = l_sfb.sfb221 AND sfb87 = 'N'
                  FOREACH sfb_cs1 INTO l_sfb01
                      DELETE FROM sfb_file WHERE sfb01 = l_sfb01
                      DELETE FROM sfbc_file WHERE sfbc01 = l_sfb01
                      DELETE FROM sfa_file WHERE sfa01 = l_sfb01
                      DELETE FROM sfac_file WHERE sfac01 = l_sfb01
                      DELETE FROM sfc_file WHERE sfc01 = tm.sfc01
                      DELETE FROM sfd_file WHERE sfd01 = tm.sfc01
                      #FUN-E20042---add--begin-----------
                      DELETE FROM sfbi_file WHERE sfbi01 = l_sfb01
                      DELETE FROM sfaa_file WHERE sfbi01 = l_sfb01   
                      DELETE FROM sfai_file WHERE sfai01 = l_sfb01 
                      #FUN-E20042---add--end-------------
                  END FOREACH
               END IF
            END IF
         END IF
#FUN-D80022 ------- add ----------end ---------------- 

         
         INSERT INTO sfb_file VALUES(l_sfb.*)
         IF SQLCA.SQLCODE THEN
            CALL s_errmsg('sfb05',l_sfb.sfb05,'insert sfb','asf-738',1)
            LET g_success='N'   
            LET new[i].new_no=null
         END IF
         #FUN-D80022--add--str--
         IF s_industry('slk') AND g_sma.sma150='Y' AND l_sfb.sfb02 MATCHES '[17]' THEN
            INITIALIZE l_sfbc.* TO NULL
            LET l_sfbc.sfbc01 = l_sfb.sfb01
            LET l_sfbc.sfbc02 = 0

            DECLARE p304_sfbc_ins CURSOR FOR
             SELECT oebc05,oebc06,oebc07 FROM oebc_file 
              WHERE oebc01=l_sfb.sfb22 AND oebc03=l_sfb.sfb221
            FOREACH p304_sfbc_ins INTO l_sfbc.sfbc03,l_sfbc.sfbc04,l_sfbc.sfbc05
               LET l_sfbc.sfbc02 = l_sfbc.sfbc02 + 1 
               INSERT INTO sfbc_file VALUES(l_sfbc.*)
               IF SQLCA.SQLCODE THEN
                  EXIT FOREACH
                  CALL s_errmsg('sfbc01',l_sfbc.sfbc01,'insert sfbc',SQLCA.sqlcode,1)
                  LET g_success='N'
               END IF
            END FOREACH
         END IF 
         #FUN-D80022--add--end--
       # IF NOT s_industry('std')  AND g_sma.sma150 <> 'Y' THEN    #FUN-D80022 add by zhuhao sma150 <> 'Y' #FUN-E20042--mark
         IF NOT s_industry('std') THEN    #FUN-E20042--add 
            INITIALIZE l_sfbi.* TO NULL
            LET l_sfbi.sfbi01 = l_sfb.sfb01
            LET l_sfbi.sfbiplant = g_plant    #FUN-E20042--add
            LET l_sfbi.sfbilegal = g_legal    #FUN-E20042--add
            IF NOT s_ins_sfbi(l_sfbi.*,'') THEN
               LET g_success='N'
               LET new[i].new_no = NULL
            END IF
         END IF
        IF s_industry('slk') AND cl_null(new[i].edc01) AND g_sma.sma150='N' THEN  #FUN-A80054 #FUN-D80022 
          #FUN-A80054--begin--add------------
          LET l_sfc.sfc01=tm.sfc01 
          LET l_sfc.sfcuser=g_user
          LET l_sfc.sfcgrup=g_grup
          LET l_sfc.sfcdate=g_today
          LET l_sfc.sfcacti='Y'
          LET l_sfc.sfcoriu=g_user
          LET l_sfc.sfcorig=g_grup
          INSERT INTO sfc_file VALUES(l_sfc.*)
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('sfc01',tm.sfc01,'insert sfc',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF
          IF NOT s_industry('std') THEN
             INITIALIZE l_sfci.* TO NULL
             LET l_sfci.sfci01 = l_sfc.sfc01 
             SELECT oebislk01 INTO l_sfci.sfcislk01 FROM oebi_file 
               WHERE oeb01 = g_oea.oea01 AND oeb03 = new[i].oeb03  #FUN-E20042--add
            #Mod No.MOD-B30028
            #LET l_flag = s_ins_sfci(l_sfci.*,'')
             SELECT COUNT(*) INTO l_cnt FROM sfci_file
              WHERE sfci01 = l_sfci.sfci01
             IF l_cnt = 0 THEN
                LET l_flag = s_ins_sfci(l_sfci.*,'')
             END IF
            #End Mod No.MOD-B30028
          END IF
          #FUN-A80054--end--add-----------
          SELECT MAX(sfd02)+1 INTO g_i FROM sfd_file WHERE sfd01 = tm.sfc01              #No.FUN-870117
          IF cl_null(g_i) THEN  LET g_i = 1 END IF                                       #No.FUN-870117
          #INSERT INTO sfd_file(sfd01,sfd02,sfd03,sfdconf)  VALUES(tm.sfc01,g_i,new[i].new_no,'N')    #No.FUN-870117 #FUN-A80054 #CHI-C60023
          INSERT INTO sfd_file(sfd01,sfd02,sfd03,sfdconf,sfd09)  VALUES(tm.sfc01,g_i,new[i].new_no,'N','2')  #CHI-C60023
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('sfd01',tm.sfc01,'insert sfb',SQLCA.sqlcode,1)
             LET g_success = 'N'
          ELSE
             MESSAGE 'INSERT O.K'            
          END IF
         END IF
         IF l_sfb.sfb93='Y' THEN
            CALL s_schdat(0,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb071,l_sfb.sfb01,
                          l_sfb.sfb06,l_sfb.sfb02,l_item,l_sfb.sfb08,2)
               RETURNING g_cnt,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb32,l_sfb.sfb24
         END IF
 
         IF l_sfb.sfb24 IS NOT NULL THEN
            UPDATE sfb_file
               SET sfb24= l_sfb.sfb24 
             WHERE sfb01=l_sfb.sfb01 
            IF SQLCA.sqlcode THEN 
               CALL s_errmsg('sfb05',l_sfb.sfb05,'update sfb',SQLCA.sqlcode,1)
               LET g_success='N' 
            END IF
         END IF
   
         #-->(2)產生備料檔
         LET l_minopseq=0
         
         CALL s_minopseq(l_sfb.sfb05,l_sfb.sfb06,l_sfb.sfb071) RETURNING l_minopseq
         
         CASE
            WHEN l_sfb.sfb02='1' OR l_sfb.sfb02='7' #一般工單 or 委外工單 (保留原本asfp304的處理方式)
               LET l_minopseq = 0
               IF s_industry('slk') AND l_sfb.sfb02='1' AND NOT cl_null(tm.bmb09) THEN   
                 #FUN-D80022--add--str--
                 IF g_sma.sma150='Y' THEN 
                    CALL s_cralc7(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
                                 l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb.sfb95,tm.bmb09,l_oebislk01) #FUN-E20042--add l_oebislk01
                       RETURNING g_cnt
                 ELSE 
                 #FUN-D80022--add--end-- 
                    CALL s_cralc5(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
                                 l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb.sfb95,tm.bmb09)
                       RETURNING g_cnt
                 END IF  #FUN-D80022 add
               ELSE
                 #FUN-D80022--add--str--
                 IF g_sma.sma150='Y' THEN
                    CALL s_cralc7(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
                                 l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb.sfb95,tm.bmb09,l_oebislk01) #FUN-E20042--add l_oebislk01
                       RETURNING g_cnt
                 ELSE
                 #FUN-D80022--add--end--
                   #CALL s_cralc4(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                    CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',  #FUN-BC0008 mod
                               l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,
                                 #new[i].a,l_sfb.sfb95)   #MOD-D90072 mark
                                  '',l_sfb.sfb95)         #MOD-D90072 add
                    RETURNING g_cnt
                  END IF #FUN-D80022  add
               END IF                       #No.FUN-870117
               
            WHEN l_sfb.sfb02='13'     #預測工單展至尾階
               CALL s_cralc2(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                             l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,
                             ' 1=1',l_sfb.sfb95)
               RETURNING g_cnt
            WHEN l_sfb.sfb02='15'     #試產性工單
               CALL s_cralc3(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                             l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,
                             l_sfb.sfb07,g_sma.sma883,l_sfb.sfb95)
               RETURNING g_cnt
            OTHERWISE                 #一般工單展單階
               IF l_sfb.sfb02 = 11 THEN
                  LET l_btflg = 'N'
               ELSE
                  LET l_btflg = 'Y'
               END IF
               CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
                           #l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb.sfb95)
                            l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,'',l_sfb.sfb95)  #FUN-BC0008 mod
                  RETURNING g_cnt
         END CASE
         IF g_cnt = 0 THEN
             CALL s_errmsg('sfb05',l_sfb.sfb05,'s_cralc error','asf-385',1)
             LET g_success = 'N' 
             LET new[i].new_no=null
         END IF
         #FUN-A80054--begin--add------------------------------
         IF g_sma.sma541 = 'Y' THEN  #FUN-B30035
            IF NOT cl_null(new[i].edc01) AND NOT cl_null(new[i].edc02) THEN
              #FUN-B30035--begin--add-------
              DECLARE sfd_cs1 CURSOR FOR
               SELECT sfd01 FROM sfd_tmp
              LET l_sfd01=''  LET l_sfd.sfd01=''
              FOREACH sfd_cs1 INTO l_sfd01
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM sfd_file WHERE sfd01=l_sfd01 AND sfd08=new[i].edc01 AND sfdconf='N'
                 IF l_cnt > 0 THEN
                    LET l_sfd.sfd01=l_sfd01
                    EXIT FOREACH
                 END IF
              END FOREACH 
              #FUN-B30035--end--add-------
              #FUN-B30035--begin--mark-----
              #DECLARE sfd_cs CURSOR FOR
              # SELECT sfd01 FROM sfd_file WHERE sfd08=new[i].edc01 AND sfdconf='N' ORDER BY sfd01
              #LET l_sfc01=''
              #FOREACH sfd_cs INTO l_sfc01
              #  EXIT FOREACH
              #END FOREACH
              #IF NOT cl_null(l_sfc01) THEN
              #   LET l_sfd.sfd01=l_sfc01
              #ELSE 
              #FUN-B30035--end--mark-----
               IF cl_null(l_sfd.sfd01) THEN  #FUN-B30035
                  LET l_t1=s_get_doc_no(new[i].edc01) 
                  SELECT smy75 INTO l_sfd.sfd01 FROM smy_file
                   WHERE smyslip=l_t1
                  IF cl_null(l_sfd.sfd01) THEN 
                     CALL s_errmsg('smy75',l_t1,'sel smy','aec-060',1)
                     LET g_success='N' 
                     LET new[i].new_no=null
                  END IF
                  CALL s_auto_assign_no("asf",l_sfd.sfd01,g_today,"8","sfd_file","sfd01","","","") 
                  RETURNING li_result,l_sfd.sfd01                                                                                               
                  IF (NOT li_result) THEN                                                                                                     
                     LET g_success='N'
                     LET new[i].new_no=null
                  END IF
                  IF NOT cl_null(l_sfd.sfd01) THEN
                     LET l_sfc.sfc01=l_sfd.sfd01
                     LET l_sfc.sfcuser=g_user
                     LET l_sfc.sfcgrup=g_grup
                     LET l_sfc.sfcdate=g_today
                     LET l_sfc.sfcacti='Y'
                     LET l_sfc.sfcoriu=g_user
                     LET l_sfc.sfcorig=g_grup
                     INSERT INTO sfc_file VALUES(l_sfc.*)
                     IF SQLCA.sqlcode THEN 
                        CALL s_errmsg('sfc01',l_sfc.sfc01,'ins sfc',SQLCA.sqlcode,1)
                        LET g_success='N' 
                        LET new[i].new_no=null
                     END IF
                     IF NOT s_industry('std') THEN
                        INITIALIZE l_sfci.* TO NULL
                        LET l_sfci.sfci01 = l_sfc.sfc01 
                       #LET l_flag = s_ins_sfci(l_sfci.*,'')  #FUN-E20042-mark
                        SELECT oebislk01 INTO l_sfci.sfcislk01 FROM oebi_file
                             WHERE oeb01 = g_oea.oea01 AND oeb03 = new[i].oeb03  #FUN-E20042--add
                       #Mod No.MOD-B30028
                       #LET l_flag = s_ins_sfci(l_sfci.*,'')
                        SELECT COUNT(*) INTO l_cnt FROM sfci_file
                         WHERE sfci01 = l_sfci.sfci01
                        IF l_cnt = 0 THEN
                           LET l_flag = s_ins_sfci(l_sfci.*,'')
                        END IF
                       #End Mod No.MOD-B30028
                     END IF
                     IF g_sma.sma541 = 'Y' THEN #FUN-B30035
                        INSERT INTO sfd_tmp VALUES(l_sfc.sfc01) #FUN-B30035
                     END IF  #FUN-B30035
                  END IF
               END IF  
               IF NOT cl_null(l_sfd.sfd01) THEN
                  SELECT MAX(sfd02)+1 INTO l_sfd.sfd02 FROM sfd_file WHERE sfd01=l_sfd.sfd01
                  IF cl_null(l_sfd.sfd02) THEN LET l_sfd.sfd02 = 1 END IF
                  LET l_sfd.sfd03=new[i].new_no
                  LET l_sfd.sfd08=new[i].edc01
                  LET l_sfd.sfd04=new[i].edc02
                  LET l_sfd.sfd09 = '2'  #CHI-C60023
                  LET l_sfd.sfdconf='N'
                  LET  l_sfd.sfduser = g_user        #FUN-D10127
                  LET  l_sfd.sfdgrup = g_grup        #FUN-D10127
                  LET  l_sfd.sfddate = g_today       #FUN-D10127
                  LET  l_sfd.sfdacti ='Y'            #FUN-D10127
                  LET  l_sfd.sfdoriu = g_user        #FUN-D10127
                  LET  l_sfd.sfdorig = g_grup        #FUN-D10127
                  SELECT edb05,edb07 INTO l_sfd.sfd05,l_sfd.sfd07
                    FROM edb_file
                   WHERE edb01=new[i].edc01
                     AND edb02=new[i].edc02
                  INSERT INTO sfd_file VALUES(l_sfd.*)
                  IF SQLCA.sqlcode THEN 
                     CALL s_errmsg('sfd01',l_sfd.sfd01,'ins sfd',SQLCA.sqlcode,1)
                     LET g_success='N' 
                     LET new[i].new_no=null
                  END IF
                  SELECT sum(sfd05) INTO l_sfd.sfd06 FROM sfd_file WHERE sfd01=l_sfd.sfd01
                  UPDATE sfd_file SET sfd06=l_sfd.sfd06 WHERE sfd01=l_sfd.sfd01
                  UPDATE sfb_file SET sfb85=l_sfd.sfd01 WHERE sfb01=l_sfb.sfb01
                  IF g_success='Y' THEN
                     CALL p304_ins_edg(l_sfd.sfd01,l_sfd.sfd02,l_sfd.sfd03,new[i].edc01,new[i].edc02)
                     IF g_success='N' THEN LET new[i].new_no=null END IF
                     IF g_success = 'Y' THEN
                        CALL p304_ins_edh(l_sfd.sfd01,l_sfd.sfd02,new[i].edc01,new[i].edc02)
                        IF g_success='N' THEN LET new[i].new_no=null END IF
                     END IF
                  END IF
               END IF
            END IF
         END IF  #FUN-B30035
         #FUN-A80054--end--add------------------------------------
       #FUN-D50098 ---------Begin---------
        #IF g_success='Y' THEN
        #   COMMIT WORK
        #ELSE
        #   LET new[i].new_no=null  #TQC-B60133
        #   ROLLBACK WORK
        #END IF
       #FUN-D50098 ---------End-----------
         #判斷sfb02若為'5，11'時不產生子工單
         IF l_sfb.sfb02 != '5' AND l_sfb.sfb02 != '11' THEN
         #FUN-D50098 ------Begin-------
          # LET g_msg="asfp301 '",l_sfb.sfb01,"' '",   # for top40
          #            l_sfb.sfb81,"' '99' 'N'"
          # CALL cl_cmdrun_wait(g_msg)
            IF new[i].a = 'Y' THEN
               CALL p301(l_sfb.sfb01, l_sfb.sfb81, 99, 'N', TRUE)
            END IF
         #FUN-D50098 ------End---------
         END IF

         CALL p304_chk_sfb39(l_sfb.sfb01)       #CHI-C50029 add 
 
 
      END FOR
      CALL s_showmsg()    #No.MOD-960317

   #FUN-D50098 ---------Begin----------
      IF g_success = 'Y' THEN
         COMMIT WORK
         # 将成功生成的工单号显示出来
         LET g_sql = "SELECT * FROM p304_tmp ORDER BY orno"
         DECLARE p304_orno CURSOR FROM g_sql
         LET i = 1
         FOREACH p304_orno INTO l_max_no
         #  LET mg[i] = l_max_no       #TQC-E10045 mark
            LET mg[i].orno = l_max_no  #TQC-E10045 add
            LET i = i + 1
         END FOREACH
         CALL cl_get_feldname('sfb01', g_lang) RETURNING g_msg
         CALL cl_show_array(base.TypeInfo.CREATE(mg), g_msg, g_msg)
      ELSE
         ROLLBACK WORK
         RETURN           #TQC-DA0029 add 
      END IF
      DROP TABLE p304_tmp
   #FUN-D50098 ---------End------------
   
      ERROR ""
      IF g_sma.sma541 = 'Y' THEN  DROP TABLE sfd_bmp END IF  #FUN-B30035
   
      LET l_max_no = ''  #TQC-C70031 add
      LET l_min_no = ''  #TQC-C70031 add
      FOR i=1 TO new.getLength()
         #TQC-C70031--modify--str--
         #IF i = 1 THEN
         #   LET l_max_no = new[i].new_no
         #   LET l_min_no = new[i].new_no
         #END IF
         IF new[i].x = 'N' THEN
            CONTINUE FOR
         END IF
         IF cl_null(l_max_no) AND cl_null(l_min_no) THEN
            LET l_max_no = new[i].new_no
            LET l_min_no = new[i].new_no
         END IF
         #TQC-C70031--modify--end--
         IF cl_null(l_max_no) THEN LET l_max_no = ' ' END IF    #MOD-B40215 add
         IF new[i].new_no > l_max_no THEN LET l_max_no = new[i].new_no END IF
         IF cl_null(l_min_no) THEN LET l_min_no = l_max_no END IF    #MOD-B40215 add
         IF new[i].new_no < l_min_no THEN LET l_min_no = new[i].new_no END IF
         #TQC-C70002 add 用子工單更新l_min_no、l_max_no
         IF NOT cl_null(new[i].new_no) THEN  
            #M001 171115 By TSD.Nic -----(S)
            IF g_wos = " sfb01 IN ('" THEN
               LET g_wos = g_wos,new[i].new_no CLIPPED
            ELSE
               LET g_wos = g_wos,"','",new[i].new_no CLIPPED
            END IF
            #M001 171115 By TSD.Nic -----(E)
            CALL p304_sub_no(new[i].new_no,l_min_no,l_max_no) RETURNING l_min_no,l_max_no 
         END IF 
         #TQC-C70002 add 
         IF cl_null(new[i].new_part) THEN EXIT FOR END IF
         DISPLAY new[i].new_no TO s_new[i].new_no
      END FOR

      #M001 171115 By TSD.Nic -----(S)
      LET g_wos = g_wos,"')"
      #M012 180129 By TSD.Nic -----(S)
      #LET g_wos = g_wos," AND sfb87 = 'Y' "    #M001 171229 By TSD.Jin
      #M012 180129 By TSD.Nic -----(E)
      #M001 171115 By TSD.Nic -----(E)

       LET i = new.getLength()
       #TQC-B60133--begin--add-
       IF cl_null(l_max_no) AND cl_null(l_min_no) THEN
          CALL cl_err('','asf-196',1)
       ELSE
       #TQC-B60133--end--add
         #MOD-B40215---modify---start---
         #LET g_msg = l_min_no CLIPPED,"~",l_max_no
          IF cl_null(l_min_no) THEN
             LET g_msg = l_max_no CLIPPED
          ELSE
             IF cl_null(l_max_no) THEN
                LET g_msg = l_min_no CLIPPED
             ELSE
                LET g_msg = l_min_no CLIPPED,"~",l_max_no
             END IF
          END IF
         #MOD-B40215---modify---end---
          CALL cl_err(g_msg,'mfg0101',1) 
       END IF  #TQC-B60133
       #處理自動過帳部份
        #M001 171117 By TSD.Nic -----(S)
        #M012 180129 By TSD.Nic unmark -----(S)
        IF g_argv3 = 'Y' THEN
        #M012 180129 By TSD.Nic unmark -----(E)
        #M001 171117 By TSD.Nic -----(E)
          FOR i = 1 TO new.getLength()
             #M001 171206 By TSD.Jin--start--
             IF new[i].x = 'N' THEN
                CONTINUE FOR
             END IF
             IF cl_null(new[i].new_no) THEN
                CONTINUE FOR
             END IF
             #M001 171206 By TSD.Jin--end----

            #CALL i301sub_firm1_chk(l_sfb.sfb01,FALSE)  #CALL原確認的check段  #No.FUN-950021    #MOD-G60047 mark 
             CALL i301sub_firm1_chk(new[i].new_no,FALSE)  #CALL原確認的check段  #No.FUN-950021  #MOD-G60047 add  
             IF g_success = 'Y' THEN
               #CALL i301sub_firm1_upd(l_sfb.sfb01,"confirm",FALSE)  #CALL原確認的update段  #No.FUN-950021    #MOD-G60047 mark
                CALL i301sub_firm1_upd(new[i].new_no,"confirm",FALSE)  #CALL原確認的update段  #No.FUN-950021  #MOD-G60047 add 
             END IF
          END FOR
        #M001 171117 By TSD.Nic -----(S)
        #M012 180129 By TSD.Nic unmark -----(S)
        END IF
        #M012 180129 By TSD.Nic unmark -----(E)
        #M001 171117 By TSD.Nic -----(E)

      #M001 171115 By TSD.Nic -----(S)
      IF g_wos = " sfb01 IN ('')" THEN      #M001 171229 By TSD.Jin mark  #M012 180129 By TSD.Nic unmark
      #IF g_wos = " sfb01 IN ('') AND sfb87 = 'Y' " THEN  #M001 171229 By TSD.Jin  #M012 180129 By TSD.Nic mark
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
        #M012 180129 By TSD.Nic -----(S)
        LET l_wos = g_wos
        LET l_pass_pmk = ''
        LET l_tot_cnt = 0
        LET l_ori_pmk = g_pmk.pmk01
        LET l_sql = "SELECT UNIQUE ima43 FROM sfb_file,sfa_file,ima_file ",
                    " WHERE sfb01 = sfa01 AND sfa03 = ima01 ",
                    "   AND sfa03 NOT LIKE '5%' AND ",g_wos CLIPPED
        DECLARE split_pmk_cs CURSOR FROM l_sql
        FOREACH split_pmk_cs INTO l_ima43
           IF SQLCA.sqlcode THEN
              CALL cl_err('split_pmk_cs',SQLCA.sqlcode,1)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
           LET g_pmk.pmk01 = l_ori_pmk
           IF NOT cl_null(l_ima43) THEN                                                     #20180409 add
           LET g_wos = l_wos," AND sfa03 NOT LIKE '5%' ",
                             " AND EXISTS( SELECT 1 FROM ima_file WHERE ima01 = sfa03 AND ima43 = '",l_ima43,"') "
           ELSE                                                                             #20180409 add
           LET g_wos = l_wos," AND sfa03 NOT LIKE '5%' ",                                   #20180409 add
                             " AND EXISTS( SELECT 1 FROM ima_file WHERE ima01 = sfa03 AND ima43 is null) "   #20180409 add
           END IF                                                                           #20180409 add
        #M012 180129 By TSD.Nic -----(E)
         CALL p304_ins_pmk()
         IF g_success = 'Y' THEN
            CALL p304_ins_pnl()
         END IF
         IF g_success = 'Y' THEN
            CALL p470('P',g_pmk.pmk01,pr_date) #20181019 add pr_date
         END IF
         IF g_success = 'Y' THEN
           #M001 180109 By TSD.Jin--start--
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM pml_file
            WHERE pml01 = g_pmk.pmk01
           IF l_cnt = 0 THEN
            DELETE FROM pmk_file WHERE pmk01 = g_pmk.pmk01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               IF SQLCA.sqlcode = 0 THEN LET SQLCA.sqlcode = 9050 END IF
               CALL cl_err3("del","pmk_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
            END IF
            LET g_pmk.pmk01 = NULL
           ELSE     
            #M001 180109 By TSD.Jin--end----
            LET l_pmk40 = 0
            #SELECT SUM(pml88) INTO l_pmk40   #20180528
            SELECT SUM(pmlud07) INTO l_pmk40  #20180528
              FROM pml_file
             WHERE pml01=g_pmk.pmk01
            IF SQLCA.sqlcode OR g_pmk.pmk40 IS NULL THEN
               LET g_pmk.pmk40=0
            END IF
            SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01=g_pmk.pmk22 AND aziacti='Y'
            CALL cl_digcut(l_pmk40,t_azi04) RETURNING l_pmk40
            UPDATE pmk_file SET pmk40=l_pmk40
             WHERE pmk01=g_pmk.pmk01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               IF SQLCA.sqlcode = 0 THEN LET SQLCA.sqlcode = 9050 END IF
               CALL cl_err3("upd","pmk_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","update pmk40 fail :",1)
               LET g_success = 'N'
            #M012 180129 By TSD.Nic -----(S)
            ELSE
               IF cl_null(l_pass_pmk) THEN
                  LET l_pass_pmk = g_pmk.pmk01
               #M012 180201 By TSD.Nic -----(S)
               #ELSE
               #   LET l_pass_pmk = l_pass_pmk,",",g_pmk.pmk01
               #M012 180201 By TSD.Nic -----(E)
               END IF
               LET l_tot_cnt = l_tot_cnt + 1
            #M012 180129 By TSD.Nic -----(E)
            END IF
           END IF    #M001 180109 By TSD.Jin
         END IF
        #M012 180129 By TSD.Nic -----(S)
        END FOREACH
        #M012 180129 By TSD.Nic -----(E)
        #M012 180201 By TSD.Nic -----(S)
        IF cl_null(l_pass_pmk) THEN
           LET l_pass_pmk = g_pmk.pmk01
        ELSE
           LET l_pass_pmk = l_pass_pmk,"~",g_pmk.pmk01
        END IF
        #M012 180201 By TSD.Nic -----(E)
         #M012 180129 By TSD.Nic -----(S)
         #IF g_success = 'Y' THEN
         #   CALL cl_err(g_pmk.pmk01,'axm-559',1) #請購單已經成功產生
         IF g_success = 'Y' AND l_tot_cnt > 0 THEN
            CALL cl_err(l_pass_pmk,'axm-559',1) #請購單已經成功產生
         #M012 180129 By TSD.Nic -----(E)
            COMMIT WORK
            #M012 180129 By TSD.Nic -----(S)
            #IF cl_confirm('TSD0012') THEN #是否要立即維護請購單？
            #   LET g_cmd = "apmt420 '",g_pmk.pmk01,"' '0' '' 'query'"
            #   CALL cl_cmdrun_wait(g_cmd CLIPPED)
            #END IF
            #M012 180129 By TSD.Nic -----(E)
         ELSE
          IF NOT cl_null(g_pmk.pmk01) THEN    #M001 180109 By TSD.Jin
            CALL cl_err('','axm-558',1) #請購單未能成功產生
          #M001 180109 By TSD.Jin--start--
          ELSE
            CALL cl_err('','TSD0033',1) #此次不需產生請購單
          END IF
          #M001 180109 By TSD.Jin--end----
            ROLLBACK WORK
         END IF
      END IF
      #M001 171115 By TSD.Nic -----(E)
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION p304_get_head()
   DEFINE p_sfb04      LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE l_str        LIKE type_file.chr20   #No.FUN-680121 VARCHAR(10)
 
   SELECT * INTO g_oea.* FROM oea_file
    WHERE oea01 = g_oea.oea01
      AND oeaconf = 'Y'
 
   SELECT gen02 INTO tm.gen02 FROM gen_file
    WHERE gen01 = g_oea.oea14
 
   DISPLAY BY NAME g_oea.oea01,g_oea.oea02,g_oea.oea14,tm.gen02,
                   g_oea.oea03,g_oea.oea032
END FUNCTION

#FUN-A80054--begin--add---------------------
FUNCTION p304_edc02(p_edc01,p_edc02,p_sfb05,p_sfb06)
DEFINE l_cnt    LIKE type_file.num5
DEFINE p_edc01  LIKE edc_file.edc01
DEFINE p_edc02  LIKE edc_file.edc02
DEFINE p_sfb05  LIKE sfb_file.sfb05
DEFINE p_sfb06  LIKE sfb_file.sfb06

  LET l_cnt=0
  LET g_errno=''
  IF cl_null(p_edc01) OR cl_null(p_edc02) OR cl_null(p_sfb05) OR cl_null(p_sfb06) THEN RETURN END IF  #FUN-B20085
  SELECT COUNT(*) INTO l_cnt FROM eda_file,edb_file 
   WHERE edb01=p_edc01 
     AND edb02=p_edc02
     AND edb03=p_sfb05 
     AND edb04=p_sfb06
     AND eda01=edb01 AND edaconf='Y'
  IF l_cnt=0 THEN LET g_errno='aec-058' END IF

END FUNCTION

FUNCTION p304_ins_edg(p_sfd01,p_sfd02,p_sfd03,p_edc01,p_edc02)
DEFINE p_sfd01    LIKE sfd_file.sfd01
DEFINE p_sfd02    LIKE sfd_file.sfd02
DEFINE p_sfd03    LIKE sfd_file.sfd03
DEFINE p_edc01    LIKE edc_file.edc01
DEFINE p_edc02    LIKE edc_file.edc02
DEFINE l_edg      RECORD LIKE edg_file.*
DEFINE l_edc      RECORD LIKE edc_file.*
#FUN-A80060--begin--add------------------
DEFINE p_strtdat       LIKE type_file.dat,
       p_duedat        LIKE type_file.dat,
       w_bdate,w_edate LIKE type_file.dat,
       w_day           LIKE type_file.num5, 
       w_flag          LIKE type_file.chr1,
       l_sfb13         LIKE sfb_file.sfb13,
       l_sfb15         LIKE sfb_file.sfb15
#FUN-A80060--end--add------------------

    DECLARE edc_cs CURSOR FOR
      SELECT * FROM edc_file WHERE edc01=p_edc01 AND edc02=p_edc02 ORDER BY edc03
    FOREACH edc_cs INTO l_edc.*
      LET l_edg.edg01 =p_sfd01
      LET l_edg.edg02 =p_sfd02
      LET l_edg.edg03 =l_edc.edc03   
      LET l_edg.edg04 =l_edc.edc04  
      LET l_edg.edg05 =l_edc.edc05  
      LET l_edg.edg06 =l_edc.edc06  
      LET l_edg.edg07 =l_edc.edc07  
      LET l_edg.edg08 =l_edc.edc08  
      LET l_edg.edg09 =l_edc.edc09  
      LET l_edg.edg10 =l_edc.edc10    
      LET l_edg.edg12 =l_edc.edc12  
      LET l_edg.edg121=l_edc.edc121 
      LET l_edg.edg13 =l_edc.edc13  
      LET l_edg.edg14 =l_edc.edc14  
      LET l_edg.edg15 =l_edc.edc15  
      LET l_edg.edg16 =l_edc.edc16  
      LET l_edg.edg17 =l_edc.edc17  
      LET l_edg.edg18 =l_edc.edc18  
      LET l_edg.edg19 =l_edc.edc19  
      LET l_edg.edg20 =l_edc.edc20  
      LET l_edg.edg21 =l_edc.edc21  
      LET l_edg.edg22 =l_edc.edc22  
      LET l_edg.edg23 =l_edc.edc23  
      LET l_edg.edg24 =l_edc.edc24  
      LET l_edg.edg25 =l_edc.edc25  
      LET l_edg.edg26 =l_edc.edc26  
      LET l_edg.edg27 =l_edc.edc27  
      LET l_edg.edg28 =l_edc.edc28  
      LET l_edg.edg291=l_edc.edc291 
      LET l_edg.edg292=l_edc.edc292 
      LET l_edg.edg301=l_edc.edc301 
      LET l_edg.edg302=l_edc.edc302 
      LET l_edg.edg303=l_edc.edc303 
      LET l_edg.edg311=l_edc.edc311 
      LET l_edg.edg312=l_edc.edc312 
      LET l_edg.edg313=l_edc.edc313 
      LET l_edg.edg314=l_edc.edc314 
      LET l_edg.edg315=l_edc.edc315 
      LET l_edg.edg316=l_edc.edc316 
      LET l_edg.edg321=l_edc.edc321 
      LET l_edg.edg322=l_edc.edc322 
      LET l_edg.edg34 =l_edc.edc34  
      LET l_edg.edg35 =l_edc.edc35  
      LET l_edg.edg36 =l_edc.edc36  
      LET l_edg.edg37 =l_edc.edc37  
      LET l_edg.edg38 =l_edc.edc38  
      LET l_edg.edg39 =l_edc.edc39  
      LET l_edg.edg40 =l_edc.edc40
      #MOD-E40116-Start-Add
      IF cl_null(l_edg.edg40) THEN
         LET l_edg.edg40 =0
      END IF     
      #MOD-E40116-End-Add
      LET l_edg.edg41 =l_edc.edc41  
      LET l_edg.edg42 =l_edc.edc42  
      LET l_edg.edg43 =l_edc.edc43  
      LET l_edg.edg45 =l_edc.edc45  
      LET l_edg.edg49 =l_edc.edc49  
     #LET l_edg.edg50 =l_edc.edc50  #FUN-A80060
     #LET l_edg.edg51 =l_edc.edc51  #FUN-A80060
      LET l_edg.edg52 =l_edc.edc52  
      LET l_edg.edg53 =l_edc.edc53  
      LET l_edg.edg54 =l_edc.edc54  
      LET l_edg.edg55 =l_edc.edc55  
      LET l_edg.edg56 =l_edc.edc56  
      LET l_edg.edg57 =l_edc.edc57  
      LET l_edg.edg58 =l_edc.edc58  
      LET l_edg.edg59 =l_edc.edc59  
      LET l_edg.edg60 =l_edc.edc60  
      LET l_edg.edg61 =l_edc.edc61  
      LET l_edg.edg62 =l_edc.edc62  
      LET l_edg.edg63 =l_edc.edc63  
      LET l_edg.edg64 =l_edc.edc64  
      LET l_edg.edg65 =l_edc.edc65  
      LET l_edg.edg66 =l_edc.edc66  
      LET l_edg.edg67 =l_edc.edc67  
      LET l_edg.edgslk01=l_edc.edcslk01
      LET l_edg.edgslk02=l_edc.edcslk02
      LET l_edg.edgslk03=l_edc.edcslk03
      LET l_edg.edgslk04=l_edc.edcslk04 
      LET l_edg.edgconf='N'
      LET l_edg.edguser=g_user
      LET l_edg.edgdate=g_today
      LET l_edg.edgacti='Y'
      LET l_edg.edgmodu=null
      LET l_edg.edggrup=g_grup
      LET l_edg.edgorig=g_grup
      LET l_edg.edgoriu=g_user
      
      SELECT sfb05,sfb06,sfb13,sfb15                  #FUN-A80060
        INTO l_edg.edg031,l_edg.edg11,l_sfb13,l_sfb15 #FUN-A80060  
        FROM sfb_file
       WHERE sfb01=p_sfd03
       #FUN-A80060--begin--add----------------
      IF NOT cl_null(l_sfb13) AND cl_null(l_sfb15) THEN
         LET w_day=(l_edg.edg14+l_edg.edg13)/86400 +0.99    # 一天86400秒
         CALL s_wknxt(l_sfb13,w_day) RETURNING w_flag,w_edate
         IF w_day != 0 THEN
            CALL s_wknxt(w_edate,-1) RETURNING w_flag,p_duedat
         ELSE
            CALL s_wknxt(w_edate,0) RETURNING w_flag,p_duedat
         END IF
         LET l_edg.edg50=l_sfb13  LET l_edg.edg51=p_duedat
      ELSE
         LET w_day=((l_edg.edg14+l_edg.edg13)/86400 +0.99)*-1    # 一天86400秒
         CALL s_wknxt(l_sfb15,w_day) RETURNING w_flag,w_bdate
         IF w_day != 0 THEN
            CALL s_wknxt(w_bdate,1) RETURNING w_flag,p_strtdat
         ELSE
            CALL s_wknxt(w_bdate,0) RETURNING w_flag,p_strtdat
         END IF
         LET l_edg.edg50=p_strtdat  LET l_edg.edg51=l_sfb15
      END IF
      #FUN-A80060--end--add--------------------
      INSERT INTO edg_file VALUES l_edg.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('ins edg',SQLCA.sqlcode,1)
         LET g_success='N' EXIT FOREACH
      END IF          
    END FOREACH
END FUNCTION    
                
FUNCTION p304_ins_edh(p_sfd01,p_sfd02,p_edc01,p_edc02)
DEFINE p_sfd01    LIKE sfd_file.sfd01
DEFINE p_sfd02    LIKE sfd_file.sfd02
DEFINE p_edc01    LIKE edc_file.edc01
DEFINE p_edc02    LIKE edc_file.edc02
DEFINE l_edh      RECORD LIKE edh_file.*
DEFINE l_edd      RECORD LIKE edd_file.*

  DECLARE edd_cs CURSOR FOR
     SELECT * FROM edd_file WHERE edd01=p_edc01 AND edd011=p_edc02 ORDER BY edd013,edd02
  FOREACH edd_cs INTO l_edd.*
    LET l_edh.edh01=p_sfd01
    LET l_edh.edh011=p_sfd02
    LET l_edh.edh013=l_edd.edd013
    LET l_edh.edh02 =l_edd.edd02 
    LET l_edh.edh03 =l_edd.edd03 
    LET l_edh.edh04 =l_edd.edd04 
    LET l_edh.edh05 =l_edd.edd05 
    LET l_edh.edh06 =l_edd.edd06 
    LET l_edh.edh07 =l_edd.edd07 
    LET l_edh.edh08 =l_edd.edd08 
    LET l_edh.edh081=l_edd.edd081
    LET l_edh.edh082=l_edd.edd082
    LET l_edh.edh09 =l_edd.edd09 
    LET l_edh.edh10 =l_edd.edd10 
    LET l_edh.edh11 =l_edd.edd11 
    LET l_edh.edh13 =l_edd.edd13 
    LET l_edh.edh14 =l_edd.edd14 
    LET l_edh.edh15 =l_edd.edd15 
    LET l_edh.edh16 =l_edd.edd16 
    LET l_edh.edh17 =l_edd.edd17 
    LET l_edh.edh18 =l_edd.edd18 
    LET l_edh.edh19 =l_edd.edd19 
    LET l_edh.edh20 =l_edd.edd20 
    LET l_edh.edh21 =l_edd.edd21 
    LET l_edh.edh22 =l_edd.edd22 
    LET l_edh.edh23 =l_edd.edd23 
    LET l_edh.edh24 =l_edd.edd24 
    LET l_edh.edh25 =l_edd.edd25 
    LET l_edh.edh26 =l_edd.edd26 
    LET l_edh.edh27 =l_edd.edd27 
    LET l_edh.edh28 =l_edd.edd28 
    LET l_edh.edh29 =l_edd.edd29 
    LET l_edh.edh30 =l_edd.edd30 
    LET l_edh.edh31 =l_edd.edd31 
    LET l_edh.edh33 =l_edd.edd33 
    LET l_edh.edh10_fac=l_edd.edd10_fac
    LET l_edh.edh10_fac2=l_edd.edd10_fac2
    LET l_edh.edhcomm=l_edd.eddcomm
    LET l_edh.edhmodu=NULL
    LET l_edh.edhdate=g_today
    INSERT INTO edh_file VALUES l_edh.*
    IF SQLCA.sqlcode THEN
       CALL cl_err('ins edh',SQLCA.sqlcode,1)
       LET g_success='N' EXIT FOREACH
    END IF 
  END FOREACH
END FUNCTION
#FUN-A80054--end--add------------------------
#No.FUN-9C0072 精簡程式碼
 
FUNCTION p304_chk_edb(p_edc01,p_new_part,p_sfb06)
DEFINE l_cnt      LIKE type_file.num5
DEFINE p_edc01    LIKE edc_file.edc01
DEFINE p_sfb06    LIKE sfb_file.sfb06
DEFINE p_new_part LIKE ima_file.ima01
 
  LET g_errno=''
  LET l_cnt=0
  IF NOT cl_null(p_edc01) AND NOT cl_null(p_new_part) AND
     NOT cl_null(p_sfb06) THEN
     SELECT COUNT(*) INTO l_cnt FROM eda_file,edb_file
      WHERE eda01=p_edc01
        AND edb03=p_new_part
        AND edb04=p_sfb06
        AND eda01=edb01 AND edaconf='Y'
     IF l_cnt = 0 THEN
        LET g_errno='aec-057'
     END IF
  END IF
END FUNCTION

#CHI-C50029 str add-----
FUNCTION p304_chk_sfb39(l_sfb01)
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_cnt2     LIKE type_file.num5
DEFINE l_sfb01    LIKE sfb_file.sfb01
DEFINE l_sfb01_2  LIKE sfb_file.sfb01

  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt FROM sfa_file
   WHERE sfa01  = l_sfb01
    #AND sfa11 != 'E' AND sfa11 !='X'    #20180607 mark      
     AND sfa11 = 'E'                     #20180607 modify
  #IF l_cnt = 0 THEN                     #20180607 mark
  IF l_cnt > 0 THEN                      #20180607 modify
    UPDATE sfb_file SET sfb39='2' WHERE sfb01=l_sfb01
  END IF

  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt FROM sfb_file
   WHERE sfb86  = l_sfb01

  IF l_cnt>0 THEN
    DECLARE p304_cur1 CURSOR FOR
       SELECT sfb01 FROM sfb_file WHERE sfb86  = l_sfb01

    FOREACH p304_cur1 INTO l_sfb01_2
       LET l_cnt2=0
       SELECT COUNT(*) INTO l_cnt2 FROM sfa_file
        WHERE sfa01  = l_sfb01_2
         #AND sfa11 != 'E'    #20180607 mark
          AND sfa11  = 'E'    #20180607 modify
      #IF l_cnt2 = 0 THEN     #20180607 mark
       IF l_cnt2 > 0 THEN     #20180607 modify
         UPDATE sfb_file SET sfb39='2' WHERE sfb01=l_sfb01_2
       END IF
    END FOREACH
  END IF

END FUNCTION
#CHI-C50029 end add-----

#TQC-C70002--add--str--
FUNCTION p304_sub_no(p_no,p_min_no,p_max_no)
   DEFINE   p_no        LIKE sfb_file.sfb01
   DEFINE   p_min_no    LIKE sfb_file.sfb01      
   DEFINE   p_max_no    LIKE sfb_file.sfb01       
   DEFINE   l_sub_no    LIKE sfb_file.sfb01
   DEFINE   l_min_no    LIKE sfb_file.sfb01
   DEFINE   l_max_no    LIKE sfb_file.sfb01        
   DEFINE   l_n         LIKE type_file.num5
   DEFINE   l_sql       STRING

   LET l_min_no = p_min_no
   LET l_max_no = p_max_no
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM sfb_file
    WHERE sfb86 = p_no
   IF l_n = 0 THEN RETURN l_min_no,l_max_no END IF 

   LET l_sql = "SELECT sfb01 FROM sfb_file ",
           " WHERE sfb86 = '", p_no ,"' "
   PREPARE q_sfb_prepare FROM l_sql
   #M001 171117 By TSD.Nic -----(S)
   #DECLARE sfb_curs CURSOR FOR q_sfb_prepare 
   DECLARE sfb_curs CURSOR WITH HOLD FOR q_sfb_prepare 
   #M001 171117 By TSD.Nic -----(E)
   FOREACH sfb_curs INTO l_sub_no
      IF SQLCA.sqlcode THEN
         RETURN l_min_no,l_max_no
      END IF
      IF cl_null(l_max_no) THEN LET l_max_no = ' ' END IF    
      IF l_sub_no > l_max_no THEN LET l_max_no = l_sub_no END IF
      IF cl_null(l_min_no) THEN LET l_min_no = l_max_no END IF    
      IF l_sub_no < l_min_no THEN LET l_min_no = l_sub_no END IF
      #M001 171115 By TSD.Nic -----(S)
      #母工單只會有一圈不用遞迴
      #CALL p304_sub_no(l_sub_no,l_min_no,l_max_no) RETURNING l_min_no,l_max_no  #遞歸查詢各級子工單
      LET g_wos = g_wos,"','",l_sub_no CLIPPED

      #M012 180129 By TSD.Nic -----(S)
      #CALL i301sub_firm1_chk(l_sub_no,FALSE)  #CALL原確認的check段
      #IF g_success = 'Y' THEN
      #   CALL i301sub_firm1_upd(l_sub_no,"confirm",FALSE)  #CALL原確認的update段
      #END IF
      #M012 180129 By TSD.Nic -----(E)
      #M001 171115 By TSD.Nic -----(E)
   END FOREACH
   RETURN l_min_no,l_max_no
END FUNCTION
#TQC-C70002--add--end--

#TQC-C70104--add--str--
FUNCTION p304_set_entry_b()
   CALL cl_set_comp_entry("sfb06",TRUE)
END FUNCTION

FUNCTION p304_set_no_entry_b(p_i)
   DEFINE p_i       LIKE type_file.num5
   DEFINE i         LIKE type_file.num5

   LET i = p_i
   IF new[i].sfb93 <> 'Y' THEN
      CALL cl_set_comp_entry("sfb06",FALSE)
   END IF
END FUNCTION

FUNCTION p304_set_no_required_b()
   CALL cl_set_comp_required("sfb06,new_no",FALSE)
   IF g_aaz.aaz90 = 'Y' THEN
      CALL cl_set_comp_required("costcenter",FALSE)
   END IF
END FUNCTION

FUNCTION p304_set_required_b(p_i)
   DEFINE p_i       LIKE type_file.num5
   DEFINE i         LIKE type_file.num5

   LET i = p_i
   IF new[i].x = 'Y' THEN
      IF new[i].sfb93 = 'Y' THEN
         CALL cl_set_comp_required("sfb06",TRUE)
      END IF
      IF g_aaz.aaz90 = 'Y' THEN
         CALL cl_set_comp_required("costcenter",TRUE)
      END IF
      CALL cl_set_comp_required("new_no",TRUE)
   END IF 
END FUNCTION
#TQC-C70104--add--end--

#DEV-D30026 add str-----------
FUNCTION p304_barcode_chk(p_new_part)
   DEFINE p_new_part LIKE ima_file.ima01

   LET l_barcode_yn = 'N'
   SELECT ima930 INTO l_barcode_yn
   FROM ima_file
   WHERE ima01 = p_new_part
END FUNCTION
#DEV-D30026 add end-----------

#M001 171116 By TSD.Nic -----(S)
#pmk default
FUNCTION p304_pmk_default()
   LET g_pmk.pmk01 = NULL
   LET g_pmk.pmk04 = g_today               #請購日期

   SELECT azn02,azn04 INTO g_pmk.pmk31,g_pmk.pmk32 FROM azn_file
    WHERE azn01 = g_pmk.pmk04
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","azn_file",g_pmk.pmk04,"","mfg0027","","",1)
      LET g_pmk.pmk04 = ''
      DISPLAY BY NAME g_pmk.pmk04
   END IF
   CALL s_get_bookno(YEAR(g_pmk.pmk04))
        RETURNING g_flag,g_bookno1,g_bookno2

   LET g_pmk.pmk02 = 'REG'       #單號性質
   LET g_pmk.pmk03 = '0'
   LET g_pmk.pmk12 = g_user
   LET g_pmk.pmk13 = g_grup
   LET g_pmk.pmk18 = 'N'
   LET g_pmk.pmk25 = '0'         #開立
   LET g_pmk.pmk27 = g_today
   LET g_pmk.pmk40 = 0           #總金額
   LET g_pmk.pmk401= 0           #總金額
   LET g_pmk.pmk43 = 0           #稅率
   LET g_pmk.pmk45 = 'Y'         #可用
   LET g_pmk.pmkdays = 0         #簽核天數
   LET g_pmk.pmkprno = 0         #列印次數
   LET g_pmk.pmksmax = 0         #己簽順序
   LET g_pmk.pmksseq = 0         #應簽順序
   #CALL s_pmksta('pmk',g_pmk.pmk25,g_pmk.pmk18,g_pmk.pmkmksg) RETURNING g_sta
   LET g_pmk.pmk05   =''
   LET g_pmk.pmk12   = g_user               #請購員
   LET g_pmk.pmkplant = g_plant
   LET g_pmk.pmklegal = g_legal
   LET g_pmk.pmk46 = '1'
   LET g_pmk.pmk47 = g_plant
   LET g_pmk.pmk50 = null
   LET g_pmk.pmk48 = TIME
   LET g_pmk.pmkacti ='Y'                   #有效的資料
   LET g_pmk.pmkuser = g_user
   LET g_pmk.pmkoriu = g_user
   LET g_pmk.pmkorig = g_grup
   LET g_data_plant = g_plant
   LET g_pmk.pmkgrup = g_grup               #使用者所屬群
   LET g_pmk.pmkcrat = g_today           #資料創建日
   LET g_pmk.pmkplant = g_plant
   LET g_pmk.pmklegal = g_legal
   LET g_pmk.pmkud03 = 'N'               #20190814 BPM是否加簽
END FUNCTION

#INSERT INTO pmk_file
FUNCTION p304_ins_pmk()
   DEFINE  l_smyauno     LIKE smy_file.smyauno
   DEFINE  l_smyapr      LIKE smy_file.smyapr
   DEFINE  l_smy59       LIKE smy_file.smy59
   DEFINE  li_result     LIKE type_file.num5
   DEFINE  l_slip        LIKE smy_file.smyslip

   LET l_slip = s_get_doc_no(g_pmk.pmk01)
   LET l_smyauno = ''
   LET l_smyapr  = ''
   LET l_smy59   = ''
   SELECT smyauno,smyapr,smy59
     INTO l_smyauno,l_smyapr,l_smy59
     FROM smy_file
    WHERE smyslip = l_slip

   IF l_smyauno='Y' THEN
   CALL s_auto_assign_no("apm",g_pmk.pmk01,g_pmk.pmk04,"1","pmk_file","pmk01","","","") RETURNING li_result,g_pmk.pmk01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
   END IF
   IF cl_null(g_pmk.pmkmksg) THEN
      LET  g_pmk.pmkmksg = l_smyapr
   END IF
   IF cl_null(g_pmk.pmkmksg) THEN
      LET  g_pmk.pmkmksg = 'N'
   END IF

  IF cl_null(g_pmk.pmk46) THEN
     LET g_pmk.pmk46 = '1'
  END IF

   IF l_smy59 = 'Y' AND cl_null(g_pmk.pmk22) THEN
      LET g_pmk.pmk22 = g_aza.aza17
      LET g_pmk.pmk42 = 1
   END IF

   INSERT INTO pmk_file VALUES(g_pmk.*)     #DISK WRITE
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pmk_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   ELSE
      IF NOT s_axm_memo_ins_pmo(g_pmk.pmk01,g_pmk.pmk09,'0') THEN
         LET g_success = 'N'
         RETURN
      END IF

      CALL cl_flow_notify(g_pmk.pmk01,'I')
      SELECT pmk01 INTO g_pmk.pmk01 FROM pmk_file
       WHERE pmk01 = g_pmk.pmk01
   END IF
END FUNCTION

#INSERT INTO pnl_file
FUNCTION p304_ins_pnl()
   DEFINE l_maxd       LIKE sfb_file.sfb13
   DEFINE l_mind       LIKE sfb_file.sfb13
   DEFINE l_sql        STRING
  #DEFINE l_wc         LIKE type_file.chr1000   #20180502 mark
   DEFINE l_wc         LIKE pnl_file.pnl02      #20180502 modify

   LET l_maxd = ''
   LET l_mind = ''
   LET l_sql = "SELECT MAX(sfb13),MIN(sfb13) ",
               #M012 180129 By TSD.Nic -----(S)
               #"  FROM sfb_file ",
               #" WHERE ",g_wos CLIPPED
               "  FROM sfb_file,sfa_file ",
               " WHERE sfa01 = sfb01 ",
               "   AND ",g_wos CLIPPED
               #M012 180129 By TSD.Nic -----(E)
   PREPARE dates_exe FROM l_sql
   EXECUTE dates_exe INTO l_maxd,l_mind

   LET l_wc = g_wos

   DELETE FROM pnl_file WHERE pnl01 = g_pmk.pmk01
   IF SQLCA.sqlcode THEN END IF
   INSERT INTO pnl_file(pnl01,pnl02,pnl03,pnl04,pnl05,
                        pnl06,pnl07,pnl08,pnl09,pnl10,pnl11,pnluser,pnlplant,pnllegal,pnloriu,pnlorig)
                 VALUES(g_pmk.pmk01,l_wc,l_mind,l_maxd,
                        #M001 180109 By TSD.Jin--start--
                        #'Y','Y','Y','Y',
                        #'Y','Y','Y',g_user,g_plant,g_legal, g_user, g_grup)
                        'N','N','N','N',
                        'N','N','N',g_user,g_plant,g_legal, g_user, g_grup)
                        #M001 180109 By TSD.Jin--end----
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pnl_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
#M001 171116 By TSD.Nic -----(E)
