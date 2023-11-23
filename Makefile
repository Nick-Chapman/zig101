
top: run-first

run-%: %.exe
	@ echo 'Running example: $*'
	@ ./$^

%.exe: %.zig
	zig build-exe $^ ; mv $* $@
