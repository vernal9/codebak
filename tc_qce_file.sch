/*
================================================================================
檔案代號:tc_qce_file
檔案名稱:細部不良原因代碼說明資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_qce_file
(
tc_qce01       varchar2(10) NOT NULL,   /*不良原因代碼                           */
tc_qce02       varchar2(1),                    /*No Use                                 */
tc_qce03       varchar2(80),                 /*說明內容                               */
tc_qce04       varchar2(10),                 /*上層不良原因                                 */
tc_qceacti      varchar2(1),                  /*資料有效碼                             */
tc_qceuser     varchar2(10),                 /*原始資料建立者                         */
tc_qcegrup    varchar2(10),                /*使用者部門                             */
tc_qcemodu   varchar2(10),             /*最後修改資料者                         */
tc_qcedate     date,                        /*最後修改日期                           */
tc_qceorig     varchar2(10),            /*資料建立部門                           */
tc_qceoriu     varchar2(10),            /*資料建立者                             */
);

alter table tc_qce_file add  constraint qce_pk primary key  (tc_qce01) enable validate;
grant select on tc_qce_file to tiptopgp;
grant update on tc_qce_file to tiptopgp;
grant delete on tc_qce_file to tiptopgp;
grant insert on tc_qce_file to tiptopgp;
grant index on tc_qce_file to public;
grant select on tc_qce_file to ods;
