extends RefCounted
class_name SimGame

const SimStateScript = preload("res://sim/sim_state.gd")
const TurnEngineScript = preload("res://sim/turn_engine.gd")
const OrderSystemScript = preload("res://sim/order_system.gd")
const SaveSystemScript = preload("res://sim/save_system.gd")

var state
var turn_engine
var save_system
var rng: RandomNumberGenerator

func _init() -> void:
	save_system = SaveSystemScript.new()
	turn_engine = TurnEngineScript.new(OrderSystemScript.new())
	rng = RandomNumberGenerator.new()

func start_new_game() -> void:
	state = SimStateScript.new()
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

func _load_crew_data() -> Array:
	var file := FileAccess.open("res://content/crew.json", FileAccess.READ)
	if file == null:
		return []
	var parsed := JSON.parse_string(file.get_as_text())
	if parsed is Array:
		return parsed
	return []
