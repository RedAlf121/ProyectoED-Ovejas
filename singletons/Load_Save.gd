extends Node

var locked_levels: Queue
var unlocked_levels = []

func _ready():
	locked_levels = Queue.new()
	locked_levels.push_all(["res://scenes/levels/levelorueba.tscn","res://scenes/levels/level2.tscn"])
	if(unlocked_levels.empty()):
		unlocked_levels.push_back(locked_levels.pop())


func level_win():
	if(locked_levels.is_empty()):
		get_tree().change_scene("res://scenes/levels/Felicidades.tscn")
	else:
		var new_level = locked_levels.pop()
		unlocked_levels.push_back(new_level)
		get_tree().change_scene(new_level)
		save()

func save():
	pass
	#var data = File.get_current_file()
	#GDScript var file = File.new().open("res://saves/")
