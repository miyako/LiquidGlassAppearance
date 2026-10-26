#DECLARE($x : Integer; $y : Integer; $width : Integer; $height : Integer; \
$radius : Integer; $attributes : Text)->$svg : Text

$svg:="<rect x=\""+String($x)+"\" y=\""+String($y)+"\" "
$svg:=$svg+"width=\""+String($width)+"\" height=\""+String($height)+"\""

If ($radius>0)
	$svg:=$svg+" rx=\""+String($radius)+"\" ry=\""+String($radius)+"\""
End if

If ($attributes#"")
	$svg:=$svg+" "+$attributes
End if

$svg:=$svg+"/>"
