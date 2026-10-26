var $column : Object

For each ($column; MN_Column)
	If (String($column.prop)#"")
		Try(OBJECT SET TITLE(*; String($column.header); \
			String(Form["hdr"+String($column.prop)])))
	End if
End for each
