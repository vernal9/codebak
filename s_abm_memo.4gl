# Prog. Version..: '5.30.24-17.04.13(00003)'     #
#
# Program name...: s_abm_memo.4gl
# Descriptions...: 
# Date & Author..: 
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: NO.FUN-670091 06/08/01 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.1910233808 20191024 By momo 新增ECN固定提問備註
# Modify.........: NO.24010010   20240116 By momo 依動態設定產生
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"   #FUN-7C0053
 
DEFINE g_chr		LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
 
FUNCTION s_abm_memo(p_no,p_cmd)
   DEFINE p_no		LIKE bmg_file.bmg01 	#No.FUN-680147 VARCHAR(20)
   DEFINE p_cmd		LIKE type_file.chr1     # u:update d:display only #No.FUN-680147 VARCHAR(1)
   DEFINE i,j,s		LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE g_bmg         RECORD LIKE bmg_file.*  #20240116
   DEFINE l_bmg     DYNAMIC ARRAY OF RECORD
                        ta_bmg01        LIKE bmg_file.ta_bmg01,  #20240116
                        bmg02           LIKE bmg_file.bmg02,     #20240116
                	bmg03		LIKE bmg_file.bmg03
                    END RECORD
   DEFINE p_row,p_col     LIKE type_file.num5   #No.FUN-680147 SMALLINT
   DEFINE l_cmd        LIKE type_file.chr1000
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF p_no IS NULL THEN RETURN END IF
 
   LET p_row = 5 LET p_col = 5
   #OPEN WINDOW s_abm_memo_w AT p_row,p_col WITH FORM "sub/42f/s_abm_memo"   #20240116
   #OPEN WINDOW s_abm_memo_w AT p_row,p_col WITH FORM "cbm/42f/abmi701"      #20240116 
   #    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN           #20240116 
    
   #CALL cl_ui_locale("s_abm_memo")                                          #20240116

   ##---- 20191024 add by momo (S) 新增固定備註詢問
   IF p_cmd = 'a' THEN
      ##---- 取動態
      DECLARE bmg_memo CURSOR FOR
        SELECT tc_dic04,tc_dic04 FROM tc_dic_file WHERE tc_dic01='abmi701' AND tc_dicacti='Y'
        FOREACH bmg_memo INTO g_bmg.ta_bmg01,g_bmg.bmg02
      ##------ 20240116 mark (S)
      #FOR i = 1 TO 3
      # IF i = 1 THEN
      #    PROMPT "庫存處理方式：" FOR l_bmg[i].bmg03
      #    LET l_bmg[i].bmg03 = '庫存處理方式：',l_bmg[i].bmg03
      #    DISPLAY BY NAME l_bmg[i].bmg03
      #END IF

      # IF i = 2 THEN
      #    PROMPT "代用量是否建立：" FOR l_bmg[i].bmg03
      #    LET l_bmg[i].bmg03 = '代用量是否建立：',l_bmg[i].bmg03
      # END IF

      # IF i = 3 THEN
      #    PROMPT "EXCEL修改否：" FOR l_bmg[i].bmg03
      #    LET l_bmg[i].bmg03 = 'EXCEL修改否：',l_bmg[i].bmg03
      # END IF
      ##------ 20240116 mark (E)

       INSERT INTO bmg_file (ta_bmg01,bmg01,bmg02,bmg03,bmgplant,bmglegal) #FUN-980012 add bmgplant,bmglegal
                     VALUES(g_bmg.ta_bmg01,p_no,g_bmg.bmg02,g_bmg.bmg03,g_plant,g_legal) #FUN-980012 add g_plant,g_legal
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","bmg_file",p_no,g_bmg.bmg03,SQLCA.sqlcode,"","",0) #FUN-670091
          LET g_success = 'N' EXIT FOREACH
       END IF
       IF g_success != 'N'
        THEN COMMIT WORK
        ELSE ROLLBACK WORK
    END IF
      END FOREACH #20240116
   END IF
   ##------ 20240116 mark (S)
   ##---- 20191024 add by momo (E)
   { 
   DECLARE s_abm_memo_c CURSOR FOR
          #SELECT bmg03,bmg02 FROM bmg_file            #20240116
           SELECT ta_bmg01,bmg02,bmg03 FROM bmg_file   #20240116
             WHERE bmg01 = p_no
             ORDER BY bmg02
 
   FOR i = 1 TO l_bmg.getLength() INITIALIZE l_bmg[i].* TO NULL END FOR
   LET i = 1

   #FOREACH s_abm_memo_c INTO l_bmg[i].bmg03,j         #20240116
   FOREACH s_abm_memo_c INTO l_bmg[i].*                #20240116
      IF STATUS THEN CALL cl_err('foreach bmg',STATUS,0) EXIT FOREACH END IF 
      LET i = i + 1
      IF i > g_max_rec THEN            #No.TQC-630109
         CALL cl_err( '', 9035, 0 )    #No.TQC-630109
         EXIT FOREACH
      END IF
   END FOREACH
   CALL SET_COUNT(i-1)
   IF p_cmd = 'd' THEN
      CALL cl_set_act_visible("accept,cancel", FALSE)
      DISPLAY ARRAY l_bmg TO s_bmg.*
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY

      END DISPLAY
      CLOSE WINDOW s_abm_memo_w
      RETURN
   END IF
   INPUT ARRAY l_bmg WITHOUT DEFAULTS FROM s_bmg.*  ATTRIBUTE(MAXCOUNT=g_max_rec)   #No.TQC-630109

   CLOSE WINDOW s_abm_memo_w
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   LET g_success ='Y' 
   BEGIN WORK
   DELETE FROM bmg_file WHERE bmg01 = p_no
   FOR i = 1 TO l_bmg.getLength()
       IF cl_null(l_bmg[i].bmg03) THEN CONTINUE FOR END IF
       INSERT INTO bmg_file (ta_bmg01,bmg01,bmg02,bmg03,bmgplant,bmglegal) #FUN-980012 add bmgplant,bmglegal #20240116
                     VALUES(l_bmg[i].ta_bmg01,p_no,l_bmg[i].bmg02,l_bmg[i].bmg03,g_plant,g_legal) #FUN-980012 add g_plant,g_legal #20240116
       IF SQLCA.sqlcode THEN
          #CALL cl_err('INS-bmg',SQLCA.sqlcode,0)  #FUN-670091
          CALL cl_err3("ins","bmg_file",p_no,l_bmg[i].bmg03,SQLCA.sqlcode,"","",0) #FUN-670091
          LET g_success = 'N' EXIT FOR
       END IF
    END FOR
    IF g_success='Y'
        THEN COMMIT WORK
        ELSE ROLLBACK WORK
    END IF
   }
   ##------ 20240116 mark (E)
   LET l_cmd='abmi701 "',p_no,'" '
                     CALL cl_cmdrun_wait(l_cmd)
END FUNCTION
