/*

SDG                                                                         JJ

							Skyshatter Engine
						    Wasm Interpreter
*/

WasmSectionId :: enum u8 {
    Custom = 0,
    Type = 1,
    Import = 2,
    Function = 3,
	Table = 4,
	Memory = 5,
	Global = 6,
    Export = 7,
	Start = 8,
	Element = 9,
    Code = 10,
    Data = 11,
	DataCount = 12,
}

WasmSection :: struct {
    section_id: WasmSectionId,
    size: u32,
    content: WasmSectionContent,
}

WasmCustomSectionContent :: struct {
    name: string,
    data: []u8, // this should be used for IAHP stuff
}

WasmTypeSectionContent :: struct {
    types: []WasmFunctionType,
}

WasmImportContent :: struct {
    imports: []WasmImport,
}

WasmFunctionContent :: struct {
    types: []WasmTypeIndex
}

WasmTableSection :: struct {
    []WasmTableType,
}

WasmMemorySection :: struct {
    []WasmMemoryType,
}

WasmGlobalSection :: struct {
    []struct { type: WasmGlobalType, init: u128 }   
}

WasmExportSection :: struct {
    []WasmExtern,
}

WasmStartSection :: struct {
    start: WasmFunctionIndex,
}

WasmElementSection :: struct {
    elements: WasmElementSegment,
}

WasmCodeSection :: struct {
    entries: WasmCodeEntry,
}

WasmDataSection :: struct {
    segments: WasmDataSegment,
}

WasmDataCountSection :: struct {
    count: u32,
}

WasmSectionContent :: union {
    WasmCustomSectionContent,
    WasmImportContent,
    WasmTypeSectionContent,
    WasmFunctionSection,
    WasmTableSection,
    WasmMemorySection,
    WasmGlobalSection,
    WasmExportSection,
    WasmStartSection,
    WasmElementSection,
    WasmCodeSection,
    WasmDataSection,
    WasmDataCountSection,
}

WASM_MAGIC_NUMBER :: `\0asm`

WasmModule :: struct {
    // magic
    version: [4]u8,
    sections: []
}