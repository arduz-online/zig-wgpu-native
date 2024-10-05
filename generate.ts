import { parseDocument } from "yaml";
import { readFileSync } from "fs";
import * as cs from "change-case";
import { defaultValue, helpersFor } from "./extra";

const file = readFileSync("webgpu.yml", "utf8").toString();
const doc = parseDocument(file).toJS() as Document;

type Doc = { readonly name: string; readonly doc?: string };
type WConstant = Doc & { readonly value: string };
type WBitflag = Doc & {
  readonly entries: Array<Doc & { value_combination?: string[] }>;
};
type WEnum = Doc & {
  readonly entries: Array<Doc & { value?: any }>;
};
type WStruct = Doc & {
  readonly members: Array<Member>;
  readonly free_members?: boolean;
  readonly type: string;
  readonly extends?: string[];
};
type WCallback = Doc & {
  readonly args: Array<Member>;
  readonly style: string;
};
type WFunction = Doc & {
  readonly args: Array<Member>;
  readonly returns: Member;
  readonly callback?: string;
  readonly returns_async?: Array<Member>;
};
type Member = Doc & {
  readonly type: string;
  readonly pointer?: string;
  readonly optional?: boolean;
};
type WObject = Doc & { readonly methods: Array<WFunction> };
type Document = {
  constants: Array<WConstant>;
  bitflags: Array<WBitflag>;
  enums: Array<WEnum>;
  structs: Array<WStruct>;
  callbacks: Array<WCallback>;
  function_types: Array<WCallback>;
  functions: Array<WFunction>;
  returns_asyncs: Array<WCallback>;
  objects: Array<WObject>;
};

if (process.argv.includes("json")) {
  console.log(JSON.stringify(doc, null, 2));
  process.exit(0);
}

function find<T>(
  identifier: string,
): (T & { ns: string; cleanName: string }) | null {
  try {
    let [ns, name] = identifier.split(".");
    if (!ns.endsWith("s")) ns = ns + "s";
    return {
      ns,
      cleanName: name,
      ...(doc as any)[ns].find((x: any) => x.name == name),
    };
  } catch (e: any) {
    process.stderr.write("\n" + e.message + JSON.stringify(identifier));
    process.stderr.write("\n" + e.stack);
    return null;
  }
}

function wgpuName(ns: string | undefined, n?: string) {
  return cs.camelCase(`wgpu_${ns ?? ""}${n ? "_" + n : ""}`.replace("__", "_"));
}

console.log(helpersFor("FileHeader"));

function safeZig(word: string) {
  switch (word) {
    case "opaque":
      return "opaq";
    case "type":
      return "typ";
    case "error":
      return "err";
    case "undefined":
      return "undef";
  }
  return word;
}

function printDoc(doc: string | undefined) {
  if (typeof doc !== "string") return;
  if (!doc) return;
  if (doc.trim() == "TODO") return;
  console.log(
    doc
      .split(/\n/gi)
      .map((_) => `/// ${_}`)
      .join("\n"),
  );
}

function enumName(name: string) {
  switch (name) {
    case "1D":
    case "2D":
    case "3D":
    case "2D_array":
      return enumName("dim_" + name.toLowerCase());
  }
  return safeZig(cs.snakeCase(name));
}

function NAME(name: string) {
  return cs.pascalCase(cs.pascalCase(name).replaceAll("_", ""));
}

function byName(a: Doc, b: Doc) {
  return a.name > b.name ? -1 : 1;
}

for (const i in doc) {
  if (Array.isArray((doc as any)[i])) {
    (doc as any)[i] = (doc as any)[i].toSorted(byName);
  }
}

doc.returns_asyncs = doc.objects
  .map(($) => $.methods)
  .flat()
  .filter(($) => $.returns_async)
  .map(($): WCallback => {
    return {
      name: `return_async.${$.name}`,
      style: "return_async",
      args: $.returns_async!,
    };
  });

