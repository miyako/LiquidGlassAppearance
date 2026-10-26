#DECLARE($measured : Object; $kind : Text; $key : Text; $scheme : Text)->$text : Text

$text:=""

Case of
	: ($kind="colour")
		If (Position("pinned:"; $key)=1)
			var $entry : Object:=$measured.pinned[Substring($key; 8)]
			$text:=Uppercase(String($measured.colour[$scheme][String($entry.borrows)]))
		Else
			$text:=Uppercase(String($measured.colour[$scheme][$key]))
		End if

	: ($kind="type")
		$text:=String(Int(Num($measured.type[$key])))

	: ($kind="composite")
		var $parts : Collection:=Split string($key; " over ")
		var $ground : Collection:=MN_Hex(String($measured.colour[$scheme][$parts[$parts.length-1]]))
		var $tint : Collection:=MN_Hex(String($measured.material.tint[$scheme]))

		var $r : Integer
		For ($r; $parts.length-2; 0; -1)
			var $rung : Text:=$parts[$r]
			var $rungTint : Collection:=$tint
			var $alpha : Real:=0

			If (Position("rim."; $rung)=1)
				var $spec : Object:=$measured.material.rim[Substring($rung; 5)]
				$rungTint:=MN_Hex(String($spec.tint))
				$alpha:=Num($spec[$scheme])
			Else
				$alpha:=Num($measured.material.alpha[$rung])
			End if

			var $i : Integer
			For ($i; 0; 2)
				$ground[$i]:=Round($ground[$i]+(($rungTint[$i]-$ground[$i])*$alpha); 0)
			End for
		End for
		$text:=MN_HexText($ground)

	: ($kind="keyword")
		$text:=$key

	: ($kind="geometry")
		var $node : Object:=$measured.geometry
		var $steps : Collection:=Split string($key; ".")
		var $step : Integer
		For ($step; 0; $steps.length-2)
			$node:=$node[$steps[$step]]
		End for
		$text:=String(Int(Num($node[$steps[$steps.length-1]])))

	: ($kind="literal")
		$text:=String($measured.type[$key])
End case
