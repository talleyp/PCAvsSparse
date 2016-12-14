using Convex, SCS
solver = SCSSolver(verbose=0)
set_default_solver(solver)
using Images, DataFrames, Colors
path = "./HeadsAndTails/"
files = readdir(path)
n = 1 #size(files,1)
finalDim = (50,50)
#fileInd = rand(1:size(files,1),n)
curfile = joinpath(path,files[1])
temp = convert(Image{Gray},load(curfile))
#temp = temp[1:480,1:480]
temp = Images.imresize(temp,finalDim)
dim = size(temp)
A = zeros(prod(dim), n)
A[:,1] = vec(temp)
for i=2:n
    curfile = joinpath(path,files[i])
    temp = convert(Image{Gray},load(curfile))
    #temp = temp[1:480,1:480]
    temp = Images.imresize(temp,finalDim)
    A[:,i] = vec(temp)
end

dA = size(A)
X = Variable(dA)
#S = Variable(dA)
lam = 1#/sqrt(maximum(dA))
prob = minimize(nuclearnorm(A-X)+lam*norm(vec(X),1))
solve!(prob)