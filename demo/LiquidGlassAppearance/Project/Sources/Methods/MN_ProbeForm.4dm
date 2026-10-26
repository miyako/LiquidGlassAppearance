var $file : 4D.File:=File("/PACKAGE/formprobe.json")
var $report : Object:=New object
var $done : Collection:=New collection
$report.loaded:=$done

var $root : 4D.Folder:=Folder("/PACKAGE/Project/Sources/Forms")
var $each : 4D.Folder
var $formName : Text

For each ($each; $root.folders())
	$formName:=$each.name
	$report.stage:="loading "+$formName
	Try($file.setText(JSON Stringify($report; *)))
	Try(FORM LOAD($formName))
	Try(FORM UNLOAD)
	$done.push($formName)
End for each

$report.stage:="unloaded"
$report.ok:=($done.length>0)
Try($file.setText(JSON Stringify($report; *)))

QUIT 4D
