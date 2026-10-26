#DECLARE($audit : Object; $where : Text; $prop : Text; $actual : Variant; $wanted : Text)

If (String($actual)#$wanted)
	MN_AuditSay($audit; $where; $prop+" is "+MN_AuditShow($actual)+", measured '"+$wanted+"'")
End if
