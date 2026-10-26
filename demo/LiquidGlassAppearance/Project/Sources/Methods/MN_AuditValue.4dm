#DECLARE($audit : Object; $where : Text; $prop : Text; $value : Variant; \
$root : Object; $node : Variant)

var $allowed : Collection:=MN_AuditEnum($root; $node; New object())

If ($allowed#Null)
	If (Value type($value)=Is text)
		var $strings : Boolean:=True
		var $each : Variant
		For each ($each; $allowed)
			If (Value type($each)#Is text)
				$strings:=False
			End if
		End for each
		If ($strings)
			If ($allowed.indexOf($value)=-1)
				MN_AuditSay($audit; $where; $prop+" is "+MN_AuditShow($value)+\
					", which is not one of "+JSON Stringify($allowed))
				return
			End if
		End if
	Else
		If ((Value type($value)#Is collection) & (Value type($value)#Is object))
			If ($allowed.indexOf($value)=-1)
				MN_AuditSay($audit; $where; $prop+" is "+MN_AuditShow($value)+\
					", which is not one of "+JSON Stringify($allowed))
				return
			End if
		End if
	End if
End if

If (Value type($value)=Is collection)
	If (Value type($node)=Is object)
		If ($node.items#Null)
			var $items : Collection:=MN_AuditEnum($root; $node.items; New object())
			If ($items#Null)
				var $entry : Variant
				For each ($entry; $value)
					If (Value type($entry)=Is text)
						If ($items.indexOf($entry)=-1)
							MN_AuditSay($audit; $where; $prop+" contains "+\
								MN_AuditShow($entry)+", which 4D does not define. An event 4D "+\
								"does not know is an event that never fires, and the object "+\
								"simply does nothing when you use it.")
						End if
					End if
				End for each
			End if
		End if
	End if
End if

var $kind : Text:=""
If (Value type($node)=Is object)
	$kind:=String($node.type)
End if

Case of
	: ($kind="boolean")
		If (Value type($value)#Is boolean)
			MN_AuditSay($audit; $where; $prop+" must be a boolean, got "+MN_AuditShow($value))
		End if
	: ($kind="integer")
		var $whole : Boolean:=False
		If ((Value type($value)=Is real) | (Value type($value)=Is longint))
			$whole:=(Num($value)=Int(Num($value)))
		End if
		If (Not($whole))
			MN_AuditSay($audit; $where; $prop+" must be an integer, got "+MN_AuditShow($value))
		End if
End case
