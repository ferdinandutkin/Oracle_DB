drop table OAA_t;
drop table OAA_t1;
commit;

create table OAA_t ( x number(3) primary key, s varchar2(50));
insert into OAA_t values (1, '1');
insert into OAA_t values (2, '2');
insert into OAA_t values (3, '33');
commit;

select x as "dsf", s as "dsf"
from OAA_t;

update OAA_t
set x = x + 1
where x >= 2;

commit;

select x as "num", s as "str"
from OAA_t;


select sum(x) as "sum"
from OAA_t
where x >=2;

delete from OAA_t
where x = 1;
commit;

select x as "num", s as "str"
from OAA_t;

create table OAA_t1
(
pk int primary key,
fk number(3) not null,
constraint fk_x
    foreign key (fk) references OAA_t(x)
);

commit;

insert into OAA_t1 values (111,1);
insert into OAA_t1 values (222,2);

commit;

select * 
from OAA_t1 inner join OAA_t on fk = x;

select * 
from OAA_t1 left outer join OAA_t  on fk = x;

select * 
from OAA_t1 right outer join OAA_t  on fk = x;