# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: asft720.4gl
# Descriptions...: 品質異常處理記錄維護作業
# Date & Author..: 99/06/25 by patricia
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No:8543,9677 03/10/30 Melody shh142 為日期欄位卻給' ',應是''
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.MOD-530461 05/05/03 By pengu 1.加列印功能，直接與 asfr720串接列印。
                                        #   2.若有後續流程資料輸入，則不可取消確認
# Modify.........: No.TQC-630013 06/03/03 By Claire 串報表傳參數
# Modify.........: No.TQC-630068 06/03/07 By Sarah 指定單據編號、執行功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660067 06/06/14 By Sarah p_flow功能補強
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0164 06/11/13 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740145 07/04/20 By hongmei 錄入時，登錄單別輸入任何值沒管控
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/21 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A50107 10/05/28 By houlia 在符合條件的情況下，留置碼欄位開窗
# Modify.........: No.FUN-A60076 10/06/25 By huangtao 製造功能優化-平行制程（批量修改）
# Modify.........: No.TQC-AB0280 10/11/29 By jan shh012給預設值
# Modify.........: No.TQC-AC0289 10/12/18 By vealxu 1.新增input時順序錯誤，客戶編號enter後跑到留置碼
#                                                   2.單頭 layout不整齊，作業編號上面空一大片
#                                                   3.製程段號沒有隱藏 (sma541='N')
#                                                   4.製程段號按開窗出現：作業錯誤,請通報 MIS!
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR 
# Modify.........: No.FUN-C30163 12/12/26 By pauline CALL q_ecm(時增加參數
# Modify.........: No:CHI-D20010 13/02/21 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D20059 13/03/26 By chenjing 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No:MOD-D70063 13/07/10 By Alberti 修改 Control+G 沒有跳出快速執行
# Modify.........: No:FUN-D40032 13/07/11 By lujh 取消作廢需控卡關帳日期
# Modify.........: No:FUN-DA0126 13/10/31 By bart 增批增加共用變數g_data_keyvalue
# Modify.........: No.TQC-E80015 14/08/27 By Sabrina GR還原CR
# Modify.........: No:FUN-F50015 15/06/04 By Mio 解決【新增】、【複製】之後無法紀錄key值問題
# Modify.........:               20180525 By momo shh08欄位更改記錄「責任歸屬」;shhud07異常數量 shhud08異常處理成本                               
# Modify.........:               20180608 By momo 增加計算處理品質異常成本計算
# Modify.........:               20180709 By momo 增加資料清單
# Modify.........:               20180712 By momo 資料清單增加處理部門筆數
# Modify.........: 20190107 By momo 資料清單增加顯示 shhud08,shh022

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE
    g_shh   RECORD LIKE shh_file.*,
    g_shh_t RECORD LIKE shh_file.*,
    g_shh01_t LIKE shh_file.shh01,
    g_flag   LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_h1,g_m1,g_s1 LIKE type_file.num5,    #No.FUN-680121 SMALLINT
    g_wc,g_sql          string      #No.FUN-580092 HCN
DEFINE g_argv1          LIKE oea_file.oea01,         #No.FUN-680121 VARCHAR(16)#TQC-630068
       g_argv2          STRING      #TQC-630068
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE   g_confirm      LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_approve      LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_post         LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_close        LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_void         LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_valid        LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
##---- 20180601 (S)
DEFINE g_qcp           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                    qcp02   LIKE qcp_file.qcp02,
                    qcp06   LIKE qcp_file.qcp06,
                    qce03   LIKE qce_file.qce03,
                    qcp03   LIKE qcp_file.qcp03,
                    qcp04   LIKE qcp_file.qcp04, 
                    qcp05   LIKE qcp_file.qcp05,
                    #FUN-840068 --start---
                    qcpud01 LIKE qcp_file.qcpud01,
                    qcpud02 LIKE qcp_file.qcpud02,
                    qcpud03 LIKE qcp_file.qcpud03,
                    qcpud04 LIKE qcp_file.qcpud04,
                    qcpud05 LIKE qcp_file.qcpud05,
                    qcpud06 LIKE qcp_file.qcpud06,
                    qcpud07 LIKE qcp_file.qcpud07,
                    qcpud08 LIKE qcp_file.qcpud08,
                    qcpud09 LIKE qcp_file.qcpud09,
                    qcpud10 LIKE qcp_file.qcpud10,
                    qcpud11 LIKE qcp_file.qcpud11,
                    qcpud12 LIKE qcp_file.qcpud12,
                    qcpud13 LIKE qcp_file.qcpud13,
                    qcpud14 LIKE qcp_file.qcpud14,
                    qcpud15 LIKE qcp_file.qcpud15
                    #FUN-840068 --end--
                    END RECORD,
    g_qcp_t         RECORD                    #程式變數 (舊值)
                    qcp02   LIKE qcp_file.qcp02,
                    qcp06   LIKE qcp_file.qcp06,
                    qce03   LIKE qce_file.qce03,
                    qcp03   LIKE qcp_file.qcp03,
                    qcp04   LIKE qcp_file.qcp04, 
                    qcp05   LIKE qcp_file.qcp05,
                    #FUN-840068 --start---
                    qcpud01 LIKE qcp_file.qcpud01,
                    qcpud02 LIKE qcp_file.qcpud02,
                    qcpud03 LIKE qcp_file.qcpud03,
                    qcpud04 LIKE qcp_file.qcpud04,
                    qcpud05 LIKE qcp_file.qcpud05,
                    qcpud06 LIKE qcp_file.qcpud06,
                    qcpud07 LIKE qcp_file.qcpud07,
                    qcpud08 LIKE qcp_file.qcpud08,
                    qcpud09 LIKE qcp_file.qcpud09,
                    qcpud10 LIKE qcp_file.qcpud10,
                    qcpud11 LIKE qcp_file.qcpud11,
                    qcpud12 LIKE qcp_file.qcpud12,
                    qcpud13 LIKE qcp_file.qcpud13,
                    qcpud14 LIKE qcp_file.qcpud14,
                    qcpud15 LIKE qcp_file.qcpud15
                    #FUN-840068 --end--
                    END RECORD,
   g_wc2           STRING, 
   g_rec_b         LIKE type_file.num5,     #單身筆數       
   l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT  
##---- 20180601 (E)

#20180709---add---str---
DEFINE g_shh_l       DYNAMIC ARRAY OF RECORD
                  shh02    LIKE shh_file.shh02,
                  shh01    LIKE shh_file.shh01,
                  ta_sfb01 LIKE sfb_file.ta_sfb01,
                  oea032   LIKE oea_file.oea032,
                  ima021   LIKE ima_file.ima021,
                  oeb15    LIKE oeb_file.oeb15,
                  shhud02  LIKE shh_file.shhud02,
                  ima02    LIKE ima_file.ima02,
                  shh112   LIKE shh_file.shh112,
                  shhud07  LIKE shh_file.shhud07,
                  shh022   LIKE shh_file.shh022,     #20190107
                  shhud08  LIKE shh_file.shhud08,    #20190107
                  shh14    LIKE shh_file.shh14,
                  shh06    LIKE shh_file.shh06       #20180712
                     END RECORD,
       l_ac4      LIKE type_file.num5,
       g_rec_b4   LIKE type_file.num5,
       g_action_flag     STRING
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
#20180709---add---end---

MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680121 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0090
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   #start TQC-630068
    LET g_argv1=ARG_VAL(1)   #分割單號
    LET g_argv2=ARG_VAL(2)   #執行功能
   #start TQC-630068
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
   #start TQC-630068
   #LET p_row = ARG_VAL(1)
   #LET p_col = ARG_VAL(2)
    LET p_row = 4 LET p_col = 20
   #end TQC-630068
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
    INITIALIZE g_shh.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM shh_file WHERE shh01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t720_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t720_w AT p_row,p_col
         WITH FORM "csf/42f/asft720"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
  # CALL cl_set_comp_visible("ssh012",g_sma.sma541 = 'Y')             #FUN-A60076 add by huangtao   #TQC-AC0289 mark
    CALL cl_set_comp_visible("shh012",g_sma.sma541 = 'Y')             #TQC-AC0289
 
   #start TQC-630068
    # 先以g_argv2判斷直接執行哪種功能：
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t720_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t720_a()
                LET g_data_keyvalue = g_shh.shh01        #FUN-F50015 add
             END IF
          OTHERWISE          #TQC-660067 add
             CALL t720_q()   #TQC-660067 add
       END CASE
    END IF
   #end TQC-630068
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL t720_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t720_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN
 
FUNCTION t720_curs()
# DEFINE   l_slip          VARCHAR(3)
  DEFINE   l_slip          LIKE aab_file.aab02        #No.FUN-680121 VARCHAR(5)#No.FUN-550067
  DEFINE   lc_qbe_sn       LIKE    gbm_file.gbm01
    CLEAR FORM
 
 #start TQC-630068
  IF NOT cl_null(g_argv1) THEN
     LET g_wc = " shh01 = '",g_argv1,"'"
  ELSE
 #end TQC-630068
   INITIALIZE g_shh.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        shh01,shh02,shh021,shh022,shh08,shh04,shh03,shh012,shh05,shh06,               #FUN-A60076 add shh012
        shh07,shh061,shh14,
        shh111,shh112,shh113,shh101,shh10,shh131,shh132,shh121,shh12,shh151,shh152,
        shh141,shh142,shh143,shh161,shh162,shh163,shh164,shh165,
                             shh171,shh172,shh173,shh174,shh175,
        shhuser,shhgrup,shhmodu,shhdate,
              #No.FUN-580031 --start--     HCN
        #FUN-840068   ---start---
        shhud01,shhud02,shhud03,shhud04,shhud05,
        shhud06,shhud07,shhud08,shhud09,shhud10,
        shhud11,shhud12,shhud13,shhud14,shhud15
        #FUN-840068    ----end----
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp                        # 沿用所有欄位
           CASE
              WHEN INFIELD(shh01)
#                LET l_slip = g_shh.shh01[1,3]
                  LET l_slip = s_get_doc_no(g_shh.shh01)     #No.FUN-550067
                #CALL q_smy(TRUE,FALSE,l_slip,'asf','E') RETURNING g_qryparam.multiret   #TQC-670008
                 CALL q_smy(TRUE,FALSE,l_slip,'ASF','E') RETURNING g_qryparam.multiret   #TQC-670008
