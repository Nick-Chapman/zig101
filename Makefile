
top: run-bf

args = ../bf/b/collatz.b
#args = ../bf/b/fib.b
#args = ../bf/b/mandelbrot.b

run-%: %.exe
	@ echo 'Running example: $^ $(args)'
	@ ./$^ $(args)

.PRECIOUS: %.exe
%.exe: %.zig
	zig build-exe $^ ; mv $* $@
