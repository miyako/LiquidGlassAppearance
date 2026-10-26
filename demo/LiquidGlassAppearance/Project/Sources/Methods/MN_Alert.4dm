#DECLARE($title : Text; $message : Text)

var $data : Object:=MN_AlertData($title; $message)

var $window : Variant:=Try(Open form window("Alert"; Movable form dialog box))
If ($window=Null)
	return
End if

Try(DIALOG("Alert"; $data))
Try(CLOSE WINDOW)
