#DECLARE($action : Text)->$glyph : Text

Case of
	: ($action="Chartered")
		$glyph:=Char(9654)
	: ($action="Added")
		$glyph:=Char(9673)
	: ($action="Edited")
		$glyph:=Char(9635)
	: ($action="Deleted")
		$glyph:=Char(9723)
	: ($action="Cleared")
		$glyph:=Char(9711)
	Else
		$glyph:=Char(183)
End case
