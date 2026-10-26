#DECLARE($count : Integer; $word : Text)->$text : Text

$text:=$word
If ($count#1)
	$text:=$word+"s"
End if
