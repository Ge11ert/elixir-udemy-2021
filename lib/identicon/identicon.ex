defmodule Identicon do
  require Integer

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_cells
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
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

  def build_pixel_map(%Identicon.Image{grid: grid, cell_size: cell_size, grid_size: grid_size} = image) do
    pixel_map = Enum.map grid, fn({ _code, index}) ->
      horizontal = rem(index, grid_size) * cell_size
      vertical = div(index, grid_size) * cell_size

      top_left = { horizontal, vertical }
      bottom_right = { horizontal + cell_size, vertical + cell_size }

      { top_left, bottom_right }
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map, cell_size: cell_size, grid_size: grid_size}) do
    side_size = grid_size * cell_size
    image = :egd.create(side_size, side_size)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
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
