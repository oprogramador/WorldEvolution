module PositionModule

type Position
  x::Int32
  y::Int32
end

function toDict(this::Position)
  Dict("x" => this.x, "y" => this.y)
end

end
