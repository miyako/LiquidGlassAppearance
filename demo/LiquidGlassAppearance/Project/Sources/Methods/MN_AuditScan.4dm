#DECLARE($pattern : Text; $subject : Text)->$hits : Collection

$hits:=New collection

ARRAY LONGINT($pos; 0)
ARRAY LONGINT($len; 0)

var $start : Integer:=1
While (Match regex($pattern; $subject; $start; $pos; $len))
	var $hit : Object:=New object("at"; $pos{0}; \
		"text"; Substring($subject; $pos{0}; $len{0}); "groups"; New collection)

	var $g : Integer
	For ($g; 1; Size of array($pos))
		$hit.groups.push(Substring($subject; $pos{$g}; $len{$g}))
	End for
	$hits.push($hit)

	If ($len{0}>0)
		$start:=$pos{0}+$len{0}
	Else
		$start:=$pos{0}+1
	End if
End while
