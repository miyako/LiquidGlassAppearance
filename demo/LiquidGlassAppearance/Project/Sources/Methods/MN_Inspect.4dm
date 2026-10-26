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
	$data.insNotes:="No vessel selected. Choose one in the register to see its particulars."
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
	$data.insStatus:=String(MN_Stage(String($sel.stage); "mark"))+"  "+String($sel.stage)
	$data.insNight:=MN_Euro(Num($sel.rate))
	$data.insWeek:=MN_Euro(Num($sel.rate)*7)
	$data.insNotes:=String($sel.notes)
	If ($data.insNotes="")
		$data.insNotes:="No operational notes on file."
	End if
End if
