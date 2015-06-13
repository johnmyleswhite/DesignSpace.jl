immutable NullableArray{T, N} <: AbstractArray{Nullable{T}, N}
    values::Array{T, N}
    isnull::BitArray{N}

    function NullableArray(d::AbstractArray{T, N}, m::BitArray{N})
        if size(d) != size(m)
            msg = "values and missingness arrays must be the same size"
            throw(ArgumentError(msg))
        end
        new(d, m)
    end
end

function NullableArray{T, N}(A::AbstractArray{T, N}, m::BitArray{N}) # -> NullableArray
    return NullableArray{T, N}(A, m)
end

Base.size(X::NullableArray) = size(X.values) # -> NTuple{Int}

import Base: LinearFast

Base.linearindexing{T <: NullableArray}(::Type{T}) = LinearFast()

# Extract a scalar element from a `NullableArray`.
function Base.getindex{T, N}(X::NullableArray{T, N}, I::Int...)
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

test_sums(x, "v2", "no", "no", "yes")
