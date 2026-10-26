#DECLARE($hex : Text)->$rgb : Collection

$rgb:=New collection

var $digits : Text:="0123456789ABCDEF"
var $clean : Text:=Uppercase(Replace string($hex; "#"; ""))

var $i : Integer
For ($i; 0; 2)
	var $hi : Integer:=Position(Substring($clean; ($i*2)+1; 1); $digits)-1
	var $lo : Integer:=Position(Substring($clean; ($i*2)+2; 1); $digits)-1
	$rgb.push(($hi*16)+$lo)
End for
