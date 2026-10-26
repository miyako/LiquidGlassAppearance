#DECLARE($audit : Object; $forms : Collection)

var $interactive : Collection:=New collection("listbox"; "button"; "tab")
var $controls : Collection:=New collection("dropdown"; "checkbox"; "radio"; "input")

var $live : Integer:=0

var $entry : Object
For each ($entry; $forms)
	var $name : Text:=String($entry.name)
	var $folder : 4D.Folder:=$entry.file.parent
	var $form : Object:=JSON Parse($entry.file.getText())

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

		var $key : Text
		For each ($key; OB Keys($page.objects))
			var $object : Object:=$page.objects[$key]
			var $kind : Text:=String($object.type)
			var $spot : Text:=$name+" p"+String($pageIndex)+" "+$key

			var $editable : Boolean:=False
			If ($kind="input")
				$editable:=(($object.enterable#False) & \
					(String($object.dataSourceTypeHint)#"picture") & ($object.dataSource=Null))
			End if
			var $unbound : Boolean:=False
			If (($controls.indexOf($kind)#-1) & ($kind#"input"))
				$unbound:=($object.dataSource=Null)
			End if

			var $display : Boolean:=False
			If ($kind="listbox")
				$display:=(String($object.selectionMode)="none")
			End if

			If ((($interactive.indexOf($kind)=-1) | $display) & Not($editable) & Not($unbound))
				continue
			End if
			$live:=$live+1

			var $method : Text:=String($object.method)
			Case of
				: ($method="")
					MN_AuditSay($audit; $spot; "is interactive but declares no method - "+\
						"clicking it will do nothing")
				: (Not($folder.file($method).exists))
					MN_AuditSay($audit; $spot; "names "+$method+", which does not exist")
			End case

			var $wired : Boolean:=False
			If (Value type($object.events)=Is collection)
				$wired:=($object.events.length>0)
			End if
			If (Not($wired))
				MN_AuditSay($audit; $spot; "declares no events - a 4D form only fires the "+\
					"events an object DECLARES, so its method is never called")
			End if
		End for each
	End for each
End for each

$audit.checks.push("wiring: "+String($live)+" interactive objects, all wired")
