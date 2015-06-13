immutable NullableArray{T, N} <: AbstractArray{Nullable{T}, N}
    values::Array{T, N}
    isnull::Array{Bool, N}
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
    if x.isnull | y.isnull
        return Nullable{Union()}()
    else
        return Nullable(Base.(:+)(x.value, y.value))
    end
end

include("suite.jl")

srand(1)
n = 10_000_000
x = NullableArray(randn(n), fill(false, n))

test_sums(x, "v7", "yes", "yes", "no")
