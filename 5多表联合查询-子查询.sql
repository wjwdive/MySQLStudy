-- 子查询
/*
	将查询结果当做一个值，一行一列
	将查询结果当做多个值，一列多行
	将查询结果当做一张表, 一行多列，多行多列
*/

use mydb3;

-- -- 创建部门表
-- create table if not exists dept3(
--   deptno varchar(20) primary key ,  -- 部门号
--   name varchar(20) -- 部门名字
-- );
--  
-- -- 创建员工表
-- create table if not exists emp3(
--   eid varchar(20) primary key , -- 员工编号
--   ename varchar(20), -- 员工名字
--   age int,  -- 员工年龄
--   dept_id varchar(20)  -- 员工所属部门
-- );

-- 查询年龄最大的员工信息，显示信息包含员工号，员工名字，员工年龄
# 1.查询最大年龄
select max(age) from emp3;
# 2.让每个员工的年龄和最大年龄进行比较，相等则满足条件
select * from emp3 where age = (select max(age) from emp3); -- 单行单列可以作为一个值来使用

-- 查询研发部和销售部的员工信息，包含员工号，员工名字
# 1.方式一，多表关联查询
select * from emp3 a join dept3 b on a.dept_id = b.deptno where b.name = '研发部' or b.name = '销售部';
# 或者
select * from emp3 a join dept3 b on a.dept_id = b.deptno and (b.name = '研发部' or b.name = '销售部');


# 方式二，
# 2.1 先查询研发部和销售部的部门号，deptno 1001,1002
select * from dept3 where name = '研发部' or name = '销售部';

# 2.2 查询那个员工的部门号是1001 或者1002
select * from emp3 where dept_id in (select deptno from dept3 where name = '研发部' or name = '销售部'); -- 多行单列

##关联查询快一点

-- 查询研发部20岁以下的员工信息，包括员工号，员工名字，部门名字
# 1 方式一，关联查询
select * from dept3 a join emp3 b on a.deptno = b.dept_id and (name = '研发部' and age < 20);

# 2 方式二， 子查询
#  2.1在部门表中查询研发部信息
select * from dept3 where name = '研发部'; -- 一行多列

# 2.2 在员工表中查询年龄小于 20s岁的员工信息
select * from emp3 where age < 30;

# 2.3 将以上两个查询的结果进行关联查询
select * from (select * from dept3 where name = '研发部') t1 join (select * from emp3 where age < 30) t2 on t1.deptno = t2.dept_id; -- 多行多列

########### 
# 子查询关键字 ALL, ANY, SOME, IN, EXITST
# ALL， 与子查询返回的所有值比较为true，则返回true,
# 			可以与 =,>,< ,>= , <= , <> 结合使用，<> 不等于括号内子查询结果的所有值
#					
# select * from where c > all(查询语句)；

-- 1.查询年龄大于'1003' 部门所有年龄的员工信息
select * from emp3 where age > all(select age from emp3 where dept_id = '1003');

-- 2. 查询不属于任何一个部门的员工信息
select * from emp3 where dept_id != all(select deptno from dept3);


# ANY 和 SOME 一致
# ANY 和 SOME 与子查询返回的所有值比较为true，则返回true,
# 可以与 =,>,< ,>= , <= , <> 结合使用，<> 不等于括号内子查询结果的所有值
-- 查询年龄大于'1003'部门任意一个员工年龄的员工信息
select * from emp3 where (age > any(select age from emp3 where dept_id = '1003')) and dept_id != '1003';

# IN
-- 查询研发部和销售部的员工信息，包含员工号，员工名字
select eid , ename from emp3 where dept_id in (select deptno from dept3 where name = '研发部' or name = '销售部'); 

# EXISTS ，如果子查询结果至少有一行数据，则该EXISTS()的结果为true,然后执行外层查询
# 					如果子查询“没有数据结果”，则该EXISTS()的结果为false,外层查询不执行
# EXISTS 后面的子查询不返回任何实际数据，只返回真或假，返回true时条件成立。
# EXISTS关键字比IN关键字的运算效率更高，因此在查询大数据量时，推荐使用。

# 全表输出：
select * from emp3 where exists(select 1);
select * from emp3 where exists(select * from emp3);

-- 查询公司是否有大于60岁的员工，有则输出
select * from emp3 a where exists (select * from emp3 b where a.age > 60);

# 错误查询, 因为子查询每次查询都有结果，外部查询每次都会执行，相当于全表输出
select * from emp3 a where exists(select * from emp3 where age > 60);
# 解决办法是，子查询中用外层查询中的参数做判断。妙啊！！

# 使用in,可以实现和exists类似的效果
select * from emp3 a where eid in(select eid from emp3 where a.age > 60);
-- 查询有所属部门的员工信息
# 错误解法，没有过滤掉 丁春秋，1005,这个部门号在部门表中不存在
select * from emp3 a where exists (select dept_id from dept3 b where a.dept_id is not null);
# 正解
select * from emp3 a where exists (select dept_id from dept3 b where a.dept_id = b.deptno);
# 使用in 子查询关键字
select * from emp3 a where a.dept_id in (select deptno from dept3 b where a.dept_id = b.deptno);

# 外层查询每个员工的时候，看看这个员工的部门号是不是在部门表中存在。


-- 自关联查询， 查询时需要进行对标自身进行相关查询，即一张表自己和自己关联，一张表当成多张表来用。注意自关联查询需要起别名

/*
格式：
select 字段列表 from 表1 a, 表1 b where 条件;
select 字段列表 from 表1 a [left] join 表1 b on 条件；
*/
-- 创建表,并建立自关联约束
create table t_sanguo(
	eid int primary key ,
	ename varchar(20),
	manager_id int,  -- 外键列
	foreign key (manager_id) references t_sanguo (eid)  -- 添加自关联约束
);

-- 添加数据 
insert into t_sanguo values(1,'刘协',NULL);
insert into t_sanguo values(2,'刘备',1);
insert into t_sanguo values(3,'关羽',2);
insert into t_sanguo values(4,'张飞',2);
insert into t_sanguo values(5,'曹操',1);
insert into t_sanguo values(6,'许褚',5);
insert into t_sanguo values(7,'典韦',5);
insert into t_sanguo values(8,'孙权',1);
insert into t_sanguo values(9,'周瑜',8);
insert into t_sanguo values(10,'鲁肃',8);
 
-- 进行关联查询
-- 1.查询每个三国人物及他的上级信息，如:  关羽  刘备 
select * from t_sanguo a, t_sanguo b where a.manager_id = b.eid;
# 也可以是如下方式
select a.ename, b.ename from t_sanguo a, t_sanguo b where a.manager_id = b.eid;
select a.ename, b.ename from t_sanguo a join t_sanguo b on a.manager_id = b.eid;

# 这个查询结果是并查集
select * from t_sanguo a, t_sanguo b;

# 查询所有人物的上级，上上级：比如： 张飞-刘备-刘协
# 答案是多次自关联查询

select a.ename, b.ename, c.ename from t_sanguo a 
	left join t_sanguo b on a.manager_id = b.eid
	left join t_sanguo c on b.manager_id = c.eid;
