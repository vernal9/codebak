# Prog. Version..: '5.30.24-17.04.13(00000)'     #
#
# Pattern name...: cxmt111.4gl
# Descriptions...: 訂單排交日修改記錄
# Date & Author..: 2019/07/17 By Momo
# Modify.........: No.2105126212 20210514 By momo 增加 tc_oeq07 延期說明
# Modify.........: No.24030004   20240313 By momo 增加SKFamily 中介檔處理
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE
    g_argv1         LIKE oeb_file.oeb01,         #訂單單號
    g_argv2         LIKE oeb_file.oeb03,         #訂單項次
    g_argv3         LIKE tc_oeq_file.tc_oeq02,   #變更次數  
    g_oeb01         LIKE oeb_file.oeb01,         #假單頭
    g_oeb03         LIKE oeb_file.oeb03,         #假單頭
    g_tc_oeq02      LIKE tc_oeq_file.tc_oeq02, 
    g_tc_oeq        DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
        oeb03       LIKE oeb_file.oeb03,         #20190807
        tc_oeq02    LIKE tc_oeq_file.tc_oeq02,   #變更次數
        tc_oeq04b   LIKE tc_oeq_file.tc_oeq04b,  #變更前排交日
        tc_oeq04a   LIKE tc_oeq_file.tc_oeq04b,  #變更後排交日
        tc_oeq05    LIKE tc_oeq_file.tc_oeq05 ,  #變更原因
        azf03       LIKE azf_file.azf03,       
        tc_oeq07    LIKE tc_oeq_file.tc_oeq07,   #延期說明 20210514
        tc_oeq06    LIKE tc_oeq_file.tc_oeq06,   #變更說明
        tc_oeqdate  LIKE tc_oeq_file.tc_oeqdate, #變更日期
        tc_oeqoriu  LIKE tc_oeq_file.tc_oeqoriu  #變更人員
      
                    END RECORD,
    g_tc_oeq_t         RECORD                     #程式變數 (舊值)
        oeb03       LIKE oeb_file.oeb03,         #20190807
        tc_oeq02    LIKE tc_oeq_file.tc_oeq02,   #變更次數
        tc_oeq04b   LIKE tc_oeq_file.tc_oeq04b,  #變更前排交日
        tc_oeq04a   LIKE tc_oeq_file.tc_oeq04b,  #變更後排交日
        tc_oeq05    LIKE tc_oeq_file.tc_oeq05 ,  #變更原因
        azf03       LIKE azf_file.azf03,       
        tc_oeq07    LIKE tc_oeq_file.tc_oeq07,   #延期說明 20210514
        tc_oeq06    LIKE tc_oeq_file.tc_oeq06,   #變更說明
        tc_oeqdate  LIKE tc_oeq_file.tc_oeqdate, #變更日期
        tc_oeqoriu  LIKE tc_oeq_file.tc_oeqoriu  #變更人員
                    END RECORD,
     g_wc2,g_sql    STRING,                 #No.FUN-580092 HCN        #No.FUN-680104
     g_wc           STRING,                 #No.FUN-580092 HCN        #No.FUN-680104
    g_rec_b        LIKE type_file.num5,     #單身筆數                 #No.FUN-680104 SMALLINT
    l_ac           LIKE type_file.num5,     #前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
    g_ss           LIKE type_file.chr1,     #No.FUN-680104 VARCHAR(1)
    l_flag         LIKE type_file.chr1      #No.FUN-680104 VARCHAR(1)
DEFINE p_row,p_col          LIKE type_file.num5          #No.FUN-680104 SMALLINT
DEFINE g_forupd_sql         STRING                       #SELECT ... FOR UPDATE  SQL   #No.FUN-680104
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680104 SMALLINT
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
MAIN

 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("CXM")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    LET g_argv1 = ARG_VAL(1)               #傳遞的參數:專案代號
    LET g_argv2 = ARG_VAL(2)               #傳遞的參數:行序
    LET g_argv3 = ARG_VAL(3)               #傳遞的參數:行序

    LET g_oeb01 = g_argv1
    LET g_oeb03 = g_argv2
    LET g_tc_oeq02 = g_argv3
 
    INITIALIZE g_tc_oeq_t.* TO NULL
    LET p_row = 4 LET p_col = 21
 
    OPEN WINDOW t111_w AT p_row,p_col
         WITH FORM "cxm/42f/cxmt111"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
