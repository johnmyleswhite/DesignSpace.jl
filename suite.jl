function split_sum(x)
    if any(x.isnull)
        return Nullable{Float64}()
    else
        return Nullable{Float64}(sum(x.values))
    end
end

function split_sum_2(x)
    return Nullable{Float64}(
        sum(x.values),
        any(x.isnull)
    )
end

function loop_sum(x)
    res = Nullable{Float64}(0.0)
    for i in 1:length(x)
        res += x[i]
    end
    return res
end

function unwrap_sum(x)
    res = 0.0
    for i in 1:length(x)
        if isnull(x[i])
            return Nullable{Float64}()
        else
            res += get(x[i])
        end
    end
    return Nullable{Float64}(res)
end

function branchfree_sum(x)
    val, null = 0.0, false
    for i in 1:length(x)
        val += x[i].value
        null |= x[i].isnull
    end
    return Nullable{Float64}(val, null)
end

function split_loop_sum(x)
    res = 0.0
    for i in 1:length(x)
        res += x.values[i]
    end
    if any(x.isnull)
        return Nullable{Float64}()
    else
        return Nullable{Float64}(res)
    end
end

function simd_sum(x)
    res = 0.0
    for i in 1:length(x)
        res += x.values[i] * x.isnull[i]
    end
    return Nullable{Float64}(res)
end

function test_sums(x, version, inline, union, bit)
    @time sum(x)
    @time split_sum(x)
    @time split_sum_2(x)
    @time loop_sum(x)
    @time unwrap_sum(x)
    @time branchfree_sum(x)
    @time split_loop_sum(x)
    @time simd_sum(x)
    @time sum(x.values)
    println()

    baseline = @elapsed sum(x.values)

    @printf("%s,%s,%s,%s,sum,%f\n", version, inline, union, bit, (@elapsed sum(x)) / baseline)
    @printf("%s,%s,%s,%s,split_sum,%f\n", version, inline, union, bit, (@elapsed split_sum(x)) / baseline)
    @printf("%s,%s,%s,%s,split_sum_2,%f\n", version, inline, union, bit, (@elapsed split_sum_2(x)) / baseline)
    @printf("%s,%s,%s,%s,loop_sum,%f\n", version, inline, union, bit, (@elapsed loop_sum(x)) / baseline)
    @printf("%s,%s,%s,%s,unwrap_sum,%f\n", version, inline, union, bit, (@elapsed unwrap_sum(x)) / baseline)
    @printf("%s,%s,%s,%s,branchfree_sum,%f\n", version, inline, union, bit, (@elapsed branchfree_sum(x)) / baseline)
    @printf("%s,%s,%s,%s,split_loop_sum,%f\n", version, inline, union, bit, (@elapsed split_loop_sum(x)) / baseline)
    @printf("%s,%s,%s,%s,simd_sum,%f\n", version, inline, union, bit, (@elapsed simd_sum(x)) / baseline)
    println()
end
