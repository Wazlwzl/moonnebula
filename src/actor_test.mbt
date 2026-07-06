test "basic actor system compiles" {
  // Actor system compilation test
  let actor = Actor::new(
    handle=fn(_ctx, msg : Int) {
      println(msg)
    }
  )
  ignore(actor)
}
