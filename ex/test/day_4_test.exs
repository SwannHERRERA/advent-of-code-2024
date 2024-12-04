defmodule Day4Test do
  use ExUnit.Case
  import Aoc.Days.Four

  test "test sample part 1" do
    input = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"""
    assert part_1(input) == 18
    
    input = """
....XXMAS.
.SAMXMS...
...S..A...
..A.A.MS.X
XMASAMX.MM
X.....XA.A
S.S.S.S.SS
.A.A.A.A.A
..M.M.M.MM
.X.X.XMASX
"""
    assert part_1(input) == 18
  end

  test "test sample part 1 with only one line" do
    input = """
XMASAMXAMM
"""
    assert part_1(input) == 2
  end

  test "test sample part 1 for vertical" do
    input = """
X
M
A
S
"""
    assert part_1(input) == 1
  end

  test "test sample part 1 for diagonal" do
    input = """
Xxxx
xMxx
xxAx
xxxS
"""
    assert part_1(input) == 1

    input = """
xxxSXxxxxxxS
xxAxAMxxxxAx
xMxxxMAxxMxx
XxxxxxXSXxxx
"""
    assert part_1(input) == 4
  end

  test "part 2 sample" do
    input = """
.M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
..........
"""

  assert part_2(input) == 9
  end
end

