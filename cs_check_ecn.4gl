#Prog. Version..: '5.30.24-17.04.13(00009)'     #
#
# Pattern name...: cs_check_ecn.4gl
# Descriptions...: abmi710/abmi720 CHECK
# Date & Author..: 2024/11/07 By momo

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"


FUNCTION cs_check_ecn(p_bmx01)
   DEFINE p_bmx01    LIKE bmx_file.bmx01
   DEFINE l_bmy05    LIKE bmy_file.bmy05
   DEFINE l_tc_bmd   RECORD LIKE tc_bmd_file.*
   DEFINE l_boa      RECORD LIKE boa_file.*

   #元件料號存在於型號取替代資料維護作業cbmi604
   DECLARE chk_bmy_cs CURSOR FOR
     SELECT distinct bmy05
       FROM bmy_file
      WHERE bmy01 = p_bmx01
        AND bmy03 IN ('1','4')

      CALL s_showmsg_init()
      FOREACH chk_bmy_cs INTO l_bmy05
         LET l_tc_bmd.tc_bmd01=''
         SELECT distinct tc_bmd01,tc_bmdnote          
           INTO l_tc_bmd.tc_bmd01,l_tc_bmd.tc_bmdnote
           FROM tc_bmd_file
          WHERE tc_bmd01 = l_bmy05
            AND tc_bmd06 IS NULL
            AND tc_bmd02 IN ('1','2','4')
         IF NOT cl_null(l_tc_bmd.tc_bmd01) THEN
            CALL s_errmsg('bmy05',l_tc_bmd.tc_bmd01,l_tc_bmd.tc_bmdnote,'cbm-019',1)
         END IF

      END FOREACH

    #群組取替
    DECLARE chk_boa_cs CURSOR FOR
     SELECT distinct boa01,boa03
       FROM boa_file,bmz_file,bmy_file
      WHERE bmz01 = p_bmx01 AND bmz01=bmy01
        AND boa01=bmz02 AND boa03=bmy05
        AND  (boa07 IS NULL OR boa07 > g_today)

    FOREACH chk_boa_cs INTO l_boa.boa01,l_boa.boa03
     IF NOT cl_null(l_boa.boa02) THEN
        CALL s_errmsg('bmy05',l_boa.boa01,l_boa.boa03,'cbm-003',1)
     END IF
    END FOREACH

      CALL s_errmsg('','','','afa-116',2)
      CALL s_showmsg()
END FUNCTION
