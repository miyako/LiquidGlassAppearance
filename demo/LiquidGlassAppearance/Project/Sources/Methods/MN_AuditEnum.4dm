#DECLARE($root : Object; $node : Variant; $seen : Object)->$values : Collection

$values:=Null

If (Value type($node)#Is object)
	return
End if

If ($node.enum#Null)
	$values:=$node.enum.copy()
	return
End if

var $found : Collection:=New collection

var $key : Text
For each ($key; New collection("anyOf"; "oneOf"; "allOf"))
	If ($node[$key]#Null)
		var $branch : Variant
		For each ($branch; $node[$key])
			var $sub : Collection:=MN_AuditEnum($root; $branch; $seen)
			var $gave : Boolean:=False
			If ($sub#Null)
				If ($sub.length>0)
					$found:=$found.combine($sub)
					$gave:=True
				End if
			End if
			If (Not($gave))
				If (Value type($branch)=Is object)
					If (String($branch.type)="string")
						$values:=Null
						return
					End if
				End if
			End if
		End for each
	End if
End for each

var $ref : Text:=String($node["$ref"])
If (($ref#"") & (Position("#/"; $ref)=1))
	If ($seen[$ref]=Null)
		$seen[$ref]:=True
		var $through : Collection:=MN_AuditEnum($root; MN_AuditRef($root; $ref); $seen)
		If ($through#Null)
			$found:=$found.combine($through)
		End if
	End if
End if

If ($found.length>0)
	$values:=$found
End if
