#DECLARE()->$data : Object

$data:=New object

var $file : 4D.File:=MN_FleetFile
$data.stored:=$file.exists
$data.savedAt:=""
If ($file.exists)
	$data.savedAt:=Substring(String(Try(Time string($file.modificationTime))); 1; 5)
End if
$data.fleet:=MN_FleetLoad
$data.provenance:=""

$data.section:="fleet"
$data.nav:=New collection
$data.navSel:=Null
$data.navPos:=0

$data.rows:=New collection
$data.sel:=Null
$data.pos:=0
$data.query:=""

$data.title:=""
$data.subtitle:=""

$data.sortBy:="name"
$data.sortDir:="asc"
$data.hdrName:=""
$data.hdrModel:=""
$data.hdrHarbour:=""
$data.hdrFlag:=""
$data.hdrRate:=""
$data.hdrStatus:=""

$data.util:=""
$data.utilNote:=""
$data.committed:=""
$data.committedNote:=""

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
$data.insNotes:=""

$data.scheme:=""
$data.reopen:=False

$data.status:=""
