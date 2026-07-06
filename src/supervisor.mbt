pub(all) enum SupervisionStrategy {
  OneForOne
  OneForAll
}

pub(all) enum SupervisorMsg {
  ChildCrashed(String)
}

pub struct ChildSpec {
  id : String
  spawn : (System, Addr[SupervisorMsg]) -> Unit
}

pub fn ChildSpec::new(id : String, spawn : (System, Addr[SupervisorMsg]) -> Unit) -> ChildSpec {
  { id, spawn }
}

pub fn supervisor_actor(
  system : System,
  children : Array[ChildSpec],
  strategy : SupervisionStrategy
) -> Actor[SupervisorMsg] {
  Actor::new(
    started=fn(ctx) {
      let self_addr = ctx.addr()
      for child in children {
        (child.spawn)(system, self_addr)
      }
    },
    handle=fn(ctx, msg) {
      match msg {
        ChildCrashed(id) => {
          match strategy {
            OneForOne => {
              for child in children {
                if child.id == id {
                  let self_addr = ctx.addr()
                  (child.spawn)(system, self_addr)
                  break
                }
              }
            }
            OneForAll => {
              let self_addr = ctx.addr()
              for child in children {
                (child.spawn)(system, self_addr)
              }
            }
          }
        }
      }
    }
  )
}
