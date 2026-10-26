#DECLARE($data : Object)->$vessel : Object

var $base : Object:=$data.base
If ($base=Null)
	$base:=New object
End if

$vessel:=New object( \
	"name"; Trim(String($data.name)); \
	"model"; Trim(String($data.model)); \
	"type"; MN_ChoiceKey($data.typeList; Trim(String($data.type))); \
	"year"; Num($data.year); \
	"stage"; MN_ChoiceKey($data.stageList; String($data.stage)); \
	"rate"; Num($data.rate); \
	"berths"; Num($data.berths); \
	"flagship"; ($data.flagship=True))

// The sheet edits the text of the current UI language; the other language is kept
var $ja : Boolean:=(MN_Lang="ja")
var $field : Text
var $value : Text
For each ($field; New collection("harbor"; "flag"; "skipper"; "notes"))
	$value:=Trim(String($data[$field]))
	If ($ja)
		$vessel[$field]:=String($base[$field])
		$vessel[$field+"Ja"]:=$value
	Else
		$vessel[$field]:=$value
		$vessel[$field+"Ja"]:=String($base[$field+"Ja"])
	End if
End for each

// "Bareboat" is a key shown translated; it is never stored as Japanese text
var $skipper : Text:=Trim(String($data.skipper))
Case of
	: (($skipper="Bareboat") | ($skipper=MN_Label("Skipper"; "Bareboat")))
		$vessel.skipper:="Bareboat"
		$vessel.skipperJa:=""
	: ($ja & ($vessel.skipper="Bareboat"))
		$vessel.skipper:=""
End case
