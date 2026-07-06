///|
pub struct Context[Msg] {
  addr : Addr[Msg]
}

///|
pub fn[Msg] Context::new(addr : Addr[Msg]) -> Context[Msg] {
  { addr, }
}

///|
pub fn[Msg] Context::addr(self : Context[Msg]) -> Addr[Msg] {
  self.addr
}

///|
pub fn[Msg] Context::stop(self : Context[Msg]) -> Unit {
  self.addr.close()
}

///|
pub async fn[Msg, TargetMsg] Context::send(
  _self : Context[Msg],
  target : Addr[TargetMsg],
  msg : TargetMsg,
) -> Unit {
  target.send(msg)
}

///|
pub fn[Msg, TargetMsg] Context::try_send(
  _self : Context[Msg],
  target : Addr[TargetMsg],
  msg : TargetMsg,
) -> Bool {
  target.try_send(msg)
}
