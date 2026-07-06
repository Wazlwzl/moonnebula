pub struct Context[Msg] {
  addr : Addr[Msg]
}

pub fn[Msg] Context::new(addr : Addr[Msg]) -> Context[Msg] {
  { addr, }
}

pub fn[Msg] Context::address(self : Context[Msg]) -> Addr[Msg] {
  self.addr
}
