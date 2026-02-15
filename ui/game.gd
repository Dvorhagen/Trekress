extends Control

@onready var ship_view: ShipView = $MarginContainer/HBoxContainer/ShipView
@onready var tick_label: Label = $MarginContainer/HBoxContainer/RightPanel/TickLabel
@onready var shields_label: Label = $MarginContainer/HBoxContainer/RightPanel/ShieldsLabel
@onready var roster_label: RichTextLabel = $MarginContainer/HBoxContainer/RightPanel/RosterLabel
@onready var log_label: RichTextLabel = $MarginContainer/HBoxContainer/RightPanel/LogLabel

var sim_game: SimGame

func _ready() -> void:
	_setup_input_map()
	sim_game = SimGame.new()
	if SimBootstrap.load_continue:
		sim_game.continue_or_new()
	else:
		sim_game.start_new_game()
	SimBootstrap.load_continue = false
	_refresh_all([])

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_up"):
		_apply_action({"type": "move", "delta": Vector2i.UP})
	elif event.is_action_pressed("move_down"):
		_apply_action({"type": "move", "delta": Vector2i.DOWN})
	elif event.is_action_pressed("move_left"):
		_apply_action({"type": "move", "delta": Vector2i.LEFT})
	elif event.is_action_pressed("move_right"):
		_apply_action({"type": "move", "delta": Vector2i.RIGHT})
	elif event.is_action_pressed("end_turn"):
		_apply_action({"type": "end_turn"})

func _on_raise_shields_pressed() -> void:
	_apply_action({"type": "order", "order_id": "raise_shields"})

func _on_end_turn_button_pressed() -> void:
	_apply_action({"type": "end_turn"})

func _apply_action(action: Dictionary) -> void:
	var result := sim_game.apply_action(action)
	_refresh_all(result.get("events", []))

func _refresh_all(new_events: Array) -> void:
	var state := sim_game.state
	ship_view.set_state(state.ship_grid, state.player_pos)
	tick_label.text = "Tick: %d" % state.tick
	shields_label.text = "Shields: %s" % ("Raised" if state.systems.get("shields", false) else "Lowered")

	roster_label.clear()
	for crew_member in state.crew:
		roster_label.append_text("%s — %s (Skill %d)\n" % [crew_member.get("name", "?"), crew_member.get("role", "?"), int(crew_member.get("skill", 0))])

	for event_text in new_events:
		log_label.append_text("%s\n" % event_text)

func _setup_input_map() -> void:
	var actions := {
		"move_up": [Key.KEY_W, Key.KEY_UP],
		"move_down": [Key.KEY_S, Key.KEY_DOWN],
		"move_left": [Key.KEY_A, Key.KEY_LEFT],
		"move_right": [Key.KEY_D, Key.KEY_RIGHT],
		"end_turn": [Key.KEY_E],
		"interact": [Key.KEY_SPACE]
	}
	for action_name in actions.keys():
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
		for keycode in actions[action_name]:
			var key_event := InputEventKey.new()
			key_event.physical_keycode = keycode
			if not InputMap.action_has_event(action_name, key_event):
				InputMap.action_add_event(action_name, key_event)

	if not InputMap.action_has_event("move_up", _joy_motion_event(1, -1.0)):
		InputMap.action_add_event("move_up", _joy_motion_event(1, -1.0))
	if not InputMap.action_has_event("move_down", _joy_motion_event(1, 1.0)):
		InputMap.action_add_event("move_down", _joy_motion_event(1, 1.0))
	if not InputMap.action_has_event("move_left", _joy_motion_event(0, -1.0)):
		InputMap.action_add_event("move_left", _joy_motion_event(0, -1.0))
	if not InputMap.action_has_event("move_right", _joy_motion_event(0, 1.0)):
		InputMap.action_add_event("move_right", _joy_motion_event(0, 1.0))
	if not InputMap.action_has_event("end_turn", _joy_button_event(0)):
		InputMap.action_add_event("end_turn", _joy_button_event(0))

func _joy_motion_event(axis: int, value: float) -> InputEventJoypadMotion:
	var event := InputEventJoypadMotion.new()
	event.axis = axis
	event.axis_value = value
	return event

func _joy_button_event(button: int) -> InputEventJoypadButton:
	var event := InputEventJoypadButton.new()
	event.button_index = button
	return event
