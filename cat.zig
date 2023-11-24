const std = @import("std");
const print = std.debug.print;
const os = std.os;

const c_string = [*:0]u8;
const string = []const u8;

pub fn main() !void {
    print("**cat.zig\n", .{});
    //for (os.argv, 0..) |arg, i| {print("arg{d} = {s}\n", .{ i, arg });}
    const n_args = os.argv.len - 1;
    //print("n_args={d}\n", .{n_args});
    if (n_args != 1) @panic("need exactly one arg");
    const filename = std.mem.span(os.argv[1]);
    //print("filename={s}\n", .{filename});
    //print("contents='{s}'\n", .{dummyContents(filename)});
    //try seeFileLines(filename);
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();
    const s = try contentsFile(allocator, filename);
    print("{s}", .{s});
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

fn dummyContents(filename: string) string {
    _ = filename;
    return "line1\nline2";
}

fn seeFileLines(filename: string) !void {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    const max_line_length = 200;
    var buf: [max_line_length]u8 = undefined;
    var i: usize = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| : (i += 1) {
        print("line{d}='{s}'\n", .{ i, line });
    }
}
