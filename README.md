# MoonNebula (星云)

MoonNebula is a high-performance Actor concurrency framework built natively on `moonbitlang/async`. It brings Erlang/OTP and Rust Actix style lock-free concurrency, message passing, and supervision trees to the MoonBit ecosystem.

## Features
- **Async Message-Driven**: No callback hell, just clean `send` and `receive`.
- **Strong Isolation**: State is isolated within individual Actors.
- **Fault-Tolerance**: Supervision trees for self-healing systems.
- **Type-Safe**: Compile-time type checking for message handling.
