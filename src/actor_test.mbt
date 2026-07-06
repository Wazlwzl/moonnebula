struct Counter {
  mut val : Int
}

async test "actor graceful shutdown" {
  let count = { val: 0 }
  let actor = Actor::new(
    started=fn(ctx) {
      ctx.stop()
    },
    handle=fn(_ctx, _msg : Unit) {
      count.val += 1
    },
    stopped=fn(_ctx) {
      count.val = 42
    }
  )
  
  run_system(fn(sys) {
    let _addr = sys.spawn(actor)
  })
  
  inspect(count.val, content="42")
}
