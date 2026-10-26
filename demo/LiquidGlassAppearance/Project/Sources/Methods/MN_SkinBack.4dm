#DECLARE($ground : Text; $ink : Text; $strength : Real; \
$width : Integer; $height : Integer; $paths : Text)->$svg : Text

var $over : Integer:=128
$svg:="<rect x=\""+String(-$over)+"\" y=\""+String(-$over)+"\" "
$svg:=$svg+"width=\""+String($width+(2*$over))+"\" height=\""+String($height+(2*$over))+"\" "
$svg:=$svg+"fill=\""+$ground+"\"/>"

If ($paths#"")
	$svg:=$svg+"<path d=\""+$paths+"\" fill=\"none\" stroke=\""+$ink+"\" "
	$svg:=$svg+"stroke-width=\"1\" opacity=\""+MN_SkinNum($strength; 3)+"\"/>"
End if
