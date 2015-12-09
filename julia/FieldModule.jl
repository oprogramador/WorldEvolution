module FieldModule

import World.Utils

type Field
  temperature::Float32
  food::Float32
end

function create()
  Field(256 * rand(), 256 * rand())
end

function mutate(this::Field)
  this.temperature += Utils.plus_minus_rand(0.1)
  this.food += this.temperature / 256 / 256
end

function toDict(this::Field)
  Dict(
    "temperature" => this.temperature,
    "food" => this.food
  )
end

end
