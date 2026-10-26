#DECLARE()->$entries : Collection

$entries:=New collection

var $file : 4D.File:=MN_LogFile
If (Not($file.exists))
	return
End if

var $parsed : Variant:=Try(JSON Parse($file.getText()))
If (Value type($parsed)=Is collection)
	$entries:=$parsed
End if
