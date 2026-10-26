#DECLARE($values : Collection)->$text : Text

var $parts : Collection:=New collection
var $value : Real
For each ($value; $values)
	$parts.push(String(Int($value)))
End for each

$text:="["+$parts.join(", ")+"]"
