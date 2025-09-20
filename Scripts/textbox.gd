extends Control

signal text_finished

@export_file("*.json") var t_file

var textbox = []
var current_text_id = 0
var t_active = false

func _ready():
	start()

func start():
	if t_active:
		return
	t_active = true
	textbox = load_text()
	current_text_id = -1
	next_script()

func load_text():
	var file = FileAccess.open("res://Dialogue/opening_text.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func _input(event):
	if !t_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()

func next_script():
	current_text_id += 1
	if current_text_id >= len(textbox):
		t_active = false
		$NinePatchRect.visible = false
		emit_signal("text_finished")
		return
	
	$NinePatchRect/Text.text = textbox[current_text_id]['text']
