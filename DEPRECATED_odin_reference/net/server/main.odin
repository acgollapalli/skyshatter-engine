package server

// std library declarations
import "base:runtime"
import "core:fmt"
import "core:mem"
import "core:net"
import "core:os"

// in engine declarations
import "net:http/nbio"
import "net:http/nbio/poly"
import "net:quic"

// base constants
PORT :: #config(PORT, 8443)
ADDRESS :: #config(ADDRESS, "127.0.0.1")

MAX_DATAGRAM_SIZE :: #config(MAX_DGRAM_SIZE, 4096)
INIT_RECV_BUFS :: #config(INIT_RECV_BUFS, 100)


Quic_Server :: struct {
	io:   nbio.IO,
	sock: net.UDP_Socket,
}

UDP_Ctx :: struct {
	server: ^Quic_Server,
	buf:    []byte,
	sock:   net.UDP_Socket,
}

main :: proc() {
	address := net.parse_address(ADDRESS)
	fmt.assertf(address != nil, "Error parsing connection params: %v", ADDRESS)

	address_family := net.family_from_address(address)
	endpoint := net.Endpoint{address, PORT}

	server: Quic_Server

	nbio.init(&server.io)
	defer nbio.destroy(&server.io)

	// We'll set aside some memory for our initial receive buffers
	initial_receive_buffers: mem.Dynamic_Arena
	mem.dynamic_arena_init(&initial_receive_buffers)
	defer mem.dynamic_arena_destroy(&initial_receive_buffers)

	// open socket
	sock, err := nbio.open_socket(&server.io, address_family, .UDP)
	socket := sock.(net.UDP_Socket)

	// bind socket
	if err = net.bind(socket, endpoint); err != nil {
		net.close(socket)
		return
	}

	fmt.assertf(err == nil, "Error opening socket: %v", err)
	server.sock = socket

	alloc := mem.dynamic_arena_allocator(&initial_receive_buffers)

	for _ in 0 ..< INIT_RECV_BUFS {
		receive_quic(&server, socket, alloc)
	}

	// event loop
	errno: os.Errno
	for errno == os.ERROR_NONE {
		errno = nbio.tick(&server.io)
	}

	fmt.assertf(
		errno == os.ERROR_NONE,
		"Server stopped with error code: %v",
		errno,
	)
}


receive_quic :: proc(
	server: ^Quic_Server,
	client: net.UDP_Socket,
	allocator: runtime.Allocator,
) {
	ctx := new(UDP_Ctx)
	buf := new([MAX_DATAGRAM_SIZE]byte)
	ctx.buf = buf[:]
	ctx.server = server
	ctx.sock = client

	nbio.recv(&server.io, client, ctx.buf, &ctx, quic_on_recv)
}

quic_on_recv :: proc(
	ctx: rawptr,
	received: int,
	_: Maybe(net.Endpoint),
	err: net.Network_Error,
) {
	ctx := transmute(^UDP_Ctx)ctx
	if err == nil {
		quic.handle_datagram(ctx.buf[:received])
	} else {
		fmt.println("Error receiving from client: %v", err)
	}

	ctx.buf = ctx.buf[0:MAX_DATAGRAM_SIZE]

	nbio.recv(&ctx.server.io, ctx.sock, ctx.buf, &ctx, quic_on_recv)
}
