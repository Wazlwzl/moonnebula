struct Counter {
  mut val : Int
}

struct AddrRef {
  mut val : Addr[Int]?
}

async test "actor graceful shutdown" {
  let count = Counter::{ val: 0 }
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
  let count1 = Counter::{ val: 0 }
  let count2 = Counter::{ val: 0 }
  
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

pub suberror CrashError derive(Debug, ToJson)

async test "supervisor child restart on crash" {
  let restart_count = Counter::{ val: 0 }
  let child_addr = AddrRef::{ val: None }
  
  let child_spec = ChildSpec::new("crasher", fn(sys, supervisor_addr) {
    restart_count.val += 1
    
    let actor = Actor::new(
      handle=fn(_ctx, msg : Int) -> Unit raise Error {
        if msg == -1 {
          raise CrashError
        }
      }
    )
    
    let queue : @aqueue.Queue[Int] = @aqueue.Queue(kind=Unbounded)
    let sender = Sender::new(queue)
    let receiver = Receiver::new(queue)
    let addr = Addr::new(sender)
    let ctx = Context::new(addr)
    
    child_addr.val = Some(addr)
    
    sys.group.spawn_bg(
      no_wait=true,
      allow_failure=true,
      async fn() {
        try {
          (actor.started)(ctx)
          while true {
            let msg = receiver.recv()
            (actor.handle)(ctx, msg)
          }
        } catch {
          @aqueue.QueueAlreadyClosed => ()
          _ => {
            let _ = supervisor_addr.try_send(ChildCrashed("crasher"))
            ()
          }
        }
        (actor.stopped)(ctx)
      }
    )
  })
  
  run_system(async fn(sys) {
    let supervisor = sys.spawn(supervisor_actor(sys, [child_spec], OneForOne))
    
    // Wait for initial spawn
    @async.sleep(20)
    
    // Trigger crash
    match child_addr.val {
      Some(addr) => {
        let _ = addr.try_send(-1)
        ()
      }
      None => ()
    }
    
    // Wait for crash and restart
    @async.sleep(50)
    
    // Clean up
    supervisor.close()
    match child_addr.val {
      Some(addr) => addr.close()
      None => ()
    }
  })
  
  inspect(restart_count.val, content="2")
}
