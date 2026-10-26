#DECLARE($value : Variant)->$text : Text

Case of
	: ($value=Null)
		$text:="null"
	: (Value type($value)=Is collection)
		$text:=JSON Stringify($value)
	: (Value type($value)=Is object)
		$text:=JSON Stringify($value)
	: (Value type($value)=Is boolean)
		$text:=Choose($value; "true"; "false")
	: (Value type($value)=Is text)
		$text:="'"+$value+"'"
	Else
		$text:=String($value)
End case
