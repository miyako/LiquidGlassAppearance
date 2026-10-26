#DECLARE($verify : Object; $name : Text; $method : Text)->$report : Object

$report:=Null

var $file : 4D.File:=File("/PACKAGE/"+$name)
If (Not($file.exists))
	$verify.problems.push($method+": 4D exited without writing "+$name+\
		". It died before the first marker - the project itself failed to open, or the probe "+\
		"was never run.")
	return
End if

$report:=JSON Parse($file.getText())
If ($report=Null)
	$verify.problems.push($method+": "+$name+" is not valid JSON")
End if

Try($file.delete())
