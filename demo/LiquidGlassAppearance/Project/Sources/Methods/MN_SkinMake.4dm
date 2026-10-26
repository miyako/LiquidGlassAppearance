var $file : 4D.File:=File("/PACKAGE/skin.json")
var $out : Object:=New object("started"; String(Current date; ISO date; Current time))

var $started : Integer:=Milliseconds
$out.report:=MN_SkinBuild
$out.ms:=Milliseconds-$started
$out.errors:=Last errors

Try($file.setText(JSON Stringify($out; *)))

QUIT 4D
