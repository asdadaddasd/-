//����jzl_test��
create database jzl_test;
//����������
use jzl_test;
create table log(pickuptime string,cityName string,address string,airporName string,car string,supplier string,price double,useTime date,distance double,flag int)
partitioned by (year int,month  int,day int)
row format delimited fields terminated by '\t';
//��������
load data inpath "'$str1'" into table jzl_test.log partition(year="'$year'",month="'$month'",day="'$day'")
//ɾ����
drop table log;
//��ѯ
select * from log

//���ÿ������5ǧ�׾����ͻ��۸���͹�Ӧ��

select flag,cityname,address fromadd,airporname toadd,car,supplier,price,usetime from log b
join (select  flag f,cityname name,address a,supplier s,min(price) p,year,month,day from log
where distance <= 5
group by year,month,day,flag,cityname,address,supplier) a
on a.name = cityname and a.p = price and a.a = address and a.s = supplier and a.f = flag
where a.year = b.year and a.year =  cast(from_unixtime(unix_timestamp(),"yyyy") as int)
and b.month = a.month and a.month = cast(from_unixtime(unix_timestamp(),"MM") as int)
and a.day = b.day and a.day = 25 cast(from_unixtime(unix_timestamp(),"dd") as int)

//��õ�������Լ�������о���������Ϣ
//���룺�ҳ�����Լ��������ͼ۸����Ϣ
select flag,cityname,address fromadd,car,airporname toadd,supplier,price,usetime from log b
join(select flag f,cityname n,address a,car c,min(price) p,year,month,day  from log
group by year,month,day,flag,cityname,address,car) a
on a.n = cityname and a.c = car and a.a = address
where supplier = "����Լ��" and a.p <price  and a.f = flag
and a.year = b.year and a.year =  cast(from_unixtime(unix_timestamp(),"yyyy") as int)
and b.month = a.month and a.month = cast(from_unixtime(unix_timestamp(),"MM") as int)
and a.day = b.day and a.day = 25 cast(from_unixtime(unix_timestamp(),"dd") as int)
//��õ����и�·����û������Լ������Ϣ
//����Լ������
select cityname c,airporname air,address a,supplier s,usetime from log
where supplier = "����Լ��"
group by usetime,cityname,airporname,address,supplier
//���ж���
select cityname,airporname,address from log
group by cityname,airporname,address
//*************************************************************
select flag,cityname,airporname toadd,address fromadd,usetime from (
select year,month,day,flag,cityname,airporname,address,usetime from log
group by year,month,day,flag,usetime,cityname,airporname,address)  a
left join (
select year,month,day,flag f,cityname c,airporname air,address a,supplier s from log
where supplier = "����Լ��"
group by year,month,day,flag,cityname,airporname,address,supplier)  b
on a.cityname = c and a.airporname = air and a.address = b.a and b.f = a.flag
where b.s is null
and a.year = b.year and a.year =  cast(from_unixtime(unix_timestamp(),"yyyy") as int)
and b.month = a.month and a.month = cast(from_unixtime(unix_timestamp(),"MM") as int)
and a.day = b.day and a.day = 25cast(from_unixtime(unix_timestamp(),"dd") as int)-1

//��ѯ�����У�ͬһ·�ߡ���ͬʱ�䡢ͬһ�����ͣ�Я�̼۸񲻵ȵ���Ϣ
select distinct a.airporname toadd,a.address fromadd,a.car,a.price,a.pickuptime,b.price,b.pickuptime from log a
join log b
on a.airporname = b.airporname and a.address = b.address and a.car = b.car and a.supplier = "����Լ��" and a.supplier = b.supplier
where a.price != b.price and a.pickuptime < b.pickuptime 
and a.year = b.year and a.year =  cast(from_unixtime(unix_timestamp(),"yyyy") as int)
and b.month = a.month and a.month = cast(from_unixtime(unix_timestamp(),"MM") as int)
and a.day = b.day and a.day = cast(from_unixtime(unix_timestamp(),"dd") as int)-1



//��ѯÿ���У�ͳһ���ƣ�ͬһ·�ߡ�ͬһ�����̡�ͬһ�ó�ʱ�䣨ʱ����ͬ�����ó��۸�ͬ

select distinct a.airporname toadd,a.address fromadd,a.car,a.price,a.pickuptime from log a
join log b
on a.airporname = b.airporname and a.address = b.address and a.car = b.car and a.supplier = b.supplier and a.`month` = b.`month` 
where a.price != b.price and split(a.pickuptime, ':')[0] = split(b.pickuptime, ':')[0] and split(a.pickuptime, ':')[1] = split(b.pickuptime, ':')[1]
and a.year = b.year and a.year =  cast(from_unixtime(unix_timestamp(),"yyyy") as int)
and b.month = a.month and a.month = cast(from_unixtime(unix_timestamp(),"MM") as int)

//��ò�ͬ�����̵ĳ���ռ��

select  supplier,concat(round(nu/num, 4) * 100, '%') por from
(select num,nu,supplier from 
(select count(*) num from log) a,
(select count(car) nu,supplier  from log
group by supplier) b) c



