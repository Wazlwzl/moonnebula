///|
pub(all) enum RoutingStrategy {
  RoundRobin
  Random
}

///|
/// Creates a Router Actor that forwards messages to worker Actors based on the strategy.
pub fn[Msg] router_actor(
  workers : Array[Addr[Msg]],
  strategy : RoutingStrategy,
) -> Actor[Msg] {
  let mut current = 0
  Actor::new(handle=fn(_ctx, msg) {
    if workers.length() == 0 {
      return
    }
    match strategy {
      RoundRobin => {
        let idx = current % workers.length()
        current += 1
        let _ = workers[idx].try_send(msg)
        ()
      }
      Random => {
        let idx = (current * 31 + 17) % workers.length()
        current += 1
        let _ = workers[idx].try_send(msg)
        ()
      }
    }
  })
}