#    CALL t111_q()
    IF NOT cl_null(g_argv1) THEN 
       CALL t111_q() 
    END IF
 
    CALL t111_menu()
 
    CLOSE WINDOW t111_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
 
#QBE 查詢資料
FUNCTION t111_cs()
 
   IF NOT cl_null(g_argv1) THEN
       LET g_wc =" oeb01= '",g_argv1,"' AND "," oeb03= ",g_argv2 
             #    " AND tc_oeq03 <= '",g_argv3,"' "
       LET g_sql=" SELECT oeb01,oeb03 ",
                 " FROM oeb_file ",
                 " WHERE ",g_wc CLIPPED
   ELSE
       CLEAR FORM                             #清除畫面
       CALL g_tc_oeq.clear()
 
       CALL cl_set_head_visible("","YES")           
   INITIALIZE g_oeb01 TO NULL   
   INITIALIZE g_oeb03 TO NULL    
   INITIALIZE g_tc_oeq02 TO NULL   
  
        CONSTRUCT g_wc ON tc_oeq01, tc_oeq03,  tc_oeq04a, tc_oeq05   
            FROM tc_oeq01, tc_oeq03,s_tc_oeq[1].tc_oeq04a,s_tc_oeq[1].tc_oeq05 

              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

      AFTER FIELD tc_oeq03                      #20241004
         LET g_oeb03 = GET_FLDBUF(tc_oeq03)     #20241004
              
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

      ON ACTION qbe_save
         CALL cl_qbe_save()
	
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #
 
       LET g_sql= "SELECT  UNIQUE tc_oeq01 FROM tc_oeq_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 1"
   END IF
 
    PREPARE t111_prepare FROM g_sql      #預備一下
    DECLARE t111_b_cs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t111_prepare
 
    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE x
    LET g_sql="SELECT DISTINCT tc_oeq01 ",
              " FROM tc_oeq_file WHERE ", g_wc CLIPPED," INTO TEMP x"
    PREPARE t111_precount_x  FROM g_sql
    EXECUTE t111_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE t111_precount FROM g_sql
    DECLARE t111_count CURSOR FOR  t111_precount
 
END FUNCTION
 
