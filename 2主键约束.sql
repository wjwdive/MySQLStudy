# mysqly约束
# 1.概念 约束就是对表中数据的限制
# 2.作用 表在设计的时候胶乳约束的目的就是为了保证记录的完整性和有效性，比如用户表有些列的值不能为空(手机号)，有些列的值不能重复（身份证号，id）
# 3.分类
/*
主键约束， primary key, PK
自增长约束，auto_increment
非空约束，not null
唯一性约束， unique
默认约束 default
零填充约束 zerofill
外键约束 foreign key, FK 
*/

# 概念， 
/*
1.mysql 的主键约束是一个列或者多个列的组合，其值能唯一标识表中的每一行，方便在RDBMS中尽快找到某一行
2. 主键的约束相当于唯一约束+非空约束的组合， 主键约束列不允许重复，也不允许出现空值。
3. 每个表最多只允许一个主键
4. 主键约束的关键字是： primary key
5. 当创建主键约束时，系统默认会在所在的列和组合列上建立对应的唯一索引。
*/

# 操作
/*
添加单列主键
添加多列联合主键
删除主键
*/

# 操作
# 1. 创建单列主键
-- 创建单列主键有两种方式，一种是在定义字段的同时指定主键，一种是定义完字段后指定主键
# 方式1
-- CREATE TABLE 语句中，通过 PRIMARY KEY 关键字来指定主键。
-- 在定义字段的同时指定主键，语法格式如下
/*
CREATE TABLE 表名(
	...
	<字段名> <数据类型> PRIMARY KEY
	...
);
*/


CREATE TABLE emp1(
	eid INT PRIMARY KEY,
	name VARCHAR(20),
	depId INT,
	salary DOUBLE
);

# 方式2
-- 在定义完字段后指定主键
CREATE TABLE 表名(
	...
	[constraint <约束名>] PRIMARY KEY [字段名];
);

CREATE TABLE emp2(
	eid INT,
	name VARCHAR(20),
	depId INT,
	salary DOUBLE,
	CONSTRAINT pk1 PRIMARY KEY(eid) -- CONSTRAINT pk1 可以省略
);


-- 主键的作用
INSERT INTO emp2(eid, name, depId, salary) VALUES (1001, '张三', 10, 5000);
INSERT INTO emp2(eid, name, depId, salary) VALUES (1001, '李四', 11, 5000);
# > 1062 - Duplicate entry '1001' for key 'emp2.PRIMARY'

# 2. 如何添加联合主键
# 操作-添加多列主键（联合主键）
# 所谓的联合主键，就是这个主键是由一张表中的多个字段组成。
/*
 注意： 
 1. 当主键是由多个字段组成时，不能直接在字段名后面生命主键约束
 2. 一张表只能有一个主键，联合主键也是一个主键
 语法
 CREATE TABLE 表名(
	...
	PRIMARY KEY(字段名1, 字段名2, ..., 字段名n)
 );
实现：

*/

CREATE TABLE emp3(
	name VARCHAR(20),
	deptId INT,
	salary DOUBLE,
	CONSTRAINT pk2 PRIMARY KEY(name, deptId) -- CONSTRAINT pk2 可省略
);

INSERT INTO emp3 VALUES('张三', 10, 4800);
INSERT INTO emp3 VALUES('张三', 10, 4800); -- > 1062 - Duplicate entry '张三-10' for key 'emp3.PRIMARY'
INSERT INTO emp3 VALUES('张三', 20, 4800);  -- 不报错

INSERT INTO emp3 VALUES(NULL, 20, 4800);  -- > 1048 - Column 'name' cannot be null
INSERT INTO emp3 VALUES('李四', NULL, 4800);  -- > 1048 - Column 'deptId' cannot be null
# 联合主键的任意 主键列都不能为空

# 3.通过修改表结构添加主键
/*
主键约束不禁可以在创建表的同时创建，也可以在修改表时添加
语法：
CREATE TABLE 表名(
	...
);
ALTER TABLE <表名> ADD PRIMARY KEY(字段列表);
*/
CREATE TABLE emp4(
	eid INT,
	name VARCHAR(20),
	deptId INT,
	salary DOUBLE
);
ALTER TABLE emp4 ADD PRIMARY KEY (eid);


CREATE TABLE emp5(
	eid INT,
	name VARCHAR(20),
	deptId INT,
	salary DOUBLE
);
ALTER TABLE emp5 ADD PRIMARY KEY (name, deptId);

# 4.删除主键
/*
一个表不需要主键约束时，可以删除
# 删除单列主键：
ALTER TABLE emp1 DROP PRIMARY KEY;

# 删除多列主键：
ALTER TABLE emp5 DROP PRIMARY KEY;

*/


# 自增长约束
/*
	在MySQl 中，当主键定义为自增长后，这个主键的值就不再需要用户输入数据了，而由数据库根据定义自动赋值
	每增加一条，主键会自动以相同的步长进行增长。
	通过给字段添加auto_)increment 属性来实现自增长
	语法：
	字段名 数据类型 auto_increment
*/
CREATE TABLE t_user1(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20)
);

INSERT INTO t_user1 VALUES(NULL, '张三'); -- 默认从1 开始增长

-- 指定自增长的初始值
-- 方式1，创建表时指定
CREATE TABLE t_user2(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20)
)AUTO_INCREMENT = 100;

INSERT INTO t_user2 VALUES(NULL, '李四'); -- 100 
INSERT INTO t_user2 VALUES(NULL, '李四'); -- 101


-- 方式二，创建表后指定
CREATE TABLE t_user2(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20)
)AUTO_INCREMENT = 100;

ALTER TABLE t_user3 AUTO_INCREMENT = 1000;
INSERT INTO t_user3 VALUES(NULL, '王五'); -- 1000
INSERT INTO t_user3 VALUES(NULL, '王五'); -- 1001

# delete 和 truncate 在删除后自增列的变化
-- delete数据之后自动增长从断点开始
-- truncate 数据之后自动从默认起始值开始

# https://www.bilibili.com/video/BV1iF411z7Pu?p=33&spm_id_from=pageDriver&vd_source=2b60f92b6a33b739768b583e0e256719
# 2022/7/25 2:33 学习到P33


