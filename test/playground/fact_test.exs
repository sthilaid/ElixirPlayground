defmodule FactTest do
  use ExUnit.Case
  doctest Playground.Fact
  import Playground.Fact

  test "Naive Factorial Test" do
    assert Playground.Fact.fact_naive(0) == 1
    assert Playground.Fact.fact_naive(1) == 1
    assert Playground.Fact.fact_naive(10) == 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9 * 10
    assert with x = 100, do: Playground.Fact.fact_naive(x) == 1..x |> Enum.reduce(1, &(&1*&2))
  end

  test "Tail Call Optimized Factorial Test" do
    assert Playground.Fact.fact_tc(0) == 1
    assert Playground.Fact.fact_tc(1) == 1
    assert Playground.Fact.fact_tc(10) == 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9 * 10
    assert with x = 100, do: Playground.Fact.fact_tc(x) == 1..x |> Enum.reduce(1, &(&1*&2))
  end

  test "distributed factorial tests" do
    assert Playground.Fact.fact_tc_partial(2, 2) == 1
    assert Playground.Fact.fact_tc_partial(3, 2) == 3
    assert Playground.Fact.fact_tc_partial(10, 5) == 10*9*8*7*6
    assert Playground.Fact.fact_dist(4) == fact_tc(4)
    assert Playground.Fact.fact_dist_loop([],[1,2,3]) == [1,2,3]
    assert Playground.Fact.fact_dist_loop([],[1,2,3]) == [1,2,3]
    assert Playground.Fact.fact_dist(4,2) == fact_tc(4)
    assert Playground.Fact.fact_dist(5,2) == fact_tc(5)
    assert Playground.Fact.fact_dist(100,10) == fact_tc(100)
    assert Playground.Fact.fact_dist(1000,10) == fact_tc(1000)
    assert Playground.Fact.fact_dist(1000,100) == fact_tc(1000)
    assert Playground.Fact.fact_dist(1000,500) == fact_tc(1000)
  end
end
