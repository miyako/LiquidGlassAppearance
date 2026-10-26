var $scheme : Text:=String(Form.scheme)

If ($scheme#"dark")
	$scheme:="light"
End if

var $base : Text
var $each : Variant

For each ($each; MN_SkinList)
	$base:=String($each)
	Try(OBJECT SET VISIBLE(*; $base+"_light"; ($scheme="light")))
	Try(OBJECT SET VISIBLE(*; $base+"_dark"; ($scheme="dark")))
End for each
