#DECLARE($amount : Integer)->$text : Text

var $n : Integer:=Abs($amount)
$text:=""

If ($n=0)
	$text:="0"
End if

var $group : Integer
var $chunk : Text

While ($n>0)
	$group:=$n%1000
	$n:=Int($n/1000)
	$chunk:=String($group)
	If ($n>0)
		While (Length($chunk)<3)
			$chunk:="0"+$chunk
		End while
	End if
	If (Length($text)>0)
		$text:=$chunk+","+$text
	Else
		$text:=$chunk
	End if
End while

If ($amount<0)
	$text:="-"+$text
End if
