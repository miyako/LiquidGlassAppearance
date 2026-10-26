#DECLARE()->$data : Object

$data:=New object
$data.entries:=New collection
$data.scheme:=""
$data.title:=MN_Text("Log_Title")

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
			var $day : Text:=Substring($at; 9; 2)
			$when:=MN_Text("Log_DateTime"; New object("dd"; $day; "d"; Num($day); \
				"month"; MN_Text("Month_"+String($month)); "time"; Substring($clock; 1; 5)))
		End if
	End if

	$data.entries.push(New object(\
	"mark"; MN_LogGlyph(String($entry.action)); \
	"when"; $when; \
	"action"; MN_Label("Action"; String($entry.action)); \
	"vessel"; String($entry.vessel); \
	"detail"; String($entry.detail)))
End for

$data.subtitle:=MN_Text(Choose($data.entries.length=1; "Log_EntriesOne"; "Log_EntriesMany"); \
New object("n"; $data.entries.length))
