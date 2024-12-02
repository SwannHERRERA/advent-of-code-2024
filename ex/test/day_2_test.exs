defmodule Day2Test do
  use ExUnit.Case
  import Aoc.Days.Two

  test "test sample part 1" do
    input = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"""
    expected_output = 2
    candidate = part_1(input)
    assert candidate  == expected_output
  end

  test "test sample part 2" do
    input = """
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  """
    expected_output = 4
    candidate = part_2(input)
    assert candidate  == expected_output
  end

  test "test sample part 2 tolerance case" do
    input = """
  8 6 4 4 1
  """
    expected_output = 1
    candidate = part_2(input)
    assert candidate  == expected_output
  end

  test "test sample part 2 wrong case" do
    input = """
  1 2 7 8 9
  """
    expected_output = 0
    candidate = part_2(input)
    assert candidate  == expected_output
  end

  test "test sample part 2 skip case" do
    input = """
  1 3 2 4 5
  """
    expected_output = 1
    candidate = part_2(input)
    assert candidate  == expected_output
  end
end

