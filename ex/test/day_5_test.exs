defmodule Day5Test do
  use ExUnit.Case
  import Aoc.Days.Five
  alias Aoc.Days.Five.Graph

  test "test part 1 final sum" do
    updates = """
  75,47,61,53,29
  97,61,53,29,13
  75,29,13
  """
    assert compute_updates(updates, %Graph{}) == 143
  end

  test "test part 1 sample" do
    input = """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"""
    assert part_1(input) == 143
  end

  test "valid tree" do
    input = """
47|53
97|13
97|61
"""
    candidate = compute_rules(input)
    expected_result = %Graph{
      ascending: %{
        53 => MapSet.new([47]),
        13 => MapSet.new([97]),
        61 => MapSet.new([97]),
      },
      descending: %{
        47 => MapSet.new([53]),
        97 => MapSet.new([13, 61])
      }
    }
    assert candidate == expected_result
  end
  
  test "part 2 samble" do
    input = """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"""
    assert part_2(input) == 123
  end
  test "ordering" do 

    line = [97,13,75,29,47]

    rules_str = """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13
"""
    rules = compute_rules(rules_str)
    candidate = order_elements(line, rules)
    assert candidate == [97,75,47,29,13]
  end
end
