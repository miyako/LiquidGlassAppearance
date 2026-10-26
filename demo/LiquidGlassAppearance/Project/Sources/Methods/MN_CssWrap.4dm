#DECLARE($text : Text; $width : Integer; $lead : Text)->$wrapped : Text

var $lines : Collection:=New collection
var $row : Text:=""

var $word : Text
For each ($word; Split string($text; " "; sk ignore empty strings))
	If (($row#"") & ((Length($row)+1+Length($word))>$width))
		$lines.push($row)
		$row:=$word
	Else
		If ($row="")
			$row:=$word
		Else
			$row:=$row+" "+$word
		End if
	End if
End for each

If ($row#"")
	$lines.push($row)
End if

var $out : Collection:=New collection
var $line : Text
For each ($line; $lines)
	$out.push($lead+$line)
End for each

$wrapped:=$out.join(Char(Line feed))
