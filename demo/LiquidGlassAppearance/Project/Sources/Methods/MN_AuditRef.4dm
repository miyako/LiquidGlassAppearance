#DECLARE($root : Object; $ref : Text)->$node : Variant

$node:=Null

var $path : Text:=$ref
While (($path#"") & ((Substring($path; 1; 1)="#") | (Substring($path; 1; 1)="/")))
	$path:=Substring($path; 2)
End while

var $walk : Variant:=$root
var $part : Text
For each ($part; Split string($path; "/"; sk ignore empty strings))
	If (Value type($walk)#Is object)
		return
	End if
	If ($walk[$part]=Null)
		return
	End if
	$walk:=$walk[$part]
End for each

$node:=$walk
