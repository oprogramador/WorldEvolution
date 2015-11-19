module AnimalModule

import World.PositionModule.Position
import World.PositionModule
import World.Utils
import World

type Animal
  health::Float32
  force::Float32
  speed::Float32
  temperature::Float32
  position::Position
end

function create(width, height, max_speed)
  Animal(256, rand(), rand() * max_speed, rand(), Position(ceil(rand()*width), ceil(rand()*height)))
end

function mutate(this::Animal)
  this.force += Utils.plus_minus_rand(0.1)
  this.speed += Utils.plus_minus_rand(0.1)
  this.temperature += Utils.plus_minus_rand(0.1)
end

function consume_energy(this::Animal)
  this.health -= 1
end

function move(this::Animal, validator)
  consume_energy(this)
  position = Position(this.position.x + Utils.plus_minus_rand_int(this.speed), this.position.y + Utils.plus_minus_rand_int(this.speed))
  should_go = validator.validate_position(position)
  if should_go
    this.position = position
  end
end

function toDict(this::Animal)
  Dict(
    "health" => this.health,
    "force" => this.force,
    "speed" => this.speed,
    "temperature" => this.temperature,
    "position" => World.PositionModule.toDict(this.position)
  )
end

end
