/* to demonstrate t-sql delighters */



use tempdb
go
/*Declaration and initialization of Variable */

			Declare @Variable Varchar(10) ='aaa' 

			--<strong>Earlier vrsion we had to do this in two steps.</strong>

			Declare @Variable Varchar(10)
			Set @Variable='aaa' OR Select @Variable='aaa'

			--Small but very effective
			
/* SQL 2005/ 2000 way of Assigning */

		Declare @Counter int
		Set @Counter =1

		Begin 
		Print @Counter
		Set @Counter =@Counter +1
				Print @Counter
		End

/*SQL 2008 way of Assigning */


		Declare @Counter int=1

		Begin 
		Print @Counter
		Set @Counter +=1
				Print @Counter
		End

/*Row Constructors */

Create table test (col int, name varchar(10))
insert test values (1,'aa'),(2,'bb'),(3,'cc')
select *from test;

/* drop the table */
Drop table test;
 
 