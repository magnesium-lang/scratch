fn get_name() : IO -> str? = { // Return type:  IO -> str?
    if let Some(name) = IO.readln() { 
        name_case(name)
    } else {
        ()
    }
}


fn name_case(n: str) -> str = { // Return type: str
    ...
} 


/**
Mg does reason about how you are using data to and from effects. So, Mg treats 
functions with effects as a kind of constructor. The function takes some arguments and returns
Action -> T. Once bound, it resolves to T

This means that the return value of functions with side-effects cannot simply be composed or used without
explicit binding. **/

fn say_hello() : IO = do { // Return type: IO -> fn() -> ()
    // let name = get_name()? // Error - DNC!

    name <- get_name()? // Because say_hello returns (), returning () here is the same as `return`
    IO.println("Hello {}", name) // Lazily invokes IO effect and returns str
    // IO.println("Hello {}", get_name()) // DNC, get_name() has IO -> str type
}


/** var_name <- fn() is lazy. So it won't invoke fn() unless var_name is used
 * This can probably operate similarly to lazy_static
*/

/* Crate provided effects will typically provide type aliases to their effect_name * IO and other supporting affects under
more generic, higher level aliases
*/
type HTTPIO = HTTP::Client * HTTP::Server
type HTTP = IO * HTTPIO // (IO, HTTPIO) === IO * HTTPIO

type HTTP::Result = Result(HTTP::ReturnCode, TCPError) // Result is a type constructor

fn network_hello() : HTTP -> HTTP::Result = async {
    IO.debugln("Saying Hello to localhost")

    // Some effect types, like HTTP, have non-static methods and must be constructed explicitly
    let client = HTTP::Client("localhost")
    client.put("Hello")
        .put(" World")
        .await
}
// Full return type: IO * HTTP -> async fn() -> HTTPResult


fn say_goodbye() : IO -> str = { // IO -> str
    IO.println("Goodbye")

    "Complete"
}

fn main() : HTTP /* IO * HTTPIO */ = { 
    hello_world()
    network_hello().unwrap()
    goodbye()
}
