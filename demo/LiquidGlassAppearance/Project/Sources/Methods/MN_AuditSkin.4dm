#DECLARE($audit : Object; $forms : Collection)

var $command : Text:="4D --project Project/Meridian4D.4DProject --headless --dataless "+\
"--skip-onstartup --startup-method MN_SkinMake"

var $rungs : Object:=MN_SkinRungs
var $named : Integer:=0
var $wanted : Collection:=New collection("canvas")

var $entry : Object
For each ($entry; $forms)
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

			If ($rungs[String($object.class)]#Null)
				If ($wanted.indexOf("glass_"+$key)=-1)
					$wanted.push("glass_"+$key)
				End if
			End if

			var $picture : Text:=String($object.picture)
			If ($picture="")
				continue
			End if
			$named:=$named+1
			var $local : 4D.File:=File("/PACKAGE/Resources/"+\
				Replace string($picture; "/RESOURCES/"; ""))
			If (Not($local.exists))
				MN_AuditSay($audit; String($entry.name)+" p"+String($pageIndex)+" "+$key; \
					$picture+" does not exist - the object will draw nothing at all, silently")
			End if
		End for each
	End for each
End for each

If ($named=0)
	$audit.checks.push("skin: no images referenced")
	return
End if

var $file : 4D.File:=File("/PACKAGE/Project/Sources/Methods/MN_SkinList.4dm")
If (Not($file.exists))
	MN_AuditSay($audit; "skin"; $file.fullName+" is missing - run: "+$command)
	return
End if

var $listed : Collection:=New collection
var $hit : Object
For each ($hit; MN_AuditScan("\"([^\"]+)\""; $file.getText()))
	If ($listed.indexOf($hit.groups[0])=-1)
		$listed.push($hit.groups[0])
	End if
End for each

var $missing : Collection:=$wanted.copy().sort()
var $extra : Collection:=$listed.copy().sort()
var $drifted : Boolean:=False

var $name : Text
For each ($name; $missing)
	If ($listed.indexOf($name)=-1)
		$drifted:=True
		MN_AuditSay($audit; "skin"; $name+" is a glass panel in the form but is absent from "+\
			"MN_SkinList, so it will never be skinned. Run: "+$command)
	End if
End for each
For each ($name; $extra)
	If ($wanted.indexOf($name)=-1)
		$drifted:=True
		MN_AuditSay($audit; "skin"; "MN_SkinList names "+$name+", which the form no longer "+\
			"has. MN_Skin would address an object that is not there. Run: "+$command)
	End if
End for each
If ($drifted)
	return
End if

For each ($name; $missing)
	var $stem : Text:="canvas"
	If ($name#"canvas")
		$stem:="glass-"+Substring($name; Length("glass_")+1)
	End if
	var $scheme : Text
	For each ($scheme; New collection("light"; "dark"))
		var $image : 4D.File:=File("/PACKAGE/Resources/"+$stem+"-"+$scheme+".png")
		If (Not($image.exists))
			MN_AuditSay($audit; "skin"; "Resources/"+$stem+"-"+$scheme+".png is missing - "+\
				$name+" would draw nothing in "+$scheme+" mode. Run: "+$command)
		End if
	End for each
End for each

$audit.checks.push("skin: "+String($named)+" images referenced and present, "+\
String($wanted.length-1)+" glass panels listed")
