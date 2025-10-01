# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cpmt004.4gl
# Descriptions...: 採購未交排程維護作業
# Input parameter: 
# Date & Author..: 2025/02/17 By Momo
# Modify.........: No.25050038  20250604 by momo 依批號抓取客戶採購順序cxmi202
# Modify.........: No.25080030  20250828 By momo

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_ima06         LIKE ima_file.ima06,       #分群碼
    g_pmn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pmm09       LIKE pmm_file.pmm09,       #供應商編號
        pmm02       LIKE pmm_file.pmm02,       #採購單性質
        pmn01       LIKE pmn_file.pmn01,       #採購單號
        pmn02       LIKE pmn_file.pmn02,       #採購項次
        pmn04       LIKE pmn_file.pmn04,       #採購料號
        ima02       LIKE ima_file.ima02,       #品名
        ima021      LIKE ima_file.ima021,      #規格
        pmn20       LIKE pmn_file.pmn20,       #採購數量
        pmn50       LIKE pmn_file.pmn50,       #未交量
        pmn33       LIKE pmn_file.pmn33,       #交貨日
        bmb01       LIKE bmb_file.bmb01,       #完工料件
        img10       LIKE img_file.img10,       #庫存狀況
        tc_pro03    LIKE tc_pro_file.tc_pro03, #機器編號
        tc_pro04    LIKE tc_pro_file.tc_pro04, #狀態
        tc_pro05    LIKE tc_pro_file.tc_pro05, #備註說明
        tc_pro06    LIKE type_file.dat,        #預計完成日
        tc_oao05    LIKE tc_oao_file.tc_oao05, #客戶重要備註 20250604
        sfa05       LIKE sfa_file.sfa05,       #未發工單備料 20250828
        ecb19       LIKE ecb_file.ecb19,       #標準人工工時 20250828
        ecb21       LIKE ecb_file.ecb21        #標準機器工時 20250828
                    END RECORD,
    g_pmn_t         RECORD                     #程式變數 (舊值)
        pmm09       LIKE pmm_file.pmm09,       #供應商編號
        pmm02       LIKE pmm_file.pmm02,       #採購單性質
        pmn01       LIKE pmn_file.pmn01,       #採購單號
        pmn02       LIKE pmn_file.pmn02,       #採購項次
        pmn04       LIKE pmn_file.pmn04,       #採購料號
        ima02       LIKE ima_file.ima02,       #品名
        ima021      LIKE ima_file.ima021,      #規格
        pmn20       LIKE pmn_file.pmn20,       #採購數量
        pmn50       LIKE pmn_file.pmn50,       #未交量
        pmn33       LIKE pmn_file.pmn33,       #交貨日
        bmb01       LIKE bmb_file.bmb01,       #完工料件
        img10       LIKE img_file.img10,       #庫存狀況
        tc_pro03    LIKE tc_pro_file.tc_pro03, #機器編號
        tc_pro04    LIKE tc_pro_file.tc_pro04, #狀態
        tc_pro05    LIKE tc_pro_file.tc_pro05, #備註說明
        tc_pro06    LIKE type_file.dat,        #預計完成日
        tc_oao05    LIKE tc_oao_file.tc_oao05, #客戶重要備註 20250604
        sfa05       LIKE sfa_file.sfa05,       #未發工單備料 20250828
        ecb19       LIKE ecb_file.ecb19,       #標準人工工時 20250828
        ecb21       LIKE ecb_file.ecb21        #標準機器工時 20250828
                    END RECORD,
    g_ima           RECORD
        unavl_stk   LIKE type_file.num15_3,  
        avl_stk     LIKE type_file.num15_3, 
        oeb_q       LIKE type_file.num15_3,  
        sfa_q1      LIKE type_file.num15_3,   
        sfa_q2      LIKE type_file.num15_3,   
        misc_q1     LIKE type_file.num15_3,   
        sfs_q2      LIKE type_file.num15_3,   
        sie_q       LIKE type_file.num15_3,    
        pml_q       LIKE type_file.num15_3,   
        pmn_q       LIKE type_file.num15_3,   
        rvb_q2      LIKE type_file.num15_3,   
        rvb_q       LIKE type_file.num15_3,   
        sfb_q1      LIKE type_file.num15_3,   
        sfb_q2      LIKE type_file.num15_3,   
        qcf_q       LIKE type_file.num15_3,   
        atp_qty     LIKE type_file.num15_3
                    END RECORD,
    g_argv1         LIKE pmn_file.pmn02,
    g_ss            LIKE type_file.chr1,   
    g_wc,g_wc2      STRING,
    g_sql           STRING, 
    g_rec_b         LIKE type_file.num5,   #單身筆數             
    l_ac,l_cnt      LIKE type_file.num5    #目前處理的ARRAY CNT 
