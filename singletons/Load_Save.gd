extends Node

const LOCKED = '0'
const UNLOCKED = '1'
onready var saves_directory = "user://"
onready var levels_directory = "res://scenes/levels/"
onready var locked_levels = Queue.new()
onready var unlocked_levels = []
onready var trie = Trie.new()
var data
var actual_source
func _ready():
	load_lockedLevels()
	if(unlocked_levels.empty()):
		unlocked_levels.push_back(locked_levels.pop())
	data = {LOCKED : get_locked_levels(), UNLOCKED : unlocked_levels}

func load_lockedLevels():
	var directory = Directory.new() 
	if(directory.open(levels_directory) == OK):
		directory.list_dir_begin(true,true)
		var file = directory.get_next()
		while(file != ""):
			if(!directory.current_is_dir()):
				if(file.get_extension() == "tscn"):
					locked_levels.push(levels_directory+file)
			file = directory.get_next()
		directory.list_dir_end()

func level_win(level):
	var new_level = find_next_level(level)
	if(locked_levels.is_empty() and new_level == null):
		get_tree().change_scene("res://scenes/Felicidades.tscn")
	else:
		get_tree().change_scene(new_level)
	save_game()

func find_next_level(level):
	var found = false
	var i = -1
	var current_level
	while(i*-1 <= unlocked_levels.size() and !found):
		current_level = unlocked_levels[i]
		if(current_level == level):
			if(i == -1 and !locked_levels.is_empty()):
				current_level = locked_levels.pop()
				data[LOCKED].pop_front()
				unlocked_levels.push_back(current_level)
			else:
				if(i == -1):
					current_level = null
				else:
					current_level = unlocked_levels[i+1]
			found = true
		else:
			i-=1
	return current_level

func load_trie():
	var directory = Directory.new() 
	if(directory.open(saves_directory) == OK):
		directory.list_dir_begin(true,true)
		var file = directory.get_next()
		while(file != ""):
			if(!directory.current_is_dir()):
				if(file.get_extension() == "save"):
					var file_name = file.get_basename()
					trie.add_word(file_name)
			file = directory.get_next()
		directory.list_dir_end()

func save_game():
	var save_file = File.new()
	save_file.open(saves_directory+actual_source+".save",File.WRITE_READ)
	data[LOCKED] = get_locked_levels()
	save_file.store_line(to_json(data))
	
	save_file.close()

func load_game():
	var load_file = File.new()
	if(load_file.file_exists(saves_directory+actual_source+".save")):
		load_file.open(saves_directory+actual_source+".save",File.READ)
		data = parse_json(load_file.get_line())
		locked_levels.clear()
		locked_levels.push_all(data[LOCKED])
		unlocked_levels = data[UNLOCKED]

func get_locked_levels():
	var array = []
	var i = 0
	while(i < locked_levels.size()):
		array.append(locked_levels.front())
		locked_levels.push(locked_levels.pop())
		i+=1
	return array

func restart_values():
	_ready()

func delete_saves(save):
	var string = saves_directory+save+".save"
	var delete_file = Directory.new()
	if(delete_file.file_exists(string)):
		trie.delete_word(save)
		delete_file.remove(string)
