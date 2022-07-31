-- 创建数据库test1
create database testdb1;

use testdb1;

-- 创建部门表
create table dept (
	deptno int primary key, -- 部门编号
	dname varchar(14), -- 部门名称
	loc varchar(13) -- 部门地址
);

-- drop table dept;
-- truncate table dept;

insert into dept values ( 10, "accounting", "new york");
insert into dept values ( 20, "research", "dallas");
insert into dept values ( 30, "sales", "chicago");
insert into dept values ( 40, "operations", "boston");

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

alter table emp add constraint foreign key emp(deptno) references dept(deptno);

drop table emp;

insert into emp values(7369, 'smith', 'clerk',7902, '1980-12-17',800,null,20);
insert into emp values(7499, 'allen', 'salesman' ,7698, '1981-02-20', 1600,300, 30);
insert into emp values(7521, 'ward', 'salesman', 7698, '1981-02-22',1250, 500,30);
insert into emp values(7566, 'jones', 'manager', 7839, '1981-04-02',2975, null,20);
insert into emp values(7654, 'martin', 'salesman', 7698, '1981-09-28',1250,1400,30);
insert into emp values(7698, 'blake', 'manager', 7839, '1981-05-01',2850,null,30);
insert into emp values(7782, 'clark', 'manager', 7839, '1981-06-09',2450,null,10);
insert into emp values(7788, 'scott', 'analyst', 7566, '1987-07-03', 3000,null,20);
insert into emp values(7839, 'king', 'president', null, '1981-11-17',5000,null,10);
insert into emp values(7844, 'turner', 'salesman' ,7698, '1981-09-08',1500,0,30);
insert into emp values(7876, 'adams', 'clerk', 7788, '1987-07-13',1100,null,20);
insert into emp values(7900, 'james', 'clerk', 7698, '1981-12-03' ,950, null,30);
insert into emp values(7902,'ford', 'analyst', 7566, '1981-12-03', 3000,null, 20);
insert into emp values(7934, 'miller', 'clerk', 7782, '1981-01-23', 1300,null,10);

truncate table emp;
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


-- 1，返回拥有员工的部门号，部门名称
select distinct dname, d.deptno from dept d join emp e on d.deptno = e.deptno;

-- 2, 工资水平多余smith的员工信息
select sal from emp b where b.ename = 'smith';
select * from emp where sal > (select sal from emp b where b.ename = 'smith');

-- 3，返回员工所属经理的姓名
select a.ename as '员工姓名', b.ename '领导姓名' from emp a join emp b where a.mgr = b.empno; -- 自己写的，语法不规范
select a.ename as '员工姓名', b.ename '经理姓名' from emp a join emp b on a.mgr = b.empno; -- a join b xx on 

-- 4，返回雇员的雇佣日期早于其经理雇佣日期的员工及其经理姓名

select a.ename as '员工姓名', b.ename '经理姓名', a.hiredate, b.hiredate from emp a join emp b on a.mgr = b.empno where a.hiredate < b.hiredate;

-- 5，返回员工姓名及其所在的部门名称
select a.ename, b.dname from emp a join dept b on a.deptno = b.deptno;


-- 6.返回从事clerk 工作的员工姓名和所在部门名称
select a.ename, b.dname, a.job from emp a join dept b on a.deptno = b.deptno and a.job = 'clerk';

-- 7，返回部门号及其本部门的最低工资
# 错误解法
# select b.deptno , min(a.sal) from emp a join dept b on a.deptno = b.deptno;# where a.sal <= min(a.sal);
# 部门编号已在emp表中，不同部门各有一个最低工资
select deptno, min(sal) from emp group by deptno;

-- 8，返回销售部sales所有员工的姓名
select a.ename, b.dname from emp a join dept b on a.deptno = b.deptno and b.dname = 'sales';

-- 9，返回工资水平多于平均工资的员工
# 错误解法
# select ename, avg(sal) as avgsal from emp  where sal > avgsal; # (select sal from emp b where

-- 10，返回与scott从事相同工作的员工










