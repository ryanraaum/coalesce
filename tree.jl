test = false

type Node
    left::Union((), Node)
    right::Union((), Node)
    ancestor::Union((), Node)
    time::Float64
end

function show(n::Node)
    print("($(n.left), $(n.right), $(n.time))")
end

function istip(n::Node)
    is((), n.left) && is((), n.right)
end

if test

    n1 = Node((), (), 0.0)
    n2 = Node((), (), 0.0)
    n3 = Node(n1, n2, 0.0)

    println(istip(n1))
    println(istip(n2))
    println(istip(n3))
end
