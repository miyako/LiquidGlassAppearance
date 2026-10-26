var $event : Object:=FORM Event

Case of
	: ($event.code=On Selection Change) | ($event.code=On Clicked)
		MN_Inspect(Form)

	: ($event.code=On Header Click)
		var $clicked : Text:=String($event.columnName)
		var $header : Text:=String($event.headerName)
		var $column : Object
		var $field : Text:=""
		For each ($column; MN_Column)
			If ((String($column.name)=$clicked) | (String($column.header)=$header))
				$field:=String($column.field)
			End if
		End for each
		If ($field="")
			return
		End if
		If ($field=String(Form.sortBy))
			Form.sortDir:=Choose(String(Form.sortDir)="asc"; "desc"; "asc")
		Else
			Form.sortBy:=$field
			Form.sortDir:="asc"
		End if
		MN_View(Form)
		MN_Headers
End case
