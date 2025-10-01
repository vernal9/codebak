# Prog. Version..: '5.30.09-13.09.06(00000)'     #
 
# Pattern name...: cxmq003.4gl
# Descriptions...: 訂單管制明細表
# Date & Author..: 2018/08/07 By momo
# Modify.........: 2103195985 分批出貨只帶最後一筆出貨日
# Modify.........: No:2106116378 20210611 By momo 查詢增加 oeb04 欄位
# Modify.........: No:2110127090 20211013 By momo 增加顯示終端客戶簡稱
# Modify.........: No:2112097280 20211210 By momo 增加顯示 oebud05客戶設備編號
# Modify.........: No:23030003   20230306 By momo 增加顯示 oeb11 客戶產品編號、oebud02 客戶專案號、oebud01 單身備註
# Modify.........: No:23030016   20230310 By momo 增加顯示 ta_ima02 軸數
 
DATABASE ds
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
     DEFINE g_oeb DYNAMIC ARRAY OF RECORD
           oeb01         LIKE oeb_file.oeb01,  #訂單單號
           oeb03         LIKE oeb_file.oeb03,  #訂單項次
           oeb04         LIKE oeb_file.oeb04,  #訂單料件
           oea032        LIKE oea_file.oea032, #帳款客戶簡稱
           occ02         LIKE occ_file.occ02,  #終端客戶 20211013
           oea02         LIKE oea_file.oea02,  #接單日期
           oea10         LIKE oea_file.oea10,  #客戶PO
           pmm02         LIKE pmm_file.pmm02,  #採購單型態
           oeb092        LIKE oeb_file.oeb092, #訂單單號+批號
           ima021        LIKE ima_file.ima021, #規格
           oeb12         LIKE oeb_file.oeb12,  #訂單數量
           oeb15         LIKE oeb_file.oeb15,  #約定交貨日
           ogb12         LIKE ogb_file.ogb12,  #出貨單數量
           pmm01         LIKE pmm_file.pmm01,  #採購單號
           oga02         LIKE oga_file.oga02,  #出貨日期
           ogapost       LIKE oga_file.ogapost,#出貨扣帳否
           pmn33         LIKE pmn_file.pmn33,  #採購交期
           pmmud04       LIKE pmm_file.pmmud04,#到達地
           oeb24         LIKE oeb_file.oeb24,  #成品支數
           gen02         LIKE gen_file.gen02,  #業務員
           oeb15_1       LIKE oeb_file.oeb01,  #約交月份
           oga02_2       LIKE ogb_file.ogb01,  #出貨月份
           oeaud01       LIKE oea_file.oeaud01,#訂單備註
           oebud05       LIKE oeb_file.oebud05, #客戶設備編號 20211210
           oeb11         LIKE oeb_file.oeb11,  #客戶產品編號 20230306
           oebud02       LIKE oeb_file.oebud02,#客戶專案號 20230306
           oebud01       LIKE oeb_file.oebud01,#單身備註 20230306
           ta_ima02      LIKE ima_file.ta_ima02 #軸數 202303010
                     END RECORD
     DEFINE ga_color DYNAMIC ARRAY OF RECORD
           oeb01         LIKE oeb_file.oeb01,  #訂單單號
           oeb03         LIKE oeb_file.oeb03,  #訂單項次
           oeb04         LIKE oeb_file.oeb04,  #訂單料件
           oea032        LIKE oea_file.oea032, #帳款客戶簡稱
           occ02         LIKE occ_file.occ02,  #終端客戶 20211013
           oea02         LIKE oea_file.oea02,  #接單日期
           oea10         LIKE oea_file.oea10,  #客戶PO
           pmm02         LIKE pmm_file.pmm02,  #採購單型態
           oeb092        LIKE oeb_file.oeb092, #訂單單號+批號
           ima021        LIKE ima_file.ima021, #規格
           oeb12         LIKE oeb_file.oeb12,  #訂單數量
           oeb15         LIKE oeb_file.oeb15,  #約定交貨日
           ogb12         LIKE ogb_file.ogb12,  #出貨單數量
           pmm01         LIKE pmm_file.pmm01,  #採購單號
           oga02         LIKE oga_file.oga02,  #出貨日期
           ogapost       LIKE oga_file.ogapost,#出貨扣帳否
           pmn33         LIKE pmn_file.pmn33,  #採購交期
           pmmud04       LIKE pmm_file.pmmud04,#到達地
           oeb24         LIKE oeb_file.oeb24,  #成品支數
           gen02         LIKE gen_file.gen02,  #業務員
           oeb15_1       LIKE oeb_file.oeb15,  #約交月份
           oga02_2       LIKE oga_file.oga02,  #出貨月份
           oeaud01       LIKE oea_file.oeaud01,#訂單備註
           oebud05       LIKE oeb_file.oebud05,#客戶設備編號 20211210
           oeb11         LIKE oeb_file.oeb11,  #客戶產品編號 20230306
           oebud02       LIKE oeb_file.oebud02,#客戶專案號 20230306
           oebud01       LIKE oeb_file.oebud01,#單身備註 20230306
           ta_ima02      LIKE ima_file.ta_ima02 #軸數 202303010
                     END RECORD
    DEFINE g_argv1       LIKE rva_file.rva01    # INPUT ARGUMENT - 1
    DEFINE g_wc,g_sql 	 string                 #WHERE CONDITION  #No.FUN-580092 HCN
    DEFINE g_wc2 	 string                 #20220408
    DEFINE l_ac          LIKE type_file.num5    #目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
    DEFINE l_sl          LIKE type_file.num5    #目前處理的SCREEN LINE  #No.FUN-680096 SMALLINT
    DEFINE g_msg         STRING 

