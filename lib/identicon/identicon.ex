defmodule Identicon do
  require Integer

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_cells
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def pick_color(image) do
    %Identicon.Image{hex: [red, green, blue | _tail]} = image

    %Identicon.Image{image | color: {red, green, blue}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = hex
    |> Enum.chunk_every(3, 3, :discard)
    |> mirror_rows
    |> List.flatten
    |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def filter_odd_cells(%Identicon.Image{grid: grid} = image) do
    filtered = Enum.reject(grid, &removeCell?/1)

    %Identicon.Image{image | grid: filtered}
  end

  def mirror_rows(rows) do
    Enum.map(rows, &mirror_row/1)
  end

  def mirror_row(row) do
    [_head | tail] = Enum.reverse(row)
    Enum.concat(row, tail)
  end

  def removeCell?({value, _index}) do
    Integer.is_odd(value)
  end
end
