const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    //const prog = "[-]>,[>,]<[.<]";
    //const input = "HELLO";
    const input = "";
    const prog =
        \\ >++++++++++>+>+[
        \\     [+++++[>++++++++<-]>.<++++++[>--------<-]+<<<]>.>>[
        \\         [-]<[>+<-]>>[<<+>+>-]<[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-
        \\             [>+<-[>+<-[>+<-[>[-]>+>+<<<-[>+<-]]]]]]]]]]]+>>>
        \\     ]<<<
        \\ ]
    ;
    run(prog, input);
}

fn run(prog: []const u8, input: []const u8) void {
    //print("whole prog:'{s}'.\n", .{prog});
    const proglen = prog.len;
    // for (prog, 0..) |c, i| {
    //     print("char:'{d}={c}'.\n", .{ i, c });
    // }
    const memsize = 30000;
    //var mem: [memsize]u8 = undefined; // 0xaa = 170
    var mem = [_]u8{0} ** memsize;
    var mp: u16 = 0;
    var pc: u16 = 0;
    var ip: u16 = 0;
    while (pc < proglen) {
        const op = prog[pc];
        //print("pc={d}, mp={d}: '{c}'\n", .{ pc, mp, op });
        switch (op) {
            '<' => {
                mp -= 1;
                if (mp < 0) {
                    unreachable;
                }
            },
            '>' => {
                mp += 1;
                if (mp >= memsize) {
                    unreachable;
                }
            },
            '+' => {
                mem[mp] +%= 1;
            },
            '-' => {
                mem[mp] -%= 1;
            },
            ',' => {
                if (ip >= input.len) {
                    mem[mp] = 0;
                } else {
                    mem[mp] = input[ip];
                    ip += 1;
                }
            },
            '.' => {
                put(mem[mp]);
            },
            '[' => {
                if (mem[mp] == 0) {
                    var nest: u8 = 1;
                    while (nest > 0) {
                        pc = pc + 1;
                        var x = prog[pc];
                        if (x == '[') nest += 1;
                        if (x == ']') nest -= 1;
                    }
                }
            },
            ']' => {
                if (mem[mp] != 0) {
                    var nest: u8 = 1;
                    while (nest > 0) {
                        pc = pc - 1;
                        var x = prog[pc];
                        if (x == ']') nest += 1;
                        if (x == '[') nest -= 1;
                    }
                }
            },
            else => {},
        }
        pc = pc + 1;
    }
}

fn put(x: u8) void {
    //print("PUT: {d} = '{c}'\n", .{ x, x });
    print("{c}", .{x});
}
