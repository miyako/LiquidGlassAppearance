#DECLARE($x1 : Real; $y1 : Real; $x2 : Real; $y2 : Real)->$segment : Text

$segment:="M"+String(Int($x1+0.5))+" "+String(Int($y1+0.5))+ \
"L"+String(Int($x2+0.5))+" "+String(Int($y2+0.5))
