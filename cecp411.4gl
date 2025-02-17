# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cecp411.4gl
# Descriptions...: 工單製程完工日修改作業
# Date & Author..: 20180515 By momo
# Modify.........: 20180817 By momo 增加可修改製程開工日

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
    tm  RECORD
     	wc  	STRING,		
       	wc2  	STRING,
        ecm50_new LIKE ecm_file.ecm50,
        ecm51_new LIKE ecm_file.ecm51
        END RECORD,
    g_sfb   RECORD
            ta_sfb01   LIKE sfb_file.ta_sfb01
        END RECORD,
    g_ecm DYNAMIC ARRAY OF RECORD
            ecm01   LIKE ecm_file.ecm01,
            sfb05   LIKE sfb_file.sfb05,
            ima02   LIKE ima_file.ima02,
            ima021  LIKE ima_file.ima021,     
            sfb13   LIKE sfb_file.sfb13,
            sfb15   LIKE sfb_file.sfb15,
            ecm03   LIKE ecm_file.ecm03,       
            ecm04   LIKE ecm_file.ecm04,       
            ecm45   LIKE ecm_file.ecm45,       
            ecm50   LIKE ecm_file.ecm50,
            ecm51   LIKE ecm_file.ecm51
        END RECORD,
    g_argv1              LIKE sfb_file.ta_sfb01,
    g_before_input_done  LIKE type_file.num5,    #No.FUN-680137 SMALLINT
    g_query_flag         LIKE type_file.num5,    #第一次進入程式時即進入Query之後進入next  #No.FUN-680137 SMALLINT
    g_wc,g_wc2,g_sql    STRING,  #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b              LIKE type_file.num10    #單身筆數  #No.FUN-680137 INTEGER
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   l_ac            LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("cec")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  

    LET g_query_flag=1
 
    OPEN WINDOW p411_w WITH FORM "cec/42f/cecp411" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL p411_q() END IF
    WHILE TRUE
      LET g_action_choice = ""
      CALL p411_menu()
      IF g_action_choice = 'exit' THEN EXIT WHILE END IF
    END WHILE

    CLOSE WINDOW p411_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION p411_cs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "ta_sfb01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_ecm.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")       
 
   INITIALIZE g_sfb.* TO NULL    
           CONSTRUCT BY NAME tm.wc ON ta_sfb01,sfb01
           
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()     
 
           
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
           END CONSTRUCT
           LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
           IF INT_FLAG THEN RETURN END IF
           ##----- 20181015 add (S)
           INPUT BY NAME tm.ecm50_new,tm.ecm51_new WITHOUT DEFAULTS
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT
              ON ACTION exit                            #加離開功能
                 LET INT_FLAG = 1
                 EXIT INPUT
           END INPUT
           ##----- 20181015 add (E)
           CALL p411_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT ' 
   
    
   LET g_sql=" SELECT  DISTINCT(NVL(ta_sfb01,sfb01)) FROM sfb_file,ecm_file ",
             "  WHERE sfb01=ecm01 AND",
             "        ",tm.wc CLIPPED, " AND ",tm.wc2 CLIPPED,
             "    AND  sfb04<8 AND sfb87 <>'X' " 
   #END IF  #MOD-G70153 mark
 
   PREPARE p411_prepare FROM g_sql
   DECLARE p411_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR p411_prepare
 

   LET g_sql=" SELECT COUNT(DISTINCT NVL(ta_sfb01,sfb01)) FROM sfb_file,ecm_file ",
              "  WHERE sfb01=ecm01 AND ",
              "     ",tm.wc CLIPPED ,
              "    AND ",tm.wc2 CLIPPED,
              "    AND  sfb04<8 AND sfb87 <>'X' " 
            
   
 
   PREPARE p411_pp  FROM g_sql
   DECLARE p411_cnt   CURSOR FOR p411_pp
END FUNCTION
 
