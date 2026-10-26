#DECLARE($report : Object; $want : Object)->$problems : Collection

$problems:=New collection

If ($report.ok#True)
	$problems.push("logic: MN_ProbeRun raised - the report is incomplete")
	return
End if

MN_VerifySame($problems; "fleet"; $report.fleet; $want.fleet; "is")
MN_VerifySame($problems; "nav"; $report.nav; $want.nav; "is")
MN_VerifySame($problems; "title"; $report.title; $want.title; "is")
MN_VerifySame($problems; "subtitle"; $report.subtitle; $want.subtitle; "is")
MN_VerifySame($problems; "util"; $report.util; $want.util; "is")
MN_VerifySame($problems; "utilNote"; $report.utilNote; $want.utilNote; "is")
MN_VerifySame($problems; "committedNote"; $report.committedNote; $want.committedNote; "is")
MN_VerifySame($problems; "searchRows"; $report.searchRows; $want.searchRows; "is")
MN_VerifySame($problems; "deskRows"; $report.deskRows; $want.deskRows; "is")

MN_VerifySame($problems; "committed"; MN_VerifyDigits($report.committed); \
$want.committedDigits; "has digits")
MN_VerifySame($problems; "insNight"; MN_VerifyDigits($report.insNight); \
$want.insNightDigits; "has digits")
MN_VerifySame($problems; "insWeek"; MN_VerifyDigits($report.insWeek); \
$want.insWeekDigits; "has digits")

var $rates : Collection:=$report.rateSorted
If ($rates=Null)
	$rates:=New collection
End if
If (JSON Stringify($rates)#JSON Stringify($rates.copy().sort()))
	$problems.push("logic: sorting by rate ascending gives "+JSON Stringify($rates)+\
		" - that is not ascending, so the column is sorting its SPELLING and not its value")
End if
If ($rates.length>0)
	If (Num($report.rateTopDesc)#$rates.max())
		$problems.push("logic: sorting by rate descending puts "+\
			MN_AuditShow($report.rateTopDesc)+" first, but the dearest vessel is "+\
			String($rates.max()))
	End if
End if

var $chevron : Collection:=New collection(Char(0x25B2); Char(0x25B4); Char(0x25BC); Char(0x25BE))
var $mark : Text
var $sortedHas : Boolean:=False
var $plainHas : Boolean:=False
For each ($mark; $chevron)
	If (Position($mark; String($report.rateHeader))>0)
		$sortedHas:=True
	End if
	If (Position($mark; String($report.nameHeader))>0)
		$plainHas:=True
	End if
End for each
If (Not($sortedHas))
	$problems.push("logic: the sorted column's header is "+MN_AuditShow($report.rateHeader)+\
		" and carries no direction chevron")
End if
If ($plainHas)
	$problems.push("logic: an unsorted column's header is "+MN_AuditShow($report.nameHeader)+\
		" - two columns claiming the sort at once")
End if

Case of
	: (String($report.selName)="")
		$problems.push("logic: the selection did not survive a rebuild - Form.sel came back "+\
			"empty, so the register would show no highlighted row")
	: (String($report.selName)#String($report.selAtPos))
		$problems.push("logic: Form.sel is "+MN_AuditShow($report.selName)+" but Form.pos "+\
			"points at "+MN_AuditShow($report.selAtPos)+\
			" - the selection and the highlight disagree")
	: (Num($report.selPos)=0)
		$problems.push("logic: Form.sel survived but Form.pos is 0 - nothing is highlighted")
End case
If ($report.selAfterMiss#True)
	$problems.push("logic: a selection whose vessel is no longer listed did not clear - the "+\
		"inspector would keep describing a row the register does not show")
End if

var $rows : Collection:=$report.firstRows
If ($rows=Null)
	$rows:=New collection
End if
If (JSON Stringify($rows.slice(0; $want.firstRows.length))#JSON Stringify($want.firstRows))
	$problems.push("logic: the register opens on "+JSON Stringify($rows.slice(0; 2))+\
		", the native app on "+JSON Stringify($want.firstRows)+\
		" - the sort is not name-ascending")
End if

var $pair : Object
For each ($pair; New collection(\
	New object("field"; "insName"; "want"; $want.insName); \
	New object("field"; "insModel"; "want"; $want.insModel); \
	New object("field"; "insStatus"; "want"; $want.insStatusText)))
	If (Position(String($pair.want); String($report[String($pair.field)]))=0)
		$problems.push("logic: "+String($pair.field)+" is "+\
			MN_AuditShow($report[String($pair.field)])+", which does not contain "+\
			MN_AuditShow($pair.want))
	End if
End for each

If ($report.rowsKept#True)
	$problems.push("selection: MN_Inspect rebuilt the rows collection. Clicking a row will "+\
		"swap the list out from under the click and the highlight will die.")
End if
If (String($report.inspectName)="")
	$problems.push("selection: selecting a row did not fill the inspector")
End if

If (String($report.charterAfter)#"On charter")
	$problems.push("charter: the vessel is "+MN_AuditShow($report.charterAfter)+\
		" after chartering it")
Else
	var $before : Object:=MN_VerifyNav($report.nav)
	var $after : Object:=MN_VerifyNav($report.charterNav)

	If (Num($after.charters)#(Num($before.charters)+1))
		$problems.push("charter: Charters went "+String(Num($before.charters))+" -> "+\
			String(Num($after.charters))+", it should have gained exactly one")
	End if
	If (Num($after.desk)#(Num($before.desk)-1))
		$problems.push("charter: Desk went "+String(Num($before.desk))+" -> "+\
			String(Num($after.desk))+\
			"; the vessel was in refit and should have left that section")
	End if
	If (Num($after.fleet)#Num($before.fleet))
		$problems.push("charter: the fleet count changed - chartering must not add or "+\
			"remove a vessel")
	End if
	If (MN_VerifyDigits($report.charterCommitted)=MN_VerifyDigits($report.committed))
		$problems.push("charter: the money did not move, but a vessel joined those under "+\
			"way - the figure and the badge disagree")
	End if
	If (String($report.charterUtil)=String($report.util))
		$problems.push("charter: utilisation did not move, but a vessel became committed")
	End if
End if

If (String($report.blankHeading)#"New vessel")
	$problems.push("vessel: a blank sheet is headed "+MN_AuditShow($report.blankHeading))
End if
If (String($report.blankStage)#"Available")
	$problems.push("vessel: a new vessel starts as "+MN_AuditShow($report.blankStage)+\
		", which is not where a vessel with no bookings actually is")
End if
If (String($report.blankComplaint)="")
	$problems.push("vessel: a blank sheet passed validation - a vessel with no name has no "+\
		"identity, and the register sorts and selects on it")
End if
If (String($report.sheetComplaint)#"")
	$problems.push("vessel: an existing vessel failed its own validation: "+\
		MN_AuditShow($report.sheetComplaint))
End if
If (String($report.sheetOriginal)#String($report.roundName))
	$problems.push("vessel: the sheet opened on "+MN_AuditShow($report.sheetOriginal)+\
		" but came back as "+MN_AuditShow($report.roundName)+" without being edited")
End if
If ($report.roundRateIsNumber#True)
	$problems.push("vessel: rate came back as text. It would sort '1 100' before '900' and "+\
		"sum to nothing - the money-column defect MN_Column exists to stop")
End if
If ($report.roundFlagshipIsBoolean#True)
	$problems.push("vessel: flagship came back as something other than a boolean")
End if
If (Num($report.roundRate)#Num($report.roundSourceRate))
	$problems.push("vessel: rate changed on a round trip, "+\
		String(Num($report.roundSourceRate))+" -> "+String(Num($report.roundRate)))
End if

If (Num($report.savedCount)#Num($want.fleet))
	$problems.push("persistence: the fleet came back from disk with "+\
		String(Num($report.savedCount))+" vessels, not "+String(Num($want.fleet)))
End if
If (String($report.savedStage)#"On charter")
	$problems.push("persistence: the chartered vessel came back as "+\
		MN_AuditShow($report.savedStage)+" - the charter did not survive the round trip")
End if
If ($report.storeExists#True)
	$problems.push("persistence: nothing was written to disk at all")
End if

If (String($report.saveProblem)#"")
	$problems.push("persistence: MN_FleetSave reported "+\
		MN_AuditShow($report.saveProblem))
End if
