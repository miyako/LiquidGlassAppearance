var $file : 4D.File:=File("/PACKAGE/css.json")
var $out : Object:=New object("started"; String(Current date; ISO date; Current time))

var $source : 4D.File:=File("/PACKAGE/reference/measured.json")
If (Not($source.exists))
	$out.error:="reference/measured.json is missing - there is nothing to render from"
	Try($file.setText(JSON Stringify($out; *)))
	QUIT 4D
	return
End if

var $sheet : Object:=MN_CssBuild(JSON Parse($source.getText()))
$out.classes:=$sheet.classes
$out.blocks:=$sheet.blocks
$out.problems:=$sheet.problems

If ($sheet.problems.length=0)
	var $target : 4D.File:=File("/PACKAGE/Project/Sources/styleSheets_mac.css")
	var $bytes : Blob
	TEXT TO BLOB($sheet.text; $bytes; UTF8 text without length)
	$target.setContent($bytes)
	$out.written:=$target.fullName
	$out.bytes:=BLOB size($bytes)
	$out.lines:=Split string($sheet.text; Char(Line feed)).length-1
Else
	$out.written:=False
End if

$out.errors:=Last errors
Try($file.setText(JSON Stringify($out; *)))

QUIT 4D
