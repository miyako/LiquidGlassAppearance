#DECLARE($data : Object)->$message : Text

$message:=""

If (Trim(String($data.name))="")
	$message:="A vessel needs a name - it is how the register identifies it."
	return
End if

If (Num($data.rate)<0)
	$message:="The nightly rate cannot be negative."
	return
End if

If (Num($data.berths)<1)
	$message:="A vessel has at least one berth."
	return
End if

var $year : Integer:=Num($data.year)
If (($year<1800) | ($year>2200))
	$message:="Built should be a year, like 2016."
	return
End if
