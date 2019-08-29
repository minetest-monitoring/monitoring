local metric = monitoring.counter("add_particlespawner_calls", "number of add_particlespawner calls")

minetest.add_particlespawner = metric.wrap(minetest.add_particlespawner)
