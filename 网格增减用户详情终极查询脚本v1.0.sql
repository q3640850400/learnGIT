/*****************************************************************************/
/*ʹ��˵����******************************************************************/
/*���޸�1�еĲ�ѯ��ʼʱ��****************************************************/
/*���޸�2�еĲ�ѯ����ʱ��****************************************************/
/*���޸�8�еı����е�ʱ��Ϊ����**********************************************/
/*���޸�9�еı����е�ʱ��Ϊ����**********************************************/
/*�ݵ�����ֿ�ʼ��ѯ�����̳��֡����������������*************************/
/*�޵�6��7��ֱ�Ϊ���ٺ����ӵ�����ͳ�ƣ���8��9�ֱ�Ϊ���ٺ���������***********/
/*��Ĭ��Ϊ��ѯ��ҵ����棬�����ѯ����Ʒ���棬���8��9���ڵĺ���ȥ��ע�ͷ�***/
/*****************************************************************************/
/*1.������ʼ��*/
drop table form1 purge;
CREATE TABLE form1 AS
SELECT t1.servid
FROM nods.to_sys_servst_dg_20160901 t1 /*��ʼʱ��*/----------------------/*��һ���ĵĵط�*/
WHERE t1.buststatus='2'
and t1.areaid=610;
/*2.����������*/
drop table form2 purge;
CREATE TABLE form2 AS
SELECT t2.servid
FROM nods.to_sys_servst_dg_20160926 t2 /*����ʱ��*/----------------------/*�ڶ����ĵĵط�*/
WHERE t2.buststatus='2'
and t2.areaid=610;
/*3.����form1��form2���е����ݱ������������û�ã�*/
drop table ZQ_form1_form2 purge; 
CREATE TABLE ZQ_form1_form2 AS
SELECT t1.servid
FROM form1 t1,form2 t2
where t1.servid = t2.servid;
/*4.����form1�У�form2û�еļ��ٱ�*/
drop table ZQ_form1_form2_minus purge;
CREATE TABLE ZQ_form1_form2_minus AS
SELECT t1.servid
FROM form1 t1
WHERE not exists 
(select 1 from form2 t2 where t1.servid=t2.servid);
/*5.����form1û�У�form2�е����ӱ�*/
drop table ZQ_form1_form2_plus purge;
CREATE TABLE ZQ_form1_form2_plus AS
SELECT t2.servid
FROM form2 t2
WHERE not exists (select 1 from form1 t1 where t1.servid=t2.servid);
/*6.����ͳ��*/
select count(*) from ZQ_form1_form2_minus;
/*7.����ͳ��*/
select count(*) from ZQ_form1_form2_plus;
/*8.���ٵ���*/
select * from /*ȥ���������ѯ����Ʒ����*/
(select ZQ_form1_form2_minus.Servid as servid0 from ZQ_form1_form2_minus) t1
left join
(select a.custid as �ͻ����,b.logicdevno as ���ܿ���,a.name as �ͻ�����,b.servid as ҵ����,b.permark as ҵ������,b.servstatus as ҵ��״̬,b.statusdate as ���ҵ�����ʱ��,/*c.pid as ��Ʒ���,d.pname as ��Ʒ����,c.pstatus as ��Ʒ״̬,c.stime as ��Ʒ��ʼʱ��,c.etime as ��Ʒ����ʱ��,*/b.whgridname as ����,a.mobile as �ֻ�,a.phone as �绰,a.linkaddr as ��ַ
from nods.TO_SYS_CUST_DG_20160926 a,nods.TO_SYS_SERVST_DG_20160926 b/*,nods.TO_BIZ_PRODUCT_DG_20160926 c,TO_PRD_PCODE_DG d*//*ע���޸ı���ʱ�䣬16��ı�ǰ��Ҫ��"nods."*/
                        /*��ʱ��*/------------------------------------/*�������ĵĵط�*/
where a.custid=b.custid
/*and b.servid=c.servid
and c.pid=d.pid*/) t2
on t1.servid0=t2.ҵ����;
/*9.���ӵ���*/
select * from /*ȥ���������ѯ����Ʒ����*/
(select ZQ_form1_form2_plus.Servid as servid0 from ZQ_form1_form2_plus) t1
left join
(select a.custid as �ͻ����,b.logicdevno as ���ܿ���,a.name as �ͻ�����,b.servid as ҵ����,b.permark as ҵ������,b.servstatus as ҵ��״̬,b.statusdate as ���ҵ�����ʱ��,/*c.pid as ��Ʒ���,d.pname as ��Ʒ����,c.pstatus as ��Ʒ״̬,c.stime as ��Ʒ��ʼʱ��,c.etime as ��Ʒ����ʱ��,*/b.whgridname as ����,a.mobile as �ֻ�,a.phone as �绰,a.linkaddr as ��ַ
from nods.TO_SYS_CUST_DG_20160926 a,nods.TO_SYS_SERVST_DG_20160926 b/*,nods.TO_BIZ_PRODUCT_DG_20160926 c,TO_PRD_PCODE_DG d*//*ע���޸ı���ʱ�䣬16��ı�ǰ��Ҫ��"nods."*/
                              /*��ʱ��*/------------------------------------/*���ĸ��ĵĵط���������*/
where a.custid=b.custid
/*and b.servid=c.servid
and c.pid=d.pid*/) t2
on t1.servid0=t2.ҵ����;