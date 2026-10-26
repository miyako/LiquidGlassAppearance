var $row : Object:=Form.sel

If ($row=Null)
	Form.status:=MN_Text("Main_SelectToEdit")
	return
End if

var $name : Text:=String($row.name)
var $vessel : Object
var $found : Object:=Null

For each ($vessel; Form.fleet)
	If (String($vessel.name)=$name)
		$found:=$vessel
	End if
End for each

If ($found=Null)
	Form.status:=MN_Text("Main_NoLongerInFleet"; New object("name"; $name))
	return
End if

var $sheet : Object:=MN_VesselData($found)

If (Not(MN_VesselSheet($sheet)))
	return
End if

var $edited : Object:=MN_VesselApply($sheet)
var $renamed : Boolean:=(String($edited.name)#String($sheet.original))

If ($renamed)
	var $other : Object
	For each ($other; Form.fleet)
		If (String($other.name)=String($edited.name))
			Form.status:=MN_Text("Main_NameTaken"; New object("name"; String($edited.name)))
			return
		End if
	End for each
End if

var $changed : Text:=MN_VesselDiff($found; $edited)

var $property : Text
For each ($property; $edited)
	$found[$property]:=$edited[$property]
End for each

var $problem : Text:=MN_FleetSave(Form.fleet)

Form.sel:=New object("name"; String($edited.name))
MN_View(Form)

MN_Log("Edited"; String($edited.name); $changed)

If ($problem#"")
	Form.status:=$problem
	MN_Alert("Meridian"; $problem)
Else
	Form.status:=MN_Text("Main_Updated"; New object("name"; String($edited.name)))
End if