console.log(`

// Constants`);
for (const C of doc.constants ?? []) {
  printDoc(C.doc);
  console.log(`pub const ${cs.constantCase(C.name)} = ${C.value};`);
}
console.log(`

// Enums`);
for (const C of doc.enums) {
  printDoc(C.doc);
  console.log(`pub const ${NAME(C.name)} = enum(EnumType) {`);
  let i = 0;
  for (const E of C.entries) {
    if (E) {
      printDoc(E.doc);

      let value =
        E.value ?? `0x${i.toString(16).padStart(8, "0").toUpperCase()}`;

      console.log(`  ${enumName(E.name)} = ${value},`);
    } else if (i == 0) {
      console.log(`  undef = ${i},`);
    }
    i++;
  }

  console.log(helpersFor(NAME(C.name)));
  console.log("};\n");
}

console.log(`// BitFlags`);
for (const C of doc.bitflags) {
  printDoc(C.doc);
  console.log(`pub const ${NAME(C.name)}Flags = packed struct(Flags) {`);
  let i = 0;
  for (const E of C.entries) {
    if (E.name == "none") continue;

    if (!E.value_combination) {
      printDoc(E.doc);
      console.log(`  ${enumName(E.name)}: bool = false,`);
      i++;
    }
  }
  if (i < 32) console.log(`\n  _padding: u${32 - i} = 0,\n`);

  for (const E of C.entries) {
    if (E.value_combination) {
      printDoc(E.doc);
      console.log(`  pub const ${E.name} = ${NAME(C.name)}Flags{`);
      E.value_combination.forEach((x: string) => {
        if (x == "none") return;
        console.log(`    .${enumName(x)} = true,`);
      });
      console.log(`  };`);
    }
  }
  console.log("};\n");
}

function isStructFull(name: string) {
  const struct = find(name) as WStruct & { ns: string };
  if (!struct) return false;

  if (struct.ns != "structs") return;
  return (
    struct.members?.every((x) =>
      T(x, true, struct.name).zig.argType.includes("="),
    ) ?? true
  );
}

function T(
  m: Member,
  printDefVal: boolean,
  parentName: string,
): Member & {
  zig: {
    readonly isArray?: boolean;
    readonly argType: string;
    readonly type: string;
  };
} {
  let { type, optional, pointer, name } = m;
  let zigType = "void";
  let defVal = null;

  const isArray = type.startsWith(`array<`);

  if (isArray) {
    type = type.substring(6);
    type = type.substring(0, type.length - 1);
  }

  if (type == "string") {
    zigType = "[*:0]const u8";
    if (optional) defVal = "null";
  } else if (type == "uint16") {
    zigType = "u16";
    defVal = 0;
  } else if (type == "int64") {
    zigType = "i64";
    defVal = 0;
  } else if (type == "c_void") {
    zigType = "anyopaque";
  } else if (type == "uint64") {
    zigType = "u64";
    defVal = 0;
  } else if (type == "uint32") {
    zigType = "u32";
    defVal = 0;
  } else if (type == "int32") {
    zigType = "i32";
    defVal = 0;
  } else if (type == "float32") {
    zigType = "f32";
    defVal = "0.0";
  } else if (type == "float64") {
    zigType = "f64";
    defVal = "0.0";
  } else if (type == "usize") {
    zigType = "usize";
    defVal = "0";
  } else if (type == "bool") {
    zigType = "Bool";
    defVal = ".false";
  } else if (type.startsWith("enum.")) {
    zigType = NAME(type.substring(5));

    const E = find<WEnum>(type)!;
    zigType = NAME(E.cleanName);

    if (E?.entries[0]) defVal = `.${enumName(E.entries[0].name)}`;
  } else if (type.startsWith("function_type.")) {
    zigType = NAME(type.substring(14));
    optional = true;
    defVal = "null";
  } else if (type.startsWith("returns_async.")) {
    zigType = NAME(type.substring(14)) + "AsyncCallback";
  } else if (type.startsWith("callback.")) {
    zigType = NAME(type.substring(9)) + "Callback";
    optional = true;
    defVal = "null";
  } else if (type.startsWith("callback_info.")) {
    zigType = NAME(type.substring(14) + "_callback_info");
  } else if (type.startsWith("bitflag.")) {
    zigType = NAME(type.substring(8)) + "Flags";
    defVal = ".{}";
  } else if (type.startsWith("struct.")) {
    zigType = NAME(type.substring(7));
    if (isStructFull(type)) {
      defVal = ".{}";
    }
  } else if (type.startsWith("object.")) {
    zigType = "*" + NAME(type.substring(7));
  }

  let argType = zigType;

  if (isArray) {
    if (pointer == "immutable") {
      argType = `?[*]const ${zigType}`;
      defVal = null;
    } else if (pointer == "mutable") {
      argType = `?[*]${zigType}`;
      defVal = null;
    }
  } else {
    if (pointer == "immutable" || type.startsWith("function_type.")) {
      argType = `*const ${zigType.replace(/^\*/, "")}`;
    } else if (pointer == "mutable" && !type.startsWith("object.")) {
      argType = `*${zigType}`;
    }
  }

  if (optional) argType = "?" + argType;

  if (optional || isArray) defVal = "null";

  defVal = defaultValue(parentName, name, defVal);

  (m as any).zig = {
    isArray,
    argType: argType + (printDefVal && defVal !== null ? " = " + defVal : ""),
    type: zigType,
  };

  return m as any;
}

