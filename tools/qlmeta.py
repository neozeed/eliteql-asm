#!/usr/bin/env python3
"""Create QLBox executable metadata using the linker-generated XTcc trailer."""
import pathlib
import struct
import sys

path = pathlib.Path(sys.argv[1])
payload = path.read_bytes()
if payload[-8:-4] != b"XTcc":
    raise SystemExit("Missing XTcc trailer: expected a linked QDOS executable")
name = path.name.encode("ascii")
if not 1 <= len(name) <= 36:
    raise SystemExit("QDOS filename must contain 1 to 36 ASCII bytes")
space = struct.unpack(">I", payload[-4:])[0]
header = bytearray(64)
struct.pack_into(">I", header, 0, len(payload))
header[5] = 1
struct.pack_into(">I", header, 6, space)
struct.pack_into(">H", header, 14, len(name))
header[16:16 + len(name)] = name
meta = path.parent / ".qlbox-meta"
meta.mkdir(exist_ok=True)
(meta / (name.lower().hex() + ".hdr")).write_bytes(header)
print("%s: %d bytes, QDOS data space %d" % (path, len(payload), space))
