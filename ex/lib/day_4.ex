defmodule Aoc.Days.Four do
  @input_file "inputs/day4.txt"
  @window_size 4
  @xmas ["X", "M", "A", "S"]
  @samx ["S", "A", "M", "X"]

  @spec part_1() :: :ok
  def part_1()  do 
    @input_file
    |> File.read!()
    |> part_1()
    |> IO.puts()
  end

  @spec part_1(String.t()) :: integer()
  def part_1(input) do
    grid = input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)

    # IO.inspect(grid, label: "grid")

    cout_horizontal = count_horizontal(grid)
    cout_vertical = count_vertical(grid)
    cout_diagonal = count_diagonal(grid)
    # IO.inspect(cout_horizontal, label: "horizontal")
    # IO.inspect(cout_vertical, label: "vertical")
    # IO.inspect(cout_diagonal, label: "diagonal")
    
    cout_horizontal + cout_vertical + cout_diagonal
  end

  defp count_horizontal(grid) do
    grid
    |> Enum.map(&get_windows/1)
    |> Enum.map(fn windows -> 
      Enum.count(windows, &(&1 == @xmas || &1 == @samx))
    end)
    |> Enum.sum()
  end

  defp count_vertical(grid) do
    width = length(Enum.at(grid, 0))
    height = length(grid)

    cond do
      height < @window_size -> 0
      width == 0 -> 0
      true ->
        for col <- 0..(width-1),
            row <- 0..(height-@window_size) do
          [
            get_cell(grid, row, col),
            get_cell(grid, row + 1, col),
            get_cell(grid, row + 2, col),
            get_cell(grid, row + 3, col)
          ]
        end
        |> Enum.count(&(&1 == @xmas || &1 == @samx))
    end
  end

  defp count_diagonal(grid) do
    width = length(Enum.at(grid, 0))
    height = length(grid)

    cond do
      height < @window_size -> 0
      width < @window_size -> 0
      true ->
        # Top-left to bottom-right diagonals
        down_right = for col <- 0..(width-@window_size),
            row <- 0..(height-@window_size) do
          [
            get_cell(grid, row, col),
            get_cell(grid, row + 1, col + 1),
            get_cell(grid, row + 2, col + 2),
            get_cell(grid, row + 3, col + 3)
          ]
        end

        # Top-right to bottom-left diagonals
        down_left = for col <- (@window_size-1)..(width-1),
            row <- 0..(height-@window_size) do
          [
            get_cell(grid, row, col),
            get_cell(grid, row + 1, col - 1),
            get_cell(grid, row + 2, col - 2),
            get_cell(grid, row + 3, col - 3)
          ]
        end

        (down_right ++ down_left)
        |> Enum.count(&(&1 == @xmas || &1 == @samx))
    end
  end

  defp get_windows(line) do
    line
    |> do_get_windows([])
  end

  defp do_get_windows([a, b, c, d | tail], acc) do
    do_get_windows([b, c, d | tail], [[a, b, c, d] | acc])
  end
  defp do_get_windows(_, acc), do: Enum.reverse(acc)

  @spec part_2() :: :ok
  def part_2() do
    @input_file
    |> File.read!()
    |> part_2()
    |> IO.puts()
  end

  @spec part_2(String.t()) :: integer()
  def part_2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> count_special_a_patterns()
  end

  defp count_special_a_patterns(grid) do
    height = length(grid)
    width = length(Enum.at(grid, 0))
  
    for i <- 0..(height-1),
        j <- 0..(width-1),
        get_cell(grid, i, j) == "A" do
      # Check both diagonal patterns:
      # M-A-S pattern: M(i-1,j-1) A(i,j) S(i+1,j+1)
      # S-A-M pattern: S(i-1,j-1) A(i,j) M(i+1,j+1)
      top_left_to_bottom_right = 
        valid_position?(i-1, j-1, height, width) && 
        valid_position?(i+1, j+1, height, width) && 
        (
          (get_cell(grid, i-1, j-1) == "M" && get_cell(grid, i+1, j+1) == "S") ||
          (get_cell(grid, i-1, j-1) == "S" && get_cell(grid, i+1, j+1) == "M")
        )
  
      # Check other diagonal:
      # M-A-S pattern: M(i-1,j+1) A(i,j) S(i+1,j-1)
      # S-A-M pattern: S(i-1,j+1) A(i,j) M(i+1,j-1)
      top_right_to_bottom_left = 
        valid_position?(i-1, j+1, height, width) && 
        valid_position?(i+1, j-1, height, width) && 
        (
          (get_cell(grid, i-1, j+1) == "M" && get_cell(grid, i+1, j-1) == "S") ||
          (get_cell(grid, i-1, j+1) == "S" && get_cell(grid, i+1, j-1) == "M")
        )
  
      top_left_to_bottom_right && top_right_to_bottom_left
    end
    |> Enum.count(&(&1))
  end
  
  defp valid_position?(i, j, height, width) do
    i >= 0 && i < height && j >= 0 && j < width
  end

  defp get_cell(grid, i, j) do
    Enum.at(Enum.at(grid, i), j)
  end
end
