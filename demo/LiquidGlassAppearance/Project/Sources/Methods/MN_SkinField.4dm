#DECLARE($width : Integer; $height : Integer; $levels : Integer; $step : Integer)->$bands : Collection

var $state : Real:=20260914

var $octaves : Collection:=New collection(6; 13; 29)
var $weights : Collection:=New collection(1; 0.45; 0.2)
var $grids : Collection:=New collection

var $o : Integer
var $i : Integer
For ($o; 0; $octaves.length-1)
	var $cells : Integer:=$octaves[$o]
	var $grid : Collection:=New collection
	For ($i; 0; (($cells+1)*($cells+1))-1)
		$state:=$state*16807
		$state:=$state-(Int($state/2147483647)*2147483647)
		$grid.push($state/2147483647)
	End for
	$grids.push(New object("cells"; $cells; "values"; $grid))
End for

var $cols : Integer:=Int($width/$step)+2
var $rows : Integer:=Int($height/$step)+2
var $field : Collection:=New collection
var $total : Real:=$weights[0]+$weights[1]+$weights[2]

var $cellsA : Integer:=$grids[0].cells
var $cellsB : Integer:=$grids[1].cells
var $cellsC : Integer:=$grids[2].cells
var $valsA : Collection:=$grids[0].values
var $valsB : Collection:=$grids[1].values
var $valsC : Collection:=$grids[2].values
var $wA : Real:=$weights[0]/$total
var $wB : Real:=$weights[1]/$total
var $wC : Real:=$weights[2]/$total

var $gx : Integer
var $gy : Integer
For ($gy; 0; $rows-1)
	var $py : Real:=($gy*$step)/$height
	For ($gx; 0; $cols-1)
		var $px : Real:=($gx*$step)/$width
		$field.push( \
			(MN_SkinNoise($valsA; $cellsA; $px; $py)*$wA)+ \
			(MN_SkinNoise($valsB; $cellsB; $px; $py)*$wB)+ \
			(MN_SkinNoise($valsC; $cellsC; $px; $py)*$wC))
	End for
End for

$bands:=New collection
var $segments : Collection
var $level : Integer
var $cx : Integer
var $cy : Integer

For ($cy; 0; $rows-2)
	$segments:=New collection
	For ($cx; 0; $cols-2)
		var $a : Real:=$field[($cy*$cols)+$cx]
		var $b : Real:=$field[($cy*$cols)+$cx+1]
		var $c : Real:=$field[(($cy+1)*$cols)+$cx+1]
		var $d : Real:=$field[(($cy+1)*$cols)+$cx]
		var $lo : Real:=$a
		var $hi : Real:=$a
		If ($b<$lo)
			$lo:=$b
		End if
		If ($c<$lo)
			$lo:=$c
		End if
		If ($d<$lo)
			$lo:=$d
		End if
		If ($b>$hi)
			$hi:=$b
		End if
		If ($c>$hi)
			$hi:=$c
		End if
		If ($d>$hi)
			$hi:=$d
		End if
		var $first : Integer:=Int($lo*$levels)
		var $last : Integer:=Int($hi*$levels)
		For ($level; $first; $last)
			var $t : Real:=$level/$levels
			If (($t>$lo) & ($t<$hi))
				$segments.push(MN_SkinCell($cx*$step; $cy*$step; $step; $a; $b; $c; $d; $t))
			End if
		End for
	End for
	$bands.push($segments.join(""))
End for
