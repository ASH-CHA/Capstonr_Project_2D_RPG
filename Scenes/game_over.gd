extends Control

func _on_start_pressed() -> void:
	GameManager.player_position = GameManager.player_start_position
	GameManager.player_hp = GameManager.player_max_hp
	GameManager.defeated_enemies.clear()
	GameManager.enemy_current_hp.clear()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
