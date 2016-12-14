using Images, DataFrames, Colors
using Convex, SCS
set_default_solver(SCSSolver());

img = load("./HeadsAndTails/Screenshot\ from\ 2016-12-10\ 13-39-32.png")
temp = convert(Image{Gray},img)
img2 = Images.imresize(temp, (150, 150))

path = "./HeadsAndTails/"
files = readdir(path)
n = 3 #size(files,1)
finalDim = (20,20)
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
L = Variable(dA)
S = Variable(dA)
lam = 1#/sqrt(maximum(dA))
prob = minimize(nuclearnorm(L-A)+1/100norm(vec(S),1),L+S==A)
solve!(prob)
