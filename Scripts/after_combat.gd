extends Node

func _ready():
	$fade_transition/AnimationPlayer.play("fade_out")
	$Player.global_position = GameManager.player_position

func _on_change_castle_scene_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/inside_castle.tscn")
