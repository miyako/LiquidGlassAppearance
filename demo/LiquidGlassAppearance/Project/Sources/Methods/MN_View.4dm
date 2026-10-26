#DECLARE($data : Object)

If ($data=Null)
	return
End if

var $fleet : Collection:=$data.fleet
If ($fleet=Null)
	$fleet:=New collection
End if

var $key : Text:=String($data.section)
If ($key="")
	$key:="fleet"
End if

var $vessel : Object
var $entry : Object
var $count : Integer
var $total : Integer:=$fleet.length

var $nav : Collection:=New collection
For each ($entry; MN_Section("list"))
	$count:=0
	For each ($vessel; $fleet)
		If (MN_InSection($vessel; String($entry.key)))
			$count:=$count+1
		End if
	End for each
	$nav.push(New object( \
		"key"; String($entry.key); \
		"label"; String($entry.glyph)+"  "+String($entry.title); \
		"count"; $count))
End for each
$data.nav:=$nav

var $section : Object:=MN_Section($key)
var $query : Text:=Trim(String($data.query))
var $needle : Text:=Lowercase($query)
var $rows : Collection:=New collection
var $pool : Integer:=0
var $hit : Boolean
var $stage : Text
var $mark : Text
var $star : Text

For each ($vessel; $fleet)
	If (MN_InSection($vessel; $key))
		$pool:=$pool+1
		$hit:=($needle="")
		If (Not($hit))
			$hit:=(Position($needle; Lowercase(String($vessel.name)))>0)
		End if
		If (Not($hit))
			$hit:=(Position($needle; Lowercase(String($vessel.model)))>0)
		End if
		If (Not($hit))
			$hit:=(Position($needle; Lowercase(String($vessel.harbor)))>0)
		End if
		If (Not($hit))
			$hit:=(Position($needle; Lowercase(String($vessel.harborJa)))>0)
		End if
		If (Not($hit))
			$hit:=(Position($needle; Lowercase(String($vessel.flag)))>0)
		End if
		If (Not($hit))
			$hit:=(Position($needle; Lowercase(String($vessel.flagJa)))>0)
		End if
		If ($hit)
			$stage:=String($vessel.stage)
			$mark:=String(MN_Stage($stage; "mark"))
			$star:=""
			If ($vessel.flagship=True)
				$star:="  "+Char(9733)
			End if
			$rows.push(New object( \
				"mark"; $mark; \
				"name"; String($vessel.name); \
				"label"; String($vessel.name)+$star; \
				"model"; String($vessel.model); \
				"type"; MN_Label("Type"; String($vessel.type)); \
				"harbor"; MN_Local($vessel; "harbor"); \
				"flag"; MN_Local($vessel; "flag"); \
				"year"; Num($vessel.year); \
				"berths"; Num($vessel.berths); \
				"skipper"; MN_Local($vessel; "skipper"); \
				"stage"; MN_Label("Stage"; $stage); \
				"stageKey"; $stage; \
				"rate"; Num($vessel.rate); \
				"money"; MN_Yen(Num($vessel.rate)); \
				"notes"; MN_Local($vessel; "notes")))
		End if
	End if
End for each

var $column : Object
var $field : Text:=""
var $direction : Text:="asc"
If (String($data.sortDir)="desc")
	$direction:="desc"
End if
For each ($column; MN_Column)
	If (String($column.field)=String($data.sortBy))
		$field:=String($column.field)
	End if
End for each
If ($field="")
	$field:="name"
	$data.sortBy:="name"
End if
$data.rows:=$rows.orderBy($field+" "+$direction)

var $chevron : Text:=Char(9652)
If ($direction="desc")
	$chevron:=Char(9662)
End if
var $title : Text
For each ($column; MN_Column)
	If (String($column.prop)#"")
		$title:=MN_Text("Column_"+String($column.key))
		If (String($column.field)=$field)
			$data["hdr"+String($column.prop)]:=$title+"  "+$chevron
		Else
			$data["hdr"+String($column.prop)]:=$title
		End if
	End if
End for each

var $selName : Text:=""
If ($data.sel#Null)
	$selName:=String($data.sel.name)
End if
$data.sel:=Null
$data.pos:=0
If ($selName#"")
	var $at : Integer:=0
	var $candidate : Object
	For each ($candidate; $data.rows)
		$at:=$at+1
		If (String($candidate.name)=$selName)
			$data.sel:=$candidate
			$data.pos:=$at
		End if
	End for each
End if

$data.title:=String($section.title)
var $prefix : Text:="Section_"+$key+"_"
var $values : Object:=New object("n"; $rows.length; "total"; $total; "pool"; $pool; "query"; $query)
If ($query="")
	$data.subtitle:=MN_Text($prefix+"Subtitle"; $values)
Else
	$data.subtitle:=MN_Text($prefix+"SubtitleQuery"; $values)
End if

var $committed : Integer:=0
var $underway : Integer:=0
var $money : Integer:=0
For each ($vessel; $fleet)
	If (MN_Stage(String($vessel.stage); "committed")=True)
		$committed:=$committed+1
	End if
	If (MN_InSection($vessel; "charters"))
		$underway:=$underway+1
		$money:=$money+Num($vessel.rate)
	End if
End for each

If ($total>0)
	$data.util:=String(Int((($committed*200)+$total)/($total*2)))+"%"
Else
	$data.util:="--"
End if
$data.utilNote:=MN_Text("View_UtilNote"; New object("n"; $committed; "total"; $total))
$data.committed:=MN_Yen($money)
$data.committedNote:=MN_Text(Choose($underway=1; "View_CommittedOne"; "View_CommittedMany"); \
	New object("n"; $underway))

$data.provenance:=MN_Text("View_ProvenanceCode")
If ($data.stored=True)
	$data.provenance:=MN_Text("View_ProvenanceSaved")
	If (String($data.savedAt)#"")
		$data.provenance:=$data.provenance+" "+Char(183)+" "+String($data.savedAt)
	End if
End if

MN_Inspect($data)

If ($rows.length=0)
	If ($query="")
		$data.status:=MN_Text($prefix+"Empty"; $values)
	Else
		$data.status:=MN_Text($prefix+"EmptyQuery"; $values)
	End if
Else
	$values.title:=String($section.title)
	$data.status:=MN_Text(Choose($rows.length=1; "View_StatusOne"; "View_StatusMany"); $values)
End if
