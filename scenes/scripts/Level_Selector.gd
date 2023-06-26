class_name LevelSelector extends Control


export(String, FILE) var main_menu
onready var hello = $Label2


func _ready():
	hello.text = hello.text+LoadSave.actual_source
	if(Singleton.mute == false):
		$AudioStreamPlayer.play()
	var container = find_container()
	var size = container.get_child_count()
	var level_list = LoadSave.unlocked_levels
	var i = 0
	while(i < size and i < level_list.size()):
		var node = container.get_child(i)
		node.level = level_list[i]
		node.check_lock()
		node.connect("load_level",self,"level_load")
		i+=1
func find_container():
	return get_node("Container")

func _on_level_selector_pressed():
	get_tree().change_scene(main_menu)


func level_load(level):
	get_tree().change_scene(level)