DEFINE p_row,p_col  LIKE type_file.num5    
 
#主程式開始
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL 
DEFINE g_before_input_done  LIKE type_file.num5          
 
DEFINE   g_cnt           LIKE type_file.num10            
DEFINE   g_i             LIKE type_file.num5             #count/index for any purpose   
DEFINE   g_msg           LIKE type_file.chr1000          
#為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         
DEFINE   g_curs_index   LIKE type_file.num10         
DEFINE   g_jump         LIKE type_file.num10        
DEFINE   mi_no_ask      LIKE type_file.num5         
DEFINE   l_sql          STRING                       
DEFINE   g_str          STRING                      
DEFINE   l_table        STRING                      
DEFINE   l_table1       STRING                     
DEFINE   g_flag         LIKE type_file.chr1  


MAIN
   
     OPTIONS
         INPUT NO WRAP
     DEFER INTERRUPT
   
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("CPM")) THEN
       EXIT PROGRAM
    END IF
  
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
  
    LET g_ima06 = NULL
    LET g_argv1 = ARG_VAL(1)
 
    LET p_row = 2 LET p_col = 12
 
    OPEN WINDOW t004_w AT p_row,p_col WITH FORM "cpm/42f/cpmt004" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
    CALL cl_set_combo_items_plus("tc_pro04","cpmt004","tc_pro04")
  
    CALL t004_menu()
 
    CLOSE WINDOW t004_w                   #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
         RETURNING g_time                 
 
END MAIN     
 
#QBE 查詢資料
FUNCTION t004_curs()
    CLEAR FORM                            #清除畫面
    CALL g_pmn.clear()
    CALL cl_set_head_visible("","YES")      
 
 
    INITIALIZE g_ima06 TO NULL   
       CONSTRUCT g_wc2 ON ima06   #螢幕上取條件 
                    FROM ima06
                                   
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
           
      ON ACTION controlp
         CASE                
         WHEN INFIELD(ima06) #分群碼
          CALL cl_init_qry_var()
          LET g_qryparam.form     = "q_imz"
          LET g_qryparam.state    = "c"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO ima06
          NEXT FIELD ima06
          END CASE

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

     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup') 
 
     LET g_wc2 = g_wc2 CLIPPED
 
     IF INT_FLAG THEN RETURN END IF
 
     IF NOT cl_null(g_argv1) THEN 
        LET g_wc = g_wc CLIPPED," AND pmm09 ='",g_argv1,"'"
     ELSE
        CONSTRUCT g_wc ON pmm09,pmn01,pmn02,pmn04,pmn33,
                          tc_pro03,tc_pro04,tc_pro05,tc_pro06,
                          ima021                                                             #20250828
            FROM s_pmn[1].pmm09,s_pmn[1].pmn01,s_pmn[1].pmn02,s_pmn[1].pmn04,s_pmn[1].pmn33,
                 s_pmn[1].tc_pro03,s_pmn[1].tc_pro04,s_pmn[1].tc_pro05,s_pmn[1].tc_pro06,
                 s_pmn[1].ima021                                                             #20250828
            
            BEFORE CONSTRUCT
               CALL cl_qbe_init()

            AFTER FIELD pmm09


            ON ACTION controlp
               CASE
                  WHEN INFIELD(pmm09)   #供應商編號
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_pmn04"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO pmm09
                       NEXT FIELD pmm09
                  WHEN INFIELD(pmn04)   #產品名稱
                        CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO pmn04
                       NEXT FIELD pmn04
                  WHEN INFIELD(pmn01)   #採購編號
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_pmn04"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO pmn01
                       NEXT FIELD pmn01
                  WHEN INFIELD(tc_pro03) #機器編號
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="cq_eci01"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO tc_pro03
                       NEXT FIELD tc_pro03
          
                END CASE
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
 
      IF INT_FLAG THEN RETURN END IF
      IF g_wc = " 1=1" THEN LET g_wc = "1=2" END If
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup') 
    END IF  
