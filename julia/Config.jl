module Config

import World

max_health = 4096
max_temperature = 256
mix_temperature_coefficient = 0.25
mix_temperature_probability = 0.5
volcano_eruption_probability = 0.001
volcano_eruption_grade = 0.5
field_temperature_max_mutation = 0.1
food_growth = 0.5
damage_from_heat_coefficient = 0.08
join_probability = 0.2
animal_gene_max_mutation = 8
energy_consumption = 1
max_random_damage = 8
genotype_length = 32
gene_mixing_probability = 0.2
reproduction_coefficient = 0.5
animal_min_reproduction_rate = 1.0
animal_min_speed = 4.0
animal_max_speed = World.args_max_speed
animal_min_force = 1.0
cooling_from_eating = 8
phenotype_minus_coefficient = 0.1

end
