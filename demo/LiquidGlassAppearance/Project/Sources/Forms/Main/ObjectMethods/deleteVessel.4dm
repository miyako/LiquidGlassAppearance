var $row : Object:=Form.sel

If ($row=Null)
	Form.status:=MN_Text("Main_SelectToRemove")
	return
End if

var $name : Text:=String($row.name)

If (Not(MN_Confirm(MN_Text("AlertRemoveTitle"; New object("name"; $name)); \
MN_Text("AlertRemoveMessage"); MN_Text("AlertButtonRemove"))))
	Form.status:=MN_Text("Main_Kept"; New object("name"; $name))
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
	Form.status:=MN_Text("Main_NoLongerInFleet"; New object("name"; $name))
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
	Form.status:=MN_Text("Main_Removed"; New object("name"; $name))
End if
