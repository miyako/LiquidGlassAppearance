#DECLARE()->$files : Collection

$files:=New collection

var $root : 4D.Folder:=Folder("/PACKAGE/Project/Sources")
If (Not($root.exists))
	return
End if

var $file : 4D.File
For each ($file; $root.files(fk recursive))
	If ($file.extension=".4dm")
		$files.push($file)
	End if
End for each

$files:=$files.orderBy("path asc")
