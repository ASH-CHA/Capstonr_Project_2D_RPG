extends Node2D

@export var enemy_type: String = "Malakron"  # which enemy to fight

@onready var player = $Player
@onready var malakron_dialogue = $Malakron_Dialogue  # the Control node with your dialogue script

func _ready():
	$fade_transition/AnimationPlayer.play("fade_out")
	player.global_position = Vector2(0, 0)
	malakron_dialogue.dialogue_finished.connect(_on_dialogue_finished)

func _on_transition_body_entered(body: Node2D) -> void:
	player.global_position = Vector2(-2, -370)  # Meeting Malakron


func _on_activate_dialogue_body_entered(body: Node2D) -> void:
	malakron_dialogue.start() # Show Dialogue
	
func _on_dialogue_finished():
	GameManager.last_enemy_type = enemy_type
	get_tree().change_scene_to_file("res://Scenes/combat_malakron.tscn")
