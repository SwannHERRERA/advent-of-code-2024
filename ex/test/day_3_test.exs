defmodule Day3Test do
  use ExUnit.Case
  import Aoc.Days.Three

  test "test sample part 1" do
    input = """
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
"""
    assert part_1(input) == 161
  end
  test "part 2" do
    input = """
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
"""
    assert part_2(input) == 48
  end
end

