// Drop-down object whose values follow the UI language; keys keeps the stored English keys
#DECLARE($kind : Text; $key : Text)->$list : Object

var $keys : Collection:=MN_Choices($kind)
var $values : Collection:=New collection
var $one : Text
For each ($one; $keys)
	$values.push(MN_Label($kind; $one))
End for each

$list:=New object("values"; $values; "keys"; $keys; "index"; $keys.indexOf($key))
If ($list.index<0)
	$list.currentValue:=MN_Label($kind; $key)
End if
