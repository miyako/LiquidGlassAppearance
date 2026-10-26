#DECLARE($value : Variant; $kind : Text)->$text : Text

Case of
	: ($kind="money")
		$text:=MN_Euro(Num($value))
	: ($kind="number")
		$text:=String(Int(Num($value)))
	: ($kind="flag")
		$text:=Choose($value=True; "yes"; "no")
	Else
		$text:=String($value)
End case

If ($text="")
	$text:="blank"
End if
