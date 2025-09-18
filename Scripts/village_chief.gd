extends CharacterBody2D

const speed = 30
var current_state = IDLE
var is_chatting = false

var player
var player_in_chat_zone = false

enum{
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	pass

func _process(_delta):
	if current_state == 0 or current_state == 1:
		$AnimatedSprite2D.play("idle_right")
	
	# Press the 'c' key to activate
	if Input.is_action_just_pressed("chat"):
		print("chatting with npc")
		$village_chief_dialogue.start()
		is_chatting = true
		$AnimatedSprite2D.play("idle")

func choose(array):
	array.shuffle()
	return array.front()

func move(_delta):
	if !is_chatting:
		$AnimatedSprite2D.play("idle_right")

func _on_chat_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true

func _on_chat_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_chat_zone = false


func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])


func _on_dialogue_dialogue_finished() -> void:
	is_chatting = false
