declare @rc int
declare @TraceID int
declare @maxfilesize bigint
set @maxfilesize = 50
 exec @rc = sp_trace_create @TraceID output, 2, N'cc:\BlockedProcessTrace_Allbritton_5PlusSec', @maxfilesize, NULL 
 
 if (@rc != 0) goto error
 declare @on bit
 set @on = 1
 exec sp_trace_setevent @TraceID, 137, 15, @on
 exec sp_trace_setevent @TraceID, 137, 1, @on
 exec sp_trace_setevent @TraceID, 137, 13, @on
 
 -- Set the Filters
 declare @intfilter int
 declare @bigintfilter bigint
 -- Set the trace status to start
 exec sp_trace_setstatus @TraceID, 1
 -- display trace id for future references
 
 select TraceID=@TraceID
 goto finish
 error: 
 select ErrorCode=@rc
 finish:
  go
