#DECLARE()->$data : Object

$data:=New object
$data.entries:=New collection
$data.scheme:=""
$data.title:="Activity"

var $months : Collection:=New collection(\
"Jan"; "Feb"; "Mar"; "Apr"; "May"; "Jun"; "Jul"; "Aug"; "Sep"; "Oct"; "Nov"; "Dec")

var $stored : Collection:=MN_LogRead
var $index : Integer

For ($index; $stored.length-1; 0; -1)
	var $entry : Object:=$stored[$index]
	var $at : Text:=String($entry.at)

	var $when : Text:=$at
	If (Length($at)>=19)
		var $month : Integer:=Num(Substring($at; 6; 2))
		var $clock : Text:=Substring($at; Length($at)-7)
		If (($month>=1) & ($month<=12))
			$when:=Substring($at; 9; 2)+" "+$months[$month-1]+"  "+Substring($clock; 1; 5)
		End if
	End if

	$data.entries.push(New object(\
	"mark"; MN_LogGlyph(String($entry.action)); \
	"when"; $when; \
	"action"; String($entry.action); \
	"vessel"; String($entry.vessel); \
	"detail"; String($entry.detail)))
End for

var $noun : Text:="entries"
If ($data.entries.length=1)
	$noun:="entry"
End if
$data.subtitle:=String($data.entries.length)+" "+$noun
