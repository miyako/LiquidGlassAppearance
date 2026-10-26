#DECLARE($audit : Object; $forms : Collection)

var $file : 4D.File:=File("/PACKAGE/Project/Sources/Methods/MN_Column.4dm")
If (Not($file.exists))
	return
End if

var $source : Text:=Replace string($file.getText(); "\\"+Char(Line feed); " ")

var $entries : Collection:=New collection
var $literal : Object
For each ($literal; MN_AuditScan("(?s)New object\\((.*?)\\)\\)?"; $source))
	var $parts : Collection:=Split string($literal.groups[0]; ";")
	If ($parts.length<4)
		continue
	End if
	var $entry : Object:=New object
	var $i : Integer
	For ($i; 0; $parts.length-2; 2)
		var $key : Text:=Replace string(Trim($parts[$i]); "\""; "")
		var $value : Text:=Trim($parts[$i+1])
		If (Substring($value; 1; 1)="\"")
			$entry[$key]:=Replace string($value; "\""; "")
		End if
	End for
	If ($entry.key#Null)
		$entries.push($entry)
	End if
End for each

If ($entries.length=0)
	MN_AuditSay($audit; "MN_Column"; \
		"no column literals could be read out of it - has its shape changed?")
	return
End if

var $measured : Collection:=JSON Parse(\
File("/PACKAGE/reference/measured.json").getText()).geometry.columns

If (MN_AuditKeys($entries; "key")#MN_AuditKeys($measured; "key"))
	MN_AuditSay($audit; "MN_Column"; "lists "+MN_AuditList2($entries; "key")+\
		", but measured.json has "+MN_AuditList2($measured; "key"))
	return
End if

var $index : Integer
For ($index; 0; $entries.length-1)
	If (String($entries[$index].title)#String($measured[$index].title))
		MN_AuditSay($audit; "MN_Column"; String($entries[$index].key)+" is titled '"+\
			String($entries[$index].title)+"', measured '"+String($measured[$index].title)+"'")
	End if
End for

var $entry2 : Object
For each ($entry2; $forms)
	var $form : Object:=JSON Parse($entry2.file.getText())
	var $page : Object
	For each ($page; $form.pages)
		If ($page=Null)
			continue
		End if
		If ($page.objects=Null)
			continue
		End if
		var $objectName : Text
		For each ($objectName; OB Keys($page.objects))
			var $object : Object:=$page.objects[$objectName]
			If (String($object.dataSource)#"Form:C1466.rows")
				continue
			End if

			var $names : Collection:=New collection
			var $heads : Collection:=New collection
			var $column : Object
			For each ($column; $object.columns)
				$names.push(String($column.name))
				$heads.push(String($column.header.name))
			End for each

			If (MN_AuditKeys($names; "")#MN_AuditKeys($entries; "name"))
				MN_AuditSay($audit; "MN_Column"; "names "+MN_AuditList2($entries; "name")+\
					", but the form names its columns "+MN_AuditList2($names; "")+\
					" - a header click will match nothing and sort silently do nothing")
			End if
			If (MN_AuditKeys($heads; "")#MN_AuditKeys($entries; "header"))
				MN_AuditSay($audit; "MN_Column"; "names headers "+\
					MN_AuditList2($entries; "header")+", but the form's are "+\
					MN_AuditList2($heads; ""))
			End if
		End for each
	End for each
End for each

var $stage : 4D.File:=File("/PACKAGE/Project/Sources/Methods/MN_Stage.4dm")
If ($stage.exists)
	var $states : Collection:=New collection
	var $hit : Object
	For each ($hit; MN_AuditScan("\\(\\$stage=\"([^\"]+)\"\\)"; $stage.getText()))
		$states.push($hit.groups[0])
	End for each

	For each ($entry2; $forms)
		var $form2 : Object:=JSON Parse($entry2.file.getText())
		var $pageIndex : Integer:=-1
		var $page2 : Object
		For each ($page2; $form2.pages)
			$pageIndex:=$pageIndex+1
			If ($page2=Null)
				continue
			End if
			If ($page2.objects=Null)
				continue
			End if
			var $key2 : Text
			For each ($key2; OB Keys($page2.objects))
				var $object2 : Object:=$page2.objects[$key2]
				If (String($object2.type)#"dropdown")
					continue
				End if
				var $binds : Text:=String($object2.dataSource)
				If (Substring($binds; Length($binds)-5)#".stage")
					continue
				End if
				If (JSON Stringify($object2.choiceList)#JSON Stringify($states))
					MN_AuditSay($audit; String($entry2.name)+" p"+String($pageIndex)+" "+$key2; \
						"offers "+MN_AuditShow($object2.choiceList)+", but MN_Stage knows "+\
						JSON Stringify($states)+". A state the dropdown offers and MN_Stage "+\
						"does not is a vessel with no glyph and no section - MN_Stage answers "+\
						"'unknown' for it")
				End if
			End for each
		End for each
	End for each
End if

var $sortable : Integer:=0
var $each : Object
For each ($each; $entries)
	If (String($each.field)#"")
		$sortable:=$sortable+1
	End if
End for each

$audit.checks.push("columns: "+String($entries.length)+" columns agree across MN_Column, the "+\
"form and reference/measured.json; "+String($sortable)+" sortable")
