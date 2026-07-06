pub(all) enum SupervisionStrategy {
  OneForOne
  OneForAll
}

pub struct Supervisor {
  strategy : SupervisionStrategy
}

pub fn Supervisor::new(strategy : SupervisionStrategy) -> Supervisor {
  { strategy, }
}

/// Supervises an actor and restarts it if it crashes (simulated for now).
pub fn[Msg] Supervisor::supervise(_self : Supervisor, system : System, actor : Actor[Msg]) -> Addr[Msg] {
  let queue : @aqueue.Queue[Msg] = @aqueue.Queue(kind=Unbounded)
  let sender = Sender::new(queue)
  let receiver = Receiver::new(queue)
  let addr = Addr::new(sender)
  
  // Note: MoonNebula Supervisor MVP
  // A fully fault-tolerant supervisor would trap task panics/errors here.
  system.group.spawn_bg(
    no_wait=true,
    allow_failure=true,
    async fn() {
      let ctx = Context::new(addr)
      (actor.started)(ctx)
      while true {
        let msg = receiver.recv()
        (actor.handle)(ctx, msg)
      }
      // Unreachable without errors, but reserved for shutdown logic
      (actor.stopped)(ctx)
    },
  )
  
  addr
}
