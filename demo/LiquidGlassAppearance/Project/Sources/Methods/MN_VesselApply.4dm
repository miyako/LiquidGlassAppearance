#DECLARE($data : Object)->$vessel : Object

$vessel:=New object( \
	"name"; Trim(String($data.name)); \
	"model"; Trim(String($data.model)); \
	"type"; Trim(String($data.type)); \
	"harbor"; Trim(String($data.harbor)); \
	"flag"; Trim(String($data.flag)); \
	"year"; Num($data.year); \
	"stage"; String($data.stage); \
	"skipper"; Trim(String($data.skipper)); \
	"rate"; Num($data.rate); \
	"berths"; Num($data.berths); \
	"flagship"; ($data.flagship=True); \
	"notes"; Trim(String($data.notes)))
