#DECLARE($measured : Object)->$sheet : Object

$sheet:=New object("problems"; New collection)

var $roles : Collection:=MN_CssRoles
var $blocks : Collection:=MN_CssBlocks
var $lines : Collection:=New collection

var $dashes : Text:=""
While (Length($dashes)<96)
	$dashes:=$dashes+"-"
End while

var $width : Integer:=0
var $role : Object
For each ($role; $roles)
	If (Length(String($role.name))>$width)
		$width:=Length(String($role.name))
	End if
End for each

$lines.push("/* Meridian4D - the whole design, generated. DO NOT HAND-EDIT THIS FILE.")
$lines.push("")
$lines.push(MN_CssWrap("Every value below is rendered from reference/measured.json by "+\
"MN_CssBuild. Nothing here was typed by a person: a hex in this file that is not in that one "+\
"is a bug in the generator, and MN_Audit fails the build if the two ever disagree. To change a "+\
"colour or a size, change the measurement and run MN_CssMake."; 94; "   "))
$lines.push("")
$lines.push(MN_CssWrap("FOUR BLOCKS, AND THE ORDER MATTERS. 4D understands two media grammars, "+\
"and on 21 R3/R4 a liquid-glass block outranks a bare prefers-color-scheme block - so the same "+\
"values are stated twice, and the liquid-glass pair comes last. Blocks 1 and 2 alone would "+\
"render unthemed on this build; blocks 3 and 4 alone would render unthemed on anything older."; \
94; "   "))
$lines.push("")
$lines.push(MN_CssWrap("NO ALPHA, AT ANY SYNTAX, AND NO UNITS. 4D's form-CSS parser takes "+\
"6-digit hex and nothing else - rgba(), hsla() and 8-digit hex do not fail loudly, they "+\
"silently truncate every rule after them. Lengths are unitless, and a `px` is error 555 and "+\
"fatal. The macOS label colours carry alpha, so measured.json stores them already composited "+\
"over their own ground."; 94; "   "))
$lines.push("")
$lines.push(MN_CssWrap("The classes are named for the ROLE each plays in the window, never for "+\
"the colour it currently is. What each one is for is written beside it below."; 94; "   "))
$lines.push("*/")

var $block : Object
For each ($block; $blocks)
	var $title : Text:=String($block.title)
	var $run : Integer:=90-Length($title)
	If ($run<3)
		$run:=3
	End if

	$lines.push("")
	$lines.push("/* ---- "+$title+" "+Substring($dashes; 1; $run)+" */")
	$lines.push("/*")
	$lines.push(MN_CssWrap(String($block.note); 94; "   "))
	$lines.push("*/")

	var $inside : Boolean:=(String($block.condition)#"")
	If ($inside)
		$lines.push("@media "+String($block.condition)+" {")
	End if

	For each ($role; $roles)
		var $body : Collection:=New collection
		var $spec : Text
		For each ($spec; $role.props)
			var $cut : Integer:=Position(" "; $spec)
			var $prop : Text:=Substring($spec; 1; $cut-1)
			var $rest : Text:=Substring($spec; $cut+1)
			$cut:=Position(" "; $rest)
			var $kind : Text:=Substring($rest; 1; $cut-1)
			var $key : Text:=Substring($rest; $cut+1)

			var $value : Text:=MN_CssValue($measured; $kind; $key; String($block.scheme))
			If ($value="")
				$sheet.problems.push("."+String($role.name)+" "+$prop+": nothing in "+\
					"measured.json answers to "+$kind+" "+$key)
			End if
			$body.push($prop+": "+$value+";")
		End for each

		var $rule : Text:="."+MN_Pad(String($role.name); $width)+" { "+$body.join(" ")+" }"
		If ($inside)
			$rule:="  "+$rule
		End if
		$lines.push($rule)
	End for each

	If ($inside)
		$lines.push("}")
	End if
End for each

$lines.push("")
$lines.push("/* ---- what each class is for "+Substring($dashes; 1; 63)+" */")
$lines.push("/*")

var $column : Integer:=$width+1
var $indent : Text:=MN_Pad(""; 4+$column)
For each ($role; $roles)
	var $prose : Text:=MN_CssWrap(String($role.why); 90-$column; $indent)
	$lines.push("   ."+MN_Pad(String($role.name); $column)+Substring($prose; (4+$column)+1))
End for each
$lines.push("*/")

$sheet.text:=$lines.join(Char(Line feed))+Char(Line feed)
$sheet.classes:=$roles.length
$sheet.blocks:=$blocks.length
