
const std = @import("std");
const print = std.debug.print;
const x = 41;

pub fn main() void {
    print("Hello {} world.\n", .{x+1});
}
