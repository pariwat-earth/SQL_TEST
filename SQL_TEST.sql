-- create by MySQL 
-- quasion 1 
SELECT 
	wo.AGREEMENT_NO,
    wo.OUTSTANDING_BALANCE,
    judetype.JUDGE_TYPE,
    case
		when wo.OUTSTANDING_BALANCE < 50000 then 1
        when wo.OUTSTANDING_BALANCE >= 50000 and judetype.JUDGE_TYPE not in (1,2) or judetype.JUDGE_TYPE is null then 2
        when wo.OUTSTANDING_BALANCE >= 50000 and judetype.JUDGE_TYPE in (1,2) then 3
        else ''
	end as 'Group',
    wo.AGE_OF_WRITE_OFF,
    wo.AUTO_TYPE_NAME
FROM sql_test.tb_data_wo wo
left join sql_test.tb_data_judetype judetype
on wo.AGREEMENT_NO  = judetype.AGREEMENT_NO
left join sql_test.tb_car_case car
on  wo.AGREEMENT_NO = car.AGREEMENT_NO
where car.CAR_CASE_DESC is NULL;

-- subquery for quation2-3
with sub as (SELECT 
	wo.COLLECTOR_CODE,
    wo.AGREEMENT_NO,
    wo.OUTSTANDING_BALANCE,
    judetype.JUDGE_TYPE,
	case
		when wo.OUTSTANDING_BALANCE < 50000 then 1
        when wo.OUTSTANDING_BALANCE >= 50000 and judetype.JUDGE_TYPE not in (1,2) or judetype.JUDGE_TYPE is null then 2
        when wo.OUTSTANDING_BALANCE >= 50000 and judetype.JUDGE_TYPE in (1,2) then 3
        else ''
	end as 'Group',
    wo.AGE_OF_WRITE_OFF,
    wo.AUTO_TYPE_NAME,
    case
		when wo.AUTO_TYPE_NAME = 'Motorcycle' and 
			wo.REPO_STATUS = 'W' and
            wo.AGE_OF_WRITE_OFF <= 1 and 
            wo.OUTSTANDING_BALANCE < 10000
            then 1500
            
		when wo.AUTO_TYPE_NAME = 'Motorcycle' and 
			wo.REPO_STATUS = 'W' and
            wo.AGE_OF_WRITE_OFF <= 1 and 
            wo.OUTSTANDING_BALANCE >= 10000 and wo.OUTSTANDING_BALANCE < 30000
            then 2000
            
		when wo.AUTO_TYPE_NAME = 'Motorcycle' and 
			wo.REPO_STATUS = 'W' and
            wo.AGE_OF_WRITE_OFF <= 1 and 
            wo.OUTSTANDING_BALANCE > 30000
            then 2500
            
		when wo.AUTO_TYPE_NAME = 'Motorcycle' and 
			wo.REPO_STATUS = 'W' and
            wo.AGE_OF_WRITE_OFF >= 1 and wo.AGE_OF_WRITE_OFF <= 3 and
            wo.OUTSTANDING_BALANCE < 10000
            then 2000
            
		when wo.AUTO_TYPE_NAME = 'Motorcycle' and 
			wo.REPO_STATUS = 'W' and
            wo.AGE_OF_WRITE_OFF >= 1 and wo.AGE_OF_WRITE_OFF <= 3 and 
            wo.OUTSTANDING_BALANCE >= 10000 and wo.OUTSTANDING_BALANCE < 30000
            then 2500
            
		when wo.AUTO_TYPE_NAME = 'Motorcycle' and 
			wo.REPO_STATUS = 'W' and
            wo.AGE_OF_WRITE_OFF >= 1 and wo.AGE_OF_WRITE_OFF <= 3 and 
            wo.OUTSTANDING_BALANCE > 30000
            then 3000
            
        when wo.AUTO_TYPE_NAME = 'Non Motorcycle' and 
			wo.REPO_STATUS = 'W' and
            wo.AGE_OF_WRITE_OFF <= 1 and 
            wo.OUTSTANDING_BALANCE < 100000
            then 2500
            
		when wo.AUTO_TYPE_NAME = 'Non Motorcycle' and 
			wo.REPO_STATUS = 'W' and
            wo.AGE_OF_WRITE_OFF <= 1 and 
            wo.OUTSTANDING_BALANCE >= 100000 and wo.OUTSTANDING_BALANCE < 300000
            then 3100
            
		when wo.AUTO_TYPE_NAME = ' Non Motorcycle' and 
			wo.REPO_STATUS = 'W' and
            wo.AGE_OF_WRITE_OFF <= 1 and 
            wo.OUTSTANDING_BALANCE > 300000
            then 3600
            
		when wo.AUTO_TYPE_NAME = 'Non Motorcycle' and 
			wo.REPO_STATUS = 'W' and
            wo.AGE_OF_WRITE_OFF >= 1 and wo.AGE_OF_WRITE_OFF <= 3 and
            wo.OUTSTANDING_BALANCE < 100000
            then 3000
            
		when wo.AUTO_TYPE_NAME = 'Non Motorcycle' and 
			wo.REPO_STATUS = 'W' and
            wo.AGE_OF_WRITE_OFF >= 1 and wo.AGE_OF_WRITE_OFF <= 3 and 
            wo.OUTSTANDING_BALANCE >= 100000 and wo.OUTSTANDING_BALANCE < 300000
            then 3600
            
		when wo.AUTO_TYPE_NAME = 'Non Motorcycle' and 
			wo.REPO_STATUS = 'W' and
            wo.AGE_OF_WRITE_OFF >= 1 and wo.AGE_OF_WRITE_OFF <= 3 and 
            wo.OUTSTANDING_BALANCE > 300000
            then 4100
        else ''
	end as Incentive
FROM sql_test.tb_data_wo wo
left join sql_test.tb_data_judetype judetype
on wo.AGREEMENT_NO  = judetype.AGREEMENT_NO
where wo.REPO_STATUS = 'W'
)

-- quasion 2
select * from sub;

-- quasion 3
select 
g3.Group,
COLLECTOR_CODE,
max(Incentive) Incentive
from sub g3
group by g3.Group;