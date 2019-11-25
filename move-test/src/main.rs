struct Thing {}

struct Node {
    has: Thing
}

fn swap(first: Node) -> Node {
    Node { has: first.has }
}

fn main() {
    let first = Node { has: Thing {} };

    let _second = swap(first);

}
