#DECLARE($audit : Object; $where : Text; $code : Collection; $joined : Text)

var $whole : Collection:=New collection
var $hit : Object
For each ($hit; MN_AuditScan("(?i)(\\$\\w+)\\s*:\\s*(?:Integer|Longint)\\b"; $joined))
	$whole.push(Lowercase($hit.groups[0]))
End for each

var $number : Integer:=0
var $line : Text
For each ($line; $code)
	$number:=$number+1

	For each ($hit; MN_AuditScan("\\bString\\("; $line))
		var $open : Integer:=$hit.at+Length("String")
		var $depth : Integer:=0
		var $j : Integer:=$open
		var $found : Boolean:=False

		While (($j<=Length($line)) & Not($found))
			var $char : Text:=Substring($line; $j; 1)
			Case of
				: ($char="(")
					$depth:=$depth+1
				: ($char=")")
					$depth:=$depth-1
					If ($depth=0)
						$found:=True
					End if
			End case
			If (Not($found))
				$j:=$j+1
			End if
		End while

		var $argument : Text:=Substring($line; $open+1; $j-($open+1))
		If (Position("/"; $argument)>0)
			If (MN_AuditScan("^\\s*(Int|Round|Trunc|Dec)\\s*\\("; $argument).length=0)
				var $shown : Text:=Trim($argument)
				If (Length($shown)>48)
					$shown:=Substring($shown; 1; 48)
				End if
				MN_AuditSay($audit; $where; "line "+String($number)+\
					": String() on a division - 4D's / is REAL division, so this follows the "+\
					"SYSTEM decimal separator and prints \"46,65\" on a comma-locale machine. "+\
					"Wrap it in Int() or Round(): '"+$shown+"'")
			End if
		End if
	End for each

	For each ($hit; MN_AuditScan(\
		"(?i)\\bString\\((\\$\\w*(?:alpha|ratio|pct|deg|px|scale|width|height)\\w*)\\)"; $line))
		If ($whole.indexOf(Lowercase($hit.groups[0]))=-1)
			MN_AuditSay($audit; $where; "line "+String($number)+\
				": String() on what looks like a Real - String() follows the SYSTEM decimal "+\
				"separator, so a comma-locale machine emits \"0,32\" where a parser expects "+\
				"\"0.32\". Format it explicitly.")
		End if
	End for each
End for each
