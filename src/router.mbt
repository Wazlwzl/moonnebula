/// A Router allows distributing messages across multiple Actors.
pub struct Router[Msg] {
  workers : Array[Addr[Msg]]
  mut current : Int
}

/// Creates a new RoundRobin router.
pub fn[Msg] Router::new(workers : Array[Addr[Msg]]) -> Router[Msg] {
  { workers, current: 0 }
}

/// Sends a message to the next worker in the pool.
pub async fn[Msg] Router::send(self : Router[Msg], msg : Msg) -> Unit {
  if self.workers.length() == 0 {
    return
  }
  let idx = self.current % self.workers.length()
  self.current += 1
  let addr = self.workers[idx]
  addr.send(msg)
}
