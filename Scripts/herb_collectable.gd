extends StaticBody2D

@onready var collected_note = $CollectedNote

@export var item: InvItem
@export var item_id: String = "" # unique identifier for this item instance
var player = null

func _ready():
	# Assigne ID if not already given
	if item_id == "" or item_id == "item_000":
		item_id = str(get_path())
	
	# If already collected, remove from world
	if GameManager.collected_items.has(item_id):
		queue_free()

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		playercollect()
		GameManager.collected_items[item_id] = true # mark as collected
		
		collected_note.text = "+1 Herb Collected"
		await get_tree().create_timer(0.5).timeout
		collected_note.text = ""
		await get_tree().create_timer(0.1).timeout
		self.queue_free()

func playercollect():
	player.collect(item)
