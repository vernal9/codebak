/*
================================================================================
檔案代號:tc_evab_file
檔案名稱:固定資產評估單身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tc_evab_file
(
tc_evab01       varchar2(20) DEFAULT ' ' NOT NULL, /*固定資產評估單號*/
tc_evab02       number(5) NOT NULL,      /*項次                                   */
tc_evab03       varchar2(40),            /*料件編號                               */
tc_evab04       varchar2(24),            /*資產名稱                               */
tc_evab05       number(5),               /*數量                                   */
tc_evab06       number(20,6),            /*未稅單價                               */
tc_evabplant     varchar2(10) NOT NULL,   /*所屬營運中心                           */
tc_evablegal    varchar2(10) NOT NULL    /*所屬法人                               */
);

alter table tc_evab_file add  constraint tpk_tc_evab_pk primary key  (tc_evab01,tc_evab02) enable validate;
grant select on tc_evab_file to tiptopgp;
grant update on tc_evab_file to tiptopgp;
grant delete on tc_evab_file to tiptopgp;
grant insert on tc_evab_file to tiptopgp;
grant index on tc_evab_file to public;
grant select on tc_evab_file to ods;
