
top: run-bf

run-%: %.exe
	@ echo 'Running example: $*'
	@ ./$^

.PRECIOUS: %.exe
%.exe: %.zig
	zig build-exe $^ ; mv $* $@
