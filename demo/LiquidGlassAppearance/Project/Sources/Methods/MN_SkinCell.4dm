#DECLARE($x : Real; $y : Real; $step : Real; \
$a : Real; $b : Real; $c : Real; $d : Real; $level : Real)->$path : Text

$path:=""

var $code : Integer:=0
If ($a>$level)
	$code:=$code+8
End if
If ($b>$level)
	$code:=$code+4
End if
If ($c>$level)
	$code:=$code+2
End if
If ($d>$level)
	$code:=$code+1
End if

If (($code=0) | ($code=15))
	return
End if

var $tx : Real:=$x+(MN_SkinLerp($a; $b; $level)*$step)
var $ty : Real:=$y
var $rx : Real:=$x+$step
var $ry : Real:=$y+(MN_SkinLerp($b; $c; $level)*$step)
var $bx : Real:=$x+(MN_SkinLerp($d; $c; $level)*$step)
var $by : Real:=$y+$step
var $lx : Real:=$x
var $ly : Real:=$y+(MN_SkinLerp($a; $d; $level)*$step)

Case of
	: ($code=1) | ($code=14)
		$path:=MN_SkinSeg($lx; $ly; $bx; $by)
	: ($code=2) | ($code=13)
		$path:=MN_SkinSeg($bx; $by; $rx; $ry)
	: ($code=3) | ($code=12)
		$path:=MN_SkinSeg($lx; $ly; $rx; $ry)
	: ($code=4) | ($code=11)
		$path:=MN_SkinSeg($tx; $ty; $rx; $ry)
	: ($code=6) | ($code=9)
		$path:=MN_SkinSeg($tx; $ty; $bx; $by)
	: ($code=7) | ($code=8)
		$path:=MN_SkinSeg($lx; $ly; $tx; $ty)
	: ($code=5)
		$path:=MN_SkinSeg($lx; $ly; $tx; $ty)+MN_SkinSeg($bx; $by; $rx; $ry)
	: ($code=10)
		$path:=MN_SkinSeg($tx; $ty; $rx; $ry)+MN_SkinSeg($lx; $ly; $bx; $by)
End case
