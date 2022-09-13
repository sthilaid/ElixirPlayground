defmodule Playground do
  @moduledoc """
  Documentation for `Playground`.
  """

  def benchmark_fact(x) do
    is_short_benchmark = x <= 50_000
    IO.puts("--- Factorial #{x} benchmark ---")
    if is_short_benchmark do
      with {usec, _n} = :timer.tc(&Playground.Fact.fact_naive/1, [x]), do: IO.puts("Naive Fact(#{x}): #{usec/1000.0}ms")
      with {usec, _n} = :timer.tc(&Playground.Fact.fact_tc/1, [x]), do: IO.puts("TailCall Optimized Fact(#{x}): #{usec/1000.0}ms")
    end
    cond do
      is_short_benchmark    -> [2,5,10,100,500,1000,2000,10000]
      true                  -> [100,500,1000]
    end
    |> Enum.each(fn(nb_process) -> with {usec, _n} = :timer.tc(&Playground.Fact.fact_dist/2, [x, div(x,nb_process)]) do
                                     IO.puts("Distributed x#{nb_process} Fact(#{x}): #{usec/1000.0}ms")
                                   end
    end)
  end

  def main(_args \\ []) do
    [100, 1000, 10_000, 25_000, 50_000, 100_000, 200_000]
    |> Enum.each(fn x -> benchmark_fact(x) end)
  end
end
