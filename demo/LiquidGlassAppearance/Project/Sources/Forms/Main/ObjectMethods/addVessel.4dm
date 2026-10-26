var $sheet : Object:=MN_VesselData(Null)

If (Not(MN_VesselSheet($sheet)))
	return
End if

var $vessel : Object:=MN_VesselApply($sheet)
var $existing : Object

For each ($existing; Form.fleet)
	If (String($existing.name)=String($vessel.name))
		Form.status:=MN_Text("Main_AlreadyInFleet"; New object("name"; String($vessel.name)))
		return
	End if
End for each

Form.fleet.push($vessel)

var $problem : Text:=MN_FleetSave(Form.fleet)

Form.sel:=New object("name"; String($vessel.name))
MN_View(Form)

MN_Log("Added"; String($vessel.name); String($vessel.model))

If ($problem#"")
	Form.status:=$problem
	MN_Alert("Meridian"; $problem)
Else
	Form.status:=MN_Text("Main_Added"; New object("name"; String($vessel.name)))
End if
