extends Node2D

var player_hp = 100
var enemy_hp = null
var player_turn = true

@onready var player_health_label = $PlayerHealth
@onready var enemy_health_label = $EnemyHealth
@onready var attack_button = $AttackButton
@onready var combat_log = $CombatLog

@onready var enemy_animated_sprite = $Enemy/AnimatedSprite2D
@onready var player_animated_sprite = $PlayerCombat/AnimatedSprite2D

func _ready():
	enemy_animated_sprite.play("idle")
	player_animated_sprite.play("idle")
	attack_button.pressed.connect(_on_attack_pressed)
	enemy_hp = GameManager.enemy_stats[GameManager.last_enemy_type]
	update_ui()

func _on_attack_pressed():
	if player_turn:
		player_animated_sprite.play("attack_right")
		enemy_animated_sprite.play("hit_right")
		var damage = randi_range(15, 25)
		enemy_hp -= damage
		combat_log.text = "You deal " + str(damage) + " damage!"
		
		
		
		if enemy_hp <= 0:
			combat_log.text = "Victory! Enemy defeated!"
			attack_button.disabled = true
			enemy_animated_sprite.play("death")
			
			# Mark enemy defeated
			GameManager.defeated_enemies[GameManager.last_enemy_id] = true
			print(GameManager.defeated_enemies)
			
			
			# Return to world after short delay
			get_tree().create_timer(1.5).timeout.connect(_return_to_world)
		else:
			player_turn = false
			await get_tree().create_timer(1.0).timeout.connect(_enemy_attack)
	
	update_ui()

	
func _return_to_world():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _enemy_attack():
	enemy_animated_sprite.play("idle")
	enemy_animated_sprite.play("attack_left")
	player_animated_sprite.play("hit_left")
	var damage = randi_range(10, 20)
	player_hp -= damage
	combat_log.text = "Enemy deals " + str(damage) + " damage!"
	
	if player_hp <= 0:
		combat_log.text = "Defeat! You have fallen!"
		attack_button.disabled = true
		get_tree().create_timer(1.5).timeout.connect(_game_over)
	else:
		player_turn = true
	
	update_ui()

func _game_over():
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")


func update_ui():
	player_health_label.text = "Player HP: " + str(player_hp)
	enemy_health_label.text = "Enemy HP: " + str(enemy_hp)
