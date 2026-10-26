#DECLARE($before : Object; $after : Object)->$text : Text

var $fields : Collection:=New collection(\
New object("key"; "name"; "label"; "Name"; "kind"; "text"); \
New object("key"; "model"; "label"; "Model"; "kind"; "text"); \
New object("key"; "type"; "label"; "Type"; "kind"; "text"); \
New object("key"; "harbor"; "label"; "Harbour"; "kind"; "text"); \
New object("key"; "flag"; "label"; "Flag"; "kind"; "text"); \
New object("key"; "skipper"; "label"; "Skipper"; "kind"; "text"); \
New object("key"; "stage"; "label"; "Status"; "kind"; "text"); \
New object("key"; "year"; "label"; "Year"; "kind"; "number"); \
New object("key"; "berths"; "label"; "Berths"; "kind"; "number"); \
New object("key"; "rate"; "label"; "Rate"; "kind"; "money"); \
New object("key"; "flagship"; "label"; "Flagship"; "kind"; "flag"); \
New object("key"; "notes"; "label"; "Notes"; "kind"; "long"))

var $parts : Collection:=New collection

var $field : Object
For each ($field; $fields)
	var $key : Text:=String($field.key)
	var $kind : Text:=String($field.kind)
	var $was : Text:=MN_VesselShow($before[$key]; $kind)
	var $now : Text:=MN_VesselShow($after[$key]; $kind)

	If ($was=$now)
		continue
	End if

	If ($kind="long")
		$parts.push(String($field.label)+" changed")
	Else
		$parts.push(String($field.label)+" "+$was+" to "+$now)
	End if
End for each

If ($parts.length=0)
	$text:="No field changed"
	return
End if

$text:=$parts.join(", ")
