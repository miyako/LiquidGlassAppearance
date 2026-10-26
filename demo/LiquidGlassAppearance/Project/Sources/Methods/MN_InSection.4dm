#DECLARE($vessel : Object; $key : Text)->$belongs : Boolean

$belongs:=False

If ($vessel=Null)
	return
End if

var $stage : Text:=String($vessel.stage)

Case of
	: ($key="fleet")
		$belongs:=True
	: ($key="charters")
		$belongs:=($stage="On charter")
	: ($key="desk")
		$belongs:=(($stage="In refit") | ($stage="Turnaround"))
	: ($key="laidup")
		$belongs:=($stage="Laid up")
End case
