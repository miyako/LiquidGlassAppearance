#DECLARE($vessel : Object; $key : Text; $kind : Text)->$text : Text

var $value : Variant:=$vessel[$key]

Case of
	: (($kind="local") | ($kind="long"))
		$text:=MN_Local($vessel; $key)
	: (($kind="Stage") | ($kind="Type"))
		$text:=MN_Label($kind; String($value))
	: ($kind="money")
		$text:=MN_Yen(Num($value))
	: ($kind="number")
		$text:=String(Int(Num($value)))
	: ($kind="flag")
		$text:=MN_Text(Choose($value=True; "Diff_Yes"; "Diff_No"))
	Else
		$text:=String($value)
End case

If ($text="")
	$text:=MN_Text("Diff_Blank")
End if
