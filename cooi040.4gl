# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cooi040.4gl
# Descriptions...: 多營運中心員工資料
# Date & Author..: 91/06/21 By Lee
# Modify.........: MOD-470515 04/10/05 Nicola 加入"相關文件"功能
#                  FUN-4B0020 04/11/03 Nicola 加入"轉EXCEL"功能
#                  FUN-510027 05/01/13 pengu  報表轉XML
#                  FUN-560004 05/06/03 alex 加多語系顯示更新等功能記為550077
# Modify.........: FUN-570110 05/07/13 vivien KEY值更改控制 
# Modify.........: FUN-570199 05/08/03 Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: MOD-580154 05/08/19 CoCo PAGE LENGTH改為 g_page_line
#                  FUN-580036 05/10/28 alex 修正錯誤訊息,多語編輯方法
# Modify.........: FUN-580031 06/01/06 By saki QBE查詢條件紀錄
# Modify.........: TQC-5C0079 06/02/09 alex 修正多語言資料顯示問題
# Modify.........: FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: FUN-680010 06/08/05 By Joe SPC整合專案-基本資料傳遞
# Modify.........: No.FUN-680102 06/09/13 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-680158 06/11/14 By pengu 勾選aoos010中"隱藏無權限的功能按鍵"，執行程式時沒友執行權限的action未disable 
# Modify.........: No.TQC-6B0103 06/11/20 By alexstar 做 'R' delete 時,相關多語言檔(gbc_file)需要一併處理
# Modify.........: No.TQC-6C0060 07/01/08 By alexstar 多語言功能單純化
# Modify.........: No.TQC-710076 07/03/06 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-760083 07/07/05 By mike 報表格式修改為crystal reports
# Modify.........: NO.FUN-860036 08/06/17 by kim  MDM整合 for GP5.1
# Modify.........: No.FUN-870067 08/07/14 By douzh 新增匯豐銀行接口新增員工銀行信息按鈕
# Modify.........: No.FUN-870166 08/09/02 By kevin MDM整合call aws_mdmdata
# Modify.........: No.FUN-890113 08/10/27 By kevin 移除刪除功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30030 10/03/10 By Cockroach ADD POS? 
# Modify.........: No.FUN-A30097 10/03/29 by huangrh add gen07
# Modify.........: No.FUN-A80148 10/08/31 by shaoyong 新增 gen08(行動電話) 欄位. 並在開啟時接收參數, 來限制查詢資料的範圍.
# Modify.........: No.FUN-AA0064 10/10/24 by johnson 同步到32區
# Modify.........: No.MOD-B20155 11/03/03 by baogc 修改資料重複的報錯信息
# Modify.........: No.FUN-B40071 11/04/27 by jason 已傳POS否狀態調整
# Modify.........: No.MOD-B70261 11/07/28 by sabrina 將gen_bank_inf action刪除
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.MOD-C70070 12/07/06 By Elise 判斷參數未勾選就不自動帶出多語系名稱維護
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:CHI-FA0015 15/10/19 By catmoon 取消查詢時LET g_rec_b = 0

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE
    tm              RECORD
     azp01          LIKE azp_file.azp01,
     zo05           LIKE zo_file.zo05,
     zo09           LIKE zo_file.zo09
                    END RECORD, 
     g_gen           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gen01       LIKE gen_file.gen01,   #員工編號
        gen02       LIKE gen_file.gen02,   #員工姓名
        gen03       LIKE gen_file.gen03,   #部門編號
        gem02       LIKE gem_file.gem02,   #部門名稱
        gen04       LIKE gen_file.gen04,   #職稱
        gen06       LIKE gen_file.gen06,   #Mail
        gen05       LIKE gen_file.gen05,   #分機
        gen08       LIKE gen_file.gen08,   #FUN-A80148--add--
        genacti     LIKE gen_file.genacti,   #No.FUN-680102 VARCHAR(1) 
        genmodu     LIKE gen_file.genmodu,
        gendate     LIKE gen_file.gendate
                    END RECORD,
    g_gen_t         RECORD                 #程式變數 (舊值)
        gen01       LIKE gen_file.gen01,   #員工編號
        gen02       LIKE gen_file.gen02,   #員工姓名
        gen03       LIKE gen_file.gen03,   #部門編號
        gem02       LIKE gem_file.gem02,   #部門名稱
        gen04       LIKE gen_file.gen04,   #職稱
        gen06       LIKE gen_file.gen06,   #Mail
        gen05       LIKE gen_file.gen05,   #分機
        gen08       LIKE gen_file.gen08,   #FUN-A80148--add--
        genacti     LIKE gen_file.genacti,    #No.FUN-680102 VARCHAR(1) 
        genmodu     LIKE gen_file.genmodu,
        gendate     LIKE gen_file.gendate
                    END RECORD,
    g_wc2           STRING,
    g_wc            STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, #No.FUN-680102 VARCHAR(80)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680102 INTEGER
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110  #No.FUN-680102 SMALLINT
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-680102 SMALLINT
DEFINE g_on_change  LIKE type_file.num5      #No.FUN-680102 SMALLINT   #FUN-550077
DEFINE g_row_count  LIKE type_file.num5       #No.TQC-680158 add
DEFINE g_curs_index LIKE type_file.num5       #No.TQC-680158 add
DEFINE g_str        STRING                    #No.FUN-760083     
DEFINE l_n          LIKE type_file.num5

MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0081
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680102 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i040_w AT p_row,p_col WITH FORM "coo/42f/cooi040"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
  #FUN-A30030 ADD-------------------------
   IF g_aza.aza88='Y' THEN
      CALL cl_set_comp_visible('genpos',TRUE)
   ELSE
      CALL cl_set_comp_visible('genpos',FALSE)
   END IF
  #FUN-A30030 END------------------------
    CALL cl_ui_init()
    LET g_wc2 = " genacti='Y' "
    LET tm.azp01 = g_plant
     
    DISPLAY tm.azp01 TO azp01
    CALL i040_b_fill(g_wc2)
    CALL i040_menu()
    CLOSE WINDOW i040_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i040_menu()
 
   WHILE TRUE
      CALL i040_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i040_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i040_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i040_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gen),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i040_q()
   CALL i040_b_askkey()
END FUNCTION
 
FUNCTION i040_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT      #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用             #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否             #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態               #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 # Prog. Version..: '5.30.24-17.04.13(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1,                 # Prog. Version..: '5.30.24-17.04.13(01),              #可刪除否
    v               string
 
    
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
   # LET l_allow_insert = cl_detail_input_auth('insert')
   # LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT gen01,gen02,gen03,'',gen04,gen06,gen05,gen08,genacti,genmodu,gendate ",  #FUN-A30030 ADD POS#FUN-A30097 #FUN-A80148--mod--
                       "  FROM ",cl_get_target_table(tm.azp01,'gen_file'),
                       " WHERE gen01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i040_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_gen WITHOUT DEFAULTS FROM s_gen.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF

       IF g_plant <> tm.azp01 THEN
          CALL cl_err('','apm-012',1)
          EXIT INPUT
       END IF
     
       IF tm.azp01 = 'TY' THEN 
       IF (g_grup[1,3] <> g_gen[l_ac].gen03[1,3]) THEN
          CALL cl_err('','coo-001',1)
          EXIT INPUT
       END IF
       END IF
 
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
        LET g_on_change = TRUE         #FUN-550077
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                      
           CALL i040_set_entry(p_cmd)                                           
           CALL i040_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end              
           LET g_gen_t.* = g_gen[l_ac].*  #BACKUP
           OPEN i040_bcl USING g_gen_t.gen01
           IF STATUS THEN
              CALL cl_err("OPEN i040_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i040_bcl INTO g_gen[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_gen_t.gen01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           SELECT gem02  INTO g_gen[l_ac].gem02 FROM gem_file
            WHERE g_gen[l_ac].gen03 = gem01
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                        
         CALL i040_set_entry(p_cmd)                                             
         CALL i040_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
         INITIALIZE g_gen[l_ac].* TO NULL      #900423
         LET g_gen[l_ac].genacti = 'Y'       #Body default
         LET g_gen_t.* = g_gen[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gen01
 
     AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i040_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO gen_file(gen01,gen02,gen03,gen04,gen05,                          #FUN-A30097
#                    gen06,genacti,genpos,genuser,gendate,genoriu,genorig)                 #FUN-A30030 ADD POS  #FUN-A80148--mark--
                     gen06,gen08,genacti,genuser,gendate,genoriu,genorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_gen[l_ac].gen01,g_gen[l_ac].gen02,
               g_gen[l_ac].gen03,g_gen[l_ac].gen04,                      #FUN-A30097
#              g_gen[l_ac].gen05,g_gen[l_ac].gen06,                                        #FUN-A80148--mark--
               g_gen[l_ac].gen05,g_gen[l_ac].gen06,g_gen[l_ac].gen08,                      #FUN-A80148--mod-- 
               g_gen[l_ac].genacti,g_user,g_today, g_user, g_grup) #FUN-A30030 ADD POS   #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_gen[l_ac].gen01,SQLCA.sqlcode,0)   #No.FUN-660131
           CALL cl_err3("ins","gen_file",g_gen[l_ac].gen01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE
 
           COMMIT WORK 
           ##FUN-680010 
 
        END IF
 
     AFTER FIELD gen01                        #check 編號是否重複
        IF NOT cl_null(g_gen[l_ac].gen01) THEN
           IF g_gen[l_ac].gen01 != g_gen_t.gen01 OR
              g_gen_t.gen01 IS NULL THEN
              SELECT count(*) INTO l_n FROM gen_file
               WHERE gen01 = g_gen[l_ac].gen01
              IF l_n > 0 THEN
                  LET g_gen[l_ac].gen01 = g_gen_t.gen01
                  NEXT FIELD gen01
              END IF
           END IF
        END IF
 
     ON CHANGE gen02   # FUN-550077
        IF g_aza.aza44 = "Y" THEN 
           CALL cl_show_fld_cont()   #TQC-6C0060
        END IF
 
     AFTER FIELD gen03
       IF NOT cl_null(g_gen[l_ac].gen03) THEN
       END IF 
 
     AFTER FIELD genacti
        IF NOT cl_null(g_gen[l_ac].genacti) THEN
           IF g_gen[l_ac].genacti NOT MATCHES '[YN]' THEN 
              LET g_gen[l_ac].genacti = g_gen_t.genacti
              NEXT FIELD genacti
           END IF
        END IF
 
     BEFORE DELETE                            #是否取消單身
         IF g_gen_t.gen01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "gen01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_gen[l_ac].gen01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE 
            END IF 
            #TQC-6B0103---start---
            IF (NOT cl_del_itemname("gen_file","gen02", g_gen_t.gen01)) THEN 
               ROLLBACK WORK
               RETURN
            END IF
            #TQC-6B0103---end---
            DELETE FROM gen_file WHERE gen01 = g_gen_t.gen01
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_gen_t.gen01,SQLCA.sqlcode,0)   #No.FUN-660131
                CALL cl_err3("del","gen_file",g_gen_t.gen01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                ROLLBACK WORK      #FUN-680010
                CANCEL DELETE
                EXIT INPUT
            END IF
 
            
 
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_gen[l_ac].* = g_gen_t.*
          CLOSE i040_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF

        IF l_lock_sw="Y" THEN
           CALL cl_err(g_gen[l_ac].gen01,-263,0)
           LET g_gen[l_ac].* = g_gen_t.*
        ELSE
           UPDATE gen_file 
              SET
                               gen05=g_gen[l_ac].gen05,
                               gen08=g_gen[l_ac].gen08,     #FUN-A80148--add--
                               genmodu=g_user,
                               gendate=g_today
           WHERE gen01 = g_gen_t.gen01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","gen_file",g_gen_t.gen01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK    #FUN-680010
              LET g_gen[l_ac].* = g_gen_t.*
           ELSE
 
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()            # 新增
       #LET l_ac_t = l_ac                # 新增   #FUN-D40030 Mark
 
        IF INT_FLAG THEN                 #900423
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_gen[l_ac].* = g_gen_t.*
           #FUN-D40030--add--str--
           ELSE
              CALL g_gen.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D40030--add--end--
           END IF
           CLOSE i040_bcl                # 新增
           ROLLBACK WORK                 # 新增
           EXIT INPUT
         END IF
         LET l_ac_t = l_ac                       #FUN-D40030 Add
         CLOSE i040_bcl                # 新增
         COMMIT WORK
 
   # ON ACTION CONTROLN
   #     CALL i040_b_askkey()
   #     EXIT INPUT
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gen01) AND l_ac > 1 THEN
             LET g_gen[l_ac].* = g_gen[l_ac-1].*
             NEXT FIELD gen01
         END IF
 
       ON ACTION controlp
           CASE 
             WHEN INFIELD(gen03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem"
                     LET g_qryparam.default1 = g_gen[l_ac].gen03
                     CALL cl_create_qry() RETURNING g_gen[l_ac].gen03
                     DISPLAY g_gen[l_ac].gen03 TO gen03
#                    CALL FGL_DIALOG_SETBUFFER(g_gen[l_ac].gen03 )
                OTHERWISE
                     EXIT CASE
            END CASE
 
     ON ACTION CONTROLR
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
 
#    #FUN-550077

    END INPUT
 
    CLOSE i040_bcl
    COMMIT WORK
END FUNCTION

 
 
FUNCTION i040_b_askkey()
    CLEAR FORM
    CALL g_gen.clear()


    INPUT BY NAME tm.azp01 WITHOUT DEFAULTS


    AFTER FIELD azp01
      IF NOT cl_null(tm.azp01) THEN
         SELECT count(azp01) INTO l_n FROM azp_file
          WHERE azp01 = tm.azp01
         IF l_n = 0 THEN
            CALL cl_err(tm.azp01,'aap-025',0)
            NEXT FIELD azp01
         END IF
      END IF

    ON ACTION controlp
       CASE
         WHEN INFIELD(azp01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_azp01"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              LET tm.azp01 = g_qryparam.multiret
              DISPLAY BY NAME tm.azp01
              NEXT FIELD azp01
              OTHERWISE
              EXIT CASE
        END CASE

    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT

    END INPUT
      IF INT_FLAG THEN
         RETURN
      END IF
 
#FUN-A80148--begin--
    CONSTRUCT g_wc2 ON gen01,gen02,gen03,gen04,gen06,gen05,gen08,genacti                        #FUN-A30030 ADD  pos#FUN-A30097
         FROM s_gen[1].gen01,s_gen[1].gen02,s_gen[1].gen03,                                   #FUN-A30097
              s_gen[1].gen04,s_gen[1].gen06,s_gen[1].gen05,s_gen[1].gen08,s_gen[1].genacti    #FUN-A30030 ADD pos

#FUN-A80148--end--
 
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(gen03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_gem"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_gen[1].gen03
 
              OTHERWISE
                   EXIT CASE
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
 
    
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_rec_b = 0   #CHI-FA0015 add
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --

  

 
    CALL i040_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i040_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING

    CALL g_gen.clear()
 
       LET g_sql = "SELECT gen01,gen02,gen03,gem02,gen04,gen06,gen05,gen08,genacti,genmodu,gendate ",   #FUN-A30030 ADD POS #FUN-A30097
                   " FROM ",
                   cl_get_target_table(tm.azp01,'gen_file'),
                   " , ", cl_get_target_table(tm.azp01,'gem_file'),
                   " WHERE gen03 = gem01 AND gen01 NOT LIKE 'H%' AND genacti='Y' AND ", p_wc2 CLIPPED,           #單身
                   " ORDER BY 2" 

       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,tm.azp01) RETURNING g_sql
 
       PREPARE i040_pb FROM g_sql
       DECLARE gen_curs CURSOR FOR i040_pb
 
       LET g_cnt = 1
       MESSAGE "Searching!" 
       FOREACH gen_curs INTO g_gen[g_cnt].*   #單身 ARRAY 填充
           IF STATUS THEN
              CALL cl_err('foreach:',STATUS,1)
              EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
        #IF g_cnt > g_max_rec THEN
        #   CALL cl_err( '', 9035, 0 )
        #   EXIT FOREACH
        #END IF
       END FOREACH
    CALL g_gen.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2

    LET g_sql = "SELECT zo05,zo09 FROM ",cl_get_target_table(tm.azp01,'zo_file') 
    PREPARE i040_zo FROM g_sql DECLARE zo_curs CURSOR FOR i040_zo
    FOREACH zo_curs INTO tm.zo05,tm.zo09
      DISPLAY tm.zo05 TO zo05
      DISPLAY tm.zo09 TO zo09
    END FOREACH
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i040_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gen TO s_gen.* ATTRIBUTE(COUNT=g_rec_b)
 
     #---------No.TQC-680158 add
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
     #---------No.TQC-680158 end
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
    #MOD-B70261---mark---start--- 
    ##No.FUN-870067--begin
    # ON ACTION gen_bank_inf
    #    LET g_action_choice="gen_bank_inf"
    #    LET l_ac = 1
    #    EXIT DISPLAY
    ##No.FUN-870067--end  
    #MOD-B70261---mark---end---
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i040_out()
    DEFINE
        l_gen           RECORD LIKE gen_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #  #No.FUN-680102 VARCHAR(40)
    IF g_wc2 IS NULL THEN 
    #  CALL cl_err('',-400,0) 
       CALL cl_err('','9057',0)
      RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 'aooi040.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM gen_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
#No.FUN-760083 --BEGIN--
{
    PREPARE i040_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i040_co                         # SCROLL CURSOR
        CURSOR FOR i040_p1
 
    #CALL cl_outnam('aooi040') RETURNING l_name    
    #START REPORT i040_rep TO l_name               
 
    FOREACH i040_co INTO l_gen.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
           EXIT FOREACH
        ELSE
          #IF g_aza.aza44 = "Y" THEN  #FUN-550077  #TQC-6C0060 mark
          #   CALL cl_itemname_by_lang("gen_file","gen02",l_gen.gen01 CLIPPED,g_lang,l_gen.gen02) RETURNING l_gen.gen02
          #END IF
        END IF
        OUTPUT TO REPORT i040_rep(l_gen.*)
    END FOREACH
 
    FINISH REPORT i040_rep
 
    CLOSE i040_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
}
    LET g_str=''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog 
        IF g_zz05='Y' THEN 
#          CALL cl_wcchp(g_wc2,'gen01,gen02,gen03,gen04,gen05,gen06,genacti,genpos')   #FUN-A30030 ADD POS  #FUN-A80148--mark--
           CALL cl_wcchp(g_wc2,'gen01,gen02,gen03,gen04,gen05,gen06,gen08,genacti,genpos')   #FUN-A30030 ADD POS  #FUN-A80148--mod--
             RETURNING g_wc2  
        END IF
        LET g_str=g_wc2    
         CALL cl_prt_cs1("aooi040","aooi040",g_sql,g_str)   
#No.FUN-760083 --END--
 
END FUNCTION
 
#No.FUN-760083 --begin--
{
REPORT i040_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),
        sr RECORD LIKE gen_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.gen01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            IF sr.genacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
          PRINT COLUMN g_c[32],sr.gen01,
                COLUMN g_c[33],sr.gen02,
                COLUMN g_c[34],sr.gen03,
                COLUMN g_c[35],sr.gen04,
                COLUMN g_c[36],sr.gen05,
                COLUMN g_c[37],sr.gen06
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-760083 --end--
 
#No.FUN-570110 --start                                                          
FUNCTION i040_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("gen01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i040_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("gen01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION       

