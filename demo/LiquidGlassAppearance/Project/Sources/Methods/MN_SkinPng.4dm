#DECLARE($svg : Text; $path : Text)->$bytes : Integer

$bytes:=0

var $ref : Text:=String(Try(DOM Parse XML variable($svg)))

If ($ref="")
	return
End if

var $picture : Picture
Try(SVG EXPORT TO PICTURE($ref; $picture; Copy XML data source))
Try(DOM CLOSE XML($ref))

var $blob : Blob
Try(PICTURE TO BLOB($picture; $blob; ".png"))
$bytes:=BLOB size($blob)

If ($bytes>0)
	Try(File($path).setContent($blob))
End if