FUNCTION p411_b_askkey()
   CONSTRUCT tm.wc2 ON ecm01,sfb05,sfb13,sfb15,ecm03,ecm04,ecm45,
                        ecm50,ecm51 
                  FROM s_ecm[1].ecm01,s_ecm[1].sfb05,s_ecm[1].sfb13,
                        s_ecm[1].sfb15,s_ecm[1].ecm03,           
                       s_ecm[1].ecm04,s_ecm[1].ecm45,s_ecm[1].ecm50,
                       s_ecm[1].ecm51
       
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
 
   
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
END FUNCTION
 
#中文的MENU
FUNCTION p411_menu()
   WHILE TRUE
      CALL p411_bp("G")
      CASE g_action_choice
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL p411_q()
            END IF
           WHEN "modify_schedule" 
                 IF cl_chk_act_auth() THEN 
                    CALL p411_b() 
                 END IF
           WHEN "next" 
            CALL p411_fetch('N')
           WHEN "previous" 
            CALL p411_fetch('P')
           WHEN "help" 
            CALL cl_show_help()
           WHEN "exit"
            EXIT WHILE
           WHEN "jump"
            CALL p411_fetch('/')
           WHEN "controlg"  #KEY(CONTROL-G)
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p411_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL p411_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN p411_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN p411_cnt
       FETCH p411_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt  
       CALL p411_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION p411_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680137 VARCHAR(1)
    l_sfbuser       LIKE sfb_file.sfbuser, 
    l_sfbgrup       LIKE sfb_file.sfbgrup 

 
    CASE p_flag
        WHEN 'N' FETCH NEXT     p411_cs INTO g_sfb.ta_sfb01
        WHEN 'P' FETCH PREVIOUS p411_cs INTO g_sfb.ta_sfb01
        WHEN 'F' FETCH FIRST    p411_cs INTO g_sfb.ta_sfb01
        WHEN 'L' FETCH LAST     p411_cs INTO g_sfb.ta_sfb01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump p411_cs INTO g_sfb.ta_sfb01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfb.ta_sfb01,SQLCA.sqlcode,0)
        INITIALIZE g_sfb.* TO NULL  
        LET g_sfb.ta_sfb01 = NULL      
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
    SELECT DISTINCT(ta_sfb01)
      INTO g_sfb.ta_sfb01          
      FROM sfb_file
     WHERE ta_sfb01 = g_sfb.ta_sfb01
        OR sfb01 = g_sfb.ta_sfb01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sfb_file",g_sfb.ta_sfb01,"",SQLCA.sqlcode,"","",0)   
       INITIALIZE g_sfb.* TO NULL    
       RETURN
    END IF
    LET g_data_owner = l_sfbuser     
    LET g_data_group = l_sfbgrup     
    LET g_data_keyvalue = g_sfb.ta_sfb01 
    CALL p411_show()
END FUNCTION
 
