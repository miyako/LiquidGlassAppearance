#DECLARE($fleet : Collection)->$problem : Text

$problem:=""

If ($fleet=Null)
	$problem:=MN_Text("Save_NoFleet")
	return
End if

var $file : 4D.File:=MN_FleetFile
var $text : Text:=JSON Stringify($fleet; *)

var $where : Text:=String($file.parent.name)+"/"+$file.fullName

Try($file.parent.create())
Try($file.setText($text))

If (Not($file.exists))
	$problem:=MN_Text("Save_NotWritten"; New object("where"; $where))
	return
End if

var $back : Text:=String(Try($file.getText()))
If ($back="")
	$problem:=MN_Text("Save_Empty"; New object("where"; $where))
	return
End if

var $parsed : Variant:=Try(JSON Parse($back))
If (Value type($parsed)#Is collection)
	$problem:=MN_Text("Save_Unreadable"; New object("where"; $where))
	return
End if

var $saved : Collection:=$parsed
If ($saved.length#$fleet.length)
	$problem:=MN_Text("Save_Count"; New object("where"; $where; \
		"n"; $saved.length; "total"; $fleet.length))
	return
End if
