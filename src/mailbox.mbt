///|
pub struct Sender[Msg] {
  queue : @aqueue.Queue[Msg]
}

///|
pub fn[Msg] Sender::new(queue : @aqueue.Queue[Msg]) -> Sender[Msg] {
  { queue, }
}

///|
pub async fn[Msg] Sender::send(self : Sender[Msg], msg : Msg) -> Unit {
  self.queue.put(msg)
}

///|
pub fn[Msg] Sender::try_send(self : Sender[Msg], msg : Msg) -> Bool {
  self.queue.try_put(msg) catch {
    _ => false
  }
}

///|
pub fn[Msg] Sender::close(self : Sender[Msg]) -> Unit {
  self.queue.close()
}

///|
pub struct Receiver[Msg] {
  queue : @aqueue.Queue[Msg]
}

///|
pub fn[Msg] Receiver::new(queue : @aqueue.Queue[Msg]) -> Receiver[Msg] {
  { queue, }
}

///|
pub async fn[Msg] Receiver::recv(self : Receiver[Msg]) -> Msg {
  self.queue.get()
}

///|
pub fn[Msg] mailbox() -> (Sender[Msg], Receiver[Msg]) {
  let queue : @aqueue.Queue[Msg] = @aqueue.Queue(kind=Unbounded)
  (Sender::new(queue), Receiver::new(queue))
}
