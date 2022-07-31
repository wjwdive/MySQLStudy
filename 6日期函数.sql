-- 日期函数
-- 1. 获取时间戳
select unix_timestamp(); -- 毫秒值

-- 2.将一个日期字符串转为毫秒值
select unix_timestamp('2022-07-30 12:09:10'); 

-- 3.将时间戳毫秒值转为指定格式的日期
select from_unixtime(1659154150, '%Y-%m-%d %H:%i:%s');

-- 4.获取当前的年月日
select curdate();  -- 年月日
select current_date(); -- 年月日

-- 5.获取当前的时分秒
select curtime();
select current_time(); -- 时分秒

-- 6.获取年月日和时分秒
select CURRENT_TIMESTAMP();

-- 7.从日期字符串中获取年月日
select date('2022-07-30 12:14:01');

-- 8.获取日期之间的插值 datediff
select datediff('2022-07-30', '1989-02-12');

-- 9.获取事件之间的插值 秒级的插值 timediff
select timediff('2022-07-30 12:14:01', '2022-08-11 12:14:01');  -- 前面减去后面  288:00:00

-- 10.DATE_FORMAT(date,format)
select date_format('2022/7/30 12:14:1', '%Y-%m-%d %H:%i:%s');

-- 11.将字符串转为日期
select str_to_date('2022-07-30 12:14:01', '%Y-%m-%d %H:%i:%s');

-- 12.将日期进行减法。 日期向前跳转
select date_sub('2022-07-10', interval 2 day);  --  2022-07-08
select date_sub('2022-07-10', interval 2 month); -- 2022-05-10

--  13.将日期进行加法， 日期向后跳转
select date_add('2022-07-10', interval 2 day);		-- 2022-07-12 
select date_add('2022-07-10', interval 2 month); -- 2022-09-10

-- 14.从日期中获取小时, 时分秒
select extract(year from '2022-07-30 12:39:01');
select extract(month from '2022-07-30 12:39:01');
select extract(day from '2022-07-30 12:39:01');
select extract(hour from '2022-07-30 12:39:01');
select extract(minute from '2022-07-30 12:39:01');
select extract(second from '2022-07-30 12:39:01');

-- 15.获取给定日期所在月的最后一天
select last_day('2022-07-30 12:39:01');

-- 16.获取指定年数和天数的日期
select makedate('2022',200);

-- 17.根据日期获取年月日，时分秒
select year('2022-07-30 12:39:01');
select quarter('2022-07-30 12:39:01');
select month('2022-07-30 12:39:01');
select week('2022-07-30 12:39:01');
select day('2022-07-30 12:39:01');
select hour('2022-07-30 12:39:01');
select minute('2022-07-30 12:39:01');
select second('2022-07-30 12:39:01');

select monthname('2022-07-30 12:39:01'); -- july
select dayname('2022-07-30 12:39:01');  -- 星期六

select DAYOFWEEK('2022-07-30 12:39:01');  -- 一周的第几天，周日为第一天
select DAYOFMONTH('2022-07-30 12:39:01');	-- 一个月的第几天 1号返回1
select DAYOFYEAR('2022-07-30 12:39:01'); -- 211，一年的第几天

-- YEARWEEK(date, mode)  返回年份级第几周，mode 为0， 表示周日是一周的第一天，mode 为1，表示周一是一周的第一天

select yearweek('2022-07-31', 0)  -- 202231, 2022年的第31周
select yearweek('2022-07-31', 1)  -- 202230, 2022年的第30周











