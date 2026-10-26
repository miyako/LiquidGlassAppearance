#DECLARE($nav : Collection)->$counts : Object

$counts:=New object

If ($nav=Null)
	return
End if

var $pair : Text
For each ($pair; $nav)
	var $parts : Collection:=Split string($pair; "=")
	If ($parts.length=2)
		$counts[$parts[0]]:=Num($parts[1])
	End if
End for each
