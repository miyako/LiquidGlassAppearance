#DECLARE($data : Object)

If ($data=Null)
	return
End if

var $sel : Object:=$data.sel
If ($sel=Null)
	$data.insName:=""
	$data.insSub:=""
	$data.insModel:=""
	$data.insType:=""
	$data.insBuilt:=""
	$data.insBerths:=""
	$data.insHarbour:=""
	$data.insFlag:=""
	$data.insSkipper:=""
	$data.insStatus:=""
	$data.insNight:=""
	$data.insWeek:=""
	$data.insNotes:=MN_Text("Inspect_NoSelection")
Else
	$data.insName:=String($sel.label)
	$data.insSub:=String($sel.model)
	$data.insModel:=String($sel.model)
	$data.insType:=String($sel.type)
	$data.insBuilt:=String($sel.year)
	$data.insBerths:=String($sel.berths)
	$data.insHarbour:=String($sel.harbor)
	$data.insFlag:=String($sel.flag)
	$data.insSkipper:=String($sel.skipper)
	$data.insStatus:=String(MN_Stage(String($sel.stageKey); "mark"))+"  "+String($sel.stage)
	$data.insNight:=MN_Yen(Num($sel.rate))
	$data.insWeek:=MN_Yen(Num($sel.rate)*7)
	$data.insNotes:=String($sel.notes)
	If ($data.insNotes="")
		$data.insNotes:=MN_Text("Inspect_NoNotes")
	End if
End if
