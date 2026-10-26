var $data : Object:=New object("scheme"; ""; "reopen"; False)

var $again : Boolean:=True
While ($again)
	$again:=False

	var $window : Variant:=Try(Open form window("Launcher"; Plain form window))
	If ($window=Null)
		return
	End if

	Try(DIALOG("Launcher"; $data))
	Try(CLOSE WINDOW)

	If ($data.reopen=True)
		$data.reopen:=False
		$again:=True
	End if
End while
