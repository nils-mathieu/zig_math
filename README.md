# zm - Zig Mathematics Library

A high-performance mathematics library for Zig, providing comprehensive vector, matrix, quaternion,
and affine transformation operations optimized for graphics programming, game development, and
scientific computing.

## Features

- **Vectors**: 2D, 3D, and 4D vectors with various scalar types, and more through the `Vector`
  generic function.
- **Matrices**: 2x2, 3x3, and 4x4 matrices for transformations, and more through the `Matrix`
  generic function.
- **Quaternions**: Efficient rotation representations, and more through the `Quaternion`
  generic function.
- **Affine Transformations**: 2D and 3D affine transformation matrices, and more through the
  `Affine` generic function.
- **SIMD Optimization**: Leverages SIMD instructions for optimal performance
- **Flexible Memory Layout**: Configurable memory representations for different use cases
- **Type Safety**: Strong typing with compile-time guarantees

## Types

## Memory Layout

The library provides flexible memory layout configurations through `ReprConfig`:

- **`.transparent`**: Compatible with `[dim]T` arrays, ideal for FFI
- **`.auto`**: Balanced approach optimizing for both performance and compatibility
- **`.optimize`**: Maximum SIMD performance optimization

## Coordinate Systems

The library supports both right-handed and left-handed coordinate systems through the `Handedness`
enum, making it suitable for various graphics APIs and mathematical conventions.

## Installation

Add zm as a dependency in your `build.zig.zon`:

```sh
zig fetch --save git+https://github.com/nils-mathieu/zig_math
```

```zig
.{
    .name = "your-project",
    .version = "0.1.0",
    .dependencies = .{
        .zm = .{
            .url = "git+https://github.com/nils-mathieu/zig_math",
            .hash = "...",
        },
    },
}
```

Then in your `build.zig`:

```zig
exe.root_module.addImport("zm", .dependency("zm", .{}).module("zm"));
```

## Usage

```zig
const zm = @import("zm");

// Create vectors
const v1 = zm.Vec3f.initXYZ(1.0, 2.0, 3.0);
const v2 = zm.Vec3f.unit_z;

// Vector operations
const dot_product = v1.dot(v2);
const cross_product = v1.cross(v2);
const normalized = v1.normalize();

// Create matrices
const identity = zm.Mat4f.identity;
const translation = zm.Mat4f.fromXYZ(1.0, 2.0, 3.0);
const rotation = zm.Mat4f.fromRotationZ(std.math.pi / 4.0);

// Matrix multiplication
const transform = translation.mul(rotation);

// Quaternions
const quat = zm.Quatf.fromAxisAngle(.unit_y, std.math.pi / 2.0);
```
