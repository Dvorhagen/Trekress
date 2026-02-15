extends Control

const SimGameScript = preload("res://sim/sim_game.gd")
const SimBootstrapScript = preload("res://sim/bootstrap.gd")

@onready var continue_button: Button = $CenterContainer/VBoxContainer/ContinueButton

func _ready() -> void:
	var sim_game = SimGameScript.new()
	continue_button.visible = sim_game.has_continue_save()

func _on_new_game_button_pressed() -> void:
	SimBootstrapScript.load_continue = false
	get_tree().change_scene_to_file("res://ui/Game.tscn")

func _on_continue_button_pressed() -> void:
	SimBootstrapScript.load_continue = true
	get_tree().change_scene_to_file("res://ui/Game.tscn")
