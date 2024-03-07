# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cecp412.4gl
# Descriptions...: 工單製程日、機器編號修改作業
# Date & Author..: 20190812 By momo
# Modify.........: NO:1908163487 20190822 By momo 剔除aeci700之ecm52(委外)打V者
# Modify.........: NO:2002244314 20200302 By momo 查詢增加「工作站」ecm06、輸入增加標準等待時間 ecm18
# Modify.........: NO:2009115187 20200914 By momo 查詢時當標準產出量-良品轉出-當站報廢等於0時，該站就不顯示
# Modify.........: No:2010195337 20201022 By momo 製程開工日變動後大於製程完工日時，製程完工日為空白
# Modify.........: NO:24020018   20240223 By momo 增加sfbud01欄位，供生管維護

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
           ta_sfb01 LIKE sfb_file.ta_sfb01,
            ecm01   LIKE ecm_file.ecm01,
            sfb05   LIKE sfb_file.sfb05,
            ima02   LIKE ima_file.ima02,
            ima021  LIKE ima_file.ima021,  
            sfb08   LIKE sfb_file.sfb08,   
            sfb09   LIKE sfb_file.sfb09,   
            sfb13   LIKE sfb_file.sfb13,
            sfb15   LIKE sfb_file.sfb15,
            sfbud01 LIKE sfb_file.sfbud01,    #20240223
            ecm03   LIKE ecm_file.ecm03,       
            ecm04   LIKE ecm_file.ecm04,       
            ecm45   LIKE ecm_file.ecm45,       
            ecm06   LIKE ecm_file.ecm06,  #工作站 20200302 add        
            ecm18   LIKE ecm_file.ecm18,  #標準作業時間 20200302 add        
            ecm50   LIKE ecm_file.ecm50,
            ecm51   LIKE ecm_file.ecm51,
            ecm05   LIKE ecm_file.ecm05,
            eci06   LIKE eci_file.eci06
        END RECORD,
    g_argv1              LIKE sfb_file.ta_sfb01,
    g_before_input_done  LIKE type_file.num5,    #No.FUN-680137 SMALLINT
    g_query_flag         LIKE type_file.num5,    #第一次進入程式時即進入Query之後進入next  #No.FUN-680137 SMALLINT
    g_wc,g_wc2,g_sql    STRING,  #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b              LIKE type_file.num10    #單身筆數  #No.FUN-680137 INTEGER
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   l_ac            LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_no_ask        LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_ac2           LIKE type_file.num5          #20240226 保存當前行數
 
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
 
    OPEN WINDOW p412_w WITH FORM "cec/42f/cecp412" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL p412_q() END IF
    WHILE TRUE
      LET g_action_choice = ""
      CALL p412_menu()
      IF g_action_choice = 'exit' THEN EXIT WHILE END IF
    END WHILE

    CLOSE WINDOW p412_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
{
FUNCTION p412_cs()
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
         #ON ACTION qbe_select
         #   CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
           END CONSTRUCT
         #  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
         #  IF INT_FLAG THEN RETURN END IF
         #  ##----- 20181015 add (S)
         #  INPUT BY NAME tm.ecm50_new,tm.ecm51_new WITHOUT DEFAULTS
         #     ON IDLE g_idle_seconds
         #        CALL cl_on_idle()
         #        CONTINUE INPUT
         #     ON ACTION exit                            #加離開功能
         #        LET INT_FLAG = 1
         #        EXIT INPUT
         #  END INPUT
         #  ##----- 20181015 add (E)
           CALL p412_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT ' 
   
    
   LET g_sql=" SELECT  DISTINCT(NVL(ta_sfb01,sfb01)) FROM sfb_file,ecm_file ",
             "  WHERE sfb01=ecm01 AND",
             "        ",tm.wc CLIPPED, " AND ",tm.wc2 CLIPPED,
             "    AND ecm65 - ecm311 - ecm313 >0 ",  #20200914 add
             "    AND  sfb04<8 AND sfb87 <>'X' " 
   #END IF  #MOD-G70153 mark
 
   PREPARE p412_prepare FROM g_sql
   DECLARE p412_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR p412_prepare
 

   LET g_sql=" SELECT COUNT(DISTINCT NVL(ta_sfb01,sfb01)) FROM sfb_file,ecm_file ",
              "  WHERE sfb01=ecm01 AND ",
              "     ",tm.wc CLIPPED ,
              "    AND ",tm.wc2 CLIPPED,
              "    AND ecm65 - ecm311 - ecm313 >0 ",  #20200914 add
              "    AND  sfb04<8 AND sfb87 <>'X' " 
            
   
 
   PREPARE p412_pp  FROM g_sql
   DECLARE p412_cnt   CURSOR FOR p412_pp
END FUNCTION
}
 
