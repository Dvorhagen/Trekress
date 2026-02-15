extends RefCounted
class_name TurnEngine

var _order_system: OrderSystem

func _init(order_system: OrderSystem) -> void:
	_order_system = order_system

func apply_action(state: SimState, action: Dictionary) -> Dictionary:
	var events: Array[String] = []
	var advanced_tick := false
	match String(action.get("type", "")):
		"move":
			var delta: Vector2i = action.get("delta", Vector2i.ZERO)
			if _try_move(state, delta):
				events.append("Captain moved to (%d, %d)." % [state.player_pos.x, state.player_pos.y])
				advanced_tick = true
			else:
				events.append("Movement blocked.")
		"order":
			var order_id := String(action.get("order_id", ""))
			events.append_array(_order_system.apply_order(state, order_id))
			advanced_tick = true
		"end_turn":
			events.append("Captain ends turn.")
			advanced_tick = true
		_:
			events.append("No action.")

	if advanced_tick:
		state.tick += 1
		events.append("Tick advanced to %d." % state.tick)

	return {
		"events": events,
		"advanced_tick": advanced_tick
	}

func _try_move(state: SimState, delta: Vector2i) -> bool:
	var target := state.player_pos + delta
	if target.y < 0 or target.y >= state.ship_grid.size():
		return false
	var row := String(state.ship_grid[target.y])
	if target.x < 0 or target.x >= row.length():
		return false
	if row.substr(target.x, 1) == "#":
		return false
	state.player_pos = target
	return true
