extends Control
class_name ShipView

var ship_grid: PackedStringArray = PackedStringArray()
var player_pos: Vector2i = Vector2i.ZERO
var tile_size: int = 32

func set_state(new_grid: PackedStringArray, new_player_pos: Vector2i) -> void:
	ship_grid = new_grid
	player_pos = new_player_pos
	queue_redraw()

func _draw() -> void:
	for y in ship_grid.size():
		var row := String(ship_grid[y])
		for x in row.length():
			var cell := row.substr(x, 1)
			var color := Color(0.1, 0.1, 0.1)
			if cell == "B":
				color = Color(0.2, 0.35, 0.55)
			elif cell == "C":
				color = Color(0.2, 0.5, 0.3)
			elif cell == "E":
				color = Color(0.55, 0.35, 0.2)
			draw_rect(Rect2(x * tile_size, y * tile_size, tile_size, tile_size), color, true)
			draw_rect(Rect2(x * tile_size, y * tile_size, tile_size, tile_size), Color.BLACK, false, 1.0)

	draw_rect(Rect2(player_pos.x * tile_size + 6, player_pos.y * tile_size + 6, tile_size - 12, tile_size - 12), Color(0.95, 0.95, 0.3), true)
