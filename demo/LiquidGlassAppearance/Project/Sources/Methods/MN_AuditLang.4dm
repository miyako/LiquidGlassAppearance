#DECLARE($audit : Object)

var $files : Collection:=MN_AuditFiles

var $methods : Collection:=New collection
var $file : 4D.File
For each ($file; $files)
	If (Position("/Methods/"; $file.path)>0)
		$methods.push($file.name)
	End if
End for each

var $openers : Collection:=New collection(\
	New object("rx"; "^For each\\s*\\("; "kind"; "foreach"); \
	New object("rx"; "^For\\s*\\("; "kind"; "for"); \
	New object("rx"; "^While\\s*\\("; "kind"; "while"); \
	New object("rx"; "^If\\s*\\("; "kind"; "if"); \
	New object("rx"; "^Case of\\b"; "kind"; "case"); \
	New object("rx"; "^Use\\s*\\("; "kind"; "use"))

var $closers : Collection:=New collection(\
	New object("text"; "End for each"; "kind"; "foreach"); \
	New object("text"; "End for"; "kind"; "for"); \
	New object("text"; "End while"; "kind"; "while"); \
	New object("text"; "End if"; "kind"; "if"); \
	New object("text"; "End case"; "kind"; "case"); \
	New object("text"; "End use"; "kind"; "use"))

For each ($file; $files)
	var $source : Text:=$file.getText()
	var $lines : Collection:=Split string($source; Char(Line feed))
	var $where : Text:=Substring($file.path; Length(Folder("/PACKAGE/Project/Sources").path)+1)

	var $code : Collection:=New collection
	var $line : Text
	For each ($line; $lines)
		If (Position("//"; Trim($line))#1)
			$code.push($line)
		End if
	End for each
	var $joined : Text:=$code.join(Char(Line feed))

	var $odd : Collection:=MN_AuditScan("[^\\x{0000}-\\x{007F}]"; $source)
	If ($odd.length>0)
		MN_AuditSay($audit; $where; "non-ASCII character "+\
			MN_AuditHex(Character code($odd[0].text))+" - use Char() instead")
	End if

	var $stack : Collection:=New collection
	var $number : Integer:=0
	For each ($line; $lines)
		$number:=$number+1
		var $trimmed : Text:=Trim($line)
		If (Position("//"; $trimmed)=1)
			continue
		End if

		var $opened : Boolean:=False
		var $opener : Object
		For each ($opener; $openers)
			If (Not($opened))
				If (MN_AuditScan(String($opener.rx); $trimmed).length>0)
					$stack.push(New object("kind"; String($opener.kind); "line"; $number))
					$opened:=True
				End if
			End if
		End for each
		If ($opened)
			continue
		End if

		var $closed : Boolean:=False
		var $closer : Object
		For each ($closer; $closers)
			If (Not($closed))
				If (Position(String($closer.text); $trimmed)=1)
					$closed:=True
					If ($stack.length=0)
						MN_AuditSay($audit; $where; "line "+String($number)+": '"+\
							String($closer.text)+"' closes nothing")
					Else
						var $open : Object:=$stack.pop()
						If (String($open.kind)#String($closer.kind))
							MN_AuditSay($audit; $where; "line "+String($number)+": '"+\
								String($closer.text)+"' closes a '"+String($open.kind)+\
								"' opened at line "+String($open.line)+" - 4D will NOT "+\
								"reject this, it will silently re-nest the method")
						End if
					End if
				End if
			End if
		End for each
	End for each
	If ($stack.length>0)
		MN_AuditSay($audit; $where; "unclosed "+String($stack[$stack.length-1].kind)+\
			" opened at line "+String($stack[$stack.length-1].line))
	End if

	var $i : Integer
	For ($i; 0; $lines.length-2)
		If (Position("//"; Trim($lines[$i]))#1)
			var $tail : Text:=Trim($lines[$i])
			If (Substring($tail; Length($tail); 1)="\\")
				If (Position("//"; Trim($lines[$i+1]))=1)
					MN_AuditSay($audit; $where; "line "+String($i+2)+\
						": a comment breaks a line continuation")
				End if
			End if
		End if
	End for

	var $names : Object:=New object
	var $declare : Collection:=MN_AuditScan("#DECLARE\\(([^)]*)\\)"; $joined)
	If ($declare.length>0)
		var $param : Object
		For each ($param; MN_AuditScan("(\\$\\w+)\\s*:\\s*([\\w.]+)"; $declare[0].groups[0]))
			MN_AuditName($names; $param.groups[0]; $param.groups[1])
		End for each
	End if
	For each ($line; $code)
		var $declared : Collection:=MN_AuditScan("^\\s*var\\s+(\\$\\w+)\\s*:\\s*([\\w.]+)"; $line)
		If ($declared.length>0)
			MN_AuditName($names; $declared[0].groups[0]; $declared[0].groups[1])
		End if
	End for each

	var $key : Text
	For each ($key; OB Keys($names))
		var $entry : Object:=$names[$key]
		If ($entry.spellings.length>1)
			MN_AuditSay($audit; $where; $key+" is declared as "+\
				MN_AuditList($entry.spellings)+" - 4D variable names are CASE-INSENSITIVE, "+\
				"these are one variable")
		Else
			If ($entry.types.length>1)
				MN_AuditSay($audit; $where; $key+" is declared as "+MN_AuditList($entry.types))
			End if
		End if
	End for each

	var $trig : Collection:=MN_AuditScan("\\bArc(sin|cos)\\b"; $joined)
	If ($trig.length>0)
		MN_AuditSay($audit; $where; "uses "+$trig[0].text+\
			" - 4D has no inverse sine or cosine. asin(v) = Arctan(v/Square root(1-v*v))")
	End if
	If (MN_AuditScan("[)\\w]\\^"; $joined).length>0)
		MN_AuditSay($audit; $where; \
			"uses the ^ operator - use Exp(g*Log(s)), the checked exponent path")
	End if

	MN_AuditReal($audit; $where; $code; $joined)

	var $called : Collection:=New collection
	var $hit : Object
	For each ($hit; MN_AuditScan("\\bMN_\\w+"; $joined))
		If ($called.indexOf($hit.text)=-1)
			$called.push($hit.text)
		End if
	End for each
	var $name : Text
	For each ($name; $called.sort())
		If ($methods.indexOf($name)=-1)
			If ($file.name#$name)
				MN_AuditSay($audit; $where; "calls "+$name+\
					", which is not a method in this project")
			End if
		End if
	End for each
End for each

$audit.checks.push("language: "+String($files.length)+" source files")
