#DECLARE()->$removed : Integer

$removed:=MN_LogRead.length

Try(MN_LogFile.setText(JSON Stringify(New collection; *)))

var $noun : Text:="entries"
If ($removed=1)
	$noun:="entry"
End if
MN_Log("Cleared"; ""; "Removed "+String($removed)+" "+$noun)
