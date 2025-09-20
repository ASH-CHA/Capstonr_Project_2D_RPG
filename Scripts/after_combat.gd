extends Node

func _ready():
	$Player.global_position = GameManager.player_position
