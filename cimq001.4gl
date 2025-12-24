# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cimq001.4gl
# Descriptions...: BOM 多階查詢
# Date & Author..: 20210326  By  momo
# Modify.........: NO:2112247379 20211229 By momo 增加停產生效日 ima1401

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
            wc      STRING, 
            wc2     STRING  
        END RECORD,
    g_bma   RECORD
            bma01 LIKE bma_file.bma01,
            ima02 LIKE ima_file.ima02,
            ima021 LIKE ima_file.ima021,
            ima08 LIKE ima_file.ima08,
            ima55 LIKE ima_file.ima55,
            bma06 LIKE bma_file.bma06
            END RECORD,
	g_vdate LIKE type_file.dat,           
	g_rec_b LIKE type_file.num5,          
    g_bmb DYNAMIC ARRAY OF RECORD
            x_level   LIKE type_file.num5,      
            bmb02     LIKE bmb_file.bmb02,
            bmb03     LIKE bmb_file.bmb03,
            bmb03_b   LIKE bmb_file.bmb03,
            ima02_b   LIKE ima_file.ima02,      
            ima021_b  LIKE ima_file.ima021,   
            ima08     LIKE ima_file.ima08,      #來源碼  
            ima1401   LIKE ima_file.ima1401,    #20211229
            bmb04     LIKE bmb_file.bmb04,      #生效日
            bmb05     LIKE bmb_file.bmb05,      #失效日
            bmb14     LIKE bmb_file.bmb14,      #特性
            bmb16     LIKE bmb_file.bmb16,      #取替代
            bmb09     LIKE bmb_file.bmb09,      #作業編號    #CHI-CB0050 add
            bmb06     LIKE bmb_file.bmb06,      #QPA bmb06/bmb07
            bmb10     LIKE bmb_file.bmb10,
            sfb08     LIKE sfb_file.sfb08,      #預估可生產數
            atp_qty    LIKE type_file.num15_3,
            avl_stk    LIKE type_file.num15_3,  
            oeb_q      LIKE type_file.num15_3,   
            sfa_q1     LIKE type_file.num15_3,   
            sfa_q2     LIKE type_file.num15_3,   
            misc_q1    LIKE type_file.num15_3,   
	    sfs_q2     LIKE type_file.num15_3,   
            pml_q      LIKE type_file.num15_3,   
            pmn_q      LIKE type_file.num15_3,   
            sfb_q1     LIKE type_file.num15_3,   
            sfb_q2     LIKE type_file.num15_3,   
            rvb_q2     LIKE type_file.num15_3,   
            rvb_q      LIKE type_file.num15_3,   
            qcf_q      LIKE type_file.num15_3   
        END RECORD,
    g_bmb_attr DYNAMIC ARRAY OF RECORD
            x_level   STRING,
            bmb02     STRING,
            bmb03     STRING,
            bmb03_b   STRING,
            ima02_b   STRING,
            ima021_b  STRING,
            ima08     STRING,
            bmb09     STRING,
            bmb06     STRING,
            bmb10     STRING,
            sfb08     STRING,
            atp_qty   STRING,
            avl_stk   STRING,
            oeb_q     STRING,
            sfa_q1    STRING,
            sfa_q2    STRING,
            misc_q1   STRING,
            sfs_q2    STRING,
            pml_q     STRING,
            pmn_q     STRING,
            sfb_q1    STRING,
            sfb_q2    STRING,
            rvb_q2    STRING,
            rvb_q     STRING,
            qcf_q     STRING
        END RECORD,
    g_argv1         LIKE bma_file.bma01,      # INPUT ARGUMENT - 1
    g_sql           string                    #No.FUN-580092 HCN
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE   g_cnt         LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_msg         LIKE ze_file.ze03      #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_curs_index  LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_jump        LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   mi_no_ask     LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE  lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE   g_seq         LIKE type_file.num5    #No.MOD-750093 add   
 
