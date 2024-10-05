#!/usr/bin/env bash

bun run generate.ts > src/wgpu.zig

zig fmt .

zig build test
