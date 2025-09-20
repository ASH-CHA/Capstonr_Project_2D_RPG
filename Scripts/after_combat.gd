extends Node

func _ready():
	$fade_transition/AnimationPlayer.play("fade_out")
	$Player.global_position = GameManager.player_position
