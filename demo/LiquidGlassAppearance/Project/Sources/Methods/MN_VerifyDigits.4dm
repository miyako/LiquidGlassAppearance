#DECLARE($value : Variant)->$digits : Text

$digits:=""

var $text : Text:=String($value)
var $i : Integer
For ($i; 1; Length($text))
	var $char : Text:=Substring($text; $i; 1)
	If (($char>="0") & ($char<="9"))
		$digits:=$digits+$char
	End if
End for
