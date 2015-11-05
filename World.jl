module World

type Position
  x::Float32
  y::Float32
end

type Animal
  force::Float32
  speed::Float32
  temperature::Float32
  position::Position
end

type Field
  temperature::Float32
end

type Board
  fields::Array{World.Field}
end

function init(width, height, n)
  fields = fill(Field(0), width, height)
  board = Board(fields)
end

board = init(100, 100, 3)
  

end
