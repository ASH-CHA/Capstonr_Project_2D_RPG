extends Control

func _ready():
	$fade_transition/AnimationPlayer.play("fade_out")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
