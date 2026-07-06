/// A Registry allows named lookups for Actors of a specific Message type.
pub struct Registry[Msg] {
  actors : Map[String, Addr[Msg]]
}

pub fn[Msg] Registry::new() -> Registry[Msg] {
  { actors: Map([]) }
}

pub fn[Msg] Registry::register(self : Registry[Msg], name : String, addr : Addr[Msg]) -> Unit {
  self.actors.set(name, addr)
}

pub fn[Msg] Registry::get(self : Registry[Msg], name : String) -> Addr[Msg]? {
  self.actors.get(name)
}
