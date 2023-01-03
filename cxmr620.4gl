# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cxmr620.4gl
# Descriptions...: 銷貨自製率報表
# Input parameter:
# Return code....:
# Date & Author..: 2022/06/07 By momo


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5       # No.FUN-680137 SMALLINT
END GLOBALS
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc     STRING,         # Where condition            
              type    LIKE type_file.chr1,            #No.FUN-8B0025 VARCHAR(1)
              x       LIKE type_file.chr1,            #No:FUN-940116
              v       LIKE type_file.chr1,            #No:FUN-940116
              s      LIKE type_file.chr3,         # No.FUN-680137 VARCHAR(3)        # Order by sequence
              t      LIKE type_file.chr3,         # No.FUN-680137 VARCHAR(3)        # Eject sw
              u      LIKE type_file.chr3,         # No.FUN-680137 VARCHAR(3)        # Group total sw
              oga00  LIKE oga_file.oga00,         # No.FUN-950110
              y      LIKE type_file.chr1,         # No.FUN-680137 VARCHAR(1)        # Input more condition(Y/N)
              c      LIKE type_file.chr1,         # No.FUN-680137 VARCHAR(1)        # PRINT sub Item #No.FUN-5C0075
              a      LIKE type_file.chr1,         # No.CHI-B10027
              d      LIKE type_file.chr1,         # No.FUN-EA0031
              more   LIKE type_file.chr1          # No.FUN-680137 VARCHAR(1)        # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680137 SMALLINT
DEFINE   g_sma115        LIKE sma_file.sma115   #No.FUN-580004
DEFINE   g_sma116        LIKE sma_file.sma116   #No.FUN-580004
DEFINE   g_sql         STRING
DEFINE   l_table       STRING
DEFINE   l_str         STRING
DEFINE   l_sql         STRING
DEFINE   l_flag        LIKE type_file.chr1
DEFINE  m_plant     LIKE azw_file.azw01   #FUN-A70084
DEFINE  g_wc        LIKE type_file.chr1000   #FUN-A70084 
DEFINE  l_oga02     LIKE oga_file.oga02   #出貨日期

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   LET g_sql = "oga01.oga_file.oga01,",
               " oga02.oga_file.oga02,",
               " oga03.oga_file.oga03,",
               " oga032.oga_file.oga032,",
               " oga04.oga_file.oga04,",
               " occ02.occ_file.occ02,",
               " oga14.oga_file.oga14,",
               " oga27.oga_file.oga27,",   #
               " gen02.gen_file.gen02,",
               " oga15.oga_file.oga15,",
               " gem02.gem_file.gem02,",
               " ogb03.ogb_file.ogb03,",
               " ogb31.ogb_file.ogb31,",
               " ogb32.ogb_file.ogb32,",   #
               " ogb04.ogb_file.ogb04,",
               " ogb06.ogb_file.ogb06,",
               " ima021.ima_file.ima021,",
               " ima1007.ima_file.ima1007,",
               " imaud02.ima_file.imaud09,",
               " oba02.oba_file.oba02,",    #產品分類
               " azf03.azf_file.azf03,",    #系列
               " str2.type_file.chr50,",
               " ogb05.ogb_file.ogb05,",
               " oga23.oga_file.oga23,",
               " ogb13.ogb_file.ogb13,",
               " ogb12.ogb_file.ogb12,",
               " ogb916.ogb_file.ogb916,",
               " ogb917.ogb_file.ogb917,",
               " ogb14.ogb_file.ogb14,",
               " ogb14t.ogb_file.ogb14t,",   #add by ruby 2018/02/22
               " oga10.oga_file.oga10,",
               " oea10.oea_file.oea10,",     #add by ruby 2018/02/22
               " occ241.occ_file.occ241,",   #200420 add by ruby
               " y.type_file.chr1,",
               " c.type_file.chr1,",
               " oaz23.type_file.chr1,",
               " ogc175.ogc_file.ogc17,",
               " ima025.ima_file.ima02,",
               " ima0215.ima_file.ima021,",
               " ogc125.ogc_file.ogc12,",
               " azi03.azi_file.azi03,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               "plant.azp_file.azp01"                           #FUN-8B0025 add
   LET l_table = cl_prt_temptable('cxmr620',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table clipped,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,", 
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,? )"  
   PREPARE insert_prept111 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM 
   END IF 

    
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.y  = ARG_VAL(11)
   LET tm.c  = ARG_VAL(12)
   LET tm.d  = ARG_VAL(13)                      #FUN-EA0031 add
   LET g_rep_user = ARG_VAL(14)                 #FUN-EA0031 modify ARG_VAL(13)->ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)                 #FUN-EA0031 modify ARG_VAL(14)->ARG_VAL(15)
   LET g_template = ARG_VAL(16)                 #FUN-EA0031 modify ARG_VAL(15)->ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078 #FUN-EA0031 modify ARG_VAL(16)->ARG_VAL(17)
   LET tm.type  = ARG_VAL(18)                   #FUN-EA0031 modify ARG_VAL(17)->ARG_VAL(18)
   LET tm.oga00 = ARG_VAL(19)   #No.FUN-950110  #FUN-EA0031 modify ARG_VAL(28)->ARG_VAL(20)
   LET tm.x     = ARG_VAL(20)   #No.FUN-940116  #FUN-EA0031 modify ARG_VAL(29)->ARG_VAL(21)
   LET tm.v     = ARG_VAL(21)   #No.FUN-940116  #FUN-EA0031 modify ARG_VAL(30)->ARG_VAL(22)
   LET g_wc     = ARG_VAL(22)                   #FUN-EA0031 modify ARG_VAL(18)->ARG_VAL(19)
   LET tm.a     = ARG_VAL(23)   #CHI-B10027     #FUN-EA0031 modify ARG_VAL(19)->ARG_VAL(20)
   LET g_xml.subject = ARG_VAL(24)              #210616 add by ruby
