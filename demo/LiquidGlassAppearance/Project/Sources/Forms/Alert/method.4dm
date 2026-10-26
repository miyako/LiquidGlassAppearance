var $event : Object:=FORM Event

Case of
	: ($event.code=On Load)
		Form.scheme:=String(Try(FORM Get color scheme))
		MN_Skin

	: ($event.code=On Close Box)
		ACCEPT
End case
