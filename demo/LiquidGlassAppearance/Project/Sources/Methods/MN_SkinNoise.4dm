#DECLARE($values : Collection; $cells : Integer; $px : Real; $py : Real)->$height : Real

var $fx : Real:=$px*$cells
var $fy : Real:=$py*$cells
var $x0 : Integer:=Int($fx)
var $y0 : Integer:=Int($fy)

If ($x0>($cells-1))
	$x0:=$cells-1
End if
If ($y0>($cells-1))
	$y0:=$cells-1
End if

var $tx : Real:=$fx-$x0
var $ty : Real:=$fy-$y0
If ($tx>1)
	$tx:=1
End if
If ($ty>1)
	$ty:=1
End if
$tx:=$tx*$tx*(3-(2*$tx))
$ty:=$ty*$ty*(3-(2*$ty))

var $row : Integer:=$y0*($cells+1)
var $v00 : Real:=$values[$row+$x0]
var $v10 : Real:=$values[$row+$x0+1]
var $v01 : Real:=$values[$row+$cells+1+$x0]
var $v11 : Real:=$values[$row+$cells+2+$x0]

var $top : Real:=$v00+(($v10-$v00)*$tx)
var $bottom : Real:=$v01+(($v11-$v01)*$tx)

$height:=$top+(($bottom-$top)*$ty)
