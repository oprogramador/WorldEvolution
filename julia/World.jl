module World
  include("./Config.jl")
  include("./Utils.jl")
  include("./PositionModule.jl")
  include("./FieldModule.jl")
  include("./AnimalModule.jl")
  include("./BoardModule.jl")

  args_width = convert(Int, float(ARGS[1]))
  args_height = convert(Int, float(ARGS[2]))
  args_n = convert(Int, float(ARGS[3]))
  args_max_speed = float(ARGS[4])
  args_iteration_count = convert(Int, float(ARGS[5]))

  this = BoardModule.init(args_width, args_height, args_n, args_max_speed)
  BoardModule.simulate(this, args_iteration_count)
end
