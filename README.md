# skyshatter-engine
A vapor, which grows into a cloud, and then a thundercrack splits the sky.

A game engine for the cloud.

Implementation Notes:
+ TODO: Finish Quic Implementation in https://github.com/acgollapalli/odin-quic  
+ TODO: Integrate SSL from https://github.com/acgollapalli/odin-ssl  
+ TODO: Implement WebTransport (which probably means implementing HTTP/3 while we're at it  
+ TODO: Write Web Server (nginx and the like don't support webtransport, so we don't get reverse proxy support)  
  - Odin's core:net does net have non-blocking sockets so we may need to implement using io-uring (and kqueues and IOCP for non-linux). probably best to just add it to the library and make a PR if we're going to  do it
+ TODO: Write Server-Side Simulation Library
  - Build Actor Model (possibly ZeroMQ integration)
  - Build World Tree
  - Implement Object Pools
  - Partition Logic (from world tree)
  - Build render loop (ring buffer with time deltas?)
  - build distributed coordination system for partition logic
  - build connection handoff logic on partition
  - build failover logic
  - build state caching (for failover logic)
+ TODO: Write Client Side Renderer using WebGPU bindings (or whatever else)
  - Asset Streaming (in parallel with 3d asset pipeline)
  - lighting
  - animation
  - bundle deployment for compositor switching
+ TODO: Build Client-Side Level Editor
+ TODO: Build 3D Asset Pipeline to put assets on CDN
+ TODO: Build Cloud Deployment Pipeline (and figure out how we're going to get webtransport with no boundaries between us and clients on the edge)
+ TODO: Make a website, with cool videos and stuff (and documentation...)
