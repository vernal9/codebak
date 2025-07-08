# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cxmp412.4gl
# Descriptions...: 料號規格查詢與申請記錄維護作業
# Input parameter: 
# Date & Author..: 2023/06/13 By Momo 


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_tc_mpn03         LIKE tc_mpn_file.tc_mpn03,   #客戶編號 (假單頭)
    g_tc_mpn03_t       LIKE tc_mpn_file.tc_mpn03,   #客戶編號 (舊值)
    g_tc_mpn01         LIKE tc_mpn_file.tc_mpn01,   #單號
    g_tc_mpn01_t       LIKE tc_mpn_file.tc_mpn01,   #單號(舊值)
    g_tc_mpn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_mpn00       LIKE tc_mpn_file.tc_mpn00,   #申請來源
        tc_mpn01       LIKE tc_mpn_file.tc_mpn01,   #單號/客戶PO
        tc_mpn02       LIKE tc_mpn_file.tc_mpn02,   #項次
        tc_mpn03       LIKE tc_mpn_file.tc_mpn03,   #客戶編號
        occ02          LIKE occ_file.occ02,         #客戶簡稱
        tc_mpn04       LIKE tc_mpn_file.tc_mpn04,   #修改件否
        tc_mpn05       LIKE tc_mpn_file.tc_mpn05,   #規格
        tc_mpn06       LIKE tc_mpn_file.tc_mpn06,   #料號
        tc_mpn07       LIKE tc_mpn_file.tc_mpn07,   #數量
        tc_mpn08       LIKE tc_mpn_file.tc_mpn08,   #希望交期
        tc_mpn09       LIKE tc_mpn_file.tc_mpn09,   #急件否
        tc_mpn10       LIKE tc_mpn_file.tc_mpn10,   #結案否
        tc_mpn19       LIKE tc_mpn_file.tc_mpn19,   #需求說明
        tc_mpn11       LIKE tc_mpn_file.tc_mpn11,   #規格重新確認否
        tc_mpn12       LIKE tc_mpn_file.tc_mpn12,   #研發說明欄
        tc_mpn13       LIKE tc_mpn_file.tc_mpn13,   #修改件規格
        tc_mpn14       LIKE tc_mpn_file.tc_mpn14,   #約定出貨日
        tc_mpn15       LIKE tc_mpn_file.tc_mpn15,   #排定出貨日
        tc_mpn16       LIKE tc_mpn_file.tc_mpn16,   #生管說明欄
        tc_mpn17       LIKE type_file.chr50,        #生管確認日
        tc_mpn18       LIKE type_file.chr50,        #研發確認日
        tc_mpndate     LIKE type_file.chr50,        #資料建立日
        tc_mpnoriu     LIKE tc_mpn_file.tc_mpnoriu, #資料建立者
        tc_mpnplant    LIKE tc_mpn_file.tc_mpnplant,#營運中心
        oeb01          LIKE oeb_file.oeb01,         #完成訂單號
        bma05          LIKE bma_file.bma05          #BOM發放日
                    END RECORD,
    g_tc_mpn_t         RECORD                 #程式變數 (舊值)
        tc_mpn00       LIKE tc_mpn_file.tc_mpn00,   #申請來源
        tc_mpn01       LIKE tc_mpn_file.tc_mpn01,   #單號/客戶PO
        tc_mpn02       LIKE tc_mpn_file.tc_mpn02,   #項次
        tc_mpn03       LIKE tc_mpn_file.tc_mpn03,   #客戶編號
        occ02          LIKE occ_file.occ02,         #客戶簡稱
        tc_mpn04       LIKE tc_mpn_file.tc_mpn04,   #修改件否
        tc_mpn05       LIKE tc_mpn_file.tc_mpn05,   #規格
        tc_mpn06       LIKE tc_mpn_file.tc_mpn06,   #料號
        tc_mpn07       LIKE tc_mpn_file.tc_mpn07,   #數量
        tc_mpn08       LIKE tc_mpn_file.tc_mpn08,   #希望交期
        tc_mpn09       LIKE tc_mpn_file.tc_mpn09,   #急件否
        tc_mpn10       LIKE tc_mpn_file.tc_mpn10,   #結案否
        tc_mpn19       LIKE tc_mpn_file.tc_mpn19,   #需求說明
        tc_mpn11       LIKE tc_mpn_file.tc_mpn11,   #規格重新確認否
        tc_mpn12       LIKE tc_mpn_file.tc_mpn12,   #研發說明欄
        tc_mpn13       LIKE tc_mpn_file.tc_mpn13,   #修改件規格
        tc_mpn14       LIKE tc_mpn_file.tc_mpn14,   #約定出貨日
        tc_mpn15       LIKE tc_mpn_file.tc_mpn15,   #排定出貨日
        tc_mpn16       LIKE tc_mpn_file.tc_mpn16,   #生管說明欄
        tc_mpn17       LIKE type_file.chr50,        #生管確認日
        tc_mpn18       LIKE type_file.chr50,        #研發確認日
        tc_mpndate     LIKE type_file.chr50,        #資料建立日
        tc_mpnoriu     LIKE tc_mpn_file.tc_mpnoriu, #資料建立者
        tc_mpnplant    LIKE tc_mpn_file.tc_mpnplant,#營運中心
        oeb01          LIKE oeb_file.oeb01,         #完成訂單號
        bma05          LIKE bma_file.bma05          #BOM發放日
                    END RECORD,
    g_argv1         LIKE tc_mpn_file.tc_mpn01,
    g_ss            LIKE type_file.chr1,   
    g_sa            LIKE type_file.chr1,   #可執行狀態 
    g_wc,g_sql      STRING, 
    g_rec_b         LIKE type_file.num5,   #單身筆數             
    l_ac,l_ac2      LIKE type_file.num5    #目前處理的ARRAY CNT  
	DEFINE p_row,p_col  LIKE type_file.num5    
	 
	#主程式開始
	DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL 
	DEFINE g_before_input_done  LIKE type_file.num5          
	 
	DEFINE   g_cnt           LIKE type_file.num10            
	DEFINE   g_i             LIKE type_file.num5             #count/index 
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
	   
	    IF (NOT cl_setup("CXM")) THEN
	       EXIT PROGRAM
	    END IF
	 
	 
	    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
	 
	    LET g_tc_mpn01_t = NULL                   #消除鍵值
	    LET g_tc_mpn03_t = NULL                   #消除鍵值
	   
	    LET g_argv1 = ARG_VAL(1)
	 
	    LET p_row = 2 LET p_col = 12
	 
	    OPEN WINDOW p412_w AT p_row,p_col
		 WITH FORM "cxm/42f/cxmp412" 
		  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
	    
	    CALL cl_ui_init()
	 
	     
	 
	    CALL p412_menu()
	 
	    CLOSE WINDOW i412_w                   #結束畫面
	    CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
		 RETURNING g_time                 
	 
	END MAIN     
	 
	#QBE 查詢資料
	FUNCTION p412_curs()
	    CLEAR FORM                            #清除畫面
	    CALL g_tc_mpn.clear()
	    CALL cl_set_head_visible("","YES")       
	 
	    CONSTRUCT g_wc ON                                                          #螢幕上取條件
			      tc_mpn01,tc_mpn02,tc_mpn03,
			      tc_mpn04,tc_mpn05,tc_mpn06,tc_mpn08,
			      tc_mpn09,tc_mpn10,tc_mpn11,tc_mpn12,
			      tc_mpn13,tc_mpn14,tc_mpn15,tc_mpn16,      
			      tc_mpn17,tc_mpn18, 
			      tc_mpndate,tc_mpnplant
		    FROM      
			      s_tc_mpn[1].tc_mpn01,s_tc_mpn[1].tc_mpn02,
			      s_tc_mpn[1].tc_mpn03,                         
			      s_tc_mpn[1].tc_mpn04,s_tc_mpn[1].tc_mpn05,                     
			      s_tc_mpn[1].tc_mpn06,s_tc_mpn[1].tc_mpn08,
			      s_tc_mpn[1].tc_mpn09,s_tc_mpn[1].tc_mpn10,
			      s_tc_mpn[1].tc_mpn11,s_tc_mpn[1].tc_mpn12,
			      s_tc_mpn[1].tc_mpn13,s_tc_mpn[1].tc_mpn14,
			      s_tc_mpn[1].tc_mpn15,s_tc_mpn[1].tc_mpn16,
			      s_tc_mpn[1].tc_mpn17,s_tc_mpn[1].tc_mpn18,
			      s_tc_mpn[1].tc_mpndate,s_tc_mpn[1].tc_mpnplant
			     
	 
		    BEFORE CONSTRUCT
		       CALL cl_qbe_init()
		       DISPLAY g_plant TO tc_mpnplant

	      
		    AFTER FIELD tc_mpn03
		       CALL p412_tc_mpn03('a')
		       LET g_tc_mpn03 = GET_FLDBUF(tc_mpn03)

		    ON ACTION controlp
		       CASE
			  
			  WHEN INFIELD(tc_mpn03) #客戶編號
			       CALL cl_init_qry_var()
			       LET g_qryparam.state = "c"
			       LET g_qryparam.form ="q_occ"
			       CALL cl_create_qry() RETURNING g_qryparam.multiret
			       DISPLAY g_qryparam.multiret TO tc_mpn03 
			       NEXT FIELD tc_mpn03
			  
		  
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

	    LET g_sql= "SELECT UNIQUE tc_mpn03,tc_mpn01 FROM tc_mpn_file ",               
		       " WHERE ", g_wc CLIPPED,
		       "   AND EXISTS ((SELECT 1 FROM zxy_file WHERE tc_mpnplant=zxy03 AND zxy01='",g_user,"') )"
	    PREPARE p412_prepare FROM g_sql      #預備一下
	    DECLARE p412_b_curs                  #宣告成可捲動的
		SCROLL CURSOR WITH HOLD FOR p412_prepare
	    
	    DROP TABLE x
	    LET g_sql = "SELECT COUNT(DISTINCT tc_mpn03||tc_mpn01) FROM tc_mpn_file",
			" WHERE ",g_wc CLIPPED,
			"   AND EXISTS ((SELECT 1 FROM zxy_file WHERE tc_mpnplant=zxy03 AND zxy01='",g_user,"') )"
	    PREPARE p412_precount FROM g_sql
	    DECLARE p412_count CURSOR FOR p412_precount

	    CALL p412_b_fill(g_wc)
	END FUNCTION
	 
	FUNCTION p412_menu()
	 
	   WHILE TRUE
	      CALL p412_bp("G")
	      CASE g_action_choice
		 WHEN "insert" 
		    IF cl_chk_act_auth() THEN
		       LET g_sa = 'a'  #新增
		       LET l_ac = 0    #20230707
		       CALL p412_a()
		    END IF
		 WHEN "query" 
		    IF cl_chk_act_auth() THEN
		       CALL p412_q()
		    END IF
		 WHEN "delete" 
		    IF cl_chk_act_auth() THEN
		       CALL p412_r()
		    END IF
		 WHEN "detail" 
		    IF cl_chk_act_auth() THEN
		       LET g_sa = 'u'
		       CALL p412_b_fill(g_wc)              
		       CALL p412_b()
		    ELSE
		       LET g_action_choice = NULL
		    END IF
		 #- 生管
		 WHEN "modify_date"
		    IF cl_chk_act_auth() THEN
		       LET g_sa = 'm' 
                       CALL update_mpn17()        #20250507 add
		       CALL p412_b_fill(g_wc)     #20250507 mark         
		       CALL p412_b()              #20250507
		       LET g_sa = ''
		    END IF
                 #- 研發-更新料號(S) 20240422
                 WHEN "refresh_item"
                    IF cl_chk_act_auth() THEN
		       CALL p412_b_fill(g_wc)   
                       IF cl_null(g_tc_mpn[l_ac].oeb01) THEN
                          LET g_tc_mpn[l_ac].tc_mpn06=''
                          UPDATE tc_mpn_file SET tc_mpn06=(SELECT ima01 FROM ima_file 
                                                            WHERE ima021=g_tc_mpn[l_ac].tc_mpn05
                                                              AND imaacti='Y' AND ima130='1')
                            WHERE tc_mpn01 = g_tc_mpn[l_ac].tc_mpn01 
                              AND tc_mpn02 = g_tc_mpn[l_ac].tc_mpn02
                              AND tc_mpn03 = g_tc_mpn[l_ac].tc_mpn03
                       END IF
                    END IF
                 #- 研發-更新料號(E) 20240422
		 #- 研發
		 WHEN "create_item"
		    IF cl_chk_act_auth() THEN
		       LET g_sa = 'r' 
                       CALL update_mpn18()       #20250507 add
		       CALL p412_b_fill(g_wc)              
		       CALL p412_b()            
		       LET g_sa = ''
		    END IF
	 
		 WHEN "help" 
		    CALL cl_show_help()
		 WHEN "exit"
		    EXIT WHILE
		 WHEN "controlg"
		    CALL cl_cmdask()
		 WHEN "exporttoexcel"     
		    IF cl_chk_act_auth() THEN
		      CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_mpn),'','')
		    END IF
		 WHEN "related_document"  #相關文件
		      IF cl_chk_act_auth() THEN
			 IF NOT cl_null(g_tc_mpn[l_ac].tc_mpn01) THEN
			    LET g_doc.column1 = "tc_mpn01"
			    LET g_doc.column2 = "tc_mpn03"               #20230814
			    LET g_doc.value1 = g_tc_mpn[l_ac].tc_mpn01
			    LET g_doc.value2 = g_tc_mpn[l_ac].tc_mpn03   #20230814
			    CALL cl_doc()
		       END IF
		 END IF
	      END CASE
	   END WHILE
	END FUNCTION
	 
	 
	FUNCTION p412_a()
	    IF s_shut(0) THEN RETURN END IF
	    MESSAGE ""
	    CLEAR FORM
	    CALL g_tc_mpn.clear()
	    INITIALIZE g_tc_mpn01 LIKE tc_mpn_file.tc_mpn01
	    INITIALIZE g_tc_mpn03 LIKE tc_mpn_file.tc_mpn03
	    CLOSE p412_b_curs
	    LET g_tc_mpn01_t = NULL
	    LET g_tc_mpn03_t = NULL
	    LET g_wc      = NULL
	    CALL cl_opmsg('a')
	    WHILE TRUE
		CALL p412_i("a")                   #輸入單頭
		IF INT_FLAG THEN                   #使用者不玩了
		    LET INT_FLAG = 0
		    CALL cl_err('',9001,0)
		    EXIT WHILE
		END IF
	    
		LET g_rec_b=0                              
		IF g_ss='N' THEN
		    FOR g_cnt = 1 TO g_tc_mpn.getLength()
			INITIALIZE g_tc_mpn[g_cnt].* TO NULL
		    END FOR
		ELSE
		    CALL p412_b_fill(' 1=1')          #單身
		END IF
	 
		CALL p412_b()                        #輸入單身
		IF SQLCA.sqlcode THEN 
		    CALL cl_err(g_tc_mpn01,SQLCA.sqlcode,0)
		END IF
		LET g_tc_mpn01_t = g_tc_mpn01                 #保留舊值
		EXIT WHILE
	    END WHILE
	END FUNCTION
	   
	 
	#處理INPUT
	FUNCTION p412_i(p_cmd)
	DEFINE
	    p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改  
	    l_buf           LIKE type_file.chr1000,       
	    l_n             LIKE type_file.num5         
	 
	    LET g_ss = 'Y'
	    CALL cl_set_head_visible("","YES")       
	 
	    INPUT g_tc_mpn03,g_tc_mpn01 WITHOUT DEFAULTS        
		FROM occ01,tc_mpn01_i                    
	 
		     
	       AFTER FIELD occ01
		   IF g_tc_mpn03 IS NULL THEN
		      NEXT FIELD occ01
		   ELSE 
		      CALL p412_tc_mpn03('a')
		   END IF

	       AFTER FIELD tc_mpn01_i
		   IF cl_null(g_tc_mpn01) THEN
		      NEXT FIELD tc_mpn01
		   END IF


		ON ACTION CONTROLF                  #欄位說明
		   CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
		   CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
		  
	 
		ON ACTION controlp 
		   CASE
		      WHEN INFIELD(occ01) #客戶編號
			   CALL cl_init_qry_var()
			   LET g_qryparam.form ="q_occ"
			   LET g_qryparam.default1 = g_tc_mpn03
			   CALL cl_create_qry() RETURNING g_tc_mpn03
			   NEXT FIELD occ01

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
	END FUNCTION
	 
	   
	FUNCTION p412_tc_mpn03(p_cmd)
	    DEFINE
		   p_cmd   LIKE type_file.chr1,          
		   l_occacti LIKE occ_file.occacti,     
		   l_occ02 LIKE occ_file.occ02
	 
	    LET g_errno = ' '
	    IF g_tc_mpn03 IS NULL THEN
		LET l_occ02 = NULL
	    ELSE
		SELECT occ02,occacti INTO l_occ02,l_occacti FROM occ_file   
		 WHERE occ01 = g_tc_mpn03
	     
		CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2732' 
					       LET l_occ02 = NULL  LET l_occacti = NULL
		     WHEN l_occacti='N' LET g_errno = '9028'
		     OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
		END CASE
	    END IF
	    IF p_cmd = 'd' OR cl_null(g_errno) THEN
		DISPLAY l_occ02 TO occ02 
	    END IF
	END FUNCTION 
	 
	#Query 查詢
	FUNCTION p412_q()
	 
	    LET g_row_count = 0
	    LET g_curs_index = 0
	    CALL cl_navigator_setting( g_curs_index, g_row_count )
	    INITIALIZE g_tc_mpn03 TO NULL               
	    INITIALIZE g_tc_mpn01 TO NULL               
	   
	    CALL cl_opmsg('q')
	 
	    MESSAGE ""                               
	    CLEAR FORM                               
	    CALL g_tc_mpn.clear()
	 
	    CALL p412_curs()                         #取得查詢條件
	 
	    IF INT_FLAG THEN                         #使用者不玩了
		LET INT_FLAG = 0
		RETURN
	    END IF


	    OPEN p412_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
	    IF SQLCA.sqlcode THEN                    #有問題
	       CALL cl_err('',SQLCA.sqlcode,0)
	       INITIALIZE g_tc_mpn03 TO NULL       
	       INITIALIZE g_tc_mpn01 TO NULL       
	    ELSE
	       #CALL p412_fetch('F')            #讀出TEMP第一筆並顯示
	       OPEN p412_count
	       FETCH p412_count INTO g_row_count
	       DISPLAY g_row_count TO FORMONLY.cnt  
	    END IF

	END FUNCTION
	 
	#處理資料的讀取
	FUNCTION p412_fetch(p_flag)
	DEFINE
	    p_flag          LIKE type_file.chr1                  #處理方式      
	 
	    MESSAGE ""
	    CASE p_flag
		WHEN 'N' FETCH NEXT     p412_b_curs INTO g_tc_mpn03,g_tc_mpn01
		WHEN 'P' FETCH PREVIOUS p412_b_curs INTO g_tc_mpn03,g_tc_mpn01
		WHEN 'F' FETCH FIRST    p412_b_curs INTO g_tc_mpn03,g_tc_mpn01
		WHEN 'L' FETCH LAST     p412_b_curs INTO g_tc_mpn03,g_tc_mpn01
		WHEN '/' 
		    IF (NOT mi_no_ask) THEN
		       CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
		       LET INT_FLAG = 0  ######add for prompt bug
		       PROMPT g_msg CLIPPED,': ' FOR g_jump
	      ON IDLE g_idle_seconds
		 CALL cl_on_idle()
	 
	      ON ACTION about       
		 CALL cl_about()     
	 
	      ON ACTION help          
		 CALL cl_show_help() 
	 
	      ON ACTION controlg      
		 CALL cl_cmdask()    
	 
	       END PROMPT
		       IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
		    END IF 
		    FETCH ABSOLUTE g_jump p412_b_curs INTO g_tc_mpn03,g_tc_mpn01
		    LET mi_no_ask = FALSE
	    END CASE
	 
	    IF SQLCA.sqlcode THEN                         #有麻煩
	       CALL cl_err(g_tc_mpn01,SQLCA.sqlcode,0)
	       INITIALIZE g_tc_mpn01 TO NULL 
	    ELSE
	 
	       CASE p_flag
		  WHEN 'F' LET g_curs_index = 1
		  WHEN 'P' LET g_curs_index = g_curs_index - 1
		  WHEN 'N' LET g_curs_index = g_curs_index + 1
		  WHEN 'L' LET g_curs_index = g_row_count
		  WHEN '/' LET g_curs_index = g_jump          --改g_jump
	       END CASE
	    
	       CALL cl_navigator_setting( g_curs_index, g_row_count )
	    END IF
	    CALL p412_show()
	END FUNCTION
	 
	#將資料顯示在畫面上
	FUNCTION p412_show()
	 
	    CALL p412_b_fill(g_wc)                 #單身
	 
	    CALL cl_show_fld_cont()                
	END FUNCTION
	 
	#取消整筆 (所有合乎單頭的資料)
	FUNCTION p412_r()
	    IF s_shut(0) THEN RETURN END IF
	    IF g_tc_mpn01 IS NULL THEN
	       CALL cl_err("",-400,0)                
	       RETURN
	    END IF
	 
	    BEGIN WORK
	 
	    IF cl_delh(0,0) THEN                   #確認一下
		INITIALIZE g_doc.* TO NULL      
		LET g_doc.column1 = "tc_mpn01"      
		LET g_doc.column2 = "tc_mpn03"      
		LET g_doc.value1 = g_tc_mpn01       
		LET g_doc.value2 = g_tc_mpn03     
		CALL cl_del_doc()                
		DELETE FROM tc_mpn_file WHERE tc_mpn01 = g_tc_mpn01 AND tc_mpn03= g_tc_mpn03
		IF SQLCA.sqlcode THEN
		    CALL cl_err3("del","tc_mpn_file",g_tc_mpn01,"",SQLCA.sqlcode,"","BODY DELETE",1)  
		ELSE
		    CLEAR FORM
		    CALL g_tc_mpn.clear()
		    LET g_cnt=SQLCA.SQLERRD[3]
		    MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
		    OPEN p412_count
		    IF STATUS THEN
		       CLOSE p412_b_curs
		       CLOSE p412_count
		       COMMIT WORK
		       RETURN
		    END IF
		    FETCH p412_count INTO g_row_count
		    IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
		       CLOSE p412_b_curs
		       CLOSE p412_count
		       COMMIT WORK
		       RETURN
		    END IF
		    DISPLAY g_row_count TO FORMONLY.cnt
		    OPEN p412_b_curs
		    IF g_curs_index = g_row_count + 1 THEN
		       LET g_jump = g_row_count
		       CALL p412_fetch('L')
		    ELSE
		       LET g_jump = g_curs_index
		       LET mi_no_ask = TRUE
		       CALL p412_fetch('/')
		    END IF
		END IF
	    END IF
	 
	    COMMIT WORK
	 
	END FUNCTION
	 
	#單身
	FUNCTION p412_b()
	DEFINE
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
	   
		"SELECT tc_mpn00,tc_mpn01,tc_mpn02,tc_mpn03,'',",                            
		"       tc_mpn04,tc_mpn05,tc_mpn06,tc_mpn07,tc_mpn08,tc_mpn09,tc_mpn10,tc_mpn19, ",  
		"       tc_mpn11,tc_mpn12,tc_mpn13,tc_mpn14,tc_mpn15,tc_mpn16,tc_mpn17, ",  
		"       tc_mpn18,tc_mpndate,tc_mpnoriu,tc_mpnplant ",
		"  FROM tc_mpn_file ",         
		" WHERE tc_mpn01 = ? AND tc_mpn02 = ? AND tc_mpn05 = ?  AND tc_mpn03 =? FOR UPDATE "  #20230704
	    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
	    DECLARE p412_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
	 
	    LET l_ac_t = 0
	    LET l_allow_insert = cl_detail_input_auth("insert")
	    LET l_allow_delete = cl_detail_input_auth("delete")
	 
	    INPUT ARRAY g_tc_mpn WITHOUT DEFAULTS FROM s_tc_mpn.*
		  ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
			    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
			    APPEND ROW=l_allow_insert)
	 
		BEFORE INPUT
		    IF g_rec_b != 0 THEn
		       CALL fgl_set_arr_curr(l_ac)
		    END IF
		    IF l_ac > 0 THEN
		       IF NOT cl_null(g_tc_mpn[l_ac].oeb01) AND NOT cl_null(g_tc_mpn[l_ac].tc_mpn15) THEN #20231013 add 排交日不可為空
			  RETURN
		       END IF
		    END IF
	 
		BEFORE ROW
		    #新增權限，其他部份填寫欄位鎖定
		    CALL p412_b_no_entry()
		    LET p_cmd = ''
		    LET l_ac = ARR_CURR()
		    LET l_lock_sw = 'N'            #DEFAULT
		    LET l_n  = ARR_COUNT()
	 
		    BEGIN WORK   
		    
		    IF g_rec_b >= l_ac THEN
	 
		       LET p_cmd='u'
		       LET g_tc_mpn_t.* = g_tc_mpn[l_ac].*  #BACKUP
	 
		       OPEN p412_bcl USING g_tc_mpn_t.tc_mpn01, g_tc_mpn_t.tc_mpn02,g_tc_mpn_t.tc_mpn05,g_tc_mpn_t.tc_mpn03 #20230704  
		       IF STATUS THEN
			  CALL cl_err("OPEN p412_bcl:", STATUS, 1)
			  LET l_lock_sw = "Y"
		       ELSE
			  FETCH p412_bcl INTO g_tc_mpn_t.* 
			  IF SQLCA.sqlcode THEN
			      CALL cl_err(g_tc_mpn_t.tc_mpn05,SQLCA.sqlcode,1)
			      LET l_lock_sw = "Y"
			  ELSE
			      LET g_tc_mpn_t.*=g_tc_mpn[l_ac].*
			  END IF
		       END IF
		       CALL cl_show_fld_cont()     
		    END IF
	 
		BEFORE INSERT
		    LET l_n = ARR_COUNT()
		    LET p_cmd='a'
		    INITIALIZE g_tc_mpn[l_ac].* TO NULL
		    LET g_tc_mpn[l_ac].tc_mpn00 = '1' 
		    LET g_tc_mpn[l_ac].tc_mpn01 = g_tc_mpn01 
		    LET g_tc_mpn[l_ac].tc_mpn03 = g_tc_mpn03
		    LET g_tc_mpn[l_ac].tc_mpn04 = 'N'
		    LET g_tc_mpn[l_ac].tc_mpn09 = 'N'
		    LET g_tc_mpn[l_ac].tc_mpn10 = 'N'
		    LET g_tc_mpn[l_ac].tc_mpn11 = 'N'
		    LET g_tc_mpn[l_ac].tc_mpn14 = ''  #20231003
		    LET g_tc_mpn[l_ac].tc_mpn15 = ''  #20231003
		    LET g_tc_mpn[l_ac].tc_mpn16 = ''  #20231003
		    LET g_tc_mpn[l_ac].tc_mpn17 = ''  #20231003
		    LET g_tc_mpn[l_ac].tc_mpn18 = ''  #20231003
		    LET g_tc_mpn[l_ac].tc_mpn02 = ''  #20231003
		    LET g_tc_mpn[l_ac].tc_mpnoriu = g_user
		    LET g_tc_mpn[l_ac].tc_mpnplant = g_plant
		    LET g_tc_mpn_t.* = g_tc_mpn[l_ac].*         #新輸入資料             
		    CALL cl_show_fld_cont()    
		    NEXT FIELD tc_mpn01
		    CALL p412_b_no_entry()
	 
		AFTER INSERT
		    IF INT_FLAG THEN
		       CALL cl_err('',9001,0)
		       LET INT_FLAG = 0
		       CANCEL INSERT
		    END IF

                    ##--- 20231003 mark (S)
                    {
		    #取生管回覆
                    LET g_tc_mpn[l_ac].tc_mpn14='' #20231003
                    LET g_tc_mpn[l_ac].tc_mpn15='' #20231003
                    LET g_tc_mpn[l_ac].tc_mpn16='' #20231003

		    SELECT tc_mpn14,tc_mpn15,tc_mpn16
		      INTO g_tc_mpn[l_ac].tc_mpn14,g_tc_mpn[l_ac].tc_mpn15,g_tc_mpn[l_ac].tc_mpn16
		      FROM tc_mpn_file
		     WHERE tc_mpn01 = g_tc_mpn[l_ac].tc_mpn01
		       AND tc_mpn02 = g_tc_mpn[l_ac].tc_mpn02
		       AND tc_mpn03 = g_tc_mpn[l_ac].tc_mpn03
		       AND tc_mpn14 IS NOT NULL
		    DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn14
		    DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn15
		    DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn16    
                    }
                    ##--- 20231003 mark (E)

                    #判斷料號有效否與是否可販售 20230816
                    SELECT 1 INTO l_cnt
                      FROM ima_file
                     WHERE ima01 = g_tc_mpn[l_ac].tc_mpn06
                       AND (imaacti='N' 
                        OR ima130='0')
                    IF l_cnt = 1 THEN 
                       CALL cl_err('','axm-129',1)
		       LET INT_FLAG = 0
		       CANCEL INSERT
                    END IF
		    
		    INSERT INTO tc_mpn_file(tc_mpn00,tc_mpn01,tc_mpn02,tc_mpn03,tc_mpn04,tc_mpn05,
					    tc_mpn06,tc_mpn07,tc_mpn08,tc_mpn09,tc_mpn10,tc_mpn11,
					    tc_mpn14,tc_mpn15,tc_mpn16,tc_mpn19,
					    tc_mpnoriu,tc_mpnplant,tc_mpndate)
				  VALUES(g_tc_mpn[l_ac].tc_mpn00,
					 g_tc_mpn[l_ac].tc_mpn01,g_tc_mpn[l_ac].tc_mpn02,                     
					 g_tc_mpn[l_ac].tc_mpn03,                                          
					 g_tc_mpn[l_ac].tc_mpn04,g_tc_mpn[l_ac].tc_mpn05,
					 g_tc_mpn[l_ac].tc_mpn06,g_tc_mpn[l_ac].tc_mpn07,
					 g_tc_mpn[l_ac].tc_mpn08,g_tc_mpn[l_ac].tc_mpn09,
					 g_tc_mpn[l_ac].tc_mpn10,g_tc_mpn[l_ac].tc_mpn11,
					 g_tc_mpn[l_ac].tc_mpn14,g_tc_mpn[l_ac].tc_mpn15,
					 g_tc_mpn[l_ac].tc_mpn16,g_tc_mpn[l_ac].tc_mpn19,
					 g_user,g_plant,sysdate)
		    IF SQLCA.sqlcode THEN
		       CALL cl_err3("ins","tc_mpn_file",g_tc_mpn01,g_tc_mpn[l_ac].tc_mpn05,SQLCA.sqlcode,"","",1) 
		       CANCEL INSERT
		    ELSE
		       MESSAGE 'INSERT O.K'
		       LET g_rec_b=g_rec_b+1
		       DISPLAY g_rec_b TO FORMONLY.cn2   
		    END IF
	 
		AFTER FIELD tc_mpn01 
		    IF NOT cl_null(g_tc_mpn[l_ac].tc_mpn01) THEN 
		       IF cl_null(g_tc_mpn[l_ac].tc_mpn02) THEN
			  SELECT MAX(tc_mpn02)+1 INTO g_tc_mpn[l_ac].tc_mpn02
			    FROM tc_mpn_file
			   WHERE tc_mpn01 = g_tc_mpn[l_ac].tc_mpn01
			     AND tc_mpn03 = g_tc_mpn[l_ac].tc_mpn03
			  IF cl_null(g_tc_mpn[l_ac].tc_mpn02) THEN
			     LET g_tc_mpn[l_ac].tc_mpn02 = 1
			  END IF
		       END IF
		    END IF
		    DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn02

		 AFTER FIELD tc_mpn02
		    #結案卡控
		    IF g_sa = 'a' OR p_cmd='a' THEN
		       SELECT 1 INTO l_cnt
			 FROM tc_mpn_file
			WHERE tc_mpn01 = g_tc_mpn[l_ac].tc_mpn01
			  AND tc_mpn02 = g_tc_mpn[l_ac].tc_mpn02
			  AND tc_mpn03 = g_tc_mpn[l_ac].tc_mpn03
			  AND tc_mpn10 = 'N'
			IF l_cnt = 1 THEN
			   CALL cl_err(g_tc_mpn[l_ac].tc_mpn02,'apm1090',1)
			   NEXT FIELD tc_mpn02
			END IF
		     END IF
		    
                    ##---- 20231003 mark (S)
                    {
		    #取生管回覆
                    LET g_tc_mpn[l_ac].tc_mpn14=''  #20231003
                    LET g_tc_mpn[l_ac].tc_mpn15=''  #20231003
                    LET g_tc_mpn[l_ac].tc_mpn16=''  #20231003

		    SELECT tc_mpn14,tc_mpn15,tc_mpn16
		      INTO g_tc_mpn[l_ac].tc_mpn14,g_tc_mpn[l_ac].tc_mpn15,g_tc_mpn[l_ac].tc_mpn16
		      FROM tc_mpn_file
		     WHERE tc_mpn01 = g_tc_mpn[l_ac].tc_mpn01
		       AND tc_mpn02 = g_tc_mpn[l_ac].tc_mpn02
		       AND tc_mpn03 = g_tc_mpn[l_ac].tc_mpn03
		       AND tc_mpn14 IS NOT NULL
		    DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn14
		    DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn15
		    DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn16
                    }
                    ##---- 20231003 mark (E)

		 AFTER FIELD tc_mpn03
		    SELECT occ02 INTO g_tc_mpn[l_ac].occ02
		      FROM occ_file
		     WHERE occ01 = g_tc_mpn[l_ac].tc_mpn03
		    IF cl_null(g_tc_mpn[l_ac].occ02) THEN
		       NEXT FIELD tc_mpn03
		    END IF

		AFTER FIELD tc_mpn04
		    IF g_tc_mpn[l_ac].tc_mpn04='Y' THEN
		       CALL cl_set_comp_entry("tc_mpn06",FALSE)
		       CALL cl_set_comp_required("tc_mpn05",TRUE)
		       LET g_tc_mpn[l_ac].tc_mpn06=''
		    END IF
		    DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn06


		AFTER FIELD tc_mpn05
		    IF NOT cl_null(g_tc_mpn[l_ac].tc_mpn05) THEN
		       CALL cl_set_comp_entry("tc_mpn06",FALSE)
		       IF g_tc_mpn[l_ac].tc_mpn04='N' THEN
			  SELECT ima01 INTO g_tc_mpn[l_ac].tc_mpn06
			    FROM ima_file
			  WHERE ima021 = g_tc_mpn[l_ac].tc_mpn05
                            #AND imaacti='Y'                             #20240823 mark 輸入時不卡控，執行INSERT才可判斷正確 
                            ORDER BY ima01
                           
			  #依客戶規格取得廠內料號、規格
			  IF cl_null(g_tc_mpn[l_ac].tc_mpn06) THEN
			     SELECT ima01,ima021 
			       INTO g_tc_mpn[l_ac].tc_mpn06,g_tc_mpn[l_ac].tc_mpn05
			       FROM ima_file,obk_file
			      WHERE ima01 = obk01 
				AND ta_obk02 = g_tc_mpn[l_ac].tc_mpn05
			  END IF
		       END IF
		    END IF
		    DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn05

		BEFORE FIELD tc_mpn06
		    CALL p412_b_no_entry()

		AFTER FIELD tc_mpn06
		   IF NOT cl_null(g_tc_mpn[l_ac].tc_mpn06) THEN
		      #取料件
		      SELECT ima021 INTO g_tc_mpn[l_ac].tc_mpn05
			FROM ima_file
		      WHERE ima01 = g_tc_mpn[l_ac].tc_mpn06
		      #取客戶料件
		      IF cl_null(g_tc_mpn[l_ac].tc_mpn05) THEN
			 SELECT obk01,ima021 INTO g_tc_mpn[l_ac].tc_mpn06,g_tc_mpn[l_ac].tc_mpn05
			   FROM obk_file,ima_file 
			  WHERE obk03 = g_tc_mpn[l_ac].tc_mpn06
			    AND obk02 = g_tc_mpn03
			    AND obk01 = ima01                   
		      END IF
		   END IF
		   DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn06
		   DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn05

		AFTER FIELD tc_mpn08
		  IF g_tc_mpn[l_ac].tc_mpn08 < g_today THEN
		     NEXT FIELD tc_mpn08
		  END IF
		  DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn08
		
		AFTER FIELD tc_mpn14
		  IF g_tc_mpn[l_ac].tc_mpn14 < g_today THEN
		     NEXT FIELD tc_mpn14
		  END IF
		  DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn14

                ##--- 20231013 排交日為空已轉訂單，清除oeb71拋轉項次 (S)
                BEFORE FIELD tc_mpn15
                  IF cl_null(g_tc_mpn[l_ac].tc_mpn15) THEN
                     UPDATE oeb_file SET oeb71='' 
                      WHERE oeb01 = g_tc_mpn[l_ac].oeb01 AND oeb71= g_tc_mpn[l_ac].tc_mpn02 
                  END IF
                ##--- 20231013 排交日為空已轉訂單，清除oeb71拋轉項次 (E)

		AFTER FIELD tc_mpn15
		  IF g_tc_mpn[l_ac].tc_mpn15 < g_today THEN
		     NEXT FIELD tc_mpn15
		  END IF
		  DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn15


		BEFORE FIELD tc_mpn13
		    CALL p412_b_no_entry()

		AFTER FIELD tc_mpn13
		  IF NOT cl_null(g_tc_mpn[l_ac].tc_mpn13) THEN
		     #先編號料再押規格
		     LET g_tc_mpn[l_ac].tc_mpn06=''
		     SELECT ima01 INTO g_tc_mpn[l_ac].tc_mpn06
		       FROM ima_file
		      WHERE ima021 = g_tc_mpn[l_ac].tc_mpn13
		     IF cl_null(g_tc_mpn[l_ac].tc_mpn06) THEN
			CALL cl_err(g_tc_mpn[l_ac].tc_mpn13,'auto-12',1)
			NEXT FIELD tc_mpn13
		     END IF
		  ELSE
		     LET g_tc_mpn[l_ac].tc_mpn06 = ''
		  END IF
		  DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn13
		  DISPLAY BY NAME g_tc_mpn[l_ac].tc_mpn06

		BEFORE DELETE                            #是否取消單身
		    IF NOT cl_null(g_tc_mpn_t.tc_mpn17) OR NOT cl_null(g_tc_mpn_t.tc_mpn18) THEN
		       CALL cl_err("",'afa-123',1)
		       CANCEL DELETE
		    END IF
		    IF g_tc_mpn_t.tc_mpn01 IS NOT NULL THEN
			
			IF NOT cl_delb(0,0) THEN
			   CANCEL DELETE
			END IF
			
			IF l_lock_sw = "Y" THEN 
			   CALL cl_err("", -263, 1) 
			   CANCEL DELETE 
			END IF 
		       
			DELETE FROM tc_mpn_file
			 WHERE tc_mpn01 = g_tc_mpn_t.tc_mpn01 
			   AND tc_mpn02 = g_tc_mpn_t.tc_mpn02
			   AND tc_mpn05 = g_tc_mpn_t.tc_mpn05   
			IF SQLCA.sqlcode THEN
			   CALL cl_err3("del","tc_mpn_file",g_tc_mpn_t.tc_mpn02,g_tc_mpn_t.tc_mpn01,SQLCA.sqlcode,"","",1)  
			   ROLLBACK WORK
			   CANCEL DELETE 
			END IF
			LET g_rec_b = g_rec_b -1   
			DISPLAY g_rec_b TO FORMONLY.cn2 
			COMMIT WORK
		    END IF
	 
		ON ROW CHANGE
		    IF INT_FLAG THEN
		       CALL cl_err('',9001,0)
		       LET INT_FLAG = 0
		       LET g_tc_mpn[l_ac].* = g_tc_mpn_t.*
		       CLOSE p412_bcl
		       ROLLBACK WORK
		       EXIT INPUT
		    END IF
		    IF l_lock_sw = 'Y' THEN
		       CALL cl_err(g_tc_mpn[l_ac].tc_mpn01,-263,1)
		       LET g_tc_mpn[l_ac].* = g_tc_mpn_t.*
		    ELSE
		       UPDATE tc_mpn_file SET 
					   tc_mpn03=g_tc_mpn[l_ac].tc_mpn03,                                
					   tc_mpn04=g_tc_mpn[l_ac].tc_mpn04,
					   tc_mpn05=g_tc_mpn[l_ac].tc_mpn05,
					   tc_mpn06=g_tc_mpn[l_ac].tc_mpn06,
					   tc_mpn07=g_tc_mpn[l_ac].tc_mpn07,
					   tc_mpn08=g_tc_mpn[l_ac].tc_mpn08,
					   tc_mpn09=g_tc_mpn[l_ac].tc_mpn09,       
					   tc_mpn10=g_tc_mpn[l_ac].tc_mpn10,       
					   tc_mpn19=g_tc_mpn[l_ac].tc_mpn19,       
					   tc_mpn11=g_tc_mpn[l_ac].tc_mpn11,       
					   tc_mpn12=g_tc_mpn[l_ac].tc_mpn12,       
					   tc_mpn13=g_tc_mpn[l_ac].tc_mpn13,       
					   tc_mpn14=g_tc_mpn[l_ac].tc_mpn14,       
					   tc_mpn15=g_tc_mpn[l_ac].tc_mpn15,  
					   tc_mpn16=g_tc_mpn[l_ac].tc_mpn16 
			WHERE tc_mpn01 = g_tc_mpn_t.tc_mpn01 
			  AND tc_mpn02 = g_tc_mpn_t.tc_mpn02
			  AND tc_mpn03 = g_tc_mpn_t.tc_mpn03
			  AND tc_mpn05 = g_tc_mpn_t.tc_mpn05    
		      IF SQLCA.sqlcode THEN
			 CALL cl_err3("upd","tc_mpn_file",g_tc_mpn_t.tc_mpn01,g_tc_mpn_t.tc_mpn02,SQLCA.sqlcode,"","",1) 
			 LET g_tc_mpn[l_ac].* = g_tc_mpn_t.*
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
			  LET g_tc_mpn[l_ac].* = g_tc_mpn_t.*
		     
		       ELSE
			  CALL g_tc_mpn.deleteElement(l_ac)
			  IF g_rec_b != 0 THEN
			     LET g_action_choice = "detail"
			     LET l_ac = l_ac_t
			  END IF
		     
		       END IF
		       CLOSE p412_bcl
		       ROLLBACK WORK
		       EXIT INPUT
		    END IF
		    LET l_ac_t = l_ac   
		    CLOSE p412_bcl
		    COMMIT WORK
	 
		ON ACTION controlp
		   CASE
		      WHEN INFIELD(tc_mpn01) #產品名稱
			   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
			   CALL p412_b_fill(" 1=1")
			   COMMIT WORK
			   LET g_flag = TRUE
			   EXIT INPUT
		    END CASE
	 
		ON ACTION CONTROLO                        #沿用所有欄位
		    IF INFIELD(tc_mpn01) AND l_ac > 1 THEN
		       LET g_tc_mpn[l_ac].* = g_tc_mpn[l_ac-1].*
		       NEXT FIELD tc_mpn01
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
	       CALL p412_b()
	    END IF

	END FUNCTION
	   
	FUNCTION p412_b_askkey()
	DEFINE
	    l_wc            LIKE type_file.chr1000       
	 
	    CONSTRUCT g_wc ON tc_mpn01,tc_mpn02,tc_mpn03,       
			      tc_mpn04,tc_mpn05,tc_mpn06,tc_mpn07,tc_mpn08,tc_mpn09,tc_mpn10    #螢幕上取條件  
		FROM s_tc_mpn[1].tc_mpn01,s_tc_mpn[1].tc_mpn02,s_tc_mpn[1].tc_mpn03,
		     s_tc_mpn[1].tc_mpn04,s_tc_mpn[1].tc_mpn05,                   
		     s_tc_mpn[1].tc_mpn06,s_tc_mpn[1].tc_mpn07,s_tc_mpn[1].tc_mpn08,s_tc_mpn[1].tc_mpn09,
		     s_tc_mpn[1].tc_mpn10

	      BEFORE CONSTRUCT
		CALL cl_qbe_init()

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
	 
	    CALL p412_b_fill(l_wc)
	 
	END FUNCTION
	 
	FUNCTION p412_b_fill(p_wc)              #BODY FILL UP
	DEFINE
	    p_wc            LIKE type_file.chr1000    
	   
	    IF NOT cl_null(g_tc_mpn01) THEN 
	       LET g_sql =
		       "SELECT tc_mpn00,tc_mpn01,tc_mpn02,tc_mpn03,occ02,",  
		       "       tc_mpn04,tc_mpn05,tc_mpn06,tc_mpn07,tc_mpn08,tc_mpn09,",
		       "       tc_mpn10,tc_mpn19,tc_mpn11,tc_mpn12,tc_mpn13,tc_mpn14,tc_mpn15,", 
		       "       tc_mpn16,",
		       "       to_char(tc_mpn17,'yyyy/mm/dd HH24:MI:SS'),",
		       "       to_char(tc_mpn18,'yyyy/mm/dd HH24:MI:SS'),",
		       "       to_char(tc_mpndate,'yyyy/mm/dd HH24:MI:SS'),",
		       "       tc_mpnoriu,tc_mpnplant,'','' ",         
		       " FROM tc_mpn_file,occ_file ",
		       " WHERE tc_mpn03 = occ01 ",
		       "   AND tc_mpn01 = '",g_tc_mpn01,"' AND tc_mpn03 = '",g_tc_mpn03,"' ",
		       "   AND ",p_wc CLIPPED ,
		       "   AND EXISTS ((SELECT 1 FROM zxy_file WHERE tc_mpnplant=zxy03 AND zxy01='",g_user,"') )",
		       " ORDER BY tc_mpn01,tc_mpn02,tc_mpn03,tc_mpn04 "
	    ELSE
	       LET g_sql =
		       "SELECT tc_mpn00,tc_mpn01,tc_mpn02,tc_mpn03,occ02,",
		       "       tc_mpn04,tc_mpn05,tc_mpn06,tc_mpn07,tc_mpn08,tc_mpn09,",
		       "       tc_mpn10,tc_mpn19,tc_mpn11,tc_mpn12,tc_mpn13,tc_mpn14,tc_mpn15,",
		       "       tc_mpn16,",
		       "       to_char(tc_mpn17,'yyyy/mm/dd HH24:MI:SS'),",
		       "       to_char(tc_mpn18,'yyyy/mm/dd HH24:MI:SS'),",
		       "       to_char(tc_mpndate,'yyyy/mm/dd HH24:MI:SS'),",
		       "       tc_mpnoriu,tc_mpnplant,'','' ",
		       " FROM tc_mpn_file,occ_file ",
		       " WHERE tc_mpn03 = occ01 ",
			"  AND EXISTS ((SELECT 1 FROM zxy_file WHERE tc_mpnplant=zxy03 AND zxy01='",g_user,"') )",
		       "   AND ",p_wc CLIPPED ,
		       " ORDER BY tc_mpn01,tc_mpn02,tc_mpn03,tc_mpn04 "
	    END IF
	    PREPARE p412_p2 FROM g_sql      #預備一下
	    DECLARE tc_mpn_curs CURSOR FOR p412_p2
	 
	    CALL g_tc_mpn.clear()
	    LET g_cnt = 1
	 
	    FOREACH tc_mpn_curs INTO g_tc_mpn[g_cnt].*   #單身 ARRAY 填充
		IF SQLCA.sqlcode THEN
		    CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
		    EXIT FOREACH
		END IF
 
	      
		##-訂單
		IF cl_null(g_tc_mpn[g_cnt].oeb01) THEN
		   SELECT oeb01 INTO g_tc_mpn[g_cnt].oeb01
		     FROM oeb_file,oea_file
		    WHERE oeb01 = oea01
		      AND oea03 = g_tc_mpn[g_cnt].tc_mpn03            
		      AND oea10 = g_tc_mpn[g_cnt].tc_mpn01              
                      AND ((oeb71 = g_tc_mpn[g_cnt].tc_mpn02)
		      OR  (oeb04 = g_tc_mpn[g_cnt].tc_mpn06
		      AND oeb15 = g_tc_mpn[g_cnt].tc_mpn14))
                      AND oeaconf <> 'X'                                #240202 add by ruby
		END IF
		#-BOM發放日
		IF cl_null(g_tc_mpn[g_cnt].bma05) THEN
		   SELECT bma05 INTO g_tc_mpn[g_cnt].bma05
		     FROM bma_file
		    WHERE bma01 = g_tc_mpn[g_cnt].tc_mpn06
		END IF
                ##---- 20250507 mark (S)
		#--生管確認日
		#IF g_sa = 'm' AND cl_null(g_tc_mpn[g_cnt].tc_mpn17) THEN
		#   UPDATE tc_mpn_file SET tc_mpn17 = sysdate 
		#    WHERE tc_mpn01 = g_tc_mpn[g_cnt].tc_mpn01
		#      AND tc_mpn02 = g_tc_mpn[g_cnt].tc_mpn02
		#      AND tc_mpn03 = g_tc_mpn[g_cnt].tc_mpn03
		#      AND tc_mpn05 = g_tc_mpn[g_cnt].tc_mpn05
		#      AND tc_mpn17 IS NULL
		#END IF
                ##---- 20250507 mark (E)
	 
                ##---- 20250507 mark (S)
		#--研發確認日
		#IF g_sa = 'r' AND cl_null(g_tc_mpn[g_cnt].tc_mpn18) THEN
		#   UPDATE tc_mpn_file SET tc_mpn18 = sysdate 
		#    WHERE tc_mpn01 = g_tc_mpn[g_cnt].tc_mpn01
		#      AND tc_mpn02 = g_tc_mpn[g_cnt].tc_mpn02
		#      AND tc_mpn03 = g_tc_mpn[g_cnt].tc_mpn03
		#      AND tc_mpn05 = g_tc_mpn[g_cnt].tc_mpn05
		#      AND tc_mpn18 IS NULL
		#END IF
                ##---- 20250507 mark (E)

		#--更新料號、結案碼
		IF cl_null(g_tc_mpn[g_cnt].tc_mpn06) AND g_tc_mpn[g_cnt].tc_mpn10='N' 
						     AND g_tc_mpn[g_cnt].tc_mpn11='N' THEN
                   IF g_tc_mpn[g_cnt].tc_mpn04='N' THEN
                      SELECT ima01 INTO g_tc_mpn[g_cnt].tc_mpn06
                        FROM ima_file
                       WHERE ima021 = g_tc_mpn[g_cnt].tc_mpn05
                         AND imaacti='Y' AND ima130='1'            #20240823   
                   ELSE
                      SELECT ima01 INTO g_tc_mpn[g_cnt].tc_mpn06
                        FROM ima_file 
                       WHERE ima021 = g_tc_mpn[g_cnt].tc_mpn13
                         AND imaacti='Y' AND ima130='1'            #20240823   
                   END IF

                      UPDATE tc_mpn_file SET tc_mpn06 = g_tc_mpn[g_cnt].tc_mpn06,
                                             tc_mpn10 = g_tc_mpn[g_cnt].tc_mpn10
                       WHERE tc_mpn01 = g_tc_mpn[g_cnt].tc_mpn01
                         AND tc_mpn02 = g_tc_mpn[g_cnt].tc_mpn02
                         AND tc_mpn03 = g_tc_mpn[g_cnt].tc_mpn03
                         AND tc_mpn05 = g_tc_mpn[g_cnt].tc_mpn05
                         AND tc_mpn06 IS NULL
                END IF                                        

		LET g_cnt = g_cnt + 1
	      
		IF g_cnt > g_max_rec THEN
		   CALL cl_err( '', 9035, 0 )
		   EXIT FOREACH
		END IF
	     
	    END FOREACH
	    CALL g_tc_mpn.deleteElement(g_cnt)
	 
	    LET g_rec_b = g_cnt - 1               #告訴I.單身筆數
	    DISPLAY g_rec_b TO FORMONLY.cn2       
	    
	END FUNCTION
	 
	FUNCTION p412_bp(p_ud)
	   DEFINE   p_ud   LIKE type_file.chr1         
	 
	 
	   IF p_ud <> "G" OR g_action_choice = "detail" THEN
	      RETURN
	   END IF
	 
	   LET g_action_choice = " "
	 
	   CALL cl_set_act_visible("accept,cancel", FALSE)
	   DISPLAY ARRAY g_tc_mpn TO s_tc_mpn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
	 
	      BEFORE DISPLAY
		 CALL cl_navigator_setting( g_curs_index, g_row_count )
	 
	      BEFORE ROW
		 LET l_ac = ARR_CURR()
                 IF l_ac2 > 0 THEN
                    CALL fgl_set_arr_curr(l_ac2)
                    LET l_ac = l_ac2
                    LET l_ac2 = 0
                 END IF
		 CALL cl_show_fld_cont()                   
	 
	      ##########################################################################
	      # Standard 4ad ACTION
	      ##########################################################################
	      ON ACTION insert
		 LET g_action_choice="insert"
		 EXIT DISPLAY
	      ON ACTION query
		 LET g_action_choice="query"
		 EXIT DISPLAY
	      ON ACTION delete
		 LET g_action_choice="delete"
		 EXIT DISPLAY
	      ON ACTION first 
		 CALL p412_fetch('F')
		 CALL cl_navigator_setting(g_curs_index, g_row_count)   
		 IF g_rec_b != 0 THEN
		    CALL fgl_set_arr_curr(1)  
		 END IF
		 ACCEPT DISPLAY                   
				      
	 
	      ON ACTION previous
		 CALL p412_fetch('P')
		 CALL cl_navigator_setting(g_curs_index, g_row_count)   
		 IF g_rec_b != 0 THEN
		    CALL fgl_set_arr_curr(1)
		 END IF
		     ACCEPT DISPLAY                  
				       
	      ON ACTION jump 
		 CALL p412_fetch('/')
		 CALL cl_navigator_setting(g_curs_index, g_row_count) 
		 IF g_rec_b != 0 THEN
		    CALL fgl_set_arr_curr(1) 
		 END IF
		     ACCEPT DISPLAY                   
				       
	      ON ACTION next
		 CALL p412_fetch('N')
		 CALL cl_navigator_setting(g_curs_index, g_row_count)   
		 IF g_rec_b != 0 THEN
		    CALL fgl_set_arr_curr(1)  
		 END IF
		     ACCEPT DISPLAY                 
				       
	      ON ACTION last 
		 CALL p412_fetch('L')
		 CALL cl_navigator_setting(g_curs_index, g_row_count)  
		 IF g_rec_b != 0 THEN
		    CALL fgl_set_arr_curr(1) 
		 END IF
		     ACCEPT DISPLAY                   
				       
	      ON ACTION detail
		 LET g_action_choice="detail"
		 LET l_ac = ARR_CURR()
		 EXIT DISPLAY

	      ON ACTION modify_date
		 LET g_action_choice="modify_date"
		 LET l_ac = ARR_CURR()
		 EXIT DISPLAY

              ##--- 20240422 add (S) 料號更新
	      ON ACTION refresh_item
		 LET g_action_choice="refresh_item"
		 LET l_ac = ARR_CURR()
		 EXIT DISPLAY
              ##--- 20240422 add (E)
		 
	      ON ACTION create_item
		 LET g_action_choice="create_item"
		 LET l_ac = ARR_CURR()
		 EXIT DISPLAY

	      ON ACTION refresh_detail
		 LET g_action_choice="refresh_detail"
		 LET  g_idle_seconds = 0
		 CALL p412_b_fill(g_wc)   
	     
              #--- 20230913 轉訂單
              ON ACTION transfer_so
                 LET g_msg = "cxmp413"
                 CALL cl_cmdrun(g_msg)
                 EXIT DISPLAY
 
	      ON ACTION axmt410
		 LET g_msg = " axmt410 '", g_tc_mpn[l_ac].oeb01,"'"
		 CALL cl_cmdrun_wait(g_msg CLIPPED)
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
	 
	      ON ACTION related_document                #相關文件
		 LET g_action_choice="related_document"          
		 LET l_ac2 = l_ac                       #20230816
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p412_b_no_entry()
   DEFINE  l_cnt   LIKE type_file.num5

   LET l_ac = ARR_CURR()
   CALL cl_set_comp_entry("tc_mpn00,tc_mpn01,tc_mpn02,tc_mpn03,tc_mpn04,tc_mpn05,
                           tc_mpn06,tc_mpn07,tc_mpn08,tc_mpn09,tc_mpn10,tc_mpn11,
                           tc_mpn12,tc_mpn13,tc_mpn14,tc_mpn15,tc_mpn16,tc_mpn17,
                           tc_mpn18,tc_mpn19",FALSE)
   #-- 生管
   IF g_sa = 'm' THEN
      CALL cl_set_comp_entry("tc_mpn14,tc_mpn15,tc_mpn16",TRUE)
   END IF

   #-- 研發
   IF g_sa = 'r' THEN
      CALL cl_set_comp_entry("tc_mpn11,tc_mpn12",TRUE)
      IF g_tc_mpn[l_ac].tc_mpn04='Y' THEN
         IF NOT cl_null(g_tc_mpn[l_ac].tc_mpn06) THEN
            SELECT 1 INTO l_cnt FROM oea_file,oeb_file
             WHERE oea01 = oeb01
               AND oea10 = g_tc_mpn[l_ac].tc_mpn01
               AND oeb04 = g_tc_mpn[l_ac].tc_mpn06
               AND oeaconf <> 'X'
            IF l_cnt=0 THEN
               CALL cl_set_comp_entry("tc_mpn13",TRUE)
            END IF
          ELSE
               CALL cl_set_comp_entry("tc_mpn13",TRUE)
         END IF
      END IF
   END IF

   #-- 銷售
   IF g_sa = 'a' or g_sa='u' THEN
      CALL cl_set_comp_entry("tc_mpn10,tc_mpn19",TRUE)

      IF l_ac = 0 THEN
         CALL cl_set_comp_entry("tc_mpn00,tc_mpn01,tc_mpn02,tc_mpn03,tc_mpn04,tc_mpn05,tc_mpn06,tc_mpn07,tc_mpn08,tc_mpn09,tc_mpn19",TRUE)
         RETURN
      END IF

      IF cl_null(g_tc_mpn[l_ac].tc_mpn17) AND cl_null(g_tc_mpn[l_ac].tc_mpn18) THEN
         CALL cl_set_comp_entry("tc_mpn00,tc_mpn01,tc_mpn02,tc_mpn03,tc_mpn04,tc_mpn05,tc_mpn06,tc_mpn07,tc_mpn08,tc_mpn09,tc_mpn19",TRUE)
      END IF   
   END IF

END FUNCTION 

##--更新研發確認日
FUNCTION update_mpn18()

   FOR g_cnt = 1 TO g_tc_mpn.getLength()
       UPDATE tc_mpn_file SET tc_mpn18 = sysdate
        WHERE tc_mpn01 = g_tc_mpn[g_cnt].tc_mpn01
          AND tc_mpn02 = g_tc_mpn[g_cnt].tc_mpn02
          AND tc_mpn03 = g_tc_mpn[g_cnt].tc_mpn03
          AND tc_mpn05 = g_tc_mpn[g_cnt].tc_mpn05
          AND tc_mpn18 IS NULL
   END FOR
END FUNCTION

##--更新生管確認日
FUNCTION update_mpn17()
   FOR g_cnt = 1 TO g_tc_mpn.getLength()
     UPDATE tc_mpn_file SET tc_mpn17 = sysdate
      WHERE tc_mpn01 = g_tc_mpn[g_cnt].tc_mpn01
        AND tc_mpn02 = g_tc_mpn[g_cnt].tc_mpn02
        AND tc_mpn03 = g_tc_mpn[g_cnt].tc_mpn03
        AND tc_mpn05 = g_tc_mpn[g_cnt].tc_mpn05
        AND tc_mpn17 IS NULL
   END FOR
END FUNCTION
