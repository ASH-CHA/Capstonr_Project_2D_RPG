extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var enemy_id : String
@export var enemy_type : String

var direction = Vector2()

func _ready():
	direction = Vector2(0, 1)  # Default facing down at start
	animated_sprite_2d.play("idle")
	
	if enemy_id == "" or enemy_id == "enemy_000":
		enemy_id = GameManager.get_next_enemy_id()
	
	if GameManager.defeated_enemies.has(enemy_id):
		queue_free() # Enemy already dead, remove it from the map

func _on_body_entered(body):
	if body.name == "Player":
		GameManager.player_position = body.global_position
		GameManager.enemy_position = body.global_position
		GameManager.last_enemy_id = enemy_id
		GameManager.last_enemy_type = enemy_type
		
		# Initialize HP if not already tracked
		if !GameManager.enemy_current_hp.has(enemy_id):
			GameManager.enemy_current_hp[enemy_id] = GameManager.enemy_stats[enemy_type]
		
		print("Starting combat!")
		if enemy_type == "Bat":
			get_tree().change_scene_to_file("res://Scenes/combat_bat.tscn")
		elif enemy_type == "Slime":
			get_tree().change_scene_to_file("res://Scenes/combat_slime.tscn")
		elif enemy_type == "Spider":
			get_tree().change_scene_to_file("res://Scenes/combat_spider.tscn")
		elif enemy_type == "RedMage":
			get_tree().change_scene_to_file("res://Scenes/combat_redmage.tscn")
		elif enemy_type == "RedOrc":
			get_tree().change_scene_to_file("res://Scenes/combat_redorc.tscn")
		elif enemy_type == "RedPeonOrc":
			get_tree().change_scene_to_file("res://Scenes/combat_redpeonorc.tscn")
		elif enemy_type == "BlueMage":
			get_tree().change_scene_to_file("res://Scenes/combat_bluemage.tscn")
		elif enemy_type == "BluePeonOrc":
			get_tree().change_scene_to_file("res://Scenes/combat_bluepeonorc.tscn")
		elif enemy_type == "OrcGrunt":
			get_tree().change_scene_to_file("res://Scenes/combat_orcgrunt.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/combat_malakron.tscn")
