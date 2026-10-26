#DECLARE($audit : Object; $forms : Collection)

var $bundle : 4D.File:=File(Application file; fk platform path)
var $file : 4D.File:=File($bundle.path+"/Contents/Resources/JSONSchemas/formsSchema.json"; \
fk posix path)

If (Not($file.exists))
	MN_AuditSay($audit; "schema"; "4D's formsSchema.json is not at "+$file.path)
	return
End if

var $schema : Object:=JSON Parse($file.getText())
var $defs : Object:=$schema.definitions

var $shared : Collection:=MN_AuditProps($schema; \
New object("$ref"; "#/definitions/types/objectCommon"))

var $names : Collection:=New collection

var $entry : Object
For each ($entry; $forms)
	var $name : Text:=String($entry.name)
	$names.push($name)

	var $form : Object:=JSON Parse($entry.file.getText())
	If ($form=Null)
		MN_AuditSay($audit; $name; "form.4DForm is not valid JSON")
		continue
	End if

	var $node : Variant:=MN_AuditNode($schema; $schema; "events"; New object())
	If (($node#Null) & ($form.events#Null))
		MN_AuditValue($audit; $name; "events"; $form.events; $schema; $node)
	End if

	var $pageIndex : Integer:=-1
	var $page : Object
	For each ($page; $form.pages)
		$pageIndex:=$pageIndex+1
		If ($page=Null)
			continue
		End if
		If ($page.objects=Null)
			continue
		End if

		var $at : Text:=$name+" p"+String($pageIndex)
		var $order : Collection:=OB Keys($page.objects)

		var $button : Integer:=-1
		var $i : Integer
		For ($i; 0; $order.length-1)
			If ($button=-1)
				If ($page.objects[$order[$i]].defaultButton#Null)
					$button:=$i
				End if
			End if
		End for
		If ($button>=0)
			For ($i; 0; $order.length-1)
				If ($i>$button)
					If (String($page.objects[$order[$i]].dataSourceTypeHint)="picture")
						MN_AuditSay($audit; $at; "picture '"+$order[$i]+"' is declared at "+\
							String($i)+", after the defaultButton at "+String($button)+\
							" - the button will be buried")
					End if
				End if
			End for
		End if

		var $key : Text
		For each ($key; $order)
			var $object : Object:=$page.objects[$key]
			var $spot : Text:=$at+" "+$key
			var $kind : Text:=String($object.type)

			If ($kind="")
				MN_AuditSay($audit; $spot; "declares no type")
				continue
			End if

			var $allowed : Collection:=New collection
			If ($defs[$kind]=Null)
				MN_AuditSay($audit; $spot; "type '"+$kind+"' is not a type 4D defines")
			Else
				$allowed:=MN_AuditProps($schema; $defs[$kind]).combine($shared)
			End if

			If ($allowed.length>0)
				var $prop : Text
				For each ($prop; OB Keys($object))
					If ($allowed.indexOf($prop)=-1)
						MN_AuditSay($audit; $spot; "property '"+$prop+\
							"' is not in 4D's schema for "+$kind)
						continue
					End if
					var $where : Variant:=MN_AuditNode($schema; $defs[$kind]; $prop; New object())
					If ($where=Null)
						$where:=MN_AuditNode($schema; \
							New object("$ref"; "#/definitions/types/objectCommon"); $prop; \
							New object())
					End if
					If ($where#Null)
						MN_AuditValue($audit; $spot; $prop; $object[$prop]; $schema; $where)
					End if
				End for each
			End if

			If ($kind="listbox")
				MN_AuditBox($audit; $spot; $object)
			End if
		End for each
	End for each
End for each

var $said : Text:="none yet"
If ($names.length>0)
	$said:=$names.join(", ")
End if
$audit.checks.push("forms: "+String($forms.length)+" validated ("+$said+")")
