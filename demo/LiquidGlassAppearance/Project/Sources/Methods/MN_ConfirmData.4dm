#DECLARE($title : Text; $message : Text; $okLabel : Text)->$data : Object

$data:=New object
$data.title:=$title
$data.message:=$message
$data.okLabel:=$okLabel
$data.accepted:=False
$data.scheme:=""
