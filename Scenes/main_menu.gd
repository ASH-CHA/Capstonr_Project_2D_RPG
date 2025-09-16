extends Control

var button_type = null

func _on_start_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/main.tscn")
	button_type = "Start Game"
	$fade_transition.show()
	$fade_transition/fade_timer.start()
	$fade_transition/AnimationPlayer.play("fade_in")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_fade_timer_timeout() -> void:
	if button_type == "Start Game":
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
