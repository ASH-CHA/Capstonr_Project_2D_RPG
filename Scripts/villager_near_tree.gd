extends CharacterBody2D

var is_chatting = false

var player
var player_in_chat_zone = false

func _ready():
	pass

func _process(_delta):
	$AnimatedSprite2D.play("idle_left")
	
	# Press the 'c' key to activate when near chat zone
	if player_in_chat_zone and Input.is_action_just_pressed("chat"):
		$AnimatedSprite2D.play("idle")
		print("chatting with npc")
		$villager_near_tree_dialogue.start()
		is_chatting = true
		#$AnimatedSprite2D.play("idle")

func choose(array):
	array.shuffle()
	return array.front()

func move(_delta):
	if !is_chatting:
		$AnimatedSprite2D.play("idle_left")

func _on_chat_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true

func _on_chat_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_chat_zone = false

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 1, 1.5])

func _on_villager_near_tree_dialogue_dialogue_finished() -> void:
	is_chatting = false
