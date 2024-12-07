defmodule Aoc.Days.Six do
  @input_file "inputs/day6.txt"

  defmodule Position do
    defstruct x: 0, y: 0

    @spec new({integer, integer}) :: %Position{}
    def new({x, y}) when is_integer(x) and is_integer(y) do
      %Position{x: x, y: y}
    end
  end

  defmodule MapDimensions do
    defstruct width: 0, height: 0
  end

  defmodule Obstacles do
    defstruct obstacles: MapSet.new()
  end

  defmodule ObservedPositions do
    defstruct observed_positions: MapSet.new()

    @spec add(%ObservedPositions{} | %{observed_positions: MapSet.t()}, integer(), integer()) ::
            %ObservedPositions{}
    def add(%ObservedPositions{observed_positions: positions}, x, y) do
      %ObservedPositions{
        observed_positions: MapSet.put(positions, {x, y})
      }
    end

    @spec size(%ObservedPositions{}) :: integer()
    def size(%ObservedPositions{observed_positions: observed_positions}) do
      MapSet.size(observed_positions)
    end
  end

  defmodule Direction do
    @type t :: :up | :right | :down | :left

    @spec turn_clockwise(t()) :: t()
    def turn_clockwise(:up), do: :right
    def turn_clockwise(:right), do: :down
    def turn_clockwise(:down), do: :left
    def turn_clockwise(:left), do: :up
  end

  @spec part_1() :: :ok
  def part_1 do
    @input_file
    |> File.read!()
    |> part_1()
    |> IO.puts()
  end

  @spec part_1(String.t()) :: integer()
  def part_1(input) do
    {start_position, dimensions, obstacles} = parse_input(input)
    observed_positions = %ObservedPositions{observed_positions: MapSet.new()}

    observed_positions =
      move_until_outside(start_position, :up, dimensions, obstacles, observed_positions)

    ObservedPositions.size(observed_positions)
  end

  @spec move_until_outside(
          %Position{},
          Direction.t(),
          %MapDimensions{},
          %Obstacles{},
          %ObservedPositions{}
        ) :: ObservedPositions
  defp move_until_outside(position, direction, dimensions, obstacles, observed_positions) do
    cond do
      outside_map?(position, dimensions) ->
        observed_positions

      obstacle_at?(next_position(position, direction), obstacles) ->
        # Hit obstacle - turn clockwise and continue
        observed_positions = observed_positions |> ObservedPositions.add(position.x, position.y)

        move_until_outside(
          position,
          Direction.turn_clockwise(direction),
          dimensions,
          obstacles,
          observed_positions
        )

      true ->
        # Move to next position
        observed_positions = observed_positions |> ObservedPositions.add(position.x, position.y)

        move_until_outside(
          next_position(position, direction),
          direction,
          dimensions,
          obstacles,
          observed_positions
        )
    end
  end

  @spec next_position(%Position{}, Direction.t()) :: %Position{}
  defp next_position(position, direction) do
    case direction do
      :up -> %Position{position | x: position.x - 1}
      :right -> %Position{position | y: position.y + 1}
      :down -> %Position{position | x: position.x + 1}
      :left -> %Position{position | y: position.y - 1}
    end
  end

  @spec outside_map?(%Position{}, %MapDimensions{}) :: boolean()
  defp outside_map?(%Position{x: x, y: y}, %MapDimensions{width: width, height: height}) do
    x < 0 or y < 0 or x >= height or y >= width
  end

  @spec obstacle_at?(%Position{}, %Obstacles{}) :: boolean()
  defp obstacle_at?(position, %Obstacles{obstacles: obstacles}) do
    MapSet.member?(obstacles, position)
  end

  @spec parse_input(String.t()) :: {%Position{}, %MapDimensions{}, %Obstacles{}}
  defp parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    {
      parse_initial_position(lines),
      parse_dimensions(lines),
      parse_obstacles(lines)
    }
  end

  @spec parse_dimensions([String.t()]) :: %MapDimensions{}
  defp parse_dimensions(lines) do
    %MapDimensions{
      height: length(lines),
      width: lines |> List.first() |> String.graphemes() |> length()
    }
  end

  @spec parse_initial_position([String.t()]) :: %Position{}
  defp parse_initial_position(lines) do
    {x, y} =
      lines
      |> Enum.with_index()
      |> Enum.find_value(fn {line, y} ->
        line
        |> String.trim()
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.find_value(fn {char, x} ->
          if char == "^", do: {y, x}
        end)
      end)

    %Position{x: x, y: y}
  end

  @spec parse_obstacles([String.t()]) :: %Obstacles{}
  defp parse_obstacles(lines) do
    obstacles =
      lines
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, x} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.filter(fn {char, _y} -> char == "#" end)
        |> Enum.map(fn {_char, y} -> Position.new({x, y}) end)
      end)
      |> MapSet.new()

    %Obstacles{obstacles: obstacles}
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
    2
  end
end

# Position = (x,y)
# MapDimensions = (width, height)
# Obstacles = Set.t(Position)
# LinesObstacles = Set.t(integer)
# RowsObstacles = Set.t(integer)
# ObservedPositions = Set.t(Position)

# SInce I move by columns it may not be the best solution to use obstacles with 2 dimensions
# Stuck situation ?
#
