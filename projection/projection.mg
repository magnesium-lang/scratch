// Projection trait that allows for a quick way to select composed types

data User = {
    name: str,
    email: str
}


// Newtypes automatically support this
// type Admin <- User 
// vs
// Type Alias
// type Admin = User
type Admin <- User(u) { // pattern match
    User.email == "admin@coolbeans.io" ? Admin { User } : () // a possible value of () makes the entire type propositional
} // fn(User) -> Admin { User } ?
// This '?' means Admin a propositional type and forces pattern matching or using the ? operator to resolve the proposition

let sabree = User { 
    name: "Sabree Blackmon",
    email: "sabree@hps.sh"
};

let superuser = Admin(sabree)
let user = superuser ^ User // lift User type from superuser
user.name // "Sabree Blackmon"
(superuser ^ User).name // "Sabree Blackmon"


type Radius = uint
type Year = int(y) {
    ...
} // fn(int) -> Year

data Wheel = {
    radius: Radius,
    year: Year
}

fn print_wheel(wheel: &Wheel) : IO = {
    IO.println("Wheel size:{}", wheel)
}

data Car = {
    wheel: Wheel,
    year: Year(y) {
        1930 < y < 2020 ? y : () // Because Year is an alias to uint, these comparisons don't require casting
    } // fn(Year) -> Year ?
} // Car { Wheel, Year ? } ? // Because Year is propositional, so is Car

fn main() : IO = {
    let car = Car {
        wheel: Wheel {
            radius: 20
        },
        year: 2010,
    }?
    // if this evaluates to ()?, this does not compile as main = ()
    // ? in debug build includes context specific tracing 

    wheel = car ^ Wheel
    print_wheel(&wheel) // Wheel { radius: 20 }
    car ^ Radius // Radius: 20 
    car ^ Year // DNC: Ambiguous type projection
}
