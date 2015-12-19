module FieldModule

import World.Utils
import World.Config

type Field
  temperature::Float32
  food::Float32
end

function create()
  Field(Config.max_temperature * rand(), Config.max_temperature * rand())
end

function mix_temperature(a::Field, b::Field)
  delta = a.temperature - b.temperature
  a.temperature -= delta * Config.mix_temperature_coefficient
  b.temperature += delta * Config.mix_temperature_coefficient
end

function mutate(this::Field)
  if rand() < Config.volcano_eruption_probability
    this.temperature += Utils.plus_minus_rand(Config.max_temperature * Config.volcano_eruption_grade)
  end
  this.temperature += Utils.plus_minus_rand(Config.field_temperature_max_mutation)
  this.food += Config.food_growth
end

function to_dict(this::Field)
  Dict(
    "temperature" => this.temperature,
    "food" => this.food
  )
end

end
