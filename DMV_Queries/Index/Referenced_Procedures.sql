SELECT *
frOM sys.dm_sql_referencing_entities ('dbo.TestingPMO_Forecast_Rates_Revenue','OBJECT')
where referencing_entity_name like '%forecast%' 
and referencing_entity_name not like'%new%' 
and referencing_entity_name not like '%rewrite%' and referencing_entity_name not like '%temp%' 
--and referencing_entity_name not like '%productiondb%' and referencing_entity_name not like '%sprint3%'
and referencing_entity_name not like '%v1%'
and referencing_entity_name not like '%bkp%'
