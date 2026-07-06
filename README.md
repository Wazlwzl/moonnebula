# MoonNebula (星云)

MoonNebula is a high-performance, strongly typed Actor concurrency runtime and ecosystem framework built natively on `moonbitlang/async` for the MoonBit ecosystem. It draws inspiration from Erlang/OTP and Rust's Actix, providing a highly scalable, fault-tolerant, and lock-free programming model.

## Architecture Overview

```text
                     +---------------------------------------+
                     |             System Context            |
                     +---------------------------------------+
                                         |
                                         v
                      +-------------------------------------+
                      |           Supervisor Actor          |
                      +-------------------------------------+
                                 | (supervises/restarts)
                                 v
        +-------------------------------------------------------------+
        |                                                             |
        v                                                             v
+---------------+  (registers)   +---------------+  (resolves)   +---------------+
|  Actor Pool   | -------------> | Name Registry | <------------ | Client Actor  |
+---------------+                +---------------+               +---------------+
| Worker Actor  |                                                | SendAfter msg |
| Worker Actor  | <============================================= | (via Timer)   |
+---------------+                    (message)                   +---------------+
```

## Features

- **Async Message-Driven**: Build scalable programs without callback hell using pure lock-free async channels.
- **Strong Isolation**: Memory state is fully isolated inside individual Actors, eliminating data races.
- **Supervision Trees**: Built-in Supervisor actors monitoring children and executing `OneForOne` self-healing strategies.
- **Routing & Load Balancing**: Load balance CPU-heavy tasks across worker pools using `RoundRobin` and `Random` Router actors.
- **Dynamic Name Registry**: Decouple actors via a concurrent request-response Name Registry.
- **Cron-like Timer Wheel**: Centralized Scheduler Actor managing leak-free interval and delayed message delivery.

## Quick Start

### 1. Define an Actor

```moonbit
let worker = Actor::new(
  started=fn(ctx) {
    println("Actor started!")
  },
  handle=fn(ctx, msg : Int) {
    println("Received: " + msg.to_string())
    if msg == 0 {
      ctx.stop() // Gracefully shutdown
    }
  },
  stopped=fn(ctx) {
    println("Actor stopped!")
  }
)
```

### 2. Spawn and Send Messages

```moonbit
run_system(async fn(sys) {
  let addr = sys.spawn(worker)
  
  // Non-blocking send
  let _ = addr.try_send(42)
  
  // Wait a bit
  @async.sleep(10)
  
  // Graceful shutdown
  let _ = addr.try_send(0)
})
```

## Running Tests

Verify the concurrent runtime and all ecosystem components:

```bash
moon test --target js
```
