var $event : Object:=FORM Event

Case of
	: ($event.code=On Selection Change) | ($event.code=On Clicked)
		var $row : Object:=Form.navSel
		If ($row=Null)
			return
		End if
		var $key : Text:=String($row.key)
		If ($key=Form.section)
			return
		End if
		Form.section:=$key
		Form.sel:=Null
		Form.pos:=0
		MN_View(Form)
End case
