load("tree.jl")

libRmath = dlopen("libRmath")

rexp(rate::Float64) = ccall(dlsym(libRmath, :rexp), Float64, (Int64, Float64), 1, 1.0/rate)
set_seed(a1::Integer, a2::Integer) = ccall(dlsym(libRmath,:set_seed),Void,(Int32,Int32), a1, a2)

function choose(n::Integer, k::Integer)
  factorial(n)/(factorial(k)*factorial(n-k))
end

function nodes_array(n::Integer)
  nodes = Array(Node, n)
  for i = 1:n
    nodes[i] = Node("$(i)", (), (), (), 0.0)
  end
  nodes
end

function increment_time!(nodes::Array{Node}, time::Float64)
  for i = 1:length(nodes)
    nodes[i].time += time
  end
end

function merge_nodes(nodes::Array{Node}, n1::Integer, n2::Integer)
  parent = Node("", nodes[n1], nodes[n2], (), 0.0)
  nodes[n1].ancestor = parent
  nodes[n2].ancestor = parent
  [ parent, nodes[1:(min(n1,n2)-1)], nodes[(min(n1,n2)+1):(max(n1,n2)-1)], nodes[(max(n1,n2)+1):end] ]
end

function rand2i(n::Integer)
  i1 = randi(n)
  i2 = i1
  while i2 == i1
    i2 = randi(n)
  end
  (i1, i2)
end

function simple_waiting_times(k::Integer)
  [ rexp(choose(i, 2)) for i in reverse(2:k) ] 
end

function exponential_waiting_times(k::Integer, beta::Float)
  simple_times = simple_waiting_times(k)
  exp_times = zeros(Float64, length(simple_times))
  for i = 1:length(simple_times)
    vkp1 = sum(exp_times[1:(i-1)])
    exp_times[i] = (1/beta)*log(1 + beta*simple_times[i]*exp(-beta*vkp1))
  end
  exp_times
end

function coalesce(wt::Array{Float64})
  nodes = nodes_array(length(wt)+1)
  for t in wt
    increment_time!(nodes, t)
    js = rand2i(length(nodes))    
    nodes = merge_nodes(nodes, js[1], js[2])
  end
  nodes[1]
end

println(coalesce(simple_waiting_times(5)))
println(coalesce(exponential_waiting_times(5, 1000.0)))