FUNCTION p412_b_askkey()
   CONSTRUCT tm.wc2 ON ta_sfb01,ecm01,sfb05,sfb13,sfb15,ecm03,ecm04,ecm45,
                        ecm06,ecm18,                                         #20200302
                        ecm50,ecm51,ecm05 
                  FROM s_ecm[1].ta_sfb01,
                       s_ecm[1].ecm01,s_ecm[1].sfb05,s_ecm[1].sfb13,
                       s_ecm[1].sfb15,s_ecm[1].ecm03,           
                       s_ecm[1].ecm04,s_ecm[1].ecm45,
                       s_ecm[1].ecm06,s_ecm[1].ecm18,                        #20200302
                       s_ecm[1].ecm50,
                       s_ecm[1].ecm51,s_ecm[1].ecm05
       
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
      
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
     #FUN-530065
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(ecm01)
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form     = "q_sfb"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ecm01
          WHEN INFIELD(sfb05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"    #FUN-AB0025 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb05
               NEXT FIELD sfb05
          WHEN INFIELD(ecm04)                 #作業編號
               CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ecm04
               NEXT FIELD ecm04
          ##---- 20200302
          WHEN INFIELD(ecm06)                 #工作站
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form     = "q_eca1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ecm06
               NEXT FIELD ecm06
      
          WHEN INFIELD(ecm05)                 #機械編號
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form     = "q_eci"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ecm05
              NEXT FIELD ecm05
         OTHERWISE
            EXIT CASE
       END CASE 
 
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

   LET g_sql=" SELECT COUNT(DISTINCT NVL(ta_sfb01,sfb01)) FROM sfb_file,ecm_file ",
              "  WHERE sfb01=ecm01 ",
              "    AND ",tm.wc2 CLIPPED,
              "    AND ecm65 - ecm311 - ecm313 >0 ",  #20200914 add
              "    AND  sfb04<8 AND sfb87 <>'X' "



   PREPARE p412_pp  FROM g_sql
   DECLARE p412_cnt   CURSOR FOR p412_pp

END FUNCTION
 
#中文的MENU
FUNCTION p412_menu()
   WHILE TRUE
      CALL p412_bp("G")
      CASE g_action_choice
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL p412_q()
            END IF
           WHEN "detail" 
            IF cl_chk_act_auth() THEN 
               CALL p412_b() 
            END IF


           ##----- 20210331 add by momo (S)
           WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN                                                                     
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecm),'','')   
             END IF
           ##----- 20210331 add by momo (E)

           ##---- 20240223 add by momo (S)
           WHEN "modify_sfbud01"
             IF cl_chk_act_auth() THEN
                CALL p412_modify_sfbud01()
             END IF
           ##---- 20240223 add by momo (E)
           
          # WHEN "next" 
          #  CALL p412_fetch('N')
          # WHEN "previous" 
          #  CALL p412_fetch('P')
           WHEN "help" 
            CALL cl_show_help()
           WHEN "exit"
            EXIT WHILE
          # WHEN "jump"
          #  CALL p412_fetch('/')
           WHEN "controlg"  #KEY(CONTROL-G)
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p412_q()
    CLEAR FORM 
    CALL g_ecm.clear()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    #CALL p412_cs()
    CALL p412_b_askkey()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    #OPEN p412_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    #IF SQLCA.sqlcode THEN
    #   CALL cl_err('',SQLCA.sqlcode,0)
    #ELSE
       OPEN p412_cnt
       FETCH p412_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt  
       CALL p412_b_fill()
       #CALL p412_fetch('F')                  # 讀出TEMP第一筆並顯示
    #END IF
	MESSAGE ''
END FUNCTION
 
