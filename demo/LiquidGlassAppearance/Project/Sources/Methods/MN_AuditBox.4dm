#DECLARE($audit : Object; $where : Text; $object : Object)

If ($object.fill#Null)
	var $paints : Boolean:=(($object.alternateFill#Null) | ($object.rowFillSource#Null))
	var $class : Text:=String($object.class)

	var $role : Object
	For each ($role; MN_CssRoles)
		If (String($role.name)=$class)
			var $spec : Text
			For each ($spec; $role.props)
				If (Position("alternateFill "; $spec)=1)
					$paints:=True
				End if
			End for each
		End if
	End for each

	If ($paints)
		MN_AuditSay($audit; $where; "declares 'fill' AND paints rows (alternateFill) - the "+\
			"fill wins and row painting stops. Omit the fill.")
	Else
		If (String($object.fill)#"transparent")
			MN_AuditSay($audit; $where; "declares an opaque fill "+\
				MN_AuditShow($object.fill)+" - a list box that paints no rows should be "+\
				"transparent, so whatever it floats on shows through")
		End if
	End if
End if

var $key : Text
For each ($key; New collection("headerHeight"; "footerHeight"; "rowHeight"))
	If ($object[$key]#Null)
		If (Value type($object[$key])#Is text)
			MN_AuditSay($audit; $where; "'"+$key+"' must be a string like \"0px\", got "+\
				MN_AuditShow($object[$key]))
		End if
	End if
End for each

If ($object.hideFocusRing#True)
	MN_AuditSay($audit; $where; "must set hideFocusRing:true")
End if

If (Value type($object.columns)#Is collection)
	MN_AuditSay($audit; $where; "declares no columns")
	return
End if
If ($object.columns.length=0)
	MN_AuditSay($audit; $where; "declares no columns")
	return
End if

var $index : Integer
For ($index; 0; $object.columns.length-1)
	var $column : Object:=$object.columns[$index]
	var $at : Text:=$where+" col"+String($index+1)

	If ($column.name=Null)
		MN_AuditSay($audit; $at; "has no 'name' - the Form Editor's CSS pass iterates it and crashes")
	End if
	If (Value type($column.header)#Is object)
		MN_AuditSay($audit; $at; "has no header.name - same crash")
	Else
		If ($column.header.name=Null)
			MN_AuditSay($audit; $at; "has no header.name - same crash")
		End if
	End if
	If (Value type($column.footer)#Is object)
		MN_AuditSay($audit; $at; "has no footer.name - same crash")
	Else
		If ($column.footer.name=Null)
			MN_AuditSay($audit; $at; "has no footer.name - same crash")
		End if
	End if

	If ($column.enterable#False)
		MN_AuditSay($audit; $at; "must set enterable:false - otherwise a click lands a text "+\
			"cursor in the cell and a keystroke edits a value the register only displays")
	End if
End for
