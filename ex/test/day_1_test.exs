defmodule Day1Test do
  use ExUnit.Case
  import Aoc.Days.One

  test "break_text_into_pairs with valid input" do
    input = "123   456\n789   101\n"
    expected_output = [{123, 456}, {789, 101}]
    assert break_text_into_pairs(input) == expected_output
  end

  test "break_text_into_pairs trims spaces" do
    input = "  123   456   \n  789   101   \n"
    expected_output = [{123, 456}, {789, 101}]
    assert break_text_into_pairs(input) == expected_output
  end

  test "break_text_into_pairs with empty input" do
    input = ""
    expected_output = []
    assert break_text_into_pairs(input) == expected_output
  end

  test "sort_columns with sorted pairs" do
    input = [{1, 2}, {3, 4}]
    expected_output = [{1, 2}, {3, 4}]
    assert sort_columns(input) == expected_output
  end

  test "sort_columns with unsorted pairs" do
    input = [{4, 1}, {3, 2}, {2, 3}, {1, 4}]
    expected_output = [{1, 1}, {2, 2}, {3, 3}, {4, 4}]
    assert sort_columns(input) == expected_output
  end

  test "computes differences between max and min values" do
    assert compute_distances([{5, 2}, {8, 3}]) == [3, 5]
  end

  test "handles equal values" do
    assert compute_distances([{4, 4}, {2, 2}]) == [0, 0]
  end

  @doc "not in the input but ..."
  test "handles negative numbers" do
    assert compute_distances([{-1, -5}, {2, -3}]) == [4, 5]
  end

  test "handles empty list" do
    assert compute_distances([]) == []
  end

  test "test day 1 part 1 with example input" do
    input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert part_1(input) == 11
  end

  test "test day 1 part 2 with example input" do
    input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert part_2(input) == 31
  end

  test "test part 2 unziping" do
    input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    {a, b} = break_text_into_pairs(input) |> Enum.unzip()
    assert a == [3, 4, 2, 1, 3, 3]
    assert b == [4, 3, 5, 3, 9, 3]
  end
end
