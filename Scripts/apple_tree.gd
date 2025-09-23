extends Node2D

@onready var collected_note = $CollectedNote

var state = "apples" # no apples, apples are the only possible states
var player_in_area = false

var apple = preload("res://Scenes/apple_collectable.tscn")

@export var item: InvItem
@export var tree_id: String = "" # unique per tree
var regrow_duration = 60.0 # 1 minute in seconds
var player = null

func _ready() -> void:
	# Auto-assign ID if none provided
	if tree_id == "" or tree_id == "tree_000":
		tree_id = str(get_path()) # path-based unique ID
		
	# Check GameManager if this tree is regrowing
	if GameManager.apple_trees.has(tree_id):
		var remaining = GameManager.apple_trees[tree_id] - Time.get_unix_time_from_system()
		
		if remaining > 0:
			state = "no apples"
			$growth_timer.start(remaining)
		else:
			state = "apples"
	else:
		# Default state is apples
		state = "apples"

func _process(_delta):
	if state == "no apples":
		$AnimatedSprite2D.play("no apples")
	if state == "apples":
		$AnimatedSprite2D.play("apples")
		if player_in_area:
			if Input.is_action_just_pressed("e"):
				state = "no apples"
				drop_apple()

func _on_pickable_area_body_entered(body: Node2D) -> void:
	if body.has_method("_ready"):
		player_in_area = true
		player = body

func _on_pickable_area_body_exited(body: Node2D) -> void:
	if body.has_method("_ready"):
		player_in_area = false

func _on_growth_timer_timeout() -> void:
	state = "apples"
	if GameManager.apple_trees.has(tree_id):
		GameManager.apple_trees.erase(tree_id)  # apples grown, clear entry

func drop_apple():
	var apple_instance = apple.instantiate()
	apple_instance.global_position = $Marker2D.global_position
	get_parent().add_child(apple_instance)
	player.collect(item)
	
	collected_note.text = "+1 Apple Collected"
	await get_tree().create_timer(1.5).timeout
	collected_note.text = ""
	
	# Store global respawn timestamp
	GameManager.apple_trees[tree_id] = Time.get_unix_time_from_system() + regrow_duration
	await get_tree().create_timer(3).timeout
	state = "no apples"
	$growth_timer.start(regrow_duration)
	
	
func collection_label():
	collected_note.text = "+1 Apple"
