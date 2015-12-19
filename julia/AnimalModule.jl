module AnimalModule

import World.PositionModule.Position
import World.PositionModule
import World.Utils
import World

type Animal
  id::Int32
  health::Float32
  force::Float32
  speed::Float32
  temperature::Float32
  position::Position
end

function rand_int()
  convert(Int, floor(typemax(Int32)*rand()))
end

function join(a::Animal, b::Animal)
  Animal(rand_int(), a.health + b.health, a.force + b.force, 0.5 * (a.speed + b.speed), 0.5 * (a.temperature + b.temperature), a.position)
end

function create(width, height, max_speed)
  Animal(rand_int(), 256, rand(), rand() * max_speed, 256 * rand(), Position(ceil(rand()*width), ceil(rand()*height)))
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
  should_go = World.BoardModule.validate_position(validator, position)
  if should_go
    this.position = position
  end
end

function to_dict(this::Animal)
  Dict(
    "id" => this.id,
    "health" => this.health,
    "force" => this.force,
    "speed" => this.speed,
    "temperature" => this.temperature,
    "position" => World.PositionModule.to_dict(this.position)
  )
end

end
