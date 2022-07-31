# MySQL 函数
/*
分类：
1.聚合函数
2.数学函数
3.字符串函数
4.日期函数
5.控制流函数
6窗口函数（mysql 8.0 新特性）
*/

# 1.聚合函数 count,sum,min,max,avg 还有新的 group_concat
/*
# group_concat语法格式
# group_concat([distinct] 字段名 order by 排序字段 asc/desc] [separator '分隔符']) 
1. 可以使用distinc 排除重复值
2. 如果需要对结果中的值进行排序，可以使用order by 子句
3. separator 是一个字符串值，默认为逗号
*/



create database mydb4;
use mydb4;
 
create table emp(
	emp_id int primary key auto_increment comment '编号',
	emp_name char(20) not null default '' comment '姓名',
	salary decimal(10,2) not null default 0 comment '工资',
	department char(20) not null default '' comment '部门'
);
 
insert into emp(emp_name,salary,department) 
values
('张晶晶',5000,'财务部'),
('王飞飞',5800,'财务部'),
('赵刚',6200,'财务部'),
('刘小贝',5700,'人事部'),
('王大鹏',6700,'人事部'),
('张小斐',5200,'人事部'),
('刘云云',7500,'销售部'),
('刘云鹏',7200,'销售部'),
('刘云鹏',7800,'销售部');

-- 1.将所有员工的名字合并成一行
select group_concat(emp_name) from emp;
select department, group_concat(emp_name separator ';') from emp group by department;
select department, group_concat(emp_name order by salary ASC separator ';') from emp group by department; -- asc, desc



# 2.数学函数

-- 求绝对值
select abs(-10);
select abs(10);

-- 向上取整
select ceil(1.1); -- 2
select ceil(1.0) -- 1

-- 向下取整
select floor(1.1); -- 1
select floor(1.9); -- 1

-- 去列表的最大值
select greatest(1,2,3); -- 3

-- 取列表的最小智
select least(1,2,3) -- 1
-- max 函数不可以对列表使用，他是对一张表里某个属性的所有值取最大值
# select max(1,2,3); -- 3

-- 取模，求余数
select mod(5, 2); -- 1

-- 取x的y次方
select (2, 3); -- 8

-- rand，取随机数
select rand(); -- 0-1 之间的随机数

-- 取随机数， 0-100的整数
select floor(rand()*100);

-- 将小数四舍五入取整
select round(3.1415);
-- 保留小数点后3位，也四舍五入了
select round(3.1415, 3); -- 3.142

use mydb2;
# 保留两位小数,之前遇到的一个double精度的问题
select category_id, round(avg(price),2) from product group by category_id;

-- 将小数直接截取到指定位数
select truncate(3.1415, 3); -- 3.141

####################
# 3.字符串函数
-- 1.获取字符串字符个数
select char_length('hello'); -- 5
select char_length('你好吗'); -- 3

-- 2.length 取长度，返回的单位是字节
select length('hello'); -- 5
select length('你好吗'); -- 9

-- 3.字符串合并
# 3.1 caoncat
select concat('hello', 'world');

# 3.2 concat (字段，字段)from table  返回一个表中的 两个自动拼接后的结果
select concat(c1, c2) from table_name;

# 3.3 concat_ws 指定分隔符进行字符串合并
select concat_ws('_', 'hello', 'world'); -- hello_world

-- 4. 返回字符在列表中的第一次出现的位置  field()
select field('aaa', 'aaa', 'bbb', 'ccc'); -- 1
select field('bbb', 'aaa', 'bbb', 'ccc'); -- 2

-- 5.去除字符串左边、右边、两边的空格  ltrim(), rtrim(), trim()
select ltrim('   aaa')；	-- 'aaa'
select rtrim('bbb   ')；	-- 'bbb'
select trim('   ccc   '); -- 'ccc'

-- 6. mid()  字符串截取
select mid('hello world', 7, 5); -- 从第七个字符串开始，向后截取5个字符  world

-- 7.获取字符串a 在字符串中出现的位置
select position('abc' in 'habcello world');

-- 8. replace, 字符串替换select replace('hello jarvis', 'jarvis', 'marvis');

-- 9. reverse ,字符串反转
select reverse('REVERSE');

-- 10. 返回字符串的后n个字符
select right('hello', 3); -- llo

-- 11. 字符串比较
select strcmp('hello', 'world'); -- 只比较字符串在字典中出现的顺序

-- 12.字符串截取
select substr('hello', 2, 3);

-- 13.字符串转大小写 ucase(s), upper(s), lcase(s), lower(s);
select UPPER('hello'); -- HELLO
select ucase('world'); -- WORLD

select lower('COME ON'); -- come on
select lcase('COME ON'); -- come on



use testdb1;
-- 获取所有人出生的年份
select ename, substr(hiredate, 1, 4) from emp;