{FUNCTION p412_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680137 VARCHAR(1)
    l_sfbuser       LIKE sfb_file.sfbuser, 
    l_sfbgrup       LIKE sfb_file.sfbgrup 

 
    CASE p_flag
        WHEN 'N' FETCH NEXT     p412_cs INTO g_sfb.ta_sfb01
        WHEN 'P' FETCH PREVIOUS p412_cs INTO g_sfb.ta_sfb01
        WHEN 'F' FETCH FIRST    p412_cs INTO g_sfb.ta_sfb01
        WHEN 'L' FETCH LAST     p412_cs INTO g_sfb.ta_sfb01
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
            FETCH ABSOLUTE g_jump p412_cs INTO g_sfb.ta_sfb01
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
    CALL p412_show()
END FUNCTION
}
 
FUNCTION p412_show()
   LET g_data_keyvalue = g_sfb.ta_sfb01       
  
  
   DISPLAY BY NAME g_sfb.*   # 顯示單頭值
   CALL p412_b_fill() #單身
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION p412_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF

   LET l_sql =
       
        "SELECT ta_sfb01,ecm01,sfb05,ima02,ima021,",
        "       sfb08,sfb08-sfb09-sfb12,sfb13,sfb15,",   
        "       sfbud01,",                 #2240223 
        "       ecm03,ecm04,ecm45,",
        "       ecm06,ecm18, ",            #20200302
        "       ecm50,ecm51,ecm05,eci06 ",  
        "  FROM sfb_file,ima_file,ecm_file,eci_file ",      
        " WHERE ecm05=eci01(+) AND ", tm.wc2 CLIPPED, 
        "   AND sfb04 < 8 AND sfb87 !='X' ",
        "   AND sfb08-sfb09-sfb12 > 0 ",
        "   AND ecm52 = 'N' ",             #20190822 
        "   AND sfb01 = ecm01 AND sfb05=ima01 ", 
        "   AND ecm65 - ecm311 - ecm313 >0 ",      #20200914                           
        " ORDER BY ecm05"
    PREPARE p412_pb FROM l_sql
    DECLARE p412_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR p412_pb
 
    FOR g_cnt = 1 TO g_ecm.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_ecm[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH p412_bcs INTO g_ecm[g_cnt].*
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
 
FUNCTION p412_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    #IF p_ud <> "G" THEN
    #    RETURN
    #END IF
 
    LET g_action_choice = " "
    LET g_ac2 = ARR_CURR()     #20240226 保存當前行數
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_ecm TO s_ecm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        BEFORE ROW
            CALL cl_set_comp_entry("ecm18,ecm05,ecm50,ecm51",TRUE)
            CALL cl_set_comp_entry("sfbud01",FALSE)
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            ##---- 20240226 (S)
            IF g_ac2 > 0 THEN
               CALL fgl_set_arr_curr(g_ac2)
               LET l_ac = g_ac2
               LET g_ac2 = 0
            END IF
            ##---- 20240226 (E)
 
        ON ACTION detail
           LET g_action_choice="detail" 
           EXIT DISPLAY
 
        ON ACTION query       
           LET g_action_choice="query" 
           EXIT DISPLAY

        ##----- 20210331 add by momo (S)
        ON ACTION exporttoexcel                                                                     
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecm),'','')   
        ##----- 20210331 add by momo (E)

        ##---- 20240223 add by momo (S)
        ON ACTION modify_sfbud01
           LET g_action_choice = "modify_sfbud01"
           LET g_ac2 = l_ac
           EXIT DISPLAY
        ##---- 20240223 add by momo (E)
 
        #ON ACTION next
        #   CALL p412_fetch('N')
        #   CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
        #   IF g_rec_b != 0 THEN
        #   CALL fgl_set_arr_curr(1)  ######add in 040505
        #   END IF
	#ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        #ON ACTION previous
        #   CALL p412_fetch('P')
        # CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
        #   IF g_rec_b != 0 THEN
        # CALL fgl_set_arr_curr(1)  ######add in 040505
        #   END IF
	#ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        #ON ACTION first
        #   CALL p412_fetch('F')
        # CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
        #   IF g_rec_b != 0 THEN
        # CALL fgl_set_arr_curr(1)  ######add in 040505
        #   END IF
        #   ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        #ON ACTION last
        #   CALL p412_fetch('L')
        # CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
        #   IF g_rec_b != 0 THEN
        # CALL fgl_set_arr_curr(1)  ######add in 040505
        #   END IF
	#ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        #ON ACTION jump
        #   CALL p412_fetch('/')
        # CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
        #   IF g_rec_b != 0 THEN
        # CALL fgl_set_arr_curr(1)  ######add in 040505
        #   END IF
	#ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
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
 
 
FUNCTION p412_b()
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
            CALL cl_set_comp_entry("sfbud01",FALSE)
            LET g_before_input_done = FALSE
            LET g_before_input_done = TRUE

        BEFORE ROW
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_sl = SCR_LINE()
            CALL cl_qbe_display_condition(lc_qbe_sn)

 
        AFTER FIELD ecm50  
           IF g_ecm[l_ac].ecm50 < g_today THEN   
              CALL cl_err('','cec-308',1) 
              #NEXT FIELD ecm51 
           END IF
           #製程開工>製程完工，則讓完工=開工  #20201022
           IF g_ecm[l_ac].ecm50 > g_ecm[l_ac].ecm51 THEN
              LET g_ecm[l_ac].ecm51 = ''
              NEXT FIELD ecm51
           END IF 
           DISPLAY BY NAME g_ecm[l_ac].ecm51              

        AFTER FIELD ecm51
           IF g_ecm[l_ac].ecm51 = '' OR cl_null(g_ecm[l_ac].ecm51) THEN #20201022
              NEXT FIELD ecm51
           END IF
           #製程預計完工日不可小於程式預計開工日
           IF g_ecm[l_ac].ecm51 < g_ecm[l_ac].ecm50 THEN
              NEXT FIELD ecm51
           END IF 
           #製程預計完工日不可小於工單預計完工日
           IF g_ecm[l_ac].ecm51 > g_ecm[l_ac].sfb15 THEN
              CALL cl_err(g_ecm[l_ac].sfb15,'cec-310',1)
              NEXT FIELD ecm51
           END IF 
           DISPLAY BY NAME g_ecm[l_ac].ecm51     
 
        AFTER FIELD ecm05
           SELECT eci06 INTO g_ecm[l_ac].eci06
             FROM eci_file
            WHERE eci01 = g_ecm[l_ac].ecm05
              AND eciacti='Y'
          # IF cl_null(g_ecm[l_ac].eci06) THEN
          #    NEXT FIELD ecm05
          # END IF           
           DISPLAY BY NAME g_ecm[l_ac].ecm05
           DISPLAY BY NAME g_ecm[l_ac].eci06
 
        ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
         
             UPDATE ecm_file SET
                ecm51 =g_ecm[l_ac].ecm51,
                ecm50 =g_ecm[l_ac].ecm50,
                ecm05 =g_ecm[l_ac].ecm05,
                ecm18 =g_ecm[l_ac].ecm18,   #20200302
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
         
               WHEN INFIELD(ecm05)                 #機械編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     = "q_eci"
                    LET g_qryparam.default1 = g_ecm[l_ac].ecm05                    
                    CALL cl_create_qry() RETURNING g_ecm[l_ac].ecm05 
                    DISPLAY BY NAME g_ecm[l_ac].ecm05
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
 