#                LET g_shh.shh01[1,3] = l_slip
                 LET g_shh.shh01 = l_slip    #No.FUN-550067
                 DISPLAY g_qryparam.multiret TO shh01
                 NEXT FIELD shh01
              WHEN INFIELD(shh03)
                 #CALL q_sfb(0,0,g_shh.shh03,'2345678') RETURNING g_shh.shh03
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form     = "q_sfb"
                 LET g_qryparam.default1 = g_shh.shh03
                 LET g_qryparam.arg1     = "2345678"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shh03
                 NEXT FIELD shh03
              ##---- 20180605 工單備料檔 (S)
              WHEN INFIELD(shhud02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form     = "q_ima"
                 LET g_qryparam.default1 = g_shh.shhud02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shhud02
                 NEXT FIELD shhud02
              ##---- 20180605 工單備料檔 (E)
              WHEN INFIELD(shh04)
                 #CALL q_occ(0,0,g_shh.shh04) RETURNING g_shh.shh04
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form     = "q_occ"
                 LET g_qryparam.default1 = g_shh.shh04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shh04
                 NEXT FIELD shh04
           #FUN-A60076 ------start----------------------      
              WHEN INFIELD(shh012)
                  CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form     = "q_shh012"
                 LET g_qryparam.default1 = g_shh.shh012
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shh012
                 NEXT FIELD shh012
           #FUN-A60076 --------end------------------------      
              WHEN INFIELD(shh05)
                #CALL q_ecm(TRUE,TRUE,'','')   #FUN-C30163 mark
                 CALL q_ecm(TRUE,TRUE,'','','','','','')  #FUN-C30163 add
                      RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shh05
                 NEXT FIELD shh05
           ##----- 20180525 add 異常原因開窗 (S)
              WHEN INFIELD(shh111)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "cq_qce01"
                LET g_qryparam.default1 = g_shh.shh111
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO shh111
                NEXT FIELD shh111
           ##----- 20180525 add 異常原因開窗 (E)
           ##----- 20180604 add 異常原因開窗 (S)
              WHEN INFIELD(shh131)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "cq_qce01"
                LET g_qryparam.default1 = g_shh.shh131
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO shh131
                NEXT FIELD shh131
              WHEN INFIELD(shh151)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "cq_qce01"
                LET g_qryparam.default1 = g_shh.shh151
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO shh151
                NEXT FIELD shh151
           ##----- 20180604 add 異常原因開窗 (E)
              WHEN INFIELD(shh101)
                 #CALL q_gen(10,3,g_shh.shh101) RETURNING g_shh.shh101
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form     = "cq_gen10"
                 LET g_qryparam.default1 = g_shh.shh101
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shh101
                 NEXT FIELD shh101
              WHEN INFIELD(shh10)
                 #CALL q_gem(0,0,g_shh.shh10) RETURNING g_shh.shh10
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form     = "q_gem"
                 LET g_qryparam.default1 = g_shh.shh10
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shh10
                 NEXT FIELD shh10
              WHEN INFIELD(shh121)
                 #CALL q_gen(10,3,g_shh.shh121) RETURNING g_shh.shh121
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form     = "q_gen"
                 LET g_qryparam.default1 = g_shh.shh121
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shh121
                 NEXT FIELD shh121
              WHEN INFIELD(shh12)
                 #CALL q_gem(0,0,g_shh.shh12) RETURNING g_shh.shh12
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 ##---- 20180525 modify by momo (S) 開部門或廠商
                 #LET g_qryparam.form     = "q_gem"
                 IF g_shh.shh08 <> '2' THEN
                    LET g_qryparam.form     = "q_gem"
                 ELSE
                    LET g_qryparam.form     = "q_pmc"
                 END IF
                 ##---- 20180525 modify by momo (E)
                 LET g_qryparam.default1 = g_shh.shh12
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shh12
                 NEXT FIELD shh12
              WHEN INFIELD(shh022)
                 #CALL q_gem(0,0,g_shh.shh12) RETURNING g_shh.shh12
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 ##---- 20180525 modify by momo (S) 開部門或廠商
                 #LET g_qryparam.form     = "q_gem"
                 IF g_shh.shh08='1' THEN
                    LET g_qryparam.form     = "q_gem"
                 ELSE
                    LET g_qryparam.form     = "q_pmc"
                 END IF
                 ##---- 20180525 modify by momo (E)
                 LET g_qryparam.default1 = g_shh.shh022
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shh022
                 NEXT FIELD shh022
              OTHERWISE
                  EXIT CASE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
  END IF   #TQC-630068
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND shhuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND shhgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND shhgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('shhuser', 'shhgrup')
    #End:FUN-980030

    ##---- 20180601 (S)
    IF g_argv1 IS NULL OR g_argv1 = ' '  OR
       g_argv2 IS NULL OR g_argv2 = ' '
    THEN
    CONSTRUCT g_wc2 ON qcp02,qcp06,qcp04,qcp05          # 螢幕上取單身條件
                      #No.FUN-840068 --start--
                      ,qcpud01,qcpud02,qcpud03,qcpud04,qcpud05
                      ,qcpud06,qcpud07,qcpud08,qcpud09,qcpud10
                      ,qcpud11,qcpud12,qcpud13,qcpud14,qcpud15
                      #No.FUN-840068 ---end---
         FROM s_qcp[1].qcp02,s_qcp[1].qcp06,s_qcp[1].qcp04,s_qcp[1].qcp05
              #No.FUN-840068 --start--
              ,s_qcp[1].qcpud01,s_qcp[1].qcpud02,s_qcp[1].qcpud03
              ,s_qcp[1].qcpud04,s_qcp[1].qcpud05,s_qcp[1].qcpud06
              ,s_qcp[1].qcpud07,s_qcp[1].qcpud08,s_qcp[1].qcpud09
              ,s_qcp[1].qcpud10,s_qcp[1].qcpud11,s_qcp[1].qcpud12
              ,s_qcp[1].qcpud13,s_qcp[1].qcpud14,s_qcp[1].qcpud15
              #No.FUN-840068 ---end---
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
	#No.FUN-580031 --start--     HCN
            ON ACTION qbe_save
	       CALL cl_qbe_save()
	#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN  RETURN END IF
       ELSE LET g_wc2 = " 1=1"
   END IF
 
    ##---- 20180601 (E)
   
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件 #20180601 add 
       LET g_sql="SELECT shh01 FROM shh_file ", # 組合出 SQL 指令
         " WHERE  ",g_wc CLIPPED," ORDER BY shh01"
    ELSE
       LET g_sql = "SELECT UNIQUE  shh01 ",
                  "  FROM shh_file, qcp_file ",
                  " WHERE shh01 = qcp01 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY shh01"
    END IF
    PREPARE t720_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t720_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t720_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM shh_file WHERE (shh031 IS NULL OR shh031=' ') AND ",g_wc CLIPPED
    PREPARE t720_precount FROM g_sql
    DECLARE t720_count CURSOR FOR t720_precount
    
    ##0180601 mark end
END FUNCTION
 
FUNCTION t720_menu()
    #MENU ""
 
       # BEFORE MENU
       #     CALL cl_navigator_setting( g_curs_index, g_row_count )
    WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #20180709 add
         CALL t720_bp("G")
      ELSE                           
         CALL t720_list_fill()
         CALL t720_bp3("G")           
         IF NOT cl_null(g_action_choice) AND l_ac4>0 THEN #將清單的資料回傳到主畫面
            SELECT shh_file.* INTO g_shh.*
              FROM shh_file
             WHERE shh01=g_shh_l[l_ac4].shh01
         END IF
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac4 = ARR_CURR()
            LET g_jump = l_ac4
            LET mi_no_ask = TRUE
            IF g_rec_b4 >0 THEN
               CALL t720_fetch('/')
            END IF
            CALL cl_set_comp_visible("page_list", FALSE)
            CALL cl_set_comp_visible("info", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page_list", TRUE)
            CALL cl_set_comp_visible("info", TRUE)
          END IF               
      END IF  
      #20180709--add---end--

      CASE g_action_choice
 
       #ON ACTION insert
        WHEN "insert"
           #LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t720_a()
                 LET g_data_keyvalue = g_shh.shh01        #FUN-F50015 add
            END IF

        #ON ACTION query
        WHEN "query"
           #LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t720_q()
            END IF
        #ON ACTION next
        WHEN "next"
            CALL t720_fetch('N')
        #ON ACTION previous
        WHEN "previous"
            CALL t720_fetch('P')
        WHEN "modify"
        #ON ACTION modify
           # LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t720_u()
            END IF
        ##---- 20180601 (S)
        WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_shh.shh132) AND NOT cl_null(g_shh.shh121) THEN
                  CALL t720_b()
               ELSE
                  CALL cl_err('','cqc-002',1)  #20180615
                  LET g_action_choice = NULL
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF 
        ##---- 20180601 (E)
        #ON ACTION delete
        WHEN "delete"
           #LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t720_r()
            END IF
 
          # --------------No.MOD-530461---------------------------
         #ON ACTION output
         WHEN "ouput"
           # LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
            LET g_msg=' shh01= "',g_shh.shh01,'"'  #TQC-630013
                LET g_msg="asfr720 ",  #FUN-C30085 mark    #TQC-E80015 mark  
               #LET g_msg="asfg720 ",  #FUN-C30085 add     #TQC-E80015 add 
                         "'",g_today,"'",
                        #TQC-630013-begin
                        #" '",g_user,"'",  
                        #TQC-630013-end
                         " ''",
                         " '",g_lang,"'",
                        #TQC-630013-begin
                        #" 'N' ",
                         " 'Y' ",
                        #TQC-630013-end
                         " ' ' ",
                         " '1'",
                        #TQC-630013-begin
                        #" 'N' ",
                        #"'",g_shh.shh01,"'"
                         " '",g_msg,"'"
                        #TQC-630013-end
               CALL cl_cmdrun(g_msg)
            END IF
          #-----------------------No.MOD-530461-----------------------
 
        #ON ACTION confirm
         WHEN "confirm"
           #LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL t720_y()
            END IF
            CASE g_shh.shh14
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
       #ON ACTION undo_confirm
        WHEN "undo_confirm"
           # LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t720_z()
            END IF
            CASE g_shh.shh14
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
{
        ON ACTION maintain_solution
            LET g_action_choice="maintain_solution"
            IF cl_chk_act_auth() THEN
               CALL t720_1()
            END IF
}
      #20180614 add
      WHEN "finish"
            IF cl_chk_act_auth() THEN
               CALL t720_close()
            END IF
            CASE g_shh.shh14
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'C'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
            
      #ON ACTION void
      WHEN "void"
         #LET g_action_choice="void"
         IF cl_chk_act_auth() THEN
           #CALL t720_x()    #CHI-D20010
            CALL t720_x(1)   #CHI-D20010
         END IF
         CASE g_shh.shh14
              WHEN 'Y'   LET g_confirm = 'Y'
                         LET g_void = ''
              WHEN 'N'   LET g_confirm = 'N'
                         LET g_void = ''
              WHEN 'X'   LET g_confirm = ''
                         LET g_void = 'Y'
           OTHERWISE     LET g_confirm = ''
                         LET g_void = ''
         END CASE
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
      #CHI-D20010---begin
      #ON ACTION undo_void
       WHEN "undo_void"
        #LET g_action_choice="undo_void"
         IF cl_chk_act_auth() THEN
           #CALL t720_x()    #CHI-D20010
            CALL t720_x(2)   #CHI-D20010
         END IF
         CASE g_shh.shh14
              WHEN 'Y'   LET g_confirm = 'Y'
                         LET g_void = ''
              WHEN 'N'   LET g_confirm = 'N'
                         LET g_void = ''
              WHEN 'X'   LET g_confirm = ''
                         LET g_void = 'Y'
           OTHERWISE     LET g_confirm = ''
                         LET g_void = ''
         END CASE
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
       #CHI-D20010---end

        WHEN "exporttoexcel"     #FUN-4B0025
            LET w = ui.Window.getCurrent()   #FUN-CB0014 add
            LET f = w.getForm()              #FUN-CB0014 add
            IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page_main")  #FUN-CB0014 add
#                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pml),'','')   #FUN-CB0014 mark
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_qcp),'','')                         #FUN-CB0014 add
               END IF
            #FUN-CB0014---add---str---
            END IF
            IF g_action_flag = "page_list" THEN
               LET page = f.FindNode("Page","page_list")
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_shh_l),'','')
               END IF
            END IF
            #FUN-CB0014---add---end---

       # ON ACTION help
        WHEN "help"
            CALL cl_show_help()
       # ON ACTION locale
        WHEN "locale"
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
           CASE g_shh.shh14
                WHEN 'Y'   LET g_confirm = 'Y'
                           LET g_void = ''
                WHEN 'N'   LET g_confirm = 'N'
                           LET g_void = ''
                WHEN 'X'   LET g_confirm = ''
                           LET g_void = 'Y'
             OTHERWISE     LET g_confirm = ''
                           LET g_void = ''
           END CASE
           #圖形顯示
           CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
       # ON ACTION exit
       WHEN "exit"
           # LET g_action_choice = "exit"
           # EXIT MENU
           EXIT WHILE
       # ON ACTION jump
       WHEN "jump"
           CALL t720_fetch('/')
       # ON ACTION first
       WHEN "first"
            CALL t720_fetch('F')
       # ON ACTION last
       WHEN "last"
            CALL t720_fetch('L')
 
       # ON IDLE g_idle_seconds
      
       #    CALL cl_on_idle()
 
        #No.FUN-6A0164-------add--------str----
       # ON ACTION related_document       #相關文件
       WHEN "related_document"
         #  LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_shh.shh01 IS NOT NULL THEN
                  LET g_doc.column1 = "shh01"
                  LET g_doc.value1 = g_shh.shh01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0164-------add--------end----

       # ON ACTION CONTROLG            #MOD-D70063 add
       WHEN "controlg"
            CALL cl_cmdask()          #MOD-D70063 add
 
        -- for Windows close event trapped
       # ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
       WHEN "close"
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
           # EXIT MENU
           EXIT WHILE
 
      #No.FUN-7C0050 add
    #  &include "qry_string.4gl"
    #END MENU
     END CASE
    END WHILE
    CLOSE t720_cs  
END FUNCTION
 
 
FUNCTION t720_a()
    DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067        #No.FUN-680121 SMALLINT
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_shh.* LIKE shh_file.*
    LET g_shh_t.* = g_shh.*
    LET g_shh01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_shh.shhuser = g_user
        LET g_shh.shhoriu = g_user #FUN-980030
        LET g_shh.shhorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_shh.shhgrup = g_grup               #使用者所屬群
        LET g_shh.shhdate = g_today
        LET g_shh.shh02   =g_today
        LET g_shh.shh021  =TIME
        LET g_shh.shh14   ='N'
        LET g_shh.shh06   =' '
        LET g_shh.shh08   ='1'       #20180525
        LET g_shh.shhplant = g_plant #FUN-980008 add
        LET g_shh.shhlegal = g_legal #FUN-980008 add
        #NO.TQC-AB0280--begin
        IF g_sma.sma541='N' THEN
           LET g_shh.shh012=' '
        END IF
        #NO.TQC-AB0280---end
        CALL t720_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_shh.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_shh.shh01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK   #No:7829
       #No.FUN-550067 --start--
        CALL s_auto_assign_no("asf",g_shh.shh01,g_shh.shh02,"E","shh_file","shh01","","","")
        RETURNING li_result,g_shh.shh01
      IF (NOT li_result) THEN