function printStruct(S: WStruct, pub?: boolean) {
  printDoc(S.doc);
  console.log(`${pub ? "pub " : ""}const ${NAME(S.name)} = extern struct {`);

  let baseType = "";
  let baseDefault = null;
  let extendees = doc.structs.filter(($) => $.extends?.includes(S.name));

  switch (S.type) {
    case "base_in":
      if (extendees.length) {
        console.log(`  pub const NextInChain = extern union {`);
        console.log(`    generic: ?*const ChainedStruct,`);
        for (const E of extendees) {
          console.log(`    ${E.name}: ?*const ${NAME(E.name)},`);
        }
        console.log(`  };\n`);

        baseType = "NextInChain";
        baseDefault = ".{ .generic = null }";
      } else {
        baseType = "?*const ChainedStruct";
        baseDefault = "null";
      }
      break;
    case "base_out":
      baseType = "?*const ChainedStructOut";
      baseDefault = "null";
      break;
    case "extension_in":
      baseType = "ChainedStruct";
      baseDefault = `.{ .next = null, .s_type = .${enumName(S.name)} }`;
      break;
    case "extension_out":
      baseType = "ChainedStructOut";
      break;
  }
  if (baseType) {
    if (baseDefault !== null) {
      console.log(`  next_in_chain: ${baseType} = ${baseDefault},`);
    } else {
      console.log(`  next_in_chain: ${baseType},`);
    }
  }

  let needsInliner = false;

  for (const E of S.members ?? []) {
    const { zig, type } = T(E, true, S.name);
    needsInliner ||= type == "bool";

    if (zig.isArray) {
      needsInliner = true;
      console.log(`    ${enumName(E.name)}_count: usize = 0,`);
    }
    printDoc(E.doc);
    console.log(`    ${enumName(E.name)}: ${zig.argType},`);
  }

  if (needsInliner && !S.free_members) {
    console.log(`
    /// Provides a slightly friendlier Zig API to initialize this structure.
    pub inline fn init(v: struct {`);
    if (baseType) {
      if (baseDefault !== null) {
        console.log(`  next_in_chain: ${baseType} = ${baseDefault},`);
      } else {
        console.log(`  next_in_chain: ${baseType},`);
      }
    }

    for (const E of S.members) {
      let { zig } = T(E, true, S.name);
      let printType = zig.argType;
      if (zig.isArray) {
        printType = zig.argType.replace("[*]", "[]");
      }

      if (zig.argType.startsWith("Bool = .")) {
        printType = zig.argType.replace("Bool = .", "bool =");
      }

      console.log(
        `  ${enumName(E.name)}: ${printType.replace(" = undefined", "")},`,
      );
    }
    console.log(`
    }) ${NAME(S.name)} {
        return .{`);
    if (baseType)
      console.log(`
		.next_in_chain = v.next_in_chain,`);
    for (const E of S.members) {
      let { zig, type } = T(E, true, S.name);
      if (zig.isArray) {
        console.log(
          `  .${enumName(E.name)}_count = if(v.${enumName(E.name)}) |e| e.len else 0,`,
        );
        console.log(
          `  .${enumName(E.name)} = if(v.${enumName(E.name)}) |e| e.ptr else null,`,
        );
      } else {
        if (type == "bool") {
          console.log(
            `  .${enumName(E.name)} = Bool.from(v.${enumName(E.name)}),`,
          );
        } else {
          console.log(`  .${enumName(E.name)} = v.${enumName(E.name)},`);
        }
      }
    }
    console.log(
      `
        };
    }
`.trim(),
    );
  }

  if (S.free_members) {
    console.log(`
    /// Releases the wgpu-owned memory of the members of this struct.
    pub fn deinit(self: *${NAME(S.name)}) void {
        wgpu${NAME(S.name)}FreeMembers(self);
    }
    extern fn wgpu${NAME(S.name)}FreeMembers(self: *${NAME(S.name)}) void;
`);
  }
  console.log(helpersFor(NAME(S.name)));

  console.log("};\n");
}

