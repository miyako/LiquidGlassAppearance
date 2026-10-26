#DECLARE($title : Text; $message : Text; $okLabel : Text)->$accepted : Boolean

$accepted:=False

var $data : Object:=MN_ConfirmData($title; $message; $okLabel)

var $window : Variant:=Try(Open form window("Confirm"; Movable form dialog box))
If ($window=Null)
	return
End if

Try(DIALOG("Confirm"; $data))
Try(CLOSE WINDOW)

$accepted:=($data.accepted=True)