#       IF g_smy.smyauno='Y' THEN #自動賦予單據編號
#   CALL s_smyauno(g_shh.shh01,g_shh.shh02) RETURNING g_i,g_shh.shh01
#          IF g_i THEN #有問題
         #No.FUN-550067 ---end---
              ROLLBACK WORK   #No:7829
              CONTINUE WHILE
           END IF
	   DISPLAY BY NAME g_shh.shh01
#       END IF       #No.FUN-550067
       #FUN-A60076 ---------start -----------------------
           IF g_shh.shh012 IS NULL THEN
           LET g_shh.shh012= ' '
           END IF
       #FUN-A60076 -----------end ------------------------
        SELECT qczud07 INTO g_shh.shhud10 FROM qcz_file   #20180608 抓開單時間放入
        LET g_shh.shh131 = g_shh.shh111
        LET g_shh.shh151 = g_shh.shh111
        INSERT INTO shh_file VALUES(g_shh.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)   #No.FUN-660128
           CALL cl_err3("ins","shh_file",g_shh.shh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        ELSE
           COMMIT WORK     #No:7829
           CALL cl_flow_notify(g_shh.shh01,'I')
 
           SELECT shh01 INTO g_shh.shh01 FROM shh_file
            WHERE shh01 = g_shh.shh01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t720_i(p_cmd)
    DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067        #No.FUN-680121 SMALLINT
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_ecm45         LIKE ecm_file.ecm45,
        l_ecm55         LIKE ecm_file.ecm55,
        l_ecm56         LIKE ecm_file.ecm56,
#       l_slip          VARCHAR(3),
        l_slip          LIKE aab_file.aab02,         #No.FUN-680121 VARCHAR(5)#No.FUN-550067
        l_n             LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_gem02_2    LIKE gem_file.gem02          #20180605
 
    DISPLAY BY NAME
        g_shh.shh14,g_shh.shhuser,g_shh.shhgrup,g_shh.shhmodu,g_shh.shhdate
    
    INPUT BY NAME g_shh.shhoriu,g_shh.shhorig,
        g_shh.shh01,g_shh.shh02,g_shh.shh021,
        g_shh.shh101,
      # g_shh.shh08,g_shh.shh04,g_shh.shh061,g_shh.shh14,g_shh.shh03,g_shh.shh012,      #FUN-A60076 add g_shh.shh012    #TQC-AC0289 mark
      # g_shh.shh08,                                                        #20180525 mark
        g_shh.shh04,g_shh.shh03,g_shh.shhud02,g_shh.shh012,                 #TQC-AC0289
        g_shh.shh05,
        g_shh.shhud07,                                                      #20180525
        g_shh.shh06,g_shh.shh14,                                            #TQC-AC0289 add  ,g_shh.shh061,g_shh.shh14,
        g_shh.shh111,g_shh.shh112,g_shh.shh113,g_shh.shh10,
        g_shh.shh131,g_shh.shh132,g_shh.shh121,
        g_shh.shh08,                                                        #20180525 modify
        g_shh.shh12,g_shh.shh061,
        g_shh.shh151,g_shh.shh152,g_shh.shh141,
        g_shh.shh022,g_shh.shh07,
        g_shh.shhud08,                                                      #20180525 modify
        g_shh.shh142,g_shh.shh143,
        g_shh.shh161,g_shh.shh162,g_shh.shh163,g_shh.shh164,g_shh.shh165,
        g_shh.shh171,g_shh.shh172,g_shh.shh173,g_shh.shh174,g_shh.shh175,
        g_shh.shhuser,g_shh.shhgrup,g_shh.shhmodu,g_shh.shhdate,
        #FUN-840068     ---start---
        g_shh.shhud01,g_shh.shhud03,g_shh.shhud04,
        g_shh.shhud05,g_shh.shhud06,
      # g_shh.shhud07,g_shh.shhud08,                                        #20180525 mark
        g_shh.shhud09,g_shh.shhud10,g_shh.shhud11,g_shh.shhud12,
        g_shh.shhud13,g_shh.shhud14,g_shh.shhud15 
        #FUN-840068     ----end----
        WITHOUT DEFAULTS

 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t720_set_entry(p_cmd)
            CALL t720_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         #No.FUN-550067 --start--
         CALL cl_set_docno_format("shh01")
         CALL cl_set_docno_format("shh03")
         #No.FUN-550067 ---end---
 
        AFTER FIELD shh01
        #No.FUN-550067 --start--
#        IF NOT cl_null(g_shh.shh01) AND g_shh.shh01 != g_shh01_t THEN      #TQC-740145
         IF NOT cl_null(g_shh.shh01) AND (g_shh.shh01 !=g_shh_t.shh01 OR g_shh_t.shh01 IS NULL) THEN   #TQC-740145
            CALL s_check_no("asf",g_shh.shh01,g_shh01_t,"E","shh_file","shh01","")
            RETURNING li_result,g_shh.shh01
            DISPLAY BY NAME g_shh.shh01
            IF (NOT li_result) THEN
               LET g_shh.shh01=g_shh_t.shh01
               NEXT FIELD shh01
            END IF
#           DISPLAY g_smy.smydesc TO smydesc     #TQC-740145
 
#           IF NOT cl_null(g_shh.shh01) THEN
#              IF g_shh.shh01 ='   -      ' THEN LET g_shh.shh01='' END IF
#              IF g_shh.shh01 IS NOT NULL THEN
#                 IF g_shh_t.shh01 IS NULL OR g_shh.shh01 != g_shh_t.shh01
#                 THEN LET l_slip=g_shh.shh01[1,3]
#                      CALL s_mfgslip(l_slip,'asf','E')	#檢查單別
#                      IF NOT cl_null(g_errno) THEN		#抱歉, 有問題
#                         CALL cl_err(l_slip,g_errno,0)
#                         LET g_shh.shh01=g_shh_t.shh01
#                         NEXT FIELD shh01
#                      END IF
#                 END IF
#                 IF p_cmd = 'a'  THEN
#                     IF NOT cl_null(g_shh.shh01[1,3]) AND #並且單號空白時,
#                        cl_null(g_shh.shh01[5,10]) THEN   #請使用者自行輸入
#                         IF g_smy.smyauno='N' THEN        #新增並要不自動編號
#                             NEXT FIELD shh01
#                         ELSE			       #要不, 則單號不用輸入
#                             NEXT FIELD shh02	
#                         END IF
#                     END IF
#                 END IF
#             END IF
#             IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
#                (p_cmd = "u" AND g_shh.shh01 != g_shh01_t) THEN
#                  IF g_smy.smyauno = 'Y' AND NOT cl_chk_data_continue(g_shh.shh01[5,10])
#                  THEN CALL cl_err('','9056',0)
#                       NEXT FIELD shh01
#                  END IF
#                  SELECT count(*) INTO l_n FROM shh_file
#                      WHERE shh01 = g_shh.shh01
#                  IF l_n > 0 THEN                  # Duplicated
#                      CALL cl_err(g_shh.shh01,-239,0)
#                      LET g_shh.shh01 = g_shh01_t
#                      DISPLAY BY NAME g_shh.shh01
#                      NEXT FIELD shh01
#                  END IF
#             END IF
         #No.FUN-550067 ---end---
           END IF
 
        AFTER FIELD shh021
           IF NOT cl_null(g_shh.shh021) THEN
              LET g_h1=g_shh.shh021[1,2]
              LET g_m1=g_shh.shh021[4,5]
              LET g_s1=g_shh.shh021[7,8]
              IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1>23 OR g_m1>=60
              THEN CALL cl_err(g_shh.shh021,'asf-807',1)
                   NEXT FIELD sha021
              END IF
           END IF
 
 
       AFTER FIELD shh08
          #20180523 mark by momo (S)
          #IF g_shh.shh08 NOT MATCHES '[12]' THEN
          #   NEXT FIELD shh08
          #END IF
          #20180523 mark by momo (E)
 
 
        AFTER FIELD shh04
            IF not cl_null(g_shh.shh04) THEN
                 #CALL t720_shh04('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_shh.shh04,g_errno,0)
                    LET g_shh.shh04 = g_shh_t.shh04
                    DISPLAY BY NAME g_shh.shh04
                    NEXT FIELD shh04
                 END IF
            END IF
 
        AFTER FIELD shh03
            IF NOT cl_null(g_shh.shh03) THEN
               #CALL t720_shh03('a')            #20180605 mark
               #IF NOT cl_null(g_errno) THEN
               #   CALL cl_err(g_shh.shh03,g_errno,0)
               #   LET g_shh.shh03 = g_shh_t.shh03
               #   DISPLAY BY NAME g_shh.shh03
               #   NEXT FIELD shh03
               #END IF
            END IF

       #TQC-AC0289 ------------add start-----------
        AFTER FIELD shh012 
           IF g_shh.shh012 IS NOT NULL AND NOT cl_null(g_shh.shh06) THEN
              CALL t720_shh06('a')
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_shh.shh012,g_errno,0)
                  LET g_shh.shh012 = g_shh_t.shh012
                  DISPLAY BY NAME g_shh.shh012
                  NEXT FIELD shh012
               END IF
           END IF 
       #TQC-AC0289 -----------add end--------------- 
 
       { AFTER FIELD shh05   #作業編號
 
          IF NOT cl_null(g_shh.shh05) THEN  #MOD-490144
            SELECT COUNT(*) INTO g_cnt FROM ecm_file
             WHERE ecm01=g_shh.shh03 AND ecm04=g_shh.shh05 AND ecm012=g_shh.shh012    #FUN-A60076  add 
            CASE
              WHEN g_cnt=0
                   CALL cl_err(g_shh.shh05,100,0)
                   LET g_shh.shh05 = g_shh_t.shh05
                   LET g_shh.shh06 = g_shh_t.shh06
                   DISPLAY BY NAME g_shh.shh05,g_shh_t.shh06
                   NEXT FIELD shh05
              WHEN g_cnt=1
                   IF NOT cl_null(g_shh.shh06) THEN
                       SELECT ecm03,ecm05,ecm45,ecm55,ecm56
                         INTO g_shh.shh06,g_shh.shh07,l_ecm45,l_ecm55,l_ecm56
                         FROM ecm_file
                        WHERE ecm01=g_shh.shh03 AND ecm04=g_shh.shh05
                          AND ecm03=g_shh.shh06  AND ecm012=g_shh.shh012              #FUN-A60076  add 
                   ELSE
                       SELECT ecm03,ecm05,ecm45,ecm55,ecm56
                         INTO g_shh.shh06,g_shh.shh07,l_ecm45,l_ecm55,l_ecm56
                         FROM ecm_file
                        WHERE ecm01=g_shh.shh03 AND ecm04=g_shh.shh05 
                        AND ecm012=g_shh.shh012                                     #FUN-A60076  add
                   END IF
                   IF STATUS THEN  #資料資料不存在
                 #     CALL cl_err(g_shh.shh05,STATUS,0)  #No.FUN-660128
                      CALL cl_err3("sel","ecm_file",g_shh.shh03,"",STATUS,"","",1)  #No.FUN-660128
                      LET g_shh.shh05 = g_shh_t.shh05
                      LET g_shh.shh06 = g_shh_t.shh06
                      DISPLAY BY NAME g_shh.shh05,g_shh.shh06
                      NEXT FIELD shh05
                   END IF
                   #-->無hold
                   ##---- 20180523 mark by momo (S)
                   #IF g_shh.shh08 ='1' AND cl_null(l_ecm55) THEN
                   #   CALL cl_err(g_shh.shh05,'asf-729',0)
                   #   LET g_shh.shh05 = g_shh_t.shh05
                   #   LET g_shh.shh06 = g_shh_t.shh06
                   #   DISPLAY BY NAME g_shh.shh05,g_shh.shh06
                   #   NEXT FIELD shh08
                   #ELSE LET g_shh.shh061 = l_ecm55
                   #END IF
                   #IF g_shh.shh08 ='2' AND cl_null(l_ecm56) THEN
                   #   CALL cl_err(g_shh.shh05,'asf-730',0)
                   #   LET g_shh.shh05 = g_shh_t.shh05
                   #   LET g_shh.shh06 = g_shh_t.shh06
                   #   DISPLAY BY NAME g_shh.shh05,g_shh.shh06
                   #   NEXT FIELD shh08
                   #ELSE LET g_shh.shh061 = l_ecm56
                   #END IF
                   ##---- 20180523 mark by momo (E)
              WHEN g_cnt>1
                  #CALL q_ecm(FALSE,FALSE,g_shh.shh03,g_shh.shh05)  #FUN-C30163 mark
                   CALL q_ecm(FALSE,FALSE,g_shh.shh03,g_shh.shh05,'','','','')  #FUN-C30163 add
                        RETURNING g_shh.shh05,g_shh.shh06
#                   CALL FGL_DIALOG_SETBUFFER( g_shh.shh05 )
#                   CALL FGL_DIALOG_SETBUFFER( g_shh.shh06 )
                   SELECT ecm03,ecm05,ecm45,ecm55,ecm56
                     INTO g_shh.shh06,g_shh.shh07,l_ecm45,l_ecm55,l_ecm56
                     FROM ecm_file
                     WHERE ecm01=g_shh.shh03 AND ecm04=g_shh.shh05
                       AND ecm03=g_shh.shh06 AND ecm012=g_shh.shh012              #FUN-A60076  add 
                   IF STATUS THEN  #資料資料不存在
#                     CALL cl_err(g_shh.shh05,STATUS,0)   #No.FUN-660128
                      CALL cl_err3("sel","ecm_file",g_shh.shh03,g_shh.shh06,STATUS,"","",1)  #No.FUN-660128
                      LET g_shh.shh05 = g_shh_t.shh05
                      LET g_shh.shh06 = g_shh_t.shh06
                      DISPLAY BY NAME g_shh.shh05,g_shh.shh06
                      NEXT FIELD shh05
                   END IF
                   #-->無hold
                   #20180523 mark by momo (S)
                   #IF g_shh.shh08 ='1' AND cl_null(l_ecm55) THEN
                   #   CALL cl_err(g_shh.shh05,'asf-729',0)
                   #   LET g_shh.shh05 = g_shh_t.shh05
                   #   DISPLAY BY NAME g_shh.shh05
                   #   NEXT FIELD shh05
                   #ELSE LET g_shh.shh061 = l_ecm55
                   #END IF
                   #IF g_shh.shh08 ='2' AND cl_null(l_ecm56) THEN
                   #   CALL cl_err(g_shh.shh05,'asf-730',0)
                   #   LET g_shh.shh05 = g_shh_t.shh05
                   #   DISPLAY BY NAME g_shh.shh05
                   #   NEXT FIELD shh05
                   #ELSE LET g_shh.shh061 = l_ecm56
                   #END IF
                   #20180523 mark by momo (E)
              OTHERWISE EXIT CASE
            END CASE
            #CALL t720_shh061('d')
          END IF #MOD-490144
 }
        AFTER FIELD shh06   #製程序號
         # IF NOT cl_null(g_shh.shh06) THEN                                #TQC-AC0289 mark
           IF NOT cl_null(g_shh.shh06) AND g_shh.shh012 IS NOT NULL THEN   #TQC-AC0289
               CALL t720_shh06('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_shh.shh06,g_errno,0)
                  LET g_shh.shh06 = g_shh_t.shh06
                  DISPLAY BY NAME g_shh.shh06
                  NEXT FIELD shh06
               END IF
           END IF
 
       AFTER FIELD shh101
          IF NOT cl_null(g_shh.shh101) THEN
             #CALL t720_gen02('a','1',g_shh.shh101)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_shh.shh101,g_errno,0)
                LET g_shh.shh101 = g_shh_t.shh101
                DISPLAY BY NAME g_shh.shh101
                NEXT FIELD shh101
             END IF
          END IF
 
       AFTER FIELD shh10
          IF NOT cl_null(g_shh.shh10) THEN
             #CALL t720_gem02('a','1',g_shh.shh10)
             #IF NOT cl_null(g_errno) THEN
             #   CALL cl_err(g_shh.shh10,g_errno,0)
             #   LET g_shh.shh10 = g_shh_t.shh10
             #   DISPLAY BY NAME g_shh.shh10
             #   NEXT FIELD shh10
             #END IF
          END IF
 
       AFTER FIELD shh121
          IF NOT cl_null(g_shh.shh121) THEN
             #CALL t720_gen02('a','2',g_shh.shh121)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_shh.shh121,g_errno,0)
                LET g_shh.shh121 = g_shh_t.shh121
                DISPLAY BY NAME g_shh.shh121
                NEXT FIELD shh121
             END IF
          END IF

       AFTER FIELD shh132
         LET g_shh.shh152 = g_shh.shh132
 
       AFTER FIELD shh022
          IF NOT cl_null(g_shh.shh022) THEN
             ##---- 20230214 add by momo (S) 增加供應商代號檢核
             IF g_shh.shh08='2' THEN
                SELECT pmc03 INTO g_shh.shh12 FROM pmc_file
                 WHERE pmc01 = g_shh.shh022
                IF cl_null(g_shh.shh12) THEN
                   CALL cl_err(g_shh.shh022,'3014',1)
                   NEXT FIELD shh022
                END IF
             ELSE
               SELECT gem02 INTO g_shh.shh12 FROM gem_file
                WHERE gem01 = g_shh.shh022
               IF cl_null(g_shh.shh12) THEN
                  CALL cl_err(g_shh.shh022,'DSC-127',1)
                  NEXT FIELD shh022
               END IF 
             END IF
             DISPLAY BY NAME g_shh.shh12
             ##---- 20230214 add by momo (E)
          END IF
 
       #FUN-840068     ---start---
       AFTER FIELD shhud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD shhud02
         # IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF #20180605 mark
         IF NOT cl_null(g_shh.shhud02) THEN
            CALL t720_shh03('a')  
         ELSE
            NEXT FIELD shhud02                          
         END IF
       AFTER FIELD shhud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD shhud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD shhud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD shhud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD shhud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD shhud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD shhud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD shhud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD shhud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD shhud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD shhud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD shhud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD shhud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #FUN-840068     ----end----
 
        ON ACTION controlp                        # 沿用所有欄位
           CASE
              WHEN INFIELD(shh01)
#                LET l_slip = g_shh.shh01[1,3]
                  LET l_slip = s_get_doc_no(g_shh.shh01)     #No.FUN-550067
                #CALL q_smy(FALSE,FALSE,l_slip,'asf','E') RETURNING l_slip  #TQC-670008
                 CALL q_smy(FALSE,FALSE,l_slip,'ASF','E') RETURNING l_slip  #TQC-670008
#                 CALL FGL_DIALOG_SETBUFFER( l_slip )
#                LET g_shh.shh01[1,3] = l_slip
                 LET g_shh.shh01 = l_slip      #No.FUN-550067
                 DISPLAY BY NAME g_shh.shh01
                 NEXT FIELD shh01
              WHEN INFIELD(shh03)
                 #CALL q_sfb(0,0,g_shh.shh03,'2345678') RETURNING g_shh.shh03
                 #CALL FGL_DIALOG_SETBUFFER( g_shh.shh03 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_sfb"
                 LET g_qryparam.default1 = g_shh.shh03
                 LET g_qryparam.arg1     = "2345678"
                 CALL cl_create_qry() RETURNING g_shh.shh03
#                 CALL FGL_DIALOG_SETBUFFER( g_shh.shh03 )
                 DISPLAY BY NAME g_shh.shh03
                 NEXT FIELD shh03
              ##---- 20180605 工單備料檔(S)
              WHEN INFIELD(shhud02)
                 CALL cl_init_qry_var()
                 IF NOT cl_null(g_shh.shh03) THEN
                    LET g_qryparam.form     = "cq_sfa01"
                    LET g_qryparam.default1 = g_shh.shhud02
                    LET g_qryparam.arg1     = g_shh.shh03
                 ELSE 
                    LET g_qryparam.form     = "q_ima"
                    LET g_qryparam.default1 = g_shh.shhud02
                 END IF
                 CALL cl_create_qry() RETURNING g_shh.shhud02
                 DISPLAY BY NAME g_shh.shhud02
                 NEXT FIELD shhud02
              ##---- 20180605 工單備料檔(E)
              WHEN INFIELD(shh04)
                 #CALL q_occ(0,0,g_shh.shh04) RETURNING g_shh.shh04
                 #CALL FGL_DIALOG_SETBUFFER( g_shh.shh04 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_occ"
                 LET g_qryparam.default1 = g_shh.shh04
                 CALL cl_create_qry() RETURNING g_shh.shh04
#                 CALL FGL_DIALOG_SETBUFFER( g_shh.shh04 )
                 DISPLAY BY NAME g_shh.shh04
                 NEXT FIELD shh04

             #TQC-AC0289 ---------------------mod start---------------------- 
             ##FUN-A60076 -------start------------------------     
             #WHEN INFIELD(shh012)
             ##CALL FGL_DIALOG_SETBUFFER( g_shh.shh04 )
             #   CALL cl_init_qry_var()
             #   LET g_qryparam.form     = "q_shh012"
             #   LET g_qryparam.default1 = g_shh.shh012
             #   CALL cl_create_qry() RETURNING g_shh.shh012
             #   DISPLAY BY NAME g_shh.shh012
             #   NEXT FIELD shh012
             ##FUN-A60076--------end----------------------------
             #WHEN INFIELD(shh012)       
              WHEN INFIELD(shh012) OR INFIELD(shh06) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     =  "q_shh012_1"
                 LET g_qryparam.default1 = g_shh.shh012
                 lET g_qryparam.default2 = g_shh.shh06 
                 LET g_qryparam.default2 = g_shh.shh05
                 LET g_qryparam.arg1     = g_shh.shh03
                 CALL cl_create_qry() RETURNING g_shh.shh012,g_shh.shh06,g_shh.shh05
                 IF cl_null(g_shh.shh012) OR g_shh.shh012 IS NULL THEN
                    LET g_shh.shh012 = ' '
                 END IF   
                 DISPLAY BY NAME g_shh.shh012,g_shh.shh06,g_shh.shh05 
                 NEXT FIELD CURRENT 
             #TQC-AC0289 ---------------------mod end-----------------------------

              WHEN INFIELD(shh05)
                #CALL q_ecm(FALSE,FALSE,g_shh.shh03,'')  #FUN-C30163 mark
                 CALL q_ecm(FALSE,FALSE,g_shh.shh03,'','','','','')   #FUN-C30163 add
                      RETURNING g_shh.shh05,g_shh.shh06
#                CALL FGL_DIALOG_SETBUFFER( g_shh.shh05 )
#                CALL FGL_DIALOG_SETBUFFER( g_shh.shh06 )
                 IF NOT cl_null(g_shh.shh05) AND NOT cl_null(g_shh.shh06) THEN
                    SELECT ecm03,ecm05 INTO g_shh.shh06,g_shh.shh07 FROM ecm_file
                     WHERE ecm01=g_shh.shh03 AND ecm04=g_shh.shh05
                       AND ecm03=g_shh.shh06 AND ecm012=g_shh.shh012              #FUN-A60076  add
                    IF STATUS THEN  #資料資料不存在
#                      CALL cl_err(g_shh.shh05,g_errno,0)   #No.FUN-660128
                       CALL cl_err3("sel","ecm_file",g_shh.shh03,g_shh.shh06,g_errno,"","",1)  #No.FUN-660128
                       LET g_shh.shh05 = g_shh_t.shh05
                       DISPLAY BY NAME g_shh.shh05
                       NEXT FIELD shh05
                    END IF
                    DISPLAY BY NAME g_shh.shh06, g_shh.shh07
                  ELSE
                     LET g_shh.shh05 = g_shh_t.shh05
                     DISPLAY BY NAME g_shh.shh05
                  END IF
                 NEXT FIELD shh05
              ##---- 20180525 add by momo (S) 異常原因說明
              WHEN INFIELD(shh111)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "cq_qce01"
                 LET g_qryparam.default1 = g_shh.shh111
                 CALL cl_create_qry() RETURNING g_shh.shh111
                 DISPLAY BY NAME g_shh.shh111
                 NEXT FIELD shh111
              ##---- 20180525 add by momo (E) 異常原因說明
              ##---- 20180604 add by momo (S) 異常原因說明
              WHEN INFIELD(shh131)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "cq_qce01"
                 LET g_qryparam.default1 = g_shh.shh131
                 CALL cl_create_qry() RETURNING g_shh.shh131
                 DISPLAY BY NAME g_shh.shh131
                 NEXT FIELD shh131
              WHEN INFIELD(shh151)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form     = "cq_qce01"
                 LET g_qryparam.default1 = g_shh.shh151
                 CALL cl_create_qry() RETURNING g_shh.shh151
                 DISPLAY BY NAME g_shh.shh151
                 NEXT FIELD shh151
              ##---- 20180604 add by momo (E) 異常原因說明
              WHEN INFIELD(shh101)
                 #CALL q_gen(10,3,g_shh.shh101) RETURNING g_shh.shh101
                 #CALL FGL_DIALOG_SETBUFFER( g_shh.shh101 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "cq_gen10"
                 LET g_qryparam.default1 = g_shh.shh101
                 CALL cl_create_qry() RETURNING g_shh.shh101,g_shh.shh10
#                 CALL FGL_DIALOG_SETBUFFER( g_shh.shh101 )
                 DISPLAY BY NAME g_shh.shh101,g_shh.shh10
                 NEXT FIELD shh101
              WHEN INFIELD(shh10)
                 #CALL q_gem(0,0,g_shh.shh10) RETURNING g_shh.shh10
                 #CALL FGL_DIALOG_SETBUFFER( g_shh.shh10 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_gem"
                 LET g_qryparam.default1 = g_shh.shh10
                 CALL cl_create_qry() RETURNING g_shh.shh10
#                 CALL FGL_DIALOG_SETBUFFER( g_shh.shh10 )
                  DISPLAY BY NAME g_shh.shh10
                 NEXT FIELD shh10
              WHEN INFIELD(shh121)
                 #CALL q_gen(10,3,g_shh.shh121) RETURNING g_shh.shh121
                 #CALL FGL_DIALOG_SETBUFFER( g_shh.shh121 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen10"
                  LET g_qryparam.default1 = g_shh.shh121
                  CALL cl_create_qry() RETURNING g_shh.shh121
#                  CALL FGL_DIALOG_SETBUFFER( g_shh.shh121 )
                  DISPLAY BY NAME g_shh.shh121
                  NEXT FIELD shh121
               WHEN INFIELD(shh12)   #20230214 mark
              #WHEN INFIELD(shh022)  #20230214 modify
                 #CALL q_gem(0,0,g_shh.shh12) RETURNING g_shh.shh12
                 #CALL FGL_DIALOG_SETBUFFER( g_shh.shh12 )
                  CALL cl_init_qry_var()
                  ##---- 20180525 modify by momo 依責任歸屬決定要開部門還是廠商 (S)
                  #LET g_qryparam.form     = "q_gem"
                  IF g_shh.shh08 <> '2' THEN
                     LET g_qryparam.form     = "cq_gem"
                  ELSE
                     LET g_qryparam.form     = "cq_pmc02"
                  END IF
                  ##---- 20180525 modify by momo 依責任歸屬決定要開部門還是廠商 (E)
                  LET g_qryparam.default1 = g_shh.shh12
                  CALL cl_create_qry() RETURNING g_shh.shh022,g_shh.shh12
#                  CALL FGL_DIALOG_SETBUFFER( g_shh.shh12 )
                  DISPLAY BY NAME g_shh.shh12,g_shh.shh022
                  NEXT FIELD shh12
#TQC-A50107 --add
                WHEN INFIELD(shh061)
                   CALL cl_init_qry_var()
                  #LET g_qryparam.form     = "q_sha061"  #20180604 留置碼改責任人員
                   LET g_qryparam.form     = "cq_gen10"     #20180604
                   LET g_qryparam.default1 = g_shh.shh061
                   CALL cl_create_qry() RETURNING g_shh.shh061,g_shh.shh061
                   LET g_shh.shh07 = g_shh.shh061
                   DISPLAY BY NAME g_shh.shh061
                   NEXT FIELD shh061
#TQC-A50107 --end
                ##---- 20180604 (S)
                WHEN INFIELD(shh141)   #複判人員
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_gen10"     
                   LET g_qryparam.default1 = g_shh.shh141
                   CALL cl_create_qry() RETURNING g_shh.shh141
                   DISPLAY BY NAME g_shh.shh141
                   NEXT FIELD shh141
                WHEN INFIELD(shh022)   #複判部門/廠商
                   CALL cl_init_qry_var()
                   CALL q_gem_pmc(FALSE,TRUE,g_plant) RETURNING g_shh.shh022,l_gem02_2
                   DISPLAY BY NAME g_shh.shh022
                   DISPLAY l_gem02_2 TO FORMONLY.gem02_2
                   NEXT FIELD shh022
                WHEN INFIELD(shh07)   #複判責任人員
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_gen10"     
                   LET g_qryparam.default1 = g_shh.shh07
                   CALL cl_create_qry() RETURNING g_shh.shh07
                   DISPLAY BY NAME g_shh.shh07
                   NEXT FIELD shh07
                ##---- 20180604 (E)
               OTHERWISE
                  EXIT CASE
            END CASE
#MOD-650015 --start
#       ON ACTION CONTROLO                        # 沿用所有欄位
#           IF INFIELD(shh01) THEN
#               LET g_shh.* = g_shh_t.*
#               CALL t720_show()
#               NEXT FIELD shh01
#           END IF
#MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
            
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
END FUNCTION
 
FUNCTION t720_shh03(p_cmd)
         DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                l_sfb04     LIKE sfb_file.sfb04,
                l_sfb05     LIKE sfb_file.sfb05,       
                l_ta_sfb01  LIKE sfb_file.ta_sfb01,       #20180605
                l_sfb28     LIKE sfb_file.sfb28,
                l_ima02     LIKE ima_file.ima02,
                l_ima021    LIKE ima_file.ima021
 
    LET g_errno = ' '
    #SELECT sfb04,sfb05,sfb28 INTO l_sfb04,l_sfb05,l_sfb28                        #20180605 mark
    IF NOT cl_null(g_shh.shh03) THEN
    SELECT sfb04,sfb05,ta_sfb01,sfb28 INTO l_sfb04,l_sfb05,l_ta_sfb01,l_sfb28     #20180605 modify
      FROM sfb_file
     WHERE sfb01 = g_shh.shh03
    
	  CASE WHEN SQLCA.SQLCODE = 100  
                         #LET g_errno = 'asf-312'
                          LET l_sfb04 = NULL LET l_sfb05 = NULL
                          LET l_sfb28 = NULL
             #  WHEN l_sfb04  = '1' OR l_sfb04 = '8'
	     #                      LET g_errno = 'asf-716'
             #  WHEN l_sfb28  = '3' LET g_errno = 'asf-803'
               OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno)  THEN
       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       #WHERE ima01 = l_sfb05       #20180605
        WHERE ima01 = g_shh.shhud02 #20180605
       SELECT ima021 INTO l_ima021 FROM ima_file
        WHERE ima01 = l_sfb05       #20180605
       #IF SQLCA.sqlcode THEN LET l_ima02 = ' ' LET l_ima021 = ' ' END IF
       #DISPLAY l_sfb05  TO FORMONLY.sfb05
       DISPLAY l_ta_sfb01  TO FORMONLY.sfb05
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
    END IF
