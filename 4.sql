--1
--pluggable database
select * from v$pdbs;

--2
--экземпляры
select * from v$instance;

--3
select * from product_component_version;

--4:
--делается в configuration assistant

--5
select * from v$pdbs;

alter pluggable database ts_pdb open;

--6: создать подключение с именем pdb в service name и войти через него
create tablespace ts_pdb 
    datafile 'ts_pdb.dbf'
    size 7 m
    autoextend on next 5 m
    maxsize 20 m
    extent management local;
    
create temporary tablespace ts_pdb_temp
    tempfile 'ts_pdb_temp.dbf'
    size 5 m
    autoextend on next 3 m
    maxsize 30 m
    extent management local;
    
select tablespace_name, status, 
    contents logging 
    from sys.dba_tablespaces;
    
alter session set "_ORACLE_SCRIPT"=true;
 

create role rl_ts_pdb;
grant connect,
    create table,
    drop any table,
    create view,
    drop any view,
    create procedure, 
    drop any procedure
    to rl_ts_pdb;
commit;


 

create profile pf_ts_pdb limit
    password_life_time 180
    sessions_per_user 3
    failed_login_attempts 7
    password_lock_time 1
    password_reuse_time 10
    password_grace_time default 
    connect_time 180
    idle_time 30
    container = current;
commit;



create user user_ts_pdb 
    identified by 12345
    default tablespace ts_pdb quota unlimited on ts_pdb
    temporary tablespace ts_pdb_temp
    profile pf_ts_pdb
    account unlock;
grant rl_ts_pdb to user_ts_pdb;

-- 7
-- зайти как user_ts_pdb 
create table ts_pdb_table (i int, j int);

insert into ts_pdb_table (i, j) values (1, 111);
insert into ts_pdb_table (i, j) values (2, 222);
select * from ts_pdb_table;
    
-- 8
select * from dba_tablespaces;
select * from dba_data_files;
select * from dba_temp_files;
select * from dba_roles;
select grantee, privilege from dba_sys_privs;
select * from dba_profiles;
select * from all_users;


-- 9: войти как sys в orcl

create user c##ts identified by 11111;
grant create session to c##ts;
commit;
-- войти как sys в pdb
grant create session to c##ts;


 

--alter pluggable database ts_pdb close immediate;

--drop pluggable database ts_pdb including datafiles;

