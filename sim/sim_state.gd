extends RefCounted
class_name SimState

var tick: int = 0
var rng_seed: int = 424242
var ship_grid: PackedStringArray = PackedStringArray([
	"#########",
	"#BBBCCEE#",
	"#BBBCCEE#",
	"#BBBCCEE#",
	"#########"
])
var player_pos: Vector2i = Vector2i(2, 2)
var crew: Array[Dictionary] = []
var systems: Dictionary = {
	"shields": false,
	"power": {
		"engines": 3,
		"shields": 1,
		"weapons": 2
	}
}

func to_dict() -> Dictionary:
	return {
		"tick": tick,
		"rng_seed": rng_seed,
		"ship_grid": ship_grid,
		"player_pos": {"x": player_pos.x, "y": player_pos.y},
		"crew": crew,
		"systems": systems
	}

func from_dict(data: Dictionary) -> void:
	tick = int(data.get("tick", 0))
	rng_seed = int(data.get("rng_seed", 424242))
	ship_grid = PackedStringArray(data.get("ship_grid", ship_grid))
	var pos: Dictionary = data.get("player_pos", {"x": 2, "y": 2})
	player_pos = Vector2i(int(pos.get("x", 2)), int(pos.get("y", 2)))
	crew = data.get("crew", [])
	systems = data.get("systems", systems)
