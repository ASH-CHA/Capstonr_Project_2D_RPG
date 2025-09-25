extends Node

var player_start_position: Vector2 = Vector2.ZERO

var enemy_stats = {
	"Bat" : 35,
	"Spider" : 50,
	"Slime" : 100,
	"RedMage" : 70,
	"RedOrc" : 80,
	"RedPeonOrc" : 60,
	"BlueMage" : 90,
	"BluePeonOrc" : 100,
	"OrcGrunt" : 120,
	"Malakron" : 200
}

var player_position : Vector2
var enemy_position : Vector2
var defeated_enemies = {}
var last_enemy_id = null
var last_enemy_type = ""
var next_unique_enemy_id = 0

# Opening textbox
var intro_shown = false

# Updating player hp
var player_max_hp: int = 100
var player_hp: int = 100

# Track Enemy HP
var enemy_current_hp = {} # Stores current HP for each enemy_id

var collected_items = {} # item_id -> true if collected
var next_unique_item_id = 0

var apple_trees = {} # tree_id -> respawn_time
var next_unique_tree_id = 0

func get_next_enemy_id() -> String:
	next_unique_enemy_id += 1
	return str(next_unique_enemy_id)

func get_next_item_id() -> String:
	next_unique_item_id += 1
	return str(next_unique_item_id)

func get_next_tree_id() -> String:
	next_unique_tree_id += 1
	return str(next_unique_tree_id)
