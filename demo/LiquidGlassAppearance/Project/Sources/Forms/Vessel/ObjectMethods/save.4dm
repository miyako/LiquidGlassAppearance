Form.message:=MN_VesselCheck(Form)

If (Form.message#"")
	return
End if

Form.accepted:=True
ACCEPT