END FUNCTION
 
FUNCTION t720_shh04(p_cmd)    #客戶編號
         DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                l_occ02     LIKE occ_file.occ02,
                l_occacti   LIKE occ_file.occacti
 
     LET g_errno = ' '
     SELECT occ02,occacti INTO l_occ02,l_occacti
       FROM occ_file WHERE occ01 = g_shh.shh04
         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                        LET l_occ02 = NULL
              WHEN l_occacti='N' LET g_errno = '9028'
  #FUN-690023------mod-------
              WHEN l_occacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690023------mod-------
              OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
     IF p_cmd = 'd' OR cl_null(g_errno)
     THEN DISPLAY l_occ02 TO FORMONLY.occ02
     END IF
END FUNCTION
 
FUNCTION t720_shh06(p_cmd)    #製程序
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         l_ecm04     LIKE ecm_file.ecm04,
         l_ecm05     LIKE ecm_file.ecm05,
         l_ecm11     LIKE ecm_file.ecm11,
         l_ecm45     LIKE ecm_file.ecm45,
         l_ecm55     LIKE ecm_file.ecm55,
         l_ecm56     LIKE ecm_file.ecm56
 
     LET g_errno = ' '
     SELECT ecm04,ecm05,ecm11,ecm45,ecm55,ecm56
       INTO l_ecm04,l_ecm05,l_ecm11,l_ecm45,l_ecm55,l_ecm56
       FROM ecm_file WHERE ecm01 = g_shh.shh03 AND ecm03 = g_shh.shh06
                                               AND ecm012=g_shh.shh012              #FUN-A60076  add
         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-805'
                                        LET l_ecm04 = NULL LET l_ecm05 = NULL
                                        LET l_ecm11 = NULL LET l_ecm45 = NULL
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
     IF p_cmd = 'a' THEN
        LET g_shh.shh05 = l_ecm04
        LET g_shh.shh07 = l_ecm05
   
        #20180523 mark by momo (S)
       # IF g_shh.shh08 = '1' THEN
       #      LET g_shh.shh061= l_ecm55
       # ELSE LET g_shh.shh061= l_ecm56
       # END IF
         #20180523 mark by momo (S)
        #CALL t720_shh061('d')
        DISPLAY BY NAME g_shh.shh05,g_shh.shh07
     END IF
     IF p_cmd = 'd' OR cl_null(g_errno)
     THEN DISPLAY l_ecm45 TO FORMONLY.ecm45
     END IF
