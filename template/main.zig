const std = @import("std");
pub fn main() !void {
    const input = try std.fs.cwd().openFile("input.txt", .{});
    defer input.close();
}
test "main" {}
