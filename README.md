Three dimensions of variation:

* Use the `@inline` macro to force inlining of scalar `getindex`
* Return type-unstable `Nullable{Union()}` from `+` when all inputs are null
* Use `BitArray` or `Array{Bool}` in definition of `NullableArray`

This leads to 8 options in our design space:

* No inlining of `getindex`, don't use `Union()` trick, use `Array{Bools}`
* No inlining of `getindex`, don't use `Union()` trick, use `BitArray`
* No inlining of `getindex`, use `Union()` trick, use `Array{Bools}`
* No inlining of `getindex`, use `Union()` trick, use `BitArray`
* Yes inlining of `getindex`, don't use `Union()` trick, use `Array{Bools}`
* Yes inlining of `getindex`, don't use `Union()` trick, use `BitArray`
* Yes inlining of `getindex`, use `Union()` trick, use `Array{Bools}`
* Yes inlining of `getindex`, use `Union()` trick, use `BitArray`

We can test them using many ways that one might try to define taking a vector
sum of an array. This gives us the tests in `suite.jl`.