for (const S of doc.structs) {
  printStruct(S, true);
}

console.log(`

// Callbacks`);
for (const C of doc.callbacks ?? []) {
  printDoc(C.doc);
  console.log(`pub const ${NAME(C.name)}Callback = *const fn (`);
  for (const E of C.args) {
    printDoc(E.doc);
    const { zig } = T(E, false, "");
    console.log(`  ${safeZig(E.name)}: ${zig.argType},`);
  }
  console.log(
    "userdata1: ?*anyopaque, userdata2: ?*anyopaque) callconv (.C) void;",
  );
  console.log(`pub const ${NAME(C.name)}CallbackInfo = extern struct {`);
  console.log(`    next_in_chain: ?*const ChainedStruct = null,`);
  console.log(`    callback: ${NAME(C.name)}Callback,`);
  console.log(`    userdata1: ?*anyopaque = null,`);
  console.log(`    userdata2: ?*anyopaque = null,`);
  console.log(`};\n`);
}

for (const C of doc.returns_asyncs ?? []) {
  printDoc(C.doc);
  console.log(
    `const ${NAME(C.name).replace("ReturnAsync", "")}AsyncCallback = *const fn (`,
  );
  for (const E of C.args) {
    printDoc(E.doc);
    const { zig } = T(E, false, "");
    console.log(`  ${safeZig(E.name)}: ${zig.argType},`);
  }
  console.log("userdata: ?*anyopaque) callconv (.C) void;");
}

console.log(`
// Function types`);
for (const C of doc.function_types ?? []) {
  printDoc(C.doc);
  console.log(`pub const ${NAME(C.name)} = *const fn (`);
  for (const E of C.args) {
    printDoc(E.doc);
    const { zig } = T(E, false, "");
    console.log(`  ${safeZig(E.name)}: ${zig.argType},`);
  }
  console.log(") callconv (.C) void;");
}

console.log(`

// Objects`);