END FUNCTION
 
FUNCTION t720_shh061(p_cmd)
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         l_sgg02     LIKE sgg_file.sgg02,
         l_sggacti   LIKE sgg_file.sggacti
 
     LET g_errno = ' '
     ##---- 20180604 留置改為責任人員
     #SELECT sgg02,sggacti INTO l_sgg02,l_sggacti #20180604
     #  FROM sgg_file WHERE sgg01 = g_shh.shh061  #20180604
      SELECT gen02,genacti INTO l_sgg02,l_sggacti #20180604
        FROM gen_file WHERE gen01=g_shh.shh061    #20180604
         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-731'
                                        LET l_sgg02 = NULL
              WHEN l_sggacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
     IF p_cmd = 'd' OR cl_null(g_errno)
     THEN DISPLAY l_sgg02 TO FORMONLY.sgg02
          DISPLAY BY NAME g_shh.shh061
     END IF
END FUNCTION
 
FUNCTION t720_gen02(p_cmd,p_type,p_gen01)    #人員
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         p_type      LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         p_gen01     LIKE gen_file.gen01,
         l_gen02     LIKE gen_file.gen02,
         l_gen03     LIKE gen_file.gen03,
         l_genacti   LIKE gen_file.genacti
 
     LET g_errno = ' '
     SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
       FROM gen_file WHERE gen01 = p_gen01
         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                        LET l_gen02 = NULL
              WHEN l_genacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
     IF p_cmd = 'd' OR cl_null(g_errno)
     THEN CASE
           WHEN p_type = '1'
                 IF p_cmd = 'a' AND cl_null(g_shh.shh10) THEN
                    LET g_shh.shh10 = l_gen03
                    DISPLAY BY NAME g_shh.shh10
                 END IF
                 DISPLAY l_gen02 TO FORMONLY.gen02_1
           WHEN p_type = '2'
                 IF p_cmd = 'a' AND cl_null(g_shh.shh12) THEN
                    LET g_shh.shh12 = l_gen03
                    DISPLAY BY NAME g_shh.shh12
                 END IF
                 DISPLAY l_gen02 TO FORMONLY.gen02_2
           OTHERWISE EXIT CASE
          END CASE
     END IF
END FUNCTION
 
FUNCTION t720_gem02(p_cmd,p_type,p_gem01)    #部門
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         p_type      LIKE type_file.chr1,          #No.FUN-680121
         p_gem01     LIKE gem_file.gem01,
         l_gem02     LIKE gem_file.gem02,
         l_gemacti   LIKE gem_file.gemacti
 
     LET g_errno = ' '
     IF g_shh.shh08 <> '2' THEN                           #20180525
       SELECT gem02,gemacti INTO l_gem02,l_gemacti
         FROM gem_file WHERE gem01 = p_gem01
     ELSE                                              #20180525
       SELECT pmc03,pmcacti INTO l_gem02,l_gemacti     #20180525
         FROM pmc_file WHERE pmc01 = p_gem01           #20180525
     END IF                                            #20180525
        # CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
        #                                LET l_gem02 = NULL
        #      WHEN l_gemacti='N' LET g_errno = '9028'
        #       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	#  END CASE
     IF p_cmd = 'd' OR cl_null(g_errno)
     THEN CASE
           WHEN p_type = '1'
                 DISPLAY l_gem02 TO FORMONLY.gem02_1
           WHEN p_type = '2'
                 DISPLAY l_gem02 TO FORMONLY.gem02_2
           OTHERWISE EXIT CASE
          END CASE
     END IF
END FUNCTION
 
