defmodule Identicon.Image do
  defstruct hex: nil,
            color: nil,
            grid: nil,
            pixel_map: nil,
            cell_size: 50,
            grid_size: 5
end
