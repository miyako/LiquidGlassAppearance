#DECLARE($audit : Object; $where : Text; $what : Text)

$audit.problems.push($where+": "+$what)