FUNCTION t720_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_shh.* TO NULL                #No.FUN-6A0164
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t720_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t720_count
    FETCH t720_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t720_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)
        INITIALIZE g_shh.* TO NULL
    ELSE
        CALL t720_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t720_fetch(p_flshh)
    DEFINE
        p_flshh         LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680121 INTEGER
 
    CASE p_flshh
        WHEN 'N' FETCH NEXT     t720_cs INTO g_shh.shh01
        WHEN 'P' FETCH PREVIOUS t720_cs INTO g_shh.shh01
        WHEN 'F' FETCH FIRST    t720_cs INTO g_shh.shh01
        WHEN 'L' FETCH LAST     t720_cs INTO g_shh.shh01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t720_cs INTO g_shh.shh01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)
        INITIALIZE g_shh.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flshh
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_shh.* FROM shh_file            # 重讀DB,因TEMP有不被更新特性
       WHERE shh01 = g_shh.shh01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)   #No.FUN-660128
        CALL cl_err3("sel","shh_file",g_shh.shh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_shh.* TO NULL             #FUN-4C0035
    ELSE
        LET g_data_owner = g_shh.shhuser      #FUN-4C0035
        LET g_data_group = g_shh.shhgrup      #FUN-4C0035
        LET g_data_plant = g_shh.shhplant #FUN-980030
        LET g_data_keyvalue = g_shh.shh01  #FUN-DA0126  
        CALL t720_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t720_show()
    DEFINE
        l_ecb17    LIKE ecb_file.ecb17,
        l_ecm11    LIKE ecm_file.ecm11
 
    LET g_shh_t.* = g_shh.*
    LET g_data_keyvalue = g_shh.shh01        #FUN-F50015 add
    
    DISPLAY BY NAME g_shh.shh01,g_shh.shh03,g_shh.shh02,g_shh.shh04, g_shh.shhoriu,g_shh.shhorig,
            g_shh.shh021,g_shh.shh022,g_shh.shh012,g_shh.shh05,g_shh.shh06,           #FUN-A60076 add   g_shh.shh012   
            g_shh.shh07,g_shh.shh061,g_shh.shh08,g_shh.shh111,g_shh.shh112,g_shh.shh113,
            g_shh.shh101,g_shh.shh10,g_shh.shh131,g_shh.shh132,
            g_shh.shh121,g_shh.shh12,g_shh.shh151,g_shh.shh152,
            g_shh.shh141,g_shh.shh142,g_shh.shh143,
            g_shh.shh161,g_shh.shh162,g_shh.shh163,g_shh.shh164,g_shh.shh165,
            g_shh.shh171,g_shh.shh172,g_shh.shh173,g_shh.shh174,g_shh.shh175,
            g_shh.shh14,g_shh.shhuser,g_shh.shhgrup,g_shh.shhmodu,
            g_shh.shhdate,
            #FUN-840068     ---start---
            g_shh.shhud01,g_shh.shhud02,g_shh.shhud03,g_shh.shhud04,
            g_shh.shhud05,g_shh.shhud06,g_shh.shhud07,g_shh.shhud08,
            g_shh.shhud09,g_shh.shhud10,g_shh.shhud11,g_shh.shhud12,
            g_shh.shhud13,g_shh.shhud14,g_shh.shhud15 
            #FUN-840068     ----end----
    CALL t720_shh03('d')
    #CALL t720_shh04('d')
    CALL t720_shh06('d')
    #CALL t720_shh061('d')
    #CALL t720_gen02('d','1',g_shh.shh101)
    #CALL t720_gen02('d','2',g_shh.shh121)
    #CALL t720_gem02('d','1',g_shh.shh10)
    #CALL t720_gem02('d','2',g_shh.shh12)
    CALL t720_gem02('d','2',g_shh.shh022)
    CASE g_shh.shh14
         WHEN 'Y'   LET g_confirm = 'Y'
                    LET g_void = ''
         WHEN 'N'   LET g_confirm = 'N'
                    LET g_void = ''
         WHEN 'X'   LET g_confirm = ''
                    LET g_void = 'Y'
      OTHERWISE     LET g_confirm = ''
                    LET g_void = ''
    END CASE
    #圖形顯示
    CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
    CALL t720_b_fill(g_wc2)                   #單身 20180601
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t720_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_shh.shh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_shh.* FROM shh_file WHERE shh01=g_shh.shh01
    #-->已confirm不可修改
   #IF g_shh.shh14 = 'Y' THEN  #20180615 mark
    IF g_shh.shh14 = 'C' THEN  #20180615 modify
       CALL cl_err(g_shh.shh14,'axm-101',0) RETURN
    END IF
    IF g_shh.shh14 = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_shh01_t = g_shh.shh01
    BEGIN WORK
 
    OPEN t720_cl USING g_shh.shh01
 
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_shh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_shh.shhmodu=g_user                     #修改者
    LET g_shh.shhdate = g_today                  #修改日期
    CALL t720_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t720_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_shh.*=g_shh_t.*
            CALL t720_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE shh_file SET shh_file.* = g_shh.*    # 更新DB
            WHERE shh01 = g_shh01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","shh_file",g_shh_t.shh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t720_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shh.shh01,'U')
 
END FUNCTION
 
FUNCTION t720_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_shh.shh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_shh.* FROM shh_file WHERE shh01 = g_shh.shh01
    IF SQLCA.sqlcode THEN
#      CALL cl_err('sel error',SQLCA.sqlcode,0)    #No.FUN-660128
       CALL cl_err3("sel","shh_file","","",SQLCA.sqlcode,"","sel error",1)  #No.FUN-660128
       RETURN
    END IF
    #-->已confirm不可刪除
    IF g_shh.shh14 = 'Y' THEN
       CALL cl_err(g_shh.shh14,'axm-101',0) RETURN
    END IF
    IF g_shh.shh14 = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
    BEGIN WORK
 
    OPEN t720_cl USING g_shh.shh01
 
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_shh.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t720_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "shh01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_shh.shh01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM shh_file WHERE shh01 = g_shh.shh01
       CLEAR FORM
       OPEN t720_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t720_cs
          CLOSE t720_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t720_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t720_cs
          CLOSE t720_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t720_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t720_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t720_fetch('/')
       END IF
    END IF
 
    CLOSE t720_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shh.shh01,'D')
 
END FUNCTION
 
FUNCTION t720_y()
  DEFINE l_gen02   LIKE gen_file.gen02
  DEFINE l_time    LIKE type_file.chr8      #No.FUN-6A0090
  DEFINE l_qcp04   LIKE qcp_file.qcp04     #20180608 單身處理分鐘數
  DEFINE l_shhud10 LIKE shh_file.shhud10   #20180608 總開單時間
  DEFINE l_qczud10 LIKE qcz_file.qczud10   #20180608 單均薪資
 
  IF s_shut(0) THEN RETURN END IF
  IF g_shh.shh01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
  END IF
  SELECT * INTO g_shh.* FROM shh_file WHERE shh01 = g_shh.shh01
  IF SQLCA.sqlcode THEN
#    CALL cl_err('sel shh',SQLCA.sqlcode,0) #No.FUN-660128
     CALL cl_err3("sel","shh_file",g_shh.shh01,"",SQLCA.sqlcode,"","sel shh",1)  #No.FUN-660128
        RETURN   
  END IF
  IF g_shh.shh14 ='Y' THEN RETURN END IF
    IF g_shh.shh14 = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
  IF NOT cl_confirm('axm-108') THEN RETURN END IF
  LET g_success = 'Y'
  BEGIN WORK
        #20180523 mark by momo (S)
        {
     CASE g_shh.shh08
        WHEN  '1'
            UPDATE ecm_file SET ecm55 = ' '
                           WHERE ecm01 = g_shh.shh03
                             AND ecm03 = g_shh.shh06
                             AND (ecm55 is not null or ecm55 != ' ')
                             AND ecm012 = g_shh.shh012                          #FUN-A60076  add
                             #bugno:7338 mark
            IF SQLCA.sqlcode # OR SQLCA.sqlerrd[3] = 0
             THEN 
 #              CALL cl_err('ecm55',STATUS,1)
               CALL cl_err3("upd","ecm_file",g_shh_t.shh03,g_shh_t.shh06,STATUS,"","ecm55",1)  #No.FUN-660128
               LET g_success = 'N'   #No.FUN-660128
            END IF
       WHEN '2'
            UPDATE ecm_file SET ecm56 = ' '
                           WHERE ecm01 = g_shh.shh03
                             AND ecm03 = g_shh.shh06
                             AND (ecm56 is not null or ecm56 != ' ')
                             AND ecm012 = g_shh.shh012                          #FUN-A60076  add
                             #bugno:7338 mark
            IF SQLCA.sqlcode # OR SQLCA.sqlerrd[3] = 0
              THEN 
     #         CALL cl_err('ecm56',STATUS,1) 
              CALL cl_err3("upd","ecm_file", g_shh_t.shh03,g_shh_t.shh06,STATUS,"","ecm56",1)  #No.FUN-660128
 
               LET g_success = 'N'   #No.FUN-660128
            END IF
       OTHERWISE LET g_success = 'N'
     END CASE
     }
       #20180523 mark by momo (S)
     LET l_time = TIME
     UPDATE shh_file SET shh14  ='Y',
                        #shh141 = g_user,
                         shh142 = g_today,
                         shh143 = l_time
                     WHERE shh01 = g_shh.shh01
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0
      THEN 
        CALL cl_err('upd shh_file',STATUS,1) #No.FUN-660128
        CALL cl_err3("upd","shh_file",g_shh_t.shh01,"",STATUS,"","",1)  #No.FUN-660128
         LET g_success = 'N'   
     END IF
     IF g_success='N' THEN
        CALL cl_rbmsg(1)
        ROLLBACK WORK
     ELSE
        CALL cl_cmmsg(1)
        ##----- 20180608 計算品質異常成本 (S)
        SELECT qczud10 INTO l_qczud10 FROM qcz_file 
        SELECT SUM(qcp04) INTO l_qcp04 FROM qcp_file WHERE qcp01=g_shh.shh01 AND qcp04 > 0
        LET g_shh.shhud08 = (g_shh.shhud10 + l_qcp04)*l_qczud10
        UPDATE shh_file SET shhud08 = g_shh.shhud08 WHERE shh01=g_shh.shh01
        DISPLAY BY NAME g_shh.shhud08
        ##----- 20180608 計算品質異常成本 (E)
        COMMIT WORK
        CALL cl_flow_notify(g_shh.shh01,'Y')
 
        LET g_shh.shh14 = 'Y'    
        #LET g_shh.shh141=g_user
        LET g_shh.shh142=g_today LET g_shh.shh143= l_time       #FUN-D20059 TIME-->l_time
        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_user
        IF SQLCA.sqlcode THEN  LET l_gen02 = ' ' END IF
        DISPLAY BY NAME g_shh.shh14,g_shh.shh141,g_shh.shh142,g_shh.shh143
        DISPLAY l_gen02 TO FORMONLY.gen02_3
     END IF
END FUNCTION
 
FUNCTION t720_z()
  DEFINE l_gen02 LIKE gen_file.gen02
   DEFINE l_cnt  LIKE type_file.num5             #MOD-530461        #No.FUN-680121 SMALLINT
  DEFINE l_time LIKE type_file.chr8              #FUN-D20059
 
  IF s_shut(0) THEN RETURN END IF
  IF g_shh.shh01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
  END IF
 
   #--No.MOD-530461
  SELECT COUNT(*) INTO l_cnt FROM shh_file
     WHERE shh03 = g_shh.shh03 AND shh06 > g_shh.shh06
 # IF l_cnt > 0 THEN
 #    CALL cl_err('','asf-078',1)
 #    RETURN
 # END IF
 #--end
 
  SELECT * INTO g_shh.* FROM shh_file WHERE shh01 = g_shh.shh01
  IF SQLCA.sqlcode THEN
