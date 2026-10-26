#DECLARE($id : Text; $values : Object)->$text : Text

$text:=Localized string($id)
If ($text="")
	$text:=$id
End if

If ($values=Null)
	return
End if

var $key : Text
For each ($key; $values)
	$text:=Replace string($text; "{"+$key+"}"; String($values[$key]); *)
End for each
