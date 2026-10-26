#DECLARE($value : Real; $places : Integer)->$text : Text

var $scale : Integer:=1
var $i : Integer
For ($i; 1; $places)
	$scale:=$scale*10
End for

var $size : Real:=Abs($value)
var $whole : Integer:=Int($size)
var $frac : Integer:=Int((($size-$whole)*$scale)+0.5)

If ($frac>=$scale)
	$whole:=$whole+1
	$frac:=0
End if

$text:=String($whole)

If ($places>0)
	var $tail : Text:=String($frac)
	While (Length($tail)<$places)
		$tail:="0"+$tail
	End while
	$text:=$text+"."+$tail
End if

If ($value<0)
	$text:="-"+$text
End if
