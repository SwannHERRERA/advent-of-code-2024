defmodule Aoc.Days.One do
  @spec part_1() :: :ok
  def part_1 do
    file = File.read!("inputs/day1.txt")
    candidate = part_1(file)
    IO.puts(candidate)
  end

  @spec part_2() :: :ok
  def part_2 do
    file = File.read!("inputs/day1.txt")
    candidate = part_2(file)
    IO.puts(candidate)
  end

  def part_1(input) do
    break_text_into_pairs(input)
    |> sort_columns()
    |> compute_distances()
    |> Enum.sum()
  end

  def part_2(input) do
    {first_column, second_column} = break_text_into_pairs(input) |> Enum.unzip()
    frequencies = Enum.frequencies(second_column)

    first_column
    |> Stream.map(fn x -> x * Map.get(frequencies, x, 0) end)
    |> Enum.sum()
  end

  @spec break_text_into_pairs(String.t()) :: [{integer, integer}]
  def break_text_into_pairs(input) do
    String.split(input, "\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  @spec sort_columns([{integer, integer}]) :: [{integer, integer}]
  def sort_columns(pairs) do
    {col1, col2} = Enum.unzip(pairs)
    sorted_col1 = Enum.sort(col1)
    sorted_col2 = Enum.sort(col2)
    Enum.zip(sorted_col1, sorted_col2)
  end

  @spec compute_distances([{integer, integer}]) :: [integer]
  def compute_distances(pairs) do
    Enum.map(pairs, fn {a, b} -> abs(a - b) end)
  end
end
