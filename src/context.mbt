pub struct Context[Msg] {
  addr : Addr[Msg]
}

pub fn[Msg] Context::new(addr : Addr[Msg]) -> Context[Msg] {
  { addr, }
}

pub fn[Msg] Context::addr(self : Context[Msg]) -> Addr[Msg] {
  self.addr
}

pub fn[Msg] Context::stop(self : Context[Msg]) -> Unit {
  self.addr.close()
}