END FUNCTION
 
FUNCTION t004_menu()
 
   WHILE TRUE
      CALL t004_bp("G")
      CASE g_action_choice
       
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t004_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t004_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmn),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION
 
 
#Query 查詢
FUNCTION t004_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ima06 TO NULL              
 
    CALL cl_opmsg('q')
 
    MESSAGE ""                               
    CLEAR FORM                               
    CALL g_pmn.clear()
 
    CALL t004_curs()                         #取得查詢條件
    CALL t004_show()
 
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
 
 
END FUNCTION
 
 
#將資料顯示在畫面上
FUNCTION t004_show()
 
    CALL t004_b_fill(g_wc)                 #單身
 
    CALL cl_show_fld_cont()                 
END FUNCTION

#單身
FUNCTION t004_b()
DEFINE
    l_imaacti       LIKE ima_file.imaacti, 
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,                #檢查重複用        
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
    p_cmd           LIKE type_file.chr1,                #處理狀態          
    l_allow_insert  LIKE type_file.num5,                #可新增否          
    l_allow_delete  LIKE type_file.num5                 #可刪除否          
DEFINE   l_cnt      LIKE type_file.num10     
 
    LET g_action_choice = ""
 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
        "SELECT pmm09,pmm02,pmn01,pmn02,pmn04,'','',pmn20,pmn50,pmn33,'',0,tc_pro03,tc_pro04,tc_pro05,tc_pro06,'' ",  #20250604     
        "       ,0,0,0 ",     #20250828                    
        "  FROM pmm_file,pmn_file ",     
        "  LEFT JOIN tc_pro_file ON pmn01=tc_pro01 AND pmn02=tc_pro02  ",     
        " WHERE pmm01=pmn01 ",
        "   AND tc_pro01 = ? AND tc_pro02 = ?  FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t004_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
    INPUT ARRAY g_pmn WITHOUT DEFAULTS FROM s_pmn.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK    
            LET g_pmn_t.*=g_pmn[l_ac].* 
            #IF g_rec_b >= l_ac AND NOT cl_null(g_pmn_t.tc_pro06) THEN
 
            #   LET p_cmd='u'
            #   LET g_pmn_t.* = g_pmn[l_ac].*  #BACKUP
 
            #   OPEN t004_bcl USING g_pmn_t.pmn01,g_pmn_t.pmn02
            #   IF STATUS THEN
            #      CALL cl_err("OPEN t004_bcl:", STATUS, 1)
            #      LET l_lock_sw = "Y"
            #   ELSE
            #      FETCH t004_bcl INTO g_pmn_t.* 
            #      IF SQLCA.sqlcode THEN
            #          CALL cl_err(g_pmn_t.pmn01,SQLCA.sqlcode,1)
            #          LET l_lock_sw = "Y"
            #      ELSE
            #          LET g_pmn_t.*=g_pmn[l_ac].*
            #      END IF
            #   END IF
            #   CALL cl_show_fld_cont()    
            #END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_pmn[l_ac].* TO NULL      
          
            LET g_pmn_t.* = g_pmn[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD tc_pro04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
           
            INSERT INTO tc_pro_file(tc_pro01,tc_pro02,tc_pro03,tc_pro04,tc_pro05,tc_pro06
                                 ) 
                          VALUES(g_pmn[l_ac].pmn01,g_pmn[l_ac].pmn02,g_pmn[l_ac].tc_pro03,
                                 g_pmn[l_ac].tc_pro04,g_pmn[l_ac].tc_pro05,g_pmn[l_ac].tc_pro06
                                 )                      
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","tc_pro_file",'',g_pmn[l_ac].pmn01,SQLCA.sqlcode,"","",1)  
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2   
            END IF
 
        AFTER FIELD tc_pro03
            IF NOT cl_null(g_pmn[l_ac].tc_pro03) THEN
               SELECT 1 INTO l_cnt FROM eci_file 
                 WHERE eci01 = g_pmn[l_ac].tc_pro03
                   AND eci01 LIKE 'DE040%'
               IF l_cnt <> 1 THEN
                  NEXT FIELD tc_pro03
               END IF
            END IF

 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pmn[l_ac].* = g_pmn_t.*
               CLOSE t004_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_pmn[l_ac].pmn01,-263,1)
               LET g_pmn[l_ac].* = g_pmn_t.*
            ELSE
               UPDATE tc_pro_file SET tc_pro03 = g_pmn[l_ac].tc_pro03,
                                      tc_pro04 = g_pmn[l_ac].tc_pro04,
                                      tc_pro05 = g_pmn[l_ac].tc_pro05,
                                      tc_pro06 = g_pmn[l_ac].tc_pro06
               WHERE tc_pro01 = g_pmn_t.pmn01 AND tc_pro02 = g_pmn_t.pmn02
               IF SQLCA.SQLERRD[3]=0 THEN
                  INSERT INTO tc_pro_file(tc_pro01,tc_pro02,tc_pro03,tc_pro04,tc_pro05,tc_pro06
                                 )
                          VALUES(g_pmn[l_ac].pmn01,g_pmn[l_ac].pmn02,g_pmn[l_ac].tc_pro03,
                                 g_pmn[l_ac].tc_pro04,g_pmn[l_ac].tc_pro05,g_pmn[l_ac].tc_pro06
                                 )
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("ins","tc_pro_file",'',g_pmn[l_ac].pmn01,SQLCA.sqlcode,"","",1)
                   ELSE
                      MESSAGE 'INSERT O.K'
                      COMMIT WORK
                   END IF
               END IF

              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","tc_pro_file",g_pmn_t.pmn01,g_pmn_t.pmn02,SQLCA.sqlcode,"","",1) 
                 LET g_pmn[l_ac].* = g_pmn_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
 
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_pmn[l_ac].* = g_pmn_t.*
               ELSE
                  #IF g_rec_b != 0 THEN
                  #   LET g_action_choice = "detail"
                  #   LET l_ac = l_ac_t
                  #END IF
               END IF
               CLOSE t004_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   
            CLOSE t004_bcl
            COMMIT WORK
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_pro03) #機器編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="cq_eci01"
                   LET g_qryparam.default1 = g_pmn[l_ac].tc_pro03
                   CALL cl_create_qry() RETURNING g_pmn[l_ac].tc_pro03
                   DISPLAY BY NAME g_pmn[l_ac].tc_pro03
                   NEXT FIELD tc_pro03

            END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pmn01) AND l_ac > 1 THEN
               LET g_pmn[l_ac].* = g_pmn[l_ac-1].*
               NEXT FIELD pmn01
            END IF
 
        ON ACTION controls                              
           CALL cl_set_head_visible("","AUTO")          
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help() 
 
    
    END INPUT

    IF g_flag THEN
       LET g_flag = FALSE
       CALL t004_b()
    END IF

 
