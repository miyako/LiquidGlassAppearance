#DECLARE($form : Object)->$changed : Boolean

$changed:=False

var $now : Text:=String(Try(FORM Get color scheme))

If ($now="")
	return
End if
If ($now=String($form.scheme))
	return
End if

$form.reopen:=True
$changed:=True
