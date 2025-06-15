
const std = @import("std");
// simple calc example

const print = std.debug.print;

pub fn main() !void {
    const e1 : Exp = .{ .num = .{ .value = 55 }};
    const e2 : Exp = .{ .num = .{ .value = 8 }};
    const e3 : Exp = .{ .num = .{ .value = 5 }};
    const e4 : Exp = .{ .add = .{ .left = &e2, .right = &e3 }};
    const e5 : Exp = .{ .sub = .{ .left = &e1, .right = &e4 }};

    const exp = e5;

    print("{any}\n",.{exp});

    var buf : [100]u8 = undefined;
    const n = try exp.pp(&buf);
    print("exp: '{s}'\n",.{buf[0..n]});

    const res = exp.eval();
    print("res: {any}\n",.{res});
}

const Exp = union(enum) {

    num : Num,
    sub : Sub,
    add : Add,

    const Num = struct {
        value: u32,
    };

    const Sub = struct {
        left: *const Exp,
        right: *const Exp,
    };

    const Add = struct {
        left: *const Exp,
        right: *const Exp,
    };

    fn eval(self : *const Exp) u32 {
        return switch(self.*) {
            .num => |n| n.value,
            .sub => |s| eval(s.left) - eval(s.right),
            .add => |a| eval(a.left) + eval(a.right),
        };
    }

    fn pp (self : *const Exp, buf : []u8) !u64 {
        switch(self.*) {
            .num => |x| {
                const written = try std.fmt.bufPrint(buf,"{d}",.{x.value});
                return written.len;
            },
            .sub => |x| {
                buf[0] = '(';
                const a = try x.left.pp(buf[1..]);
                buf[a+1] = '-';
                const b = try x.right.pp(buf[a+2..]);
                buf[a+b+2] = ')';
                return a+b+3;
            },
            .add => |x| {
                buf[0] = '(';
                const a = try x.left.pp(buf[1..]);
                buf[a+1] = '+';
                const b = try x.right.pp(buf[a+2..]);
                buf[a+b+2] = ')';
                return a+b+3;
            },
        }
    }

};
