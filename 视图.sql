# 视图
/* 1.视图是一个虚拟的表，非真实存在，其本质是根据SQL语句获取动态的数据集，并为其命名，用户使用时只需使用视图名称即可获取结果集，并可以将其当做表来使用
2, 数据库中只存放了视图的定义，而没有存放视图中的数据，这些数据存放在原来的表中
3.使用视图查询数据时，数据库系统会从原来的表中取出对应的数据。因此视图中的数据时依赖于原来的表中的数据的。一旦表中的数据发生改变。显示在视图中的数据也会发生改变。

作用：
1.简化代码，可以把重复使用的查询封装成视图重复使用，同时可以是复杂的查询易于理解和使用g
2.安全原因，如果一张表中有许多数据，很多信息不希望让所有人看到，此时可以使用视图，
如：社会保险基金表，可以使用视图只显示姓名，地址，二不显示社会保险代号和工资数，可以对不同的用户，设定不同的视图
*/

-- 别名存在于内存中，视图存在于硬盘中

/*
创建视图的语法：
create [or replace] [algorithm = {undefined | merge | temptable}]

view view_name [(column_list)]

as select_statement

[with [cascades | local] check option]

参数说明：
（1）algorithm：可选项，表示视图选择的算法。
（2）view_name ：表示要创建的视图名称。
（3）column_list：可选项，指定视图中各个属性的名词，默认情况下与SELECT语句中的查询的属性相同。
（4）select_statement
：表示一个完整的查询语句，将查询记录导入视图中。
（5）[with [cascaded | local] check option]：可选项，表示更新视图时要保证在该视图的权限范围之内。

*/

create database mydb6_view;
use mydb6_view;

-- 创建部门表
create table dept (
	deptno int primary key, -- 部门编号
	dname varchar(14), -- 部门名称
	loc varchar(13) -- 部门地址
);

-- drop table dept;
-- truncate table dept;


insert into dept values(10, "教研部", "北京");
insert into dept values(20, "学工部", "上海");
insert into dept values(30, "销售部", "广州");
insert into dept values(40, "财务部", "武汉");


-- 创建员工表
create table if not exists emp(
  empno int primary key, -- 员工编号
  ename varchar(20), -- 员工名字
	job varchar(9), -- 员工工资
	mgr int, -- 员工直属领导编号
	hiredate date, -- 入职时间
	sal double, -- 工资
	comm double, -- 奖金
	deptno int -- 对应dept表的外键
);

-- 添加外键
alter table emp add constraint foreign key emp(deptno) references dept(deptno);

insert into emp values(1001, '甘宁', '文员', 1013, '2000-12-17', 8000.00, NULL, 20);
insert into emp values(1002, '黛丽丝', '销售员', 1006, '2001-02-20', 16000.00, 3000, 30);
insert into emp values(1003, '殷天正', '销售员', 1006, '2001-02-22', 12500.00, 5000,30);
insert into emp values(1004, '刘备', '经理', 1009, '2001-04-02', 29750.00, NULL, 20);
insert into emp values(1005, '谢逊', '销售员', 1006, '2001-09-28', 12500.00, 14000, 30);
insert into emp values(1006, '关羽', '经理', 1009, '2001-05-01', 285000.00, NULL, 30);
insert into emp values(1007, '张飞', '经理', 1009, '2001-09-01', 245000.00, NULL, 10);
insert into emp values(1008, '诸葛亮', '分析师', 1004, '2001-09-01', 30000.00, NULL, 20);
insert into emp values(1009, '曾阿牛', '董事长', NULL, '2001-11-17', 50000.00, NULL, 10);
insert into emp values(1010, '韦一笑', '销售员', 1006, '2001-09-08', 15000.00, 0.0, 30);
insert into emp values(1011, '周泰', '文员', 1008, '2007-05-23', 11000.00, NULL, 20);
insert into emp values(1012, '程普', '文员', 1006, '2001-12-03', 9500.00, NULL, 30);
insert into emp values(1013, '庞统', '分析师', 1004, '2001-12-03', 30000.00, NULL, 20);
insert into emp values(1014, '黄盖', '文员', 1007, '2002-01-23', 13000.00, NULL, 10);

-- drop table emp;
-- truncate table emp;


-- 创建工资等级表
create table salgrade(
	grade int, -- 等级
	losal double, -- 最低工资
	hisal double -- 最高工资
);


insert into salgrade values(1, 700, 1200);
insert into salgrade values(2, 1201, 1400);
insert into salgrade values(3, 1401, 2000);
insert into salgrade values(4, 2001, 3000);
insert into salgrade values(5, 3000, 9999);


# 创建视图
create or replace view view1_emp as select ename, job from emp;

show tables;
show full tables;

select * from view1_emp;

describe view1_emp;

-- 修改视图
alter view view1_emp
as 
select a.deptno, a.dname, a.loc, b.ename, b.sal from dept a, emp b where a.deptno = b.deptno;

select * from view1_emp;

-- 更新视图
/*
可以在UPDATE、DELETE或INSERT等语句中使用它们，以更新基表的内容。对于可更新的视图，在视图中的行和基表中的行之间必须具有一对一的关系。如果视图包含下述结构中的任何一种，那么它就是不可更新的：
聚合函数（SUM(), MIN(), MAX(), COUNT()等）
DISTINCT
GROUP BY
HAVING
UNION或UNION ALL
位于选择列表中的子查询
JOIN
FROM子句中的不可更新视图
WHERE子句中的子查询，引用FROM子句中的表。
仅引用文字值（在该情况下，没有要更新的基本表）

视图中虽然可以更新数据，但是有很多的限制。一般情况下，最好将视图作为查询数据的虚拟表，而不要通过视图更新数据。因为，使用视图更新数据时，如果没有全面考虑在视图中更新数据的限制，就可能会造成数据更新失败。

*/

-- 更新视图就是更新原表的数据

update view1_emp set ename = '周瑜' where name = '鲁肃';
insert into view1_emp values('孙权', '文员');

-- --------------- 视图包含聚合函数不可更新-------------
create or replace view view2_emp
as
select count(*) cnt from emp group by deptno;

select * from view2_emp;
# 插入失败
insert into view2_emp values(100);
# 插入失败
update view2_emp set cnt = 100;


-- --------------- 视图包含union ,union all不可更新-------------
create or replace view view5_emp
as
select empno, ename from emp where empno <= 1005
union
select empno, ename from emp where empno > 1005;
# 插入失败
insert into view5_emp values(1015, '韦小宝'); -- The target table view5_emp of the INSERT is not insertable-into
-- union 前后查询的结果上下 合到一起，去重
-- union all  前后查询的结果上下 合到一起，不去重
-- jion是左右拼接

-- --------------- 视图包含子查询不可更新-------------
create or replace view view6_emp
as
select empno, ename, sal from emp where sal = (select max(sal) from emp);

insert into view6_emp values(1015, '韦小宝', 30000);

-- --------------- 视图包jion查询不可更新-------------
create or replace view view7_emp
as
select dname, ename, sal from emp a join dept b on a.deptno = b.deptno;
# 插入失败
insert into view7_emp(dname, ename, sal) values('行政部', '韦小宝', 3000);

create or replace view view8_emp
as
select '行政部' dname, '杨过' ename;

insert into view8_emp values('行政部', '杨过');

############### 
# 重命名视图，删除视图

-- 1.重命名视图
rename table view1_emp to myview1;

-- 2.删除视图
drop view myview1;

show tables;

-- 视图练习
# 1.查询部门平均薪资最高的部门名称
select deptno, avg(deptno) from emp group by deptno;





