test "basic actor system compiles" {
  // Actor system compilation test
  let actor = Actor::new(
    handle=fn(_ctx, msg : Int) {
      ignore(msg)
    }
  )
  ignore(actor)
}

test "supervisor strategy" {
  let sup = Supervisor::new(SupervisionStrategy::OneForOne)
  ignore(sup)
  let sup2 = Supervisor::new(SupervisionStrategy::OneForAll)
  ignore(sup2)
}

test "router compilation" {
  let router : Router[Int] = Router::new([])
  ignore(router)
}

test "registry compilation" {
  let reg : Registry[Int] = Registry::new()
  ignore(reg)
}
