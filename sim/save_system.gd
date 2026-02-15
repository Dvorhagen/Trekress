extends RefCounted
class_name SaveSystem

const SAVE_PATH := "user://autosave_v0.save"

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_state(state: SimState) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(state.to_dict()))

func load_state() -> SimState:
	var state := SimState.new()
	if not has_save():
		return state
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return state
	var parsed := JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		state.from_dict(parsed)
	return state

func delete_save() -> void:
	if has_save():
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
