# MySQL 数据库基本操作-DQL-基本查询
# 不只简单的返回查询的数据，还应该根据需要对数据进行筛选以及确定数据以什么样的格式显示。
/*语法格式
select 
[all | distinct]
<目标列的表达式1> [别名],
<目标列的表达式2> [别名],
from <表名或视图名> [别名], <表名或视图名> [别名]...
[where <条件表达式>]
[group by <列名>]
[having <条件表达式>]
[order by <列名> [asc | desc]
[limit <数字或者列表>];

*/

-- 创建数据库和表：
-- 创建数据库
create database if not exists mydb2;
use mydb2;

-- 创建商品表：
create table product(
pid int primary key auto_increment, 	-- 商品编号
pname varchar(20) not null,		-- 商品名字
price double,		-- 商品价格
category_id varchar(20)		-- 商品所属分类
);

# 添加数据
insert into product values (null, '海尔洗衣机', 5000, 'c001');
insert into product values (null, '美的冰箱', 3000, 'c001');
insert into product values (null, '格力空调', 5000, 'c001');
insert into product values (null, '九阳点饭煲', 200, 'c001');

insert into product values(null,'啄木鸟衬衣',300,'c002');
insert into product values(null,'恒源祥西裤',800,'c002');
insert into product values(null,'花花公子夹克',440,'c002');
insert into product values(null,'劲霸休闲裤',266,'c002');
insert into product values(null,'海澜之家卫衣',180,'c002');
insert into product values(null,'杰克琼斯运动裤',430,'c002');

insert into product values(null,'兰蔻面霜',300,'c003');
insert into product values(null,'雅诗兰黛精华水',200,'c003');
insert into product values(null,'香奈儿香水',350,'c003');
insert into product values(null,'SK-II神仙水',350,'c003');
insert into product values(null,'资生堂粉底液',180,'c003');

insert into product values(null,'老北京方便面',56,'c004');
insert into product values(null,'良品铺子海带丝',17,'c004');
insert into product values(null,'三只松鼠坚果',88,null);

# 清空表数据
truncate product;

# 1.查询所有商品
# 逐个写出列名
select pid,pname,price,category_id from product;
# 用*代表查询所有列
select * from product;

# 2.查询商品名和商品价格。
select pname,price from product;

# 3.别名查询，使用的关键字是as, as可以省略
# 3.1 表别名 , 多表查询使用表别名可以简化书写
select * from product as p;
select * from product p;


# 3.2 列别名
select pname as '商品名', price '商品价格' from product;


# 4.去掉重复值 一般distinct 后面只跟一列。
select distinct price from product;

# * 代表，去除重复行，两条数据信息全部一致
select distinct * from product;

# 5.查询结果是表达式 (运算查询),将所有商品的价格加10元进行显示
select pname, price + 10 new_price from product;


###############
# 1.运算符 
# 1.1 算术运算符 
# 	+-*/% 加减乘除模

select 1+1;
select 1-1;
select 1*1;
select 1/1;
select 5%2;

-- 每件商品的价格加10
select pname,price + 10 new_price from product;
-- 每件商品的价格加10%
select pname,price*1.1 new_price from product;


# 1.2 比较运算符
/*
	=
	< <=
	> >=
	<=> 安全的等于，两个操作码均为NULL时，其所得值为1，而当一个操作码为NULL时，其所得值为0.
	<>	!= 不等于
	IS NULL 或 ISNULL  判断一个值是否已为NULL
	IS NOT NULL 判断一个值是否不为NULL
	LEAST ,当有两个或多个参数时，返回最小值
	GREATEST ,当有两个或多个参数时，返回最大值
	BETWWEEN AND , 判断一个值是否落在两个值之间
	IN	,判断一个值是 IN列表中的任意一个值
	NOT IN，	判断一个值不是列表中的任意一个值
	LIKE,		通配符匹配
	REGEXP，	正则表达式匹配
*/

# 1.3 逻辑运算符
/*
	NOT 或者 ！, 		逻辑非
	AND 或者 &&，		逻辑与
	OR 	或者	||，	逻辑或
	XOR							逻辑异或
*/

# 1.4 位运算符
/*
	| 	按位或
	& 	按位与
	^		按位异或
	<<	按位左移
	>> 	按位右移
	~		按位取反，反转所有比特
*/

