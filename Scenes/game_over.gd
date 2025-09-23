extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()


func _on_exit_pressed() -> void:
	get_tree().quit()
