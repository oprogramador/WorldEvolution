module Utils

function plus_minus_rand(x)
  (rand() - 0.5) * x
end

function plus_minus_rand_int(x)
  convert(Int64, round(plus_minus_rand(x)))
end

end
