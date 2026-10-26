#DECLARE($root : Object; $node : Variant; $seen : Object; $props : Collection)

If (Value type($node)#Is object)
	return
End if

If ($node.properties#Null)
	var $name : Text
	For each ($name; OB Keys($node.properties))
		If ($props.indexOf($name)=-1)
			$props.push($name)
		End if
	End for each
End if

var $key : Text
For each ($key; New collection("allOf"; "anyOf"; "oneOf"))
	If ($node[$key]#Null)
		var $branch : Variant
		For each ($branch; $node[$key])
			MN_AuditWalk($root; $branch; $seen; $props)
		End for each
	End if
End for each

var $ref : Text:=String($node["$ref"])
If (($ref#"") & (Position("#/"; $ref)=1) & ($seen[$ref]=Null))
	$seen[$ref]:=True
	MN_AuditWalk($root; MN_AuditRef($root; $ref); $seen; $props)
End if
