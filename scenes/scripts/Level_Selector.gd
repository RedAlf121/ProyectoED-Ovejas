class_name LevelSelector extends Control


export(String, FILE) var main_menu
export (String, FILE) var test_level

func _ready():
	if(Singleton.mute == false):
		$AudioStreamPlayer.play()


func _on_level_selector_pressed():
	get_tree().change_scene(main_menu)


func test_level_load():
	get_tree().change_scene(test_level)