DEFINE   g_cnt           LIKE type_file.num10,  #No.FUN-680096 INTEGER
         g_rec_b         LIKE type_file.num5    #單身筆數    #No.FUN-680096 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8	     #No.FUN-6A0060
    DEFINE l_sl		 LIKE type_file.num5    #No.FUN-680096 SMALLINT
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵，由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("cxm")) THEN
      EXIT PROGRAM
   END IF
 
    #計算使用時間 (進入時間)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
 
    LET p_row = 4 LET p_col = 4
        
    OPEN WINDOW q003_w AT p_row,p_col WITH FORM "cxm/42f/cxmq003" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL q003_cs()
    CALL q003_b_fill()
    #處理功能選擇
    CALL q003_menu()
 
    CLOSE WINDOW q003_w
 
    #計算使用時間 (退出使間)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
 
END MAIN
 
# Describe: QBE 查詢資料
 
FUNCTION q003_cs()
 
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680096 SMALLINT
 
   #清除畫面
   CLEAR FORM
   CALL g_oeb.clear()
   CALL cl_opmsg('q')
 
   CONSTRUCT g_wc ON oeb01,oeb03,oeb04,oea032,oea02,oea10,ima021,oeb15,gen02,oga02
       FROM  s_oeb[1].oeb01,
             s_oeb[1].oeb03,
             s_oeb[1].oeb04,                    #20210611 add
             s_oeb[1].oea032,s_oeb[1].oea02,
             s_oeb[1].oea10,
             s_oeb[1].ima021,s_oeb[1].oeb15,
             s_oeb[1].gen02,s_oeb[1].oga02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
                 IF cl_null(g_wc) THEN
                    LET g_wc = " oea02 = '",g_today CLIPPED,"'"
                    DISPLAY g_today TO oea02
                 END IF
              #No.FUN-580031 --end--       HCN
     ON ACTION CONTROLP #FUN-4B0001
            IF INFIELD(gen02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "cq_gen10"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gen02
               NEXT FIELD gen02
            END IF
            
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
      
END FUNCTION
 
FUNCTION q003_menu()
   DEFINE   l_cmd    LIKE type_file.chr1000   #No.FUN-680096  VARCHAR(80)
 
   WHILE TRUE
      CALL q003_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q003_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"     
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oeb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q003_q()
 
    CALL cl_opmsg('q')
    DISPLAY '' TO FORMONLY.cn2
 
    CALL q003_cs()

    #LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gemuser', 'gemgrup') 
    IF INT_FLAG THEN 
        LET INT_FLAG = 0
        RETURN 
    END IF
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    END IF

    MESSAGE ''
    CALL q003_b_fill()
 
END FUNCTION
 
# Describe: BODY FILL UP
 
FUNCTION q003_b_fill()
 
    DEFINE l_sql     STRING
    CALL g_oeb.clear()
    CALL ga_color.clear()
    LET g_cnt = 1
    LET g_rec_b=0

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null)
   

    MESSAGE ' WAIT '
    LET g_sql=" SELECT oeb01,oeb03,oeb04,oea032,",
              "        '',",                                                   #20211013
              "        oea02,oea10,pmm02,oeb01||LPAD(oeb03,3,'0'),ima021,",
              "        oeb12,oeb15,0,pmm01,",
              "        oga02,'',pmn33,pmmud04,oeb12,gen02, ",
              "        '','',oeaud01,oebud05,              ",                  #20211210 add
              "        oeb11,oebud02,oebud01, ",                               #20230306
              "        ta_ima02 ",                                             #20230310
              " FROM gen_file,ima_file,oea_file , oeb_file ",
              "  LEFT JOIN pmn_file ON pmn24=oeb01 and pmn25=oeb03 ",
              "                          and pmn16 in ('0','1','2','S','W','R','6')",
              "  LEFT JOIN pmm_file ON pmn01=pmm01 and pmm18 !='X' ",
             #"  LEFT JOIN (SELECT * FROM ogb_file,oga_file ",                                                         #20210319 mark
              "  LEFT JOIN (SELECT MAX(oga02) oga02,ogb31,ogb32 FROM ogb_file,oga_file ",                              #20210319 modify
             #"              WHERE oga01=ogb01 AND oga09 IN ('2','4','6') AND ogapost='Y' ) ",                         #20210319 mark
              "              WHERE oga01=ogb01 AND oga09 IN ('2','4','6') AND ogapost='Y' GROUP BY ogb31,ogb32 ) ",    #20210319 modify
              "       ON ogb31=oeb01 and ogb32=oeb03 ",
              " WHERE oea01=oeb01 AND oea14=gen01 AND oeb04=ima01 AND oeaconf !='X' ",
              "   AND oeb70 ='N' and ",g_wc CLIPPED 
    
 
    PREPARE q003_prepare FROM g_sql
    DECLARE q003_cs CURSOR FOR q003_prepare
 
    FOREACH q003_cs INTO g_oeb[g_cnt].*
        
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
         
        #實際出貨數量
         SELECT SUM(ogb12) INTO g_oeb[g_cnt].ogb12
           FROM ogb_file,oga_file
          WHERE ogb31=g_oeb[g_cnt].oeb01 AND ogb32=g_oeb[g_cnt].oeb03
            AND oga09 IN ('2','4','6') AND ogaconf !='X'
            AND oga01=ogb01
         IF cl_null(g_oeb[g_cnt].ogb12) THEN LET g_oeb[g_cnt].ogb12=0 END IF
        #出貨量=訂單量時才帶出最後出貨日
         IF g_oeb[g_cnt].ogb12 = g_oeb[g_cnt].oeb12 THEN 
            SELECT MAX(oga02),ogapost
             INTO g_oeb[g_cnt].oga02,g_oeb[g_cnt].ogapost
             FROM oga_file,ogb_file
            WHERE ogb31=g_oeb[g_cnt].oeb01 AND ogb32=g_oeb[g_cnt].oeb03
              AND oga01=ogb01  AND oga09 IN ('2','4','6') AND ogaconf !='X'
            GROUP BY ogapost
            LET g_oeb[g_cnt].oga02_2 = MONTH(g_oeb[g_cnt].oga02) #出貨月份
         END IF
         LET g_oeb[g_cnt].oeb15_1 = MONTH(g_oeb[g_cnt].oeb15) #約交月份
     
  
         #換算支數，成品=訂單數量，非成品為0
         IF g_oeb[g_cnt].oeb04[1,1] <> '0' THEN
            LET g_oeb[g_cnt].oeb24=0
         END IF

         ##--- 20211013 終端客戶簡稱抓取(S)
         #潛在客戶
         SELECT ofd02 INTO g_oeb[g_cnt].occ02
           FROM ofd_file,oea_file
          WHERE ofd01 = oea04
            AND oea01 = g_oeb[g_cnt].oeb01

         IF cl_null(g_oeb[g_cnt].occ02) THEN
            SELECT occ02 INTO g_oeb[g_cnt].occ02   #一般客戶
              FROM occ_file,oea_file
             WHERE occ01 = oea04
               AND oea01 = g_oeb[g_cnt].oeb01
         END IF
         ##--- 20211013 終端客戶(E)

          IF g_oeb[g_cnt].ogb12 < g_oeb[g_cnt].oeb12 THEN
           LET ga_color[g_cnt].oeb01 ="RED REVERSE"
           LET ga_color[g_cnt].oeb03 =""
           LET ga_color[g_cnt].oeb04 =""
           LET ga_color[g_cnt].oea032 =""
           LET ga_color[g_cnt].oea02 =""
           LET ga_color[g_cnt].oea10 =""
           LET ga_color[g_cnt].pmm02 =""
           LET ga_color[g_cnt].oeb092 =""
           LET ga_color[g_cnt].ima021 =""
           LET ga_color[g_cnt].oeb12 ="RED REVERSE"
           LET ga_color[g_cnt].oeb15 ="RED REVERSE"
           LET ga_color[g_cnt].ogb12 =""
           LET ga_color[g_cnt].pmm01 =""
           LET ga_color[g_cnt].oga02 =""
           LET ga_color[g_cnt].ogapost =""
           LET ga_color[g_cnt].pmn33 =""
           LET ga_color[g_cnt].pmmud04 =""
           LET ga_color[g_cnt].oeb24 =""
           LET ga_color[g_cnt].gen02 =""
           LET ga_color[g_cnt].oeb15_1 =""
           LET ga_color[g_cnt].oga02_2 =""
           LET ga_color[g_cnt].oeaud01 =""
           LET ga_color[g_cnt].oebud05 =""   #20211210
        ELSE
           LET ga_color[g_cnt].oeb01 =""
           LET ga_color[g_cnt].oeb03 =""
           LET ga_color[g_cnt].oeb04 =""
           LET ga_color[g_cnt].oea032 =""
           LET ga_color[g_cnt].oea02 =""
           LET ga_color[g_cnt].oea10 =""
           LET ga_color[g_cnt].pmm02 =""
           LET ga_color[g_cnt].oeb092 =""
           LET ga_color[g_cnt].ima021 =""
           LET ga_color[g_cnt].oeb12 =""
           LET ga_color[g_cnt].oeb15 =""
           LET ga_color[g_cnt].ogb12 =""
           LET ga_color[g_cnt].pmm01 =""
           LET ga_color[g_cnt].oga02 =""
           LET ga_color[g_cnt].ogapost =""
           LET ga_color[g_cnt].pmn33 =""
           LET ga_color[g_cnt].pmmud04 =""
           LET ga_color[g_cnt].oeb24 =""
           LET ga_color[g_cnt].gen02 =""
           LET ga_color[g_cnt].oeb15_1 =""
           LET ga_color[g_cnt].oga02_2 =""
           LET ga_color[g_cnt].oeaud01 ="" 
           LET ga_color[g_cnt].oebud05 ="" #20211210 
        END IF
        
 
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    LET g_cnt = g_cnt - 1
    CALL SET_COUNT(g_cnt)                    #告訴I.單身筆數
    LET g_rec_b=g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cnt 
 
END FUNCTION
 
FUNCTION q003_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oeb TO s_oeb.*
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
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
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
       #No.MOD-530688  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
       #No.MOD-530688  --end
   
      ON ACTION refresh_detail
         CALL q003_b_fill()

      ON ACTION so_detail #訂單查詢
         LET g_msg = " axmt410 '", g_oeb[l_ac].oeb01,"'"
         CALL cl_cmdrun_wait(g_msg CLIPPED)


      ON ACTION po_detail #採購單查詢
         LET g_msg = " apmt540 '", g_oeb[l_ac].pmm01,"'"
         CALL cl_cmdrun_wait(g_msg CLIPPED)


      BEFORE DISPLAY
        CALL DIALOG.setCellAttributes(ga_color) 

      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
