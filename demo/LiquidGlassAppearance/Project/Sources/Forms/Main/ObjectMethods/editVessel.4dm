var $row : Object:=Form.sel

If ($row=Null)
	Form.status:="Select a vessel in the register first, then edit it."
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
	Form.status:=$name+" is no longer in the fleet."
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
			Form.status:="There is already a vessel called "+String($edited.name)+"."
			return
		End if
	End for each
End if

var $changed : Text:=MN_VesselDiff($found; $edited)

$found.name:=String($edited.name)
$found.model:=String($edited.model)
$found.type:=String($edited.type)
$found.harbor:=String($edited.harbor)
$found.flag:=String($edited.flag)
$found.year:=Num($edited.year)
$found.stage:=String($edited.stage)
$found.skipper:=String($edited.skipper)
$found.rate:=Num($edited.rate)
$found.berths:=Num($edited.berths)
$found.flagship:=($edited.flagship=True)
$found.notes:=String($edited.notes)

var $problem : Text:=MN_FleetSave(Form.fleet)

Form.sel:=New object("name"; String($edited.name))
MN_View(Form)

MN_Log("Edited"; String($edited.name); $changed)

If ($problem#"")
	Form.status:=$problem
	MN_Alert("Meridian"; $problem)
Else
	Form.status:=String($edited.name)+" updated."
End if
