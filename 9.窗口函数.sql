# 窗口函数
/*
回顾聚合函数：聚合函数是对一组数据计算后返回单个值，
非聚合函数一次只会处理一行数据。
窗口聚合函数在行记录上计算某个字段的结果时，可将窗口范围内的数据输入到聚合函数中，并不改变行数

1.序号函数
2.分布函数
3.前后函数
4.头尾函数
5.其他函数

开窗聚合函数：SUM,MAX,MIN,AVG

*/

# 窗口函数语法
/*
window_function (expr) OVER (
	PARTITION BY ...
	ORDER BY ...
	frame_clause
);
*/

-- 1.序号函数 ROW_NUMBER(), RANK(),DENSE_RANK(), 可以用来实现分组排序，并添加序号。
/*
ROW_NUMBER() | RANK() | DENSE_RANK() over(
	partition by ...
	order by
);


*/


use mydb4; 
create table employee( 
   dname varchar(20), -- 部门名 
   eid varchar(20), 
   ename varchar(20), 
   hiredate date, -- 入职日期 
   salary double -- 薪资
); 

insert into employee values('研发部','1001','刘备','2021-11-01',3000);
insert into employee values('研发部','1002','关羽','2021-11-02',5000);
insert into employee values('研发部','1003','张飞','2021-11-03',7000);
insert into employee values('研发部','1004','赵云','2021-11-04',7000);
insert into employee values('研发部','1005','马超','2021-11-05',4000);
insert into employee values('研发部','1006','黄忠','2021-11-06',4000);

insert into employee values('销售部','1007','曹操','2021-11-01',2000);
insert into employee values('销售部','1008','许褚','2021-11-02',3000);
insert into employee values('销售部','1009','典韦','2021-11-03',5000);
insert into employee values('销售部','1010','张辽','2021-11-04',6000);
insert into employee values('销售部','1011','徐晃','2021-11-05',9000);
insert into employee values('销售部','1012','曹洪','2021-11-06',6000);

-- 给每个部门的员工按照薪资排序，并给出排名
select 
dname, ename, salary, 
row_number() over(partition by dname order by salary desc) as rn1,
rank() over(partition by dname order by salary desc) as rn2,
dense_rank() over(partition by dname order by salary desc) as rn3
from employee;

# row_number(), 无并列，无人数限制的排序，用这个。
# rank(), 有并列，排名只取3个人。但有两个并列第一的，第一名和第二名都是第1， 第1， 第三个人第三名，没有第二名
# dense_rank(), 有并列，并且序号不会被跳过


-- 分组求topN
# 直接加一个where rn1 <= 3条件语句是不行的。from --> where -> select, 所以执行where的时候，select中还没有把rn1求出来。
/* 错的
select 
dname, ename, salary, 
row_number() over(partition by dname order by salary desc) as rn1,
rank() over(partition by dname order by salary desc) as rn2,
dense_rank() over(partition by dname order by salary desc) as rn3
from employee
where rn1 <= 3;

*/
# 嵌套一层子查询，子查询中先算出来 rn1,  外层就可以用来做条件判断了
select * from 
(
select 
dname, ename, salary, 
row_number() over(partition by dname order by salary desc) as rn1,
rank() over(partition by dname order by salary desc) as rn2,
dense_rank() over(partition by dname order by salary desc) as rn3
from employee

)t 
where rn1 <= 3;


# 对所有员工进行全局排序，不分组。不加partition by
select * from 
(
select 
dname, ename, salary, 
row_number() over(order by salary desc) as rn1,
rank() over(order by salary desc) as rn2,
dense_rank() over(order by salary desc) as rn3
from employee

)t 
where rn1 <= 3;




# 聚合函数和开窗函数一起，实现每行累加
select 
	dname, 
	ename, 
	salary, 
	sum(salary) 
	over(partition by dname order by hiredate) as c1 
from employee;


# 和上一行查询，区别，排序，sum会计算分区后 一个部门的所有薪资之和  可以计算每个人的薪资占部门薪资比例
select 
	dname, 
	ename, 
	hiredate,
	salary, 
	sum(salary) over(partition by dname ) as c1 -- 如果没有order by， 默认把分组内的所有数据进行sum操作
from employee;

# rows between unbounded preceding and current row  | 从第一行加到当前行 | 前缀和
select 
	dname, 
	ename, 
	hiredate,
	salary, 
	sum(salary) over(partition by dname order by hiredate rows between unbounded preceding and current row ) as c1 -- 
from employee;

# rows between unbounded preceding and current row | 前3行到当前行  | 范围前缀和
select 
	dname, 
	ename, 
	hiredate,
	salary, 
	sum(salary) over(partition by dname order by hiredate rows between 3 preceding and current row) as c1 -- 
