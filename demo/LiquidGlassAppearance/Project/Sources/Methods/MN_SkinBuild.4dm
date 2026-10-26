#DECLARE()->$report : Object

$report:=New object("written"; 0; "images"; New collection)

var $measured : Object:=JSON Parse(File("/PACKAGE/reference/measured.json").getText())
var $geometry : Object:=$measured.geometry
var $material : Object:=$measured.material
var $lens : Object:=$material.lens

var $width : Integer:=$geometry.content.width
var $height : Integer:=$geometry.content.height
var $radius : Integer:=$geometry.inspector.cardRadius

var $rungs : Object:=MN_SkinRungs
var $panels : Collection:=New collection

var $folder : 4D.Folder
For each ($folder; Folder("/PACKAGE/Project/Sources/Forms").folders())
	var $formFile : 4D.File:=$folder.file("form.4DForm")
	If (Not($formFile.exists))
		continue
	End if
	var $form : Object:=JSON Parse($formFile.getText())

	var $page : Object
	For each ($page; $form.pages)
		If ($page=Null)
			continue
		End if
		If ($page.objects=Null)
			continue
		End if
		var $name : Text
		For each ($name; $page.objects)
			var $object : Object:=$page.objects[$name]
			If ($rungs[String($object.class)]#Null)
				$panels.push(New object("name"; $name; \
					"form"; $folder.name; \
					"rung"; String($rungs[String($object.class)]); \
					"x"; Num($object.left); "y"; Num($object.top); \
					"w"; Num($object.width); "h"; Num($object.height)))
			End if
		End for each
	End for each
End for each
$panels:=$panels.orderBy("name asc")
$report.panels:=$panels.length

var $step : Integer:=6
var $bands : Collection:=MN_SkinField($width; $height; Num($material.canvas.contours); $step)
$report.bands:=$bands.length

var $schemes : Collection:=New collection("light"; "dark")
var $scheme : Text

For each ($scheme; $schemes)
	var $ground : Text:=String($measured.colour[$scheme].windowBackground)
	var $ink : Text:=String($measured.colour[$scheme].accent)
	var $strength : Real:=Num($material.canvas[$scheme])

	var $svg : Text:=MN_SkinDoc($width; $height; 0; 0; $width; $height; "")
	$svg:=$svg+MN_SkinBack($ground; $ink; $strength; $width; $height; $bands.join(""))
	$svg:=$svg+"</svg>"
	var $bytes : Integer:=MN_SkinPng($svg; "/RESOURCES/canvas-"+$scheme+".png")
	$report.images.push(New object("file"; "canvas-"+$scheme+".png"; "bytes"; $bytes))
	$report.written:=$report.written+1

	var $panel : Object
	For each ($panel; $panels)
		$report.written:=$report.written+1
		$bytes:=MN_SkinPng(MN_SkinSlab($panel; $scheme; $measured; $bands; $step; $radius); \
			"/RESOURCES/glass-"+String($panel.name)+"-"+$scheme+".png")
		$report.images.push(New object("file"; \
			"glass-"+String($panel.name)+"-"+$scheme+".png"; "bytes"; $bytes))
	End for each
End for each

var $names : Collection:=New collection("\"canvas\"")
var $each : Object
For each ($each; $panels)
	$names.push("\"glass_"+String($each.name)+"\"")
End for each

var $source : Text:="#DECLARE()->$names : Collection"+Char(13)
$source:=$source+Char(13)
$source:=$source+"$names:=New collection("+$names.join("; ")+")"+Char(13)

Try(File("/PACKAGE/Project/Sources/Methods/MN_SkinList.4dm").setText($source))
$report.listWritten:=True
