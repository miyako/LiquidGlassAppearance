#DECLARE($root : Object; $node : Variant; $prop : Text; $seen : Object)->$found : Variant

$found:=Null

If (Value type($node)#Is object)
	return
End if

If ($node.properties#Null)
	If ($node.properties[$prop]#Null)
		$found:=$node.properties[$prop]
		return
	End if
End if

var $key : Text
For each ($key; New collection("allOf"; "anyOf"; "oneOf"))
	If ($node[$key]#Null)
		var $branch : Variant
		For each ($branch; $node[$key])
			var $hit : Variant:=MN_AuditNode($root; $branch; $prop; $seen)
			If ($hit#Null)
				$found:=$hit
				return
			End if
		End for each
	End if
End for each

var $ref : Text:=String($node["$ref"])
If (($ref#"") & (Position("#/"; $ref)=1) & ($seen[$ref]=Null))
	$seen[$ref]:=True
	$found:=MN_AuditNode($root; MN_AuditRef($root; $ref); $prop; $seen)
End if
