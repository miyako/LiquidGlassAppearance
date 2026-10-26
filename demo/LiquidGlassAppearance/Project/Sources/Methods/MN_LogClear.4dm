#DECLARE()->$removed : Integer

$removed:=MN_LogRead.length

Try(MN_LogFile.setText(JSON Stringify(New collection; *)))

MN_Log("Cleared"; ""; MN_Text(Choose($removed=1; "Log_RemovedOne"; "Log_RemovedMany"); \
New object("n"; $removed)))