MAIN
      DEFINE  # l_time LIKE type_file.chr8           #No.FUN-6A0060
          l_sl	       LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
    LET g_argv1      = ARG_VAL(1)          # 參數值(1)
    LET g_vdate      = g_today
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q501_w AT p_row,p_col WITH FORM "cim/42f/cimq001"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
    #FUN-560021................end
 
    IF NOT cl_null(g_argv1) THEN CALL q501_q() END IF
    CALL q501_menu()
    CLOSE WINDOW q501_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
 
FUNCTION q501_cs()                         # QBE 查詢資料
   DEFINE   l_cnt   LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "bma01 = '",g_argv1,"'"
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM                       # 清除畫面
   CALL g_bmb.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INITIALIZE g_bma.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON bma01
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      #--No.MOD-850118--------
      ON ACTION CONTROLP
        CASE 
         WHEN INFIELD(bma01) #主件
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
      	     #LET g_qryparam.form = "q_bmb01"    #CHI-CA0002 mark
              LET g_qryparam.form = "q_bma101"   #CHI-CA0002
              CALL cl_create_qry() RETURNING g_qryparam.multiret
      	      DISPLAY g_qryparam.multiret TO bma01
      	      NEXT FIELD bma01
         OTHERWISE 
              EXIT CASE
         END CASE
      #--#MOD-850118-END-------    
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
      INPUT BY NAME g_vdate WITHOUT DEFAULTS
         ON ACTION controlg       #TQC-860021
            CALL cl_cmdask()      #TQC-860021
 
         ON IDLE g_idle_seconds   #TQC-860021
            CALL cl_on_idle()     #TQC-860021
            CONTINUE INPUT        #TQC-860021
 
         ON ACTION about          #TQC-860021
            CALL cl_about()       #TQC-860021
 
         ON ACTION help           #TQC-860021
            CALL cl_show_help()   #TQC-860021
      END INPUT                   #TQC-860021
 
      IF INT_FLAG THEN
         RETURN
      END IF
      CALL q501_b_askkey()             # 取得單身 construct 條件( tm.wc2 )
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
   MESSAGE ' SEARCHING '
   #MOD-E60121 add---end---
   IF tm.wc2 = " 1=1" THEN
      LET g_sql = " SELECT UNIQUE bma01,bma06 FROM bma_file", #FUN-550093
                  "  WHERE ",tm.wc CLIPPED
   ELSE
      LET g_sql = " SELECT UNIQUE bma01,bma06", #FUN-550093
                  " FROM bma_file, bmb_file ",
                  " WHERE ",tm.wc CLIPPED, 
                 #"   AND ",tm.wc2 CLIPPED, #MOD-E60121 mark 因為會展BOM,可能查詢的元件是在第2階(含)之後,故不能在一開始就限製
                  "   AND bma06 = bmb29",   #MOD-920233 add
                  "   AND bma01 = bmb01"
      #MOD-E60121 add---str---
      #-->當單頭未下條件時,才將單身的條件加入
      IF tm.wc = " 1=1" THEN
          LET g_sql = g_sql CLIPPED," AND ",tm.wc2 CLIPPED 
      END IF

      #-->生效日及失效日的判斷 
      IF NOT cl_null(g_vdate) THEN
          LET g_sql = g_sql CLIPPED,
                     " AND (bmb04 <='",g_vdate,"' OR bmb04 IS NULL)",
                     " AND (bmb05 > '",g_vdate,"' OR bmb05 IS NULL)"
      END IF
      #MOD-E60121 add---end---
   END IF
 
   LET g_sql = g_sql clipped," ORDER BY bma01"
   PREPARE q501_prepare FROM g_sql
   DECLARE q501_cs SCROLL CURSOR FOR q501_prepare
