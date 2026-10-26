#DECLARE($sheet : Object)->$accepted : Boolean

$accepted:=False

If ($sheet=Null)
	return
End if

var $win : Variant:=Try(Open form window("Vessel"; Sheet form window))
If ($win=Null)
	return
End if

var $answer : Variant:=Try(DIALOG("Vessel"; $sheet))

Try(CLOSE WINDOW)

$accepted:=($sheet.accepted=True)