FUNCTION t111_menu()
 
   WHILE TRUE
      CALL t111_bp("G")
      CASE g_action_choice
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL t111_q()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t111_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        ##--- 20190807 批次調整交貨日
        WHEN "modify_date"
           IF cl_chk_act_auth() THEN
              CALL t111_date('a')
           END IF 
 
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_oeq),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t111_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,        #a:輸入 u:更改        #No.FUN-680104 VARCHAR(1)
    l_n             LIKE type_file.num5,        #No.FUN-680104 SMALLINT
    l_str           LIKE cob_file.cob01         #No.FUN-680104 VARCHAR(40)
 
    LET g_ss='Y'
    DISPLAY  g_oeb01 TO tc_oeq01
    DISPLAY  g_oeb03 TO tc_oeq03
    DISPLAY  g_tc_oeq02 TO tc_oeq02
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT BY NAME g_oeb01,g_oeb03,g_tc_oeq02 WITHOUT DEFAULTS
 
        #AFTER FIELD tc_oeq01
        #    IF g_oeb01 != g_tc_oeq01_t OR      #輸入後更改不同時值
        #       g_tc_oeq01_t IS NULL THEN
        #        SELECT UNIQUE tc_oeq01 #INTO g_chr
        #            FROM tc_oeq_file
        #            WHERE tc_oeq01=g_oeb01
        #        IF SQLCA.sqlcode THEN             #不存在, 新來的
        #            IF p_cmd='a' THEN
        #                LET g_ss='N'
        #            END IF
        #        ELSE
        #            IF p_cmd='u' THEN
        #                CALL cl_err(g_oeb01,-239,0)
        #                LET g_oeb01=g_tc_oeq01_t
        #                NEXT FIELD tc_oeq01
        #            END IF
        #        END IF
        #     END IF   
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
END FUNCTION
 
 
#Query 查詢
FUNCTION t111_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_tc_oeq.clear()
    CALL t111_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_oeb01 TO NULL
        FOR g_cnt = 1 TO g_tc_oeq.getLength()
            LET g_tc_oeq[g_cnt].tc_oeq05 = ' '
        END FOR
        RETURN
    END IF
    OPEN t111_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_oeb01 TO NULL
       INITIALIZE g_oeb03 TO NULL
    ELSE
       OPEN t111_count
       FETCH t111_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t111_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t111_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,          #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10          #絕對的筆數      #No.FUN-680104 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t111_b_cs INTO g_oeb01
        WHEN 'P' FETCH PREVIOUS t111_b_cs INTO g_oeb01
        WHEN 'F' FETCH FIRST    t111_b_cs INTO g_oeb01
        WHEN 'L' FETCH LAST     t111_b_cs INTO g_oeb01
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
 
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            FETCH ABSOLUTE l_abso t111_b_cs INTO g_oeb01
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_oeb01,SQLCA.sqlcode,0)
       #INITIALIZE g_oeb01  TO NULL  #TQC-6B0105
       #INITIALIZE g_oeb03  TO NULL  #TQC-6B0105
       #INITIALIZE g_tc_oeq02 TO NULL  #TQC-6B0105
       FOR g_cnt = 1 TO g_tc_oeq.getLength()
           LET g_tc_oeq[g_cnt].tc_oeq02 = ' '
       END FOR
       DISPLAY g_oeb01 TO tc_oeq01        #單頭
    ELSE
       CALL t111_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t111_show()
    IF NOT cl_null(g_argv1) THEN
       DISPLAY g_oeb01,g_oeb03 TO tc_oeq01,tc_oeq03      #單頭
    ELSE
       DISPLAY g_oeb01 TO tc_oeq01
       DISPLAY g_oeb03 TO tc_oeq03   #20241004
    END IF
     IF g_tc_oeq02 > 1 OR cl_null(g_argv1) THEN
        CALL t111_b_fill(' 1=1')                        #單身
     ELSE
        CALL t111_b()
     END IF

    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t111_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用      #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否      #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680104 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680104 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680104 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_oeb01 IS NULL THEN RETURN END IF
    #IF g_oeb03 IS NULL THEN RETURN END IF
    #IF g_tc_oeq02 IS NULL THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
 

    LET g_forupd_sql = "SELECT tc_oeq03,tc_oeq02,tc_oeq04b,tc_oeq04a,tc_oeq05,'',tc_oeq07, ", #20210514 add tc_oeq07
                       "       tc_oeq06,tc_oeqdate,tc_oeqoriu FROM tc_oeq_file ",
                       "  WHERE  tc_oeq01= ? AND tc_oeq03= ? ",
                       " AND tc_oeq02= ?  FOR UPDATE "           

    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t111_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    CALL cl_set_act_visible("accept,cancel", TRUE) 
    INPUT ARRAY g_tc_oeq WITHOUT DEFAULTS FROM s_tc_oeq.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               LET l_ac = l_ac
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF NOT cl_null(g_oeb03) THEN LET g_tc_oeq[l_ac].oeb03=g_oeb03 END IF
            IF g_rec_b >= l_ac THEN
 
               BEGIN WORK
               LET p_cmd='u'
               LET g_tc_oeq_t.* = g_tc_oeq[l_ac].*  #BACKUP
 
               OPEN t111_bcl USING g_oeb01,g_tc_oeq[l_ac].oeb03,g_tc_oeq[l_ac].tc_oeq02
               IF STATUS THEN
                  CALL cl_err("OPEN t111_bcl:", STATUS, 1)
                  LET l_lock_sw = 'Y'
               ELSE
                  FETCH t111_bcl INTO g_tc_oeq[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_tc_oeq_t.tc_oeq02,SQLCA.sqlcode,1)
                     LET l_lock_sw = 'Y'
                  ELSE
                     SELECT azf03 INTO g_tc_oeq[l_ac].azf03 FROM azf_file
                      WHERE azf01=g_tc_oeq[l_ac].tc_oeq05 AND azf09='C'
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_tc_oeq[l_ac].* TO NULL      #900423
            LET g_tc_oeq_t.* = g_tc_oeq[l_ac].*         #新輸入資料
            LET g_tc_oeq[l_ac].tc_oeq02 = g_tc_oeq02
            IF NOT cl_null(g_oeb03) THEN LET g_tc_oeq[l_ac].oeb03=g_oeb03 END IF

            SELECT oeb16 INTO g_tc_oeq[l_ac].tc_oeq04b FROM oeb_file
             WHERE oeb01= g_oeb01 AND oeb03 = g_tc_oeq[l_ac].oeb03
            LET g_tc_oeq[l_ac].tc_oeqdate = g_today
            LET g_tc_oeq[l_ac].tc_oeqoriu = g_user

            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT

            END IF

            INSERT INTO tc_oeq_file(tc_oeq01,tc_oeq03,tc_oeq02,tc_oeq04b,tc_oeq04a,tc_oeq05,tc_oeq07,tc_oeq06,tc_oeqdate,tc_oeqoriu)   #20210514 add                                            
                          VALUES(g_oeb01,g_tc_oeq[l_ac].oeb03,g_tc_oeq02,g_tc_oeq[l_ac].tc_oeq04b,g_tc_oeq[l_ac].tc_oeq04a, 
                                 g_tc_oeq[l_ac].tc_oeq05,
                                 g_tc_oeq[l_ac].tc_oeq07,    #20210514 add 
                                 g_tc_oeq[l_ac].tc_oeq06,  
                                 g_today,g_user)                                              
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","tc_oeq_file",g_oeb01,g_oeb03,SQLCA.sqlcode,"","",1)  
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               #更新訂單排交日
               UPDATE oeb_file SET oeb16 = g_tc_oeq[l_ac].tc_oeq04a 
                WHERE oeb01 = g_oeb01 AND oeb03 = g_tc_oeq[l_ac].oeb03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","oeb_file",g_oeb01,g_tc_oeq[l_ac].oeb03,SQLCA.sqlcode,"","",1)
               END IF 
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER FIELD tc_oeq02                        #check 編號是否重複
            IF NOT cl_null(g_tc_oeq[l_ac].tc_oeq02) THEN
               IF g_tc_oeq[l_ac].tc_oeq02 != g_tc_oeq_t.tc_oeq02 OR
                  cl_null(g_tc_oeq_t.tc_oeq02) THEN
                   
               END IF
            END IF
 
        AFTER FIELD tc_oeq04a
           IF NOT cl_null(g_tc_oeq[l_ac].tc_oeq04a) THEN
              
              IF STATUS THEN NEXT FIELD tc_oeq04a END IF
           END IF
 
        AFTER FIELD tc_oeq05
           IF g_tc_oeq[l_ac].tc_oeq05 IS NULL THEN
              NEXT FIELD tc_oeq05
           ELSE
              SELECT azf03 INTO g_tc_oeq[l_ac].azf03 FROM azf_file
                      WHERE azf01=g_tc_oeq[l_ac].tc_oeq05 AND azf09='C'
              IF STATUS THEN NEXT FIELD tc_oeq05 END IF
           END IF

 
        BEFORE DELETE                            #是否取消單身
            IF g_tc_oeq[l_ac].tc_oeq02 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM tc_oeq_file
                 WHERE tc_oeq02 = g_tc_oeq[l_ac].tc_oeq02                 
                  AND tc_oeq01 = g_oeb01 AND tc_oeq03 = g_tc_oeq[l_ac].oeb03   
                  
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","tc_oeq_file",g_oeb01,g_tc_oeq[l_ac].oeb03,SQLCA.sqlcode,"","",1)  
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               UPDATE oeb_file SET oeb16 = g_tc_oeq[l_ac].tc_oeq04b
                 WHERE oeb01 = g_oeb01 AND oeb03 = g_tc_oeq[l_ac].oeb03
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
               CALL cs_axmmid(g_oeb01,"axmt410")  #20240314
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_oeq[l_ac].* = g_tc_oeq_t.*
               CLOSE t111_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_oeq[l_ac].tc_oeq02,-263,1)
               LET g_tc_oeq[l_ac].* = g_tc_oeq_t.*
            ELSE
               UPDATE tc_oeq_file SET 
                                   tc_oeq04a=g_tc_oeq[l_ac].tc_oeq04a,
                                   tc_oeq05=g_tc_oeq[l_ac].tc_oeq05,
                                   tc_oeq07=g_tc_oeq[l_ac].tc_oeq07,     #20210514 add
                                   tc_oeq06=g_tc_oeq[l_ac].tc_oeq06,
                                   tc_oeqdate=g_today,                      
                                   tc_oeqoriu=g_user
               WHERE tc_oeq01=g_oeb01
                 AND tc_oeq03=g_tc_oeq[l_ac].oeb03
                 AND tc_oeq02=g_tc_oeq[l_ac].tc_oeq02
                
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","tc_oeq_file",g_oeb01,g_tc_oeq[l_ac].oeb03,SQLCA.sqlcode,"","",1)  
                  LET g_tc_oeq[l_ac].* = g_tc_oeq_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                  #更新排交日
                  UPDATE oeb_file SET oeb16 = g_tc_oeq[l_ac].tc_oeq04a
                   WHERE oeb01 = g_oeb01 AND oeb03 = g_tc_oeq[l_ac].oeb03
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","oeq_file",g_oeb01,g_tc_oeq[l_ac].oeb03,SQLCA.sqlcode,"","",1)
                  END IF
                  CALL cs_axmmid(g_oeb01,"axmt410")  #20240314
                  LET g_rec_b=g_rec_b
                  DISPLAY g_rec_b TO FORMONLY.cn2
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_tc_oeq[l_ac].* = g_tc_oeq_t.*
               END IF
               CLOSE t111_bcl
               ROLLBACK WORK
               CALL t111_menu()
               EXIT INPUT
            END IF
            CLOSE t111_bcl
            COMMIT WORK
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tc_oeq01) AND l_ac > 1 THEN
                LET g_tc_oeq[l_ac].* = g_tc_oeq[l_ac-1].*
                NEXT FIELD tc_oeq01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLP
           CASE
            WHEN INFIELD(tc_oeq05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azf01"
              LET g_qryparam.arg1  = "C"
              CALL cl_create_qry() RETURNING g_tc_oeq[l_ac].tc_oeq05
              DISPLAY BY NAME g_tc_oeq[l_ac].tc_oeq05
              NEXT FIELD tc_oeq05
            END CASE 

 
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


      CLOSE t111_bcl
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         RETURN
      END IF
 
        END INPUT
 
    CALL cl_set_act_visible("accept,cancel", FALSE) 
    COMMIT WORK

END FUNCTION
 
FUNCTION t111_b_askkey()
    CLEAR FORM
    CALL g_tc_oeq.clear()
 
    CONSTRUCT g_wc2 ON tc_oeq04a,tc_oeq05
         FROM s_tc_oeq[1].tc_oeq04a, s_tc_oeq[1].tc_oeq04a, s_tc_oeq[1].tc_oeq05
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    CALL t111_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t111_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING

    IF cl_null(p_wc2) THEN LET p_wc2=' 1=1'  END IF


    IF NOT cl_null(g_argv1) OR NOT cl_null(g_oeb03) THEN    
      LET g_sql = "SELECT tc_oeq03,tc_oeq02,tc_oeq04b,tc_oeq04a,tc_oeq05,azf03,tc_oeq07,tc_oeq06,tc_oeqdate,tc_oeqoriu ",   #20210514 add
                " FROM tc_oeq_file,azf_file",
                " WHERE tc_oeq01='",g_oeb01,"' AND tc_oeq03='",g_oeb03 CLIPPED,"' ",
                " AND tc_oeq05=azf01 AND azf09='C' AND ",p_wc2 CLIPPED,
                " ORDER BY 1"
    ELSE
      LET g_sql = "SELECT tc_oeq03,tc_oeq02,tc_oeq04b,tc_oeq04a,tc_oeq05,azf03,tc_oeq07,tc_oeq06,tc_oeqdate,tc_oeqoriu ",  #20210514 add
                " FROM tc_oeq_file,azf_file",
                " WHERE tc_oeq01='",g_oeb01,"' ",
                " AND tc_oeq05=azf01 AND azf09='C' AND ",p_wc2 CLIPPED,
                " ORDER BY 1"
    END IF

    PREPARE t111_pb FROM g_sql
    DECLARE tc_oeq_curs CURSOR FOR t111_pb
 
    CALL g_tc_oeq.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!"
 
    FOREACH tc_oeq_curs INTO g_tc_oeq[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_tc_oeq.deleteElement(g_cnt)
    MESSAGE ""
 
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION t111_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_oeq TO s_tc_oeq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         CALL t111_q()

      ON ACTION first
         CALL t111_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
#     ON ACTION previous
         CALL t111_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t111_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         CALL t111_b()

      ON ACTION modify_date
         CALL t111_date('a')
 
      ON ACTION next
         CALL t111_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t111_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     #@ON ACTION 相關文件                         #FUN-830068                                                                       
     # ON ACTION related_document                                                                                                    
     #    LET g_action_choice="related_document"                                                                                     
     #    EXIT DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #No.MOD-530688  --begin
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      #No.MOD-530688  --end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032

      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         RETURN
      END IF

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610036 <001> #

##---- 20190807 新增批次變更 (S)
#批次變更單身日期資料: 變更前交貨日期、變更後交貨日期
FUNCTION t111_date(p_cmd)   #MOD-D80150 add p_from -> 1:單頭詢問篩選條件展單身   #TQC-D80039 modify p_from -> p_cmd :'a':新增
                            #                         2:透過Action異動單身資料                                       'u':Update
   DEFINE a         LIKE type_file.chr1,
          oeb01     LIKE oeb_file.oeb01,
          l_oea02   LIKE oea_file.oea02,
          q_azf01   LIKE azf_file.azf01,
          tc_oeq07  LIKE tc_oeq_file.tc_oeq07,   #20210514 add
          tc_oeq06  LIKE tc_oeq_file.tc_oeq06,
          l_oeq16b  LIKE oeq_file.oeq15b,
          l_oeq16a  LIKE oeq_file.oeq15a,
          l_imzacti LIKE imz_file.imzacti
   DEFINE p_cmd     LIKE type_file.chr1                                          #TQC-D80039 add

   #IF oeb01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   LET g_success = 'Y' #TQC-D60043 add

   CALL s_showmsg_init()
   OPEN WINDOW t111_d WITH FORM "cxm/42f/cxmt111_d"         #條件畫面
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("cxmt111_d")

    LET a='1'
    LET q_azf01 = NULL
    LET l_oeq16b = NULL
    LET l_oeq16a = NULL
   CALL cl_set_act_visible("accept,cancel", TRUE)
   INPUT a,oeb01,q_azf01,tc_oeq07,tc_oeq06,l_oeq16b,l_oeq16a   #20210514 add
         WITHOUT DEFAULTS FROM FORMONLY.a,FORMONLY.oeb01,
                               FORMONLY.q_azf01,
                               FORMONLY.tc_oeq07,              #20210514 add
                               FORMONLY.tc_oeq06,
                               FORMONLY.oeq15b,FORMONLY.oeq15a

         BEFORE INPUT
           # CALL t111_set_entry_d(a,l_oeq15a)
           # CALL t111_set_no_entry_d(a,l_oeq15a)

         AFTER FIELD a
            IF a NOT MATCHES "[12]" THEN   #MOD-D80150 add 4
               NEXT FIELD a
            END IF
            
         AFTER FIELD q_azf01
            SELECT azf03 INTO tc_oeq06
              FROM azf_file
             WHERE azf01 = q_azf01
               AND azf09='C'
            IF cl_null(tc_oeq06) THEN
               CALL cl_err(q_azf01,'mfg3179',0)
               NEXT FIELD q_azf01
            ELSE
               DISPLAY BY NAME tc_oeq06
            END IF

         AFTER FIELD oeq15a
            IF NOT cl_null(l_oeq16a) THEN
               SELECT oea02 INTO l_oea02 FROM oea_file
                WHERE oea01 = g_oep.oep01
               IF l_oea02 > l_oeq16a THEN
                  CALL cl_err('','axm-330',0)
                  NEXT FIELD oeq15a
               END IF 
            END IF   

         ON CHANGE a
            IF a <> '2' THEN
               LET l_oeq16b = ' '
               DISPLAY l_oeq16b TO FORMONLY.oeq15b
            END IF
   
         ON CHANGE oeq15a
            IF cl_null(l_oeq16a) THEN
               LET l_oeq16a = ' '
               DISPLAY l_oeq16a TO FORMONLY.oeq15a
            END IF

         ON ACTION controlp
            CASE
               WHEN INFIELD(oeb01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_oea03"
                    LET g_qryparam.arg1  = "C"
                    CALL cl_create_qry() RETURNING oeb01
                    DISPLAY oeb01 TO FORMONLY.oeb01
                    NEXT FIELD oeb01
               WHEN INFIELD(q_azf01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azf01"
                    LET g_qryparam.arg1  = "C"
                    CALL cl_create_qry() RETURNING q_azf01
                    DISPLAY q_azf01 TO FORMONLY.q_azf01
                    NEXT FIELD q_azf01
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

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         AFTER INPUT
            IF INT_FLAG THEN           # 若按了DEL鍵
               LET INT_FLAG = 0
               EXIT INPUT
            END IF
            IF cl_null(l_oeq16a) AND a <> '4' THEN   #MOD-D80150 add AND a <> '4'
               CALL cl_err('','apm1195',0)
               NEXT FIELD oeq15a         
            ELSE
               IF p_cmd = 'a' THEN                   #MOD-D80150 add   #TQC-D80039 modify p_from = '1' -> p_cmd = 'a'
                  CALL t111_b_g(a,oeb01,q_azf01,tc_oeq07,tc_oeq06,l_oeq16b,l_oeq16a)  #20210514 add
                  LET g_oeb01 = oeb01
               END IF
            END IF
   END INPUT

   IF INT_FLAG THEN  
      LET INT_FLAG=0 
   END IF          

   CLOSE WINDOW t111_d
   CALL s_showmsg()
   CALL t111_show()
   CALL cl_set_act_visible("accept,cancel", FALSE)
END FUNCTION


FUNCTION t111_b_g(p_a,g_oeb01,p_azf01,p_tc_oeq07,p_tc_oeq06,p_oeq16b,p_oeq16a)  #批次變更單身日期展單身資料 #20210514 add
   DEFINE l_sql      STRING,
          l_sql_2    STRING,
          g_oeb01    LIKE oeb_file.oeb01,
          p_a        LIKE type_file.chr1,
          p_azf01    LIKE azf_file.azf01,
          p_tc_oeq07 LIKE tc_oeq_file.tc_oeq07,  #20210514 add
          p_tc_oeq06 LIKE tc_oeq_file.tc_oeq06,
          p_oeq16b   LIKE oeq_file.oeq15b, 
          p_oeq16a   LIKE oeq_file.oeq15a,
          l_i,l_x    LIKE type_file.num5,
          l_ac2     LIKE type_file.num5

 
   CASE p_a
      WHEN "1"   #所有單身日期一併調整
         LET l_sql=" SELECT oeb03,   oeb16 ", 
                   "   FROM oeb_file ",
                   "  WHERE oeb01 = '",g_oeb01,"'",
                   "    AND oeb70 <> 'Y' "
      WHEN "2"   #只調整變更前相同的單身日期
         LET l_sql=" SELECT oeb03,    oeb16 ",
                   "   FROM oeb_file WHERE oeb01 = '",g_oeb01,"'",
                   "    AND oeb15 = '",p_oeq16b,"' ",                       
                   "    AND oeb70 <> 'Y' "                            
      #MOD-D80150 -- add end --
      OTHERWISE EXIT CASE
   END CASE

   PREPARE oeq_pre_2 FROM l_sql
   DECLARE oeq_cs_2 CURSOR FOR oeq_pre_2 
   
   LET l_ac2 = 1
   FOREACH oeq_cs_2 INTO g_oeb03,g_tc_oeq_t.tc_oeq04b
      IF SQLCA.sqlcode THEN
         CALL s_errmsg(g_oeb01,p_oeq16a,'tc_oeq16a',SQLCA.sqlcode,1)
      END IF
      SELECT MAX(tc_oeq02)+1 INTO g_tc_oeq02
         FROM tc_oeq_file
        WHERE tc_oeq01 = g_oeb01 AND tc_oeq03 = g_oeb03
      IF cl_null(g_tc_oeq02) THEN LET g_tc_oeq02 = 1 END IF
       INSERT INTO tc_oeq_file(tc_oeq01,tc_oeq03,tc_oeq02,tc_oeq04b,tc_oeq04a,tc_oeq05,tc_oeq07,tc_oeq06,tc_oeqdate,tc_oeqoriu) #20210514 add
                          VALUES(g_oeb01,g_oeb03,g_tc_oeq02,g_tc_oeq_t.tc_oeq04b,
                                 p_oeq16a,
                                 p_azf01,
                                 p_tc_oeq07, #20210514 add
                                 p_tc_oeq06,
                                 g_today,g_user)
       IF STATUS THEN
          CALL s_errmsg('tc_oeq03',g_tc_oeq_t.oeb03,"",SQLCA.sqlcode,1)
          LET g_success = "N"
       ELSE
          UPDATE oeb_file SET oeb16 = p_oeq16a
                WHERE oeb01 = g_oeb01 AND oeb03 = g_oeb03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","oeb_file",g_oeb01,g_tc_oeq_t.oeb03,SQLCA.sqlcode,"","",1)
               END IF
       END IF
   END FOREACH

END FUNCTION
##---- 20190807 新增批次變更 (E)
