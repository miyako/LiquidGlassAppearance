#DECLARE($action : Text; $vessel : Text; $detail : Text)

var $limit : Integer:=500

var $stamp : Text:=Substring(String(Current date; ISO date); 1; 10)+\
" "+String(Current time; HH MM SS)

var $entries : Collection:=MN_LogRead
$entries.push(New object(\
"at"; $stamp; \
"action"; $action; \
"vessel"; $vessel; \
"detail"; $detail))

If ($entries.length>$limit)
	$entries:=$entries.slice($entries.length-$limit)
End if

Try(MN_LogFile.setText(JSON Stringify($entries; *)))
