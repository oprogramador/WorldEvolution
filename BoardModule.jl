module BoardModule

import World.FieldModule.Field
import World.AnimalModule.Animal
import World.PositionModule.Position
import World.Utils

type Board
  fields::Array{Field}
  animals::Array{Animal}
end

function mutate()
  for animal in this.animals
    animal.force += Utils.plus_minus_rand(0.1)
    animal.speed += Utils.plus_minus_rand(0.1)
    animal.temperature += Utils.plus_minus_rand(0.1)
  end
end

function validate_position(position)
  position.x >= 0 && position.y >= 0 && position.x < size(this.fields)[1] && position.y < size(this.fields)[2]
end

function move()
  for animal in this.animals
    position = animal.position + rand()
  end
end

function init(width, height, n)
  fields = fill(Field(0), width, height)
  animals = Array{Animal}(n)
  for i in 1:n
    animals[i] = Animal(rand(), rand(), rand(), Position(floor(rand()*width), floor(rand()*height)))
  end
  Board(fields, animals)
end

this = init(100, 100, 3)

end
