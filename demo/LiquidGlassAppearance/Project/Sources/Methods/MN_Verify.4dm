var $file : 4D.File:=File("/PACKAGE/verify.json")
var $verify : Object:=New object("problems"; New collection; "checks"; New collection)

var $measured : 4D.File:=File("/PACKAGE/reference/measured.json")
If (Not($measured.exists))
	$verify.problems.push("verify: reference/measured.json is missing - there is nothing to "+\
		"check the app against")
	Try($file.setText(JSON Stringify($verify; *)))
	QUIT 4D
	return
End if
var $want : Object:=JSON Parse($measured.getText()).acceptance

var $compile : Object:=MN_VerifyRead($verify; "compile.json"; "MN_ProbeCompile")
If ($compile#Null)
	Case of
		: (String($compile.stage)#"after")
			$verify.problems.push("compile: 4D stopped during Compile project - the report "+\
				"never got past its 'before' marker")
		: ($compile.success#True)
			var $error : Object
			For each ($error; $compile.errors)
				var $code : Object:=$error.code
				var $where : Text:="?"
				If ($code#Null)
					If (String($code.path)#"")
						$where:=String($code.path)
					Else
						If (String($code.objectName)#"")
							$where:=String($code.objectName)
						End if
					End if
				End if
				$verify.problems.push("compile: "+$where+" line "+String(Num($error.line))+\
					": "+String($error.message))
			End for each
			If ($compile.errors.length=0)
				$verify.problems.push("compile: reported failure with no errors listed")
			End if
		Else
			$verify.checks.push("compile : clean, "+String($compile.errors.length)+" errors")
	End case
End if

var $form : Object:=MN_VerifyRead($verify; "formprobe.json"; "MN_ProbeForm")
If ($form#Null)
	If ((String($form.stage)#"unloaded") | ($form.ok#True))
		$verify.problems.push("form: FORM LOAD stopped at "+MN_AuditShow($form.stage)+\
			" - that form did not parse, and 4D did not survive it")
	Else
		var $loaded : Collection:=$form.loaded.copy().sort()
		var $onDisk : Collection:=New collection
		var $entry : Object
		For each ($entry; MN_AuditFormList)
			$onDisk.push(String($entry.name))
		End for each
		If (JSON Stringify($loaded)#JSON Stringify($onDisk.sort()))
			$verify.problems.push("form: 4D loaded "+JSON Stringify($loaded)+\
				" but the project has "+JSON Stringify($onDisk))
		Else
			$verify.checks.push("form    : "+$loaded.join(", ")+" parse and unload")
		End if
	End if
End if

var $probe : Object:=MN_VerifyRead($verify; "probe.json"; "MN_Probe")
If ($probe#Null)
	var $found : Collection:=MN_VerifyLogic($probe; $want)
	$verify.problems:=$verify.problems.combine($found)

	If ($found.length=0)
		var $before : Object:=MN_VerifyNav($probe.nav)
		var $after : Object:=MN_VerifyNav($probe.charterNav)

		$verify.checks.push("logic   : "+String(Num($probe.fleet))+" vessels, "+\
			String($probe.util)+" utilisation, "+String($probe.committed)+", nav "+\
			$probe.nav.join("/"))
		$verify.checks.push("charter : Argonaut "+String($probe.charterBefore)+" -> "+\
			String($probe.charterAfter)+"; "+String($probe.util)+" -> "+\
			String($probe.charterUtil)+", "+String($probe.committed)+" -> "+\
			String($probe.charterCommitted)+", charters "+String(Num($before.charters))+\
			" -> "+String(Num($after.charters)))
		$verify.checks.push("persist : saved and reloaded "+String(Num($probe.savedCount))+\
			" vessels; Argonaut came back "+MN_AuditShow($probe.savedStage))
		$verify.checks.push("vessel  : sheet round-trips "+String($probe.roundName)+\
			" with rate "+String(Num($probe.roundRate))+\
			" intact; a blank sheet is refused")
	End if
End if

$verify.clean:=($verify.problems.length=0)
Try($file.setText(JSON Stringify($verify; *)))

QUIT 4D
