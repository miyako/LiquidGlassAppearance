#DECLARE()->$roles : Collection

$roles:=New collection

$roles.push(New object("name"; "mnWindow"; "props"; New collection( \
	"fill colour windowBackground"; \
	"stroke colour windowBackground"); \
	"why"; "the window ground: the register, the inspector, anything not the sidebar"))

$roles.push(New object("name"; "mnChrome"; "props"; New collection( \
	"fill composite chrome over windowBackground"; \
	"stroke composite chrome over windowBackground"); \
	"why"; "THE NAVIGATION LAYER - the sidebar and the header band. One rung below the canvas. The native one is vibrancy and samples the DESKTOP, so this is frozen at the rung measured over a black desktop - close there, visibly different over a bright one"))

$roles.push(New object("name"; "mnRule"; "props"; New collection( \
	"fill composite hairline over windowBackground"; \
	"stroke composite hairline over windowBackground"); \
	"why"; "a hairline ON THE CANVAS: pane boundaries, the band under the column headers"))

$roles.push(New object("name"; "mnRimTop"; "props"; New collection( \
	"fill composite rim.top over glass over windowBackground"; \
	"stroke composite rim.top over glass over windowBackground"); \
	"why"; "the light inlet: a 1px bevel along a group's top edge, where overhead light catches the rim. Without it a translucent surface has no boundary and blends into what is behind it"))

$roles.push(New object("name"; "mnRimBottom"; "props"; New collection( \
	"fill composite rim.bottom over glass over windowBackground"; \
	"stroke composite rim.bottom over glass over windowBackground"); \
	"why"; "the contact shadow inside the glass's own thickness, along a group's bottom edge"))

$roles.push(New object("name"; "mnCardRule"; "props"; New collection( \
	"fill composite hairline over glass over windowBackground"; \
	"stroke composite hairline over glass over windowBackground"); \
	"why"; "a hairline INSIDE a group, which sits a rung higher than the canvas and so needs its own tone. One hairline colour for both would be visibly wrong on one of them"))

$roles.push(New object("name"; "mnTitle"; "props"; New collection( \
	"stroke colour label"; \
	"fontSize type title2"); \
	"why"; "the window title - the section's name"))

$roles.push(New object("name"; "mnSubtitle"; "props"; New collection( \
	"stroke colour secondaryLabel"; \
	"fontSize type subheadline"); \
	"why"; "the window subtitle - the count and its noun"))

$roles.push(New object("name"; "mnHeading"; "props"; New collection( \
	"stroke colour label"; \
	"fontSize type headline"; \
	"fontWeight literal headlineWeight"); \
	"why"; "a vessel's name, in the register and at the head of the inspector"))

$roles.push(New object("name"; "mnBody"; "props"; New collection( \
	"stroke colour label"; \
	"fontSize type body"); \
	"why"; "ordinary text: cells, inspector values"))

$roles.push(New object("name"; "mnSecondary"; "props"; New collection( \
	"stroke colour secondaryLabel"; \
	"fontSize type body"); \
	"why"; "text that is present but not the point: inspector field labels, an uncommitted status"))

$roles.push(New object("name"; "mnTertiary"; "props"; New collection( \
	"stroke colour tertiaryLabel"; \
	"fontSize type body"); \
	"why"; "the faintest rank: the flagship mark, a placeholder"))

$roles.push(New object("name"; "mnCaption"; "props"; New collection( \
	"stroke colour secondaryLabel"; \
	"fontSize type caption1"); \
	"why"; "the detail line under each sidebar figure, and the provenance line at its foot"))

$roles.push(New object("name"; "mnLabel"; "props"; New collection( \
	"stroke colour secondaryLabel"; \
	"fontSize type caption2"; \
	"fontWeight literal headlineWeight"); \
	"why"; "the small heading over a sidebar figure. SECONDARY and bold, not tertiary: the native app sets these tertiary and gets away with it on a pale vibrant sidebar, but over glass tertiary lands within a few percent of the panel itself and the words disappear. The weight is what keeps them subordinate to the figure without hiding them. 4D has no textCase, so the CAPITALS are in the string; no tracking either, so the widened letter-spacing is simply lost"))

$roles.push(New object("name"; "mnFigure"; "props"; New collection( \
	"stroke colour label"; \
	"fontSize type title2"); \
	"why"; "the two figures a charter desk reads first. The native face is rounded with monospaced digits; 4D reaches neither, so this is the size and the colour and nothing else"))

$roles.push(New object("name"; "mnColumn"; "props"; New collection( \
	"stroke colour secondaryLabel"; \
	"fontSize type subheadline"); \
	"why"; "a column header in the register"))

$roles.push(New object("name"; "mnAccent"; "props"; New collection( \
	"stroke colour accent"; \
	"fontSize type body"); \
	"why"; "the one state that takes the accent - see MN_Stage. Text only: this colour has not been checked as a ground under a white label"))

$roles.push(New object("name"; "mnStrong"; "props"; New collection( \
	"stroke colour label"; \
	"fontSize type title2"; \
	"fontWeight literal headlineWeight"); \
	"why"; "the vessel's name at the head of the inspector - title2, and the only bold at that size"))

$roles.push(New object("name"; "mnRegister"; "props"; New collection( \
	"alternateFill colour alternatingRow"; \
	"horizontalLineStroke keyword transparent"; \
	"verticalLineStroke keyword transparent"); \
	"why"; "the register list box. alternateFill paints every other row and NO rules are drawn: a macOS inset table separates rows by that fill, not by a grid. No `fill` either - one on a list box kills row painting outright - and the selection is left to 4D, which paints it in the user's own accent"))

$roles.push(New object("name"; "mnNav"; "props"; New collection( \
	"stroke colour label"; \
	"fontSize type body"; \
	"horizontalLineStroke composite hairline over glass over windowBackground"; \
	"verticalLineStroke keyword transparent"); \
	"why"; "the sidebar's section list. Hairlines BETWEEN rows and none down the middle, so it reads as one card of sections rather than a two-column table - the same treatment the inspector's groups get, which is where the look comes from"))

$roles.push(New object("name"; "mnInspector"; "props"; New collection( \
	"fill colour windowBackground"; \
	"stroke colour windowBackground"); \
	"why"; "the inspector pane is CANVAS, not chrome. Liquid Glass belongs on the navigation and control layer; the canvas is what shows through it, so it stays the window's own ground"))

$roles.push(New object("name"; "mnCard"; "props"; New collection( \
	"fill composite glass over windowBackground"; \
	"stroke composite glass over windowBackground"; \
	"borderRadius geometry inspector.cardRadius"); \
	"why"; "a floating group - an inspector section, the sidebar's section list. One glass rung above the canvas it sits on. The radius is measured, and unitless because a unit here is error 555 and fatal"))
