defmodule Aoc.Days.Three do
  @input_file "inputs/day3.txt"

  @spec part_1() :: :ok
  def part_1()  do 
    @input_file
    |> File.read!()
    |> part_1()
    |> IO.puts()
  end

  @spec part_1(String.t()) :: integer()
  def part_1(input) do
    pattern = ~r/mul\((\d+),(\d+)\)/

    Regex.scan(pattern, input)
    |> Enum.map(fn [_full_match, num1, num2] ->
      {String.to_integer(num1), String.to_integer(num2)}
    end)
      |> Enum.reduce(0, fn {num1, num2}, acc -> acc + num1 * num2 end)
  end

  @spec part_2() :: :ok
  def part_2() do
    @input_file
    |> File.read!()
    |> part_2()
    |> IO.puts()
  end

  @spec part_2(String.t()) :: integer()
  def part_2(input) do
    {_enabled, results} = Enum.reduce(get_instructions(input), {true, []}, &process_instruction/2)
    Enum.reduce(results, 0, fn {num1, num2}, acc -> acc + num1 * num2 end)
  end

  defp get_instructions(input) do
    Regex.scan(~r/(?:do\(\)|don't\(\)|mul\(\d+,\d+\))/, input)
    |> List.flatten()
  end

  defp process_instruction(instruction, {enabled, results}) do
    case instruction do
      "do()" -> {true, results}
      "don't()" -> {false, results}
      "mul(" <> _ when enabled ->
        case Regex.run(~r/mul\((\d+),(\d+)\)/, instruction) do
          [_, num1, num2] -> {enabled, [{String.to_integer(num1), String.to_integer(num2)} | results]}
          nil -> {enabled, results}
        end
      _ -> {enabled, results}
    end
  end
end
