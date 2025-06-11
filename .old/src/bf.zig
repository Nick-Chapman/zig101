const std = @import("std");
const print = std.debug.print;
const os = std.os;

const string = []const u8;

pub fn main() !void {
    const filename = std.mem.span(os.argv[1]);
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();
    const input = "";
    const prog = try contentsFile(allocator, filename);
    run(prog, input);
}

fn contentsFile(allocator: std.mem.Allocator, filename: string) !string {
    const max_file_size = 100000;
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    return file.reader().readAllAlloc(
        allocator,
        max_file_size,
    );
}

fn run(prog: []const u8, input: []const u8) void {
    const proglen = prog.len;
    const memsize = 30000;
    //var mem: [memsize]u8 = undefined; // 0xaa = 170
    var mem = [_]u8{0} ** memsize;
    var mp: u16 = 0;
    var pc: u16 = 0;
    var ip: u16 = 0;
    while (pc < proglen) {
        const op = prog[pc];
        switch (op) {
            '+' => mem[mp] +%= 1,
            '-' => mem[mp] -%= 1,
            '.' => put(mem[mp]),
            ',' => {
                if (ip >= input.len) {
                    mem[mp] = 0;
                } else {
                    mem[mp] = input[ip];
                    ip += 1;
                }
            },
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
    print("{c}", .{x});
}
