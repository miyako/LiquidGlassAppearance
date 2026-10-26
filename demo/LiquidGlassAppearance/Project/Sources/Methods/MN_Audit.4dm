var $file : 4D.File:=File("/PACKAGE/audit.json")
var $audit : Object:=New object("problems"; New collection; "checks"; New collection)

var $started : Integer:=Milliseconds
var $forms : Collection:=MN_AuditFormList

MN_AuditForms($audit; $forms)
MN_AuditBind($audit; $forms)
MN_AuditWire($audit; $forms)
MN_AuditLang($audit)
MN_AuditCss($audit; $forms)
MN_AuditGeom($audit; $forms)
MN_AuditCols($audit; $forms)
MN_AuditSkin($audit; $forms)

$audit.ms:=Milliseconds-$started
$audit.clean:=($audit.problems.length=0)
$audit.errors:=Last errors

Try($file.setText(JSON Stringify($audit; *)))

QUIT 4D
