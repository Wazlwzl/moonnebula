///|
pub(all) enum SchedulerMsg[Msg] {
  SendAfter(Int, Addr[Msg], Msg)
  SendInterval(Int, Addr[Msg], Msg)
}

///|
/// Creates a Scheduler Actor that schedules delayed or periodic message delivery.
pub fn[Msg] scheduler_actor(system : System) -> Actor[SchedulerMsg[Msg]] {
  Actor::new(handle=fn(_ctx, msg) {
    match msg {
      SendAfter(delay_ms, addr, payload) =>
        system.group.spawn_bg(no_wait=true, allow_failure=true, async fn() {
          @async.sleep(delay_ms)
          let _ = addr.try_send(payload)
          ()
        })
      SendInterval(interval_ms, addr, payload) =>
        system.group.spawn_bg(no_wait=true, allow_failure=true, async fn() {
          while true {
            @async.sleep(interval_ms)
            // Stop the timer if the target actor is stopped
            if !addr.try_send(payload) {
              break
            }
          }
        })
    }
  })
}