#FUN-A70084--mod--end
   ##--- 建立與刪除暫存檔 
   #DROP TABLE r620_cxmr620                                                                   #20220804
   #SELECT ima01,ima021,ima09,ima1007,imaud02 FROM view_self_maker INTO TEMP r620_cxmr620     #20220804

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL cxmr620_tm(0,0)        # Input print condition
      ELSE CALL cxmr620()            # Read data and create out-file
   END IF

   DROP TABLE r620_cxmr620
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION cxmr620_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_oaz23     LIKE oaz_file.oaz23    #No.FUN-5C0075
   DEFINE l_azwerr    LIKE type_file.chr1    #MOD-G80051 add
   DEFINE l_wc_con    LIKE type_file.chr10   #MOD-G80051 add
   DEFINE l_azw01_wc  LIKE type_file.chr1000 #MOD-G80051 add
   DEFINE l_cont      LIKE type_file.num5    #MOD-G80051 add
   DEFINE i           LIKE type_file.num10   #MOD-G80051 add
 
   LET p_row = 3 LET p_col = 15
 
   OPEN WINDOW axmr620_w AT p_row,p_col WITH FORM "axm/42f/axmr620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   SELECT oaz23 INTO l_oaz23 FROM oaz_file
   IF l_oaz23 = 'N' THEN
      CALL cl_set_comp_visible("c",FALSE)
   END IF
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm2.s1  = '8'
   LET tm2.s2  = ''
   LET tm2.u1  = 'Y'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.y    = 'Y'
   LET tm.c    = 'N'     #No.FUN-5C0075
   LET tm.a    = 'N'     #CHI-B10027
   LET tm.more = 'N'
   LET tm.x='1'       #No.FUN-940116
   LET tm.v='1'       #No.FUN-940116
   LET tm.oga00='A'   #No.FUN-950110
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  #LET tm.b ='N'        #FUN-A70084
  #LET tm.p1=g_plant    #FUN-A70084
   LET tm.type  = '3'
  #FUN-EA0031--add str--
   IF s_industry("slk") AND g_sma.sma150='Y' THEN
      CALL cl_set_comp_visible("d",TRUE)
      LET tm.d='Y'
   ELSE
      CALL cl_set_comp_visible("d",FALSE)
      LET tm.d='N'
   END IF
   CALL cl_set_comp_visible("group02,g01",FALSE)
 
