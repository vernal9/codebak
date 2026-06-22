# Prog. Version..: '5.30.24-17.04.13(00003)'     #
#
# Program name...: cs_gen_tcbmd.4gl
# Descriptions...: cbmi606 特殊取替代工單替換邏輯
# Date & Author..: 20260515 By momo
# Usage..........: CALL cs_gen_tc_bmd(工單)
# 

DATABASE ds

GLOBALS "../../../tiptop/config/top.global" 

FUNCTION cs_gen_tc_bmd(p_sfb01)
   DEFINE p_sfb01    LIKE sfb_file.sfb01
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_sfa03    LIKE sfa_file.sfa03
   DEFINE l_sfa26    LIKE sfa_file.sfa26
   DEFINE l_sfa27    LIKE sfa_file.sfa27
   DEFINE l_ta_sfb01 LIKE sfb_file.ta_sfb01
   DEFINE l_sfb08    LIKE sfb_file.sfb08
   DEFINE l_tc_bmd   RECORD LIKE tc_bmd_file.*
   DEFINE l_sfa      RECORD LIKE sfa_file.*
   DEFINE l_oea      RECORD LIKE oea_file.*
   DEFINE l_msg      LIKE tc_bmd_file.tc_bmdnote               

   CALL s_showmsg_init()
   DECLARE i301sub_tc_bmd_chk CURSOR FOR 
      SELECT DISTINCT sfa03,oea03,oea04,oea08,tc_bmd02,sfa26,sfb08,sfa27
         FROM sfa_file
         LEFT JOIN tc_bmd_file ON ((sfa03=tc_bmd01 AND tc_bmd02 <> '9') OR (sfa03=tc_bmd04 AND sfa27=tc_bmd01 AND tc_bmd02='9'))
         LEFT JOIN sfb_file ON sfb01=sfa01
         LEFT JOIN oea_file ON oea01=SUBSTR(ta_sfb01,1,15)
         WHERE sfa01=sfb01 AND sfa01 = p_sfb01
           AND tc_bmd06 IS NULL
           AND tc_bmd02 IN ('3','9','S')
           AND sfa05 > 0 
               
    FOREACH i301sub_tc_bmd_chk INTO l_sfa03,l_oea.oea03,l_oea.oea04,l_oea.oea08,l_tc_bmd.tc_bmd02,l_sfa26,l_sfb08,l_sfa27
      LET l_tc_bmd.tc_bmd04=' '
      LET l_cnt = 0

      CASE
      ##--- S，外銷，備料無指定分群，更換包材
      WHEN l_tc_bmd.tc_bmd02='S' AND l_oea.oea08='2'
        #---- 檢核是否設定客戶不可用 9
        SELECT 1 INTO l_cnt FROM tc_bmd_file
         WHERE (tc_bmd08 = l_oea.oea03 OR tc_bmd08=l_oea.oea04)
           AND tc_bmd01 =  l_sfa27 
           AND tc_bmd02 = '9'
           AND tc_bmd06 IS NULL
        IF l_cnt = 1 THEN
           CONTINUE FOREACH
        END IF 
        SELECT tc_bmd04 INTO l_tc_bmd.tc_bmd04
          FROM tc_bmd_file
         WHERE tc_bmd01 = l_sfa03 AND tc_bmd02='S'
           AND tc_bmd06 IS NULL
           AND NOT EXISTS (SELECT 1 FROM sfa_file,ima_file
                            WHERE sfa03=ima01 AND ima06 IN ('22049','22039') AND sfa01= p_sfb01)
        IF cl_null(l_tc_bmd.tc_bmd04) THEN
           CONTINUE FOREACH
        END IF
        LET g_showmsg = l_sfa03,"->",l_tc_bmd.tc_bmd04
        CALL s_errmsg('sfa03',l_sfa03,g_showmsg,'csf-026',1)
      #---- 取客戶直接 3
      WHEN l_tc_bmd.tc_bmd02='3' 
        SELECT tc_bmd04 INTO l_tc_bmd.tc_bmd04 FROM tc_bmd_file
         WHERE (tc_bmd08 = l_oea.oea03 OR tc_bmd08 = l_oea.oea04)
           AND tc_bmd01 = l_sfa03
           AND tc_bmd02 = '3'
           AND tc_bmd06 IS NULL
        LET g_showmsg = l_sfa03," -> ",l_tc_bmd.tc_bmd04
        CALL s_errmsg('sfa03',l_sfa03,g_showmsg,'csf-025',1)
      #---- 客戶不可換
      WHEN l_tc_bmd.tc_bmd02='9'
        SELECT 1 INTO l_cnt FROM tc_bmd_file
         WHERE tc_bmd01 = l_sfa27 
           AND tc_bmd04 = l_sfa03
           AND tc_bmd02 = '9'
           AND tc_bmd06 IS NULL
        IF l_cnt = 1 THEN
           LET g_showmsg = l_sfa27," -> ",l_sfa03 
           CALL s_errmsg('sfa03',l_sfa03,g_showmsg,'cbm-012',1)
           LET g_success='N'
        END IF
        EXIT FOREACH
      OTHERWISE CONTINUE FOREACH
      END CASE 
      #----更換
      LET l_msg=''
      IF NOT cl_null(l_tc_bmd.tc_bmd04) THEN
         IF (l_sfa26 = '1' OR l_sfa26 = '2') THEN
            IF cl_confirm("csf-024") THEN
               LET g_success='N'
               RETURN
            END IF
         END IF
         LET l_msg = "sfa26:",l_sfa26,",",l_sfa03,"-->",l_tc_bmd.tc_bmd04,",",l_tc_bmd.tc_bmd02
         UPDATE sfa_file SET sfa03 = l_tc_bmd.tc_bmd04,
                             sfa26 = '0',
                             sfa161= sfa05/l_sfb08,
                             sfa27 = l_tc_bmd.tc_bmd04,
                             sfaud01 = l_msg
             WHERE sfa01 = p_sfb01 AND sfa03 = l_sfa03
         IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
            CALL s_errmsg("upd faild",l_tc_bmd.tc_bmd04,g_showmsg,"upd sfa03",1) 
            LET g_success='N'
            RETURN
         ELSE
           CASE
           WHEN l_sfa26='S'
               LET l_msg = l_sfa27,": sfa26 4 --> 2 "
               UPDATE sfa_file SET sfa26 = '2',sfaud01 = l_msg
                WHERE sfa01 = p_sfb01 AND sfa26 = '4' AND sfa27 = l_sfa27
           WHEN l_sfa26='U'
               LET l_msg = l_sfa27,": sfa26 3 --> 1 "
               UPDATE sfa_file SET sfa26 = '1',sfaud01 = l_msg
                WHERE sfa01 = p_sfb01 AND sfa26 = '3' AND sfa27 = l_sfa27
           END CASE
         END IF
      END IF
    END FOREACH
    CALL s_showmsg()
    COMMIT WORK
END FUNCTION

