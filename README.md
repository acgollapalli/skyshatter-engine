# Kingdom Core

This is a project to display the capabilities of the Interactive HyperMedia Protocol for making interactive online games.

Some notes on IAHP:
Programs for the IAHP are client-server programs.
On the client-side, programs run in a wasm64 environment with a subset of the SDL3 GPU apis, some QUIC networking abstractions, a subset of WASI
including thread spawning, random number, and clock utilities, and some utilities to share memory between processes linked by the host.
Programs link to one another using their server ID's
Programs may run at the same time, with the first program providing the second program a texture to render to, which is then
presented to the screen by the first program.
Programs may handoff control to one of their child programs.
Programs are provided the device and either the swapchain image or the texture image for which they should render.
Programs are also provided api's to choose whether to render fullscreen.
Programs are provided input data from the host environment.
Child programs are not provided any of this. All data required for the display will be provided by the parent program.

Programs, regardless of whether they are a parent program or a child program, will have access to the network via iahp.
Programs may share memory between parent and child processes.
Programs will NOT have to use the asynchronous model of the browser. A simple main-loop will do.

Some notes on the engine:
I originally started this in Odin, and got as far as a quic implementation, some mappings for wasi, and some work on a game using the SDL gpu api.
I think the SDL gpu api is the right thing because, while it is a bit more restrictive than something like Vulkan, it is sufficiently powerful for
the sort of games I expect to be initially made. Moreover, unlike WebGPU, the SDL is made by games people for games people, and for the games
people are making. If there is something people need for their games, it'll most likely be added. I can't expect the same from the implementers of
WebGPU at Mozilla, and don't want to kludge my own or make everybody write Vulkan. It's better to have something that people know will run everywhere.
As for shader languages, we will not be requiring people to use SDL's experimental shader language. Maybe in the future, but for right now, we'll stick
to letting people provide their own, with a recommendation that they use Slang as a part of their build process. We're trying slang out here to see how 
well it works out for us.

Why JAI? The metaprogramming facilities _should_ let us do things like have a `@client-only` or `@server-only` declaration at the top of a file, or on a 
function, meaning you can have a build process and a testing process that feels less like a kludge and a bit more unified. Think something like NextJS
but for multiplayer games (I can hear Jon's pained screams). The reality is that games were full-stack way before webapps, their networking and overall
architecture is far more complicated. While the IAHP idea was to do games in a way that made use of modern web-tech, the reality is that all that's missing
from games is CDN's and that's due to the hard realtime requirements and the difficulty of solving when assets are needed, and when they should be gotten
rid of. That's the hard problem we need to solve.  