FUNCTION p411_show()
   LET g_data_keyvalue = g_sfb.ta_sfb01       
  
  
   DISPLAY BY NAME g_sfb.*   # 顯示單頭值
   CALL p411_b_fill() #單身
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION p411_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF

   IF NOT cl_null(g_sfb.ta_sfb01) THEN
   LET l_sql =
       
        "SELECT ecm01,sfb05,ima02,ima021,sfb13,sfb15,",    
        "      ecm03,ecm04,ecm45,",
        "             ecm50,ecm51 ",  
        "  FROM sfb_file,ecm_file, ima_file ",      
        " WHERE ta_sfb01 = '",g_sfb.ta_sfb01,"' ", " AND ", tm.wc2 CLIPPED, "AND ", tm.wc CLIPPED,
        "   AND sfb04 < 8 AND sfb87 !='X' ", 
        "   AND sfb01 = ecm01 AND sfb05=ima01 ",                                  
        " ORDER BY 1"
    ELSE
    LET l_sql =

        "SELECT ecm01,sfb05,ima02,ima021,sfb13,sfb15,",
        "      ecm03,ecm04,ecm45,",
        "             ecm50,ecm51 ",
        "  FROM sfb_file,ecm_file, ima_file ",
        " WHERE  ", tm.wc2 CLIPPED, "AND ", tm.wc CLIPPED,
        "   AND sfb04 < 8 AND sfb87 !='X' ",
        "   AND sfb01 = ecm01 AND sfb05=ima01 ",
        " ORDER BY 1"
    END IF
    PREPARE p411_pb FROM l_sql
    DECLARE p411_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR p411_pb
 
    FOR g_cnt = 1 TO g_ecm.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_ecm[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH p411_bcs INTO g_ecm[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ecm.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
END FUNCTION
 
FUNCTION p411_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_ud <> "G" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_ecm TO s_ecm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION modify_schedule
           LET g_action_choice="modify_schedule" 
           EXIT DISPLAY
 
        ON ACTION query       
           LET g_action_choice="query" 
           EXIT DISPLAY
 
        ON ACTION next
           CALL p411_fetch('N')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION previous
           CALL p411_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION first
           CALL p411_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION last
           CALL p411_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION jump
           CALL p411_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION help
           LET g_action_choice="help"    
           EXIT DISPLAY
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           EXIT DISPLAY
 
        ON ACTION exit
           LET g_action_choice="exit"    
           EXIT DISPLAY
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      #No.MOD-530688  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
      #No.MOD-530688  --end          
       ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
    
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p411_b()
    DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
    DEFINE l_ac,l_sl	   LIKE type_file.num5,      #No.FUN-680137 SMALLINT
           l_sn1,l_sn2     LIKE type_file.num5,      #No.FUN-680137      #No:7576 add  SMALLINT
           l_cnt           LIKE type_file.num5
 
    CALL cl_opmsg('b')
    CALL SET_COUNT(g_rec_b)   #告訴I.單身筆數
    INPUT ARRAY g_ecm WITHOUT DEFAULTS FROM s_ecm.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
        BEFORE INPUT
            LET g_before_input_done = FALSE
            LET g_before_input_done = TRUE
        BEFORE ROW
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_sl = SCR_LINE()
            CALL cl_qbe_display_condition(lc_qbe_sn)

        ##---- 20181015 add by momo (S)
        IF NOT cl_null(tm.ecm50_new) THEN
           IF cl_confirm('cec-309')  THEN
              UPDATE ecm_file SET ecm50 = tm.ecm50_new,ecm51=tm.ecm51_new
               WHERE ecm01 = g_ecm[l_ac].ecm01
              CALL p411_show()
           END IF
        END IF
        ##---- 20181015 add by momo (E)
 
        AFTER FIELD ecm50  
           IF g_ecm[l_ac].ecm50 < g_today THEN   
              CALL cl_err('','cec-308',1) 
              #NEXT FIELD ecm51 
           END IF 
           DISPLAY BY NAME g_ecm[l_ac].ecm51              

        AFTER FIELD ecm51  
           IF g_ecm[l_ac].ecm51 < g_today THEN   
              CALL cl_err('','cec-308',1) 
              #NEXT FIELD ecm51 
           END IF 
           DISPLAY BY NAME g_ecm[l_ac].ecm51              
 
        ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
         
             UPDATE ecm_file SET
                ecm51 =g_ecm[l_ac].ecm51,
                ecm50 =g_ecm[l_ac].ecm50,
                ecmmodu=g_user,
                ecmdate=g_today
                WHERE ecm01 =g_ecm[l_ac].ecm01 AND ecm03=g_ecm[l_ac].ecm03
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err('upd ecm:',SQLCA.SQLCODE,0)
            END IF

        AFTER ROW
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
          
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON ACTION CONTROLP
           CASE  
                WHEN INFIELD(ecm01) 

                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_sfb"
                       LET g_qryparam.construct = 'N'
                       LET g_qryparam.default1 = g_ecm[l_ac].ecm01                      
                       CALL cl_create_qry() RETURNING g_ecm[l_ac].ecm01
                       DISPLAY BY NAME g_ecm[l_ac].ecm01
           END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
    END INPUT
END FUNCTION
 

