Select convert(sysname,'') as databasename,* into sys_objects from  sys.objects where 1 = 2
Insert into sys_objects 
exec sp_MSforeachdb 'Select ''?'',* from ?.sys.objects'
Alter table sys_objects
ADD  iVal int identity(1,1) PRIMARY KEY   
Select * from   sys_objects 
 
