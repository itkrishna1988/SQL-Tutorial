Declare @condition_id int

EXEC msdb.dbo.sp_syspolicy_add_condition 
@name=N'Check table schema', @description=N'', 
@facet=N'ITableOptions', 
@expression=N'<Operator>
  <TypeClass>Bool</TypeClass>
  <OpType>NE</OpType>
  <Count>2</Count>
  <Attribute>
    <TypeClass>String</TypeClass>
    <Name>Schema</Name>
  </Attribute>
  <Constant>
    <TypeClass>String</TypeClass>
    <ObjType>System.String</ObjType>
    <Value>dbo</Value>
  </Constant>
</Operator>', @is_name_condition=0, 
@obj_name=N'', 
@condition_id=@condition_id OUTPUT
Select @condition_id
GO

Declare @object_set_id int

EXEC msdb.dbo.sp_syspolicy_add_object_set 
@object_set_name=N'User tables must use non dbo schema_ObjectSet', 
@facet=N'ITableOptions', 
@object_set_id=@object_set_id OUTPUT
Select @object_set_id

Declare @target_set_id int

EXEC msdb.dbo.sp_syspolicy_add_target_set 
@object_set_name=N'User tables must use non dbo schema_ObjectSet', 
@type_skeleton=N'Server/Database/Table', 
@type=N'TABLE', 
@enabled=True, 
@target_set_id=@target_set_id OUTPUT
Select @target_set_id

EXEC msdb.dbo.sp_syspolicy_add_target_set_level 
@target_set_id=@target_set_id, 
@type_skeleton=N'Server/Database/Table', 
@level_name=N'Table', @condition_name=N'', 
@target_set_level_id=0

EXEC msdb.dbo.sp_syspolicy_add_target_set_level 
@target_set_id=@target_set_id, 
@type_skeleton=N'Server/Database', 
@level_name=N'Database', 
@condition_name=N'', 
@target_set_level_id=0


GO

Declare @policy_id int
EXEC msdb.dbo.sp_syspolicy_add_policy 
@name=N'User tables must use non dbo schema', 
@condition_name=N'Check table schema', 
@policy_category=N'', 
@description=N'', 
@help_text=N'', 
@help_link=N'', 
@schedule_uid=N'00000000-0000-0000-0000-000000000000', 
@execution_mode=1, 
@is_enabled=False, 
@policy_id=@policy_id OUTPUT, 
@root_condition_name=N'', 
@object_set=N'User tables must use non dbo schema_ObjectSet'
Select @policy_id
GO


