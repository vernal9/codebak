# Prog. Version..: '5.30.24-17.04.13(00010)'     #
#
# Pattern name...: cxmp411.4gl
# Descriptions...: 研發訂單檢核修改作業
# Date & Author..: 2019/10/25 By Momo
# Modify.........: No.2206228331 20220627 add by momo 增加研發訂單狀態 tc_oga07
# Modify.........: No.22110030   20221122 add by momo 訂單變更訂單狀態功能調整

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
    tm  RECORD
       	wc2  	STRING		
        END RECORD,
    g_oeb DYNAMIC ARRAY OF RECORD
            choice     LIKE type_file.chr1, 
            oea02      LIKE oea_file.oea02,
            oea08      LIKE oea_file.oea08,
            oea49      LIKE oea_file.oea49,
            oeb70d     LIKE oeb_file.oeb70d, #結案日期
            oep04      LIKE oep_file.oep04,  #訂單變更日
            oea032     LIKE oea_file.oea032, #帳款客戶
            occ02      LIKE occ_file.occ02,  #送貨客戶
            oeaud01    LIKE oea_file.oeaud01,#訂單單頭備註
            oea01      LIKE oea_file.oea01,  #批號
            oeb01      LIKE oeb_file.oeb01,
            oeb03      LIKE oeb_file.oeb04,
            oeb04      LIKE oeb_file.oeb04,
            oeb06      LIKE oeb_file.oeb06,
            ima021     LIKE ima_file.ima021,
            ima06      LIKE ima_file.ima06,
            imz02      LIKE imz_file.imz02,
            ima09      LIKE ima_file.ima09,
            azf03      LIKE azf_file.azf03,
            ima131     LIKE ima_file.ima131,
            oba02      LIKE oba_file.oba02,
            ima1007    LIKE ima_file.ima1007,
            ta_ima02   LIKE ima_file.ta_ima02,
            ta_ima04   LIKE ima_file.ta_ima04,
            ta_ima06   LIKE ima_file.ta_ima06,
            oeb12      LIKE oeb_file.oeb12,    
            oeb24      LIKE oeb_file.oeb24,     #出貨量  
            oeb16      LIKE oeb_file.oeb16,     #排交日 
            oeo07      LIKE oeo_file.oeo07,     #訂單存在選配件 
            bma05      LIKE bma_file.bma05,
            sfb01      LIKE sfb_file.sfb01,
            packing    LIKE type_file.chr1000, 
            tc_ogauser LIKE tc_oga_file.tc_ogauser,
            tc_oga05   LIKE tc_oga_file.tc_oga05,  #時間
            tc_oga06   LIKE tc_oga_file.tc_oga06,  #日期
            tc_oga07   LIKE tc_oga_file.tc_oga07   #訂單狀態 
        END RECORD,
    g_argv1              LIKE oea_file.oea02,
    g_before_input_done  LIKE type_file.num5,   
    g_query_flag         LIKE type_file.num5,    #第一次進入程式時即進入Query之後進入next 
    g_wc,g_wc2,g_sql    STRING,                  #WHERE CONDITION  
    g_rec_b              LIKE type_file.num10    #單身筆數  