-- 查询所有商品名称为'海尔洗衣机'的商品的所有信息
select * from product where pname = '海尔洗衣机';

-- 查询价格为800的商品
select * from product where price = 800;

-- 查询价格不是800的商品
select * from product where price != 800;
select * from product where price <> 800;
select * from product where not (price = 800);


-- 查询商品价格大于60元的所有信息
select * from product where price >= 60;

-- 查询商品价格在200--1000之间的商品
select * from product where price between 200 and 1000;
select * from product where price >= 200 and price <= 1000;
select * from product where price >= 200 && price <= 1000;

-- 查询商品价格是200 或 800 的商品
select * from product where price in(200, 800);


-- 查询商品名中带有'鞋'字的商品  %用来匹配任意字符
select * from product where pname like '%鞋';	-- 没有
select * from product where pname like '%裤';	-- 有

-- 查询商品中以'海'字开头的字符
select * from product where pname like '海%';

-- 查询第二个字为'蔻'的商品,  _  匹配一个字符，别忘记后面的百分号
select * from product where pname like '_蔻%';

-- 查询category_id 为null的商品
select * from product where category_id is null;
-- 查询category_id 不为null的商品
select * from product where category_id is not null;


-- 使用list来求最小值
select least(1,2,3) as small_numall;
-- 如果求最小/大值中有一个值为null，结果直接返回null
select least(1,2,null) as small_numall;
select greatest(1,2,null) as small_numall;



#######################
# 1.排序
# 使用 order by 来排序

/*
语法格式：
select 
字段名1， 字段名2，...
form 表名
order by 字段名1[asc | desc], 字段名2[asc | desc]...
*/

/*
1. asc代表升序， desc代表降序，如果不写默认升序
2. order by， 用于字句中可以支持单个字段，多个字段，表达式，函数，别名
3. order by 子句放在查询语句的最后面，limit 子句除外。
*/


-- 1.使用价格排序，降序
select * from product order by price desc;

-- 2.在价格降序的基础上， 分类降序

select * from product order by price desc, category_id desc;

-- 3.显示商品的价格（去重复），并排序，降序
select distinct price from product order by price desc;

####################

# 1.聚合查询
-- 聚合函数
/**
count()		统计指定列不为NULL的记录行数
sum()			统计指定列的数值和，非数值，返回0
max()			
min()
avg()
*/

-- 1.查询商品的总行数
select count(pid) from product;
select count(*) from product;

-- 2.查询价格大于200的商品的总条数
select count(*) from product where price > 200;

-- 3.查询分类为'c001'的所有商品的总条数
select sum(price) from product where category_id = 'c001';

-- 4.查询商品的最大价格
select max(price) from product;

-- 5.查询商品的最小价格
select min(price) from product;

select min(price) min_price, max(price) max_price from product;

-- 6.查询分类为'c002'的所有商品的平均价格
select avg(price) from product where category_id = 'c002';

##########################

-- 聚合查询对null的处理
/*
	count函数对null值的处理：如果count(*),则统计所有记录的个数，如果count(name),则不统计含有null值得记录个数。
	
	min,max,avg，会忽略null值的存在
*/


##########################

# 1.分组查询， 分组查询，会把整个表切割成多个临时表，会对每个临时表进行count, select ,
-- group by ,分组查询语句中，select字句之后只能出现分组字段和统计函数，其他字段不能出现。

--  1.统计各个分类商品的个数
-- 会把整个表切割成多个临时表，会对每个临时表进行count
select category_id,count(pid) from product group by category_id;


-- 2.分组之后的条件筛选 having
-- 2.1	分组之后对统计结果进行筛选的话必须使用having,不能使用where字句。
-- 2.2 where子句用来筛选 from 子句中指定的操作产生的行。
-- 2.3 group by 字句用来分组 where 字句的输出
-- 2.4 having 用来从分组的结果中进行筛选

## SQL 执行顺序 from -> GROUP BY --> count --> select --> HAVING --> order by
-- 3.1 统计各个分类商品的个数，且只显示个数大于4的信息
select category_id, count(pid) cnt from product group by category_id having cnt > 4 order by cnt;








