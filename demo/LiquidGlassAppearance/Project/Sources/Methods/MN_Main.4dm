var $data : Object:=MN_Data

MN_View($data)

If ($data.nav.length>0)
	$data.navSel:=$data.nav[0]
	$data.navPos:=1
End if

If ($data.rows.length>0)
	$data.sel:=$data.rows[0]
	MN_View($data)
End if

var $win : Variant
var $answer : Variant
var $again : Boolean:=True

While ($again)
	$again:=False
	$win:=Try(Open form window("Main"; Plain form window))
	If ($win=Null)
		return
	End if
	$answer:=Try(DIALOG("Main"; $data))
	Try(CLOSE WINDOW)
	If ($data.reopen=True)
		$data.reopen:=False
		$again:=True
	End if
End while