from employee;

# rows between 3 preceding and 1 following  | 当前行前3行到当前行后一行之间
select
	dname,
	ename,
	hiredate,
	salary,
	sum(salary) over(partition by dname order by hiredate rows between 3 preceding and 1 following) as c1
from employee;


#rows between current row and unbounded following | 后缀和
select  
 dname,
 ename,
 salary,
 sum(salary) over(partition by dname order by hiredate   rows between current row and unbounded following) as c1 
from employee;





###########################
-- 2.分布函数  CUME_DIST
# 用途： 分组内小于、等于当前rank值得行数/ 分组内总行数
# 应用场景：查询小于当前薪资salary 的比例
/*
select
	dname,
	ename,
	salary,
	cume_dist() over(order by salary) as rn1,
	cume_dist() over(partition by dept order by salray) as rn2
from employee;
*/
use mydb4;

# 行数比例，小于等于当前员工salary的行数比上总行数， 比上本组内总行数
select
	dname,
	ename,
	salary,
	cume_dist() over(order by salary) as rn1, -- 没有partition函数
	cume_dist() over(partition by dname order by salary) as rn2
from employee;

# 2.2 PERCENT_RANK()
# 用途：每行按照公式(rank-1) / (rows-1)进行计算。其中，rank为RANK()函数产生的序号，rows为当前窗口的记录总行数 
# 应用场景：不常用

select 
 dname,
 ename,
 salary,
 rank() over(partition by dname order by salary desc ) as rn,
 percent_rank() over(partition by dname order by salary desc ) as rn2
from employee;


# 3. 前后函数 LAG , LEAD
# 用途： 返回位于当前行的前N行(LAG(expr, n)),或后N行(LEAD(expr, n))的expr的值
# 应用场景：查询前1名同学的成绩和当前同学成绩的差

-- lag用法
select 
 dname,
 ename,
 hiredate,
 salary,
 lag(hiredate, 1, '2000-01-01') over(partition by dname order by hiredate) as last_1_time, -- lag 三个参数(列名，前几行， 默认值)，对于hiredate列 前一行的值和本行的值进行比较，前一行没有值，按'2001-01-01'为默认值 | last_1_time 应该是上一行的值，首行没有上一行，使用默认值
 lag(hiredate, 2) over(partition by dname order by hiredate) as last_2_time -- lag 两个参数，(列名，前几行) 把此行的前2行放到本行，依次类推
from employee;

-- lead 用法
-- lead的用法 本行后第几行， 移动到和此行同一行
select 
 dname,
 ename,
 hiredate,
 salary,
 lead(hiredate,1,'2000-01-01') over(partition by dname order by hiredate) as last_1_time,
 lead(hiredate,2) over(partition by dname order by hiredate) as last_2_time 
from employee;

######## t
# 4.头尾函数 FIRST_VALUE(expr), LAST_VALUE(expr)
# 用途： 返回第一个FIRST_VALUE 或 最后一个 LAST_VALUE 表达式expr的值
# 应用场景：截止到当前，按照日期排序查询第一个入职和最后一个入职职工的薪资

-- 注意,  如果不指定ORDER BY，则进行排序混乱，会出现错误的结果
select
  dname,
  ename,
  hiredate,
  salary,
  first_value(salary) over(partition by dname order by hiredate) as first,
  last_value(salary) over(partition by dname order by  hiredate) as last  -- 到目前为止最后一个入职职工的薪资。因为是按薪资排序，所以和本行薪资相同
from  employee;

################
# 5.NTH_VALHE(expr), NTILE(n)
# HTH_VALUE(): 返回窗口中第n个expr的值，expr可以是表达式，也可以是列名
# 应用场景：截止到当前薪资，显示每个员工的薪资中排名第2 或者第3的薪资

-- 查询每个部门截止目前薪资排在第二和第三的员工信息
select 
  dname,
  ename,
  hiredate,
  salary,
  nth_value(salary,2) over(partition by dname order by hiredate) as second_score,
  nth_value(salary,3) over(partition by dname order by hiredate) as third_score
from employee;


# NTILE(N)

-- 用途：将分区中的有序数据分为n个等级，记录等级数
-- 应用场景：将每个部门员工按照入职日期分成3组

-- 根据入职日期将每个部门的员工分成3组
select 
  dname,
  ename,
  hiredate,
  salary,
ntile(3) over(partition by dname order by  hiredate  ) as rn 
from employee;

-- 取出每个部门的第一组员工
select *
from (
select 
  dname,
  ename,
  hiredate,
  salary,
ntile(3) over(partition by dname order by  hiredate  ) as rn 
from employee

) t
where t.rn = 1;



