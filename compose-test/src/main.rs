#![feature(unboxed_closures)]
#![feature(fn_traits)]

use futures::executor::block_on;
use std::future::Future;
use std::pin::Pin;
use std::task::{Context, Poll};

enum IOOp {
    None,
    Write(String),
}
pub struct IO {
    op: IOOp,
}

impl Future for IO {
    type Output = ();

    fn poll(self: Pin<&mut Self>, _cx: &mut Context) -> Poll<Self::Output> {
        match &self.op {
            IOOp::None => Poll::Ready(()),
            IOOp::Write(string) => {
                println!("{}", string);
                Poll::Ready(())
            }
        }
    }
}

impl IO {
    fn println(self, s: &str) -> IO {
        IO {
            op: IOOp::Write(s.to_owned()),
        }
    }

    fn new() -> IO {
        IO { op: IOOp::None }
    }
}

impl std::ops::FnOnce<String> for IO {
    type Output = ();
    extern "rust-call" fn call_once(self, args: String) -> Self::Output {
        println!("{}", args);
    }
}

impl std::ops::FnMut<String> for IO {
    extern "rust-call" fn call_mut(&mut self, args: String) -> Self::Output {
        self.call_once(args)
    }
}

async fn hello_world() {
    let io = IO::new(); // Create IO effect for use
    let io = io.println("Hello World"); // let IO = (Use update syntax?)
    io.await // execute IO effect
}

async fn _goodbye() -> (IO, String) {
    let io = IO::new(); //
    let io = io.println("Goodbye"); // let IO =
    (io, "Complete".to_owned()) //
}

async fn say_hello() /* -> impl Future<Output = ()> */ // async ()
{
    async {
        let io = IO::new(); //
        let io = io.println("Hello!"); // let IO =
        io.await
    }
        .await
}

fn main() {
    block_on(say_hello());
    let _num = block_on(hello_world());
}
