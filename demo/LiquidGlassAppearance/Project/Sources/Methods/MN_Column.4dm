#DECLARE()->$columns : Collection

$columns:=New collection( \
	New object("key"; "mark"; "name"; "colMark"; "header"; "colMarkH"; \
	"field"; ""; "title"; ""; "prop"; ""); \
	New object("key"; "name"; "name"; "colName"; "header"; "colNameH"; \
	"field"; "name"; "title"; "Vessel"; "prop"; "Name"); \
	New object("key"; "model"; "name"; "colModel"; "header"; "colModelH"; \
	"field"; "model"; "title"; "Model"; "prop"; "Model"); \
	New object("key"; "harbour"; "name"; "colHarbour"; "header"; "colHarbourH"; \
	"field"; "harbor"; "title"; "Harbour"; "prop"; "Harbour"); \
	New object("key"; "flag"; "name"; "colFlag"; "header"; "colFlagH"; \
	"field"; "flag"; "title"; "Flag"; "prop"; "Flag"); \
	New object("key"; "rate"; "name"; "colRate"; "header"; "colRateH"; \
	"field"; "rate"; "title"; "Rate / night"; "prop"; "Rate"); \
	New object("key"; "status"; "name"; "colStatus"; "header"; "colStatusH"; \
	"field"; "stage"; "title"; "Status"; "prop"; "Status"))
