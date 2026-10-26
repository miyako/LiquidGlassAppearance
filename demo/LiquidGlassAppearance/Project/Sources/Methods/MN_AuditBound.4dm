#DECLARE($node : Variant; $bound : Collection)

Case of
	: (Value type($node)=Is object)
		var $key : Text
		For each ($key; OB Keys($node))
			var $binds : Boolean:=(($key="dataSource") | ($key="currentItemSource") | \
				($key="currentItemPositionSource"))
			var $taken : Boolean:=False
			If ($binds)
				If (Value type($node[$key])=Is text)
					If (Position("Form:C1466."; $node[$key])=1)
						var $prop : Text:=Substring($node[$key]; Length("Form:C1466.")+1)
						If ($bound.indexOf($prop)=-1)
							$bound.push($prop)
						End if
						$taken:=True
					End if
				End if
			End if
			If (Not($taken))
				MN_AuditBound($node[$key]; $bound)
			End if
		End for each

	: (Value type($node)=Is collection)
		var $item : Variant
		For each ($item; $node)
			MN_AuditBound($item; $bound)
		End for each
End case
