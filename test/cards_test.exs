defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "creates a card desk" do
    assert Cards.create_desk() == ["Ace", "Two", "Three"]
  end
end
