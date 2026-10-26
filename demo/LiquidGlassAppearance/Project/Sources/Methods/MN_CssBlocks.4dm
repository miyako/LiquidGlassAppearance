#DECLARE()->$blocks : Collection

$blocks:=New collection

$blocks.push(New object("condition"; ""; \
	"scheme"; "light"; "title"; "BASE = light"; \
	"note"; "Also what 4D renders before 21 R3, which knows no form theme at all."))

$blocks.push(New object("condition"; "(prefers-color-scheme: dark)"; \
	"scheme"; "dark"; "title"; "dark"; \
	"note"; "Uncrossed with form-theme on purpose, so it still applies pre-21 R3."))

$blocks.push(New object("condition"; "(form-theme: liquid-glass) and (prefers-color-scheme: light)"; \
	"scheme"; "light"; "title"; "light, again, verbatim"; \
	"note"; "On 21 R3/R4 the liquid-glass theme is live and outranks the two blocks above. Without this pair the window renders unthemed there; without the pair above it renders unthemed on anything older. Same values, stated twice, which is what the generator is for."))

$blocks.push(New object("condition"; "(form-theme: liquid-glass) and (prefers-color-scheme: dark)"; \
	"scheme"; "dark"; "title"; "dark, again, verbatim"; \
	"note"; "Last, so it wins."))
