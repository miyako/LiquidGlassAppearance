#DECLARE($code : Integer)->$text : Text

var $digits : Text:="0123456789abcdef"
var $rest : Integer:=$code
$text:=""

If ($rest=0)
	$text:="0"
End if

While ($rest>0)
	$text:=Substring($digits; ($rest%16)+1; 1)+$text
	$rest:=Int($rest/16)
End while

$text:="0x"+$text
