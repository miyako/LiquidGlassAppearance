var $file : 4D.File:=File("/PACKAGE/compile.json")
var $report : Object:=New object
$report.stage:="before"
Try($file.setText(JSON Stringify($report; *)))

var $result : Variant:=Try(Compile project)

$report.stage:="after"
$report.type:=Value type($result)
If (Value type($result)=Is object)
	$report.success:=$result.success
	$report.errors:=$result.errors
	$report.warnings:=$result.warnings
End if
Try($file.setText(JSON Stringify($report; *)))

QUIT 4D
