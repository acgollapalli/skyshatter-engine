/*

SDG                                                                         JJ

							Skyshatter Engine
						    Wasm Interpreter
*/

package wasm

import "core:encoding/varint"

MAX_JUMP_LABELS :: 512
MAX_STACK_HEIGHT :: 4096

push_val :: proc(operand: $T, stack_full: []u64, stack: ^[]u64) -> bool {
    len(stack) < len(stack_full) or_return
        
    stack_full[len(stack)] = transmute(u64)operand; // WARNING(caleb): may not work for 32 bit values
    stack^ = stack_full[len(stack)+1];
}

pop_val :: proc($T: typeid, stack_full: []u64, stack: ^[]u64) -> $T {
    len(stack) < 0 or_return
        
    stack^ = stack[:len(stack) -1]
    return transmute(T)stack_full[len(stack)]
}

peek_val :: proc($T: typeid, stack_full: []u64, stack: ^[]u64) -> $T {
    if len(stack) == 0 do return {}
    
	return transmute(T)stack_full[len(stack)]
}    

push_vec :: proc(operand:[$N]$T, stack_full: []u64, stack:^[]u64) {
    N_aligned := size_of(operand) / size_of(u64)
#assert(N_aligned > 1)
    len(stack) + N_aligned <= len(stack_full) or_return
        
    operand_vec_aligned := transmute([N_aligned]u64)operand;
    // NOTE(caleb): could we just do a transmute here, like in pop_vec?
    for op, i in operand {
        stack_full[len(stack) + i] = op;
    }
    stack^ = stack_full[len(stack) + N_aligned]
}

pop_vec :: proc(out_type: $T, stack_full: []u64, stack:^[]u64) -> (out: T) {
    N_aligned := size_of(out_type) / size_of(u64)
#assert(N_aligned > 1)
    len(stack) >= N_aligned or_return
        
    out = transmute(T)raw_data(stack[len(stack) - N_aligned:])
    stack^ = stack[:len(stack) - N_aligned]
    return 
}
            
    
// NOTE(caleb): this is for the structured control flow instructions
// positive values imply forward jumps on branch
// negative values imply backward jumps on branch
@(thread_local)
label_mem : ^[MAX_JUMP_LABELS]u64

@(thread_local)
labels : []u64;
    
label_push := proc(label: int) {
    push_val(label, label_mem[:], &labels)
}
    
label_pop := proc() -> int {
    return pop_val(int, label_mem[:], &labels)
}

label_peek := proc() -> int {
    return peek_val(int, label_mem[:], &labels)
}
        
@(thread_local)
stack_mem : ^[MAX_STACK_HEIGHT]u64

@(thread_local)
stack : []u64
    
stack_push :: proc(operand: $T) {
    push_val(operand, stack_mem[:], &stack)
}

stack_pop :: proc($T: typeid) -> {
    return pop_val(T, stack_mem[:], &stack)
}

stack_push_vec :: proc(operand: $T) {
    push_vec(operand, stack_mem[:], &stack) 
}

stack_pop_vec :: proc(operand: $T) -> T {
    return pop_vec(operand, stack_mem[:], &stack)
}


wasm_exec :: proc( exec_mem: []u8, vm: VM ) -> bool {
    // TOOD(caleb): read module data here
    // TODO(caleb): control flow from main thread here
    // TODO(caleb): wait on streamed data at some point
    
    // NOTE(caleb): pc is the program counter
    // I'm just treating it as a range of continuous memory for right now
    // this may not be valid due to modules but, it's a solid working assumption
    pc := 0;
     
    label_mem = new([MAX_JUMP_LABELS]u64)
    defer free(label_mem)                       
    labels := label_mem[:0];
     
    stack_mem := new([MAX_STACK_HEIGHT]u64);
    defer free(stack_mem)
    stack := stack_mem[:0]
    
    for {
        switch wasm_instruction(exec_mem[pc]) {
            case wasm_unreachable:		return false;
            case wasm_nop:				pc += 1;
            case wasm_block:			  
            label_push(pc)
            pc += 1
            _, bt_size, bt_err := varint.decode_ileb128_buffer(exec_mem[pc:]) // read blocktype
            if (bt_err != nil) do return false;
            pc += bt_size; 
            
            case wasm_loop:			   
            label_push(-pc)
            pc += 1
            _, bt_size, bt_err := varint.decode_ileb128_buffer(exec_mem[pc:]) // read blocktype
            if (bt_err != nil) do return false;
            pc += bt_size; 
            
            case wasm_if:				 
            label_push(pc)
            pc += 1
            _, bt_size, bt_err := varint.decode_ileb128_buffer(exec_mem[pc:]) // read blocktype
            if (bt_err != nil) do return false;
            pc += bt_size; 
            
            pc += stack_pop(i32) != 0 ? 1 : label_seek_offset(pc + 1, exec_mem) 
    	    
        
}