#DECLARE($stage : Text; $what : Text)->$answer : Variant

var $mark : Text:=""
var $accent : Boolean:=False
var $afloat : Boolean:=False
var $committed : Boolean:=False

Case of
	: ($stage="Available")
		$mark:=Char(9675)
		$afloat:=True
	: ($stage="On charter")
		$mark:=Char(9679)
		$afloat:=True
		$committed:=True
	: ($stage="Turnaround")
		$mark:=Char(9680)
		$afloat:=True
		$committed:=True
		$accent:=True
	: ($stage="In refit")
		$mark:=Char(9633)
	: ($stage="Laid up")
		$mark:=Char(9632)
	Else
		$mark:=Char(63)
End case

Case of
	: ($what="accent")
		$answer:=$accent
	: ($what="afloat")
		$answer:=$afloat
	: ($what="committed")
		$answer:=$committed
	Else
		$answer:=$mark
End case
