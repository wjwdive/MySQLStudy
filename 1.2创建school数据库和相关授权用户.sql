## 创建school  数据库
## CREATE DATABASE school if not EXISTS school; //不值为何无法正确执行
CREATE DATABASE school;
## 创建用户

## % 代表不限制ip
## localhost 代表只能本地访问
## 192.168.1.1 代表只能192.168.1.1 这个固定ip访问
create user 'testuser'@'%' identified by 'testuser';

## all privileges 代表所有权限
## select,insert,update,delete,create,drop 代表具体权限
grant all privileges on test_database.* to 'testuser'@'%';

## 刷新权限
flush privileges;

# mysql 修改密码
ALTER USER 'testuser'@'%' IDENTIFIED WITH mysql_native_password BY 'testuser';
flush privileges; 
