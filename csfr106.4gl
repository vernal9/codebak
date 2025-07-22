# Prog. Version..: '5.30.24-17.04.13(00009)'     #
#
# Pattern name...: csfr106.4gl
# Descriptions...: 工單備料未發/缺料狀況表
# Date & Author..: 2021/05/07  By  momo

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD
#             wc      VARCHAR(600),   #TQC-630166
              wc      STRING,      #TQC-630166
              s       LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)
              t       LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)
              u       LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)
              bdate   LIKE type_file.dat,           #No.FUN-680121 DATE
              edate   LIKE type_file.dat,           #No.FUN-680121 DATE
              c       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
              d       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
              e       LIKE type_file.num10,         #241225 add by ruby
              more    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
              END RECORD,
         g_ordera  ARRAY[5] OF LIKE type_file.chr1000   #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
DEFINE   g_i          LIKE type_file.num5           #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   l_table      STRING                        #No.FUN-760046   
DEFINE   g_str        STRING                        #No.FUN-760046   
DEFINE   g_sql        STRING                        #No.FUN-760046   
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_sql = "order4.type_file.chr1000,",
               "sfa03.sfa_file.sfa03,",
               "sfb05.sfb_file.sfb05,",
               "sfb82.sfb_file.sfb82,",
               "ndate.type_file.dat,",
               "sfa12.sfa_file.sfa12,",
               "qty.sfa_file.sfa07,",
               "sfa07.sfa_file.sfa07,",
               "ima02.ima_file.ima02,",       #備料品名
               "ima021.ima_file.ima021,",     #備料規格
               "ta_sfb01.sfb_file.ta_sfb01,",
               "oea03.oea_file.oea03,",       #客戶代號
               "oea032.oea_file.oea032,",     #客戶名稱
               "ima021_2.ima_file.ima021,",   #訂單規格      
               "oeb12.oeb_file.oeb12,",       #訂單數量
               "oeb16.oeb_file.oeb16,",       #約交日
               "delay.type_file.num10 "       #延遲天數
   LET l_table = cl_prt_temptable('csfr106',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,? )"              
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN                                                                                                                  
      CALL cl_err('insert_prep:',status,1) 
      EXIT PROGRAM                                                                            
   END IF   
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.bdate  = ARG_VAL(11)
   LET tm.edate  = ARG_VAL(12)
   LET tm.c  = ARG_VAL(13)
   LET tm.d  = ARG_VAL(14)
   LET tm.e  = ARG_VAL(15)           #241225 add by ruby
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_xml.subject = ARG_VAL(19)   #241225 add by ruby  
   LET g_rpt_name = ARG_VAL(20)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r106_tm(0,0)
      ELSE CALL r106()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r106_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 4 LET p_col =20
 
   OPEN WINDOW r106_w AT p_row,p_col
        WITH FORM "csf/42f/csfr106"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.c    = 'Y'
   LET tm.d    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   LET tm2.u1 = "N"
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON sfa03,sfb01,ta_sfb01,sfb05,sfb13
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
       #### No.FUN-4A0006
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(sfa03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfa03
                NEXT FIELD sfa03
 
              WHEN INFIELD(sfb01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb9"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb01
                NEXT FIELD sfb01
 
              #WHEN INFIELD(sfb82)
              #  CALL cl_init_qry_var()
              #  LET g_qryparam.form = "q_gem"
              #  LET g_qryparam.state = 'c'
              #  CALL cl_create_qry() RETURNING g_qryparam.multiret
              #  DISPLAY g_qryparam.multiret TO sfb82
              #  NEXT FIELD sfb82
 
              WHEN INFIELD(sfb05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb05
                NEXT FIELD sfb05
             #TQC-D50043--add--end-----
           END CASE
      ### END  No.FUN-4A0006
 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION CONTROLG CALL cl_cmdask()   #add by hellen No.FUN-760046
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
     END CONSTRUCT
 
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF tm.wc =' 1=1' THEN CONTINUE WHILE END IF
 
     INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                     tm2.t1,tm2.t2,tm2.t3,
                     tm2.u1,tm2.u2,tm2.u3,
                     tm.bdate,tm.edate,tm.c,tm.d,tm.e,   #241225 add tm.e by ruby
                     tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD bdate
           #IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
        AFTER FIELD edate
           #IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
           IF tm.edate < tm.bdate THEN NEXT FIELD bdate END IF
 
        AFTER FIELD c
           IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN NEXT FIELD c END IF
 
        AFTER FIELD d
           IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN NEXT FIELD d END IF
 
        AFTER FIELD more
           IF tm.more = 'Y' THEN
              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
              RETURNING g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies
           END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        AFTER INPUT
           LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
           LET tm.t = tm2.t1,tm2.t2,tm2.t3
           LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
     END INPUT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file
               WHERE zz01='csfr106'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('csfr106','9031',1)
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc CLIPPED,"'",
                           " '",tm.s CLIPPED,"'",
                           " '",tm.t CLIPPED,"'",
                           " '",tm.u CLIPPED,"'",
                           " '",tm.bdate CLIPPED,"'",
                           " '",tm.edate CLIPPED,"'",
                           " '",tm.c CLIPPED,"'",
                           " '",tm.d CLIPPED,"'",
                           " '",tm.e CLIPPED,"'",               #241225 add by ruby
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_xml.subject CLIPPED,"'",        #241225 add by ruby                   
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
           CALL cl_cmdat('csfr106',g_time,l_cmd)
        END IF
        CLOSE WINDOW r106_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
 
     CALL cl_wait()
     CALL r106()
     ERROR ""
 
   END WHILE
 
   CLOSE WINDOW r106_w
END FUNCTION
 
FUNCTION r106()
   DEFINE l_name    LIKE type_file.chr20,                #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8              #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,              # RDSQL STATEMENT   #TQC-630166        #No.FUN-680121 VARCHAR(1000)
          l_sql     STRING,                              # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,                 #No.FUN-680121 VARCHAR(1)
          l_cnt     LIKE type_file.num5,                 #No.FUN-680121 SMALLINT
          l_order   ARRAY[4] OF LIKE sfa_file.sfa03,     #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
          l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          sr        RECORD
                    order1   LIKE sfa_file.sfa03,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    order2   LIKE sfa_file.sfa03,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    order3   LIKE sfa_file.sfa03,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    order4   LIKE type_file.chr1000,     #No.FUN-680121 VARCHAR(70)#FUN-5B0105 45->70
                    sfa03    LIKE sfa_file.sfa03,
                    sfb05    LIKE sfb_file.sfb05,
                    sfb82    LIKE sfb_file.sfb82,
                    ndate    LIKE type_file.dat,           #No.FUN-680121 DATE#需要日期 
                    sfb13    LIKE sfb_file.sfb13,         #No.TQC-A70128
                    sfa09    LIKE sfa_file.sfa09,         #No.TQC-A70128
                    sfa12    LIKE sfa_file.sfa12,
                    sfa08    LIKE sfa_file.sfa08,          #No.FUN-940008 add
                    sfa27    LIKE sfa_file.sfa27,          #No.FUN-940008 add
                    qty      LIKE sfa_file.sfa07,          #No.FUN-680121 DEC(12,3)#未發
                    sfa07    LIKE sfa_file.sfa07,   #欠料
                    ta_sfb01 LIKE sfb_file.ta_sfb01,
                    oea03    LIKE oea_file.oea03,
                    oea032   LIKE oea_file.oea032,
                    ima021_2 LIKE ima_file.ima021,
                    oeb12    LIKE oeb_file.oeb12,
                    oeb16    LIKE oeb_file.oeb16,
                    delay    LIKE type_file.num10
                    END RECORD
   DEFINE l_short_qty   LIKE sfa_file.sfa07        #FUN-940008 add
   DEFINE l_sfa05       LIKE sfa_file.sfa05        #FUN-940008 add
   
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     CALL cl_del_data(l_table)                                                                                                        
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                         
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
 
     LET l_sql = "SELECT '','','','',",
               # "       sfa03,sfb05,sfb82,'',sfb13,sfa09,",         #20210728 mark         
                 "       sfa03,'','','','',sfa09,",                  #20210728 modify
                 "       sfa12,sfa08,sfa27,SUM(sfa05-sfa06),'',",
                 "       ta_sfb01,oea03,oea032,'',0,'',0 ",    
                 " FROM sfa_file,sfb_file ",
                 " LEFT JOIN oea_file ON oea01 = SUBSTR(ta_sfb01,1,15) ",
                 " WHERE ", tm.wc CLIPPED,
                 "   AND sfb01 = sfa01 AND sfb87 ='Y' ",       
                 "   AND sfb04 != '8' AND sfa05-sfa06 > 0 ",
                 "   AND sfa11 != 'X' ",
                #" GROUP BY sfa03,sfb05,sfb82,sfb13,sfa09,sfa12,sfa08,sfa27, ta_sfb01,oea03,oea032 "                          
                 " GROUP BY sfa03,sfa09,sfa12,sfa08,sfa27, ta_sfb01,oea03,oea032 "                          
 
     PREPARE r106_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     DECLARE r106_curs1 CURSOR FOR r106_prepare1
 
 
     CALL g_ordera.clear()
 
     FOREACH r106_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
   
          #前置時間調整
          #IF cl_null(sr.sfa09) THEN
          #   LET sr.sfa09 = 0
          #END IF
          #LET sr.ndate =  sr.sfb13 + sr.sfa09
          #   IF NOT cl_null(tm.bdate) THEN
          #      IF sr.ndate < tm.bdate OR sr.ndate > tm.edate THEN
          #         CONTINUE FOREACH
          #      END IF
          #   END IF    

          #計算是否缺料     
          SELECT SUM(img10) INTO l_short_qty 
            FROM img_file
           WHERE img04 = sr.ta_sfb01
             AND img01 = sr.sfa03
          
          IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF 
          LET sr.sfa07 = sr.qty - l_short_qty 
          IF sr.sfa07 = 0 THEN CONTINUE FOREACH END IF 

          SELECT oeb12,oeb15,ima021,oeb15-sysdate
            INTO sr.oeb12,sr.oeb16,sr.ima021_2,sr.delay
            FROM oeb_file,ima_file
           WHERE oeb01||LPAD(oeb03,3,'0') = sr.ta_sfb01
             AND oeb04 = ima01
 
          IF sr.qty <=0 AND sr.sfa07 <= 0 THEN CONTINUE FOREACH END IF
          CASE 
             WHEN tm.c = 'Y' AND tm.d = 'N' 
                  IF sr.qty <=0 THEN CONTINUE FOREACH END IF
             WHEN tm.c = 'N' AND tm.d = 'Y' 
                  IF sr.sfa07 <= 0 THEN CONTINUE FOREACH END IF
             WHEN tm.c = 'N' AND tm.d = 'N'
                  CONTINUE FOREACH
          END CASE  
          LET sr.order4 = sr.ta_sfb01,sr.oeb16,sr.oea03,sr.sfa03,sr.ndate,sr.sfa12
          
 
          SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file  #add
           WHERE ima01 = sr.sfa03                                  #add
                     
          IF cl_null(tm.e) OR (NOT cl_null(tm.e) AND sr.delay<=tm.e) THEN       #241225 add by ruby
            EXECUTE insert_prep USING
                  sr.order4,sr.sfa03,sr.sfb05,sr.sfb82,sr.ndate,
                  sr.sfa12,sr.qty,sr.sfa07,l_ima02,l_ima021,
                  sr.ta_sfb01,sr.oea03,sr.oea032,sr.ima021_2,sr.oeb12,sr.oeb16,sr.delay 
          END IF                                                                #241225 add by ruby
     END FOREACH
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     IF g_zz05 = 'Y' THEN                                                                                                            
        CALL cl_wcchp(tm.wc,'sfa03,sfb03,sfb82,sfb05')
             RETURNING tm.wc                                                                                                         
        LET g_str = tm.wc                                                                                                            
     END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u
     CALL cl_prt_cs3('csfr106','csfr106',l_sql,g_str)     #FUN-A60027
 
END FUNCTION
 
 
