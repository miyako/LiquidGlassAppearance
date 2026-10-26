var $report : Object:=New object
$report.ok:=False
$report.stage:="logic"

var $file : 4D.File:=File("/PACKAGE/probe.json")

var $store : 4D.File:=File("/PACKAGE/Data/fleet.json")
var $stash : 4D.File:=File("/PACKAGE/Data/fleet.json.probe-stash")
If ($store.exists)
	Try($store.moveTo($stash.parent; $stash.fullName))
End if

var $error : Variant:=Try(MN_ProbeRun($report))
Try($file.setText(JSON Stringify($report; *)))

If ($store.exists)
	Try($store.delete())
End if
If ($stash.exists)
	Try($stash.moveTo($store.parent; $store.fullName))
End if

QUIT 4D
