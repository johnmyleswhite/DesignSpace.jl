results <- read.csv("results.csv")

library("ggplot2")

results <- transform(results, inline = paste0("inline = ", inline))
results <- transform(results, union_bit = paste0("union = ", union, ", bit = ", bit))

ggplot(results, aes(x = algorithm, y = perf, fill = algorithm)) +
    geom_bar(stat = "identity") +
    facet_grid(inline ~ union_bit) +
    coord_flip()

ggplot(results, aes(x = algorithm, y = perf, fill = algorithm)) +
    geom_bar(stat = "identity") +
    facet_grid(inline ~ union_bit) +
    scale_y_sqrt() +
    coord_flip()
ggsave("results.png", width = 12, height = 8)
