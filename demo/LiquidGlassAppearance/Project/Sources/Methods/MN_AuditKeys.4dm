#DECLARE($items : Collection; $field : Text)->$text : Text

var $parts : Collection:=New collection
var $item : Variant
For each ($item; $items)
	If ($field="")
		$parts.push(String($item))
	Else
		$parts.push(String($item[$field]))
	End if
End for each

$text:=$parts.join(Char(1))
