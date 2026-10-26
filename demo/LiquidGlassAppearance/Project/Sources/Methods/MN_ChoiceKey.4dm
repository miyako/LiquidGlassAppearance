#DECLARE($list : Object; $fallback : Text)->$key : Text

$key:=$fallback

If ($list=Null)
	return
End if

var $index : Integer:=Num($list.index)
If (($index>=0) & ($index<$list.keys.length))
	$key:=String($list.keys[$index])
End if
