# 查询练习2

use mydb2;

CREATE TABLE emp(
empno INT,	-- 员工编号ename
ename VARCHAR(50), -- 员工名字
job VARCHAR( 50), -- 工作名字
mgr INT,	-- 上级领导编号
hiredate DATE,	-- 入职旦期
sal INT,	-- 薪资
comm INT, -- 奖金
deptno INT-- 部门编号
);

INSERT INTO emp VALUES(7369,'SMITH', 'CLERK', 7902, '1980-12-17', 800, NULL, 20);
INSERT INTO emp VALUES(7499,'ALLEN', 'SALESNAN', 7698, '1981-02-20', 1600, 300, 30);
INSERT INTO emp VALUES(7521,'WARD', 'SALESMAN', 7698, '1981-02-22', 1250, 500, 30);
INSERT INTO emp vALUES(7566,'ONES', 'MANAGER', 7839, '1981-04-02', 2975, NULL, 20);
INSERT INTO emp VALUES(7654,'WARTIN', 'SALESMAN', 7698, '1981-09-28', 1250,1400, 30);
INSERT INTO emp VALUES(7698,'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850, NULL, 30);
INSERT INTO emp VALUES(7782,'CLARK', 'MANAGER' , 7839, '1981-06-09', 2450, NULL, 10);
INSERT INTO emp VALUES(7788,'SCOTT', ' ANALYST', 7566, '1987-04-19', 3000, NULL, 20);
INSERT INTO emp VALUES(7839,'KING', 'PRESIDENT', NULL, '1981-11-17', 5000, NULL, 10);
INSERT INTO emp VALUES(7844,'TURNER', 'SALESMAN' ,7698,'1981-09-08', 1500, 0, 30);
INSERT INTO emp VALUES(7876,'ADAMNS', 'CLERK',7788,'1987-05-23', 1100, NULL, 20);
INSERT INTO emp VALUES(7900,'AMNES', 'CLERK',7698, '1981-12-03', 950, NULL, 30);
INSERT INTO emp VALUES(7902,'FORD', 'ANALYST' ,7566, '1981-12-03', 3000, NULL, 20);
INSERT INTO emp VALUES(7934,'MILLER', 'CLERK',7782,'1982-01-23', 1300, NULL, 10);

-- 1 安员工编号升序排列，不在10号部门工作的员工信息
select * from emp where (deptno != 10) order by empno asc;

-- 2.查询姓名第二个字母不是A,且薪水大于1000元的员工信息，按【年薪】降序排列。
select *, (ifnull(sal, 0)*12 + ifnull(comm, 0)) total_sal from emp where ename  not like '_A%' and sal >1000 order by (ifnull(sal, 0)*12 + ifnull(comm, 0)) desc;

-- 3.每个部门的平均薪水
select deptno, avg(sal)  as avl_sal from emp group by deptno;
select deptno, avg(sal)  as avl_sal from emp group by deptno order by avg(sal) desc;

-- 4.求每个部门的最高薪水
select deptno,max(sal) max_avg from emp group by deptno;

-- 5.求每个部门，每个岗位的最高薪水
select deptno,job,max(sal) max_avg from emp group by deptno, job order by deptno;


-- 6.求平均薪水大于2000的部门编号; 对分组之后的结果再进行筛选用having
select deptno, avg(sal) from emp group by deptno having avg(sal) > 2000 order by deptno;

-- 7.将部门平均薪水大于1500的部门编号列出来，按部门平均薪水降序排列
select deptno, avg(sal) from emp group by deptno having avg(sal) > 1500 order by avg(sal) desc;


-- 8. 选择公司中有奖金的员工姓名，工资
select ename, sal from emp where comm is not null;

-- 9.查询员工最高工资和最低工资
select max(sal) - min(sal) from emp;



##################################
# 正则表达式



