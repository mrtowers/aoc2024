const std = @import("std");
const io = std.io;
const Allocator = std.mem.Allocator;
const ascii = std.ascii;

pub fn main() !void {
    const input = try std.fs.cwd().openFile("input.txt", .{});
    defer input.close();
}

fn day1(ally: Allocator, input: io.AnyReader) !i32 {
    const list1 = std.AutoHashMap(i32, i32).init(ally);
    const list2 = std.AutoHashMap(i32, i32).init(ally);

    while (true) {
        const n1 = parseNumber(ally, input) catch {
            break;
        };
        const n2 = parseNumber(ally, input) catch unreachable;

        const res1 = try list1.getOrPut(n1);
        res1.value_ptr.* += 1;
        const res2 = try list2.getOrPut(n2);
        res2.value_ptr.* += 1;
    }

    const arr1 = try std.ArrayList(i32).initCapacity(ally, list1.count());
    var list1_iter = list1.keyIterator();
    while (list1_iter.next()) |entry| {
        arr1.append(entry);
    }
    std.mem.sort(i32, arr1.items, .{}, std.sort.asc);

    const arr2 = try std.ArrayList(i32).initCapacity(ally, list2.count());
    var list2_iter = list2.keyIterator();
    while (list2_iter.next()) |entry| {
        arr2.append(entry);
    }
    std.mem.sort(i32, arr2.items, .{}, std.sort.asc);
}

fn parseNumber(ally: Allocator, input: io.AnyReader) !i32 {
    var number_arr = try std.ArrayList(u8).initCapacity(ally, 5);
    defer number_arr.deinit();

    var b: u8 = undefined;
    while (true) {
        b = input.readByte() catch {
            if (number_arr.items.len == 0) {
                return 0;
            } else {
                return std.fmt.parseInt(i32, number_arr.items, 10);
            }
        };
        if (std.ascii.isDigit(b)) {
            try number_arr.append(b);
        } else if (number_arr.items.len == 0) {
            continue;
        } else {
            return std.fmt.parseInt(i32, number_arr.items, 10);
        }
    }
}

test "main" {
    const testing = std.testing;
    const input =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;
    try testing.expectEqual(11, day1(testing.allocator, io.fixedBufferStream(input)));
}

test "parseNumber" {
    const testing = std.testing;
    const input = "32145, 42142, 6 1613246, 431";
    var stream = io.fixedBufferStream(input);
    const reader = stream.reader().any();
    try testing.expectEqual(32145, try parseNumber(testing.allocator, reader));
    try testing.expectEqual(42142, try parseNumber(testing.allocator, reader));
    try testing.expectEqual(6, try parseNumber(testing.allocator, reader));
    try testing.expectEqual(1613246, try parseNumber(testing.allocator, reader));
    try testing.expectEqual(431, try parseNumber(testing.allocator, reader));
}
