var $count : Integer:=Form.entries.length

If ($count=0)
	MN_Alert(MN_Text("Log_Title"); MN_Text("AlertNothingToClear"))
	return
End if

var $message : Text:=MN_Text(Choose($count=1; "AlertClearMessageOne"; "AlertClearMessageMany"); \
New object("n"; $count))

If (Not(MN_Confirm(MN_Text("AlertClearTitle"); $message; MN_Text("AlertButtonClear"))))
	return
End if

MN_LogClear

var $fresh : Object:=MN_LogData
Form.entries:=$fresh.entries
Form.subtitle:=$fresh.subtitle
