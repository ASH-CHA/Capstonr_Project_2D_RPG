extends CharacterBody2D

var direction: Vector2 = Vector2()
var speed: float = 65.0
var combat_triggered = false

@export var inv: Inv # add inventory

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hp_label: Label = $HPLabel
#@onready var enemy = get_parent().get_node("Spider")

func _ready():
	animated_sprite_2d.play("idle_down")
	var player = get_tree().get_root().get_node("Main/Player")
	player.global_position = GameManager.player_position
	
	hp_label.text = str(GameManager.player_hp) + " / " + str(GameManager.player_max_hp)
	update_hp_label()
	
	# Connects signal so HP label updates immediately when items are used
	inv.hp_changed.connect(update_hp_label)

func _physics_process(_delta):
	read_input()
	move_and_slide()
	
	#if position.distance_to(enemy.position) < 20 and not combat_triggered:
		#combat_triggered = true
		#print("Starting combat!")
		#get_tree().change_scene_to_file("res://Scenes/combat.tscn")

func read_input():
	velocity = Vector2()

	if Input.is_action_pressed("up"):
		velocity.y -= 1
		direction = Vector2(0, -1)
		animated_sprite_2d.play("move_up")
	elif Input.is_action_pressed("down"):
		velocity.y += 1
		direction = Vector2(0, 1)
		animated_sprite_2d.play("move_down")
	elif Input.is_action_pressed("left"):
		velocity.x -= 1
		direction = Vector2(-1, 0)
		animated_sprite_2d.play("move_left")
	elif Input.is_action_pressed("right"):
		velocity.x += 1
		direction = Vector2(1, 0)
		animated_sprite_2d.play("move_right")
	else:
		# Idle animations based on last direction faced
		if direction == Vector2(0, -1):
			animated_sprite_2d.play("idle_up")
			if Input.is_action_pressed("attack"):
				animated_sprite_2d.play("attack_up")
		elif direction == Vector2(0, 1):
			animated_sprite_2d.play("idle_down")
			if Input.is_action_pressed("attack"):
				animated_sprite_2d.play("attack_down")
		elif direction == Vector2(-1, 0):
			animated_sprite_2d.play("idle_left")
			if Input.is_action_pressed("attack"):
				animated_sprite_2d.play("attack_left")
		elif direction == Vector2(1, 0):
			animated_sprite_2d.play("idle_right")
			if Input.is_action_pressed("attack"):
				animated_sprite_2d.play("attack_right")

	# Normalize velocity to avoid faster diagonal movement
	if velocity != Vector2():
		velocity = velocity.normalized() * speed

# Needed to collect items
func player():
	pass

# Collect items
func collect(item):
	inv.insert(item)

# Update Player HP Label
func update_hp_label():
	hp_label.text = str(GameManager.player_hp) + " / " + str(GameManager.player_max_hp)
