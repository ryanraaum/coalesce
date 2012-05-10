test = false

type Node
    name::String
    left::Union((), Node)
    right::Union((), Node)
    ancestor::Union((), Node)
    time::Float64
end

istip(n::Node) = is((), n.left) && is((), n.right)
isroot(n::Node) = is((), n.ancestor)

function to_newick(n::Node)
    if istip(n)
        time = string(n.time)
        time = time[1:min(6, length(time))]
        "$(n.name):$(time)"
    elseif isroot(n)
        "($(to_newick(n.left)),$(to_newick(n.right)));"
    else
        time = string(n.time)
        time = time[1:min(6, length(time))]
        "($(to_newick(n.left)),$(to_newick(n.right)))$(n.name):$(time)"
    end
end

show(io, n::Node) = print(io, to_newick(n))
#print(n::Node) = print(to_newick(n))

if test

    n1 = Node("n1", (), (), (), 1.0)
    n2 = Node("n2", (), (), (), 1.5)
    n3 = Node("n3", n1, n2, (), 2.0)

    n1.ancestor = n3
    n2.ancestor = n3

    println(istip(n1))
    println(istip(n2))
    println(istip(n3))

    println(to_newick(n3))
end
