pub struct Addr[Msg] {
  sender : Sender[Msg]
}

pub fn[Msg] Addr::new(sender : Sender[Msg]) -> Addr[Msg] {
  { sender, }
}

pub async fn[Msg] Addr::send(self : Addr[Msg], msg : Msg) -> Unit {
  self.sender.send(msg)
}

pub fn[Msg] Addr::close(self : Addr[Msg]) -> Unit {
  self.sender.close()
}
