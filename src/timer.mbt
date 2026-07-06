/// Timer allows sending delayed or periodic messages to Actors.
pub struct Timer {
  system : System
}

pub fn Timer::new(system : System) -> Timer {
  { system, }
}

/// Sends a message after a specified delay in milliseconds.
pub fn[Msg] Timer::send_after(self : Timer, delay_ms : Int, addr : Addr[Msg], msg : Msg) -> Unit {
  self.system.group.spawn_bg(
    no_wait=true,
    allow_failure=true,
    async fn() {
      @async.sleep(delay_ms)
      addr.send(msg)
    }
  )
}

/// Sends a message periodically at a specified interval.
pub fn[Msg] Timer::send_interval(self : Timer, interval_ms : Int, addr : Addr[Msg], msg : Msg) -> Unit {
  self.system.group.spawn_bg(
    no_wait=true,
    allow_failure=true,
    async fn() {
      while true {
        @async.sleep(interval_ms)
        addr.send(msg)
      }
    }
  )
}
