#DECLARE($root : Object; $node : Variant)->$props : Collection

$props:=New collection
MN_AuditWalk($root; $node; New object(); $props)
