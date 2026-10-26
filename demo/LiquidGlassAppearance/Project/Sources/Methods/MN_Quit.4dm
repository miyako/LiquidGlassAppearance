#DECLARE()->$closed : Integer

$closed:=0

var $activity : Object:=Process activity
var $process : Object

For each ($process; $activity.processes)
	If (Position("Meridian "; String($process.name))=1)
		Try(POST OUTSIDE CALL(Num($process.number)))
		$closed:=$closed+1
	End if
End for each

If (Is compiled mode)
	QUIT 4D
End if
