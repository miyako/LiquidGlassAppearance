#DECLARE($what : Text)->$answer : Variant

var $all : Collection:=New collection( \
	New object("key"; "fleet"; "glyph"; Char(9673)); \
	New object("key"; "charters"; "glyph"; Char(9654)); \
	New object("key"; "desk"; "glyph"; Char(9635)); \
	New object("key"; "laidup"; "glyph"; Char(9723)))

var $one : Object
For each ($one; $all)
	$one.title:=MN_Text("Section_"+String($one.key)+"_Title")
End for each

If (($what="") | ($what="list"))
	$answer:=$all
	return
End if

For each ($one; $all)
	If (String($one.key)=$what)
		$answer:=$one
		return
	End if
End for each

$answer:=$all[0]
