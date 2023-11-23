
top: run-first

run-%: %
	@ echo 'Running example: $*'
	@ ./$*

first: first.zig
	zig build-exe $^
