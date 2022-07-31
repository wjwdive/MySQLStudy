# 控制流函数

-- 1. if(expr, v1, v2);

select if(5 > 3, '大于', '小于');

use mydb3;
select *, if(score >= 85, '优秀','及格') flag from score;

# 2. ifnull 
select ifnull(5, 0);
select ifnull(NULL, 0);

use testdb1;
select *, ifnull(comm, 0) comm_flag from emp;

# isnull 
select isnull(0);  -- 0
select isnull(null); -- 1

-- nullif
select nullif(11, 11); -- 一样就返回null

-- case when 
/*
case express 
	when condition1 then result1
	when condition2 then result2
*/


select 
	case 3
		when 1 then '你好'
		when 2 then '他好'
		when 3 then '我也好'
		else 
			'其他'
	end as info;
	
	
use mydb4; 
-- 创建订单表
create table orders(
 oid int primary key, -- 订单id
 price double, -- 订单价格
 payType int -- 支付类型(1:微信支付 2:支付宝支付 3:银行卡支付 4：其他)
);
 
insert into orders values(1,1200,1);
insert into orders values(2,1000,2);
insert into orders values(3,200,3);
insert into orders values(4,3000,1);
insert into orders values(5,1500,2);
 

-- 方式1
select *, 
	case payType
		when 1 then '微信支付'
		when 2 then '支付宝支付'
		when 3 then '银行卡支付'
		else 
			'其他方式支付'
	end as payTypeStr
from orders;

-- 方式2
select *,
	case
		when payType = 1 then '微信支付'
		when payType = 2 then '支付宝支付'
		when payType = 3 then '银行卡支付'
	else 
		'其他方式支付'
	end as payTypeStr
from orders;


	
	