
create application role [FMLAAccessRead]
	with password = 'p@ssm0rd!_xlkchdook';
go

create application role [FMLAAccessReadWrite]
	with password = 'p@ssm0rd!_oiwejflkjos';
go

grant select on fmlahistory to [FMLAAccessRead];
grant select on fmlahistory to [FMLAAccessReadWrite];
go

grant update on fmlahistory to [FMLAAccessReadWrite];
go