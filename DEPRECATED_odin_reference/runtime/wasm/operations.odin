/*

SDG                                                                         JJ

							Skyshatter Engine
						    Wasm Operations
*/

package wasm

BaseOperations :: struct {
    instruction: wasm_instruction,
    debug_offset: int,
}


UnaryOperation :: struct ($T1) {
    using base: BaseInstruction,
    operand_1: $T1,
}

BinaryOperation :: struct ($T1, $T2) {
    using base: BaseInstruction,
    operand_1: $T1,
    operand_2: $T2,
}

TrinaryOperation :: struct ($T1, $T2, $T3) {
    using base: BaseInstruction,
    operand_1: $T1,
    operand_2: $T2,
    operand_3: $T3,
}

WasmOperation :: union {
    BaseOperation,
    UnaryOperation,
    BinaryOperation,
    TrinaryOperation,
}



