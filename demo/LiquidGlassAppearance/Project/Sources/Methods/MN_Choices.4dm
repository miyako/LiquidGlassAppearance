#DECLARE($kind : Text)->$keys : Collection

Case of
	: ($kind="Stage")
		$keys:=New collection("Available"; "On charter"; "Turnaround"; "In refit"; "Laid up")
	: ($kind="Type")
		$keys:=New collection("Sloop"; "Catamaran"; "Motor"; "Ketch"; "Gulet")
	Else
		$keys:=New collection
End case
