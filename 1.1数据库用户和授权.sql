-- 目标： 创建一个school数据库
-- 1、查看数据库版本号
select VERSION();
-- 2、创建数据库school
create database school;

-- 3、创建用户并授权ip
#创建用户testuser，仅限本机访问，密码123456
create user 'testuser'@'localhost' identified by '0000';
#创建用户testuser，仅限192.168.10.52访问，密码123456
create user 'testuser'@'192.168.10.52' identified by '0000';
#创建用户testuser，所有IP可以访问，密码123456
create user 'testuser'@'%' identified by '0000';

-- 4、创建用户
#将数据库school下的所有（*）授权给testuser
grant all privileges on school.* to 'testuser'@'%';
#最后刷新权限
flush privileges;






