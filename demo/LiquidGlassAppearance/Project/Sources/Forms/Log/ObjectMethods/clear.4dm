var $count : Integer:=Form.entries.length

If ($count=0)
	MN_Alert("Activity"; "There is nothing to clear.")
	return
End if

var $noun : Text:="entries"
If ($count=1)
	$noun:="entry"
End if

If (Not(MN_Confirm("Clear the activity log?"; \
"This removes "+String($count)+" "+$noun+" and cannot be undone. A single entry recording the "+\
"clearance is kept."; "Clear")))
	return
End if

MN_LogClear

var $fresh : Object:=MN_LogData
Form.entries:=$fresh.entries
Form.subtitle:=$fresh.subtitle
