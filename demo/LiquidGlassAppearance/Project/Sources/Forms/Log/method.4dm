var $event : Object:=FORM Event

Case of
	: ($event.code=On Load)
		Form.scheme:=String(Try(FORM Get color scheme))
		MN_Skin
		SET TIMER(60)

	: ($event.code=On Activate) | ($event.code=On Timer)
		If (MN_Scheme(Form))
			CANCEL
		End if

	: ($event.code=On Outside Call)
		CANCEL

	: ($event.code=On Close Box)
		CANCEL
End case
