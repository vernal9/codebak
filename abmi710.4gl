# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: abmi710.4gl
# Descriptions...: 多主件ECN資料維護作業
# Date & Author..: 97/07/20 By Roger
# Modify.........: 03/03/10 By Carol For bugno:6845
# Modify.........: No:7827 03/08/18 By Mandy ECN確認, update bmb_file 時應以ECN單頭生效日做為舊料的失效日
# Modify.........: No:7836 03/08/19 By Mandy ECN輸入時應check底數不可不輸入,可default 1
# Modify.........: No:7840 03/08/19 By Mandy ECN '取代'時, ECN單號應僅記錄於新料即可
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: No:7826 03/08/27 By Mandy 單身 ^Y 的細項 gui 畫面, 料換算率輸入(修)後, 再按mouse 到工程圖號欄其料換算率的修改後值, 會恢復.並建議, 增加庫存單位顯示
# Modify.........: No:7958 03/08/27 By Mandy abmi710b.per欄位插件位置bmy13應同abmi600的bmb13為NOENTRY
# Modify.........: No:9810 04/07/30 By ching 已phase料件應不可輸入bom單身
# Modify.........: No:9806 04/07/30 By ching 增加"工單展開選項"可修改,並defualt
# Modify.........: No.MOD-480185 04/07/30 By ching add  "本張異動單據" 列印
# Modify.........: No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-490380 04/09/23 By Melody 使用插件位置自動擷取功能作業會自動跳出
# Modify.........: No.MOD-490438 04/09/24 ching 取代時以bmy27取得ima107,im147
# Modify.........: No.MOD-4A0046 04/10/05 ching 取代時bmy27 set required
# Modify.........: No.MOD-4A0063 04/10/05 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0159 04/10/11 By Mandy i710_delall()中要多DELETE bmz_file
# Modify.........: No.FUN-4A0071 04/10/12 By Mandy 開窗原料號,指能show 次元件的料號
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4A0248 04/10/26 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0001 04/11/01 By Smapmin 主件料號開窗
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-4B0191 04/11/19 By Mandy 插件位置是否勾稽是由參數設定(aimi100)來決定, 'Y'則不match不可離開
# Modify.........: No.FUN-4C0054 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530342 05/04/01 By kim 主件料號開窗抓bma_file
# Modify.........: No.FUN-540045 05/04/21 By pengu TIPTOP & EasyFlow整合程式修改
# Modify.........: No.FUN-550040 05/05/13 By Echo 新增 TIPTOP 與 EasyFlow 整合
# Modify.........: No.FUN-550032 05/05/16 By wujie 單據編號加大
# Modify.........: No.FUN-550014 05/05/17 By Mandy 因特性BOM功能,增加bmz05,bmy29,bmy30
# Modify.........: No.MOD-560007 05/06/02 By Echo   重新定義整合FUN名稱
# Modify.........: No.FUN-560021 05/06/07 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560115 05/06/21 By kim 變異之元件料號開窗時有該料號,但輸入完後ENTER時出現錯誤訊息
# Modify.........: No.FUN-560201 05/06/23 By kim 單身出現細部資料時，誤差容許率請預設為 0。
# Modify.........: No.MOD-550047 05/06/17 By pengu  1. 子視窗 i710_b_more_w之誤差容許率預設值應帶0
                                                  # 2.AFTER FIELD bmy05應多增加bmy05值變更時方處理之判斷
# Modify.........: No.MOD-570304 05/08/26 By kim check在主件輸入修改的狀態時去check 此主件+單身元件 需存在BOM
# Modify.........: No.FUN-580120 05/09/10 By yiting 以 EF 為 backend engine,
#                                                   由 TIPTOP 處理前端簽核動作
# Modify.........: No.MOD-590172 05/09/14 By Claire 當系統參數sma118設為非"Y", 將確認主件BOM是否已發放放在料號輸入完畢之後
# Modify.........: NO.TQC-5C0004 05/12/14 BY yiting  action name應該為component_detail
# Modify.........: No.TQC-610068 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-630070 06/03/07 By Dido 流程訊息通知功能
# Modify.........: No.FUN-630044 06/03/16 By Alexstar 新增「申請人」欄位
# Modify.........: No.TQC-630177 06/03/17 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-640215 06/04/09 By Sarah 組成用量不可小於等於零
# Modify.........: No.MOD-640179 06/04/10 By cl   修改傳參的准確性
# Modify.........: No.MOD-640153 06/04/14 By pengu 多主件變更, 維護插件位置, 確認單據後, 回寫至bmb_file插件位置, 長度被截掉
# Modify.........: No.FUN-640241 06/04/25 By Echo 自動執行確認功能
# Modify.........: No.MOD-640577 06/04/27 By Claire g_rec_e+1 改至insert into之後 
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-640273 06/05/12 By Sarah 允許只key主件可確認
# Modify.........: No.TQC-660046 06/06/13 By douzh cl_err---->cl_err3
# Modify.........: No.TQC-660072 06/06/15 By Dido 補充TQC-630070
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.MOD-670125 06/08/07 By 若是元件單身資料未作異動更改，直接按"維護新元件明細資料"
                                  #          新元件明細資料的修改並未 UPDATE 回資料庫中
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-670023 06/09/19 By Sarah 當主件單身沒有輸入資料,元件單身就不可輸入,也不可做確認
# Modify.........: No.FUN-6A0002 06/10/19 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6A0007 06/11/01 By rainy 遇多元件時要先詢問是否更改
# Modify.........: No.FUN-6A0036 06/11/14 By rainy 判斷 ima140停產時，一要併判斷生效日ima1401
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能			
# Modify.........: No.MOD-6C0019 06/12/06 By pengu 單身異動別為"2:新增元件"，BOM項次不可輸入
# Modify.........: No.TQC-6C0055 06/12/11 By Sarah 當單身的變異別輸入的是2.新元件新增生效時,執行確認程式會當出
# Modify.........: No.TQC-6C0056 06/12/12 By Sarah 新增一張工程變異單之後,會進入列印狀態,右邊RingMenu缺少一個放棄的按鈕
# Modify.........: No.MOD-6B0077 06/12/13 By pengu 維護插件位置,確認單據後,回寫至bmb_file插件位置,長度被截掉
# Modify.........: No.MOD-710092 07/01/22 By pengu 1.新增時bmy20不可為NULL
# Modify.........: No.CHI-710048 07/02/27 By rainy 取代料順序移到變異元件之後
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-710072 07/03/13 By jamie 增加"主件查詢"action
# Modify.........: No.TQC-740043 07/04/10 By pengu 1.再確認段當g_success='N'應該加上ROLLBACK WORK
#                                                  2.確認段SQL應該加上"特性代碼"與"作業編號"的條件
# Modify.........: No.TQC-740079 07/04/13 By Ray 已審核的資料點刪除提示的信息有誤
# Modify.........: No.MOD-740078 07/04/22 By rainy 過單用
# Modify.........: No.TQC-740145 07/04/23 By johnray ECN單號不應該可以修改
# Modify.........: NO.TQC-740178 07/05/02 BY yiting 主件單身下條件查詢後，元件單身沒有一併秀出資料
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750146 07/05/25 By jamie 將一直顯示的訊息"依單別取號中..."移除
# Modify.........: No.MOD-770126 07/07/28 By pengu 新增單身時,Default組成用量欄位=1
# Modify.........: No.MOD-780142 07/08/20 By rainy SQL判斷式錯誤
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.TQC-7A0027 07/10/11 By lumxa 查詢時，輸入ECN單號，兩個單身都可以顯示信息，若只輸入主件料號進行查詢，元件單身不會顯示資料。 
# Modify.........: No.TQC-7A0040 07/10/15 By lumxa 在abmi710中，版本號可以維護成與原版本號一致
# Modify.........: No.MOD-7B0055 07/11/07 By Pengu 當新增元件單身資料未重新查詢下就再次進入元件單會出現重複的錯誤訊息
# Modify.........: No.MOD-780260 07/11/26 By Pengu 輸入主件編號時應判斷是否存在bmb_file中
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-820027 08/02/20 By xiaofeizhu 資料中心功能
# Modify.........: NO.FUN-840018 08/04/07 BY yiting 增加一個頁面放置清單資料
# Modify.........: NO.FUN-840033 08/04/17 BY Yiting 存在相同主件+元件且未確認單據，在輸入元件資料時要予以控管
# Modify.........: No.MOD-840284 08/04/20 By Pengu 按確認未有反應也沒有show錯誤訊息
# Modify.........: No.FUN-840138 08/04/21 By xiaofeizhu 資料中心功能增加bmz02的管控
# Modify.........: NO.MOD-840420 08/04/24 by yiting 確認時要先檢查是否有其它單據有相同的主件+元件資料未確認
# Modify.........: NO.MOD-840426 08/04/24 BY Yiting 增加委外代買欄位處理
# Modify.........: No.TQC-830036 08/05/22 By xiaofeizhu 增加日期錄入時“生效日期”不可小于“錄入日期”的警告
# Modify.........: No.FUN-850156 08/06/05 By Sherry  元件修改,取代功能改善
# Modify.........: No.TQC-860021 08/06/10 By Sarah DISPLAY ARRAY段漏了about功能
# Modify.........: No.FUN-860074 08/06/19 By Sherry  考慮項次不輸的處理
# Modify.........: No.MOD-840026 08/07/04 By Pengu 若是修改舊元件時bmy23不default為0
# Modify.........: No.MOD-840645 08/07/10 By Pengu 開放在新增元件時可以指定BOM項次的功能
# Modify.........: No.MOD-840100 08/07/13 By Pengu 維護新元件明細" 跳出視窗但是不能維護
# Modify.........: No.TQC-850020 08/07/15 By lala  第二個單身在填充時 如果bmz_file中有多比資料的話，會重復顯示
# Modify.........: No.FUN-860044 08/07/25 By sherry 增加單頭action "維護多插件位置資料"
# Modify.........: No.CHI-880031 08/09/09 By xiaofeizhu 查出資料后,應該停在第一筆資料上,不必預設是看資料清單,有需要瀏覽,再行點選
# Modify.........: No.MOD-890184 08/09/18 By claire 修改發料單位時, 重新計算bmb10_fac2發料單位對成本單位換算率
# Modify.........: No.CHI-890025 08/09/19 By claire 單身before input控制欄位開關應放在before row
# Modify.........: No.TQC-890018 08/10/03 By claire 確認時更新bma_file,bmadate,bmamodu
# Modify.........: No.MOD-8B0135 08/11/13 By clover abmi710b增加欄位bmy34 
# Modify.........: No.TQC-8C0042 08/12/24 By clover l_sql語法錯誤更正
# Modify.........: No.CHI-8C0049 08/12/26 By claire 變更後的元件不可以主件相同
# Modify.........: No.MOD-910108 09/01/17 By claire 變更元件於BOM存在大於此生效日的其他設變資料則不可新增
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING   
# Modify.........: No.MOD-920095 09/02/09 By chenyu i710_s2()中bmd_file不需要新增
# Modify.........: No.MOD-920313 09/02/24 By chenyu i710_s2()中,bmy04如果有值，應該直接給bmb02
# Modify.........: No.CHI-930005 09/03/03 By jan if bmy03='4' 則 bmy06/07為必輸，反之則不為必輸
# Modify.........: No.CHI-930006 09/03/03 By jan 當bmy03 新值不等於舊值時，將bmy05的值清空
# Modify.........: No.MOD-930124 09/03/11 By jan insert/update狀態欄位賦值
# Modify.........: No.CHI-930025 09/03/12 By jan 單身CONSTRUCT增加bmy16,bmy30.bmy34,bmy22
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.MOD-950055 09/05/07 By lutingting g_msg后加CLIPPED
# Modify.........: No.MOD-930230 09/05/25 By Pengu 執行確認時程式會擋掉
# Modify.........: No.MOD-940061 09/05/25 By Pengu ima105是"是否為軟體物件", 對到bmb_file 應為bmb27
# Modify.........: No.MOD-950247 09/05/25 By mike 1.在第一單身的主件欄位判斷主件是否存在BOM且使有效的。                             
#                                                 2.單頭跳單身一或是執行整批產生主件action時會開abmi710a視窗下主件QBE，             
#                                                   當QBE下完條件按確定會去撈bma_file將相關的主件產生到單身一，請再撈取             
#                                                   bma_file的SQL加上有效碼判斷     
# Modify.........: No.MOD-960234 09/07/01 By mike 在INSERT INTO bmz_file之后多家上SQLCA.SQLERRD[3]=0的判斷
# Modify.........: No.CHI-960004 09/07/26 By jan 變異碼 欄位 加選項5：替代
# Modify.........: No.FUN-980001 09/08/06 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980076 09/08/13 By Smapmin 圖示未顯示出來
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-980075 09/09/09 By mike ECN變易方式選擇4.取代時，應控管變異元件料號不可與新元件料號相同                   
# Modify.........: NO.FUN-990069 09/10/12 By baofei 增加子公司可新增資料的檢查  
# Modify.........: No:MOD-9A0182 09/11/06 By Pengu ECN確認時無法將資料更新到bmb_file
# Modify.........: No:MOD-990218 09/11/10 By Pengu 調整IF NOT cl_null(b_bmz.bmz05) THEN的判斷
# Modify.........: No:TQC-9B0163 09/11/19 By sherry 新增時，bmy34賦初值
# Modify.........: No:CHI-960045 09/11/26 By sabrina 單身的備註欄位也開放可維護
# Modify.........: No:TQC-970021 09/11/26 By sabrina 在INSERT bmz_file須判斷是否重複，若重複則不允許產生
# Modify.........: No:MOD-970032 09/11/26 By sabrina 元件單身輸入時應判斷變更料後是否存在主件單身中的主件BOM中
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No:FUN-950045 10/01/05 By jan 撈取或檢查bmr_file時，多加bmr_file.確認碼='Y'的條件
# Modify.........: No:MOD-A10114 10/01/20 By Pengu 做替代時，ECN變更單單身組成用量應代表是替代量
# Modify.........: No.CHI-9C0054 10/02/25 By vealxu 新增申請部門欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30027 10/03/08 by destiny 录入ece单号时只能录审核过的资料
# Modify.........: No.TQC-A30032 10/03/08 by destiny 进入abmi710a后元件料号的开窗应和已录入的主件相关
# Modify.........: No.TQC-A30040 10/03/09 By Carrier 1.取代/替代时,更新bmb项次错误;2.修改时,更新原bmb失效日期失败
# Modify.........: No.TQC-A30033 10/03/10 by destiny 管控在ecr单号有值时主件料号只能输入ecr的主件资料
# Modify.........: No:CHI-A30011 10/03/18 By Sarah 修正CHI-930005,取消bmy06/bmy07兩欄位必輸的限制
# Modify.........: No:MOD-A30170 10/03/30 By Summer bmx05開窗改成q_bmr1
# Modify.........: No:MOD-A40116 10/04/21 By Sarah 改以輸入日期(bmx02)為單號編碼原則
# Modify.........: No:FUN-A60008 10/06/24 By destiny 增加平行工艺逻辑      
# Modify.........: No:CHI-A60028 10/06/25 By Summer 增加欄位bmy35,ECN變更單確認時,將bmy35寫入bmb14裡    
# Modify.........: No:FUN-A60083 10/06/25 By destiny 修改平行工艺逻辑      
# Modify.........: No:MOD-A70152 10/07/20 By Sarah bmy08不應拿ima562來當預設值
# Modify.........: No:FUN-A70125 10/07/28 By lilingyu 平行工藝
# Modify.........: No:MOD-A80018 10/08/04 By sabrina 更改單身變異別資料時，修改前非"2.新增"要改為"2.新增"時不會呼叫i710_b_more() 
# Modify.........: No:MOD-A80105 10/08/13 By sabrina 單身元件有做異動時要重帶"工單開立展開選項"、"發料單位"……等欄位 
# Modify.........: No.FUN-950057 10/08/25 By vealxu gew03 = '1'時,確認時自動拋轉
# Modify.........: No:MOD-A80227 10/08/27 By sabrina 在i710_b_more()裡修改完後若按"放棄"時，值並沒有恢復 
# Modify.........: No:CHI-A80054 10/09/29 By Summer 加上abm-205訊息的檢查
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AB0058 10/11/08 By yinhy 倉庫權限使用控管修改
# Modify.........: No:MOD-9C0004 10/11/26 By sabrina 取替代時BOM項次應是目前最大在加上sma19
# Modify.........: No.TQC-AB0240 10/12/02 By vealxu 建議在主件單身輸入時若主件料號不可變更點擊退出後應自動將單頭及單身資料刪除
# Modify.........: No:MOD-AC0029 10/12/03 By sabrina 當bmy03='4'時，bmy16只顯示"0"和"1"的選項
# Modify.........: No:TQC-AC0175 10/12/14 By jan 調整程式顯示名稱
# Modify.........: No.TQC-AC0173 10/12/14 By vealxu 列印時加傳bom類別欄位bmx50
# Modify.........: No.TQC-AC0161 10/12/15 By jan abmi710b拿掉bmy34
# Modify.........: No.TQC-AC0171 10/12/16 By vealxu 當變更別='舊元件修改'，輸完單身元件料號後，bmy35沒自動帶出舊值
# Modify.........: No:TQC-AC0300 10/12/20 By zhangll 修改固定損耗量,损耗批量
# Modify.........: No:TQC-AC0305 10/12/21 By destiny 輸入完主件單后身會報"未輸入單身資料，故取消單頭" 的錯
# Modify.........: No.FUN-AC0075 11/01/07 By vealxu brb081,brb082確認時沒有更新
# Modify.........: No:MOD-B10090 11/01/12 By sabrina FUNCTION i710_list_fill()若是背景執行則不做DISPLAY ARRAY
# Modify.........: No.FUN-B30171 11/03/29 By destiny 新增主件单身料号开窗时允许选择多个料号，并将所选料号插入到单身中
# Modify.........: No.TQC-B40175 11/04/26 By destiny 已核准未確認時畫面沒有“核”字樣
# Modify.........: No:MOD-B40163 11/05/10 By vampire AFTER FIELD 
# Modify.........: No:MOD-B50058 11/05/11 By vampire 若組成用量為null時，則給值"1"
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B50157 11/05/18 By zhangll 變異碼為”5替代”時，必須為選項2或5，但取替代特性下拉沒有‘2’和‘5’選項
# Modify.........: No.MOD-B70036 11/07/06 By sabrina 組成用量及底數抓取的值有誤
# Modify.........: No:MOD-B70147 11/07/17 By Vampire 如果 g_bmy[l_ac].bmy03='2' 時才讓 g_bmy[l_ac].bmy06=1
# Modify.........: No.MOD-B70148 11/07/18 By sabrina 抓組成用量及底數應多判斷三個值
# Modify.........: No.FUN-B70022 11/07/20 By Abby mark多餘程式段(for EF整合)
# Modify.........: No.MOD-B80208 11/08/19 By lilingyu 取消單身顯示最大筆數限制
# Modify.........: No:FUN-B80071 11/08/22 By Abby    調整EF自動確認功能
# Modify.........: No:TQC-BA0079 11/10/18 By houlia  為回收料的時候bmy06小於零
# Modify.........: No:FUN-BB0086 11/12/08 By tanxc 增加數量欄位小數取位
# Modify.........: No.CHI-C10032 12/02/03 By ck2yuan 新增g_bmy_o存修改後的值,避免畫面上的值一直被清空
# Modify.........: No.CHI-C10034 12/02/03 By ck2yuan 同一張ECN單身不可以輸入相同元件
# Modify.........: No:FUN-C20011 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:MOD-C20093 12/02/09 By ck2yuan 在i710_b_more()增加計算bmy_fac2
# Modify.........: No:FUN-C20048 12/02/10 By tanxc 增加數量欄位小數取位
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into bmd_file之前給bmd11賦值
# Modify.........: No:MOD-C20082 12/02/17 By bart 還原TQC-AB0240,再針對TQC-AB0240原先的問題做修改
# Modify.........: No:MOD-C20195 12/02/28 By Elise 變異別為替代時，被替代料與替代料不應相同
# Modify.........: No:MOD-C20154 12/03/02 By ck2yuan 在確認段檢查新增元件是否有維護元件明細資料
# Modify.........: No:CHI-C10023 12/03/08 By ck2yuan 依變異別,修改插件數量判斷
# Modify.........: No:MOD-C40150 12/04/19 By ck2yuan 當bmy03='5'時，bmy16應顯示選項只有2,5 不然會有abm-037錯誤
# Modify.........: No:CHI-C40010 12/04/23 By ck2yuan 取替代時,作業編號未輸入即表示不異動
# Modify.........: No:TQC-C50024 12/05/08 By lixh1 AFTER FIELD bmz02 后調用i710_insbmz()將資料插入數據量,否則手動輸入主件料號時會報錯
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30035 12/06/13 By bart 增加7.規格替代 9.配方替代
# Modify.........: No.MOD-BA0200 12/06/15 By ck2yuan i710_s()回來後要在多判斷g_success
# Modify.........: No.MOD-B90044 12/06/18 By Elise 若b_bmy.bmy06、b_bmy.bmy07為null時則不可以將值給bmb06、bmb07
# Modify.........: No.TQC-C60179 12/06/25 By lixh1 更改提示信息和臨時表的定義
# Modify.........: No.FUN-C30119 12/06/28 By bart qbe主件編號，帶出符合之主件供挑選，將選擇之資料寫入第一單身
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:TQC-C80066 12/08/10 By chenjing 當bmy03='1’時，bmy16,bmy35,bmy30不可以輸
# Modify.........: No:TQC-C80106 12/08/22 By chenjing  修改第一單身料件特性勾稽關係
# Modify.........: No:TQC-C80130 12/09/03 By chenjing  修改AFERT ROW后報錯信息
# Modify.........: No:CHI-C20060 12/09/18 By bart 類別增加替代變更，變更替代量，替代只能打替代量，回寫abmi604
# Modify.........: No:MOD-CB0147 12/11/23 By Elise 無單身不可確認
# Modify.........: No:CHI-CA0035 13/01/28 By Elise 調整參數避免串查錯誤,g_argv1:固定參數 g_argv2:單號 g_argv3:執行功能
# Modify.........: No:MOD-D10278 13/01/30 By bart bmy16只能輸入1時直接給值
# Modify.........: No:CHI-980001 13/02/01 By Alberti 原件失效時，應將對應的替代資料也失效
# Modify.........: No:CHI-B40031 13/02/01 By Alberti (1)特性代碼改為開窗型態
#                                                    (2)單身的元件在輸入時會依特性代碼不同而顯示不同的元件資料
# Modify.........: No:MOD-D10285 13/02/18 By bart 增加"查詢新元件明細資料"
# Modify.........: No:CHI-D10013 13/02/19 By Alberti 將ECR單號(bmx05)之控卡移除
# Modify.........: No:CHI-D20010 13/02/19 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更
# Modify.........: No:MOD-D30036 13/03/06 By Alberti 修改after field bmy03 及 after field bmy35
# Modify.........: No:MOD-D30061 13/03/07 By bart  bmz02為空則 不控卡 abm-742
# Modify.........: No:CHI-D40002 13/04/02 By bart icd行業別需一併修改icm_file
# Modify.........: No:MOD-D40044 13/04/09 By bart 元件被取代為另一顆元件後，已失效元件的取替代資料應該要一起失效
# Modify.........: No:TQC-D40054 13/04/22 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查 
# Modify.........: No:MOD-D50159 13/05/20 By bart 按放棄時則不更新資料修改者
# Modify.........: No:FUN-D60005 13/06/03 By yangtt 開放【列印】
# Modify.........: No:FUN-D40032 13/07/10 By lujh 取消作廢需控卡關帳日期
# Modify.........: No:FUN-D60015 13/07/24 By lujh 資料清單和主頁面分開匯出excel
# Modify.........: No:FUN-D70103 13/07/29 By Alberti "取消作廢"時增加控卡
# Modify.........: No:FUN-D80022 13/09/02 By fengrui 鞋服功能改善
#                                服饰版新增同款式不同颜色、尺寸使用单一料号进行管理的功能，
#                                即一个款式就是一个料号，颜色、尺寸作为料号的两个属性，不同颜色、尺寸不再生成子料号
# Modify.........: No:MOD-D90002 13/09/02 By Alberti BOM內同時存在兩筆相同元件資料B,做4.取代時,BOM單身將會產生二筆取代資料
# Modify.........: No:MOD-D90028 13/09/14 By Alberti 由單身進入abmi710b，將其取消鍵及X按鈕拿掉
# Modify.........: No.FUN-D90010 13/09/25 By qirl 修改abmg710傳參,增加一個參數
# Modify.........: No:TQC-DA0015 13/10/15 By lixh1 bmb_file 新增bmb34 服飾業顏色、尺寸屬性設定,By fengrui bmy38控卡修改
# Modify.........: No:MOD-DA0100 13/10/16 By Alberti 1.移除控卡abm-982 2.需將ima05 帶預設至 新版本(bmz03)
# Modify.........: No:TQC-DA0052 13/10/28 By Alberti 修正　當變異別為"3:舊元件修改"時,在輸入完bmy05後，沒有將後續預設值帶出
# Modify.........: No:MOD-DB0007 13/11/04 By Alberti 修正 刪除主件單身的最後一筆再點回上一筆 會造成無窮迴圈
# Modify.........: No:MOD-DB0005 13/11/05 By Alberti 修正 若單身有4:取代和5:替代時，取替代特性(bmy16)會有消失情形
# Modify.........: No:FUN-DA0124 13/11/07 By yihsuan 增加共用變數g_data_keyvalue給值
# Modify.........: No.FUN-DA0126 13/11/13 By bart 移除azo_file程式段
# Modify.........: No.CHI-DC0015 13/12/12 By Polly 增加bmy36"替代失效日期"欄位，變異別為6時才可輸入，有值時bmy06,bmy07不可異動
# Modify.........: No:CHI-DC0019 13/12/16 By Alberti 新增 單身控卡變異別1:新增 or 3:修改時，當ima147 = 'Y'(插件位置QPA勾稽)，控卡組成用量(bmy06)與插件總數量 要相同
# Modify.........: No:MOD-E10174 14/01/24 By Alberti 還原MOD-CB0147之作法，因若只想變動版本的話，此控卡會卡住，故將此控卡移除
# Modify.........: No.MOD-E10080 14/01/13 By fengmy abmi720已審核資料不重複審核
# Modify.........: No:MOD-E30063 14/03/12 By Alberti 修正 abm-387的錯誤應該要限定在slk業別
# Modify.........: No.MOD-E30067 14/03/12 By fengmy mark MOD-E10080
# Modify.........: No:MOD-E30159 14/03/28 By Alberti 修正 bmy38(服飾業用)，控卡不完全，在非服飾業下也會出現，造成BUG
# Modify.........: No:MOD-E40001 14/04/02 By Alberti 修正 新增時bmy34(代買料否)預設值應該是為N
# Modify.........: No:MOD-E40053 14/04/11 By Alberti 修正 錯誤訊息(abm-388)，只能在服飾業才做控卡
# Modify.........: No:FUN-E50024 14/05/08 By sabrina GR改串CR
# Modify.........: No:FUN-E50052 14/05/22 By SunLM CR报表传参增加
# Modify.........: No:MOD-E60057 14/06/12 By Mandy AFTER FIELD bmy07(底數)增加控卡=>mfg2615:主件底數不可小於等於零
# Modify.........: No:MOD-E60073 14/06/17 By fengmy 元件單身進入單身時為清除單身已有空值資料
# Modify.........: No:MOD-E60114 14/06/25 By fengmy 申請人開窗調整為員工基本資料，與abmi720一致
# Modify.........: No:CHI-E80001 14/08/04 By Alberti 新增時，如主件/元件為Z:雜項料件(ima08)，應控卡住無法新增
# Modify.........: No:TQC-E90001 14/09/09 By Sulamite 1.單據刪除時,畫面上顏色尺寸明細未一併重新display
#                                                     2.修改變異元件料號,重新維護顏色尺寸資料,第一次會沒有寫入
# Modify.........: No:CHI-EA0015 14/10/13 By Iris Wang 调整资料清单影响按上下笔效能问题
# Modify.........: No:MOD-EA0134 14/10/27 By Alberti 修正 將異動別(bmy03)=6 替代變更 -> 取/替代變更，相對應的控卡也一併做更改(CHI-C20060) 
# Modify.........: No:CHI-EA0052 14/11/03 By Iris Wang 调整资料清单影响按上下笔效能问题
# Modify.........: No:MOD-EC0101 14/12/22 By Alberti 當選擇5:替代 需預帶abmi600的值，值不可修改，後續bmb_file改用UPDATE
# Modify.........: No:FUN-F10019 15/01/22 By Lisa 調整單關簽核或通知關卡EF與TT狀態不一致問題，aws_efcli2僅需重新撈取狀態碼並顯示於單據上
# Modify.........: No:MOD-F20085 15/02/24 By Mandy (1)將MOD-EC0101調整i710_s4()拆分4:取代/5:替代的功能還原
#                                                  (2)MOD-EC0101的原本BUG問題,調整i710_chkinsitm()做到控卡"abm-806:同一ECN變更單,不可輸入二次同一主件,同一元件之變更"
#                                                  (3)5:替代 中文明確同abmi720改為"替代新增"
# Modify.........: No:FUN-F50035 15/05/27 By Lisa 新增與APS整合時,單身增加vls_file及vlr_file維護資訊,並與確認時回寫vmq_file及vmo_file
# Modify.........: No:FUN-F50016 15/06/01 By jwlin 解決新增、複製後記錄key問題
# Modify.........: No:CHI-F80014 15/09/01 By fionchen 調整CURSOR在二次查詢顯示異常的問題 
# Modify.........: No:MOD-FA0119 15/10/27 By catmoon 鞋服業修改單身項次時,要先判斷若有顏色尺寸明細資料時,也要一併更新顏色尺寸明細的單據項次資料 
# Modify.........: No:MOD-G50111 16/05/23 By catmoon 預設上一筆後，需將新值塞入g_bmy_o,避免畫面上的值一直被清空
# Modify.........: No:MOD-G70147 16/07/28 By catmoon 調整g_bmz順序，避免EXCEL匯出資料異常
# Modify.........: No:MOD-G90008 16/09/03 By Mandy (1)ima147插件位置與QPA勾稽=N時，若更改插件位置數量並不會更新組成用量
#                                                  (2)ima147插件位置與QPA勾稽=Y時，若更改插件位置數量應控卡住
# Modify.........: No:MOD-G90032 16/09/06 By Mandy 插件位置的維護(abmi710c)限制在變異別為[2:新元件新增生效]或[3:舊元件修改]才能進入
# Modify.........: No:MOD-G90038 16/09/07 By Mandy MOD-G90008未調整好,未考慮到ima147 = 'N'時,用SUM(bmt07)回寫組成用量,但SUM(bmt07)可能無值
# Modify.........: No:MOD-H10002 17/01/03 By Mandy 若新增的元件為半成品或虛擬件需檢核該元件的BOM是否發放
# Modify.........: No:MOD-H30025 17/03/24 By Mandy 取代時不成功s4_ins bmd問題,bmd03 應重新取MAX(bmd03)+1 而不是直接給1
# Modify.........: No:0000664623_06_M014 18/02/02 By TSD.Andy 修改變異別=4[取代]時之預設及確認邏輯
# Modify.........: NO:1901152575 20190123 By momo bmy05,bmy27單位不同時，會顯示不同顏色提醒;且未KEY入使用量及底數，ECN無法確認 
# Modify.........: No:1909273692 20191005 By momo 主件單身增加顯示代工欄位ta_ima06
# Modify.........: No:1910233808 20191024 By momo 單頭新增時即詢問固定備註
# Modify.........: No:2010195341 20201023 By momo KS確認時卡控是否有生效日較早未確認單據
# Modify.........: No:2011265491 20201208 By momo 增加停產維護欄位 bmy38
# Modify.........: No:2012235638 20201223 By momo 確認時生效日不可小於當日
#                                                 停產卡控由強制更改為提示
# Modify.........: No:22110032   20221123 By momo 單身增加 bmy09作業編號，可直接維護
# Modify.........: No:23020008   20230208 By momo 增加 ECN變更原因欄位
# Modify.........: No:23080026   20230901 By momo 當設定料件停產，依aooi602 設定進行更新判斷
# Modify.........: NO:24080018   20240814 By momo 調整備註欄位顯示 
# Modify.........: No:24080014   20240816 By momo ECN筆數過多，送簽時調整 不送單身資料，BPM表單直接抓取資料顯示即可
# Modify.........: No:24110009   20241108 By momo 增加 cbmi604 檢核機制

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../tiptop/sub/4gl/s_data_center.global"   #No.FUN-820027
 
#模組變數(Module Variables)
DEFINE
    g_bmx   RECORD LIKE bmx_file.*,
    g_bmx_t RECORD LIKE bmx_file.*,
    g_bmx_o RECORD LIKE bmx_file.*,
    b_bmz   RECORD LIKE bmz_file.*,
    g_bmz           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                        bmz012   LIKE bmz_file.bmz012,   #MOD-G70147 add
			bmz013   LIKE bmz_file.bmz013,   #MOD-G70147 add
			bmz02    LIKE bmz_file.bmz02,
			ima02_1  LIKE ima_file.ima02,
			ima021_1 LIKE ima_file.ima021,
                        ta_ima06 LIKE ima_file.ta_ima06, #20191005
			bmz011   LIKE bmz_file.bmz011,   #No.FUN-A60008
           #bmz012   LIKE bmz_file.bmz012,   #No.FUN-A60008 #MOD-G70147 mark
           #bmz013   LIKE bmz_file.bmz013,   #No.FUN-A60008 #MOD-G70147 mark
			bmz04    LIKE bmz_file.bmz04,    #bugno:6845 add
			bmz03    LIKE bmz_file.bmz03,
			bmz05    LIKE bmz_file.bmz05 #FUN-550014 add
                    END RECORD,
    g_bmz_t         RECORD    #程式變數(Prinram Variables)
            bmz012   LIKE bmz_file.bmz012,   #MOD-G70147 add
			bmz013   LIKE bmz_file.bmz013,   #MOD-G70147 add
			bmz02    LIKE bmz_file.bmz02,
			ima02_1  LIKE ima_file.ima02,
			ima021_1 LIKE ima_file.ima021,
                        ta_ima06 LIKE ima_file.ta_ima06, #20191005
			bmz011   LIKE bmz_file.bmz011,   #No.FUN-A60008
           #bmz012   LIKE bmz_file.bmz012,   #No.FUN-A60008 #MOD-G70147 mark
           #bmz013   LIKE bmz_file.bmz013,   #No.FUN-A60008 #MOD-G70147 mark		
			bmz04    LIKE bmz_file.bmz04,    #bugno:6845 add
			bmz03    LIKE bmz_file.bmz03,
			bmz05    LIKE bmz_file.bmz05 #FUN-550014 add
                    END RECORD,
    g_bmf_t         RECORD    #程式變數(Prinram Variables)
			bmf03    LIKE bmf_file.bmf03,
			bmf04    LIKE bmf_file.bmf04
                    END RECORD,
    b_bmy   RECORD LIKE bmy_file.*,
    b_bmf   RECORD LIKE bmf_file.*,
    g_bmy           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
			bmy02    LIKE bmy_file.bmy02,
			bmy03    LIKE bmy_file.bmy03,
		 	bmy19    LIKE bmy_file.bmy19,
			bmy04    LIKE bmy_file.bmy04,
			bmy05    LIKE bmy_file.bmy05,
			ima02    LIKE ima_file.ima02,
			ima021   LIKE ima_file.ima021,
                        bmy38    LIKE bmy_file.bmy38,  #20201208 modify
                       #FUN-F50035 add start ---
                        vlr13    LIKE vlr_file.vlr13,
                        vlr16    LIKE vlr_file.vlr16,
                        vlr17    LIKE vlr_file.vlr17,
                        vlr18    LIKE vlr_file.vlr18,
                       #FUN-F50035 add end ---
		 	bmy27    LIKE bmy_file.bmy27,  #bugno:6845 add
			ima02n   LIKE ima_file.ima02,
			ima021n  LIKE ima_file.ima021,
			bmy16    LIKE bmy_file.bmy16,
                        vls11    LIKE vls_file.vls11,  #FUN-F50035 add
			bmy35    LIKE bmy_file.bmy35,  #CHI-A60028 add
			bmy30    LIKE bmy_file.bmy30,  #FUN-550014 add
                       #bmy38    LIKE bmy_file.bmy38,  #FUN-D80022 add #20201208 mark
			bmy06    LIKE bmy_file.bmy06,
			bmy07    LIKE bmy_file.bmy07,
			bmy09    LIKE bmy_file.bmy09,  #20221123 
                        bmy34    LIKE bmy_file.bmy34,  #NO.MOD-840426
                        bmy36    LIKE bmy_file.bmy36,  #CHI-DC0015 add
			bmy22    LIKE bmy_file.bmy22
                    END RECORD,
    g_bmy_t         RECORD
			bmy02    LIKE bmy_file.bmy02,
			bmy03    LIKE bmy_file.bmy03,
		 	bmy19    LIKE bmy_file.bmy19,
			bmy04    LIKE bmy_file.bmy04,
			bmy05    LIKE bmy_file.bmy05,
			ima02    LIKE ima_file.ima02,
			ima021   LIKE ima_file.ima021,
                        bmy38    LIKE bmy_file.bmy38,  #20201208 modify
                       #FUN-F50035 add start ---
                        vlr13    LIKE vlr_file.vlr13,
                        vlr16    LIKE vlr_file.vlr16,
                        vlr17    LIKE vlr_file.vlr17,
                        vlr18    LIKE vlr_file.vlr18,
                       #FUN-F50035 add end ---
		 	bmy27    LIKE bmy_file.bmy27,  #bugno:6845 add
			ima02n   LIKE ima_file.ima02,
			ima021n  LIKE ima_file.ima021,
			bmy16    LIKE bmy_file.bmy16,
                        vls11    LIKE vls_file.vls11,  #FUN-F50035 add
			bmy35    LIKE bmy_file.bmy35,  #CHI-A60028 add
			bmy30    LIKE bmy_file.bmy30,  #FUN-550014 add
                       #bmy38    LIKE bmy_file.bmy38,  #FUN-D80022 add #20201208 mark
			bmy06    LIKE bmy_file.bmy06,
			bmy07    LIKE bmy_file.bmy07,
			bmy09    LIKE bmy_file.bmy09,  #20221123 
                        bmy34    LIKE bmy_file.bmy34,  #no.MOD-840426
                        bmy36    LIKE bmy_file.bmy36,  #CHI-DC0015 add
			bmy22    LIKE bmy_file.bmy22
                    END RECORD,
   #CHI-C10032 str add-----
    g_bmy_o         RECORD
                        bmy02    LIKE bmy_file.bmy02,
                        bmy03    LIKE bmy_file.bmy03,
                        bmy19    LIKE bmy_file.bmy19,
                        bmy04    LIKE bmy_file.bmy04,
                        bmy05    LIKE bmy_file.bmy05,
                        ima02    LIKE ima_file.ima02,
                        ima021   LIKE ima_file.ima021,
                        bmy38    LIKE bmy_file.bmy38,  #20201208 modify
                       #FUN-F50035 add start ---
                        vlr13    LIKE vlr_file.vlr13,
                        vlr16    LIKE vlr_file.vlr16,
                        vlr17    LIKE vlr_file.vlr17,
                        vlr18    LIKE vlr_file.vlr18,
                       #FUN-F50035 add end ---
                        bmy27    LIKE bmy_file.bmy27,
                        ima02n   LIKE ima_file.ima02,
                        ima021n  LIKE ima_file.ima021,
                        bmy16    LIKE bmy_file.bmy16,
                        vls11    LIKE vls_file.vls11,  #FUN-F50035 add
                        bmy35    LIKE bmy_file.bmy35,
                        bmy30    LIKE bmy_file.bmy30,
                       #bmy38    LIKE bmy_file.bmy38,  #FUN-D80022 add #20201208 mark
                        bmy06    LIKE bmy_file.bmy06,
                        bmy07    LIKE bmy_file.bmy07,
                        bmy09    LIKE bmy_file.bmy09,  #20221123
                        bmy34    LIKE bmy_file.bmy34,
                        bmy36    LIKE bmy_file.bmy36,  #CHI-DC0015 add
                        bmy22    LIKE bmy_file.bmy22
                    END RECORD,
   ##----- 20190123 add (S)
   ga_color DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
			bmy02    STRING,
			bmy03    STRING,
		 	bmy19    STRING,
			bmy04    STRING,
			bmy05    STRING,
			ima02    STRING,
			ima021   STRING,     
                        bmy38    STRING, #20201208 modify
                        vlr13    STRING,
                        vlr16    STRING,
                        vlr17    STRING,
                        vlr18    STRING,
		 	bmy27    STRING,  
			ima02n   STRING,
			ima021n  STRING,
			bmy16    STRING,
                        vls11    STRING,  
			bmy35    STRING,  
			bmy30    STRING,  
                       #bmy38    STRING,  #20201208 mark
			bmy06    STRING,
			bmy07    STRING,
			bmy09    STRING,  #20221123
                        bmy34    STRING,  
                        bmy36    STRING,  
			bmy22    STRING
                    END RECORD,
   ##----- 20190123 add (E)   
   #CHI-C10032 end add-----
    g_bmw           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
			bmw04    LIKE bmw_file.bmw04,
			bmw05    LIKE bmw_file.bmw05
                    END RECORD,
    g_bmw_t         RECORD    #程式變數(Prinram Variables)
			bmw04	LIKE bmw_file.bmw04,
			bmw05	LIKE bmw_file.bmw05
                    END RECORD,
    g_bmf           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                        bmf03    LIKE bmf_file.bmf03,
                        bmf04    LIKE bmf_file.bmf04
                    END RECORD,
    b_bmw	    RECORD LIKE bmw_file.*,
    g_last_seq      LIKE type_file.num10,       #No.FUN-680096  INTEGER
    g_bmb	    RECORD LIKE bmb_file.*,
    g_bmy05_t	    LIKE bmy_file.bmy05,        #No.MOD-490217
   #TQC-E90001--add str--
    g_bmy05_t1	    LIKE bmy_file.bmy05, 
    g_bmy02_t       LIKE bmy_file.bmy02,
    g_bmy38_t       LIKE bmy_file.bmy38, 
    l_action        LIKE type_file.chr30,
   #TQC-E90001--add end--
    g_bmd	    RECORD LIKE bmd_file.*,
    g_bmw05         LIKE bmw_file.bmw05,
    g_wc,g_wc2,g_wc3,g_sql    string,           #No.FUN-580092 HCN
    g_t1            LIKE oay_file.oayslip,  #No.FUN-680096  #No.FUN-680096 VARCHAR(5)
    g_sw            LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
    g_ima107	    LIKE ima_file.ima107,   #No.FUN-680096  VARCHAR(1)
    g_ima147	    LIKE ima_file.ima147,   #No.FUN-680096  VARCHAR(1)
    g_buf           LIKE type_file.chr20,   #No.FUN-680096  VARCHAR(20)
    g_exit_sw       LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
    g_rec_d         LIKE type_file.num5,    #單身筆數  #No.FUN-680096  SMALLINT
    g_rec_b         LIKE type_file.num5,    #單身筆數  #No.FUN-680096  SMALLINT
    g_void          LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
    g_approve       LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
    g_confirm       LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
    g_rec_t         LIKE type_file.num5,    #單身筆數  #No.FUN-680096  SMALLINT
    g_rec_e         LIKE type_file.num5,    #單身筆數  #No.FUN-680096  SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-680096 SMALLINT
DEFINE g_argv2      LIKE bmx_file.bmx01	   #ECN No.                         #CHI-CA0035 mod g_argv1->g_argv2
DEFINE g_argv3      STRING       	   #TQC-630070      #執行功能       #CHI-CA0035 mod g_argv2->g_argv3    
DEFINE g_argv1      LIKE type_file.chr1            #No.FUN-A60008           #CHI-CA0035 mod g_argv3->g_argv1
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680096 SMALLINT
DEFINE g_forupd_sql   STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE g_chr          LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE g_i            LIKE type_file.num5          #count/index for any purpose  #No.FUN-680096 SMALLINT
DEFINE g_msg          LIKE ze_file.ze03            #No.FUN-680096  VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680096  INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680096  INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680096  INTEGER
DEFINE mi_no_ask      LIKE type_file.num5          #No.FUN-680096  SMALLINT
DEFINE g_laststage    LIKE type_file.chr1          #FUN-580120   #No.FUN-680096  VARCHAR(1)
DEFINE g_chr2         LIKE type_file.chr1          #FUN-580120   #No.FUN-680096  VARCHAR(1)
DEFINE g_chr3         LIKE type_file.chr1          #FUN-580120   #No.FUN-680096  VARCHAR(1)
 
DEFINE g_bmx_l        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)                                                        
         bmx01        LIKE bmx_file.bmx01,                                                                                          
         bmx07        LIKE bmx_file.bmx07,                                                                                          
         bmx10        LIKE bmx_file.bmx10,                                                                                          
         bmx13        LIKE bmx_file.bmx13,      #No CHI-9C0054 add 
         bmx05        LIKE bmx_file.bmx05,                                                                                          
         bmg03        LIKE bmg_file.bmg03,                                                                                          
         bmx11        LIKE bmx_file.bmx11                                                                                           
                      END RECORD                                                                                                    
DEFINE  g_bmxx        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)                                                        
          sel         LIKE type_file.chr1,                                                                                          
          bmx01       LIKE bmx_file.bmx01                                                                                           
                      END RECORD                                                                                                    
DEFINE g_gev04        LIKE gev_file.gev04                                                                                           
DEFINE l_ac1          LIKE type_file.num10                                                                                          
DEFINE g_rec_b1       LIKE type_file.num10                                                                                          
DEFINE g_bp_flag      LIKE type_file.chr10                                                                                          
DEFINE g_flag2        LIKE type_file.chr1   
DEFINE g_flag3        LIKE type_file.chr1       #MOD-D90028 add                                                                                         
DEFINE g_gew06        LIKE gew_file.gew06                                                                                           
DEFINE g_gew07        LIKE gew_file.gew07                                                                                           
DEFINE g_brb          RECORD LIKE brb_file.*    #No.FUN-A60008
DEFINE g_bra014       LIKE bra_file.bra014      #No.FUN-A60008
DEFINE g_ecb06        LIKE ecb_file.ecb06       #No.FUN-A60083
DEFINE cb             ui.ComboBox
DEFINE g_multi_bmz02  STRING    #FUN-B30171
DEFINE b_bmy10_t      LIKE bmy_file.bmy10       #No.FUN-BB0086
#DEFINE l_table       STRING  #FUN-C30119       #TQC-C60179
DEFINE g_rec_b2       LIKE type_file.num10      #TQC-C60179
#FUN-D80022 -----Begin------
DEFINE g_bmya_1    DYNAMIC ARRAY OF RECORD
           bmya03      LIKE bmya_file.bmya03,
           bmya04      LIKE bmya_file.bmya04,
           bmya04_des  LIKE agd_file.agd03,
           bmya05      LIKE bmya_file.bmya05,
           bmya05_des  LIKE agd_file.agd03,
           bmyb03      LIKE bmyb_file.bmyb03,
           bmyb04      LIKE bmyb_file.bmyb04,
           bmyb04_des  LIKE agd_file.agd03,
           bmyb05      LIKE bmyb_file.bmyb05,
           bmyb05_des  LIKE agd_file.agd03,
           bmyc03      LIKE bmyc_file.bmyc03,
           bmyc04      LIKE bmyc_file.bmyc04,
           bmyc04_des  LIKE agd_file.agd03,
           bmyd03      LIKE bmyd_file.bmyd03,
           bmyd04      LIKE bmyd_file.bmyd04,
           bmyd04_des  LIKE agd_file.agd03
                   END RECORD,
       g_bmya_1_t  RECORD
           bmya03      LIKE bmya_file.bmya03,
           bmya04      LIKE bmya_file.bmya04,
           bmya04_des  LIKE agd_file.agd03,
           bmya05      LIKE bmya_file.bmya05,
           bmya05_des  LIKE agd_file.agd03,
           bmyb03      LIKE bmyb_file.bmyb03,
           bmyb04      LIKE bmyb_file.bmyb04,
           bmyb04_des  LIKE agd_file.agd03,
           bmyb05      LIKE bmyb_file.bmyb05,
           bmyb05_des  LIKE agd_file.agd03,
           bmyc03      LIKE bmyc_file.bmyc03,
           bmyc04      LIKE bmyc_file.bmyc04,
           bmyc04_des  LIKE agd_file.agd03,
           bmyd03      LIKE bmyd_file.bmyd03,
           bmyd04      LIKE bmyd_file.bmyd04,
           bmyd04_des  LIKE agd_file.agd03
                   END RECORD,
       g_bmya_a    DYNAMIC ARRAY OF RECORD
           bmya04      LIKE bmya_file.bmya04,
           bmya04_d    LIKE agd_file.agd03,
           bmya05      LIKE bmya_file.bmya05,
           bmya05_d    LIKE agd_file.agd03
                   END RECORD,
       g_bmyb_b    DYNAMIC ARRAY OF RECORD
           bmyb04      LIKE bmyb_file.bmyb04,
           bmyb04_d    LIKE agd_file.agd03,
           bmyb05      LIKE bmyb_file.bmyb05,
           bmyb05_d    LIKE agd_file.agd03
                   END RECORD,
       g_bmyc_c    DYNAMIC ARRAY OF RECORD
           bmyc04      LIKE bmyc_file.bmyc04,
           bmyc04_c    LIKE agd_file.agd03
                   END RECORD,
       g_bmyd_d    DYNAMIC ARRAY OF RECORD
           bmyd04      LIKE bmyd_file.bmyd04,
           bmyd04_c    LIKE agd_file.agd03
                   END RECORD

DEFINE g_rec_b_2    LIKE type_file.num10
DEFINE g_rec_b3     LIKE type_file.num10
DEFINE g_rec_b4     LIKE type_file.num10
DEFINE g_rec_b5     LIKE type_file.num10
DEFINE g_rec_b6     LIKE type_file.num10
DEFINE l_ac2        LIKE type_file.num10
DEFINE l_ac_t2      LIKE type_file.num10
DEFINE g_forupd_sql1              STRING,
       g_forupd_sql2              STRING,
       g_forupd_sql3              STRING,
       g_forupd_sql4              STRING
DEFINE g_ima940     LIKE ima_file.ima940,
       g_ima941     LIKE ima_file.ima941,
       g_ima943     LIKE ima_file.ima943,
       g_ima940_1   LIKE ima_file.ima940,
       g_ima941_1   LIKE ima_file.ima941,
       g_ima943_1   LIKE ima_file.ima943

#FUN-D80022 -----End--------
#FUN-D60015--add--str--
DEFINE w        ui.Window
DEFINE f        ui.Form
DEFINE page     om.DomNode
#FUN-D60015--add--end--
DEFINE b_vlr   RECORD LIKE vlr_file.*    #FUN-F50035 add
DEFINE b_vls   RECORD LIKE vls_file.*    #FUN-F50035 add
DEFINE g_amt      LIKE bmw_file.bmw05    #MOD-G90008 add

MAIN
DEFINE l_argv5 STRING   #FUN-B80071
    IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP
      DEFER INTERRUPT
    END IF
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("CBM")) THEN
       EXIT PROGRAM
    END IF

    LET g_flag3 = 'N'            #MOD-D90028 add
    LET g_forupd_sql = "SELECT * FROM bmx_file WHERE bmx01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i710_cl CURSOR FROM g_forupd_sql
 
    LET g_argv1 = ARG_VAL(1)			# ECN No.
    LET g_argv2 = ARG_VAL(2)   #執行功能   #TQC-630070
    LET g_argv3 = ARG_VAL(3)     #No.FUN-A60008
    LET l_argv5 = ARG_VAL(5)   #FUN-B80071
    #TQC-AC0175--begin--add---
    IF NOT cl_null(g_argv1) THEN   #CHI-CA0035 mod g_argv3->g_argv1
       IF g_argv1='2' THEN         #CHI-CA0035 mod g_argv3->g_argv1 
          LET g_prog='abmi711'
       ELSE
          LET g_prog='abmi710'
       END IF
    END IF
    #TQC-AC0175--end--add--------

    #No.FUN-A60008--begin
    IF g_prog='abmi710' THEN 
       LET g_argv1='1'         #CHI-CA0035 mod g_argv3->g_argv1
    END IF 
    IF g_prog='abmi711' THEN 
    	 LET g_argv1='2'       #CHI-CA0035 mod g_argv3->g_argv1
    END IF     
    IF cl_null(g_argv1) THEN   #CHI-CA0035 mod g_argv3->g_argv1
       LET g_argv1='1'         #CHI-CA0035 mod g_argv3->g_argv1
    END IF 
    IF g_argv1='2' THEN        #CHI-CA0035 mod g_argv3->g_argv1
      CALL cl_set_comp_entry("bmy16",FALSE)
    END IF 
    #No.FUN-A60008--end 
    IF fgl_getenv('EASYFLOW') = "1" THEN
       LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1   #CHI-CA0035 mod g_argv1->g_argv2
       #FUN-B80071 add str---
       #因從EASYFLOW進行自動確認時,參數位置非標準,故增加此判斷邏輯
       #argv1='',argv2='',argv3='1',argv4='AAA-11082302',argv5='efconfirm'
       IF NOT cl_null(g_argv3) THEN        #CHI-CA0035 mod g_argv2->g_argv3
          IF g_argv3 <> 'efconfirm' THEN   #CHI-CA0035 mod g_argv2->g_argv3
             LET g_argv3 = l_argv5         #CHI-CA0035 mod g_argv2->g_argv3 
          END IF
       ELSE
          LET g_argv3 = l_argv5            #CHI-CA0035 mod g_argv2->g_argv3
       END IF
       #FUN-B80071 add end---
    END IF
 
    CALL s_decl_bmb()
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
 
    IF g_bgjob='N' OR cl_null(g_bgjob) AND cl_null(g_argv3) THEN  #NO.FUN-840033  #CHI-CA0035 mod g_argv2->g_argv3
 
      LET p_row = 2 LET p_col = 2
    
      OPEN WINDOW i710_w AT p_row,p_col WITH FORM "cbm/42f/abmi710"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
      CALL cl_ui_init()
      CALL cl_set_toolbaritem_visible('output',TRUE)   #FUN-D60005 add 
    END IF
    #No.FUN-A60008--begin
    IF g_argv1='2' THEN                 #CHI-CA0035 mod g_argv3->g_argv1
       IF g_sma.sma542='N' THEN 
          CALL cl_err('','abm-213',1)
          CLOSE WINDOW i710_w           #TQC-AC0175  
          CALL  cl_used(g_prog,g_time,2) RETURNING g_time           
       END IF         
    END IF 

    IF g_argv3 <> 'abmp701' OR cl_null(g_argv3) THEN   #CHI-CA0035 add
       IF g_argv1='2' THEN              #CHI-CA0035 mod g_argv3->g_argv1
          CALL cl_set_comp_visible('bmz011,bmz012,bmz013',TRUE)
          CALL cl_set_comp_entry('bmy16',FALSE)
       ELSE 
       	 CALL cl_set_comp_visible('bmz011,bmz012,bmz013',FALSE)
       END IF 
    END IF    #CHI-CA0035 add
    #FUN-D80022--add--str--
    IF s_industry('slk') AND g_sma.sma150 = 'Y' THEN
       CALL cl_set_comp_visible('s_bmya_a,s_bmyb_b,s_bmyc_c,s_bmyd_d',TRUE)
       CALL cl_set_comp_visible('bmy38',TRUE)                              
       CALL cl_set_act_visible("define_color_size", TRUE)
    ELSE 
       CALL cl_set_comp_visible('s_bmya_a,s_bmyb_b,s_bmyc_c,s_bmyd_d',FALSE)
    #  CALL cl_set_comp_visible('bmy38',FALSE)                                #20201208 mark
       CALL cl_set_act_visible("define_color_size", FALSE)
    END IF
    #FUN-D80022--add--end--

    IF g_argv1='2' THEN                 #CHI-CA0035 mod g_argv3->g_argv1
       LET cb = ui.ComboBox.forName("bmy03")
       CALL cb.removeItem('4')
       CALL cb.removeItem('5')
    END IF     
    #No.FUN-A60008--end 
    #CHI-C20060---begin  
    IF g_prog='abmi711' THEN 
       LET cb = ui.ComboBox.forName("bmy03")
       CALL cb.removeItem('6')
    END IF  
    #CHI-C20060---end
    #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
    #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
    CALL aws_efapp_toolbar()    #FUN-580120
 
    CAll cl_set_comp_visible("vlr13,vlr16,vlr17,vlr18,vls11",g_sma.sma901 = 'Y')  #FUN-F50035 add
 
    # 先以g_argv3判斷直接執行哪種功能：   #CHI-CA0035 mod g_argv2->g_argv3
    IF NOT cl_null(g_argv2) THEN          #CHI-CA0035 mod g_argv1->g_argv2
       CASE g_argv3                       #CHI-CA0035 mod g_argv2->g_argv3 
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i710_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i710_a()
               LET g_data_keyvalue = g_bmx.bmx01      #No:FUN-F50016
            END IF
         WHEN "efconfirm"
            CALL i710_q()
            CALL i710_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               CALL i710_y_upd()       #CALL 原確認的 update 段
            END IF
            EXIT PROGRAM
         WHEN "abmp701"
            CALL s_showmsg_init()
            LET g_bmx.bmx01 = g_argv2  #CHI-CA0035 mod g_argv1->g_argv2 
            LET g_action_choice = "confirm" 
            CLOSE WINDOW SCREEN
            CALL i710_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               CALL i710_y_upd()       #CALL 原確認的 update 段
               CALL i710_refresh() RETURNING g_bmx.*  #FUN-B80071
              #CALL i710_show()                       #FUN-B80071  #CHI-CA0035 mark
            END IF
            CALL s_showmsg()
            EXIT PROGRAM
         OTHERWISE          #TQC-660072
            CALL i710_q()   #TQC-660072
       END CASE
    END IF

   #FUN-B70022 mark str----- 
   #IF NOT cl_null(g_argv1) THEN
   #    CALL i710_q()
   #END IF
   #FUN-B70022 mark end-----
 
    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
    #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, confirm, undo_confirm,easyflow_approval,master_item_detail,component_detail")  #NO.TQC-5C0004  #FUN-B80071 mark
     CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void,undo_void, confirm, undo_confirm,easyflow_approval, master_item_detail, component_detail, carry, mntn_insert_loc, memo")  #FUN-B80071  #CHI-D20010 add undo_void
          RETURNING g_laststage
 
    CALL cl_set_comp_visible("bmz05,bmy30",g_sma.sma118='Y') #FUN-560115

    CALL i710()
 
    CLOSE WINDOW i710_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
 
END MAIN
 
FUNCTION i710()
  DEFINE l_za05    LIKE za_file.za05
 
    LET g_wc2=' 1=1'
    LET g_wc3=' 1=1'
    
    LET g_exit_sw = 'N'
    CALL i710_menu()
END FUNCTION
 
FUNCTION i710_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_bmz.clear()
    CALL g_bmy.clear()
    CALL g_bmw.clear()
    CALL g_bmf.clear()
    #FUN-D80022--add--str--
    CALL g_bmya_a.clear()
    CALL g_bmyb_b.clear()
    CALL g_bmyc_c.clear()
    CALL g_bmyd_d.clear()
    #FUN-D80022--add--end--
    IF NOT cl_null(g_argv2) THEN            #CHI-CA0035 mod g_argv1->g_argv2
       LET g_wc = " bmx01 = '",g_argv2,"'"  #FUN-580120  #CHI-CA0035 mod g_argv1->g_argv2
       LET g_wc2=' 1=1'
       LET g_wc3=' 1=1'

     ELSE
       CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INITIALIZE g_bmx.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
                bmx01,bmx02,bmx07,bmx10,bmx13,bmx11,bmx05,#FUN-630044    #FUN-820027 add bmx11  #CHI-9C0054 add bmx13 
                #bmx04,bmxmksg,bmx09,bmxuser,bmxgrup,bmxmodu,   #M014 180205 By TSD.Andy mark
                ta_bmx03,                                                         #20230208
                bmx04,bmx09,bmxmksg,ta_bmx01,ta_bmx02,bmxuser,bmxgrup,bmxmodu,    #M014 180205 By TSD.Andy
                bmxdate,bmxacti  #FUN-540045
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
          CASE 
               WHEN INFIELD(bmx01) #查詢單据
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               #LET g_qryparam.form = "q_bmx3"
               LET g_qryparam.form = "q_bmx01"
               LET g_qryparam.arg1=g_argv1          #CHI-CA0035 mod g_argv3->g_argv1  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bmx01
               NEXT FIELD bmx01
 

               WHEN INFIELD(bmx10) #申請人
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"   #MOD-E60114
                #LET g_qryparam.form = "q_bmx10" #MOD-E60114 mark
                #LET g_qryparam.arg1=g_argv1        #CHI-CA0035 mod g_argv3->g_argv1  #MOD-E60114 mark
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bmx10
                 NEXT FIELD bmx10
 
               #No.CHI-9C0054  ---start---
               WHEN INFIELD(bmx13)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_gem"
                 LET g_qryparam.form = "q_bmx13"
                 LET g_qryparam.arg1=g_argv1        #CHI-CA0035 mod g_argv3->g_argv1 
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO bmx13
                 NEXT FIELD bmx13               
               #No.CHI-9C0054 ---end---

               WHEN INFIELD(bmx11)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  #LET g_qryparam.form  = "q_azp" 
                  LET g_qryparam.form = "q_bmx11"
                  LET g_qryparam.arg1=g_argv1       #CHI-CA0035 mod g_argv3->g_argv1                                                                                     
                  LET g_qryparam.state = "c"                                                                                        
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO bmx11                                                                              
                  NEXT FIELD bmx11                                                                                                  
 
               WHEN INFIELD(bmx05) #查詢ECR
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_bmr"     #MOD-A30170 mark
                    LET g_qryparam.form = "q_bmr1"    #MOD-A30170 
                   #TQC-AC0171 --------add start-----
                    IF g_argv1 = '1' THEN             #CHI-CA0035 mod g_argv3->g_argv1
                       LET g_qryparam.where = " bmr50 = '1' "
                    ELSE
                       LET g_qryparam.where = " bmr50 = '2' "
                    END IF
                   #TQC-AC0171 --------add end---------  
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bmx05
                    NEXT FIELD bmx05

                 ##--- 20230208 --- (S) ---
               WHEN INFIELD(ta_bmx03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_azf01a"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1  = "G"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ta_bmx03
                  NEXT FIELD ta_bmx03
               ##--- 20230208 --- (E) ---
          END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
 
       END CONSTRUCT
 
       IF INT_FLAG THEN RETURN END IF
 
       CONSTRUCT g_wc2 ON bmz02,bmz011,bmz012,bmz013,bmz04,bmz03,bmz05       #No.FUN-A60008 add bmz011,bmz012,bmz013  #CHI-B40031 add bmz05
            FROM s_bmz[1].bmz02,s_bmz[1].bmz011,s_bmz[1].bmz012,
            s_bmz[1].bmz013,s_bmz[1].bmz04,s_bmz[1].bmz03,s_bmz[1].bmz05      #CHI-B40031 add s_bmz[1].bmz05
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
          ON ACTION controlp
             #No.FUN-A60008--begin
             #IF INFIELD(bmz02) THEN    #FUN-4B0001主件料號開窗
             CASE WHEN INFIELD(bmz02)   
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_bma"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bmz02
                       NEXT FIELD bmz02
                  WHEN INFIELD(bmz011) 
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_bmz011"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bmz011
                       NEXT FIELD bmz011         
                  WHEN INFIELD(bmz012)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_bmz012"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bmz012
                       NEXT FIELD bmz012     
                  WHEN INFIELD(bmz013)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_bmz013"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bmz013
                       NEXT FIELD bmz013     
                  #CHI-B40031 --- modify --- start ---
                  WHEN INFIELD(bmz05)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_bmz05"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bmz05
                       NEXT FIELD bmz05
                 #CHI-B40031 --- modify ---  end  ---
             #END IF
             END CASE 
             #No.FUN-A60008--end 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
 
      #---------------------------CHI-DC0015-------------------(S)
      #--CHI-DC0015--mark
      #CONSTRUCT g_wc3 ON bmy02,bmy03,bmy19,bmy04,bmy05,bmy27,bmy38,bmy06,  #CHI-710048 bmy27順序在bmy05後  #FUN-D80022 add bmy38
      #                   bmy16,bmy35,bmy30,bmy34,bmy22         #CHI-930025 #CHI-A60028 add bmy35
      #     FROM s_bmy[1].bmy02, s_bmy[1].bmy03, s_bmy[1].bmy19,
      #          s_bmy[1].bmy04, s_bmy[1].bmy05,s_bmy[1].bmy27, #CHI-710048 bmy27順序在bmy05後                 
      #          s_bmy[1].bmy38,s_bmy[1].bmy06,                 #FUN-D80022 add bmy38  
      #          s_bmy[1].bmy16, s_bmy[1].bmy35,s_bmy[1].bmy30,s_bmy[1].bmy34,s_bmy[1].bmy22  #CHI-930025 #CHI-A60028 add bmy35
      #--CHI-DC0015--mark
       CONSTRUCT g_wc3 ON bmy02,bmy03,bmy19,bmy04,bmy05,
                          bmy27,bmy38,bmy06,bmy16,bmy35,  
                          bmy30,bmy34,bmy36,bmy22                                                   #CHI-DC0015 add bmy36
            FROM s_bmy[1].bmy02, s_bmy[1].bmy03, s_bmy[1].bmy19,s_bmy[1].bmy04, s_bmy[1].bmy05,
                 s_bmy[1].bmy27, s_bmy[1].bmy38, s_bmy[1].bmy06,s_bmy[1].bmy16, s_bmy[1].bmy35,                
                 s_bmy[1].bmy30, s_bmy[1].bmy34, s_bmy[1].bmy36,s_bmy[1].bmy22                      #CHI-DC0015 add bmy36 
      #---------------------------CHI-DC0015-------------------(E)
        BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE WHEN INFIELD(bmy05)
#FUN-AA0059 --Begin--
                 #    CALL cl_init_qry_var()
                 #    LET g_qryparam.form = "q_ima"
                 #    LET g_qryparam.state = "c"
                 #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO bmy05
                     NEXT FIELD bmy05
                WHEN INFIELD(bmy27)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.state = "c"
                  #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO bmy27
                     NEXT FIELD bmy27
                ##---- 20221123 add (S)
                WHEN INFIELD(bmy09) #作業編號
                   CALL q_ecd( FALSE, TRUE,"") RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO bmy09
                   NEXT FIELD bmy09
                ##---- 20221123 add (E)
           END CASE
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
 
       END CONSTRUCT
 
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    END IF

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmxuser', 'bmxgrup')
 
 
    CASE WHEN g_wc2 = " 1=1" AND g_wc3 = " 1=1"
              LET g_sql = "SELECT  bmx01 FROM bmx_file",
                          " WHERE ", g_wc CLIPPED,
                          "   AND bmx06='1' ",   #No.B244 add
                          " AND bmx50='",g_argv1,"' ",       #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
                          " ORDER BY 1"
         WHEN g_wc2 <> " 1=1" AND g_wc3 = " 1=1"
              LET g_sql = "SELECT UNIQUE  bmx01 ",
                          "  FROM bmx_file, bmz_file",
                          " WHERE bmx01 = bmz01",
                          "   AND bmx06='1' ",   #No.B244 add
                          " AND bmx50='",g_argv1,"' ",       #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
                          "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                          " ORDER BY 1"
         WHEN g_wc2 = " 1=1" AND g_wc3 <> " 1=1"
              LET g_sql = "SELECT UNIQUE  bmx01 ",
                          "  FROM bmx_file, bmy_file",
                          " WHERE bmx01 = bmy01",
                          "   AND bmx06='1' ",   #No.B244 add
                          " AND bmx50='",g_argv1,"' ",       #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
                          "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                          " ORDER BY 1"
         WHEN g_wc2 <> " 1=1" AND g_wc3 <> " 1=1"
              LET g_sql = "SELECT UNIQUE  bmx01 ",
                          "  FROM bmx_file, bmy_file, bmz_file",
                          " WHERE bmx01 = bmy01 AND bmx01=bmz01",
                          "   AND bmx06='1' ",   #No.B244 add
                          " AND bmx50='",g_argv1,"' ",       #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
                          "   AND ", g_wc CLIPPED,
                          "   AND ", g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED,
                          " ORDER BY 1"
    END CASE
 
    PREPARE i710_prepare FROM g_sql
    DECLARE i710_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i710_prepare
 
    #DECLARE i710_list_cur CURSOR FOR i710_prepare    #CHI-F80014 mark                                                                                   
 
    CASE WHEN g_wc2 = " 1=1" AND g_wc3 = " 1=1"
              LET g_sql="SELECT COUNT(DISTINCT bmx01) FROM bmx_file",
                          " WHERE ", g_wc CLIPPED,
                          "   AND bmx06='1' ",    #No.B244 add
                          " AND bmx50='",g_argv1,"' "       #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
         WHEN g_wc2 <> " 1=1" AND g_wc3 = " 1=1"
              LET g_sql="SELECT COUNT(DISTINCT bmx_file.bmx01) ",
                          "  FROM bmx_file, bmz_file",
                          " WHERE bmx01 = bmz01",
                          "   AND bmx06='1' ",   #No.B244 add
                          " AND bmx50='",g_argv1,"' ",       #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
                          "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
         WHEN g_wc2 = " 1=1" AND g_wc3 <> " 1=1"
              LET g_sql="SELECT COUNT(DISTINCT bmx_file.bmx01) ",
                          "  FROM bmx_file, bmy_file",
                          " WHERE bmx01 = bmy01",
                          "   AND bmx06='1' ",   #No.B244 add
                          " AND bmx50='",g_argv1,"' ",       #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
                          "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED
         WHEN g_wc2 <> " 1=1" AND g_wc3 <> " 1=1"
              LET g_sql="SELECT COUNT(DISTINCT bmx_file.bmx01) ",
                          "  FROM bmx_file, bmy_file, bmz_file",
                          " WHERE bmx01 = bmy01 AND bmx01=bmz01",
                          "   AND bmx06='1' ",   #No.B244 add
                          " AND bmx50='",g_argv1,"' ",       #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
                          "   AND ", g_wc CLIPPED,
                          "   AND ", g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED
    END CASE
    PREPARE i710_precount FROM g_sql
    DECLARE i710_count CURSOR FOR i710_precount
END FUNCTION
 
FUNCTION i710_menu()
DEFINE l_creator      LIKE type_file.chr1    #No.FUN-680096  VARCHAR(1)
DEFINe l_flowuser     LIKE type_file.chr1    #No.FUN-680096  VARCHAR(1)
#DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-820027 #20180820 mark
DEFINE l_cmd          STRING #No.FUN-820027  #20180820 modify
   LET l_flowuser = "N"   #FUN-580120
 
   WHILE TRUE
      IF cl_null(g_bp_flag) OR g_bp_flag <> 'list' THEN     
         CALL i710_bp("G")                                                                                                          
      ELSE            
         CALL i710_list_fill()   #EA0015 add   
         CALL i710_bp1("G")                                                                                                         
      END IF                                                                                                                    
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i710_a()
               LET g_data_keyvalue = g_bmx.bmx01      #No:FUN-F50016
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i710_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i710_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i710_u()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i710_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "mntn_insert_loc"
           IF cl_chk_act_auth() THEN
              CALL i710_t()
           END IF
       #@WHEN "主件單身"
         WHEN "master_item_detail"
            IF cl_chk_act_auth() THEN
               CALL i710_d()
            END IF
       #@WHEN "元件單身"
         WHEN "component_detail"
            IF cl_chk_act_auth() THEN
               CALL i710_b()
            END IF
            #LET g_action_choice = ""  #TQC-D40054 mark
       #@WHEN "備註"
         WHEN "memo"
           #FUN-B80071 add str---
            IF g_bmx.bmx09 matches '[Ss]' THEN
               CALL cl_err('','apm-030',0)
            ELSE
           #FUN-B80071 add end---
               CALL s_abm_memo(g_bmx.bmx01,'u')
               CALL i710_bmg03()
            END IF  #FUN-B80071 add        
       #@WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL i710_x()    #CHI-D20010
               CALL i710_x(1)   #CHI-D20010
               CALL i710_field_pic()
            END IF

       #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
             # CALL i710_x()    #CHI-D20010
               CALL i710_x(2)   #CHI-D20010
               CALL i710_field_pic()
            END IF
         #CHI-D20010---end
 
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()      #No.MOD-840284 add
               CALL i710_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                   CALL i710_y_upd()      #CALL 原確認的 update 段
                   CALL i710_refresh() RETURNING g_bmx.*  #FUN-B80071
                   CALL i710_show()                       #FUN-B80071
               END IF
               CALL s_showmsg()           #No.MOD-840284 add
              CALL i710_field_pic()
            END IF
        #@WHEN "簽核狀況"
         WHEN "approval_status"
            IF cl_chk_act_auth() THEN        #DISPLAY ONLY
               IF aws_condition2() THEN                #FUN-550040
                   CALL aws_efstat2()                  #MOD-560007
               END IF
            END IF
 
         WHEN "easyflow_approval"     #FUN-550040
            IF cl_chk_act_auth() THEN
              #FUN-C20011 add str---
               SELECT * INTO g_bmx.* FROM bmx_file
                WHERE bmx01 = g_bmx.bmx01
               CALL i710_show()
               CALL i710_d_fill(' 1=1')
               CALL i710_b_fill(' 1=1')
              #FUN-C20011 add end---
               CALL i710_ef()
               CALL i710_show()  #FUN-C20011 add
            END IF
 
         #@WHEN "准"
         WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = "N" THEN #最後一關
                 CALL i710_y_upd()      #CALL 原確認的 update 段
                 CALL i710_refresh() RETURNING g_bmx.*  #FUN-B80071
                 CALL i710_show()                       #FUN-B80071
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                    IF cl_confirm('aws-081') THEN
                       IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1  #CHI-CA0035 mod g_argv1->g_argv2
                          IF NOT cl_null(g_argv2) THEN     #CHI-CA0035 mod g_argv1->g_argv2
                                CALL i710_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                               #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void,confirm, undo_confirm,easyflow_approval")  #FUN-B80071 mark
                                CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, undo_void,confirm, undo_confirm,easyflow_approval, master_item_detail, component_detail, carry, mntn_insert_loc, memo")  #FUN-B80071  #CHI-D20010 add undo_void
                                      RETURNING g_laststage
                          ELSE
                              EXIT WHILE
                          END IF
                        ELSE
                              EXIT WHILE
                        END IF
                    ELSE
                       EXIT WHILE
                    END IF
              END IF
 
         #@WHEN "不准"
         WHEN "deny"
             IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN
                IF aws_efapp_formapproval() THEN
                   IF l_creator = "Y" THEN
                      LET g_bmx.bmx09 = 'R'
                      DISPLAY BY NAME g_bmx.bmx09
                   END IF
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1  #CHI-CA0035 mod g_argv1->g_argv2
                          IF NOT cl_null(g_argv2) THEN     #CHI-CA0035 mod g_argv1->g_argv2
                                CALL i710_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                               #CALL aws_efapp_flowaction("insert, modify, delete,reproduce, detail, query, locale,void,confirm, undo_confirm,easyflow_approval")  #FUN-B80071 mark
                                CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, undo_void, confirm, undo_confirm,easyflow_approval, master_item_detail, component_detail, carry, mntn_insert_loc, memo")  #FUN-B80071   #CHI-D20010 add undo_void
                                      RETURNING g_laststage
                          ELSE
                                EXIT WHILE
                          END IF
                      ELSE
                            EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                END IF
              END IF
 
         #@WHEN "加簽"
         WHEN "modify_flow"
              IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF
 
         #@WHEN "撤簽"
         WHEN "withdraw"
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "抽單"
         WHEN "org_withdraw"
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
        #@WHEN "簽核意見"
         WHEN "phrase"
              CALL aws_efapp_phrase()
 
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmz),base.TypeInfo.create(g_bmy),'')
              #FUN-D60015---add---str---
              LET w = ui.Window.getCurrent()
              LET f = w.getForm()
              IF cl_null(g_bp_flag) OR g_bp_flag = "main" THEN
                 LET page = f.FindNode("Page","page19")
                 CALL cl_export_to_excel(page,base.TypeInfo.create(g_bmz),base.TypeInfo.create(g_bmy),'')
              END IF
              IF g_bp_flag = "list" THEN
                 LET page = f.FindNode("Page","page20")
                    CALL cl_export_to_excel(page,base.TypeInfo.create(g_bmx_l),'','')
              END IF
              #FUN-D60015---add---end---
            END IF
 
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_bmx.bmx01 IS NOT NULL THEN
                 LET g_doc.column1 = "bmx01"
                 LET g_doc.value1 = g_bmx.bmx01
                 CALL cl_doc()
               END IF
           END IF
 
         #@WHEN "主件查詢"
         WHEN "qry_mstr_item"
            IF cl_chk_act_auth() THEN
               CALL i710_bp2('G')
            ELSE
               LET g_action_choice = NULL
            END IF     
 
         WHEN "carry"                                                                                                               
            IF cl_chk_act_auth() THEN                                                                                               
               CALL ui.Interface.refresh()                                                                                          
               CALL i710_carry()                                                                                                    
               ERROR ""      
            END IF

         ##---20241108 add (S)
         WHEN "check_sub"
            IF cl_chk_act_auth() THEN
               CALL cs_check_ecn(g_bmx.bmx01)
            END IF
         ##---20241108 add (E)                                                                                                                  
                                                                                                                                    
         WHEN "download"                                                                                                            
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i710_download()                                                                                                 
            END IF                                                                                                                  
                                                                                                                                    
         WHEN "qry_carry_history"                                                                                                   
            IF cl_chk_act_auth() THEN     
               IF NOT cl_null(g_bmx.bmx01) THEN                                                                                          
                  IF NOT cl_null(g_bmx.bmx11) THEN                                                                                    
                     SELECT gev04 INTO g_gev04 FROM gev_file                                                                           
                     WHERE gev01 = '3' AND gev02 = g_bmx.bmx11                                                                      
                  ELSE      #歷史資料,即沒有bmx11的值                                                                                 
                     SELECT gev04 INTO g_gev04 FROM gev_file                                                                           
                     WHERE gev01 = '3' AND gev02 = g_plant                                                                            
                  END IF                                                                                                               
                  IF NOT cl_null(g_gev04) THEN                                                                                         
                     LET l_cmd='aooq604 "',g_gev04,'" "3" "',g_prog,'" "',g_bmx.bmx01,'"'                                              
                     CALL cl_cmdrun(l_cmd)                                                                                             
                  END IF 
               ELSE
                  CALL cl_err('',-400,0)                                                                                                                
               END IF
            END IF 
         #MOD-D10285---begin
         WHEN "qry_item_detail"
            IF l_ac > 0 THEN 
               CALL i710_b_more1()
            END IF 
         #MOD-D10285---end
         #FUN-D80022--add--str--
         WHEN "define_color_size"
            IF l_ac>0 THEN
               IF NOT cl_null(g_bmy[l_ac].bmy38) THEN
                  IF g_bmy[l_ac].bmy38 MATCHES '[234567]'  THEN  #區分
                    #BEGIN WORK                   #TQC-E90001 mark
                     CALL i710_ins_bmyx('')
                    #COMMIT WORK                  #TQC-E90001 mark
                  END IF
               END IF
            END IF 
         #FUN-D80022--add--str--
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i710_a()
DEFINE   li_result   LIKE type_file.num5      #No.FUN-680096 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_bmz.clear()
    CALL g_bmy.clear()
    CALL g_bmw.clear()
    CALL g_bmf.clear()
   #TQC-E90001--add str--
    CALL g_bmya_a.clear()
    CALL g_bmyb_b.clear()
    CALL g_bmyc_c.clear()
    CALL g_bmyd_d.clear()
   #TQC-E90001--add str--
 
    INITIALIZE g_bmx.* TO NULL
    LET g_bmx_o.* = g_bmx.*
 
    CALL cl_opmsg('a')
 
    WHILE TRUE
        LET g_bmx.bmx02  =TODAY
        LET g_bmx.bmx07  =TODAY   #No.B245 add
        LET g_bmx.bmx04  ='N'
        LET g_bmx.bmx06  ='1'     #No.B244 by linda add
        LET g_bmx.bmx11=g_plant   #No.FUN-820027
        LET g_bmx.bmxuser=g_user
        LET g_bmx.bmxoriu = g_user #FUN-980030
        LET g_bmx.bmxorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_bmx.bmxgrup=g_grup
        LET g_bmx.bmxdate=g_today
        LET g_bmx.bmxacti='Y'
        LET g_bmx.bmx09='0'   #--FUN-540045
        #LET g_bmx.bmx10=g_user     #20240816 mark 申請人不等於填單人
        LET g_bmx.ta_bmx01 = 'N'    #M014 180202 By TSD.Andy
        IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'a') THEN                                                                           
           CALL cl_err(g_bmx.bmx11,'aoo-078',1)                                                                                         
           RETURN                                                                                                                       
        END IF       
        CALL i710_bmx10('d')
        IF NOT cl_null(g_errno) THEN
           LET g_bmx.bmx10 = ''
        END IF
        
        CALL i710_bmx13('d')              #No.CHI-9C0054
        IF NOT cl_null(g_errno) THEN      #No.CHI-9C0054   
           LET g_bmx.bmx13 = ''               #No.CHI-9C0054 
        END IF                            #No.CHI-9C0054  
 
 
        IF NOT cl_null(g_argv2) AND (g_argv3 = "insert") THEN  #CHI-CA0035 mod g_argv1->g_argv2,g_argv2->g_argv3
           LET g_bmx.bmx01 = g_argv2                           #CHI-CA0035 mod g_argv1->g_argv2
        END IF
 
        LET g_bmx.bmxplant = g_plant 
        LET g_bmx.bmxlegal = g_legal 
 
        CALL i710_i("a")                #輸入單頭
        IF INT_FLAG THEN
           INITIALIZE g_bmx.* TO NULL
           LET INT_FLAG=0 CALL cl_err('',9001,0) ROLLBACK WORK EXIT WHILE
        END IF
 
        IF g_bmx.bmx01 IS NULL THEN CONTINUE WHILE END IF
 
        BEGIN WORK #No:7857
       #CALL s_auto_assign_no("abm",g_bmx.bmx01,g_bmx.bmx07,"1","bmx_file","bmx01","","","")  #MOD-A40116 mark
        CALL s_auto_assign_no("abm",g_bmx.bmx01,g_bmx.bmx02,"1","bmx_file","bmx01","","","")  #MOD-A40116
             RETURNING li_result,g_bmx.bmx01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_bmx.bmx01
        MESSAGE ""    #TQC-750146 add
 

        IF cl_null(g_bmx.bmx07) THEN
           LET g_bmx.bmx07=g_bmx.bmx02
           DISPLAY BY NAME g_bmx.bmx07
        END IF
        LET g_bmb.bmb33 = 0    #NO.FUN-840033 add
        LET g_brb.brb33 = 0    #No.FUN-A60008
        LET g_bmx.bmx50 = g_argv1 #CHI-A60028 add (bug:FUN-A60008)  #CHI-CA0035 mod g_argv3->g_argv1
        INSERT INTO bmx_file VALUES (g_bmx.*)
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#          ROLLBACK WORK #No:7857       #MOD-B80208
           CALL cl_err3("ins","bmx_file",g_bmx.bmx01,g_bmx.bmx02,SQLCA.SQLCODE,"","",1) # TQC-660046
           ROLLBACK WORK #No:7857       #MOD-B80208
           CONTINUE WHILE
        ELSE
           COMMIT WORK #No:7857
           CALL cl_flow_notify(g_bmx.bmx01,'I')
           CALL s_abm_memo(g_bmx.bmx01,'a')  #20191024
           CALL i710_show()                  #20191024
        END IF
 
        SELECT bmx01 INTO g_bmx.bmx01 FROM bmx_file WHERE bmx01 = g_bmx.bmx01
        LET g_bmx_t.* = g_bmx.*
 
        CALL g_bmz.clear()
        LET g_rec_b = 0
        LET g_rec_d = 0
 
        CALL i710_g_bmz()
        CALL i710_d()                   #輸入單身
        CALL i710_d_fill(' 1=1')
 
        CALL g_bmy.clear()
       #TQC-E90001--add str--
        CALL g_bmya_a.clear()
        CALL g_bmyb_b.clear()
        CALL g_bmyc_c.clear()
        CALL g_bmyd_d.clear()
       #TQC-E90001--add str--
        CALL i710_b()                   #輸入單身
 
        SELECT COUNT(*) INTO g_cnt FROM bmy_file WHERE bmy01=g_bmx.bmx01
        IF g_cnt>0 THEN
           CALL i710_out()
        ELSE
          #允許只key主件,就算不輸入元件明細資料也可以
           LET g_cnt = 0
           SELECT COUNT(*) INTO g_cnt FROM bmz_file WHERE bmz01=g_bmx.bmx01
           IF g_cnt=0 THEN
              CALL i710_delall()
           END IF   #FUN-640273 add
        END IF
       
       #FUN-B80071 add str----
        IF NOT cl_null(g_bmx.bmx01) AND g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y' THEN  #確認
           LET g_action_choice = "insert"

           CALL i710_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL i710_y_upd()      #CALL 原確認的 update 段
              CALL i710_refresh() RETURNING g_bmx.*
              CALL i710_show()
           END IF
        END IF
       #FUN-B80071 add end----
 
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION i710_delall()
   CALL cl_getmsg('9044',g_lang) RETURNING g_msg
 
   ERROR g_msg CLIPPED
   DELETE FROM bmx_file WHERE bmx01=g_bmx.bmx01
   IF SQLCA.SQLCODE OR STATUS THEN
      CALL cl_err3("del","bmx_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del bmx: ",1) # TQC-660046 
   ELSE
       DELETE FROM bmz_file WHERE bmz01=g_bmx.bmx01 #MOD-4A0159
      CLEAR FORM
      CALL g_bmz.clear()
      CALL g_bmy.clear()
      CALL g_bmw.clear()
      CALL g_bmf.clear()
     #TQC-E90001--add str--
      CALL g_bmya_a.clear()
      CALL g_bmyb_b.clear()
      CALL g_bmyc_c.clear()
      CALL g_bmyd_d.clear()
     #TQC-E90001--add str--
   END IF
 
END FUNCTION
 
FUNCTION i710_u()
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx.bmx01
    IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'u') THEN                                                                           
       CALL cl_err(g_bmx.bmx11,'aoo-045',1)                                                                                         
       RETURN                                                                                                                       
    END IF
    IF g_bmx.bmx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_bmx.bmx04 = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_bmx.bmx04 = 'Y'   THEN CALL cl_err('','abm-101',0) RETURN END IF      #No.TQC-740079
    IF g_bmx.bmx09 matches '[Ss]' THEN          #FUN-550040
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bmx_o.* = g_bmx.*
 
    BEGIN WORK
 
    OPEN i710_cl USING g_bmx.bmx01
    IF STATUS THEN
       CALL cl_err("OPEN i710_cl:", STATUS, 1)
       CLOSE i710_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i710_cl INTO g_bmx.*          # 鎖住將被更改或取消的資料
    IF STATUS THEN
        CALL cl_err('lock bmx:',SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE i710_cl ROLLBACK WORK RETURN
    END IF
 
    CALL i710_show()
 
    WHILE TRUE
        LET g_bmx.bmxmodu=g_user
        LET g_bmx.bmxdate=g_today
           CALL i710_i("u")
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bmx.*=g_bmx_t.*
            CALL i710_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_bmx.bmx09 = '0'        #FUN-550040
        UPDATE bmx_file SET * = g_bmx.* WHERE bmx01 = g_bmx.bmx01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","bmx_file",g_bmx_o.bmx01,g_bmx_o.bmx02,SQLCA.SQLCODE,"","upd bmx: ",1) # TQC-660046
           CONTINUE WHILE
        END IF
 
        #CALL i710_list_fill()     #CHI-EA0052 mark                                                                                                  
 
        EXIT WHILE
    END WHILE
 
    CLOSE i710_cl
    DISPLAY BY NAME g_bmx.bmx09
    CALL i710_field_pic()
 
    COMMIT WORK
    CALL cl_flow_notify(g_bmx.bmx01,'U')
 
END FUNCTION
 
FUNCTION i710_i(p_cmd)
  DEFINE p_cmd       LIKE type_file.chr1      #a:輸入 u:更改 #No.FUN-680096 VARCHAR(1)
  DEFINE l_flag      LIKE type_file.chr1      #判斷必要欄位是否有輸入   #No.FUN-680096 VARCHAR(1)
  DEFINE li_result   LIKE type_file.num5      #No.FUN-680096 SMALLINT
  DEFINE l_gem02       LIKE gem_file.gem02      #No.CHI-9C0054  
    CALL cl_set_head_visible("","YES")        #No.FUN-6B0033
    LET l_gem02 = NULL                        #No.CHI-9C0054 
    INPUT BY NAME g_bmx.bmxoriu,g_bmx.bmxorig,
        g_bmx.bmx01,g_bmx.bmx02,g_bmx.bmx07,g_bmx.bmx10,g_bmx.bmx13,#FUN-630044    #FUN-CHI9C0054 add bmx13
        g_bmx.bmx05,g_bmx.bmx04,g_bmx.bmxmksg,g_bmx.ta_bmx01,g_bmx.ta_bmx02,g_bmx.bmx09,g_bmx.bmx11,   #--FUN-540045    #FUN-820027 add g_bmx.bmx11  #M014 180202 By TSD.Andy add ta_bmx01,ta_bmx02
        g_bmx.ta_bmx03,                                             #20230208 add by momo
        g_bmx.bmxuser,g_bmx.bmxgrup,g_bmx.bmxmodu,g_bmx.bmxdate,g_bmx.bmxacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            #M014 180202 By TSD.Andy -----(S)
            CALL i710_i_set_entry(p_cmd)
            CALL i710_i_set_no_entry(p_cmd)
            #M014 180202 By TSD.Andy -----(E)
            CALL cl_set_docno_format("bmx01")
            CALL cl_set_docno_format("bmx05")
           IF p_cmd = 'u' THEN
              CALL cl_set_comp_entry("bmx01",FALSE)
           ELSE 
              CALL cl_set_comp_entry("bmx01",TRUE)
           END IF
 
        BEFORE FIELD bmx07                                                    #TQC-830036                                           
            CALL cl_err('',368,0)                                             #TQC-830036
 
        AFTER FIELD bmx01
            IF NOT cl_null(g_bmx.bmx01) THEN
 
            CALL s_field_chk(g_bmx.bmx01,'3',g_plant,'bmx01') RETURNING g_flag2                                                     
            IF g_flag2 = '0' THEN                                                                                                   
               CALL cl_err(g_bmx.bmx01,'aoo-043',1)                                                                                 
               LET g_bmx.bmx01 = g_bmx_o.bmx01                                                                                      
               DISPLAY BY NAME g_bmx.bmx01                                                                                          
               NEXT FIELD bmx01                                                                                                     
            END IF                                                                                                                  
 
            CALL s_check_no("abm",g_bmx.bmx01,g_bmx_t.bmx01,"1","bmx_file","bmx01","") RETURNING li_result,g_bmx.bmx01
            DISPLAY BY NAME g_bmx.bmx01
            IF (NOT li_result) THEN
               LET g_bmx.bmx01=g_bmx_o.bmx01
               NEXT FIELD pmw01
            END IF
                 LET g_bmx.bmxmksg=g_smy.smyapr
                 DISPLAY BY NAME g_bmx.bmxmksg
 
            END IF
 
        AFTER FIELD bmx02
            IF cl_null(g_bmx.bmx07) THEN
               LET g_bmx.bmx07=g_bmx.bmx02
            END IF
 
        AFTER FIELD bmx05
            IF NOT cl_null(g_bmx.bmx05) THEN       
               IF g_argv1 = '1' THEN         #TQC-AC0107  #CHI-CA0035 mod g_argv3->g_argv1
                  SELECT COUNT(*) INTO g_cnt FROM bmr_file
                      WHERE bmr01=g_bmx.bmx05
                        AND bmrconf= 'Y'   #FUN-950045
                        AND bmr50 = '1'      #TQC-AC0107
              #TQC-AC0107 --------add start-----------------
               ELSE                          
                  SELECT COUNT(*) INTO g_cnt FROM bmr_file 
                   WHERE bmr01=g_bmx.bmx05
                     AND bmrconf= 'Y'
                     AND bmr50 = '2'
               END IF     
              #TQC-AC0107 --------add end ---------------------
               IF g_cnt=0 THEN
                  CALL cl_err(g_bmx.bmx05,'mfg0044',0)
                  NEXT FIELD bmx05
               END IF
            END IF                                  
 
        AFTER FIELD bmx07
            IF NOT cl_null(g_bmx.bmx07) THEN
                SELECT COUNT(*) INTO g_cnt FROM bma_file
                 WHERE (bma05 IS NULL OR bma05 >g_bmx.bmx07)
                   AND bma01 IN (SELECT bmz02 FROM bmz_file
                                  WHERE bmz01=g_bmx.bmx01)
                IF g_cnt >0 THEN
                   LET g_bmx.bmx07 = g_bmx_t.bmx07
                   DISPLAY BY NAME g_bmx.bmx07
                   CALL cl_err(g_bmx.bmx07,'abm-005',0)
                   NEXT FIELD bmx07
                END IF
            END IF
        AFTER FIELD bmx10
            IF NOT cl_null(g_bmx.bmx10) THEN
               CALL i710_bmx10('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_bmx.bmx10 = g_bmx_t.bmx10
                  CALL cl_err(g_bmx.bmx10,g_errno,0)
                  DISPLAY BY NAME g_bmx.bmx10 #
                  NEXT FIELD bmx10
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.gen02
            END IF
     
        #No.CHI-9C0054 ---start---
        AFTER FIELD bmx13
            IF NOT cl_null(g_bmx.bmx13) THEN
               CALL i710_bmx13('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_bmx.bmx13 = g_bmx_t.bmx13
                  CALL cl_err(g_bmx.bmx10,g_errno,0)
                  DISPLAY BY NAME g_bmx.bmx13
                  NEXT FIELD bmx13
               END IF 
            ELSE
               DISPLAY '' TO FORMONLY.gem02
            END IF
        #No.CHI-9C0054 ---end---

        ##--- 20230208 add by momo (S) ---
        AFTER FIELD ta_bmx03
            IF NOT cl_null(g_bmx.ta_bmx03) THEN
               CALL i710_ta_bmx03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_bmx.ta_bmx03,g_errno,0)
                  NEXT FIELD ta_bmx03
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.azf03
            END IF
            CALL i710_ta_bmx03('d')
        ##--- 20230208 add by momo (E) ---

        #M014 180202 By TSD.Andy -----(S)
        ON CHANGE ta_bmx01
           IF g_bmx.ta_bmx01 = 'N' THEN
              LET g_bmx.ta_bmx02 = ''
              DISPLAY BY NAME g_bmx.ta_bmx02
           END IF
           CALL i710_i_set_entry(p_cmd)
           CALL i710_i_set_no_entry(p_cmd)

        AFTER FIELD ta_bmx02
           IF NOT cl_null(g_bmx.ta_bmx02) THEN
              IF ( g_bmx.ta_bmx02 <> g_bmx_o.ta_bmx02 ) OR cl_null(g_bmx_o.ta_bmx02) THEN
                 IF g_bmx.ta_bmx02 < 0 THEN
                    CALL cl_err('','aec-020',0)
                    LET g_bmx.ta_bmx02 = g_bmx_o.ta_bmx02
                    NEXT FIELD ta_bmx02
                 END IF
              END IF
           END IF
           LET g_bmx_o.ta_bmx02 = g_bmx.ta_bmx02
        #M014 180202 By TSD.Andy -----(E)
        
        ON ACTION controlp
          CASE WHEN INFIELD(bmx01) #查詢單据

                    LET g_t1=s_get_doc_no(g_bmx.bmx01)
                    CALL q_smy(FALSE,TRUE,g_t1,'ABM','1') RETURNING g_t1 #TQC-670008
                    LET g_bmx.bmx01=g_t1
                    DISPLAY BY NAME g_bmx.bmx01
                    NEXT FIELD bmx01
               WHEN INFIELD(bmx05) #查詢ECR
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_bmr"        #No.TQC-A30027
                    LET g_qryparam.form = "q_bmr1"       #No.TQC-A30027
                   #TQC-AC0171 --------add start-----
                    IF g_argv1 = '1' THEN                #CHI-CA0035 mod g_argv3->g_argv1
                       LET g_qryparam.where = " bmr50 = '1' "
                    ELSE
                       LET g_qryparam.where = " bmr50 = '2' "
                    END IF
                   #TQC-AC0171 --------add end---------
                    LET g_qryparam.default1 = g_bmx.bmx05
                    CALL cl_create_qry() RETURNING g_bmx.bmx05
                    DISPLAY BY NAME g_bmx.bmx05
                    NEXT FIELD bmx05
               WHEN INFIELD(bmx10)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.default1 = g_bmx.bmx10
                    CALL cl_create_qry() RETURNING g_bmx.bmx10
                    DISPLAY BY NAME g_bmx.bmx10
                    NEXT FIELD bmx10

               #No.CHI-9C0054 ---start---
               WHEN INFIELD(bmx13)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_bmx.bmx13
                    CALL cl_create_qry() RETURNING g_bmx.bmx13
                    DISPLAY BY NAME g_bmx.bmx13
                    NEXT FIELD bmx13
               #No.CHI-9C0054 ---end---   

               ##--- 20230208 ---(S)---
               WHEN INFIELD(ta_bmx03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azf01a"
                    LET g_qryparam.arg1 = "G"
                    LET g_qryparam.default1 = g_bmx.ta_bmx03
                    CALL cl_create_qry() RETURNING g_bmx.ta_bmx03
                    DISPLAY BY NAME g_bmx.ta_bmx03
                    NEXT FIELD ta_bmx03
               ##--- 20230208 ---(E)---
 
          END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
 
END FUNCTION
 
FUNCTION i710_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    INITIALIZE g_bmx.* TO NULL                   #No.FUN-6A0002
    CALL cl_msg("")                              #FUN-640241
 
    DISPLAY ' ' TO FORMONLY.cnt
    CALL i710_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_bmx.* TO NULL
       RETURN
    END IF
 
    CALL cl_msg(" SEARCHING ! ")                              #FUN-640241
 
    OPEN i710_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bmx.* TO NULL
    ELSE
        OPEN i710_count
        FETCH i710_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        #CALL i710_list_fill()          #No.FUN-820027     #CHI-EA0015 mark                                                                                 
        LET g_bp_flag = NULL                                  #CHI-880031
        CALL i710_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")                              #FUN-640241
 
END FUNCTION
 
FUNCTION i710_list_fill()                                                                                                           
  DEFINE l_bmx01         LIKE bmx_file.bmx01                                                                                        
  DEFINE l_i             LIKE type_file.num10                                                                                       
                                                                                             #No.TQC-940183
                                                                                                                                    
    CALL g_bmx_l.clear()                                                                                                            
    LET l_i = 1                                                                                                                     
    #FOREACH i710_list_cur INTO l_bmx01               #CHI-F80014 mark
    FOREACH i710_cs INTO l_bmx01                      #CHI-F80014 add                                                                                      
       IF SQLCA.sqlcode THEN                                                                                                        
          CALL cl_err('foreach list_cur',SQLCA.sqlcode,1)                                                                           
          CONTINUE FOREACH                                                                                                          
       END IF                                                                                                                       
       SELECT bmx01,bmx07,bmx10,bmx13,bmx05,'',bmx11        #No.CHI-9C0054 add bmx13                                                                           
         INTO g_bmx_l[l_i].*                                                                                                        
         FROM bmx_file                                                                                              
        WHERE bmx01=l_bmx01
       SELECT bmg03                                                                                   
         INTO g_bmx_l[l_i].bmg03                                                                                                        
         FROM bmg_file                                                                                               
        WHERE bmg01=l_bmx01                                                                                       
       LET l_i = l_i + 1                                                                                                            
       IF l_i > g_max_rec THEN                                                                                                      
          CALL cl_err( '', 9035, 0 )                                                                                                
          EXIT FOREACH                                                                                                              
       END IF                                                                                                                       
    END FOREACH
    OPEN i710_cs                                      #CHI-F80014 add
    LET g_rec_b1 = l_i - 1                                           
    DISPLAY g_rec_b1 TO FORMONLY.cnt                  #CHI-F80014 add                                                               
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN        #MOD-B10090 add
       DISPLAY ARRAY g_bmx_l TO s_bmx_1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)                                                         
          BEFORE DISPLAY                                                                                                               
             EXIT DISPLAY                                                                                                              
       END DISPLAY                                                                                                                     
    END IF                                         #MOD-B10090 add                                                                                                                                
END FUNCTION                                                                                                                        
 
FUNCTION i710_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1      #處理方式   #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i710_cs INTO g_bmx.bmx01
        WHEN 'P' FETCH PREVIOUS i710_cs INTO g_bmx.bmx01
        WHEN 'F' FETCH FIRST    i710_cs INTO g_bmx.bmx01
        WHEN 'L' FETCH LAST     i710_cs INTO g_bmx.bmx01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i710_cs INTO g_bmx.bmx01
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bmx.bmx01,SQLCA.sqlcode,0)
       INITIALIZE g_bmx.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx.bmx01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","bmx_file",g_bmx.bmx01,"",SQLCA.sqlcode,"","",1) # TQC-660046
       INITIALIZE g_bmx.* TO NULL
       RETURN
    ELSE
        LET g_data_owner = g_bmx.bmxuser      #FUN-4C0054
        LET g_data_group = g_bmx.bmxgrup      #FUN-4C0054
        LET g_data_plant = g_bmx.bmxplant     #FUN-980030
        LET g_data_keyvalue = g_bmx.bmx01     #FUN-DA0124 add
    END IF
 
    CALL i710_show()
 
END FUNCTION
 
FUNCTION i710_show()
    DEFINE w     ui.Window                 #20241115 
    DEFINE n     om.DomNode                #20241115
    DEFINE l_cnt LIKE type_file.num5       #20241115

    LET g_bmx_t.* = g_bmx.*                #保存單頭舊值
    LET g_data_keyvalue = g_bmx.bmx01      #No:FUN-F50016
    DISPLAY BY NAME g_bmx.bmxoriu,g_bmx.bmxorig,
        g_bmx.bmx01,g_bmx.bmx02,g_bmx.bmx07,g_bmx.bmx10,g_bmx.bmx13,#FUN-630044   #CHI-9C0054
        g_bmx.bmx05,g_bmx.bmx04,g_bmx.bmxmksg,g_bmx.ta_bmx01,g_bmx.ta_bmx02,g_bmx.bmx09,g_bmx.bmx11,   #FUN-540045   #FUN-820027 add g_bmx.bmx11   #M014 180202 By TSD.Andy add ta_bmx01,ta_bmx02
        g_bmx.ta_bmx03,                                             #20230208 add
        g_bmx.bmxuser,g_bmx.bmxgrup,g_bmx.bmxmodu,g_bmx.bmxdate,g_bmx.bmxacti
 

    CALL i710_bmg03() #01/08/13 mandy
    CALL i710_field_pic()   #FUN-540045
    CALL i710_bmx10('d')                      #FUN-630044  
    CALL i710_bmx13('d')                      #CHI-9C0054
    CALL i710_ta_bmx03('d')                   #20230208 
    CALL i710_d_fill(g_wc2)
    CALL i710_b_fill(g_wc3)                   #TQC-7A0027
 
   #TQC-E90001--mark str--
   ##FUN-D80022 ----Begin----
   #IF s_industry('slk') AND g_sma.sma150 = 'Y' AND l_ac>0 THEN
   #   CALL i710_b_fill_slk()
   #END IF
   ##FUN-D80022 ----End------
   #TQC-E90001--mark end--
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i710_bmg03()
    DEFINE l_bmg	RECORD LIKE bmg_file.*
 
    DECLARE i710_show_c CURSOR FOR
       SELECT * FROM bmg_file WHERE bmg01=g_bmx.bmx01 ORDER BY 2
    LET g_msg=NULL
 
    FOREACH i710_show_c INTO l_bmg.*
      SELECT tc_dic05 INTO l_bmg.ta_bmg01 FROM tc_dic_file                          #20240814 增加說明
        WHERE tc_dic01='abmi701' AND tc_dic04=l_bmg.ta_bmg01                        #20240814
       #LET g_msg=g_msg CLIPPED,l_bmg.bmg03                                         #20240814 mark
       LET g_msg=g_msg CLIPPED,l_bmg.bmg02," :",l_bmg.ta_bmg01,"_",l_bmg.bmg03,"\n" #20240814 重組
    END FOREACH
 
    DISPLAY g_msg TO bmg03_display
 
END FUNCTION
 
FUNCTION i710_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_bmx.bmx01 IS NULL THEN                    
       CALL cl_err("",-400,0)                  #No.FUN-6A0002
       RETURN 
    END IF   
 
    SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx.bmx01
    IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'r') THEN                                                                           
       CALL cl_err(g_bmx.bmx11,'aoo-044',1)                                                                                         
       RETURN                                                                                                                       
    END IF                                                                                                                          
    IF g_bmx.bmx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_bmx.bmx04 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_bmx.bmx04 = 'Y' THEN CALL cl_err('','abm-101',0) RETURN END IF      #No.TQC-740079
    IF g_bmx.bmx09 matches '[Ss1]' THEN          #FUN-550040
         CALL cl_err('','mfg3557',0)
         RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i710_cl USING g_bmx.bmx01
    IF STATUS THEN
       CALL cl_err("OPEN i710_cl:", STATUS, 1)
       CLOSE i710_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i710_cl INTO g_bmx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bmx.bmx01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL i710_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bmx01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bmx.bmx01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete bmx,bmz,bmy,bmg!"
        DELETE FROM bmx_file WHERE bmx01 = g_bmx.bmx01
           IF STATUS THEN
              CALL cl_err3("del","bmx_file",g_bmx.bmx01,"",STATUS,"","del bmx",1) # TQC-660046
              ROLLBACK WORK RETURN
           END IF
           IF SQLCA.SQLERRD[3]=0 THEN
              CALL cl_err3("del","bmx_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","No del bmx",1) # TQC-660046
              ROLLBACK WORK RETURN
           END IF
        DELETE FROM bmy_file WHERE bmy01 = g_bmx.bmx01
            IF STATUS THEN
               CALL cl_err3("del","bmy_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del bmy: ",1) # TQC-660046
               ROLLBACK WORK RETURN
            END IF
        DELETE FROM bmz_file WHERE bmz01 = g_bmx.bmx01
            IF STATUS THEN
               CALL cl_err3("del","bmz_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del bmz: ",1) # TQC-660046
               ROLLBACK WORK RETURN
            END IF
        DELETE FROM bmg_file WHERE bmg01 = g_bmx.bmx01
            IF STATUS THEN
                CALL cl_err3("del","bmg_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del bmg:",1) # TQC-660046
               ROLLBACK WORK RETURN
            END IF
        DELETE FROM bmw_file WHERE bmw01 = g_bmx.bmx01
            IF STATUS THEN
               CALL cl_err3("del","bmw_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del bmw: ",1) # TQC-660046
               ROLLBACK WORK RETURN
            END IF
       #FUN-F50035 add str----
        IF g_sma.sma901 = 'Y' THEN  #與APS整合
           DELETE FROM vlr_file WHERE vlr00 = g_bmx.bmx01
               IF STATUS THEN
                  CALL cl_err3("del","vlr_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del vlr: ",1) 
                  ROLLBACK WORK RETURN
               END IF
           DELETE FROM vls_file WHERE vls00 = g_bmx.bmx01
               IF STATUS THEN
                  CALL cl_err3("del","vls_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del vls: ",1) 
                  ROLLBACK WORK RETURN
               END IF
        END IF
       #FUN-F50035 add end----
        #刪除時一併刪除子表bmya_file/bmyb_file/bmyc_file/bmyd_file
        #FUN-D80022 --------Begin--------
        IF s_industry('slk') AND g_sma.sma150 = 'Y' THEN
           DELETE FROM bmya_file WHERE bmya01 = g_bmx.bmx01
           IF STATUS THEN
              CALL cl_err3("del","bmya_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del bmya: ",1)
              ROLLBACK WORK RETURN
           END IF
           DELETE FROM bmyb_file WHERE bmyb01 = g_bmx.bmx01
           IF STATUS THEN
              CALL cl_err3("del","bmyb_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del bmyb: ",1)
              ROLLBACK WORK RETURN
           END IF
           DELETE FROM bmyc_file WHERE bmyc01 = g_bmx.bmx01
           IF STATUS THEN
              CALL cl_err3("del","bmyc_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del bmyc: ",1)
              ROLLBACK WORK RETURN
           END IF
           DELETE FROM bmyd_file WHERE bmyd01 = g_bmx.bmx01
           IF STATUS THEN
              CALL cl_err3("del","bmyd_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del bmyd: ",1)
              ROLLBACK WORK RETURN
           END IF
        END IF      
        #FUN-D80022 --------End----------
        #LET g_msg=TIME  #FUN-DA0126
        #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)    #FUN-980001 add plant & legal  #FUN-DA0126
        #   VALUES ('abmi710',g_user,g_today,g_msg,g_bmx.bmx01,'delete',g_plant,g_legal)#FUN-980001 add plant & legal  #FUN-DA0126
        CLEAR FORM
        CALL g_bmz.clear()
        CALL g_bmy.clear()
        CALL g_bmw.clear()
        CALL g_bmf.clear()
       #TQC-E90001--add str--
        CALL g_bmya_a.clear()
        CALL g_bmyb_b.clear()
        CALL g_bmyc_c.clear()
        CALL g_bmyd_d.clear()
       #TQC-E90001--add str--
    	INITIALIZE g_bmx.* TO NULL
        OPEN i710_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i710_cs  
             CLOSE i710_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        FETCH i710_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i710_cs  
             CLOSE i710_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i710_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i710_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL i710_fetch('/')
        END IF
        MESSAGE ""
    END IF
    CLOSE i710_cl
    COMMIT WORK
    CALL cl_flow_notify(g_bmx.bmx01,'D')
END FUNCTION
 
FUNCTION i710_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   #No.FUN-680096 SMALLINT
    l_row,l_col     LIKE type_file.num5,     #No.FUN-680096  SMALLINT
    l_n,l_cnt       LIKE type_file.num5,     #檢查重複用  #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態    #No.FUN-680096 VARCHAR(1)
   #l_b2            LIKE type_file.chr1000,  #No.FUN-680096  VARCHAR(30) #20180820
    l_b2            STRING,                  #No.FUN-680096  VARCHAR(30) #20180820
    l_n1,l_n2       LIKE type_file.num5,     #No.FUN-680096  SMALLINT
    l_n3,l_n4       LIKE type_file.num5,     #No.FUN-680096  SMALLINT
    l_bmz02         LIKE bmz_file.bmz02,
    l_bmz05         LIKE bmz_file.bmz05,     #FUN-550014 add
    l_allow_insert  LIKE type_file.num5,     #可新增否   #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5,     #可刪除否   #No.FUN-680096 SMALLINT
    l_bmx09         LIKE bmx_file.bmx09,
    l_bmy05         LIKE bmy_file.bmy05      #No.MOD-550047
DEFINE  l_chkinsitm    LIKE type_file.num5   #no.FUN-840033 add
DEFINE l_errno      LIKE type_file.chr10     #No.MOD-840645 add
DEFINE l_chr        LIKE type_file.chr1      #No.MOD-970032 add
DEFINE l_bma01      LIKE bma_file.bma01      #No.MOD-970032 add
DEFINE l_bmy16      LIKE bmy_file.bmy16      #CHI-960004
DEFINE l_sql        STRING                   #No.FUN-A60008
DEFINE l_sql1       STRING                   #No.FUN-A60008
DEFINE l_bmz011     LIKE bmz_file.bmz011     #No.FUN-A60008 
DEFINE l_bmz012     LIKE bmz_file.bmz012     #No.FUN-A60008 
DEFINE l_bmz013     LIKE bmz_file.bmz013     #No.FUN-A60008 
DEFINE cb             ui.ComboBox
DEFINE comb_value   STRING                   #MOD-AC0029 add
DEFINE comb_item    STRING                   #MOD-AC0029 add
DEFINE l_ima08      LIKE ima_file.ima08      #CHI-E80001 add
DEFINE l_vlr03      LIKE vlr_file.vlr03      #FUN-F50035 add
DEFINE l_ima910     LIKE ima_file.ima910     #MOD-H10002 add
DEFINE l_bma05      LIKE bma_file.bma05      #MOD-H10002 add

    LET g_action_choice = ""
    
    #MOD-E60073--begin
    IF cl_null(g_bmy[1].bmy02) THEN
       CALL g_bmy.clear() 
      #TQC-E90001--add str--
       CALL g_bmya_a.clear()
       CALL g_bmyb_b.clear()
       CALL g_bmyc_c.clear()
       CALL g_bmyd_d.clear()
      #TQC-E90001--add str--
    END IF 
    #MOD-E60073--end
    SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx.bmx01
    IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'u') THEN                                                                           
       CALL cl_err(g_bmx.bmx11,'aoo-045',1)                                                                                         
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_bmx09 = g_bmx.bmx09                #FUN-550040
    IF g_bmx.bmx01 IS NULL THEN RETURN END IF
    IF g_bmx.bmx04 = 'Y' THEN CALL cl_err('','abm-101',0) RETURN END IF      #No.TQC-740079
    IF g_bmx.bmx04 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_bmx.bmx09 matches '[Ss]' THEN       #FUN-550040
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM bmz_file WHERE bmz01=g_bmx.bmx01
    IF l_cnt = 0 THEN
       CALL cl_err('','mfg-063',1)   #主件單身資料未輸入, 不可輸入元件單身!
       RETURN
    END IF
    IF g_argv1='2' THEN              #CHI-CA0035 mod g_argv3->g_argv1
#      CALL cl_set_combo_items("bmy03","1,2,3","Old Void,New Compo Eff,Mdf O.Comp")
       LET cb = ui.ComboBox.forName("bmy03")
       CALL cb.removeItem('4')
       CALL cb.removeItem('5')
    END IF 
    CALL cl_opmsg('b')
    IF g_argv1='2' THEN              #CHI-CA0035 mod g_argv3->g_argv1
      CALL cl_set_comp_visible('bmy16',FALSE) 
    END IF 
    LET g_forupd_sql = " SELECT * FROM bmy_file ",
                       "  WHERE bmy01= ?  AND bmy02= ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i710_bcl CURSOR FROM g_forupd_sql         # LOCK CURSOR
 
    LET l_ac_t = 0
 
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_bmy WITHOUT DEFAULTS FROM s_bmy.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
           #TQC-E90001--add str--
            LET g_bmy02_t = g_bmy[l_ac].bmy02
            LET g_bmy05_t1 = g_bmy[l_ac].bmy05
            LET g_bmy38_t = g_bmy[l_ac].bmy38
           #TQC-E90001--add end--
           #CHI-C20060---begin
            IF g_bmy[l_ac].bmy03 = '6' THEN
               CALL cl_set_comp_entry("bmy16,bmy35,bmy30",FALSE)
               CALL cl_set_comp_required("bmy06,bmy07",TRUE)
               CALL cl_set_comp_entry("bmy36",TRUE)                   #CHI-DC0015 add
            ELSE
               CALL cl_set_comp_entry("bmy16,bmy35,bmy30",TRUE)
               CALL cl_set_comp_required("bmy06,bmy07",FALSE)
               CALL cl_set_comp_entry("bmy36",FALSE)                  #CHI-DC0015 add
            END IF  
           #CHI-C20060---end
           #-----------------------CHI-DC0015-------------------(S)
            IF cl_null(g_bmy[l_ac].bmy36) THEN
               CALL cl_set_comp_entry("bmy06,bmy07",TRUE)
            ELSE
               CALL cl_set_comp_entry("bmy06,bmy07",FALSE)
            END IF
           #-----------------------CHI-DC0015-------------------(E)
           
	    BEGIN WORK
            OPEN i710_cl USING g_bmx.bmx01
            IF STATUS THEN
               CALL cl_err("OPEN i710_cl:", STATUS, 1)
               CLOSE i710_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i710_cl INTO g_bmx.*  # 鎖住將被更改或取消的資料
            IF STATUS THEN
               CALL cl_err('lock bmx:',SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE i710_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_bmy_t.* = g_bmy[l_ac].*  #BACKUP
               LET g_bmy_o.* = g_bmy[l_ac].*  #TQC-E90001
               LET p_cmd='u'
               OPEN i710_bcl USING g_bmx.bmx01,g_bmy_t.bmy02
               IF STATUS THEN
                  CALL cl_err("OPEN i710_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i710_bcl INTO b_bmy.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock bmy',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL i710_b_move_to()
                     CALL i710_bmy27('d')
                  END IF
               END IF
               LET g_before_input_done=FALSE
               CALL i710_set_entry_b(p_cmd)
               CALL i710_set_no_entry_b(p_cmd)
               LET g_before_input_done=TRUE
               LET g_bmy_t.* = g_bmy[l_ac].*  #BACKUP
               LET g_bmy_o.* = g_bmy[l_ac].*  #CHI-C10032 add
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
         #FUN-D80022 ------Begin------
         IF s_industry('slk') AND g_sma.sma150 = 'Y' THEN
            IF l_ac <> 0 THEN
               CALL i710_b_fill_slk()
               CALL i710_bp_refresh_slk()
            END IF
         LET l_action = ' '                   #TQC-E90001
         END IF
         #FUN-D80022 ------End--------
             LET g_before_input_done = FALSE
             CALL i710_set_entry_b(p_cmd)
             CALL i710_set_no_entry_b(p_cmd)
             LET g_before_input_done = TRUE
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bmy[l_ac].* TO NULL      #900423
            INITIALIZE b_bmy.* TO NULL
            LET g_bmy_t.* = g_bmy[l_ac].*
            LET g_bmy_o.* = g_bmy[l_ac].*  #MOD-FA0119 add
            
            LET g_bmy[l_ac].bmy06 = 1      #No.MOD-770126 modify
            LET g_bmy[l_ac].bmy07 = 1
            LET g_bmy[l_ac].bmy34 = 'N'   #TQC-9B0163 add
            #No.FUN-A60008--begin
            IF g_argv1='2' THEN           #CHI-CA0035 mod g_argv3->g_argv1
               LET g_bmy[l_ac].bmy16='0'     
            END IF 
            #No.FUN-A60008--end 
            IF g_sma.sma118 != 'Y' THEN
                LET g_bmy[l_ac].bmy30 = ' '
            ELSE
                LET g_bmy[l_ac].bmy30 = '1'
            END IF
            LET b_bmy.bmy01=g_bmx.bmx01
            INITIALIZE g_bmy_t.* TO NULL
 
            #FUN-D80022 ------Begin------
            IF s_industry('slk') AND g_sma.sma150 = 'Y' THEN
               CALL g_bmya_a.clear()
               CALL g_bmyb_b.clear()
               CALL g_bmyc_c.clear()
               CALL g_bmyd_d.clear()
               IF l_ac <> 0 THEN
                  CALL i710_bp_refresh_slk()
               END IF
               LET l_action = ' '          #TQC-E90001
            END IF
            #FUN-D80022 ------End--------
            LET g_before_input_done=FALSE
            CALL i710_set_entry_b(p_cmd)
            CALL i710_set_no_entry_b(p_cmd)
            LET g_before_input_done=TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            LET g_bmy_o.bmy02 = g_bmy[l_ac].bmy02  #MOD-FA0119 add
            NEXT FIELD bmy02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
               CALL g_bmy.deleteElement(l_ac)   #取消 Array Element
               IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
               EXIT INPUT
            END IF
 
            CALL i710_b_move_back()
 
            IF b_bmy.bmy03 MATCHES '[2345]' THEN    #CHI-960004 add 5
               LET g_flag3 = 'Y'         #MOD-D90028 add
               CALL i710_b_more('w') #No:7826      #No.MOD-670125 modify
               LET g_flag3 = 'N'         #MOD-D90028 add
            END IF
            IF b_bmy.bmy03 MATCHES '[2456]' THEN    #No.MOD-840026 add #CHI-960004 add 5 #CHI-C20060
               IF cl_null(b_bmy.bmy23) THEN LET b_bmy.bmy23 = 0 END IF #FUN-560201
            END IF                                #No.MOD-840026 add
            LET b_bmy.bmy33 = 0                    #NO.FUN-840033 add
            LET b_bmy.bmy34 = g_bmy[l_ac].bmy34    #no.MOD-840426            
 
            LET b_bmy.bmyplant = g_plant 
            LET b_bmy.bmylegal = g_legal 
 
#FUN-A70125 --begin--
            IF cl_null(b_bmy.bmy012) THEN
               LET b_bmy.bmy012 = ' ' 
            END IF 
            IF cl_null(b_bmy.bmy013) THEN
               LET b_bmy.bmy013 = 0 
            END IF
#FUN-A70125 --end--
            IF cl_null(b_bmy.bmy38) THEN LET b_bmy.bmy38 = ' ' END IF  #FUN-D80022
            INSERT INTO bmy_file VALUES(b_bmy.*)

            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","bmy_file",b_bmy.bmy01,"",SQLCA.sqlcode,"","ins bmy",1) # TQC-660046
               ROLLBACK WORK
               CANCEL INSERT
               LET g_bmy[l_ac].* = g_bmy_t.*
            ELSE 
              #FUN-F50035 add start ---
               IF g_sma.sma901 = 'Y' THEN  #與APS整合
                 #若該料件在BOM無重複則bmy04無須有值,故給予預設值
                  IF cl_null(g_bmy[l_ac].bmy04) THEN
                     LET l_vlr03 = 0 
                  ELSE 
                     LET l_vlr03 = g_bmy[l_ac].bmy04
                  END IF

                  IF g_bmy[l_ac].bmy03 = '4' THEN
                     INSERT INTO vlr_file (vlr00,vlr01,vlr02,vlr03,vlr19,
                                           vlr13,vlr16,vlr17,vlr18)
                     VALUES(g_bmx.bmx01,g_bmz[1].bmz02,g_bmy[l_ac].bmy27,l_vlr03,g_bmy[l_ac].bmy02,
                            g_bmy[l_ac].vlr13,g_bmy[l_ac].vlr16,g_bmy[l_ac].vlr17,g_bmy[l_ac].vlr18)
                  ELSE  
                     INSERT INTO vlr_file (vlr00,vlr01,vlr02,vlr03,vlr19,
                                           vlr13,vlr16,vlr17,vlr18)
                     VALUES(g_bmx.bmx01,g_bmz[1].bmz02,g_bmy[l_ac].bmy05,l_vlr03,g_bmy[l_ac].bmy02,
                            g_bmy[l_ac].vlr13,g_bmy[l_ac].vlr16,g_bmy[l_ac].vlr17,g_bmy[l_ac].vlr18)
                  END IF
   
                  IF SQLCA.SQLCODE THEN
                     CALL cl_err3("ins","vlr_file",b_bmy.bmy01,"",SQLCA.sqlcode,"","ins vlr",1) 
                     ROLLBACK WORK
                     CANCEL INSERT
                     LET g_bmy[l_ac].* = g_bmy_t.*
                  ELSE
                    #若APS替代比率為空則不需INSERT vls_file
                     IF NOT(cl_null(g_bmy[l_ac].vls11)) AND g_bmy[l_ac].vls11 <> 0 THEN 
                        IF g_bmy[l_ac].bmy03 = '4' THEN
                           INSERT INTO vls_file (vls00,vls01,vls02,vls03,
                                                 Vls12,vls11)
                           VALUES(g_bmx.bmx01,g_bmz[1].bmz02,g_bmy[l_ac].bmy27, g_bmy[l_ac].bmy05,
                                  g_bmy[l_ac].bmy02,g_bmy[l_ac].vls11)
                        ELSE
                           INSERT INTO vls_file (vls00,vls01,vls02,vls03,
                                                 vls12,vls11)
                           VALUES(g_bmx.bmx01,g_bmz[1].bmz02,g_bmy[l_ac].bmy05, g_bmy[l_ac].bmy27,
                                  g_bmy[l_ac].bmy02,g_bmy[l_ac].vls11)
                        END IF                      

                        IF SQLCA.SQLCODE THEN
                           CALL cl_err3("ins","vls_file",b_bmy.bmy01,"",SQLCA.sqlcode,"","ins vls",1) 
                           ROLLBACK WORK
                           CANCEL INSERT
                           LET g_bmy[l_ac].* = g_bmy_t.*
                        END IF
                     END IF
                  END IF
               END IF
              #FUN-F50035 add end ---

               MESSAGE 'INSERT O.K'
               LET l_bmx09 = '0'          #FUN-550040
               #MOD-D50159---begin
               UPDATE bmx_file SET bmxmodu = g_user,bmxdate = g_today,bmx09 = l_bmx09
                WHERE bmx01 = g_bmx.bmx01
               LET g_bmx.bmx09 = l_bmx09
               DISPLAY BY NAME g_bmx.bmx09
               #MOD-D50159---end
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
              #IF g_ima107='Y' AND g_bmy[l_ac].bmy03 MATCHES '[23456]' THEN #CHI-960004 add 5 #CHI-C20060  #MOD-G90032 mark
               IF g_ima107='Y' AND g_bmy[l_ac].bmy03 MATCHES '[23]'    THEN #CHI-960004 add 5 #CHI-C20060  #MOD-G90032 add
                  CALL i710_t()
               END IF
               COMMIT WORK
            END IF
 
        BEFORE FIELD bmy02                            #default 序號
            IF g_bmy[l_ac].bmy02 IS NULL OR g_bmy[l_ac].bmy02 = 0 THEN
               SELECT max(bmy02)+1 INTO g_bmy[l_ac].bmy02
                FROM bmy_file WHERE bmy01 = g_bmx.bmx01
               IF g_bmy[l_ac].bmy02 IS NULL THEN
                  LET g_bmy[l_ac].bmy02 = 1
               END IF
               LET g_bmy_o.bmy02 = g_bmy[l_ac].bmy02 #MOD-FA0119 add
            END IF
 
        AFTER FIELD bmy02                        #check 序號是否重複
            IF NOT cl_null(g_bmy[l_ac].bmy02) THEN
               LET g_bmy02_t = 0                           #TQC-E90001 
               LET g_bmy02_t = g_bmy[l_ac].bmy02           #TQC-E90001
               IF g_bmy[l_ac].bmy02 != g_bmy_t.bmy02 OR
                  g_bmy_t.bmy02 IS NULL THEN
                  SELECT count(*) INTO l_n FROM bmy_file
                   WHERE bmy01 = g_bmx.bmx01 AND bmy02 = g_bmy[l_ac].bmy02
                  IF l_n > 0 THEN
                     LET g_bmy[l_ac].bmy02 = g_bmy_t.bmy02
                     CALL cl_err('',-239,0) NEXT FIELD bmy02
                  END IF
               END IF
            END IF

           #MOD-FA0119--add--start---------------------
            IF g_bmy[l_ac].bmy02 != g_bmy_o.bmy02 THEN
               IF g_sma.sma150 = 'Y' THEN
                  CALL i710_upd_bmyc_slk(g_bmy[l_ac].bmy05,g_bmy[l_ac].bmy38,g_bmy[l_ac].bmy02,g_bmy_o.bmy02)
               END IF
            END IF
            LET g_bmy_o.bmy02 = g_bmy[l_ac].bmy02
           #MOD-FA0119--add--end----------------------- 
 
        BEFORE FIELD bmy03
            CALL i710_set_entry_b(p_cmd)
 
        AFTER FIELD bmy03
            IF NOT cl_null(g_bmy[l_ac].bmy03) THEN
               IF g_bmy[l_ac].bmy03 != g_bmy_t.bmy03 OR g_bmy_t.bmy03 IS NULL THEN  #TQC-AC0161
                   IF g_bmy[l_ac].bmy03 NOT MATCHES '[123456]'THEN #CHI-960004 add 5 #CHI-C20060
                      NEXT FIELD bmy03
                   END IF
                   IF g_bmy[l_ac].bmy03 !='4' THEN
                      LET g_bmy[l_ac].bmy27 = ''
                      LET g_bmy[l_ac].ima02n = ''
                      LET g_bmy[l_ac].vls11 = ''          #FUN-F50035 add
                      DISPLAY BY NAME g_bmy[l_ac].bmy27
                      DISPLAY BY NAME g_bmy[l_ac].ima02n
                      DISPLAY BY NAME g_bmy[l_ac].vls11   #FUN-F50035 add
                   END IF
                   
                   IF g_bmy[l_ac].bmy03 MATCHES '[3]' THEN
                      LET g_bmy[l_ac].bmy06 = ''
                      LET g_bmy[l_ac].bmy07 = ''
                      LET g_bmy[l_ac].bmy22 = ''
                      LET g_bmy[l_ac].bmy34 = 'N'  #TQC-9B0163 add
                      DISPLAY BY NAME g_bmy[l_ac].bmy06
                      DISPLAY BY NAME g_bmy[l_ac].bmy07
                      DISPLAY BY NAME g_bmy[l_ac].bmy22
                      DISPLAY BY NAME g_bmy[l_ac].bmy34
                   END IF
               #CHI-DC0019-Mark-Start
               #因插件位置開窗會抓不到值，故MARK     
               ##MOD-D30036-start-add
               #   IF g_bmy[l_ac].bmy03 <> '3' THEN         
               #      LET g_bmy[l_ac].bmy06 = ''
               #      DISPLAY BY NAME g_bmy[l_ac].bmy06 
               #   END IF
               ##MOD-D30036-end-add
               #CHI-DC0019-Mark-End 
               LET g_bmy_t.bmy06 = g_bmy[l_ac].bmy06 #CHI-DC0019 add
               END IF                                                             #TQC-AC0161
            END IF
           #IF g_bmy[l_ac].bmy03 != g_bmy_t.bmy03 OR g_bmy_t.bmy03 IS NULL THEN   #CHI-C10032 mark
            IF g_bmy[l_ac].bmy03 != g_bmy_o.bmy03 OR g_bmy_o.bmy03 IS NULL THEN   #CHI-C10032 add
               LET g_bmy[l_ac].bmy05 = NULL
               DISPLAY BY NAME g_bmy[l_ac].bmy05
               #M014 180202 By TSD.Andy -----(S)
               IF g_bmy[l_ac].bmy03 = '4' THEN
                  LET g_bmy[l_ac].bmy06 = ''
                  LET g_bmy[l_ac].bmy07 = ''
                  DISPLAY BY NAME g_bmy[l_ac].bmy06,g_bmy[l_ac].bmy07
               END IF
               #M014 180202 By TSD.Andy -----(E)
            END IF
            #FUN-D80022--add--str--
            IF g_bmy[l_ac].bmy03 MATCHES '[23]' THEN 
              #LET g_bmy[l_ac].bmy34 = '0'   #MOD-E40001 mark
               LET g_bmy[l_ac].bmy34 = 'N'   #MOD-E40001 add
            END IF 
            #FUN-D80022--add--end--
            CALL i710_set_no_entry_b(p_cmd)
            LET g_bmy_o.bmy03 = g_bmy[l_ac].bmy03     #CHI-C10032 add
 
           AFTER FIELD bmy04
              IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
                 IF g_bmy[l_ac].bmy03 = '2' THEN
                    CALL i710_chk_bmb() RETURNING l_errno
                    IF NOT cl_null(l_errno) THEN
                       CALL cl_err('',l_errno,1)
                       NEXT FIELD bmy04
                    END IF
                 END IF
              END IF
 
        BEFORE FIELD bmy05
           IF cl_null(g_bmy[l_ac].bmy05) THEN
              LET l_bmy05 = NULL
           END IF
 
        AFTER FIELD bmy05
           #MOD-E40053-Start-Add
           IF s_industry('slk') AND g_sma.sma150 = 'Y' THEN 
              #FUN-D80022--add--str--
              IF NOT cl_null(g_bmy[l_ac].bmy05) THEN
                 LET g_bmy05_t1 = ' '                   #TQC-E90001
                 LET g_bmy05_t1 = g_bmy[l_ac].bmy05     #TQC-E90001
                 SELECT ima940,ima941,ima943 INTO g_ima940,g_ima941,g_ima943 FROM ima_file
                  WHERE ima01 = g_bmz[1].bmz02
                 SELECT ima940,ima941,ima943 INTO g_ima940_1,g_ima941_1,g_ima943_1 FROM ima_file
                  WHERE ima01 = g_bmy[l_ac].bmy05
                 IF NOT ( g_ima943 = g_ima943_1 OR g_ima943 = '3' OR g_ima943_1 = '4' ) THEN 
                    CALL cl_err(g_bmy[l_ac].bmy05,'abm-388',1)
                    NEXT FIELD bmy05
                 END IF 
              END IF
              #FUN-D80022--add--end--
           END IF 
           #MOD-E40053-End-Add
           IF NOT cl_null(g_bmy[l_ac].bmy05) THEN
             #FUN-AA0059 ---------------------------------add start----------------------------
              IF NOT s_chk_item_no(g_bmy[l_ac].bmy05,'') THEN 
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD bmy05
              END IF 
             #FUN-AA0059----------------------------------add end-----------------------------
             #SELECT ima02,ima021,ima107,ima147                                       #CHI-E80001 mark
             #  INTO g_bmy[l_ac].ima02, g_bmy[l_ac].ima021,g_ima107,g_ima147          #CHI-E80001 mark  
             #SELECT ima02,ima021,ima107,ima147,ima08                                 #CHI-E80001 add  #MOD-H10002 mark
              SELECT ima02,ima021,ima107,ima147,ima08,ima910                                           #MOD-H10002 add
                INTO g_bmy[l_ac].ima02, g_bmy[l_ac].ima021,g_ima107,g_ima147,l_ima08  #CHI-E80001 add  
                    ,l_ima910 #MOD-H10002 add
                FROM ima_file
               WHERE ima01=g_bmy[l_ac].bmy05
                 AND imaacti = 'Y'
              IF STATUS THEN
                 CALL cl_err3("sel","ima_file",g_bmy[l_ac].bmy05,"",STATUS,"","sel ima",1) # TQC-660046
                 NEXT FIELD bmy05
              END IF
              DISPLAY BY NAME g_bmy[l_ac].ima02
              DISPLAY BY NAME g_bmy[l_ac].ima021

              #CHI-E80001-Start-Add #新增，不可為Z:雜項料件
              IF l_ima08 = 'Z' AND g_bmy[l_ac].bmy03 = '2' THEN 
                 CALL cl_err(g_bmy[l_ac].bmy05,'mfg2752',1)
                 NEXT FIELD bmy05        
              END IF 
              #CHI-E80001-End-Add

              #MOD-H10002---add---str---
              IF g_bmy[l_ac].bmy03 = '2' THEN 
                  IF cl_null(l_ima910) THEN LET l_ima910 = ' ' END IF
                  SELECT COUNT(*) INTO l_n
                    FROM bma_file
                   WHERE bma01 = g_bmy[l_ac].bmy05
                     AND bma06 = l_ima910
                     AND bmaacti = 'Y'
                  IF l_n > 0 THEN
                     LET l_bma05 = NULL
                     SELECT bma05 INTO l_bma05
                       FROM bma_file
                      WHERE bma01 = g_bmy[l_ac].bmy05
                        AND bma06 = l_ima910
                        AND bmaacti = 'Y'
                     IF cl_null(l_bma05) OR l_bma05 = ' ' THEN
                         CALL cl_err(g_bmy[l_ac].bmy05,'amr-001',1) #此料號的BOM 尚未發放!
                         NEXT FIELD bmy05        
                     END IF
                  END IF
              END IF
              #MOD-H10002---add---end---

             #M014 180207 By TSD.Tim---(S)
             IF g_bmy[l_ac].bmy03 = '4' THEN
              SELECT bmb14 INTO g_bmy[l_ac].bmy35
                FROM bmb_file
               WHERE bmb01 = g_bmz[1].bmz02
                 AND bmb03 = g_bmy[l_ac].bmy05
                 AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
              IF cl_null(g_bmy[l_ac].bmy35) THEN LET g_bmy[l_ac].bmy35 = 0 END IF 
             ELSE
             #M014 180207 By TSD.Tim---(E)
              #CHI-DC0019-Start-Add
             #SELECT bmb06,bmb07 INTO g_bmy[l_ac].bmy06,g_bmy[l_ac].bmy07                         #MOD-EC0101 mark
             #SELECT bmb06,bmb07,bmb14 INTO g_bmy[l_ac].bmy06,g_bmy[l_ac].bmy07,g_bmy[l_ac].bmy35 #MOD-EC0101 add #20221123 mark
              SELECT bmb06,bmb07,bmb14,bmb09                                                      #20221123
                INTO g_bmy[l_ac].bmy06,g_bmy[l_ac].bmy07,g_bmy[l_ac].bmy35,g_bmy[l_ac].bmy09      #20221123
                FROM bmb_file 
               #M014 180208 By TSD.Tim---(S)
               #WHERE bmb01 = g_bmz[l_ac].bmz02 
               WHERE bmb01 = g_bmz[1].bmz02 
               #M014 180208 By TSD.Tim---(E)
                 AND bmb03 = g_bmy[l_ac].bmy05
                 AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                 AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                 
              IF cl_null(g_bmy[l_ac].bmy06) THEN LET g_bmy[l_ac].bmy06 = 1 END IF 
              IF cl_null(g_bmy[l_ac].bmy07) THEN LET g_bmy[l_ac].bmy07 = 1 END IF
             #M014 180207 By TSD.Tim---(E)
              IF cl_null(g_bmy[l_ac].bmy35) THEN LET g_bmy[l_ac].bmy35 = 0 END IF   #MOD-EC0101 add
             #M014 180207 By TSD.Tim---(S)
             END IF
             #M014 180207 By TSD.Tim---(E)
             #DISPLAY BY NAME g_bmy[l_ac].bmy06,g_bmy[l_ac].bmy07                   #MOD-EC0101 mark
              DISPLAY BY NAME g_bmy[l_ac].bmy06,g_bmy[l_ac].bmy07,g_bmy[l_ac].bmy35 #MOD-EC0101 add
              #CHI-DC0019-End-Add
              DISPLAY BY NAME g_bmy[l_ac].bmy09                                     #20221123
 
              IF g_bmy[l_ac].bmy03 != '1' THEN
                 LET g_cnt = 0  #FUN-6A0036
                 SELECT COUNT(*) INTO g_cnt
                   FROM ima_file
                  WHERE ima01=g_bmy[l_ac].bmy05
                    AND (ima140='N'
                    OR (ima140 ='Y' AND ima1401 > g_bmx.bmx07))                   #MOD-780142
                 IF g_cnt=0        THEN
                    CALL cl_err('','aim-809',0)
                   #NEXT FIELD bmy05                                              #20201223 mark
                 END IF
              END IF
 
             #變異別不為失效時,不允許元件和主件相同
              IF g_bmy[l_ac].bmy03 != '1' THEN
                 DECLARE i710_c0 CURSOR FOR
                  SELECT bmz02 FROM bmz_file 
                   WHERE bmz01=g_bmx.bmx01
                 FOREACH i710_c0 INTO l_bmz02
                    IF STATUS THEN EXIT FOREACH END IF
                   IF l_bmz02 = g_bmy[l_ac].bmy05 THEN 
                      CALL cl_err('sel bmb','mfg2633',0)
                      NEXT FIELD bmy05
                   END IF 
                 END FOREACH
              END IF
 
#             #此料件存在大於此生效日的其他設變資料,不可輸入
#             #檢查單身所輸入的設變料件是否己有存在ECN的單據且
#             #單據已確認,但生效日尚未到者,則不可再key單
#             LET l_cnt = 0
#             
#             IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
#                SELECT COUNT(*) INTO l_cnt FROM bmb_file
#                 WHERE bmb01 = (SELECT bmz02 FROM bmz_file
#                                 WHERE bmz01=g_bmx.bmx01)
#                   AND bmb03 = g_bmy[l_ac].bmy05
#                   AND bmb02 = g_bmy[l_ac].bmy04
#                   AND (bmb04 > g_bmx.bmx07 AND bmb04 IS NOT NULL)
#                   AND bmb05 IS NULL
#             ELSE 
#                SELECT COUNT(*) INTO l_cnt FROM bmb_file
#                 WHERE bmb01 = (SELECT bmz02 FROM bmz_file
#                                 WHERE bmz01=g_bmx.bmx01)
#                   AND bmb03 = g_bmy[l_ac].bmy05
#                   AND (bmb04 > g_bmx.bmx07 AND bmb04 IS NOT NULL)
#                   AND bmb05 IS NULL
#             END IF
# 
#             IF l_cnt > 0 THEN
#                CALL cl_err(g_bmy[l_ac].bmy05,'abm-729','1')
#                NEXT FIELD bmy05
#             END IF
             
             #此料件存在大於此生效日的其他設變資料,不可輸入
             #檢查單身所輸入的設變料件是否己有存在ECN的單據且
             #單據已確認,但生效日尚未到者,則不可再key單
             LET l_cnt = 0
             
             IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
                IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
                   SELECT COUNT(*) INTO l_cnt FROM bmb_file
                    WHERE bmb01 = (SELECT bmz02 FROM bmz_file
                                    WHERE bmz01=g_bmx.bmx01)
                      AND bmb03 = g_bmy[l_ac].bmy05
                      AND bmb02 = g_bmy[l_ac].bmy04
                      AND (bmb04 > g_bmx.bmx07 AND bmb04 IS NOT NULL)
                      AND bmb05 IS NULL
                ELSE 
                   SELECT COUNT(*) INTO l_cnt FROM brb_file
                    WHERE brb01 = (SELECT bmz02 FROM bmz_file
                                    WHERE bmz01=g_bmx.bmx01)
                      AND brb011=(SELECT bmz011 FROM bmz_file
                                    WHERE bmz01=g_bmx.bmx01)
                      AND brb012=(SELECT bmz012 FROM bmz_file
                                    WHERE bmz01=g_bmx.bmx01)
                      AND brb013=(SELECT bmz013 FROM bmz_file
                                    WHERE bmz01=g_bmx.bmx01)                            
                      AND brb03 = g_bmy[l_ac].bmy05
                      AND brb02 = g_bmy[l_ac].bmy04
                      AND (brb04 > g_bmx.bmx07 AND brb04 IS NOT NULL)
                      AND brb05 IS NULL                	 
                END IF 
             ELSE 
             	  IF g_argv1='1' THEN  #CHI-CA0035 mod g_argv3->g_argv1
                   SELECT COUNT(*) INTO l_cnt FROM bmb_file
                    WHERE bmb01 = (SELECT bmz02 FROM bmz_file
                                    WHERE bmz01=g_bmx.bmx01)
                      AND bmb03 = g_bmy[l_ac].bmy05
                      AND (bmb04 > g_bmx.bmx07 AND bmb04 IS NOT NULL)
                      AND bmb05 IS NULL
                ELSE 
                   SELECT COUNT(*) INTO l_cnt FROM brb_file
                    WHERE brb01 = (SELECT bmz02 FROM bmz_file
                                    WHERE bmz01=g_bmx.bmx01)
                      AND brb011=(SELECT bmz011 FROM bmz_file
                                    WHERE bmz01=g_bmx.bmx01)
                      AND brb012=(SELECT bmz012 FROM bmz_file
                                    WHERE bmz01=g_bmx.bmx01)
                      AND brb013=(SELECT bmz013 FROM bmz_file
                                    WHERE bmz01=g_bmx.bmx01)                            
                      AND brb03 = g_bmy[l_ac].bmy05
                      AND (brb04 > g_bmx.bmx07 AND brb04 IS NOT NULL)
                      AND brb05 IS NULL   
                 END IF                      
             END IF
             IF l_cnt > 0 THEN
                CALL cl_err(g_bmy[l_ac].bmy05,'abm-729','1')
                NEXT FIELD bmy05
             END IF            
             #變異別為0,1,3須check元件是否屬於該主件
             IF g_bmy[l_ac].bmy03 != '2' THEN
                 #No.FUN-A60008--begin
                 #DECLARE i710_c1 CURSOR FOR
                 # SELECT bmz02,bmz05 FROM bmz_file  #FUN-550014 add bmz05
                 #  WHERE bmz01=g_bmx.bmx01
                 IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
                    LET l_sql=" SELECT bmz02,bmz05,'','','' FROM bmz_file WHERE bmz01='",g_bmx.bmx01,"' "
                 ELSE 
                 	  LET l_sql=" SELECT bmz02,bmz05,bmz011,bmz012,bmz013 FROM bmz_file WHERE bmz01='",g_bmx.bmx01,"' "
                 END IF 
                 PREPARE i710_bmz FROM l_sql
                 DECLARE i710_c1 CURSOR FOR i710_bmz
                 #No.FUN-A60008--end 
                 LET l_n1 = 0
                 LET l_n2 = 0
                 LET l_n3=0
                 LET l_n4=0
                 LET l_chr = 'N'    #No:MOD-970032 add
                 LET l_bma01 = NULL #No:MOD-970032 add
                 FOREACH i710_c1 INTO l_bmz02,l_bmz05,l_bmz011,l_bmz012,l_bmz013  #FUN-550014 add bmz05  #No.FUN-A60008 add bmz011,bmz012,bmz013
                    IF STATUS THEN EXIT FOREACH END IF
 
                    IF g_bmy[l_ac].bmy04 IS NOT NULL THEN
                       #No.FUN-A60008--begin
                       IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
                          SELECT COUNT(*) INTO l_n1 FROM bmb_file
                           WHERE bmb01 = l_bmz02
                             AND bmb29 = l_bmz05   #FUN-550014 add
                             AND bmb02 = g_bmy[l_ac].bmy04
                             AND bmb03 = g_bmy[l_ac].bmy05
                             AND (bmb04 <=g_bmx.bmx07 OR bmb04 IS NULL)
                             AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL)
                       ELSE 
                          SELECT COUNT(*) INTO l_n1 FROM brb_file
                           WHERE brb01 = l_bmz02
                             AND brb29 = l_bmz05 
                             AND brb011= l_bmz011
                             AND brb012= l_bmz012
                             AND brb013= l_bmz013
                             AND brb02 = g_bmy[l_ac].bmy04
                             AND brb03 = g_bmy[l_ac].bmy05
                             AND (brb04 <=g_bmx.bmx07 OR brb04 IS NULL)
                             AND (brb05 > g_bmx.bmx07 OR brb05 IS NULL)                       	  
                       END IF 
                    ELSE
                    	 IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
                          SELECT COUNT(*) INTO l_n2 FROM bmb_file
                           WHERE bmb01 = l_bmz02
                             AND bmb29 = l_bmz05   #FUN-550014 add
                             AND bmb03 = g_bmy[l_ac].bmy05
                             AND (bmb04 <=g_bmx.bmx07 OR bmb04 IS NULL)
                             AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL)
                       ELSE 
                          SELECT COUNT(*) INTO l_n2 FROM brb_file
                           WHERE brb01 = l_bmz02
                             AND brb29 = l_bmz05 
                             AND brb011= l_bmz011
                             AND brb012= l_bmz012
                             AND brb013= l_bmz013
                             AND brb03 = g_bmy[l_ac].bmy05
                             AND (brb04 <=g_bmx.bmx07 OR brb04 IS NULL)
                             AND (brb05 > g_bmx.bmx07 OR brb05 IS NULL)                           	  
                       END IF 
                       #No.FUN-A60008--end 
                    END IF
                    IF l_n1 = 0 AND l_n2 = 0 THEN
                       LET l_chr = 'Y' 
                       LET l_bma01 = l_bmz02
                       EXIT FOREACH
                    END IF
                 END FOREACH
                 IF l_chr = 'Y' THEN                      #No:MOD-970032 modify
                    CALL cl_err(l_bma01,'mfg2631',0)      #No:MOD-970032 modify
                    NEXT FIELD bmy05
                 END IF
               END IF
 
               IF g_bmy[l_ac].bmy03 = '2' THEN
                  IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
                     SELECT COUNT(*) INTO l_cnt FROM bmb_file,bmz_file
                      WHERE bmb01 = bmz02
                        AND bmz01 = g_bmx.bmx01
                        AND bmb03 = g_bmy[l_ac].bmy05
                        AND (bmb04 <=g_bmx.bmx07 OR bmb04 IS NULL)
                        AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL)
                  ELSE 
                     SELECT COUNT(*) INTO l_cnt FROM brb_file,bmz_file
                      WHERE brb01 = bmz02
                        AND brb011= bmz011
                        AND brb012= bmz012
                        AND brb013= bmz013
                        AND bmz01 = g_bmx.bmx01
                        AND brb03 = g_bmy[l_ac].bmy05
                        AND (brb04 <=g_bmx.bmx07 OR brb04 IS NULL)
                        AND (brb05 > g_bmx.bmx07 OR brb05 IS NULL)                  	 
                  END IF 
                  IF l_cnt > 0 THEN
                     IF NOT cl_confirm('abm-728') THEN
                        NEXT FIELD CURRENT #CHI-960004
                     END IF
                  END IF
              END IF
 
              IF cl_null(l_bmy05) OR l_bmy05 != g_bmy[l_ac].bmy05 THEN    #No.MOD-550047
                 LET l_bmy05 = g_bmy[l_ac].bmy05                          #No.MOD-550047
                 #TQC-AC0171 ------------add start---------------
                 IF g_bmy[l_ac].bmy03 = '3' THEN
                    IF g_argv1='1' THEN  #CHI-CA0035 mod g_argv3->g_argv1
                       LET l_sql = "SELECT bmb14 FROM bmb_file,bmz_file ",
                                  #MOD-B70036---modify---start---
                                  #" WHERE bmb01 = bmz02 AND bmb29 = bmz05 AND bmz01 = g_bmx.bmx01 ",            
                                  #" AND bmb03 = g_bmy[l_ac].bmy05 AND (bmb04 <=g_bmx.bmx07 OR bmb04 IS NULL) ", 
                                  #" AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL) "                                
                                   " WHERE bmb01 = bmz02 AND bmb29 = bmz05 AND bmz01 = '",g_bmx.bmx01,"' ",                   
                                   " AND bmb03 = '",g_bmy[l_ac].bmy05,"' AND (bmb04 <='",g_bmx.bmx07,"' OR bmb04 IS NULL) ", 
                                   " AND (bmb05 > '",g_bmx.bmx07,"' OR bmb05 IS NULL) "                                      
                                  #MOD-B70036---modify---end---
                    ELSE
                       LET l_sql = "SELECT brb14 FROM brb_file,bmz_file ",
                                  #MOD-B70036---modify---start---
                                  #" WHERE brb01 = bmz02 AND brb29 = bmz05 AND bmz01 = g_bmx.bmx01 ",             
                                  #" AND bmz011=brb011 AND brb012=bmz012 AND brb013=bmz013 ",
                                  #" AND brb03 = g_bmy[l_ac].bmy05 AND (brb04 <=g_bmx.bmx07 OR brb04 IS NULL) ",              
                                  #" AND (brb05 > g_bmx.bmx07 OR brb05 IS NULL) "                                              
                                   " WHERE brb01 = bmz02 AND brb29 = bmz05 AND bmz01 = '",g_bmx.bmx01,"' ",       
                                   " AND bmz011=brb011 AND brb012=bmz012 AND brb013=bmz013 ",
                                   " AND brb03 = '",g_bmy[l_ac].bmy05,"' AND (brb04 <='",g_bmx.bmx07,"' OR brb04 IS NULL) ",   
                                   " AND (brb05 > '",g_bmx.bmx07,"' OR brb05 IS NULL) "                                        
                                  #MOD-B70036---modify---end---
                    END IF 
                    PREPARE i710_bmb_pre01 FROM l_sql
                    DECLARE i710_bmb CURSOR FOR i710_bmb_pre01
                    FOREACH i710_bmb INTO g_bmy[l_ac].bmy35
                       EXIT FOREACH
                    END FOREACH
                    DISPLAY g_bmy[l_ac].bmy35 TO bmy35   
                 END IF 
                 #TQC-AC0171 -------------add end---------------- 
              
                 IF g_bmy[l_ac].bmy03 = '1' OR 
                    g_bmy[l_ac].bmy03 = '3' OR          #TQC-DA0052 add
                    g_bmy[l_ac].bmy03 = '4' THEN #FUN-850156
                    LET l_bmy16 = g_bmy[l_ac].bmy16   #CHI-960004
                    IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
                       LET l_sql1=" SELECT bmb16,bmb06,bmb07,bmb30,bmb31 FROM bmb_file,bmz_file ",   
                                #MOD-B70036---modify---start---
                                #" WHERE bmb01 = bmz02 AND bmb29 = bmz05 AND bmz01 = g_bmx.bmx01 ",
                                #" AND bmb03 = g_bmy[l_ac].bmy05 AND (bmb04 <=g_bmx.bmx07 OR bmb04 IS NULL) ",  
                                #" AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL) "                                                        
                                 " WHERE bmb01 = bmz02 AND bmb29 = bmz05 AND bmz01 = '",g_bmx.bmx01,"' ",                        
                                 " AND bmb03 = '",g_bmy[l_ac].bmy05,"' AND (bmb04 <='",g_bmx.bmx07,"' OR bmb04 IS NULL) ",        
                                 " AND (bmb05 > '",g_bmx.bmx07,"' OR bmb05 IS NULL) "                                          
                                #MOD-B70036---modify---end---
                    ELSE 
                       LET l_sql1=" SELECT brb16,brb06,brb07,brb30,brb31 FROM brb_file,bmz_file ",    
                                #MOD-B70036---modify---start---
                                #" WHERE brb01 = bmz02 AND brb29 = bmz05 AND bmz01 = g_bmx.bmx01 ",
                                #" AND bmz011=brb011 AND brb012=bmz012 AND brb013=bmz013 ",
                                #" AND brb03 = g_bmy[l_ac].bmy05 AND (brb04 <=g_bmx.bmx07 OR brb04 IS NULL) ",
                                #" AND (brb05 > g_bmx.bmx07 OR brb05 IS NULL) "                 	  
                                 " WHERE brb01 = bmz02 AND brb29 = bmz05 AND bmz01 = '",g_bmx.bmx01,"' ",
                                 " AND bmz011=brb011 AND brb012=bmz012 AND brb013=bmz013 ",
                                 " AND brb03 = '",g_bmy[l_ac].bmy05,"' AND (brb04 <='",g_bmx.bmx07,"' OR brb04 IS NULL) ",
                                 " AND (brb05 > '",g_bmx.bmx07,"' OR brb05 IS NULL) "                 	  
                                #MOD-B70036---modify---end---
                    END IF 
                    PREPARE i710_brb FROM l_sql1
                    DECLARE get_def_cs CURSOR FOR i710_brb
#                   DECLARE get_def_cs CURSOR FOR
#                    SELECT bmb16,bmb06,bmb07,bmb30,bmb31 #FUN-550014 add bmb29  #NO.MOD-840426 add bmb31
#                      FROM bmb_file,bmz_file
#                     WHERE bmb01 = bmz02
#                       AND bmb29 = bmz05           #FUN-550014 add
#                       AND bmz01 = g_bmx.bmx01
#                       AND bmb03 = g_bmy[l_ac].bmy05
#                       AND (bmb04 <=g_bmx.bmx07 OR bmb04 IS NULL)
#                       AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL)
                   FOREACH get_def_cs INTO
                           g_bmy[l_ac].bmy16 ,
                           g_bmy[l_ac].bmy06 ,
                           g_bmy[l_ac].bmy07,
                           g_bmy[l_ac].bmy30,  #FUN-550014 add bmy30
                           g_bmy[l_ac].bmy34   #no.MOD-840426 add 
                     EXIT FOREACH
                   END FOREACH
                   IF g_bmy[l_ac].bmy03 = '4'  THEN  #CHI-960004
                      LET g_bmy[l_ac].bmy16 = l_bmy16    #CHI-960004
                      LET g_bmy[l_ac].bmy06 = ''         #CHI-A30011 add
                      LET g_bmy[l_ac].bmy07 = ''         #CHI-A30011 add
                   END IF                                #CHI-960004
                   IF g_bmy[l_ac].bmy03 = '3' THEN       #TQC-DA0052 add
                       LET g_bmy[l_ac].bmy06 = ''        #TQC-DA0052 add
                    END IF                               #TQC-DA0052 add
                   DISPLAY g_bmy[l_ac].bmy16  TO bmy16
                   DISPLAY g_bmy[l_ac].bmy06  TO bmy06
                   DISPLAY g_bmy[l_ac].bmy07  TO bmy07
                   DISPLAY g_bmy[l_ac].bmy30  TO bmy30
                   DISPLAY g_bmy[l_ac].bmy34  TO bmy34   #no.MOD-840426
                 END IF
              END IF
 
              IF g_bmy[l_ac].bmy03 = '4' THEN
                 SELECT ima107,ima147
                   INTO g_ima107,g_ima147
                   FROM ima_file
                  WHERE ima01=g_bmy[l_ac].bmy27
                    AND imaacti = 'Y'
              END IF
              CALL i710_chkinsitm() RETURNING l_chkinsitm
              IF NOT l_chkinsitm THEN
                NEXT FIELD bmy05
              END IF
              #-----------------CHI-DC0015------------------(S)
               IF g_bmy[l_ac].bmy03 = '6' THEN
                  IF NOT cl_null(g_bmy[l_ac].bmy27) THEN
                     SELECT bmd07 INTO g_bmy[l_ac].bmy06
                       FROM bmd_file,bmz_file
                      WHERE bmd08 = bmz02
                        AND bmz01 = g_bmx.bmx01
                        AND bmd01 = g_bmy[l_ac].bmy05
                        AND bmd04 = g_bmy[l_ac].bmy27
                        AND bmd02 = '2'
                     DISPLAY BY NAME g_bmy[l_ac].bmy06
                  END IF
               END IF
              #-----------------CHI-DC0015------------------(E)
           END IF
   
           BEFORE FIELD bmy16
            #IF g_bmy[l_ac].bmy03 MATCHES '[123]' THEN
            #IF g_bmy[l_ac].bmy03 MATCHES '[1235]' THEN  #MOD-B50157 mod   #MOD-C40150 mark
             IF g_bmy[l_ac].bmy03 MATCHES '[123]' THEN                     #MOD-C40150 add
               #MOD-AC0029---add---start---
                LET comb_value = '0,1,2,5,7,9'  #FUN-C30035 add 7,9
                CALL cl_getmsg('abm-076',g_lang) RETURNING comb_item
                CALL cl_set_combo_items('bmy16',comb_value,comb_item)
               #MOD-AC0029---add---end---
                IF cl_null(g_bmy[l_ac].bmy16) THEN
                   IF g_bmy[l_ac].bmy03 = '2' THEN
                      LET g_bmy[l_ac].bmy16 = '0'
                   ELSE
                      DECLARE get_def_cs1 CURSOR FOR
                       SELECT bmb16
                         FROM bmb_file,bmz_file
                        WHERE bmb01 = bmz02
                          AND bmb29 = bmz05
                          AND bmz01 = g_bmx.bmx01
                          AND bmb03 = g_bmy[l_ac].bmy05
                          AND (bmb04 <=g_bmx.bmx07 OR bmb04 IS NULL)
                          AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL)
                      FOREACH get_def_cs1 INTO g_bmy[l_ac].bmy16
                        EXIT FOREACH
                      END FOREACH
                   END IF
                   DISPLAY g_bmy[l_ac].bmy16  TO bmy16
                END IF
            #MOD-AC0029---add---start---
            #因如果單身內有4和5，取替代皆有的話，會導致再修改單身時會有其中一筆的取替代特性(bmy16)無法顯示
            #故將此段Mark，改用After Field 來控卡
            #MOD-DB0005-Start-Mark
            #ELSE
            #  #MOD-C40150---add---start---
            #    IF g_bmy[l_ac].bmy03 = '5' THEN
            #      LET comb_value = '2,5'
            #      CALL cl_getmsg('abm-078',g_lang) RETURNING comb_item
            #      CALL cl_set_combo_items('bmy16',comb_value,comb_item)
            #   ELSE
            #  #MOD-C40150---add---end---
            #     #LET comb_value = '0,1'    #MOD-C40150 mark
            #      LET g_bmy[l_ac].bmy16 = '1'  #MOD-D10278
            #      DISPLAY g_bmy[l_ac].bmy16 TO bmy16 #MOD-D10278
            #      LET comb_value = '1'      #MOD-C40150 add
            #      CALL cl_getmsg('abm-077',g_lang) RETURNING comb_item
            #      CALL cl_set_combo_items('bmy16',comb_value,comb_item)
            #   END IF                #MOD-C40150 add
            ##MOD-AC0029---add---end---
            #MOD-DB0005-End-Mark 
             END IF
             
           AFTER FIELD bmy16
            IF NOT cl_null(g_bmy[l_ac].bmy16) THEN
               IF g_bmy[l_ac].bmy16 NOT MATCHES '[012579]' THEN  #FUN-C30035 add 79
                  LET g_bmy[l_ac].bmy16 = g_bmy_t.bmy16 #CHI-A60028 add
                  DISPLAY BY NAME g_bmy[l_ac].bmy16     #CHI-A60028 add
                  NEXT FIELD bmy16
               END IF
               #CHI-A60028 add --start--
               IF NOT cl_null(g_bmy[l_ac].bmy35) THEN
                  IF g_bmy[l_ac].bmy35 = '2' THEN
                     LET g_bmy[l_ac].bmy16 = '0'
                  END IF
               END IF
               LET g_bmy_t.bmy16 = g_bmy[l_ac].bmy16
               #CHI-A60028 add --end--
           END IF
           IF g_bmy[l_ac].bmy03 = '5' THEN
              IF g_bmy[l_ac].bmy16 NOT MATCHES '[25]' THEN
                 CALL cl_err('','abm-037',1)
                 NEXT FIELD bmy16
              END IF
           END IF
           #MOD-DB0005-Start-Add
           IF g_bmy[l_ac].bmy03 = '4' THEN
              #M014 180202 By TSD.Andy -----(S)
              #IF g_bmy[l_ac].bmy16 NOT MATCHES '[1]' THEN 
              #   CALL cl_err('','abm1005',1)
              IF g_bmy[l_ac].bmy16 NOT MATCHES '[01]' THEN
                 CALL cl_err('','TSD0044',1)      #當變異碼(bmy03)為"4:取代"時，取替(bmy16)一定要為"1:可被取代"或"0:不可取替代".
              #M014 180202 By TSD.Andy -----(E)
                 NEXT FIELD bmy16
              END IF
           END IF 
           #MOD-DB0005-End-Add 
        
        #CHI-A60028 add --start--
           AFTER FIELD bmy35
              IF NOT cl_null(g_bmy[l_ac].bmy35) THEN
                 IF g_bmy[l_ac].bmy35 NOT MATCHES'[0123]' THEN
                     LET g_bmy[l_ac].bmy35 = g_bmy_t.bmy35
                     DISPLAY BY NAME g_bmy[l_ac].bmy35
                     NEXT FIELD bmy35
                 END IF
                 IF g_bmy[l_ac].bmy35 = '2' THEN
                    LET g_bmy[l_ac].bmy16 = '0'
                 END IF
                 IF cl_null(g_bmy[l_ac].bmy06) OR g_bmy[l_ac].bmy06=0 THEN
                    IF g_bmy[l_ac].bmy03 <> '4' THEN #M014 180205 By TSD.Andy
                       IF g_bmy[l_ac].bmy35 = '2' THEN
                          LET g_bmy[l_ac].bmy06 = -1
                       ELSE
                          LET g_bmy[l_ac].bmy06 = 1
                       END IF
                    END IF                           #M014 180205 By TSD.Andy
                 ELSE
                   IF g_bmy[l_ac].bmy35 = '2' AND g_bmy[l_ac].bmy06 > 0 THEN
                      LET g_bmy[l_ac].bmy06=g_bmy[l_ac].bmy06 * (-1)
                   END IF
                   IF g_bmy[l_ac].bmy35 <> '2' AND g_bmy[l_ac].bmy06 < 0 THEN
                      LET g_bmy[l_ac].bmy06=g_bmy[l_ac].bmy06 * (-1)
                   END IF
                 END IF
                  LET g_bmy_t.bmy06 = g_bmy[l_ac].bmy06 #CHI-DC0019 add
                #CHI-DC0019-Mark-Start
                #因插件位置開窗會抓不到值，故MARK  
                ##MOD-D30036-start-add 
                # IF g_bmy[l_ac].bmy06 = '' THEN
                #    LET g_bmy[l_ac].bmy06 = 1
                # END IF
                # IF g_bmy[l_ac].bmy03 = '3' THEN
                #    LET g_bmy[l_ac].bmy06 = ''
                # END IF
                ##MOD-D30036-end-add
                #CHI-DC0019-Mark-End   
              END IF
        #CHI-A60028 add --end--
            

        #FUN-D80022 --------Begin--------
        BEFORE FIELD bmy38
          ##----- 20201208 mark (S)
          # IF NOT cl_null(g_bmy[l_ac].bmy05) THEN
          #    SELECT ima940,ima941,ima943 INTO g_ima940,g_ima941,g_ima943 FROM ima_file
          #     WHERE ima01 = g_bmz[1].bmz02 
          #    SELECT ima940,ima941,ima943 INTO g_ima940_1,g_ima941_1,g_ima943_1 FROM ima_file
          #     WHERE ima01 = g_bmy[l_ac].bmy05
          # END IF
          ##----- 20201208 mark (E)
          ##----- 20201208 add (S)
          IF cl_null(g_bmy[l_ac].bmy38) THEN
             IF g_bmy[l_ac].bmy03 MATCHES '[14]' THEN
                LET g_bmy[l_ac].bmy38='Y'
             ELSE
                LET g_bmy[l_ac].bmy38='N'
             END IF
          END IF
          ##----- 20201208 add (E)

        AFTER FIELD bmy38
          ##------ 20201208 mark (S)
          # IF NOT cl_null(g_bmy[l_ac].bmy38) THEN
          #    LET g_bmy38_t = ' '                     #TQC-E90001 
          #    LET g_bmy38_t = g_bmy[l_ac].bmy38       #TQC-E90001
          #    IF NOT i710_chk_bmy38() THEN NEXT FIELD bmy38 END IF  #TQC-DA0015
          #    IF g_bmy[l_ac].bmy38 MATCHES '[234567]'  THEN  #區分
          #     #TQC-E90001--mark str--
          #      #IF  b_bmy.bmy05 <> g_bmy_t.bmy05 THEN
          #      #   CALL i710_ins_bmyx('a')
          #      #ELSE 
          #      #   CALL i710_ins_bmyx(p_cmd)
          #      #END IF 
          #     #TQC-E90001--mark end--
          #     #TQC-E90001--add str--
          #      CALL i710_del_bmyx()
          #      CALL i710_ins_bmyx(p_cmd)
          #    ELSE 
          #      CALL i710_del_bmyx()
          #     #TQC-E90001--add end--
          #    END IF
          # END IF
          # IF s_industry('slk') AND g_sma.sma150 = 'Y' THEN
          #    IF l_ac <> 0 THEN
          #       CALL i710_b_fill_slk()
          #       CALL i710_bp_refresh_slk()
          #    END IF
          # END IF

        ##------ 20201208 mark (S)
        #FUN-D80022 --------End----------

        AFTER FIELD bmy06
           IF NOT cl_null(g_bmy[l_ac].bmy06) THEN
              IF g_bmy[l_ac].bmy03 MATCHES '[23456]' THEN  #CHI-960004 #CHI-C20060
                 IF g_bmy[l_ac].bmy06=0 THEN
                     CALL cl_err('','mfg9243',0)   #MOD-640215 add
                     NEXT FIELD bmy06
                 END IF
              END IF
              #檢查組成用量,不可小於等於零,否則abmi600會顯示不出變更後的元件料號
          #   IF g_bmy[l_ac].bmy06 <= 0 AND               #TQC-BA0079
          #      g_bmy[l_ac].bmy03 NOT MATCHES '[3]' THEN #FUN-850156  TQC-BA0079
              IF g_bmy[l_ac].bmy06 <= 0 AND               #TQC-BA0079
                 g_bmy[l_ac].bmy35 NOT MATCHES '[2]' THEN #TQC-BA0079
                 CALL cl_err('','mfg9243',0)
                 NEXT FIELD bmy06
              END IF
              #CHI-DC0019-Start-Add
             #IF g_ima147='Y' AND g_bmy[l_ac].bmy03 MATCHES '[23456]'  #MOD-G90032 mark
              IF g_ima147='Y' AND g_bmy[l_ac].bmy03 MATCHES '[23]'     #MOD-G90032 add
                              AND g_bmy[l_ac].bmy06 <> g_bmy_t.bmy06 THEN
                 CALL i710_t()
              END IF
             #CHI-DC0019-End-Add
           ELSE                                  #MOD-B50058 add
            # IF g_bmy[l_ac].bmy03='2' THEN      #MOD-B70147 add
              IF g_bmy[l_ac].bmy03='2' AND g_bmy[l_ac].bmy35 NOT MATCHES '[2]' THEN   #TQC-BA0079 
                 LET g_bmy[l_ac].bmy06 = 1       #MOD-B50058 add
              END IF                             #MOD-B70147 add
           END IF
        #No.FUN-A60083--begin
        BEFORE FIELD bmy07 
           IF g_bmy[l_ac].bmy03='2' THEN 
              LET g_bmy[l_ac].bmy07=1
           END IF 
        #No.FUN-A60083--end
           LET g_bmy_t.bmy07 = g_bmy[l_ac].bmy07 #CHI-DC0019 add
           
        AFTER FIELD bmy07
           IF cl_null(g_bmy[l_ac].bmy07) AND
              g_bmy[l_ac].bmy03 NOT MATCHES '[34]' THEN #FUN-850156   #CHI-A30011 add 4
               LET g_bmy[l_ac].bmy07 = 1
              DISPLAY BY NAME g_bmy[l_ac].bmy07
           END IF
           #MOD-E60057---add----str---
           #控卡=>mfg2615:主件底數不可小於等於零
           IF NOT cl_null(g_bmy[l_ac].bmy07) THEN
               IF g_bmy[l_ac].bmy07 <= 0 THEN
                  CALL cl_err(g_bmy[l_ac].bmy07,'mfg2615',1)
                  LET g_bmy[l_ac].bmy07 = g_bmy_t.bmy07
                  DISPLAY BY NAME g_bmy[l_ac].bmy07
                  NEXT FIELD bmy07
               END IF
               LET g_bmy_t.bmy07 = g_bmy[l_ac].bmy07
           END IF
           #MOD-E60057---add----end---
           #CHI-DC0019-Start-Add
          #IF g_ima147='Y' AND g_bmy[l_ac].bmy03 MATCHES '[23456]' THEN  #MOD-G90032 mark
           IF g_ima147='Y' AND g_bmy[l_ac].bmy03 MATCHES '[23]'    THEN  #MOD-G90032 add
              IF g_bmy[l_ac].bmy07 != g_bmy_t.bmy07 THEN
                 CALL i710_t() #開窗插件位置
                 END IF 
              END IF 
           #CHI-DC0019-End-Add

       ##-- 20221123 add by momo (S) 作業編號
       AFTER FIELD bmy09
         IF NOT cl_null(g_bmy[l_ac].bmy09) THEN
            LET g_cnt = 0
            SELECT 1 INTO g_cnt 
              FROM ecd_file
             WHERE ecd01 = g_bmy[l_ac].bmy09
            IF g_cnt =0 THEN
               CALL cl_err('','mfg4009',1)
               NEXT FIELD bmy09
            END IF 
         END IF
         LET b_bmy.bmy09 = g_bmy[l_ac].bmy09
       ##-- 20221123 add by momo (E) 作業編號
           
       #--------------CHI-DC0015---------------(S)
        AFTER FIELD bmy36
            CALL i710_set_no_entry_b(p_cmd)
       #--------------CHI-DC0015---------------(E)

 
        AFTER FIELD bmy27
           IF NOT cl_null(g_bmy[l_ac].bmy27) THEN  #no.6845
              #FUN-AA0059 ---------------------add  start------------------------
               IF NOT s_chk_item_no(g_bmy[l_ac].bmy27,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD bmy27
               END IF 
              #FUN-AA0059 -------------------add end-----------------------------
               CALL i710_bmy27('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD bmy27
               END IF
 
               IF g_bmy[l_ac].bmy03 != '1' THEN
                  LET g_cnt = 0  #FUN-6A0036
                  SELECT COUNT(*) INTO g_cnt
                    FROM ima_file
                   WHERE ima01=g_bmy[l_ac].bmy27
                     AND (ima140='N'
                     OR (ima140 ='Y' AND ima1401 > g_bmx.bmx07))                 #MOD-780142
                  IF g_cnt=0        THEN
                     CALL cl_err('','aim-809',0)
                     NEXT FIELD bmy27
                  END IF
                 #變異別不為失效時,不允許元件和主件相同
                  DECLARE i710_c01 CURSOR FOR
                   SELECT bmz02 FROM bmz_file 
                    WHERE bmz01=g_bmx.bmx01
                  FOREACH i710_c01 INTO l_bmz02
                     IF STATUS THEN EXIT FOREACH END IF
                    IF l_bmz02 = g_bmy[l_ac].bmy27 THEN 
                       CALL cl_err('sel bmb','mfg2633',0)
                       NEXT FIELD bmy27
                    END IF 
                  END FOREACH
               END IF
               
               IF g_bmy[l_ac].bmy03 = '5' THEN 
                 #MOD-C20195---add---str---
                  IF g_bmy[l_ac].bmy05 = g_bmy[l_ac].bmy27 THEN
                     CALL cl_err('bmy05=bmy27','mfg2626',0)
                     NEXT FIELD bmy05
                  END IF
                 #MOD-C20195---add---end--- 
                  #檢查替代料是否一存在于bmd_file
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM bmd_file,bmz_file
                   WHERE bmd08 = bmz02
                     AND bmz01 = g_bmx.bmx01
                     AND bmd01 = g_bmy[l_ac].bmy05 
                     AND bmd04 = g_bmy[l_ac].bmy27
                     AND bmd02 = '2'
                  IF l_cnt > 0 THEN
                     CALL cl_err('','abm-034',1)
                     NEXT FIELD bmy27
                  END IF
               END IF
               #CHI-C20060---begin
               IF g_bmy[l_ac].bmy03 = '6' THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM bmd_file,bmz_file
                   WHERE bmd08 = bmz02
                     AND bmz01 = g_bmx.bmx01
                     AND bmd01 = g_bmy[l_ac].bmy05
                     AND bmd04 = g_bmy[l_ac].bmy27
                    #AND bmd02 = '2'                  #MOD-EA0134 mark
                     AND (bmd02 = '1' OR bmd02 = '2') #MOD-EA0134 add
                  IF l_cnt = 0 THEN 
                     CALL cl_err('','abm-127',1)
                     NEXT FIELD bmy27
                  END IF 
               END IF 
               #CHI-C20060---end
               IF g_bmy[l_ac].bmy03 = '4' THEN                                                                                      
                  IF g_bmy[l_ac].bmy05=g_bmy[l_ac].bmy27 THEN                                                                       
                     CALL cl_err('','abm-619',0)                                                                                    
                     NEXT FIELD bmy27                                                                                               
                  END IF                                                                                                            
               END IF                                                                                                               

               #CHI-A80054 add --start--
               #合理性的檢查,元件A不應同時有相同的替代料及取代料皆為B的狀況
               LET l_cnt = 0
               CASE g_bmy[l_ac].bmy03 
                  WHEN '4'
                     SELECT COUNT(*) INTO l_cnt FROM bmd_file,bmz_file
                      WHERE bmd01 = g_bmy[l_ac].bmy05 
                        AND bmd08 = bmz02 
                        AND bmz01 = g_bmx.bmx01
                        AND bmd04 = g_bmy[l_ac].bmy27
                        AND bmd02 = '2'
                        AND bmdacti = 'Y' 
                  WHEN '5'
                     SELECT COUNT(*) INTO l_cnt FROM bmd_file,bmz_file
                      WHERE bmd01 = g_bmy[l_ac].bmy05 
                        AND bmd08 = bmz02
                        AND bmz01 = g_bmx.bmx01
                        AND bmd04 = g_bmy[l_ac].bmy27
                        AND bmd02 = '1'
                        AND bmdacti = 'Y' 
               END CASE 
               IF l_cnt > 0 THEN
                  CALL cl_err_msg("","abm-205",g_bmy[l_ac].bmy05 CLIPPED|| "|" || g_bmy[l_ac].bmy27 CLIPPED,10)
                  NEXT FIELD bmy27
               END IF 
               #CHI-A80054 add --end--
              #-----------------CHI-DC0015------------------(S)
               IF g_bmy[l_ac].bmy03 = '6' THEN
                  IF NOT cl_null(g_bmy[l_ac].bmy05) THEN
                     SELECT bmd07 INTO g_bmy[l_ac].bmy06
                       FROM bmd_file,bmz_file
                      WHERE bmd08 = bmz02
                        AND bmz01 = g_bmx.bmx01
                        AND bmd01 = g_bmy[l_ac].bmy05
                        AND bmd04 = g_bmy[l_ac].bmy27
                       #AND bmd02 = '2'                  #MOD-EA0134 mark
                        AND (bmd02 = '1' OR bmd02 = '2') #MOD-EA0134 add
                     DISPLAY BY NAME g_bmy[l_ac].bmy06
                  END IF
               END IF
              #-----------------CHI-DC0015------------------(E)
           END IF

        BEFORE DELETE                            #是否取消單身
           IF g_bmy_t.bmy02 > 0 AND g_bmy_t.bmy02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM bmy_file
                 WHERE bmy01 = g_bmx.bmx01 AND bmy02 = g_bmy_t.bmy02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","bmy_file",g_bmx.bmx01,"",SQLCA.sqlcode,"","del bmy",1) # TQC-660046
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
 
                DELETE FROM bmw_file
                 WHERE bmw01 = g_bmx.bmx01
                   AND bmw02 = g_bmy_t.bmy02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","bmw_file",g_bmx.bmx01,g_bmy_t.bmy02,SQLCA.sqlcode,"","del bmw",1) # TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF

               #FUN-F50035 add str----
                IF g_sma.sma901 = 'Y' THEN  #與APS整合
                   DELETE FROM vlr_file 
                    WHERE vlr00 = g_bmx.bmx01
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","vlr_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del vlr: ",1) 
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF

                   DELETE FROM vls_file 
                    WHERE vls00 = g_bmx.bmx01
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","vls_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del vls: ",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
               #FUN-F50035 add end----

                #刪除時一併刪除子表bmya_file/bmyb_file/bmyc_file/bmyd_file
                #FUN-D80022 --------Begin--------
                IF s_industry('slk') AND g_sma.sma150 = 'Y' THEN
                   DELETE FROM bmya_file WHERE bmya01 = g_bmx.bmx01 AND bmya02 = g_bmy_t.bmy02
                   IF STATUS THEN
                      CALL cl_err3("del","bmya_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del bmya: ",1)
                      ROLLBACK WORK CANCEL DELETE  
                   END IF
                   DELETE FROM bmyb_file WHERE bmyb01 = g_bmx.bmx01 AND bmyb02 = g_bmy_t.bmy02
                   IF STATUS THEN
                      CALL cl_err3("del","bmyb_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del bmyb: ",1)
                      ROLLBACK WORK CANCEL DELETE  
                   END IF
                   DELETE FROM bmyc_file WHERE bmyc01 = g_bmx.bmx01 AND bmyc02 = g_bmy_t.bmy02
                   IF STATUS THEN
                      CALL cl_err3("del","bmyc_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del bmyc: ",1)
                      ROLLBACK WORK CANCEL DELETE  
                   END IF
                   DELETE FROM bmyd_file WHERE bmyd01 = g_bmx.bmx01 AND bmyd02 = g_bmy_t.bmy02
                   IF STATUS THEN
                      CALL cl_err3("del","bmyd_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del bmyd: ",1)
                      ROLLBACK WORK CANCEL DELETE  
                   END IF
                END IF
                #FUN-D80022 --------End----------
                LET l_bmx09 = '0'          #FUN-550040
                #MOD-D50159---begin
                UPDATE bmx_file SET bmxmodu = g_user,bmxdate = g_today,bmx09 = l_bmx09
                 WHERE bmx01 = g_bmx.bmx01
                LET g_bmx.bmx09 = l_bmx09
                DISPLAY BY NAME g_bmx.bmx09
                #MOD-D50159---end
		COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmy[l_ac].* = g_bmy_t.*
               CLOSE i710_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           #MOD-A80018---add---start---
            IF g_bmy[l_ac].bmy03 MATCHES '[2345]' THEN  
               LET g_flag3 = 'Y'         #MOD-D90028 add 
               CALL i710_b_more('w') #No:7826     
               LET g_flag3 = 'N'         #MOD-D90028 add
            END IF
           #MOD-A80018---add---end---
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bmy[l_ac].bmy03,-263,1)
               LET g_bmy[l_ac].* = g_bmy_t.*
            ELSE
 
               CALL i710_b_move_back()
 
               UPDATE bmy_file SET * = b_bmy.*
                WHERE bmy01=g_bmx.bmx01
                  AND bmy02=g_bmy_t.bmy02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","bmy_file",g_bmx.bmx01,g_bmy_t.bmy02,SQLCA.sqlcode,"","",1)# TQC-660046
                  LET g_bmy[l_ac].* = g_bmy_t.*
               ELSE
                 #FUN-F50035 add start ---
                 #若與APS整合時，須同步update vlr_file及vls_file
                  IF g_sma.sma901 = 'Y' THEN  #與APS整合
                     LET l_cnt = 0 
                     CALL i710_chk_vlr('1',g_bmx.bmx01,g_bmy[l_ac].bmy02) RETURNING l_cnt  #chk vlr_file是否存在
                     IF l_cnt > 0 THEN
                       #若該料件在BOM無重複則bmy04無須有值,故從bom捉取該料件的BOM項次值
                        IF cl_null(g_bmy[l_ac].bmy04) THEN
                           LET l_vlr03 = 0 
                        ELSE 
                           LET l_vlr03 = g_bmy[l_ac].bmy04
                        END IF
                       
                        IF g_bmy[l_ac].bmy03 = '4' THEN
                           UPDATE vlr_file 
		              SET vlr01 = g_bmz[1].bmz02,
                                  vlr02 = g_bmy[l_ac].bmy27,
                                  vlr03 = l_vlr03,
                                  vlr13 = g_bmy[l_ac].vlr13,
                                  vlr16 = g_bmy[l_ac].vlr16,
                                  vlr17 = g_bmy[l_ac].vlr17,
                                  vlr18 = g_bmy[l_ac].vlr18
                            WHERE vlr00 = g_bmx.bmx01
                              AND vlr19 = g_bmy[l_ac].bmy02
                        ELSE
                           UPDATE vlr_file 
		              SET vlr01 = g_bmz[1].bmz02,
                                  vlr02 = g_bmy[l_ac].bmy05,
                                  vlr03 = l_vlr03,
                                  vlr13 = g_bmy[l_ac].vlr13,
                                  vlr16 = g_bmy[l_ac].vlr16,
                                  vlr17 = g_bmy[l_ac].vlr17,
                                  vlr18 = g_bmy[l_ac].vlr18
                            WHERE vlr00 = g_bmx.bmx01
                              AND vlr19 = g_bmy[l_ac].bmy02
                        END IF
                        
                        IF SQLCA.SQLCODE THEN
                           CALL cl_err3("upd","vlr_file",b_bmy.bmy01,"",SQLCA.sqlcode,"","upd vlr",1) 
                           LET g_bmy[l_ac].* = g_bmy_t.*
                        END IF
                     ELSE
                     IF g_bmy[l_ac].bmy03 = '4' THEN
                        INSERT INTO vlr_file (vlr00,vlr01,vlr02,vlr03,vlr19,
                                              vlr13,vlr16,vlr17,vlr18)
                        VALUES(g_bmx.bmx01,g_bmz[1].bmz02,g_bmy[l_ac].bmy27,l_vlr03,g_bmy[l_ac].bmy02,
                               g_bmy[l_ac].vlr13,g_bmy[l_ac].vlr16,g_bmy[l_ac].vlr17,g_bmy[l_ac].vlr18)
                     ELSE
                        INSERT INTO vlr_file (vlr00,vlr01,vlr02,vlr03,vlr19,
                                              vlr13,vlr16,vlr17,vlr18)
                        VALUES(g_bmx.bmx01,g_bmz[1].bmz02,g_bmy[l_ac].bmy05,l_vlr03,g_bmy[l_ac].bmy02,
                               g_bmy[l_ac].vlr13,g_bmy[l_ac].vlr16,g_bmy[l_ac].vlr17,g_bmy[l_ac].vlr18)
                     END IF
                     END IF
                     IF SQLCA.SQLCODE = 0 THEN
                       #若有替代料資料，則chk資料是否存在，不存在則INSERT，存在則update 
                       #若無替代料資料，則chk資料是否存在，存在則delete
                        LET l_cnt = 0 
                        CALL i710_chk_vls('1',g_bmx.bmx01,g_bmy[l_ac].bmy02) RETURNING l_cnt

                        IF NOT(cl_null(g_bmy[l_ac].vls11)) AND g_bmy[l_ac].vls11 <> 0 THEN
                           IF l_cnt = 0 THEN
                              IF g_bmy[l_ac].bmy03 = '4' THEN
                                 INSERT INTO vls_file (vls00,vls01,vls02,vls03,
                                                       vls12,vls11)
                                 VALUES(g_bmx.bmx01,g_bmz[1].bmz02,g_bmy[l_ac].bmy27, g_bmy[l_ac].bmy05,
                                        g_bmy[l_ac].bmy02,g_bmy[l_ac].vls11)
                              ELSE
                                 INSERT INTO vls_file (vls00,vls01,vls02,vls03,
                                                       vls12,vls11)
                                 VALUES(g_bmx.bmx01,g_bmz[1].bmz02,g_bmy[l_ac].bmy05, g_bmy[l_ac].bmy27,
                                        g_bmy[l_ac].bmy02,g_bmy[l_ac].vls11)
                              END IF
                              
                              IF SQLCA.SQLCODE THEN
                                 CALL cl_err3("ins","vls_file",b_bmy.bmy01,"",SQLCA.sqlcode,"","ins vls",1) 
                                 LET g_bmy[l_ac].* = g_bmy_t.*
                              END IF
                           ELSE
                              IF g_bmy[l_ac].bmy03 = '4' THEN
                                 UPDATE vls_file
                                    SET vls01 = g_bmz[1].bmz02,
                                        vls02 = g_bmy[l_ac].bmy27,
                                        vls03 = g_bmy[l_ac].bmy05,
                                        vls11 = g_bmy[l_ac].vls11
                                  WHERE vls00 = g_bmx.bmx01
                                    AND vls12 = g_bmy[l_ac].bmy02
                              ELSE
                                 UPDATE vls_file
                                    SET vls01 = g_bmz[1].bmz02,
                                        vls02 = g_bmy[l_ac].bmy05,
                                        vls03 = g_bmy[l_ac].bmy05,
                                        vls11 = g_bmy[l_ac].vls11
                                  WHERE vls00 = g_bmx.bmx01
                                    AND vls12 = g_bmy[l_ac].bmy02
                              END IF
                              IF SQLCA.SQLCODE THEN
                                 CALL cl_err3("upd","vls_file",b_bmy.bmy01,"",SQLCA.sqlcode,"","upd vls",1) 
                                 LET g_bmy[l_ac].* = g_bmy_t.*
                              END IF
                           END IF
                        ELSE
                           IF l_cnt > 0 THEN
                              DELETE FROM vls_file 
                               WHERE vls00 = g_bmx.bmx01
                              IF SQLCA.sqlcode THEN
                                 CALL cl_err3("del","vls_file",g_bmx.bmx01,"",SQLCA.SQLCODE,"","del vls: ",1)
                                 LET g_bmy[l_ac].* = g_bmy_t.*
                              END IF
                           END IF
                        END IF
                     END IF
                  END IF
                 #FUN-F50035 add end ---

                  MESSAGE 'UPDATE O.K'
                  LET l_bmx09 = '0'          #FUN-550040
                  #MOD-D50159---begin
                  UPDATE bmx_file SET bmxmodu = g_user,bmxdate = g_today,bmx09 = l_bmx09
                   WHERE bmx01 = g_bmx.bmx01
                  LET g_bmx.bmx09 = l_bmx09
                  DISPLAY BY NAME g_bmx.bmx09
                  #MOD-D50159---end
                  #FUN-D80022 ---------Begin---------
                   IF s_industry('slk') AND g_sma.sma150 = 'Y' THEN
                     #TQC-E90001--mark and add str--
                     #IF b_bmy.bmy05 <> g_bmy_t.bmy05 THEN  #更改元件
                     #   DELETE FROM bmya_file WHERE bmya01 = g_bmx.bmx01 AND bmya02 = g_bmy_t.bmy02
                     #   DELETE FROM bmyb_file WHERE bmyb01 = g_bmx.bmx01 AND bmyb02 = g_bmy_t.bmy02
                     #   DELETE FROM bmyc_file WHERE bmyc01 = g_bmx.bmx01 AND bmyc02 = g_bmy_t.bmy02
                     #   DELETE FROM bmyd_file WHERE bmyd01 = g_bmx.bmx01 AND bmyd02 = g_bmy_t.bmy02
                     #END IF
                      CALL i710_del_bmyx()
                     #TQC-E90001--mark and add end--
                      IF b_bmy.bmy02 <> g_bmy_t.bmy02 AND b_bmy.bmy05 = g_bmy_t.bmy05 AND b_bmy.bmy38=g_bmy_t.bmy38 THEN 
                         IF b_bmy.bmy38 = g_bmy_t.bmy38 THEN
                            IF b_bmy.bmy38 MATCHES '[23]' THEN
                               UPDATE bmya_file SET bmya02 = b_bmy.bmy02  
                                WHERE bmya01 = g_bmx.bmx01
                                  AND bmya02 = g_bmy_t.bmy02
                            END IF
                            IF b_bmy.bmy38 MATCHES '[24]' THEN
                               UPDATE bmyb_file SET bmyb02 = b_bmy.bmy02 
                                WHERE bmyb01 = g_bmx.bmx01
                                  AND bmyb02 = g_bmy_t.bmy02
                            END IF
                            IF b_bmy.bmy38 MATCHES '[56]' THEN
                               UPDATE bmyc_file SET bmyc02 = b_bmy.bmy02
                                WHERE bmyc01 = g_bmx.bmx01
                                  AND bmyc02 = g_bmy_t.bmy02
                            END IF
                            IF b_bmy.bmy38 MATCHES '[57]' THEN
                               UPDATE bmyd_file SET bmyd02 = b_bmy.bmy02 
                                WHERE bmyd01 = g_bmx.bmx01
                                  AND bmyd02 = g_bmy_t.bmy02
                            END IF
                         END IF
                      END IF
                    END IF
                  #FUN-D80022 ---------End-----------
                 #IF g_ima107='Y' AND g_bmy[l_ac].bmy03 MATCHES '[23456]' #CHI-960004 add 5 #CHI-C20060 #MOD-G90032 mark
                  IF g_ima107='Y' AND g_bmy[l_ac].bmy03 MATCHES '[23]'    #CHI-960004 add 5 #CHI-C20060 #MOD-G90032 add
                     AND g_bmy[l_ac].bmy06 <> g_bmy_t.bmy06 THEN
                     CALL i710_t()
                  END IF
                  COMMIT WORK
               END IF
            END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #TQC-D40054 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_bmy[l_ac].* = g_bmy_t.*
              #TQC-D40054--add--str--
              ELSE
                #MOD-FA0119--add--start-------------------------
                 IF g_bmy_t.bmy02 != g_bmy_o.bmy02 THEN
                    IF g_sma.sma150 = 'Y' THEN
                       CALL i710_upd_bmyc_slk(g_bmy[l_ac].bmy05,g_bmy[l_ac].bmy38,g_bmy_t.bmy02,g_bmy_o.bmy02) 
                    END IF
                 END IF
                 LET g_bmy_o.bmy02 = g_bmy_t.bmy02
                #MOD-FA0119--add--end---------------------------
                 CALL g_bmy.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "component_detail"
                    LET l_ac = l_ac_t
                 END IF
              #TQC-D40054--add--end--
              END IF
              CLOSE i710_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #TQC-D40054 add 
           CLOSE i710_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bmy02) AND l_ac > 1 THEN
                LET g_bmy[l_ac].* = g_bmy[l_ac-1].*
                LET g_bmy_o.* = g_bmy[l_ac].*   #MOD-G50111 add
                LET g_bmy[l_ac].bmy02 = NULL
                NEXT FIELD bmy02
            END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(bmy05)
                     IF g_bmy[l_ac].bmy03 MATCHES '[13456]' THEN #CHI-960004 add 5 #CHI-C20060
                         CALL cl_init_qry_var()
                         IF g_argv1='1' THEN  #CHI-CA0035 mod g_argv3->g_argv1 
                            LET g_qryparam.form = "q_bmb7" #FUN-560115
                         ELSE 
                         	  LET g_qryparam.form = "q_brb1"
                         END IF 
                         LET g_qryparam.default1 = g_bmy[l_ac].bmy05
                         LET g_qryparam.arg1     = g_bmx.bmx01
                         LET g_qryparam.arg2     = g_bmx.bmx07
                         LET g_qryparam.arg3     = g_bmx.bmx07
                         CALL cl_create_qry() RETURNING g_bmy[l_ac].bmy05
                     ELSE
#FUN-AA0059 --Begin--
                    #     CALL cl_init_qry_var()
                    #     LET g_qryparam.form = "q_ima"
                    #     LET g_qryparam.default1 = g_bmy[l_ac].bmy05
                    #     CALL cl_create_qry() RETURNING g_bmy[l_ac].bmy05
                         CALL q_sel_ima(FALSE, "q_ima", "", g_bmy[l_ac].bmy05, "", "", "", "" ,"",'' )  RETURNING g_bmy[l_ac].bmy05 
#FUN-AA0059 --End--
                     END IF
                      DISPLAY BY NAME g_bmy[l_ac].bmy05        #No.MOD-490371
                     NEXT FIELD bmy05
                WHEN INFIELD(bmy27)
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima"
                   #  LET g_qryparam.default1 = g_bmy[l_ac].bmy27
                   #  CALL cl_create_qry() RETURNING g_bmy[l_ac].bmy27
                      CALL q_sel_ima(FALSE, "q_ima", "",g_bmy[l_ac].bmy27 , "", "", "", "" ,"",'' )  RETURNING g_bmy[l_ac].bmy27
#FUN-AA0059 --End--
                      DISPLAY BY NAME g_bmy[l_ac].bmy27        #No.MOD-490371
                     NEXT FIELD bmy27
                ##--- 20221123 add by momo (S)
                WHEN INFIELD(bmy09)
                     CALL cl_init_qry_var()
                     CALL q_ecd( FALSE, TRUE,g_bmy[l_ac].bmy09) RETURNING g_bmy[l_ac].bmy09
                     DISPLAY BY NAME g_bmy[l_ac].bmy09
                     NEXT FIELD bmy09 
                ##--- 20221123 add by momo (E) 
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION mntn_item_detail
           CALL i710_b_more(p_cmd)
 
        ON ACTION mntn_insert_loc
           CALL i710_t()
 
        ON ACTION mntn_desc
           CALL i710_e()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033

        #FUN-D80022--add--str--
        ON ACTION define_color_size 
           IF NOT cl_null(g_bmy[l_ac].bmy38) THEN
              IF g_bmy[l_ac].bmy38 MATCHES '[234567]'  THEN  #區分
                 CALL i710_ins_bmyx(p_cmd)
              END IF
           END IF
        #FUN-D80022--add--end--
 
      END INPUT
      #MOD-D50159---begin
      #UPDATE bmx_file SET bmxmodu = g_user,bmxdate = g_today,bmx09 = l_bmx09
      # WHERE bmx01 = g_bmx.bmx01
      #LET g_bmx.bmx09 = l_bmx09
      #DISPLAY BY NAME g_bmx.bmx09
      #MOD-D50159---end
      CALL i710_field_pic()
 
      CLOSE i710_bcl
      COMMIT WORK
 
END FUNCTION
 
#主件查詢
FUNCTION i710_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 #CHI-790004
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL cl_set_act_visible("cancel", FALSE)
   DISPLAY ARRAY g_bmz TO s_bmz.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
   
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION help                     
         CALL cl_show_help()             
 
      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021
 
      ON ACTION controlg                 
         CALL cl_cmdask()                
 
   END DISPLAY
   CALL cl_set_act_visible("cancel", FALSE)
 
END FUNCTION
 
FUNCTION i710_chk_bmb()
   DEFINE l_errno     LIKE type_file.chr10
   DEFINE l_cnt       LIKE type_file.num5
 
   LET l_errno = NULL
   LET l_cnt = 0
   IF cl_null(g_bmy[l_ac].bmy04) THEN RETURN l_errno END IF
  #chk項次是否存在正式BOM中
   SELECT count(*) INTO l_cnt FROM bmb_file,bmz_file
    WHERE bmb01 = bmz02
      AND bmz01 = g_bmx.bmx01
      AND bmb02 = g_bmy[l_ac].bmy04
      AND bmb29 = bmz05
      AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
      AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
   IF l_cnt > 0 THEN 
      LET l_errno = 'mfg-015'
      RETURN l_errno
   END IF
  #chk項次是否存其它ECN變更單中 
   SELECT COUNT(*) INTO l_cnt FROM bmy_file,bmx_file,bmz_file 
    WHERE bmy03 = '2'
      AND bmy04 = g_bmy[l_ac].bmy04
      AND bmz05 in (SELECT bmz05 FROM bmz_file WHERE bmz01=g_bmx.bmx01)
      AND ((bmy01 != g_bmx.bmx01) OR
           (bmy01 = g_bmx.bmx01 AND bmy02 != g_bmy[l_ac].bmy02))
      AND bmy01 = bmx01
      AND bmy01 = bmz01
      AND bmx04 != 'Y'
      AND bmxacti = 'Y'
   IF l_cnt > 0 THEN 
      LET l_errno = 'abm-386'
      RETURN l_errno
   END IF
   RETURN l_errno
END FUNCTION
FUNCTION i710_bmy27(p_cmd)
DEFINE
    p_cmd      LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
    l_imaacti  LIKE ima_file.imaacti
 
    LET g_errno = ''
    SELECT ima02,ima021,imaacti INTO g_bmy[l_ac].ima02n,g_bmy[l_ac].ima021n,l_imaacti FROM ima_file
     WHERE ima01 = g_bmy[l_ac].bmy27
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1314'
                                   LET g_bmy[l_ac].ima02n = NULL
                                   LET g_bmy[l_ac].ima021n = NULL
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY BY NAME g_bmy[l_ac].ima02n
    DISPLAY BY NAME g_bmy[l_ac].ima021n
 
END FUNCTION
 
 
FUNCTION i710_b_move_to()
   LET g_bmy[l_ac].bmy02 = b_bmy.bmy02
   LET g_bmy[l_ac].bmy03 = b_bmy.bmy03
   LET g_bmy[l_ac].bmy04 = b_bmy.bmy04
   LET g_bmy[l_ac].bmy05 = b_bmy.bmy05
   LET g_bmy[l_ac].bmy38 = b_bmy.bmy38   #FUN-D80022 add
   LET g_bmy[l_ac].bmy06 = b_bmy.bmy06  
   LET g_bmy[l_ac].bmy07 = b_bmy.bmy07  
   LET g_bmy[l_ac].bmy09 = b_bmy.bmy09   #20221123  
   LET g_bmy[l_ac].bmy16 = b_bmy.bmy16  
   LET g_bmy[l_ac].bmy35 = b_bmy.bmy35   #CHI-A60028 add
   LET g_bmy[l_ac].bmy19 = b_bmy.bmy19
   LET g_bmy[l_ac].bmy27 = b_bmy.bmy27
   LET g_bmy[l_ac].bmy34 = b_bmy.bmy34   #no.MOD-840478
   LET g_bmy[l_ac].bmy36 = b_bmy.bmy36   #CHI-DC0015 add
END FUNCTION
 
FUNCTION i710_b_move_back()
 DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
   LET b_bmy.bmy02 = g_bmy[l_ac].bmy02
   LET b_bmy.bmy03 = g_bmy[l_ac].bmy03
   LET b_bmy.bmy04 = g_bmy[l_ac].bmy04
   LET b_bmy.bmy05 = g_bmy[l_ac].bmy05
   LET b_bmy.bmy38 = g_bmy[l_ac].bmy38   #FUN-D80022 add
   LET b_bmy.bmy06 = g_bmy[l_ac].bmy06  
   LET b_bmy.bmy07 = g_bmy[l_ac].bmy07  
   LET b_bmy.bmy09 = g_bmy[l_ac].bmy09   #20221123  
   LET b_bmy.bmy16 = g_bmy[l_ac].bmy16  
   LET b_bmy.bmy35 = g_bmy[l_ac].bmy35   #CHI-A60028 add
   LET b_bmy.bmy19 = g_bmy[l_ac].bmy19  
   LET b_bmy.bmy27 = g_bmy[l_ac].bmy27  
   LET b_bmy.bmy30 = g_bmy[l_ac].bmy30   #FUN-550014 add
   LET b_bmy.bmy34 = g_bmy[l_ac].bmy34   #no.MOD-840478 
   LET b_bmy.bmy22 = g_bmy[l_ac].bmy22   #no.CHI-960045 add 
   LET b_bmy.bmy36 = g_bmy[l_ac].bmy36   #CHI-DC0015 add 
END FUNCTION
#MOD-D10285---begin
FUNCTION i710_b_more1()
   DEFINE l_bmy RECORD LIKE bmy_file.*
   OPEN WINDOW i710_b_more_w WITH FORM "abm/42f/abmi710b"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("abmi710b")

   SELECT * INTO l_bmy.*
   FROM bmy_file
   WHERE bmy01 = g_bmx.bmx01
     AND bmy02 = g_bmy[l_ac].bmy02

   LET l_bmy.bmy09 = g_bmy[l_ac].bmy09   #20221123
   
   DISPLAY BY NAME
           l_bmy.bmy25, l_bmy.bmy26, l_bmy.bmy13, l_bmy.bmy18,
	       l_bmy.bmy08, l_bmy.bmy081,l_bmy.bmy082,l_bmy.bmy11, l_bmy.bmy20,
           l_bmy.bmy22, l_bmy.bmy09, l_bmy.bmy10,
	       l_bmy.bmy10_fac,l_bmy.bmy21,l_bmy.bmy23 

   MENU ""
      ON ACTION exit
         EXIT MENU
      ON ACTION cancel
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
      ON ACTION about        
         CALL cl_about()    
      ON ACTION help         
         CALL cl_show_help()
      ON ACTION controlg      
         CALL cl_cmdask()    
      ON ACTION close   
         EXIT MENU
 
     END MENU
   CLOSE WINDOW i710_b_more_w
END FUNCTION 
#MOD-D10285---end
FUNCTION i710_b_more(p_cmd)
   DEFINE ls_tmp        STRING
   DEFINE p_cmd         LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
   DEFINE l_code        LIKE type_file.chr1     #No.FUN-680096  VARCHAR(1)
   DEFINE l_ima04       LIKE ima_file.ima04
   DEFINE l_ima25       LIKE ima_file.ima25
   DEFINE l_ima86       LIKE ima_file.ima86
   DEFINE l_ima70       LIKE ima_file.ima70
   DEFINE l_ima562      LIKE ima_file.ima562
   DEFINE l_ima136      LIKE ima_file.ima136
   DEFINE l_ima137      LIKE ima_file.ima137
   DEFINE l_ima110      LIKE ima_file.ima110 #No.9806
   DEFINE l_item        LIKE ima_file.ima01
   DEFINE b_bmy_t	RECORD LIKE bmy_file.*
   DEFINE b_bmy_o	RECORD LIKE bmy_file.*      #MOD-A80227 add
   DEFINE sn1,sn2       LIKE type_file.num5     #No.FUN-680096  SMALLINT
   DEFINE l_bmb         RECORD LIKE bmb_file.*  #TQC-DA0052 add
   DEFINE l_bmy14       LIKE bmy_file.bmy14     #TQC-DA0052 add
   DEFINE l_bmy29       LIKE bmy_file.bmy29     #TQC-DA0052 add

   IF g_flag3 ='Y' THEN                                       #MOD-D90028 add
      CALL cl_set_act_visible("exit,cancel,close", FALSE)     #MOD-D90028 add
   END IF                                                     #MOD-D90028 add
 
   IF g_bmy[l_ac].bmy03 = '1' THEN
      CALL cl_err('','abm-014',1)
      RETURN
   END IF
 
   LET p_row = 4 LET p_col = 3
   OPEN WINDOW i710_b_more_w AT p_row,p_col WITH FORM "abm/42f/abmi710b"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmi710b")
   IF g_argv1='2' THEN   #CHI-CA0035 mod g_argv3->g_argv1
      CALL cl_set_comp_visible('bmy09',FALSE)
   END IF 
   LET b_bmy_t.*=b_bmy.*
   LET b_bmy_o.*=b_bmy.*      #MOD-A80227 add
   IF g_bmy[l_ac].bmy03 = '4' THEN
      SELECT ima25,ima86,ima110 INTO l_ima25,l_ima86,l_ima110 FROM ima_file
       WHERE ima01=g_bmy[l_ac].bmy27
   ELSE
      SELECT ima25,ima86,ima110 INTO l_ima25,l_ima86,l_ima110 FROM ima_file
       WHERE ima01=g_bmy[l_ac].bmy05
   END IF
   DISPLAY l_ima25 TO FORMONLY.ima25 #No:7826
 
   CALL i710_up_bmy13() #No:7958
 
   IF p_cmd MATCHES '[auw]' THEN #No:7826    #No.MOD-670125 modify  #No.MOD-840100 modify
      IF cl_null(b_bmy.bmy21) THEN         #MOD-C20154 add
         LET b_bmy.bmy21 = 'N'             #MOD-C20154 add
      END IF                               #MOD-C20154 add
      IF g_bmy[l_ac].bmy03 = '4' THEN
         LET l_item = g_bmy[l_ac].bmy27
      ELSE
         LET l_item = g_bmy[l_ac].bmy05
      END IF
     #IF g_bmy[l_ac].bmy03 MATCHES '[245]' AND cl_null(b_bmy.bmy10) THEN #FUN-850156#CHI-960004 add 5   #MOD-A80105 mark
     #IF (g_bmy[l_ac].bmy03 = '2' AND (g_bmy[l_ac].bmy05 != g_bmy_t.bmy05 OR g_bmy_t.bmy05 IS NULL)) OR             #MOD-A80105 add   #TQC-DA0052 mark
      IF (g_bmy[l_ac].bmy03 MATCHES '[23]' AND (g_bmy[l_ac].bmy05 != g_bmy_t.bmy05 OR g_bmy_t.bmy05 IS NULL)) OR                               #TQC-DA0052 add
         (g_bmy[l_ac].bmy03 MATCHES '[45]' AND (g_bmy[l_ac].bmy27 != g_bmy_t.bmy27 OR g_bmy_t.bmy27 IS NULL)) THEN  #MOD-A80105 add
         #TQC-DA0052-Start-Add            
         IF NOT cl_null(g_bmy[l_ac].bmy04) THEN
            SELECT * INTO l_bmb.* FROM bmb_file
             #M014 180208 By TSD.Tim---(S)
             #WHERE bmb01 = g_bmz[l_ac].bmz02
             WHERE bmb01 = g_bmz[1].bmz02
             #M014 180208 By TSD.Tim---(E)
               AND bmb02 = g_bmy[l_ac].bmy04
         ELSE
            SELECT * INTO l_bmb.* FROM bmb_file
             #M014 180208 By TSD.Tim---(S)
             #WHERE bmb01 = g_bmz[l_ac].bmz02
             WHERE bmb01 = g_bmz[1].bmz02
             #M014 180208 By TSD.Tim---(E)
               AND bmb03 = g_bmy[l_ac].bmy05
               #M014 180208 By TSD.Tim---(S)
               #AND bmb29 = g_bmz[l_ac].bmz05
               AND bmb29 = g_bmz[1].bmz05
               #M014 180208 By TSD.Tim---(E)
               AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL)
         END IF
         IF NOT cl_null(l_bmb.bmb18) THEN
              LET b_bmy.bmy18=l_bmb.bmb18
              LET b_bmy_t.bmy18=l_bmb.bmb18
           ELSE
              LET b_bmy.bmy18=0
              LET b_bmy_t.bmy18=0
           END IF
           IF NOT cl_null(l_bmb.bmb08) THEN
              LET b_bmy.bmy08=l_bmb.bmb08
              LET b_bmy_t.bmy08=l_bmb.bmb08
              LET b_bmy_o.bmy08 = l_bmb.bmb08  
           ELSE
              LET b_bmy.bmy08=0
              LET b_bmy_t.bmy08=0
              LET b_bmy_o.bmy08 = 0            
           END IF   
           IF NOT cl_null(l_bmb.bmb15) THEN
              LET b_bmy.bmy21 = l_bmb.bmb15
              LET b_bmy_t.bmy21 = l_bmb.bmb15
              LET b_bmy_o.bmy21 = l_bmb.bmb15
           ELSE
              LET b_bmy.bmy21 = 'N'
              LET b_bmy_t.bmy21 = 'N'
              LET b_bmy_o.bmy21 = 'N'
           END IF 
           IF NOT cl_null(l_bmb.bmb28) THEN
              LET b_bmy.bmy23 = l_bmb.bmb28
              LET b_bmy_t.bmy23 = l_bmb.bmb28
              LET b_bmy_o.bmy23 = l_bmb.bmb28
           ELSE
              LET b_bmy.bmy23 = 0
              LET b_bmy_t.bmy23 = 0
              LET b_bmy_o.bmy23 = 0
           END IF 
           IF NOT cl_null(l_bmb.bmb081) THEN
              LET b_bmy.bmy081=l_bmb.bmb081
              LET b_bmy_t.bmy081=l_bmb.bmb081
           ELSE
              LET b_bmy.bmy081=0
              LET b_bmy_t.bmy081=0
           END IF
           IF NOT cl_null(l_bmb.bmb082) THEN
              LET b_bmy.bmy082=l_bmb.bmb082
              LET b_bmy_t.bmy082=l_bmb.bmb082
           ELSE
              LET b_bmy.bmy082=1
              LET b_bmy_t.bmy082=1
           END IF
           IF NOT cl_null(l_bmb.bmb09) THEN
              LET b_bmy.bmy09=l_bmb.bmb09
              LET b_bmy_t.bmy09=l_bmb.bmb09
           ELSE
              LET b_bmy.bmy09=''
              LET b_bmy_t.bmy09=''
           END IF
         #TQC-DA0052-End-Add

         #TQC-DA0052-Start-Mark
         #LET b_bmy.bmy18=0
         #LET b_bmy_t.bmy18=0
         #LET b_bmy.bmy08=0
         #LET b_bmy_t.bmy08=0
         ##Add No:TQC-AC0300
         #LET b_bmy.bmy081=0
         #LET b_bmy_t.bmy081=0
         #LET b_bmy.bmy082=1
         #LET b_bmy_t.bmy082=1
         ##End Add No:TQC-AC0300
         #LET b_bmy.bmy09=''
         #LET b_bmy_t.bmy09=''
         #TQC-DA0052-End-Mark 
          SELECT ima63,ima63_fac,ima25,ima04,ima136,ima137,ima70,ima562,ima86     #MOD-C20093 add ima86
            INTO b_bmy.bmy10,b_bmy.bmy10_fac,l_ima25,
                 l_ima04,l_ima136,l_ima137,l_ima70,l_ima562,l_ima86               #MOD-C20093 add l_ima86
            FROM ima_file WHERE ima01=l_item
 
          CALL s_umfchk(l_item,b_bmy.bmy10,l_ima25)
                RETURNING g_sw,b_bmy.bmy10_fac  #發料/庫存單位
          IF g_sw THEN LET b_bmy.bmy10_fac = 1 END IF

          #MOD-C20093 str add-----
          CALL s_umfchk(l_item,b_bmy.bmy10,l_ima86)
               RETURNING g_sw,b_bmy.bmy10_fac2  #發料/成本單位
          IF g_sw THEN LET b_bmy.bmy10_fac2 = 1 END IF
          #MOD-C20093 end add-----
 
          IF cl_null(b_bmy.bmy10_fac) THEN
             LET b_bmy.bmy10_fac = 1
          END IF
 
          LET b_bmy_t.bmy10     = b_bmy.bmy10
          LET b_bmy_t.bmy10_fac = b_bmy.bmy10_fac
          DISPLAY BY NAME b_bmy.bmy10_fac
          LET b_bmy.bmy11 = l_ima04
          LET b_bmy.bmy25 = l_ima136
          LET b_bmy.bmy26 = l_ima137
          LET b_bmy.bmy21 = l_ima70
         #LET b_bmy.bmy08 = l_ima562   #MOD-A70152 mark
          IF cl_null(l_ima110) THEN LET l_ima110 = '1' END IF   # No.MOD-710092 add
          IF g_bmy[l_ac].bmy03 <> '3' THEN           #TQC-DA0052 add
             LET b_bmy.bmy20 = l_ima110    #No.9806
          ELSE                                       #TQC-DA0052 add
             LET b_bmy.bmy20 = l_bmb.bmb19           #TQC-DA0052 add
          END IF                                     #TQC-DA0052 add
          LET b_bmy_t.bmy20 = b_bmy.bmy20            #TQC-DA0052 add
          LET b_bmy_o.bmy20 = b_bmy.bmy20            #TQC-DA0052 add
          
       END IF 
 
       IF b_bmy.bmy03 MATCHES '[245]' THEN       #No.MOD-840026 add #CHI-960004 add 5 
          IF cl_null(b_bmy.bmy23) THEN LET b_bmy.bmy23=0 END IF #FUN-560201
          LET b_bmy.bmy23 = 0           #No.MOD-550047
       END IF          #No.MOD-840026 add
 
       DISPLAY BY NAME b_bmy.bmy10_fac,b_bmy.bmy13,b_bmy.bmy11
       DISPLAY BY NAME
         b_bmy.bmy25, b_bmy.bmy26, b_bmy.bmy13, b_bmy.bmy18,
         b_bmy.bmy08, b_bmy.bmy081,b_bmy.bmy082,b_bmy.bmy11, b_bmy.bmy20,   #No.9806 add bmy20 #Mod No:TQC-AC0300 add bmy081,bmy082
         b_bmy.bmy22, b_bmy.bmy09, b_bmy.bmy10,
        #b_bmy.bmy10_fac,b_bmy.bmy21,b_bmy.bmy34,b_bmy.bmy23   #MOD-8B0135 #TQC-AC0161
         b_bmy.bmy10_fac,b_bmy.bmy21,b_bmy.bmy23   #TQC-AC0161
       CALL cl_set_head_visible("","YES")         #No.FUN-6B0033
 
       CALL cl_set_comp_required("bmy20,bmy21",TRUE)
       IF g_bmy[l_ac].bmy03 MATCHES '[3]' THEN
          CALL cl_set_comp_required("bmy20,bmy21",FALSE)
       END IF
 
       INPUT BY NAME
         b_bmy.bmy25, b_bmy.bmy26, b_bmy.bmy18,   #No.MOD-670125 modify   delete bmy13
        #Mod No:TQC-AC0300
        #b_bmy.bmy08, b_bmy.bmy11, b_bmy.bmy20,   #No.9806 add bmy20
        #b_bmy.bmy22, b_bmy.bmy09, b_bmy.bmy10,
        ##b_bmy.bmy10_fac,b_bmy.bmy21,b_bmy.bmy34,b_bmy.bmy23  #TQC-AC0161
        #b_bmy.bmy10_fac,b_bmy.bmy21,b_bmy.bmy23              #TQC-AC0161
         b_bmy.bmy08, b_bmy.bmy081,b_bmy.bmy082,
         b_bmy.bmy09, b_bmy.bmy10, b_bmy.bmy10_fac,b_bmy.bmy21,b_bmy.bmy23,             #TQC-AC0161
         b_bmy.bmy11, b_bmy.bmy20,b_bmy.bmy22
        #End Mod No:TQC-AC0300
         WITHOUT DEFAULTS
 
 
        AFTER FIELD bmy08    #損耗率
            IF b_bmy.bmy08 < 0 OR b_bmy.bmy08 > 100 THEN
               CALL cl_err(b_bmy.bmy08,'mfg4063',0)
               LET b_bmy.bmy08 = b_bmy_t.bmy08
               DISPLAY BY NAME b_bmy.bmy08
               NEXT FIELD bmy08
            END IF
 
        #Add No:TQC-AC0300
        AFTER FIELD bmy081   #固定損耗量
           IF NOT i710_bmy081_check(b_bmy_t.bmy081) THEN NEXT FIELD bmy081 END IF   #No.FUN-BB0086 
            #No.FUN-BB0086--mark--start--
            #IF b_bmy.bmy081 < 0 THEN
            #   CALL cl_err(b_bmy.bmy081,'aec-020',0)
            #   LET b_bmy.bmy081 = b_bmy_t.bmy081
            #   DISPLAY BY NAME b_bmy.bmy081
            #   NEXT FIELD bmy081
            #END IF
            #No.FUN-BB0086--mark--end--

        AFTER FIELD bmy082   #损耗批量
            IF b_bmy.bmy082 <= 0 THEN
               CALL cl_err(b_bmy.bmy082,'alm-808',0)
               LET b_bmy.bmy082 = b_bmy_t.bmy082
               DISPLAY BY NAME b_bmy.bmy082
               NEXT FIELD bmy082
            END IF
        #End Add No:TQC-AC0300

        AFTER FIELD bmy25   #倉庫
            IF NOT cl_null(b_bmy.bmy25) THEN
               SELECT * FROM imd_file
                WHERE imd01=b_bmy.bmy25
                  AND imdacti='Y'
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("sel","imd_file",b_bmy.bmy25,"","mfg1100","","",1) # TQC-660046
                  NEXT FIELD bmy25
               END IF
               #No.FUN-AB0058  --Begin
               IF NOT s_chk_ware(b_bmy.bmy25) THEN
                  NEXT FIELD bmy25
               END IF
               #No.FUN-AB0058  --End
            END IF
            IF NOT s_imechk(b_bmy.bmy25,b_bmy.bmy26) THEN NEXT FIELD bmy26 END IF   #FUN-D40103 add
 
        AFTER FIELD bmy26   #發料儲位
            #FUN-D40103--mark--str--
            #IF NOT cl_null(b_bmy.bmy26) THEN
            #   SELECT * FROM ime_file
            #    WHERE ime01=b_bmy.bmy25
            #      AND ime02=b_bmy.bmy26
            #   IF SQLCA.SQLCODE THEN
            #       CALL cl_err3("sel","ime_file",b_bmy.bmy25,b_bmy.bmy26,"mfg1101","","",1) #TQC-660046 
            #       NEXT FIELD bmy26
            #   END IF
            #END IF
            #FUN-D40103--mark--end--
            IF cl_null(b_bmy.bmy26) THEN LET b_bmy.bmy26 = ' ' END IF               #FUN-D40103 add 
            IF NOT s_imechk(b_bmy.bmy25,b_bmy.bmy26) THEN NEXT FIELD bmy26 END IF   #FUN-D40103 add 

        AFTER FIELD bmy09   #作業編號
            IF NOT cl_null(b_bmy.bmy09) THEN
               SELECT * FROM ecd_file
                WHERE ecd01=b_bmy.bmy09
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("sel","ecd_file",b_bmy.bmy09,"",100,"","sel ecd_file",1) # TQC-660046 
                  NEXT FIELD bmy09
               END IF
            END IF

        #No.FUN-BB0086--add--start---    
        BEFORE FIELD bmy10
           IF p_cmd = 'u' THEN 
              LET b_bmy10_t = b_bmy.bmy10
           END IF 
        #No.FUN-BB0086--add--end---
        
        AFTER FIELD bmy10   #發料單位
            IF cl_null(b_bmy.bmy10) THEN
               LET b_bmy.bmy10 = b_bmy_t.bmy10
               DISPLAY BY NAME b_bmy.bmy10
            ELSE
               SELECT * FROM gfe_file
                WHERE gfe01=b_bmy.bmy10
               IF STATUS THEN
                  CALL cl_err3("sel","gfe_file",b_bmy.bmy10,"",SQLCA.SQLCODE,"","sel gfe",1) # TQC-660046  
                  LET b_bmy.bmy10 = b_bmy_t.bmy10
                  DISPLAY BY NAME b_bmy.bmy10
                  NEXT FIELD bmy10
               END IF
 
               IF g_bmy[l_ac].bmy03 = '4' THEN
                  LET l_item = g_bmy[l_ac].bmy27
               ELSE
                  LET l_item = g_bmy[l_ac].bmy05
               END IF
 
               SELECT ima25,ima86 INTO l_ima25,l_ima86 FROM ima_file
                WHERE ima01=l_item #No:7826
               IF (b_bmy.bmy10 != b_bmy_t.bmy10) OR cl_null(b_bmy_t.bmy10) THEN  #No:7826 #MOD-890184 add b_bmy_t.bmy10 
                  IF b_bmy.bmy10 != l_ima25 THEN
                     CALL s_umfchk(l_item,b_bmy.bmy10,l_ima25)
                          RETURNING g_sw,b_bmy.bmy10_fac  #發料/庫存單位
                          IF g_sw THEN
                             CALL cl_err(b_bmy.bmy10,'mfg2721',0)
                             LET b_bmy.bmy10 = b_bmy_t.bmy10
                             DISPLAY BY NAME b_bmy.bmy10
                             NEXT FIELD bmy10
                          END IF
                  ELSE
                     LET b_bmy.bmy10_fac  = 1
                  END  IF
               END  IF
 
               DISPLAY BY NAME b_bmy.bmy10_fac
               IF b_bmy.bmy10 != l_ima86  THEN #發料/成本單位
                  CALL s_umfchk(l_item,b_bmy.bmy10,l_ima86)
                       RETURNING g_sw,b_bmy.bmy10_fac2
                  IF g_sw THEN
                     CALL cl_err(g_bmy[l_ac].bmy05,'mfg2722',0)
                     LET b_bmy.bmy10 = b_bmy_t.bmy10
                     DISPLAY BY NAME b_bmy.bmy10
                     NEXT FIELD bmy10
                  END IF
               ELSE
                  LET b_bmy.bmy10_fac2 = 1
               END IF
               #No.FUN-BB0086--add--start---
               IF NOT cl_null(b_bmy.bmy081) AND b_bmy.bmy081 <> 0 THEN   #No.FUN-C20048 add
                  IF NOT i710_bmy081_check(b_bmy_t.bmy081) THEN 
                     LET b_bmy10_t = b_bmy.bmy10
                     LET b_bmy_t.bmy10 = b_bmy.bmy10
                     NEXT FIELD bmy081 
                  END IF 
               END IF   #No.FUN-C20048 add 
               LET b_bmy10_t = b_bmy.bmy10
               #No.FUN-BB0086--add--end---
 
            END IF
 
            LET b_bmy_t.bmy10 = b_bmy.bmy10
 
        AFTER FIELD bmy20
            IF b_bmy.bmy20 NOT MATCHES '[1234]' THEN
                  NEXT FIELD bmy20
            END IF
 
 
        ON ACTION controlp
          CASE
              WHEN INFIELD(bmy25) #倉庫
#No.FUN-AB0058  --Begin
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_imd"
#                   LET g_qryparam.default1 = b_bmy.bmy25
#                   LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                   CALL cl_create_qry() RETURNING b_bmy.bmy25
                    CALL q_imd_1(FALSE,TRUE,b_bmy.bmy25,"","","","") RETURNING b_bmy.bmy25
#No.FUN-AB0058  --End
                   DISPLAY BY NAME b_bmy.bmy25
                   NEXT FIELD bmy25
              WHEN INFIELD(bmy26) #發料儲位
#No.FUN-AB0058  --Begin
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_ime"
#                   LET g_qryparam.default1 = b_bmy.bmy26
#                   LET g_qryparam.arg1     = b_bmy.bmy25 #倉庫編號 #MOD-4A0063
#                   LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-4A0063
#                   CALL cl_create_qry() RETURNING b_bmy.bmy26
                   CALL q_ime_1(FALSE,TRUE,b_bmy.bmy26,b_bmy.bmy25,"","","","","") RETURNING b_bmy.bmy26
#No.FUN-AB0058  --End
                   DISPLAY BY NAME b_bmy.bmy26
                   NEXT FIELD bmy26
              WHEN INFIELD(bmy09) #作業編號
                   CALL q_ecd( FALSE, TRUE,b_bmy.bmy09) RETURNING b_bmy.bmy09
                   DISPLAY BY NAME b_bmy.bmy09
              WHEN INFIELD(bmy10) #單位檔
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.default1 = b_bmy.bmy10
                   CALL cl_create_qry() RETURNING b_bmy.bmy10
                   DISPLAY BY NAME b_bmy.bmy10
                   NEXT FIELD bmy10
              OTHERWISE EXIT CASE
          END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      #MOD-D90028-Start-Add  
      ON ACTION CLOSE 
         IF g_flag3 = 'Y' THEN 
            LET INT_FLAG = 0
            CONTINUE INPUT   
         ELSE 
            LET INT_FLAG = 1
            EXIT INPUT  
         END IF  
      ON ACTION EXIT 
         IF g_flag3 = 'Y' THEN 
            LET INT_FLAG = 0
            CONTINUE INPUT  
         ELSE 
            LET INT_FLAG = 1
            EXIT INPUT        
         END IF  
         
      ON ACTION CANCEL 
         IF g_flag3 = 'Y' THEN 
            LET INT_FLAG = 0
            CONTINUE INPUT     
         ELSE 
            LET INT_FLAG = 1
            EXIT INPUT     
         END IF     
     #MOD-D90028-End-Add
 
      END INPUT
 
    ELSE
      DISPLAY BY NAME
		b_bmy.bmy25, b_bmy.bmy26, b_bmy.bmy13, b_bmy.bmy18,
		b_bmy.bmy08, b_bmy.bmy081,b_bmy.bmy082,b_bmy.bmy11, b_bmy.bmy09, b_bmy.bmy10,  #Mod No:TQC-AC0300 add bmy081,bmy082
		b_bmy.bmy10_fac,b_bmy.bmy22,b_bmy.bmy21,b_bmy.bmy23
               #b_bmy.bmy34  #no.MOD-840426 add  #TQC-AC0161
            LET INT_FLAG = 0  ######add for prompt bug
      PROMPT '>' FOR CHAR g_chr
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END PROMPT
   END IF
 
   IF INT_FLAG THEN
     #LET b_bmy.*=b_bmy_t.*        #MOD-A80227 mark
      LET b_bmy.*=b_bmy_o.*        #MOD-A80227 add
      LET INT_FLAG=0
   ELSE
      IF p_cmd = 'u' THEN 
         BEGIN WORK
         UPDATE bmy_file SET * = b_bmy.*
          WHERE bmy01=g_bmx.bmx01
            AND bmy02=g_bmy_t.bmy02
         IF SQLCA.sqlcode THEN
            CALL cl_err('upd bmy',SQLCA.sqlcode,0)
            LET b_bmy.*=b_bmy_t.*
            ROLLBACK WORK
         ELSE
            COMMIT WORK
            MESSAGE 'UPDATE O.K'
         END IF
      END IF
   END IF

   IF g_flag3 ='Y' THEN                                   #MOD-D90028 add
      CALL cl_set_act_visible("exit,cancel,close", TRUE)  #MOD-D90028 add
   END IF                                                 #MOD-D90028 add
 
   CLOSE WINDOW i710_b_more_w
 
   LET g_bmy[l_ac].bmy22 = b_bmy.bmy22
 
END FUNCTION
 
FUNCTION i710_b_askkey()
#DEFINE l_wc2  LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(200) #20180820 mark
DEFINE l_wc2  STRING                   #No.FUN-680096 VARCHAR(200) #20180820 modify
 
    CONSTRUCT l_wc2 ON bmy02,bmy03,bmy19,bmy04,bmy05,bmy27,bmy38,bmy06      #CHI-710048 bmy27順序在bmy05後  #FUN-D80022 add bmy38
         FROM s_bmy[1].bmy02, s_bmy[1].bmy03, s_bmy[1].bmy19,               
              s_bmy[1].bmy04, s_bmy[1].bmy05,s_bmy[1].bmy27,                #CHI-710048 bmy27順序在bmy05後
              s_bmy[1].bmy38,s_bmy[1].bmy06                                 #FUN-D80022 add bmy38
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i710_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i710_b_fill(p_wc3)              #BODY FILL UP
#DEFINE p_wc3   LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(200) #20180820
DEFINE p_wc3   STRING                     #No.FUN-680096 VARCHAR(200) #20180820
DEFINE l_cnt   LIKE type_file.num5             #20190123 add
 
    LET g_sql =
       #----------------------------------CHI-DC0015------------------------(S)
       #--CHI-DC0015--mark
       #"SELECT UNIQUE bmy02,bmy03,bmy19,bmy04,bmy05,'','',bmy27,'','',bmy16,bmy35,bmy30,bmy38,bmy06,bmy07,", #FUN-550014 add bmy30 add TQC-850020 #CHI-A60028 add bmy35 #FUN-D80022 add bmy38
       #"       bmy34,", 　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　#no.MOD-840426 add   #No:CHI-960045 add ,
       #"       bmy22",                                                                                        #bugno:6845
       #--CHI-DC0015--mark
        "SELECT UNIQUE bmy02,bmy03,bmy19,bmy04,bmy05,",
        "              '','',bmy38,'','',                  ",  #FUN-F50035 add  #20201208 modify
        "              '','',bmy27,'','',bmy16,'',   ",        #FUN-F50035 add ''
       #"              bmy35,bmy30,bmy38,bmy06,bmy07,",        #20201208 mark
        "              bmy35,bmy30,bmy06,bmy07,",              #20201208 modify
        "              bmy09,",                                #20221123 add
        "              bmy34,bmy36,bmy22", 　　　　　　　　    #CHI-DC0015 add bmy36　
       #----------------------------------CHI-DC0015------------------------(E)
        " FROM bmy_file,bmz_file,  ima_file ",                                     #NO.TQC-740178
        " WHERE bmy01 ='",g_bmx.bmx01,"'",                                         #單頭
        "   AND bmz01 = bmy01 ",                                                   #NO.TQC-740178
        "   AND bmy_file.bmy05 = ima_file.ima01 AND ",p_wc3 CLIPPED,               #單身
        " ORDER BY 1"
 
    PREPARE i710_pb FROM g_sql
    DECLARE bmy_curs CURSOR FOR i710_pb
 
    CALL g_bmy.clear()
   #TQC-E90001--add str--
    CALL g_bmya_a.clear()
    CALL g_bmyb_b.clear()
    CALL g_bmyc_c.clear()
    CALL g_bmyd_d.clear()
   #TQC-E90001--add str--
    CALL ga_color.clear()  #20190123 add
    LET g_rec_b = 0
    LET g_cnt = 1
 
    FOREACH bmy_curs INTO g_bmy[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
 
        LET l_ac = g_cnt
 
        SELECT ima02,ima021 INTO g_bmy[g_cnt].ima02,g_bmy[g_cnt].ima021
          FROM ima_file
         WHERE ima01=g_bmy[l_ac].bmy05
        SELECT ima02,ima021 INTO g_bmy[g_cnt].ima02n,g_bmy[g_cnt].ima021n
          FROM ima_file
         WHERE ima01=g_bmy[l_ac].bmy27
 
       #FUN-F50035 add start ---
        IF g_sma.sma901 = 'Y' THEN  #與APS整合
           SELECT vlr13,vlr16,vlr17,vlr18 INTO g_bmy[g_cnt].vlr13,g_bmy[g_cnt].vlr16,g_bmy[g_cnt].vlr17,g_bmy[g_cnt].vlr18
             FROM vlr_file
            WHERE vlr00 = g_bmx.bmx01
              AND vlr19 = g_bmy[g_cnt].bmy02
           
           SELECT vls11 INTO g_bmy[g_cnt].vls11
             FROM vls_file
            WHERE vls00 = g_bmx.bmx01
              AND vls12 = g_bmy[g_cnt].bmy02
        END IF
       #FUN-F50035 add end ---

       ##---- 20190123 add by momo (S) 判斷變異別新舊元件單位是否相同
        IF NOT cl_null(g_bmy[g_cnt].bmy05) AND NOT cl_null(g_bmy[g_cnt].bmy27) THEN
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM bmy_file,ima_file a,ima_file b
            WHERE bmy05 = a.ima01 and bmy27=b.ima01
              AND bmy05 = g_bmy[g_cnt].bmy05
              AND bmy27 = g_bmy[g_cnt].bmy27
              AND bmy01 = g_bmx.bmx01
              AND a.ima25<>b.ima25
            IF l_cnt > 0 THEN
               LET ga_color[g_cnt].bmy02 = "red"
               LET ga_color[g_cnt].bmy06 = "red reverse"
               LET ga_color[g_cnt].bmy07 = "red reverse"
            END IF
        END IF
        ##---- 20190123 add by momo (E)

        LET g_cnt = g_cnt + 1
 
#MOD-B80208--begin--
#        IF g_cnt > g_max_rec THEN
#           CALL cl_err( '', 9035, 0 )
#           EXIT FOREACH
#        END IF
#MOD-B80208--end--
 
    END FOREACH

    CALL g_bmy.deleteElement(g_cnt)
 
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
 
      LET g_rec_b=g_cnt - 1
      DISPLAY g_rec_b TO FORMONLY.cn2
      LET g_cnt = 0
      DISPLAY ARRAY g_bmy TO s_bmy.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            EXIT DISPLAY
      END DISPLAY
    END IF
END FUNCTION
  
FUNCTION i710_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680096  VARCHAR(1)
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN  #TQC-D40054
   IF p_ud <> "G" OR g_action_choice = "detail" OR g_action_choice = "component_detail" THEN  #TQC-D40054
      RETURN
   END IF
 
   LET g_action_choice = " "
   DISPLAY ARRAY g_bmz TO s_bmz.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
      BEFORE DISPLAY
              EXIT DISPLAY
               
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      &include "qry_string.4gl"
    END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DIALOG ATTRIBUTES(UNBUFFERED)   #FUN-D80022 add
      DISPLAY ARRAY g_bmy TO s_bmy.* ATTRIBUTE(COUNT=g_rec_b)  #fun-d80022 add
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL DIALOG.setCellAttributes(ga_color) #20190123 add
     
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
            #FUN-D80022 ------Begin------
            IF s_industry('slk') AND g_sma.sma150 = 'Y' THEN
               IF l_ac <> 0 THEN
                  CALL i710_b_fill_slk()
                  CALL i710_bp_refresh_slk()                  
               END IF
            END IF

         ON ACTION accept
            LET g_action_choice="component_detail"
            LET l_ac = ARR_CURR()
            EXIT DIALOG
            #FUN-D80022 ------End--------
 
      END DISPLAY  #FUN-D80022 add
      #FUN-D80022--add--str--
         DISPLAY ARRAY g_bmya_a TO s_bmya_a.* ATTRIBUTES(COUNT=g_rec_b3)
         END DISPLAY  
         DISPLAY ARRAY g_bmyb_b TO s_bmyb_b.* ATTRIBUTES(COUNT=g_rec_b4)
         END DISPLAY
         DISPLAY ARRAY g_bmyc_c TO s_bmyc_c.* ATTRIBUTES(COUNT=g_rec_b5)
         END DISPLAY
         DISPLAY ARRAY g_bmyd_d TO s_bmyd_d.* ATTRIBUTES(COUNT=g_rec_b6)
         END DISPLAY
      #FUN-D80022--add--end--
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION first
         CALL i710_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION previous
         CALL i710_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION jump
         CALL i710_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION next
         CALL i710_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION last
         CALL i710_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL i710_field_pic()
 
      ON ACTION carry               
         LET g_action_choice = "carry" 
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

      ##---- 20241108 (S)
      ON ACTION check_sub
         LET g_action_choice = "check_sub"
         EXIT DIALOG
      ##---- 20241108 (E)

      ON ACTION download                      
         LET g_action_choice = "download"    
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

      ON ACTION qry_carry_history             
         LET g_action_choice = "qry_carry_history" 
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
                                                 
      ON ACTION ecnre_list                      
         LET g_bp_flag = 'list'                
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
   
      ON ACTION mntn_insert_loc
         LET g_action_choice ="mntn_insert_loc"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
           
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

    #@ON ACTION 主件單身
      ON ACTION master_item_detail
         LET g_action_choice="master_item_detail"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

    #@ON ACTION 元件單身
      ON ACTION component_detail
         LET g_action_choice="component_detail"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

    #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

    #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

    #CHI-D20010---end
    #@ON ACTION easyflow送簽
      ON ACTION easyflow_approval         #FUN-550040
         LET g_action_choice = "easyflow_approval"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
    #@ON ACTION 簽核狀況
      ON ACTION approval_status
         LET g_action_choice="approval_status"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
 
      #FUN-D80022--mark--str--
      #ON ACTION accept
      #   LET g_action_choice="component_detail"
      #   LET l_ac = ARR_CURR()
      #  # EXIT DISPLAY
      #   EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
      #FUN-D80022--mark--end--
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION related_document                #No.FUN-6A0002  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      #MOD-D10285---begin
      ON ACTION qry_item_detail
         LET g_action_choice="qry_item_detail"          
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
      #MOD-D10285---end 
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      ON ACTION qry_mstr_item         #主件查詢
         LET g_action_choice="qry_mstr_item"
         EXIT DIALOG  #FUN-D80022 DISPLAY -> DIALOG

      #FUN-D80022--add--str--
      ON ACTION define_color_size
         LET g_action_choice="define_color_size"
         LET l_action = "define_color_size"    #TQC-E90001
         EXIT DIALOG  
      #FUN-D80022--add--end--
      &include "qry_string.4gl"
   END DIALOG  #FUN-D80022 DISPLAY -> DIALOG
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i710_bp1(p_ud)                                                                                                             
   DEFINE   p_ud   LIKE type_file.chr1                                                                                              
                                                                                                                                    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                                                                                
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   LET g_action_choice = " "                                                                                                        
                                                                                                                                    
   DISPLAY ARRAY g_bmz TO s_bmz.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)     
      BEFORE DISPLAY                                                                                                                
         EXIT DISPLAY                                                                                                               
   END DISPLAY
   DISPLAY ARRAY g_bmy TO s_bmy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                                                          
      BEFORE DISPLAY                                                                                                                
         EXIT DISPLAY                                                                                                               
   END DISPLAY                                                                                                                      
                                                                                                                                    
   CALL cl_set_act_visible("accept,cancel", FALSE)                                                                                  
                                                                                                                                    
   DISPLAY ARRAY g_bmx_l TO s_bmx_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)                                                          
                                                                                                                                    
      BEFORE DISPLAY                                                                                                                
         CALL cl_navigator_setting( g_curs_index, g_row_count )                                                                     
                                                                                                                                    
      BEFORE ROW
         LET l_ac1 = ARR_CURR()                                                                                                     
         CALL cl_show_fld_cont()                                                                                                    
                                                                                                                                    
      ON ACTION main
         LET g_bp_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i710_fetch('/')
         END IF
         CALL cl_set_comp_visible("page20", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page20", TRUE)
         EXIT DISPLAY
      ON ACTION CONTROLS                                                                                                            
         CALL cl_set_head_visible("","AUTO")                                                                                        
      ON ACTION insert                                                                                                              
         LET g_action_choice="insert"                                                                                               
         EXIT DISPLAY                                                                                                               
      ON ACTION query                                                                                                               
         LET g_action_choice="query"                                                                                                
         EXIT DISPLAY                                                                                                               
      ON ACTION delete                                                                                                              
         LET g_action_choice="delete"                                                                                               
         EXIT DISPLAY                                                                                                               
      ON ACTION modify                                                                                                              
         LET g_action_choice="modify"                                                                                               
         EXIT DISPLAY                                                                                                               
      ON ACTION invalid                                                                                                             
         LET g_action_choice="invalid"                                                                                              
         EXIT DISPLAY                                                                                                               
      ON ACTION first                                                                                                               
         CALL i710_fetch('F')                                                                                                       
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN                                                                                                      
            CALL fgl_set_arr_curr(1)                                                                                                
         END IF                                                                                                                     
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION previous                                                                                                            
         CALL i710_fetch('P')                                                                                                       
         CALL cl_navigator_setting(g_curs_index, g_row_count)                                                                       
         IF g_rec_b1 != 0 THEN                                                                                                      
            CALL fgl_set_arr_curr(1)                                                                                                
         END IF                                                                                                                     
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION jump                                                                                                                
         CALL i710_fetch('/')                                                                                                       
         CALL cl_navigator_setting(g_curs_index, g_row_count)                                                                       
         IF g_rec_b1 != 0 THEN                                                                                                      
            CALL fgl_set_arr_curr(1)                                                                                                
         END IF                                                                                                                     
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION next
         CALL i710_fetch('N')                                                                                                       
         CALL cl_navigator_setting(g_curs_index, g_row_count)                                                                       
         IF g_rec_b1 != 0 THEN                                                                                                      
            CALL fgl_set_arr_curr(1)                                                                                                
         END IF                                                                                                                     
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION last                                                                                                                
         CALL i710_fetch('L')                                                                                                       
         CALL cl_navigator_setting(g_curs_index, g_row_count)                                                                       
         IF g_rec_b1 != 0 THEN                                                                                                      
            CALL fgl_set_arr_curr(1)                                                                                                
         END IF                                                                                                                     
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION help                                                                                                                
         LET g_action_choice="help"                                                                                                 
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION locale                                                                                                              
         CALL cl_dynamic_locale()                                                                                                   
         CALL cl_show_fld_cont()                                                                                                    
                                                                                                                                    
      ON ACTION exit                                                                                                                
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION controlg                                                                                                            
         LET g_action_choice="controlg"                                                                                             
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION accept                                                                                                              
         LET l_ac1 = ARR_CURR()                                                                                                     
         LET g_jump = l_ac1                                                                                                         
         LET mi_no_ask = TRUE
         LET g_bp_flag = NULL                                                                                                       
         CALL i710_fetch('/')                                                                                                       
         CALL cl_set_comp_visible("info", FALSE)                                                                                    
         CALL ui.interface.refresh()                                                                                                
         CALL cl_set_comp_visible("info", TRUE)                                                                                     
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG=FALSE                                                                                                         
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON IDLE g_idle_seconds                                                                                                        
         CALL cl_on_idle()                                                                                                          
         CONTINUE DISPLAY                                                                                                           
                                                                                                                                    
      ON ACTION about                                                                                                               
         CALL cl_about()                                                                                                            
             
      ON ACTION carry                                                                                                               
         LET g_action_choice = "carry"                                                                                              
         EXIT DISPLAY       

       ##---- 20241108 (S)
      ON ACTION check_sub
         LET g_action_choice = "check_sub"
         EXIT DISPLAY
      ##---- 20241108 (E)                                                                                                        
                                                                                                                                    
      ON ACTION download                                                                                                            
         LET g_action_choice = "download"                                                                                           
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION qry_carry_history                                                                                                   
         LET g_action_choice = "qry_carry_history"                                                                                  
         EXIT DISPLAY                                                                                                               
 
      ON ACTION mntn_insert_loc
         LET g_action_choice ="mntn_insert_loc"
         EXIT DISPLAY
      
    #@ON ACTION 主件單身                                                                                                            
      ON ACTION master_item_detail                                                                                                  
         LET g_action_choice="master_item_detail"                                                                                   
         EXIT DISPLAY                                                                                                               
    #@ON ACTION 元件單身                                                                                                            
      ON ACTION component_detail                                                                                                    
         LET g_action_choice="component_detail"                                                                                     
         EXIT DISPLAY                                                                                                               
    #@ON ACTION 備注                                                                                                                
      ON ACTION memo                                                                                                                
         LET g_action_choice="memo"                                                                                                 
         EXIT DISPLAY                                                                                                               
    #@ON ACTION 作廢                                                                                                                
      ON ACTION void                                                                                                                
         LET g_action_choice="void"                                                                                                 
         EXIT DISPLAY                                                                                                               
    #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
    #CHI-D20010---end
    #@ON ACTION easyflow送簽                                                                                                        
      ON ACTION easyflow_approval         #FUN-550040                                                                               
         LET g_action_choice = "easyflow_approval"                                                                                  
         EXIT DISPLAY                                                                                                               
    #@ON ACTION 確認
      ON ACTION confirm                                                                                                             
         LET g_action_choice="confirm"                                                                                              
         EXIT DISPLAY
 
    #@ON ACTION 簽核狀況                                                                                                            
      ON ACTION approval_status                                                                                                     
         LET g_action_choice="approval_status"                                                                                      
         EXIT DISPLAY
 
      ON ACTION agree                                                                                                               
         LET g_action_choice = 'agree'                                                                                              
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION deny                                                                                                                
         LET g_action_choice = 'deny'                                                                                               
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION modify_flow                                                                                                         
         LET g_action_choice = 'modify_flow'                                                                                        
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION withdraw                                                                                                            
         LET g_action_choice = 'withdraw'                                                                                           
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION org_withdraw                                                                                                        
         LET g_action_choice = 'org_withdraw'                                                                                       
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION phrase                                                                                                              
         LET g_action_choice = 'phrase'
         EXIT DISPLAY
                                                                                                                       
      ON ACTION related_document
        LET g_action_choice="related_document"                                                                                      
        EXIT DISPLAY                                                                                                                
                                                                                                                                    
      ON ACTION exporttoexcel                                                                                                       
         LET g_action_choice = 'exporttoexcel'                                                                                      
         EXIT DISPLAY                                                                                                               
      #MOD-D10285---begin
      ON ACTION qry_item_detail
         LET g_action_choice="qry_item_detail"          
         EXIT DISPLAY 
      #MOD-D10285---end                                                                                                                              
      AFTER DISPLAY                                                                                                                 
         CONTINUE DISPLAY                                                                                                           
                                                                                                                                    
      &include "qry_string.4gl"                                                                                                     
   END DISPLAY                                                                                                                      
   CALL cl_set_act_visible("accept,cancel", TRUE)                                                                                   
END FUNCTION                                                                                                                        
 
FUNCTION i710_d()
   DEFINE i      	LIKE type_file.num5    #No.FUN-680096 SMALLINT
   DEFINE l_bmx09       LIKE bmx_file.bmx09
 
   SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx.bmx01
    IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'u') THEN                                                                           
       CALL cl_err(g_bmx.bmx11,'aoo-045',1)                                                                                         
       RETURN                                                                                                                       
    END IF                                                                                                                          
   IF g_bmx.bmx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_bmx.bmx04 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_bmx.bmx04 = 'Y' THEN CALL cl_err('','abm-101',0) RETURN END IF      #No.TQC-740079
   IF g_bmx.bmx09 matches '[Ss]' THEN       #FUN-550040
         CALL cl_err('','apm-030',0)
         RETURN
   END IF
 
   LET g_success='Y'
 
   BEGIN WORK
 
   INITIALIZE g_bmz_t.* TO NULL
   CALL i710_d_fill(' 1=1')
   CALL i710_d_i()
   IF INT_FLAG = 0 THEN  #MOD-D50159
   #IF g_exit_sw='Y' THEN     #TQC-AB0240   #MOD-C20082 mark
   #IF g_exit_sw != 'Y' THEN  #TQC-AB0240 #TQC-AC0305--MARK   #MOD-C20082 取消mark  #TQC-C80106 mark 
    IF g_exit_sw='Y' THEN     #TQC-C80106
      CALL i710_d_fill(' 1=1')
 
      DISPLAY ARRAY g_bmz TO s_bmz.* ATTRIBUTE(COUNT=g_rec_d)
         BEFORE DISPLAY
                EXIT DISPLAY
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      END DISPLAY
      CALL cl_set_act_visible("accept,cancel", TRUE)
 
     #RETURN   #TQC-AC0305
    END IF
 
   #-----MOD-C20082---------mark
   ##TQC-AB0240 ------------add start------
   #IF g_exit_sw = 'Y' THEN
   #   ROLLBACK WORK
   #   CALL i710_delall()
   #ELSE
   ##TQC-AB0240 ------------add end-------------
   #-----END MOD-C20082-----mark
      DELETE FROM bmz_file WHERE bmz01=g_bmx.bmx01
      FOR i=1 TO g_bmz.getLength()
         IF g_bmz[i].bmz02 IS NULL THEN CONTINUE FOR END IF
         LET b_bmz.bmz01=g_bmx.bmx01
         LET b_bmz.bmz02=g_bmz[i].bmz02
         LET b_bmz.bmz04=g_bmz[i].bmz04
         LET b_bmz.bmz03=g_bmz[i].bmz03
         LET b_bmz.bmz05=g_bmz[i].bmz05   #FUN-550014 add
         LET b_bmz.bmz011=g_bmz[i].bmz011  #No.FUN-A60008
         LET b_bmz.bmz012=g_bmz[i].bmz012  #No.FUN-A60008 
         LET b_bmz.bmz013=g_bmz[i].bmz013  #No.FUN-A60008
         IF cl_null(b_bmz.bmz05) THEN LET b_bmz.bmz05 = ' ' END IF #CHI-960004
 
         LET b_bmz.bmzplant = g_plant 
         LET b_bmz.bmzlegal = g_legal 
 
         INSERT INTO bmz_file VALUES(b_bmz.*)

      END FOR
      IF g_success = 'Y' THEN
         LET l_bmx09 = '0'          #FUN-550040
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
      UPDATE bmx_file SET bmx09 = l_bmx09,
                          bmxmodu = g_user,#MOD-930124
                          bmxdate = g_today#MOD-930124
       WHERE bmx01 = g_bmx.bmx01
      LET g_bmx.bmx09 = l_bmx09
      DISPLAY BY NAME g_bmx.bmx09
      CALL i710_field_pic()
 
      CALL i710_d_fill(' 1=1')
 
      DISPLAY ARRAY g_bmz TO s_bmz.* ATTRIBUTE(COUNT=g_rec_d)
         BEFORE DISPLAY
             EXIT DISPLAY
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION controls                       #No.FUN-6B0033                                                                       
            CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      END DISPLAY
      ELSE  #MOD-D50159
         LET INT_FLAG = 0  #MOD-D50159
      END IF  #MOD-D50159
      CALL cl_set_act_visible("accept,cancel", TRUE)
   #END IF    #TQC-AB0240   #MOD-C20082 mark
END FUNCTION
 
FUNCTION i710_d_i()
   DEFINE l_n              LIKE type_file.num5      #No.FUN-680096 SMALLINT
   DEFINE l_ima            RECORD LIKE ima_file.*
   DEFINE l_flag           LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
   DEFINE i                LIKE type_file.num5      #No.FUN-680096 SMALLINT
   DEFINE l_bma05          LIKE bma_file.bma05,
          l_allow_insert   LIKE type_file.num5,     #可新增否   #No.FUN-680096 SMALLINT
          l_allow_delete   LIKE type_file.num5      #可刪除否   #No.FUN-680096 SMALLINT
   DEFINE l_chkinsitm      LIKE type_file.num5  #no.FUN-840033 add
   DEFINE l_bmr07          LIKE bmr_file.bmr07      #No.TQC-A30033
   DEFINE l_n1             LIKE type_file.num5      #No.FUN-A60008
   DEFINE l_ima08          LIKE ima_file.ima08      #CHI-E80001 add
   DEFINE l_cnt            LIKE type_file.num5      #FUN-F50035 add
   
   LET g_exit_sw = 'N'   #No.B241 010326 by linda add
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_bmz WITHOUT DEFAULTS FROM s_bmz.*
         ATTRIBUTE(COUNT=g_rec_d,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
           IF g_rec_d !=0 THEN
             CALL fgl_set_arr_curr(l_ac)
           END IF

 
         BEFORE ROW
            LET l_ac=ARR_CURR()
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            CALL i710_d_i_set_entry()
            CALL i710_d_i_set_no_entry()
         #No.FUN-A60008--begin   
         BEFORE INSERT 
            IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
               LET g_bmz[l_ac].bmz011=' '
               LET g_bmz[l_ac].bmz012=' '
               LET g_bmz[l_ac].bmz013=0
            END IF 
         #No.FUN-A60008--end    
         AFTER FIELD bmz02
            #FUN-D80022--add--str--
            IF l_ac > 1  AND s_industry('slk') AND g_sma.sma150 = 'Y' AND NOT cl_null(g_bmz[l_ac].bmz02) THEN 
               LET l_n1 = 0 
               SELECT COUNT(*) INTO l_n1 FROM ima_file x ,
                 (SELECT ima01,ima943,ima940,ima941 FROM ima_file 
                   WHERE ima01 = g_bmz[1].bmz02) y 
                WHERE x.ima01 = g_bmz[l_ac].bmz02 AND x.ima943 = y.ima943
                  AND x.ima940 = y.ima940 AND x.ima941 = y.ima941
               IF l_n1 <> 1 THEN 
                  CALL cl_err(g_bmz[l_ac].bmz02,'abm-387',1)
                  LET g_bmz[l_ac].bmz02 = ''
                  NEXT FIELD bmz02
               END IF 
            END IF 
            #FUN-D80022--add--end--
            #CHI-E80001-Start-Add  #新增，不可為Z:雜項料件
            LET l_ima08 = ''
            SELECT ima08 INTO l_ima08
              FROM ima_file
             WHERE ima01 = g_bmz[l_ac].bmz02
               AND imaacti = 'Y'  
            IF l_ima08 = 'Z' THEN 
               CALL cl_err(g_bmz[l_ac].bmz02,'mfg2752',1)
               NEXT FIELD bmz02 
            END IF    
            #CHI-E80001-End-Add
         #-----MOD-C20082---------
            CALL s_showmsg_init()  #FUN-C30119
            IF NOT i710_chk_bmz02_1(g_bmz[l_ac].bmz02,'b') THEN
               CALL s_showmsg()    #TQC-C60119
               NEXT FIELD bmz02
            END IF    
         #  CALL s_showmsg()       #FUN-C30119  #TQC-C60119 mark
         #TQC-C80106--mark--
         #TQC-C50024 ------------Begin--------------  
         #  LET g_multi_bmz02 = g_bmz[l_ac].bmz02 
         #  IF NOT cl_null(g_multi_bmz02) THEN
         #     CALL i710_insbmz()
         #  END IF 
         #TQC-C50024 ------------End----------------
         #TQC-C80106--mark--
         #   IF NOT cl_null(g_bmz[l_ac].bmz02)  THEN
         #      #FUN-AA0059 ----------------------------add start-----------------------
         #      IF NOT s_chk_item_no(g_bmz[l_ac].bmz02,'') THEN
         #         CALL cl_err('',g_errno,1)
         #         LET g_bmz[l_ac].bmz02 = g_bmz_t.bmz02
         #         DISPLAY BY NAME g_bmz[l_ac].bmz02
         #         NEXT FIELD bmz02
         #      END IF 
         #      #FUN-AA0059 ----------------------------add end---------------------                                         
         #  CALL s_field_chk(g_bmz[l_ac].bmz02,'3',g_plant,'bmz02') RETURNING g_flag2                                                           
         #  IF g_flag2 = '0' THEN                                                                                                         
         #     CALL cl_err(g_bmz[l_ac].bmz02,'aoo-043',1)                                                                                       
         #     LET g_bmz[l_ac].bmz02 = g_bmz_t.bmz02                                                                                                
         #     DISPLAY BY NAME g_bmz[l_ac].bmz02                                                                                                
         #     NEXT FIELD bmz02
         #  END IF
         #      #No.FUN-A60008--begin 
         #      IF g_argv3='1' THEN 
         #         IF g_sma.sma542='Y' THEN 
         #            SELECT COUNT(*) INTO l_n1 FROM bra_file WHERE bra01=g_bmz[l_ac].bmz02 
         #            IF l_n1>0 THEN 
         #               CALL cl_err('','abm-225',1)
         #               NEXT FIELD bmz02
         #            END IF 
         #         END IF 
         #      END IF 
         #      #No.FUN-A60008--end   
         #      #No.TQC-A30033--begin       
         #      IF NOT cl_null(g_bmx.bmx05) THEN
         #         SELECT bmr07 INTO l_bmr07 FROM bmr_file
         #                                  WHERE bmr01=g_bmx.bmx05
         #                                    AND bmrconf = 'Y' 
         #         IF g_bmz[l_ac].bmz02<>l_bmr07 THEN
         #            CALL cl_err('','abm-024',1)
         #            NEXT FIELD bmz02
         #         END IF
         #      END IF                                                                                                                  
         #      #No.TQC-A30033--end       
         #      SELECT ima05 INTO g_bmz[l_ac].bmz04
         #        FROM ima_file
         #       WHERE ima01=g_bmz[l_ac].bmz02
         #      IF STATUS THEN
         #         CALL cl_err3("sel","ima_file",g_bmz[l_ac].bmz02,"",STATUS,"","sel bma:",1) # TQC-660046
         #         LET g_bmz[l_ac].bmz02=NULL
         #         NEXT FIELD bmz02
         #      ELSE
         #         SELECT COUNT(*) INTO g_cnt FROM bma_file
         #            WHERE bma01=g_bmz[l_ac].bmz02 AND bmaacti='Y'
         #            IF g_cnt =0 THEN
         #               CALL cl_err(g_bmz[l_ac].bmz02,'abm-742',0)
         #               NEXT FIELD bmz02
         #            END IF
         #
         #         #TQC-AB0240 --------add start--------
         #         SELECT COUNT(*) INTO g_cnt FROM bma_file
         #          WHERE bma01=g_bmz[l_ac].bmz02
         #            AND bmaacti='Y'
         #            AND bma10 = '2'
         #         IF g_cnt =0 THEN
         #            CALL cl_err(g_bmz[l_ac].bmz02,'abm-038',0)
         #            NEXT FIELD bmz02
         #         END IF
         #         #TQC-AB0240 --------add end----------------
         #
         #         SELECT ima02,ima021 INTO g_bmz[l_ac].ima02_1,g_bmz[l_ac].ima021_1
         #           FROM ima_file
         #          WHERE ima01=g_bmz[l_ac].bmz02
         #         DISPLAY g_bmz[l_ac].ima02_1 TO FORMONLY.ima02_1
         #         DISPLAY g_bmz[l_ac].ima021_1 TO FORMONLY.ima021_1
         #      END IF
         #       IF NOT i710_chk_bmz02(g_bmz[l_ac].bmz02) THEN #MOD-570304
         #         CALL cl_err('chk bmz02','abm-710',0)
         #         NEXT FIELD bmz02
         #      END IF
         #      LET g_cnt = 0                                                                                                        
         #      SELECT COUNT(*) INTO g_cnt FROM bma_file                                                                             
         #       WHERE bma01=g_bmz[l_ac].bmz02                                                                                       
         #      IF g_cnt=0 THEN                                                                                                      
         #         CALL cl_err(g_bmz[l_ac].bmz02,'abm-748',0)                                                                        
         #         NEXT FIELD bmz02                                                                                                  
         #      END IF                                                                                                               
         #      LET g_cnt=0                                                                                                          
         #      SELECT COUNT(*) INTO g_cnt FROM bma_file                                                                             
         #       WHERE bmaacti='Y'                                                                                                   
         #      IF g_cnt=0 THEN                                                                                                      
         #         CALL cl_err(g_bmz[l_ac].bmz02,'abm-201',0)                                                                        
         #         NEXT FIELD bmz02                                                                                                  
         #      END IF                                                                                                               
         #   END IF
         #   IF g_sma.sma118 != 'Y' THEN
         #       IF cl_null(g_bmz[l_ac].bmz05) THEN
         #         LET g_bmz[l_ac].bmz05 = ' '
         #     END IF
         #     SELECT bma05 INTO l_bma05 FROM bma_file
         #      WHERE bma01=g_bmz[l_ac].bmz02
         #        AND bma06=g_bmz[l_ac].bmz05
         #     IF cl_null(l_bma05) OR l_bma05 > g_bmx.bmx07 THEN
         #        CALL cl_err(l_bma05,'abm-005',0)
         #        LET g_bmz[l_ac].bmz05=NULL
         #        NEXT FIELD bmz02
         #     END IF
         #   END IF
         #   CALL i710_chkinsitm() RETURNING l_chkinsitm
         #   IF NOT l_chkinsitm THEN
         #     NEXT FIELD bmz02
         #   END IF
         #-----END MOD-C20082-----
            
         #No.FUN-A60008--begin   
         AFTER FIELD bmz011 
            IF NOT cl_null(g_bmz[l_ac].bmz011) THEN 
               SELECT COUNT(*) INTO l_n FROM bra_file WHERE bra01=g_bmz[l_ac].bmz02 
                  AND bra011=g_bmz[l_ac].bmz011
                  AND braacti='Y' AND bra10='2' 
               IF l_n=0 THEN 
                  CALL cl_err('','abm-226',1)
                  NEXT FIELD bmz011
               END IF 
            END IF 
         AFTER FIELD bmz012 
            IF NOT cl_null(g_bmz[l_ac].bmz012) THEN 
               SELECT COUNT(*) INTO l_n FROM bra_file WHERE bra01=g_bmz[l_ac].bmz02 
                  AND bra011=g_bmz[l_ac].bmz011
                  AND bra012=g_bmz[l_ac].bmz012
                  AND braacti='Y' AND bra10='2' 
               IF l_n=0 THEN 
                  CALL cl_err('','abm-227',1)
                  NEXT FIELD bmz012
               END IF 
            END IF 
            IF cl_null(g_bmz[l_ac].bmz012) THEN 
               LET g_bmz[l_ac].bmz012=' '
            END IF             
         AFTER FIELD bmz013 
            IF NOT cl_null(g_bmz[l_ac].bmz013) THEN 
               SELECT COUNT(*) INTO l_n FROM bra_file WHERE bra01=g_bmz[l_ac].bmz02 
                  AND bra011=g_bmz[l_ac].bmz011
                  AND bra012=g_bmz[l_ac].bmz012
                  AND bra013=g_bmz[l_ac].bmz013
                  AND braacti='Y' AND bra10='2' 
               IF l_n=0 THEN 
                  CALL cl_err('','abm-228',1)
                  NEXT FIELD bmz013
               END IF 
            END IF     
            IF cl_null(g_bmz[l_ac].bmz013) THEN 
               LET g_bmz[l_ac].bmz013=0
            END IF                    
         #No.FUN-A60008--end    
        #MOD-DA0100-Start-Mark         
        #AFTER FIELD bmz03
        #   IF g_bmz[l_ac].bmz03 = g_bmz[l_ac].bmz04 THEN  
        #      CALL cl_err('','abm-982',1) 
        #      NEXT FIELD bmz03
        #   END IF      
        #MOD-DA0100-End-Mark    
         AFTER FIELD bmz05
               IF cl_null(g_bmz[l_ac].bmz05) THEN LET g_bmz[l_ac].bmz05 = ' ' END IF       #MOD-B40163 add
               IF NOT cl_null(g_bmz[l_ac].bmz02) THEN           #MOD-DB0007 add if
                  SELECT COUNT(*) INTO g_cnt FROM bma_file
                   WHERE bma01=g_bmz[l_ac].bmz02
                     AND bma06=g_bmz[l_ac].bmz05
                  IF g_cnt > 0 THEN
                     IF cl_null(g_bmz[l_ac].bmz05) THEN
                        LET g_bmz[l_ac].bmz05 = ' '
                     END IF
                     SELECT bma05 INTO l_bma05 FROM bma_file
                      WHERE bma01=g_bmz[l_ac].bmz02
                        AND bma06=g_bmz[l_ac].bmz05
                     IF cl_null(l_bma05) OR l_bma05 > g_bmx.bmx07 THEN
                        CALL cl_err(l_bma05,'abm-005',0)      #TQC-C80130 
                        LET g_bmz[l_ac].bmz05=NULL
                        NEXT FIELD bmz05
                     END IF
                  ELSE
                     IF NOT cl_null(g_bmz[l_ac].bmz02) THEN  #MOD-D30061
                        CALL cl_err(g_bmz[l_ac].bmz02,'abm-742',0)
                        LET g_bmz[l_ac].bmz05=NULL
                        NEXT FIELD bmz05
                     END IF  #MOD-D30061
                  END IF
               END IF                                          #MOD-DB0007 add
         AFTER ROW
            IF INT_FLAG THEN
               #LET INT_FLAG=0  #MOD-D50159
               LET g_exit_sw='Y'
               EXIT INPUT
            END IF
            IF cl_null(g_bmz[l_ac].bmz05) THEN
               LET g_bmz[l_ac].bmz05=' '
            END IF
       #TQC-C80106--add--
       
            LET g_cnt = 0 
            IF NOT cl_null(g_bmz[l_ac].bmz02) THEN           #MOD-DB0007 add if
               SELECT COUNT(*) INTO g_cnt FROM bma_file
                WHERE bma01=g_bmz[l_ac].bmz02
                  AND bma06=g_bmz[l_ac].bmz05
               IF g_cnt > 0 THEN
                  IF cl_null(g_bmz[l_ac].bmz05) THEN
                      LET g_bmz[l_ac].bmz05 = ' '
                  END IF
                  SELECT bma05 INTO l_bma05 FROM bma_file
                   WHERE bma01=g_bmz[l_ac].bmz02
                     AND bma06=g_bmz[l_ac].bmz05
                  IF cl_null(l_bma05) OR l_bma05 > g_bmx.bmx07 THEN
                     CALL cl_err(l_bma05,'abm-005',0)       
                     LET g_bmz[l_ac].bmz05=NULL
                     NEXT FIELD bmz05
                  END IF
               ELSE
                  CALL cl_err(g_bmz[l_ac].bmz02,'abm-742',0)
                  LET g_bmz[l_ac].bmz05=NULL
                  NEXT FIELD bmz05
               END IF
            END IF                                            #MOD-DB0007 add 
       #TQC-C80106--add--
            #No.FUN-A60008--begin
            IF cl_null(g_bmz[l_ac].bmz011) THEN
               LET g_bmz[l_ac].bmz011=' '
            END IF
            IF cl_null(g_bmz[l_ac].bmz012) THEN
               LET g_bmz[l_ac].bmz012=' '
            END IF
            IF cl_null(g_bmz[l_ac].bmz013) THEN
               LET g_bmz[l_ac].bmz013=0
            END IF            
            #No.FUN-A60008--end                         
            FOR i=1 TO g_bmz.getLength()
                IF i != l_ac THEN
                   IF g_bmz[i].bmz02 = g_bmz[l_ac].bmz02 
                      AND g_bmz[i].bmz05 = g_bmz[l_ac].bmz05 
                      AND g_bmz[i].bmz011 = g_bmz[l_ac].bmz011       #No.FUN-A60008
                      AND g_bmz[i].bmz012 = g_bmz[l_ac].bmz012       #No.FUN-A60008
                      AND g_bmz[i].bmz013 = g_bmz[l_ac].bmz013 THEN  #No.FUN-A60008
                      CALL cl_err ('','-239',1)
                      NEXT FIELD bmz02
                   END IF
                END IF
            END FOR

         BEFORE DELETE
 
            DELETE FROM bmz_file
             WHERE bmz01 = g_bmx.bmx01
               AND bmz02 = g_bmz[l_ac].bmz02
               AND bmz05 = g_bmz[l_ac].bmz05   #FUN-550014 add
               AND bmz011= g_bmz[l_ac].bmz011  #No.FUN-A60008 
               AND bmz012= g_bmz[l_ac].bmz012  #No.FUN-A60008 
               AND bmz013= g_bmz[l_ac].bmz013  #No.FUN-A60008 
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err3("del","bmz_file",g_bmx.bmx01,g_bmz[l_ac].bmz02,SQLCA.SQLCODE,"","",1) # TQC-660046
               ROLLBACK WORK
               CANCEL DELETE
               EXIT INPUT
            END IF
 
         AFTER INPUT
            LET l_flag = 'N'
            FOR i=1 TO g_bmz.getLength()
               IF g_bmz[i].bmz02 IS NOT NULL THEN
                  LET l_flag = 'Y'
                  EXIT FOR
               END IF
            END FOR
            IF l_flag = 'N' THEN NEXT FIELD bmz02 END IF
           #FUN-F50035 add str---
           #若有與APS整合，則更新bmz_file的主件資料時，則一併update vlr_file及vls_file的資料
            IF g_sma.sma901 = 'Y' THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM vlr_file
                WHERE vlr00 = g_bmx.bmx01      #ECN單號
                  AND vlr01 <> g_bmz[1].bmz02  #主件料件
               IF l_cnt > 0 THEN
                  UPDATE vlr_file
                     SET vlr01 = g_bmz[1].bmz02
                   WHERE vlr00 = g_bmx.bmx01
               END IF
               
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM vls_file
                WHERE vls00 = g_bmx.bmx01      #ECN單號
                  AND vls01 <> g_bmz[1].bmz02  #主件料件
               IF l_cnt > 0 THEN
                  UPDATE vls_file
                     SET vls01 = g_bmz[1].bmz02
                   WHERE vls00 = g_bmx.bmx01
               END IF
            END IF
           #FUN-F50035 add end---
 
         ON ACTION batch_gen_master_item
            CALL i710_g_bmz()
            CALL i710_d_fill( '1=1')
            EXIT INPUT
 
         ON ACTION controlp
            LET l_ac=ARR_CURR()
            CASE WHEN INFIELD(bmz02)
                 #FUN-B30171--begin
                 #CALL cl_init_qry_var()
                 ##No.TQC-A30033--begin   
                 #IF NOT cl_null(g_bmx.bmx05) THEN 
                 #   LET g_qryparam.form = "q_bmr2"
                 #   LET g_qryparam.arg1=g_bmx.bmx05
                 #ELSE 
                 #	  IF g_argv3='1' THEN                  #No.FUN-A60083
                 #      #LET g_qryparam.form = "q_bma"    #No.FUN-A60083
                 #      LET g_qryparam.form = "q_bma_1"   #No.FUN-A60083
                 #   ELSE                                 #No.FUN-A60083
                 #   	 LET g_qryparam.form = "q_bra_1"   #No.FUN-A60083
                 #   END IF                               #No.FUN-A60083
                 #END IF 
                 ##No.TQC-A30033--end
                 #LET g_qryparam.default1 = g_bmz[l_ac].bmz02
                 #CALL cl_create_qry() RETURNING g_bmz[l_ac].bmz02
                 #DISPLAY BY NAME g_bmz[l_ac].bmz02        #No.MOD-490371
                 #NEXT FIELD bmz02
                 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                # IF NOT cl_null(g_bmx.bmx05) THEN    #CHI-D10013   mark
                #    LET g_qryparam.form = "q_bmr2"   #CHI-D10013   mark
                #    LET g_qryparam.arg1=g_bmx.bmx05  #CHI-D10013   mark 
                # ELSE 
               	    IF g_argv1='1' THEN                  #CHI-CA0035 mod g_argv3->g_argv1
                       LET g_qryparam.form = "q_bma_1"   
                    ELSE                                 
                    	 LET g_qryparam.form = "q_bra_1"   
                    END IF                               
                # END IF                              #CHI-D10013   mark
                 CALL cl_create_qry() RETURNING g_multi_bmz02     
                 IF NOT cl_null(g_multi_bmz02) THEN 
                    CALL i710_insbmz()
                    IF g_success='Y' THEN 
                       CALL i710_d_fill(" 1=1")
                       CALL i710_bp_refresh()
                       CALL i710_d_i()
                       #MOD-D50159---begin
                       IF INT_FLAG = 1 THEN
                         LET INT_FLAG = 0
                       END IF 
                       #MOD-D50159---end
                       EXIT INPUT 
                    ELSE 
                    	 NEXT FIELD bmz02
                    END IF 
                 END IF  
                 NEXT FIELD bmz02                    
                 #FUN-B30171--end                  
                 #No.FUN-A60008--begin                 
                 WHEN INFIELD(bmz011)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bra1"
                 LET g_qryparam.arg1=g_bmz[l_ac].bmz02
                 LET g_qryparam.default1 = g_bmz[l_ac].bmz011
#                 LET g_qryparam.default2 = g_bmz[l_ac].bmz012
                 CALL cl_create_qry() RETURNING g_bmz[l_ac].bmz011
                 DISPLAY BY NAME g_bmz[l_ac].bmz011    
                 NEXT FIELD bmz011
                 WHEN INFIELD(bmz012)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bra2"
                 LET g_qryparam.arg1=g_bmz[l_ac].bmz02
                 LET g_qryparam.arg2=g_bmz[l_ac].bmz011
                 LET g_qryparam.default1 = g_bmz[l_ac].bmz012
                 CALL cl_create_qry() RETURNING g_bmz[l_ac].bmz012
                 IF cl_null(g_bmz[l_ac].bmz012) THEN 
                    LET g_bmz[l_ac].bmz012=' '
                 END IF 
                 DISPLAY BY NAME g_bmz[l_ac].bmz012       
                 NEXT FIELD bmz012
                 WHEN INFIELD(bmz013)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bra3"
                 LET g_qryparam.arg1=g_bmz[l_ac].bmz02
                 LET g_qryparam.arg2=g_bmz[l_ac].bmz011
                 LET g_qryparam.arg3=g_bmz[l_ac].bmz012
                 LET g_qryparam.default1 = g_bmz[l_ac].bmz013
                 CALL cl_create_qry() RETURNING g_bmz[l_ac].bmz013
                 DISPLAY BY NAME g_bmz[l_ac].bmz013       
                 NEXT FIELD bmz013                  
                 #No.FUN-A60008--end 
                # CHI-B40031 --- modify --- start ---
                 WHEN INFIELD(bmz05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_bmz05"
                    LET g_qryparam.arg1 = g_bmz[l_ac].bmz02
                    LET g_qryparam.default1 = g_bmz[l_ac].bmz05
                    CALL cl_create_qry() RETURNING g_bmz[l_ac].bmz05
                    DISPLAY BY NAME g_bmz[l_ac].bmz05
                    NEXT FIELD bmz05
                 #CHI-B40031 --- modify ---  end  ---
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                      #FUN-560115................begin
                                      
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      END INPUT
 
      #IF INT_FLAG THEN  #MOD-D50159
      #   LET INT_FLAG=0  #MOD-D50159
      #END IF  #MOD-D50159
 
END FUNCTION
 
FUNCTION i710_g_bmz()
   DEFINE ls_tmp    STRING
   DEFINE eff_date  LIKE type_file.dat      #No.FUN-680096  DATE
   DEFINE l_bmb01   LIKE bmb_file.bmb01     #FUN-560115
   DEFINE l_bmb03   LIKE bmb_file.bmb03     #FUN-560115
   DEFINE l_brb011  LIKE brb_file.brb011    #No.FUN-A60008  
   DEFINE l_brb012  LIKE brb_file.brb012    #No.FUN-A60008
   DEFINE l_brb013  LIKE brb_file.brb013    #No.FUN-A60008
   DEFINE l_n       LIKE type_file.num5     #No.FUN-A60008
   DEFINE l_bmz02   LIKE bmz_file.bmz02     #No.FUN-D80022
  
   LET p_row = 4 LET p_col = 3
   OPEN WINDOW i710_g_bmz_w AT p_row,p_col WITH FORM "abm/42f/abmi710a"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmi710a")
   CALL cl_set_comp_visible("bmb29",g_sma.sma118='Y')
   #No.FUN-A60008--begin
   IF g_argv1='2' THEN   #CHI-CA0035 mod g_argv3->g_argv1
      CALL cl_set_comp_visible("brb011,brb012,brb013",TRUE)
   ELSE 
   	  CALL cl_set_comp_visible("brb011,brb012,brb013",FALSE)
   END IF 	
   #No.FUN-A60008--end 
   #FUN-C30119---begin
#TQC-C60179 ------------Begin-------------
#  LET g_sql = "cho.type_file.chr1,",
#              "bmz01.bmz_file.bmz01,",
#          "bmz02.bmz_file.bmz02,",
#          "bmz03.bmz_file.bmz03,",
#          "bmz04.bmz_file.bmz04,",
#          "bmz05.bmz_file.bmz05,",
#          "bmzplant.bmz_file.bmzplant,",
#          "bmzlegal.bmz_file.bmzlegal,",
#          "bmz011.bmz_file.bmz011,",
#          "bmz012.bmz_file.bmz012,",
#          "bmz013.bmz_file.bmz013 "
#  LET l_table = cl_prt_temptable('i710_tmp_table',g_sql) CLIPPED
#  IF l_table = -1 THEN
#     CALL cl_err('Create i710_tmp_table fail','',0)  
#     LET g_success = 'N'      
#     RETURN
#  END IF
#TQC-C60179 ------------End--------------
#TQC-C60179 ------------Begin------------
   DROP TABLE abmi710_tmp
   CREATE TEMP TABLE abmi710_tmp(
                  cho        LIKE type_file.chr1,
                  bmz01      LIKE bmz_file.bmz01,
                  bmz02      LIKE bmz_file.bmz02,
                  bmz03      LIKE bmz_file.bmz03,
                  bmz04      LIKE bmz_file.bmz04,
                  bmz05      LIKE bmz_file.bmz05,
                  bmzplant   LIKE bmz_file.bmzplant,
                  bmzlegal   LIKE bmz_file.bmzlegal,
                  bmz011     LIKE bmz_file.bmz011,
                  bmz012     LIKE bmz_file.bmz012,
                  bmz013     LIKE bmz_file.bmz013)
   DELETE FROM abmi710_tmp
#TQC-C60179 ------------End--------------

#  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,   #TQC-C60179  mark
   LET g_sql = "INSERT INTO abmi710_tmp ",                   #TQC-C60179
	       " (cho,bmz01,bmz02,bmz03,bmz04,bmz05,bmzplant,bmzlegal,bmz011,bmz012,bmz013) ",
	       "VALUES (?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_tmp_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_tmp_prep:',status,1)
      RETURN
   END IF
   #FUN-C30119---end
   WHILE TRUE
     CONSTRUCT BY NAME g_wc ON bmb01,bmb29,bmb03,brb011,brb012,brb013  #FUN-550014 add bmb29 #No.FUN-A60008 add bmz011,bmz012,bmz013
              BEFORE CONSTRUCT              #No.FUN-580031 --end--       HCN
                 CALL cl_qbe_init()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
     
     CALL cl_cmdask()     #MOD-4C0121
     ON ACTION CONTROLP
        IF INFIELD(bmb01) THEN
           CALL cl_init_qry_var()
           #No.TQC-A30033--begin
          # IF NOT cl_null(g_bmx.bmx05) THEN     #CHI-D10013   mark
          #    LET g_qryparam.form = "q_bmr2"    #CHI-D10013   mark
          #    LET g_qryparam.arg1=g_bmx.bmx05   #CHI-D10013   mark
          # ELSE                                 #CHI-D10013   mark 
           IF g_argv1='1' THEN                  #No.FUN-A60083  #CHI-CA0035 mod g_argv3->g_argv1
                 LET g_qryparam.form = "q_bmb5"
                 LET g_qryparam.arg1 = g_bmx.bmx07
              #No.FUN-A60083--begin   
              ELSE 
              	 LET g_qryparam.form = "q_brb_1"
                 LET g_qryparam.arg1 = g_bmx.bmx07
              END IF                            
              #No.FUN-A60083--end 
          # END IF                             #CHI-D10013   mark
           #No.TQC-A30033--end
           CALL cl_create_qry() RETURNING l_bmb01
           DISPLAY l_bmb01 TO bmb01
           NEXT FIELD bmb01
        END IF
        IF INFIELD(bmb03) THEN
           CALL cl_init_qry_var()
           #No.TQC-A30032--begin
           IF NOT cl_null(l_bmb01) THEN 
              LET g_qryparam.form = "q_bmb9" 
           ELSE
              LET g_qryparam.form = "q_bmb8"
           END IF 
           LET g_qryparam.arg1 = g_bmx.bmx07
           LET g_qryparam.arg2 = l_bmb01 
           #No.TQC-A30032--END 
           CALL cl_create_qry() RETURNING l_bmb03
           DISPLAY l_bmb03 TO bmb03
           NEXT FIELD bmb03
        END IF
        #No.FUN-A60008--begin
        IF INFIELD(brb011) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_bra011" 
           LET g_qryparam.arg1 = l_bmb01 
           CALL cl_create_qry() RETURNING l_brb011
           DISPLAY l_brb011 TO brb011
           NEXT FIELD brb011
        END IF 
        IF INFIELD(brb012) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_bra012" 
           LET g_qryparam.arg1 = l_bmb01 
           CALL cl_create_qry() RETURNING l_brb012
           DISPLAY l_brb012 TO brb012
           NEXT FIELD brb012
        END IF 
        IF INFIELD(brb013) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_bra013" 
           LET g_qryparam.arg1 = l_bmb01 
           CALL cl_create_qry() RETURNING l_brb013
           DISPLAY l_brb013 TO brb013
           NEXT FIELD brb013
        END IF                 
        #No.FUN-A60008--end 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
     END CONSTRUCT
     IF INT_FLAG THEN EXIT WHILE END IF
     IF g_wc=' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
     EXIT WHILE
   END WHILE
   IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW i710_g_bmz_w RETURN END IF
   LET eff_date =g_today
   DISPLAY BY NAME eff_date
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   INPUT BY NAME eff_date WITHOUT DEFAULTS
      AFTER FIELD eff_date
          IF eff_date IS NULL THEN NEXT FIELD eff_date END IF
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
     END INPUT
   IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW i710_g_bmz_w RETURN END IF
   #No.FUN-A60008--begin
   IF g_argv1='2' THEN    #CHI-CA0035 mod g_argv3->g_argv1
      LET g_wc=cl_replace_str(g_wc,"bmb01","brb01")
      LET g_wc=cl_replace_str(g_wc,"bmb03","brb03")
   END IF 
   IF g_argv1='1' THEN    #CHI-CA0035 mod g_argv3->g_argv1
      LET g_sql="SELECT DISTINCT bmb01,bmb29,'','','' FROM bmb_file,bma_file ", #FUN-550014 add bmb29
                " WHERE bma01=bmb01 ",
                "   AND bma06=bmb29 ", #FUN-550014 add
                #"   AND (bma05 IS NOT NULL AND bma05 <='",eff_date,"') ",      #No.FUN-A60008
                "   AND ",g_wc CLIPPED
      
      IF eff_date IS NOT NULL THEN
         LET g_sql=g_sql CLIPPED,
                   " AND (bmb04 IS NULL OR bmb04<='",eff_date,"')",
                   " AND (bmb05 IS NULL OR bmb05>'",eff_date,"')"
      END IF
      LET g_sql = g_sql CLIPPED," AND bmaacti='Y' " #MOD-950247  
   ELSE 
      LET g_sql="SELECT DISTINCT brb01,brb29,brb011,brb012,brb013 FROM brb_file,bra_file ", 
                " WHERE bra01=brb01 ",
                "   AND bra06=brb29 ",
                "   AND ",g_wc CLIPPED
      
      IF eff_date IS NOT NULL THEN
         LET g_sql=g_sql CLIPPED,
                   " AND (brb04 IS NULL OR brb04<='",eff_date,"')",
                   " AND (brb05 IS NULL OR brb05>'",eff_date,"')"
      END IF
      LET g_sql = g_sql CLIPPED," AND braacti='Y' "    	  
   END IF 
   #No.FUN-A60008--end 
   PREPARE i710_g_bmz_p FROM g_sql
   DECLARE i710_g_bmz_c CURSOR FOR i710_g_bmz_p
   LET b_bmz.bmz01=g_bmx.bmx01
   LET g_cnt=0
   CALL s_showmsg_init()  #FUN-C30119
   LET l_bmz02 = ''   #FUN-D80022 add
   FOREACH i710_g_bmz_c INTO b_bmz.bmz02,b_bmz.bmz05,b_bmz.bmz011,b_bmz.bmz012,b_bmz.bmz013 #FUN-550014 add bmz05  #No.FUN-A60008 add bmz011,bmz012,bmz013
      IF s_industry('slk') AND g_sma.sma150 = 'Y' THEN #MOD-E30063 add 
         #FUN-D80022--add--str--
         IF cl_null(l_bmz02) THEN 
            LET l_bmz02 = b_bmz.bmz02
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM ima_file x ,
              (SELECT ima01,ima943,ima940,ima941 FROM ima_file
                WHERE ima01 = l_bmz02) y
             WHERE x.ima01 = b_bmz.bmz02 AND x.ima943 = y.ima943
               AND x.ima940 = y.ima940 AND x.ima941 = y.ima941
            IF l_n <> 1 THEN
               CALL s_errmsg('bmz02',b_bmz.bmz02,'','abm-387',1)
               CONTINUE FOREACH
            END IF
         END IF 
        #FUN-D80022--add--end--
      END IF           #MOD-E30063 add 
    #取得主件舊版本記錄
     SELECT ima05 INTO b_bmz.bmz04 FROM ima_file
      WHERE ima01 = b_bmz.bmz02
     IF cl_null(b_bmz.bmz05) THEN LET b_bmz.bmz05 = ' ' END IF #CHI-960004
     IF cl_null(b_bmz.bmz011) THEN LET b_bmz.bmz011=' ' END IF   #No.FUN-A60008
     IF cl_null(b_bmz.bmz012) THEN LET b_bmz.bmz012=' ' END IF   #No.FUN-A60008
     IF cl_null(b_bmz.bmz013) THEN LET b_bmz.bmz013=0 END IF   #No.FUN-A60008
     LET b_bmz.bmzplant = g_plant 
     LET b_bmz.bmzlegal = g_legal 
     LET b_bmz.bmz03 = b_bmz.bmz04  #MOD-DA0100 add
     #当abmi710时，且sma542='Y',如果该主件存在于bra_file且bra014='Y' 则不允许录入该主件，改由abmi711输入
     #No.FUN-A60008--begin
     IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
        IF g_sma.sma542='Y' THEN 
           SELECT COUNT(*) INTO l_n FROM bra_file WHERE bra01=b_bmz.bmz02 AND bra014='Y' 
           IF l_n > 0 THEN 
              CONTINUE FOREACH 
           END IF 
        END IF 
     END IF 
     #No.FUN-A60008--end
     #-----MOD-C20082--------- 
     IF NOT i710_chk_bmz02_1(b_bmz.bmz02,'p') THEN  
        CONTINUE FOREACH
     END IF
     #-----END MOD-C20082-----
     #INSERT INTO bmz_file VALUES(b_bmz.*) #FUN-C30119
     EXECUTE insert_tmp_prep USING 'N',b_bmz.* #FUN-C30119

   END FOREACH
   CALL s_showmsg()       #FUN-C30119
   CALL i710_g_bmz1()  #FUN-C30119
   CLOSE WINDOW i710_g_bmz_w
   LET g_cnt=1
 
END FUNCTION
#FUN-C30119---begin
FUNCTION i710_g_bmz1()
DEFINE l_bmz1    DYNAMIC ARRAY OF RECORD
          cho      LIKE type_file.chr1,
          bmz02    LIKE bmz_file.bmz02,
          ima02    LIKE ima_file.ima02,
          ima021   LIKE ima_file.ima021,
          ta_ima06 LIKE ima_file.ta_ima06, #20191005
          bmz04    LIKE bmz_file.bmz04,
          bmz05    LIKE bmz_file.bmz05,
          bmz011   LIKE bmz_file.bmz011,
          bmz012   LIKE bmz_file.bmz012,
          bmz013   LIKE bmz_file.bmz013
                 END RECORD
DEFINE l_bmz     RECORD LIKE bmz_file.*
DEFINE l_i       LIKE type_file.num5
DEFINE l_ac      LIKE type_file.num5

     OPEN WINDOW i710_g_bmz1_w AT p_row,p_col WITH FORM "cbm/42f/abmi710f"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
     CALL cl_ui_locale("abmi710f")
     CALL cl_set_comp_visible("bmz05",g_sma.sma118='Y')
     IF g_argv1='2' THEN   #CHI-CA0035 mod g_argv3->g_argv1
        CALL cl_set_comp_visible('bmz011,bmz012,bmz013',TRUE)
     ELSE 
    	  CALL cl_set_comp_visible('bmz011,bmz012,bmz013',FALSE)
     END IF 

     LET g_sql="SELECT cho,bmz02,'','','',bmz04,bmz05,bmz011,bmz012,bmz013", #20191005
	       #   "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,         #TQC-C60179
                   "  FROM abmi710_tmp",         #TQC-C60179
               "  ORDER BY bmz02 DESC "
               
     PREPARE i710_tmp_p FROM g_sql
     DECLARE i710_tmp_cur CURSOR FOR i710_tmp_p

     LET g_sql="SELECT bmz01,bmz02,bmz03,bmz04,bmz05,bmzplant,bmzlegal,bmz011,bmz012,bmz013",
	       #   "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,         #TQC-C60179
                   "  FROM abmi710_tmp",         #TQC-C60179
               "  WHERE cho = 'Y' "
     PREPARE i710_tmp_p1 FROM g_sql          
     DECLARE i710_tmp_cur1 CURSOR FOR i710_tmp_p1

#    LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,           #TQC-C60179       
     LET g_sql = "UPDATE abmi710_tmp",           #TQC-C60179        
                 "   SET cho = ? ",
                 " WHERE bmz02 = ? AND bmz05 = ? AND bmz011 = ? AND bmz012 = ? AND bmz013 = ?"
     PREPARE i710_upd_tmp FROM g_sql
     
     CALL l_bmz1.clear()
     LET g_rec_b = 0
     LET l_i = 1

    FOREACH i710_tmp_cur INTO l_bmz1[l_i].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach_tmp:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       SELECT ima02,ima021,ta_ima06                                       #20191005
         INTO l_bmz1[l_i].ima02, l_bmz1[l_i].ima021, l_bmz1[l_i].ta_ima06 #20191005
         FROM ima_file
        WHERE ima01 = l_bmz1[l_i].bmz02
       LET l_i = l_i + 1
    END FOREACH
    CALL l_bmz1.deleteElement(l_i)
#   LET g_rec_b = l_i - 1          #TQC-C60179  mark
    LET g_rec_b2 = l_i - 1         #TQC-C60179
    CALL ui.Interface.refresh()
#   DISPLAY ARRAY  l_bmz1 TO s_bmz1.* ATTRIBUTE( COUNT = g_rec_b)    #TQC-C60179 mark
    DISPLAY ARRAY  l_bmz1 TO s_bmz1.* ATTRIBUTE( COUNT = g_rec_b2)   #TQC-C60179
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

    INPUT ARRAY l_bmz1 FROM s_bmz1.*
#    ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,    #TQC-C60179 mark
     ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,   #TQC-C60179
                   INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

       BEFORE ROW
          LET l_ac = ARR_CURR()
       ON CHANGE cho
          EXECUTE i710_upd_tmp USING l_bmz1[l_ac].cho,l_bmz1[l_ac].bmz02,l_bmz1[l_ac].bmz05,l_bmz1[l_ac].bmz011,l_bmz1[l_ac].bmz012,l_bmz1[l_ac].bmz013
          IF SQLCA.sqlerrd[3]=0 THEN
             CALL cl_err('upd i710_tmp_table','9050',1)
          END IF  
       ON ACTION ALL
          FOR l_i = 1 TO l_bmz1.getLength()
              LET l_bmz1[l_i].cho = 'Y'
              DISPLAY BY NAME l_bmz1[l_i].cho
              EXECUTE i710_upd_tmp USING l_bmz1[l_i].cho,l_bmz1[l_i].bmz02,l_bmz1[l_i].bmz05,l_bmz1[l_i].bmz011,l_bmz1[l_i].bmz012,l_bmz1[l_i].bmz013
              IF SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err('upd i710_tmp_table','9050',1)
              END IF
          END FOR
          #   DISPLAY ARRAY  l_bmz1 TO s_bmz1.* ATTRIBUTE( COUNT = g_rec_b)    #TQC-C60179 mark
              DISPLAY ARRAY  l_bmz1 TO s_bmz1.* ATTRIBUTE( COUNT = g_rec_b2)   #TQC-C60179
                 BEFORE DISPLAY
                 EXIT DISPLAY
              END DISPLAY
       ON ACTION no_all
          FOR l_i = 1 TO l_bmz1.getLength()
              LET l_bmz1[l_i].cho = 'N'
              DISPLAY BY NAME l_bmz1[l_i].cho
              EXECUTE i710_upd_tmp USING l_bmz1[l_i].cho,l_bmz1[l_i].bmz02,l_bmz1[l_i].bmz05,l_bmz1[l_i].bmz011,l_bmz1[l_i].bmz012,l_bmz1[l_i].bmz013
             
              IF SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err('upd i710_tmp_table','9050',1)
              END IF
          END FOR
          #   DISPLAY ARRAY  l_bmz1 TO s_bmz1.* ATTRIBUTE( COUNT = g_rec_b)    #TQC-C60179 mark
              DISPLAY ARRAY  l_bmz1 TO s_bmz1.* ATTRIBUTE( COUNT = g_rec_b2)   #TQC-C60179
                 BEFORE DISPLAY
                 EXIT DISPLAY
              END DISPLAY
       ON ACTION EXIT
          EXIT INPUT 
          
       ON ACTION controlg
          CALL cl_cmdask()
          CONTINUE INPUT

       ON ACTION CANCEL
          EXIT INPUT

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about
          CALL cl_about()

       ON ACTION ACCEPT
          CALL s_showmsg_init()
          FOREACH i710_tmp_cur1 INTO l_bmz.bmz01,l_bmz.bmz02,l_bmz.bmz03,l_bmz.bmz04,l_bmz.bmz05,l_bmz.bmzplant,l_bmz.bmzlegal,l_bmz.bmz011,l_bmz.bmz012,l_bmz.bmz013
             INSERT INTO bmz_file VALUES(l_bmz.*)
             IF SQLCA.sqlcode THEN 
                CALL s_errmsg('bmz02',l_bmz.bmz02,'inset bmz_file:',SQLCA.sqlcode,1)
             END IF 
          END FOREACH
          CALL s_showmsg() 
          EXIT INPUT 
          
    END INPUT 
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW i710_g_bmz1_w RETURN END IF
    
    CLOSE WINDOW i710_g_bmz1_w
END FUNCTION
#FUN-C30119---end
FUNCTION i710_d_fill(p_wc2)              #BODY FILL UP
#DEFINE p_wc2  LIKE type_file.chr1000     #No.FUN-680096 VARCHAR(200) #20180820
DEFINE p_wc2  STRING                      #No.FUN-680096 VARCHAR(200) #20180820
 
    LET g_sql =
       #"SELECT bmz02,ima02,ima021,bmz011,bmz012,bmz013,bmz04,bmz03,bmz05 FROM bmz_file,ima_file", #FUN-550014 add bmz05 #No.FUN-A60008 add bmz011,bmz012,bmz013  #MOD-G70147 mark
        "SELECT bmz012,bmz013,bmz02,ima02,ima021,",
        "       ta_ima06, ",                                      #20191005
        "       bmz011,bmz04,bmz03,bmz05 FROM bmz_file,ima_file", 
        " WHERE bmz01 ='",g_bmx.bmx01,"' AND ima01=bmz02 AND ",p_wc2 CLIPPED,
        " ORDER BY 1,6" #FUN-550014  add 6
 
    PREPARE i710_pd FROM g_sql
    DECLARE bmz_curs CURSOR FOR i710_pd
 
    CALL g_bmz.clear()
    LET g_cnt = 1
    LET g_rec_d = 1
 
    FOREACH bmz_curs INTO g_bmz[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
 
#MOD-B80208 --begin--
#        IF g_cnt > g_max_rec THEN
#           CALL cl_err( '', 9035, 0 )
#           EXIT FOREACH
#        END IF
#MOD-B80208 --end--
    END FOREACH
    CALL g_bmz.deleteElement(g_cnt)

    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      LET g_rec_d=g_cnt - 1
      DISPLAY g_rec_d TO FORMONLY.cn2
      LET g_cnt = 0
      DISPLAY ARRAY g_bmz TO s_bmz.* ATTRIBUTE(COUNT=g_rec_d)
         BEFORE DISPLAY
            EXIT DISPLAY
      END DISPLAY
    END IF
END FUNCTION
 
FUNCTION i710_out()
    DEFINE l_no	LIKE bmx_file.bmx01 #FUN-550014
    DEFINE l_d  LIKE type_file.chr1 #FUN-D90010
    IF cl_null(g_bmx.bmx01) THEN RETURN END IF
    LET l_no=g_bmx.bmx01
    #FUN-D90010--add--str--
    IF s_industry("slk") AND g_sma.sma150 = 'Y' THEN
       LET l_d='Y'    #打印款式明細
    ELSE
       LET l_d='N'
    END IF
    #FUN-D90010--add--end
 
    MENU ""
       ON ACTION list_doc

         LET g_msg = 'bmx01 = "',g_bmx.bmx01,'"'
         LET g_msg = "abmr710 '",g_today,"' '",g_user,"' '",g_lang,"' ",#FUN-C30085 mark  #FUN-E50024 remark GR改串CR   
        #LET g_msg = "abmg710 '",g_today,"' '",g_user,"' '",g_lang,"' ", #FUN-C30085 add  #FUN-E50024 mark GR改串CR   
                      " 'Y' ' ' '1' ", 
                 #   " '",g_msg CLIPPED,"' "   #No.MOD-950055 add CLIPPED  #FUN-D90010 mark
                     " '",g_msg CLIPPED, "' " #,  l_d CLIPPED,"' " #FUN-D90010 add  #FUN-E50052 MARK l_d
                    ,"'",g_bmx.bmx50,"' "      #TQC-AC0173 
                    ," ' ' ' ' ' ' ' ' '",l_d CLIPPED,"'" #FUN-E50052  add
          CALL cl_cmdrun(g_msg)
 
       ON ACTION list_of_effective_wo
 
         LET g_msg = 'bmx01 = "',g_bmx.bmx01,'"'        # MOD-640179
         LET g_msg = "abmr730 '",g_today,"' '",g_user,"' '",g_lang,"' ", 
                     " 'Y' ' ' '1' ", 
                     " '",g_msg CLIPPED,"' "   #No.MOD-950055 add CLIPPED 
          CALL cl_cmdrun(g_msg)
 
       ON ACTION cancel   #TQC-6C0056 add
          EXIT MENU       #TQC-6C0056 add
 
       ON ACTION exit
          EXIT MENU
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
          LET INT_FLAG=FALSE 		#MOD-570244	mars
          LET g_action_choice = "exit"
          EXIT MENU
 
    END MENU
 
 
END FUNCTION
 

FUNCTION i710_y_chk()
DEFINE l_cnt      LIKE type_file.num5      #No.FUN-680096 SMALLINT
DEFINE l_pml04    LIKE pml_file.pml04
DEFINE l_imaacti  LIKE ima_file.imaacti
DEFINE l_ima140   LIKE ima_file.ima140
 
   LET g_success = 'Y'
   IF s_shut(0) THEN RETURN END IF

   ##--- 20201023 add by momo - ECN 單據確 需依生效日依序執行(S) 
   #IF g_plant = 'KS' THEN
   #   LET l_cnt = 0
   #   SELECT COUNT(*) INTO l_cnt
   #     FROM bmx_file
   #    WHERE bmx07 < g_bmx.bmx07 AND bmx04='N'
   #   IF l_cnt > 0 THEN
   #      CALL cl_err('','cbm-009',1)
   #      LET g_success = 'N'
   #      RETURN
   #   END IF
   #END IF
   ##--- 20201023 add by momo - ECN 單據確 需依生效日依序執行(E)

   ##--- 20201223 add by momo (S)  生效日小於確認日時，將生效日改為確認日
   IF g_bmx.bmx07 < g_today THEN
      UPDATE bmx_file SET bmx07 = g_today WHERE bmx01 = g_bmx.bmx01
   END IF
   ##--- 20201223 add by momo (E)

#CHI-C30107 ----------- add --------------- begin
   IF g_bmx.bmx04='X'      THEN
      LET g_showmsg = g_bmx.bmx01
      CALL s_errmsg('bmx01','',g_showmsg,'9024',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_bmx.bmx04='Y'      THEN
      LET g_showmsg = g_bmx.bmx01
      CALL s_errmsg('bmx01','',g_showmsg,'9023',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_bmx.bmxacti= 'N' THEN
      LET g_showmsg = g_bmx.bmx01
      CALL s_errmsg('bmx01','',g_showmsg,'mfg0301',1)
       LET g_success = 'N'
   END IF
      IF g_action_choice CLIPPED = "confirm" OR    #按「確認」時
         g_action_choice CLIPPED = "insert"        #FUN-B80071
      THEN
         IF cl_null(g_argv3) THEN                  #CHI-CA0035 mod g_argv2->g_argv3
            IF NOT cl_confirm('axm-108') THEN 
               LET g_success = 'N' 
               RETURN 
            END IF
         END IF                      
      END IF
#CHI-C30107 ----------- add --------------- end
   SELECT bmx01 INTO g_bmx.bmx01 FROM bmx_file WHERE bmx01 = g_bmx.bmx01
   SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx.bmx01
   IF cl_null(g_bmx.bmx01) THEN CALL cl_err('',-400,0) RETURN END IF

   IF g_bmx.bmx04='X'      THEN 
      LET g_showmsg = g_bmx.bmx01                    
      CALL s_errmsg('bmx01','',g_showmsg,'9024',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_bmx.bmx04='Y'      THEN
      LET g_showmsg = g_bmx.bmx01                    
      CALL s_errmsg('bmx01','',g_showmsg,'9023',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_bmx.bmxacti= 'N' THEN
      LET g_showmsg = g_bmx.bmx01                    
      CALL s_errmsg('bmx01','',g_showmsg,'mfg0301',1)
       LET g_success = 'N'
   END IF
 
   CALL i710_y_chk_bmy()
   IF g_success = 'N' THEN
       RETURN
   END IF

   #MOD-E10080--begin
   #MOD-E30067--mark--begin
   #CALL i710_y_chk_bmy3()
   #IF g_success = 'N' THEN
   #    RETURN
   #END IF
   #MOD-E30067--mark--end
   #MOD-E10080--end
   #MOD-C20154 str add-----
   CALL i710_y_chk_bmy2()
   IF g_success = 'N' THEN
       RETURN
   END IF
   #MOD-C20154 end add-----
 
   LET l_cnt =0
   SELECT COUNT(*) INTO l_cnt FROM bmy_file
    WHERE bmy01=g_bmx.bmx01
   IF l_cnt=0 OR cl_null(l_cnt) THEN
     #若元件明細資料沒輸入，主件資料也沒輸入，顯示錯誤訊息，不可確認
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM bmz_file WHERE bmz01=g_bmx.bmx01
      IF l_cnt=0 THEN
         LET g_showmsg = g_bmx.bmx01                    
         CALL s_errmsg('bmx01','',g_showmsg,'mfg-008',1)
         LET g_success = 'N'
         RETURN
      END IF   #FUN-640273 add
   ELSE
     #若元件明細資料有輸入，但主件資料沒輸入，顯示錯誤訊息，不可確認
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM bmz_file WHERE bmz01=g_bmx.bmx01
      IF l_cnt=0 THEN
         LET g_showmsg = g_bmx.bmx01                    
         CALL s_errmsg('bmx01','',g_showmsg,'mfg-007',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF

 #MOD-E10174-Start-Mark  
 ##MOD-CB0147---add---S
 # LET l_cnt=0
 # SELECT COUNT(*) INTO l_cnt FROM bmy_file WHERE bmy01=g_bmx.bmx01
 # IF l_cnt=0 THEN
 #    CALL cl_err(g_bmx.bmx01,'mfg-009',1)
 #    LET g_success='N'
 #    RETURN
 # END IF  
 ##MOD-CB0147---add---E
 #MOD-E10174-End-Mark 

END FUNCTION
 
FUNCTION i710_y_upd()
DEFINE l_str            STRING                  #FUN-640241
DEFINE l_cnt      LIKE  type_file.num5#CHI-6A0007
DEFINE l_sql      STRING#CHI-6A0007
DEFINE l_gew03    LIKE gew_file.gew03   #FUN-950057                             
DEFINE l_i        LIKE type_file.num10  #FUN-950057 
 
   LET g_success = 'Y'
    IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'u') THEN                                                                           
       LET g_showmsg = g_bmx.bmx11                    
       CALL s_errmsg('bmx11',g_bmx.bmx11,g_showmsg,'aoo-045',1)
       RETURN                                                                                                                       
    END IF                                                                                                                          
   IF g_action_choice CLIPPED = "confirm" OR    #按「確認」時
      g_action_choice CLIPPED = "insert"        #FUN-B80071
   THEN
       IF g_bmx.bmxmksg='Y' THEN
             IF g_bmx.bmx09 != '1' THEN
                   LET g_showmsg = g_bmx.bmx09                    
                   CALL s_errmsg('bmx09',g_bmx.bmx09,g_showmsg,'aws-078',1)
                   LET g_success = 'N'
                   RETURN
             END IF
       END IF
       IF g_bmx.bmx04 = 'Y' THEN RETURN END IF
#CHI-C30107 ----------- mark --------------- begin
#      IF cl_null(g_argv2) THEN            #no.FUN-840033 add
#          IF NOT cl_confirm('axm-108') THEN RETURN END IF
#      END IF                                  #NO.FUN-840033 add
#CHI-C30107 ----------- mark --------------- end
   END IF
 
   BEGIN WORK
 
   OPEN i710_cl USING g_bmx.bmx01
   IF STATUS THEN
      display "status:",STATUS
      LET g_success = 'N'
      LET g_showmsg = g_bmx.bmx01,'OPEN i710_cl:'
      CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,STATUS,1)
      CLOSE i710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i710_cl INTO g_bmx.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      LET g_showmsg = g_bmx.bmx01,'FETCH:'
      CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,SQLCA.sqlcode,1)
      CLOSE i710_cl
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE bmx_file SET bmx04='Y',bmx09='1',
                       bmxmodu = g_user,#MOD-930124
                       bmxdate = g_today#MOD-930124
                   WHERE bmx01=g_bmx.bmx01
   DECLARE i710_y_c1 CURSOR FOR
    SELECT * FROM bmz_file WHERE bmz01=g_bmx.bmx01
 
   FOREACH i710_y_c1 INTO b_bmz.*
     IF STATUS THEN EXIT FOREACH END IF
 
     CALL cl_msg(b_bmz.bmz02)                              #FUN-640241
 
     IF cl_null(b_bmz.bmz02) THEN CONTINUE FOREACH END IF
    IF g_argv1='1' THEN  #No.FUN-A60008   #CHI-CA0035 mod g_argv3->g_argv1
       UPDATE bma_file SET bmamodu= g_user,  
                          bmadate= g_today
       WHERE bma01=b_bmz.bmz02
         AND bma06=b_bmz.bmz05 
    ELSE   
       UPDATE bra_file SET bramodu= g_user,  
                          bradate= g_today
       WHERE bra01=b_bmz.bmz02
         AND bra011= b_bmz.bmz011
         AND bra012= b_bmz.bmz012
         AND bra013= b_bmz.bmz013
         AND bra06=b_bmz.bmz05     	   
    END IF 
    #No.FUN-A60008--end  
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","bma_file",b_bmz.bmz02,"","aap-161","","upd bma:",1) 
       LET g_success='N'
       EXIT FOREACH
    END IF
     LET g_last_seq=NULL
     DECLARE i710_y_c2 CURSOR FOR
      SELECT * FROM bmy_file WHERE bmy01=g_bmx.bmx01
     FOREACH i710_y_c2 INTO b_bmy.*
        IF SQLCA.sqlcode THEN
           LET g_showmsg = g_bmx.bmx01,'i710_y_c2 foreach:'
           CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #No.FUN-AB0058  --Begin
        IF NOT cl_null(b_bmy.bmy25) THEN
           IF NOT s_chk_ware(b_bmy.bmy25) THEN  #检查仓库是否属于当前门店
              LET g_success='N'
              ROLLBACK WORK
              RETURN
           END IF
        END IF
        #No.FUN-AB0058  --End
        IF b_bmy.bmy03 ='4' AND cl_null(b_bmy.bmy27) THEN
           LET g_showmsg = b_bmy.bmy27,'bmy27 is null'
           CALL s_errmsg('bmy27',b_bmy.bmy27,g_showmsg,'100',1)
           LET g_success='N'
           ROLLBACK WORK     #No.TQC-740043 add
           RETURN
        END IF
        IF cl_null(b_bmy.bmy05) THEN CONTINUE FOREACH END IF
 
        LET l_str = b_bmy.bmy02,' ',b_bmy.bmy05
        CALL cl_msg(l_str)                              
 
       IF NOT cl_null(b_bmy.bmy04) THEN           #No.MOD-930230 add
          LET l_cnt = 0
          IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
             SELECT COUNT(*) INTO l_cnt  FROM bmb_file
              WHERE bmb01 = b_bmz.bmz02  AND bmb03 = b_bmy.bmy05
                AND bmb02 = b_bmy.bmy04                    #MOD-910108 add
                AND (bmb05 IS NULL OR bmb05 > g_bmx.bmx07)
          ELSE 
             SELECT COUNT(*) INTO l_cnt  FROM brb_file
              WHERE brb01 = b_bmz.bmz02  AND brb03 = b_bmy.bmy05
                AND brb011= b_bmz.bmz011
                AND brb012= b_bmz.bmz012
                AND brb013= b_bmz.bmz013
                AND brb02 = b_bmy.bmy04                
                AND (brb05 IS NULL OR brb05 > g_bmx.bmx07)          	 
          END IF 
       ELSE 
       	  IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
             SELECT COUNT(*) INTO l_cnt  FROM bmb_file
              WHERE bmb01 = b_bmz.bmz02  AND bmb03 = b_bmy.bmy05
                AND (bmb05 IS NULL OR bmb05 > g_bmx.bmx07)
          ELSE 
             SELECT COUNT(*) INTO l_cnt  FROM brb_file
              WHERE brb01 = b_bmz.bmz02  AND brb03 = b_bmy.bmy05
                AND brb011= b_bmz.bmz011
                AND brb012= b_bmz.bmz012
                AND brb013= b_bmz.bmz013               
                AND (brb05 IS NULL OR brb05 > g_bmx.bmx07)            	 
          END IF 
       END IF
        IF l_cnt > 1 THEN
            CALL cl_getmsg('abm-023',g_lang) RETURNING g_msg
            IF g_argv3 = 'abmp701' THEN  #CHI-CA0035 mod g_argv2->g_argv3
                LET g_msg=g_bmx.bmx01 CLIPPED,' : ',g_msg CLIPPED
            ELSE
                LET g_msg=g_msg CLIPPED
            END IF
            LET INT_FLAG = 0 

        END IF

      ##----- 20180516 add by momo (S) 元件群組替代先修改
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM boa_file
       WHERE boa01= b_bmz.bmz02 AND boa03=b_bmy.bmy05
         AND (boa07 IS NULL OR boa07 > g_today)
      IF l_cnt > 0 THEN
         CALL cl_err(b_bmy.bmy05,'cbm-003',1) 
         LET g_success='N'
         ROLLBACK WORK
         RETURN 
      END IF
      ##----- 20180516 add by momo (E)
 
       #此料件存在大於此生效日的其他設變資料,不可輸入
       #檢查單身所輸入的設變料件是否己有存在ECN的單據且
       #單據已確認,但生效日尚未到者,則不可再key單
       LET l_cnt = 0
       
       IF NOT cl_null(b_bmy.bmy04) THEN         #No.MOD-930230 add
          IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
             SELECT COUNT(*) INTO l_cnt FROM bmb_file
              WHERE bmb01 = b_bmz.bmz02
                AND bmb03 = b_bmy.bmy05
                AND bmb02 = b_bmy.bmy04
                AND (bmb04 > g_bmx.bmx07 AND bmb04 IS NOT NULL)
                AND bmb05 IS NULL
          ELSE    
             SELECT COUNT(*) INTO l_cnt FROM brb_file
              WHERE brb01 = b_bmz.bmz02
                AND brb011= b_bmz.bmz011
                AND brb012= b_bmz.bmz012
                AND brb013= b_bmz.bmz013
                AND brb03 = b_bmy.bmy05
                AND brb02 = b_bmy.bmy04
                AND (brb04 > g_bmx.bmx07 AND brb04 IS NOT NULL)
                AND brb05 IS NULL          	
          END IF 
       ELSE 
       	  IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
             SELECT COUNT(*) INTO l_cnt FROM bmb_file
              WHERE bmb01 = b_bmz.bmz02
                AND bmb03 = b_bmy.bmy05
                AND (bmb04 > g_bmx.bmx07 AND bmb04 IS NOT NULL)
                AND bmb05 IS NULL
          ELSE    
             SELECT COUNT(*) INTO l_cnt FROM brb_file
              WHERE brb01 = b_bmz.bmz02
                AND brb011= b_bmz.bmz011
                AND brb012= b_bmz.bmz012
                AND brb013= b_bmz.bmz013
                AND brb03 = b_bmy.bmy05
                AND (brb04 > g_bmx.bmx07 AND brb04 IS NOT NULL)
                AND brb05 IS NULL          	
          END IF              
       END IF
 
       IF l_cnt > 0 THEN
          LET g_showmsg = b_bmz.bmz02 CLIPPED,'/',b_bmy.bmy05
          CALL cl_err(g_showmsg,'abm-729','1')
          LET g_success='N'
          ROLLBACK WORK     
          RETURN
       END IF
       CALL i710_s()               #No.FUN-A60008  
      #MOD-BA0200---add---start---
       IF g_success = 'N' THEN
          RETURN
       END IF
      #MOD-BA0200---add---end---
#        IF b_bmy.bmy03 MATCHES '[1345]' THEN   #CHI-960004
#           IF NOT cl_null(b_bmy.bmy04) AND b_bmy.bmy04 > 0 THEN
#
#              LET l_sql="SELECT bmb_file.*  FROM bmb_file ",
#                        " WHERE bmb01 ='", b_bmz.bmz02 CLIPPED, "'",
#                        "   AND bmb02 =",  b_bmy.bmy04,
#                        "   AND bmb03 ='", b_bmy.bmy05 CLIPPED, "'",
#                        "   AND ( bmb05 >'", g_bmx.bmx07, "' OR bmb05 IS NULL )"
#
#              IF b_bmz.bmz05 IS NOT NULL THEN 
#                 LET l_sql=l_sql CLIPPED," AND bmb29 ='", b_bmz.bmz05 ,"'"   #No:MOD-9A0182 modify
#              END IF
#           ELSE    
#                LET l_sql ="SELECT bmb_file.* FROM bmb_file ",
#                           " WHERE bmb01 ='", b_bmz.bmz02 CLIPPED, "'",
#                           "   AND bmb03 ='", b_bmy.bmy05 CLIPPED, "'",
#                           "   AND ( bmb05 >'", g_bmx.bmx07, "' OR bmb05 IS NULL )"
#
#               IF b_bmz.bmz05 IS NOT NULL THEN 
#                  LET l_sql=l_sql CLIPPED," AND bmb29 ='", b_bmz.bmz05 ,"'"   #No:MOD-9A0182 modify
#               END IF
#           END IF
#          
#
#           PREPARE i710_bmb_pre FROM l_sql
#           DECLARE i710_bmb_c2 CURSOR FOR i710_bmb_pre
#           FOREACH i710_bmb_c2 INTO g_bmb.*
#             IF STATUS THEN        # 當bmy04 is null時,可能讀出一筆以上
#                LET g_showmsg = g_bmx.bmx01,'sel bmb:'
#                CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,STATUS,1)
#                LET g_success='N' 
#                ROLLBACK WORK     #No.TQC-740043 add
#                RETURN
#             END IF
#             LET g_last_seq=g_bmb.bmb02
# 
#             CASE
#                WHEN b_bmy.bmy03='1' CALL i710_s1()        # 失效
#                WHEN b_bmy.bmy03='3' CALL i710_s3()        # 修改
#                WHEN b_bmy.bmy03='4' CALL i710_s4()        # 取代
#                WHEN b_bmy.bmy03='5' CALL i710_s4()        # 替代 #CHI-960004
#             END CASE
#             IF g_success='N' THEN 
#                ROLLBACK WORK     #No.TQC-740043 add
#                RETURN 
#             END IF
#           END FOREACH
#        ELSE
#           CALL i710_s2()        # 新增
#           IF g_success='N' THEN 
#              ROLLBACK WORK     #No.TQC-740043 add
#              RETURN 
#           END IF
#        END IF
     END FOREACH
     UPDATE ima_file SET ima05 = b_bmz.bmz03,
                         imamodu = g_user,
                         imadate = g_today
      WHERE ima01=b_bmz.bmz02 #版本
   END FOREACH
 
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
         COMMIT WORK
         CALL cl_flow_notify(g_bmx.bmx01,'Y')
         LET g_showmsg = g_bmx.bmx01                    
         CALL s_errmsg('bmx01','',g_showmsg,'abm-983',0)
         DISPLAY BY NAME g_bmx.bmx09
         DISPLAY BY NAME g_bmx.bmx04
      ELSE
         LET g_bmx.bmx04='N'
         LET g_success = 'N'
         LET g_showmsg = g_bmx.bmx01                    
         CALL s_errmsg('bmx01','',g_showmsg,'abm-984',0)
         ROLLBACK WORK
      END IF
   ELSE
      LET g_bmx.bmx04='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_bmx.* FROM bmx_file WHERE bmx01 = g_bmx.bmx01
   IF g_bmx.bmx04='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_bmx.bmx09='1' OR
      g_bmx.bmx09='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   IF g_bmx.bmx09='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
   IF g_argv3 <> 'abmp701' THEN   #NO.FUN-840033  #CHI-CA0035 mod g_argv2->g_argv3
       CALL cl_set_field_pic(g_bmx.bmx04,g_chr2,"",g_chr3,g_chr,g_bmx.bmxacti)
   END IF                         #NO.FUN-840033 
   #FUN-950057 ---------------------add start----------------------------------
   SELECT gev04 INTO g_gev04 FROM gev_file                                      
    WHERE gev01 = '3' AND gev02 = g_plant                                       
      AND gev03 = 'Y'
   IF NOT cl_null(g_gev04) THEN                                                 
       SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file                           
        WHERE gew01 = g_gev04 AND gew02 = '3'                                   
       IF l_gew03 = '1' THEN #自动抛转
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
#FUN-950057 -----------------------add end--------------------------
END FUNCTION
#No.FUN-A60008--begin 
FUNCTION i710_s()
DEFINE   l_sql      STRING 
DEFINE   l_bmd07    LIKE bmd_file.bmd07  #CHI-C20060
DEFINE   l_azw06    LIKE azw_file.azw06  #20230901 多營運中心更新使用

   IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
      IF b_bmy.bmy03 MATCHES '[1345]' THEN   
         IF NOT cl_null(b_bmy.bmy04) AND b_bmy.bmy04 > 0 THEN

            LET l_sql="SELECT bmb_file.*  FROM bmb_file ",
                      " WHERE bmb01 ='", b_bmz.bmz02 CLIPPED, "'",
                      "   AND bmb02 ='",  b_bmy.bmy04 CLIPPED, "'",
                      "   AND bmb03 ='", b_bmy.bmy05 CLIPPED, "'",
                      "   AND bmb04 <='", g_bmx.bmx07,  "'",            #MOD-D90002 add
                      "   AND ( bmb05 >'", g_bmx.bmx07, "' OR bmb05 IS NULL )"

            IF b_bmz.bmz05 IS NOT NULL THEN 
               LET l_sql=l_sql CLIPPED," AND bmb29 ='", b_bmz.bmz05 ,"'"   
            END IF
         ELSE    
              LET l_sql ="SELECT bmb_file.* FROM bmb_file ",
                         " WHERE bmb01 ='", b_bmz.bmz02 CLIPPED, "'",
                         "   AND bmb03 ='", b_bmy.bmy05 CLIPPED, "'",
                         "   AND bmb04 <='", g_bmx.bmx07,  "'",          #MOD-D90002 add
                         "   AND ( bmb05 >'", g_bmx.bmx07, "' OR bmb05 IS NULL )"

             IF b_bmz.bmz05 IS NOT NULL THEN 
                LET l_sql=l_sql CLIPPED," AND bmb29 ='", b_bmz.bmz05 ,"'"   
             END IF
         END IF
        
         PREPARE i710_bmb_pre FROM l_sql
         DECLARE i710_bmb_c2 CURSOR FOR i710_bmb_pre
         FOREACH i710_bmb_c2 INTO g_bmb.*
           IF STATUS THEN        # 當bmy04 is null時,可能讀出一筆以上
              LET g_showmsg = g_bmx.bmx01,'sel bmb:'
              CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,STATUS,1)
              LET g_success='N' 
              ROLLBACK WORK     
              RETURN
           END IF
           LET g_last_seq=g_bmb.bmb02
           CASE
              WHEN b_bmy.bmy03='1' CALL i710_s1()        # 失效
              WHEN b_bmy.bmy03='3' CALL i710_s3()        # 修改
              WHEN b_bmy.bmy03='4' CALL i710_s4()        # 取代
              WHEN b_bmy.bmy03='5' CALL i710_s4()        # 替代 
           END CASE
           IF g_success='N' THEN 
              ROLLBACK WORK     
              RETURN 
           END IF
         END FOREACH
      #ELSE                      #CHI-C20060
      END IF                     #CHI-C20060
      IF b_bmy.bmy03 = '2' THEN  #CHI-C20060
         CALL i710_s2()        # 新增
         IF g_success='N' THEN 
            ROLLBACK WORK    
            RETURN 
         END IF
      END IF 

      ##------ 20201208 add by momo (S)
        IF b_bmy.bmy03 MATCHES '[14]' AND b_bmy.bmy38='Y' THEN
           ##---- 20230901 add by momo (S)多營運中心同步停產
           DECLARE i710sub_multupd_ima140 CURSOR FOR
             SELECT azw06 FROM gew_file,azw_file WHERE gew04=azw01 AND gew01 = g_plant AND gew02='2'
             FOREACH i710sub_multupd_ima140 INTO l_azw06
               IF NOT cl_null(l_azw06) THEN
                  CALL s_dbstring(l_azw06) RETURNING l_azw06
                  LET g_sql = "UPDATE ",l_azw06 CLIPPED,"ima_file",
                              "  SET ima140 = '",b_bmy.bmy38,"', ima1401 = '",g_bmx.bmx07,"' ",
                              " WHERE ima01 = '",b_bmy.bmy05,"'"
                  PREPARE i710sub_mulupd_ima140 FROM g_sql
                  EXECUTE i710sub_mulupd_ima140
               END IF
             END FOREACH
           ##---- 20230901 add by momo (E)多營運中心同步停產
           UPDATE ima_file
              SET ima140 = b_bmy.bmy38, ima1401 = g_bmx.bmx07
            WHERE ima01 =  b_bmy.bmy05
           IF SQLCA.SQLERRD[3]=0 THEN
              LET g_showmsg = g_bmx.bmx01,'upd ima:'
              CALL s_errmsg('ima140',b_bmy.bmy05,g_showmsg,'aap-161',1)
          #    LET g_success='N'
           END IF
        END IF
      ##------ 20201208 add by momo (E)
 
      #CHI-C20060---begin
      IF b_bmy.bmy03 = '6' THEN
         LET l_bmd07 = b_bmy.bmy06/b_bmy.bmy07
         UPDATE bmd_file 
            SET bmd07 = l_bmd07,
                bmd06 = b_bmy.bmy36             #CHI-DC0015 add
          WHERE bmd08 = b_bmz.bmz02
            AND bmd01 = b_bmy.bmy05
            AND bmd04 = b_bmy.bmy27
           #AND bmd02 = '2'                   #MOD-EA0134 mark
            AND (bmd02 = '1' OR bmd02 = '2')  #MOD-EA0134 add
        #FUN-F50035 add str-----
         IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN #與APS整合
            CALL i710_upd_vmo()
            CALL i710_upd_vmq()
         END IF
        #FUN-F50035 add end-----
      END IF 
      #CHI-C20060---end 
   ELSE 
      IF b_bmy.bmy03 MATCHES '[1345]' THEN   
         IF NOT cl_null(b_bmy.bmy04) AND b_bmy.bmy04 > 0 THEN
            LET l_sql="SELECT brb_file.*  FROM brb_file ",
                      " WHERE brb01 ='", b_bmz.bmz02 CLIPPED, "'",
                      "   AND brb011='", b_bmz.bmz011 , "'",
                      "   AND brb012='", b_bmz.bmz012 , "'",
                      "   AND brb013='", b_bmz.bmz013 , "'",
                      "   AND brb02 ='",  b_bmy.bmy04 CLIPPED, "'",
                      "   AND brb03 ='", b_bmy.bmy05 CLIPPED, "'",
                      "   AND ( brb05 >'", g_bmx.bmx07, "' OR brb05 IS NULL )"
            IF b_bmz.bmz05 IS NOT NULL THEN 
               LET l_sql=l_sql CLIPPED," AND brb29 ='", b_bmz.bmz05 ,"'"   
            END IF
         ELSE    
            LET l_sql ="SELECT brb_file.* FROM brb_file ",
                       " WHERE brb01 ='", b_bmz.bmz02 CLIPPED, "'",
                       "   AND brb011='", b_bmz.bmz011 , "'",
                       "   AND brb012='", b_bmz.bmz012 , "'",
                       "   AND brb013='", b_bmz.bmz013 , "'",                         
                       "   AND brb03 ='", b_bmy.bmy05 CLIPPED, "'",
                       "   AND ( brb05 >'", g_bmx.bmx07, "' OR brb05 IS NULL )"

            IF b_bmz.bmz05 IS NOT NULL THEN 
               LET l_sql=l_sql CLIPPED," AND brb29 ='", b_bmz.bmz05 ,"'"   
            END IF
         END IF
        
         PREPARE i710_brb_pre FROM l_sql
         DECLARE i710_brb_c2 CURSOR FOR i710_brb_pre
         FOREACH i710_brb_c2 INTO g_brb.*
           IF STATUS THEN        # 當bmy04 is null時,可能讀出一筆以上
              LET g_showmsg = g_bmx.bmx01,'sel brb:'
              CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,STATUS,1)
              LET g_success='N' 
              ROLLBACK WORK     
              RETURN
           END IF
           LET g_last_seq=g_brb.brb02
           CASE
              WHEN b_bmy.bmy03='1' CALL i710_s1()        # 失效
              WHEN b_bmy.bmy03='3' CALL i710_s3()        # 修改
           END CASE
           IF g_success='N' THEN 
              ROLLBACK WORK     
              RETURN 
           END IF
         END FOREACH
      #ELSE                      #CHI-C20060
      END IF                     #CHI-C20060
      IF b_bmy.bmy03 = '2' THEN  #CHI-C20060
         CALL i710_s2()        # 新增
         IF g_success='N' THEN 
            ROLLBACK WORK    
            RETURN 
         END IF
      END IF 
      #CHI-C20060---begin
      IF b_bmy.bmy03 = '6' THEN
         LET l_bmd07 = b_bmy.bmy06/b_bmy.bmy07
         UPDATE bmd_file 
            SET bmd07 = l_bmd07,
                bmd06 = b_bmy.bmy36             #CHI-DC0015 add
          WHERE bmd08 = b_bmz.bmz02
            AND bmd01 = b_bmy.bmy05
            AND bmd04 = b_bmy.bmy27
           #AND bmd02 = '2'                  #MOD-EA0134 mark
            AND (bmd02 = '1' OR bme02 = '2') #MOD-EA0134 add
      END IF 
      #CHI-C20060---end  
   END IF 
END FUNCTION 
#No.FUN-A60008--end  
FUNCTION i710_s1()
DEFINE   l_cnt     LIKE type_file.num5   #No:CHI-980001 add
DEFINE   l_bmb06   LIKE bmb_file.bmb06



   SELECT bra014 INTO g_bra014 FROM bra_file 
    WHERE bra01 =b_bmz.bmz02 
     AND bra011=b_bmz.bmz011
     AND bra012=b_bmz.bmz012
     AND bra013=b_bmz.bmz013

   #IF g_argv3='1' OR (g_argv3='2' AND g_bra014='Y') THEN 
   IF g_argv1='1' THEN    #CHI-CA0035 mod g_argv3->g_argv1 
      UPDATE bmb_file SET bmb05  = g_bmx.bmx07,
                          bmb24  = g_bmx.bmx01,
                          bmbmodu= g_user,
                          bmbdate= g_today
       WHERE bmb01 = g_bmb.bmb01 AND bmb02=g_bmb.bmb02 AND bmb03=g_bmb.bmb03 AND bmb04=g_bmb.bmb04 AND bmb29=g_bmb.bmb29
      
      IF SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = g_bmx.bmx01,'upd bmb:'
         CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,'aap-161',1)
         LET g_success='N'
      END IF
      
      IF SQLCA.sqlcode THEN
         LET g_showmsg = g_bmx.bmx01,'upd bmb:'
         CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,STATUS,1)
         LET g_success='N'
      END IF


     #FUN-F50035 add str---
      IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN
         CALL i710_del_vmo()
      END IF
     #FUN-F50035 add end---
   END IF 
   #CHI-D40002---begin
   IF s_industry('icd')  THEN
      UPDATE icm_file
         SET icmacti = 'N'
       WHERE icm01 = g_bmb.bmb03
         AND icm02 = g_bmb.bmb01
   END IF 
   #CHI-D40002---end
   IF g_argv1='2' THEN  #CHI-CA0035 mod g_argv3->g_argv1
      UPDATE brb_file SET brb05  = g_bmx.bmx07,
                          brb24  = g_bmx.bmx01,
                          brbmodu= g_user,
                          brbdate= g_today
       WHERE brb01 = g_brb.brb01 AND brb011=g_brb.brb011 AND brb012=g_brb.brb012 
         AND brb013=g_brb.brb013 AND brb02=g_brb.brb02 AND brb03=g_brb.brb03 
         AND brb04=g_brb.brb04 AND brb29=g_brb.brb29
      
      IF SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = g_bmx.bmx01,'upd brb:'
         CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,'aap-161',1)
         LET g_success='N'
      END IF
      
      IF SQLCA.sqlcode THEN
         LET g_showmsg = g_bmx.bmx01,'upd brb:'
         CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,STATUS,1)
         LET g_success='N'
      END IF   	  
      IF g_bra014='Y' THEN 
         SELECT ecb06 INTO g_ecb06 FROM ecb_file 
         WHERE ecb01=g_brb.brb01 AND ecb02=g_brb.brb011
          AND ecb012=g_brb.brb012 AND ecb03=g_brb.brb013        
         SELECT bmb06 INTO l_bmb06 FROM bmb_file 
          WHERE bmb01=g_brb.brb01 AND bmb03=g_brb.brb03
            AND bmb29=g_brb.brb29 AND bmb09=g_ecb06
         IF l_bmb06 >g_brb.brb06 THEN 
           UPDATE bmb_file SET bmb06  = l_bmb06-g_brb.brb06,
                               bmb24  = g_bmx.bmx01,
                               bmbmodu= g_user,
                               bmbdate= g_today
            WHERE bmb01 = g_brb.brb01 AND bmb09=g_brb.brb09 AND bmb03=g_brb.brb03 
              AND bmb29=g_brb.brb29           
         ELSE  
           UPDATE bmb_file SET bmb05  = g_bmx.bmx07,
                               bmb24  = g_bmx.bmx01,
                               bmbmodu= g_user,
                               bmbdate= g_today
            WHERE bmb01 = g_brb.brb01 AND bmb09=g_brb.brb09 AND bmb03=g_brb.brb03 
              AND bmb29=g_brb.brb29
#              AND bmb04=g_brb.brb04 
         END IF 
       END IF 
             
   END IF 
   #-----------------No:CHI-980001 add
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM bmd_file 
           WHERE bmd08 = g_bmb.bmb01
             AND bmd01 = g_bmb.bmb03
             AND (bmd06 > g_bmx.bmx07 OR bmd06 IS NULL)
   IF l_cnt > 0 THEN 
      UPDATE bmd_file SET bmd06=g_bmx.bmx07,
                          bmdmodu=g_user,
                          bmddate=g_today
       WHERE bmd08 = g_bmb.bmb01 
         AND bmd01 = g_bmb.bmb03
         AND (bmd06 > g_bmx.bmx07 OR bmd06 IS NULL)

      IF SQLCA.sqlcode THEN
         LET g_showmsg = g_bmx.bmx01,' update bmd_file:'                    
         CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,SQLCA.SQLCODE,1)
         LET g_success='N'
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = g_bmx.bmx01,' update bmd_file:'                    
         CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,'aap-161',1)
         LET g_success='N'
      END IF
   END IF
  #-----------------No:CHI-980001 end
   LET g_bmy05_t=b_bmy.bmy05
 
END FUNCTION
 
FUNCTION i710_s2()
   DEFINE l_bmt		RECORD LIKE bmt_file.*
   DEFINE l_bmc		RECORD LIKE bmc_file.*
   DEFINE l_ecb06       LIKE ecb_file.ecb06
   DEFINE l_brb06       LIKE brb_file.brb06 
   DEFINE l_cnt         LIKE type_file.num5     #CHI-D40002
   DEFINE l_icm         RECORD LIKE icm_file.*  #CHI-D40002
   #FUN-D80022--add--str--
   DEFINE l_bmz05       LIKE bmz_file.bmz05 
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
   #FUN-D80022--add--end--
   
   #No.FUN-A60008--begin
   SELECT bra014 INTO g_bra014 FROM bra_file 
    WHERE bra01 =b_bmz.bmz02 AND bra011=b_bmz.bmz011
     AND bra012=b_bmz.bmz012 AND bra013=b_bmz.bmz013 
    #No.FUN-A60008--end  
   INITIALIZE g_bmb.* TO NULL
   LET g_bmb.bmb01 =b_bmz.bmz02
   LET g_bmb.bmb29 =b_bmz.bmz05  #FUN-550014 add
   LET g_bmb.bmb30 =b_bmy.bmy30 #FUN-550014 add
   IF cl_null(b_bmy.bmy04) THEN   #No.MOD-840645 add
      SELECT MAX(bmb02) INTO g_bmb.bmb02 FROM bmb_file WHERE bmb01=g_bmb.bmb01
                                                         AND bmb29=g_bmb.bmb29 #FUN-550014 add      
      IF cl_null(g_bmb.bmb02) THEN
         LET g_bmb.bmb02 = 0
      END IF
      LET g_bmb.bmb02=g_bmb.bmb02+g_sma.sma19
   ELSE
      LET g_bmb.bmb02 = b_bmy.bmy04
   END IF             #No.MOD-840645 add
 
   LET g_bmb.bmb03 =b_bmy.bmy05
   LET g_bmb.bmb04 =g_bmx.bmx07
   LET g_bmb.bmb34 =b_bmy.bmy38   #FUN-D80022 add
   LET g_bmb.bmb06 =b_bmy.bmy06
   LET g_bmb.bmb07 =b_bmy.bmy07
   LET g_bmb.bmb09 =b_bmy.bmy09   #20221123
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
   LET g_bmb.bmb09 =b_bmy.bmy09
   LET g_bmb.bmb10 =b_bmy.bmy10
   LET g_bmb.bmb10_fac =b_bmy.bmy10_fac
   LET g_bmb.bmb31 =b_bmy.bmy34   #no.MOD-840426
 
   SELECT ima105 INTO g_bmb.bmb27 FROM ima_file    #No.MOD-940061 add
    WHERE ima01=g_bmb.bmb03
 
   LET g_bmb.bmb10_fac2=b_bmy.bmy10_fac2
  #LET g_bmb.bmb14 =0 #CHI-A60028 mark
   LET g_bmb.bmb14 =b_bmy.bmy35 #CHI-A60028 add
   LET g_bmb.bmb15 =b_bmy.bmy21   #bugno:6845 add
   LET g_bmb.bmb17 ='N'
   LET g_bmb.bmb19 ='1'
   IF NOT cl_null(b_bmy.bmy20) THEN LET g_bmb.bmb19 =b_bmy.bmy20 END IF  # No.MOD-710092 modify
 
   LET g_bmb.bmb23 =0
   LET g_bmb.bmb28 =b_bmy.bmy23   #bugno:6845 add
 
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
   LET g_bmb.bmb33 = 0                  #NO.FUN-840033
   LET g_bmb.bmb31 = b_bmy.bmy34        #no.MOD-840478
   LET g_bmb.bmbdate = g_today  #MOD-930124
   #IF g_argv3='1' OR (g_argv3='2' AND g_bra014='Y') THEN     #No.FUN-A60008
   IF g_argv1='1' THEN  #CHI-CA0035 mod g_argv3->g_argv1
      LET g_bmb.bmb34 = b_bmy.bmy38                  #TQC-DA0015 add 
      IF cl_null(g_bmb.bmb34) THEN LET g_bmb.bmb34 = 0 END IF  #TQC-DA0015 add
      INSERT INTO bmb_file VALUES(g_bmb.*)
      
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = g_bmx.bmx01,'ins bmb:'
         CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,SQLCA.sqlcode,1)
         LET g_success='N'
      END IF
     #FUN-F50035 add str-----
      IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN #與APS整合
         CALL i710_ins_vmo()
      END IF
     #FUN-F50035 add end-----
      #FUN-D80022--add--str--
      #ADD ABOUT COLOR SIZE
      IF g_success = 'Y' AND s_industry('slk') AND g_sma.sma150 = 'Y' THEN
         SELECT bmz05 INTO l_bmz05 FROM bmz_file
          WHERE bmz01 = g_bmx.bmx01 AND bmz02 = g_bmb.bmb01
         IF g_bmb.bmb34 MATCHES '[23]' THEN 
            DECLARE i710_s2_bmya CURSOR FOR
             SELECT bmya04,bmya05 FROM bmya_file 
              WHERE bmya01 = g_bmx.bmx01 
                AND bmya02 = b_bmy.bmy02
            FOREACH i710_s2_bmya INTO l_bmya04,l_bmya05 
               IF NOT cl_null(l_bmya04) AND NOT cl_null(l_bmya05) THEN
                    LET l_bmba.bmba01 = g_bmb.bmb01
                    LET l_bmba.bmba02 = g_bmb.bmb02
                    LET l_bmba.bmba03 = g_bmb.bmb03
                    LET l_bmba.bmba04 = g_bmb.bmb04
                    LET l_bmba.bmba05 = l_bmya04 
                    LET l_bmba.bmba06 = l_bmya05
                    LET l_bmba.bmba29 = l_bmz05
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
            DECLARE i710_s2_bmyb CURSOR FOR
             SELECT bmyb04,bmyb05 FROM bmyb_file
              WHERE bmyb01 = g_bmx.bmx01
                AND bmyb02 = b_bmy.bmy02
            FOREACH i710_s2_bmyb INTO l_bmyb04,l_bmyb05
               IF NOT cl_null(l_bmyb04) AND NOT cl_null(l_bmyb05) THEN
                    LET l_bmbb.bmbb01 = g_bmb.bmb01
                    LET l_bmbb.bmbb02 = g_bmb.bmb02
                    LET l_bmbb.bmbb03 = g_bmb.bmb03
                    LET l_bmbb.bmbb04 = g_bmb.bmb04
                    LET l_bmbb.bmbb05 = l_bmyb04
                    LET l_bmbb.bmbb06 = l_bmyb05
                    LET l_bmbb.bmbb29 = l_bmz05 
                    INSERT INTO bmbb_file VALUES (l_bmbb.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                       LET g_showmsg = g_bmb.bmb01,'ins bmbb:'
                       CALL s_errmsg('bmbb01',g_bmb.bmb01,g_showmsg,SQLCA.sqlcode,1)
                       LET g_success = 'N'
                    END IF
               END IF 
            END FOREACH
         END IF
         IF g_bmb.bmb34  MATCHES '[56]' THEN
            DECLARE i710_s2_bmyc CURSOR FOR
             SELECT bmyc04 FROM bmyc_file
              WHERE bmyc01 = g_bmx.bmx01
                AND bmyc02 = b_bmy.bmy02
            FOREACH i710_s2_bmyc INTO l_bmyc04
               IF NOT cl_null(l_bmyc04) THEN
                    LET l_bmbc.bmbc01 = g_bmb.bmb01
                    LET l_bmbc.bmbc02 = g_bmb.bmb02
                    LET l_bmbc.bmbc03 = g_bmb.bmb03
                    LET l_bmbc.bmbc04 = g_bmb.bmb04
                    LET l_bmbc.bmbc05 = l_bmyc04
                    LET l_bmbc.bmbc29 = l_bmz05 
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
            DECLARE i710_s2_bmyd CURSOR FOR
             SELECT bmyd04 FROM bmyd_file
              WHERE bmyd01 = g_bmx.bmx01
                AND bmyd02 = b_bmy.bmy02
            FOREACH i710_s2_bmyd INTO l_bmyc04
               IF NOT cl_null(l_bmyc04) THEN
                    LET l_bmbd.bmbd01 = g_bmb.bmb01
                    LET l_bmbd.bmbd02 = g_bmb.bmb02
                    LET l_bmbd.bmbd03 = g_bmb.bmb03
                    LET l_bmbd.bmbd04 = g_bmb.bmb04
                    LET l_bmbd.bmbd05 = l_bmyc04
                    LET l_bmbd.bmbd29 = l_bmz05 
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
      #FUN-D80022--add--end--
   END IF   
#CHI-D40002---begin
   IF s_industry('icd')  THEN
      SELECT COUNT(*) INTO l_cnt FROM icm_file       
       WHERE icm01 = g_bmb.bmb03 AND icm02 = g_bmb.bmb01 
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
         INSERT INTO icm_file VALUES (l_icm.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","icm_file",g_bmb.bmb01,g_bmb.bmb03,SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
         END IF
      ELSE
         IF l_cnt = 1 THEN
            UPDATE icm_file
               SET icmacti = 'Y'
             WHERE icm01 = g_bmb.bmb03 AND icm02 = g_bmb.bmb01 
         END IF 
      END IF
   END IF
#CHI-D40002---end
   #No.FUN-A60008--begin
   IF g_argv1='2' THEN   #CHI-CA0035 mod g_argv3->g_argv1
      INITIALIZE g_brb.* TO NULL
      LET g_brb.brb01 =b_bmz.bmz02
      LET g_brb.brb29 =b_bmz.bmz05 
      LET g_brb.brb30 =b_bmy.bmy30 
      LET g_brb.brb011=b_bmz.bmz011
      LET g_brb.brb012=b_bmz.bmz012
      LET g_brb.brb013=b_bmz.bmz013
      SELECT ecb06 INTO g_ecb06 FROM ecb_file 
         WHERE ecb01=g_brb.brb01 AND ecb02=g_brb.brb011
          AND ecb012=g_brb.brb012 AND ecb03=g_brb.brb013      
      LET g_brb.brb09=g_ecb06    
      IF cl_null(b_bmy.bmy04) THEN  
         SELECT MAX(brb02) INTO g_brb.brb02 FROM brb_file 
         WHERE brb01=g_brb.brb01 AND brb29=g_brb.brb29 
           AND brb011= g_brb.brb011
           AND brb012= g_brb.brb012
           AND brb013= g_brb.brb013
         IF cl_null(g_brb.brb02) THEN
            LET g_brb.brb02 = 0
         END IF
         LET g_brb.brb02=g_brb.brb02+g_sma.sma19
      ELSE
         LET g_brb.brb02 = b_bmy.bmy04
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
      LET g_brb.brb081 = b_bmy.bmy081       #FUN-AC0075 
      LET g_brb.brb082 = b_bmy.bmy082       #FUN-AC0075 
      LET g_brb.brb11 =b_bmy.bmy11
      LET g_brb.brb10 =b_bmy.bmy10
      LET g_brb.brb10_fac =b_bmy.bmy10_fac
      LET g_brb.brb31 =b_bmy.bmy34 
      
      SELECT ima105 INTO g_brb.brb27 FROM ima_file   
       WHERE ima01=g_brb.brb03
      
      LET g_brb.brb10_fac2=b_bmy.bmy10_fac2
     #LET g_brb.brb14 =0 #CHI-A60028 mark
      LET g_brb.brb14 =b_bmy.bmy35 #CHI-A60028 add
      LET g_brb.brb15 =b_bmy.bmy21  
      LET g_brb.brb17 ='N'
      LET g_brb.brb19 ='1'
      IF NOT cl_null(b_bmy.bmy20) THEN LET g_brb.brb19 =b_bmy.bmy20 END IF  
      LET g_brb.brb23 =0
      LET g_brb.brb28 =b_bmy.bmy23  
      IF cl_null(g_brb.brb28) THEN
         LET g_brb.brb28 =0
      END IF
      IF cl_null(g_brb.brb08) THEN
         LET g_brb.brb08 = 0
      END IF
      LET g_brb.brb33 = 0                  
      LET g_brb.brb31 = b_bmy.bmy34 
      LET g_brb.brbdate = g_today  
      IF g_bra014='Y' THEN 
         INITIALIZE g_bmb.* TO NULL
         LET g_bmb.bmb01 =b_bmz.bmz02 LET g_bmb.bmb29 =b_bmz.bmz05 
         LET g_bmb.bmb30 =b_bmy.bmy30 LET g_bmb.bmb03 =b_bmy.bmy05
         LET g_bmb.bmb04 =g_bmx.bmx07 LET g_bmb.bmb06 =b_bmy.bmy06
         LET g_bmb.bmb07 =b_bmy.bmy07 LET g_bmb.bmb16 =b_bmy.bmy16
         LET g_bmb.bmb24 =g_bmx.bmx01 LET g_bmb.bmb25 =b_bmy.bmy25
         LET g_bmb.bmb26 =b_bmy.bmy26 LET g_bmb.bmb13 =b_bmy.bmy13
         LET g_bmb.bmb18 =b_bmy.bmy18 LET g_bmb.bmb08 =b_bmy.bmy08
         LET g_bmb.bmb081=b_bmy.bmy081 LET g_bmb.bmb082 =b_bmy.bmy082  #Add No:TQC-AC0300
         LET g_bmb.bmb11 =b_bmy.bmy11 LET g_bmb.bmb09 =g_brb.brb09
         LET g_bmb.bmb10 =b_bmy.bmy10 LET g_bmb.bmb10_fac =b_bmy.bmy10_fac
         LET g_bmb.bmb31 =b_bmy.bmy34 LET g_bmb.bmb27=g_brb.brb27 
         LET g_bmb.bmb10_fac2=b_bmy.bmy10_fac2
         LET g_bmb.bmb14 =b_bmy.bmy35 LET g_bmb.bmb15 =b_bmy.bmy21  
         LET g_bmb.bmb34 =b_bmy.bmy38 #FUN-D80022 add
         LET g_bmb.bmb17 ='N' 
         LET g_bmb.bmb19 ='1'
         SELECT MAX(bmb02) INTO g_bmb.bmb02 FROM bmb_file 
         WHERE bmb01=g_bmb.bmb01 AND bmb29=g_bmb.bmb29 
         IF cl_null(g_bmb.bmb02) THEN
            LET g_bmb.bmb02 = 0
         END IF
         LET g_bmb.bmb02=g_bmb.bmb02+g_sma.sma19                   
         IF NOT cl_null(b_bmy.bmy20) THEN LET g_bmb.bmb19 =b_bmy.bmy20 END IF  
         LET g_bmb.bmb23 =0
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
         SELECT ecb06 INTO l_ecb06 FROM ecb_file 
         WHERE ecb01=g_brb.brb01 AND ecb02=g_brb.brb011
          AND ecb012=g_brb.brb012 AND ecb03=g_brb.brb013  
         SELECT SUM(brb06) INTO l_brb06 FROM brb_file,bra_file  
          WHERE bra01=brb01 AND bra011=brb011 AND bra012=brb012 
            AND bra013=brb013 AND bra06=brb29 AND bra10='2' 
            AND brb01=g_brb.brb01 AND brb011=g_brb.brb011 
            AND brb09=l_ecb06 AND brb29=g_brb.brb29 AND brb03=g_brb.brb03
         IF cl_null(l_brb06) THEN 
            LET l_brb06=0
         END IF    
         LET g_bmb.bmb06=l_brb06+b_bmy.bmy06
         IF cl_null(g_bmb.bmb34) THEN LET g_bmb.bmb34 = 0 END IF  #TQC-DA0015 add
         INSERT INTO bmb_file VALUES(g_bmb.*)
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
      INSERT INTO brb_file VALUES(g_brb.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = g_bmx.bmx01,'ins brb:'
         CALL s_errmsg('brb01',g_brb.brb01,g_showmsg,SQLCA.sqlcode,1)
         LET g_success='N'
      END IF          
   END IF 
   #No.FUN-A60008--end 
   IF g_argv1='1' THEN           #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
      IF g_sma.sma845='Y' THEN   #低階碼可否部份重計
         LET g_success='Y'
         #CALL s_uima146(g_bmb.bmb03)  #CHI-D10044
         CALL s_uima146(g_bmb.bmb03,0)  #CHI-D10044
         CALL cl_msg("")                              #FUN-640241
      END IF
 
      DECLARE i710_s2_c2 CURSOR FOR
       SELECT * FROM bmw_file
        WHERE bmw01=g_bmx.bmx01 AND bmw02=b_bmy.bmy02
      FOREACH i710_s2_c2 INTO b_bmw.*
         LET l_bmt.bmt01=g_bmb.bmb01
         LET l_bmt.bmt02=g_bmb.bmb02
         LET l_bmt.bmt03=g_bmb.bmb03
         LET l_bmt.bmt04=g_bmb.bmb04
         LET l_bmt.bmt05=b_bmw.bmw03
         LET l_bmt.bmt06=b_bmw.bmw04
         LET l_bmt.bmt07=b_bmw.bmw05
         LET l_bmt.bmt08=g_bmb.bmb29 #FUN-550014 add
         IF cl_null(l_bmt.bmt02) THEN
            LET l_bmt.bmt02=0
         END IF
         INSERT INTO bmt_file VALUES(l_bmt.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg = g_bmx.bmx01,'ins bmb:'
            CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,SQLCA.sqlcode,1)
            LET g_success='N'
         END IF
      
      END FOREACH 
      CALL i710_up_bmb13() 
     #----- 說明檔(bmc_file)複製 add in 00/03/15 ------------
      SELECT COUNT(*) INTO g_cnt FROM bmf_file
       WHERE bmf01=g_bmx.bmx01 AND bmf02=b_bmy.bmy02
      IF g_cnt>0 THEN 	# 有輸入才更新
         DECLARE i710_s2_c3 CURSOR FOR
          SELECT * FROM bmf_file
           WHERE bmf01=g_bmx.bmx01 AND bmf02=b_bmy.bmy02
         FOREACH i710_s2_c3 INTO b_bmf.*
             LET l_bmc.bmc01=g_bmb.bmb01
             LET l_bmc.bmc02=g_bmb.bmb02
             LET l_bmc.bmc021=g_bmb.bmb03
             LET l_bmc.bmc03=g_bmb.bmb04
             LET l_bmc.bmc04=b_bmf.bmf03
             LET l_bmc.bmc05=b_bmf.bmf04
             LET l_bmc.bmc06=g_bmb.bmb29 #FUN-550014 add
             INSERT INTO bmc_file VALUES(l_bmc.*)
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                LET g_showmsg = l_bmc.bmc01,'ins bmc:'
                CALL s_errmsg('bmc01',l_bmc.bmc01,g_showmsg,SQLCA.sqlcode,1)
                LET g_success='N'
             END IF
         END FOREACH
      END IF
   END IF    #No.FUN-A60008
 
END FUNCTION
 
FUNCTION i710_s3()
   DEFINE l_bmt		RECORD LIKE bmt_file.*
   DEFINE l_bmc		RECORD LIKE bmc_file.*
   DEFINE l_cnt		LIKE type_file.num5 #FUN-850156
   DEFINE l_brb06 LIKE brb_file.brb06 
   #FUN-D80022--add--str--
   DEFINE l_bmz05       LIKE bmz_file.bmz05
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
   #FUN-D80022--add--end--

   #No.FUN-A60008--begin
   SELECT bra014 INTO g_bra014 FROM bra_file 
    WHERE bra01 =b_bmz.bmz02 AND bra011=b_bmz.bmz011
     AND bra012=b_bmz.bmz012 AND bra013=b_bmz.bmz013 
    #No.FUN-A60008--end   
#  LET g_bmb.bmb04 =g_bmx.bmx07  #No.TQC-A30040
   LET g_bmb.bmb05 =NULL
 
   IF NOT cl_null(b_bmy.bmy38) THEN LET g_bmb.bmb34 =b_bmy.bmy38 END IF  #FUN-D80022 add
   IF NOT cl_null(b_bmy.bmy06) THEN LET g_bmb.bmb06 =b_bmy.bmy06 END IF
   IF NOT cl_null(b_bmy.bmy07) THEN LET g_bmb.bmb07 =b_bmy.bmy07 END IF
   IF NOT cl_null(b_bmy.bmy16) THEN LET g_bmb.bmb16 =b_bmy.bmy16 END IF
   IF NOT cl_null(b_bmy.bmy35) THEN LET g_bmb.bmb14 =b_bmy.bmy35 END IF  #CHI-A60028 add
 
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
   IF NOT cl_null(b_bmy.bmy10_fac) THEN
      LET g_bmb.bmb10_fac =b_bmy.bmy10_fac
   END IF
   IF NOT cl_null(b_bmy.bmy10_fac2) THEN
      LET g_bmb.bmb10_fac2 =b_bmy.bmy10_fac2
   END IF
   IF NOT cl_null(b_bmy.bmy21) THEN LET g_bmb.bmb15 =b_bmy.bmy21 END IF #no6845
   IF NOT cl_null(b_bmy.bmy23) THEN LET g_bmb.bmb28 =b_bmy.bmy23 END IF #no6845
   IF cl_null(g_bmb.bmb28) THEN LET g_bmb.bmb28 =0 END IF
   IF NOT cl_null(b_bmy.bmy34) THEN LET g_bmb.bmb31 =b_bmy.bmy34 END IF   #NO.MOD-840426
   LET g_bmb.bmbmodu = g_user
   LET g_bmb.bmbdate = g_today
   LET l_bmb02_t = g_bmb.bmb02  #FUN-D80022
 
   # 將原資料設為無效，新增一筆修改後的資料
   IF g_argv1='1' THEN     #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
      UPDATE bmb_file SET bmb05=g_bmx.bmx07,
                          bmbmodu = g_user,  #MOD-930124
                          bmbdate = g_today  #MOD-930124
       WHERE bmb01 = g_bmb.bmb01 AND bmb02=g_bmb.bmb02 AND bmb03=g_bmb.bmb03 
       #AND bmb04=g_bmb.bmb04 
       AND bmb29=g_bmb.bmb29         #失效日 #No:7827
      IF SQLCA.SQLCODE OR STATUS THEN
         LET g_showmsg = g_bmx.bmx01,' upd bmb:'
         CALL s_errmsg('bmb01',g_bmx.bmx01,g_showmsg,SQLCA.sqlcode,1)
         LET g_success='N'
      END IF


     #FUN-F50035 add str---
      IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN
         CALL i710_del_vmo()
      END IF
     #FUN-F50035 add end---
   END IF 
   LET g_bmb.bmb04 =g_bmx.bmx07  #No.TQC-A30040
   LET g_bmb.bmb29 =b_bmz.bmz05  #FUN-550014 add
   LET g_bmb.bmb30 =b_bmy.bmy30 #FUN-550014 add
   SELECT MAX(bmb02) INTO g_bmb.bmb02 FROM bmb_file
    WHERE bmb01 = g_bmb.bmb01
      AND bmb29 = g_bmb.bmb29 #FUN-550014 add
 
   IF cl_null(g_bmb.bmb02) THEN LET g_bmb.bmb02 = 0 END IF
   LET g_bmb.bmb02 = g_bmb.bmb02 + g_sma.sma19
 
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
   LET g_bmb.bmb33 = 0                 #NO.FUN-840033
   IF NOT cl_null(b_bmy.bmy34) THEN LET g_bmb.bmb31 =b_bmy.bmy34 END IF   #FUN-840156
   IF g_argv1='1' THEN     #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
      IF cl_null(g_bmb.bmb34) THEN LET g_bmb.bmb34 = 0 END IF  #TQC-DA0015 add
      INSERT INTO bmb_file VALUES (g_bmb.*)
      IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
         LET g_showmsg = g_bmb.bmb01,' ins bmb:'
         CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,STATUS,1)
         LET g_success='N'
      END IF
     #FUN-F50035 add str-----
      IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN #與APS整合
         CALL i710_ins_vmo()
      END IF
     #FUN-F50035 add end-----

      #FUN-D80022--add--str--
      #ADD ABOUT COLOR SIZE
      IF g_success = 'Y' AND s_industry('slk') AND g_sma.sma150 = 'Y' AND NOT cl_null(b_bmy.bmy38) THEN
         SELECT bmz05 INTO l_bmz05 FROM bmz_file
          WHERE bmz01 = g_bmx.bmx01 AND bmz02 = g_bmb.bmb01
         DELETE FROM bmba_file WHERE bmba01 = g_bmb.bmb01
                                 AND bmba02 = l_bmb02_t
                                 AND bmba03 = g_bmb.bmb03
                                 AND bmba29 = l_bmz05 
         DELETE FROM bmbb_file WHERE bmbb01 = g_bmb.bmb03
                                 AND bmbb02 = l_bmb02_t
                                 AND bmbb03 = g_bmb.bmb03
                                 AND bmbb29 = l_bmz05 
         DELETE FROM bmbc_file WHERE bmbc01 = g_bmb.bmb03
                                 AND bmbc02 = l_bmb02_t 
                                 AND bmbc03 = g_bmb.bmb03
                                 AND bmbc29 = l_bmz05 
         DELETE FROM bmbd_file WHERE bmbd01 = g_bmb.bmb03
                                 AND bmbd02 = l_bmb02_t 
                                 AND bmbd03 = g_bmb.bmb03
                                 AND bmbd29 = l_bmz05 
         IF g_bmb.bmb34 MATCHES '[23]' THEN 
            DECLARE i710_s3_bmya CURSOR FOR
             SELECT bmya04,bmya05 FROM bmya_file 
              WHERE bmya01 = g_bmx.bmx01 
                AND bmya02 = b_bmy.bmy02
            FOREACH i710_s3_bmya INTO l_bmya04,l_bmya05 
               IF NOT cl_null(l_bmya04) AND NOT cl_null(l_bmya05) THEN
                    LET l_bmba.bmba01 = g_bmb.bmb01
                    LET l_bmba.bmba02 = g_bmb.bmb02
                    LET l_bmba.bmba03 = g_bmb.bmb03
                    LET l_bmba.bmba04 = g_bmb.bmb04
                    LET l_bmba.bmba05 = l_bmya04 
                    LET l_bmba.bmba06 = l_bmya05
                    LET l_bmba.bmba29 = l_bmz05
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
            DECLARE i710_s3_bmyb CURSOR FOR
             SELECT bmyb04,bmyb05 FROM bmyb_file
              WHERE bmyb01 = g_bmx.bmx01
                AND bmyb02 = b_bmy.bmy02
            FOREACH i710_s3_bmyb INTO l_bmyb04,l_bmyb05
               IF NOT cl_null(l_bmyb04) AND NOT cl_null(l_bmyb05) THEN
                    LET l_bmbb.bmbb01 = g_bmb.bmb01
                    LET l_bmbb.bmbb02 = g_bmb.bmb02
                    LET l_bmbb.bmbb03 = g_bmb.bmb03
                    LET l_bmbb.bmbb04 = g_bmb.bmb04
                    LET l_bmbb.bmbb05 = l_bmyb04
                    LET l_bmbb.bmbb06 = l_bmyb05
                    LET l_bmbb.bmbb29 = l_bmz05 
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
            DECLARE i710_s3_bmyc CURSOR FOR
             SELECT bmyc04 FROM bmyc_file
              WHERE bmyc01 = g_bmx.bmx01
                AND bmyc02 = b_bmy.bmy02
            FOREACH i710_s3_bmyc INTO l_bmyc04
               IF NOT cl_null(l_bmyc04) THEN
                    LET l_bmbc.bmbc01 = g_bmb.bmb01
                    LET l_bmbc.bmbc02 = g_bmb.bmb02
                    LET l_bmbc.bmbc03 = g_bmb.bmb03
                    LET l_bmbc.bmbc04 = g_bmb.bmb04
                    LET l_bmbc.bmbc05 = l_bmyc04
                    LET l_bmbc.bmbc29 = l_bmz05 
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
            DECLARE i710_s3_bmyd CURSOR FOR
             SELECT bmyd04 FROM bmyd_file
              WHERE bmyd01 = g_bmx.bmx01
                AND bmyd02 = b_bmy.bmy02
            FOREACH i710_s3_bmyd INTO l_bmyc04
               IF NOT cl_null(l_bmyc04) THEN
                    LET l_bmbd.bmbd01 = g_bmb.bmb01
                    LET l_bmbd.bmbd02 = g_bmb.bmb02
                    LET l_bmbd.bmbd03 = g_bmb.bmb03
                    LET l_bmbd.bmbd04 = g_bmb.bmb04
                    LET l_bmbd.bmbd05 = l_bmyc04
                    LET l_bmbd.bmbd29 = l_bmz05 
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
      #FUN-D80022--add--end--
   END IF 
  
   #No.FUN-A60008--begin
   IF g_argv1='2' THEN   #CHI-CA0035 mod g_argv3->g_argv1
      LET g_brb.brb05 =NULL
      IF NOT cl_null(b_bmy.bmy06) THEN LET g_brb.brb06 =b_bmy.bmy06 END IF
      IF NOT cl_null(b_bmy.bmy07) THEN LET g_brb.brb07 =b_bmy.bmy07 END IF
      IF NOT cl_null(b_bmy.bmy16) THEN LET g_brb.brb16 =b_bmy.bmy16 END IF
      IF NOT cl_null(b_bmy.bmy35) THEN LET g_brb.brb14 =b_bmy.bmy35 END IF #CHI-A60028 add
      LET g_brb.brb24 =g_bmx.bmx01
      IF NOT cl_null(b_bmy.bmy25) THEN LET g_brb.brb25 =b_bmy.bmy25 END IF
      IF NOT cl_null(b_bmy.bmy26) THEN LET g_brb.brb26 =b_bmy.bmy26 END IF
      IF NOT cl_null(b_bmy.bmy13) THEN LET g_brb.brb13 =b_bmy.bmy13 END IF
      IF NOT cl_null(b_bmy.bmy18) THEN LET g_brb.brb18 =b_bmy.bmy18 END IF
      IF NOT cl_null(b_bmy.bmy08) THEN LET g_brb.brb08 =b_bmy.bmy08 END IF
      IF NOT cl_null(b_bmy.bmy081) THEN LET g_brb.brb081 = b_bmy.bmy081 END IF   #FUN-AC0075
      IF NOT cl_null(b_bmy.bmy082) THEN LET g_brb.brb082 = b_bmy.bmy082 END IF   #FUN-AC0075
      IF NOT cl_null(b_bmy.bmy11) THEN LET g_brb.brb11 =b_bmy.bmy11 END IF
      IF NOT cl_null(b_bmy.bmy20) THEN LET g_brb.brb19 =b_bmy.bmy20 END IF
      IF NOT cl_null(b_bmy.bmy10) THEN LET g_brb.brb10 =b_bmy.bmy10 END IF
      IF NOT cl_null(b_bmy.bmy10_fac) THEN
         LET g_brb.brb10_fac =b_bmy.bmy10_fac
      END IF
      IF NOT cl_null(b_bmy.bmy10_fac2) THEN
         LET g_brb.brb10_fac2 =b_bmy.bmy10_fac2
      END IF
      IF NOT cl_null(b_bmy.bmy21) THEN LET g_brb.brb15 =b_bmy.bmy21 END IF 
      IF NOT cl_null(b_bmy.bmy23) THEN LET g_brb.brb28 =b_bmy.bmy23 END IF
      IF cl_null(g_brb.brb28) THEN LET g_brb.brb28 =0 END IF
      IF NOT cl_null(b_bmy.bmy34) THEN LET g_brb.brb31 =b_bmy.bmy34 END IF 
      LET g_brb.brbmodu = g_user
      LET g_brb.brbdate = g_today
      LET g_brb.brb04 =g_bmx.bmx07  
      LET g_brb.brb29 =b_bmz.bmz05 
      LET g_brb.brb30 =b_bmy.bmy30 
      LET g_brb.brb011=b_bmz.bmz011 
      LET g_brb.brb012=b_bmz.bmz012 
      LET g_brb.brb013=b_bmz.bmz013
      IF cl_null(g_brb.brb08) THEN
         LET g_brb.brb08 = 0
      END IF
      LET g_brb.brb33 = 0      
      IF cl_null(g_brb.brb09) THEN 
         SELECT ecb06 INTO g_ecb06 FROM ecb_file 
         WHERE ecb01=g_brb.brb01 AND ecb02=g_brb.brb011
          AND ecb012=g_brb.brb012 AND ecb03=g_brb.brb013
         LET g_brb.brb09=g_ecb06
      END IF            
      IF NOT cl_null(b_bmy.bmy34) THEN LET g_brb.brb31 =b_bmy.bmy34 END IF  
      # 將原資料設為無效，新增一筆修改後的資料
      UPDATE brb_file SET brb05=g_bmx.bmx07,
                          brbmodu = g_user,  
                          brbdate = g_today 
       WHERE brb01 = g_brb.brb01 AND brb02=g_brb.brb02 
       AND brb011 = g_brb.brb011 AND brb012 = g_brb.brb012 AND brb013 = g_brb.brb013
       AND brb03=g_brb.brb03  AND brb29=g_brb.brb29
       #AND brb04=g_brb.brb04      #No.FUN-A60083 
      IF SQLCA.SQLCODE OR STATUS THEN
         LET g_showmsg = g_bmx.bmx01,' upd brb:'
         CALL s_errmsg('brb01',g_bmx.bmx01,g_showmsg,SQLCA.sqlcode,1)
         LET g_success='N'
      END IF   
      SELECT MAX(brb02) INTO g_brb.brb02 FROM brb_file
       WHERE brb01 = g_brb.brb01
         AND brb011= g_brb.brb011
         AND brb012= g_brb.brb012
         AND brb013= g_brb.brb013
         AND brb29 = g_brb.brb29
      IF cl_null(g_brb.brb02) THEN LET g_brb.brb02 = 0 END IF
      LET g_brb.brb02 = g_brb.brb02 + g_sma.sma19
      IF cl_null(g_brb.brb02)  THEN
         LET g_brb.brb02=' '
      END IF      
#FUN-A70125 --begin--
      IF cl_null(g_brb.brb012) THEN
         LET g_brb.brb012 = ' '
      END IF  
      IF cl_null(g_brb.brb013) THEN
         LET g_brb.brb013 = 0 
      END IF  
#FUN-A70125 --end-- 
      #No.FUN-A60083--begin
      INSERT INTO brb_file VALUES (g_brb.*)
      IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
         LET g_showmsg = g_brb.brb01,' ins brb:'
         CALL s_errmsg('brb01',g_brb.brb01,g_showmsg,STATUS,1)
         LET g_success='N'
      END IF   
      IF g_bra014='Y' THEN 
         DELETE FROM bmb_file WHERE bmb01=g_brb.brb01 
                                AND bmb03=g_brb.brb03 
                                AND bmb09=g_brb.brb09
                                AND bmb29=g_brb.brb29
         SELECT SUM(brb06) INTO l_brb06 FROM brb_file,bra_file  
          WHERE brb01=g_brb.brb01 AND brb011=g_brb.brb011 
            AND (brb012 !=g_brb.brb012 OR brb013 !=g_brb.brb013 )
            AND brb09 =g_brb.brb09 AND brb29 =g_brb.brb29 
            AND brb03=g_brb.brb03 AND bra01=brb01 AND bra011=brb011 AND bra012=brb012 AND bra013=brb013 
            AND bra06=brb29 AND bra014='Y' 
         IF cl_null(l_brb06) THEN LET l_brb06=0 END IF 
         LET g_bmb.bmb01=g_brb.brb01   LET g_bmb.bmb03=g_brb.brb03
         LET g_bmb.bmb04 =g_bmx.bmx07  LET g_bmb.bmb29 =b_bmz.bmz05 
         LET g_bmb.bmb30 =b_bmy.bmy30  LET g_bmb.bmb05 =NULL
         SELECT MAX(bmb02) INTO g_bmb.bmb02 FROM bmb_file
          WHERE bmb01 = g_bmb.bmb01
            AND bmb29 = g_bmb.bmb29 
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
       
         INSERT INTO bmb_file VALUES (g_bmb.*)
         IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
            LET g_showmsg = g_bmb.bmb01,' ins bmb:'
            CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,STATUS,1)
            LET g_success='N'
         END IF                                   
      END IF 
      #No.FUN-A60083--end 
   END IF 
   #No.FUN-A60008--end    
   IF g_argv1='1' THEN      #No.FUN-A60008   #CHI-CA0035 mod g_argv3->g_argv1
      IF g_sma.sma845='Y' THEN   #低階碼可否部份重計
         LET g_success='Y'
         #CALL s_uima146(g_bmb.bmb03)  #CHI-D10044
         CALL s_uima146(g_bmb.bmb03,0)  #CHI-D10044
         CALL cl_msg("")                              #FUN-640241
      END IF
      
      DECLARE i710_s3_c2 CURSOR FOR
       SELECT * FROM bmw_file
        WHERE bmw01=g_bmx.bmx01
          AND bmw02=b_bmy.bmy02
      
      FOREACH i710_s3_c2 INTO b_bmw.*
         LET l_bmt.bmt01=g_bmb.bmb01
         LET l_bmt.bmt02=g_bmb.bmb02
         LET l_bmt.bmt03=g_bmb.bmb03
         LET l_bmt.bmt04=g_bmb.bmb04
         LET l_bmt.bmt05=b_bmw.bmw03
         LET l_bmt.bmt06=b_bmw.bmw04
         LET l_bmt.bmt07=b_bmw.bmw05
         LET l_bmt.bmt08=g_bmb.bmb29 #FUN-550014 add
         IF cl_null(l_bmt.bmt02) THEN
            LET l_bmt.bmt02=0
         END IF
         INSERT INTO bmt_file VALUES(l_bmt.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg = g_bmb.bmb01,' ins bmt:'
            CALL s_errmsg('bmt01',l_bmt.bmt01,g_showmsg,SQLCA.SQLCODE,1)
            LET g_success='N'
         END IF      
      END FOREACH
      
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM bmw_file
        WHERE bmw01=g_bmx.bmx01 AND bmw02=b_bmy.bmy02
      IF g_cnt=0 THEN
        DECLARE i710_s3_c21 CURSOR FOR
         SELECT * FROM bmt_file
          WHERE bmt01=b_bmz.bmz02 #AND bmt02=b_bmy.bmy04 #FUN-860074
            AND bmt03=b_bmy.bmy05
            AND bmt04 IN (SELECT MAX(bmt04) FROM bmt_file
                           WHERE bmt01=b_bmz.bmz02 #AND bmt02=b_bmy.bmy04 #FUN-860074
                             AND bmt03=b_bmy.bmy05 )
        LET l_cnt=0
        FOREACH i710_s3_c21 INTO l_bmt.*
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
           INSERT INTO bmt_file VALUES(l_bmt.*)
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
              LET g_showmsg = l_bmt.bmt01,' s3_c21 ins bmt:'
              CALL s_errmsg('bmt01',l_bmt.bmt01,g_showmsg,SQLCA.SQLCODE,1)
              LET g_success='N'
           END IF
        END FOREACH
      END IF
      
      CALL i710_up_bmb13()
      
#---- 說明檔(bmc_file)複製 add in 00/03/15 ------------
      SELECT COUNT(*) INTO g_cnt FROM bmf_file
       WHERE bmf01=g_bmx.bmx01 AND bmf02=b_bmy.bmy02
      IF g_cnt=0 THEN RETURN END IF	# 有輸入才更新
      
      DECLARE i710_s3_c3 CURSOR FOR
       SELECT * FROM bmf_file
        WHERE bmf01=g_bmx.bmx01 AND bmf02=b_bmy.bmy02
      
      FOREACH i710_s3_c3 INTO b_bmf.*
         LET l_bmc.bmc01=g_bmb.bmb01
         LET l_bmc.bmc02=g_bmb.bmb02
         LET l_bmc.bmc021=g_bmb.bmb03
         LET l_bmc.bmc03=g_bmb.bmb04
         LET l_bmc.bmc04=b_bmf.bmf03
         LET l_bmc.bmc05=b_bmf.bmf04
         LET l_bmc.bmc06=g_bmb.bmb29 #FUN-550014 add
      
         INSERT INTO bmc_file VALUES(l_bmc.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg = l_bmc.bmc01,' ins bmc:'
            CALL s_errmsg('bmc01',l_bmc.bmc01,g_showmsg,SQLCA.SQLCODE,1)
            LET g_success='N'
         END IF
      
      END FOREACH
   END IF      #No.FUN-A60008 
END FUNCTION
 
FUNCTION i710_s4()
   DEFINE l_bmt		RECORD LIKE bmt_file.*
   DEFINE l_bmc		RECORD LIKE bmc_file.*
   DEFINE l_cnt 	LIKE type_file.num5 #FUN-850156
   DEFINE l_brb06       LIKE brb_file.brb06 
   DEFINE l_bmb06       LIKE bmb_file.bmb06  #No:MOD-A10114 add
   DEFINE l_bmb07       LIKE bmb_file.bmb07  #No:MOD-A10114 add
   DEFINE l_bmb09       LIKE bmb_file.bmb09  #CHI-C40010 add
  #DEFINE l_bmb04       LIKE bmb_file.bmb04  #MOD-EC0101 add #MOD-F20085 mark

   
  #IF b_bmy.bmy03='4' THEN #MOD-EC0101 add 當為5:替代時，不用失效，改用UPDATE #MOD-F20085 mark
      #舊料做失效
      UPDATE bmb_file SET bmb05=g_bmx.bmx07,
                          bmbmodu=g_user,
                          bmbdate=g_today
       WHERE bmb01 = g_bmb.bmb01 AND bmb02=g_bmb.bmb02 AND bmb03=g_bmb.bmb03 AND bmb04=g_bmb.bmb04 AND bmb29=g_bmb.bmb29
      IF SQLCA.sqlcode THEN
         LET g_showmsg = g_bmx.bmx07,' s4_upd bmb:'
         CALL s_errmsg('bmx07',g_bmx.bmx07,g_showmsg,STATUS,1)
         LET g_success='N'
      END IF
   
      IF SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = g_bmx.bmx07,' upd bmb:'
         CALL s_errmsg('bmx07',g_bmx.bmx07,g_showmsg,'aap-161',1)
         LET g_success='N'
      END IF
     #FUN-F50035 add str---
      IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN #與APS整合
         CALL i710_del_vmo()
      END IF
     #FUN-F50035 add end---
  #END IF #MOD-EC0101 add #MOD-F20085 mark
   
   #MOD-D40044---begin
   IF b_bmy.bmy03 = '4' THEN
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM bmd_file 
              WHERE bmd08 = g_bmb.bmb01
                AND bmd01 = g_bmb.bmb03
                AND (bmd06 > g_bmx.bmx07 OR bmd06 IS NULL)
      IF l_cnt > 0 THEN 
         UPDATE bmd_file SET bmd06=g_bmx.bmx07,
                             bmdmodu=g_user,
                             bmddate=g_today
          WHERE bmd08 = g_bmb.bmb01 
            AND bmd01 = g_bmb.bmb03
            AND (bmd06 > g_bmx.bmx07 OR bmd06 IS NULL)
 
         IF SQLCA.sqlcode THEN
            LET g_showmsg = g_bmx.bmx01,' update bmd_file:'                    
            CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,SQLCA.SQLCODE,1)
            LET g_success='N'
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg = g_bmx.bmx01,' update bmd_file:'                    
            CALL s_errmsg('bmx01',g_bmx.bmx01,g_showmsg,'aap-161',1)
            LET g_success='N'
         END IF
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
  #-----------------No:MOD-A10114 add
   LET l_bmb06 = 1
   LET l_bmb07 = 1
   SELECT bmb06,bmb07 INTO l_bmb06,l_bmb07                             #MOD-EC0101 mark  #MOD-F20085 unmark
  #SELECT bmb06,bmb07,bmb04 INTO l_bmb06,l_bmb07,l_bmb04               #MOD-EC0101 add   #MOD-F20085 mark
                                           FROM bmb_file WHERE bmb01=g_bmb.bmb01
                                                           AND bmb02=g_bmb.bmb02   #MOD-B70148 add
                                                           AND bmb03=g_bmb.bmb03   #MOD-B70148 add
                                                           AND bmb04=g_bmb.bmb04   #MOD-B70148 add
                                                           AND bmb29=g_bmb.bmb29
   IF cl_null(l_bmb06) THEN LET l_bmb06 = 1 END IF 
   IF cl_null(l_bmb07) THEN LET l_bmb07 = 1 END IF 
  #-----------------No:MOD-A10114 end
   
#新增新料,取替代default '1'
   INITIALIZE g_bmb.* TO NULL
   LET g_bmb.bmb01 =b_bmz.bmz02
   #No.TQC-A30040  --Begin
   #LET g_bmb.bmb02 =b_bmy.bmy04
   #IF cl_null(g_bmb.bmb02) THEN
   #   LET g_bmb.bmb02 = g_last_seq
   #END IF
   #No.TQC-A30040  --End  
   LET g_bmb.bmb29 =b_bmz.bmz05  #FUN-550014 add
   LET g_bmb.bmb30 =b_bmy.bmy30 #FUN-550014 add
   IF cl_null(g_bmb.bmb02) THEN
     #MOD-F20085--mark---str---
     ##MOD-EC0101-Start-Add
     #IF b_bmy.bmy03 = '5' THEN 
     #   SELECT MAX(bmb02) INTO g_bmb.bmb02 FROM bmb_file WHERE bmb01=g_bmb.bmb01
     #                                                      AND bmb03=b_bmy.bmy05
     #                                                      AND bmb29=g_bmb.bmb29
     #ELSE    
     ##MOD-EC0101-End-Add
     #MOD-F20085--mark---end---
         SELECT MAX(bmb02) INTO g_bmb.bmb02 FROM bmb_file WHERE bmb01=g_bmb.bmb01
                                                            AND bmb29=g_bmb.bmb29 #FUN-550014 add
     #END IF #MOD-EC0101 add #MOD-F20085 mark
      IF g_bmb.bmb02 IS NULL THEN LET g_bmb.bmb02 = 0 END IF
     #IF b_bmy.bmy03 = '4' THEN   #MOD-EC0101 add  #MOD-F20085 mark
         LET g_bmb.bmb02=g_bmb.bmb02+g_sma.sma19   #MOD-9C0004 add
     #END IF                      #MOD-EC0101 add  #MOD-F20085 mark
   END IF
  #LET g_bmb.bmb02=g_bmb.bmb02+g_sma.sma19   #CHI-960004    #MOD-9C0004 mark

  #----------------No:MOD-9C0004 add
   IF cl_null(g_bmb.bmb02) THEN
      LET g_bmb.bmb02 = g_last_seq 
   END IF
  #----------------No:MOD-9C0004 end
   
   IF b_bmy.bmy03 ='5' THEN
      LET g_bmb.bmb03 =b_bmy.bmy05
   ELSE
      LET g_bmb.bmb03 =b_bmy.bmy27
   END IF
   LET g_bmb.bmb04 =g_bmx.bmx07
  #--------------No:MOD-A10114 modify
   IF b_bmy.bmy03 = '5' THEN
      LET g_bmb.bmb06 =l_bmb06
      LET g_bmb.bmb07 =l_bmb07
   ELSE
     #str CHI-A30011 mod
     #LET g_bmb.bmb06 =b_bmy.bmy06
     #LET g_bmb.bmb07 =b_bmy.bmy07
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
     #end CHI-A30011 mod
      #M014 180205 By TSD.Andy -----(S)
      IF g_bmx.ta_bmx01 = 'Y' THEN
         LET g_bmb.bmb06 = g_bmb.bmb06 * g_bmx.ta_bmx02
      END IF
      #M014 180205 By TSD.Andy -----(E)
   END IF
  #--------------No:MOD-A10114 end
  #LET g_bmb.bmb06 =b_bmy.bmy06  #MOD-B90044 mark 上面已有判斷，此處不需在重新給值
  #LET g_bmb.bmb07 =b_bmy.bmy07  #MOD-B90044 mark 上面已有判斷，此處不需在重新給值
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
  #CHI-C40010 str add------
  #LET g_bmb.bmb09 =b_bmy.bmy09
   IF NOT cl_null(b_bmy.bmy09) THEN
     LET g_bmb.bmb09 =b_bmy.bmy09
   ELSE
     LET g_bmb.bmb09 =l_bmb09
   END IF
  #CHI-C40010 end add-----
   LET g_bmb.bmb10 =b_bmy.bmy10
   LET g_bmb.bmb10_fac =b_bmy.bmy10_fac
   SELECT ima105 INTO g_bmb.bmb27 FROM ima_file    #No.MOD-940061 add
    WHERE ima01=g_bmb.bmb03
   LET g_bmb.bmb10_fac2=b_bmy.bmy10_fac2
  #LET g_bmb.bmb14 =0 #CHI-A60028 mark
   LET g_bmb.bmb14 =b_bmy.bmy35 #CHI-A60028 add
   LET g_bmb.bmb15 = b_bmy.bmy21        #bugno:6845 add
   LET g_bmb.bmb17 ='N'
   LET g_bmb.bmb19 ='1'
   IF NOT cl_null(b_bmy.bmy20) THEN LET g_bmb.bmb19 =b_bmy.bmy20 END IF  # No.MOD-710092 modify
   LET g_bmb.bmb23 =0
   LET g_bmb.bmb28 = b_bmy.bmy23        #bugno:6845 add
 
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
      SELECT ima70 INTO g_bmb.bmb15 FROM ima_file
       WHERE ima01 = g_bmb.bmb03 
   END IF
   LET g_bmb.bmb33 = 0                  #NO.FUN-840033
   LET g_bmb.bmbdate = g_today  #MOD-930124 
   IF NOT cl_null(b_bmy.bmy34) THEN LET g_bmb.bmb31 =b_bmy.bmy34 END IF   #FUN-840156

   #LET g_bmb.bmb34 = b_bmy.bmy38                  #TQC-DA0015 add #20201208 mark
   IF cl_null(g_bmb.bmb34) THEN LET g_bmb.bmb34 = 0 END IF  #TQC-DA0015 add
  #IF b_bmy.bmy03='4' THEN  #MOD-EC0101 add #MOD-F20085 mark
      INSERT INTO bmb_file VALUES(g_bmb.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = g_bmb.bmb01,' s4_ins bmb:'
         CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,SQLCA.SQLCODE,1)
         LET g_success='N'
      END IF
     #FUN-F50035 add str-----
      IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN #與APS整合
         CALL i710_ins_vmo()
      END IF
     #FUN-F50035 add end-----

 #MOD-F20085--mark---str---
 ##MOD-EC0101-Start-Add #5:替代 用UPDATE  
 # ELSE
 #    UPDATE bmb_file set bmb.* = g_bmb.*
 #     WHERE bmb01=g_bmb.bmb01
 #       AND bmb02=g_bmb.bmb02   
 #       AND bmb03=g_bmb.bmb03   
 #       AND bmb04=l_bmb04  
 #       AND bmb29=g_bmb.bmb29
 #    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
 #       LET g_showmsg = g_bmb.bmb01,' s4_upd bmb:'
 #       CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,SQLCA.SQLCODE,1)
 #       LET g_success='N'
 #    END IF   
 # END IF 
 ###MOD-EC0101-End-Add 
 #MOD-F20085--mark---end---
      IF g_sma.sma845='Y' THEN   #低階碼可否部份重計
         LET g_success='Y'
         #CALL s_uima146(g_bmb.bmb03)  #CHI-D10044
         CALL s_uima146(g_bmb.bmb03,0)  #CHI-D10044
         CALL cl_msg("")                              #FUN-640241
      END IF
    
      DECLARE i710_s4_c2 CURSOR FOR
       SELECT * FROM bmw_file
        WHERE bmw01=g_bmx.bmx01 AND bmw02=b_bmy.bmy02
      FOREACH i710_s4_c2 INTO b_bmw.*
         LET l_bmt.bmt01=g_bmb.bmb01
         LET l_bmt.bmt02=g_bmb.bmb02
         LET l_bmt.bmt03=g_bmb.bmb03
         LET l_bmt.bmt04=g_bmb.bmb04
         LET l_bmt.bmt05=b_bmw.bmw03
         LET l_bmt.bmt06=b_bmw.bmw04
         LET l_bmt.bmt07=b_bmw.bmw05
         LET l_bmt.bmt08=g_bmb.bmb29 #FUN-550014
         IF cl_null(l_bmt.bmt02) THEN
            LET l_bmt.bmt02=0
         END IF
         INSERT INTO bmt_file VALUES(l_bmt.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg = l_bmt.bmt01,' s4_ins bmt:'
            CALL s_errmsg('bmt01',l_bmt.bmt01,g_showmsg,SQLCA.SQLCODE,1)
            LET g_success='N'
         END IF
      END FOREACH
    
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM bmw_file
        WHERE bmw01=g_bmx.bmx01 AND bmw02=b_bmy.bmy02
      IF g_cnt=0 THEN
        DECLARE i710_s4_c21 CURSOR FOR
         SELECT * FROM bmt_file
          WHERE bmt01=b_bmz.bmz02 #AND bmt02=b_bmy.bmy04 #FUN-860074
            AND bmt03=b_bmy.bmy05
            AND bmt04 IN (SELECT MAX(bmt04) FROM bmt_file
                           WHERE bmt01=b_bmz.bmz02 #AND bmt02=b_bmy.bmy04 #FUN-860074
                             AND bmt03=b_bmy.bmy05
                         )
        LET l_cnt=0
        FOREACH i710_s4_c21 INTO l_bmt.*
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
           INSERT INTO bmt_file VALUES(l_bmt.*)
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
              LET g_showmsg = l_bmt.bmt01,' s4_c21 ins bmt:'
              CALL s_errmsg('bmt01',l_bmt.bmt01,g_showmsg,SQLCA.SQLCODE,1)
              LET g_success='N'
           END IF
        END FOREACH
      END IF
    
      CALL i710_up_bmb13()
    
   #----- 說明檔(bmc_file)複製 add in 03/03/10 ------------
      SELECT COUNT(*) INTO g_cnt FROM bmf_file
       WHERE bmf01=g_bmx.bmx01 AND bmf02=b_bmy.bmy02
      IF g_cnt>0 THEN 	# 有輸入才更新
         DECLARE i710_s4_c3 CURSOR FOR
          SELECT * FROM bmf_file
           WHERE bmf01=g_bmx.bmx01 AND bmf02=b_bmy.bmy02
    
         FOREACH i710_s4_c3 INTO b_bmf.*
             LET l_bmc.bmc01=g_bmb.bmb01
             LET l_bmc.bmc02=g_bmb.bmb02
             LET l_bmc.bmc021=g_bmb.bmb03
             LET l_bmc.bmc03=g_bmb.bmb04
             LET l_bmc.bmc04=b_bmf.bmf03
             LET l_bmc.bmc05=b_bmf.bmf04
             LET l_bmc.bmc06=g_bmb.bmb29 #FUN-550014 add
             INSERT INTO bmc_file VALUES(l_bmc.*)
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                LET g_showmsg = l_bmt.bmt01,' s4_ins bmc:'
                CALL s_errmsg('bmc01',l_bmc.bmc01,g_showmsg,SQLCA.SQLCODE,1)
                LET g_success='N'
             END IF
         END FOREACH
    
      END IF
    
   #----- 取代�替代產品結構明細資料檔(bmd_file)複製 add in 03/03/10 ------------
      IF NOT cl_null(g_bmy05_t) AND b_bmy.bmy16 <> '0' THEN
         INITIALIZE g_bmd.* TO NULL
         IF b_bmy.bmy03 = '4' THEN   #CHI-960004
            LET g_bmd.bmd01=b_bmy.bmy27 #CHI-960004
            LET g_bmd.bmd02='1'
            LET g_bmd.bmd07 = 1      #No:MOD-A10114 add
         END IF                      #CHI-960004
         IF b_bmy.bmy03 = '5' THEN   #CHI-960004
            LET g_bmd.bmd01=b_bmy.bmy05 #CHI-960004
            LET g_bmd.bmd02='2'      #CHI-960004
            LET g_bmd.bmd07= b_bmy.bmy06 / b_bmy.bmy07   #No:MOD-A10114 add
         END IF                      #CHI-960004
         IF b_bmy.bmy03 = '5' THEN
            SELECT max(bmd03)+1 INTO g_bmd.bmd03 
              FROM bmd_file
             WHERE bmd01 = b_bmy.bmy05
               AND bmd02 = '2' 
               AND bmd08 = b_bmz.bmz02
            IF cl_null(g_bmd.bmd03) THEN
               LET g_bmd.bmd03=1
            END IF
          ELSE
           #LET g_bmd.bmd03 = 1 #MOD-H30025 mark
           #MOD-H30025---add----str----
            SELECT max(bmd03)+1 INTO g_bmd.bmd03 
              FROM bmd_file
             WHERE bmd01 = b_bmy.bmy27
               AND bmd02 = '1' #取代
               AND bmd08 = b_bmz.bmz02
            IF cl_null(g_bmd.bmd03) THEN
               LET g_bmd.bmd03=1
            END IF
           #MOD-H30025---add----end----
          END IF
         IF b_bmy.bmy03 = '4' THEN     #CHI-960004
            LET g_bmd.bmd04=g_bmy05_t
         ELSE
            LET g_bmd.bmd04=b_bmy.bmy27
         END IF
         LET g_bmd.bmd05=g_bmx.bmx07
        #LET g_bmd.bmd07=1              #No:MOD-A10114 mark
         LET g_bmd.bmd08=b_bmz.bmz02
         LET g_bmd.bmduser = g_user
         LET g_bmd.bmdgrup = g_grup
         LET g_bmd.bmddate = g_today
         LET g_bmd.bmdacti = 'Y'
         LET g_bmd.bmdoriu = g_user      #No.FUN-980030 10/01/04
         LET g_bmd.bmdorig = g_grup      #No.FUN-980030 10/01/04
         IF cl_null(g_bmd.bmd11) THEN LET g_bmd.bmd11 = 'N' END IF      #TQC-C20131  add
         INSERT INTO bmd_file VALUES(g_bmd.*)
        #FUN-F50035 add str---
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg = g_bmd.bmd01,' s4_ins bmd:'
            CALL s_errmsg('bmd01',g_bmd.bmd01,g_showmsg,SQLCA.SQLCODE,1)
            LET g_success='N'
         END IF
        #FUN-F50035 add end---
         LET g_bmy05_t=NULL
        #FUN-F50035 add str---
         IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN #與APS整合
            CALL i710_upd_vmq()
         END IF
        #FUN-F50035 add end---
      END IF
END FUNCTION
 
FUNCTION i710_up_bmb13()
 DEFINE l_cnt     LIKE type_file.num5   #MOD-G90038 add
 DEFINE l_ima147  LIKE ima_file.ima147  #MOD-G90008 add
 DEFINE l_bmt07   LIKE bmt_file.bmt07   #MOD-G90008 add
 DEFINE l_bmt06   LIKE bmt_file.bmt06,
        s_bmb13   LIKE bmb_file.bmb13,
        l_i,i,j   LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
    LET s_bmb13=' '
    LET l_i = 0
    DECLARE up_bmb13_cs CURSOR FOR
     SELECT bmt06 FROM bmt_file
      WHERE bmt01=g_bmb.bmb01 AND bmt02=g_bmb.bmb02
        AND bmt03=g_bmb.bmb03 AND bmt04=g_bmb.bmb04
        AND bmt08=g_bmb.bmb29 #FUN-550014 add
    FOREACH up_bmb13_cs INTO l_bmt06
     IF SQLCA.sqlcode THEN
        LET g_showmsg = g_bmb.bmb01,' up_bmb13_cs foreach:'
        CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,SQLCA.SQLCODE,1)
        EXIT FOREACH
     END IF
 
     IF l_i = 0 THEN
        LET s_bmb13=l_bmt06
     ELSE
        IF (Length(s_bmb13) + Length(l_bmt06)) > 8 THEN   #No.MOD-6B0077 modify
           FOR i=1 TO (10 - Length(s_bmb13))
               LET s_bmb13 = s_bmb13 CLIPPED , '.'
           END FOR
           EXIT FOREACH
        ELSE
           LET s_bmb13= s_bmb13 CLIPPED , ',', l_bmt06
        END IF
     END IF
     LET l_i = l_i + 1
    END FOREACH

   #MOD-G90008--add---str---
    LET l_ima147 = NULL
    SELECT ima147 INTO l_ima147 FROM ima_file 
     WHERE ima01=g_bmb.bmb03
    IF l_ima147 = 'Y' THEN
        SELECT bmb06 INTO l_bmt07 FROM bmb_file
         WHERE bmb01=g_bmb.bmb01 
           AND bmb02=g_bmb.bmb02
           AND bmb03=g_bmb.bmb03 
           AND bmb04=g_bmb.bmb04
           AND bmb29=g_bmb.bmb29 
    ELSE
        #MOD-G90038---add----str----
        #當插件位置檔(bmt_file)有資料時,以SUM(bmt07)的值回寫組成用量
        #當插件位置檔(bmt_file)無資料時,以原bmb06   的值回寫組成用量
        SELECT COUNT(*) INTO l_cnt FROM bmt_file 
         WHERE bmt01=g_bmb.bmb01 
           AND bmt02=g_bmb.bmb02
           AND bmt03=g_bmb.bmb03 
           AND bmt04=g_bmb.bmb04
           AND bmt08=g_bmb.bmb29 
        IF l_cnt >=1 THEN
        #MOD-G90038---add----end----
            SELECT SUM(bmt07) INTO l_bmt07 FROM bmt_file 
             WHERE bmt01=g_bmb.bmb01 
               AND bmt02=g_bmb.bmb02
               AND bmt03=g_bmb.bmb03 
               AND bmt04=g_bmb.bmb04
               AND bmt08=g_bmb.bmb29 
        #MOD-G90038---add----str----
        ELSE
            SELECT bmb06 INTO l_bmt07 FROM bmb_file
             WHERE bmb01=g_bmb.bmb01 
               AND bmb02=g_bmb.bmb02
               AND bmb03=g_bmb.bmb03 
               AND bmb04=g_bmb.bmb04
               AND bmb29=g_bmb.bmb29 
        END IF
        #MOD-G90038---add----end----
    END IF 
    #MOD-G90038---add----str----
    IF cl_null(l_bmt07) THEN
        LET l_bmt07 = 1
    END IF
    #MOD-G90038---add----end----
   #MOD-G90008--add---end---
 
    UPDATE bmb_file SET bmb13 = s_bmb13,
                        bmb06 = l_bmt07,  #MOD-G90008 add
                        bmbmodu = g_user, #MOD-930124
                        bmbdate = g_today #MOD-930124
     WHERE bmb01=g_bmb.bmb01 AND bmb02=g_bmb.bmb02
       AND bmb03=g_bmb.bmb03 AND bmb04=g_bmb.bmb04
       AND bmb29=g_bmb.bmb29 #FUN-550014 add
    IF SQLCA.sqlcode THEN
       LET g_showmsg = g_bmb.bmb01,' update bmb13:'
       CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,SQLCA.SQLCODE,1)
    END IF
 
END FUNCTION
 
FUNCTION i710_t()
   DEFINE ls_tmp     STRING
   DEFINE i	     LIKE type_file.num5     #No.FUN-680096  SMALLINT
   DEFINE l_bmw03    LIKE bmw_file.bmw03
   DEFINE l_n    LIKE type_file.num5    #No.FUN-860044
 
   LET p_row = 9 LET p_col = 48
   
  #MOD-G90032--add---str---
   IF g_bmy[l_ac].bmy03 NOT MATCHES '[23]' THEN
      #插件位置的維護限制在變異別為[2:新元件新增生效]或[3:舊元件修改]才能進入
      CALL cl_err('','abm-098',1)
      RETURN
   END IF
  #MOD-G90032--add---end---
  #FUN-B80071 add str---
   IF g_bmx.bmx09 matches '[Ss]' THEN        
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
  #FUN-B80071 add end---
    SELECT COUNT(*) INTO l_n FROM bmx_file,bmy_file
     WHERE bmx01 = bmy01 
       AND bmx01 = g_bmx.bmx01 
     
   IF l_n = 0  THEN 
     IF g_bmx.bmx04 = 'Y'  THEN  
       CALL cl_err('','abm-520',0)
       RETURN  
     ELSE 
     	 LET l_ac = 1
     END IF 	  
   END IF   

  #MOD-G90008--add---str--
   IF NOT cl_null(g_bmy[l_ac].bmy05) THEN
       SELECT ima107,ima147
         INTO g_ima107,g_ima147
         FROM ima_file
        WHERE ima01=g_bmy[l_ac].bmy05
   END IF
  #MOD-G90008--add---end--
   
   
   OPEN WINDOW i710_t_w AT p_row,p_col WITH FORM "abm/42f/abmi710c"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmi710c")
 
   IF STATUS THEN
      CALL cl_err('open win:',STATUS,1)
      RETURN
   END IF
   
   CALL i710_t_fill()
     
   LET g_success ='Y'
   
   IF g_bmx.bmx04 <> 'Y' THEN
      CALL i710_t_i()
   ELSE 
   	 CALL cl_err('','abm-521',0) 
   	 DISPLAY ARRAY g_bmw TO s_bmw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
   	 
   	  BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
        CALL cl_show_fld_cont() 
      
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION cancel
         LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY   
         
     END DISPLAY   
   END IF
   IF g_success = 'N' THEN
     CLOSE WINDOW i710_t_w
     RETURN
   END IF
 
   DELETE FROM bmw_file
    WHERE bmw01=g_bmx.bmx01 AND bmw02=g_bmy[l_ac].bmy02
   IF SQLCA.SQLCODE OR STATUS THEN
      CALL cl_err3("del","bmw_file",g_bmx.bmx01,g_bmy[l_ac].bmy02,SQLCA.SQLCODE,"","del bmw:",1) # TQC-660046
      LET g_success='N'
   END IF
 
   LET l_bmw03 = 0
   FOR i=1 TO g_bmw.getLength()
      IF g_bmw[i].bmw04 IS NULL OR g_bmw[i].bmw05 IS NULL OR
         g_bmw[i].bmw05 = 0 THEN
         CONTINUE FOR
      END IF
 
      LET b_bmw.bmw01=g_bmx.bmx01
      LET b_bmw.bmw02=g_bmy[l_ac].bmy02
      LET l_bmw03 = l_bmw03 + g_sma.sma19
      LET b_bmw.bmw03=l_bmw03
      LET b_bmw.bmw04=g_bmw[i].bmw04
      LET b_bmw.bmw05=g_bmw[i].bmw05
 
      LET b_bmw.bmwplant = g_plant 
      LET b_bmw.bmwlegal = g_legal 
 
      INSERT INTO bmw_file VALUES(b_bmw.*)
 
   END FOR
   
   CLOSE WINDOW i710_t_w
 
END FUNCTION
 
FUNCTION i710_t_i()
   DEFINE l_exit_while     LIKE type_file.chr1     #MOD-4B0191      #No.FUN-680096  VARCHAR(1)
   DEFINE l_n              LIKE type_file.num5     #No.FUN-680096   #No.FUN-680096  SMALLINT
   DEFINE i,s              LIKE type_file.num5     #No.FUN-680096  SMALLINT
   DEFINE l_amt            LIKE bmw_file.bmw05,
          l_allow_insert   LIKE type_file.num5,    #可新增否        #No.FUN-680096  SMALLINT
          l_allow_delete   LIKE type_file.num5     #可刪除否        #No.FUN-680096  SMALLINT
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   CALL i710_get_ori_bmb06()  #MOD-G90008 add
 
  WHILE TRUE #MOD-4B0191 ADD (WHILE.....END WHILE)
   
   INPUT ARRAY g_bmw WITHOUT DEFAULTS FROM s_bmw.*
         ATTRIBUTE(COUNT=g_rec_t,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         CALL fgl_set_arr_curr(l_ac)
         LET g_success = 'Y'
 
      BEFORE ROW
         LET l_exit_while = 'Y'          #MOD-4B0191
         LET i=ARR_CURR()
         LET g_bmw_t.* = g_bmw[l_ac].*  #BACKUP  #No.FUN-860044
         IF cl_null(g_bmw[i].bmw04) THEN
            LET g_bmw[i].bmw05 = NULL
         END IF
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         
      AFTER ROW
         CALL i710_t_cnt()
 
      AFTER INPUT
        #IF INT_FLAG THEN EXIT INPUT END IF  #CHI-DC0019 mark
         CALL i710_t_cnt()
        #LET l_amt = g_bmy[l_ac].bmy06 / g_bmy[l_ac].bmy07    #CHI-C10023 mark
         IF g_ima147 = 'Y' THEN
           #IF g_bmw05 != l_amt THEN                          #CHI-C10023 mark
           #    LET l_exit_while = 'N'      #MOD-4B0191       #CHI-C10023 mark
            CALL i710_chk_bmw() RETURNING l_exit_while        #CHI-C10023 add
            IF l_exit_while = 'N' THEN                        #CHI-C10023 add
                CALL cl_err('','abm-010',1) #MOD-4B0191
               NEXT FIELD bmw04
            END IF
         END IF
 
      ON ACTION get_org_ins_loc
         CALL i710_g_bmw()
         CALL i710_t_cnt()
         EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END INPUT
      
   IF INT_FLAG THEN
      LET INT_FLAG=0
      LET g_success='N'
       EXIT WHILE #MOD-4B0191
   END IF
   IF l_exit_while = 'N' THEN
       CONTINUE WHILE
   END IF
   EXIT WHILE
 END WHILE
 
END FUNCTION
 
FUNCTION i710_t_cnt()
   DEFINE i	LIKE type_file.num10   #No.FUN-680096  INTEGER
 
   LET g_bmw05=0
 
   FOR i=1 TO g_bmw.getLength()
      IF g_bmw[i].bmw04 IS NULL OR g_bmw[i].bmw05 IS NULL OR
         g_bmw[i].bmw05 = 0 THEN
         CONTINUE FOR
      END IF
 
      LET g_bmw05 = g_bmw05 + g_bmw[i].bmw05
 
   END FOR
 
   DISPLAY g_bmw05 TO tot
 
END FUNCTION
 
FUNCTION i710_g_bmw()
   DEFINE l_bmy		RECORD LIKE bmy_file.*
   DEFINE l_bmb		RECORD LIKE bmb_file.*
   DEFINE l_bmt		RECORD LIKE bmt_file.*
 
   CALL g_bmw.clear()
   INITIALIZE l_bmy.* TO NULL #CHI-DC0019 add
 
   SELECT * INTO l_bmy.* FROM bmy_file
    WHERE bmy01 = g_bmx.bmx01
      AND bmy02 = g_bmy[l_ac].bmy02
 
   IF NOT cl_null(l_bmy.bmy04) THEN
      SELECT * INTO l_bmb.* FROM bmb_file
       WHERE bmb01 = g_bmz[1].bmz02
         AND bmb29 = g_bmz[1].bmz05 #FUN-550014 add
         AND bmb02 = l_bmy.bmy04
        #AND bmb03 = l_bmy.bmy05        #CHI-DC0019 mark
         AND bmb03 = g_bmy[l_ac].bmy05  #CHI-DC0019 Add
         AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                       WHERE bmb01 = g_bmz[1].bmz02
                         AND bmb29 = g_bmz[1].bmz05 #FUN-550014 add
                        #AND bmb02 = l_bmy.bmy04         #CHI-DC0019 mark
                        #AND bmb03 = l_bmy.bmy05)        #CHI-DC0019 mark
                         AND bmb02 = g_bmy[l_ac].bmy04   #CHI-DC0019 add
                         AND bmb03 = g_bmy[l_ac].bmy05)  #CHI-DC0019 Add
   ELSE
      SELECT * INTO l_bmb.* FROM bmb_file
       WHERE bmb01 = g_bmz[1].bmz02
         AND bmb29 = g_bmz[1].bmz05 #FUN-550014 add
        #AND bmb03 = l_bmy.bmy05        #CHI-DC0019 mark
         AND bmb03 = g_bmy[l_ac].bmy05  #CHI-DC0019 Add
         AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                       WHERE bmb01 = g_bmz[1].bmz02
                         AND bmb29 = g_bmz[1].bmz05 #FUN-550014 add
                        #AND bmb03 = l_bmy.bmy05)         #CHI-DC0019 mark 
                         AND bmb03 = g_bmy[l_ac].bmy05)   #CHI-DC0019 Add
   END IF
 
   DECLARE i710_g_bmw_c CURSOR FOR
    SELECT bmt06,bmt07 FROM bmt_file
      WHERE bmt01=l_bmb.bmb01
        AND bmt02=l_bmb.bmb02
        AND bmt03=l_bmb.bmb03
        AND bmt04=l_bmb.bmb04
        AND bmt08=l_bmb.bmb29
      ORDER BY bmt06
 
   LET g_rec_t=1
 
   FOREACH i710_g_bmw_c INTO g_bmw[g_rec_t].*
     IF STATUS THEN CALL cl_err('for bmb:',STATUS,1) EXIT FOREACH END IF
     LET g_rec_t=g_rec_t+1
 
     IF g_rec_t > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
 
   END FOREACH
 
   LET g_rec_t=g_rec_t - 1
    CALL i710_t_i()   #No.MOD-490380
 
END FUNCTION
 
FUNCTION i710_t_fill()
 
   CALL g_bmw.clear()
 
    
   DECLARE i710_t_c CURSOR FOR
    SELECT bmw04,bmw05 FROM bmw_file
     WHERE bmw01=g_bmx.bmx01
       AND bmw02=g_bmy[l_ac].bmy02
     ORDER BY bmw04
 
   LET g_rec_t=1
 
   FOREACH i710_t_c INTO g_bmw[g_rec_t].*
 
     LET g_rec_t=g_rec_t+1
 
     IF g_rec_t > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
 
   END FOREACH
   CALL g_bmw.deleteElement(g_rec_t)
 
   LET g_rec_t=g_rec_t - 1
 
   CALL i710_t_cnt()
   
 
END FUNCTION
 
FUNCTION i710_e()
   DEFINE i	     LIKE type_file.num5      #No.FUN-680096 SMALLINT
   DEFINE l_bmf03    LIKE bmf_file.bmf03
   DEFINE ls_tmp     STRING
 
   LET p_row = 9 LET p_col = 48
   OPEN WINDOW i710_e_w AT p_row,p_col WITH FORM "abm/42f/abmi710e"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmi710e")
 
   IF STATUS THEN CALL cl_err('open win:',STATUS,1) RETURN END IF
 
   CALL i710_e_fill()
 
   LET g_success='Y'
   CALL i710_e_i()
 
   CLOSE WINDOW i710_e_w
 
END FUNCTION
 
FUNCTION i710_e_i()
   DEFINE l_n              LIKE type_file.num5      #No.FUN-680096 SMALLINT
   DEFINE i,s              LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          p_cmd            LIKE type_file.chr1,     #處理狀態 #MOD-470494    #No.FUN-680096 VARCHAR(1)
          l_allow_insert   LIKE type_file.num5,     #可新增否    #No.FUN-680096  SMALLINT
          l_allow_delete   LIKE type_file.num5      #可刪除否    #No.FUN-680096  SMALLINT
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   IF g_rec_e <> 0 THEN
        LET i = 1 #MOD-470494
   END IF
 
   INPUT ARRAY g_bmf WITHOUT DEFAULTS FROM s_bmf.*
          ATTRIBUTE(COUNT=g_rec_e,MAXCOUNT=g_max_rec,UNBUFFERED, #MOD-470494 將g_rec_b改成g_rec_e
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
              IF g_rec_e != 0 THEN         #MOD-470494
                 CALL fgl_set_arr_curr(i)
             END IF
 
          BEFORE ROW                       #MOD-470494
            LET p_cmd = ''
            LET i=ARR_CURR()
            IF g_rec_e >= i THEN
                LET p_cmd='u'
                LET g_bmf_t.* = g_bmf[i].*
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
         BEFORE INSERT                     #MOD-470494
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_bmf[i].* TO NULL      #900423
            LET g_bmf_t.* = g_bmf[i].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmf03
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
                CANCEL INSERT                      #MOD-470494
            END IF
            LET b_bmf.bmf01=g_bmx.bmx01
            LET b_bmf.bmf02=g_bmy[l_ac].bmy02
            LET b_bmf.bmf03=g_bmf[i].bmf03
            LET b_bmf.bmf04=g_bmf[i].bmf04
 
            LET b_bmf.bmfplant = g_plant 
            LET b_bmf.bmflegal = g_legal 
 
            IF cl_null(g_bmf_t.bmf03) THEN
               INSERT INTO bmf_file VALUES(b_bmf.*)
               IF SQLCA.SQLCODE OR STATUS THEN
                  CALL cl_err3("ins","bmf_file",b_bmf.bmf01,"",SQLCA.SQLCODE,"","ins bmf:",1)# TQC-660046
                  LET g_success='N'
                   CANCEL INSERT          #MOD-470494
               ELSE
                   LET g_rec_e=g_rec_e+1  #MOD-470494
                  MESSAGE 'Insert ok!'
               END IF
            END IF
 
         BEFORE FIELD  bmf03
            IF g_bmf[i].bmf03 IS NULL THEN
               SELECT MAX(bmf03) + 1
                 INTO g_bmf[i].bmf03
                 FROM bmf_file
                WHERE bmf01=g_bmx.bmx01
                  AND bmf02=g_bmy[l_ac].bmy02
               IF cl_null(g_bmf[i].bmf03) THEN LET g_bmf[i].bmf03=1 END IF
            END IF
 
         AFTER FIELD bmf03
            IF NOT cl_null(g_bmf[i].bmf03) THEN
               IF g_bmf[i].bmf03 != g_bmf_t.bmf03 OR cl_null(g_bmf_t.bmf03) THEN
                  SELECT COUNT(*) INTO g_cnt FROM bmf_file
                   WHERE bmf01 = g_bmx.bmx01
                     AND bmf02=g_bmy[l_ac].bmy02
                     AND bmf03 = g_bmf[i].bmf03
                  IF g_cnt > 0 THEN
                     CALL cl_err('',-239,0)
                     NEXT FIELD bmf03
                  END IF
               END IF
            END IF
 
         BEFORE DELETE
            IF g_bmf_t.bmf03 > 0 AND g_bmf_t.bmf03 IS NOT NULL THEN
               DELETE FROM bmf_file
                WHERE bmf01=g_bmx.bmx01
                  AND bmf02=g_bmy[l_ac].bmy02
                  AND bmf03=g_bmf[i].bmf03
               IF SQLCA.SQLCODE OR STATUS THEN
                  CALL cl_err3("del","bmf_file",g_bmx.bmx01,g_bmy[l_ac].bmy02,SQLCA.SQLCODE,"","del bmf: ",1) # TQC-660046              
                  CANCEL DELETE
               ELSE
                   LET g_rec_e=g_rec_e-1  #MOD-470494
                  MESSAGE 'Delete ok!'
               END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmf[i].* = g_bmf_t.*
               EXIT INPUT
            END IF
 
            LET b_bmf.bmf01=g_bmx.bmx01
            LET b_bmf.bmf02=g_bmy[l_ac].bmy02
            LET b_bmf.bmf03=g_bmf[i].bmf03
            LET b_bmf.bmf04=g_bmf[i].bmf04
            UPDATE bmf_file SET * = b_bmf.*
             WHERE bmf01=g_bmx.bmx01
               AND bmf02=g_bmy[l_ac].bmy02
               AND bmf03=g_bmf_t.bmf03
 
            IF SQLCA.SQLCODE OR STATUS THEN
               CALL cl_err3("upd","bmf_file",g_bmx.bmx01,g_bmf_t.bmf03,SQLCA.SQLCODE,"","upd bmf: ",1) # TQC-660046
                LET g_bmf[i].* = g_bmf_t.* #MOD-470494
               LET g_success='N'
            END IF
 
         AFTER ROW
             LET i = ARR_CURR()
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                 IF p_cmd = 'u' THEN           #MOD-470494
                    LET g_bmf[i].* = g_bmf_t.*
                END IF
                EXIT INPUT
             END IF
 
         AFTER INPUT
            IF INT_FLAG THEN
               LET INT_FLAG=0
               EXIT INPUT
            END IF
 
         ON ACTION get_orginal_data
 
            CALL i710_g_bmf()
            EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      LET g_success='N'
   END IF
 
END FUNCTION
 
FUNCTION i710_g_bmf()
   DEFINE l_bmy		RECORD LIKE bmy_file.*
   DEFINE l_bmb		RECORD LIKE bmb_file.*
   DEFINE l_bmt		RECORD LIKE bmt_file.*
 
   DELETE FROM bmf_file WHERE bmf01=g_bmx.bmx01 AND bmf02=g_bmy[l_ac].bmy02
   CALL g_bmf.clear()
 
   SELECT * INTO l_bmy.* FROM bmy_file
    WHERE bmy01 = g_bmx.bmx01
      AND bmy02 = g_bmy[l_ac].bmy02
 
   IF NOT cl_null(l_bmy.bmy04) THEN
      SELECT * INTO l_bmb.* FROM bmb_file
       WHERE bmb01 = g_bmz[1].bmz02
         AND bmb02 = l_bmy.bmy04
         AND bmb03 = l_bmy.bmy05
         AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                       WHERE bmb01 = g_bmz[1].bmz02
                         AND bmb02 = l_bmy.bmy04
                         AND bmb03 = l_bmy.bmy05)
   ELSE
      SELECT * INTO l_bmb.* FROM bmb_file
       WHERE bmb01 = g_bmz[1].bmz02
         AND bmb03 = l_bmy.bmy05
         AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                       WHERE bmb01 = g_bmz[1].bmz02
                         AND bmb03 = l_bmy.bmy05)
   END IF
 
   DECLARE i710_g_bmf_c CURSOR FOR
    SELECT bmc04,bmc05 FROM bmc_file
      WHERE bmc01 = l_bmb.bmb01
        AND bmc02 = l_bmb.bmb02
        AND bmc021= l_bmb.bmb03
        AND bmc03 = l_bmb.bmb04
      ORDER BY bmc04
 
   LET g_rec_e=1
   FOREACH i710_g_bmf_c INTO g_bmf[g_rec_e].*
     IF STATUS THEN
        CALL cl_err('for bmb:',STATUS,1)
        EXIT FOREACH
     END IF
 

 
     LET b_bmf.bmf01=g_bmx.bmx01
     LET b_bmf.bmf02=g_bmy[l_ac].bmy02
 
     SELECT MAX(bmf03) + 1 INTO b_bmf.bmf03 FROM bmf_file
      WHERE bmf01=g_bmx.bmx01 AND bmf02=g_bmy[l_ac].bmy02
     IF cl_null(b_bmf.bmf03) THEN LET b_bmf.bmf03=1 END IF
 
     LET b_bmf.bmf04=g_bmf[g_rec_e].bmf04
 
     LET b_bmf.bmfplant = g_plant 
     LET b_bmf.bmflegal = g_legal 
 
     INSERT INTO bmf_file VALUES(b_bmf.*)
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err3("ins","bmf_file",b_bmf.bmf01,b_bmf.bmf02,SQLCA.SQLCODE,"","ins bmf: ",1) # TQC-660046
        LET g_success='N'
        EXIT FOREACH
     END IF
 
      LET g_rec_e=g_rec_e+1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
   LET g_rec_e=g_rec_e - 1
   CALL i710_e_fill()
 
END FUNCTION
 
FUNCTION i710_e_fill()
   CALL g_bmf.clear()
 
   DECLARE i710_e_c CURSOR FOR
        SELECT bmf03,bmf04 FROM bmf_file
         WHERE bmf01=g_bmx.bmx01 AND bmf02=g_bmy[l_ac].bmy02
         ORDER BY bmf03
 
   LET g_rec_e=1
   FOREACH i710_e_c INTO g_bmf[g_rec_e].*
     LET g_rec_e=g_rec_e+1
 
     IF g_rec_e > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
 
   END FOREACH
   CALL g_bmf.deleteElement(g_rec_e)
   LET g_rec_e=g_rec_e - 1
 
END FUNCTION
 
#FUNCTION i710_x()       #CHI-D20010
FUNCTION i710_x(p_type)  #CHI-D20010
DEFINE l_flag LIKE type_file.chr1  #CHI-D20010
DEFINE p_type LIKE type_file.chr1  #CHI-D20010
DEFINE l_cnt  LIKE type_file.num5  #FUN-D70103 add

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_bmx.bmx01) THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_bmx.bmx09 MATCHES '[Ss1]' THEN      #FUN-540045 #FUN-550040
      CALL cl_err('','mfg3557',0)
      RETURN
   END IF
    IF NOT s_dc_ud_flag('3',g_bmx.bmx11,g_plant,'u') THEN                                                                           
       CALL cl_err(g_bmx.bmx11,'aoo-045',1)                                                                                         
       RETURN                                                                                                                       
    END IF                                                                                                                          
   IF g_bmx.bmx04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
 
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_bmx.bmx04 ='X' THEN RETURN END IF
   ELSE
      IF g_bmx.bmx04 <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN i710_cl USING g_bmx.bmx01
   IF STATUS THEN
      CALL cl_err("OPEN i710_cl:", STATUS, 1)
      CLOSE i710_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i710_cl INTO g_bmx.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bmx.bmx01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i710_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_bmx.bmx04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_bmx.bmx04 = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010 

   #FUN-D40032--add--str--
   IF g_bmx.bmx04='X' AND NOT cl_null(g_sma.sma53) AND g_bmx.bmx07 <= g_sma.sma53 THEN
      CALL cl_err('','alm1393',0)
      RETURN
   END IF
   #FUN-D40032--add--end--

   #FUN-D70103-Start-Add
   #主件料號(bmz02)BOM是否已發放,若未發放,不允許"取消作廢"
    IF g_bmx.bmx04='X' THEN
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt 
         FROM bma_file
        WHERE bma01 = g_bmz[l_ac].bmz02
          AND bma10 = '1'
       IF l_cnt >0 AND l_cnt IS NOT NULL THEN
          CALL cl_err(g_bmz[l_ac].bmz02,'abm1106', 1)
          RETURN
       END IF   
    END IF
   #FUN-D70103-End-Add
   
  # Prog. Version..: '5.30.24-17.04.13(0,0,g_bmx.bmx04) THEN   #CHI-D20010
   IF cl_void(0,0,l_flag) THEN        #CHI-D20010
      LET g_chr=g_bmx.bmx04
     #IF g_bmx.bmx04 ='N' THEN     #CHI-D20010
      IF p_type = 1 THEN  #CHI-D20010
          LET g_bmx.bmx04='X'
          LET g_bmx.bmx09='9'  #--FUN-540045
      ELSE
          LET g_bmx.bmx04='N'
          LET g_bmx.bmx09='0'  #--FUN-540045
      END IF
      LET g_bmx.bmxmodu = g_user
      LET g_bmx.bmxdate = g_today
      UPDATE bmx_file
          SET bmx04=g_bmx.bmx04,   #--FUN-540045
              bmx09=g_bmx.bmx09,   #--FUN-540045
              bmxmodu=g_user,
              bmxdate=g_today
          WHERE bmx01  =g_bmx.bmx01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","bmx_file",g_bmx.bmx01,"",SQLCA.sqlcode,"","",1) # TQC-660046
          LET g_bmx.bmx04=g_chr
      END IF
      DISPLAY BY NAME g_bmx.bmx04,g_bmx.bmx09,g_bmx.bmxmodu,g_bmx.bmxdate   #--FUN-540045
        #CALL i710_list_fill()     #CHI-EA0052 mark                                                                                                  
   END IF
 
   CLOSE i710_cl
   COMMIT WORK
   CALL cl_flow_notify(g_bmx.bmx01,'V')
 
END FUNCTION
 
FUNCTION i710_up_bmy13()
 DEFINE l_bmw04   LIKE bmw_file.bmw04,
        l_bmy13   LIKE bmy_file.bmy13,
        l_i       LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
    LET l_bmy13=' '
    LET l_i = 0
 
    DECLARE up_bmy13_cs CURSOR FOR
     SELECT bmw04 FROM bmw_file
      WHERE bmw01=g_bmx.bmx01
        AND bmw02=g_bmy[l_ac].bmy02
 
    FOREACH up_bmy13_cs INTO l_bmw04
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        IF l_i = 0 THEN
           LET l_bmy13=l_bmw04
        ELSE
           LET l_bmy13= l_bmy13 CLIPPED , ',', l_bmw04
        END IF
        LET l_i = l_i + 1
 
    END FOREACH
 
    LET b_bmy.bmy13 = l_bmy13
 
END FUNCTION
 
FUNCTION i710_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
    CALL cl_set_comp_entry("bmy30",TRUE) #FUN-550014 add
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("bmy16,bmy06,bmy07,bmy27,bmy34",TRUE)  #no.MOD-840478 mod
        CALL cl_set_comp_required("bmy27,bmy06,bmy07",FALSE)  #MOD-4A0046 #CHI-930005
    END IF
 
    IF INFIELD(bmy03) THEN
       CALL cl_set_comp_entry("bmy16,bmy06,bmy07,bmy27,bmy34",TRUE)   #No.MOD-6C0019 modify  #MOD-840645 modify
        CALL cl_set_comp_required("bmy27,bmy06,bmy07",FALSE) #MOD-4A0046  #CHI-930005
    END IF
    CALL cl_set_comp_entry("bmy16,bmy27,bmy35,bmy06,bmy07,bmy34",TRUE)   #CHI-960004 #TQC-C80066--add bmy35,bmy06,bmy07,bmy34
 
END FUNCTION
 
FUNCTION i710_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
    IF g_sma.sma114 != 'Y' THEN
        CALL cl_set_comp_entry("bmy30",FALSE) #FUN-550014 add
    END IF
 
    IF INFIELD(bmy03) OR ( NOT g_before_input_done ) THEN    #TQC-C80066 add ( NOT g_before_input_done )
       IF l_ac>0 THEN                                      #TQC-C80066--add
          IF g_bmy[l_ac].bmy03 ='1' THEN
            CALL cl_set_comp_entry("bmy06,bmy07,bmy27,bmy34,bmy16,bmy35,bmy30",FALSE)  #no.MOD-840478 mod #CHI-960004 mod  #TQC-C80066 add bmy16,bmy35,bmy30 
         #FUN-F50035 add str----
            CALL cl_set_comp_entry("vlr13,vlr16,vlr17,vlr18,vls11",FALSE) 
          ELSE                                                            
            CALL cl_set_comp_entry("vlr13,vlr16,vlr17,vlr18",TRUE)        
            IF g_bmy[l_ac].bmy03 MATCHES '[456]' THEN
              CALL cl_set_comp_entry("vls11",TRUE)        
            ELSE
              CALL cl_set_comp_entry("vls11",FALSE)        
            END IF
          END IF
         #FUN-F50035 add str----
          IF g_bmy[l_ac].bmy03 MATCHES '[23]' THEN
             CALL cl_set_comp_entry("bmy27",FALSE)  
          END IF
          IF g_bmy[l_ac].bmy03 MATCHES '[456]' THEN  #CHI-C20060
            #CALL cl_set_comp_required("bmy27,bmy06,bmy07",TRUE)  #CHI-930005  #CHI-A30011 mark 
             CALL cl_set_comp_required("bmy27",TRUE)  #CHI-930005              #CHI-A30011  
          END IF

         IF g_bmy[l_ac].bmy03 MATCHES '[3]' THEN
            CALL cl_set_comp_required("bmy06,bmy34,",FALSE)       #CHI-960004 mod
         END IF
       END IF                                                      #TQC-C80066--add
    END IF
    IF NOT cl_null(g_bmy[l_ac].bmy03) THEN
      #MOD-AC0029---mark---start---
      #IF g_bmy[l_ac].bmy03 = '4' THEN
      #   CALL cl_set_comp_entry("bmy16",FALSE)
      #   LET g_bmy[l_ac].bmy16 = '1'
      #END IF 
      #MOD-AC0029---mark---end---
       IF g_bmy[l_ac].bmy03 MATCHES '[456]' THEN  #CHI-C20060
          CALL cl_set_comp_required("bmy27",TRUE)  
          CALL cl_set_comp_entry("vls11",TRUE)    #FUN-F50035 add
       ELSE
          CALL cl_set_comp_required("bmy27",FALSE)  
          CALL cl_set_comp_entry("bmy27,vls11",FALSE)   #FUN-F50035 add vls11
       END IF
      #CHI-C20060---begin
       IF g_bmy[l_ac].bmy03 = '6' THEN
          CALL cl_set_comp_entry("bmy16,bmy35,bmy30",FALSE)
          CALL cl_set_comp_required("bmy06,bmy07",TRUE)
          CALL cl_set_comp_entry("bmy36",TRUE)                         #CHI-DC0015 add
       ELSE
          CALL cl_set_comp_entry("bmy16,bmy35,bmy30",TRUE)
          CALL cl_set_comp_required("bmy06,bmy07",FALSE)
          CALL cl_set_comp_entry("bmy36",FALSE)                        #CHI-DC0015 add
       END IF  
      #CHI-C20060---end
      #-----------------CHI-DC0015------------------(S)
       IF l_ac > 0 THEN
          IF cl_null(g_bmy[l_ac].bmy36) THEN
             CALL cl_set_comp_entry("bmy06,bmy07",TRUE)
          ELSE
             CALL cl_set_comp_entry("bmy06,bmy07",FALSE)
          END IF
       END IF
      #-----------------CHI-DC0015------------------(E)
      IF s_industry('slk') AND g_sma.sma150 = 'Y' THEN#bmy38應在服飾業狀況下 #MOD-E30159 add
      #FUN-D80022--add--str--
         IF g_bmy[l_ac].bmy03 MATCHES '[3]' THEN
            CALL cl_set_comp_required("bmy38",FALSE)
         END IF
         IF g_bmy[l_ac].bmy03 MATCHES '[2]' THEN
            CALL cl_set_comp_required("bmy38",TRUE)
         END IF
       END IF                                                             #MOD-E30159 add
       IF s_industry('slk') AND g_sma.sma150 = 'Y' THEN
          IF g_bmy[l_ac].bmy03 MATCHES '[23]' THEN 
             CALL cl_set_comp_entry("bmy38",TRUE)
          ELSE 
             CALL cl_set_comp_entry("bmy38",FALSE)
          END IF
       END IF 
      #FUN-D80022--add--end--
    END IF
    ##----- 20201208 add by momo (S)
    IF g_bmy[l_ac].bmy03 MATCHES '[14]' THEN
       CALL cl_set_comp_entry("bmy38",TRUE)
    ELSE
       CALL cl_set_comp_entry("bmy38",FALSE)
       LET g_bmy[l_ac].bmy38='N'
    END IF
    ##----- 20201208 add by momo (E)
 
END FUNCTION
FUNCTION i710_d_i_set_entry()
    CALL cl_set_comp_entry("bmz05",TRUE)
END FUNCTION
FUNCTION i710_d_i_set_no_entry()
    IF g_sma.sma118 != 'Y' THEN
        CALL cl_set_comp_entry("bmz05",FALSE)
    END IF
END FUNCTION
 
FUNCTION i710_ef()
   DEFINE l_cnt    LIKE type_file.num5                    #20240809 
  
     CALL cs_check_ecn(g_bmx.bmx01)                                   #20241108 add
     CALL i710_y_chk()           #CALL 原確認的 check 段   #FUN-580120
     IF g_success = "N" THEN
         RETURN
     END IF
 
     CALL aws_condition()      #判斷送簽資料
     IF g_success = 'N' THEN
         RETURN
     END IF
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
 
#IF aws_efcli2(base.TypeInfo.create(g_bmx),base.TypeInfo.create(g_bmz),base.TypeInfo.create(g_bmy),'','','')   #20240816 mark
 IF aws_efcli2(base.TypeInfo.create(g_bmx),'','','','','')                                                     #20240816 modify
 THEN
   LET g_success='Y'
  #LET g_bmx.bmx09='S' #FUN-F10019 mark
  #FUN-F10019 add(S)
  #重新更新狀態碼顯示
   SELECT bmx09 INTO g_bmx.bmx09 FROM bmx_file WHERE bmx01 = g_bmx.bmx01
  #FUN-F10019 add(E)
   DISPLAY BY NAME g_bmx.bmx09
 ELSE
   LET g_success='N'
 END IF
 
END FUNCTION
FUNCTION i710_field_pic()
     LET g_void=NULL
     LET g_approve=NULL
     LET g_confirm=NULL
     IF g_bmx.bmx04 MATCHES '[Yy]' THEN
        IF g_bmx.bmx09 MATCHES '[SsRrWw]' THEN
           LET g_confirm='Y'
           LET g_approve='N'
           LET g_void='N'
        END IF
        IF g_bmx.bmx09 MATCHES '[1]' THEN
           LET g_confirm='Y'
           LET g_approve='Y'
           LET g_void='N'
        END IF
     ELSE
        IF g_bmx.bmx04 ='X' THEN
           IF g_bmx.bmx09 MATCHES '[9]' THEN
              LET g_confirm='N'
              LET g_approve='N'
              LET g_void='Y'
           END IF
        ELSE
           LET g_confirm='N'
           LET g_approve='N'
           LET g_void='N'
        END IF
     END IF
     #TQC-B40175--begin
     IF g_bmx.bmx09 MATCHES '[1]' THEN 
        LET g_approve='Y'
     END IF 
     #TQC-B40175--end
     IF g_argv3 <> 'abmp701' OR cl_null(g_argv3) THEN    #NO.FUN-840033 add   #MOD-980076  #CHI-CA0035 mod g_argv2->g_argv3
         CALL cl_set_field_pic(g_confirm,g_approve,"","",g_void,"g_bmx.bmxacti")
     END IF                          #NO.FUN-840033 add
 
END FUNCTION
 
#變異別為0,1,3須check all 元件是否屬於該主件
FUNCTION i710_chk_bmz02(p_bmz02)
   DEFINE p_bmz02  LIKE bmz_file.bmz02
   DEFINE l_cnt    LIKE type_file.num10    #No.FUN-680096  INTEGER
   DEFINE l_bmy04  LIKE bmy_file.bmy04
   DEFINE l_bmy05  LIKE bmy_file.bmy05
   DEFINE l_result LIKE type_file.num5     #No.FUN-680096  SMALLINT
 
   LET l_result=TRUE
   DECLARE i710_chk_bmz02_cur CURSOR FOR
      SELECT bmy04,bmy05 FROM bmy_file WHERE bmy01=g_bmx.bmx01
      AND bmy03<>'2' ORDER BY bmy02
   FOREACH i710_chk_bmz02_cur INTO l_bmy04,l_bmy05
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(l_bmy05) THEN EXIT FOREACH END IF
      LET l_cnt=0
      IF l_bmy04 IS NOT NULL THEN
         SELECT COUNT(*) INTO l_cnt FROM bmb_file
          WHERE bmb01= p_bmz02 AND bmb02 = l_bmy04
            AND bmb03=l_bmy05
            AND (bmb04 <=g_bmx.bmx07 OR bmb04 IS NULL)
            AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL)
      ELSE
         SELECT COUNT(*) INTO l_cnt FROM bmb_file
          WHERE bmb01 = p_bmz02
            AND bmb03 = l_bmy05
            AND (bmb04 <=g_bmx.bmx07 OR bmb04 IS NULL)
            AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL)
      END IF
      IF l_cnt=0 THEN
         LET l_result=FALSE
         EXIT FOREACH
      END IF
   END FOREACH
   RETURN l_result
END FUNCTION
FUNCTION i710_bmx10(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,     #No:7381
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381
      FROM gen_file
     WHERE gen01 = g_bmx.bmx10
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #No.CHI-9C0054 ---start---
    IF p_cmd != 'd' THEN       
       IF cl_null(g_bmx.bmx13) THEN 
          LET g_bmx.bmx13 = l_gen03     
       END IF                           
    END IF            
    #No.CHI-9C0054 ---end---   
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION

#No.CHI-9C0054 ---start---
FUNCTION i710_bmx13(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_gem02      LIKE gem_file.gem02
   DEFINE l_gemacti    LIKE gem_file.gemacti
   LET g_errno = ' '
   SELECT gem02,gemacti INTO l_gem02,l_gemacti
     FROM gem_file
    WHERE gem01 = g_bmx.bmx13
   CASE 
      WHEN SQLCA.sqlcode = 100  LET g_errno = 'aap-039'
                                LET l_gem02 = NULL
                                LET l_gemacti = NULL           
      WHEN l_gemacti = 'N'  LET g_errno = '9028'
      OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION
#No.CHI-9C0054 ---end---

##--- 20230208 add by momo (S)---
FUNCTION i710_ta_bmx03(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_azf03     LIKE azf_file.azf03
   DEFINE l_azfacti   LIKE azf_file.azfacti

   LET g_errno = ' '
   SELECT azf03,azfacti INTO l_azf03,l_azfacti
     FROM azf_file
    WHERE azf01 = g_bmx.ta_bmx03
      AND azf09 = 'G'

   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aoo-018'
                               LET l_azf03 = NULL
                               LET l_azfacti = NULL
      WHEN l_azfacti = 'N' LET g_errno = '9028'
      OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azf03 TO FORMONLY.azf03
   ELSE
      DISPLAY '' TO FORMONLY.azf03
   END IF

END FUNCTION
##--- 20230208 add by momo (E)---
 
FUNCTION i710_carry()                                                                                                               
   DEFINE l_i       LIKE type_file.num10                                                                                            
   DEFINE l_j       LIKE type_file.num10 
   DEFINE #l_sql     LIKE type_file.chr1000
          l_sql     STRING     #NO.FUN-910082
   DEFINE l_gew03   LIKE gew_file.gew03  #FUN-950057 
       
   IF cl_null(g_bmx.bmx01) THEN 
      CALL cl_err('',-400,0)
      RETURN 
   END IF                                                                                    
   IF g_bmx.bmx04 <> 'Y' THEN                                                                                                     
      CALL cl_err(g_bmx.bmx01,'aoo-092',3)                                                                                          
      RETURN                                                                                                                        
   END IF             
                                                                                                                       
   LET g_gev04 = NULL                           
 
   #是否為資料中心的拋轉DB                                                                                                  
   SELECT gev04 INTO g_gev04 FROM gev_file                                                                                  
    WHERE gev01 = '3' AND gev02 = g_plant                                                                                   
      AND gev03 = 'Y'                                                                                                       
   IF SQLCA.sqlcode THEN                                                                                                    
      CALL cl_err(g_gev04,'aoo-036',1)                                                                                      
      RETURN                                                                                                                
   END IF
                                                                                    
                                                                                                                    
   IF cl_null(g_gev04) THEN RETURN END IF                                                                                           
                                                                                                                                    
#FUN-950057 -------------------------add start----------------------
   SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file                               
    WHERE gew01 = g_gev04 AND gew02 = '3'                                       
   IF NOT cl_null(l_gew03) THEN                                                 
      IF l_gew03 = '2' THEN                                                     
          IF NOT cl_confirm('anm-929') THEN RETURN END IF  #询问是否执行抛转    
      END IF    
#FUN-950057 -------------------------add end------------------------                                                                                                      
 
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
   IF g_success='Y' THEN CALL cl_err('','aim-162',1) END IF  #TQC-AC0161
 
 END IF        #FUN-950057 	add
                                                                                                                                    
END FUNCTION                                                                                                                        
 
FUNCTION i710_download()                                                                                                            
  DEFINE l_path       LIKE ze_file.ze03                                                                                             
  DEFINE l_i          LIKE type_file.num10                                                                                          
  DEFINE l_j          LIKE type_file.num10                                                                                          
                                                  
   IF cl_null(g_bmx.bmx01) THEN 
      CALL cl_err('',-400,0)
      RETURN 
   END IF                                                                                  
   CALL g_bmxx.clear()                                                                                                              
   FOR l_i = 1 TO g_bmx_l.getLength()                                                                                               
       LET g_bmxx[l_i].sel   = 'Y'                                                                                                  
       LET g_bmxx[l_i].bmx01 = g_bmx_l[l_i].bmx01                                                                               
   END FOR                                                                                                                          
   CALL s_abmi710_download(g_bmxx)                                                                                                                            
                                                                                                                                    
END FUNCTION
                                                                                                                                                                                                                  
FUNCTION i710_chkinsitm()
 DEFINE l_count LIKE type_file.num5 ,
        l_sql   STRING   
 DEFINE l_count_bmy LIKE type_file.num5 
 DEFINE i       LIKE type_file.num5
 DEFINE l_flag  LIKE type_file.chr1  
 
  #IF (g_bmy[l_ac].bmy05 IS NULL) OR (g_bmz[l_ac].bmz02 IS NULL) THEN #MOD-F20085 mark
   IF (g_bmy[l_ac].bmy05 IS NULL) THEN                                #MOD-F20085 add
      RETURN TRUE
   END IF
 
   #避免若修改狀態,僅修改了項次,也會造成 err msg,所以加入此判斷
  #MOD-F20085--mark---str---
  #IF (g_bmy[l_ac].bmy05=g_bmy_t.bmy05) AND
  #   (g_bmz[l_ac].bmz02=g_bmz_t.bmz02) THEN
  #   RETURN TRUE
  #END IF
  #MOD-F20085--mark---end---
   #-----CHI-C10034 str add -------
   #--同一張ECN單身不允許多筆相同 元件 ---
   IF cl_null(g_bmy[l_ac].bmy04) THEN
      LET l_sql="SELECT COUNT(*) FROM bmy_file ",
                " WHERE bmy05='",g_bmy[l_ac].bmy05,
                "'  AND bmy01='",g_bmx.bmx01,
                "'  AND bmy02<>",g_bmy[l_ac].bmy02
   ELSE
      LET l_sql="SELECT COUNT(*) FROM bmy_file WHERE ",
                " WHERE bmy05='",g_bmy[l_ac].bmy05,
                "'  AND bmy04=",g_bmy[l_ac].bmy04,
                "'  AND bmy01='",g_bmx.bmx01,
                "' AND bmy02<>",g_bmy[l_ac].bmy02
   END IF
   PREPARE i710_chkinsitm_sql FROM l_sql
   DECLARE i710_chkinsitm_cur CURSOR FOR i710_chkinsitm_sql
   OPEN i710_chkinsitm_cur
   FETCH i710_chkinsitm_cur INTO l_count
   CLOSE i710_chkinsitm_cur
   #-----CHI-C10034 end add -------
 
   #--不同張ECN不允許相同 主件+元件 ---
   IF cl_null(g_bmy[l_ac].bmy04) THEN 
       LET l_sql="SELECT COUNT(*) FROM bmz_file,bmx_file,bmy_file ",
                 " WHERE bmx01 = bmy01 ",
                 "   AND bmx01 = bmz01 ",
                 "   AND bmx01 <> '",g_bmx.bmx01,"'",       #單號
                 "   AND bmz02= ? ",   #主件編號
                 "   AND bmy05='",g_bmy[l_ac].bmy05,"'",    #元件編號
                 "   AND bmx07 <= '",g_bmx.bmx07,"'",       #生效日
                 "   AND bmx04 = 'N'"                       #確認碼 
                #,"   AND bmy02 <>",g_bmy_t.bmy02," "      #FUN-D80022 add
   ELSE
       LET l_sql="SELECT COUNT(*) FROM bmz_file,bmx_file,bmy_file ",
                 " WHERE bmx01 = bmy01 ",
                 "   AND bmx01 = bmz01 ",
                 "   AND bmx01 <> '",g_bmx.bmx01,"'",       #單號
                 "   AND bmz02= ? ",   #主件編號
                 "   AND bmy05='",g_bmy[l_ac].bmy05,"'",    #元件編號
                 "   AND bmy04='",g_bmy[l_ac].bmy04,"'",    #BOM項次  #TQC-8C0042
                 "   AND bmx07 <= '",g_bmx.bmx07,"'",       #生效日
                 "   AND bmx04 = 'N'"                       #確認碼 
                #,"   AND bmy02 <>",g_bmy_t.bmy02," "      #FUN-D80022 add
   END IF
 
   PREPARE i710_chkinsitm_1 FROM l_sql
   DECLARE i710_chkinsitm_cur1 CURSOR FOR i710_chkinsitm_1
   LET l_flag= 'N'
   FOR i = 1 TO g_bmz.getLength()
      OPEN i710_chkinsitm_cur1 USING g_bmz[i].bmz02
      FETCH i710_chkinsitm_cur1 INTO l_count_bmy
      CLOSE i710_chkinsitm_cur1
      CASE
          WHEN l_count_bmy > 0 
              CALL cl_err('chk ins itm','abm-821',0)
              LET l_flag = 'Y'
              RETURN FALSE
              EXIT FOR
          #-----CHI-C10034 str add-----
          WHEN l_count > 0
              CALL cl_err('chk ins itm','abm-806',0)
              LET l_flag = 'Y'
              RETURN FALSE
              EXIT FOR
          #-----CHI-C10034 end add-----
          OTHERWISE
              CONTINUE FOR
              LET l_flag = 'N'
      END CASE
   END FOR
   IF l_flag= 'N' THEN 
       RETURN TRUE
   END IF
 
END FUNCTION
 
#確認時檢查單據中所有的主件+元件是否有未確認的單據存在資料庫且生效日在本張單據之前
FUNCTION i710_y_chk_bmy()  
DEFINE i,j      LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_sql    STRING
DEFINE l_bmy02  LIKE bmy_file.bmy02
DEFINE l_boa01  LIKE boa_file.boa01 #20241220
DEFINE l_boa03  LIKE boa_file.boa03 #20241220
 
   LET l_flag= 'N'
   FOR i = 1 TO g_bmz.getLength()
       FOR j=1 TO g_bmy.getLength()
           IF cl_null(g_bmy[l_ac].bmy04) THEN 
 
               LET l_sql="SELECT COUNT(*) FROM bmz_file,bmx_file,bmy_file ",
                         " WHERE bmx01 = bmy01 ",
                         "   AND bmx01 = bmz01 ",
                         "   AND bmx01 <> '",g_bmx.bmx01,"'",       #單號
                         "   AND bmz02= '",g_bmz[i].bmz02,"'",   #主件編號
                         "   AND bmy05='",g_bmy[j].bmy05,"'",        #元件編號
                         "   AND bmx07 < '",g_bmx.bmx07,"'",       #生效日
                         "   AND bmx04 = 'N'"                       #確認碼 
           ELSE
               LET l_sql="SELECT COUNT(*) FROM bmz_file,bmx_file,bmy_file ",
                         " WHERE bmx01 = bmy01 ",
                         "   AND bmx01 = bmz01 ",
                         "   AND bmx01 <> '",g_bmx.bmx01,"'",       #單號
                         "   AND bmz02= '",g_bmz[i].bmz02,"'",   #主件編號
                         "   AND bmy05='",g_bmy[j].bmy05,"'",        #元件編號
                         "   AND bmy04=",g_bmy[j].bmy04,"'",     #BOM項次
                         "   AND bmx07 < '",g_bmx.bmx07,"'",       #生效日
                         "   AND bmx04 = 'N'"                       #確認碼 
           END IF
 
           PREPARE i710_chk_bmy_p FROM l_sql
           DECLARE i710_chk_bmy_c CURSOR FOR i710_chk_bmy_p
           LET l_flag= 'N'
           OPEN i710_chk_bmy_c
           FETCH i710_chk_bmy_c INTO l_count
           CLOSE i710_chk_bmy_c
           CASE
               WHEN l_count > 0 
                   LET g_showmsg = g_bmz[i].bmz02,'/',g_bmy[j].bmy05                    
                   CALL s_errmsg('bmz02,bmy05','',g_showmsg,'abm-821',1)
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
    END FOR

    ##---- 20190123 add by momo(S) 組成用量與底數空值檢核
    LET l_sql = "SELECT bmy02,COUNT(*) FROM bmx_file,bmy_file, ",
              "                             ima_file a,ima_file b ",
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
   ##---- 20190123 add by momo(E)
  
   ##--- 20241220 add by momo (S)存在有效群組取替代
   LET l_sql = " SELECT distinct boa01,boa03 FROM bmz_file,bmy_file,boa_file ", 
               "  WHERE bmz01 = '",g_bmx.bmx01,"'",     #單號
               "    AND bmz01 = bmy01 ",
               "    AND boa01 = bmz02 AND boa03 = bmy05 ",
               "    AND  (boa07 IS NULL OR boa07 > g_today) "

   PREPARE i710_sel_boa_p1 FROM l_sql
   DECLARE i710_sel_boa_c1 CURSOR FOR i710_sel_boa_p1
   FOREACH i710_sel_boa_c1 INTO l_boa01,l_boa03
      LET g_showmsg = l_boa01,'/',l_boa03                
      CALL s_errmsg('bmy02',g_showmsg,'','cbm-003',1)
      LET g_success = 'N'
      EXIT FOREACH
   END FOREACH
   ##--- 20241220 add by momo (E)
END FUNCTION
#No:FUN-9C0077

#MOD-E10080--begin
#確認時檢查單據中所有的主件+元件是否有確認的單據存在資料庫且生效日在本張單據之前或同時
FUNCTION i710_y_chk_bmy3()
DEFINE i,j      LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_sql    STRING

   LET l_flag= 'N'
   FOR i = 1 TO g_bmz.getLength()
       FOR j=1 TO g_bmy.getLength()
           IF cl_null(g_bmy[l_ac].bmy04) THEN

               LET l_sql="SELECT COUNT(*) FROM bmx_file,bmy_file ",
                         " WHERE bmx01 = bmy01 ",
                         "   AND bmx01 <> '",g_bmx.bmx01,"'",       #單號
                         "   AND bmy14= '",g_bmz[i].bmz02,"'",   #主件編號
                         "   AND bmy05='",g_bmy[j].bmy05,"'",        #元件編號
                         "   AND bmx07 <= '",g_bmx.bmx07,"'",       #生效日
                         "   AND bmx04 = 'Y'"                       #確認碼
           ELSE
               LET l_sql="SELECT COUNT(*) FROM bmx_file,bmy_file ",
                         " WHERE bmx01 = bmy01 ",
                         "   AND bmx01 <> '",g_bmx.bmx01,"'",       #單號
                         "   AND bmy14= '",g_bmz[i].bmz02,"'",   #主件編號
                         "   AND bmy05='",g_bmy[j].bmy05,"'",        #元件編號
                         "   AND bmy04=",g_bmy[j].bmy04,"'",     #BOM項次
                         "   AND bmx07 <= '",g_bmx.bmx07,"'",       #生效日
                         "   AND bmx04 = 'Y'"                       #確認碼
           END IF

           PREPARE i710_chk_bmy_p1 FROM l_sql
           DECLARE i710_chk_bmy_c1 CURSOR FOR i710_chk_bmy_p1
           LET l_flag= 'N'
           OPEN i710_chk_bmy_c1
           FETCH i710_chk_bmy_c1 INTO l_count
           CLOSE i710_chk_bmy_c1
           CASE
               WHEN l_count > 0
                   LET g_showmsg = g_bmz[i].bmz02,'/',g_bmy[j].bmy05
                   CALL s_errmsg('bmz02,bmy05','',g_showmsg,'abm-822',1)
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
    END FOR
END FUNCTION
#MOD-E10080--end
#FUN-B30171--begin
FUNCTION i710_insbmz()
DEFINE   tok              base.StringTokenizer
DEFINE   l_bmz            RECORD LIKE bmz_file.*
DEFINE   l_bmr07          LIKE bmr_file.bmr07 
DEFINE   l_n1             LIKE type_file.num5
DEFINE   l_bma05          LIKE bma_file.bma05 
DEFINE   l_chkinsitm      LIKE type_file.num5
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_bmz02,"|")
        
   WHILE tok.hasMoreTokens()
    LET l_bmz.bmz02 = tok.nextToken()
           IF NOT s_chk_item_no(l_bmz.bmz02,'') THEN
              CALL s_errmsg('bmz02',l_bmz.bmz02,'INS bmz_file',g_errno,1)
              CONTINUE WHILE 
           END IF                                 
           CALL s_field_chk(l_bmz.bmz02,'3',g_plant,'bmz02') RETURNING g_flag2                                                           
           IF g_flag2 = '0' THEN                                              
              CALL s_errmsg('bmz02',l_bmz.bmz02,'INS bmz_file','aoo-043',1)                                                                                  
              CONTINUE WHILE 
           END IF
           IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
              IF g_sma.sma542='Y' THEN 
                 SELECT COUNT(*) INTO l_n1 FROM bra_file WHERE bra01=l_bmz.bmz02 
                 IF l_n1>0 THEN 
                    CALL s_errmsg('bmz02',l_bmz.bmz02,'INS bmz_file','abm-225',1) 
                    CONTINUE WHILE
                 END IF 
              END IF 
           END IF  
         #CHI-D10013-start----mark  
         #  IF NOT cl_null(g_bmx.bmx05) THEN        
         #     SELECT bmr07 INTO l_bmr07 FROM bmr_file
         #                              WHERE bmr01=g_bmx.bmx05
         #                                AND bmrconf = 'Y' 
         #     IF l_bmz.bmz02<>l_bmr07 THEN
         #        CALL s_errmsg('bmz02',l_bmz.bmz02,'INS bmz_file','abm-024',1) 
         #        CONTINUE WHILE
         #     END IF
         #END IF
         #CHI-D10013-end---mark                                   
           SELECT ima05 INTO l_bmz.bmz04
             FROM ima_file
            WHERE ima01=l_bmz.bmz02
           IF STATUS THEN 
              CALL s_errmsg('bmz02',l_bmz.bmz02,'INS bmz_file',STATUS,1)          
              CONTINUE WHILE
           ELSE
              SELECT COUNT(*) INTO g_cnt FROM bma_file
                 WHERE bma01=l_bmz.bmz02 AND bmaacti='Y'
                 IF g_cnt =0 THEN
                    CALL s_errmsg('bmz02',l_bmz.bmz02,'INS bmz_file','abm-742',1)  
                    CONTINUE WHILE
                 END IF
              SELECT COUNT(*) INTO g_cnt FROM bma_file
               WHERE bma01=l_bmz.bmz02
                 AND bmaacti='Y'
                 AND bma10 = '2'
              IF g_cnt =0 THEN
              #  CALL s_errmsg('bmz02',l_bmz.bmz02,'INS bmz_file','abm-038',1)   #TQC-C60179  mark
                 CALL s_errmsg('bmz02',l_bmz.bmz02,'INS bmz_file','abm-096',1)   #TQC-C60179 
                 CONTINUE WHILE
              END IF
           END IF
           IF NOT i710_chk_bmz02(l_bmz.bmz02) THEN 
               CALL s_errmsg('bmz02',l_bmz.bmz02,'INS bmz_file','abm-710',1)  
               CONTINUE WHILE
           END IF
           LET g_cnt = 0                                                                                                        
           SELECT COUNT(*) INTO g_cnt FROM bma_file                                                                             
            WHERE bma01=l_bmz.bmz02                                                                                       
           IF g_cnt=0 THEN                                                 
              CALL s_errmsg('bmz02',l_bmz.bmz02,'INS bmz_file','abm-748',1)                                                                  
              CONTINUE WHILE                                                                                              
           END IF                                                                                                               
           LET g_cnt=0                                                                                                          
           SELECT COUNT(*) INTO g_cnt FROM bma_file                                                                             
            WHERE bmaacti='Y'                                                                                                   
           IF g_cnt=0 THEN                                                        
              CALL s_errmsg('bmz02',l_bmz.bmz02,'INS bmz_file','abm-201',1)                                                                     
              CONTINUE WHILE                                                                                                
           END IF                                                                                                               
           IF g_sma.sma118 != 'Y' THEN
             IF cl_null(l_bmz.bmz05) THEN
                 LET l_bmz.bmz05 = ' '
             END IF
             SELECT bma05 INTO l_bma05 FROM bma_file
              WHERE bma01=l_bmz.bmz02
                AND bma06=l_bmz.bmz05
             IF cl_null(l_bma05) OR l_bma05 > g_bmx.bmx07 THEN
                CALL s_errmsg('bmz02',l_bmz.bmz02,'INS bmz_file','abm-005',1) 
                LET l_bmz.bmz05=NULL
                CONTINUE WHILE
             END IF
           END IF
           CALL i710_chkinsitm() RETURNING l_chkinsitm
           IF NOT l_chkinsitm THEN
             CONTINUE WHILE
           END IF
    LET l_bmz.bmz01=g_bmx.bmx01
    IF cl_null(l_bmz.bmz05) THEN 
       LET l_bmz.bmz05=' '
    END IF 
    LET l_bmz.bmzplant=g_plant
    LET l_bmz.bmzlegal=g_legal
    LET l_bmz.bmz011=' '
    LET l_bmz.bmz012=' '
    LET l_bmz.bmz013=0
    INSERT INTO bmz_file VALUES (l_bmz.*)
#TQC-C50024 -----------Begin---------------
    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
       CONTINUE WHILE
    ELSE
#TQC-C50024 -----------End-----------------
       IF STATUS THEN  
          CALL s_errmsg('bmz02',l_bmz.bmz02,'INS bmz_file',STATUS,1)
          CONTINUE WHILE
       END IF 
    END IF       #TQC-C50024                   
  END WHILE
  CALL s_showmsg()
END FUNCTION 

FUNCTION i710_bp_refresh()

   DISPLAY ARRAY g_bmz TO s_bmz.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
   BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION
#FUN-B30171--end

#FUN-B80071 add str---
FUNCTION i710_refresh()
  DEFINE l_bmx RECORD LIKE bmx_file.*

  SELECT * INTO l_bmx.* FROM bmx_file WHERE bmx01=g_bmx.bmx01
  RETURN l_bmx.*
END FUNCTION
#FUN-B80071 add end---

#No.FUN-BB0086---start---add---
FUNCTION i710_bmy081_check(b_bmy81_t)
   DEFINE b_bmy81_t	LIKE bmy_file.bmy081
   IF NOT cl_null(b_bmy.bmy081) AND NOT cl_null(b_bmy.bmy10) THEN
      IF cl_null(b_bmy81_t) OR cl_null(b_bmy10_t) OR b_bmy81_t != b_bmy.bmy081 OR b_bmy10_t != b_bmy.bmy10 THEN
         LET b_bmy.bmy081=s_digqty(b_bmy.bmy081, b_bmy.bmy10)
         DISPLAY BY NAME b_bmy.bmy081
      END IF
   END IF

   IF b_bmy.bmy081 < 0 THEN
      CALL cl_err(b_bmy.bmy081,'aec-020',0)
      LET b_bmy.bmy081 = b_bmy81_t
      DISPLAY BY NAME b_bmy.bmy081
      RETURN FALSE 
   END IF
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---end---add---

#-----MOD-C20082---------
FUNCTION i710_chk_bmz02_1(l_bmz02,l_flag)  
   DEFINE l_bmz02 LIKE bmz_file.bmz02,
          l_flag  LIKE type_file.chr1,
          l_bma05          LIKE bma_file.bma05,
          l_chkinsitm      LIKE type_file.num5, 
          l_bmr07          LIKE bmr_file.bmr07,
          l_n1             LIKE type_file.num5 

    IF NOT cl_null(l_bmz02)  THEN
       #FUN-AA0059 ----------------------------add start-----------------------
       IF NOT s_chk_item_no(l_bmz02,'') THEN
          #CALL cl_err(l_bmz02,g_errno,1) #FUN-C30119
          CALL s_errmsg('bmz02',l_bmz02,'',g_errno,1)  #FUN-C30119
          IF l_flag = 'b' THEN 
             LET g_bmz[l_ac].bmz02 = g_bmz_t.bmz02
             DISPLAY BY NAME g_bmz[l_ac].bmz02
          END IF
          RETURN FALSE
       END IF 
       #FUN-AA0059 ----------------------------add end---------------------                                         
       CALL s_field_chk(l_bmz02,'3',g_plant,'bmz02') RETURNING g_flag2                                                           
       IF g_flag2 = '0' THEN                                                                                                         
          #CALL cl_err(l_bmz02,'aoo-043',1)   #FUN-C30119 
          CALL s_errmsg('bmz02',l_bmz02,'','aoo-043',1)  #FUN-C30119                                                                                      
          IF l_flag = 'b' THEN 
             LET g_bmz[l_ac].bmz02 = g_bmz_t.bmz02                                                                                                
             DISPLAY BY NAME g_bmz[l_ac].bmz02                                                                                                
          END IF
          RETURN FALSE
       END IF
       #No.FUN-A60008--begin 
       IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
          IF g_sma.sma542='Y' THEN 
             SELECT COUNT(*) INTO l_n1 FROM bra_file WHERE bra01=l_bmz02 
             IF l_n1>0 THEN 
                #CALL cl_err(l_bmz02,'abm-225',1)  #FUN-C30119
                CALL s_errmsg('bmz02',l_bmz02,'','abm-225',1)  #FUN-C30119
                RETURN FALSE
             END IF 
          END IF 
       END IF 
       #No.FUN-A60008--end   
       #No.TQC-A30033--begin       
      #CHI-D10013-start---mark
      # IF NOT cl_null(g_bmx.bmx05) THEN          
      #    SELECT bmr07 INTO l_bmr07 FROM bmr_file
      #                             WHERE bmr01=g_bmx.bmx05
      #                               AND bmrconf = 'Y' 
      #    IF l_bmz02<>l_bmr07 THEN
      #       #CALL cl_err(l_bmz02,'abm-024',1) #FUN-C30119
      #       CALL s_errmsg('bmz02',l_bmz02,'','abm-024',1)  #FUN-C30119
      #       RETURN FALSE
      #    END IF
      # END IF                                    
      #CHI-D10013-end---mark                                                                                                                
       #No.TQC-A30033--end       
       IF l_flag = 'b' THEN 
          SELECT ima05 INTO g_bmz[l_ac].bmz04
            FROM ima_file
           WHERE ima01=l_bmz02
          LET g_bmz[l_ac].bmz03 = g_bmz[l_ac].bmz04  #MOD-DA0100 add 
       END IF
       IF STATUS AND l_flag = 'b' THEN   
          #CALL cl_err3("sel","ima_file",l_bmz02,"",STATUS,"","sel bma:",1) # TQC-660046 #FUN-C30119
          CALL s_errmsg('sel',l_bmz02,'ima_file',STATUS,1)  #FUN-C30119
          LET g_bmz[l_ac].bmz02=NULL
          RETURN FALSE
       ELSE
          SELECT COUNT(*) INTO g_cnt FROM bma_file
             WHERE bma01=l_bmz02 AND bmaacti='Y'
          IF g_cnt =0 THEN
             #CALL cl_err(l_bmz02,'abm-742',0) #FUN-C30119
             CALL s_errmsg('bmz02',l_bmz02,'','abm-742',1)  #FUN-C30119
             RETURN FALSE
          END IF
       
          #TQC-AB0240 --------add start--------
          SELECT COUNT(*) INTO g_cnt FROM bma_file
           WHERE bma01=l_bmz02
             AND bmaacti='Y'
             AND bma10 = '2'
          IF g_cnt =0 THEN
          #  CALL cl_err(l_bmz02,'abm-038',0)   #TQC-C60179  mark
             #CALL cl_err(l_bmz02,'abm-096',0)   #TQC-C60179 #FUN-C30119
             CALL s_errmsg('bmz02',l_bmz02,'','abm-096',1)  #FUN-C30119
             RETURN FALSE
          END IF
          #TQC-AB0240 --------add end----------------
       
          IF l_flag = 'b' THEN 
             SELECT ima02,ima021 INTO g_bmz[l_ac].ima02_1,g_bmz[l_ac].ima021_1
               FROM ima_file
              WHERE ima01=l_bmz02
             DISPLAY g_bmz[l_ac].ima02_1 TO FORMONLY.ima02_1
             DISPLAY g_bmz[l_ac].ima021_1 TO FORMONLY.ima021_1
          END IF
       END IF
       IF NOT i710_chk_bmz02(l_bmz02) THEN #MOD-570304
          #CALL cl_err(l_bmz02,'abm-710',0)  #FUN-C30119
          CALL s_errmsg('bmz02',l_bmz02,'','abm-710',1)  #FUN-C30119
          RETURN FALSE
       END IF
       LET g_cnt = 0                                                                                                        
       SELECT COUNT(*) INTO g_cnt FROM bma_file                                                                             
        WHERE bma01=l_bmz02                                                                                       
       IF g_cnt=0 THEN                                                                                                      
          #CALL cl_err(l_bmz02,'abm-748',0) #FUN-C30119
          CALL s_errmsg('bmz02',l_bmz02,'','abm-748',1)  #FUN-C30119                                                                       
          RETURN FALSE
       END IF                                                                                                               
       LET g_cnt=0                                                                                                          
       SELECT COUNT(*) INTO g_cnt FROM bma_file                                                                             
        WHERE bmaacti='Y'                                                                                                   
       IF g_cnt=0 THEN                                                                                                      
          #CALL cl_err(l_bmz02,'abm-201',0) #FUN-C30119  
          CALL s_errmsg('bmz02',l_bmz02,'','abm-201',1)  #FUN-C30119                                                                      
          RETURN FALSE
       END IF                                                                                                               
    END IF
    IF l_flag = 'b' THEN 
       IF g_sma.sma118 != 'Y' THEN
             IF cl_null(g_bmz[l_ac].bmz05) THEN
                LET g_bmz[l_ac].bmz05 = ' '
             END IF
             SELECT bma05 INTO l_bma05 FROM bma_file
              WHERE bma01=l_bmz02
                AND bma06=g_bmz[l_ac].bmz05
             IF cl_null(l_bma05) OR l_bma05 > g_bmx.bmx07 THEN
                #CALL cl_err(l_bma05,'abm-005',0)  #FUN-C30119 
                CALL s_errmsg('bma05',l_bma05,'','abm-005',1)  #FUN-C30119
                LET g_bmz[l_ac].bmz05=NULL
                RETURN FALSE
             END IF
       END IF
       CALL i710_chkinsitm() RETURNING l_chkinsitm
       IF NOT l_chkinsitm THEN
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION
#-----END MOD-C20082-----
#MOD-C20154 str add-----
FUNCTION i710_y_chk_bmy2()

    DECLARE i710_y_c3 CURSOR FOR
      SELECT * FROM bmy_file WHERE bmy01=g_bmx.bmx01

    FOREACH i710_y_c3 INTO b_bmy.*
      IF (cl_null(b_bmy.bmy08) OR cl_null(b_bmy.bmy10) OR cl_null(b_bmy.bmy10_fac) OR
          cl_null(b_bmy.bmy18) OR cl_null(b_bmy.bmy20) OR cl_null(b_bmy.bmy21) OR
          cl_null(b_bmy.bmy23) OR cl_null(b_bmy.bmy34)) AND b_bmy.bmy03 = '2' THEN

         CALL s_errmsg('bmy05',b_bmy.bmy05,' ','abm-093',1)
         LET g_success='N'
      END IF
    END FOREACH

END FUNCTION
#MOD-C20154 end add-----
#CHI-C10023 str add-----
FUNCTION i710_chk_bmw()
DEFINE l_sql      STRING
DEFINE i          LIKE type_file.num10
DEFINE l_amt      LIKE bmw_file.bmw05

    LET l_sql = " SELECT bmb06/bmb07 FROM bmb_file ",
                " WHERE bmb01= ? AND bmb03= '",g_bmy[l_ac].bmy05,"'"

    PREPARE i710_bmw_pre01 FROM l_sql
    DECLARE i710_bmw_c1 CURSOR FOR i710_bmw_pre01

   #CHI-DC0019-Add-Modify  
   #IF g_bmy[l_ac].bmy03<>5 AND NOT (cl_null(g_bmy[l_ac].bmy06) OR cl_null(g_bmy[l_ac].bmy07)) THEN
    IF g_bmy[l_ac].bmy03<>5 THEN
       IF cl_null(g_bmy[l_ac].bmy06) THEN 
         #MOD-G90008--mark---str---
         #SELECT bmb06/bmb07 INTO l_amt 
         #  FROM bmb_file
         # WHERE bmb01=g_bmz[l_ac].bmz02 
         #   AND bmb03=g_bmy[l_ac].bmy05 
         #   AND bmb05 IS NULL          
         #MOD-G90008--mark---end---
          LET l_amt = g_amt #MOD-G90008 add
       ELSE 
          LET l_amt = g_bmy[l_ac].bmy06/g_bmy[l_ac].bmy07
       END IF 
   #CHI-DC0019-End-Modify    
       IF g_bmw05 != l_amt THEN
        #RETURN FALSE #CHI-DC0019 mark
         RETURN 'N'   #CHI-DC0019 add
       END IF
    ELSE
       FOR i=1 TO g_bmz.getLength()
         OPEN i710_bmw_c1 USING g_bmz[i].bmz02
         IF STATUS THEN
            CALL cl_err("OPEN i710_bmw_c1:", STATUS, 1)
            CLOSE i710_cl
            RETURN 'N'
         END IF
         FETCH i710_bmw_c1 INTO l_amt
         IF g_bmw05 != l_amt THEN
           RETURN 'N'
         END IF
       END FOR
    END IF

    RETURN 'Y'

END FUNCTION
#CHI-C10023 end add-----

#TQC-E90001--add str--
FUNCTION i710_del_bmyx()
IF (g_bmy_o.bmy02 <> g_bmy02_t) OR (g_bmy_o.bmy05 <> g_bmy05_t1) OR (g_bmy_o.bmy38 <> g_bmy38_t) THEN  #若更改元件則刪除該單身項次的明細
   DELETE FROM bmya_file WHERE bmya01 = g_bmx.bmx01 AND bmya02 = g_bmy_t.bmy02
   DELETE FROM bmyb_file WHERE bmyb01 = g_bmx.bmx01 AND bmyb02 = g_bmy_t.bmy02
   DELETE FROM bmyc_file WHERE bmyc01 = g_bmx.bmx01 AND bmyc02 = g_bmy_t.bmy02
   DELETE FROM bmyd_file WHERE bmyd01 = g_bmx.bmx01 AND bmyd02 = g_bmy_t.bmy02
   LET g_bmy_o.bmy02 = g_bmy[l_ac].bmy02
   LET g_bmy_o.bmy05 = g_bmy[l_ac].bmy05
   LET g_bmy_o.bmy38 = g_bmy[l_ac].bmy38
END IF
END FUNCTION
#TQC-E90001--add end--

#FUN-D80022 ---------Begin---------
FUNCTION i710_ins_bmyx(p_cmd)
DEFINE l_bmya    RECORD LIKE bmya_file.*
DEFINE l_bmyb    RECORD LIKE bmyb_file.*
DEFINE l_bmyc    RECORD LIKE bmyc_file.*
DEFINE l_bmyd    RECORD LIKE bmyd_file.* 

DEFINE 
    l_ac_t          LIKE type_file.num5,     
    l_n             LIKE type_file.num5,     
    l_lock_sw       LIKE type_file.chr1,    
    p_cmd           LIKE type_file.chr1,     
    l_possible      LIKE type_file.num5,     
    l_dir1          LIKE type_file.chr1,     
    l_recal_ima1    LIKE type_file.chr1,     
    l_recal_ima2    LIKE type_file.chr1,     
    l_buf           LIKE ze_file.ze03,      
    l_allow_insert  LIKE type_file.chr1,     
    l_allow_delete  LIKE type_file.chr1,     
    l_cnt           LIKE type_file.num10,    
    l_cnt1          LIKE type_file.num10,
    l_cnt2          LIKE type_file.num10,
    l_imd           RECORD LIKE imd_file.*,  
    l_change        LIKE type_file.chr1      
DEFINE l_sql        STRING,
       l_sql1       STRING,
       l_sql2       STRING 
DEFINE l_bmy02      LIKE bmy_file.bmy02
  
   WHENEVER ERROR CONTINUE    
   LET p_row = 10 LET p_col = 24
   OPEN WINDOW i710_b_w AT p_row,p_col WITH FORM "abm/42f/abmi710_b"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_locale("abmi710_b")       
  #順序不能顛倒
 # CALL cl_set_comp_visible("bmya04,bmya05",g_bmy[l_ac].bmy38 = '3') 
 # CALL cl_set_comp_visible("bmyb04,bmyb05",g_bmy[l_ac].bmy38 = '4')
 # CALL cl_set_comp_visible("bmya04,bmya05,bmyb04,bmyb05",g_bmy[l_ac].bmy38 = '2')  
 # CALL cl_set_comp_visible("bmyc04",g_bmy[l_ac].bmy38 = '6') 
 # CALL cl_set_comp_visible("bmyd04",g_bmy[l_ac].bmy38 = '7')
 # CALL cl_set_comp_visible("bmyc04,bmyd04",g_bmy[l_ac].bmy38 = '5')

   IF g_bmy[l_ac].bmy38 MATCHES '[23]' THEN
      CALL cl_set_comp_visible("bmya04,bmya04_des,bmya05,bmya05_des",TRUE)
   ELSE
      CALL cl_set_comp_visible("bmya04,bmya04_des,bmya05,bmya05_des",FALSE)
   END IF 
   IF g_bmy[l_ac].bmy38 MATCHES '[24]' THEN
      CALL cl_set_comp_visible("bmyb04,bmyb04_des,bmyb05,bmyb05_des",TRUE)
   ELSE
      CALL cl_set_comp_visible("bmyb04,bmyb04_des,bmyb05,bmyb05_des",FALSE)
   END IF
   IF g_bmy[l_ac].bmy38 MATCHES '[56]' THEN
      CALL cl_set_comp_visible("bmyc04,bmyc04_des",TRUE)
   ELSE
      CALL cl_set_comp_visible("bmyc04,bmyc04_des",FALSE)
   END IF
   IF g_bmy[l_ac].bmy38 MATCHES '[57]' THEN
      CALL cl_set_comp_visible("bmyd04,bmyd04_des",TRUE)
   ELSE
      CALL cl_set_comp_visible("bmyd04,bmyd04_des",FALSE)
   END IF

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   CALL i710_bmyx_b_fill()

   #點擊退出
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CLOSE WINDOW i710_b_w
   END IF 

   IF p_cmd = 'u' THEN 
      LET l_bmy02 = g_bmy_t.bmy02
   ELSE
      LET l_bmy02 = g_bmy[l_ac].bmy02
   END IF 
   LET g_forupd_sql1 = "SELECT bmya03,bmya04,bmya05 FROM bmya_file ",
               " WHERE bmya01 = '",g_bmx.bmx01,"'",
               "   AND bmya02 = '",l_bmy02,"'",
               "   AND bmya03 = ? ",
               "   FOR UPDATE "  
   LET g_forupd_sql1 = cl_forupd_sql(g_forupd_sql1)
   LET g_forupd_sql2 = "SELECT bmyb03,bmyb04,bmyb05 FROM bmyb_file ", 
               " WHERE bmyb01 = '",g_bmx.bmx01,"'",
               "   AND bmyb02 = '",l_bmy02,"'",
               "   AND bmyb03 = ?",
               "   FOR UPDATE "     
   LET g_forupd_sql2 = cl_forupd_sql(g_forupd_sql2)
   LET g_forupd_sql3 = "SELECT bmyc03,bmyc04 FROM bmyc_file ",
               " WHERE bmyc01 = '",g_bmx.bmx01,"'",
               "   AND bmyc02 = '",l_bmy02,"'",
               "   AND bmyc03 = ?",
               "   FOR UPDATE "       
   LET g_forupd_sql3 = cl_forupd_sql(g_forupd_sql3)
   LET g_forupd_sql4 = "SELECT bmyd03,bmyd04 FROM bmyd_file ",
               " WHERE bmyd01 = '",g_bmx.bmx01,"'",
               "   AND bmyd02 = '",l_bmy02,"'",
               "   AND bmyd03 = ?",
               "   FOR UPDATE "         
   LET g_forupd_sql4 = cl_forupd_sql(g_forupd_sql4)
   IF g_bmy[l_ac].bmy38 MATCHES '[23]' THEN 
      DECLARE i710_bcl_1 CURSOR FROM g_forupd_sql1
   END IF
   IF g_bmy[l_ac].bmy38 MATCHES '[24]' THEN
      DECLARE i710_bcl_2 CURSOR FROM g_forupd_sql2
   END IF
   IF g_bmy[l_ac].bmy38 MATCHES '[56]' THEN
      DECLARE i710_bcl_3 CURSOR FROM g_forupd_sql3
   END IF
   IF g_bmy[l_ac].bmy38 MATCHES '[57]' THEN
      DECLARE i710_bcl_4 CURSOR FROM g_forupd_sql4
   END IF
   
   IF NOT cl_null(g_bmy[l_ac].bmy05) AND cl_null(p_cmd) THEN
      SELECT ima940,ima941,ima943 INTO g_ima940,g_ima941,g_ima943 FROM ima_file
       WHERE ima01 = g_bmz[1].bmz02
      SELECT ima940,ima941,ima943 INTO g_ima940_1,g_ima941_1,g_ima943_1 FROM ima_file
       WHERE ima01 = g_bmy[l_ac].bmy05
   END IF

   INPUT ARRAY g_bmya_1 WITHOUT DEFAULTS FROM s_bmya_1.*
         ATTRIBUTE(COUNT=g_rec_b_2,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
   BEFORE INPUT 
      CALL i710_set_b_no_required()
      CALL i710_set_b_required()   

   BEFORE ROW
      LET p_cmd=''          
      LET l_ac2 = ARR_CURR()
      LET l_lock_sw = 'N'  
      LET l_n = ARR_COUNT() 
      LET g_success = 'Y'
      CALL fgl_set_arr_curr(l_ac2)  #TQC-E90001 
   
     #TQC-E90001--add str--
      IF l_action = 'define_color_size' AND g_rec_b_2 >= l_ac2 THEN
         BEGIN WORK
      END IF
     #TQC-E90001--add end--
   
      IF g_rec_b_2>=l_ac2 THEN
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE 
         
         LET g_success = 'Y'
         LET p_cmd = 'u'     
         LET g_bmya_1_t.* = g_bmya_1[l_ac2].*
         IF g_bmy[l_ac].bmy38 MATCHES '[23]' AND NOT cl_null(g_bmya_1_t.bmya03) THEN             
            OPEN i710_bcl_1 USING g_bmya_1_t.bmya03
         END IF
         IF g_bmy[l_ac].bmy38 MATCHES '[24]' AND NOT cl_null(g_bmya_1_t.bmyb03) THEN  
            OPEN i710_bcl_2 USING g_bmya_1_t.bmyb03
         END IF    
         IF g_bmy[l_ac].bmy38 MATCHES '[56]' AND NOT cl_null(g_bmya_1_t.bmyc03) THEN 
            OPEN i710_bcl_3 USING g_bmya_1_t.bmyc03
         END IF
         IF g_bmy[l_ac].bmy38 MATCHES '[57]' AND NOT cl_null(g_bmya_1_t.bmyd03) THEN 
            OPEN i710_bcl_4 USING g_bmya_1_t.bmyd03
         END IF

         IF STATUS THEN 
            CALL cl_err("OPEN lock_curs:", STATUS, 1)
            LET l_lock_sw = 'Y'
         ELSE
            IF g_bmy[l_ac].bmy38 MATCHES '[23]' AND NOT cl_null(g_bmya_1_t.bmya03) THEN
               FETCH i710_bcl_1 INTO g_bmya_1[l_ac2].bmya03,g_bmya_1[l_ac2].bmya04,g_bmya_1[l_ac2].bmya05
            END IF
            IF g_bmy[l_ac].bmy38 MATCHES '[24]' AND NOT cl_null(g_bmya_1_t.bmyb03) THEN
               FETCH i710_bcl_2 INTO g_bmya_1[l_ac2].bmyb03,g_bmya_1[l_ac2].bmyb04,g_bmya_1[l_ac2].bmyb05
            END IF
            IF g_bmy[l_ac].bmy38 MATCHES '[56]' AND NOT cl_null(g_bmya_1_t.bmyc03) THEN
               FETCH i710_bcl_3 INTO g_bmya_1[l_ac2].bmyc03,g_bmya_1[l_ac2].bmyc04
            END IF
            IF g_bmy[l_ac].bmy38 MATCHES '[57]' AND NOT cl_null(g_bmya_1_t.bmyd03) THEN
               FETCH i710_bcl_4 INTO g_bmya_1[l_ac2].bmyd03,g_bmya_1[l_ac2].bmyb04
            END IF
            IF SQLCA.sqlcode THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()
         END IF
      END IF

         BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           LET g_before_input_done = FALSE
           CALL i710_set_b_no_required()
           CALL i710_set_b_required() 
           LET g_before_input_done = TRUE
           INITIALIZE g_bmya_1[l_ac2].* TO NULL 
           LET g_bmya_1_t.* = g_bmya_1[l_ac2].*          
           CALL cl_show_fld_cont()  
           IF g_bmy[l_ac].bmy38 MATCHES '[23]' THEN     
              NEXT FIELD bmya04
           END IF 
           IF g_bmy[l_ac].bmy38 = '4' THEN     
              NEXT FIELD bmyb04
           END IF  
           IF g_bmy[l_ac].bmy38 MATCHES '[56]' THEN     
              NEXT FIELD bmyc04
           END IF 
           IF g_bmy[l_ac].bmy38 = '7' THEN     
              NEXT FIELD bmyd04
           END IF 
                      
        AFTER FIELD bmya04 
           IF NOT cl_null(g_bmya_1[l_ac2].bmya05) AND cl_null(g_bmya_1[l_ac2].bmya04) THEN 
              NEXT FIELD bmya04
           END IF  
           IF NOT cl_null(g_bmya_1[l_ac2].bmya04) THEN
              IF NOT i710_bmya04_chk(g_bmya_1[l_ac2].bmya04,g_ima940) THEN
                 LET g_bmya_1[l_ac2].bmya04 = g_bmya_1_t.bmya04
                 CALL cl_err(g_bmya_1[l_ac2].bmya04,'abm-140',0)
                 NEXT FIELD bmya04
              END IF
              IF NOT i710_bmyx_chk() THEN
                 LET g_bmya_1[l_ac2].bmya04 = g_bmya_1_t.bmya04 
                 NEXT FIELD bmya04
              END IF
              SELECT agd03 INTO g_bmya_1[l_ac2].bmya04_des FROM ima_file,agd_file
               WHERE agd01 = ima940
                 AND ima01 = g_bmz[1].bmz02
                 AND agd02 = g_bmya_1[l_ac2].bmya04
           END IF
           IF cl_null(g_bmya_1[l_ac2].bmya05) AND NOT cl_null(g_bmya_1[l_ac2].bmya04) THEN 
              NEXT FIELD bmya05
           END IF  

        AFTER FIELD bmya05
           IF NOT cl_null(g_bmya_1[l_ac2].bmya04) AND cl_null(g_bmya_1[l_ac2].bmya05) THEN 
              NEXT FIELD bmya05
           END IF 
           IF NOT cl_null(g_bmya_1[l_ac2].bmya05) THEN
              IF NOT i710_bmya04_chk(g_bmya_1[l_ac2].bmya05,g_ima940_1) THEN
                 LET g_bmya_1[l_ac2].bmya05 = g_bmya_1_t.bmya05
                 CALL cl_err(g_bmya_1[l_ac2].bmya05,'abm-140',0)
                 NEXT FIELD bmya05
              END IF 
              IF NOT i710_bmyx_chk() THEN
                 LET g_bmya_1[l_ac2].bmya05 = g_bmya_1_t.bmya05
                 NEXT FIELD bmya05
              END IF
              SELECT agd03 INTO g_bmya_1[l_ac2].bmya05_des FROM ima_file,agd_file
               WHERE agd01 = ima940
                 AND ima01 = g_bmy[l_ac].bmy05 
                 AND agd02 = g_bmya_1[l_ac2].bmya05
           END IF
           IF cl_null(g_bmya_1[l_ac2].bmya04) AND NOT cl_null(g_bmya_1[l_ac2].bmya05) THEN 
              NEXT FIELD bmya04
           END IF 

        AFTER FIELD bmyb04
           IF NOT cl_null(g_bmya_1[l_ac2].bmyb05) AND cl_null(g_bmya_1[l_ac2].bmyb04) THEN 
              NEXT FIELD bmyb04
           END IF  
           IF NOT cl_null(g_bmya_1[l_ac2].bmyb04) THEN
              IF NOT i710_bmyb04_chk(g_bmya_1[l_ac2].bmyb04,g_ima941) THEN
                 LET g_bmya_1[l_ac2].bmyb04 = g_bmya_1_t.bmyb04
                 CALL cl_err(g_bmya_1[l_ac2].bmyb04,'abm-140',0)
                 NEXT FIELD bmyb04
              END IF
              IF NOT i710_bmyx_chk() THEN          
                 LET g_bmya_1[l_ac2].bmyb04 = g_bmya_1_t.bmyb04
                 NEXT FIELD bmyb04
              END IF
              SELECT agd03 INTO g_bmya_1[l_ac2].bmyb04_des FROM ima_file,agd_file
               WHERE agd01 = ima941
                 AND ima01 = g_bmz[1].bmz02
                 AND agd02 = g_bmya_1[l_ac2].bmyb04
           END IF
           IF cl_null(g_bmya_1[l_ac2].bmyb05) AND NOT cl_null(g_bmya_1[l_ac2].bmyb04) THEN 
              NEXT FIELD bmyb05
           END IF  

        AFTER FIELD bmyb05
           IF cl_null(g_bmya_1[l_ac2].bmyb05) AND NOT cl_null(g_bmya_1[l_ac2].bmyb04) THEN 
              NEXT FIELD bmyb05
           END IF
           IF NOT cl_null(g_bmya_1[l_ac2].bmyb05) THEN
              IF NOT i710_bmyb04_chk(g_bmya_1[l_ac2].bmyb05,g_ima941_1) THEN
                 LET g_bmya_1[l_ac2].bmyb05 = g_bmya_1_t.bmyb05
                 CALL cl_err(g_bmya_1[l_ac2].bmyb05,'abm-140',0)
                 NEXT FIELD bmyb05
              END IF
              IF NOT i710_bmyx_chk()THEN
                 LET g_bmya_1[l_ac2].bmyb05 = g_bmya_1_t.bmyb05
                 NEXT FIELD bmyb05         
              END IF
              SELECT agd03 INTO g_bmya_1[l_ac2].bmyb05_des FROM ima_file,agd_file
               WHERE agd01 = ima941
                 AND ima01 = g_bmy[l_ac].bmy05 
                 AND agd02 = g_bmya_1[l_ac2].bmyb05
           END IF
           IF NOT cl_null(g_bmya_1[l_ac2].bmyb05) AND cl_null(g_bmya_1[l_ac2].bmyb04) THEN 
              NEXT FIELD bmyb04
           END IF

        AFTER FIELD bmyc04
           IF NOT cl_null(g_bmya_1[l_ac2].bmyc04) THEN
              IF NOT i710_bmya04_chk(g_bmya_1[l_ac2].bmyc04,g_ima940) THEN
                 LET g_bmya_1[l_ac2].bmyc04 = g_bmya_1_t.bmyc04
                 CALL cl_err(g_bmya_1[l_ac2].bmyc04,'abm-140',0)
                 NEXT FIELD bmyc04 
              END IF 
              IF NOT i710_bmyx_chk() THEN
                 LET g_bmya_1[l_ac2].bmyc04 = g_bmya_1_t.bmyc04
                 NEXT FIELD bmyc04
              END IF
              SELECT agd03 INTO g_bmya_1[l_ac2].bmyc04_des FROM ima_file,agd_file
               WHERE agd01 = ima940
                 AND ima01 = g_bmz[1].bmz02
                 AND agd02 = g_bmya_1[l_ac2].bmyc04
           END IF
           
        AFTER FIELD bmyd04
           IF NOT cl_null(g_bmya_1[l_ac2].bmyd04) THEN
              IF NOT i710_bmyb04_chk(g_bmya_1[l_ac2].bmyd04,g_ima941) THEN
                 LET g_bmya_1[l_ac2].bmyd04 = g_bmya_1_t.bmyd04
                 CALL cl_err(g_bmya_1[l_ac2].bmyd04,'abm-140',0)
                 NEXT FIELD bmyd04
              END IF
              IF NOT i710_bmyx_chk() THEN
                 LET g_bmya_1[l_ac2].bmyd04 = g_bmya_1_t.bmyd04
                 NEXT FIELD bmyd04
              END IF
              SELECT agd03 INTO g_bmya_1[l_ac2].bmyd04_des FROM ima_file,agd_file
               WHERE agd01 = ima941
                 AND ima01 = g_bmz[1].bmz02
                 AND agd02 = g_bmya_1[l_ac2].bmyd04
           END IF 

        AFTER INSERT
           IF INT_FLAG THEN                  
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF 
           IF cl_null(g_bmya_1[l_ac2].bmya04) AND cl_null(g_bmya_1[l_ac2].bmyb04) AND
              cl_null(g_bmya_1[l_ac2].bmyc04) AND cl_null(g_bmya_1[l_ac2].bmyd04) THEN 
              CANCEL INSERT
           END IF  
           IF g_bmy[l_ac].bmy38 MATCHES '[23]' THEN
              IF NOT cl_null(g_bmya_1[l_ac2].bmya04) AND NOT cl_null(g_bmya_1[l_ac2].bmya05) THEN
                 LET l_bmya.bmya01 = g_bmx.bmx01
                 LET l_bmya.bmya02 = g_bmy[l_ac].bmy02
                #SELECT COUNT(*) INTO l_n FROM bmya_file                       #TQC-E90001 mark
                 SELECT MAX(bmya03) INTO l_n FROM bmya_file                    #TQC-E90001 modify
                  WHERE bmya01 = g_bmx.bmx01 AND bmya02 = g_bmy[l_ac].bmy02 
                 IF cl_null(l_n) THEN LET l_n = 0 END IF                       #TQC-E90001 add
                 LET l_bmya.bmya03 = l_n + 1
                 LET g_bmya_1[l_ac2].bmya03 = l_bmya.bmya03                    #TQC-E90001 add
                 LET l_bmya.bmya04 = g_bmya_1[l_ac2].bmya04   
                 LET l_bmya.bmya05 = g_bmya_1[l_ac2].bmya05
                 IF cl_null(l_bmya.bmya04) THEN LET l_bmya.bmya04 = ' ' END IF 
                 IF cl_null(l_bmya.bmya05) THEN LET l_bmya.bmya05 = ' ' END IF 
                 INSERT INTO bmya_file VALUES (l_bmya.*)
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("ins","bmya_file",g_bmy[l_ac].bmy05,"",
                                   SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                    CANCEL INSERT
                 END IF
              END IF          
           END IF 
           IF g_bmy[l_ac].bmy38 MATCHES '[24]' THEN
              IF NOT cl_null(g_bmya_1[l_ac2].bmyb05) AND NOT cl_null(g_bmya_1[l_ac2].bmyb04) THEN
                 LET l_bmyb.bmyb01 = g_bmx.bmx01
                 LET l_bmyb.bmyb02 = g_bmy[l_ac].bmy02
                #SELECT COUNT(*) INTO l_n FROM bmyb_file                       #TQC-E90001 mark
                 SELECT MAX(bmyb03) INTO l_n FROM bmyb_file                    #TQC-E90001 modify
                  WHERE bmyb01 = g_bmx.bmx01 AND bmyb02 = g_bmy[l_ac].bmy02
                 IF cl_null(l_n) THEN LET l_n = 0 END IF                       #TQC-E90001 add
                 LET l_bmyb.bmyb03 = l_n + 1
                 LET g_bmya_1[l_ac2].bmyb03 = l_bmyb.bmyb03                    #TQC-E90001 add
                 LET l_bmyb.bmyb04 = g_bmya_1[l_ac2].bmyb04   
                 LET l_bmyb.bmyb05 = g_bmya_1[l_ac2].bmyb05
                 IF cl_null(l_bmyb.bmyb04) THEN LET l_bmyb.bmyb04 = ' ' END IF
                 IF cl_null(l_bmyb.bmyb05) THEN LET l_bmyb.bmyb05 = ' ' END IF
                 INSERT INTO bmyb_file VALUES (l_bmyb.*)
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("ins","bmyb_file",g_bmy[l_ac].bmy05,"",
                                   SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                    CANCEL INSERT
                 END IF
              END IF   
           END IF  
           IF g_bmy[l_ac].bmy38 MATCHES '[56]' THEN
              IF NOT cl_null(g_bmya_1[l_ac2].bmyc04) THEN
                 LET l_bmyc.bmyc01 = g_bmx.bmx01
                 LET l_bmyc.bmyc02 = g_bmy[l_ac].bmy02
                #SELECT COUNT(*) INTO l_n FROM bmyc_file                       #TQC-E90001 mark
                 SELECT MAX(bmyc03) INTO l_n FROM bmyc_file                    #TQC-E90001 modify
                  WHERE bmyc01 = g_bmx.bmx01 AND bmyc02 = g_bmy[l_ac].bmy02
                 IF cl_null(l_n) THEN LET l_n = 0 END IF                       #TQC-E90001 add
                 LET l_bmyc.bmyc03 = l_n + 1
                 LET g_bmya_1[l_ac2].bmyc03 = l_bmyc.bmyc03                    #TQC-E90001 add
                 LET l_bmyc.bmyc04 = g_bmya_1[l_ac2].bmyc04   
                 IF cl_null(l_bmyc.bmyc04) THEN LET l_bmyc.bmyc04 = ' ' END IF
                 INSERT INTO bmyc_file VALUES (l_bmyc.*)
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("ins","bmyc_file",g_bmy[l_ac].bmy05,"",
                                   SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                    CANCEL INSERT
                 END IF 
              END IF
           END IF  
           IF g_bmy[l_ac].bmy38 MATCHES '[57]' THEN
              IF NOT cl_null(g_bmya_1[l_ac2].bmyd04) THEN
                 LET l_bmyd.bmyd01 = g_bmx.bmx01
                 LET l_bmyd.bmyd02 = g_bmy[l_ac].bmy02
                #SELECT COUNT(*) INTO l_n FROM bmyd_file                       #TQC-E90001 mark 
                 SELECT MAX(bmyd03) INTO l_n FROM bmyd_file                    #TQC-E90001 modify
                  WHERE bmyd01 = g_bmx.bmx01 AND bmyd02 = g_bmy[l_ac].bmy02
                 IF cl_null(l_n) THEN LET l_n = 0 END IF                       #TQC-E90001 add
                 LET l_bmyd.bmyd03 = l_n + 1
                 LET g_bmya_1[l_ac2].bmyd03 = l_bmyd.bmyd03                    #TQC-E90001 add 
                 LET l_bmyd.bmyd04 = g_bmya_1[l_ac2].bmyd04   
                 IF cl_null(l_bmyd.bmyd04) THEN LET l_bmyd.bmyd04 = ' ' END IF
                 INSERT INTO bmyd_file VALUES (l_bmyd.*)
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("ins","bmyd_file",g_bmy[l_ac].bmy05,"",
                                   SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                    CANCEL INSERT
                 END IF 
              END IF
           END IF  
           IF g_success = 'Y' THEN
              MESSAGE 'INSERT O.K'
              LET g_rec_b_2 = g_rec_b_2 + 1
              DISPLAY g_rec_b_2 TO FORMONLY.cn1  
           END IF     
           
        ON ROW CHANGE 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_bmya_1[l_ac2].* = g_bmya_1_t.*
             #CLOSE i710_bcl_1
              IF g_bmy[l_ac].bmy38 MATCHES '[23]' AND NOT cl_null(g_bmya_1_t.bmya03) THEN
                 CLOSE i710_bcl_1
              END IF
              IF g_bmy[l_ac].bmy38 MATCHES '[24]' AND NOT cl_null(g_bmya_1_t.bmyb03) THEN
                 CLOSE i710_bcl_2
              END IF 
              IF g_bmy[l_ac].bmy38 MATCHES '[56]' AND NOT cl_null(g_bmya_1_t.bmyc03) THEN
                 CLOSE i710_bcl_3
              END IF
              IF g_bmy[l_ac].bmy38 MATCHES '[57]' AND NOT cl_null(g_bmya_1_t.bmyd03) THEN
                 CLOSE i710_bcl_4
              END IF
              IF l_lock_sw = 'Y' THEN                   #TQC-E90001 
                 ROLLBACK WORK
              END IF                                    #TQC-E90001
              LET g_success = 'N'                       #TQC-E90001
              EXIT INPUT
           END IF  
           IF l_lock_sw = 'Y' THEN
              CALL cl_err('',-263,1)
              LET g_bmya_1[l_ac2].* = g_bmya_1_t.*
           ELSE
              IF g_bmy[l_ac].bmy38 MATCHES '[23]' THEN 
                 IF NOT cl_null(g_bmya_1_t.bmya03) THEN
                    UPDATE bmya_file  SET bmya04 = g_bmya_1[l_ac2].bmya04,
                                          bmya05 = g_bmya_1[l_ac2].bmya05
                     WHERE bmya01 = g_bmx.bmx01
                       AND bmya02 = g_bmy[l_ac].bmy02 
                       AND bmya03 = g_bmya_1[l_ac2].bmya03 
                 ELSE 
                    IF NOT cl_null(g_bmya_1[l_ac2].bmya04) AND NOT cl_null(g_bmya_1[l_ac2].bmya05) THEN
                       LET l_bmya.bmya01 = g_bmx.bmx01
                       LET l_bmya.bmya02 = g_bmy[l_ac].bmy02
                      #SELECT COUNT(*) INTO l_n FROM bmya_file                       #TQC-E90001 mark
                       SELECT MAX(bmya03) INTO l_n FROM bmya_file                    #TQC-E90001 modify
                        WHERE bmya01 = g_bmx.bmx01 AND bmya02 = g_bmy[l_ac].bmy02
                       IF cl_null(l_n) THEN LET l_n = 0 END IF                       #TQC-E90001 add
                       LET l_bmya.bmya03 = l_n + 1
                       LET l_bmya.bmya04 = g_bmya_1[l_ac2].bmya04
                       LET l_bmya.bmya05 = g_bmya_1[l_ac2].bmya05
                       IF cl_null(l_bmya.bmya04) THEN LET l_bmya.bmya04 = ' ' END IF 
                       IF cl_null(l_bmya.bmya05) THEN LET l_bmya.bmya05 = ' ' END IF
                       INSERT INTO bmya_file VALUES (l_bmya.*)
                       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                          CALL cl_err3("ins","bmya_file",g_bmy[l_ac].bmy05,"",
                                         SQLCA.sqlcode,"","",1)
                         #TQC-E90001--add str--
                          IF l_action = 'define_color_size' THEN
                             ROLLBACK WORK
                          END IF
                         #TQC-E90001--add end--
                          LET g_success = 'N'
                       END IF
                    END IF   
                 END IF
              END IF  
              IF g_bmy[l_ac].bmy38 MATCHES '[24]' THEN 
                 IF NOT cl_null(g_bmya_1_t.bmyb03) THEN
                    UPDATE bmyb_file  SET bmyb04 = g_bmya_1[l_ac2].bmyb04,
                                          bmyb05 = g_bmya_1[l_ac2].bmyb05
                     WHERE bmyb01 = g_bmx.bmx01
                       AND bmyb02 = g_bmy[l_ac].bmy02 
                       AND bmyb03 = g_bmya_1[l_ac2].bmyb03 
                 ELSE 
                    IF g_bmy[l_ac].bmy38 MATCHES '[24]' THEN
                       IF NOT cl_null(g_bmya_1[l_ac2].bmyb05) AND NOT cl_null(g_bmya_1[l_ac2].bmyb04) THEN
                          LET l_bmyb.bmyb01 = g_bmx.bmx01
                          LET l_bmyb.bmyb02 = g_bmy[l_ac].bmy02
                         #SELECT COUNT(*) INTO l_n FROM bmyb_file                    #TQC-E90001 mark
                          SELECT MAX(bmyb03) INTO l_n FROM bmyb_file                 #TQC-E90001 modify
                           WHERE bmyb01 = g_bmx.bmx01 AND bmyb02 = g_bmy[l_ac].bmy02
                          IF cl_null(l_n) THEN LET l_n = 0 END IF                    #TQC-E90001 add
                          LET l_bmyb.bmyb03 = l_n + 1
                          LET l_bmyb.bmyb04 = g_bmya_1[l_ac2].bmyb04
                          LET l_bmyb.bmyb05 = g_bmya_1[l_ac2].bmyb05
                          IF cl_null(l_bmyb.bmyb04) THEN LET l_bmyb.bmyb04 = ' ' END IF
                          IF cl_null(l_bmyb.bmyb05) THEN LET l_bmyb.bmyb05 = ' ' END IF
                          INSERT INTO bmyb_file VALUES (l_bmyb.*)
                          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                             CALL cl_err3("ins","bmyb_file",g_bmy[l_ac].bmy05,"",
                                            SQLCA.sqlcode,"","",1)
                            #TQC-E90001--add str--
                             IF l_action = 'define_color_size' THEN
                                ROLLBACK WORK
                             END IF
                            #TQC-E90001--add end--
                             LET g_success = 'N'
                          END IF
                       END IF
                    END IF
                 END IF
              END IF  
              IF g_bmy[l_ac].bmy38 MATCHES '[56]' THEN 
                 IF NOT cl_null(g_bmya_1_t.bmyc03) THEN
                    UPDATE bmyc_file  SET bmyc04 = g_bmya_1[l_ac2].bmyc04
                     WHERE bmyc01 = g_bmx.bmx01
                       AND bmyc02 = g_bmy[l_ac].bmy02 
                       AND bmyc03 = g_bmya_1[l_ac2].bmyc03 
                 ELSE
                    IF NOT cl_null(g_bmya_1[l_ac2].bmyc04) THEN
                       LET l_bmyc.bmyc01 = g_bmx.bmx01
                       LET l_bmyc.bmyc02 = g_bmy[l_ac].bmy02
                      #SELECT COUNT(*) INTO l_n FROM bmyc_file                       #TQC-E90001 mark
                       SELECT MAX(bmyc03) INTO l_n FROM bmyc_file                    #TQC-E90001 modify
                        WHERE bmyc01 = g_bmx.bmx01 AND bmyc02 = g_bmy[l_ac].bmy02
                       IF cl_null(l_n) THEN LET l_n = 0 END IF                       #TQC-E90001 add
                       LET l_bmyc.bmyc03 = l_n + 1
                       LET l_bmyc.bmyc04 = g_bmya_1[l_ac2].bmyc04
                       IF cl_null(l_bmyc.bmyc04) THEN LET l_bmyc.bmyc04 = ' ' END IF
                       INSERT INTO bmyc_file VALUES (l_bmyc.*)
                       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                          CALL cl_err3("ins","bmyc_file",g_bmy[l_ac].bmy05,"",
                                         SQLCA.sqlcode,"","",1)
                         #TQC-E90001--add str--
                          IF l_action = 'define_color_size' THEN
                             ROLLBACK WORK
                          END IF
                         #TQC-E90001--add end--
                          LET g_success = 'N'
                       END IF
                    END IF
                 END IF
              END IF   
              IF g_bmy[l_ac].bmy38 MATCHES '[57]' THEN 
                 IF NOT cl_null(g_bmya_1_t.bmyd03) THEN
                    UPDATE bmyd_file  SET bmyd04 = g_bmya_1[l_ac2].bmyd04
                     WHERE bmyd01 = g_bmx.bmx01
                       AND bmyd02 = g_bmy[l_ac].bmy02 
                       AND bmyd03 = g_bmya_1[l_ac2].bmyd03 
                 ELSE 
                    IF NOT cl_null(g_bmya_1[l_ac2].bmyd04) THEN
                       LET l_bmyd.bmyd01 = g_bmx.bmx01
                       LET l_bmyd.bmyd02 = g_bmy[l_ac].bmy02
                      #SELECT COUNT(*) INTO l_n FROM bmyd_file                       #TQC-E90001 mark
                       SELECT MAX(bmyd03) INTO l_n FROM bmyd_file                    #TQC-E90001 modify
                        WHERE bmyd01 = g_bmx.bmx01 AND bmyd02 = g_bmy[l_ac].bmy02
                       IF cl_null(l_n) THEN LET l_n = 0 END IF                       #TQC-E90001 add
                       LET l_bmyd.bmyd03 = l_n + 1
                       LET l_bmyd.bmyd04 = g_bmya_1[l_ac2].bmyd04
                       IF cl_null(l_bmyd.bmyd04) THEN LET l_bmyd.bmyd04 = ' ' END IF
                       INSERT INTO bmyd_file VALUES (l_bmyd.*)
                       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                          CALL cl_err3("ins","bmyd_file",g_bmy[l_ac].bmy05,"",
                                         SQLCA.sqlcode,"","",1)
                         #TQC-E90001--add str--
                          IF l_action = 'define_color_size' THEN
                             ROLLBACK WORK
                          END IF
                         #TQC-E90001--add end--
                          LET g_success = 'N'
                       END IF
                    END IF
                 END IF
              END IF 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","",g_bmy[l_ac].bmy05,"",
                               SQLCA.sqlcode,"","",1)
                 LET g_bmya_1[l_ac].* = g_bmya_1_t.*
                 IF l_action = 'define_color_size' THEN       #TQC-E90001
                    ROLLBACK WORK
                 END IF                                       #TQC-E90001
                 LET g_success = 'N'                          #TQC-E90001
              ELSE
                #TQC-E90001--add str--
                 IF l_action = 'define_color_size' THEN
                    COMMIT WORK
                 END IF
                #TQC-E90001--add end--
                 MESSAGE 'UPDATE O.K'  
              END IF             
           END IF            

        BEFORE DELETE 

           IF NOT cl_null(g_bmya_1_t.bmya04) OR NOT cl_null(g_bmya_1_t.bmya05) OR
              NOT cl_null(g_bmya_1_t.bmyb04) OR NOT cl_null(g_bmya_1_t.bmyb05) OR
              NOT cl_null(g_bmya_1_t.bmyc04) OR NOT cl_null(g_bmya_1_t.bmyd04) THEN 
              IF NOT cl_delete() THEN
                 CANCEL DELETE
              END IF        
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF 
              IF g_bmy[l_ac].bmy38 MATCHES '[23]' THEN 
                 IF NOT cl_null(g_bmya_1_t.bmya04) AND NOT cl_null(g_bmya_1_t.bmya05) THEN
                    DELETE FROM bmya_file WHERE bmya01 = g_bmx.bmx01
                                            AND bmya02 = g_bmy[l_ac].bmy02
                                           #AND bmya03 = g_bmya_1[l_ac].bmya03    #TQC-E90001 mark
                                            AND bmya03 = g_bmya_1[l_ac2].bmya03   #TQC-E90001 modify
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","",g_bmy[l_ac].bmy03,"",
                                     SQLCA.sqlcode,"","",1)
                       LET g_bmya_1[l_ac].* = g_bmya_1_t.*
                       IF l_action = 'define_color_size' THEN                     #TQC-E90001
                          ROLLBACK WORK 
                       END IF                                                     #TQC-E90001
                       LET g_success = 'N'                                        #TQC-E90001
                       CANCEL DELETE  
                    END IF                                           
                 END IF
              END IF  
              IF g_bmy[l_ac].bmy38 MATCHES '[24]' THEN 
                 DELETE FROM bmyb_file WHERE bmyb01 = g_bmx.bmx01
                                         AND bmyb02 = g_bmy[l_ac].bmy02
                                        #AND bmyb03 = g_bmya_1[l_ac].bmyb03       #TQC-E90001 mark
                                         AND bmyb03 = g_bmya_1[l_ac2].bmyb03      #TQC-E90001 modify
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","",g_bmy[l_ac].bmy03,"",
                                  SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'              
                    LET g_bmya_1[l_ac].* = g_bmya_1_t.*
                    IF l_action = 'define_color_size' THEN                        #TQC-E90001
                       ROLLBACK WORK 
                    END IF                                                        #TQC-E90001
                    CANCEL DELETE  
                 END IF                                          
              END IF 
              IF g_bmy[l_ac].bmy38 MATCHES '[56]' THEN 
                 DELETE FROM bmyc_file WHERE bmyc01 = g_bmx.bmx01
                                         AND bmyc02 = g_bmy[l_ac].bmy02
                                        #AND bmyc03 = g_bmya_1[l_ac].bmyc03       #TQC-E90001 mark
                                         AND bmyc03 = g_bmya_1[l_ac2].bmyc03      #TQC-E90001 modify
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","",g_bmy[l_ac].bmy03,"",
                                  SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'               
                    LET g_bmya_1[l_ac].* = g_bmya_1_t.*
                    IF l_action = 'define_color_size' THEN                        #TQC-E90001
                       ROLLBACK WORK 
                    END IF                                                        #TQC-E90001
                    CANCEL DELETE  
                 END IF                                          
              END IF  
              IF g_bmy[l_ac].bmy38 MATCHES '[57]' THEN 
                 DELETE FROM bmyd_file WHERE bmyd01 = g_bmx.bmx01
                                         AND bmyd02 = g_bmy[l_ac].bmy02
                                        #AND bmyd03 = g_bmya_1[l_ac].bmyd03       #TQC-E90001 mark
                                         AND bmyd03 = g_bmya_1[l_ac2].bmyd03      #TQC-E90001 modify
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","",g_bmy[l_ac].bmy03,"",
                                  SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'               
                    LET g_bmya_1[l_ac].* = g_bmya_1_t.*
                    IF l_action = 'define_color_size' THEN                        #TQC-E90001
                       ROLLBACK WORK 
                    END IF                                                        #TQC-E90001
                    CANCEL DELETE  
                 END IF                                          
              END IF    
              IF g_success = 'N'  THEN
                  CALL cl_err3("del","",g_bmy[l_ac].bmy03,"",
                                SQLCA.sqlcode,"","",1)                                
                  LET g_bmya_1[l_ac].* = g_bmya_1_t.*
                  IF l_action = 'define_color_size' THEN                          #TQC-E90001
                     ROLLBACK WORK 
                  END IF                                                          #TQC-E90001
                  CANCEL DELETE  
              ELSE 
              #  COMMIT WORK              
                #TQC-E90001--add str--
                 IF l_action = 'define_color_size' THEN
                    COMMIT WORK
                 END IF
                #TQC-E90001--add end--
                 LET g_rec_b_2=g_rec_b_2-1
                 DISPLAY g_rec_b_2 TO FORMONLY.cn1         
              END IF                         
           END IF    
              
        AFTER ROW
            LET l_ac2 = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_bmya_1[l_ac2].* = g_bmya_1_t.*
               ELSE
                  CALL g_bmya_1.deleteElement(l_ac2)
                  IF g_rec_b_2 != 0 THEN
                  #  LET g_action_choice = "detail"
                     LET l_ac2 = l_ac_t2
                  END IF
               END IF
               IF g_bmy[l_ac].bmy38 MATCHES '[23]' AND NOT cl_null(g_bmya_1_t.bmya03) THEN 
                  CLOSE i710_bcl_1
               END IF
               IF g_bmy[l_ac].bmy38 MATCHES '[24]' AND NOT cl_null(g_bmya_1_t.bmyb03) THEN 
                  CLOSE i710_bcl_2
               END IF 
               IF g_bmy[l_ac].bmy38 MATCHES '[56]' AND NOT cl_null(g_bmya_1_t.bmyc03) THEN 
                  CLOSE i710_bcl_3
               END IF
               IF g_bmy[l_ac].bmy38 MATCHES '[57]' AND NOT cl_null(g_bmya_1_t.bmyd03) THEN 
                  CLOSE i710_bcl_4
               END IF
               IF l_action = 'define_color_size' THEN                        #TQC-E90001
                  ROLLBACK WORK
               END IF
               LET g_success = 'N'                                           #TQC-E90001
               EXIT INPUT
            END IF
            IF l_ac2 <= g_bmya_1.getLength() THEN                            #TQC-E90001
               LET l_ac_t2 = l_ac2      
               LET g_bmya_1_t.* = g_bmya_1[l_ac2].*
               IF g_bmy[l_ac].bmy38 MATCHES '[23]' AND NOT cl_null(g_bmya_1_t.bmya03) THEN 
                  CLOSE i710_bcl_1
               END IF
               IF g_bmy[l_ac].bmy38 MATCHES '[24]' AND NOT cl_null(g_bmya_1_t.bmyb03) THEN 
                  CLOSE i710_bcl_2
               END IF 
               IF g_bmy[l_ac].bmy38 MATCHES '[56]' AND NOT cl_null(g_bmya_1_t.bmyc03) THEN 
                  CLOSE i710_bcl_3
               END IF
               IF g_bmy[l_ac].bmy38 MATCHES '[57]' AND NOT cl_null(g_bmya_1_t.bmyd03) THEN 
                  CLOSE i710_bcl_4
               END IF
            END IF                                                           #TQC-E90001
      ON ACTION controlp

           CASE
              WHEN INFIELD(bmya04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = g_ima940
                 LET g_qryparam.form ="q_agd"
                 CALL cl_create_qry() RETURNING g_bmya_1[l_ac2].bmya04
                 SELECT agd03 INTO g_bmya_1[l_ac2].bmya04_des FROM ima_file,agd_file
                  WHERE agd01 = ima940
                    AND ima01 = g_bmz[1].bmz02
                    AND agd02 = g_bmya_1[l_ac2].bmya04
                 DISPLAY BY NAME g_bmya_1[l_ac2].bmya04,g_bmya_1[l_ac2].bmya04_des
                 NEXT FIELD bmya04
              WHEN INFIELD(bmya05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = g_ima940_1
                 LET g_qryparam.form ="q_agd"
                 CALL cl_create_qry() RETURNING g_bmya_1[l_ac2].bmya05
                 SELECT agd03 INTO g_bmya_1[l_ac2].bmya05_des FROM ima_file,agd_file
                  WHERE agd01 = ima940
                    AND ima01 = g_bmy[l_ac].bmy05 
                    AND agd02 = g_bmya_1[l_ac2].bmya05
                 DISPLAY BY NAME g_bmya_1[l_ac2].bmya05,g_bmya_1[l_ac2].bmya05_des
                 NEXT FIELD bmya05
              WHEN INFIELD(bmyb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = g_ima941
                 LET g_qryparam.form ="q_agd"
                 CALL cl_create_qry() RETURNING g_bmya_1[l_ac2].bmyb04
                 SELECT agd03 INTO g_bmya_1[l_ac2].bmyb04_des FROM ima_file,agd_file
                  WHERE agd01 = ima941
                    AND ima01 = g_bmz[1].bmz02
                    AND agd02 = g_bmya_1[l_ac2].bmyb04
                 DISPLAY BY NAME g_bmya_1[l_ac2].bmyb04,g_bmya_1[l_ac2].bmyb04_des
                 NEXT FIELD bmyb04
              WHEN INFIELD(bmyb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = g_ima941_1
                 LET g_qryparam.form ="q_agd"
                 CALL cl_create_qry() RETURNING g_bmya_1[l_ac2].bmyb05
                 SELECT agd03 INTO g_bmya_1[l_ac2].bmyb05_des FROM ima_file,agd_file
                  WHERE agd01 = ima941
                    AND ima01 = g_bmy[l_ac].bmy05 
                    AND agd02 = g_bmya_1[l_ac2].bmyb05
                 DISPLAY BY NAME g_bmya_1[l_ac2].bmyb05,g_bmya_1[l_ac2].bmyb05_des
                 NEXT FIELD bmyb05
              WHEN INFIELD(bmyc04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = g_ima940
                 LET g_qryparam.form ="q_agd"
                 CALL cl_create_qry() RETURNING g_bmya_1[l_ac2].bmyc04
                 SELECT agd03 INTO g_bmya_1[l_ac2].bmyc04_des FROM ima_file,agd_file
                  WHERE agd01 = ima940
                    AND ima01 = g_bmz[1].bmz02
                    AND agd02 = g_bmya_1[l_ac2].bmyc04
                 DISPLAY BY NAME g_bmya_1[l_ac2].bmyc04,g_bmya_1[l_ac2].bmyc04_des
                 NEXT FIELD bmyc04
              WHEN INFIELD(bmyd04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = g_ima941
                 LET g_qryparam.form ="q_agd"
                 CALL cl_create_qry() RETURNING g_bmya_1[l_ac2].bmyd04
                 SELECT agd03 INTO g_bmya_1[l_ac2].bmyd04_des FROM ima_file,agd_file
                  WHERE agd01 = ima941
                    AND ima01 = g_bmz[1].bmz02
                    AND agd02 = g_bmya_1[l_ac2].bmyd04
                 DISPLAY BY NAME g_bmya_1[l_ac2].bmyd04,g_bmya_1[l_ac2].bmyd04_des
                 NEXT FIELD bmyd04

           END CASE


      ON ACTION CONTROLG
          CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

   END INPUT   
   CLOSE WINDOW i710_b_w
END FUNCTION

FUNCTION i710_bmyx_chk()
DEFINE  l_sql1,l_sql2,l_sql3,l_sql4    STRING 
DEFINE  l_cnt1,l_cnt2                  LIKE type_file.num5

   IF (NOT cl_null(g_bmx.bmx01) AND NOT cl_null(g_bmy[l_ac].bmy02) AND 
      NOT cl_null(g_bmy[l_ac].bmy05)) OR 
      (NOT cl_null(g_bmya_1[l_ac2].bmya04) OR NOT cl_null(g_bmya_1[l_ac2].bmya05) OR 
       NOT cl_null(g_bmya_1[l_ac2].bmyb04) OR NOT cl_null(g_bmya_1[l_ac2].bmyb05) OR 
       NOT cl_null(g_bmya_1[l_ac2].bmyc04) OR NOT cl_null(g_bmya_1[l_ac2].bmyd04))
       THEN
      LET l_sql1 = "SELECT COUNT(*) FROM bmya_file",
                   " WHERE bmya01 = '",g_bmx.bmx01,"' ",
                   "   AND bmya02 = '",g_bmy[l_ac].bmy02,"' ",
                   "   AND bmya04 =  '",g_bmya_1[l_ac2].bmya04,"' ",
                   "   AND bmya04 <> '",g_bmya_1_t.bmya04,"' "
       
      LET l_sql2 = "SELECT COUNT(*) FROM bmyb_file",
                   " WHERE bmyb01 = '",g_bmx.bmx01,"' ",
                   "   AND bmyb02 = '",g_bmy[l_ac].bmy02,"' ",
		   "   AND bmyb04 =  '",g_bmya_1[l_ac2].bmyb04,"' ",
                   "   AND bmyb04 <> '",g_bmya_1_t.bmyb04,"' "

      LET l_sql3 = "SELECT COUNT(*) FROM bmyc_file",
                   " WHERE bmyc01 = '",g_bmx.bmx01,"' ",
                   "   AND bmyc02 = '",g_bmy[l_ac].bmy02,"' ",
                   "   AND bmyc04 = '",g_bmya_1[l_ac2].bmyc04,"' ",
                   "   AND bmyc04 <> '",g_bmya_1_t.bmyc04,"' "
       
      LET l_sql4 = "SELECT COUNT(*) FROM bmyd_file",
                   " WHERE bmyd01 = '",g_bmx.bmx01,"' ",
                   "   AND bmyd02 = '",g_bmy[l_ac].bmy02,"' ",
                   "   AND bmyd04 = '",g_bmya_1[l_ac2].bmyd04,"' ",
                   "   AND bmyd04 <> '",g_bmya_1_t.bmyd04,"' "
       
      IF g_bmy[l_ac].bmy38 MATCHES '[234]' THEN 
         LET l_cnt1 = 0
         LET l_cnt2 = 0
         IF g_bmy[l_ac].bmy38 MATCHES '[23]' AND NOT cl_null(g_bmya_1[l_ac2].bmya04) THEN 
            PREPARE i710_bmya FROM l_sql1
            EXECUTE i710_bmya INTO l_cnt1                      
            IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
            IF l_cnt1 > 0 THEN 
               CALL cl_err('','abm-138',1)
               RETURN FALSE 
            END IF
         END IF  
         IF g_bmy[l_ac].bmy38 MATCHES '[24]' AND NOT cl_null(g_bmya_1[l_ac2].bmyb04) THEN 
            PREPARE i710_bmyb FROM l_sql2
            EXECUTE i710_bmyb INTO l_cnt2                      
            IF cl_null(l_cnt2) THEN LET l_cnt2 = 0 END IF
            IF l_cnt2 > 0 THEN 
               CALL cl_err('','abm-139',1)
               RETURN FALSE 
            END IF            
         END IF 
         IF g_bmy[l_ac].bmy38 MATCHES '[23]' AND NOT cl_null(g_bmya_1[l_ac2].bmya04) AND NOT cl_null(g_bmya_1[l_ac2].bmya05) THEN 
            LET l_sql1 = l_sql1, " AND bmya05 = '",g_bmya_1[l_ac2].bmya05,"' "
            PREPARE i710_bmya_2 FROM l_sql1
            EXECUTE i710_bmya_2 INTO l_cnt1                      
            IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
            IF l_cnt1 > 0 THEN 
               CALL cl_err('','abm-138',1)
               RETURN FALSE 
            END IF
         END IF  
         IF g_bmy[l_ac].bmy38 MATCHES '[24]' AND NOT cl_null(g_bmya_1[l_ac2].bmyb04) AND NOT cl_null(g_bmya_1[l_ac2].bmyb05) THEN 
            LET l_sql2 = l_sql2, " AND bmyb05 = '",g_bmya_1[l_ac2].bmyb05,"' "
            PREPARE i710_bmyb_2 FROM l_sql2
            EXECUTE i710_bmyb_2 INTO l_cnt2                      
            IF cl_null(l_cnt2) THEN LET l_cnt2 = 0 END IF
            IF l_cnt2 > 0 THEN 
               CALL cl_err('','abm-139',1)
               RETURN FALSE 
            END IF            
         END IF              
      END IF  
      
      IF g_bmy[l_ac].bmy38 MATCHES '[567]' THEN 
         LET l_cnt1 = 0
         LET l_cnt2 = 0
         IF g_bmy[l_ac].bmy38 MATCHES '[56]' AND NOT cl_null(g_bmya_1[l_ac2].bmyc04) THEN 
            PREPARE i710_bmyc FROM l_sql3
            EXECUTE i710_bmyc INTO l_cnt1                      
            IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
            IF l_cnt1 > 0 THEN
               CALL cl_err('','abm-138',1)
               RETURN FALSE 
            END IF
         END IF  
         IF g_bmy[l_ac].bmy38 MATCHES '[57]' AND NOT cl_null(g_bmya_1[l_ac2].bmyd04) THEN 
            PREPARE i710_bmyd FROM l_sql4
            EXECUTE i710_bmyd INTO l_cnt2                      
            IF cl_null(l_cnt2) THEN LET l_cnt2 = 0 END IF
            IF l_cnt2 > 0 THEN 
               CALL cl_err('','abm-139',1)
               RETURN FALSE 
            END IF            
         END IF              
      END IF      
   END IF    
   RETURN TRUE 
END FUNCTION 

#檢查顏色
FUNCTION i710_bmya04_chk(p_color,p_ima940)
DEFINE  p_color    LIKE bmya_file.bmya04
DEFINE  p_ima940   LIKE ima_file.ima940
DEFINE  l_cnt      LIKE type_file.num5
DEFINE  l_agc04    LIKE agc_file.agc04
DEFINE  l_agc05    LIKE agc_file.agc05
DEFINE  l_agc06    LIKE agc_file.agc06

   IF NOT cl_null(p_color) THEN
      SELECT agc04,agc05,agc06 INTO l_agc04,l_agc05,l_agc06 FROM agc_file
       WHERE agc01 = p_ima940 
         AND agc07 = '1'
      IF l_agc04 = '2' THEN
         SELECT COUNT(*) INTO l_cnt FROM agc_file,agd_file
          WHERE agc01 = agd01
            AND agc01 = p_ima940 
            AND agc07 = '1'
            AND agd02 = p_color 
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
         IF l_cnt < 1 THEN
            RETURN FALSE 
         END IF
      END IF
      IF l_agc04 = '3' THEN
         IF p_color > = l_agc05 AND p_color <= l_agc06 THEN
            RETURN TRUE
         ELSE
            RETURN FALSE
         END IF 
      END IF
      RETURN TRUE 
   END IF
END FUNCTION

#檢查尺寸
FUNCTION i710_bmyb04_chk(p_size,p_ima941)
DEFINE  p_size    LIKE bmyb_file.bmyb04
DEFINE  p_ima941   LIKE ima_file.ima941
DEFINE  l_cnt      LIKE type_file.num5
DEFINE  l_agc04    LIKE agc_file.agc04
DEFINE  l_agc05    LIKE agc_file.agc05
DEFINE  l_agc06    LIKE agc_file.agc06

   IF NOT cl_null(p_size) THEN
      SELECT agc04,agc05,agc06 INTO l_agc04,l_agc05,l_agc06 FROM agc_file
       WHERE agc01 = p_ima941
         AND agc07 = '2'
      IF l_agc04 = '2' THEN
         SELECT COUNT(*) INTO l_cnt FROM agc_file,agd_file
          WHERE agc01 = agd01
            AND agc01 = p_ima941
            AND agc07 = '2'
            AND agd02 = p_size
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
         IF l_cnt < 1 THEN
            RETURN FALSE 
         END IF
      END IF
      IF l_agc04 = '3' THEN
         IF p_size > = l_agc05 AND p_size <= l_agc06 THEN
            RETURN TRUE 
         ELSE
            RETURN FALSE 
         END IF
      END IF
      RETURN TRUE 
   END IF
END FUNCTION

FUNCTION i710_set_b_no_required() 
   CALL cl_set_comp_required("bmya04,bmya05,bmyb04,bmyb05,bmyc04,bmyd04",FALSE)    
END FUNCTION    
 
FUNCTION i710_set_b_required() 
#  IF g_bmy[l_ac].bmy38 = '2' THEN
#     CALL cl_set_comp_required("bmya04,bmya05,bmyb04,bmyb05",TRUE) 
#  END IF  
   IF g_bmy[l_ac].bmy38 = '3' THEN
      CALL cl_set_comp_required("bmya04,bmya05",TRUE) 
   END IF 
   IF g_bmy[l_ac].bmy38 = '4' THEN
      CALL cl_set_comp_required("bmyb04,bmyb05",TRUE) 
   END IF 
#   IF g_bmy[l_ac].bmy38 = '5' THEN
#      CALL cl_set_comp_required("bmyc04,bmyd04",TRUE) 
#   END IF 
   IF g_bmy[l_ac].bmy38 = '6' THEN
      CALL cl_set_comp_required("bmyc04",TRUE) 
   END IF  
   IF g_bmy[l_ac].bmy38 = '7' THEN
      CALL cl_set_comp_required("bmyd04",TRUE) 
   END IF      
END FUNCTION           

FUNCTION i710_chk_bmy38()
   IF g_ima943_1 = '3' THEN
      IF g_bmy[l_ac].bmy38 != '2' THEN
         CALL cl_err_msg('','abm-131','2',1)
         RETURN FALSE 
      END IF
   END IF
   IF g_ima943_1 = '1' THEN 
      IF g_bmy[l_ac].bmy38 != '3' THEN 
         CALL cl_err_msg('','abm-131','3',1)
         RETURN FALSE 
      END IF
   END IF 
   IF g_ima943_1 = '2' THEN
      IF g_bmy[l_ac].bmy38 != '4' THEN 
         CALL cl_err_msg('','abm-131','4',1)
         RETURN FALSE 
      END IF
   END IF
   IF g_ima943_1 = '4' OR cl_null(g_ima943_1) THEN
      IF g_ima943 = '3' THEN
         IF g_bmy[l_ac].bmy38 NOT MATCHES '[1567]' THEN
            CALL cl_err_msg('','abm-131','1/5/6/7',1)
            RETURN FALSE 
         END IF
      END IF
      IF g_ima943 MATCHES '[1]' THEN
         IF g_bmy[l_ac].bmy38 NOT MATCHES '[16]' THEN 
            CALL cl_err_msg('','abm-131','1/6',1)
            RETURN FALSE 
         END IF
      END IF 
      IF g_ima943 MATCHES '[2]' THEN
         IF g_bmy[l_ac].bmy38 NOT MATCHES '[17]' THEN 
            CALL cl_err_msg('','abm-131','1/7',1)
            RETURN FALSE 
         END IF
      END IF
   END IF 
   RETURN TRUE
END FUNCTION

FUNCTION i710_bmyx_b_fill()
DEFINE  l_cnt     LIKE type_file.num10,
        l_cnt1    LIKE type_file.num10,
        l_cnt2    LIKE type_file.num10,
        l_sql     STRING,
        l_sql1    STRING,
        l_sql2    STRING 

   IF g_bmy[l_ac].bmy38 MATCHES '[3467]' THEN
      IF g_bmy[l_ac].bmy38 = '3' THEN
         LET l_sql = "SELECT bmya03,bmya04,'',bmya05,'','','','','','','','','','','','' FROM bmya_file ",
                     " WHERE bmya01 = '",g_bmx.bmx01,"'",
                     "   AND bmya02 = '",g_bmy[l_ac].bmy02,"'"
      END IF
      IF g_bmy[l_ac].bmy38 = '4' THEN
         LET l_sql = "SELECT '','','','','',bmyb03,bmyb04,'',bmyb05,'','','','','','','' FROM bmyb_file ",
                     " WHERE bmyb01 = '",g_bmx.bmx01,"'",
                     "   AND bmyb02 = '",g_bmy[l_ac].bmy02,"'"
      END IF
      IF g_bmy[l_ac].bmy38 = '6' THEN
         LET l_sql = "SELECT '','','','','','','','','','',bmyc03,bmyc04,'','','','' FROM bmyc_file ",
                     " WHERE bmyc01 = '",g_bmx.bmx01,"'",
                     "   AND bmyc02 = '",g_bmy[l_ac].bmy02,"'"
      END IF
      IF g_bmy[l_ac].bmy38 = '7' THEN
         LET l_sql = "SELECT '','','','','','','','','','','','','',bmyd03,bmyd04,'' FROM bmyd_file ",
                     " WHERE bmyd01 = '",g_bmx.bmx01,"'",
                     "   AND bmyd02 = '",g_bmy[l_ac].bmy02,"'"
      END IF
      PREPARE i710_pr01 FROM l_sql
      DECLARE i710_curs01 CURSOR FOR i710_pr01
   END IF
   CALL g_bmya_1.clear()  #TQC-E90001
   IF g_bmy[l_ac].bmy38 = '2' THEN
      LET l_sql1 = "SELECT bmya03,bmya04,'',bmya05,'','','','','','','','','','','','' FROM bmya_file ",
                  " WHERE bmya01 = '",g_bmx.bmx01,"'",
                  "   AND bmya02 = '",g_bmy[l_ac].bmy02,"'"
      PREPARE i710_pr02 FROM l_sql1
      DECLARE i710_curs02 CURSOR FOR i710_pr02
      LET l_sql2 = "SELECT bmyb03,bmyb04,bmyb05 FROM bmyb_file ",
                  " WHERE bmyb01 = '",g_bmx.bmx01,"'",
                  "   AND bmyb02 = '",g_bmy[l_ac].bmy02,"'"
      PREPARE i710_pr03 FROM l_sql2
      DECLARE i710_curs03 CURSOR FOR i710_pr03
      LET l_cnt1 = 1
      FOREACH i710_curs02 INTO g_bmya_1[l_cnt1].*
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         SELECT agd03 INTO g_bmya_1[l_cnt1].bmya04_des FROM ima_file,agd_file
          WHERE agd01 = ima940
            AND ima01 = g_bmz[1].bmz02
            AND agd02 = g_bmya_1[l_cnt1].bmya04
         SELECT agd03 INTO g_bmya_1[l_cnt1].bmya05_des FROM ima_file,agd_file
          WHERE agd01 = ima940
            AND ima01 = g_bmy[l_ac].bmy05 
            AND agd02 = g_bmya_1[l_cnt1].bmya05
         LET l_cnt1 = l_cnt1 + 1
         IF l_cnt1 > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
         END IF
      END FOREACH
      LET l_cnt2 = 1
      FOREACH i710_curs03 INTO g_bmya_1[l_cnt2].bmyb03,g_bmya_1[l_cnt2].bmyb04,g_bmya_1[l_cnt2].bmyb05
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         SELECT agd03 INTO g_bmya_1[l_cnt2].bmyb04_des FROM ima_file,agd_file
          WHERE agd01 = ima941
            AND ima01 = g_bmz[1].bmz02
            AND agd02 = g_bmya_1[l_cnt2].bmyb04
         SELECT agd03 INTO g_bmya_1[l_cnt2].bmyb05_des FROM ima_file,agd_file
          WHERE agd01 = ima941
            AND ima01 = g_bmy[l_ac].bmy05
            AND agd02 = g_bmya_1[l_cnt2].bmyb05
         LET l_cnt2 = l_cnt2 + 1
         IF l_cnt2 > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
         END IF
      END FOREACH
      IF l_cnt1 > l_cnt2 THEN
         CALL g_bmya_1.deleteElement(l_cnt1)
         LET g_rec_b_2=l_cnt1 - 1
      ELSE
         CALL g_bmya_1.deleteElement(l_cnt2)
         LET g_rec_b_2=l_cnt2 - 1
      END IF
   END IF 
   IF g_bmy[l_ac].bmy38 = '5' THEN
      LET l_sql1 = "SELECT '','','','','','','','','','',bmyc03,bmyc04,'','','','' FROM bmyc_file ",
                  " WHERE bmyc01 = '",g_bmx.bmx01,"'",
                  "   AND bmyc02 = '",g_bmy[l_ac].bmy02,"'"
      PREPARE i710_pr05 FROM l_sql1
      DECLARE i710_curs05 CURSOR FOR i710_pr05
      LET l_sql2 = "SELECT bmyd03,bmyd04 FROM bmyd_file ",
                  " WHERE bmyd01 = '",g_bmx.bmx01,"'",
                  "   AND bmyd02 = '",g_bmy[l_ac].bmy02,"'"
      PREPARE i710_pr06 FROM l_sql2
      DECLARE i710_curs06 CURSOR FOR i710_pr06
      LET l_cnt1 = 1
      FOREACH i710_curs05 INTO g_bmya_1[l_cnt1].*
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         SELECT agd03 INTO g_bmya_1[l_cnt1].bmyc04_des FROM ima_file,agd_file
          WHERE agd01 = ima940 
            AND ima01 = g_bmz[1].bmz02
            AND agd02 = g_bmya_1[l_cnt1].bmyc04
         LET l_cnt1 = l_cnt1 + 1
         IF l_cnt1 > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
         END IF
      END FOREACH 
      LET l_cnt2 = 1
      FOREACH i710_curs06 INTO g_bmya_1[l_cnt2].bmyd03,g_bmya_1[l_cnt2].bmyd04
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         SELECT agd03 INTO g_bmya_1[l_cnt2].bmyd04_des FROM ima_file,agd_file
          WHERE agd01 = ima941
            AND ima01 = g_bmz[1].bmz02
            AND agd02 = g_bmya_1[l_cnt2].bmyd04
         LET l_cnt2 = l_cnt2 + 1
         IF l_cnt2 > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
         END IF
      END FOREACH
      IF l_cnt1 > l_cnt2 THEN
         CALL g_bmya_1.deleteElement(l_cnt1)
         LET g_rec_b_2=l_cnt1 - 1
      ELSE
         CALL g_bmya_1.deleteElement(l_cnt2)
         LET g_rec_b_2=l_cnt2 - 1
      END IF
   END IF

   LET l_cnt = 1
   IF g_bmy[l_ac].bmy38 MATCHES '[3467]' THEN
      FOREACH i710_curs01 INTO g_bmya_1[l_cnt].*
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         SELECT agd03 INTO g_bmya_1[l_cnt].bmya04_des FROM ima_file,agd_file
          WHERE agd01 = ima940
            AND ima01 = g_bmz[1].bmz02
            AND agd02 = g_bmya_1[l_cnt].bmya04
         SELECT agd03 INTO g_bmya_1[l_cnt].bmya05_des FROM ima_file,agd_file
          WHERE agd01 = ima940
            AND ima01 = g_bmy[l_ac].bmy05 
            AND agd02 = g_bmya_1[l_cnt].bmya05
         SELECT agd03 INTO g_bmya_1[l_cnt].bmyb04_des FROM ima_file,agd_file
          WHERE agd01 = ima941
            AND ima01 = g_bmz[1].bmz02
            AND agd02 = g_bmya_1[l_cnt].bmyb04
         SELECT agd03 INTO g_bmya_1[l_cnt].bmyb05_des FROM ima_file,agd_file
          WHERE agd01 = ima941
            AND ima01 = g_bmy[l_ac].bmy05 
            AND agd02 = g_bmya_1[l_cnt].bmyb05
         SELECT agd03 INTO g_bmya_1[l_cnt].bmyc04_des FROM ima_file,agd_file
          WHERE agd01 = ima940
            AND ima01 = g_bmz[1].bmz02
            AND agd02 = g_bmya_1[l_cnt].bmyc04
         SELECT agd03 INTO g_bmya_1[l_cnt].bmyd04_des FROM ima_file,agd_file
          WHERE agd01 = ima941
            AND ima01 = g_bmz[1].bmz02
            AND agd02 = g_bmya_1[l_cnt].bmyd04
         LET l_cnt = l_cnt + 1
         IF l_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
         END IF
      END FOREACH
      CALL g_bmya_1.deleteElement(l_cnt)
      LET g_rec_b_2=l_cnt - 1
   END IF

   DISPLAY g_rec_b_2 TO FORMONLY.cn1    #lixh1


   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmya_1 TO s_bmya_1.* ATTRIBUTE(COUNT=g_rec_b_2,UNBUFFERED)
      ON ACTION controlg
         CALL cl_cmdask()
         EXIT DISPLAY

      ON ACTION accept 
         IF g_bmx.bmx04 <>'N' THEN
            CALL cl_err(g_bmx.bmx01,'art-345',1)
         ELSE 
            EXIT DISPLAY
         END IF 

      ON ACTION detail
         EXIT DISPLAY

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DISPLAY
   END DISPLAY   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION  

FUNCTION i710_b_fill_slk()
      
    LET g_sql = "SELECT bmya04,'',bmya05,'' FROM bmya_file ",
                " WHERE bmya01 = '",g_bmx.bmx01,"'",
                "   AND bmya02 = '",g_bmy[l_ac].bmy02,"'"
         
    PREPARE i710_pb_a FROM g_sql
    DECLARE bmy_curs_a CURSOR FOR i710_pb_a
    
    CALL g_bmya_a.clear()
    LET g_cnt = 1
    LET g_rec_b3 = 0 
    FOREACH bmy_curs_a INTO g_bmya_a[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF    
      SELECT agd03 INTO g_bmya_a[g_cnt].bmya04_d FROM ima_file,agd_file
       WHERE agd01 = ima940
         AND ima01 = g_bmz[1].bmz02
         AND agd02 = g_bmya_a[g_cnt].bmya04
      SELECT agd03 INTO g_bmya_a[g_cnt].bmya05_d FROM ima_file,agd_file
       WHERE agd01 = ima940
         AND ima01 = g_bmy[l_ac].bmy05
         AND agd02 = g_bmya_a[g_cnt].bmya05   
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

    END FOREACH
    CALL g_bmya_a.deleteElement(g_cnt)
    LET g_rec_b3 = g_cnt - 1
    DISPLAY g_rec_b3 TO FORMONLY.cn2
    LET g_cnt = 0

    LET g_sql = "SELECT bmyb04,'',bmyb05,'' FROM bmyb_file ",
                " WHERE bmyb01 = '",g_bmx.bmx01,"'",
                "   AND bmyb02 = '",g_bmy[l_ac].bmy02,"'"
    PREPARE i710_pb_b FROM g_sql
    DECLARE bmy_curs_b
        CURSOR FOR i710_pb_b

    CALL g_bmyb_b.clear()
    LET g_cnt = 1
    LET g_rec_b4 = 0
    FOREACH bmy_curs_b INTO g_bmyb_b[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      SELECT agd03 INTO g_bmyb_b[g_cnt].bmyb04_d FROM ima_file,agd_file
       WHERE agd01 = ima941
         AND ima01 = g_bmz[1].bmz02
         AND agd02 = g_bmyb_b[g_cnt].bmyb04
         
      SELECT agd03 INTO g_bmyb_b[g_cnt].bmyb05_d FROM ima_file,agd_file
       WHERE agd01 = ima941
         AND ima01 = g_bmy[l_ac].bmy05 
         AND agd02 = g_bmyb_b[g_cnt].bmyb05
      
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN 
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
    END FOREACH
    CALL g_bmyb_b.deleteElement(g_cnt)
    LET g_rec_b4 = g_cnt - 1
    LET g_cnt = 0
    
    LET g_sql = "SELECT bmyc04,agd03 FROM bmyc_file,ima_file,agd_file ",
                " WHERE ima01 = '",g_bmz[1].bmz02,"' ",
                "   AND ima940 = agd01 ",
                "   AND bmyc04 = agd02 ",
                "   AND bmyc01 = '",g_bmx.bmx01,"'",
                "   AND bmyc02 = '",g_bmy[l_ac].bmy02,"'"
    
    PREPARE i710_pb_c FROM g_sql
    DECLARE bmy_curs_c CURSOR FOR i710_pb_c
    
    CALL g_bmyc_c.clear()
    LET g_cnt = 1
    LET g_rec_b4 = 0
    FOREACH bmy_curs_c INTO g_bmyc_c[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
     END IF

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

    END FOREACH
    CALL g_bmyc_c.deleteElement(g_cnt)
    LET g_rec_b5 = g_cnt - 1
    LET g_cnt = 0

    LET g_sql = "SELECT bmyd04,agd03 FROM bmyd_file,ima_file,agd_file ",
                " WHERE ima01  = '",g_bmz[1].bmz02,"' ",
                "   AND ima941 = agd01 ",
                "   AND bmyd04 = agd02 ",
                "   AND bmyd01 = '",g_bmx.bmx01,"'",
                "   AND bmyd02 = '",g_bmy[l_ac].bmy02,"'"

    PREPARE i710_pb_d FROM g_sql
    DECLARE bmy_curs_d CURSOR FOR i710_pb_d  

    CALL g_bmyd_d.clear()
    LET g_cnt = 1
    LET g_rec_b4 = 0
    FOREACH bmy_curs_d INTO g_bmyd_d[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF      

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

    END FOREACH
    CALL g_bmyd_d.deleteElement(g_cnt)
    LET g_rec_b6 = g_cnt - 1
    LET g_cnt = 0     
   
END FUNCTION

FUNCTION i710_bp_refresh_slk()
   DISPLAY ARRAY g_bmya_a TO s_bmya_a.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
   BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
   END DISPLAY  
   DISPLAY ARRAY g_bmyb_b TO s_bmyb_b.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
   BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
   END DISPLAY
   DISPLAY ARRAY g_bmyc_c TO s_bmyc_c.* ATTRIBUTE(COUNT=g_rec_b5,UNBUFFERED)
   BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
   END DISPLAY
   DISPLAY ARRAY g_bmyd_d TO s_bmyd_d.* ATTRIBUTE(COUNT=g_rec_b6,UNBUFFERED)
   BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
#FUN-D80022 ---------End-----------

#FUN-F50035 add str-----
FUNCTION i710_chk_vlr(p_type,p_bmx01,p_bmy02)
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
          AND (vlr03 = g_bmb.bmb02 OR vlr03 = 0)
          AND vlr19 = p_bmy02
    END IF

    RETURN l_cnt
END FUNCTION

FUNCTION i710_chk_vls(p_type,p_bmx01,p_bmy02)
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

FUNCTION i710_get_aps_temp_data(p_type)
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

FUNCTION i710_del_vmo()
  DEFINE l_cnt   LIKE type_file.num5

   LET l_cnt = 0
   CALL i710_chk_vlr('2',g_bmx.bmx01,b_bmy.bmy02) RETURNING l_cnt
   IF l_cnt > 0 THEN
      CALL i710_get_aps_temp_data('vlr')   #取得存在vlr_file的資料至b_vlr.*
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

FUNCTION i710_ins_vmo()
  DEFINE l_cnt   LIKE type_file.num5

    CALL i710_get_aps_temp_data('vlr')
    IF cl_null(b_vlr.vlr00) THEN   #若vlr_file沒有資料則不INSERT vmo_file
       RETURN
    END IF
    IF b_vlr.vlr03 = 0 THEN
       LET b_vlr.vlr03 = g_bmb.bmb02
    END IF
    INSERT INTO vmo_file (vmo01,vmo02,vmo03,vmo13,vmo16,vmo17,vmo18)
    VALUES(b_bmz.bmz02,b_vlr.vlr02,b_vlr.vlr03,b_vlr.vlr13,b_vlr.vlr16,b_vlr.vlr17,b_vlr.vlr18)
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       LET g_showmsg = g_bmx.bmx01,'ins vlr:'
       CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,SQLCA.sqlcode,1)
       LET g_success='N'
    END IF
END FUNCTION

FUNCTION i710_upd_vmo()
  DEFINE l_cnt   LIKE type_file.num5
  DEFINE l_vmo03 LIKE vmo_file.vmo03

    CALL i710_get_aps_temp_data('vlr')

    LET l_vmo03 = 0
    SELECT vmo03 INTO l_vmo03
      FROM vmo_file
     WHERE vmo01 = b_vlr.vlr01
       AND vmo02 = b_vlr.vlr02

    UPDATE vmo_file 
       SET vmo13 = b_vlr.vlr13,
           vmo16 = b_vlr.vlr16,
           vmo17 = b_vlr.vlr17,      
           vmo18 = b_vlr.vlr18      
     WHERE vmo01 = b_vlr.vlr01
       AND vmo02 = b_vlr.vlr02
       AND vmo03 = l_vmo03
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       LET g_showmsg = g_bmx.bmx01,'upd vmo:'
       CALL s_errmsg('bmb01',g_bmb.bmb01,g_showmsg,SQLCA.sqlcode,1)
       LET g_success='N'
    END IF
END FUNCTION

FUNCTION i710_upd_vmq()
  DEFINE l_cnt   LIKE type_file.num5

   #若變異別為'6'，則g_bmb會沒有值，故需另外給值
    IF b_bmy.bmy03 = '6' THEN
       LET g_bmb.bmb01 = b_bmz.bmz02
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
       CALL i710_get_aps_temp_data('vls')
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
#MOD-FA0119--add--start------------------------------------------------------------------
#傳入修改前後的項次,連動更新相關的表單 p_ima01(料號),p_bmy38(屬性設置),p_bmy02a(新值),p_bmy02b(舊值)
FUNCTION i710_upd_bmyc_slk(p_ima01,p_bmy38,p_bmy02a,p_bmy02b)
DEFINE p_ima01    LIKE ima_file.ima01
DEFINE p_bmy38    LIKE bmy_file.bmy38
DEFINE p_bmy02a   LIKE bmy_file.bmy02
DEFINE p_bmy02b   LIKE bmy_file.bmy02
DEFINE l_ima943   LIKE ima_file.ima943   #屬性組控管
DEFINE l_cnt      LIKE type_file.num5

   SELECT ima943 INTO l_ima943 FROM ima_file
    WHERE ima01 = p_ima01 AND imaacti='Y' AND ima1010='1'  #檢查料件
   IF l_ima943 = '4' OR cl_null(l_ima943) THEN
      RETURN 
   END IF

   IF p_bmy38 MATCHES '[23]' THEN
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM bmya_file
       WHERE bmya01 = g_bmx.bmx01       #ECN單號
         AND bmya02 = p_bmy02b          #ECN項次

      IF l_cnt > 0 THEN
         UPDATE bmya_file SET bmya02 = p_bmy02a
          WHERE bmya01 = g_bmx.bmx01       #ECN單號
            AND bmya02 = p_bmy02b          #ECN項次         
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","bmya_file",p_bmy02a,"",SQLCA.sqlcode,"","",1)
         END IF   
      END IF
   END IF
   IF p_bmy38 MATCHES '[24]' THEN
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM bmyb_file
       WHERE bmyb01 = g_bmx.bmx01       #ECN單號
         AND bmyb02 = p_bmy02b          #ECN項次
        
      IF l_cnt > 0 THEN
         UPDATE bmyb_file SET bmyb02 = p_bmy02a
          WHERE bmyb01 = g_bmx.bmx01       #ECN單號
            AND bmyb02 = p_bmy02b          #ECN項次         
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","bmyb_file",p_bmy02a,"",SQLCA.sqlcode,"","",1)
         END IF   
      END IF
   END IF
   IF p_bmy38 MATCHES '[56]' THEN
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM bmyc_file
       WHERE bmyc01 = g_bmx.bmx01       #ECN單號
         AND bmyc02 = p_bmy02b          #ECN項次
        
      IF l_cnt > 0 THEN
         UPDATE bmyc_file SET bmyc02 = p_bmy02a
          WHERE bmyc01 = g_bmx.bmx01       #ECN單號
            AND bmyc02 = p_bmy02b          #ECN項次         
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","bmyc_file",p_bmy02a,"",SQLCA.sqlcode,"","",1)
         END IF   
      END IF
   END IF
   IF p_bmy38 MATCHES '[57]' THEN
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM bmyd_file
       WHERE bmyd01 = g_bmx.bmx01       #ECN單號
         AND bmyd02 = p_bmy02b          #ECN項次
        
      IF l_cnt > 0 THEN
         UPDATE bmyd_file SET bmyd02 = p_bmy02a
          WHERE bmyd01 = g_bmx.bmx01       #ECN單號
            AND bmyd02 = p_bmy02b          #ECN項次         
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","bmyd_file",p_bmy02a,"",SQLCA.sqlcode,"","",1)
         END IF   
      END IF
   END IF
   
END FUNCTION
#MOD-FA0119--add--end--------------------------------------------------------------------

#MOD-G90008---add---str---
FUNCTION i710_get_ori_bmb06()
   DEFINE l_bmy		RECORD LIKE bmy_file.*
   DEFINE l_bmb		RECORD LIKE bmb_file.*
   DEFINE l_bmt		RECORD LIKE bmt_file.*
 
   INITIALIZE l_bmy.* TO NULL 
 
   SELECT * INTO l_bmy.* FROM bmy_file
    WHERE bmy01 = g_bmx.bmx01
      AND bmy02 = g_bmy[l_ac].bmy02
 
   #邏輯同FUNCTION i710_g_bmw()
   IF NOT cl_null(l_bmy.bmy04) THEN
      SELECT (bmb06/bmb07) INTO g_amt FROM bmb_file 
       WHERE bmb01 = g_bmz[1].bmz02
         AND bmb29 = g_bmz[1].bmz05 
         AND bmb02 = l_bmy.bmy04
         AND bmb03 = g_bmy[l_ac].bmy05  
         AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                       WHERE bmb01 = g_bmz[1].bmz02
                         AND bmb29 = g_bmz[1].bmz05 
                         AND bmb02 = g_bmy[l_ac].bmy04   
                         AND bmb03 = g_bmy[l_ac].bmy05)  
   ELSE
      SELECT (bmb06/bmb07) INTO g_amt FROM bmb_file                     
       WHERE bmb01 = g_bmz[1].bmz02
         AND bmb29 = g_bmz[1].bmz05 
         AND bmb03 = g_bmy[l_ac].bmy05  
         AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                       WHERE bmb01 = g_bmz[1].bmz02
                         AND bmb29 = g_bmz[1].bmz05 
                         AND bmb03 = g_bmy[l_ac].bmy05)   
   END IF
END FUNCTION

#MOD-G90008---add---end---

#M014 180202 By TSD.Andy -----(S)
FUNCTION i710_i_set_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1   
    CALL cl_set_comp_entry("ta_bmx02",TRUE)
END FUNCTION

FUNCTION i710_i_set_no_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1    
    IF g_bmx.ta_bmx01 = 'Y' THEN
    ELSE
        CALL cl_set_comp_entry("ta_bmx02",FALSE)
    END IF

   ##--- 20230208 add by momo (S) ta_bmx03 卡必填
   CALL cl_set_comp_required("ta_bmx03",TRUE)
   ##--- 20230208 add by momo (E)

END FUNCTION
#M014 180202 By TSD.Andy -----(E)
