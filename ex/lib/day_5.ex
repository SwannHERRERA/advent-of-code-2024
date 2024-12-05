defmodule Aoc.Days.Five do
  @input_file "inputs/day5.txt"

  defmodule Graph do
      defstruct ascending: %{}, descending: %{} # ascending: nodes that come after, descending: reverse order
    end

  @spec part_1() :: :ok
  def part_1()  do 
    @input_file
    |> File.read!()
    |> part_1()
    |> IO.puts()
  end

  @spec part_1(String.t()) :: integer()
  def part_1(input) do
    [rules_str, updates] =  String.split(input, "\n\n", trim: true)

    rules = compute_rules(rules_str)
    # IO.inspect(rules, label: "rules")

    compute_updates(updates, rules)
  end

  @spec compute_rules(String.t()) :: %Graph{}
  def compute_rules(rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.map(fn rule -> 
      [a, b] = String.split(rule, "|", trim: true)
      {String.to_integer(a), String.to_integer(b)}
    end)
    |> Enum.reduce(%Graph{}, fn {a, b}, graph ->
      insert_rule(graph, a, b)
    end)
  end

  @spec insert_rule(%Graph{}, integer(), integer()) :: %Graph{}
  defp insert_rule(%Graph{ascending: ascending, descending: descending} = _graph, a, b) do
    cond do
      # Both nodes exist in their respective dictionaries
      Map.has_key?(descending, a) and Map.has_key?(ascending, b) ->
        %Graph{
          ascending: Map.update!(ascending, b, &MapSet.put(&1, a)),
          descending: Map.update!(descending, a, &MapSet.put(&1, b))
        }

      # Only a exists in descending
      Map.has_key?(descending, a) ->
        %Graph{
          ascending: Map.put(ascending, b, MapSet.new([a])),
          descending: Map.update!(descending, a, &MapSet.put(&1, b))
        }

      # Only b exists in ascending
      Map.has_key?(ascending, b) ->
        %Graph{
          ascending: Map.update!(ascending, b, &MapSet.put(&1, a)),
          descending: Map.put(descending, a, MapSet.new([b]))
        }

      # Neither exists
      true ->
        %Graph{
          ascending: Map.put(ascending, b, MapSet.new([a])),
          descending: Map.put(descending, a, MapSet.new([b]))
        }
    end
  end

  @spec compute_updates(String.t(), %Graph{}) :: integer()
  def compute_updates(updates, rules) do
    String.split(updates, "\n", trim: true)
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.map(&Enum.map(&1, fn el -> String.to_integer(el) end))
    |> Enum.filter(&is_line_valid?(&1, rules))
    # |> IO.inspect(label: "valid lines", charlists: :as_lists)
    |> compute_result()
  end

  @spec compute_updates_part_2(String.t(), %Graph{}) :: integer()
  def compute_updates_part_2(updates, rules) do
    String.split(updates, "\n", trim: true)
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.map(&Enum.map(&1, fn el -> String.to_integer(el) end))
    |> Enum.reject(&is_line_valid?(&1, rules))
      |> Enum.map(&order_elements(&1, rules))
    # |> IO.inspect(label: "invalid lines", charlists: :as_lists)
    |> compute_result()
  end

  @spec order_elements(list(), %Graph{}) :: list()
  def order_elements(line, %Graph{ascending: ascending, descending: descending}) do
    elements = MapSet.new(line)
    
    deps = Enum.reduce(line, %{}, fn el, acc ->
      must_be_after = Map.get(ascending, el, MapSet.new())
      must_be_before = Map.get(descending, el, MapSet.new())
      
      # Only keep dependencies that are actually in our line
      filtered_after = MapSet.intersection(must_be_after, elements)
      filtered_before = MapSet.intersection(must_be_before, elements)
      
      Map.put(acc, el, %{
        after: filtered_after,
        before: filtered_before
      })
    end)
    
    sorted = sort_elements(deps, [], MapSet.new(line))
    
    if length(sorted) != length(line) do
      line  # Return original if we couldn't sort properly
    else
      sorted
    end
  end
  
  @spec sort_elements(map(), list(), MapSet.t()) :: list()
  defp sort_elements(deps, sorted, remaining) do
    # Find elements that have all their "after" dependencies satisfied
    available = Enum.filter(MapSet.to_list(remaining), fn el ->
      deps_map = Map.get(deps, el)
      # Element can be next if all elements it should be after are already in sorted
      MapSet.subset?(deps_map.after, MapSet.new(sorted))
    end)
    
    case available do
      [] ->
        if MapSet.size(remaining) > 0 do
          sorted ++ MapSet.to_list(remaining)  # Add remaining elements if we can't resolve further
        else
          sorted
        end
        
      [next | _] ->
        # Remove the selected element from remaining and add to sorted
        new_remaining = MapSet.delete(remaining, next)
        sort_elements(deps, sorted ++ [next], new_remaining)
    end
  end

  @spec is_line_valid?(list(), %Graph{}) :: boolean()
  def is_line_valid?(line, %Graph{ascending: ascending, descending: descending} = _rules) do
    line
    |> Enum.with_index()
    |> Enum.reduce_while(true, fn {el, idx}, _acc ->
      # Get all elements before and after current element
      previous_elements = Enum.take(line, idx)
      next_elements = Enum.drop(line, idx + 1)
      
      # Check if current element has any rules
      should_be_before = Map.get(descending, el, MapSet.new())
      should_be_after = Map.get(ascending, el, MapSet.new())
      
      cond do
        # Check if any required "before" elements are actually after
        Enum.any?(should_be_before, &Enum.member?(previous_elements, &1)) ->
          {:halt, false}
          
        # Check if any required "after" elements are actually before
        Enum.any?(should_be_after, &Enum.member?(next_elements, &1)) ->
          {:halt, false}
          
        true ->
          {:cont, true}
      end
    end)
  end

  @spec part_2([String]) :: integer()
  def compute_result(lines) do
    lines
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.sum()
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
    [rules_str, updates] =  String.split(input, "\n\n", trim: true)

    rules = compute_rules(rules_str)
    # IO.inspect(rules, label: "rules")

    compute_updates_part_2(updates, rules)
  end
end
