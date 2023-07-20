# Prog.Version ..: '5.30.15-14.10.14(00000)'     #
#
# Program name...: cl_set_combo_items_gae.4gl
# Descriptions...: 動態設定ComboBox的Item.
# Date & Author..: 20220117 by momo
#                  串連欄位名稱/程式代號/欄位名稱

DATABASE ds       

GLOBALS "../../../tiptop/config/top.global"

FUNCTION cl_set_combo_items_plus(ps_field_name,p_tc_dic01,p_tc_dic02)
   DEFINE ps_field_name    STRING
   DEFINE p_tc_dic01      LIKE tc_dic_file.tc_dic01
   DEFINE p_tc_dic02      LIKE tc_dic_file.tc_dic02 
   DEFINE l_sql            STRING 
   DEFINE ps_values        LIKE ze_file.ze03
   DEFINE ps_items         LIKE ze_file.ze03

   WHENEVER ERROR CALL cl_err_msg_log

   LET l_sql = 
     #"SELECT to_char(wm_concat(tc_dic04)),to_char(wm_concat(tc_dic04||':'||tc_dic05)) ",
     # "SELECT to_char(wm_concat(tc_dic04)),to_char(wm_concat(tc_dic05)) ",
      "SELECT listagg(to_char((tc_dic04)),',') within group (order by tc_dic03) tc_dic04 ,",
      "       listagg(to_char((tc_dic05)),',') within group (order by tc_dic03) tc_dic05  ",
      "  FROM tc_dic_file ",
      " WHERE tc_dic01='",p_tc_dic01,"' ", 
      "   AND tc_dic02 = '",p_tc_dic02,"' ", 
      "   AND tc_dicacti = 'Y' ",
      " ORDER BY tc_dic03 "  
   PREPARE pre_001 FROM l_sql 
   EXECUTE pre_001 INTO ps_values,ps_items

   CALL cl_set_combo_items(ps_field_name, ps_values, ps_items)
END FUNCTION

