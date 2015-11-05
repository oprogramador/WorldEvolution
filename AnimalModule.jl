module AnimalModule

import World.PositionModule.Position
import World.Utils

type Animal
  force::Float32
  speed::Float32
  temperature::Float32
  position::Position
end

function mutate(this)
  this.force += Utils.plus_minus_rand(0.1)
  this.speed += Utils.plus_minus_rand(0.1)
  this.temperature += Utils.plus_minus_rand(0.1)
end

function move(animal, validator)
  position = Position(round(animal.position.x + rand() * animal.speed), round(animal.position.y + rand() * animal.speed))
  if validor.validate_position(animal)
    animal.position = position
  end
end

end
