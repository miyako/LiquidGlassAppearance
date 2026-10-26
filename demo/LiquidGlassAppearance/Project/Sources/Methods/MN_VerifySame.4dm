#DECLARE($problems : Collection; $field : Text; $got : Variant; $want : Variant; $how : Text)

If (JSON Stringify($got)#JSON Stringify($want))
	$problems.push("logic: "+$field+" "+$how+" "+MN_AuditShow($got)+\
		", the native app shows "+MN_AuditShow($want))
End if
