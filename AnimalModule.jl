module AnimalModule

import World.PositionModule.Position
import World.PositionModule
import World.Utils
import World

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

function move(this, validator)
  position = Position(this.position.x + Utils.plus_minus_rand_int(this.speed), this.position.y + Utils.plus_minus_rand_int(this.speed))
  should_go = validator.validate_position(position)
  if should_go
    this.position = position
  end
end

function toDict(this::Animal)
  Dict(
    "force" => this.force,
    "speed" => this.speed,
    "temperature" => this.temperature,
    "position" => World.PositionModule.toDict(this.position)
  )
end

end