#    CALL cl_err('sel shh',SQLCA.sqlcode,0)   #No.FUN-660128
     CALL cl_err3("sel","shh_file", g_shh.shh01,"",SQLCA.sqlcode,"","sel shh",1)  #No.FUN-660128
     RETURN
  END IF
  IF g_shh.shh14 ='N' THEN RETURN END IF
  IF g_shh.shh14 ='X' THEN CALL cl_err('','9024',0) RETURN END IF
  IF NOT cl_confirm('axm-109') THEN RETURN END IF
  LET g_success = 'Y'
  BEGIN WORK
        #20180523 mark by momo (S) 
       {
     CASE g_shh.shh08
        WHEN  '1'
            UPDATE ecm_file SET ecm55 = g_shh.shh061
                           WHERE ecm01 = g_shh.shh03
                             AND ecm03 = g_shh.shh06
                             AND ecm012 = g_shh.shh012                          #FUN-A60076  add
                             #bugno:7338 mark
            IF SQLCA.sqlcode # OR SQLCA.sqlerrd[3] = 0
             THEN 
#              CALL cl_err('ecm55',STATUS,1) 
              CALL cl_err3("upd","ecm_file",g_shh_t.shh03,g_shh_t.shh06,STATUS,"","ecm55",1)  #No.FUN-660128
               LET g_success = 'N'   #No.FUN-660128
            END IF
       WHEN '2'
            UPDATE ecm_file SET ecm56 = g_shh.shh061
                           WHERE ecm01 = g_shh.shh03
                             AND ecm03 = g_shh.shh06
                             AND ecm012 = g_shh.shh012                          #FUN-A60076  add
                             #bugno:7338 mark
            IF SQLCA.sqlcode # OR SQLCA.sqlerrd[3] = 0
             THEN 
#              CALL cl_err('ecm56',STATUS,1)#No.FUN-660128
              CALL cl_err3("upd","ecm_file",g_shh_t.shh03,g_shh_t.shh06,STATUS,"","ecm56",1)  #No.FUN-660128
              LET g_success = 'N'   
            END IF
       OTHERWISE LET g_success = 'N'
     END CASE
      }
      #20180523 mark by momo (S)
  #FUN-D20059--str--
  #  UPDATE shh_file SET shh14 ='N',shh141=' ',
  #                      shh142='',shh143=' '     #No:8543,9677
     LET l_time = TIME
     UPDATE shh_file SET shh14 = 'N',
                       # shh141 = g_user,
                         shh142 = g_today,
                         shh143 = l_time
  #FUN-D20059--end--
      WHERE shh01 = g_shh.shh01
 
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err('upd shh_file',STATUS,1)   #No.FUN-660128
        CALL cl_err3("upd","shh_file",g_shh_t.shh01,"",STATUS,"","upd shh_file",1)  #No.FUN-660128
        LET g_success = 'N'
     END IF
 
     IF g_success='N' THEN
        CALL cl_rbmsg(1)
        ROLLBACK WORK
     ELSE
        CALL cl_cmmsg(1)
        COMMIT WORK
       #bugno:7338 modify g_shh.shh14 = 'N'
    #FUN-D20059--str--
    #   LET g_shh.shh14 = 'N'    LET g_shh.shh141=' '
    #   LET g_shh.shh142= ''     LET g_shh.shh143=' '   #No:8543,9677
        LET g_shh.shh14 = 'N'         #LET g_shh.shh141 = g_user
        LET g_shh.shh142 = g_today     LET g_shh.shh143 = l_time   
    #FUN-D20059--end--
        DISPLAY BY NAME g_shh.shh14,g_shh.shh141,g_shh.shh142,g_shh.shh143
    #FUN-D20059--str--
        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_user
        IF SQLCA.sqlcode THEN  LET l_gen02 = ' ' END IF
   #    LET l_gen02 = ' '   #FUN-D20059
     #FUN-D20059--end--
        DISPLAY l_gen02 TO FORMONLY.gen02_3
     END IF
 
END FUNCTION
 
FUNCTION t720_1()
   IF s_shut(0) THEN RETURN END IF
   IF g_shh.shh01 IS NULL THEN
     CALL cl_err('',-400,0)
     RETURN
   END IF
   LET g_success ='Y'
   SELECT * INTO g_shh.* FROM shh_file WHERE shh01 = g_shh.shh01
 
   OPEN WINDOW t720_1_w AT 12,2
        WITH FORM "asf/42f/asft7201"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("asft7201")
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t720_1_w RETURN END IF
   DISPLAY BY NAME g_shh.shh161,g_shh.shh162,g_shh.shh163,g_shh.shh164,g_shh.shh165,
                   g_shh.shh171,g_shh.shh172,g_shh.shh173,g_shh.shh174,g_shh.shh175
   INPUT BY NAME g_shh.shh161,g_shh.shh162,g_shh.shh163,g_shh.shh164,g_shh.shh165,
                 g_shh.shh171,g_shh.shh172,g_shh.shh173,g_shh.shh174,g_shh.shh175
                 WITHOUT DEFAULTS
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t720_1_w RETURN END IF
   UPDATE shh_file SET shh161 = g_shh.shh161,shh162= g_shh.shh162,
                       shh163 = g_shh.shh163,shh164= g_shh.shh164,
                       shh165 = g_shh.shh165,shh171= g_shh.shh171,
                       shh172 = g_shh.shh172,shh173= g_shh.shh173,
                       shh174 = g_shh.shh174,shh175= g_shh.shh175
         WHERE shh01 = g_shh.shh01
   IF SQLCA.sqlcode THEN LET g_success ='N'
 #        CALL cl_err('t720_1',STATUS,1)  #No.FUN-660128
         CALL cl_err3("upd","shh_file",g_shh_t.shh01,"",STATUS,"","t720_1",1)   #No.FUN-660128
   END IF
   IF g_success ='Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
#  CALL cl_end(0,0)
   CLOSE WINDOW t720_1_w
   RETURN
END FUNCTION
 
#FUNCTION t720_x()  #CHI-D20010
FUNCTION t720_x(p_type)  #CHI-D20010
DEFINE l_flag  LIKE type_file.chr1  #CHI-D20010
DEFINE p_type  LIKE type_file.chr1  #CHI-D20010
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_shh.shh01) THEN CALL cl_err('',-400,0) RETURN END IF   #MOD-660086 add
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_shh.shh14 ='X' THEN RETURN END IF
   ELSE
      IF g_shh.shh14 <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t720_cl USING g_shh.shh01
 
   IF STATUS THEN
      CALL cl_err("OPEN t720_cl:", STATUS, 1)
      CLOSE t720_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t720_cl INTO g_shh.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t720_cl ROLLBACK WORK RETURN
   END IF
   IF cl_null(g_shh.shh01) THEN CALL cl_err('',-400,0) RETURN END IF
   #-->confirm不可void
   IF g_shh.shh14 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_shh.shh14 = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010 
   #FUN-D40032--add--str--
   IF g_shh.shh14 ='X' AND NOT cl_null(g_sma.sma53) AND g_shh.shh02 <= g_sma.sma53 THEN
      CALL cl_err('','alm1393',0)
      RETURN
   END IF
   #FUN-D40032--add--end--
   ##---- 20180612 增加作廢原因 (S)
   IF cl_null(g_shh.shhud03) AND p_type=1 THEN
      CALL cl_err(g_shh.shhud03,'cqc-001',1)
      RETURN
   END IF
   ##---- 20180612 增加作廢原因 (E)
  # Prog. Version..: '5.30.24-17.04.13(0,0,g_shh.shh14)   THEN #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN #CHI-D20010
        LET g_chr=g_shh.shh14
       #IF g_shh.shh14='N' THEN #CHI-D20010
        IF p_type=1 THEN        #CHI-D20010
            LET g_shh.shh14='X'
        ELSE
            LET g_shh.shh14='N'
        END IF
        UPDATE shh_file
            SET shh14=g_shh.shh14,
                shhmodu=g_user,
                shhdate=g_today
            WHERE shh01  =g_shh.shh01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_shh.shh14,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","shh_file",g_shh_t.shh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            LET g_shh.shh14=g_chr
        END IF
        DISPLAY BY NAME g_shh.shh14
   END IF
 
   CLOSE t720_cl
   COMMIT WORK
   CALL cl_flow_notify(g_shh.shh01,'V')
 
END FUNCTION
 
FUNCTION t720_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("shh01",TRUE)
   END IF
   CALL cl_set_comp_entry("shh012,shh05,shh06",FALSE)     #TQC-AC0289
END FUNCTION
 
FUNCTION t720_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("shh01",FALSE)
   END IF
  #TQC-AC0289 ---------------add start--------
   IF g_sma.sma541 = 'Y' THEN
      CALL cl_set_comp_entry("shh012,shh06",TRUE)
   ELSE
      CALL cl_set_comp_entry("shh05",TRUE)
   END IF  
  #TQC-AC0289 ---------------add end---------------
END FUNCTION

