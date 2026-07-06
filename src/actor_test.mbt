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

async test "router round robin load balancing" {
  let count1 = { val: 0 }
  let count2 = { val: 0 }
  
  let worker1 = Actor::new(
    handle=fn(_ctx, _msg : Unit) {
      count1.val += 1
    }
  )
  
  let worker2 = Actor::new(
    handle=fn(_ctx, _msg : Unit) {
      count2.val += 1
    }
  )
  
  run_system(async fn(sys) {
    let w1 = sys.spawn(worker1)
    let w2 = sys.spawn(worker2)
    let router = sys.spawn(router_actor([w1, w2], RoundRobin))
    
    let _ = router.try_send(())
    let _ = router.try_send(())
    let _ = router.try_send(())
    
    @async.sleep(50)
    
    router.close()
    w1.close()
    w2.close()
  })
  
  inspect(count1.val, content="2")
  inspect(count2.val, content="1")
}
