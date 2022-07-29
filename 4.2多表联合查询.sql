-- 多表联合查询
# 交叉联合查询
select * from table_a, table_b;

# 内连接查询，关键字，inner join, inner可以省略

# 隐式内连接 SQL92标准
select * from A ,B where 条件;

# 显式内连接 SQL99标准
select * from A inner join B on 条件;


# 外连接查询，关键字，outer join, outer 可以省略
# 左外连接：left outer join
select * from A left outer join B on 条件;

# 右外连接：right outer join
select * from A right outer join B on 条件;

# 满外连接：full outer join
select * from A full outer join B on 条件;


##### 子查询   ###########重要

# 表自关联：将一张表当成多张表来用

-- 创建部门表
create table if not exists dept3(
  deptno varchar(20) primary key ,  -- 部门号
  name varchar(20) -- 部门名字
);
 
-- 创建员工表
create table if not exists emp3(
  eid varchar(20) primary key , -- 员工编号
  ename varchar(20), -- 员工名字
  age int,  -- 员工年龄
  dept_id varchar(20)  -- 员工所属部门
);

-- 给dept3表添加数据
insert into dept3 values('1001','研发部');
insert into dept3 values('1002','销售部');
insert into dept3 values('1003','财务部');
insert into dept3 values('1004','人事部');

-- 给emp表添加数据
insert into emp3 values('1','乔峰',20, '1001');
insert into emp3 values('2','段誉',21, '1001');
insert into emp3 values('3','虚竹',23, '1001');
insert into emp3 values('4','阿紫',18, '1001');
insert into emp3 values('5','扫地僧',85, '1002');
insert into emp3 values('6','李秋水',33, '1002');
insert into emp3 values('7','鸠摩智',50, '1002'); 
insert into emp3 values('8','天山童姥',60, '1003');
insert into emp3 values('9','慕容博',58, '1003');
insert into emp3 values('10','丁春秋',71, '1005');

# 交叉连接查询, 没有查询条件，会产生很多冗余数据
select * from dept3,emp3;

# 内连接查询
-- 查询每个部门的所属员工
-- 隐式内连接
select * from dept3, emp3 where dept3.deptno = emp3.dept_id;

-- 显式内连接
select * from dept3 inner join emp3 where dept3.deptno = emp3.dept_id;

-- 查询研发部门的所员工信息
-- 隐式内连接
select * from dept3 a, emp3 b where a.deptno = b.dept_id and name = '研发部';
-- 显式内连接
select * from dept3 a join emp3 b where a.deptno = b.dept_id and name = '研发部';


-- 查询研发部和销售不得所有员工
select * from dept3 a join emp3 b where a.deptno = b.dept_id and (name = '研发部' or name = '销售部');
select * from dept3 a join emp3 b where a.deptno = b.dept_id and name in( '研发部', '销售部');

-- 查询每个部门的员工数，并按升序排列
# count(1)==count(*)==count(deptno)
# 一般分组之后只能写三个字段，和聚合函数。但是分组的
select a.name, a.deptno,count(1) from dept3 a join emp3 b on a.deptno = b.dept_id group by a.deptno, name; 

-- 查询人数大于等于3的部门，并按照人数降序
select
	a.name,
	a.deptno,
	count(1) as total_cnt
from
	dept3 a join emp3 b 
on
	a.deptno = b.dept_id 
group by
	a.deptno, a.name
having
	total_cnt >= 3
order by
	total_cnt 
desc;


# 内连接是求交集
# 外连接是求单个

# 左外连接，把左表的数据输出，如果右表有对应的数据，则输出，没有则补上NULL

# 右外连接，把右表的数据输出，如果左表有对应的数据，则输出，没有则补上NULL

# 满外连接，mysql 对满外连接的支持不好。我们可以使用union来达到目的。

-- 外连接查询
-- 查询哪些部门有员工，哪些部门没有员工
use mydb3;
select * from dept3 left outer join emp3 on dept3.deptno = emp3.dept_id;

-- 查询哪些员工有对应的部门，哪些没有
select * from dept3 right outer join emp3 on dept3.deptno = emp3.dept_id;
 
# mySql 对full outer join 支持不好
# select * from dept3 full outer join emp3 on dept3.deptno = emp3.dept_id;

-- 使用union关键字实现左外连接和右外连接的并集
select * from dept3 left outer join emp3 on dept3.deptno = emp3.dept_id
union 
select * from dept3 right outer join emp3 on dept3.deptno = emp3.dept_id;

/*
# 多个做连接
select * from A
	left join B on 条件1
	left join C on 条件2
	left join D on 条件3
*/







