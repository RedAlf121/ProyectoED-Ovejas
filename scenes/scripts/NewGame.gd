extends Node2D

export(String, FILE) var main_menu
onready var text_edit = $Control/TextEdit
export (PackedScene) onready  var level_selector
onready var accept = $Control/Accept

func _on_Button_pressed():
	get_tree().change_scene(main_menu)

func _ready():
	$Control.set_process_input(true)
	text_edit.grab_focus()

func _on_Accept_pressed():
	if(text_edit.text != ""):
		LoadSave.actual_source = text_edit.text
		LoadSave.restart_values()
		LoadSave.save_game()
		get_tree().change_scene_to(level_selector)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		accept.emit_signal("pressed")
		
