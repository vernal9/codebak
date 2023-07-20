# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cpmr259.4gl
# Desc/riptions..: 採購金額比較報表
# Date & Author..: 2023/03/08 By Momo
# Modify.........: No.2101055685 20210107 by momo 增加KS營運中心平均用量-主要供應商為DE005
# Modify.........: No.2102145819 20210220 By momo 增加KS營運中心年度用量

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
                 wc  	STRING,		        # Where condition
                 pmm04a  LIKE type_file.dat,    #採購日期範圍-起始    
                 pmm04b  LIKE type_file.dat,    #採購日期範圍-終止    
                 purtype LIKE pmm_file.pmm02,   #採購性質  
                 rate    LIKE azk_file.azk052,  #匯率
                 type   LIKE type_file.chr1,    #CHI-9C0025
                 more	LIKE type_file.chr1     #Input more condition(Y/N)  #No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_aza17        LIKE aza_file.aza17,   # 本國幣別
          g_total1       LIKE pmn_file.pmn44,   #No.FUN-680136 DECIMAL(20,6)        
          g_total2       LIKE pmn_file.pmn44    #No.FUN-680136 DECIMAL(20,6)
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE l_table        STRING,                 ### FUN-720010 ###
       g_str          STRING,                 ### FUN-720010 ###
       g_sql          STRING                  ### FUN-720010 ###
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
## ***  與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.Martin  *** ##
    LET g_sql = 
                " pmi01.pmi_file.pmi01,",  # 核價單號
                " pmi02.pmi_file.pmi02,",  # 核價日期
                " pmi03.pmi_file.pmi03,",  # 廠商
                " pmc03.pmc_file.pmc03,",  # 廠商簡稱
                " pmi05.pmi_file.pmi05,",  # 分量計價
                " pmi09.pmi_file.pmi09,",  # 申請人
                " gen02.gen_file.gen02,",  # 申請人姓名
                " pmj03.pmj_file.pmj03,",  # 料件編號
                " pmj07.pmj_file.pmj07,",  # 核價單價
                " ima02.ima_file.ima02,",  # 品名
                " ima021.ima_file.ima021,",# 規格
                " ima41.ima_file.ima41,",  # 年平均用量
                " ksima41.ima_file.ima41,",# KS年平均用量20210107
                " pmm09.pmm_file.pmm09,",  # 最近採購廠商
                " pmn31.pmn_file.pmn31,",  # 最近採購平均單價
                " pmn20.pmn_file.pmn20,",   # 最近採購平均數量
                " kspmn20.pmn_file.pmn20"  # KS最近採購平均數量 20210220
 
    LET l_table = cl_prt_temptable('cpmr259',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
                " VALUES(?,?,?,?,?,   ?,?,?,?,?, ",
                "        ?,?,?,?,?,   ?,?        ) "   
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#----------------------------------------------------------CR (1) ------------#
 
 
    LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
    LET g_towhom = ARG_VAL(2)
    LET g_rlang = ARG_VAL(3)
    LET g_bgjob = ARG_VAL(4)
    LET g_prtway = ARG_VAL(5)
    LET g_copies = ARG_VAL(6)
    LET tm.wc = ARG_VAL(7)
    LET tm.pmm04a  = ARG_VAL(8)
    LET tm.pmm04b  = ARG_VAL(9)
    LET tm.purtype = ARG_VAL(10)
    LET tm.rate = ARG_AVL(11)
    LET g_rep_user = ARG_VAL(15)
    LET g_rep_clas = ARG_VAL(16)
    LET g_template = ARG_VAL(17)
    LET g_rpt_name = ARG_VAL(18)  
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN	# If background job sw is off
        CALL r259_tm(0,0)		        # Input print condition
    ELSE
        CALL cpmr259()		# Read data and create out-file
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r259_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01  
    DEFINE p_row,p_col	LIKE type_file.num5,         
           l_cmd	LIKE type_file.chr1000,      
           l_a          LIKE type_file.chr1,         
           l_n          LIKE type_file.num5          
 
    LET p_row = 2 LET p_col = 16
 
    OPEN WINDOW r259_w AT p_row,p_col WITH FORM "cpm/42f/cpmr259"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL			# Default condition
    LET tm.pmm04a = g_today
    LET tm.pmm04b = g_today
    LET tm.purtype = '1'
    LET tm.rate = 1
    LET tm.more = 'N'
    LET g_pdate = g_today
    LET g_rlang = g_lang
    LET g_bgjob = 'N'
    LET g_copies = '1'
  
 
WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON bma01,ima01
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
        ON ACTION CONTROLP
            IF INFIELD(bma01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bma01
               NEXT FIELD bma01
            END IF
            
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
 
     ON ACTION locale
          CALL cl_show_fld_cont()                   
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW r259_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
    END IF
    IF tm.wc = " 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
    END IF
    DISPLAY BY NAME tm.pmm04a,tm.pmm04b,tm.purtype,tm.rate,
                    tm.more # Condition
#UI
    INPUT BY NAME tm.pmm04a,tm.pmm04b,tm.purtype,tm.rate,                                  
                  tm.more WITHOUT DEFAULTS 
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
    AFTER FIELD pmm04a
        IF cl_null(tm.pmm04a) THEN
            NEXT FIELD pmm04a
        END IF
    AFTER FIELD pmm04b
        IF cl_null(tm.pmm04b) OR tm.pmm04b < tm.pmm04a THEN
            NEXT FIELD pmm04b
        END IF
    AFTER FIELD rate
        IF cl_null(tm.rate) THEN
           LET tm.rate = 1
        END IF
 
    AFTER FIELD more
        IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more)
            THEN NEXT FIELD more
        END IF
        IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
        END IF
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
    ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      #UI
      
 END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW r259_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
    END IF
    IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
            WHERE zz01='cpmr259'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('cpmr259','9031',1)
        ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.pmm04a CLIPPED,"'",
                         " '",tm.pmm04b CLIPPED,"'",
                         " '",tm.purtype CLIPPED,"'",
                         " '",tm.rate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",          
                         " '",g_template CLIPPED,"'",          
                         " '",g_rpt_name CLIPPED,"'"           
            CALL cl_cmdat('cpmr259',g_time,l_cmd)      # Execute cmd at later time
        END IF
        CLOSE WINDOW r259_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL cpmr259()
    ERROR ""
END WHILE
    CLOSE WINDOW r259_w
END FUNCTION
 
FUNCTION cpmr259()
    DEFINE l_pmj09      LIKE pmj_file.pmj09  # 新核日
    DEFINE l_name	LIKE type_file.chr20, 	      # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
           l_str        STRING,
           l_time	LIKE type_file.chr8,  	      # Used time for running the job   #No.FUN-680136 VARCHAR(8)
           l_sql 	STRING,                                                                                        #TQC-B30073 
           l_chr	LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
           l_za05	LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
           l_order	ARRAY[2] OF  LIKE pmn_file.pmn04,             #No.FUN-680136 VARCHAR(40)
           sr               RECORD #order1   LIKE pmn_file.pmn04,   
                                   #order2   LIKE pmn_file.pmn04, 
                                   pmi01    LIKE pmi_file.pmi01, # 核價單號
                                   pmi02    LIKE pmi_file.pmi02, # 核價日期
                                   pmi03    LIKE pmi_file.pmi03, # 核價廠商
                                   pmc03    LIKE pmc_file.pmc03, # 廠商簡稱
                                   pmi05    LIKE pmi_file.pmi05, # 分量計價否
                                   pmi09    LIKE pmi_file.pmi09, # 申請人
                                   gen02    LIKE gen_file.gen02, # 申請人姓名
                                   pmj02    LIKE pmj_file.pmj02, # 核價項次
                                   pmj03    LIKE pmj_file.pmj03, # 核價料號
                                   pmj07    LIKE pmj_file.pmj07, # 核價單價
                                   ima02    LIKE ima_file.ima02, # 品名
                                   ima021   LIKE ima_file.ima021,# 規格
                                   ima41    LIKE ima_file.ima41, # 年平均用量
                                   ksima41  LIKE ima_file.ima41, # KS年平均用量 20210107
                                   pmm09    LIKE pmm_file.pmm09, # 廠商
                                   pmn31    LIKE pmn_file.pmn31, # 採購平均單價
                                   pmn20    LIKE pmn_file.pmn20, # 採購平均數量
                                   kspmn20  LIKE pmn_file.pmn20  # KS採購平均數量 20210220
                            END RECORD
     DEFINE l_avg     LIKE ima_file.ima41     #20210220 by momo 兩廠平均
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720010 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720010 add ###
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
 
     LET l_sql = " SELECT  ",
                 "        ima01,ima02,ima021,ima44,ima41/ima44_fac, ",  
                 "        0,",                                                  #20210107
                 "        '',0,0,0 ",                                           #20210220                        
                 " FROM pmi_file,pmj_file, ",
                 "      pmc_file,ima_file,gen_file ",  
                 " WHERE pmi01=pmj01 AND pmi_file.pmi03 = pmc_file.pmc01 AND pmj_file.pmj03 = ima_file.ima01 ",
                 "     AND pmiconf='Y'  ",
                 "     AND ta_pmj02 IS NULL ",
                 "     AND pmi09=gen01 ",
                 "     AND imaacti='Y' AND ima140='N' ",  #20210105
                 "     AND ",tm.wc
      
    IF tm.purtype = 'REG' THEN
       LET l_sql = l_sql CLIPPED, " AND pmi10 = '1' "
    ELSE
       LET l_sql = l_sql CLIPPED, " AND pmi10 = '2' "
    END IF                          
    PREPARE r259_prepare1 FROM l_sql
    DECLARE r259_cs1 CURSOR FOR r259_prepare1
 
    LET g_pageno = 0
    FOREACH r259_cs1 INTO sr.*                                           
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF

        #抓最近供應商與單價
        LET l_sql = "SELECT pmm09,pmn31  ",
                    "  FROM (SELECT pmm09,pmn31, ROW_NUMBER() OVER (PARTITION BY pmm09 ORDER BY pmm04 desc) as NO ",
                    "          FROM pmn_file,pmm_file ",
                    "         WHERE pmm01=pmn01 ",
                    "           AND NOT EXISTS (SELECT * FROM pml_file WHERE pml52 is not NULL AND pml01 =  pmn24 AND pml02=pmn25 )",
                    "           AND pmm04 BETWEEN '",tm.pmm04a,"' AND '",tm.pmm04b,"' ",
                    "           AND pmm02='",tm.purtype,"' ",
                    "           AND pmn04 = '",sr.pmj03,"' )",
                    " WHERE NO = 1"
        PREPARE r259_prepare11 FROM l_sql
        DECLARE r259_cs11 CURSOR FOR r259_prepare11
        FOREACH r259_cs11 INTO sr.pmm09,sr.pmn31
        END FOREACH

        


        #---分量計價時的單價抓取, 用量抓取年平均
        IF sr.pmi05 = 'Y' THEN
           LET l_avg = sr.ima41 + sr.ksima41  #20210220
           LET sr.pmj07 = 0
           SELECT pmr05 INTO sr.pmj07
             FROM pmr_file
            WHERE pmr01 = sr.pmi01
             #AND pmr04 >= sr.ima41 AND pmr03 <= sr.ima41  #20210220 mark by momo 
              AND pmr04 >= l_avg AND pmr03 <= l_avg  #20210220 modify by momo 兩廠平均 
              AND pmr02 = sr.pmj02
        END IF


        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
           EXECUTE insert_prep USING 
                   sr.pmi01,sr.pmi02,sr.pmi03,sr.pmc03,sr.pmi05,sr.pmi09,sr.gen02,
                   sr.pmj03,sr.pmj07,sr.ima02,sr.ima021,sr.ima41,
                   sr.ksima41,                                                        #20210107
                   sr.pmm09,sr.pmn31,
                   sr.pmn20,
                   sr.kspmn20                                                         #20210220
        #------------------------------ CR (3) ------------------------------#
    END FOREACH
 
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720010 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
    LET g_str = ''
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'pmi09,pmj03') 
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";"
                     ,";",g_azi03,";",g_azi04
    CALL cl_prt_cs3('cpmr259','cpmr259',l_sql,g_str)        
    #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
#No:FUN-9C0071--------精簡程式----- 
