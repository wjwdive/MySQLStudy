-- DML练习
-- 创建employee表
use school;
CREATE TABLE IF NOT EXISTS employee(
id INT,
name VARCHAR(20),
gender VARCHAR(20),
salary DOUBLE
);

-- 2.插入数据
/**
	1,'张三','男',2000
	2,'李四','男',3000
	3,'王五','女',4000
*/
INSERT INTO employee(id, name, gender, salary) VALUES(1, '张三', '男', 2000);
INSERT INTO employee VALUES(2,'李四','男',3000),(3,'王五','女',4000);

-- 3.修改表数据
-- 3.1 将所有员工的薪水修改为5000元。
UPDATE employee SET salary = 5000;
-- 3.2 将姓名为‘张三’的员工薪资修改为3000
UPDATE employee SET salary = 3000 WHERE name = '张三';
-- 3.3 将姓名为李四的员工薪水修改改为 4000,性别改为女
UPDATE employee SET salary = 4000, gender = '女' WHERE name = '王五';
-- 3.4 将王五的工资在原来的基础上增加1000
UPDATE employee SET salary = salary + 1000 WHERE name = '王五';

