#DECLARE()->$lang : Text

$lang:="en"
If (Substring(Get database localization(Current localization); 1; 2)="ja")
	$lang:="ja"
End if
