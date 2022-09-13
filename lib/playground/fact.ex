defmodule Playground.Fact do
  def fact_naive(0), do: 1
  def fact_naive(n) when is_integer(n) and n >= 0, do: n*fact_naive(n-1)
  
  def fact_tc(n) when is_integer(n) and n >= 0, do: fact_tc(n, 1)
  def fact_tc(0, acc), do: acc
  def fact_tc(n, acc), do: fact_tc(n - 1, n * acc)

  def fact_tc_partial(n, lower) when is_integer(n) and n >= lower do
    # IO.puts("fact(#{n},#{lower})")
    fact_tc_partial(n, lower, 1)
  end
  def fact_tc_partial(n, lower, acc) when n == lower, do: acc
  def fact_tc_partial(n, lower, acc), do: fact_tc_partial(n - 1, lower, n * acc)

  def spawn_fact_dist_child(parent, i, num_per_process) do
    spawn(fn ->
      send(parent, {self(), fact_tc_partial((i+1)*num_per_process, i*num_per_process)})
    end)
  end

  def fact_dist(n, 0) when is_integer(n) and n >= 0 do
    fact_tc(n)
  end
  def fact_dist(n, num_per_process \\ 1000) when is_integer(n) and n >= 0 do
    nb_process = div(n, num_per_process)
    n_reminder = rem(n, num_per_process)
    n_processed = nb_process * num_per_process
    reminder_partial_result = fact_tc_partial(n_processed + n_reminder, n_processed)
    
    if nb_process >= 1 do
      0..nb_process-1
      |> Enum.map(&(spawn_fact_dist_child(self(), &1, num_per_process)))
      |> fact_dist_loop([reminder_partial_result])
      #|> then(fn(results) -> IO.inspect(results); results end)
      |> Enum.reduce(1, fn x,acc -> x*acc end)
    else
      fact_tc(n)
    end
  end

  def fact_dist_loop([], results) do
    results
  end

  def fact_dist_loop(childs, results) do
    receive do
      {child_pid, result} -> fact_dist_loop(List.delete(childs, child_pid), [result | results])
    end
  end
end
