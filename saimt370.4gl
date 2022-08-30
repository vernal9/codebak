# Prog. Version..: '5.30.24-17.04.13(00000)'     #
#
# Pattern name...: saimt370.4gl
# Descriptions...: 庫存雜收雜發報廢作業
# Date & Author..: 95/03/20 By Roger
# Modify.........: 95/04/12 By Danny (判斷是否使用保稅系統)
# Modify.........: 95/07/05 By Danny (判斷倉庫類別'S','W')
#                  將 update 過帳碼之動作移至所有 transaction 之後  By Melody
# Modify.........: 97/07/24 By Melody CHECK sma894 是否庫存可扣至負數
# Modify.........: No:7824 03/08/18 By Mandy 單身 ^I 直接跳到單位欄位此動作因與 TAB鍵衝突,將該 ^I 功能拿掉
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: No:9742 04/07/09 By Mandy  因為輸入倉庫後有控管為S: 一般性倉庫或W: 在製品倉庫  WIP,所以在倉庫的地方開窗也要依飫w作業開倉庫類別為'S'的倉庫, WIP作業開倉庫類別為'W'的倉庫
# Modify.........: No.MOD-480181 04/08/19 By Nicola 新增單身時，手冊編號沒有控管到，及將品名規格放在料號後面
# Modify.........: No.MOD-490038 04/09/02 By Smapmin 加入inb09不可小於零的限制
# Modify.........: No.MOD-490208 04/09/16 By Nicola 單身Control-o複製放棄時，資料應清空
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4A0057 04/10/05 By Yuna 查詢時, 單據編號應開出單據單號而不是單據別
# Modify.........: No.MOD-4A0063 04/10/12 By Mandy q_ime1的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4A0248 04/10/27 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-4B0174 04/11/17 By Mandy 查所有資料,選一筆資料編輯單頭,當部門編號跳到簡稱後,編輯確定後,按下筆,其他資料的部門簡稱都是一樣
# Modify.........: No.MOD-4B0074 04/11/17 By Smapmin 判斷理由碼是否為"失效",失效情況下則不能輸入
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.MOD-4B0275 04/11/27 By Danny CALL q_coc2
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.MOD-520023 05/02/16 By Melody p_lot應是 VARCHAR(24)
# Modify.........: No.MOD-530345 05/03/26 By kim 輸入時，部門應自動帶出使用者自己之部門編號
# Modify.........: No.FUN-540025 05/04/12 By Carrier 雙單位內容修改
# Modify.........: No.FUN-550011 05/05/23 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: No.FUN-550029 05/05/30 By Will 單據編號放大
# Modify.........: No.FUN-550047 05/06/13 By Echo 新增 TIPTOP 與 EasyFlow 整合
# Modify.........: No.MOD-560007 05/06/13 By Echo 重新定義整合FUN名稱
# Modify.........: No.MOD-530574 05/06/16 By kim 異動數量不允許為零,允許輸入負數
# Modify.........: No.MOD-550007 05/06/16 By kim 修改AFTER INPUT段
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-570036 05/07/06 By Carrier 拆箱
# Modify.........: No.MOD-570299 05/08/16 By kim 理由碼加show中文說明
# Modify.........: No.MOD-560242 05/06/29 By kim AFTER FIELD inb09 時必須重新抓取 g_img10 的量
# Modify.........: NO.MOD-570234 05/08/30 BY pengu p_qty改用like方式定義
# Modify.........: NO.FUN-580179 05/09/07 BY Nicola 輸入完異動數量後，會當掉
# Modify.........: No.MOD-590118 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No.MOD-570181 05/09/12 By Kevin INSERT 到tlf034 or tlf024(img10異動後數量)不正確
# Modify.........: No.MOD-590347 05/09/20 By Carrier mark du_default()
# Modify.........: No.FUN-580120 05/08/24 By yiting 以 EF 為 backend engine, 由TIPTOP 處理前端簽核動作
# Modify.........: No.MOD-570203 05/10/24 By pengu  若該主件為(Phase out)料,系統應警告視窗詢問後允雜收
# Modify.........: No.TQC-5A0134 05/10/31 By Rosayu VAR CHAR-> CHAR
# Modify.........: No.TQC-5C0031 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No.MOD-5C0022 05/12/09 By kim 理由碼放大至40
# Modify.........: No.FUN-5B0140 05/12/13 By Pengu 若單頭有輸入專案編號，單身批號欄位自動預設專案編號
# Modify.........: No.FUN-5C0077 05/12/22 By jackie  單身增加檢驗否inb10欄位，扣帳時做檢查
# Modify.........: No.FUN-5C0085 05/12/23 By Sarah 將單身"批號"的位置移到"儲位"的後面
# Modify.........: No.FUN-610070 06/01/17 By alex 過帳錯誤統整顯示功能新增
# Modify.........: No.TQC-610014 06/01/24 By pengu 單身新增且為單一單位時，若打異動數量欄位未輸入案enter後程式會產生無窮回圈當住
# Modify.........: No.FUN-610090 06/01/25 By Nicola 拆併箱功能修改
# Modify.........: No.MOD-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-630018 06/03/08 By Claire 傳入單號及項次給s_upimg
# Modify.........: NO.TQC-620156 06/03/09 By kim GP3.0庫存不足err_log 延續 FUN-610070 的修改
# Modify.........: No.FUN-630046 06/03/14 BY Alexstar 新增申請人(表單關係人)欄位
# Modify.........: No.FUN-640025 06/04/08 BY Joer 單身新增第二筆時,預設值出現品名規格
# Modify.........: No.MOD-640049 06/04/08 BY kim 單身資料輸入問題
# Modify.........: No.MOD-640485 06/04/17 BY Claire 單身資料輸入問題,使用下箭頭可避過控卡,但資料仍未寫入成功
# Modify.........: No.FUN-640056 06/04/18 BY wujie  單身母料件控管
# Modify.........: No.TQC-640162 06/04/19 BY Claire mfg6069 不使用於 ina00=3 or ina00=4
# Modify.........: No.FUN-640245 06/04/28 By Echo 自動執行確認功能
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: NO.TQC-610015 06/05/25 By yoyo  多屬性
# Modify.........: NO.FUN-630087 06/05/26 By rainy 新增顯示工單號碼
# Modify.........: No.MOD-650090 06/06/08 BY Claire inb05不可空白改以per判斷
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: No.FUN-660079 06/06/16 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.TQC-660096 06/06/21 By saki 流程訊息通知功能
# Modify.........: No.TQC-660100 06/06/21 By Rayven 多屬性功能改進:查詢時不顯示多屬性內容
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3
# Modify.........: No.FUN-660085 06/07/03 By Joe 若單身倉庫欄位已有值，則倉庫開窗查詢時，重新查詢時不會顯示該料號所有的倉儲。
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670093 06/07/20 By kim GP3.5 利潤中心
# Modify.........; NO.TQC-680036 06/08/15 BY Claire (1)確認及取消確認要update inamode,inadate
#                                                   (2) _x() update失敗加入rollback wrok ,return
#                                                   (3)_y_chk mfg-009的	select count ina_file 改為inb_file
# Modify.........: No.TQC-680071 06/08/18 By kim 修正TQC-680036的錯誤
# Modify.........: No.FUN-680010 06/08/24 by Joe SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-690026 06/09/14 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/10/16 By jamie 1.FUNCTION t370()_q 一開始應清空g_ina.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0061 23/10/16 By xumin g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0007 06/10/26 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6A0036 06/11/14 By rainy 判斷停產(ima140)時，須一併判斷生效日期(ima1401)
# Modify.........: No.MOD-6A0104 06/12/11 By Claire 單位轉換率為no_entry
# Modify.........: No.CHI-6A0015 06/12/18 By rainy 輸入料號後，要自動帶出預設倉庫儲位
# Modify.........: No.FUN-6C0083 07/01/05 By Nicola 錯誤訊息彙整
# Modify.........: No.TQC-710032 07/01/15 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-720002 07/02/02 By kim GP3.6行業別架構
# Modify.........: No.FUN-6B0038 07/02/06 By rainy 庫存扣帳時先跳到扣帳日期輸入
# Modify.........: No.FUN-720049 07/03/01 By kim 行業別架構變更
# Modify.........: No.MOD-710027 07/03/05 By pengu CALL cl_err('','abm-731',1)多傳項次
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730061 07/03/28 By kim 行業別架構
# Modify.........: No.MOD-710118 07/03/29 By pengu t370_update()中不宜再加入commit/rollbakwork的處理
# Modify.........: No.TQC-740184 07/04/22 By Carol 單身倉庫欄位QBE加查詢功能
# Modify.........: No.TQC-740197 07/04/22 By Carol 過帳時使用的變數值l_ina02要在call t370_s1()前給 g_ina.ina02
# Modify.........: No.MOD-740123 07/04/22 By Carol ina00不可為可輸入欄位
# Modify.........: No.TQC-740186 07/04/23 By Carol t370_r()調整FUN-66007的錯誤
# Modify.........: No.MOD-740082 07/04/23 By rainy 單身料號不修改時不重抓倉庫儲位
# Modify.........: No.TQC-740266 07/04/23 By kim aimt303&aimt313檢驗欄位不可修改
# Modify.........: No.TQC-740281 07/04/24 By Echo 從ERP簽核時，無法帶出單據資料
# Modify.........: No.MOD-740059 07/04/24 By pengu 當申請人改變時，部門代號不會重新帶出申請人的部門代號
# Modify.........: No.CHI-770019 07/07/25 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.TQC-750015 07/08/14 By pengu 庫存轉換率異常
# Modify.........: No.TQC-790008 07/09/03 By judy "異動量"不可小于等于零
# Modify.........: No.MOD-790053 07/09/17 By Pengu 過帳判斷是否使用拆併箱時應先重新select ima906的值
# Modify.........: No.MOD-790069 07/09/17 By Pengu 產生拆併箱時傳入的日期應為過帳日期，而不應該是單據日期
# Modify.........: No.MOD-780071 07/09/20 By pengu 過帳斷不應該有簽核處理
# Modify.........: No.TQC-7B0031 07/11/06 By Carrier 過帳還原時,日期要即時清掉
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.MOD-7C0002 07/12/03 By Pengu 當扣帳時出現"mfg6090"錯誤訊息且按放棄時還是會做過帳動作
# Modify.........: No.FUN-810045 08/01/18 By rainy 項目管理 單身加專案編號(inb41)/WBS(inb42)/活動編號(inb43)
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.FUN-830056 08/03/17 By bnlent ICD庫存過帳修改 
# Modify.........: No.FUN-840042 08/04/11 By TSD.liquor 自定欄位功能修改
# Modify.........: No.MOD-840157 08/04/21 By Pengu 刪除時程式會擋掉
# Modify.........: No.FUN-850120 08/05/23 By rainy 多單位補批序號處理
# Modify.........: No.CHI-840039 08/05/29 By sherry 1、未完全檢驗合格部份,可取消確認!
#                                                   2、修改數量時,檢查不可小與已檢驗合格量 
# Modify.........: NO.CHI-860008 08/06/11 BY yiting del_rvbs modify
# Modify.........: No.FUN-860045 08/06/12 By Nicola 批/序號傳入值修改及開窗詢問使用者是否回寫單身數量
# Modify.........: No.FUN-850027 08/05/29 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No.CHI-860032 08/06/24 By Nicola 批/序號修改
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.FUN-860014 08/07/08 By sherry 過帳不可先判斷日期,輸完再檢查
# Modify.........: No.FUN-870040 08/07/14 By sherry 增加申請量(inb16)
# Modify.........: No.FUN-870163 08/07/31 By sherry 預設申請數量=原異動數量
# Modify.........: No.FUN-880129 08/09/05 By xiaofeizhu s_del_rvbs的傳入參數(出/入庫，單據編號，單據項次，專案編號)，改為(出/入庫，單據編號，單據項次，檢驗順序)
# Modify.........: No.FUN-840012 08/10/08 By kim 整合功能mBarcode,自動確認+過帳
# Modify.........: No.FUN-8A0091 08/10/20 By jan 加復制功能
# Modify.........: No.MOD-8A0098 08/10/21 By wujie  設定單別綁定屬性群組時，修改多屬性料件欄位，開窗返回的還是未修改的老料號
# Modify.........: No.MOD-8A0263 08/10/30 By claire 輸入單身再輸入批序號,此時單身尚未完成輸入,又刪除,再重新輸入,批序號資料仍為舊值
# Modify.........: No.FUN-8C0024 08/12/09 By jan 增加 "倉庫批修改"action
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID 
# Modify.........: No.MOD-910081 09/01/08 By claire 刪除雜收單,也應刪除對應的批序號 
# Modify.........: No.MOD-8C0189 08/12/18 By claire 調整語法,以免於ifx區會執行錯誤
# Modify.........: No.MOD-910104 09/01/09 By claire 報廢單對批序號處理同發料單
# Modify.........: No.MOD-910219 09/01/20 By claire 調整FUN-850027
# Modify.........: No.MOD-920007 09/02/02 By liuxqa 庫存不可過賬
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING  
# Modify.........: No.MOD-920064 09/02/05 By claire chk_inb04() 使用變數有誤
# Modify.........: No.FUN-930109 09/03/19 By xiaofeizhu 過賬時增加s_incchk檢查使用者是否有相應倉,儲的過賬權限
# Modify.........: No.FUN-930145 09/03/23 By lala 理由碼必須為庫存雜項 
# Modify.........: No.TQC-930155 09/04/17 By Zhangyajun Lock imgg_file 失敗，不能直接Rollback
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-940083 09/05/14 By zhaijie增加VIM 發/退料單號-ina103的邏輯處理
# Modify.........: No.MOD-940186 09/05/21 By Pengu 修改時會再重新default部門資料，這樣不合理
# Modify.........: No.MOD-940351 09/05/21 By Pengu ida, idb並沒有070的欄位程是卻有用到
# Modify.........: No.FUN-960007 09/06/02 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.MOD-960086 09/06/08 By mike 判斷出入庫的部分，入庫應該是[34]
# Modify.........: No.CHI-950013 09/06/24 By mike 若為報稅系統,抓取理由碼時還要考慮到料件是否為保稅料件                       
# Modify.........: No.CHI-960025 09/06/24 By mike 請調整aimt303/aimt313單身的手冊編號(inb901)欄位應該要依據單據別判斷是否可以輸入   
# Modify.........: No.MOD-970026 09/07/03 By Carrier 單身料件有打'檢驗'的選擇時,過帳需檢查是否有QC單 & 過帳時,單身有異動數量inb09為零時,報警
# Modify.........: No.MOD-970031 09/07/06 By lilingyu 彈出維護排序號的窗口時,不去維護,系統會提示是否回寫數量,選擇是,則系統進入死循環
# Modify.........: No.MOD-970121 09/07/14 By mike 在呼叫aimr300時多傳3個參數      
# Modify.........: No.MOD-970097 09/07/16 By Smapmin 在單身無資料的情況下,點擊"批/序號查詢"ACTION,程序當出
# Modify.........: No.TQC-970155 09/07/21 By lilingyu 新增資料時報錯:無法將NULL插入欄的'欄-名稱'
# Modify.........: No.TQC-970197 09/07/22 By lilingyu 在碼別編號說明維護作業中新維護的"理由碼"資料,在aimt302中開窗選擇無資料,手動輸入ok
# Modify.........: No.FUN-950056 09/07/27 By chenmoyan 去掉ima920
# Modify.........: No.FUN-870100 09/07/31 By Cockroach 零售超市移植
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No:CHI-990051 09/10/05 By Pengu 使用BOM結構產生單身資料時，會無法產生M件資料
# Modify.........: No.TQC-9A0004 09/10/09 By lilingyu 取消審核時,應將審核日期(inacond)和審核人員(inaconu)清除
# Modify.........: No.MOD-9A0067 09/10/12 By Smapmin 輸入WBS編號時不輸控卡pjb25(帶活動否)的條件
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No.FUN-9A0068 09/10/28 By destiny 显示增加ina103
# Modify.........: No.FUN-930064 09/11/05 By jan 新增時,單身可以依BOM以及工單自動展開
# Modify.........: No.CHI-960092 09/11/05 By jan 1:新增修改時 inb09/inb907/inb904 不可輸入
# .............................................. 2:修改時DEFAULT異動數量=申請數量,多單位時同樣處理
# Modify.........: No.CHI-980019 09/11/05 By jan 虛擬料件不可做任何單據
# Modify.........: No.TQC-9B0037 09/11/12 By jan 修正FUN-930064的問題
# Modify.........: No:TQC-9B0148 09/11/18 By sherry t370_chk_inb08()中重抓g_img09
# Modify.........: No:MOD-9B0146 09/11/24 By Smapmin 修正CHI-960092
# Modify.........: No:MOD-980242 09/11/25 By sabrina 當單身有輸入專案代號時，則WBS強制一定要輸入
# Modify.........: No:MOD-960138 09/11/27 By sabrina key完料號後若未經過倉庫欄位時單位欄位不會default
# Modify.........: No.FUN-9B0025 09/11/30 By cockroach 添加inacond默認值
# Modify.........: No.TQC-9C0056 09/12/10 BY Carrier 更新时,用到错误变量
# Modify.........: No.FUN-9C0075 09/12/17 By Cockroach inb05從rtz_file里抓初值
# Modify.........: No.FUN-9C0090 09/12/18 By Cockroach 新增默认抓inaplant_desc
# Modify.........: No.TQC-9C0169 09/12/24 By Carrier CONSTRUCT时增加ina103(VMI发/退料单号)
# Modify.........: No:MOD-9C0050 09/12/25 By Pengu 料件基本資料沒有設定預設倉儲時，inb08會是空的，導致新增料倉儲批資料時會被卡住
# Modify.........: No.FUN-9C0072 10/01/15 By vealxu 精簡程式碼
# Modify.........: No:CHI-A10016 10/01/18 By Dido 調整 s_lotout transcation 架構 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.CHI-A20020 10/02/26 By wuxj  CHI-960092的衍生問題
#                                                  NEXT FIELD inb09  -> NEXT FIELD inb16
#                                                  NEXT FIELD inb904 -> NEXT FIELD inb922
#                                                  NEXT FIELD inb907 -> NEXT FIELD inb927
# Modify.........: No.TQC-A30041 10/03/16 By Cockroach add oriu/orig
# Modify.........: No.CHI-9A0022 10/02/04 By chenmoyan s_lotin,s_lotout增加參數:歸屬單號
# Modify.........: No.FUN-A20044 10/03/22 By wangj ima26x改善
# Modify.........: No:MOD-A30017 10/03/30 By Summer 複製時應依單據性質給予inamksg預設值
# Modify.........: No:MOD-A30151 10/03/30 By Summer 當ina00為5或6時,不做aim-400的控卡
# Modify.........: No:MOD-A40089 10/04/19 By Sarah 抓取g_img09,g_img10變數前先清空變數值
# Modify.........: No:MOD-A40131 10/04/22 By Sarah 當單身輸入完料號,直接跳過倉庫點選後面的單位,沒有檢查到倉庫的正確性
# Modify.........: No:MOD-A50026 10/05/05 By Sarah b_fill()段抓取ima15後,若沒抓到資料不需顯示錯誤訊息,直接LET l_ima15='N'
# Modify.........: No.FUN-A50071 10/05/20 By lixia 程序增加POS單號字段 并增加相應管控
# Modify.........: No:MOD-A50144 10/05/21 By Sarah 單身輸入方式選擇2.依工單需求整批產生時,沒有給予多單位欄位預設值
# Modify.........: No:TQC-A60014 10/06/17 By lilingyu  "未錄入單身資料時,故取消單頭資料",此時單頭畫面仍然存在
# Modify.........: No.MOD-A60125 10/06/18 By liuxqa 修正MOD-A40131，给inb05赋初值时，不需要判断一定要是流通库。
# Modify.........: No.FUN-A60028 10/06/21 By lilnigyu 錄完單頭,選擇"依據工單整批生成",按確定後,單身無資料生成
# Modify.........: No:MOD-A70038 10/07/05 By Sarah tlf034目前會直接寫入inb09,應該要先換算成庫存單位的數量後再寫入
# Modify.........: No:FUN-A70034 10/07/21 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:MOD-A10187 10/08/03 By Pengu 輸入單身時應該依據料件基本資料default檢驗碼的值
# Modify.........: No:MOD-A80086 10/08/11 By Carrier 单身录入时按"退出",重新进到单身做新增时,没有走INSERT逻辑
# Modify.........: No:MOD-A80220 10/08/27 By sabrina 雜收發依BOM表自動產生功能應要加上可輸入理由碼，否則自動產生出來後會沒理由碼
# Modify.........: No:TQC-A90032 10/09/15 By Summer 雜收發的確認段,在確認時不要回寫"修改人員"與"修改日期"
# Modify.........: No:MOD-AA0034 10/10/08 By sabrina 當azw04='2'倉庫抓rtz07，否則抓ima35
# Modify.........: No:MOD-AA0076 10/10/13 By sabrina 當取消確認時，另一個視窗不可以做過帳的動作 
# Modify.........: No:FUN-AA0007 10/10/14 By jan 若輸入的批號之ids17='Y',则控卡不能输入 
# Modify.........: No:MOD-AA0102 10/10/19 By sabrina (1)修改MOD-AA0076的錯誤
#                                                    (2)t370_s_upd()少了一個RETURN 
# Modify.........: No.FUN-A40022 10/10/26 By jan 當料件為批號控管,則批號必須輸入
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0049 10/11/05 by destiny  增加倉庫的權限控管
# Modify.........: No.FUN-AB0025 10/11/12 By vealxu 全系統增加料件管控
# Modify.........: No.FUN-AB0066 10/11/16 By lilingyu 審核段增加倉庫權限的控管
# Modify.........: No:MOD-9C0398 10/11/25 By sabrina 依BOM展單身時，不會依據QPA推算數量
# Modify.........: No:TQC-AB0360 10/12/03 By huangtao 重新過單
# Modify.........: No.TQC-AB0417 10/12/03 By jan aimt312只允許wip倉使用
# Modify.........: No:MOD-AC0052 10/12/08 By sabrina 新增單身選「依BOM展開單身」時，沒有帶出「發料申請單位」及「發料申請數量」 
# Modify.........: No:TQC-AC0122 10/12/14 BY shenyang 修改單身倉庫字段預帶值不正確，未管控倉為歸屬營運中心應為當前營運中心
# Modify.........: No:MOD-AC0115 10/12/14 By sabrina 勾選保稅系統時，理由碼開窗仍要帶出雜收的理由碼
# Modify.........: No:TQC-AC0216 10/12/17 by jan 由其他程式呼叫本程式時不應該有呼叫外掛程式的感覺  
# Modify.........: No:TQC-AC0330 10/12/22 by zhangll 增加理由码控管
# Modify.........: No:FUN-A50036 10/12/23 By Lilan 控制EF簽核時,ICD行業別不可執行的ACTION
# Modify.........: No:MOD-AC0315 10/12/24 By jan window aimt370_wo 的inb15一直保持顯示狀態
# Modify.........: No:MOD-AC0324 10/12/27 By suncx window aimt370_wo 的inb15管控調整為和單身一致
# Modify.........: No:FUN-B10016 11/01/07 By Lilan 與CRM整合
# Modify.........: No:TQC-B10061 11/01/11 By lilingyu 已經審核的資料不可再"全部刪除再重新生成"
# Modify.........: No:MOD-B10101 11/01/13 By sabrina t370_b_fill()判斷是否為保稅資料時，不需多判斷該料號為有效。因在輸入料號時已判斷
# Modify.........: No:FUN-A50095 11/01/18 By Mandy EasyFlow ICD
# Modify.........: No:MOD-B30036 11/03/07 By sabrina 呼叫完s_lotout()後的判斷值應該l_r而不是l_i 
# Modify.........: No.FUN-B30211 11/04/01By yangtingting   1、離開MAIN時沒有cl_used(2)
#                                                           2、未加離開前得cl_used(2)
# Modify.........: No:FUN-B30170 11/04/08 By suncx 單身增加批序號明細頁簽
# Modify.........: No:FUN-AC0074 11/05/03 By jan 若單據已備置，則不可取消確認
# Modify.........: No:FUN-AC0074 11/05/09 By destiny 關賬后，還可以過帳還原
# Modify.........: No.CHI-B40058 11/05/13 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.TQC-B50032 11/05/18 By destiny 审核时不存在的部门可以通过 
# Modify.........: No.FUN-B50138 11/05/23 By jan 拆分 確認/取消確認/過帳 段至saimt370_sub.4gl
# Modify.........: No.FUN-B40082 11/05/24 By jason  ina10不為空時不可過帳還原
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B30187 11/06/16 By jason ICD功能修改，增加母批、DATECODE欄位
# Modify.........: No:MOD-B70023 11/07/19 By JoHung AFTER INSERT與ON ROW CHANGE時
#                                                   判斷當筆單身料須做批序號且數量有修改且不做檢驗時，開窗批序號維護
#                                                   開窗批序號維護確定回寫時，回寫inb09及inb16
# Modify.........: No:FUN-B70061 11/07/20 By jason 維護刻號/BIN回寫母批DATECODE
# Modify.........: No.FUN-B80070 11/08/08 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No:MOD-B60188 11/08/10 By Summer 理由碼是否有效應多判斷azf02
# Modify.........: No.FUN-B30053 11/08/18 By xianghui 輸入單身時應該依據單據別中設定的QC欄位的值為預設值
# Modify.........: No.FUN-B50096 11/08/19 By lixh1 所有入庫程式應該要加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.TQC-B90096 11/09/14 By lixh1  如果批號設為不可輸入,AFTER FIELD 儲位后CALL AFTER FIELD 批號程式
# Modify.........: No:MOD-B90150 11/09/22 By johung t370_check_inb04加上抓ima906
# Modify.........: No:MOD-BA0122 11/10/18 By johung 修改t370_g()呼叫的畫面名稱
# Modify.........: No:MOD-BB0321 11/11/29 By ck2yuan 修改copy段 呼叫正確日期
# Modify.........: No:MOD-BB0341 11/12/01 By ck2yuan 修改CHI-960092設定欄位開關,將mark放入引號中部分移除
# Modify.........: No.FUN-BA0051 11/12/01 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-BC0061 11/12/15 By yangxf 程式判別若為零售業且來源單號為券作廢異動單時, 則不允過帳還原.
# Modify.........: No.TQC-B90236 11/12/21 By zhuhao s_lotout_del/s_lotin_del程式段Mark，改為s_lot_del
#                                                   BEFORE DELETE中的s_del_rvbs程式段Mark
#                                                   _r()中，使用FOR迴圈執行s_del_rvbs程式段Mark，改為s_lot_del
#                                                   原執行s_lotou程式段，改為s_mod_lot，傳入參數不變，於最後多傳入-1
#                                                   原執行s_lotin程式段，改為s_mod_lot，於第6,7,8個參數傳入倉儲批，最後多傳入1，其餘傳入參數不變
# Modify.........: No.FUN-BB0085 11/12/21 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-B80093 11/10/03 By pauline 控管VIM相關欄位
# Modify.........: No:TQC-BB0208 12/01/11 By jason for ICD 維護完刻號/BIN時,DIE數量回寫至單身'參考申請單位數量'
# Modify.........: NO.FUN-BC0104 12/01/12 By xianghui 增加QC料件判定

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20029 12/02/03 By ck2yuan 修改傳入s_chk_item_no錯誤參數
# Modify.........: No.FUN-C20047 12/02/08 BY xianghui 修正FUN-BC0104的一些問題
# Modify.........: No:FUN-C20002 12/02/10 By fanbj 券產品倉庫調整
# Modify.........: No:FUN-C20025 12/02/08 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No.TQC-C20183 12/02/15 By fengrui 數量欄位小數取位處理
# Modify.........: No.TQC-C20194 12/02/15 By xianghui 對FUN-BC0104進行一些調整
# Modify.........: NO.TQC-C20223 12/02/16 By xianghui QC料件判定調整
# Modify.........: No:MOD-BB0165 12/02/16 By bart 修改 多單位時，inb922未填寫，AFTER FIELD到數量後再回到inb922維護
#                                                   會出現「單位、庫別不可同時為空」的訊息
# Modify.........: No.FUN-BC0109 12/02/17 By jason for ICD Datecode回寫多筆時即以","做分隔
# Modify.........: No:TQC-BB0223 12/02/17 By SunLM 增加VMI發料單號開窗查詢功能
# Modify.........: No.FUN-C20101 12/02/20 By qiaozy 增加服饰二维结构
# Modify.........: No.FUN-BC0062 12/03/05 By xujing 使用移動加權平均成本時，需維護單價,在審核時也需check一次
# Modify.........: No.MOD-C30390 12/03/12 By xujing 查詢倉庫ACTION增加WHERE條件:當前營運中心
# Modify.........: No:MOD-C30217 12/03/12 By lixiang  控管數量欄位數量不可小於零
# Modify.........: No.MOD-C30533 12/03/13 By xianghui 作廢時沒有清空g_wc2的值導致撈不到單身資料不顯示
# Modify.........: No.MOD-C30541 12/03/16 By xianghui 處理單身有QC時的新增問題
# Modify.........: No.MOD-C30873 12/03/27 By destiny ima35没有维护时自动带出imf02
# Modify.........: No.TQC-C30205 12/03/28 By xianghui 使用qc料件判定時，倉庫應qc料件維護的的倉庫相同相關
# Modify.........: No:FUN-C30257 12/03/29 By pauline 由換物或換券而自動產生的出貨單據, 不可進行 "扣帳還原"
# Modify.........: No:FUN-C30293 12/03/30 By Abby  執行[單身],按"確認",狀況碼才可變成0.開立
# Modify.........: No:CHI-C30106 12/04/05 By Elise 批序號維護
# Modify.........: No.FUN-C40016 12/04/06 By xianghui 單據作廢時不須清空QC料件判定新增的那幾個欄位,重新回寫已轉入庫量即可，取消作廢時檢查數量是否合理
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No.TQC-C40079 12/04/13 By xianghui 調整t370sub_y_chk()的參數
# Modify.........: No:FUN-C30302 12/04/20 By bart 修改 s_icdout和s_icdin 回傳值
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:CHI-C30125 12/06/01 By ck2yuan 在產生單身或手動key帶預設倉庫時,若預帶的倉庫與單別設定衝突則將倉儲清空
# Modify.........: No:TQC-C60007 12/06/01 By bart 單身增加刻號/BIN號出入庫明細按鈕
# Modify.........: No:TQC-C60033 12/06/01 By bart 單身維護料號要選取倉儲批,正常可於批號欄位選取倉儲批,現行到儲位無法到批號就一定要選擇資料.應同雜發單於批號點選放大鏡可以選取.
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No:TQC-C60020 12/06/13 By bart datecode可維護
# Modify.........: No:MOD-BA0209 12/06/18 By ck2yuan 當料件抓不到單位時會帶到上一筆的單位資料
# Modify.........: No:FUN-C30085 12/06/20 By lixiang 串CR報表改GR報表
# Modify.........: No:FUN-C60100 12/06/26 By qiaozy  服飾流通：快捷鍵controlb的問題，切換的標記請在BEFORE INPUT 賦值 
# Modify.........: No:MOD-C70176 12/07/16 By ck2yuan 當是保稅,理由碼開窗應只有保稅跟雜收理由碼
# Modify.........: No:MOD-C70234 12/07/23 By ck2yuan chk_part中 ima08多 X
# Modify.........: No:FUN-C80030 12/08/10 By xujing 添加批序號依參數sma95隱藏
# Modify.........: No:FUN-C30027 12/08/16 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-C80045 12/08/17 By nanbing 檢查POS單別，不允許在ERP中錄入
# Modify.........: No:FUN-C80107 12/09/19 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No:CHI-C40009 12/09/20 By bart 保稅料使用保稅理由碼
# Modify.........: No:MOD-C70128 12/10/09 By yinhy 默認inb13，inb132，inb133，inb134，inb135，inb136，inb137，inb138默認為0
# Modify.........: No:MOD-C90167 12/10/11 By Elise 倉庫未輸入，過了批號欄位，若批號沒有輸入值，倉庫欄位應要可進去
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:CHI-C70017 12/10/29 By bart 關帳日管控
# Modify.........: No:MOD-CA0110 12/10/29 By Elise 在 on change inb04 將單位清空
# Modify.........: No.FUN-CB0087 12/12/05 By qiull 庫存單據理由碼改善
# Modify.........: No.FUN-CC0074 12/12/11 By zhangll 雜項報廢增加根據參數管控必輸性
# Modify.........: No.FUN-CC0013 13/01/11 By Lori aqci106移除性質3.驗退/重工(qcl05=3)選項
# Modify.........: No:CHI-CA0042 13/01/11 By Elise 目前沒有機會進入inb09,故將此段mark
# Modify.........: No:FUN-D10081 13/01/21 By qiull 增加資料清單
# Modify.........: No:CHI-C80041 13/01/25 By bart 刪除單頭
# Modify.........: No:TQC-D10084 13/01/29 By qiull 資料清單頁簽不可點擊單身按鈕
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D20060 13/02/22 By yangtt 設限倉庫/儲位控卡
# Modify.........: No:MOD-C70301 13/03/13 By Alberti 只要在新增時去清空後面的數量就好，修改狀態不需清空數量
# Modify.........: No:FUN-D30024 13/03/13 By lixh1 負庫存依據imd23判斷
# Modify.........: No:MOD-D30154 13/03/19 By bart 增加條件p_cmd='u' and inb924=0
# Modify.........: No.DEV-D30026 13/03/19 By Nina GP5.3 追版:DEV-D10001、DEV-CB0005、DEV-CC0001、DEV-CC0006、DEV-D10007為GP5.25 的單號
# Modify.........: No:FUN-D30030 13/03/20 By Nina 修正參數aoos010的是否與M-Barcode整合設定為'N'時有顯示'條碼相關'的功能
# Modify.........: No:FUN-D30065 13/03/21 By lixh1 給inb13默認值
# Modify.........: No.DEV-D30037 13/03/21 By TSD.JIE 有用smyb01="2:條碼單據"的控卡的改為用單身任一筆(MIN(項次)判斷即可)料件是否為包號管理(ima931)='Y'
# Modify.........: No.TQC-D30066 13/03/25 By lixh1 輸入數量之後沒有計算出金額,造成新增時沒有單價或更改時金額沒有更新
# Modify.........: No.DEV-D30045 13/03/26 By TSD.JIE 調整自動產生barcode
#                                                    調整自動作廢barcode
# Modify.........: No.DEV-D30059 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),輸入資料時,
#                                                 不要自動開批序號的Key In畫面(s_mod_lot)
# Modify.........: No.CHI-CC0028 13/04/15 By bart 過帳還原需控管"有無此倉儲的過賬權限"
# Modify.........: No.MOD-D40091 13/04/15 By bart 理由碼為必填
# Modify.........: No.MOD-D40175 13/04/24 By bart 單身全部刪除並重新產生時把對應的 ida_file / idb_file 刪除
# Modify.........: No:TQC-D40078 13/04/27 By fengrui 負庫存函数添加营运中心参数 
# Modify.........: No:TQC-D30075 13/04/28 By fengrui 調整庫存理由碼判斷寫法
# Modify.........: No:MOD-D50152 13/05/17 By bart 修改項次後，應該連相關table也要一併更新
# Modify.........: No.FUN-C60035 13/05/21 By Mandy inb905,inb902,inb925,inb922 這幾個欄位需多判斷是否跟此料的ima25有轉換率
# Modify.........: No.DEV-D50009 13/05/23 By Nina 修正判斷CALL批序號變數的預設值
# Modify.........: No:CHI-D50047 13/05/29 By bart 儲位控卡時跳到倉庫儲位
# Modify.........: No:MOD-D50272 13/05/30 By bart AFTER 批號時，先判斷是否已輸入，有值才處理add_img的部份
# Modify.........: No:FUN-D60038 13/06/07 By fengrui 庫存資料不存在于img_file調用s_add_img;
# Modify.........: No:TQC-D60062 13/06/21 By joyce 調整流通取料件預設倉庫別規則，若為券則取採購策略的預設倉庫，非券者則取門店基本資料的成本倉
# Modify.........: No:MOD-D60198 13/06/25 By Alberti 修正_slk之理由碼不得為空
# Modify.........: No:MOD-D60192 13/06/25 By Alberti 在before field inb08 多加控卡
# Modify.........: No:FUN-D60112 13/06/26 By jingll 區分制造與流通的控管邏輯:制造業態下不顯示款式頁簽,流通業下才顯示
# Modify.........: No.DEV-D60003 13/06/26 By Nina [條碼管理]:增加檢查若掃描數量 <> 0，控卡不可取消確認或取消過帳
# Modify.........: No.MOD-D60246 13/07/01 By jingll bug修改判斷CALL t370sub_ins_inb 成功否, 若ins_inbi成功, 則回傳l_flag1 =TRUE 会退出WHILE 循環 只會成功一筆資料 
# Modify.........: No:FUN-D70027 13/07/02 By xianghui aimt370_wo畫面中的分群碼、來源碼開窗，日期改成日期控件
# Modify.........: No.MOD-D60011 13/06/03 By fengmy 去掉BOM有效日期不能小於當天的管控
# Modify.........: No.MOD-D60019 13/06/05 By fengmy 帶出工單倉庫,過濾回收料和參考諮詢
# Modify.........: No.MOD-D60227 13/06/27 By fengmy 未離開當前行，查詢倉庫返回值須保留
# Modify.........: No.MOD-D60002 13/06/01 By fengmy 不判斷aza115，不需要通過aooi220檢驗
# Modify.........: No:MOD-D70040 13/07/08 By Alberti 僅在扣帳時檢查倉庫不可空白,其餘階段不做控卡
# Modify.........: No:FUN-D40032 13/07/10 By lujh 取消作廢需控卡關帳日期
# Modify.........: No:TQC-D70030 13/07/11 By Alberti 修改MOD-D70040之問題，當跳至單位欄位後,欲往前至倉庫欄位做調整,但會無法跳至倉庫欄位
# Modify.........: No:TQC-D70092 13/07/26 By lixh1 發料時倉庫允許負庫存則不報錯会再過帳時新增倉儲批
# Modify.........: No:TQC-D80002 13/08/02 By lixh1 過帳段增加'apm-936'報錯信息 
# Modify.........: No:MOD-D80034 13/08/07 By bart 修正檢查單號後卡住
# Modify.........: No:TQC-D80003 13/08/07 By fengrui 金額添加取位
# Modify.........: No:FUN-D70125 13/08/09 By nanbing 料號是卡時，根據arts100的rcj21設置,帶出arti200的預設成本倉或非成本倉
# Modify.........: No:MOD-D80067 13/08/30 By Alberti 用BOM表產生單身資料時無法產生
# Modify.........: No.FUN-D90010 13/09/23 By qirl 修改aimg300傳參,增加一個參數
# Modify.........: No.FUN-DA0126 13/11/04 By bart 移除azo_file程式段
# Modify.........: No:MOD-DB0029 13/11/06 By Alberti 給預設值 b_inb.inb908 = 0
# Modify.........: No:FUN-DA0124 13/11/07 By yihsuan 增加共用變數g_data_keyvalue給值
# Modify.........: No:MOD-DA0151 13/11/08 By Albert 因FUN-D90070 被誤過正式區，故先Mark此段修改之程式
# Modify.........: No:FUN-DA0106 13/11/11 By Albert 1.控卡 雜發(aimt301)及WIP雜發(aimt311)不需控卡img_file(mfg6069)
#                                                   2.狀況碼(ina08)原為"1:已核准",經由ACTION "倉儲批修改"調整倉/儲/批後,狀況碼被異動成"0:開立"
# Modify.........: No:TQC-DB0063 13/11/12 By fengrui 添加庫位无效性控卡
# Modify.........: No:FUN-DB0029 13/11/18 By zhuhao 製造服飾業修改
# Modify.........: No:TQC-DB0075 13/11/27 By wangrr 點擊"查詢"再"退出",會報錯"-404:找不到光標或說明"
# Modify.........: No:MOD-DB0188 13/11/29 By Vampire 串 aqcp107 增加傳遞參數判斷欄位控卡。
# Modify.........: No:TQC-DB0021 13/12/02 By zhuhao sma150='Y'批序號不開啟畫面
# Modify.........: No:MOD-DC0071 13/12/12 By Polly 修改欄位後需重新抓取單位好可重新計算轉換率
# Modify.........: No:FUN-DC0025 13/12/17 By chenying 還原MOD-DA0151 對FUN-D90010的mark 
# Modify.........: No:TQC-DC0083 13/12/30 By zhuhao rvbs09值填充問題修改
# Modify.........: No:TQC-E10006 14/01/08 By zhuhao 進入顏色檔欄位關閉問題
# Modify.........: No:TQC-E10049 14/01/20 By fengrui 服饰制造小數取位完善
# Modify.........: No:MOD-E20008 14/02/06 By Alberti 新增控卡 單頭AFTER INPUT增加 扣帳日期(ina02)加嚴控卡mfg9999及mfg6091
# Modify.........: No:MOD-E20019 14/02/10 By Reanna g_rec_b3沒有抓到值，修改的情況會誤判為新增狀態
# Modify.........: No:FUN-E20026 14/02/24 By apo 新鞋服15欄屬性放寬至40欄
# Modify.........: No:MOD-E30014 14/03/05 By Alberti 無論員工(ina11)有效或無效，員工姓名(gen02)皆應該顯示 
# Modify.........: No:TQC-E30007 14/03/14 By apo 新鞋服bug修改
# Modify.........: No:FUN-E30041 14/03/21 By apo 1.apm-187錯誤訊息增加顯示明細總數量
#                                                2.更改單身左側數量時,不刪除明細
# Modify.........: No:MOD-E30039 14/04/02 By Alberti 修正檢查單號後卡住(新增時發生)
# Modify.........: No:MOD-E40087 14/04/15 By SunLM 對MOD-D60002進行部份還原MARK,還是要對理由碼進行檢核
# Modify.........: No.FUN-E50024 14/05/08 By sabrina GR還原CR
# Modify.........: No:MOD-E70151 14/07/29 By 增加條件儲存 
# Modify.........: No:MOD-E80023 14/08/06 By liliwen 參考單位、收料單位無法維護
# Modify.........: No.CHI-E80019 14/08/12 By sabrina (1)寫入 rvbs06 需先轉換為庫存單位
#                                                    (2)變更單位時，rvbs的數量也要依新單位的轉換率更新為新的數量
# Modify.........: No.MOD-E80090 14/08/15 By qiull 單身刪除最後一筆時跳到上一筆
# Modify.........: No.MOD-E80167 14/09/01 By liliwen 修正TQC-D70092,CALL s_inv_shrt_by_warehouse增加條件g_ina.ina00 MATCHES '[1256]'
# Modify.........: No.MOD-E90053 14/09/15 By Alberti 當該營運中心為2:零售(azw04) 輸入完成 再按下單身，程式未直接關閉的問題
# Modify.........: No.MOD-EA0129 14/10/24 By Alberti 修正 單身做修改，批/序號也要同步修改
# Modify.........: No.MOD-EB0093 14/11/20 By Mandy AFTER FIELD inb927 時，當為參考單位，不做數量的控卡(mfg1303)
# Modify.........: No.MOD-EC0006 14/12/01 By Mandy 使用雙單位,當不為收料作業(3:庫存雜項收料  4:WIP 雜項收料)且無img_file檔時,提示訊息不明確
# Modify.........: No:MOD-EC0007 14/12/02 By Mandy 原aim-163 訊息提示不明確,做調整
# Modify.........: No:MOD-EC0015 14/12/03 By Mandy 不使用雙單位時,若單身輸入的料號為參考單位(ima906='3'),輸入後不應顯示出雙單位的欄位
# Modify.........: No.MOD-F10035 15/01/09 By Alberti 修正 有使用多單位的欄位可輸入/不可輸入
# Modify.........: No.FUN-F10019 15/01/23 By Lisa 調整單關簽核或通知關卡EF與TT狀態不一致問題，aws_efcli2僅需重新撈取狀態碼並顯示於單據上
# Modify.........: No.MOD-F30050 15/03/10 By Mandy 畫面aimt370_g1 原本"主特性代碼"改成"特性代碼"且開窗改開q_bma06
# Modify.........: No:FUN-F30034 15/03/19 By Rayhu 背景執行時不作批序號維護
# Modify.........: No:MOD-F30181 15/03/30 By Mandy 當料件為參考單位(ima906='3')時,且參考單位(inb925)和申請單位一(inb922)有換算率時,給預設值inb924給錯
# Modify.........: No.FUN-E80014 15/05/14 By TsungYung 流通業在輸入相關單據時，應該不須控卡MISC要存在於商品/採購策略中
# Modify.........: No:FUN-F50014 15/05/25 By ywtsai 於新增a()段與show()段增加記錄g_data_keyvalue值
# Modify.........: No:CHI-F30073 15/05/26 By TsungYung 在INSERT INTO img_file前,要檢查該倉庫的歸屬營運中心,是否與imd_file (aimi200) 一致
# Modify.........: No:MOD-F70148 15/07/28 By ywtsai 點選批序號維護Action時，若該料號未做製造批號/序號管理，需顯示訊息與使用者
# Modify.........: No:MOD-F80053 15/08/10 By ywtsai 單頭於inb04(料號)欄位後，若有設定不可輸入批號，於NEXT FIELD inb05之前須再加判設定避免未卡控到
# Modify.........: No:CHI-F80014 15/08/31 By fionchen 調整CURSOR在二次查詢顯示異常的問題 
# Modify.........: No:MOD-F90136 15/09/23 By catmoon 修正TQC-D70030 導致對應的倉庫類別控卡失效
# Modify.........: No:MOD-FA0119 15/10/23 By catmoon 鞋服業修改單身項次時,要先判斷若有顏色尺寸明細資料時,也要一併更新顏色尺寸明細的單據項次資料
# Modify.........: No.FUN-FC0005 15/12/17 By fionchen cralc_rate增加傳入組成用量與組成底數兩個參數 
# Modify.........: No:MOD-FC0120 15/12/22 By catmoon 刪除或作廢時，檢查是否存在於rmd21，有則需清空rmd21
# Modify.........: No:MOD-FC0134 15/12/24 By catmoon 所屬營運中心名稱欄位(inaplant_desc)資料來源錯誤
# Modify.........: No:CHI-G10002 16/01/15 By TsungYung 將 s_showmsg(..) 移至 Transaction 外，以避免資料被長時間Lock的問題。
# Modify.........: No:MOD-G70157 16/07/29 By ywtsai 修改FUNCTION t370_upd_rvbs_slk()的p_sum變數定義長度需同rvbs_file.rvbs06
# Modify.........: No:MOD-G80079 16/08/16 By fionchen 調整MOD-E40087,若是倉儲批修改作業時,不需執行t370_inb15_chk1檢核 
# Modify.........: No:FUN-G90010 17/02/23 By earl 隱藏舊有條碼Action
# Modify.........:               20180427 By momo 預計停產料件更改為卡死不可收
# Modify.........:               19/04/16 BY ruby 部門編號為T17*研發單位，則專案代號不可為空
# Modify.........: No:2002134265 20200217 By momo 增加顯示成本筆數
# Modify.........: No:2004304569 20200507 By momo 確認時「自動產生 aqct700 QC檢驗單」
# Modify.........: No:2005204667 20200520 By momo 「已確認」才可拋轉請購單，拋轉邏輯調整為 預計可用量小於0時才拋轉
# Modify.........: No:2105046171 20210506 By momo 增加顯示專案名稱pja02
# Modify.........:               20210809 By momo 190416程式段調整檢核處，避免部門調整後誤判
# Modify.........: No:2203037686 20220310 By momo 拋轉請購單無產生單據押上N，用以判別當下不需生成請購
# Modify.........: No:2203037685 20220316 By momo 雜發單 需求日期 調整

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../4gl/saimt370.global"   #FUN-720002
DEFINE g_ima918    LIKE ima_file.ima918  #No.FUN-810036
DEFINE g_ima921    LIKE ima_file.ima921  #No.FUN-810036
DEFINE g_ima930    LIKE ima_file.ima930  #No.DEV-D30059 add
DEFINE l_r         LIKE type_file.chr1   #No.FUN-860045
DEFINE g_qty       LIKE rvbs_file.rvbs06   #No.FUN-860045
DEFINE l_i         LIKE type_file.num5   #No.FUN-860045
DEFINE l_fac       LIKE img_file.img34   #No.FUN-860045
DEFINE g_wm        LIKE type_file.chr1   #No.FUN-8C0024
DEFINE g_crmStatus LIKE type_file.num10  #FUN-B10016 add
DEFINE g_crmDesc   STRING                #FUN-B10016 add
DEFINE g_inb03     LIKE inb_file.inb03   #20200211
DEFINE g_pml   RECORD LIKE pml_file.*    #20200211
DEFINE                                                                                                                              
    tm  RECORD                                                                                                                      
          part    LIKE ima_file.ima01,                                                                                               
          ima910  LIKE ima_file.ima910,                                                                                              
          qty     LIKE sfb_file.sfb08,                                                                                               
          idate   LIKE type_file.dat,                                                                                                
          img02   LIKE img_file.img02,    #FUN-D60038 add
          img03   LIKE img_file.img03,    #FUN-D60038 add
          img04   LIKE img_file.img04,    #FUN-D60038 add
          inb15   LIKE inb_file.inb15,
          inb15_1 LIKE inb_file.inb15,    #MOD-AC0324
          inb930  LIKE inb_file.inb930,
          a       LIKE type_file.chr1                                                                                                
        END RECORD                                                                                                                 
DEFINE g_ima44    LIKE ima_file.ima44                                                                                               
DEFINE g_ccc      LIKE type_file.num5                                                                                               
DEFINE l_imn04    LIKE imn_file.imn04                                                                                               
DEFINE l_imn05    LIKE imn_file.imn05                                                                                               
DEFINE l_imn15    LIKE imn_file.imn15                                                                                               
DEFINE l_imn16    LIKE imn_file.imn16                                                                                               
DEFINE l_imn28    LIKE imn_file.imn28
DEFINE g_ima25    LIKE ima_file.ima25
DEFINE g_azi03    LIKE azi_file.azi03     #TQC-D80003 add
DEFINE p_row,p_col  LIKE type_file.num5 
DEFINE l_inb15    LIKE inb_file.inb15 
DEFINE 
    tm1  RECORD                                                                                                                     
         sfb01    LIKE sfb_file.sfb01,  #MOD-D60019
         sfb13    LIKE sfb_file.sfb01,  #MOD-D60019
         ima06    LIKE ima_file.ima06,  #MOD-D60019
         ima08    LIKE ima_file.ima06,  #MOD-D60019
         bdate    LIKE type_file.dat,                                                                                             
         sudate   LIKE type_file.dat,
         img02    LIKE img_file.img02,   #FUN-D60038 add
         img03    LIKE img_file.img03,   #FUN-D60038 add
         img04    LIKE img_file.img04,   #FUN-D60038 add
         inb15    LIKE inb_file.inb15,                                                                                              
         inb15_1  LIKE inb_file.inb15    #MOD-AC0324 add
         END RECORD                                                                                                                 
DEFINE g_argv1    LIKE type_file.chr1                                                                                        
DEFINE g_sw       LIKE type_file.chr1                                                                                        
DEFINE g_seq      LIKE type_file.num5                                                                                            
DEFINE g_cnt      LIKE type_file.num10   
#FUN-B30170 add begin--------------------------
DEFINE g_rvbs   DYNAMIC ARRAY OF RECORD        #批序號明細單身變量
                  rvbs02  LIKE rvbs_file.rvbs02,
                  rvbs021 LIKE rvbs_file.rvbs021,
                  ima02a  LIKE ima_file.ima02,
                  ima021a LIKE ima_file.ima021,
                  rvbs022 LIKE rvbs_file.rvbs022,
                  rvbs04  LIKE rvbs_file.rvbs04,
                  rvbs03  LIKE rvbs_file.rvbs03,
                  rvbs05  LIKE rvbs_file.rvbs05,
                  rvbs06  LIKE rvbs_file.rvbs06,
                  rvbs07  LIKE rvbs_file.rvbs07,
                  rvbs08  LIKE rvbs_file.rvbs08
                END RECORD
DEFINE g_rec_b1           LIKE type_file.num5,   #單身二筆數 ##FUN-B30170
       l_ac1              LIKE type_file.num5    #目前處理的ARRAY CNT  #FUN-B30170
#FUN-B30170 add -end---------------------------                                                                                                                                    
#FUN-BB0085-add-str--
DEFINE g_inb08_t          LIKE inb_file.inb08
DEFINE g_inb902_t         LIKE inb_file.inb902
DEFINE g_inb905_t         LIKE inb_file.inb905
DEFINE g_inb922_t         LIKE inb_file.inb922
DEFINE g_inb925_t         LIKE inb_file.inb925
#FUN-BB0085-add-end--

#FUN-C20101----ADD---STR----
#FUN-C20101----ADD---END----
DEFINE l_flag01   LIKE type_file.chr1   #FUN-C80107 add
DEFINE l_img_flag LIKE type_file.chr1   #FUN-D60038 add
#FUN-D10081---add---str---
DEFINE g_ina_l DYNAMIC ARRAY OF RECORD
               ina00   LIKE ina_file.ina00,
               ina01   LIKE ina_file.ina01,
               smydesc LIKE smy_file.smydesc,
               ina02   LIKE ina_file.ina02,
               ina03   LIKE ina_file.ina03,
               ina11   LIKE ina_file.ina11,
               gen02   LIKE gen_file.gen02,
               ina04   LIKE ina_file.ina04,
               gem02   LIKE gem_file.gem02,
               ina07   LIKE ina_file.ina07,
               ina10   LIKE ina_file.ina10,
               ina103  LIKE ina_file.ina103,
               ina13   LIKE ina_file.ina13,
               inaconf LIKE ina_file.inaconf,
               ina08   LIKE ina_file.ina08,
               inapost LIKE ina_file.inapost,
               inamksg LIKE ina_file.inamksg
               END RECORD,
        l_ac4      LIKE type_file.num5,
        g_rec_b4   LIKE type_file.num5,
        g_action_flag  STRING
DEFINE   w     ui.Window
DEFINE   f     ui.Form
DEFINE   page  om.DomNode
#FUN-D10081---add---end---
DEFINE g_cmd     STRING #No:DEV-D30026--add                                                                                                                                    

DEFINE  g_inb03_o LIKE inb_file.inb03 #MOD-FA0119

FUNCTION t370(p_argv1)
 
    DEFINE p_argv1       LIKE type_file.chr1  	# 11/12/13  #No.FUN-690026 VARCHAR(1)
    DEFINE p_argv2       LIKE ina_file.ina01    #FUN-580120 #No.FUN-690026 VARCHAR(10)
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    #初始化界面的樣式(沒有任何默認屬性組)
    LET lg_smy62 = ''
    LET lg_group = ''
    CALL t370_refresh_detail()
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM ina_file WHERE ina01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t370_cl CURSOR FROM g_forupd_sql
    LET g_argv1=p_argv1
    
    #CALL cl_set_comp_required("inb15",g_aza.aza115='Y')    #FUN-CB0087--ADD  #MOD-D40091
    #TQC-D30075--add--end--
    IF g_aza.aza115='Y' THEN
       CALL cl_set_comp_required("inb15",TRUE)  
    END IF 
    #TQC-D30075--add--end--
    #No.FUN-A50071 -----start---------
    IF p_argv1 = '1' OR p_argv1 ='3'  THEN
       CALL cl_set_comp_visible("ina13",g_aza.aza88 = 'Y')
    ELSE
       CALL cl_set_comp_visible("ina13",FALSE)
    END IF    
    #No.FUN-A50071 -----end---------
   
    #FUN-C80030--add--str---
    CALL cl_set_act_visible('modi_lot,qry_lot',g_sma.sma95 = 'Y')
    CALL cl_set_comp_visible('Page2',g_sma.sma95 = 'Y')
    #FUN-C80030--add--end--- 
    IF g_argv1 = '1' THEN
       CALL cl_set_act_visible('carry_pr,over_qty,modify_inaud13',TRUE)    #20200317 #20220316
    ELSE
       CALL cl_set_act_visible('carry_pr,over_qty,modify_inaud13',FALSE)   #20200317 #20220316
       CALL cl_set_comp_visible("inaud13,socnt",FALSE)      #20210507
    END IF
#FUN-C20101--add--begin--
#    CALL cl_set_act_visible("controlb",FALSE) #FUN-C60100--MARK--
#FUN-C20101--add--end-- 

#FUN-BC0062 --begin--
   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'

    IF g_ccz.ccz28 = '6' AND (g_argv1  = '3' OR g_argv1 = '4') THEN 
       CALL cl_set_comp_visible("inb13,inb14",TRUE)
       CALL cl_set_comp_required("inb13",TRUE)
    ELSE 
       CALL cl_set_comp_visible("inb13,inb14",FALSE)   
    END IF 
#FUN-BC0062 --end--
    SELECT azi03 INTO g_azi03 FROM azi_file WHERE azi01=g_aza.aza17  #TQC-D80003 add

    LET g_argv2      = ARG_VAL(2)          #單號       #FUN-640245
    LET g_argv3      = ARG_VAL(3)          #功能       #FUN-640245
    LET g_argv4      = ARG_VAL(4)          #程式代號   #DEV-D30026 add 

    CALL t370_init() #FUN-720002           #No.TQC-740281

    IF NOT cl_null(g_argv2) THEN
       CASE g_argv3
          WHEN "vmi_undo"          #取消自動確認+過賬-FOR VMI
             CALL t370_q()
             IF g_ina.inapost = 'Y' THEN
                LET g_msg = "aimp379 '",g_ina.ina01,"' 'Y' " #No.FUN-940083 By shiwuying
                CALL cl_cmdrun_wait(g_msg)
             ELSE
                IF g_ina.inaconf = 'X' THEN        #作廢
                   CALL cl_err(g_ina.ina01,9024,0)
                END IF
                IF (g_ina.inapost = 'N') OR (g_ina.inaconf = 'N') THEN
                #未過賬資料不可過賬還原！
                   CALL cl_err(g_ina.ina01,'afa-108',1)
                END IF
             END IF 
             IF g_success = "Y" THEN
                CALL t370sub_z(g_ina.ina01,'Y',FALSE)  #FUN-B50138
             END IF
             CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
             EXIT PROGRAM
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t370_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t370_a()
                LET g_data_keyvalue = g_ina.ina01    #FUN-F50014 add
             END IF
          WHEN "efconfirm"
             CALL t370_q()
#FUN-C20101-----ADD-----STR-------
#FUN-C20101-----ADD-----END-------                
             CALL t370sub_y_chk(g_ina.ina01,g_argv1,'Y') #FUN-660079 #FUN-B50138  #TQC-C40079 add Y
             IF g_success = "Y" THEN
                CALL t370sub_y_upd(g_ina.ina01,'Y',FALSE) #FUN-660079 #FUN-B50138
             END IF
             CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
             EXIT PROGRAM
          WHEN "stock_post"  #自動確認+過帳-mBarcode用
             CALL t370_q()
#FUN-C20101-----ADD-----STR-------
#FUN-C20101-----ADD-----END-------                
             CALL t370sub_y_chk(g_ina.ina01,g_argv1,'Y')          #FUN-B50138   #TQC-C40079 add Y
             IF g_success = "Y" THEN
                CALL t370sub_y_upd(g_ina.ina01,'Y',FALSE)    #FUN-B50138
             END IF
             IF g_success = "Y" THEN
                CALL t370sub_s_chk(g_ina.ina01,'Y',FALSE,'') #FUN-B50138
                IF g_success = "Y" THEN
                   CALL t370sub_s_upd(g_ina.ina01,g_argv1,FALSE)    #FUN-B50138
                END IF
             END IF
             CALL t370_refresh() RETURNING g_ina.*  #FUN-B50138
             CALL t370_show()                       #FUN-B50138
             CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
             EXIT PROGRAM
          OTHERWISE
             CALL t370_q()
       END CASE
    END IF
    IF g_azw.azw04 <> '2' THEN
      #CALL cl_set_comp_visible('ina12,inaplant,inaplant_desc,inapos,inacont,inaconu,inaconu_desc,inacond',FALSE)  #20200217 mark
       CALL cl_set_comp_visible('ina12,inaplant,inaplant_desc,inapos,inacont,inaconu,inaconu_desc',FALSE)          #20200217 modify
    END IF
#FUN-C20101-----ADD------STR----
#FUN-C20101----END-------
    CALL t370_menu()
END FUNCTION
 
FUNCTION t370_cs()
 DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01     #No.FUN-580031  HCN
 DEFINE  l_type          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_ima08         LIKE ima_file.ima08
 
    IF NOT cl_null(g_argv2) THEN
       LET g_wc ="ina01 = '",g_argv2,"'"
       LET g_wc2 = '1=1'
    ELSE
       CLEAR FORM                             #清除畫面
       CALL g_inb.clear()
#FUN-C20101-----ADD----STR----
#FUN-C20101-----ADD----END----       
       INITIALIZE g_ina.* TO NULL  #FUN-640213 add
       CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
#FUN-C20101-----ADD----STR-----
       DIALOG ATTRIBUTE(UNBUFFERED)  
          CONSTRUCT BY NAME g_wc ON
              ina01,ina03,ina02,ina11,ina04,ina06,ina07,ina10,ina103,
              ina12,inaplant,ina13,inaconf,inaconu,inacond,inacont,inaspc,
              inapost,inamksg,ina08,inapos,inauser,inagrup,inamodu,inadate,
              inaoriu,inaorig,
              inaud01,inaud02,inaud03,inaud04,inaud05,
              inaud06,inaud07,inaud08,inaud09,inaud10,
              inaud11,inaud12,inaud13,inaud14,inaud15          
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
          END CONSTRUCT
                
          
          CONSTRUCT g_wc2 ON inb03,
                           inb911,inb912, #FUN-6A0007 新增inb911,inb912
                           inb44,inb45,inb48,inb46,qcl02,inb47,                 #FUN-BC0104  add
                           inb04,inb05,inb06,inb07,inb08,
                           inb16,  #FUN-870040
                           inb925,inb927,inb922,inb924, #FUN-870040
                           inb09,   #FUN-5C0085
                           inb905,inb907,inb902,inb904,
                           inb15,inb41,inb42,inb43,       #FUN-810045 add inb41-43
                           inb11,inb12,inb901,inb10,inb930  #no.A050  #No.FUN-5C0077增加inb10 #FUN-670093
                           ,inbud01,inbud02,inbud03,inbud04,inbud05
                           ,inbud06,inbud07,inbud08,inbud09,inbud10
                           ,inbud11,inbud12,inbud13,inbud14,inbud15
             FROM s_inb[1].inb03,
                  s_inb[1].inb911,s_inb[1].inb912, #FUN-6A0007 新增inb911,inb912
                  s_inb[1].inb44,s_inb[1].inb45,s_inb[1].inb48,         #FUN-BC0104
                  s_inb[1].inb46,s_inb[1].qcl02,s_inb[1].inb47,         #FUN-BC0104
                  s_inb[1].inb04, s_inb[1].inb05,       #FUN-5C0085
                  s_inb[1].inb06, s_inb[1].inb07, s_inb[1].inb08,       #FUN-5C0085
                  s_inb[1].inb16, s_inb[1].inb925,s_inb[1].inb927,  #FUN-870040
                  s_inb[1].inb922,s_inb[1].inb924,  #FUN-870040
                  s_inb[1].inb09, s_inb[1].inb905,s_inb[1].inb907,
                  s_inb[1].inb902,s_inb[1].inb904,s_inb[1].inb15,
                  s_inb[1].inb41, s_inb[1].inb42, s_inb[1].inb43,   #FUN-810045 add
                  s_inb[1].inb11, s_inb[1].inb12, s_inb[1].inb901,#no.A050
                  s_inb[1].inb10, s_inb[1].inb930      #No.FUN-5C0077  #FUN-670093
                  ,s_inb[1].inbud01,s_inb[1].inbud02,s_inb[1].inbud03,s_inb[1].inbud04,s_inb[1].inbud05
                  ,s_inb[1].inbud06,s_inb[1].inbud07,s_inb[1].inbud08,s_inb[1].inbud09,s_inb[1].inbud10
                  ,s_inb[1].inbud11,s_inb[1].inbud12,s_inb[1].inbud13,s_inb[1].inbud14,s_inb[1].inbud15
           	 BEFORE CONSTRUCT
           	    CALL cl_qbe_display_condition(lc_qbe_sn)
          END CONSTRUCT
#          IF INT_FLAG THEN RETURN END IF
#          LET g_wc = g_wc CLIPPED,cl_get_extra_cond('inauser', 'inagrup')
 
#          IF NOT cl_null(g_argv1) THEN
#             LET g_wc = g_wc clipped," AND ina00 = '",g_argv1,"'"
#          END IF
          ON ACTION controlp
              CASE 
                 WHEN INFIELD(ina01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    IF g_azw.azw04='2' THEN
                       LET g_qryparam.form = "q_ina" 
                    ELSE
                       LET g_qryparam.form = "q_ina"
                    END IF
                    LET g_qryparam.arg1 = g_argv1  #單據類別
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ina01
                    NEXT FIELD ina01
 
                 WHEN INFIELD(ina11) #申請人
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ina11
                    NEXT FIELD ina11
 
                 WHEN INFIELD(ina04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_ina.ina04
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ina04  #No.MOD-4A0248
                    NEXT FIELD ina04
                 WHEN INFIELD(ina06) #專案代號 BugNo:6548
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pja2"  #FUN-810045
                    LET g_qryparam.default1 =  g_ina.ina06
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ina06  #No.MOD-4A0248
                    NEXT FIELD ina06
                 WHEN INFIELD(inaconu)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_inaconu"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inaconu
                    NEXT FIELD inaconu
                   # TQC-BB0223  Start
                 WHEN INFIELD(ina103)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ina103"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ina103
                    NEXT FIELD ina103
                   # TQC-BB0223  End
                 WHEN INFIELD(inb04)
#FUN-AA0059 --Begin--
                   #     CALL cl_init_qry_var()
                   #     LET g_qryparam.form ="q_ima"
                   #     LET g_qryparam.default1 = g_inb[1].inb04
                   #     LET g_qryparam.state = "c"
                   #     CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","",g_inb[1].inb04,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO inb04
                    NEXT FIELD inb04

                 WHEN INFIELD(inb05)
                        #No.FUN-AA0049--begin
                        #CALL cl_init_qry_var()
                        #LET g_qryparam.form     = "q_imd"
                        #LET g_qryparam.state    = "c"
                        #LET g_qryparam.arg1     = 'SW'        #倉庫類別
                        #CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
                        #No.FUN-AA0049--end
                    DISPLAY g_qryparam.multiret TO inb05
                    NEXT FIELD inb05
 
                 WHEN INFIELD(inb08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_inb[1].inb08
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb08
                    NEXT FIELD inb08
 
                 WHEN INFIELD(inb905)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_inb[1].inb905
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb905
                    NEXT FIELD inb905
 
                 WHEN INFIELD(inb902)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_inb[1].inb902
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb902
                    NEXT FIELD inb902
 
                 WHEN INFIELD(inb925)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_inb[1].inb925
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb925
                    NEXT FIELD inb925
 
                 WHEN INFIELD(inb922)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_inb[1].inb922
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb922
                    NEXT FIELD inb922
#FUN-BC0104-----------add------------str------------------
                 WHEN INFIELD(inb44)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_inb44"
                    LET g_qryparam.state = "c" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb44
                    NEXT FIELD inb44        

                 WHEN INFIELD(inb45)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_inb44"
                    LET g_qryparam.state = "c"   
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb45
                    NEXT FIELD inb45

                 WHEN INFIELD(inb48)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_inb44"
                    LET g_qryparam.state = "c"   
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb48
                    NEXT FIELD inb48

                 WHEN INFIELD(inb46)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_inb44"
                    LET g_qryparam.state = "c"   
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb46
                    NEXT FIELD inb46

                 WHEN INFIELD(inb47)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_inb44"
                    LET g_qryparam.state = "c"   
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb47
                    NEXT FIELD inb47 
#FUN-BC0104-----------add------------end------------------

                 WHEN INFIELD(inb41) #專案
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pja2"
                    LET g_qryparam.state = "c"   #多選
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb41
                    NEXT FIELD inb41
 
                 WHEN INFIELD(inb42)  #WBS
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pjb4"
                    LET g_qryparam.state = "c"   #多選
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb42
                    NEXT FIELD inb42
 
                 WHEN INFIELD(inb43)  #活動
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pjk3"
                    LET g_qryparam.state = "c"   #多選
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb43
                    NEXT FIELD inb43
 
                 WHEN INFIELD(inb15)
                    IF g_sma.sma79='Y' THEN
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_azf06"                      #MOD-C70176  q_azf->q_azf06
                       LET g_qryparam.default1 = g_inb[1].inb15,'A2'    #MOD-AC0115 add 2
                      #LET g_qryparam.arg1 = "A2"      #MOD-AC0115 add 2   #MOD-C70176 mark   
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                    ELSE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_azf01a"               #FUN-930145
                       LET g_qryparam.default1 = g_inb[1].inb15,'2'
                       LET g_qryparam.arg1 = "4"                     #FUN-930145
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                    END IF
                    DISPLAY g_qryparam.multiret TO inb15
                    NEXT FIELD inb15
                 WHEN INFIELD(inb901)
                    SELECT ima08 INTO l_ima08 FROM ima_file
                     WHERE ima01 = g_inb[1].inb04
                    IF STATUS THEN
                       LET l_ima08 = ''
                    END IF
                    IF l_ima08 = 'M' THEN LET l_type = '0' END IF
                    IF l_ima08 = 'P' THEN LET l_type = '1' END IF
                    CALL q_coc2(TRUE,TRUE,g_inb[1].inb901,'',g_ina.ina02,l_type,
                                '',g_inb[1].inb04)
                                RETURNING g_inb[1].inb901
                    DISPLAY BY NAME g_inb[1].inb901
                    NEXT FIELD inb901
                 WHEN INFIELD(inb930)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form  = "q_gem4"
                    LET g_qryparam.state = "c"   #多選
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb930
                    NEXT FIELD inb930
                 WHEN INFIELD(inb911) OR INFIELD(inb912) #查詢訂單單號、項次
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_inb911"
                    LET g_qryparam.default1 =  g_inb[1].inb911
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO inb911
                    NEXT FIELD inb911
               END CASE
               
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE DIALOG
 
            ON ACTION about
               CALL cl_about()
 
            ON ACTION help 
               CALL cl_show_help()
 
            ON ACTION controlg
               CALL cl_cmdask()
 
            ON ACTION qbe_select
               CALL cl_qbe_list() RETURNING lc_qbe_sn
               CALL cl_qbe_display_condition(lc_qbe_sn)

            #MOD-E70151 add --start--
            ON ACTION qbe_save
               CALL cl_qbe_save()
            #MOD-E70151 add --end--
               
            ON ACTION ACCEPT
               EXIT DIALOG
       
            ON ACTION EXIT
               LET INT_FLAG = TRUE
               EXIT DIALOG 
                 
            ON ACTION CANCEL
               LET INT_FLAG = TRUE
               EXIT DIALOG          
                  
       END DIALOG            
#FUN-C20101-----ADD----END----- 
#FUN-C20101-----MARK----STR----      
#       CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
#           ina01,ina03,ina02,ina11,ina04,ina06,ina07,ina10,ina103,            #No.TQC-9C0169 #FUN-A50071 add ina13
#           ina12,inaplant,ina13,inaconf,inaconu,inacond,inacont,inaspc, #FUN-630046 #FUN-630078 add ina10 #FUN-660079 #FUN-680010 #FUN-870100
#           inapost,inamksg,ina08,inapos,inauser,inagrup,inamodu,inadate,     #FUN-550047 #FUN-870100
#           inaoriu,inaorig,                                                   #TQC-A30041 ADD
#           inaud01,inaud02,inaud03,inaud04,inaud05,
#           inaud06,inaud07,inaud08,inaud09,inaud10,
#           inaud11,inaud12,inaud13,inaud14,inaud15          
# 
#                  BEFORE CONSTRUCT
#                     CALL cl_qbe_init()
# 
#           ON ACTION controlp
#              CASE WHEN INFIELD(ina01) #查詢單据
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.state= "c"
#                        IF g_azw.azw04='2' THEN
#     	                   LET g_qryparam.form = "q_ina" 
#                        ELSE
#    	                   LET g_qryparam.form = "q_ina"
#                        END IF
#                        LET g_qryparam.arg1 = g_argv1  #單據類別
#     	                CALL cl_create_qry() RETURNING g_qryparam.multiret
#    	                DISPLAY g_qryparam.multiret TO ina01
#    	                NEXT FIELD ina01
# 
#                   WHEN INFIELD(ina11) #申請人
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.form = "q_gen"
#                        LET g_qryparam.state = 'c'
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO ina11
#                        NEXT FIELD ina11
# 
#                   WHEN INFIELD(ina04)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.form ="q_gem"
#                        LET g_qryparam.state = "c"
#                        LET g_qryparam.default1 = g_ina.ina04
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                         DISPLAY g_qryparam.multiret TO ina04  #No.MOD-4A0248
#                        NEXT FIELD ina04
#                   WHEN INFIELD(ina06) #專案代號 BugNo:6548
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.form ="q_pja2"  #FUN-810045
#                        LET g_qryparam.default1 =  g_ina.ina06
#                        LET g_qryparam.state = "c"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO ina06  #No.MOD-4A0248
#                        NEXT FIELD ina06
#                   WHEN INFIELD(inaconu)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.form = "q_inaconu"
#                        LET g_qryparam.state = 'c'
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO inaconu
#                        NEXT FIELD inaconu
#                   # TQC-BB0223  Start
#                   WHEN INFIELD(ina103)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.form = "q_ina103"
#                        LET g_qryparam.state = 'c'
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO ina103
#                        NEXT FIELD ina103
#                   # TQC-BB0223  End
#              END CASE
# 
#           ON IDLE g_idle_seconds
#              CALL cl_on_idle()
#              CONTINUE CONSTRUCT
# 
#           ON ACTION about         #MOD-4C0121
#              CALL cl_about()      #MOD-4C0121
# 
#           ON ACTION help          #MOD-4C0121
#              CALL cl_show_help()  #MOD-4C0121
# 
#           ON ACTION controlg      #MOD-4C0121
#              CALL cl_cmdask()     #MOD-4C0121
# 
#           ON ACTION qbe_select
#              CALL cl_qbe_list() RETURNING lc_qbe_sn
#              CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#        END CONSTRUCT
#        IF INT_FLAG THEN RETURN END IF
#        LET g_wc = g_wc CLIPPED,cl_get_extra_cond('inauser', 'inagrup')
# 
#        IF NOT cl_null(g_argv1) THEN
#           LET g_wc = g_wc clipped," AND ina00 = '",g_argv1,"'"
#        END IF
#        CONSTRUCT g_wc2 ON inb03,
#                           inb911,inb912, #FUN-6A0007 新增inb911,inb912
#                           inb44,inb45,inb48,inb46,qcl02,inb47,                 #FUN-BC0104  add
#                           inb04,inb05,inb06,inb07,inb08,
#                           inb16,  #FUN-870040
#                           inb925,inb927,inb922,inb924, #FUN-870040
#                           inb09,   #FUN-5C0085
#                           inb905,inb907,inb902,inb904,
#                           inb15,inb41,inb42,inb43,       #FUN-810045 add inb41-43
#                           inb11,inb12,inb901,inb10,inb930  #no.A050  #No.FUN-5C0077增加inb10 #FUN-670093
#                           ,inbud01,inbud02,inbud03,inbud04,inbud05
#                           ,inbud06,inbud07,inbud08,inbud09,inbud10
#                           ,inbud11,inbud12,inbud13,inbud14,inbud15
#&ifdef ICD                           
#                           ,inbiicd028,inbiicd029   #FUN-B30187
#&endif                           
#             FROM s_inb[1].inb03,
#                  s_inb[1].inb911,s_inb[1].inb912, #FUN-6A0007 新增inb911,inb912
#                  s_inb[1].inb44,s_inb[1].inb45,s_inb[1].inb48,         #FUN-BC0104
#                  s_inb[1].inb46,s_inb[1].qcl02,s_inb[1].inb47,         #FUN-BC0104
#                  s_inb[1].inb04, s_inb[1].inb05,       #FUN-5C0085
#                  s_inb[1].inb06, s_inb[1].inb07, s_inb[1].inb08,       #FUN-5C0085
#                  s_inb[1].inb16, s_inb[1].inb925,s_inb[1].inb927,  #FUN-870040
#                  s_inb[1].inb922,s_inb[1].inb924,  #FUN-870040
#                  s_inb[1].inb09, s_inb[1].inb905,s_inb[1].inb907,
#                  s_inb[1].inb902,s_inb[1].inb904,s_inb[1].inb15,
#                  s_inb[1].inb41, s_inb[1].inb42, s_inb[1].inb43,   #FUN-810045 add
#                  s_inb[1].inb11, s_inb[1].inb12, s_inb[1].inb901,#no.A050
#                  s_inb[1].inb10, s_inb[1].inb930      #No.FUN-5C0077  #FUN-670093
#                  ,s_inb[1].inbud01,s_inb[1].inbud02,s_inb[1].inbud03,s_inb[1].inbud04,s_inb[1].inbud05
#                  ,s_inb[1].inbud06,s_inb[1].inbud07,s_inb[1].inbud08,s_inb[1].inbud09,s_inb[1].inbud10
#                  ,s_inb[1].inbud11,s_inb[1].inbud12,s_inb[1].inbud13,s_inb[1].inbud14,s_inb[1].inbud15
#&ifdef ICD                  
#                  ,s_inb[1].inbiicd028,s_inb[1].inbiicd029   #FUN-B30187
#&endif                  
#           	BEFORE CONSTRUCT
#           	   CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#          ON ACTION controlp
#              CASE WHEN INFIELD(inb04)
##FUN-AA0059 --Begin--
#                   #     CALL cl_init_qry_var()
#                   #     LET g_qryparam.form ="q_ima"
#                   #     LET g_qryparam.default1 = g_inb[1].inb04
#                   #     LET g_qryparam.state = "c"
#                   #     CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        CALL q_sel_ima( TRUE, "q_ima","",g_inb[1].inb04,"","","","","",'')  RETURNING  g_qryparam.multiret
##FUN-AA0059 --End--
#                        DISPLAY g_qryparam.multiret TO inb04
#                        NEXT FIELD inb04
#
#                   WHEN INFIELD(inb05)
#                        #No.FUN-AA0049--begin
#                        #CALL cl_init_qry_var()
#                        #LET g_qryparam.form     = "q_imd"
#                        #LET g_qryparam.state    = "c"
#                        #LET g_qryparam.arg1     = 'SW'        #倉庫類別
#                        #CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
#                        #No.FUN-AA0049--end
#                        DISPLAY g_qryparam.multiret TO inb05
#                        NEXT FIELD inb05
# 
#                   WHEN INFIELD(inb08)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.form ="q_gfe"
#                        LET g_qryparam.default1 = g_inb[1].inb08
#                        LET g_qryparam.state = "c"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO inb08
#                        NEXT FIELD inb08
# 
#                   WHEN INFIELD(inb905)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.form ="q_gfe"
#                        LET g_qryparam.default1 = g_inb[1].inb905
#                        LET g_qryparam.state = "c"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO inb905
#                        NEXT FIELD inb905
# 
#                   WHEN INFIELD(inb902)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.form ="q_gfe"
#                        LET g_qryparam.default1 = g_inb[1].inb902
#                        LET g_qryparam.state = "c"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO inb902
#                        NEXT FIELD inb902
# 
#                   WHEN INFIELD(inb925)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.form ="q_gfe"
#                        LET g_qryparam.default1 = g_inb[1].inb925
#                        LET g_qryparam.state = "c"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO inb925
#                        NEXT FIELD inb925
# 
#                   WHEN INFIELD(inb922)
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.form ="q_gfe"
#                        LET g_qryparam.default1 = g_inb[1].inb922
#                        LET g_qryparam.state = "c"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO inb922
#                        NEXT FIELD inb922
##FUN-BC0104-----------add------------str------------------
#                   WHEN INFIELD(inb44)
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.form ="q_inb44"
#                      LET g_qryparam.state = "c" 
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO inb44
#                      NEXT FIELD inb44        
#
#                   WHEN INFIELD(inb45)
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.form ="q_inb44"
#                      LET g_qryparam.state = "c"   
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO inb45
#                      NEXT FIELD inb45
#
#                   WHEN INFIELD(inb48)
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.form ="q_inb44"
#                      LET g_qryparam.state = "c"   
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO inb48
#                      NEXT FIELD inb48
#
#                   WHEN INFIELD(inb46)
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.form ="q_inb44"
#                      LET g_qryparam.state = "c"   
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO inb46
#                      NEXT FIELD inb46
#
#                   WHEN INFIELD(inb47)
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.form ="q_inb44"
#                      LET g_qryparam.state = "c"   
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO inb47
#                      NEXT FIELD inb47 
##FUN-BC0104-----------add------------end------------------
#
#                   WHEN INFIELD(inb41) #專案
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.form ="q_pja2"
#                      LET g_qryparam.state = "c"   #多選
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO inb41
#                      NEXT FIELD inb41
# 
#                   WHEN INFIELD(inb42)  #WBS
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.form ="q_pjb4"
#                      LET g_qryparam.state = "c"   #多選
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO inb42
#                      NEXT FIELD inb42
# 
#                   WHEN INFIELD(inb43)  #活動
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.form ="q_pjk3"
#                      LET g_qryparam.state = "c"   #多選
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO inb43
#                      NEXT FIELD inb43
# 
#                   WHEN INFIELD(inb15)
#                        IF g_sma.sma79='Y' THEN
#                           CALL cl_init_qry_var()
#                           LET g_qryparam.form ="q_azf" 
#                           LET g_qryparam.default1 = g_inb[1].inb15,'A2'    #MOD-AC0115 add 2
#                           LET g_qryparam.arg1 = "A2"      #MOD-AC0115 add 2 
#                           LET g_qryparam.state = "c"
#                           CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        ELSE
#                           CALL cl_init_qry_var()
#                           LET g_qryparam.form ="q_azf01a"               #FUN-930145
#                           LET g_qryparam.default1 = g_inb[1].inb15,'2'
#                           LET g_qryparam.arg1 = "4"                     #FUN-930145
#                           LET g_qryparam.state = "c"
#                           CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        END IF
#                        DISPLAY g_qryparam.multiret TO inb15
#                        NEXT FIELD inb15
#                  WHEN INFIELD(inb901)
#                       SELECT ima08 INTO l_ima08 FROM ima_file
#                        WHERE ima01 = g_inb[1].inb04
#                       IF STATUS THEN
#                          LET l_ima08 = ''
#                       END IF
#                       IF l_ima08 = 'M' THEN LET l_type = '0' END IF
#                       IF l_ima08 = 'P' THEN LET l_type = '1' END IF
#                       CALL q_coc2(TRUE,TRUE,g_inb[1].inb901,'',g_ina.ina02,l_type,
#                                   '',g_inb[1].inb04)
#                                   RETURNING g_inb[1].inb901
#                       DISPLAY BY NAME g_inb[1].inb901
#                       NEXT FIELD inb901
#                   WHEN INFIELD(inb930)
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.form  = "q_gem4"
#                      LET g_qryparam.state = "c"   #多選
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO inb930
#                      NEXT FIELD inb930
#                   WHEN INFIELD(inb911) OR INFIELD(inb912) #查詢訂單單號、項次
#                        CALL cl_init_qry_var()
#                        LET g_qryparam.form ="q_inb911"
#                        LET g_qryparam.default1 =  g_inb[1].inb911
#                        LET g_qryparam.state = "c"
#                        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                        DISPLAY g_qryparam.multiret TO inb911
#                        NEXT FIELD inb911
#&ifdef ICD                        
#                   #FUN-B30187 --START--
#                   WHEN INFIELD(inbiicd029)
#                      CALL q_slot(TRUE,TRUE,g_inb[1].inbiicd029,g_inb[1].inb07,'')                         
#                          RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO inbiicd029
#                      NEXT FIELD inbiicd029
#                   #FUN-B30187 --END--
#&endif                   
#                    
#              END CASE
#           ON IDLE g_idle_seconds
#              CALL cl_on_idle()
#              CONTINUE CONSTRUCT
# 
#           ON ACTION about         #MOD-4C0121
#              CALL cl_about()      #MOD-4C0121
# 
#           ON ACTION help          #MOD-4C0121
#              CALL cl_show_help()  #MOD-4C0121
# 
#           ON ACTION controlg      #MOD-4C0121
#              CALL cl_cmdask()     #MOD-4C0121
# 
#           ON ACTION qbe_save
#              CALL cl_qbe_save()
# 
#        END CONSTRUCT
#FUN-C20101----MARK-----END------
    END IF
#FUN-C20101----ADD----STR----    
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('inauser', 'inagrup')
 
    IF NOT cl_null(g_argv1) THEN
        LET g_wc = g_wc clipped," AND ina00 = '",g_argv1,"'"
    END IF 
    IF cl_null(g_wc2) THEN LET g_wc2=" 1=1" END IF 
    IF cl_null(g_wc) THEN LET g_wc=" 1=1" END IF  
#FUN-C20101---ADD-----END-----   
    IF INT_FLAG THEN 
       #LET INT_FLAG=0 #TQC-DB0075 mark
       RETURN 
    END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  ina01 FROM ina_file",
                   " WHERE ", g_wc CLIPPED,
                   " AND inaplant IN ",g_auth,      #No.FUN-870100
                   " ORDER BY ina01"
#FUN-C20101----ADD---STR-------
#FUN-C20101----ADD---END-------                   
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE ina_file. ina01 ",
                   "  FROM ina_file, inb_file",
                   " WHERE ina01 = inb01",
                   " AND inaplant = inbplant",           #No.FUN-870100
                   " AND inaplant IN ",g_auth,           #No.FUN-870100
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY ina01"
#FUN-C20101-------ADD-----STR-----
#FUN-C20101-------ADD-----END-----    
    END IF
    
 
    PREPARE t370_prepare FROM g_sql
    DECLARE t370_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t370_prepare
    #DECLARE t370_fill_cs CURSOR WITH HOLD FOR t370_prepare     #FUN-D10081 add  #CHI-F80014 mark
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM ina_file WHERE ",
                  " inaplant IN ",g_auth,      #No.FUN-870100
                  " AND ",g_wc CLIPPED
#FUN-C20101----ADD---STR-------
#FUN-C20101----ADD---END-------

    ELSE
        LET g_sql="SELECT COUNT(DISTINCT ina01) FROM ina_file,inb_file WHERE ",
                  "inb01=ina01 ",
                  " AND inaplant = inbplant",           #No.FUN-870100
                  " AND inaplant IN ",g_auth,           #No.FUN-870100
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
#FUN-C20101-------ADD-----STR-----
#FUN-C20101-------ADD-----END-----       
    END IF
    PREPARE t370_precount FROM g_sql
    DECLARE t370_count CURSOR FOR t370_precount
END FUNCTION
 
FUNCTION t370_menu()
DEFINE l_creator         LIKE type_file.chr1    #FUN-580120  #No.FUN-690026 VARCHAR(1)
DEFINE l_flowuser        LIKE type_file.chr1    # 是否有指定加簽人員      #FUN-580120  #No.FUN-690026 VARCHAR(1)
DEFINE l_cnt             LIKE type_file.num5    #FUN-B40082
DEFINE l_azw04           LIKE azw_file.azw04    #FUN-BC0061
DEFINE l_n               LIKE type_file.num5       #FUN-C30257 add
DEFINE l_yy,l_mm         LIKE type_file.num5    #CHI-C70017
DEFINE l_inb03           LIKE inb_file.inb03  #CHI-CC0028
DEFINE l_inb05           LIKE inb_file.inb05  #CHI-CC0028
DEFINE l_inb06           LIKE inb_file.inb06  #CHI-CC0028 
DEFINE l_flag            LIKE type_file.chr1  #CHI-CC0028
DEFINE l_flag1           LIKE type_file.chr1  #CHI-CC0028

   LET l_flowuser = "N"
 
   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN      #FUN-D10081 add    
         CALL t370_bp("G")
      #FUN-D10081---add---str---
      ELSE 
         CALL t370_list_fill()
         CALL t370_bp2("G")
         IF NOT cl_null(g_action_choice) AND l_ac4>0 THEN #將清單的資料回傳到主畫面
            SELECT ina_file.* INTO g_ina.*
              FROM ina_file
             WHERE ina01 = g_ina_l[l_ac4].ina01
         END IF 
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac4 = ARR_CURR()
            LET g_jump = l_ac4
            LET mi_no_ask = TRUE
            IF g_rec_b4 >0 THEN
               CALL t370_fetch('/')
            END IF
            CALL cl_set_comp_visible("page_list", FALSE)
            CALL cl_set_comp_visible("page_main", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page_list", TRUE)
            CALL cl_set_comp_visible("page_main", TRUE)
         END IF
      END IF
      #FUN-D10081---add---end---
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t370_a()
               LET g_data_keyvalue = g_ina.ina01   #FUN-F50014 add
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t370_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
             #FUN-B10016 add str -------
             #若有與CRM整合,需先取得是否可刪除命令
              IF NOT cl_null(g_ina.ina10) AND g_ina.ina05 = 'Y' AND g_aza.aza123 MATCHES "[Yy]" THEN
                 CALL aws_crmcli('aimt370','chkdel','1',g_ina.ina01,'') RETURNING g_crmStatus,g_crmDesc
                 IF g_crmStatus <> 0 THEN
                    CALL cl_err(g_crmDesc,'!',1)
                 ELSE
                    CALL t370_r() 
                 END IF
              ELSE
             #FUN-B10016 add end -------
                 CALL t370_r()
              END IF                     #FUN-B10016 add 
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t370_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t370_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t370_out()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t370_copy()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

         ##----- 20220316 add by momo (S)
         WHEN "modify_inaud13"
            IF cl_chk_act_auth() THEN
              IF g_ina.inapost = 'N' THEN
                 CALL t370_modify_inaud13()
              END IF
            END IF
         ##----- 20220316 add by momo (E)
        
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
#FUN-C20101-----ADD-----STR-------
#FUN-C20101-----ADD-----END-------               
               CALL t370sub_y_chk(g_ina.ina01,g_argv1,'Y') #FUN-B50138  #TQC-C40079 add Y
               IF g_success = "Y" THEN
                  CALL t370sub_y_upd(g_ina.ina01,'Y',FALSE) #FUN-B50138
               END IF
               CALL t370_refresh() RETURNING g_ina.*  #FUN-B50138
               LET g_wc2 = ''                         #MOD-C30541
               CALL t370_show()                       #FUN-B50138
               ##---- 20200507 add by momo 雜收單確認時，自動產生QC(S)
               ##---- 20220215 增加判斷有要檢驗的資料才跳 (S)
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM inb_file
                WHERE inb10='Y'
                  AND inb01 = g_ina.ina01
               ##---- 20220215 增加判斷有要檢驗的資料才跳 (E)
               IF g_prog='aimt302' AND l_cnt > 0 THEN       #20220215 add  l_cnt > 0
                  LET g_cmd = "cqcp001  '",g_ina.ina01,"' "
                  CALL cl_cmdrun_wait(g_cmd)
               END IF
               ##---- 20200507 add by momo (E)
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t370sub_z(g_ina.ina01,'Y',FALSE)    #FUN-B50138
               CALL t370_refresh() RETURNING g_ina.*  #FUN-B50138
               CALL t370_show()                       #FUN-B50138
            END IF
       #FUN-BC0104-add-str--
         WHEN "qc_determine_storage"
            IF cl_chk_act_auth() THEN 
              #LET g_msg = "aqcp107 '3' '' '' '' '' '' '' '' '' 'N'"     #MOD-DB0188 mark
               LET g_msg = "aqcp107 '3' '' '' '' '' '' '' '' '' 'N' '2'" #MOD-DB0188 add
               CALL cl_cmdrun(g_msg)
            END IF   
       #FUN-BC0104-add-end--
       #@WHEN "庫存過帳"
          WHEN "stock_post"
             IF cl_chk_act_auth() THEN
                CALL t370sub_s_chk(g_ina.ina01,'Y',FALSE,'')    #CALL 原確認的 check 段 #FUN-B50138
                IF g_success = "Y" THEN
                   CALL t370sub_s_upd(g_ina.ina01,g_argv1,FALSE)       #CALL 原確認的 update 段#FUN-B50138
                END IF
                CALL t370_refresh() RETURNING g_ina.*  #FUN-B50138
                CALL t370_show()                       #FUN-B50138
              #CALL t370_pic() #FUN-720002            #FUN-B50138
             END IF
       #@WHEN "過帳還原"
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN               
               IF g_ina.inapost = 'Y' THEN #FUN-550047 add if 判斷  
                  IF g_sma.sma53 IS NOT NULL AND g_ina.ina02 <= g_sma.sma53 THEN  #FUN-AC0074
                     CALL cl_err('','aim-885',1)                                  #FUN-AC0074
                  ELSE                                                            #FUN-AC0074
                     IF NOT cl_null(g_ina.ina103) THEN
                        CALL cl_err(' ','aim-019',1)
                     ELSE
                        #No.FUN-A50071 ----------start----------   
                        #-->POS單號不為空時不可过帳還原
                        IF NOT cl_null(g_ina.ina13) THEN                          
                           CALL cl_err('','axm-744' ,1)
                        ELSE
                          #FUN-C30257 add START
                           #由換物或換券而自動產生的出貨單據, 不可進行 "扣帳還原"
                           LET l_n = 0
                           SELECT COUNT(*)  INTO  l_n FROM lrj_file WHERE lrj16 = g_ina.ina01
                           IF cl_null(l_n) OR l_n = 0 THEN
                              SELECT COUNT(*)  INTO  l_n FROM lrl_file WHERE lrl14 = g_ina.ina01
                           END IF
                           IF l_n > 0 THEN
                              CALL cl_err('','axm_119',0)
                           ELSE 
                          #FUN-C30257 add END
                              #CHI-C70017---begin
                              IF g_sma.sma53 IS NOT NULL AND g_ina.ina02 <= g_sma.sma53 THEN
                                 CALL cl_err('','mfg9999',0)
                                 LET g_action_choice = ''
                                 CONTINUE WHILE
                              END IF
   
                              CALL s_yp(g_ina.ina02) RETURNING l_yy,l_mm
 
                              IF l_yy > g_sma.sma51 THEN      # 與目前會計年度,期間比較
                                 CALL cl_err(l_yy,'mfg6090',0)
                                 LET g_action_choice = ''
                                 CONTINUE WHILE
                              ELSE
                                 IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
                                    CALL cl_err(l_mm,'mfg6091',0)
                                    LET g_action_choice = ''
                                    CONTINUE WHILE
                                 END IF
                              END IF
                              #CHI-C70017---end

                             #DEV-D60003 add str-------
                             #檢查掃描數量總和 <> 0，控卡不可取消確認或取消過帳
                              IF g_aza.aza131 = 'Y' THEN
                                 IF NOT s_chk_barcode_undo('undo_post','tlfb',g_ina.ina01,'','') THEN
                                    LET g_action_choice = ''
                                    CONTINUE WHILE
                                 END IF
                              END IF
                             #DEV-D60003 add end-------

                              #FUN-B40082 --START--
                              IF NOT cl_null(g_ina.ina10) THEN
                                 SELECT COUNT(*) INTO l_cnt FROM pie_file 
                                    WHERE pie01 = g_ina.ina10 
                                 IF l_cnt > 0 THEN                              
                                    CALL cl_err('','aim-164' ,1)
                                    LET g_action_choice = ''
                                    CONTINUE WHILE
                                 END IF 
                              END IF                                                 
                              #FUN-B40082 --END--
                              #FUN-BC0061 --STA--
                              SELECT azw04 INTO l_azw04
                                FROM azw_file
                               WHERE azw01 = g_ina.inaplant
                              SELECT COUNT(*) INTO l_cnt
                                FROM lpy_file
                               WHERE lpy01 = '3' 
                                 AND lpy02 = g_ina.ina10
                              IF l_azw04 = '2' AND l_cnt > 0 THEN    
                                  CALL cl_err('','aim-986',0)
                                  LET g_action_choice = ''
                                  CONTINUE WHILE
                              END IF 
                              #FUN-BC0061 --END--
                              #CHI-CC0028---begin
                              LET l_flag = 'Y'
                              DECLARE t370_z_c1 CURSOR FOR SELECT inb03,inb05,inb06 FROM inb_file 
                                                              WHERE inb01=g_ina.ina01
                              CALL s_showmsg_init()   
                              FOREACH t370_z_c1 INTO l_inb03,l_inb05,l_inb06                              
                                 CALL s_incchk(l_inb05,l_inb06,g_user) 
                                      RETURNING l_flag1
                                 IF l_flag1 = FALSE THEN
                                    LET l_flag='N'
                                    LET g_showmsg=l_inb03,"/",l_inb05,"/",l_inb06,"/",g_user
                                    CALL s_errmsg('inb03,inb05,inb06,inc03',g_showmsg,'','asf-888',1)
                                 END IF
                              END FOREACH

                              CALL s_showmsg()

                              IF l_flag='N' THEN
                                 LET g_action_choice = ''
                                 CONTINUE WHILE
                              END IF
                              #CHI-CC0028---end
                            #TQC-D80002 --------Begin--------
                              SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
                              IF g_ccz.ccz28  = '6' AND NOT cl_null(g_ina.ina01) THEN
                                 CALL cl_err('','apm-936',1)
                                 LET g_action_choice = ''
                                 CONTINUE WHILE
                              END IF
                            #TQC-D80002 --------End----------

                            ##---- 20190718 ASRS倉不可還原(S)
                            LET l_cnt = 0
                            SELECT COUNT(*) INTO l_cnt FROM tc_tlf_file
                             WHERE tc_tlf905 = g_ina.ina01
                            #  AND tc_tlfexists <> '0'
                            IF l_cnt > 0 THEN 
                               CALL cl_err('','cws-001',1)
                               CONTINUE WHILE
                            END IF
                            ##---- 20190718 ASRS倉且狀態不為0不可還原(E)

                              IF cl_confirm('asf-663') THEN  #TQC-AC0216
                                 LET g_msg="aimp379 '",g_ina.ina01,"' 'Y' "  #TQC-AC0216
                                 CALL cl_cmdrun_wait(g_msg)
                              END IF  #TQC-AC0216                           
                          END IF     #FUN-C30257 add
                        END IF                                                    
                        #No.FUN-A50071 ----------end----------  
                     END IF
                  END IF      #FUN-AC0074
                  SELECT ina08,inapost,ina02
                    INTO g_ina.ina08,g_ina.inapost,g_ina.ina02
                    FROM ina_file
                   WHERE ina01=g_ina.ina01
                  DISPLAY BY NAME g_ina.ina08,g_ina.inapost,g_ina.ina02
                  CALL t370_pic() #FUN-720002
               ELSE
                  IF g_ina.inaconf = 'X' THEN #FUN-660079
                     #作廢!
                     CALL cl_err(g_ina.ina01,9024,0)
                  END IF
                  IF (g_ina.inapost = 'N') OR (g_ina.inaconf = 'N') THEN #FUN-660079
                      #未過帳資料不可過帳還原!
                     CALL cl_err(g_ina.ina01,'afa-108',1)
                  END IF
               END IF
            END IF
       #@WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #FUN-B10016 add str -------
              #若有與CRM整合,需先取得是否可刪除命令
               IF NOT cl_null(g_ina.ina10) AND g_ina.ina05 = 'Y' AND g_aza.aza123 MATCHES "[Yy]" THEN
                 CALL aws_crmcli('aimt370','chkdel','2',g_ina.ina01,'') RETURNING g_crmStatus,g_crmDesc
                 IF g_crmStatus <> 0 THEN
                    CALL cl_err(g_crmDesc,'!',1)
                 ELSE
                   #CALL t370_x()       #CHI-D20010
                    CALL t370_x(1)      #CHI-D20010
                    LET g_wc2 = ''      #MOD-C30533
                    CALL t370_show()    #TQC-C20223
                    CALL t370_pic() #FUN-720002                    
                 END IF
               ELSE
              #FUN-B10016 add end -------
                #CALL t370_x()       #CHI-D20010
                 CALL t370_x(1)      #CHI-D20010
                 LET g_wc2 = ''      #MOD-C30533
                 CALL t370_show()       #TQC-C20223
                 CALL t370_pic() #FUN-720002
               END IF                          #FUN-B10016 add
            END IF
       
        #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               #FUN-B10016 add str -------
              #若有與CRM整合,需先取得是否可刪除命令
               IF NOT cl_null(g_ina.ina10) AND g_ina.ina05 = 'Y' AND g_aza.aza123 MATCHES "[Yy]" THEN
                 CALL aws_crmcli('aimt370','chkdel','2',g_ina.ina01,'') RETURNING g_crmStatus,g_crmDesc
                 IF g_crmStatus <> 0 THEN
                    CALL cl_err(g_crmDesc,'!',1)
                 ELSE
                   #CALL t370_x()       #CHI-D20010
                    CALL t370_x(2)      #CHI-D20010
                    LET g_wc2 = ''      #MOD-C30533
                    CALL t370_show()    #TQC-C20223
                    CALL t370_pic() #FUN-720002
                 END IF
               ELSE
              #FUN-B10016 add end -------
                #CALL t370_x()    #CHI-D20010
                 CALL t370_x(2)   #CHI-D20010
                 LET g_wc2 = ''      #MOD-C30533
                 CALL t370_show()       #TQC-C20223
                 CALL t370_pic() #FUN-720002
               END IF                          #FUN-B10016 add
            END IF
       #CHI-D20010---end
 
 
	     WHEN "exporttoexcel" #FUN-4B0002
            LET w = ui.Window.getCurrent()   #FUN-D10081 add
            LET f = w.getForm()              #FUN-D10081 add
            IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-D10081 add   
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page_main")                 #FUN-D10081 add   
                  #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_inb),'','')    #FUN-D10081 mark
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_inb),'','')    #FUN-D10081 add
               END IF
            #FUN-D10081---add---str---
            END IF 
            IF g_action_flag = "page_list" THEN
               LET page = f.FindNode("Page","page_list")
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_ina_l),'','')
               END IF
            END IF
            #FUN-D10081---add---end---  
 
       ##EasyFlow送簽
         WHEN "easyflow_approval"     #FUN-550047
            IF cl_chk_act_auth() THEN
              #FUN-C20025 add str---
               SELECT * INTO g_ina.* FROM ina_file
                WHERE ina01 = g_ina.ina01
               CALL t370_show()
#FUN-C20101-----ADD------STR-------
#FUN-C20101-----ADD------END-------               
               CALL t370_b_fill(' 1=1')
#FUN-C20101----ADD--&endif------
               
              #FUN-C20025 add end---
               CALL t370_ef()
               CALL t370_show()  #FUN-C20025 add
            END IF
            CALL t370_pic() #FUN-720002
 
        #@WHEN "簽核狀況"
         WHEN "approval_status"
            IF cl_chk_act_auth() THEN        #DISPLAY ONLY
               IF aws_condition2() THEN                #FUN-550047
                  CALL aws_efstat2()                  #MOD-560007
               END IF
            END IF

         #No:DEV-D30026--add--begin
         WHEN "barcode_gen"     #條碼產生
             IF cl_chk_act_auth() THEN
                #CALL t370_barcode_gen()     #DEV-D30045--mark
                CALL t370sub_barcode_gen(g_ina.ina01,'Y') #DEV-D30045--add
             END IF

         WHEN "barcode_query"   #條碼查詢
             IF cl_chk_act_auth() THEN
                IF g_ina.ina01 IS NULL THEN
                   CALL cl_err('',-400,0)
                ELSE
                   LET g_cmd = "abaq100 '",g_ina.ina01,"' "
                   CALL cl_cmdrun_wait(g_cmd)
                END IF
             END IF

         WHEN "barcode_output"  #條碼列印
             IF cl_chk_act_auth() THEN
                IF g_ina.ina01 IS NULL THEN
                   CALL cl_err('',-400,0)
                ELSE
                   LET g_msg=' ibb03="',g_ina.ina01 CLIPPED,'"'
                   LET g_cmd = "abar100",
                       " '",g_today CLIPPED,"' ''",
                       " '",g_lang CLIPPED,"' 'Y' '' '1'",
                       " '' '' '' '' ",
                       " '",g_msg CLIPPED,"' ",
                      #" 'C' 'I' '2'"      #DEV-D30045--mark
                       " ' ' 'I' '",s_gen_barcode_ibd07(),"'"   #DEV-D30045--mod
                   CALL cl_cmdrun_wait(g_cmd)
                END IF
             END IF
         #No:DEV-D30026--add--end

         #@WHEN "准"
         WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = 'N' THEN #最後一關
                 CALL t370sub_y_upd(g_ina.ina01,'Y',FALSE) #FUN-660079 #FUN-B50138
                 CALL t370_refresh() RETURNING g_ina.*  #FUN-B50138
                 CALL t370_show()                       #FUN-B50138
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
                           LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1
                           IF NOT cl_null(g_argv2) THEN
                              CALL t370_q()
                              #設定簽核功能及哪些 action 在簽核狀態時是不可被執行
#FUN-A50036 mod str ---
                             #CALL aws_efapp_flowaction("insert, modify,delete, reproduce, detail, query, locale,void,confirm, undo_confirm, easyflow_approval")                                                        #FUN-A50095 mark
                              CALL aws_efapp_flowaction("insert, modify,delete, reproduce, detail, query, locale,void,undo_void,confirm, undo_confirm, easyflow_approval, stock_post, undo_post, warahouse_modify,barcode_gen,over_qty")               #FUN-A50095 add  #CHI-D20010 add undo_void   #FUN-D30030 add barcode_gen
#FUN-A50036 mod end ---  
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
                      LET g_ina.ina08 = 'R'
                      DISPLAY BY NAME g_ina.ina08
                   END IF
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                         LET l_flowuser = 'N'
                         LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1
                         IF NOT cl_null(g_argv2) THEN
                            CALL t370_q()
                            #設定簽核功能及哪些 action 在簽核狀態時是不可被執行>
#FUN-A50036 mod str ---
                           #CALL aws_efapp_flowaction("insert, modify,delete, reproduce, detail, query, locale,void,confirm, undo_confirm, easyflow_approval")                                                        #FUN-A50095 mark
                            CALL aws_efapp_flowaction("insert, modify,delete, reproduce, detail, query, locale,void, undo_void, confirm, undo_confirm, easyflow_approval, stock_post, undo_post, warahouse_modify,over_qty")               #FUN-A50095 add  #CHI-D20010 add undo_void  #DEV-D30030 add barcode_gen
#FUN-A50036 mod end ---  
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
 
         WHEN "warahouse_modify"
            IF cl_chk_act_auth() THEN
               CALL t370_wm_b()
            END IF

         ##---- 20200317 add 
         WHEN "over_qty"  #超耗數量
            IF cl_chk_act_auth() THEN
               CALL t370_wm_b()
            END IF

         ##----- 20200211 add
         WHEN "carry_pr" #拋轉請購單
            IF cl_chk_act_auth() THEN
               CALL t370sub_exp()
            END IF
 
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_ina.ina01 IS NOT NULL THEN
                  LET g_doc.column1 = "ina01"
                  LET g_doc.value1 = g_ina.ina01
                  CALL cl_doc()
               END IF
           END IF
 
         WHEN "trans_spc"
            IF cl_chk_act_auth() THEN
               CALL t370_spc()
            END IF
 
         WHEN "qry_lot"
            IF l_ac > 0 THEN     #MOD-970097
               SELECT ima918,ima921 INTO g_ima918,g_ima921
                 FROM ima_file
                WHERE ima01 = g_inb[l_ac].inb04
                  AND imaacti = "Y"
            
            IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
               LET g_success = 'Y'              #CHI-A10016
               BEGIN WORK                       #CHI-A10016
               LET g_img09 = ''   LET g_img10 = 0   #MOD-A40089 add
               SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
                WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
                  AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
               CALL s_umfchk(g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09)
                   RETURNING l_i,l_fac
               IF l_i = 1 THEN LET l_fac = 1 END IF
               IF g_ina.ina00 = "1" OR g_ina.ina00 = "2" #MOD-910104 mark THEN
                  OR  g_ina.ina00 ="5" OR g_ina.ina00 = "6" THEN  #出庫 #MOD-910104 add
                 #CALL s_lotout(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,      #TQC-B90236 mark
                  CALL s_mod_lot(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,      #TQC-B90236 add
                                g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                                g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                                g_inb[l_ac].inb08,g_img09,  
                                g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,'','QRY',-1) #CHI-9A0022 add ''   #TQC-B90236 add'-1'
                     RETURNING l_r,g_qty 
                 #-CHI-A10016-add-
                  IF g_success = "Y" THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK    
                  END IF
                 #-CHI-A10016-end-
               END IF    
               IF g_ina.ina00 = "3" OR g_ina.ina00 = "4" THEN
#No.TQC-B90236-----mark-----begin-----
#                 CALL s_lotin(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,      
#                              g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09,  
#                              g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,'','QRY') #CHI-9A0022 add ''
#No.TQC-B90236-----mark-----end-------
#No.TQC-B90236-----add------begin-----
                  CALL s_mod_lot(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,      
                                g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                                g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                                g_inb[l_ac].inb08,g_img09,
                                g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,'','QRY',1) 
#No.TQC-B90236-----add------end-------
                     RETURNING l_r,g_qty 
               END IF
            END IF
         END IF   #MOD-970097
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t370_a()
DEFINE li_result LIKE type_file.num5                #No.FUN-550029  #No.FUN-690026 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_inb.clear()
#FUN-C20101-----ADD----STR----
#FUN-C20101-----ADD----END----   
   INITIALIZE g_ina.* TO NULL
   LET g_ina.inaplant = g_plant #FUN-980004 add
   LET g_ina.inalegal = g_legal #FUN-980004 add
   LET g_ina_o.* = g_ina.*
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t370_a_default()
      CALL t370_i("a")                #輸入單頭
 
      IF INT_FLAG THEN
         INITIALIZE g_ina.* TO NULL
         LET INT_FLAG=0
         CALL cl_err('',9001,0)
         ROLLBACK WORK
         EXIT WHILE
      END IF
      IF g_ina.ina01 IS NULL THEN CONTINUE WHILE END IF
 
      BEGIN WORK
      IF NOT t370_a_inschk() THEN
         CONTINUE WHILE
      END IF
      IF NOT t370_a_ins() THEN
         ROLLBACK WORK #No:7857
         CONTINUE WHILE
      ELSE
         COMMIT WORK #No:7857
         CALL cl_flow_notify(g_ina.ina01,'I')
      END IF
      SELECT ina01 INTO g_ina.ina01 FROM ina_file WHERE ina01 = g_ina.ina01 
      LET g_ina_t.* = g_ina.* 
#FUN-C20101-------ADD----STR----
#FUN-C20101-------ADD--END----      
      CALL t370_g()      #FUN-930064
#FUN-C20101------ADD-&endif-----------      
      SELECT COUNT(*) INTO g_cnt FROM inb_file WHERE inb01=g_ina.ina01 
      IF g_cnt>0 THEN
         IF g_smy.smyprint='Y' THEN
            IF cl_confirm('mfg9392') THEN CALL t370_out() END IF
         END IF
         IF g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y' THEN
            LET g_action_choice = "insert"
            CALL t370sub_y_chk(g_ina.ina01,g_argv1,'Y') #FUN-B50138  #TQC-C40079 add Y 
            IF g_success = "Y" THEN
               CALL t370sub_y_upd(g_ina.ina01,'Y',FALSE) #FUN-B50138
            END IF
            CALL t370_refresh() RETURNING g_ina.*  #FUN-B50138
            CALL t370_show()                       #FUN-B50138
         END IF
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t370_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ina.ina01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ina.* FROM ina_file WHERE ina01=g_ina.ina01 
    IF g_ina.inaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660079
    IF g_ina.inaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #FUN-660079
    IF g_ina.ina08 matches '[Ss]' THEN          #FUN-550047
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ina_o.* = g_ina.*
 
    BEGIN WORK
 
    OPEN t370_cl USING g_ina.ina01
    IF STATUS THEN
       CALL cl_err("OPEN t370_cl:", STATUS, 1)
       CLOSE t370_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t370_cl INTO g_ina.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t370_cl ROLLBACK WORK RETURN
    END IF
    CALL t370_show()
    WHILE TRUE
        LET g_ina.inamodu=g_user
        LET g_ina.inadate=g_today
        LET g_ina.inapos='N'               #No.FUN-870100
        CALL t370_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            ROLLBACK WORK
            LET g_ina.*=g_ina_t.*
            CALL t370_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF NOT t370_u_upd() THEN
           CONTINUE WHILE
        ELSE
           COMMIT WORK
           CALL cl_flow_notify(g_ina.ina01,'U')
        END IF
        IF g_ina.ina01 != g_ina_t.ina01 THEN CALL t370_chkkey() END IF
        EXIT WHILE
    END WHILE
    CLOSE t370_cl
    CALL t370_pic() #FUN-720002
 
END FUNCTION
 
FUNCTION t370_inaplant(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_inaplant_desc LIKE gem_file.gem02
 
 #SELECT azp02 INTO l_inaplant_desc FROM azp_file WHERE azp01 = g_plant        #MOD-FC0134 mark
  SELECT azp02 INTO l_inaplant_desc FROM azp_file WHERE azp01 = g_ina.inaplant #MOD-FC0134 add
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_inaplant_desc TO FORMONLY.inaplant_desc
  END IF
 
END FUNCTION
 
FUNCTION t370_inaconu(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_inaconu_desc LIKE gen_file.gen02
 
   SELECT gen02 INTO l_inaconu_desc FROM gen_file WHERE gen01 = g_ina.inaconu AND genacti='Y'
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_inaconu_desc TO FORMONLY.inaconu_desc
   END IF
 
END FUNCTION
 
FUNCTION t370_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1    #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
 
    DISPLAY BY NAME g_ina.inaoriu,g_ina.inaorig,g_ina.ina00

    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT BY NAME 
        g_ina.ina01,g_ina.ina03,g_ina.ina02,g_ina.ina11,g_ina.ina04,#No.FUN-630046
        g_ina.ina06,g_ina.ina07,g_ina.ina12,g_ina.inaconf,g_ina.inaspc,g_ina.inapost,g_ina.inamksg, #FUN-660079 add g_ina.inaconf  #FUN-680010
        g_ina.ina08,g_ina.inapos,g_ina.inauser, #FUN-550047 add inamksg,ina08
        g_ina.inagrup,g_ina.inamodu,g_ina.inadate,
        g_ina.inaud01,g_ina.inaud02,g_ina.inaud03,g_ina.inaud04,
        g_ina.inaud05,g_ina.inaud06,g_ina.inaud07,g_ina.inaud08,
        g_ina.inaud09,g_ina.inaud10,g_ina.inaud11,g_ina.inaud12,
        g_ina.inaud13,g_ina.inaud14,g_ina.inaud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t370_set_entry(p_cmd)
            CALL t370_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("ina01")   #No.FUN-550029
            LET g_ina.inaplant=g_plant
            DISPLAY BY NAME g_ina.inaplant
            CALL t370_inaplant('a')
 
        AFTER FIELD ina01
            IF NOT t370_chk_ina01() THEN
               #NEXT FIELD CURRENT  #MOD-D80034
               #EXIT INPUT  #MOD-D80034       #MOD-E30039 mark
               IF p_cmd = 'u' THEN            #MOD-E30039 add
                  EXIT INPUT                  #MOD-E30039 add
               ELSE                           #MOD-E30039 add
                  NEXT FIELD CURRENT          #MOD-E30039 add 
               END IF                         #MOD-E30039 add 
            END IF
 
        AFTER FIELD ina02
            IF NOT t370_chk_ina02() THEN
               NEXT FIELD CURRENT
            END IF
 
        AFTER FIELD ina11
            IF NOT t370_chk_ina11() THEN
               NEXT FIELD CURRENT
            END IF
            #FUN-CB0087---add---str---
            #MOD-D60002--mark begin-----
#            IF NOT t370_inb15_chk2() THEN
#               NEXT FIELD ina11
#            END IF
            #MOD-D60002--mark end-------
            #FUN-CB0087---add---end---
 
        AFTER FIELD ina04
            IF NOT t370_chk_ina04() THEN
               NEXT FIELD CURRENT
            END IF

            ##---- 20210809 modify start
            #研發單位領用，專案代碼不可為空
            IF g_ina.ina04 matches 'T17*' THEN
               CALL cl_set_comp_required("inb41",TRUE)
            ELSE 
               CALL cl_set_comp_required("inb41",FALSE)
            END IF
            ##--- 20210809 modify end

          #190416 add by ruby --e--
            #FUN-CB0087---add---str---
            #MOD-D60002--mark begin-----
#            IF NOT t370_inb15_chk2() THEN
#               NEXT FIELD ina04
#            END IF
            #MOD-D60002--mark end-------
            #FUN-CB0087---add---end---
 
        AFTER FIELD ina06
            IF NOT t370_chk_ina06() THEN
               NEXT FIELD CURRENT
            END IF
 
        AFTER FIELD inaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
        AFTER INPUT
           LET g_ina.inauser = s_get_data_owner("ina_file") #FUN-C10039
           LET g_ina.inagrup = s_get_data_group("ina_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
           #MOD-E20008-Start-Add
           IF NOT cl_null(g_ina.ina02) THEN
	          IF g_sma.sma53 IS NOT NULL AND g_ina.ina02 <= g_sma.sma53 THEN
	             CALL cl_err('','mfg9999',0)
	             NEXT FIELD ina02
	          END IF
              CALL s_yp(g_ina.ina02) RETURNING g_yy,g_mm
              IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
                 CALL cl_err('','mfg6091',0)
                 NEXT FIELD ina02
              END IF
           END IF
           #MOD-E20008-End-Add
           
           IF NOT t370_i_aft_inp() THEN
              NEXT FIELD ina04
           END IF
 
         ON ACTION controlp
            CASE WHEN INFIELD(ina01) #查詢單据
                      LET g_t1=s_get_doc_no(g_ina.ina01)  #No.FUN-550029
                      CASE WHEN g_ina.ina00 MATCHES "[12]" LET g_chr='1'
                           WHEN g_ina.ina00 MATCHES "[34]" LET g_chr='2'
                           WHEN g_ina.ina00 MATCHES "[56]" LET g_chr='3'
                      END CASE
                      CALL q_smy(FALSE,FALSE,g_t1,'AIM',g_chr) RETURNING g_t1   #TQC-670008
                      LET g_ina.ina01=g_t1                #No.FUN-550029
                      DISPLAY BY NAME g_ina.ina01
                      NEXT FIELD ina01
 
                 WHEN INFIELD(ina11)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gen"
                      LET g_qryparam.default1 = g_ina.ina11
                      CALL cl_create_qry() RETURNING g_ina.ina11
                      DISPLAY BY NAME g_ina.ina11
                      NEXT FIELD ina11
 
                 WHEN INFIELD(ina04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_gem"
                      LET g_qryparam.default1 = g_ina.ina04
                      CALL cl_create_qry() RETURNING g_ina.ina04
                      DISPLAY BY NAME g_ina.ina04
                      NEXT FIELD ina04
                 WHEN INFIELD(ina06) #專案代號 BugNo:6548
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_pja2"  #FUN-810045
                      LET g_qryparam.default1 =  g_ina.ina06
                      CALL cl_create_qry() RETURNING g_ina.ina06
                      DISPLAY BY NAME g_ina.ina06
                      NEXT FIELD ina06
 
                 WHEN INFIELD(inaconu)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gen"
                      LET g_qryparam.default1 = g_ina.inaconu
                      CALL cl_create_qry() RETURNING g_ina.inaconu
                      DISPLAY BY NAME g_ina.inaconu
                      CALL t370_inaconu('a')
                      NEXT FIELD inaconu                 
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
    END INPUT
END FUNCTION
 
FUNCTION t370_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ina.* TO NULL                   #No.FUN-680046
    CALL cl_msg("")                              #FUN-640245
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
 
    IF g_sma.sma120 = 'Y'  THEN
       LET lg_smy62 = ''
       LET lg_group = ''
       CALL t370_refresh_detail()
    END IF
 
    CALL t370_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_ina.* TO NULL RETURN END IF
    CALL cl_msg(" SEARCHING ! ")                              #FUN-640245
 
    OPEN t370_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ina.* TO NULL
    ELSE
        OPEN t370_count
        FETCH t370_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t370_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")                              #FUN-640245
END FUNCTION
 
FUNCTION t370_fetch(p_flag)
DEFINE p_flag       LIKE type_file.chr1    #處理方式  #No.FUN-690026 VARCHAR(1)
DEFINE l_slip       LIKE smy_file.smyslip  #No.TQC-650115 #No.FUN-690026 VARCHAR(10)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t370_cs INTO g_ina.ina01
        WHEN 'P' FETCH PREVIOUS t370_cs INTO g_ina.ina01
        WHEN 'F' FETCH FIRST    t370_cs INTO g_ina.ina01
        WHEN 'L' FETCH LAST     t370_cs INTO g_ina.ina01
        WHEN '/'
            IF (NOT mi_no_ask) THEN    #No.FUN-6A0061
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
            FETCH ABSOLUTE g_jump t370_cs INTO g_ina.ina01
            LET mi_no_ask = FALSE    #No.FUN-6A0061
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)
        INITIALIZE g_ina.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_ina.* FROM ina_file WHERE ina01 = g_ina.ina01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"",
                    "",1)  #No.FUN-660156
       INITIALIZE g_ina.* TO NULL
       RETURN
    ELSE
       LET g_data_owner = g_ina.inauser    #FUN-4C0053
       LET g_data_group = g_ina.inagrup    #FUN-4C0053
       LET g_data_plant = g_ina.inaplant   #FUN-980030
       LET g_data_keyvalue = g_ina.ina01   #FUN-DA0124 add
    END IF
    #在使用Q查詢的情況下得到當前對應的屬性組smy62
    IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
       LET l_slip = g_ina.ina01[1,g_doc_len]
       SELECT smy62 INTO lg_smy62 FROM smy_file
        WHERE smyslip = l_slip
    END IF
    CALL t370_show()
END FUNCTION
 
FUNCTION t370_aft_del()
   CLEAR FORM
   CALL g_inb.clear()
#FUN-C20101-----ADD---STR---
#FUN-C20101-----ADD---END---   
   INITIALIZE g_ina.* TO NULL
   MESSAGE ""
   OPEN t370_count
   #FUN-B50062-add-start--
   IF STATUS THEN
      CLOSE t370_cs
      CLOSE t370_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end-- 
   FETCH t370_count INTO g_row_count
   #FUN-B50062-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE t370_cs
      CLOSE t370_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end-- 
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t370_cs
   IF g_curs_index = g_row_count + 1 THEN
      LET g_jump = g_row_count
      CALL t370_fetch('L')
   ELSE
      LET g_jump = g_curs_index
      LET mi_no_ask = TRUE     #No.FUN-6A0061
      CALL t370_fetch('/')
   END IF
END FUNCTION
 
FUNCTION t370_b()
DEFINE
   #l_flag2         LIKE type_file.chr1,    #TQC-D70030 add #MOD-F90136 mark
    l_flag3         LIKE type_file.chr1,    #TQC-D70030 add
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態  #No.FUN-690026 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否  #No.FUN-690026 SMALLINT
    l_ima08         LIKE ima_file.ima08,
    l_check_res     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_type          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_ina08         LIKE ina_file.ina08,
    l_inb03_o       LIKE inb_file.inb03,
    l_coc04         LIKE coc_file.coc04
DEFINE l_pja26      LIKE pja_file.pja26,
       l_cnt        LIKE type_file.num5,
       l_pjb25      LIKE pjb_file.pjb25,
       l_act        LIKE type_file.chr1
DEFINE #l_sql     LIKE type_file.chr1000
       l_sql      STRING     #NO.FUN-910082                                      
DEFINE l_inb09   LIKE inb_file.inb09,                                        
       l_inb03   LIKE inb_file.inb03,                                        
       l_inb10   LIKE inb_file.inb10,                                        
       l_qcs01   LIKE qcs_file.qcs01,                                        
       l_qcs02   LIKE qcs_file.qcs02,                                        
       l_qcs091c LIKE qcs_file.qcs091                                        
DEFINE l_pjb09   LIKE pjb_file.pjb09    #No.FUN-850027
DEFINE l_pjb11   LIKE pjb_file.pjb11    #No.FUN-850027
DEFINE l_ima15   LIKE ima_file.ima15    #No.CHI-950013      
DEFINE l_n       LIKE type_file.num5       #FUN-870100
DEFINE l_bno     LIKE rvbs_file.rvbs08  #No.CHI-9A0022
DEFINE l_qcl05   LIKE qcl_file.qcl05    #FUN-BC0104
DEFINE l_type1   LIKE type_file.chr1    #FUN-BC0104
DEFINE l_inb     RECORD LIKE inb_file.*   #TQC-C60007
DEFINE l_ima159  LIKE ima_file.ima159   #FUN-B50096
#FUN-B50096 -----------------End-------------------------
#FUN-C20101----ADD---STR-----
#FUN-C20101----ADD---END------
DEFINE l_c     LIKE type_file.num5     #CHI-C30106 add 
DEFINE l_flag1    LIKE type_file.chr1  #FUN-CB0087
DEFINE l_where    STRING               #FUN-CB0087


  IF NOT t370_chk_ina01() THEN  LET g_action_choice = '' RETURN END IF #MOD-E30039 add
   
  IF g_action_choice = "warahouse_modify" OR g_action_choice = "over_qty" THEN  #20200317
     LET g_wm = 'Y'
  ELSE
     LET g_wm = 'N'
  END IF
  IF g_action_choice != "over_qty" THEN  #20200317
     LET g_action_choice = ""
  END IF
  LET g_success = 'Y'   #TQC-E30007
  IF g_ina.ina01 IS NULL THEN RETURN END IF                          #FUN-DA0106 add
 
  SELECT * INTO g_ina.* FROM ina_file WHERE ina01=g_ina.ina01        #FUN-DA0106 add
  LET l_ina08 = g_ina.ina08                                          #FUN-DA0106 add
  IF g_wm != 'Y'  THEN                #No.FUN-8C0024
   #IF g_ina.ina01 IS NULL THEN RETURN END IF                        #FUN-DA0106 mark
 
   #SELECT * INTO g_ina.* FROM ina_file WHERE ina01=g_ina.ina01      #FUN-DA0106 mark
   #LET l_ina08 = g_ina.ina08   #FUN-550047                          #FUN-DA0106 mark
    IF g_ina.inaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660079
    IF g_ina.inaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #FUN-660079
    IF g_ina.ina08 matches '[Ss]' THEN       #FUN-550047
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
  END IF               #No.FUN-8C0024
 
    CALL cl_opmsg('b')
 
  IF g_wm = 'Y' THEN            #FUN-8C0024
    LET l_allow_insert = FALSE  #FUN-8C0024
    LET l_allow_delete = FALSE  #FUN-8C0024
  ELSE                          #FUN-8C0024
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
  END IF                        #FUN-8C0024
 
    LET g_forupd_sql = "SELECT * FROM inb_file ",
                       " WHERE inb01= ? AND inb03= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t370_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

#FUN-C20101----ADD-----STR-----
#FUN-C20101----ADD-----END-----
#FUN-C20101----ADD-----STR------
   IF g_rec_b=0 THEN CALL g_inb.clear() END IF 

  IF g_azw.azw04='2' AND (g_prog="aimt301_slk" OR g_prog="aimt302_slk" OR g_prog="aimt303_slk") AND g_sma.sma150='N' THEN    #FUN-D60112-add    #FUN-DB0029 add sma150
 ELSE           #FUN-D60112--add
#FUN-D60112--add &endif
#FUN-C20101----ADD-----END------ 
#    IF g_rec_b=0 THEN CALL g_inb.clear() END IF    #FUN-C20101----MARK-----
    DIALOG ATTRIBUTE(UNBUFFERED)      #FUN-DB0029 add
 
    #INPUT ARRAY g_inb WITHOUT DEFAULTS FROM s_inb.* #FUN-C20101----MARK-----  #FUN-D60112--remark  #FUN-DB0029 mark
    #     ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,               #FUN-D60112--add     #FUN-DB0029 mark
    #               INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) #FUN-D60112--add  #FUN-DB0029 mark
     INPUT ARRAY g_inb FROM s_inb.*                  #FUN-C20101---ADD------   #FUN-D60112--mark #FUN-DB0029 remark
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,    #FUN-D60112--mark #FUN-DB0029 remark
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) #FUN-D60112--mark  #FUN-DB0029 remark
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

           IF g_wm = 'Y' THEN
              IF g_action_choice = 'over_qty' THEN          #20200317
                 CALL cl_set_comp_entry("inbud07",TRUE)     #20200317
              END IF                                        #20200317
           CALL cl_set_comp_entry("inb03,inb911,inb912,inb04,inb08,inb08_fac,
                                   inb16,inb925,inb926,inb927,inb922,inb923,inb924,inb09,
                                   inb905,inb906,inb907,inb902,inb903,inb904,inb15,     
                                   inb41,inb42,inb43,inb11,inb12,inb901,inb10,inb930,
                                   inb44,inb45,inb46,inb47,inb48,inb13",FALSE)                      #FUN-C20047 add inb44-48 
                                             #FUN-BC0062 add inb13
           ELSE
           # -------MOD-BB0341 start-----------
           #CALL cl_set_comp_entry("inb03,inb911,inb912,inb04,inb08,inb08_fac,
           #                inb16,inb925,inb926,inb927,inb922,inb923,inb924, #inb09, #CHI-960092
           #                inb905,inb906,inb902,inb903,inb15,                     #CHI-960092
           #                inb41,inb42,inb43,inb11,inb12,inb901,inb10,inb930",TRUE)
           CALL cl_set_comp_entry("inb03,inb911,inb912,inb04,inb08,inb08_fac,       
                                   inb16,inb925,inb926,inb927,inb922,inb923,inb924,
                                   inb905,inb906,inb902,inb903,inb15,
                                   inb41,inb42,inb43,inb11,inb12,inb901,inb10,inb930, 
                                  inb44,inb45,inb46,inb47,inb48,inb13",TRUE)  #上段會將mark部分也視為欄位  #FUN-C20047 add inb44-48 
                                                      #FUN-BC0062 add inb13
           # -------MOD-BB0341 end----------- 
           END IF
           CALL cl_set_comp_entry("inb09,inb904,inb907",FALSE)   #CHI-960092
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET g_value = NULL
            LET g_inb04 = NULL
            LET g_chr4  = '0'
            LET g_chr3  = '0'
            #FUN-BB0085-add-str--
            LET g_inb08_t = NULL
            LET g_inb902_t= NULL
            LET g_inb905_t= NULL
            LET g_inb922_t= NULL
            LET g_inb925_t= NULL
            #FUN-BB0085-add-end--
 
            BEGIN WORK
 
            OPEN t370_cl USING g_ina.ina01
            IF STATUS THEN
               CALL cl_err("OPEN t370_cl:", STATUS, 1)
               CLOSE t370_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t370_cl INTO g_ina.*          # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                  CLOSE t370_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_inb_t.* = g_inb[l_ac].*  #BACKUP
               LET g_inb03_o = g_inb[l_ac].inb03  #MOD-FA0119 add
               #FUN-BB0085-add-str--
               LET g_inb08_t = g_inb[l_ac].inb08
               LET g_inb902_t= g_inb[l_ac].inb902
               LET g_inb905_t= g_inb[l_ac].inb905
               LET g_inb922_t= g_inb[l_ac].inb922
               LET g_inb925_t= g_inb[l_ac].inb925
               #FUN-BB0085-add-end--
               #MOD-F10035-Start-Add
               IF g_sma.sma115 = 'Y' THEN  #多單位
                 LET g_ima906 = NULL
                 SELECT ima906 INTO g_ima906 FROM ima_file
                  WHERE ima01 = g_inb[l_ac].inb04
               END IF 
               #MOD-F10035-End-Add
                
               OPEN t370_bcl USING g_ina.ina01,g_inb_t.inb03
               IF STATUS THEN
                  CALL cl_err("OPEN t370_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t370_bcl INTO b_inb.*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('lock inb',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                     CALL t370_b_move_to()
                      LET g_inb[l_ac].gem02c=s_costcenter_desc(g_inb[l_ac].inb930) #FUN-670093
                  END IF
               END IF
#&ifdef ICD    #FUN-B50096 
               CALL t370_set_no_required_inb07()   #FUN-A40022
               CALL t370_set_required_inb07(p_cmd) #FUN-A40022
               CALL t370_set_entry_inb07()         #FUN-B50096
               CALL t370_set_no_entry_inb07()      #FUN-B50096
               #FUN-BC0104-add-str--
               CALL t370_set_entry_inb()
               IF NOT cl_null(g_inb[l_ac].inb46) THEN 
                  CALL t370_qcl02_sel()
                  CALL cl_set_comp_entry('inb03,inb10',FALSE)    #MOD-C30541 add inb10
               END IF
               #FUN-BC0104-add-end--
          
          ##----- 20210809 mark by momo start 程式段搬移 
          #190416 add by ruby --s-- 研發單位領用，專案代碼不可為空
          #IF g_ina.ina04 matches 'T17*' THEN
          #  CALL cl_set_comp_required("inb41",TRUE)
          #ELSE 
          #  CALL cl_set_comp_required("inb41",FALSE)
          #END IF
          #190416 add by ruby --e--
          ##----- 20210809 mark by momo end
                         
               LET g_change='N'  #No.FUN-540025
               LET g_yes='N'
               IF g_wm != 'Y' THEN    #FUN-8C0024
                  CALL t370_set_entry_b()
                  CALL t370_set_no_entry_b()
               ELSE                   #FUN-8C0024
                  IF g_action_choice = 'over_qty' THEN   #20200317
                     NEXT FIELD inbud07
                  ELSE
                     NEXT FIELD inb05
                  END IF
               END IF                 #FUN-8C0024
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            CALL t370_b_bef_ins()
            CALL cl_set_comp_required('inb44,inb45,inb46,inb47,inb48',FALSE)       #FUN-BC0104 add
            CALL cl_set_comp_entry('inb03,inb44,inb45,inb46,inb47,inb48,inb10',TRUE)     #FUN-BC0104 add  #MOD-C30541 add inb03,inb10
            NEXT FIELD inb03
 
        AFTER INSERT            
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
#FUN-B50096 ---------------Begin------------------
#&ifdef ICD
#           #FUN-A40022--begin--add---------
#           IF NOT cl_null(g_inb[l_ac].inb04) THEN
#              SELECT imaicd13 INTO l_imaicd13 
#                FROM imaicd_file
#               WHERE imaicd00 = g_inb[l_ac].inb04
#              IF l_imaicd13 = 'Y' AND cl_null(g_inb[l_ac].inb07) THEN
#                 CALL cl_err(g_inb[l_ac].inb04,'aim-034',1)
#                 NEXT FIELD inb07 
#              END IF
#           END IF
#           #FUN-A40022--end--add-----------
#&endif
            IF NOT cl_null(g_inb[l_ac].inb04) THEN
               SELECT ima159 INTO l_ima159 FROM ima_file
                WHERE ima01 = g_inb[l_ac].inb04
               IF l_ima159 = '1' AND cl_null(g_inb[l_ac].inb07) THEN
                  CALL cl_err(g_inb[l_ac].inb04,'aim-034',1)
                  NEXT FIELD inb07
               END IF
            END IF
#FUN-B50096 ---------------End------------------
 
            CASE t370_b_inschk()
               WHEN "inb04"  NEXT FIELD inb04
               WHEN "inb907" NEXT FIELD inb927       #CHI-A20020
               WHEN "inb904" NEXT FIELD inb922       #CHI-A20020
               WHEN "inb05"  NEXT FIELD inb05
               WHEN "errno"  CANCEL INSERT  #has g_errno
            END CASE
 
            CALL t370_b_move_back()
            CALL t370_b_else()
        

#MOD-B70023 -- begin --
            LET g_ima918 = ''      #DEV-D50009 add
            LET g_ima921 = ''      #DEV-D50009 add
            LET g_ima930 = ''      #DEV-D50009 add
            SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930    #DEV-D30059 add g_ima930
               FROM ima_file
               WHERE ima01 = g_inb[l_ac].inb04 AND imaacti = 'Y'

           #DEV-D50009 add str--------
            IF cl_null(g_ima918) THEN LET g_ima918 = 'N' END IF   
            IF cl_null(g_ima921) THEN LET g_ima921 = 'N' END IF
           #DEV-D50009 add end--------
            IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add
            IF (g_ima918 = 'Y' OR g_ima921 = 'Y') AND g_inb[l_ac].inb10 = 'N'                
               AND (g_inb[l_ac].inb16 <> g_inb_t.inb16 OR cl_null(g_inb_t.inb16)) THEN
               LET g_success = "Y"
               LET g_img09 = ''
               SELECT img09 INTO g_img09 FROM img_file
                  WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
                  AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
               CALL s_umfchk(g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09)
                  RETURNING l_i,l_fac
               IF l_i = 1 THEN
                  LET l_fac = 1
               END IF
               IF g_ina.ina00 = "1" OR g_ina.ina00 = "2"
                  OR  g_ina.ina00 = "5" OR g_ina.ina00 = "6" THEN
                  IF cl_null(g_inb[l_ac].inb41) THEN
                     LET l_bno = ''
                  ELSE
                     LET l_bno = g_inb[l_ac].inb41
                  END IF
                 #CALL s_lotout(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,     #TQC-B90236 mark
                  IF g_ima930 = 'N' AND g_sma.sma150='N' THEN      #DEV-D30059 add   #TQC-DB0021 add sam150
                     CALL s_mod_lot(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0, #TQC-B90236 add
                                   g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                                   g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                                   g_inb[l_ac].inb08,g_img09,
                                   g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD',-1)         #TQC-B90236 add '-1'
                        RETURNING l_r,g_qty
                  END IF                                                    #DEV-D30059 add
                  IF l_r = "Y" THEN
                     LET g_qty = s_digqty(g_qty,g_inb[l_ac].inb08)   #FUN-BB0085
                     LET g_inb[l_ac].inb16 = g_qty
                     LET g_inb[l_ac].inb09 = g_qty
                     LET b_inb.inb16 = g_qty
                     LET b_inb.inb09 = g_qty
                  END IF
               END IF
               IF g_ina.ina00 = "3" OR g_ina.ina00="4" THEN
                  IF cl_null(g_inb[l_ac].inb41) THEN
                     LET l_bno = ''
                  ELSE
                     LET l_bno = g_inb[l_ac].inb41
                  END IF
#No.TQC-B90236-----mark----begin-------
#                 CALL s_lotin(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,
#                              g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09,
#                              g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD')
#No.TQC-B90236-----mark----end---------
#No.TQC-B90236-----add-----begin-------
                  IF g_ima930 = 'N' AND g_sma.sma150='N' THEN     #DEV-D30059 add  #TQC-DB0021 add sam150
                     CALL s_mod_lot(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,    
                                   g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                                   g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                                   g_inb[l_ac].inb08,g_img09,
                                   g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD',1)     
#No.TQC-B90236-----add-----end---------
                        RETURNING l_r,g_qty
                  END IF                                                    #DEV-D30059 add
                  IF l_r = "Y" THEN       #MOD-B30036 add
                     LET g_qty = s_digqty(g_qty,g_inb[l_ac].inb08)   #FUN-BB0085
                     LET g_inb[l_ac].inb16 = g_qty
                     LET g_inb[l_ac].inb09 = g_qty
                     LET b_inb.inb16 = g_qty
                     LET b_inb.inb09 = g_qty
                  END IF
               END IF
            END IF
#MOD-B70023 -- end -- 

            #IF 有專案且要做預算控管，check料件， if 沒做批號管理也沒做序號管理，則要寫入rvbs_file
            LET g_success = 'Y'
            IF s_chk_rvbs(g_inb[l_ac].inb41,g_inb[l_ac].inb04) THEN
               CALL t370_rvbs()   #FUN-810045 add
            END IF
            IF g_success = 'N' THEN
	       CANCEL INSERT
               NEXT FIELD inb03
            END IF
 
            IF NOT t370_b_ins() THEN
               CANCEL INSERT
               SELECT ima918,ima921 INTO g_ima918,g_ima921
                 FROM ima_file
                WHERE ima01 = g_inb[l_ac].inb04
                  AND imaacti = "Y"
               
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  IF g_ina.ina00 = "1" OR g_ina.ina00 = "2" #MOD-910104 mark THEN
                     OR  g_ina.ina00 = "5" OR g_ina.ina00 = "6" THEN  #出庫 #MOD-910104 add
                    #IF NOT s_lotout_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045   #TQC-B90236 mark
                     IF NOT s_lot_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045   #TQC-B90236 add
                        CALL cl_err3("del","rvbs_file",g_ina.ina01,g_inb_t.inb03,
                                      SQLCA.sqlcode,"","",1)
                        ROLLBACK WORK      #CHI-A10016 
                        CANCEL INSERT      #CHI-A10016
                     END IF
                  END IF
                  IF g_ina.ina00 = "3" OR g_ina.ina00 = "4" THEN
                    #IF NOT s_lotin_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045 #TQC-B90236 mark
                     IF NOT s_lot_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045 #TQC-B90236 add
                        CALL cl_err3("del","rvbs_file",g_ina.ina01,g_inb_t.inb03,
                                      SQLCA.sqlcode,"","",1)
                     END IF
                  END IF
               END IF
            ELSE
               #FUN-BC0104-add-str--
               CALL t370_qcl05_sel() RETURNING l_qcl05
               IF l_qcl05 = '1' THEN LET l_type1 = '6' ELSE LET l_type1 = '4' END IF 
               IF NOT s_iqctype_upd_qco20(g_inb[l_ac].inb44,g_inb[l_ac].inb45,g_inb[l_ac].inb48,g_inb[l_ac].inb47,l_type1) THEN
                  ROLLBACK WORK
                  CANCEL INSERT
               END IF
               #FUN-BC0104-add-end--
               MESSAGE 'INSERT O.K'
               LET l_ina08 = '0'          #FUN-550047
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE FIELD inb03                            #default 序號
            CALL t370_bef_inb03()
            #FUN-BC0104---add---str---
            IF p_cmd = 'a' THEN
               CALL cl_set_comp_required('inb44,inb45,inb46,inb47,inb48',FALSE)
               CALL cl_set_comp_entry('inb03,inb44,inb45,inb46,inb47,inb48',TRUE)
            END IF
            #FUN-BC0104---add---end---            
 
        AFTER FIELD inb03                        #check 序號是否重複
            IF NOT t370_chk_inb03() THEN
               NEXT FIELD CURRENT
            END IF
           #MOD-FA0119--add--start---------------------
            IF g_inb[l_ac].inb03 != g_inb03_o THEN
               IF g_sma.sma150 = 'Y' THEN
                  CALL t370_upd_inbc_slk(g_inb[l_ac].inb04,g_inb[l_ac].inb03,g_inb03_o)
               END IF
            END IF
           #MOD-FA0119--add--start--------------------- 
           #MOD-EA0129-Start-Add
            IF p_cmd = 'u' AND ( g_inb[l_ac].inb03 != g_inb_t.inb03) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM rvbs_file
                WHERE rvbs00 = g_prog
                  AND rvbs01 = g_ina.ina01    #入庫單號(ina01) 
                  AND rvbs02 = g_inb_t.inb03  #項次(需用異動前的項次)
               IF l_cnt > 0 THEN 
                  UPDATE rvbs_file 
                     SET rvbs02  = g_inb[l_ac].inb03
                   WHERE rvbs00= g_prog
                     AND rvbs01= g_ina.ina01
                     AND rvbs02= g_inb_t.inb03
                  IF sqlca.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("UPD","rvbs_file",g_ina.ina01,"",STATUS,"","upd rvbs:",1)
                     NEXT FIELD inb03
                  ELSE                                  #MOD-FA0119 add
                     LET g_inb03_o = g_inb[l_ac].inb03  #MOD-FA0119 add
                  END IF    
               END IF 
               LET l_cnt = 0
            END IF    
           #MOD-EA0129-End-Add

           #MOD-C30541---mark---str---
           #IF p_cmd ='a' THEN                      #FUN-BC0104
           #   CALL t370_set_require_inb44()        #FUN-BC0104
           #END IF                                  #FUN-BC0104
           #MOD-C30541---mark---end---

        BEFORE FIELD inb911
           CALL t370_set_entry_b()
           CALL t370_set_no_required()
 
        AFTER FIELD inb911
            IF NOT t370_chk_inb911() THEN
               NEXT FIELD CURRENT
            END IF
 
        AFTER FIELD inb912
            IF NOT t370_chk_inb912() THEN
               NEXT FIELD CURRENT
            END IF

#FUN-BC0104---------add------------str---------------------------  
        AFTER FIELD inb44
           IF NOT cl_null(g_inb[l_ac].inb44) THEN 
              IF NOT t370_inb_chk() THEN  
                 CALL cl_err(g_inb[l_ac].inb44,'aqc-525',0)
                 NEXT FIELD inb44
              END IF  
              CALL t370_qc_inb_check()
              CALL t370_qco_show()   
           END IF        

        AFTER FIELD inb45
           IF NOT cl_null(g_inb[l_ac].inb45) THEN 
              IF NOT t370_inb_chk() THEN  
                 CALL cl_err(g_inb[l_ac].inb45,'aqc-528',0)
                 NEXT FIELD inb45
              END IF   
              CALL t370_qc_inb_check()
              CALL t370_qco_show()   
           END IF         
     
        BEFORE FIELD inb46
           CALL t370_set_entry_b()
       
        AFTER FIELD inb46
           IF NOT cl_null(g_inb[l_ac].inb46) THEN 
              CALL t370_qcl05_sel() RETURNING l_qcl05
              #FUN-CC0013 mark begin---
              #IF l_qcl05 = '3' THEN 
              #   CALL cl_err(g_inb[l_ac].inb46,'aqc-529',0)
              #   LET g_inb[l_ac].inb46 = ''
              #   NEXT FIELD inb46
              #END IF 
              #FUN-CC0013 mark end-----
              IF NOT t370_inb_chk() THEN  
                 CALL cl_err(g_inb[l_ac].inb46,'aqc-525',0)
                 NEXT FIELD inb46
              END IF               
              CALL t370_qcl02_sel() 
              CALL t370_qc_inb_check()
              CALL t370_qco_show() 
           ELSE 
              LET g_inb[l_ac].qcl02 = ''
           END IF
           CALL t370_set_no_entry_b()
           
           
        AFTER FIELD inb47
           IF NOT cl_null(g_inb[l_ac].inb45) THEN 
              IF NOT t370_inb_chk() THEN  
                 CALL cl_err(g_inb[l_ac].inb47,'aqc-530',0)
                 NEXT FIELD inb47
              END IF   
              CALL t370_qc_inb_check()
              CALL t370_qco_show()   
           END IF 
        
        AFTER FIELD inb48
           IF NOT cl_null(g_inb[l_ac].inb48) THEN 
              IF NOT t370_inb_chk() THEN  
                 CALL cl_err(g_inb[l_ac].inb48,'aqc-531',0)
                 NEXT FIELD inb48
              END IF 
              CALL t370_qc_inb_check()
              CALL t370_qco_show()   
           END IF 
        
#FUN-BC0104---------add------------end---------------------------        
 
        BEFORE FIELD inb04
           CALL t370_set_entry_b()
           CALL t370_set_no_required()
           CALL t370_set_no_required_inb07()   #FUN-A40022 
           CALL t370_set_entry_inb07()         #FUN-B50096  
       #MOD-CA0110---add---S
        ON CHANGE inb04
           LET g_inb[l_ac].inb08 = ' '
       #MOD-CA0110---add---E
 
        AFTER FIELD inb04
           #LET l_flag2 = 'Y'                 #TQC-D70030 add  #MOD-F90136 mark
#FUN-AA0059 ---------------------start----------------------------
            IF NOT cl_null(g_inb[l_ac].inb04) THEN
              #IF NOT s_chk_item_no(g_inb[l_ac].att00,'') THEN     #TQC-C20029 mark
               IF NOT s_chk_item_no(g_inb[l_ac].inb04,"") THEN     #TQC-C20029 add
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD CURRENT
               END IF
            END IF
#FUN-AA0059 ---------------------end-------------------------------
           IF NOT t370_chk_inb04_1() THEN
             #str MOD-A40131 mod
             #NEXT FIELD CURRENT
              IF g_errno = "mfg1100" THEN
                 LET g_errno = ''
                 CALL t370_set_required_inb07(p_cmd)    #MOD-F80053 add
                 CALL t370_set_no_entry_inb07()         #MOD-F80053 add
                 NEXT FIELD inb05
              ELSE
                 NEXT FIELD CURRENT
              END IF
             #end MOD-A40131 mod
           END IF
           IF NOT s_chkima08(g_inb[l_ac].inb04) THEN
              NEXT FIELD CURRENT
           END IF
           IF g_azw.azw04 ='2' AND g_argv1='5' THEN
              IF NOT cl_null(g_inb[l_ac].inb04) THEN
                 #FUN-E80014 --- add start ---
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt
                   FROM rty_file
                  WHERE rty02 = g_inb[l_ac].inb04
                 IF cl_null(l_cnt) OR l_cnt = 0 THEN
                    IF g_inb[l_ac].inb04[1,4] != 'MISC' THEN
                       LET l_cnt = 1
                    END IF
                 END IF
                 IF l_cnt > 0 THEN
                 #FUN-E80014 --- add end   ---
                    SELECT COUNT(*) INTO l_n FROM rty_file WHERE rty01=g_ina.inaplant
                     AND rty02=g_inb[l_ac].inb04 AND( rty06='2' OR rty06='3')
                    IF l_n>0 THEN
                       CALL cl_err('','aim-884',0)
                       NEXT FIELD inb04
                    END IF
                 END IF                                      #FUN-E80014 --- add 
              END IF
           END IF

           SELECT aza131 INTO g_aza.aza131 FROM aza_file   #FUN-D30030 add

          #DEV-D30037--mark--begin
          ##No:DEV-D30026--add--begin
          #IF g_aza.aza131 = 'Y' THEN                          
          #    IF g_prog = 'aimt301' OR g_prog = 'aimt302' THEN
          #        CALL t370_chk_smyb(g_inb[l_ac].inb04)
          #        IF NOT cl_null(g_errno) THEN
          #            CALL cl_err(g_inb[l_ac].inb04,g_errno,1)
          #            NEXT FIELD inb04
          #        END IF
          #    END IF 
          #END IF    
          ##No:DEV-D30026--add--end
          #DEV-D30037--mark--end

           CALL t370_set_required_inb07(p_cmd)    #FUN-B50096
           CALL t370_set_no_entry_inb07()         #FUN-B50096

        #當sma908 <> 'Y'的時候,即不准通過單身來新增子料件,這時
        #對于采用料件多屬性新機制(與單據性質綁定)的分支來說,各個明細屬性欄位都
        #變NOENTRY的, 只能通過在母料件欄位開窗來選擇子料件,并且母料件本身也不允許
        #接受輸入,而只能開窗,所以這里要進行一個特殊的處理,就是一進att00母料件
        #欄位的時候就auto開窗,開完窗之后直接NEXT FIELD以避免用戶亂動
        #其他分支就不需要這么麻煩了
        BEFORE FIELD att00
            CALL t370_bef_att00()

        #以下是為料件多屬性機制新增的20個屬性欄位的AFTER FIELD代碼
        #下面是十個輸入型屬性欄位的判斷語句
        AFTER FIELD att00
            #FUN-AB0025 -----------add start--------
            IF NOT cl_null(g_inb[l_ac].att00) THEN
               IF NOT s_chk_item_no(g_inb[l_ac].att00,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD CURRENT
               END IF
            END IF            
            #FUN-AB0025 ----------add end--------
            IF NOT t370_chk_att00() THEN
               NEXT FIELD CURRENT
            END IF
 
        AFTER FIELD att01
            CALL t370_check_att0x(g_inb[l_ac].att01,1,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att01 END IF
        AFTER FIELD att02
            CALL t370_check_att0x(g_inb[l_ac].att02,2,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att02 END IF
        AFTER FIELD att03
            CALL t370_check_att0x(g_inb[l_ac].att03,3,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att03 END IF
        AFTER FIELD att04
            CALL t370_check_att0x(g_inb[l_ac].att04,4,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att04 END IF
        AFTER FIELD att05
            CALL t370_check_att0x(g_inb[l_ac].att05,5,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att05 END IF
        AFTER FIELD att06
            CALL t370_check_att0x(g_inb[l_ac].att06,6,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att06 END IF
        AFTER FIELD att07
            CALL t370_check_att0x(g_inb[l_ac].att07,7,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att07 END IF
        AFTER FIELD att08
            CALL t370_check_att0x(g_inb[l_ac].att08,8,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att08 END IF
        AFTER FIELD att09
            CALL t370_check_att0x(g_inb[l_ac].att09,9,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att09 END IF
        AFTER FIELD att10
            CALL t370_check_att0x(g_inb[l_ac].att10,10,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att10 END IF
        #下面是十個輸入型屬性欄位的判斷語句
        AFTER FIELD att01_c
            CALL t370_check_att0x_c(g_inb[l_ac].att01_c,1,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att01_c END IF
        AFTER FIELD att02_c
            CALL t370_check_att0x_c(g_inb[l_ac].att02_c,2,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att02_c END IF
        AFTER FIELD att03_c
            CALL t370_check_att0x_c(g_inb[l_ac].att03_c,3,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att03_c END IF
        AFTER FIELD att04_c
            CALL t370_check_att0x_c(g_inb[l_ac].att04_c,4,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att04_c END IF
        AFTER FIELD att05_c
            CALL t370_check_att0x_c(g_inb[l_ac].att05_c,5,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att05_c END IF
        AFTER FIELD att06_c
            CALL t370_check_att0x_c(g_inb[l_ac].att06_c,6,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att06_c END IF
        AFTER FIELD att07_c
            CALL t370_check_att0x_c(g_inb[l_ac].att07_c,7,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att07_c END IF
        AFTER FIELD att08_c
            CALL t370_check_att0x_c(g_inb[l_ac].att08_c,8,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att08_c END IF
        AFTER FIELD att09_c
            CALL t370_check_att0x_c(g_inb[l_ac].att09_c,9,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att09_c END IF
        AFTER FIELD att10_c
            CALL t370_check_att0x_c(g_inb[l_ac].att10_c,10,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att10_c END IF
 
        AFTER FIELD inb05 
          #-------------------------MOD-DC0071----------------(S)
           IF NOT cl_null(g_inb[l_ac].inb05) AND g_inb[l_ac].inb05 <> g_inb_t.inb05 THEN
              IF NOT t370_chk_inb08() THEN
                 NEXT FIELD CURRENT
              END IF
           END IF
          #-------------------------MOD-DC0071----------------(E)
           LET l_flag3 = 'Y'                      #TQC-D70030 add
          #IF  l_flag2 = 'Y' THEN                 #TQC-D70030 add  #MOD-F90136 mark
              CASE t370_chk_inb05()
                 WHEN "inb05" NEXT FIELD inb05
                 WHEN "inb06" NEXT FIELD inb06
              END CASE
          #END IF                                 #TQC-D70030 add  #MOD-F90136 mark
           IF NOT s_imechk_acti(g_inb[l_ac].inb05,g_inb[l_ac].inb06) THEN NEXT FIELD inb06 END IF  #TQC-DB0063 add
              #TQC-C30205---mark---str--
              ##FUN-BC0104---add---str--
              #IF NOT cl_null(g_inb[l_ac].inb46) THEN
              #   IF NOT t370_inb05_check() THEN
              #      CALL cl_err('','aqc-524',0)
              #      NEXT FIELD inb05
              #   END IF
              #END IF
              ##FUN-BC0104---add---end--
              #TQC-C30205---mark---end---
#TQC-C30205---------MARK------------STR---------
#&ifdef ICD
#              #No.FUN-830056  若已有ida/idb存在不可修改--(S)
#              IF p_cmd = 'u' AND NOT cl_null(g_inb[l_ac].inb05) THEN
#                 IF g_inb_t.inb05 <> g_inb[l_ac].inb05 THEN
#                    CALL t370_ind_icd_chk_icd()
#                    IF NOT cl_null(g_errno) THEN
#                       CALL cl_err('',g_errno,0)
#                       LET g_inb[l_ac].inb05 = g_inb_t.inb05
#                       NEXT FIELD inb05
#                    END IF
#                 END IF
#              END IF
#              #No.FUN-830056  若已有ida/idb存在不可修改--(E)
#              #FUN-AA0007--begin--add---------
#              IF g_argv1 MATCHES '[1256]' THEN
#                 IF NOT s_icdout_holdlot(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
#                                         g_inb[l_ac].inb06,g_inb[l_ac].inb07) THEN
#                    NEXT FIELD inb05
#                 END IF
#              END IF
#              #FUN-AA0007--end--add-----------
#&endif
#TQC-C30205--------------------MARK--------------END----- 
 
        AFTER FIELD inb06
           #-------------------------MOD-DC0071----------------(S)
            IF NOT cl_null(g_inb[l_ac].inb06) AND g_inb[l_ac].inb06 <> g_inb_t.inb06 THEN
               IF NOT t370_chk_inb08() THEN
                  NEXT FIELD CURRENT
               END IF
            END IF
           #-------------------------MOD-DC0071----------------(E)
            IF NOT s_imechk_acti(g_inb[l_ac].inb05,g_inb[l_ac].inb06) THEN NEXT FIELD inb06 END IF  #TQC-DB0063 add
           #LET l_flag2 = 'N'                     #TQC-D70030 add #MOD-F90136 mark
            CASE t370_chk_inb06()
               WHEN "inb04" NEXT FIELD inb04      #TQC-C30205
               WHEN "inb05" NEXT FIELD inb05
               WHEN "inb06" NEXT FIELD inb06
               WHEN "inb07" NEXT FIELD inb07   #No.TQC-750015 add
            END CASE
            
            #MOD-D70040-Start-Add
            IF l_flag3 = 'Y' THEN                 #TQC-D70030 add if
               IF NOT cl_null(g_inb[l_ac].inb05) THEN 
                  NEXT FIELD inb07
               END IF
            END IF                               #TQC-D70030 add
            #MOD-D70040-End-Add
            
#TQC-C30205------------------MARK--------------STR--------
##TQC-B90096 ------------------Begin------------------
#            IF NOT cl_null(g_inb[l_ac].inb04) THEN
#               SELECT ima159 INTO l_ima159 FROM ima_file
#                WHERE ima01 = g_inb[l_ac].inb04
#               IF l_ima159 = '2' THEN
#                  CASE t370_chk_inb07(p_cmd)
#                    #WHEN "inb04" NEXT FIELD inb04      #MOD-C30541
#                     #MOD-C30541---add---str---
#                     WHEN "inb04"
#                        IF NOT cl_null(g_inb[l_ac].inb46) THEN
#                           NEXT FIELD inb06
#                        ELSE
#                           NEXT FIELD inb04
#                        END IF
#                     #MOD-C30541--add---end--
#                     WHEN "inb06" NEXT FIELD inb06
#                     WHEN "inb07" NEXT FIELD inb06
#                  END CASE
#               END IF
#            END IF
##TQC-B90096 ------------------End--------------------
# 
#&ifdef ICD
#	   IF p_cmd = 'u' THEN
#              IF cl_null(g_inb_t.inb06) THEN LET g_inb_t.inb06 = ' ' END IF
#              IF g_inb_t.inb06 <> g_inb[l_ac].inb06 THEN
#                 CALL t370_ind_icd_chk_icd()
#                 IF NOT cl_null(g_errno) THEN
#                    CALL cl_err('',g_errno,0)
#                    LET g_inb[l_ac].inb06 = g_inb_t.inb06
#                    NEXT FIELD inb06
#                 END IF
#              END IF
#           END IF
#           #FUN-AA0007--begin--add---------
#           IF g_argv1 MATCHES '[1256]' THEN
#              IF NOT s_icdout_holdlot(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
#                                      g_inb[l_ac].inb06,g_inb[l_ac].inb07) THEN
#                 NEXT FIELD inb06
#              END IF
#           END IF
#           #FUN-AA0007--end--add-----------
#&endif
#TQC-C30205----------------------MARK-------------END----------------
 
        AFTER FIELD inb07
           LET l_flag3 = 'N'                 #TQC-D70030 add 
           #MOD-D50272---begin
           IF NOT cl_null(g_inb[l_ac].inb04) THEN
              SELECT ima159 INTO l_ima159
                FROM ima_file
               WHERE ima01 = g_inb[l_ac].inb04
              IF l_ima159 = '1' AND cl_null(g_inb[l_ac].inb07) THEN
                 CALL cl_err(g_inb[l_ac].inb04,'aim-034',1)
                 NEXT FIELD inb05
              END IF
           END IF   
          #-------------------------MOD-DC0071----------------(S)
           IF NOT cl_null(g_inb[l_ac].inb07) AND g_inb[l_ac].inb07 <> g_inb_t.inb07 THEN
              IF NOT t370_chk_inb08() THEN
                 NEXT FIELD CURRENT
              END IF
           END IF
          #-------------------------MOD-DC0071----------------(E)
           #MOD-D50272---end
	   CASE t370_chk_inb07(p_cmd)
	    #WHEN "inb04" NEXT FIELD inb04  #MOD-C30541
            #MOD-C30541---add---str---
             WHEN "inb04"
                 IF NOT cl_null(g_inb[l_ac].inb46) THEN 
                    NEXT FIELD inb07
                 ELSE 
                    NEXT FIELD inb04
                 END IF
              #MOD-C30541--add---end--
             WHEN "inb05" NEXT FIELD inb05  #TQC-C60023
	         WHEN "inb06" NEXT FIELD inb06
	         WHEN "inb07" NEXT FIELD inb07
	   END CASE
#MOD-D50272---begin 往上移
##FUN-B50096 -----------------Begin----------------
#           IF NOT cl_null(g_inb[l_ac].inb04) THEN
#              SELECT ima159 INTO l_ima159
#                FROM ima_file
#               WHERE ima01 = g_inb[l_ac].inb04
#              IF l_ima159 = '1' AND cl_null(g_inb[l_ac].inb07) THEN
#                 CALL cl_err(g_inb[l_ac].inb04,'aim-034',1)
#                 #NEXT FIELD inb07  #TQC-C60023
#                 NEXT FIELD inb05   #TQC-C60023
#              END IF
#           END IF
##FUN-B50096 -----------------End------------------
#MOD-D50272---end

      #MOD-D60192-Start-Add
        BEFORE FIELD inb08
           IF cl_null(g_inb[l_ac].inb06) THEN
                LET g_inb[l_ac].inb06 = ' '
           END IF
           
           IF cl_null(g_inb[l_ac].inb07) THEN
                LET g_inb[l_ac].inb07 = ' '
           END IF
           
           IF NOT cl_null(g_inb[l_ac].inb04) THEN
              SELECT ima159 INTO l_ima159
                FROM ima_file
               WHERE ima01 = g_inb[l_ac].inb04
              IF l_ima159 = '1' AND cl_null(g_inb[l_ac].inb07) THEN
                 CALL cl_err(g_inb[l_ac].inb04,'aim-034',1)
                 NEXT FIELD inb05
              END IF
           END IF   
	    CASE t370_chk_inb07(p_cmd)
              WHEN "inb04"
                 IF NOT cl_null(g_inb[l_ac].inb46) THEN 
                    NEXT FIELD inb07
                 ELSE 
                    NEXT FIELD inb04
                 END IF
          WHEN "inb05" NEXT FIELD inb05  
	      WHEN "inb06" NEXT FIELD inb06
	      WHEN "inb07" NEXT FIELD inb07
	    END CASE
        
         #MOD-D60192-End-Add

         ##---- 20200219 add by momo (S) 若為空預設為庫存單位
         IF cl_null(g_inb[l_ac].inb08) THEN
            LET g_inb[l_ac].inb08 = g_ima25
         END IF
         ##---- 20200219 add by momo (E) 若為空預設為庫存單位


        AFTER FIELD inb08
            IF NOT t370_chk_inb08() THEN
               NEXT FIELD CURRENT
            END IF
           ##---- 20200219 增加單位換算檢核(S)
           CALL s_umfchk(g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_ima25)
               RETURNING l_check_res,g_inb08_t
           IF l_check_res = '1'  THEN
              CALL cl_err(g_inb[l_ac].inb08,'abm-731',1)
              LET g_inb[l_ac].inb08 = g_ima25 
                   NEXT FIELD inb08
              DISPLAY BY NAME g_inb[l_ac].inb08
           END IF
           ##---- 20200219 增加單位換算檢核(E)

           #TQC-C20183--add--str--
           IF NOT cl_null(g_inb[l_ac].inb08) THEN 
              IF NOT cl_null(g_inb[l_ac].inb09) THEN
                 IF cl_null(g_inb08_t) OR g_inb08_t != g_inb[l_ac].inb08 OR
                    cl_null(g_inb_t.inb09) OR g_inb_t.inb09 != g_inb[l_ac].inb09 THEN
                    LET g_inb[l_ac].inb09 = s_digqty(g_inb[l_ac].inb09,g_inb[l_ac].inb08)
                    DISPLAY BY NAME g_inb[l_ac].inb09
                 END IF
              END IF
              IF NOT cl_null(g_inb[l_ac].inb16) AND g_inb[l_ac].inb16<>0 THEN #TQC-C20183
                 IF NOT t370_chk_inb16(p_cmd) THEN
                    LET g_inb08_t = g_inb[l_ac].inb08
                    NEXT FIELD inb16
                 END IF
              END IF
           END IF
           LET g_inb08_t = g_inb[l_ac].inb08
           #TQC-C20183--add--end--
 
        AFTER FIELD inb08_fac
           IF NOT cl_null(g_inb[l_ac].inb08_fac) THEN
              IF g_inb[l_ac].inb08_fac=0 THEN
                 NEXT FIELD inb08_fac
              END IF
           END IF
 
        AFTER FIELD inb16
            IF NOT t370_chk_inb16(p_cmd) THEN
               NEXT FIELD CURRENT
            END IF
            LET g_inb[l_ac].inbud07 = 0    #20200317
            LET g_inb[l_ac].inb09=g_inb[l_ac].inb16
            #TQC-D30066 -------Begin--------
            IF NOT cl_null(g_inb[l_ac].inb13) THEN
               LET g_inb[l_ac].inb14 = g_inb[l_ac].inb13 * g_inb[l_ac].inb16 
               LET g_inb[l_ac].inb14 = cl_digcut(g_inb[l_ac].inb14,g_azi03)  #TQC-D80003 add
            END IF
            #TQC-D30066 -------End----------
            DISPLAY BY NAME g_inb[l_ac].inb09
            DISPLAY BY NAME g_inb[l_ac].inb14    #TQC-D30066  

       #CHI-CA0042---mark---S
       #AFTER FIELD inb09
       #    IF NOT t370_chk_inb09() THEN
       ##      NEXT FIELD CURRENT           #CHI-A20020
       #       NEXT FIELD inb16             #CHI-A20020 
       #    END IF
       #CHI-CA0042---mark---E
 
        BEFORE FIELD inb905
           CALL t370_set_no_required()
 
        AFTER FIELD inb905  #第二單位
           CASE t370_chk_inb905()
              WHEN "inb07"  NEXT FIELD inb07
              WHEN "inb04"  NEXT FIELD inb04
              WHEN "inb905" NEXT FIELD CURRENT
           END CASE
           #TQC-C20183--mark--str--
           ##FUN-BB0085-add-str--
           #IF NOT cl_null(g_inb[l_ac].inb905) THEN
           #   IF NOT t370_chk_inb907(p_cmd) THEN
           #      NEXT FIELD inb927
           #   END IF
           #END IF 
           ##FUN-BB0085-add-end--
           #TQC-C20183--mark--end--
           #TQC-C20183--add--str--
           IF NOT cl_null(g_inb[l_ac].inb907) AND NOT cl_null(g_inb[l_ac].inb905) THEN 
              IF cl_null(g_inb905_t) OR g_inb905_t != g_inb[l_ac].inb905 OR 
                 cl_null(g_inb_t.inb907) OR g_inb_t.inb907 != g_inb[l_ac].inb907 THEN 
                 LET g_inb[l_ac].inb907 = s_digqty(g_inb[l_ac].inb907,g_inb[l_ac].inb905)
                 DISPLAY BY NAME g_inb[l_ac].inb907
              END IF
           END IF
           LET g_inb905_t = g_inb[l_ac].inb905
           #TQC-C20183--add--end--
 
        BEFORE FIELD inb906  #第二轉換率
           CASE t370_bef_inb906()
              WHEN "inb04"  NEXT FIELD inb04
              WHEN "inb07"  NEXT FIELD inb07
           END CASE
 
        AFTER FIELD inb906  #第二轉換率
           IF NOT cl_null(g_inb[l_ac].inb906) THEN
              IF g_inb[l_ac].inb906=0 THEN
                 NEXT FIELD CURRENT
              END IF
           END IF
 
        BEFORE FIELD inb907
           CASE t370_bef_inb907()
              WHEN "inb04"  NEXT FIELD inb04
              WHEN "inb07"  NEXT FIELD inb07
           END CASE
 
        AFTER FIELD inb907  #第二數量
           IF NOT t370_chk_inb907(p_cmd) THEN
          #   NEXT FIELD CURRENT       #CHI-A20020
              NEXT FIELD inb927        #CHI-A20020
           END IF
           #FUN-C20047-mark-str--
           ##FUN-BC0104-add-str--
           #IF NOT t370_chk_inb09() THEN
           #   NEXT FIELD inb907
           #END IF
           ##FUN-BC0104-add-end--
           #FUN-C20047-mark-end--
 
        BEFORE FIELD inb902
           CALL t370_set_no_required()
 
        AFTER FIELD inb902  #第一單位
           CASE t370_chk_inb902()
              WHEN "inb04"  NEXT FIELD inb04
              WHEN "inb07"  NEXT FIELD inb07
              WHEN "inb902" NEXT FIELD CURRENT
           END CASE
           #TQC-C20183--mark--str--
           ##FUN-BB0085-add-str--
           #IF NOT cl_null(g_inb[l_ac].inb902) THEN
           #   CASE t370_chk_inb904()
           #      WHEN "inb904" NEXT FIELD inb922
           #      WHEN "inb907" NEXT FIELD inb927
           #   END CASE
           #END IF
           #FUN-BB0085-add-end--
           #TQC-C20183--mark--end--
           #TQC-C20183--add--str--
           IF NOT cl_null(g_inb[l_ac].inb904) AND NOT cl_null(g_inb[l_ac].inb902) THEN 
              IF cl_null(g_inb902_t) OR g_inb902_t != g_inb[l_ac].inb902 OR
                 cl_null(g_inb_t.inb904) OR g_inb_t.inb904 != g_inb[l_ac].inb904 THEN
                 LET g_inb[l_ac].inb904 = s_digqty(g_inb[l_ac].inb904,g_inb[l_ac].inb902)
                 DISPLAY BY NAME g_inb[l_ac].inb904
              END IF
           END IF
           LET g_inb902_t = g_inb[l_ac].inb902
           #TQC-C20183--add--end--
 
        AFTER FIELD inb903  #第一轉換率
           IF NOT cl_null(g_inb[l_ac].inb903) THEN
              IF g_inb[l_ac].inb903=0 THEN
                 NEXT FIELD inb903
              END IF
           END IF
 
        AFTER FIELD inb904  #第一數量
           CASE t370_chk_inb904()
            # WHEN "inb904" NEXT FIELD CURRENT       #CHI-A20020
            # WHEN "inb907" NEXT FIELD inb907        #CHI-A20020
              WHEN "inb904" NEXT FIELD inb922        #CHI-A20020
              WHEN "inb907" NEXT FIELD inb927        #CHI-A20020
           END CASE
           #FUN-C20047-mark--str--
           ##FUN-BC0104-add-str--
           #IF NOT t370_chk_inb09() THEN 
           #   NEXT FIELD inb904
           #END IF
           ##FUN-BC0104-add-end--
           #FUN-C20047-add-end--
 
        BEFORE FIELD inb925
           CALL t370_set_no_required()
 
        AFTER FIELD inb925  #第二單位
           CASE t370_chk_inb925()
              WHEN "inb07"  NEXT FIELD inb07
              WHEN "inb04"  NEXT FIELD inb04
              WHEN "inb925" NEXT FIELD CURRENT
           END CASE
           #FUN-BB0085-add-str--
           IF NOT cl_null(g_inb[l_ac].inb925) THEN 
               IF NOT t370_chk_inb927(p_cmd) THEN
                  LET g_inb925_t = g_inb[l_ac].inb925 #TQC-C20183
                  NEXT FIELD inb927
               END IF
           END IF
           LET g_inb925_t = g_inb[l_ac].inb925        #TQC-C20183
           #FUN-BB0085-add-end--
 
        BEFORE FIELD inb926  #第二轉換率
           CASE t370_bef_inb926()
              WHEN "inb04"  NEXT FIELD inb04
              WHEN "inb07"  NEXT FIELD inb07
           END CASE
 
        AFTER FIELD inb926  #第二轉換率
           IF NOT cl_null(g_inb[l_ac].inb926) THEN
              IF g_inb[l_ac].inb926=0 THEN
                 NEXT FIELD CURRENT
              END IF
           END IF
 
        BEFORE FIELD inb927
           CASE t370_bef_inb927()
              WHEN "inb04"  NEXT FIELD inb04
              WHEN "inb07"  NEXT FIELD inb07
           END CASE
 
        AFTER FIELD inb927  #第二數量
            IF NOT t370_chk_inb927(p_cmd) THEN
               NEXT FIELD CURRENT
            END IF
 
        BEFORE FIELD inb922
           CALL t370_set_no_required()
 
        AFTER FIELD inb922  #第一單位
           CASE t370_chk_inb922()
              WHEN "inb04"  NEXT FIELD inb04
              WHEN "inb07"  NEXT FIELD inb07
              WHEN "inb922" NEXT FIELD CURRENT
           END CASE
           #FUN-BB0085-add-str--
           IF NOT cl_null(g_inb[l_ac].inb922) THEN 
              CASE t370_chk_inb924(p_cmd)
                 WHEN "inb924"
                    LET g_inb922_t = g_inb[l_ac].inb922 #TQC-C20183
                    NEXT FIELD inb924 
                 WHEN "inb927"
                    LET g_inb922_t = g_inb[l_ac].inb922 #TQC-C20183
                    NEXT FIELD inb927
              END CASE
           END IF
           LET g_inb922_t = g_inb[l_ac].inb922          #TQC-C20183
           #FUN-BB0085-add-str--

        AFTER FIELD inb923  #第一轉換率
           IF NOT cl_null(g_inb[l_ac].inb923) THEN
              IF g_inb[l_ac].inb923=0 THEN
                 NEXT FIELD inb923
              END IF
           END IF
 
        AFTER FIELD inb924  #第一數量
           CASE t370_chk_inb924(p_cmd)
              WHEN "inb924" NEXT FIELD CURRENT
              WHEN "inb927" NEXT FIELD inb927
           END CASE
 
 
       AFTER FIELD inb41  
          IF NOT cl_null(g_inb[l_ac].inb41) THEN
             SELECT COUNT(*) INTO g_cnt FROM pja_file
              WHERE pja01 = g_inb[l_ac].inb41
                AND pjaacti = 'Y'
                AND pjaclose = 'N'           #FUN-960038
             IF g_cnt = 0 THEN
                CALL cl_err(g_inb[l_ac].inb41,'asf-984',0)
                NEXT FIELD inb41
             END IF
             IF cl_null(g_inb[l_ac].inb42) THEN
                NEXT FIELD inb42
             END IF
          ELSE
             NEXT FIELD inb11    #IF 專案沒輸入資料，不可輸入WBS/活動,直接跳到下個欄位
          END IF
 
       BEFORE FIELD inb42
         IF cl_null(g_inb[l_ac].inb41) THEN
            NEXT FIELD inb41
         END IF
 
       AFTER FIELD inb42
          IF NOT cl_null(g_inb[l_ac].inb42) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjb_file
              WHERE pjb01 = g_inb[l_ac].inb41
                AND pjb02 = g_inb[l_ac].inb42
                AND pjbacti = 'Y'
             IF g_cnt = 0 THEN
                CALL cl_err(g_inb[l_ac].inb42,'apj-051',0)
                LET g_inb[l_ac].inb42 = g_inb_t.inb42
                NEXT FIELD inb42
             END IF
             SELECT pjb09,pjb11
               INTO l_pjb09,l_pjb11 
               FROM pjb_file
              WHERE pjb01 = g_inb[l_ac].inb41
                AND pjb02 = g_inb[l_ac].inb42
                AND pjbacti = 'Y'
              IF SQLCA.sqlcode = 100 THEN
                   LET g_errno = SQLCA.sqlcode USING '-------'
                   CALL cl_err(g_inb[l_ac].inb42,g_errno,0)
                   LET g_inb[l_ac].inb42 = g_inb_t.inb42
                   NEXT FIELD inb42
              END IF
            
             CASE WHEN l_pjb09 !='Y' 
                       CALL cl_err(g_inb[l_ac].inb42,'apj-090',0)
                       LET g_inb[l_ac].inb42 = g_inb_t.inb42
                       NEXT FIELD inb42
                  WHEN l_pjb11 !='Y'
                       CALL cl_err(g_inb[l_ac].inb42,'apj-090',0)
                       LET g_inb[l_ac].inb42 = g_inb_t.inb42
                       NEXT FIELD inb42
             END CASE
             SELECT pjb25 INTO l_pjb25 FROM pjb_file
              WHERE pjb02 = g_inb[l_ac].inb42
             IF l_pjb25 = 'Y' THEN
                NEXT FIELD inb43
             ELSE
                LET g_inb[l_ac].inb43 = ' '
                DISPLAY BY NAME g_inb[l_ac].inb43
                NEXT FIELD inb12
             END IF
          ELSE
             IF NOT cl_null(g_inb[l_ac].inb41) THEN
                NEXT FIELD inb42
             END IF
          END IF
 
       BEFORE FIELD inb43
         IF cl_null(g_inb[l_ac].inb42) THEN
            NEXT FIELD inb42
         ELSE
            SELECT pjb25 INTO l_pjb25 FROM pjb_file
             WHERE pjb02 = g_inb[l_ac].inb42
            IF l_pjb25 = 'N' THEN  #WBS不做活動時，活動帶空白，跳開不輸入
               LET g_inb[l_ac].inb43 = ' '
               DISPLAY BY NAME g_inb[l_ac].inb43
               NEXT FIELD inb44
            END IF
         END IF
 
       AFTER FIELD inb43
          IF NOT cl_null(g_inb[l_ac].inb43) THEN
             SELECT COUNT(*) INTO g_cnt FROM pjk_file
              WHERE pjk02 = g_inb[l_ac].inb43
                AND pjk11 = g_inb[l_ac].inb42
                AND pjkacti = 'Y'
             IF g_cnt = 0 THEN
                CALL cl_err(g_inb[l_ac].inb43,'apj-049',0)
                NEXT FIELD inb43
             END IF
          END IF
 
        BEFORE FIELD inb15
           #FUN-CB0087--ADD--STR
           #IF g_aza.aza115 = 'Y' AND cl_null(g_inb[l_ac].inb15) THEN  #MOD-D40091
           #MOD-D60002--mark-begin------MOD-E40087 remark end---------
           IF cl_null(g_inb[l_ac].inb15) THEN  #MOD-D40091
              CALL s_reason_code(g_ina.ina01,'','',g_inb[l_ac].inb04,g_inb[l_ac].inb05,g_ina.ina11,g_ina.ina04) RETURNING g_inb[l_ac].inb15
              DISPLAY BY NAME g_inb[l_ac].inb15
           END IF
           #MOD-D60002--mark-end------ MOD-E40087 remark end---------
           #FUN-CB0087--ADD--END
           CALL t370_du_data_to_correct2()  #FUN-870040
           CALL t370_set_origin_field2()    #FUN-870040
           CALL t370_set_origin_field()   #MOD-9B0146
           #FUN-C20047--Begin--
           CALL t370_qcl05_sel() RETURNING l_qcl05
           IF l_qcl05 != '1' AND NOT cl_null(l_qcl05) THEN
           #FUN-C20047--End----
              IF g_inb[l_ac].inb09 IS NULL OR g_inb[l_ac].inb09=0 THEN
                 IF g_ima906 MATCHES '[23]' THEN
                  # NEXT FIELD inb907      #CHI-A20020
                    NEXT FIELD inb927      #CHI-A20020
                 ELSE
                    IF g_wm = 'N' AND cl_null(g_inb[l_ac].inb904) THEN 
                    ELSE
                  #   NEXT FIELD inb904     #CHI-A20020
                      NEXT FIELD inb922     #CHI-A20020  
                    END IF    #MOD-970031  
                 END IF
              END IF
           END IF                       #FUN-C20047

        AFTER FIELD inb15
           IF NOT t370_chk_inb15() THEN
              NEXT FIELD CURRENT
           END IF
 
#FUN-D30065 --------Begin---------
       BEFORE FIELD inb13
          IF g_inb[l_ac].inb13 <= 0 OR g_inb[l_ac].inb13 IS NULL THEN
             SELECT cfa12 INTO g_inb[l_ac].inb13 FROM cfa_file 
              WHERE cfa01 = g_inb[l_ac].inb04
                AND cfa04 = 1
                AND cfa02 = (SELECT MAX(cfa02) FROM cfa_file WHERE cfa01= g_inb[l_ac].inb04 AND cfa04=1 ) 
          END IF
          IF cl_null(b_inb.inb13) THEN LET b_inb.inb13 = 0 END IF
          IF cl_null(b_inb.inb09) THEN LET b_inb.inb09 = 0 END IF
          LET b_inb.inb14 = b_inb.inb13 * b_inb.inb09
          LET b_inb.inb14 = cl_digcut(b_inb.inb14,g_azi03)  #TQC-D80003 add
#FUN-D30065 --------End-----------

#FUN-BC0062 --begin--
       AFTER FIELD inb13
          IF g_inb[l_ac].inb13 <= 0 THEN
             CALL cl_err('','aim-031',0)
             NEXT FIELD inb13 
          ELSE
             LET g_inb[l_ac].inb14 = g_inb[l_ac].inb13 * g_inb[l_ac].inb09
             LET g_inb[l_ac].inb14 = cl_digcut(g_inb[l_ac].inb14,g_azi03)  #TQC-D80003 add
             DISPLAY BY NAME g_inb[l_ac].inb14
          END IF
#FUN-BC0062 --end--

       AFTER FIELD inb901
           IF NOT t370_chk_inb901() THEN
              NEXT FIELD CURRENT
           END IF
 
        AFTER FIELD inb930
           IF NOT t370_chk_inb930() THEN
              NEXT FIELD CURRENT
           END IF
 
        AFTER FIELD inbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inbud07
          ##------ 20200317 modify by momo (S)
          #IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          ##------ 20200317 modify by momo (E)
        AFTER FIELD inbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD inbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
          IF g_inb_t.inb03 > 0 AND g_inb_t.inb03 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
 
             SELECT ima918,ima921 INTO g_ima918,g_ima921
               FROM ima_file
              WHERE ima01 = g_inb[l_ac].inb04
                AND imaacti = "Y"
 
             IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                IF g_ina.ina00 = "1" OR g_ina.ina00 = "2" #MOD-910104 mark THEN
                   OR  g_ina.ina00 = "5" OR g_ina.ina00 = "6" THEN  #出庫 #MOD-910104 add
                  #IF NOT s_lotout_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045 #TQC-B90236 mark
                   IF NOT s_lot_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045 #TQC-B90236 add   
                      CALL cl_err3("del","rvbs_file",g_ina.ina01,g_inb_t.inb03,
                                    SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
                IF g_ina.ina00 = "3" OR g_ina.ina00 = "4" THEN
                  #IF NOT s_lotin_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045 #TQC-B90236 mark
                   IF NOT s_lot_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045 #TQC-B90236 add
                      CALL cl_err3("del","rvbs_file",g_ina.ina01,g_inb_t.inb03,
                                    SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
             END IF
               CASE
                 WHEN g_ina.ina00 MATCHES '[1256]'  #出庫
                   LET l_act = "1"
                 WHEN g_ina.ina00 MATCHES '[34]'    #入庫   #MOD-910081 
                   LET l_act = "2"
               END CASE
#TQC-B90236------mark------begin---
#              IF NOT s_del_rvbs(l_act,g_ina.ina01,g_inb[l_ac].inb03,0)  THEN                      #FUN-880129
#                ROLLBACK WORK
#                CANCEL DELETE
#              END IF
#TQC-B90236------mark------end-----
             IF NOT t370_b_del() THEN
                ROLLBACK WORK
                CANCEL DELETE
             ELSE
                #FUN-BC0104-add-str--
                CALL t370_qcl05_sel() RETURNING l_qcl05
                IF l_qcl05 = '1' THEN LET l_type1 = '6' ELSE LET l_type1 = '4' END IF
                IF NOT s_iqctype_upd_qco20(g_inb[l_ac].inb44,g_inb[l_ac].inb45,g_inb[l_ac].inb48,g_inb[l_ac].inb47,l_type1) THEN 
                   ROLLBACK WORK
                   CANCEL DELETE               
                END IF  
                #FUN-BC0104-add-end--
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                LET l_ina08 = '0'          #FUN-550047
                COMMIT WORK      
             END IF
          ELSE
             SELECT ima918,ima921 INTO g_ima918,g_ima921
               FROM ima_file
              WHERE ima01 = g_inb[l_ac].inb04
                AND imaacti = "Y"
 
             IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                IF g_ina.ina00 = "1" OR g_ina.ina00 = "2" #MOD-910104 mark THEN
                   OR  g_ina.ina00 = "5" OR g_ina.ina00 = "6" THEN  #出庫 #MOD-910104 add
                  #IF NOT s_lotout_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045  #TQC-B90236 mark
                   IF NOT s_lot_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045  #TQC-B90236 add
                      CALL cl_err3("del","rvbs_file",g_ina.ina01,g_inb_t.inb03,
                                    SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
                IF g_ina.ina00 = "3" OR g_ina.ina00 = "4" THEN
                  #IF NOT s_lotin_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045   #TQC-B90236 mark
                   IF NOT s_lot_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045   #TQC-B90236 add
                      CALL cl_err3("del","rvbs_file",g_ina.ina01,g_inb_t.inb03,
                                    SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
                #FUN-C20047-mark-str--
                ##FUN-BC0104-add-str--
                #CALL t370_qcl05_sel() RETURNING l_qcl05
                #IF l_qcl05 = '1' THEN LET l_type1 = '6' ELSE LET l_type1 = '4' END IF
                #IF NOT s_iqctype_upd_qco20(g_inb[l_ac].inb44,g_inb[l_ac].inb45,g_inb[l_ac].inb48,g_inb[l_ac].inb47,l_type1) THEN
                #   ROLLBACK WORK
                #   CANCEL DELETE
                #END IF
                ##FUN-BC0104-add-end--
                #FUN-C20047-mark-end--
             END IF
          END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_inb[l_ac].* = g_inb_t.*
               LET l_ina08 = g_ina.ina08  #FUN-C30293
               CLOSE t370_bcl
               ROLLBACK WORK
              #EXIT INPUT  #FUN-C20101---MARK---  #FUN-D60112--remark #FUN-DB0029 mark
               EXIT DIALOG   #FUN-C20101---ADD--  #FUN-D60112--mark   #FUN-DB0029 remark
            END IF
            IF g_wm != 'Y' THEN #FUN-DA0106 add if
               LET l_ina08 = '0'  #FUN-C30293
            END IF              #FUN-DA0106 add
#FUN-B50096 ----------------Begin-----------------
           IF NOT cl_null(g_inb[l_ac].inb04) THEN
               SELECT ima159 INTO l_ima159 FROM ima_file
                WHERE ima01 = g_inb[l_ac].inb04
               IF l_ima159 = '1' AND cl_null(g_inb[l_ac].inb07) THEN
                  CALL cl_err(g_inb[l_ac].inb04,'aim-034',1)
                  NEXT FIELD inb07
               END IF
            END IF
#FUN-B50096 ----------------End-------------------
            #FUN-CB0087---add---str---
            #IF g_aza.aza115 = 'Y' THEN  #MOD-D40091
            IF g_wm != 'Y' THEN      #MOD-G80079 add
            #MOD-D60002--mark begin----------#MOD-E40087 remark begin-------
               IF NOT t370_inb15_chk1() THEN
                  NEXT FIELD inb15
               END IF
            #MOD-D60002--mark end----------#MOD-E40087 remark end-----------
            END IF                   #MOD-G80079 add
            #END IF  #MOD-D40091
            #FUN-CB0087---add---end---

 
#MOD-B70023 -- begin --
            LET g_ima918 = ''      #DEV-D50009 add
            LET g_ima921 = ''      #DEV-D50009 add
            LET g_ima930 = ''      #DEV-D50009 add
            SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930
               FROM ima_file
               WHERE ima01 = g_inb[l_ac].inb04 AND imaacti = 'Y'
            IF cl_null(g_ima918) THEN LET g_ima918 = 'N' END IF   #DEV-D50009 add
            IF cl_null(g_ima921) THEN LET g_ima921 = 'N' END IF   #DEV-D50009 add
            IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF   #DEV-D30059 add

            IF (g_ima918 = 'Y' OR g_ima921 = 'Y') AND g_inb[l_ac].inb10 = 'N'
               AND (g_inb[l_ac].inb16 <> g_inb_t.inb16 OR cl_null(g_inb_t.inb16)) THEN
               LET g_success = "Y"
               LET g_img09 = ''
               SELECT img09 INTO g_img09 FROM img_file
                  WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
                  AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
               CALL s_umfchk(g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09)
                  RETURNING l_i,l_fac
               IF l_i = 1 THEN
                  LET l_fac = 1
               END IF
               IF g_ina.ina00 = "1" OR g_ina.ina00 = "2"
                  OR  g_ina.ina00 = "5" OR g_ina.ina00 = "6" THEN
                  IF cl_null(g_inb[l_ac].inb41) THEN
                     LET l_bno = ''
                  ELSE
                     LET l_bno = g_inb[l_ac].inb41
                  END IF
                 #CALL s_lotout(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,      #TQC-B90236 mark
                  IF g_ima930  = 'N' AND g_sma.sma150='N' THEN           #DEV-D30050 add  #TQC-DB0021 add sam150
                     CALL s_mod_lot(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,     #TQC-B90236 add
                                   g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                                   g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                                   g_inb[l_ac].inb08,g_img09,
                                   g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD',-1)   #TQC-B90236 add '-1'
                        RETURNING l_r,g_qty
                  END IF                                                     #DEV-D30050 add
                  IF l_r = "Y" THEN
                     LET g_qty = s_digqty(g_qty,g_inb[l_ac].inb08)   #FUN-BB0085
                     LET g_inb[l_ac].inb16 = g_qty
                     LET g_inb[l_ac].inb09 = g_qty
                     LET b_inb.inb16 = g_qty
                     LET b_inb.inb09 = g_qty
                  END IF
               END IF
               IF g_ina.ina00 = "3" OR g_ina.ina00="4" THEN
                  IF cl_null(g_inb[l_ac].inb41) THEN
                     LET l_bno = ''
                  ELSE
                     LET l_bno = g_inb[l_ac].inb41
                  END IF
#No.TQC-B90236----mark------begin---------
#                 CALL s_lotin(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,
#                              g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09,
#                              g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD')
#No.TQC-B90236----mark------end-----------
#No.TQC-B90236----add-------begin---------
                  IF g_ima930  = 'N' AND g_sma.sma150='N' THEN         #DEV-D30050 add  #TQC-DB0021 add sam150
                     CALL s_mod_lot(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,     
                                   g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                                   g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                                   g_inb[l_ac].inb08,g_img09,
                                   g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD',1)   
#No.TQC-B90236----add-------end-----------

                        RETURNING l_r,g_qty
                  END IF                                                     #DEV-D30050 add
                  IF l_r = "Y" THEN       #MOD-B30036 add
                     LET g_qty = s_digqty(g_qty,g_inb[l_ac].inb08)   #FUN-BB0085
                     LET g_inb[l_ac].inb16 = g_qty
                     LET g_inb[l_ac].inb09 = g_qty
                     LET b_inb.inb16 = g_qty
                     LET b_inb.inb09 = g_qty
                  END IF
               END IF
            END IF
#MOD-B70023 -- end --

	    IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_inb[l_ac].inb03,-263,1)
               LET g_inb[l_ac].* = g_inb_t.*
            ELSE
               CASE t370_b_updchk()
                  WHEN "inb04"  NEXT FIELD inb04
                # WHEN "inb907" NEXT FIELD inb907        #CHI-A20020
                # WHEN "inb904" NEXT FIELD inb904        #CHI-A20020
                  WHEN "inb907" NEXT FIELD inb927        #CHI-A20020
                  WHEN "inb904" NEXT FIELD inb922        #CHI-A20020
                  WHEN "inb911" NEXT FIELD inb911
                  WHEN "inb912" NEXT FIELD inb912
               END CASE
                #IF 有專案且要做預算控管
                # check料件， if料件沒做批號管理也沒做序號管理，則要寫入rvbs_file
                LET g_success = 'Y'
                IF s_chk_rvbs(g_inb[l_ac].inb41,g_inb[l_ac].inb04) THEN
                   CALL t370_rvbs()
                END IF
                IF g_success = 'N' THEN
                   NEXT FIELD inb03
                END IF
               CALL t370_b_move_back()
               CALL t370_b_else()

               
	       IF NOT t370_b_upd() THEN
                 #CONTINUE INPUT #FUN-720002 #FUN-C20101---MARK--  #FUN-D60112--remark  #FUN-DB0029 mark
                  CONTINUE DIALOG  #FUN-C20101---ADD----           #FUN-D60112--mark    #FUN-DB0029 remark
               ELSE
                  #FUN-BC0104-add-str--
                  CALL t370_qcl05_sel() RETURNING l_qcl05
                  IF l_qcl05 = '1' THEN LET l_type1 = '6' ELSE LET l_type1 = '4' END IF
                  IF NOT s_iqctype_upd_qco20(g_inb[l_ac].inb44,g_inb[l_ac].inb45,g_inb[l_ac].inb48,g_inb[l_ac].inb47,l_type1) THEN 
                    #CONTINUE INPUT  ##FUN-C20101---MARK--- #FUN-D60112--remark #FUN-DB0029 mark
                     CONTINUE DIALOG  #FUN-C20101---ADD---- #FUN-D60112--mark   #FUN-DB0029 remark
                  END IF 
                  #FUN-BC0104-add-end--
                  CALL cl_msg('UPDATE O.K')  #FUN-720002
                  IF g_wm != 'Y' THEN #FUN-DA0106 add if
                     LET l_ina08 = '0' #FUN-550047
                  END IF              #FUN-DA0106 add
                  COMMIT WORK    
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'a' AND l_ac <= g_inb.getLength() THEN  #CHI-C30106---add

                 #MOD-FA0119--add--start-------------------------
                  IF g_inb_t.inb03 != g_inb03_o THEN
                     IF g_sma.sma150 = 'Y' THEN
                        CALL t370_upd_inbc_slk(g_inb[l_ac].inb04,g_inb_t.inb03,g_inb03_o) 
                     END IF
                  END IF
                 #MOD-FA0119--add--end---------------------------
               
                 SELECT ima918,ima921 INTO g_ima918,g_ima921
                   FROM ima_file
                  WHERE ima01 = g_inb[l_ac].inb04
                    AND imaacti = "Y"
               
                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                    IF g_ina.ina00 = "1" OR g_ina.ina00 = "2" #MOD-910104 mark THEN
                       OR  g_ina.ina00 = "5" OR g_ina.ina00 = "6" THEN  #出庫 #MOD-910104 add
                      #IF NOT s_lotout_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045 #TQC-B90236 mark
                       IF NOT s_lot_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045 #TQC-B90236 add   
                          CALL cl_err3("del","rvbs_file",g_ina.ina01,g_inb_t.inb03,
                                        SQLCA.sqlcode,"","",1)
                       END IF
                    END IF
                    IF g_ina.ina00 = "3" OR g_ina.ina00 = "4" THEN
                      #IF NOT s_lotin_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045   #TQC-B90236 mark
                       IF NOT s_lot_del(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,g_inb[l_ac].inb04,'DEL') THEN   #No.FUN-860045   #TQC-B90236 add
                          CALL cl_err3("del","rvbs_file",g_ina.ina01,g_inb_t.inb03,
                                        SQLCA.sqlcode,"","",1)
                       END IF
                    END IF
                 END IF

               END IF   #CHI-C30106---add
               IF p_cmd='u' THEN
                  LET g_inb[l_ac].* = g_inb_t.*
                ELSE                               #No.MOD-490208
                  INITIALIZE g_inb[l_ac].* TO NULL
                  CALL g_inb.deleteElement(l_ac)   #No.MOD-A80086
               END IF
               LET l_ina08 = g_ina.ina08  #FUN-C30293
               CLOSE t370_bcl
               ROLLBACK WORK
              #EXIT INPUT     #FUN-C20101---MARK---- #FUN-D60112--remark   #FUN-DB0029 mark
               EXIT DIALOG     #FUN-C20101---ADD---- #FUN-D60112--mark     #FUN-DB0029 remark
#FUN-BC0062 --begin--
            ELSE 
               IF g_ccz.ccz28 = '6' AND (g_argv1  = '3' OR g_argv1 = '4') THEN
                  IF cl_null(g_inb[l_ac].inb13) OR g_inb[l_ac].inb13 <=0 THEN 
                     CALL cl_err('','aim-031',0)
                     NEXT FIELD inb13
                  END IF
               END IF 
#FUN-BC0062 --end--                  
            END IF
            IF g_wm != 'Y' THEN #FUN-DA0106 add if 
               LET l_ina08 = '0'  #FUN-C30293
            END IF              #FUN-DA0106 add
            #FUN-CB0087---add---str---
            #IF g_aza.aza115 = 'Y' THEN  #MOD-D40091
            IF g_wm != 'Y'  THEN            #MOD-G80079 add
            #MOD-D60002--mark--begin--------MOD-E40087 remark begin-----------   
               IF NOT t370_inb15_chk1() THEN
                  NEXT FIELD inb15
               END IF
            #MOD-D60002--mark--end--------MOD-E40087 remark end---------------
            END IF                          #MOD-G80079 add
            #END IF  #MOD-D40091
            #FUN-CB0087---add---end---
            #MOD-E80090---add---str---
            IF l_ac > g_rec_b AND cl_null(g_inb[l_ac].inb04) THEN
               CALL g_inb.deleteElement(l_ac)
               LET l_ac=g_rec_b
               CALL fgl_set_arr_curr(l_ac)
            END IF 
            #MOD-E80090---add---end---
            CLOSE t370_bcl
            COMMIT WORK

       #CHI-C30106---add---S---
       AFTER INPUT
        LET g_cnt = 0
        SELECT COUNT(*) INTO g_cnt FROM inb_file WHERE inb01=g_ina.ina01
        FOR l_c=1 TO g_cnt
          SELECT ima918,ima921 INTO g_ima918,g_ima921
            FROM ima_file
           WHERE ima01 = g_inb[l_c].inb04
             AND imaacti = "Y"

          IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          UPDATE rvbs_file SET rvbs021=g_inb[l_c].inb04
           WHERE rvbs00= g_prog
             AND rvbs01= g_ina.ina01
             AND rvbs02= g_inb[l_c].inb03
          END IF
        END FOR
       #CHI-C30106---add---E---
     END INPUT          #FUN-DB0029 add

        ON ACTION ACCEPT                       #FUN-DB0029 add
           ACCEPT DIALOG                       #FUN-DB0029 add

        ON ACTION CANCEL                       #FUN-DB0029 add
           ROLLBACK WORK                       #FUN-DB0029 add
           EXIT DIALOG                         #FUN-DB0029 add
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(inb03) AND l_ac > 1 THEN
              LET l_inb03_o=g_inb[l_ac].inb03             #MOD-640049 #保留原序號
              LET g_inb[l_ac].* = g_inb[l_ac-1].*
              LET g_inb_t.* = g_inb[l_ac].*               #MOD-DC0071 add
              LET g_inb[l_ac].inb03=l_inb03_o             #MOD-640049
              NEXT FIELD inb03
           END IF
 
        ON ACTION controlp
           CASE
               WHEN INFIELD(inb911) OR INFIELD(inb912)
                    CALL cl_init_qry_var()
                    IF g_azw.azw04='2' THEN
                       LET g_qryparam.form ="q_oea06"
                    ELSE 
                       LET g_qryparam.form ="q_oea06"
                    END IF
                    LET g_qryparam.default1 = g_inb[l_ac].inb911
                    LET g_qryparam.default2 = g_inb[l_ac].inb912
                    CALL cl_create_qry() RETURNING g_inb[l_ac].inb911,
                                                   g_inb[l_ac].inb912
                    DISPLAY BY NAME g_inb[l_ac].inb911,g_inb[l_ac].inb911
                    IF INFIELD(inb911) THEN
                       NEXT FIELD inb911
                    ELSE
                       NEXT FIELD inb912
                    END IF
                WHEN INFIELD(inb04)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form ="q_ima"
                  #   LET g_qryparam.default1 = g_inb[l_ac].inb04
                  #   CALL cl_create_qry() RETURNING g_inb[l_ac].inb04
                     CALL q_sel_ima(FALSE, "q_ima", "", g_inb[l_ac].inb04, "", "", "", "" ,"",'' )  RETURNING g_inb[l_ac].inb04 
#FUN-AA0059 --End--
                     DISPLAY BY NAME g_inb[l_ac].inb04   #No.MOD-490371
                     NEXT FIELD inb04
 
                WHEN INFIELD(inb05) OR INFIELD(inb06) OR INFIELD(inb07)
                   IF g_argv1 MATCHES '[135]' THEN
                       LET g_imd10='S'
                   ELSE
                       LET g_imd10='W'
                   END IF
                   #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_inb[l_ac].inb04
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                             g_inb[l_ac].inb06,g_inb[l_ac].inb07)
                      RETURNING g_inb[l_ac].inb05,g_inb[l_ac].inb06,g_inb[l_ac].inb07
                   ELSE
                   #FUN-C30300---end
                      CALL q_img4(FALSE,TRUE,g_inb[l_ac].inb04,g_inb[l_ac].inb05,  ##NO.FUN-660085
                                              g_inb[l_ac].inb06,g_inb[l_ac].inb07,g_imd10) #No:9742
                                             #g_inb[l_ac].inb06,g_inb[l_ac].inb07,'A')     #No:9742
                      RETURNING g_inb[l_ac].inb05,g_inb[l_ac].inb06,g_inb[l_ac].inb07
                   END IF  #FUN-C30300
                   IF cl_null(g_inb[l_ac].inb05) THEN LET g_inb[l_ac].inb05 = ' ' END IF
                   IF cl_null(g_inb[l_ac].inb06) THEN LET g_inb[l_ac].inb06 = ' ' END IF
                   IF cl_null(g_inb[l_ac].inb07) THEN LET g_inb[l_ac].inb07 = ' ' END IF
                   DISPLAY g_inb[l_ac].inb05 TO inb05
                   DISPLAY g_inb[l_ac].inb06 TO inb06
                   DISPLAY g_inb[l_ac].inb07 TO inb07
                   IF INFIELD(inb05) THEN NEXT FIELD inb05 END IF
                   IF INFIELD(inb06) THEN NEXT FIELD inb06 END IF
                   IF INFIELD(inb07) THEN NEXT FIELD inb07 END IF
 
                WHEN INFIELD(inb08) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_inb[l_ac].inb08
                     CALL cl_create_qry() RETURNING g_inb[l_ac].inb08
                     DISPLAY BY NAME g_inb[l_ac].inb08       #No.MOD-490371
                     NEXT FIELD inb08
 
                WHEN INFIELD(inb902) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_inb[l_ac].inb902
                     CALL cl_create_qry() RETURNING g_inb[l_ac].inb902
                     DISPLAY BY NAME g_inb[l_ac].inb902
                     NEXT FIELD inb902
 
                WHEN INFIELD(inb905) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_inb[l_ac].inb905
                     CALL cl_create_qry() RETURNING g_inb[l_ac].inb905
                     DISPLAY BY NAME g_inb[l_ac].inb905
                     NEXT FIELD inb905
 
                WHEN INFIELD(inb922) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_inb[l_ac].inb922
                     CALL cl_create_qry() RETURNING g_inb[l_ac].inb922
                     DISPLAY BY NAME g_inb[l_ac].inb922
                     NEXT FIELD inb922
 
                WHEN INFIELD(inb925) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_inb[l_ac].inb925
                     CALL cl_create_qry() RETURNING g_inb[l_ac].inb925
                     DISPLAY BY NAME g_inb[l_ac].inb925
                     NEXT FIELD inb925

#FUN-BC0104-----------add------------str------------------
                WHEN INFIELD(inb44) OR INFIELD(inb45) OR INFIELD(inb46) OR INFIELD(inb47) OR INFIELD(inb48)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_inb44"
                     CALL cl_create_qry() RETURNING g_inb[l_ac].inb44,g_inb[l_ac].inb45,
                                                    g_inb[l_ac].inb48,g_inb[l_ac].inb46,
                                                    g_inb[l_ac].inb47
                     DISPLAY BY NAME g_inb[l_ac].inb44,g_inb[l_ac].inb45,
                                     g_inb[l_ac].inb48,g_inb[l_ac].inb46,
                                     g_inb[l_ac].inb47
                     CALL t370_qcl02_sel()
                     CASE                 
                        WHEN INFIELD(inb44) NEXT FIELD inb44
                        WHEN INFIELD(inb45) NEXT FIELD inb45
                        WHEN INFIELD(inb46) NEXT FIELD inb46
                        WHEN INFIELD(inb47) NEXT FIELD inb47
                        WHEN INFIELD(inb48) NEXT FIELD inb48
                     END CASE    
#FUN-BC0104-----------add------------end------------------                     
 
                WHEN INFIELD(inb41) #專案
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"
                  CALL cl_create_qry() RETURNING g_inb[l_ac].inb41
                  DISPLAY BY NAME g_inb[l_ac].inb41
                  NEXT FIELD inb41
                WHEN INFIELD(inb42)  #WBS
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjb4"
                  LET g_qryparam.arg1 = g_inb[l_ac].inb41
                  CALL cl_create_qry() RETURNING g_inb[l_ac].inb42
                  DISPLAY BY NAME g_inb[l_ac].inb42
                  NEXT FIELD inb42
                WHEN INFIELD(inb43)  #活動
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pjk3"
                  LET g_qryparam.arg1 = g_inb[l_ac].inb42
                  CALL cl_create_qry() RETURNING g_inb[l_ac].inb43
                  DISPLAY BY NAME g_inb[l_ac].inb43
                  NEXT FIELD inb43
 
                WHEN INFIELD(inb15)  #理由
                     #FUN-CB0087---add---str---
                     #MOD-D60002--mark begin----#MOD-E40087 remark begin------------
                     CALL s_get_where(g_ina.ina01,'','',g_inb[l_ac].inb04,g_inb[l_ac].inb05,g_ina.ina11,g_ina.ina04) RETURNING l_flag1,l_where
                     #IF l_flag1 AND g_aza.aza115 = 'Y' THEN  #MOD-D40091
                     IF l_flag1 THEN  #MOD-D40091
                        CALL cl_init_qry_var()
                        LET g_qryparam.form     ="q_ggc08"
                        LET g_qryparam.where = l_where
                        LET g_qryparam.default1 = g_inb[l_ac].inb15
                        CALL cl_create_qry() RETURNING g_inb[l_ac].inb15
                     ELSE
                     #MOD-D60002--mark end----#MOD-E40087 remark end------------------
                     #FUN-CB0087---add---end---
                        SELECT ima15 INTO l_ima15 FROM ima_file                                                                        
                         WHERE ima01 = g_inb[l_ac].inb04                                                                               
                           AND imaacti = 'Y'                                                                                           
                        IF STATUS THEN                                                                                                 
                           CALL cl_err('sel ima15',STATUS,1)                                                                           
                        END IF                                                                                                         
                        IF g_sma.sma79 = 'Y' AND l_ima15 = 'Y' THEN                                                                    
                           CALL cl_init_qry_var()
                           #LET g_qryparam.form ="q_azf06"                      #MOD-C70176  q_azf->q_azf06 #CHI-C40009
                           LET g_qryparam.form ="q_azf"  #CHI-C40009
                           LET g_qryparam.default1 = g_inb[l_ac].inb15
                          #LET g_qryparam.arg1 = "A2"         #MOD-AC0115 add 2 #MOD-C70176 mark  
                           LET g_qryparam.arg1 = "A"     #CHI-C40009 
                           CALL cl_create_qry() RETURNING g_inb[l_ac].inb15
                        ELSE
                           CALL cl_init_qry_var()
                           LET g_qryparam.form ="q_azf01a"                    #FUN-930145
                           LET g_qryparam.default1 = g_inb[l_ac].inb15
                           LET g_qryparam.arg1 = "4"                          #FUN-930145
                           CALL cl_create_qry() RETURNING g_inb[l_ac].inb15
                        END IF
                     END IF                                    #FUN-CB0087--ADD   #MOD-D60002 mark #MOD-E40087 remark
                     DISPLAY BY NAME g_inb[l_ac].inb15        #No.MOD-490371
                     NEXT FIELD inb15                        
                WHEN INFIELD(inb901)
                     SELECT ima08 INTO l_ima08 FROM ima_file
                      WHERE ima01 = g_inb[l_ac].inb04
                     IF STATUS THEN
                        LET l_ima08 = ''
                     END IF
                     IF l_ima08 = 'M' THEN LET l_type = '0' END IF
                     IF l_ima08 = 'P' THEN LET l_type = '1' END IF
                     CALL q_coc2(FALSE,FALSE,g_inb[l_ac].inb901,'',g_ina.ina02,
                                 l_type,'',g_inb[l_ac].inb04)
                     RETURNING g_inb[l_ac].inb901,l_coc04
                     DISPLAY BY NAME g_inb[l_ac].inb901         #No.MOD-490371
                     NEXT FIELD inb901
              #新增的母料件開窗
              #這里只需要處理g_sma.sma908='Y'的情況,因為不允許單身新增子料件則在前面
              #BEFORE FIELD att00來做開窗了
              #需注意的是其條件限制是要開多屬性母料件且母料件的屬性組等于當前屬性組
                WHEN INFIELD(att00)
                     #可以新增子料件,開窗是單純的選取母料件
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form ="q_ima_p"
                   #  LET g_qryparam.arg1 = lg_group
                   #  CALL cl_create_qry() RETURNING g_inb[l_ac].att00
                     CALL q_sel_ima(FALSE, "q_ima", "", "" , lg_group, "", "", "" ,"",'' )  RETURNING g_inb[l_ac].att00
#FUN-AA0059 --End--
                     DISPLAY BY NAME g_inb[l_ac].att00
                     LET g_inb[l_ac].inb04 =g_inb[l_ac].att00                   
                     LET g_inb[l_ac].att01 =null                                
                     LET g_inb[l_ac].att01_c =null                              
                     LET g_inb[l_ac].att02 =null                                
                     LET g_inb[l_ac].att02_c =null                              
                     LET g_inb[l_ac].att03 =null                                
                     LET g_inb[l_ac].att03_c =null                              
                     LET g_inb[l_ac].att04 =null                                
                     LET g_inb[l_ac].att04_c =null                              
                     LET g_inb[l_ac].att05 =null                                
                     LET g_inb[l_ac].att05_c =null                              
                     LET g_inb[l_ac].att06 =null                                
                     LET g_inb[l_ac].att06_c =null                              
                     LET g_inb[l_ac].att07 =null                                
                     LET g_inb[l_ac].att07_c =null                              
                     LET g_inb[l_ac].att08 =null                                
                     LET g_inb[l_ac].att08_c =null                              
                     LET g_inb[l_ac].att09 =null                                
                     LET g_inb[l_ac].att09_c =null                              
                     LET g_inb[l_ac].att10 =null                                
                     LET g_inb[l_ac].att10_c =null                              
                     NEXT FIELD att00
               WHEN INFIELD(inb930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  CALL cl_create_qry() RETURNING g_inb[l_ac].inb930
                  DISPLAY BY NAME g_inb[l_ac].inb930
                  NEXT FIELD inb930
           END CASE
 
        ON ACTION q_imd    #查詢倉庫
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_imd"
           LET g_qryparam.default1 = g_inb[l_ac].inb05
           LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
           LET g_qryparam.where    = " imd20='",g_ina.inaplant CLIPPED,"'"     #MOD-C30390
           CALL cl_create_qry() RETURNING g_inb[l_ac].inb05
           DISPLAY BY NAME g_inb[l_ac].inb05                                   #MOD-D60227 add
           NEXT FIELD inb05
 
        ON ACTION q_ime    #查詢倉庫儲位
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_ime1"
           LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0063
           LET g_qryparam.default1 = g_inb[l_ac].inb05
           LET g_qryparam.default2 = g_inb[l_ac].inb06
           CALL cl_create_qry() RETURNING g_inb[l_ac].inb05,g_inb[l_ac].inb06 #MOD-4A0063
           NEXT FIELD inb05

        ON ACTION regen_detail                                                                                                      
#TQC-B10061 --begin--
           IF g_ina.inaconf = 'Y' OR g_ina.inaconf = 'X' THEN
              CALL cl_err('','aim-027',0)
             #EXIT INPUT   #FUN-C20101---MARK----  #FUN-D60112--remark  #FUN-DB0029 mark
              EXIT DIALOG    #FUN-C20101---ADD---- #FUN-D60112--mark    #FUN-DB0029 remark
           END IF 
#TQC-B10061 --end--
           IF NOT cl_confirm('aim-148') THEN                                                                                                 
             #EXIT INPUT   #FUN-C20101---MARK---  #FUN-D60112--remark  #FUN-DB0029 mark
              EXIT DIALOG   #FUN-C20101---ADD---  #FUN-D60112--mark    #FUN-DB0029 remark
           END IF 
           CALL t370_del()
           CALL g_inb.clear()
           CALL t370_g()                                                                                                         
           CALL t370_b_fill(" 1=1")                                                                                                 
          #EXIT INPUT    #FUN-C20101---MARK----  #FUN-D60112--remark  #FUN-DB0029 mark
           EXIT DIALOG    #FUN-C20101---ADD----- #FUN-D60112--mark    #FUN-DB0029 remark

 
 
        ON ACTION modi_lot
           SELECT ima918,ima921 INTO g_ima918,g_ima921
             FROM ima_file
            WHERE ima01 = g_inb[l_ac].inb04
              AND imaacti = "Y"
 
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              LET g_img09 = ''   LET g_img10 = 0   #MOD-A40089 add
              SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
               WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
                 AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
              CALL s_umfchk(g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09)
                  RETURNING l_i,l_fac
              IF l_i = 1 THEN LET l_fac = 1 END IF
              IF g_ina.ina00 = "1" OR g_ina.ina00 = "2" #MOD-910104 mark THEN
                 OR  g_ina.ina00 = "5" OR g_ina.ina00 = "6" THEN  #出庫 #MOD-910104 add
#CHI-9A0022 --Begin
                 IF cl_null(g_inb[l_ac].inb41) THEN
                    LET l_bno = ''
                 ELSE
                    LET l_bno = g_inb[l_ac].inb41
                 END IF
#CHI-9A0022 --End
                #CALL s_lotout(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,      #TQC-B90236 mark
                 CALL s_mod_lot(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,      #TQC-B90236 add
                               g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                               g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                               g_inb[l_ac].inb08,g_img09,  
                               g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD',-1) #CHI-9A0022  #TQC-B90236 add '-1'
                    RETURNING l_r,g_qty 
                #IF l_i = "Y" THEN       #MOD-B30036 mark
                 IF l_r = "Y" THEN       #MOD-B30036 add
                    LET g_qty = s_digqty(g_qty,g_inb[l_ac].inb08)   #FUN-BB0085
                    LET g_inb[l_ac].inb16 = g_qty   #MOD-B70023 add
                    LET g_inb[l_ac].inb09 = g_qty
                    LET b_inb.inb16 = g_qty         #MOD-B70023 add
                    LET b_inb.inb09 = g_qty         #MOd-B70023 add
                 END IF
              END IF
              IF g_ina.ina00 = "3" OR g_ina.ina00="4" THEN
#CHI-9A0022 --Begin
                 IF cl_null(g_inb[l_ac].inb41) THEN
                    LET l_bno = ''
                 ELSE
                    LET l_bno = g_inb[l_ac].inb41
                 END IF
#CHI-9A0022 --End
#No.TQC_B90236-----mark-----begin-------
#                CALL s_lotin(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,
#                             g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09,
#                             g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD')#CHI-9A0022 add l_bno
#No.TQC-B90236-----mark-----end---------
#No.TQC-B90236-----add------begin-------
                 CALL s_mod_lot(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,     
                               g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                               g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                               g_inb[l_ac].inb08,g_img09,
                               g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD',1) 
#No.TQC-B90236-----add------end---------


                    RETURNING l_r,g_qty 
                #IF l_i = "Y" THEN       #MOD-B30036 mark
                 IF l_r = "Y" THEN       #MOD-B30036 add
                    LET g_qty = s_digqty(g_qty,g_inb[l_ac].inb08)   #FUN-BB0085
                    LET g_inb[l_ac].inb16 = g_qty   #MOD-B70023 add
                    LET g_inb[l_ac].inb09 = g_qty
                    LET b_inb.inb16 = g_qty         #MOD-B70023 add
                    LET b_inb.inb09 = g_qty         #MOD-B70023 add
                 END IF
              END IF
           #MOD-F70148 add---start---
           ELSE
              CALL cl_err('','aim1106',1)
           #MOD-F70148 add---start---
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
          #CONTINUE INPUT   ##FUN-C20101---MARK---  #FUN-D60112--mark     #FUN-DB0029 mark
           CONTINUE DIALOG   #FUN-C20101---ADD----- #FUN-D60112--remark   #FUN-DB0029 remark
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
        ON ACTION controls
           CALL cl_set_head_visible("","AUTO")
 
   #END INPUT      #FUN-DB0029 mark
    END DIALOG     #FUN-DB0029 add
#FUN-C20101-----ADD----BEGIN-----
#&endif  #FUN-D60112--mark
 END IF  #FUN-D60112--add

#FUN-D60112---mark--begin--------該段代碼移置服飾二維中
#&ifdef SLK
#    ON ACTION controlb    #設置快捷鍵，用於“款號單身”與“多屬性單身”之間的切換
#       SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 =  g_inbslk[l_ac2].inbslk04
#       IF l_ima151 = 'Y' THEN
#          IF li_a THEN
##              LET li_a = FALSE     #FUN-C60100 MARK---
#             NEXT FIELD inbslk03
#          ELSE
##              LET li_a = TRUE      #FUN-C60100  MARK--
#             NEXT FIELD color
#          END IF
#       END IF
#&endif
# 
#   ON ACTION ACCEPT
#      ACCEPT DIALOG
#   ON ACTION CANCEL
#      EXIT DIALOG   
#   END DIALOG
#FUN-D60112---mark--end--------

#FUN-C20101------add end---------- 
    UPDATE ina_file SET inamodu=g_user,inadate=g_today,ina08=l_ina08 #FUN-A50095 mark  #FUN-C30293 add
   #UPDATE ina_file SET inamodu=g_user,inadate=g_today,ina08='0'     #FUN-A50095 add   #FUN-C30293 mark
     WHERE ina01=g_ina.ina01 
    LET g_ina.ina08 = l_ina08                                        #FUN-A50095 mark  #FUN-C30293 add
   #LET g_ina.ina08 = '0'                                            #FUN-A50095 add   #FUN-C30293 mark
    DISPLAY BY NAME g_ina.ina08
    CALL t370_pic() #FUN-720002
 
    SELECT COUNT(*) INTO g_cnt FROM inb_file WHERE inb01=g_ina.ina01 
#FUN-C20101----ADD---BEGIN----
#FUN-C20101----ADD----end------
    CLOSE t370_bcl
#FUN-C20101-----ADD endif-----    
    COMMIT WORK
    CALL t370_b_fill(" 1=1")                        #MOD-C30541
#   CALL t370_delall()                              #No.FUN-870100  #CHI-C30002 mark
    CALL t370_delHeader()     #CHI-C30002 add
END FUNCTION
#FUN-C20101----ADD------STR--------
#FUN-C20101----ADD------END--------
 
FUNCTION t370_wm_b()
DEFINE l_n   LIKE type_file.num5
 
  IF cl_null(g_ina.ina01) THEN RETURN END IF
  SELECT COUNT(*) INTO l_n FROM inb_file WHERE inb01 = g_ina.ina01
  IF l_n <= 0 THEN RETURN END IF
  IF g_ina.inaconf = 'Y' AND g_ina.inapost = 'N' THEN 
     CALL t370_b()
     # -------MOD-BB0341 start-----------
     #CALL cl_set_comp_entry("inb03,inb911,inb912,inb04,inb08,inb08_fac,
     #                       inb16,inb925,inb926,inb927,inb922,inb923,inb924,  #inb09, #CHI-960092
     #                       inb905,inb906,inb902,inb903,inb15,                #CHI-960092
     #                       inb41,inb42,inb43,inb11,inb12,inb901,inb10,inb930",TRUE)

     CALL cl_set_comp_entry("inb03,inb911,inb912,inb04,inb08,inb08_fac,inb16,inb925,inb926,inb927,inb922,inb923,inb924, 
                             inb905,inb906,inb902,inb903,inb15,inb41,inb42,inb43,inb11,inb12,inb901,inb10,inb930,
                             inb44,inb45,inb46,inb47,inb48",TRUE) #上段會將mark部分也視為欄位  #FUN-C20047 add inb44-48
     # -------MOD-BB0341 end-----------
  END IF
END FUNCTION
FUNCTION t370_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(400)
DEFINE l_ima15         LIKE ima_file.ima15    #No.CHI-950013       
   IF cl_null(p_wc2) THEN
      LET p_wc2 = " 1=1"
   END IF 
   LET g_sql =
       "SELECT inb03,inb911,inb912,", #FUN-6A0007
       "       inb44,inb45,inb48,inb46,'',inb47,",     #FUN-BC0104
       "inb04,'','','','','','','','','','','','','','','','','','','','','',",
       "ima02,ima021,inb05,inb06,inb07,inb08,inb08_fac,",
       "       inb16,inb925,inb926,inb927,inb922,inb923,inb924,",  #FUN-870040
       "       inb09,inb905,inb906,inb907,inb902,inb903,inb904,",
       "       inb15,' ',inb13,inb14,inb41,inb42,inb43,inb11,inb12,inb901,inb10,inb930,'', ",  #FUN-810045 add inb41-43
                                #FUN-BC0062 add inb13,inb14
       "       inbud01,inbud02,inbud03,inbud04,inbud05,",
       "       inbud06,inbud07,inbud08,inbud09,inbud10,",
       "       inbud11,inbud12,inbud13,inbud14,inbud15", 
       "       ,'',''",   #FUN-B30187 
       " FROM inb_file, OUTER ima_file ",
       " WHERE inb01 ='",g_ina.ina01,"'",  #單頭
       "   AND inb_file.inb04 = ima_file.ima01 AND ",p_wc2 CLIPPED,                     #單身
       " ORDER BY inb03"
   PREPARE t370_pb FROM g_sql
   DECLARE inb_curs CURSOR FOR t370_pb
   DISPLAY "p_sql=",g_sql
   CALL g_inb.clear()
   LET g_cnt = 1
   FOREACH inb_curs INTO g_inb[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      SELECT qcl02 INTO g_inb[g_cnt].qcl02 FROM qcl_file WHERE qcl01 = g_inb[g_cnt].inb46   #FUN-BC0104
      SELECT ima15 INTO l_ima15 FROM ima_file                                                                                      
       WHERE ima01 = g_inb[g_cnt].inb04                                                                                            
        #AND imaacti = 'Y'         #MOD-B10101 mark
     #IF STATUS THEN                                   #MOD-A50026 mark
     #   CALL cl_err('select ima15',STATUS,1)          #MOD-A50026 mark
     #END IF                                           #MOD-A50026 mark
      IF cl_null(l_ima15) THEN LET l_ima15='N' END IF  #MOD-A50026 add
      IF g_sma.sma79 = 'Y' AND l_ima15 = 'Y' THEN                                                                                   
        SELECT DISTINCT(azf03) INTO g_inb[g_cnt].azf03 FROM azf_file
         WHERE azf02='A' AND azf01=g_inb[g_cnt].inb15                     #MOD-AC0115 mark #CHI-C40009
          #WHERE (azf02='A' OR azf02 = '2') AND azf01=g_inb[g_cnt].inb15    #MOD-AC0115 add  #CHI-C40009
      ELSE
        SELECT DISTINCT(azf03) INTO g_inb[g_cnt].azf03 FROM azf_file
          WHERE azf02='2' AND azf01=g_inb[g_cnt].inb15
      END IF
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
         #得到該料件對應的父料件和所有屬性
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                imx07,imx08,imx09,imx10 INTO
                g_inb[g_cnt].att00,g_inb[g_cnt].att01,g_inb[g_cnt].att02,
                g_inb[g_cnt].att03,g_inb[g_cnt].att04,g_inb[g_cnt].att05,
                g_inb[g_cnt].att06,g_inb[g_cnt].att07,g_inb[g_cnt].att08,
                g_inb[g_cnt].att09,g_inb[g_cnt].att10
           FROM imx_file WHERE imx000 = g_inb[g_cnt].inb04
 
         LET g_inb[g_cnt].att01_c = g_inb[g_cnt].att01
         LET g_inb[g_cnt].att02_c = g_inb[g_cnt].att02
         LET g_inb[g_cnt].att03_c = g_inb[g_cnt].att03
         LET g_inb[g_cnt].att04_c = g_inb[g_cnt].att04
         LET g_inb[g_cnt].att05_c = g_inb[g_cnt].att05
         LET g_inb[g_cnt].att06_c = g_inb[g_cnt].att06
         LET g_inb[g_cnt].att07_c = g_inb[g_cnt].att07
         LET g_inb[g_cnt].att08_c = g_inb[g_cnt].att08
         LET g_inb[g_cnt].att09_c = g_inb[g_cnt].att09
         LET g_inb[g_cnt].att10_c = g_inb[g_cnt].att10
      END IF
      LET g_inb[g_cnt].gem02c=s_costcenter_desc(g_inb[g_cnt].inb930) #FUN-670093
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_inb.deleteElement(g_cnt)
   CALL t370_refresh_detail()   #No.TQC-650115
   LET g_rec_b=g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
    #FUN-B30170 add begin-------------------------
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_ina.ina01,"'"
    PREPARE sel_rvbs_pre FROM g_sql
    DECLARE rvbs_curs CURSOR FOR sel_rvbs_pre

    CALL g_rvbs.clear()

    LET g_cnt = 1
    FOREACH rvbs_curs INTO g_rvbs[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rvbs.deleteElement(g_cnt)
    LET g_rec_b1 = g_cnt - 1
    #FUN-B30170 add -end--------------------------
END FUNCTION

#FUN-C20101-------ADD----STR------
#FUN-C20101-------ADD----END------ 

FUNCTION t370_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE   l_index  LIKE type_file.num5
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
#FUN-DB0029 --------- add ------- begin -----------
   CALL cl_set_head_visible("s_imxb","NO")
#FUN-DB0029 --------- add ------- end -------------

   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-B30170 add begin-------------------------
   
   IF g_azw.azw04 = '2' AND (g_prog = 'aimt301_slk' OR g_prog = 'aimt302_slk' OR g_prog = 'aimt303_slk') AND g_sma.sma150 ='N'  THEN #FUN-D60112--add  #FUN-DB0029 add sma150
#非服飾流通行業-------------
ELSE
  DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_inb TO s_inb.* #FUN-C20101----MODIFY------

       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

       BEFORE ROW
          LET l_ac = ARR_CURR()
          CALL cl_show_fld_cont()
       AFTER DISPLAY
          CONTINUE DIALOG   #因為外層是DIALOG
   END DISPLAY   


   DISPLAY ARRAY g_rvbs TO s_rvbs.* 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG
   END DISPLAY

      #FUN-D10081---add---str---
      ON ACTION page_list 
         LET g_action_flag="page_list"
         EXIT DIALOG
      #FUN-D10081---add---end---
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
      ON ACTION first
         CALL t370_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL t370_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
      ON ACTION jump
         CALL t370_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL t370_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL t370_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
       ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t370_set_perlang()   #TQC-710032
         CALL t370_pic() #FUN-720002
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

   #FUN-BC0104-add-str--
      ON ACTION qc_determine_storage
         LET g_action_choice="qc_determine_storage"
         EXIT DIALOG
   #FUN-BC0104-add-end--

   ##---- 20220316 add --------(S)
   #@ ON ACTION 修改需求日期
      ON ACTION modify_inaud13
         LET g_action_choice="modify_inaud13"
         EXIT DIALOG
   ##---- 20220316 add ------- (E)
 
   #@ ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
   #@ ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
      ON ACTION easyflow_approval
         LET g_action_choice="easyflow_approval"
         EXIT DIALOG
    #@ON ACTION 庫存過帳
      ON ACTION stock_post
         LET g_action_choice="stock_post"
         EXIT DIALOG
    #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DIALOG
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG

      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
      #CHI-D20010---end
 
 
      ON ACTION accept
         LET g_action_choice="detail"
        #LET l_ac = ARR_CURR()       #FUN-DB0029 mark
         EXIT DIALOG
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION approval_status                    #FUN-550047
         LET g_action_choice="approval_status"
         EXIT DIALOG
 
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DIALOG
 
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DIALOG
 
      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DIALOG
 
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DIALOG
 
      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DIALOG
 
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DIALOG
 
#@    ON ACTION 拋轉至SPC
      ON ACTION trans_spc                      #FUN-680010
         LET g_action_choice="trans_spc"
         EXIT DIALOG

      #拋轉請購單 20200211
      ON ACTION carry_pr
         LET g_action_choice = "carry_pr"
         EXIT DIALOG
 
      ON ACTION related_document                #No.FUN-680046  相關文件
         LET g_action_choice="related_document"
         EXIT DIALOG
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DIALOG
 
      ON ACTION warahouse_modify
         LET g_action_choice="warahouse_modify"
         EXIT DIALOG

      ##---- 20200317 超耗數量
      ON ACTION over_qty
         LET g_action_choice = "over_qty"
         EXIT DIALOG
 
      #No:DEV-D30026--add--begin
      ON ACTION barcode_gen
         LET g_action_choice = 'barcode_gen'
         EXIT DIALOG

      ON ACTION barcode_query
         LET g_action_choice = 'barcode_query'
         EXIT DIALOG

      ON ACTION barcode_output #條碼列印
         LET g_action_choice = 'barcode_output'
         EXIT DIALOG
      #No:DEV-D30026--add--end
 &include "qry_string.4gl"
   END DIALOG

END IF
#FUN-D60112--add--end---------
#FUN-B30170 add -end--------------------------
#FUN-B30170 mark -begin--------------------------
#   DISPLAY ARRAY g_inb TO s_inb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
# 
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#      ON ACTION first
#         CALL t370_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#      ON ACTION previous
#         CALL t370_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#      ON ACTION jump
#         CALL t370_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#      ON ACTION next
#         CALL t370_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#      ON ACTION last
#         CALL t370_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
#       ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         CALL t370_set_perlang()   #TQC-710032
#         CALL t370_pic() #FUN-720002
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
# 
#   #@ ON ACTION 確認
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
#   #@ ON ACTION 取消確認
#      ON ACTION undo_confirm
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
#      ON ACTION easyflow_approval
#         LET g_action_choice="easyflow_approval"
#         EXIT DISPLAY
#    #@ON ACTION 庫存過帳
#      ON ACTION stock_post
#         LET g_action_choice="stock_post"
#         EXIT DISPLAY
#    #@ON ACTION 過帳還原
#      ON ACTION undo_post
#         LET g_action_choice="undo_post"
#         EXIT DISPLAY
#    #@ON ACTION 作廢
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
# 
#&ifdef ICD
#    #@ON ACTION 單據刻號BIN查詢作業
#      ON ACTION aic_s_icdqry
#         LET g_action_choice = "aic_s_icdqry"
#         EXIT DISPLAY
# 
#    #@ON ACTION 單據刻號BIN明細維護作業
#      ON ACTION aic_s_icdout
#         LET g_action_choice = "aic_s_icdout"
#         EXIT DISPLAY
#&endif
# 
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#             LET INT_FLAG=FALSE 		#MOD-570244	mars
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION exporttoexcel #FUN-4B0002
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION approval_status                    #FUN-550047
#         LET g_action_choice="approval_status"
#         EXIT DISPLAY
# 
#      ON ACTION agree
#         LET g_action_choice = 'agree'
#         EXIT DISPLAY
# 
#      ON ACTION deny
#         LET g_action_choice = 'deny'
#         EXIT DISPLAY
# 
#      ON ACTION modify_flow
#         LET g_action_choice = 'modify_flow'
#         EXIT DISPLAY
# 
#      ON ACTION withdraw
#         LET g_action_choice = 'withdraw'
#         EXIT DISPLAY
# 
#      ON ACTION org_withdraw
#         LET g_action_choice = 'org_withdraw'
#         EXIT DISPLAY
# 
#      ON ACTION phrase
#         LET g_action_choice = 'phrase'
#         EXIT DISPLAY
# 
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
##@    ON ACTION 拋轉至SPC
#      ON ACTION trans_spc                      #FUN-680010
#         LET g_action_choice="trans_spc"
#         EXIT DISPLAY
# 
#      ON ACTION related_document                #No.FUN-680046  相關文件
#         LET g_action_choice="related_document"
#         EXIT DISPLAY
#     ON ACTION controls
#         CALL cl_set_head_visible("","AUTO")
# 
#      ON ACTION qry_lot
#         LET g_action_choice="qry_lot"
#         EXIT DISPLAY
# 
#      ON ACTION warahouse_modify
#         LET g_action_choice="warahouse_modify"
#         EXIT DISPLAY
# 
#      &include "qry_string.4gl"
# 
#   END DISPLAY
#FUN-B30170 mark --end---------------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
###以下由 saimt370 global 移過來 ###
 
FUNCTION t370_init()
    CALL cl_set_comp_visible("inb903,inb906",FALSE)
    CALL cl_set_comp_visible("inb923,inb926",FALSE)  #FUN-870040
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("inb905,inb906,inb907",FALSE)
       CALL cl_set_comp_visible("inb902,inb903,inb904",FALSE)
       CALL cl_set_comp_visible("inb925,inb926,inb927",FALSE)  #FUN-870040
       CALL cl_set_comp_visible("inb922,inb923,inb924",FALSE)  #FUN-870040
    ELSE
       CALL cl_set_comp_visible("inb08,inb08_fac,inb09,inb16",FALSE)  #FUN-870040
    END IF
    IF g_aaz.aaz90='Y' THEN
       CALL cl_set_comp_required("ina04",TRUE)
    END IF
    CALL cl_set_comp_visible("inb930,gem02c",g_aaz.aaz90='Y')
    CALL cl_set_comp_visible("inb911,inb912",g_sma.sma79='Y')

    IF g_prog = 'aimt303' OR g_prog = 'aimt313' THEN
       CALL cl_set_comp_visible("inaspc",FALSE)
       CALL cl_set_act_visible("trans_spc",FALSE)
       CALL cl_set_comp_entry("inb10",FALSE) #TQC-740266
    ELSE
       IF g_aza.aza64 matches '[ Nn]' THEN
          CALL cl_set_comp_visible("inaspc",FALSE)
          CALL cl_set_act_visible("trans_spc",FALSE)
       END IF
    END IF
    #FUN-BC0104-add-str--
    IF g_argv1 <> '3' THEN 
       CALL cl_set_act_visible("qc_determine_storage",FALSE)
       CALL cl_set_comp_visible("inb44,inb45,inb46,inb47,inb48,qcl02",FAlSE)
    END IF
    SELECT qcz14 INTO g_qcz.qcz14 FROM qcz_file
    IF g_qcz.qcz14 = 'N' THEN 
       CALL cl_set_comp_visible("inb44,inb45,inb46,inb47,inb48,qcl02",FAlSE)
       CALL cl_set_act_visible("qc_determine_storage",FALSE)
    END IF
    #FUN-BC0104-add-end--

# FUN-B80093 add START
   IF g_sma.sma93="Y" THEN
      CALL cl_set_comp_visible("ina103", TRUE)
   ELSE
      CALL cl_set_comp_visible("ina103", FALSE)
   END IF
# FUN-B80093 add END


    CALL t370_set_perlang()
 
    DISPLAY g_argv1 TO ina00
    IF g_argv1 MATCHES '[135]' THEN
       LET g_imd10='S'
    ELSE
       LET g_imd10='W'
        #解析ls_value生成要傳給cl_copy_bom的那個l_param_list
    END IF
 
    IF fgl_getenv('EASYFLOW') = "1" THEN
          LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1
    END IF
    #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
    #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
    CALL aws_efapp_toolbar()    #FUN-580120
    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
#FUN-A50036 mod str ---
   #CALL aws_efapp_flowaction("insert, modify,delete, reproduce, detail, query, locale,void,confirm, undo_confirm, easyflow_approval")                                                        #FUN-A50095 mark
    CALL aws_efapp_flowaction("insert, modify,delete, reproduce, detail, query, locale,void, undo_void, confirm, undo_confirm, easyflow_approval, stock_post, undo_post, warahouse_modify,barcode_gen,over_qty")               #FUN-A50095 add   #CHI-D20010 add undo_void   #FUN-D30030 add barcode_gen
#FUN-A50036 mod end ---  
         RETURNING g_laststage
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    CALL cl_set_comp_visible("ina06,inb41,inb42,inb43",g_aza.aza08='Y')  #FUN-810045 add

    SELECT aza131 INTO g_aza.aza131 FROM aza_file   #FUN-D30030 add

    #No:DEV-D30026--add--begin
    IF g_prog <> 'aimt302' OR g_aza.aza131 = 'N' THEN    #FUN-D30030 add g_aza.aza131 = 'N'
       CALL cl_set_act_visible("barcode_gen,barcode_query,barcode_output", FALSE)
    END IF
    #No:DEV-D30026--add--end

    #FUN-G90010 add str---
    CALL cl_set_act_visible("barcode_gen,barcode_query,barcode_output", FALSE)
    #FUN-G90010 add end---
END FUNCTION
 
FUNCTION t370_set_perlang()
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb905",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb907",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb902",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb904",g_msg CLIPPED)
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_getmsg('asm-502',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb925",g_msg CLIPPED)
       CALL cl_getmsg('asm-506',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb927",g_msg CLIPPED)
       CALL cl_getmsg('asm-503',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb922",g_msg CLIPPED)
       CALL cl_getmsg('asm-507',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb924",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb905",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb907",g_msg CLIPPED)
       IF g_argv1 MATCHES '[12]' THEN
          CALL cl_getmsg('asm-315',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb902",g_msg CLIPPED)
          CALL cl_getmsg('asm-317',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb904",g_msg CLIPPED)
       END IF
       IF g_argv1 MATCHES '[34]' THEN
          CALL cl_getmsg('asm-314',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb902",g_msg CLIPPED)
          CALL cl_getmsg('asm-318',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb904",g_msg CLIPPED)
       END IF
       IF g_argv1 MATCHES '[56]' THEN
          CALL cl_getmsg('asm-316',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb902",g_msg CLIPPED)
          CALL cl_getmsg('asm-319',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb904",g_msg CLIPPED)
       END IF
       CALL cl_getmsg('asm-504',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb925",g_msg CLIPPED)
       CALL cl_getmsg('asm-508',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb927",g_msg CLIPPED)
       IF g_argv1 MATCHES '[12]' THEN
          CALL cl_getmsg('asm-515',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb922",g_msg CLIPPED)
          CALL cl_getmsg('asm-517',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb924",g_msg CLIPPED)
       END IF
       IF g_argv1 MATCHES '[34]' THEN
          CALL cl_getmsg('asm-514',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb922",g_msg CLIPPED)
          CALL cl_getmsg('asm-518',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb924",g_msg CLIPPED)
       END IF
       IF g_argv1 MATCHES '[56]' THEN
          CALL cl_getmsg('asm-516',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb922",g_msg CLIPPED)
          CALL cl_getmsg('asm-519',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb924",g_msg CLIPPED)
       END IF
    END IF
    IF g_sma.sma122 ='3' THEN
       IF g_argv1 MATCHES '[34]' THEN
          CALL cl_getmsg('asm-424',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb902",g_msg CLIPPED)
          CALL cl_getmsg('asm-425',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb904",g_msg CLIPPED)
       END IF
       IF g_argv1 MATCHES '[56]' THEN
          CALL cl_getmsg('asm-422',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb902",g_msg CLIPPED)
          CALL cl_getmsg('asm-423',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb904",g_msg CLIPPED)
       END IF
       IF g_argv1 MATCHES '[34]' THEN
          CALL cl_getmsg('asm-524',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb922",g_msg CLIPPED)
          CALL cl_getmsg('asm-525',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb924",g_msg CLIPPED)
       END IF
       IF g_argv1 MATCHES '[56]' THEN
          CALL cl_getmsg('asm-522',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb922",g_msg CLIPPED)
          CALL cl_getmsg('asm-523',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb924",g_msg CLIPPED)
       END IF
    END IF
END FUNCTION
 
FUNCTION t370_a_default()
DEFINE l_inaplant_desc   LIKE azp_file.azp02    #FUN-9C0090 ADD
   LET g_ina.ina00  =g_argv1
   LET g_ina.ina02  =g_today
   LET g_ina.ina03  =g_today
   IF cl_null(g_ina.ina04) THEN #FUN-840012
      LET g_ina.ina04  =g_grup  #MOD-530345
   END IF
   LET g_ina.inapost='N'
   LET g_ina.inaconf='N'     #FUN-660079
   LET g_ina.inaspc ='0'     #FUN-680010
   LET g_ina.inauser=g_user
   LET g_ina.inaoriu = g_user #FUN-980030
   LET g_ina.inaorig = g_grup #FUN-980030
   LET g_data_plant = g_plant #FUN-980030
   LET g_ina.inagrup=g_grup
   LET g_ina.inadate=g_today
   LET g_ina.ina08 = '0'           #開立  #FUN-550047
   LET g_ina.inamksg = 'N'         #簽核否#FUN-550047
   LET g_ina.ina12='N'       #No.FUN-870100
   LET g_ina.inapos='N'       #No.FUN-870100
   LET g_ina.inacont=''       #No.FUN-870100
   LET g_ina.inaconu=''       #No.FUN-870100
   SELECT azp02 INTO l_inaplant_desc FROM azp_file
    WHERE azp01=g_ina.inaplant
   DISPLAY l_inaplant_desc TO FORMONLY.inaplant_desc
   DISPLAY g_ina.inapos TO inapos  #No.FUN-870100
   DISPLAY g_ina.inacont TO inacont  #No.FUN-870100
   DISPLAY g_ina.inaconu TO inaconu  #No.FUN-870100
   IF cl_null(g_ina.ina11) THEN #FUN-840012
      LET g_ina.ina11=g_user
   END IF
   CALL t370_ina11('a')    #No.MOD-940186 add
   IF NOT cl_null(g_errno) THEN
     LET g_ina.ina11 = ''
   END IF
END FUNCTION
 
FUNCTION t370_a_inschk()
   DEFINE li_result LIKE type_file.num5
   CALL s_auto_assign_no("aim",g_ina.ina01,g_ina.ina03,g_chr,"ina_file","ina01","","","")
     RETURNING li_result,g_ina.ina01
   IF (NOT li_result) THEN
      RETURN FALSE
   END IF
   DISPLAY BY NAME g_ina.ina01
   IF cl_null(g_ina.inamksg) THEN
      LET  g_ina.inamksg = g_smy.smyapr
   END IF
   IF cl_null(g_ina.inamksg) THEN
      LET  g_ina.inamksg = 'N'
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_a_ins()
   IF cl_null(g_ina.ina12) THEN
      LET g_ina.ina12 = 'N'
   END IF 
   IF cl_null(g_ina.inapos) THEN
      LET g_ina.inapos = 'N'
   END IF 
 
   LET g_ina.inaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_ina.inaorig = g_grup      #No.FUN-980030 10/01/04

   INSERT INTO ina_file VALUES (g_ina.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","ina_file",g_ina.ina01,"",SQLCA.sqlcode,
                   "","ins ina",1)
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_u_upd()
   LET g_ina.ina08 = '0'        #FUN-550047
   DISPLAY BY NAME g_ina.ina08
   UPDATE ina_file SET * = g_ina.* WHERE ina01 = g_ina_o.ina01   #No.TQC-9C0056
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","ina_file",g_ina_t.ina01,"",SQLCA.sqlcode,"",
                   "upd ina",1)
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chkkey()
   UPDATE inb_file SET inb01=g_ina.ina01
    WHERE inb01=g_ina_t.ina01 
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","inb_file",g_ina_t.ina01,"",SQLCA.sqlcode,"",
                   "upd inb01",1)  #No.FUN-660156
      LET g_ina.*=g_ina_t.*
      CALL t370_show()
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t370_chk_ina01()
   DEFINE li_result       LIKE type_file.num5    #No.FUN-550029  #No.FUN-690026 SMALLINT
   DEFINE l_cnt     LIKE type_file.num5   #FUN-C80045 add
   IF NOT cl_null(g_ina.ina01) THEN
      LET g_t1=s_get_doc_no(g_ina.ina01)
      #得到該單別對應的屬性群組
      IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) THEN
         #讀取smy_file中指定作業對應的默認屬性群組
         SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_t1
         #刷新界面顯示
         CALL t370_refresh_detail()
      ELSE
         LET lg_smy62 = ''
      END IF
      #FUN-C80045 add sta
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM rye_file WHERE rye04 = g_t1 AND ryeacti = 'Y' AND rye01 = 'aim'
      IF l_cnt > 0 THEN
         CALL cl_err(g_t1,'apc1036',0)
         RETURN FALSE
      END IF
      #FUN-C80045 add end

      CASE WHEN g_ina.ina00 MATCHES "[12]" LET g_chr='1'
           WHEN g_ina.ina00 MATCHES "[34]" LET g_chr='2'
           WHEN g_ina.ina00 MATCHES "[56]" LET g_chr='3'
      END CASE
      CALL s_check_no("aim",g_ina.ina01,g_ina_t.ina01,g_chr,"ina_file","ina01","")
        RETURNING li_result,g_ina.ina01
      DISPLAY BY NAME g_ina.ina01
      IF (NOT li_result) THEN
         RETURN FALSE
      END IF
      DISPLAY BY NAME g_smy.smydesc
      LET  g_ina.inamksg = g_smy.smyapr
      DISPLAY BY NAME g_ina.inamksg   #簽核否
   ELSE
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
         LET lg_smy62 = ''
         CALL t370_refresh_detail()
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_ina02()
   
   
   IF NOT cl_null(g_ina.ina02) THEN
	    IF g_sma.sma53 IS NOT NULL AND g_ina.ina02 <= g_sma.sma53 THEN
	       CALL cl_err('','mfg9999',0)
	       RETURN FALSE
	    END IF
      CALL s_yp(g_ina.ina02) RETURNING g_yy,g_mm
      IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
         CALL cl_err('','mfg6091',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_ina11()
   IF NOT cl_null(g_ina.ina11) THEN
      CALL t370_ina11('a')
      IF NOT cl_null(g_errno) THEN
         LET g_ina.ina11 = g_ina_t.ina11
         CALL cl_err(g_ina.ina11,g_errno,0)
         DISPLAY BY NAME g_ina.ina11
         RETURN FALSE
      END IF
   ELSE
      DISPLAY '' TO FORMONLY.gen02
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_ina04()
   CASE
      WHEN g_ina.ina00 MATCHES "[12]"
         LET g_chr='1'
         IF cl_null(g_ina.ina04) AND g_sma.sma847[1,1] = 'Y' THEN
            #參數設定(asms230)雜項發料要輸入部門,請輸入部門編號
            CALL cl_err('','aim-330',0)
            RETURN FALSE
         END IF
      WHEN g_ina.ina00 MATCHES "[34]"
         LET g_chr='2'
         IF cl_null(g_ina.ina04) AND g_sma.sma847[2,2] = 'Y' THEN
            #參數設定(asms230)雜項收料要輸入部門,請輸入部門編號
            CALL cl_err('','aim-331',0)
            RETURN FALSE
         END IF
      WHEN g_ina.ina00 MATCHES "[56]"
         LET g_chr='3'
         #FUN-CC0074 add
         IF cl_null(g_ina.ina04) AND g_sma.sma847[3,3] = 'Y' THEN
            #參數設定(asms230)雜項報廢要輸入部門,請輸入部門編號
            CALL cl_err('','aim-332',0)
            RETURN FALSE
         END IF
         #FUN-CC0074 add--end
      OTHERWISE EXIT CASE
   END CASE
 
   IF NOT cl_null(g_ina.ina04) THEN
      SELECT gem02 INTO g_buf FROM gem_file
       WHERE gem01=g_ina.ina04
         AND gemacti='Y'   #NO:6950
      IF STATUS THEN
         CALL cl_err3("sel","gem_file",g_ina.ina04,"",SQLCA.sqlcode,"",
                      "select gem",1)
         RETURN FALSE
      END IF
      DISPLAY g_buf TO gem02
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_ina06()
   IF NOT cl_null(g_ina.ina06) AND g_aza.aza08='Y' THEN
       LET g_cnt=0
       LET g_buf ='' #20210506
       SELECT COUNT(*),pja02 INTO g_cnt,g_buf   #20210506 modify
         FROM pja_file
        WHERE pja01 = g_ina.ina06
          AND pjaacti = 'Y'
          AND pjaclose = 'N'           #FUN-960038
       GROUP BY pja02                  #20210506 add

       IF g_cnt = 0  THEN   #check 專案代號主檔
          CALL cl_err(g_ina.ina06,'apj-004',0)
          LET g_ina.ina06= g_ina_t.ina06
          DISPLAY BY NAME g_ina.ina06
          RETURN FALSE
       ELSE                       #20210506
          DISPLAY g_buf TO pja02  #20210506
       END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_i_aft_inp()
   DEFINE l_flag LIKE type_file.num5
   LET l_flag=TRUE
   IF g_ina.ina00 MATCHES "[12]" AND
      cl_null(g_ina.ina04) AND g_sma.sma847[1,1] = 'Y' THEN
      LET l_flag=FALSE
      DISPLAY BY NAME g_ina.ina04
      CALL cl_err('','aim-330',0) #MOD-550007
   END IF
   IF g_ina.ina00 MATCHES "[34]" AND
      cl_null(g_ina.ina04) AND g_sma.sma847[2,2] = 'Y' THEN
      LET l_flag=FALSE
      DISPLAY BY NAME g_ina.ina04
      CALL cl_err('','aim-331',0) #MOD-550007
   END IF
   #FUN-CC0074 add
   IF g_ina.ina00 MATCHES "[56]" AND
      cl_null(g_ina.ina04) AND g_sma.sma847[3,3] = 'Y' THEN
      LET l_flag=FALSE
      DISPLAY BY NAME g_ina.ina04
      CALL cl_err('','aim-332',0)
   END IF
   #FUN-CC0074 add--end
   RETURN l_flag
END FUNCTION
 
 
FUNCTION t370_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ina01",TRUE)   #MOD-740123 ina00 移除
   END IF
END FUNCTION
 
FUNCTION t370_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ina01",FALSE)   #MOD-740123 modify ina00 移除
   END IF
END FUNCTION
 
FUNCTION t370_set_entry_b()
 
   CALL cl_set_comp_entry("inb901",TRUE)
 
   CALL cl_set_comp_entry("inb905",TRUE)         #CHI-960092  
   CALL cl_set_comp_entry("inb925,inb927",TRUE)  #FUN-870040
 
   CALL cl_set_comp_entry("inb912",TRUE)
 
   CALL cl_set_comp_entry("inb41,inb42,inb43",TRUE)

   CALL cl_set_comp_entry("inb04,inb08,inb902,inb905,inb922,inb925",TRUE)       #FUN-C20047
 
END FUNCTION
 
FUNCTION t370_set_no_entry_b()
DEFINE l_smy57 LIKE smy_file.smy57  #CHI-960025
DEFINE l_imaicd09 LIKE imaicd_file.imaicd09  #TQC-C60020
#DEFINE l_imaicd08 LIKE imaicd_file.imaicd08   #FUN-B30187 #FUN-BA0051 mark
   IF g_aza.aza27 != 'Y' OR g_ina.ina00 NOT MATCHES '[56]' THEN
      LET g_t1=s_get_doc_no(g_ina.ina01)                                                                                            
      SELECT smy57 INTO l_smy57 FROM smy_file                                                                                       
       WHERE smyslip=g_t1                                                                                                           
      LET l_smy57=l_smy57[5,5]                                                                                                      
      IF l_smy57='N' THEN                                                                                                           
         CALL cl_set_comp_entry("inb901",FALSE)
      END IF #CHI-960025        
   END IF

   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("inb905,inb906,inb907",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("inb903,inb906",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("inb905",FALSE)
   END IF
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("inb925,inb926,inb927",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("inb923,inb926",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("inb925",FALSE)
   END IF
 
   IF l_ac = 0  THEN CALL cl_set_comp_entry("inb912",FALSE) END IF
   IF INFIELD(inb911) THEN
      IF cl_null(g_inb[l_ac].inb911) THEN
         CALL cl_set_comp_entry("inb912",FALSE)
      END IF
   END IF
   CALL cl_set_comp_entry("inb08_fac",FALSE)   #MOD-6A0104 add
   #FUN-810045  begin 如果是由工單轉入的資料不可更改專案相關欄位
   IF NOT cl_null(g_ina.ina10) THEN
     CALL cl_set_comp_entry("inb41,inb42,inb43",FALSE)
   END IF



   #FUN-C20047----Begin----
   IF l_ac > 0 THEN
      IF NOT cl_null(g_inb[l_ac].inb46) THEN 
         CALL cl_set_comp_entry("inb04,inb08,inb902,inb905,inb922,inb925",FALSE)
      END IF
   END IF
   #FUN-C20047----End-----
 
END FUNCTION
 
FUNCTION t370_set_required()
  IF g_sma.sma115 = 'Y' THEN #MOD-EC0015 add if 判斷 #使用雙單位否
      #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
      IF g_ima906 = '3' THEN
         CALL cl_set_comp_required("inb905,inb907,inb902,inb904",TRUE)
      END IF
      #單位不同,轉換率,數量必KEY
      IF NOT cl_null(g_inb[l_ac].inb902) THEN
         CALL cl_set_comp_required("inb904",TRUE)
      END IF
      IF NOT cl_null(g_inb[l_ac].inb905) THEN
         CALL cl_set_comp_required("inb907",TRUE)
      END IF
     
      #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
      IF g_ima906 = '3' THEN
         CALL cl_set_comp_required("inb925,inb927,inb922,inb924",TRUE)
      END IF
      #單位不同,轉換率,數量必KEY
      IF NOT cl_null(g_inb[l_ac].inb922) THEN
         CALL cl_set_comp_required("inb924",TRUE)
      END IF
      IF NOT cl_null(g_inb[l_ac].inb925) THEN
         CALL cl_set_comp_required("inb927",TRUE)
      END IF
      #--
  END IF #MOD-EC0015 add
 
 
  IF g_sma.sma79 = 'Y' THEN #MOD-EC0015 add if 判斷 #是否使用保稅系統
      IF NOT cl_null(g_inb[l_ac].inb911) THEN
         CALL cl_set_comp_required("inb912",TRUE)
      END IF
      IF NOT cl_null(g_inb[l_ac].inb04) THEN
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM ima_file
          WHERE ima01 = g_inb[l_ac].inb04 AND ima106 = '6'
         IF g_cnt <> 0 THEN
            CALL cl_set_comp_required("inb911,inb912",TRUE)
         END IF
      END IF
  END IF #MOD-EC0015 add
END FUNCTION
 
FUNCTION t370_set_no_required()
  CALL cl_set_comp_required("inb905,inb906,inb907,inb902,inb903,inb904,inb925,inb926,inb927,inb922,inb923,inb924,inb911,inb912",FALSE) #FUN-6A0007  #FUN-870040
END FUNCTION


#FUN-A40022--begin--add----
FUNCTION t370_set_required_inb07(p_cmd)
DEFINE l_ima159   	LIKE ima_file.ima159   #FUN-B50096
#DEFINE l_imaicd13 LIKE imaicd_file.imaicd13   #FUN-B50096
DEFINE p_cmd      LIKE type_file.chr1

#FUN-C20101----ADD----STR----
 #IF g_azw.azw04='2' AND (g_prog="aimt301_slk" OR g_prog="aimt302_slk" OR g_prog="aimt303_slk") THEN    #FUN-D60112-add    #MOD-E90053 mark
  IF g_azw.azw04='2' AND (g_prog="aimt301_slk" OR g_prog="aimt302_slk" OR g_prog="aimt303_slk") AND g_sma.sma150='N' THEN  #MOD-E90053 add
#&else
 ELSE
#FUN-D60112-modify---end--------
#FUN-C20101----ADD----end-----
   IF p_cmd='u' OR INFIELD(inb04) THEN
      IF NOT cl_null(g_inb[l_ac].inb04) THEN
#FUN-B50096 ---------------Begin---------------
      #  SELECT imaicd13 INTO l_imaicd13 FROM imaicd_file
      #   WHERE imaicd00 = g_inb[l_ac].inb04
      #  IF l_imaicd13 = 'Y' THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_inb[l_ac].inb04
         IF l_ima159 = '1' THEN
#FUN-B50096 ---------------End-----------------
            IF cl_null(g_inb[l_ac].inb07) THEN LET g_inb[l_ac].inb07=NULL END IF
            CALL cl_set_comp_required("inb07",TRUE)
         END IF
      END IF
   END IF
#&endif   #FUN-D60112--mark
 END IF   #FUN-D60112--add
#FUN-C20101----ADD endif----------   
END FUNCTION

FUNCTION t370_set_no_required_inb07()
#FUN-C20101---ADD---STR--
     CALL cl_set_comp_required("inb07",FALSE)
#FUN-C20101---add endif---------     
END FUNCTION
#FUN-A40022--end--add-----

#FUN-BC0104----add----str----
FUNCTION t370_qcl02_sel()
   SELECT qcl02 INTO g_inb[l_ac].qcl02 
    FROM qcl_file 
   WHERE qcl01 = g_inb[l_ac].inb46
END FUNCTION

FUNCTION t370_qc_inb_check()
   IF NOT cl_null(g_inb[l_ac].inb44) OR NOT cl_null(g_inb[l_ac].inb45)
      OR NOT cl_null(g_inb[l_ac].inb46) OR NOT cl_null(g_inb[l_ac].inb47)
      OR NOT cl_null(g_inb[l_ac].inb48) THEN 
      CALL cl_set_comp_required("inb44,inb45,inb46,inb47,inb48",TRUE)
      LET g_inb[l_ac].inb10 = 'Y'                                          #MOD-C30541
      CALL cl_set_comp_entry("inb10",FALSE)                                #MOD-C30541
   END IF   
   IF cl_null(g_inb[l_ac].inb44) AND cl_null(g_inb[l_ac].inb45)
       AND cl_null(g_inb[l_ac].inb46) AND cl_null(g_inb[l_ac].inb47)
       AND cl_null(g_inb[l_ac].inb48) THEN
      CALL cl_set_comp_required("inb44,inb45,inb46,inb47,inb48",FALSE)
      LET g_inb[l_ac].qcl02 = ''
      CALL cl_set_comp_entry("inb10",TRUE)                                #MOD-C30541
   END IF   
END FUNCTION

FUNCTION t370_set_entry_inb()
   CALL cl_set_comp_entry("inb44,inb45,inb46,inb47,inb48",FALSE)
END FUNCTION

#MOD-C30541------mark-----str-----
#FUNCTION t370_set_require_inb44()
#DEFINE l_n    LIKE type_file.num5
#DEFINE l_n1   LIKE type_file.num5
#DEFINE l_sql  STRING
#DEFINE l_sql1 STRING
#DEFINE l_sql2 STRING
#
#   LET l_n = 0     
#   LET l_n1= 0
#   LET l_sql = " SELECT COUNT(*) FROM inb_file",
#               " WHERE inb01 = ? "
#               " AND inb03 = ? "  
#               
#   LET l_sql1 = l_sql CLIPPED," AND inb46 IS NOT NULL AND inb46 <> ' '" 
#   PREPARE insert_ln FROM l_sql1
#   EXECUTE insert_ln INTO l_n USING g_ina.ina01,g_inb[l_ac].inb03 
#   
#   LET l_sql2 = l_sql CLIPPED," AND (inb46 IS NULL OR inb46 = ' ')"   
#   PREPARE insert_ln1 FROM l_sql2
#   EXECUTE insert_ln1 INTO l_n1 USING g_ina.ina01,g_inb[l_ac].inb03
#
#   IF l_n > 0 THEN
#      CALL cl_set_comp_required("inb44,inb45,inb46,inb47,inb48",TRUE)
#   END IF
#   IF l_n1 > 0 THEN
#      LET g_inb[l_ac].inb44 = ''
#      LET g_inb[l_ac].inb45 = ''
#      LET g_inb[l_ac].inb46 = ''
#      LET g_inb[l_ac].inb47 = ''
#      LET g_inb[l_ac].inb48 = ''
#      DISPLAY BY NAME g_inb[l_ac].inb44,g_inb[l_ac].inb45,g_inb[l_ac].inb46,g_inb[l_ac].inb47,g_inb[l_ac].inb48       
#      CALL cl_set_comp_required("inb44,inb45,inb46,inb47,inb48",FALSE)
#   END IF   
#END FUNCTION
#MOD-C30541-----mark-----end-----

FUNCTION t370_inb_chk()
DEFINE l_n    LIKE type_file.num5
DEFINE l_sql  STRING

   LET l_n = 0
   LET l_sql = " SELECT COUNT(*) FROM qco_file,qcs_file,qcf_file,qcl_file",
               " WHERE ((qco01 = qcs01 AND qco02 = qcs02 AND qco05 = qcs05 AND qcs00 IN('2','Z') AND qcs14 ='Y')",     
               "    OR (qco01 = qcf01 AND qcf00='2' AND qcf14='Y'))",
              #"   AND  qcl01 = qco03 AND qcl05 <>'3' "     #FUN-CC0013 mark
               "   AND  qcl01 = qco03 "                     #FUN-CC0013 add
   IF NOT cl_null(g_inb[l_ac].inb44) THEN
      LET l_sql = l_sql CLIPPED," AND qco01 = '",g_inb[l_ac].inb44 CLIPPED,"'"
   END IF
   IF NOT cl_null(g_inb[l_ac].inb45) THEN
      LET l_sql = l_sql CLIPPED," AND qco02 = ",g_inb[l_ac].inb45 CLIPPED
   END IF
   IF NOT cl_null(g_inb[l_ac].inb46) THEN
      LET l_sql = l_sql CLIPPED," AND qco03 = '",g_inb[l_ac].inb46 CLIPPED,"'"
   END IF
   IF NOT cl_null(g_inb[l_ac].inb47) THEN
      LET l_sql = l_sql CLIPPED," AND qco04 = ",g_inb[l_ac].inb47 CLIPPED
   END IF
   IF NOT cl_null(g_inb[l_ac].inb48) THEN
      LET l_sql = l_sql CLIPPED," AND qco05 = ",g_inb[l_ac].inb48 CLIPPED
   END IF 
   PREPARE insert_l_n FROM l_sql
   EXECUTE insert_l_n INTO l_n
   IF l_n = 0 THEN  
      CALL cl_err(g_inb[l_ac].inb44,'aqc-525',0)
      RETURN FALSE
   END IF    
   RETURN TRUE 
END FUNCTION

FUNCTION t370_inb05_check()
DEFINE l_n     LIKE type_file.num5,
       l_qcl05 LIKE qcl_file.qcl05,
       l_sql   STRING
   LET l_n = 0
   LET l_sql="SELECT COUNT(*) FROM qcl_file,imd_file",
             " WHERE qcl01='",g_inb[l_ac].inb46 CLIPPED,
             "' AND imd01 = '",g_inb[l_ac].inb05 CLIPPED,
             "' AND qcl03=imd11 AND qcl04=imd12"

   SELECT qcl05 INTO l_qcl05 FROM qcl_file
                  WHERE qcl01 = g_inb[l_ac].inb46

   IF l_qcl05 = '0' OR l_qcl05 = '1' THEN
      LET l_sql = l_sql CLIPPED," AND imd01 NOT IN(SELECT jce02 FROM jce_file)"
   END IF
   IF l_qcl05 = '2' THEN
      LET l_sql = l_sql CLIPPED," AND imd01 IN(SELECT jce02 FROM jce_file)"
   END IF

   PREPARE insert_l_n2 FROM l_sql
   EXECUTE insert_l_n2 INTO l_n

   IF l_n = 0 THEN
      RETURN FALSE
   END IF
RETURN TRUE
END FUNCTION

FUNCTION t370_qcl05_sel()
DEFINE l_qcl05  LIKE qcl_file.qcl05
   IF NOT cl_null(g_inb[l_ac].inb46) THEN 
      SELECT qcl05 
        INTO l_qcl05
        FROM qcl_file 
       WHERE qcl01 = g_inb[l_ac].inb46
      RETURN l_qcl05
   END IF 
   RETURN ''
END FUNCTION

FUNCTION t370_qco_show()
DEFINE l_qcl05    LIKE qcl_file.qcl05
DEFINE l_sum      LIKE qco_file.qco11
DEFINE l_sum1     LIKE qco_file.qco11
DEFINE l_inb1005  LIKE inb_file.inb1005
DEFINE l_inb902   LIKE inb_file.inb902
DEFINE l_inb904   LIKE inb_file.inb904
DEFINE l_inb905   LIKE inb_file.inb905
DEFINE l_inb907   LIKE inb_file.inb907
DEFINE l_qco20    LIKE qco_file.qco20

   IF NOT cl_null(g_inb[l_ac].inb44) AND NOT cl_null(g_inb[l_ac].inb45)
      AND NOT cl_null(g_inb[l_ac].inb46) AND NOT cl_null(g_inb[l_ac].inb47) AND NOT cl_null(g_inb[l_ac].inb48) THEN 
      SELECT qco06,qco07,qco08,qco09,qco10,qco13,qco15,qco16,qco18,qco20
        INTO g_inb[l_ac].inb04,g_inb[l_ac].inb05,g_inb[l_ac].inb06,
             g_inb[l_ac].inb07,g_inb[l_ac].inb08,l_inb902,l_inb904,l_inb905,l_inb907,l_qco20
        FROM qco_file
       WHERE qco01 = g_inb[l_ac].inb44
         AND qco02 = g_inb[l_ac].inb45
         AND qco05 = g_inb[l_ac].inb48
         AND qco04 = g_inb[l_ac].inb47
      DISPLAY BY NAME g_inb[l_ac].inb04,g_inb[l_ac].inb05,g_inb[l_ac].inb06,
                      g_inb[l_ac].inb07,g_inb[l_ac].inb08         
      #TQC-C20194-add-str--
      IF g_inb_t.inb04 <> g_inb[l_ac].inb04 OR cl_null(g_inb_t.inb04) OR g_inb_t.inb04 = '' THEN
         SELECT ima02,ima021
           INTO g_inb[l_ac].ima02,g_inb[l_ac].ima021
            FROM ima_file WHERE ima01=g_inb[l_ac].inb04 AND imaacti='Y'
         DISPLAY BY NAME g_inb[l_ac].ima02,g_inb[l_ac].ima021
      END IF 
      LET g_inb[l_ac].inb10 = 'Y' 
      DISPLAY BY NAME g_inb[l_ac].inb10
      #TQC-C20194-add-end--
      IF g_sma.sma115 = 'Y' THEN
         LET g_inb[l_ac].inb902 = l_inb902  #單位一賦值
         LET g_inb[l_ac].inb905 = l_inb905  #單位二賦值
         LET g_inb[l_ac].inb922 = g_inb[l_ac].inb902     #FUN-C20047
         LET g_inb[l_ac].inb925 = g_inb[l_ac].inb905     #FUN-C20047
         SELECT ima906 INTO g_ima906 FROM ima_file
          WHERE ima01 = g_inb[l_ac].inb04
         CAll t370_set_origin_field()
         SELECT img09 INTO g_img09 FROM img_file
          WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
            AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
         CALL s_du_umfchk(g_inb[l_ac].inb04,'','','',
                          g_img09,g_inb[l_ac].inb902,'1')
             RETURNING g_errno,g_factor
         LET g_inb[l_ac].inb903 = g_factor
         LET g_inb[l_ac].inb923 = g_factor       #FUN-C20047
        #DISPLAY BY NAME g_inb[l_ac].inb903      #FUN-C20047
         CALL s_du_umfchk(g_inb[l_ac].inb04,'','','',
                          g_inb[l_ac].inb08,g_inb[l_ac].inb905,g_ima906)
           RETURNING g_errno,g_factor
         LET g_inb[l_ac].inb906 = g_factor
         LET g_inb[l_ac].inb926 = g_factor       #FUN-C20047
        #DISPLAY BY NAME g_inb[l_ac].inb906      #FUn-C20047
      END IF
      CALL t370_qcl05_sel() RETURNING l_qcl05
      IF l_qcl05 = '0' OR l_qcl05 = '2' THEN 
         IF g_sma.sma115 = 'N' THEN    #FUN-C20047
            CALL t370_sum('') RETURNING l_sum 
            LET g_inb[l_ac].inb09 = l_sum   
            LET g_inb[l_ac].inb16 = g_inb[l_ac].inb09    #TQC-C20194
         #FUN-C20047-----Begin----
         ELSE 
            IF l_qco20 = 0 THEN 
               LET g_inb[l_ac].inb904 = l_inb904
               LET g_inb[l_ac].inb907 = l_inb907
               LET g_inb[l_ac].inb924 = l_inb904
               LET g_inb[l_ac].inb927 = l_inb907
            ELSE
               LET g_inb[l_ac].inb904 = 0
               LET g_inb[l_ac].inb907 = 0
               LET g_inb[l_ac].inb924 = 0
               LET g_inb[l_ac].inb927 = 0
            END IF
            CAll t370_set_origin_field()
            DISPLAY BY NAME g_inb[l_ac].inb904,g_inb[l_ac].inb907,g_inb[l_ac].inb924,g_inb[l_ac].inb927
         END IF
         #FUN-C20047-----End-----
      END IF 
      IF l_qcl05 = '1' THEN 
         LET g_inb[l_ac].inb09 = 0
         LET g_inb[l_ac].inb16 = g_inb[l_ac].inb09    #TQC-C20194
         #FUN-C20047--Begin-------
         LET g_inb[l_ac].inb904 = 0
         LET g_inb[l_ac].inb907 = 0
         LET g_inb[l_ac].inb924 = 0
         LET g_inb[l_ac].inb927 = 0
         #FUN-C20047--End---------
         LET b_inb.inb1004 = g_inb[l_ac].inb08
         CALL t370_sum('') RETURNING l_sum1 
         LET b_inb.inb1005 = l_sum1
         DISPLAY BY NAME g_inb[l_ac].inb09,g_inb[l_ac].inb904,g_inb[l_ac].inb907,             #FUN-C20047
                         g_inb[l_ac].inb924,g_inb[l_ac].inb927                                #FUN-C20047
      END IF
      IF l_qcl05 = '2' THEN 
         LET b_inb.inb1004 = g_inb[l_ac].inb08
         LET b_inb.inb1005 = 0
      END IF
   END IF 
END FUNCTION

FUNCTION t370_sum(p_cmd)
DEFINE l_sum   LIKE qco_file.qco11
DEFINE p_cmd   LIKE type_file.chr1
DEFINE l_qcl05 LIKE qcl_file.qcl05
DEFINE l_qco10 LIKE qco_file.qco10
DEFINE l_i     LIKE type_file.chr1
DEFINE l_fac   LIKE type_file.num5

   CALL t370_qcl05_sel() RETURNING l_qcl05                   #FUN-C20047
   SELECT qco11-qco20,qco10 INTO l_sum,l_qco10               #FUN-C20047 add qco10
     FROM qco_file
    WHERE qco01 = g_inb[l_ac].inb44
      AND qco02 = g_inb[l_ac].inb45
      AND qco05 = g_inb[l_ac].inb48
      AND qco04 = g_inb[l_ac].inb47
   IF cl_null(l_sum) THEN LET l_sum = 0 END IF                  #FUN-C20047
   IF (l_qcl05 = '0' OR l_qcl05 = '2') AND p_cmd = 'u' THEN       
      CALL s_umfchk(g_inb[l_ac].inb04,l_qco10,g_inb[l_ac].inb08)   #FUN-C20047
          RETURNING l_i,l_fac                                      #FUN-C20047
      IF l_i THEN LET l_fac=1 END IF                               #FUN-C20047
      LET l_sum = l_sum*l_fac                                      #FUN-C20047
      LET l_sum = l_sum + g_inb_t.inb09
   END IF   
   RETURN l_sum   
END FUNCTION
#FUN-BC0104----add----end----

#FUN-B50096 -------------Begin---------------
FUNCTION t370_set_entry_inb07()
#FUN-C20101----ADD---STR----
#FUN-C20101----ADD----END---   
   CALL cl_set_comp_entry("inb07",TRUE)
#FUN-C20101----ADD endif------   
END FUNCTION

FUNCTION t370_set_no_entry_inb07()
DEFINE l_ima159   LIKE ima_file.ima159
#FUN-C20101---ADD---STR----
#FUN-C20101-----ADD---END------   
   IF l_ac > 0 THEN
      IF NOT cl_null(g_inb[l_ac].inb04) THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_inb[l_ac].inb04
         IF l_ima159 = '2' THEN
            CALL cl_set_comp_entry("inb07",FALSE)
         ELSE
            CALL cl_set_comp_entry("inb07",TRUE)
         END IF
      END IF
   END IF
#FUN-C20101----ADD endif-----------   
END FUNCTION
#FUN-B50096 -------------End-----------------

 
FUNCTION t370_show()
   DEFINE socnt    LIKE type_file.num5      #轉訂單筆數 20200217

   SELECT inaconf,ina08 INTO g_ina.inaconf,g_ina.ina08         #FUN-C40016
     FROM ina_file                                             #FUN-C40016
    WHERE ina01 = g_ina.ina01                                  #FUN-C40016
   LET g_ina_t.* = g_ina.*                #保存單頭舊值
   LET g_data_keyvalue = g_ina.ina01      #FUN-F50014 add
   DISPLAY BY NAME g_ina.ina00  ,g_ina.ina01  ,g_ina.ina03  , g_ina.inaoriu,g_ina.inaorig,
                   g_ina.ina02  ,g_ina.ina11  ,g_ina.ina04  ,
                   g_ina.ina06  ,g_ina.ina07  ,g_ina.ina10  , g_ina.ina103,    #No.FUN-9A0068 add ina103
                   g_ina.ina12  ,g_ina.inaplant ,g_ina.ina13 ,    #FUN-870100#FUN-A50071 add ina13
                   g_ina.inaconf,g_ina.inacond,g_ina.inaconu,g_ina.inacont,g_ina.inaspc ,g_ina.inapost,   #FUN-870100  
                   g_ina.inamksg,g_ina.inapos,g_ina.ina08  ,g_ina.inauser,     #FUN-870100
                   g_ina.inagrup,g_ina.inamodu,g_ina.inadate,
                   g_ina.inaud01,g_ina.inaud02,g_ina.inaud03,g_ina.inaud04,
                   g_ina.inaud05,g_ina.inaud06,g_ina.inaud07,g_ina.inaud08,
                   g_ina.inaud09,g_ina.inaud10,g_ina.inaud11,g_ina.inaud12,
                   g_ina.inaud13,g_ina.inaud14,g_ina.inaud15 
 
   SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_ina.ina04
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   DISPLAY g_buf TO gem02 LET g_buf = NULL
 
   LET g_buf = s_get_doc_no(g_ina.ina01) #No.FUN-550029
   SELECT smydesc INTO g_buf FROM smy_file WHERE smyslip=g_buf
   DISPLAY g_buf TO smydesc LET g_buf = NULL

   ##----- 20200217 add by momo (S)
   SELECT COUNT(*) INTO socnt FROM inb_file
    WHERE inb01 = g_ina.ina01
      AND inb04 LIKE '0%'
   DISPLAY socnt TO FORMONLY.socnt
   ##----- 20200217 add by momo (E)

   ##----- 20210506 add by momo (S)
   SELECT pja02 INTO g_buf FROM pja_file WHERE pja01=g_ina.ina06
   DISPLAY g_buf TO pja02 LET g_buf = NULL
   ##----- 20210506 add by momo (E)

   CALL t370_pic() #FUN-720002
   CALL t370_ina11('d')                      #FUN-630046
   CALL t370_inaconu('d')                    #FUN-870100
   CALL t370_inaplant('d')                   #FUN-870100
#FUN-C20101----ADD----STR----
#FUN-C20101----ADD----END----   
   CALL t370_b_fill(g_wc2)
#FUN-C20101---ADD endif------------   
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t370_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
    DEFINE l_i,l_cnt    LIKE type_file.num5,   #FUN-810045
           l_pja26      LIKE pja_file.pja26,   #FUN-810045
           l_act        LIKE type_file.chr1    #FUN-810045
    DEFINE l_flag       LIKE type_file.chr1    #No.FUN-830056
    #FUN-BC0104-add-str--
    DEFINE l_inb03  LIKE inb_file.inb03
    DEFINE l_inb44  LIKE inb_file.inb44
    DEFINE l_inb45  LIKE inb_file.inb45
    DEFINE l_inb46  LIKE inb_file.inb46
    DEFINE l_inb47  LIKE inb_file.inb47
    DEFINE l_inb48  LIKE inb_file.inb48
    DEFINE l_flagg  LIKE type_file.chr1
    DEFINE l_qcl05  LIKE qcl_file.qcl05
    DEFINE l_type1  LIKE type_file.chr1
    DEFINE l_cn     LIKE  type_file.num5
    DEFINE l_c      LIKE  type_file.num5
    DEFINE l_inb_a  DYNAMIC ARRAY OF RECORD
           inb44    LIKE  inb_file.inb44,
           inb45    LIKE  inb_file.inb45,
           inb48    LIKE  inb_file.inb48,
           inb46    LIKE  inb_file.inb46,
           inb47    LIKE  inb_file.inb47,
           flagg    LIKE  type_file.chr1
                    END RECORD
    #FUN-BC0104-add-end--
 
    IF s_shut(0) THEN RETURN END IF     #No.MOD-840157 del FALSE
    IF g_ina.ina01 IS NULL THEN CALL cl_err('',-400,0) RETURN  END IF    #No.MOD-840157 del FALSE
    SELECT * INTO g_ina.* FROM ina_file WHERE ina01=g_ina.ina01 
    IF g_ina.inaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660079
    IF g_ina.inaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #FUN-660079
    IF g_ina.ina08 matches '[Ss1]' THEN          #FUN-550047
         CALL cl_err('','mfg3557',0)
         RETURN         #No.MOD-840157 del FALSE
    END IF
 
    BEGIN WORK
 
    OPEN t370_cl USING g_ina.ina01
    IF STATUS THEN
       CALL cl_err("OPEN t370_cl:", STATUS, 1)
       CLOSE t370_cl
       ROLLBACK WORK
       RETURN           #No.MOD-840157 del FALSE
    END IF
    FETCH t370_cl INTO g_ina.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)
       CLOSE t370_cl
       ROLLBACK WORK
       RETURN              #No.MOD-840157 del FALSE
    END IF
    CALL t370_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ina01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ina.ina01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete ina,inb!"
 
        DELETE FROM ina_file WHERE ina01 = g_ina.ina01 
        IF SQLCA.SQLERRD[3]=0
           THEN # CALL cl_err('No ina deleted',SQLCA.SQLCODE,0) #No.FUN-660156
                  CALL cl_err3("del","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"",
                               "No ina deleted",1)  #No.FUN-660156
                ROLLBACK WORK RETURN     #No.MOD-840157 del FALSE
        END IF
        #FUN-BC0104-add-str--
        LET l_cn =1
        DECLARE upd_qco20 CURSOR FOR
         SELECT inb03 FROM inb_file WHERE inb01 = g_ina.ina01
        FOREACH upd_qco20 INTO l_inb03
           CALL s_iqctype_inb(g_ina.ina01,l_inb03) RETURNING l_inb44,l_inb45,l_inb46,l_inb48,l_inb47,l_flagg
           LET l_inb_a[l_cn].inb44 = l_inb44
           LET l_inb_a[l_cn].inb45 = l_inb45
           LET l_inb_a[l_cn].inb46 = l_inb46
           LET l_inb_a[l_cn].inb48 = l_inb48
           LET l_inb_a[l_cn].inb47 = l_inb47
           LET l_inb_a[l_cn].flagg = l_flagg
           LET l_cn = l_cn + 1
        END FOREACH
       #MOD-FC0120--add--strat--
        SELECT COUNT(*) INTO g_cnt FROM rmd_file WHERE rmd21 = g_ina.ina01
        IF g_cnt > 0 THEN
           UPDATE rmd_file SET rmd21 = NULL WHERE rmd21 = g_ina.ina01
           IF SQLCA.sqlcode THEN
              ROLLBACK WORK
              RETURN
           END IF 
        END IF 
       #MOD-FC0120--add--end----
#FUN-C20101-----ADD------BEGIN------
#FUN-C20101-----ADD------END--------        
        #FUN-BC0104-add-end--
        DELETE FROM inb_file WHERE inb01 = g_ina.ina01
        #FUN-BC0104-add-str--

#FUN-C20101----ADD  ENDIF---------        
        FOR l_c=1 TO l_cn-1
           IF l_inb_a[l_c].flagg = 'Y' THEN
              CALL s_qcl05_sel(l_inb_a[l_c].inb46) RETURNING l_qcl05
              IF l_qcl05='1' THEN LET l_type1='6' ELSE LET l_type1='4' END IF
              IF NOT s_iqctype_upd_qco20(l_inb_a[l_c].inb44,l_inb_a[l_c].inb45,l_inb_a[l_c].inb48,l_inb_a[l_c].inb47,l_type1) THEN
                 ROLLBACK WORK     
                 RETURN
              END IF
           END IF
        END FOR
        #FUN-BC0104-add-end--
        #LET g_msg=TIME  #FUN-DA0126
        #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980004 add azoplant,azolegal  #FUN-DA0126
        #   VALUES ('aimt370',g_user,g_today,g_msg,g_ina.ina01,'delete',g_plant,g_legal) #FUN-980004 add g_plant,g_legal  #FUN-DA0126
        FOR l_i = 1 TO g_rec_b
            CASE
              WHEN g_ina.ina00 MATCHES '[1256]'  #出庫
                LET l_act = "1"
              WHEN g_ina.ina00 MATCHES '[34]'    #入庫 #MOD-960086
                LET l_act = "2"
            END CASE
           #IF NOT s_del_rvbs(l_act,g_ina.ina01,g_inb[l_i].inb03,0)  THEN    #FUN-880129   #TQC-B90236 mark
            IF NOT s_lot_del(g_prog,g_ina.ina01,'',0,g_inb[l_i].inb04,'DEL') THEN    #FUN-880129   #TQC-B90236 add
              ROLLBACK WORK
              RETURN        #No.MOD-840157 del FALSE
            END IF
        END FOR
    END IF

   #FUN-B10016 add str -------
   #若有與CRM整合,需回饋CRM單據狀態,表CRM可再重發雜收/發單
    IF NOT cl_null(g_ina.ina10) AND g_ina.ina05 = 'Y' AND g_aza.aza123 MATCHES "[Yy]" THEN
       CALL aws_crmcli('x','restatus','1',g_ina.ina01,'1') RETURNING g_crmStatus,g_crmDesc
       IF g_crmStatus <> 0 THEN
          CALL cl_err(g_crmDesc,'!',1)
          ROLLBACK WORK
          RETURN
       END IF
    END IF
   #FUN-B10016 add end -------

    CLOSE t370_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ina.ina01,'D')
    CALL t370_aft_del()
END FUNCTION
 
FUNCTION t370_b_bef_ins()
DEFINE l_ina01 LIKE ina_file.ina01   #FUN-B30053
DEFINE l_smy57 LIKE smy_file.smy57   #FUN-B30053
   INITIALIZE g_inb[l_ac].* TO NULL      #900423
   INITIALIZE arr_detail[l_ac].* TO NULL   #No.TQC-650115
   INITIALIZE g_inb_t.* TO NULL
   LET b_inb.inb01=g_ina.ina01
   LET g_inb03_o = NULL    #MOD-FA0119 add
  #LET g_inb[l_ac].inb10 = 'N'     #No.FUN-5C0077   #FUN-B30053
   LET g_inb[l_ac].inb08_fac=1
   LET g_yes='N'
   LET g_change = 'Y'
   LET g_inb[l_ac].inb930=s_costcenter(g_ina.ina04) #FUN-670093
   LET g_inb[l_ac].gem02c=s_costcenter_desc(g_inb[l_ac].inb930) #FUN-670093
   LET g_inb[l_ac].inb41 = g_ina.ina06    #FUN-810045 add
   CALL cl_show_fld_cont()     #FUN-550037(smin)
   #FUN-B30053-add-str--
   LET l_ina01 = s_get_doc_no(g_ina.ina01)
   SELECT smy57 INTO l_smy57
    FROM  smy_file WHERE smyslip = l_ina01 AND smyacti = 'Y'
   IF cl_null(l_smy57[2,2]) THEN 
      LET l_smy57[2,2] = 'N'
   END IF
   LET g_inb[l_ac].inb10 = l_smy57[2,2]
   #FUN-B30053-add-end--
END FUNCTION
 
FUNCTION t370_b_inschk()
DEFINE l_qcl05   LIKE qcl_file.qcl05              #FUN-C20047
   IF g_sma.sma115 = 'Y' THEN
      CALL s_chk_va_setting(g_inb[l_ac].inb04)
           RETURNING g_flag,g_ima906,g_ima907
      IF g_flag=1 THEN
         RETURN "inb04"
      END IF
 
      CALL t370_du_data_to_correct()
      CALL t370_du_data_to_correct2()  #FUN-870040
   END IF
   CALL t370_set_img09() #FUN-720002
  #IF cl_null(g_img09) AND (g_ina.ina00!='3' AND g_ina.ina00!='4')THEN  #TQC-640162                               #FUN-DA0106 mark
   IF cl_null(g_img09) AND (g_ina.ina00!='1' AND g_ina.ina00!='2' AND g_ina.ina00!='3' AND g_ina.ina00!='4') THEN #FUN-DA0106 add
     ##FUN-C80107 modify begin----------------------------------------------121024
     #CALL cl_err(g_inb[l_ac].inb04,'mfg6069',0)
     # LET g_errno = 'mfg6069'                   #FUN-B10016 add
     # RETURN "inb04"
      LET l_flag01 = NULL
   #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING l_flag01   #FUN-D30024
      CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING l_flag01 #FUN-D30024 #TQC-D40078 g_plant
      IF l_flag01 = 'N' OR l_flag01 IS NULL THEN
         LET g_errno = 'mfg6069'
         CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)
         RETURN "inb04"
      ELSE
         IF g_sma.sma892[3,3] = 'Y' THEN
            IF g_bgjob='N' OR cl_null(g_bgjob) THEN
               IF NOT cl_confirm('mfg1401') THEN
                  LET g_errno = 'mfg6069'
                  CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)
                  RETURN "inb04"
               END IF
            END IF
         END IF
         CALL s_add_img(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                        g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                        g_ina.ina01,g_inb[l_ac].inb03,g_ina.ina02)
         IF g_errno='N' THEN
            RETURN "inb04"
         END IF
      END IF
     #FUN-C80107 modify end------------------------------------------------
   END IF
 
   IF g_sma.sma115 = 'Y' THEN
      IF t370_qty_issue() THEN
         IF g_ima906 MATCHES '[23]' THEN
            RETURN "inb907"
         ELSE
            RETURN "inb904"
         END IF
      END IF
      CALL t370_set_origin_field()
   END IF
 
   #FUN-C20047--Begin--
   CALL t370_qcl05_sel() RETURNING l_qcl05
   IF l_qcl05 != '1' AND NOT cl_null(l_qcl05) THEN
   #FUN-C20047--End----
      IF g_inb[l_ac].inb09=0 THEN
         CALL cl_err("","aim-120",1)
         LET g_errno = 'aim-120'                    #FUN-B10016 add
         RETURN "inb05" #因為inb09有可能是隱藏狀態,所以移到inb05
      END IF
   END IF           #FUN-C20047
 
   IF NOT cl_null(g_inb[l_ac].inb911) THEN
      LET g_errno=NULL
      CALL t370_inb911()
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_inb[l_ac].inb911,g_errno,0)
         CALL g_inb.deleteElement(l_ac)
         RETURN "errno"
      END IF
      IF NOT cl_null(g_inb[l_ac].inb912) THEN
         CALL t370_inb912()
         IF NOT cl_null(g_errno) THEN
            LET g_msg = g_inb[l_ac].inb911 CLIPPED,'+',
                        g_inb[l_ac].inb912 USING '<<<<<'
            CALL cl_err(g_msg,g_errno,1)
            CALL g_inb.deleteElement(l_ac)
            RETURN "errno"
         END IF
      END IF
   END IF
   RETURN NULL
END FUNCTION
 
FUNCTION t370_b_ins()
   LET b_inb.inb16 = g_inb[l_ac].inb09   #No.FUN-870163
   LET b_inb.inblegal = g_legal   #MOD-A50144 add
   LET b_inb.inbplant = g_plant   #FUN-A60028
   #No.MOD-C70128  --Begin
#  LET b_inb.inb13 = 0    #FUN-BC0062 mark
# #FUN-BC0062 ------Begin------
   LET b_inb.inb13 = g_inb[l_ac].inb13 
   IF cl_null(b_inb.inb13) THEN LET b_inb.inb13 = 0 END IF 
   LET b_inb.inb14 = g_inb[l_ac].inb14
# #FUN-BC0062 ------End--------
   LET b_inb.inb132 = 0
   LET b_inb.inb133 = 0
   LET b_inb.inb134 = 0
   LET b_inb.inb135 = 0
   LET b_inb.inb136 = 0
   LET b_inb.inb137 = 0
   LET b_inb.inb138 = 0
   #No.MOD-C70128  --End
   INSERT INTO inb_file VALUES(b_inb.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","inb_file","","",SQLCA.sqlcode,"",
                   "ins inb",1)  #No.FUN-660156
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_bef_inb03()
   IF g_inb[l_ac].inb03 IS NULL OR g_inb[l_ac].inb03 = 0 THEN
      SELECT max(inb03)+1 INTO g_inb[l_ac].inb03
        FROM inb_file WHERE inb01 = g_ina.ina01 
      IF g_inb[l_ac].inb03 IS NULL THEN
         LET g_inb[l_ac].inb03 = 1
         LET g_inb03_o = 1    #MOD-FA0119 add
      END IF
   END IF
END FUNCTION
 
FUNCTION t370_chk_inb03()
   IF NOT cl_null(g_inb[l_ac].inb03) THEN
      IF g_inb[l_ac].inb03 != g_inb_t.inb03 OR
         g_inb_t.inb03 IS NULL THEN
         LET g_cnt=0
         SELECT count(*) INTO g_cnt FROM inb_file
          WHERE inb01 = g_ina.ina01 AND inb03 = g_inb[l_ac].inb03 
         IF g_cnt > 0 THEN
            LET g_inb[l_ac].inb03 = g_inb_t.inb03
            LET g_errno = '-239'                   #FUN-B10016 add
            CALL cl_err('',-239,0)
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_inb911()
   IF NOT cl_null(g_inb[l_ac].inb911) THEN
      CALL t370_inb911()
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_inb[l_ac].inb911,g_errno,0)
         RETURN FALSE
      END IF
   ELSE
      LET g_inb[l_ac].inb912 = NULL
      DISPLAY BY NAME g_inb[l_ac].inb912
   END IF
   CALL t370_set_no_entry_b()
   CALL t370_set_required()
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_inb912()
   IF NOT cl_null(g_inb[l_ac].inb911) AND
      NOT cl_null(g_inb[l_ac].inb912) THEN
      CALL t370_inb912()
      IF NOT cl_null(g_errno) THEN
         LET g_msg = g_inb[l_ac].inb911 CLIPPED,'+',
                     g_inb[l_ac].inb912 USING '<<<<<'
         CALL cl_err(g_msg,g_errno,0)
         RETURN FALSE
      END IF
      #by 單號項次 chk oeb04是否建bom，若沒有，show msg
      CALL t370_chk_oeb04(g_inb[l_ac].inb911,g_inb[l_ac].inb912)
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_inb04_1()
   DEFINE l_imaag         LIKE ima_file.imaag     #No.FUN-640056
 
   #AFTER FIELD 處理邏輯修改為使用下面的函數來進行判斷，請參考相關代碼
   IF NOT t370_check_inb04('inb04',l_ac) THEN
      RETURN FALSE
   END IF
 
   IF cl_null(g_inb[l_ac].inb04) THEN
       LET g_errno = 'aap-099'                   #FUN-B10016 add
       CALL cl_err('','aap-099',0)
       RETURN FALSE
   END IF
 
   SELECT imaag INTO l_imaag FROM ima_file
    WHERE ima01 =g_inb[l_ac].inb04
   IF NOT CL_null(l_imaag) AND l_imaag <> '@CHILD' THEN #FUN-640245
      LET g_errno = 'aim1004'                   #FUN-B10016 add
      CALL cl_err(g_inb[l_ac].inb04,'aim1004',0)
      RETURN FALSE
   END IF
 
   #FUN-6A0007...............begin 判斷是否為訂單-項次 料件bom之元件
   CALL t370_chk_inb04(g_inb[l_ac].inb911,g_inb[l_ac].inb912,
                       g_inb[l_ac].inb04)
 
   RETURN TRUE
 
END FUNCTION
 
FUNCTION t370_bef_att00()
   #根據子料件找到母料件及各個屬性
   SELECT imx00,imx01,imx02,imx03,imx04,imx05,
          imx06,imx07,imx08,imx09,imx10
   INTO g_inb[l_ac].att00, g_inb[l_ac].att01, g_inb[l_ac].att02,
        g_inb[l_ac].att03, g_inb[l_ac].att04, g_inb[l_ac].att05,
        g_inb[l_ac].att06, g_inb[l_ac].att07, g_inb[l_ac].att08,
        g_inb[l_ac].att09, g_inb[l_ac].att10
   FROM imx_file
   WHERE imx000 = g_inb[l_ac].inb04
 
   LET g_inb04 = g_inb[l_ac].att00
   LET g_chr4  = '1'
 
   #賦值所有屬性
   LET g_inb[l_ac].att01_c = g_inb[l_ac].att01
   LET g_inb[l_ac].att02_c = g_inb[l_ac].att02
   LET g_inb[l_ac].att03_c = g_inb[l_ac].att03
   LET g_inb[l_ac].att04_c = g_inb[l_ac].att04
   LET g_inb[l_ac].att05_c = g_inb[l_ac].att05
   LET g_inb[l_ac].att06_c = g_inb[l_ac].att06
   LET g_inb[l_ac].att07_c = g_inb[l_ac].att07
   LET g_inb[l_ac].att08_c = g_inb[l_ac].att08
   LET g_inb[l_ac].att09_c = g_inb[l_ac].att09
   LET g_inb[l_ac].att10_c = g_inb[l_ac].att10
   #顯示所有屬性
   DISPLAY BY NAME g_inb[l_ac].att00
   DISPLAY BY NAME
       g_inb[l_ac].att01, g_inb[l_ac].att01_c,
       g_inb[l_ac].att02, g_inb[l_ac].att02_c,
       g_inb[l_ac].att03, g_inb[l_ac].att03_c,
       g_inb[l_ac].att04, g_inb[l_ac].att04_c,
       g_inb[l_ac].att05, g_inb[l_ac].att05_c,
       g_inb[l_ac].att06, g_inb[l_ac].att06_c,
       g_inb[l_ac].att07, g_inb[l_ac].att07_c,
       g_inb[l_ac].att08, g_inb[l_ac].att08_c,
       g_inb[l_ac].att09, g_inb[l_ac].att09_c,
       g_inb[l_ac].att10, g_inb[l_ac].att10_c
   LET g_chr3  = '1'
END FUNCTION
 
FUNCTION t370_chk_att00()
   #檢查att00里面輸入的母料件是否是符合對應屬性組的母料件
   LET g_cnt=0
   SELECT COUNT(ima01) INTO g_cnt FROM ima_file
     WHERE ima01 = g_inb[l_ac].att00 AND imaag = lg_smy62
   IF g_cnt = 0 THEN
      CALL cl_err_msg('','aim-909',lg_smy62,0)
      RETURN FALSE
   END IF
 
   LET g_inb04 = g_inb[l_ac].att00
 
   #如果設置為不允許新增
   IF NOT t370_check_inb04('imx00',l_ac) THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_inb05()
DEFINE  l_inaplant   LIKE ina_file.inaplant   #FUN-9C0075-add--
   #FUN-C20002--start add-------------------------------------------
   DEFINE l_ima154      LIKE ima_file.ima154
   DEFINE l_rcj03       LIKE rcj_file.rcj03
   DEFINE l_rtz07       LIKE rtz_file.rtz07
   DEFINE l_rtz08       LIKE rtz_file.rtz08
   #FUN-C20002--end add---------------------------------------------
   DEFINE p_cmd      LIKE type_file.chr1    #TQC-C30205

   IF NOT cl_null(g_inb[l_ac].inb05) THEN
      #FUN-C20002--start add-----------------------------------
      IF g_azw.azw04 = '2' THEN
         #FUN-D70125 mark start
        #SELECT ima154 INTO l_ima154
        #  FROM ima_file
        # WHERE ima01 = g_inb[l_ac].inb04

        #IF l_ima154 = 'Y' AND g_inb[l_ac].inb04[1,4] <> 'MISC' THEN
        #   SELECT rcj03 INTO l_rcj03
        #     FROM rcj_file
        #    WHERE rcj00 = '0'

        #   #FUN-C90049 mark begin---
        #   #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
        #   #  FROM rtz_file
        #   # WHERE rtz01 = g_plant
        #   #FUN-C90049 mark end-----

        #  CALL s_get_defstore(g_plant,g_inb[l_ac].inb04) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add

        #   IF l_rcj03 = '1' THEN
        #      IF g_inb[l_ac].inb05 <> l_rtz07 THEN
        #         CALL cl_err('','aim1142',0)
        #         LET g_inb[l_ac].inb05 = g_inb_t.inb05
        #         RETURN "inb05"
        #      END IF
        #   ELSE
        #      IF g_inb[l_ac].inb05 <> l_rtz08 THEN
        #         CALL cl_err('','aim1143',0)
        #         LET g_inb[l_ac].inb05 = g_inb_t.inb05
        #         RETURN "inb05"
        #      END IF
        #   END IF
        #END IF
         #FUN-D70125 mark end
         #FUN-D70125 add start
          CALL s_chk_store(g_plant,g_inb[l_ac].inb04,g_inb[l_ac].inb05) RETURNING g_errno
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,0)
             LET g_inb[l_ac].inb05 = g_inb_t.inb05
             RETURN "inb05"
          END IF　
         #FUN-D70125 add end
      END IF
      #FUN-C20002--end add-------------------------------------
      #FUN-D20060----add---str--
      IF NOT s_chksmz(g_inb[l_ac].inb04, g_ina.ina01,
                      g_inb[l_ac].inb05, g_inb[l_ac].inb06) THEN
         RETURN "inb05"
      END IF
      #FUN-D20060----add---end--
       #No.FUN-AA0049--begin
       IF NOT s_chk_ware(g_inb[l_ac].inb05) THEN
          RETURN "inb05"
       END IF
       #No.FUN-AA0049--end
      IF g_inb_t.inb07 IS NULL OR g_inb_t.inb07 <> g_inb[l_ac].inb07 THEN
         LET g_change='Y'
      END IF
      SELECT imd02 INTO g_buf FROM imd_file
       WHERE imd01=g_inb[l_ac].inb05 AND imd10=g_imd10
          AND imdacti = 'Y' #MOD-4B0169
      IF STATUS THEN
         LET g_errno = 'mfg1100'                   #FUN-B10016 add
         CALL cl_err3("sel","imd_file",g_inb[l_ac].inb05,g_imd10,"mfg1100","",
                      "imd",1)  #No.FUN-660156
         RETURN "inb05"    #No.TQC-750015 modify
      END IF
      #No.FUN-AA0049--begin
      #SELECT imd20 INTO l_inaplant FROM imd_file
      # WHERE imd01=g_inb[l_ac].inb05
      #IF l_inaplant <> g_ina.inaplant THEN
      #  CALL cl_err(g_inb[l_ac].inb05,"art-426",1)
      #   RETURN "inb05"
      #END IF
      #No.FUN-AA0049--end
     # No.TQC-AC0122--begin
      SELECT imd20 INTO l_inaplant FROM imd_file
       WHERE imd01=g_inb[l_ac].inb05
      IF l_inaplant <> g_ina.inaplant THEN
         LET g_errno = 'art-426'                   #FUN-B10016 add
         CALL cl_err(g_inb[l_ac].inb05,"art-426",1)
         RETURN "inb05"
      END IF
     #No.TQC-AC0122--end
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM img_file
       WHERE img01=g_inb[l_ac].inb04
         AND img02=g_inb[l_ac].inb05
     #IF g_cnt = 0 AND (g_ina.ina00!='3' AND g_ina.ina00!='4')THEN  #TQC-640162                               #FUN-DA0106 mark
      IF g_cnt = 0 AND (g_ina.ina00!='1' AND g_ina.ina00!='2' AND g_ina.ina00!='3' AND g_ina.ina00!='4')THEN  #FUN-DA0106 add
        #FUN-C80107 modify begin----------------------------------------------121024
        #LET g_errno = 'mfg6069'                   #FUN-B10016 add
        #CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)
        #RETURN "inb05"     #No.TQC-750015 modify
         LET l_flag01 = NULL
      #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING l_flag01   #FUN-D30024
         CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING l_flag01 #FUN-D30024 #TQC-D40078 g_plant
         IF l_flag01 = 'N' OR l_flag01 IS NULL THEN
            LET g_errno = 'mfg6069'
            CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)
            RETURN "inb05"
         ELSE
            IF g_sma.sma892[3,3] = 'Y' THEN
               IF g_bgjob='N' OR cl_null(g_bgjob) THEN
                  IF NOT cl_confirm('mfg1401') THEN
                     LET g_errno = 'mfg6069'
                     CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)
                     RETURN "inb05"
                  END IF
               END IF
            END IF
            CALL s_add_img(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                           g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                           g_ina.ina01,g_inb[l_ac].inb03,g_ina.ina02)
            IF g_errno='N' THEN
               RETURN "inb05"
            END IF
         END IF
        #FUN-C80107 modify end------------------------------------------------
      END IF
#TQC-C30205---add---str---
      IF NOT cl_null(g_inb[l_ac].inb46) THEN
         IF NOT t370_inb05_check() THEN
            CALL cl_err('','aqc-524',0)
            RETURN "inb05"
         END IF
      END IF
#TQC-C30205---add---end---
   END IF
   RETURN "inb06"    #No.TQC-750015 modify
END FUNCTION

FUNCTION t370_chk_inb06()
   DEFINE l_ima159  LIKE ima_file.ima159   #TQC-C30205
   DEFINE p_cmd LIKE type_file.chr1        #TQC-C30205

   IF NOT cl_null(g_inb[l_ac].inb06) THEN  #TQC-C60033
      LET g_errno = ' '              #FUN-B10016 add

      #BugNo:5626 控管是否為全型空白
      IF g_inb[l_ac].inb06 ='　' THEN #全型空白
          LET g_inb[l_ac].inb06 =' '
      END IF
      IF g_inb[l_ac].inb06 IS NULL THEN LET g_inb[l_ac].inb06 =' ' END IF
      IF g_inb_t.inb06 IS NULL OR g_inb_t.inb06 <> g_inb[l_ac].inb06 THEN
         LET g_change='Y'
      END IF
      #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
      IF NOT cl_null(g_inb[l_ac].inb05) THEN  #FUN-D20060 add
         IF NOT s_chksmz(g_inb[l_ac].inb04, g_ina.ina01,
                         g_inb[l_ac].inb05, g_inb[l_ac].inb06) THEN
            RETURN "inb05"
         END IF
      END IF   #FUN-D20060 add
      #MOD-640485-begin #確認料+倉+儲存在於img_file
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM img_file
       WHERE img01=g_inb[l_ac].inb04
         AND img02=g_inb[l_ac].inb05
         AND img03=g_inb[l_ac].inb06
     #IF g_cnt = 0 AND (g_ina.ina00!='3' AND g_ina.ina00!='4')THEN  #TQC-640162                              #FUN-DA0106 mark
      IF g_cnt = 0 AND (g_ina.ina00!='1' AND g_ina.ina00!='2' AND g_ina.ina00!='3' AND g_ina.ina00!='4')THEN #FUN-DA0106 add
        ##FUN-C80107 modify begin--------------------------------------------121024
        #LET g_errno = 'mfg6069'                                    #FUN-B10016 add
        #CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)
        #RETURN "inb06"
         LET l_flag01 = NULL
      #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING l_flag01   #FUN-D30024
         CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING l_flag01 #FUN-D30024 #TQC-D40078 g_plant
         IF l_flag01 = 'N' OR l_flag01 IS NULL THEN
            LET g_errno = 'mfg6069'
            CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)
            RETURN "inb06"
         ELSE
            IF g_sma.sma892[3,3] = 'Y' THEN
               IF g_bgjob='N' OR cl_null(g_bgjob) THEN
                  IF NOT cl_confirm('mfg1401') THEN
                     LET g_errno = 'mfg6069'
                     CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)
                     RETURN "inb06"
                  END IF
               END IF
            END IF
            CALL s_add_img(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                           g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                           g_ina.ina01,g_inb[l_ac].inb03,g_ina.ina02)
            IF g_errno='N' THEN
               RETURN "inb06"
            END IF
         END IF
        #FUN-C80107 modify end------------------------------------------------
      END IF
   #TQC-C30205--------------------------------STRART--
      IF NOT cl_null(g_inb[l_ac].inb04) THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_inb[l_ac].inb04
         IF l_ima159 = '2' THEN
            CASE t370_chk_inb07(p_cmd)
               WHEN "inb04"
                  IF NOT cl_null(g_inb[l_ac].inb46) THEN
                     RETURN "inb06"
                  ELSE
                     RETURN "inb04"
                  END IF
               WHEN "inb06" RETURN "inb06"
               WHEN "inb07" RETURN "inb06"
            END CASE
         END IF
      END IF

#TQC-C30205----------------------------------END---
   ELSE   #TQC-C60033
      IF g_inb[l_ac].inb06 IS NULL THEN LET g_inb[l_ac].inb06 =' ' END IF  #TQC-C60033
   END IF  #TQC-C60033
  #RETURN "inb07"     #No.TQC-750015  #MOD-C90167 mark
   RETURN " "     #MOD-C90167
END FUNCTION

FUNCTION t370_chk_inb07(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1

   #BugNo:5626 控管是否為全型空白
   IF g_inb[l_ac].inb07 ='　' THEN #全型空白
       LET g_inb[l_ac].inb07 =' '
   END IF
   IF g_inb[l_ac].inb07 IS NULL THEN LET g_inb[l_ac].inb07 =' ' END IF
   IF g_inb_t.inb07 IS NULL OR g_inb_t.inb07 <> g_inb[l_ac].inb07 THEN
      LET g_change='Y'
   END IF
      #TQC-C60033---begin
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM img_file
       WHERE img01=g_inb[l_ac].inb04
         AND img02=g_inb[l_ac].inb05
         AND img03=g_inb[l_ac].inb06
         AND img04=g_inb[l_ac].inb07
     #IF g_cnt = 0 AND (g_ina.ina00!='3' AND g_ina.ina00!='4')THEN  #TQC-640162                               #FUN-DA0106 mark
      IF g_cnt = 0 AND (g_ina.ina00!='1' AND g_ina.ina00!='2' AND g_ina.ina00!='3' AND g_ina.ina00!='4')THEN  #FUN-DA0106 add
         CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING l_flag01   #TQC-D70092 add
         IF l_flag01 = 'N' OR l_flag01 IS NULL THEN   #TQC-D70092 add
            LET g_errno = 'mfg6069'                                    #FUN-B10016 add
            CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)
            RETURN "inb05"
         END IF     #TQC-D70092 add
      END IF
      #TQC-C60033---end
   IF NOT cl_null(g_inb[l_ac].inb04) AND NOT cl_null(g_inb[l_ac].inb05) THEN
      CALL t370_set_img09() #FUN-720002
   #  IF (g_ina.ina00 MATCHES '[1256]' AND SQLCA.sqlcode!=0) OR                 #TQC-D70092 mark
   #     (g_ina.ina00 MATCHES '[34]'   AND STATUS AND SQLCA.sqlcode!= 100) THEN #TQC-D70092 mark
      IF (g_ina.ina00 MATCHES '[1234]' AND STATUS AND SQLCA.sqlcode!= 100) THEN   #TQC-D70092 add #DA0106 add 12
         CALL cl_err('sel img:',STATUS,0)
         LET g_errno = STATUS                          #FUN-B10016 add
         #RETURN "inb06"  #TQC-C60033
         RETURN "inb05"   #TQC-C60033
      END IF
   #TQC-D70092 ----------Begin----------
      IF g_ina.ina00 MATCHES '[56]' AND SQLCA.sqlcode!=0 THEN                  #DA0106  扣除 12
         IF SQLCA.sqlcode = 100 THEN
            CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING l_flag01
            IF l_flag01 = 'N' OR l_flag01 IS NULL THEN
               CALL cl_err('sel img:',STATUS,0)
               RETURN "inb05"
            END IF
         ELSE
            CALL cl_err('sel img:',STATUS,0)
            RETURN "inb05"
         END IF
      END IF
   #TQC-D70092 ----------End------------

      IF (g_ina.ina00 MATCHES '[34]' AND SQLCA.sqlcode=100) THEN
         IF g_sma.sma892[3,3] = 'Y' THEN
             IF g_bgjob='N' OR cl_null(g_bgjob) THEN   #FUN-B10016 add
               IF NOT cl_confirm('mfg1401') THEN
                 RETURN "inb04"
               END IF
             END IF                                    #FUN-B10016 add
         END IF
         CALL s_add_img(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                        g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                        g_ina.ina01,g_inb[l_ac].inb03,g_ina.ina02)
         IF g_errno='N' THEN
            RETURN "inb04"
         END IF
         LET g_img09 = ''   LET g_img10 = 0   #MOD-A40089 add
         SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
          WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
            AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
      END IF

      IF p_cmd ='u' THEN
         IF g_inb[l_ac].inb08=g_img09 THEN
            LET g_inb[l_ac].inb08_fac =  1
         ELSE
            IF cl_null(g_inb[l_ac].inb08) THEN LET g_inb[l_ac].inb08=g_img09 END IF #20200313
            IF NOT cl_null(g_img09) THEN    #TQC-D70092
               CALL s_umfchk(g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09)
                     RETURNING g_cnt,g_inb[l_ac].inb08_fac
               IF g_cnt = 1 THEN
                  CALL cl_err('','mfg3075',0)
                  LET g_errno = 'mfg3075'                #FUN-B10016 add
                  #RETURN "inb07"  #TQC-C60033
                  RETURN "inb05"   #TQC-C60033
               END IF
            END IF   #TQC-D70092
         END IF
      END IF

      IF cl_null(g_inb[l_ac].inb08) THEN
         LET g_inb[l_ac].inb08=g_img09
         DISPLAY BY NAME g_inb[l_ac].inb08    #MOD-640485
         LET g_inb[l_ac].inb09 = s_digqty(g_inb[l_ac].inb09,g_inb[l_ac].inb08)   #FUN-BB0085
         LET g_inb[l_ac].inb16 = s_digqty(g_inb[l_ac].inb16,g_inb[l_ac].inb08)   #FUN-BB0085
         DISPLAY BY NAME g_inb[l_ac].inb09,g_inb[l_ac].inb16                     #FUN-BB0085
      END IF

      LET g_cnt = 0                           #FUN-B10016 add

      IF g_ina.ina00 NOT MATCHES '[56]' THEN  #MOD-A30151 add
         SELECT COUNT(*) INTO g_cnt FROM img_file
          WHERE img01 = g_inb[l_ac].inb04   #料號
            AND img02 = g_inb[l_ac].inb05   #倉庫
            AND img03 = g_inb[l_ac].inb06   #儲位
            AND img04 = g_inb[l_ac].inb07   #批號
            AND img18 < g_ina.ina02         #調撥日期
         IF g_cnt > 0 THEN    #大於有效日期
            call cl_err('','aim-400',0)   #須修改
            LET g_errno = 'aim-400'                #FUN-B10016 add
            #RETURN "inb07"  #TQC-C60033
            RETURN "inb05"   #TQC-C60033
         END IF
      END IF  #MOD-A30151 add
      IF g_sma.sma115 = 'Y' AND cl_null(g_inb[l_ac].inb46) THEN
         CALL t370_du_default(p_cmd)
      END IF
      #FUN-540025  --end
   END IF
   #end FUN-5C0085

   RETURN NULL
END FUNCTION
 
FUNCTION t370_chk_inb08()
   IF NOT cl_null(g_inb[l_ac].inb08) THEN
      SELECT gfe02 INTO g_buf FROM gfe_file
       WHERE gfe01=g_inb[l_ac].inb08
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_inb[l_ac].inb08,"",STATUS,"",
                      "gfe:",1)
         LET g_errno = STATUS                          #FUN-B10016 add
         RETURN FALSE
      END IF
      LET g_img09 = ''   LET g_img10 = 0   #MOD-A40089 add
      SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
       WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
         AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
      IF g_inb[l_ac].inb08=g_img09 THEN
         LET g_inb[l_ac].inb08_fac =  1
      ELSE
         IF NOT cl_null(g_img09) THEN #判斷(g_img09庫存單位不為空時)        #MOD-D70040 add
            CALL s_umfchk(g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09)
                  RETURNING g_cnt,g_inb[l_ac].inb08_fac
            IF g_cnt = 1 THEN
               CALL cl_err('','mfg3075',0)
               LET g_errno = 'mfg3075'                    #FUN-B10016 add
               RETURN FALSE
            END IF
         END IF                                                         #MOD-D70040 add
      END IF
      DISPLAY BY NAME g_inb[l_ac].inb08_fac
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_inb16(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1      #FUN-C20047
DEFINE l_qcl05   LIKE qcl_file.qcl05      #FUN-C20047
   #FUN-C20047-add-str--
   CALL t370_qcl05_sel() RETURNING l_qcl05
   IF l_qcl05 = '1' AND NOT cl_null(l_qcl05) THEN
      IF g_inb[l_ac].inb16 != 0 THEN
         CALL cl_err('','apm-818',0)
         RETURN FALSE
      END IF
   ELSE
   #FUN-C20047-add-end--
      #FUN-BB0085-add-str--
      IF NOT cl_null(g_inb[l_ac].inb16) AND NOT cl_null(g_inb[l_ac].inb08) THEN 
         IF cl_null(g_inb08_t) OR g_inb08_t != g_inb[l_ac].inb08 OR 
            cl_null(g_inb_t.inb16) OR g_inb_t.inb16 != g_inb[l_ac].inb16 THEN 
            LET g_inb[l_ac].inb16 = s_digqty(g_inb[l_ac].inb16,g_inb[l_ac].inb08)
            DISPLAY BY NAME g_inb[l_ac].inb16
         END IF 
      END IF 
      #FUN-BB0085-add-end--

      IF g_inb[l_ac].inb16=0 THEN
         CALL cl_err("","aim-120",0)
         RETURN FALSE
      END IF
      IF g_inb[l_ac].inb16<0 THEN
         CALL cl_err("","aim-989",0)
         RETURN FALSE
      END IF
      #FUN-C20047-add-str--
      IF NOT t370_inb09_chk(p_cmd) THEN
         RETURN FALSE 
      END IF
      #FUN-C20047-add-end--
   END IF     #FUN-C20047
   RETURN TRUE
 
END FUNCTION
 
FUNCTION t370_chk_inb09()
DEFINE #l_sql     LIKE type_file.chr1000 
       l_sql      STRING     #NO.FUN-910082                                        
DEFINE l_inb09   LIKE inb_file.inb09,                                           
       l_inb03   LIKE inb_file.inb03,                                           
       l_inb10   LIKE inb_file.inb10,                                           
       l_qcs01   LIKE qcs_file.qcs01,                                           
       l_qcs02   LIKE qcs_file.qcs02,                                           
       l_qcs091c LIKE qcs_file.qcs091                                           
DEFINE l_bno     LIKE rvbs_file.rvbs08  #No.CHI-9A0022

   #FUN-BB0085-add-str--
   IF NOT cl_null(g_inb[l_ac].inb16) AND NOT cl_null(g_inb[l_ac].inb08) THEN
      IF cl_null(g_inb08_t) OR g_inb08_t != g_inb[l_ac].inb08 OR
         cl_null(g_inb_t.inb09) OR g_inb_t.inb09 != g_inb[l_ac].inb09 THEN
         LET g_inb[l_ac].inb09 = s_digqty(g_inb[l_ac].inb09,g_inb[l_ac].inb08)
         DISPLAY BY NAME g_inb[l_ac].inb09
      END IF
   END IF
   #FUN-BB0085-add-end--

   IF g_inb[l_ac].inb09=0 THEN
      CALL cl_err("","aim-120",0)
      LET g_errno = 'aim-120'                #FUN-B10016 add
      RETURN FALSE
   END IF
   IF g_inb[l_ac].inb09<0 THEN
      CALL cl_err("","aim-989",0)
      LET g_errno = 'aim-989'                #FUN-B10016 add
      RETURN FALSE
   END IF
   IF NOT cl_null(g_inb[l_ac].inb09) THEN
      IF g_ina.ina00 MATCHES "[1256]" THEN
         SELECT img10 INTO g_img10 FROM img_file
            WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
            AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
         IF g_inb[l_ac].inb09*g_inb[l_ac].inb08_fac > g_img10 THEN
           #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN   #FUN-C80107 mark 
            LET l_flag01 = NULL    #FUN-C80107 add
         #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING l_flag01   #FUN-C80107 add  #FUN-D30024
            CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING l_flag01 #FUN-D30024 #TQC-D40078 g_plant
            IF l_flag01 = 'N' OR l_flag01 IS NULL THEN           #FUN-C80107 add
               CALL cl_err(g_inb[l_ac].inb09*g_inb[l_ac].inb08_fac,'mfg1303',1)
               LET g_errno = 'mfg1303'                    #FUN-B10016 add
               RETURN FALSE
            ELSE
               IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                  IF NOT cl_confirm('mfg3469') THEN
                     RETURN FALSE
                  END IF
               END IF                                     #FUN-B10016 add
            END IF
         END IF
      END IF
   ELSE
      LET g_errno = 'aim-120'                             #FUN-B10016 add
      CALL cl_err("","aim-120",0)
      RETURN FALSE
   END IF
 
   SELECT SUM(qcs091) INTO l_qcs091c
     FROM qcs_file
    WHERE qcs01 = g_ina.ina01         
      AND qcs02 = g_inb[l_ac].inb03    
   IF g_inb[l_ac].inb09 < l_qcs091c THEN
      LET g_errno = 'aim-006'                             #FUN-B10016 add
      CALL cl_err('','aim-006',0)
      RETURN FALSE
   END IF
   LET g_ima918 = ''      #DEV-D50009 add
   LET g_ima921 = ''      #DEV-D50009 add
   LET g_ima930 = ''      #DEV-D50009 add
 
  #若為背景執行,不作批序號維護
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-F30034 add
      SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930
        FROM ima_file
       WHERE ima01 = g_inb[l_ac].inb04
         AND imaacti = "Y"
 
      IF cl_null(g_ima918) THEN LET g_ima918 = 'N' END IF  #DEV-D50009 add
      IF cl_null(g_ima921) THEN LET g_ima921 = 'N' END IF  #DEV-D50009 add
      IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

      IF (g_ima918 = "Y" OR g_ima921 = "Y") AND g_sma.sma150='N' AND      #TQC-DB0021 add sam150
         (cl_null(g_inb_t.inb09) OR (g_inb[l_ac].inb09<>g_inb_t.inb09 )) THEN
         LET g_img09 = ''   LET g_img10 = 0   #MOD-A40089 add
         SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
          WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
            AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
         CALL s_umfchk(g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09)
             RETURNING l_i,l_fac
         IF l_i = 1 THEN LET l_fac = 1 END IF
         IF g_ina.ina00 = "1" OR g_ina.ina00="2" THEN
#CHI-9A0022 --Begin
            IF cl_null(g_inb[l_ac].inb41) THEN
               LET l_bno = ''
            ELSE
               LET l_bno = g_inb[l_ac].inb41
            END IF
#CHI-9A0022 --End
           #CALL s_lotout(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,   #TQC-B90236 mark
            IF g_ima930  = 'N' THEN                                 #DEV-D30059 add
               CALL s_mod_lot(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,  #TQC-B90236 add
                             g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                             g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                             g_inb[l_ac].inb08,g_img09,  
                             g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD',-1) #CHI-9A0022 add l_bno   #TQC-B90236 add '-1'
                  RETURNING l_r,g_qty 
            END IF                                                  #DEV-D30059 add
           #IF l_i = "Y" THEN       #MOD-B30036 mark
            IF l_r = "Y" THEN       #MOD-B30036 add
               LET g_qty = s_digqty(g_qty,g_inb[l_ac].inb08)     #FUN-BB0085
               LET g_inb[l_ac].inb16 = g_qty   #MOD-B70023  add
               LET g_inb[l_ac].inb09 = g_qty
               LET b_inb.inb16 = g_qty         #MOD-B70023  add
               LET b_inb.inb09 = g_qty         #MOD-B70023  add
            END IF
         END IF
         IF g_ina.ina00 = "3" OR g_ina.ina00="4" THEN
#CHI-9A0022 --Begin
            IF cl_null(g_inb[l_ac].inb41) THEN
               LET l_bno = ''
            ELSE
               LET l_bno = g_inb[l_ac].inb41
            END IF
#CHI-9A0022 --End
#No.TQC-B90236-----mark-----begin------
#        CALL s_lotin(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,
#                     g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09,   #No.FUN-860045
#                     g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD')   #No.FUN-860045#CHI-9A0022 add l_bno
#No.TQC-B90236-----mark-----end--------
#No.TQC-B90236-----add------begin------
            IF g_ima930  = 'N' THEN                                 #DEV-D30059 add
               CALL s_mod_lot(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,  
                             g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                             g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                             g_inb[l_ac].inb08,g_img09,
                             g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD',1) 
#No.TQC-B90236-----add------end--------
                  RETURNING l_r,g_qty   #No.FUN-860045
            END IF                                                  #DEV-D30059 add
            IF l_r = "Y" THEN  #MOD-8A0263 modify l_i->l_r
               LET g_qty = s_digqty(g_qty,g_inb[l_ac].inb08)     #FUN-BB0085
               LET g_inb[l_ac].inb16 = g_qty   #MOD-B70023 add
               LET g_inb[l_ac].inb09 = g_qty
               LET b_inb.inb16 = g_qty         #MOD-B70023 add
               LET b_inb.inb09 = g_qty         #MOD-B70023 add
            END IF
         END IF
         DISPLAY BY NAME g_inb[l_ac].inb09
         DISPLAY BY NAME g_inb[l_ac].inb16   #MOD-B70023 add
      END IF
   END IF  #FUN-F30034 add
 
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_inb905()
   IF cl_null(g_inb[l_ac].inb04) THEN RETURN "inb04" END IF
   IF g_inb[l_ac].inb05 IS NULL OR g_inb[l_ac].inb06 IS NULL OR
      g_inb[l_ac].inb07 IS NULL THEN
      RETURN "inb07"
   END IF
   IF NOT cl_null(g_inb[l_ac].inb905) THEN
      SELECT gfe02 INTO g_buf FROM gfe_file
       WHERE gfe01=g_inb[l_ac].inb905
         AND gfeacti='Y'
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_inb[l_ac].inb905,"",STATUS,"",
                      "gfe:",1)  #No.FUN-660156
         RETURN "inb905"
      END IF
      CALL s_du_umfchk(g_inb[l_ac].inb04,'','','',                              
                       g_inb[l_ac].inb08,g_inb[l_ac].inb905,g_ima906)           
           RETURNING g_errno,g_factor                                           
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_inb[l_ac].inb905,g_errno,0)
         RETURN "inb905"
      END IF
      LET g_inb[l_ac].inb906 = g_factor
      CALL s_chk_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                      g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                      g_inb[l_ac].inb905) RETURNING g_flag
      IF g_flag = 1 THEN
      #TQC-D70092 -----Begin------
        #IF g_ina.ina00 MATCHES '[1256]' THEN
        #   CALL cl_err('sel img:',STATUS,0)
        #   RETURN "inb04"
        #END IF
      #TQC-D70092 -----End--------
      #TQC-D70092 -----Begin------
         IF g_ina.ina00 MATCHES '[1256]' THEN   #MOD-E80167 add
            CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_flag
            IF g_flag = 'N' OR g_flag IS NULL THEN
               CALL cl_err('sel img:',STATUS,0)
               RETURN "inb04"
            END IF
         END IF   #MOD-E80167 add
      #TQC-D70092 -----End--------
         IF g_ina.ina00 NOT MATCHES '[1256]' THEN    #TQC-D70092 add 
            IF g_sma.sma892[3,3] = 'Y' THEN
               IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                  IF NOT cl_confirm('aim-995') THEN
                    RETURN "inb905"
                  END IF
               END IF                                     #FUN-B10016 add
            END IF
            CALL s_add_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                            g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                            g_inb[l_ac].inb905,g_inb[l_ac].inb906,
                            g_ina.ina01,
                            g_inb[l_ac].inb03,0) RETURNING g_flag
            IF g_flag = 1 THEN
               RETURN "inb905"
            END IF
         END IF  #TQC-D70092 add
      END IF
      #FUN-C60035 add----str----
      CALL t370sub_chk_ima25(g_inb[l_ac].inb04,g_inb[l_ac].inb905) RETURNING g_flag 
      IF g_flag = 0 THEN
          RETURN "inb905"
      END IF
      #FUN-C60035 add----end----
   END IF
   CALL t370_set_required()
   CALL cl_show_fld_cont()                   #No.FUN-560197
   RETURN NULL
END FUNCTION
 
FUNCTION t370_bef_inb906()
   IF cl_null(g_inb[l_ac].inb04) THEN RETURN "inb04" END IF
   IF g_inb[l_ac].inb05 IS NULL OR g_inb[l_ac].inb06 IS NULL OR
      g_inb[l_ac].inb07 IS NULL THEN
      RETURN "inb07"
   END IF
   IF NOT cl_null(g_inb[l_ac].inb905) AND g_ima906 = '3' THEN
      CALL s_chk_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                      g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                      g_inb[l_ac].inb905) RETURNING g_flag
      IF g_flag = 1 THEN
      #TQC-D70092 ------Begin------
        #IF g_ina.ina00 MATCHES '[1256]' THEN
        #   CALL cl_err('sel img:',STATUS,0)
        #   RETURN "inb04"
        #END IF
      #TQC-D70092 ------End--------
      #TQC-D70092 ------Begin------
         IF g_ina.ina00 MATCHES '[1256]' THEN   #MOD-E80167 add
            CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_flag
            IF g_flag = 'N' OR g_flag IS NULL THEN
               CALL cl_err('sel img:',STATUS,0)
               RETURN "inb04"
            END IF
         END IF   #MOD-E80167 add
      #TQC-D70092 ------End--------         
         IF g_ina.ina00 NOT MATCHES '[1256]' THEN
            IF g_sma.sma892[3,3] = 'Y' THEN
               IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                  IF NOT cl_confirm('aim-995') THEN
                    RETURN "inb04"
                  END IF
               END IF                                     #FUN-B10016 add
            END IF
            CALL s_add_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                            g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                            g_inb[l_ac].inb905,g_inb[l_ac].inb906,
                            g_ina.ina01,
                            g_inb[l_ac].inb03,0) RETURNING g_flag
            IF g_flag = 1 THEN
               RETURN "inb04"
            END IF
         END IF
      END IF
   END IF
   RETURN NULL
END FUNCTION
 
FUNCTION t370_bef_inb907()
   IF cl_null(g_inb[l_ac].inb04) THEN RETURN "inb04" END IF
   IF g_inb[l_ac].inb05 IS NULL OR g_inb[l_ac].inb06 IS NULL OR
      g_inb[l_ac].inb07 IS NULL THEN
      RETURN "inb07"
   END IF
   IF NOT cl_null(g_inb[l_ac].inb905) AND g_ima906 = '3' THEN
      CALL s_chk_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                      g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                      g_inb[l_ac].inb905) RETURNING g_flag
      IF g_flag = 1 THEN
      #TQC-D70092 ------Begin------
        #IF g_ina.ina00 MATCHES '[1256]' THEN
        #   CALL cl_err('sel img:',STATUS,0)
        #   RETURN "inb04"
        #END IF
      #TQC-D70092 ------End--------
      #TQC-D70092 ------Begin------
         IF g_ina.ina00 MATCHES '[1256]' THEN   #MOD-E80167 add
            CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_flag
            IF g_flag = 'N' OR g_flag IS NULL THEN
               CALL cl_err('sel img:',STATUS,0)
               RETURN "inb04"
            END IF
         END IF   #MOD-E80167 add
      #TQC-D70092 ------End--------
         IF g_ina.ina00 NOT MATCHES '[1256]' THEN    #TQC-D70092 add
            IF g_sma.sma892[3,3] = 'Y' THEN
               IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                  IF NOT cl_confirm('aim-995') THEN
                    RETURN "inb04"
                  END IF
               END IF                                     #FUN-B10016 add
            END IF
            CALL s_add_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                            g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                            g_inb[l_ac].inb905,g_inb[l_ac].inb906,
                            g_ina.ina01,
                            g_inb[l_ac].inb03,0) RETURNING g_flag
            IF g_flag = 1 THEN
               RETURN "inb04"
            END IF
         END IF   #TQC-D70092 add
      END IF
   END IF
   RETURN NULL
END FUNCTION
 
FUNCTION t370_chk_inb907(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_bno     LIKE rvbs_file.rvbs08  #No.CHI-9A0022

   #FUN-BB0085-add-str--
   IF NOT cl_null(g_inb[l_ac].inb907) AND NOT cl_null(g_inb[l_ac].inb905) THEN 
      IF cl_null(g_inb905_t) OR g_inb905_t != g_inb[l_ac].inb905 OR 
         cl_null(g_inb_t.inb907) OR g_inb_t.inb907 != g_inb[l_ac].inb907 THEN 
         LET g_inb[l_ac].inb907 = s_digqty(g_inb[l_ac].inb907,g_inb[l_ac].inb905)
         DISPLAY BY NAME g_inb[l_ac].inb907
      END IF
   END IF
   #FUN-BB0085-add-end--

   IF NOT cl_null(g_inb[l_ac].inb907) THEN
      IF g_inb[l_ac].inb907 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE
      END IF
      IF p_cmd = 'a' THEN
         IF g_ima906='3' THEN
            LET g_tot=g_inb[l_ac].inb907*g_inb[l_ac].inb906
            IF cl_null(g_inb[l_ac].inb904) OR g_inb[l_ac].inb904=0 THEN
               LET g_inb[l_ac].inb904=g_tot*g_inb[l_ac].inb903
               LET g_inb[l_ac].inb904=s_digqty(g_inb[l_ac].inb904,g_inb[l_ac].inb902)   #FUN-BB0085
               DISPLAY BY NAME g_inb[l_ac].inb904
            END IF
         END IF
      END IF
      IF g_ima906 MATCHES '[23]' THEN
         SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
          WHERE imgg01=g_inb[l_ac].inb04
            AND imgg02=g_inb[l_ac].inb05
            AND imgg03=g_inb[l_ac].inb06
            AND imgg04=g_inb[l_ac].inb07
            AND imgg09=g_inb[l_ac].inb905
      END IF
      IF NOT cl_null(g_inb[l_ac].inb905) THEN
         IF g_ina.ina00 MATCHES '[1256]' THEN
            IF g_sma.sma117 = 'N' THEN
               IF g_inb[l_ac].inb907 > g_imgg10_2 THEN
                 #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN    #FUN-C80107 mark
                  LET l_flag01 = NULL    #FUN-C80107 add
               #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING l_flag01   #FUN-C80107 add  #FUN-D30024
                  CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING l_flag01 #FUN-D30024 #TQC-D40078 g_plant
                  IF l_flag01 = 'N' OR l_flag01 IS NULL THEN           #FUN-C80107 add
                     CALL cl_err(g_inb[l_ac].inb907,'mfg1303',1)
                     RETURN FALSE
                  ELSE
                     IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                       IF NOT cl_confirm('mfg3469') THEN
                          RETURN FALSE
                       ELSE
                          LET g_yes = 'Y'
                       END IF
                     END IF                                     #FUN-B10016 add
                  END IF
               END IF
            END IF
         END IF
      END IF
 
     #此段copy from t370_chk_inb09
       LET g_ima918 = ''   #DEV-D50009 add
       LET g_ima921 = ''   #DEV-D50009 add
       LET g_ima930 = ''   #DEV-D50009 add

       SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930
         FROM ima_file
        WHERE ima01 = g_inb[l_ac].inb04
          AND imaacti = "Y"

       IF cl_null(g_ima918) THEN LET g_ima918 = 'N' END IF  #DEV-D50009 add
       IF cl_null(g_ima921) THEN LET g_ima921 = 'N' END IF  #DEV-D50009 add 
       IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

       IF (g_ima918 = "Y" OR g_ima921 = "Y") AND g_sma.sma150='N' AND  #TQC-DB0021 add sam150
          (cl_null(g_inb_t.inb905) OR (g_inb[l_ac].inb905<>g_inb_t.inb905 )) THEN
          LET g_img09 = ''   LET g_img10 = 0   #MOD-A40089 add
          SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
           WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
             AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
          CALL s_umfchk(g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09)
              RETURNING l_i,l_fac
          IF l_i = 1 THEN LET l_fac = 1 END IF
          IF g_ina.ina00 = "1" OR g_ina.ina00="2" #MOD-910104 mark THEN
             OR g_ina.ina00 = "5" OR g_ina.ina00 = "6" THEN #MOD-910104
#CHI-9A0022 --Begin
             IF cl_null(g_inb[l_ac].inb41) THEN
                LET l_bno = ''
             ELSE
                LET l_bno = g_inb[l_ac].inb41
             END IF
#CHI-9A0022 --End
            #CALL s_lotout(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,   #TQC-B90236 mark
             IF g_ima930  = 'N' THEN                                 #DEV-D30059 add
                CALL s_mod_lot(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,  #TQC-B90236 add
                              g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                              g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                              g_inb[l_ac].inb08,g_img09,  
                              g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD',-1) #CHI-9A0022 add l_bno    #TQC-B90236 add '-1'
                   RETURNING l_r,g_qty 
             END IF                                                  #DEV-D30059 add 
            #IF l_i = "Y" THEN       #MOD-B30036 mark
             IF l_r = "Y" THEN       #MOD-B30036 add
                LET g_qty = s_digqty(g_qty,g_inb[l_ac].inb08)     #FUN-BB0085
                LET g_inb[l_ac].inb16 = g_qty   #MOD-B70023 add
                LET g_inb[l_ac].inb09 = g_qty
                LET b_inb.inb16 = g_qty         #MOD-B70023 add
                LET b_inb.inb09 = g_qty         #MOD-B70023 add
             END IF
          END IF
          IF g_ina.ina00 = "3" OR g_ina.ina00="4" THEN
#CHI-9A0022 --Begin
             IF cl_null(g_inb[l_ac].inb41) THEN
                LET l_bno = ''
             ELSE
                LET l_bno = g_inb[l_ac].inb41
             END IF
#CHI-9A0022 --End
#No.TQC-B90236-----mark-----begin------
#            CALL s_lotin(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,
#                         g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09,   #No.FUN-860045
#                         g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD')   #No.FUN-860045 #CHI-9A0022 add l_bno
#No.TQC-B90236-----mark-----end--------
#No.TQC-B90236-----add------begin------
             IF g_ima930  = 'N' THEN                                 #DEV-D30059 add
                CALL s_mod_lot(g_prog,g_ina.ina01,g_inb[l_ac].inb03,0,  
                              g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                              g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                              g_inb[l_ac].inb08,g_img09,
                              g_inb[l_ac].inb08_fac,g_inb[l_ac].inb09,l_bno,'MOD',1) 
#No.TQC-B90236-----add------end--------
                   RETURNING l_r,g_qty   #No.FUN-860045
             END IF                                                  #DEV-D30059 add 
            #IF l_i = "Y" THEN       #MOD-B30036 mark
             IF l_r = "Y" THEN       #MOD-B30036 add
                LET g_qty = s_digqty(g_qty,g_inb[l_ac].inb08)     #FUN-BB0085
                LET g_inb[l_ac].inb16 = g_qty   #MOD-B70023 add
                LET g_inb[l_ac].inb09 = g_qty
                LET b_inb.inb16 = g_qty         #MOD-B70023 add
                LET b_inb.inb09 = g_qty         #MOD-B70023 add
             END IF
          END IF
          DISPLAY BY NAME g_inb[l_ac].inb905
       END IF
   END IF
   CALL cl_show_fld_cont()                   #No.FUN-560197
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_inb902()
   IF cl_null(g_inb[l_ac].inb04) THEN RETURN "inb04" END IF
   IF g_inb[l_ac].inb05 IS NULL OR g_inb[l_ac].inb06 IS NULL OR
      g_inb[l_ac].inb07 IS NULL THEN
      RETURN "inb07"
   END IF
   IF NOT cl_null(g_inb[l_ac].inb902) THEN
      SELECT gfe02 INTO g_buf FROM gfe_file
       WHERE gfe01=g_inb[l_ac].inb902
         AND gfeacti='Y'
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_inb[l_ac].inb902,"",STATUS,"",
                      "gfe:",1)  #No.FUN-660156
         RETURN "inb902"
      END IF
     #MOD-E80023 add str
      LET g_img09 = ''
      SELECT img09 INTO g_img09 FROM img_file
       WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
         AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
     #MOD-E80023 add end
     #MOD-EC0006---add---str---
      IF cl_null(g_img09) AND (g_ina.ina00!='3' AND g_ina.ina00!='4') THEN  #3:庫存雜項收料  4:WIP 雜項收料
          #無此料+倉+儲+批[img_file]資料,請查核..!
          CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)
          LET g_errno = 'mfg6069'                  
          RETURN "inb04"
      END IF
     #MOD-EC0006---add---end---
      CALL s_du_umfchk(g_inb[l_ac].inb04,'','','',      
                       g_img09,g_inb[l_ac].inb902,'1')
           RETURNING g_errno,g_factor
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_inb[l_ac].inb902,g_errno,0)
         RETURN "inb902"
      END IF
      LET g_inb[l_ac].inb903 = g_factor
      IF g_ima906 = '2' THEN
         CALL s_chk_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                         g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                         g_inb[l_ac].inb902) RETURNING g_flag
         IF g_flag = 1 THEN
         #TQC-D70092 -------Begin-------
           #IF g_ina.ina00 MATCHES '[1256]' THEN
           #   CALL cl_err('sel img:',STATUS,0)
           #   RETURN "inb04"
           #END IF
         #TQC-D70092 -------End---------
         #TQC-D70092 -------Begin-------
            IF g_ina.ina00 MATCHES '[1256]' THEN   #MOD-E80167 add
               CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_flag
               IF g_flag = 'N' OR g_flag IS NULL THEN 
                  CALL cl_err('sel img:',STATUS,0)
                  RETURN "inb04"
               END IF
            END IF   #MOD-E80167 add
         #TQC-D70092 -------End--------- 
            IF g_ina.ina00 NOT MATCHES '[1256]' THEN    #TQC-D70092 add
               IF g_sma.sma892[3,3] = 'Y' THEN
                  IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                    IF NOT cl_confirm('aim-995') THEN
                      RETURN "inb902"
                    END IF
                  END IF                                     #FUN-B10016 add
               END IF
               CALL s_add_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                               g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                               g_inb[l_ac].inb902,g_inb[l_ac].inb903,
                               g_ina.ina01,
                               g_inb[l_ac].inb03,0) RETURNING g_flag
               IF g_flag = 1 THEN
                  RETURN "inb902"
               END IF
            END IF    #TQC-D70092 add
         END IF
      END IF
      IF g_ima906 ='2' THEN
         SELECT imgg10 INTO g_imgg10_1 FROM imgg_file
          WHERE imgg01=g_inb[l_ac].inb04
            AND imgg02=g_inb[l_ac].inb05
            AND imgg03=g_inb[l_ac].inb06
            AND imgg04=g_inb[l_ac].inb07
            AND imgg09=g_inb[l_ac].inb902
      ELSE
         SELECT img10 INTO g_imgg10_1 FROM img_file
          WHERE img01=g_inb[l_ac].inb04
            AND img02=g_inb[l_ac].inb05
            AND img03=g_inb[l_ac].inb06
            AND img04=g_inb[l_ac].inb07
      END IF
      #FUN-C60035 add----str----
      CALL t370sub_chk_ima25(g_inb[l_ac].inb04,g_inb[l_ac].inb902) RETURNING g_flag 
      IF g_flag = 0 THEN
          RETURN "inb902"
      END IF
      #FUN-C60035 add----end----
   END IF
   CALL t370_set_required()
   CALL cl_show_fld_cont()                   #No.FUN-560197
   RETURN NULL
END FUNCTION
 
FUNCTION t370_chk_inb904()

   #FUN-BB0085-add-str--
   IF NOT cl_null(g_inb[l_ac].inb904) AND NOT cl_null(g_inb[l_ac].inb902) THEN 
      IF cl_null(g_inb902_t) OR g_inb902_t != g_inb[l_ac].inb902 OR
         cl_null(g_inb_t.inb904) OR g_inb_t.inb904 != g_inb[l_ac].inb904 THEN
         LET g_inb[l_ac].inb904 = s_digqty(g_inb[l_ac].inb904,g_inb[l_ac].inb902)
         DISPLAY BY NAME g_inb[l_ac].inb904
      END IF
   END IF
   #FUN-BB0085-add-end--  

   IF NOT cl_null(g_inb[l_ac].inb904) THEN
      IF g_inb[l_ac].inb904 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN "inb904"
      END IF
      IF NOT cl_null(g_inb[l_ac].inb902) THEN
         IF g_ina.ina00 MATCHES '[1256]' THEN
            IF g_ima906 = '2' THEN
               IF g_sma.sma117 = 'N' THEN
                  IF g_inb[l_ac].inb904 > g_imgg10_1 THEN
                    #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN    #FUN-C80107 mark
                     LET l_flag01 = NULL    #FUN-C80107 add
                  #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING l_flag01   #FUN-C80107 add #FUN-D30024
                     CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING l_flag01 #FUN-D30024 #TQC-D40078 g_plant
                     IF l_flag01 = 'N' OR l_flag01 IS NULL THEN           #FUN-C80107 add
                        CALL cl_err(g_inb[l_ac].inb904,'mfg1303',1)
                        RETURN "inb904"
                     ELSE
                        IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                          IF NOT cl_confirm('mfg3469') THEN
                             RETURN "inb904"
                          ELSE
                             LET g_yes = 'Y'
                          END IF
                        ELSE                                       #FUN-B10016 add
                          LET g_yes = 'Y'                          #FUN-B10016 add
                        END IF                                     #FUN-B10016 add 
                     END IF
                  END IF
               END IF
            ELSE
               IF g_inb[l_ac].inb904 * g_inb[l_ac].inb903 > g_imgg10_1 THEN
                 #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN     #FUN-C80107 mark
                  LET l_flag01 = NULL    #FUN-C80107 add
               #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING l_flag01   #FUN-C80107 add #FUN-D30024
                  CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING l_flag01 #FUN-D30024 #TQC-D40078 g_plant
                  IF l_flag01 = 'N' OR l_flag01 IS NULL THEN           #FUN-C80107 add
                     CALL cl_err(g_inb[l_ac].inb904,'mfg1303',1)
                     RETURN "inb904"
                  ELSE
                     IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                       IF NOT cl_confirm('mfg3469') THEN
                          RETURN "inb904"
                       ELSE
                          LET g_yes = 'Y'
                       END IF
                     ELSE                                       #FUN-B10016 add
                       LET g_yes = 'Y'                          #FUN-B10016 add
                     END IF                                     #FUN-B10016 add
                  END IF
               END IF
            END IF
         END IF
      END IF
      CALL t370_du_data_to_correct()
      CALL t370_set_origin_field()
      IF g_inb[l_ac].inb09 IS NULL OR g_inb[l_ac].inb09=0 THEN
         IF g_ima906 MATCHES '[23]' THEN
            RETURN "inb907"
         ELSE
            RETURN "inb904"
         END IF
      END IF
   END IF
   CALL cl_show_fld_cont()                   #No.FUN-560197
   RETURN NULL
END FUNCTION
 
FUNCTION t370_chk_inb925()
   IF cl_null(g_inb[l_ac].inb04) THEN RETURN "inb04" END IF
   IF g_inb[l_ac].inb05 IS NULL OR g_inb[l_ac].inb06 IS NULL OR
      g_inb[l_ac].inb07 IS NULL THEN
      RETURN "inb07"
   END IF
   IF NOT cl_null(g_inb[l_ac].inb925) THEN
      SELECT gfe02 INTO g_buf FROM gfe_file
       WHERE gfe01=g_inb[l_ac].inb925
         AND gfeacti='Y'
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_inb[l_ac].inb925,"",STATUS,"",
                      "gfe:",1)  #No.FUN-660156
         RETURN "inb925"
      END IF
     #MOD-EC0006---add---str---
      LET g_img09 = ''
      SELECT img09 INTO g_img09 FROM img_file
       WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
         AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
      IF cl_null(g_img09) AND (g_ina.ina00!='3' AND g_ina.ina00!='4') THEN  #3:庫存雜項收料  4:WIP 雜項收料
          #無此料+倉+儲+批[img_file]資料,請查核..!
          CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)
          LET g_errno = 'mfg6069'                  
          RETURN "inb04"
      END IF
     #MOD-EC0006---add---end---
      CALL s_du_umfchk(g_inb[l_ac].inb04,'','','', 
                      #g_img09,g_inb[l_ac].inb925,g_ima906)              #MOD-E80023 mark
                       g_inb[l_ac].inb08,g_inb[l_ac].inb925,g_ima906)    #MOD-E80023 add
           RETURNING g_errno,g_factor
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_inb[l_ac].inb925,g_errno,0)
         RETURN "inb925"
      END IF
      LET g_inb[l_ac].inb926 = g_factor
      CALL s_chk_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                      g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                      g_inb[l_ac].inb925) RETURNING g_flag
      IF g_flag = 1 THEN
      #TQC-D70092 --------Begin--------
       # IF g_ina.ina00 MATCHES '[1256]' THEN
       #    CALL cl_err('sel img:',STATUS,0)
       #    RETURN "inb04"
       # END IF
      #TQC-D70092 --------End----------
      #TQC-D70092 --------Begin--------
         IF g_ina.ina00 MATCHES '[1256]' THEN   #MOD-E80167 add
            CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_flag
            IF g_flag = 'N' OR g_flag IS NULL THEN 
               CALL cl_err('sel img:',STATUS,0)
               RETURN "inb04"
            END IF
         END IF   #MOD-E80167 add
      #TQC-D70092 --------End----------
         IF g_ina.ina00 NOT MATCHES '[1256]' THEN   #TQC-D70092 add
            IF g_sma.sma892[3,3] = 'Y' THEN
               IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                 IF NOT cl_confirm('aim-995') THEN
                   RETURN "inb925"
                 END IF
               END IF                                     #FUN-B10016 add
            END IF
            CALL s_add_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                            g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                            g_inb[l_ac].inb925,g_inb[l_ac].inb926,
                            g_ina.ina01,
                            g_inb[l_ac].inb03,0) RETURNING g_flag
            IF g_flag = 1 THEN
               RETURN "inb925"
            END IF
         END IF   #TQC-D70092 add 
      END IF
      #FUN-C60035 add----str----
      CALL t370sub_chk_ima25(g_inb[l_ac].inb04,g_inb[l_ac].inb925) RETURNING g_flag 
      IF g_flag = 0 THEN
          RETURN "inb925"
      END IF
      #FUN-C60035 add----end----
   END IF
   CALL t370_set_required()
   CALL cl_show_fld_cont()                   #No.FUN-560197
   RETURN NULL
END FUNCTION
 
FUNCTION t370_bef_inb926()
   IF cl_null(g_inb[l_ac].inb04) THEN RETURN "inb04" END IF
   IF g_inb[l_ac].inb05 IS NULL OR g_inb[l_ac].inb06 IS NULL OR
      g_inb[l_ac].inb07 IS NULL THEN
      RETURN "inb07"
   END IF
   IF NOT cl_null(g_inb[l_ac].inb925) AND g_ima906 = '3' THEN
      CALL s_chk_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                      g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                      g_inb[l_ac].inb925) RETURNING g_flag
      IF g_flag = 1 THEN
      #TQC-D70092 ------Begin-------
        #IF g_ina.ina00 MATCHES '[1256]' THEN
        #   CALL cl_err('sel img:',STATUS,0)
        #   RETURN "inb04"
        #END IF
      #TQC-D70092 ------End---------
      #TQC-D70092 ------Begin-------
         IF g_ina.ina00 MATCHES '[1256]' THEN   #MOD-E80167 add
            CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_flag
            IF g_flag = 'N' OR g_flag IS NULL THEN 
               CALL cl_err('sel img:',STATUS,0)
               RETURN "inb04"
            END IF
         END IF   #MOD-E80167 add
      #TQC-D70092 ------End---------
         IF g_ina.ina00 NOT MATCHES '[1256]' THEN   #TQC-D70092 add 
            IF g_sma.sma892[3,3] = 'Y' THEN
               IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                 IF NOT cl_confirm('aim-995') THEN
                   RETURN "inb04"
                 END IF
               END IF                                     #FUN-B10016 add 
            END IF
            CALL s_add_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                            g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                            g_inb[l_ac].inb925,g_inb[l_ac].inb926,
                            g_ina.ina01,
                            g_inb[l_ac].inb03,0) RETURNING g_flag
            IF g_flag = 1 THEN
               RETURN "inb04"
            END IF
         END IF    #TQC-D70092 add
      END IF
   END IF
   RETURN NULL
END FUNCTION
 
FUNCTION t370_bef_inb927()
   IF cl_null(g_inb[l_ac].inb04) THEN RETURN "inb04" END IF
   IF g_inb[l_ac].inb05 IS NULL OR g_inb[l_ac].inb06 IS NULL OR
      g_inb[l_ac].inb07 IS NULL THEN
      RETURN "inb07"
   END IF
   IF NOT cl_null(g_inb[l_ac].inb925) AND g_ima906 = '3' THEN
      CALL s_chk_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                      g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                      g_inb[l_ac].inb925) RETURNING g_flag
      IF g_flag = 1 THEN
      #TQC-D70092 --------Begin--------
        #IF g_ina.ina00 MATCHES '[1256]' THEN
        #   CALL cl_err('sel img:',STATUS,0)
        #   RETURN "inb04"
        #END IF
      #TQC-D70092 --------End----------
      #TQC-D70092 --------Begin--------
         IF g_ina.ina00 MATCHES '[1256]' THEN   #MOD-E80167 add
            CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_flag
            IF g_flag = 'N' OR g_flag IS NULL THEN
               CALL cl_err('sel img:',STATUS,0)
               RETURN "inb04"
            END IF
         END IF   #MOD-E80167 add
      #TQC-D70092 --------End----------
         IF g_ina.ina00 NOT MATCHES '[1256]' THEN     #TQC-D70092 add
            IF g_sma.sma892[3,3] = 'Y' THEN
               IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                 IF NOT cl_confirm('aim-995') THEN
                   RETURN "inb04"
                 END IF
               END IF                                     #FUN-B10016 add
            END IF
            CALL s_add_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                            g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                            g_inb[l_ac].inb925,g_inb[l_ac].inb926,
                            g_ina.ina01,
                            g_inb[l_ac].inb03,0) RETURNING g_flag
            IF g_flag = 1 THEN
               RETURN "inb04"
            END IF
         END IF    #TQC-D70092 add 
      END IF
   END IF
   RETURN NULL
END FUNCTION
 
FUNCTION t370_chk_inb927(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_qcl05  LIKE qcl_file.qcl05     #FUN-C20047
   DEFINE l_factor LIKE type_file.num5  #MOD-D30154

   #FUN-C20047-add-str--
   CALL t370_qcl05_sel() RETURNING l_qcl05
   IF l_qcl05 = '1' AND NOT cl_null(l_qcl05) THEN
      IF g_inb[l_ac].inb927 != 0 THEN
         CALL cl_err('','apm-818',0)
         RETURN FALSE
      END IF
   ELSE  
   #FUN-C20047-add-end--

      #FUN-BB0085-add-str--
      IF NOT cl_null(g_inb[l_ac].inb927) AND NOT cl_null(g_inb[l_ac].inb925) THEN 
         IF cl_null(g_inb925_t) OR g_inb925_t != g_inb[l_ac].inb925 OR 
            cl_null(g_inb_t.inb927) OR g_inb_t.inb927 != g_inb[l_ac].inb927 THEN
            LET g_inb[l_ac].inb927 = s_digqty(g_inb[l_ac].inb927,g_inb[l_ac].inb925)
            DISPLAY BY NAME g_inb[l_ac].inb927
         END IF   
      END IF
      #FUN-BB0085-add-end--

      IF NOT cl_null(g_inb[l_ac].inb927) THEN
         IF g_inb[l_ac].inb927 < 0 THEN
            CALL cl_err('','aim-391',0)  #
            RETURN FALSE
         END IF
         #IF p_cmd = 'a' THEN  #MOD-D30154
         IF p_cmd = 'a' OR (p_cmd='u' AND g_inb[l_ac].inb924=0)  THEN  #MOD-D30154
            IF g_ima906='3' THEN  
               IF NOT cl_null(g_inb[l_ac].inb926) AND g_inb[l_ac].inb926 > 0 THEN  #MOD-D30154
                  LET g_tot=g_inb[l_ac].inb927*g_inb[l_ac].inb926
               #MOD-D30154---begin
               ELSE
                 #CALL s_du_umfchk(g_inb[l_ac].inb04,'','','',g_inb[l_ac].inb925,g_inb[l_ac].inb922,g_ima906)  #MOD-F30181 mark
                  CALL s_du_umfchk(g_inb[l_ac].inb04,'','','',g_inb[l_ac].inb922,g_inb[l_ac].inb925,g_ima906)  #MOD-F30181 add
                  RETURNING g_errno,l_factor
                  LET g_tot=g_inb[l_ac].inb927*l_factor
               END IF
               #MOD-D30154---end
               IF cl_null(g_inb[l_ac].inb924) OR g_inb[l_ac].inb924=0 THEN #CHI-960022
                  LET g_inb[l_ac].inb924=g_tot*g_inb[l_ac].inb923
                  LET g_inb[l_ac].inb924=s_digqty(g_inb[l_ac].inb924,g_inb[l_ac].inb922)   #FUN-BB0085
                  DISPLAY BY NAME g_inb[l_ac].inb924                       #CHI-960022
               END IF                                                      #CHI-960022
            END IF
         END IF
         IF g_ima906 MATCHES '[23]' THEN
            SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
             WHERE imgg01=g_inb[l_ac].inb04
               AND imgg02=g_inb[l_ac].inb05
               AND imgg03=g_inb[l_ac].inb06
               AND imgg04=g_inb[l_ac].inb07
               AND imgg09=g_inb[l_ac].inb925
         END IF
         IF NOT cl_null(g_inb[l_ac].inb925) THEN
            IF g_ina.ina00 MATCHES '[1256]' THEN
                IF g_ima906 = '2' THEN #MOD-EB0093 add if 判斷母子單位時才做以下
                    IF g_sma.sma117 = 'N' THEN
                       IF g_inb[l_ac].inb927 > g_imgg10_2 THEN
                         #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN   #FUN-C80107 mark
                          LET l_flag01 = NULL    #FUN-C80107 add
                       #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING l_flag01   #FUN-C80107 add #FUN-D30024
                          CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING l_flag01 #FUN-D30024 #TQC-D40078 g_plant 
                          IF l_flag01 = 'N' OR l_flag01 IS NULL THEN           #FUN-C80107 add
                             CALL cl_err(g_inb[l_ac].inb927,'mfg1303',1)
                             RETURN FALSE
                          ELSE
                             IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                                IF NOT cl_confirm('mfg3469') THEN
                                   RETURN FALSE
                                ELSE
                                   LET g_yes = 'Y'
                                END IF
                             ELSE                                       #FUN-B10016 add
                                LET g_yes = 'Y'                         #FUN-B10016 add
                             END IF                                     #FUN-B10016 add
                          END IF
                       END IF
                    END IF
                END IF #MOD-EB0093 add
            END IF
         END IF
         #IF p_cmd = 'a' OR g_inb[l_ac].inb907=0 THEN    #CHI-960092
            LET g_inb[l_ac].inb905 = g_inb[l_ac].inb925  #MOD-9B0146
            LET g_inb[l_ac].inb906 = g_inb[l_ac].inb926  #MOD-9B0146
            LET g_inb[l_ac].inb907 = g_inb[l_ac].inb927
            DISPLAY BY NAME g_inb[l_ac].inb927
         #END IF                                         #CHI-960092       
 
      END IF
      #FUN-C20047-add-str--
      IF NOT t370_inb09_chk(p_cmd) THEN
         RETURN FALSE
      END IF
      #FUN-C20047-add-end--
   END IF                                    #FUN-C20047
   CALL cl_show_fld_cont()                   #No.FUN-560197
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_inb922()
   IF cl_null(g_inb[l_ac].inb04) THEN RETURN "inb04" END IF
   IF g_inb[l_ac].inb05 IS NULL OR g_inb[l_ac].inb06 IS NULL OR
      g_inb[l_ac].inb07 IS NULL THEN
      RETURN "inb07"
   END IF
   IF NOT cl_null(g_inb[l_ac].inb922) THEN
      SELECT gfe02 INTO g_buf FROM gfe_file
       WHERE gfe01=g_inb[l_ac].inb922
         AND gfeacti='Y'
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_inb[l_ac].inb922,"",STATUS,"",
                      "gfe:",1)  #No.FUN-660156
         RETURN "inb922"
      END IF
     #MOD-BB0165 -- begin --
      CALL t370_set_origin_field()
      CALL t370_set_origin_field2()
     #MOD-BB0165 -- end --
     #MOD-E80023 add str
      LET g_img09 = ''
      SELECT img09 INTO g_img09 FROM img_file
       WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
         AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
     #MOD-E80023 add end
     #MOD-EC0006---add---str---
      IF cl_null(g_img09) AND (g_ina.ina00!='3' AND g_ina.ina00!='4') THEN  #3:庫存雜項收料  4:WIP 雜項收料
          #無此料+倉+儲+批[img_file]資料,請查核..!
          CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)
          LET g_errno = 'mfg6069'                  
          RETURN "inb04"
      END IF
     #MOD-EC0006---add---end---
      CALL s_du_umfchk(g_inb[l_ac].inb04,'','','', 
                      #g_inb[l_ac].inb08,g_inb[l_ac].inb922,'1')  #MOD-E80023 mark
                       g_img09,g_inb[l_ac].inb922,'1')            #MOD-E80023 add
           RETURNING g_errno,g_factor
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_inb[l_ac].inb922,g_errno,0)
         RETURN "inb922"
      END IF
      LET g_inb[l_ac].inb923 = g_factor
      IF g_ima906 = '2' THEN
         CALL s_chk_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                         g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                         g_inb[l_ac].inb922) RETURNING g_flag
         IF g_flag = 1 THEN
         #TQC-D70092 -------Begin-------
          # IF g_ina.ina00 MATCHES '[1256]' THEN
          #    CALL cl_err('sel img:',STATUS,0)
          #    RETURN "inb04"
          # END IF
         #TQC-D70092 -------End---------
         #TQC-D70092 -------Begin-------
            IF g_ina.ina00 MATCHES '[1256]' THEN   #MOD-E80167 add
               CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_flag
               IF g_flag = 'N' OR g_flag IS NULL THEN 
                  CALL cl_err('sel img:',STATUS,0)
                  RETURN "inb04" 
               END IF
            END IF   #MOD-E80167 add
         #TQC-D70092 -------End---------
            IF g_ina.ina00 NOT MATCHES '[1256]' THEN    #TQC-D70092 add
               IF g_sma.sma892[3,3] = 'Y' THEN
                  IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                    IF NOT cl_confirm('aim-995') THEN
                      RETURN "inb922"
                    END IF
                  END IF                                     #FUN-B10016 add
               END IF
               CALL s_add_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                               g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                               g_inb[l_ac].inb922,g_inb[l_ac].inb923,
                               g_ina.ina01,
                               g_inb[l_ac].inb03,0) RETURNING g_flag
               IF g_flag = 1 THEN
                  RETURN "inb922"
               END IF
            END IF #TQC-D70092 add
         END IF
      END IF
      IF g_ima906 ='2' THEN
         SELECT imgg10 INTO g_imgg10_1 FROM imgg_file
          WHERE imgg01=g_inb[l_ac].inb04
            AND imgg02=g_inb[l_ac].inb05
            AND imgg03=g_inb[l_ac].inb06
            AND imgg04=g_inb[l_ac].inb07
            AND imgg09=g_inb[l_ac].inb922
      ELSE
         SELECT img10 INTO g_imgg10_1 FROM img_file
          WHERE img01=g_inb[l_ac].inb04
            AND img02=g_inb[l_ac].inb05
            AND img03=g_inb[l_ac].inb06
            AND img04=g_inb[l_ac].inb07
      END IF
      #FUN-C60035 add----str----
      CALL t370sub_chk_ima25(g_inb[l_ac].inb04,g_inb[l_ac].inb922) RETURNING g_flag 
      IF g_flag = 0 THEN
          RETURN "inb922"
      END IF
      #FUN-C60035 add----end----
   END IF
   CALL t370_set_required()
   CALL cl_show_fld_cont()                   #No.FUN-560197
   RETURN NULL
END FUNCTION
 
FUNCTION t370_chk_inb924(p_cmd)            #FUN-C20047
DEFINE l_qcl05   LIKE qcl_file.qcl05       #FUN-C20047
DEFINE p_cmd     LIKE type_file.chr1       #FUN-C20047

   #FUN-C20047-add-str--
   CALL t370_qcl05_sel() RETURNING l_qcl05
   IF l_qcl05 = '1' AND NOT cl_null(l_qcl05) THEN
      IF g_inb[l_ac].inb924 != 0 THEN
         CALL cl_err('','apm-818',0)
         RETURN 'inb924'
      END IF
   ELSE  
   #FUN-C20047-add-end--

      #FUN-BB0085-add-str--
      IF NOT cl_null(g_inb[l_ac].inb924) AND NOT cl_null(g_inb[l_ac].inb922) THEN
         IF cl_null(g_inb922_t) OR g_inb922_t != g_inb[l_ac].inb922 OR
            cl_null(g_inb_t.inb924) OR g_inb_t.inb924 != g_inb[l_ac].inb924 THEN 
            LET g_inb[l_ac].inb924 = s_digqty(g_inb[l_ac].inb924,g_inb[l_ac].inb922)
            DISPLAY BY NAME g_inb[l_ac].inb924
         END IF 
      END IF
      #FUN-BB0085-add-end--

      IF NOT cl_null(g_inb[l_ac].inb924) THEN
         IF g_inb[l_ac].inb924 < 0 THEN
            CALL cl_err('','aim-391',0)  #
            RETURN "inb924"
         END IF
         IF NOT cl_null(g_inb[l_ac].inb922) THEN
            IF g_ina.ina00 MATCHES '[1256]' THEN
               IF g_ima906 = '2' THEN
                  IF g_sma.sma117 = 'N' THEN
                     IF g_inb[l_ac].inb924 > g_imgg10_1 THEN
                       #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN      #FUN-C80107 mark
                        LET l_flag01 = NULL    #FUN-C80107 add
                     #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING l_flag01   #FUN-C80107 add #FUN-D30024
                        CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING l_flag01 #FUN-D30024 #TQC-D40078 g_plant 
                        IF l_flag01 = 'N' OR l_flag01 IS NULL THEN           #FUN-C80107 add
                           CALL cl_err(g_inb[l_ac].inb924,'mfg1303',1)
                           RETURN "inb924"
                        ELSE
                           IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                             IF NOT cl_confirm('mfg3469') THEN
                                RETURN "inb924"
                             ELSE
                                LET g_yes = 'Y'
                             END IF
                           ELSE                                       #FUN-B10016 add
                             LET g_yes = 'Y'                          #FUN-B10016 add
                           END IF                                     #FUN-B10016 add
                        END IF
                     END IF
                  END IF
               ELSE
                  IF g_inb[l_ac].inb924 * g_inb[l_ac].inb923 > g_imgg10_1 THEN
                    #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN      #FUN-C80107 mark
                     LET l_flag01 = NULL    #FUN-C80107 add
                  #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING l_flag01   #FUN-C80107 add #FUN-D30024
                     CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING l_flag01 #FUN-D30024 #TQC-DD40078 g_plant
                     IF l_flag01 = 'N' OR l_flag01 IS NULL THEN           #FUN-C80107 add
                        CALL cl_err(g_inb[l_ac].inb924,'mfg1303',1)
                        RETURN "inb924"
                     ELSE
                        IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #FUN-B10016 add
                          IF NOT cl_confirm('mfg3469') THEN
                             RETURN "inb924"
                          ELSE
                             LET g_yes = 'Y'
                          END IF
                        ELSE                                       #FUN-B10016 add
                          LET g_yes = 'Y'                          #FUN-B10016 add 
                        END IF                                     #FUN-B10016 add
                     END IF
                  END IF
               END IF
            END IF
         END IF
 
         LET g_inb[l_ac].inb902 = g_inb[l_ac].inb922   #MOD-9B0146
         LET g_inb[l_ac].inb903 = g_inb[l_ac].inb923   #MOD-9B0146
         LET g_inb[l_ac].inb904 = g_inb[l_ac].inb924
         DISPLAY BY NAME g_inb[l_ac].inb924
 
         CALL t370_du_data_to_correct2()
         CALL t370_set_origin_field2()
         CALL t370_set_origin_field()   #MOD-9B0146
         IF g_inb[l_ac].inb16 IS NULL OR g_inb[l_ac].inb16=0 THEN
            IF g_ima906 MATCHES '[23]' THEN
               RETURN "inb927"
            ELSE
               RETURN "inb924"
            END IF
         END IF
      END IF
      #FUN-C20047-add-str--
      IF NOT t370_inb09_chk(p_cmd) THEN 
         RETURN 'inb924'
      END IF
      #FUN-C20047-add-end--
   END IF                                    #FUN-C20047
   CALL cl_show_fld_cont()                   #No.FUN-560197
   RETURN NULL
END FUNCTION

#FUN-C20047-add-str--
FUNCTION t370_inb09_chk(p_cmd)
DEFINE l_inb09    LIKE inb_file.inb09
DEFINE p_cmd      LIKE type_file.chr1
DEFINE l_flag     LIKE type_file.chr1
DEFINE l_factor   LIKE type_file.num5
DEFINE l_sum      LIKE qco_file.qco11

   IF g_sma.sma115 ='Y' THEN 
      IF NOT cl_null(g_inb[l_ac].inb924) AND NOT cl_null(g_inb[l_ac].inb44) AND NOT cl_null(g_inb[l_ac].inb927) THEN
         IF g_inb_t.inb924 IS NULL OR (p_cmd ='u' AND g_inb_t.inb924 != g_inb[l_ac].inb924) THEN
            CALL s_umfchk(g_inb[l_ac].inb04,g_inb[l_ac].inb925,g_inb[l_ac].inb08) RETURNING l_flag,l_factor
            IF l_flag = 1 THEN
               LET l_factor = 1
            END IF           
            LET l_inb09 = g_inb[l_ac].inb927 * l_factor + g_inb[l_ac].inb924
            CALL t370_sum(p_cmd) RETURNING l_sum
            IF l_inb09 > l_sum THEN
               CALL cl_err('','apm-804',0) 
               RETURN  FALSE
            ELSE
               LET g_inb[l_ac].inb16 = l_inb09
            END IF         
         END IF
      END IF
   ELSE
      IF NOT cl_null(g_inb[l_ac].inb16) AND NOT cl_null(g_inb[l_ac].inb44) THEN
         IF g_inb_t.inb16 IS NULL OR (p_cmd ='u' AND g_inb_t.inb16 != g_inb[l_ac].inb16) THEN
            CALL t370_sum(p_cmd) RETURNING l_sum
            IF g_inb[l_ac].inb16 > l_sum THEN 
               CALL cl_err('','apm-804',0)
               RETURN  FALSE
            END IF
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-C20047-add-end-

 
FUNCTION t370_chk_inb15()
   DEFINE l_acti LIKE azf_file.azfacti
   DEFINE l_azf09  LIKE azf_file.azf09   #FUN-930145
   DEFINE l_ima15  LIKE ima_file.ima15   #No.CHI-950013           
   DEFINE l_n       LIKE type_file.num5,    #FUN-CB0087
          l_sql     STRING,                 #FUN-CB0087
          l_where   STRING,                 #FUN-CB0087
          l_flag    LIKE type_file.chr1     #FUN-CB0087

   LET g_buf=NULL #MOD-570299
   IF NOT cl_null(g_inb[l_ac].inb15) THEN
      #FUN-CB0087---add---str
      #MOD-D60002--mark begin------------#MOD-E40087 remark begin----------
      LET l_n = 0
      CALL s_get_where(g_ina.ina01,'','',g_inb[l_ac].inb04,g_inb[l_ac].inb05,g_ina.ina11,g_ina.ina04) RETURNING l_flag,l_where
      #IF g_aza.aza115='Y' AND l_flag THEN  #MOD-D40091
      IF l_flag THEN  #MOD-D40091
         LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_inb[l_ac].inb15,"' AND ",l_where
         PREPARE ggc08_pre FROM l_sql
         EXECUTE ggc08_pre INTO l_n
         IF l_n < 1 THEN
            CALL cl_err('','aim-425',0)
            RETURN FALSE
         END IF
         IF l_n > 0 THEN
            SELECT azf03 INTO g_buf FROM azf_file WHERE azf01=g_inb[l_ac].inb15 AND azf02='2'
         END IF
      ELSE
      #MOD-D60002--mark end------------#MOD-E40087 remark end-----------------
      #FUN-CB0087---add---end
         SELECT ima15 INTO l_ima15 FROM ima_file                                                                                       
          WHERE ima01 = g_inb[l_ac].inb04                                                                                              
            AND imaacti = 'Y'                                                                                                          
         IF STATUS THEN                                                                                                                
            CALL cl_err3("sel","ima_file",g_inb[l_ac].inb04,"",STATUS,"",                                                              
                         "select ima15",1) 
            LET g_errno = STATUS                          #FUN-B10016 add                                                                                            
            RETURN FALSE                                                                                                               
         END IF                                                                                                                        
         IF g_sma.sma79='Y' AND l_ima15 = 'Y' THEN        #使用保稅系統且為保稅料件                                                     
            IF cl_null(g_inb[l_ac].inb15) THEN RETURN FALSE END IF
            #SELECT azf03 INTO g_buf FROM azf_file  #CHI-C40009
            SELECT azf03,azfacti INTO g_buf,l_acti FROM azf_file  #CHI-C40009
             WHERE azf01=g_inb[l_ac].inb15 AND azf02='A'                   #MOD-AC0115 mark #CHI-C40009
             #WHERE azf01=g_inb[l_ac].inb15 AND (azf02='A' OR azf02='2')    #MOD-AC0115 add  #CHI-C40009
             IF STATUS THEN
                CALL cl_err3("sel","azf_file",g_inb[l_ac].inb15,"",STATUS,"",
                             "select azf",1)  #No.FUN-660156
                LET g_errno = STATUS                                       #FUN-B10016 add
                RETURN FALSE
             END IF
         ELSE
             #SELECT azf03 INTO g_buf FROM azf_file  #CHI-C40009
            SELECT azf03,azfacti INTO g_buf,l_acti FROM azf_file  #CHI-C40009
             WHERE azf01=g_inb[l_ac].inb15 AND azf02='2' #6818
            IF STATUS THEN
               CALL cl_err3("sel","azf_file",g_inb[l_ac].inb15,"",STATUS,"",
                            "select azf",1)  #No.FUN-660156
               LET g_errno = STATUS                                       #FUN-B10016 add
               RETURN FALSE
            END IF
            SELECT azf09 INTO l_azf09 FROM azf_file
             WHERE azf01=g_inb[l_ac].inb15 AND azf02='2'
            IF l_azf09 != '4' OR cl_null(l_azf09) THEN  #TQC-970197
               CALL cl_err('','aoo-403',0)
               LET g_errno = 'aoo-403'                                    #FUN-B10016 add
               RETURN FALSE
            END IF
         END IF
      END IF                                            #FUN-CB0087  #MOD-D60002 mark  ##MOD-E40087 remark
   ELSE
      IF g_smy.smy59 = 'Y' THEN
         CALL cl_err('','apj-201',0)
         LET g_errno = 'apj-201'                                        #FUN-B10016 add
         RETURN FALSE
      END IF
   END IF
   LET g_inb[l_ac].azf03=g_buf #MOD-570299
   DISPLAY g_inb[l_ac].azf03 TO FORMONLY.azf03 #MOD-570299  #FUN-810045
   #MOD-4B0074判斷理由碼是否為"失效",失效情況下則不能輸入
   #SELECT azfacti INTO l_acti FROM azf_file WHERE azf01 = g_inb[l_ac].inb15     #CHI-C40009
   #                                           AND (azf02='A' OR azf02='2')      #MOD-B60188 add #CHI-C40009
   IF l_acti <> 'Y' THEN
#     CALL cl_err('','apy-541',1)               #CHI-B40058 mark
#     LET g_errno = 'apy-541'                   #FUN-B10016 add  #CHI-B40058
     #MOD-EC0007------mod---str---
     #CALL cl_err('','aim-163',1)                #CHI-B40058
     #LET g_errno = 'aim-163'                    #CHI-B40058
      CALL cl_err('','aim-946',1)                #CHI-B40058
      LET g_errno = 'aim-946'                    #CHI-B40058
     #MOD-EC0007------mod---end---
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_inb901()
   DEFINE l_coc10 LIKE coc_file.coc10
   DEFINE l_ima08 LIKE ima_file.ima08
   IF NOT cl_null(g_inb[l_ac].inb901) THEN
      SELECT coc10 INTO l_coc10 FROM coc_file
       WHERE coc03 = g_inb[l_ac].inb901
      IF STATUS THEN
         CALL cl_err3("sel","coc_file",g_inb[l_ac].inb901,"","aco-062","",
                      "",1)  #No.FUN-660156
         LET g_errno = 'aco-062'                   #FUN-B10016 add
         RETURN FALSE
      END IF
      SELECT ima08 INTO l_ima08 FROM ima_file
       WHERE ima01 = g_inb[l_ac].inb04
      LET g_cnt=0
      #檢查成品檔
      IF l_ima08 MATCHES '[MS]' THEN
         SELECT COUNT(*) INTO g_cnt FROM coc_file,cod_file,coa_file
          WHERE coc01 = cod01 AND cod03 = coa03
            AND coa05 = l_coc10
            AND coa01 = g_inb[l_ac].inb04
            AND coc03 = g_inb[l_ac].inb901
      END IF
      #檢查材料檔
      IF l_ima08 = 'P' THEN
         SELECT COUNT(*) INTO g_cnt FROM coc_file,coe_file,coa_file
          WHERE coc01 = coe01 AND coe03 = coa03
            AND coa05 = l_coc10
            AND coa01 = g_inb[l_ac].inb04
            AND coc03 = g_inb[l_ac].inb901
      END IF
      IF g_cnt = 0 THEN
         CALL cl_err(g_inb[l_ac].inb901,'aco-073',0)
         LET g_errno = 'aco-073'                   #FUN-B10016 add
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_chk_inb930()
   IF NOT s_costcenter_chk(g_inb[l_ac].inb930) THEN
      LET g_inb[l_ac].inb930=g_inb_t.inb930
      LET g_inb[l_ac].gem02c=g_inb_t.gem02c
      DISPLAY BY NAME g_inb[l_ac].inb930,g_inb[l_ac].gem02c
      RETURN FALSE
   ELSE
      LET g_inb[l_ac].gem02c=s_costcenter_desc(g_inb[l_ac].inb930)
      DISPLAY BY NAME g_inb[l_ac].gem02c
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_b_del()
   DELETE FROM inb_file
    WHERE inb01 = g_ina.ina01 AND inb03 = g_inb_t.inb03 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","inb_file",g_inb_t.inb03,"",SQLCA.sqlcode,"",
                   "",1)  #No.FUN-660156
      RETURN FALSE
   END IF

   
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_b_updchk()
   IF g_sma.sma115 = 'Y' THEN
      CALL s_chk_va_setting(g_inb[l_ac].inb04)
           RETURNING g_flag,g_ima906,g_ima907
      IF g_flag=1 THEN
         RETURN "inb04"
      END IF
 
      CALL t370_du_data_to_correct()
      CALL t370_du_data_to_correct2()  #FUN-870040
 
      IF t370_qty_issue() THEN
         IF g_ima906 MATCHES '[23]' THEN
            RETURN "inb907"
         ELSE
            RETURN "inb904"
         END IF
      END IF
 
      CALL t370_set_origin_field()
   END IF
 
   IF NOT cl_null(g_inb[l_ac].inb911) THEN
      CALL t370_inb911()
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_inb[l_ac].inb911,g_errno,0)
         RETURN "inb911"
      END IF
      IF NOT cl_null(g_inb[l_ac].inb912) THEN
         CALL t370_inb912()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_inb[l_ac].inb912,g_errno,0)
            RETURN "inb912"
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_b_upd()
   UPDATE inb_file SET * = b_inb.*
    WHERE inb01=g_ina.ina01 AND inb03=g_inb_t.inb03 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","inb_file",g_ina.ina01,g_inb_t.inb03,SQLCA.sqlcode,"",
                   "upd inb",1)  #No.FUN-660156
      LET g_inb[l_ac].* = g_inb_t.*
      RETURN FALSE
   END IF
   
   RETURN TRUE
END FUNCTION
 
FUNCTION t370_b_move_to()
 #IF g_azw.azw04='2' AND (g_prog="aimt301_slk" OR g_prog="aimt302_slk" OR g_prog="aimt303_slk") THEN #   #FUN-D60112-add  #MOD-E90053 mark
  IF g_azw.azw04='2' AND (g_prog="aimt301_slk" OR g_prog="aimt302_slk" OR g_prog="aimt303_slk") AND g_sma.sma150='N' THEN #MOD-E90053 add
#FUN-C20101----ADD---STR---
ELSE   
#FUN-D60112-add &endif
#FUN-C20101---ADD---END-----   
   LET g_inb[l_ac].inb03 = b_inb.inb03
   LET g_inb[l_ac].inb04 = b_inb.inb04
   LET g_inb[l_ac].inb05 = b_inb.inb05
   LET g_inb[l_ac].inb06 = b_inb.inb06
   LET g_inb[l_ac].inb07 = b_inb.inb07
   LET g_inb[l_ac].inb08 = b_inb.inb08
   LET g_inb[l_ac].inb08_fac = b_inb.inb08_fac
   LET g_inb[l_ac].inb09 = b_inb.inb09
   LET g_inb[l_ac].inb902= b_inb.inb902
   LET g_inb[l_ac].inb903= b_inb.inb903
   LET g_inb[l_ac].inb904= b_inb.inb904
   LET g_inb[l_ac].inb905= b_inb.inb905
   LET g_inb[l_ac].inb906= b_inb.inb906
   LET g_inb[l_ac].inb907= b_inb.inb907
   LET g_inb[l_ac].inb922= b_inb.inb922
   LET g_inb[l_ac].inb923= b_inb.inb923
   LET g_inb[l_ac].inb924= b_inb.inb924
   LET g_inb[l_ac].inb925= b_inb.inb925
   LET g_inb[l_ac].inb926= b_inb.inb926
   LET g_inb[l_ac].inb927= b_inb.inb927
   LET g_inb[l_ac].inb16 = b_inb.inb16
   LET g_inb[l_ac].inb11 = b_inb.inb11
   LET g_inb[l_ac].inb12 = b_inb.inb12
   LET g_inb[l_ac].inb15 = b_inb.inb15
   LET g_inb[l_ac].inb41 = b_inb.inb41
   LET g_inb[l_ac].inb42 = b_inb.inb42
   LET g_inb[l_ac].inb43 = b_inb.inb43
#FUN-BC0104----add----str----
   LET g_inb[l_ac].inb44 = b_inb.inb44
   LET g_inb[l_ac].inb45 = b_inb.inb45
   LET g_inb[l_ac].inb46 = b_inb.inb46
   LET g_inb[l_ac].inb47 = b_inb.inb47
   LET g_inb[l_ac].inb48 = b_inb.inb48
#FUN-BC0104----add----end----
   LET g_inb[l_ac].inb901= b_inb.inb901 #no.A050
   LET g_inb[l_ac].inb930= b_inb.inb930  #FUN-670093
   LET g_inb[l_ac].inb911 = b_inb.inb911
   LET g_inb[l_ac].inb912 = b_inb.inb912
   LET g_inb[l_ac].inbud01 = b_inb.inbud01
   LET g_inb[l_ac].inbud02 = b_inb.inbud02
   LET g_inb[l_ac].inbud03 = b_inb.inbud03
   LET g_inb[l_ac].inbud04 = b_inb.inbud04
   LET g_inb[l_ac].inbud05 = b_inb.inbud05
   LET g_inb[l_ac].inbud06 = b_inb.inbud06
   LET g_inb[l_ac].inbud07 = b_inb.inbud07
   LET g_inb[l_ac].inbud08 = b_inb.inbud08
   LET g_inb[l_ac].inbud09 = b_inb.inbud09
   LET g_inb[l_ac].inbud10 = b_inb.inbud10
   LET g_inb[l_ac].inbud11 = b_inb.inbud11
   LET g_inb[l_ac].inbud12 = b_inb.inbud12
   LET g_inb[l_ac].inbud13 = b_inb.inbud13
   LET g_inb[l_ac].inbud14 = b_inb.inbud14
   LET g_inb[l_ac].inbud15 = b_inb.inbud15
#&endif  #FUN-D60112--mark
 END IF  #FUN-D60112--add
#FUN-C20101----ADD endif------------
END FUNCTION
 
FUNCTION t370_b_move_back()
 IF g_azw.azw04='2' AND (g_prog="aimt301_slk" OR g_prog="aimt302_slk" OR g_prog="aimt303_slk") AND g_sma.sma150='N' THEN    #FUN-D60112-add   #TQC-E10006 add sma150
#FUN-C20101------ADD-----STR----
 ELSE
#FUN-D60112--add &endif
#FUN-C20101------ADD-----END----
   IF g_inb[l_ac].inb11 IS NULL  THEN LET g_inb[l_ac].inb11 = ' ' END IF
   IF g_inb[l_ac].inb12 IS NULL  THEN LET g_inb[l_ac].inb12 = ' ' END IF
   IF g_inb[l_ac].inb901 IS NULL THEN LET g_inb[l_ac].inb901=' '  END IF
 
   LET b_inb.inb03 = g_inb[l_ac].inb03
   LET b_inb.inb04 = g_inb[l_ac].inb04
   LET b_inb.inb05 = g_inb[l_ac].inb05
   LET b_inb.inb06 = g_inb[l_ac].inb06
   LET b_inb.inb07 = g_inb[l_ac].inb07
   LET b_inb.inb08 = g_inb[l_ac].inb08
   LET b_inb.inb08_fac = g_inb[l_ac].inb08_fac
   LET b_inb.inb09 = g_inb[l_ac].inb09
   IF g_action_choice = 'over_qty' THEN                             #20200317
      LET b_inb.inb09 = g_inb[l_ac].inb16 + g_inb[l_ac].inbud07     #20200317
   END IF
   LET b_inb.inb902= g_inb[l_ac].inb902
   LET b_inb.inb903= g_inb[l_ac].inb903
   LET b_inb.inb904= g_inb[l_ac].inb904
   LET b_inb.inb905= g_inb[l_ac].inb905
   LET b_inb.inb906= g_inb[l_ac].inb906
   LET b_inb.inb907= g_inb[l_ac].inb907
   LET b_inb.inb922= g_inb[l_ac].inb922
   LET b_inb.inb923= g_inb[l_ac].inb923
   LET b_inb.inb924= g_inb[l_ac].inb924
   LET b_inb.inb925= g_inb[l_ac].inb925
   LET b_inb.inb926= g_inb[l_ac].inb926
   LET b_inb.inb927= g_inb[l_ac].inb927
   LET b_inb.inb16 = g_inb[l_ac].inb16
   LET b_inb.inb11 = g_inb[l_ac].inb11
   LET b_inb.inb12 = g_inb[l_ac].inb12
   LET b_inb.inb15 = g_inb[l_ac].inb15
   LET b_inb.inb41 = g_inb[l_ac].inb41
   LET b_inb.inb42 = g_inb[l_ac].inb42
   LET b_inb.inb43 = g_inb[l_ac].inb43
   LET b_inb.inb13 = g_inb[l_ac].inb13    #FUN-BC0062
   LET b_inb.inb14 = g_inb[l_ac].inb14    #FUN-BC0062
#FUN-BC0104----add----str----
   LET b_inb.inb44 = g_inb[l_ac].inb44
   LET b_inb.inb45 = g_inb[l_ac].inb45
   LET b_inb.inb46 = g_inb[l_ac].inb46
   LET b_inb.inb47 = g_inb[l_ac].inb47
   LET b_inb.inb48 = g_inb[l_ac].inb48
#FUN-BC0104----add----end----
   LET b_inb.inb901= g_inb[l_ac].inb901 #no.A050
   LET b_inb.inb10 = g_inb[l_ac].inb10   #No.FUN-5C0077
   LET b_inb.inb930= g_inb[l_ac].inb930  #FUN-670093
   LET b_inb.inb911= g_inb[l_ac].inb911
   LET b_inb.inb912= g_inb[l_ac].inb912
   LET b_inb.inbud01 = g_inb[l_ac].inbud01
   LET b_inb.inbud02 = g_inb[l_ac].inbud02
   LET b_inb.inbud03 = g_inb[l_ac].inbud03
   LET b_inb.inbud04 = g_inb[l_ac].inbud04
   LET b_inb.inbud05 = g_inb[l_ac].inbud05
   LET b_inb.inbud06 = g_inb[l_ac].inbud06
   LET b_inb.inbud07 = g_inb[l_ac].inbud07
   LET b_inb.inbud08 = g_inb[l_ac].inbud08
   LET b_inb.inbud09 = g_inb[l_ac].inbud09
   LET b_inb.inbud10 = g_inb[l_ac].inbud10
   LET b_inb.inbud11 = g_inb[l_ac].inbud11
   LET b_inb.inbud12 = g_inb[l_ac].inbud12
   LET b_inb.inbud13 = g_inb[l_ac].inbud13
   LET b_inb.inbud14 = g_inb[l_ac].inbud14
   LET b_inb.inbud15 = g_inb[l_ac].inbud15
   LET b_inb.inbplant = g_plant #FUN-980004 add
   LET b_inb.inblegal = g_legal #FUN-980004 add

#&endif  #FUN-D60112--mark
 END IF  #FUN-D60112--add
#FUN-C20101----ADD endif------ 
END FUNCTION
 
FUNCTION t370_b_else()
 IF g_azw.azw04='2' AND (g_prog="aimt301_slk" OR g_prog="aimt302_slk" OR g_prog="aimt303_slk") AND g_sma.sma150='N' THEN    #FUN-D60112-add   #TQC-E10006 add
#FUN-C20101-----ADD----STR------
 ELSE
#FUN-D60112-add ELSE
#FUN-C20101-----ADD-----END-----
   IF g_inb[l_ac].inb05 IS NULL THEN LET g_inb[l_ac].inb05 =' ' END IF
   IF g_inb[l_ac].inb06 IS NULL THEN LET g_inb[l_ac].inb06 =' ' END IF
   IF g_inb[l_ac].inb07 IS NULL THEN LET g_inb[l_ac].inb07 =' ' END IF
#&endif  #FUN-D60112--mark
 END IF  #FUN-D60112--add
#FUN-C20101-------ADD---END------   
END FUNCTION
 
FUNCTION t370_out()
    DEFINE l_chk_yn       LIKE type_file.chr1           #DEV-D30026 add
    DEFINE l_prt_yn       LIKE type_file.chr1           #DEV-D30026 add
    DEFINE l_d  LIKE type_file.chr1 #FUN-D90010         #MOD-DA0151 mark #FUN-DC0025 remark

    IF g_ina.ina01 IS NULL THEN RETURN END IF
    LET g_msg = 'ina01= "',g_ina.ina01,'"'

   #DEV-D30026 add str-----------------
    IF g_argv1 ='3' THEN
       SELECT aza131 INTO l_chk_yn FROM aza_file
       IF l_chk_yn IS NULL THEN LET l_chk_yn = 'N' END IF
    ELSE
       LET l_chk_yn = 'N'
    END IF
   #DEV-D30026 add end-----------------
   #MOD-DA0151-Start-Mark
   ##FUN-D90010--add--str--
   #IF s_industry("slk") AND g_sma.sma150 = 'Y' THEN
   #   LET l_d='Y'    #打印款式明細
   #ELSE
   #   LET l_d='N'
   #END IF
   ##FUN-D90010--add--end
   #MOD-DA0151-End-Mark
   
   #FUN-DC0025--add--str--
   IF g_sma.sma150 = 'Y' THEN
      LET l_d = 'Y'
   ELSE
      LET l_d = 'N'
   END IF
   #FUN-DC0025--add--end--
   
    LET g_msg = "aimr300 '",g_today,"' '",g_user,"' '",g_lang,"' ",   #FUN-C30085 mark   #FUN-E50024 remark GR改串CR 
   #LET g_msg = "aimg300 '",g_today,"' '",g_user,"' '",g_lang,"' ",   #FUN-C30085 add    #FUN-E50024 mark GR改串CR 
                " 'Y' ' ' '1' ",
               #" '",g_msg CLIPPED,"' '3' '3' ' ' ' ' ' ' ' ' ' ' 'N' "  ##MOD-8C0189 add CLIPPED #MOD-970121 add '3' '3' ' ' ' ' ' ' ' ' ' ' 'N'  #DEV-D30026 mark
               #" '",g_msg CLIPPED,"' '3' '3' 'N' '",l_chk_yn CLIPPED,"' ' ' ' ' ' ' ' ' "  ##MOD-8C0189 add CLIPPED #MOD-970121 add '3' '3' ' ' ' ' ' ' ' ' ' ' 'N' #DEV-D30026 add  #FUN-D90010  mark #MOD-DA0151 Remark  #FUN-DC0025 mark
                " '",g_msg CLIPPED,"' '",l_d  CLIPPED,"' '3' '3' 'N' '",l_chk_yn CLIPPED,"' ' ' ' ' ' ' ' ' "  #FUN-D90010 add                                                                          #MOD-DA0151 mark    #FUN-DC0025 remark
    CALL cl_cmdrun(g_msg)
END FUNCTION

#FUN-B50138--begin--mark--該FUNCTION沒有在任何地方被調用,故mark 
#FUNCTION t370_s()
#   DEFINE l_cnt     LIKE type_file.num10   #No.FUN-690026 INTEGER
#   DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(400)
#   DEFINE l_inb09   LIKE inb_file.inb09,
#          l_inb04   LIKE inb_file.inb04,
#          l_inb10   LIKE inb_file.inb10,
#          l_qcs01   LIKE qcs_file.qcs01,
#          l_qcs02   LIKE qcs_file.qcs02,
#          l_qcs091c LIKE qcs_file.qcs091
#   DEFINE l_imaag  LIKE ima_file.imaag   #No.FUN-640056
#   DEFINE l_inb  RECORD LIKE inb_file.*  #FUN-6A0007 檢查單身用  
# 
#   IF s_shut(0) THEN RETURN END IF
# 
#   IF g_ina.ina01 IS NULL THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
# 
#   SELECT * INTO g_ina.* FROM ina_file
#    WHERE ina01 = g_ina.ina01  
# 
#   IF g_ina.inaconf = 'N' THEN
#      CALL cl_err('','aba-100',0)
#      RETURN
#   END IF
# 
#   IF g_ina.inapost = 'Y' THEN
#      CALL cl_err('','asf-812',0) #FUN-660079
#      RETURN
#   END IF
# 
#   IF g_ina.inaconf = 'X' THEN #FUN-660079
#      CALL cl_err('',9024,0)
#      RETURN
#   END IF
# 
#   IF g_ina.inamksg = 'Y' THEN
#      IF g_ina.ina08 != '1' THEN
#         CALL cl_err('','aim-317',0)
#         RETURN
#      END IF
#   END IF
# 
#    
#   IF g_sma.sma53 IS NOT NULL AND g_ina.ina02 <= g_sma.sma53 THEN
#      CALL cl_err('','mfg9999',0)
#      RETURN
#   END IF
# 
#   CALL s_yp(g_ina.ina02) RETURNING g_yy,g_mm
# 
#   IF g_yy > g_sma.sma51 THEN      # 與目前會計年度,期間比較
#      CALL cl_err(g_yy,'mfg6090',0)
#      RETURN
#   ELSE
#      IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52 THEN
#         CALL cl_err(g_mm,'mfg6091',0)
#         RETURN
#      END IF
#   END IF
# 
#   IF g_aza.aza23 MATCHES '[Yy]' AND g_ina.inamksg MATCHES '[Yy]' THEN  #FUN-550047
#      IF g_ina.ina08 <> '1' THEN
#         #必須簽核狀況為已核准，才能執行過帳
#         CALL cl_err(g_ina.ina01,'aim-317',1)
#         RETURN
#      END IF
#   END IF
# 
#   LET l_cnt=0
#   SELECT COUNT(*) INTO l_cnt
#     FROM inb_file
#    WHERE inb01=g_ina.ina01 
#   IF l_cnt=0 OR l_cnt IS NULL THEN
#      CALL cl_err('','mfg-009',0)
#      RETURN
#   END IF   
# 
#   LET l_sql = " SELECT inb09,inb10,inb04,inb01,inb03 FROM inb_file ",
#               "  WHERE inb01 = '",g_ina.ina01,"'"
# 
#   PREPARE t370_curs1 FROM l_sql
#   DECLARE t370_pre1 CURSOR FOR t370_curs1
# 
#   FOREACH t370_pre1 INTO l_inb09,l_inb10,l_inb04,l_qcs01,l_qcs02
#      IF l_inb10 = 'Y' THEN
#         LET l_qcs091c = 0
#         SELECT SUM(qcs091) INTO l_qcs091c
#           FROM qcs_file
#          WHERE qcs01 = l_qcs01
#            AND qcs02 = l_qcs02
#            AND qcs14 = 'Y'
# 
#         IF l_qcs091c IS NULL THEN
#            LET l_qcs091c = 0
#         END IF
# 
#         SELECT imaag INTO l_imaag FROM ima_file
#          WHERE ima01 =l_inb04
#         IF NOT cl_null(l_imaag) AND l_imaag <> '@CHILD' THEN #FUN-640245
#            CALL cl_err(l_inb04,'aim1004',1)
#            RETURN
#         END IF
# 
#         IF l_inb09 > l_qcs091c THEN
#            CALL cl_err(l_inb04,'mfg3558',1)
#            RETURN
#         END IF
#      END IF
#   END FOREACH
# 
#   #FUN-6A0007...............begin 檢查單身的來源訂單料及雜收發報癈料與bom的關係
#   DECLARE t370_s_cs CURSOR FOR
#    SELECT * FROM inb_file WHERE inb01 = g_ina.ina01 
#       AND inb911 IS NOT NULL AND inb912 IS NOT NULL
#   FOREACH t370_s_cs INTO l_inb.*
#     CALL t370_chk_oeb04(l_inb.inb911,l_inb.inb912)
#     CALL t370_chk_inb04(l_inb.inb911,l_inb.inb912,l_inb.inb04)
#   END FOREACH
# 
#   IF NOT cl_confirm('mfg0176') THEN
#      RETURN
#   END IF
# 
#   LET g_success = 'Y'
# 
#   BEGIN WORK
# 
#   OPEN t370_cl USING g_ina.ina01
#   IF STATUS THEN
#      CALL cl_err("OPEN t370_cl:", STATUS, 1)
#      CLOSE t370_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH t370_cl INTO g_ina.*          # 鎖住將被更改或取消的資料
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)     # 資料被他人LOCK
#      CLOSE t370_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   CALL t370_s1()
# 
#   IF SQLCA.SQLCODE THEN
#      LET g_success = 'N'
#   END IF
# 
#   IF g_success = 'Y' THEN
#      UPDATE ina_file SET inapost = 'Y'
#       WHERE ina01=g_ina.ina01 
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err3("upd","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"",
#                      "upd inapost",1)  #No.FUN-660156
#         ROLLBACK WORK
#         RETURN
#      END IF
# 
#      LET g_ina.inapost='Y'
#      LET g_ina.ina08='1'              #FUN-550047
#      DISPLAY BY NAME g_ina.inapost
#      DISPLAY BY NAME g_ina.ina08        #FUN-550047
#      COMMIT WORK
#      CALL cl_flow_notify(g_ina.ina01,'S')
#   ELSE
#      LET g_ina.inapost='N'
#      ROLLBACK WORK
#   END IF
# 
#   IF (g_ina.inapost = "N") THEN
#      DECLARE t370_s1_c2 CURSOR FOR SELECT * FROM inb_file
#                                     WHERE inb01 = g_ina.ina01 
# 
#      LET g_imm01 = ""
#      LET g_success = "Y"
# 
#      CALL s_showmsg_init()   #No.FUN-6C0083
# 
#      BEGIN WORK
# 
#      FOREACH t370_s1_c2 INTO b_inb.*
#         IF STATUS THEN
#            EXIT FOREACH
#         END IF
#         IF g_sma.sma115 = 'Y' THEN
#            IF g_ima906 = '2' THEN  #子母單位
# 
#               LET g_unit_arr[1].unit= b_inb.inb902
#               LET g_unit_arr[1].fac = b_inb.inb903
#               LET g_unit_arr[1].qty = b_inb.inb904
#               LET g_unit_arr[2].unit= b_inb.inb905
#               LET g_unit_arr[2].fac = b_inb.inb906
#               LET g_unit_arr[2].qty = b_inb.inb907
#               IF g_ina.ina00 MATCHES '[1256]' THEN
#                  CALL s_dismantle(g_ina.ina01,b_inb.inb03,g_ina.ina03,
#                                   b_inb.inb04,b_inb.inb05,b_inb.inb06,
#                                   b_inb.inb07,g_unit_arr,g_imm01)
#                         RETURNING g_imm01
#                  IF g_success='N' THEN    #No.FUN-6C0083
#                     LET g_totsuccess='N'
#                     LET g_success="Y"
#                     CONTINUE FOREACH
#                  END IF
#               END IF
#            END IF
#         END IF
#      END FOREACH
# 
#      IF g_totsuccess="N" THEN    #TQC-620156
#         LET g_success="N"
#      END IF
#      CALL s_showmsg()
# 
#      IF g_success = "Y" AND NOT cl_null(g_imm01) THEN
#         COMMIT WORK
#         LET g_msg="aimt324 '",g_imm01,"'"
#         CALL cl_cmdrun_wait(g_msg)
#      ELSE
#         ROLLBACK WORK
#      END IF
#   END IF
# 
#   CALL t370_pic() #FUN-720002
#   MESSAGE ''
# 
#END FUNCTION
#FUN-B50138--end--mark------ 
 
#FUNCTION t370_x()        #CHI-D20010
FUNCTION t370_x(p_type)   #CHI-D20010
#FUN-BC0104-add-str--
DEFINE l_inb44      LIKE inb_file.inb44,
       l_inb45      LIKE inb_file.inb45,
       l_inb46      LIKE inb_file.inb46,
       l_inb47      LIKE inb_file.inb47,
       l_inb48      LIKE inb_file.inb48, 
       l_qcl05      LIKE qcl_file.qcl05,
       l_qty        LIKE qco_file.qco20,
       l_inb09      LIKE inb_file.inb09,
       l_inb1005    LIKE inb_file.inb1005
#FUN-BC0104-add-end--
DEFINE l_flagg  LIKE type_file.chr1         #FUN-C40016
DEFINE l_type1  LIKE type_file.chr1         #FUN-C40016
DEFINE l_inb03  LIKE inb_file.inb03         #FUN-C40016
DEFINE l_flag1  LIKE type_file.chr1  #CHI-D20010
DEFINE p_type   LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_ina.* FROM ina_file WHERE ina01=g_ina.ina01
   IF g_ina.ina01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_ina.inapost = 'Y' THEN CALL cl_err('','asf-812',0) RETURN END IF #FUN-660079
   IF g_ina.inaconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660079
   IF g_ina.ina08 MATCHES '[Ss1]' THEN   #FUN-550047
       CALL cl_err('','mfg3557',0)
       RETURN
   END IF
 
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_ina.inaconf ='X' THEN RETURN END IF
   ELSE
      IF g_ina.inaconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
 
    OPEN t370_cl USING g_ina.ina01
    IF STATUS THEN
       CALL cl_err("OPEN t370_cl:", STATUS, 1)
       CLOSE t370_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t370_cl INTO g_ina.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t370_cl ROLLBACK WORK RETURN
    END IF
    IF g_ina.inaconf = 'X' THEN  LET l_flag1 = 'X' ELSE LET l_flag1 = 'N' END IF #CHI-D20010
    #FUN-D40032--add--str--
    IF g_ina.inaconf='X' AND NOT cl_null(g_sma.sma53) AND g_ina.ina02 <= g_sma.sma53 THEN
       CALL cl_err('','alm1393',0)
       RETURN
    END IF
    #FUN-D40032--add--end--
    #====>01/08/01mandy作廢/作廢還原功能
   # Prog. Version..: '5.30.24-17.04.13(0,0,g_ina.inaconf) THEN #FUN-660079 post->conf  #CHI-D20010
    IF cl_void(0,0,l_flag1) THEN #FUN-660079 post->conf         #CHI-D20010
        LET g_chr = g_ina.inaconf #FUN-660079 post->conf
   #    IF g_ina.inaconf = 'N' THEN #FUN-660079 post->conf   #CHI-D20010
        IF p_type = 1 THEN    #CHI-D20010
            LET g_ina.inaconf = 'X' #FUN-660079 post->conf
	    LET g_ina.ina08 = '9'    #FUN-550047
        ELSE
            LET g_ina.inaconf = 'N' #FUN-660079 post->conf
            LET g_ina.ina08 = '0'    #FUN-550047
        END IF
        #MOD-C30533---------mark-----------str-----
        ##FUN-BC0104----add----str----
        #DECLARE inb_cur2 CURSOR FOR 
        # SELECT inb09,inb44,inb45,inb46,inb47,inb48,inb1005 
        #   FROM inb_file
        #  WHERE inb01 = g_ina.ina01
        #FOREACH inb_cur2 INTO l_inb09,l_inb44,l_inb45,l_inb46,l_inb47,l_inb48,l_inb1005
        #   LET l_qcl05=''
        #   LET l_qty =0
        #   SELECT qcl05 INTO l_qcl05 FROM qcl_file WHERE qcl01 = l_inb46
        #   IF NOT cl_null(l_qcl05) THEN 
        #      IF l_qcl05 ='1' THEN
        #         LET l_qty = l_inb1005
        #      ELSE
        #         LET l_qty = l_inb09 
        #      END IF
        #      UPDATE qco_file SET qco20 = qco20-l_qty
        #       WHERE qco01 = l_inb44 
        #         AND qco02 = l_inb45
        #         AND qco04 = l_inb47
        #         AND qco05 = l_inb48
        #      IF SQLCA.sqlcode THEN
        #         CALL cl_err3("upd","qco_file",g_ina.ina01,"",STATUS,"","upd qco20:",1)
        #         ROLLBACK WORK
        #         RETURN      
        #      END IF 
        #   END IF  
        #END FOREACH
        #UPDATE inb_file
        #   SET inb44 ='',
        #       inb45 ='',
        #       inb46 ='',
        #       inb47 ='',
        #       inb48 =''
        # WHERE inb01 = g_ina.ina01        
        #IF SQLCA.sqlcode THEN
        #   CALL cl_err3("upd","qco_file",g_ina.ina01,"",STATUS,"","upd inb44,inb45,inb46,inb47,inb48:",1)
        #   ROLLBACK WORK
        #   RETURN
        #END IF
        ##FUN-BC0104----add----end----
        #MOD-C30533--------------mark--------end--------
 
        UPDATE ina_file
            SET inaconf = g_ina.inaconf, #FUN-660079 post->conf
                ina08   = g_ina.ina08,  #FUN-550047
                inamodu = g_user,
                inadate = g_today
            WHERE ina01 = g_ina.ina01 
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"",
                        "up inaconf",1)  #No.FUN-660156
           ROLLBACK WORK    #TQC-680036 add
           RETURN           #TQC-680036 add
        #FUN-C40016----------mark----------str----------
        ##MOD-C30533----add---str---
        #ELSE
        #   DECLARE inb_cur2 CURSOR FOR
        #    SELECT inb09,inb44,inb45,inb46,inb47,inb48,inb1005
        #      FROM inb_file
        #     WHERE inb01 = g_ina.ina01
        #   FOREACH inb_cur2 INTO l_inb09,l_inb44,l_inb45,l_inb46,l_inb47,l_inb48,l_inb1005
        #      LET l_qcl05=''
        #      LET l_qty =0
        #      SELECT qcl05 INTO l_qcl05 FROM qcl_file WHERE qcl01 = l_inb46
        #      IF NOT cl_null(l_qcl05) THEN
        #         IF l_qcl05 ='1' THEN
        #            LET l_qty = l_inb1005
        #         ELSE
        #            LET l_qty = l_inb09
        #         END IF
        #         UPDATE qco_file SET qco20 = qco20-l_qty
        #          WHERE qco01 = l_inb44
        #            AND qco02 = l_inb45
        #            AND qco04 = l_inb47
        #            AND qco05 = l_inb48
        #         IF SQLCA.sqlcode THEN
        #            CALL cl_err3("upd","qco_file",g_ina.ina01,"",STATUS,"","upd qco20:",1)
        #            ROLLBACK WORK
        #            RETURN
        #         END IF
        #      END IF
        #   END FOREACH
        #   UPDATE inb_file
        #      SET inb44 ='',
        #          inb45 ='',
        #          inb46 ='',
        #          inb47 ='',
        #          inb48 =''
        #    WHERE inb01 = g_ina.ina01
        #   IF SQLCA.sqlcode THEN
        #      CALL cl_err3("upd","qco_file",g_ina.ina01,"",STATUS,"","upd inb44,inb45,inb46,inb47,inb48:",1)
        #      ROLLBACK WORK
        #      RETURN
        #   END IF
        ##MOD-C30533----add----str----
        #FUN-C40016----------mark----------end----------
        #FUN-C40016----add----str----
        ELSE
           DECLARE inb_sur2 CURSOR FOR
            SELECT inb03 FROM inb_file WHERE inb01 = g_ina.ina01
           FOREACH inb_sur2 INTO l_inb03
              CALL s_iqctype_inb(g_ina.ina01,l_inb03) RETURNING l_inb44,l_inb45,l_inb46,l_inb48,l_inb47,l_flagg
              IF l_flagg = 'Y' THEN
                 CALL s_qcl05_sel(l_inb46) RETURNING l_qcl05
                 IF l_qcl05='1' THEN LET l_type1='6' ELSE LET l_type1='4' END IF
                 IF NOT s_iqctype_upd_qco20(l_inb44,l_inb45,l_inb48,l_inb47,l_type1) THEN 
                    ROLLBACK WORK
                    RETURN
                 END IF
              END IF
           END FOREACH        
        #FUN-C40016----add----end---- 
          #MOD-FC0120--add--strat--
           SELECT COUNT(*) INTO g_cnt FROM rmd_file WHERE rmd21 = g_ina.ina01
           IF g_cnt > 0 THEN
              UPDATE rmd_file SET rmd21 = NULL WHERE rmd21 = g_ina.ina01
              IF SQLCA.sqlcode THEN
                 ROLLBACK WORK
                 RETURN
              END IF 
           END IF 
          #MOD-FC0120--add--end----
        END IF
        DISPLAY BY NAME g_ina.inaconf,g_ina.ina08 #FUN-550047 #FUN-660079 post->conf
    END IF

   #FUN-B10016 add str -------
   #若有與CRM整合,需回饋CRM單據狀態,表CRM可再重發雜收/發單
    IF NOT cl_null(g_ina.ina10) AND g_ina.ina05 = 'Y' AND g_aza.aza123 MATCHES "[Yy]" THEN
       CALL aws_crmcli('x','restatus','2',g_ina.ina01,'1') RETURNING g_crmStatus,g_crmDesc

       IF g_crmStatus <> 0 THEN
          CALL cl_err(g_crmDesc,'!',1)
          ROLLBACK WORK
          RETURN
       END IF
    END IF
   #FUN-B10016 add end -------

    CLOSE t370_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ina.ina01,'V')
END FUNCTION
 
FUNCTION t370_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ware   LIKE img_file.img02,     #倉庫
            l_loc    LIKE img_file.img03,     #儲
            l_lot    LIKE img_file.img04,     #批
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE inb_file.inb08_fac, #第二轉換率
            l_qty2   LIKE inb_file.inb09,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE inb_file.inb08_fac, #第一轉換率
            l_qty1   LIKE inb_file.inb09,     #第一數量
            p_cmd    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-690026 DECIMAL(16,8)
 
    LET l_item = g_inb[l_ac].inb04
    LET l_ware = g_inb[l_ac].inb05
    LET l_loc  = g_inb[l_ac].inb06
    LET l_lot  = g_inb[l_ac].inb07
    IF cl_null(g_inb[l_ac].inb04) THEN
       RETURN
    END IF
 
    SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item
 
    LET l_img09 = ''   #MOD-A40089 add
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01 = l_item
       AND img02 = l_ware
       AND img03 = l_loc
       AND img04 = l_lot
    IF cl_null(l_img09) THEN LET l_img09 = l_ima25 END IF
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',l_img09,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
    LET l_unit1 = l_img09
    LET l_fac1  = 1
    LET l_qty1  = 0
 
   #IF p_cmd = 'a' OR g_change = 'Y' THEN   #MOD-C70301 mark
    IF p_cmd = 'a' THEN                     #MOD-C70301 add
       LET g_inb[l_ac].inb905=l_unit2
       LET g_inb[l_ac].inb906=l_fac2
       LET g_inb[l_ac].inb907=l_qty2
       LET g_inb[l_ac].inb902=l_unit1
       LET g_inb[l_ac].inb903=l_fac1
       LET g_inb[l_ac].inb904=l_qty1
       LET g_inb[l_ac].inb925=l_unit2  #FUN-870040
       LET g_inb[l_ac].inb926=l_fac2  #FUN-870040
       LET g_inb[l_ac].inb927=l_qty2  #FUN-870040
       LET g_inb[l_ac].inb922=l_unit1  #FUN-870040
       LET g_inb[l_ac].inb923=l_fac1  #FUN-870040
       LET g_inb[l_ac].inb924=l_qty1  #FUN-870040
    END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t370_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE inb_file.inb906,
            l_qty2   LIKE inb_file.inb907,
            l_fac1   LIKE inb_file.inb903,
            l_qty1   LIKE inb_file.inb904,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-690026 DECIMAL(16,8)
 
    IF g_sma.sma115='N' THEN RETURN END IF
    LET l_fac2=g_inb[l_ac].inb906
    LET l_qty2=g_inb[l_ac].inb907
    LET l_fac1=g_inb[l_ac].inb903
    LET l_qty1=g_inb[l_ac].inb904
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_inb[l_ac].inb08=g_inb[l_ac].inb902
                   LET g_inb[l_ac].inb08_fac=l_fac1
                   LET g_inb[l_ac].inb09=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_inb[l_ac].inb08=g_img09
                   LET g_inb[l_ac].inb08_fac=1
                   LET g_inb[l_ac].inb09=l_tot
                   LET g_inb[l_ac].inb09=s_digqty(g_inb[l_ac].inb09,g_inb[l_ac].inb08)   #FUN-BB0085
          WHEN '3' LET g_inb[l_ac].inb08=g_inb[l_ac].inb902
                   LET g_inb[l_ac].inb08_fac=l_fac1
                   LET g_inb[l_ac].inb09=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_inb[l_ac].inb906=l_qty1/l_qty2
                   ELSE
                      LET g_inb[l_ac].inb906=0
                   END IF
       END CASE
    END IF
 
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t370_set_origin_field2()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE inb_file.inb926,
            l_qty2   LIKE inb_file.inb927,
            l_fac1   LIKE inb_file.inb923,
            l_qty1   LIKE inb_file.inb924,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-690026 DECIMAL(16,8)
 
    IF g_sma.sma115='N' THEN RETURN END IF
    LET l_fac2=g_inb[l_ac].inb926
    LET l_qty2=g_inb[l_ac].inb927
    LET l_fac1=g_inb[l_ac].inb923
    LET l_qty1=g_inb[l_ac].inb924
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_inb[l_ac].inb08=g_inb[l_ac].inb922
                   LET g_inb[l_ac].inb08_fac=l_fac1
                   LET g_inb[l_ac].inb16=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_inb[l_ac].inb08=g_img09
                   LET g_inb[l_ac].inb08_fac=1
                   LET g_inb[l_ac].inb16=l_tot
          WHEN '3' LET g_inb[l_ac].inb08=g_inb[l_ac].inb922
                   LET g_inb[l_ac].inb08_fac=l_fac1
                   LET g_inb[l_ac].inb16=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_inb[l_ac].inb926=l_qty1/l_qty2
                   ELSE
                      LET g_inb[l_ac].inb926=0
                   END IF
       END CASE
    END IF
    LET g_inb[l_ac].inb16 = s_digqty(g_inb[l_ac].inb16,g_inb[l_ac].inb08)    #FUN-BB0085
 
END FUNCTION
 
#以img09單位來計算雙單位所確定的數量
FUNCTION t370_tot_by_img09(p_item,p_fac2,p_qty2,p_fac1,p_qty1)
  DEFINE p_item    LIKE ima_file.ima01
  DEFINE p_fac2    LIKE inb_file.inb903
  DEFINE p_qty2    LIKE inb_file.inb904
  DEFINE p_fac1    LIKE inb_file.inb903
  DEFINE p_qty1    LIKE inb_file.inb904
  DEFINE l_ima906  LIKE ima_file.ima906
  DEFINE l_ima907  LIKE ima_file.ima907
  DEFINE l_tot     LIKE img_file.img10
 
    SELECT ima906,ima907 INTO l_ima906,l_ima907
      FROM ima_file WHERE ima01 = p_item
 
    IF cl_null(p_fac2) THEN LET p_fac2 = 1 END IF
    IF cl_null(p_qty2) THEN LET p_qty2 = 0 END IF
    IF cl_null(p_fac1) THEN LET p_fac1 = 1 END IF
    IF cl_null(p_qty1) THEN LET p_qty1 = 0 END IF
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=p_qty1*p_fac1
          WHEN '2' LET l_tot=p_qty1*p_fac1+p_qty2*p_fac2
          WHEN '3' LET l_tot=p_qty1*p_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=p_qty1*p_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    RETURN l_tot
 
END FUNCTION
 
#計算庫存總量是否滿足所輸入數量
FUNCTION t370_check_inventory_qty()
  DEFINE l_img10    LIKE img_file.img10
  DEFINE l_tot      LIKE img_file.img10
  DEFINE l_flag     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    LET l_flag = '1'
    SELECT img10 INTO l_img10 FROM img_file
     WHERE img01 = g_inb[l_ac].inb04
       AND img02 = g_inb[l_ac].inb05
       AND img03 = g_inb[l_ac].inb06
       AND img04 = g_inb[l_ac].inb07
 
    CALL t370_tot_by_img09(g_inb[l_ac].inb04,g_inb[l_ac].inb906,g_inb[l_ac].inb907,
                           g_inb[l_ac].inb903,g_inb[l_ac].inb904)
         RETURNING l_tot
    IF l_img10 < l_tot THEN
       LET l_flag = '0'
    END IF
    RETURN l_flag
END FUNCTION
 
#檢查發料/報廢動作是否可以進行下去
FUNCTION t370_qty_issue()
 
    IF g_ina.ina00 MATCHES "[1256]" THEN
       CALL t370_check_inventory_qty()  RETURNING g_flag
       IF g_flag = '0' THEN
         #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN    #FUN-C80107 mark
          LET l_flag01 = NULL    #FUN-C80107 add
         #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING l_flag01   #FUN-C80107 add  #FUN-D30024
          CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING l_flag01 #FUN-D30024 #TQC-D40078 g_plant
          IF l_flag01 = 'N' OR l_flag01 IS NULL THEN           #FUN-C80107 add
             CALL cl_err(g_inb[l_ac].inb904,'mfg1303',1)
             LET g_errno = 'mfg1303'                   #FUN-B10016 add
             RETURN 1
          ELSE
             IF g_yes = 'N' THEN
                IF NOT cl_confirm('mfg3469') THEN
                   RETURN 1
                END IF
             END IF
         END IF
       END IF
    END IF
 
    RETURN 0
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t370_du_data_to_correct()
 
   IF cl_null(g_inb[l_ac].inb902) THEN
      LET g_inb[l_ac].inb903 = NULL
      LET g_inb[l_ac].inb904 = NULL
   END IF
 
   IF cl_null(g_inb[l_ac].inb905) THEN
      LET g_inb[l_ac].inb906 = NULL
      LET g_inb[l_ac].inb907 = NULL
   END IF
   DISPLAY BY NAME g_inb[l_ac].inb903
   DISPLAY BY NAME g_inb[l_ac].inb904
   DISPLAY BY NAME g_inb[l_ac].inb906
   DISPLAY BY NAME g_inb[l_ac].inb907
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t370_du_data_to_correct2()
 
   IF cl_null(g_inb[l_ac].inb922) THEN
      LET g_inb[l_ac].inb923 = NULL
      LET g_inb[l_ac].inb924 = NULL
   END IF
 
   IF cl_null(g_inb[l_ac].inb925) THEN
      LET g_inb[l_ac].inb926 = NULL
      LET g_inb[l_ac].inb927 = NULL
   END IF
   DISPLAY BY NAME g_inb[l_ac].inb923
   DISPLAY BY NAME g_inb[l_ac].inb924
   DISPLAY BY NAME g_inb[l_ac].inb926
   DISPLAY BY NAME g_inb[l_ac].inb927
 
END FUNCTION
 
FUNCTION t370_ef()
 
     CALL t370sub_y_chk(g_ina.ina01,g_argv1,'N') #FUN-660079 #FUN-B50138  #TQC-C40079 add N
     IF g_success = "N" THEN
         RETURN
     END IF
 
     CALL aws_condition()      #判斷送簽資料
     IF g_success = 'N' THEN
         RETURN
     END IF
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
 
 IF aws_efcli2(base.TypeInfo.create(g_ina),base.TypeInfo.create(g_inb),'','','','')
 THEN
       LET g_success = 'Y'
      #LET g_ina.ina08 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'  #FUN-F10019 mark
      #FUN-F10019 add(S)
      #重新更新狀態碼顯示
       SELECT ina08 INTO g_ina.ina08 FROM ina_file WHERE ina01 = g_ina.ina01
      #FUN-F10019 add(E)
       DISPLAY BY NAME g_ina.ina08
   ELSE
       LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION t370_ina11(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,             #No:7381
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381
      FROM gen_file
     WHERE gen01 = g_ina.ina11
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd != 'd' THEN                 #No.MOD-940186 add
       LET g_ina.ina04 = l_gen03         #No.MOD-740059 add
    END IF                               #No.MOD-940186 add
    IF cl_null(g_errno)                  #No.MOD-940186 add
    THEN DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
    IF p_cmd = 'd' THEN                                      #MOD-E30014 add 
       DISPLAY l_gen02 TO FORMONLY.gen02                     #MOD-E30014 add
    END IF                                                   #MOD-E30014 add
END FUNCTION
 
FUNCTION t370_refresh_detail()
  DEFINE l_compare          LIKE smy_file.smy62
  DEFINE li_col_count       LIKE type_file.num5    #No.FUN-690026 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5    #No.FUN-690026 SMALLINT
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
 
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' )AND(lg_smy62 IS NOT NULL) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_smy62來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_inb.getLength() = 0 THEN
        LET lg_group = lg_smy62
     ELSE
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_inb.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_inb[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_inb[li_i].att00
         #第一次是賦值
         IF cl_null(lg_group) THEN
            LET lg_group = l_compare
         #以后是比較
         ELSE
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)
           IF l_compare <> lg_group THEN
              LET lg_group = ''
              EXIT FOR
           END IF
         END IF
         IF lg_group <> lg_smy62 THEN
            LET lg_group = ''
            EXIT FOR
         END IF
       END FOR
     END IF
 
     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group
 
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替inb04子料件編號來顯示
     #得到當前語言別下inb04的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file
       WHERE gae01 = 'aimt370' AND gae02 = 'inb04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
 
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'inb04,ima02'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'inb04,ima02'
     END IF
 
     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
     FOR li_i = 1 TO li_col_count
         SELECT agb03 INTO lc_agb03 FROM agb_file
           WHERE agb01 = lg_group AND agb02 = li_i
 
         LET lc_agb03 = lc_agb03 CLIPPED
         SELECT * INTO lr_agc[li_i].* FROM agc_file
           WHERE agc01 = lc_agb03
 
         LET lc_index = li_i USING '&&'
 
         CASE lr_agc[li_i].agc04
           WHEN '1'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
 
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
     END FOR
 
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'
    LET ls_show = 'inb04'
  END IF
 
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
 
END FUNCTION
 
#--------------------在修改下面的代碼前請讀一下注釋先，謝了! -----------------------
 
#下面代碼是從單身INPUT ARRAY語句中的AFTER FIELD段中拷貝來的，因為在多屬性新模式下原來的inb04料件編號
#欄位是要被隱藏起來，并由新增加的imx00（母料件編號）+各個明細屬性欄位來取代，所以原來的AFTER FIELD
#代碼是不會被執行到，需要執行的判斷應該放新增加的几個欄位的AFTER FIELD中來進行，因為要用多次嘛，所以
#單獨用一個FUNCTION來放，順便把inb04的AFTER FIELD也移過來，免得將來維護的時候遺漏了
#下標g_inb[l_ac]都被改成g_inb[p_ac]，請注意
 
#本函數返回TRUE/FALSE,表示檢核過程是否通過，一般說來，在使用過程中應該是如下方式□
#    AFTER FIELD XXX
#        IF NOT t370_check_inb04(.....)  THEN NEXT FIELD XXX END IF
FUNCTION t370_check_inb04(p_field,p_ac)
DEFINE
  p_field                     STRING,    #當前是在哪個欄位中觸發了AFTER FIELD事件
  p_ac                        LIKE type_file.num5,    #g_inb數組中的當前記錄下標  #No.FUN-690026 SMALLINT
 
  l_ps                        LIKE sma_file.sma46,
  l_str_tok                   base.stringTokenizer,
  l_tmp, ls_sql               STRING,
  l_param_list                STRING,
  l_cnt, li_i                 LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  ls_value                    STRING,
  lv_value                    LIKE ima_file.ima01,
  ls_pid,ls_value_fld         LIKE ima_file.ima01,
  ls_name, ls_spec            STRING,
  lc_agb03                    LIKE agb_file.agb03,
  lc_agd03                    LIKE agd_file.agd03,
  ls_pname                    LIKE ima_file.ima02,
  l_misc                      LIKE type_file.chr4,    #VAR CHAR -> CHAR #No.FUN-690026 VARCHAR(04)
  l_n                         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  l_b2                        LIKE ima_file.ima31,
  l_ima25                     LIKE ima_file.ima25,
  l_imaacti                   LIKE ima_file.imaacti,
  l_qty                       LIKE type_file.num10,   #No.FUN-690026 INTEGER
  p_cmd                       STRING,
  l_ima135                    LIKE ima_file.ima135,
  l_ima1002                   LIKE ima_file.ima1002,
  l_ima35                     LIKE ima_file.ima35,
  l_ima36                     LIKE ima_file.ima36,
  l_occ1028                   LIKE occ_file.occ1028,
  l_ima1010                   LIKE ima_file.ima1010,
  l_fac                       LIKE oeb_file.oeb05_fac,
  l_ima140                    LIKE ima_file.ima140,
  l_ima1401                   LIKE ima_file.ima1401,       #FUN-6A0036
  l_imaag                     LIKE ima_file.imaag,         #No.FUN-640056
  l_max                       LIKE tqw_file.tqw07,
  l_check_r                   LIKE type_file.chr1,       #No.FUN-690026 VARCHAR(1)
  l_smy57                     LIKE smy_file.smy57,       #FUN-B30053
  l_ina01                     LIKE ina_file.ina01        #FUN-B30053
  #FUN-C20002--start add-------------------------------------------
  DEFINE l_ima154      LIKE ima_file.ima154
  DEFINE l_rcj03       LIKE rcj_file.rcj03
  DEFINE l_rtz07       LIKE rtz_file.rtz07
  DEFINE l_rtz08       LIKE rtz_file.rtz08
  #FUN-C20002--end add--------------------------------------------- 
  DEFINE l_imf02       LIKE imf_file.imf02 #MOD-C30873
  DEFINE l_imf03       LIKE imf_file.imf03 #MOD-C30873
  DEFINE l_inb05_t     LIKE inb_file.inb05 #MOD-D60227
  #FUN-D70125 add START
  DEFINE l_rcj03_21      LIKE rcj_file.rcj03  #券庫存管理倉庫/卡庫存管理倉庫
  DEFINE l_rtz07_08      LIKE rtz_file.rtz07  #預設成本倉/預設非成本倉
  DEFINE l_f             LIKE type_file.num5  #料號類型標誌0:普通料號,1:券料號,2:卡料號
  #FUN-D70125 add END
   
     #如果當前欄位是新增欄位（母料件編號以及十個明細屬性欄位）的時候，如果全部輸了值則合成出一個
     #新的子料件編號并把值填入到已經隱藏起來的inb04中（如果imxXX能夠顯示，inb04一定是隱藏的）
     #下面就可以直接沿用inb04的檢核邏輯了
     #如果不是，則看看是不是inb04自己觸發了，如果還不是則什么也不做(無聊)，返回一個FALSE
 
     IF ( p_field = 'imx00' )OR( p_field = 'imx01' )OR( p_field = 'imx02' )OR
        ( p_field = 'imx03' )OR( p_field = 'imx04' )OR( p_field = 'imx05' )OR
        ( p_field = 'imx06' )OR( p_field = 'imx07' )OR( p_field = 'imx08' )OR
        ( p_field = 'imx09' )OR( p_field = 'imx10' ) THEN
 
        #首先判斷需要的欄位是否全部完成了輸入（只有母料件編號+被顯示出來的所有明細屬性
        #全部被輸入完成了才進行后續的操作
        LET ls_pid = g_inb[p_ac].att00   # ls_pid 父料件編號
        LET ls_value = g_inb[p_ac].att00   # ls_value 子料件編號
        IF cl_null(ls_pid) THEN
           #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
           #注釋掉
           CALL t370_set_no_entry_b()
           CALL t370_set_required()
 
           RETURN TRUE
        END IF  #注意這里沒有錯，所以返回TRUE
 
        #取出當前母料件包含的明細屬性的個數
        SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 =
           (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)
        IF l_cnt = 0 THEN
           #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
           CALL t370_set_no_entry_b()
           CALL t370_set_required()
 
            RETURN TRUE
        END IF
 
        FOR li_i = 1 TO l_cnt
            #如果有任何一個明細屬性應該輸而沒有輸的則退出
            IF cl_null(arr_detail[p_ac].imx[li_i]) THEN
               #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
               CALL t370_set_no_entry_b()
               CALL t370_set_required()
 
               RETURN TRUE
            END IF
        END FOR
 
        #得到系統定義的標准分隔符sma46
        SELECT sma46 INTO l_ps FROM sma_file
 
        #合成子料件的名稱
        SELECT ima02 INTO ls_pname FROM ima_file   # ls_name 父料件名稱
          WHERE ima01 = ls_pid
        LET ls_spec = ls_pname  # ls_spec 子料件名稱
        #方法□循環在agd_file中找有沒有對應記錄，如果有，就用該記錄的名稱來
        #替換初始名稱，如果找不到則就用原來的名稱
        FOR li_i = 1 TO l_cnt
            LET lc_agd03 = ""
            LET ls_value = ls_value.trim(), l_ps, arr_detail[p_ac].imx[li_i]
            SELECT agd03 INTO lc_agd03 FROM agd_file
             WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = arr_detail[p_ac].imx[li_i]
            IF cl_null(lc_agd03) THEN
               LET ls_spec = ls_spec.trim(),l_ps,arr_detail[p_ac].imx[li_i]
            ELSE
               LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
            END IF
        END FOR
 
        #解析ls_value生成要傳給cl_copy_bom的那個l_param_list
        LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
        LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
        LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                     "ima01 = '",ls_pid CLIPPED,"' AND agb01 = imaag ",
                     "ORDER BY agb02"
        DECLARE param_curs CURSOR FROM ls_sql
        FOREACH param_curs INTO lc_agb03
          #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
          IF cl_null(l_param_list) THEN
             LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()
          ELSE
             LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()
          END IF
        END FOREACH
 
        LET g_value =ls_value
        SELECT count(*) INTO l_n FROM ima_file
         WHERE ima01 = g_value
        IF l_n =0 THEN
           CALL cl_err(ls_value,'atm-523',0)
           RETURN FALSE
        END IF
 
 
        #把生成的子料件賦給inb04，否則下面的檢查就沒有意義了
        LET g_inb[p_ac].inb04 = ls_value
        SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_inb[l_ac].inb04
        IF l_n=0 THEN
           CALL cl_err('inb04','ams-003',1)
           RETURN FALSE
        END IF
     ELSE
       IF ( p_field <> 'inb04' )AND( p_field <> 'imx00' ) THEN
          RETURN FALSE
       END IF
     END IF
 
  #到這里已經完成了以前在cl_itemno_multi_att()中做的所有准備工作，在系統資料庫
  #中已經有了對應的子料件的名稱，下面可以按照inb04進行判斷了
 
  #--------重要 !!!!!!!!!!!-------------------------
  #下面的代碼都是從原INPUT ARRAY中的AFTER FIELD inb04段拷貝來的，唯一做的修改
  #是將原來的NEXT FIELD 語句都改成了RETURN FALSE, xxx,xxx ... ，因為NEXE FIELD
  #語句要交給調用方來做，這里只需要返回一個FALSE告訴它有錯誤就可以了，同時一起
  #返回的還有一些CHECK過程中要從ima_file中取得的欄位信息，其他的比如判斷邏輯和
  #錯誤提示都沒有改，如果你需要在里面添加代碼請注意上面的那個要點就可以了
 
  IF NOT cl_null(g_inb[l_ac].inb04) THEN
     #新增一個判斷,如果lg_smy62不為空,表示當前采用的是料件多屬性的新機制,因此這個函數應該是被
     #attxx這樣的明細屬性欄位的AFTER FIELD來調用的,所以不再使用原來的輸入機制,否則不變
     IF cl_null(lg_smy62) THEN
       IF g_sma.sma120 = 'Y' THEN
          CALL cl_itemno_multi_att("inb04",g_inb[l_ac].inb04,"","1","4")
               RETURNING l_check_r,g_inb[l_ac].inb04,g_inb[l_ac].ima02
          IF l_check_r = '0' THEN
             RETURN FALSE
          END IF
          DISPLAY g_inb[l_ac].inb04 TO inb04
          DISPLAY g_inb[l_ac].ima02 TO ima02
       END IF
     END IF
             #SELECT ima140,ima1401 INTO l_ima140,l_ima1401 FROM ima_file  #FUN-6A0036 add ima1401   #MOD-B90150 mark
              SELECT ima140,ima1401,ima906 INTO l_ima140,l_ima1401,g_ima906   #MOD-B90150
               FROM ima_file                                                  #MOD-B90150
               WHERE ima01=g_inb[l_ac].inb04
              IF (l_ima140 = 'Y' AND l_ima1401 <= g_ina.ina02) AND g_ina.ina00 MATCHES '[34]' THEN
                 CALL cl_err('','aim-809',1)
                 RETURN FALSE                       #20180427 add
              END IF
              IF g_inb_t.inb04 IS NULL OR g_inb[l_ac].inb04 <> g_inb_t.inb04 THEN
                 LET g_change = 'Y'
              END IF
              IF g_inb[l_ac].inb04[1,4]='MISC' THEN  #NO:6808
                  CALL cl_err('','aim-807',1)
                  RETURN FALSE
              END IF
 
            #MOD-740082 若料號無修改不要重抓資料
              IF g_inb_t.inb04 <> g_inb[l_ac].inb04 OR cl_null(g_inb_t.inb04) OR g_inb_t.inb04 = '' THEN
                 SELECT ima02,ima021,ima25,ima36  #,ima24      #No:MOD-A10187 add ima24  #FUN-B30053 delete ima24
                  INTO g_inb[l_ac].ima02,g_inb[l_ac].ima021,l_b2,
                       g_inb[l_ac].inb06  #,g_inb[l_ac].inb10  #No:MOD-A10187 add inb10  #FUN-B30053 delete inb10
                   FROM ima_file WHERE ima01=g_inb[l_ac].inb04 AND imaacti='Y'
                 LET g_ima25 = l_b2   #20200219
                 IF STATUS THEN
                    CALL cl_err3("sel","ima_file",g_inb[l_ac].inb04,"",STATUS,"",
                                 "sel ima",1)  #No.FUN-660156
                    RETURN FALSE
                 END IF
     # No.TQC-AC0122--begin--add
                 IF g_azw.azw04 <> '1' THEN        
                    #FUN-C20002--start add-------------------------------------------
                    IF g_azw.azw04 = '2' THEN
                       #FUN-D70125 mark start
                      #SELECT ima154 INTO l_ima154 
                      #  FROM ima_file
                      # WHERE ima01 = g_inb[l_ac].inb04
                      #IF l_ima154 = 'Y' AND g_inb[l_ac].inb04[1,4] <> 'MISC' THEN
                      #   SELECT rcj03 INTO l_rcj03
                      #     FROM rcj_file 
                      #    WHERE rcj00 = '0'
                    
                      #   #FUN-C90049 mark begin---
                      #   #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
                      #   #  FROM rtz_file
                      #   # WHERE rtz01 = g_plant
                      #   #FUN-C90049 mark end-----

                      #   CALL s_get_defstore(g_plant,g_inb[l_ac].inb04) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add
                     
                      #   IF l_rcj03 = '1' THEN
                      #      LET g_inb[l_ac].inb05 = l_rtz07
                      #   ELSE
                      #      LET g_inb[l_ac].inb05 = l_rtz08
                      #   END IF 
                       #FUN-D70125 mark end
                    #  END IF    # TQC-D60062 mark
                       #FUN-D70125 add start 
                       CALL s_get_store(g_plant,g_inb[l_ac].inb04) RETURNING l_f,l_rcj03_21,l_rtz07_08 
                       IF l_f <> 0 THEN 
                          LET g_inb[l_ac].inb05 = l_rtz07_08         
                       #FUN-D70125 add end  
                       ELSE
                    #FUN-C20002--end add---------------------------------------------

                          #FUN-C90049 mark begin---
                          #SELECT rtz07 INTO g_inb[l_ac].inb05 FROM rtz_file
                          # WHERE rtz01 = g_ina.inaplant
                          #FUN-C90049 mark end-----
                     
                          CALL s_get_coststore(g_ina.inaplant,g_inb[l_ac].inb04) RETURNING g_inb[l_ac].inb05   #FUN-C90049 add
                       END IF               #TQC-D60062  add
                    END IF                  #FUN-C20002  add 
                    IF cl_null(g_inb[l_ac].inb05) THEN
                       SELECT imd01 INTO g_inb[l_ac].inb05 FROM imd_file
                       WHERE imd22 = 'Y' and imd20=g_plant and imd10 = 'S'
                    END IF 
                    IF cl_null(g_inb[l_ac].inb05) THEN
                       SELECT ima35 INTO g_inb[l_ac].inb05 FROM ima_file      
                       WHERE ima01=g_inb[l_ac].inb04 AND imaacti='Y'
                    END IF
                 ELSE 
                 	  LET l_inb05_t = g_inb[l_ac].inb05                   #MOD-D60227
                    SELECT ima35 INTO g_inb[l_ac].inb05 FROM ima_file
                    WHERE ima01=g_inb[l_ac].inb04 AND imaacti='Y'   
                    #MOD-C30873--begin
                    IF cl_null(g_inb[l_ac].inb05) THEN
                       #MOD-D60227--begin
                       IF NOT cl_null(l_inb05_t) THEN 
                          LET g_inb[l_ac].inb05 = l_inb05_t
                       ELSE 
                       #MOD-D60227--end  
                          DECLARE t370_imf02 CURSOR FOR SELECT imf02,imf03 FROM imf_file WHERE imf01 =g_inb[l_ac].inb04
                          FOREACH t370_imf02 INTO l_imf02,l_imf03 
                             EXIT FOREACH 
                          END FOREACH 
                          LET g_inb[l_ac].inb05=l_imf02
                          LET g_inb[l_ac].inb06=l_imf03
                       END IF  #MOD-D60227  add
                    END IF 
                    #MOD-C30873--end       
                 END IF
    # No.TQC-AC0122--edd--add
    # No.TQC-AC0122--begin-mark
   #             IF g_azw.azw04 = '2' THEN        #MOD-AA0034 add
   #                SELECT rtz07 INTO g_inb[l_ac].inb05 FROM rtz_file 
   #                 WHERE rtz01 = g_ina.inaplant  
   #             ELSE                                                      #MOD-AA0034 add 
   #                SELECT ima35 INTO g_inb[l_ac].inb05 FROM ima_file      #MOD-AA0034 add   
   #                 WHERE ima01=g_inb[l_ac].inb04 AND imaacti='Y'         #MOD-AA0034 add  
   #             END IF                                                    #MOD-AA0034 add 
    # No.TQC-AC0122--edd--mark                                               
#FUN-AB0066 --begin--                 
#                 #No.FUN-AA0049--begin
#                 IF NOT s_chk_ware(g_inb[l_ac].inb05) THEN
#                    LET g_inb[l_ac].inb05=' '
#                    LET g_inb[l_ac].inb06=' '
#                 END IF 
#                 #No.FUN-AA0049--end     
#FUN-AB0066 --end---                 
                #str MOD-A40131 add
                #MOD-A60125 mark --begin 
                # IF STATUS THEN
                #    CALL cl_err3("sel","rtz_file",g_inb[l_ac].inb04,"",STATUS,"",
                #                 "sel rtz",1)
                #    RETURN FALSE
                # ELSE  
                #MOD-A60125 mark --end 
                  #檢查倉庫的正確性
                    IF NOT cl_null(g_inb[l_ac].inb05) THEN
                       SELECT imd02 INTO g_buf FROM imd_file
                        WHERE imd01=g_inb[l_ac].inb05 AND imd10=g_imd10
                          AND imdacti = 'Y' #MOD-4B0169
                       IF STATUS THEN
                          LET g_errno = "mfg1100"
                          CALL cl_err3("sel","imd_file",g_inb[l_ac].inb05,g_imd10,"mfg1100","",
                                       "imd",1)  #No:FUN-660156
                          RETURN FALSE
                       END IF
                    END IF
                 #END IF    #MOD-A60125 mark 
                #end MOD-A40131 add
                #CHI-C30125 str add-----  #20200311 mark
                # IF NOT s_chksmz(g_inb[l_ac].inb04, g_ina.ina01,
                #                 g_inb[l_ac].inb05, g_inb[l_ac].inb06) THEN
                #    LET g_inb[l_ac].inb05 =' '
                #    LET g_inb[l_ac].inb06 =' '
                # END IF
                #CHI-C30125 end add-----
                 CALL t370_set_img09() 
                 IF cl_null(g_inb[l_ac].inb08) THEN 
                    LET g_inb[l_ac].inb08 = g_img09 
                    LET g_inb[l_ac].inb09 = s_digqty(g_inb[l_ac].inb09,g_inb[l_ac].inb08)   #FUN-BB0085
                    LET g_inb[l_ac].inb16 = s_digqty(g_inb[l_ac].inb16,g_inb[l_ac].inb08)   #FUN-BB0085
                    DISPLAY BY NAME g_inb[l_ac].inb09,g_inb[l_ac].inb16                     #FUN-BB0085
                 END IF
              END IF   #MOD-740082
              DISPLAY BY NAME g_inb[l_ac].ima02
              DISPLAY BY NAME g_inb[l_ac].ima021
              DISPLAY BY NAME g_inb[l_ac].inb05   #CHI-6A0015
              DISPLAY BY NAME g_inb[l_ac].inb06   #CHI-6A0015
              DISPLAY BY NAME g_inb[l_ac].inb10   #No:MOD-A10187 add
 
 
              SELECT COUNT(*) INTO g_cnt FROM inb_file
               WHERE inb01=g_ina.ina01
                 AND inb03<>g_inb[l_ac].inb03
                 AND inb04=g_inb[l_ac].inb04
 
              IF g_cnt>0 THEN CALL cl_err('','aim-401',0) END IF
 
              IF g_sma.sma115 = 'Y' THEN
                 CALL s_chk_va_setting(g_inb[l_ac].inb04)
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    RETURN FALSE
                 END IF
                 IF g_ima906 = '3' THEN
                    LET g_inb[l_ac].inb905=g_ima907
                 END IF
              END IF
           CALL t370_set_no_entry_b()
           CALL t370_set_required()
           RETURN TRUE
        ELSE
     #如果是由inb04來觸發的,說明當前用的是舊的流程,那么inb04為空是可以的
     #如果是由att00來觸發,原理一樣
           IF ( p_field = 'inb04' )OR( p_field = 'imx00' ) THEN
        #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
              CALL t370_set_no_entry_b()
              CALL t370_set_required()
 
              RETURN TRUE
           ELSE
        #如果不是inb,則是由attxx來觸發的,則非輸不可
              RETURN FALSE
           END IF #如果為空則不允許新增
        END IF
 
END FUNCTION
 
#用于att01~att10這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t370_check_inb04相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t370_check_att0x(p_value,p_index,p_row)
DEFINE
  p_value      LIKE imx_file.imx01,
  p_index      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  p_row        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  li_min_num   LIKE agc_file.agc05,
  li_max_num   LIKE agc_file.agc06,
  l_index      STRING,
 
  l_check_res     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  l_imaacti       LIKE ima_file.imaacti,
  l_ima25         LIKE ima_file.ima25
 
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成inb04料件編號
  IF cl_null(p_value) THEN
     RETURN FALSE
  END IF
 
  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由t370_refresh_detail()函數在較早的時候填充
 
  #判斷長度與定義的使用位數是否相等
  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)
     RETURN FALSE
  END IF
  #比較大小是否在合理范圍之內
  LET li_min_num = lr_agc[p_index].agc05
  LET li_max_num = lr_agc[p_index].agc06
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND
     (p_value < li_min_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE
  END IF
  #通過了欄位檢查則可以下面的合成子料件代碼以及相應的檢核操作了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t370_check_inb04('imx' || l_index ,p_row)
    RETURNING l_check_res
    RETURN l_check_res
END FUNCTION
 
#用于att01_c~att10_c這十個選擇型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t370_check_inb04相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t370_check_att0x_c(p_value,p_index,p_row)
DEFINE
  p_value  LIKE imx_file.imx01,
  p_index  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  p_row    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  l_index  STRING,
 
  l_check_res     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  l_imaacti       LIKE ima_file.imaacti,
  l_ima25         LIKE ima_file.ima25
 
 
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成inb04料件編號
  IF cl_null(p_value) THEN
     RETURN FALSE
  END IF
  #下拉框選擇項相當簡單，不需要進行范圍和長度的判斷，因為肯定是符合要求的了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t370_check_inb04('imx'||l_index,p_row)
    RETURNING l_check_res
  RETURN l_check_res
END FUNCTION
 
FUNCTION t370_spc()
DEFINE l_gaz03        LIKE gaz_file.gaz03
DEFINE l_cnt          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_qc_cnt       LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_inb03        LIKE inb_file.inb03
DEFINE l_qcs          DYNAMIC ARRAY OF RECORD LIKE qcs_file.*
DEFINE l_qc_prog      LIKE zz_file.zz01      #No.FUN-690026 VARCHAR(10)
DEFINE l_i            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_cmd          STRING
DEFINE l_sql          STRING
DEFINE l_err          STRING
 
   LET g_success = 'Y'
 
   #檢查資料是否可拋轉至 SPC
   IF g_ina.inapost matches '[Yy]' THEN    #判斷是否已過帳
      CALL cl_err('inapost','aim-318',0)
      LET g_success='N'
      RETURN
   END IF
 
   #CALL aws_spccli_check('單號','SPC拋轉碼','確認碼','有效碼')
   CALL aws_spccli_check(g_ina.ina01,g_ina.inaspc,g_ina.inaconf,'')
 
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   LET l_qc_prog = "aqct700"               #設定QC單的程式代號
 
   #若在 QC 單已有此單號相關資料，則取消拋轉至 SPC
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_ina.ina01
   IF l_cnt > 0 THEN
      CALL cl_get_progname(l_qc_prog,g_lang) RETURNING l_gaz03
      CALL cl_err_msg(g_ina.ina01,'aqc-115', l_gaz03 CLIPPED || "|" || l_qc_prog CLIPPED,'1')
      LET g_success='N'
      RETURN
   END IF
 
   #需要 QC 檢驗的筆數
   SELECT COUNT(*) INTO l_qc_cnt FROM inb_file
    WHERE inb01 = g_ina.ina01 AND inb10 = 'Y' 
   IF l_qc_cnt = 0 THEN
      CALL cl_err(g_ina.ina01,l_err,0)
      LET g_success='N'
      RETURN
   END IF
 
   #需檢驗的資料，自動新增資料至 QC 單 ,功能參數為「SPC」
   LET l_sql  = "SELECT inb03 FROM inb_file                  WHERE inb01 = '",g_ina.ina01,"' AND inb10='Y'"
   PREPARE t370_inb_p FROM l_sql
   DECLARE t370_inb_c CURSOR WITH HOLD FOR t370_inb_p
   FOREACH t370_inb_c INTO l_inb03
       display l_cmd
       IF g_prog = 'aimt301' OR g_prog = 'aimt311' THEN
          LET l_cmd = l_qc_prog CLIPPED," '",g_ina.ina01,"' '",l_inb03,"' '1' 'SPC' 'A'"
       ELSE
          IF g_prog = 'aimt302' OR g_prog = 'aimt312' THEN
             LET l_cmd = l_qc_prog CLIPPED," '",g_ina.ina01,"' '",l_inb03,"' '1' 'SPC' 'B'"
          END IF
       END IF
       CALL aws_spccli_qc(l_qc_prog,l_cmd)
   END FOREACH
 
   #判斷產生的 QC 單筆數是否正確
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_ina.ina01
   IF l_cnt <> l_qc_cnt THEN
      CALL t370_qcs_del()
      LET g_success='N'
      RETURN
   END IF
 
   LET l_sql  = "SELECT *  FROM qcs_file WHERE qcs01 = '",g_ina.ina01,"'"
   PREPARE t370_qc_p FROM l_sql
   DECLARE t370_qc_c CURSOR WITH HOLD FOR t370_qc_p
   LET l_cnt = 1
   FOREACH t370_qc_c INTO l_qcs[l_cnt].*
       LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_qcs.deleteElement(l_cnt)
 
   # CALL aws_spccli()
   #功能: 傳送此單號所有的 QC 單至 SPC 端
   # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,
   # 回傳值  : 0 傳送失敗; 1 傳送成功
   IF aws_spccli(l_qc_prog,base.TypeInfo.create(l_qcs),"insert") THEN
      LET g_ina.inaspc = '1'
   ELSE
      LET g_ina.inaspc = '2'
      CALL t370_qcs_del()
   END IF
 
   UPDATE ina_file set inaspc = g_ina.inaspc WHERE ina01 = g_ina.ina01 
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ina_file",g_ina.ina01,"",STATUS,"","upd inaspc",1)
      IF g_ina.inaspc = '1' THEN
          CALL t370_qcs_del()
      END IF
      LET g_success = 'N'
   END IF
   DISPLAY BY NAME g_ina.inaspc
 
END FUNCTION
 
FUNCTION t370_qcs_del()
 
      DELETE FROM qcs_file WHERE qcs01 = g_ina.ina01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcs_file",g_ina.ina01,"",SQLCA.sqlcode,"","DEL qcs_file err!",0)
      END IF
 
      DELETE FROM qct_file WHERE qct01 = g_ina.ina01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qct_file",g_ina.ina01,"",SQLCA.sqlcode,"","DEL qct_file err!",0)
      END IF
 
      DELETE FROM qctt_file WHERE qctt01 = g_ina.ina01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qctt_file",g_ina.ina01,"",SQLCA.sqlcode,"","DEL qcstt_file err!",0)
      END IF
 
      DELETE FROM qcu_file WHERE qcu01 = g_ina.ina01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcu_file",g_ina.ina01,"",SQLCA.sqlcode,"","DEL qcu_file err!",0)
      END IF
 
      DELETE FROM qcv_file WHERE qcv01 = g_ina.ina01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcv_file",g_ina.ina01,"",SQLCA.sqlcode,"","DEL qcv_file err!",0)
      END IF
 
END FUNCTION
 
#FUN-6A0007...............begin 新增判斷
#判斷訂單單號存否及確認否
FUNCTION t370_inb911()
   DEFINE l_oeaconf LIKE oea_file.oeaconf
 
   LET g_errno = ' '
   SELECT oeaconf INTO l_oeaconf FROM oea_file
    WHERE oea01 = g_inb[l_ac].inb911
 
   CASE
       WHEN SQLCA.sqlcode = 100  LET g_errno = 100
       WHEN l_oeaconf <> 'Y'     LET g_errno = 9029
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
#判斷訂單單號項次存否及確認否
FUNCTION t370_inb912()
   DEFINE l_oeaconf LIKE oea_file.oeaconf
 
   LET g_errno = ' '
   SELECT oeaconf INTO l_oeaconf FROM oea_file,oeb_file
    WHERE oea01 = g_inb[l_ac].inb911
      AND oeb03 = g_inb[l_ac].inb912
      AND oea01 = oeb01
 
   CASE
                                 #(訂單單號+項次)不存在訂單!
       WHEN SQLCA.sqlcode = 100  LET g_errno = "abx-053"
       WHEN l_oeaconf <> 'Y'     LET g_errno = 9029
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
#判斷單號項次
FUNCTION t370_chk_oeb04(p_oea01,p_oeb03)
   DEFINE p_oea01 LIKE oea_file.oea01,
          p_oeb03 LIKE oeb_file.oeb03
   DEFINE l_cnt LIKE type_file.num5
 
   LET g_errno = ' '
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM oea_file,oeb_file,bma_file,bmb_file
    WHERE oea01 = oeb01 AND oeb04 = bma01 AND oeaconf = 'Y'
      AND bma01 = bmb01 AND bma06 = bmb29 AND bmaacti = 'Y'
      AND (bmb04 IS NULL OR bmb04 <= g_ina.ina03)
      AND (bmb05 IS NULL OR bmb05 > g_ina.ina03)
      AND oea01 = p_oea01
      AND oeb03 = p_oeb03
 
   IF l_cnt = 0 THEN
      LET g_msg = p_oea01,' - ',p_oeb03 USING '<<<'
      LET g_errno = 'abx-054'                   #FUN-B10016 add
      CALL cl_err(g_msg,'abx-054',1)
   END IF
END FUNCTION
 
#判斷單號項次 inb04是否是單號所建bom元件，若沒有，show msg
FUNCTION t370_chk_inb04(p_oea01,p_oeb03,p_bmb03)
   DEFINE p_oea01 LIKE oea_file.oea01,
          p_oeb03 LIKE oeb_file.oeb03,
          p_bmb03 LIKE bmb_File.bmb03
   DEFINE l_cnt LIKE type_file.num5,
          l_oeb04 LIKE oeb_file.oeb04
 
   LET g_errno = ' '
   IF cl_null(p_oea01) OR cl_null(p_oeb03) THEN     #MOD-920064
      RETURN
   END IF
 
   SELECT oeb04 INTO l_oeb04 FROM oea_file,oeb_file
    WHERE oea01 = oeb01 AND oeaconf = 'Y'
      AND oea01 = p_oea01
      AND oeb03 = p_oeb03
 
   IF NOT t370_bom(l_oeb04,p_bmb03) THEN
      LET g_errno = 'abx-055'                   #FUN-B10016 add
      CALL cl_err(p_bmb03,'abx-055',1)
   END IF
END FUNCTION
 
#展bom找元件
FUNCTION t370_bom(p_bma01,p_bmb03)
   DEFINE p_bma01 LIKE bma_file.bma01,
          p_bmb03 LIKE bmb_file.bmb03,
          l_bmb03 LIKE bmb_file.bmb03,
          l_cnt   LIKE type_file.num5,
          l_i     LIKE type_file.num5,
          l_rec   LIKE type_file.num5,
          l_bmb   DYNAMIC ARRAY OF RECORD
            bmb03 LIKE bmb_file.bmb03
                  END RECORD
 
   LET l_cnt = 0
   DECLARE t370_bom_cs CURSOR WITH HOLD FOR
    SELECT bmb03 FROM bma_file,bmb_file
     WHERE bma01 = bmb01 AND bma06 = bmb29 AND bmaacti = 'Y'
       AND (bmb04 IS NULL OR bmb04 <= g_ina.ina03)
       AND (bmb05 IS NULL OR bmb05 > g_ina.ina03)
       AND bma01 = p_bma01
   OPEN t370_bom_cs
 
   LET l_i = 1
   FOREACH t370_bom_cs INTO l_bmb[l_i].*
       LET l_i = l_i + 1
   END FOREACH
   LET l_rec = l_i - 1
 
   FOR l_i = 1 TO l_rec
     IF l_bmb[l_i].bmb03 = p_bmb03 THEN
        LET l_cnt = 1
        RETURN l_cnt
     END IF
     IF t370_bom(l_bmb[l_i].bmb03,p_bmb03) THEN RETURN 1 END IF
   END FOR
 
   RETURN l_cnt
END FUNCTION
 
#圖形顯示
FUNCTION t370_pic()
   IF g_ina.inaconf = 'X' THEN #FUN-660079
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   IF g_ina.ina08 = '1' THEN
       LET g_chr2='Y'
   ELSE
       LET g_chr2='N'
   END IF
   CALL cl_set_field_pic(g_ina.inaconf,g_chr2,g_ina.inapost,"",g_void,"") #FUN-660079
END FUNCTION
 
FUNCTION t370_set_img09()
   IF cl_null(g_inb[l_ac].inb06) THEN LET g_inb[l_ac].inb06 = ' ' END IF
   IF cl_null(g_inb[l_ac].inb07) THEN LET g_inb[l_ac].inb07 = ' ' END IF
   LET g_img09 = ''   #MOD-BA0209 add
   IF (NOT cl_null(g_inb[l_ac].inb04)) AND
      (NOT cl_null(g_inb[l_ac].inb05)) THEN
     #LET g_img09 = ''   #MOD-A40089 add     #MOD-BA0209 mark
      SELECT img09 INTO g_img09 FROM img_file
       WHERE img01=g_inb[l_ac].inb04
         AND img02=g_inb[l_ac].inb05
         AND img03=g_inb[l_ac].inb06
         AND img04=g_inb[l_ac].inb07
   END IF
END FUNCTION
 
FUNCTION t370_rvbs()
  DEFINE b_rvbs  RECORD  LIKE rvbs_file.*
  DEFINE l_ima25         LIKE ima_file.ima25
 IF g_azw.azw04='2' AND (g_prog="aimt301_slk" OR g_prog="aimt302_slk" OR g_prog="aimt303_slk") THEN    #FUN-D60112-add
#FUN-C20101-----ADD----STR-----
ELSE     
#FUN-D60112--add  &endif
#FUN-C20101-----ADD----END----- 
  CASE
    WHEN g_ina.ina00 MATCHES '[1256]'  #出庫
      LET b_rvbs.rvbs00 = g_prog
      LET b_rvbs.rvbs01 = g_ina.ina01
      LET b_rvbs.rvbs02 = g_inb[l_ac].inb03
      LET b_rvbs.rvbs021 = g_inb[l_ac].inb04
      LET b_rvbs.rvbs06 = g_inb[l_ac].inb09 * g_inb[l_ac].inb08_fac  #數量*庫存單位換算率
      LET b_rvbs.rvbs08 = g_inb[l_ac].inb41
      LET b_rvbs.rvbs09 = -1
      CALL s_ins_rvbs("1",b_rvbs.*)
 
    WHEN g_ina.ina00 MATCHES '[34]'    #入庫
      LET b_rvbs.rvbs00 = g_prog
      LET b_rvbs.rvbs01 = g_ina.ina01
      LET b_rvbs.rvbs02 = g_inb[l_ac].inb03
      LET b_rvbs.rvbs021 = g_inb[l_ac].inb04
      LET b_rvbs.rvbs06 = g_inb[l_ac].inb09 * g_inb[l_ac].inb08_fac  #數量*庫存單位換算率
      LET b_rvbs.rvbs08 = g_inb[l_ac].inb41
      LET b_rvbs.rvbs09 = 1  #1入庫
      CALL s_ins_rvbs("2",b_rvbs.*)
   END CASE
#&endif  #FUN-D60112--mark #&endif
 END IF  #FUN-D60112--add
#FUN-C20101-----ADD ENDIF-----------
   
END FUNCTION
 
 
 
FUNCTION t370_copy()
   DEFINE l_newno      LIKE ina_file.ina01
   DEFINE l_oldno      LIKE ina_file.ina01
   DEFINE l_ina02      LIKE ina_file.ina02
   DEFINE l_ina03      LIKE ina_file.ina03
   DEFINE li_result    LIKE type_file.num5
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_chr        LIKE type_file.chr1
   DEFINE l_yy,l_mm    LIKE type_file.num5
   DEFINE l_inbi RECORD LIKE inbi_file.*   #FUN-B30187
   DEFINE l_cnt        LIKE type_file.num5   #FUN-C80045 add 
   IF s_shut(0) THEN RETURN END IF
                                                                                                                                    
   IF g_ina.ina01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t370_set_entry('a')
   CALL cl_set_head_visible("","YES")
 
   INPUT l_newno,l_ina03,l_ina02 FROM ina01,ina03,ina02
 
       BEFORE INPUT
          CALL cl_set_docno_format("ina01")
 
      AFTER FIELD ina01
          CASE WHEN g_ina.ina00 MATCHES "[12]" LET l_chr='1'
               WHEN g_ina.ina00 MATCHES "[34]" LET l_chr='2'
               WHEN g_ina.ina00 MATCHES "[56]" LET l_chr='3'
          END CASE
          #FUN-C80045 add sta
          IF NOT cl_null(l_newno) THEN
             LET g_t1=s_get_doc_no(l_newno)
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM rye_file WHERE rye04 = g_t1 AND ryeacti = 'Y' AND rye01 = 'aim'
             IF l_cnt > 0 THEN
                CALL cl_err(g_t1,'apc1036',0)
                NEXT FIELD ina01
             END IF 
          END IF
          #FUn-C80045 add end
          CALL s_check_no("aim",l_newno,"",l_chr,"ina_file","ina01","")
          RETURNING li_result,l_newno
          DISPLAY l_newno TO ina01
          IF (NOT li_result) THEN                                                                                                  
              LET g_ina.ina01 = g_ina_t.ina01                                                                                       
              NEXT FIELD ina01                                                                                                      
          END IF 
 
       AFTER FIELD ina02
        IF NOT cl_null(l_ina02) THEN
            IF g_sma.sma53 IS NOT NULL AND l_ina02 <= g_sma.sma53 THEN
               CALL cl_err('','mfg9999',0)
               NEXT FIELD ina02
            END IF
            CALL s_yp(l_ina02) RETURNING l_yy,l_mm
           IF l_yy*12+l_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
              CALL cl_err('','mfg6091',0)
              NEXT FIELD ina02
           END IF
         END IF
 
      AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
          #MOD-E20008-Start-Add
          IF NOT cl_null(l_ina02) THEN
             IF g_sma.sma53 IS NOT NULL AND l_ina02 <= g_sma.sma53 THEN
                CALL cl_err('','mfg9999',0)
                NEXT FIELD ina02
             END IF
             CALL s_yp(l_ina02) RETURNING l_yy,l_mm
             IF l_yy*12+l_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
                CALL cl_err('','mfg6091',0)
                NEXT FIELD ina02
             END IF
          END IF
          #MOD-E20008-End-Add
          LET g_success = 'Y'
          BEGIN WORK
          #CALL s_auto_assign_no("aim",l_newno,g_ina.ina03,l_chr,"ina_file","ina01","","","")  #MOD-BB0321 mark
          CALL s_auto_assign_no("aim",l_newno,l_ina03,l_chr,"ina_file","ina01","","","")       #MOD-BB0321 add
          RETURNING li_result,l_newno 
          IF (NOT li_result) THEN                                                                                              
              NEXT FIELD ina01                                                                                              
          END IF
          DISPLAY l_newno TO ina01
          IF NOT cl_null(l_newno) THEN
          SELECT count(*) INTO l_n FROM ina_file
           WHERE ina01=l_newno
          IF l_n > 0 THEN
             CALL cl_err('',-239,0)
             NEXT FIELD ina01
          END IF
          END IF
 
          
         ON ACTION controlp
            CASE WHEN INFIELD(ina01) #查詢單据
                      LET g_t1=s_get_doc_no(l_newno)  #No.FUN-550029
                      CASE WHEN g_ina.ina00 MATCHES "[12]" LET l_chr='1'
                           WHEN g_ina.ina00 MATCHES "[34]" LET l_chr='2'
                           WHEN g_ina.ina00 MATCHES "[56]" LET l_chr='3'
                      END CASE
                      CALL q_smy(FALSE,FALSE,g_t1,'AIM',l_chr) RETURNING g_t1   #TQC-670008
                      LET l_newno=g_t1                #No.FUN-550029
                      DISPLAY l_newno TO ina01
                      NEXT FIELD ina01
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
                                                                                                                                    
                                                                                                                                    
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_ina.ina01
      DISPLAY BY NAME g_ina.ina02
      DISPLAY BY NAME g_ina.ina03
      ROLLBACK WORK
      RETURN
   END IF 

  #str MOD-A30017 add
   LET g_ina.inamksg = g_smy.smyapr
   IF cl_null(g_ina.inamksg) THEN
      LET g_ina.inamksg = 'N'
   END IF
  #end MOD-A30017 add
 
   DROP TABLE y
   SELECT * FROM ina_file
      WHERE ina01=g_ina.ina01
      INTO TEMP y
 
   UPDATE y
      SET ina01=l_newno,
          ina02=l_ina02,
          ina03=l_ina03,
          inauser=g_user,
          inagrup=g_grup,
          inaoriu=g_user,      #TQC-A30041 ADD
          inaorig=g_grup,      #TQC-A30041 ADD
          inamodu=NULL,
          inacond=NULL,        #20201109 add
          inadate=g_today,
          inaconf='N',
          ina08='N',
          inapost='N',
          ina10='',            #20210804 add
          ina07='',            #20210804 add
          inamksg=g_ina.inamksg   #'N'   #MOD-A30017 mod

      INSERT INTO ina_file SELECT * FROM y
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","ina_file","","",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF
#FUN-C20101----add---str--------
 IF g_azw.azw04='2' AND (g_prog="aimt301_slk" OR g_prog="aimt302_slk" OR g_prog="aimt303_slk") AND g_sma.sma150='N' THEN    #FUN-D60112-add #FUN-DB0029 add sma150
 ELSE
#FUN-D60112--add  &endif
#FUN-C20101----ADD----END------- 
      DROP TABLE x
      
      SELECT * FROM inb_file
         WHERE inb01=g_ina.ina01
         INTO TEMP x
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
     
      UPDATE x SET inb01=l_newno
 
      INSERT INTO inb_file
          SELECT * FROM x
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","inb_file","","",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN      
      END IF
#&endif   #FUN-D60112--mark
#FUN-C20101-----ADD endif-----------     
END IF    #FUN-D60112--add
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   LET g_cnt=SQLCA.SQLERRD[3]                                                                                                       
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'                                                                       
                                                                                                                                    
   LET l_oldno = g_ina.ina01                                                                                                        
   SELECT ina_file.* INTO g_ina.* FROM ina_file WHERE ina01 = l_newno                                             
   CALL t370_u()                                                                                                                    
   CALL t370_b()                                                                                                                    
   #SELECT ina_file.* INTO g_ina.* FROM ina_file WHERE ina01 = l_oldno  #FUN-C30027                                       
   #CALL t370_show()  #FUN-C30027
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t370_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   SELECT COUNT(*) INTO g_cnt FROM inb_file
    WHERE inb01 = g_ina.ina01


   IF g_cnt = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ina.ina01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ina_file ",
                  "  WHERE ina01 LIKE '",l_slip,"%' ",
                  "    AND ina01 > '",g_ina.ina01,"'"
      PREPARE t370_pb1 FROM l_sql 
      EXECUTE t370_pb1 INTO l_cnt      
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL t370_x()    #CHI-D20010
         CALL t370_x(1)   #CHI-D20010
         LET g_wc2 = ''    
         CALL t370_show()     
         CALL t370_pic()
      END IF 
      
      IF l_cho = 3 THEN     
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ina_file WHERE ina01 = g_ina.ina01
#FUN-C20101-----ADD--STR----
#FUN-C20101-----ADD--END-----
         INITIALIZE g_ina.* TO NULL
         CLEAR FORM          #TQC-A60014
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t370_delall()

#  SELECT COUNT(*) INTO g_cnt FROM inb_file
#   WHERE inb01 = g_ina.ina01
#  
#
#  IF g_cnt = 0 THEN                  
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM ina_file WHERE ina01 = g_ina.ina01
#FUN-C20101-----ADD--STR----
#&ifdef SLK      
#      DELETE FROM inb_file WHERE inb01 = g_ina.ina01 
#&endif
#FUN-C20101-----ADD--END-----      
#     CLEAR FORM          #TQC-A60014 
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end 
 
FUNCTION t370_g()    #####依BOM或工單自動展開單身                                                                                
DEFINE  l_chr       LIKE type_file.chr1                                                                                             
DEFINE  l_cnt       LIKE type_file.num5                                                                                             

    OPEN WINDOW aimt370_w AT p_row,p_col WITH FORM "aim/42f/aimt370_g"                                                              
             ATTRIBUTE (STYLE = g_win_style CLIPPED)                                                                                

   #CALL cl_ui_locale("aimt324_g")   #MOD-BA0122 mark
    CALL cl_ui_locale("aimt370_g")   #MOD-BA0122

    LET l_chr='1'

    INPUT l_chr WITHOUT DEFAULTS FROM FORMONLY.a

    AFTER FIELD a
       IF l_chr NOT MATCHES '[123]' THEN
          NEXT FIELD a
       END IF


    ON ACTION CONTROLR
       CALL cl_show_req_fields()

    ON ACTION CONTROLG
       CALL cl_cmdask()

    AFTER INPUT
       IF INT_FLAG THEN                         # 若按了DEL鍵
          LET INT_FLAG = 0
          EXIT INPUT
       END IF

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()


    END INPUT                                                                                                                       
    IF INT_FLAG THEN
       LET INT_FLAG=0
       LET l_chr = '1'
    END IF
    CLOSE WINDOW aimt370_w                 #結束畫面
    IF cl_null(l_chr) THEN
       LET l_chr = '1'
    END IF
    LET g_rec_b = 0
    CASE
      WHEN l_chr = '1'         
           CALL g_inb.clear()          
           CALL t370_b()
      WHEN l_chr = '2'
           CALL t370_wo(g_ina.ina01)
           COMMIT WORK
           LET g_wc2=NULL
           CALL t370_b_fill(g_wc2)
           LET g_action_choice="detail"
           IF cl_chk_act_auth() THEN
              CALL t370_b()
           ELSE
              RETURN
           END IF
      WHEN l_chr='3' 
           CALL t370_b_g(g_ina.ina01)
           LET g_wc2=NULL
           CALL t370_b_fill(g_wc2)
           LET g_action_choice="detail"
           IF cl_chk_act_auth() THEN
              CALL t370_b()
           ELSE
              RETURN
           END IF
      OTHERWISE EXIT CASE
      END CASE
      LET g_ina_t.* = g_ina.*                # 保存上筆資料
      LET g_ina_o.* = g_ina.*                # 保存上筆資料
END FUNCTION 

######根據BOM自動生成單身
FUNCTION t370_b_g(p_argv1)                                                                                                              
                                                                                                                                    
   DEFINE l_time  LIKE type_file.chr8,  
          l_sql   LIKE type_file.chr1000, 
          l_n1    LIKE type_file.num5,   
          p_argv1 LIKE pml_file.pml01,  
          l_flag_wo LIKE type_file.chr1, #FUN-D60038 add
          l_pro   STRING                 #FUN-D60038 add

                                                                                                                                    
   WHENEVER ERROR CONTINUE                                                                                                          
    IF p_argv1 IS NULL OR p_argv1 = ' ' THEN                                                                                        
       CALL cl_err(p_argv1,'mfg3527',0)                                                                                             
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET g_ccc=0  
    SELECT * INTO g_ina.* FROM ina_file WHERE ina01 = p_argv1                                                                                                                   
    LET b_inb.inb01  = p_argv1                                                                                                      
    
    INITIALIZE tm.* TO NULL 
    LET tm.qty=0                                                                                                                    
    LET tm.idate=g_today                                                                                                            
    LET tm.a='N'                                                                                                                    
                                                                                                                                    
WHILE TRUE                                                                                                                          
    #-->條件畫面輸入                                                                                                                
    OPEN WINDOW aimt370_g1_w AT 6,30 WITH FORM "aim/42f/aimt370_g1"                                                                          
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
                                                                                                                                    
    CALL cl_ui_locale("aimt370_g1")                                                                                                    
                                                                                                                                    
                                                                                                                                    
    CALL cl_set_comp_visible("ima910",g_sma.sma118='Y')  
   #CALL cl_set_comp_visible("inb15",g_sma.sma79='N')          #MOD-A80220 mark
    CALL cl_set_comp_visible("inb930",g_aaz.aaz90='Y')
    CALL cl_set_comp_visible("inb15_1",g_sma.sma79='Y')        #MOD-AC0324
    #FUN-D60038--add--str--
    IF g_ina.ina00 MATCHES '[34]' THEN 
       CALL cl_set_comp_visible("img02,img03,img04",TRUE)
    ELSE 
       CALL cl_set_comp_visible("img02,img03,img04",FALSE)
    END IF
    #FUN-D60038--add--end--
    INPUT  tm.part,tm.ima910,tm.qty,tm.idate,tm.img02,tm.img03,tm.img04,   #FUN-D60038 
           tm.inb15,tm.inb15_1,tm.inb930,tm.a      #MOD-AC0324 add inb15_1
             WITHOUT DEFAULTS FROM FORMONLY.part,FORMONLY.ima910,FORMONLY.qty,FORMONLY.idate,
                                   FORMONLY.img02,FORMONLY.img03,FORMONLY.img04,FORMONLY.inb15,  #FUN-D60038
                                   FORMONLY.inb15_1,FORMONLY.inb930,FORMONLY.a   #MOD-AC0324 add inb15_1
       AFTER FIELD part                                                                                                             
          IF NOT chk_part() THEN NEXT FIELD part END IF                                                                             
       AFTER FIELD ima910                                                                                                           
          IF cl_null(tm.ima910) THEN                                                                                                
             LET tm.ima910 = ' '                                                                                                    
          ELSE                                                                                                                      
             SELECT COUNT(*) INTO g_cnt FROM bma_file                                                                               
              WHERE bma01=tm.part AND bma06=tm.ima910                                                                               
             IF g_cnt = 0 THEN                                                                                                      
                CALL cl_err('','abm-618',0)                                                                                         
                NEXT FIELD ima910                                                                                                   
             END IF                                                                                                                 
          END IF                                                                                                                    
       AFTER FIELD qty                                                                                                              
          IF cl_null(tm.qty) OR tm.qty<=0 THEN NEXT FIELD qty END IF                                                                
       AFTER FIELD idate                                                                                                            
          #IF cl_null(tm.idate) OR tm.idate < g_today  #MOD-D60011 mark
          IF cl_null(tm.idate)                         #MOD-D60011
             THEN NEXT FIELD idate END IF             
       #FUN-D60038--add--str--
       AFTER FIELD img02,img03,img04
          IF INFIELD(img03) AND cl_null(tm.img03) THEN LET tm.img03 = ' ' END IF 
          IF INFIELD(img04) AND cl_null(tm.img04) THEN LET tm.img04 = ' ' END IF 
          CALL t370_wo_chk_img(tm.img02,tm.img03,tm.img04) RETURNING l_flag_wo,l_pro
          IF NOT l_flag_wo THEN
             CASE l_pro
                WHEN 'img02' NEXT FIELD img02
                WHEN 'img03' NEXT FIELD img03
                OTHERWISE EXIT CASE
             END CASE
          END IF 
       #FUN-D60038--add--end--
       AFTER FIELD inb15
          IF NOT t370_wo_chk_inb15(tm.inb15) THEN                                                                                     
            NEXT FIELD CURRENT                                                                                                      
         END IF
      #MOD-AC0324 -------add start---------
       AFTER FIELD inb15_1
          IF NOT t370_wo_chk_inb15_1(tm.inb15_1) THEN
             NEXT FIELD CURRENT
          END IF 
      #MOD-AC0324 -------add end------------- 
       AFTER FIELD inb930
          IF NOT s_costcenter_chk(tm.inb930) THEN                                                                                 
             NEXT FIELD CURRENT
          END IF 
       AFTER FIELD a                                                                                                                
          IF cl_null(tm.a) OR tm.a NOT matches '[YN]' THEN NEXT FIELD a END IF                                                      
       ON IDLE g_idle_seconds                                                                                                       
          CALL cl_on_idle()                                                                                                         
          CONTINUE INPUT                                                                                                            
       ON ACTION controlp                                                                                                           
          CASE                                                                                                                      
             WHEN INFIELD(part)                                                                                                     
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.form = "q_bma"                                                                                       
                LET g_qryparam.default1 = tm.part                                                                                   
                CALL cl_create_qry() RETURNING tm.part
                DISPLAY tm.part TO FORMONLY.part                                                                                    
                NEXT FIELD part                                                                                                     
           #FUN-D60038--add--str--
             WHEN INFIELD(img02) OR INFIELD(img03) OR INFIELD(img04)
                CALL cl_init_qry_var()
                LET g_qryparam.form  = "q_img11"
                LET g_qryparam.default1 = tm.img02
                LET g_qryparam.default2 = tm.img03
                LET g_qryparam.default3 = tm.img04
                CALL cl_create_qry() RETURNING tm.img02,tm.img03,tm.img04
                IF cl_null(tm.img02) THEN LET tm.img02 = ' ' END IF
                IF cl_null(tm.img03) THEN LET tm.img03 = ' ' END IF
                IF cl_null(tm.img04) THEN LET tm.img04 = ' ' END IF
                DISPLAY BY NAME tm.img02,tm.img03,tm.img04
                IF INFIELD(img02) THEN NEXT FIELD img02 END IF
                IF INFIELD(img03) THEN NEXT FIELD img03 END IF
                IF INFIELD(img04) THEN NEXT FIELD img04 END IF
           #FUN-D60038--add--end--
             WHEN INFIELD(inb15)                                                                                                                       
               #MOD-AC0324 mark begin------------
               # CALL cl_init_qry_var()                                                                                      
               # LET g_qryparam.form ="q_azf"                                                                                
               # LET g_qryparam.default1 = tm.inb15
               ##MOD-AC0115---add---start---
               # IF g_sma.sma79 = 'Y' THEN
               #    LET g_qryparam.arg1 = "A2"  
               # ELSE                       
               ##MOD-AC0115---add---end---                                                          
               #    LET g_qryparam.arg1 = "2"                                                                                   
               # END IF            #MOD-AC0115 add
               # CALL cl_create_qry() RETURNING tm.inb15
               #MOD-AC0324 mark end--------------
            #MOD-AC0324 ---------------mod start by vealxu ----------------
            #   #MOD-AC0324 add begin------------
            #   IF g_sma.sma79='Y' THEN
            #      CALL cl_init_qry_var()
            #      LET g_qryparam.form ="q_azf"
            #      LET g_qryparam.default1 = tm.inb15,'A2'
            #      LET g_qryparam.arg1 = "A2"
            #      LET g_qryparam.state = "c"
            #      CALL cl_create_qry() RETURNING tm.inb15
            #   ELSE
            #      CALL cl_init_qry_var()
            #      LET g_qryparam.form ="q_azf01a"
            #      LET g_qryparam.default1 = tm.inb15,'2'
            #      LET g_qryparam.arg1 = "4"
            #      LET g_qryparam.state = "c"
            #      CALL cl_create_qry() RETURNING tm.inb15
            #   END IF
            #   #MOD-AC0324 add end--------------
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azf01a"
                LET g_qryparam.default1 = tm.inb15
                LET g_qryparam.arg1 = "4"
                CALL cl_create_qry() RETURNING tm.inb15
                DISPLAY tm.inb15 TO FORMONLY.inb15
                NEXT FIELD inb15 
             WHEN INFIELD(inb15_1)    
                CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_azf06"                      #MOD-C70176  q_azf->q_azf06 #CHI-C40009
                LET g_qryparam.form ="q_azf"  #CHI-C40009
                LET g_qryparam.default1 = tm.inb15_1
               #LET g_qryparam.arg1 = "A2"                          #MOD-C70176 mark
                LET g_qryparam.arg1 = "A"  #CHI-C40009
                CALL cl_create_qry() RETURNING tm.inb15_1
            #MOD-AC0324 ----------mod end by vealxu ---------------
                DISPLAY tm.inb15_1 TO FORMONLY.inb15_1   
                NEXT FIELD inb15_1
             WHEN INFIELD(inb930)
                CALL cl_init_qry_var()                                                                                            
                LET g_qryparam.form ="q_gem4"                                                                                     
                LET g_qryparam.default1 = tm.inb930
                CALL cl_create_qry() RETURNING tm.inb930 
                DISPLAY BY NAME tm.inb930
                NEXT FIELD inb930 
             #FUN-D70027 add-------------str
             WHEN INFIELD(ima910)
                CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_ima910" #MOD-F30050 mark
               #LET g_qryparam.arg1 = tm.part   #MOD-F30050 mark
               #MOD-F30050--add----str---
                LET g_qryparam.form ="q_bma06"
                IF NOT cl_null(tm.part) THEN
                    LET g_qryparam.where = " bma01='",tm.part,"'"
                END IF
               #MOD-F30050--add----end---
                CALL cl_create_qry() RETURNING tm.ima910
                DISPLAY BY NAME tm.ima910
                NEXT FIELD ima910
              #FUN-D70027 add-------------end

             OTHERWISE EXIT CASE                                                                                                    
          END CASE                                                                                                                  
                                                                                                                                    
       ON ACTION about        
          CALL cl_about()    
                                                                                                                                    
       ON ACTION help         
          CALL cl_show_help() 
                                                                                                                                    
       ON ACTION controlg    
          CALL cl_cmdask()  
                                                                                                                                    
       BEFORE INPUT                                                                                                                 
           CALL cl_qbe_init()                                                                                                       
                                                                                                                                    
       ON ACTION qbe_select                                                                                                         
          CALL cl_qbe_select()                                                                                                      
                                                                                                                                    
       ON ACTION qbe_save                                                                                                           
          CALL cl_qbe_save()                                                                                                        
                                                                                                                                    
    END INPUT                                                                                                                       
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW aimt370_g1_w RETURN END IF                                                               
    CALL t370_g_init() 
    CALL t370_g_bom()                                                                                                                 
    CLOSE WINDOW aimt370_g1_w                                                                                                             
    EXIT WHILE                                                                                                                      
END WHILE                                                                                                                           
END FUNCTION 

FUNCTION t370_g_init()                                                                                                                
   
   LET b_inb.inb07 = ' ' 
   LET b_inb.inb10 = 'N'                                                                                                           
   LET b_inb.inb08_fac=1                                                                                                           
   LET b_inb.inb930=s_costcenter(g_ina.ina04)                                                                                      
   LET b_inb.inb41 = g_ina.ina06 
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION chk_part()                                                                                                                 
  DEFINE  l_ima08    LIKE ima_file.ima08,                                                                                           
          l_imaacti  LIKE ima_file.imaacti,                                                                                         
          l_cnt      LIKE type_file.num5,   
          l_err      LIKE type_file.num5   
                                                                                                                                    
         LET l_err=1                                                                                                                
        #檢查該料件是否存在                                                                                                         
         SELECT ima08,imaacti INTO l_ima08,l_imaacti FROM ima_file                                                                  
          WHERE ima01=tm.part                                                                                                       
             CASE                                                                                                                   
               WHEN l_ima08 NOT MATCHES '[MSX]'     #MOD-C70234 add X
                    LET l_err=0                                                                                                     
               WHEN l_imaacti = 'N'                                                                                                 
                    CALL cl_err(tm.part,'mfg0301',2)                                                                                
                    LET l_err=0                                                                                                     
               WHEN SQLCA.SQLCODE = 100                                                                                             
                    CALL cl_err(tm.part,'mfg0002',2)                                                                                
                    LET l_err=0                                                                                                     
               WHEN SQLCA.SQLCODE != 0                                                                                              
                    CALL cl_err(tm.part,sqlca.sqlcode,2)                                                                            
                    LET l_err=0                                                                                                     
            END CASE                                                                                                                
         IF l_err THEN                                                                                                              
            #檢查該料件是否有產品結構                                                                                               
            SELECT COUNT(*) INTO l_cnt FROM bmb_file WHERE bmb01=tm.part                                                            
            IF SQLCA.SQLCODE THEN                                                                                                   
                CALL cl_err(tm.part,sqlca.sqlcode,2)                                                                                
                LET l_err=0                                                                                                         
            END IF                                                                                                                  
            IF l_cnt=0 OR cl_null(l_cnt) THEN                                                                                       
                CALL cl_err(tm.part,'mfg2602',2)                                                                                    
                LET l_err=0  
            END IF                                                                                                                  
         END IF                                                                                                                     
    RETURN l_err                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
###展BOM                                                                                                                            
                                                                                                                                    
 FUNCTION t370_g_bom()                                                                                                                
   DEFINE l_ima562     LIKE ima_file.ima562,                                                                                        
          l_ima910     LIKE ima_file.ima910, 
          l_ima55      LIKE ima_file.ima55,                                                                                         
          l_ima86      LIKE ima_file.ima86,                                                                                         
          l_ima86_fac  LIKE ima_file.ima86_fac                                                                                      
                                                                                                                                    
   #SELECT ima562,ima55,ima86,ima86_fac,ima910 INTO        #MOD-D80067 mark
   #  l_ima562,l_ima55,l_ima86,l_ima86_fac,l_ima910        #MOD-D80067 mark
    SELECT ima562,ima55,ima86,ima86_fac INTO               #MOD-D80067 add 
      l_ima562,l_ima55,l_ima86,l_ima86_fac                 #MOD-D80067 add
        FROM ima_file                                                                                                               
        WHERE ima01=tm.part AND imaacti='Y'                                                                                         
    IF SQLCA.sqlcode THEN RETURN END IF                                                                                             
    IF l_ima562 IS NULL THEN LET l_ima562=0 END IF  
   #IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF      #MOD-D80067 mark
   #IF tm.ima910 != ' ' THEN                               #MOD-D80067 mark                                                                          
   #   LET l_ima910 = tm.ima910                            #MOD-D80067 mark                                                                         
   #END IF                                                 #MOD-D80067 mark
    IF cl_null(tm.ima910) THEN LET tm.ima910 = ' ' END IF  #MOD-D80067 add   
    CALL s_showmsg_init()        #CHI-C30125 add
   # Prog. Version..: '5.30.24-17.04.13(0,tm.part,l_ima910,tm.qty,1)          #MOD-D80067 mark         
    CALL t370_g_bom2(0,tm.part,tm.ima910,tm.qty,1)         #MOD-D80067 add
       IF g_ccc=0 THEN                                                                                                              
           LET g_errno='asf-014'                                                                                                    
       END IF    #有BOM但無有效者                                                                                                   
    CALL s_showmsg()             #CHI-C30125 add                                                                                                                                    
    MESSAGE ""                                                                                                                      
    RETURN                                                                                                                          
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION t370_g_bom2(p_level,p_key,p_key2,p_total,p_QPA)
#No.FUN-A70034  --Begin
DEFINE l_total_1   LIKE sfa_file.sfa06
DEFINE l_QPA_1     LIKE bmb_file.bmb06
#No.FUN-A70034  --End  
DEFINE                                                                                                                              
    p_level      LIKE type_file.num5,   
    p_total      LIKE sfb_file.sfb08,  
#    p_QPA        LIKE ima_file.ima26, 
#    l_QPA        LIKE ima_file.ima26, 
    p_QPA        LIKE type_file.num15_3,#No.FUN-A20044
    l_QPA        LIKE type_file.num15_3,#No.FUN-A20044
    l_total      LIKE sfb_file.sfb08,         #原發數量     
    l_total2     LIKE sfb_file.sfb08,         #應發數量    
    p_key        LIKE bma_file.bma01,      
    p_key2       LIKE bma_file.bma06,     
    l_ac,l_i,l_x LIKE type_file.num5,    
    arrno        LIKE type_file.num5,   
    b_seq,l_double LIKE type_file.num10,  
    l_ima45      LIKE ima_file.ima45,                                                                                               
    l_ima46      LIKE ima_file.ima46,                                                                                               
    sr DYNAMIC ARRAY OF RECORD  #array for storage                                                                                  
        bmb02 LIKE bmb_file.bmb02, #項次                                                                                            
        bmb03 LIKE bmb_file.bmb03, #料號                                                                                            
        bmb16 LIKE bmb_file.bmb16, #取替代碼                                                                                        
        bmb06 LIKE bmb_file.bmb06, #組成用量                                                                                             
        bmb07 LIKE bmb_file.bmb07, #底數    #FUN-FC0005 add                                                                                             
        bmb06_07 LIKE bmb_file.bmb06, #QPA  #FUN-FC0005 add                                                                                           
        bmb08 LIKE bmb_file.bmb08, #損耗率                                                                                          
        bmb10 LIKE bmb_file.bmb10, #發料單位                                                                                        
        bmb10_fac LIKE bmb_file.bmb10_fac, #換算率                                                                                  
        ima08 LIKE ima_file.ima08, #來源碼                                                                                          
        ima02 LIKE ima_file.ima02, #品名規格  
        ima05 LIKE ima_file.ima05, #版本                                                                                            
        ima44 LIKE ima_file.ima44, #采購單位                                                                                        
        ima25 LIKE ima_file.ima25, #庫存單位                                                                                        
        ima44_fac LIKE ima_file.ima44_fac,  #采購單位/庫存單位 換算率                                                               
        ima49  LIKE ima_file.ima49,  #到廠前置期                                                                                    
        ima491 LIKE ima_file.ima491, #入庫前置期                                                                                    
        ima24  LIKE ima_file.ima24, #TQC-9B0037
        bma01 LIKE bma_file.bma01, #項次                                                                                            
        #No.FUN-A70034  --Begin
        bmb081 LIKE bmb_file.bmb081,
        bmb082 LIKE bmb_file.bmb082 
        #No.FUN-A70034  --End  
    END RECORD,                                                                                                                     
    l_ima08     LIKE ima_file.ima08, 
#    l_ima26     LIKE ima_file.ima26,  #No.FUN-A20044
    l_chr       LIKE type_file.chr1,      
    l_ActualQPA LIKE bmb_file.bmb06,     
    l_cnt,l_c   LIKE type_file.num5,    
    l_cmd       LIKE type_file.chr1000,  
    l_status    LIKE type_file.num5,    
    l_factor    LIKE ima_file.ima31_fac    
DEFINE  l_ima908     LIKE ima_file.ima908 
DEFINE  l_ima44      LIKE ima_file.ima44                                                                                            
DEFINE  l_ima906     LIKE ima_file.ima906                                                                                           
DEFINE  l_ima907     LIKE ima_file.ima907                                                                                           
DEFINE  l_img09      LIKE img_file.img09      #No:MOD-9C0050 add                                                                                          
DEFINE  l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910     
DEFINE  l_flag       LIKE type_file.chr1       #No.CHI-990051 add
DEFINE  l_ima15      LIKE ima_file.ima15       #MOD-AC0324 add
DEFINE  l_ina01      LIKE ina_file.ina01       #FUN-B30053
DEFINE  l_smy57      LIKE smy_file.smy57       #FUN-B30053
DEFINE  l_flag1      LIKE type_file.num5       #FUN-BC0104
                                                                                                                                    
    LET p_level = p_level + 1                                                                                                       
    LET arrno = 500                                                                                                                 
        #No.FUN-A70034  --Begin
        #LET l_cmd=" SELECT 0,bmb03,bmb16,bmb06/bmb07,bmb08,bmb10,bmb10_fac,",                                                       
        #          "     ima08,ima02,ima05,ima44,ima25,ima44_fac,ima49,ima491,ima24,bma01 ",  #TQC-9B0037 add ima24
       #LET l_cmd=" SELECT 0,bmb03,bmb16,bmb06/bmb07,bmb08,bmb10,bmb10_fac,",                 #FUN-FC0005 mark                                                  
        LET l_cmd=" SELECT 0,bmb03,bmb16,bmb06,bmb07,bmb06/bmb07,bmb08,bmb10,bmb10_fac,",     #FUN-FC0005 add                                                  
                 #"        ima08,ima02,ima05,ima44,ima25,ima44_fac,ima49,ima491,ima24,bma01,",
                  "        ima08,ima02,ima05,ima44,ima25,ima44_fac,ima49,ima491,'',bma01,",    #FUN-B30053 ima24-->''
                  "        bmb081,bmb082 ", 
        #No.FUN-A70034  --End  
                  "   FROM bmb_file ",
                  "   LEFT OUTER JOIN ima_file ON ima01=bmb03 ",
                  "   LEFT OUTER JOIN bma_file ON bma01=bmb03 AND bma06=bmb29 ",                                                              
                  "  WHERE bmb01='",p_key,"' AND bmb02 > ?",                                                                        
                  "    AND bmb29='",p_key2,"'",                                                                                              
                  "    AND (bmb04 <='",tm.idate,"' OR bmb04 IS NULL) ",                                                             
                  "    AND (bmb05 >'",tm.idate,"' OR bmb05 IS NULL)",                                                               
                  " ORDER BY 1"                                                                                                     
        PREPARE bom_p FROM l_cmd                                                                                                    
        DECLARE bom_cs CURSOR FOR bom_p                                                                                             
        IF SQLCA.sqlcode THEN CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN  END IF                                                     
                                                                                                                                    
    LET b_seq=0                                                                                                                     
    WHILE TRUE  
        LET l_ac = 1                                                                                                                
        FOREACH bom_cs USING b_seq INTO sr[l_ac].*                                                                                  
            MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED                                                                        
            #若換算率有問題, 則設為1                                                                                                
            IF sr[l_ac].bmb10_fac IS NULL OR sr[l_ac].bmb10_fac=0 THEN                                                              
                LET sr[l_ac].bmb10_fac=1                                                                                            
            END IF                                                                                                                  
            IF cl_null(sr[l_ac].bmb16) THEN    #若未定義, 則給予'正常'                                                              
                LET sr[l_ac].bmb16='0'                                                                                              
            ELSE                                                                                                                    
               IF sr[l_ac].bmb16='2' THEN LET sr[l_ac].bmb16='1' END IF                                                             
            END IF                                                                                                                  
            #FUN-B30053-add-str--
            LET l_ina01 = s_get_doc_no(g_ina.ina01)
            SELECT smy57 INTO l_smy57
             FROM  smy_file WHERE smyslip = l_ina01 AND smyacti = 'Y'
            IF cl_null(l_smy57[2,2]) THEN
               LET l_smy57[2,2] = 'N'
            END IF
            LET sr[l_ac].ima24 = l_smy57[2,2]
            #FUN-B30053-add-end--
            LET l_ima910[l_ac]=''                                                                                                   
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03                                              
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF                                                           
            LET l_ac = l_ac + 1    #check limitation                                                                                
            IF l_ac > arrno THEN EXIT FOREACH END IF                                                                                
        END FOREACH                                                                                                                 
        LET l_x=l_ac-1                                                                                                              
                                                                                                                                    
        FOR l_i = 1 TO l_x                                                                                                          
            LET l_flag = 'Y'    #No.CHI-990051 add
                                                                                                                                    
            #No.FUN-A70034  --Begin
            #IF g_sma.sma71='N' THEN LET sr[l_i].bmb08=0 END IF                                                                      
            #LET l_ActualQPA=(sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA                                                                 
            #LET l_QPA=sr[l_i].bmb06 * p_QPA                                                                                         
            #LET l_total=sr[l_i].bmb06*p_total*((100+sr[l_i].bmb08))/100  #量                                                        

           #CALL cralc_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,sr[l_i].bmb06,p_QPA)                                   #FUN-FC0005 mark
            CALL cralc_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,sr[l_i].bmb06_07,p_QPA,sr[l_i].bmb06,sr[l_i].bmb07)    #FUN-FC0005 add
                 RETURNING l_total_1,l_QPA,l_ActualQPA
            LET l_QPA_1 = l_ActualQPA
            LET l_total=l_total_1
            #No.FUN-A70034  --End  

            IF sr[l_i].ima08='X' THEN       ###為 X PART 由參數決定                                                                 
                LET l_flag = 'N'    #No.CHI-990051 add
                IF sr[l_i].bma01 IS NOT NULL THEN                                                                                   
                   #No.FUN-A70034  --Begin
                   #CALL t370_g_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],    
                   #    p_total*sr[l_i].bmb06,l_ActualQPA)                                                                          
                    CALL t370_g_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],    
                        l_total,l_QPA_1)
                   #No.FUN-A70034  --End  
                END IF                                                                                                              
            END IF                                                                                                                  
                                                                                                                                    
                                                                                                                                    
            IF sr[l_i].ima08='M' OR                                                                                                 
               sr[l_i].ima08='S' THEN     ###為 M PART 由人決定                                                                     
               IF tm.a='Y' THEN                                                                                                     
                  IF sr[l_i].bma01 IS NOT NULL THEN                                                                                 
                     LET l_flag = 'N'    #No.CHI-990051 add
                     #No.FUN-A70034  --Begin
                     #CALL t370_g_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],    
                     #     p_total*sr[l_i].bmb06,l_ActualQPA)                                                                        
                     CALL t370_g_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],    
                          l_total,l_QPA_1)
                     #No.FUN-A70034  --Begin
                  ELSE                                                                                                              
                      LET l_flag = 'Y'    #No.CHI-990051 add
                  END IF                                                                                                            
               ELSE                                                                                                                 
                  LET l_flag = 'Y'    #No.CHI-990051 add
               END IF                                                                                                               
            END IF    
            IF l_flag = 'Y' THEN
               LET b_inb.inb44 = ''         #TQC-C20223
               LET b_inb.inb45 = ''         #TQC-C20223
               LET b_inb.inb46 = ''         #TQC-C20223
               LET b_inb.inb47 = ''         #TQC-C20223
               LET b_inb.inb48 = ''         #TQC-C20223
               LET g_ccc=g_ccc+1                                                                                                     
               LET b_inb.inb08 = sr[l_i].bmb10    #No:MOD-9C0050 add
               LET b_inb.inb08_fac = 1            #No:MOD-9C0050 add
               LET b_inb.inb09 = l_total          #No:MOD-9C0398 add
               LET b_inb.inb16 = l_total          #No:MOD-9C0398 add
               LET b_inb.inb09 = s_digqty(b_inb.inb09,b_inb.inb08)   #FUN-BB0085
               LET b_inb.inb16 = s_digqty(b_inb.inb16,b_inb.inb08)   #FUN-BB0085
               LET b_inb.inb04=sr[l_i].bmb03                                                                                        
               IF cl_null(tm.img02) THEN  #FUN-D60038 add
                  SELECT ima35,ima36 INTO b_inb.inb05,b_inb.inb06 FROM ima_file ## 倉儲
                   WHERE ima01 = b_inb.inb04 AND imaacti = 'Y'
               #FUN-D60038--add--str--
               ELSE 
                  LET b_inb.inb05 = tm.img02
                  LET b_inb.inb06 = tm.img03
                  LET b_inb.inb07 = tm.img04
               END IF 
               #FUN-D60038--add--end--
#FUN-AB0066 --begin--               
#               #No.FUN-AA0049--begin
#               IF NOT s_chk_ware(b_inb.inb05) THEN
#                  LET b_inb.inb05=' '
#                  LET b_inb.inb06=' '
#               END IF 
#               #No.FUN-AA0049--end   
#FUN-AB0066 --end--               
               IF (NOT cl_null(b_inb.inb04)) AND (NOT cl_null(b_inb.inb05)) THEN   ###單位                                                                                         
                  LET l_img09 = NULL                          #No:MOD-9C0050 add
                  SELECT img09 INTO l_img09 FROM img_file     #No:MOD-9C0050 modify                                                                                  
                   WHERE img01=b_inb.inb04                                                                                                
                     AND img02=b_inb.inb05                                                                                                
                     AND img03=b_inb.inb06                                                                                                
                     AND img04=b_inb.inb07                                                                                                
                   CALL s_umfchk(b_inb.inb04,b_inb.inb08,l_img09)
                         RETURNING g_cnt,b_inb.inb08_fac
                   IF g_cnt = 1 THEN
                      LET b_inb.inb08_fac = 1
                   END IF
                  #CHI-C30125 str add-----
                   IF NOT s_chksmz(b_inb.inb04, g_ina.ina01,
                                   b_inb.inb05, b_inb.inb06) THEN
                      LET b_inb.inb05 =' '
                      LET b_inb.inb06 =' '
                   END IF
                  #CHI-C30125 end add-----
               END IF
               IF g_sma.sma115 = 'Y' THEN                                                                                            
                 CALL s_chk_va_setting(b_inb.inb04)                                                                           
                      RETURNING g_flag,g_ima906,g_ima907                                                                            
                 IF g_ima906 = '3' THEN                                                                                             
                    LET b_inb.inb905=g_ima907                                                                                 
                 END IF                                                                                                             
               END IF   
                
             ### 寫進 inb_file                                                                                                      
               SELECT COUNT(*) INTO l_cnt FROM inb_file                                                                             
                WHERE inb01=g_ina.ina01 AND inb04=b_inb.inb04
               IF l_cnt > 0 THEN   #Duplicate   數量相加                                                                            
                  SELECT ima25,ima44,ima906,ima907                                                                                  
                    INTO g_ima25,g_ima44,g_ima906,g_ima907                                                                          
                    FROM ima_file WHERE ima01=b_inb.inb04                                                                           
                  IF SQLCA.sqlcode =100 THEN                                                                                        
                     IF b_inb.inb04 MATCHES 'MISC*' THEN                                                                            
                        SELECT ima25,ima44,ima906,ima907                                                                            
                          INTO g_ima25,g_ima44,g_ima906,g_ima907                                                                    
                          FROM ima_file WHERE ima01='MISC'                                                                          
                     END IF                                                                                                         
                  END IF                                                                                                            
                  IF cl_null(g_ima44) THEN LET g_ima44 = g_ima25 END IF                                                             
                  IF g_sma.sma115 = 'Y' AND g_ima906 MATCHES '[23]' THEN 
                     SELECT ima25 INTO b_inb.inb902 FROM inb_file 
                      WHERE ima01 = b_inb.inb04
                     LET b_inb.inb905 = b_inb.inb902                    
                     LET g_factor = 1                                                                                               
                     CALL s_umfchk(b_inb.inb04,b_inb.inb902,b_inb.inb905)                                                             
                          RETURNING g_cnt,g_factor                                                                                  
                     IF g_cnt = 1 THEN                                                                                              
                        LET g_factor = 1                                                                                            
                     END IF                                                                                                         
                     LET b_inb.inb907 = b_inb.inb09*g_factor 
                     LET b_inb.inb907 = s_digqty(b_inb.inb907,b_inb.inb905)   #FUN-BB0085
                     LET b_inb.inb904 = b_inb.inb09
                  ELSE                              
                     SELECT ima25,ima906 INTO b_inb.inb902,b_inb.inb905
                       FROM inb_file WHERE ima01 = b_inb.inb04                                                                                
                     LET b_inb.inb904 = 0
                  END IF                                                                                                            
                                                                                                                                    
                 #UPDATE pml_file SET inb09=inb09+b_inb.inb09,   #No:MOD-9C0398 mark                                                                    
                  UPDATE inb_file SET inb09=inb09+b_inb.inb09,   #No:MOD-9C0398 add 
                                      inb16=inb16+b_inb.inb16,   #No:MOD-9C0398 add 
                                      inb904=inb904+b_inb.inb904,  
                                      inb907=inb907+b_inb.inb907 
                   WHERE inb01=b_inb.inb01 AND inb04=b_inb.inb04                                                                    
               ELSE                                                                                                                 
#FUN-BC0104 -----------------Begin------------------
#saimt370.src.4gl 獨立出來的 SUB
               #TQC-D30066 -----Begin--------
                  IF g_ccz.ccz28 = '6' AND (g_argv1  = '3' OR g_argv1 = '4') THEN
                     SELECT cfa12 INTO b_inb.inb13 FROM cfa_file
                      WHERE cfa01 = b_inb.inb04
                        AND cfa04 = 1
                        AND cfa02 = (SELECT MAX(cfa02) FROM cfa_file WHERE cfa01= b_inb.inb04 AND cfa04=1 )
                     IF cl_null(b_inb.inb13) THEN LET b_inb.inb13 = 0 END IF
                     IF cl_null(b_inb.inb09) THEN LET b_inb.inb09 = 0 END IF
                     LET b_inb.inb14 = b_inb.inb13 * b_inb.inb09
                     LET b_inb.inb14 = cl_digcut(b_inb.inb14,g_azi03)  #TQC-D80003 add
                  END IF
                  #TQC-D30066 -----End----------
                  CALL t370sub_ins_inb(b_inb.*,b_inbi.*,l_total,tm.inb930,tm.inb15,tm.inb15_1,sr[l_i].ima24)  RETURNING l_flag1
               END IF    
#FUN-BC0104 -----------------End---------------------
#FUN-BC0104 ----------------------Begin---------------------------
#                 SELECT MAX(inb03) INTO b_inb.inb03 FROM inb_file
#                  WHERE inb01 = b_inb.inb01
#                 IF cl_null(b_inb.inb03) THEN
#                    LET b_inb.inb03 = 0
#                 END IF 
#                 LET b_inb.inb03=b_inb.inb03+1                                                                                     
#                 IF g_sma.sma115 = 'Y' THEN                                                                                        
#                    SELECT ima44,ima906,ima907 INTO l_ima44,l_ima906,l_ima907                                                      
#                      FROM ima_file                                                                                                
#                     WHERE ima01=b_inb.inb04                                                                                       
#                     IF  g_ima906 MATCHES '[23]' THEN                                                            
#                        SELECT ima25 INTO b_inb.inb902 FROM inb_file                                                                   
#                         WHERE ima01 = b_inb.inb04                                                                                     
#                        LET b_inb.inb905 = b_inb.inb902                                                                                
#                    ELSE                                                                                                              
#                       SELECT ima25,ima906 INTO b_inb.inb902,b_inb.inb905                                                             
#                         FROM inb_file WHERE ima01 = b_inb.inb04                                                                      
#                    END IF 
#                    LET l_factor = 1                                                                                               
#                    CALL s_umfchk(b_inb.inb04,b_inb.inb902,l_ima44)                                                                 
#                         RETURNING l_cnt,l_factor                                                                                  
#                    IF l_cnt = 1 THEN                                                                                              
#                       LET l_factor = 1                                                                                            
#                    END IF                                                                                                         
#                    LET b_inb.inb903=l_factor                                                                                       
#                    LET b_inb.inb904=b_inb.inb09                                                                                    
#                    LET b_inb.inb905=l_ima907                                                                                       
#                    LET l_factor = 1   
#                    CALL s_umfchk(b_inb.inb04,b_inb.inb905,l_ima44)                                                                 
#                         RETURNING l_cnt,l_factor                                                                                  
#                    IF l_cnt = 1 THEN                                                                                              
#                       LET l_factor = 1                                                                                            
#                    END IF                                                                                                         
#                    LET b_inb.inb906=l_factor                                                                                       
#                    LET b_inb.inb907=0                                                                                              
#                    IF l_ima906 = '3' THEN                                                                                         
#                       LET l_factor = 1                                                                                            
#                       CALL s_umfchk(b_inb.inb04,b_inb.inb902,b_inb.inb905)                                                          
#                            RETURNING l_cnt,l_factor                                                                               
#                       IF l_cnt = 1 THEN                                                                                           
#                          LET l_factor = 1                                                                                         
#                       END IF                                                                                                      
#                       LET b_inb.inb907=b_inb.inb904*l_factor                                                                        
#                       LET b_inb.inb907=s_digqty(b_inb.inb907,b_inb.inb905)   #FUN-BB0085
#                    END IF                                                                                                         
#                 END IF                                                                                                            
#                 SELECT ima908 INTO l_ima908                                                                                       
#                   FROM ima_file                                                                                                   
#                  WHERE ima01=b_inb.inb04 
#                                                                                                                                   
#                 #No.FUN-A70034  --Begin
#                 #LET b_inb.inb09 = tm.qty
#                 #LET b_inb.inb16 = tm.qty
#                 LET b_inb.inb09 = l_total
#                 LET b_inb.inb16 = l_total
#                 #No.FUN-A70034  --End  
#                #MOD-AC0324 ------add start----------
#                #LET b_inb.inb15 = tm.inb15
#                 SELECT ima15 INTO l_ima15 FROM ima_file 
#                  WHERE ima01 = b_inb.inb04
#                 IF g_sma.sma79 = 'Y' AND l_ima15 = 'Y' THEN
#                    LET b_inb.inb15 = tm.inb15_1
#                 ELSE
#                    LET b_inb.inb15 = tm.inb15
#                 END IF
#                #MOD-AC0324 ------add end-------------
#                 LET b_inb.inb930 = tm.inb930
#                 LET b_inb.inb922 = b_inb.inb902     #申請單位一                #MOD-AC0052 add
#                 LET b_inb.inb923 = b_inb.inb903     #申請單位一換算率          #MOD-AC0052 add
#                 LET b_inb.inb924 = b_inb.inb904     #申請單位一數量            #MOD-AC0052 add
#                 LET b_inb.inb10 = sr[l_i].ima24 #TQC-9B0037
#                 IF cl_null(b_inb.inb06) THEN LET b_inb.inb06 = ' ' END IF  #TQC-9B0037
#                 IF cl_null(b_inb.inb07) THEN LET b_inb.inb07 = ' ' END IF  #TQC-9B0037
#                 LET b_inb.inblegal = g_legal   #MOD-A50144 add
#                 LET b_inb.inbplant = g_plant   #FUN-A60028                  
#                 INSERT INTO inb_file VALUES(b_inb.*)                                                                              
#                 IF SQLCA.SQLCODE THEN                                                                                             
#                    ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE
#&ifndef STD
#                 #FUN-B30187 --START--
#                 ELSE
#                    LET b_inbi.inbi01 = b_inb.inb01
#                    LET b_inbi.inbi03 = b_inb.inb03
#                    LET b_inbi.inbilegal = b_inb.inblegal
#                    LET b_inbi.inbiplant = b_inb.inbplant
#                    IF NOT s_ins_inbi(b_inbi.*,b_inb.inbplant) THEN
#                       EXIT WHILE
#                    END IF 
#                 #FUN-B30187 --END--                     
#&endif                     
#                 END IF                                                                                                            
#              END IF                                                                                                               
#FUN-BC0104 --------------------End-------------------------
            END IF                                                                                                                  
        END FOR                                                                                                                     
        IF l_x < arrno OR l_ac=1 THEN #nothing left                                                                                 
            EXIT WHILE                                                                                                              
        ELSE                                                                                                                        
            LET b_seq = sr[l_x].bmb02                                                                                               
        END IF                                                                                                                      
    END WHILE                                                                                                                       
    # 避免 'X' PART 重復計算                                                                                                        
    IF p_level >1 THEN                                                                                                              
       RETURN                                                                                                                       
     END IF

END FUNCTION       

FUNCTION t370_wo(p_argv1)
   DEFINE l_time     LIKE type_file.chr8,                                                                                           
          l_sql      LIKE type_file.chr1000,                                                                                        
          p_argv1    LIKE pmm_file.pmm01                                                                                           
                                                                                                                                    
   WHENEVER ERROR CONTINUE                                                                                                          
    IF p_argv1 IS NULL OR p_argv1 = ' ' THEN                                                                                        
       CALL cl_err(p_argv1,'mfg3527',0)                                                                                             
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET g_sw = 'Y'                                                                                                                  
WHILE TRUE                                                                                                                          
    #-->條件畫面輸入                                                                                                                
    IF g_sw != 'N' THEN                                                                                                        
       LET p_row = 4 LET p_col = 27                                                                                            
       OPEN WINDOW aimt370_wo_g AT p_row,p_col          #條件畫面 
              WITH FORM "aim/42f/aimt370_wo"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
       CALL cl_ui_locale("aimt370_wo")                                                                                          
      #CALL cl_set_comp_visible("inb15",g_sma.sma79='N') #MOD-AC0315
       CALL cl_set_comp_visible("inb15_1",g_sma.sma79='Y') #MOD-AC0324 add 
    END IF                                                                                                                     
    CALL t370_wo_tm()                                                                                                             
    IF INT_FLAG THEN                                                                                                           
       CLOSE WINDOW aimt370_wo_g                                                                                                     
       EXIT WHILE                                                                                                              
    END IF                                                                                                                     
    #-->無符合條件資料                                                                                                         
    IF g_sw = 'N' THEN                                                                                                         
       CALL cl_err(g_ina.ina01,'mfg2601',0)                                                                                    
        CONTINUE WHILE                                                                                                          
    END IF                                                                                                                     
    CALL cl_wait()                                                                                                                  
    CALL aimt370_wo_g()                                                                                                                   
    #-->無符合條件資料                                                                                                              
    IF g_sw = 'N' THEN                                                                                                              
       CALL cl_err(g_ina.ina01,'mfg2601',0)                                                                                         
       CONTINUE WHILE                                                                                                               
    END IF                                                                                                                          
    ERROR ""                                                                                                                        
    EXIT WHILE                                                                                                                      
 END WHILE                                                                                                                          
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF                                                                                 
    CLOSE WINDOW aimt370_wo_g                                                                                                             
                                                                                                                                    
END FUNCTION  

FUNCTION t370_wo_tm()                                                                                                                  
 DEFINE  l_cnt       LIKE type_file.num5,                                                                                           
         l_wobdate   LIKE type_file.dat,                                                                                            
         l_woedate   LIKE type_file.dat,                                                                                            
         l_sql       LIKE type_file.chr1000,                                                                                        
         l_where     LIKE type_file.chr1000,                                                                                        
         l_n         LIKE type_file.num5, 
         l_flag_wo   LIKE type_file.chr1,   #FUN-D60038 add
         l_pro       STRING                 #FUN-D60038 add
                                                                                                                                    
    #FUN-D60038--add--str--
    IF g_ina.ina00 MATCHES '[34]' THEN
       CALL cl_set_comp_visible("img02,img03,img04",TRUE)
    ELSE
       CALL cl_set_comp_visible("img02,img03,img04",FALSE)
    END IF
    #FUN-D60038--add--end--
    
#------------#MOD-D60019--begin---------- 
#    CONSTRUCT BY NAME g_wc ON sfb01,sfb13,ima06,ima08                                                                               
#    BEFORE  CONSTRUCT                                                                                                               
#       CALL cl_qbe_init()                                                                                                           
#    ON ACTION CONTROLP                                                                                                              
#       CASE                                                                                                                    
#          WHEN INFIELD(sfb01)                                                                                                  
#               CALL cl_init_qry_var()                                                                                          
#               LET g_qryparam.form = "q_sfb"                                                                                   
#               LET g_qryparam.state = 'c'                                                                                      
#               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
#               DISPLAY g_qryparam.multiret TO sfb01                                                                            
#               NEXT FIELD sfb01                                                                                                
#          OTHERWISE EXIT CASE                                                                                                  
#        END CASE                                                                                                               
#    ON IDLE g_idle_seconds 
#        CALL cl_on_idle()                                                                                                           
#        CONTINUE CONSTRUCT                                                                                                          
#                                                                                                                                    
#    ON ACTION about                                                                                                                 
#       CALL cl_about()                                                                                                              
#                                                                                                                                    
#    ON ACTION controlg                                                                                                              
#       CALL cl_cmdask()                                                                                                             
#                                                                                                                                    
#    ON ACTION help                                                                                                                  
#       CALL cl_show_help()                                                                                                          
#                                                                                                                                    
#    END CONSTRUCT 
    INITIALIZE tm1.* TO NULL      
    INPUT BY NAME tm1.sfb01,tm1.sfb13,tm1.ima06,tm1.ima08                                                                                
                                                                                                              
    ON ACTION CONTROLP                                                                                                              
       CASE                                                                                                                    
          WHEN INFIELD(sfb01)                                                                                                  
               CALL cl_init_qry_var()                                                                                          
               LET g_qryparam.form = "q_sfb"                                                                                   
               CALL cl_create_qry() RETURNING tm1.sfb01                                                            
               DISPLAY BY NAME tm1.sfb01                                                                            
               NEXT FIELD sfb01                                                              
           #FUN-D70027 add---------str
           WHEN INFIELD(ima06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_imz"
              CALL cl_create_qry() RETURNING tm1.ima06
              DISPLAY BY NAME tm1.ima06
              NEXT FIELD ima06
           WHEN INFIELD(ima08)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima08_1"
              CALL cl_create_qry() RETURNING tm1.ima08
              DISPLAY BY NAME tm1.ima08
              NEXT FIELD ima08
           #FUN-D70027 add---------end
          OTHERWISE EXIT CASE                                                                                                  
        END CASE                                                                                                               
    ON IDLE g_idle_seconds 
        CALL cl_on_idle()                                                                                                           
        CONTINUE INPUT                                                                                                          
                                                                                                                                    
    ON ACTION about                                                                                                                 
       CALL cl_about()                                                                                                              
                                                                                                                                    
    ON ACTION controlg                                                                                                              
       CALL cl_cmdask()                                                                                                             
                                                                                                                                    
    ON ACTION help                                                                                                                  
       CALL cl_show_help()                                                                                                          
                                                                                                                                    
    END INPUT  
#------------#MOD-D60019--end----------                                                                                                                            
    IF INT_FLAG THEN RETURN END IF                                                                                                  
    CALL cl_wait()
    #------------#MOD-D60019--begin----------  
    LET g_wc = " sfb01 = '",tm1.sfb01,"'"
    IF NOT cl_null(tm1.sfb13) THEN
       LET g_wc = g_wc," AND sfb13 = '",tm1.sfb13,"'"
    END IF  
    IF NOT cl_null(tm1.ima06) THEN
       LET g_wc = g_wc," AND ima06 = '",tm1.ima06,"'"
    END IF  
    IF NOT cl_null(tm1.ima08) THEN
       LET g_wc = g_wc," AND ima08 = '",tm1.ima08,"'"
    END IF
    #------------#MOD-D60019--end----------                                                       
    #-->讀取工單最早開工日期/最晚開工日期                                                                                           
    LET l_sql = "SELECT min(sfb13),max(sfb13) ",                                                                                    
                "  FROM sfb_file,ima_file,sfa_file ",                                                                               
                " WHERE sfb01 = sfa01 ",                                                                                            
                "   AND sfa03 = ima01 ",                                                                                            
                "   AND sfb87!='X' AND ", g_wc CLIPPED                                                                              
                                                                                                                                    
    PREPARE p470_predate  FROM l_sql                                                                                                
    DECLARE p470_curdate CURSOR FOR p470_predate
    LET g_sw = 'Y'                                                                                                                  
    FOREACH p470_curdate INTO l_wobdate,l_woedate                                                                                   
        IF SQLCA.sqlcode THEN                                                                                                       
           CALL cl_err('p470_curdate',SQLCA.sqlcode,0)                                                                              
           EXIT FOREACH                                                                                                             
        END IF                                                                                                                      
        IF (l_wobdate IS NULL OR l_wobdate = ' ') AND                                                                               
           (l_woedate IS NULL OR l_woedate = ' ')                                                                                   
        THEN LET g_sw = 'N'                                                                                                         
             EXIT FOREACH                                                                                                           
        END IF                                                                                                                      
    END FOREACH                                                                                                                     
    IF g_sw = 'N' THEN RETURN END IF                                                                                                
    ERROR ""                                                                                                                        
#   INITIALIZE tm1.* TO NULL                      # Default condition      #MOD-D60019 mark                                                           
   LET tm1.sudate = l_woedate                                                                                                        
   INPUT BY NAME tm1.sudate,tm1.img02,tm1.img03,tm1.img04,tm1.inb15,tm1.inb15_1  #MOD-AC0324 add inb15_1  #FUN-D60038  
                 WITHOUT DEFAULTS HELP 1                                                                                            
      AFTER FIELD sudate    #工單範圍中最晚開工日期前一天                                                                           
         IF tm1.sudate IS NULL OR tm1.sudate = ' ' THEN                                                                               
            NEXT FIELD sudate                                                                                                       
         END IF
      
      #FUN-D60038--add--str--
      AFTER FIELD img02,img03,img04
         IF INFIELD(img03) AND cl_null(tm1.img03) THEN LET tm1.img03 = ' ' END IF
         IF INFIELD(img04) AND cl_null(tm1.img04) THEN LET tm1.img04 = ' ' END IF
         CALL t370_wo_chk_img(tm1.img02,tm1.img03,tm1.img04) RETURNING l_flag_wo,l_pro 
         IF NOT l_flag_wo THEN 
            CASE l_pro 
               WHEN 'img02' NEXT FIELD img02
               WHEN 'img03' NEXT FIELD img03
               OTHERWISE EXIT CASE
            END CASE
         END IF 
      #FUN-D60038--add--end--

      AFTER FIELD inb15                                                                                                           
         IF NOT t370_wo_chk_inb15(tm1.inb15) THEN                                                                                             
            NEXT FIELD CURRENT                                                                                                    
         END IF 

     #MOD-AC0324 --add start-----------
      AFTER FIELD inb15_1
         IF NOT t370_wo_chk_inb15_1(tm1.inb15_1) THEN
            NEXT FIELD CURRENT
         END IF 
     #MOD-AC0324 --add end-----------    
        ON ACTION controlp
           CASE 
           #FUN-D60038--add--str--
              WHEN INFIELD(img02) OR INFIELD(img03) OR INFIELD(img04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_img11"
                 LET g_qryparam.default1 = tm1.img02
                 LET g_qryparam.default2 = tm1.img03
                 LET g_qryparam.default3 = tm1.img04
                 CALL cl_create_qry() RETURNING tm1.img02,tm1.img03,tm1.img04
                 IF cl_null(tm1.img02) THEN LET tm1.img02 = ' ' END IF
                 IF cl_null(tm1.img03) THEN LET tm1.img03 = ' ' END IF
                 IF cl_null(tm1.img04) THEN LET tm1.img04 = ' ' END IF
                 DISPLAY BY NAME tm1.img02,tm1.img03,tm1.img04 
                 IF INFIELD(img02) THEN NEXT FIELD img02 END IF
                 IF INFIELD(img03) THEN NEXT FIELD img03 END IF
                 IF INFIELD(img04) THEN NEXT FIELD img04 END IF
           #FUN-D60038--add--end--
              WHEN INFIELD(inb15)      #理由码
                #MOD-AC0324 mark begin-----------
                # CALL cl_init_qry_var()                                                                                              
                # LET g_qryparam.form ="q_azf"                                                                                        
                # LET g_qryparam.default1 = tm1.inb15                                                                                  
                ##MOD-AC0115---add---start---
                # IF g_sma.sma79 = 'Y' THEN
                #    LET g_qryparam.arg1 = "A2"  
                # ELSE                       
                ##MOD-AC0115---add---end---                                                          
                #    LET g_qryparam.arg1 = "2"                                                                                   
                # END IF            #MOD-AC0115 add
                # CALL cl_create_qry() RETURNING tm1.inb15                                                                             
                #MOD-AC0324 mark end-------------
            #MOD-AC0324 ------------mod start by vealxu --------------
                ##MOD-AC0324 add begin------------
                #IF g_sma.sma79='Y' THEN
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form ="q_azf"
                #   LET g_qryparam.default1 = tm1.inb15,'A2'   
                #   LET g_qryparam.arg1 = "A2"     
                #   LET g_qryparam.state = "c"
                #   CALL cl_create_qry() RETURNING tm1.inb15
                #ELSE
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form ="q_azf01a"       
                #   LET g_qryparam.default1 = tm1.inb15,'2'
                #   LET g_qryparam.arg1 = "4"       
                #   LET g_qryparam.state = "c"
                #   CALL cl_create_qry() RETURNING tm1.inb15 
                #END IF
                ##MOD-AC0324 add end--------------
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azf01a"
                   LET g_qryparam.default1 = tm1.inb15
                   LET g_qryparam.arg1 = "4"
                   CALL cl_create_qry() RETURNING tm1.inb15
                   DISPLAY tm1.inb15 TO FORMONLY.inb15
                   NEXT FIELD inb15
                
              WHEN INFIELD(inb15_1)     #保税理由码
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_azf06"                      #MOD-C70176  q_azf->q_azf06 #CHI-C40009
                 LET g_qryparam.form ="q_azf"  #CHI-C40009
                 LET g_qryparam.default1 = tm1.inb15_1
                #LET g_qryparam.arg1 = "A2"                          #MOD-C70176 mark
                 LET g_qryparam.arg1 = "A"     #CHI-C40009
                 CALL cl_create_qry() RETURNING tm1.inb15_1
                 DISPLAY tm1.inb15_1 TO FORMONLY.inb15_1
                 NEXT FIELD inb15_1
            #MOD-AC0324----------mod end by vealxu --------------    
              OTHERWISE EXIT CASE 
           END CASE
        ON KEY(CONTROL-G)                                                                                                           
            CALL cl_cmdask()                                                                                                        
                                                                                                                                    
        ON IDLE g_idle_seconds                                                                                                      
          CALL cl_on_idle()                                                                                                         
          CONTINUE INPUT                                                                                                            
                                                                                                                                    
        AFTER INPUT                                                                                                                 
          IF INT_FLAG THEN EXIT INPUT END IF                                                                                        
          IF tm1.sudate IS NULL AND tm1.sudate = ' '                                                                                  
          THEN NEXT FIELD sudate                                                                                                    
          END IF                                                                                                                    
          IF INT_FLAG THEN EXIT INPUT END IF                                                                                        
   END INPUT                                                                                                                        
   IF INT_FLAG THEN RETURN END IF                                                                                                   
END FUNCTION

FUNCTION t370_wo_chk_inb15(p_argv)
   DEFINE l_acti   LIKE azf_file.azfacti                                                                                              
   DEFINE l_ima15  LIKE ima_file.ima15  
   DEFINE p_argv   LIKE inb_file.inb15                                                                                                                                 
   DEFINE l_azf09  LIKE azf_file.azf09

   LET g_buf=NULL 
   IF NOT cl_null(p_argv) THEN                                                                                           
    #MOD-AC0324 -------------------mark start------------------------------
    ##MOD-AC0115-add---start---
    # IF g_sma.sma79 = 'Y' THEN   
    #    SELECT azf03 INTO g_buf FROM azf_file                                                                                     
    #     WHERE azf01=p_argv AND (azf02 = '2' OR azf02 = 'A')
    #   #MOD-AC0324 add begin-----------
    #   #IF STATUS THEN     #MOD-AC0324 mark
    #    IF cl_null(g_buf) THEN  #MOD-AC0324 
    #       CALL cl_err('','aic-040',1)
    #       RETURN FALSE
    #    END IF
    #   #MOD-AC0324 add end-------------
    # ELSE              
    ##MOD-AC0115---add---end---
    #MOD-AC0324 --------------------mark end----------------------------
         SELECT azf03 INTO g_buf FROM azf_file                                                                                     
          WHERE azf01=p_argv AND azf02='2'
        #MOD-AC0324 add begin-----------
        #IF STATUS THEN                      #MOD-AC0324 mark
         IF cl_null(g_buf) THEN              #MOD-AC0324  
            CALL cl_err('','aic-040',1)
            RETURN FALSE
         END IF

         SELECT azf09 INTO l_azf09 FROM azf_file
          WHERE azf01=p_argv AND azf02='2'
         IF l_azf09 != '4' OR cl_null(l_azf09) THEN  #TQC-970197
            CALL cl_err('','aoo-403',0)
            RETURN FALSE
         END IF 
        #MOD-AC0324 add end-------------
    # END IF         #MOD-AC0115 add      #MOD-AC0324 mark
      #MOD-AC0324 mark begin-----------
      #IF STATUS THEN                                                                                                            
      #   CALL cl_err('','aic-040',1)
      #   RETURN FALSE                                                                                                           
      #END IF 
      #MOD-AC0324 mark end-------------
      ####判斷理由碼是否為"失效",失效情況下則不能輸入                                                                                      
      SELECT azfacti INTO l_acti FROM azf_file WHERE azf01 = p_argv 
         AND azf02='2'  #CHI-C40009
      IF l_acti <> 'Y' THEN                                                                                                            
#        CALL cl_err('','apy-541',1)    #CHI-B40058
        #MOD-EC0007------mod---str---
        #CALL cl_err('','aim-163',1)  #CHI-B40058
         CALL cl_err('','aim-946',1)                
        #MOD-EC0007------mod---end---
         RETURN FALSE                                                                                                                  
      END IF    
   ELSE                                                                                                                             
      IF g_smy.smy59 = 'Y' THEN                                                                                                     
         CALL cl_err('','apj-201',0)                                                                                                
         RETURN FALSE                                                                                                               
      END IF                                                                                                                        
   END IF                                                                                                                           
   RETURN TRUE                                                                                                                      
END FUNCTION

#MOD-AC0324 ----------add start----------
FUNCTION t370_wo_chk_inb15_1(p_argv)
   DEFINE l_acti   LIKE azf_file.azfacti
   DEFINE l_ima15  LIKE ima_file.ima15
   DEFINE p_argv   LIKE inb_file.inb15

   LET g_buf=NULL
   IF NOT cl_null(p_argv) THEN
      SELECT azf03 INTO g_buf FROM azf_file
       #WHERE azf01=p_argv AND (azf02 = '2' OR azf02 = 'A') #CHI-C40009
       WHERE azf01=p_argv AND azf02 = 'A'  #CHI-C40009
      IF cl_null(g_buf) THEN  #MOD-AC0324
         CALL cl_err('','aic-040',1)
         RETURN FALSE
      END IF
      ####判斷理由碼是否為"失效",失效情況下則不能輸入
      SELECT azfacti INTO l_acti FROM azf_file WHERE azf01 = p_argv
         AND azf02 = 'A'  #CHI-C40009
      IF l_acti <> 'Y' THEN
#        CALL cl_err('','apy-541',1)    #CHI-B40058
        #MOD-EC0007------mod---str---
        #CALL cl_err('','aim-163',1)  #CHI-B40058
         CALL cl_err('','aim-946',1)                
        #MOD-EC0007------mod---end---
         RETURN FALSE
      END IF
   ELSE
      IF g_smy.smy59 = 'Y' THEN
         CALL cl_err('','apj-201',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#MOD-AC0324 ----------add end-----------

FUNCTION aimt370_wo_g()                                                                                                                   
  DEFINE  l_sql      LIKE type_file.chr1000,                                                                                        
          l_sfa03    LIKE sfa_file.sfa03,                                                                                           
          l_sfa05    LIKE sfa_file.sfa05,
          l_sfa12    LIKE sfa_file.sfa12,
          l_sfa26    LIKE sfa_file.sfa26,                                                                                           
          l_sfb25    LIKE sfb_file.sfb25,                                                                                           
          l_sfb98    LIKE sfb_file.sfb98,
#          l_ima262   LIKE ima_file.ima262,   #No.FUN-A20044                                                                                       
          l_ima27    LIKE ima_file.ima27,                                                                                           
          l_ima45    LIKE ima_file.ima45,                                                                                           
          l_ima46    LIKE ima_file.ima46,
          l_ima24    LIKE ima_file.ima24,   #TQC-9B0037                                                                                           
          l_ima25    LIKE ima_file.ima25    #TQC-9B0037                                                                                           
  DEFINE  l_ina01    LIKE ina_file.ina01    #FUN-B30053
  DEFINE  l_smy57    LIKE smy_file.smy57    #FUN-B30053
  DEFINE  l_sfa01    LIKE sfa_file.sfa01    #FUN-DB0029 add

    #-->料件/替代碼/本次需求量                                                                                                      
   #LET l_sql = "SELECT UNIQUE sfa03,sfa12,sfa26,sfb25,sfb98,ima24,ima25,sum(sfa05)", #TQC-9B0037                                                 
    LET l_sql = "SELECT UNIQUE sfa03,'',sfa12,sfa26,sfb25,sfb98,'',ima25,sum(sfa05)", #TQC-9B0037 #FUN-B30053 ima24-->'' #FUN-DB0029 add '' as sfa01
                "  FROM sfa_file,sfb_file,ima_file",                                                                                
                " WHERE sfa01 = sfb01 ",                                                                                            
                "   AND sfb04 != '8' ",                                                                                             
                "  AND sfb02 != '2'  AND sfb02 != '11' AND sfb87!='X' ",                                                            
                "  AND sfa065 = 0 ", 
                "   AND sfa11 != 'X' AND sfa11 !='S' ",                #MOD-D60019 add                                                                                                 
                "   AND sfa03 = ima01 AND ", g_wc CLIPPED,                                                                          
               #" GROUP BY sfa03,sfa12,sfa26,sfb25,sfb98,ima24,ima25", #TQC-9B0037                                                                                      
                " GROUP BY sfa03,sfa12,sfa26,sfb25,sfb98,ima25",     #FUN-B30053 del ima24
                " ORDER BY sfa03,sfa12,sfa26,sfb25,sfb98"  #TQC-9B0037                                                                                                   
    PREPARE t370_wo_prepare FROM l_sql                                                                                                 
    DECLARE t370_wo_cs                         #CURSOR                                                                                 
        CURSOR FOR t370_wo_prepare             #TQC-9B0037                                                                              
    #-->單身預設值                                                                                                              
    CALL t370_g_init() 
    SELECT max(inb03)+1 INTO g_seq FROM inb_file WHERE inb01 = g_ina.ina01                                                       
    IF g_seq IS NULL OR g_seq = ' ' OR g_seq = 0  THEN                                                                               
       LET g_seq = 1                                                                                                           
    END IF                                                                                                                       
    LET g_sw = 'N'                                                                                                                  
    LET g_success = 'Y'
    BEGIN WORK                                                                                                                      
    CALL s_showmsg_init() 
    FOREACH t370_wo_cs INTO l_sfa03,l_sfa01,l_sfa12,l_sfa26,l_sfb25,l_sfb98,l_ima24,l_ima25,l_sfa05  #TQC-9B0037  #FUN-DB0029 add l_sfa01
       IF SQLCA.sqlcode THEN                                                                                                        
         LET g_success = 'N'                                                                                                        
         IF g_bgerr THEN                                                                                                            
             CALL s_errmsg('sfa03',l_sfa03,"t370_wo_cs",SQLCA.sqlcode,1)#TQC-9B0037                                                                         
         ELSE                                                                                                                       
            CALL cl_err('t370_wo_cs',SQLCA.sqlcode,0)                   #TQC-9B0037
         END IF                                                                                                                     
         EXIT FOREACH                                                                                                              
       END IF          
       #FUN-B30053-add-str--
       LET l_ina01 = s_get_doc_no(g_ina.ina01)
       SELECT smy57 INTO l_smy57
        FROM  smy_file WHERE smyslip = l_ina01 AND smyacti = 'Y'
       IF cl_null(l_smy57[2,2]) THEN
          LET l_smy57[2,2] = 'N'
       END IF
       LET l_ima24 = l_smy57[2,2]
       #FUN-B30053-add-end--
       LET g_sw = 'Y'                                                                                                             
       #--->產生單身檔                                                                                                       
       CALL aimt370_wo_ins_inb(l_sfa03,l_sfa01,l_sfa05,l_sfa12,l_sfa26,l_sfb25,l_sfb98,l_ima24,l_ima25) #TQC-9B0037  #FUN-DB0029 add
       IF g_success = 'N' THEN EXIT FOREACH END IF                                                                               
    END FOREACH

    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
                                                                                                                                    
   #CALL s_showmsg()    #CHI-G10002 mark
    IF g_success = 'Y' THEN                                                                                                         
       COMMIT WORK                                                                                                                  
    ELSE                                                                                                                            
       ROLLBACK WORK                                                                                                                
    END IF                                                                                                                          
    CALL s_showmsg()    #CHI-G10002 add 
END FUNCTION 

FUNCTION aimt370_wo_ins_inb(p_sfa03,p_sfa01,p_sfa05,p_sfa12,p_sfa26,p_sfb25,p_sfb98,p_ima24,p_ima25) #TQC-9B0037  #FUN-DB0029 add p_sfa01
DEFINE p_sfa03  LIKE sfa_file.sfa03
DEFINE p_sfa05  LIKE sfa_file.sfa05
DEFINE p_sfa12  LIKE sfa_file.sfa12
DEFINE p_sfa26  LIKE sfa_file.sfa26
DEFINE p_sfb25  LIKE sfb_file.sfb25
DEFINE p_sfb98  LIKE sfb_file.sfb98
DEFINE p_ima24  LIKE ima_file.ima24   #TQC-9B0037
DEFINE p_ima25  LIKE ima_file.ima25   #TQC-9B0037
DEFINE l_i      LIKE type_file.num5   #TQC-9B0037
DEFINE l_ima908 LIKE ima_file.ima908
DEFINE l_ima906 LIKE ima_file.ima906
DEFINE l_ima907 LIKE ima_file.ima907
DEFINE l_ima44  LIKE ima_file.ima44
DEFINE l_factor LIKE ima_file.ima31_fac 
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_ima15  LIKE ima_file.ima15  #MOD-AC0324
DEFINE p_sfa01  LIKE sfa_file.sfa01  #FUN-DB0029 add
DEFINE l_sql    STRING               #FUN-DB0029 add
DEFINE l_rvbs09 LIKE rvbs_file.rvbs09  #TQC-DC0083 add

   INITIALIZE b_inb.* TO NULL  #TQC-9B0037
   LET b_inb.inb01  = g_ina.ina01  #TQC-9B0037 
   LET b_inb.inb908 = 0            #MOD-DB0029 add
   LET b_inb.inb04=p_sfa03
   #MOD-D60019--begin----------
   SELECT sfa30,sfa31 INTO b_inb.inb05,b_inb.inb06 FROM sfa_file ## 倉儲                                                
       WHERE sfa03 = p_sfa03 AND sfa01 = tm1.sfb01
   #MOD-D60019--end----------  
   IF cl_null(tm1.img02) THEN   #FUN-D60038
      IF cl_null(b_inb.inb05) THEN         #MOD-D60019
         SELECT ima35,ima36 INTO b_inb.inb05,b_inb.inb06 FROM ima_file ## 倉儲                                                
          WHERE ima01 = b_inb.inb04 AND imaacti = 'Y' 
      END IF                               #MOD-D60019
   #FUN-D60038--add--str--
   ELSE
      LET b_inb.inb05 = tm1.img02
      LET b_inb.inb06 = tm1.img03
      LET b_inb.inb07 = tm1.img04
   END IF 
   #FUN-D60038--add--end--
   #CHI-C30125 str add-----
    IF NOT s_chksmz(b_inb.inb04, g_ina.ina01,
                    b_inb.inb05, b_inb.inb06) THEN
       LET b_inb.inb05 =' '
       LET b_inb.inb06 =' '
    END IF
   #CHI-C30125 end add-----
#FUN-AB0066 --begin--
#   #No.FUN-AA0049--begin
#   IF NOT s_chk_ware(b_inb.inb05) THEN
#      LET b_inb.inb05=' '
#      LET b_inb.inb06=' '
#   END IF 
#   #No.FUN-AA0049--end                                                               
#FUN-AB0066 --end--   
   LET b_inb.inb08 = p_sfa12
   LET b_inb.inb10 = p_ima24
   LET b_inb.inb03 = g_seq
   LET b_inb.inb09 = p_sfa05 
   LET b_inb.inb16 = p_sfa05
  #LET b_inb.inb15 = tm1.inb15   #MOD-AC0324 makr 
   LET b_inb.inb930 = p_sfb98
   CALL s_umfchk(b_inb.inb04,p_sfa12,p_ima25)  RETURNING l_i,b_inb.inb08_fac #TQC-9B0037
   IF l_i = 1 THEN LET b_inb.inb08_fac = 1 END IF #TQC-9B0037
   IF cl_null(b_inb.inb06) THEN LET b_inb.inb06 = ' ' END IF  #TQC-9B0037
   IF cl_null(b_inb.inb07) THEN LET b_inb.inb07 = ' ' END IF  #TQC-9B0037
  #MOD-AC0324 --------add start-------------
   SELECT ima15 INTO l_ima15 FROM ima_file
    WHERE ima01 = b_inb.inb04
   IF g_sma.sma79 = 'Y' AND l_ima15 = 'Y' THEN
      LET b_inb.inb15 = tm1.inb15_1
   ELSE
      LET b_inb.inb15 = tm1.inb15
   END IF 
  #MOD-AC0324 --------add end------------ 
   IF g_sma.sma115 = 'Y' THEN                                                                                           
      LET b_inb.inb902 = p_sfa12          #單位一
      LET b_inb.inb903 = b_inb.inb08_fac  #單位一換算率(與庫存單位)  #MOD-A50144 add
      LET b_inb.inb904 = b_inb.inb09      #單位一數量                #MOD-A50144 add
      LET b_inb.inb922 = b_inb.inb902     #申請單位一                #MOD-A50144 add
      LET b_inb.inb923 = b_inb.inb903     #申請單位一換算率          #MOD-A50144 add
      LET b_inb.inb924 = b_inb.inb904     #申請單位一數量            #MOD-A50144 add
      CALL s_chk_va_setting(b_inb.inb04)                                                                           
         RETURNING g_flag,g_ima906,g_ima907                                                                            
     #str MOD-A50144 add
      IF g_ima906 = '1' THEN                                                                                             
         LET b_inb.inb905=''              #單位二
         LET b_inb.inb906=''              #單位二換算率(與庫存單位)
         LET b_inb.inb907=''              #單位二數量
      ELSE
     #end MOD-A50144 add
     #IF g_ima906 = '3' THEN   #MOD-A50144 mark
         LET b_inb.inb905=g_ima907
     #str MOD-A50144 add
         #採購單位ima44
         SELECT ima44 INTO l_ima44 FROM ima_file WHERE ima01=b_inb.inb04
         LET l_factor = 1
         CALL s_umfchk(b_inb.inb04,b_inb.inb905,l_ima44)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET b_inb.inb906=l_factor
         LET b_inb.inb907=0
         IF g_ima906 = '3' THEN
            LET l_factor = 1
            CALL s_umfchk(b_inb.inb04,b_inb.inb902,b_inb.inb905)
                 RETURNING l_cnt,l_factor
            IF l_cnt = 1 THEN
               LET l_factor = 1
            END IF
            LET b_inb.inb907=b_inb.inb904*l_factor
            LET b_inb.inb907=s_digqty(b_inb.inb907,b_inb.inb905)    #FUN-BB0085
         END IF
      END IF
      LET b_inb.inb925 = b_inb.inb905     #申請單位二
      LET b_inb.inb926 = b_inb.inb906     #申請單位二換算率
      LET b_inb.inb927 = b_inb.inb907     #申請單位二數量
     #end MOD-A50144 add
   END IF
   SELECT ima908 INTO l_ima908                                                                                       
     FROM ima_file                                                                                                   
    WHERE ima01=b_inb.inb04                                                                                          
   LET b_inb.inblegal = g_legal   #MOD-A50144 add
   LET b_inb.inbplant = g_plant   #FUN-A60028   
  #TQC-D30066 -----Begin--------
   IF g_ccz.ccz28 = '6' AND (g_argv1  = '3' OR g_argv1 = '4') THEN
      IF b_inb.inb13 <= 0 OR b_inb.inb13 IS NULL THEN
         SELECT cfa12 INTO b_inb.inb13 FROM cfa_file
          WHERE cfa01 = b_inb.inb04
            AND cfa04 = 1
            AND cfa02 = (SELECT MAX(cfa02) FROM cfa_file WHERE cfa01= b_inb.inb04 AND cfa04=1 )
      END IF
      IF cl_null(b_inb.inb13) THEN LET b_inb.inb13 = 0 END IF
      IF cl_null(b_inb.inb09) THEN LET b_inb.inb09 = 0 END IF
      LET b_inb.inb14 = b_inb.inb13 * b_inb.inb09
      LET b_inb.inb14 = cl_digcut(b_inb.inb14,g_azi03)  #TQC-D80003 add
   END IF
  #TQC-D30066 -----End----------
   #FUN-D60038--add--str-- 寫入單身
   LET l_cnt = 0
   LET l_img_flag = ''
   SELECT COUNT(*) INTO l_cnt FROM img_file
    WHERE img01=b_inb.inb04 AND img02=b_inb.inb05
      AND img03=b_inb.inb06 AND img04=b_inb.inb07
   IF l_cnt = 0 AND g_ina.ina00 MATCHES '[34]' THEN 
      IF cl_null(l_img_flag) THEN
         LET l_img_flag = 'Y'
         IF g_sma.sma892[3,3] = 'Y' THEN
            IF g_bgjob='N' OR cl_null(g_bgjob) THEN
               IF NOT cl_confirm('mfg1401') THEN
                  LET l_img_flag = 'N' 
               END IF
            END IF
         END IF
      END IF
      IF l_img_flag = 'Y' THEN 
         CALL s_add_img(b_inb.inb04,b_inb.inb05,b_inb.inb06,b_inb.inb07,g_ina.ina01,b_inb.inb03,g_ina.ina02)
      END IF
   END IF
   #FUN-D60038--add--end--
   INSERT INTO inb_file VALUES(b_inb.*)                                                                              
   IF SQLCA.SQLCODE THEN                                                                                             
      ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE  
   END IF
   LET g_seq = g_seq + 1 
END FUNCTION 

FUNCTION t370_del()
DEFINE l_flag   LIKE type_file.chr1  #MOD-D40175

   DELETE FROM inb_file WHERE inb01 = g_ina.ina01
END FUNCTION

#FUN-B50138--begin--add----
FUNCTION t370_refresh()
 DEFINE l_ina    RECORD LIKE ina_file.*

 SELECT * INTO l_ina.* FROM ina_file WHERE ina01=g_ina.ina01
 RETURN l_ina.*
END FUNCTION
#FUN-B50138--end--add---

#No.FUN-9C0072 精簡程式碼

#No:DEV-D30026--add--begin
#DEV-D30045--mark--begin
#FUNCTION t370_barcode_gen()
#   DEFINE l_inb03   LIKE inb_file.inb03
#   DEFINE l_inb04   LIKE inb_file.inb04
#   DEFINE l_inb09   LIKE inb_file.inb09
#   DEFINE l_ima918  LIKE ima_file.ima918
#   DEFINE l_ima919  LIKE ima_file.ima919
#   DEFINE l_ima920  LIKE ima_file.ima920
#   DEFINE l_ima921  LIKE ima_file.ima921
#   DEFINE l_ima922  LIKE ima_file.ima922
#   DEFINE l_ima923  LIKE ima_file.ima923
#   DEFINE l_ima931  LIKE ima_file.ima931
#   DEFINE l_ima933  LIKE ima_file.ima933
#   DEFINE l_count   LIKE type_file.num5
#   DEFINE l_n       LIKE type_file.num5
#   DEFINE l_sql     STRING
#   DEFINE l_cnt     LIKE type_file.num5 #DEV-D30026 add
#
#   IF cl_null(g_ina.ina01) THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
#
#   SELECT * INTO g_ina.* FROM ina_file WHERE ina01 = g_ina.ina01
#
#   IF g_ina.inaconf = 'N' THEN
#      CALL cl_err('','sfb-999',0)
#      RETURN
#   END IF
#
#   IF g_ina.inaconf = 'X' THEN
#      CALL cl_err('','sfb-998',0)
#      RETURN
#   END IF
#
#   #DEV-D30026 add----str---
#   LET l_cnt = 0
#   SELECT COUNT(*) INTO l_cnt
#     FROM tlfb_file
#    WHERE tlfb01 IN (SELECT UNIQUE ibb01 FROM ibb_file
#                      WHERE ibb03 = g_ina.ina01)
#   IF l_cnt >=1 THEN
#      #在條碼掃瞄異動記錄檔(tlfb_file)已有異動的記錄,不可再重新產生條碼!
#      CALL cl_err(g_ina.ina01,'aba-127',1)
#      RETURN
#   END IF
#   #DEV-D30026 add----end---
#
#   #No:DEV-CB0002--add--begin
#   LET g_success = 'Y'
#   CALL s_showmsg_init()
#   BEGIN WORK
#
#   OPEN t370_cl USING g_ina.ina01
#   IF STATUS THEN
#      CALL cl_err("OPEN t370_cl:", STATUS, 1)
#      CLOSE t370_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   FETCH t370_cl INTO g_ina.*          # 鎖住將被更改或取消的資料
#   IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)     # 資料被他人LOCK
#       CLOSE t370_cl ROLLBACK WORK RETURN
#   END IF
#   #No:DEV-CB0002--add--end
#
#
#   SELECT COUNT(*) INTO l_count FROM ibb_file
#    WHERE ibb02 = 'I'
#      AND ibb03 = g_ina.ina01
#   IF l_count > 0 THEN
#      IF NOT cl_confirm('sfb-995') THEN
#         ROLLBACK WORK #No:DEV-CB0002--add
#         RETURN
#      END IF
#      DELETE FROM iba_file WHERE iba01 IN (SELECT ibb01 FROM ibb_file
#                                            WHERE ibb02 = 'I'
#                                              AND ibb03 = g_ina.ina01)
#      IF SQLCA.sqlcode THEN
#         CALL cl_err3("del","iba_file",g_ina.ina01,'',SQLCA.sqlcode,"","",1)
#         LET g_success = 'N' #No:DEV-CB0002--add
#         ROLLBACK WORK       #No:DEV-CB0002--add
#         RETURN
#      END IF
#      DELETE FROM ibb_file WHERE ibb02 = 'I' AND ibb03 = g_ina.ina01
#      IF SQLCA.sqlcode THEN
#         CALL cl_err3("del","ibb_file",g_ina.ina01,'',SQLCA.sqlcode,"","",1)
#         LET g_success = 'N' #No:DEV-CB0002--add
#         ROLLBACK WORK       #No:DEV-CB0002--add
#         RETURN
#      END IF
#   END IF
#   LET l_sql = "SELECT inb03,inb04,inb09,ima931,ima933, ",
#               "       ima918,ima919,ima920,ima921,ima922,ima923",
#               "  FROM inb_file,ima_file",
#               " WHERE inb01 = '",g_ina.ina01,"' ",
#               "   AND inb04 = ima01 ",
#               "   AND ima930 = 'Y' ",
#               "   AND ima932 IN('A','F','G')",
#               " ORDER BY inb03 "
#   PREPARE inb_prep FROM l_sql
#   DECLARE inb_cs CURSOR FOR inb_prep
#
#   LET l_n = 0
#   FOREACH inb_cs INTO l_inb03,l_inb04,l_inb09,l_ima931,l_ima933,
#                       l_ima918,l_ima919,l_ima920,l_ima921,l_ima922,l_ima923
#      IF STATUS THEN
#         CALL cl_err('FOREACH inb_cs:',STATUS,0)
#         LET g_success = 'N' #No:DEV-CB0002--add
#         EXIT FOREACH
#      END IF
#
#      IF cl_null(l_inb09) THEN LET l_inb09 = 0 END IF
#
#      IF l_ima918 = 'Y' AND l_ima919 = 'Y' THEN
#         LET l_n = l_n + 1
#         CALL s_gen_barcode('1','I',g_ina.ina01,l_inb03,l_inb04,l_inb09)
#      END IF
#
#      IF l_ima921 = 'Y' AND l_ima922 = 'Y' THEN
#         LET l_n = l_n + 1
#         CALL s_gen_barcode('2','I',g_ina.ina01,l_inb03,l_inb04,l_inb09)
#      END IF
#
#      IF l_ima931 = 'Y' THEN
#         LET l_n = l_n + 1
#         CALL s_gen_barcode('3','I',g_ina.ina01,l_inb03,l_inb04,l_inb09)
#      END IF
#   END FOREACH
#   IF l_n = 0 THEN
#      CALL cl_err('','aba-118',0)
#      LET g_success = 'N' #No:DEV-CB0002--add
#     #RETURN              #No:DEV-CB0002--mark
#   END IF
#
#   #No:DEV-CB0002--add--begin
#   CALL s_showmsg()
#   IF g_success='Y' THEN
#      CALL cl_msgany(0,0,'aba-001')
#      COMMIT WORK
#   ELSE
#      CALL cl_msgany(0,0,'aba-002')
#      COMMIT WORK
#      ROLLBACK WORK
#   END IF
#   #No:DEV-CB0002--add--end
#END FUNCTION
#DEV-D30045--mark--end

FUNCTION t370_chk_smyb(p_ima01)
   DEFINE p_ima01    LIKE ima_file.ima01
   DEFINE l_smyb01   LIKE smyb_file.smyb01
   DEFINE l_ima930   LIKE ima_file.ima930
   DEFINE l_ima932   LIKE ima_file.ima932

   LET g_errno = ''
   IF g_aza.aza131 <> 'Y' OR
      cl_null(g_ina.ina01) OR cl_null(p_ima01) THEN
      RETURN
   END IF

   LET g_t1 = s_get_doc_no(g_ina.ina01)
   LET l_smyb01 = ''
   SELECT smyb01 INTO l_smyb01
     FROM smyb_file
    WHERE smybslip = g_t1

   #DEV-D30026--add---str---
   IF cl_null(l_smyb01) THEN
       LET l_smyb01 = '1' #1:非條碼單據
   END IF
   #DEV-D30026--add---end---

   LET l_ima930 = ''
   LET l_ima932 = ''

   SELECT ima930,ima932
     INTO l_ima930,l_ima932
     FROM ima_file
    WHERE ima01 = p_ima01
   IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF
   IF cl_null(l_ima932) THEN LET l_ima932 = 'N' END IF   #DEV-D50009 add

   CASE
      WHEN l_smyb01 = '1' #1:非條碼單據
        #IF l_ima930 = 'N' THEN #DEV-D30026 mark
         IF l_ima930 = 'Y' THEN #DEV-D30026 add
            #當前單別不允許輸入使用條碼料件！
            LET g_errno = 'aba-036'
         END IF

      WHEN l_smyb01 = '2'
        #IF l_ima930 = 'N' OR l_ima932 = 'H' THEN  #DEV-D30026 mark
         IF l_ima930 = 'N' THEN                    #DEV-D30026 add
            #當前單別只允許輸入使用條碼料件(ima930='Y')!
            LET g_errno = 'aba-095'
         END IF
     #WHEN l_smyb01 = '3'
     #   IF l_ima930 = 'N' OR l_ima932 <> 'H' OR cl_null(l_ima932) THEN
     #      LET g_errno = 'aba-096'
     #   END IF
   END CASE
END FUNCTION
#No:DEV-D30026--add--end

#FUN-CB0087---add---str---
FUNCTION t370_inb15_chk1()
DEFINE  l_flag          LIKE type_file.chr1,
        l_n             LIKE type_file.num5,
        l_where         STRING,
        l_sql           STRING,
        l_azf03         LIKE azf_file.azf03,
        l_azf09         LIKE azf_file.azf09,
        l_azfacti       LIKE azf_file.azfacti,
        l_ima15         LIKE ima_file.ima15
   IF NOT cl_null(g_inb[l_ac].inb15) THEN
      LET l_n = 0
      LET l_flag = FALSE
      #IF g_aza.aza115='Y' THEN  #MOD-D40091
         CALL s_get_where(g_ina.ina01,'','',g_inb[l_ac].inb04,g_inb[l_ac].inb05,g_ina.ina11,g_ina.ina04) RETURNING l_flag,l_where
      #END IF  #MOD-D40091
      #IF g_aza.aza115='Y' AND l_flag THEN  #MOD-D40091
      IF l_flag THEN  #MOD-D40091
         LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_inb[l_ac].inb15,"' AND ",l_where
         PREPARE ggc08_pre2 FROM l_sql
         EXECUTE ggc08_pre2 INTO l_n
         IF l_n < 1 THEN
            CALL cl_err('','aim-425',0)
            RETURN FALSE
         END IF
      ELSE
         #SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_inb[l_ac].inb15 AND azf02 = '2'
         #IF l_n < 1 THEN
         #   CALL cl_err('','aim-425',0)
         LET g_errno = ''
         SELECT ima15 INTO l_ima15 FROM ima_file
          WHERE ima01 = g_inb[l_ac].inb04
            AND imaacti = 'Y'
         IF STATUS THEN
            CALL cl_err3("sel","ima_file",g_inb[l_ac].inb04,"",STATUS,"",
                         "select ima15",1)
            RETURN FALSE
         END IF        
         IF g_sma.sma79='Y' AND l_ima15 = 'Y' THEN
            IF cl_null(g_inb[l_ac].inb15) THEN RETURN FALSE END IF
            SELECT azf03,azfacti INTO l_azf03,l_azfacti FROM azf_file
             WHERE azf01 = g_inb[l_ac].inb15 AND azf02 = 'A'
            IF STATUS THEN
                CALL cl_err3("sel","azf_file",g_inb[l_ac].inb15,"",STATUS,"",
                             "select azf",1)  
                RETURN FALSE
             END IF
         ELSE
            SELECT azf03,azf09,azfacti INTO l_azf03,l_azf09,l_azfacti FROM azf_file   
             WHERE azf01 = g_inb[l_ac].inb15 AND azf02 = '2'

            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                           LET l_azf03 = ''
                                           LET l_azfacti = ''
                 WHEN l_azfacti='N'        LET g_errno = '9028'
                 WHEN l_azf09 != '4'       LET g_errno = 'aoo-403'     
                 WHEN l_azf09 != ''        LET g_errno = 'aoo-403'
                 OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_inb[l_ac].inb15,g_errno,0)
               RETURN FALSE
            END IF
         END IF  
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t370_inb15_chk2()
DEFINE l_flag       LIKE type_file.chr1,
       l_sql        STRING,
       l_where      STRING,
       l_n          LIKE type_file.num5,
       l_i          LIKE type_file.num5,
       l_azf03         LIKE azf_file.azf03,
       l_azf09         LIKE azf_file.azf09,
       l_azfacti       LIKE azf_file.azfacti,
       l_ima15         LIKE ima_file.ima15
   #IF g_aza.aza115 = 'Y' THEN  #MOD-D40091
      FOR l_i=1 TO g_inb.getlength()
         CALL s_get_where(g_ina.ina01,'','',g_inb[l_i].inb04,g_inb[l_i].inb05,g_ina.ina11,g_ina.ina04) RETURNING l_flag,l_where
         IF l_flag THEN
            LET l_n=0
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_inb[l_i].inb15,"' AND ",l_where
            PREPARE ggc08_pre3 FROM l_sql
            EXECUTE ggc08_pre3 INTO l_n
            IF l_n < 1 THEN
               CALL cl_err('','aim-425',0)
               LET g_ina.ina11 = g_ina_t.ina11
               LET g_ina.ina04 = g_ina_t.ina04
               RETURN FALSE
            END IF
         ELSE
            LET g_errno = ''
            LET l_ima15 = ''
            LET l_azf03 = ''
            LET l_azf09 = ''
            LET l_azfacti = ''
            SELECT ima15 INTO l_ima15 FROM ima_file
             WHERE ima01 = g_inb[l_i].inb04
               AND imaacti = 'Y'
            IF STATUS THEN
               CALL cl_err3("sel","ima_file",g_inb[l_i].inb04,"",STATUS,"",
                            "select ima15",1)
               RETURN FALSE
            END IF
            IF g_sma.sma79='Y' AND l_ima15 = 'Y' THEN
               IF cl_null(g_inb[l_i].inb15) THEN RETURN FALSE END IF
               SELECT azf03,azfacti INTO l_azf03,l_azfacti FROM azf_file
                WHERE azf01 = g_inb[l_i].inb15 AND azf02 = 'A'
               IF STATUS THEN
                  CALL cl_err3("sel","azf_file",g_inb[l_i].inb15,"",STATUS,"",
                               "select azf",1)  
                  RETURN FALSE
               END IF
            ELSE
               SELECT azf03,azf09,azfacti INTO l_azf03,l_azf09,l_azfacti FROM azf_file 
                WHERE azf01 = g_inb[l_i].inb15 AND azf02 = '2'

               CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                              LET l_azf03 = ''
                                              LET l_azfacti = ''
                    WHEN l_azfacti='N'        LET g_errno = '9028'
                    WHEN l_azf09 != '4'       LET g_errno = 'aoo-403'     
                    WHEN l_azf09 != ''        LET g_errno = 'aoo-403'
                    OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
              END CASE
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_inb[l_i].inb15,g_errno,0)
                 LET g_ina.ina11 = g_ina_t.ina11
                 LET g_ina.ina04 = g_ina_t.ina04
                 RETURN FALSE
              END IF
            END IF
         END IF
      END FOR
   #END IF  #MOD-D40091
   RETURN TRUE
END FUNCTION
#FUN-CB0087---add---end---
#FUN-D10081---add---str---
FUNCTION t370_list_fill()
  DEFINE l_ina01         LIKE ina_file.ina01
  DEFINE l_i             LIKE type_file.num10

    CALL g_ina_l.clear()
    LET l_i = 1
    #FOREACH t370_fill_cs INTO l_ina01                #CHI-F80014 mark
    FOREACH t370_cs INTO l_ina01                      #CHI-F80014 add
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT ina00,ina01,'',ina02,ina03,ina11,gen02,ina04,
              gem02,ina07,ina10,ina103,ina13,inaconf,ina08,
              inapost,inamksg
         INTO g_ina_l[l_i].*
         FROM ina_file
              LEFT OUTER JOIN gem_file ON gem01 = ina04
              LEFT OUTER JOIN gen_file ON gen01 = ina11
        WHERE ina01=l_ina01
       LET g_buf=s_get_doc_no(g_ina_l[l_i].ina01)
       SELECT smydesc INTO g_ina_l[l_i].smydesc
         FROM smy_file 
        WHERE smyslip = g_buf
       LET g_buf = NULL

       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN
            CALL cl_err( '', 9035, 0 )
          END IF
          EXIT FOREACH
       END IF
    END FOREACH
    OPEN t370_cs                                      #CHI-F80014 add
    LET g_rec_b4 = l_i - 1
    DISPLAY g_rec_b4 TO FORMONLY.cnt                  #CHI-F80014 add
    DISPLAY ARRAY g_ina_l TO s_ina_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    
END FUNCTION

FUNCTION t370_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_ina_l TO s_ina_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
      BEFORE DISPLAY
          CALL fgl_set_arr_curr(g_curs_index)
          CALL cl_navigator_setting( g_curs_index, g_row_count )
       BEFORE ROW
          LET l_ac4 = ARR_CURR()
          LET g_curs_index = l_ac4
          CALL cl_show_fld_cont()

      ON ACTION page_main
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE
         IF g_rec_b4 > 0 THEN
             CALL t370_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_main", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("page_main", TRUE)          
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE
         CALL t370_fetch('/')  
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("page_main", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_main", TRUE)    
         EXIT DISPLAY

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
      ON ACTION first
         CALL t370_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                  
      ON ACTION previous
         CALL t370_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
      ON ACTION jump
         CALL t370_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
      ON ACTION next
         CALL t370_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                
      ON ACTION last
         CALL t370_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY         
      #TQC-D10084---mark---str---          
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY
      #TQC-D10084---mark---end---
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
       ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
         CALL t370_set_perlang()   
         CALL t370_pic() 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION qc_determine_storage
         LET g_action_choice="qc_determine_storage"
         EXIT DISPLAY
 
   #@ ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
   #@ ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION easyflow_approval
         LET g_action_choice="easyflow_approval"
         EXIT DISPLAY
    #@ON ACTION 庫存過帳
      ON ACTION stock_post
         LET g_action_choice="stock_post"
         EXIT DISPLAY
    #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
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
 
 
      ON ACTION CANCEL
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()      
 
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

      #拋轉請購單 20200211
      ON ACTION carry_pr
         LET g_action_choice = "carry_pr"
         EXIT DISPLAY
 
#@    ON ACTION 拋轉至SPC
      ON ACTION trans_spc                     
         LET g_action_choice="trans_spc"
         EXIT DISPLAY
 
      ON ACTION related_document               
         LET g_action_choice="related_document"
         EXIT DISPLAY
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY
 
      ON ACTION warahouse_modify
         LET g_action_choice="warahouse_modify"
         EXIT DISPLAY

      ##---- 20200317 add
      ON ACTION over_qty
         LET g_action_choice = "over_qty"
         EXIT DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION 
#FUN-D10081---add---end---

#FUN-D60038---add--str--
FUNCTION t370_wo_chk_img(p_img02,p_img03,p_img04)
DEFINE p_img02      LIKE img_file.img02
DEFINE p_img03      LIKE img_file.img03
DEFINE p_img04      LIKE img_file.img04
DEFINE l_imdacti    LIKE imd_file.imdacti

   IF NOT cl_null(p_img02) THEN 
      SELECT imdacti INTO l_imdacti FROM imd_file
       WHERE imd01 = p_img02 
      CASE WHEN SQLCA.SQLCODE = 100 
              CALL cl_err( '', 'mfg4020', 0 )          
              RETURN FALSE,'img02'
           WHEN l_imdacti='N' LET g_errno = '9028'
              CALL cl_err( '', '9028', 0 )
              RETURN FALSE,'img02'
           OTHERWISE EXIT CASE  
      END CASE
      
      IF NOT s_imechk(p_img02,p_img03) THEN 
         RETURN FALSE,'img03' 
      END IF
   END IF
   RETURN TRUE,''
END FUNCTION
#FUN-D60038---add--str--


#MOD-FA0119--add--start------------------------------------------------------------------
#傳入修改前後的項次,連動更新相關的表單 p_ima01(料號),p_inb03a(新值),p_inb03b(舊值)
FUNCTION t370_upd_inbc_slk(p_ima01,p_inb03a,p_inb03b)
DEFINE p_ima01    LIKE ima_file.ima01
DEFINE p_inb03a   LIKE inb_file.inb03
DEFINE p_inb03b   LIKE inb_file.inb03
DEFINE l_ima943   LIKE ima_file.ima943   #屬性組控管
DEFINE l_cnt      LIKE type_file.num5

   SELECT ima943 INTO l_ima943 FROM ima_file
    WHERE ima01 = p_ima01 AND imaacti='Y' AND ima1010='1'  #檢查料件
   IF l_ima943 = '4' OR cl_null(l_ima943) THEN
      RETURN 
   END IF
   
   LET l_cnt = 0

   SELECT COUNT(*) INTO l_cnt FROM inbc_file
    WHERE inbc01 = g_ina.ina01
      AND inbc03 = p_inb03b

   IF l_cnt > 0 THEN
      UPDATE inbc_file SET inbc03 =  p_inb03a
       WHERE inbc01 = g_ina.ina01 AND inbc03 = p_inb03b
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","inbc_file",p_inb03a,"",SQLCA.sqlcode,"","",1)
      END IF
   END IF

END FUNCTION

#MOD-FA0119--add--end--------------------------------------------------------------------

##----- 20200211 add by momo 雜發單轉請購 (S)
FUNCTION t370sub_exp()   #TQC-730022
  DEFINE l_buf    LIKE oay_file.oayslip   
  DEFINE l_pmk RECORD LIKE pmk_file.*     
  DEFINE l_pmk01  LIKE pmk_file.pmk01
  DEFINE l_inb16  LIKE inb_file.inb16  #申請數量
  DEFINE l_avguse  LIKE oeb_file.oeb28
  DEFINE l_inb03  LIKE inb_file.inb03  
  DEFINE l_sql    STRING 
  DEFINE l_cnt    LIKE type_file.num5    
  DEFINE l_cnt1   LIKE type_file.num5   
  DEFINE tm RECORD
         wc       STRING,                 
         inb01    LIKE inb_file.inb01,
         inb03    LIKE inb_file.inb03,
         slip     LIKE oay_file.oayslip  
         END RECORD 
  DEFINE l_slip  LIKE oay_file.oayslip 
  DEFINE l_prog_t STRING
  DEFINE l_ina   RECORD LIKE ina_file.*
  DEFINE l_gfa   RECORD LIKE gfa_file.*
  DEFINE p_row,p_col LIKE type_file.num5
  DEFINE li_cnt   LIKE type_file.num5     
  DEFINE li_success   STRING              
  DEFINE l_chr    STRING              
  DEFINE l_inb04  LIKE inb_file.inb04  
  DEFINE l_inb08  LIKE inb_file.inb08  
  DEFINE l_ima25  LIKE ima_file.ima25  #庫存單位
  DEFINE l_ima44  LIKE ima_file.ima44  #採購單位
  DEFINE l_flag   LIKE type_file.num5  
  DEFINE l_fac    LIKE img_file.img21  
  DEFINE l_t      LIKE type_file.num5  
  DEFINE l_n      LIKE type_file.num5,  
         p_flag   LIKE type_file.chr1 
  DEFINE li_result LIKE type_file.num5  
  DEFINE l_smydmy4 LIKE smy_file.smydmy4 
  DEFINE l_cmd     LIKE type_file.chr1000 
  WHENEVER ERROR CONTINUE                #忽略一切錯誤  #
 
   #重新讀取資料
   SELECT * INTO l_ina.* FROM ina_file
    WHERE ina01=g_ina.ina01
   
   IF cl_null(l_ina.ina01) THEN RETURN END IF
   IF l_ina.ina00 != '1'  THEN RETURN END IF  #需為雜發單方可產生
  #IF l_ina.inaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF     #20200520 mark
   IF l_ina.inaconf != 'Y' THEN CALL cl_err('',9029,1) RETURN END IF    #20200520 modify
   IF NOT cl_null(l_ina.ina10) AND l_ina.ina10<> 'N' THEN               #20220310 modify
      CALL cl_err('','axm-001',1) 
      RETURN END 
   IF #20200520
  
     
      LET p_row = 5 LET p_col = 11
 
      OPEN WINDOW t370sub_exp AT p_row,p_col WITH FORM "axm/42f/axmt400e"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      CALL cl_set_comp_visible("a",FALSE)   
      CALL cl_set_comp_visible("oeb01,oeb03",FALSE) 
      CALL cl_ui_locale("axmt400e")
   
   
      WHILE TRUE           
      CONSTRUCT BY NAME tm.wc ON inb01,inb03    # 螢幕上取單頭條件
   
      BEFORE CONSTRUCT
       
         ON ACTION controlp
   
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
                   CONTINUE CONSTRUCT
   
                ON ACTION about         
                   CALL cl_about()      
         
                ON ACTION help          
                   CALL cl_show_help()  
         
                ON ACTION controlg      
                   CALL cl_cmdask()     
   
             END CONSTRUCT
 

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t370sub_exp
         RETURN
      END IF
     
                 
      LET l_sql ="SELECT inb04,inb08,inb16 ",                                             
                 "  FROM pmk_file,pml_file,inb_file",
                 " WHERE inb01 = pml24",                                        
                 "   AND inb03 = pml25",                                        
                 "   AND pmk01 = pml01",
                 "   AND pmk18 != 'X'",
                 "   AND inb01 = '",g_ina.ina01,"' " 
                 
      PREPARE t370sub_sel_pml FROM l_sql                                        
      EXECUTE t370sub_sel_pml INTO l_inb04,l_inb08,l_inb16                                    
      SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44
        FROM ima_file WHERE ima01=l_inb04

      IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
      CALL s_umfchk(l_inb04,l_ima44,l_inb08) RETURNING l_flag,l_fac                                                                             
      IF cl_null(l_fac) THEN LET l_fac=1 END IF
  
      IF NOT cl_null(l_inb04) THEN
      #   CALL cl_err('','axm-001',1)                                            
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF      

      
      END WHILE   
    
      INPUT BY NAME tm.slip 
                 
         BEFORE INPUT
         
              
         AFTER FIELD slip
            IF NOT cl_null(tm.slip) THEN   
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM smy_file
                WHERE smyslip = tm.slip AND smysys = 'apm' AND smykind = '1' 
               IF SQLCA.sqlcode OR cl_null(tm.slip) THEN  
                  LET l_cnt = 0
               END IF
               IF l_cnt = 0 THEN
                  CALL cl_err(tm.slip,'aap-010',0)       
                  NEXT FIELD slip
               END IF
            END IF
            LET l_slip = tm.slip
   
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW t370sub_exp
            RETURN
         END IF
   
         ON ACTION controlp
            CASE
               WHEN INFIELD(slip)
                    CALL q_smy(FALSE,TRUE,tm.slip,'apm','1') RETURNING tm.slip
                     DISPLAY BY NAME tm.slip        
                    NEXT FIELD slip
               OTHERWISE EXIT CASE
            END CASE
   
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
   
         ON ACTION about         
            CALL cl_about()      
   
         ON ACTION help         
            CALL cl_show_help() 
   
         ON ACTION controlg      
            CALL cl_cmdask()    
   
   
      END INPUT
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t370sub_exp
         RETURN
      END IF
 
   LET g_success = 'Y'  

  
   BEGIN WORK           #MOD-8A0086
  
   SELECT smydmy4 INTO l_smydmy4 FROM smy_file
    WHERE smyslip = tm.slip
   
   # -------------------------未存在請購單號 才可拋轉
   LET l_inb16 = 0
   LET l_avguse = 0
 
   LET l_sql = "SELECT inb03,inb16,0,inb04,inb08 ",  
               "  FROM inb_file ",
               " WHERE inb01 = '",g_ina.ina01,"' ",
               "   AND NOT EXISTS (SELECT * from pml_file,pmk_file  ",
               "                    WHERE pmk01=pml01 AND pmk18 != 'X' AND pml24=inb01 AND pml25= inb03) ",
               "   AND EXISTS (SELECT * FROM ima_file WHERE ima01=inb04  ) ",
               " ORDER BY inb03 "
               
  
   PREPARE t370sub_exp_pre FROM l_sql
   IF SQLCA.sqlcode THEN CALL cl_err('t370sub_exp_pre',STATUS,1) END IF
   DECLARE t370sub_exp_c CURSOR FOR t370sub_exp_pre
   IF SQLCA.sqlcode THEN CALL cl_err('t370sub_exp_c',STATUS,1) END IF
   LET l_cnt = 1
   
   CALL s_auto_assign_no("apm",tm.slip,g_today,"","pmk_file","pmk01","","","")
        RETURNING li_result,l_pmk01
   IF (NOT li_result) THEN
      LET g_success ='N'
      ROLLBACK WORK
      CLOSE WINDOW t370sub_exp
      RETURN
   END IF
    
   DROP TABLE pml_file_temp
   SELECT * FROM pml_file WHERE pml01 = l_pmk01
     INTO TEMP pml_file_temp 

 
   CALL s_showmsg_init()                
   LET l_inb03 = 0    
   FOREACH t370sub_exp_c INTO l_inb03,l_inb16,l_avguse,l_inb04,l_inb08  #項次/數量/預計可用量/產品編號/庫存單位   
   IF g_success = "N" THEN                                                                                                        
      LET g_totsuccess = "N"                                                                                                      
      LET g_success = "Y"                                                                                                         
   END IF                                                                                                                         
     
     SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44
       FROM ima_file WHERE ima01=l_inb04

     IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
     CALL s_umfchk(l_inb04,l_ima44,l_inb08) RETURNING l_flag,l_fac                                                                             
     IF cl_null(l_fac) THEN LET l_fac=1 END IF   

     CALL cs_q102_atp_qty(l_inb04) RETURNING l_avguse
     
     
     #IF l_inb16 - l_avguse <= 0 THEN     #雜發量-預計可用量<0
     IF l_avguse >=0 THEN                 #20200520
         CONTINUE FOREACH
     ELSE
  
         IF l_cnt = 1 THEN            
             CALL t370sub_ins_pmk(l_pmk01)                 
             CALL t370sub_ins_pml_exp(l_pmk01,g_ina.ina01,l_inb03)
         ELSE                     
             CALL t370sub_ins_pml_exp(l_pmk01,g_ina.ina01,l_inb03)
         END IF
         LET l_cnt = l_cnt + 1
     END IF
   END FOREACH
   IF cl_null(l_pmk01) THEN LET g_success="N" END IF    
   
   IF g_totsuccess="N" THEN                                                                                                       
      LET g_success="N"                                                                                                           
   END IF                                                                                                                         
    CALL s_showmsg()        
   IF li_success = 'N' OR g_success = 'N' OR l_cnt <= 1 THEN                              
       ROLLBACK WORK                                                        
       CALL cl_err('','axm-558',1)                                           
       CLOSE WINDOW t370sub_exp                                              
       UPDATE ina_file SET ina10 = 'N' WHERE ina01 = g_ina.ina01             #20220310
       DISPLAY 'N' TO ina10                                                  #20220310
   ELSE                                                                                                                                            
  
   IF g_success = 'Y' THEN
   
       COMMIT WORK
       LET l_prog_t = g_prog
       LET g_prog = 'apmt420'
       CALL cl_flow_notify(l_pmk01,'I')
       LET g_prog = l_prog_t
       #MESSAGE "已轉請購單號:",l_pmk01        

       IF NOT cl_null(l_pmk01) THEN
          IF cl_confirm('TSD0012') THEN
             LET l_cmd = "apmt420 ","'",l_pmk01,"'"   #20181212 add by momo  直接開啟請購單
             CALL cl_cmdrun(l_cmd)                   
          END IF
       END IF

   ELSE
       ROLLBACK WORK
       
   END IF
   CLOSE WINDOW t370sub_exp
  END IF                                                                                            
END FUNCTION

FUNCTION t370sub_ins_pmk(p_pmk01)                            
 DEFINE l_pmk    RECORD LIKE pmk_file.*
 DEFINE l_slip   LIKE type_file.chr5                               
 DEFINE p_pmk01 LIKE pmk_file.pmk01  
 
   INITIALIZE l_pmk.* TO NULL
 
   LET l_pmk.pmk01 = p_pmk01      
   CALL s_get_doc_no(p_pmk01) RETURNING l_slip 
   LET l_pmk.pmk02 = 'REG'       #單號性質
   LET l_pmk.pmk03 = '0'
   LET l_pmk.pmk04 = g_today     #請購日期
   LET l_pmk.pmk12 = g_user
   LET l_pmk.pmk13 = g_grup
   LET l_pmk.pmk18 = 'N'
   LET l_pmk.pmk25 = '0'         #開立
   LET l_pmk.pmk27 = g_today
   LET l_pmk.pmk40 = 0           #總金額
   LET l_pmk.pmk401= 0           #總金額
   LET l_pmk.pmk42 = 1           #匯率
   LET l_pmk.pmk43 = 0           #稅率
   ##smyud02=N 判斷預設MRP為不勾取
   IF g_smy.smyud02='N' THEN 
      LET l_pmk.pmk45='N' 
   ELSE
      LET l_pmk.pmk45 = 'Y'         #可用
   END IF
   ##---- 20190515 add by momo (E)
   LET l_pmk.pmk50 = g_plant     #生产门店
   SELECT smyapr,smysign INTO l_pmk.pmkmksg,l_pmk.pmksign   
     FROM smy_file
    WHERE smyslip = l_slip
   IF SQLCA.sqlcode OR cl_null(l_pmk.pmkmksg) THEN
      LET l_pmk.pmkmksg = 'N'
      LET l_pmk.pmksign= NULL
   END IF
   LET l_pmk.pmkdays = 0         #簽核天數
   LET l_pmk.pmksseq = 0         #應簽順序
   LET l_pmk.pmkprno = 0         #列印次數
 
   LET l_pmk.pmkacti ='Y'        #有效的資料
   LET l_pmk.pmkuser = g_user    #使用者
   LET l_pmk.pmkgrup = g_grup    #使用者所屬群
   LET l_pmk.pmkdate = g_today   
   LET l_pmk.pmk46='5'       
   LET l_pmk.pmk47=''
   LET l_pmk.pmkcond= ''             #審核日期
   LET l_pmk.pmkconu= ''             #審核時間
   LET l_pmk.pmkcrat= g_today        #資料創建日
   LET l_pmk.pmkplant = g_plant        #機構別
   LET l_pmk.pmklegal = g_legal        
   LET l_pmk.pmkoriu = g_user     
   LET l_pmk.pmkorig = g_grup   
   LET l_pmk.pmkud03 = 'N'
   LET l_pmk.pmksmax = 0
   LET l_pmk.pmksseq = 0
   
   INSERT INTO pmk_file VALUES(l_pmk.*)     #DISK WRITE
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg("pmk01",l_pmk.pmk01,"ins pmk",SQLCA.sqlcode,1)      
      LET g_success = 'N'
   END IF           
  
END FUNCTION        

FUNCTION t370sub_ins_pml_exp(l_pmk01,p_ina01,p_inb03)
 DEFINE l_pmk01  LIKE pmk_file.pmk01   
 DEFINE l_inb03  LIKE inb_file.inb03  
 DEFINE l_qty    LIKE inb_file.inb16
 DEFINE l_inb01  LIKE inb_file.inb01  
 DEFINE l_inb    RECORD LIKE inb_file.*
 DEFINE p_ina01  LIKE ina_file.ina01
 DEFINE p_inb03  LIKE inb_file.inb03 
 
      DECLARE t370sub_inb_curs1 CURSOR FOR
       SELECT * FROM inb_file
        WHERE inb01 = p_ina01
          AND inb03 = p_inb03     
          
      FOREACH t370sub_inb_curs1 INTO l_inb.*
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','',"foreach:",SQLCA.sqlcode,1)  
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET g_inb03 = g_inb03+1   
          CALL t370sub_ins_pml(l_pmk01,l_inb.inb01,l_inb.inb03) 
      END FOREACH
 
END FUNCTION

FUNCTION t370sub_ins_pml(p_pmk01,p_inb01,p_inb03)           
  DEFINE p_pmk01     LIKE pmk_file.pmk01,
         p_inb01     LIKE inb_file.inb01,    
         p_inb03     LIKE inb_file.inb03,
         l_ima01     LIKE ima_file.ima01,
         l_ima02     LIKE ima_file.ima02,
         l_ima05     LIKE ima_file.ima05,
         l_ima25     LIKE ima_file.ima25,
         l_ima27     LIKE ima_file.ima27,
         l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk    LIKE type_file.num15_3, #FUN-A20044
         l_ima44     LIKE ima_file.ima44,
         l_ima44_fac LIKE ima_file.ima44_fac,
         l_ima45     LIKE ima_file.ima45,
         l_ima46     LIKE ima_file.ima46,
         l_ima49     LIKE ima_file.ima49,
         l_ima491    LIKE ima_file.ima491,
         l_ima913    LIKE ima_file.ima913,   
         l_ima914    LIKE ima_file.ima914,   
         l_pan       LIKE type_file.num10,   
         l_flag      LIKE type_file.chr1,    
         l_double    LIKE type_file.num10    
   DEFINE l_pml      RECORD LIKE pml_file.*  
   DEFINE l_inb      RECORD LIKE inb_file.*  
   DEFINE l_factor   LIKE img_file.img21     #
   DEFINE l_cnt      LIKE type_file.num5     
   DEFINE l_ima39    LIKE ima_file.ima39    
   DEFINE l_ima391   LIKE ima_file.ima391   
   DEFINE l_pmj01    LIKE pmj_file.pmj01     
   DEFINE l_azk052   LIKE azk_file.azk052    # 匯率

   CALL t370sub_pml_ini(p_pmk01) RETURNING l_pml.* 
   
   SELECT * INTO l_inb.* FROM inb_file WHERE inb01=p_inb01 AND inb03=p_inb03
 
   LET l_ima913 = 'N'  
 
       SELECT ima01,ima02,ima05,ima25,0,ima27,ima44,ima44_fac, 
              ima45,ima46,ima49,ima491,
              ima913,ima914,       
              ima39,ima391         
         INTO l_ima01,l_ima02,l_ima05,l_ima25,l_avl_stk,l_ima27,
              l_ima44,l_ima44_fac,l_ima45,l_ima46,l_ima49,l_ima491,
              l_ima913,l_ima914,      
              l_ima39,l_ima391       
         FROM ima_file
        WHERE ima01 = l_inb.inb04
       CALL s_getstock(l_inb.inb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk 
       IF SQLCA.sqlcode THEN
           CALL s_errmsg("ima01",l_inb.inb04,"sel ima:",SQLCA.sqlcode,1)     
           LET g_success = 'N'
           RETURN
       END IF
       LET l_pml.pml40  = l_ima39     
       LET l_pml.pml401 = l_ima391    
       LET l_pml.pml02 = g_inb03 
       LET l_pml.pml04 = l_ima01
       LET l_pml.pml041= l_ima02
       LET l_pml.pml05 = NULL      
       LET l_pml.pml07 = l_ima44      
       LET l_pml.pml08 = l_ima25
       LET l_pml.pml12 = l_inb.inb41
       LET l_pml.pml121= l_inb.inb42
       CALL s_umfchk(l_pml.pml04,l_pml.pml07,                                                                                     
            l_pml.pml08) RETURNING l_flag,l_pml.pml09                                                                             
            IF cl_null(l_pml.pml09) THEN LET l_pml.pml09=1 END IF
      #先將雜發數量轉換成請購單位數量                                                                                               
       LET l_inb.inb16 = l_inb.inb16 * l_inb.inb08_fac / l_pml.pml09       
       LET l_pml.pml42 = '0'
    IF g_sma.sma115='N' THEN      
       #-->考慮最少採購量/倍量
       IF l_inb.inb16 > 0 THEN  #FUN-730018                                                                 
          CALL s_sizechk(l_pml.pml04,l_inb.inb16,g_lang,l_pml.pml07) 
                         RETURNING l_pml.pml20         
       ELSE
          LET l_pml.pml20 = 0
       END IF
    ELSE      
       LET l_pml.pml20 = l_inb.inb16      
    END IF     
       LET l_pml.pml35 = g_today                 #到庫日期
       CALL s_aday(l_pml.pml35,-1,l_ima491) RETURNING l_pml.pml34 
       CALL s_aday(l_pml.pml34,-1,l_ima49) RETURNING l_pml.pml33  
  
   LET l_pml.pml86 = l_inb.inb1004
   LET g_pml.* = l_pml.*      
   CALL t370_set_pml87()      
   LET l_pml.pml87=g_pml.pml87        
   LET l_pml.pml190 = l_ima913    #統購否
   LET l_pml.pml191 = l_ima914    #採購成本中心
   LET l_pml.pml192 = 'N'         #拋轉否 
   LET l_pml.pml24 = p_inb01
   LET l_pml.pml25 = p_inb03
   LET l_pml.pml47=''
   LET l_pml.pml48=''
   LET l_pml.pml49='1'
   LET l_pml.pml50='1'
   LET l_pml.pml51=''
   LET l_pml.pml52=''
   LET l_pml.pml53=''
   LET l_pml.pml54=' '
      

  #給初始值
   IF cl_null(l_pml.pml88) THEN
      LET l_pml.pml88 = 0
   END IF
   IF cl_null(l_pml.pml88t) THEN
      LET l_pml.pml88t = 0
   END IF
   IF cl_null(l_pml.pml49) THEN
      LET l_pml.pml49 = ' '
   END IF
   IF cl_null(l_pml.pml50) THEN
      LET l_pml.pml50 = '1'
   END IF
     

  #帶入主要供應商與採購員   
   SELECT ima54,ima43 INTO l_pml.ta_pml03,l_pml.ta_pml06
     FROM ima_file
    WHERE ima01= l_pml.pml04                                                                     


##----  帶入單價等資訊
   CALL cs_get_quote_price(l_pml.ta_pml03, l_pml.pml04, '1', l_pml.pml20, g_plant)
         RETURNING l_pml.ta_pml04,l_pml.ta_pml05,l_pml.pml31,l_pml.pml31t,l_pmj01

   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
       WHERE azi01 = l_pml.ta_pml05  AND aziacti= 'Y'       #原幣

   LET l_pml.pml88 =cl_digcut(l_pml.pml87*l_pml.pml31,t_azi04)
   LET l_pml.pml88t=cl_digcut(l_pml.pml87*l_pml.pml31t,t_azi04)
   
   SELECT azk052 INTO l_azk052 FROM azk_file
    WHERE azk01=g_pml2.ta_pml05 AND azk02=g_today
   IF cl_null(l_azk052) THEN LET l_azk052=1 END IF
   LET l_pml.pmlud07 =cl_digcut(l_pml.pml88*l_azk052,t_azi04)
   IF cl_null(l_pml.pmlud07) THEN LET l_pml.pmlud07=0 END IF
##----  (E)
                                                                         
   LET l_pml.pml56 = '1'  #bnl
   LET l_pml.pml91 = 'N'  #FUN-980010 add 給初始值  #Mod TQC-B30096
   LET l_pml.pml92 = 'N' #FUN-9B0023
   LET l_pml.pml91 = 'N'
  
   INSERT INTO pml_file VALUES(l_pml.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg("pml01",l_pml.pml01,"INS pml_file",SQLCA.sqlcode,1)          
      LET g_success = 'N'
   ELSE                                                                     #20200305
      UPDATE ina_file SET ina10 = l_pml.pml01 WHERE ina01 = g_ina.ina01         #20200305
   END IF
    
END FUNCTION

FUNCTION t370sub_pml_ini(p_pmk01)
  DEFINE p_pmk01 LIKE pmk_file.pmk01,
         l_pmk02 LIKE pmk_file.pmk02,
         l_pmk25 LIKE pmk_file.pmk25,
         l_pmk13 LIKE pmk_file.pmk13
  DEFINE l_pml   RECORD LIKE pml_file.*
 
   INITIALIZE l_pml.* TO NULL     
   SELECT pmk02,pmk25,pmk13 INTO l_pmk02,l_pmk25,l_pmk13
     FROM pmk_file WHERE pmk01 = p_pmk01
   LET l_pml.pml01 = p_pmk01               LET l_pml.pml011 = l_pmk02
   LET l_pml.pml16 = l_pmk25
   LET l_pml.pml14 = g_sma.sma886[1,1]     LET l_pml.pml15  =g_sma.sma886[2,2]
   LET l_pml.pml23 = 'Y'  
   IF g_smy.smyud02='N' THEN LET l_pml.pml38='N' ELSE                 
      LET l_pml.pml38  ='Y'
   END IF
   LET l_pml.pml43 = 0                     LET l_pml.pml431 = 0
   LET l_pml.pml11 = 'N'                   LET l_pml.pml13  = 0
   LET l_pml.pml21  = 0
   LET l_pml.pml30 = 0                     LET l_pml.pml32 = 0
   LET l_pml.pml930=s_costcenter(l_pmk13) 
   LET l_pml.pmlplant=g_plant  
   LET l_pml.pmllegal=g_legal  
   RETURN l_pml.*
END FUNCTION

FUNCTION t370_set_pml87()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            g_cnt    LIKE type_file.num5,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE type_file.num20_6
 
    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
      FROM ima_file WHERE ima01=g_pml.pml04

    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
 
    LET l_fac2=g_pml.pml84
    LET l_qty2=g_pml.pml85
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=g_pml.pml81
       LET l_qty1=g_pml.pml82
    ELSE
       LET l_fac1=1
       LET l_qty1=g_pml.pml20
       CALL s_umfchk(g_pml.pml04,g_pml.pml07,l_ima44)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    CALL s_umfchk(g_pml.pml04,l_ima44,g_pml.pml86)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
    LET g_pml.pml87 = l_tot
    LET g_pml.pml87 = s_digqty(g_pml.pml87,g_pml.pml86)   #No.FUN-BB0086
END FUNCTION
 
##----- 20200211 add by momo 雜發單轉請購 (E)

##----- 20220316 add by momo (S) 修改需求日期
FUNCTION t370_modify_inaud13()

IF g_action_choice = "modify_inaud13" THEN
   INPUT g_ina.inaud13 WITHOUT DEFAULTS FROM inaud13

    AFTER FIELD inaud13
        IF cl_null(g_ina.inaud13) THEN
            NEXT FIELD inaud13
        ELSE
            IF g_ina.inaud13 < g_today THEN
                NEXT FIELD inaud13
            END IF
        END IF
        
    AFTER INPUT
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            RETURN
        END IF
        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
                    
    END INPUT

    UPDATE ina_file SET inaud13=g_ina.inaud13 
         WHERE ina01 = g_ina.ina01
         
    DISPLAY BY NAME g_ina.inaud13
END IF


END FUNCTION
##----- 20220316 add by momo (E)
