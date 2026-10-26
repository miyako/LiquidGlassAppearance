#DECLARE($audit : Object; $forms : Collection)

var $colourProps : Collection:=New collection("fill"; "stroke"; "horizontalLineStroke"; \
"verticalLineStroke"; "alternateFill"; "backgroundColor")

var $source : 4D.File:=File("/PACKAGE/reference/measured.json")
If (Not($source.exists))
	MN_AuditSay($audit; "stylesheet"; \
		"reference/measured.json is missing - the sheet is generated FROM it")
	return
End if

var $file : 4D.File:=File("/PACKAGE/Project/Sources/styleSheets_mac.css")
If (Not($file.exists))
	MN_AuditSay($audit; "stylesheet"; $file.fullName+" does not exist - run MN_CssMake")
	return
End if

var $sheet : Object:=MN_CssBuild(JSON Parse($source.getText()))
var $actual : Text:=$file.getText()
var $current : Boolean:=($actual=$sheet.text)

If (Not($current))
	var $mine : Collection:=Split string($actual; Char(Line feed))
	var $want : Collection:=Split string($sheet.text; Char(Line feed))
	var $detail : Text:="the two differ in length"
	var $i : Integer
	For ($i; 0; $mine.length-1)
		If ($i<$want.length)
			If ($mine[$i]#$want[$i])
				$detail:="first difference at line "+String($i+1)
				break
			End if
		End if
	End for
	MN_AuditSay($audit; "stylesheet"; $file.fullName+" is NOT what MN_CssBuild would write ("+\
		$detail+"). It is a generated artifact: hand-edits are lost and a stale copy means "+\
		"the window paints colours nobody measured. Run MN_CssMake")
End if

var $body : Text:=""
var $cursor : Integer:=1
var $comment : Object
For each ($comment; MN_AuditScan("(?s)/\\*.*?\\*/"; $actual))
	$body:=$body+Substring($actual; $cursor; $comment.at-$cursor)
	var $breaks : Integer:=Split string($comment.text; Char(Line feed)).length-1
	var $n : Integer
	For ($n; 1; $breaks)
		$body:=$body+Char(Line feed)
	End for
	$cursor:=$comment.at+Length($comment.text)
End for each
$body:=$body+Substring($actual; $cursor)

var $number : Integer:=0
var $line : Text
For each ($line; Split string($body; Char(Line feed)))
	$number:=$number+1
	var $hit : Object
	For each ($hit; MN_AuditScan("\\b(\\w+)\\s*:\\s*([^;{}]+);"; $line))
		var $prop : Text:=$hit.groups[0]
		var $value : Text:=Trim(Replace string($hit.groups[1]; "!important"; ""))

		If ($colourProps.indexOf($prop)#-1)
			If (MN_AuditScan("^(#[0-9A-Fa-f]{6}|transparent|automatic|automaticAlternate)$"; \
				$value).length=0)
				MN_AuditSay($audit; "stylesheet"; "line "+String($number)+": "+$prop+": '"+\
					$value+"' is not a 6-digit hex or a sanctioned keyword - 4D drops this "+\
					"rule AND every rule after it in the file, silently")
			End if
		Else
			If (MN_AuditScan("^-?\\d+(\\.\\d+)?\\s*(px|pt|em|rem|%|ex|ch|vw|vh)$"; \
				$value).length>0)
				MN_AuditSay($audit; "stylesheet"; "line "+String($number)+": "+$prop+": '"+\
					$value+"' carries a unit - 4D form CSS lengths are unitless, and this is "+\
					"error 555 (xmlc), FATAL: it aborts Open form window and is reported "+\
					"only in a modal dialog")
			End if
		End if
	End for each
End for each

var $stripped : Text:=""
$cursor:=1
For each ($comment; MN_AuditScan("(?s)/\\*.*?\\*/"; $actual))
	$stripped:=$stripped+Substring($actual; $cursor; $comment.at-$cursor)
	$cursor:=$comment.at+Length($comment.text)
End for each
$stripped:=$stripped+Substring($actual; $cursor)

var $bounds : Collection:=New collection(1)
var $media : Object
For each ($media; MN_AuditScan("@media[^{]+\\{"; $stripped))
	$bounds.push($media.at)
	$bounds.push($media.at+Length($media.text))
End for each
$bounds.push(Length($stripped)+1)

var $everywhere : Collection:=Null
var $b : Integer
For ($b; 0; $bounds.length-1; 2)
	var $chunk : Text:=Substring($stripped; $bounds[$b]; $bounds[$b+1]-$bounds[$b])
	var $here : Collection:=New collection
	var $found : Object
	For each ($found; MN_AuditScan("\\.(\\w+)\\s*\\{"; $chunk))
		If ($here.indexOf($found.groups[0])=-1)
			$here.push($found.groups[0])
		End if
	End for each
	If ($everywhere=Null)
		$everywhere:=$here
	Else
		var $both : Collection:=New collection
		var $candidate : Text
		For each ($candidate; $everywhere)
			If ($here.indexOf($candidate)#-1)
				$both.push($candidate)
			End if
		End for each
		$everywhere:=$both
	End if
End for

If ($everywhere=Null)
	$everywhere:=New collection
End if

var $used : Integer:=0
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
			var $class : Text:=String($page.objects[$key].class)
			If ($class="")
				continue
			End if
			If ($everywhere.indexOf($class)#-1)
				$used:=$used+1
			Else
				MN_AuditSay($audit; String($entry.name)+" p"+String($pageIndex)+" "+$key; \
					"names class '"+$class+"', which is not defined in all four blocks of "+\
					$file.fullName+" - add it to MN_CssRoles")
			End if
		End for each
	End for each
End for each

var $state : Text:="DRIFTED"
If ($current)
	$state:="current"
End if
$audit.checks.push("stylesheet: "+String($sheet.classes)+" classes x "+String($sheet.blocks)+\
" blocks from reference/measured.json, "+$state+"; "+String($used)+" form references resolve")
