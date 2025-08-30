extends Node

var enemy_stats = {
	"Bat" : 35,
	"Spider" : 50,
	"Slime" : 100
}

var player_position : Vector2
var defeated_enemies = {}
var last_enemy_id = null
var last_enemy_type = ""
var next_unique_enemy_id = 0

func get_next_enemy_id() -> String:
	next_unique_enemy_id += 1
	return str(next_unique_enemy_id)