##---- 20180601 (S)
#單身
FUNCTION t720_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT   #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,         #檢查重複用      #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否      #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,         #可新增否        #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5          #可刪除否        #No.FUN-680136 SMALLINT
DEFINE l_gfe02      LIKE gfe_file.gfe02
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_shh.shh01 IS NULL  THEN
        RETURN
    END IF
    IF g_shh.shh14 <> 'N' THEN CALL cl_err('','9022',0) RETURN END IF #FUN-BB0153 add
 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql =
       "SELECT qcp02,qcp06,'',qcp03,qcp04,qcp05, ",    #No:MOD-960239 modify
       #No.FUN-840068 --start--
       "       qcpud01,qcpud02,qcpud03,qcpud04,qcpud05,",
       "       qcpud06,qcpud07,qcpud08,qcpud09,qcpud10,",
       "       qcpud11,qcpud12,qcpud13,qcpud14,qcpud15 ", 
       #No.FUN-840068 ---end---
       "FROM qcp_file ",
       " WHERE qcp01 = ?  ",
       "  AND qcp02 = ? ",
       "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t720_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_qcp WITHOUT DEFAULTS FROM s_qcp.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_qcp_t.* = g_qcp[l_ac].*  #BACKUP
                BEGIN WORK
                OPEN t720_bcl USING g_shh.shh01,g_qcp_t.qcp02
                IF STATUS THEN
                    CALL cl_err("OPEN t720_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t720_bcl INTO g_qcp[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_qcp_t.qcp04,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        SELECT qce03 INTO g_qcp[l_ac].qce03 FROM qce_file
                         WHERE qce01= g_qcp[l_ac].qcp06
                        LET g_qcp_t.*=g_qcp[l_ac].*
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO qcp_file(qcp01,qcp02,qcp03,qcp04,qcp05,qcp06,
                                 #FUN-840068 --start--
                                 qcpud01,qcpud02,qcpud03,qcpud04,qcpud05,qcpud06,
                                 qcpud07,qcpud08,qcpud09,qcpud10,qcpud11,qcpud12,
                                 qcpud13,qcpud14,qcpud15,
                                 qcpplant,qcplegal)  #FUN-980007
                                 #FUN-840068 --end--
                          VALUES(g_shh.shh01,g_qcp[l_ac].qcp02,g_qcp[l_ac].qcp03,
                                 g_qcp[l_ac].qcp04,g_qcp[l_ac].qcp05,g_qcp[l_ac].qcp06,
                                 #FUN-840068 --start--
                                 g_qcp[l_ac].qcpud01,g_qcp[l_ac].qcpud02,
                                 g_qcp[l_ac].qcpud03,g_qcp[l_ac].qcpud04,
                                 g_qcp[l_ac].qcpud05,g_qcp[l_ac].qcpud06,
                                 g_qcp[l_ac].qcpud07,g_qcp[l_ac].qcpud08,
                                 g_qcp[l_ac].qcpud09,g_qcp[l_ac].qcpud10,
                                 g_qcp[l_ac].qcpud11,g_qcp[l_ac].qcpud12,
                                 g_qcp[l_ac].qcpud13,g_qcp[l_ac].qcpud14,
                                 g_qcp[l_ac].qcpud15,
                                 g_plant,    g_legal) #FUN-980007
                                 #FUN-840068 --end--
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","qcp_file",g_shh.shh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qcp[l_ac].* TO NULL      #900423
            LET g_qcp_t.* = g_qcp[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD qcp02
 
        BEFORE FIELD qcp02                        # dgeeault 序號
            IF g_qcp[l_ac].qcp02 IS NULL or g_qcp[l_ac].qcp02 = 0 THEN
                SELECT max(qcp02)+1 INTO g_qcp[l_ac].qcp02 FROM qcp_file
                    WHERE qcp01 = g_shh.shh01 
                IF g_qcp[l_ac].qcp02 IS NULL THEN
                    LET g_qcp[l_ac].qcp02 = 1
                END IF
            END IF
 
        AFTER FIELD qcp02                        #check 序號是否重複
            IF g_qcp[l_ac].qcp02 IS NOT NULL AND
               (g_qcp[l_ac].qcp02 != g_qcp_t.qcp02 OR
                g_qcp_t.qcp02 IS NULL) THEN
                SELECT count(*) INTO l_n FROM qcp_file
                 WHERE qcp01 = g_shh.shh01 AND qcp02 = g_qcp[l_ac].qcp02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_qcp[l_ac].qcp02 = g_qcp_t.qcp02
                   NEXT FIELD qcp02
                END IF
            END IF

         ------#MOD-BB0306 start---------
      
      AFTER FIELD qcp04
          IF NOT cl_null(g_qcp[l_ac].qcp04) AND g_qcp[l_ac].qcp04 < 0 THEN
             CALL cl_err('','aqc-090',0)
             NEXT FIELD qcp04
          END IF

         ------#MOD-BB0306 end----------
 
        AFTER FIELD qcp06
            IF NOT cl_null(g_qcp[l_ac].qcp06) THEN
               #SELECT sgb05 INTO g_qcp[l_ac].sgb05 FROM sgb_file
               # WHERE sgb01= g_qcp[l_ac].qcp06
               SELECT qce03 INTO g_qcp[l_ac].qce03 FROM qce_file
                WHERE qce01= g_qcp[l_ac].qcp06
               IF STATUS THEN
                  CALL cl_err3("sel","qce_file",g_qcp[l_ac].qcp06,"","aoo-018","","",1)  #No.FUN-660128
                  LET g_qcp[l_ac].qcp06 = ''
                  NEXT FIELD qcp06
               ELSE
                  DISPLAY BY NAME g_qcp[l_ac].qce03
               END IF
            END IF
           
        #No.FUN-840068 --start--
        AFTER FIELD qcpud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_qcp_t.qcp02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM qcp_file
                 WHERE qcp01 = g_shh.shh01 AND qcp02 = g_qcp_t.qcp02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","qcp_file",g_shh.shh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_qcp[l_ac].* = g_qcp_t.*
               CLOSE t720_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_qcp[l_ac].qcp03,-263,1)
               LET g_qcp[l_ac].* = g_qcp_t.*
            ELSE
                UPDATE qcp_file SET
                       qcp02 = g_qcp[l_ac].qcp02,
                       qcp03 = g_qcp[l_ac].qcp03,
                       qcp04 = g_qcp[l_ac].qcp04,
                       qcp05 = g_qcp[l_ac].qcp05,
                       qcp06 = g_qcp[l_ac].qcp06,
                       #FUN-840068 --start--
                       qcpud01 = g_qcp[l_ac].qcpud01,
                       qcpud02 = g_qcp[l_ac].qcpud02,
                       qcpud03 = g_qcp[l_ac].qcpud03,
                       qcpud04 = g_qcp[l_ac].qcpud04,
                       qcpud05 = g_qcp[l_ac].qcpud05,
                       qcpud06 = g_qcp[l_ac].qcpud06,
                       qcpud07 = g_qcp[l_ac].qcpud07,
                       qcpud08 = g_qcp[l_ac].qcpud08,
                       qcpud09 = g_qcp[l_ac].qcpud09,
                       qcpud10 = g_qcp[l_ac].qcpud10,
                       qcpud11 = g_qcp[l_ac].qcpud11,
                       qcpud12 = g_qcp[l_ac].qcpud12,
                       qcpud13 = g_qcp[l_ac].qcpud13,
                       qcpud14 = g_qcp[l_ac].qcpud14,
                       qcpud15 = g_qcp[l_ac].qcpud15
                       #FUN-840068 --end-- 
                 WHERE qcp01 = g_shh.shh01
                   AND qcp02 = g_qcp_t.qcp02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","qcp_file",g_shh.shh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    LET g_qcp[l_ac].* = g_qcp_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac   #FUN-D30034
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qcp[l_ac].* = g_qcp_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_qcp.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE t720_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034
            CLOSE t720_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qcp02) AND l_ac > 1 THEN
                LET g_qcp[l_ac].* = g_qcp[l_ac-1].*
                DISPLAY g_qcp[l_ac].* TO s_qcp[l_ac].*
                NEXT FIELD qcp02
            END IF
 
        ON ACTION controlp
            CASE WHEN INFIELD(qcp06)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_qce"
                      LET g_qryparam.default1 = g_qcp[l_ac].qcp06
                      CALL cl_create_qry() RETURNING g_qcp[l_ac].qcp06
                      DISPLAY BY NAME g_qcp[l_ac].qcp06
                      NEXT FIELD qcp06
                 WHEN INFIELD(qcpud03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "cq_gen10"
                      LET g_qryparam.default1 = g_qcp[l_ac].qcpud03
                      CALL cl_create_qry() RETURNING g_qcp[l_ac].qcpud03,g_qcp[l_ac].qcpud04
                      DISPLAY BY NAME g_qcp[l_ac].qcpud03,g_qcp[l_ac].qcpud04
                      NEXT FIELD qcpud03
                 WHEN INFIELD(qcpud04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "cq_gem"
                      LET g_qryparam.default1 = g_qcp[l_ac].qcpud04
                      CALL cl_create_qry() RETURNING g_qcp[l_ac].qcpud04
                      DISPLAY BY NAME g_qcp[l_ac].qcpud04
                      NEXT FIELD qcpud04
             END CASE
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
        END INPUT
 
    CLOSE t720_bcl
    COMMIT WORK
END FUNCTION

FUNCTION t720_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2         LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    LET g_sql =
        "SELECT qcp02,qcp06,'',qcp03,qcp04,qcp05, ",
        #No.FUN-840068 --start--
        "       qcpud01,qcpud02,qcpud03,qcpud04,qcpud05,",
        "       qcpud06,qcpud07,qcpud08,qcpud09,qcpud10,",
        "       qcpud11,qcpud12,qcpud13,qcpud14,qcpud15", 
        #No.FUN-840068 ---end---
        " FROM qcp_file",
        " WHERE qcp01 ='",g_shh.shh01,"'",  #單頭-1
        " AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE t720_pb FROM g_sql
    DECLARE qcp_cs                       #CURSOR
        CURSOR FOR t720_pb
 
    CALL g_qcp.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH qcp_cs INTO g_qcp[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT qce03 INTO g_qcp[g_cnt].qce03 FROM qce_file
         WHERE qce01= g_qcp[g_cnt].qcp06
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_qcp.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t720_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)

   #DISPLAY ARRAY g_qcp TO s_qcp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
   DISPLAY ARRAY g_qcp TO s_qcp.*
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

   END DISPLAY 

      #20180709---add---str---
      ON ACTION page_list
         LET g_action_flag = "page_list"  
         #EXIT DISPLAY
          EXIT DIALOG
      #20180709---add---end---
 
      ON ACTION insert
         LET g_action_choice="insert"
         #EXIT DISPLAY
          EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         #EXIT DISPLAY
          EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         #EXIT DISPLAY
          EXIT DIALOG
#FUN-BB0153---begin add         
      ON ACTION delete
         LET g_action_choice="delete"
         #EXIT DISPLAY
          EXIT DIALOG
      ##---- 20180614 add (S)
      #@ ON ACTION 結案
      ON ACTION finish
         LET g_action_choice="finish"
         #EXIT DISPLAY
          EXIT DIALOG
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         #EXIT DISPLAY    
          EXIT DIALOG     
      #FUN-D20025--add--str-- 
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         #EXIT DISPLAY      
          EXIT DIALOG   
      #FUN-D20025--add--end-- 
#FUN-BB0153---end add         
      ON ACTION first
         CALL t720_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           #ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
           ACCEPT DIALOG
      ON ACTION previous
         CALL t720_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	 #ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
           ACCEPT DIALOG
      ON ACTION jump
         CALL t720_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	 #ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
           ACCEPT DIALOG
      ON ACTION next
         CALL t720_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	 #ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
           ACCEPT DIALOG
 
 
      ON ACTION last
         CALL t720_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	 #ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
           ACCEPT DIALOG
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         #EXIT DISPLAY
         EXIT DIALOG
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         #EXIT DISPLAY
         EXIT DIALOG
      ON ACTION output
         LET g_action_choice="output"
         LET g_msg=' shh01= "',g_shh.shh01,'"'  #TQC-630013
                LET g_msg="asfr720 ",  #FUN-C30085 mark    #TQC-E80015 mark   
                         "'",g_today,"'",
                         " ''",
                         " '",g_lang,"'",
                         " 'Y' ",
                         " ' ' ",
                         " '1'",
                         " '",g_msg,"'"
               CALL cl_cmdrun(g_msg)
         #EXIT DISPLAY
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_field_pic(g_shh.shh14,"","","",g_chr,"") #FUN-BB0153    
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         #EXIT DISPLAY
         EXIT DIALOG
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         #EXIT DISPLAY
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         #EXIT DISPLAY
         EXIT DIALOG
  
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE DISPLAY
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
         EXIT DIALOG
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         #EXIT DISPLAY
         EXIT DIALOG
  
      # No.FUN-530067 --start--
      #AFTER DISPLAY
      #   CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
      #No.FUN-7C0050 add
      #&include "qry_string.4gl"
   #END DISPLAY
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
##---- 20180601 (E)

##---- 20180614 結案/反結案
FUNCTION t720_close()  #CHI-D20010
DEFINE l_flag  LIKE type_file.chr1  #CHI-D20010
DEFINE p_type  LIKE type_file.chr1  #CHI-D20010
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_shh.shh01) THEN CALL cl_err('',-400,0) RETURN END IF   #MOD-660086 add
   IF cl_null(g_shh.shh141) THEN CALL cl_err('','cqc-003',1) RETURN END IF #2080615 
 
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t720_cl USING g_shh.shh01
 
   IF STATUS THEN
      CALL cl_err("OPEN t720_cl1:", STATUS, 1)
      CLOSE t720_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t720_cl INTO g_shh.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t720_cl ROLLBACK WORK RETURN
   END IF
   IF cl_null(g_shh.shh01) THEN CALL cl_err('',-400,0) RETURN END IF
   #-->confirm不可void
   IF g_shh.shh14 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF g_shh.shh14 = 'N' THEN CALL cl_err('',9026,0) RETURN END IF


  # Prog. Version..: '5.30.24-17.04.13(0,0,g_shh.shh14)   THEN #CHI-D20010
     
       IF g_shh.shh14='Y' THEN #CHI-D20010 
        UPDATE shh_file
            SET shh14='C',
                shhmodu=g_user,
                shhdate=g_today
            WHERE shh01  =g_shh.shh01
        LET g_shh.shh14='C'
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("close","shh_file",g_shh_t.shh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            LET g_shh.shh14='Y'
        END IF
        DISPLAY BY NAME g_shh.shh14
       ELSE
        UPDATE shh_file
            SET shh14='Y',
                shhmodu=g_user,
                shhdate=g_today
            WHERE shh01  =g_shh.shh01
        LET g_shh.shh14='Y'
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("close","shh_file",g_shh_t.shh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            LET g_shh.shh14='C'
        END IF
        DISPLAY BY NAME g_shh.shh14
       END IF
 
   CLOSE t720_cl
   COMMIT WORK
   CALL cl_flow_notify(g_shh.shh01,'V')
 
END FUNCTION

#20180709---add---str---
FUNCTION t720_list_fill()
  DEFINE l_shh01         LIKE shh_file.shh01
  DEFINE l_i             LIKE type_file.num10

    CALL g_shh_l.clear()
    LET l_i = 1
  
    FOREACH t720_cs INTO l_shh01      #MOD-E10113 add
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       #SELECT shh02,shh01,ta_sfb01,oea032,a.ima021,oeb15,shhud02,     #20180720 mark
        SELECT shh02,shh01,ta_sfb01,oea032,a.ima021,sfb15,shhud02,     #20180720 modify
              b.ima02,shh112,shhud07,shh022,shhud08,shh14,0            #20180716 add 0 #20190107 add
         INTO g_shh_l[l_i].*
         FROM shh_file
              LEFT OUTER JOIN sfb_file   ON shh03=sfb01
              LEFT OUTER JOIN oea_file   ON oea01=SUBSTR(ta_sfb01,1,15)
              LEFT OUTER JOIN ima_file a ON sfb05=a.ima01
              LEFT OUTER JOIN oeb_file   ON oea01=oeb01 AND LPAD(oeb03,3,'0') = SUBSTR(ta_sfb01,16,18)
              LEFT OUTER JOIN ima_file b ON shhud02=b.ima01
        WHERE shh01=l_shh01
          
       SELECT COUNT(qcpud04) INTO g_shh_l[l_i].shh06 
         FROM qcp_file
        WHERE qcp01=g_shh_l[l_i].shh01

       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN  
            CALL cl_err( '', 9035, 0 )
          END IF                             
          EXIT FOREACH
       END IF
    END FOREACH
    OPEN t720_cs                      #MOD-E10113 add
    LET g_rec_b4 = l_i - 1
    DISPLAY g_rec_b4 TO FORMONLY.cnt  #MOD-E10113 add
    DISPLAY ARRAY g_shh_l TO s_shh_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION

FUNCTION t720_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   


   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_shh_l TO s_shh_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)                                     #FUN-B90101---Add---
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
             CALL t720_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("info", TRUE)
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE
         CALL t720_fetch('/')
         CALL cl_set_comp_visible("info", FALSE)
         CALL cl_set_comp_visible("info", TRUE)
         CALL cl_set_comp_visible("page_list", FALSE) 
         CALL ui.interface.refresh()                 
         CALL cl_set_comp_visible("page_list", TRUE)    
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
         CALL t720_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(g_curs_index)
         ACCEPT DISPLAY 
 
      ON ACTION previous
         CALL t720_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         CALL fgl_set_arr_curr(g_curs_index)
         ACCEPT DISPLAY   
 
      ON ACTION jump
         CALL t720_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(g_curs_index)
         ACCEPT DISPLAY   
 
      ON ACTION next
         CALL t720_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         CALL fgl_set_arr_curr(g_curs_index)
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL t720_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         CALL fgl_set_arr_curr(g_curs_index)
         ACCEPT DISPLAY  
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      #TQC-D10084--mark--str--
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY
      #TQC-D10084--mark--end--
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
         EXIT DISPLAY
 

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

   
 
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
#FUN-D20025 add
    #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
#FUN-D20025 add         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
     
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY

   
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG = TRUE
         LET g_action_choice = "exit"
         EXIT DISPLAY          
   END DISPLAY       

   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#20180709---add---end---
 

