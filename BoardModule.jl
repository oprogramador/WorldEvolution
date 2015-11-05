module BoardModule

using World
import World.FieldModule.Field
import World.AnimalModule.Animal
import World.PositionModule.Position

type Board
  fields::Array{Field}
  animals::Array{Animal}
end

function mutate()
  for animal in this.animals
    World.AnimalModule.mutate(animal)
  end
end

function validate_position(position)
  position.x >= 0 && position.y >= 0 && position.x < size(this.fields)[1] && position.y < size(this.fields)[2]
end

function move()
  for animal in this.animals
    World.AnimalModule.move(animal, BoardModule)
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
