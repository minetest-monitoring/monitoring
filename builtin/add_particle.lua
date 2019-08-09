local metric = monitoring.counter("add_particle_calls", "number of add_particle calls")

minetest.add_particle = metric.wrap(minetest.add_particle)
