module FieldModule

type Field
  temperature::Float32
end

function toDict(this::Field)
  Dict("temperature" => this.temperature)
end

end