##----- 20240223 add by momo (S)
FUNCTION p412_modify_sfbud01()
  DEFINE l_ac,l_sl       LIKE type_file.num5

  CALL cl_opmsg('b')
  CALL SET_COUNT(g_rec_b)   #告訴I.單身筆數
  IF g_action_choice="modify_sfbud01" THEN
     INPUT ARRAY g_ecm WITHOUT DEFAULTS FROM s_ecm.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

     BEFORE INPUT
       CALL cl_set_comp_entry("ecm18,ecm05,ecm50,ecm51",FALSE)
       CALL cl_set_comp_entry("sfbud01",TRUE)

     BEFORE ROW
       LET l_ac = ARR_CURR()
       IF g_ac2 > 0 THEN
          CALL fgl_set_arr_curr(g_ac2)
          LET l_ac = g_ac2
          LET g_ac2 = 0
       END IF
       DISPLAY l_ac TO FORMONLY.cn3

     AFTER FIELD sfbud01


     ON ROW CHANGE
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           EXIT INPUT
        END IF
        UPDATE sfb_file SET sfbud01=g_ecm[l_ac].sfbud01 WHERE sfb01=g_ecm[l_ac].ecm01
        IF STATUS OR SQLCA.SQLCODE THEN
           CALL cl_err('upd sfb:',SQLCA.SQLCODE,0)
        END IF

     DISPLAY BY NAME g_ecm[l_ac].sfbud01
        
     AFTER ROW
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          EXIT INPUT
        END IF
     END INPUT
  END IF
  CALL p412_b_fill() #單身

END FUNCTION
##----- 20240223 add by momo (E)
