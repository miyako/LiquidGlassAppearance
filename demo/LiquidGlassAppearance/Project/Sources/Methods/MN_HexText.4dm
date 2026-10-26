#DECLARE($rgb : Collection)->$text : Text

$text:="#"

var $digits : Text:="0123456789ABCDEF"
var $i : Integer
For ($i; 0; 2)
	var $value : Integer:=$rgb[$i]
	$text:=$text+Substring($digits; Int($value/16)+1; 1)+Substring($digits; ($value%16)+1; 1)
End for
