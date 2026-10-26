#DECLARE($data : Object)->$message : Text

$message:=""

If (Trim(String($data.name))="")
	$message:=MN_Text("Vessel_NeedName")
	return
End if

If (Num($data.rate)<0)
	$message:=MN_Text("Vessel_NegativeRate")
	return
End if

If (Num($data.berths)<1)
	$message:=MN_Text("Vessel_NeedBerth")
	return
End if

var $year : Integer:=Num($data.year)
If (($year<1800) | ($year>2200))
	$message:=MN_Text("Vessel_BadYear")
	return
End if
