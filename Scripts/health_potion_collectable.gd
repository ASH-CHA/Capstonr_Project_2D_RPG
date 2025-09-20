extends StaticBody2D

@onready var collected_note = $CollectedNote

@export var item: InvItem
var player = null

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		playercollect()
		collected_note.text = "+1 Health Potion"
		await get_tree().create_timer(0.5).timeout
		collected_note.text = ""
		await get_tree().create_timer(0.1).timeout
		self.queue_free()

func playercollect():
	player.collect(item)
