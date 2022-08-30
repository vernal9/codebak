/*
================================================================================
檔案代號:tc_evaa_file
檔案名稱:固定資產評估單頭
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tc_evaa_file_file
(
tc_evaa01       varchar2(20) DEFAULT ' ' NOT NULL, /*固定資產評估單號*/
tc_evaa02       date,                              /*申請日期*/
tc_evaa03       varchar2(10) NOT NULL,             /*申請人員*/
tc_evaa04       varchar2(10) NOT NULL,             /*保管部門*/
tc_evaa05       varchar2(1) NOT NULL,              /*資產類別*/
tc_evaa06       varchar2(1),                       /*單據狀態*/
tc_evaa07       varchar2(1),                       /*申請類別*/
tc_evaa08       varchar2(1) DEFAULT '0' NOT NULL,  /*簽核狀況*/
tc_evaa09       varchar2(10),                      /*供應商*/
tc_evaa10       varchar2(10),                      /*幣別*/
tc_evaa11       number(20,6),                      /*預估本幣總額*/
tc_evaa12       varchar2(255) NOT NULL,            /*申請事由*/
tc_evaa13       varchar2(255) NOT NULL,            /*效益評估*/
tc_evaadate     date,                              /*最近修改日*/
tc_evaagrup     varchar2(10),                      /*資料所有部門*/
tc_evaamodu     varchar2(10),                      /*資料修改者*/
tc_evaauser     varchar2(10),                      /*資料所有者*/
tc_evaaacti     varchar2(1),                       /*資料有效碼*/
tc_evaaplant    varchar2(10) NOT NULL,             /*所屬營運中心*/
tc_evaalegal    varchar2(10) NOT NULL,             /*所屬法人 */
tc_evaaoriu     varchar2(10),                      /*資料建立者*/
tc_evaaorig     varchar2(10),                      /*資料建立部門*/
tc_evaamksg     varchar2(1) DEFAULT 'N' NOT NULL   /*是否簽核*/
);

alter table tc_evaa_file add  constraint tc_evaa_pk primary key  (tc_evaa01) enable validate;
grant select on tc_evaa_file to tiptopgp;
grant update on tc_evaa_file to tiptopgp;
grant delete on tc_evaa_file to tiptopgp;
grant insert on tc_evaa_file to tiptopgp;
grant index on tc_evaa_file to public;
grant select on tc_evaa_file to ods;
