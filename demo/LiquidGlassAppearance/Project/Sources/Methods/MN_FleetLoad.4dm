#DECLARE()->$fleet : Collection

$fleet:=MN_Fleet

var $file : 4D.File:=MN_FleetFile
If (Not($file.exists))
	return
End if

var $text : Text:=String(Try($file.getText()))
If ($text="")
	return
End if

var $parsed : Variant:=Try(JSON Parse($text))
If (Value type($parsed)#Is collection)
	return
End if

var $saved : Collection:=$parsed
If ($saved.length=0)
	return
End if

var $i : Integer
For ($i; 0; $saved.length-1)
	If (Value type($saved[$i])#Is object)
		return
	End if
	If (String($saved[$i].name)="")
		return
	End if
End for

$fleet:=$saved
