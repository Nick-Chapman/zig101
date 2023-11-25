const std = @import("std");
const print = std.debug.print;
const eql = std.mem.eql;
const ArrayList = std.ArrayList;
const parseInt = std.fmt.parseInt;
const assert = std.debug.assert;

var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
const allocator = arena.allocator();

const String = []const u8;

pub fn main() !void {
    const input = try contentsFile("../aoc2022/input/day1.input");
    print("AOC 2022, day1, part1 = {d}\n", .{try part1(input)});
}

test "22.1.part1" {
    const input = try contentsFile("../aoc2022/input/day1.input");
    assert(try part1(input) == 71506);
}

pub fn part1(input: String) !u32 {
    var lines = ArrayList(String).init(allocator);
    defer lines.deinit();
    try splitLines(input, &lines);
    var best: u32 = 0;
    var acc: u32 = 0;
    for (lines.items) |line| {
        if (isBlankLine(line)) {
            if (acc > best) {
                best = acc;
            }
            acc = 0;
        } else {
            const num = try parseInt(u32, line, 10);
            acc += num;
        }
    }
    if (acc > best) {
        best = acc;
    }
    return best;
}

fn isBlankLine(line: String) bool {
    return eql(u8, line, "");
}

fn splitLines(str: String, list: *ArrayList(String)) !void {
    var it = std.mem.split(u8, str, "\n");
    while (it.next()) |line| {
        try list.append(line);
    }
}

fn contentsFile(filename: String) !String {
    const max_file_size = 100000;
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    return file.reader().readAllAlloc(
        allocator,
        max_file_size,
    );
}
