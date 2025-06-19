
// explore higher order functions and simulating closures in zig

const std = @import("std");
const print = std.debug.print;

var gpa = std.heap.DebugAllocator(.{}){};
const allocator = gpa.allocator();

const Fuu = struct {
    ptr: *anyopaque,
    _func: *const fn (ptr: *anyopaque, data: u32) u32,

    fn init(ptr: anytype) Fuu {
        const T = @TypeOf(ptr);
        const ptr_info = @typeInfo(T);
        const gen = struct {
            pub fn func(pointer: *anyopaque, data:u32) u32 {
                const me: T = @ptrCast(@alignCast(pointer));
                return ptr_info.@"pointer".child.call(me, data);
            }
        };
        return .{
            .ptr = ptr,
            ._func = gen.func,
        };
    }
    fn call(me: Fuu, data: u32) u32 {
        return me._func(me.ptr, data);
    }
};

const AddBy = struct {
    inc: u8,
    fn init(inc: u8) Fuu {
        const me : *AddBy = allocator.create(AddBy) catch unreachable;
        me.* = AddBy{.inc = inc};
        return Fuu.init(me);
    }
    fn call(me:*AddBy, arg:u32) u32 {
        return me.inc + arg;
    }
};

const MulBy = struct {
    mul: u8,
    fn init(mul: u8) Fuu {
        const me : *MulBy = allocator.create(MulBy) catch unreachable;
        me.* = MulBy{.mul = mul};
        return Fuu.init(me);
    }
    fn call(me:*MulBy, arg:u32) u32 {
        return me.mul * arg;
    }
};

const Compose = struct {
    f: Fuu,
    g: Fuu,
    fn init(f:Fuu, g:Fuu) Fuu {
        const me : *Compose = allocator.create(Compose) catch unreachable;
        me.* = Compose{.f = f, .g=g};
        return Fuu.init(me);
    }
    fn call(me:*Compose, arg:u32) u32 {
        return me.f.call(me.g.call(arg));
    }
};

pub fn main() void {
    const f = MulBy.init(2);
    const g = AddBy.init(5);
    const fg = Compose.init(f,g);
    const gf = Compose.init(g,f);
    caller(f);
    caller(g);
    caller(fg);
    caller(gf);
}

fn caller(f: Fuu) void {
    const arg = 100;
    const res = f.call(arg);
    print("caller: {d} -> {d}\n", .{arg,res});
}
