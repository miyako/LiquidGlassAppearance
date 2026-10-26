#DECLARE()->$forms : Collection

$forms:=New collection

var $root : 4D.Folder:=Folder("/PACKAGE/Project/Sources/Forms")
If (Not($root.exists))
	return
End if

var $folder : 4D.Folder
For each ($folder; $root.folders())
	var $file : 4D.File:=$folder.file("form.4DForm")
	If ($file.exists)
		$forms.push(New object("name"; $folder.name; "file"; $file))
	End if
End for each

$forms:=$forms.orderBy("name asc")
