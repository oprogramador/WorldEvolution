module PositionModule

type Position
  x::Int32
  y::Int32
end

function to_dict(this::Position)
  Dict("x" => this.x, "y" => this.y)
end

end
