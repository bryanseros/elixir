defmodule App.ApplicationTest do
  use ExUnit.Case
  doctest App.Application

  test "test childrens" do
    assert App.Application.env_children(:test) == []
  end
end