#No.TQC-720055 --begin
#  LET g_sql= " SELECT COUNT(*) FROM bma_file WHERE ",tm.wc CLIPPED
   IF tm.wc2 = " 1=1" THEN
     #LET g_sql= " SELECT COUNT(*) ",                     #MOD-E60124 mark
      LET g_sql= " SELECT COUNT(UNIQUE bma01||bma06) ",   #MOD-E60124 add 得到的筆數不正確調整
                 "   FROM bma_file WHERE ",tm.wc CLIPPED  
   ELSE
     #LET g_sql = " SELECT COUNT(*) ",                    #MOD-E60124 mark
      LET g_sql = " SELECT COUNT(UNIQUE bma01||bma06) ",  #MOD-E60124 add 得到的筆數不正確調整
                  " FROM bma_file, bmb_file ",
                  " WHERE ",tm.wc CLIPPED,
                 #"   AND ",tm.wc2 CLIPPED, #MOD-E60121 mark
                  "   AND bma06 = bmb29",   #MOD-920233 add
                  "   AND bma01 = bmb01"
      #MOD-E60121 add---str---
      #-->當單頭未下條件時,才將單身的條件加入
      IF tm.wc = " 1=1" THEN
          LET g_sql = g_sql CLIPPED," AND ",tm.wc2 CLIPPED 
      END IF

      #-->生效日及失效日的判斷 #140626
      IF NOT cl_null(g_vdate) THEN
          LET g_sql = g_sql CLIPPED,
                     " AND (bmb04 <='",g_vdate,"' OR bmb04 IS NULL)",
                     " AND (bmb05 > '",g_vdate,"' OR bmb05 IS NULL)"
      END IF
      #MOD-E60121 add---end---
   END IF
#No.TQC-720055 --end
 
   PREPARE q501_pp FROM g_sql
   DECLARE q501_cnt CURSOR FOR q501_pp
END FUNCTION
 
 
FUNCTION q501_b_askkey()
   CONSTRUCT tm.wc2 ON bmb02,bmb03,bmb09                      #CHI-CB0050 add bmb09
        FROM s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb09     #CHI-CB0050 add bmb09

              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
              #No.FUN-580031 --end--       HCN

     #CHI-CB0050---add---S
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bmb09)
                 CALL q_ecd(TRUE,TRUE,g_bmb[1].bmb09)
                        RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO bmb09
                   NEXT FIELD bmb09

            OTHERWISE EXIT CASE
         END  CASE
     #CHI-CB0050---add---E

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
END FUNCTION
 
FUNCTION q501_menu()
 
   WHILE TRUE
      CALL q501_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q501_q()
         WHEN "jump"
            CALL q501_fetch('/')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "next"
            CALL q501_fetch('N')
         WHEN "previous"
            CALL q501_fetch('P')
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q501_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q501_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q501_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q501_cnt
       FETCH q501_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q501_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q501_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1      #處理方式   #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q501_cs INTO g_bma.bma01,g_bma.bma06
        WHEN 'P' FETCH PREVIOUS q501_cs INTO g_bma.bma01,g_bma.bma06
        WHEN 'F' FETCH FIRST    q501_cs INTO g_bma.bma01,g_bma.bma06
        WHEN 'L' FETCH LAST     q501_cs INTO g_bma.bma01,g_bma.bma06
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump q501_cs INTO g_bma.bma01,g_bma.bma06
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)
        INITIALIZE g_bma.* TO NULL  #TQC-6B0105
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
    #FUN-550093................begin
    SELECT bma01,'','','','','',bma06
           INTO g_bma.*
      FROM bma_file WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06
 
    IF SQLCA.sqlcode THEN
   #    CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("sel","bma_file",g_bma.bma01,"",SQLCA.sqlcode,"","",0)    #No.TQC-660046
        RETURN
    END IF
    SELECT ima02,ima021,' ',ima08,ima55
       INTO g_bma.ima02,g_bma.ima021,g_bma.ima08,g_bma.ima55
       FROM ima_file WHERE ima01=g_bma.bma01
    #FUN-550093................end
 
    CALL q501_show()
