// --- Literal Typees --------
u16 // u16
i16 // i16
u32 // u32
i32 // i32
u64 // u64
i64 // i64
f64 // f64
char // char
str // &'static str
usize // usize

// Declaration
// Scope of variale is determined by where it is declared, not assigned
let age: u32
age = 32

// Explicit typing
let ratio: f64 = 0.0

// With postfix
let ratio = 0f
let capacity = 125ul

// Implicit typing
let ratio = 0.0
let name = "Sabree Blackmon" // &'static str

// --- Casting --------

// --- Arrays T[n] --------

// --- Arrays T[n] --------

// Type Declaration

type buffer = i32[8]

type CalendarYear = Month[12] // A calendar year is a 12 element array of months

// Instantiation
let hello: char[5]
hello = ['h', 'e', 'l', 'l', 'o'] // char[5]

// Explicit typing
let order: i32[5] = [1, 2, 5, 9, 10]

// Type inferred
let letters = ['a', 'c', 'e', 'g']  // char[4]

// --- Allocated Types -----------------------

// These are heap allocated. However, they maintain their immutability.

// --- String ------
// Any method that alters string content creates a clones of the string, and returns the new string
    // The alteration occurs on the new string -- Rust string methods are still mutating state internally

// The current length of the string is part of its type -- this is character/rune count, not byte
    // This should be determinable at compile time
    // Functions can choose to accept string or string[usize]

let name = string("Sabree") // string[6]
let full_name = name.append(" Blackmon") // "Sabree Blackmon" : string[15]

IO.println("{}", name) // "Sabree" -- As strings are immutable 
 
// --- Vectors T[](), T[](..) --------
// Implemented with im::vector::Vector

// The current length of the vector is part of its type
    // This should be determinable at compile time
    // Functions can choose to accept type[] or type[:usize]

// Type Declaration
type ClassRole = Student[] // An vector of students

type 


// Instatiation T[]
let hello = char[]() // char[:0]

// With combinatorics 
let hello' = char[]()
    .push('h')
    .push('e') 
    .push('l')
    .push('l')
    .push('o')
    .sort() // ['e', 'h', 'l', 'l', 'o'] : char[:5]

// Initial construction -- with optional variadic list
let order = i32[](1, 2, 5, 9, 10) // i32[:5]
order =< order.push(100)

// Vectors are just arrays of unknown size. They should share much of the same interface

// --- Slices &T[] --------


// --- Set Types {}, {:n} ----------
// Sets are an unordered collections of unique things, supporting any type, including references
// You can add things, query membership and remove things, requiring PartialEq on all element types to each-other 

// Type Declaration

type members = {} // A set of infinity size

type Role = {1} // A set that contains exactly 1 elements
type Permissions = {1..} // A set that contains 1 to infinity elements
let queue: {5..10} // A set that contains 5 to 10 things

// Initial construction
let members = {&user1, 0, "Admin"}

let empty = {}

// Add and Remove
// Sets are immutable, so add and remove operations copy elements to new set, requiring Copy on all elements
let group = {superuser}
let group' = group.add(root) // Duplicate additions are allowed, but only stored once


// Membership operators 


// Type construction
if super_admin = SuperAdmin(user) // pattern matching
    ...
else if admin = Admin(user)
    ...
else

super_admin = SuperAdmin(user)? // If type construction fails, abort -- but this has no meaning
super_admin = SuperAdmin(user)! // Expect type construction to succeed -- if it doesn't, this refutes the routine


// New Types (Singletons)
newtype Name = string // Name is a string newtype

// Name is string newtype bound to the result of the value expression
newtype Name <- string(v) { // Value expressions on newtypes can omit the input argument type. 
    v.title_case()
}

// Type Aliases
type Name = string // Name is an alias for string, so uses the same constructor
surname = Name("Blackmon")

// Sigma Types (Dependent pairs)
// Simply a tuple type constructor with a value expression
type CalendarMonth <- (i32 ** i32)(a: i32) {
    a > 0 && a <= 12 ? (a, a) : ()!
}

type Sum <- ((i32, i32) ** i32)(a: i32) {
    (a, (a.0 + a.1))
}

// Generic types with specialized value expressions
type Sum(@T) <- ((i32, i32) ** i32)(a: @T)

Sum(i32)(a) {
    (a, (a.0 + a.1))
}

Sum(f64)(a) {
    (a as i32, ((a.0 + a.1) as i32)
}

// Product types
// You can specify named newtypes within the product type
// You can also use anonymous functions as value constructors
data Car { wheel: Wheel, name <- Name(v) { v.len > 0 ? v : () }, hp: Horsepower(u32) }
data Car {
    wheel <- |n: string| { // Type inference
        n < 4 ? n : () // A field that is set to () means the entire type is (). This is not configurable?
    },
    name: string,
    hp: Horsepower(u32),
}

miata = Car { wheel: ..., name: Name("Miata"), hp: HP(250) } // Field names are optional
miata = Car {
    ...,
    Name("Miata"),
    HP(250),
}

// Constructor
Car(name: string, model: ...) {

}

// Algebraic types
data Popcorn { Butter | Kettle | Caramel }
data Popcorn {
    Butter
    | Kettle
    | Caramel
}

// Constructor for ADT
Popcorn(v: string) {
    match string {
        "Butter" => Butter, // Varients can be named with full qualification in the constructor
        "Kettle" => Kettle,
        "Caramel" => Caramel,
        _ => (), // Matches must be exhaustive -- non-matches will return zero type. Non matches are not refutations, as this constructor is here for ergonomics
    }
}

// With newtypes (onefield struct) & left arrow
data Volume {
    Liters(u32)
    | Gallons <- u32(v) {
        v * 2
    } 
}

Volumes::Gallons(23) // Volumes::Gallons(46) : u32

// Generic algebraiac type
data None {
    Refuted(@T)
    | Undecided(@T)
}

data Maybe {
    Some(@T)
    | None
}

// GADTS
// All variant types must evaluate to the same type, allowing for some type inference
data Calculator {
    Add <- fn(a: i32, b: i32) { // Return type inference
        a + b
    }
    | Subtract <- fn(a: i32, b: i32) {
        a - b
    }
    | Zero = 0 // i32
    | Infinity <- { // with type inference -- same as <- fn() {
        // expression that must return an i32
    }
}

// If we allow () operator to be called on values/variants, ie, an identity function, than we can do:
impl Calculator {
    fn eval(expr: Calculator) -> i32 {
        expr()
    }
}

// Otherwise, we need a match -- 
fn eval(expr: Calculator) -> i32 {
    match expr {
        Add(a, b) => Add(a, b),
        Subtract(a, b) => Subtract(a, b),
        Zero => Zero,
        infinity => Infinity()
    }
}
eval(Add(2, 3)) // 
eval(Zero) // 0