END FUNCTION
   
FUNCTION t004_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000  
 
    CONSTRUCT g_wc ON pmn01,pmn03,ta_pmn01,ta_pmn02,         #180913 add ta_pmn01,ta_pmn02 by ruby
                      ta_pmn03,                              #20190326
                      pmn04,pmn05,pmn07,pmn08,pmn09,pmn15    #螢幕上取條件  #FUN-G90009 add pmn15
        FROM s_pmn[1].pmn01,s_pmn[1].pmn03,s_pmn[1].ta_pmn01,s_pmn[1].ta_pmn02,   #180913 add ta_pmn01,ta_pmn02 by ruby
             s_pmn[1].ta_pmn03,                              #20190326
             s_pmn[1].pmn04,s_pmn[1].pmn05,                   
             s_pmn[1].pmn07,s_pmn[1].pmn08,s_pmn[1].pmn09,s_pmn[1].pmn15  #FUN-G90009 add pmn15 
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
    IF INT_FLAG THEN RETURN END IF
 
    CALL t004_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION t004_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000,    
    l_sfb08         LIKE sfb_file.sfb08,     #在製量
    l_sql           STRING
DEFINE l_ima44_fac  LIKE ima_file.ima44_fac  #庫存採購換算
 
    LET l_sql ="SELECT pmm09,pmm02,pmn01,pmn02,pmn04,ima02,ima021,pmn20,pmn20-pmn53+pmn58,pmn33,'',0,",
               "       tc_pro03,tc_pro04,tc_pro05,tc_pro06,'' ",                                           #20250604
               "       ,0,0,0 ",   #20250828
               " FROM ima_file,pmm_file,pmn_file ",
               " LEFT JOIN tc_pro_file ON tc_pro01=pmn01 AND tc_pro02=pmn02 ",
               " WHERE pmm01=pmn01 AND pmm18='Y' AND pmn04=ima01 AND pmn16 <='2'",
               "   AND pmn20-pmn53+pmn58 > 0 AND ima08 <> 'Z' AND ",g_wc CLIPPED ,
               " ORDER BY pmn33 "
    PREPARE t004_p2 FROM l_sql      #預備一下
    DECLARE pmn_curs CURSOR FOR t004_p2
 
    CALL g_pmn.clear()
    LET g_cnt = 1
 
    FOREACH pmn_curs INTO g_pmn[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

        ##--20250604 抓順序 (S) ---
        SELECT tc_oao05 INTO g_pmn[g_cnt].tc_oao05
          FROM tc_oao_file,oea_file,pmn_file
         WHERE tc_oao02 = '5' AND oea03=tc_oao01
           AND tc_oao06 IS NULL
           AND oea01 = SUBSTR(pmn56,1,15)
           AND pmn01 = g_pmn[g_cnt].pmn01
           AND pmn02 = g_pmn[g_cnt].pmn02
        ##--20250604 抓順序 (E) ---

        #--抓工單
        IF g_pmn[g_cnt].pmm02 = 'SUB' THEN
           SELECT sfb05 INTO g_pmn[g_cnt].bmb01
             FROM sfb_file,pmn_file
            WHERE sfb01 = pmn41
              AND pmn01 = g_pmn[g_cnt].pmn01 
              AND pmn02 = g_pmn[g_cnt].pmn02
        ELSE
           SELECT sfb05,MIN(sfb15) INTO g_pmn[g_cnt].bmb01 
             FROM sfb_file,sfa_file
            WHERE sfb01=sfa01
              AND sfb87 != 'X' AND sfb04 < '8'
              AND sfa05 > sfa06 
              AND sfa03 = g_pmn[g_cnt].pmn04
              AND sfb05 LIKE '1%'
            GROUP BY sfb05
         END IF
          #---扣工單在製
          SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
           WHERE sfb05 = g_pmn[g_cnt].bmb01
             AND sfb87 !='X' AND sfb04 < '4'
        IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF

        IF cl_null(g_pmn[g_cnt].bmb01) THEN
           LET g_pmn[g_cnt].bmb01 = g_pmn[g_cnt].pmn04
        END IF

        SELECT ima44_fac INTO l_ima44_fac
          FROM ima_file
         WHERE ima01 = g_pmn[g_cnt].bmb01

        CALL cs_q102_qty(g_pmn[g_cnt].bmb01)
             RETURNING g_ima.oeb_q, g_ima.sfa_q1, g_ima.sfa_q2, g_ima.sie_q,  g_ima.pml_q,
             g_ima.pmn_q, g_ima.rvb_q2, g_ima.rvb_q,  g_ima.sfb_q1, g_ima.sfb_q2,
             g_ima.qcf_q, g_ima.atp_qty,g_ima.misc_q1,g_ima.sfs_q2
        LET g_pmn[g_cnt].sfa05 = g_ima.sfa_q1   #20250828
        LET g_pmn[g_cnt].img10 = (g_ima.atp_qty - l_sfb08 - g_ima.pml_q-g_ima.pmn_q)/l_ima44_fac

        #20250828 (S)
        SELECT ecb19,ecb21 INTO g_pmn[g_cnt].ecb19,g_pmn[g_cnt].ecb21
          FROM ecb_file
         WHERE ecb01 = g_pmn[g_cnt].bmb01
           AND ecb08 IN ('MM001','SA002')
           AND ecb19 > 0
           AND rownum = 1
        #20250828 (E)

        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     
    END FOREACH
    CALL g_pmn.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2      
    
END FUNCTION
 
FUNCTION t004_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                  
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION po_detail
         IF g_pmn[l_ac].pmm02 != 'SUB' THEN
            LET g_msg = " apmt540 '", g_pmn[l_ac].pmn01,"'"
            CALL cl_cmdrun_wait(g_msg CLIPPED)
         END IF
    
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION refresh_detail
         CALL t004_b_fill(g_wc)
  
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                            
         CALL cl_set_head_visible("","AUTO")          
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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
   
      ON ACTION exporttoexcel      
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 

 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 


