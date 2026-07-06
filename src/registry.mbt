pub(all) enum RegistryMsg[Msg] {
  Register(String, Addr[Msg])
  Lookup(String, Addr[Addr[Msg]?])
}

/// Creates a Registry Actor that manages actor registration and lookups safely.
pub fn[Msg] registry_actor() -> Actor[RegistryMsg[Msg]] {
  let actors : Map[String, Addr[Msg]] = Map([])
  Actor::new(
    handle=fn(_ctx, msg) {
      match msg {
        Register(name, addr) => {
          actors.set(name, addr)
        }
        Lookup(name, reply_to) => {
          let target = actors.get(name)
          let _ = reply_to.try_send(target)
          ()
        }
      }
    }
  )
}
