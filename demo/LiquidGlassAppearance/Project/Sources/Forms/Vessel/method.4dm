var $event : Object:=FORM Event

Case of
	: ($event.code=On Load)
		Form.message:=""

	: ($event.code=On Close Box)
		Form.accepted:=False
		CANCEL
End case
