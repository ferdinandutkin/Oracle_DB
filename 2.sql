create tablespace ts_0
    datafile 'ts0.dbf'
    size 7 m
    autoextend on next 5 m
    maxsize 20 m
    extent management local;
   

create temporary tablespace ts_0_temp
    tempfile 'ts0_temp.dbf'
    size 7 m
    autoextend on next 5 m
    maxsize 20 m
    extent management local;
    
    
select tablespace_name, contents logging from sys.dba_tablespaces;

alter session set "_ORACLE_SCRIPT"=true;--чинит ORA-65096 при создании юзеров/ролей/etc с нестандартными именами
create role rl_tscore;
grant connect,
    create table,
    drop any table,
    create view,
    drop any view,
    create procedure, 
    drop any procedure
    to rl_tscore;
    
    
commit;


select * from sys.dba_roles;
select * from sys.dba_roles where role like 'rl%';


create profile pf_tscore limit
    password_life_time 180
    sessions_per_user 3
    failed_login_attempts 7
    password_lock_time 1
    password_reuse_time 10
    password_grace_time default 
    connect_time 180
    idle_time 30;
commit;



select * from sys.dba_profiles where profile like 'PF%';
select * from sys.dba_profiles where profile = 'DEFAULT';


create user tscore 
    identified by pword
    default tablespace ts_0
    quota unlimited on ts_0
    temporary tablespace ts_0_temp
    profile pf_tscore
    account unlock
    password expire; --закончился надо будет переввести при логине

grant rl_tscore to tscore; 




create table tscore_table
(
i int,
j int
);

insert into tscore_table (i, j) values (1, 1);
insert into tscore_table (i, j) values (2, 2);

create view tscore_view as select * from tscore_table;
commit;
select * from tscore_view;


commit;



--11


create tablespace ts_qdata
datafile 'ts_qdata.dbf'
size 7m
autoextend on next 5m
maxsize 20m
offline;

alter tablespace ts_qdata online;

alter user tscore quota 2m on ts_qdata;


create table ts_t1
(
    str varchar(50)
) tablespace ts_qdata;

insert into  ts_t1 values ('1');
insert into  ts_t1 values ('2');
insert into  ts_t1 values ('3');

select * from  ts_t1;


 
    