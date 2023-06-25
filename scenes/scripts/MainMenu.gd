class_name MainMenu extends Control

export (PackedScene) onready  var level_selector
export (PackedScene) onready  var load_save
onready var option_button = $WindowDialog/OptionButton

func _ready():
	if(Singleton.mute == false):
		$AudioStreamPlayer.play()
	select_resolution()
	LoadSave.load_trie()

func select_resolution():
	var screen_size = OS.get_window_size()
	match(screen_size):
		Vector2(800,600):
			option_button.select(0)
		Vector2(1024,768):
			option_button.select(1)
		Vector2(1280,720):
			option_button.select(2)
		_:
			if(OS.is_window_fullscreen()):
				option_button.select(2)

func _load_pressed():
	get_tree().change_scene_to(level_selector)


func exit_pressed():
	$ConfirmationDialog.set_visible(true)



func _on_ConfirmationDialog_confirmed():
	get_tree().quit()


func _on_Options_pressed():
	$WindowDialog.set_visible(true)	


func _on_CheckBox_pressed():
	$AudioStreamPlayer.playing = !$AudioStreamPlayer.playing
	Singleton.set_mute(!Singleton.mute)


func _on_OptionButton_item_selected(index):
	var size = Vector2(800,600)
	var fullscreen = false
	match(index):
		0:
			size = Vector2(800,600)
		1:
			size = Vector2(1024,768)
		2:
			size = Vector2(1280,720)
	if(size == Vector2(1280,720)):
		fullscreen = true
	else:
		fullscreen = false
	OS.set_window_position(Vector2.ZERO)
	OS.set_window_fullscreen(fullscreen)
	OS.set_window_size(size)


func _on_LoadSources_pressed():
	get_tree().change_scene_to(load_save)
