var $event : Object:=FORM Event

Case of
	: ($event.code=On After Edit) | ($event.code=On Data Change)
		Form.sel:=Null
		Form.pos:=0
		MN_View(Form)
End case