DEFINE   g_cnt           LIKE type_file.num10         
DEFINE   g_msg           LIKE type_file.chr1000       
DEFINE   l_ac            LIKE type_file.num5          
DEFINE   g_row_count    LIKE type_file.num10         
DEFINE   g_curs_index   LIKE type_file.num10         
DEFINE   g_jump         LIKE type_file.num10         
DEFINE   g_no_ask      LIKE type_file.num5          
DEFINE   seconds       SMALLINT
DEFINE   l_cmd         LIKE type_file.chr1000
 
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
  
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  

    LET g_query_flag=1
 
    OPEN WINDOW p411_w WITH FORM "cxm/42f/cxmp410" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN 
       LET g_wc2 = " oea02 = '",g_argv1 CLIPPED,"'" 
       CALL p411_b_fill(g_wc2)
    ELSE
       CALL p411_q()
    END IF
    WHILE TRUE
      LET g_action_choice = ""
      CALL p411_menu()
      IF g_action_choice = 'exit' THEN EXIT WHILE END IF
    END WHILE
    CLOSE WINDOW p411_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION p411_b_askkey()

   #清除畫面
   CLEAR FORM
   CALL g_oeb.clear()
   CALL cl_opmsg('q')

   CONSTRUCT g_wc2 ON oea02,oea49,oeb70d,oep04,oeb01,oeb03,oeb04,oeb06,oeb12,oeb24,
                       ima021,
                       ima06,ima09,ima131,ima1007,
                       ta_ima02,ta_ima04,ta_ima06,
                       bma05,sfb01,
                       tc_ogauser,tc_oga05,
                       tc_oga07                                #20220627
                  FROM s_oeb[1].oea02,
                       s_oeb[1].oea49,
                       s_oeb[1].oeb70d,
                       s_oeb[1].oep04,
                       s_oeb[1].oeb01,s_oeb[1].oeb03,s_oeb[1].oeb04,
                       s_oeb[1].oeb06,
                       s_oeb[1].oeb12,
                       s_oeb[1].oeb24,
                       s_oeb[1].ima021,
                       s_oeb[1].ima06,s_oeb[1].ima09,s_oeb[1].ima131,s_oeb[1].ima1007,
                       s_oeb[1].ta_ima02,s_oeb[1].ta_ima04,s_oeb[1].ta_ima06,
                       s_oeb[1].bma05,s_oeb[1].sfb01,                          
                       s_oeb[1].tc_ogauser,s_oeb[1].tc_oga05,
                       s_oeb[1].tc_oga07                       #20220627
         
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
             IF NOT cl_null(g_argv1) THEN LET g_wc2 = " oea02 = '",g_argv1 CLIPPED,"'" END IF
    
             IF cl_null(g_wc2) THEN
                LET g_wc2 = " oea02 = '",g_today CLIPPED,"'"
                DISPLAY g_today TO oea02
             END IF
        
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

END FUNCTION
 
#中文的MENU
FUNCTION p411_menu()
   WHILE TRUE
      CALL p411_bp("G")
      CASE g_action_choice
           WHEN "detail"
                 IF cl_chk_act_auth() THEN
                    CALL p411_b()
                 END IF

           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL p411_q()
            END IF
           WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oeb),'','')
            END IF
           WHEN "output"
            #IF cl_chk_act_auth() THEN
               LET l_cmd = 'p_query "cxmr411" '
               CALL cl_cmdrun(l_cmd)
               RETURN
           # END IF
           ##-----20220627 add by momo (S)匯出EXCEL並更新狀態
           WHEN "exportstatus"
            IF cl_chk_act_auth() THEN
               CALL p411_b_fill(g_wc2)
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oeb),'','')
            END IF
           ##-----20220627 add by momo (E)
           WHEN "help" 
            CALL cl_show_help()
           WHEN "exit"
            EXIT WHILE
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
    CALL p411_b_askkey()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
	MESSAGE ''
    CALL p411_b_fill(g_wc2)
