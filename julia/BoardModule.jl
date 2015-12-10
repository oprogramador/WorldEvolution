module BoardModule

import JSON

using World
import World.FieldModule.Field
import World.AnimalModule.Animal
import World.PositionModule.Position

type Board
  fields::Array{Field}
  animals::Array{Animal}
end

function toDict()
  Dict(
    "fields" => map((x)->World.FieldModule.toDict(x), this.fields),
    "animals" => map((x)->World.AnimalModule.toDict(x), this.animals),
  )
end

function serialize()
  JSON.json(toDict())
end

function eat()
  for animal in this.animals
    food = this.fields[animal.position.x, animal.position.y].food
    this.fields[animal.position.x, animal.position.y].food = 0
    animal.health += food
  end
end

function kill_malnutred()
  for (i, animal) in enumerate(this.animals)
    if animal.health <= 0
      deleteat!(this.animals, i)
    end
  end
end

function damage_from_heat()
  for animal in this.animals
    field = this.fields[animal.position.x, animal.position.y]
    animal.health -= (field.temperature  - animal.temperature)^2 / 256
  end
end

function mutate()
  for animal in this.animals
    World.AnimalModule.mutate(animal)
  end
end

function validate_position(position)
  position.x >= 1 && position.y >= 1 && position.x <= size(this.fields)[1] && position.y <= size(this.fields)[2]
end

function move()
  for animal in this.animals
    World.AnimalModule.move(animal, BoardModule)
  end
end

function join()
  for (i, animal) in enumerate(this.animals)
    for (k, other) in enumerate(this.animals)
      if(animal.position.x == other.position.x && animal.position.y == other.position.y && animal.id != other.id && rand() > 0.2)
          deleteat!(this.animals, i)
          deleteat!(this.animals, k < i ? k : k - 1)
          new = World.AnimalModule.join(animal, other)
          push!(this.animals, new)
      end
    end
  end
end

function step()
  join();
  eat()
  kill_malnutred()
  damage_from_heat()
  move()
  mutate()
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

function write_to_file(dir, i)
  f = open("$dir/$i.json", "w")
  write(f, serialize())
  close(f)
end

function simulate(n)
  dir = create_dir()
  write_to_file(dir, 0)
  for i in 1:n
    step()
    write_to_file(dir, i)
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

args_width = convert(Int, float(ARGS[1]))
args_height = convert(Int, float(ARGS[2]))
args_n = convert(Int, float(ARGS[3]))
args_max_speed = float(ARGS[4])
args_iteration_count = convert(Int, float(ARGS[5]))

this = init(args_width, args_height, args_n, args_max_speed)
simulate(args_iteration_count)

end