function params(p: null | Member[]) {
  return (p ?? []).map((A) => T(A, false, ""));
}
function printMethod(method: WFunction, obj?: WObject) {
  printDoc(method.doc);

  let retType = T(method.returns ?? { type: "void" }, false, "");
  const argsTypes = params(method.args);

  if (obj) {
    // if it is part of an object, add the first argument
    argsTypes.unshift(
      T(
        { name: "self", pointer: "mutable", type: `object.${obj.name}` },
        false,
        "",
      ),
    );
  }

  let cb = null;

  let retStruct;

  if (method.callback) {
    retType = T({ name: "future", type: "struct.future" }, false, "");
    cb = find(method.callback);
    argsTypes.push(
      T(
        {
          name: "callback",
          type: `callback_info.${cb.cleanName}`,
          pointer: "immutable",
        },
        false,
        "",
      ),
    );
  } else if (method.returns_async) {
    argsTypes.push(
      T(
        {
          name: "callback",
          type: `returns_async.${method.name}`,
        },
        false,
        "",
      ),
    );
    argsTypes.push(
      T(
        {
          name: "userdata",
          type: `c_void`,
          optional: true,
          pointer: "immutable",
        },
        false,
        "",
      ),
    );
  }

  const argStruct = argsTypes.map((A) => find(A.type));
  let optionalReturn = false;

  if (retType.type == "void" && method.name.startsWith("get_")) {
    retType = argsTypes.pop()!;
    retStruct = argStruct.pop()!;
  } else if (
    (retType.type == "bool" || retType.type == "enum.status") &&
    method.name.startsWith("get_")
  ) {
    retType = argsTypes.pop()!;
    retStruct = argStruct.pop();
    optionalReturn = true;
  }

  let retTypeResolved = retType.pointer ? find<WStruct>(retType.type) : null;
  let requiresAllocator = retTypeResolved?.free_members;

  if (requiresAllocator) {
    argsTypes.push({
      name: "alloc",
      type: "",
      zig: { argType: "std.mem.Allocator", type: "std.mem.Allocator" },
    });
  }

  const haveDocs = argsTypes.find(
    (x) => (x.doc ?? "").trim().replace("TODO", "").length > 0,
  );

  if (requiresAllocator) {
    console.log("/// memory is owned by the caller.");
  }

  const header = `fn ${cs.camelCase(method.name)}(`;
  console.log(`pub ${header}`);

  const callargs = argsTypes
    .map((A, i) => {
      printDoc(A.doc);
      if (argStruct[i]?.ns == "structs" && A.pointer != "mutable") {
        console.log(
          `  ${cs.snakeCase(A.name)}: ${NAME(argStruct[i]!.cleanName)}`,
        );
      } else if (A.zig.isArray) {
        console.log(
          `  ${cs.snakeCase(A.name)}: ${A.zig.argType.replace(/\??\[\*?\]/, "[]")}`,
        );
      } else {
        console.log(`  ${cs.snakeCase(A.name)}: ${A.zig.argType}`);
      }

      if (i != argsTypes.length - 1 || haveDocs) console.log(",");

      if (argStruct[i]?.ns == "structs" && A.pointer != "mutable") {
        return "&" + cs.snakeCase(A.name);
      } else if (A.zig.isArray) {
        return [cs.snakeCase(A.name) + ".len", cs.snakeCase(A.name) + ".ptr"];
      } else {
        return cs.snakeCase(A.name);
      }
    })
    .flat();

  const retTypeStr =
    (requiresAllocator ? "!" : "") +
    (optionalReturn ? "?" : "") +
    (retStruct && !requiresAllocator
      ? retType.zig.argType.replace(/^\*/, "")
      : retType.zig.argType);

  console.log(`) ${retTypeStr} {`);

  if (retStruct) {
    const t = retType.zig.argType.replace(/[^a-z]*/gi, "");

    const varMut = retType.pointer == "immutable" ? "const" : "const";

    if (requiresAllocator) {
      console.log(`${varMut} ret: *${t} = try alloc.create(${t});`);
      if (isStructFull("struct." + retType.name)) {
        console.log(` ret.* = .{};`);
      }
      callargs.pop(); // removes the allocator
      callargs.push("ret");
    } else {
      console.log(`var ret: ${t} = std.mem.zeroes(${t});`);
      callargs.push("&ret");
    }

    const ret = retType.pointer ? "ret" : "&ret";

    const returnNull = requiresAllocator
      ? `alloc.destroy(ret);\nreturn null;`
      : "return null;";

    if (optionalReturn && method.returns?.type == "bool") {
      console.log(
        `if (${wgpuName(obj?.name, method.name)}( ${callargs.join(",")}).toNative()) { return ${ret}; }
${returnNull}`,
      );
    } else if (optionalReturn && method.returns?.type == "enum.status") {
      console.log(
        `if (${wgpuName(obj?.name, method.name)}( ${callargs.join(",")}) == .success) return ${ret};
${returnNull}`,
      );
    } else {
      console.log(
        `${wgpuName(obj?.name, method.name)}( ${callargs.join(",")});`,
      );
      console.log(`return ret;`);
    }
  } else if (retType.zig.argType == "Bool") {
    console.log(
      `return ${wgpuName(obj?.name, method.name)}(${callargs.join(",")}).toNative();`,
    );
  } else if (retType.type == "void") {
    console.log(`${wgpuName(obj?.name, method.name)}(${callargs.join(",")});`);
  } else {
    console.log(
      `return ${wgpuName(obj?.name, method.name)}(${callargs.join(",")});`,
    );
  }
  console.log(`}\n`);
}

