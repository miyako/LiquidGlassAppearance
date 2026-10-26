// Text of a field that has a Japanese twin (harbor/harborJa ...), following the UI language
#DECLARE($vessel : Object; $field : Text)->$text : Text

$text:=""

If ($vessel=Null)
	return
End if

var $en : Text:=String($vessel[$field])
var $ja : Text:=String($vessel[$field+"Ja"])

If (MN_Lang="ja")
	$text:=Choose($ja=""; $en; $ja)
Else
	$text:=Choose($en=""; $ja; $en)
End if

If (($field="skipper") & ($text="Bareboat"))
	$text:=MN_Label("Skipper"; $text)
End if
