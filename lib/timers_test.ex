defmodule TimersTest do
  use GenServer

  defmodule State do
  	defstruct timer_refs: []
  end

  def start_link(opts) do
  	GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
  	timer_refs = for datetime <- opts do
  	  trigger_timer(datetime)
  	end
  	{:ok, %State{timer_refs: []}}
  end

  def get_state(pid) do
  	GenServer.call(pid, :get_state)
  end

  def handle_call(:get_state, _reply, state=%State{}) do
  	{:reply, state, state}
  end

  def handle_info(:timer, state=%State{}) do
    timer_refs = Enum.filter(state.timer_refs, fn(ref) ->
      :erlang.read_timer(ref)
    end)

    {:noreply, %State{state | timer_refs: timer_refs}}
  end

  defp trigger_timer(date) do
    now = :calendar.local_time
    case time_difference(now, date) do
      x when x > 0 ->
        :erlang.send_after(x, self, :timer)
      _ ->
        nil
    end
  end

  defp time_difference(time1, time2) do
    (:calendar.datetime_to_gregorian_seconds(time2) -
      :calendar.datetime_to_gregorian_seconds(time1)) * 1000
  end
end