END FUNCTION
 
FUNCTION q501_show()
   #No.FUN-9A0024--begin                                                                                                            
   #DISPLAY BY NAME g_bma.*                                                                                                         
   DISPLAY BY NAME g_bma.bma01,g_bma.ima02,g_bma.ima021,g_bma.ima08,g_bma.ima55                                        
   #No.FUN-9A0024--end 
 #MOD-550192
   CALL q501_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION q501_b_fill()              #BODY FILL UP
   DEFINE i	LIKE type_file.num5          #No.FUN-680096 SMALLINT
   
   #-->生效日及失效日的判斷 
   IF NOT cl_null(g_vdate) THEN
      LET tm.wc2 = tm.wc2 CLIPPED,
                  " AND (bmb04 <='",g_vdate,"' OR bmb04 IS NULL)",
                  " AND (bmb05 > '",g_vdate,"' OR bmb05 IS NULL)"
   END IF
 
   LET g_sql = "SELECT Level,bmb02,LPAD(' ', (Level - 1) * 3) ||bmb03,bmb03,",
               "       ima02,ima021,ima08,ima1401,",
               "       bmb04,bmb05,bmb14,bmb16,bmb09, ",
               "       bmb06/bmb07,bmb10, ",
               "       0,0,0,0,0,0,0,0,0,0,0,0,0,0,0",
               "  FROM bmb_file,bma_file,ima_file  ",
               "  WHERE ima01=bmb03 AND bma01=bmb01  ",   
               "   AND ",tm.wc2,
               " START WITH ",tm.wc, # add 篩選單身下的查詢條件
               "  AND ima01=bmb03 AND bma01=bmb01 " ,             
               " CONNECT BY bmb01 = prior bmb03 ",
               "  AND ",tm.wc2,
               "  AND ima01=bmb03 AND bma01=bmb01 "              
   PREPARE q501_pb FROM g_sql
   DECLARE q501_bcs CURSOR FOR q501_pb
   #MOD-E60121--add----end---

   #-----------------No.MOD-740052 modify
   #FOR g_cnt = 1 TO g_bmb.getLength()           #單身 ARRAY 乾洗
   #   INITIALIZE g_bmb[g_cnt].* TO NULL
   #END FOR
    CALL g_bmb.clear()
   #-----------------No.MOD-740052 end
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH q501_bcs INTO g_bmb[g_cnt].*
       IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
       CALL cs_q103_qty(g_bmb[g_cnt].bmb03_b)
            RETURNING g_bmb[g_cnt].oeb_q,
                   g_bmb[g_cnt].sfa_q1,
                   g_bmb[g_cnt].sfa_q2,
                   g_bmb[g_cnt].pml_q,
                   g_bmb[g_cnt].pmn_q,
                   g_bmb[g_cnt].rvb_q2,
                   g_bmb[g_cnt].rvb_q,
                   g_bmb[g_cnt].sfb_q1,
                   g_bmb[g_cnt].sfb_q2,
                   g_bmb[g_cnt].qcf_q,
                   g_bmb[g_cnt].atp_qty,
                   g_bmb[g_cnt].misc_q1,
                   g_bmb[g_cnt].sfs_q2,
                   g_bmb[g_cnt].avl_stk
       LET g_bmb[g_cnt].sfb08 = g_bmb[g_cnt].atp_qty / g_bmb[g_cnt].bmb06
       LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    CALL g_bmb.deleteElement(g_cnt)       #No.MOD-760024 add
    LET g_rec_b = g_cnt -1
    LET g_cnt = g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cn2
#   LET i = g_cnt / g_bmb_sarrno
#   IF (g_cnt > i*g_bmb_sarrno) THEN LET i = i + 1 END IF
END FUNCTION
 
FUNCTION q501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q501_fetch('L')
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION next
         CALL q501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION accept
        #LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
       &include "qry_string.4gl" 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
