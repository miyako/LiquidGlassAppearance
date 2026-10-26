#DECLARE($before : Object; $after : Object)->$text : Text

var $fields : Collection:=New collection(\
New object("key"; "name"; "label"; "Diff_Name"; "kind"; "text"); \
New object("key"; "model"; "label"; "Diff_Model"; "kind"; "text"); \
New object("key"; "type"; "label"; "Diff_Type"; "kind"; "Type"); \
New object("key"; "harbor"; "label"; "Diff_Harbour"; "kind"; "local"); \
New object("key"; "flag"; "label"; "Diff_Flag"; "kind"; "local"); \
New object("key"; "skipper"; "label"; "Diff_Skipper"; "kind"; "local"); \
New object("key"; "stage"; "label"; "Diff_Status"; "kind"; "Stage"); \
New object("key"; "year"; "label"; "Diff_Year"; "kind"; "number"); \
New object("key"; "berths"; "label"; "Diff_Berths"; "kind"; "number"); \
New object("key"; "rate"; "label"; "Diff_Rate"; "kind"; "money"); \
New object("key"; "flagship"; "label"; "Diff_Flagship"; "kind"; "flag"); \
New object("key"; "notes"; "label"; "Diff_Notes"; "kind"; "long"))

var $parts : Collection:=New collection

var $field : Object
For each ($field; $fields)
	var $key : Text:=String($field.key)
	var $kind : Text:=String($field.kind)
	var $label : Text:=MN_Text(String($field.label))
	var $was : Text:=MN_VesselShow($before; $key; $kind)
	var $now : Text:=MN_VesselShow($after; $key; $kind)

	If ($was=$now)
		continue
	End if

	If ($kind="long")
		$parts.push(MN_Text("Diff_Changed"; New object("label"; $label)))
	Else
		$parts.push(MN_Text("Diff_FromTo"; New object("label"; $label; "was"; $was; "now"; $now)))
	End if
End for each

If ($parts.length=0)
	$text:=MN_Text("Diff_None")
	return
End if

$text:=$parts.join(MN_Text("Diff_Separator"))
