pub struct System {
  group : @async.TaskGroup[Unit]
}

pub async fn run_system(f : async (System) -> Unit) -> Unit {
  @async.with_task_group(async fn(group) {
    let sys = { group, }
    f(sys)
  })
}

pub fn[Msg] System::spawn(self : System, actor : Actor[Msg]) -> Addr[Msg] {
  let queue : @aqueue.Queue[Msg] = @aqueue.Queue(kind=Unbounded)
  let sender = Sender::new(queue)
  let receiver = Receiver::new(queue)
  let addr = Addr::new(sender)
  let ctx = Context::new(addr)
  
  self.group.spawn_bg(
    no_wait=true,
    allow_failure=true,
    async fn() {
      try {
        (actor.started)(ctx)
        while true {
          let msg = receiver.recv()
          (actor.handle)(ctx, msg)
        }
      } catch {
        _ => ()
      }
      (actor.stopped)(ctx)
    },
  )

  addr
}
