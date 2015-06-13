immutable NullableArray{T, N} <: AbstractArray{Nullable{T}, N}
    values::Array{T, N}
    isnull::BitArray{N}
end

Base.size(X::NullableArray) = size(X.values) # -> NTuple{Int}

@inline function Base.getindex{T, N}(X::NullableArray{T, N}, I::Int...)
    if X.isnull[I...]
        Nullable{T}()
    else
        Nullable{T}(X.values[I...])
    end
end

function Base.(:+){S1, S2}(x::Nullable{S1}, y::Nullable{S2})
    return Nullable(Base.(:+)(x.value, y.value), x.isnull | y.isnull)
end

include("suite.jl")

srand(1)
n = 10_000_000
x = NullableArray(randn(n), falses(n))

test_sums(x, "v6", "yes", "no", "yes")
