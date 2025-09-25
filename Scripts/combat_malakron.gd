extends Node2D

var enemy_hp = GameManager.enemy_stats[GameManager.last_enemy_type]
var player_turn = true
var defending = false

@onready var player_health_label = $PlayerHealth
@onready var enemy_health_label = $EnemyHealth
@onready var attack_button = $AttackButton
@onready var defend_button = $DefendButton
@onready var run_button = $RunButton
@onready var combat_log = $CombatLog

@onready var enemy_animated_sprite = $Enemy/AnimatedSprite2D
@onready var player_animated_sprite = $PlayerCombat/AnimatedSprite2D

func _ready():
	enemy_animated_sprite.play("combat_idle")
	player_animated_sprite.play("Player_combat_idle")
	
	# Connect buttons
	attack_button.pressed.connect(_on_attack_pressed)
	defend_button.pressed.connect(_on_defend_pressed)

	# Malakron is the final boss – disable run
	run_button.disabled = true
	run_button.text = "Cannot Escape"

	# Load saved HP or set fresh if first time
	if GameManager.enemy_current_hp.has(GameManager.last_enemy_id):
		enemy_hp = GameManager.enemy_current_hp[GameManager.last_enemy_id]
	else:
		enemy_hp = 500  # Malakron base HP
		GameManager.enemy_current_hp[GameManager.last_enemy_id] = enemy_hp
	
	update_ui()

# ATTACK
func _on_attack_pressed():
	if player_turn:
		player_animated_sprite.play("attack_right")
		enemy_animated_sprite.play("hit_right")
		var damage = randi_range(20, 35)
		enemy_hp -= damage
		GameManager.enemy_current_hp[GameManager.last_enemy_id] = enemy_hp
		combat_log.text = "You strike Malakron for " + str(damage) + " damage!"
		
		if enemy_hp <= 0:
			combat_log.text = "You have vanquished Malakron!"
			attack_button.disabled = true
			defend_button.disabled = true
			enemy_animated_sprite.play("death")
			
			GameManager.defeated_enemies[GameManager.last_enemy_id] = true
			GameManager.enemy_current_hp.erase(GameManager.last_enemy_id)
			
			# Trigger ending cutscene
			get_tree().create_timer(2.0).timeout.connect(_victory_ending)
		else:
			player_turn = false
			get_tree().create_timer(1.0).timeout.connect(_enemy_attack)
	
	update_ui()

# DEFEND
func _on_defend_pressed():
	if player_turn:
		defending = true
		player_animated_sprite.play("defend_right")
		combat_log.text = "You brace yourself against Malakron’s power!"
		player_turn = false
		get_tree().create_timer(1.0).timeout.connect(_enemy_attack)

# ENEMY ATTACK
func _enemy_attack():
	enemy_animated_sprite.play("attack_left")
	player_animated_sprite.play("hit_left")
	
	var roll = randi_range(1, 100)
	var damage = 0
	
	if roll <= 20:
		# 20% chance special Dark Blast
		damage = randi_range(40, 60)
		combat_log.text = "Malakron unleashes a DARK BLAST for " + str(damage) + " damage!"
	elif roll <= 30:
		# 10% chance heal
		var heal = 20
		enemy_hp += heal
		GameManager.enemy_current_hp[GameManager.last_enemy_id] = enemy_hp
		combat_log.text = "Malakron absorbs dark energy and heals " + str(heal) + " HP!"
	else:
		# Normal attack
		damage = randi_range(25, 40)
		if defending:
			damage = int(damage / 2)
			defending = false
			combat_log.text = "Malakron attacks, but you deflect some damage! (" + str(damage) + ")"
		else:
			combat_log.text = "Malakron strikes for " + str(damage) + " damage!"
	
	if damage > 0:
		GameManager.player_hp -= damage
	
	if GameManager.player_hp <= 0:
		combat_log.text = "Malakron has defeated you..."
		attack_button.disabled = true
		defend_button.disabled = true
		get_tree().create_timer(1.5).timeout.connect(_game_over)
	else:
		player_turn = true
	
	update_ui()

# RETURN
func _victory_ending():
	get_tree().change_scene_to_file("res://Scenes/ending.tscn")

func _game_over():
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

# UI UPDATE
func update_ui():
	player_health_label.text = "Heron HP: " + str(GameManager.player_hp) + " / " + str(GameManager.player_max_hp)
	enemy_health_label.text = "Malakron HP: " + str(enemy_hp)
