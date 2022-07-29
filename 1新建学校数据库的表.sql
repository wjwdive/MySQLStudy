# 在school 数据库中创建一个学生表
USE school; -- 说明使用的数据库
# 创建一个学生表
CREATE TABLE IF NOT EXISTS student (
	sid INT,
	name VARCHAR(20),
	gender VARCHAR(20),
	age INT,
	birth DATE,
	address VARCHAR(20)
);

# 查看当前数据库的所有表
SHOW TABLES;

# 4.查看指定表的创建语句
SHOW CREATE TABLE student;

# 5.查看表结构
DESC student;

# 5.删除表
DROP TABLE student;

# 对标的结构的常用操作-修改表结构的格式
# 1. 修改表-添加列
# 语法格式 : ALTER TABLE 表名 ADD 列名 类型(长度) [约束];
ALTER TABLE student ADD dept VARCHAR(20);

# 2.修改列名和类型
# 语法格式 ： ALTER TABLE 表名 CHANGE 原列名 新列名 类型(长度) [约束];
ALTER TABLE student CHANGE dept department VARCHAR(30);

# 3.修改表删除列 ：ALTER TABLE 表名 DROP 列名;
ALTER TABLE student DROP department;

# 4.修改表名： rename table 表名 to 新表名
RENAME TABLE stu to student;

-- DML

# 数据库基本操作DML：数据操作语言， 全称 Data Manipulation Language。用来对数据库中标的记录进行更新
# 插入：insert, 删除 delete, 更新： update

# 1.插入数据
# 语法格式： insert into 表(列名1， 列名2， 列名3...) VALUES (值1, 值2, 值3... ) # 向表中插入某些列
# insert into 表values(值1, 值2, 值3...)  # 向表中插入所有列

# 例如：
INSERT INTO student(sid, name, gender, age, birth, address, score) VALUES (1001, 'Jarvis', '男', 18, '1996-12-23', '北京', 90.0);

# 一次添加多条数据
INSERT INTO 
student(sid, name, gender, age, birth, address, score) 
VALUES 
(1002, '张三', '男', 19, '1995-12-23', '北京', 80.0),
(1003, '李四', '男', 20, '1994-12-23', '上海', 88.0),
(1004, '王五', '女', 17, '1997-12-23', '深圳', 92.0);

# 格式2，不指定列名，需要把所有列的值都设定好值。
# INSERT INTO 表 VALUES(1004, '王五', '女', 17, '1997-12-23', '深圳', 92.0);
INSERT INTO student VALUES(1005, '赵六', '男', 20, '1994-11-11', '郑州', 93);

# 2.UPDATE 修改数据
# 将所有学生的地址修改为重庆
UPDATE student set address = '重庆';

# 将sid 为1004的学生的地址修改为杭州
UPDATE student SET address = '杭州' WHERE sid = 1004; 
# UPDATE student SET address = '杭州' WHERE sid > 1004;   # 可以使用> 判断


# 将sid 为1005的学生的地址修改为北京，成绩修改为100
UPDATE student SET address = '北京', score = 100 WHERE sid = 1005;

# 3.删除数据
-- 语法格式： DELETE FROM 表名 [WHERE 条件];
-- TRUNCATE TABLE 表名 或者 TRUNCATE 表名

# 删除sid 为 1004的学生数据
DELETE FROM student(sid) WHERE sid = 1004;

-- 删除表所有数据
DELETE FROM student;

-- 清空表数据
TRUNCATE TABLE student;
-- 或者
TRUNCATE student;

-- DELETE 和 TRUNCATE 的不同，事务支持的不同。






