#DECLARE($from : Real; $to : Real; $level : Real)->$t : Real

var $span : Real:=$to-$from

If ($span=0)
	$t:=0.5
	return
End if

$t:=($level-$from)/$span

If ($t<0)
	$t:=0
End if
If ($t>1)
	$t:=1
End if
