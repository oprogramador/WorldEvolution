module BoardModule

import JSON

using World
import World.FieldModule.Field
import World.AnimalModule.Animal
import World.PositionModule.Position
import World.Config

type Board
  fields::Array{Field}
  animals::Array{Animal}
end

function to_dict(this::Board)
  Dict(
    "fields" => map((x)->World.FieldModule.to_dict(x), this.fields),
    "animals" => map((x)->World.AnimalModule.to_dict(x), this.animals),
  )
end

function serialize(this::Board)
  JSON.json(to_dict(this))
end

function eat(this::Board)
  for animal in this.animals
    food = this.fields[animal.position.x, animal.position.y].food
    this.fields[animal.position.x, animal.position.y].food = 0
    animal.health += food
  end
end

function kill_malnutred(this::Board)
  for (i, animal) in enumerate(this.animals)
    if animal.health <= 0
      deleteat!(this.animals, i)
    end
  end
end

function mutate_fields(this::Board)
  width = size(this.fields)[1]
  height = size(this.fields)[2]
  for x in 1:width
    for y in 1:height
      World.FieldModule.mutate(this.fields[x, y])
    end
  end
end

function mix_temperature(this::Board)
  width = size(this.fields)[1]
  height = size(this.fields)[2]
  for x in 1:width
    for y in 1:height
      if x > 1 && rand() > Config.mix_temperature_probability
        World.FieldModule.mix_temperature(this.fields[x, y], this.fields[x - 1, y])
      end
      if y > 1 && rand() > Config.mix_temperature_probability
        World.FieldModule.mix_temperature(this.fields[x, y], this.fields[x, y - 1])
      end
    end
  end
end

function damage_from_heat(this::Board)
  for animal in this.animals
    field = this.fields[animal.position.x, animal.position.y]
    animal.health -= (field.temperature - animal.temperature)^2 * Config.damage_from_heat_coefficient
  end
end

function mutate(this::Board)
  for animal in this.animals
    World.AnimalModule.mutate(animal)
  end
end

function validate_position(this::Board, position::Position)
  position.x >= 1 && position.y >= 1 && position.x <= size(this.fields)[1] && position.y <= size(this.fields)[2]
end

function move(this::Board)
  for animal in this.animals
    World.AnimalModule.move(animal, this)
  end
end

function join(this::Board)
  to_delete = []
  for (i, animal) in enumerate(this.animals)
    for (k, other) in enumerate(this.animals)
      if(!(i in to_delete) && !(k in to_delete) && animal.position.x == other.position.x && animal.position.y == other.position.y && animal.id != other.id && rand() > Config.join_probability)
          push!(to_delete, i)
          push!(to_delete, k)
          deleteat!(this.animals, k < i ? k : k - 1)
          new = World.AnimalModule.join(animal, other)
          push!(this.animals, new)
      end
    end
  end
  deleteat!(this.animals, sort(unique(to_delete)))
end

function step(this::Board)
  join(this)
  eat(this)
  kill_malnutred(this)
  damage_from_heat(this)
  move(this)
  mutate(this)
  mix_temperature(this)
  mutate_fields(this)
end

function create_dir()
  base_dir = "public/evolution_output"
  dir = base_dir*"/"*Dates.format(now(), "yyyy-mm-dd_HH-MM-SS")*"_"*randstring()
  if !isdir(base_dir)
    mkdir(base_dir)
  end
  if !isdir(dir)
    mkdir(dir)
  end
  dir
end

function write_to_file(this::Board, dir, i)
  f = open("$dir/$i.json", "w")
  write(f, serialize(this))
  close(f)
end

function simulate(this::Board, n)
  dir = create_dir()
  write_to_file(this, dir, 0)
  for i in 1:n
    step(this)
    write_to_file(this, dir, i)
  end
end

function init(width, height, n, max_speed)
  fields = Array{Field}(width, height)
  for x in 1:width
    for y in 1:height
      fields[x, y] = World.FieldModule.create()
    end
  end
  animals = Array{Animal}(n)
  for i in 1:n
    animals[i] = World.AnimalModule.create(width, height, max_speed)
  end
  Board(fields, animals)
end

end
