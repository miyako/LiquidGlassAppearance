#DECLARE($vessel : Object)->$data : Object

$data:=New object
$data.accepted:=False
$data.message:=""

If ($vessel=Null)
	$data.heading:="New vessel"
	$data.original:=""
	$data.name:=""
	$data.model:=""
	$data.type:=""
	$data.harbor:=""
	$data.flag:=""
	$data.skipper:="Bareboat"
	$data.year:=Year of(Current date)
	$data.berths:=2
	$data.rate:=0
	$data.stage:="Available"
	$data.flagship:=False
	$data.notes:=""
Else
	$data.heading:="Edit vessel"
	$data.original:=String($vessel.name)
	$data.name:=String($vessel.name)
	$data.model:=String($vessel.model)
	$data.type:=String($vessel.type)
	$data.harbor:=String($vessel.harbor)
	$data.flag:=String($vessel.flag)
	$data.skipper:=String($vessel.skipper)
	$data.year:=Num($vessel.year)
	$data.berths:=Num($vessel.berths)
	$data.rate:=Num($vessel.rate)
	$data.stage:=String($vessel.stage)
	$data.flagship:=($vessel.flagship=True)
	$data.notes:=String($vessel.notes)
End if
