# 多表查询
# 一对一，一对多，多对一，多对多

# 外键约束 foreign key ,是表的一个特殊字段，经常与主键的约束一起使用，对于两个具有关联关系的表而言，相关字段中主键所在的表就是主表（父表），外键所在的表就是从表（子表）。
/*
外键用来建立主表与从表的关联关系，为两个表的数据建立连接，约束两个表中数据的一致性和完整性。
例如：一个水果摊，只有苹果、桃子、李子、西瓜，那么买水果的话就只能选择苹果，桃子，李子，西瓜，其他水果是不能购买的

*/

# 外键的特点
/*
1, 主表必须是已经存在在数据库中，或者是当前正在创建的表。
2，必须为主表定义主键
3，主键不能包含空值，但允许在外键中出现空值。也就是说，只要外键的每个非空值出现在指定的主键中，这个键的内容就是正确的
4.在主表的表名后面指定列名或列名的组合，这个列或列的组合必须是主表的主键或者候选键
5.外键中列的数目必须和主表的主键列的数目相同
6.外键列中的数据类型必须和主表主键中对应列的数据类型相同
*/

# 外键约束的创建
-- 操作
/*
方式1，创建表时设置外键约束
[constraint <外键名> foreign key 字段名[,字段名2...] references <主表名> 主键列[,主键列2,...]
实现

*/



/*
复习：
rename table test to test1; -- 修改表名
alter table 表名 change 原列名 新列名 类型； --修改表的列属性名
alter table 表名 modify 列名 类型 ； --修改表的类类型
alter table 表名 drop 列名； --删除表的某一列
alter table 表名 add 列名 类型；--添加某一列
alter table 表名 rename 新表名； --修改表名

# 批量修改表名
SELECT
 CONCAT(
 'ALTER TABLE ',
 table_name,
 ' RENAME TO db_',
 substring(table_name, 4),
 ';'
 )
FROM
 information_schema. TABLES
WHERE
 table_name LIKE 'ct%';
 
 # 批量删除表名
 SELECT
 CONCAT(
 'drop table ',
 table_name,
 ';'
 )
FROM
 information_schema. TABLES
WHERE
 table_name LIKE 'uc_%';
*/

create database mydb3;
use mydb3;

# 创建部门表
create table if not exists dept (
	deptno varchar(10) primary key, -- 部门号
	name varchar(20) -- 部门名字
);

# deptno 属性拼错，修改之  change, modify ,
alter table dept change column detpno deptno varchar(10);
drop table dept;
truncate dept;

# 创建员工表
create table if not exists emp (
	eid varchar(20) primary key, -- 员工编号
	ename varchar(20), -- 员工名字
	age int, -- 员工年龄
	dept_id varchar(20), -- 员工所属部门
	constraint emp_fk foreign key (dept_id) references dept (deptno) -- 外键约束
);

## 创建表后新增外键约束
# 创建表dept2
create table if not exists dept2 (
	deptno varchar(10) primary key, -- 部门号
	name varchar(20) -- 部门名字
);

create table if not exists emp2 (
	eid varchar(20) primary key, -- 员工编号
	ename varchar(20), -- 员工名字
	age int, -- 员工年龄
	dept_id varchar(20) -- 员工所属部门
);
# 创建表后 添加外键约束
alter table emp2 add constraint emp2_fk foreign key (dept_id) references dept2 (deptno) -- 外键约束
# 删除外键
# alter table <表名> drop foreign key <外键约束名>;
ALTER TABLE mydb3.emp2 DROP FOREIGN KEY emp2_fk;


 -- 1、添加主表数据
 -- 注意必须先给主表添加数据
insert into dept values('1001','研发部');
insert into dept values('1002','销售部');
insert into dept values('1003','财务部');
insert into dept values('1004','人事部');


-- 2、添加从表数据
-- 注意给从表添加数据时，外键列的值不能随便写，必须依赖主表的主键列
insert into emp values('1','乔峰',20, '1001');
insert into emp values('2','段誉',21, '1001');
insert into emp values('3','虚竹',23, '1001');
insert into emp values('4','阿紫',18, '1002');
insert into emp values('5','扫地僧',35, '1002');
insert into emp values('6','李秋水',33, '1003');
insert into emp values('7','鸠摩智',50, '1003'); 
insert into emp values('8','天山童姥',60, '1005');  -- 不可以

-- 3、删除数据
 /*
   注意：
       1：主表的数据被从表依赖时，不能删除，否则可以删除
       2: 从表的数据可以随便删除
 */
delete from dept where deptno = '1001'; -- 不可以删除
delete from dept where deptno = '1004'; -- 可以删除
delete from emp where eid = '7'; -- 可以删除

# 删除的时候，先删除从表，再删除主表

-- 外键约束--多对多的关系

-- 表A一行对应表B的多行，同时表B的一行对应表A的多行



-- 学生表和课程表(多对多)
-- 1 创建学生表student(左侧主表)
create table if not exists student(
	sid int primary key auto_increment,
	name varchar(20),
	age int,
	gender varchar(20)
);

-- 2 创建课程表course(右侧主表)
create table course(
	cid  int primary key auto_increment,
	cidname varchar(20)
);

-- 3创建中间表student_course/score(从表)
create table score(
	sid int,
	cid int,
	score double
);
	
-- 4建立外键约束(2次)
alter table score add foreign key(sid) references student(sid);
alter table score add foreign key(cid) references course(cid);
 
-- 5给学生表添加数据
insert into student values(1,'小龙女',18,'女'),(2,'阿紫',19,'女'),(3,'周芷若',20,'男');
-- 6给课程表添加数据
insert into course values(1,'语文'),(2,'数学'),(3,'英语');
-- 7给中间表添加数据
insert into score values(1,1),(1,2),(2,1),(2,3),(3,2),(3,3);

-- 修改和删除时，中间从表可以随便删除和修改，但是两边的主表受从表依赖的数据不能删除或者修改。



