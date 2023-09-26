# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cxmp413.4gl
# Descriptions...: 訂單前行單轉訂單批次作業
# Date & Author..: No:20230908 By momo


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE g_tc_mpn1   DYNAMIC ARRAY OF RECORD
                  select       LIKE type_file.chr1,   #選擇
                  tc_mpn01     LIKE tc_mpn_file.tc_mpn01, 
                  tc_mpn02     LIKE tc_mpn_file.tc_mpn02,     
                  tc_mpn03     LIKE tc_mpn_file.tc_mpn03,
                  occ02        LIKE occ_file.occ02,
                  tc_mpn04     LIKE tc_mpn_file.tc_mpn04,
                  tc_mpn06     LIKE tc_mpn_file.tc_mpn06,
                  ima02        LIKE ima_file.ima02,
                  ima021       LIKE ima_file.ima021,
                  tc_mpn07     LIKE tc_mpn_file.tc_mpn07,
                  tc_mpn14     LIKE tc_mpn_file.tc_mpn14,
                  tc_mpn15     LIKE tc_mpn_file.tc_mpn15
               END RECORD,
       g_tc_mpn1_t RECORD
                  select       LIKE type_file.chr1,   #選擇
                  tc_mpn01     LIKE tc_mpn_file.tc_mpn01, 
                  tc_mpn02     LIKE tc_mpn_file.tc_mpn02,     
                  tc_mpn03     LIKE tc_mpn_file.tc_mpn03,
                  occ02        LIKE occ_file.occ02,
                  tc_mpn04     LIKE tc_mpn_file.tc_mpn04,
                  tc_mpn06     LIKE tc_mpn_file.tc_mpn06,
                  ima02        LIKE ima_file.ima02,
                  ima021       LIKE ima_file.ima021,
                  tc_mpn07     LIKE tc_mpn_file.tc_mpn07,
                  tc_mpn14     LIKE tc_mpn_file.tc_mpn14,
                  tc_mpn15     LIKE tc_mpn_file.tc_mpn15
               END RECORD,
       g_tc_mpn  RECORD       LIKE tc_mpn_file.*,      
       g_oea  RECORD       LIKE oea_file.*,       #訂單單頭
       g_oeb  RECORD       LIKE oeb_file.*,       #訂單單身
       g_oea01             LIKE oea_file.oea01,   #訂單單號
       begin_no,end_no     LIKE oea_file.oea01,
       end_no_old          LIKE oea_file.oea01,   
       g_wc2,g_sql,g_ws1,g_ws2    STRING,
       g_rec_b        LIKE type_file.num5,         
       g_rec_b1       LIKE type_file.num5,         
       l_ac1          LIKE type_file.num5,         
       l_ac1_t        LIKE type_file.num5,         
       l_ac           LIKE type_file.num5          
DEFINE lg_group      LIKE oay_file.oay22   #當前單身中采用的組別
DEFINE g_cnt          LIKE type_file.num10         
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done STRING
DEFINE li_result      LIKE type_file.num5          
DEFINE g_msg          LIKE type_file.chr1000       
DEFINE l_msg          LIKE type_file.chr1000       
DEFINE mi_need_cons   LIKE type_file.num5
DEFINE g_dbs2          LIKE type_file.chr30   
DEFINE tm RECORD			      #
          slip         LIKE oay_file.oayslip, #單據別
          dt           LIKE oeb_file.oeb16,   #出通/出貨日期
          g            LIKE type_file.chr1    #匯總方式
      END RECORD,
      g_gfa  RECORD    LIKE gfa_file.*
DEFINE g_flag    LIKE type_file.chr1   
DEFINE g_flag2   LIKE type_file.chr1   
DEFINE t_aza41   LIKE type_file.num5        #單別位數 (by aza41)
DEFINE g_type         LIKE type_file.chr1   
DEFINE g_plant2       LIKE type_file.chr10  

MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP,                     #輸入的方式: 不打轉
      FIELD ORDER FORM
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  

   OPEN WINDOW p413_w WITH FORM "cxm/42f/cxmp413"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   LET g_plant2 = g_plant                    
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)    

   CASE g_aza.aza41
     WHEN "1"
       LET t_aza41 = 3
     WHEN "2"
       LET t_aza41 = 4
     WHEN "3"
       LET t_aza41 = 5 
   END CASE

   LET mi_need_cons = 1
   
   CREATE TEMP TABLE tmp1_file(
      tmp1_01  LIKE tc_mpn_file.tc_mpn02,
      tmp1_02  LIKE tc_mpn_file.tc_mpn01,
      tmp1_03  LIKE tc_mpn_file.tc_mpn03);

   #CREATE TEMP TABLE tmp2_file(
   #   tmp2_01  LIKE tc_mpn_file.tc_mpn01,
   #   tmp2_02  LIKE tc_mpn_file.tc_mpn03);
   CALL p413()

   CLOSE WINDOW p413_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  

END MAIN

FUNCTION p413()

   
   CLEAR FORM
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p413_q()
      END IF
      CALL p413_p1()
      IF INT_FLAG THEN EXIT WHILE END IF
      CASE g_action_choice

         WHEN "refresh_detail"
           CALL p413_b_fill(g_wc2)

         WHEN "select_all"   #全部選取
           CALL p413_sel_all('Y')

         WHEN "select_non"   #全部不選
           CALL p413_sel_all('N')

         WHEN "carry_so"      #轉訂單
           IF cl_chk_act_auth() THEN
             CALL s_showmsg_init()    
             CALL p413_dis_oea()
             CALL s_showmsg()       
           END IF

         WHEN "exporttoexcel" #匯出excel
           IF cl_chk_act_auth() THEN
             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_mpn1),'','')
           END IF
     
         WHEN "exit"
           EXIT WHILE
      END CASE
   END WHILE
END FUNCTION

FUNCTION p413_p1()
      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)

      INPUT ARRAY g_tc_mpn1 WITHOUT DEFAULTS FROM s_tc_mpn.*  #顯示並進行選擇
        ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
        
         BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF  
      
         BEFORE ROW
             LET l_ac1 = ARR_CURR()
             IF l_ac1 = 0 THEN
                LET l_ac1 = 1
             END IF
             CALL cl_show_fld_cont()
             LET l_ac1_t = l_ac1
             LET g_tc_mpn1_t.* = g_tc_mpn1[l_ac1].*

             IF g_rec_b1 > 0 THEN
               CALL cl_set_act_visible("select_all,select_non,carry_so", TRUE)
             ELSE
               CALL cl_set_act_visible("select_all,select_non,carry_so", FALSE)
             END IF

         ON CHANGE select
            IF cl_null(g_tc_mpn1[l_ac1].select) THEN 
               LET g_tc_mpn1[l_ac1].select = 'Y'
            END IF
            
         ON ACTION query
            LET mi_need_cons = 1
            EXIT INPUT

         ON ACTION refresh_detail
            LET g_action_choice="refresh_detail"
            LET g_idle_seconds = 0
            EXIT INPUT

         ON ACTION select_all   #全部選取
            LET g_action_choice="select_all"
            EXIT INPUT

         ON ACTION select_non   #全部不選
            LET g_action_choice="select_non"
            EXIT INPUT

         ON ACTION carry_so      #轉訂單
            LET g_action_choice="carry_so"
            EXIT INPUT

         ON ACTION exporttoexcel
            LET g_action_choice = "exporttoexcel"
            EXIT INPUT     

         ON ACTION help
            CALL cl_show_help()
            EXIT INPUT

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         ON ACTION exit
            LET g_action_choice="exit"
            EXIT INPUT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
            CALL cl_about()
      END INPUT
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p413_q()

   CALL p413_b_askkey()
END FUNCTION


