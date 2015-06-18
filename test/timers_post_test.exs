defmodule TimersTestTest do
  use ExUnit.Case

  setup do
  	opts = [
  	 {{2015,6,30},{12,30,30}}
  	]
  	{:ok, pid} = TimersTest.start_link(opts)
  	{:ok, [pid: pid]}
  end

  test "the truth", %{pid: pid} do
    state = TimersTest.get_state(pid)
    Enum.each(state.timer_refs, fn(ref) -> 
      assert :erlang.read_timer(ref) > 0
    end)
  end
end
