var $row : Object:=Form.sel

If ($row=Null)
	Form.status:="Select a vessel in the register first, then remove it."
	return
End if

var $name : Text:=String($row.name)

If (Not(MN_Confirm("Remove "+$name+" from the fleet?"; \
"The vessel and everything recorded against it are removed. This cannot be undone."; "Remove")))
	Form.status:=$name+" kept."
	return
End if

var $i : Integer
var $removed : Integer:=0

For ($i; Form.fleet.length-1; 0; -1)
	If (String(Form.fleet[$i].name)=$name)
		Form.fleet.remove($i)
		$removed:=$removed+1
	End if
End for

If ($removed=0)
	Form.status:=$name+" is no longer in the fleet."
	return
End if

var $problem : Text:=MN_FleetSave(Form.fleet)

Form.sel:=Null
MN_View(Form)

MN_Log("Deleted"; $name; "")

If ($problem#"")
	Form.status:=$problem
	MN_Alert("Meridian"; $problem)
Else
	Form.status:=$name+" removed from the fleet."
End if