FUNCTION p413_b_askkey()

   CLEAR FORM
   CALL g_tc_mpn1.clear()

   CALL cl_set_act_visible("accept,cancel", TRUE)
   CONSTRUCT g_wc2 ON tc_mpn01,tc_mpn02,tc_mpn03,tc_mpn06,tc_mpn07,
                      tc_mpn14,tc_mpn15    
                 FROM s_tc_mpn[1].tc_mpn01,s_tc_mpn[1].tc_mpn02,s_tc_mpn[1].tc_mpn03,
                      s_tc_mpn[1].tc_mpn06,s_tc_mpn[1].tc_mpn07,s_tc_mpn[1].tc_mpn14,
                      s_tc_mpn[1].tc_mpn15
                      

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(tc_mpn03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_occ"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tc_mpn03
                    NEXT FIELD tc_mpn03
                    
               WHEN INFIELD(tc_mpn06)                    
                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')   
                    RETURNING  g_qryparam.multiret                          
                    
                    DISPLAY g_qryparam.multiret TO tc_mpn06
                    NEXT FIELD tc_mpn06
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
   CALL cl_set_act_visible("accept,cancel", FALSE)

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   CALL p413_b_fill(g_wc2)

END FUNCTION

FUNCTION p413_b_fill(p_wc2)
   DEFINE p_wc2     STRING
   DEFINE l_cnt     LIKE type_file.num5   #CHI-B10003

   LET g_sql = "SELECT 'N',tc_mpn01,tc_mpn02,tc_mpn03,occ02,tc_mpn04,tc_mpn06,ima02,ima021,tc_mpn07,",
               "       tc_mpn14,tc_mpn15",   
               "  FROM ima_file,tc_mpn_file ",
               "  LEFT JOIN occ_file ON tc_mpn03 = occ01 ",                    
               " WHERE tc_mpn06 = ima01 ",
               "   AND tc_mpn00='1' AND tc_mpn10 = 'N' ",
               "   AND tc_mpnplant = '",g_plant,"'",
               "   AND NOT EXISTS (SELECT 1 FROM oea_file WHERE oea10=tc_mpn01 AND oea03=tc_mpn03 AND oeaconf <> 'X') ", 
               "   AND ", p_wc2 CLIPPED,
               " ORDER BY tc_mpn03,tc_mpn01,tc_mpn02"

   PREPARE p413_pb1 FROM g_sql
   DECLARE tc_mpn_curs CURSOR FOR p413_pb1
  
   CALL g_tc_mpn1.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"

   FOREACH tc_mpn_curs INTO g_tc_mpn1[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)  
         EXIT FOREACH
      END IF

      IF g_flag2 = 'N' THEN
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM oea_file,oeb_file
          WHERE oea01 = oeb01
            AND oeaconf <> 'X'
            AND oea10 = g_tc_mpn1[g_cnt].tc_mpn01 
            AND oea03 = g_tc_mpn1[g_cnt].tc_mpn03
         IF l_cnt > 0 THEN
            CONTINUE FOREACH   #此處要過濾掉已產生到訂單的單據
         END IF
      END IF

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH

   CALL  g_tc_mpn1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION


FUNCTION p413_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5
  FOR l_i = 1 TO g_rec_b1 
    LET g_tc_mpn1[l_i].select = p_flag
    DISPLAY BY NAME g_tc_mpn1[l_i].select
  END FOR
END FUNCTION


FUNCTION p413_dis_oea()
  DEFINE l_tc_mpn01   LIKE tc_mpn_file.tc_mpn01        #訂單單號
  DEFINE l_tc_mpn03   LIKE tc_mpn_file.tc_mpn03        #帳款客戶編號
  DEFINE l_tc_mpn04   LIKE tc_mpn_file.tc_mpn04        #送貨客戶編號
  DEFINE l_str     LIKE type_file.chr20
  DEFINE l_i,l_n       LIKE type_file.num5
  DEFINE l_cols  STRING
  
  LET begin_no = NULL
  LET end_no = NULL
  
  LET g_success = 'Y'
  BEGIN WORK

  DELETE FROM tmp1_file 
  FOR l_i = 1 TO g_rec_b1
     IF g_tc_mpn1[l_i].select = 'Y' THEN
        INSERT INTO tmp1_file(tmp1_01,tmp1_02,tmp1_03) VALUES (g_tc_mpn1[l_i].tc_mpn02,g_tc_mpn1[l_i].tc_mpn01,g_tc_mpn1[l_i].tc_mpn03)
     END IF
  END FOR


  LET g_sql = " SELECT DISTINCT tc_mpn01,tc_mpn03,tc_mpn04",  
              "  FROM tc_mpn_file ",
              " WHERE tc_mpn10='N' ",
              "   AND tc_mpn02||tc_mpn01||tc_mpn03 IN (SELECT tmp1_01||tmp1_02||tmp1_03 FROM tmp1_file)"    
 
  PREPARE tc_mpn_pre FROM g_sql
  DECLARE tc_mpn_cur2 CURSOR FOR tc_mpn_pre
  FOREACH tc_mpn_cur2 INTO  l_tc_mpn01, l_tc_mpn03,l_tc_mpn04
  
      ###在這一個foreach迴圈中就已經決定了要併成幾張出通/出貨單

       LET g_sql = "SELECT * FROM tc_mpn_file ",
                   " WHERE tc_mpn01 ='", l_tc_mpn01, "'",
                   "   AND tc_mpn03 ='", l_tc_mpn03, "'",
                   "   AND tc_mpn10 = 'N' ",
                   " AND tc_mpn02||tc_mpn01||tc_mpn03 IN (SELECT tmp1_01||tmp1_02||tmp1_03 FROM tmp1_file)"   

      PREPARE tc_mpn_pre1  FROM g_sql
      DECLARE p413_tc_mpn_cs                     
        SCROLL CURSOR FOR tc_mpn_pre1
      #DELETE FROM tmp2_file   
      LET g_flag='N'  
      FOREACH p413_tc_mpn_cs INTO g_tc_mpn.*
      
         LET g_flag='Y'
        
      END FOREACH

      CALL p413_ins_oea()  
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
   END FOREACH

   IF g_success = 'N' THEN
      ROLLBACK WORK
      CALL cl_err('','abm-020',1)
   ELSE
      COMMIT WORK
      IF NOT cl_null(begin_no) THEN
         CALL cl_getmsg("mfg0101",g_lang) RETURNING l_msg
         LET l_msg = l_msg ,begin_no CLIPPED,"~",end_no CLIPPED
         CALL cl_msgany("0","0",l_msg CLIPPED)
      END IF
      CALL p413_b_fill(g_wc2)
   END IF
END FUNCTION

FUNCTION p413_ins_oea()   
   DEFINE l_cnt     LIKE type_file.num5   
   DEFINE l_oao    RECORD LIKE oao_file.*   
   DEFINE l_t       LIKE oay_file.oayslip  
   DEFINE l_oeb03   LIKE oeb_file.oeb03
   DEFINE l_occ21   LIKE occ_file.occ21      #國別
   DEFINE exT       LIKE oaz_file.oaz52      #匯率控制 
   
   INITIALIZE g_oea.* TO NULL 
   #Default初植
      LET g_oea.oea00  = '1'       #類別
      LET g_oea.oea02  = g_today
      LET g_oea.oea03  = g_tc_mpn.tc_mpn03
      LET g_oea.oea17  = g_tc_mpn.tc_mpn03
      LET g_oea.oea04  = g_tc_mpn.tc_mpn03
      LET g_oea.oea10  = g_tc_mpn.tc_mpn01        #客戶PO
      LET g_oea.oealegal = g_legal
      LET g_oea.oeaplant = g_plant
      LET g_oea.oea63  = 0
      LET g_oea.oea62  = 0
      LET g_oea.oea61  = 0
      LET g_oea.oea1008  = 0
      LET g_oea.oea09  = g_oaz.oaz201
      LET g_oea.oea85  = '2'
      LET g_oea.oea37  = 'N'
      LET g_oea.oea50  = 'N'
      LET g_oea.oea18  = 'N'
      LET g_oea.oea07  = 'N'
      LET g_oea.oea11  = '1'
      LET g_oea.oea161 = 0
      LET g_oea.oea162 = 100
      LET g_oea.oea261 = 0
      LET g_oea.oea262 = 0
      LET g_oea.oea263 =0
      LET g_oea.oeaconf = 'N'
      LET g_oea.oea49   = '0'
      LET g_oea.oeaoriu = g_user
      LET g_oea.oeaorig = g_grup
      LET g_oea.oea06 = g_oaz.oaz41
      LET g_oea.oea1005='N'
      LET g_oea.oea1012='N'
      LET g_oea.oea905 ='N'

   #預設客戶相關資料
   SELECT occ02,occ04,occ42,occ41,occ45,
          occ44,occ03,occ21,gen03,occ08,
          occ65
     INTO g_oea.oea032,g_oea.oea14,g_oea.oea23,g_oea.oea21,g_oea.oea32,
          g_oea.oea31,g_oea.oea25,l_occ21,g_oea.oea15,g_oea.oea05,
          g_oea.oea65
     FROM occ_file
     LEFT JOIN gen_file ON gen01 = occ04
    WHERE occ01 = g_oea.oea03

   LET g_oea.oeauser = g_oea.oea14
   LET g_oea.oeagrup = g_oea.oea15

   #判斷稅
   SELECT gec04,gec05,gec07
     INTO g_oea.oea211,g_oea.oea212,g_oea.oea213
     FROM gec_file
    WHERE gec01 = g_oea.oea21
      AND gec011 = '2'  #銷項

   #依國別判斷內外銷
   IF g_aza.azaud02 = l_occ21 THEN
      LET g_oea.oea08 = '1'
      LET exT = g_oaz.oaz52
   ELSE
      LET g_oea.oea08 = '2'
      LET exT = g_oaz.oaz70
   END IF

   #匯率
   CALL s_curr3(g_oea.oea23,g_oea.oea02,exT) RETURNING g_oea.oea24
   IF cl_null(g_oea.oea24) THEN
      LET g_oea.oea24 = 0
   END IF

   #預設單別
   SELECT rye03 INTO tm.slip FROM rye_file
    WHERE ta_rye01 = 'cxmp413'
      AND rye02='30'

   #維修件改單別為 5398
   IF g_tc_mpn.tc_mpn04='Y' THEN
      LET tm.slip = cl_replace_str(tm.slip,"5301","5398")
   END IF

   LET l_t = s_get_doc_no(tm.slip)                                                                                     
   SELECT oayapr INTO g_oea.oeamksg FROM oay_file WHERE oayslip=l_t 
   
   CALL s_auto_assign_no("axm",tm.slip,g_oea.oea02,"30","oea_file","oea01","","","")
     RETURNING li_result,g_oea.oea01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
   
   INSERT INTO oea_file VALUES(g_oea.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','','p413_ins_oea()',SQLCA.sqlcode,1)      
      LET g_success = 'N'
      RETURN
   END IF
   IF cl_null(begin_no) THEN 
      LET begin_no = g_oea.oea01
   END IF
   LET end_no_old = end_no  
   LET end_no=g_oea.oea01

   LET g_sql = "SELECT * FROM tc_mpn_file ",
               " WHERE tc_mpn01 = '",g_tc_mpn.tc_mpn01,"' ",
               "   AND tc_mpn03 = '",g_tc_mpn.tc_mpn03,"' ",
               "   AND tc_mpn10 = 'N' ",
               "   AND tc_mpn02||tc_mpn01||tc_mpn03 IN (SELECT tmp1_01||tmp1_02||tmp1_03 FROM tmp1_file)"   
    
   LET l_oeb03 = 0
   PREPARE p413_prepare1 FROM g_sql
   IF SQLCA.sqlcode THEN 
      CALL s_errmsg('','','',SQLCA.sqlcode,1)   
      LET g_success = 'N'
      RETURN 
   END IF
   DECLARE p413_cs1 CURSOR WITH HOLD FOR p413_prepare1
   FOREACH p413_cs1 INTO g_tc_mpn.* 
            
         LET l_oeb03 = l_oeb03 + 1
         IF SQLCA.sqlcode THEN 
            CALL s_errmsg('','','prepare:',SQLCA.sqlcode,1)  
            LET g_success = 'N'
            RETURN 
         END IF
     
         #現返
	
         LET g_oeb.oeb03  = l_oeb03     #項次
         CALL p413_ins_oeb()  
         INITIALIZE g_tc_mpn.* LIKE tc_mpn_file.*   #DEFAULT 設定
         INITIALIZE g_oeb.*    LIKE oeb_file.*      #DEFAULT 設定
   END FOREACH
 
END FUNCTION
 
FUNCTION p413_ins_oeb() 
   DEFINE l_flag   LIKE type_file.num5,           
          l_ima25  LIKE ima_file.ima25
   DEFINE l_cnt    LIKE type_file.num5

   #Default初植
   LET g_oeb.oeb01  = g_oea.oea01           #訂單單號
   LET g_oeb.oeb04  = g_tc_mpn.tc_mpn06     #產品編號
   LET g_oeb.oeb12  = g_tc_mpn.tc_mpn07     #訂單數量
   LET g_oeb.oeb15  = g_tc_mpn.tc_mpn14     #約交日
   LET g_oeb.oeb16  = g_tc_mpn.tc_mpn15     #排交日
   LET g_oeb.oeb04  = g_tc_mpn.tc_mpn06     #料件編號
   LET g_oeb.oeb71  = g_tc_mpn.tc_mpn02     #項次
   LET g_oeb.oeb19  = 'N'                   #備置否
   LET g_oeb.oeb70  = 'N'                   #是否結案
   LET g_oeb.oeb1012 = 'N'                  #是否結案
   LET g_oeb.oeb70d = NULL                  #結案日期
   LET g_oeb.oeb23  = 0
   LET g_oeb.oeb24  = 0
   LET g_oeb.oeb25  = 0
   LET g_oeb.oeb26  = 0
   LET g_oeb.oeb37  = 0
   LET g_oeb.oeb47  = 0
   LET g_oeb.oeb13  = 0
   LET g_oeb.oeb14  = 0
   LET g_oeb.oeb14t = 0
   LET g_oeb.oeb905 = 0
   LET g_oeb.oeb1006 = 100
   LET g_oeb.oeb44  = '1'
   LET g_oeb.oeb48  = '1'
   LET g_oeb.oeb1003= '1'
   LET g_oeb.oeb906 = 'N' #檢驗否
   LET g_oeb.oeb30 = ''
   LET g_oeb.oeb72 = NULL
   LET g_oeb.oeb930 = s_costcenter(g_oea.oea15) #成本中心
   LET g_oeb.oebplant = g_plant 
   LET g_oeb.oeblegal = g_legal 

   LET l_cnt = 0
   SELECT ima02,ima09,ima31,ima31_fac,tc_azf02 
     INTO g_oeb.oeb06,g_oeb.oebud03,g_oeb.oeb05,g_oeb.oeb05_fac,g_oeb.oebud04
     FROM ima_file
     LEFT JOIN tc_azf_file ON ima31=tc_azf01                    #取PM
     WHERE ima01 = g_oeb.oeb04
   
   INSERT INTO oeb_file VALUES(g_oeb.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','',"p413_ins_oeb():",SQLCA.sqlcode,1)  
      LET g_success = 'N'
      RETURN
   END IF
  
END FUNCTION
 
FUNCTION p413_init()
  CALL cl_set_comp_visible("oeb03",FALSE)
END FUNCTION
