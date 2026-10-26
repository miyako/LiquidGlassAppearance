#DECLARE($names : Object; $spelling : Text; $type : Text)

var $key : Text:=Lowercase($spelling)

If ($names[$key]=Null)
	$names[$key]:=New object("spellings"; New collection; "types"; New collection)
End if

If ($names[$key].spellings.indexOf($spelling)=-1)
	$names[$key].spellings.push($spelling)
End if
If ($names[$key].types.indexOf($type)=-1)
	$names[$key].types.push($type)
End if
