#DECLARE($audit : Object; $forms : Collection)

var $file : 4D.File:=File("/PACKAGE/reference/measured.json")
If (Not($file.exists))
	MN_AuditSay($audit; "geometry"; "cannot read reference/measured.json")
	return
End if

var $measured : Object:=JSON Parse($file.getText())
If (Value type($measured.geometry)#Is object)
	MN_AuditSay($audit; "geometry"; "reference/measured.json has no 'geometry' block")
	return
End if

var $g : Object:=$measured.geometry
var $w : Integer:=Num($g.content.width)
var $h : Integer:=Num($g.content.height)

var $panes : Integer:=0
var $key : Text
For each ($key; OB Keys($measured.panes))
	$panes:=$panes+Num($measured.panes[$key].width)
End for each
If ($panes#$w)
	MN_AuditSay($audit; "geometry"; "the panes sum to "+String($panes)+" but content.width "+\
		"is "+String($w)+" - one of them is measured against a different edge")
End if

var $span : Integer:=Num($g.table.right)-Num($g.table.left)
var $cols : Integer:=0
var $column : Object
For each ($column; $g.columns)
	$cols:=$cols+Num($column.width)
End for each
If ($cols#$span)
	MN_AuditSay($audit; "geometry"; "the columns sum to "+String($cols)+" but the table "+\
		"spans "+String($span))
End if

var $widths : Collection:=New collection
For each ($column; $g.columns)
	$widths.push(Num($column.width))
End for each

var $checked : Integer:=0

var $entry : Object
For each ($entry; $forms)
	var $name : Text:=String($entry.name)
	var $form : Object:=JSON Parse($entry.file.getText())

	var $isWindow : Boolean:=False
	var $page : Object
	For each ($page; $form.pages)
		If ($page#Null)
			If ($page.objects#Null)
				var $each : Text
				For each ($each; OB Keys($page.objects))
					If (String($page.objects[$each].dataSource)="Form:C1466.rows")
						$isWindow:=True
					End if
				End for each
			End if
		End if
	End for each

	If ($isWindow)
		If ((Num($form.width)#$w) | (Num($form.height)#$h))
			MN_AuditSay($audit; $name; "is "+String(Num($form.width))+"x"+\
				String(Num($form.height))+", but the measured window content is "+\
				String($w)+"x"+String($h))
		End if
	End if

	var $bw : Integer:=$w
	var $bh : Integer:=$h
	If (Num($form.width)#0)
		$bw:=Num($form.width)
	End if
	If (Num($form.height)#0)
		$bh:=Num($form.height)
	End if

	var $pageIndex : Integer:=-1
	For each ($page; $form.pages)
		$pageIndex:=$pageIndex+1
		If ($page=Null)
			continue
		End if
		If ($page.objects=Null)
			continue
		End if

		var $objectName : Text
		For each ($objectName; OB Keys($page.objects))
			var $object : Object:=$page.objects[$objectName]
			var $where : Text:=$name+" p"+String($pageIndex)+" "+$objectName

			var $right : Integer:=Num($object.left)+Num($object.width)
			var $bottom : Integer:=Num($object.top)+Num($object.height)
			If ($right>$bw)
				MN_AuditSay($audit; $where; "ends at x="+String($right)+", past the form's "+\
					String($bw)+" - it will be clipped")
			End if
			If ($bottom>$bh)
				MN_AuditSay($audit; $where; "ends at y="+String($bottom)+", past the form's "+\
					String($bh)+" - it will be clipped")
			End if

			If (String($object.type)#"listbox")
				continue
			End if

			Case of
				: (String($object.dataSource)="Form:C1466.rows")
					$checked:=$checked+1
					MN_AuditSame($audit; $where; "rowHeight"; $object.rowHeight; \
						String(Num($measured.table.rowHeight))+"px")
					MN_AuditSame($audit; $where; "headerHeight"; $object.headerHeight; \
						String(Num($measured.table.headerHeight))+"px")
					If ((Num($object.left)#Num($g.table.left)) | \
						(Num($object.top)#Num($g.table.top)))
						MN_AuditSay($audit; $where; "sits at "+String(Num($object.left))+","+\
							String(Num($object.top))+" but the measured table starts at "+\
							String(Num($g.table.left))+","+String(Num($g.table.top)))
					End if
					If (Num($object.width)#$span)
						MN_AuditSay($audit; $where; "is "+String(Num($object.width))+\
							" wide, measured "+String($span))
					End if
					var $actual : Collection:=New collection
					var $each2 : Object
					For each ($each2; $object.columns)
						$actual.push(Num($each2.width))
					End for each
					If (JSON Stringify($actual)#JSON Stringify($widths))
						MN_AuditSay($audit; $where; "column widths are "+\
							MN_AuditNums($actual)+", measured "+MN_AuditNums($widths))
					End if

				: (String($object.dataSource)="Form:C1466.nav")
					$checked:=$checked+1
					MN_AuditSame($audit; $where; "rowHeight"; $object.rowHeight; \
						String(Num($g.nav.rowHeight))+"px")
					If (Num($object.top)#Num($g.nav.top))
						MN_AuditSay($audit; $where; "top is "+String(Num($object.top))+\
							", measured "+String(Num($g.nav.top)))
					End if
			End case
		End for each
	End for each
End for each

$audit.checks.push("geometry: "+String($w)+"x"+String($h)+" content, "+\
String($g.columns.length)+" measured columns, "+String($checked)+\
" list box(es) checked against reference/measured.json")
