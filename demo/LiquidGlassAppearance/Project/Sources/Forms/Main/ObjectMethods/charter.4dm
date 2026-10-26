var $row : Object:=Form.sel

If ($row=Null)
	var $at : Integer:=Num(Form.pos)
	If (($at>0) & ($at<=Form.rows.length))
		$row:=Form.rows[$at-1]
	End if
End if

If ($row=Null)
	Form.status:=MN_Text("Main_SelectToCharter")
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

var $was : Text:=String($found.stage)

If (String($found.stage)="On charter")
	Form.status:=MN_Text("Main_AlreadyOnCharter"; New object("name"; $name))
	return
End if

$found.stage:="On charter"

var $problem : Text:=MN_FleetSave(Form.fleet)

MN_View(Form)

MN_Log("Chartered"; $name; MN_Text("Main_CharterFrom"; New object("was"; MN_Label("Stage"; $was))))

If ($problem#"")
	Form.status:=$problem
	MN_Alert("Meridian"; $problem)
Else
	Form.status:=MN_Text("Main_NowOnCharter"; New object("name"; $name))
End if
