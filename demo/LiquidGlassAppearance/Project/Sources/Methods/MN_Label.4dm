// Display text for a stored English key (stage, type, skipper, log action)
#DECLARE($kind : Text; $key : Text)->$text : Text

$text:=$key

var $id : Text:=""
var $word : Text
For each ($word; Split string($key; " "; sk ignore empty strings))
	$id:=$id+Uppercase(Substring($word; 1; 1))+Substring($word; 2)
End for each

If ($id="")
	return
End if

var $found : Text:=Localized string($kind+"_"+$id)
If ($found#"")
	$text:=$found
End if
