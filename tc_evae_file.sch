/*
================================================================================
檔案代號:tc_evae_file
檔案名稱:模具零件資料表
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table tc_evae_file
(
tc_evae01   varchar2(20) NOT NULL,   /*模具編號                               */
tc_evae02   number(5) DEFAULT '0' NOT NULL, /*版次*/
tc_evae03   varchar2(30) NOT NULL,   /*零件料號                               */
tc_evae04   varchar2(40),            /*零件材質                               */
tc_evae05   varchar2(20),            /*採購單號                               */
tc_evae06   number(5),               /*採購項次                               */
tc_evaeplant varchar2(10),           /*所屬營運中心                           */
tc_evaelegal varchar2(10)            /*所屬法人                               */
);

create unique index tic_tc_evae_01 on tc_evae_file (tc_evae01,tc_evae02,tc_evae03);
alter table tc_evae_file add  constraint tpc_evae_pk primary key  (tc_evae01,tc_evae02,tc_evae03) enable validate;
grant select on tc_evae_file to tiptopgp;
grant update on tc_evae_file to tiptopgp;
grant delete on tc_evae_file to tiptopgp;
grant insert on tc_evae_file to tiptopgp;
grant index on tc_evae_file to public;
grant select on tc_evae_file to ods;
