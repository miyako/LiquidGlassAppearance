#DECLARE($what : Text)->$answer : Variant

var $all : Collection:=New collection( \
	New object("key"; "fleet"; "title"; "Fleet register"; "noun"; "vessels"; \
	"glyph"; Char(9673)); \
	New object("key"; "charters"; "title"; "Charters"; "noun"; "under way"; \
	"glyph"; Char(9654)); \
	New object("key"; "desk"; "title"; "Desk"; "noun"; "ashore or in yard"; \
	"glyph"; Char(9635)); \
	New object("key"; "laidup"; "title"; "Laid up"; "noun"; "out of service"; \
	"glyph"; Char(9723)))

If (($what="") | ($what="list"))
	$answer:=$all
	return
End if

var $one : Object
For each ($one; $all)
	If (String($one.key)=$what)
		$answer:=$one
		return
	End if
End for each

$answer:=$all[0]
