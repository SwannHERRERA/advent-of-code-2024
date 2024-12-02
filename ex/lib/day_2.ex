defmodule Aoc.Days.Two do
  @input_file "inputs/day2.txt"
  @min_difference 1
  @max_difference 3

  @spec part_1() :: :ok
  def part_1 do
    @input_file
    |> File.read!()
    |> part_1()
    |> IO.puts()
  end

  @spec part_1(String.t()) :: integer()
  def part_1(input) do
    input
    |> parse_input()
    |> Enum.count(&safe?/1)
  end

  @spec part_2() :: :ok
  def part_2 do
    @input_file
    |> File.read!()
    |> part_2()
    |> IO.puts()
  end

  @spec part_2(String.t()) :: integer()
  def part_2(input) do
    input
    |> parse_input()
    |> Enum.count(&safe_with_dampener?/1)
  end

  @spec parse_input(String.t()) :: [[integer()]]
  defp parse_input(input) do
    for line <- String.split(input, "\n", trim: true),
      do: String.split(line) |> Enum.map(&String.to_integer/1)
  end

  @spec safe?([integer()]) :: boolean()
  defp safe?(report) do
    [first, second | _] = report
    comparison = if first < second, do: &</2, else: &>/2

    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> 
      comparison.(a, b) and abs(a - b) in @min_difference..@max_difference
    end)
  end

  @spec safe_with_dampener?([integer()]) :: boolean()
  defp safe_with_dampener?(report) do
    report
    |> Enum.with_index()
    |> Enum.any?(fn {_, skip_index} -> 
      report
      |> Stream.with_index()
      |> Stream.reject(fn {_, index} -> index == skip_index end)
      |> Enum.map(&elem(&1, 0))
      |> safe?()
    end)
  end
end
