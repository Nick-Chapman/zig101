const std = @import("std");
const print = std.debug.print;

const allocator = std.heap.page_allocator;

pub fn main() void {
    const e = makeFibExample(10).*;
    print("eval -> {d}\n", .{eval(e)});
}

const Exp = *const ExpV;
const Bin = struct { left: Exp, right: Exp };
//const Bin = struct { Exp, Exp }; // prefer anonymous struct?
const ExpV = union(enum) {
    int: i32,
    add: Bin,
};

fn eval(self: ExpV) i32 {
    return switch (self) {
        ExpV.int => |i| i,
        ExpV.add => |x| eval(x.left.*) + eval(x.right.*),
        //ExpV.add => |x| eval(x.@"0".*) + eval(x.@"1".*),
    };
}

fn mkNum(i: i32) Exp {
    var e = allocator.create(ExpV) catch unreachable;
    e.* = ExpV{ .int = i };
    return e;
}

fn mkAdd(left: Exp, right: Exp) Exp {
    var e = allocator.create(ExpV) catch unreachable;
    e.* = ExpV{ .add = .{ .left = left, .right = right } };
    //e.* = ExpV{ .add = .{ left, right } };
    return e;
}

fn makeFibExample(n: i32) Exp {
    if (n < 2) {
        return mkNum(n);
    } else {
        return mkAdd(makeFibExample(n - 1), makeFibExample(n - 2));
    }
}
