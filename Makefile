
top: run-arith

exes: $(patsubst src/%.zig, _build/%, $(wildcard src/*))

all:  _build $(patsubst src/%.zig, _build/%, $(wildcard src/*))

args = ../bf/b/mandelbrot.b

run-%: _build _build/%
	@ echo 'Running example: $@ $(args)'
	@ _build/$* $(args)

.PRECIOUS: %.exe
_build/%: src/%.zig
	zig build-exe $^ ; mv $*.o $* _build

_build: ; @mkdir -p $@
