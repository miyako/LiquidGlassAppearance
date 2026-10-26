#DECLARE($width : Integer; $height : Integer; $viewX : Integer; $viewY : Integer; \
$viewW : Integer; $viewH : Integer; $defs : Text)->$svg : Text

$svg:="<svg xmlns=\"http://www.w3.org/2000/svg\" "
$svg:=$svg+"xmlns:xlink=\"http://www.w3.org/1999/xlink\" "
$svg:=$svg+"width=\""+String($width)+"\" height=\""+String($height)+"\" "
$svg:=$svg+"viewBox=\""+String($viewX)+" "+String($viewY)+" "+String($viewW)+" "+String($viewH)+"\">"

If ($defs#"")
	$svg:=$svg+"<defs>"+$defs+"</defs>"
End if
