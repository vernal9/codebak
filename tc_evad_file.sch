/*
================================================================================
檔案代號:tc_evad_file
檔案名稱:模具基本資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table tc_evad_file
(
tc_evad01   varchar2(20) NOT NULL,   /*模具編號                               */
tc_evad02   date,                    /*開模日期                               */
tc_evad03   varchar2(10),            /*模具負責人員                           */
tc_evad04   varchar2(10),            /*負責部門                               */
tc_evad05   varchar2(1),             /*模具類別                               */
tc_evad06   varchar2(10),            /*開模廠商                               */
tc_evad07   number(5),               /*數量                                   */
tc_evad08   number(20,6),            /*模具重量                               */
tc_evad09   number(20,6),            /*模具壽命                               */
tc_evad10   number(5),               /*模具穴數                               */
tc_evad11   varchar2(20),            /*客供料號                               */
tc_evad12   varchar2(1) DEFAULT 'N' NOT NULL, /*轉量產否*/
tc_evad13   varchar2(1) DEFAULT '0' NOT NULL, /*簽核狀況*/
tc_evad14   varchar2(20),            /*財產編號                               */
tc_evaddate date,                    /*最近修改日                             */
tc_evadgrup varchar2(10),            /*資料所有部門                           */
tc_evadmodu varchar2(10),            /*資料修改者                             */
tc_evaduser varchar2(10),            /*資料所有者                             */
tc_evadacti varchar2(1) DEFAULT 'Y' NOT NULL, /*資料有效碼*/
tc_evadplant varchar2(10),           /*所屬營運中心                           */
tc_evadlegal varchar2(10),           /*所屬法人                               */
tc_evadoriu varchar2(10),            /*資料建立者                             */
tc_evadorig varchar2(10),            /*資料建立部門                           */
tc_evad15   varchar2(80)             /*備註說明                               */
);

alter table tc_evad_file add  constraint tpc_evad_pk primary key  (tc_evad01) enable validate;
grant select on tc_evad_file to tiptopgp;
grant update on tc_evad_file to tiptopgp;
grant delete on tc_evad_file to tiptopgp;
grant insert on tc_evad_file to tiptopgp;
grant index on tc_evad_file to public;
grant select on tc_evad_file to ods;
