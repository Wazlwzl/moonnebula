pub struct Actor[Msg] {
  started: (Context[Msg]) -> Unit
  handle: (Context[Msg], Msg) -> Unit
  stopped: (Context[Msg]) -> Unit
}

pub fn[Msg] Actor::new(
  handle~: (Context[Msg], Msg) -> Unit,
  started~: (Context[Msg]) -> Unit = fn(_ctx) {},
  stopped~: (Context[Msg]) -> Unit = fn(_ctx) {}
) -> Actor[Msg] {
  { started, handle, stopped }
}
