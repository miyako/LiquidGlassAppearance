#DECLARE($panel : Object; $scheme : Text; $measured : Object; $bands : Collection; \
$step : Integer; $radius : Integer)->$svg : Text

var $lens : Object:=$measured.material.lens
var $geometry : Object:=$measured.geometry
var $canvasW : Integer:=$geometry.content.width
var $canvasH : Integer:=$geometry.content.height

var $x : Integer:=Num($panel.x)
var $y : Integer:=Num($panel.y)
var $w : Integer:=Num($panel.w)
var $h : Integer:=Num($panel.h)

var $corner : Integer:=$radius
If (($x<=0) | ($y<=0) | (($x+$w)>=$canvasW) | (($y+$h)>=$canvasH))
	$corner:=0
End if

var $band : Integer:=Num($lens.refract)
If ($band>($w/3))
	$band:=Int($w/3)
End if
If ($band>($h/3))
	$band:=Int($h/3)
End if

var $margin : Integer:=Int($h/2)+$step
var $first : Integer:=Int(($y-$margin)/$step)
var $last : Integer:=Int((($y+$h+$margin)/$step))
If ($first<0)
	$first:=0
End if
If ($last>($bands.length-1))
	$last:=$bands.length-1
End if
var $paths : Text:=$bands.slice($first; $last+1).join("")

var $ground : Text:=String($measured.colour[$scheme].windowBackground)
var $ink : Text:=String($measured.colour[$scheme].accent)
var $backdrop : Text:=MN_SkinBack($ground; $ink; Num($measured.material.canvas[$scheme]); \
$canvasW; $canvasH; $paths)

var $rgb : Collection:=MN_Hex($ground)
var $pivot : Real:=((0.299*$rgb[0])+(0.587*$rgb[1])+(0.114*$rgb[2]))/255
var $slope : Real:=Num($lens.contrast)
var $shift : Text:=MN_SkinNum($pivot*(1-$slope); 4)
var $gain : Text:=MN_SkinNum($slope; 3)
var $curve : Text:=$gain+" 0 0 0 "+$shift+" 0 "+$gain+" 0 0 "+$shift
$curve:=$curve+" 0 0 "+$gain+" 0 "+$shift+" 0 0 0 1 0"

var $defs : Text:="<filter id=\"lens\" x=\"-25%\" y=\"-25%\" width=\"150%\" height=\"150%\">"
$defs:=$defs+"<feGaussianBlur stdDeviation=\""+MN_SkinNum(Num($lens.blur); 2)+"\" result=\"b\"/>"
$defs:=$defs+"<feColorMatrix in=\"b\" type=\"saturate\" values=\"" \
+MN_SkinNum(Num($lens.saturate); 2)+"\" result=\"s\"/>"
$defs:=$defs+"<feColorMatrix in=\"s\" type=\"matrix\" values=\""+$curve+"\"/>"
$defs:=$defs+"</filter>"
$defs:=$defs+"<clipPath id=\"panel\">"+MN_SkinRect($x; $y; $w; $h; $corner; "")+"</clipPath>"
$defs:=$defs+"<clipPath id=\"inner\">" \
+MN_SkinRect($x+$band; $y+$band; $w-(2*$band); $h-(2*$band); $corner; "")+"</clipPath>"

var $bleed : Integer:=(Int(Num($lens.blur))*4)+$band
$defs:=$defs+"<clipPath id=\"bleed\">" \
+MN_SkinRect($x-$bleed; $y-$bleed; $w+(2*$bleed); $h+(2*$bleed); 0; "")+"</clipPath>"

$svg:=MN_SkinDoc($w; $h; $x; $y; $w; $h; $defs)

var $centreX : Integer:=$x+Int($w/2)
var $centreY : Integer:=$y+Int($h/2)
var $scale : Text:=MN_SkinNum(Num($lens.magnify); 3)

$svg:=$svg+"<g clip-path=\"url(#panel)\"><g filter=\"url(#lens)\"><g clip-path=\"url(#bleed)\">"
$svg:=$svg+"<g transform=\"translate("+String($centreX)+","+String($centreY)+") scale("+$scale+") "
$svg:=$svg+"translate("+String(-$centreX)+","+String(-$centreY)+")\">"+$backdrop+"</g>"
$svg:=$svg+"<g clip-path=\"url(#inner)\">"+$backdrop+"</g>"
$svg:=$svg+"</g></g></g>"

var $strength : Real:=Num($lens.alpha[$scheme])
If (String($panel.rung)="chrome")
	$strength:=$strength*1.35
	If ($strength>0.95)
		$strength:=0.95
	End if
End if

$svg:=$svg+MN_SkinRect($x; $y; $w; $h; $corner; \
"fill=\""+String($lens.tint)+"\" opacity=\""+MN_SkinNum($strength; 3)+"\"")

var $rim : Object:=$lens.rim
$svg:=$svg+MN_SkinRect($x+$corner; $y; $w-(2*$corner); 1; 0; \
"fill=\""+String($rim.top.tint)+"\" opacity=\""+MN_SkinNum(Num($rim.top[$scheme]); 3)+"\"")
$svg:=$svg+MN_SkinRect($x+$corner; $y+$h-1; $w-(2*$corner); 1; 0; \
"fill=\""+String($rim.bottom.tint)+"\" opacity=\""+MN_SkinNum(Num($rim.bottom[$scheme]); 3)+"\"")

$svg:=$svg+"</svg>"
