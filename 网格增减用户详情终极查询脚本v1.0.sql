/*****************************************************************************/
/*使用说明：******************************************************************/
/*①修改1中的查询开始时间****************************************************/
/*②修改2中的查询结束时间****************************************************/
/*③修改8中的表名中的时间为昨天**********************************************/
/*④修改9中的表名中的时间为昨天**********************************************/
/*⑤点击齿轮开始查询，过程出现“丢弃表报错”不用理会*************************/
/*⑥第6、7项分别为减少和增加的数量统计，第8、9分别为减少和增加详情***********/
/*⑦默认为查询到业务层面，如需查询到产品层面，请把8、9项内的红字去掉注释符***/
/*****************************************************************************/
/*1.创建起始表*/
drop table form1 purge;
CREATE TABLE form1 AS
SELECT t1.servid
FROM nods.to_sys_servst_dg_20160901 t1 /*起始时间*/----------------------/*第一个改的地方*/
WHERE t1.buststatus='2'
and t1.areaid=610;
/*2.创建结束表*/
drop table form2 purge;
CREATE TABLE form2 AS
SELECT t2.servid
FROM nods.to_sys_servst_dg_20160926 t2 /*结束时间*/----------------------/*第二个改的地方*/
WHERE t2.buststatus='2'
and t2.areaid=610;
/*3.创建form1和form2都有的数据表（后来发现这个没用）*/
drop table ZQ_form1_form2 purge; 
CREATE TABLE ZQ_form1_form2 AS
SELECT t1.servid
FROM form1 t1,form2 t2
where t1.servid = t2.servid;
/*4.创建form1有，form2没有的减少表*/
drop table ZQ_form1_form2_minus purge;
CREATE TABLE ZQ_form1_form2_minus AS
SELECT t1.servid
FROM form1 t1
WHERE not exists 
(select 1 from form2 t2 where t1.servid=t2.servid);
/*5.创建form1没有，form2有的增加表*/
drop table ZQ_form1_form2_plus purge;
CREATE TABLE ZQ_form1_form2_plus AS
SELECT t2.servid
FROM form2 t2
WHERE not exists (select 1 from form1 t1 where t1.servid=t2.servid);
/*6.减少统计*/
select count(*) from ZQ_form1_form2_minus;
/*7.增加统计*/
select count(*) from ZQ_form1_form2_plus;
/*8.减少导出*/
select * from /*去掉红字则查询到产品层面*/
(select ZQ_form1_form2_minus.Servid as servid0 from ZQ_form1_form2_minus) t1
left join
(select a.custid as 客户编号,b.logicdevno as 智能卡号,a.name as 客户姓名,b.servid as 业务编号,b.permark as 业务类型,b.servstatus as 业务状态,b.statusdate as 最后业务办理时间,/*c.pid as 产品编号,d.pname as 产品名称,c.pstatus as 产品状态,c.stime as 产品开始时间,c.etime as 产品结束时间,*/b.whgridname as 网格,a.mobile as 手机,a.phone as 电话,a.linkaddr as 地址
from nods.TO_SYS_CUST_DG_20160926 a,nods.TO_SYS_SERVST_DG_20160926 b/*,nods.TO_BIZ_PRODUCT_DG_20160926 c,TO_PRD_PCODE_DG d*//*注意修改表名时间，16年的表前面要加"nods."*/
                        /*表时间*/------------------------------------/*第三个改的地方*/
where a.custid=b.custid
/*and b.servid=c.servid
and c.pid=d.pid*/) t2
on t1.servid0=t2.业务编号;
/*9.增加导出*/
select * from /*去掉红字则查询到产品层面*/
(select ZQ_form1_form2_plus.Servid as servid0 from ZQ_form1_form2_plus) t1
left join
(select a.custid as 客户编号,b.logicdevno as 智能卡号,a.name as 客户姓名,b.servid as 业务编号,b.permark as 业务类型,b.servstatus as 业务状态,b.statusdate as 最后业务办理时间,/*c.pid as 产品编号,d.pname as 产品名称,c.pstatus as 产品状态,c.stime as 产品开始时间,c.etime as 产品结束时间,*/b.whgridname as 网格,a.mobile as 手机,a.phone as 电话,a.linkaddr as 地址
from nods.TO_SYS_CUST_DG_20160926 a,nods.TO_SYS_SERVST_DG_20160926 b/*,nods.TO_BIZ_PRODUCT_DG_20160926 c,TO_PRD_PCODE_DG d*//*注意修改表名时间，16年的表前面要加"nods."*/
                              /*表时间*/------------------------------------/*第四个改的地方，改完了*/
where a.custid=b.custid
/*and b.servid=c.servid
and c.pid=d.pid*/) t2
on t1.servid0=t2.业务编号;