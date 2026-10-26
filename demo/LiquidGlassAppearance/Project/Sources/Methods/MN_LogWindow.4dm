var $again : Boolean:=True
var $data : Object

While ($again)
	$again:=False

	$data:=MN_LogData
	$data.reopen:=False

	var $window : Variant:=Try(Open form window("Log"; Plain form window))
	If ($window=Null)
		return
	End if

	Try(DIALOG("Log"; $data))
	Try(CLOSE WINDOW)

	If ($data.reopen=True)
		$again:=True
	End if
End while
