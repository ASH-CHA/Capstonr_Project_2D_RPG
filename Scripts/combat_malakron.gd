extends Node2D

var enemy_hp = 115  # Malakron's HP
var player_turn = true
var defending = false
var malakron_turn_counter = 0  # tracks his move cycle

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
	enemy_animated_sprite.play("combat_idle")
	player_animated_sprite.play("Player_combat_idle")

	attack_button.pressed.connect(_on_attack_pressed)
	defend_button.pressed.connect(_on_defend_pressed)
	run_button.pressed.connect(_on_run_pressed)

	update_ui()


# --- PLAYER ATTACK ---
func _on_attack_pressed():
	if player_turn:
		player_animated_sprite.play("attack_right")
		enemy_animated_sprite.play("hit_right")

		var damage = randi_range(15, 25)
		enemy_hp -= damage
		combat_log.text = "You strike Malakron for " + str(damage) + " damage!"

		if enemy_hp <= 0:
			_victory()
		else:
			player_turn = false
			get_tree().create_timer(1.0).timeout.connect(_enemy_attack)

	update_ui()


# --- PLAYER DEFEND ---
func _on_defend_pressed():
	if player_turn:
		defending = true
		player_animated_sprite.play("defend_right")
		combat_log.text = "You brace yourself for Malakron’s attack!"

		player_turn = false
		get_tree().create_timer(1.0).timeout.connect(_enemy_attack)


# --- RUN (disabled for boss) ---
func _on_run_pressed():
	combat_log.text = "There is no escape from Malakron!"
	update_ui()


# --- ENEMY ATTACK ---
func _enemy_attack():
	malakron_turn_counter += 1
	var damage = 0

	if malakron_turn_counter % 3 == 0:
		# Telegraph the strong attack
		combat_log.text = "Malakron raises his blade… a devastating strike is coming!"
		enemy_animated_sprite.play("charge") # <- use a special animation if you have one

		# Delay the actual strike slightly for drama
		get_tree().create_timer(1.0).timeout.connect(func():
			enemy_animated_sprite.play("attack_left")
			player_animated_sprite.play("hit_left")

			damage = randi_range(30, 35)
			if defending:
				damage = int(damage / 4)
				combat_log.text = "Malakron unleashes his strike! You defend and take only " + str(damage) + "!"
			else:
				combat_log.text = "Malakron unleashes his strike for " + str(damage) + "!"

			_apply_player_damage(damage)
		)
	else:
		# Normal attack
		enemy_animated_sprite.play("attack_left")
		player_animated_sprite.play("hit_left")

		damage = randi_range(10, 20)
		if defending:
			damage = int(damage / 2)
			combat_log.text = "Malakron slashes at you! You defend and take only " + str(damage) + "!"
		else:
			combat_log.text = "Malakron slashes you for " + str(damage) + "!"

		_apply_player_damage(damage)


# --- APPLY DAMAGE ---
func _apply_player_damage(damage: int):
	GameManager.player_hp -= damage
	defending = false  # reset defend state

	if GameManager.player_hp <= 0:
		_defeat()
	else:
		player_turn = true

	update_ui()


# --- VICTORY / DEFEAT ---
func _victory():
	combat_log.text = "Victory! You have defeated Malakron!"
	attack_button.disabled = true
	defend_button.disabled = true
	run_button.disabled = true
	enemy_animated_sprite.play("death")

	get_tree().create_timer(3.0).timeout.connect(_return_to_world)

func _defeat():
	combat_log.text = "You have fallen before Malakron..."
	attack_button.disabled = true
	defend_button.disabled = true
	run_button.disabled = true
	get_tree().create_timer(2.0).timeout.connect(_game_over)


# --- YOU WIN / GAME OVER ---
func _return_to_world():
	get_tree().change_scene_to_file("res://Scenes/win.tscn")

func _game_over():
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")


# --- UI UPDATE ---
func update_ui():
	player_health_label.text = "Player HP: " + str(GameManager.player_hp) + " / " + str(GameManager.player_max_hp)
	enemy_health_label.text = "Malakron HP: " + str(enemy_hp)
