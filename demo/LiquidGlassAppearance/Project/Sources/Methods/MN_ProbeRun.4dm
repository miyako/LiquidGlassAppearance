#DECLARE($report : Object)

var $data : Object:=MN_Data
MN_View($data)

$report.fleet:=$data.fleet.length
$report.title:=$data.title
$report.subtitle:=$data.subtitle
$report.util:=$data.util
$report.utilNote:=$data.utilNote
$report.committed:=$data.committed
$report.committedNote:=$data.committedNote
$report.rows:=$data.rows.length

var $nav : Collection:=New collection
var $entry : Object
For each ($entry; $data.nav)
	$nav.push(String($entry.key)+"="+String($entry.count))
End for each
$report.nav:=$nav

var $names : Collection:=New collection
var $row : Object
For each ($row; $data.rows)
	$names.push(String($row.name))
End for each
$report.firstRows:=$names.slice(0; 3)

If ($data.rows.length>0)
	$data.sel:=$data.rows[0]
	$data.pos:=1
	MN_View($data)
End if
$report.insName:=$data.insName
$report.insModel:=$data.insModel
$report.insNight:=$data.insNight
$report.insWeek:=$data.insWeek
$report.insStatus:=$data.insStatus

$data.query:="  lagoon  "
$data.sel:=Null
MN_View($data)
$report.searchRows:=$data.rows.length
$report.searchSubtitle:=$data.subtitle

$data.section:="fleet"
$data.query:=""
$data.sortBy:="name"
$data.sortDir:="asc"
MN_View($data)
$data.sel:=$data.rows[2]
MN_View($data)
$report.selName:=String($data.sel.name)
$report.selPos:=$data.pos
$report.selAtPos:=""
If (($data.pos>0) & ($data.pos<=$data.rows.length))
	$report.selAtPos:=String($data.rows[$data.pos-1].name)
End if

$data.query:="zzzz no such vessel"
MN_View($data)
$report.selAfterMiss:=($data.sel=Null)
$data.query:=""

$data.query:=""
$data.sortBy:="rate"
$data.sortDir:="asc"
MN_View($data)
var $rates : Collection:=New collection
var $cheap : Object
For each ($cheap; $data.rows)
	$rates.push(Num($cheap.rate))
End for each
$report.rateSorted:=$rates
$report.rateHeader:=$data.hdrRate
$report.nameHeader:=$data.hdrName

$data.sortDir:="desc"
MN_View($data)
$report.rateTopDesc:=Num($data.rows[0].rate)

$data.sortBy:="name"
$data.sortDir:="asc"
MN_View($data)

$data.query:=""
$data.section:="desk"
MN_View($data)
$report.deskRows:=$data.rows.length
$report.deskTitle:=$data.title

$data.section:="fleet"
$data.query:=""
MN_View($data)
$data.rows[0].probeMark:="kept"
$data.sel:=$data.rows[4]
MN_Inspect($data)
$report.inspectName:=String($data.insName)
$report.rowsKept:=(String($data.rows[0].probeMark)="kept")
$report.rowsCount:=$data.rows.length

$data.section:="fleet"
$data.query:=""
MN_View($data)

var $target : Object:=Null
var $each : Object
For each ($each; $data.fleet)
	If (String($each.name)="Argonaut")
		$target:=$each
	End if
End for each

$report.charterBefore:=String($target.stage)
$target.stage:="On charter"
MN_View($data)

$report.charterAfter:=String($target.stage)
$report.charterUtil:=$data.util
$report.charterCommitted:=$data.committed
$report.charterNote:=$data.committedNote
var $after : Collection:=New collection
var $entry2 : Object
For each ($entry2; $data.nav)
	$after.push(String($entry2.key)+"="+String($entry2.count))
End for each
$report.charterNav:=$after

var $blank : Object:=MN_VesselData(Null)
$report.blankHeading:=String($blank.heading)
$report.blankStage:=String($blank.stage)
$report.blankComplaint:=MN_VesselCheck($blank)

var $sample : Object:=$data.fleet[0]
var $sheet : Object:=MN_VesselData($sample)
$report.sheetOriginal:=String($sheet.original)
$report.sheetComplaint:=MN_VesselCheck($sheet)
var $roundTrip : Object:=MN_VesselApply($sheet)
$report.roundName:=String($roundTrip.name)
$report.roundRateIsNumber:=(Value type($roundTrip.rate)=Is real) | (Value type($roundTrip.rate)=Is longint)
$report.roundRate:=Num($roundTrip.rate)
$report.roundSourceRate:=Num($sample.rate)
$report.roundBerths:=Num($roundTrip.berths)
$report.roundFlagshipIsBoolean:=(Value type($roundTrip.flagship)=Is boolean)

$report.saveProblem:=MN_FleetSave($data.fleet)
var $reloaded : Collection:=MN_FleetLoad
$report.savedCount:=$reloaded.length
$report.savedStage:=""
var $back : Object
For each ($back; $reloaded)
	If (String($back.name)="Argonaut")
		$report.savedStage:=String($back.stage)
	End if
End for each
$report.storeExists:=MN_FleetFile.exists

$report.ok:=True
