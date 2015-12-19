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
  this.temperature = 0
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
end

function create(width, height, max_speed)
  genotype = zeros(Int8, Config.genotype_length)
  position = Position(ceil(rand()*width), ceil(rand()*height))
  a = Animal(rand_int(), genotype, Config.max_health, 0, 0, 0, 0, position)
  create_phenotype(a)
  a
end

function mutate(this::Animal)
  for i in 1:Config.genotype_length
    this.genotype += Utils.plus_minus_rand_int(Config.animal_gene_max_mutation)
  end 
  create_phenotype(this)
end

function consume_energy(this::Animal)
  this.health -= Config.energy_consumption
end

function move(this::Animal, validator)
  consume_energy(this)
  position = Position(this.position.x + Utils.plus_minus_rand_int(this.speed), this.position.y + Utils.plus_minus_rand_int(this.speed))
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
