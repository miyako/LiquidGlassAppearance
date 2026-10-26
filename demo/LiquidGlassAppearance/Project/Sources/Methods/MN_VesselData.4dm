#DECLARE($vessel : Object)->$data : Object

$data:=New object
$data.accepted:=False
$data.message:=""

If ($vessel=Null)
	$data.heading:=MN_Text("Vessel_HeadingNew")
	$data.base:=New object
	$data.original:=""
	$data.name:=""
	$data.model:=""
	$data.type:=""
	$data.harbor:=""
	$data.flag:=""
	$data.skipper:=MN_Label("Skipper"; "Bareboat")
	$data.year:=Year of(Current date)
	$data.berths:=2
	$data.rate:=0
	$data.stage:="Available"
	$data.flagship:=False
	$data.notes:=""
Else
	$data.heading:=MN_Text("Vessel_HeadingEdit")
	$data.base:=OB Copy($vessel)
	$data.original:=String($vessel.name)
	$data.name:=String($vessel.name)
	$data.model:=String($vessel.model)
	$data.type:=String($vessel.type)
	$data.harbor:=MN_Local($vessel; "harbor")
	$data.flag:=MN_Local($vessel; "flag")
	$data.skipper:=MN_Local($vessel; "skipper")
	$data.year:=Num($vessel.year)
	$data.berths:=Num($vessel.berths)
	$data.rate:=Num($vessel.rate)
	$data.stage:=String($vessel.stage)
	$data.flagship:=($vessel.flagship=True)
	$data.notes:=MN_Local($vessel; "notes")
End if

$data.typeList:=MN_ChoiceList("Type"; $data.type)
$data.stageList:=MN_ChoiceList("Stage"; $data.stage)
