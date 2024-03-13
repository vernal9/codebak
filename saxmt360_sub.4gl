# Prog. Version..: '5.30.24-17.04.13(00002)'     #
#
# Program name...: saxmt360_sub.4gl
# Description....: 提供saxmt360.4gl使用的sub routine
# Date & Author..: 14/03/19 By Rayhu (FUN-D80128)
# Modify.........: No.FUN-D80128 14/03/19 By Rayhu 將確認段移到saxmt360_sub.4gl
# Modify.........: No.MOD-EB0141 14/11/28 By Hungli 將g_cnt接值改為l_cnt，避免EasyFlow簽核要回寫時出錯。
# Modify.........: No.24030004   20240312 By momo 增加SKFamily 中介檔處理

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../4gl/saxmt360.global"

DEFINE   g_oqt            RECORD LIKE oqt_file.*
DEFINE   g_oah08          LIKE oah_file.oah08

FUNCTION t360sub_y_chk(p_oqt01,p_action_choice)
   DEFINE p_oqt01            LIKE oqt_file.oqt01
   DEFINE p_action_choice    STRING
   DEFINE l_cnt              LIKE type_file.num5          #SMALLINT
   DEFINE l_gemacti          LIKE gem_file.gemacti        

   LET g_success = 'Y'
   LET g_action_choice = p_action_choice

   IF cl_null(p_oqt01) THEN
      LET g_success = 'N'
      RETURN
   END IF
  
   SELECT * INTO g_oqt.* 
     FROM oqt_file 
    WHERE oqt01 = p_oqt01
  
   IF NOT cl_null(g_oqt.oqt06) THEN
      SELECT gemacti INTO l_gemacti FROM gem_file
       WHERE gem01 = g_oqt.oqt06
      IF l_gemacti = 'N' THEN
         CALL cl_err(g_oqt.oqt06,'asf-472',0)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
  
   IF g_oqt.oqtconf = 'Y' THEN
      CALL cl_err('',9023,0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_oqt.oqtconf = 'X' THEN
      CALL cl_err(g_oqt.oqt01,'9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_oqt.oqtacti='N' THEN
      CALL cl_err('','mfg0301',1)
      LET g_success = 'N'
      RETURN
   END IF

   IF g_action_choice CLIPPED = "confirm" OR   #按「確認」or 「新增」時
      g_action_choice CLIPPED = "insert"       
   THEN
      IF NOT cl_confirm('axm-108') THEN  LET g_success = 'N' RETURN END IF
   END IF
  
  #無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM oqu_file
    WHERE oqu01 = g_oqt.oqt01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      LET g_success = 'N' 
      RETURN
   END IF
  
   SELECT oah08 INTO g_oah08 
     FROM oah_file 
    WHERE oah01 = g_oqt.oqt10
   IF cl_null(g_oah08) THEN
      LET g_oah08 = 'Y'
   END IF
   IF g_oah08='N' THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt 
        FROM oqu_file
       WHERE oqu01=g_oqt.oqt01 
         AND oqu07 = 0
      IF l_cnt > 0 THEN
         CALL cl_err('','axm-627',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
END FUNCTION

FUNCTION t360sub_y_upd(p_oqt01,p_action_choice)
   DEFINE p_oqt01            LIKE oqt_file.oqt01
   DEFINE p_action_choice    STRING
   DEFINE l_cnt              LIKE type_file.num5          #SMALLINT

   WHENEVER ERROR CONTINUE

   LET g_success = 'Y'
   LET g_action_choice = p_action_choice

   IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
      g_action_choice CLIPPED = "insert"       #FUN-640248
   THEN
      IF g_oqt.oqt22='Y'   THEN
          IF g_oqt.oqt21 != '1' THEN
             CALL cl_err('','aws-078',1)
             LET g_success = 'N'
             RETURN
          END IF
      END IF
   END IF
  
   BEGIN WORK
   LET g_forupd_sql = "SELECT * FROM oqt_file WHERE oqt01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t360sub_cl CURSOR FROM g_forupd_sql
   OPEN t360sub_cl USING g_oqt.oqt01
   IF STATUS THEN
      CALL cl_err("OPEN t360sub_cl:", STATUS, 1)
      CLOSE t360sub_cl
      LET g_success='N'
      ROLLBACK WORK
      RETURN
   END IF
  
   FETCH t360sub_cl INTO g_oqt.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oqt.oqt01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t360sub_cl 
      LET g_success='N'
      ROLLBACK WORK 
      RETURN
   END IF
  
   LET g_success = 'Y'
  
   UPDATE oqt_file 
      SET oqtconf = 'Y'
    WHERE oqt01 = g_oqt.oqt01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
      ROLLBACK WORK
      RETURN
   END IF
  
   IF g_oqt.oqt22 = 'N' AND g_oqt.oqt21 = '0' THEN
      LET g_oqt.oqt21 = '1'
      UPDATE oqt_file 
         SET oqt21 = g_oqt.oqt21 
       WHERE oqt01 = g_oqt.oqt01
      IF SQLCA.sqlerrd[3] = 0 THEN
         LET g_success = 'N'
      END IF
   END IF
  
   IF g_oqt.oqt22 = 'Y' THEN #簽核模式
      CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
          WHEN 0  #呼叫 EasyFlow 簽核失敗
               LET g_oqt.oqtconf = "N"
               LET g_success = "N"
               ROLLBACK WORK
               RETURN
          WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
               LET g_oqt.oqtconf = "N"
               ROLLBACK WORK
               RETURN
      END CASE
   END IF

   SELECT COUNT(*) INTO l_cnt 
     FROM oqu_file
    WHERE oqu01 = g_oqt.oqt01
  #IF g_cnt = 0 AND g_oqt.oqt22 = 'Y' THEN #MOD-EB0141 mark
   IF l_cnt = 0 AND g_oqt.oqt22 = 'Y' THEN #MOD-EB0141 add 
      CALL cl_err(' ','aws-065',0)
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN
   END IF

   IF g_success = 'Y' THEN
      LET g_oqt.oqt21='1'             #執行成功, 狀態值顯示為 '1' 已核准  
      UPDATE oqt_file 
         SET oqt21 = g_oqt.oqt21 
       WHERE oqt01 = g_oqt.oqt01
      IF SQLCA.sqlerrd[3]=0 THEN
         LET g_success='N'
      END IF

      LET g_oqt.oqtconf='Y'           #執行成功, 確認碼顯示為 'Y' 已確認
      DISPLAY BY NAME g_oqt.oqtconf
      DISPLAY BY NAME g_oqt.oqt21
      COMMIT WORK
      CALL cl_flow_notify(g_oqt.oqt01,'Y')
      CALL cs_axmmid(g_oqt.oqt01,"axmt360")     #20240312 中介檔
     #CALL s_pmista('oqt',g_oqt.oqt21,g_oqt.oqtconf,g_oqt.oqt22) 
     #   RETURNING g_sta  
     #DISPLAY g_sta TO FORMONLY.desc2
   ELSE
      LET g_oqt.oqtconf='N'
      ROLLBACK WORK
   END IF
   IF g_oqt.oqtconf='X' THEN 
      LET g_chr='Y' 
   ELSE 
      LET g_chr='N' 
   END IF
   IF g_oqt.oqt21='1' THEN 
      LET g_chr2='Y' 
   ELSE 
      LET g_chr2='N' 
   END IF
   CALL cl_set_field_pic(g_oqt.oqtconf,g_chr2,"","",g_chr,"")

END FUNCTION
#FUN-D80128