END FUNCTION
 
 
FUNCTION p411_show()
  
   CALL p411_b_fill(g_wc2) #單身
    CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION p411_b_fill(p_wc2)              
   DEFINE l_sql     STRING
   DEFINE l_ta_sfb01 LIKE sfb_file.ta_sfb01
   DEFINE p_wc2     STRING
 
   #IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
       
        "SELECT 'N',oea02,oea08,oea49,oeb70d,oep04,",
        "       oea03||oea032,occ01||occ02,oeaud01,",
        "       oeb01||LPAD(oeb03,3,'0'),",
        "       oeb01,oeb03,oeb04,oeb06,ima021,", 
        "       ima06,imz02,ima09,azf03,ima131,oba02,ima1007,ta_ima02,ta_ima04,",
        "       ta_ima06,",   
        "       oeb12,oeb24,oeb16,'N',bma05, ",
        "       sfb01, ",
        "       '',",
        "       tc_ogauser,tc_oga05,tc_oga06,tc_oga07 ",                                   #20220627 
        "  FROM oea_file ",
        "  LEFT JOIN occ_file ON oea04=occ01 , ",
        "       oeb_file ",
        "  LEFT JOIN sfb_file ON sfb22=oeb01 AND sfb221=oeb03 AND sfb87<>'X' ",            
        "  LEFT JOIN tc_oga_file ON tc_oga01=oeb01 AND tc_oga02=oeb03 AND tc_oga00='R' ",    
        "  LEFT JOIN (SELECT MAX(oep04) oep04,oeq01,oeq03 FROM oeq_file,oep_file ",
        "               WHERE oeq01=oep01 AND oeq04a LIKE '0%' GROUP BY oeq01,oeq03) ON oeq01=oeb01 AND oeq03=oeb03 ,",
        "       ima_file  ",
        "  LEFT JOIN bma_file ON bma01=ima01 ", 
        "  LEFT JOIN imz_file ON ima06=imz01 ",  
        "  LEFT JOIN azf_file ON ima09=azf01 ",
        "  LEFT JOIN oba_file ON ima131=oba01",
        " WHERE oea01=oeb01 AND oeaconf != 'X' ",
        "   AND ima01= oeb04 ", 
        "   AND ima08 = 'M' ", 
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY 3,4"
    PREPARE p411_pb FROM l_sql
    DECLARE p411_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR p411_pb
 
    FOR g_cnt = 1 TO g_oeb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_oeb[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH p411_bcs INTO g_oeb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

        #--判斷工單存在否
        #SELECT 'Y' INTO g_oeb[g_cnt].so
        #  FROM sfb_file
        # WHERE sfb22 = g_oeb[g_cnt].oeb01 AND sfb221=g_oeb[g_cnt].oeb03
        #   AND sfb87 != 'X'
        #IF cl_null(g_oeb[g_cnt].so) THEN LET g_oeb[g_cnt].so='N' END IF

        ##訂單結案
        SELECT '2' INTO g_oeb[g_cnt].oea49
           FROM oeb_file 
          WHERE oeb01 = g_oeb[g_cnt].oeb01 AND oeb03=g_oeb[g_cnt].oeb03
            AND oeb70 = 'Y'

        #留置  
        SELECT 'H' INTO g_oeb[g_cnt].oea49
          FROM  oea_file
          WHERE oea01 = g_oeb[g_cnt].oeb01
            AND oeahold IS NOT NULL

        ##潛在客戶
        IF cl_null(g_oeb[g_cnt].occ02) THEN
           SELECT ofd01||ofd02 INTO g_oeb[g_cnt].occ02
             FROM ofd_file,oea_file
            WHERE oea04=ofd01 AND oea01 =  g_oeb[g_cnt].oeb01
        END IF

        ##選配件
        SELECT 'Y' INTO g_oeb[g_cnt].oeo07
          FROM oeo_file
         WHERE oeo01 = g_oeb[g_cnt].oeb01 AND oeo03=g_oeb[g_cnt].oeb03
           AND rownum=1

        ##變更料號-訂單變更日
        SELECT MAX(oep04) INTO g_oeb[g_cnt].oep04
          FROM oep_file ,oeq_file
         WHERE oep01=oeq01
           AND oep02=oeq02
           AND oepconf='Y'
           AND oeq01 = g_oeb[g_cnt].oeb01 AND oeq03 = g_oeb[g_cnt].oeb03
           AND oeq04a LIKE '0%'
        GROUP BY oeq01,oeq03

        #--判斷使用包材 (S)
        
        IF g_oeb[g_cnt].oeb04[1,1]='0' THEN 
           # 代工為 JP002，型別符合 xxx22 或 行程 >1500
           IF g_oeb[g_cnt].ta_ima06='JP002' AND 
              (g_oeb[g_cnt].ima1007[4,5]='22' OR g_oeb[g_cnt].ta_ima04 >= 1500)
           THEN
              LET g_oeb[g_cnt].packing = '1.木箱'
           END IF


        #C-TYPE多軸
           IF cl_null(g_oeb[g_cnt].packing) THEN
              IF g_oeb[g_cnt].oea08='2' THEN                   #國外
                 SELECT '2.C-木箱' INTO g_oeb[g_cnt].packing 
                   FROM ima_file
                  WHERE ima01 = g_oeb[g_cnt].oeb04
                    AND (ima06 ='00200' OR ta_ima02 > 1)
                    AND ((ta_ima08 = 'N' AND ima021 LIKE '%-C')
                     OR (ta_ima08 = 'Y' AND ima021 LIKE '%-C%'))
              END IF
              IF g_oeb[g_cnt].oea08='1' THEN                   #國內
                 SELECT '2.C-木棧板' INTO g_oeb[g_cnt].packing
                   FROM ima_file
                  WHERE ima01 = g_oeb[g_cnt].oeb04
                    AND (ima06 ='00200' OR ta_ima02 > 1)
                    AND ((ta_ima08 = 'N' AND ima021 LIKE '%-C')
                     OR (ta_ima08 = 'Y' AND ima021 LIKE '%-C%'))
              END IF
           END IF

        #線馬
           IF cl_null(g_oeb[g_cnt].packing) THEN
              IF g_oeb[g_cnt].ima131='05' OR
                 (g_oeb[g_cnt].ima09 = '01012' OR g_oeb[g_cnt].ima09 ='01013')
              THEN
                 LET g_oeb[g_cnt].packing = '3.紙箱'
           END IF
           END IF

        #K-TYPE多軸
           IF cl_null(g_oeb[g_cnt].packing) THEN
              IF g_oeb[g_cnt].oea08='1' THEN                   #國內
                 SELECT '4.單軸' INTO g_oeb[g_cnt].packing
                   FROM ima_file
                  WHERE ima01 = g_oeb[g_cnt].oeb04
                    AND (ima06 ='00200' OR ta_ima02 > 1)
                    AND ((ta_ima08 = 'N' AND ima021 LIKE '%-K')
                     OR (ta_ima08 = 'Y' AND ima021 LIKE '%-K%'))
              END IF
           END IF

        #連結待確認
           IF cl_null(g_oeb[g_cnt].packing) AND  
              (g_oeb[g_cnt].ima06='00200' OR g_oeb[g_cnt].ta_ima02 > 1)
           THEN
              LET g_oeb[g_cnt].packing = '5.連結待確認'
           END IF

           IF cl_null(g_oeb[g_cnt].packing) THEN
              IF ((g_oeb[g_cnt].ima1007 = 'ETH22' OR
                  g_oeb[g_cnt].ima1007 = 'ECH22' OR
                  g_oeb[g_cnt].ima1007 = 'ETB22M' OR
                 #g_oeb[g_cnt].ima1007 = 'ECB22') AND g_oeb[g_cnt].ta_ima04 >= 1000) OR  #20200428 mark
                  g_oeb[g_cnt].ima1007 = 'ECB22' OR                                      #20200428 modify
                  g_oeb[g_cnt].ima1007 = 'ETH22M' OR                                     #20200428 add
                  g_oeb[g_cnt].ima1007 = 'ECH22M' )) OR                                  #20200428 add
                 ((g_oeb[g_cnt].ima1007 = 'ETH17M' OR
                   g_oeb[g_cnt].ima1007 = 'ECH17M2') AND g_oeb[g_cnt].ta_ima04 >= 1200) 
              THEN
                  LET g_oeb[g_cnt].packing = '7.紙箱'
              END IF

              IF ((g_oeb[g_cnt].ima1007 = 'MK85' OR g_oeb[g_cnt].ima1007 = 'MK110') AND 
                   g_oeb[g_cnt].ta_ima04 >= 1000) OR
                 ((g_oeb[g_cnt].ima1007[1,2] = 'MH' OR g_oeb[g_cnt].ima1007 = 'MK65') AND 
                   g_oeb[g_cnt].ta_ima04 >= 1500)
              THEN
                  LET g_oeb[g_cnt].packing = '6.紙箱(2支1箱)'
              END IF
           END IF

           IF cl_null(g_oeb[g_cnt].packing) THEN
              IF g_oeb[g_cnt].ta_ima04 >= 1500 THEN
                 LET g_oeb[g_cnt].packing = '8.紙箱'
              END IF  
           END IF
        END IF
        #--判斷使用包材 (E)

        IF g_oeb[g_cnt].oeb12 IS NULL THEN
  	       LET g_oeb[g_cnt].oeb12 = 0 
        END IF
      
        ##-- 20220627 add by momo (S) 更新狀態 
        IF g_action_choice="exportstatus" 
           AND cl_null(g_oeb[g_cnt].tc_oga07) AND cl_null(g_oeb[g_cnt].tc_ogauser) THEN

           LET g_oeb[g_cnt].tc_oga05=g_today
           LET g_oeb[g_cnt].tc_oga06=TIME

           INSERT INTO tc_oga_file(tc_oga00,tc_oga01,tc_oga02,tc_oga03,tc_oga04,tc_oga05,tc_oga06,tc_ogauser,tc_oga07)
                          VALUES('R',g_oeb[g_cnt].oeb01,
                                     g_oeb[g_cnt].oeb03,
                                     1,
                                     0,
                                     g_oeb[g_cnt].tc_oga05,
                                     g_oeb[g_cnt].tc_oga06,
                                     ' ','1')
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_oga_file",g_oeb[l_ac].oeb01,g_oeb[l_ac].oeb03,SQLCA.sqlcode,"","",1)
           END IF
           LET g_oeb[g_cnt].tc_oga07 = '1'
        END IF        
        ##-- 20220627 add by momo (E) 更新狀態 
        ##-- 20221122 add by momo (S) 訂單變更更新狀態
        IF g_action_choice="exportstatus" AND g_oeb[g_cnt].tc_oga07='3' THEN
           UPDATE tc_oga_file SET tc_oga07='1',tc_ogauser=' '
            WHERE tc_oga00 ='R'
              AND tc_oga01 = g_oeb[g_cnt].oeb01
              AND tc_oga02 = g_oeb[g_cnt].oeb03
        END IF
        ##-- 20221122 add by momo (E)

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oeb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
END FUNCTION
 
FUNCTION p411_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          
 
    IF p_ud <> "G" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()    

        ON ACTION BOM #BOM查詢
           LET g_msg = " abmi600 '", g_oeb[l_ac].oeb04,"'"
           CALL cl_cmdrun_wait(g_msg CLIPPED)     
 
        ON ACTION refresh_detail
           CALL p411_b_fill(g_wc2)
 
        ##---- 20220627 add by momo (S)
        ON ACTION exportstatus
           LET g_action_choice="exportstatus"
           EXIT DISPLAY
        ##---- 20220627 add by momo (E)         
 
        ON ACTION detail
           LET g_action_choice="detail"
           LET l_ac = 1 
           EXIT DISPLAY
 
        ON ACTION query       
           LET g_action_choice="query" 
           EXIT DISPLAY

        ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

        ON ACTION output
           LET g_action_choice = 'output'
           EXIT DISPLAY

        ON IDLE seconds
          CALL p411_b_fill(g_wc2)
          CONTINUE DISPLAY
 
        ON ACTION help
           LET g_action_choice="help"    
           EXIT DISPLAY
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
           EXIT DISPLAY
 
        ON ACTION exit
           LET g_action_choice="exit"    
           EXIT DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION controlg      
         CALL cl_cmdask()     
                                                  
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
         
       ON ACTION controls                            
         CALL cl_set_head_visible("","AUTO") 

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY         
 
     
      AFTER DISPLAY
         CONTINUE DISPLAY
    &include "qry_string.4gl" 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
    
END FUNCTION
 
 
FUNCTION p411_b()
    DEFINE lc_qbe_sn      LIKE gbm_file.gbm01  
    DEFINE l_ac,l_sl	   LIKE type_file.num5,      
           l_sn1,l_sn2     LIKE type_file.num5,      
           l_cnt           LIKE type_file.num5
 
    CALL cl_opmsg('b')
    CALL SET_COUNT(g_rec_b)   #告訴I.單身筆數
    INPUT ARRAY g_oeb WITHOUT DEFAULTS FROM s_oeb.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL p411_set_entry()
            CALL p411_set_no_entry()
            LET g_before_input_done = TRUE
        BEFORE ROW
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_sl = SCR_LINE()
             CALL cl_qbe_display_condition(lc_qbe_sn)

        AFTER FIELD choice
          IF cl_null(g_oeb[l_ac].bma05) OR g_oeb[l_ac].tc_oga07<>'1' THEN
             LET g_oeb[l_ac].choice = 'N'
             DISPLAY 'N' TO choice
          END IF   
         
 
        BEFORE FIELD tc_ogauser
           IF cl_null(g_oeb[l_ac].bma05) THEN            #未發放不可輸入工號
              CALL cl_err(g_oeb[l_ac].oeb04,'abm-096',0)
              RETURN
           END IF
      

        AFTER FIELD tc_ogauser
           IF NOT cl_null(g_oeb[l_ac].tc_ogauser) THEN
              SELECT COUNT(*) INTO l_cnt
                FROM gen_file
               WHERE gen01 = g_oeb[l_ac].tc_ogauser
                 AND genacti = 'Y'
              IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
              IF l_cnt = 0 THEN
                 NEXT FIELD tc_ogauser
              END IF
              DISPLAY BY NAME g_oeb[l_ac].tc_ogauser        
              IF cl_null(g_oeb[l_ac].tc_oga07) OR g_oeb[l_ac].tc_oga07='1' THEN
                 LET g_oeb[l_ac].tc_oga05=g_today
                 LET g_oeb[l_ac].tc_oga06=TIME
                 DISPLAY BY NAME g_oeb[l_ac].tc_oga05      
                 DISPLAY BY NAME g_oeb[l_ac].tc_oga06  
              END IF     
           END IF
           
        ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
         IF NOT cl_null(g_oeb[l_ac].tc_ogauser) THEN
            INSERT INTO tc_oga_file(tc_oga00,tc_oga01,tc_oga02,tc_oga03,tc_oga04,tc_oga05,tc_oga06,tc_ogauser,tc_oga07)
                          VALUES('R',g_oeb[l_ac].oeb01,
                                     g_oeb[l_ac].oeb03,
                                     1,
                                     0,
                                     g_oeb[l_ac].tc_oga05,
                                     g_oeb[l_ac].tc_oga06,
                                     g_oeb[l_ac].tc_ogauser,'2')
            IF SQLCA.sqlcode THEN
               UPDATE tc_oga_file SET tc_ogauser = g_oeb[l_ac].tc_ogauser,
                                      tc_oga05   = g_oeb[l_ac].tc_oga05,
                                      tc_oga06   = g_oeb[l_ac].tc_oga06,
                                      tc_oga07   = '2'
                      WHERE tc_oga01 = g_oeb[l_ac].oeb01 
                        AND tc_oga02 = g_oeb[l_ac].oeb03
                        AND tc_oga00='R'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","tc_oga_file",g_oeb[l_ac].oeb01,g_oeb[l_ac].oeb03,SQLCA.sqlcode,"","",1)
               END IF
            ELSE
               COMMIT WORK
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF 
         END IF

        AFTER ROW
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            EXIT INPUT
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
          
        ON ACTION CONTROLP
           CASE  
                WHEN INFIELD(oeb01) 
                      
                      # CALL q_oea(FALSE,TRUE,g_oeb[l_ac].oeb01,"","","","") RETURNING g_oeb[l_ac].oeb01
                      # DISPLAY BY NAME g_oeb[l_ac].oeb01
           END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION select_all
         CALL p411_sel_all("Y")

      ON ACTION select_non
         CALL p411_sel_all("N")

      ON ACTION batch_update
         CALL p411_batch_update()
         CALL p411_b_fill(g_wc2)
 
    END INPUT
END FUNCTION
 
FUNCTION p411_set_entry()

END FUNCTION
 
FUNCTION p411_set_no_entry()


END FUNCTION

FUNCTION p411_batch_update()
   DEFINE  l_i       LIKE type_file.num5
   DEFINE l_msg1    LIKE type_file.chr1000
  
   BEGIN WORK
     FOR l_i = 1 TO g_cnt
         ##---- 20220713 add by momo (S)
         IF cl_null(g_oeb[l_i].bma05) OR g_oeb[l_i].tc_oga07 <> '1' THEN
            LET  g_oeb[l_i].choice = 'N'
            CONTINUE FOR
         END IF
         ##---- 20220713 add by momo (E)
         IF g_oeb[l_i].choice = 'N' THEN
            CONTINUE FOR
         END IF
         LET g_oeb[l_i].tc_oga06=TIME
         UPDATE tc_oga_file SET tc_ogauser = g_user,
                                tc_oga05 = g_today,
                                tc_oga06 = g_oeb[l_i].tc_oga06,
                                tc_oga07 ='2'
         WHERE tc_oga01 = g_oeb[l_i].oeb01
           AND tc_oga02 = g_oeb[l_i].oeb03
           AND tc_oga00='R'
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('upd tc_oga_file',SQLCA.SQLCODE,1)
            EXIT FOR
            ROLLBACK WORK
         ELSE
            COMMIT WORK   
         END IF
     END FOR

END FUNCTION

FUNCTION p411_sel_all(p_value)
  DEFINE p_value      LIKE type_file.chr1
  DEFINE l_i          LIKE type_file.num10

  FOR l_i = 1 TO g_oeb.getLength()
     IF NOT cl_null(g_oeb[l_i].bma05) AND g_oeb[l_i].tc_oga07='1' THEN
        LET g_oeb[l_i].choice = p_value
     END IF
  END FOR

END FUNCTION
