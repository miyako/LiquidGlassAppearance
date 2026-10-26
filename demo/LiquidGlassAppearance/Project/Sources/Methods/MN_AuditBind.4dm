#DECLARE($audit : Object; $forms : Collection)

var $total : Integer:=0

var $entry : Object
For each ($entry; $forms)
	var $name : Text:=String($entry.name)
	var $bound : Collection:=New collection

	var $form : Object:=JSON Parse($entry.file.getText())
	var $page : Object
	For each ($page; $form.pages)
		If ($page#Null)
			If ($page.objects#Null)
				var $key : Text
				For each ($key; OB Keys($page.objects))
					MN_AuditBound($page.objects[$key]; $bound)
				End for each
			End if
		End if
	End for each

	If ($bound.length=0)
		continue
	End if
	$bound:=$bound.sort()
	$total:=$total+$bound.length

	var $builder : Text:="MN_Data"
	If ($name#"Main")
		$builder:="MN_"+$name+"Data"
	End if

	var $file : 4D.File:=File("/PACKAGE/Project/Sources/Methods/"+$builder+".4dm")
	If (Not($file.exists))
		MN_AuditSay($audit; "bindings"; $name+" binds "+String($bound.length)+\
			" Form properties but its builder "+$builder+".4dm does not exist")
		continue
	End if

	var $built : Text:=$file.getText()
	var $prop : Text
	For each ($prop; $bound)
		If (Position("."+$prop+":="; $built)=0)
			MN_AuditSay($audit; "bindings"; $name+": Form."+$prop+" is bound but never built "+\
				"in "+$builder+" - a collection list box and an input BOTH bind their "+\
				"dataSource before On Load runs, so it arrives Null")
		End if
	End for each
End for each

$audit.checks.push("bindings: "+String($total)+" Form properties across "+\
String($forms.length)+" form(s), all built")
