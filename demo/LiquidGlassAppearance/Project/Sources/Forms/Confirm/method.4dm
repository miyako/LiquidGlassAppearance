var $event : Object:=FORM Event

Case of
	: ($event.code=On Load)
		Form.scheme:=String(Try(FORM Get color scheme))
		MN_Skin
		Try(OBJECT SET TITLE(*; "confirmOk"; String(Form.okLabel)))

	: ($event.code=On Close Box)
		Form.accepted:=False
		CANCEL
End case
