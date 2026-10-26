#DECLARE($text : Text; $width : Integer)->$padded : Text

$padded:=$text

While (Length($padded)<$width)
	$padded:=$padded+" "
End while
