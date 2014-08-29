--
-- created by liuguangzhao@comsenz.com 2008/03/12
--
-- RUN: /serv/pgsql/bin/psql -h 60.2.222.59 -U webstat  postgres<./cacl.sql


--创建临时数据库
\timing
drop database if exists cross_stat;
create database cross_stat;
\c cross_stat

drop table  if exists sp_stat_1 ;
Create table sp_stat_1(
id serial not null,
uuid char(20) not null ,
sid  integer not null,
count integer not null default 1
);
\echo "INFO: copy data from file";
copy sp_stat_1 (uuid,sid,count) from '/home/webstat/temp/r.txt' DELIMITER  ',';

drop table  if exists sp_stat_dict;
Create table sp_stat_dict(
id serial not null,
uuid char(20) not null
);
create index idx_ssd_uuid on sp_stat_dict (uuid);
insert into sp_stat_dict(uuid) select distinct(uuid) from sp_stat_1;

drop table  if exists sp_stat_2;
Create table sp_stat_2(
id serial not null,
uuid integer not null ,
sid  integer not null,
count integer not null default 1
);
insert into sp_stat_2 (uuid,sid,count) select t2.id,t1.sid,t1.count from sp_stat_1 t1,sp_stat_dict t2 where t1.uuid=t2.uuid;

drop table  if exists sp_stat_3;
create table sp_stat_3(
id serial not null,
uuid integer not null ,
sid1  integer not null,
sid2  integer not null,
count1 integer not null default 1,
count2 integer not null default 1
);
-- 执行第一次组合操作：一个用户访问的不同站点间的组合。
-- 一条记录的意义是：用户uuid访问的两个站点sid1,sid2的访问次数是count1,count2
insert into sp_stat_3 (uuid,sid1,sid2,count1,count2) select t1.uuid,t1.sid as sid1,t2.sid as sid2,t1.count as count1,t2.count as count2 from sp_stat_2 t1,sp_stat_2 t2 where t1.uuid=t2.uuid and t1.id!=t2.id and t1.sid>t2.sid ;


drop table  if exists sp_stat_4;
create table sp_stat_4(
id serial not null,
sid1  integer not null,
sid2  integer not null,
cb_sid varchar(20) not null ,
ch_cnt integer not null,
uuid1 integer not null ,
uuid2 integer not null 
);
create index idx_ss4 on sp_stat_4 (cb_sid);
-- 执行第二次组合：不同用户访问的站点组合的组合。
insert into sp_stat_4 (sid1,sid2,cb_sid,ch_cnt,uuid1,uuid2) select t1.sid1,t1.sid2,t1.sid1::varchar||','||t1.sid2::varchar , LEAST(t1.count1,t1.count2,t2.count1,t2.count2) as sh_cnt , t1.uuid, t2.uuid from sp_stat_3 t1,sp_stat_3 t2 where t1.id!=t2.id and t1.uuid>t2.uuid  and t1.sid1=t2.sid1 and t1.sid2=t2.sid2 ;

-- select cb_sid,sum(ch_cnt) as sum_cnt from sp_stat_4 where uuid1>uuid2 group by cb_sid order by sum_cnt desc limit 1000;
select cb_sid,round(sum(ch_cnt)*100.0/(select sum(ch_cnt) from sp_stat_4),4)::varchar||'%',sum(ch_cnt) as sum_cnt from sp_stat_4 where uuid1>uuid2 group by cb_sid order by sum_cnt desc limit 1000;

\timing;
select 'sites' as holder,'sum_rate: '||round((select sum(ch_rate) as sum_rate from (select sum(ch_cnt)*100.0/(select sum(ch_cnt) from sp_stat_4) as ch_rate from sp_stat_4 where uuid1>uuid2 group by cb_sid order by sum(ch_cnt) desc limit 1000) tt),4)::varchar as sum_rate , 'rec: '||sum(ch_cnt)::varchar as sum_cnt, (select 'rows: '||count(id)::varchar as rows from sp_stat_4) as row_cnt from  sp_stat_4;
