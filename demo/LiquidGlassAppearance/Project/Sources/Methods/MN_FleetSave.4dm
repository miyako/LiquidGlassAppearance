#DECLARE($fleet : Collection)->$problem : Text

$problem:=""

If ($fleet=Null)
	$problem:="There was no fleet to save."
	return
End if

var $file : 4D.File:=MN_FleetFile
var $text : Text:=JSON Stringify($fleet; *)

var $where : Text:=String($file.parent.name)+"/"+$file.fullName

Try($file.parent.create())
Try($file.setText($text))

If (Not($file.exists))
	$problem:="The fleet could not be written to "+$where+\
		". This change is on screen only and will not be here next time."
	return
End if

var $back : Text:=String(Try($file.getText()))
If ($back="")
	$problem:="The fleet was written to "+$where+\
		" but came back empty. This change is on screen only."
	return
End if

var $parsed : Variant:=Try(JSON Parse($back))
If (Value type($parsed)#Is collection)
	$problem:="The fleet was written to "+$where+\
		" but cannot be read back. This change is on screen only."
	return
End if

var $saved : Collection:=$parsed
If ($saved.length#$fleet.length)
	$problem:="The fleet was written to "+$where+" but came back with "+\
		String($saved.length)+" of "+String($fleet.length)+" vessels."
	return
End if