for (const C of doc.objects) {
  printDoc(C.doc);
  console.log(`pub const ${NAME(C.name)} = opaque {`);

  const helpers = helpersFor(NAME(C.name));

  for (const E of C.methods) {
    const header = `fn ${cs.camelCase(E.name)}(`;
    if (helpers?.includes(header)) continue;
    printMethod(E, C);
  }

  console.log(`
    /// Increases the wgpu reference counter
    pub fn addRef(self: *${NAME(C.name)}) void {
        wgpu${NAME(C.name)}Reference(self);
    }

    /// Releases the wgpu-owned object.
    pub fn release(self: *${NAME(C.name)}) void {
        wgpu${NAME(C.name)}Release(self);
    }
`);
  helpers && console.log(helpers);

  for (const E of C.methods) {
    let retType = T(E.returns ?? { type: "void" }, false, "");
    const argsTypes = params(E.args).flatMap((A) => {
      if (A.zig.isArray)
        return [T({ name: A.name + "_count", type: "usize" }, false, ""), A];
      return A;
    });

    argsTypes.unshift(
      T(
        { name: "self", type: `object.${C.name}`, pointer: "mutable" },
        false,
        "",
      ),
    );

    if (E.callback) {
      retType = T({ name: "future", type: "struct.future" }, false, "");
      const cb = find(E.callback)!;
      argsTypes.push(
        T({
          name: "callback",
          type: `callback_info.${cb.cleanName}`,
          pointer: "immutable",
        }, false, ''),
      );
    } else if (E.returns_async) {
      retType = T({ name: "void", type: "void" }, false, "");
      argsTypes.push(
        T(
          {
            name: "callback",
            type: `returns_async.${E.name}`,
          },
          false,
          "",
        ),
      );
      argsTypes.push(
        T(
          {
            name: "userdata",
            type: `c_void`,
            optional: true,
            pointer: "immutable",
          },
          false,
          "",
        ),
      );
    }

    console.log(`extern fn ${wgpuName(C.name, E.name)}(`);
    console.log(
      argsTypes
        .flat()
        .map((A) => `  ${cs.snakeCase(A.name)}: ${A.zig.argType}`)
        .join(","),
    );
    console.log(`) ${retType.zig.argType};`);
  }
  console.log(`extern fn wgpu${NAME(C.name)}Reference(self: *${NAME(C.name)}) void;
    extern fn wgpu${NAME(C.name)}Release(self: *${NAME(C.name)}) void;
`);
  console.log("};\n");
}

for (const E of doc.functions) {
  printMethod(E);

  let retType = T(E.returns ?? { type: "void" }, false, '');
  if (E.callback) retType = T({ name: "future", type: "struct.future" }, false, '');
  const argsTypes = params(E.args);

  console.log(`extern fn ${wgpuName(E.name)}(`);
  console.log(
    argsTypes
      .map((A) => `  ${cs.snakeCase(A.name)}: ${A.zig.argType}`)
      .join(","),
  );
  console.log(`) ${retType.zig.argType};`);
}

console.log(helpersFor("FileFooter"));
