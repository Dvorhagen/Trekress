extends RefCounted
class_name SimGame

var state: SimState
var turn_engine: TurnEngine
var save_system: SaveSystem
var rng: RandomNumberGenerator

func _init() -> void:
	save_system = SaveSystem.new()
	turn_engine = TurnEngine.new(OrderSystem.new())
	rng = RandomNumberGenerator.new()

func start_new_game() -> void:
	state = SimState.new()
	state.crew = _load_crew_data()
	rng.seed = state.rng_seed
	save_system.save_state(state)

func continue_or_new() -> void:
	if save_system.has_save():
		state = save_system.load_state()
	else:
		start_new_game()
	rng.seed = state.rng_seed

func apply_action(action: Dictionary) -> Dictionary:
	var result := turn_engine.apply_action(state, action)
	if result.get("advanced_tick", false):
		save_system.save_state(state)
	return result

func has_continue_save() -> bool:
	return save_system.has_save()

func _load_crew_data() -> Array[Dictionary]:
	var file := FileAccess.open("res://content/crew.json", FileAccess.READ)
	if file == null:
		return []
	var parsed := JSON.parse_string(file.get_as_text())
	if parsed is Array:
		return parsed
	return []
