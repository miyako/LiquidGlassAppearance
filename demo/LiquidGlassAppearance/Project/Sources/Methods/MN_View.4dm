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
			$hit:=(Position($needle; Lowercase(String($vessel.flag)))>0)
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
				"type"; String($vessel.type); \
				"harbor"; String($vessel.harbor); \
				"flag"; String($vessel.flag); \
				"year"; Num($vessel.year); \
				"berths"; Num($vessel.berths); \
				"skipper"; String($vessel.skipper); \
				"stage"; $stage; \
				"rate"; Num($vessel.rate); \
				"money"; MN_Euro(Num($vessel.rate)); \
				"notes"; String($vessel.notes)))
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
For each ($column; MN_Column)
	If (String($column.prop)#"")
		If (String($column.field)=$field)
			$data["hdr"+String($column.prop)]:=String($column.title)+"  "+$chevron
		Else
			$data["hdr"+String($column.prop)]:=String($column.title)
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
var $noun : Text:=String($section.noun)
If ($query="")
	$data.subtitle:=String($rows.length)+" "+$noun+" of "+String($total)+" in fleet"
Else
	$data.subtitle:=String($rows.length)+" of "+String($pool)+" "+$noun+" matching " \
		+Char(8220)+$query+Char(8221)
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
$data.utilNote:=String($committed)+" of "+String($total)+" vessels committed"
$data.committed:=MN_Euro($money)
$data.committedNote:="across "+String($underway)+" "+MN_Plural($underway; "vessel")+" under way"

$data.provenance:="Fleet as MN_Fleet wrote it"
If ($data.stored=True)
	$data.provenance:="Saved in this project"
	If (String($data.savedAt)#"")
		$data.provenance:=$data.provenance+" "+Char(183)+" "+String($data.savedAt)
	End if
End if

MN_Inspect($data)

If ($rows.length=0)
	If ($query="")
		$data.status:="Nothing in the fleet is "+$noun+"."
	Else
		$data.status:="No "+$noun+" match "+Char(8220)+$query+Char(8221)+"."
	End if
Else
	$data.status:=String($section.title)+" "+Char(183)+" "+String($rows.length)+" " \
		+MN_Plural($rows.length; "vessel")+" listed."
End if
