extends Node2D

var player_hp = 100
var enemy_hp = null
var player_turn = true
var defending = false  # track if player is defending

@onready var player_health_label = $PlayerHealth
@onready var enemy_health_label = $EnemyHealth
@onready var attack_button = $AttackButton
@onready var defend_button = $DefendButton
@onready var run_button = $RunButton
@onready var combat_log = $CombatLog

@onready var enemy_animated_sprite = $Enemy/AnimatedSprite2D
@onready var player_animated_sprite = $PlayerCombat/AnimatedSprite2D
@onready var player_run_animation = $PlayerCombat/AnimationPlayer

func _ready():
	enemy_animated_sprite.play("idle")
	player_animated_sprite.play("Player_combat_idle")
	
	# Connect buttons
	attack_button.pressed.connect(_on_attack_pressed)
	defend_button.pressed.connect(_on_defend_pressed)
	run_button.pressed.connect(_on_run_pressed)
	
	enemy_hp = GameManager.enemy_stats[GameManager.last_enemy_type]
	update_ui()

# ATTACK
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
			defend_button.disabled = true
			run_button.disabled = true
			enemy_animated_sprite.play("death")
			
			# Mark enemy defeated
			GameManager.defeated_enemies[GameManager.last_enemy_id] = true
			print(GameManager.defeated_enemies)
			
			# Return to world after short delay
			get_tree().create_timer(1.5).timeout.connect(_return_to_world)
		else:
			player_turn = false
			get_tree().create_timer(1.0).timeout.connect(_enemy_attack)
	
	update_ui()


# DEFEND
func _on_defend_pressed():
	if player_turn:
		defending = true  # player prepares to defend
		player_animated_sprite.play("defend_right") # defends
		combat_log.text = "You brace yourself for the enemy’s attack!"
		
		player_turn = false
		get_tree().create_timer(1.0).timeout.connect(_enemy_attack)

# Run
func _on_run_pressed():
	if player_turn:
		player_animated_sprite.play("run_left")
		player_run_animation.play("run_away")
		combat_log.text = "You got away safely!"
		
		# Change player's position close to enemy to avoid a combat loop
		GameManager.player_position = GameManager.enemy_position - Vector2(15,0)
		
		get_tree().create_timer(1.5).timeout.connect(_return_to_world)
	update_ui()

# ENEMY ATTACK
func _enemy_attack():
	enemy_animated_sprite.play("idle")
	enemy_animated_sprite.play("attack_left")
	player_animated_sprite.play("hit_left")
	
	var damage = randi_range(10, 20)
	if defending:
		damage = int(damage / 2)  # reduce damage if defending
		defending = false          # reset defending after effect
		combat_log.text = "Enemy attacks, but you defend! Damage reduced to " + str(damage) + "!"
	else:
		combat_log.text = "Enemy deals " + str(damage) + " damage!"
	
	player_hp -= damage
	
	if player_hp <= 0:
		combat_log.text = "Defeat! You have fallen!"
		attack_button.disabled = true
		defend_button.disabled = true
		run_button.disabled = true
		get_tree().create_timer(1.5).timeout.connect(_game_over)
	else:
		player_turn = true
	
	update_ui()


# RETURN / GAME OVER
func _return_to_world():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _game_over():
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")


# UI UPDATE
func update_ui():
	player_health_label.text = "Player HP: " + str(player_hp)
	enemy_health_label.text = "Enemy HP: " + str(enemy_hp)