WHILE TRUE
#FUN-A70084--add--str--
   CONSTRUCT BY NAME g_wc ON azw01

      BEFORE CONSTRUCT
          CALL cl_qbe_init()

      DISPLAY g_plant TO azw01
      #MOD-G80051 add---start---
      AFTER FIELD azw01
          CALL s_showmsg_init()
          LET l_azwerr = 'N'
          LET l_azw01_wc = GET_FLDBUF(azw01)
          FOR i = 1 TO LENGTH(l_azw01_wc)
              IF l_azw01_wc[i,i] = "|" THEN
                 LET l_cont = 0
                 SELECT COUNT(*) INTO l_cont FROM azw_file
                  WHERE azw01 = l_wc_con
                   #AND azw02 = g_legal
                    AND azw01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user)
                    
                 IF l_cont = 0 THEN
                    LET l_azwerr = 'Y'
                    CALL s_errmsg('azw01',l_wc_con,'','sub-188',1)
                 END IF
                 LET l_wc_con = ''
              ELSE
                 LET l_wc_con = l_wc_con CLIPPED,l_azw01_wc[i,i]
              END IF
              IF i = LENGTH(l_azw01_wc) THEN
                 SELECT COUNT(*) INTO l_cont FROM azw_file
                  WHERE azw01 = l_wc_con
                   #AND azw02 = g_legal
                    AND azw01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user)
                 IF l_cont = 0 THEN
                    LET l_azwerr = 'Y'
                    CALL s_errmsg('azw01',l_wc_con,'','sub-188',1)
                 END IF
                 LET l_wc_con = ''
              END IF
          END FOR
          IF l_azwerr = 'Y' THEN
             CALL s_showmsg()
             NEXT FIELD azw01
          END IF
       #MOD-G80051 add---end---

      ON ACTION controlp
            IF INFIELD(azw01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " azw01 IN(SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' )"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azw01
               NEXT FIELD azw01
            END IF

      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT CONSTRUCT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()
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
     LET INT_FLAG = 0
     CLOSE WINDOW axmr620_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM
  END IF
#FUN-A70084--add--end

   CONSTRUCT BY NAME tm.wc ON oga01,oga02,oga03,oga04,oga14,oga15,oga23,ogb04
      BEFORE CONSTRUCT
       CALL cl_set_comp_required("oga02", TRUE)
       CALL cl_qbe_display_condition(lc_qbe_sn) #MOD-D40008 add
       DISPLAY '0*' TO ogb04
       DISPLAY g_today TO oga02

 
       ON ACTION locale
         LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT CONSTRUCT
 
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oga01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oga8"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga01
                NEXT FIELD oga01
 
              WHEN INFIELD(oga03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga03
                NEXT FIELD oga03
 
              WHEN INFIELD(oga04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga04
                NEXT FIELD oga04
 
              WHEN INFIELD(oga14)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga14
                NEXT FIELD oga14
 
              WHEN INFIELD(oga15)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga15
                NEXT FIELD oga15
 
              WHEN INFIELD(ogb04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ogb04
                NEXT FIELD ogb04
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more         # Condition
 
   INPUT BY NAME tm.oga00,tm.y,tm.c,tm.a,tm.d,tm.type,  #No.FUN-950110 add tm.oga00  #FUN-EA0031 add tm.d
                 tm.x,tm.v,                             #No.FUN-940116
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more WITHOUT DEFAULTS    #No.FUn-5C0075
   #-----END CHI-B10027-----
                 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
            #MOD-D40008 add start -----
             LET tm.oga00 = GET_FLDBUF(oga00)
             LET tm.y = GET_FLDBUF(y)
             LET tm.c = GET_FLDBUF(c)
             LET tm.a = GET_FLDBUF(a)
             LET tm.d = GET_FLDBUF(d)          #FUN-EA0031 add
             LET tm.type = GET_FLDBUF(type)
             LET tm.x = GET_FLDBUF(x)
             LET tm.v = GET_FLDBUF(v)
             LET tm2.s1 = GET_FLDBUF(s1)
             LET tm2.s2 = GET_FLDBUF(s2)
             LET tm2.s3 = GET_FLDBUF(s3)
             LET tm2.t1 = GET_FLDBUF(t1)
             LET tm2.t2 = GET_FLDBUF(t2)
             LET tm2.t3 = GET_FLDBUF(t3)
             LET tm2.u1 = GET_FLDBUF(u1)
             LET tm2.u2 = GET_FLDBUF(u2)
             LET tm2.u3 = GET_FLDBUF(u3)
             LET tm.more = GET_FLDBUF(more)
            #MOD-D40008 add end   -----
    

       #No.FUN-950110--ADD--
       AFTER FIELD oga00
          IF tm.oga00 NOT MATCHES '[A1234]' THEN
             NEXT FIELD oga00
          END IF
       #No.FUN-950110--END--

       AFTER FIELD type
          IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN
             NEXT FIELD type
          END IF                 

 
      AFTER FIELD y
        IF cl_null(tm.y) OR tm.y NOT MATCHES '[YN]' THEN
           NEXT FIELD y
        END IF
      AFTER FIELD c
        IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
           NEXT FIELD c
        END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

     #FUN-EA0031--add str--
      AFTER FIELD d
        IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
           NEXT FIELD d
        END IF
     #FUN-EA0031--add end--

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cxmr620'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('cxmr620','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET g_wc = cl_replace_str(g_wc, "'", "\"") #MOD-EB0105 add
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",            #No.TQC-610089 add
                         " '",tm.d CLIPPED,"'",            #No.FUN-EA0031 add
                         " '",g_rep_user CLIPPED,"'",      #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",      #No.FUN-570264
                         " '",g_template CLIPPED,"'",      #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",      #No.FUN-7C0078
                         " '",tm.type CLIPPED,"'",         #FUN-8B0025   
                         " '",tm.oga00 CLIPPED,"'",        #210616 add by ruby
                         " '",tm.x CLIPPED,"'",            #210616 add by ruby
                         " '",tm.v CLIPPED,"'",            #210616 add by ruby         
                         " '",g_wc CLIPPED,"'",            #FUN-A70084
                         " '",tm.a CLIPPED,"'"             #CHI-B10027
                         
         CALL cl_cmdat('cxmr620',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cxmr620()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr620_w
END FUNCTION
 
FUNCTION cxmr620()
   DEFINE l_name    LIKE type_file.chr20,      # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          l_time    LIKE type_file.chr8,       #No.FUN-6A0094
          l_sql     STRING,                    #TQC-B50069
          l_chr     LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
         l_order    ARRAY[5] OF LIKE oea_file.oea01,             # No.FUN-680137  VARCHAR(16)   #No.FUN-550070
         sr               RECORD order1 LIKE oea_file.oea01,     # No.FUN-680137  VARCHAR(16)
                                 order2 LIKE oea_file.oea01,     # No.FUN-680137  VARCHAR(16)
                                 order3 LIKE oea_file.oea01,     # No.FUN-680137  VARCHAR(16)
                                  oga01 LIKE oga_file.oga01,    #
                                  oga02 LIKE oga_file.oga02,
                                  oga03 LIKE oga_file.oga03,
                                  oga032 LIKE oga_file.oga032,
                                  oga04 LIKE oga_file.oga04,
				                          occ02 LIKE occ_file.occ02,
                                  oga14 LIKE oga_file.oga14,
                                  oga27 LIKE oga_file.oga27,   #181218 add by ruby
                                  oga15 LIKE oga_file.oga15,
                                  ogb03 LIKE ogb_file.ogb03,   #單身項次
                                  ogb31 LIKE ogb_file.ogb31,
                                  ogb32 LIKE ogb_file.ogb32,    #add by ruby 2018/03/30
                                  ogb04 LIKE ogb_file.ogb04,
                                  ogb06 LIKE ogb_file.ogb06,
                                  ogb05 LIKE ogb_file.ogb05,
                                  ogb13 LIKE ogb_file.ogb13,
                                  ogb12 LIKE ogb_file.ogb12,
                                  ogb14 LIKE ogb_file.ogb14,
                                  ogb14t LIKE ogb_file.ogb14t,   #add by ruby 2018/02/22
				                          oga10	LIKE oga_file.oga10,
                                  occ241 LIKE occ_file.occ241,   #200420 add by ruby
				                          azi03	LIKE azi_file.azi03,
				                          azi04	LIKE azi_file.azi04,
				                          azi05	LIKE azi_file.azi05,
				                          oga23 LIKE oga_file.oga23,
				                          oga24 LIKE oga_file.oga24,
				                          ogb910 LIKE ogb_file.ogb910,
				                          ogb912 LIKE ogb_file.ogb912,
				                          ogb913 LIKE ogb_file.ogb913,
				                          ogb915 LIKE ogb_file.ogb915,
				                          ogb916 LIKE ogb_file.ogb916,
				                          ogb917 LIKE ogb_file.ogb917
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5               #No.FUN-580004        #No.FUN-680137 SMALLINT
     DEFINE i                  LIKE type_file.num5               #No.FUN-580004        #No.FUN-680137 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02  #No.FUN-580004
     DEFINE  l_gen02      LIKE gen_file.gen02,
             l_gem02      LIKE gem_file.gem02,
             l_ima021t    LIKE ima_file.ima021,
             l_ima906     LIKE ima_file.ima906,
             l_str2       LIKE type_file.chr50,
             l_ogb915     STRING,
             l_ogb912     STRING,
             l_ogb12      STRING,
             l_oea10      LIKE oea_file.oea10  #add by ruby 2018/02/22
 DEFINE
      g_ogc        RECORD
                   ogc12 LIKE ogc_file.ogc12,
                   ogc17 LIKE ogc_file.ogc17
              END RECORD,
      l_oaz23   LIKE oaz_file.oaz23,
      l_ima02   LIKE ima_file.ima02,
      l_ima021  LIKE ima_file.ima021,
      l_imaud02 LIKE ima_file.imaud09, #自製率
      l_ima1007 LIKE ima_file.ima1007, #型號
      l_oba02   LIKE oba_file.oba02,   #分類名稱
      l_azf03   LIKE azf_file.azf03,   #系列
      l_ima02t  LIKE ima_file.ima02
     DEFINE     l_dbs      LIKE azp_file.azp03                               
     DEFINE     l_azp03    LIKE azp_file.azp03                               
     DEFINE     l_occ37    LIKE occ_file.occ37                               
    #FUN-EA0031--add str--
     DEFINE l_ogbc05  LIKE ogbc_file.ogbc05,
            l_ogbc06  LIKE ogbc_file.ogbc06,
            l_ogbc07  LIKE ogbc_file.ogbc07,
            l_ogbc05_name  LIKE agd_file.agd03,    #尺寸
            l_ogbc06_name  LIKE agd_file.agd03,    #顏色
            l_ogbc07_1     LIKE ogbc_file.ogbc07,  #數量(1~10)
            l_ogbc07_2     LIKE ogbc_file.ogbc07,  #數量(11~20)
            l_ogbc07_3     LIKE ogbc_file.ogbc07,  #數量(21~30)
            l_ogbc07_4     LIKE ogbc_file.ogbc07,  #數量(31~40)
            l_next         LIKE type_file.num5,
            l_agd04_color  LIKE agd_file.agd04,
            l_agd04_size   LIKE agd_file.agd04,
            l_flag1        LIKE type_file.chr1,
            l_cnt1         LIKE type_file.num5
    #FUN-EA0031--add end--
    
     CALL cl_del_data(l_table)   #FUN-8B0025 換位置
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-560229
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')

   LET l_sql = "SELECT azw01 FROM azw_file,azp_file ",
               " WHERE azp01 = azw01 AND azwacti = 'Y'",
               "   AND azw01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"')",
               "   AND ",g_wc CLIPPED 
   PREPARE sel_azw01_pre FROM l_sql
   DECLARE sel_azw01_cur CURSOR FOR sel_azw01_pre
   FOREACH sel_azw01_cur INTO m_plant
     IF cl_null(m_plant) THEN CONTINUE FOREACH END IF 
        
     LET l_sql = "SELECT azi03,azi04 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'azi_file'),  
                 " WHERE azi01=? "                                                                                                                                                                                  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql  
     PREPARE azi_prepare FROM l_sql                                                                                          
     DECLARE azi_c  CURSOR FOR azi_prepare                                                                                 

     LET l_sql = "SELECT gen02 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'gen_file'),  
                 " WHERE gen01=? "                                                                                                                                                                                  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql 
     PREPARE r620_prepare1 FROM l_sql                                                                                          
     DECLARE r620_c1  CURSOR FOR r620_prepare1                                                                                 

     LET l_sql = "SELECT gem02 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'gem_file'),  
                 " WHERE gem01=? "                                                                                                                                                                                  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql 
     PREPARE r620_prepare2 FROM l_sql                                                                                          
     DECLARE r620_c2  CURSOR FOR r620_prepare2                                                                                 

     LET l_sql = "SELECT ima_file.ima021,ima_file.ima1007,oba02,azf03 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'ima_file') ,
                 " LEFT JOIN ",cl_get_target_table(m_plant, 'oba_file') ,
                 "  ON oba01 = ima131 ", 
                 " LEFT JOIN ",cl_get_target_table(m_plant, 'azf_file') ,
                 "  ON azf01 = ima09 AND azf02='D' ", 
                 " WHERE ima_file.ima01=? "                                                                                                                                                                                  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql  
     PREPARE r620_prepare3 FROM l_sql                                                                                          
     DECLARE r620_c3  CURSOR FOR r620_prepare3                                                                                 

     LET l_sql = "SELECT ima021,ima906 ",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'ima_file'),  
                 " WHERE ima01=? "                                                                                                                                                                                  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql  
     PREPARE r620_prepare4 FROM l_sql                                                                                          
     DECLARE r620_c4  CURSOR FOR r620_prepare4                                                                                 

     LET l_sql = "SELECT omb01",                                                                                                 
                 "  FROM ",cl_get_target_table(m_plant, 'omb_file'),",",
                 cl_get_target_table(m_plant, 'oma_file'),               
                 " WHERE omb01 = oma01",                                                                              
                 "   AND omb31=? ",                                                                                  
                 "   AND omb32=? ",   
                 "   AND oma00='12'",      #MOD-B40096 add
                 "   AND omavoid = 'N'"    #不可作廢                                                                               
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql      
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql 
     PREPARE r620_prepare5 FROM l_sql                                                                                          
     DECLARE r620_c5  CURSOR FOR r620_prepare5                                                                                 

     LET l_sql = "SELECT oaz23",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'oaz_file')  
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql  
     PREPARE r620_prepare6 FROM l_sql                                                                                          
     DECLARE r620_c6  CURSOR FOR r620_prepare6                                                                                 

     LET l_sql = "SELECT ima02,ima021",                                                                              
                 "  FROM ",cl_get_target_table(m_plant, 'ima_file'),  
                 " WHERE ima01=? "                                                                                                                                            
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql  
     PREPARE r620_prepare7 FROM l_sql                                                                                          
     DECLARE r620_c7  CURSOR FOR r620_prepare7                                                                                 
     #CHI-AC0013 add --end-- 
 
     LET l_sql = "SELECT '','','',",
                 "       oga01,oga02,oga03,oga032,oga04,occ02,oga14,oga27, ",   #181218 add by ruby
		 "       oga15,ogb03,ogb31,ogb32,ogb04,ogb06,ogb05, ",              #add by ruby 2018/03/30
		 "       ogb13,ogb12,ogb14,ogb14t,oga10,occ241, ",                  #add by ruby 2018/02/22 #200420 add occ241 by ruby
                 "       azi03,azi04,azi05,oga23,oga24, ",
                 "       ogb910,ogb912,ogb913,ogb915,ogb916,ogb917,  ", #No.FUN-580004
                 "       occ37",                                        #NO.FUN-8B0025
                 "  FROM ",cl_get_target_table(m_plant, 'oga_file'),
                 "  LEFT OUTER JOIN ",cl_get_target_table(m_plant, 'occ_file'),
                 "          ON oga_file.oga04 = occ_file.occ01,",  
                 cl_get_target_table(m_plant, 'ogb_file'),",",            
                 cl_get_target_table(m_plant, 'azi_file'),               
                 " WHERE oga01 = ogb_file.ogb01 ",
                 "   AND oga23 = azi_file.azi01 ",
		 ##--- 221228 剔除買進賣出(S)
                 "   AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(m_plant, 'pmn_file'),                              #20221228 add        
                 "          WHERE ogb31 = pmn24 AND ogb32 = pmn25 AND ogb04= pmn04 AND pmn16 between '1' and '8') ",        #20221228 add 
                 ##--- 221228 剔除買進賣出(E)
                 "   AND oga09 = '2' ", 
                 "   AND ogaconf = 'Y' ", 
                 "   AND ",tm.wc CLIPPED	

     #-----CHI-B10027---------
     IF tm.a = 'N' THEN
        LET l_sql = l_sql," AND oga09 != 'A' "
     END IF
     #-----END CHI-B10027-----

     #No.FUN-950110--ADD--
         IF tm.oga00 MATCHES '[1234]' THEN
            LET l_sql=l_sql CLIPPED,"  AND oga00='",tm.oga00,"' "
         END IF
     #No.FUN-950110--END--

     #No.FUN-940116--ADD--
         IF tm.x='1' THEN LET l_sql=l_sql CLIPPED," AND ogaconf='Y' " END IF
         IF tm.x='2' THEN LET l_sql=l_sql CLIPPED," AND ogaconf='N' " END IF
         IF tm.v='1' THEN LET l_sql=l_sql CLIPPED," AND ogapost='Y' " END IF
         IF tm.v='2' THEN LET l_sql=l_sql CLIPPED," AND ogapost='N' " END IF
     #No.FUN-940116--END--

     CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #FUN-A70084
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #NO.FUN-A70084
     PREPARE cxmr620_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
     END IF
     DECLARE cxmr620_curs1 CURSOR FOR cxmr620_prepare1
   
 
     FOREACH cxmr620_curs1 INTO sr.*,l_occ37                          #FUN-8B0025 Add l_occ37
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #MOD-G50062 --- add Start ---
       IF cl_null(sr.oga14) THEN
          LET sr.oga14 = ' '
       END IF
       IF cl_null(sr.oga15) THEN
          LET sr.oga15 = ' '
       END IF 
       #MOD-G50062 --- add End ---
       
        IF cl_null(l_occ37) THEN LET l_occ37 = 'N' END IF
        IF tm.type = '1' THEN
           IF l_occ37  = 'N' THEN  CONTINUE FOREACH END IF
        END IF
        IF tm.type = '2' THEN   #非關係人
           IF l_occ37  = 'Y' THEN  CONTINUE FOREACH END IF
        END IF
       
       IF tm.y='Y' THEN    #將原幣金額轉成本幣金額
          LET sr.oga23=g_aza.aza17            #幣別
          LET sr.ogb14=sr.ogb14 * sr.oga24    #未稅金額*匯率
          LET sr.ogb14t=sr.ogb14t * sr.oga24    #含稅金額*匯率 #add by ruby 2018/02/22
          LET sr.ogb13=sr.ogb13 * sr.oga24    #No.B512 add by linda 換成本幣

                OPEN azi_c USING sr.oga23 #CHI-AC0013                                                                                    
                FETCH azi_c INTO sr.azi03,sr.azi04
            SELECT azi05 INTO sr.azi05
              FROM azi_file WHERE azi01=sr.oga23         
           
       END IF
       LET sr.ogb14 = cl_digcut(sr.ogb14,sr.azi04)   #MOD-890003
       LET sr.ogb14t = cl_digcut(sr.ogb14t,sr.azi04)   #add by ruby 2018/02/22
 
             OPEN r620_c1 USING sr.oga14 #CHI-AC0013
             LET l_gen02 = ' '           #MOD-G50062  --- add             
             FETCH r620_c1 INTO l_gen02
 
             OPEN r620_c2 USING sr.oga15 #CHI-AC0013
             LET l_gem02 = ' '           #MOD-G50062  --- add                          
             FETCH r620_c2 INTO l_gem02
       
       IF sr.ogb04[1,4] !='MISC' THEN
          OPEN r620_c3 USING sr.ogb04 #CHI-AC0013                                                                                   
          FETCH r620_c3 INTO l_ima021,l_ima1007,l_oba02,l_azf03,l_imaud02
          #抓暫存資料使用
          LET l_imaud02=0
          #SELECT imaud02 INTO l_imaud02 FROM r620_cxmr620 #20220804
          # WHERE ima1007 = l_ima1007 AND rownum = 1       #20220804
          ##---- 20220804 取用標準件
          SELECT imaud02 INTO l_imaud02
            FROM ty.ima_file,ty.tc_aaf_file  #20221228 指定使用TY
           WHERE ima01 = tc_aaf02
             AND tc_aaf01 = l_ima1007
       ELSE
         LET l_ima021 = ''
       END IF
         
               OPEN r620_c4 USING sr.ogb04 #CHI-AC0013                                                                                    
               FETCH r620_c4 INTO l_ima021,l_ima906
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
            IF sr.ogb05  <> sr.ogb916 THEN   #No.TQC-6B0137  mod
               CALL cl_remove_zero(sr.ogb12) RETURNING l_ogb12
               LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
            END IF
      END IF
     #因有同出貨單但項次為不同AR,以單身的出貨項次去取omb01
      LET sr.oga10=''
    
            OPEN r620_c5 USING sr.oga01,sr.ogb03 #CHI-AC0013                                                                                   
            FETCH r620_c5 INTO sr.oga10
 
      LET l_flag = 'N'  #MOD-7A0115
  
            OPEN r620_c6                                                                                    
            FETCH r620_c6 INTO l_oaz23
      IF l_oaz23 = 'Y' AND tm.c='Y' THEN
         LET g_sql = "SELECT ogc12,ogc17 ",
                     "  FROM ",cl_get_target_table(m_plant, 'ogc_file'),   #NO.FUN-A70084
                     " WHERE ogc01 = '",sr.oga01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql      #FUN-A70084  
         CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #NO.FUN-A70084
         PREPARE ogc_prepare FROM g_sql
         DECLARE ogc_cs CURSOR FOR ogc_prepare
         FOREACH ogc_cs INTO g_ogc.*
            LET l_flag = 'Y'

                  OPEN r620_c7 USING g_ogc.ogc17 #CHI-AC0013                                                                                   
                  FETCH r620_c7 INTO l_ima02t,l_ima021t

      #add by ruby 2018/02/22
      SELECT oea10 INTO l_oea10 FROM oea_file WHERE oea01=sr.ogb31
          IF STATUS THEN
         LET l_oea10 = '' 
      END IF 
      
            EXECUTE insert_prept111 USING sr.oga01,sr.oga02,
                                sr.oga03,sr.oga032,sr.oga04,sr.occ02,sr.oga14,sr.oga27,  #181218 add by ruby
                               l_gen02,sr.oga15,l_gem02,sr.ogb03,sr.ogb31,sr.ogb04,
                               sr.ogb06,l_ima021,l_ima1007,l_imaud02,l_oba02,l_azf03,l_str2,sr.ogb05,sr.oga23,
                               sr.ogb13,sr.ogb12,sr.ogb916,sr.ogb917,sr.ogb14,sr.ogb14t, #add by ruby ogb14t 2018/02/22
                              sr.oga10,l_oea10,sr.occ241,tm.y,                           #add by ruby l_oea10 2018/02/22 #200420 add occ241 by ruby
                              tm.c,     l_oaz23,  g_ogc.ogc17, l_ima02t,l_ima021t,     #FUN-8B0025 mod
                              g_ogc.ogc12,sr.azi03, sr.azi04, sr.azi05, m_plant     #FUN-A70084
         END FOREACH      	 
      END IF

      #add by ruby 2018/02/22
      SELECT oea10 INTO l_oea10 FROM oea_file WHERE oea01=sr.ogb31
          IF STATUS THEN
         LET l_oea10 = '' 
      END IF 
      
      IF l_flag != 'Y' THEN
          EXECUTE insert_prept111 USING sr.oga01,sr.oga02,
                                sr.oga03,sr.oga032,sr.oga04,sr.occ02,sr.oga14,sr.oga27,   #181218 add by ruby
                               l_gen02,sr.oga15,l_gem02,sr.ogb03,sr.ogb31,sr.ogb32,sr.ogb04,   #add by ruby ogb03 2018/03/30
                               sr.ogb06,l_ima021,l_ima1007,l_imaud02,l_oba02,l_azf03,l_str2,sr.ogb05,sr.oga23,
                               sr.ogb13,sr.ogb12,sr.ogb916,sr.ogb917,sr.ogb14,sr.ogb14t,  #add by ruby ogb14t 2018/02/22
                              sr.oga10,l_oea10,sr.occ241,tm.y,tm.c,l_oaz23,                         #add by ruby l_oea10 2018/02/22
                              g_ogc.ogc17,l_ima02t,l_ima021t,g_ogc.ogc12,sr.azi03,
                              sr.azi04,sr.azi05,m_plant                           #FUN-A70084  
      END IF
      LET l_flag = 'N' 

    
     END FOREACH
 
    END FOREACH    #FUN-A70084   
 
     LET l_sql = " SELECT *",
                 "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'cxmr620'  
     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'oga01,oga02,oga03,oga04,oga14,oga15,oga23,ogb04')   #No.FUN-6C0039
              RETURNING tm.wc                
     END IF     
     LET l_str = tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                 tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",
                 tm.wc CLIPPED,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3]
              CALL cl_prt_cs3('cxmr620','cxmr620',l_sql,l_str)
     
END FUNCTION
 

