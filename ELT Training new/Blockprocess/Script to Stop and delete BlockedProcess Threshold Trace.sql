Declare @TraceID int
	set @TraceID=3
	exec sp_trace_setstatus @TraceID, 0
	--delete the trace but leaves the file on the drive
	exec sp_trace_setstatus @TraceID, 2

-- To ensure all the trace has been stoped and removed - Run the following statement
	SELECT * FROM ::fn_trace_getinfo(NULL)
