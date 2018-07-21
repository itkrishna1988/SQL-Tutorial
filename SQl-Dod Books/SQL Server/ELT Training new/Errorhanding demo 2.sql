-- @@Error execption hadling method and drawback
-- If statement reset the pervious @@Error Value
Select 1/0 
if @@ERROR<>0
select 'Current @@Error value ='+ str(@@ERROR)
go

--Try /catch


Begin try
	 
		Select 1/0 
	End Try
begin catch
	Select 'Division by 0 Exception Occured and exception caught' 
End Catch	

-- catching specific exception

Begin try
	 
		Select CONVERT(int , 'abc') as exception
	End Try
begin catch
	If ERROR_NUMBER() =245
	Select ' Conversion error happend : Error number :'+str(ERROR_NUMBER())
	else
	Select ERROR_NUMBER() as error_number
End Catch	

-- Handling deadlock using Try/catch

Declare @retry int =3
 
While @retry>0
Begin

		Begin try
			 
				-- Put the deadlock prone code here
			End Try
		begin catch
			If ERROR_NUMBER() =1205
				Begin
				Set @retry=@retry-1
					If @retry=0
						Raiserror ('Could not complete transaction',16,1)
				ENd
			
			else
				Begin
							Raiserror ('Non Deadlock error happend',16,1)
							Set @retry=0
				End 
			 
		End Catch
End		

truncate table teststat
select *from teststat


-- Statement level excption in a transaction. WIll have inconsistent data
begin tran
insert teststat select 'a'
Select 1/0
insert teststat select '1'
commit tran

-- Batch termination exception in a transaction. WIll not have inconsistent data
begin tran
insert teststat select 'a'
Select CONVERT(int , 'abc') as exception
insert teststat select '1'
commit tran

-- using xact_abort

Set xact_abort on
begin tran
insert teststat select 'a'
Select 1/0
insert teststat select '1'
commit tran
