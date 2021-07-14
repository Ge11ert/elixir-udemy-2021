defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "creates a card desk" do
    assert Cards.create_desk() == ["Ace", "Two", "Three"]
  end

  test "checks if deck contains a card" do
    assert Cards.contains?(Cards.create_desk(), "Two") == true
    assert Cards.contains?(Cards.create_desk(), "King") == false
  end
end
