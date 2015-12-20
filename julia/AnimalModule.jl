module AnimalModule

import World.PositionModule.Position
import World.PositionModule
import World.Utils
import World.Config
import World

type Animal
  id::Int32
  genotype::Array{Int8}
  health::Float32
  force::Float32
  speed::Float32
  temperature::Float32
  reproduction_rate::Float32
  position::Position
end

function rand_int()
  convert(Int, floor(typemax(Int32)*rand()))
end

function create_phenotype(this::Animal)
  this.force = 0
  this.speed = 0
  this.temperature = Config.max_temperature * 0.5
  this.reproduction_rate = 0
  for (i, gene) in enumerate(this.genotype)
    this.force += (i % 3) * gene
    this.force -= (i % 5) * gene
    this.speed += (i % 7) * gene
    this.speed -= (i % 11) * gene
    this.temperature += (i % 13) * gene
    this.temperature -= (i % 17) * gene
    this.reproduction_rate += (i % 19) * gene
    this.reproduction_rate -= (i % 23) * gene
  end
  if this.speed < Config.animal_min_speed
    this.speed = Config.animal_min_speed
  end
  if this.speed > Config.animal_max_speed
    this.speed = Config.animal_max_speed
  end
  if this.reproduction_rate < Config.animal_min_reproduction_rate
    this.reproduction_rate = Config.animal_min_reproduction_rate
  end
  if this.force < Config.animal_min_force
    this.force = Config.animal_min_force
  end
end

function join(a::Animal, b::Animal)
  genotype = Array{Int8}(Config.genotype_length)
  for i in 1:Config.genotype_length
    if rand() < Config.gene_mixing_probability
      genotype[i] = floor(0.5 * (a.genotype[i] + b.genotype[i]))
    elseif rand() < 0.5
      genotype[i] = a.genotype[i]
    else
      genotype[i] = b.genotype[i]
    end
  end
  c = Animal(rand_int(), genotype, a.health + b.health, 0, 0, 0, 0, a.position)
  create_phenotype(c)
  c
end

function reproduct(this::Animal)
  a = Animal(rand_int(), this.genotype, this.health, this.force, this.speed, this.temperature, this.reproduction_rate, this.position)
  b = Animal(rand_int(), this.genotype, this.health, this.force, this.speed, this.temperature, this.reproduction_rate, this.position)
  [a, b]
end

function create(width, height)
  genotype = zeros(Int8, Config.genotype_length)
  position = Position(ceil(rand()*width), ceil(rand()*height))
  a = Animal(rand_int(), genotype, Config.max_health, 0, 0, 0, 0, position)
  create_phenotype(a)
  a
end

function mutate(this::Animal)
  i = convert(Int8, 1)
  di = convert(Int8, 1)
  while typeof(i) === Int8 && i >= 1 && i <= Config.genotype_length
    this.genotype[i] += Utils.plus_minus_rand_int(Config.animal_gene_max_mutation)
    i += di
  end 
  create_phenotype(this)
end

function consume_energy(this::Animal)
  this.health -= Config.energy_consumption
end

function move(this::Animal, validator)
  consume_energy(this)
  dx = Utils.plus_minus_rand_int(this.speed)
  dy = Utils.plus_minus_rand_int(this.speed)
  position = Position(this.position.x + dx, this.position.y + dy)
  should_go = World.BoardModule.validate_position(validator, position)
  if should_go
    this.position = position
  end
end

function to_dict(this::Animal)
  Dict(
    "id" => this.id,
    "genotype" => this.genotype,
    "health" => this.health,
    "force" => this.force,
    "speed" => this.speed,
    "temperature" => this.temperature,
    "reproduction_rate" => this.reproduction_rate,
    "position" => World.PositionModule.to_dict(this.position)
  )
end

end
