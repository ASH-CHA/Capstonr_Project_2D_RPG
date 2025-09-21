extends Resource

class_name Inv

signal update # updates inventory UI
signal hp_changed # when an item affects HP

@export var slots: Array[InvSlot]

# Insert item to inventory
func insert(item: InvItem):
	# Organizes / stacks items in inventory
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()

# Use item from a slot
func use(slot_index: int):
	if slot_index < 0 or slot_index >= slots.size():
		return
	var slot = slots[slot_index]
	if slot.item == null:
		return
	
	# Apply effect
	if slot.item.hp_restore > 0:
		GameManager.player_hp = min(GameManager.player_max_hp, GameManager.player_hp + slot.item.hp_restore)
		hp_changed.emit() # emit signal whenever HP changes
	
	# Decrease stack
	slot.amount -= 1
	if slot.amount <= 0:
		slot.item = null
	update.emit()
