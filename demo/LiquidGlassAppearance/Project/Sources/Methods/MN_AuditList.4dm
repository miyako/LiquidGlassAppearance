#DECLARE($items : Collection)->$text : Text

var $parts : Collection:=New collection
var $item : Text
For each ($item; $items.copy().sort())
	$parts.push("'"+$item+"'")
End for each

$text:="["+$parts.join(", ")+"]"
