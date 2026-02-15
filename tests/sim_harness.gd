extends SceneTree

func _init() -> void:
	var sim := SimGame.new()
	sim.start_new_game()
	var first := sim.apply_action({"type": "move", "delta": Vector2i.RIGHT})
	assert(sim.state.tick == 1)
	assert(first["events"][0].begins_with("Captain moved"))
	var second := sim.apply_action({"type": "order", "order_id": "raise_shields"})
	assert(sim.state.systems["shields"] == true)
	assert(sim.state.tick == 2)
	assert(second["events"].has("Tactical: Aye, Captain."))
	print("sim_harness: PASS")
	quit(0)
